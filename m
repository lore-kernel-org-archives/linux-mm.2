Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB0060A2638
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ctkDejQj
Received: by kanga.kvack.org (Postfix)
	id 9021F6B05B3; Wed, 18 Nov 2026 09:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9C26B05B4; Wed, 18 Nov 2026 09:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0A66B05B5; Wed, 18 Nov 2026 09:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 509C66B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:12:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFD2CA842A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:12:21 +0000 (UTC)
X-FDA: 85448429682.01.365897F
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id EAC1640010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:12:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ctkDejQj;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZUtL6/Zh+PGwvVCL/LrsblWzIm0zKOhzUlFpTCrzCY=;
	b=d2mzYLQ3ZhhR7qS3A8zeUly+ynrvbecbNMMefqAh9KpJlPw2ZJjIH5BYDepLiwhFt30Qk6
	SSCZXHnt6K5NebFRlKLwngdab3hfRTpW/y5ZwTSSKr38wn/aXjlrncKOPljAi9CQesBHLX
	6iJ15u2nKCdU5BIqMiepfD2yXgo35VU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ctkDejQj;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011140;
	b=XCEkb+ICV9tbncBr3KQUVCm9m8zmjalIVS9JE1VV3GQEAdIcxRDUJq3reN8IQCxwj8xD67
	8Kj2JVJIPjEkOjuxAjhnL3vUk66oCx2TimQh76wAT4Brm5gVLOWuLLamOJkCowR5dOOxmU
	LWT/eNPO2CBIGaj9pMCknagBIVBJStY=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-94999a08973so106680385a.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795011139; x=1795615939; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aZUtL6/Zh+PGwvVCL/LrsblWzIm0zKOhzUlFpTCrzCY=;
        b=ctkDejQjXKd1WudD/wdH7lJw3+JsNAPzJBMehlacEZavY3ke6finp0HjY0EQcznMPj
         x6SnkptGkLmxf3o4PvQX2edFy06neGRQYRwrgQI+ostfEI2CJcvrhvYaRpVOXy/cgEtf
         cD4PCPmHVjwwzjoRZxGHdB9YMnOZ+6XdU2ovHVjjAq8X9R+CupB56x5DbCts96goN9ZO
         4HH8Dmt3o9lJ7GgCSlOQufaNrWrvXVrGtvURLzKlW8zhsGQomUaNHMbDlS/vIgc/h/ht
         gfR0P+NoiWAMKkCdJZphSS8IuhmyQNB/8zIL+o6CjWJWEwua4BtX4rOl2Lg6jP1Fuabp
         NY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795011139; x=1795615939;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aZUtL6/Zh+PGwvVCL/LrsblWzIm0zKOhzUlFpTCrzCY=;
        b=oWBYUMiU5V5DOZvpCE/Xg7SpS+34nOXOiJhEYrFOwEpf7tBauaWuI2z6Kh66Xsp9y9
         9kz8wP7vLYgdNbmHSBVUhqiy2zXLF1n1/GDLlzByPzV6CbW5cLTDuCEeJQdv2CRRe51P
         i/LroCPKcwBRyxhpfYbbOXcvI+MeiPhWng4eP/Ou5218QOzIFKQI0VLFQBzxyQ4CRMf9
         SdLC0B3gbts84c5eMIQesEwKoGQkQfnE+m5KDtZWb0vWLmUUpX7qB51Ed7ZJYJhNIlH0
         d8ZuYr4AjnIj9OHDicY0bOGCBl9eMeQ339z7k6hWX2fZGREW8y2zQRJVmmO5+sX5sEjm
         BVGg==
X-Forwarded-Encrypted: i=1; AL+hErE6N7xqcoJxBOW4BQ3+PmAsjBVNc0XYh2n3YSo/RS2hLo3sByoFh7EYoPS+KrdrMPbxE7QIUQW3mg==@kvack.org
X-Gm-Message-State: APuU4Z9xP9CEnl2BpxpiLiirg199VGRIYiFHmr3vs8K2mqUBddaDdumE
	LkDRXjq9Ji153e1FY3OVsYDKF9VRtEjc4Q95fFJCU6lwv2GJyUAPRrsUVC0xpICNOjo=
X-Gm-Gg: AYBFou05tLnxUjzdTKy2+h5RMy4wGC+yBXtapX2v8b2Eb483mFhQ9OuUKtfENnB9DBV
	ZIAbarVkjfaqUPDsPGcFN+zaXRM2IivXC0crunTHt7oUs4OHaxcDqwtz+HDG0RzB36sOI+s5Yxx
	eQkfpNZ5MXmsbyDmuA6zcvnyTpIrQTG+rdiL+wNE+emKt+Q6mYyC8KcodsmOvXSCjAp7qu+PbuO
	tGNY6S6NkzBiDCr1qpcuqtja7B3zY5MnXIfEpNHxlCkOK4u+DYZJfrG+m4ZYEMQK+unb19of1Tz
	uR6fN0DFl9/zfpRAM5TyeQrGASXfCaHQ3AkyZbVxLMHDwr12CZjtvqo3sF4BPwdEvHMGrfsi1Rr
	Lf3nV5zJFMm+mhHp1G/1ihgOfXAj6/PiIVdme5lWWKWVeqSpb9cTZMZbDR18/4k9h+jNTXJfk30
	m8vypsse6F4F9VhmphFpDh1/IrUyhypUbds3pDHQROkNiOs2+7CKJzyRtEVbSW0J5/IRqWaMRhg
	xUvmE9TpWSDxGJjGcGc6oafwyoc0eE0MRTbYqe6Ixp2J1itz+KnsLatHEHqe/GjZG+1+5Xmx6fH
	W7SNZHF35n0ft2MLUspNkDx4aoTPu9F0+R+s1ZPfCi3R8w52SH7Feq5cw783mYmRo0vvOnCKogl
	aPiMaLOo=
X-Received: by 2002:a05:620a:44ca:b0:93f:3163:3e25 with SMTP id af79cd13be357-949996e2da8mr497886585a.24.1795011138732;
        Wed, 18 Nov 2026 06:12:18 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b454facsm191203985a.5.2026.11.18.06.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 06:12:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/userfaultfd: reject DAX mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 Jingyi Sun <1045704958@qq.com>
In-Reply-To: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
References: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Date: Wed, 18 Nov 2026 09:12:17 -0500
Message-Id: <179501113767.2932576.9608927748315673286.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: EAC1640010
X-Stat-Signature: wyrudtj4xrzuoyhau3c3ofx3acuhtzjp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795011139-769755
X-HE-Meta: U2FsdGVkX1+SkMPofgetTYnyqRwlv9QbJwLFaAaUO/JvGE0YzAwfZ2Cq8q2KUVEqa+sgV3LAaW3zio1okl1IBjgs/JCPXRxGglWYzUcf72s28BN3V12aaQwQ2rp5A2u4zeAIVLxAlVbk98KPC+u17BJ+PRIrYmhVheAKIf02tqWzPkE51Xsw/yJYz3bu+sMRwfIaG3RAUYypYyPXqoG8UrB4HGmmEVhpeEIRrtE6Ig4SgGrLgclec6tLPDKwhnTCCieuNufql34wQc2Idoj+IXu/L5qVSytrIP8FPX+/sXXXlulYzrSm6hPPybBw6bpA8JPZj965o/qkkgnunWjxrGfeZmBatcEdMzoXgbXu0Kw05poll7iVH+XdqtoNZM0h0pc1wPovxd9HBpjT1iYCWNJ99twW6V7wlYjrXamjV9A/KK4z/+JD1gUO/jc4YiN2MmtkI+CWC93sBm/24eSV5ofIa5/d8dv8oQ47arzSCqPazBgG7RQpGJSjevSql3R+rbB4a/B5HG3aKpQi5mClL7hKCe14UMBHiemWQAx+prxF7Xj07NbGyJWldAljWrDJebBeK+bcsxa632I4fIZdluT0gGZ9F3W2Mm17sJYmpXCULdEsJPu8Z2hq2Wg7EoXHSXioy4lGGwnkJFM3eB61/UYqa7B1e2gR/im7UvRIOXUddVMSDt9IJ4ibVdxnqFyridjunowHz/v4rkQqiDbbL1EXaLCYQ4zJBlG9W3vl4jyUiMW+T6v1ttBDqgOA8fTDnCUaybKyQxQmSdVDU7lg+YuOo3Bc8O6kSJRGrsrxNHHA0JpyCmZnUkJRv1FtVN9kF5YJMJikQZAPqkZZq3imVLCwLpDRsfHj5cDMNZSd+mnY/Og5Sv3WDJiPpUnlglZyaFOTSYRlAouGcpDdW5k42WpyT3Fw6wc6S1MdGITG/XkR51ZR9Uy4RA086+dBUUU0NRt5gqLWuRVPuXpFTOw
 7Ec0krPC
 OOas+dc1sNIYrY1KtyYkhBRqYm/olh5R3yCTrMNKfZkJG4i1AGQK5GDrFe+HU560fBTZrHfoeLX+Mo5kMC4EcJ0yAjRvszWjfGmgRHpodjmYBpeYkginaZ9rWwY2BjFGfIoSXxd3rQT4VL9hbmh9jntW5id0LOhcRo7KUcHMgIgMvMhI4gcYZwGWzTq2ZIa86rOQAMbI+KiFHsl4LGq63Jj9J/loLstTWrPe6tQ4bHwPLFgV4eCT779l96muKu1zL3e7/YmIqSDuPR9cny+ne/2Nr59xY6dFa5GwJn0Y1gTmsOvIxP0az1BkqQ2BCWJ8zfT7ohcy8wAN2iFeC5qteA2lNWZ7aOWohoKVIKI5EKLQnass=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-18 11:03 +0100, David Hildenbrand (Arm) wrote:
> UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
> write-protection, but the DAX fault paths have never fully supported it.
> 
> DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which
> treats any non-empty PTE, including uffd-wp markers, as an existing mapping.
> A read fault on an uffd-wp marker therefore returns VM_FAULT_NOPAGE without
> replacing the marker, causing the fault to repeat indefinitely.
> 
> PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX write-fault
> path can make it writable without clearing its uffd-wp bit, breaking async
> write tracking.
> 
> Device DAX mappings requiring huge-page alignment and cannot serve PTE
> faults after UFFDIO_WRITEPROTECT has split their huge mappings.
> 
> So let's just disallow DAX mappings in vma_can_userfault() entirely,
> making UFFDIO_REGISTER fail with EINVAL.
> 
> Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Jingyi Sun <1045704958@qq.com>
> Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


