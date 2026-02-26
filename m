Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685FCFD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 17:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69156B017D; Thu, 26 Feb 2026 12:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A166A6B017E; Thu, 26 Feb 2026 12:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAB56B017F; Thu, 26 Feb 2026 12:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74E936B017D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:11:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C75214030E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:11:19 +0000 (UTC)
X-FDA: 84487248678.01.4D4A8E7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id B0D7C20015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:11:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bLq8scXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AUyzYfQ9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bLq8scXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AUyzYfQ9;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8csZr2EQgc5N3LRaH5ivagOwuXzf8UvC8RjMLY1sRU=;
	b=HXXonVuzMHQ3ws/P4sYIhxdJDd1w06p3MMATIyGZFMzk6Ie75uYNO6HppKVRm8OFnEkuiu
	Nb7T/PPDsTD5Vr/c4wXr/dO6HsBQBXTMm9RjQ27U5njVCM0hyiq1wq0Xf76tAqDxO6hElj
	jXSj4bqELuAZV1Go4ULE+RGwGsazkYA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bLq8scXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AUyzYfQ9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bLq8scXn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AUyzYfQ9;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772125877; a=rsa-sha256;
	cv=none;
	b=O3hLxNtshS6lv6+PGfjCgPv3EPbEZ/Wwe8m6Ndmp2TcgPhGICPsJdhJRHWGnugKeLqvQpH
	J/yQBvKBYYFhFBAhBDfG+GoZbX+w/t7AigizLxNBuu13euPy1nzR0tMWiJTIKbnWJHOWJC
	467rcc3S1Ggs5Pi7dCU3300SXT/u6Nk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A6EE11FA8E;
	Thu, 26 Feb 2026 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M8csZr2EQgc5N3LRaH5ivagOwuXzf8UvC8RjMLY1sRU=;
	b=bLq8scXnwXC0vwEJ5ilKWXpiGzWGXINIRxQGuAPYznnzF8dJ7yEAGsRN1FXFSCo0wMOtEw
	R1r7iRQfHNM8PtehEoACNOxGhhYttQpUUfNxxp1s2Wvc9j05A7FUEFY5faSoAqQhjduxby
	hGwdqMrN8ovxNjwcyfxmNJZvL2UdNBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M8csZr2EQgc5N3LRaH5ivagOwuXzf8UvC8RjMLY1sRU=;
	b=AUyzYfQ90XcSZmOs/v84BZ0D0IAVBm4VSfgx0h3wTW4vNmvkFtLxsrW/okGqwdCnF/6uEc
	+rRoz6E13pCoehCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772125874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M8csZr2EQgc5N3LRaH5ivagOwuXzf8UvC8RjMLY1sRU=;
	b=bLq8scXnwXC0vwEJ5ilKWXpiGzWGXINIRxQGuAPYznnzF8dJ7yEAGsRN1FXFSCo0wMOtEw
	R1r7iRQfHNM8PtehEoACNOxGhhYttQpUUfNxxp1s2Wvc9j05A7FUEFY5faSoAqQhjduxby
	hGwdqMrN8ovxNjwcyfxmNJZvL2UdNBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772125874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M8csZr2EQgc5N3LRaH5ivagOwuXzf8UvC8RjMLY1sRU=;
	b=AUyzYfQ90XcSZmOs/v84BZ0D0IAVBm4VSfgx0h3wTW4vNmvkFtLxsrW/okGqwdCnF/6uEc
	+rRoz6E13pCoehCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EC4B3EA62;
	Thu, 26 Feb 2026 17:11:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cu1uIrJ+oGlERwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 17:11:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1EDF2A0A27; Thu, 26 Feb 2026 18:11:06 +0100 (CET)
Date: Thu, 26 Feb 2026 18:11:06 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jan Kara <jack@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Alexander Aring <alex.aring@gmail.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, David Sterba <dsterba@suse.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>, 
	Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Yangtao Li <frank.li@vivo.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, David Woodhouse <dwmw2@infradead.org>, 
	Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Anders Larsen <al@alarsen.net>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Casey Schaufler <casey@schaufler-ca.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Martin Schiller <ms@dev.tdt.de>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-nilfs@vger.kernel.org, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	autofs@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, 
	ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-x25@vger.kernel.org
Subject: Re: [PATCH 03/61] trace: update VFS-layer trace events for u64 i_ino
Message-ID: <6exhq5gjvef5obfsqwkxfcpl2sjqmlv7klrzolodzpcjolgrmd@ds42ulhod7pw>
References: <20260226-iino-u64-v1-0-ccceff366db9@kernel.org>
 <20260226-iino-u64-v1-3-ccceff366db9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226-iino-u64-v1-3-ccceff366db9@kernel.org>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B0D7C20015
X-Stat-Signature: zc53tk5khkizcbpwyqxzka9oi3e8zg3d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1772125876-561884
X-HE-Meta: U2FsdGVkX19YLxwGmhc98Swf91r1G/5B2COX1/cBKXYBfNIPifE1Ux1IpG8k5rI75jPXVQhHTSh/EvOKH3fFNU1a0kiK1tcd3ER8Hs6WfrW05KfBC+s0IedNq50aMkdzNBEIlPiT9QC6O7e1V8fz4pRqOExBKGlLC9jt6QE2NnV6eno2birTwMOazJr2FTmVFI1lLamUE4WarbTWWJvfr0YdfSCsPjJCpog+7DWnm3HbvH/1EoBsZjdwb8NWhzDy9ZlXmZfI/jiXSZJxK8ggDd7LIDmIC2y714NZndhEjUlfPf+AAysPbJAna0yh6tIVrFqEP1B7Shm7+3LVygE4Gl7JbmUtpip4DlENYCXjy0kfbrRFnDLzv9Gvl9spN0hKc92047MyJ7MwYt8M8fVi3f7yDJZf3NNJNYU1iD6KbG/bV/X9cYZmX4sSWTcb86dZwfOn7E97adOF0vRr2iVwrcslWqrQMkKtVHHNkYvOt5uPeb58zJJNMf1Q1nI/6HM9FuW3yis4kHiu4IBjx1s7EKviuYmbapKtJtqFw1IUtnErt8RRZSL/SZSC3Wf6M6ddoLku3ec24mTlZj64nD5r5SYnSieKzQWEb4nQE7vrJmcnTFA+f0ZGKNnR51OnSlaCtBJNjlbsO/1sI8k6qfJ8gWEAhXScmX51Y1WmyZIX9JMkApCLogHi6USkSt6ziXYpn/XGaq9yGW6ZtY315fv/czYnYInqaCNMS9Bmf/ap41/+Hz2JR+rAATT4p+3DGoJwhuKJeIDYXqwBiKNV0aAdfjcJi7Yd4X8hzN0FQGNzql/4yc5/AsKic6ZATnLtcqKS2jCabT4CGN23x8GUobHCPuQdILk3x+mj4XCD+2daStsKGGmyzA2KHou+6hzyFzbNcGxORLaIf17DqfsFbj4s6EWqPA2BiTCoYbBIGeaHUUqBQDB6/rD++VTEdEDp0mYrpOaoojFhoXi9Rn5DOMU
 RWpCTfrk
 YaigxZ0o8Do5nYmK9eR4XE48qqNhEimxfnY+gLBgT/Ndg9do04keWXXmjCvaWdNcr/5xX1km8L30AG1f2Zp0/3TlRxmzcROd6asRjcpzA5ofOyFZWuextrCE8va3y+1Bi8iqPBdI8hgwx0SPzakNNoH2We/sy/uFCt/8k+iWP6zw4eoL5eOHYwCF9opXFh03xnODkb/2wT+BPtfLmZBxhVBfYFIF7lPB/AL7WuGpiPbpGnQjECGdg6g9kBWUeDG2vteEdJYOEFqIUv0pp6p/H+IqoErDsq3f5VJ5IWiwxmTVuTdTc6fzlRbRkd/r+4VxOtdQUPAuQvbaPuzAo0R3eTwLkG042kNIFAo5NfMQ55laTB95I8cIikWTPbVWADP/o7Gx8ySQEczL66ElS16LQHqGZf5NaX9rJjBolV2TSTifT1o+VOcIDXgP8ESCdryjTNo4I0eVGthcRditHLDPj+iKfbCdoaMtXONFppRWo+ch0Mb9D51D62ySFEjKFo3I5ncM81ChAtWqG5U8TI8Wc12CLPO9KHpTxewjS2qZ9K6ZAsToHWj5pXxxkH4HZZNXU4fYNOHZspH2t0JudhQVXkdf0ocP0jZQ4MdHwt7hzSD7vvA72LP8XqgJxI8bQ6uXtWJglRLxW9yhIzP7ebOU3l0tVvTINfY1dTIOYQ1gHNfXKXhPwW76wigdH0KyO2XGZ6mXgQHJ7YurS6zwwVigwrnJbNIpezJ2nd4/RvCXF6HEPpA2J8DxLe4HxSTTYuQeaXTRkTCARlMll4CqmAtUFo9ccT73dzHUur85tGUc6IQYqH1c9igE73/UjzNXCb3n+RyN6ukBHeXbc9piFqisMLNtqn2FN7OomUy+svkyLyGxlUMJVo3yG9M4Xmyvjz6AWwqo9iYKPRFMHVm5V2sPo+w31JoyIGLX+PiaqSMvAvv1vYn1nEyXWKxLJXiDEWBmzN32+X1aTCmxEr1LEfy9DxxcUQWAd
 D4Q41+wI
 lr33t3tWjki/S+ybKXLwEL6surZq8pcg/FcIvKQRFfib1aj/aaznqlf8NKhfkPxkwuYVTwAIVT89kFNPJNEZQewaQR4/SzyXoXC4b2SP8I4HRo1lt0FJAa+bHtgwPLztyEloxquuqPLnpOWC4v0MHCK43RftNOhjhuIJZFn50gQI4yCPmjX+Nu/1/o1C/ZFm2OzagrWcG9iIefMBQJBPAeSc6xB4ZYOOWT2XH7mC0lCBEdyGRscSo241YccfdU6yxcAL9R+7HToTx77yj7G5sLA48cNv/G5EA//4BzwQP5tSe4ghtxoAfA2J5IcMd7Bfd1b4DRDo/RIl9oXwZT+vtQUSkCMDr/IhrjoYE1COkbsfm/r8w/yx88DhYqLkq7lYmVEJMaP0X3TZ1ZcIGGLf0y4/cpVLGq91kPSzPyoL7LDzt4mHe2Nv24ZBt40uHZWQDhmDnKQLUignZzpcomD+Vvamgh9Ogajd1K5CLm1WaHYHdobSfrsMNyNnulRaLLX+3jeHuxYk1SSuoKN8KaC2qTdZO81leS9+Dlr1VHkvz2YeNdP9tEUen5GErWRV9QlIS6emk86x6Ddht1XJU/0hJS2qhWSKDYZtpv9nr/LPj2BG/0TzV0FitLFb96DXETcEI69hHn6/UV+30MbxQ//5bkJKaBuOPky831dpSk0KGDYOgkIQyky/1xboui3Rk79F2wSVyJlRCxtph82E9K1Zoz1/gS5e2VU4buf7oqNp2oRZFaQhKMQ//u4HWtY5hcr+zAGowVUh7490ymwoRSPr6s4hKXJH6x7UsVzwDt3+5zjX9jUDi0FdSkQHoLJ3q4rfGosPWf/Y+Ieonuo8Oyjn5z8arIpUigs93kwSS2a6ZTaBoyDTtNmKnATx9mnKw8w5AFUMknyXC21eo3yq9kPuUR0vfCx4/QMPdgFMQAYQpq+E9BmUcF3THAqjYvyVs0DMwVYkZIvHJOy0Kx7wXg2+OlNeKiGBw
 O19Quj3O
 juYaI/MDRGwwkJG0UkU/DlMEA/J8NsMndLza+lhMU6DAxkk0yljWVYZB+SBMP1iCNoHdn4deZN1LJWul+0u9f79g2NmXufqINhXEzuJzIqvUi8ot5HrHKqHhPxV+nSFcHGhHLmSpHVatgI5I9FD9IAgt1ABfxEG78R5opPHZz+lHClm1WJe2GPZUsviJb+ucrF/giRW0gHp3styJ+trcS+Ne2f3xAd3pSavs6AXe31nR89GqOkYUfUcDZ9uolEAVSFeH86w2gKZRmU59pAPTEfcwYBp2WAGj9sV8Y9+VEkvnDuDYeiMIK4Sbm9IfJdpxpk4+AZCFWKhAo8nFRkXXWhiP6boY0JgSI1W6evwylJkB+0ALkjxcWq5vPpFkkJBTrzGt7EwOBDxFyV7zNjNvkUcCCPZKGCxltdfsDYkMc+gdAks0IEFRBfNCJM8qYaH5MQQACCTye7Jup7JiMplNcpI2/O4Vg4nIllgnFqp0yJgPO6pF1tkHFnJKT2tiENN8S9kJdesz/FVxOKAmXInSgKeiLTcHWIVBlXfhh8CsCd+8994Gzm0nFxlpqvfFlXTQjUpUu0aytm6TvSez69x7/Bi5WxVOPoCIyLP47cswEHk+lsmD+s086viexkfEAt16eV7CaCD179WGrp16Mx7m7e4QgvHUihd8jhJYksPFZA3R7EwENKFnKYFjSQSPDdowB+gqaH2hellUzYv/5hNKAiMIF0gHJUFemwNWeL5K9Qo6g3GjFPai8tY4ft0hz6p9NAYEnRU12Scgcab1d7yrbJPRhIXKrESfW1X92dc8+UVUAIoXRp7eJjFAueaOjDbxno3SIFxwfLnWrCZTfcOWQHlVsl6PvlC+zqq+ijO5TdAlQj6KHwj4XaigmhjsrvgbNixt56/EZ1YC0Ud5hpOumX2HrZ7xEAksGANfgpHN044Ty5aezt8qefaYfjiOflEGxdOV1/FclUhEJU/WHY8IaXNyC4B0B
 K/Vmsi6W
 59Fa0gfKASHb6ARtJZNdFZ5c/XrxiyjGaHr/Rzi8i2Kcy/Z4A6YqdAO6P/oZA5OCMFDFFYGja83K20Ub16TM+jBSgaUnB4q4Gw8XhBPgR2PNpTfdMgHxCfGH01HZ6dXMCN9DN2i0uSSIIA4ef2Dmb200oo8Q0a73shCrZXtOOIy0MPCr5Rs92k1w9caG0uwxSnWYrS+4UwiWOLEHlaT1U4NiW3ndWHe2MplFzjeQj4qLqe8p3/G5UUb6gSGoisUqf8+aGmcstx6LbRUUoHvWPD70EI8rBeoWsuUO9MHEEpvf7cpdXQohzc5KAmO4EL70YxIF8R5l6Rw4nPdSzyG+mYQwpGdwa984VbMpRckjcu4NjUJBosLKsvtFcsM4+sQp0jenZf/6vQh4IsrbLnr/gIZHZmSP6tCAKXgpdPfowhnyP4NyWQfAOPgt/35fh9i6+kXL4bXCjPM40fGm8LNrpxJ35Y3T51N0pFqUskT+2/Nl+0WwpfEJo5HI+1CPk4QDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-02-26 10:55:05, Jeff Layton wrote:
> Update trace event definitions in VFS-layer trace headers to use u64
> instead of ino_t/unsigned long for inode number fields, and change
> format strings from %lu/%lx to %llu/%llx to match.
> 
> This is needed because i_ino is now u64. Changing trace event field
> types changes the binary trace format, but the self-describing format
> metadata handles this transparently for modern trace-cmd and perf.
> 
> Files updated:
>   - cachefiles.h, filelock.h, filemap.h, fs_dax.h, fsverity.h,
>     hugetlbfs.h, netfs.h, readahead.h, timestamp.h, writeback.h
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

...

> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 4d3d8c8f3a1bc3e5ef10fc96e3c6dbbd0cf00c98..cc7651749eb3ce1123cb3ea9496f0803a0f4c1a0 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -67,7 +67,7 @@ DECLARE_EVENT_CLASS(writeback_folio_template,
>  
>  	TP_STRUCT__entry (
>  		__array(char, name, 32)
> -		__field(ino_t, ino)
> +		__field(u64, ino)
>  		__field(pgoff_t, index)
>  	),
>  
> @@ -79,9 +79,9 @@ DECLARE_EVENT_CLASS(writeback_folio_template,
>  		__entry->index = folio->index;
>  	),
>  
> -	TP_printk("bdi %s: ino=%lu index=%lu",
> +	TP_printk("bdi %s: ino=%llu index=%lu",
>  		__entry->name,
> -		(unsigned long)__entry->ino,
> +		(unsigned long long)__entry->ino,

No need for explicit typing to ULL?

>  		__entry->index
>  	)
>  );
> @@ -108,7 +108,7 @@ DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
>  
>  	TP_STRUCT__entry (
>  		__array(char, name, 32)
> -		__field(ino_t, ino)
> +		__field(u64, ino)
>  		__field(unsigned long, state)
>  		__field(unsigned long, flags)
>  	),
> @@ -123,9 +123,9 @@ DECLARE_EVENT_CLASS(writeback_dirty_inode_template,
>  		__entry->flags		= flags;
>  	),
>  
> -	TP_printk("bdi %s: ino=%lu state=%s flags=%s",
> +	TP_printk("bdi %s: ino=%llu state=%s flags=%s",
>  		__entry->name,
> -		(unsigned long)__entry->ino,
> +		(unsigned long long)__entry->ino,

And here as well? And many times below as well...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

