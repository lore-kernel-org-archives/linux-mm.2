Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D63E5CD8C89
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 17:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C106B0088; Sun,  7 Jun 2026 13:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CEE6B008A; Sun,  7 Jun 2026 13:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62A16B008C; Sun,  7 Jun 2026 13:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C97276B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:36:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BC17C2A08
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:36:55 +0000 (UTC)
X-FDA: 84853821990.11.1BF0791
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CBD7F14000C
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:36:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lv3HEGr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780853813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52SIwcd9Prvxu4y3GXU1hVE6SDvGCfin9Q9wjcWOubQ=;
	b=vtyvmnpe6nA4ZBN3zuh+3Lz3qqqQdyoq7Q58BNRTcd9Bqfk0syD5SQs7JSHyj//PurWpH7
	eeISqiEnEgHeOXnbnAY010C5cGWzXf3B1pV3U4qcaz/Ux/431utC+2DJ64EOR0oWPTXQjQ
	g30cDcWb7cA3VW8ulwVLwYBgWF3+LyQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lv3HEGr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780853813;
	b=sW68r7W/1XM/tq1Ix5tY+TrVn7MNc0pckWamfMuQbHVUoYML00SWodfY4BHQn5uF1m/e+Z
	ko+nvFLU0HGNWPLnqn+e7qcj2MXkGzOLqhwrkdkBtzSfJQt3pqGAwfXDzBybHquzo1753e
	c4sQ8Ev927Lp/nXdvL9ZtU2L9AXEqMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CB3060018;
	Sun,  7 Jun 2026 17:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8DB1F00893;
	Sun,  7 Jun 2026 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780853813;
	bh=52SIwcd9Prvxu4y3GXU1hVE6SDvGCfin9Q9wjcWOubQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv3HEGr56u8JGKcD5qnIgVON54GoCgMtVH94rdgRP9So9LKvoOI08KozG7d5XYh2X
	 rPPLhDmrrdRIuTCZoFdk4LA+VNBVyMWDACfxV58WObjyjyJoxvac3cz7fGG9QUdt1u
	 pVJ2gDDF9H/3mkdcuCU0tCjC/2fKArR7S9bsu6IcpSe00Bkp/ETrJ8lEzPMWa/iu9v
	 MLEWAKYxPEP3GW6DXicJ3dlirU4NU5GSmbNp7QuCGS+RJmGmKu2AfM+tGHE5IVH6IE
	 8H+RLQgdJYeB2I/jAFkog4uY4vIdPfUoxu1BBoXUbUAk97HtTxiiXUM087/L1Hi6Zw
	 7KDOkt63oDO6g==
From: SeongJae Park <sj@kernel.org>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: drop redundant mmap_read_lock from damon_va_three_regions
Date: Sun,  7 Jun 2026 10:36:44 -0700
Message-ID: <20260607173644.93883-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607-rcu-v1-1-3c9f5995a3a0@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8cnuyspuurygut7zokxy8xwmrjr9ra34
X-Rspamd-Queue-Id: CBD7F14000C
X-HE-Tag: 1780853813-76970
X-HE-Meta: U2FsdGVkX197+37QzLgg4I5LuSstrmB4W706MTBhAycC+eKpuMSXHQERbKnJsaPG2JGam5UAbkZTEFOp5SJP1Co97jqJNgE2ObjoonI2STnuwtBNRKNnx/qy7kYUjqVSOysaATPeoHib13b0RJUCn+xRTjBkrYJEcGbdpP9vTX4dWHhQZCltt9hQX6pWkyQ0iHf9n8oRRD1bR4J8L8Zzf+FVG2ozF7IS57CfgYzyU5oj7ehd9q67cT7ljk73PO3OtnwfRvpgCIhhY0KKou+pz8XK1st9ET0acOCsD2dLtK9acrc94cCBV4J3FaBu69r8ot+Aa8Ngeb8+MidQ6Az9JBevyQgyyPfCP7EHNtw8PEG51GeABfJNIDa8QYK+Zrrkdl2i7+hu/eIyUdh04hp216/CCZnNixpd+Orlm2t3mNwdfTRaUMzUkhjXQZunke+H6QVwL/CZBH5A+ulGyU/zcT8PJYwWssnpg6fSCOIJ2zG/R64Z+9etb1zCS8nrIjE6HyGpEOw423IfnMZJYO3b9Htr/y3qB/GLh1AvoxMY4sz0Ns4myks8kymbny0D6JnUUseUtm9wkEeWyosome7uQVR9MoKnXEZV9/6+NHrZ++okGknFo+zIesa1dstUaB/O4PBrtb8iRsjXkxHCuKxLrSr2CI3C+vwjuoIPz/4Gl+BzvsiWDETkLuE9euwaXqqUK8lFjYtQ+XArmO7BnhXlovkGf1vW4+j8bO4QsPhrSYN6+MqWDFr9OUKQ6KUjEojweKZFLIOmzItXHvp46LQbOe4QjjUEecaiulUYdhmE92cX9eRGldl8Os8tuF0oh9MKBSYiOBpW1DAmOY5LF0APOtShIuC9HzRQoruJ1y64iRN5EYMrdVw0oCLnHXT5wIjXyfbPD5EzZVkCwh8DrO0AzbpovH0sDXwRS9nOzAhbbUdR2XWg+rT/jhvwWumCP0nDdO6bcyNKXYqnlIypXbP
 kb3iJGzL
 r3OakgBYlIvU4BGGc8HH5iS2T+mWUP9dDQ7rbUii5wrnLBEX1+/VU3ihWWTeGS4H7dj+A/+65NroeZuj7rA7mEiHd5wqJCLHvYHB7hV7EFZKAubKubY2N3YICr9GjVkT/Miuwm2wE6OGiECbluWQNzNpIk4FEjz0HganjfR8f6LlY69OArL//B1Egx5HgUIX5203zIeu+nVrJ22RzJ17xogagBlVLZP9GICqPz67gP90mo18Lhza4rHl92WbGTQ7C/X3ojRbrFSIUo4mHhXB2rnYUlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Cunlong,

On Sun, 07 Jun 2026 21:48:52 +0800 Cunlong Li <shenxiaogll@gmail.com> wrote:

> __damon_va_three_regions() already walks VMAs under rcu_read_lock(), so
> the outer mmap_read_lock() is no longer needed.

The function aims to read a snapshot of the virtual address space.  So I think
mmap_read_lock() is still required.  Please let me know if I'm missing
something.


Thanks,
SJ

[...]

