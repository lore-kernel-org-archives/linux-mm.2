Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46370C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB22F6B008A; Wed, 22 Jul 2026 09:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63256B008C; Wed, 22 Jul 2026 09:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B286B0092; Wed, 22 Jul 2026 09:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96B2D6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:45:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E08A05B4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:45:34 +0000 (UTC)
X-FDA: 85016534988.21.387938B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9145B180005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJWegH0/";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784727932;
	b=nuzYmRmU2tbuoX1asyj8QohHMJUMFPQvJHb7klcd6dcnKYYip4xqqoUhn0he3hoVydr9Dj
	D90cc3TD82GmbbeHFo4MViafSCtCDoafqeKcrsOPuaWTKlgdWty6ihIgCBnYD3fqsYe54q
	kCQo/aXMgdnR+VSnov0pV2n8QVnt1I0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJWegH0/";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784727932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3vYwSW4UujfgSMcU5g5Qb19b6BNp6jfqJHAfwMNJHw=;
	b=5/p+9SANMP6D91a+9N91rY0cMCR9NNSsOxnyVpsvY43Ry7oxcotb3su9F/IrIlqQq95lJt
	RKz6KsQA8vxguDiuSJKcAzwugpX1Sa8WMrD72ASy5KAlD1Xpxl8o7PNrHFkHwC73zoaITm
	JsFiAfEYwtqW5BScIVnKje84m/i55gw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED0AC60A70;
	Wed, 22 Jul 2026 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5AD1F00ADB;
	Wed, 22 Jul 2026 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784727931;
	bh=W3vYwSW4UujfgSMcU5g5Qb19b6BNp6jfqJHAfwMNJHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJWegH0/RLjcksN2vqderqOYhQ9eWMrvzDt5295YLB/S3X3EZ0v380dfSamggSPEG
	 TVP7s8UFmheAbEgBv9yaFV3OuTn9uUQcIe8KAIZW0KXPGhpE+cjXlMt/9FdUdjm9XZ
	 agBD6Rh8Ady3BBoT0diaBBbNtQ/bjZcDOrsc6V0y9No+2M94lnhkApJ1GzclAF7rem
	 js395LCWqzwq/SfBRYcnE8qI/fQ9/WZxTx7Wc99Lou97N1TRsFDADph+Gpmpocyd9d
	 7W4dbQ+eiHFeDQQZBIVJmQ4clllbMPu1NnVLx9dfs8+qnk6H4HAx6kllqK61GZ+PlK
	 AN17LF64p95bQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Wed, 22 Jul 2026 06:45:22 -0700
Message-ID: <20260722134523.87856-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721035848.147455-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9145B180005
X-Stat-Signature: f1zjk3wtetiwnpnmxbp3jsrittaprbe1
X-Rspam-User: 
X-HE-Tag: 1784727932-748019
X-HE-Meta: U2FsdGVkX18kwDB85BJNSGs2x9snj7CuWwvcgme3qTRWOksb/X8ikkHPgyPeaIgDIHMLZDx2RWwuw485/nUmMJAGuiQv/zkR0pAg2GDeFa750Yj5/9uJoPG0yXCRexVHZsrzZc8tSsaynBAWnNosWkrL3jGtjCmXcZ3K3/jiG7PIYgOv96NFXGIngg1cVnyJjg8XaK4F1OoS2EKRRCq73k2u+cDG0To9u2Aot4b5d18rji4BYWJ+XfNoHhlBxqKj/IpM87RK+CAVn/3bs4buAbRGeuWbHYkUmwaoCNsjmx4xvniD299Bzp+JXuZ/Yd+V4yseGIcmOuIgoNTLkVRYZ6q+6X0o8Mt/EG8ZSmIDlGJyhl/ZSxKFRM5wxd3tko74gzRJTxfrDiWwNHWaE4KkqiU3xZ0Sp8OISNB0B0DHyUYB9/reZMlQ7cunTFDc57aV5rhS9SZkjCrXUDuc974438KKUlVVHGk/pOqiHjcg+5V0D3C5wQM1JSQZ2FJl6NNpN0xCi1remehmJkZcWkgjEPPGorGI4Qcgf6gVA87rfzadzibfx5SenR2tMzNqeX+znpbhh82GPZQuOGNAaE66UqAc25PUS0k1l8WkIbNCmnVElVHGD9u1eEzMXv2yeq1/yqHbQSXdrQhnkpuCgs2SbGJNW7WO4AWirn1aJqYDSxbPsUzOw5F/NI4d4PbTX11eq+K+IniY2+IWVwLO+9C1VaNOR1E6WHlf/DIJyYG87wEZDBWW+Tb4GqiA/DpBtEK1TKizZgF4WWVIspGesG3ut9TE0/H4Cjeb93IPY0NJk/wQFAJ6gL40h6uL7R/9smu3vdiCjVMmgL17WhhN/oqXjSs3iN8iMp3a3W5HnE69XvobeP6lyrZI9ovBS+4nKaI4iZOFvmTAqYo4iKYK4koiZyxwE0carHFz075J2ha0Uti42sYIvyOu4Vyus9at8+IlDblEcH4T38EvmMz+CJy
 SMq5OAnI
 uzSLJoNe/GoX6vgLmLY2BluYW+X/E9rxjOntAvrmxuBClr/n7BqOV4qYpFjllNjGaUgA1RxvcKjPuV3uqqfGVzrclNU9GCBEXLsPoKwxRXSfTaAOLHGnaXNO+DZxA0GRbiuwl98hxS11A/VPICkMZIYQiYhB6UhUdrjyu5YC8kyvoWj92dRfdISXkpRcaRJZWOjEu/bwk+2eYbl5pmJOWXUFEogjg/ZOkm4/9mKnqy0ktXrjoC0JDLG2ca/Ft5y15S68JTyOE7cOCmNuTxntZ2HXZ8r4O7dikJ8tf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 20:58:47 -0700 SJ Park <sj@kernel.org> wrote:

> Hello Asier,
> 
> On Mon, 20 Jul 2026 12:01:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
> > From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > 
> > Overview
> > ========
> > This patch set introduces a new autotuning which allows to collapse
> > hot regions into hugepages.
> 
> Thank you for making this series well done like this!
> 
> [...]
> > Patches Sequence
> > ================
> > Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
> > Patch 2 -> sysfs support for the new quota goal
> > Patch 3 -> Document hugepage_mem_bp parameter
> 
> I'd prefer handling 'total' underflow and returning 10,000 instead of INT_MAX
> from damos_hugepage_mem_bp() corner cases.  But definitely that is no blocker.
> For the series,
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> This series is applied to damon/next [1] tree.  If this series is not added to
> mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  In the case, I will update patch 1 to do what I mentioned as
> preferred change if you don't mind.  So, no action from your side is needed for
> now.  If it seems I also forgot doing that or you cannot wait for my action,
> please feel free to directly ask that to Andrew.

We (mm community) now want to focus on making mm.git more stabilized and
therefore ready for the next merge window, rather than adding more changes that
are not really urgent.  I agree and want to help [1] that.  For the reason,
unless Andre pick this first, I will request adding this to mm.git only after
next -rc1 release.  Let me know if you think this is really urgent.

[1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org


Thanks,
SJ

[...]

