Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4F5C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048CF6B009D; Tue,  7 Jul 2026 06:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C666B009E; Tue,  7 Jul 2026 06:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52B36B009F; Tue,  7 Jul 2026 06:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF8A26B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:55:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45B261C7C4D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:55:53 +0000 (UTC)
X-FDA: 84961675386.10.778E11C
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70523100004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:55:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NaogLiKa;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783421751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qysopWPwsURO3z9WSrAVNVxTz4/XDs+oOwgZcDBRT9Q=;
	b=AE0m0pAoLqxWlG12pVzVFCUGrKZiewzxJ8qdw3QQJt5Dx+2uYvIEG0MbRAzoYPFSEu6BFd
	aauPcFdUn8DrWNmEd5yfXptgB/ut9KRd2sT5BZjV+fml+qmOJ0Rdiacdseyy4t1gYlP/ld
	LYppqLLdCzPsW86+cpN57PwpAX4lvuM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NaogLiKa;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783421751;
	b=JsxaHXLPPGREw4ETcnUdb6ceEozhHt7p55tUM6Ftcfwcz6HmStQLP3/hqPN5zxCwm46pFt
	aIf19i4T8wpaCT24GNFuBqtJtxAko+GnIGTx0VfM7f0PXcrGa26WX0wwCXNZ8vB3wkVlH6
	XujrRf9Dck+LJdI2TUY8EczC9y/hr/M=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c999f162c9aso2600578a12.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 03:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1783421750; x=1784026550; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qysopWPwsURO3z9WSrAVNVxTz4/XDs+oOwgZcDBRT9Q=;
        b=NaogLiKaBnQ2CAlZlSyWf5NcD/Eq3Bnef4QalbIrm9lZ7caRvoxgMvzpwLy6jZ/a6J
         NSmIxBHY+Ctuay4F7CCVD4GwUtcLyHeo+ntfttT5mUhzVe2mpQqu1eXZ2WP3yk45fdTR
         zjmKdZkatZWkH3MKHyifa+qQGswZLys/61svk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783421750; x=1784026550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qysopWPwsURO3z9WSrAVNVxTz4/XDs+oOwgZcDBRT9Q=;
        b=Cy5mUvUAuIW3q+nthiHLZutNe6XxMpkn0qMKfiqpl2r3XRTATD99L+R2ZaRrFnWcUg
         p3DpTSkVZH2ujxfmXNmA/t9uTEUcyIKnvmZFBe3Vxq/OBPpmov9d8ISmxhd9i7ZJ0KLU
         ZAUOvN4yxFYts1G+2jnkERv62zFO4JZGQRWVLFUizmwv5zMBXXdKNqq8JWr6vuZRHM8y
         vpFWIdoualPjDOWSda4XkSNW3Dt+pZ0rpLwu3cHQ3mPqCo48faRQv6lPy/FMtA8aw2ij
         BgRGzeEWOoz0tMNXLESaRgCBjHJB7Ol4NPEJe0OGTv/362RiBKweMxYZM5UWG17tJudH
         0Yrg==
X-Forwarded-Encrypted: i=1; AHgh+RokZitYzGxWJnsYLv1e9JHHop2O9gtwzo8SieI5DX0bht1HgmfHXRWcny5MpeG56YY6hG8TFZhgcQ==@kvack.org
X-Gm-Message-State: AOJu0YwtMY+yrzX2VIgKERp8WbiwrRrJluYsWsuvcgeRayPRcVy+NBcA
	lsZYanz9XwDLlk9r6GpXvJZdMCB4NMt9UxS575OwUTHQKWs1puhcxH21FmcUbnpM8pamWlBxbU1
	uT2e7jg==
X-Gm-Gg: AfdE7cliOyHcQJlD1nbxDVyDvaes1CvtIsSEn5dUbPsW80P9DdcSJ43dM9bZtjYFb/S
	Ush1KIEicSjLt2Bqqwz1+3SMp20rHAsKD+zUqdbLb3V7GUgpkKHmYZm6ZP5ExV98a1wcqsDBCIq
	Tl1l3M08JOU/08ulcsRqn5AKBRtDUMG7kRWTAzivTHyNL/FDUqkLq4RiMdiqG3Y9AMZhl7wYVle
	DQmy+LMxAwJB4ia44BkSjFWZpkBgJzc8i+DJwu51zja8xOsSnduImQuLANDoT5AQgYSvk1nQrXe
	29f6kZbdxi9p4tPwiakmzEYrPZGNvSs6Ya2j0XXpgPatEWF/InmNlufg0vGtIi7zXO7XTD3AjVs
	15Q0OmeMFTpxznKDwsit+o9ilGBXtNw34Rf8vhMVbl10C00sL4AGSNQpBlbQMzS4bf3MyR+fP8a
	tOAzXVkBNBtS8RFajw4T1A/tr+No2dHxz3miqbdHiZS6n9b9DdrLXphUJoi3jEWxo=
X-Received: by 2002:a05:6a20:914a:b0:3c0:29c6:20ae with SMTP id adf61e73a8af0-3c08eda80c6mr5744473637.15.1783421750361;
        Tue, 07 Jul 2026 03:55:50 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:d4f4:6328:49c0:b912])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5af6df87fsm781139a12.5.2026.07.07.03.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 03:55:49 -0700 (PDT)
Date: Tue, 7 Jul 2026 19:55:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <akza1qtgHm7zbjMW@google.com>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
 <20260707064030.D843llKh@linutronix.de>
 <aky05GBxo4VKGD58@google.com>
 <20260707093024.DPG2lvt_@linutronix.de>
 <akzJlY53m3XBg9Is@google.com>
 <20260707100241.zaM2yrF5@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707100241.zaM2yrF5@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70523100004
X-Stat-Signature: r4ins5xge56oyn3hesrajji57jj765bw
X-HE-Tag: 1783421751-55564
X-HE-Meta: U2FsdGVkX19Ac10O8RgBj30Jd/enH8Z3T5r1v4JE/l5mMZEmq/dIQXBcrdvgHdmLtID4pDnfwavntuyCgXewEyxehtzL6f+usiZn49jEMUXU2HyjhBzZFg+vgNaIX2Va8fQ3IkeX3FKlyFib2z25iFnrvRJUOUoQSegYZZyTLmnMXsXw7YumLeEz/pR6kQLa7vqSwvC/Eyt14w/BY7mzc9VLecDs6DiRk8mQ40uGLXCmOB1ei09AAWcREVJt7wYgftUBf7Q2kWMVOpRRt8gJdp3Iq/TLGMpJG1UO1B93T43as4B43tK+wHaoHlUCIzfNdtO9ZoXvu7+XvW3JLHxV8eVVmrzd7aLsEh9BVOrhtGVKV0KaW3KV6KFL3QWDuyW+cDGgiknfCsrBSsqNTwKvi5kV8e4PAQGwN9TgnrJSPZI0uvMdFSVso2GDMco50jtY2fj+2l2nO4746usAac/g52PrkJngQvnm1scekYSaZZ4L3PfIbqk6epKo5EqaGoSbisA4Xk864ET63cJ+IdLZXsDRPV94EwsmZsezwEr3yFGL7F8T92i9vkpz0Hq9SFcxzf5Rx3tgEhsPUSmHb0wSdvGGT+38OWEN1jOeNNEmUr6g44G/tWqUlaFgDfIx0Wx86o4zXiAn8gm6e2zjPxgTtCn19OAeukHNibQaDcjtNXPLAH8camwhrgcgvX9UOfKkwnU3rGM2v+yGRXorVn9SRw/9pm6vevlG0JE/Y8F/nI3TYrGh8MNebcP3Jt7DErzhQVeqxJiiM3qb0sHbLQwb9XCNB/Ht0AhLGxUg7tKuntGmNXCVp7yKj2euJl1tT3CP4U670YrA7Uhb+P64J0adzQttrZ5EFURbPfA2nsGeaBn+oi1Le9NAv+SCdAladhG5NkYyoSX0NoRJPt8d2605ihnGOJakg37013x4HcAvTDE3KijCQ1e0qDCu4Z2sWrYATX96Z/b4UD9gUdU0kJM
 KmE9IdXS
 HwKwymDOOzFa/o3XR//DIKWngcu2GF3u8KgJ/JGCs5tQxRa+VCifrYhVUuyl5SqTFh84oMU5V9/Fky4cLdVhlfK0zpHgARA3iu5ek5ZlTVFA9OPk4SL+NGPiWQTT6+0TYr0HQhW24duhWSEzAbt5EK0GhplDKDhcwFXVHKGAikmW2drqzhUNIFERS5/1L62GQh9o+dLt9lJPUurK03y+iU/Qujat1ECxpkVdle21mOKc+8jOsvtF0icEiKbtiYlfL9GwdG3bboSx6wn+//KW4h4DLIcJVm/PgklQF/RUIt1OCWvMqZ221VYJZIdeNtYdHM9dIkh5Q8P4tjpmx4ynVOkbBpHtSj6AEQENTW/ybmrZB+bEpzEmkAQv2DER4F7aIuslU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/07 12:02), Sebastian Andrzej Siewior wrote:
[..]
> If you have zram0 and zram1 and both have different lock chains which
> could result in a deadlock from theoretical point of view but not in
> reality because the zram0-swap never clash with zram1-ext4 then you
> should have a dynamic key. That means add it struct zram and register
> with lockdep_register_key() and assign with the lock as you did.

Sounds good.  Do you have time to send a patch or do you prefer me to
cook one (giving you the credit)?

