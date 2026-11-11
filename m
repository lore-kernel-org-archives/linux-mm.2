Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29F83606A335
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6306B05BD; Wed, 11 Nov 2026 10:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438926B05BE; Wed, 11 Nov 2026 10:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E6D6B05BF; Wed, 11 Nov 2026 10:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156D96B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:05:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE41740342
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:07 +0000 (UTC)
X-FDA: 85423161054.01.2E83616
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10833120006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=jHYGmByIDzqStnpUsd4FiKwVG1W9St4dBkuU5MSufuMJjLYC+3NQgNSb93XNZGelS7V63I
	tN9G0WfAuiODoBZBsc9ferJjoiMPOeQuzHmCzkoE1kGCpT6SbCqI8SA+rwgjJg68pMkXi9
	gWfkaL0EPiF6aIVwQDhGCaEo9CeOi+c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409506;
	b=acEuUmYUD31AGYepxnV7mq7mt0lFE/0i9q2AkuvOv3CUN3/OxI9Ct2FL1deYHPPSS2Dlxo
	6SmvjAzuKWfnUdKC3Uch9NWvbOLGvJRi9r75PaIRfvLsaAPLY8GWEw6XF0TIwY8qHm4vzA
	5ychHfURh1MKkGGMTVlckDScgqxBehw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id F080D68D13; Wed, 11 Nov 2026 16:05:02 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:02 +0100
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
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
Message-ID: <20261111150502.GD10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: g1pwoirr9fwztmijmq1bmuc9ky1imrk5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 10833120006
X-HE-Tag: 1794409505-634278
X-HE-Meta: U2FsdGVkX1/6xoYOQemwU366jZmCxROKiLqXQLOzmloWT8Z9E1OdpPn+wj7XzpPMVqH7PLXQMGh/VTcrfXEYbHfNa8OYD021U8GVpfiVDWQ2+gCDcniyUReCZisxZuQFvS+KbzH878OFgLmJcVTfXBSVwlcI9lcJ/+oB8viwiuWQgRFYl5XiDLZtYuLQbtU5wVzphmV8tCNPz9eTxhOioHDsK2Mbo2SGR0nwZwWGuGEqYcrSKvFQFGzu50t631Uhha8YpM8xyUGdjicIMJ6xDE8y8qvBytwmZJzP2cSFmd9XiOGG0HQUBkG1AtNVpeLQfYn4VGToG62x2lQIfsGwfO8h21zEHnlZHNG5r2fZBKnNl60RhcCfuUNBcVSi/CtJ4mFUvQt35MtGvbs5Ann0KS2+REo7VPWCc3SqcUr/pbKfDEq1gp7bqYnCmnN/vKTh/dQeO0thTuvtQnHobZLCWm6sk9RlnJin5fvqY3vHmQ7NWDRMh808I+K0Wubed2nA91mXpthw8geDg7F8XvLb2Gz7R7AY9EhfTCYU/OT/clxwTxjXB+qXIfu/IZi4psUfJBZbuNyRqofUzv74bgH5h6CJhdTx36D+ajaLQ5QI9BSSEZFHzYepTLifo84Yfd2u4ZfJFSqiYWowYhPiys8WeW+tB65Wzw16sjpw2mSr+P5AHtpeeG9W4eaIfhVHf7KsPgsGKFEyuRSz5bf6eMp0AXw+ZYzBL/5mtToU8540hjqmd8TKkwtG9xeVHQZtUOt7TE4glNYS+B2Vn/hPaaiuGNd9toAR7LGz3QdtlUWY56VH0JQA1B6YX6OXeVFBZ2Ua+oRFHsvdgpKxtygBAMrAd5vB4xYqgf/WxutFJWagrRXYFUAIQdSmUwyU/mEcP8gv2ZAakR2hzwJLHsvMkqH7JK0uQWztQa7ehC+EDD0H17uZ0BxugbRv1wZdomtl53r5FoSofVGq2lsQ+SdaQF8
 zW4UwJwX
 rX5cepQzHCfQugJFkrLOL4SJQ5vr4BU9onEmvIW+Xa260B394ymAl7zvK3/EwphEzcLUvZny8dJ+HtREPyeTKwrHQlP5YCdIGdFmQd4g1d7HGqWyjezPgmYlX+bao2Vt7Q+tlAosg0i3s4wLCNvPAAsL9qYTLH+kBO3pyjQMTl68/Tq0FnD5uaRPzDE1WCWWi/SjSKsIO7RFnxd/C0CcFZVF+QOwwqhEQ4iSQlEGrZGcQ0j9c7POOHJrlJcDx2LzziX8DVFJuw+F+3fEmoLhApKfUNWWrtWKHXgx6xqspSw3v8t2FfPLZpOVN1mWfvU9kD1N4lRM/HZYhvYIFnBWx2iPhWumvB0GI/pEUCxKWZqwH5sFwg8W8MhWp7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


