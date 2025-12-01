Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0864CD116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 12:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244CF6B0012; Mon,  1 Dec 2025 07:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F55A6B0022; Mon,  1 Dec 2025 07:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5F96B0023; Mon,  1 Dec 2025 07:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7A306B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:01:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91DE6140178
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:01:17 +0000 (UTC)
X-FDA: 84170761794.07.9E95D5F
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id AA3BD180025
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:01:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764590475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BsodzE7kJXjS12+0T8EannKUoVfUWFT1FH+/E0ThAxg=;
	b=tFGhPRhEK3qt+RLscW4IOakTGSsVuDEcjio9PfvOv7VTTA2hFfHp4agSRgeHVUWyJLayt0
	iuRkFCSpGFX8crPNoHWN23gw+cu6fJ3m+OcCfiS0YNmgQ9pZWLncpk20ia4vTyC0Yws23w
	F44FY2gC1Z5SmaPYGIO9ek8KU9pZqQs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764590475; a=rsa-sha256;
	cv=none;
	b=uVIOye1CY9hfdU+V1R3zMI4v5933v34Vwe56MqPnmsaZk9rF3S5nfcdO8joM6hQmJecdlW
	zdys9jzcz4uM4j3DePTw1uCNeLOooRWv/8iblh1FHlaSJ8nli7RafSoK+dXwJIlqmNl42v
	iEmYAHx8i+EXNGiO3NaTWPTfl4CtWHo=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dKj9L5GZMzYn1v3;
	Mon,  1 Dec 2025 19:58:46 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Dec
 2025 20:01:09 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Dec
 2025 20:01:09 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <ryncsn@gmail.com>
CC: <21cnbao@gmail.com>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <axelrasmussen@google.com>, <corbet@lwn.net>,
	<david@redhat.com>, <hannes@cmpxchg.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@kernel.org>, <mhocko@suse.com>,
	<rppt@kernel.org>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tao.wangtao@honor.com>, <vbabka@suse.cz>, <wangzhen5@honor.com>,
	<wangzicheng@honor.com>, <weixugc@google.com>, <willy@infradead.org>,
	<yuanchu@google.com>, <zhengqi.arch@bytedance.com>, <zhongjinji@honor.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from debugfs to procfs
Date: Mon, 1 Dec 2025 20:01:05 +0800
Message-ID: <20251201120105.23338-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAMgjq7DOPMp3Eq9_SxmxNhY7S5--3uf0PByNAJOAEne9hb+T9Q@mail.gmail.com>
References: <CAMgjq7DOPMp3Eq9_SxmxNhY7S5--3uf0PByNAJOAEne9hb+T9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: AA3BD180025
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xoysnjwybsqbi3g5cu6hqe37wmapkssk
X-HE-Tag: 1764590474-572287
X-HE-Meta: U2FsdGVkX189iCeG64hvkhLE/n+iENgKMfkhK0fWZpWGU97cVZzPo/hDPM5mT0ky25H3z/r3SGEAKEh/Z2yTMiOr2wGUbn9PnM/4TNrvY55P2SNWdRBNo11Dw+1u9V5uwRwR2DYOGWX2atY4BZA9Xy6V64ENQNP0LF2nc45c7dEQasZKEhok2JLurMVG6S4rfBStGEergz35R6eOYOUiBCvIFyMaRqQxwBO1so6CMPtBcnYrD5aauK1+W2QnIenC2AVmVfYb5H0v4sWyOjj2mN8qoJM2ro24IGZZpJRIMrFfZRD2CE55g39w4D0GYe98xHkWbIGwrbvT/jNGqaOLm/qFEY3o2RMXY98/tPfZ0qzbmVJDJnXSeV8QtG1sA24ae86/LSD6oM5iVrM3/csy55YN+YV4CvhIK/5GUd95XePAooT55fXPnA4rH19hWPhjEOU4YUigkFKxrCSLiGI2WO7FxCzniaZUyMi0r3xuDfBcN4iyQQVlVoYJH6fO+s2H+AJ6sRt/8tuNEBaqyfifMGRMIWyJTUmVzzQra/++KvdaCUEyjKv5WMDKzS6sYRUhXYv07A+wmoODDJDFNubJpTgY9HJ0RjNAwqWg282g3mFxiyWUt7Fxa5F7DGaN8lunj/A+isiC1UpxVZ6nJicaZOvhFjRYsw0TK6zP5IR6b2aq02F3KuoVDC8kJbJvKHpYCb27gLZSpCMaeRJ2/j0Y56GAa1kJ1R6ChxZT9HcSvK/iY6LXt0VyCpfCZnX96QjWunsMHQWxEyneZTHN99FZdpRVs6OAjX+YjSjuYKGnlI+c9ijkoXiDsbJ8lCGBQZbxfC8l88BSQ23S8O5EyT1zC0/kphlsQG26JeYbbO3lRJxNRYH+zeaDGVjhD+58P9D50FTy9YjIGPrpKvZq0+DujbIbSwBASV6vuom/AhZDh7cq6IXD6w8ySxgDo4AuNzPf7J0TDW/SqS3qcqnk3eC
 4oTdqIWy
 VK+GAleTL0Kn8e8xmAKShpnwNljBHKYwK3jKocFURhyuYzzyClTr4ncCB5ljDLD0A2PTeDLhEA3Sj6RgDK8JrrxvZs8k5eRSP8HFEWLrQZ39+U5Ef7SlOyPHlejxRHYfr84FRv2BFtILvZsJfMFACGIrBrfCfUNfcrm8sQV38zK901UNL9ZrSAhAYf2PQpEsad88MZy60U1KaRICJMyIX7W6bEQAllAofhsqhF9pvUcoZmpc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > I strongly recommend separating this from your patchset. Avoid including
> > unrelated changes in a single patchset.
> >
> > MGLRU has a mechanism to ensure that file and anon pages can keep pace
> > with each other. In the newest kernel, the minimum generation is 2. For
> > example, if anon has only 2 generations left and we decide to reclaim
> > anon folios, we will fall back to reclaiming file pages. Sometimes,
> > this means that anon reclamation is insufficient while file pages are
> > over-reclaimed.
> >
> > static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >                        struct scan_control *sc, int type, int tier,
> >                        struct list_head *list)
> > {
> >         ...
> >         if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> >                 return 0;
> >         ...
> > }
> >
> > This is probably not a bug, but this design can sometimes work
> > suboptimally.
> >
> > Regarding this issue, both Kairui (from the Linux server side, cc-ed) and I
> > (from the Android side) have observed it. This should be addressed in
> > MGLRU's code, and we already have kernel code for that. It is unrelated
> > to your patchset, so you shouldn’t include so many unrelated changes in
> > a single patchset.
> 
> Thanks for including me in the discussion.
> 
> Right, we are seeing similar problems on our server too. To workaround
> it we force an age iteration before reclaiming when it happens, which
> isn't the best choice. When the LRU is long and the opposite type of
> the folios we want to reclaim is piling up in the oldest gen, a forced
> age will have to move all these folios, which leads to long tailing
> issues. Let's work on a reasonable solution for that.

We have encountered the same issue on Android. When an app is frozen
(which may mean the app will not be used for a long time), we want to
reclaim the app's anonymous pages. After all inactive anonymous pages
are reclaimed, the reclamation cannot proceed further. If we actively trigger
aging on anonymous pages at this point, the number of inactive file pages
may become very large.

To address this issue, I have tried using different max_seq values for
anonymous and file pages. When reclaiming anonymous pages through memory.reclaim,
we can age only the anonymous pages. However, this approach requires extensive
code changes, and it does not seem worthwhile to implement.


