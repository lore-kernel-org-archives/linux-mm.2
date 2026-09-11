Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CCAC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356E56B008A; Fri, 11 Sep 2026 09:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F286B0095; Fri, 11 Sep 2026 09:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245486B0096; Fri, 11 Sep 2026 09:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03FBA6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:44:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F8EC140177
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:44:54 +0000 (UTC)
X-FDA: 85201602108.19.2DAF5B4
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8DB2140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:44:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nPRJYrct;
	spf=pass (imf04.hostedemail.com: domain of 30wWkagYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=30wWkagYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35qTFGciq12kEJU+EMJ4woELZzEj6I4YMtoPAd4aNAQ=;
	b=PilGyyo+nQ0DQ1qC7VB/d7cjdTRLsvGKPtS7b62GtQhiH9X/nFEmjsDIfaFllUAanfNVWM
	zVHfmD24JvNXhs2n0u0xhmrH/mDG43C2dgln4W2jVXa3chqwcNz9h8fVbOizPLDU18rvoF
	fD4CTbP7UTqESP5QqJdy5i5hmnxWpqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134292;
	b=h5IqARpBoNxbbOMTti5K/HGdXGHzHjxGQwnswnjviZKmXmLUegsML+Q1/EvxU8IYOAczFu
	IW92lUcQgnxDe5/rYCtnhsUmbG8Ynvo00kMbSvE+P6RkJOVwP2l5Nw1zWCnG6Z6biJR8lv
	9Bc0pxvNrNIpiSpuiqMPUYhCfyRjv5U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nPRJYrct;
	spf=pass (imf04.hostedemail.com: domain of 30wWkagYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=30wWkagYKCMo8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb835525b10so1140591a12.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134291; x=1789739091; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=35qTFGciq12kEJU+EMJ4woELZzEj6I4YMtoPAd4aNAQ=;
        b=nPRJYrctTAhT5fvsUKM/u+DUXplSgDm0L1c4OmLI0JBEHGuBsTq66L0LeAXmb7Troj
         wH+J74Ne9Ga5HJCoHT/+/fM0fvuoN3onlCuHXitrR16rP08yFsSfVn6dSNiKUtTwyo6a
         6v20PaSAKKeTgpIcDxuScfsZPAqjK1LDDmn/XPIfeL+rBdPI5Usx5+UHJCFxzghuHsN/
         ZuS6sbG1KdzhUzXP/KEMUTtTDV/CilAs+TNpZGux0soJ0TnvskjZpOQLk8SAe2jtjiyC
         IhXM/TeLOZb8mqVKoqtrStm+Cn4/MUeY8WlttjYTXvz2oG5dvPjnmLdBT8sb+heY/S0v
         V/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134291; x=1789739091;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=35qTFGciq12kEJU+EMJ4woELZzEj6I4YMtoPAd4aNAQ=;
        b=ABD6ezBKX0R2PFPRdyDD0vg8QSIj7isMSPII83l7VQLOR2grL1eEYJTbne//f7YuqN
         zZgio/f8BlTi2Vx+cNs4WvaY/vTS5FthprcuDd7UaD5i9svmjcpkav87Ewa+38riJPRe
         TuzksV+zqUzvN4xFq5IREYonRf5xX1AOLoFWWutX5WjsvYe2gJRjREbC7io5ahc2NfNE
         TRGh/dU1w06ZjOGLaq9YrGL/Vtdb293Z4kIyieADRUcK2W3Q+3zqty/K7P/BDuGZCa9t
         bw5fYiRbQy/megHMJrToQh9zAUAN/fmAu8I30c7s/hQOyWwvYsRq8iJ5Q7qMT3UZcnyP
         6xzA==
X-Forwarded-Encrypted: i=1; AKwUvBz4JSfP89MNJS29KXL/vYBf83OP6ql7EM7Yep3Is2oznBER+HinnSp6v1yyd67Tz2nAoiY1GcKPsA==@kvack.org
X-Gm-Message-State: AFuF++lVoaKjM7XQgVtuiHJrGtqUk9yqMIGlz4x8+838AOzcUprO9G+B
	5wamZW4UnmswGDzao0XgYrlYMnsXOtNoza/MyptQW5af2T6p+WIsynjraxPcv/VsWLMMzJDwrir
	b/wc4Zw==
X-Received: from pgjj10.prod.google.com ([2002:a63:230a:0:b0:cc4:5907:21e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:b08d:b0:3c6:61b9:917c
 with SMTP id adf61e73a8af0-3daed1fd3cfmr8633653637.11.1789134291123; Fri, 11
 Sep 2026 06:44:51 -0700 (PDT)
Date: Fri, 11 Sep 2026 06:44:50 -0700
In-Reply-To: <20260910225728.GB857650@nvidia.com>
Mime-Version: 1.0
References: <aptFFYqcSiBdMLE8@google.com> <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com> <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com> <20260910171210.GF3968357@nvidia.com>
 <aqMgjXfTJ8u3n7Kj@google.com> <20260910221832.GH3968357@nvidia.com>
 <aqMyXE-fD-UN6w5L@google.com> <20260910225728.GB857650@nvidia.com>
Message-ID: <aqQF0gz3Q2weDyEd@google.com>
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>, arnd@arndb.de, 
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com, 
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org, 
	kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8DB2140007
X-Stat-Signature: zgqj8hhpdeymk6pspjnwfyffcbaafqhe
X-Rspam-User: 
X-HE-Tag: 1789134292-164373
X-HE-Meta: U2FsdGVkX184dbLB7jgs/Ky86daXrEhqqMaUwhauc/CqfEbIcpm14U31D8DQ62KrR4UzkuaUIXDtHjUcAhyj1MPYbB2MkWfaumSewZHSfag4hSCpVsxig01guv3MUPECvWmGMffFI27g8GJ8yXANIGbN9uynIdGkoK9Z2vP5BtmL/M0vjwdFGh3BFOiIKcVhPdgU0uKaThLlMEFssiy8SgQ2ytCQrFnyJxk+HsveWkfmgJT69e6GcuBYJj0xZs1zExfPWgjp750yQFEzxL2ntD1zi2ZMZ9DjWdOXEt+XWzr7+xFuNm3QLo1NblSnvIx3B3miooxSHbqDN/Nf0q0jq/qD+MsaDcG1dklknTjVLcUIeBLQOdf3TgieOPPB1SbtsD0EXAPjNzgj8DXYB1ukeO1iJhTYOJGxVp4LbXlX7bsp6pCLTXCNiz3Mf2UZ4eVM7iahCHrDOmjmHE5SPevB6U4YtXLolHijuS2/WUy8gB3CNuT9UlgF2lb3w8sJ4inHhZ5fNvY8l30hq/VAder+cl+Ft6YiRAM8ksFdSJVQNqOjaPK2esPGXgSWruJgd8i9IPgaNqTnfJT2FXPsd5ZvpC39JreXJSCGg/Eg+ZFdB0n2gerbjlhc8uEJzmhNL3ecJrRTgYirYGceGBrmQ5ik1NnYah0KOXyXSJgC0dLe5CL/VXGSVyLmE+ba9jlyzUG/i34ublR7tpytKqEe18y1jomivxbR2wgi+sJELErsUNAKq8AWY//0kBlpPQkiiBaiheDh8H75Pexu+U8kF5EJLkPMAYGOFDcrrk1OGSBU12E3HJZbi8XVaRR/DnCnj2yMlo/KvLDtrTX57U51LUar+dr4SiyT1RS1P8rgz6Lj40P+6VVm41IcL2QntTv5wMtsDwsqMcvIuj4HC1uDC7htqzx6Qv422AcoqG7jJvdRpt02osIG8gyHJQqKQz84+WReqtLzzRwHf6LlJAiw95P
 C67ueHlJ
 flx1n0YFWuoPLBKffedZv+5292dyPMlnsd0egdpXgIdpGFxxlhEYV/GBaycJb6hhp0+5GkcugZPtkhE+kbAnq9Pu+AGR5MeY8T3PlemcQvou39spWGA/Gb1ya2iomxZtIDzU8OmlRxJQUpizIZhC8bI1yP4PRyid0xkv4GxJ6eR6WGThnFhVHExp+zFJ/Tc8GePxCBbdfJ1COpxT+G4TB9wAYN2AtaeMxbpoSvSfHFxaErjUs28VU0nl1EX98ZJzsuvDw2mxFNkJqNzqSdlM+5HKTsho8+fAs3XGquufpYhj/IHK54BQofCGl1DAe/kRv0wrV8j4rvKocHwMksQUOkpVv9OvfqdllTZOY1hxDSC6/gRABF507bfwFbDAvOvvFHiPld5/Z/GvZzLIzQ60S+ZGKc/lCd7oiMtkrnCjkm5BIdCul1JVlp+kWX701S5HYjQNgTdirCqvgWI/w+DwTbUQFjyHdRLSFPGL7eGUKB1LcLXbXOFbvjyo8JS8e7tNQ0lAmz+O+ZuwyH507juz1I6uHFjFs7hQipvELv/hcetrRahgjAcuNx11n+NnBqU3Z2FI9vV/eOO/+FUB5971EQL9JfIF38lWZQMXWwpkJiU5YmLeRDLLnq2nbMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2026 at 03:42:36PM -0700, Sean Christopherson wrote:
> > On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
> > > Sean's initial email was asking for strict never-break ABI compatability
> > > rules on top, and that is what I've been reacting to.
> > 
> > No, I was never asking for that.  I think we just have a different interpretation
> > of ABI, or rather are talking about different pieces of ABI.
> > 
> > I am still asking for never-break serialization format compatibility, i.e. the
> > more literal save/restore ABI.  I'm not asking for full backwards/forwards
> > compatibility across all kernels version, i.e. the higher level "kernel" ABI.
> > 
> > To phrase things differently: I am a-ok if kernels are inherently incompatible
> > because they fundamentally operate differently and/or support different features.
> > I am not ok if we end up with incompatible kernels because the save/restore
> > interfaces and payloads are poorly designed, lack abstraction, etc.  
> 
> I can more agree with this, it is mostly what I thought we'd end up
> doing anyhow with version numbers and growing the structs not
> replacing them.
> 
> So you still end up with a version label (string I guess?) because we
> can break it from time to time, 
   
Why bother with a label/string?  I don't understand what it buys us; I see only
pain.  Make the features discoverable and punt on all of the "is this pile of
insanity my company has created compatible with this other pile of insanity?" to
layers above the kernel.

IMO, trying to capture compatibility in a version string is doomed to fail.  To
be useful, the version would have to be extremely sensitive to changes, otherwise
userspace will have to do its own compatibility analysis/checks anyways.  And at
that point, a verson string will be too restrictive, e.g. will mismatch due to
changes in features the deployment isn't using.

> just the version should have the feature mechanism layered under it? I'm fine
> with that
> 
> Jason

