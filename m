Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09889CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8716B0088; Tue, 29 Sep 2026 01:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8FE6B008C; Tue, 29 Sep 2026 01:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97A06B0093; Tue, 29 Sep 2026 01:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5656B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:40:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21902C03B8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:40:30 +0000 (UTC)
X-FDA: 85265699820.12.FAE3288
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA8E580004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:40:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=PJOuuQ1O;
	spf=pass (imf30.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790660428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaRFM2LnugPvzVF6cPiwMbM3OqZGlKXLOIHfT5eOFM4=;
	b=RTIhH6UuqJyItwS4pkWLsDi3wY0nnmdclt/FYYgOw/nTctNl4IzwUzBubLlDKPJm7Ubca5
	yykbjEbxM9E2LARruxqusajW0VPZ5qsn9t9kL2nyzF9quTDxpHQsL1ycHmy9ZopnU5pmHi
	ynq5oXe8BI6fhyKcIn1juDD/c88C0Jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=PJOuuQ1O;
	spf=pass (imf30.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790660428;
	b=k8GZ7T4AaVSRfBwSABrg61ykN4qu3dHWDtWwz9Sul7LXthCbG2QKRIakurueiJiyYLf7//
	n4VWatGoj9ZNoYDCMjKML6IZrS7eb83YgzNqIsV2Q7gFHnSuGejMAIkgV14GPg7RfD/pY7
	PIrk5g2UdrSjF0Grto9BtBrsvLhohd4=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 90C9640E01ED;
	Tue, 29 Sep 2026 05:40:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LW9VMulucr1U; Tue, 29 Sep 2026 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1790660414; bh=4lbDjmw7JtBgfO2hPYdY0U8ZEXv57xCD4oHdW903C5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJOuuQ1OX8x8eK+0w+F5cbdnUGSPrA8pi/h5SDJBeGEsOnwgCvPAVmrnHiPiObdDP
	 et7KfBmhLy+crcqPIG3X0MyMtYijQWmADye082P0afK3ztffARE+/RWwyVUB+gWwx+
	 meTKNH7NDq1RtEe3/bLWL6hwhWxD46FXH+HtJXG/0jDaGSxJfF6Pe3T1iWK45qot5U
	 2LfqvK13f6GD7tUmMVa1mn1dorgnMf08BKYtnKhMN5Gpu+b+r9+VmSfhxqQaSmo4KP
	 H+44JUWa/alrd+4EhBdHCePdSwe/MRXL8KAc/RdsPVYBd0n3lH3CqY/vAkqPrZrTGq
	 /M+W3xct/KCM/3iPxwfF/was8cNy/hc+25ugpW1cp2z2XqI+PePUOSiC1/zJj1fbpg
	 QQlb2Km0uC3V/R8nnJVzeUYcVNOtT6XvHAEZbLI+uYyVSBoKGGpme7aE5vmW1twx4K
	 J/4gGT7BVgeqZoCYcFQ0uJgtIEpGy1fNNiQG7DH3HLjukLsEm/kewzzgIueScAo7kH
	 yB83BPL6mbiHeGeMfrV4PGbWdqhmVdTw3lO+VJrbfAH86L2T+PeJ+huzdrnq025EzS
	 OxKWC/z/2nvnTSqHoZfDcGagnhp3WcaEniNGYCg78V+tMWGMGsSR7D9BZa7RfDZK8V
	 go6kmqSEINa+cyy3zeqxqcl8=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2796940E015D;
	Tue, 29 Sep 2026 05:39:34 +0000 (UTC)
Date: Mon, 28 Sep 2026 22:39:30 -0700
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
Message-ID: <20260929053930.GEartPEjbZMpBVSvSk@fat_crate.local>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rr8axwjbeyem8dwwh6truy71i4ng63o3
X-Rspamd-Queue-Id: CA8E580004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790660427-605458
X-HE-Meta: U2FsdGVkX18fM9aiAWG4Y4+6BBD8xMmlLhgwsKA10pWdrRsjNnL3iOU6efNuOpmDnVsHDbqV2jjL8oo+N0xlgvCFxOgVxYgvyzIw30k8erq8lI6JJ2MGL3z13XVKayMA44CHj9MFdCgtJUvz5hNDIwe4CZQYHNhX4V7OxT0TYba1btWw076m9Vj+j1EXCKfkRMpGx77A+n+7d0l0F+BVqjb51Av6kfMRJ1jYbykRgoqHgrJHv+wXa9OagzdWoSIcDMAXOzVKOHtk+RBJovh/JX02ThwWqTtAEAMffU+v7ipBIWexnIHCxBGhVY/kZKjfF1AmdNbZpvaG5qR0h5qtA1u4GepTGYygTpQThBcusSlRG+dcQLeXByFOGXNkyn2WktPrHCKD68MW2KkMbSpTFvnRc5mLAh0MQL3Si1q7/uo0/lnTTgBZtWEa6mPVYdAKp7wdQWTlRYuJH31P7tYHfohlNa83W1up0wNq38/qxbJjBJg8J23au1gHg6Sdute3ut8a78XWAHSGXnl1sb2hUf1VRNj6iFiIEzQ3PZWgCvIXGT1wO6K20RbpmVnRqUmuXHnH4q3zrzfOplkmWi+IBpAyKv0V8NyqmLNva+FZTqcxNYo2LzV0MwtpwQmC+3CigYAMUjf51NGuSEntfqCJu66P5cpac4nm4/ob22aJzVRnIiIqw+JK6DZ2zFrUGWCpvgalwejRO3Q6NUVpI4oL7pHFxSqItxBh2upZnt600LpmdwO/8IjbPoBF5s6uXADXZhgNdv8DyCVKJQGR+2Pl0U07FCtKAUebXsNEtph2HMgSEcsVQhe76neNUptbY8SpSejEfg+cLqYPuvip0Oos8jW2O6x3aK/4O2OfdyGS0FgUYQE3eLJQkLJO+OnMumfRa34ECyK9P7w02QxhiIuCzeevt2riddXQKNwDkzDWt7Nk1JnqeK0yCjfyaMtQaz4aPh1VagT2aasoYKXyCZm
 qVt07BIQ
 ZmvWcrzJTTeE7BmVyW7Cp1n01xpuEI4H6yT4RVxpHxZ+VG6fTyYp34OeHunplMJ9xrZimfkB60M8RS6xgq6b3h135+WaL66CQQnFKyaJe70VF9SQ7NXUx/IOecniOc1VVxxMyE66gI1MQeRhEHSvSdY9o+5Qg73ESjwvV8UbJrIL+iTLVZAIRhbNYaoSbLLtVT+76EMGEEkA3NLYKaVCrkespYNhywpwlDVsPjpuLT0uUh14BbBsk8GmQqNkSiQTRr1KbelS6ddA3E2tfFEWV+2MA6gioAbH/HZzwM8WaosRAkvI/xgkFCtl7aWdrllm7VSvgcAMkBTGAjJ7vUIko+X2rlfdsEoYvRgoK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 12:02:49AM -0400, Zack Rusin wrote:
> VMware publishes its per-CPU steal-time GPA without first sharing the
> storage in encrypted guests.

So this one liner is the only explanation why this patchset exists, AFAIC=
T. So
I asked AI. I'm pasting what it said below, at the end.

Is any of it true?

If so, how much and is that the reason this patchset exists?

I.e., you want for vmware monitoring tools to work with CoCo guests.

Yes, no? Anything else?

And looking at your commit messages, they don't really talk about why the
patches exist.

And I don't think you know your audience - you're sending a bunch of patc=
hes
touching arch/x86/ and you throw all that virt gibberish around like it a=
in't
no tomorrow and you're thinking that tip people can follow. And I think w=
e can
follow only bits and pieces but all of us will be mostly head-scratching =
here
and probably ignore the whole set.

So perhaps you should lay off your virt hat for a minute and try to expla=
in in
an approachable way what you're trying to do so that even non-virt people=
 can
follow.

Right now concepts are flying around left and right in that text and I ha=
ve no
clue what's going on here.

Thx.

P.S., here's the AI gunk:

"In this context, =E2=80=9CVMware per=E2=80=91CPU steal=E2=80=91time GPA=E2=
=80=9D is referring to **Guest
Physical Address (GPA)**=E2=80=93based accounting of **CPU steal time per=
 vCPU**
inside a VMware virtual machine.

Let=E2=80=99s break the components down:

- **Steal time** =20

  In virtualization, =E2=80=9Csteal time=E2=80=9D is the amount of time a=
 guest CPU *wanted*
  to run but **was not scheduled by the hypervisor** because the physical=
 CPU
  was busy running other VMs or host tasks. =20

  Per=E2=80=91CPU steal time means this is measured **for each vCPU** sep=
arately.

- **GPA (Guest Physical Address)** =20
  GPA is the CPU=E2=80=99s view of =E2=80=9Cphysical=E2=80=9D memory insi=
de the guest. It=E2=80=99s:
  - The address space the guest OS uses for RAM, MMIO, etc.
  - Translated by the hypervisor to real host physical memory (or nested =
translations with EPT/NPT).

- **Why GPA for steal time?** =20
  VMware (and other hypervisors) can expose performance statistics (like =
steal time, idle time, run time) via:
  - Per=E2=80=91vCPU counters/timers
  - Memory=E2=80=91mapped (GPA=E2=80=91mapped) structures that the guest =
can read
  - Paravirtual interfaces (e.g., hypercalls, PV drivers) which are often=
 described or backed by GPA regions

So when someone says =E2=80=9CVMware per=E2=80=91CPU steal-time GPA,=E2=80=
=9D they usually mean:

A VMware mechanism where **per=E2=80=91vCPU steal=E2=80=91time metrics** =
are exposed to the
guest via data structures located in **guest physical address space**, so=
 the
guest OS or monitoring tools can read those counters and attribute lost C=
PU
time per vCPU."

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

