Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822F9606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=T88QAZ0C
Received: by kanga.kvack.org (Postfix)
	id 4A6646B05B0; Thu, 26 Nov 2026 11:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FCD6B05B6; Thu, 26 Nov 2026 11:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F79D6B05B7; Thu, 26 Nov 2026 11:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7E246B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:31:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1C33802D5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:31:57 +0000 (UTC)
X-FDA: 85477811874.08.A1992C2
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A77BA003A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:31:40 +0000 (UTC)
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-67db1f6f50eso7418204d50.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795710699; x=1796315499; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=T88QAZ0CNOwUyBcDlI1ATCu5cMXHU98nMkDH0NdQWoreBgmbiOugmwcXG5TnST6yCq
         AMXTr9HLd6/9Wl4LwSRLGZWHxgCv0m5BiUEfze6Ar2PdOyIPOp4SYf1ikmTN16Qw7I4A
         s+0sDXfTzIB4h+M2wocgNTgUZgXNs8Z5KHEKLI/DeksM2YAIUIl95QiFp56bqDTfoik1
         T2jIFh9M7IWcu0NrEF4RJL1TuoJoAITWCiNaxOK76x8cxdBSvJOdM5G2RjB151ZlCARy
         nc/bQgjEncQkzZ60v4F9OYUV9sZXPwigTo2OMrOidCc+DEN4u+BQYWf/V9obArAUcwEk
         dLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710699; x=1796315499;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=l7Hd5g3CR6Z6GD5o4slvKVx+s81iI8v8QoA97SdglF9e9hv6vfvfCPiNIFbFR+f0lP
         /ZM+sRp3BYdREdDMDZCb928/az60VfwR07CM/St6vHLsyzDokJ6myyeWWxgP0Z+AWeDs
         MyZF60GC7gnyYptnJSDi6uReN6+VpvQtq5jScmnLJxZXmQsb5csEIsapF96tZebT3xnu
         25SFKXuqBIYQ7Sbpk5senqjvJUeGNvyr9+lh+ml4qBOYeV8gW7iT+a6Ka/GW3Rqz0gv1
         sm2G5w2RtiT86XUtLkLsaOJBuB1jws1TFesxXYSmu6E+FVKoyteZ/HuWZmnNhYCDENXh
         jtoA==
X-Forwarded-Encrypted: i=1; AL+hErG0xIBpcI1HFxWmGZhqLP8Bk6qwO1pfRS2Wep/lWUAWzIb3VF1eCQzbYXmiPDp5pHvIJrBdkTrD4A==@kvack.org
X-Gm-Message-State: APuU4Z/AEnGtskTyFEO4O2wgcAT2KcwkLcXFCoj3surQvigbUS/MN+Ki
	1SmVraFKzG90d60iRA3ZShRrkSsS5OW+QuE5ajmretY7jmmkRuvbhvLW+kqDYdTKrjU=
X-Gm-Gg: AZFdTZdFVvOZ3FWaUQWig0256vE3A97TBJyMn1fptJbgrPBkkWX962Pv8b4qGHByos3
	iGQbLRaJxsFM/P2DBxNyTLVsPz5C7VjwI8LXPuP0c/uAREVqO8cughRhjXCXzfQCO0Qu9vP8iUn
	UarDJmZ5wcoLbVMpvLEW3MtrKsIBjmrq0pYPfLC1Sh/gXuKiSvkmQ3k2VyoOb8WGWjCuE3SANM1
	fu60T2WibrUTh+troC1zfv0QJODZFr+XHysPWEXawSO0fl5Gpqh8eTMHVWqX6gEs2BH1aDKa1HZ
	HK31M3n4ANLrQThC0jYFQ/dKZnlc9bQcB85BmiRo0trtENvGgtyo2Xgr+FME2Nr4FdPmEmgMHMf
	AkqA6HSCvUBmalRTgB/Lh7X1iJntAk1D7lra3tkoWfb+sRt3vUdAusym4Al+7+FH6mkx14KgDQa
	GP4jCcCQqSCnQFHfhLcVCr4N313XGFp02erTP/Id8rLjfeeeg//08jeGj6Nvj7RIbQl+b/UsXlW
	g/zhHTZ7zdQNNCK68wk/XyjJTmaoMGQ3HZQvEutIUjYuhl0rzvlshurdGUAXswACObGOHW8/gWI
	IupOGQ==
X-Received: by 2002:a05:690e:13cb:b0:66f:c1be:a64f with SMTP id 956f58d0204a3-67df4444c30mr10219064d50.65.1795710699306;
        Thu, 26 Nov 2026 08:31:39 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a15b99sm192865986d6.38.2026.11.26.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWcNl-00000004WQW-3ltS;
	Thu, 26 Nov 2026 12:31:37 -0400
Date: Thu, 26 Nov 2026 12:31:37 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
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
Message-ID: <20261126163137.GQ246011@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
 <20261124134621.GI9566@ziepe.ca>
 <awhVoDXluqpncgcd@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhVoDXluqpncgcd@arm.com>
X-HE-Tag: 1795710700-264675
X-HE-Meta: U2FsdGVkX1+v/NPCDhgMMRrjtDy6mBJzxuZ41Vnfj8RaGIGygYmvZc82/U6Gdz4dZUHcWhvWsfm4MGTMakBGllYCc0RluWboI9chi++kDKqu8wJlRi5p1dYDJg9wnNRp6yeX2SKKMIAiahc5gpD4JrLY6+ZiV61vzhZI9V2M24l4d3qdUVBRJHEHf8ILpq/uUO8Mru9LFyavKVNmmcG25P04o2mL7cD15BMrwcsOxU8Ru652KaBvkV27Kt+5QtEFZYp8irns/cUbiBwcDJYcOlYZvEORsJ1FyEwzB9nxYupMDypA5ubjgzc4FXp0dtTL5OPCPQR1RWh6QOPcgFEdgvBs7qVx21nDrAdEep7odb22FVPLJhhlzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 03:52:00PM +0000, Catalin Marinas wrote:
> On Tue, Nov 24, 2026 at 09:46:21AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:
> > 
> > > Taking Jason's feedback into account, we could have the allocator
> > > request compound pages and recover the actual allocation order with
> > > compound_order(). That would avoid passing an order to free:
> > > 
> > > void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> > > void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> > > void free_cc_shared(void *addr);
> > 
> > It probably shouldn't be order here, that is hard to use. Just size_t
> > len
> > 
> > And round up internally
> 
> Minor point in favour of keeping the '_pages' naming and order is that
> it makes it more obvious what alignment is returned for code that needs
> it like the ITS. Otherwise we can just document it, I don't have a
> strong opinion either way (only that it's simpler than what was proposed
> earlier).

All our allocators return things aligned to their size, does ITS need
higher alignment than that?

Jason

