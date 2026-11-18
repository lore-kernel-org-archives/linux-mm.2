Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47ED6606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdwaZMb4
Received: by kanga.kvack.org (Postfix)
	id 3A0C26B05B6; Tue, 17 Nov 2026 19:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351BF6B05B7; Tue, 17 Nov 2026 19:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2198F6B05B8; Tue, 17 Nov 2026 19:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 010776B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:22:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8506D405F9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:22:55 +0000 (UTC)
X-FDA: 85446339510.04.1BA0779
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E57BCA000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:22:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdwaZMb4;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRw6fEvSDbVhRU8qh+aETvS7Fbkzj3KZVD4IK2wFBqY=;
	b=ns09Pe+xwlWYBaVT8w28PIK5809AyEJ3g5JR+P7EtdtoHRrnVc41knA8yyzlumVRuMDAj8
	fncTuEeNGdnam/4Zm8GtoemH2NGfmhPpnwheO8HQgjDRSBCK3im2JgZj3SNZeOUf+kmDx5
	Y+p4VRlFjuBJ/wbmpZZDET+fHsKSM5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961374;
	b=sbp/zzMJImGFCIe6b9fFTzum3VqQUS+ihgBVbP2BASAzybgEJxvrOwn1qm8msD4iEWPd24
	ngYtH5R697pKYZLm1aqihyFgnGtEEzi3b3XgDC+Dp/uJvPTyvR2RqSEjDaYUwseLY/Qv//
	BsqLNpMYbCLk+LHdDaAm0Y1QgtksR64=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdwaZMb4;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13E0A45827;
	Wed, 18 Nov 2026 00:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4161F000C4;
	Wed, 18 Nov 2026 00:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961373;
	bh=JRw6fEvSDbVhRU8qh+aETvS7Fbkzj3KZVD4IK2wFBqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdwaZMb41Dr3sv04GZVnGjckzwbg/sehBYDC9dmFCUjWmtVO+EiTp4J4s45P+khZL
	 UCahzLL42MXU12ywdBfCrXPFhGP9An8DYILkAVUTTMREIHqtADzsdw9HV8B7btfy/y
	 Iyn97cZZ0IizG1GH+O/uib7AAFqp6gZOC162nwpAwmV8VzGEP/84mp7dCY8qUC+qo5
	 0yeUEa8Pc2KF3p4wMmNTKv1YFnVhIy2e41ycU1RCksHOXsbjA8JZvewNrJjYSAMVF8
	 Ety645S097tDqS0HarWO2Vtte/fwbY2ElXgqjLueJvKnBN+XEJbP9bSXCQ1vdNsvxI
	 H63ujfIZ03r+A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Mark Polyakov <mark@thundercompute.com>
Subject: Re: Backport request for 6.12.y: mm/damon/reclaim: use parameter context correctly
Date: Tue, 17 Nov 2026 19:22:50 -0500
Message-ID: <2026-11-17-1-daily-reply-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
References: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1irmji5doa9h5d89pw4o5g6ffipi5duc
X-Rspam-User: 
X-Rspamd-Queue-Id: E57BCA000D
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794961373-855066
X-HE-Meta: U2FsdGVkX1+IbsEHHUzB0QyhjUlM7U/mr/5RtIC2O+o545LAb374J5j73PtsdISwQyam2fPhHKK5iI04sFqvEZFv8EFsfkxu4E/7FxAMPqIGyI+DcDLTAWrifSaYzIcix4x50EtjG/7j4eDut/RCmCY8AT5ZqTKXEMv6XEHAjUMyxDNEi+FxF5xndtxyWzUzJkKxkdiJwkWrLHfNEHQEW4nu7nEr1z8+YD5o9yTEOBlUrrcvhM5dq/zPON8k3dcvIk5a+IbWWRRt0MHRnTAMM/bB0liKxmmYxLGVQyrYkshwS/78ZOQ9qH8rRR3P8nEaT8iOHzMGdMFRVuBmIK50yQjQPZqxBfZfj5hVGlXKXAeyNQ5bGzFlUK4ZJZvWbD3AWbOqDQlSmNv40cOc56t7BN6unK7ZZMDP5G2sb/IT2myd8DuzMaU+0yri1+mrBWtP1bE8ndZoii32TUB/KOciupZcrY0ABhqEaIP4BiStEvzz6YH49juY0JiNuom6gMQIZwHLLUIBJpAicO8X2ht1XXqx40YZKBGAjiq+d0WZB2d+agMdMn3CAuXG1JE41crTJZvN4w5bG0Bxpn4WnsiycKRqxJWCQl943skHDchQ4qNkvtL1XwkyUZLHwLjhfnGmmlTgzkDDdVM9FWXdexX5pb32UXWwHILsGsZqymR8uJEHM6vqjCqPHmouVl8Ak2nlhWqn4/nwqXevIBXZcyF22dyKY1de0S0DKj1Bch2eVVuTXBK7I6LuSfWkGjmudPRMvpIQGQjC00Dq0JjSct3uB0eseqXsfeSjbPhTrdDqtb5kPgeIPKuckD9EkyMD1yXTGr1xwzE+HvZ7PV/u7mQWPAJTKC9RoVki+fzUZWQ53W1qonBIlkQEzRRT3sCjYQjZpg+yyt6hzPRpkxChIMVF+sJdbgKEqO+LwWrL61Ld8YhpYsBuKtML+YD7vps8JtduJtGyRbYmMulVZqby5J0
 mqK621qc
 oVvPRwzdIMuejseD+8mZ+ByKAuWxr6ucOCrr4RZuHmodySsesgxVNJwuoVNsRInqoEcizRhQBPwAzfEAsK/uuHB3EDVGGGTPTRuEqIRQAWJWC287Y/1WrnLIE3+hUqnUh/PzBDg9b9HFcJFjCqNEUwwbKYdOw19g4g4R1bZLtV+VsW6dkhAEInt2effkSjlJQx6oNEE0stmxgxv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
Message-ID: <20261118002250.L5wk0sBY3Qu2EzVC7WmdJYVS2bxrl_adZ_GylXrcM6c@z>

> It seems 6.12 gets backports of most DAMON fixes but this one must
> have slipped through.

Queued for 6.12, thanks.

-- 
Thanks,
Sasha

