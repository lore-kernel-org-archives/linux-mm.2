Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E36CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BCC6B0095; Thu, 15 Oct 2026 20:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5B36B0096; Thu, 15 Oct 2026 20:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887016B0098; Thu, 15 Oct 2026 20:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 566686B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:14:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0E19C022B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:14:53 +0000 (UTC)
X-FDA: 85326568866.28.7D56126
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id D13DC14000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:14:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ivrWLP1+;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792109691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2saNd2pf5xXpmgizEGMG+P83blHZRupazL/vtIJhv4=;
	b=pmg6pzRddn0WwEWyvkuBvQwB+cfTHKbOYs6sQBkMfy59C6SSwDkJVNIxZFOEXeM5SaL4cI
	CtNlKJm2EXMLihlMmN8EjjIEM45REXO0Z//LY1PXglhIrD2DlYxzt9Z7a7XGniJPJecqVB
	6lpAPIm6KDi4qA+nEfEdy74+hALEvIc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792109691;
	b=bk9J7I9e6aF+i8TpboNAeGSk4YIbwN/BePgEIyLcz+hLm8C+SdZXcROWEqTIYSbj+jDU+s
	JFoyRlSuXRcufpXlWX+Y51XtsXXgcJR+Hsj/9YaE/wWGygcQxYyth4EWAdlyud0FjGzWC9
	YjnzTASKE16EdxzNz7yhAtUPqy3WwGY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ivrWLP1+;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-535d60d850cso5463551cf.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792109691; x=1792714491; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V2saNd2pf5xXpmgizEGMG+P83blHZRupazL/vtIJhv4=;
        b=ivrWLP1+CK8rFALiKepNg8WV2PKeU+Rj0QT+3qAdPNaRPv+b5l9Wgh6i0WzkHM35ZQ
         b0ZgzfU4flfxVKYlxPhH/yLEc+eExEg7vFoxu5mE84yNngviSmq/+lt6SMtOr2Pi8rz9
         fXrDhX3OdyrcG4svgHd8EKBtkqMj5Vd3dr4vlPGxd6o+ZHiU8DE+iPW0Ia777Qok5+IQ
         5ksB1x2IntrPvNHdnMsUptIgTIER/CIWsfa6hnZA/yZAUDNNK9e0W+dm9FkSh0ABtK7o
         vu8hxaV1NMRfkQ7ADe4WfE6H45XoNsK9/gkLbN+oA4BU8Rr8aPzmgMlqRJoBCAlwPXN6
         K3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792109691; x=1792714491;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V2saNd2pf5xXpmgizEGMG+P83blHZRupazL/vtIJhv4=;
        b=y1JH4sS9xn+vy7mR7vKT31Oi/sEtVmwCnJYpdLELSMB9r4TopVK92CMwHkr79s0Jee
         aNxfHpLtboISDfbryXF4qVfBeqk3iiGrEXTU2fWp0BUlklt/Zwk72aPh2kV4z/BvTlEC
         ilj64tW+CIentG/kdWwBpRoFl0/LDRNr5Avu4Mry2U5KtbeyeWd+veYnpFTCfKofLFE7
         FXsxvrr5rgmazefR4jiojlOAAM647bBXyFg2LQiVKyaT9eFosnSaPxKoUQBjB63xFbiJ
         sx9dhKNAx0cjcXz/K0d3JhQwZmr4sTC4JkyfY0WhxF4CwYn/ZkO8G6zghjOe87h+T+y7
         gtRA==
X-Forwarded-Encrypted: i=1; AKwUvByadzynmaoaCtLLWetItY7UGMdsVC0lBzMmuAOV56bWnSq9v5ISAm+PNlBxvqZtlHiq9pygImZjhA==@kvack.org
X-Gm-Message-State: AFq9FYIGt0yOQFqFmrYsDOTzD4iRep/OBBxu6MJ9OpdQl/uGCl1Y14af
	UjPGxY0C+4fEegdH/6L5s8cktW4pOD5BbLtYh6SA8fnXfU352IxH/cj5PhblmINU+k8=
X-Gm-Gg: AYBFou1ZQbBkXQsU9gEQDzpkCM2lbz4Df2c1t2W7YUgs9h3Js+fA6KPh8lei+CJ5vPz
	eI+XIEca9GmfCi0kAC3w3tHTYBfl+chX5u8tPy6AKtKR1/UtqUmXhsgnA56FE6EqQd3Yh5iUaMA
	z3OSOYInN4TRbMAWE8yH1bxJW/+arNVPL3ED0QIkcPgRwCxXccGrISi3ZwcTscsZTdusi7lXgsL
	lZvPRiX2zGLn2tZ9AWzbYcd68+hgKwh5eZKcsf1UbBuOPR/b5WSw4c+jVNYzvbDkJ/7wb1AOkRM
	t+2d7xtTsGxrnKAGX7aCPBm2xKzzwos8TjktnZaUc+2Ing1whb8jpjLVd4D3GUop8n2ERX0EfYF
	GrCjUeX7gPdgWJkRoAp6etVWiTbX/6gNmW+JVQr1Q3K9CMZkP4IItcyQbsqq0oG5V860t7Og5lR
	XWeZ9l26idyNfNpZGSc3qwpcVFa5cGCOOraSBIbFQ9oWgLSYjZYebCtyS6BGA6UzQh/1VtuoKA6
	5H79w7L+/6jX1pA4KNdt18Ih/H5REI4A39f/bpbICfOLuYNfCG2r9id
X-Received: by 2002:a05:622a:990:b0:535:ba01:d95 with SMTP id d75a77b69052e-536272c2d55mr30900421cf.19.1792109690637;
        Thu, 15 Oct 2026 17:14:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5362aa57106sm7257071cf.28.2026.10.15.17.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 17:14:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHVay-00000000IxD-2c33;
	Thu, 15 Oct 2026 21:14:48 -0300
Date: Thu, 15 Oct 2026 21:14:48 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Fred Griffoul <griffoul@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 07/11] iommufd: Use large IOMMU pages for provider
 mappings
Message-ID: <20261016001448.GC14213@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-8-griffoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014093733.90312-8-griffoul@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D13DC14000C
X-Rspam-User: 
X-Stat-Signature: un6z1h48d6p5reg8z7ntcj5fgfes89tn
X-HE-Tag: 1792109691-682495
X-HE-Meta: U2FsdGVkX18esrS6GEAFv0VLM+T4g1B2UqWwKXYynlB0GTVJ1ij7EjYcI5nplxduct9K/7q76vCgg3GPRpN9HPTJlE4jHLraUiM6gFkTAxbBQeiTeaYg181hSMiFtoL9eQnjZXG1B8IgNafoun29rOQC/xo2QDrFrYpdsMREb4Pl3Bi4uyz/4UnmVmHehVieqcyUpxXqUDE3YKgsagewz28F5bbosSm5pZQfBrmE3hHfK/144TR5mvSJGzkIuCSykiK+SSd8+m2DvO8vH8xLLMHCSDOrkwg84vOeYuTfoUqgm5UdEt5+HFwyXrpffea/W3wKkuQltSc4TbUE2A+SKLJ15PyjNTq0HrPs6OtqlAvp75FPjSg9IOppAYvppZjG1vz99BorKfXFGU9YE2BY+5vpSDmatiG8iMJDbhPmeBshnp5aLMIOsOUIxlZuNUnHDq+QyH1mnFW9bV0ObY8MwU9RnklPGN2OusjM1b+NpY6dPOSBWJPCY3MmBDJl7o7hL3nEGqeO1hvuU+iisNkM0SHBeljysH4bol5ERErTIvTas1S9LPA9My4RlNkA9N4N8GPO8CnPN652sHRh+Xa6meqyVympfOiQyd0sBW8+SK7OrFqBxHsW7Hx9RM4gIojzJjJOcNBAzOgyznTsvUtbv/XSaQZPr1oFXWS/8ted3IXt/CPIL6u6AVbwGknamwZdTYELPVVZwLuNyUBhvb56BAF8KWQdppHbPr5AoYj/IcqdVpMYbuZlfSxii1ziD6myKSxne5uixtxMkVZJOewyXT+Ity4FNC90Tieag4v+A7csygzjLME/O6j52vKi5+LbgrTttw7guN/6xIbdeRVmiKKJe7MNK6MarHcEt/A5BCdQ4WxVLR2PsDYs4IRJFNYkA5mwcevvNvvi7/O7GyzbxfvIxZb6xBcFvfjeFXQnquURgrMtlr2jaJbOd7uSNdZEanrrdrpDzeQjyvEZ9Zz
 FF3qwkz7
 6Lwo0qP6PEOonbjIx314O4OUQTq1gSbZUxVqHKspVB4pgwn/WOgQULG3bPe9iXP1Jvemq1o3e/H6yxNHJLjITxX2/Bg5hwisPl1Z8X08wtrMPh1oiiXfMz/suH5SfHQhFzpERYP8RpCp9EhOu4g3WgCtz8Wuo7ga58RPQAZdHJAR1sTyWG7NBDxlUmMZb8ht/ClzOZL4RyhlEQDmlW94EAHp78B0E38Ct2p2G5YD/i70oAjAisGg68YGteQS39/X0Ut7/nRHVyqRNM/JtSyzHzR3e9/9iGdxUxcWvQGFq79q57t008hdujRAZPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 09:37:29AM +0000, Fred Griffoul wrote:
> From: Fred Griffoul <fgriffo@amazon.co.uk>
> 
> Provider pages are mapped with one PAGE_SIZE entry each. A device that
> uses a large provider block then misses in the IOTLB on every page, and
> the IOMMU needs more page table memory than the block requires. A
> revoke also flushes the IOTLB once per run of pages it unmaps.
> 
> Map each block that the provider reports with large IOMMU pages where
> the IOVA and the frames are aligned alike, and with smaller ones where
> they are not. Only the pages of the block are mapped, as before.
> 
> A large IOMMU page can only be unmapped whole, so a revoke that cuts
> one widens its range to the whole page. It maps back what the provider
> backs now, and a device may also fault on the rest of that page while
> it is remapped. The widening finds the page with iova_to_phys():
> pages that only look like one large page make the revoke remap more
> than it must, which is harmless.

You are going to need to go into generic_pt and implement cut and a
more suitable unmap to make this stuff work properly. We can't over
unmap on conversions.

> iommu_unmap() may not split the range of one map call either, and
> virtio-iommu refuses to. Map each IOMMU page with its own call: the
> widened range ends on IOMMU page boundaries, so it also ends on map
> call boundaries.

Also please don't write commit messages with AI. WTF is this even
trying to say? The subject is "use large pages" and this text says
"map each page with its own call"

Jason

