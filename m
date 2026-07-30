Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D021C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A896B007B; Thu, 30 Jul 2026 18:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACC66B008A; Thu, 30 Jul 2026 18:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E506B008C; Thu, 30 Jul 2026 18:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7C556B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:46:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78895A1439
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:46:27 +0000 (UTC)
X-FDA: 85046928414.10.9861270
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 842E720004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:46:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/85cotQ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785451585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
	b=RM3asBD1ry79ldX6Fi2neUCfchJcPRHNswCzdb64j5a1r3dfkAMHXAxcSYyfFhZuxLA4KG
	V7Dzgn7sHfEVp9K57H51ELJtqfmEhQdeu3u7Hpah5/5zoGd03Ea5aamvX8HC/nOHM5Gwub
	w8E1y6iEfCnK9Dl8LLaZtTxfEiBRYho=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/85cotQ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785451585;
	b=HxRVhcL4vBKzCL+6B2SGuKa7y1J3qSIXlgdeR2DuyRvY2Lhv7wrLi+hvnDlSRmho3mvWRF
	613vA6FVz2ki7luEdI3MzPEe/iPwq/lyEZni3VXK5iCqgQm3RsYBuQuSShlw1KlERlFfmH
	4c7XO4IcMnfhPtyQTJ+HpnQIDRYzoG0=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38101f85591so1065644a91.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:46:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785451584; cv=none;
        d=google.com; s=arc-20260327;
        b=altKpedqEppCjacIXgKpLu/Mim2P2Pe4nu+MvudLspcIlxrGsa0ZTPbTTzPaCMpTMH
         8l2ExaPzlMdjjtzTqH8do8149CyFThlSgkHIfJaJZNAfaPb9aoZxGOJMkdcSnEpfouBZ
         o7gronCgkAVRjAVOmrHW9Xh63dfKJJNU+KJD5IuDxXxOy9fFI8Ri28NBsG/gQw4LP4cA
         5gSnxyRFgkkVklyGNJDjt52TW9wAVYxM3AhCmdr+9QGMaV6ShN9FBwi6JxqgxiLv96m1
         T80oFAybnc5PegkDOXqMKgXicceeK3lGzQLmXFucAruRFt7gUOflVdjsoMuSovz8pMk1
         8W6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        fh=lgo5cpKap9gUOby4HpM0ZG37CbJOWh8XLIEgZnVyuIY=;
        b=jxQlMf/tJLrXq9OhXX+ffSEoPsOqhYMljs3q9JULk5GnhQtBLH0DMtTE+RxfQJYGyH
         pi4svhG77u2MPK0/6W0Zdr5WhxGf9RBnrgNxwr3zbd8Z1ur7ESPj43pEsmFDq3nbnEtU
         M3v6/Qgc31Q7yIbCFhTZWUPZ+qKaYliGhDrNFUFf6Sa7SzYhFHtudT5cRf6q56AL4GDU
         VbqPn9qqEhviqnm98sesdoDCw3zGoBxCk9cm5lMdknmAZWfY+mOUUXbI+ssZduorgjTd
         ZpCdTWX69Uod79Z4MyHLJQkiQT7W/l2GNn/3YtJ4NcYIOGWTCMfuyfUT8LAN45Tkicp2
         Az+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785451584; x=1786056384; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        b=S/85cotQc8szGmr3uVdhVJY281U49dWl47McuIUDNkLNboQLIzSWB019fNXrUCYS52
         EORpNG+39HHYZar11sCblXwOXM1bqWJdzARStQanbyH+hfFkCRbmQwS+GbOjVAtfytx+
         uR9iUQr/LsgpDnEN/NC8MJBhw1A96mjDxCshGkJB3Y9eiFXrKTeczEuAJRfraCWBmFjd
         /bIRNClt/pybiiKcHPmlUCFptv93UFsf/3XbOFdWWS/xIhLHLiT9l4ewHoT9a/kUMRQZ
         pw+/M4iyQ36D0DqPOlDaUhL+QkfwG4fIeY/8KkvN7xIF9imVzmlLGA0njzuLI3GfnGx3
         YMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785451584; x=1786056384;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W7DZ+f0MeQTnq04NgpGqANM3Cz0BYewhjBpaHxc9ELk=;
        b=LGV3vDvTY21L6dQDkG9TIy5QdV+ZQUHgITIL49F8cYHfE5gabu7GugPfltHi73iwUJ
         FAmQr7cSGUhWMKiL7YTiHhb7OsAPwDVXSvoqVgRhI8U58kQX0TdtS17+WW8nc87HFwbR
         7+lwCqoaBcSpOMTZ3wRFcw44MiBqMGxJfUWJm41OVBHTPJox22t5+xTq8dgcBaP+hYhI
         ZFyOeAWbe/MlFpSV+ftmNviAv7lmeN33t8C0tUQRAVnrHqdtgkFgSvXDEAI2eS6vdT6d
         X40fKa5o09r6MGYvhYjUYpTGMfvlozP/yoJdSC75D+yNOWEVvnm4vLiHhX9A0pR9Vbb2
         7hzA==
X-Forwarded-Encrypted: i=1; AHgh+Rpt45UbqkNfq9T5xj0UyvgDK+tO+fV7QRHk/HHC4BVpS4zT6daLHp75T+tB09Cw3WP6CAMTwXiFsQ==@kvack.org
X-Gm-Message-State: AOJu0YyHQr/agk3OwjcWk9Sas4eX0vciwxIMgqWzTcZgpoI69u1g4nss
	/StTg7iJGQBnox4fV2in1GVroe5xfJj0BCEepC+qlvj3WLTYiovP6IX/t6ROo/DXpMcPGB60uXd
	cm5dPC8HRAK9kiHP0Rkd+e6qqAsOy2uv30EYKZmAG
X-Gm-Gg: AR+sD12IhMaiHW22SUabdb9Q7RA+474qw9VFD3ep8ar0rIfwsXIjUYR2lxFaj1fbI67
	P43Zt3yoDBJJReX4avnNAliuHz7k5gurf/gqi7aB7gkLcpWaCr6p2WPFC/sVTS+qFEsJcRb9l+L
	f2Bw4osfnQMJsAaCx6n+R9LWAZeTjyTq6NumP/ZyElA87STM994RvGK5QTeJeLjnCKz4dJQRLW5
	Z0JMmFEQbTXN/QAmkLLZTfPW+VMF/nHyycyOvxUsT4UAFTmG3G2EAc2SMsksMAHHjz5tWIR0EBA
	z2PsKgijGPLEUlJuRYxYx5NnE3U38xfn0XGYO1mUtLSjl4PToh62TiEvTE03wBjQnw2xCRHNZtk
	O/LLZ9KFK5RyMGLrsXh1diq4UHFc+bNRaBDAYBYroSe0OIA==
X-Received: by 2002:a17:90b:2f06:b0:36b:b903:994 with SMTP id
 98e67ed59e1d1-38fa68500b7mr1838360a91.4.1785451583701; Thu, 30 Jul 2026
 15:46:23 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:46:22 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 15:46:22 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <afEwWZksU0Fw61oT@plex>
References: <afEwWZksU0Fw61oT@plex>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 15:46:22 -0700
X-Gm-Features: AUfX_mztKVf-vmsid_VHO9yf9OChzZkQAo084zzlpI1FA8C_xfqYz8r7z-LEAo8
Message-ID: <CAEvNRgE8YHXVZLTQQYZJrJvnrW+WUfpGUn2XpxpkDRj1Zwi4Cw@mail.gmail.com>
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
To: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: rppt@kernel.org, graf@amazon.com, pratyush@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, maz@kernel.org, oupton@kernel.org, dwmw2@infradead.org, 
	alex.williamson@redhat.com, kevin.tian@intel.com, rientjes@google.com, 
	Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, baolu.lu@linux.intel.com, 
	david@kernel.org, dmatlack@google.com, mheyne@amazon.de, jgowans@amazon.com, 
	jgg@nvidia.com, pankaj.gupta.linux@gmail.com, kpraveen.lkml@gmail.com, 
	vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	loeser@linux.microsoft.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	roman.gushchin@linux.dev, akpm@linux-foundation.org, pjt@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 842E720004
X-Rspamd-Server: rspam01
X-Stat-Signature: o78e6r35fsuiuroxnf3fdinifbca4wau
X-HE-Tag: 1785451585-316616
X-HE-Meta: U2FsdGVkX18krfhmTZv6NsfAcNekJk5IK9PEhUT91xnH9rJL/eXkPcU5P3CKaUidus+IRO0Fb9Y5svEmd8aNtGXX5tQMRWq+5kE9VShRZawTEqf+ZyE1m3pWcSZhpVCl6Te96RRZJKTPMpYDlHWSHllcD2hZq2Xz1Lhvlgmk7YNy8jugvSxE7MtsByCumir5iUO4Q4yjUJULtgNCf+Qn6Un/dJDc3zJXzzlQ222Na1qCHpz8akRcRPC84ZK1jxgDJGpPGXOpAu/jl1jliFOkE3OjOfq0w6g9+RNqr/F2i4IN8NI2lFUTu9G5tz28xNFFX/70FgBfhjMs966irppZ7ZR9ieZS0+c2YSgqJetgdesi4wIRRRKcfu4ScBIvudTxRVy4eQrWqUoMqS3VFGFKivVEP5NFXERVnb9EF4KUn2tmytDlp9Pqq7IBLi/nIMOfX8oGUKMkYmXKlrMlCOm/m/2Y03zADKEkL2x3TbfQKqxHSPfdsgWcsr/9PxuHB7EJ3UVZPDp6XD6iXjtP8LPgFAU1hkktGb157uQoY6mmydOMKL7RrwLiye/xoJkBZa1pOqklJaYMmRCCBwyLf4S94LBcD8hJuXJM1cU5MOuf1FbVpbWiJ4VYCCgFiR8+T+JezSmh2TgV3MjAOohZNg7uUeqlPzUX3OrtE0kpHACaSE/gQFy6HRjAFi5zxWE9iC270p2cV8+ptQ4b7adqgSS25XzB2WpnS3zcQYgn27zAZx7kgqRaiAJ2NihzX3zSg9XdDzZ+7dal8bvrF5T+vWX1c9fj/oda++R9owiJI0VZb5D/b7Z8wI1DGFuqeTpqHLDT5gSobMC2+pze+Bw6KtEL0xbQLByLY/HzxJeCojv5FC6IBPLs8YaF1Vhnb2HYSe25UCzOt772ru5NYJPUsHBmfYALhra6YbJzLdOV31vSWFACWFjW0BdT1kC4O1P1ASsScfl1+OISMwcPnWoYSLy
 9zygiH9Y
 QzHdms7reYnVPuuQhvFPrCg6sTpzWxFT2bGdkiOv2FDSj0iLnAQuBhLP9Fq1bxwhhs14FPiQBQ43YcPrblj7f3UjLGB6yOjOQPETKczulJXPGXKpCRhTPVmYdteFU4WXqk9sLT49B0vlbkij3mSZwOFSgzpD7H9PCbWBXzb/LUgt5dBlF/ATbHS4kdyMLFjMCtCAdYcOwsrx+z/LmyGZ6t2/jO2Ceok8zRLCFSCR+zgTSixyqQdUCQsaJ2IZxxbLEjx4Y8jdZNaF3wWUwixMfrlBY2oD//YUEGxAVOx80FNUgv9QYSaoyIHGgi9uuv0ys0A58uTFNDH0+rkat9XnuwfWIeP9ftteBw8IagzdwJ3w92uBW0dfHEy4O2+pbRhiafPXUOXU0rLYHFgA21uRNwZAQ643Qdum277FPywS7z8sBV8I3CnLPfiqoU3CpqTbkt3dPwsOqWDlxW9WWX8uzM+KmTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

>
> [...snip...]
>
> The Caretaker
> =============
>
> The Caretaker is a specialized, identity-mapped bare-metal executable
> attached to each vCPU. While it is installed during the initial VM setup
> and remains permanently enabled as an interpose layer between the Guest
> and KVM, it is the key architectural feature required for a VM to be
> orphaned. By providing an execution environment independent of the host
> OS, the Caretaker enables the guest workload to safely survive the host
> lifecycle transition.
>
> During normal VM operation, the Caretaker acts as a fast-path shim: it
> forwards standard VM Exits down to the backing KVM kernel module and
> handles certain exits autonomously. However, during the "Management Gap"
> (when no host OS is active and standard KVM handlers are offline), the
> Caretaker enters a standalone mode to ensure continuous guest execution
> without host intervention.
>

I think this might already be explained in different ways by the other
commenters.

I guess the main question I have is, if the Caretaker could indeed take
over caretaking during a "Management Gap", then we're adding code to
tell KVM what to do to handle some VM exits.

In that case, it would be awesome to have that functionality provided by
KVM in the first place, to avoid some number of kernel exits to the
userspace VMM.

> While this proposal focuses on its critical role in minimally disruptive
> Live Update, the Caretaker is fundamentally designed as an extensible
> primitive.

If the Caretaker can/needs to be extended, then on the other extreme,
the entirety of the userspace VMM's functionality could go into the
caretaker, and perhaps that's another direction to go, where maybe LUO
could keep some slice of userspace alive? (then the VM is no longer
orphaned)

> Its architecture allows it to be leveraged for a variety of
> other advanced virtualization use cases, such as running custom
> lightweight hypervisors or completely offloading virtualization duties
> to an accelerator card.
>
>
> [...snip...]
>

