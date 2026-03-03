Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37473EC1431
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627656B016F; Tue,  3 Mar 2026 06:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF666B0171; Tue,  3 Mar 2026 06:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5364B6B0172; Tue,  3 Mar 2026 06:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF7E6B016F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:49:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3F68160140
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:49:30 +0000 (UTC)
X-FDA: 84504581700.08.E25A133
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A013140005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:49:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="ZvhzO/Bb";
	spf=pass (imf23.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772538569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLIQPSMZxH5XPx9wxSi/zIDIJTBwL2PHFwUC/MuVlSM=;
	b=0miHth6pQPdPvAlbxJvyDh3nc0leWRarMkwMrG9AR42a39pIS/fnvMORy/uGdAkwklJGlQ
	fYAQ2PSHDVCjs2NnzcPiX30VB8z8Q91/FTgP5PdSesn67M8xTgNFcVIQ4pSMK1nN0thu7q
	l5RMbhtSHdsAo57BAlqCyB6z5vyp50U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="ZvhzO/Bb";
	spf=pass (imf23.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772538569; a=rsa-sha256;
	cv=none;
	b=n+iWnWNTb8VmBvtfrgGfoU+aInlYUcpJ/iS7tvEmA3CE3Rb0Fwxv2JoZmrrOv24N73DMcQ
	tsK4XoHwGKlqUqPbva9WIf1K/0+KEuCRf4stSFOVKfooiel/Wt12fBVdzpcbYfoDDLCWK/
	CCe6ffGqdxIUkk6HAr4D0NJFFbmysCM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hLIQPSMZxH5XPx9wxSi/zIDIJTBwL2PHFwUC/MuVlSM=;
	t=1772538569; x=1773748169; b=ZvhzO/BbmOxAEYDyU+5ZrwMMpzJhXOlDpkutV1SF84vHKQV
	dpbt3hkmno4Yc/7v22LcahOqqU3A3jy8vKIy6z1off0i2NzD/kFba4L1nQiqvDfG1oOnoNINoNZTn
	NGlMVpRvZENtNJ6DYqsRDYWHsBxwkLP3SZN5bhUdraPH37N19KtQ6+/L5xHvoSHmWLywbdxkI/WT/
	SVKnBhcywrc+z+h+AkhckYBFtG4q7UlbWFVUkTWk0p8oCSwMBbE5MHtlt9LrKfvxXWA3U6ckiwiOX
	gDptvcOaASLgl6BZLptbNjYK+g957VHxrsRyKKbbcTBNqyyMKwdYMHqR3ewIttrw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxOFh-000000075Cr-2ndV;
	Tue, 03 Mar 2026 12:49:25 +0100
Message-ID: <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, linux-wireless
	 <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>, 
	linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2026 12:49:24 +0100
In-Reply-To: <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
	 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
	 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
	 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
	 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Queue-Id: 3A013140005
X-Stat-Signature: 9ijex7enxue7y69y583izdcbdzsfck6x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772538568-379933
X-HE-Meta: U2FsdGVkX1/GxhIPWCUoRhdwYB/NGExBOXaDprSlE6SVcOb59/wyJh0pBu/9VmxCvP1O+A3uXLug7FjnHhIuL4I1+SVy4Bt6zd2qL1sweSQ6Y4w/LGQNM2OkY2YRlsXTgM0ACOWNVGSZkN/87m7Rnth0FhERo3Hvy34gG8BeUqTROU+HLsSHX3TZnrDGXrsn8r0SgpXdmgnZMeD6ChwACwtJq1yOj5FQuH5aWSmKt3NjGrC9DOzR7MHpKksamLiEouhFP8VgBUJ9ZVfm7tt/3S6ln/t0lvX4KcLV/kfaBdv5jjeBeZVfBjHb3DiTnGYx4uoe8rU1kd2JboO4yRi7h/T90G6bFcjpHgc+SxXjf2tovq2EkUV4rLTgfSYzdWiOPXk298eFmsG6B+SyRGhz3D7qdQwLDtbUCVRULjUXnnOpZZv9IpAUPQYL++LD2bFK8qcVrORg8mEJgzFtJ6ILLhy6n5ZOP1pMWoR50pNXqBdhnGv57qHAUF9uf4ajbP8vQ4h05iF7prNOur5DqxSJmfeOTqSsj6MfaaWrBKLI74V8Bmj0OO8JbnNFsy3/C9A1T0dJGPpsnJrj3Moq4F6/K16ghkcP+xMN0tO6fZ2cx+DkTO4n6brUcYVpaTXsjHLdh2xcwf/Z+QmWVSKeF4H7o2c5qXrIkO3XAep/iPbQm+sfIEzRoVqh67zF3b1QT2d3LN+SX6Soi75QIVZbaxy8mWWe1yN874wTEpgQ04xXX7X9CcGTW+90W53rclkWB9IwfbYoOxhvAYNzL2pRSOD9ZMAjI+yadJgEofb4G1TmxeOB37/KZvbTQE6UDqg9ppJE92+MwPi4JGSGHSVUvSmPvDs1EJ3ZHyuiB0ubvAXW9T6CgkokN4OVe9OJTUBkNXBHYt8rV5k6O4X/frpXntWSWcXtrurN5aVrlsUg/vj/eMuwZSITi4mPEhZmft0/L7gPvcQ8o2rozWM7PQDQzCh
 bXdRCUQc
 T2nUcvMvUpHg4ztTwnF6uCeWvEm/1HCMQ3B24a7zpTyq5Dg5bTZlbydIzEo8yIjauBrTqq4UDi3JLHTJMebpzpvMV4+E4k72RCgifvX5Q0PdbLj5P9Fa4sGlIQY1QEZ2CcPZFUg411a7NtDLIgQh8CsjNTG7V+mtMJHyA0Q5JGfFI2VDtAqfAm/GEfAtjWxDWSYwh2N/gkho0Nr6F97gBvfw4OMgxlEoJ8ZcEGHAoia6R1tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-03-02 at 07:50 -0800, Ben Greear wrote:
> On 3/2/26 07:38, Johannes Berg wrote:
> > On Mon, 2026-03-02 at 07:26 -0800, Ben Greear wrote:
> > >=20
> > > >=20
> > > > Was this with lockdep? If so, it complain about anything?
> > > >=20
> > > > I'm having a hard time seeing why it would deadlock at all when wif=
i
> > > > uses  schedule_work() and therefore the system_percpu_wq, and
> > > > __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, a=
nd
> > > > lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything re=
lated
> > > > to RTNL etc.?
> > > >=20
> > > > I think we need a real explanation here rather than "if I randomly
> > > > change this, it no longer appears".
> > >=20
> > > The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks bef=
ore
> > > allocating CMA memory, as expected.
> > >=20
> > > And the CMA allocation path attempts to flush the work queues in
> > > at least some cases.
> > >=20
> > > If there is a work item queued that is trying to grab rtnl and/or wip=
hy lock
> > > when CMA attempts to flush, then the flush work cannot complete, so i=
t deadlocks.
> > >=20
> > > Lockdep doesn't warn about this.
> >=20
> > It really should, in cases where it can actually happen, I wrote the
> > code myself for that... Though things have changed since, and the check=
s
> > were lost at least once (and re-added), so I suppose it's possible that
> > they were lost _again_, but the flushing system is far more flexible no=
w
> > and it's not flushing the same workqueue anyway, so it shouldn't happen=
.
> >=20
> > I stand by what I said before, need to show more precisely what depends
> > on what, and I'm not going to accept a random kthread into this.
>=20
> My first email on the topic has process stack traces as well as lockdep
> locks-held printout that points to the deadlock.  I'm not sure what else =
to offer...please let me know
> what you'd like to see.

Fair. I don't know, I don't think there's anything that even shows that
there's a dependency between the two workqueues and the
"((wq_completion)events_unbound)" and "((wq_completion)events)", and
there would have to be for it to deadlock this way because of that?

But one is mm_percpu_wq and the other is system_percpu_wq.

Tejun, does the workqueue code somehow introduce a dependency between
different per-CPU workqueues that's not modelled in lockdep?

johannes

