Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F06CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83FB08E0023; Mon, 20 Oct 2025 10:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0F58E0002; Mon, 20 Oct 2025 10:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF788E0023; Mon, 20 Oct 2025 10:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5698E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:18:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A0B568B6
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:18:51 +0000 (UTC)
X-FDA: 84018698862.15.727477F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A649EC0010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:18:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OvxITGck;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6K80TH6o4U4go35LNrjweRUjIOhhQ0EB2jV6/Z5Cds=;
	b=ISLpmK2FtGRTomg8UMk7m+GVn7DwvWitjXSxRjVlYGOpVHShLiYRBVzPSn4nze5OfiX8Pz
	mKmA98Pe+fUnYXvMC6Cveyt0u2q/OmwDccbkurANdTw0HpXAXZQb1Y72qfe1DTtqyBTFj3
	Bitnf62CvVP7shIJ2v/IPbOOvTFUdcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969929; a=rsa-sha256;
	cv=none;
	b=Mj0KnKI02zF5n3iE8rATDqTkgFUIUls/vwecBdF3GwCEKNoQCfWdJszNCdH8aif5othFOb
	dTIfu5eW6wEXzES0nRCjX/HlBQ5xb5OKgEIK/K3gMXUJSkH99sMpG1H3f8gU2xvdoKh5+T
	HtIneO2GAOj+q0B8aTbMHghIu8jV/B0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OvxITGck;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=s6K80TH6o4U4go35LNrjweRUjIOhhQ0EB2jV6/Z5Cds=;
	b=OvxITGckefXoPiDacT40WrHsLEFA75LRKkR2L9M5XGLc7DoW31MN+CaIkhD9CV8z/r+2PD
	10b10o9iJkh1/koxV5r7dbsJLa3LhABdwK05YxONXj3KcFTkuU3BlLykciAxCJpSSqTXkc
	+M6OKjiv9YMruuoRk7uzQPF32m9uhYs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-5rKsp7GeM1Wchsdwtfz-5g-1; Mon, 20 Oct 2025 10:18:47 -0400
X-MC-Unique: 5rKsp7GeM1Wchsdwtfz-5g-1
X-Mimecast-MFC-AGG-ID: 5rKsp7GeM1Wchsdwtfz-5g_1760969926
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471001b980eso27323035e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969926; x=1761574726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6K80TH6o4U4go35LNrjweRUjIOhhQ0EB2jV6/Z5Cds=;
        b=JOfJkrLvXkF3WhGh4PYjRVs7IOnDIikfbl+CaEodlJryC8vsOnzTr5UokKc+L6kJvo
         lUMv6/ErB530Ee0lg3uz/4IXLYdoOwgwyvsV0k+SKfunz3YDtkgaP2EsmDWTPGqPvGDB
         +zA3JKucp4cjmeKAmRXwxZfZMoIbBDBEEV1HkhpGlGKcXlTcW9cvl9Zv+S4dfay+i9GA
         xpZzyvAe0KAMlbcucesPde6d6dvLcEG0lrwBrLm1LVjD39dUPBlTfntuyz9Lk5140rU5
         /n+UaeRbLlD6GetNlf/cwsRXleKq5klGmp2iCMhx8aSBOFx6nnN6vdtA+7X6WUN31k4E
         6icQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaBCDN+C4uZVimeaPQpx09z5kDfZqB3i08sL+Jm17YEj/RQD3s5HEwzcPxdWhFd8HNAGgiCGFvvg==@kvack.org
X-Gm-Message-State: AOJu0YyW1Fd+uB1CHJiGVUNvp5xqX1uB+VmoNDQA9rjJBBIj//VjPilT
	wUkjTmBwypupvJLbjjMc94XX+jucSzSEFUid3s5QVhfItC8McHbMS0vkjvf8xbppuCmCbpS8IL4
	WuH5xjWNQfV9Ckal2EHA5MVHYPXyub4Wn2MGGsSfA2SwyvajIkKpz
X-Gm-Gg: ASbGnctNltuc48WCPk1ZWVmlOpxdVLROB9kVuzHxpL0PS6rW2eTlsAhBkXbz2ZfTMNi
	nrgtcvjuGXjQL/6gqIGR3S4x/KHDOXWl+EJ3JmEZAQuQrcPRTfgSqWwtFEDwulCXDyP+s3DdZfV
	LEL+OeIOHt54Vc+/rX5QLJXzM0Svz02rWJ75sz7lzazaEhGGp1aGCR/l4ZDTy2KtsZV/xjlB6+r
	DcrG0dojVZir3H503FWI2o+1NDRuHeY1KyYsPQBMk0FwijatlpKngDjVymzeGINixl16FjxymN8
	lkF141q/yiT1yo1Hzv8P8b6PQgxbiSWEPhf6FtfJctBRpsle51c21SjttCH0avNPao1aRgmtvgx
	wviXVq4bXmK4exUbUIRDnUSbAy8V7BxMGZqXJ53I2Gq6BuDu0hOauBYL3ZISxXP3yXxsVDEJ/2K
	JoyEFq4mlsmt15xeMfd8yYvd9FVyA=
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-471179122aamr102607555e9.25.1760969925865;
        Mon, 20 Oct 2025 07:18:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG198e3YWwet8QDeIjkn0yzH0vQyP2TPEMlDh54DecRr+N6MrGFB4PSpZB472QMbwXTyzJoWQ==
X-Received: by 2002:a05:600c:34d0:b0:471:114e:5894 with SMTP id 5b1f17b1804b1-471179122aamr102607225e9.25.1760969925409;
        Mon, 20 Oct 2025 07:18:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442dbaesm234245435e9.8.2025.10.20.07.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:18:44 -0700 (PDT)
Message-ID: <ddd6f2a0-4855-40b1-9e08-8156fa9500b7@redhat.com>
Date: Mon, 20 Oct 2025 16:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm/shmem: Support vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <20251014231501.2301398-3-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014231501.2301398-3-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t4xvU0PoUY740VPEzuKoiwZBfY4LmwZV4cSmezUaUVw_1760969926
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A649EC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: 4fsusyzwh7rzub4q7nu6bzncnxii1nck
X-HE-Tag: 1760969929-961247
X-HE-Meta: U2FsdGVkX1/UfhzEdU6U8Y4gqZ7gjtsFKVIQq8W9dAEyajkMOTLQVkJO67sw0K/WVuqJ2kDbhol+56lRy0UtGlKPAsev9bGuBGRbzqSUGkd11W4SDhJ+MqJCySYSp0hxbdY8i3XJukutedUv8Rya1bSxSxsmEfRVArDgRns2huLocxJRl1bJg49xfhXYb0NVb+7bU5+NNa0dncrOKaFwkfJ1e/vzFojzPj1+ihIXOMHPl+PUo0KC/h/z5TY+yvWYxRQN9p1nLTotDIKMN42BMDl6OS9xxcZE7Dr3UcXJijDkj2P+2e3PtyEprNqkpFuT7f8fCoLN/0o8+/dXeu4aQyFedVTF9W0/0KAlq4VfJdAWj8FZ4TDoxNlRPlPA8RsfLY9/diZziAXjV/StLb55vUf+pvdMPqVnD1LK4w6TbALvan2GxvbMk0Vnzg7VNXlAPvJ9fjfauT/F0ae+oCqEhcxe+k24uHbwj0hRfyVQ18HGIo+Mrjjz00gUS4lfapGL891v75vb1yhSK93hXHykQQ2iVXVTi5ujlvmPhIN2NJcjbM37B7qZLhu75BfyWOvoJWWFww4g0P1X0LUM4GEaFCOeoSESn7EgXc0Eh4UGIgUah3dj5QfHL7uyDj3eMr9dmGxZdr3pn33OIprRfb0Hq7usTb5ndyU/ZMig1+Y3VgjLKPRgxfYtf5V0jOIjFRS9kFUxLcHJOeoz+O8SLAYxRU9RGBygqnfIHGZhjNtPTkFfEOTQN7CvScJGa2C8d+rmlWU+KdpkLpXMKS6G33b8xSd5/16lva6uerHgoavW3uSR0j/BNjplZLApYfvTtPbmqbxQu9C1mkzGwtv5w/h/d61oTQJ9SWMCavPewaihK6/Vr56yZN5oVjohtA8eeDTU+wIfoSEkFCRjxsz+6tI1Q5dX4OhSP9mtGlTybmQNoicCCAG9JvSYxiEETwZ+DpgMIQOaNKEan7f18r5Bn2v
 GPgzDGd6
 mz1fVx5ukcHigSHyvBSxZGZtwZtryQfENmqCfKXPlh31t3IgQvq5t7wRNQ00OvD3Jh32c9tWhBqaKiE9IAx5mWqj6LZLZg9VA0Dan7RpDKA6m5gwY7ElO2cVneqtWlmPqRRnNxu4QVU03YRkWg+Pow95zStJ+yekdKEG+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 01:14, Peter Xu wrote:
> Add support for the new vm_uffd_ops API for shmem.  Note that this only
> introduces the support, the API is not yet used by core mm.
> 
> It only needs a separate minor_get_folio() definition but that's oneliner.
> 
> Due to the limitation of the current vm_uffd_ops on MISSING mode support,
> the shmem UFFDIO_COPY/ZEROPAGE process are still hard-coded in mm/.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Acked-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


