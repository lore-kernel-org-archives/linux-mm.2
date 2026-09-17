Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E48FC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDE16B0092; Thu, 17 Sep 2026 10:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5968C6B0093; Thu, 17 Sep 2026 10:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACC76B0095; Thu, 17 Sep 2026 10:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2104B6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:11:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2F14C0360
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:11:26 +0000 (UTC)
X-FDA: 85223441772.07.C6A1462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C219020009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:11:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIaKJjIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIaKJjIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654284;
	b=ed7+aBEU51pCa0E/kTCBXLaVpUMrCjH6kZcFH3Yntouc7rGpGlH1+0pGO1Yiq7wTysox/C
	2AKpqfPzq7S3EZS0K4sXzc3YF69p65M+2t2kqtt8HsEYVGJcbIrtZNk8lCLzvLtdVAgd1t
	FSJtv8hxGap1SIPdQoRigeY1n4JSiSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sw4l7egVZZpkPzWMWuKshNPwKQcv/aeVFEewmWZph6U=;
	b=CQWzd2SCiOvnelebrVSa7bQLjkRZFugtVCyKKFNTOPsfIHBC88KK8VjbnsP5OZt7Qw+cBy
	pQblci36MEE0D8eYYBpjanXawjVKMsnsWMLB4bnwmC6BxDJqhvWw9iU/qtzgKy2ywXIIX7
	kaBPoKGBF+Mu9D9LK9vOIoJOUkpWiVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B42D60211;
	Thu, 17 Sep 2026 14:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4741F00893;
	Thu, 17 Sep 2026 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654284;
	bh=sw4l7egVZZpkPzWMWuKshNPwKQcv/aeVFEewmWZph6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIaKJjIbccvkrYBH0+v46ZwCGpX8u2/Y7+TtCKCBGh6qM+mDBNq41vdcklxwv+kIv
	 Yn5vdiVCHzlGfOciw/YRms0lPnT8om1qUARsis6mc4+ZHscBj2J+mXafkSH5xAAZzW
	 viCO6XlKeTNkRbwB6BypWO6wKj6/t2QEei/K638tn6Suapt4WMtLvfVKsGyU/qU/uf
	 jXW1VC9LaXRAYOK+JkVwirV9QlKiGKTgVriJyuRll/Bun0U2cJ4NKs1eGYtsmD0oOt
	 JPWUreOx8VFkcdfFqVTht2Xe9j31J1WPSckRX5G0i9nTiIf5rxbX0LnoRGhbmoZecs
	 agjxo/s79L0zA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id DC180198004A;
	Thu, 17 Sep 2026 10:11:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 17 Sep 2026 10:11:21 -0400
X-ME-Sender: <xms:BfWrasERx0bB0bQpen8UY-FjGVSE7vCNnIZ2D0aRNJTX5pjpsZJkFg>
    <xme:BfWrau3XEvQvuLMxZ9WELL-eWCyvs0ZTR171fgmFImTRM0M4G-DO2K_NUF6p9cQ_g
    ixdxYBTMwsdbhqIguHadeIrfg2msPjONvCvamirrUh1PviCBlpRAONd>
X-ME-Received: <xmr:BfWraqYKNKGLnqsM5J2q7-ZHNFwYUxgMtKlaJL_Mz4SgnHGx5nKaGoZTmkw>
X-ME-Proxy-Cause: dmFkZTFQhJTCOy0YHIilx9900UfTpNvB34YFJiLNooiGSVb0X0+i17bCb5sAQsuLM4KruI
    dvsoPorMOMMYqAxO2DV21waGwNq85WpddXnct2choRCqkriiPtWZwJSD/E+2sC/TR/5LJC
    QAXCpBpPsqJAESSaRrlPaePdvhn7KHnK3U3kCpoo+lao8OupTd1eF1VCtRg0LwmpTVEpHm
    WYB3aLcRIwUWTuU/E2rpNvbjSQwXo/nbf71ZypkmtdH5i3YDnrSNkgb2ZQZg4hCpLWQpap
    ZS8iBYkdEdu7VwyUz17Hbw5Z1Ztfq2J376o2mKktQqYnxRczNYRLsD8XZ4ZIzI1LQoxvR4
    7vfmFO60v62faua+6UuZ/FWXjMhET8yC0owKNgiolW8HG4g+JBBhKJZ1JGW5aTKw8/LnwK
    vYfO9iVoP2uUVfzvkEbxeWeuHRr7etQL41JftUTG0QTvYmj762Ikfj8G60IjYN0aS54m4E
    87UOdPS1OclRtHI5oHufH45DAiqQBfREpGW7qfaSjyk45Iy6Umfl5qmHXsn/ALoFC+ZinD
    TygddqlYc4pXgQMnTmjbZI+gBUZ2YUMze9+L074Ub7p4Qz9IIc2XVs4VxnZN0RdS0avSxP
    gDNtd2nFUxqJUJ0fzGHDpmm2qgtliD0UN1bnTXF0R5tOJajKPrDzMO998uZA
X-ME-Proxy: <xmx:BfWralr3PphkjPXQ1w6ofPx7F9fh_RVIqjs7iioZ-5QP97J9akp7UQ>
    <xmx:BfWraq1933UaajS6j7oE36Kyne2rgqCmOhxHTmssnyS7ALzgzy3uJA>
    <xmx:BfWrauUM6FfwyBX7iyjn7m6bI7Ll9uUv0cRzvNmloyri599Lpb2G4A>
    <xmx:BfWrarU_R-VIRJxSjt5VfBYNlNFCobVMeltrAZ3edhioruVNhPFrXA>
    <xmx:BfWraiDP36XwqmVTsJk_pmZ0BVHsjaBgAmARcAGw24PmOEFtS11wilkY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Sep 2026 10:11:16 -0400 (EDT)
Date: Thu, 17 Sep 2026 15:11:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Borislav Petkov <bp@alien8.de>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.makhalov@broadcom.com>, x86@kernel.org, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, virtualization@lists.linux.dev, 
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Bo Gan <bo.gan@broadcom.com>, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] x86/vmware: Share steal-time storage in encrypted
 guests
Message-ID: <aqvxQoIoYhJTZpAC@thinkstation>
References: <cover.1789488039.git.zack.rusin@broadcom.com>
 <aqqGUAX65s4LdJkr@thinkstation>
 <CABQX2QMAfszf3z+Auo0AdwGsf94kTX0DrTrd8k6G1PTNMYsdXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQX2QMAfszf3z+Auo0AdwGsf94kTX0DrTrd8k6G1PTNMYsdXQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C219020009
X-Stat-Signature: 8hmhso7nt34tc1ewt8sjfby5i3q3q1o4
X-Rspamd-Server: rspam01
X-HE-Tag: 1789654284-795256
X-HE-Meta: U2FsdGVkX1/quv+e2vXMh1I/8YvwxPh6GXaVRHAIbDQYVTjtdr9BvQxnCefrcR7rBFQjTgw0fp7X44jWPN0UAAJDEHudwJQUpGpW3B2g3EynSbIjdsEkppJ5850Ig6YBJFCIBoNKHwkMOp/AXySLyFzKJAedXQXv1R8TF8ew74b3ou988FM7gvVlsGBVd+fJd2+71j0Hyy8ksSU8invYlC4r/hr9CMorwUqed4oWiGuolYtMBfxR5vS/I5vmkgxfAlTw6TG8iaZFeOSJiLeeuCQK2f4c7L4wkBAcozNUHUhnls8CEHmnURxlLiAnjDdrQDB5x4FpF1kr6t/D61odaQULX9p11pcEmJH4LYSowvSDcgdO/JkygJs/Fg4YBPA9YobB4/Roh0QWnmkUbY3zqXzhzWi9Qntedw2LRCDtEimlORaZqGpCDhjTUDC5VZYGVOykA7AQDWuYKceSZKfey+o6ulLFRDZZaCbXnk7RU9FcJkCPJqjh7+nLVxqbYnmuQWDYzbm86rsrdKWiJyHJ4TgMv19KAFhhwauwPtIxXJAStoO0cHdrrAqKfwsINNR0o6Tz/2fJFQ05h+m6BEFhZaf5q+uP4N6G+u4pFycn8D9qVQV3FvCraUxf2xYPtH5ebvL3OyG4Gb2yLW8Dpp3PeghXRyuiaDAOX7Vs5tdQwDWbXZy6oldxo5q6kumTkccewAiyxG8Mtonip4jzW3yBhxL90gylsy3vnJNxBdtiNgFcpEkaMLk1p2aoYaSLiprQufmJGlQFZHVLxoIeJyZn7xuU3VnOiId9YYS4TWuaOB9RFeA6G20HSUHSb7eDIh/+AqkrZhjEdHYyZnDMDucM5afFK5aUZ+d8jOlZQNa+2cM7Z/zCrMM6FVjU3kO2cLD7+0w2TC+OVO3Nn1jAu04n1nUoNn5XJN4XNUnZS1Pi94jQppqzYiebtYg1KsQXj1KXRPdDl9uWvKSFQ2IOdQa
 EI113MOl
 Qemfk0gZszvpZTpjIJrr3g9ylYx+Bn0v8Ba4tbAGomXllokAJogT2jTULBdaJTi1cKzjEpFV54LLAlNR2l9GV/4vg2VhnuedXTfNzW5O8O4JeDePhwM7uwQQCkdCwVjRO04ZEjnP/fRSMbHk338fvuftlopzeAIPFMLLjbIeAvvcw76eJUiZOYz0Ubo2Q9TpaFp8wGKT2hvP/HHhDDkpBO8wkjKoJhB0EFWhHbwW9rV5/+X7G1vnYXoIMkDzLVAjiCR0DZOzc6Bv4dLQ1nQszEwQ3oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:41:19AM -0400, Zack Rusin wrote:
> > I acked 1/2, but I don't like where 2/2 does the conversion.
> 
> I saw that, thank you. Since I'll be respinning v2 of this I can go
> ahead and drop the unused DECLARE_PER_CPU_DECRYPTED in that one if you
> want as well.

Yes, please.

> I went through the linked thread, including the dropped 2022
> Quote-buffer alias approach and the 2024 netvsc work's kexec
> regression, fix and re-review discussion. I will keep TDX vmalloc
> support out of this series and correct the explanation to cover alias
> consistency, direct-map splitting and load_unaligned_zeropad(),
> including removing the suggestion that per-page GPA lookup alone
> resolves it.
> 
> After tracing the boot paths, I think there are two distinct pieces
> here. The SEV boot GHCB needs .bss..decrypted before BSS is cleared,
> whereas the SMP per-CPU instances do not exist until
> setup_per_cpu_areas(). KVM then registers its boot-CPU per-CPU buffers
> in smp_prepare_boot_cpu(), so the common conversion needs the early
> primitive you proposed. A shared early_initcall would be too late for
> KVM. The UP registration path probably also needs handling separately

Agreed on all of that. Leave .bss..decrypted alone in this series; the
SEV boot GHCB pins its conversion to the startup code and nothing on
TDX needs it today.

With the primitive called before smp_prepare_boot_cpu() there is no
readiness state to track.

For the vmalloc-backed case, I would rather not handle it at all. Force
the embed allocator when memory encryption is on: ignore
percpu_alloc=page with a warning and don't fall back to page mode if
embed fails, just let it hit the existing panic. On 64-bit embed only
fails on memblock exhaustion at boot or when the NUMA groups spread over
more than 3/4 of vmalloc space. Neither happens in a guest.

> My suggestion would be to do one of two things (or at least I think
> those two options are realistic to me, given that I'm no expert here):
> - add the central per-CPU infrastructure and migrate KVM/VMware
> together, removing both loops and putting the TDX vmalloc rejection
> and readiness state in common code. Would you and the KVM maintainers
> be happy with that first, and generalizing .bss..decrypted separately
> while preserving its earliest SEV setup? afaict the latter also needs
> to broaden the annotation and linker guards, and changes kvmclock
> storage and sharing on TDX-only builds.
> - a smaller VMware fix using a separately allocated, direct-mapped
> page per CPU while the common infrastructure is developed. Using the
> normal allocator would also defer ordinary-guest registration, unless
> I kept their current static storage as a second path. This option
> would retain caller-managed sharing and buffer lifetime handling.
> 
> The second option is, of course, easier for me, but I'm happy to do
> the first to get steal-time storage working for us. Do you have any
> thoughts on this?

The first one, please. It is the better long-term shape and it removes
the KVM loop as well, so the per-CPU section finally does what its
name says.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

