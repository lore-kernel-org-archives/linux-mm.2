Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A84BCD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 13:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E6E6B0005; Sun,  3 May 2026 09:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55C06B008A; Sun,  3 May 2026 09:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992526B008C; Sun,  3 May 2026 09:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 886076B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 09:23:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17AC6A0613
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:23:13 +0000 (UTC)
X-FDA: 84726174666.11.10AE68C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C3D940005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:23:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NH30Knx/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777814591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0/HQn5xgZoRGT5t7wy3Z7WUfouTd1qBStKctn7j39M=;
	b=eAs0bx0a7me7m11Q0Lyk0o5Dt14hBBcw/95qqE/W9r8hwW51Y1lUAhckSA9fwBfWq6oEV2
	HBLNt0MRY9sHLfMndWEiAjw13TkXbt6sF8fme+BZF5Gw7oa5MwJcNezwv30mbntxC44ayH
	JGd8c0MWiN0gRYjp7D+OorlKsrrTs0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NH30Knx/";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777814591; a=rsa-sha256;
	cv=none;
	b=ZRUeEkfRw/MJc4+QSEAelKS/A0C6Y5oIcEkA5mwIW92nrupXsfZ7p9J1pt4AcuGX0BVzPm
	7bQb1NZiHSZJ/gF7awDPxTMxRw4+Gk9DzJXviSmxe11Y1K4jt1S7cDNYYGoEzUzLevl9NN
	42HSyS+yDfDMJBcSAmKx3p/pnb9E9gM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A991360125;
	Sun,  3 May 2026 13:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E538C2BCB4;
	Sun,  3 May 2026 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777814590;
	bh=mYNWMtlRqxgw8ZzffIHWqmYjfKhkeKsUP+dHj/1loP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NH30Knx/rQBjY70h33pZJsdDa3qAzY4uq/KYKBhUN8qk1pNAQ6F67C81O9jhHv1gS
	 qnp2ajP2p1QLUzjqg/3mdi8PtjgsM/f048oy1RotBnwkU/sUWnoOT2/cYYdLrTBrNQ
	 8QIyy0ATNhSwGdjtqtXXM8b8uu5GioQYP7E3HCHo=
Date: Sun, 3 May 2026 06:23:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v3] selftests/mm: ksm-functional-tests: fix partial
 write handling
Message-Id: <20260503062304.02b166415ef419cf4df6cb87@linux-foundation.org>
In-Reply-To: <20260503101229.654763-1-agarwal.vineet2006@gmail.com>
References: <20260503101229.654763-1-agarwal.vineet2006@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C3D940005
X-Stat-Signature: h35wcye7i1x9w4wwnt9xog364iyzna1c
X-HE-Tag: 1777814591-41289
X-HE-Meta: U2FsdGVkX1/6O+NNFpsxSSa8Soh1UUJ8Xz+O/vHqf7MupfTi6i7AsK60nxOrdc6+3BXSAj3ecQrZLPNrJi+HZBsScrYExixkkz4l2Yyi7/X2E58MvZWFS/G3caSh8upm6wMBqcVJ020fzwgxehoUsXIkddjMUZ2uMReuxt6d/QQu5bNYsbFaBVt/8cIWggO6L0HVGEVAYPKfEKpv0FG4HPF14dt/6qPqzZRjh2CY8O7dE8ZtvkkA8WhpQyTNjkDkbLabeiXPx59IWfRcin1y3rmtpGsSslMw6FG/6/456laoIlJiJNb7DXZez/vQvrz4tJpDEy+z2gkqTs2fWRlber1HXbbYAGqiob2/0rB2fUX8ZleCoxf8J7c361gPD6jbmiYWdEnn4sYif23C/HmF99uJL0KPjpf5mebNnz0/iMehBOIzsSe/kKkSGVA51e1/Tee7u8tHtT1tVpI3Nse7IH/U+zBzh5ZGZyif8aTV09cmkkI3X8UxhnmNU8U6WfbagS0NtqVrEE/OC/3xZQCtya+cGaxTJtSu+0VcO1NR3zrL0T+DsmmgKnh96yfSmVuIU+8nXR0npTxlLYK2j/P0ZsltMxetxH5O9lt047wSQh6GYn5SJOyFgvJdcuEJhXwxX2wdRdrPgqrI/d5LgNgeg8NHcLm1VopV9elsratYydXu1+iZ7BkQ2yi17cwPO/QUAC2fTI8b5mK6TR0iMRLw+gqpkwIrnxxI/AV9kHJGKxnxr1MAOpYBdmQmUSLyr9it1ilW3PDRoMVAdEnyBdI0vp5SwG4wzy5U76EWSaclZCj90iK4vvFOLZRW1bGuikWMvv7o4xr0REEpde8KOXVrRUBg4beRsCM2R45ed2ubVvEZBHQrN1aPPfbDOyFBGuOCHSt0DUQfbzHbA6T2h0BbY1OHJIhdi9glcZ2LCJK8LDLG9yApOa+46YmxKSX/8E1bqZY8FyYw87VzEau0jQD
 lzoDG0t2
 S9Bea6UOHG+g5DFZ+t3awDGo2nkhMLz8Ardwgofi36yhG5kwaB4LxrPTYZrHEj6x6+ifaumc90VhutirPeLS3CeFgYfXp5F60wSqV8s7jdZvN0dtTgg1j97i2TDXXFSN8flo4TBp8NJm5YKqhKQGp9nS1+0VFMqMFsmHDeKSNFZSAVPTCGmD8z5tHxl0eLmy59M1u+QCuCRKl4H0r+isC94uICmBmThLsP2Z0sjyPKGesajHMnLyEj0T9//ppLfRKsNXNf4FSYcqO2dUFj0NQ/Ugog7ysFnqHdLjkjBGGb5oOFqKPFqkfbJfiQHQTr5QTT4CyePYZjofUp+4ZSRmlW/+OpmE+ztDRPM++0JgLjrSVNY/yYsIAhKFvzxvcD78D3Oce2sEdktiZkwM+qGWlC8uujg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  3 May 2026 15:38:40 +0530 Vineet Agarwal <agarwal.vineet2006@gmail.com> wrote:

> Update write() checks to properly detect and handle partial writes.
> 
> Previously, partial writes (ret > 0 && ret != len) could be treated
> as success because write() does not set errno in this case and the
> code returned -errno. This could result in returning 0 and
> incorrectly signaling success.
> 
> Fix this by verifying that write() returns the full expected length
> and treating any mismatch as failure.

Thanks.  AI review asked some questions:
	https://sashiko.dev/#/patchset/20260503101229.654763-1-agarwal.vineet2006@gmail.com


