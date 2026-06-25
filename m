Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17384CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 16:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B886B0095; Thu, 25 Jun 2026 12:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73296B0098; Thu, 25 Jun 2026 12:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB04C6B0099; Thu, 25 Jun 2026 12:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 989476B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:56:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D7F61A016A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:56:08 +0000 (UTC)
X-FDA: 84919037616.10.BC3DC56
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57BD6140008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:56:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hVaBQJKf;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782406566;
	b=0O0iNbfHtc2IG/xgHSU2TefOIfM5Ej2VhIv4mjpQhiApSUts41QhMGwbYcc7N4VPPzMOch
	kHLSoyWgM6JPORgQs3SHpK3kQsdSHV1ZZGRp38QJyB/GDJfvnVDAqmiTYZNLOgcke9sStW
	YPotM0kQ+zo7Bg9rljArXF+KYw6cCns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782406566;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ca3thQgy3hkYQeLMahjSUA8d4XyPM8+MNN/hTNDelBk=;
	b=bQJcu9jY2E6oxdPQrUe/ABwvzB7007hgp5hgm80cNeHgB2ckxH6zZVokZVhakaTA2RQQQk
	ZhsGPpnWeTPs3rIz/g6wjJJNZRWLJGjV9XEtJCyW1TYhelbD9f/pJPvdBjNz6b/W5nluz5
	tlvZmbszBNyXLgFLA3OgCgXDaN1cFEg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hVaBQJKf;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ca3thQgy3hkYQeLMahjSUA8d4XyPM8+MNN/hTNDelBk=; b=hVaBQJKfhBl/asUbbRxclaQcT/
	wPXd8ws3uSTEzHX/PKkWmbtT8yC1vBqPDnVZThLpb7+CWq3VEnyHoiyg+pWV+zcp3UELv7gBr1iny
	U9VBrDo3Yku5X/qwFlELKVh1aUZElPPSkZgqCypuy2xnZhi6ddw8xq8Buebbfpi6/rzzQ0Ew9gLKW
	4+7NCfnEhQLePPXw3nZAZtD2f4EDwEWqrfhyfwOhq5078rufRFgcDlW8FBudwKUmXb09daQFW7PHW
	CbY3rMNm8I3lJ0469fvXAD0iBb23kxEaQfvxWC2L86Nf+oFVQ1B3ztA4RLmUZyah8xOXegCUR2Jly
	fV55qiWQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.4 #2 (Red Hat Linux))
	id 1wcnMk-00000003JNf-0vcA;
	Thu, 25 Jun 2026 16:55:50 +0000
Date: Thu, 25 Jun 2026 17:55:50 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xin Zhao <jackzxcui1989@163.com>
Cc: brauner@kernel.org, alex.aring@gmail.com, allen.lkml@gmail.com,
	arnd@arndb.de, chuck.lever@oracle.com, david@kernel.org,
	ebiederm@xmission.com, j.granados@samsung.com, jack@suse.cz,
	jlayton@kernel.org, keescook@chromium.org,
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	mcgrof@kernel.org, mjguzik@gmail.com, pfalcato@suse.de,
	rppt@kernel.org
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
Message-ID: <20260625165550.GN2636677@ZenIV>
References: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
 <20260625085018.989584-1-jackzxcui1989@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625085018.989584-1-jackzxcui1989@163.com>
X-Rspam-User: 
X-Stat-Signature: hyq59q3oi679kf3pbkqhpeccsb7qdk1b
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57BD6140008
X-HE-Tag: 1782406566-112331
X-HE-Meta: U2FsdGVkX18whJhFr+7enBAykYcje5TvRp+voKVHhYD/EQOWkxQpHJyhyPNxIBpxqHm7gPEfY1b0lMbH76Ol+6A1ooJ8HwSPH2XdEnHVe3lLFAySj8vRUeOJGRqF5cucvXisysThwY7hsrOBU8tqs3ekjXe4YYZGOvLnXOLCbJrgjiNWNJS39/eKZNFSDljhlZMSm63Ec7pawcJTsz/T+sE7NRSiv/MVj84Oq6u98Eun+UPvFtQXht4IN/JY1Q49UbXr471mBCXnq2NZnsX7T4EDDJiiXA1aCBp4ijXt5p02sF+XUJ1zMicYETNhHtAM2RKLYjh27hgQ/tqSefPVNb4tyhz7r9gi3v/rc/YoU4fFKh5DmcxlMSHlg4otAjQowmriMpRE5PSN29wy7l83KcF48KrLCa4RdT0FT95IuPtBlCUq9k7M/jVdV0HfU78bZqVU/YI9bW4zldifi/Zb262I+rO3luCnUgabQea+E9TnLGsMLk0cYZmZ53cG4+m5hRuy1wG9lVPWEx49o9Y+qvuvDZWdayMSC3Jwl0G1gKqSnydmCFj1lPvHGaWzERUA9UI97WId5/kYMUcP2HqW1J/BSHYVvNa4gpnIyIQGJ9R7JEu8c5sAcFXuaOIqoRemQ/7HaY5qBxWQiZCRJyRmnAiq/TbMvIiE8p1zu15v/TWv0MtE1FkittCJaWSF0GEkBdA+hq8zqlvLLR38qouy2kw1n2qF6fc+lG7biMVWvqtiFrzdDZFtUeJK6rtytYcPAMEq0yl+gh/RSCznqhrcLN6pPrZQrUpYXxsXEfzIDI7sGrLAVbJZ84u1SqgpiDFj0F1E5W2Dm7tg3AUV38PwYcV09Kyh245riy2DtFBI86TRSOp4Y3t4UJupsUqcrMoqdUciCRtNuwmqgtbNDW4DRO7zjlAd3zjEz6GUaOIkqT4v78xPrq3egyjVwoTfjQLYxIYpSxgb6grnjRSl5xQ
 ItvOgnhw
 mKGXysaQUJ6d5gMkdagKRCciHznLzReU6PDng1f9qAnAaLJgm28I+MihxM3q9UvRhItpmfLL8ksj319FP9awkgkGop7tHYLULao7YjW7Ku6dR0+QObIy84vLaeP6R69R7Qi1oN83VmqYWOMaCz6kAYQKhYbf+bRhs/VRVHWDjthtzxHFj57fNODCheRawDey/I7nDkjbOuSprVjlchbcZZMvqqk030ZhbWgoUetFq/9cYwopkP3vnIyQ432HJghiVOfkqyAg/n2jqc+sFJ4iwZ1DYdqGjKPD1Xh3JvAIW+w2dP34PjGsYzvV6x3Xsb9TeRHU+5g89ZGlx7o8jKKB4FAmeZy5cbP6EnLZdmPRHKJLK6PgduiLDtf+g9fvR3DEa49Ss43AWH8PCVDRfEkPFDVOmVUVSSEKamLmlruDqvIqxU6aVIVKp1M2DSRoVxp8WI4IVH5qOiD1RUarZAtZEO8R7oVpY57HUUgqRhg9xsgchX9JWvneMruc0iLHNgayw0iFuPKcMx4sqyfBpMYN/YCULK02lKxt8Lj60lCXQbtUAoPba952kryx1ICNQWQWe4eTfLMPr31NV+DSyV7BrGIWMCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 04:50:18PM +0800, Xin Zhao wrote:
> > [Severity: Medium]
> > Similar to the issue in exit_mmap_mapped_shared(), this non-atomic update
> > of file->f_flags risks losing concurrent fcntl() updates since it doesn't
> > hold file->f_lock.
> > 
> > Also, if a file has duplicated file descriptors (e.g., via dup()), will
> > clearing O_TMPCLOS here prematurely skip the closure of the remaining
> > descriptors? When encountering the duplicated descriptor later, the flag
> > will already be cleared, leaving the shared file actively referenced.
> 
> Currently, this flag will only be used by the logic we added, so I believe
> there won't be any issues.

What makes you (or whatever LLM you happen to use) think that file is referenced
only by descriptor table of the coredumping process?  Or that only one coredumping
process exists at any time, for that matter - and each might hold references to
the same struct file.

