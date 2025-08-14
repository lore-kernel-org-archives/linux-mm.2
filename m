Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13716CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7D890015F; Thu, 14 Aug 2025 09:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7AB900023; Thu, 14 Aug 2025 09:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7969390015F; Thu, 14 Aug 2025 09:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 673E6900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:08:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB0035A135
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:08:41 +0000 (UTC)
X-FDA: 83775392442.03.C913058
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B3DE20007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:08:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yl645NV1xizfbGAK6fxM4kSaGs5z+FjQwvJRvcYLVjg=;
	b=B8Wn5rYXwWLGIGx4H9kAfsLh6ajz3lrvatHANmwfawni9Uwpmm9y4sCDwo1H93waKJqXtT
	Ezoe7tGycwgdoRZAh47mwMEUW7hA7BfuJucQEJt1Vhs1dAYy9ZoZS7g6r/hcZlEz056m8S
	xkCCLyirwZhYbFM3JvgDtCmeN4hVn9s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176920; a=rsa-sha256;
	cv=none;
	b=KDGcMc1f4P7FAE1ms986G8ShT7Hm7FOLoy+Hw2aVUvrWlCifUEsCA6q3DUkfsp3NQec1hh
	1JaZdUTsBUvV+qvQeTOcdRA6217hfODBLYrxgqEPnQMGSUAVwdVsPsvkEqYVzR/dEYVQSm
	wKQ6ZksF5iFzqblrlFL+ufg5Vt/lZSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id AADAEA56E4F;
	Thu, 14 Aug 2025 13:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C2C4CEF1;
	Thu, 14 Aug 2025 13:08:37 +0000 (UTC)
Date: Thu, 14 Aug 2025 14:08:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJ3f05Dqzx0OouJa@arm.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B3DE20007
X-Stat-Signature: 8npon885s4gs5hqbiahuhxc7ws9nmoko
X-Rspam-User: 
X-HE-Tag: 1755176920-119519
X-HE-Meta: U2FsdGVkX18Gkhc9KPla7cqlhvvWt6yTkwcqixj2pHwun8IZtIe7NqScw0MRc+wnEOs+4hXzXQtqW+QkBP2rNgC1JVx6HRMseIsZ7NxBF3RzNoVBYZstzgjDnQsOLVcd7Dz3YwuLch/zYf0I1zmQAmLUKz/smHntQORa9TnBMfH7SNAnO20DFr7xqbTDBad73qFXzE1uQ/n4FdRC4MuyzIOV0QK0tXY0e1vmMli58VBP1AnbklgPr1Gw7PHcHDptiC3c7Ll2X4fuE3G115p9lfy5OMwgffndD4kvKVLXWI1jIIqgjKX5BJep0UfZPs45Ask2WbdxsgNSsJr10DL1nBH94KKC3JlQ0YILFUSKD1ADyZGFAauVeo3l9C8yKUGrKP3lKJk18Us4vUIDLcS9LDLGwWko4LdaOb677yXcRzPP+zNSxucwHLtCu5W36CE33rEw6aH/aiV9kR9sP7o3HXLFdf70idxKSkRsIL2U4xHZ8QU0hya+QWpu3uxM9d4yTTNY7z9K3timkRB1BhACkVx274DhCGJMiISXOVTCqco9TJQ/Y0vqWscyT4wRb6OsRME3rGVdRmq3DFyePjAK3KXq9ctt4oFpoa1Z9XnokCnXhnKkFbHTidOVrSl4T+KTWcGEOWKS9dGi3cvIh2PFj2g1jHWiksh1GNHMgg+8vdRJHKyQYHKeMGzNYtYW17FScvcKgvRtpahouQ8/iI+UEkLbtuQo+ItVBJs+lX0AANatLiEyxK/t+Wf+yanSYuYd1XMJCBo0CDh5TD4q4HXcrEjRoAfzRFHZIl2ZZhvVgriHnNgOknTR8VEaXAwgrm/uOznyxpvNsXupiBmmFhUeockiG9r16DfV7cEyhLrjhD67DNDDdSZPm5wrvEXsUQ3iRXuXLhTccmxvzSKz13Ft13eFu46nNTQM7RQwtLpemykYQJWGbhzkAzxDogeDfHaA8wdm9WxLe7naJSGErdq
 vCj+1Crv
 t3k/eok/lvnCVKjFk4Hf2YPfcg2Mz8PwLk9QsIMCGJUvQe+Zmg8eRIzXxYRZXMv6X4tZn4zs5zd+2hDOIqzW//A1C7MuAN4x5gtrmS57+AUYklH80Xr+aJAkTumZ3UOHHhy6mUsX5+J7bjMIHSdiQAmjJhzxJgZDaoTYhjYEOyTPalNqOr01RSq35JjjmAtTCSWf+Xs2h/e/85soh22JIXu8uSOnzCSQuEoTEdwF1Kt4ptIbng26BO6wNzRj3ePywFCowvDE2pD41W/z3p1Ssqc1UcDjChFi6yHeW12nexoKPEpdC2v9bWqjBQNF21OxpjsmjG1t6+7KrmLPwwFCS+cTUaj02EXJQjtK4GgU0Wq4Oj0CVEm38skFYa1dhVFUlKdST4vUOkw4H4ChURqiyzShI2kq0gDnqAyZY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > I'm not sure which kernel version this was against, but kmemleak.c has
> > changed quite a lot.
> > 
> > Could we please see a patch against a latest kernel version?  Linus
> > mainline will suit.
> > 
> > Thanks.
> 
> I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> code of the mainline version and found that this deadlock path no longer
> exists due to the refactoring of console_lock in v6.2-rc1. For details on
> the refactoring, you can refer to this link :
> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> Therefore, theoretically, this issue existed before the refactoring of
> console_lock.

Oh, so you can no longer hit this issue with mainline. This wasn't
mentioned (or I missed it) in the commit log.

So this would be a stable-only fix that does not have a correspondent
upstream. Adding Greg for his opinion.

-- 
Catalin

