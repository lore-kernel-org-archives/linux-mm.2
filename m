Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5AF6CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC136B0088; Wed, 14 Oct 2026 23:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972146B008A; Wed, 14 Oct 2026 23:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B246B008C; Wed, 14 Oct 2026 23:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5634A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:19:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E02C61A08D9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:19:48 +0000 (UTC)
X-FDA: 85323406056.05.E9DB36B
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E86A180005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:19:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QzrA/PAY";
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792034387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDuUS9lEAlDmYNRCGgtkqtpjRNa5kOmWvu33Let1WwQ=;
	b=h390n8T7MI0Zd56Wf8IqB4g2zEadpqZdL27jorizXoYwPPvWLQ62OZXJwnMjve3OSlsd1t
	8AL/CDb4gDNrKAowsuCdvOLXnXzn6uTLdOwTV8sYmSMeaoC7Dh3bHY1pD9OhquW+Ikjf/9
	+yo9zbLTFjkyqGXefjq7QY/Bg5c96Gg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QzrA/PAY";
	spf=pass (imf06.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792034387;
	b=UqkCPhYPi3++OxnO696BefLt/yjDZyWeUw4b/K0llY6ZGSkJ7b0n2K/xcC1TjE7gilwPPL
	Lnt8Fo9IG4l+cButQiFG+BKvDzv9MC4Il6Zk1jZZLdBKY4X6v2eumsrFmHpioddmtXTKMZ
	7OzGp0RkOhwbW5IMQbGOs3Zqmywv7+o=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-35f036b17easo1332888eec.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792034386; x=1792639186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dDuUS9lEAlDmYNRCGgtkqtpjRNa5kOmWvu33Let1WwQ=;
        b=QzrA/PAYEf1lExEFbfAViflm9I6//VA2vuVRQE+S0X5lx/trDo01ZOJUTid1ZntROP
         AP9X87a1STkhhdxVVTW0P81Qkm37MBTZzz5qLT4RDMKP55iOdNf6vyIkN/XUL4X2up4b
         7hNsE7TfZXyGYnmXJ8sgRRgdM6MAFbf+ZnMxqCZ+mkxeEIbZ+N9hnak+ODR1N58ZmFaq
         d0HEXZoqHO7c309OjIKhqla1nm++hCw5RZWBFoynEVDmTJi9GCDHEMZGlLYPa+uv4xBi
         0ZWTMUSuKdCV1vmx/EaAXNcj9m8gqkFZO28qjyBRB56wZxuDHPSUdzLX6WuV/aLJ1x00
         RX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792034386; x=1792639186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dDuUS9lEAlDmYNRCGgtkqtpjRNa5kOmWvu33Let1WwQ=;
        b=rKKCyGKrC0du8PFLvncOx7gwP26U+C8Iq8pjsYQBQjU8RcykLxBdblNpQbAv1dGBEm
         mG0q4+3iZ9zo0NkiDH3JzGUBIump4ZxhCF39RGNrgn1Ws4owOm2TLtg196Q5TE94eDpR
         BGw64DcGDzIQ8p3whEFk6DxSUoq7cW9g+axbk4qc3fgKMDR9scmC/VCja00vHF5g2HW3
         5IcwndiORNwCv7plrlr4S/J/q2vlAx2Jhxr4bPZuXXBx5MUb/gSclt2Dsgor5Jhwsfh1
         7CM//AEoBDCFLpK5nkcRjQQ5DdsHr9J6JvEMzzLjG0aY6V6qNbQ7QHpNB34Y0eRZQgJx
         nLIQ==
X-Forwarded-Encrypted: i=1; AKwUvBw3UpkpuI344HOG3XQWxZ0P1LKA31kpcZUboPmSDfsPAsahhV2b9z/a+my7p7BbQK5V9AKOCBzr+A==@kvack.org
X-Gm-Message-State: AFq9FYJqLqt4a3IxN5u+jlaCGi9z+2cIWNtbk83SRPFwbg0XJxenxAJJ
	VtCLxMRZMySm0D0JhZtIaWsO0G2kAmjbVVvTVUI289LFQeDeqqw0Wfvf
X-Gm-Gg: AYBFou0c5SkkRN8zby1CTU01026Bl+on/nFlfyBQS9/ouB+8mfC+CXataO1gxgRYQjd
	aYXMqhm8BGz0JaFWJTl0VgxDMzSDtAmZQsSq7CvudCZFv/sPVtaTR2yfpS4AR68rsh/C0qtkmcw
	CsVpzh35mLFW814mdCF5g14HNi3v2MAkmij76FuPGsCrF0DFSpaJA/bQkCge1GWaZKFoajGYhuE
	sU725cp77cqZDnntQRQ4oKUOkzBXftARqB0tyQEMXVokPTkDdH7nmvJZzde5AWJTqD4+H7pkZum
	sZQ/N/pbMER25/B7LuYwGjYPYj6lYMzdjXSsl+SJgcEGlejHlNa0XhrnPxYd3CUcjUdCZJOtO5x
	mxhedF6UGW2Wm7yDp3Q4Soqiu22mmek2SfezUjGYO+VF4mHziLFiN2cC59Y+yGBmoVc6hnnk8ig
	DTzrp1vmvIxMrbxszhc6nLMrUnM8+YmWnZ7j8U0NNFPyP85eLgiOyQXdfMZy9cMq9X6fWjZ42F3
	ZbrsS0289GvaRFl
X-Received: by 2002:a05:7301:3a84:b0:351:985:e729 with SMTP id 5a478bee46e88-3537e01e8b6mr26189806eec.12.1792034385583;
        Wed, 14 Oct 2026 20:19:45 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-353814b556esm64832837eec.18.2026.10.14.20.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 20:19:45 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: baohua@kernel.org
Cc: senozhatsky@chromium.org,
	akpm@linux-foundation.org,
	bgeffon@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Date: Thu, 15 Oct 2026 11:19:40 +0800
Message-Id: <20261015031940.1410875-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
References: <CAGsJ_4wuPCPR0DnbrLp7ebdO=Oih6K_yP4XxwETKQ+3U+THVjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E86A180005
X-Stat-Signature: qtf8octo3a1c65xi4wy97dj88yhik56s
X-HE-Tag: 1792034386-511796
X-HE-Meta: U2FsdGVkX19WFi9Ot4khhRHkQK9yGdmEGnwCUGBgO1L2oaaYClkTDZ9JwbEmo89nByn7JV0z61QNF4YcpeYRhdPVZjw2f6x5OwZrjedxDxEv+rWpZ7cKWLDXDFC7g4YufXvLgFBW90KtciZWb7v+yIwUURc5v28tTfZ0COSxaL+xNTg/xx77wRY9Ggtyr7H1Qh7Mwmq7meJzB1HeHz/vM0PYqwNZP9iqDmI7hg5oPBFPA9lIh9D9+dIj6XcvdENmCa3wVpRZxW1tTjP9nta6bdY94nx05vauBWgzM05zs9vCTaMFoQ1SQyW2gWP4uPq185qK4lqZpWCGRWF+PtZxUVvPH7Ad1qzF8kCo8t3wQZ4gJS7Oj8BWfmxbOk3f6IoveM+wMkPwK1scvEPSee2bMdWSlJ25Egm3B8mFhJTh8ayVA8UHZC5IFHQ61iuLOR3RQQ/7coWGfoZmBb0cHK/6DgUL6W4A5jyuuXJ6Nv6d2bOFPiFIAfxCTRpTHlD0IXsGbpUL+j10aKWpEwenlLGrsd0XAnScZkWrFxtZkHkVMCoYKpuHjOHBs9h1ZBC8n3en3ZKPiSoRkf8qyXcKAJM2pVhuy7eQsrFsFzjSSR4CnS3bwLNoDHcjfJyMGailx5HrZYmRZDc/UXK3/cEUZVQkaT8C9hPl/fPuatrfihg537gnsKkstgV/5nNArpflkp7OJnQeN0w7l/dp49CKEmdIDwpNE/l4efYYrwJf6LhlNQFg7u4uHDdu1/XMLc1gZ7GrEIMCjPUYbPv+PdDx6U4Hw3IkE/bM2y2IKtg47rTk428yxbEP7AoguTv0SlVp7AGGh/TgyyKzrMislOm9gvxPs5T0AU1/Jwm4l8C6niB//7xvgfdz9EhoQNTOmt27EiV/6iII8UiEPxz0DQaDaZ40+VluqaTgn4Vaoxj5aFhAk0pjDOGTmuKTobAdoTxH5VW5fI4GLhdUU8SBTtpjXyC
 17e7DY1k
 KN6hGBSHPjaRiPFdC54vq4AfXlhhAcy1w1hVzM1N/xnK1WbiKA6wAcfoery7f9aHS+XLnr7dWdr4w40DyLZhN2KAY1N0o/2SMqudgvOuaRelarvcbFh9kbhd88EiP5wvaVeUm6adlQ1iu5zPWNhTBEy4tDdu06088jOqBgpi4vBiVoMphMC4oV1oteMlcsvZy10FZgjQC6dtLenCY1pslywZuAyFSwcxuW2rL6+H0tDWpmTikkx6VyxbzaFfccafpwqe9nfKnBPiDIoq6/v/7Y81r1igQ1fWC0xGycxxJ+aZw2P0ONLqfjgF4S0aNUuBgkH1w4BVMC1AbyCnirLeMW5ZbkyRQfJGpK9nIva9nhNUg27Rx5Yg6NzqDGYj+qNZ7NlvTny5Ndr9lIUkNoYtyfBeLQnwedJD2Wrku
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 04:46:27 +0800 Barry Song <baohua@kernel.org> wrote:
> is it due to the case that sg_is_last() is false, local_copy is needed?

Yes, exactly. Our tree isn't on the sg read model yet, so I detect the
single-page case via zs_obj_get_pages() (page1 == page2) rather than
sg_is_last(), but the condition is the same: the residual exclusive
reads are the cross-page objects that need the ->local_copy bounce.

> Also, with either deflate or zstd, create_dctx() will
> always be present. So, what algorithm are we actually testing?
> What happens if we switch to zstd?

We're testing lzo-rle, which is stateless (no create_dctx), so the
~77% shared figure is specific to it. You're right that with zstd or
deflate every read takes create_dctx != NULL and would fall onto the
exclusive path, so the shared benefit wouldn't apply there - as Sergey
noted, zstd mutates the decompression ctx and its dctx workspace is too
large to allocate per-request. So the shared-read win is really a
stateless-backend property; I should have called that out.

I'll also apply Sergey's vm_map_ram() patch (with the memalloc_noio
fixup) and re-run on-device. Note this only helps the cross-page part
of our exclusive reads on a stateless backend like lzo-rle; it won't
change zstd/deflate, which stay exclusive regardless because of
create_dctx. Will report the numbers separately.

Thanks,
Bo

