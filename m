Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E506CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 18:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F096B007B; Thu, 27 Nov 2025 13:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F3D6B0095; Thu, 27 Nov 2025 13:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFDF36B0098; Thu, 27 Nov 2025 13:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAF806B007B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:13:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6456657A93
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:13:07 +0000 (UTC)
X-FDA: 84157183614.06.DCC20CD
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F766120015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:13:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=AgAPsYSW;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764267185; a=rsa-sha256;
	cv=none;
	b=rvmO0RcE56G1Xj6jOiGFPTLeZRRJlLmWrSewoW0b9XOKQ8Si1Lqc4i70fcPogDHTCF4xwr
	9iShfzZFoqk239J8+tjZImj7vEcHxlmQDdYzBlocmv/kt/qSldR4MJOUW8idgiCO7eHx/B
	IZiQaQmzvUv+xjnsTQuAwwLzBAXTRDM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=AgAPsYSW;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764267185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toswCiccfDRgBMXp1RMWgi8nHKTH1DMLdV5VQ3k89kU=;
	b=60N5+QOzdVlbXRnnD6mLPceXKxKEb+YN6whZeLLPINB9H+aGmo3XFoMMNMAID1ibGxIKdC
	Mxa0tV6dFwwmMZNB08hBJMMlUa4neidlcNsZr0L0uwoEEOrlqYT72ouWgCx4xQtpb96eGl
	cT20ffeRMPp42jHYLVzTTkMx4hazf+E=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7A0F140E01A5;
	Thu, 27 Nov 2025 18:13:01 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Ckcqr7l0S_Dv; Thu, 27 Nov 2025 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764267175; bh=toswCiccfDRgBMXp1RMWgi8nHKTH1DMLdV5VQ3k89kU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AgAPsYSWeoSvOEjCZ/RC1kmrOolDLgjFKbUf58BJahK47BfcR/dpL8Qq4OEjJqM7p
	 PeQ0HMqmkd7uQDwbkSgRcAQ/8APE7BBnnkcluh9p0I0m2WsDoof6kSZ80Uqcesykva
	 MzTRX/uO386yMYGQItgx1EMzVRAScZAZV4rRZxffke0N/3HUuHw1Pn5fDMtZM9af9j
	 s0VNj0ej+J3FcDwJ3Ym0T1yNRvt+zxl/hyghcoRnsJoy+ArHRbawYMENXWgrAzMv8r
	 3MG9GrE6cfB+vv+XCaRk15W6oE9RfF/B5dJSONLYgz+f6n2Yn8IeS+Xexcljx/Aw+7
	 73gGxb/3fzzb1hY7otKRfvPyI0C6xIA3BmeudLZrjYpb02Br5v2JxDXSG+iM88NyxO
	 kBUyj2Fpu2IA4w0vxFSrruAXnNU+YDviw26+PhjPo0bMgpze8bEdi+TJHBemOh5ktE
	 Gt/uIba18w6pIQWKqGuRftGPrCFBBGJE4SMENnD/EewdVggp5ixuBJqEVF0opaLcR/
	 uJNlP9UaK6kE/rdmeEAeIkBAHd44neUJiCiL2sWM1COCGCeDAX6/uF395HNoDaIZRV
	 esdbutJTzk+C5rWbFGLpaLkPzIAc28sBOHHVOc6d780i6AZEaOarGsvPykPAXnC6jq
	 LMo7njMcEIx8ddyTdXpvS/ZU=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 4191940E016C;
	Thu, 27 Nov 2025 18:12:39 +0000 (UTC)
Date: Thu, 27 Nov 2025 19:12:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F766120015
X-Stat-Signature: tzi91ibi5h4eobafoju494nehsoc4ybn
X-Rspam-User: 
X-HE-Tag: 1764267184-483880
X-HE-Meta: U2FsdGVkX1+SucF0aFsUQo04YL5awkkVh0+Rv7QKhCGHiyRNJ5iNYTDX6zhI7IvFiZtb1XFwxmvsVJsJXrf5VRAkyN+U6XEw3F0byfEC0LTwGllqnS/yoORYVEtla3neteIAjo4qyTKNsleUeXvIBneGBOfoIM+ZflabbL+2sTdQE6PmTJe96Ro2Echyof2XO+JZyC/AGDN9E6RTs9/Y/Ia9s18AHhSt9y5Y08H0z/hikjmM9fmOtl4cyMw02doitEWUL8CfeCllTG0H3wFA09RnkC/an+/O4ye90mjZ9cFDI1FuUdSAtwiXOMN2yxNsuhDnoOa3B0iS84uIMwrqKJPD2fO1QvL86Qn1VvBuKod39TeUGYlF32Szsj7gpasc0i/a9w3MyaQEtq/FJR5BcsjERjUUZpBbI9SWLL4KwP/L6Kx8NVICYCpZ6NqG+/eqlJwToFyEQsIdM2JzJ5+0WaUYo/iVrK0YCD7/CRnvlrQrjL/RoZlv3hyjlAcfyNcFgVPjB2ueTVp9eYAAY1UPiURz1ikIvrET967+mVAdbJt6wf/5lIntxG9VphOUP12RyxGJqhGkxf7L6bPCFYM6a1lKRamCh5mR4zaxA4h21WoJQZK0J0DxAuKTFWEpDalmx63GwcHY8skUQZkCXFOs/mlpDm9pI11B/tdfDqdWEqFlPP/BjjU2h+iKYREM2m5/WoE4LJpOM1puD6IGAWmnlxn6sIsfDMYEhs74eJ5+TlpP9q26Q919JL7tPkbFCwwgWA8xfMD118JxQX8drmYyiiVYDHlWArseaMTUUQlhWpSSOlWA6Ak/Vx3TPacYoGMKWicksE8lIYZwIzUeL8XSxyPzpGBPgg1CAq5jmfN88MaiQ0BOxDCPm5l8ND/cvQf6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 05:35:57PM +0000, Kiryl Shutsemau wrote:
> > ABI break for kexec? Is that a thing?
> > 
> > Since when do we enforce ABI compatibility for kexec and where are we
> > documenting that?

I'll take that as a "no".

> The whole purpose of kexec() is to switch between kernel versions. This
> struct defines format we communicate information about unaccepted memory
> between kernels. The mismatch will lead to boot failure.
> 
> The structure is versioned. Ideally, we should know the format of the
> structure the next kernel supports and act accordingly in the first
> kernel. Like, we can accept all memory before kexec on mismatch.

None of that matters if you kexec the same kernels.

IOW, for some reason you want to be able to kexec different kernels. The
question is why do we care?

AFAICT, nowhere do we say that there's an ABI between kexec-ed kernels...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

