Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46931C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3657D6B00AC; Fri, 10 Jul 2026 10:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316D26B00AD; Fri, 10 Jul 2026 10:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FD76B00AE; Fri, 10 Jul 2026 10:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 005B16B00AC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:17:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BB5F120489
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:17:48 +0000 (UTC)
X-FDA: 84973070616.30.2580121
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EEC521C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:17:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+OsDlam;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mAXWGA6OSF8O0XuZXZOdAP4iu1AOJgDdR8iw//XVK6w=;
	b=l7BM7/XbzhAOgnAXwKw5PqLfJJwFiDWWoht1LP7SaO0376Rbo4/729V0Dd6cQOozMOsLqq
	2L0E6GI3aW8d2r7fSEsrMIlL2rEZhkOeHEogoc+0XYW3GQi/uZtD8IMEbdlXCU//FjxSUO
	dZFfOGOenU2Is0pkfwZLBUrbper/m6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L+OsDlam;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693067;
	b=lCJ26CxGNwJhBzBE1TAfvF+pFdetdouRSL++swozBUJfJItF8m7C6p8cKfUSs+vn1lvAzZ
	utGxSAT+Lp/VeXjupGbeSdR9pifqXamIC7jQdFIcciZSdRmmYkMDlQaRy9mszOM14cMemz
	tvcUXLqXSMT/uRGhJTOhyxXA4JIoxvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9C284183A;
	Fri, 10 Jul 2026 14:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848931F000E9;
	Fri, 10 Jul 2026 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783693065;
	bh=mAXWGA6OSF8O0XuZXZOdAP4iu1AOJgDdR8iw//XVK6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+OsDlamhtkR0me8N7dd05YqGELnbUe4ClnnZxkAISGzo/elcnuewm+CSAYcZIJNA
	 rDaDEs7adbIqaX15SOzaJ4pQCa8mDW8gKUA1USxMyrQ24Lo2pZnqyCpzmNB34zx2iy
	 rt04l2tYAj+Q84fz0ltXNBIobBgt7ZBuWhxDiS8RA71YAp8I/hVWBkDdYyJLk0/cbw
	 Zt7lrjwSsdkJle0ajimIznpxkzqo6Kc84YIx56V7W9LdygqPOoyUMaleqHO69kCEuD
	 ae6Lk6vqlNCVDkMtALt+egaBDOgJ5ugRypWMDtRgJiP40oazpU9ORmWd16C0Pfh9Lm
	 pONQo3alOp9Gg==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/4] Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Fri, 10 Jul 2026 07:17:37 -0700
Message-ID: <20260710141738.24789-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710044737.561102-2-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s5brksskf435orif4yi914sz4qg1cadz
X-Rspamd-Queue-Id: EEC521C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783693066-916660
X-HE-Meta: U2FsdGVkX1/z8oB5+f4PeZ32H1JRGqWzCcQB4eJzIgbI7AO5HHhfUVhlQ5CXYAxCe7SYx61Zr4rpqfP+Xc8bkulEIUYnnj86keumFJ+NQBFRvdfWjX6rUM+Ck95ccdOF1YHYZOOQwiWSqlxYAP76L7r+V76sI8G+vE7T3P7UYCY+rdctvpfIRCbnM3pf3Rl/orZ4sIH8leoW0L70r6bzpBNcUf0q3mClmFYb8KuodjrJou+Oy6POaf59RIiNCOHfOFHvt1XrRZFB8f5nFbOAONALawyDU46te4AOErmtUUh6O+GMfLu/vHLuRgSTq+UeMDMjGByUUKtBJE+SCzYuJImGc1BUWLZt2X+2ZH7dkbQ/JeKC50I8QegMxYGCiaa0MLp8Ym735kIBy+JS9iMX8hUQrBChaKysDDZEimKEUZ3UyQpA3c84QtmVeuzG7L9fp+Gz+B2RyP3yaw9thsDnw3TqJYBeTCIVzthpXWseg2RXM/LaueIX0YVE0bLULg3ZkGRYGDavio4OsWSG5yLJaH6wuzIUB8owsi62DA7ndNVtANEbuGgWHapCMO+/SZ2hH3F1Ft+tiV+yt5YYljk10DGALctEyWnmDpx6FA2NVtUbq4w1kbtX04Hi04R7M0oTllZw4G8zXccIftrT79RhjwDw5/N/xjSbYHgDhk0/r/SxZSTRW0iIXyaZADWM31+8KJ2DiO65LBRvgwarxNhb3bZ1NiRSU575ZHk0Ok6g5Ha+yxR/Yoho4pzFqIMT0rayOHOht+RnXyuHEzFErnxfbStX/4m8SIv8/z7iVup2kGSCqVBXC8mYJwpY1DxNkndf+q6AYySw6FiCOs2flVVNf/ssW4HViwZOp5y+P539/lh2NiUZW0J8/ctARK+qmtLGdScmEd6jlmA0TRBEVMFSupL8tbptg8ZLEjvSBIkIWXJQzvTvwxfKIEvBVgbQ04D2enqzLz46VZjkDpSYooC
 uuCp7vzN
 ErRzl2SwdspJrIFPTPgxgumrOTvSwq5vg6XWCRk7+UL1nLaxY68f8bF7S31URo/Fpw0Yz4gcbDeaOg64ikMbQe92qiSzaHceqfyGM27RnxDX/kDj/5bgx9ZKQ1qcRBirWLj5NknRyHDadtw8f2BrBmONjwBpcNJiCR2a7MkGSDcbkrDzJMQLUy0vO2vh/Vk/xDPESxoUAHkn5dpE3hnsciGoFhtAo9anF224cqvi1H2nnzmjrCkgHx9ezjUscGfWhed9ecZJfMnOIWd5OpECcmWxrFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 12:47:34 +0800 Song Hu <husong@kylinos.cn> wrote:

> The ABI document spells the DAMON sysfs directory as "intrvals_goal"
> (missing 'e') in four What: entries, but the kernel creates it as
> "intervals_goal" (mm/damon/sysfs.c).  Following the documented path
> therefore yields a non-existent directory.

Nice catch!

> 
> Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ  Park <sj@kernel.org>


Thanks,
SJ

[...]

