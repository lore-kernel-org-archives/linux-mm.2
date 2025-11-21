Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF0ADCFA468
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 08:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462A56B00A2; Fri, 21 Nov 2025 03:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413596B00A3; Fri, 21 Nov 2025 03:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350726B00A4; Fri, 21 Nov 2025 03:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 249CC6B00A2
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 03:24:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B550D13B1F3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:24:08 +0000 (UTC)
X-FDA: 84133926576.30.3DC8CFC
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	by imf11.hostedemail.com (Postfix) with ESMTP id 060C54000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:24:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=RKQrA+iO;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf11.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763713446; a=rsa-sha256;
	cv=none;
	b=2k/mnCZOX9xQgoKJu0MhD4105CLZLtDwZiUk9wQtd6FdZCI184mVTPPi8dbHroez3TSw3E
	4vZAhfbnKs5+dHCKeZiMNXW4Nhu3cbJXsO6p+j3A2S2tm82H/YbelBYSoKunqa/bBbim5v
	lQ2UqzqHhrnVNSNCKOm+IcCDt7QOeF0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=RKQrA+iO;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf11.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.64 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763713446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQLrOq0QQR+4eVsM8YUr1bTz3EqZ74x8PaNds/2DexI=;
	b=dIPgc3J9Ty/udJ34qXUxTTt2UNS43+tSkajwZJtrXLuAUJ2kRLsDfchMO9wOZ6efeFjP7U
	vLHeA87Y/5/nZCRNmOXJFX50XmAiNgoxIizVD9CIHwUlGMv5uSbP7fcwdlD7928/6KBNUo
	8MC1J/M6JktHXZLMQ7PYaPP1vj1yS5Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763713441;
	bh=pQLrOq0QQR+4eVsM8YUr1bTz3EqZ74x8PaNds/2DexI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKQrA+iOdCisookcvk14Z5yjxEmikMT3jFLMqCKPt4+GHVxIt5S81rrwrH0uEdnP6
	 pDuFjHcaURvWaok1m5L3XzTvVTbpvbEvZ6LSer899JgzfGRrZiMZyuDCGg1DptHrcJ
	 1emf01+1NNBEZcRVMxpDFc9fvAw2dIPjOm2CIyv4=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5FB1F4E2; Fri, 21 Nov 2025 16:23:59 +0800
X-QQ-mid: xmsmtpt1763713439tj8u89r6n
Message-ID: <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNP/nfJC+X1lO5CmizeW4R30yyEPSi+ZAOnF15s818bIUMKTLMFn2
	 7DXMfvxYVYiae95vc2wW1xWCDIMZzPkAgZlIkb5rzh2/JGLDZF9XSWHj5j/M1qaCu1AtVTFFjDIF
	 O28CWP1CSOQ3k8Jb8COVsS4Ig3DDTERdRt2/Ooy4mEVwg4o2vzZOBTxQnzS0+PkBjMa+85rnHstk
	 kVjmZTiAWY+JySl7u68j+maZDOOS9JCmQGBiHlTYvMlh801ypfiEnV8cCDz4o7BbB5ZHLuyk7ziH
	 hooCTHufT1M0D23oQCvYW0jh6xGfPp1oP+8dFZ7F+KdTpaNkCWicrCVzrT3k6n92IO0Nyq+r8Q8Z
	 C07AirQ3Z3pe5uoOO/zFXnWr3gr9tz3HqBdxPeaKTlW1y4oAzgOckWNpmx8jGy36K/Q+XrquUp21
	 UfOJHH6ykFXaOrEj0DmR2ySRx9m4hPCuOzMqewHyzbWPj2G6uRQ3St7Fort4UT7sfyYUKayEfxiN
	 0uDLFsRcQhyCSsCtpAry6fMfTuyAvvpBQZyeuMZs2ICo1TeMkzHdiSNUPziNQq99c3MrP8WUcOJd
	 As5txDvdJrKaBNh1FF7XBPPtKktzN1ubcgQukzFcmtP8HuRa7UgBRDOc+IcHe6+gXXW5LXtfO7tk
	 O4yJUHvRGGxulFxHQwIpgs3sgZekQ14hyo0XLoMeoWl1WuB8gobQqE3/9bGCVG6rVFpbjNkca5Q+
	 DDK4aKbojVkDKK2bYl2DiU24R4nZCZwNfeAyOyvys/YQrGKWhJdk4rnoaYgTjXnnNGLfG2XoNaCr
	 K+1c/9puY8rEb5KEBACZqDdWzjbJCZw+f8I/WmmfGCWbPD7pKyhKAKtaHLh3sikZayCIIZGK1fXb
	 TjQFw/+kWWqPvErQJZG/MpsmOEnTvT1YNDrGEvABOfxuZ9hhchRee+NWMiOYpI4mm/i+wwZ9S4aW
	 FLDQYud6juRugTSEfB/9XFn6qJ6QtMG/nXwK2DOWbV7a4A5SUyL+RgdyVhWEx92TxI7FZRpQiwqu
	 4Q+TYgH0moYERRYOHs5vn6bv9BVzPPPpXMXVog3oh723JmWumNdWK5gWfHQKYeCt2fSGc2H89str
	 bb/bdA9A28WRci2xS0TBKpQCkNcgRt5wjdfe+AmkfyWvYdaDGpEM7WBBUtig==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Date: Fri, 21 Nov 2025 16:23:58 +0800
X-OQ-MSGID: <20251121082358.3003848-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 060C54000A
X-Rspamd-Server: rspam07
X-Stat-Signature: amhy9acug4goof73spxa86ge4w4en4ne
X-Rspam-User: 
X-HE-Tag: 1763713445-629575
X-HE-Meta: U2FsdGVkX1+tq2Ri7jkmxTUxvskkOlo1xmFYFxV3XY+MXX9VXBjdfBjScWY2RfGRMixfn8nUeC2v6YiKJlfHjEgm5d4BqNPBelbnQUDJ4bzP82en2zERbPMygFmTQKvwSCYVh+hai81ygY0xL9qIWrsBAnYX41sV2cN4lGjiA2R+idXc5sGDZRvIeKRtpoEv5N1AzhVMwhpHl28hJIuYmmhp/QlRRKUCJ5PR0ZFlC5BtfImqaSB7IyDiMZbo3ghKMoFjR3g2AmRNGLP+FOXVPCRXsQ+CoFPOuiXLJncjqZnBpwkjlNKcYxAQ5WyddtJ2PE3r8XGkkfKnI7R3KGKIdZLAWf13niXpMcefZrEGNOmXq3sPEu9YnDJrfUZYB4HTogaBqrf3V24zh+K2RxRJBqeZOzXfLQkX2bYVD2TLPyBks4D9EV/lApPh4EqvltweiseMicdQCTxn+jA9bsZD36kE5sgq/xIrOHYp2aGZNoRHVytUCx1z+NOeMxwiCBQ90S2wtSKU+P/soFQ0+ARArLySiEen0fX4z/NUHcJ7wvJc0HmWTuGeuDB5joSaqBiQw1qKBQyoE/s+tz2I/MxGr0KR/hQWxjbuX3jbMMFg8Jz/lRN/sc4/D0jOyhQjkWKpIsUrG7Ry4sPtmr8GerFn62rLvf2pQwpaDdwlkXyxDmucB/TEelReSQSlUQAQdOo+s10vrqcAO3AGV5m7kKtmc+kbYAOzAXpBAAXKpCTVHZm5IDY6wYGsNrCkWgKZvTagZDJ03DYKLTr3eYbgBw6L4GOj1EUInJHXGhovr6sDM/F9JKe8W1K06myrQ8aK7KEt7qu6EZIWYGIzmSLTDhXzgs2hHHGxEB6JgfnGeDnOkvbsLMP/dlFunhpZ+6/UF7RpfCBWZl7eLnEcoCSS6LesB86wPU1XWQjpQRepeOiVuuMTPu95Q/Eq10nXS5JXQlVn03XGBANK+S+xffdQq6+
 Vns+OH5u
 BvZ9GEp1tEqSi1rWQDS5hdlHbRpFsq+FcVgB2DAd1ZiJUS+JFL1+ltamIPjuG1Peg9M1CAtmkYhOTa0vxLyF+95/yiogP1w1grfGqsSbc8UvJ3Ck4VutwzM7TFXSA9/1LkmkM16QUwOzgISFZtEcbSAv72k8kq6UgaCG67gZlpcLKe/RQOptpyjZBmvrds3Yx3M3Bv2MYZhZL3PSHtdqGRybDew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 16:58:41 +0900, Sergey Senozhatsky wrote:
> No problem.  I wonder if the effect is more visible on larger data sets.
> 0.3 second sounds like a very short write.  In my VM tests I couldn't get
> more than 2 inflight requests at a time, I guess because decompression
> was much slower than IO.  I wonder how many inflight requests you had in
> your tests.

I used the following code for testing here, and the result was 32.

code:
@@ -983,6 +983,7 @@ static int zram_writeback_slots(struct zram *zram,
        struct zram_pp_slot *pps;
        int ret = 0, err = 0;
        u32 index = 0;
+       int inflight = 0;
 
        while ((pps = select_pp_slot(ctl))) {
                spin_lock(&zram->wb_limit_lock);
@@ -993,6 +994,9 @@ static int zram_writeback_slots(struct zram *zram,
                }
                spin_unlock(&zram->wb_limit_lock);
 
+               if (inflight < atomic_read(&wb_ctl->num_inflight))
+                       inflight = atomic_read(&wb_ctl->num_inflight);
+
                while (!req) {
                        req = zram_select_idle_req(wb_ctl);
                        if (req)
@@ -1074,6 +1078,7 @@ next:
                        ret = err;
        }
 
+       pr_err("%s: inflight max: %d\n", __func__, inflight);
        return ret;
 }

log: 
[3741949.842927] zram: zram_writeback_slots: inflight max: 32

Changing ZRAM_WB_REQ_CNT to 64 didn't shorten the overall time.

> I think page-fault latency of a written-back page is expected to be
> higher, that's a trade-off that we agree on.  Off the top of my head,
> I don't think we can do anything about it.
>
> Is loop device always used as for writeback targets?

On the Android platform, currently only the loop device is supported as
the backend for writeback, possibly for security reasons. I noticed that
EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
latency. I think ZRAM might also be able to do this.


