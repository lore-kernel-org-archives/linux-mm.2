Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E14FAD3EC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E886B0005; Wed, 22 Apr 2026 21:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846776B008A; Wed, 22 Apr 2026 21:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7829A6B008C; Wed, 22 Apr 2026 21:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 675F76B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:56:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B7111C0214
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:56:28 +0000 (UTC)
X-FDA: 84688156056.25.6779B8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 751CFC000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:56:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncJzQNmU;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776909386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjYzFXJ+0y7BGs9l+Zd0yxtk1jf6XPGOyyEiq6x+0Eo=;
	b=0z0sKA+7JfNTc+eT9eAJ/LQKY6zICeRRqZO4E25DAHiCm+OQ0JD4r8sq138e+hLOFablRz
	C8WsSF+cKGu+QevzG9Yx1QuPRtCBVczyZrryVwQhctpb7X6jceNMNgcEPShMZ2vD0/AVt5
	nP/vS8OTi0sPLYRhFj2ShEQdzanDJeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776909386; a=rsa-sha256;
	cv=none;
	b=06xymuOm10JnfzV4CgefqGHZPIdvdaSvqZht8geGPr+lw0UEeaeDi51t/589mErr+dgqLh
	YnM2ul7ucAdXipY1/1h92JyJD1t+KKj56I2zTrc0vX/z8XmMvZdUb/TBIR8xdi/wyO3rZ9
	SKSFUdi6MjcQUfghGPWqyTrPZRJIf7s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncJzQNmU;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9253A60008;
	Thu, 23 Apr 2026 01:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B3C19425;
	Thu, 23 Apr 2026 01:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776909385;
	bh=KAGOUx6yOQBUTWbcJZ5YYD8oZgXKSd/G9nbZorBB8VI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ncJzQNmU8XIhi0yRu9hOCQjgLfDGJEYeL70YBREslC+wBqHUdqZ271/iCXsrfsBWr
	 luJ2YTFRBvf8tWy4agH3WztEDkLqhYe/5JI3b4EXJtt+leCo1yMyp1FQkATADIKigj
	 ad5BBJdJrXZGp0nkyCvSOTCdmZvW6g727Tm91z8aLIUn5aiTv2acVnMVnsD7KOA0A7
	 ZEan9MBbXd8xe+A2aIuqbcB4d2wVxrjkBb5eWGyBALkgDKvN285yTprc4mQ3ogsLFx
	 70mmHSbkGwKf9KIRHN7KmRRVPGLK9JQ4elbEmYD6cyzc0th2nHNmHLNQInHOnkfThn
	 UApdlssqWVN5A==
Date: Thu, 23 Apr 2026 10:56:23 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <ael8R0vOeZ0Xbcoe@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aelxH--hZkCahPv6@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aelxH--hZkCahPv6@hyeyoo>
X-Stat-Signature: mitq9osqmja7hmznn4fm6ox8dfh5emcu
X-Rspam-User: 
X-Rspamd-Queue-Id: 751CFC000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776909386-425220
X-HE-Meta: U2FsdGVkX19Miy4bTGUv2vRmmylfWgQqPv/8JCHEIcviTvunyYV/EphfOp+qTTHL11raBtQNUmsJwOvAkYmkgGUGXcoK/7PfhBRZBpdfLz9kk/+ljxSJ1vOhcxo5Rk89Z6nxQ8q8YWFN/SgzhNxQXNiPXx8oZiajX41IV36k3Xejt17FAaiK1XlWWwnncpYLFfYpMa+CIvjhC1p0wmFh4Qm3KXgUkJf8Cf9NPlL7lWR9yeL72wwdfstY4CV+OFGkTMA4A9yuhRaMB60ru9YiAPTbDJ2IzytrTVgo+7TaW8kOy+lZa/omFZOjsOPo9/fj9yF5q9XoepjJhoTm/1jdXx/JGZsp9eMJlC7Q2rl0fDatVuIhAPSzI1mj+06AkJSp/RU27bVoHdJTCJO4d6j4aLwhDXwg5ebTw1ZRiGa+A4MXUpw6byrVPgG1gMpegBrIOhDB8DJqktS4jeol1faRW4Fk7iLmr3gCimzhyRJjdw/OIMOIb02Moutm3LA3b60XoSkNP7MaGQhQjKiNSlj69N5var6jurg99JhSX8/XYCwhxPjOqr9dZz6wz1qAr+ZMElbHhDS4YOiKSu2/9k98UngxYhUDxwn8lYve7bPThb9d5MeSOKwzNOiWeBPhVj+ztCzQcuYwThM81+GYg8Z+3/7ANQ5GqXnyXZiaJncQncXPzPTRuaz64v9c3vla+B00PrcvLrsVwZ0DAGuwcfglAjYJp7t9AfXN/NpjMzGly91xOdsj0h9V7bkBOxOaTrX6mSYHhsff1hfrPbk8VbzvjO4sUUAiJgD+Brx92BXSfhU28/3tW5C0Y0O0n29L2R7eTgSjkPI9GZtiFipa9hIZ3RrIBTVDZaOgZoktT1X/6LAgihob4sydOjJd3KgkLng800WW+rrjJDfSsvGK5Rfre74BwaPDAQUgJbmUvHtrXCCa6HvILZIoV75KTgvTPZa2LN6SR1xMCIPq0VufUiw
 AeJbQeEJ
 PGDJBy78z9p46EO/MCBMidvs47sdve/SLw7AyGWugVpMeO3bp72mnPOnugOdWRxzTa99ZV+UC0kKfIYCQ2eW+C86YLcw4qcQEY0tgvNd8ZuaVegqbBWYvZ5B7uMiToc9Xy6DwpzQGh1pMEAyUrkzEgb2UMIsoXdopdMiobxruRfMvgR9ENqJAc8nn4l83TBtfWteAJDUEAJkVObKJhkQWQweLd507OVmmvdJzMhiKgkC5KLOE1kqsyA6rPYrLCvtr0X3TaPpr/m3mgc4BaC1r8X+IwbHIMFYA/RMYoAeZKaSHTtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 10:08:49AM +0900, Harry Yoo (Oracle) wrote:
> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
> > As discussed or noted earlier, having third argument and check the
> > entire path with "if (allow_spin)" is not optimal and is not good
> > approach. I do not think it this would be a good fit for mainline.
> 
> I understand that this pattern is pretty uncommon and adds complexity.
> But there is a reason why we're doing this. As Alexei pointed out
> earlier, even rare spikes of irq_work hurt performance [1]; that can be
> avoided in most cases where the lock is not in use. That's why buddy [2]
> and slab [3] accepted this pattern despite the added complexity?

Perhaps we can avoid complicating existing kvfree_rcu batching
(and still avoid hurting performance).

Given that kfree_rcu_nolock() (at least BPF) doesn't need to free
vmalloc objects, we can make kfree_rcu_sheaf() handle most of frees
(slab already knows how to handle allow_spin = false) and fall back to
a simple irq_work as Ulad suggested.

But then we need to make kfree_rcu_sheaf() try harder (currently it
gives up when it fails to get an empty sheaf from the barn).

And I guess the tricky part is making kfree_rcu_sheaf() work on RT ;)

-- 
Cheers,
Harry / Hyeonggon

