Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62B4606A334
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ywu0UgES
Received: by kanga.kvack.org (Postfix)
	id E3A566B05B2; Thu, 29 Oct 2026 10:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12556B05B9; Thu, 29 Oct 2026 10:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00CF6B05BE; Thu, 29 Oct 2026 10:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAF9E6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:28:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 207FBA7F4D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:28:02 +0000 (UTC)
X-FDA: 85375893204.07.1B2B2B7
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3875DA0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:28:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ywu0UgES;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793284080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gO96Ic3QVCctvLn6OTuZFYeIzqeAoDK7wy79tyihoyk=;
	b=fax5sXUdZoib42hjZQFSzY5fm4OxVM/ZD5UOOBU6hFtB/jW39ZPszIyZ560kMu2qLBMETN
	AwRaH0xv5N/Yz4qTn6gOAP1xQA291tk5wOUcOjKStdxFUwhccUTRcnCEKpJipxWEN+LegJ
	dBnhqrCgv3cJjJ4Bhb+/InAPQgtGRLE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Ywu0UgES;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793284080;
	b=c+a4E8tF6EDvMPfOssCKHx91QGu326Zev+kNJd1b6vsP7zpKdNZ4/xrAMgSuyrPX21z9FM
	5sDv5l2rGO32nVP+BJa34fAwZZGi2HbwXs9VITkDvs5/B+M4kyU54SuHUjVOAfJpWGUulM
	HsBM13oQAKXEGj8j7LVO9PpHQ5Tc/uE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b4a13789b0so1091718a12.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793284078; cv=none;
        d=google.com; s=arc-20260327;
        b=L7nJPTw96tPlQRAkEAGaKFp43WHibBiym/QI2I3BrEhOIIKwuEo/mAXBYt5qPSwooA
         UlJ/L3pubxo7mjSo6U6vITLSIqtcOXrCc+6VJwhg8hOf29CcSeZFRlMIn/0wog05Cqri
         mJg0yOuI6eT5Ww2n61/6qUBJhYNEz19pM+ZPHyAXwd2F8nu2kLugaoW6STcMYw2iI5ZT
         /+yyrs48vZblUzKA+1YJ9EFBvjGS5le4yLCHK1O4qtpjQUpEhpS9fojh7wrrUAgZeBoR
         YjOWC3LoXhBoEH1MnSgq39F5owD58O3lknf1PkdRk1Y212JUUhL4cPOT25e49sI0b0j9
         W1/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gO96Ic3QVCctvLn6OTuZFYeIzqeAoDK7wy79tyihoyk=;
        fh=KcA7aVq6IT6Q/s3+5AJmn01rCLItdqXNFnEsV26qO6I=;
        b=bkpMVmteXOYeEaIE2gWSXA0i4WiHmN/xCswoxJp6vkKWIun/XRRyFXisaLAshFTX9P
         h4BeIvDjFW+Rw/HM5pZ0IpeVSJoUn1ljgukqIIRuvJHty1viMnUV6qKIKO0BcmkFc5JP
         IKJWvMKeljnZJFzDgN0OEJM/RKj8AlRnaOxXg3qMpNAWXJR6MSitCOuOhPj+UfXvGxHt
         JGwalj8h1F9xwFPjbgLlY5eS3L6HPKxc/G/UjesMR7tlEvjj9AnkMoBpsZ8l8QoGnkpn
         2eW47LvViUsq2Ez02duuVKi5zQO5MUeJRLrMTe/JY+KNpMxm9yv8XAKGQkDe7pC1Uhzk
         LArg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793284078; x=1793888878; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gO96Ic3QVCctvLn6OTuZFYeIzqeAoDK7wy79tyihoyk=;
        b=Ywu0UgESBG0SBJ7qMBBftD6g+c7Hlc7ThPzGRmqUlI7lDuH6ly8JmDoU8dWBf1DQOD
         I8REF97gYO/IDA3b/Me4n8AVdo3QLCz83+2SZCzfcRGIW8Y6NvZI8qB6jTSsc5bEmqzD
         esLlmVS6X/goNqJRYBYWw+pbN1BUr4i/AqKyblXduKoj5nTOsi3otOq+pXhI2w9sjmb1
         J8zmTpI9urzyFw4he3LtUKayB2fbjGE6GRSYeAdasVSGujA1X1H02/rk000NVmSJPLI/
         yyQrAGlD5A6BQZj9SojXJ+6gCSlfbE3+B5JjPhQgR7PkAJoCWatj3DHTqsFaxeD0H9m/
         yz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793284078; x=1793888878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gO96Ic3QVCctvLn6OTuZFYeIzqeAoDK7wy79tyihoyk=;
        b=dUsYlRH0xELREXLnxkj5xEcUcpBGtHVZNCrVO6KNwgvYOmY29Q6RDMYpQDN5DSQCgR
         Y+apXtk5u4OR8bXlU0XPvYpbWt00je2Xmlsk+QcJVyHZKGf8Hhwne/gPdDAqXG4V0fq1
         R+6La76csE3NUxQxH78PJQBhL1qcd/2+r3FJdCt1p3/U3taFGiiCq1QpXxe1LoYo+c9b
         D8gf37JLimdMYTFL2qsm7bjaDZTZWznmfxi0vFpvm3Bjq1hh5CzxCHkyrcTmh6YEyK1S
         aLNXJKvnnN4UpIzzo0Fq+VY2D7iP6+GaB8GMh+ZGEiuMxALymiZzdcdvoEabtALnzRzF
         RKOQ==
X-Forwarded-Encrypted: i=1; AKwUvBwqllNHZcnkaYSBVK5h9c7lUFEYgd5YCVceDAla3/hniOlpwk1QlVnATpbPd2/AwTyC6crrIihBBg==@kvack.org
X-Gm-Message-State: AFq9FYJzMAtsCIg2x3Kb0sje0UqpV2iC58HjPMYKeF7it5/4zAiwJHRe
	o2nRo8ii3sP/F2e9m0jw2CaAIFhVADYEKZfDcGauKsLxV5qWIrTheQIGhUbeRCE1CheAx5Lu0vJ
	httXgjnUMwJGPZ7yuYiZJG876+pji+oQ=
X-Gm-Gg: AYBFou3pTw+Pql8kaKLpKutWjeGCJR3DWuogoWE/2F0V6PFy2EE5/C4YLwiLHiq+9O/
	ssjHxd4bcFif+0K8IVAwSpFPet6OaIHLLlfvJ/d+Jz+ZrZzMFT4ruC+H3wZ6aDQIJkGDvsvFUf3
	DVX/99lYS9pS9RctzQWmEYlGClqnoCRFGCjdFA+/OrIfAeTLp7KNnbZLYyGjDWY1FTqEAYbk8sG
	RAV1vKRr1kRdDY4346D077D5d8lU1sTG5WCKvSsJb/LRvXhNdIJVMbOw9tu6h1acuhJK4P6+W+x
	ZQ1pUUZDUnGOWXw6YNNoXb5rDiIxNfA9DG7RWHjuY5I/WMassbRph1kOg1Ij1vHg1l03gMsTu1l
	dEWJU5zCFbsnlDbn/fpxbjsG405OAMNOHVe7DNqDVJQt58HnDpSvAJkY5N94ir8VfpaTBQw==
X-Received: by 2002:a05:6402:4508:b0:6b1:bb19:de98 with SMTP id
 4fb4d7f45d1cf-6b4b0b09dcemr2163933a12.1.1793284076799; Thu, 29 Oct 2026
 07:27:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com> <20261027154649.91571-12-griffoul@gmail.com>
 <CAEvNRgGn09qrCZjUM5sdqQohPWE62GN4c52iK7ZV_gi5wro_Ww@mail.gmail.com>
In-Reply-To: <CAEvNRgGn09qrCZjUM5sdqQohPWE62GN4c52iK7ZV_gi5wro_Ww@mail.gmail.com>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Thu, 29 Oct 2026 14:27:45 +0000
X-Gm-Features: AclHuK_kIg9XZ2cFnZL0tpsqSJGFt3xKJOd_xbKB2NrNWZ3oy-bCAgu9pf3hZSM
Message-ID: <CAF2vKzOTd=0rmMXvtAE_SzbbZ3C9n9jTcjM+Rj=ovFoYBsXCKA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/14] KVM: guest_memfd: Add kvm_gmem_restore() for
 PFN mode providers
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, 
	Alexander Graf <graf@amazon.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Kardashevskiy <aik@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	Bill Wendling <morbo@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Connor Williamson <connordw@amazon.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
	Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
	Gregory Price <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, Jianxiong Gao <jxgao@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
	John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Justin Stitt <justinstitt@google.com>, Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>, 
	Steven Price <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3875DA0007
X-Stat-Signature: drja8t9hniufy3fqq8n81frytymwa7f6
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793284080-617470
X-HE-Meta: U2FsdGVkX1/GMxYxGrZzkWLGimXja2hp8AEVuk9XPXGhTQalet+f9GXT3EUi5LKL4u0Y57cPapYHkgMFLHz+ZNdUr6Im34CCtuZM8eziARJFITFbVpiuBskeyA93PqK9hIqtep5Ot0hKgzQk+qUTNVslnw2SIEu4yLbg0rpZWd3l4qpkaBDvqkeNH55tWsDQlZBQICRZ+NlPOyvHemWxykBATcrV0yqWqWlKB1rvWZCv4TzU9Cu34KgHehP8G8IYxcnWl7vaAMfdnxdiDE8vq33G/IThFhw92L8lbRQkc+ZAzaaquX2HhrZVegqiAdlb8/m+dp3pV9yKdiQuX4jQc+HuTRX1K4wF04taCAfxRJ8bLPbt7hc0SsYUBuRNyElhoc1R/jynj9FKYjWyyDSI9CURjq6GO1pLrUEhS1Ysiz7NJ/cCjkTC27jTd/VANtSkHSjmeJEXmv4cfkPBP37udoGMIOMQEJ++3uMWbFV68QAQUWGBi/jCsJTGzaB1AjVzc6sGygCHq6LbIjgahD+b+ej/PSpUGeNn8xn05LnHZM2o1gu531lwkgZM82/CbipcXnb5evQQ46WRxJ4hA20nVhG1bJXk6hddniINR+UgpHz6DAKcZshGPUxWcBZSXJydks9RrsRhc5JtjIQHSADXYcIl5BfBlxY7OwFDWD0OSUFFuWXRW1B5VKYjcG+udha2dOaH7eZqqqF+hZHPQLDGrWElr2lJ9FEQX+o1vhsl40OB1tc9zTR5UguB7+X2QrQmIa0s1K5A67BH5nkwuv/KKUD12n5hn5jjgaM9b9WfucVehiDdWvXJ/48kcnqS82eWdOmSpnPbP7qCTBxok5J3CBnpUzc8GpaAdJ4PZpCXTV/HQ/oVyNnznMPVZvvLLeYbe0VgYv8OJtz60TTKyk/LRlYNhVmQRazBIGXoIYDmibV0cbXsbgLjrnSxqmKoPdfJNyYp8oRMRjr4i1GM5bl
 G7fmn3yY
 6y86Xmj8+vd16EgQPJoDMM2E4XJ/gm/45CCN3qrwQFeNYwDq5pDMDo8fLC+w0RLayssvE10ziufGaE4YIpkaW7W2jPWKZgl22XJKZdt9qp4JZ9grL9z0q93GnnLKSI8oH4Br+earVCKZIjb4H/Ze2+vuZiTk15A0fwb1meWm9W8WDiiRKg+8sYlDIhVFi+RQ6IqKWH+OcICRBu5qmnQDrIi6x1N/VGo5PU6EEdt9ORCIVSXY/cnPKF3zeUZJ9Qi6o43vcBf0z3iExd9nSSWeWCsB1S+mKx45xDMk2L9fXMbPbp2aT3x3MhPyq5cHXkde6jebvG0+gzPPSJlThmFuCPpcF5gZjsJyFIutpwt05DzzPXUrq6OuPT6aaHAprcjCO6l6/NDCvtE1g5OpIKZOrDwLIFAXX6eC+uwPUSi08fD/WtDgWIk1l1JIPqkRIM0c6RvBqqrFFLz2XVdsKICPA27KkGmgqmotvtIoiO+yj4RVE97IADjtVwpeaWDwwRFAFGN6fiqOZLT3D6a1DSaU8JpWAWw9U6Pbj4nrF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 05:52:40AM -0700, Ackerley Tng wrote:
> Fred Griffoul <griffoul@gmail.com> writes:
>
> > kvm_gmem_revoke() does not fit: it would
> > zap the guest's and the VMM's mappings and reclaim frames that a guest
> > may already use.
> >
>
> I'd drop this paragraph from the commit message, kvm_gmem_revoke() is
> the complete opposite and isn't a candidate at all for the goal, which
> is to notify importers that a page is now available (and they can map it
> in).

Sure, I'll drop it.

> provider --1--> guest_memfd --2--> IOMMU
>
> 2 is definitely required, but why is 1 required?
>
> Between the first .get_pfn() or .lookup_pfn_range() () and
> .put_pfn_range() or kvm_gmem_revoke(), the provider should consider the
> memory in-use by guest_memfd.
>
> When it's in-use by guest_memfd, then guest_memfd should use --2--> to
> map into IOMMU page tables as necessary.
>
> When it's not in-use by guest_memfd, why would the provider force it
> into guest_memfd?
>
> If the guest VM knows that the page is now usable (some other
> communication channel), it would touch the memory and do a .get_pfn(),
> that would be successful this time. Perhaps that's when --2--> needs to
> be performed?

The IOMMU never asks, and the CPU may not touch the page before a
device does. A few cases where only the provider knows:

- The provider gives frames back with no guest involved: a page that
  arrives during post-copy, a range moved back to the VM, memory given
  to an overcommitted VM.

- The guest already gave that IOVA to a device as a DMA buffer. The
  device writes it without any CPU access, so there is no .get_pfn()
  from a stage-2 fault, and most devices cannot fault.

- A read-only frame becomes writable. KVM finds out on the next write
  fault, but a device write to a read-only IOPTE just fails.

kvm_gmem_restore() doesn't push the memory into guest_memfd: guest_memfd
only passes it on to its exports. Stage-2 and userspace mappings stay
lazy, and iommufd looks the range up again and maps it.

I'll make that clear in the kernel-doc and the commit message. Would
that work for you?

Fred

