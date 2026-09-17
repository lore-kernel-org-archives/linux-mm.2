Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DA2C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214186B008A; Thu, 17 Sep 2026 16:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB2B6B008C; Thu, 17 Sep 2026 16:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128F26B0092; Thu, 17 Sep 2026 16:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D85756B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:26:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AB721604B3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:26:50 +0000 (UTC)
X-FDA: 85224387780.06.7E67048
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44E47120008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:26:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D4pmKdxh;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789676808;
	b=j574sIuH8+z6bL3iZfKaNxDI5vUlgQbTRq4zENcgqDHmtL/gDxRog2U0ol+qiY2aTCpypO
	LwjemnpJDEuM+6I4eixRVTFbyVSN6gaMrLOTKU0CZ3jiyp5ktMDIJyAMFsk3vjHhheuvZ3
	m5bIqI9nHQQOfflEFSxLnPY6/CTSO5g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D4pmKdxh;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789676808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcHBkdPQ9u02lad3vdNl2l/OX5b8EYvouHfmIGVzPcs=;
	b=mfzCuXcC3mwj6hjXkp02bSJ7dT2Bqni4xAx6HpWS3JYLO/JQeQizvQDEY4kVUtfBIouKzi
	4Ea2Tj+QJw3fQ7E+kdTUh/iCnFqGPsDHz6JwertNSeLADFoZ7x8rjlSxkA2pb+n4ECZGVk
	ng6b+FiQzm2knckq0b/FougHCbmERrM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IymYpdktmr2T4Y5nV+Oxbm/h4xXa2qb7o9DAxlo2Xn0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789676806; v=1; x=1790281606;
 b=D4pmKdxhFVZQFivGakGVOSrbvSKbZEBdyCjj4lGV6icshBRbqhP0wfoG4pG19ksSNEqjl1yM
 Ofu6j1bY3qoTBen7GlUiQHRiD4JQ4RFAd7b72QkQqDt39PRjCXSVvkzG80oNq8a0aoXMyLNHK1p
 hUboxtUeSqOiYwVgIw/c67As=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5c187154c223a05e;
	Thu, 17 Sep 2026 20:26:45 +0000
X-Mizu-Trace-ID: 5c187154c223a05e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 13:26:40 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aqxMk6yaiFHeeAAg@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44E47120008
X-Rspam-User: 
X-Stat-Signature: i4esipqdkqhqbbiga7sf8hp6f574y99b
X-HE-Tag: 1789676808-283137
X-HE-Meta: U2FsdGVkX1+EWmckrra7ko3WkRym8JE0Vy1pfITjoaM0ixPA3+6CuRemYpQWGmTY4Vb1BFWB9MKOHJW5M99qwOlt9HYPH1oyUYMPXOClEcBgqI7MDvVZd0iutUuicBc4mAtlvac3O76DA0obx4g/pnuSHEvLAFVdGGDFkJ9chS/cxbPmZcdk9Q8vNKr8Ccy6gKUX7g/2QYAzpya0aZqjeeXymxWUjQRxCA2DAnrqoOOqem1GgzwVkj/0iC1nagx4bmkZUSvaSTL99jQqnCnHjTqSKvjjPsznzJoPfqJx9uA1nb2+Nh9TxX6a75J4OJ6yQOkebshl8LfjQ2odfsJt7+AZlUf6LYhCOckR+3C+rWDqbucebAjgP6QdfgtpbdaYNrqRxCnosoXK2fkj/XZtayosIhyxYComo98r4Z0oYNxHgwADIL9F6Xoyd6KooratBo4DzRRkyYV3qGr1aZQCvj8mxeswN6C6ZB2WViIwPs8xn9tdGoyoQAcP1gONFZj/F3nsPmZKtHZyq6hXvyX/KRBItSB/BYE3O17jARln3yJQ0thzgcDrDJjjJ2bHwD+gigwxuuGeSMOEZvnXLTX2P3cgRG3Gn/eXCGwxuTJehOhqbchj6xiYKx6Dt7BD4BIHZj3apE85YgeDrzkfpiTLxedFF+lkLLbuTgXwj97pbh3mE0We1bxZLRd9zwB3h/rkyXaaGZfnZgDdi7WehL/UhjX2iOet/0hlrK/i+YVPIxCyodAcrZW7EHZUiVpxC4eDcexoL3T2/b+6pG+vjsV+ho5oA7ela1N6xbHKY0xnP6GY6yh35DrEwkUbc/pqlAQjbJOJc11BMpbR99bCtB2Y95bLbxj4xKSvZr7SFNk0OZGF0exeYGdkSRswU/hqPf2UUTDWfgPruNs1nBihot7iorxzchP+qBEe53VHrIXryZqvE+4GrSHOBkzVKDGn+icv9Zt+tiIwZsjBwj66XFb
 raifkCwC
 ht4/v4HBrFog53RCpsDVwMSPpoC94bzT9I7RwuopjMAN6xsd3hXDggxd2SC++gOmzcy5U9U8klHZJXBG5qmmR79K7pUhoxJxQ1Cnua+30QEB22sHfft5DRUu4LGCgOMf20LYUKtTnLklJ0dyH1eqcbRuhl58gYR8HTGo9nfcA45gUy8fgjZpxKQOvwZhZeYuSwuVtPkcM6u8qXOslnUN8PzUpbv4VbLhAw2mi3XxVTda6sftJ6tRnttAzIKxsXff74Sbmoh3VaDuZRwmmkzQ0yvRw72x6GZtum2O22M/EzRHWPHuoJOowKr/vUwvgkeHJ5TeT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> The legacy cgroup v1 memory controller has already been moved out of
> the shared implementation at the file level (mm/memcontrol-v1.c) and at
> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> per-cgroup state, however, still sits as individual members inside
> struct mem_cgroup, guarded by #ifdefs.
> 
> This series isolates the deprecated implementation from the shared hot
> structure: all v1-only members are grouped into a dedicated
> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> 
> With this in place the v1 implementation is self-contained: its
> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> its eventual removal becomes a localized deletion of this struct
> together with mm/memcontrol-v1.c, instead of unwinding
> ifdef-scattered members across the shared header.

Sorry I don't see any benefit of this code churn. The code is already behind
config. What exactly this code churn is giving us?


