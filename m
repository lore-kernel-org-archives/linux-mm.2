Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950CED3B7E5
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 02:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C86B6B0005; Sat,  6 Dec 2025 21:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7792A6B0006; Sat,  6 Dec 2025 21:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EF66B0008; Sat,  6 Dec 2025 21:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 537F46B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 21:36:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC975134098
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 02:36:32 +0000 (UTC)
X-FDA: 84191111424.26.05E19F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3AC972000A
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 02:36:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPZilZEW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765074991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJAttfSClPUqJnrjCYZzdaV2XQ/WsLl6bivcn4Hl05U=;
	b=UdwtAbT1riYFGKIiK7BPzagN6m+qfN7TlmSbHuLmATcPNZh/2g8cEmnHXkkrLfFXeh/oob
	7Ri5Dw3UoSixo9qnjXoF4U7FcqfJCHZVC+MgVG/LBNab+kBeaPbVvWbfSPqTd6QOYcfjTs
	hdLo0XANGQ85ZM86tZ9lmiQ0b6JK46I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPZilZEW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765074991; a=rsa-sha256;
	cv=none;
	b=DSJNHss1rNYTHHdt+H9RDF4Ka5hoeEIR+KZ4ECoZtUS63fHKUX5i55AF8Aqje27HLZI89C
	74dTuAgLUe18lXtGas4mF/8Yf3ODNVrZCD6L0UdGUuu+m/3FoBN0/KYze2c92IvpdRJutD
	sTq0V+yySA1K5wmQYdgelc6b0M2AZcw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CD4C4410E;
	Sun,  7 Dec 2025 02:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071CBC4CEF5;
	Sun,  7 Dec 2025 02:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765074989;
	bh=CtJt8Aaak1dMFe8w2iMKtDuXgkibMZoukhc8PNi8Krg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPZilZEW6kw0uc+bGl3VHAfRudFGSxArS56f3F+c724FJtz9dGsNHvuWF6iQj/3jh
	 PrylN9D+kGXSDYDjPAJ+sM9gQGr6gD1mB3v3ur/K6PFrFvu3/eaebZQA1+WKf2WIO3
	 KqV0mS/QVe2Hm/YrdbeU9OMvSPsJUV3wSL+4H5ohRdTox27k+ANaYtufuE6sELY243
	 FQyFpfj+AU3dOkk6DnfoCxEXZx+lnz/LOCwOxlpCFxstUM1B8wenYybTlE6oEf+GOU
	 GgjBoi/qJkRiXeTQZzhsU2kw5fZQCCUlvLI4xWgIJ9ChaHAOkHAMInt97+xZ7bR83r
	 IvujCeenSpICQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Sat,  6 Dec 2025 18:36:24 -0800
Message-ID: <20251207023625.44177-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251206224724.13832-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3wazsbnz88gtchagh1ewaobhwac4rbg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AC972000A
X-HE-Tag: 1765074991-436052
X-HE-Meta: U2FsdGVkX18ykpgGQK0s6/O7RGEq3UhmcaaqmRQJa4tj4a+OMVMeF5aorNZGs6gX3wh5sU61gjCwql3WlVzmXiHSA8YjknTuV9zDcFGA0y2vahxIVhFHWS1lWH5CpW9Nr1HBC7s1hn2iCsKgkvLbzE5KdU2w2PINkx1tV9scHVaHIh5rNeyQjjcnhR2AFl0juZOuZdW+4C8SPlMwWZkAARl+0MUgWm5EBf7mKrvdU/g5TECKREj9CVqfslApqKmB87JUp2zkZCGB2NscXLlpBV7WoWlwRlEgq6veNuWMst3UkimYftoMllE+f3DgOoFGg+Pv0Cw0GnnJOwKOaWzv4NhEjloskB3GLRthtoWLbhJuJ6/xj4wUaRUywE9xLBbLbxn4933SXczyC5lw/G31gU5kNPVxIC34DaEciFztTClRiziJnna2k0mCmCY7ygdMq/GgncF2pT8u6wqbtRV3oedJ2nr7RKZQGIjuM+d2D/8XXvPyVfBdNOFMwnFl8Pd85uvxVYEGWrDX3VFPKQI0DgJDqQrUYa8hF6y3SqbWLMu65enUe8ESmAuNLOwyRExBhr3lUjvgxBgnmGDWDTgJkTwL6TagLlsvmUThSVyhOaWh7AFJWl0KEemt8s6dzGBPxBJWJHZcIqsel9CfcylEi0A2ja6n6SPkIjkjwrmUHxMpUbDOgUQEVWLQvXnS5ANdWhJn7m9mMvhY1z/UB5FCwRURuGcmj5tXFEidVrKdEAyB2BdEUHjAsLDaUotk0EpfrXfgkgtKggtLo8S2zvr6gKno4THthDoozWnthUpZUPYebjjYiIz/sxnzBLl+Mu3cXQb6KFlv41HfQ0gZvC0JZODnbKDJNwG+eZkSld1nEC/PBk/b75EsZQ4lUHhEl5VYcCp4uOpPQBOQBQ1KlH13zGhcgxGvxCW6FdiCtvxe+Ri3zcGm62l92+F0QYO9CMtUvQHQWjfibdc3KknNi9h
 e/z9tONL
 JsLTt9/JTmwUteSV4DIyBbpFhdCy9HzD6OeMrIUclA8Dj74Ch59hcJZiBUp3v7rQakJ1Jqor1jeaMp8oB2gSfzHtwlqkue6j2zU2Ky9KONIZwcPkkZ9pcwyA091WxwJ8Yl2PpizD1GuLkSnCD25Y4XLEy/AEZUY9wtIQCJDgt5aIUkAqcFxDsdND66a01uQ2j1wdKtNeLDKSGf/dYNpLGU3KhJNZP4QlB3RIXyZEe8ip3+7N5Pg9zp3HO90M+gj81pg0qIoVa4iDB1NFldBszLHwTFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  7 Dec 2025 07:47:23 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> The damon_call_control structure is used by all damon modules.
> In mm/damon/sysfs.c, it is dynamically allocated with kmalloc(),

It is only for refresh_ms handling damon_call_control.
damon_sysfs_damon_call() doesn't use kmalloc().

> and in
> the remaining modules, it is statically coded.

I try not to use dynamic allocation when possible and *reasonable*, since doing
so eliminates the chances of bugs from dynamic allocation handling mistakes.

> There are many daemon
> modules and they are designed to be used only when needed.  It is more
> efficient to use kmalloc dynamically whenever needed as in damon/sysfs.c.

I agree that is more efficient in terms of kernel size.  Nevertheless, I don't
think it is a significant improvement, since it is only single data structure
per the DAMON module.  The total number of DAMON modules is only five.  Two
among those are samples.

> Using damon_call_control dynamically and consistently has the advantage of
> eliminating the dealloc_on_cancel member variable condition and reducing
> code size.

Disadvantage of this change is that it is adding four more dynamic allocations
that we need to cautiously maintain.  It is not significantly increasing the
maintenance overhead.  But, the advantage (kernel size reduction) also seems
only modest, if I'm not wrong.

So I'm sadly have to say I don't think this change is really needed.

Please let me know if I'm missing something, though.


Thanks,
SJ

[...]

