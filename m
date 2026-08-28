Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9230BC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C4C6B008A; Fri, 28 Aug 2026 10:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9648C6B008C; Fri, 28 Aug 2026 10:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852D26B0092; Fri, 28 Aug 2026 10:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0E66B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:57:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6D8E1203F5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:57:05 +0000 (UTC)
X-FDA: 85150980810.08.93A28C8
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F168120006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:57:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v3MkuW7S;
	spf=pass (imf29.hostedemail.com: domain of 3vqGRagYKCKMVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3vqGRagYKCKMVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787929024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKyTv2j02zbnlF+PSfGKNUB7r5AsnRVQJaAhKBT0UgU=;
	b=pMM8BEn212lzr8JdnEjpvTuneY6SI0b8tyTU120zNfO1f17qHazZRyb6Dsc+YO0CWMUomq
	NVz4EHrEzoyhXenKjMmKfgWg2ds4y8lJvxhohVf5Lof5BkF8XjW46tND2UlarQcUChKWAW
	u2wz1Z9oI1KMH/edeGdG5izSCAyYBGo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v3MkuW7S;
	spf=pass (imf29.hostedemail.com: domain of 3vqGRagYKCKMVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3vqGRagYKCKMVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787929024;
	b=puFRBm5sfMnnay/3Rd1No8GlVn5twqk/Eeg2DnWDkbXoFy8rD1bbIsuM035MUf+2jjyoCN
	mVaMGlHwi4NYTgbTond2enRjMfBaWJf5EUdrwsIDEImqMGb7v3PqiPcng4I4xBsCP2/4FN
	dcdQg2DNAAM9sg9UBvqPWRbdv5RSUa4=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cec4226c70so13798195ad.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787929023; x=1788533823; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rKyTv2j02zbnlF+PSfGKNUB7r5AsnRVQJaAhKBT0UgU=;
        b=v3MkuW7SjZmkgO3QaIOrgCBTp7Lfev/p3tOEg7R4PTVqkZPCAV2VLMlfp/A0E8yUf7
         SUzGia5iz0Jw7jBD52a1Le5/YkklnEC1VNBirZ0o5jgUU9Lbr+HHkQz8D8iX/BrlBEBa
         ZW7FFk0nR+MPvIgjynJqw0HTeidalhdOLAzZubOU/JGUaRAZMGYvjo83rt43rp6vfiyg
         66hhX0X5QRB7tPkzjjKEvYHZCiUtcYDk4ithJZG0FoKir6igIv9Hdx8pafGeR0huk2hA
         u6vfMWWnp/8CB0/RtSCEfJC0KVpFddnmD4catwPA8HoDIsH/DHHNCxGCp/S+iKFhoXpT
         SuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787929023; x=1788533823;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rKyTv2j02zbnlF+PSfGKNUB7r5AsnRVQJaAhKBT0UgU=;
        b=gT/ZqbfHtnftwNizknuF6DYYON2Q1KwyqE+QYCJsikuLj9jB9q75NtXhtV9CyMm+D3
         xh8lP13tCuZwq1y7kt37wWdkKhCumB718xfxQnXCNjNdUULeBS4Ch0Knm9NegbQrcUxv
         lg5bOQ6tLtHjcs5k7Cu6j8Zo1EvJML4oX4BXy/EiUdb1e0RGQhMf+fAP0Qddw3DyAzeb
         eBxsqBUxMQq6qU+wo0gkMR2Gf4seEtaDjUpUiseIQrNRt/3BKnZbcp6wjeUrsD5Z08BY
         hM8QiVSXVmhTuscyNWu6QUvrv81Ujzq7IDo6ZkyaScmahktvbBhGAKIiR9AQRKzKF31t
         LzzA==
X-Forwarded-Encrypted: i=1; AHgh+Rq3T18qkwPO49ZqjQZk4mKYDEEba5Z39Boa8aigJ6ny0td82ZQqCbAEDxSNHQNe3Z0rzlUrxbxOBA==@kvack.org
X-Gm-Message-State: AFuF++mGSioRNybVEe/UBPPVBp/vpT8Bbj3bp9kZ5vU3heA3ao46LIka
	LWPQCTkPgA9gDH+qzlaqqrmMsqA0UTPkgLh6SG0+Y+oCgPdsNmUG7rJ/KdPkSZSdL5gvOViPzrc
	iqxBN9Q==
X-Received: from plbkz13.prod.google.com ([2002:a17:902:f9cd:b0:2ca:ed29:ea82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1984:b0:2d8:d4d3:da4f
 with SMTP id d9443c01a7336-2d8d4d3db7dmr6783485ad.19.1787929022578; Fri, 28
 Aug 2026 07:57:02 -0700 (PDT)
Date: Fri, 28 Aug 2026 07:57:01 -0700
In-Reply-To: <CAEvNRgG7n6F=dW9V_QqQPDDgLiZ7x08uLDanJgSzerNtN8sqBQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com> <CAEvNRgG7n6F=dW9V_QqQPDDgLiZ7x08uLDanJgSzerNtN8sqBQ@mail.gmail.com>
Message-ID: <apGhvboNAlExQFsK@google.com>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: dn9e9q5x1h5ieudcoxdnsi5kq1o4so5b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F168120006
X-Rspam-User: 
X-HE-Tag: 1787929023-692661
X-HE-Meta: U2FsdGVkX19SA9lQBvUPgCV9DoAfmxPxm7aO8ZjZdWAOh/oCzlNyP4jfBoKJxrVYoqqnvqLcNMaTxTDKvKImC6zZee5L8bd8MNU8+9/n34zVKHmU4kwA+OtDI3d42jcFLICF+IgL0J4QtZG6scR/818aXFDAdXKPQDIEjZOMDLIg26LHRMMa5b1tC5ZwkLZ8aEzaQ41jqoT97dP4ThR7eBM7Ky0Gk1bF0zCZBsKA5k3kHvLtlqeWw5feV0ad8Ry6dohTOfu/kGA6WZOs0UdeNTIqTb/ogWbI2FS9yxRjv5Aj+v0/T/iKWPBLeGo/1EPGFTDSr6MO3cdg43cbxbdOfjf4S/Hrcnk83KddaC4ZeKaqvovnSqeh7YNGei3T8SwnuBuhz5upicT7ihxck0MyYWx5JvkxL/xjmvNG+sIPIi0/QTeVrao/WutsOLx8yTkKjdXDeLP/MLmcHDsHv6ZN7qsv/TqJLkUZrDi6ojvi5cTjvw6/A8tdiFPcs3tGOnQMAo2ga0Gh5CPIVDkBGlRaOZWlly6FSEej5HCoNjVvFreTOClybLfbvLT6kpVRO0Gt10+M0R7b5Z6ZWUtSSeAfG7dVt5zoLm2bvU2iuCREFNJuE8OioX4H6Rx/tl4q//UJmcyG8HmoH2msd7SsK3SwKgOIBg859C6KDeQgC4kLtP3l4X2BNNKboZ7djooPRwGyKfhtlJtEnEWPlyanny+6fVVtNMJcz+bucZs42KNTtlVgvVsdggMo7zeuQonF9tA9vmIj9HI0EtmFWMDJX4rASXOe6eFbJ8TuCGtAdd4ZFAJdYK8OpSWK31BmFZSaeMfwHqTRByJpQ0+ovOuUZcacr2dah8BubM052FR9P4x8tt5d074ZwKseY+jX0vwLEHmw1ALd2Z4FOy6WjTKd+l/rJXdaxJw5sv5FQBr+mG9CIqfkvE0Ew7C1FSXmfaY5uTWTZdzdsPlX8FLaUjmjBf/
 u4ziUieq
 5BKOKkq1O9Z99PkjWIUF2eKK0xZWIkF59FmuXDpxp+leUzuwffAS9eena/OJ++floUUUHpXwH3+GXzwL8rIT6reCtHKoNujBLw/dwWvgHWUWb349zsFnPFpdxIJadLodwJVRtkh2c8dj3b4IpExkm5fKwIXRBEu/DWwbXhWSbUER9r+WP2ishbC9mrWzEqqsJJhLXcvIx7oOxOgVG0gAefJm92Fdb4phLoSCcr/bq/LIvr9Dg91MIi7w+fcfG0PvTTG8BViO+myAlqsMtDciNiWcOKFLxCXpV1+QhjYSk1y9OZ7qF7x2dDCbWJWD7SU5mUJ0oMOt8Y8see2xvhww9DlXEt1MofRLoPwyBF5ptDgPRmtyP9sump3lFti1glaro+Ab+poapqXPdoATO3phY9BWKbNIFSx9+7orIzD6oWNm0d9KQcutKmJ/ghr4iwa6vDvdACNm7nqvxcdYPDTYvmUspDESp4gNMLLR9Wd3euP73h+z173PVQ9RLuMYRCRtyU/8x7D/961k8Cib9Nh36N3i8hsGe8QlZj8xkytdZwQqwijQATevalNJtcI0Fgm97TPeulcOWTdX5KvjIisvGq1QoL5moqz41jOVsg9eqQIeZTkEpIRSREx6REv9IqE2a3XIHOu/KOUVpPyW1FNWofvXeZ4nGdVWHdlxv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Aug 26, 2026, Ackerley Tng wrote:
> >> Omit support for calling the arch hook to make private, since SNP, the only
> >> implementer of the arch make-private hook today, would actually prefer
> >> making private only just before faulting memory into the NPTs.
> >>
> >> Calling the make-private arch hook would require iterating both bindings
> >> and the filemap to find the intersection of bindings and allocated
> >> folios.
> >
> > Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
> > whether or not the RMP is currently reachable is irrelevant, no?
> >
> > Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
> > superfluous, but that's already possible, e.g. if an NPT mappings is removed for
> > whatever reason.
> >
> 
> make_private takes a gfn and pfn, so __kvm_gmem_set_attributes() would
> need to iterate bindings to get gfns and filemap to find folios to get
> pfns.

Oooh, right, unassigned a page in the RMP only needs the PFN, but assigned a page
needs the ASID and GFN.

> > I don't care terribly about how SNP handles this, but I do want accurate reasoning
> > and justification so that if/when we revisit any of this in the future, we can make
> > informed decisions.  Because unless I'm missing something, this is an optimization
> > choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
> > not clear to me how we decided the lazy approach would provide better performance.
> >
> 
> How's this, to replace the entire commit message? I hope it captures
> points from this discussion:
> 
>   When memory in guest_memfd is converted from private to shared, the
>   platform-specific state associated with the guest-private pages must
>   be invalidated or cleaned up.
> 
>   Iterate over the folios in the affected range and call the
>   kvm_arch_gmem_make_shared() hook for each PFN range. This allows
>   architectures to update hardware metadata or encryption states to
>   transition pages to the shared state, instead of leaving hardware
>   state as private while guest_memfd tracks it as shared. Transitioning
>   hardware state ensures that guest_memfd upholds the guarantee that
>   userspace only maps shared memory.

Nit, don't reference functions by name when it's easy-ish to avoid doing so.  And
don't give a play-by-play: the patch makes it pretty obvious the code is iterating
over folios, what isn't obvious is *why* the code does that.

>   Invoke this helper after indicating to KVM's mmu code that an
>   invalidation is in progress to stop in-flight page faults from
>   succeeding. Calling the invalidation helper also calls the arch
>   invalidate hook. For SNP, this kicks any vCPU with a registered VMSA
>   within the range being converted out of the guest. This ensures that
>   make_shared never fails due to the VMSA page being in-use and is
>   important because if make_shared fails, the RMP table would track the
>   page as private while guest_memfd is unaware and tracks the page as
>   shared.

Exaclty what SNP does isn't relevant.  Or rather, it's but on example of how this
needs to work.  I.e. the conversion needs to happen within the invalidtion sequence
because thems the rules for KVM.

>   Omit support for calling the arch hook to make private during
>   to-private conversions. Making private lazily at fault time aligns
>   with how it works on other platforms like TDX.

To me, this isn't a valid argument.  We've fully committed to relying on vendor
specific behavior, and SNP can't truly work like TDX because the underlying
implementations are so different.

>   Furthermore, making pages shared only requires PFNs, which are
>   obtained by iterating folios in the filemap. In contrast, making pages
>   private in the RMP also requires the GFN, which would require
>   iterating bindings to get GFNs and the filemap to get PFNs from
>   allocated folios. Deferring the transition to fault time avoids this
>   additional complexity.

It's not just complexity, it's that the bindings might not even exist.  I.e. for
all intents and purposes, doing on-demand updates is mandatory, because that's the
only time a relevant memslot binding is guaranteed to exist.

All in all, this?

   When doing in-place conversion from PRIVATE to SHARED, immediately inform
   arch code of the conversion for all allocated pages/folios, e.g. so that
   arch code can put hardware metadata tables in the correct state.  Eagerly
   updating the table for to SHARED conversions avoids having to implement
   on-demand updates, e.g. when faulting in host userspace mappings.  Skip
   the entire flow if the arch doesn't implement conversion callbacks, as
   getting folios from the filemap is noticeably expensive, especially when
   converting large chunks of memory.

   Deliberately don't eagerly update the metadata table on conversions from
   SHARED to PRIVATE, because assigning a page to a VM (versus "returning" it
   to the host) requires the exact GFN associated with the page, i.e would
   require walking the memslot bindings.  And because KVM *must* do on-demand
   metadata updates when getting a PFN for KVM-internal usage, as that's the
   only time a relevant memslot binding is guaranteed to exist.

   Note!  Inform arch code of the conversion within the protection of the
   invalidation sequence, to ensure that any existing mappings are dropped
   before hardware is updated, and to ensure that new mappings can't be
   established until after the conversion is complete.

