Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6863D111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BBE6B0088; Wed,  1 Apr 2026 20:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3216B0089; Wed,  1 Apr 2026 20:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FB46B008A; Wed,  1 Apr 2026 20:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863E86B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:40:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA96B13A3EB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:40:31 +0000 (UTC)
X-FDA: 84611759862.03.402B713
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4928E100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:40:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=raO0q6T+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775090430; a=rsa-sha256;
	cv=none;
	b=uVk9bt8Wi5gZ3/Auj+xAjGahbX0PsPb47Xq5udwCTXHY0/PhSZ3ZqwBun5xkJXHHbRkctv
	AKHZkHFHNO2SKfMhBbzvwShIgE3ZkpLk1rjLeiag8CEIFC6xOpLvRHrsMB8U/AqTRddodW
	vjiIlaAcGm7RgB2seFXAqbMXwXCI258=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=raO0q6T+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775090430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w39lkvGwMHpSqiuyi6JXpl2u1BhZ0nzIG8GDC8wymGM=;
	b=UlAionlAbqdi8uE6ptJz8WRqJ9tr0mVZRHVM32MLpw2byNxRlSNlCLL0DVCYLwRzTFLGv2
	GdhSuWfo8fhIAEdqCP5LpEIlK0NLJeJ87rc2DOFhl7xww3vcIHLQe2Y9PBLQTPLzUrenM0
	Iv8xqxyp8r9FbWdAdywYSf60oHc9kmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85227600CB;
	Thu,  2 Apr 2026 00:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1549C4CEF7;
	Thu,  2 Apr 2026 00:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775090429;
	bh=JF8+debzMCtcQ9RFsdSB1opffxjgjYKLJ5l4rkKwMYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raO0q6T+cev2ccGk4Aul8Z47OvE3wCTq2XfWf2aSKSUsJqrvGkZSXMyLXkA/VfCtB
	 zshh84DRoKZF3VxKwMNYT1gvHASfTLdBTX44fkGLBjX3IS40tY9VOp+HryWJPOGMR0
	 +qB1DLNMr4qH6HaPJSOj3PdQSIfeG+icC2tqPsaZC4v7Hsqs6BdB1AAlLxWg/1hTPW
	 tAisz9gWShnDDqDoxqxUNDjI5OqR5hAu4pCIuzp5n3siq1g9G42O3JE/4EGlTkItHh
	 bLdwetdsmUL+9iCQmYaueHjqJRhD/EMUVmr3cLCTIrBtI8eqaL9vkPcboYsYz6vFnL
	 xOvIi73SwB+6A==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed,  1 Apr 2026 17:40:27 -0700
Message-ID: <20260402004027.64439-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401082354.12467-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4928E100005
X-Stat-Signature: ebue3x49xd5w1441hujoyd1h8qftxmtb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775090430-24964
X-HE-Meta: U2FsdGVkX1/wbuYKVDPWmdUUSxxIpcwN/Z8tb3sCt/tT5evLWwmkBPW2BdeHh2H+YumoWxRoUrI4AK61TVqF4pkOchr1BeCG7vtiaQhQaRSrpPjTEKke7RXgdd4twKLKVATcnraAa4z6LcB+3VGhB+5+lCBKwT5ibbbQ3td4Bg2IswqNK8WeR/df3zERwkC54dFDN7F7NpK9ecSqzKvIx6yscg56Xc23XrABFilfYOeUnueohNoS6kKRbv3JqmKe5bus7zPoMDIR5C/mWDm6aAK7oeaeFTz1oBWTqcpRAfbgQYkcsiRbuYHzKEHiZ0//5TzrDiZBpuqUoisJORqy3UuNTxXRZV9NxXmo/NQnvCrVLxdYE6tVo90NgfaCaYloRUkUruJTum7UTrX4ddFd3faaoszQl6Il4DDR1outvSybEhCVgtjbhQdBkwP1zEf7MxFMEwzh4irw76hn1PLdbXy0XUKSa0fbJIQ537E3L8lF5lgBEJzGCI5MrPcf8aNPBZ3GO+Us9ou0Wvbcgy2eFZhs0JGIABJ5Vg4OyuJLn0TuVjPyA08I0aLuqPb/54/w91yFphx8dl59fs+aMbrWm0yw4NEfcgVU0X0hRSzS7Kud1Xmv6oef+mNRFTZVrxPbkIPOpL4C/DT8d+MSEvwM9bRY54JS2YkXSzQeHRTWBuHBgFRxKV/S81BVTJUnD5g7OXOPj1O3aGt/MXAlk9/Qir+4x6ed9JSxdPuqtQWv+w0cKtMQiZXpUQ6+jMR5qfE9+eLaOPf2oCWpD3/r3n3Oo5To5lBRgaCvjeAubDrG2Sk7iNV0Fgk3hUEgEBrhVAyNiB3MwQy6VOU8OdvX8jtkLyDgv1i2mwpPuqN/ajWN5BbpFzqtiH3qH5nkfzkRjwSBqHNRseCZ6d4tzMUYHXusOP15Q54PFzuHvEW6f8qF+kcNRKKMf/DeufoGcF7BCP3bIZ+yTRCpX38JjqKrQW2
 lJ+vLreg
 942V/8f14QYl786iG2fkzis+Gij+v1UzXYqXGF1iUD7rHyfbVRVPY0rlOP3OwKg8S6n33DooZpWqqpT5f4fbdyX5eBH7g+22QvPw1C2Kyk4S1AVHTFRmXt+nDiR1iQ4n3m/M0kwNRKZgC0iO8ZD8gtncqEkfHdUyLWsw5mcXyG8scTQ2gtWisI7YvKXXAMjglkWR8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 16:23:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> First of all, I apologize for not completely answering your question,
> and I will be more careful next time.

No worries, we all make mistakes, or simply have different tastes.  Thank you
for adding clear answers to my questions and generously accepting my
suggestions.


Thanks,
SJ

[...]

