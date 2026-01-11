Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC22BD2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 02:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D476B00A2; Sat, 10 Jan 2026 21:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAD36B00A3; Sat, 10 Jan 2026 21:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6B86B00A4; Sat, 10 Jan 2026 21:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D38C6B00A2
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 21:12:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DABFD047D
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:12:55 +0000 (UTC)
X-FDA: 84318059910.19.F24F86F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6537B40002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:12:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0KUqpSQx;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768097573; a=rsa-sha256;
	cv=none;
	b=8BsZagEeWpSF40X1HSBA2uFEd64/+ptVAx7DGnxVx+Ot/1SFL+Ez4YsOH3kbrzd6QOKyJP
	Dzgk7Bjs8Y5iyWSKmjj2q50eS+boiCHgc+DqUq+vfB2lKNYCm2RIw2sGeKujzCygwvNtv0
	Smd69csNTsO4QY0o6z6CF69+XR+rNJo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0KUqpSQx;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768097573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnXP43oXXFqD1GG5k6na1+iwsgZMmPqpzUjUDVCVa6w=;
	b=HFHu/MNcDYbRBTcs7EvIJsydEoUfubiTvMlFSTuPMqKGc0rulddalyoybaWKlawMJvS9AJ
	Lkcf4x/lgqMRa85Mo0LkiUW5Ayq4z1k05RLQtAr1eHmOhspWhfgOZWt1GvC1x8ikpKw2Fg
	rjrU3/V+h75H/t+JbcA2YxKsAiYw/Gw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B4C6440A2;
	Sun, 11 Jan 2026 02:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99609C116C6;
	Sun, 11 Jan 2026 02:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768097572;
	bh=lKv7dTKmsmPzbUbXlyvG4jikBT3XnIDEBzDSFJ5GSOw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0KUqpSQxHtzpnLJPWAGB+So7Bw/iZVr7fy5J0ZRU0Cyo1jdy+nEC3toM6g64FvHk4
	 VDgF3d7447QzWOBU3g5WmLRsZmGXB8TvEYlEjYuekV/uq8TpCdnEzQ7GOqNhLStwCN
	 wEnUb52wC8HgIZgDz0V/JA5SkIkptBkWXfOMTHns=
Date: Sat, 10 Jan 2026 18:12:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ranxiaokai627@163.com
Cc: surenb@google.com, vbabka@suse.cz, kent.overstreet@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot
 parameter
Message-Id: <20260110181250.429195a2afa08ed61b5bbb4f@linux-foundation.org>
In-Reply-To: <20260109062419.157284-1-ranxiaokai627@163.com>
References: <20260109062419.157284-1-ranxiaokai627@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6537B40002
X-Rspamd-Server: rspam06
X-Stat-Signature: ezr7zgb64mahg7cyknawzqcjzzaewfum
X-Rspam-User: 
X-HE-Tag: 1768097573-996013
X-HE-Meta: U2FsdGVkX1/UXcqMF9yhBxBK/3nkfQbrwbLj3EkmoJPraooH0CMvMIxcBWvltbUvPD5NrRHr0n4r0i32R4RYHCP9pC2KLJB9/S0oH9RgFFXoA6g2mkpY+btUQsMuSAxHIbPY9wlEc0QcC0vdBXbREfDok3K+W2yIl9MAgdEDysej0gK8fkm/e75ejYlf12zaHnwUHj6fvUfqPsmcaxcF/toGhIwIgi4mIEFCHrUGQI369NiSAU267iX0xkwhO1b2jRrM/yS31TLTMh+5iXwSTpmH84PEu7KGsszSNTnn5d7oBgves1Ob/mw3lX9AFri8tdBzlJne6COJHPef+Y7cULhP/yKylexnWx3uYo97Vt9ytFLrL8f5jhR20/LKqdco042Mpw9bFm2AyYLVn4rhZbWhfIPwctqQiWARE9NbXepBQNmM3c3GuK5cR2b4oFbcoK43glMTc/ayjtpYhSfJ6mm0iOH5U2gLGC9Dd2Fm9+tdvNDp3scMJIHs61t/Gaiga9qzxvY0GeMsHSpoPokmwnMCXAHKR7j7Bu1/7AdVf6zyacKP1R2thcXa7CLil4i6vcUfy27v6XXy23RuTKy4vocO9aEL75EDMmEVApuCJolDtyyoLXVjXiwOEr0BhZikhFkW+31lKZI0x929IuBNyrZLEydHY5pjIyxsnH9B1en37vJo3Ugyn66K+jk23hPQCY+6w6wiUP44bbBU4BFzjnK9daDXvkCX/BV8t3znsAbx5ihK2HiOTnVK2o/Lwo5Egr2O2eLOCXmYy7yUWiHnev7qA54updwXva0ySUnJzRPDtnzLqJbFxJ001W7XVUVa2LcyHCZ0SF7UD5SiPOqMOyXXboQZtZMUqB27TUh0NBGBx1/2gbI1fIIqrhq1UtDfFBu0eiazrVdtjzTwgP+GZG3mEKtjp4UFMHvFYyQyzMwRBuTZzaqGLG2HnrcC49jU0e2TkCNX/c8ZSHCXNgH
 XttIoIPp
 P8bcGnHQQXZVxfE6IP9RfJXEZwFjPl/1oUCM5grp3lY5XEeMuvp4CLqzIxy5uH89lEnzbUYpljtdRkBaeTzDBO416rixemFdlnw7n1AKSnq9NbGjhQO47cMjKG0mUOUhUeHSB5YxLZEIjZEvwDOkw8l47kEcQLI0Mh+bXeY2KNkYuxlMIv6cubEK6xn2Izm4pIHH6ptMgZHf21xknUquJ45fOC4TjfbbLI4dISEddpTYX6PU28QPD4El6HjMCtFwiDn75w2zUouWiLp2v+Xsr1KqVM9NODemx+w1xSQ1bMXPit6oDb+L1r30XEDSqGT8sjzN3LzxfEgM5I+Bs6Ohb9rG0JqRIocbNyQznTh/uShOATqxx4u4Pe3JUUeDqTFBlQ9U4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 06:24:19 +0000 ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Boot parameters prefixed with "sysctl." are processed separately
> during the final stage of system initialization via kernel_init()->
> do_sysctl_args(). Since mem_profiling support should be parsed
> in early boot stage, it is unsuitable for centralized handling
> in do_sysctl_args().
> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> the sysctl.vm.mem_profiling entry is not writable and will cause
> a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
> rename the boot parameter to "mem_profiling".

Isn't this a backwardly-incompatible change?  What happens to existing
steups which are using sysctl.vm.mem_profiling=?


