Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721FEC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF7D6B00E2; Tue, 28 Jul 2026 20:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE366B00E3; Tue, 28 Jul 2026 20:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEEA6B00E4; Tue, 28 Jul 2026 20:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29BD26B00E2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:50:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B9814058D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:50:53 +0000 (UTC)
X-FDA: 85039984386.24.3AD3141
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30EF840004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xr9h2++r;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785286252;
	b=c35IeFsmoSVUA/uZaaa7nuebPyfgdrLE6PdaWDoG0aZueltVbFqp5VHqUU5JZqMDQLmu7W
	WbGMDkneU3vUwt+QnwH4iISZCvaHc+EoVBOx8mB2ekUjImPrENCE2Vkubj1IA7DsTnx2uv
	DNPMm4lF82R6o/RtLHGuVR6GIjeDx28=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xr9h2++r;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785286252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic9L3BJoSROKa6Eya4cGtNIhuOcX34TSYVnxCMS4B9o=;
	b=Q1Sny7cDwNH46dzHPNHZqCtkApQFEmJCTPc/9RK5fK2yaNUqG9qtSmZD1YMjM+55BEQf2o
	NGrR43F27w1v1YFuxyBSDsQxBpc7RwK5qEmDjeKTpvTXA/IutuMjaavIIUrHuawcIGUE3S
	UN942tsDhQfeizWACbYXD81xLxJaxA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FC2460A61;
	Wed, 29 Jul 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671541F000E9;
	Wed, 29 Jul 2026 00:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785286251;
	bh=ic9L3BJoSROKa6Eya4cGtNIhuOcX34TSYVnxCMS4B9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr9h2++raMozjYdGXpFqN2gCSk96HdB3ot+KlijzrEGE42ZRLqDPiC+Pz1uTR8aka
	 +DTFtoD1Hj0Oo3slfFTxuJzgkIb7voJ/yvJ88Bku6Yy9jMxdoSSIt1cmwKUAkTZ9IT
	 z9niXhL88bcEoTgvlXWvrrm5ww7iGF+VauPtECwfKTcjdGn6dBwbIZvpBhjXTFKf23
	 1QCY77D4xbkGX305jAD//bJuZ+957FEQMXXHnCHfdJkhQPCNVAl5G8p4iJWGv0TQou
	 GsBmGGPCIi8tQhlDHb9Vv0QN5hqJS/xL6xodafApcD5J95vcYXjtLwWNYcftKh4KVM
	 2lGi2pj8YVrvw==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in damon_get_folio()
Date: Tue, 28 Jul 2026 17:50:36 -0700
Message-ID: <20260729005036.98063-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728194714.3713735-2-gourry@gourry.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30EF840004
X-Stat-Signature: wzir8ggd6c9nmteku5m76rnzij4a3e7a
X-Rspam-User: 
X-HE-Tag: 1785286251-663784
X-HE-Meta: U2FsdGVkX18EhpwSHGxyNdQ2+1gY6Gu45mhNOfdKPK31l0yXMKe6+YdSZ6xjQk2/rE+ld7+LCdY4MOS55ue2CBFrb9l6zTRSMnzGNQKs2YGsFSUsDVWYZkRPpoe/bWpmjNddehReYR9ybAidAUy+KrJ09Okbrup1OM0bMju/m5Okme43WOT75EQ0t7mevJgH0LTSG73nQ8/Eoi/mNbWrBN+7tK4sKdFLTKvL5c2RitPZlX/LwR4fieMPuN4cmnyRdbX+1qG6BDasHVtXXIEt2WK4/QnK22eNz8TfL68hAJbFBQvv6dME9ePeNS0Zf0gcZYSER4ZVO8xNpZpxIBerBi9MSBhMcLgccWAxargv9Ri+UbaXwQzwtN/mMEE/TJJ3Fq85BD2D/UpVJEpnu5EGcLnIYPRcjW0WhaIegv45qe3qdfsnWgo0wANCDe/lQLmyghRfdMh4r87xfcx1AFyxaLT/Cld37XvzQdXJqJOFMCtH/Q6OIItR9+grnUGvBE7HLvv4Imz6tb0J8n04DzC3Od4Aol1ulNPxaDRyM7kErfDaKjlvHr9CSkQjglH/PFGMx4QjSx4he750+Hvvuvgnb98feXIOvFl8LeS1+epiP9y4PJYfVgi+lDhl1rJJBScBNUqquK48iWFb/OgZMFtCRQM9ihuLhLmqkT3AOCL+XrUjFCAMkKcZi/78ZuVwTAhpQZX8RCmVv9V0qP3FKqSO/9tzHQ4b3YFJMJarlIhxFvtyBvAUX1KhPj+Tbcx2bCSgrRrCNpXI0i8rW1YtAu02d5EOWc9ztPdCRBZ6bFWZw/dxNbPsSLrQn+SeszIbnqlnOm8akdnCceoKgsaylRnTsEjmpGne9RQXVLCPv4ijatnS4rkVmPOqioIpbzEdGE/ikzQl6Z5/0frJW9oo3v9G1j6WkGrbOt64+gKSg0NMiifuZt1oXGTbeuzYmnYsE2HVhUvHD7u6+zezsXu7uLX
 ZeGY0M4r
 v6H1lt/2P6KSAUaWfQj4+FnwEyxluJwhRMZBthJMwA62H5IR/xd2GFTIasnIL4EM7Sv2XxJX1BLACbReiEhRvBNYWoLHW48KCgy5RoixRTbIWfhlWLv1482QunQCtpTFVOgww+0C4HATbMy81PF6gm8IMueC9osxl7w84uSei5cANzxy28eVXhuWfc9qsNG9FORRngFMgm9AaDt6ZwpNsgeJ2WRT5oytKHTF9fpeaGC4tm7FR0mZMrxHK3haQ6sWjrHDx/0vfR7Pf4qOKnd9hYKQptZ46zwsEGJ+yv6OJ3N0Dnh51weDMiYEbuIoDjncDuEmOAzYM5s1i0ZW+sqtu45O2JFmtqGcNFdjG7QjCaSH17oEGB6+rEkBt5rIxgPR90pY3cQvTUxtQzMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,


On Tue, 28 Jul 2026 15:47:11 -0400 Gregory Price <gourry@gourry.net> wrote:

> All DAMON physical- and virtual-address operations obtain their folios
> through damon_get_folio(). That helper already excludes ZONE_DEVICE
> memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> this is inconsistent with other callers in mm/ which test explicitly.
> 
> Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> so the guarantee lives in one place and covers every caller uniformly,
> consistent with other mm walkers that reject zone device folios.

Thank you for checking this and sharing this nice patch!

However, I'm not very sure adding a call that not really required for only
making it looks consistent with others is the right choice.  I'm especially
concerned if this will confuse future readers including myself.

If this is a hardening purpose, we have CONFIG_DAMON_DEBUG_SANITY for the
purpose.  What about using it with a good comment explaining why we doing that?


Thanks,
SJ

[...]

