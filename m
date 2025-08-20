Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2149ACA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B758A8E0016; Tue, 19 Aug 2025 21:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25DD8E0011; Tue, 19 Aug 2025 21:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BF98E0016; Tue, 19 Aug 2025 21:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3968E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:29:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30CFF14021C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:29:20 +0000 (UTC)
X-FDA: 83795402880.25.BB12387
Received: from r3-11.sinamail.sina.com.cn (r3-11.sinamail.sina.com.cn [202.108.3.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 600C2120008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:29:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=k12cfg6k;
	spf=pass (imf29.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDafkYWgS7KusKN99KHqr7eNp5lhr4MsE3lDHCQLm5I=;
	b=FpMm87vCdTJ3lxOZw7gBQ0yWrxjwe/wk8MwB8/na9sgpQxh5l6iP6J1SYR8UmYqPoLERYE
	eWVG6C62O06yj9GnrBxOT/sn0nlwUA7TefkD3gr1TWseE1ZovNb8/9lEejHrIC4ru7GE8M
	qZoMsAYluYHxSTQBE/EmMvF58i4W5qU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=k12cfg6k;
	spf=pass (imf29.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653358; a=rsa-sha256;
	cv=none;
	b=khcyrnBV5pnSjADY4As9iaikHUdgXdg/f2xjm82DtmxYGMZ/nS54XFHEIOGzzdU59AOeAf
	xCjQxA+iQYYz6nThPns2TE+osV7YqFYNTQV1nuBRvnfJuRfk1apTy5pjcHEytyqCA0quPq
	yIt41zYFxMDbDgBDNIlyobQq4WtLhTc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1755653357;
	bh=IDafkYWgS7KusKN99KHqr7eNp5lhr4MsE3lDHCQLm5I=;
	h=From:Subject:Date:Message-ID;
	b=k12cfg6kjMPe+0+5F7dChaSlmiuKNx/A/cfUfXmI3Hob3ooOKmtQTJ3Biimk9GcBR
	 UnXT5TAPIFmsqOBw9Mw4x6ISU39P66toBQ078iIzNLrGNUgLoW5sXaCz+LejAldPQk
	 OgKiZs0isfk8nurjprq610V+0VpWoMYH10uEeW/c=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68A524E600007DD3; Wed, 20 Aug 2025 09:29:13 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 894876291954
X-SMAIL-UIID: 7B0216A86C964D598B3BEA84EA01C3B9-20250820-092913-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Wed, 20 Aug 2025 09:29:00 +0800
Message-ID: <20250820012901.5083-1-hdanton@sina.com>
In-Reply-To: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8htwk7e5behu99m8bjwi3mrfaoeoutbr
X-Rspam-User: 
X-Rspamd-Queue-Id: 600C2120008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755653357-654891
X-HE-Meta: U2FsdGVkX1/uVh/5HgTouSdiSdZnT5NjuiHvuZ0QZFNnDea8FdBZG2xa8sFeHk66ELujCsapIH7CNY6GFhdb1U7aA1veyIyRUMSFlpsxW9UV/mTvBl5hOGR0vMaXUCLpM6Pxw/XgHueyS/FLbfBkRCjnCaNv8yPIuAXX8rY7lKYJ6Eb8M2V7v4ESivRLitjatG0BFWY1Yx7ilG8Slx5Co4PTmmvVsR7ycWgUaBKhT2hbo6+qB/gyTQ8PAcdNkH1bsFM9Bh7l953rtbBagttb/lJZWq0tGpEz3UYTTP3d7so0iNbdZVFHtQvVegvy5D9H7IxQu1acJbpQESHHuBl6UZzTPjpDUtuzzg3N+34aNbuT88hNBSwE4RyKaSO0Vpp8hOwKtnwftW0sG1pLWSHwsF63qC2TNEzfsv7FbmTYfEc5/y9ye/y92AMHlmZoWII9/pd5YlOCCBIHOO7tLDDSfCHmR8BDouQ9qmUszRIDH6cQXFJ4K67TUSOwrdZYnE6hrfvrTIoTrQRxBswWjjX8+Fosz0pcEdvPHI5PazQVDfOhefDehvQMttyV6qn2zcEWPk1nG5JCdTfXrJSu1gc381sf5pvGmWkwcDHTigkavvC24nz/G/hLZmqDF02Q1jm2wXl3uxAS3fqmRz+lfxGAg1JHH1hLooYZTn5s0Wi8MMaqGudUY04IzhmWN/B4JOQmBw/tBNd7ZGsL42P8AbNNKrDFVr+D5otVCDBNPzBmeAd63o5MTDg5StE9N4GMv11ytZsEmDFjcoIUqETpp520AnS4dUtAjzIU7OGYDgVPY8vPsrsQ9MAhmsrfwu/CGmxODCrka66ThlaIh+bK37yos7ZsrfrGZdcc4vMKJM9/jIRUxCeBN2e+1e3iyYg9nu0TxZOLiBxo5R+YObfEvSnic9t4GGMmE6c6qWWvICyWc8znQovr4SZZ6QizcZEPNsrkLaB1jwl5r7i1c7XxEQW
 FNgpVCsr
 aO/+8cV2Fr0mP0wg3Nui038eiTBzORu5nBvYltXEeRFvXtMEsjT9dm36wO3VRM88qYS+jJ4B96pJOTiKqC1QqzugDVW5fJWEBqUZQeaBBCAEYs/oufQDt+BoJLgK/qSPnfJPg2N6KEeFl0IhVDVUVUvjJqsWZKe2+rOClqAA3OZtJnHpxA+wZy34HU7O/iUzdYnRxFn5ZsJaXwSMWLyvAx546Jc5tSPU0teqwDUBUV6uLO/HVW1wqhOuNQla44cOvYBi5tHq6B4CRADpM+VxiMwD15DwV6/xkeYveCRceVCAsKTsutSo81NnDMWAQAnrZkOmVdScQ1+SrXLiNhpl54FBr7XMti85oR/s1e+wGfCDFmw0c3mTQf5Cizx85RkKky93cJiuUR0uHSTQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn wrote:
> 
> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed.
> 
> Instead of holding the lock for the entirety of the freeing, check to see if
> the zone lock is contended every pcp->batch pages. If there is contention,
> relinquish the lock so that other processors have a change to grab the lock
> and perform critical work.
> 
Instead of the unlock/lock game, simply return with the rest left to workqueue
in case of lock contension. But workqueue is still unable to kill soft lockup
if the number of contending CPUs is large enough.

