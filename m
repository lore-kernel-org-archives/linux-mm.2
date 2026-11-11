Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 652A8606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GLtQoeAY
Received: by kanga.kvack.org (Postfix)
	id 884096B05C7; Wed, 11 Nov 2026 04:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BCA6B05C8; Wed, 11 Nov 2026 04:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7741D6B05C9; Wed, 11 Nov 2026 04:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51E876B05C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:34:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00FCA1A024B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:34:13 +0000 (UTC)
X-FDA: 85422327228.30.F575CAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64757C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:34:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLtQoeAY;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxQLDsrm5Bn3FiXuPcGFrFZIY4Qgd1CNPnHPoQGzQhc=;
	b=NFFqt1G0rRkUrbeeR90tzDcdBL3OxAYd9YF0GragchVEkIG0iR+Uy54AUyfdI3FVSvo5To
	0vf8XLUVq1k/S2R7PnDMtjqTxwqu3+jSHaZb4MXdbSSbGykrdcK36ts/xjRYUN2lSq47/p
	Bcq2apqD7lagAPBhAs1kf1YRHo+LiH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389652;
	b=LRmZaBy0TwqJ5il6miuiUrFH0RYX4ou9y0mZWdyP6YA7TKyo6GIn+JDf3dnhj0qagB8fTF
	wFUA2kuO8aE5iImPr19RuoGic9hWkqqm0SI7JDl5BHRIave4yfrTE1WTFf5TpZCXPsObZ3
	ML/MoeiaR+wH+GyC6ieDYlMpELUrd8E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLtQoeAY;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9F9D633C5;
	Wed, 11 Nov 2026 09:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719321F00A05;
	Wed, 11 Nov 2026 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389651;
	bh=UxQLDsrm5Bn3FiXuPcGFrFZIY4Qgd1CNPnHPoQGzQhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GLtQoeAY0mrnAY0bSjsRnGSvaNs+ez+7FDZJNG8Mtcj65toWfTW8PMB5aiEVszULa
	 KoCE9F9mivUgLpHq3UdX5jpwfh65n3G71JcnKQ0V/nXpe+ynzHzRT9H4XVJ6t4iRBD
	 b+q+n3vga6wqq6ZvC4QYq4PdA1v6i7ki/pYBnygnNDBLj/b4MpLRA2e6a2H3Guzi4A
	 Zg8knxWD3iXKhgGMpp6YRUS+wGEdQwKLTPwRTz+hw3HzAzdM2Q8c27wWucohtcbkYw
	 ijQS9GoePWL7z4nmn7h4xTd/MYb4YUoWbPDpdrEcJu03uNN3wZdh8VzFLtVBFv71Mo
	 53OC38J7SEyDQ==
Date: Wed, 11 Nov 2026 10:34:05 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 16/34] hpfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261111-verpennen-eigne-ortstarif-e47e3521ab76@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-16-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191235@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191235@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tkh9dn6xy363pgf7xo98czzqon4azi7r
X-Rspamd-Queue-Id: 64757C0008
X-Rspam-User: 
X-HE-Tag: 1794389652-310909
X-HE-Meta: U2FsdGVkX1/FF+6E7ZWCV1qfXuxWy8hRPdgUZDCFtYN8Qannd92HY1urohDUrGbJEDOebJOF0JBACU2F+2xARABdJvx1umcrGgQvO97x6XqfMYAh6a4/D2hO3FEw8W5FVykS6BsV77f5smd0k9gYS1NYr4FVheNNoegTp47r5LKKHWZGoFaBQtjLOok68ZzafXvEFwp7VCe2vIZL5bfsnf62fPpPr8fdgDMqdSQO5LbatFonQhlqtOr+W4PxDPNL7VL+obF9nEIgiigSPUuPwnUOTbhT8X6LNjlIrdxWAcCB3AJ1CQUJF7Ir//qSHezCQ1BRUjm/2uNlDgvGESiu8WAHuoJQIowtQh/nd6mjk0EGRLQBhweiqDDTjSh6aFB+HillWpCgLNYH5sUUe3BGolhzOAQD1E2XwdvXngJNmPydGKPC7MoPg+JY0IHDVo9LnPaCwMQTqmRDtDkEHLUv7GtQs/43thkCMYtDkbRgxJBdK/IOPKmKJ6ZXqtXAhhvTrMvWW7p+lFeP5mgE3codYjJELW00oI6OeoF1F9C264b/PBNI4h1Rs8LrEP2OV6UBg5fEVomGRj6cEdqcNOPmF4Im/HTAoccZiHEpxZfiCzcivW32dltvee5vd3GYf5wI51gz/1DoQZoVzmEpeKVs/9gAmYmP3/XNT38TbFidakuWmBaV/3vzitvgh1ZAYWkVPGgkHpq0fM9+Wd6i8XOna46t9aQxmEowq3yzsO+gtWvmO4ncSnoJVV9O4QIZjob2ney3uDvl0xv962dhBRCE9IDJ1Wg7iSEtr+QDwmTGvsJRO6YHwaqjRJHyAbvoV+XlDmHcH6Q5lsxMyEpv4iWEkoet7GKW3X22qI46rYLKjPBXbn3JoFLBauHxW4ChcCr4yX5zVDrsu6RhtRXvrRejd7WP5tH5P10dGZxE+cHWd2UdJWx9ZjDJCLs95hjKaSuBxvWFx+D/5c6MkMLDF+y
 0EOsAUvS
 /nt89aL63hJsoJnn9wDC9TEoiLvpLWY3ceBnKyjakX8g8a3zpwIE7AYCZeQGMnT98vV/gnfBeLEwORBCur1jQsCT1ZtqMWLZeMNPe5ErHT/oz0XTj1QJE6/0wsGzlji5dcux5XrYHgjcHsvVX/x9WInvUdQwxGY/6nmlMg6Twu+gbksAz/66dja2j/hLpD49zg0grkdwPA1h64jVSkoTrArULGM+N0NeqSmOkIJlcolPn3j7o406a+/nWoMY64DL7JDGnVga5TLscztbYttSNbwlfMFYFGoQP7Bw4aUAPzxutn2nobrvzhT/zrsH9AXA76LF0MB9bhQHhjunVppb6u1+uP5KF9o9dn+bSRvJvPiMt7XynI7/7UmLr8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:10:01PM +0000, sashiko-bot@kernel.org wrote:
> Does this allow a read-write remount or reconfigure after an error to
> succeed and synchronously write the spare block at sector 17 via
> mark_dirty()?

That writes the same dirty bit that hpfs_error() already wrote when the
error happened. Before this patch the same remount ran mark_dirty() as
well and made the filesystem writable again on top.

