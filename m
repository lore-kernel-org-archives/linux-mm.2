Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30F4CA5FCE
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 00:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7976B0088; Thu,  1 Oct 2026 20:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A80B6B008A; Thu,  1 Oct 2026 20:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEA86B008C; Thu,  1 Oct 2026 20:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 438106B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 20:00:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96CCDC05C2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 00:00:49 +0000 (UTC)
X-FDA: 85275730218.25.7A6A638
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F1E01C000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 00:00:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=fsZrsXbw;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790899247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cG+cJ7mT22tNPHsFBNtxnr+VztjGQBeRNYYjS2dgVhM=;
	b=eUBZnH3Rkac4w+wJwbYqWlIIOpGFLRk8GtkGvX04kbz04CmAfnt+icbIXTd0K/nvWhIAkM
	BjFFWWwiil3yLQ9jLkm2OdKX9jkocngHdWjPfa9N3FTL6Em32i+2DxgtnsZsxzIxVrlW1C
	g907cSXLvZQg6+5plMHMnxPclIi8ZHg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=fsZrsXbw;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790899247;
	b=0z0S8/D9eNtENUtSECPBUKoh2Uxp4H4PkOWqISQgWhPQ3l+HXqK2wOd0HsUxdYGxFqaV5H
	it3sjFCXrMJwHQryj62lirBfSVnumrGCZDKzJuSuyRI/z//jQpXUUyUouJV1S/PSPwzigQ
	TiVb+mYjbnuKmOidWVvpJ/MxZh0PqLA=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CC72640E03BE;
	Fri,  2 Oct 2026 00:00:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NaJ-HpYXBw58; Fri,  2 Oct 2026 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1790899233; bh=cG+cJ7mT22tNPHsFBNtxnr+VztjGQBeRNYYjS2dgVhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fsZrsXbwppxgBw+JMcEWeOik0QpmlmhwCehRdAUflP9fffOHurGmKV/miQIYLo7dl
	 0rmH8plvSRduAlM1Cd30fXlLUrWE36VjiP69+bX8ezPP9y0QbxAOVhaCEx0jzOH/jB
	 rbq7WEuRlaVjUgZjaf2IHhqfeNccFCrHykU19EBEhHgRybuf7w8mZIwFMlxAaVoZhO
	 d2TAISGT5AW67hpOT2+/jKGEpfJKcUp197bqs0RU90atPixEZBAiKw5T0H5SO+reOd
	 EKhLFW70iqospUTw4Dyczm2h7FZeU4EqpowkR1A0eD3A1FRbdrLcG+6aJe/+D9IRdV
	 tQJEHyKX6/eVtDIEm/SyhgtBr+oDFW9stciSfKxFq8xv/2n4EL/3GPpQ9ysJWhWKGv
	 EJe1QQMc1ogmeLVzWVENseeV0l5d75Gy1Xa55R0LUR5e33g7YK/bQKQ1dP0RKEw9+a
	 Jsor6wKUbW+b/UYo8/4cNn/8j4dlu8Kj2n4pvaDvI/gnBKgFoBt5Ze9+Qnk9MvfLwP
	 TI0lh7wmOTllPBTjS6DrcAv7FlotWP4MVY2v90qApdWiwDmhehK4G374oOCXyj+Abu
	 tpvNncuvRIoCcb75sb/7GJWT8Aq2ohUS2oAwudDUNDQHqhjulshygMHoLW/6AOLKFB
	 NJfQuVGfFyE0nXitzxJWJCqU=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D09C640E02A8;
	Thu,  1 Oct 2026 23:59:53 +0000 (UTC)
Date: Thu, 1 Oct 2026 16:59:50 -0700
From: Borislav Petkov <bp@alien8.de>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>
Subject: Re: [PATCH v2 0/6] x86/percpu: Share decrypted storage before guest
 setup
Message-ID: <20261001235950.GHar7z9v3zfk8odoTh@fat_crate.local>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
 <20260929053930.GEartPEjbZMpBVSvSk@fat_crate.local>
 <CABQX2QNmza+=i1FXgDtFS3e3O5oXxPZppRbRrL54P1LmrB2gBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABQX2QNmza+=i1FXgDtFS3e3O5oXxPZppRbRrL54P1LmrB2gBw@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: ihn1qwjrkrk6whg1nndtxauwch5x8cc8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F1E01C000D
X-HE-Tag: 1790899247-569401
X-HE-Meta: U2FsdGVkX1+Fu4MUVd84RiI5Zps1lx7RCbFu2tJSgKdUCeoIcvitNVaaWxVar481TppG/G3ePcaUg4ZYPrFACsQMsDrdB2L9QABiVehzme/OLJniHcj2X08grQVj140fzJUrdv1pW/Bg+WSrmiDRSsA+gkcr4VFqaTDZ9gVK9x8FHc7rGUYCX9i+CfmZ7d6xkHnJja8e4lolTP8LxdcHLmj6nUEghKbgNzfs+pg3WZeraaeABt3+N+B2r3eLYIXGgBWH2ICI/AIx++HvgAV5AR8O+Xg63lKZ9Ci1e/uJGys1XnwbGNoqIZ66+2f/um9iVLLll52wlKRq+TjpwYez1uurg1BgZ8l2moW466s/sk7VCKy0lVa106C8L6ubxLYsS1jndNmc1w2Csc+tp55yFxxIdUu0t2o7Cfi62hOAuMotijl6l2xf5TWj1jBi84IJCd+TR0O+jtiF5FJW2hH/mtXzOUItnAa3Los+iESaz22w913OIiPIjGQgAPFfVEb5MvbXGyP3EaAX2ZYHhCtNMnTZhelnyz6hpWGhEiqToP/yUQdLmpN0CYx1d8BzPllJupUzHxe0fhcEFXbYRA/hFlURIoEn1YiP1No7jD8IflphChH0nHztXaWvyf6WGrEDNYK8BUh8lEQiDOIhociCoFOQ7ZYi1398vI3/IbA4uzBgmF2QZj7lrldKa3Gyrag5OiTxKnlSFMD+iULGPXbVNi87WAu0mShuhxQGQGaUVXo3mB7MYkDaKtrnT2sDWbxzrvmxUHgEtDnxemYUJQS9aY53NVKdj3dsmCXhd1fxtn0qSyOKuIRwLC0ZK6OCEObzpmmUZq2265JovB+U3VSIOL75SnPWjhl1d7mEGoN628WzmZztZyz4hDCGjQ9jDF2crFtIgHYjPJTJXw2+/gB/UQTgCc0C07y/254XoPzrjAVCMh3fzPRGZzf3Tb3LYWp/StU8JESO+2UtoJWfj3G
 G4hVXMOp
 vMgLVr5pz+XTsadob2V8y9/Jf2JifCTvIYFJRITF9zDXZdzlgWokJ9Z9kSdw8HG0p/Yz6alTrCCAYanyK0hrHRs7Bf/C1854rJV4p15WhzTeg2Fr/cY3ld1xcZisxLpSDc23X0nedZrtItlXWh3eICrqJtOfYC4hV1ZrCFNmTgKfrwpFFqzdViIe6zfLzSUzprt72gg6pI6qTKhI23GgbLlJPYkY8GMXjjHLeIo5EjDayiakTQBMSZePQ/pPiuFDod8SkB9eCINFNAZKxb+Us6pvv4FhvRSPg5++jVy1CNoAXMkBQUMx3NHAnXp7sqbHMw0+xrwgJAeIffvsTk26Hxsp4kuBdvHZ2eRe+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 01:25:09PM -0400, Zack Rusin wrote:
> Partly. So steal time tells Linux how much time a virtual CPU spent
> ready to run but waiting for the hypervisor to schedule it.
> 
> For example, during a 100 ms interval, the vCPU might execute for 70
> ms and wait for a physical CPU for 30 ms. Reporting those 30 ms helps
> kernel:
> - account for CPU usage accurately: avoid charging applications for
> time when the hypervisor wasn't running their vCPU.
> - make fairer scheduling decisions: base task execution accounting on
> the CPU time tasks actually received.
> - expose host contention: the st field in top and counters in
> /proc/stat help explain why a VM is slow even though its applications
> don't appear to consume all available CPU time.

Aaaha, IOW, that's the "st" column here:

$ vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 1  0      0 1714852   9748  85300    0    0  3793    51 1445    0  0  1 99  0  0  0

In any case, you could keep that helpful explanation in yout 0th message. :)

> If options are binary then "no" :) It's not for monitoring tools, it's
> for the kernel's own steal-time accounting above, which currently
> doesn't work in confidential VMware guests. So the issue is that in a
> confidential guest (AMD SEV SNP, Intel TDX) memory is private by
> default, so the hypervisor can't read or write it. Any page the
> hypervisor has to write must first be converted to shared by the
> guest. Linux gives us the address of the steal-time buffer without
> converting it. The hypervisor then tries to write into a private page,
> which doesn't work. Currently ESXi deliberately powers off the VM when
> that happens. That only affects VMs with the steal clock enabled,
> which ESXi leaves off by default except for Photon guests. I'll
> probably change ESXi to just disable steal time when a guest gives us
> a private page, but that only avoids the power-off; steal time still
> won't work in these guests without this series.
> 
> KVM has the same need for three of its per-CPU buffers (steal time,
> async page faults and PV EOI). It already converts them, but only on
> AMD and in its own loop. Kiryl asked on v1 for one common place that
> converts all such per CPU buffers early, on both AMD and Intel,

Right, why early?

I mean, I am still trying to see the justification for this diffstat

 14 files changed, 247 insertions(+), 51 deletions(-)

and whether it is really worth it.

> instead of each hypervisor driver doing it. That's patches 2-6.
> 
> Patch 1 fixes an old layout bug in uniprocessor kernels, where these
> buffers can share a page with unrelated data. The series also fixes
> SEV and SEV-SNP guests on KVM running kernels built with CONFIG_SMP=n,
> which currently hang at boot (we reproduced the hang).

That should tell you how much we care about UP. We would even love to make SMP
the default.

> Fair enough. I'll rework the cover letter and the commit messages so
> each one starts with the problem. The series originally wasn't really
> touching x86 core parts and I haven't updated it for a larger crowd.
> Would you like an explanation of steal time, like the above, in the
> cover as well?

Yes please.

Also, we have some blurb about how to write those:

https://docs.kernel.org/process/maintainer-tip.html#patch-subject

and

https://docs.kernel.org/process/submitting-patches.html

In talking to Peter about it, we were wondering whether this can be made
simpler. Like do not touch perCPU but do a normal page for each CPU's steal
time gunk and thus do not split the large page and then that early
enc/decrypting of memory I don't like either.

Perhaps we should start with the simplest approach first.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

