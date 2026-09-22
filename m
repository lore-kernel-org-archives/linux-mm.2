Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216ACC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128096B00AC; Tue, 22 Sep 2026 05:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8426B00AD; Tue, 22 Sep 2026 05:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09806B00B1; Tue, 22 Sep 2026 05:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBAF76B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:03:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 655E4A625E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:03:10 +0000 (UTC)
X-FDA: 85240808940.22.97812B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C1E1D40009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:03:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+JOE4ry;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067788;
	b=27y2yNBzTMCD5S6HxDWgzGH1atikb2x7ZX9h1G+do4o7ikxjfOZvscBRePyBZ5FfuJ079J
	8Hkwk3RMuGd30veqcXexGPhEMsqh2C3Jm/BvpmV0cfrD59j+WGFuy/i/0GgN+PCRRXUPme
	zwSka4u0mETN0GaFMYJy89aKjddKmoU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+JOE4ry;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067788;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHgvoHnJIwe3nC5S4OY8z28uWVR9gAOlu7YWol56jKc=;
	b=v4SuG8uNBhO4lIWogg5x6O8iP+M4IvxU+tuOllDl1TqfJRPGlGogr8ArPwMB4wdnD8qY89
	7FGbIdD3UOtTUPeG3ZrD5TgnifK4lBHtxvxyEVV2KIrXBGcNtULn9kyGr/YgZzi7Zqrwn7
	VPkrVoQfW6qyVa8Szfg6BiSa9WWZBvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16E0440C4A;
	Tue, 22 Sep 2026 09:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542831F000FF;
	Tue, 22 Sep 2026 09:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067788;
	bh=pHgvoHnJIwe3nC5S4OY8z28uWVR9gAOlu7YWol56jKc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l+JOE4ryLKIP3w9q5Wm7pSG1JLgmDJMTih9bWxagWnLP0XhQLvugLdVxdO/i7BZ1b
	 uvX39GjRiLtbNCtIwl6kbzM07pHvNRM7sLWrfKdwu5cRDBDhhUW14JQEPxQgJCJcpo
	 zteqI1bXRF1+ErMo/W206HGKtuTl5xYGFoYzr8R+VyzOeETVbKARobUvCKiqV/1H5G
	 ZG2bS7BFom8VmX+m2cO+RlPZM8u/HRlPHtdDSKYxDCuUCo7GUN/ZasJtPMbhOvS5BW
	 mJMwC/BAeODqKEf4NJtp6Oe/JkjP/uh/PV3O0rpjhB5shaJzPxmBPBVxFXQ+Q6GbJt
	 r1KqQABQ7lA/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 3/9] crash_core: serialize crash header preparation
 against hotplug
Reply-To: sashiko-reviews@lists.linux.dev
To: m.szyprowski@samsung.com, "Wandun Chen" <chenwandun1@gmail.com>, baoquan.he@linux.dev, robh@kernel.org, rppt@kernel.org
Cc: devicetree@vger.kernel.org, ruirui.yang@linux.dev, linux-arm-kernel@lists.infradead.org, alex@ghiti.fr, pjw@kernel.org, tglx@kernel.org, aou@eecs.berkeley.edu, bp@alien8.de, hpa@zytor.com, akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, saravanak@kernel.org, x86@kernel.org, will@kernel.org, kexec@lists.infradead.org, linux-riscv@lists.infradead.org, linux-mm@kvack.org, chenhuacai@kernel.org, iommu@lists.linux.dev, mark.rutland@arm.com, loongarch@lists.linux.dev, robin.murphy@arm.com, kernel@xen0n.name, pratyush@kernel.org, catalin.marinas@arm.com, palmer@dabbelt.com, conor+dt@kernel.org, pasha.tatashin@soleen.com
In-Reply-To: <20260922084256.1515554-4-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-4-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 09:03:05 +0000
Message-Id: <20260922090306.542831F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1E1D40009
X-Stat-Signature: 49t78x8abfpy6b1dn119kscbrx8d3jeo
X-Rspam-User: 
X-HE-Tag: 1790067788-648935
X-HE-Meta: U2FsdGVkX1+F6NulZJ58hO7c3T4v4D3qxLwbc4S2QeaHvx7E3kuDgQwKAEGfAqOlu2BCSFknwP6dmrAdkCLvzcwxZEKly6L8tJopQtMMEB9shssBHCBTzY7iTz+hdIo8KiPzdD2RP2cHP6ZrwhPBKEgb4hc6pxakodDy6qtnrzC1nxpZY8O8470oiE2tL6yEG0WtxD/yDQoN+XghjwVHA5lOtgEtDTTZRSMjdNh+OKyOlLMm9N27PVXuwysrhFoWprPVKAdBA03sgH+t9C68AIQklozNpHi0V+rggpW1GGBdGKRKzeYVQqTykQN2XIbDo3Bfva4V1CZ5Wyg7xXZGrCI/5U5mgp0NgSX90vrf7duP/pMKkRzxvQ8ml75kIT0YnX8btNuQdNqYTT60DDC6IoOW+/YAk+J5ki53ChNXy/aYMv2L09Iqb0X+69GdznXfLaiSlDx/BtVOAvCgd1HMFEc5Oc78/43MgI/K+Kt1QZTuIH7CRHfWwuYeVN/siabyuyjS9+tZkvKNmZCRZXghsdr3RCzwlOoz2MvIEueOZsraHBMvTjbjhhLnACykgE9lfZIr9sRLdybJiwSv5klVxNkuHpMcJSxZnk2rSGvXYUHUz/sDgQ/2NADeGB0UHkhnmpdoTKTJ5f/jwnpyX9XIt+Y+H4LudpX6xK+USPbJZ39mRbVLn1Dki9Y24tOBVLaHOelgFBbcQlJ1klpLpl7ga476XzgfVTnsAfYrVVKVjGaNhTVFAXuAq8EwVtMAcnIBy0w1QXl+l83eCIhbzCnwrII3TRU1qh3ZRJtwTlK8z5SzpZFsljpntHUmHjZ/R99mXKZcq98UhFUkDIc3A4PvLXqFOId92aOeqZTjkgo4WpAj2osOu7O5ctlkE+zrV29ACpanxWF2DqI5YudZ/HeaLBy9vKuUBy/9otFVXWQvkojBIK+Yzj9l2vk9p6Jfd0Fbbb5OIX1LHAAnbzSau2d
 R0Yuf0Qv
 Uz1iJfU5Hui7wyyrAHWwGwkfw+U6Dt1b2Pzl6hjfEtDf/z04DMZ5MvTv1qXAYw4S43XNDmWGPDBKx7DoTinDUKEc49lLkv2pjnogEQRAN4TrAQ49kVH3wNbZAuyI+Vdu4Uzlig8uGYPdK1LvIUUJr5V65GvrzYx2dbY2aIBUnceEqkALR3KoOoiM84IDrApOXETsrbumHJqE1SQklMLjHAnOi6nntYp9VjPBW/xJ8npWIFPfPe2purcqp2emkW6XAAIWCiWdB+ziCq302RRaTCta6jjPl0LWUwMuCHVtBKqCexcg058pXpz1W/cxIbC1O8celH2iIAAIDL49WUaD+mhUZFCrLrg3NL7TWcXJwxPjtjDEKVTu+MIRSM0kJdxkM6TGYNa63mXfYcP0SEUZ9tNrnAtYJOHpK4ME56GYzNXeQfboA4fGGJEv0E9czTJ5Rvskix9rs+D+cW/HGwQVOaTmihpRZE4v4EfktTrEoN+RVyyQyxDJOXTLWaC8M2+0Kb5Y1fcg79EBJNHoo+f9qMbK+txCav+BN7jpZw6eR7phxBWF718mNsBO9Ex+m6CI51qM4QfCPYgybKvr+wowRXDsucBIZGGEh6X7d3e31HHf0iBa93pXXWZD+a4V5qTGKfwSYXfonqd8dDxutXpxlXwMObXKhb0OU4F10GnPpjPWkpeUj0oC9X54vZYBcPifiRY73QbemINL1PVNQHJhaXDph+E5D7sgK2+1LBMFjM198Bz6Gqg6p0JKkVvw1LUTOoM81FV+YGcuQEsQIt1nWD9FGd1GfEOl2qFZDZxR1nOYKjZkY3/0QaQEK4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Wandun Chen <chenwandun@lixiang.com>
>=20
> crash_prepare_headers() counts memory ranges before populating the
> allocated crash_mem array. The weak implementation used by ARM64,
> RISC-V and LoongArch walks memblock.memory, while x86 performs the same
> two-pass operation over system RAM resources. Concurrent memory hotplug
> can change range source between the two walks and make the populate
> pass overflow cmem->ranges.
>=20
> Take device_hotplug_lock when preparing crash headers during
> kexec_file_load(). The x86 memory hotplug path already takes
> device_hotplug_lock, so call __crash_prepare_headers() directly
> to avoid recursive locking.
>=20
> Sashiko reported this issue in [1].
>=20
> Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
> Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
> Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
> Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system =
call")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D3


