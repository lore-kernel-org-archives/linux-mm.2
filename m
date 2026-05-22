Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C3F5CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BC16B0096; Fri, 22 May 2026 06:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CB76B0098; Fri, 22 May 2026 06:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BE26B0099; Fri, 22 May 2026 06:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 970FC6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:13:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6971A1A06F6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:13:49 +0000 (UTC)
X-FDA: 84794644578.23.577B762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B9CFD2000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:13:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCL+e0mr;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779444827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yep+MmzsVlWADDSUqsV9kVJgBjttfHFqU4R3V6EEppA=;
	b=L1W4FtgxbgquRCDnW17k1xsbxEaa43C9UQm1xVRQG4w9RpcrgeDVqt9y7TLaynmwHJ34vt
	vcYdR+qenW/KPXOy6ziA/3LyLPJZ8jvp3g5xuY83jYh6wnYNqlzZ+6lVL2dS+YNLERKOrk
	CMSORYk7ED7w+sS4bJwsMnpf3FzYRZI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WCL+e0mr;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779444827; a=rsa-sha256;
	cv=none;
	b=ELOdhP1lrvJqrI7d7UCYGmw3RweiqwxhlZzHWVk/NVOrG9b5Y8yoWBJNoH3Qxr9ilZ3PWc
	ELyqiCoAICAcWAD4cQ+kxv7l24wto2V23Fd5I8RlvFSyOw/A4iIQBw8GN3E2nCfRelaU6q
	pfvtQaz0pnTBp1DAnmsbQVT7aCz5HRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42B3160136;
	Fri, 22 May 2026 10:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4101F000E9;
	Fri, 22 May 2026 10:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779444827;
	bh=yep+MmzsVlWADDSUqsV9kVJgBjttfHFqU4R3V6EEppA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCL+e0mr9bpdkDzdJgE2Jq9HRvbi/JIjrTQVzlJ4/ka9xAlhgW2vP0XfvwcveFaNV
	 4xqTJH3Y2fdiEV4bbr1ijWk3+xX2WnBK5GcX+kIT/wqS4tTQ3EqZ14IjV9CEXg/nDF
	 TJ03j5Wzk3Zst1RNElnY5VLzd2LojuCcf4bYPkTQ4whWhYTk2CM1BjpTwTQ7iZHuLG
	 V+WHzSflVOXJh2Mm9XdbGS0ghZ+kW8aFG2u+EtiXym1t3WbHUj+uhn1NVjHMGIJp84
	 9xMMCwBQwcCmsACH69DB/pwpOmFpGGsPAzeiRON0aKG2YNGzMRF2FFTWamKGol5c3z
	 wGxWzKFLY6hLw==
From: Christian Brauner <brauner@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] init: do_mounts: use kmalloc() for allocations of temporary buffers
Date: Fri, 22 May 2026 12:13:31 +0200
Message-ID: <20260522-gefressen-bahnverbindung-inzwischen-e2af1ef5fcaf@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
References: <20260520-init-v1-1-aaf2ebac5ad9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1290; i=brauner@kernel.org; h=from:subject:message-id; bh=lhbV15gqFVYmCMZEvg1uU1m1PBLfa07qcuf2ui7Zz+Q=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJ6ITtNvj7uGL2xfyp8pc9Dabutq8pjIjnblFRsp02R WqN2pnYjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlYfGX4H5kZ/7b+vcC7Ukff sw6/Vy76fr/P4iZ39qTpOtMFO9XFGxj+RzH8/7rrPLc1j6WbMnuUwMRdat9EjHw+P755wOhE+cY QDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s73gkxqmj11c5h9o3si6pajsr4r747kc
X-Rspamd-Queue-Id: B9CFD2000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779444827-694934
X-HE-Meta: U2FsdGVkX18hEiZnMyydUG/Iuf4fINSpeNp34hS9ATOXoNPgm57GYC4vYWTDHe26G54Kf9kXYTcQJfICRrGV9h3DCjovks6jL9JdTHtMJzBYoMQZbpGZUs0nzXjJAGSmq1O5cT3GsEGHKgf4bh11NvDT1NR3hQmdJFlxsVEoHA2lb1BNxigj9qs+5GMwSk3zXNudFbwJ5PNs0Yd2HaK37z5Jx8lVXpKiUz0V8JyaszoJLxuh1SvktCpwlkfwAWTjqf1NvimUWYPPUCX//Ji8OTQL6R8ueWBJ0o9YtEdrFL+PtblKklVrrD5EJ5nCH1pRPewEX4EU4fEOHpET84BGqI3X9qCHeVdSv2ChszIAmY527BV/Vv8mcBUS16llQYTiv5jDFPBhlfZhYs8lT02tGsXqZ3U13L2VI4cdqrpX6L2Fuxw/L+UccVdPrtoWibeyBBNTdPbMwN7ImaGyIACEwloM7KxSR4hf4mA2vYDaMqH+ZMhmhp1jS2et1Mf+FPnUxU8OFV0KCixAsmJViWgJ0b/m89n3xj9lPsDS0++qIAqyEoZBhAjUiH15BC+Fsm5WPZxDD6azTDluMMAnyc1PZJ0TzUM94x014uxQ1BqRw1s+Laabr9hz2FLk7xMuHLne6bW5zBr82nPQqRbcsTrFxRBPEpI2GO3LyT0+26xSbajAxWjXsq4cQGfCS0l2WCJR2tV9EeC1nxqy5Md62dlYXQylucSjwqT3YQfezdQvtVMpsviE/r+/N1iEXGwI+2VJtsnWDJkXpJP3Bq7p3yObxxi8fp6lP/niSqCtMI9sDDjMeiqLEhrcdSgW2xHIzrjkNGH1ldFky74PUIPDwlw6s5BDbfxJn/YPtfL/gKZR597j0avVuH+vTCFMRGIb17Vwg5a+PQIcbQa6Jd2vRZHaSKpFW+EnPalikEtspe4UMvo+pIulhOqI7MoBHpmNUAiE3VmZpvOuIIBo27blmba
 nnpHydRh
 nr5B0Ei4o9GK0LOh5crO6gooSe1M0AOJJGaLIJGoTeYyBOx0rzM5KiSpbwaF5JMwwsgCtouGKf7D/HotYeez7UioBvm6h2+Zp+/ZA1x4eAQJk/CQuczy3iWt4ATK7D4tSgs/r8wd1X0M8FiupwJiyhC1KcwBm3o6SDn0OKr9cBAxKvQlDPajrJ05Kl19lHv0icVXB7aZ+OcIn5drMuUDmjYEOeWCfrQUeE9zxXMJawFBp01rP8tgfPrtYRGh9gadH9Gn44AJH1QcpZBWfMyGOxx75Ng9E3oqVpLPBFxqDXYcslZn7DpaYMf9SLdxD41hLSzJA5i2gHE0fBsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 11:16:51 +0300, Mike Rapoport (Microsoft) wrote:
> Several places in init/do_mounts.c allocate temporary buffers for
> filesystem names or options using __get_free_page() or alloc_page().
> 
> Usage of alloc_page() APIs is not required there and only creates
> unnecessary noise with castings or conversion from struct page to void *.
> 
> kmalloc() is a better API for these uses and it also provides better
> scalability and more debugging possibilities.
> 
> [...]

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/1] init: do_mounts: use kmalloc() for allocations of temporary buffers
      https://git.kernel.org/vfs/vfs/c/3fb2d124b647

