Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84907CA0EFA
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 08:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B8D8E0024; Sat, 23 Aug 2025 04:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603438E0018; Sat, 23 Aug 2025 04:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FDA8E0024; Sat, 23 Aug 2025 04:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 431388E0018
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 04:52:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8311BB9E3A
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:52:42 +0000 (UTC)
X-FDA: 83807406564.18.CC26080
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id E332A40004
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:52:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BOzR7LYH;
	spf=pass (imf04.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755939160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PP5wLYO2zlvHpx8ruISXTqTGXsZ44eUfMj/9ZfnRZE=;
	b=bZT/jbpfOohfl92GymSkXB5g1cInDGTfIPV02H/XTOIs0gx4qBpebZap5hxj/PZ2mgQGd4
	24XRnLyBQKlXR3pM7aqfC8bcu4NgHc7NPsZFmk+ZWIEJdgMySV/p1q8nFYo151048keFPi
	hnbzY9/WdHo6kCoNc0hW8urX8oCka/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BOzR7LYH;
	spf=pass (imf04.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755939160; a=rsa-sha256;
	cv=none;
	b=iDZp5MU0PAvjd+NQSZ8ynPY5i0vjJ6t/YnEQPWMZWkfLeUhQVo9RUL97YNTa69QLSp6SYq
	yhjB6DX08LFLNydgoMIBPEkfTN64yv4pC4dLcNmR/ZJ/UbHGzfjVEg68qRTXFyGCtcmccv
	p/EqNn6ExSRorD+ogEfogUOJ6veNuZY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b4b25cdb5so3677705e9.2
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755939158; x=1756543958; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PP5wLYO2zlvHpx8ruISXTqTGXsZ44eUfMj/9ZfnRZE=;
        b=BOzR7LYHLy0S5Ep/Z1MLRElX+N5z+8c90Auz/eVqiur1UNpbteMP/6/Umx7kO68A1c
         FWstfyu+/AID+07wlV2gAGfCKz7wpVZFDXikx3dIKz3Ta2YaAX9U/cw1uOEWBfo4wVFJ
         N4ZqVkIlpxCjnRZG/iwY6dm79qnWHHFMCQn9reTKN3tqQz5SMHSuxLrjSKlbuAW7E1AH
         NvavzCauvaTrK239ILb2qztfpmiphUdR0FGBbdsn93/3nRvFSyhgQJj79MBnNqHUHHz9
         k18Ckiiba4HkjRaW55K6Fd25SfuD0xchsGUGhVLlonSNdeW3v+k/UskuqRLygKZBgZq8
         friA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755939158; x=1756543958;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7PP5wLYO2zlvHpx8ruISXTqTGXsZ44eUfMj/9ZfnRZE=;
        b=OeNae39qfXahBfYT01lMi4eodsg8js1VKNpQyR/RShGihWBU0nhyg7eeKtduddS/4O
         qXqqT8B8uqor2CqYUJBeSHXOSYMNWMVf/2P4YdSBVtjAfGZApF/6qkxIdOY4RuC6HoCT
         LFIIcJVlBjVkh5UpIf6gNfFzdZP7GrUst/ExAx2VCfIcq5u8YgRbl9R32IUqZishcMSx
         punV1DKQpaKLZ8Xvd1/OTCF9MDeEffH9/qw7bxlvEbHZ+QuzzSy227TpdzMr9/MHetvF
         pDiBr16HW2HGdTsP6ovnyqALck2siBUwwEAiwxHEZQQ3h+XplTBNP4WTeJNBXJ/Wf6Fr
         zP2g==
X-Forwarded-Encrypted: i=1; AJvYcCWeayNa9VwJy58BKknVzA41HAxzIwfMll3c+R9TmgN6QTSsewIiCvb1ZKQOLEhyCa9iMYdmh1cPKw==@kvack.org
X-Gm-Message-State: AOJu0Yy+YYV+3pDxT0nfSqdpyUqzwfmq3XEBA1+iQgBWhVhWrM/0RsY0
	nIx4ThKDZQtexWEQWG4+eGG3Np8bUDFYozVX6S52ZcrVX7WwDixsNeWP
X-Gm-Gg: ASbGnct1lRAonGaVLwenv5guA1H/dtxDzxGQWlFAWNamZ7Us2FHEqC/N5pVPobyy6oZ
	XKTNHdToIbVONx2/IPSkqe28mdvGb6SjSiTC9sAZqSlAgWMb9SpjcxW367PYLBCFydTy1cmgexi
	+9xU4n/Z71dkdyyud71teQnKDjj4d7cGx2e8+0uaQwFlc6vMGOyH9d3uwsXSB35k56s+brvx2WI
	spePJEV5RG5LQNq8/4cvXFjF2aKfTU5BQ4tyV3xfVT6vpGGgghHMv8TIy85939u2MAhQHpOj3PG
	8tkDRV/5TzdimXXJenhvWRqJADQK3tsdC7rbueQfJb8VnxYem9LCwgJarKkyxIOFSSOu5Xriebc
	OBNE6kizguhF8j3giYyV5R2pLqlJdzeBEmMSySXL+LMfrEHOduiCW
X-Google-Smtp-Source: AGHT+IHodoiT3tBSjX0hwuDcLRmhYNw6cAIJpzxg7LcK2D4rgZHgimwZ/kdkV0/kf5RKPnxladSDAw==
X-Received: by 2002:a05:600c:8b26:b0:456:1823:f10 with SMTP id 5b1f17b1804b1-45b552eb575mr18571825e9.8.1755939158114;
        Sat, 23 Aug 2025 01:52:38 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c7116e1397sm2714908f8f.49.2025.08.23.01.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Aug 2025 01:52:37 -0700 (PDT)
Message-ID: <1757f780-0228-476c-a5a0-ed980209852d@gmail.com>
Date: Sat, 23 Aug 2025 12:52:34 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: akpm@linux-foundation.org
Cc: aha310510@gmail.com, david@redhat.com, leitao@debian.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
References: <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org>
Subject: Re: [PATCH] mm/hugetlb: add missing hugetlb_lock in
 __unmap_hugepage_range()
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <20250822180708.86e79941d7e47e3bb759b193@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9h93uhf3tjk835fksof5h7jzx1zkyd3z
X-Rspam-User: 
X-Rspamd-Queue-Id: E332A40004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755939159-458167
X-HE-Meta: U2FsdGVkX19AF/uosAqe1xSOmsO6dLzDauH35Y13eUSyTzQDZimp6qbceblnpBqE9gE4JkNKs0QxeN8gbs3uOd9UZrId0tH/73U93BnZ8DiRICnNBV9yymfDBaDnkJ8ctxdSi3gaXGGvCG49ws0pTUD1DhM/WQe8cnDSxJTyIUOKq/5fhKtOMItgT590vkMhOSqgpoMfy7gb2MVPeS+n4Z3hlcft2ondVcpAJCR1PLtyh/xPz3sKJlMkzZh6EK8OdSckiWAomnvxffd/2u1PYCi3SzClQfbUwk5SHdNDp94J5PAA82I47qxkrM3phSdAAVEV5WgZ6bf5eRn3OgnsnDvvKtER8NkdrGY8N20sbqOhkAXRFe0kVR2339FJMGIC1YcFCm2G5TQnK1Ti024TMZE6KrF+gy9VT4hy9Xp3Cya1FYeHRnOcIczURlQC9vwzCI5euUxZd9RWrkrOJgSscHcOqjvXDgLPGTuDn5+Fws1iJZFo2+te8qagJAX9S9wzANRjRD/awyj+nniljCJ6ilISlA4JQIwZ2roslhOadMqf/KyQzK69QyIIt5p/uzXLBTyBK6qvegkW0aTuc5HhmT/x2TubCA2BqnM4k0JHVPAPQUdcf4UJUIg8ND7OzZAC19F0YmxBphM0/h0KgndocrHaeGz6BoGJ/N5vAg4T34EtU1UI2Y3jhs4yhR6RmjJVQRmQQZgD2iu0F/ZQi3HoezG8wJgasJ9ZtNT8LHy/SxXLLs41qweQYKQhYFj7YM2P+HK9uDdNl5powDuCBelKVq1kh4LNrfC9iGVz3PKucEvUWcHY2EUFqTsYdUMCC6AZnWmQzdF0BtBcqu/Jjw0dvOwdRyCj/mlzFJ9zuQm4NikMfaEQVvohLUsv348OgV2Ef+PDA9nXN3DMX82jXpuBQ/HO77zQ6chVr+Yd3CUaCx0HhT9cKUIEhRmZnWYo8edctEnWFnhWGAQ9SrfMi1H
 rVIeKlUq
 /GMiqVHt9wUlSUikM82JM+NfycUSZRkez3Dv6zCjXYPnOAiG4QurGJiXZ1Of8qxNUT4hU33TfX+2tjlWqzXYHGUC5Sh+kyUk9iEvdhOZFPiNmkiInDSLxvMQrhrmUCpYVIQx2+RJ6qVRqMASPh9eL/wNdYzc3aeDQFqq37l5zBxT5o7jKPTbt5Cs37DC6HNQaYEK8Q9/Mz2k6b//OW0rlzyjDK49g76SoMTplQrRsESm/+9kGYouNdPiCspfJLCZoisBI3gMtQ7xeijwrQSaEKMGgSD70SNOCnZXb2vAJb00tNLF/eb1Eb96rD1n4FMDwjI2Hy6bUxvRYJasgwfOm1sUvXJmpxROiGAjany2OYC4HR+z1Q5OrkkCzEEDA+eQ8t5GFAsAC2lXh+XTKv/nQSQE2WTEpgY/EsYOTVRdr3fKNly2aausxz08IDU0tTV6l4IDB6cangA23CP/KnDfdrtuwZ1XWJS0z778nqg/M/A0JI1UYbkktxkKYxfTgft8nB0j5c91dt/Xpk8HykVIysguTE7u+701Wh8VvDb2ZBpjr0n3mfr/VmiQRuqL8hNSk0MFkmex1kaQ8tsERTYZKZ6q7r7qPOZ5lR/MX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+		/*
+		 * Check surplus_huge_pages without taking hugetlb_lock.
+		 * A race here is okay:
+		 *   - If surplus goes 0 -> nonzero, we skip restore.
+		 *   - If surplus goes nonzero -> 0, we also skip.
+		 * In both cases we just miss a restore, which is safe.
+		 */
+		{
+			unsigned long surplus = READ_ONCE(h->surplus_huge_pages);
+
+			if (!surplus &&
+			    __vma_private_lock(vma) &&
+			    folio_test_anon(folio) &&
+			    READ_ONCE(h->surplus_huge_pages) == surplus) {
+				folio_set_hugetlb_restore_reserve(folio);
+				adjust_reservation = true;
+			}
+		}

  		spin_unlock(ptl);




On 8/23/2025 5:07 AM, Andrew Morton wrote:
> On Fri, 22 Aug 2025 14:58:57 +0900 Jeongjun Park <aha310510@gmail.com> wrote:
> 
>> When restoring a reservation for an anonymous page, we need to check to > freeing a surplus. However, __unmap_hugepage_range() causes data 
> race > because it reads h->surplus_huge_pages without the protection of 
>  > hugetlb_lock. > > Therefore, we need to add missing hugetlb_lock. > 
>  > ... > > --- a/mm/hugetlb.c > +++ b/mm/hugetlb.c > @@ -5951,6 +5951,8 
> @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct 
> vm_area_struct *vma, > * If there we are freeing a surplus, do not set 
> the restore > * reservation bit. > */ > + spin_lock_irq(&hugetlb_lock); 
>  > + > if (!h->surplus_huge_pages && __vma_private_lock(vma) && > 
> folio_test_anon(folio)) { > folio_set_hugetlb_restore_reserve(folio); > 
> @@ -5958,6 +5960,7 @@ void __unmap_hugepage_range(struct mmu_gather 
> *tlb, struct vm_area_struct *vma, > adjust_reservation = true; > } > > + 
> spin_unlock_irq(&hugetlb_lock); > spin_unlock(ptl); >
> Does hugetlb_lock nest inside page_table_lock?
> 
> It's a bit sad to be taking a global lock just to defend against some
> alleged data race which probably never happens.  Doing it once per
> hugepage probably won't matter but still, is there something more
> proportionate that we can do here?
> 



