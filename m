Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60847C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019AF8E0002; Thu,  7 Aug 2025 15:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DC38E0001; Thu,  7 Aug 2025 15:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4668E0002; Thu,  7 Aug 2025 15:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA8B98E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:41:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 528E9160555
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:41:32 +0000 (UTC)
X-FDA: 83750980824.05.638D6BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E59D7140002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:41:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KXejDDui;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595690; a=rsa-sha256;
	cv=none;
	b=zDrKTF+S5vC6Vklm89luzo9H0N5PE+0qlkpvNMlcCpGV89YI0GKgAwD5WaT/SFVbHrEtYK
	aFQ6bB/ukk5otwaFJR4PeFi/7kQEFIcF8NbuCHIf+xTP5icM9KtdjXwTCNILBPm7qDD4sj
	ZWyuVezk5/b8o4J8gcfEsJUusPdP9g4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KXejDDui;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeYHKw89L3v5zGQ5eALX6EboGtf9gJSw2vDV44gM3pA=;
	b=h0EgM7m4cNN9jaYuSgHQsnWRs+k8ujN/+HO6o2PiJKy53qWzPeQDS3cmZXF3zUYMnPBo0R
	blRNl3HjDcPLITP4IuuGPslLnBTA+js/4bijG/Ix2m2tK2cFwJAU8RxD1mDK/Cf5CIP7yR
	96pYemuEmvC0wGVUweqmLGcj6nuMcBs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754595689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PeYHKw89L3v5zGQ5eALX6EboGtf9gJSw2vDV44gM3pA=;
	b=KXejDDuiYJpfwqc9aNKQBgz6Wp3kmEis5T/rrc2zCbo9NQwqEr9H+r02B1LMjHe60D6GdS
	I8PXizAYGOeH6tP0iS2ahZzpsEm2vF7dBrUbXBXPVMyHOs+a5dMqzHK3+NFlkVO9GYD2Ul
	+tJTTtikPMQWiQ+BBHm7fjxe+tO/VpY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-ea_T4EPaOc-Omtjw0SZSQw-1; Thu, 07 Aug 2025 15:41:28 -0400
X-MC-Unique: ea_T4EPaOc-Omtjw0SZSQw-1
X-Mimecast-MFC-AGG-ID: ea_T4EPaOc-Omtjw0SZSQw_1754595687
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d7ae12b8so9378265e9.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595687; x=1755200487;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PeYHKw89L3v5zGQ5eALX6EboGtf9gJSw2vDV44gM3pA=;
        b=Wo/qvI2HQK3+Uwx5tfVUjhfaYawg9Z9bgvbRrq0pNuMV1mSeZPirq4c1NE6nkUhdtc
         3MCFBDnP0qNLNOFaJL5bJwHixxDYj0fpbAmmh+9TIagRDFQC53eas57LIdmKH8ondTID
         nO3FY+R5+VYUB0M5jWEb8Kq/8cBcq+Zpau5No0OVNvLPS2YcG65rnonJo/0u7AdacFqd
         NDugPrfGDEobgp7eMZzmGuDiepCd5rK3MeGVmlqCYfcCa/ZaQwI0Z39uS8zI6MiMeDAe
         oWx6KK/4o/rK/EXZQ2xnES6nBBaCZm7ZBcNWun9Cm7FXuVlygBIJvwuOYPoyHsSYgcwe
         A12Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqpCzXof7dehawaVtkIAbNyIXGjF4cYxw38jQcvzEzleIqn4pt58UigDlkZ0XO000KOv2kNU1/0g==@kvack.org
X-Gm-Message-State: AOJu0YxT14oTtJ9rv4gIsX5qzLLsCBXgGrxQ9v6JP9Jh0OG43heHTDCp
	GwcTeLt8pHjmUzcGvGh9NmBLhPVJCtOYFbqinF5eQWrh7z3SMkxzaBFEAe7vb7b9D7Sn8Plng5w
	cR9MQaAkHfv/Ib5/0IQ3yGKtXUU02jr5rFKQTL8em/dt2Os10mpql
X-Gm-Gg: ASbGnct6w5BDWgW/bQTi9U7toziQzv6ZKgRztvIYMNViRAnGxvScmdFmkKpuAwkI1Ku
	1g+7rnXttcLWINFMm/F26YettYoKLJ/gFkbqZuhnpM000CQ8qVniK3J64PV9JbRQySIX/JO2u0E
	1esaFuqB5E4DdrbZB2ftyiCNEv401PvAWNB018768QVScN96xkLfcT0gxa7YkMzvsAjsutnN2cN
	PnIOIql5mCKGrYff3aL9+4gID1KIXPzKZi2bHxOFQB8FMT4XSMpcr8GGUvizzZzTVqnfC8iQH3i
	zrGvX0g7foNjOdzAFcBOYg3CPoeWHTa7ZiWfsznyWPQCEkA1tvCdJoAXx/2lWEu7oDeYjxk8Try
	fJJnGi/A3eETapAed3x3N/8xBBteJpGdInUkPHzmwSY2BxRKcVOt+Il0dnjsKVVKiOsk=
X-Received: by 2002:a05:600c:a4c:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-459f4f26472mr1728575e9.26.1754595686835;
        Thu, 07 Aug 2025 12:41:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyQsr50pqCVgGsQY+sBGaUVLZfT/YAV41avTGHKvxWeW+KAmNO8+R4RWGQ6C3gl5IURhlxKw==
X-Received: by 2002:a05:600c:a4c:b0:459:dde3:1a33 with SMTP id 5b1f17b1804b1-459f4f26472mr1728395e9.26.1754595686434;
        Thu, 07 Aug 2025 12:41:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e075047fsm79496325e9.1.2025.08.07.12.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 12:41:25 -0700 (PDT)
Message-ID: <ee3d7b32-af47-42b7-bd27-0675c065d736@redhat.com>
Date: Thu, 7 Aug 2025 21:41:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IXYyPQT9VYCY6M55bw95PrVGKrpE2XrtRnMMVQVEzfg_1754595687
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E59D7140002
X-Stat-Signature: dfmnk7jbs4te6npxr5kfbor71dktub9z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754595689-15472
X-HE-Meta: U2FsdGVkX19Y5WN59N4rC4wxRJ/QUQBexqiyfCnEaB0IUMI27CFbCrtXzlt5mhn03gSQu0HajACnSv++baQpiEHT17eU8de7HFbXLG1kRP3ZTMdWNWOCWTVOWj1LB65RwtQju8jMquo7TGCrKvHfeNbHCfkDifBJ6Fg9AQzesMu8K+fja5p3+6swr7z0iy5n+fK7r2OqA/YLjflhNXBGG2wZh+zEY/22sZ5dwBrwnFsHWMsJvSy3d9clc7faFG8ni7UlQbglMSCsFmRFcbjJ1UEClF1fSDMFtgCLFGWJlROa6T+vJKuAYKyucDLwTKCohliy/lQlk5dVPzYJid9tWLiZ58ZU5eNyuiZ96y2q5ewDuVe+iogX1fX7MVBeeFu7OfWZ6z90+4pCnIi7wS6MQyNpSlK8pD89QJozfhGlYOPNFwKa/97kV1VXKnsJBvtyBQrTO6W9OWCC9ch95ZvT7GAFb8VlIfH0MYmeLvY7hnad2Gh1lo7NvGg5s5Kfq8HjMGqazpz4oYWXOYcAAtenc6Qu/4vTdNe5lMoYqab4hH8g+p6hAQaP8BuoVCB9z5Xl7btlE8cVCDwkPHAAXkNWsP4Afp3cBhHyD29mGnRb5TPJqDpw0654DR9dr2pBQi2VfyisxnQkJWCiyoNlE5x1yOJM4EqGU+i/94+VFxLNEBr/BxtQrX7L6eSEQQ4vM9AvptIvO548TsJO3ZySJGwVEwpikqJa4zb1beBYNvvO4cWh2CfRWMkagoXb0Tuq5J6xniJk+SevRWNIH+PocAn2sp0YPuTcEcE7xAoU5Nm28WiV5RMnzMKzvqL7G2AWqwBOhZJvy8fZ9NnoLYbtvHXYdtuMSJSGJIHUViKbIlQWJkGrrks6t+SGe5iTdvQGmu0f8yuA9ubsyFZ2O+86vlAgG0TBhIcFh4zW0HNtYW2FviEZqtO0YJq+bcP4VLFkfECC9Z1ELwHi2d+II4TYvfa
 g0VgTEac
 7mnbG9tfU1qLxdeuUo8Cni7KlCeDlsogstueoVg32N+BVgOn6aIUz/A2s647AsRRbNZnUwrduARTTEiJjte4Eqv8ToJECIhaEOz+4wPTGQWMC14S8Riw+vQfcv7SaIjP6cExO9V1+MAFDcWztsvyUf7y2nX6tTPdEYU32hLPaP1D6zEabAfkiR0P/akMzDLYZY+47ZOLh6e6/v4BXS30gH3wfoqb5sMxFc05m5FO4f3u0rJQTfvO1XMbh1xWYJBfQJEwjTQInW1UBZv6dMX7bTO9DyQ7ACwmg9tyBxFPlae4pK5jX4Ia979iAsa85LB/sdOn+f7k5VvBQuoClT8FfI0rYBRFe6OptTHwVZZNazBropzJAro+NXE4kfXucstz1etgqF1mJHM8EvKjS9gXMsA15eDSpyk9xO4/855qI4oV8ZWmaJQYJ48ZNquXAE9ta+XPZjT1zdNKklnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 21:20, Lorenzo Stoakes wrote:
> +cc Ryan for ContPTE stuff.
> 
> On Thu, Aug 07, 2025 at 09:10:52PM +0200, David Hildenbrand wrote:
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks!
> 
>>
>> Wondering whether we could then just use the patch hint instead of going via
>> the folio.
>>
>> IOW,
>>
>> return pte_batch_hint(ptep, pte);
> 
> Wouldn't that break the A/D stuff? Also this doesn't mean that the PTE won't
> have some conflicting flags potentially. The check is empirical:
> 
> static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> {
> 	if (!pte_valid_cont(pte))
> 		return 1;
> 
> 	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
> }
> 
> So it's 'the most number of PTEs that _might_ coalesce'.

No. If the bit is set, all PTEs in the aligned range (e.g., 64 KiB 
block) are coalesced. It's literally the bit telling the hardware that 
it can coalesce in that range because all PTEs are alike.

The function tells you exactly how many PTEs you can batch from the 
given PTEP in that 64 KiB block.

That's also why folio_pte_batch_flags() just jumps over that.

All you have to do is limit it by the maximum number.

So likely you would have to do here

diff --git a/mm/mremap.c b/mm/mremap.c
index 677a4d744df9c..58f9cf52eb6bd 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -174,16 +174,7 @@ static pte_t move_soft_dirty_pte(pte_t pte)
  static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned 
long addr,
                 pte_t *ptep, pte_t pte, int max_nr)
  {
-       struct folio *folio;
-
-       if (max_nr == 1)
-               return 1;
-
-       folio = vm_normal_folio(vma, addr, pte);
-       if (!folio || !folio_test_large(folio))
-               return 1;
-
-       return folio_pte_batch(folio, ptep, pte, max_nr);
+       return min_t(unsigned int, max_nr, pte_batch_hint(ptep, pte));
  }

  static int move_ptes(struct pagetable_move_control *pmc,


And make sure that the compiler realizes that max_nr >= 1 and optimized 
away the min_t on !arm64.

> 
> (note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).
> 
 > I suppose we could not even bother with checking if same folio and 
_just_ check> if PTEs have consecutive PFNs, which is not very likely if 
different folio
> but... could that break something?
> 
> It seems the 'magic' is in set_ptes() on arm64 where it'll know to do the 'right
> thing' for a contPTE batch (I may be missing something - please correct me if so
> Dev/Ryan).
> 
> So actually do we even really care that much about folio?

I don't think so. Not in this case here where we don't use the folio for 
anything else.


-- 
Cheers,

David / dhildenb


