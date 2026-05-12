Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73523CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750F16B0088; Mon, 11 May 2026 23:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700F26B008A; Mon, 11 May 2026 23:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6179C6B008C; Mon, 11 May 2026 23:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 532976B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:36:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF654140370
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:36:40 +0000 (UTC)
X-FDA: 84757355760.10.0A0E3ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20260C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:36:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZDXYucW;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778556999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhtn/D+0+8jcVVmNb5wa8k3pAaS0G5+xGjvUQY0OKz8=;
	b=ys4kgrsggwz72//hB+UU9K6svtyc+r1eEB5HgZEIJHvn8ApBmidhk7tXAPCXUfk4/lmU3U
	CuEUAi4orIHnXIBKB1fOecCp5HmFSJQWCZqfANwS1mGgwr4kH5Q8axqPcdAz/+2f7SPOIT
	IbPmbgVaEfz6OJG8EstD3jM+pZR8T2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778556999; a=rsa-sha256;
	cv=none;
	b=eOIdI55oiU1i4lO6rmBlIKPjzObjh6En/ZeStgj2SaWF+T0S9wTKlCzAleZ8hUZyJzulvd
	7ULh5h4M35No65jFew3TVRQ9D+K5lo4M3c4xoMKBZu18VXAXCLLull8WJKso04VXJ3ZhHm
	HbTJ/d33nO2tffV4VZSyCmMLuuh3UAg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZDXYucW;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B4A96001A;
	Tue, 12 May 2026 03:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E911C2BCB0;
	Tue, 12 May 2026 03:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778556998;
	bh=nBacPl1IDyKDaFSd7EUOB0zxBS7q9hwDQXTfwXout78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZDXYucWv1jr6Rg7S8pHZ32pWuwoeCEZ2A9gv61rRHiPXEoggk4ealHA1WnH6c77o
	 bVIYPcoBognsU4yzqjKQbVA6yKgsu5Q+dozHqNViaF9Ae5YcFABykWb93FuxeDCbmP
	 LwyvSxReD3lVfDwR278P42nZbEEvmksNb/vWvPnoWN28xrHtqdSMrKhLYngqAXgMWv
	 Dri8lVeygOg2jcxvMds8oGei5E4/NWJSEt9VoMLrUiaU66baeTt/KPomea1YM5gRJA
	 unIYNwnkSrPDY7eXEjzsld1RvloOqCcBh4P4GeeJhw0G8kuXz3yseJTVjGPFbEKD1t
	 hYxoBgHzp1MHw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 0/2] mm/damon: validate min_region_size to be power of 2
Date: Mon, 11 May 2026 20:36:29 -0700
Message-ID: <20260512033630.39793-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501013750.71704-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20260C000B
X-Stat-Signature: 73musqs7fizb5jbnr9p6dc969ieyetgj
X-Rspam-User: 
X-HE-Tag: 1778556998-343677
X-HE-Meta: U2FsdGVkX1+HevVBdSVP2CLCMrr9Kr76R6H9vVqfFYa6osWBtaUbSN0U3ST7Ymj7MDtjyIRj/0dDnddCkXB8aZFlfGv+shikpGC54pQYjrPPBuJIxa+UdPfPpupcIGdzqFhALoyAszB7F21yBlG1t9cdJOGx7E/SgstHNDTXY4Cag2eDVOPo/1yMT+v5Xk62UrawZNG+EIxsdW6MuSBv3qoV6t/NiW3+RM8kpMv72BQIjyOoYeRsJ3WIAuChPxz//Jq7QlAMkh8cHYwMAVpR5dUETDumurJj9abhdZ8nfHLMPtisVZY5GbpMCGd4UG3lkzLnFYWQ4diHyTUR27ZXqQ/1nk04hRlcBOA0hyRgjCelPM5PmklFpA43jUOKoLtvoeWxGihfaZVEkNt5t2GsXUL+EmHk1p+R5E6XuuiSEBFe5TsHfu92QSTqZbaVXOznDIWtoLVyV0giVOVKZBUQicMFLUWwV4qAyAyb+l1hLeS95pwicK3JgVv/VTQKXbPzJUz7owq3XAYwAkRAoRtOINlO9BMzre93pnSNibO3XBWjrgAi4EIK4bn+98tSvhEtLfy0qS1n24lzVlveRCox/DCAcuYtenFm8t+2Js++ZUS1UbVlOJIySE9GO9NLbfJA19Le+NeZLvlZOleBGXwRp8Jd745MMHvaUh0P9Kq7gxXjJHceEvYCR7Sa4NfwEcxDzKwbM1TLRvVAJRMLz0/rVzC20xix8GvTVoeIr7KJuTDLuRghVTOswmCQM8UY6KqrfVltclvIYpItq9w7TWPIcNqrZLGMtlCwC86JT7SmWkhvcThEZhcPnI5RytyclDjRT6YecwFG0doS8ll+xGsyVQoPL7+vyQIqLXCpxT8yN+SqJVWlNDSoHa3SgUbkqIJZdzpjgYiJ7VNkbD9XhKGiYqNHjcz8mctJIl9tFkW5fSz/Cwn6kf57sNNOK7TabAOEy7BeWGeq5PqmtVsZXJ3
 9Smxv/uI
 vW568d0uFLGYIJlQjEtSbWED3sB+VmUlFT6hGURo10q98oZOAHnwSJdWOWcvwga2S+pCOBGdOich6y/vGWVpaPVCJd9UhmcIKPhyaEbI7f2KhXHdvySSsFj3KBcAXBP/fv7u2ER0CeUbhktxwVt4dyw+2/ksumLlLRlKBXOKH3A+fArPMgkxI6yvnkEKzsJzbQcxW8SeFsV3mar+aBsfVXR3eSoECe9wqEFdckFargi30gJh5l144WjJxtyXpfX9oEUyZ/xSd+B+C5UQPFkfHSWrwnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Fri,  1 May 2026 09:37:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via DAMON_LRU_SORT or
> DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2 value. While
> damon_commit_ctx() correctly detects this and returns -EINVAL, it sets
> the 'maybe_corrupted' flag during this process.
> 
> This flag causes the running kdamond to terminate. While the termination
> is a safety measure, it is suboptimal in this case because the error is
> just a simple invalid input from the user, which shouldn't neccessitate
> stopping the kdamond.
> 
> Solution
> ========
> Add an early validation in damon_lru_sort_apply_parameters() and
> damon_reclaim_apply_parameters() to check 'min_region_sz' before any
> state change occurs. If it is non-power-of-2, return -EINVAL immediately,
> preventing 'maybe_corrupted' from being set.


I think this series is good to go in my opinion.  Could you please add this
series into mm.git?


Thanks,
SJ

[...]

