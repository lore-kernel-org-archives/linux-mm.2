Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A70CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734258E0009; Tue, 21 Oct 2025 03:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC8E8E0002; Tue, 21 Oct 2025 03:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D35E8E0009; Tue, 21 Oct 2025 03:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 494EA8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:26:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B24916039C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:26:12 +0000 (UTC)
X-FDA: 84021287784.04.C76980E
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65A1C1C0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:26:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZCgbvwYg;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf20.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761031570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+t9A0kZYWOlwZbL/Kjits3Uw62fi4VAwF1SOn82uzw=;
	b=fcI705hlt/2x2Kdbi1hjnP8D06GZYJhBDnwAra02FBQo6BoPkz9x4CXFw1A3QfIARlItyl
	cGi6iEWYEaWxomywS+5aXwg16fmizZYpjc5Xt6wRnjUZOICcVpnPOcWJ7vOHcRVkIdkinF
	jnu5HyZm3AwRwASFIm3U2y8/xjh36QA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761031570; a=rsa-sha256;
	cv=none;
	b=OSrXxJ/lsO6m5p+olvMgClPGVjX9GumCJbbpldEi9+HZ6RLWiOCpmdD0KB+ZOpgNomZHMh
	ULnrsdsa5z20euwp2zb6+GS4RC75QN6W9vywTdBdCgXYxGfrZ8Lpn15YNyZHbS38jadFN8
	QF2ezqiPX8xRwSNTVhsngRXMXIrR1c0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZCgbvwYg;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf20.hostedemail.com: domain of "prvs=382e81130=mngyadam@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=382e81130=mngyadam@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1761031570; x=1792567570;
  h=from:to:cc:in-reply-to:references:date:message-id:
   mime-version:subject;
  bh=8+t9A0kZYWOlwZbL/Kjits3Uw62fi4VAwF1SOn82uzw=;
  b=ZCgbvwYgLny8t3apG1Yk4z0iVGf7BaCXLjNf9sZplbO/8vy42aG8mW33
   rx/CXD9iijfVHdKovfqOOppEZyam+/zrKCySaKrqw8a+ai/zSYccSHw/o
   aKaOv/elYzwf8b1GJQ6jJhLLfIhZ7ySwya6GDwfAMpfH/D+kwYrKRh+vf
   9sOF+DgZwo7WywzyRiYPmCQSdr1bpCBUZXCkyP11+adeXXgqc687TBG16
   2TGUm0ZWcHnvwh8g9MLRJODDlzFjMdO6vxSd8t5IESig8Fqg1XIU9xu+r
   QhqbaMzRpi2O3/zf4/bruTPtUN70RgICGH7znLDhpB2N+UP5ma/4G15WK
   Q==;
X-CSE-ConnectionGUID: TYAeHBJkTkyfK88JJgTexA==
X-CSE-MsgGUID: BLPocVkKTgeQ6UWeWe47Mw==
X-IronPort-AV: E=Sophos;i="6.19,244,1754956800"; 
   d="scan'208";a="3819608"
Subject: Re: [PATCH 6.1 0/8] Backporting CVE-2025-38073 fix patch
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 07:25:52 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:2836]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.159:2525] with esmtp (Farcaster)
 id 06137168-4ab5-48ee-b858-30f80bdf9b8c; Tue, 21 Oct 2025 07:25:51 +0000 (UTC)
X-Farcaster-Flow-ID: 06137168-4ab5-48ee-b858-30f80bdf9b8c
Received: from EX19D013EUB004.ant.amazon.com (10.252.51.92) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 21 Oct 2025 07:25:49 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D013EUB004.ant.amazon.com (10.252.51.92) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Tue, 21 Oct 2025
 07:25:40 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <nagy@khwaternagy.com>, Jens Axboe
	<axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
	<idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
	<chao@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
	<djwong@kernel.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Anna
 Schumaker" <anna@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, Damien Le Moal
	<dlemoal@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ceph-devel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
	<linux-xfs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
	<linux-nilfs@vger.kernel.org>, <linux-mm@kvack.org>
In-Reply-To: <2025102128-agent-handheld-30a6@gregkh> (Greg KH's message of
	"Tue, 21 Oct 2025 09:16:18 +0200")
References: <20251021070353.96705-2-mngyadam@amazon.de>
	<2025102128-agent-handheld-30a6@gregkh>
Date: Tue, 21 Oct 2025 09:25:37 +0200
Message-ID: <lrkyqms5klnri.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.253.107.175]
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D013EUB004.ant.amazon.com (10.252.51.92)
X-Rspamd-Server: rspam01
X-Stat-Signature: u8nf1zcpb73e1tpk35w4mneb35ziuzpd
X-Rspam-User: 
X-Rspamd-Queue-Id: 65A1C1C0002
X-HE-Tag: 1761031570-331547
X-HE-Meta: U2FsdGVkX19GvORnn7ixf/W0JzzfxkXTW0FrCShe9IYpZLbALiG3c+B3d60WgLuKxPSmbmGzA1WQEf3Rtx3bvlgVTyKgHactwt+XzrzArllWAMt6AvDsXeHA2S2jxESwlNNDK22ESC2ELa+R90+tk2AohM63SeQOMUUdmGkZfvdT4nMsl86hO+Cs5Qy5iWyZ2ugrRalOu8OOX2ZBUTBxrKKbmUsSyLgxBaqW4k+Gw6CdcBWn/af9JrhdSzCyCFRFF5lyVDjbXEAsSXIugJHqic6+fWQpoQwbOvzG4zM0h5j9gmxj/3uBAEQ9Wb/3pNe+KmyhKBridl1XE8j+LvxmGubo92nRYEafxaYvbRC83hNStn4PLLQbIsjE6XykBNNuJtIN0hf+KIsiJ4teSh21AnvlG/dfYDaKUdB0nV54B5ejHSbtA8ka50eXcorLEqIjVLGqLiIsI3TdC4SPLcQYE1VkN+3gvO6TwP1egPXpEP9zruPA1BXWa1eQWsq71HhePZS6Xl1NYLGP4yWtumP3Ro8Z6Cb/EBZOS61XoN4M0eEEZrP172b8LOi2mFQafctu56pwko30bURGDPi11F+U/x56MUZvCHQpO3+ApFTs+6g0M07jMAfd2vFFwxGLbTk1rJXwe/XDRXkVZQddgJ93YEInlLv4QUiJb2dYncjD4WYMkPpBWZh7HeysjOOFM5iUatUGVbFI1OxfkoMKODaCO7Kyg60RsCTun1/w3cMefKreqaTZyWsbWu1bZIfsb5Zt1OkypotPVjhsxjF6DENo9L10OCgquqAzLUyQLf9WnV6EwGQ84mRzRAIr2mzIp2bInLUwoxHudaWU6dONTdzNVPdJ+4YLf8D7ah6j+WU0mkSTtsXVzz6hlSJ1Qqbed3TYnrHAWg60y3zjqgYRKJKNbTQH2BgYtZu3up4XT5vJjXb3gK5sAn9Lpc5C/VKiHuBA4I5f/ntO7rxac9zOR57
 J2OyW/MJ
 u6rGY7e+4Vu2WoLGEkkQdwjspzpiPOoZQAt5RsV3gI09pk2QyTj5P8vh4coyatyrpLh5p84/YkBRUkqEXQdXOzkpdHcfraV9AL8re5Z3UyYw07ab4HFM49MBYyQXQP89p+pakSSBkr7wLvKerWiF6i+0SW3xwUpBIXVGc/UHNYI9OMXU8hGfy5Uqv048xWRGO+ZvnDQI++5LSROM7VLvXpcTGZTxJOSGmtRJPDkjMYdw2LoQMhLQ6K6r1yJ0J96z4AJAUEHB/928a2zoK/R1Us7U1QPU4g2Yyr1n72vR6FVg0LJyBHIcuWbA8bztjvE0jNbcAu8hgUmj91HESDyW6kPQsit49aLFXE8xr03ti6WCHfDVMqrsRMJzHS9J6pMlKPKMz/LVeWBAhHO/Z77/wgY96zo2aRPVjiqhWBfWzsv5yKWEXb/97BOkIkfx+VelUw6edsicrfHaR7i8X5FwtKLcBhM778Wk2aWwlT1hfhWqq2RfBoPTo0RgzFIh6u7rHy2Z3GhfP2YWrK0MtuIGNYIIYu4iyRawU8R37KDdCl0a8l0ehkamdWwPUnprIEpWgVI4h0bSqhMr9hqD4mDqPrHcwfD90cawc6Pc+hIYoaW8oYwMTdqrVM7R30w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Greg KH <gregkh@linuxfoundation.org> writes:

>
>
> On Tue, Oct 21, 2025 at 09:03:35AM +0200, Mahmoud Adam wrote:
>> This series aims to fix the CVE-2025-38073 for 6.1 LTS.
>
> That's not going to work until there is a fix in the 6.6.y tree first.
> You all know this quite well :(
>
> Please work on that tree first, and then move to older ones.
>

Yup, I've already sent a series for 6.6 yesterday:
https://lore.kernel.org/stable/20251020122541.7227-1-mngyadam@amazon.de/

- MNAdam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


