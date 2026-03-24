Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1C1F54AC7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51A06B0089; Tue, 24 Mar 2026 11:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02B36B008A; Tue, 24 Mar 2026 11:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18186B0092; Tue, 24 Mar 2026 11:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A10996B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:06:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CCE61B6FA7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:06:23 +0000 (UTC)
X-FDA: 84581282646.30.356782C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 543F040020
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:06:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkoNFeL5;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774364781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gP/iem24GKD6/XBxeyGvjIYQriduyO4JRtmZs8f+DvM=;
	b=7nRwpVG+sioW4GbHlXrt5p37jxbh3PTVVz6L2RroYbmHcXrWZbTe1YpKRiCupH7AtzXF35
	5Bo02RvhhRPADm/7ZxAlHe2YJ4hrR7YPIw0my/rAt8trurhv9BlB5m/0V281PQML7fUBgi
	Mo3bXB7yph2O2PlxTrVoQrMXsTL1d7E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkoNFeL5;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774364781; a=rsa-sha256;
	cv=none;
	b=EvhljyXieleM1yVh2Tg6ofj2PwFKNSe78aT4WQp+IxCEJTjDToUr6/vta0urtMnqkuCmQC
	P7v1wgk7AIIo8GiVcoquO1iG8zBNBddXycxuRzhVDpCMdRxDKT7YSX1SovS/iVQALgvkyW
	ZpHMZAosvqxzRcP5RK6xuF3aYfe97as=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1283041AF0;
	Tue, 24 Mar 2026 15:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9248C19424;
	Tue, 24 Mar 2026 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364779;
	bh=/Pkl3ERIJblGJmh1debS8MoBSBQPNjNn+kFUL0+4r1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkoNFeL5OSZwqroED1E3mZnCVF17BldTgUOcIMJ9gcbPiwRAB4EtzOSUIWx5nryXX
	 qnfZVuEDVag22I/X4naqGRTn4WhV5oFRVNJanjPd4W060FtwUcR3dl011DkPF9Tt+c
	 hL0zOZ87HnFx7hJx3LqvvPr9X1xUoVL2SuLKrUXvLHezscyhg0uOLL6a99c0FFT9zF
	 RO6JvKIH2tHPifNhhRx1/HrTHcP+ERf0ytDi7J1OXUgutVwge+GLqJaWNz/zjrIDru
	 jv6kLSlhu7/0LHDmLNTWRc3HwoULFQvCSxJL4Rcul+qWVMdv6YHFr3jTMcr/zVMrTh
	 Ll9JYlWQbTBEw==
From: SeongJae Park <sj@kernel.org>
To: Cheng-Han Wu <hank20010209@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Documentation/admin-guide/mm/damon: fix 'parametrs' typo
Date: Tue, 24 Mar 2026 08:06:11 -0700
Message-ID: <20260324150611.92050-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324144851.12883-1-hank20010209@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 543F040020
X-Stat-Signature: ygiwfibdcey9oqdydpegk7zr81dx5fm5
X-Rspam-User: 
X-HE-Tag: 1774364781-43986
X-HE-Meta: U2FsdGVkX1/XT/t0PwFnC7dUNQo5fE6GGna4BzKd0Sbzpo6ZRdSGv3Kqb7PvHMNpftXoQpHF6kPUsHydQmRDobhAQJN6BmIVs65icyEZ4C3Al5Qf58yyvzGge8v1mikdXsCyZZ7B65wR1C+MZjdgBvxdOKhOnj8XU8sLYGpHYmIFLKiMvoJOk3iIzW8XryKYoh9hyibKV7wG5D8Z0+qh/+Au4MgQ3ROxbBCjlJqfwPfy5/EwjnUh99o8TxMEwJKF1E6jWKwtHSd2innuPNkHDxP3LRrTCLasve4A8j/j//3lN190xqLOz85QomCYSGDayxjqZaxTD8Gr/YczaU0hI96nI/eA3Z5w/TYZeVoUjx8A3k08NswEUcsQbJUCEb1+1Zw+ciJs9qkfcU4WaXfVx1Mln56200BL0Wq/2wUsBjqbwlaQm7YkFgzu3adj2VepgpjGc4oV9Nw87xrKe9KOcIY4/wF15jglmSHlpkar1L4e+flkXjTlUOQLVgD3XzjrSBTBnwO2JLjhAmD5Dr7TX8G89VubzUXgDx7UAsT50DMN+J3dlQtjzKsZA2VtkrakdMkwY3vCl8qQMY3CgTk41Jw2F89MbXhEfTEAIeMWUc5GI7GLk2wMiPpaP8WpsiDHVyLihTVpACiw6FbjDRuD9p7rv5kziY8QW0vNvnxPY6+jwi2tcumHMOb2JL1mxvRrjohMOhducMxyJ8YYs6B+6rxoXgVXUwoTAn1mQT9Mr55yVdzgV5tZNRTncPnBNBCsdT17qIVKphJJ4AtNoDpYhVwMvII7rjLhsf8JUzfiK1+mocNVCXwvnYRTc60zaMsW0LQ98JamnRtT3x2RZ7sl1tls8JU3cJ/UuiicmEmzck+7lztWC+T4kYNAtg43ilWqZtsNavhOoN9kCEkbufdOmY+C/+0Er2msFw0A2gk82Vp4Ql/Q+RYm3ZgK7njvKw2EpVgQEFZPUazERAXRZTm
 kzXzwsJy
 4QyKfNCZlNki8YWWVmwXwwht4DpGk8FlUqJzBk/efPB36tphpDMw0RC12X8AEgjXkjpHderkah96h8HpDgjMV7obM1YYHY0CFLQKlmafDWOY5E+VYeHQeZnyqJK6sPNaYo0dkxSBzx7GXTBPmhFRJmWUSq8GgccFmbSB3qKfwDqsJ2o92oGctWQo35xVg4J1QsCfwfYNsCbhRuXd5YN5NfiWDhF9dpin6UqeWPskU2kRN5mohcOpKvENwMxbFBZwsCDGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 22:48:51 +0800 Cheng-Han Wu <hank20010209@gmail.com> wrote:

> Fix the misspelling of "parametrs" as "parameters" in
> reclaim.rst and lru_sort.rst.

Thank you for finding and fixing these!

> 
> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

