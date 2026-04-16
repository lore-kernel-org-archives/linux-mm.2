Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C688AF433E9
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B026B0092; Thu, 16 Apr 2026 01:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312736B0093; Thu, 16 Apr 2026 01:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F196B0095; Thu, 16 Apr 2026 01:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 140AC6B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:49:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE3B3E4085
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:49:18 +0000 (UTC)
X-FDA: 84663341196.20.5E58BAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFAB0C0008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:49:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OhOc0RBf;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoMYUFFqJX10VRRqCz0hZilNcV0YTcs60QdMGfYawHs=;
	b=xe2+DfcUmkXq1N74HyxqVjzH2rLk0RoyEneFnIwoklln8nXCJz4HidGYW8jM4TO1616pvp
	ROJnBTnn0qBVntoj34KzN25arEUIBh407N3m4LTSG9zZzYbBzqkAclsTYXFe9crjqz1MJK
	iqIiSJWPeK2gYLGc92HJd1zpl+QF2q8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OhOc0RBf;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318557; a=rsa-sha256;
	cv=none;
	b=g/O0QgpQQY3WoATXQgf0H7KjPgPnCCyriVeakXklmhSORCmMq6j8TXjk72IfqmsqsUAcEL
	W+LZ9D/RMtljT/cs8JGoja8s/tYUdulafw0wNzTvbuCHBm+JsRRrp4m4KAkqzbFJLYtvep
	FHtKqMV+wGwVQJVOA+j+ASXPVZtkBJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 963FE40422;
	Thu, 16 Apr 2026 05:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3301BC2BCB3;
	Thu, 16 Apr 2026 05:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776318555;
	bh=TjD4DVp4r0NsP/6idZk8ijE+d8yOAvrj2zlcjV2TT3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OhOc0RBfhb/HTKW43l7z4by2Kia7EZtHFzctGhb5/mNzpBYKgx/vsLEmhQ36vhGkV
	 /E7d30MqpvYXmyRJtMV2z8YOQJSJe2YKuv+IAX6o66Tjc9pv6+B9cT0cM/EhzJEkeD
	 ysr7OJsYHBTvbe44Hk24DB/zc42a3FyDT7Wn8amk=
Date: Wed, 15 Apr 2026 22:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] MAINTAINERS: Add page cache reviewer
Message-Id: <20260415224911.444a1e8cf6d8bc31bc4880f9@linux-foundation.org>
In-Reply-To: <20260415174039.13016-2-jack@suse.cz>
References: <20260415174039.13016-2-jack@suse.cz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EFAB0C0008
X-Stat-Signature: 5zptfroqf4a7q5paywzz8xxj1zose8j1
X-HE-Tag: 1776318556-28764
X-HE-Meta: U2FsdGVkX19DMTNDYcgtgm57e8LnHHpYmn4OB21MF0bPDrfv9MhRxrUSzPtISNM9sLZ0p6aJdojORlCbRRbZItRNhdD4LXiScYyTZ+ykHSRrP3QgT9sW+oGgfn6UADcS72Q7sGt7arcK3xVmDlOTLTXfppoA56fQHFZLqF3kS+1e5pf+ymdRp2Wfi6J8Y2lY7d9bJAGYRJqwwSkaUKCUj3wWHEi1UVxLokPulzRoYGfInEPhIrPAQmBu5N9TthRHCoXbp4fIXkJvGBztLhT7zIVC/1FOSRAUYYB0tqFQbCNNipOF0yu18Lvtjxx4eE/+0l3qxiABjsvdDEn8wpw9MXtB49lM85QJlDmD/dJI0V3nQ10jSVgu6GtXRPOV9F2EkFGLaar1NgcsOZ2laAKteDbPfFFzv8D1iKJ7NU4mx4jubDihILIUehI1pkyA0LOe6ZyOVNOLqU0Yt1bjntmw3ewo9zWEvriD615JIJGYcEnZXUQ8B5NQJxm1ERVh8DCUqDyePmPfkCatDu4K9vmsc1+xeKab+a83+DpM5ptgNqvG4zgTtccQ/byXVb9U0ttmtmhYzNgUvv7sHRmf3KnDKXrAP8m3wtyPyq3BckQTwEzklmS/ZK3fgi0TPA6twAb+m/fDRxEdA612s2a6oefsxSTAtWBF9vCHDshmSGK4p+Jy9pCT8dfzJanoczZrCl4HZ1fKJk2YOPLOm5dWeSrZGF15fnONDerfhz7xtD5kRzZ2pf6qLqIOLdIfTHPLHK/lq0lMuUSNvAmwSRznPmAWPaS8KTzLrR8mkwrpgvqEzakv2IcIpOP1vbVjNPFOOyh7StV58zFWNBMnJQRzG5of+3yz8dcLUPsfhR72PSMviNqcXteJHUU4ZnZDyT74Am6QtflXNieABR0bloWXhm9zxAz1T72x1SoQ7zqvt30dqc1l+eOHawVhkJc/jFOik2HhRK3Kuxiz4LHAMbP3tlS
 QuiKGzuq
 Lr8A29rl4Bc28fsHJfoK/+6Kyo51wJR8l/slOa2wlGwvC9iIQtAkimmNZ/A2fPnSrmLaMRpR/544s5oZI0kdQuZDLVpOEKqE80/VZvaM+rZaOY4HO6EC8OJ1MEKpMgEALfgMuv3X12RkjPWPGcExE8xkUdiiSmP2MxrRWX+1jcP0Sm/d0bmAvyVW+idPP/R5R5Ff/6yjAnpPuYTNzRPdz0lSHKbhADrDdr9A+HbUHP4OjNOZ7k6Ku/P/rNIDLKU89Kd5iUHH5hdJhoEE42vqTFeLWu+JboQ9JCN7R8afqAC8t/wrZhOaN2rhMUJgtGnjhtOL/NZfuL1R8LFupWzipkVW9UctS8sCwsrRo6W7cuDVO5sgSx0wkwASW8ZEN2WMAuPBTyDRfCyrmHeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 19:40:40 +0200 Jan Kara <jack@suse.cz> wrote:

> Add myself as a page cache reviewer since I tend to review changes in
> these areas anyway.
> 

Cool, thanks.

And let's add this guy:

--- a/MAINTAINERS~maintainers-add-page-cache-reviewer-fix
+++ a/MAINTAINERS
@@ -19966,6 +19966,7 @@ PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
_


