Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6B5CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FA96B008C; Mon, 25 May 2026 22:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19296B0093; Mon, 25 May 2026 22:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07AF6B0099; Mon, 25 May 2026 22:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3446B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:28:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BA071C0148
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:03 +0000 (UTC)
X-FDA: 84807986046.21.A02B7E0
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8830516000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jN5QE8jd;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u9B1EjQHGqQ23iNLAVOoHqkoJQynG3WH+EzXh7vse5Y=;
	b=TrHnWLSFxVoB4bVQYZ420UoNGPw91eav95K7rOoE4m+hBy8tsSl7DvUus76f2RcPTLI8y3
	LK5av4UlNP6JZWrUysDboHaFGL7D/v5r8TmxLuCKbCB+sRv0gbZlkhPsRiB4mmj6Zj0mq/
	i5/mKjRcK/wp90oLjJkvqUbPLiVhRKA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jN5QE8jd;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762481; a=rsa-sha256;
	cv=none;
	b=O6DOpxlJyMDemIpQ9pPfJa2QoAOKcKG5LQI/a0ZZxNUleM5hWf3r4HhgaDJFrNgOm9ngAZ
	7hTAL/0DT5f2HJzTnpIBsZhVM3IaEVo/JNSSCC9i1awY0ixi00eWW4p9RYQ+5zyeR2FsMi
	T9BWAE4fLoJzcoJnOkS7Gqs1ecUMER0=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f8b60e485so4178776b3a.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 19:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779762480; x=1780367280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u9B1EjQHGqQ23iNLAVOoHqkoJQynG3WH+EzXh7vse5Y=;
        b=jN5QE8jd4ewpwNSaLA3cmEwcLqrvIKZzWKwvaykmOSZWdkys148NOWAUzmEpoelezv
         YNI7BNxgLhNiL9HtZRYrUr1ECXAm43EHlbwHoqpZcuZfb1R4l0SAn7+dEm37Dt6e4fVz
         FxY5zUjX/TF4FxMMO7U6+zVo51yPmqlHcsrNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779762480; x=1780367280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9B1EjQHGqQ23iNLAVOoHqkoJQynG3WH+EzXh7vse5Y=;
        b=Dpnq0zPIbrG7wfPTLAQHNJ2dnPE+q/qaY+cQxU58KZDIiWVUf2s9vIXYPqdTnKn66a
         WIiqmLNK3gbZ6C16f+8UWwRiuBs5/kgzm/xLtm1stq+OIfTOvB4EawLzEvEEjMyNVCkt
         jd5jmjl7mPX7VN0uO1E4MTBruGvjy54PchZp/ftJS2XLwPerwx6+pPIuroOq9hHaClTk
         BJwUW2tFROhbDkXDOVJ++VLc0F6iQ10bFwQnM/j2TrGhzqAmSNJI+ZchX6pCOBCuFK8i
         zW0Zx7lacAjgLY5KdFwmP3w4SkqfSHPuBrAassZzN76meWEi9d1HrV8AeZ7o+emMxH7o
         2hoA==
X-Forwarded-Encrypted: i=1; AFNElJ8efnjS0LfL6wjPul4ItZU387tN15QwwPtpOY/cNo9obB7YD7l0UAXijodlQ1kOEDYBCBVWRzSgvQ==@kvack.org
X-Gm-Message-State: AOJu0YyNaKsCBh2xSLKcW6kl+ITHPMgOYmvn0MyN+oPsDdkVIXiBJoPh
	AeohOIi6LhxjGa7s8UkLM6/BEa5J7UcrPi+mJ7YTFOahtUBIFSTFsYTulPoxQh5mIg==
X-Gm-Gg: Acq92OHg9NVfwEz+fx66Dp5F+kOAHL4zrgCnCYF2q9Kz8o93wSm1nMNMi44+DVv0byi
	hbRFkHE4vs3N5cfhRj12PXQdSiE9T8H3PPlHkNjRx7Psw7CGyiTsIIqJThCd25FjKx/TaW5Y7Vg
	nSYdvFn3Mv6/eOjOzm9R1Q4/t8x1D3MQ6QclItk139gJ05AqGd2yCEHLh3E680+GTA+uDzVc5L2
	7AMrJzZedh53JKFgl6EOFh0Whxj7n38xBvKjNiABf9hj1yjGhwMWpDO2j4h/juVb/W51FKftZTB
	ozTkwOxEQWaV2yhekMOmWHebqn33sHNbT27AWXll0A0mPb5BklKBJNAX4i0eZfEFvFi6HwtFRVl
	NHcTxmJCfzXJNRogPo4ctZWTfA2PBRcHgOWbSzoRF6ufgW3ujE5WmdmtSM2sOjeA7cPUgCxHDX3
	VmpU34nx81hHQ5zrmJX2AcBS2v//5jveMoGvqWoiRQa+XatRmmUD/mJTBglrcsRNz7GIvoFobNM
	JsJt8fHjLOp+29++yqGho4Z
X-Received: by 2002:a05:6a00:2384:b0:827:4bca:f1a2 with SMTP id d2e1a72fcca58-8415f0f02cbmr15112125b3a.10.1779762480277;
        Mon, 25 May 2026 19:28:00 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:890b:1e07:dd0a:52d0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164af0506sm10796944b3a.16.2026.05.25.19.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 19:27:59 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 0/2] zram: writeback fixes
Date: Tue, 26 May 2026 11:27:15 +0900
Message-ID: <20260526022754.2377730-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8830516000B
X-Stat-Signature: 9oht8yudw1ds399oqydinfttj47q7ch5
X-HE-Tag: 1779762481-907116
X-HE-Meta: U2FsdGVkX18jyTo036AtlDk1xlwz1M1ZAaZ9bJepO+9m0M5YfrqurdEWv8ezir1SWcWk4OTFaaKxPOx+/Zl49IglQSbBQk3bw6XFWk9cABOeUxcUW8K1HPFZGIas2LVaIuTokMKxhApnApLGyV4cq7rVRBYZAjuZQbhpSko1AIcOgpspw5EyrPJEP5cFMtY9FS3QUVrKy8PfivQdDwHISuocdnbMl9k6TSsMxZ7A6F4pt7qfmnsyCmBmNLOMKDJ+Hrm5KrdxJeQz0sVQlyBGV6Ry8j1ubt1E9X+8j1RS90ayCq0zITRhtdhJ6V0gu/0H1XPeG1bKgey7F405NbUjikK3Irb0gv61+Oe8Ltz6cg67Trzj73yuwuFnHGMwGD1Z2ga3lUmE1Ku1GyWk8T2E/OxCtHw8oVuflc8nSnB3Tbkkw3U2ZCujUK9W8LTlNCDZy+EkCvd29oRSsKbyuzbL0m0wnPhXOIlStuw8wmK3q/ushKx7wogox3CKocnCBONI8VJIiCXe/s2B212aG5YcViajeokHByRKxYGIYJqlx0NE40x0C+jedkOLZxc/62yfNRmdxWVTU+/Fl1yyZlrRxiytJ0r+HtUlw+Dk034wRsFi/DWrgGmnPWiV8cf3d9Q97gBjGxNmxTTasX8SmN8UD914+yTlP/xq9wWr/kOVzjaZVjzUSTOyMIuQmn2auguNXA+Yo/ftdoKA4X0y9kT4BBPBjXLSHJWz1Di8YEw1ceqvaV68HC2E1UZbxktDsdcEHQZhMGxzjtmYEbS57kZfRADkFQJQDBOJA10TiCXxPECu8VILIIKygu3uUzOJTB9n5WiM2Tw5dA2GaKNgHkcrUR5sIqLWOxZeV7eBycdfJOQEnvyhZFIOPJhbHiP/2yg2sUl6cf9nwCjMm3zuoG1NrXDoaKn9am4l1LqJIsLK5dTqAWuRgjlvuaXZzO9UMZbFEUP133SUbpz9/ShyZwz
 hAfUgzjI
 6pgYpgxOwKYs9jmGFHBVsUpf8YG5YXXb6x0gqsTWEFhdTEDIHhXiPMypi2BAs6AZHih9G1ROOuiJjI0B4qOiFxieF2Fh+d8dCnbkXcrKICn6E6O1uSb2feX99k2yJ/MTiV7ZTHBZX+yeZ8MmoUE0jVCFpVdUNvWpOVGluGRPazgWkv7WD37CMKpXzdE4/qK5NAo9M6cKUgNa10jzfAu6Tbpt07HrlX1JZuTshqXPfwI+5r9vzJZoqANc4qoRQupsRnjjvgYRRt1HKP+BnstArqxleHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Brian (privately) reported a "leak" of writeback bitmap in
certain cases, so that backing device can store less pages;
and a theoretical data leak in the trailing bytes of
compressed writeback pages.  Both issues are low risk.

v1 -> v2:
- better commit messages (Andrew)

Sergey Senozhatsky (2):
  zram: do not leak blk idx at the end of writeback
  zram: clear trailing bytes of compressed writeback pages

 drivers/block/zram/zram_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.54.0.746.g67dd491aae-goog


