Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3F9606A8B5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13086B05B4; Wed, 11 Nov 2026 10:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB2F6B05B6; Wed, 11 Nov 2026 10:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9273B6B05B7; Wed, 11 Nov 2026 10:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 735286B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:12:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E906E1202FA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:12:08 +0000 (UTC)
X-FDA: 85423178736.26.A7A9E07
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id 534BD4000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:12:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dehBO8Yxo1qlGsyLOmGqdqT0CExk2sS3MX1Vk4oa/6A=;
	b=YqGVARWdh/IOcKSziz57KCucYR2fVQq8JMmwjKd5Hh2x9sS0dMIeXpq+oT9Q4rq/zagmxR
	uqIJR/1NvebUdR0QQpLtysnixiC/js6687jO819oPcAorujE7foXrIt/RertPo/BcZz8kz
	9u9xrriucJQlwulNHO7ielmeTpt8DWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409927;
	b=squ1ocC19GY7niEQi7YJoNrzLVbH8K77jpGQ6/9JvAX4shKfuxQTTJ9wHk4pgwP8zmP0Hk
	JlM18lm6J2aUamPoIIpGV/u94qTgk4Or6C3OZiEap+1Kj1wB5prwpn1NEwG/nMQvoO9U8Z
	O8sBs1ExLzvxDoagzjIgcN0zZU9u/Hs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52A7668D16; Wed, 11 Nov 2026 16:12:03 +0100 (CET)
Date: Wed, 11 Nov 2026 16:12:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hg9wifz8dx4scjxn8su8derizgqtmkot
X-Rspamd-Queue-Id: 534BD4000E
X-Rspam-User: 
X-HE-Tag: 1794409927-286865
X-HE-Meta: U2FsdGVkX1/w/5gcwl2mmGiJ/uMb+l7NURzJMP3IKTd8Tjd8tIBgMnXYY/LvZmzVU73mfvGweQGx9n8EDv0CGlwYORnGaLm5oZbwULAfLvv8ItP8nklAYDfWKtxgIJtvOrVImF925Vy+MszmIaVg1pEQhk3REmWkqNYJ12yCqN/Mv8K+ebnals4Or0zwfizvjAFag1AMQ2ToVQ6a8JU/yXB8zDqil9Sjved5gkqNqAAG6mPGMeNmG/y3I3FDzcNWVJVdgXO7BbrCiDJrt67ipBOWuF/v7WQZfrVOlMZ0dK2gtSuxUjtASvWF3/UmEeHPFN2qtrlfMgygjViKqR1Ox2Y3+u4HFJg3qVJ0zCz76CrG6O+7NCLwreU6a4ARy32a1/k1UpZCni9t/Nm0jAEucIf2OcdXB3uHfzKc1no1ADh6GH2gvttx+TALCnSURyQCdtLfb1EyA8je1oWc6mRVP62lX0X97V3aJD9759DkVNIdCfw5/CpH8FAm9j/lYbis3Lm3+54wey8anqZ3Szz53Ern6tX4BFbeuAu53lomdaDDLahy1E8c0tym5yDQWAacs2LJZ4fFRiqKmJ4XUjxRgbIZEsxhp89Zkf660/daRZTa+8X92wO8PAZY0SS1UZSC5d98MoFF4mWOTK0u+pYEEOLt5+/QzUZZkNCO5w9FMS50g6Nb+MOwtopBBn+8kqpgtCKC4NNQYc74RmC2N3LSsjidlgtLZ41U5JhC3BqrFDG1I4fFba2s3WLeuQHJb3zxCX8nSXEuXcWnRGiKp1jk5/A7vlIRmLn7qjgtyG0uFZtGBVS9ZAzFdq90l++NSynwiFe31lR/nK+6DznmE8Xdok1rgTKt06zODuz1HawhboklB1w6acQZil9CHS36oNQMLs78mK4VAztjQl5vDIjwJ85XWqGXQPr9Imcuy2MacVXT2r/Qd/DnQmcb6xa9DkCXcgRFbXwh/1Z0izwwBgD
 RfRlrrgl
 FKkkW4ewx/MACkRSmWqAxxauR1sqhf9nubSYVOYSxp5+MnJGXYpxIWlZjK+uOotvBRk/lPvMUtRtmSbWn7jFPAktEmq62sq9w5A5gDUqMV8ObBzO8r6VT5scNtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I've seen setups where people use fuse to mediate access to sysfs
sysfs in odd ways.  No idea if that's still around, but if so, this
patch will break it.


