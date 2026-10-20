Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEF2606A336
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HCWlROcV
Received: by kanga.kvack.org (Postfix)
	id 820EB6B04C1; Tue, 20 Oct 2026 09:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1E76B04C2; Tue, 20 Oct 2026 09:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7E26B04C3; Tue, 20 Oct 2026 09:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 445CA6B04C1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:04:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D52DDA7012
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:04:52 +0000 (UTC)
X-FDA: 85343024424.20.A228C66
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F0B58000E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:04:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HCWlROcV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 38WbXagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=38WbXagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiOSNZMdnqqChU7eCmFOfWFFqcm5VOjZEu4im1R13jg=;
	b=3DOO/1eQx71ZHqpTKKj70fRlMBFCxY7hN6DbAWWm3+/jlGP1Kh5bGTEWKsxg2ZYUmarqvr
	uamz0kEn1UcFBLSihYGYP5buP22ArGrNUHg6OSLawDWS9FKl2NX5FNqHpspjX907Ye0tu1
	SV6NHv0gIbBd/cskliYzql0RRCtlqEk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HCWlROcV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 38WbXagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=38WbXagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501491;
	b=jkG1hjGd63tt0RvYErP10T5oQCACNF7yBmOm+i1B+UKdVW3Trrk2GmArUY9KStKG99hPu7
	tx0ty9zzmKRjN2CBn61MrYYiVZnp1vxKIfn/4SU0zk0017ruAVeoN3vrysFsvdgo4whx6i
	sUk595bdezj999qPtz2aBndUs+081bE=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd6969473a4so660544a12.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792501490; x=1793106290; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TiOSNZMdnqqChU7eCmFOfWFFqcm5VOjZEu4im1R13jg=;
        b=HCWlROcVQJ7jjRx6JYBF5yWhNmJnL2i4aQizVNwT0MgTMOPQGIyFzyO2OSnT7XI5Xc
         IfQK9MNNlPtj0pTC09MIC5wbmvqNJ1qFLI0YbfXyHzIB6yqBORNryyu4dUnpBBbeWxmb
         HKAMPIq/7PkAm+wYtsF/kNU5ETJSTeqmubEEBHfavOoeteia9jb5ikk34ue7zlrI2kb/
         pgY+XBtyFa6N4bWAh69RPdt1CFh8RD5EIf+qx6zS1lf+mt+AFPca3foI4tMKIdE+SAp1
         GmnbDcwTaLzsBH1+0wnIusaKjKA0eKU4u9nyXg0SjELHOadEAKeqvSG5kcOE+rs17xCx
         gNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792501490; x=1793106290;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TiOSNZMdnqqChU7eCmFOfWFFqcm5VOjZEu4im1R13jg=;
        b=Lp/EpJ9lM3pBvPNwzOqI8J1UmjNVaXLMJEnqtfU0bbB9OfVekxLcdSN8TCtRGIfvNE
         rZAUjUWiAaROCurM7+b+N7RNMWi7+T0fX9eNDgd+aLXCRGAv6cRuVBDeaDN+iKnL8Phg
         Qlr2zpHyPGJNix7NlymBiG2ql6GRF2c2MDok/W2hQDmsltxd0LZK8g4KWGtnytC9AgqG
         zDrfDhTlerwujfT/8Vnmq54/83a+Fx75r4UazRRIAXTtPKUuX3MxoTphI5wDRd3K+sYJ
         IcPjY1mB8SC8lY6OGVLWaZf3Ph3JHIfvHL9rKYMlRe0eLP1CLPU0s58p8aMIV3dgXeOg
         yanQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9Jq1AcboISPCoRmNflM2Jx8JL+/6x+1FVWFx3xeGaCr8WovAaIunZH36s8r2HUrfAQizNnEJumA==@kvack.org
X-Gm-Message-State: AFq9FYLynjiokyTp8IaKQADZg+PGzY9Aw5pQxodf6+EOTvsHQTmVLcmB
	sHcePkyfPuT1HBk1Uu6+/CbzwAsE4FtH2Vi780ibhxVFkMol/E5ruvkz0YMvuEeiqXNgFIoR9Qn
	LeMDwew==
X-Received: from pjdn34.prod.google.com ([2002:a17:90a:2ca5:b0:3ab:c22:1eb0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e85:b0:3ac:aa8d:19eb
 with SMTP id 98e67ed59e1d1-3acee29585cmr8240994a91.3.1792501489305; Tue, 20
 Oct 2026 06:04:49 -0700 (PDT)
Date: Tue, 20 Oct 2026 06:04:47 -0700
In-Reply-To: <20261019214611.404880-1-yosry@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019214611.404880-1-yosry@kernel.org>
Message-ID: <atdm23p9cUTG7_MX@google.com>
Subject: Re: [PATCH 6.18.y] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on
 intercept recalc
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Laight <david.laight.linux@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Luiz Capitulino <luizcap@redhat.com>, 
	Matt Fleming <matt@readmodwrite.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Mike Rapoport <rppt@kernel.org>, Tal Zussman <tz2294@columbia.edu>, 
	andrew.cooper3@citrix.com, gregkh@linuxfoundation.org, sashal@kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 1F0B58000E
X-Rspam-User: 
X-Stat-Signature: wqhods7am9omfeuxqymkkpzhcg99e6ek
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792501490-954118
X-HE-Meta: U2FsdGVkX18lKvoB0a41s4z36MDpxHcX1q+Yx7tWlaAJeJS9iqXbFjMubEfxNrcu2dbAYvB5d9XHeIMCaxGOI9JX0tRMu2ELRifKX+VVXQYo18ZZmwhe+M0p29q/YLbpXxgK7M985LzE6M7UI62kJjNVWIXcOvr7THz2Ir42B7fjphEqEGqaN+Ui2bsV6ROMxNnIuk4Gmvx9mMpPH6TyWGvbxNz7wZtyY0UfDdxqrYTYykHScyKDzshTp3mEzHNPORVFUgEo8ToCwKltRGvBj3bBLH58aDyv0WqNA3ydOqK0qtmzTYgsgmoJDyH58PgupEWuweCq3t9taqeO0miKBzqy2z5ivqZZd5Gk7jYZmDe5MOauuhSC8nZEBleJ8oQqUoXuy40d2ng+LbgR/m81ZO0gJIu4MlZpL5PCLH8U7qanb7P2iz0EPv9I0SDB57nTYCCp2UK0PEsP8tdaP6DPNhSjQY/YhJyzv81ezaDfv85KaclBz9pggI+WfzPP/QOYQMFMV8dQSt/Z9a6CeQwGCzUop80W0b+e2nYr8HOkVSP/N1XqBfeVDszTv2LQwj/f71v20G9MjpNko64bYj8WVuKuczlQ3AY2f5T3HGq2reWzkw2+q3D1S5C1Qw3ecH6tj+00sGxF2PV8SQXig1OlJGg1ZyB8wkg/taXFH1uCuo5PwYDNnF/fNo98jmYhB0eLYRjx035VGXB81jTmMOuACoHJnyQ2AvJWkWr2RcXXNewby1f1Gez8TyCno/JlvTb3ROYuQJ9dynMOFetpa/rbu0LNdPzV3ujODHeDW12K6altpZAbm5g/81oo6WzaFLzwbSC9lQ0XI55lVlS1I8XsqSn/bN+FG3FNl3tPvlruhbCh241+99ad+JjR5HH2u9CDtvKSGMtOUfAynUETqj2XMaflDSQ4DUguiAhmI7iDeD99A86b1UCVUeWBqXSQPe64yYAk7Rh/gDR5DbZA4r9
 gy8CQWgf
 LatQJchK0qKFL72kh6LYUnhsU2DHIEwV5iM1+SkAQpWFNsgkYQoHc8DVcF5VeqU6mB7INwoJO8N+w/Pm+8FpWp7ZV8Kb63V9kjJEVSZcNUJGmJc8NFXqCTnoPKOV3rpJ62ZNoI4UwuURkCeLAXAet8K1eNGsTBiWMkHr7gSmGX/OrNvnroPPUBcUOcfxfClE6tSih9wyWzCGfcvjxWD2d6Mj7K1XKyVq04QdLZkIjJYw5opFj1R4t8ar6yexHjmTs7FCkxnvuDf/GWQiselA9yX1qeAvJos3RM437UkrwLFVOdI5MDbGupVkrv1ftex66IpSSECuFq0jIH2EBf1SX5p/S1m2USrymGEf7163VyBwEpqgPwdovaTOY5By2pRoF/ddwbn+KJtSjo5ACZd/b71YMRv6EY1G+buAtNQ4zWY4jpFP+Sj/DQj2nsSdRS17dSYwNqxAtYf+g//vAKFTJ+V5hif8aGZP/v//bwzkVeihsxuyC9La2u7w+L1uxrqIJe4KVmUnIhiwNwiIYEpAIPO4hn3apY+Kffr79kOmpksmzJQ7JUyl6M6i9IkS7aLFGtHbvBbLKrMYdjyM/Sg7h6fKcktG1Wsj61q++puKRN+VEfBakgjZK/9xbeQY3je7jkxMbqNx1LySars7XcJMCUL0w5rMqB7wRHRUdpg+lwK+gjQqOJ7rw+hXK8Q5TmCNagTBQx83cKiUNdhhl/jfHRK0ID9FqZ/WEHfKdSycuWreIXJcvOZF5M+Ghgkxz3x5B6aOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026, Yosry Ahmed wrote:
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> [ Upstream commit 55780d8a1dcc93d2c4b33c565ada88df12c9f206 ]
> 
> Virtual VMSAVE/VMLOAD enablement (i.e.
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK) is set/cleared by
> svm_recalc_instruction_intercepts() when the intercepts are cleared/set.
> This is unnecessary because the bit is meaningless when intercepts are
> set and KVM emulates the instructions. Initialize the bit in vmcb01 base
> on vls, and keep it unchanged.
> 
> This is similar-ish to how vGIF is handled. It is enabled in init_vmcb()
> if vgif=1 and remains unchanged when the STGI intercept is enabled (e.g.
> for NMI windows).
> 
> This fixes a bug in svm_recalc_instruction_intercepts(). The intercepts
> for VMSAVE/VMLOAD are always toggled in vmcb01, but
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is toggled in the current VMCB, which
> could be vmcb02 instead of vmcb01 if L2 is active.
> 
> Virtual VMSAVE/VMLOAD enablement in vmcb02 is separately controlled by
> nested_vmcb02_prepare_control() based on the vCPU features and VMCB12,
> and if intercepts are needed they are set by recalc_intercepts().
> 
> The bug is benign though. Not toggling the bit for vmcb01 is harmless
> because it's useless anyway. For vmcb02:
> 
> - The bit could be incorrectly cleared when intercepts are set in
>   vmcb01. This is harmless because VMSAVE/VMLOAD will be emulated by KVM
>   anyway.
> 
> - The bit could be incorrectly set when the intercepts are cleared in
>   vmcb01. However, if the bit was originally clear in vmcb02, then
>   recalc_intercepts() will enable in the intercepts in vmcb02 anyway and
>   VMSAVE/VMLOAD will be emulated by KVM.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Link: https://patch.msgid.link/20260110004821.3411245-3-yosry.ahmed@linux.dev
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Fixes: 5a1a726e68ff ("KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates")
> Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> Closes: https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/
> Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
> [ yosry: The bug is not benign. Since 5a1a726e68ff, a vCPU restored into
>   L2 (e.g. on live migration) recalculates intercepts with vmcb02
>   loaded, leaving vmcb01 with neither VMLOAD/VMSAVE intercepts nor
>   virtual VMLOAD/VMSAVE, so L1's VMLOAD/VMSAVE corrupt host memory. ]
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

