Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668D6CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6386B008C; Thu,  8 Oct 2026 07:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDA36B0092; Thu,  8 Oct 2026 07:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4C16B0093; Thu,  8 Oct 2026 07:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1EC6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:04:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D71DC0189
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:04:36 +0000 (UTC)
X-FDA: 85299175752.20.D4CC952
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA74A1C0009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:04:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEZnvdbH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791457475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZk4kmtV+weBTEPyGq+1h+AGsdm3cag6C0y6gwefIXM=;
	b=jM/hPebL5KcCGTIY16eWNRcAFZAO8/vPWqQuwQVlXrnF60TDS4L2nxYU5rt1sArDPuFRhf
	ogsEl8ROmKPsGXbDfq55ysOSXPcZjuTxr5Llwrjv1tneLMkYko84o6URcGcUs3BA3pT5VH
	isL4Egdt4482SKYFN7VMb2ObZ61guTI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791457475;
	b=jfIVCBPbDIHZvKvAb9M6NqENUICPqfsA7ZczgCCujqWFEeGQ9i/wqnNlEq5sTNTPJbhPd0
	hLtOIWrYxyywdlWqKesOnKnqh2BLNGxNIStiH1e3UBwF2sRayzHgza+OSZyk8RxRz2IblQ
	eZYbrI55jZStZ4U6Wgl+SmalnRAMmWE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEZnvdbH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D18E94396A;
	Thu,  8 Oct 2026 11:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C991F00893;
	Thu,  8 Oct 2026 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791457473;
	bh=zZk4kmtV+weBTEPyGq+1h+AGsdm3cag6C0y6gwefIXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEZnvdbH8cWi1V2myGiQJ813AhiOpAdDmQC6n/b8pv/F1MgafcSVoR/2Tm6wqSsP7
	 rv8MPceG52K6US2zmU7DKngE287GQDo+bGyF1fMjdkWKxG7d+oP7ZiQKtAc7II/2I0
	 /+VyYgYAxlnBKPI8DtZWbq7ujZt/8cbV5jb5uKgyjPk7vViEyP3rmbiZfY5MI9OyHX
	 TEL8b54hqi5FzUSOCWSw9YAQJUJOWbsnUzOwOsuRVJ7PTGCm/3/1n6fk2E8/HYfY1U
	 s0pSuwM3dnC2mnneXMtZnD9qxk2zsaN3w9ax3a2+1RxoKP8T/x10pS9rilBzcNL42Q
	 +t8fRhakfdUeg==
From: SJ Park <sj@kernel.org>
To: Huang Adrian <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/3] Docs/admin-guide/mm/damon: Fix various typos
Date: Thu,  8 Oct 2026 04:04:27 -0700
Message-ID: <20261008110429.41646-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHKZfL3z0-fVa7HhW+J5E0RdEUoR-E3wMFYmQ6C0ZQh7t1xoGQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA74A1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jwxdjrq6wsdomx6tuwy6k9qfmaar53aa
X-HE-Tag: 1791457474-962425
X-HE-Meta: U2FsdGVkX18xcTAAEeH0DNYCrnkf2jkSGbCLrvavb8gydmxJb9pYTtx/8ywEhc0g2p5fgZDRReVPJS96IsBIOhzCebGbjU1ICvE/rShVCL8F1pbgNvIIsrYr4HTLX1s7ZV5dIoo/EvhD66h7/bfVsCKEnn35QLqy+ES3hN/YbMdUPUI6LbLKl+FgNyA9fijFJoaDqkIqKFQrqRzd0CGKphWK0xN4D/VqzXeM/iqQ6m5hAfHsRNbyImldZFo/m8AmUUcU9oVwjaFjuP8SZ+C9BjmsmOCDp/0kHs8mfBUPGs6ciPlTwxHwJ5MwRrsivpYIRBjTI+j9so+PU87J3G864V6lwjijSFvFiYjsM28bUBBbGiZsDs5Edbh9Etcyuqh60iDkfxtEljKJf99lwfOsBhZ+LK96W2Ylci7A5U/WAbh91783iiVCWIyKPfLEE5F7c39eQh2PQMxEqTtIPfJTVCSqJ6O3Bjxbl0e8bDopvfUYwY1c35JowI57KrpdtEsdGc7DzxlYI5yTWY9UNpseBOkaMEJkn12UFLRDwR88YeHc6QH3KLVUzFwCEJKFfecT+ajawH9fH7tNoXvhg/NYcIodd16kipyFkzdLn4HAYChki4u3F35FBjXuzxX64GVRH6RmZr+EcQy9B5YgGQ2rtNCk5l/nOJ9nLQsR/NfPpaMzeSPUfwtcsDp7K4kcLLPbWJ0Zip88m6X0G+ISwQqSIEboKjc6YBn8kwuEj48tjicgYfu0HVFtOjkiG6L5Wb+oFJLX3bWRWvgbJlJifqD4prSgBqcfywste+mwzsP2Uc5AwgzJNieW0Y/UjhAKt3dFi1Q4gwhGIBMgJ3yy3MPXMUEsFZG13t1EVvty+ubvfFPPiN02SCYFFzsZGv/d6HtN5zPAs2iiIy+wBII2ucF0wgssud4gbKDVQiN1+Z1SmN3hE9PBLeMDe3+oDXPUhchaoh7cejYqOEX9mkHrI2K
 HNotrRCT
 ZWitijE/FtFxCYlMMA6KV3JsOErswfDk+8qE+A/x98H/b2Wk44vxwiy94Qt3xJByfTr/UH66rFlZ3MRpvCoZHAVr7cKjIg8O86AVGJc+pshidseVFomxwtfje+KOs5sQqNBN3n4923esPO/443eBDBgvLrr3IpAFuDcbJxt/J04iQQ4fJOoZtoiolHKPzNsxWj32lUU0KgCoh2bWTMgdZwIlRTKasyiEOL9CzzDS5vyDRTy4DyKUvJp1x6h4ft9RWpJtWMXqmh0mVQdaUQhUNCYv2LiIlJ25IBj2VjBS1Rawr4/728+BvTjp9IBVpNZ6L9YPwOJMbf1gIL954ZvRFjpy/VlIq2PRp0Lou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Manuel,

On Wed, 7 Oct 2026 19:53:18 +0800 Huang Adrian <adrianhuang0701@gmail.com> wrote:

> Hi Manuel,
> 
> On Wed, Oct 7, 2026 at 6:30 PM Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> >
> > Hi Adrian,
> >
> > I have read your patch and the affected files. I have found
> > a lot of issues, non in your patch.
> >
> > This got kinda big, so if you don't want add it to your series
> > let me know, then I'll make a patch on top of yours.
> 
> Since you found those typos and grammatical errors, I think you’re the
> best person to submit another patch. The credit should go to you. ;-).
> 
> Also, as SJ suggested in the previous email, please post another patch
> to fix those issues.

I agree to Adrian.  Coule you please send fixes as your patch?


Thanks,
SJ

[...]

