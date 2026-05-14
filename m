Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 658E5CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA826B008A; Thu, 14 May 2026 10:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2406B00C3; Thu, 14 May 2026 10:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEA06B00C4; Thu, 14 May 2026 10:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1196B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:37:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CFB48DC52
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:37:46 +0000 (UTC)
X-FDA: 84766279332.11.8E954E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73D3A16000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:37:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSzgITkm;
	spf=pass (imf08.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778769464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKEnSDOVlo6CEUHpYZMySiy8/gPT9lRBLUnGZhtoNUM=;
	b=6aHf26gyi04AICbR2NRQPmXDJMK2ZzEraDfzYFrotvZtQTpjS+RIuNotrdVU8bkXUyZFDX
	jGSunn0k+j099gVrEirPpYhyiux5wpbklpFUgYNU938TXqkwFYJsN9mRu8LSfWYq3oli1Q
	79lJR5DN3yE3HbkNiy9C+bWYv2YlQ9U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSzgITkm;
	spf=pass (imf08.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778769464; a=rsa-sha256;
	cv=none;
	b=IbZTBEx0eGG/exSvzV0uiCOgCWMnw6QiVVXs+Yhb8TIysw0veas0J40I72opketq+jb1kZ
	u62f+MtI5VCFgQW4sJcuIL6iIWHlibcYqda4X9VELDsAhIH2cIptEPzaEN8dDATFrpWu9h
	VDhDaF8xwLPdX5tbTVjR75CvoawiVTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D9BD42B12;
	Thu, 14 May 2026 14:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451D6C2BCB3;
	Thu, 14 May 2026 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778769463;
	bh=rZgHzTbgnHHmJN6qZy+N8eVodksxfqXSK4VW1S+0K7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WSzgITkmGehUccFbXTWsPk0QgXndYmpZfV7daj62F/XhP97o2McXRouYZH6CLLFwV
	 gqggLlEnZ1PXfTjjROCChaOh3grRD106tHztsRAi1luciA9n5+Z6uR56rq/zS3XA3J
	 YnLMKpNKptZSqQ+7fG/Q9tObtVhW9ctnptKEFbI0pchM2CLBhnLGtH34yqCKRQvOGW
	 7tLS0IrpYKXpaGZv8TAHtOKGVHyfly3YPOjDQLKY9xULeUNIZ2PiNzkPf4rTYC4WT+
	 mEMhTAGHxkOSdsjXj9RG0qveXJ811sNv6MaeF7a5Pg1xBtEyPItjOhZC5D9DOj0U/p
	 Zv4alA42osiJw==
Date: Thu, 14 May 2026 07:37:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
Message-ID: <20260514143742.GB9531@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-10-hch@lst.de>
 <20260512170846.GJ9555@frogsfrogsfrogs>
 <20260513055806.GC1236@lst.de>
 <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
 <20260513074608.GA3693@lst.de>
 <b37ca8a7-289e-45a0-8cbd-eb14d7453b97@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b37ca8a7-289e-45a0-8cbd-eb14d7453b97@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 73D3A16000B
X-Rspamd-Server: rspam06
X-Stat-Signature: wfm15bt65aiodz5gd3qdq18qs1kpa6er
X-HE-Tag: 1778769464-789865
X-HE-Meta: U2FsdGVkX19h8dVhKsUup2QcK28SMk52z6yCAqc6HsUsqqRhHNdDpL9DWVgac1NkKpMzt2mu/I7/GZh7RMSDoltC+NzOFuC73et/1KK2DCr0WqAlBBiFWi1tvTajLYhpNJpvCir+y98PbBnq6P1dYbZXjKEKVh75AA2bt4pKBYyfwpsBNUKQPZTGEKl1eO4nSI5pyDQBJ7Y8xMY81TIDtTyg2pddRutj035DnW50ZEP02Sek9i2wJ5s00Qt9up460n14G975wYFj0lUpeSQoU6pBJ+8B2R2pJwZ5fNOkJPOS9VmAK40VnalzvjVKF+tNlIMzTXU94Yr9ofLY5yoJxqgxLAU4UAFWR6WAyXtxZHxwib5RV6WnGh9k+ZE+zcYMigX9lgJM3IABFgT8AxaN+eOSEdXyLhWNxcjYozJuWFv9TkTDq1wVL12zqg38M6Z8qqovFgRu1lEY69nQ9irJi9TaVc+FL70dvAfEGXGY8klxRTh6s8JB/H8l6xknFkVp00o9UdJwUKfn0D2iN7gsxp1fqF9WFZIaisSZ2Ix0a8Cb00pe7tMTsp46mbFnRCgIbaq9pB7dRP3qhRh0XmUWOgh7PgjXyr75fwm+NPd/RNWHg+39Qn+fvJ+raOVM3bAn/BF2o6pdlkpyMgfmtV7ukPf2LaChvd7Al+hqf7X+U5/Ivpsl0eYv5GGR/n053aKVLKRuSO7RAydyDmsxdqjbAZm5rqSVYHguv6Q4kfliZ2s/kK3AWBxr8UrK9KCMtbEv/+ZXIPqeDfKeRGMLFPReCGmS7t7UB9Hqwlz/1PxVPAUk8NDNOrWdf1vHbjub5XcOQgXceWFPwVdJRF4I7CNlcDDVaQRdyVGdbzVi4CpqYUN2JA2+BJSMmKRFlPmPmAkU9ycYsZZfyz9CLr1q5IokUzKAWGvDy6W4Mkt/59gX9qDJG/SFHirUwO0Z0peGuZ0y3OPqYwRJqBG9AiY+r7G
 pMAhWYnk
 lypmOWQ2KDa96HICwySJ9Q2hyf4zu3IPy4VVxQqZb6LOnTIHlsxdVUkiMP/Sz8TYidqNjRdo3GZuovoOH+LqToCnfn7iPJ+Cb/sbIzqhsSHslQJ3t/qPj5XnUaOXQrMuleTB59b4TSny5zbeP8Oz+0d7Bsc50lpOB/7GQMxuFk4IaVqYMDByLwoJWqpCx/4vrzxwkINgq8135n0qyBqcTC1/sr2rZOpNrNkfzNARcqBGSLI6rG+hPjIsS6SaK2xL9+qNYfSPH4gkizuZccTkrWYtEail+BTfEibG4SVpgg5VKRrsjd8N41c4AwVkPmZ6VatqBMIgCpYybcssrAUthFtcZ4CN4Ic8fcL3bpvqFyeMJBzOiqXD8y1LyTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 04:58:37PM +0900, Damien Le Moal wrote:
> On 5/13/26 16:46, Christoph Hellwig wrote:
> > On Wed, May 13, 2026 at 04:44:53PM +0900, Damien Le Moal wrote:
> >> Hmmm... With zonefs, swap files can be created on top of conventional zone
> >> files. So enforcing "no swap on zoned device" here would break that.
> > 
> > We can check that none of the extents fall onto sequential zones instead
> > of just devices.
> > 
> > I still wonder why you bother with swap to zonefs at all, though.
> 
> Yeah. I do not think anyone actually use that... But since it is there from the
> start, kind of stuck with it now.

Ahh, right, I forgot that zoned devices can have conventional zones
where swap would actually work.  Question withdrawn.

--D

