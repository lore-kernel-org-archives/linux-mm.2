Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408C6606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P3SRir8W
Received: by kanga.kvack.org (Postfix)
	id 48AEC6B05B8; Sun, 25 Oct 2026 22:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43BD26B05B9; Sun, 25 Oct 2026 22:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378C16B05BA; Sun, 25 Oct 2026 22:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 079BE6B05B8
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:58:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87220140500
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:58:02 +0000 (UTC)
X-FDA: 85363268004.03.7CCBD3D
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F43F80003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:57:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P3SRir8W;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M/3vq7XpKzMqLSjMclXqdhAjifEnbo76yvSfWikbsc=;
	b=VdUD2zXnn/iygk5Yl2SHKampXUjPWNdXub5k23/WKGy3BpfUKWPsJ+GWYNU9aJ9ujgqXfH
	Bt/ShsPWDMCS0DPs9JRIuruhIjp4+TxK3BNEizVMsKKqXJNJqbVyBdSocTSqPob1w2lka3
	E1GFVHi0+earCF7KbyapmUhh1Hjo+IA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P3SRir8W;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792983480;
	b=cP8koKF79QO6p3MV/1m5b/dGnJxgbIm5e5uYnS2c5rjyjexTjqtQ69Ejf2mQ+4C3b0TEn/
	W32P9hsknXusKPKRShEn5te29M9jYwQs1pohbmNilje54dcDvhQj2Ol8rSLsIoLOIiI/5R
	p/q6uYwOdjme4U9pICi3bIcHH/gHrwk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792983477; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=8M/3vq7XpKzMqLSjMclXqdhAjifEnbo76yvSfWikbsc=;
	b=P3SRir8WmnxRe6H7KVhK8b1z3EO8un5dP6rKqgJLnXajWWayMXhTLq/s6/H6z61zCaqZCwitJAvlVQeo8y4Bl8Bo8Hcy3zDxGqc05uLKHsIE1SvV4pjj1eGYSn03ubAkU8ypdzG3BPAzmcy26ZIA7y8H4/D8JroVz+Z5nrsLb3E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDRaNKg_1792983468;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRaNKg_1792983468 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:57:56 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: david@kernel.org,
	kaitao.cheng@linux.dev
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned pages
Date: Mon, 26 Oct 2026 10:57:47 +0800
Message-ID: <20261026025747.1432066-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <58cfeba3-a3c0-426e-ba97-8f82da5b1e8d@linux.dev>
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com> <20260928105805.1215770-2-xiangzao@linux.alibaba.com> <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org> <20260929034123.2705745-1-xiangzao@linux.alibaba.com> <331b4e40-8d0c-4333-b2b6-b81e4c4b2e17@linux.dev> <877bjowf9i.fsf@DESKTOP-5N7EMDA> <20261020071600.3695395-1-xiangzao@linux.alibaba.com> <95a5ab94-5d91-4a01-a417-19f27aa91b54@kernel.org> <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev> <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org> <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev> <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org> <49966df8-c092-40de-a05a-ff6d69382dd4@linux.dev> <e4c3ce3a-c19b-418a-a92e-40e077f1ea63@kernel.org> <58cfeba3-a3c0-426e-ba97-8f82da5b1e8d@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F43F80003
X-Stat-Signature: uwcow5g85yekfuxrfi4tkirfa9kz7f3u
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792983479-318010
X-HE-Meta: U2FsdGVkX19Um5PJlTu9WxWxn1afWnytT28LdQdUNTeEWe6Mn8RPXYuhtRy+B+Sz6HEtaGg/by/OO3g34TGBhBXLbPd76ASld7NKq+hEb82BL7igcteZFDZDKLdSsz6RtBwtPwuRO6rBrjlHm1QUK+UTOtLwkrOsl+WzlVfmNuoF8X5UPtvD2SsGOiGLiD0oRj3pbJlm7UxAg9ddfxpOvFqJ7fA+bDqYsVDQ1RDdtNnr4NxU8feAppSYpkkPVfyP7AVIyeHQmCMHuYBYJZRSLMAk65JNiCqgnLH7cCTF5zMctdVxZeAGJX27RQ4DnbEiqhaBxbL2N/Uq6tPeT+ZqEgGyfbXmQ1DYinfxj1mpbKFO6mE4tgCgUeQQNfXbwGMeOP8DfSUR9mbXFtNIx0dLX2Y4Z88pnFqMUAbLdJVDEYr/uGdb18Bv0y/AOF4DeSNjY3E0+4gLII6lt3ARW5WIBTNKBeEge9Y202G/Ip2a+J4oUwVXXo3xfVlSIo5w+5F0qzrmZyVdnsEJX3sAeya4GuFWsWUzlkcItBZ6TWiOnQPG6tGtPXUzrgXR8gQAtwlzeQtgb9PHx35c+NdpTLk1TkJTDXdUWBRFGsnFK0nFPPkJhfH6hX+7lkUH8x9KBH16Vx4rWywx9yK8Bmvcq7KuzIMlsSB1lGK/XsdQwzkymLMNXTdW4p+MvZo+XZq/cKHT9YCG/z1EaOPn3Sjy66sWhy1PpfWx3WWVD+xezJN6vAY58QRgyPlLZOFsKwwQXjjI0qhR0azDdc2NRTPOI2VUaMOYSEwXk6mEKnhtIRQSQQUnpQDDx+c/GKc22+bRXVM6MgRxt8HosyG+Yv+eLO9SwPveA8SiyA8gN7E8pOevWa9sxvkJh6Qg5nFraAwwyAZjIBTw3A5T90xAb+b9tJ/u+Hw5Zo5FCpftsTBlB6pjEm716/jYOIAugc1oTY4LCYkX+d8X29RyFTHm1qD9tTN
 FK46p5ob
 m336kHAYMPJXgNb6C/4KVNMMXtvRkpphlfgCijCzYQ2mFLZCdengPk60BIIgMtD4MwcK4J3dsErrbdPNC5/DkSkCoJEeHNA21XFDdnpBrmzquKOvNNd4/fFNFWtbLAt4LBwzKWhSqT9WuVHa/6kUc51ttnYXjtwYioqA6mClbLerGo4lhdJnogcbecUexJznNmpj3cv5qTcb6z+4EJzO0TOJbizvwz6njZqzEQ8ammNASvacQR58mbVUvirUPwKiX1TPyIMcU4Q1NFWiMUGm2tL5Bg6MVOkdn0dpGWMY7ee8Fu8EzLHD+cgYBmdjmzKu/lW9MRHbCcEKmSHuKKpkTohrT9Gnx1HYYnrVfXyI2Uhh1O7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 20:39, Kaitao Cheng wrote:
> Here are a few subtle corner cases I came up with. They may be
> extremely unlikely to occur.

Both cases set the flag while the memcpy still succeeds - that is
the "how this makes sense" for checking after the copy: a check
before it misses them, the recheck after it catches both, and the
refusal is the same either way (the data is still good in case A,
already bad in case B).  What no flag check, before or after, can
catch is corruption whose hardware report lands after the last
check; that needs architecture support, as David noted.

The migration paths spell out the same placement and races in v2
(patch 2, just posted), and the fallback patch ("mm/highmem: refuse
to copy hwpoisoned folios in the !copy_mc fallbacks") is posted as
well, with the races in its changelog.

-- 
Yuanhe

