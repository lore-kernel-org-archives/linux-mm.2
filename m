Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7974E606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D006B05BB; Wed, 11 Nov 2026 10:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04606B05BC; Wed, 11 Nov 2026 10:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C276B05BD; Wed, 11 Nov 2026 10:04:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7536B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:04:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B9FFA033B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:55 +0000 (UTC)
X-FDA: 85423160550.27.39F6FAE
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF62920004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=zmhlHubM4YVAjV2a6jkbjR0LtKZDt9v1HFdA+qDJ95WSCb/hb034sGuM4Tvu88uMHnS7oj
	reHHxnGXIZZmZkMkZMcezv/w+Qs9KCZpN+YGDB8odLnjYpJzOMhjfOX5EEVoe9wu3+wRX/
	1UirU2Lkd4n6SuArKcZ09EYpI7ekeAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409493;
	b=mF0+drLqV+o2kjzlTuy1KSsLTGf2cHGZSiW9J7jl6eL7+cMW/YsOLQUoXBGzbUfiezfHB6
	kkTbvYi0Qsin2I43npWl+9bNzBgabZyA7r9JoLjuoRvF511mHwRTN/dDctnGlnI8CXsGNz
	Jq8aDVVCfkIldLjnp/MkXn+9HkJ/4ys=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A445568D12; Wed, 11 Nov 2026 16:04:50 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:49 +0100
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
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
Message-ID: <20261111150449.GC10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF62920004
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1ztckzkegeykbcmzrmfd9wsjere7zdm7
X-Rspam-User: 
X-HE-Tag: 1794409493-55680
X-HE-Meta: U2FsdGVkX19hfL/Yk+vc3EklsQHXWwDs9accMirr/N5AnHftUEYtmEh5P45C5xeafioBjs5KCKicQsD5301bWmgl0eUjwUX8KtKq11a1rR1ywSCm2MNhh5L96hgH48hhcGjxj+P2/BMTNN1XnYeMKs9PGp7tKXZkas5dF4Q2K0vdUV1Zg/c3EdQWbkeL/zq4XoyyprrzeXSbohE/DdjSrDCLfF1t995NL3//IlbsXdZ3T606wF+ObQ4Lxi0F1QsEZdkPyBuim5u6xqQjKkbWwuLfhss3BsRldbtPTk/+k6TkKyaT/8vRQmxF30eIfz1/S+1EBCK6HarG3I/Nm9HIDbVr70/utYC2XgK20+dK9b2fzZORACdLdOMmnIFxOjcGTL7wr1y18J2GObfS5zzjYKIKXIgy3TYiTjhmxQ12UZDdhUEiJWWfe3+L3jA9DTJwSXqcILqGUHmtsa6JOacZvvWl48XuhtooHweYNeRYs4SfM4FuVM9/l3fthE9+fAHJtj9C8odatHmBlTSDyMsA1zak/Oa8Fqd5PXVq61y5QmnNuIESdg2TEDj0uUBDQ0G9QC1xQ0yz1qJW7Mv83mcxULygjcxkJwd5sIaoB7kwdRp8nooZEA7ZsUw4itES8TsnTO3geWh9pOBlZXHhs6Lt4OXWd88tzfq6Ed9dU1oGD3G9VpWNKe3U+Uqj2+runy5oepIY8qNd/ghwuHpuhwfX62vUtZIel4WjUT5cCPjIQhlgMsqN/LsVi9tMPnuRv1K3/ghQPD5oA4rizzWdsybkMGPZYbgO6sOxk8alNtWQDBlcVVjFp/GMgCKSdm7i1vxYipEgSyu0i4G7lrkTcRq6ZwI8HAI020XLXc7gokNajOlgsUTbKDrxkh0O6xyaQH2TzLSYv8avJxMqNKGRsY8bTqkeJ4UniG+ZQ2X1wVEOTm8QS0Wn8aGc3FqUpEqlu/0E8uLrY0Us7066m0x/vhE
 EPx1cpHO
 XaKAIdnilDoM6xr3IFhaS6HqTFo8xq1xG9UxQonzEcA+oOc4mGVKz4Cr+sBQ8mkNO6fkG+sZPrlyHHkKNg18U4JJaEs6yKLJMhnTB2esXXO4QM9HRUPGWAvGtxKJPg4HD4R99g69RvkrveN9Yma78TZfqXqT4yk+74n5l5I6NebEK02aSs+RzzWoz/GRwoc10ORVpetzzN1t5y+nzwYoF8znO1GrHb3cgN/BmriD0AzhQMyOPEbq9d88hs5LPQZXSKQ7okjhjBmxRcx57YbOhPjtjccoyAFVQAVDkTBLPtRgQY91C9E1DyOBPypfgk9xMvVtnG9TWnrO9snnYQ/Aj/q23wrOC39liMOrwzQI7jjpS3ACh/qFQac1xCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


