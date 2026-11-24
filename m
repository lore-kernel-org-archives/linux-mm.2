Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C06606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xRer9G1j;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xRer9G1j
Received: by kanga.kvack.org (Postfix)
	id 1C5706B0692; Tue, 24 Nov 2026 06:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1276A6B0693; Tue, 24 Nov 2026 06:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD5F6B0692; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 343996B0698
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D21A41C44D9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.23.42FACF0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6CB010000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xRer9G1j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xRer9G1j;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521549;
	b=FLun/LQLbWhfWouiw/89O14BNLpj68EJZJdwKPS1OQ14+7wg5t8vdOO3Mft/++yXwi6uZc
	ZT0UoqADnyjX6YmFik0S7nUc+6L1uOTv/cPjSR97jN+ArA8mAz006dtKSybsb8L/0XAxlm
	fYTCzkOgQGOIguyRvUUTjMhwBgEXrxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A5M/4CSKr8nGu+5ll03h6CgMljX0Z2g/Au5Ni+hqHnw=;
	b=quzp9Ama4Mh0lQVVVjKUXGj1YrkjaAykbQ+s6At0Ct6O9BniIx0FLGt9Ai3E773zzOmC2Y
	p4z+VAARXH1JIuB3aekHnAqiZYw1CN0vAEcm95n89sZcCGFfxmQtLdqUGbUpGWQKV0inS6
	o9jWZCumPppKOa7NecKi4uQVNiUDos0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xRer9G1j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JdBKj2Pv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xRer9G1j;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 779351F461;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5M/4CSKr8nGu+5ll03h6CgMljX0Z2g/Au5Ni+hqHnw=;
	b=JdBKj2PvvIFiJtcB0+f3uOz3KNZq/jMavvFFBrWS88l9zObHP/XJ6RPAdksxV1uT8kClRo
	jonXN3tT47IGw6SU2v6Kw95eTUQOSMFw5Het7MTs5V+qY8ZpoZWii7h4uEdzx+t6HZfQyn
	6DYrbyNjFHrXA/cZyIfEnBaDZUJiZV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5M/4CSKr8nGu+5ll03h6CgMljX0Z2g/Au5Ni+hqHnw=;
	b=xRer9G1jIXuMJTrfH1aOvDFt5r+PR+ul+5agZIznkavZVrNmDD+ubXuLSSelXqonKX9Lsb
	zXG/gBpK5xMr/aBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5M/4CSKr8nGu+5ll03h6CgMljX0Z2g/Au5Ni+hqHnw=;
	b=JdBKj2PvvIFiJtcB0+f3uOz3KNZq/jMavvFFBrWS88l9zObHP/XJ6RPAdksxV1uT8kClRo
	jonXN3tT47IGw6SU2v6Kw95eTUQOSMFw5Het7MTs5V+qY8ZpoZWii7h4uEdzx+t6HZfQyn
	6DYrbyNjFHrXA/cZyIfEnBaDZUJiZV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=A5M/4CSKr8nGu+5ll03h6CgMljX0Z2g/Au5Ni+hqHnw=;
	b=xRer9G1jIXuMJTrfH1aOvDFt5r+PR+ul+5agZIznkavZVrNmDD+ubXuLSSelXqonKX9Lsb
	zXG/gBpK5xMr/aBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F21E13735;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NUC+Jwp8BWtIZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CD14927845; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8 v4] fs: Deferred inode reclaim
Date: Tue, 24 Nov 2026 12:58:44 +0100
Message-ID: <20261124113450.3451-1-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3928; i=jack@suse.cz; h=from:subject:message-id; bh=vFlN+gOu+lwPK4zJC6DbpUxA92Homwwvyd6ieE8f8ak=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXvzR/XHjfH8JoZew1OdN4cZLQj37dsmNL8sv lX+JQ4zqiGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV78wAKCRCcnaoHP2RA 2ZX4CACjsD8u1El38f2w21opVlI43GwddTRfb2MkTqx5hyR8oJrg4MS7AIMMWU5LDBaqyvsrBws sRFdvtYhyPB3yBnFo5ts+lxOhYmcf28J3I8IszDof0lZjRCOxCSkYpu9Ckd6wXEjK7tgAbPzWzY 3mGf+PQg9oVWWEn83GgwWWDXb2B3iTWy84Ap83lsAEbWEL3X0pG+MooC8M4t08F0TAAz4YUY299 l3+0O+06x8fjjlkb0Iu2IlVHiurELCO24g3/QLEBHjfkq3YsfeOh1/oNYqDU2Kk794IkxvN5sd5 i/5jiiucQXyDBWlZnFHL48QCXGex5mWhxIlDAkXUk7iu5lql
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6CB010000B
X-Stat-Signature: nybwysphfy5k7ybjfhtaj89doaakbyo5
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795521548-534199
X-HE-Meta: U2FsdGVkX18x7JulD2uVvhy7JfFHY+hxnGI/NWRtTWQwXkrCDEjZ4MiW9pyByOgB7VqXu3OmP05vHpHUHZySFNMUyX/nQ2Wgkmq022o92CoOmxaYVsD64bHEYiu0Jxln4lhJlufx0FR1qV0igrnb49XdHmmlBAhV9Yn6EEdJIt7iQcY7SISNMyJ1tEgUSxsq0fRBjQ1s3U/y0MzC9yy/VFoMrvWpiYqC3+UvFzkgvQX+T58YTGGBCl9P9mnoMyz6opu6j9fQi3dkDBbV4Q6aqB0AD0eohxA7nOWJ9fRCMPk9yS+m2SRYgEqJdZsqIpApfOV+Vkbpi92k9z+8B4hH3kL8Amdj6sb77uI3BVKsxGQO0rV4qA2tDPwjV/p/kiYEzCswZC0lvgI43AEiU0OA1v/ar4YV7D/qhLPV0/vzqmpfOjQzAD76ZpejVqGBUuER4U90w5uyQKAHSX1sYYNzfGGoxNOEar1XWLQ6ihbKVCt3txCDUcekL96rDz7On9/uIwOKQFH0pH1t7UwYy8IyvkOBMlhQEHjm1/SFhxN0gta3tu/PMMuL2FZHwZIDV6FeSrIAHNutFuVrhl2FdhLty33x6fWlm0J/48o3Y5yd0K7rgZrvOIz0HckZlIt4AEstyUBkc4VXBpQSkQ3d2XdNkgMx7aT9eSemoZeJ+tuZeJ2amRtyXxMeZmYXrckx2U+V1jkXwidGYqczaS7sc/QZfJj8/gPi5eEnKsSxvSfggMWHmw/3NJOeGs2e7sqxuvYkShyx6wFXof42gbg9BfmIydc5yqGDojdZEBgZgspfzL2Kkj4snoWm2YOhq/bY31aGmF4mvt5k0wwRXSDIN/O2iBuvuDKpT1YinbpI62u2ARvHWYwi2iQGOSrMDDfV+J2y+cAh3s97DAKXumAs7vSleDRuLF6Bdihc2EVhl4fhXJw997Unp+NwcaVsrux0iJjdiPPZmbXX2MHQYQPc6cp
 V6feEaFe
 Emgrxg6KLyAObviqaGUSE8pEMLL4nmp8Su3K3Xs2STFmO7gLcQMnx4aHu+QxefQOAuzClr4NGCk3nRrqGihypr3XEhYCYEmYGZ7P4L88y1KPTRnxzDKKXpOLgWou3NTpq0jZKOg3rEDYXRNdqH9SpjKUodPJlaU7j52iLtmGWikB8mX54oQ5m580KNNdpV80ZSx1p7fEyn0c5bnWRgIR+pHauWvEdlxiPYMfMzbduUsrv4piP/raw3pFxzSkgTiPXMCdPYoAwNkxBxd45z0r048w+kTvaIJuvd1yueboHNMOE0nbw6txcCN0D0gv2s19UL0/xGqquaoSs1x9JC1Fcu0dodHjh2kZ1eUusZa7uDCoeKIkIfP9lun8n3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

here is the fourth revision of my patches implementing deferred inode reclaim
to deal with MM warnings due to GFP_NOFAIL allocations from reclaim paths. This
happens because to reclaim some inodes, filesystems have to do IO including
complex operations using journalling and forward progress of these depends on
successful memory allocations (which is impossible to guarantee from reclaim
context).

There are two notable changes since v3 and that is tweaking of the logic
expediting writeback of B_DIRTY_TIME inodes on last iput() so that it works
more reliably (even if the inode happens to be currently under writeback). This
led to occasional generic/622 failures before. Also we now automatically defer
reclaim of inodes with I_METADATA_WRITEBACK bit as Christian suggested.
Otherwise there are couple smaller issues fixed that were spotted by Sashiko.

The patches have survived full fstests run on ext4 when marking all loaded ext4
inodes for deferred reclaim to stress the deferred reclaim paths. I have also
tested (when marking all inodes for deferred reclaim) the patches by creating a
memcg with 128m memory limit and then scanning from 10 processes 1m inodes in
total which heavily exercises deferred inode reclaim paths. This also verified
efficiency of throttling of marking of inodes for deferred reclaim. Basically
we cannot guarantee any particular limit on the number of inodes queued for
deferred reclaim as that is bound only by their number in memory and memory
pressure. But as the number of queued inodes grows, the tasks creating them get
slowed down so eventually some equilibrium is hit. In my VM this was at ~10k
inodes (only slightly above the 8k limit when throttling kicks in) but this all
very much depends on the reclaim pressure, speed of deferred reclaim etc. so I
don't think this is some representative number.

The first patch is a pure fix for a problem I've hit when running fstests.  The
second patch deals with lazy timestamp updates which I've decided to handle
better directly inside the writeback infrastructure instead of deferring
reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
deferred inode reclaim is there mostly as a demonstration. Other filesystems
need to determine which inodes need deferred reclaim and mark them as such
which generally requires good internal knowledge of the filesystem. I'm hoping
that once the infrastructure is there, fs developers prompted by MM warnings
will start using it :). I know for a fact that besides ext4 e.g. gfs2 wants
to use this infrastructure.

								Honza

Changes since v3:
* Improve logic to expedite writeback of I_DIRTY_TIME inodes to handle also
  the case when inode is dirty or under writeback
* Defer reclaim of I_METADATA_WRITEBACK inodes
* Handle kernel workers when throttling deferred inode reclaim
* Fix memory leak in throttling code
* Fix synchronization between superblock teardown and deferred inode reclaim
* Fix synchronization between superblock freezing and deferred inode reclaim

Changes since v2:
* Some cleanups and simplifications from Andreas Grunbacher
* Fixed couple of bugs pointed out by Sashiko
* Added support for auto-deferring eviction from iput() when inode has 0 link
  count and we are in reclaim path
* Added protection of deferred reclaim from filesystem freezing
* Throttling now doesn't happen directly in mark_inode_reclaim_deferred() but
  on exit to userspace

Changes since v1:
* Multiple workers to reclaim deferred inodes, related to that I've
  moved lists of deferred inodes from per-sb to global ones
* Added missed lazytime sync fix

Previous versions:
Link: http://lore.kernel.org/r/20260429174850.18223-1-jack@suse.cz # v1
Link: http://lore.kernel.org/r/20260911081309.14137-1-jack@suse.cz # v2
Link: http://lore.kernel.org/r/20261009133253.20102-1-jack@suse.cz # v3

