Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117F6CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3503A6B015A; Sun, 31 May 2026 13:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328EA6B015B; Sun, 31 May 2026 13:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2665F6B015C; Sun, 31 May 2026 13:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 163806B015A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:08:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B83D7A0456
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:08:17 +0000 (UTC)
X-FDA: 84828348234.13.0D5DD9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1689A20008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:08:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T67PVWQC;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780247296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0kft5uZTu7IpkVqR8CNYuSgsRuNK2ZGN1ogEISTcwU=;
	b=Hwje8WfKvbdm9d7TKRh09u0CSMwahqOTWydqtA+Z+ehEnVssoy3feHz8YUEnVidyePelgf
	t5vLtGdBB0dnZcPWegb4XlhWprBtXXuDMGmv4g+WIe4ZmiI7TngxNqIIPTJN/VLihmZxvZ
	2ih7Vh/Y5OsOmhtLUhyACOrm7hZzVgY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T67PVWQC;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780247296; a=rsa-sha256;
	cv=none;
	b=T4B6vnOnr4J0toTk+0asaYj/pPVxUFOVoIdlZHWrH5UDglaHAL5c9A3wcahN+pUIr8yyJu
	nbpdhajqCyYMAdlU1JZpupgcp8H2x9BzR7l6CaU43F4cTwhYN3gFT1nMCk70ohGYOgHjXd
	yQC93QeDUYYMSHfschtRhRk+ExBSoRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88A186008A;
	Sun, 31 May 2026 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85D1F00893;
	Sun, 31 May 2026 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780247295;
	bh=q0kft5uZTu7IpkVqR8CNYuSgsRuNK2ZGN1ogEISTcwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T67PVWQCsaBBMEvoIVNH5eCFp2G8RFJWaM1NeWF9umI9ALi1cKs6OHZbf/RpzCs51
	 iVZN1/DWiYRMSwp6nNzK7r6ay5bE8FTr7aVI0p252zfLFV8fJQLQf++S8RXta1FqUn
	 WzlH1M/CV9T5wlMGhH/H848kG1aqeZoH14BbC5Gx3mLfvNaFiuSuwetKOLd0OBgVWa
	 bZAehCUUlYhdApZ1F6iOeI/3S+AXsVSErx0eRo+15mIB63JKQNKr/XQZTU7xLM6zKV
	 IgMP9e9aBiwTi2Ae2qyLuDuBGxsMYUQtIKv4bKHDW/HxKDlb1Gns8epCEr4Qq78gG4
	 b1sAB8xU5s43w==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 0/5] selftests/damon: misc fixes for test bugs
Date: Sun, 31 May 2026 10:08:06 -0700
Message-ID: <20260531170807.99856-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531085633.48626-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1689A20008
X-Stat-Signature: ij7isdm931shxp36myrjmyhjdxpmaoaq
X-HE-Tag: 1780247295-617062
X-HE-Meta: U2FsdGVkX18fx6bz9AxLh7tfJw506o6nGySGtu8K5sOk2KrrBM3p/LGS2dsctve7ESaHnba7Siw3AspWS+HID2VCnOzuhQ5Rlqv/Ve5hD5eoSzMtSWYMQcgyMssyIor9DjhCaEFN/2VY58SXA+rMTvFP7sGUSpKUmCoAFAsPpFNhaXqSHkj1/iwsJ9nFAAgXqnwr7Pq/Ezgz8WNppHkOXS1MuCDtsYrcbvYjHuBlWwCpgB8YSGC0dh7z1gRIXQP4tFopidm0lihn8XcrBbBuOHo9nbNEas4/kKYAmvPfqbPq/qBP8N9pSlAgz91cFJzDkSntsgnRX7GypceJ/nOrqY6+cK6x0fz04hiOyPNWBZya0o2YvZYZLIvLQqC6qdBL736NdQVI/lHoNggHpKW51PDQ/xWtVrsuAiFDzJ25ON8/ILeaZ4XI/3yyvWg1UbIqdx/n+cM1E9a75JHYgiEPZSOW4EXDL9kXUS6nOoSbHrW61AvtR6oJegxKlGEGriEZAYppDx0ZaCoYs6kXM4tEIu/NHgOubw3ZsZZeFcQyplJdFsBHJdGGZwDm4RgeDnq6A3FUrhIpRsx4GxYwk1WI2dgn+gxYS9/nVhwm0EyI7+8GLe2+oxaSMf4tfgRwUNCxQjftkrRMYY3bOsQghLXkLWyrkUqGbGMcgKhV3N40R5MCLQPRmJCXXO/bHfOp0f3Mt+9FaiNpHYWzfJpX0gCwzWxRbB9MX80iGMhf3a0oJriLWiBIRWN7gbGNYXG1pSx1NMfPpLRFNgMj86YsCwR9uKTBXqG6YEI1hmtctwYunqILzSvLD7Png1U+JZEnp4fUvSg0yJWjvX++ubY/nhzzw1BY4LgCke2CvOlGe4SCecr3yn1GRHjlXNGbj4RSU11LPcfcw5QY/Dv9eYjr4wRDPQshI/tucaR4ciidOdGcw4WwxGmMSHCfahgjExYxVEzi6I9WggM0ejJ29N7bGHS
 XO/+WZnV
 WTUsdMh5Q/lS/OIMa40VauBo5t4cswFcUDM/PAdlIArbbd3UlSrwQ6NjB3/rWYXgaIdUbnX2NVoW6c0BL1opsDgiYcKEoibyBt1yqKjMAyX2XRCM1q91EEkwwUFVytPhPxrhL4SsZVUXfD4Utb4zTym8DgjZGtI3xJtZTs8SyLldsHyAKeSDBUMD2kCyUxyQr/ljsZUHDZLdIGt+K/9lOwnes5UkMcw3Q0fsJA5IoFkd4kQFGEVwJVvxzwP9O8s++zki+NKz6tk+WptSmg18MWCjCn1OWV4aBvZ1YnN+7pFGHXLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 16:56:28 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> This series fixes several bugs in the DAMON selftests.  Most are
> trivial but cause tests to silently pass when they shouldn't, or
> fail prematurely on slow machines.

Thank you for sharing these great changes, Kunwu and Lian!

> 
> Patch 1 fixes mutable default arguments in DamonCtx.__init__()
> that cause state to leak between test instances.
> 
> Patch 2 fixes a trailing comma in DamosFilter that turns
> memcg_path from a string into a tuple, silently breaking memcg
> filter setup.
> 
> Patch 3-4 fix bugs in damos_tried_regions.py: wrong operator
> precedence drops the "not met" prefix from failure output, and
> empty early aggregation cycles cause premature test failure.
> 
> Patch 5 fixes several wrong strings that produce dead elif
> branches, skipped file existence checks, and broken dict key
> lookups.

I left comments to each patch.  To summarize,

Patches 1, 3 and 5 look good except signer/author info mismatch.

For patches 2 and 4, I think we need more discussions.


Thanks,
SJ

[...]

