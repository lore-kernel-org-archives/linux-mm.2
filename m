Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952D8CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051346B03B6; Tue,  2 Jun 2026 09:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001B16B03B8; Tue,  2 Jun 2026 09:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E810C6B03C0; Tue,  2 Jun 2026 09:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D45726B03B6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:11:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 998E9408CF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:11:48 +0000 (UTC)
X-FDA: 84835009896.12.5B9162B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EAB7D1C0008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:11:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AJPCbMd/";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLOjlhT22pofCMdQds+qWoM3V0/Vcoudw5MjQx2Z3FU=;
	b=ONzWlN+Xa5LSpd4q7oB+3lmOAXoktZH/RrXzjakoGdb1JOXCzIZ+ySU0w8Gx5g2/fchq/f
	hNI3MRFJTNz/xVU3eX+bMvAAp9wi2doj6oLGuhpUsPWfNTIgOlVjhJmrUUjpFqmk0T0UrQ
	V7UVJZ0apr1Cm8BV7Ilax/Dg1muVIeI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405907;
	b=VWO4MeLDBgpEkGNiD0Im6xzKX8bh2+iKXJk2v4T9aJJKvVG/GEr9Fu7V/UtZ952XCnoS6S
	rixOz6XrXKPzBXSi7XV9PkYVNsfOkPnyaq87ORuN4itNYRNmdVLicd8eoXzt/poIIXwLi/
	1GS5EjRVVOLfpKSKae6W+rpMNz7HAF4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AJPCbMd/";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32B7D43A23;
	Tue,  2 Jun 2026 13:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170301F00893;
	Tue,  2 Jun 2026 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780405906;
	bh=nLOjlhT22pofCMdQds+qWoM3V0/Vcoudw5MjQx2Z3FU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AJPCbMd/c8pqT56MRA719wM3TUPEPbTueTi/p8LnOr0P43iHGWLQNMZAJDrPrgtqt
	 tYd1VUr+hG6g3C14KiUWY9QBFGVyjAZ92Xi/fj5eOjSsUD55sfLxJtnT1IqQzOjdeM
	 khY90XRE2/XqwQGlxsWkCCxMpCirUsL5c0qv5HkzDJrhyAhcVgHnaCaUV21R9DRym5
	 8hWHHeQlkYT19GCdN4sfKq/qzWM3rLofMb/WxYuZdtGi3J/1O/hY+A8D16RuoD1YW7
	 PbYKGxqs1PKjMkMsO303CSLVVkeL7kbqvBTbhLGcQYNI2Y0JnW70kHis/3qJKrDPP7
	 zLftJV72Wbtjw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260602-mm-div64-cleanup-v1-1-bf5d67d89d93@gmail.com>
References: <20260602-mm-div64-cleanup-v1-1-bf5d67d89d93@gmail.com>
Subject: Re: [PATCH v2] mm: mm_init: use div64_ul() instead of do_div()
Message-Id: <178040589571.415500.1649006528191330533.b4-ty@b4>
Date: Tue, 02 Jun 2026 16:11:35 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAB7D1C0008
X-Stat-Signature: 3baftwxfz83hocobmtcrrpkgrecrsuta
X-HE-Tag: 1780405906-688522
X-HE-Meta: U2FsdGVkX18uYor+ffM4A9IM4ifCcfqm8CjiWbebO5aI6MmWSx6JgOsMHo5MzPOuoQPsyWbrv0rHrps7lWaxeq8jYm5thxglquhLaEDdfdVw3ZS9QloLI99nznuCbTsPZV8hcvjHecMktZ6C040eizQWCMMXoHzmGoS/rSOBvIvo9tWErUMWsu27QgbxEQen3QHoSYtzymy6Q7hDeGzuuW/38RTtIYBX2LsgUBcgWf1orXz+MRqsO9Gcdr95ZwcAHJbBk2H56zJg1dai1LB/ADZyEpoCoW4NUQgqCGNLPOj4vOE+fSe+K1Xaokl8bfU3FmtLldVfLWbtrtYs8+uKyUj7qhvhA9p/OUv6BKPikh257mzizOadRNqJX10LM9G5JzTPqomJV6Go3UgabfTfV74NiV/rOBg3vRjT4Q30K89M3857vLBOkRTpnA9RETE3p7/QSSiTZ9MutHJ96O6dpu3nG07a5wTxVyfHtjgqscwiSE2p3RN4ezRqnR3h3Ut2rYNqzqOI8PC5d4Z7MV3oYUV9mrsT7Q4LvClKTRvuECFREMy5gOlZT3BpbwehicnIWRKYjPnzRVue+gK1WKkKYV/8OsFGxw48cQO6/t8h0zrn9KOR2dEaFn+TGNFOIanqQl1QHlmIT5azvrfZnWfh0AcPysVf+kG3nr4xMfJCNfOzonAsfzal1oQvIkHSlIW/Jv7ZQFxxiq8leUyvSXfNTwEHbBqm4VFzJ+j7xEmQeFya9T9xpKEOYtcNMurezbEcrLeAKnkHmwF7p5onlU0KccOwU++A6+HkY2yfs3y0jEc3OvM+eEQztAMo9RNK3ZgUiX6jRbhm9dlJLXUIoi17qGJzaHVfY3hG+WUf9O5x9j0t2XBQlD/N5AZCwTyflq29o2jt+zaEQ70Q5EEFxuWZUIbP53OoXqaVKxYA2AoNCH9zRoq7+0vjmQS02eRKovIZW/3oKMxUY3/rF6bxR/K
 I4cbYqYb
 opB/kYE4ZsuS4qa9j51raN1MHtxGqu59MbTdnF7g5myTAfC+3iWguk7AP+wuvkTSTCyonR/LKJRz18O38kRupLbiNsKPDDXdumb1Dev7HZvqpTqROIPbRrTzRbBXtChVsZ3vCN7xCYjlNvtEeziHe0jC9JIKa7/YBeaRln3VGqMwgz+HfMIh1NOhYgLn9c6CnvrX2PnNnmDZYdgLWKEUL7NVXVQxwI6QIJuXuHfzLp4olJ9Zj02BG0zWbFXCDgSaFYmv16MBHoefVEP2aq29qVVH8B2TNSePQINVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 15:32:45 +0400, Giorgi Tchankvetadze wrote:
> mm: mm_init: use div64_ul() instead of do_div()

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm: mm_init: use div64_ul() instead of do_div()
      commit: 00e06cb773fd81d4f2806a6ee69d1aef8f6dd5ca

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



