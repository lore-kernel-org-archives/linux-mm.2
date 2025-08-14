Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2133CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DADC9001A1; Thu, 14 Aug 2025 12:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B29D900172; Thu, 14 Aug 2025 12:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EFB69001A1; Thu, 14 Aug 2025 12:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C644900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:04:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC8BEC072F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:04:34 +0000 (UTC)
X-FDA: 83775835668.27.CB220EC
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0305118001B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:04:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1FZCpuG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755187473; a=rsa-sha256;
	cv=none;
	b=BJM1PdROLKQ1S7I6uB7h+a7YY7REIlg9TrmirOekxLQs3JHt+lyVlAlJHVmD4hAFxe3ZLd
	FJo8+bDnCiJltz9+h78Ko3+LWM3aEv7D0RrbsRsA3Xa68ruD15DSQ+wk661S6w1sE7RZJY
	Q7B9vQVqllm8bjjDutL4RvZHDMCBqMg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1FZCpuG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755187473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5W7NPaY5kCu/GIHSMtLyna9nfESYWLTiYpIVzm59DoI=;
	b=j59sZLrdACM2a8ddj0eOXLEgypnFRjiRvfZ/aQFsIP3Y7mstXitbk5KRy7RKBbqCpCKU0P
	ISwgp5lAHER4x0BMan9sT9bOaF1Bm5b/qGEflXj+INU3/gX3mWcBVgL4+A/Vj62DGluhyz
	Cl7C+gKdR67thZ/IxojmxFXMaZglA34=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id DFF555C667E;
	Thu, 14 Aug 2025 16:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A5FC4CEEF;
	Thu, 14 Aug 2025 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755187471;
	bh=0DvQEAd0ldq1r3dzwWT+fSNKJ5CZVR01NTIGwBUpIL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1FZCpuGsRG6LoTlMwU47Eq1G/89Mq76dfMn5sDX6GxTtkW7JNlOaLZUkB5MKsNdj
	 tWPnUMIbJXcHZJIM1iyPIKOoOHX+C9A5o1jV/5Z1gtA2k/qUqEttQ7gQb/YftF4t1R
	 +btu+JJB2uMxtwXvZngJ3YbUH48zMUM1QcM4NuresbPlclmygvx621Q2ACOq/Cvuww
	 w8ZGVHpeU+pKv1JSkOPjXF9ahETOkyKl1tUbvWLeslO+kzJ+GdZWZWdM0xRQvnQJaC
	 gsK9PNDoF6d1mKs+xG6UQoMftDoi7dygOlOAMkJAXRHfUGtiHPaXqB6n4Bt6PNtwzr
	 iwlOqwVRkPz8w==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
Date: Thu, 14 Aug 2025 09:04:29 -0700
Message-Id: <20250814160429.67476-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <ee37ea36-7298-4174-b146-fd62b24ef345@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0305118001B
X-Stat-Signature: e7rmsm4wctph9myz3ikky9u8c46ss4u5
X-HE-Tag: 1755187472-601149
X-HE-Meta: U2FsdGVkX19WRkMpY+087Nnn32TFFFzQ7k9bztRcf7kLqswlVxNm3HGkcivzyUMpPytA5f+cJGVVwMfJAsvIO1sxcA6NcPrWYSZ7p+vsMr6DLPvfZHF2/CcKwH0NiXPxM4lDEifhExsQ+DU8ksvuJ3xbKiCem9wRJcANZKmtkgSqQJPe2wur/LZkjdsZPV561oUOihQ+WwbNZCnerbCQQHuyMtOUp2H9YpLYDfqQcodJ5RJ3MNdFBP7jvz4zztE3bEnmmJX7vAlu3PigGyUyQXy9EyM0hlZimgWeLTbMvBup8yfTHq3CFgWnYwBJgtgsc8k44gdqNhIhoZqraPRYN7fk4+7x4XyvAc+4tDRt4e7ymx44IopFaTFSQ+bAyouPUA4YFg9FW17Y2/giWqaGahX1+7emRjHtLI++hgZq2WP0iAIywfVX/gPLsHJgZl9v0xZ6gHIHXaKpALibDn5/xqMHytL8OU8+bxwjV3dCq8TSjvpDYr1s21Gpc85XbibcrJsTptZ6mL0shXaAtWrgjz92IV0gKu4bolKtNH4FN8ckZlGsUTSGKiRLRMPh1FVQAcju3ja2ZnNgYPBiwRfdKosRkHmlp5ZMt4c4n7TdlUN5XwzOQSpOxz1oj/ayfN2dxTP2SI72DMqkRPLd79UoY/Jad5iHRPir0qL5/SXX3taBNb90OQ41+CQJ7/HL8gdYpiJsCMn3AB/vBTz6YJvpIlvJZYQonfbfZ1HnHj9wYjmtpCxDC9R+OPiRlOj0imoKit4njGn107kKYJZn7Zvez+Bzczn9KNvxHjb6o+Nqy9EU88Amv2AYwDDk/wabIoGqIR+tBXRl3193zWpY5acokIhgfaerxlcDhmCuDZ8C+s36SbnZp7lFVquTpG2UUAuFwhoE0JUIFnVNF/EigFtiJ8gaLP1fOWQT7ue5E9P1mljUvGt+mi3xjAhuXeH+4b7g37SocO9XRQArXrmCcak
 Rma+lJaF
 SH7NVXA5/t569rUtV1YlUBa9ODjHwwnZ62+gKdBjHt1LSiyTKOf4cP0kEH2EyUXSwQmE3F9idiW5ujMhnGZkiMq+zwIlrMQCrjh4/CobOz0wJEAvYV2p+5mLDlNYt/zE7CL63Y+CXFtbEFApMvtrfekiE6tjRytcEhJ6m4vWvaFelprNF31zndz2igm5MaI9xPDvNTSyT9V3ZYFQimHYGIY+ZWvq8/RbQVZXQh/Gn2rfJOKjxsoXJ8YY37GPvgFWCk+9AXN3dHw+s0fgPKP7e3zjqXJq3yYfWVebMzUbQqCivaP94dJqU4xgVmoKQ0ypIMFSl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 22:07:12 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/8/14 8:57, SeongJae Park 写道:
> > On Wed, 13 Aug 2025 10:25:44 -0700 SeongJae Park <sj@kernel.org> wrote:
> >
> >> Hello Quanmin,
> >>
> >> On Wed, 13 Aug 2025 13:06:50 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> >>
> >>> Previously, DAMON's physical address space monitoring only supported
> >>> memory ranges below 4GB on LPAE-enabled systems. This was due to
> >>> the use of 'unsigned long' in 'struct damon_addr_range', which is
> >>> 32-bit on ARM32 even with LPAE enabled.
> >>>
> >>> Implements DAMON compatibility for ARM32 with LPAE enabled.
> >> Thank you for working on this, Quanmin!
> >>
> >>> Patches 01/16 through 10/16 are from the mailing list[1], add a new core
> >>> layer parameter called 'addr_unit'. Operations set layer can translate a
> >>> core layer address to the real address by multiplying the parameter value
> >>> to the core layer address.
> >>>
> >>> Patches 11/16 through 14/16 extend and complement patches 01~10, addressing
> >>> various issues introduced by the addr_unit implementation.
> >>>
> >>> Patches 15/16 and 16/16 complete native DAMON support for 32-bit systems.
> >> Overall, looks good to me.  I have a few change requests including below major
> >> ones, though.
> >>
> >> First, let's squash patches for fixing problems made with patches 1-10 into
> >> patches 1-10.  If you don't mind, I will post RFC v2 of those so that you can
> >> pick into your series.
> >>
> >> Second, let's keep DAMOS stats in 'unsigned long' type.  This require fixups of
> >> patches 1-10.  If you don't mind, I will also do this in RFC v2 of those.
> > Instead of posting completely new RFC v2 of the ten patches, I think posting
> > fixup patches as replies to this thread might be a better approach.  I will
> > make fixups first, see what looks easier for working together with you, and
> > either post entirely new version of the patch series, or send individual fixups
> > as replies to each patch of this thread.
> >
> > And one more questions.  What is the baseline if this series?  I cannot simply
> > apply these patches on mm-unstable or mm-new.  It would be nice if you could
> > share a git tree having these patches fully applied, since 'cherry-pick' is
> > easier than 'am' for me.
> 
> Hi SJ,
> 
> Thank you for your detailed suggestions on the patch series. Please allow me
> some time to thoroughly review each of your recommendations.

No worry, please take your time :)

> I haven’t responded
> to every point immediately because I’d like to first attempt updating the patches
> accordingly. If I encounter any questions or issues during the process, I’ll promptly
> reach out to discuss them with you, very appreciate your patience and guidance.

Sounds good.

> 
> By the way, this patch series is based on linux-next(commit:2674d1eadaa2).

Thank you for sharing this.  From the next time, please use mm-new[1] as a
baseline for DAMON patches if there is no reason to not do so.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

