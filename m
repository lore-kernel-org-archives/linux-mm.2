Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FECED1489D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968F16B0005; Thu,  8 Jan 2026 00:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FE26B0098; Thu,  8 Jan 2026 00:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DFE6B0099; Thu,  8 Jan 2026 00:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 749A46B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:13:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F7F7B9D7E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:13:00 +0000 (UTC)
X-FDA: 84307627320.17.5C33D11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A4C58140007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:12:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3zoCxQg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767849178; a=rsa-sha256;
	cv=none;
	b=SySJfpTVwOvZl84RO/sOorQHlIvfXdYiPobhsB03fpGOiwEV//XZs/FESqiUdqfWsHSHZx
	3tigBVKUuDfOgw9/zoqGkBOCsjz5FPBXg+ywFiqFn4082RKYBpwv9CLlhHCpo44BD9074o
	gZUOwPATyNgrsG8a4JIigTHqtEfbafw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f3zoCxQg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767849178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ls1FVTbhlJIz7Xvv2IAiYX9ugi6Oc7MjHhHUn7dJfFE=;
	b=7sxBF1mpkLmBiCVoRAGp9ROTMXlWvjYP0FCeA+BG0hUAHGh4gxJjDUl6btx+blPIz5Lu3q
	X7TB1FfXHG5fXcutwEbkbPMNQ2Mnqubp6jEWoDDYExbXwMrxWfOIvTgN3vBUXvsBZ8l5YF
	+r2ROgBRUx0e0dIoGkP9bTEXvWyvk8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B431142DCF;
	Thu,  8 Jan 2026 05:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71021C116C6;
	Thu,  8 Jan 2026 05:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767849177;
	bh=QIfzWMb0DNiwWefcZq/2yQSEyvgUvaKgQCA4R4LPX+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3zoCxQgz5NnUbZID3Qde47T33yvva0nq6nQ0BVHj+rrwo6p0uJPRxn+hYHHeHlWe
	 n/MfUseHhPQQtNPwAOJ/oZLzk/ZmSyZLuI4QAVvG+hh9qNtXEtHkDAujxrsORBwe2F
	 oAYOibT3b7gB5+oYZ+Yfgm/4X+u10bYTLW2hANudcTkcc2yJcCbHeCU1CjqbLvq2xl
	 5WZXdLvAjs12vIkS+Z3YUVFhyD1zFVebuBYyocWUuEyWJVw9g24jmaBbWlalh7OGCX
	 A+1sUW9oqh+Iso4dOYLYEmJEcLgqeKds3CMXTA5l34XKBqvYgbuAP+XIjCYJa6g0TG
	 5LLX/zVpCDNxw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	klourencodev@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	kevin <kevin@desktop-mu90jgd.home>
Subject: Re: [PATCH] mm/damon: fix typos in comments
Date: Wed,  7 Jan 2026 21:12:49 -0800
Message-ID: <20260108051250.81675-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217222609.3355-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4C58140007
X-Rspamd-Server: rspam03
X-Stat-Signature: qsijo1ta8596bxrswd9f9a1fgddswg1x
X-Rspam-User: 
X-HE-Tag: 1767849178-934784
X-HE-Meta: U2FsdGVkX1/PxLBji6veTdAT4RFdEOSXrOH8ZzmfxjvmMfLWeZml+aLDdC3It6lUzwlqnjXox5A7vfp5QYG40CUrNgn7DkJgNtiK/7iTbgsCCjUoA7l30Z9jcP7CX0ROYu5wUSnYoLzWYEd0fe7izqNvzAFYNlyeMhhLOZz2Gz8ylMtYxpAlxC8n27v2UWcjnJaC9h5XlAFR5U0qiKRKT32tY/OKB55iAI8GMQEvLM/1orLIve1y6MPQLd3LE4WYZfK3Xyel8HGp1HlnbKIbXEHzla8VPWFvNkWTY789m45m25YIKTZleNeR6tXwYROCZmdAFIRBsslmp+Iz18QL+OLRoJmfVbwTLpXXs26FZXSYEiYykXpre88d720ZOVbgicFknBq7hcF2HbhPpeCyfOPNwmnUE7aXfZ+73SNg6EToNpi+a14y3D2y2HWVOgXdql8S4npfl9gQ485tLcPPz0hggN7P2+/4qDeUKgOPqB9rMFxu6hiPDj/rRDNLYHY/LReGjsL1o5ehm84LZ7LVEBtdQqHowJpnAm6T1W7TmGUkeTAeP4Z/N5WNBLXgLZwylt650moysOZeWT6nSTlL9b4pJIhp//cCHJm6pLKEYcHzMGOC4TkkOGmQ45IdNPu0tmDhxqhfSd2KmgWlZ4+kQYiKteBgz9Qe/mKxmqHpg9pxS6ByIwIlaIgXBY6f+0HWBAf6Ncy9D6TTr7YElk1RFwm47wQlJDNA/ocn1vswj0RuKnty7wKGmh4uxjiSR4CldTH8IPrii606A72HZbNkpHYmhpPpDQFrgMTke43Ao/ptlde13FUpxMXITNbi5/BFL4aXsWAaj2lGNFFrJjfIolLELmyewdPXlb7QmgfMj8lHhmSEduxltqIqIadoMDwrqTfTJfw4PdwZCb4RA5uOXcnuKYxMSJbmpb/ktWz6GBbrcQCPXAOFhmi/fhSfYfC6Iw0GtHqiviT3dpecude
 VZAH3hhl
 FunMeURwYt18/pK0jQJNmlO0voJG17L674fbf6gQZQ5qVwPD2ViYZ1RpkLUsgLJl+cG7zzP7EhiPuqKp85ZUMPLFzqKslobMQQ23yrz7I5cc1SsD+vaTRd/W8wkksq8TjmSc6o5akw0GXXSenoYchCjMSpQv9/+neyolpCgQcB/b0+yOL1w5UbYafn4y+65p8wcSYTiRdgO9cq6lDKASDl46CVjAec6nniWTFy6K3ivBZZYyfe4nurgmI75Zfaz7JzGn1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Wed, 17 Dec 2025 14:26:09 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 17 Dec 2025 19:12:16 +0100 klourencodev@gmail.com wrote:
> 
> > From: kevin <kevin@desktop-mu90jgd.home>
> 
> I think this should match with 'Signed-off-by:' tag below?
> 
> > 
> > Correct minor spelling mistakes in several files under mm/damon.
> > No functional changes.
> 
> Thank you for catching this!
> 
> > 
> > Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> 
> Other than the inconsistency between the author and the Signed-off-by,

I saw you addeed this patch to mm tree after fixing the above commented
inconsistency, as commit e8dd7a6b54a8 ("mm/damon: fix typos in comments").
Thank you!

> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

But I just found you didn't add the above Reviewed-by: tag from mine, to the
patch.  Sorry for catching this late, but could you please add it to the patch?


Thanks,
SJ

[...]

