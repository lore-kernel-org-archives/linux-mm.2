Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF02FC72D6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD1D6B0005; Sun, 22 Mar 2026 15:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DC96B0088; Sun, 22 Mar 2026 15:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3E66B0089; Sun, 22 Mar 2026 15:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C71616B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:33:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84D6A13BB14
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:33:00 +0000 (UTC)
X-FDA: 84574696920.03.CCA5104
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03D95120010
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:32:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+FtvOeo;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774207979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7XvfB5P/nMyjAkCWRyjB+gw7L9jVWKHJRlA+B4UFC0=;
	b=LUZR1bAmgNvcBpRmu2gvXQhXL/wtVBdoUucQaLlz/anLtAQONGE9y0aeCtt7xYYl8A1ODM
	um6lyKu5lmu6OCN+Ftcw4/VP4rUhVLGLEmbIikqXYY7eSlCvO4tYYcOnTqUIEcG6TZLA9Z
	YPpWeSUwR2fD0PV1yP63gE1DV+KFsj0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+FtvOeo;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774207979; a=rsa-sha256;
	cv=none;
	b=8n7iALr7lI+c0/D3XEoEK6ieKHTeOVrxuX5aguugn1YaLxH99WDZUjosD3ifJiiUHkhebx
	wiK0b9Bvr0E96i+4aLmD2QNLziW+2JZ2JrzXgJknJWA1yM45ZmrEO3twdqrZcfkG3S+xny
	C7G3qobZmODm5L28e30zSPsFwbfe97o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CBD6418D0;
	Sun, 22 Mar 2026 19:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D06C19424;
	Sun, 22 Mar 2026 19:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774207977;
	bh=3D+LrY1/ynKCWurva4ZNY7JKVhIvr0t2su2LfdfwKQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+FtvOeoVBZccJvJX6KAWADTB1HxETF2bkgp8zlyFw1BX4mG81zosEk5W7kqj7qDz
	 7SaQ6H3DW9dyeM3B+An0Tz3hQqB8k0r0GPUwYcQf+kbQaMxBuAPXNTXfh7iam21x2k
	 l/ymJaJEBpgoCZVxGNbJvSBRqm2cQRTfnseoL6pzOHpJcFW8PMU5U1tO1e28ZziZej
	 /b+pH0rlgioex45VOlI0KA/Ai2zg8joxHqRjgV7T7jUi6/AjqtaXhbmtW8ddBv4lL6
	 0iJAL8r+5LJBRheMVCZUbqPOcoF1nmiqRQEXdIzvL9ipL+crba70Shf0dET1SuR9VV
	 02rO1akKQ45zg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 15 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: avoid use of half-online-committed context
Date: Sun, 22 Mar 2026 12:32:55 -0700
Message-ID: <20260322193256.88040-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322192641.87848-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 03D95120010
X-Rspamd-Server: rspam08
X-Stat-Signature: wbopqgu88feun95ocaigu5ctx69xnmwx
X-HE-Tag: 1774207978-384419
X-HE-Meta: U2FsdGVkX18CpxjmYZ69Usv3poVMMa4DECUiyp9K3PghVy8LxYY1yQDF4SsOJ+gnbfKCMreVjPtwwe7WKR6F9Qy9LhL7B4SYH44qORqqRqdU3beivZ7zjkilsmArDVvSOjjJt2MdGiG4mhHehzmVJoaylsZFSzT7+yH0sMkItNjqktA3vWmO0eYb1GW7ZKaWJsmLZOtSpaRGM80GhZbd0TvHBsZuOMd0u4A7nxln/a5XDgpdSawuiUxYNeMDtMPvu0cUBbYQe3UNR35AKWpn902G++WW19PjWECWztfc6/ZB8+jON2gNBr+ehxITKihKFOT3D8pnstNcGnknQoVxckMUctbxyAwvi/NUkx2kN53xhzQ4ePmC2upEw+DEVr69xPEizIiP48Fm1T/c7LkkDAlaL1u5qnzeiXXq9COwfGFcdAs0cUGv13W9R64fb+LRDbGrTJd3FIzZOf7SfhiALV512y0bjFOqCQa0WISF8W3D/dC8rShQWMOwmG3BCI6+HRioUYPcGMBlf44DlVd6l5m+/5LzRvEm9cvwo+VQkVrD8u8WZpxeuzv7uLxgGGbeLvyz02RKvtWAb/yaRQoNF/2VuFKd5n5IzNExIeJFmwW/GrRlngNdzZ/PtB4tK5zXSo2ClRMgnHho6O+HroegV4xCReNDQicC4x/aG+vgqYK5rOHHj2SQkRP4baKVqYzCtH5h8fWqYxKOem++htiSLBXSgda1jg5T0RrK0xFhdtb2th46VYeTLXgWtXCmUrc+kdcWgFFEkgWq7TPbmDZx7jOPCPTLoVsikrmiHk1BcZ3WQkvsFQ+KUXt1hW8j8GWvlNUVdManfsILNq/rKGo5mxw8nncJpFJMiBjKYnq0W8YVLWeu7/ubicXer0n/QNIjx6EQqyCepIEeixW2UT/VY0O872R/1F9/WzyVMwGiBRv+pIh5DoMFOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 12:26:48 SeongJae Park <sj@kernel.org> wrote:
[...]
> Now the feature is available on 'master' branch of hkml.  I started using it
> since yesterday for DAMON patches, and it works for at least my workflow.  The
> documentation is also updated [1].
> 
> [1] https://github.com/sjp38/hackermail/blob/test/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list

The above link is broken, sorry.  Please use below.

https://github.com/sjp38/hackermail/blob/master/USAGE.md#sashikodev


Thanks,
SJ

[...]

