Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522DCFD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E1B6B0088; Tue, 10 Mar 2026 23:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BE56B0089; Tue, 10 Mar 2026 23:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDB46B008A; Tue, 10 Mar 2026 23:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48F856B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:37:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D35E2597A2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:37:20 +0000 (UTC)
X-FDA: 84532371840.10.4D3FBD7
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27CFB100010
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:37:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JWvKSVmZ;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773200239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=rHxXiAvo6zOonxHyAewJkbWbuOENn2paNkRQUdILloA=;
	b=wewwt8NhQhuRlXxmy58TC3jJxU3PiF1vVQl6Q0imqONYFAEy2KYcTSOqOhp6rVVrsXfmpn
	Vc5PH/hVGrhAaN4mNPh8LY1m4ZjHRQVRLw5P+5exWoGjf4RxaiPT5UcyIYS9vwQqvTWPXV
	CorcHqlgiI27gi7gIt0vJxqvgvl+V5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JWvKSVmZ;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773200239; a=rsa-sha256;
	cv=none;
	b=lzsJ24cSzav1+vtr4/qvHe3fj2uz9DELeV4jh6wLc0SQn82Lwq5f/lpmlUVmASjROmQmnb
	OnhtuJ14q8b/M3F0Tpk1/NpkMMs5lQWsWFgdWE5PAHSqBHHgtcEu295BDjAlvgTZZBLZ1J
	rnjOH5W3WzdJwOAPb55ghjTTcKiH0aM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-823c56765fdso6861290b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773200238; x=1773805038; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rHxXiAvo6zOonxHyAewJkbWbuOENn2paNkRQUdILloA=;
        b=JWvKSVmZu4DmnGLZoSgNFqa1G7PLorZnbT1sMoH9f+VRuArFjPRbYLE9mgPxyiXn36
         vkiBRwARyRuX6NjQL3Flpkc6Zp7/DreJGBdDjZwh2kJBCXMiKxQwaRLT77w+aQqP4c8x
         ZHG7Gvoqvpo47Np+30CXRAgVzd557MI98y+zOauU3Xo7AUmi7RvRD5X+3qV+hYBfvJyr
         E2KO/ag4SdmCK5yLNZKYMyhI+psqwRVjbVY0abnyWveDY8ofG4l21bH4qTaSzIgAW+xv
         9ezSeZpfRlNDT5bcvTwAJ50SyFV7mSvwoFcalECobhqDy0B7b4g6MVHQWV3ifnJtNqWs
         oFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773200238; x=1773805038;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHxXiAvo6zOonxHyAewJkbWbuOENn2paNkRQUdILloA=;
        b=jPRoKpB7G4Mangln2xWCKEabenXVtTANEOEDAM2dTYBAs5B/5bWcvusGqtXmkC78XS
         jWxterkuyGRMxaQuk9YXgBSneFkyx5jqWKJvfXknJqBiXsFr04VEvz5W4wfqktULwIJB
         sWWOReo2/cbkU9gehy3nonXqJVkqenxaLbJYhwWXZuaaJ2E4F3yI/iCd645iCtYFGdP8
         bSBdyHbxaGda2xWGxtZ7EiFRC0DWMfDhtgLFZba4fmEOzqMXotYXi0t+OxssKYVQ/TmE
         Nf9DmUQowIqM9qXaEyXknLpyiKkSZfoJhGxfD+JoDXwU+fp4E7CeZGRYQKa9junO1UJV
         HgrQ==
X-Gm-Message-State: AOJu0YwkdcpwFC4sQjnEHQASsv8GD11/UBeFb66qfjlhJySnQaZrEAkv
	YIvLTwVL7zqO/OW4QyaccBxTgbKIq3wWYs92KYc9WYxvYeYnMVgNThGl
X-Gm-Gg: ATEYQzyGmlRx/zH+diYfsg3EC7M31FDVC5xnmThCaLKH0ArvLK0U6Bb2CO5nisMoCFk
	uwnp/CL1Jsnq2a8+xrjbTIxzAVgG/NL3vbaLygMeF4qSHG/qtoVImvdVRgx7fesGUV/vBqe7DgW
	6+m33C2czhnbe3Lb+R2EmEsTSlIu1jHiwNUS0wnNzHIyk2p7a0MAUhxlYHtH68kDoCqkZ8DFZQ4
	CShndjy2LmAvkJ9D5iJmgoowoVvo0LX82ErOuPUA1+FiRy5SEYkaEVNU0SKKlxbIpfRPWfMtD2J
	Z02lFpyfbtqfwqK0mvyHVyW/UpVrPZLDZbmr/+zAHK+OX673Qo8vcJhGSksGqKibVaFwd6aEUiB
	T/CnnPtJl5HIhiHSdViW6bHTmLkj0h5hjv89tdgd4qWAa0TpWnvWJr6uFzkG1FeqC131PlBinnH
	HRax66vup6bZRJzdVETb2zrw/Iff6r+QbC
X-Received: by 2002:a05:6a00:bc93:b0:829:7d88:34c4 with SMTP id d2e1a72fcca58-829f7274b2dmr1088865b3a.64.1773200238028;
        Tue, 10 Mar 2026 20:37:18 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6df3bcbsm752506b3a.15.2026.03.10.20.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:37:17 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 4/4] KVM: PPC: remove hugetlb.h inclusion
In-Reply-To: <20260309151901.123947-5-david@kernel.org>
Date: Wed, 11 Mar 2026 09:06:06 +0530
Message-ID: <y0jzt4ux.ritesh.list@gmail.com>
References: <20260309151901.123947-1-david@kernel.org> <20260309151901.123947-5-david@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27CFB100010
X-Stat-Signature: ykpqtgzgougydxahzg87btg8tsdrzcsh
X-Rspam-User: 
X-HE-Tag: 1773200238-872650
X-HE-Meta: U2FsdGVkX1/DoW5QrLfSGQARcLsbLNezLj/WATYzOYZjC3kIUpxuupKjOIuVnAiNcDuKS7kLFGHb8uYvqo2sPAEXoE8n+CfURPYhcu+5sF6JYSirvr/c8NLfDV4EkXWUhWpkdhvv/aBkeMg2eesmFAfLgI4VPRyVLYprCfwESTv5A4ba7up3JOtrwy/rqJXPhjiXayvn7/y7M87o253xvQ8KGAyOW+PobmwHi5AuC38iApNAKGbZxTN6z/R8o18QgbuLe+t8qY0WIBV5nc6ztcuH8LP2dQolOdA4LioL8qn07zr6MQTmxy2qeo4Wg1pTRr6Ft1eMl9NHeH0v8Kprr7WJzCCCGQqG4vsksIN4/EgabeQ15xTsDsoeo3SrUF60+JYAnBL6JYAixZnlamguoUSyA9cfZ1ZLP2z7Py0NHQSQOo3pDLIGVwXjbDmJzVMqeVF1iyV0qOEodBULF4erJRJAS6ZaejdKCn6lbnuBWqlDAT4/33P0/DYsjW9bkqahwmdfV5fvxaZMPqX8+NpgFp221XjsQRodnVkm5NFtU0jo7f5WTyRzNJ29WKZHxZNITrlSII4fRaT787y9aSpvbRS68Mu8M2mMhTfn0IsvL+eoPgzCheruzX+ojfXq8XMENq1Gmj5qazNhXn8thBoAcPJQ/G4mVvNvB1dNGU2XqnebX9GpFazC1oCBQwBHHJ8+NgGKNo/9bBIZ9mcIBDSLTfrHFDAVWepNve8Dsj+sx6L29HwT8MDfvWNa1+7PwRKiDusEwpCORtyaRYBWwHwNzWxKGCQgV125PpVCoU9ziZ2BsxhebD9NNmLXuBnQCXGOLaGUniyaAFplGPYww01hYxAavDpnk8Obaec94VpsosUeWAypVJZhghdvh1BR7qK1rfmgtO7ISZq2z8SGa7lMqkH1qbV4ZRziyRhglyOlncDAaImvmU/79y1IO2AAg1+49G37RlMysl+5DAArIIS
 RiYxXOI0
 BpOmZZn5byV5BB5aZcl6hnDw9rK5Rdo4NHuWY8RrtuASTmtcSG6C2GP0DYvMUUDEZrVX05IlSss72C4XH2ktk33Yu1BzAOViII+cMjw/xrXg/zFlhFMYB/mDtnX4m6g7ovoWgMsw4xipq4S+26brSM2eMFO7F6LlwQv9ehavlZbdhz4vybEdRZQhUqQ7unq5n/7bZrUzFAbJVcxlspFp0xMi9kqMoDqL0y6n/+d9MuyW/czxjqmOQvpDeGI/xRz2upFQwMRkcVXkthxdl+n/HukO2vvjfDJAjSjWDREk8g4scDDv4cKmglfR86GceFckbT4R5x8fN9ojavRpEbXRrTe1wlaVDZN84Br0khbVPLsOVmEJOVBVDMx8IO5alSsXH5Xnquld/n1dYqNnNfzPaespmBkVDVMVEH5ASqS8DlmZsjLprgPZM+IEZUQS2xnnhRsB9GdKhuk2keOWhGeBlGBe28+iJl9J/6bP0Dajumw698ds/zfAKRtwPrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
> to mm.h.
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 1 -

Make sense to me. Please feel free to add:

Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>


>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 08e5816fdd61..61dbeea317f3 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -36,7 +36,6 @@
>  #include <linux/gfp.h>
>  #include <linux/vmalloc.h>
>  #include <linux/highmem.h>
> -#include <linux/hugetlb.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
>  #include <linux/module.h>
> -- 
> 2.43.0

