Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B857CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1862280028; Fri, 22 Aug 2025 07:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFDC8E009D; Fri, 22 Aug 2025 07:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0567280028; Fri, 22 Aug 2025 07:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB7E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:31:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C3C8809F7
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:31:32 +0000 (UTC)
X-FDA: 83804178024.28.7E8DAA5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A97B100013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:31:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gNraIgo8;
	spf=pass (imf05.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755862290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfbHPH5Jjp8Rpz5+ZFUkvP8crb1ywqdy8VPh1hjPgaM=;
	b=kjWndKaP3ZpI0LbhurvczPc84nyqWwpesGYYs8Ile7D1QS3zP/QQnGsiQQof0pBhuvDNQX
	9Bfbuu2YXvrJwwy2ZAjPBNIWbIQ+h9OsVK0/FEx1PW7DcwaHbVZ7OOMcTT7hTkkt5MTQnJ
	9Rz8a2KNYAgDx3qFjiKprThNdhq7brg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gNraIgo8;
	spf=pass (imf05.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755862290; a=rsa-sha256;
	cv=none;
	b=dPqD/lKF4T9VsxRk/LcMFRNwwQaOtCCLmyJMRWGOo6zKxcXpwApbMPK0KSNR78oqNoYZZR
	5+D4hT4gNII0AdLQS15UQxnUwBEzbxP9BRc6iiKsBKv+pyNdRE/QIFOECefdatmUuF4EoN
	wTbs/kaSqx+MrO+feILKSBgTII1i9s4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b00a65fso9944065e9.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755862288; x=1756467088; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SfbHPH5Jjp8Rpz5+ZFUkvP8crb1ywqdy8VPh1hjPgaM=;
        b=gNraIgo8GeL3loXv2UIksPfHLqseTMs0txUpDvyiMP39vvjCjktP7Q9C7YqRtGwp97
         rWi4ENa4vsHmAO+SuRHGHE53mOth/4QV2tNLxY7DWMMb3mr1tMTbV3D+dOI6atoNTmPW
         aLYpPq4wqd9+GkNCHTa/oI7pttS1bX4DKh7JOg5cPV4CHj7HPzVsc6+R1pOHvWM4zea8
         Fuf9CYfE2Gg8ZZgAC/WhYWKQAFZI3+IdMwDhvKUOacQDW07OagpBDYbRY1gfOlkHMYiX
         DTZfngE9UUjjlOtOTTA3U5PEF66Mr104NTybjun+LYcS+BC9s3uEYoXHlqdxbVwJWwQZ
         zMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755862288; x=1756467088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfbHPH5Jjp8Rpz5+ZFUkvP8crb1ywqdy8VPh1hjPgaM=;
        b=FylTdCfHDFSjhe2Cg52vDDf68r3LK9wbXaoN4fwIfYS4U0GLef8WhlluRg+8oQCUhU
         tOqg1jHuLacDWeYqPF93gs1yHTW9hLTTKynX9InXLsC/1wJyewfjR3FLSPPo0mwFO9Si
         1YW0lznNbZbHe/RUnP/SmxdZjk9X5v69ZkXa5KBmjDlQrq8Jp/ET8uR96mD98LNCpkE6
         ERanPGlPLbOniwsfOEi/+fLIu/Sg+ODbJ0poo10/KJFUryv3VBCRbkdb3V9A1LLHnbCB
         jVbGVVwMZJ2ztJ5sFk07cvsrqcC3UUnvz6giW93hC/IMx0QiewDtlwE39AwQhKSMMaNU
         hZ5A==
X-Forwarded-Encrypted: i=1; AJvYcCX/ovRCDVVfGi+In2jlBZDVvBddVk/GELm10zjRK839x1eXy6s4LdYfMtookAZQyYp/x0mF7a0T8Q==@kvack.org
X-Gm-Message-State: AOJu0Yw5pYT6sDIamO/TxvaZjuQXF04TVFCMlw4shd073OAQ5zEAR0T2
	95l5zkHtAPjHgLg2cqvSjYbHUMHvTHphp+GDIHPPELZ3SvP3d2SppPhz
X-Gm-Gg: ASbGncsagrKryN3xPigP9I5kl0+e3vGKE68DdUhVD5j685ud0L74v930vsif1+BCez3
	fuiFxp/9RY+pBr8dxVLPMJwmXwNU4GF+VXrVyySpIAHUtcJfJX6+aItY/jz/oKRfKRlRu9ml2eS
	3nnrtVIQBMrIVmly//Mk93l5LvNGxIINfdPk8aSECUTS5Uu3TycPN3rh9aJBZXJceFnRj2ME+NZ
	Lk9bOwzoez/6wZLXmlN/1qzwKeu5A5Nt/k37kXTho4QqwhZprYBvLXpseghdyBX1VSoMvp+5QPw
	D1vrufzxRjbhWFLqy/Qg475+Tlqb6coaKfTGwl2+Q0qTtX9OAb7Bfw2tvbpRi7GOHtilPYYLhnT
	Da2mmc0P5LoTsWoIIrnqCO/4Vlpvv4HS5sEpj2mEWkwGtbJjFyhc/vVI=
X-Google-Smtp-Source: AGHT+IGRxFKrTZ5eDvBkmi1zEgN6s0gJ3t3AoyWptSyZJnQ5Bb32czELomyx9FMDxkr1p0nFemiRbQ==
X-Received: by 2002:a05:600c:4747:b0:459:e094:92cb with SMTP id 5b1f17b1804b1-45b517ad81bmr24844685e9.12.1755862287996;
        Fri, 22 Aug 2025 04:31:27 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1b93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50e4241dsm35921185e9.24.2025.08.22.04.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 04:31:27 -0700 (PDT)
Message-ID: <b5b08ad3-d8cd-45ff-9767-7cf1b22b5e03@gmail.com>
Date: Fri, 22 Aug 2025 12:32:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 18/35] io_uring/zcrx: remove "struct io_copy_cache"
 and one nth_page() usage
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-19-david@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250821200701.1329277-19-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o4m36qgh7a1srietpacb76csmgka9gxj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A97B100013
X-Rspamd-Server: rspam01
X-HE-Tag: 1755862289-411373
X-HE-Meta: U2FsdGVkX18PCj065Kw8OVR/F0ZXNlvzbBo83+HiHZ1goTIZvJALbbgysXCH8GfTSagsRhmb0TqDtl/aLa3sdw5py/MgAVKgUaRYMS4PPiZhpCtL/WNjRD9zUjXonPmG+xpi47NXxaf6iuYDKcIaYsejaszliXMxOdP4msnJ95Ru5Mtr2DJWiRBv2Fs3cSBaW1PvyDDBdlFb8sYzBdgOlkdgOkF9cZFPF0AoAs6pl398mk/kXKnCSXvhgsk4Yn81bKGlQaVPnO2WZJhzq/AmjmiRPQ9bXOsUxpgdz2gmSQiswJHjnEw5gi3U5iSX0hfbGR501VqwE1CdM2e5EWrT+6AcFIb4rsWKecGtSIL3OUiDDfJJ9a+JP4FapKIhl1Dm4FeNPlj3jdRQlaFZSuk39cZU1ZFHw3e08l+GO+j5pfhwfrg9P/d/EMEAIWgKYeoj4gWRh1Zi7UE+g9VJZiIlfQnQH1kvr5+4uZvav2HFYHniVghmYsFQ8fyaV7Ky111Z6sVHzVn0aRSQ4TwafZjKc385x0gqSZNn+WwG/BKGuyqDUuhHsjuJT/6mntEsKPNjX4LhIKQD2aiInZmRaP88SQq698U8Y6tPcA7lCDb3OYgltzc7An0T3xFiXR9BoS25ggN0oSPqtMeDTRUDcTZydRNwzIAqEdBLYS41svSoE523souhoVrtq8pR56X4KMXZzlEJo7S78jInaojq0O4bSd2I1Y+V+5tGVaf2JFYpSBDB68Xy6RQ7DcWoPziRkfufpB2AX9ibT73nbpyxQP3FidMR1E7obQ3tA/MP0V64WLf+iNcK+1euITt9gUFgAIlIPBkE4BdNv+KlY5JLx1LiT2to/5XVsxOld2ZCIEG20U+n4q9Y7bbY1qloWTgsJtFbSirL47rY1oQvzJ5dZAofxuN5Dt5SoFZdl0r3FyXsCi6rjSQY+9TK15VqC/BhDJcM2rraNS7Gxc/q7vf09sj
 cuFiroH4
 wDHR3Je7BVkg7QNBwsyV77nYICxPtC9CdowBTT6t+KFfxleGFBb/81t4yqewWnRC7/xxk2xJW8kX9W6WyQS9IIWDpnoBwfrrODvwlvEpS8aBPFruO2lKyjHcioUglLZe0ZKhmTxCUwZftNFVU1kB3jQnDDcAsBZAsTDKf0wQdNwq1IR6C10so6ui7atD+VW7Ss2cGv8VtHX4qJ01jx5OwylBS5Rco9qFjY4qi/PjQgKzXRuVv99SNGfIfPkUL+ryz+jTYDnahp1/ScUSvKDmdQ3lTyL0hDz3wYl8biWEYRchaxHFvn1yzDaNWRMLqQ8jWJL5ovzpX5zAjx57UqNk2eyQKQG7XZduBaU1O5qq8VA/5xLCHQwfpB1mXODCK2Yi4/PXD/cde2Hna7Fl6HuMu+5dxGQDJsakKaffb9xMD+1vb01F2zp4zFmOYe0skkcpxC5apyciRlktOBZE/cEUr2DzmiNBa/aLq5NnERnmM+3Sta1kYIxxS4v02piS9BiqT5EW6MfYCptfk2jY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 21:06, David Hildenbrand wrote:
> We always provide a single dst page, it's unclear why the io_copy_cache
> complexity is required.

Because it'll need to be pulled outside the loop to reuse the page for
multiple copies, i.e. packing multiple fragments of the same skb into
it. Not finished, and currently it's wasting memory.

Why not do as below? Pages there never cross boundaries of their folios.

Do you want it to be taken into the io_uring tree?

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..18c12f4b56b6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
  
  		if (folio_test_partial_kmap(page_folio(dst_page)) ||
  		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
  			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
  			src_offset = offset_in_page(src_offset);
  			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
  			n = min(n, len);

-- 
Pavel Begunkov


