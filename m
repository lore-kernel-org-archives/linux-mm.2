Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A580AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8946B00E2; Tue, 30 Jun 2026 00:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0516B00E3; Tue, 30 Jun 2026 00:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDD46B00E4; Tue, 30 Jun 2026 00:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4EA6B00E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:53:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA3211C6A26
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:53:06 +0000 (UTC)
X-FDA: 84935359572.10.B5A5026
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 25F971C000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:53:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7IKbSNc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782795184;
	b=n2OSlfi7MNxaT7ehnuJASBb1Q/ANSYjZwvj9pBD8k1m2VUA5UwgL7Ds7gVByuNkE9o3Dw5
	tIr/lc0blb/gfh0h/E7UgBkH4GUZR5rAJFotgAcjiCGDd/TwKTESdNDW+TRqqKRxqQ8mI1
	cou1DFuIieOBpNr7lhtokkf4/yNg4xE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782795184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRlGgaXw16xjpf66bv4K2Iaac3zOrbbgMuETGo6XHPs=;
	b=rv78vkCnAKlcJiiI0MIbM5PbvqK1+vngAx+nlzUaEa7kKfom8Urb/TCPul7bYBy7uxP6q4
	2UgXVgEJgKoFWuArxc1An3aiCXFBq4g6aN7JsZHcMzszhQoZtvJSV+yzJYd3tRUMPQHZOm
	03svRLOhj/qJrmood9u1X7vDm1UPPVU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7IKbSNc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B0D760008;
	Tue, 30 Jun 2026 04:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06871F000E9;
	Tue, 30 Jun 2026 04:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782795183;
	bh=IRlGgaXw16xjpf66bv4K2Iaac3zOrbbgMuETGo6XHPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7IKbSNcE2lINdb5e83fU8zEFYINgOMzcqLv8dKyDmhIL6cI+MJnLZzTIbwkS8nB7
	 bdOBqyaPuD1vmUgg3YPeYx6i9RGW/RLP+vkbiDKcRCn/53YwK3joAhg+r0qQMh+UfZ
	 PbJGIjCE8M02HNTmrBJH3Nzzvl/hAaDQhKriC3GwRUgs0sdpU4Ygkz1icv6432Ui6g
	 f/WPHcaPOSjq3xrFjDflsyd7VqH71sHLepRdiP9uf97ita08y0gL9Mres7DDWBH1WC
	 /tal0Q1ppmov0ynQFZ+obmVWx2NOGQN+mgyJX3b+UOeg2m9MAPiBerrXp4fJ14Svbf
	 +Tr46LXADli4w==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] mm/damon: optimize out nr_accesses_bp
Date: Mon, 29 Jun 2026 21:52:53 -0700
Message-ID: <20260630045253.152505-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25F971C000A
X-Stat-Signature: gm5sf8rujhmaowmk4cfn35rw6sy78ewj
X-HE-Tag: 1782795184-488197
X-HE-Meta: U2FsdGVkX19u0ZV4VbWX5OBV9q7UhdSEwlk5OkGvUbV01115aIHOive74GUO/56i8GMy43KYwvXX1rpkwQszBdPLooFqT3/dCJB05DGYI2EvAriE5czFlVfO0SBsJ8mUV+V9Y5amuBs8LeP8WTIxCFil8rVJ1Fv+EBZYjcu8tVAQK9JeCHWZPfN4sS2o5xWk0HSUvwUQTriZRY0zle+aRhfMOaPTrv4Ezzaq/ReiV2l2TKCsO2WC8XnL8+t1XdT0aJCWSNesC3jiWf0WxvP8gPVnow5DhuSipuNJqDyBHYL8kji3CgTMSxR3WSUxGulaEW1dqzI0opA0LnBWZlhbSC8WQn7Cl+9DXwsLIDX6FoKgLdwK+6chdrkBlVBu5BafcRj9bzTAzLnuSAGCIvoYFHJcRJrAFzVlaApSahPC2jBeVaHmPM58sirHiXzhP7ErE5sNfNKgXaguTKYkC52TOiJPQenmuIav+gSNRPKS3xLFy550QWLSceXi9nhn/4rGNjBbRDZdyMTF9bXzMOMFUyi572s94Fkaxjt54pYTwmJERyfqN7xmZtz08ZvRV8MTp094mY+Dw0vKXla8w5bOEulEhWlXWRJasNr/lQkCzY+CvaUq8nQXV5aVDiI6W76mSN8VHaZRYWEssMMlUb3N2fUwQph2NmQXd/1XJ+oX2FZjb77/tGEBXJ8rMkhN8QYPWDflcAwX7hi1RJPv6Z/VgMsaix746lLl46zEvCzdMeVQ1UWiT5bNoOhpgnE9noq3ylK0P8GaaKENW41jWp/MKoWGyxGseBVytW9yJ6XuKoNrGfzoGi2FuEMcfsMezI92hfURn1zCYBzhq9mfe/TkZ9KcI/BidDQyOrfULGSdVthi0zfnEjpdPNBAkGlUmP8er5DCGAySa1aoe114AyRxGKBywljSyz9APnMplesn1XxTUb3CK1bBq8rrFW8XXdIkHp8Nq5s8NnJAeJleR2l
 Or7/+kC5
 U8QaQiVAlwPrHd3GjzI2sLbgA2C2fCpPQli+tpQpbjomHEe96JLYCLQ5Um7mygeDwsd0rgTIyv1QWngh5SbwCuwYDnHoW+c2xuXrTPvHhupefmVNEhQS0Mxuk30VnZksg8lU8lIDMlgEluedrikPRjdsJlS0ELZMJ1SbFDDmaxUpsCScz3PsPMDzJD+knySjfMsIZ9/XgKECi7z3kGxrPDJciOfoq1Ucz7MtvSCO1xkEmHuhF0gtwh6ZYGr9Gg6BtqlFLfpaezq4xeODARgVKSHaDbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 21:07:53 -0700 SJ Park <sj@kernel.org> wrote:

> TLDR: Replace damon_region->nr_accesses_bp, which is easy to be wrong,
> with a simpler on-demand moving sum function, damon_nr_accesses_mvsum().

Sashiko found no blocker for this series.  All Sashiko findings and my
responses can be found from the complete thread [1] at lore.kernel.org.

It found a typo in the commit message of patch 14, though.  I added the detail
about the typo as a reply [2] to the patch.  Andrew, could you please fix the
commit message when you pick it up?  If you prefer sending a new revision with
the fixup, pleae feel free to let me know.

[1] https://lore.kernel.org/20260630040812.149729-1-sj@kernel.org
[2] https://lore.kernel.org/20260630044859.152347-1-sj@kernel.org/

Thanks,
SJ

[...]

