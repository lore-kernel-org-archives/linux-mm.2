Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172F8CA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BD96B0088; Mon,  5 Oct 2026 05:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D9E6B008C; Mon,  5 Oct 2026 05:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33706B0092; Mon,  5 Oct 2026 05:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 711396B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:24:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32419C01A9
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:24:29 +0000 (UTC)
X-FDA: 85288037058.17.A01BBA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A4B1D4000A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:24:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCjJkLZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791192267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLr/rCkV16XHpH0zaj+dpRly0K1ghzdKwwNgfOS+UnA=;
	b=WU3T3YKDkahUGOWqvdK9W7suywzDad/vzycjC86/ZszjSqT9nGFDaFp/EO/5wtKQvyVvjC
	/aP7xWwL4Bg291CBKZvrn5JyMqFg4I9OFAzrs9bZonFy1auP1kfqv+oJYvhwlwQB4kiKD/
	1t/rgOwkjlxYRD/UbStW2zd260+NdTY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCjJkLZ9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791192267;
	b=fHcRkznaotY4r+CidllD+yFAFsXe99vAo2NVeuCXyeA6iFcIetsm3jF4bU46j2TDKwAf5X
	rddZMliL7lGjDHLa9U5z9iBEFoJKQd/bsWIJVQ1X8vfT+C9A8+WqoEs+eZuvfU0iyFxKbq
	87BhHW+N1oq8/MILYq4fu+Td17eRcRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F05EE60235;
	Mon,  5 Oct 2026 09:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226981F00893;
	Mon,  5 Oct 2026 09:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791192266;
	bh=FLr/rCkV16XHpH0zaj+dpRly0K1ghzdKwwNgfOS+UnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCjJkLZ9MXn7y0Lsm6P7HPnE6jkkE1f5lXCdIUzYOTPUQembvevd8akIlTMGiapSY
	 2FSjrunI6Oj8qT3+mehFInIrczhaWPZKFILKNCudyCsQm1wPaWK0r+7J5XNq/DnAyO
	 ZRoRM/iLOPoEb5KqFtSB92igYaCbhTjXFuIWJlz23oFMBIcL9rsGBAdgPAEvh01b5h
	 CT623cf+o9U2Uq9txVEymaV3BZQx5UhnCr8v64+PGzMyMqWJhVew/AYRrjyFbuh1uM
	 jBw9y/+ktLV03Zsnzi83HB9uQ9x5j/6K4D0Ugna5fswmKmxPKZVXcYPQhkOYNwXlXA
	 gx7VoC3XrVQTg==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Gregory Price <gourry@gourry.net>,
	David Rientjes <rientjes@google.com>,
	Wei Xu <weixugc@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Jonathan Cameron <jic23@kernel.org>
Subject: Re: [RFC PATCH v4 0/9] mm/damon: hardware-sampled access reports
Date: Mon,  5 Oct 2026 02:24:20 -0700
Message-ID: <20261005092420.43681-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h18daqdh7dg5jnrj3rbsahh1czo7144o
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4B1D4000A
X-HE-Tag: 1791192267-696580
X-HE-Meta: U2FsdGVkX19J4fZEY1Mg1/eojV8FX93MKiHX97vcV6IuSrzGjXg6EG3d1/ga4xZEVdxp8l5Hw3B9XWiiEDakqJTYeUD3TVm2qh5/rCTDN2spB/RFbXrJHHTps55uutkGNVnJZueYkOXlrwltHfJKnPlNg8QazoOM/jhSaKLD7wlmufjMPGjQz5+0AiJV8wgWxgwmNU8ryWbPjoRLjV0dgmdC5rFxT6a4UAkP81Se+3wOQTfuCzSgJCufw89MIZ3c//Wt6Y/1pbIUlBPkR1CLbcPahdq7+bfXARLkePeElKVKJCfeWaK35URNER77/4WWPo3zdFwKD/QX0BPsu10Xpryrz/II2i4KbE2bO8tQ8noa0cjWUkP+sgXkt0qHqgd4KHESsEOR259fiwQcRvugO4fMmz/Vj674U+kv5DLP1xuisUAmFJ8ewj41mp1jcXIeWwxqz1ZQ21G3Jrz6FDHg6baICzgcNSyqKJT3Xe6mvzmsHInnm053YQR0VNkJZRiWphYjBFTfJfBIoFmQ8s0ZcKKHinn8+lWv2ETDe4tEJTZ9muG91Ya8FhbmF2Y+KF/dAWuSY54VhxmsO4cZhcfK4egnpoXCnLq6OQ4PUZWgJ1ULCREIEJdYLlocLhWXLnxs/BnVOdrIgec/5osRMN8NvkzvzzNSgz8im7YEo8PLlWrkyWc5huP2oTSqCkySmMMtlnn26eqtUdIry2zHVHK1MVJ7UwT+rsNzFLqxXER7eM+7gzjJcUl6SJ3mI7sWKtTSAqw0+v7LfqVMgJZ2YyHL69ZbAjEQqBBL/lzUS2dkKgH5gtHs0E0fYYgPgv1iOh8MyyWscn2aRYvNRUMteXEhkHhM+/VwPvS286tSDoW+Qrmi0aUjBLPt7QCOL+ZQSqA7+8Bx6dEKyPPyYEPYcFVHGgor2Lhv2txxptG1Znq5QDcJVnyoSZg7iqIkVCxKfOgfLzgZP3OkwYR6SFD4y//
 4jEnujlm
 BctiAWbDQBhaQ6uaVH0S4joswjEMgbytn7kfO+8+3H13m8H+KzbuYL05YJzOnrBy8kv9Bah01HZIATvZ7aKxhz5uwOcwB8JjmVK/WJA0JSdEVP9ho5h3JzYHg20YPH0Mjjs6s/UvJMxr3+pMtAWfQ3d4ptteEFpTcNLFdfc1Aauw0/Bs7chKbkYYv6VbOm6OtxBi7xwfJ1vldzc3iqi/dYTmATBeCHw5rRWkh3/vM+Lyun46jaTE8NrVILY7bNb+LHQj9ESLH8q90qTlIzVb9BQ63gGXAzCboyuLX6dbB+e4myX0WJEPliN+DIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ravi,

On Mon, 05 Oct 2026 01:46:44 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series lets DAMON monitor a hardware-sampled data attribute -- the
> addresses a PMU saw accessed -- through the data attributes monitoring
> (probe) interface, and run DAMOS schemes on it in data attributes-only
> mode.  Patches 3, 5, and 6 are co-developed with Akinobu Mita, building
> on his earlier perf-event proposal [3].

Thank you for this series!  I'm in travel, so it would take time to review this
in depth, though.  Hopefully I will get get some bandwidth starting from next
week.  Feel free to send new versions meanwhile, if you think those are needed.
I will review the latest version when I get the bandwidth.


Thanks,
SJ

[...]

