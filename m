Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924AA6082BC8
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHt7HSGu
Received: by kanga.kvack.org (Postfix)
	id 9FA316B05B2; Thu,  5 Nov 2026 09:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983BA6B05B5; Thu,  5 Nov 2026 09:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B646B05B8; Thu,  5 Nov 2026 09:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6278E6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:14:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE8F8C0A17
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:14:28 +0000 (UTC)
X-FDA: 85401260616.20.3ED727F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5DB744000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:14:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHt7HSGu;
	spf=pass (imf17.hostedemail.com: domain of lee@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lee@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793888067;
	b=JIx/DlCou31joxMmcklxAGSsvQHIEFnVYXYzAGSkYr3feOqblQ43VzqaBI3/SqD+c1z/h4
	ehvkc9OAU1bXSq7g77kkSnjTVPhIw8ju8IDAfCuGje8qgyf4/JBWgyNRRVA8oOSP0YAoGb
	JRiBL9Cp7Ij8/udfyZiQ+RFmgzfqymk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHt7HSGu;
	spf=pass (imf17.hostedemail.com: domain of lee@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=lee@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793888067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QpYJSS9gn8AjXi8jX/3Dtqw7BlVuFU8dH7dnogBVO0=;
	b=ZBxVcWTn79Zia1160H9NxqxstB4ooaRH4WlXlv8fXYVm2IEkxSCHn8dufHLFjmRiDizpmS
	ihQHWSE6gYv3MHtXBwF1AXvkliWxI4+WQRZInV6ySG3qBeuc1PvmtVQUn5a2QJ0ozy9YXv
	IYUZXvg1Oe0kzaNPz/faue/a7YsPZDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84A88438DE;
	Thu,  5 Nov 2026 14:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B311F00A1B;
	Thu,  5 Nov 2026 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793888065;
	bh=4QpYJSS9gn8AjXi8jX/3Dtqw7BlVuFU8dH7dnogBVO0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZHt7HSGugybN5tt7aBm2DYpjLqmVSzGHPf+FbQmlOA5T4Nk5fCKWzCEZb+J82PHlw
	 l6AVe6kDbgKPpfD8/3R3rRcmmEPrg353sNwySWNZPUaC8eFmRslm5bIRcVZkF6IdyU
	 ruk1UXsR2KoKlIyaiX4m5Bt2MaupvTmPsJkjn50vKnSDxBeKsVV4bwubvy7qds1fXh
	 dHtWj4Z4lh+pj2d8Bkkjb5jAZcuLTyb0EPvvsrr0CO/XIRBV5F5Y3YmW39L6T82LYq
	 MDqcufEATybJTn1bGcMM2j64t0KtpUgUMcx8vhy/hXPFsBB7xQM1sVp6uE3gUGspMg
	 8BTqLnNf590eA==
From: Lee Jones <lee@kernel.org>
To: Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, 
 Pavel Machek <pavel@kernel.org>, Joel Stanley <joel@jms.id.au>, 
 Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>
Cc: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-hardening@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>
In-Reply-To: <ed2b0b67c306bb458ba389f16dc92904203a104b.1793027261.git.d@ilvokhin.com>
References: <ed2b0b67c306bb458ba389f16dc92904203a104b.1793027261.git.d@ilvokhin.com>
Subject: Re: (subset) [PATCH 08/10] leds: pwm: Switch to __nonnull_args()
 macro
Message-Id: <179388805861.2575351.14283088205507759337.b4-ty@b4>
Date: Thu, 05 Nov 2026 14:14:18 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16-dev-ad80c
X-Stat-Signature: 7p4jjcf1om4nmt6t4k7k8k591s94tmh7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DB744000E
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793888067-630214
X-HE-Meta: U2FsdGVkX1+KL1cS5Ys7m/RmnVUGA6V/M3gBIasJQYcfMXfDniC1Acvk8zNioOOxvxoDQJ6KHGCbXHvD8jIRxD53X2sFYFQQJKrlpANJ5vxl8jSvS10gN1xQToc07wUvl68i1vipvZb1MFdB2InvwUo2PVVKssEMHp7okMaKT992Eew49eIZp88rMZeoCbO6nV9okuYhJ/PGtV7M1TS6uc8G/3x+xephpATycnvxzrtClcjB5BSUQ4uwKBKowC5yIXsoiJbwERFiUet4am/DCzHEOalsXt9VJbgIdCIjuz0hh32Z4dme7EHOKKPmXYXY3zulwlrB9oveUKaK1unfVTvwXgJ1h4HxcQMcf2aHlLJzcD5MP9jhx3kVL7uOqpN+RYLDC8MSTFLyGB/jrUYTEzfZwlhqaxr/7BR8iLIkamBdjMJGFmglcSFkI6uNvUNa37Bnzi9GMyJA4AvqysfP2XzxErM5Wf6ZUUjSkSygIHGiv6SSLpRn48jjifV/bu8cUb0sX321plFqX9BqSVPr2/4ops792JhUz4Vq6k+kOKa2D2KLwGwFf0G6esa4tzRjtUjnyA7LiS8JB5jZ4YOBdPU8WC1xyNsrTRAZanIBfROzwcs7Vh78cD0ebqihWrq9441wGBB8gDJRfak5IxF/g86Zq6SDwAbGe5y8yFJ+hHC0p65LbIVFzx46zvEXIji0PLO4gWuh8Dmx1wHPWKwopobxX7t0VJk9PBTfcht7Q8RBV7+u6+pEpX9YWagUjzuH8XjtGan3P8ZL4QQG9CyVmSkuQZxIWEvmwUIa4sEVsyR9GYIeaFecY6+2t30CMDYPIQ/RDeOfN0dVFQSos86Mw5CWlSSqzdgr8Ir5vIc/tsXpQOGkU3dh20IuuaknJ87mf6YJj1O38/vvA592U1Dj8BQ7xZ8WdqbUDVxM/KcSx9GNADgPjtnTLuvdaEW3rjOsbnTPs+J/eGCwu3y2Ktm
 6B5tlGGO
 NBq2PW5TPpBJJfFpH8kUTpQ2rfbm+RU6VTgfV/Ueaukn+KHcjPM8Tb9ClGqW8KvcNbJXNiYefXUVg4wBM2J+ccjWECQq412QkE33DCwzgSOkw+UTqf3VHDcEyPrgaTJHTRck35J75qJZFBYtOfZiM+vqb+ZXaaJxeg6CiArPw/3u3KkYLTNucIe9RYMjvtzw7WMDwFopt9hO0G0SjD2/0p0iDoAkxAaybLYNjKpy9x5AP1y5YLXDH2Ro+DXIavps20jLlb8VzRHU2D1BNSfrsRx0sbOv63WSevLMn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 08:19:47 +0000, Dmitry Ilvokhin wrote:
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
> 
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.
> 
> [...]

Applied, thanks!

[08/10] leds: pwm: Switch to __nonnull_args() macro
        commit: 687615faae92e36a2b6c5ab0d007751e8e88a645

--
Lee Jones [李琼斯]


