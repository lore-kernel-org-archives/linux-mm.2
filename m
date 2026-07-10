Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AEDC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F82E6B00B0; Fri, 10 Jul 2026 10:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEF36B00B1; Fri, 10 Jul 2026 10:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6136B00B2; Fri, 10 Jul 2026 10:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFDA16B00B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:28:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E7E7120443
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:28:24 +0000 (UTC)
X-FDA: 84973097328.14.CCC690A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C086440005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:28:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBbBiWxe;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693702;
	b=N+o/s9xUmrGZoyjkIQlRfZsmZ581jqTDac+I9Ck065/gmTgJU8886GsBC7/f8RCfIqD/pD
	vF4DHBu8ZovK26WCJR8VvlTm2xWuJBZsoe06w1vDA6KCgsxnVbcqEmvYpPNOatrcncB+R5
	FbdC6OcYi7H+NFwbE8q0NivVRW4GVNo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iBbBiWxe;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulN4+TCdNRof1oArK+ARWol5k9fS9quVru4deTo15LQ=;
	b=xdrcBOB+3Md7nph1LPtgu7iullEeg9gxKyiSDORfqc5snmsY207C/h6xlex6tUqRFtjWJt
	+n38wgOhkMgHz4DEtkpqbHmDAduTOsZTMR+hoxe3H/m1J38bf7bTGVMy1LyqLxw4LlNxcS
	qv9YvUHPpFhUfha53ZCLVNsrMdkb03Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF65641A17;
	Fri, 10 Jul 2026 14:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEBC1F000E9;
	Fri, 10 Jul 2026 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783693701;
	bh=ulN4+TCdNRof1oArK+ARWol5k9fS9quVru4deTo15LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBbBiWxeFbpLQIUcTJxY0uAeybSbPWM7G4qbFJjj79p0itLYqGYwSSlPVc2+eJwBK
	 VNoZ/DnTCuJ0ful/dnuuDwqQuhJwX8QFKvArNnEfqem5dSLi0PT/SLyCyr9DTOsH/n
	 iVDKaBNI5Nxd8bQtrgs39I1JksQcPy/33tSvv9PMvbG0WCooCsHRBmGf+LEDbROchG
	 yaEovQmYUBxE3tPrjC5glPrWr/YO/GUQaraCTwvX8ca9/iaZv+qA/Tr4MabSRxByqe
	 7ijkeZUmqAd8WMiUbqx6vgGaKiVBO0Q+Cje6CBbW50H7Mn+Z5RzcDSkOfkFE8JQ7Fg
	 XZlyQdEkJLkYg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Song Hu <husong@kylinos.cn>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 0/4] Docs/ABI/damon: sysfs ABI document fixes and additions
Date: Fri, 10 Jul 2026 07:28:12 -0700
Message-ID: <20260710142812.25332-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710141631.24657-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C086440005
X-Stat-Signature: imhu7cozxbz4c63ohdnrq17a37zr915j
X-HE-Tag: 1783693702-737454
X-HE-Meta: U2FsdGVkX1+TLhQfc/s9Y0SEuGOHN3XSd+JBYKSPPKYjFPFbnJRUBP+f6fzBzbCp/5KRktjdkHSJxHrKxZl9PkSuPPvBaTf8hbdXVKvO073vkpBwcBbU0tw2G7hoHf8V7ULvjq54035swBAv44rD0+fKUdOI6PbkA8jRRfAWFqv9zXf5DQo7RzOYE4eMH/0msWxQJguWGOMfK9rRu6hdqEpG7xQTtTpnAfBHCAKrpe5bupl3AydjuOXhvwHdJRPf1IWV4ejosE1NxGyeGInXGM95C54Pqnjg2o7GlokXqbf3RGag3ke4d3khDWiNNrMtuVr0upaqlWY6gCLKx/feZnLM04NQkf93u55bqfKyVN9vP8AZDdDHdTJF1s6Dz/5HCOf99WzzC1NYG2ioYt4EJn77NlA8+FU891wrsERqySqyDgXVDJ2Mn8ZmPPJrYfDNEq8Vc8odB2bBGEf2caxIQ+TaoIZXt5e5O5fOMbsVuj2Sm9GVaItvt/Gur2QA8Hr3SvDyy0VJfeAb9CLlwtRAznJhDlsYZIxoimawR4oWW+Ef7gzu4RAqu8ixI0Fxn+ljU4N0tzGv7JfamzyJhZPbNLIstNHwJM3n30ZbrnhFQuio4loHsNekAW/m0A2NcOhHlL8fWv2BnXEz2pGYzKSdwcpIMbtRoUFT4AzWDvCosGW/cf3knhPGCDCuxQht/AOc0SGJi/sF9n9Q8Du7c5AM0jXIxLRK8Of3Nl8sPtjiNbC+4LCp4CgU/xms/CxcaRAbN1Sg2MMl8FC7clVtFbOraZ6CR0SYuyA+Odt7e0Ncsehpv/SE+oMDW1UyRBBDGz4qXeW9ytvC6/Ngy+yza7BExeyU40rDJQqU1/5Uot7kLTBEgoy+DwjJDUiNt6aCGLS4/pxEQDf/QELezgbGEmc5yEJpfbrLq6iCXBSGsJuLK1KtryF7kSnCvZuM4v4EWJS2gB49cTfXugA7fRhMXUO
 0H1bOEaN
 TtoZosBAhwszYLO4RR+Gvmbrio+VovcjzEuNIrDPeBdvtuzgVrO32WIF3xP2+O5CwpkQt+Y9G/LzbivptZXhDzCdqB6SXB/92wGlQmYhEpVrsHg+94f3JcM4kpzx6Gf2Ak2gw077yX/QilvBkr35zC7pdCvnT8g2DR8lwXLvKGQK9ZVsqTfISY6ztmUv/Yk7xRMx8/4BIWTUGIGQRlqzPZ5vnswE8OiOrJTTY4zUDtQnFGftySnQjQ7vHZgEMMI8In9XT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 07:16:38 -0700 SJ Park <sj@kernel.org> wrote:

[...]
> On Fri, 10 Jul 2026 12:47:33 +0800 Song Hu <husong@kylinos.cn> wrote:
> 
> > This series fixes typos and fills in missing entries in the DAMON
> > sysfs ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).
> > 
> > Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in
> > four What: entries; the documented path points to a non-existent
> > directory, so it is Cc'ed to stable.
> > 
> > Patch 2 fixes two further typos ("WDate:", "manimum").
> > 
> > Patches 3 and 4 add ABI entries that exist in the kernel and are
> > already described in usage.rst but are missing from the canonical ABI
> > document: the 'update_tuned_intervals' state command (patch 3) and the
> > 'tried_regions/<R>/probes/<P>/hits' file (patch 4).
> 
> Looks good overall.  Patch 3 looks unnecessary, though.  Let me add comments to
> each patch.

Sorry, I was misreading patch 3.  All patches including the third one looks
good to me now.

This series is applied to damon/next [1] tree.  If this series is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

