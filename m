Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1242CD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 15:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58576B0088; Sun, 10 May 2026 11:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08D26B008A; Sun, 10 May 2026 11:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F236B008C; Sun, 10 May 2026 11:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCF26B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 11:26:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3975B1C0355
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:26:47 +0000 (UTC)
X-FDA: 84751887654.06.4E57B43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8748340002
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:26:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jQBzndG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778426805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2DJ0+VZuFITv07ba56ktOXeWYmXZHzHSGYUcYS/+gQ=;
	b=xAFOrn3LgUR6YtTA3Qzjd4QKL2bKnTci8Tc4zielhiuNiC+oo0bxu4JMnnD3JdV08ALzvs
	ZNbtlIqndVEbfp3J6M3ohHMd50tx5iRNYOOPmTeQKivo9KhtI0gvC/2MR8UzOTJo6AH4UE
	PUU44L+SQtVY8xxDadX5GiSeoJ5zvZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778426805; a=rsa-sha256;
	cv=none;
	b=WDaAINPEs+joioXoIw8aSGY5OTMRM8/WJTgEWNLQ3ZQOHojVELTu4yAu8b1Uhlwvo/q9cn
	O7UbcRBM8TvAzhhXWUWtEw9rSIpFewFwc1X60+XI7ncsZP5tbwBN0i2f+3oOUJRPRTgxh2
	QuzHOBoF31Wuz2JclP86OpDeF9c6ULU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jQBzndG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 635464393D;
	Sun, 10 May 2026 15:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2899CC2BCB8;
	Sun, 10 May 2026 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778426804;
	bh=Mc2Qe7ArI+7McctHiVxQHX2r5/hJPhKxbCJROVGr6FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQBzndG/7p70Syz1+pOI3qJXIibMuK0p+00ZZsF1ApjIBiiGd/ro/xZQ/VVMZxwT+
	 g5OfaMDFcKzAyfq5u8NwzC6y2jsbsjGL6Vo0L5Hc95IRGX0PKKgxuu6ZBNe7dRlXGh
	 YPHmlwXPm6cL9fL7uRxd6OvRooiPfT3zOxNKnyGSqGky+azWpRA+ExH9Abgj/tPfsZ
	 IEsU8DumL1Y6wvuYVHF4EDyjsK+wQjTJvAzkLCF9YqllVuQF/5phYzbfTIAOZXkGRl
	 3Zq4PjOnfk7ktYCYjijJI4Tz3GV8rZHWtMZiiMJ0ZOxC4eR89ep4Pw3kyYaY+xmcJ2
	 Wloorhvo6iChg==
From: Mike Rapoport <rppt@kernel.org>
To: pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	George Guo <dongtai.guo@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>,
	graf@amazon.com,
	jasonmiu@google.com,
	ran.xiaokai@zte.com.cn,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH 1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
Date: Sun, 10 May 2026 18:26:26 +0300
Message-ID: <177842678313.259088.8928737921907121858.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260509024415.33190-1-dongtai.guo@linux.dev>
References: <20260509024415.33190-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8748340002
X-Stat-Signature: wpioyt9kyb5zxsybm6ertp7g5j9yo31k
X-Rspam-User: 
X-HE-Tag: 1778426805-11376
X-HE-Meta: U2FsdGVkX1+4z+uWiWPxQJDPHEsoChYQU1pXq4iPK3p7nmWytqftH9smw/bQLjMy2DJNibHt5Z/WaHsBvwIb3bP7euwgq+udRI6Nd/33+0pRJTHhPIEwBv+j/sqTZ2IBKYgMxQmg3gAYQgPSnjDMpAoeO6bKyDxRyaQqhe8GKbglQ6ubEX6Kf5q1DU2o0OWfZakfmxdUOmUfHbhabM/s0OqtXgRfURDIsfu3rIhaOue6DiyNhlG7OQSw+RePBSYL7v1rUX//QDh4Y+Ev9CiGkO1p58QniuOhrEKmSc6AjbkcEOMwjteLezcjauzdZ6KwdLgHIELnYlxi5oYws2iQlQTIb/WkRsCpSOkgAYYgsPuy96WXVrylGki2Bk5smg3bt8mG5+vbqMAuFvphC+Ej/2um1HWgb84D5cSJ5ZJsQVinmVAZXbg4xVQINqH6GEsS6F4QDVw9EdobJmWI+cLPas92sxZHSgqQuqEPtZ3em/yt4ruuiChehog5fIOXqBRB0rWFFe0F9jMSl/Nq6cZwWMEfRYCnH2tjxxJcnosjcyfFmJibeUJCCaxjdE+BOzeibwAUBOpSOS5P31oUkpG0DFiuNh7OUhK+VEF4dIMGgRFUAKOlKSwGGGgWWMxzd8xBwVtuJ3qi5cDWuKJc9oew3fOTOdHt6jLqYOAbaMul6P9QgYJFUmn0DmCLpFM/VgwMdKI9ngomvStZcKR679sUt/qixDd80OkuLDpKHoeEJt/jAhi/fxntEn4wYw4q/iRWl8odNJSiA1nJCa2KEdKzW8crpqWTITDjki6WvcRoKBAGmwF/jp9Nyg2Q0LIRj5Q2eB82oItGFBinTFmzBtPitaEdB9HvvhUo9KBbh9wu23mKKIdZaUw5mfgqVIBzKJK+uNnsuh5HblPGYKHjZe0kq89m8RF0Wm0YoroZKj2uBJjjuwJ9y/v+rPTGUnBID4k2XAi6tfTs6JI5G8GIdHk
 3H9KVjKy
 4Offr+vAvSZq8wI7ZStlXXIw1HrNCKvks3Acen2eBIJ0SKUMynlV3pU1IrHwYg5fsvlD0YtV5RWqGSXgr+6oWSuf8FsizEfT9lZvtZ/TCfhVU4v7prg1vkDdPYJyZ5Y6gvoTiosN8DiTGrj/NqzwKSJlHdzgsE0rfpi2VW/VF4qaZRZnpqpG9UBY27C0/SnEobycO4ty8McFRNFFfDyf2FWGtvdx593c3eVMTxf5FzgiHz1xFmvGUz82UBVB3TSyfFzjlwATqw16MkYX/YT2t80qEXJIzIoKAmYzL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Sat, 09 May 2026 10:44:15 +0800, George Guo wrote:
> KHO_TREE_MAX_DEPTH is calculated as:
> 
>   DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
>                KHO_TABLE_SIZE_LOG2) + 1
> 
> For systems with 16KB pages (e.g. LoongArch), this gives a depth of 4,
> with the top-level shift at bit 39.  The order-0 bit sits at bit 50
> (KHO_ORDER_0_LOG2 = 64 - PAGE_SHIFT = 50).  When inserting or reading
> a key, the index extracted at the top level is:
> 
> [...]

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes
      commit: eaf3933ec58da601cf0008afbcca7cf5433321e8

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.


