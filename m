Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FCCCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5CB8E0012; Mon, 29 Sep 2025 04:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD978E0002; Mon, 29 Sep 2025 04:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD36C8E0012; Mon, 29 Sep 2025 04:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95D2A8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:29:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54406855E1
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:29:31 +0000 (UTC)
X-FDA: 83941613742.13.4C6EC00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0FB1340005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:29:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KBTBLnc4;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759134569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hi2iNCAqNq7pguiCgEi6uYcm4+bKrtHHFufNeahe3d4=;
	b=61CtdFFtKoKeuiWyxzsSXhj1IXasG7j3XWIPXfhaHNB+GTok3WqZArZDn0ncTjUeWpqrxL
	qomA7l+3uMbgs+dNcWq0fW2dmEuaAW9zAc86bte2CT/BfXd5C5J8OE1+eK7IgEL0dlC7H6
	cOlsy2wOjuFRT36DosoPZHXrjwEySus=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KBTBLnc4;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759134569; a=rsa-sha256;
	cv=none;
	b=5AnBQL9yH5uLsBR4TrddA7UwngVFfggD8V4MbqoOeE0TNh91PIFNcyzmnCYaWOJ4igrXfd
	gr5Kww1OP1qf1fteY4LNerunfDRVTluxLBsDz55qY3OPn683ULEYqBZgrSIZTtTgImM6/R
	fxLpih0PCuAj3XEKUOxZ+pb/ntaU3+c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759134568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Hi2iNCAqNq7pguiCgEi6uYcm4+bKrtHHFufNeahe3d4=;
	b=KBTBLnc46C4fwZ5faSrJUMLQyn89JO85ebCAAS7naKf0Rsq6G+Ki/cPyCzQntS5dtoeePO
	SmouOZEvJCvRGwWn2JueN4TEJYcKS87kOm108naxfg+BAKxr8TBJsqn0LMD76EK3kpxO5p
	XSp37hsASVydrgPUxZwnZGNqQisIzUU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-Wq_NmkNdPny3v6Gb0IvWcQ-1; Mon, 29 Sep 2025 04:29:26 -0400
X-MC-Unique: Wq_NmkNdPny3v6Gb0IvWcQ-1
X-Mimecast-MFC-AGG-ID: Wq_NmkNdPny3v6Gb0IvWcQ_1759134565
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e39567579so21028865e9.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759134565; x=1759739365;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hi2iNCAqNq7pguiCgEi6uYcm4+bKrtHHFufNeahe3d4=;
        b=Tr5tj8Zwy5nTCGLtAwvJ/U8OpiVFskM+TOuam+ZsDII8qPYbR7Q7e7Ve27lCVnfTIC
         kacS/WsQ8a8mi3bN18u/k7Yky/J+sQO0D9nGMULIoDgleySS0JfbB555dp5vpr6c/eA5
         jzX2HNp274pX7gkBYkk4/rX82NlYssUPEbEpr4HFZXYr5Qhyn4KUJMiuFUQGwjiOdFhS
         nuCbqkGgKqYQZQjZvIDPbvQOcSoUBx6IjpPVOX4uHhsYBcvNRlZuAV5AK2w9NEk4fWMP
         I3kv33WP2OaTf50pEuQgb3ZMY8gbJwHtasSSP4UjGr1jP8mI3VvAQ2TtK+JwGt4drHJ7
         Hshw==
X-Gm-Message-State: AOJu0Yx0pApqFzNThlvCY3moV/4tnJwJ0neZW1DP65E9KLzkLWDMyDBq
	p7jFtv2W/G41CToyxVPX3kZWjh/TYBvFnjoMaQSlVZx7H0F5TgbPVGJH5MvNx+GMKbJ+neOK23T
	RU7kVORiMN0fdr1ulAc44LnWRJ8SrGfuZUIXx+srH5vE9zJuwbNFd
X-Gm-Gg: ASbGncubaSf1OF4RQNF8+udjvtrOzG83ly/Rs+B1aRaWRxT4+6ElPWlmzulm6vWXnuc
	wrq6xJJLU9h+4OOFS6M408iqcx9gC3D1REHEIZd3yAhdfv2oXsd1ivF/IqoWQLSlrVUWgfc1aLI
	xY7pF1mZ1ATVshAzIcKmxZ5m1Yy5QAxMZWrSPurKAgQruJkVABe4ijeaHTfE5OKGnrmqY6kugjV
	Ni5l9II+BVH/sDIyKAjWI2OKKgEuy2BQHLDLs7X47onULpw9BOd9JtdKvZMzx1tNYra3vWYwgsj
	SqAgglTuDuYS6zUem3olYxXyIQxNHaflkKPrRDStDJLdxZtQ9RczJ+dAyqC4Yz0uim5XugkCDBJ
	SKs8g0+izl7h/+na5PNI4pLl5pVduREp1g7+15jpNcQGYipr0LzoUaTE3G0Iar5cD0w==
X-Received: by 2002:a05:600d:41eb:b0:46e:4329:a4d1 with SMTP id 5b1f17b1804b1-46e4329a7cbmr68503175e9.4.1759134565405;
        Mon, 29 Sep 2025 01:29:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGG44LTMrSDqtdNJC5gLcztZfakoOEQQRrMtffuTK9hpeNWgZ2xEVdwVn1FQvyYJPfNI56NlA==
X-Received: by 2002:a05:600d:41eb:b0:46e:4329:a4d1 with SMTP id 5b1f17b1804b1-46e4329a7cbmr68502895e9.4.1759134565003;
        Mon, 29 Sep 2025 01:29:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32c31df7sm87789975e9.4.2025.09.29.01.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:29:24 -0700 (PDT)
Message-ID: <a01ccce3-51c9-48a3-9c8a-1651a0f8dc37@redhat.com>
Date: Mon, 29 Sep 2025 10:29:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
To: Yang Shi <yang@os.amperecomputing.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, catalin.marinas@arm.com,
 will@kernel.org, carl@os.amperecomputing.com, cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926162034.1785899-1-yang@os.amperecomputing.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sSPTH0RG5bjLHwgfApkbMP2qofU1F1ZUCrEs2trNvMk_1759134565
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 37djk6o68moisutxzrfajwaxm7abg3mx
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FB1340005
X-Rspamd-Server: rspam04
X-HE-Tag: 1759134568-648130
X-HE-Meta: U2FsdGVkX1+E+0ZiM8q39iD2LMOupTwRhC8XL7eEEx9/Xklpgd11I4z3H4HFWzK1nci092FtdRwxEE9uComrCVXlG0Si6qx/PMrzW8DirWpk+6XrkE6Lptonv9tOV3gx3beaEPl3vdAr/LjyvrszQNvVURQ0UU6Qdmu4FpmnojcGFl5pIGWjdHOoCXkCKgqbQnb2WvmCM+l7ndFEywCaUm8xJckXMj4XxEYXfksY0P7pl9Xcllp24Mf20HN4DRKIYx+r7upWy8RXahHGjYcpUhXVD3BgB8d7yxJksvveay0zo7msSBSpTB9/MuJpIKlX/CriCzFXz2HanJkK7Zx378ZKnHdYzksgo0cSuuyooGVl4klO2e7MRbvUKw4wwmnuiQFqeXtQ0Dbroy14smW4OffxlGGKCmagfI8GXhDnmpH0MlBEkHLMZs4rCbHmc2BTQSQPNhMkCgK85kblMC8gRrKQMwy1zvOs9CtNEDVwYfTRgJB2lpNa5K3CeH1awhvhlIuMVrUWL5MF9VJ9ID9659XArLR765LXu4k1xokGFXdEcHBLis3opF7aMSLtAwiFHdLupAz/41f8n9g2idDbaGUAWkpe++eruVoIUmzPy7f6DKYClawxOWl4HKtjmL9NeGGE8yJ5U0BsVB/jcYTgKPwZcWGIUNGJqbR3igV0ox1tPz58VqEMndyiHVB3VeTA0Ol2Wqd+mE96RoMgNRwY32/DiQGAM3IYprIv4hzhFNBPSn1xDVUMg8QYEEKVLoUJuTXqiUCQu+kIGODJvUDhKpMvJIHqDHDpnOn8gMN6DKggoSpkAMHENi3ldnPIwI7OakFvLM9m2wMc9BgD0GbWLxUN1alkgHt65pOfA+qsoPVB64QOaOwuM4YLp0DDKQKFoDeuiMazSA1Ei7jCGXp5+EvRuKAVo9DrMVTTFz0IjKWeEc0U5FRO+FRfgKpf0+opC89JkifAMpro7+iX5Xg
 TODAz+2W
 M+zYikieugpV0z9Jrd8KvuBt0eT8D9Pdqng8RHjtumvdVaFiVs2p2OLMUpoyBJA0dJKP98lfSwdW4ig47JnvxBGSlPeUNrwyOH0okAadQSl1/jQ3R5qHkaDkdqEZSLuWy7YJybQAZ83L85dB+V3X+SC+yfZvew17HDAJFT1SJu0UlSpMMP9PAmT04ZDBaNnFtNBciILiwnG+CflsXayPOJLt+kbf9+8BhZXZJyOrO3Qrh3NYAe6uiu1MxHd/54atdX96fu6U01jFaNeHUOAkZt2Y8wNP9sQLV7m07b7Vn/kSUAA/7KXBTIxE80kQGUxRH5dsOyQh9yZ4FrupjfotFxtDFNTFMzOemvPtu2eDmQt9xR+ScqMd1Cb5RMw+4sT6kqP8oUsL1cqtFsrr2vK4+o0a90swaihaJrZkXSxyMjC4CQwPIrwa4ZWGFozf92rybhwOZinwOcxhhYw5yjlMKuvqjJ9N/mMqZek/mF0rwKqKj1qVwS1P2EPt2VKnTMhFZ8kDuyHV6r09C4DoF2nlrrTFidChEc0rEWFciS5DrvwhBuRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 18:20, Yang Shi wrote:
> When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
> for every single page in the affected area. Soft lockup was observed
> when doing this for large HugeTLB memory area in our customer's workload
> (~300GB memory):
> 
> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
> 
> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 5.4.4.1 07/15/2025
> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : mte_clear_page_tags+0x14/0x24
> lr : mte_sync_tags+0x1c0/0x240
> sp : ffff80003150bb80
> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
> 
> Call trace:
>    mte_clear_page_tags+0x14/0x24
>    set_huge_pte_at+0x25c/0x280
>    hugetlb_change_protection+0x220/0x430
>    change_protection+0x5c/0x8c
>    mprotect_fixup+0x10c/0x294
>    do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>    __arm64_sys_mprotect+0x24/0x44
>    invoke_syscall+0x50/0x160
>    el0_svc_common+0x48/0x144
>    do_el0_svc+0x30/0xe0
>    el0_svc+0x30/0xf0
>    el0t_64_sync_handler+0xc4/0x148
>    el0t_64_sync+0x1a4/0x1a8
> 
> Soft lockup is not triggered with THP or base page because there is
> cond_resched() called for each PMD size.
> 
> So add cond_resched() for hugetlb to avoid soft lockup.
> 
> Fixes: 25c17c4b55de ("hugetlb: arm64: add mte support")
> Tested-by: Carl Worth <carl@os.amperecomputing.com>
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> ---

Agreed that the issue likely predates MTE support, but likely in 
practice only PROT_MTE makes it pop up in practice.

With a refined subject/description + Fixes:

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


