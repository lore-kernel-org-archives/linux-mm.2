Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1874F606A330
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r6M4lPQD
Received: by kanga.kvack.org (Postfix)
	id 1668B6B0614; Thu, 29 Oct 2026 13:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E0C6B0615; Thu, 29 Oct 2026 13:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02CB56B0616; Thu, 29 Oct 2026 13:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF12A6B0614
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:07:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EE30A04EA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:07:56 +0000 (UTC)
X-FDA: 85376296152.25.E06CB9E
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3553080017
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:07:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r6M4lPQD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793293674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YjGbXSGdFWqGTw7iXBWdHWj/MRYXXZreyMjEGvCLmY=;
	b=FZnoq8AZSSDH6n3xQ9wkfE1E5zfI0pK1pTlhuIgUP6FPNNtjK1LGgdpeghOnh9HRP4R/m6
	rc3u1JV/iNUQy/5tvy+HpFwON+jCV66JOurir58ycku5QGYigJa6M14iwlyY6mEf09qyqg
	Ih0pUdabDtUUjlQKypm2zaCejDpig2w=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r6M4lPQD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793293674;
	b=FCIF/9rX2PSYjz58FC7vLtwA2p5HOc7jDCuMhk30OqoP7DUumwERi2aWJ2nED/O+jX4Fiu
	NXYaE38/cX0D2Fte8Wjf/K7aNU1JEknXNJCqGBgk2DN1WoFvQhZk/yUmm7/Gmrushfly0U
	9FYy3cGFDCaiXD999HR9fMbFYw6RwFs=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so391036366b.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:07:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793293672; cv=none;
        d=google.com; s=arc-20260327;
        b=LlbFZU5+3bKR8RbKlCHxjvMWhq4SX2h8XgM+0YyAIzBXDfyqQDdVPiJ81Y6R+wa6ZF
         sWlxDh/8pBlKIKjm2pcGaDJRoeliUCFKOcFrrYYJkwy625vnzUDGSsSBaDU1DCZ9gApn
         ddjaVslOQ9jKKWk4ZyIN5rv+FC6Lxl+A+WVkJk169NV/mO0yoms6jMZJIc49yjbjDU2d
         P8Bt18HWkQtatlc7s3PRMerpzrywHGURrDk/vu/rDILDIvudu5NNiCmFnw9QyEW9C/iJ
         jIjb7rUcynZVIs3SdfVSBlcPT6+HcKA7FP5iRWED3e9ckgJvbVI5Un/X2UecWvnNIJUm
         C9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0YjGbXSGdFWqGTw7iXBWdHWj/MRYXXZreyMjEGvCLmY=;
        fh=T3jG9CfO4xTP46nkiQg4lxsFv2xU/kNx/H7R4W2SRiU=;
        b=n7xFkIzEW1PfSJkjAIMYpQ9YZXOc4qrc0yHIjkTYCneKkjFrMnhs63l+OiX06wXqPF
         2sQPdcDm0rAf9eh2RFyafL/67GScacHDXeezUzrsgsWwUt7Ux4XlAkIy+iqMPo4EBazi
         7RWHoLhB8ZwL9KpcpksF2wudDcStJym0oCmfaXMWhh3VNVJCwAStxXlZ0QxhkYpge+mK
         8K24PBD2mBYiP96HVkCcESUwZoxwBGy5Onawam9TVPTM7527N6fheLHy4WroTLObQiCu
         dhyIvkWO6W1qWAg8o0CXJkqEZjqayO/9JhGz01++h0D56NoT0bIqsQqVRCBK1GqLVKH+
         /utg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793293672; x=1793898472; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0YjGbXSGdFWqGTw7iXBWdHWj/MRYXXZreyMjEGvCLmY=;
        b=r6M4lPQDFJR1AQfxdMhbNTqsdQVlD7zltH6OJDXzHMOevecnooj+8rbtibOAMU+Xxf
         kqBeYsSYyLcJ/4+sCtgqDhKAHIWI+p+iLlAFABGbywkNRQlcMXP3oyrL7aV41k/6b8Y+
         WrmoIs7Hs4TsFogYLG7ki+BbRoBx19vdMSQ4ZKEoKyfDsPFqZbhJLx8IQ82y2kwmZMCv
         TElrVIVdAoKqsb+Tu2TZ0PkyFOu9/mgdvVLVZAOAY5uvdoDoWckPb1cVoTf9jN168hb9
         cMVTSoyhE32Zr6dqnG6SoWdaAHWNhwqo5JcMVokKt8ZL6bjQoz1UXKgtrN+6sfM9k1Ks
         RZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293672; x=1793898472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0YjGbXSGdFWqGTw7iXBWdHWj/MRYXXZreyMjEGvCLmY=;
        b=bcUSk4AgG+d1WR6NqgkMwKcwgFquWsAqbV3U0mssEYKt92npD/hsIpGzuBWyDBxGnp
         a5quUJ7PqSdPYtpQtl7wvlM2Vrb/dbX1eNEtx7DyQACN1OFEalxXbFOB+6oC5NEL7drH
         lysAwtwHCW2+TZju50l9nB3uegk4rgi6dnW1T0Z57R0lBAaH3h149qXPfJvwuZwzKKbR
         JY6jy1iTaiKefuN8vUCvehLaolZfLBdIh9k6Hh+CrAqCZWqKRscgB/5qFTvr4Nof3Gfh
         m4TSbsWa+2voVpF2r1rLAbMQYw2VZ3/JmEs3kixYC51lw+HCZsAPz0Vg4UhCl/HCRTNz
         CkSQ==
X-Forwarded-Encrypted: i=1; AKwUvByIOWkoRbTysVIxvbgee6rpSU25YqQzHYpWu2eocaxmss4xWEVTSwsHR3lQkG42YGmbvqsUX0rCFA==@kvack.org
X-Gm-Message-State: AFq9FYIPtmotSdYC/CD8qSjdd6eudGVlC/xJ3c7T4cVpL3uKkGihVlIt
	u4grEKbFszS1PfHryPZDwZ5HQRdy6Y37JTNBWiFS1bepVT7kyDbms9Jy9aiwbrmum+ymxvPHduD
	mJBgnGgPyp0l30Nm3WPxdIdoSW3OgLI0=
X-Gm-Gg: AYBFou1PaVpeRVkjFjpEfnjuiCS+C6cMUB3N2ABAZCFS4anFqziyLQ1wNgoDZ8gzha6
	wWPcxIfO7KgefzSbjnQ8WUv7etprZRX3U/1TB3bBxvpptaFrNSuVaCtLPJvRFZbJqWrJf9uADSc
	RISqsx5v/Xy/jTbtQfin9n/j83u+uFWxwYMnSAJXKghflX8dKKRY2sB9ArXjuAwTUjXwy/hhuJK
	MomO3ExnO3ak4Un2NQcZb/hx0uB16CCW6v5nbcR/f0Nah/EztUl1zEEiDGHpGWmSvZICynY31R7
	a2eBdYmmpRJr9A7+Fh4NySXF43OtN7YC0nDV4Z+Uev1xtLrZZuMeDK87eNCJn8uZAWkvf2BGXzS
	Zd4L6ZAWMwRNNHY/jdP7rLKF1hjwWauigVMsxe2koUPBNjIP/vvzPnV6PUJ0YgOyClYCEqigiOr
	gsbYzj0ISLqdzieeo=
X-Received: by 2002:a17:906:7313:b0:c45:c030:732c with SMTP id
 a640c23a62f3a-c49be03a73amr610119866b.41.1793293672256; Thu, 29 Oct 2026
 10:07:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com> <20261027154649.91571-2-griffoul@gmail.com>
 <CAEvNRgGvxtgT=x3sLcasLZzCrtX+qEkHjPgs2yFRY0HRJvodag@mail.gmail.com>
In-Reply-To: <CAEvNRgGvxtgT=x3sLcasLZzCrtX+qEkHjPgs2yFRY0HRJvodag@mail.gmail.com>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Thu, 29 Oct 2026 17:07:41 +0000
X-Gm-Features: AclHuK-XOTTZ577Y9tlQyUF1DU-1w6QS3FSXEW1jGcpzGvSeAxBjghFI3p-6WVU
Message-ID: <CAF2vKzP7mKAsbDFfj-ndoYSxxZYbNzVO7uysb-XtKytR4zuC7w@mail.gmail.com>
Subject: Re: [RFC PATCH 01/14] KVM: guest_memfd: Clamp the order of PFN mode
 blocks to what KVM can map
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3553080017
X-Stat-Signature: dsc7xumxjbe5hc8d9obim5odx55b413b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793293674-250098
X-HE-Meta: U2FsdGVkX18NAxK8UB4Mh6TzKJjHPx94T3M/4qM/izMaDxSBj+WjXYqfFeeYmalG7ygZsgfpjM2fkYuq60W0YAY4kHDVfDntEfHtsssNgQJRB4f1AJkCF7eCiv+82X9WYmw6XNCRRUVMeeG28UMa0r8oKXjFV05sM1FmNGXDNZ/jPZDTpkbkxkQp2/StxiwQbEJzst1KweCCUlsj9e9JPIkS3kBmo2fSr4kV95GEVzbY+BwJGHVS4PA8/JY/4m6MwM79TK6ayVspegkFpNwLGiDWxpfRpJMTR6GuBNjHCxGkPsRq8QYoUTZtXdXGKE875xGdwtH+pvmUrqByb7ZeZcwaUWTKqCMt+FHiQvaGkJkQXbkai3PyTYKijC0STMZ+iMEhraN76DMwLDX4j3k9/Ec0Te7utPK5h30PtoMUDak6rTHsZX/EOM4A21E0cZ70gbO0MH+HRkWi+WPH76dLNu3CBejY+LCO1hDhQ6caNF+6n8uvgJY16SjD3z24Cz9G1BG1rBoHYLEUhkdCZddxaHb5ZqCDQOp3gurbXJMCtCNgeR1mMKiw1gG+HZG1P2hU1XUhTGwEBrcgbgG5jFA1zAz6KAbndqakGZFxOTfKg8l9A4QmnyBBEuoGiRT4LfTlZyTKLrHOvY5m+NAfW1qOQ0zCgFWoH1/iygrUffCEq/75m14Gh7ZyPiq9MnJfQSr7BV+P1svz+vPfObM8edcdC8sVasLIBvbb0RtKVme23+k1T6EgiD8abX6aBTpveVGxoa3skUDrvpadg00jBoXmZNVqPLJi8AxO+wm+iXEVuSdO/bTv2mloJXDzFAa8V6TN0qWIgyhn2yQNkQqW9QUL2XwzCN8Y00tuG9T4KgS1QVlf0RvhVZADKm8kncd9gligcYZ0Tl5gN1oq7RXkj4p9rACwQYFmw7GIOfwrsWWfU8+aPKcQIUWxq8yM95FMN4XQYjU+WxCUUySmEA8mpUO
 CPiq0dnx
 zG4YYQy4Jlu4XPgGfO/n8fhrNGdygldKznkSk/I4JlmW6A+vkL0yAQ0zcLfHANbMn4hEqRTNsjjQRsLPAVF6bbfhvmrM1g0fqo0HG2sJDb5tEgQFpw/7FUsl7IQsgdnaxmxSgWxTERwdm9Qx6YDW6pMCcWRBpSZFEkO5wJuLkWVofl4Q603tIXPs9M5V8bqjfpBOjNSJxqLHbWhDmrdGmxYWeO2IM/AOFCW8tLkqTrDcemIQubcACX2AUvh6nAZEzv1PrgRwuTvI/k4oTimy1t/4TyN7vaX9KRpgrEO/zJpQaZZ21wly1fV6Uo4SKKPCrsOjT81Jwv6duTbFUqWYu8BEAvxRlDoL42IlC+z+Xs054lARUqcbb4am4UKpeKNsXlngMJli+TVD3lJ7wNCGYuVazCCq0V22yV+aQZfKkZZp0+qh+sJ0HRn80WIfVXA1i/pR5LRQMRLkD5dtlG1GyoOF1yDLCqGGvQNsDuc+b581P3pbwia4k96ye0U1ZC1gIifcDYqGclCOqc1mNOd8j2M0nhxSKsGrfZXWfpp+Yyw0o6UHzj+ZA0+w4UEyPgt9cxZFgrnienQ5rmPWu9pWSMgK2hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 06:25:49AM -0700, Ackerley Tng wrote:
> Fred Griffoul <griffoul@gmail.com> writes:
>
> > +        kvm_mmu_invalidate_range_add(kvm,
> > +                         round_down(gfn_range.start, blk),
> > +                         round_up(gfn_range.end, blk));
> > +
>
> Yes, we want to make the invalidation range larger, but not the range
> being zapped. We can't over-zap for CoCo VMs.
>
> Would it be better to refactor kvm_mmu_unmap_gfn_range() instead of
> doing kvm_mmu_invalidate_range_add() twice?

Good point. As far as I can see, kvm_mmu_unmap_gfn_range() is only
kvm_mmu_invalidate_range_add() plus kvm_unmap_gfn_range(), so
guest_memfd could do the two steps itself: add the blocks around the
range, then unmap the exact range. The zap stays exact and the range is
added once. Or am I missing something about kvm_mmu_unmap_gfn_range()
that a refactor would need to keep?

> So I think we should follow the same model:
>
> + The provider reports the max_order based on it's contiguity
>   information, which is the actual contiguity of memory and
>   read-only attributes
> + guest_memfd further reduces max_order due to shared/private contiguity
> + After handing it to KVM, KVM further reduces the max order based on
>   the above.
>
> I think mappings for all other page tables (userspace and IOMMU) should
> also follow this approach.

Agreed. guest_memfd should then only reduce the order for shared and
private pages, and drop the gfn alignment and the rounding to a
page-table size, which KVM does. For the provider, "contiguity" would
mean a naturally aligned block of contiguous frames with the same
attributes, the frames aligned to the block too, so a mapping of that
size is valid as is.

One gap: KVM does not cover a memslot whose gfn and guest_memfd offset
are not aligned to each other. On x86, kvm_alloc_memslot_metadata()
disallows large pages when base_gfn and userspace_addr are misaligned,
but nothing compares base_gfn with gmem.pgoff, and kvm_gmem_bind()
takes any page-aligned offset. A gmem.pgoff check next to the
userspace_addr one would keep that in KVM too.

The export lookup in the series already works this way: it reports the
provider's block, reduced for shared and private pages. iommufd maps
PAGE_SIZE IOPTEs in this series, and will pick larger IOPTEs from that
block later.

> I guess the kvm_gmem_fault_user_mapping() equivalent of this max_order
> tuning is missing from this series. :) I think we should defer order >
> 0 to a later series though. I think read-only-ness should be part of
> the first PFN mode series.

Right, userspace mappings are PAGE_SIZE for now.

Deferring order > 0 for KVM and userspace is fine with me. I'd like to
keep the order in the export lookup, though: large IOPTEs matter for
device performance, and I'm preparing iommupt changes to split and merge
them in place.

Fred

On Thu, Oct 29, 2026 at 1:25=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Fred Griffoul <griffoul@gmail.com> writes:
>
> > From: Fred Griffoul <fgriffo@amazon.co.uk>
> >
> > KVM maps guest memory in 4K, 2M or 1G blocks, and uses guest_memfd's
> > max_order to choose. A folio of order N is physically aligned and never
> > mixes shared and private pages, so the order needs no check. A PFN mode
> > provider's frames need not be aligned
>
> I'll need to think about max_order > 0 more for PFNs. I put it out of my
> mind because my frame of mind is that only order-0 folios are supported
> today. Perhaps with PFNs it's actually a lot easier to support order >
> 0.
>
> > and the provider does not know
> > which pages are private, yet kvm_gmem_get_pfn() passes its order to KVM
> > unchanged. KVM can then map a block over the wrong frames, or with one
> > attribute over shared and private pages.
> >
>
> Yes, makes sense that private/shared contiguity needs to be taken into
> account. I didn't consider this because order-0 is always safe to
> map. Thank you!
>
> >
> > [...snip...]
> >
> > -static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t s=
tart,
> > +static void __kvm_gmem_invalidate_start(struct inode *inode,
> > +                                     struct gmem_file *f, pgoff_t star=
t,
> >                                       pgoff_t end,
> >                                       enum kvm_gfn_range_filter attr_fi=
lter)
> >  {
> > +     const gfn_t blk =3D kvm_gmem_is_pfn_mode(GMEM_I(inode)) ?
> > +                       1UL << PUD_ORDER : 1;
> >       bool flush =3D false, found_memslot =3D false;
> >       struct kvm_memory_slot *slot;
> >       struct kvm *kvm =3D f->kvm;
> > @@ -355,6 +360,16 @@ static void __kvm_gmem_invalidate_start(struct gme=
m_file *f, pgoff_t start,
> >
> >               flush |=3D kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
> >
> > +             /*
> > +              * In PFN mode, a fault may map a block of up to PUD_ORDE=
R
> > +              * pages, sized before this invalidation (see
> > +              * kvm_gmem_pfn_map_order()): make faults anywhere in the
> > +              * blocks around the range retry.
> > +              */
> > +             kvm_mmu_invalidate_range_add(kvm,
> > +                                          round_down(gfn_range.start, =
blk),
> > +                                          round_up(gfn_range.end, blk)=
);
> > +
>
> Yes, we want to make the invalidation range larger, but not the range
> being zapped. We can't over-zap for CoCo VMs.
>
> Would it be better to refactor kvm_mmu_unmap_gfn_range() instead of
> doing kvm_mmu_invalidate_range_add() twice?
>
> >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> >               kvm_arch_gmem_invalidate_range(kvm, &gfn_range);
> >  #endif
> > @@ -374,7 +389,7 @@ static void kvm_gmem_invalidate_start(struct inode =
*inode, pgoff_t start,
> >       struct gmem_file *f;
> >
> >       kvm_gmem_for_each_file(f, inode)
> > -             __kvm_gmem_invalidate_start(f, start, end, filter);
> > +             __kvm_gmem_invalidate_start(inode, f, start, end, filter)=
;
> >  }
> >
> >  static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t sta=
rt,
> > @@ -670,7 +685,7 @@ static int kvm_gmem_release(struct inode *inode, st=
ruct file *file)
> >        * Zap all SPTEs pointed at by this file.  Do not free the backin=
g
> >        * memory, as its lifetime is associated with the inode, not the =
file.
> >        */
> > -     __kvm_gmem_invalidate_start(f, 0, -1ul,
> > +     __kvm_gmem_invalidate_start(inode, f, 0, -1ul,
> >                                   kvm_gmem_get_all_gfns_filter(inode));
> >       __kvm_gmem_invalidate_end(f, 0, -1ul);
> >
> > @@ -1535,6 +1550,44 @@ static struct folio *__kvm_gmem_get_pfn(struct f=
ile *file,
> >       return folio;
> >  }
> >
> > +/*
> > + * The order a PFN mode block can be mapped at: the provider's order, =
no
> > + * larger than the alignment of @gfn and @pfn to @index allows, rounde=
d down to
> > + * a page-table size, and never over pages that are not all shared or =
all
> > + * private, since KVM maps a block with a single attribute.  Called wi=
th the
> > + * invalidate lock held; an invalidation of any page of the block make=
s the
> > + * fault retry (see __kvm_gmem_invalidate_start()).
> > + */
> > +static int kvm_gmem_pfn_map_order(struct inode *inode, pgoff_t index,
> > +                               gfn_t gfn, kvm_pfn_t pfn, int order)
> > +{
> > +     u64 misalign =3D (gfn ^ index) | (pfn ^ index);
> > +     u64 attrs;
> > +
> > +     if (WARN_ON_ONCE(order < 0))
> > +             return 0;
> > +
> > +     order =3D min(order, PUD_ORDER);
> > +     if (misalign)
> > +             order =3D min_t(int, order, __ffs64(misalign));
> > +
> > +     if (order >=3D PUD_ORDER)
> > +             order =3D PUD_ORDER;
> > +     else if (order >=3D PMD_ORDER)
> > +             order =3D PMD_ORDER;
> > +     else
> > +             return 0;
> > +
> > +     attrs =3D kvm_gmem_get_attributes(inode,
> > +                                     mtree_load(&GMEM_I(inode)->attrib=
utes, index));
> > +     while (order &&
> > +            !kvm_gmem_range_has_attributes(inode,
> > +                                           ALIGN_DOWN(index, 1UL << or=
der),
> > +                                           1UL << order, attrs))
> > +             order =3D order =3D=3D PUD_ORDER ? PMD_ORDER : 0;
> > +     return order;
> > +}
> > +
>
> I'll review this function more closely again. I think the mapping order
> should fit into how KVM does it. After taking guest_memfd's input on
> max_order, KVM then lets these parties possibly tune the max order down:
>
> 1. lpage_info contains information about highest order due to memslot
>    alignment and alignment due to VM-level memory attributes
> 2. CoCo platform can impose a max order
> 3. Userspace mappings can impose a max order too.
>
> So I think we should follow the same model:
>
> + The provider reports the max_order based on it's contiguity
>   information, which is the actual contiguity of memory and
>   read-only attributes
> + guest_memfd further reduces max_order due to shared/private contiguity
> + After handing it to KVM, KVM further reduces the max order based on
>   the above.
>
> I think mappings for all other page tables (userspace and IOMMU) should
> also follow this approach.
>
> I guess the kvm_gmem_fault_user_mapping() equivalent of this max_order
> tuning is missing from this series. :) I think we should defer order > 0
> to a later series though. I think read-only-ness should be part of the
> first PFN mode series.
>
> >
> > [...snip...]
> >

