Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD968F4198E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A7F6B0092; Wed, 15 Apr 2026 06:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BCA6B0093; Wed, 15 Apr 2026 06:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E739D6B0095; Wed, 15 Apr 2026 06:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D57AE6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:30:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BB7816038A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:30:54 +0000 (UTC)
X-FDA: 84660422028.15.AFE0605
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84728C0010
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:30:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mE17bSEC;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43Y5EuMZCliooxm18QEO+BRO1GEJzdf7tODE9by7ZDE=;
	b=G+3uSTHVdW4Q+aBOT65WdBNZF31AAnEqtnt5ns5tyUk8ZNOJ2L+trp49RVUTquYQUAkNr5
	/oF2UXpx4KUqIunYnFw/g0jJkCFs/+8uA3sVyoixWVnT1p/Ea5v1BM02RrU/8l030oE2oI
	vU3tZUzWn87R3MLMFs8QooYVvbvRXgI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mE17bSEC;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249052; a=rsa-sha256;
	cv=none;
	b=jYI7k7fYCjSOVcvaRFjhXy6/tm5mx8K4RFxcr/9JM++nfoNBrFCpB733wjUgd4IuvD0ha0
	gVmAeqEkcn8TOXDh9msLwxYGoY1BfBVsXg1bhDoX7aeH4hZi0YlpzOpNpGgdrOhpJ+iyDj
	4IDPgN/gs0FLCBVIJJCQ/z0E5slJ1aQ=
Date: Wed, 15 Apr 2026 18:30:41 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776249050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43Y5EuMZCliooxm18QEO+BRO1GEJzdf7tODE9by7ZDE=;
	b=mE17bSECRchLGwhJ02/2dxDFwkI+vGBpXoLmr1JWJWG+QK2ya587tbNtMHit31p/yZR5Cr
	U+L+cefpBxFEDPYNMqmDU1taiQbyclQ/8msfgN10q0bC/tVIG55O0mgu9VdLAwbWiwXNm6
	kkv+Wqi59gq96UDX9h5PpHgTzQt23Xk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Askar Safin <safinaskar@gmail.com>
Cc: bhe@redhat.com, 21cnbao@gmail.com, chrisl@kernel.org,
	kasong@tencent.com, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org, youngjun.park@lge.com,
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] swap_ops and plugable swap back end
Message-ID: <ad9o0eSTs3bm1xpS@MiWiFi-R3L-srv>
References: <aZiFvzlBJiYBUDre@MiWiFi-R3L-srv>
 <20260324124645.3944104-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324124645.3944104-1-safinaskar@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ksoftorttxbr6pazt7wopn78izh4u6n7
X-Rspamd-Queue-Id: 84728C0010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776249052-697324
X-HE-Meta: U2FsdGVkX191glRZer68TnjUK1mW4kjb6cfxiX5FVWbVGq5WIa7h9uJvK2EJ4IIp2s43kgrO8LH8uZbLtIFmq1Y8Wzq4MDIPmrb+T33yjY6+uk+ZbarZSQ6jj6SQjryf8uo7gKz5rd9yhDAYF6jUrnPhXQYjjo1+x/+Tnwdh8CXF7tunmToD6LF5LI6rO00rk1ToYrAvOgoFH9J6SvzFHTuSHB7UU9Fzhx4Ax9TOtXpmWd3uUj5yFT7Q1r3hkLX9hk325/8/8YiQzJnbEKI9QOsnrmD7FqzYqjcztpwumAXs2Er9irwbSaw0T3t9fSLtTrqGKJcX4IVm67dpIw658obVuvDAEc8baJBDd4872OyCp1fcr54rJ3oF9Xg+y1tHjCjjzAN+Ayy0HJfD2HO4FuCW/4Lvkt4lgWdledtUvVkGlQizfr60GC2zsqdCaQMnETwy7TIH8wxhvPsUCQFYhmcRCHdd9/qCXtaBBW/ClGOzdrYBd1lqJWRYIQw0sNmJs5X7zrDZtpmiI1rSKXDWTlNE9hKE2TFqzGT8lSQAk5ZhWeBCMz0kx65IJ9IhNOZItm0cj/rsPtA6etZqWTYZOoca+Scr4Rs3nSI1IsGbv0GLgX+wDvK+jQM/7VbEQpmB57CqjwTrfHls8TJHuFasJhuu6lGbGzwX7GiHNVPGSg9/wmqq8ERx2Qmyk4UB5KqsBrkNJv2IGJ3ayzPiATKzFaewS6Z1H/5tPtPAl1hOR6t8NG/9V0HSg71ygw+4dEOUZH0M6hVwKjzmJggnMV2Cl4he6zipy2JpU/6G97xMO/vLCu7wJ0LPjyfvEfCa2PihtOhfVXTO/XPeXW7D89L16+gkOwyCheVbOJj2Y+xy95hDFzgozmcYuKSI1xVMyuQtX5YAJkf/XB2Ndn9NRPrj/zXv9wCdWgUVc9uv0dHMs/c8wEQ7N6/Nq948zZy3GXjsYVPhYRb9eqKIQox6ed5
 kbxV4+zW
 YGdlZlyYyu4cnhT/Ww2eKLc8VlhlCQkK1gBqe2Z5FHtyHTWqRwHMQtuvAfNG2JsTgeh+OHvi1Q07XS8grWxUE8KiVtCKk5+i4AWQbvspqTSbucyT5IYWAGRWzvt+9MePll6w0RXSes7k6x2PTA+2qFDECKF9qbLBnFeIJGmo/CyMojR82TPFwsI7X4v9vDqWmHkXlM1m22ED+Ydb4dnVAP0r27eOeSQE7OXV1vFphxZ3mArmetdoEvOtUiOQ9RdsCV5PwzgE7OCf7aqDukTpXNV3y3NcAw2rp6CwrI5AqtamRdpb4+ILrAfGBnsV3c4eJ5QnkjbANrwCB79xtPX8BsR1Pa0sINlSsOyAy5ZbLVNVb9NgoDISYO+9wZC90uRziKh446BriqONsFw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/24/26 at 03:46pm, Askar Safin wrote:
> Baoquan He <bhe@redhat.com>:
> > How to handle storing compressed data. e.g. data from zram directly
> > write to the swap backend without uncompressing.
> 
> This is already implemented here: https://lore.kernel.org/all/20251201094754.4149975-1-senozhatsky@chromium.org/ .
> The patch is already in mainline.

Thanks for telling, sorry for late reply.

