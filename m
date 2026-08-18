Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536BDC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3446B018E; Tue, 18 Aug 2026 12:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AD46B0191; Tue, 18 Aug 2026 12:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CFD6B0577; Tue, 18 Aug 2026 12:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0061D6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:29:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F1711A0197
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:29:52 +0000 (UTC)
X-FDA: 85114926666.01.07A8D7C
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 382F84000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:29:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JRZ2RD1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3fYiEagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3fYiEagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eyzaZNjJLEyd0fKbeRAuoUQBuqF6sdPIInoyVaJmj0=;
	b=6vqYqzDKQd4KyUZkZ/U4wyKTojadIzrpOzAa+g+Esibh2ZVW941GFazljxh1pHgdDVlstq
	VUCSDyrVZyEnmCVcUrBSRYLlBo6J34b/ywBeM+HejmAsisps4PzIqTBrQ93tl8B56PdXbv
	VP6mFRLsInCsUkhpLkHrGQfA6IZZxys=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JRZ2RD1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3fYiEagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3fYiEagkKCPovctwpucjwiqqing.eqonkpwz-oomxcem.qti@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070591;
	b=2B+NJOLh7sWwYffArtHu0B+nzaqqAEdCxBtVyBmySBZvVqIgWMuNT61nG63qqgMEghF6Kj
	O/D4MoYxxqPs4AbIliRTglKrXG8G5aRl+9PY1DM8U3Jc5vM0RR6g3IgmLuts021TIbBlaM
	4rqdLrepiViKqttCBFDjEmU5tKXxgtc=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a368c27a94so18802a12.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070590; x=1787675390; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/eyzaZNjJLEyd0fKbeRAuoUQBuqF6sdPIInoyVaJmj0=;
        b=JRZ2RD1LKX38BKxV5PaOG4f5dTGsX0w8Lme4QevUDQYaieyM2jtVtvhNLoBi5739sx
         2pMPEUwVC5HNpdy8rMak/GTk0NlBoXizE3kWWbMFPuCo0Maa+egmfyhIDTvIpplXkS7l
         g6VVaOmQxNkPM9F/rLp8yuoju2cDxF68fQUDGyi2POFTNV/+gUWaVR/M1wT63pZeRdkZ
         Jik8Y8zvmwZ/EFrAtMlb8Kh6K7NMPjtQpdS0u5S/K+6At6RWQeeJGQMI9hpwV8bKeFKo
         /XRtS0WOTE5ftoZLBTxzNaBgMS5kEKj0iavpmtO+OW6aqPhH1G6hJXEr37ur5Gqgq2X1
         Nm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070590; x=1787675390;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/eyzaZNjJLEyd0fKbeRAuoUQBuqF6sdPIInoyVaJmj0=;
        b=XLZI+cA6LQfdapKsQNcG58tWDouK8Of9ZSHfpmtBpc5+3RbUfR7ibdlrnLFa++mAEN
         kgvGmmqW0vQvRFwVGW9KbbDGBBE0MpHQhnUKVDDNkL9tVOPDRtj/CxfZ7xHzi0sSExO0
         607Ra7V96qIjdmNX63TyWVzBHOvKGOt3WQywf12/fmRVdhkEXHh24fljJPWa+8cvQVZN
         nMbo5Ja0UCRxVo9CMG+MFAN3rYmLGBu95+POKMlpG8GzkmD9eXNDq6swlGCsFCAj31J2
         a5LgIQSwSFrkicXEhlvaxrkdYNfvk7tkOZPm43ELx5kSq7ZFKlXbKUcVJxpbSex4T4fQ
         YQkQ==
X-Forwarded-Encrypted: i=1; AHgh+RopXkR7OuMQZJzY4x5QTnGPrK1170bN6z/ZJjUNnBAdU199cCtV3JBAI8i96Csa/jGEIyWoViqCvw==@kvack.org
X-Gm-Message-State: AOJu0Yw7zrv6Wt01bNz/1Ax3WWSg67r+1BVmjqVtLWxNwsxDy7Ey38YL
	C9C8TvHFhgxqS3nfnP7l4NNfabgAbd/B7TooI5/WMWhnoFlJ+jm/UPTPRtjrX5Oy6Sy8vrxTn4H
	bzRqVIy+Dz67vXmXN3A==
X-Received: from edts26.prod.google.com ([2002:aa7:cb1a:0:b0:6a1:f410:2ec5])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:e85:b0:6a3:edb6:2228 with SMTP id 4fb4d7f45d1cf-6a3edb6285cmr3681617a12.17.1787070589499;
 Tue, 18 Aug 2026 09:29:49 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:29:48 +0000
In-Reply-To: <anpdYD1UaO0ffQgi@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-5-tarunsahu@google.com> <anpdYD1UaO0ffQgi@google.com>
Message-ID: <9huzik57v1c3.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: g9dex85a8gyj3w9asfi9iq5ppkwe5ut8
X-Rspamd-Queue-Id: 382F84000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787070591-156793
X-HE-Meta: U2FsdGVkX1+lJ227cqf3Iht5L2gEP6HW6h5QvBGZdOhOvuP9fm8RVkl8k8L0Vl8aIPi138lCRHMA9ZkvMwhOsFPZIHdBHNOf006N7y+VIG9FEe7t9215ohW8AeBl4u82XZisgTrHuWJYN20hnT3MY7Ce1qnfnRkEP3nDc3ud3eLO2H1/7NGP4sJyGrt9Sys7mrBpwjM4eTxyZNXivX7KWZtplPO7xOjj2uYzD0yr4YB6wVNHG+9tgHMDvPkl2Rp7+MUMsQBtfw+KoxU9fLalmHaUJijcqbOVwElHxsXcwDtPDlzYgaYALMsoifQezhz9gK0QQF03ExfER/69GiqWXU7621vRig9uCkTNfPBb/dSDvoRhKwEbuqrXNp8kXRhAX5ykQ7T8Wx4+12XNH0WPfCCVVf+9HEY1fNc4ClpcOegaCEwAxiDwnru4F82TRAQI0dRQUSwhSh7UbPNhOZY2KLufGM/9JG7MWq1p4S/6r2x8v2wnXlVOGPbKtFI/dS2z68bCkoa6pcf+rRhoPBdhNwoeQrDD1JDhzhuNcA84p/780QdLdcVVSN/+kO31DEGQu7b1/PNkbdksk3uifNaCFqKNHW0xHxhYLvZW9XAreenEo5GUcQGE8JKO/3hukUVxbSQrLwX5fPv2diXpPQ1DMbOyq9LuoC0mChlKaLHFBEAcRiXEM3Pe7iFtrK06Z9tiX0JZ0pEUiLK551JpoSpagj09O5zmAhZleKp5VpNahbBKU2DgTaBIhpo8qhB+U2FhJZegSoLNSVRpAGYlZKnZz/Y3vYW4zBsf8YSDmFT+Mrd23r6A6ifq8RxXtDMcvJKckmEFj3J+oM84DbTBROm/FBx0jmeSmGP0zjQbHz9YDGsvkeFknPS4M9lmHb/RWM44jfHZD02diPJ9/nmLrnm5TDEXSqFdDMTWB+TF1zaLeuTmQn4XG6F5bOskVP0O+h3SDqCb8rjfMP2vlR6iN/O
 CYQm1YV4
 Y6OSo8Hi9uvB+CwVt9Iffk2RGHnYfVpHYsxUI+FB7pQGaxUWRDNZV7OdwBAcC2qIEb3S4MLVJ5f/uGbD6kPluzn3jzWTjVIBbJk6X6mcEziuDeVbFGx5VIAXXFbBGZSrEEumFDE47EvEl7+CJztuW3NppUGFBlY8fe2EWaQNaWSr72ZmQBCwpJ50eQ3e2FKCaE2w0PYH/bD7MHjfxj10u8KcXT94K+cQwK+GCoDj/1M+wa6h9h7cBXcZTo7R7o+0R7PcXTMT5gH5hiM+hd3awcrJ7cQRkdh33TcnoTmQfC3xUxva4b/3tBh8mntpAHPvg7yQsU+EYYEVJOrci1w6pf2hRbA0V0FJggkzdjqP3tIKIXpdIud0uMxIXlCaAal/DR44JPnE5SDP8wCq1iGdj8Q9kAREQpv0ZP4nu4tWmhkFwGUXvT7ZV/LXkIaNCpBvgolnqbZe7GtfMFVLUR5zE8l/eBrFls6NznPPLo1IOqsKIQ4vU0ibh12pD6S47XRHs3cNiBdfF6Hy7WPJNk5O4vcuBaZhKf6LYWig0uz/HeRUjQHhPBvlpE7L2JGLxGWEvmB+7UXhnP0MEnebei9jSvmgbO1ncmDJ/CjL9lqTlj5cVxgb7lZKgUYsI9hZ0uWfYJMzK/UYRV+o+ZAMdJYNjJVBG0E1BHex0dk1wzX5zmMUxctw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> - Add a weak reference 'vm_file' in struct kvm under
>
> "vm_file" is effectively already claimed by vm_area_struct.vm_file.  *If* we go
> this route, I would very strongly prefer to take a dependency on "vfio: Use
> file-based reference counting for KVM"[*].  I'll poke that thread, we really
> should land that one particular patch long before the s390-is-arm64
> insanity.

[*] Seem interesting way to solve this. So we will also have vm_file
directly in guest_memfd instead of struct kvm and refcounting on vm_file
instead struct kvm?

struct gmem_file {
-	struct kvm *kvm;
+	struct file *vm_file;
	struct xarray bindings;
	struct list_head entry;
};

>
> Empashish on "if" because this all feels backwards.

> It's not at all clear to
> me why liveupdate goes directly to guest_memfd, but then requires a token associated
> with the VM.

guest_memfd can be recreated without having the struct kvm, Which there
is no way to pass it on retrieval path. So the function
kvm_gmem_luo_retrieve() gets this VM token, find the vm_file (hence
struct kvm) associated with the preserved guest_memfd. Now it create a
fresh guest_memfd by calling kvm_gmem_create(..., kvm). And populate
preserved flags and folios to this guest_memfd.

>
> https://lore.kernel.org/all/20260731130902.654679-2-seiden@linux.ibm.com

