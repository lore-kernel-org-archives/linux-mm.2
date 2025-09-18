Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA611CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8928E00F5; Thu, 18 Sep 2025 07:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58AF8E0093; Thu, 18 Sep 2025 07:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B211B8E00F5; Thu, 18 Sep 2025 07:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B23D8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:31:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 643CA562D8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:31:19 +0000 (UTC)
X-FDA: 83902155078.03.B6F907F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0551EA000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:31:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SNSiKuty;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758195077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QrWGYEi6HNQJXQ3RqQmXqq47wX836SHGBRKvJVdoC0E=;
	b=K0qvzrQ/o9rbg59cU9FqG0K361omsViSG81sNpSf+Ac+O50UrwGdi/FHvUS6o5tp6+ETGn
	VGSfIX8Jn2yYryZkyJItC02HXGkYyghtkJJqAq8sOj3M+7Yjm7HlxOkzwQ7iC676w5O4dR
	lLReMoRsjFFB34LHR7KzNIvZBQf3bo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758195077; a=rsa-sha256;
	cv=none;
	b=LHCaZgCCaIidmXEos737dGZKrbspXCAoGN5/8S9RWtgsBdsXQ5sZnzgcEuki9ZVlTEoKL5
	YlvqaDsb6OCXlclKeX7Esn0nBjqIxhC08jrMzIzYdv0XKwWV6Zvv62OqTq7nOhEJTmsJMX
	AjqDGT+RcFlRsJ0XIy0wnkb3KVbRN0g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SNSiKuty;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758195076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QrWGYEi6HNQJXQ3RqQmXqq47wX836SHGBRKvJVdoC0E=;
	b=SNSiKutyLcyIJkYAk2sH7vCDcjCiZSBP/laSSYhTwJtyoPlK6u1Xl5YkEdJedos5fqQDro
	GerW4okX9G7w/WlLBnY0AQMCH8qyBzbjgBNPulTv9kcwiQoy/M0+xpbd1NOYyOy3ZrY77Y
	cRVUH8Z+QLcqr3KBmPmxdDJQFUjh8VQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-dGaNXgckPhG3b2eC1gB8Tg-1; Thu, 18 Sep 2025 07:31:13 -0400
X-MC-Unique: dGaNXgckPhG3b2eC1gB8Tg-1
X-Mimecast-MFC-AGG-ID: dGaNXgckPhG3b2eC1gB8Tg_1758195072
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45f2f15003aso5372385e9.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758195072; x=1758799872;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QrWGYEi6HNQJXQ3RqQmXqq47wX836SHGBRKvJVdoC0E=;
        b=eSunh1vhgGibS4SNt2MdzIn5gZGjPvrL10cx+vfygPdZrBcnZUVulk7ijD/ol9DqfA
         ZDZ7iiv4jyAnR+taXpxYVckSK2sSuG7ix6BVQewMc8XZGlomZncRAl7IIqiV37FmNWe1
         AhantKRhO4y/j3zA7v5U624a9pFTKRDFYV56TqEUQJQX3vjehmxUCIkW5OQT1aOz6CAF
         4l2sAeAs3fDZhFb5lEAzyAG8Si+SvVk+eDdcX1DbqatMsZ2FWRTqNnbBwouyyrmP1y+q
         ePgK0iHgyj+3D/h3RA4oIQl/itulFuO6RyIQJD55otpo4edjra0QH88M52gvH8nXlbVE
         BH8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUn6hEleRaLh6ICByRB37p/CJxs8p3ytzLsicSPKbpN5K/ZMwznwAs9+oBawTzohEQEcX6JM44j1g==@kvack.org
X-Gm-Message-State: AOJu0YxDh+kgSg/gLVIrZuh6i2VfndBPzhnZxgWn7LWoVj/SWVJ6aqW1
	QcqnhgI4dM0MaTR1pSoHyEStN7olL1NYDl3SfUA9QzqquoL9uwsZDJH5HKP+FRdPBewMcPo3rAz
	vKWjdaVZBntvg049wOzRUswMdhTSXq/pboW9AKXE2IAC3/TknXUvU
X-Gm-Gg: ASbGnctCn95ORTKtm6ZGq4gMlHSzuv567m3fHN2oi4l5pOa51y3e+9OVx9S5i1ruvdP
	oC9O8RWOxSiUMkJezI7FVTrlUpB05lscUeS/8/DvrH+7NFDeq84U8zOGNU+2BrRQGdjhyInxfnT
	0yYQMTlVxaV8UbD20zanisrf8mZpD9fmtq4i4km/j+/4xOiPzhPxFtzgZ1SkeJwj4u9TD7k4YXt
	w+n/887IK0jzAaLbyyK0yY0Fm9sxkXjzSpdhInRxiLiLhp+2sCGjMkLTEzEF2CyzjiaLpnX3hSy
	Byr28Ldr0aHPwrq859APTOdOFXvAOelZvuo9huIQBuB0XPByt9U/BjPSoBleHEBbiCXMsM1aKHf
	+9qc7+/XIsJeXs/is64ea7WL0W9uxdHdP6HtfJKAbv5ZWY6NwuSlZDo6EsxBxq/mHy7+N
X-Received: by 2002:a05:600c:498a:b0:45d:dbf4:8892 with SMTP id 5b1f17b1804b1-462fbf7233dmr32682355e9.11.1758195071876;
        Thu, 18 Sep 2025 04:31:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVZFogblmOGSGPq9jZ3wZFd4gwhxXtANAFQfp9OyD+5QNnMjVHGSC9FytvkSxqiM/KZmtIow==
X-Received: by 2002:a05:600c:498a:b0:45d:dbf4:8892 with SMTP id 5b1f17b1804b1-462fbf7233dmr32682145e9.11.1758195071503;
        Thu, 18 Sep 2025 04:31:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fc00a92sm3283894f8f.63.2025.09.18.04.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 04:31:11 -0700 (PDT)
Message-ID: <ea9a78a2-6044-4720-8dc1-33d9e255cb2b@redhat.com>
Date: Thu, 18 Sep 2025 13:31:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
To: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918112157.410172-3-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JdxGvXilIRDFARTuoS__LsikFq6q1_N7DG4evr3vkao_1758195072
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uncntaggxpqq51kidppf959ef6yctax6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0551EA000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758195076-371859
X-HE-Meta: U2FsdGVkX19YpnLetLkMycF65fER0k1xNHqWnafflVHfscwZ3MIqGvz8MetMEF1UT9OwdxqyEbBdyrRpT9cRa2DoeF+JdsW8w2pDW7tMKR7ZEAs9X+1f/h9qPgIYMvB56paSBY4hUb8zHxrZcJaJm8p2ITdUMNd4DoweVF+p/5t6ez5iXXNmTetCuTeeCjLbVqw2lKqa28yzgFbEYnLmlkz3I0xAi6SUf8cWu/rQRJW4aspymHcm1D+pur7diXoIilC7zAlNCoejbJikzH9UP0+cZty84pGfwq99cU3SI1FsIBnvqTQVObOyiZZLcMUr/XYRZQPeALerAY2BT333c6lbGlXVxdsuJWlCmoCkbfwWEVa4PW8aoSYwGmn5Izkymcg4f46eRSPp2NbdrfejvISYNPJVBXI3EyldzN0hwLKvQXxHtFevGs8vVtKMHPGuN85YjL00tnfVBv3HyTEKUKotDAL/uZ8e4+sY39lreAPt1MKieQdnHCLoFDIO/LT+n6tZaOhHomab+UPA7+LG084OvGD1VoWcm/Yar45nLfA7GlsDmIyyGgncfm7rdunKWtQ9GqjI5qEMndhh/hIB4AMUyDnqxyZuODi6szNQvixykpJmF3Utn2Xx9gxPprcOBDQm2prXLt57Bc+MaGa7SRPdobdZ4+9OjnCVX9dcaV5ydoSh6pTtHIAqL3L/ScpCsxFkF2PQJeQaAw0j5nHuaCQ7vzQXKQ1gNyUi41d8J2cZKbalg18vwSt9zKsEX59fo64xs11MDRw7CS0MTJV2LQijuQIJcjjXqTrdNvqDjc2cKaJc/LsWbFL8JjM3CV+zw7LIt9+7AolSpV1A87BynF5ma7kurNjCD3+9GZ0zOmdnGtcw41rvu0afiCzNdd7EQr8eZTTBSZ2kKzTCt/5vUuMgQd4A30uMcNUOruU8SmF8TZ5hRASUTwirfPHuxg2FxOJHEkhoAP857Hj4OwV
 gunqmwof
 Fcl9QZW2xcodw1tNkXPugKWH0AJ63aAyGoJJhiHJrNx5mxmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 13:21, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The kernel currently does not mlock large folios when adding them to
> rmap, stating that it is difficult to confirm that the folio is fully
> mapped and safe to mlock it. However, nowadays the caller passes a
> number of pages of the folio that are getting mapped, making it easy to
> check if the entire folio is mapped to the VMA.
> 
> mlock the folio on rmap if it is fully mapped to the VMA.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


