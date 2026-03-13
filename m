Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EE8107BCDF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 19:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F216D6B0088; Fri, 13 Mar 2026 15:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF326B0089; Fri, 13 Mar 2026 15:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86F16B008A; Fri, 13 Mar 2026 15:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C64446B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:22:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61C691C10F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:22:29 +0000 (UTC)
X-FDA: 84542011218.13.9519B6A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E39EC1C0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:22:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cwr9QvSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K+U59XI2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cwr9QvSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K+U59XI2;
	spf=pass (imf21.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773429747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEZDbFbdaiqtR0DORmYiMySif6us6CTI89GNtF8koIU=;
	b=8KLMhBwfSbbX57tVqWZHI9I7/mKEs1xjp4UDLO6Gm3nk2Fi5kc5xabD/zSOxPUnrWe6wj2
	h4DfDhOBPWXD6dKaaJWfw/uL0ZKSPGLbAliVw8oWa3SA7h6Ixb7lyhwtZDJpfUZe9QzGcG
	6GmKzDdFWs/+xEBFlcS/x2bAkh44Of4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773429747; a=rsa-sha256;
	cv=none;
	b=oy78UOJjAJCCdntNVUcunoxfrUxpgqxtA83RY1v7qlJW5W+81r/1Ke84yWB8aLk4Y7Zdo9
	kSBhvS+7g38O3R6s8Vh+y1fFqksOGHvHiLnQWIW37WigtgRFPR+04+wXl4jUdPbAKNfpiM
	WJ0gaAQtZro2QaR8Yw94REHYUJzN6Ek=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cwr9QvSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K+U59XI2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cwr9QvSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K+U59XI2;
	spf=pass (imf21.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B208C4D943;
	Fri, 13 Mar 2026 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773429744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lEZDbFbdaiqtR0DORmYiMySif6us6CTI89GNtF8koIU=;
	b=cwr9QvSbf3addifFtJFaEE3S5jwqDpZlb749Rs1kTiqHHQe0wIw+TMnTma/8mfA3QiWv+t
	IZuKpLsIb+k3xwyZAXuL8F5GTiyGUJh1olDjZfpDExV1+UvdVwgZIIojOm6APRysjO8/lt
	9WDXlxlJVmMpUXoO3id4LXjiv7t5UI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773429744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lEZDbFbdaiqtR0DORmYiMySif6us6CTI89GNtF8koIU=;
	b=K+U59XI2u6gqS+yANGWtG/Pii/V0SpIQQ7wMg6BtOp5KKFcWyvgFtoDkwX90d0NOWdybeR
	Ua+tdtixGZm/opAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773429744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lEZDbFbdaiqtR0DORmYiMySif6us6CTI89GNtF8koIU=;
	b=cwr9QvSbf3addifFtJFaEE3S5jwqDpZlb749Rs1kTiqHHQe0wIw+TMnTma/8mfA3QiWv+t
	IZuKpLsIb+k3xwyZAXuL8F5GTiyGUJh1olDjZfpDExV1+UvdVwgZIIojOm6APRysjO8/lt
	9WDXlxlJVmMpUXoO3id4LXjiv7t5UI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773429744;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lEZDbFbdaiqtR0DORmYiMySif6us6CTI89GNtF8koIU=;
	b=K+U59XI2u6gqS+yANGWtG/Pii/V0SpIQQ7wMg6BtOp5KKFcWyvgFtoDkwX90d0NOWdybeR
	Ua+tdtixGZm/opAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F14A406AC;
	Fri, 13 Mar 2026 19:22:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6cTyGvBjtGnfZAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 19:22:24 +0000
Date: Fri, 13 Mar 2026 20:22:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 02/61] btrfs: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <20260313192215.GH5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-2-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-2-bd63b656022d@avm.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspam-User: 
X-Stat-Signature: tihku9qdbygagog161rii4pt79utp7tx
X-Rspamd-Queue-Id: E39EC1C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773429746-761248
X-HE-Meta: U2FsdGVkX18e6FFSfoL0iFlxJF0W8XSgZz0QynGMZw1YDztzrtaSEx+wilSIfqWblvluSKVUnF305uunVfpQ3jh3doYHLBMboQ2/DbV5wvoZ9mlxtNQDIXgDTYHrW9qQ48lpFEW28lK1l5T6pgSdLU1aeerSr6monItNh06Ih/Pxn2Yvjv3HgYBlvdiEdK3W6tTtHjpO5kMe1xFpYRwlFAocsfoz2eWq+WtdldJUD9ZLsKTtN6tP6sa2JXrj13jpTQZJmIt3D8mx0L3978RueZWlf0txBpF7x6hRMefq+h/RWm5WkFk5Zv+ep23XrYK8P6z2rpVhXALd3uyKI2EuzxKuf4RSJGwJf6/D9dOMtO3B6waIpzmX+Pm2TM7t+hAp/ebxT3qilQEEpz8IwwqvqEgn6LAPnAjG7Q3nTYNWWWw/NeNF0glXXByj8hCccPYQooKgkjT+Wd/iB+npSAf9fI+n65iN6e8/G4G6PWvePLEzSNTfShSAXR1lvzWBMZjJ5/FLVvQZu2x5LgWRp8bW4gD1A1qkps/skPZKjRzDhw+PnSD0UCZmNUnQSDCYs+g06yMjQVG2PKv2Jr9zLPd8WNKw76u3oZi9009gTFpcEgarkchaR6m9fEp9wwntKblwpbX5Fi5pRzMaR9p83473liGpEJ/8wBiq2wtFZh8xM3Xp/Jt/rDPYHmVNPMWLcWGaXmTfK59FomUP74B11GOL6IFTJs44hqpzicZ/Suunj24FCqoy4aG+irQ/vo4YOnbTS0JpQnc+AfySPnofiDCLMBwqbzxypOX4f8Ag1EXrmHhkG19mXXwjhiMGTsl2KstYNy5dYdlhfu5QiT6I3MS/HYuBQlxMj9MdNtv0E83zeecO3JAKLFGHaLTxnMFjYIeZ5BMru8Rq7dieMk4LPhoau2LP6BI8wq25Cnw4iOaKb57KkuyyoAKKaQ6fOcR13BKaBX4wAuf6j8luZP/dlO5
 s9daMeBQ
 +hi9OJs9bTzGiRE8+Y9iQmU/pno+w2ygqiuy0F4GErBaDiMFyxqSUFT7a3B18A7e3GmHw/L1QralfGf+triL9lcSChbKVVjlG76Og8RieKd4t7j3u2O2sqMaKXPJLJJD75wIixxP0vak1WklTRn5sdXqwEDqKDZae486f/9o/l3PqUJ6sHKRL6ODeqOaforjb1imXMlLZhsDzBk6AtEUOFEUMyRB05dEJUN6vwmbmbPhGWdzTzrqCb7Bi8XbSZiOapHG8t1MnXVrYyjFSa4kpCwu+auv4ryWsmohB8BKSGFQw07mLZICgNVHJkS/ZaFNCJqySq7eOSVnPS6XhPZk8YZoxia34UMRuxgjJhAiA2jnZUJW4t3qGIz4OBdK/CNcwZjMw3r4Bpyt/lcVCGByR9XpLOeSb012hx0lmXQM69sagQmoYhtGiFMmWxpKFH/mEZoB4c0T3R2nEw3iD+9hqpPDahf76dPnsu+SofYC5aGDmJLhZwio3n0tp/NdJtRSdvJ3y8PQpnNCI8f+HDXw3adZr1RL0mOjTNsZk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:48:28PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
> not like nesting it:
> > WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> > unlikely() internally
> Remove the explicit use of likely().
> 
> Change generated with coccinelle.
> 
> To: Chris Mason <clm@fb.com>
> To: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Added to for-next, we seem to be using IS_ERR_OR_NULL() already in a
few other places so this is makes sense for consistency. Thanks.

