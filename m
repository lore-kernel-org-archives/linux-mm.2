Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B58CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5592B8E0002; Wed, 10 Sep 2025 02:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530CD8E0001; Wed, 10 Sep 2025 02:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F9A8E0002; Wed, 10 Sep 2025 02:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30F788E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEAF3140772
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:45:50 +0000 (UTC)
X-FDA: 83872405260.14.5F59881
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 770F01A000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:45:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=arZ7EH1B;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757486748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0LaaZHJC2+QM5StiTxDhV+SbRojzxK9teAGcqG/Wng=;
	b=Na6zQk0CmC577BjaI4/I8XW285Rk7E3hJTRgEarzOVkPssky53XkCe2dSDndZ41/XoJlqi
	P0Ygbwyg0Fv8XG+jdXysXVVwX8sWEn3NTWqqPxMr4RGEINUH8xucdgtrz6nNUc7LVh3ajN
	xas4WyWUnE9EMFTJR85/VuhVnuwQLws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757486748; a=rsa-sha256;
	cv=none;
	b=for+kj/DQKTZz4k7B0h8KnjEWqnVjvgmSEpqFfaxvYssaqxwr4hPCDvqjNh3+XCbUumpN5
	BmsjyIXzKi6kisWaOZ3oOnhB2Ov1eJj0b+g2KFmRq2uCXQymr5If561tggRAmBea/NK15F
	RunRVUlZv7OKeVmnLSvhNecCcMHlhT8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=arZ7EH1B;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757486747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V0LaaZHJC2+QM5StiTxDhV+SbRojzxK9teAGcqG/Wng=;
	b=arZ7EH1Bjmy+6StiNhfjdclDmBF+Zr94WMXZ8M43JMJ7/DNdRpbEgF9jnNfCTts/SW/Jvf
	K6+nAKy1Dl0IgnezyOykqURIZyVefoJeVSeWYsb2wNmZ40qerigRTjzw5ur0gSzv6JjzDd
	oBwib650W740NhWVyHfE92k9cuEZlLw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-DQ1MCgsRMGKEp2VjhXcdOQ-1; Wed, 10 Sep 2025 02:45:46 -0400
X-MC-Unique: DQ1MCgsRMGKEp2VjhXcdOQ-1
X-Mimecast-MFC-AGG-ID: DQ1MCgsRMGKEp2VjhXcdOQ_1757486745
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb612d362so35550985e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 23:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757486745; x=1758091545;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0LaaZHJC2+QM5StiTxDhV+SbRojzxK9teAGcqG/Wng=;
        b=QJGWsP6H+aulIvgX3I/rsXUKK91U+cGRkEntEI1zwfdvgLru3e/UfxYtMWrMXpj5CM
         6fEtYgPtPYzPo9SxLBGmEZsJHTziF201jl9MFmlrpJsZHnq+E3sgryHh8sOsuG/jL9JZ
         z/LGm3+MhwlMa5amMK1xzQvqZWszpLUpo4cSmtbbsqWW/XXVllnPhwV2DZtaifQD8SuV
         RBtZNrT0sf5n3BivTQxsBqyT2KbZeBFgg/LLWc4H3a2ZhsMlgBc/hpA+2QAkgzzdMnoE
         rRvJyOuU+tyUHg+lSp4+OLpp9Jtfsup/Hd8hQvSLgjSEiAja9zt6ihyx/cMBii7W646f
         fweQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAWBJmbKfgDgO6VBWuaibML9JrEKWWmBTX7zq9rN38GdYvDl7GX4Po95IRqfZQDH7d+iOio02itg==@kvack.org
X-Gm-Message-State: AOJu0Yz4kZ7UqKBinM3tNAB1zhwolEv3aWXbSIwAuHlXC6eiYBPoHk1z
	BxJIF0+1iKMC90HHxWFd6YAmTCQWNGGj9qqC2HeKnsTpL1ykjVcM3Lk72lExGggtXm0Ep6BIU4U
	dyk2CQcnUdh3cqXOEfLRLAHa75rLBPvYjVGt1ldD4HNW3vkl7V0Q0
X-Gm-Gg: ASbGncuiu9lCF7NFLhtzkv9fybnGz9x/FRYaQHL2dT+3eyhWXJ/hv9qL5NAObOSxoqX
	BwP1qzoQh+0c3fDj5apSov1b/OzCYUYGBzkxrzbpz4mryUpsYmp5l0PHKYINugL8WcWj7u/Km6Y
	T/f/nKADqYXj2qBabvRoQ0K/F06LY6J+3jNwvJYFU/Pdh619GzwupQS4ztMMnNpb6vz73y5dmO0
	1rzqYmb5Uta5mgU9fBGGspDrZ8K6MngKVxCMcbyjpoHmVs/+CRRwUE1NDsylXzCP5pDRGbT034u
	TpZ1iuRjnH6c2x3dyRko0DwtMlqrStY9Zlc89aPU/wLrmvqvS+LtwVQJw99FWuVjxCmUT5iLYOB
	vdXJcmttr6InvYomFZw+WOwLvtUh4PBtZrJ9ObNX3VrOu9h448n6D2EDptaqxratjFdg=
X-Received: by 2002:a05:600c:8b42:b0:45d:d522:5b2c with SMTP id 5b1f17b1804b1-45dddefa74emr108518515e9.34.1757486745353;
        Tue, 09 Sep 2025 23:45:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiaDvgvPi+ow108IrBBgH6uR4YMCBOBWtjYkmddUoAmFVlm0pw98QwAazjmMcru3JY0FxgMQ==
X-Received: by 2002:a05:600c:8b42:b0:45d:d522:5b2c with SMTP id 5b1f17b1804b1-45dddefa74emr108518355e9.34.1757486744966;
        Tue, 09 Sep 2025 23:45:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df17d9774sm23146765e9.9.2025.09.09.23.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 23:45:44 -0700 (PDT)
Message-ID: <e9b34151-0879-4900-af9f-2ce0dbb678a6@redhat.com>
Date: Wed, 10 Sep 2025 08:45:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
To: Jane Chu <jane.chu@oracle.com>, harry.yoo@oracle.com, osalvador@suse.de,
 liushixin2@huawei.com, muchun.song@linux.dev, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909184357.569259-1-jane.chu@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909184357.569259-1-jane.chu@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OcTKGjLacrhgJp6Xt3EVSRRYGyw5pRQqXKL8lP5NvPc_1757486745
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k1dk9zpt75kbkw86w5matthd6qfgafud
X-Rspam-User: 
X-Rspamd-Queue-Id: 770F01A000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757486748-120744
X-HE-Meta: U2FsdGVkX18wLc43R6Bh6I4ld6UyIPUMvLQPZFFZRxy/lUMdUUEAjynpvAkWNHUX6XxLUiZ3w+7/dkq+D/8TArOIKjG21do74AqBDeNw8rv+d9UruY9CGXDLyOmqsb+9XBUbGs+ctrX7Oc0qxoisodKhHPCMKD6GFIbrdJ6iZZp/oDyGIbs4HbLAmdiPFh7DPhtADaN/4GsJliZTpG1Y8rQ5R0CoKH7MoQIWc53vBekVTkzwaq6w2ptZVChNJEqW6un8R5SvXU6o/xABs1rEDKjsxmLyGeqfAaFEu2lm/fkCkGdHkg8WrQcAm4lZgHTCsAtne3WoyPZgzefb1KSvY4gsfC7tHr8PJuv4HirWjdMv2OC0asF5yEHVHQflXzTCNYxu7k+pkJ5AYSDj8cjkQc0JSmNl6f43wV33lurYfaeg7YhXgN5KTdgi4Xl2AWTvFMZt2r7GQ/GV1Jz1d35U6uIgkq2se5TqCUI4lbCK8oaFJlD0EqJCWwnK6dtrM6qi4CIpISvJlN4ur26v6ArA8Z6vVEJl5YXG9ATdBQWNN7jvi3z26D2WIqPT9joFhkub5USFco1iDcKi+mZ/j0CmUo/Eg75yOeyT8B7eIjKqYBAWTwHbB8eb5owQZkp0JI3RJjRsbXNhupMO8E+JBvu0MQrnxUVTsgg3fVduFZEYEwXK7bnTc9vA9y+t9onR4KoKEsap58hCGOj5rHhZ3zzS7x5l5asrZgSrvZYHQHBDEOsWrIPkGxIYx5QmBicSF5WCwLOOFAqdA5FCCPQKL4y7RuzxeWF+4MA90PslrMwRF0vBLxZSRE7zeYOWg7xsIfXX7pX0brbRedwtbW2aw7RktObvoOSJtqJIcsVj9rKEe8NqeWZFujZY86tvDO14/GX+a3ip/GBmF0w3bz9vwGJDkd/1loKG/CKGrKPapi14GVPWvhceXjw9QvjE3oq2Vccu+nLaA4/IFuPJsNjxfPd
 fZz3t4qY
 VW/fbMugSOIk6pqzweczbdbL89kfmDj4VtbOZInZW0dAkq5tGlljFj7BoH55ZPDpV782fEztKLpy64vgwSAZOi1AbaKlMt6p2zlO5RZKNVEJ6bCF+F34QRiUd9v+jemmh5nXXYcknaWsXj6oxaHw1I5w6HmjvtDb6JQfSoKhHW9YOn1qBqKdx1vD5cm2NN5DkZ470dv0Ro1M3k+edWnNnbjpHE5n3FdILmck4xADFMk7Orj12x85019YU958Os12K8YYI9RF254e5g/+EGj3qbjhqW1vikNINjWCW8aK85j5nRLotrHXRCdySd+sY/WWyTstzldyLWzEBiMsaUSi5wReFrG1R3uDMbCMWZhgNirTIvhu3BR2znMzoxKT8QYNoRrs0/7iUdCG1KvwPVEXRJo2+jahbhMpdS5UftwcshSDIOV9mVjqJzT7q3DpuAXzZWsrNAWiqmnwrWAxFbWhbXE19e0qho9JcQec72QwJbu6mQh9XQ9LIyDLjrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 20:43, Jane Chu wrote:
> commit 59d9094df3d79 introduced ->pt_share_count dedicated to
> hugetlb PMD share count tracking, but omitted fixing
> copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled (commit bcd51a3c679d),
> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>    1. remove the PMD sharing awareness from copy_hugetlb_page_range(),
>    2. fix it.
> This patch opts for the second option.
> 
> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
> count")
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>   mm/hugetlb.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..8ca5b4f7805f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>   			break;
>   		}
>   
> -		/*
> -		 * If the pagetables are shared don't copy or take references.
> -		 *
> -		 * dst_pte == src_pte is the common case of src/dest sharing.
> -		 * However, src could have 'unshared' and dst shares with
> -		 * another vma. So page_count of ptep page is checked instead
> -		 * to reliably determine whether pte is shared.
> -		 */
> -		if (page_count(virt_to_page(dst_pte)) > 1) {
> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> +		/* If the pagetables are shared don't copy or take references. */

Why remove so much of the original comment?

> +		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
>   			addr |= last_addr_mask;
>   			continue;
>   		}

LGTM, thanks!

-- 
Cheers

David / dhildenb


