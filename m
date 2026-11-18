Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90E1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OxS0Otyy
Received: by kanga.kvack.org (Postfix)
	id CEE116B05B1; Tue, 17 Nov 2026 21:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F686B05B4; Tue, 17 Nov 2026 21:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDBDC6B05B6; Tue, 17 Nov 2026 21:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFE96B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:07:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3907C0602
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:07:18 +0000 (UTC)
X-FDA: 85446602556.17.E671588
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 260EAA0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:07:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxS0Otyy;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967637;
	b=AT/nuO4OsSaWyKmlMKuULNhtQ916CRPIJh7muH28E2xhQgx4Y2lcx2R9FsNdao3n0OLNXq
	PU/HGJ9Q5pp4Ck7B0erWKp4S5qKwef9FYtOgkbr5xNZM6Eb8OJMIsNxZn4HljdPuRwWJgy
	+x/w1a8TbYwCGaHVgENJh1oEe14MNak=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxS0Otyy;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfJwYwm5e4vsMzXCNz9yx/bfvNCh4e6ZadaT7dtFFCc=;
	b=AuXZNViTKhKvoszh+AN6/WznMtZ2Kv8LNbSHiIAp4EZXIClnMzVw22/PlUcDtNbdHvlEOE
	wVgfh6WiUml2G7cWBT/k7at933o7iirwlifKLrlrzZvLITlMDLU7MtWscxGA+ZS8vnT97p
	wbQJ83sfe/wFBfjDZ89vBvewow0s1WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BC6545108;
	Wed, 18 Nov 2026 02:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9151F000C4;
	Wed, 18 Nov 2026 02:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967636;
	bh=SfJwYwm5e4vsMzXCNz9yx/bfvNCh4e6ZadaT7dtFFCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxS0OtyyAIerLsAhqGBRZ+KTdGsIkmq3EWg7V/diqU8vep8orjnhHHMpfi8HdS/e8
	 5CmV4owJrPu9fVMDWqrP3PXnFDuGAFxOaWbl9nbawe5aBx8OmbUcTRdGCuN+8szwLm
	 DzEqrqHJvaQSXYaDpZsKoIjy+ePZyuap0aQ1vEfQgM6F47xKF/ewaUbsZyqE56eT1o
	 sSZIdd8GUjB2BZqHlC4ABa4Wpfnx49lcjt5R3KAAiANpXhY/jtbLp+zRzJYnEaoAau
	 PpPfsxAlxmuqUWpmLp45IjLc1wrfkR2ugyBHxexfl7s/cEMqNpWaGj2HapQa9pzGe3
	 ou5Yf9OOHZUkA==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
Date: Tue, 17 Nov 2026 18:07:08 -0800
Message-ID: <20261118020709.97589-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 260EAA0002
X-Stat-Signature: jryf8neycjb961zccmwhn3z4ypzm74jy
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794967637-245711
X-HE-Meta: U2FsdGVkX1+EZ5AIcAYWXKoARNjkYtsRdd7ptIJWmdyFnyYiWmS+cJLngeOpSNVmD6rnc/qCfqVW3nw69k38S+V5roVpmpaufM7syVxjUpw2ELjNIuorJJblfa5JQvpKVyV3p8vmjYf0sH823ppnNUB2gBxeRgh4UTx+T/twDYKHP+i766Ov4qGcuGoFOvExEYr8BlQpAIJIHnDeQFSKTGb/uBfjT6+talhCaA42ZlodpH74lkHRxd1iM1CWac0WFkZGEhbONiN9wrZMbO3odEyy/0HuG/HqaY1HhLr7Ivp+t3N/BWANNet9Psj5AUawMIkzSygi76LpyMrKmydUm5Tb5dtnup4LxCXNANxFJbEt2qqCk8haOq+K6TSLX65mpYEz7SDzlbq8bicxFi/bqRCOxzKvp0kFNN7H0kr6bGUrJaE9oXlAvWq9nLvth3Phs132ZH6KX7iuGyJnQur/db+0xz9rcTcF3M2eE++Ulub83Y3p2zEpI/AVDqg1er4u2cUdpAPER9iDrOJwzL2IPIVjbt+pqHogk6S51GtnWVzQCPJr+GoH3K722CRqlwZoihv2GHqehnAaA2qHOGd9B2Ky3uARunJwi/AFS7PImpJt+npibUVfddnKSXG1KWbndXOQp0t8Nmu/EJ1XC7z9yY9wO5pK6QOjZ1gV7jdL9rKZhKb4Nsojm6upvCfPtfpBf7Oprq8Jdbagf+vz0NRn9eQk0HXEpkZ2tRALjiEVM/VpQUcEmRSWGnR3tWtgIW9Z4OkzWtCNi35MI1/1gO4ylv2MmOirF+aSsdIZ/0zSnlOTEKEB8gsCsAIB6Dz25/x9XRGuQbDjLiMvgPtrYbUQ+Wf89qFkN8GPYeDDeoybgCxfqb/h1XG/3dPdPqBSV4zAqLvL/2aZwjkcyK6HLdSRl4AUF2RtMaMtXGZlkNUPBEYSDj4jKNLBeTe6Qi8IEiyz4SVnjFyFRcRBN0iUM5I
 4KAAg4B8
 ObL/m9OeKNaSZcrlHhK9vu6vRjhGpwl5PrQcWMFO3oBZFsxz+FmHG/ZwEVwmIeV292owoqFHR2YBIKWlFDAVhS9F4RZcIHhsogIvSO2x3WVH7bYv2uilKNJBxCAemEgU8HtM+z9qkYJ21f0yAsrbYf8xlk/QvtmbU1pJ8mTTK2R3TDKE/j/pN5pxEmVGijheJpG++FRtBvJaEW2f3WrLIGEFBNWyCFFtKVuC6cpGy5Fn/Dvg0h4dH25QgEyHrFOtzH5ko4FFNi1UDzKpANOwvjSCZMrC+y3DUlyht4T6ASzwYYxryvN1ex9U6LtBoGxvVLxOpvpkkER9aoLlvVBeOB/BOyoEInWLh39qXxVxW+BeNdc9QzseQsGwP/d4r3HDfJ1cZZUImTnJeSBXZg6G3tAxdcT11f43z5/vbves4m1sEcpzmLiRA0F7uzeFaYOlGm4efcUPEf566vIFb72daBNMnuD4f3G3gVOLozcWrcEpmvI15pEWoPTDedpCWpZ/Kj4YB/A+Oz6gI7CqClEusj04gjXYhnUzgWIPus8BsQX7kAQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:14 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> DAMOS stat sz_ops_filter_passed shows the total bytes that passed
> operations layer-handled DAMOS filters, accumulated from the beginning
> of the scheme's execution.  Users who want the amount for only the
> latest apply interval, e.g., the size of a workload's anonymous memory
> that is cold as of now, have to keep the previous value in user space
> and compute the difference.  To know how many apply intervals a
> difference covers, they have to rely on nr_snapshots.  But nr_snapshots
> is increased once per target per apply interval, so the computation is
> complicated for contexts having multiple targets.
> 
> This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
> shows the amount of sz_ops_filter_passed increase in the last apply
> interval of the scheme.  It is updated at the end of each apply
> interval, and kept unchanged until the next apply interval is
> completed.  Like the other DAMOS stats, it is exposed under the stats/
> directory of the scheme in the DAMON sysfs interface, and refreshed
> together with the other stats when refresh_ms expires or
> update_schemes_stats is written.
[...]
> Changes in v2:
> - Patch 2: join the attribute declaration onto one line 
> - Patch 3: call damos_set_filters_default_reject() before adding the
>   scheme 
> - Patch 4: keep only the stats list bullet, dropping the explanation
>   that the stat is not accumulated 
> - Patch 5: wrap the stats line in the usage document
> - Link to v1: https://patch.msgid.link/20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com

Thank you for addressing all comments I added to v1.  However, you didn't
directly reply to the comments on the v1 thread.  That might confuse some
future readers.  From the next time, please make sure the previous version
thread is complete by replying to all comments and waiting sufficient time to
let any other chime in if they have opinions.

All patches in this version look good to me.

This series is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

