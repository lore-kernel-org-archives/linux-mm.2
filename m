Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA91CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFF06B0088; Fri, 16 Oct 2026 11:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492C96B008A; Fri, 16 Oct 2026 11:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6876B008C; Fri, 16 Oct 2026 11:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1654E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:08:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EB3B404EA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:08:19 +0000 (UTC)
X-FDA: 85328820318.28.7E9866E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E6C464000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:08:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwMOGeKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792163297;
	b=6TwbiS1d7Dj9AskGxMtfMZ5EJ10F8L7zKr1YcQLaTjakl3C2D8BYtKmJBvX6Racu+0PrDI
	Ha35gqXC71VWDzhTJguv9QzavPEC6yVrL+c4Pm7VaWwko3Pjtpg2l/m761i1zwJ1auQO62
	0eSdJOkVsERrO86/h7+ywBO3t4dIZAA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bwMOGeKB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792163297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GaGFNgl1GBFYDagkb0NG6gNUC4bplBfbJ7IM8ysGNo=;
	b=KSpwTz8GxCR2HIfDoOnFpX7DBLeo6R/VJqkbbQ0fbW3BSWXkI/cF6PJky0IsL8W9FBXDHa
	qHZtrmoReSZ4c2L8HswykqDDtSM8hpRmomYSxv2IIgLWQbGzhSWhR6NT29piRpVjREscHS
	XE3JSX4tDRahlXMVc45p8QEE6EP51Qw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15C19601FF;
	Fri, 16 Oct 2026 15:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA7E1F000C4;
	Fri, 16 Oct 2026 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792163296;
	bh=9GaGFNgl1GBFYDagkb0NG6gNUC4bplBfbJ7IM8ysGNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwMOGeKBmDDimGvJ6avqsU4zzJU6oWHAMnplPaUKcB5a+3D2eBDGJJHM7kcMRy0jH
	 YStCKJccgkyStEtEmklxkcSls2oWI1cH8MRk3TBwKxeuZdAfztE6/G0kfQQvJY/w6n
	 OOWz7ELc2KTC+Joy4OR3JHx0KEWw2Ox63TAH+TflmLFmOe7u46nzphV4K+jArOS7PR
	 KY82tGQhzfpp0o4wZgNT12wN64DSZY6iH9uP4x8Bp7qcYhTcbLzmeJseGuGDkeI/MW
	 oDPO77sWv/FyP3H/eTO+1EQwQSSHj2vJ/DOb7WfCe+xr+/7ZHmPZclFCaHVQqwZjgm
	 VxZKJRhu4KoMw==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/1] mm/damon/core: Remove unnecessary zero-initialization in damon_new_ctx()
Date: Fri, 16 Oct 2026 08:08:09 -0700
Message-ID: <20261016150809.92159-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016143733.320-1-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxggmqa8zc6yxfixyqarernnnj3z9mrf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6C464000C
X-HE-Tag: 1792163297-740207
X-HE-Meta: U2FsdGVkX1/O89gdTp7otUBdpAJfF3bxiaQUJXi04xDKwkqTvUz/oH3EQ5X6viIyMRisTQNLVsbyOikwqGg99zoFRYyAZ6ruS424b2Hy2sZf6G4qvsoK2innDrb3UUu6o4cImEbQzRvrwv3FvIsIGtlY1Q0EmgZC8Y/nFKhsQuACdS4Sq4QpfT0nBxwBMLhMBYmwHDVyEYfXWxdB9xE5E6lTjJM3NBjt+r2B9eYlaWPsmDNZrbbaka5KZykw66HPyCuPkzTXyB4iYQ6A3/jcxW8WFwl6nj2C0axmDm4067Nf+SmQVnArwvk5Mf8MvgNORh8GufkZo6cS7BI82TY+0Srd0uaDCdkZ9EAtYd4iOMHd1cHJYmGkDAe2NXnj3UzZge5765PTPVN9sZ5Utms1bI/TpQ+2OvXMHYISHNmrmBvduF+Tw/hucO6R8IcXk4ssTVpIcu2dIURWAdovqoNjVILtLU4kSRycWtPkLJbdzYlkeLZAzQdDZ0qknadDiC8xBOnwptEjolLCDxzzondleHkon2yDiNFwYZsqaD9u6MTa68RrkNglo2wjddf9UI7Z+eQ29ETpYqnlhrQfEV7gSpJhlMu57ry7LMWD3715R/LDWBZmX7udAEhAOdluQJvFmV8cb+6hqmtqbyih2jOpOWf01Nn1U19fkN2rZtFXGwFZKA5Vs549QUtxSD8/gKzfok4pWQi2mEiOSFcT/AaJYRFv9JlCxAoHNqHa/5p0AeaTJZRtsJex3/sGPhlzDys+2sPJC5npPvjdMFYC9MgtJO9eJCeays2E5YQ8S4DN9c+tYQnTwdwxlho4OLEjP59V6USJmGca/LcIgaykQwMD8uAxC6nKfcmZNufT27qPPYvMycTzAy4IlyKyB2BmbS4eh37fStg8XDrUxWIUurI51j8NfLhmoeAv0OdC2CDGj2OUz0Mgx9iJ1Vpc/FqDjldsx3CFloLSg+0JNq8OqjX
 KBSnwChM
 CXzVwIYaMFv/IdyPmdrzrfOR7Bn5y51ihNI8YDc6tMOzO4DRRF++B/afmmSC1AoIaovhXwAPPbWA8QnsTJS8DEkx1DE1E6q89TwMPNapT59tTB8obJIwMrXTxG2OfX80h0lK94bZylClFvNq7ziD/Zn43oyCMCNQwLbBAhApRbOkx1jKJ8meP+k1GJuPM3DjCajw7GQP0AjXdcgP0ue3DHbg9GshvjEl/wtRXWdjOEvfJ5VLY/jPjB6YgLGHvTCyclRhv+I/D7QgxZ7xK3hTYJrv4FK9FyeLO4VmOklVUZ6+OZW3dBETxVRtqNeb20RnlIUAQ7rwURZCw84U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Adrian,


Let's use lowercase for the first word of the subject (s/Remove/remove/), as
that's the convention in mm.

On Fri, 16 Oct 2026 22:37:33 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> damon_new_ctx() allocates the context structure using kzalloc(),
> which already initializes all fields to zero.
> 
> The explicit initialization of passed_sample_intervals,
> next_aggregation_sis, and next_ops_update_sis is therefore redundant.
> In addition, they are later initialized by kdamond_init_ctx() before use.
> 
> Remove the unnecessary assignments to simplify the code.

Makes sense, thank you for this patch.

> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree after adjusting the subject as I
abovely mentioned.  Let me know if you dislike the change.  We are now quite
close to next merge window.  It may better to focus on making mm.git more
stabilized and therefore ready for the next merge window, rather than adding
more changes that are not really urgent.  I understand this series is not
really urgent.  Hence, Andrew might not add this patch until next -rc1 release.
In the case, I will request adding this to mm.git after next -rc1 release.  So,
no action from your side is needed for now.  Let me know if you think this is
really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

