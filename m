Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 858FDCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 22:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A7B8E0005; Tue, 30 Sep 2025 18:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A878E0002; Tue, 30 Sep 2025 18:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C097D8E0005; Tue, 30 Sep 2025 18:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A90A98E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:04:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BE94C0842
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:04:26 +0000 (UTC)
X-FDA: 83947296132.08.A00D0BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A33BB80013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:04:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2EleeKZ;
	spf=pass (imf30.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759269864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epcjDK81koczFNmI4hDuBmPFVZel+0XkACBAe0f8nxM=;
	b=72lgcqV+lq+tnCrBO/svjjjv+PRFw7u5Vj6ryJAD88LB9JrOzTpoa03XPc9pJRVlz7mtu6
	cu3fgKt0hYoh9wj1xlNla/zpUvPBp8CCW5wKJShu3Br8I3B2xgfdOPrzb1XT/sycmOhYcg
	b+4CIXiji6sINVTxqHX6Xu6pdjF+a88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2EleeKZ;
	spf=pass (imf30.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759269864; a=rsa-sha256;
	cv=none;
	b=JWr8nWHMn0N5CCLrBndlfwqgPXZM6j8oZmwxmBJg4tyFxpw3tiEdI3nKwW+bVL4bBPTa0P
	cqMUZ9/CMyAPLgvZ6dY3FwfDdjuPV3GpSOt7RYB3uWWKp+v75CA1gwNftLF86pAw5w4vX7
	1BPHxjS7EWKlL8vp6QUNfACYPj492pE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60D6F40A26;
	Tue, 30 Sep 2025 22:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384A1C4CEF0;
	Tue, 30 Sep 2025 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759269863;
	bh=OpwwMbhJZ2rP3NRKllcR4zXPav8iTuPDNfNUf+Ss5qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2EleeKZjQ1Omw1IsbFLaA1ULnAEHgUFQgnUl1id/tS1ccvWAEhAfEnNi7wuhNvJS
	 tndXrzAEXbjsk53JF44IC6455DjclVyhDtDnS7O5w8Zn9sPgOdEsT8REZeUGoj0d7o
	 4kcn89dLbrR8nqcacTt0klC9XYLBxOsfFVLSAztvlmZNAa+S4DePAWjLOuBDkRjCxX
	 KX9yS5m4kto3HVylOWHFl/3pDxOrG73oRaWJ8er5QHSbzrgP/GO/TWlEeBHlQZtGml
	 oj0yOzEX0sfDfyB7AJ4A0oatNkNndFfdAYtSlJtLYTi25FKiVsqIn7lQoWUzDy9t2o
	 elJrTZ+EPYGMw==
Date: Tue, 30 Sep 2025 15:04:22 -0700
From: Kees Cook <kees@kernel.org>
To: syzbot <syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [fs?] [mm?] WARNING in path_noexec (2)
Message-ID: <202509301457.30490A014C@keescook>
References: <68dc3ade.a70a0220.10c4b.015b.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68dc3ade.a70a0220.10c4b.015b.GAE@google.com>
X-Rspamd-Queue-Id: A33BB80013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ytz1bgurjrcgq74ze67kqxasxgsw7yox
X-HE-Tag: 1759269864-654281
X-HE-Meta: U2FsdGVkX1/0qQdMn9CvzU5d3Ai6gEJzg7zxeYS53XhF6sZWqjmyHLThqBsj3qnGPPuqrRVeeQynyTBhu6IJtfMmLPMEE+H7GmnA+s1tGwSMImgbfiNTeU9jbiq0udrXgfF1puZse+wo8GIIbnpi/fd4Y/mzoc9Nqc4mj/Pp8f6mvC+0D1KTmmvG/MylOw/g/nIdBe7bFu8zWWFlwStKy1t+HZz4rn24Rq1dTwf3/WI8l/gsTSOBWj+uOBzsRjZGf3w9u0iQndn+XEUxby0qN0PioYL+heG+YmWeTebK1mUff1oJ86ZwdG7HK9qB0YGTsk9/DWsIuXVzmoNwtERP20SfKRK9j8rNXr2sPq7BIqde3uuE3mXQLFfTKbUf3YRf5jqfAaUmPT11+FrAkDpzD7jqjWKzn7C40nWaI5Ln1K7EVz9hTS+Fne7lB+nfhsz6W2ERPnjHwi1uJa1m/10Jr0yCT4DqL/UzOCxZJjzlscJSrICufB7lqx2k1txp9xWGaKg88LgO5sUeBMob5727DGU8biWOtzKT3aq3CMcJboKo8AgftUYXmCIX4yHMaXwwiZlqrKe/+kEj3ljd+MJCn1Kg6vGlTKrim2D6NxzKMRA8fnvXgjWTfzdBKufP375tTU6mlhqrLJA1/RptX/d/OwicpiZ1NuKOVvhogmKREgcKHOjzzhiyWhOOyR/zsNGRRES9K0wG170A30e4RwpmMLaAgt3HZzb6RWTQrHKGQavZYE8F+G8CY3cnUCixqFCRKr2RQQsUrz530U5hMZSG9PCyOMU8LX5js/wbMOPc6p0bLucFUov9SbV4qsYJxqUvVDK1B73P6ojH7ShXnwvG4cwBe9HPVskIIbEjaFtxT0xjjCzQIxgiETZywnvalMzGgaunMXjBbs9x+GE3R030YpflR/bnK17wKqrEiYQDO5jSNkQL3vLM6Ke7m/pBwvXpnCIDZaOQSvq7WWdjarY
 eLQUimt1
 4WaHAB0TAeiIlBekIP+/EBet6oQLEU/3POo8SJsqlXrOJHjp/LKwOK0N9tPX2x6aDL7f1Kh6femD4QBcJQVlnZ571H9ul6eWkHCTNogNv+7oXixgioYaPlOGXlIz+6uJoI5J0VGYT/WSPno+tOVHwnEH9VgIGMfSzza5yxxLn4frH43SB76JWflHOfu5J/4A6ApxAjlc329wmMIenA+/Pi0H2JEiaCGc5NqCYEu29kGezg0WZy2m6hm7+dkvBzIAod8L7UmTpIGHRKiopGWh+FACViAfTKD2DLh1s16QZ+9MteEm/TuUjgSv6rsH5JZk9hCsGaT9xUdgFnrDtVEjn4Cwo7Tw8Qhe/8v5h56rdM1j9abfumpqWXSY7Tiwv41ZUBN5441ZhZA8zWGfJkk0aUMv1g8WP+KMRHTIHvBEgOOPJMybQ69JnJkQO0IEZWWZGTqbWZNcvqhtgaIwlzk32Qs5ZD5xGY4wyMPzXwq5/Vy8zhRbQMUm9mMfPuxakuH9I7MKgVNf99Q6cyPDvjcd1y9wh27Xzcs2RHV1qxeSEdKeaocdOC6oafIdYR8fGFwEH4ELss09ckXUJYbg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 01:17:34PM -0700, syzbot wrote:
> Reported-by: syzbot+a9391462075ffb9f77c6@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 6000 at fs/exec.c:119 path_noexec+0x1af/0x200 fs/exec.c:118

Christian, this is:

bool path_noexec(const struct path *path)
{
        /* If it's an anonymous inode make sure that we catch any shenanigans. */
        VFS_WARN_ON_ONCE(IS_ANON_FILE(d_inode(path->dentry)) &&
                         !(path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC));
        return (path->mnt->mnt_flags & MNT_NOEXEC) ||
               (path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC);
}

> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e5fd6f980000

I think is from the created fd_dma_buf. I expect this would fix it:


diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 2bcf9ceca997..6e2ab1a4560d 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -189,6 +189,8 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
 {
 	struct pseudo_fs_context *ctx;
 
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
 	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
 	if (!ctx)
 		return -ENOMEM;


Which reminds me, this still isn't landed either for secretmem:
https://lore.kernel.org/all/20250707171735.GE1880847@ZenIV/

-- 
Kees Cook

