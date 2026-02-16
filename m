Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EDDE83837
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D056B0088; Mon, 16 Feb 2026 16:47:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2746B008A; Mon, 16 Feb 2026 16:47:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4078E6B008C; Mon, 16 Feb 2026 16:47:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6306B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:47:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2F98C278E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:47:18 +0000 (UTC)
X-FDA: 84451656156.07.972998A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5362980006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:47:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eh1tidSW;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IulNIc5BbIpAc0RBykx7SWopbGOosUsWDXnb3povie4=;
	b=o4vZkXGYmwJ+uU12LjCwUl3V//PbiB4V/zTZ6M1+9AczWRJjjaHARO9hiAkQRQqiY9k9+p
	hquttnWijW75Kou8cJ3Esm80z/wT4vHOucJy6JjUwxdc77INz8Gqfm0WAfk83xZcHf1XjB
	5TBTRlvCzY0hcChfOT7PdITNs49llqc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eh1tidSW;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771278437; a=rsa-sha256;
	cv=none;
	b=8kLXJKxfVhp7OpYGvJMD0s0yZQ6I0tspFeSt9dNsDyXClVlFTkDNhVQv2hlFYXeR2V/Cxo
	caHoNt2Bz9LRpwdr2cWoDLtmKqQC4S1hI/w5YXbxrnllKAbqXdKWvmqPRlfJD3RAneivfU
	CcZThhtVSlpLhm0/vHEVjPSuKtlMgX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2932F406E6;
	Mon, 16 Feb 2026 21:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA453C19424;
	Mon, 16 Feb 2026 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771278436;
	bh=wZmeRByRpbHTNtIWpUSkmnwjt2QkNJEcQc0HK71ZMGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh1tidSWKRQ7DZ3Gm42b0ZHMJhwgc7bYz/NsatZTnTqrxD9b5ofGy3OhEpQIjFK8O
	 /Vy9sKP7AC7Dm9CzbVNaCijAELYpJjMoUqxIbk0JLrEcWrzx9i2PbXAimFAfRkhQrX
	 vnaLUKmw3+I7mvDpA2McDtxrCEexhK384eX+aB8XUfImN6+xMOPCFgMGrUdUb3IP2z
	 mv7cxFt6T4fK2UTskhF293WHpFHW7W46ZLd1ULz/7L/WdOMJk4Dvjep3tOxBxAT+pD
	 bh0uUyiDZV+oNnz3LjZ0YhIwUGxeztnvXmOUo8lVrSNGcd5Q5a65155yoKCfig1BhB
	 lmiJgXKRH3UIA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"security@kernel.org" <security@kernel.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/damon/core: dangling walk_control pointer in damos_walk() on inactive context
Date: Mon, 16 Feb 2026 13:47:12 -0800
Message-ID: <20260216214712.68725-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260216185741.74145-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5362980006
X-Rspamd-Server: rspam07
X-Stat-Signature: 5o1cbqehi3mzu963byy5gwcdzxkambrx
X-HE-Tag: 1771278437-568667
X-HE-Meta: U2FsdGVkX19kXNE3b1Q9R/XYTsfP/eOuajO0AUMIZKvMA4InefO48GB5d1J1GTSkdmT7fANcbdz2qhzPRZrM97HrqQ2TD/YvBaCP8tZdUyJyB50T9Nnmbm2aQoTVeLT4t6jZgtOtBYzfR3NvQ9ZdUeo3g0SKw8oogiwvlFqvmMY+cg0M2jYtUdvPx6UjLP2b0nR4qi8kcE09gokawuKEqesv8g/X69QACXTWvCAXxB9J7EyzuSaO8IxcEaBCU8ZQTLQMIvAwWPLAS3iCPB2DPSYRhmBusS5vZ1sgBSqIGGBaQRkO76cOeFAqbMJjZ8nYu2ysk3DuI9QDoPoEe2PBKVjQDuT7zXkCje3k9kJ6iAal/iMlAfWAHmAOWusL5pWKepuWbsaHuQxVWU+dqnHQEyjqzQaQEOAaRZ82ZtsBHVp1g6BeOFGaybdaIDdnwsZAtHftSEGooRW1iC/aVMo3H6SVWVuxS1PSfjGu2WGanJr27jfK2e55nCnABDhTOGTSFGMxxd0fBSA7T4LNrQ7hj9d4OFBURlpIGkzhCRTsnPf23WwTSZRZCJvMo4DAvnykIylQrbg2c2bgzEGcBTnT1r+MKYGgtXH079yBI7EvO/QlCNcCirQy/7EVc/RoW0jOBhbt9uTBVtgurKuCiu98LTSKK/gjAS+gXp0PyXwaA1VKn8P7c3o3DmYMoXEwOYvlt1X12z8xTMmgJWnuUQjXp+O2rD5SNV4S7M7gjjw+sl1ZSJuC7IDMPg2/QcTXTQ+vnSXwY4LZFcKDJMGOQR0duhd/WVW9+LvRwE3zP757mOSspNh6eE8DPb1t+vf6aYdX7q857C3Ckdz9DQShtH7Yygt1t+6BDAoP4lhvrtaQvjoQTS4dxiNJTWjbIcbn/nEw7AkqvnNzm+NCqsE1BHRSWZfW6IoWnteXgY/4oyLPSvYkEd6nSNoWjMRBV+d2hFHmnp+5Vz4VkvTu8ISZM9D
 ZmFYfgW4
 gukgaqbX+8zd+G89BtApH6LS968+Hh1WASTvKDooR1If1TvHztwAVSFSoFG9ILEfKy93rvbU6Ju4C7iIvQKnqO8Up9ixgBxCqxEPsamHJm46TwMwAzO22Ui8Jb/vo7B0QvvfGEKdX6/8QMPRnEWSNJ/AQ3SqZPKqTAFqRoB2uQeE242H/UUMxOtgDhZFcwx6KjJoge19DlYxFnPZ44CQzi3eT9UsoNWg1jq+ryZiXtChGM2PulmcEaMdmTNItmbmnKUvNQoPwDTyiCecnCv2+hh82xMHT0nhGHZrmqFqzEGGG4tKyDDkwc9ngGlJqftyMsm1Csc3/irJWfEPlPlYdNzZFAsDkyzt2fX7MeG9+4nziR50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026 10:57:40 -0800 SeongJae Park <sj@kernel.org> wrote:

> 
> Hello Raul,
[...]
> 
> I also found 'git am' of this patch is not cleanly working on mm-new.  Please
> consider using mm-new as the baseline [2] next time.
> 
> To ensure this is not forgotten and merged into the mainline, I added this
> patch to my tree,

I forgot adding a link to it, sorry.  It is [3] on my original mail.

> after manually rebasing on mm-new, adding a note about the
> user impact, and adding the above tags that I offered.  Unless I find something
> on this patch needs to be changed, and you mind, I will post it again after the
> current merge window, to make sure it goes to the mainline.  So no additional
> work from your side is required.
> 
> Nonetheless, if you prefer to make a new revision of this patch and repost on
> your own, please do so.
> 
> [1] https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
> [2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/sj/damon-hack.git/tree/patches/next/mm-damon-core-clear-walk_control-on-inactive-context.patch?id=398e6f536b37de82f789d74ea93815dfcb129d99

^^^ This one.


Thanks,
SJ

[...]

