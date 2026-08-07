Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C714DC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64EA6B009E; Fri,  7 Aug 2026 09:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B160C6B009F; Fri,  7 Aug 2026 09:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BA86B00A0; Fri,  7 Aug 2026 09:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0366B009E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:53:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EF031C0129
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:53:05 +0000 (UTC)
X-FDA: 85074614730.20.67C4ACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81CE01C0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:53:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gfo2pa8w;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110783;
	b=ad+HeUC8G2w/QAxcDMy+NqaOHa6XMD55BsZcKvjCea4tAhDQU2QBobLjrix0exHQo6DWmK
	gD9jXKJZluV/kGjznTaj49ZnEdbwWublurtKNKCurtFIsPFpP8NC2UeSej/17KVJIHzu1b
	e3LJ7Is0p3Zn0/g8RuNal2HokHuJC9I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gfo2pa8w;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLmyX6PhcnTmivWl7rzGTTmoWyX2vh+vVEFc0xm/UwA=;
	b=FRhYobqpEDiqU/wc6jkO5CB4B4k3gkwqWjiX9nDxSz6Ht8T+5UYXV2PZ6XtDv61iHwQkSC
	ndGV2SI7kXMKInHjc9snYFHhCNFS9R6w76qsDXVE6OE58eGAxtO8ls/CmLKIXw3XuLaERb
	oMq4jjg1VSmgF++0Cd0eq8QIMU3q3jw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2F3741272;
	Fri,  7 Aug 2026 13:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D3B1F00A3A;
	Fri,  7 Aug 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110782;
	bh=XLmyX6PhcnTmivWl7rzGTTmoWyX2vh+vVEFc0xm/UwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gfo2pa8w60elepfN5stHdRVpJBos0YvI06jFft3nWQ3FRYfUPIf01zi5XHnm7tuTo
	 Zkggd8O9/GqLMrLkqCGVE5ptWcyNvt9iND1i6UMl7cmkwJkzXlBCR9dBAjKpwwlequ
	 Jyp+PPdKWaLPMZ/uCeyQNHKZianlSin6XLg9yol/feRbqS5yWlWcFVIW/SbeLFTtVk
	 IxM6FXjKhVBzsy2dWOB+CtuAqztbmgEt7tgZaVg/IdQ1PwinLLU3bK75p2GicYjdss
	 F8Y4QTLXb28Kr6Ht0ns6mpW8s2WCVPO7Pk2ibAFFHPgUque91WBVz2/fIKnf9R8pzR
	 BSJ3zbMURObRg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/damon: fix nr_snapshots counting using tried_applied flag
Date: Fri,  7 Aug 2026 06:52:59 -0700
Message-ID: <20260807135300.90965-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807093526.183009-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81CE01C0003
X-Stat-Signature: xhd58ympdjesxtwez6sdwjkbzjhrq8xb
X-Rspam-User: 
X-HE-Tag: 1786110783-828292
X-HE-Meta: U2FsdGVkX19pkfCQXcorI2jql5gTB9FZrfqyqZFkp8ctXBYIL8XVmH+c9lMMbixzBPRoUwjWcK64sIYHYczAGh5LxKiQu39/lc0IHttSsnV9v73YAlH2lpkqT2KaKFnrj5XlOF3iKaZL5kT4ZSrtAAwMCNmGcP71AB8qdn5cdheuYW6jv7sJQXrYY9l8x1Z6mdurWZyoxHoIsEZuOG6v4f2FUUdNuw2TlWz7yQuSrkhjVL9td4cMlZRLryGBx87gUtYwMNeVtJ9Pq1QCcN7n6j3vpJOsvFzUEMq/k+nBVeOD9kI2KpB52zGErQCSIYeT8J0X7Q7eUIzVeV90XGDmoP+35sxFKovHL6TJdz50LLQU7mGpL2K7v8Gi6GP913GoYA1qIVphCmePWxBFOaGIsXccQYi6G9x5tvjtqbVb3B8hugx8/kV3EVGfuGJo6uNZ8mtRWg8/LJ8WYmmFVv4F46x+s2DEIOM6wIeMetIb0y66hM7gFaHM1STTxtkHBI1B59zJac7NaAgftBtTm1RYUDlIeKi+OMIrbOKPogEFIy8WPCYEV8wg3wanliwZlDWgRJ3t/HmCKRu5SrMjT4c4DtWZn+wvLL2oC+X6lPdPylCEqrefTJHe+08MEwr6MMGCZc/mB8Vnp+NxOJhxgdYbG8JJAjvuAjEvkTFPLDL6IuMFpBmjT8m057vZBtJXsWIIiaX8HjKIMtJN9mFeeAdghDxlVtXsF9XOWEYShG1c+v+DbLvQIvSEQRAGb3pIiWosJ0iPW8z21JhRGjCGEKpff6Xk/NOXV7vzz9SXp6DrCH8zZHRxj9AXxlEcVCMYMG8CZecjIl5neMUL52QMQrSL2tk7W//1WDdYrQiruxKpIRyqcgeW4JRhr5zi3R9S9+3K6nGms9CELHq0q484WTfvWXwoWIKaKfVSEnJJTXYQVZ2zO9WyFKGQDDCV9FtkSnB5+HOkUHLeLTCYO+DMZK8
 VpCBdUkR
 OW5pnYBpnPxKurL+Hb+cetVVoJ13FVNNBmV44o7eMaq4UCN7EF/lRrNfdkgEOGN1mizzRx8ZEnk9rYj1W8QyK+VjOzpd6eY2r1UeKavXmvn8senj108anzUO8EekASn8dMvho92NWzb+anA4kyOIEK4ln0ZBtoHM3IuMXy2WwwnzWiOhv+WrOa6TPhb/B8WeuD16QrYhEu8OHEbQ05ve6UB2Wn3k/MjCRiEKI/IrRz4LQ/JASbIn/ZibG3eW1UYxKxSgawJPiHjIKB/nqTMaSfmRDBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 17:35:25 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Currently, nr_snapshots is only incremented when damon_is_last_region()
> returns true. This is semantically incorrect because nr_snapshots should
> count the number of DAMON snapshots (aggregation intervals) where the
> scheme was tried to be applied, as documented in design.rst.

I don't think the current implementation is wrong.  Maybe the documentation is
better to be updated to "...that the scheme has __completely__ tried".  Let me
know if I'm missing something, or this implementaion has some practical
problems.


Thanks,
SJ

[...]

