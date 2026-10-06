Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC88CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 08:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EFA6B0092; Tue,  6 Oct 2026 04:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFA86B0093; Tue,  6 Oct 2026 04:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEFA6B0095; Tue,  6 Oct 2026 04:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E576C6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 04:15:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75A2C1605B1
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:15:52 +0000 (UTC)
X-FDA: 85291492944.06.9B6D2B4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id D290740004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:15:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CTmIyYMh;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791274550;
	b=UFBGZ8S0TnwUAqbOvd9XM6IfIva7zSOYytM+TyVnRRdEmVAkzKafOUQLjE45IJK4Ooct82
	FZZuUMnZAaZWFytsWdPKmAQ/KzagymU/u3/4B4S8PKY5H6FxeqrlXWDXmspoat+xT7oJkj
	CXDPpdoImOSB/vyqgvJRYjqOwLx/9+w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CTmIyYMh;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791274550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7w+ywd1PSZdlDyJtHv9jkoIkzwVkAbGER4qOmhoc9sg=;
	b=m7zxZL7qhbmxjULt1yVQrwfK3mpzuG5kdU6EvFRnNyzVpKfZoBGbhXKtyvJBfl8rHzmklU
	E2xj/MZymvKRGSTA8OWmhdfLOq2fjnx4OHo1V0zimpIeG/iI6zKjKp0MFRtu6LhGCcd93O
	+u0ZDNXvJdTJ3oyRHQZEg7TxH3PVYwQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7w+ywd1PSZdlDyJtHv9jkoIkzwVkAbGER4qOmhoc9sg=; b=CTmIyYMhKZW/mp3AaVxMHgb+9K
	X3vZdM9CDUMPceZXmRakufgvFfy2NMersd5i4sJ4Ckg2QWO/GuscHH/Scxd/z/8FDAjnkiKBXC9yL
	XMeEG3A/u4Mh1Qrs+yallYQBLVAmyokd9vWHgEQpyWzeJlafboCbhXvDbMAFFZRMLjv2SswWjAYrt
	lm8GWIYyGfZXUqCoNs/Yjrkg0G8hJ7nJk0ak6ZFxAMGerkX+7Yng5CtGPWubHg/3yy73vu9KCTZcY
	D2eSuecRXnn7lKbpdjjuDLXBz/x3pHnO1BE721fCdVD8O7K33Ql2Yznu2mx4EqtDD3K0C1cCC8Hb2
	x9TrmwOA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xE0Kx-003pm6-1d;
	Tue, 06 Oct 2026 08:15:47 +0000
Date: Tue, 6 Oct 2026 01:15:44 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, rppt@kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <asSuFcNafCEnEo8t@gmail.com>
References: <aqgUdbtumaO8RiIb@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgUdbtumaO8RiIb@bender.morinfr.org>
X-Debian-User: leitao
X-Stat-Signature: 4p5p4juss1hakukbr8dsc81rqxgt6xb9
X-Rspamd-Queue-Id: D290740004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791274550-635640
X-HE-Meta: U2FsdGVkX18SqVo8Xj/ZnNQpIvc7E01Q8TKwfF7bNQrB4/8suhChdPEw5K9wnbgjzIC+uBC02BpxeLaQqURuRQrIRbA4015lwUPV/jBXaCNKSgS/Boqt6suY/VAxfZBJhiXIrM/HE0eiosbZuKQ1Ob90PyHCNPEcD50ARi/Eqx7ocIpKtLroRS4/HOoMz0/ZYbktuot4s/LSFUspWpd6TAb1Md47hzA5khRUzieKIYfZNTdGdTXi6y579EB69vnjqIzcaNuCClP1iZg1Y7snp3d4to8CJhtzqEuXWX+r0MBw5Wi5bpgdHo5w2kN01/SAVgxmRo/BriWp6/Po/5pn05hgw4aPP4WYTRNoXGlzn8Ysnexp95/9fJyFvCYYXrlmbuoaT/QW0baqZp4JOB1ZOSHx3Zq0pc9ZeA3tk1ONJovQwPeYj45dufcKLfXb7KtTJ4F8JT7gaiHtbeS9pBoApcv7SnBKC0twKS3KLmJA/lQ3HNXoHaHdiRtxj2b0gfGl/aA4XheDAxsa4wKd4LwnyJCbFOw6PGRWOmS2UCQdu1+rQDm2MpI/y2jpYlKx+c8FkmaYz5kqwl8SMoOlTMwd2R7cF0we6mJWoCS0dNvkym191b1uSUm1XCr8fdoFOcCejSIphYgP6AKq8FmCgzqCe3WVBfYqPjls1tTGI/V1QAlf1tq9sBiCXKU3ffZHa3mBr4E2UrZtTN/sUM5Cb6IFSEk66KS9NL715SYqZqKafxmqzbd22wY1FshZ9qx5jq9y/tOm1ee2Hr3Pty8YyhjDHuNnGA7m56sf8JNZF1KZEXfpX6QJx79xokJlzwoQsV8iQR6yg3uGopjCqFlxgqgwAJFgRj8BGAYqkfHt8SOKPwAgNVn42Iw57XZuALrz+kqTkFtoQqDKvuk59/0y1UwDmKJDFRILjoCMLn9cy0atXbKenY3D6WNDNVbb+Wwxg1K1B09Nb71qwojd8ODHY/7
 YbibHzIi
 mPs08eP4mdYZ2LeS706G3ndDIluOVDgnlnHssrvyFmz/pJm0HF5iuGLNcZNYPnie2fcyHDoGt9uycTlhXVyjS8o9GFL3AF+J0mZl6XYSUsmIOXUAkY3QdbPBYKhVYcGZiN/Qu5a6pIV6oM+GCiztOujCtiXmVp5ojf6XxQB40L6KZTsFL/nuKGdoV+Y3+UJyBDIRvboSegtoa73rgSV2UagT1mYF9yK2NpeGYbTY+KauHR3jy4CCTqSXmJsJbqCsuEIoINROSe86BdPeWH1cQHUFLPvsqBJYbFipGgZm3MxfFiW7qEl1jEshqCVsCMjfyBCDyqV5RClyQBXeejc+zD1vYTar43yJ4W7mfso0Om9XkkONoHLkS0ONFXZjbl6I0khkt3bv4DJNBTtgJRnhCcM7+bOnEItPQ34xUOujRc0xcOb2KfRQYoYtUdw+FZNJm3yeypj8PiM1PMdlkkNy7OGMmsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:36:21PM +0200, Guillaume Morin wrote:
> Add a test that checks for underflows when a parent unmaps the page
> first. Also check that when the child exits the reserve count is
> correct.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Reviewed-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Mike Rapoport <rppt@kernel.org>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Tested-by: Breno Leitao <leitao@debian.org>

