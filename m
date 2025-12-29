Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756BAE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 06:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2656B0089; Mon, 29 Dec 2025 01:57:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B566B008A; Mon, 29 Dec 2025 01:57:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98D16B008C; Mon, 29 Dec 2025 01:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB3016B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:57:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FDDD13C114
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:57:20 +0000 (UTC)
X-FDA: 84271602240.26.58BE447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70F5D40002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:57:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=jjuNxnsu;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766991438; a=rsa-sha256;
	cv=none;
	b=8dvDhuai7t6lgPV3V59LuDQav32WYo0GtaC58kfhvtxAgAEW03HHbCU14bejDWvDxQT6tE
	qtaZBuz3X056kjxLjpWywNVr5EB7mZuwqj/1fzZWcj87vEwOgQmQvNgsXA+IQXPzfq/P+y
	uTToNKEc+Qflkv+al2UP/SC3jWt6oh8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=jjuNxnsu;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766991438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6hXgknI8JB3Fox0uIEASnyxh72p24yHpIcCM5WeqOo=;
	b=nir60fknkRyLEqqao2GsHLctL09/JlP3Mb1BbOpVPjHHNdaplCgOWpJXURXdyRgpbRUg8A
	VLFd+ub74RWB0DJ90b4XxGJkf0/qzlWHxHtJv2PM0JTPotCCJ+1fBt7g9hB9DaTtACkA9n
	pQWczvkA58uW4FIqAjIBeckoMH9fEl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C5EC416A6;
	Mon, 29 Dec 2025 06:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FCFC4CEF7;
	Mon, 29 Dec 2025 06:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766991437;
	bh=3Xlk7G6bmd4X6/lYVrx7q/DEebj24CCDZyGomhzFc3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jjuNxnsuIaZoDMxK0gnNTqBRqhRzHQs3pO5xZLJlgwtYrJ0npzKBGxQiX1LiHLPn0
	 dUWQLA9mZXqVCnv11S0bVF8V6OjDaswaFLEhRFQcqmBqCklJo/EcCGPyooHL62DDN6
	 I1OjCMacDI4O59mVBVfje/lGFtKnzKnwLbdvUR+Y=
Date: Mon, 29 Dec 2025 07:57:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Ban ZuoXiang <bbaa@bbaa.fun>
Cc: aliceryhl@google.com, ojeda@kernel.org, alex.gaynor@gmail.com,
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] soft lockup in kswapd0 caused by Rust binder
Message-ID: <2025122947-award-effects-b765@gregkh>
References: <20251228183129.17193-1-bbaa@bbaa.fun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251228183129.17193-1-bbaa@bbaa.fun>
X-Rspam-User: 
X-Rspamd-Queue-Id: 70F5D40002
X-Rspamd-Server: rspam10
X-Stat-Signature: et16uti7iuosw6xeczyokxep7kwqbx47
X-HE-Tag: 1766991438-747466
X-HE-Meta: U2FsdGVkX18E+ckDXsG/IEIE8Y84Tcqo/IouvZSj+sOidr1VO6h65WFWuTkRJwGYGTgqjRAQKGAHXtfiI8h3MU+qHf7sEEeo2TzyJfrpYeh9fR6qyxQZFj7XS+NObm+bRnhaG6hyTi26oDLruIDN8/G6awBFdoe5PDIOd4HrhoYT+iB+4d1eBD0k8gYrCwhzOdy1OXZ8+5/kjSucB3hsmIMScRI0FpVHPCHCqi8W9h5YnWrWkyThEHh4abcUQyEzTozt/aHF6Gh96I6ikPnMvF5baZbeWxI+yhA1BH8vxJynvKWaMoAhV3W9bHUWpC4CCqsmf+Ewess8xFR6Yj99Uw7zcGZQ2t6EjePlsyzqmL66mBfeDxIFZdDfDJA/+mehW2y9X160ZibahWd12SDOfB7R9/GFUGYsheqE1tMwRYUNZeQEq6YdIiGDZjLzMcAAQK7XS9D9n8lWNTEpy2BHsJS9l1tUteOuO8RJkOP/f8TDjjNrzPV7neFAKjJLPcASyv+arZ3wtf/f70GlxzeNPJSI4SD62wC4iRmH8g7+1xczM6h3KrMe1d8iLu0eAEA7eGr7LU2qrjH/gDSPtsS1vn9+Okip4HyUco6GkDUghNqF+1UhlSLYWlk+KN/Vch26B5rpf5Jl6jIKTuF6hT1KKv1dD87l4QTqaBqEqKEtk1P8iqVJ/ToWuGhY4lQEf43ybuDmPHZCbH8U+vN6wo9y3JfDXjS7I/pUaqBKE60CyV8R7+rKQHMyAbzmJ3BwHWydxbR5k5kjseOJjLYhBYMfoToqq+Jx1xZyJNbTlJRrrXX8gL/OFsGUmal+fH55sU+ecbSfyrL2FE6/9zW11fLv5fqOWsdKSHe0kxJb/6Qfn3m0jr5sjXWdKhgGrXoKyATMaO0Ozm3GbizBb+Oc2e+NvIJmL2e6P1OuMngmR+cuECcsemdrMUKashyL6On/qHVCanTUdBgfhRx8Cy3DMSx
 Dhy56m87
 Y6/KqO/vVlY769R/6zWWSwwBhc5cGoBxWqcUCGmducEOJXQwGSCcSfinl0s7PI9ARPL7KeX+LbVz4++ApU5Miri6TpSHM7sUYTf9I5MM66rxKahq3/yah4b7QoL4I8HY+/efajPL1p1b5FiDDzxamKB+YDVCe9VBLEnbT+ddTJKnly25C2RY7YGAH0hqwR/3SIpiIW0sDsnSP08lyImhg4RzbRF8epyJgGpmKd2Tuor08Kc4Tf8bxYfwM7jK5gMMNzhuC70rwVR0Vja0iHY2f51zmOh+qRPd76tbL1ikS3geh4TEYJsor6+qCq2acFlWYTsz+ywM/NFhj0P62DiTwFGU9e8mnPP4Hv3RrsznzUB/iaZJ3Clb0zCRLIGerIeNNhW+pPZAhSjxmyWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 02:31:24AM +0800, Ban ZuoXiang wrote:
> It appears that there exists a patch addressing this issue: 
> 'rust: binder: stop spinning in shrinker' [4] 
> 
> I have tested this patch, and it appears to resolve the soft lockup
> issue. 
> 
> Could this patch be picked up to fix the regression?

It is in my queue to pick up, hopefully this week.

thanks,

greg k-h

