Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDC3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91656B00A7; Wed,  8 Jul 2026 10:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E424F6B00B2; Wed,  8 Jul 2026 10:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58326B00B4; Wed,  8 Jul 2026 10:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC0186B00A7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:17:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0752D120185
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:17:58 +0000 (UTC)
X-FDA: 84965813478.29.9DBBF39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51B41A0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:17:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=de04IjG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783520277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OP6bc8DQ9DDDlz+P8xeYExBeg/4G+KzWHPg6szTAAo=;
	b=8hIwOog35QVRkXL0YB4qKVl+bcPQ3EKROgChqjNBtN0kSim3rVj6Gx+IxezGMK5whxas1K
	KaugsdQx2Vk6e5hV9jPmyFruZNA0XL2SYdm3HS9G83aJLO2mpWFP957xIA7VLMrpsc0KzC
	CN6kyLOQ9zw50ffJEq7BXIJwNYSpJ3g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=de04IjG4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783520277;
	b=wjRfNfQX1mmQnADmkXD/nB6z52alObIuH8wA4ULefXcTwgMhbkKQI91Dzu20adT/5PA0Iu
	P8K+vgVLrR4gVN5b5U54QEBs/lsTkIyrgHV7YuOWloGeAF2oul4+1eBo8hoLeirU+HGn8v
	20p3uf3NWaBBj/CZ6oxx7EL3+eM7YDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCB3160008;
	Wed,  8 Jul 2026 14:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3941F000E9;
	Wed,  8 Jul 2026 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783520276;
	bh=1OP6bc8DQ9DDDlz+P8xeYExBeg/4G+KzWHPg6szTAAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=de04IjG4Xx46+ArvvwANYil2mUNeiRFbbhuKTp4TBhPk4HKRD5JCrXiqkrmykskzl
	 hBpLKalv1o6WS4fBC7uGI0V7jdsNnUJQKqEZ3XJvUyvK47stsjk7XifPP/QR+SnSSZ
	 +19nQs4SInhSGSO744AHWnfbPH69nXSHIj/hrtkOCWkAmwN8jYdjSJ0t+I3S/VQCdz
	 rFhTiuYU0RqXrJZSQlk8aIfX2Xg46OsDDOoVLNLGKepQ93NVRQXxK/etVIUFxQOr2L
	 v2Ea69VvIAtYSmMl42SfN/NGN9OP9nxps2Iu+1uM3XI0S7aViKvItCEuT7/jMJsUX7
	 uA2OV9E2IBGQA==
From: SJ Park <sj@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/sysfs-schemes: fix tried_regions setup failure cleanup
Date: Wed,  8 Jul 2026 07:17:46 -0700
Message-ID: <20260708141747.123596-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708080107.727043-1-lgs201920130244@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4ybhgyko4tqa9stm4p8w7u54aeprzoc
X-Rspamd-Queue-Id: 51B41A0002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783520277-36436
X-HE-Meta: U2FsdGVkX1/b0sKfOz9/OCYtkIPmm+KmN1xuZQwdhHzwPcYKO7Eqjhd/ZrSbCvqeymY9cu1nW8ZH3iQ3Zq+Jn1zTeFWK+pTt0c1IB9hVDWNA17iQ3zC4BomT5bmYaS+tcazivkLVvIcNtgtHMnnx6ri3rNIdAkkOxIgon3sPVcKsCxZil0XdFP/Cor9PpHqen0HWI5BR5WVqld9yio0jud6wW8U0YwXi5nhAQx4cKEVeKY0GlNeTBFSRjiybio3q/ishf5Wvo5pgPKWCx4JM0q4mly0p8CIGfd/B86sJktnGq1ZdrhzQ05GG8HPEZ7eOwPQL9p9nLSsHxdf+GZVmGVkSV2LC9oTTjTp+GauSAgb6LRWDCmPPLSewzpz5QALGzm89X5416iCU/R8288Eej/nxI6IjITYbeS1lqRfUmwG03FWTmuXhQVVm1sPyN2UFV0K0Z6se1ovYp0S+RSF8fSbu4/vCDs1VJyCW5mT5Qa4148B841omlETft4oI6b5OdNVDuZ99pr08o5llN0MuFplP/oKx0ziF9AuuOYYTj72l0xkMG7yutQXSNcVQTS/WWOJmKIuWTDqgyM8+dzAEoEnqsOWt3JvmPmL0nlouUqa9iRBr3nI23TYboo8M4uQkBhxMCCwWNjo2VN/1voKIwoXzKvu4A1Hmb0VQULykkEvE8O6paGsYGJQ/bkSAjNQwDbVsdVuX6GcwuF+fNQ+AzCQ9po148OhU+DEC+VgooqR2K5h6zeDohUKGNYw20XfMlG+WbD56R5QxWXTyyoKwUK+Yh4nSfgaReu/vR1yyimmqVefBXAElFfWRifpoJaTGJdZcyhptFzAXha0276tR4nEZ57ZzoEZqYCAfad2iB6aHN4OM+cnOEAN/gB56RvMkdmQTTNu/O+wINfV1pnoYY1+fd0WEhVVG9mPf7kz0eyvu4NLAVnRCRtqMkhZGJ/TC7kZeL1u99C+JHDHM2k4
 KH9+QucT
 Og+75e1CkYf7YbjUTSvT7DTDAZpKQktO7zP4RCcxcYWh1GFfA3h+HSsE8kFs5u7/iiwXJwchvm4z17g08YBwzNoFF/3NqzjUEIiDAXwnslDpPtdHtrBuRUQ2/6sjBFZLGtzIgEmkw9PbY0vC5a9ET6YzRBMalhhQr3+iNWY+hCCN75BkfD+J3Fn3etOApBXFE2VM6O1MiIKvkIQVJ8Medn74xk+x1IzYs4HYsxRwWDElpRQlXyOD8iMGEWv69wWNyslisNdMEy8W/ulGv2Ka1x3cGxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Guangshuo,

On Wed,  8 Jul 2026 16:01:07 +0800 Guangshuo Li <lgs201920130244@gmail.com> wrote:

> damon_sysfs_scheme_add_dirs() sets up the tried_regions directory after
> the stats directory has already been created.
> 
> If damon_sysfs_scheme_set_tried_regions() fails, scheme->tried_regions
> has not been assigned. The error path nevertheless jumps to
> put_tried_regions_out and dereferences scheme->tried_regions while
> trying to put its kobject.
> 
> This can dereference uninitialized memory because struct
> damon_sysfs_scheme is allocated with kmalloc-style allocation and
> scheme->tried_regions is only assigned after tried_regions setup
> succeeds.
> 
> On tried_regions setup failure, start cleanup from the last successfully
> created directory, stats, instead of trying to put tried_regions.

Thank you for this patch!  However, it seems a same fix is already merged into
the mainline as commit 05ea83ee88ca ("mm/damon/sysfs-schemes: put stats for
scheme_add_dirs() internal error").

So, unfortunately we will not be able to merge this patch.


Thanks,
SJ

[...]

