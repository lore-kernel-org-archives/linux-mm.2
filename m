Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09AD0C79F9E
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 00:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0001D6B008A; Tue,  8 Sep 2026 20:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2916B008C; Tue,  8 Sep 2026 20:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F336B0092; Tue,  8 Sep 2026 20:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC48E6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:45:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04DAA806BE
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:45:32 +0000 (UTC)
X-FDA: 85192380546.04.7BE423D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63E8FC0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:45:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRMTXI5L;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788914731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNopAaAzl4l7FgpL2NX3Esneyi/PfV8GDqKzg7A+eWw=;
	b=wbGJ4qPO8r83CphNRj283GHOQ8qoVfTC/p6wupF3JwUBq2KGN0kCQtG91noia3oMbtQD7l
	T1lzcOYnjFgBngKOWUmMJIfy8hMoWjOzaK6eEhoZyjlvmoMYV+1emFmNNDawmKhC1UjsPc
	juFSJYwvg4i/YQnot0cU8BanFEoVXtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788914731;
	b=gCRQqMq5LXvRJvQVHkqJ5IpLvJ4cQV/gutBFPdSM9Dz0s9vJBDH1QLS6e9DVoJfYGPfv98
	esymaPaDVH+d8bU2GClyA8om/YEpj/CnddKgC7tg5W3m9IRwVZcOdlz++8s+hc5HP/ACUR
	0QkmQx+/VMeJJjgAFG7MbL/7WxtVBCs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRMTXI5L;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3FE9601FB;
	Wed,  9 Sep 2026 00:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540891F00A3A;
	Wed,  9 Sep 2026 00:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788914730;
	bh=ZNopAaAzl4l7FgpL2NX3Esneyi/PfV8GDqKzg7A+eWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRMTXI5LTdLH8UBQUVL75Ne4wsGyyqbLlOWfIZh8O5U92WQbxbNUZ0tyc9cMVwhj8
	 4C9Yt1aAExJ2jT+xMlwTtu24XMlk07ApGbQ3LXvjfjeppJuT+9iBJvrx4snpx3QR1k
	 20hZHkLkCl20E9nF/dFDNVyuVimE+CGV8bhjVFsbnxmJJ53XrlT9tFfuf5Mp/5Yy9o
	 w1klF/NP7eKnJOFW4VLKEgnxmWJZAweD7BKR8oX+Z8GasMv8Sr9Ci6AkK/lErrRbuO
	 kfftRhUZGaHSzN8mSs7LRZOTAv0Oz2tflAz6ylMd8ky9ERtu+pH9BnYhbgY6Pril96
	 OEigpzFjTAHTg==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH] selftests/damon: ignore test-generated damon_dump_output
Date: Tue,  8 Sep 2026 17:45:22 -0700
Message-ID: <20260909004523.112863-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908162716.85648-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qhtisxob4szxnkuwzt45y8orjjuuyor1
X-Rspamd-Queue-Id: 63E8FC0002
X-HE-Tag: 1788914731-535062
X-HE-Meta: U2FsdGVkX19bxh2YNzG6t37m/xuPj5Pk2dbhalhiw+6I+y2RHom4e0HqzSVbLsG8pqmmRw6pFAFRCs08raG3KCOEw3vE8DN8bcw0EMwhCn02jbG2EjcAf00CGTKSfdGeB47aNAPsqhwHNd5hk+BKdwUJv/9e9gopX88ZI6Wo8t/Ch/Ube/dvpNHGeYLi8TUpjeks+g6n3r/UeS2hGjU3SH0jgnqkGUmGWUAiBMWBaojeRnLLtMkKScFMQmCczMK+I6twmSVaVyCw8Riw7uPB9pKdRoRElFymp9vgm5BsiziDx+WoeqDTP6zvLAAH4LIZOF8GAfNO1/CRMDQyFE03yOxkC8IGMoZgpkT9jpt9YK6etOCO0wA4hIpzZYp8cwU6stpy/PW1DM+jLAX/3Kpk8erGJ4MkUVmJgi0CAO5Cq1mSwWnIq5tWYrRsTVbN0KMdjXmz7w3mI+c7Igvlety/6LLG/Ju399fyNz5Rsl3KxbHReJq2cQvtWnOh73cWx/FlAolfXcFdmcv/OYT8m4lPAxIrehdGyFdiwNndwiMYZ8pI/RDZvzv4x0kUuMI7qMIixfa24UDaBBlZQpPzeo/HZju+oBXoryxld2gsWWIQ8qzsCfGFr1rysPArurTree5covXuQgFsKhzAR+2a5+5LJ514mzIFLEQlGZML9NR+1M0aAzXhoOiJnKH0ITuyCvTE+24jEsY5ODddQKLxG5+mhA43/RHJl7r47Z/cVuksCuT8Sy24qmyPmZ8gUsHLQbWJ9+Q/VdmgpV3o0I9GeqfPGWUCj5jujW+4zYZ+frBvNuk/nxrTFEmiTLG/oBcJkbpqJjLpnT++K1i74dI0Lp4tQIx/aKxcaSVMirh9sfe+gN94FrbdbXvPVfW01/DQeePNsje1wbDVcari/RHaSZXQCYSozGfZtEX/lpVjdeGb/zF7XS2vLEVfgUXfCXvHuiO6kwSusgolT4sa431YUik
 eXZnIcd7
 ckzUG1OGUWXwovjpQY3Jw0kEd/FgkKGJLy8xufHUeU9aJTx2F2fRncSFrf/73SiE19PBCnzeltYGGvAXdV887phCW0bbj/2vwpz7zs3rg845wKuoMdE2enCii1JOLDkVLl3/Hn2R4oDYcGsy12dlPRMiLuarcF7dEEjUffWlCX154I4sxlOP1QZxB57JEHpPE4YFI3E+dWgKKXQh3PiEISj8JY/HjQird+IxuKo5CkUgJatf+w+FynflCE4g9lHPZ4ZcpocrqHCqNHI02wAPYx5gzC1Ued3BlC1Hx0Q3pSwl4IXDryvvsJ83FnnK8UntwjBvoBQxGmOQzaWBhkG7xMdrv8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 00:27:16 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> sysfs.py and sysfs_no_op_commit_break.py dump the DAMON status collected
> via drgn_dump_damon_status.py into a damon_dump_output file in the working
> directory.  Ignore it so that running the tests in-tree does not pollute
> git status.

Nice catch!  Thank you for finding and fixing this!

> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

