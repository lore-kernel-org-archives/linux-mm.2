Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BDB606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ITfVd9wI
Received: by kanga.kvack.org (Postfix)
	id A6FC06B05CC; Mon, 16 Nov 2026 04:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48106B05CD; Mon, 16 Nov 2026 04:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984DF6B05CE; Mon, 16 Nov 2026 04:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7755F6B05CC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:54:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF2CD1A076D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:53:59 +0000 (UTC)
X-FDA: 85440520998.13.FB5C219
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2399C180005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:53:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITfVd9wI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJJAwrYiVuc03fJzpQ6JP1zmHcGVR+cvTb2BYqmzziU=;
	b=yjFb6UM5QzsrpMKrzcLIuZLXtLBsEzkTbDgobhftpnE8BPp1vo4zyvccMwNIWQ0en10a76
	I+XCHFNUvXXb/c30oB2KeM8c3XuAp/LkvV5a4qmACaC/LoEqENB62VzsT8x7OfvZySb9j9
	B1TbU1m0XNvsDBzUMu8NtBIrBZjfTrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822838;
	b=ZQ4S++7Wjyb40/qbD/g24CdVYzHQ9TR8o5/46+60BE9ViOIrJfYhZNVtzska/OyyZzVrd7
	r6OwZTx2JTO/sir1whLe1q4g2aLLOuDo0UZLd9iQTJJR6LwzHViW999FsOdOu+9HNJZJMc
	I/ux+5Xu3WI1z3JBzWLlWicW0fUKvAo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITfVd9wI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FBB3403A0;
	Mon, 16 Nov 2026 09:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755391F000C4;
	Mon, 16 Nov 2026 09:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822837;
	bh=ZJJAwrYiVuc03fJzpQ6JP1zmHcGVR+cvTb2BYqmzziU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ITfVd9wIQ+nAJl70v53f42aDy/XLw55ZzF4oM5tblfEkuK2iHhD8qpLtJZT0c0P+n
	 HTtvLYBRLgESb81dQJ9PMlL8Si8rguYAg3MfEHU2CYldhRS9twbkP4WgHCBwgFXQT7
	 b78SqT79oeCU7aHqQl3icLQCvN74FKTQYOIdftgBB/Pp9sTlail+VAzkjVRGlSgVUB
	 wx6NDyYG0eJRW9+VWuvkpQkOs6ju3VgVddH1fqrpvs7U8MQOKu6shGaFMeZPkgQmZS
	 O/Y6znUt0e5V4BVxF51ykZt+7guJX6IM2GRfuJSgYd1WbVXBzS0acGGTp0MhvwaUCn
	 TYQGj8hI8awFA==
Date: Mon, 16 Nov 2026 10:53:49 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org, Farhad Alemi <farhad.alemi@berkeley.edu>, 
	Tyler Hicks <code@tyhicks.com>, Jan Kara <jack@suse.cz>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/33] fs: don't set SB_RDONLY after filesystem errors
Message-ID: <20261116-kiesel-exekutive-liedchen-26b1c45fe533@brauner>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
X-Stat-Signature: 5fz7sqkcpikdcrtopgyq1d64tpr7qi7k
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2399C180005
X-HE-Tag: 1794822837-675685
X-HE-Meta: U2FsdGVkX18F0xRPJDMi/p/F6tOav8vUayK0IyzsW9JhsRcGRFwnMz3pZY1To/yvO+IW2WXXgAOGs+7YbPGo+Zi3XlhGyBLJivju6PpQI2Ekb+y2EKD+sB4FlOhS8ZZ5HQFBNB2SU+kKiYRb4mYyb1k4AFTR7hnPnocfMg5dzsVttLMiU+vfoazX6mRVuBpD+tmB3p6hGhvdyWEV/ruW700ewMZeeg2EHiFnfYTGxRNaX/EpegnFk29/5CIzhzDYEP85Zmb2KFslaAgN4kKHmY1vg1LxUJpkp0ZYZmO6zom+st8pnaBdeHmPWd1cIrhvKGc219JdgZ8MIY100GsxOxEbtXZliv+NoTpPZYeqv8Wh5MBd5nc2D7lqJGjYcq8bFtMUD9inzAWwscUe/y1xR7nNADSQEUOBS4AwtmYX0rQONfci0QqToBB+0qV8/iBbBkHuXxClU6yaMPjxxxBslmK5sqmnQcxnYuQNAx+bc0c2j3aVw+k1ZONFWgRaBs/0i3DZLEibRWnaK7yEVfD+M+gVdNkqA9hFPh4EZBQf14ZEYSpTloP9gxar148U8CxVJ+g8P/q/JrYn4Y2SrY/DIvjrshUDL9Xh82KZsswyZEFt/y69H3zWiHEs5rTktLBVC7IaeaRY0H2T5HofrLzyRM6WTsA+F9MFvWVUfGOfusQzG9bpDsyLGwI/mawCqIIc8epIqJIJN2Wy9MGTuczXKbjCyrdMgp6LLi9yyKf7wwvqk3fQlwfoR8XDWP5ucAfE5jTAxddI0qJvR7ws4djKjWW2g/Xm7P4IsrI0cJdOsuSSgysUy7vc//SfeYLSm5C6PbT75i/VQh1bzg1OiS/tXcJTiOx52E1KJFwBlehi7McW3PApOERyFNqtxQ17nmpdCnnZ3KT3UTfYo18N7uvPtfHx+i5g+DdL7ZRyFBY+wzYAlOnxbT0/m30Pttcsn8bFfL3GMq+e06b+sVy7Cq/
 ieuzJ8qg
 s+9Rjv9lYQUQW6juOAYvUBErJyExycCXrx02FRsMtgJKXmTHAz88akzImYxEH8IBd0mL08f3HCrayNyoEDhUPCnorxGWCdRK8r1d4yMzqled3g7T6i4z4OnRqUN9AjLLQKUhfDmC7JDOcyesXDs+7Gj44JdYlxS/S+wLhmtfJHrMzwtDQHQjMh0c8XL4FlsQK0aITls8zjeliGOgW1Ppy3+aWG/rtp3LbEYhedfiEsnnAhFho8nyqJS4BeWMKPAXSDZnRp5RHS5tjWu/3hYgGOWlZQK5mXC0s8ZBCS96XiRLCC1FCWDDiVRWzcAtjzBGdt7oesQ10TK3gY1hESVuHAeE0eNWS9sk9Eq60RySkCsmQEOhc3Npc8J1VQw+MKoE0aE5He5lnjncNiYEmkLl6JToqof8aaDrCCv4hhDplXqItkkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is now on vfs-7.5.super. There's a bunch of outstanding
pre-existing fixes per-filesystems. So please, if you're a filesystem
maintainer take a look.

I will declare this series ready, otherwise this will turn from the yak
shaving that this is right now into yak-herd shaving.

