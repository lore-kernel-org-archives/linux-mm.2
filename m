Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40462C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DBB6B009D; Tue,  7 Jul 2026 15:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245CE6B009E; Tue,  7 Jul 2026 15:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C676B009F; Tue,  7 Jul 2026 15:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E130E6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:45:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7761D1C39D3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:45:18 +0000 (UTC)
X-FDA: 84963009516.15.0D82464
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C75AB100003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:45:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9fGiKWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453516;
	b=4Yk8M51X68fNJKBIj/gtrPnOcAE67zDuu3Z7M2aP5vlCL1A5eoCICWzVXcrjVv6xeOpCFz
	hquieiSUcCNef61JXCCja0897Um3YPQlGLDbce+wkVuCy3qT6pVrcx6IjJ2P3TcvQqf97V
	FRyNLPOZxuOBY3ag8z0nyzRF5LsVL5g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9fGiKWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjD0Ay/RGuMmXAFryRcqf7UQBWFaDLVErpeUMjY74WA=;
	b=n4MyK5raCqkbx0O+ylgUpJZ5GIB91Z7UN0q3cYe79r3tMnNV5pKLUKOOZiQrQEiwURa9Dg
	GuU3TO+dBJj/04EAkJXrYYWiGQ12l7/SV6ZI40hN9wgY3j+G3YOS/ikpvV/XnyDTEewNwB
	KHi+/v4H1WuXLZOuIUaU1masErmLVP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 480AA61836;
	Tue,  7 Jul 2026 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D5F1F00ACF;
	Tue,  7 Jul 2026 19:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453516;
	bh=kjD0Ay/RGuMmXAFryRcqf7UQBWFaDLVErpeUMjY74WA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=C9fGiKWO0UgmpcjlJ7ZsxUYSRNx5bcZRHSCU4OYpv2OHf04ceEkGc0L2y4DzuBzPl
	 cj21X37R8jDBsAcUeHld/lyxRSbm4VeG9TnW3Df8yEX6EvljdlCAKaBG0UY8CF7HHW
	 tO3sLo1G6ZGg7lvY3IUaORGpGEEUqXFpOJs1TYjWS4XE5udFpbLuhoWy4e27stM5sk
	 mcLAPWGpSqFh3Qs+epro5bMDU1dB4+dHDTxGK0WCI/slUh+rSUGah3kwLkVMGEyF7q
	 Sj5tR0NJGmyLFG5dEHl80vGnCOuAEkz6sEPvvME9+PCqCEhQZsrMldGGXDMjkbpw6b
	 ysl/I9nfh5HrA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
Date: Tue, 07 Jul 2026 21:45:11 +0200
Message-Id: <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=897; i=brauner@kernel.org;
 h=from:subject:message-id; bh=f2/r3OFjkGnjq1xSExRYwOyB6jTnXmNliLm2qYHSgNE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hnvoehTuXbSuetvytccYNN697Vv6qW3S0et32kxl1
 nvYeG5u7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiILiPDf1eJj1LiHUWydT77
 bfUe1se7vV3BZRdtUePYYh9b+XZrC8MffpNN6q4OHl5f9zrPDKlJOua4eXfTdlshPfWdgqaba12
 5AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C75AB100003
X-Rspam-User: 
X-Stat-Signature: ycbmxf4sgunpbrwkpso43weh1gngxj1q
X-Rspamd-Server: rspam03
X-HE-Tag: 1783453516-669335
X-HE-Meta: U2FsdGVkX1+qZ2lo9isXyvAgOziTAcenn0lPMv29VVAPy4bLEwoSDhNH/SXB8yiarmOd6U3PtOefLsZZguCHw2s/VhFXF5VBAh9kqK70TtX/yNMcDtZdqTLLK21jm9NPQjpoFVThkFolqvX0wBALQy3qPp8WyOVg9zkSFZ1rP9bdiYVbZVnCsinWOUDFhvutyI8Eb3qURv1aahd9/dnyKb+viFyxZzMaoq4ZB564KsocuMxhfBbgeag3rCsu1AXTCYMecXUsbQ/IE5B19F9uj04ni7xVgwuilSNPdfjYB0sWvnEL0sGmM0M2ZfcTDSXMH7p4kBoNUBXY/X5SJTCabIivAD6nY6EDiYkkgsUAtbS57H+FY2ld1BsXvG4FXo+EKrKVzZjRwOMVWtlopcSTlxSVFyu7+usqNFEcrpt8oNDci/F+lkiaF+UIzaj/nwtZTZiujHwGYCmrKhoJAZw/GUgTaBqxRtQSyFh7+9KTJapUrnMuNmCNPZkg/I/ye37q3698wIwVO1SHc5LouipG5K+ezuhpJo446BObvZVWZIDdBwlfC9RL/mgcSsBjmdzqs3wtLJPLivlrSK6K8nYJ8o6I0j6ooIO7Me5Or0s9oZD2jYj5Nat426KCE2evuX1N3gLMpUJF1HZERBcK+V8QBViCWQMtxNIYKTtW6u8UZVC6EM8jVefG3hxwGsD+JfMqNYy0rjxsxnIDVEQ9V6qGkFc2+Y8bakkGNrtBYkFneResQ7AX3VhFvnyrKl3sr8aiQelGPhPUmEmTNKlArVGoK7wqXByFIGCazKVIByE0fneh5fAwn0qXu5QJlkpvI8aAsyRxnmwgX8+auaUh+jPRan39VH0Y3f7Zb4SzWI6P/Ni3eFdSmAHuyh2QAGdym6wA6hN7aaQwzBCCFFHu1gI4gatEAAm34Ys5B+/ptTmvBEuhMpf2rPlljMHfLDmdxxs7AS2I5uwEJn4rUtnvQmI
 nhKMdjuM
 iT7VOpfQqWSeKM2b40BhvzAzPsP0hk5aXT/DT5KQC5BHj2+q8FKahlWD8/gdyogp+wd4TRcfs64VLUsZIgvo1dlgnju0f41AvxzNK4zO95YRKwJNXYW2DTcRUGFk5HkNJ0Vj65GakJf/ana5eca2cZrtB5zK4P0DaCX6W7MTL8+Y7JZk00b5GD7tOCezIwq5DOyP1ojPoSVvyr5dsSNcw25Pn4Ck3WSowbql7fp/pYEG1fIslYITME3RVdTKtVaUcCfV3SbfNosqdBcU3ftzMFQFJ2ENnCnwPOcbpHdQBgCclVHWbeJZY52//8KNAcHWG+kmN9mhDJGlAuvTyOTE41mLofEVitcMtimp5+lxwWVn6GvCTl0AM61oENQAle4FzgD55OQfhaSpXApqyCRkGh75lYYIIQZJlTArIODTHuEZjBaq/xP7xbVR2bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 13:34 +0200, Christian Brauner wrote:
> On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
> > On Mon, Jul 6, 2026 at 9:01 AM Christian Brauner <brauner@kernel.org> wrote:
> > 
> > > Ignoring the blatant bpf abuse here I think this is quite workable. So
> > > this can be turned into an actual design and patch imho...
> > 
> > Glad to see you think this proposal is in the right direction.
> > Just for my edification, when you say "balatant bpf abuse", you mean
> > how it abuses the socket bpf type?
> > If so, do you have any guidance on a new type or should I just take a
> > stab at it.

I drafted a POC for you that should be closer to how this should look
like with the bpf people in Cc. I'll let you lead from now on. I just
wanted to help you out and illustrate a more viable direction. Might be
that the bpf people want it done differentely. Let's see.


