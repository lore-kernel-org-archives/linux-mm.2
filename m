Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D08FEA80A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 06:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE526B008A; Wed, 25 Mar 2026 02:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F3D6B008C; Wed, 25 Mar 2026 02:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC8F6B0092; Wed, 25 Mar 2026 02:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9653F6B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:02:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 352245A8E1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:02:13 +0000 (UTC)
X-FDA: 84583540146.21.67B4E9D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 894A080011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:02:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cIWtZYKJ;
	spf=none (imf02.hostedemail.com: domain of BATV+3b37efca848b3caba94d+8249+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3b37efca848b3caba94d+8249+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774418531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOaBkNKPQOZthjf88p2qEBTQxMkWTSMwFKAq+WdKe6I=;
	b=cOxDWVxLkhP5FZe5xdrBVtwuNF+TZGIEQIcf7Xn3fB0kwod3RJaCo4UcTG85vgShM++0EK
	2qCc8uZiMJk2akv3/qHd5NBkxNsik25UDZC4rnomgwVK+Sf6Sn9gHnHC1dlIzFdDrX3N1E
	hgGChuGhhdq9dnATYfLuahVIjiiY4OI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774418531; a=rsa-sha256;
	cv=none;
	b=VnqTs2wtsFgop9VeCXE6TlcimERq4T3eotibclcuXQeDUxyZZcaZ9lGWmz7xH2oYk3QjaZ
	sH85Yrz0aG6OEt2N4Caxlz1Q3SerEztxDP064yOzGTnbCiuKfvmTSnKbO9O+BcwpOf0Rpm
	J4Zb2m4kBbm//D5xBcGu+DSRVsh+4Mo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cIWtZYKJ;
	spf=none (imf02.hostedemail.com: domain of BATV+3b37efca848b3caba94d+8249+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3b37efca848b3caba94d+8249+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vOaBkNKPQOZthjf88p2qEBTQxMkWTSMwFKAq+WdKe6I=; b=cIWtZYKJEHy3n2MDiXQL5JqhSG
	XbZI+X7rtKeYd86Po1JNSEH4Lt6L6SiY04TARKw+Z3UqREgoenijeAV8rEQdNgG0AhUu5wKsjEpkv
	80eyogzCiAloS9sQhzU4/TWM8TcolhihA4dP6ulxjvj2RGqHKwSg6EIzkVIuxBLwHR8xFgLadLE34
	vWR7P0qtX9Y4uJ/tn1ppGTM1Q9wnoezBrGl9DmJ+P2/ZvLhslLorn0SKdj+9gTCahhQWGVoriTBT/
	gjD/EQuOvnqiQA6C+sGyaGUVi5zdn5LoIZsZAHMwMZ/JsHhhPJC/6KfAax0pEs2VgU/307kNtbPTP
	Yy4jsDlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5HJg-00000002lID-1zLE;
	Wed, 25 Mar 2026 06:02:08 +0000
Date: Tue, 24 Mar 2026 23:02:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Jianzhou Zhao <luckd0g@163.com>
Subject: Re: [PATCH v2 2/2] udf: Fix race between file type conversion and
 writeback
Message-ID: <acN6YNzbgVUPGETm@infradead.org>
References: <20260324105132.30490-1-jack@suse.cz>
 <20260324105316.28684-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324105316.28684-4-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 894A080011
X-Stat-Signature: q4h7nixadzt7dy5hebrpcsbkwhw6xp3u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774418530-146173
X-HE-Meta: U2FsdGVkX1/6DSoH4GCC5YBsw30qShmiKJvN+zkZsRm1vc/xZnWQi2aN6ij/aNlTbwI9NDY9Ks3jDlsyj+9c75+f39dC44GR6ucGSYrXjCR4odMEqxACCLk6FW8GVlLnQSv+ym2J6Y9FFcm6Hjj8SIXYO92oTdZaXnBvzWLtctZUhCYk8q+CLbkIFoqBQGuGRcRbgPkewO8W31ehGDUA9tJRMQcPDrf+YClLIPt/ZIy6mfEBv+XHbwysTmpaWBI4/lsgMYBUUwEATcG3ncvn5k3Oq2TeR8zY04SjZU8CDqXcPf+ZgJiPtbWedi5V+clCHp82GMEF55PqUZWwixOvzLrpPaydQSat9XO8JTLZ9abf4080wS2/3Tgd9CbAFuKYKg0FLEEKaDMwOGOi3vhShaGRx6YKt6pphRe+HJGfSiCmrkMbwyJssHpH+qjKcsC5cRdhM9f5JZAX6IHD2AkplsW/53ymZpifRoDy2OyknkzUrWAYAIVr/HGBF0it+qU0CHFfwQZRz6XmSstNDJ+ZJ7eK72h7B0mDExDSZVVQSBK5R5j+4b25XjYpenyUl8sO+jN4W3iRgFpVhwy7CSMDRMPn1b/ecPEBuAmwYe/Uuc04y3RRE+X49GMkIdU0boHzkx7+6EntJ4BqXMp+ImeHcwsi7ISekrC1py415TpVFGQssuej8zGQ7nZ65zDBZhVqMoY8WydemdhWHgXtjJr/WOYO0wTm3QQGRSuWJZKJVVmmgpKg6FdYqxnOanMUCcptTOL/jkaHleBIhczYvQPUQh+e0Y3qi744FtzWy9vV/JgCI8PWtjwunaXayHOgvgfDjjFWPb20wt8ApwOHGKYz5mI+CzJp2IlBK03lU1UEXJI7Ud98kpRp+OIaw18XVVBff/8CWUGdzk7qNOgbDJ7eyBy6OHNKESO8azFz8/rQOLG+Kr2UGE7RJ+OhSsPA22lsusEwsw47Oj+L42ETcqc
 KT47JVxI
 tV05luSIJlB1tBaVr+Zf4ouuJcKkGW9Q8c6CGh8EAJEJNOxZzcNi0ZRNms49IKB8ydIRPXVGcIynJKqu/NPQRQ/DTyveo8eB9Tx/6HiOejuMMgPP6/u7yFhX+a7+o9Zh21pfOpwds5KUacGBGvHbBU6JFYvOi4EyB0lTWVwVR4S2sLm7BUBPhCt7r+dyqRg20c7cseVjkghuLqrjxgAH6puaICM5+XyaQC20Ul6YFeO3gDop8lsiYAkqL78y6QfsIHQg6Y/MHB1iJo8VFKCa10kXDMhC8qJk0p7aYFTjRkp+X45Soru3wDsQ8/+A8967v9E7FjIm6s5W6ZDSp8LdAnBS95ob+jZvCfcOaHgCkx8JlpD5Y85YAYxiMh9199avLxYdaQ/0ywm1MG6QcArFApfYANjTxm6gxg/gkYMwscF6B10rBDyMM99X2r314l6xNkw7MTrGdNBYFVK7xkBn0BafQ/5rv6L7RKV6mMKxd11NS9+Nlnxe5iTgNFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The race is real, but I don't like exporting the writeback internals
for it.

It seems like the somewhat cleaner version would be to have a version
of mpage_writepages that takes and extra callback called in the
writeback_iter() loop and allows bypassing mpage_write_folio when
say returning a positive value?


