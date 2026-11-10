Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0EB2606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k07W8ph5
Received: by kanga.kvack.org (Postfix)
	id D55016B05BB; Tue, 10 Nov 2026 16:59:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CA36B05BC; Tue, 10 Nov 2026 16:59:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C766B05BD; Tue, 10 Nov 2026 16:59:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2E716B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:59:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38EEB160130
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:59:46 +0000 (UTC)
X-FDA: 85420577172.09.D65D1D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FC3C14000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:59:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k07W8ph5;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSI5fSzHXT6l17Dh1aqL0HL8Ya/c/u8QoksVrlo85Oc=;
	b=cr3CBW1fc/6vu1RC0Q6ItPYbQqU+xj23SQav3eprH1+f7FdWj2p7bG5637QRMMMXxO4IrG
	FBMnTw7RG+cptMHfYnReJJfYqUl6njIO2gWydoq6COj7thnGIOzPmcZC4g2XrjioTVwnyL
	Eht/vuc+feXcWfuZVlon5Ky5Z7l1iPg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347984;
	b=2kwGLQ3595Hrnhi1Xrv8YGVM4031UusC3JMJdXQDb+h94FVYnK9nht5xMhwiBBbLwcSumL
	xAfGQ99FfOcrYOCuGitKlqaTDNjnBPJ8vV9s/HKR/c6bh80jKa4XUn6fb/0auJQNmQetuC
	lHHGDdx7+LqjIaRJvFr/acnGmP2E/Is=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k07W8ph5;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9612455F7;
	Tue, 10 Nov 2026 21:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB3E1F0089F;
	Tue, 10 Nov 2026 21:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347983;
	bh=sSI5fSzHXT6l17Dh1aqL0HL8Ya/c/u8QoksVrlo85Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k07W8ph5jDucWyYd1JAfrEw4i6xY04o8KKCSMcakegRQzZa6WBYF/iiSupP9LnPJ6
	 PqRhHexhugKYQxif88bLv/RmfKXZebt0jM/KU0AoU7X/Rvq61mdIO9FJhp2BYx92kS
	 p4IfKEBA/29+u3ojBvJItjPeNy1gDzVaKYKHNh0QJMp0FcqnToCGYHvHu+0j4vs2lh
	 6l9GcvDZOpU9QKqBiCWntZiVc7lisJ/D0GY22YgK9BHJp/qwHkFYO1cN5SLvdma2T0
	 YcK1DObxEoQMnj0ObSoLKNC4Sggkxu1v2pCbXzPTs5E5lpGJXBDIfiFdtYdZPgCyQ8
	 L6MbrOl5ir66Q==
Date: Tue, 10 Nov 2026 22:59:38 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 07/34] fat: don't set SB_RDONLY after filesystem errors
Message-ID: <20261110-zehen-rammen-unabdingbar-81907ca99042@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-7-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191226@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191226@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: t5wa6muawaj35u9qi39uqd6ug9mor6mi
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8FC3C14000F
X-Rspam-User: 
X-HE-Tag: 1794347984-680462
X-HE-Meta: U2FsdGVkX1+b/rnCtoE9CU1nWdIQ8AvvLwalUjZvUo8v9bu9sVun/ObYffStrS+lPxzLH3hp8ubuwTPlySTFVGYVR+nNeyLdl9HtJeqCKPqzQhycHbkJjSMK9Wa77Xl+4HBxhrEiIfdOLYkbxC9Gc+IGe4MK0QHA8BMPvbnmwHb2AymBLH8GqsEv4cY6sCpv+kmxE930x9I+WrMTzQsEzr6ZlXAPyKbdU5stOY7oBdMUMO7HZmd2xa6C3CMFA3na7bbiwUgNc+7i1DxpFPmEUVTdcd6jkUGP8++4yg2604zZE/LcaBA0rmNx1odQGaoPe/YEIm1gHCDOWTbo/OsLnyB+YUVV1nuPgu5g+u6VW0ZgZ8NZU1UsvT18dg+ALcpBYyW+Jb3+Gn2h3heSWtiAKWfhxZarKew4WAzOZOhWcOgPqQEk1oqcxzMUBk2nEzvYw2Y2G8zJxWapuk2plQY38RsZQS3L/JmyIgM6EKOHoWPPy2na75De6tfxPHxuXuWQNdqKcef6EB+NAOpsLR7K9TaktdYcoOSIy0uj+74pYZkUgAaf/9sErPovnSPCfCgGCwicYYZvsxeuZLmXx9LACRWwtOeweVaXlS8HXCdfhkURZX4UYccT2ZlE27sRqs9MPfCg81WHJLuN/aNEFxedHpzzVJVpGmEwtMGhan5n0XvwRasyciPqqxmNYabEYn5ywAJMZkWsQjKnIOjdshkfxE6X9DrfFLiMsGiJzmox+Qdqpk7ndA7HZEEOAi3unezDxtHeIIB5XlqqQELLSfL0/xUn2F6UvSwCnEBkD9jeqqY+GMtc0n+6NGy6JwH5yohniLqnjGCgLPOvTMNhSEbV6TNzjT2jDNmvVPUXoWqsQDV2/OE25JWxZt3s9WRnZaSgatL/XYsNbNu/Lra7DPnPGjPt+R04fZQkUj0DYd5KKfN981KTrvghxQDNkwGCmxHmuOYIoPWHdDslFatChul
 sCViT2tM
 pMUFBz/DjhZkuMygUnyMcOHR4uHasHpG2PM5s3oKUv6zb4WfmNBDU66H19bKvYxq/JueLpGFIbsvvtxrDer6ieKyOK0yyQB8vhWqZejb3mFHvoWBBj0z6PokB9MUssizId3osYdyLNddIF/Li13Gsa6X3o+Yc0nat4xCEHYaOzh5k3HFOe/1F7bjSFk/2zR3/+/ZGWfQasW2H6N5ChLcows4pbKnfKxYjJYAFTk0r0EdZQAgpFUY2I5hVcEDwJK/8DZBwboyoY161DBnT8fIfnZLN0Mda5omuwjLqatNtg1XX4UwtNy2J/7PQsmEmxxzkL4o/dWOi7jGF2OAgAPXj3TK/vJj3tMXGkNj6Y7ByVbxbhxSIQ93BRjJ6cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:09:53PM +0000, sashiko-bot@kernel.org wrote:
> However, the dirty directory and FAT buffer_heads in sb->s_bdev are still
> written out by bdev writeback, mmb_sync() in fat_evict_inode(), and
> sync_blockdev() on unmount. Wouldn't that flush the deleted old directory
> entry along with a new directory entry containing start = 0 and size = 0,
> losing the file or directory contents and orphaning its cluster chain?

Right. I'll drop that check.

-- 

