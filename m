Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D5BE94108
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 00:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956ED6B0088; Mon, 29 Dec 2025 19:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9966B0089; Mon, 29 Dec 2025 19:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E60D6B008A; Mon, 29 Dec 2025 19:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 670946B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 19:57:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 003A2C41E3
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:57:23 +0000 (UTC)
X-FDA: 84274323966.20.5EE6EEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 67C421C0002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:57:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAXJeUIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767056242; a=rsa-sha256;
	cv=none;
	b=I0jMsCRYDE6VWQzNvtmCUZqXjV6wOKlHF/N2yUgLJT2gInlUBC58TPSbjQA7Os7KVeydy1
	XyhSmyoqvmPEA0dsQAdaq5f2vIPOxAKtCtzI1v/8kYL6lpZ0Y9BF1iCa7qwEG4BLqQVOHC
	YYycewg8hvv/gRL6gcatGAbq4oYSipk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAXJeUIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767056242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kw/Psl+58bsrCLO7LYf8h0yzFV2Tnz8dq0RwXb7Gyfg=;
	b=w0JSublZnE3/gJvz0cF/BhM9gdUYT2RvVXnzOduKk/rcOp48e1lzdFSfLNkttgTRs3gtDH
	WYhCnUiHLh48q3s4NDymkYBIGHVCzW5EVSEu7r+bmeM9hRJfAUEwIj6ZJExbLlYNJY/z84
	RUxaEuLmTcQDW/ICWoblckNNAHapA1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9192260010;
	Tue, 30 Dec 2025 00:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2608EC4CEF7;
	Tue, 30 Dec 2025 00:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767056241;
	bh=ABitZlA6pWrBbnmGARMlUJQ1EKCA3LyUITLpALBWMws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAXJeUIWr31dlu0uE7PzO7zGrqXoJuxZj5Pus790ITBskoPoBxaMo6pVDq6oVDE4u
	 EscmWo4deN+eMOTNgxdOIL1+cmaZJSaDvMueh3vAkAZ/VDTONRPvSwD1Ke1p7tmqDL
	 iEr7hifloPMVGT5S3o3gRPG3GWeq7MeQTz1ThInONgPHT9dg2kaCkjjnItTHo8ghG/
	 yWe6LU3NDlAgsjTvWssY/H0u28Q7W9Ga5d7R+D2KGvOZ5J8OmLx3Wqo5aF++QvSCPS
	 QVnuH/eNb+tBRMip8rzaLGyOSkIgwAe1HVVtNkb5IONLv9MCUwk5Cu15k30nRbPgkN
	 GLHXauj7uL8sA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
Date: Mon, 29 Dec 2025 16:57:15 -0800
Message-ID: <20251230005716.47160-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC7ondk_Gjhetb7Wtsz60c1dRmt_h9MwT8uwh0vwaktDLw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67C421C0002
X-Stat-Signature: nq3ih8budue7rqdzhw6q6wmbtzp1o1pw
X-Rspam-User: 
X-HE-Tag: 1767056242-837030
X-HE-Meta: U2FsdGVkX1+2brGLi7YvWVoFrnNCE9MQTmJin84KLscVF3PqKGqCGADsI8mbt+V1hpt8Z98yqFS/PQwD85I247IxMO/rS9nk0RE/vEBh1x76+M07cQizukYVEEvhLrbez5m7XC+1tAbYMfcbnNS632Unar7Nw3btWczs3rjrV10+OAdu47honOLoKx2MfpKcHg4qCbKzFxlKH9XKcarlOow9D4WK4AE2yw2SJBxe4CM2jcvDShRk8uJEDd7WA+CtKOp4wgrEaLuAOcwaIgdbtdlguMFC0Z9b7yjsRPTSidn/tA27/XZ8Bv1rfI+Y4bwU9WQiAr1P4jXL6F8zhQd8tF6c9W7/7cn9X3CxHhXpXSwhnOn5CuFjUuiXysN6GaJyFTisgiifvSOYzfg7o8aMUkUqTHpRCUteSo5qd2KvgdFbJkrMyPGzbfEbEZ2SyO68nTipC5mKcXf724VjgN7/b5aCZerQ3xFLLxBsV4/XKnL7giqL2wKJtW550kqwY+tk5Yp0bSmotBvHuauG6vXpzarg78bgDgdD+f7dRhdxbW1o1PHeu+tkfzD7VtgtZJMWp5btPVavy4sbGj8U2VLbTTjt3EmDdUfiK4+kcSmTlb3ocQ9AYuyXX2+3MeXuFLF5pa7i3EmCBra2iTYI1cWP98vgxqtWsW2utagMpg1tZwb/V8mBwjQZmmGk3EhEL1CXCiuIL4hfrYx/pkTQpvr1Kebiey2I4dIVhsOKmfFzsd+0v3V6vgk6Hz1It2xRgCO64QLmtERC45EfTrwYx4rmAh3iCUJdC/M45p5uWDhqqQA3XFfie05tVj/01H8SIPy4MkZ77v1o71Tzmtt717vPpdcR8fyrYrJxGE9tLsICba0ieinQxNytUgHayU9bbtBOZi1jEoPIdwL0zsXioP8Z+ZN5n0lr/ctGNZI8nVRvLDht1C1sFKBchcuFFo/UaoIJgm9Nh8kfi3o+ZD4sCX9
 Z2+HV5RG
 C+L+rMarEcDKg6VfM5lzZSPpYzBN69/KItb7nfgGxjejqY43+iBCenyjJYqMC8XWQnx6bBofvnBvsilEHLpW0LOuvaLvkqx6V3pwyhXEkxINsFShllgn20zFE0zjcDqvd7276+M1S7BYAjQ7ybrExdrWbfWIoFFAe1xy9Otf7MlCLdaAskCBkXH3Rla8Q5zBNO6L9LrJOkLt7wNSYj//41BZrw9JVpfEQZPz3BrFmdLZAbHsE+Hnwet7gFZVSOlxoCW2FgM3TR3krRw7q1VVt0xCZzODBaL7YfngeRHYglh7Kn6MRE1T/VRMJ/udXu4vVqvJ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Dec 2025 09:14:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> I will reflect the above in patch v2.
> Would you like me to resend patch v2 ?

I just found my fix [1] of the bug that you reported has a race condition.  And
to fix that, I think kdamond_call() will anyway need to be modified.  I will
shortly send more details as a reply to the fix [1].  Can you please hold this
refactoring until all discussions about the bug fix is done?  Sorry for your
inconvenience.

[1] https://lore.kernel.org/20251228183105.289441-1-sj@kernel.org


Thanks,
SJ

[...]

