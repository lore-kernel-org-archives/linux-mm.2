Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A53F1C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF256B0093; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747AB6B0095; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636956B0099; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF166B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:52:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF6E312014A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:10 +0000 (UTC)
X-FDA: 85200864420.29.1B4412C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8AA62C0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kXPTGl5e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xHmQSVr/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=evBWxFs1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rvWH5mkw;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116728;
	b=lh9iNtnQtiub9kH5R7TOxpQbKrO7nS50EP4fEGDi8k7yJ4p5IU3pxDvNwoCQyd1WugXKJg
	7Yhmr87bmoLiVzt551EOmsbFt/R/giboARjvh0imaN0bukemjFXZdpxb3v4dAgwtd+Arq6
	s5uY80jO5xyOjskvMul8dul7JeTnO0I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kXPTGl5e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xHmQSVr/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=evBWxFs1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rvWH5mkw;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z/fxdm5G9XKt+9Xe5B66an5zv6QkeOhmXsJC5MEhbuw=;
	b=sSLRiKCezOKLsH248pmV0eMxxbeI4yJ4BssIsDidEmmAF44fPFBytaivJWTG8M/WL4Em1l
	zaMlRq/fOSx81DCgkkG/A+7JuXsl8VeCwdEut+7dfozPQo4+YTZsxy6A7FAwiW4fUgVrjG
	pGXP3O9LAUZ60w4MuQ9DgiP9RB9/Zzc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E7501FA79;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z/fxdm5G9XKt+9Xe5B66an5zv6QkeOhmXsJC5MEhbuw=;
	b=kXPTGl5e+rYlxHfO0P9FQozWKELvV0LwD+8X2jT7frkWrqIM209HQW9rPQauE9P271cEaT
	Wq7LbstPEoKMqgY2dkUshCEwNPfBs4v7kcFcs3bQCTDuY+ZPBXKysYLWYVPdzV556BqzFP
	p72anasTR/gWYUqBmmRMzSa6wki7DOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z/fxdm5G9XKt+9Xe5B66an5zv6QkeOhmXsJC5MEhbuw=;
	b=xHmQSVr/TeosCGnXYpwj0W5uOB97er5y8BmxqFjw/NvnaaJJ1vxG11hHdeEaS3fwSevCMS
	z0x/bD7/GmB4bmDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z/fxdm5G9XKt+9Xe5B66an5zv6QkeOhmXsJC5MEhbuw=;
	b=evBWxFs1LnY87IdpSVJgOaS/D8Phaa7+eUx7GiEj5bpxhfWRkkSdgM6YNz5f098TJ+R/yO
	ILaPlIEhUXt8Ow3ryNJS5+bbvRzb6U38SZGU1kniGVs2BVrPAjLK4XhGosqP7Uf9NU1HX7
	hnekQJo8Vs5pY8MkC1Uk8sKMIXwzb5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z/fxdm5G9XKt+9Xe5B66an5zv6QkeOhmXsJC5MEhbuw=;
	b=rvWH5mkwo67z+qAwNpiJ+H5kRi+SPhPSj45nS2zLF/+6XqlJUl0tZafjnNTbPPii6BYrnc
	gx+k9j2lr8h2UNCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47BB413715;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BQVyES7Bo2quHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 08:51:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BF509A1342; Fri, 11 Sep 2026 10:51:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5 v2] fs: Deferred inode reclaim
Date: Fri, 11 Sep 2026 10:51:36 +0200
Message-ID: <20260911081309.14137-1-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2552; i=jack@suse.cz; h=from:subject:message-id; bh=qb2MBAqTLT1go2FYYfHVi1Q5zbydQPdUbAmNs4JQD1w=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqo8EYxl9zKGYzitP7Znr2SZL1VlrMOl8wBQxgu rW64pldoMiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaqPBGAAKCRCcnaoHP2RA 2behB/9mDlFKMai+yJJQedPJanFbltFjkJM6Op6ouyQEjMT2YYFuz6FT81zQOTPZ7/JZYdLtpOr R1YlWV91z9LkSS9kOI7nF4zBGqhSnyelaJ7F2dmv6KCzM/K10mLWymCwjcJtuRHKBx9NnAp3Rkp zKfs7+Vtruv0tOERt3oezMvsYE2xIj5NogYyeOuwDC+TexDzVyKnlUuknWM6lUzGLKAoJs3IoZY qdokUf3VlOiT/Do8B19eF8M+7MJmKTBUAv/+9s75EDfN+DPq8r/RvX2akoeByfVGRwwEie6knkY AhfQyviILiSkggdja1Kw1lJT6sji9vNXEP8xQ0/JYaUCO52D
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8AA62C0002
X-Rspam-User: 
X-Stat-Signature: qtas7ai4k6i3a9tgttixzsrb5x1skzim
X-HE-Tag: 1789116728-503260
X-HE-Meta: U2FsdGVkX1+swOqMr7CN3RsRlwbYlIQBUMM6qZwtEfWy+6P4aZCRy9MIsMzEJVTGHKwjnv5FoYZ+yj6de3HY641u7IUnyeygrD4tKBOzmpinUwj6wfysYMAjPkX7v+eCJkDrQpOy2EYwt+KIDlTQ2aRGviZToeM82cjZj/r2je6Nu326IomoOdBC2hmtazaNWskTEpIKkD8XyF+JBXxpofOKy028rD6qe6IG5xVqOJXhkLA2xRvC67PFd5RYQGu1U66Z22BcYIGEvxspc4UcEKnLn3mdQ9P2fnbfDKEsXF56ZvX5kuYZdFTsg5hhFcpZ+mkg7DWuWFz55FhOH3dN9zFyoMLzw6n8Hbck9nAexR/Dbg2Uw0tl9yAFuVWSSY9GcJK0Y6jbQy7GiRtnLNxN0bopazhylAVyuyFocVdOgkL8WnvBjaILA3XHuK+1tbKcbX0KWpWwUS+u7B5nUCIO49PoLBR9mKro/uaRSiScLFUodNyMN7oLPfUjvPBl3sjancjSGkrTyO0oCFM9XXXRpgxFKzrMEFPCnpZNs5NJsMZ4mrddSB3AVxAphlh+iy45IoKnoiGk1FhGEQANEhu9QBxED+6vwio1QkzWEHmgHFkE4Ka2MHpZ1iTPxHe7gAKjqLF2dmsZTUNpyKG/EIRfEGJO6K4najw9lC2+G9Aw1i43JFctsbAGlBBWbQ8zlou1w4VxeU6rZoiIS1RbuME2es6NTrWGXDt6GHOr4YeopRw+oiTwyQrLkwMVn0NAAH9m3NuCGZtOxI/wYpoSHa1WXutyLeIldwJV4UOHsoZwASzgHQmht9HAfRsUhkrSkQxf7dpmFfrRuJRZTrrW6KDiSRXtHxXZhr5ZZxknvUnj6VrQWh2Lw9JKPubEj/Rso8iUsgxsTRBEvTA7DZymewJKeRRkaQbfUJHj0BUz8ltJlaNeywrK5TRcWzYxe4YFuNuzm71j7sYIz32XrDRBRQW
 B5sfeDM+
 h9UfFWgqyoDvecGfrzVAu0VIZYYdSSTVSmY8luz1bm2yFNoe1cLC4Nulu9pHxvPfe3c9hCuqMFRzmWSR43PZProokG35MNDUTxV/UsRfuNef523pw+O/THCQsjFY4ettPh4aRKY9piPwbzBZ5JvIE+6EzH3PQV2F0us9wym+VXd7dDEabJzmsJSe329LD95ih966m9feivtqtV8WWwfkSwGY04otCOvw8DH+hEwvwK6UGmfOaPjjnzEKeprBtVhkupT5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

after a long pause here is a second revision of my patches implementing
deferred inode reclaim to deal with MM warnings due to GFP_NOFAIL allocations
from reclaim paths. This happens because to reclaim some inodes, filesystems
have to do IO including complex operations using journalling and forward
progress of these depends on successful memory allocations (which is impossible
to guarantee from reclaim context).

This time I have fully tested the patch set. In particular it survives full
fstests run on ext4 both as is as well as when marking all loaded ext4 inodes
for deferred reclaim to stress the deferred reclaim paths. I have also tested
(when marking all inodes for deferred reclaim) the patches by creating a memcg
with 128m memory limit and then scanning from 10 processes 600k inodes in total
which heavily exercises deferred inode reclaim paths. This also verified
efficiency of throttling of marking of inodes for deferred reclaim. Basically
we cannot guarantee any particular limit on the number of inodes queued for
deferred reclaim as that is bound only by their number in memory and memory
pressure. But as the number of queued inodes grows, the tasks creating them
get slowed down so eventually some equilibrium is hit. In my VM this was
at ~10k inodes (only slightly above the 8k limit when throttling kicks in)
but this all very much depends on the reclaim pressure, speed of deferred
reclaim etc. so I don't think this is some representative number.

The first patch is a pure fix for a problem I've hit when running fstests.  The
second patch deals with lazy timestamp updates which I've decided to handle
better directly inside the writeback infrastructure instead of deferring
reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
deferred inode reclaim is there mostly as a demonstration. Other filesystems
need to determine which inodes need deferred reclaim and mark them as such
which generally requires good internal knowledge of the filesystem. I'm hoping
that once the infrastructure is there, fs developers prompted by MM warnings
will start using it :). I know for a fact that besides ext4 e.g. btrfs is
hitting MM warnings in inode reclaim as well.

								Honza

Changes since v1:
* Multiple workers to reclaim deferred inodes, related to that I've
  moved lists of deferred inodes from per-sb to global ones
* Added missed lazytime sync fix

Previous versions:
Link: http://lore.kernel.org/r/20260429174850.18223-1-jack@suse.cz # v1

