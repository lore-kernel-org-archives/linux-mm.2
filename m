Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2202CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 16:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3406B8E0005; Mon, 22 Sep 2025 12:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317968E0001; Mon, 22 Sep 2025 12:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206588E0005; Mon, 22 Sep 2025 12:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A68D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:34:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABCA8C06E7
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:34:09 +0000 (UTC)
X-FDA: 83917433418.21.871E609
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7903BA000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:34:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WUUETWtQ;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758558847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBJljojDbws+qHKYWMWrH6AZIQ6pnwW8hsnZj31y4NQ=;
	b=2QzWVzVBuYDiL+8xbB7PvgtLYMTDvmjciBppSFv6RQrWaUboht5jMSCpuvAm49MIG2fgHp
	TVoCS+huIuFXCpFR3jILPT20PKo+rOa+QYmSDDw93fUlJNPBfTcHVq46LgVtc499TJwF08
	kL2tunSWGz4M1Z/gP6ghoSLrWQBJAFg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WUUETWtQ;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758558847; a=rsa-sha256;
	cv=none;
	b=qUduyimFcv14UirNgFj9s2zCkpm5KXQDAV/B9wPiGsxMPiZg4KJvdidetA2oH/nbqKPLyx
	CAVOpryvb/Iua9JOLxFAbf1ngcmY/aDmwfHbiOGdKdd0AQ4V7/goVRzj0fFSps1h4X32kz
	F2fpeNKyiys+U93b3WqWflqC9f/QhEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758558846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gBJljojDbws+qHKYWMWrH6AZIQ6pnwW8hsnZj31y4NQ=;
	b=WUUETWtQLYO5jMZMLsueV3HEcGB1rv5uw8yWRdhuuvwb3F1gIrWvn6xXb036Ztlm4/OGzw
	++hWZ5SehzJsbx6E8lTZy49vCWlS/2XisY57Q40BZN+EZ6Kz8YPG+d+wIYMc697B8qcDgE
	1MBezF+Tn3ts6i+ZGyrv7EwE2fwPS7Q=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-LH8enQU4M2CAGRt_hXvD3Q-1; Mon, 22 Sep 2025 12:34:00 -0400
X-MC-Unique: LH8enQU4M2CAGRt_hXvD3Q-1
X-Mimecast-MFC-AGG-ID: LH8enQU4M2CAGRt_hXvD3Q_1758558839
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b5ecf597acso111195321cf.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758558839; x=1759163639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBJljojDbws+qHKYWMWrH6AZIQ6pnwW8hsnZj31y4NQ=;
        b=XJHZ6WZITyd8JVfpqusqinhVQNfvf+u5vRcjWNTci5coBWVO/fb2ZCW7zsyWOWfB8B
         NmoRbWCEhu6aEvjjBhVkWOEGSkWsqPwfK7BT8oPmc8y++TQ2S514N7a4qP2DQBesYZcY
         dxirQxOgXi34mCej7pfCFWwwgG/UFTcLFlUOZYW3BW3pIPyRlvjI46gliffgfdIYJlOV
         KJVCEq0XHhffyyz2vKK/5+I2vSy04flmjV1E5dq1uyyYLuWyg/GWmQRFmDR8VPBw3Qqd
         aSAyMeo/6nG6vON1F3ipPKjyQTwc/8uB2dkzgoXaeQ+Qzq8bQyAmIJeBRT64YJb8bfbi
         lEPg==
X-Forwarded-Encrypted: i=1; AJvYcCWPVWSrP0uBjuiZGA1vG5l+FtkJR8MdaiReL37OV5TmRrlTeSKfgzmBYuXuNUqMriD77+8TGRC3Aw==@kvack.org
X-Gm-Message-State: AOJu0YxT1PgTtWdB8S7/mPBgwGQ8wpua0MUdjxZJu2oB5zABTta5Sg/M
	k/IwsOyF52KmKs+Aa0HrD1AITeRyAf+j+xyppMX47Ni1XZlh82U9VWkkz7EnIpvhXpAj7NLk5C1
	sxwupTSt8S5okJRHdYsEP1lxxSFT0UtssJ8eHF0oYlr0yqEUpk9My
X-Gm-Gg: ASbGnctes+EHrs3JysE5959h+U6pWMECM73dW+Q/8SasxGoQo1518Qvk7zDqogEAAEL
	p8WkZdKGANIGMhgA5UJLsYHB4SODR5ccGr/0rwsU8qtYQgc5J8QF7WBOO5Kr0WeY/gUPB9mNcqd
	e3fGBMF9Ogncb7JuYN92NJeK2zoRXlM/YvR5Czzcuxm2Ra54NvZS8BlEt5L9JvZtwUAv0rIJH/S
	JhutT5eKG1BE2JBjrWkO/NyE5YxiXkcwvSUSbH8aktdqWzINqFJAAOan4mddP8R+2s6m4wXJACZ
	+xExw/DM4YchtW38HfGHfm1sItgCam+a
X-Received: by 2002:a05:622a:5908:b0:4b5:db9f:9904 with SMTP id d75a77b69052e-4c06e01de1bmr199682461cf.22.1758558839455;
        Mon, 22 Sep 2025 09:33:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH//E8b4gnkiEJqOP3wljjECSy+ua/1PyrN9UKJVnDq/W9qkrGv0rnACb5iI8z2zg8fwH1I7A==
X-Received: by 2002:a05:622a:5908:b0:4b5:db9f:9904 with SMTP id d75a77b69052e-4c06e01de1bmr199681851cf.22.1758558838967;
        Mon, 22 Sep 2025 09:33:58 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ccade1cf34sm15909061cf.46.2025.09.22.09.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:33:58 -0700 (PDT)
Date: Mon, 22 Sep 2025 12:33:56 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNF6dCL_yonTforG@x1.local>
References: <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
 <aMx0oGwRpSTcfdnf@x1.local>
 <swfs7qpgrezamnijhheiggwdfklfqdc6ahp5g7nvprr64m7wz5@msf2mqajzbuz>
 <aM1l2YMmvBgiXJ8a@x1.local>
 <unvooxce622bchlsivyr63lsvywnx4u6omyndotdo32ynv2eki@ju5srmktf3hg>
MIME-Version: 1.0
In-Reply-To: <unvooxce622bchlsivyr63lsvywnx4u6omyndotdo32ynv2eki@ju5srmktf3hg>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N9t28C9d0jbzuKaRPasEAxs8x8LInFfYpOY_JUb_Imc_1758558839
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7903BA000F
X-Stat-Signature: 9piaw8rqjhexggso7adg3soyiygkft55
X-HE-Tag: 1758558847-994819
X-HE-Meta: U2FsdGVkX1+Fq7kjp5kuearFQmYR20zJFKkLo0L8HfCf+8qtvNPBNOf0WoHUWMGGPEnHFmS+z+vK2TdUwD3dEyPMWWtTrY4vkSRQigF251DyuwLYXJqCnCFZBswyFW+SIBq2a2XZOzlCuQzCfgrgeClCOiwrNvdEFjqgX5yidoFhRBd0Vbe2cexnhAdB3UlGFacSqdkBdohpYCMZH8KD2lBNUZuO1eX4xIUde8m/yJxtA0/RvUNQWJlKIWzJ9LeH4/8yKEvX4rH+ZlEgR6N1qJ6PBTHPlx4gUxxlMQRnpqyzzH/aa4JsbvJpKtH/eXwPBpFcS3AB6wCnAOQlixQB419xOoZv+iYP09ZX5bdzuUvrmpj7hgwGm5ZMzF87vpqDCh6ZZDZowmXnxVgr+DtwEK/7f4ixp08y6akMudUoJAFbsvy8y5COvkn9x4NYCyHC9znwCuCUSRaJyft3suon9Id1XLwgYlFtJ1vQ4+aZeril4TdekfBZ1shTmf4ca5kDUCX3rGru0P7g3CNCg9hp1+pqwmqrtNJP6mpQjO17DENZqTkt7IzAVbatQiValQqjT6zZQii53acu7pwrVAw1m0LsjaBb5Hc/kThN1GsLIGFhhy7+ywpX3E9Hjs4Nh9r6WYs9vz8nIp1zTN6oUeXlORM7+6VObzhgdjS8fi1QFunwFBL1ddeBjRViu2/UnML6vFWHz+hrM0fKSGXaWwT4ZLaCa0Shc9MvSApTrB880OoZd2EAP8BSVE/n/YYUxJhbAhf1wWVER07MojSeluszEkhk7T51x1HEkAuPF9jQhj6iBLmsxKo7y+41jFHbt7M37eWMYYnL9qVG/x84omVJy5r2Qg6te8i/8q7UsEVduXFCXqubgRwPB6rfHG/cPV8R7nz7yqvLu3gCenMHekqPCEB07iQgY6xsztzBYOel0OvuSZejA18j3nkFUsIgfGhmZAS/+F2GV6Ate6P8CGg
 77czKUy+
 KvqLSLq2kFQAkfttUQGssUqf3qEYVQsId8DfKuZ3Hbm1+vBJ1Yoi4gTw+CqBMZAlmUgIFUo/oDhO2yTKIa6gsuF33cvRE96a2DLATE4FMQlBPrjh3DkPlCsYJTOTAYINecN88/AEKK46wqeZ+Izd8MtXCrq/IP1Pm3tlHuXGU6bzamMv4+TyAptc7XO6g7D7TaQd263cCqacZWlcPhxTKi5KDgGgDI25kP6/1Dc6v79pDj65yTdf5XXaS/YVh4KV5ZHcPHHeM4DMU0/SXlDtuicqYVyNsoJk0VDQUsJohGei1VXw/72qT1DwToapZqLscxiW126J/wNtxUMwkXMTYaZHzm95wZ1TIoUIXQndxboSzg6vJsuG3eebBcMHkj6zMOUFTcccycsS6BRdPFCdD3poXn6EQjQYcZ3jnupss9vNcI8a/70dNDxOoO1EWtRMM4Os6XjMQq0YPogK3xqeznU8u4bnOAIu4f3xpPQQDTeBuGal54QRMcxEXwYJ2O6Q1VZH1nkcK1Bqm5XCHgOYaB6Y+1c5E4HwMJbNW2FmjLf2EBBErfk/KW0Cq2uY/c30dQnb7sXWrr62hsoGEBekhJoOV5D5N9BG/3NKA2WM90PoTcGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 03:38:51PM -0400, Liam R. Howlett wrote:
> I spoke to Mike on this and I understand what I was missing.  I'm fine
> with the folio part as you have it.
> 
> Apologies for holding this up and the added stress on your side.

Thank you for changing your mind.

Mike, I definitely appreciate your help alone the way since the start.

I'll wait for 2-3 more days to see whether there's any further objections
from anyone, or I'll repost.

-- 
Peter Xu


