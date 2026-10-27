Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9C2606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBlHJW5e
Received: by kanga.kvack.org (Postfix)
	id 5AAF56B090F; Tue, 27 Oct 2026 18:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582596B0911; Tue, 27 Oct 2026 18:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCB16B0912; Tue, 27 Oct 2026 18:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAB66B090F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:31:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D028160B4F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:31:05 +0000 (UTC)
X-FDA: 85369852890.29.412D7D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 61A411A0013
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:31:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBlHJW5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793140263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=C91okvUL0Y06ewCeQiKP8nerc+m3RbY290lx+tzKN94=;
	b=5wee+VpSnzBa0bk50ELLhEKnE7eMOMfCy1cTRaW3Danlp31tciP3RnQ/i8Lcf4PRzASNvS
	u7n0eGdOBP8GU2XzA85aM+l+Qg4cDxmif4YBzq5sA8wOy8sWfkAZeTbuKBpN4qMINgVwho
	KQZ4hghHk8WDNbiMdhi3CV9o+SQxt0s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBlHJW5e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793140263;
	b=MLPUOVTymMzWarPJU4Rx4obu90FbkUaV6uZVnNSY4zTLHVdx/PsCm4624h19Pdul0XBWv/
	hf+YtBdfnxE/omaajJonzQCW25TqLW3f9XeueHkBsnBlnVJ3ajlXA+qrkRrKFB+50BP/oS
	o/jsPJkr/S6mPo7g4FwIS45JF5wuhBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A78D240104;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7411F01828;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793140262;
	bh=C91okvUL0Y06ewCeQiKP8nerc+m3RbY290lx+tzKN94=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NBlHJW5elIhSS+OhmSVFuesAqDMhnRwcfbeccaaZ76VeYGKFAYlwaHD+IdcU1Vzrp
	 c1B3o3w8cBXRjcCRZ1iy2jTau3PCMATXurhVgq57pKFm3jxKa2ahv7dh9d0ROWjHjM
	 eHgROE52H2NpPOiAvikLp2wsDSZNAJiNpISpsNZ83pP46tT9HRXoyJTLvGWoH2IvgK
	 o5Xa9pSCPddkB182ho8BcW1JlM8tqsrY27H9N3IncHs6ISr16SjRLczSuijunf5d3m
	 apdk1qTpPYnYjHrI+e05PKKgNNoilQWSU8g4JizxsdUJ+S12SMfo22ok0MopOwrhHh
	 6wxeHtP9cXiFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8140C3AA940B;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
References: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c
X-PR-Tracked-Commit-Id: 183895979c441e52dbd651b388553b09eaa35cfa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a36f53fd5ec3eff01f1b637d42cbdc3821d0493
Message-Id: <179314026135.360848.9768940194637210306.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 22:31:01 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 61A411A0013
X-Rspam-User: 
X-Stat-Signature: ne4n8on3jmsxfwzuz37zwi1ghu675yf7
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793140263-804993
X-HE-Meta: U2FsdGVkX1806pexmpS4pCWMk7HxYmoRyHC14Yfx2GD+bq0psipdnkjOWFrPdBfNdz8tqfO2QV7IR2CXPIGeZq1MHIq3TMfWbZmQB7XAGZguNM44GCFxulJOrC+pZK80qI44L1i10PyA4LjRC2V5JMwmvWSAxGoFyxLmwyKEnRFS2LYaC2GO2LNUCCatp+D4wLPM2OnX+1vhkzwEa2C7hwJqA2g0t3shqmtU14LEnQ8IVg8tKr9XzTaUczuKTTKsYJekpeZ4kySc7pMkxlnToVunc1nFjyGfWAqgurZsVQscHW7Wx86DBQ580wDAg3VtCqysRVTGpRwV3XyB4l/kLbNjWJM1mWp7KpASVjBkLA+jkiP5bQvF9DlF3EdbDhX5I4oFuNPR94vNjGk2xVapm9ERTzN/rA+4ZB50jxu/SuEESiJLJZJL41gFd9a2Fl1eXud/6W5fmHp+3VD1qTysd+2TnY6gR8bd9rY3wVCzrGHmH40h7Zihu57p7I+FVGk/6Y4iOaC4OziG4d3Utk8Aq6fZgbw4VoN2J7VrXmx+gKNo6phwnQtr6/1/rfztNMR4FSYfO0Pv9Nhfw0CkhLCqlMzUJu/TcKrNXNJrergzpr7CWrG+Llz/m5rxuLZZK0PjldONzgLmJsu1gJKFLAZp5CNlPZz9/rtrj9TdY05D+D9shdiFsxemHiK3G1+1Wvd8mYnQt1j7sua+5myO14l0uX3JMP4F7myDFyUIibInpBH59Mt3Qk5Oe1xCgO+ovGOCs0hHRfB9520KbM0OOOm1xuRwyrJfLg2V1mKapeKe4OC31bCBt3ASPcpoMmruxGyTh4NhEEQqxm1A6eWZ5I89sgcvk5Fi6MtaO57xQe7D+nW+yDqFm5O+C/thSps/cs43trXucKf8dxgMap6dApauFei8xy4m2C3r2KnDdLkdnPLt7oeOtE4ZGt6YF+f1WBFORiElCNgTth+TRWlmqZQ
 g1NxD5wF
 hqyDH+/mZbvZ9On/zK47XtY+Mz/DeiwECl1FWaneeXRFSqDPt7FJxIT20ttikGZBXo5bNkEQFpoVmY+AyhjyDLIaowM/RXKcr49jeEXXwUr34Bx8+MNBlnrfQXPz7s9/B3G80PGr93lehX1hYQQp2jC3mOlsGYNW53lTs9La42sFkc8FR6qQAd0vvHll9uMxxgKOtAr/uF2+ej8oHR3c9oOmU0u7ungCOt2I/F/1Q77yB1JVQfaQzXsVRcUtBKY+sYGiebNYFcfXsZ38m6Tr9h9V0rCX5p396NUzhdqQTIG7saWLoPU2jq9yUEMf1GjZpz/joQBLmQvl87iFjolmzx5nvCWNG17m4qMgEJ4i/v4vgdm/+aeNO1IWOYsILPlwjEuRjB/jccrlxGXaWdJK8nwSM5hl7TgIS8Ft5Jmh1pbLpTKkWL9/AVB7Gg0Bue+xsW6F0PHzVw+/U2hSYj+jRNwuJZmE5rPtcPgKIfdxgm7rw+Gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Mon, 26 Oct 2026 15:21:20 -0700:

> https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a36f53fd5ec3eff01f1b637d42cbdc3821d0493

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

