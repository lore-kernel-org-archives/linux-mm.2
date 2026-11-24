Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958D1606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Ot0RHZs+
Received: by kanga.kvack.org (Postfix)
	id A54A16B06EA; Tue, 24 Nov 2026 08:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE116B06EB; Tue, 24 Nov 2026 08:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5F56B06EC; Tue, 24 Nov 2026 08:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 608346B06EA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:46:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFFBDA8637
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:46:25 +0000 (UTC)
X-FDA: 85470137130.22.18E7F4C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id D45F0140011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Ot0RHZs+;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795527984;
	b=0/kbuyZvSNy1T/5xHAhjASwDyT7+4itVOVox72KuwtOsmjgGIfKSfY/gbgWNVYJxKMPmBD
	dIPBcimsI/fFkh3V1pnthYYDeFQ0RgJTJnZvTwopmAVllfoqcnmD5aonbnwlzq2WsMEEib
	ltIJSDKozS3VLjG/PhFzXEcaSyTchc8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795527984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
	b=FokTjnSJ6DKzZUrk1HCiV4o7Etkxlifh02wCwYaK9zFqlzmKyUCzldbRo6eiKV7hNk+CZW
	62no5EFDBCXcmkJdJ5lB0KD6Qx7xzbgPuc1K1k4bEuipaf4dKknUZkonMTYUwshNV9oAQt
	xms45dX1tlcONLf2col6VFUGJ2ZtrJY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Ot0RHZs+;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55d2f5f1e26so51198961cf.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795527983; x=1796132783; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=Ot0RHZs+Y0nFBCc8bJAciht3oFRFnITo6Yh7o1hBaPYjTtv8e4Nl1UwvWZ2HkgIVC1
         ncG3yFW1kInAk3TrfJnzNmfMuhwoz9nGhN/xWKL5KNGpCl71QrufRHBX2jOY/fzQPXZ2
         2n3463Ge7ll9eQO8wja3F6qb3LKVGcLyTMYhLfaIMF5Fs/bmp/4wPDmlV4dwtHxOjXMA
         fjT8Z6ASuUw2gScsbV5EYFts/aeeJKR2OPnr1Ck6dtEzCbkXXyjDvtn8To9ov21Ofvo9
         L02QJ/yepUKzufLGOLv5edlv1RNY8uHziViU/ozTC1wT3zy0c+KSkJh0SAYE5OToZYi1
         tHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527983; x=1796132783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=aDQn2NmvVsaMrfUnaqDaa2iFkuGt1KXyP4YIG45ZO6M9U3BY8Rmv8PTTBX3Er9cwpT
         reVrb5rEl2A+/UgXE/Av7UQz8WkGgpsiEDO1LgOUVHBv+X+SDYrQPrGFb6rtRMTM0NiM
         3YyA6f9PbZvbq+6zkQnDGayhYLl8k/F2Wuo+5M06g/WibDXMpfcL+vL1MXJc21kf0qCG
         7IMktORmfzTTm2Y7SHG6cijmMpa4OS+5RT+Ikjcdtjn+9OkvF/0dhUoucSeUPFPbxRU3
         n0jQbgGK7153kErU1caulL5u16eXyjoGxSdb8ZcV+BCiutCZAPX35yOw1ElElF9SIGOa
         kH9A==
X-Forwarded-Encrypted: i=1; AL+hErGRd/pmGGLqCn90mITtTiQKVMIzfWnH+33GrFo4+uKnLOBNoBV9BZax/L+2VvhO1/D/UU/14NAeNA==@kvack.org
X-Gm-Message-State: APuU4Z/R3wGfEIcP3cm2ZSWoOYO8mkvw4i+ur4Fki8EQjQ0hBYG7OTV6
	GFPPb7qC3ZplxLRkQxK088DZ3bh0iQtVhjfWLx+lm+QQw/1tfEnAUXi0WkLcqMAs6UY=
X-Gm-Gg: AZFdTZdodf9mtXh/p0cU7MCTVi1ha1c2bE3nIC5Ak848IuZUf57f/I1VWmh4GZ0uzhp
	7yJCbCKokSRmK8pv6k4AJBdbaiWaJlU2cul3CIaHRf9/D3jBIsLVZNp115qMFV38SW5GBOHp967
	LHlTj3epCdvGHZeTHbyXaGNf+9rJ2jNyLksWKaCwsoPBnj5wmANQHyxxhePxVQQbTcd3+vdOwHu
	TVZcPD+jveARpADVNCvxttUdjm6Q+0caqtGYu7Fs/PvwMIeaAGWBGgV0uvT+BDMM9IYO2nbxDBR
	9S4uLGQ53PX30Rbioth5uw8gUpycpaYyarJLAZCagZbmJ2IOe9ia5fwi25f7NKwkZ+Ym4LiU7fT
	4l68XySK3NrlMd7OLB/5A/wwTwEplkg5lmtesLMmYy6gu2bnlvulRRdt9IxxZ4C6Za3tmSYlnli
	gOPy6v+SnZO8GpuGs9oPfKCjMdOcAnn45c+puHdQg1A1ZMlg9gGBrR5XSQUczN/P79BWKg5yeMp
	zKUZ+JC6JW5DNCwJh6dXUVam+VeCGwMu0+3gs3PFlrZrQhAUxBJXXxbTUiqkNQAEg3Us/MYiesK
	sXugcQ==
X-Received: by 2002:a05:622a:120c:b0:535:a5f9:752e with SMTP id d75a77b69052e-55d76aed568mr264410241cf.77.1795527982900;
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78451407sm128368371cf.2.2026.11.24.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqqj-00000000QIG-3EJB;
	Tue, 24 Nov 2026 09:46:21 -0400
Date: Tue, 24 Nov 2026 09:46:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124134621.GI9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aa4mybbmv.fsf@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: D45F0140011
X-Stat-Signature: ftnddbasxnjqmumwcfxjn4pdji9dgnsz
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795527983-231399
X-HE-Meta: U2FsdGVkX18o9ylKRXW4WiIyDqmE+1R2ZsStlI6/2271+zCy86H6IByiB3xftyTskppfHDQUX1ySmTzzygTPLvAjZvpKgtxr5ko21+OzKJMTfqTzuKCyHq7nfczMdLbdmPPNvGHSXQ+JfDdaf5FDRVwRkgbWQI/50l8MmLBqOJnQx+UJihdcRXj4vMb8hPjZmfuJSYE9G+Qz7ZGpgSF9qcjEWnW89xNbgcPVRU19A8/vMvnYhEzjY1B54h8X57tbZx+6l3jEEvyKTY9ch/+2LdJxGv7vYp5WiWT+BZ3plmBWrtdusQ98KtNU4A/tEBNAbmn+JcDVqZu/6x0rkQRF+kdsiRmIJXMOkNZnUDuol7ni1aYd1MF7h9AWyKLHBWHW1VRHonD532K4tJkVHmvb6vI+aqFr53rV31wwbaCw5VyT9jlv/5BWimU9NZ/xF6EzZb0cI05IPA8z35wMDsOTgGMCJdzqE2kOQKNTusSUrinAg2F4lFyHHg+Q+NciAitcaBRBBjmHHlDlPLSjUE7YwGQPi/UkdrGg2Zbyt0G08YuXT+Yx3O3QqEQk+jg48jym9Dz8EL3aIwOLxAX7cy7mVXxGHIGr4egVZyP2GNh1d7l1cYMLE1LIfqf+s0Qol3AppKfrXRfqNlRuu5a16+1pCxKOw0jjSEvihrQCP6ZBpvNbo9xjRQeOVKO7fLGlo/qoOl9Lc/zA0AcmbVlYHdciogaV4VxwAognmrlm6ojlBUVKv/BQK882ngd3vCBPSedhbjK3BxumvEOv9d7JhWcgzraXWD0GJm1Tw/5QAUdUREuMbrJgKTkeWlTzXgAEeF6l1Jd26mJoQUwFjoCDizYna1ae9NMYNj3OOLs+vLKvFRi7kxsMVsTimmp7fVGPOjxKkNBO/jdH0ukwIVOZy8lE5g6KCPRq3iMkYkiUXjTkb9RGrlEZEGS93pLfrYgqwhLmsyq1edrjQpbXrJTOwmi
 GWHZQSo/
 lJJxjU20wC7HEqVrCEZVU/yHryCUh65VT10g9jVAnXc4/IFLetFcCBUfXV675UyvXsGtiNkzviecBZKoRrEfI44aOKgM/V1vfdPeVtt9eJSHuSTtqUsxWfAX6oAp6kS8P07PjS1JGNokwxhDz00DYKbb6EUVyWXwHI+djJwZhS4CYUWrA//x783X26OUGEWq27zt/hH2YnXOoyUDaZt0SWIvLig1Gy7ZnyOjS2VfliiUrWycUN/k5Qkg22mJAGf+CRnUido7sdgaTHQuq8/xiWZuYRP7vBqPQEcgbEDGNMPYL5uFRdOMb9b3aSd1BWz1Q1Ao22yGSbdIVASDwp1+Ykrm463ty+idxXyH7urSsyxGdCcVqhrL0Pu9FIMI5r/I2pk3H7/GTCKwX623sMPeBLlfEagZMOnxijdHGDy8OZgCXVvar3mdtU0uoOHszCkZZwOGydoE0MADvnbtnulyvfxwNfE3vGp1OqnJ4gDbSKgjUGgUcOvlH2KuQOfFUdvHT6K7KbUr3crLnOQ5JR8/2lSpsEPK53vKHbA1aoBlLZFq1xStvyWPAJkpvmJah1+OtwX0GSQ2n7GDulviLNr1K0PE6wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:

> Taking Jason's feedback into account, we could have the allocator
> request compound pages and recover the actual allocation order with
> compound_order(). That would avoid passing an order to free:
> 
> void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> void free_cc_shared(void *addr);

It probably shouldn't be order here, that is hard to use. Just size_t
len

And round up internally

If we ever want to do some kind of slab sharing scheme then the API is
already set up for it.

> As you noted, dma-buf would need virt_to_page() to obtain the pages for
> its scatterlist.

I think that is fine, other places working with kalloc/vmap already do
that.

Jason

