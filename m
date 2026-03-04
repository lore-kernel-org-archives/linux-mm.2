Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4243BEFCE48
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007676B0088; Wed,  4 Mar 2026 15:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13AA6B0089; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D696B008C; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D265B6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C8E759C87
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:04 +0000 (UTC)
X-FDA: 84509532408.14.836A1A2
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id C976A4000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hVd4360t;
	spf=pass (imf01.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772656442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i62CyfGzlBbG78rdYdFa1rHokVDjFVL3h6+yZupnMvU=;
	b=qpAggD9YoIpNHXuHsgN56+YXiDDkE/K+AbtByXJ25dT/CEsXJjX7QT9zPZDsfZjmWrId50
	hyBbm4VvE0bwmycJ9zCeKPLCqrEnyCNktb1jDzXgTckxifpVxoV2FBtS7GeXlf+j83pyZL
	gzs2fKbparkM/5gF7A8UEUg+BHv6rJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772656442; a=rsa-sha256;
	cv=none;
	b=Mv0BV0eTFSOvB6xXfTyA32b8U65PR05u3o3GIc/RRyJAMpX04FziY+ysKYJtxQxgrO2OUE
	E8UwmATyYIfU5HeQa1Vb/2tVgqlcLNTWrMufaRnWffW49VeVHy1ILPVZ9rQ4lDH1LTqQdl
	dn2qSwK9+mMSLkO1a9DsZtLb82qsVt4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=hVd4360t;
	spf=pass (imf01.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i62CyfGzlBbG78rdYdFa1rHokVDjFVL3h6+yZupnMvU=; b=hVd4360tlBQvOPJNYEB5qg7aVH
	hsPdW7IG6fsdrcK6V9FuLMH3JAZad9F+AOXOYWv0yTjhVxG9sw8cfbYpr2JYR9jerpoc3E6oZ440e
	nmfh1K6ECmGc5OClQTv5AYfrCRLfi6l80PFxQvixc3tIqocDhQ9stlCcibdyVI4BXud+4BjBMYkY0
	G7hezmS8iCWUcXZTLWgdwCmtuO4+SMhporU+kWcd3/QjhnUi/63bCkVG+KCsDv76cykKuCR+iRpO2
	osptHGXvSJQaRT1aopUZLkHq8qylFq9GYC4wEDeSAO24b3lvLWK4DHq0sMUonpJWoPmMJMwQNdaKz
	uHkfSW5g==;
Received: from [187.90.181.146] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vxsun-0095KB-Uw; Wed, 04 Mar 2026 21:33:54 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org,
	rppt@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH V2 0/2] Small improvements to reserve_mem, take 2
Date: Wed,  4 Mar 2026 17:14:09 -0300
Message-ID: <20260304203300.1414286-2-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C976A4000A
X-Stat-Signature: ps7bx19ggd5ahkttniynnn7rr8q3dapt
X-HE-Tag: 1772656442-488919
X-HE-Meta: U2FsdGVkX193kxfMccRCQr3INx8zWGgn12vWQy2+UQaybeGDT/iszZ0JGju+h2L3MvU3P4C/TKyIZTXpTqBahqNIDZZbRseyhH8ojMOjTV+eF8mdm96omMielIDW34cBDrGuuzMnm5Ranq/94B48LNp3B139DkA2zCSf1Wnt2Gi0x1Y1SF3nyLdSZIVIZOSaOF9QDD4t3PORX5Fclue/ZPoIpchDjYMJ95JX/n3sRoPNRSpfLhGODXnjI+6+sLaASb+IZMWX5dCOjJpSdkAP5CITe150E/wUOiax+LVGhLUbtB87XbU2J9xmIjQGj1GOQe+Vl5ONOIpYlYzPayDbquthn7Y1BhJTV4RCylVaV/gQ98fvmlbWLOo3s70zuuWfSUHaX9Fs1wINizUNBnUWFdCxZ0PyqPdqjzBrtPvEakz4FAGL93ahz9eDH6i8cPPTt1WB4f0O78gTkTxCklKk4VfzWSgCLk0B6xTwod9O8kHEgfp/U754dl8YkYlTbizskmu1Px/eMcEwRLasLyaXvXjgT92BnV+eBL/xEHwbjc9ZPlctP/pqgZ7cYlv4ht8uV9leKLC4/ldJFpIZVDf+4KkAnJpVvKqnxs2xISXQkVFD6yFv2TGIiyXyVK8mdJU734QgIhP0tQLOcb/KEWcBYacrM8/ADxc2V4bZv1SmWmFquXYFIm08hPICJmDv3N1BtxXPjbNKUTo8PTGR4y6gFg3ZG+nNYMxIHvcT3vsOcG8zOtwiyNooQC2gV3QqNB5ycewApTrxk9vjVmIrjYbojbSvT7jv2pb9ux+OEQ+p6W5hvZe2R2WGmGWk5faSRcCtfwiRVz6x+xw2lb4EsvE1yOcXwkIyRMLmfsYBOW7tRMWhgKj3BtFzE/cBvlLG7HHm9zN1JKOpo0VohHGAVeCqj0t3/5kHEK3LtForpuIno+/PeQ5DT+MC4O/S85FYfetyaJL7Lu9ESm3hz1nKdIu
 KNhyie0l
 370q6GWdhyO/VP5MIpo0pNEZzF9Q/MS+vGhYyT4/AzGruLDZAqqA8YrOY6ZnW5HU5XqhfZxIZPePbBZ99i870pvRnRMNfhGECV8kcXDYbsv5rRRvDnu+OseBk/kHMevmwTcX1XVecfMItpE6PIoSKTDroW7qeV65j6C4Lh4/xOYxRj6hjmyjf6QgbKm9Y2YBxEBjfe2jRDKufoOLNfF9IcVNLSlEsyjPJSogBJFQVB/X8hiJYmiNanDCFMi+ir+pBwXFC+47bTFsaiN+96PwK7VhrG+Uv3vDGGtJtDDifnuwagNuj7i0eHYMWUYx+esok333e/58jJF6WCTORy8P8YRLieFue2gESKLOVsIH/VeE6xGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi folks, this is the 2nd version of the patchset, V1 is
here: https://lore.kernel.org/r/20260217195816.861684-1-gpiccoli@igalia.com/

So, quick summary: we are adding
(a) Error messages if "reserve_mem=" fails;

(b) A debugfs file in case "reserve_mem=" succeeds, showing name and
size of the allocation.

Use case of (a) is kinda obvious - we want to know if there are failures.
Use case for (b) are users or tools like kdumpst[0] that might want to
check if their reserve_mem allocation(s) succeeded in order to load
ramoops with proper parameters, using the reserved areas.

Thanks a lot Mike for the great review so far! Questions or comments
are welcome,

Guilherme G. Piccoli (2):
  mm/memblock: Print out errors on reserve_mem parser
  mm/memblock: Add reserve_mem debugfs info

 mm/memblock.c | 65 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 54 insertions(+), 11 deletions(-)


[0] https://aur.archlinux.org/packages/kdumpst

-- 
2.50.1


