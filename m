Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FF5606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=syFxrA5q
Received: by kanga.kvack.org (Postfix)
	id 8AC506B05B1; Sat, 14 Nov 2026 12:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D636B05B2; Sat, 14 Nov 2026 12:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C096B05B9; Sat, 14 Nov 2026 12:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE066B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:45:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A649D160402
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:45:06 +0000 (UTC)
X-FDA: 85434450612.19.E1F1A4D
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id B248B180006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:45:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=syFxrA5q;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794678304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNcZMolhjI9akx8wnIcso6bAnFZ7LtMgZRZy+seyfFc=;
	b=zM2Izs7jbnUma8GBM0W+gUN30vFEClr+2D6oyTzZluR66AY/RY5mYuZJ+a47TJ/Y2OIGku
	Soi8ofr1cnRfUht05A1IgZXJG0CzjHVxQHIAa/EbRYefQyleDc329Nlv96k032PrjjcpAF
	tYB/fbzcEqlqFB7WsGMFuaMsrdiwXsA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794678304;
	b=nmpIU7bDXMgQYAouRUsK0cmWrQK/j2GZu6xBKkEPmVIgHWPmHeqUXixROg4bEn32zjmt+u
	fQHuM0g+hlNgu++wsMlaBIBMUK1KQLWHS3xEbYA6m8FTRKT41W8jVGl2LCJyfWJD09koxA
	dvObY17VjTMbt6xMD81GEVQOokKj29Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=syFxrA5q;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c11468b5fso30764366d6.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794678304; x=1795283104; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZNcZMolhjI9akx8wnIcso6bAnFZ7LtMgZRZy+seyfFc=;
        b=syFxrA5qMjTsNolcabFPfpNVu58+bG5hHhBEBXQm2xP1q9K2wJQ/DkWEjv5nmCuBbn
         ujqSBKyPLbHrRof52uYxUXyZPwbz8VPxQfuYZPGbqsmSw+eqgmkc6x0b4hL5JN9HAp8y
         T/K630m1LNPZk+B9hdqaOd+NskwevCkhxLgcPkggk5QhD07VABf5rGhicZEzJAa9pHLj
         uUGepr+3pZ+AvAkiivF4TvqIZ1v1WQYr/7RS9pOOjhs1rHrnYKQCgodqyap7h7soBYze
         tEoY0uK9NBnrr4yplVNAz+5J29Tt08REb4lSnOq6TOAZx4PYeODrYXgO28yYHwigQ0w0
         S3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794678304; x=1795283104;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZNcZMolhjI9akx8wnIcso6bAnFZ7LtMgZRZy+seyfFc=;
        b=kHAetJntJ3f1rhtrVRGbK0LTkSiWZ3dzbW8pPQZWUp10kCF3AeBYdaEtwwtTYY/RLi
         +PeZJxz8j8MIGMMORQO48uHAhT2sliSDppMG/keAFEpNUT9ZszWF2ydYwJOoObslMvQ8
         sx/7FD5yLGK68tdfPZD3cCOcmuwrK0PL1s7s1Qz3TSJ8i58yTJsls+J0AXsYkDosGp4H
         u/D8E8LKqIQ8VIRFOmk335Qwk7a9+NCx5GdFYBzg6MdVYEnHwBcCZYHaKJOjk8eTQjKa
         7vhltJnzen6Bk7hIHyYuYbmA3arH74m6y2dq7+drd0bLHOR37P4mBymZcch5b0sPVXG1
         Wv3Q==
X-Forwarded-Encrypted: i=1; AL+hErGbAiIV7SQSp0ml0O2E7aMMg5G9iOs3w4902Fd7cfMtxgFEzstFiG96EBUX43LYejfrma23sFLw9w==@kvack.org
X-Gm-Message-State: APuU4Z+x1XPhEiZBfeyMTbByO4IEaTliZWnP/WRWrpa4Se573T5KKciu
	oM0R/Ob81EpFzqKtruUJYOdF6l3IHnpy864CsF6oUyVJLUqLgUJklnS4DDQBbtKaqsk=
X-Gm-Gg: AYBFou3/i2IzAuzpQIuAc7kZtCFi+mNeKEkkb4Xh8xa7Jv6CKTSZUpbD0fQVEF0CG8S
	X4CRgdeK99VeSAUSRsr5lCQ5r12ok19OoxRXb7l1S7tWZ5W1IX63W9CJuTcxGCVooMP8CKTsyHf
	Xth1ys/1KJMoouBIJkVb+mUJiUXgI9i9pnaLHcbTaZGA3CplOX/KEu/0whA05IfYc/Qh6WPhCpw
	KO/tqmGGVDQu71G3N1Ap6POz16/U/S9ORkG8y4PnQtMAIkK0fyhVFUWie7T0SkUCLvgSzwUB5Id
	V0lsVIy769dChLbkEotHPo8tiLBUxvVESl5txZEYpoYO2pmKjE4Q0eLTLhIbyh77pPqEMtIorjq
	NrhrYG8JY5plr4KaiD2pjtV2sB+bgOZEGKy0t4AdOtbjaCGE36tZ5u9H2i2z34y86FnV9B1sIRM
	hNmTivClQpDh7EZGKCiYkUGQ+1Evn9g3i6AsBjZ073DjH9hik08WGIvBsxVsmj+ReJYCAjOQKm3
	eFbQTOjFzNEmoxoMbtQ4k4f2xAo3RgFA2ORDDTqaukgxDdbDDFzPQN73a0njkxflRRvU4cG5vRG
	ijKI1hHkvgXtOWQCLNnau/rGpC0vSpY1QuThUVb7V4mA2WInrb29rMZp3ppm20AaQ0VxpkpWOuC
	lBzQQAGg=
X-Received: by 2002:a0c:f409:0:b0:91e:747c:f833 with SMTP id 6a1803df08f44-91f2424b367mr92045736d6.46.1794678303872;
        Sat, 14 Nov 2026 09:45:03 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d73258sm47539586d6.24.2026.11.14.09.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 09:45:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/15] mm/hugetlb: keep surplus folios that are
 reserved
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@kernel.org
In-Reply-To: <20261028-fixes_hugetlb-v1-12-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-12-a0a033db180f@kernel.org>
Date: Sat, 14 Nov 2026 12:45:02 -0500
Message-Id: <179467830214.482102.2328406932805572650.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: if4okhits3ekizrbtbzzr36n7zbeskdi
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B248B180006
X-HE-Tag: 1794678304-75476
X-HE-Meta: U2FsdGVkX18aWbFfBrFhUxwsvaRgQfXxS4Q3vtfiVkDIzv0+LFiRj/rv5DqhmkbOVg2Dp0qaMYVuq9bZsgCWOtPH58EAMg6L4g6065CaMA0/NHyyYOHR3IICPxA5qzchYyoZM7RgEt1B/9mbKiOwxGsgO4/Rlpv9z4gUs+C9eC9SW9FuFru+ZvuECjwDV3nsrmEcMZlHMp41wqkvmI3y2Ya1pApTj1J4eLU0DFexYf87L5MvE/Ne+wEmXzZYttcNhsqpMKq/9IoZfGOMR12zB4aYvICXmfwUPbn2+aBsUeP3j9fMbNkhxbs+GWVW/9cCHL5dhwTjRFxBPc4HoW5Gyxmw2kBmZJGNePSYD6QMdHCFZeAvRdhmxnl27Vqt5GWf1Bmm3ldAlUPUeAom/qwWj8Tg0ikxv9fDyy/MGrKndoc7luqEhB5IIamC7HaK5IJSaxpeaCPLrCFKEwoxtO0fBAtKDewbGgpd6lbgBKSWeKPiRpSGQ2P7M7owVyEKFDhK0C/MveERYB/jDwxubQYjUfS606BdGCQ8W1+jQ3/7tKk5yP/bOeFdf3PQI3cMggMlPuiYsqbEn1mQ9U/oHtajNhPiqMEv7IBOAy9ycomUFeGzFy2We5WL7hWbgk2n61GpWYiCCSG6tAHN67lZuJ7Wn25N3vW3Kfo0p0PTZKUbMSKfGS+DX4MwcOpfXPTs9V3Yywj3QtNgVqd00mwhiP9t18xk2nYbhe9fRjAuNRphlkuC+ODQkl3p15idOiepF94N1zI/XfdCiHUjslP6WyUWywzOG7psyGSqND4eSO/7w8sJoi2TKumMzl/bv6C/btl4ojR43odxmcCjEoWK6iV+SO+nh/XiIhHg2Ej5BMsUuwG6vQEHwSPkv1Zn08tpNN5FYZFdnkLc5r7VgT1mL79KG+2UZzoKjMOmzyZKcHdJKrUjjUdQmhB17VLC6hfgMfBOfDTwBWxXMdrn1L59EXe
 nrtjH5t/
 rO/ZMuMzJzikxS/aDqARkhQQ39BwGdmTzFDm/O8Oy45VK58VBpy/LgmF2oXRDkcaByO2CB/fnF+UFdAjAx/yjpxTSQHm4FTJ3MF8fxxc3sxEAuTVBbmOUytqJC2IbpJQAAkpgfZkUke7vg3gPWOXgkI0b9Y8sfbyX0I90W7nlZSkdBzybLR/unUI0oS+VAmpmHWyHzfdGnLG1L6JWZStbaZOcF/8745Zkh8HpixBRBE6sbwkS37Z6/r5deJpnZ2myoofE4g5nn18MXAl6bVsC46jWBdBQB+FXabHwCVpPlbFPRIg6GHEHRGW3YyVZTN+efXGpKY5Fz4T9EOcgYob4/G4AWq7jja1Eo5hQXJSWUXKDbKnZ0nlkRndU8aAaUessX/V+jRPvWjv4kLoj2+X7DHAAvP9fyKJkpcPG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 21:13 +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> free_huge_folio() may restore a reservation, but still returns the folio
> to the page allocator if its node has surplus huge pages.
> 
> For example, start with no hugetlb folios and allow one surplus 2 MiB
> folio:
> 
>   1. Mount hugetlbfs with pagesize=2M,min_size=2M. This allocates and
>      reserves one surplus folio: free=1, reserved=1.
>   2. Create a 2 MiB file and write to a shared mapping of it. The fault
>      consumes the folio and its reservation: free=0, reserved=0.
>   3. Unmap the file and truncate it to zero. The mount's reservation is
>      restored, but the surplus folio is freed: free=0, reserved=1.
> 
> Besides losing a hugetlb folio that is required for a reservation, this
> can also make available_huge_pages() underflow and cause other issues.
> 
> Keep the folio in the pool if it is needed to cover reservations,
> including any reservation we just restored.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 07443a85ad90 ("mm, hugetlb: return a reserved page to a reserved pool if failed")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Was able to reproduce the issue and demonstrate the patch resolves it.

LGTM

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


