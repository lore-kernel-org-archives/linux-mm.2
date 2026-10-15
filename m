Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB5DCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302986B008C; Thu, 15 Oct 2026 02:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3C86B0096; Thu, 15 Oct 2026 02:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB526B0098; Thu, 15 Oct 2026 02:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED74D6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:49:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C6E2160951
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:49:05 +0000 (UTC)
X-FDA: 85323933450.12.1F1BE37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C98B40002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:49:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=voza9Lwq;
	spf=pass (imf07.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792046943;
	b=M6PSHTbikRf/dyRsHv7Y/uKQ9i4Z6o+6u/TPhAPw+3H1n2k5Luz2z17Tf+Y98j/CFiusTN
	thvKhU+ZPOlwtIhxfxfD5s4n1jHvh3/6BluN2Xg7/2XiyzTzF3FYZqYVBLSgHuCe0QXwXl
	Og1zKtNfgIxHRhW9gwpAjBeUqBfmI28=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=voza9Lwq;
	spf=pass (imf07.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792046943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpBRtW1c5Bvw27pImafqkl0rftVd4vCurbfdpumHKZg=;
	b=RpbN2lxQDd88xg0dDdvQ/xfoWN/lLJg/qyt9keL284jU/SFN/eSketyj1h7V/ro4hRpExN
	OjUYBKTyqtH9t1DvvY0kr6/rZyvRACuJD5gsYipVLbS8vzL0LGIQrl8v1iQY4HuzMavU0U
	F8gFAubusc8QBv5VyMlG6C45Z423TSs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25E241516;
	Wed, 14 Oct 2026 23:48:59 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA4CA3F871;
	Wed, 14 Oct 2026 23:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792046942; bh=jH94vNlTdIwm6jZHBQQNa3v+vblk6T61f2PK0+CjxmQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=voza9Lwq+doL2sr4Tc3HIACuSBabUN4ErHuDJ7uOkRp3uPTjRLxSkIB9sWKSBblzJ
	 6r/2gVeyJuu9+U/yX8cS5fPBAWnjxOFpGv7VGj1fIUpsmoflzsy0Q7WuR/S+pqd6WF
	 lHRLY2D/OEzmbbHXY3f5tvtTMtBUCD2FwDR5UPW4=
Message-ID: <f09eedd2-3a82-4184-a456-6d8a3b0f4139@arm.com>
Date: Thu, 15 Oct 2026 12:18:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: test mremap DONTUNMAP with locked memory
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20261014191803.196515-1-ampr.mhd@gmail.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261014191803.196515-1-ampr.mhd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C98B40002
X-Rspam-User: 
X-Stat-Signature: itg9sknq4yjk38pdwnwz31tzxw66ph4t
X-HE-Tag: 1792046943-128518
X-HE-Meta: U2FsdGVkX1+Zv88M0b7pqP8mq3hJ7i5RFier19OjagqZrD/NUJ1gvP5K9ImNmQFxr4bvhDJ8FUdSU6jBcRbGmnAp73sI7kcThKOWtU6MXvoB4Fr/Jz/PGlAXMykQE1oKGl/FnawdHSDxZOa/AJB7d9Nuoq+ph/bkYFS1hd3zhbYJ2p+4WOWSgDEIh3KARSv76QCh/xE7OBAuJm/5DJUQC/zR7fnx0s+IATPIntd6qOA+Kv6Tgkvj37F5jelc2pI8tAKHMwztdKOUcSaqiU4Qsy91KySP8DLBOrjhLMp2mA9o8W7tVWej66HfG3JaQG6X7xnw0Fyv6ZZ6cPnZm8eas4ZPfmQPgIj7gsl0/+SmWZMfHGiFAVCqjQB3cTex14MUFuHz5vnhB6avQpJUig5kX4enzGyv05QHO/ylGdAzKTtpiG12eqq7/PKxw7WNTlZzAWZp8HXS9oHhHmQNYxWna7GmhiuDpBND1kuBVpSx46ZVzcYdcxXY3HDFd/QmqKO4Qh00FtD4KNeuncwtOg/iit5QSkuX/dReLW6GPAGQvnmxENcbZ2f960ttKtppQnAFlBC1t/mSHTm5mZggWNsnWwzbEKIVte8awP8IyjUxh2qIBCNX23FqPjCHpHm0fHPSwscbdD9Nsw15doKPfgdaJsibUgGgleRk/eFS4I+snJOifRZVsiUummI1vEvt/S3gV5G82VrdY1oNeNLyPYhUGrheKmXJ+bQwMpFGY9IVThD+mx13iIIxfnFnSy/+4k1rhYuOcnYouWjvQIDl0wz3C5CkBRyzgsrGxSgEMF1672l+94cVw2X1dQRVbM0CFMPZyBAkQ5WjXiQonmToiGw57A726gqNN6QXeT4LT4BZvNeobpwysU/LIyVaS4Op3nCiQ3vRJSLlgY46ym8P3cuyLHGBwteucgrsll/MURTYcn0Csl4HoVkP+YGfmpl4iVYqX2QjWg7o1gExeQ1q24v
 j8NuvgY/
 Rgn3LA+sxT0pNwShledUGOxT4XmUFSPtMhZ2kSWxTIBFRu27vUjlxow85JaMsr/P54Nt3lwbA5MMCPUb/iHLnwRPxp/OsmZJpq/eitQJ2N1GtgGhpMairMYF+6QcI0KJ9bHuIV76f0Nf0buSPepGvPjBS38Z4zG3fz+D4mFUES96NjHZGJhPa3cCbAtRi2qfxlix1CTvNYqqLs4MZ8zEjHCgyNDsz/TzUFHhFjjJqiz/1bZdBUtSdv/brCO4/bn7PTGHzWJYC0p/zotx0Vs+qg3q/GRbuPgru+jn/kfffWGse22IuWRMm3lHGLcuj8MPJ/rH7p8ZLdEK7RBSBYMWWp4UdmdpLhxVwEJJRWarqyDtJ8fTfw7lhdu5vP+OftavprpgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/15/26 12:48 AM, Muhammad Mahdi Amirpour wrote:
> Check that a partial MREMAP_DONTUNMAP operation on mlocked memory
> preserves locked-memory accounting and that unmapping both mappings
> returns VmLck to its original value.
> 
> This tests for a locked_vm accounting leak after a partial remap.
> 
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> ---

There's already a patch in mm-unstable that adds a test for mlock
accounting [1]. It covers the partial mremap with MREMAP_DONTUNMAP case
as well.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=35524c870053cb28bb056fb17e715ebebec17229


