Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AF7C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA366B009E; Sun,  5 Jul 2026 15:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B2B6B00A0; Sun,  5 Jul 2026 15:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66D46B00A1; Sun,  5 Jul 2026 15:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833936B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:44:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B77B1C1036
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:44:10 +0000 (UTC)
X-FDA: 84955749060.21.8CD1671
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B1FA40005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:44:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qb/ROMJT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783280648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRzL8vvysxWLKSj1GfmeFYz6qgJkZAveKBolbQbTsJc=;
	b=3VcGHEerEYtcAxdkhHFUUJmpBUfRN+SIsKZ3qA2IJwKY7WE+cuZzJWb9Kbym+PVjBLCLH4
	G3pNloI6x+iwq6L7RBr55nSJKGoKv4UhoeAgm8JnkN5qgF/zxHnjly+E91m69u2CuXEjzQ
	tVPvyqhdHbAqbBtfF5lSnZlC8KgiV9U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Qb/ROMJT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783280648;
	b=DlXtk8FALTg63CWTGLkE2C09tsuNK6TzEJwVK167qafjttww/5pn+dkLkfwfzoG0K2VgWQ
	AohKEYT1wFCnFCAndKE8NOQUm4TWb+StCcXx5JtPzEWu2nVMHmc5J/vy7bhoAKihnvQ2BQ
	LIUsgtX3CdjBnLvntdU0BLezE6DwqRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 985F542E8E;
	Sun,  5 Jul 2026 19:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A61F000E9;
	Sun,  5 Jul 2026 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280647;
	bh=WRzL8vvysxWLKSj1GfmeFYz6qgJkZAveKBolbQbTsJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qb/ROMJTIZ2DSo6ObB0y1O5PKnJeseobYCA5EBdDJn+6F7xYZGOUlaikXqT8dQLl4
	 +hZseWN6pDOLBEOeGzkvgZjtlL9buFVTDWzhHhxboc8vmXgtngHn6JVioF+pHr0vw9
	 WVzRhKf0OGunwCPqMYap9OpFX/BWNyWZg8Jqh74jdYMxLgaz80JHRBH937WlrtWg2k
	 RY714446AAGv1vpW42zcZhc2vfQosXjEGLr9mg9ZHbna1EZNapzJpC2ZqPIOaz1b19
	 5cxMGRzHFEDnXRLU+Oq7n1B1V3B4jsdn62FSYNo1eIGZ9HyDDHFKGBWx1hdDK7582u
	 biRxy2gc2izyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: validate all parameters in the core
Date: Sun,  5 Jul 2026 12:43:57 -0700
Message-ID: <20260705194359.117680-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705121618.48da52edf6747499ba626dc1@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gs4b9gqrr87q7jo3u8n17eyxgri98rwj
X-Rspamd-Queue-Id: 6B1FA40005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783280648-838231
X-HE-Meta: U2FsdGVkX1/6aM1VynoP06GcL1jBQE0zU2/knYcvC4AEpdP7cqZ/oNsJARq0RyRZPROBmEXZBzJRNeOvcEOGOkpMGHMDb6WxHuzL/ojjOg8imE+EFeuKn/qyieAGL67GLXPSiuMEnUJ1FH5193SObM7+3a8mCF1JVyp6QRUVPVlOULZKhLxk6zrFxLr/ezwkCNN/ZN/TWSp0OnQfhHRElTN8ovkAmxa8daJraqG4XodVXw4CNRziABhnX5aj5ouZAFxru/LTFi41ksQoHCpVMIozNQp/wVyFF7nzGK/nVddVfxI0kjdfEkwWLWCHCmxO537G5wCfteERFEMq64+uD3xSspc+My6TsozyTpz4JJCVcqXy0IWKVIAetVWcTp3zq5DeeleZNcDg5lzH4dcbxputknHw7FjQwJbgIsKtdF3JuANZKeiRZtetVj8OuskvM3T4dKV5n5asoz8rarFcz2fzldhJF0yCkccBZUJtbbrUr+o/J1ZmeityZqH0JI7mXHmrmFYYn2xKeakePQVFtCmak7eFHd8rb/uSOxDMTNAYpm5z8wR5TrR70caV2YC/BB/CBic0t0Oy1i2NF7uyVrzutnEOJ+Lb/P8QmJEoJTVOZa7RG4oikxW7wIi/A92f9ZIgEt1nIzILOx/orxVrMHs89SsMfQh7I4+VLe0ZUV9W0cj3+6rE5HEN6x7j+z6meshWSZpwGBYOwlLelQhtCUrHhDn10qZ7uLIdtu9ap8z2lAFXgF8k3axC3tIxKhlJpurMRgAz3GAi571z7A2xu7z94D9FntSMLsI+fX4oyCbha6opCb/5XeRlpdBNNSvVJY7UcevRKWK/0BqOLERlj+Ppwk2z73JPp0022fA80EjvwtamAKBAT8EnX+0NLyzdhgBQZ6lHhnhiOcW64MXMmX74KbaTFtifgwWawbfeZ/T5B53Yefn8bzzsX9qdoolkSO76WzqzLYKcdpn8Gdt
 u75KW8SM
 xKkaRcuVaeKxOlRBstj3v6B6JnGo+x5YD8goURIlgniBN/amh3HE8n13CeBrqSF7MGffaAR4d/541lkGOX7YCNblqPt09eMUangvPYqMREZAdE5y36knUysUTHfvBY18PhzIht1ipjPhYjBE5QX7LbpvKMK/EIjQyTPU7Op6kQ978ZV40Dc9Vmrn75K6xBm5GJld53g0Spw2s6H2oX/GGNqSSFxKC6A51JR2+mECv6TZBGYPqu5cdBG3/SLQXFJcjRE4Y66+qYgHDuLy/lo8U4lRoNQk6/xjrT1B1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 12:16:18 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun,  5 Jul 2026 08:55:51 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Note that the patch for providing the validation from
> > damon_set_regions() is separately posted as a hotfix [1] but not yet
> > picked into mm.git as of this writing.
> > 
> > [1] https://lore.kernel.org/20260630035221.146458-1-sj@kernel.org
> 
> Actually this was included in mm-hotfixes-unstable on July 1(?)

You're correct.  I dropped the RFC tag of this patch series because I found it
is merged.  But I forgot dropping this note.  Sorry for causing confusion.


Thanks,
SJ

