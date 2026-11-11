Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B82606A898
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747386B05B2; Wed, 11 Nov 2026 10:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E0C6B05B4; Wed, 11 Nov 2026 10:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682906B05BA; Wed, 11 Nov 2026 10:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2C56B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:04:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC1B940336
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:42 +0000 (UTC)
X-FDA: 85423160004.13.6EDC286
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id EBB2240005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=cjOmDRkBqQJpOhDJv1WAi2Iqy6wpSAoVlwH0V9tt9TyGhS+rHEuW2M1zuj4WAGuiFZPwv9
	j0ecC4Y9tonZYSa5ry5t/aGlcJ2wuGy0ISL+2aE2uvxBfKboF6SGM5SdKmoV0mDNguv6Rk
	9WBri1uHBgMkw9LOmqz2Gq34KDSeQrE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409481;
	b=sGiSgtfQSHnRMjcCLdYuJSOYYJ89PMgXJCeTHLjV2IdlYu15tZf9Rt+EHUBhJ5d5cJjU2V
	6gpQ0OzCNS/7rXZtrv+fVFaNzhejzUcz5FugM5BaVJfIrSjvJu2Rtz1JqQWo5tgR5PF+ek
	8Gbfd+4pOCgvVlw9zL0kYVNoVItWUUs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 269A268D0F; Wed, 11 Nov 2026 16:04:37 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:36 +0100
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
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
Message-ID: <20261111150436.GB10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: dqnykw73qbxehia14hanwztyxzmn8uzd
X-Rspam-User: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EBB2240005
X-HE-Tag: 1794409480-179054
X-HE-Meta: U2FsdGVkX18pZBkuiCuHLtlrY3Yx8NgGNiHTLdTttkyKbRKDEI3QW5kjaoh/8eDor9SXd8mIy8p+eHpyLXL7pYDOnbd9P3Y0lg1glLkYTMAj2zhhcBH4wgauAm+1F443SCHinWVHFfrkLYpTjY27fzcT5HG3qu1XKFJvvW3mPU19mUlDb5n1FmTyi1nL1R/aO9AnMrjiR+UC78u1w+X84Ebh8a9Cht6wYh3ZrVGxwjGuRxsxeiv8O3yvpR+ckrosuOLZca3Qf8eQM6pe2dMfaZFSdZM87AJV7AjspD7jyY8exakxr3X2Rg5Ays04PvpfdU6gd6IyI7wONxaj6muKgKSDInh/003jV+M302IPDxSjpGvzRBoP6SVH/a+MITb+n3BwpHzubuX2ZOwNxfDY/p2cR8nF7xOEjRyV53xbCnc1n9kjU10Ht+ghJ0jytt2ggsaIX2VnqpG7d6hRGq13xbGfE4GkrMI7vMPKfx3j9q+2pVZ+JDFWESE5mcBL7rFHyE/T4W7gQ0iAZgCCgjGTYlvBzVtM/veD+5HWb4Ql1XTSP+rklLqG4YLT2yT4GJbudhEuPhCAqg8hzem9dKoXU5peUpuYWQqYgeR3EOkb8L8cIwi9oEFeZDzInh5hSPaAXklEAYPKTznRHWa8XaAAoqDePbaB2Yofqx5g8YeN4M/VX/Oy9wCP8H6YpsXR44Rno3fH4u4tNpMv5Fmp2pqj16XudTz+85gp/Re5rENx0Rpt046IXv6lSXh/zRH7/pXj+c0ZH2CKmJKBg3QSHZSs4h54Bg5CI2OvoxXq8KWCGTOd8BlvIQm2PwKH8qXu9hwOgl3XHMeG35k/+QcSFeIhiZRGJJ1Rn/A2Bi9lm8CYhUM8b2w0rzKhfd11lUnVB3aFw4zXrlgfta0js7K+7RwChlRswm15RS3qXke6VKVk6cgAp3zVnCVK7EJ7FjLE2WwUUPsKa4IkcWQrs2DwpgT
 bgWReOk9
 np5MzfyYWp9K2HF2qz75SccpsPXAIxd29XI85Suo/1FEFUTMTKxHLZXg6KZ3PoP54WOVhXQID34L1U3malRUdGgn2CSeLpGvBecvZaYTVaeUBnt1UEEg52NJoaTLxiiu1bbQScj/bThjHdO7lWG2DB5fg/6UJvPVuOVI6Ul9035AvIhHyUzRVsR5zEKWTkNzEk/fJHezfz1XKsPXzDg8rFnoZZV5l9VLclXhcxIYRznhCLUeK8CQM09z5L0glo9jSfZ4NkSl1f3pio17E317vrX5Pk5ZUodEiX669nvfMCdUB3OfjZ5KElX74BtXF9eEhLWSyOYEwD5shnTnbiK6R1tuFmH+QYAJHfolNXtfHi1xtkG3sxfrPUBYzEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


