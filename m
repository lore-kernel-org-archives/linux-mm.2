Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C54CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F42C8E001A; Mon,  1 Sep 2025 07:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A54C8E0016; Mon,  1 Sep 2025 07:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0457B8E001A; Mon,  1 Sep 2025 07:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E63828E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:26:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45AECC07D8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:26:28 +0000 (UTC)
X-FDA: 83840453256.14.B843EC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7EB320007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:26:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TGy4bM5v;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756725985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0iUXkssVvvwl4l+6dfL0IIQ3dvJMYipttZeZiZiVu4=;
	b=Radrbr1KKwfPaoLOC3Ji95m7nA00DYRxdAPWgXpd8x4WvzWLk9X1pb7hOCgdEhjWIYuky0
	9EAJDXPsRf6tkxDguu70LJSIg0PuTVnNnuv8skWMztzT9w/Ry+d9boSNbt+m4xjoe9m18e
	VaWy90sFC+1rTpMCiO4atVOurUHSrc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756725985; a=rsa-sha256;
	cv=none;
	b=n31CSxX0q7TOyUThGXmWSKPrNsQgRJ+RtimV44NgvpFBSb+8Utt48BJlPg0uSTkv0zuoGL
	gCk6rfKE5GQ2awHJPyJ5pDFgIIJjgR+euI/QRmK8zAIX14/fSAWofWGap4ezckiU2sagi0
	bcNudMVeJKxCdXuL+2dRa3SU1uYbJDs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TGy4bM5v;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756725985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+0iUXkssVvvwl4l+6dfL0IIQ3dvJMYipttZeZiZiVu4=;
	b=TGy4bM5vutP5VtuADgZjb8UhY+YD9+pg5K/Q8x4Bd7ubGELGk/Sy2JJCDGYa+3NLqOpa99
	ADwiY59UeMTiISyYjzxf0QFmJT33VxKoDt1gzZJcQfNdiuVEodgDaFx62vtWFag6OEBkUL
	LQ4aJ8q/FTgJTrWGZtF2chD3aBR3Iyw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-7wNoL-5BNIavKpWa_k-v2g-1; Mon, 01 Sep 2025 07:26:24 -0400
X-MC-Unique: 7wNoL-5BNIavKpWa_k-v2g-1
X-Mimecast-MFC-AGG-ID: 7wNoL-5BNIavKpWa_k-v2g_1756725983
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8dde54c1so4409295e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 04:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756725983; x=1757330783;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+0iUXkssVvvwl4l+6dfL0IIQ3dvJMYipttZeZiZiVu4=;
        b=NJ6mu3FUrIdrE+6AJXygj1ZeGr0fTfoksoMsSj59V4QR7eUuvpt8IUpRBxoMZqFECg
         ps0GOxPcRyU8PRk0hjEF4WVFMcnnuzjSB72/TKJ7ymhk6jzcmUaduf4VDXrPkVQOPyyM
         1ae0r+C3/hEY2zY/VC1hFzYFbtmAhTrNhc0Jgj65vNpC0XtVST/0u0BYQraON6FrCxsw
         2UZ5fcbQqAkjWoM75REW77bmdgKrRmJQdPSmwUwLhTXeMZRsf/QWpgtXyfEwktsb2eJ1
         /GBKpgOo6aiFjmWifoPVCi5mtIlJTjYepsYJDxwDUUWexmBYL2/dCG3TOdZbY0H+um1L
         CkJA==
X-Gm-Message-State: AOJu0YzCjX9G82wdqZRMVprURSRX2ZYkmmkjIO85fzqI2KQTq9rt0NBj
	TvRM7NinGZ7hd/3A1qHZmnpmRqnEWgflWau3qp7AbNJF5dbv+uR/l6Wn96wfdp3nISAVeh2Xe0l
	SUQ60WxdvjB8f9jEQ24o2+pqUU//EyYY9ePGf4CGllCh5dBfroP97
X-Gm-Gg: ASbGnct+0G0huIZmcj5SrrSArqfdJUsnkF+uBKpyUTBn6oiCWdFUSZc5PoF9LjkXow6
	uGK50GfhHoffMoNZBi5vopz6CAKtCUQZD4vl4cJt3KN9uaShuNzHGjGUyhZtbF6Td0/5TNkaTjN
	Pvd3YSGp1D9dxittieYbQsHqZfdm/ByQ0UuH+lQJuj2WkSpHaig5IiW3ty1Tv9rRhy/0CKWgx0t
	jS12n5Td8oUIqvSECis2iqw18QDyDjgKStfvVwC+6BPnSVy7CpaksE9SmtqyupG5kAtEHT/H7+j
	ZvRWeTz0eITi5zKY5iPfkHLw2+IaSLunt+lQldZeWU5XuM15DWRLiTpmf8FWaYELzR5D7vgurpV
	2RLwOa8AA+eFCJwh9c7vZhcMGf4cy5CE4w/3a+Fysd9ujcfHA/11l+npl/Qjeaqsde/w=
X-Received: by 2002:a05:600c:35ca:b0:45b:8939:8b19 with SMTP id 5b1f17b1804b1-45b89398d7amr45472995e9.8.1756725982889;
        Mon, 01 Sep 2025 04:26:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDSGyETaSLlIJWU3uzoaaoqfMZkiytSvPl1Lt94HwmLorgIbYtX0kyMO60lbJbmccNczIMnQ==
X-Received: by 2002:a05:600c:35ca:b0:45b:8939:8b19 with SMTP id 5b1f17b1804b1-45b89398d7amr45472785e9.8.1756725982455;
        Mon, 01 Sep 2025 04:26:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm233491715e9.5.2025.09.01.04.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:26:21 -0700 (PDT)
Message-ID: <2dcf12d0-e29c-4c9b-aeac-a0b803d2c2fd@redhat.com>
Date: Mon, 1 Sep 2025 13:26:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "trix@redhat.com" <trix@redhat.com>,
 "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y34l4c1es2WQIoz-ZcvSFTwtyI7sJF4FtcmwUz_vULM_1756725983
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7EB320007
X-Stat-Signature: irh9fkxp776gb55gk7arm1pgw8jfk73d
X-Rspam-User: 
X-HE-Tag: 1756725985-718059
X-HE-Meta: U2FsdGVkX1+xICBe7FL8+DlBX4YJ+v0Pg6hKiB/R1vFqkB1jlDua3odgQX7RgikypvLO2fl3+pxIQvYsyen0he9Qom0ElaDXcoeaTCbFJBwFYDDvj87k76MySFT+a2NkymerSCsgPPV0aNPJ1DVSL/6VBTo0v+4SLuYl+1unrAB3XbRdrxfbnE6qDPdgcD/1B88PQyoBJVotu14ZMS1VhnkHgCWEsTC/6NwDJBlVrCQJxv/bzvjmp/+vuLKMju6401eBNbgr67EXn0vK/aLJRBFf8x4BpPS7YEjxXKgLEZW/D9z7qlKGIO9016Q52e3dgWO7l4LJ3kXOxzF5mfAxgRr3GMpYFauc1QomMAU1M1TzJB37pdRVyNa2JlZVgtY9FrijsqzDOx3AnWNcslmKzFvaJx43q3sNWOxs/19ldl6YUCo4KtBcs3gK8O24U+GieIikJMmi69B38fAeR4oTPY3jbqSaRq6S3eZ+bptx1vTDCpr2Gv93JJbOFQ3zGfSyodat/PuiGOYkL227jOcrf8DWh3Jhk0mcha9UvDQKsQ+lwiI/QE7kFX/eb7ngQG50U6ArgtV3SuK3HRyqbC5YChGv8MuAMRNRTqtZtmBBmKKMum7YbWG6cxO/YNch+qxjZ1RBuq7jgMdpuoUwx93rBV631kLK0EVGq9grcC9AFx7EB/e4arX5XDhZeMxnaW5p9DD9IO+xp8VqykyvHpfmKDzJWWP4zsfTMpSiCdFxQttFcf1/ordD17n4SbItHddqCJ5Z3Q3n8Jqesi9ykfVIuNjlp74R2gNv86EnA5bri+0uoRcPxMglh0KNszqgzAMaWx1XSWn9q1KAo0rwzdKWknrwA9AvWpL4poT72xDwChdRxFJUpUrR3pb/cwQhVHDOXVpnhpZ0l2X9jfOJPqZ8bYsgDZdo8pQFivpw+l/nkNdSY7wGN/YgNbbzmG9+hIPLjevJZtwMOZ4vvgT5957
 pGMpgbZU
 qa7eHMzafekilnX0+Vr7QVymupLuiflt1NmZzfhUglR9jXN+5M0iFa8kv7ceI8EqP5lna+9vx0lB1T5M8Ioj8gs7o088QWhebTK+v12ROcQJLrF9qrv0Sp5yyhdSLJAbUYcHPWDN5uniNxN4iS/E6vsLqR4b0eE8ZIuUl+fjRibz7CHR24OLhEZExSksHBvZUpVwVH9Vk1syHVFlVKxJ17phTzlB9x2jzJw2Y6HzQHE//xPEnImQHvMW2p284I03kKeIGqA0IqKE7reUu///SSl59yd9EqVCeL9sp5X4v5jGnbAMkGq60NraNZaunBA4hMg1fh14jlq/a8sC3553zgjLIow22axaNBfQV/VIS6XiJbSiemh3hb4+onJajxSR+5VonMEVhFBop4zV4xunifzFMMrpbNCl7hjGZ7hj4RO+pMyeLW9CA34/1UVQOrlkliuzdm3b5DI/jlRmoPqCrxx0PUa/SYXADgy1GERsAGBr7ymgH3UFY+O2ev3ylOfTnSOZilaT6V66nsNvNDFYOtkpVh/fqQyIk2DDR6kEOZFB6eN+2GDNYDlz3mww3gsAZS8nkPGVjGPxbicHwzCiMf5CJqTXB7NuJ94R9zhRPQWZ7gqNxlNCXtVO/IKbIFqOIZIehDupmQuEwI54v9PwuqQtxgG14WLqHvC0h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:58, Jann Horn wrote:
> Hi!
> 
> On Fri, Aug 29, 2025 at 4:30 PM Uschakow, Stanislav <suschako@amazon.de> wrote:
>> We have observed a huge latency increase using `fork()` after ingesting the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB of memory with 196 cores, we identified mmapping of 1.2TB of shared memory and forking itself dozens or hundreds of times we see a increase of execution times of a factor of 4. The reproducer is at the end of the email.
> 
> Yeah, every 1G virtual address range you unshare on unmap will do an
> extra synchronous IPI broadcast to all CPU cores, so it's not very
> surprising that doing this would be a bit slow on a machine with 196
> cores.

What is the use case for this extreme usage of fork() in that context? 
Is it just something people noticed and it's suboptimal, or is this a 
real problem for some use cases?

-- 
Cheers

David / dhildenb


