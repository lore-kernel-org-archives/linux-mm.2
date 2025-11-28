Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B29CCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9ED56B0012; Fri, 28 Nov 2025 06:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F536B0023; Fri, 28 Nov 2025 06:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9663F6B0029; Fri, 28 Nov 2025 06:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83CA36B0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:57:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 297B9C037F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:57:28 +0000 (UTC)
X-FDA: 84159865776.26.D383131
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 012AE100012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:57:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ObD6zpXS;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764331046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztYqiuTtW1RKiVqd15czUstvVxKRPfKny0WDCbR3Kl0=;
	b=3ewpnuFFPs4A4RZBF8LAeg82s3OQqB10/TjGfNgylg5RcsYA/vOMcCosX7l93UayddhFcM
	XnURCg8YSH5wqCaHr4kPu7ph7r2ln0hxwKQow2LwNdofprsd0VYv4yuqRWd99vVa4va8Pw
	jghWq+AKaaTasRR4qffeT389Edt18Ac=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ObD6zpXS;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764331046; a=rsa-sha256;
	cv=none;
	b=zkH7Xq14MSEJtE6WsQB3PVcKGqKMz59iCVwrpHfmEECnV+osde2rjNIdcs4kxCZttDPqfL
	DqnPuMEgWcG8UGvHOxFuH7KQdC8VTflVY2mrXxep/31n22Ntr5iJDMpVS7FaJmApIfR7Jr
	XFoaEGL9MnxfyFHuE2+TeM3UYQj/jY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFDF643759;
	Fri, 28 Nov 2025 11:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62485C116D0;
	Fri, 28 Nov 2025 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764331044;
	bh=5bMip0S9/tpW0MoW/lR7BMtgwSMIBTUWbFJDxUU4KQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ObD6zpXSUFtkdPUXhB4rMibFP88ajANWtQb6RdCS3FEoHqbmbym6aBc4c5MYEvXzd
	 /RLgFDcWHBFb+1fRCjlu7s5U9Cskre5386a24lhJdLGSxEZfeFGUNBurR9IGdAbaJI
	 iNPSmkxW1YbtbqpkQsBhceygBvdHpNXd8ZtSgZMxYeZeZrSXlddkCFvJ0B6TCvC/1a
	 +1I7uSJVgYapGE7iHqTpE+E8pgc8pI1GvvGBpIK/hEDIFQCSwC9oE743tsUhwXkZFX
	 1Atsyrw3tMR2pkYTnC13ofxnVy8C9KdJ4FIqT9hEjNlRU3Qa/qE7u8WKZDmNiZ9Uw/
	 GnsISHAbBJ2aw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7AF7AF40068;
	Fri, 28 Nov 2025 06:57:23 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 28 Nov 2025 06:57:23 -0500
X-ME-Sender: <xms:I44paXh6wlrYfbaf6BYOfUX8Sd6sV3Ik7XiRgHsEGQGQ6wAvd6Kt8A>
    <xme:I44paf40M54DFAP6RX2PcaZ-B1qEMsM5Bw61ORScJ1-6ZdBXk-e6rtJi_zp34J1Jq
    Jpn9AOxKreE-h1J63qc_VcVso0FdsOVl6TEJY1ht0dk1r3WfUTPWw4>
X-ME-Received: <xmr:I44paf7Ube1kmovtBCdc7rGSQze_yr-PhRQWrvoL0xOJSY-sBEEuMvAY-U4e2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeelkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopehrph
    hptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhu
    nhgurghtihhonhdrohhrghdprhgtphhtthhopegthhgrnhhghihurghnlhesghhoohhglh
    gvrdgtohhmpdhrtghpthhtohepghhrrghfsegrmhgriihonhdrtghomhdprhgtphhtthho
    pehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepthhhvghvlhgrugesmh
    gvthgrrdgtohhmpdhrtghpthhtohepphhrrghthihushhhsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:I44padE2EDL86-w49zQuBDkeApdBPYCSn7IfQ1hWHdr133ra5pelKA>
    <xmx:I44padwuHKiPAsu3DGOb2hH7Ef0WYDc0kVy4y3Z7KBCQfN385D86AQ>
    <xmx:I44pad3B2jAYTiWNl-VuEWtW1mdsFkkH32h0tQk5rCS2k_3X5M5KyQ>
    <xmx:I44paQNIrw0AmgtR1hXiEJeuHQdpaZvemNltyteU_9wBFD9qCs4Ujw>
    <xmx:I44paZunYnMqvS-rZL6aAYIqcX8_IlAdtb7sdjM9BGVX2lssyT5mkJg3>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Nov 2025 06:57:22 -0500 (EST)
Date: Fri, 28 Nov 2025 11:57:21 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: rppt@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	changyuanl@google.com, graf@amazon.com, leitao@debian.org, thevlad@meta.com, 
	pratyush@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH
 option
Message-ID: <lknkhwexdoaf73jjr5ji2wya4kacurt7evabqrsoa4po6yyewv@qs6rfpxyxpdz>
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
 <20251127203724.3177621-2-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127203724.3177621-2-usamaarif642@gmail.com>
X-Rspamd-Queue-Id: 012AE100012
X-Rspamd-Server: rspam02
X-Stat-Signature: 47sj84oq484nptrmuthsmbq6jg7m9qea
X-Rspam-User: 
X-HE-Tag: 1764331045-590528
X-HE-Meta: U2FsdGVkX18YqGV86tTrLXLsBfpN/nMKl8wjiiZD7w3p175J8FP0fRve91+qXIvdJfZX6ac3r3kvMAgq1aumBPueaMtnTFUXk6VuqsIheii8UsqqQXS8IJJZdOYEuoZBaFfwruMa7N1JSqvcjz0Uq2CwYWPfemlipOJrdtzaAZYfpnbn6A0ioJpdVCr4tqCXeJSp7h//oK1aAwOrIG8sq6Gn8h6KmOJwClfuJSl3B4osprxoryypZCZntPGS+4zu7PQaQ0g7aXQheUeA21VqaVcm+AkqW3wtvGi3w/f9PGHOnv7DoSDdhdVH7nL2uxFmvb08FXFc1sPcKAZb7DunxEECTbWtjgAGw+OTDBhTZr04meghv9MJtxodyb5p7MA2ZKcODWvrvbK+Ik+oNZ2ZDrcxJBuEhvS9II+2Pb3XhAA8fKGxANEDlssJlOGHo6T3CtifaczJL24FutPJbD9XEN2csHWh5e6lcUTwzDkUnPBAWhI4DveMnpH9bGydCXDt40pvhOaML+7A7NbISefWGdA4/KYDL397aC/oPhJWZjUh/E8PSWx3Pa0TNDULD6Mgb2B1fZtXnAJInm08bZlS/rVSJWjALDdu8r895iPHNMVT3F7uZFwLLx8+V6iniHsw8XBZUMR1IXjIiEZuI+E/y4laxjVBaHPR9lr1NB76a75jPEB4fxZLeZ/0N5tiSvjJ/YQquPxW1+lRw3P0yOBYBF9Q2SI9GWtJEPBlPAk/1a7VUSUwxrdhVNW9oSR3GdEQaSEZxDrWmySwV3c9uArawdYzg967SJHigQ46OAfvgLfBUGDcLjD355ELz1lMq2AUOINUkzBhMnIr1yg3xO1a8/SL7HZgWJ8f2rpRue3o3QptHhx6Jx1Nwloa8DTlm5MbXDN0wfvy9UzMoJOJ5MQtvDPiT/XvvM69QS2dwvGCLmdk4e0TJQdb6NPiiCsjQ8NZl6hxxXepgFbajiW6ont
 gJ3CEsAk
 kuYrJ90i4SR/8N4ZsAYRZOGToC7ctoBzRkWMhngsqw64Y5HwGWtftLBonbvkOyrqHMrFuCZZEWocnkkxz8eqKhpiQkR92QmPR9sTfT/2ADp2KGkMSwJtDuFXVSUHdF/FIJXnS0zv9UP8jt2WzfcANSshsR+kbZr8OMTwVos1w5YKDw5lknEazQrKnJ/ag8kmQ+CP/Z+RF/QiWqjj3zAUl0aL7THHD+yoFua4f9ikUouFHCQZXFfpT/bPgjCfGJgZokglFgIDGoQusXXQ8cKwVkdREUtYoTUW0aMgXMul5hdPfzpCrRmmJ97O8ptvvr/btL5xP+5qYJJmQ7pNl4r4lAz+tGT6NQXyP7saKb9BRk4zNqmJsseAypbAqIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 08:33:19PM +0000, Usama Arif wrote:
> The only defconfig that selects this is CONFIG_KEXEC_HANDOVER.

defconfig? Maybe "config option"?

> Replace CONFIG_MEMBLOCK_KHO_SCRATCH with CONFIG_KEXEC_HANDOVER
> to simplify code.
> No functional change intended.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

