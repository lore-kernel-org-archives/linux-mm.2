Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71804CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFA228000F; Thu, 30 Oct 2025 12:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA668280003; Thu, 30 Oct 2025 12:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC3828000F; Thu, 30 Oct 2025 12:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94797280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:05:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EF121601D0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:05:10 +0000 (UTC)
X-FDA: 84055254780.18.EB7CD66
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 471E4A000C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:05:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TGXhdMas;
	spf=pass (imf15.hostedemail.com: domain of 3sowDaQgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sowDaQgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761840308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9b8XC/fH65U9UHUGq3SmXgvpJYhZ/Lo5B2qlcSERQ0=;
	b=WoYQQYUEtqdg/sN3s/kWvYFU2K6zG+PQIq9EzCBQJ5FVZWisvpA4KtNf73o/gRhTA1Le4y
	ADGtWjTxp+hUMMUPYxeM8c/Whdu6otagoxMAUxyJPdgCm/6FqJjp8G9CiuBxXesmQ5Eg2F
	EKwyXnHq34uoIDPOKOGd8OSHnglM5oc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TGXhdMas;
	spf=pass (imf15.hostedemail.com: domain of 3sowDaQgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sowDaQgKCCkOFHPRFSGLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761840308; a=rsa-sha256;
	cv=none;
	b=TGEyfncwXp0juc4Clj7fUZAACFSpxLWzhvyyFVW6QyOP2dBwSDX1aBBESjvPAJ4ODV4ZYl
	gibhc8ww2JL9GPuihkjN4cOwlNskxarGG+osf7HieVpLTNE+F/F+UUwV29H6GbrEviWvBu
	mQxD4vqTkvDXfiQv48m4/rt6dRexA+k=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42705afbf19so743800f8f.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761840307; x=1762445107; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9b8XC/fH65U9UHUGq3SmXgvpJYhZ/Lo5B2qlcSERQ0=;
        b=TGXhdMasSD0qiPBmLIj1f2XR78B/qS1hFAC4tRPlYWkv+e/ImV7eZ81HjeSe6Yo/V7
         aZFMpWFw3wOQW1Zb/8P+vUjxzD29rLhRnbEcvsEyNO0tWyXZzws5k7+DUD4WL7d2HnsD
         8pDNMhb+iGx4+egpwGmyPCbs3i38opIlBtWBfCQDIzcDg3IS94CW0xKRk0PMUM5up8gU
         Qlo/e8N9Ce7kdYnfM8l1FNCOXtQIPM7m2nufbCSm7NrjHDo3KoJ2KpVs7LX/zjjab/mX
         Mor+FbnaKn9pfGokpUqr23b293S4wt9q3VY9xYdVRHMcXWbdV5PNalor0ixpBlAdjyWa
         k1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761840307; x=1762445107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9b8XC/fH65U9UHUGq3SmXgvpJYhZ/Lo5B2qlcSERQ0=;
        b=r/8L4IxNnsizWuMQcMeLvxOmeuMa2xsNGCHBwTMMGVBOFvWUzNoOwTzSKotZe1igfw
         NT9eI++Q4/uwzcMUfC3LIheXCKQjvInOC3oQD3B7hRdC9FD2Z9KlXwT/9sDYhmaBfYqQ
         eqVIvoaOuzEa7Wxk3QbcBUJ4cT+3GVT0VOTrMUxhcrO822kRLTdeCqPwMVZkMzcA0J8J
         oW2NFMZH6cgbYr9Dc3RsFKt+YYj0durwsK/GXb6zu6IpFzL6O9/exsjWcAGcoI4+uDVC
         EEgG2y48vMNnHOMf94IGG6dy4gfN9KO6tVtMCXwE6CgJEocOl8eHVA/Rl37yJmsMH9UL
         N/aA==
X-Forwarded-Encrypted: i=1; AJvYcCWzbH5ekeeyrwda3a5OO0kTD/3OTW6PHpJbPcGx+3isOD61qQ6K0BglKjdaHvVtTnI6RsfUCM9TDw==@kvack.org
X-Gm-Message-State: AOJu0Yy67jOkz3YCAk6qM8v1QH/nDfTrMkSSlpsBSHX4X9eqMXwfZonG
	/QG/Z/Yz0CcdzFZBO7SUUNhRxoyiwHdsTSOnBhM/255WAvqYBpMr416oX+Shr4Ip1iizgtXyPl9
	10NMhUGKsvwEhig==
X-Google-Smtp-Source: AGHT+IHjMaURNuY5ADspjcwjcl/WRoZFYO9bioemMflpQGaxNDVvaG4JDdR/nXAPdbz/Yfz+Utvfc7Y4KaunSA==
X-Received: from wmbz6.prod.google.com ([2002:a05:600c:c086:b0:471:6089:1622])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2408:b0:429:8b8a:c32b with SMTP id ffacd0b85a97d-429b4c83176mr3266075f8f.22.1761840306279;
 Thu, 30 Oct 2025 09:05:06 -0700 (PDT)
Date: Thu, 30 Oct 2025 16:05:05 +0000
In-Reply-To: <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDVS9ITBCE2Z.RSTLCU79EX8G@google.com>
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qkdcka5tujeabdbio7ub8ya81wxxu8um
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 471E4A000C
X-HE-Tag: 1761840308-106526
X-HE-Meta: U2FsdGVkX18fOOY0P4XzeiEEquSyBTMYEoIbGROjmPS9/cLN8ajK6P8X4K3Cd9arfe9jIa815lK93MpijhKx0eqc+nUb18HCLVqnx1RtwDrXsYfKHFKaweZKV7rpRq21GF5cRkvC2W0wjk11gdKT/0o/zOlwZSb/rT7Z9CYoKFyRq7PGRRsyBhDGotZlh3eWx7JBdkqrF77u4gdWSXxBqR0IbT5mnGhC2+dztREjqIFlEbIjlMFfEgzmm1AuppNE8azqrDHAtEz9/XJpr1PpFV4LS9K6nhWAow1KgPL/+567JiRL6dwQ+LUEG7cNeMnSJSxyKRBmZzjAEXKlcFKb4Ckg69uLe6pf+upRiP3gaKc0HDn6ginWQEkTGWeJ6IcOLjw2Jx/1bTiy4H88lgKkWygNtJh92NAbRKs4qEoIm3PtVjeg52FzPdR9TUjm8bDenj3fxwsXnHGYQAc5bJviTc45bMOjesnmeMg6e9kesaeiN9gSFk8nLspwysWbYVvdh0XMrSptG7odw5xq8J6ZKZc6c3zzwkeQPs4v+xtuCNDmbGtoA+iNkTLBcPZGBYEMtsb3Xk6dpNCMK77O6eHOdh/OVQ4KP6Impwabe2+4PmXzcnG80FGPdO/BdVuqh2rvEoAq9kROzRLTb9i3UyuiylKEeWTetx3XJ+vzY16d0kkn1P/rxn1+meXhOX/6zzvhPaZA9wHbJRnF2NOx4E4bofvtwjFrFLgWuEiF2U11IBdC6ugAfFGe9LLLn+J5Jv6PlG3Dm90CleswW6F/UI160jbRNHLAJL0as4v35cSWAWo9KR6j92SDZflBXwX4qrWUEEA2dktsBIa6O+ZntYx1G+mxIcHdaOKMlJAmecxV54R0bFqFdAcc4Tm9VV/qvbaJ8BEmJ9hfffhNxtObYKLJ4irq13LSt5Aid+ER6JpynTUe0Ji73VNLgLB4kC9sw0cfo/MI5VGcZ8q2WqrNyrF
 +c4khKJC
 ijbd54jlQCQdVRuYW7lSl9ZcUv1Vo/NddDXqIze6EXJye1tPiZmBHfHmKSs0gb3k82ZsLtS/DQedVUs8AYuqcZcZCgIeZF4AeM95nNEyYXkLtuygD61IafEw21kyFgentMopzk+25pnjBzatCHIsBqPPd1p4XMH08aZcP+aY7EMWEaK63fXV2S3SQvH28Jf12CzaUk+qj8RHv33nl/fRoxCnEoVekeqdPj9Sl4bQomdUatn/7zkOs9Iigpy09T/nTC20rIRyXPmBnVbDexzOW9+TDlhS9jpN5VCFnblDH0cahEKPWSbnj0pr4WQFXJiigmfA93R/o7/eSHLnJLGYK7JPCGx23qJOTDwRlK48SXhzaq78r3yVLjA3Y7TkzJivuC8eahhECeiXnO3Cz62dR0teBPOzfvnpAwuotGrXSNWihvGhLEQdYC0S6RAFinqkmlcrcv4g1/8irKqpnxmtghqpSGeOIWwlCSoBuS3Juencwrc0BxXKujVS/zogYTKtskInFsRQcn6wJZ0QSQCg9X0ewhxlf+0C6V2dyjq4as9hjnN/gzza7jnDaYyNH+Zy0xPk7/+bYIJ6ZzGr/ZFSDxrvC4lfhg9g5R5uJbGYeT5CGnWYfpQdKBTxso7fBsH1cCcArFMjdkG7+piE/Angs562kDwHEIIUUnV577NhSPPkZFLhKoR+iOROlKhrEhM52d4pqMge3/IQndMopOuywR/niPmGix5WY7HyOvTA+VoorLwdEUTPPpUqy76Id8Lvz7CNSJhQsaixCN9rCx+F56JD1P79RbM9v+ccCiskZP9xCgzOfwUXb2dAYcHqv4CZW6X8gEXd15b60x2n36+1PDwheFHyzOP2FDgxQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 6:27 PM UTC, Dave Hansen wrote:
> On 9/24/25 08:22, Roy, Patrick wrote:
>> Add an option to not perform TLB flushes after direct map manipulations.
>
> I'd really prefer this be left out for now. It's a massive can of worms.
> Let's agree on something that works and has well-defined behavior before
> we go breaking it on purpose.

As David pointed out in the MM Alignment Session yesterday, I might be
able to help here. In [0] I've proposed a way to break up the direct map
by ASI's "sensitivity" concept, which is weaker than the "totally absent
from the direct map" being proposed here, but it has kinda similar
implementation challenges.

Basically it introduces a thing called a "freetype" that extends the
idea of migratetype. Like the existing idea of migratetype, it's used to
physically group pages when allocating, and you can index free pages by
it, i.e. each freetype gets its own freelist. But it can also encode
other information than mobility (and the other stuff that's encoded in
migratetype...).

Could it make sense to use that logic to just have entire pageblocks
that are absent from the direct map? Then when allocating memory for the
guest_memfd we get it from one of those pageblocks. Then we only have to
flush the TLB if there's no memory left in pageblocks of this freetype
(so the allocator has to flip another pageblock over to the "no direct
map" freetype, after removing it from the direct map).

I haven't yet investigated this properly, I'll start doing that now.
But I thought I'd immediately drop this note in case anyone can
immediately see a reason why this doesn't work.

[0] https://lore.kernel.org/all/20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com/T/#t

BTW, I think if the skip-flush flag is the only thing blocking this
patchset, it would be great to merge it without it. Even if that means
it's no use for Firecracker usecases that doesn't mean the underlying
feature isn't valuable for _someone_. Then we can figure out how to make
it work for Firecracker afterwards, one way or another.

(Just to be transparent: my nefarious ulterior motive is that it would
give me an angle to start merging code that will eventually support ASI.
But, I'm serious that there are probably users who would like this
feature even if it's slow!)

