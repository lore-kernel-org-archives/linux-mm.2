Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F57606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=P1zcEWUi
Received: by kanga.kvack.org (Postfix)
	id 23BAD6B00EF; Mon, 16 Nov 2026 12:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213136B05B2; Mon, 16 Nov 2026 12:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129D76B05B3; Mon, 16 Nov 2026 12:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE4856B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:40:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 423AA12020A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:40:29 +0000 (UTC)
X-FDA: 85441696578.08.E19B861
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55F7A180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:40:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P1zcEWUi;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794850827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjLseNf2hnBu+sCpNnb8CVwZ4cVJDuEl0f+BAYdwnZg=;
	b=XnwC4AVr5TAnbpLdLV+Cj82lMqFqrddQ2gpWPHzBMezkVtDWmegignqsPDb2k3qJnoVzTI
	DsWUTFySJ5hrBFQEKjIVIm7OzhC7TmDhDurfMEoq9WmDsOaaucb+JsLx+LpUZL/6OMLDg0
	3XGzMiL/aRH9U6npCqpAgvQaffj4gcE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794850827;
	b=CkRtJyb85TxzJ63q1sQBGZhymADoL3M/JEwXDphg/zEmQD0HvMQoBsk3EQVEXxawUaUipA
	Sj0L/i3+ldNfpXqLNERSre54STKCNOPFHCKDGDxA8EB+jP2EdkjsI1FBSnU0JEaYySnSmY
	IniW80NvRe6Ofx2Ids8mCxPxwYroY30=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P1zcEWUi;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91e8a05ec5aso57924606d6.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794850826; x=1795455626; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YjLseNf2hnBu+sCpNnb8CVwZ4cVJDuEl0f+BAYdwnZg=;
        b=P1zcEWUi6ywEsy134YSlYjfgzXSjKvY6JUsynyzIQm4LaXodxJ4hrYgz6CoEoBQocS
         8zPaAMEeuAWTvYqseHO50cCVmMsR3d8sgxO/JcvxyaIRu4LM0dXS9NyZ++tOe/ivJsxr
         CxEh/qVtFigUifCvrSASnVQSXG1iBP7vI6WEfculqYz2i4tuY2B4PO/LX5ixsiS8oMKY
         BMMUzxlynCac1S6p2kevFcpVpovfGwSkiBsD0A2BxUb+FUk7xdDw6pUjAV9/VUXqS4Tg
         /zriV3/4DDOBTn47ctiggapnioJnaIsb9p0ID4nuYN5kJnw0yRLFR6XfCIdle6B7qYgr
         MK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850826; x=1795455626;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YjLseNf2hnBu+sCpNnb8CVwZ4cVJDuEl0f+BAYdwnZg=;
        b=MNJCH042oaPK/BlrCWc9gP6uEX6zQ0QTXFEJwrpy8xhyW1/1rvjf8EfJvc2Jb44I/i
         e/fl7VKvnqvTckFRwbVEBjY1Gq3gsuPyCwy3JJKlMQSsrjq9MI2cbu9Jadb0L6HusllQ
         wgl9WHpcEttYrcLO92tdpSjGr3QqGX4rsbdUbRbiE3IWotdx3f6EDytfx05eHe461Aek
         VXDKEnBBY6bhIrGFCM8AOQ5uoW5k5nRuSYHLYqlR+cmHgXUsFsBj09kFdFVHtHYgF+jk
         gE87amMjof+iomM2SGLqgVQEpZzaC5SRACW/Zke8k8gVbNmCcKnIGJNxthdfMr71Rx/g
         8H/w==
X-Forwarded-Encrypted: i=1; AL+hErHTNxuynwTZxDav4ZdDvPEwJdKyi9cBtX7LSO8yNwmLlAmHafwSLx81jot+CjQoJBnanZDCynQf4g==@kvack.org
X-Gm-Message-State: APuU4Z/wpgq2L9E1RKKiiAgLhjH5G4me11x94aUUYCnDi92IaB4XotQR
	4MPtvtqebTC6HQKdZ+IavJCmGkoTPauGxTdL0Fwa9ZNjGFsC8x0f17loFCgO0B9BNV0=
X-Gm-Gg: AZFdTZeoY7hSxqjbUOSLSthcclL9v3e9tkng2yKGKRFIPOLiKkXiLRIloYC63Sx7FKi
	8/exUqjWUc16241Bp70tCmxj5lcHzYi+dYkKJAr0L9PJIcGio0jmnL7uENntKE0BPSVtSAYVtpP
	nb3C0KvHukEmGDvY2keS+6XWCLYPU6oDqSBGumpDIDRQ4L8eXTOtiOwURor/qpfwCinhwWdeQFR
	evei0HP2nlH9JG4EncM5gRnxxm9AMv97NlhMLF18+IdSLyjb3oqmdp7ZFW0cJMN423b1313C/kC
	ENM3Qjmv4d+1/N1K42fPt5rRuY/F3Kber/FfIgOD7vVMCBG+iza5Symqr6isTkf0hCd9+kHELrx
	eUNTKp0ImSGj/YNQzOCr7m2kiI8Q+mAfCS3UK6gX6h5QDlGxwbRPAUJCcT+7Me810A1quuQ2zLb
	ugeGE6y/xSnfkHE1fZm9OYSG+Qk6gSBuZ56caBgTIX0LPD82L9ByThRsgX6ZcqI0UZkyR5uBO0x
	aZDurXyoF+1o7w/IULV9/DmD9+ukOw/pURj691VFLsaRHyT7yUUJ+TzgIJz/196X7TRToeAOONM
	Hck2bUOoJGTOyTeTW5HtXHgobY1G+LPmI+xwycL1wxZMhk2Tz74ipJ21oKfbVh3lqYRgt/wjayF
	d/FPR/ZM=
X-Received: by 2002:a05:6214:2246:b0:914:53ca:99e0 with SMTP id 6a1803df08f44-91f241102aemr180003636d6.11.1794850826464;
        Mon, 16 Nov 2026 09:40:26 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d7b607sm91534216d6.26.2026.11.16.09.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:40:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
Date: Mon, 16 Nov 2026 12:40:25 -0500
Message-Id: <179485082513.482102.6134237207669235151.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 55F7A180004
X-Stat-Signature: udjg4cqbz51skxxw4enke54ieb9jrqb6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794850827-945021
X-HE-Meta: U2FsdGVkX1/j63bWLNWPxQjB1d65XqL1i/8+c+DETFDg43E7ROjD5TETbQnvXwrQumjaDFHsq0kudoM2VDiU7JUG5x5P1CE3pP/49B3U8YPQuvQurO9W+NIn63rlIJxe7U1xcHOwdOsDI6wavYuiiWFq8n0x9LH3fHANsvrWSrntQz6NM4ONnxmvi3q/sPWv+oPHcJyukfDjVslOEvVyCeoGbeNC4JG4UqQK788AW0trc/7kDN1njF7HCXJRj0I1/Yr2/IxVlawzd2KN3wD9GLLJSqOV2WqAk4t/qwT28aB2vjMnE8Kh4Vjes8fARmVXt34DM3nIvir4J8N/cvaWLrLz3CYTiZeP73IZyeaEkIIKehuATlTt51B/DkmQYSarWCpyJR7P4iCl6CCXcVOtmFlStJUczFSPJENnGLAKZTu/RcB6q1x0zS1vWy9+GQzi7D1cQEz6pFNi5CD5+hEZAgao18XLPC/9eSMDSclqcMt290KWhs++SLNSf9wRu4EE5RNl6R70L1lZo/QMTofsSu6KDfBxHK6hd83bPhr3vaJmC/jKWV/xwdEIpTDtDSMxLQvIHuEBmSSLAp3VfON6NLGFFtb4ZXibjSWzfCWm9btFppDTK317OBlby6RTxB9qE1ovzH9fGy3jEX2Tc6UL0GJbfzQoX4h8BXloPu/dvX5q5o+sMhzMe0qI/Z5wiEuSV8YsWMvuNjKA9AF4dciFi4nRFa9DHT/A3DryNKaNQnU5CZwrbPvxPF1gAOcO4TPXD8bp4Cpc0DUjiMmoeqXi/e+iNGR4RYxIIzu9Jyd5jEEgbYyVGgFIJL3T2Se8CHZSRl0G4hhM2YhO1u4Q/YKrrp7Mir6WNrr5K6q5D9Vjrj9NtFjj4z2I5NkLkgo6BhOALnthnjnBSiJYanKXMMulWAz3hgZK7nGXUTYs4pHkF8AywdTreryVcs84urtwdovdCxnYpWrlY2R6/7K/JYH
 XrnsaGfM
 OdHtoSTgUVH42CJ0l2k5JSeM1eqvoCSoI2CghGh3eZAoqq8MvctdF3AzDdjJxOZ6xxNzljbvkYatMJo5aRN4N3ETjMeG/5BHxRVUnvVrI7Ccli9SR+1x4FQCokE+29WyJ4N+hOm5M4MR+bjeOjhPvq4odXrU6PexZ3rXbv1bKGTyxq5awT3RY1/cB5qB1tz0MeUJRUA2TQf8bht6tS8uKDijK1Mtue3PE/B8UJV0CvSPuFsN6cxL8xZ8U4reoxfU5nqqMPomzy1EUOEuLPVAu5OP+TOZOJoOths+i7+BICKXKL6QQ7cM5FVfYjyJgjLjTijWPwfZZhY9M9eNOJj7G0BE/vOCF1G/0O5Z1eVFaHlfHLHpF3fFK7lmb4Gkn6yq6FPrytQ0Yq92jUEEMfy7lAACGDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-15 20:58 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothing
> can concurrently install a huge PMD entry in the range.
> 
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
> 
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
> 
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
> 
> So just remove the assert.
> 
> Target the commit which introduced the first driver able to do this for the
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reproduced by racing faults different mappings against THP-policy
changes. Change looks reasonable.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


