Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434BBC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A046B008A; Fri, 11 Sep 2026 10:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2F36B008C; Fri, 11 Sep 2026 10:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CA56B0092; Fri, 11 Sep 2026 10:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E578F6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:57:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BD04160285
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:57:13 +0000 (UTC)
X-FDA: 85201784346.07.A91B10E
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 191AF20004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:57:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=V0j7sj0q;
	spf=pass (imf13.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138631;
	b=Bh99WhBPG4mCZEF7bTomQp9ySuaKvZPoC3YOOZkh5WJYbsw6clpjZ71Wj8Qblu2+M2QxSG
	Nzyb8oXPgIWX0xe7W5DPLYM4QXFo5/qGVMAGX7EaDBbQmLWbpQqs2E2YuPJJlP3jnSBFM9
	Y/sRcBmp535trOe1/DBkS3CNPk0EX0w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=V0j7sj0q;
	spf=pass (imf13.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOLqMnhLxFcuZQU5MjIuT6M+r5m+kGO8dRpT+arVVBk=;
	b=uPwwgdVQx6lS12JgVHhNJSFIt9owIXd+GnDR4JaJJT+4MZO6C5VUNJay0bXjIS/lA93UTn
	HZPGJ/y3EgNar2e7TQmdiFRig9/rjVgETNZIwLbaICVnUjwjQlnIkB+YUV22BdKmJoWj49
	bss8qQeiSYauik3cbEhdvkKqszjBZrQ=
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68BEusEA023912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 10:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1789138617; bh=aOLqMnhLxFcuZQU5MjIuT6M+r5m+kGO8dRpT+arVVBk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=V0j7sj0qoGJXIVCOxj0EapqMi4j8HuO81h2kbjnaUsZ2R6AUOa/4Xgf6sepue9QlF
	 RhQ+bSGMxs3DUesIlWY8UJxjZ+MhVkPy/EFjnvGmGnqE4/UpzoUjn0hRqAu4KWoZY+
	 jOjNT+At/iIN4tZkrqX9dciXhqdUp5hay57CQ06XsQrfc8Rn9/8g3i1vboEDMuZYZ8
	 e/hACqSoojo+fGIvxPAp78avwE7V9a1nhedhHweL4KUwuNerRKd5avDz+NfHiXilFc
	 cZ0LD2rXI5WurNdh9JsxSLMjOg7BpPBZWsUMh3CFo2TGN5BJlhmn8jEe975fQQZwQB
	 WzyzSlL9m9QTw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E4CD01481C8A; Fri, 11 Sep 2026 10:55:53 -0400 (EDT)
Date: Fri, 11 Sep 2026 10:55:53 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH 0/5 v2] fs: Deferred inode reclaim
Message-ID: <aqQV6Uwma_KjUH0O@mit.edu>
References: <20260911081309.14137-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 191AF20004
X-Stat-Signature: zykbtcme1g1d9qbfg4zx6ti9fohi1gbs
X-Rspam-User: 
X-HE-Tag: 1789138629-932013
X-HE-Meta: U2FsdGVkX19eNhgXcZ1Eo92HGnIToHux41D+i9/p27Ezntoe2SVFVZcGhh7ieprFnkejsYzjMScxb9G8/J/zmJ1k6AKYlmlWOSh7jZP/D7uPStAwti8KGUYppYKDMiszILHdrbSL/1/Wv0nudxfKxKh9XCcEV1pe9TXJ/eST0ey1P1Ua7BYDCvDdGGSEsBuiM78l7u9eL/Tk22C98Dj4UnfSOqY/wcN7bsKz5chalrnueFcf6Yg8HyRlQOGwqzzcZ8JFKnhTAqaJncoLnMu2Vr179pE1RwA/Fa2OIYcctue0YGRRjIzbGL0ht6HZw8E2RZE1CM/G/bEuZiPxAOt6WNkrP24sl7ulUBGlaiN8w76/nwS20ny+0FG9MBFt1LK9T9R+EubXr0JCh785R4JzpBS+ugHEFwC4MOpRx2yZ5ShTCivR17udUWQuZZ2zJl1D9p4fXvr26s4vmyTRJfo3rbRbSQaeNr+HWKixJ8mRbSE68pHQCMPbWJwjVN8a5TWvBKnWFxlc4vJN55A9ZkakG7eIvW8x2yyJwix0tt5Yca4WN9eCRkJwGvAJKLJ3cWB9kxyJARjRoE81WUvsfYwgkyQBcCdHsdtVbD4o8iZ6MU3wRrQURgGzxzwQZ/SelnqMGFwdZ2iFy8nln+kOpabkrkForxFh7LhUqLHtrLngYfK52K6Sg4h+WMmgveoZIDSzEJ8i6JVilOhc6Hq9K3zSQrGQzl+N7hwmG4x+w/t7t1qzG9SKHiutuItaJpX8VUGm2a59Jmin96mfqkgDIvrVfmHMNWlA13pAo1r5B3RqLmOCC63dbvHewcFZttIFS2DtNBoAhWKKwdhemHuBXN6nAPjkLDAJgQiPyZmN3iMuHg0dTIpuR8ctum8huMOKHI5k2E3jKdNw94r6DFUSrWzCmlWOIv5PMJGTUbjwpH2J6Q4Ub0uWm/A5RJ5K2+sEZZVHbu3L8fbZ0aXWdauaehP
 8YJioDuI
 nejVsO6S8wTa0F+Qdpu2hHjx19YPktJ398x7Xt+Xdghl0stFhSDOT54w8XYG9Cf6z8HVZq5s8D1bJyYqHcdrbDZKDyNVRvCaviMBualU/bDondtR801hepdvgsBb1Jkt0nVGJpvxvpsojUNw0Durhv/RHXqAs9Ws5JVCrgbGQV243A3nhUksSXc+lxgkonYOhNUr7+d/1grwXL8EGtPWtghUF1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:51:36AM -0500, Jan Kara wrote:
> 
> after a long pause here is a second revision of my patches implementing
> deferred inode reclaim to deal with MM warnings due to GFP_NOFAIL allocations
> from reclaim paths. This happens because to reclaim some inodes, filesystems
> have to do IO including complex operations using journalling and forward
> progress of these depends on successful memory allocations (which is impossible
> to guarantee from reclaim context).

Thanks for the patch set!  I wonder if it is worthwhile to wait for
inode reclaim before freezing a file system for suspend.  On the plus
side, it leaves the file system in a more cleaned-up state, and
reduces the amount of memory that might need to be written in a
hibernation scenario.  On the other side of the argument there's more
opportunity for freeze/suspend deadlocks, and more complexity.  So
maybe it's not worth it.

What do folks think?

						- Ted

