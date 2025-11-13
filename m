Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7583ACCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82138E0005; Thu, 13 Nov 2025 02:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32448E0003; Thu, 13 Nov 2025 02:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF98E8E0005; Thu, 13 Nov 2025 02:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAC278E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:55:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57F97BBBBD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:55:30 +0000 (UTC)
X-FDA: 84104824020.28.A75259E
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 945BE40002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:55:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="lsZ/AFs/";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf12.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763020528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5xHITYUt6oFMxXRYSXMZYMrVmkRWvp/mzkgT57QABw=;
	b=LSbpqyaQFxUXg9S0dBCZhowQNYaVaG7JTril9Wqna6e6nVeHjOA/jhPgXkwKQJDNSGGyPT
	cwoyWdmpyLvqNquQ2fxWs055cyX6QSrYPtBQobTMdBD2ndTGzHfB259HMJui50fu/chEqi
	++hKkwuVgVuwTbAbxZGnRUA304I1LU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763020528; a=rsa-sha256;
	cv=none;
	b=5gMq11yGl9W7qwrjcGXE8OAjyWqB8ieATkSxXCPtza3QItEFjgLjKBBqWC8qks5Lv41WpB
	3qMLT/DFqtXwDb62sEDe8Se7DNqYPyox/ZtwE5zH/SVzVnZdFsx2VeEKVSklwBZsTTMj0x
	+eAXe1GilHSk5RSW1uFPYBTEW4xwhMc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="lsZ/AFs/";
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf12.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763020523;
	bh=t5xHITYUt6oFMxXRYSXMZYMrVmkRWvp/mzkgT57QABw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsZ/AFs/ch1AnbI2jmg3cJUhWwytfpFQ2qR3NmCqw5L5pbMMQvdsmQmjVtT0OQpMc
	 NxZL+Pn0mfPJxyCfohWTs1GZ0/1WwP2ZVvJlKCiEaMXqmqvZvOOzEcRSYFFFOqVnJZ
	 jhLGckLvpzLcsstCbRvPfDN9iTCsXHdSzIDK9utA=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id DD4BA6FE; Thu, 13 Nov 2025 15:55:20 +0800
X-QQ-mid: xmsmtpt1763020520t39bf1js8
Message-ID: <tencent_FE5751D11BB7EC389B2BC0B957DEE0D75E06@qq.com>
X-QQ-XMAILINFO: OWROGFTRp+d+cprrP6KWNZeBoDbPIt355KIOdz7m8YO0yifwHSmyC318L/1UFM
	 HQjK+iAcQMCwKSjbrPtsC5tB5a8AQ5NdkcSrP9g4SAB5M4UIEHZO06KxjpYRmJAc8xTyuCg9LlGq
	 2cIfEHotv7sPvLZW9Yj4KYRmoGTTswTwG0SgP3lychboOjo5ANiK8wtzYXpws2pqEPNivta748i6
	 pSvYwiaYLC2r1eyW5Rqi+/wasPYhDwZtFVo2Ctc3S5WKG3tXDd2l948ROigBSTe8pNiBWqNo9J7P
	 Y+YOGhxBUiansipAfh862fXC9tuiIa/mY2XrqH43W/GdLREfobKISqlXBaXB7z0Isfew4KXbXNPw
	 Bp8ihfv828SMU/k4BGO6GbV3ZgitsyvLzxgpBzKP5Ug6bEOQnbY3hwRmm00qedwc5cgyQQOonmJu
	 TJwybxJcPuiXot9KClyFQ+YytKvS+XeyWU55jbgPwR5yev3JeIjtAS//4Hsl7DxZO2M2rohbge6F
	 MjdmlR0esGEzMoTaZ4i8wS2kIPOMTSKZwK3vZMwSqVv9nRgWTxhiCAoD+tP2tDRzf6sOntmyKyE2
	 YbtwkgagBwt7zxLZc+4tiO2LoIFyTPN2PSo4DiheTdf1Okc/l7mE9Q/qzGCb/bD/XWE/L8U7B2Uu
	 UTIrycqxeiWo2kjQduzJk5FTavIWDSqN9UBHxos8docNkd9idrMfClQ0kOLAEMD5BHe36JHivPPi
	 5k/ACopMxuB8EB/rXIY7TexiAC8A6i3+L9MNdk3R7bURVbPE37d42w6u2tDPNXLw7vJBXemPUqTc
	 1t8w4B7KS1kpPOmBItMQdSwu5CjAn7s8wVRhMaU4O0bxG69jT90Sbz4p8IFDchKKbz034dKP3rb/
	 Q80MXqdJo7lTocENwm7HbaajYcVZ4H2EBaR6cPsVcCzUrveJxFkDWnb7bVpbg+fymO0RbL8Bv0N/
	 r2L4NYeTwjWJWIJVdq48tDELGZB4kCw8t+ybRkOGzVoGGROUCB4LyoTCunSIB7PdGXNtLybsLrr/
	 v6cBaZZ+j8xXLec9dlGuqjcy/Hy+vJNlEjD2lRRg3+OgfGG38g
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Date: Thu, 13 Nov 2025 15:55:20 +0800
X-OQ-MSGID: <20251113075520.3325126-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <x6ksirxv2xffhzpvdxmm5fa7r4b56mlh3kbhopljdsvwzg62wm@rrsslefk4rb4>
References: <x6ksirxv2xffhzpvdxmm5fa7r4b56mlh3kbhopljdsvwzg62wm@rrsslefk4rb4>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1amu83pje7to9fa4f58rsd6c144npit7
X-Rspam-User: 
X-Rspamd-Queue-Id: 945BE40002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763020527-410774
X-HE-Meta: U2FsdGVkX1/LUY67yATBxi2IsKyWTAJTPQOiekxAZ69u/CRXywz8h80O/AWzLnPUmYKP3t0owwNH53vTDmTHbcHQtzyBAKKkEj5J8bau/XOVS5eLTPc1tDRcmDIeMHFuuzZy5iZJvX0VG0DpRtwpVCKPFMYb6hUvjW+G7yGsHHf3oduRQxLRNYeVzNn/lr7NJPMWJHnPvhHWNq3gHfFBQgZnIwq29+rLe9OP9DJx6YjlyEG34ybeyHLQ6uyNzB8FcCc3PiFW+rZkEflFpQ9h2zOOqoeUq60mRdmQ6uXH9aO7LTRVcok/VyleXXGvQTXB5NDvif9GaQ8rsP9GUY2+fzbinFeKtf6lx/D6OT5HCqJbRtEwl1pTSsG3jq1f+PBkthcbmDsnIdx8sHQJ6HceO9GQI9JcrjzZoLwGxNrjQkRDoh37WGWuOR64XLXZ8f+43sB+uwUrLEHP6hsUP86HbqHVEiIwWnrmWq5s68II1uMe3qxu0g2Xnb9fLgrsPoWtspj74C15uko7J0nes7Qr/Y+xbeMx8awSJyCF9Pe6vv9IFPr2Xpgfulh3DfJABxEzeNJm44ilDuuB0PVzpXbnw27miAm93SY8rkzNaaZpp+CGx8Ti9Hc9Boy8lEiwOA0BHiEaY5l4z/linNN7FA6bOKaGDqLax5hKcDWnKwLPDhqxt7LlgApz/kx+c1U3GoMBPHNV5XzzGfAHvG+P2JdTvg3U+QDSw3N4u+/v8CMWb6O+BhsprdkbkgOqxHdoMLMlgrKQUgCxe/H20m+LFVMHw+PMWIpSOd+1H3ahoSNVdG5PG6rVqZTh+oHPyHev0zBQnWxeEoTjE1GtaSNNZAZS8W6oV/7Swh1pCt8oNoYkCzGi8RmUs46iYCzFVOVQgx3o/6/yoUxj4PQ+BB3zk1RfN+PreEHBPLC2DdzQleB8hrwgEu0JvqYEoEjXYAy4HC8f8E3Vx6VAaPWsG8xxPou
 T4D36xqb
 Q5H2cNYwvPRQDbvRcjOUkBEXEn00KeW80t6cOOlMrlj/71+rvjhAwbVPEoZyjnIqVNvMbcrnFink6qvg6fauNEPfjouwV/jgz78/quWNEHwJVGIG9+thtc3TxTF0kZfxGWE83O1XXBACKwafsUNUzJq8Hju/z44OePQfNG4D4vBXsiRB9TlP8eS32hXZPfX8PbrOgIsmZqts79MOQdxZKjBe+PA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 11:04:04 +0900, Sergey Senozhatsky wrote:
> How was this number chosen?  Did you try lower/higher values?
> I think we might want this to be runtime tunable via sysfs, e.g.
> writeback_batch_size attr, with min value of 1.

I haven't conducted any tests on this value. I just set an empirical
value of 32 based on the submission queue length of the storage device.

As you said, providing a sys node for configuration might offer
performance advantages for mechanical hard drives.

On Thu, 13 Nov 2025 11:20:15 +0900, Sergey Senozhatsky wrote:
> So I wonder if things will look simpler (is this the word I'm looking
> for?) if you just have two lists for requests: one list for completed/idle
> requests and one list for in-flight requests (and you move requests
> around accordingly).  Then you don't need to iterate the pool and check
> flags, you just can check list_empty(&idle_requests) and take the first
> (front) element.

Yes, using two linked lists can reduce the complexity. It's just that
before I saw your submission, I couldn't find a better way to avoid
introducing locks. Thank you very much!


