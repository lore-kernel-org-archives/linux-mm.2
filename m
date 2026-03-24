Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D0DF54AD7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586ED6B008A; Tue, 24 Mar 2026 12:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EBA6B008C; Tue, 24 Mar 2026 12:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BB26B0092; Tue, 24 Mar 2026 12:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39F596B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:36:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A774E0500
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:36:49 +0000 (UTC)
X-FDA: 84581510538.08.451F954
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8040C140004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:36:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QndkqMCx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774370207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSycPKbk2fdS+E5YCX4L+r5LFtmgi215LmLvriDP2vU=;
	b=UweolF4E1Cu9ey1dbrBKjyFfk9pWWjHmdn7eBattNVCa8YbMr9bxIi3bWZQEfwwrNjyF9A
	aQ7mlbOHQY/ElYhXiQBxe8zvuGUlyB70vF+UXHUCcI/OsI+caT8aIerpidFFkuQ0FvayUp
	66OtTx8eScvmw1oMyIuIrUdNwDCqCIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774370207; a=rsa-sha256;
	cv=none;
	b=X6LqfYqP4GaKxyHEFrOVZGZD7BRdv3+fEhE0XYTw4q8+iK2aSYfcykT2pOUOjde9xpI+m8
	hD9O1QM3oXCbLwnYqKD3EbmXZTEvFpnWi18QiMOEkwxqwA28lhyej3a7fYpkUpBmHTcqab
	VejXa3OqlgmxvjsW2bY/fHaG8VfuLa0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QndkqMCx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9851600AC;
	Tue, 24 Mar 2026 16:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E10C19424;
	Tue, 24 Mar 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774370206;
	bh=mSycPKbk2fdS+E5YCX4L+r5LFtmgi215LmLvriDP2vU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QndkqMCxK1TeWqDkJY3Xr3u+beAQFaCzExSDnyjROfpnOQSf7l70VpJwfTJCuGdnF
	 j67peCtt/5H0my3B5ITCB4HSiMCWCntjAvhxYlpGs1/oSfG5InVkbK8NShMAgAFIYr
	 rQsw1xjH87dQkZE6IQci3tuUa2pyILrfU9+RrT7wd+L8mN+o/S7jkXq51bR675P11l
	 hfU/eOWBHswnvbUXWr67rX9foP1NpibfBnSfNXkTg2TZz7g/v555sYClL8vV1AG7ZY
	 r7S07bw6KTyVrCffSXxO8s3R/+sYR1ppC69d1zyINlTI9mUwicRhW5hEFlWw794qQP
	 BxusL2gzAxyDQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hillenbrand <david@kernel.org>, Eric Dumazet <edumazet@google.com>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
In-Reply-To: <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
Date: Tue, 24 Mar 2026 17:36:42 +0100
Message-ID: <87fr5pgp5x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8040C140004
X-Stat-Signature: 6hacq45z6epxpohmpwaz1gf6p1frxtsj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774370207-698964
X-HE-Meta: U2FsdGVkX18twfjFULIjZwdNjJpSNyeEJWEtsczgPfp24SZnzbk3lA60S6gZa90Pbn3+2NURBBrnk1aDBsZHmTwryTNXFMHd8vtOtMfjSCfqKqA4E3yjX9zNcnuJJc3T9Y/FTv7DAyohj4cxvZRWgp0tw+R2BSPFGN4Wy6KjlijNGIiQJzBgZIVg0wR7iWGVlQDAMtTi8oS+Q5K40UeZ7k2gGxallfcCpsEPct/f6oPczWfWloR4yS0CEN0nkjpVec+tm5lyq1KSY647ALv/6ILpN40n9jFojfJ4406gz4z5T9qjOU5bUcyqH4cpC9HNhS6EDiKaXkqqg9RR+yAvtf4FqUMOSFcmmoidw+AkuF3hn7iWiO/MB46OnQfyVM0NG/0fsVvSVuEWFtnVrzdMBI5eOh9GHzM5VRlO+v/5Uo7gFDNmkdakuSt9oOWUnSfTAHc20fKbtDqLOdhwSED5xINi66kX0FExZbZyIBOTCeeh5pgZekx95XG+7+ikqwzb9U2cp+E6Rb3TbeO9WYdKKJLL3hG8rWjEM1mqcsykHto4E8XuizFivxU8oUSoIm9G5ctQgH3DnW/goZxmuDGdxoX9d7onBNxIba3a3etfHIu6mRs93xh4jsww8cbkzBFHar2jidFDRp/EBcejGDXnbRtl5Qah7Qd8xQgZP85QOCcgI7CiM1CzSSOLK9VkJoYXWNWamRfmcCEQxWsgOXCg5FJR4pbBOW1xqw5hmoFt8wdbMkmClZUON4RlWorPUQvdagiSfIPFe39TwMw/Q6aUtPcsxI9MpUJtU1dYWNR0/c5QucFQM50QVh56SvBd7QkpkXPOl4iqVrTNfshvwV7tlWDe/kGZvMOZRpyo5+HWc1xZ33IAYRgv/H9te0tshKy0f8B/MlOoC5cdwJ8WgcmOFRgrIW6lMSDi5TW9ZcO3Q7a9/6G0dBWpm2kkBVIHLK32vSn2J3eyXTMpB2sPbNp
 xE8ANqCr
 adhNDiKNcM9UJIucxpZCzYmOwYepVRO02iq+xypUxTg2ocd1aEyTXJgQBEJg5vD5cWl+u7TxxtkCEyIkfZDlvCkNPF1ud//NBeldI+TMix5WcCaIQttT0/jTlc2IjmgQWvnPdM/itn2Q76+wqEUVSWrdkQCFHwYfVc0w1xVHeGCz57hoF05PDgjpJbT7OuiG6WEeQmW3uKlx2AAiOl1cEitK6/PvY7t5hlavlUYE1t87iVWCzwaX82an0vdEy58wB7NZVIjRJxRJhD7Br8yS91fiNOD4WftBK2kR1DSpYRx2rSnk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24 2026 at 15:00, Peter Zijlstra wrote:
> On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
> Not to mention we don't actually need any of that here, because:
>
>> Especially the writer side is required so that the proper memory
>> barriers are inserted for architectures with a weakly ordered memory
>> model.
>
> The vma->vm_policy thing is written under mmap_lock held for writing,
> and the futex consumer is a speculative read lock. Specifically the
> ordering is through the associated seqcount.

Duh. Yes.

> All that is really needed is to extend the lifetime of the mpol to the
> associated RCU period. Which is exactly what this patch does.
>
> Want me to go write up a better Changelog?

And a comment in the code explaining the RCU magic perhaps?


