Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0CFCDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780376B00C9; Thu, 25 Jun 2026 14:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731A46B00CA; Thu, 25 Jun 2026 14:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6205E6B00CB; Thu, 25 Jun 2026 14:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3981C6B00C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:29:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98D0F1C5886
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:29:07 +0000 (UTC)
X-FDA: 84919271934.23.946206F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BDA771C000E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:29:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aucTVLfS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782412145;
	b=UEFQpGrGtmvnLHppLoMHKeQj/RZcyAIqpahV3/sVfL1Q0cqF0ima6hWldEKkNZ5G6fHebk
	Ck7cIqB/x0DSOu4HX5edvVx0S5ycIPoMNpLilSqXHN88yLbDsy69RNtpFtRylkxbJL1HEp
	Rzdi70naSewbpRT7q3qjsGSRbSQJ0V4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782412145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz9FOGPa7qqQY6AQKnjVfyoG9EY2IZ8jwVG5z5C3WNs=;
	b=uH/6O7GjmkISgYe0KCXXXsJZ/vA0r6rvgvTp3yBOWhn4VVSD4b5YOhIUkhClhqfEBETT4b
	5kVpb55i7JILnXtWesnS1GXIwkG6xRKOXp9JkuLwFPI1GzkpNQa63r48Oj4TGSa1EhSYxL
	5siwPHJJtrJ/vmxe/x2bjmdt9Uh/bgA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aucTVLfS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D83560098;
	Thu, 25 Jun 2026 18:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5954D1F000E9;
	Thu, 25 Jun 2026 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782412144;
	bh=Gz9FOGPa7qqQY6AQKnjVfyoG9EY2IZ8jwVG5z5C3WNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aucTVLfSiI88uOQgXNeZHAfDomgg19wlc87GHYGd6G0AdUvLe5znczySG5wXLXaJx
	 BGotTj2TypYkC8zXApQLuRCbbi3TIYgr+1X+MqKGfpkiFMfwQ1rZlxc80uaZc6D6tV
	 R1We3MX22LSUnvhKAN/NFfmfUzDrdiBq0fJEtGl4=
Date: Thu, 25 Jun 2026 11:29:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jan Kara <jack@suse.cz>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount
 idmap
Message-Id: <20260625112903.f961fc41a0b0f8dd1f1a9fdd@linux-foundation.org>
In-Reply-To: <20260625153853.913949-1-pfalcato@suse.de>
References: <20260625153853.913949-1-pfalcato@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: aofsk88r8yeyfqh1ubwq6m3oi55fmoj3
X-Rspamd-Queue-Id: BDA771C000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782412145-484178
X-HE-Meta: U2FsdGVkX1+12xuWnf8VU0zhGD/9Fs3kGWloFDo5Xw6cdBA5XwQ+1jMyvaw7v8L5TanQOnlPx7hRr4M6CaKfgctqNXbp2H7Ic/EIorSFm0hV82BAJeD9MBWdRbbf5AP1O01PIs/DxX8y8ZF0EEec8aLf1KS7goL1BEWyQWIkpsR31IsmUlnseilYnujiunnqq3m89jevLMV3wiyfPWj5rhxP9lY7ywk84/xrQWmwQ0wLRw7n3hbpM7/COHDlhT6LZv3P3QlHH4/KLPxFIQ+RpPHWJal/aO4lgM+e/q8lCd1CDqgj542GHGknjOCE0oxQ7EWMGfGD2IRWds3XLAese25j06oC5w5OuM9RYxNO8JVM/qPRiRbOiWAem22TDaumqcN6gkfl3S3SRoFvHVNFLFTyjURdT8rynQuAog7uvtMGWa8FF1FuN7xc8BWC2cUFtEfUlocy4zUjr4jqv3BP5E9kVBF+nAjWrPdpUUI16YonxXB6ek3bubEVKyffilN5S26mG0deVHAZcs9AFO4wlsP2wWJMuyDLf1+0k9Vu9m/RWi1pfPBw4LEm66PvSeXBYnPbfgnyAJkUHJSE+WGjYbjdwCXobtucpepp8wctLmMLmNT96jC5wuwziSmMMTmR7/qIUGvq4opg54PPWyONfS0hUdY8i7Xbu0/U0HlpZbPR7B5ik9S/2U59gG3dF3vaVkaWt9M1VZKBzR3Ut7xn6NtbykBlBfYJEanSRP0zrVSjZkurbBee4kMRWfJ3N2cOT4fGqS6c0HjH0GzmjvZYL+2R6q+9UnGvNnQMdpkuM8wmphrHHTtFSfXSHy3WoGHQTA/7J5S3e2Kf34AZiG1DfpA5CKsZk7IpyYsphwCr9Li1/80qFWKEZskSMZnreQroQZCjoGY/vgY9PVLXgM/8DBX/lbhX+OTD+lSeCLe5PX2smQxciH8kPjc6TQqkGc7EJyGUmAMDWegdMhpU3ta
 /36y50nj
 a/fca96O3qb/sC58WaxLpIt7Y8ZC372A8j0bzeJA2/8dhyjXAuY38GwvzDbVVVKll1fOC9muUjqmx4z1vtjC7SBvwJccBtrwYhYlNR91kQaLN/FQVnGNxblk5RGabx2/fGAUWBt0b1lHxPpJ5edS3uShQkMVxwcM4D9/6peYMef7xEEo2biyqDi5zFVo80ur85yPKLyS3k+Lkdr2PYkC767NF+uU1Z3WeSn/Z/00CAOEIBGGXWxNX6AiHONYqlFIlz8ud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 16:38:53 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> Ever since idmapped mounts were introduced, inode ownership checks
> (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> done against the nop_mnt_idmap, which completely ignores the file's mount's
> idmap. This results in odd edgecases like:
> 
> 1) mount/bind-mount with an idmap userA:userB:1
> 2) userB runs an owner_or_capable() check on file that is owned by userA
> on-disk/in-memory, but owned by userB after idmap translation
> 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> 
> In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> idmap internally, but it does not need to be the case on e.g a 0444 file
> where even the owner itself doesn't have permissions to write to it.
> 
> Since this is clearly not trivial to get right, introduce a
> file_owner_or_capable() that can carry the correct semantics, and switch
> the various users in mm to it.
> 
> The issue was found by manual code inspection & an off-list discussion with
> Jan Kara.

Do our idmap selftests tickle these issues?  If not, is it hard to add?

> I noticed there are a couple of call sites in fs/ that could perhaps be
> cleaned up with the added helper, but I'm skipping that for now for brevity's
> sake.

You could do this as a 2-patch series, because:

>  include/linux/fs.h | 5 +++++
>  mm/filemap.c       | 2 +-
>  mm/madvise.c       | 3 +--
>  mm/mincore.c       | 3 +--
>  4 files changed, 8 insertions(+), 5 deletions(-)

it touches mm/ but ->Christian, please.

(or I can queue it with Christian's ack, of course)


