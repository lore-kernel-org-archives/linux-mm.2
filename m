Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4E4F34C64
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510A06B0088; Mon, 13 Apr 2026 11:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E74D6B0089; Mon, 13 Apr 2026 11:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5F56B008A; Mon, 13 Apr 2026 11:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28B586B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:45:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7B3556EB4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:12 +0000 (UTC)
X-FDA: 84653956464.17.DF81D5F
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6686C0011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:45:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iamIiVAH;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776095110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j4HA8S9Jgb0f+hoqoPOXN8eIo8iSqnJJj363IEDCdRk=;
	b=a667OJJMxWuS7irfEKUipSKbxMAqMoNeDUJOISBXW8l4kzYxpT8De1oLBr0IhbGhh/hGzo
	dwn6Qn8RfuoUgccVuAWUf5fgjZnX/cTl8RWPWp9sQPAswQQopaMqishRRgZeTMdYO0KpQ1
	lDrCVwC7X568gcaFJ9wn4hQ9Cuu60No=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776095110; a=rsa-sha256;
	cv=none;
	b=Ay2HWmuMwlfX4i+qV90xQjWjc2dtwMBPhJIhzhbscQh0o2Txp5MB+3RztpuKYayGH5ZHXZ
	j19M2AluX+j04KxBpbunQNOqDfUbX27xrixGg9MHjLak8zEdjAsMbHvhiRyPVWzmr5Ontn
	1G+V4usxWFWUORqtWXejAHCpvLopLYo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iamIiVAH;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35e576110adso976432a91.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776095109; x=1776699909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j4HA8S9Jgb0f+hoqoPOXN8eIo8iSqnJJj363IEDCdRk=;
        b=iamIiVAHnGXUgkqQxXDwvi7WdkKI0QEhJfcH2suf88C3t6A1JQRLI45lH2MS1FEJpm
         VpISCvxGN4gLxVjcCrX8uLkjKIxX2l/Bmh7g1UiLdCES7+xQbvGzz3LFUjXhwImBlFn7
         kXecUhkupUAdmq/cbZqAm8XH25DF5Ippogjq0j+4GTuIS4NZZz3MwyZ8EwBe41ZPJhlX
         xOWAcvCnpO4lqaDMZOT6LrE76ENN8zPpSNPb4HRZV9MIhxuIG2MdWohZ3sSnk4KEIpa5
         KHxj5P28A+8zn98eM/Bd1LCXhhvrlXUBoT3htBp0BvS5SfT4C39MnybrGusV17zeM09o
         UjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776095109; x=1776699909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4HA8S9Jgb0f+hoqoPOXN8eIo8iSqnJJj363IEDCdRk=;
        b=W/DW3Kd/5fbl9sUSe2tfs3l6U5dsg23phhFQVrHrXPp9dsM2ylEyNx4PoE75+fo1Yl
         He10S31XeHgcwFFZPDvFNy40tcdcI0o3PCyyFK/Yc293J2Ld35iw1e7q8ibO1QGafTiY
         2VkA3cJk5pOmYOnvKGhF/I+bDBnoUyfqjD3ieoJsve4R43goaXliYjLjN1XJ9JmjTU3v
         jEZvyws1iizp4AnYFMYiStvJhz1jr4yBf3dLbFan9nhjzGLGA0v8hOcGwIHUqCivkfEg
         fwOBg/L2r+P9c/bA86+RT0TyiIoCcojGz+MpP77SqCidNdiGDVaP28ye7hFKrxMwuIjr
         qmkg==
X-Gm-Message-State: AOJu0YwLoBqILF47bIwsjB1KkXHJfAgVihRauvViomL5M6m3XW3eTKPF
	PQ3J3cFdbeG4fcqsqjaoLiRnCA9Yxhc8KOv/9r/PZNKtjMnlQwwjQGfk
X-Gm-Gg: AeBDieu2sRisJwEJ0CGfq3AGWkhYMSKEbdd4OB+HEA45qOApsCOX9vSpZvM3ix+FRmu
	OhK5sHUPJ5ZaNvTK7wXIwAwQuODlHBoOMgnbXdvJ8m4wvlFl+xzfSlLGOR1xU0JxgGgo593f6wi
	iQ3MCbA22Tly2PFa3qXOhK2t8BcDa5Y5Lppjo1JactBgBWH80+jUWQ1pd7vv9rfmIPQlU4jC39F
	ZGohRPxTzWc+8lsjjSL7n9yjWvxY5H49Q3zLxckPqp7T2K53Ae9y5RhEum2nzOKC0qPIIwtenqh
	ujLRE5DYwzFuLy9IJEDqV73w25DuArrbkn14TKzpdGmwUYkESDfVlYI0z/1fE2zMm7ZNM5vIxj5
	KTJWPHa+HK38H73lOIEzacYG47DvEnX6LHB5ZzPs8lMNC7ZafsglEmLj5DpsC4ScUKH8t1HNshG
	tze7gRiREwe0dvInTzR+swEFpL8hSNAQmz9n559oI=
X-Received: by 2002:a17:90b:3c4c:b0:35b:e4f0:f9b4 with SMTP id 98e67ed59e1d1-35e430a7fc4mr10623392a91.10.1776095109336;
        Mon, 13 Apr 2026 08:45:09 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e41355470sm12786052a91.17.2026.04.13.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:45:07 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [RFC PATCH 0/2] mm/fake-numa: fix under-allocation detection logic in uniform split
Date: Tue, 14 Apr 2026 00:44:36 +0900
Message-ID: <20260413154438.396031-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: n6secmfkoub9rs8da9sf3bnghwxr3yof
X-Rspamd-Queue-Id: A6686C0011
X-Rspam-User: 
X-HE-Tag: 1776095110-416781
X-HE-Meta: U2FsdGVkX1/ETfyaq9pobwwXB74wmMZur5iuuXNgH1SsYxAO0JFGeQkMmePJ1Ys2FkzyaI17KalNT1kYgK++f4gU61XGTxyqQuVaaw1cYrMgcLbxSUJPKghXwi3Udb5eh5KYdc8KGYrplQD02KCZMbCB6FZ+2f/oC4H25LuMbjoZ8DXIjsm1J+N6v9cEKTUKChuxRK5Fi8VXfQ0i4Ja11Ee0DKkULpMIFaZKeoZHyf+axAV88bRZthkl25uUv6PPUCB9+mQ1Dtn1wV9qIrX+gJReTperAWXQmCWH4Vh1Ae4kcfWZqnxLTz9URR106sjkI/eZPQnCH14NhCvqlPM3kUyEloZIflottwUo2QlPGhn//ADobrOJtbA2fR4UUxi7MiqEdHg0dqIxX1UCl4a88VjhwOaIN7lCDmyWxfGY02PwO8vuIYyUwa9mCwT8aGo6suUWi6MpJYIG8HrbDo5vggW5LAUDhRm7WOp8RRR4lr0nsj1vvTtewcK4mu2NBgXwdPsMU0654/zxpPE/zXukrWzE/LizOW1JmGdcmFThfmyyK4yumfs3kzxHgd7kvpBawixsHnbBcxFLEO40pOQ5nz+OgWfufZ33YD0Xs36nj2fjHBLwuHr2qyc1a3a9bE1UeChwdw8cWvy6sBPxuzrvZoRcOsCbPehHf45De8QKMorZN8fGgJA1w7ckEkmd00TvMjKiIPdWMcyMlBw4ZCkgDHIOeZaS86LsYN7fTLLm1XTdSCoVkgm5hiu1fp0v8x24KJqFYXBtY/WK+g1NApj2xj/xeu5cIs8ZKCCoo6MKlas5LXuiTJnF53ce+z5Z4IpjFvErZ1oLQq8YYvYOaRNk3GwurhPYXsBisfsujaW0GvOGqI/4v8Sxkh+/AXEm0lfIshzxZiwS5/nm1BXM9XJCnBXXULl+RZ9ER9H/JK7Q4t8W5ef/te3/694gFSD+o1t/EtYJlbWrRn77X/5nhZw
 5bLyaw/O
 Rw/KOhK6twPmLYlgAlWZ3H8UjQxEfiA03YZTYTMpFq50RKy2Z9NHQ65S2bMFGeaO1Htif1+y4OhDX6EwP9VbKDuqjSKjNeK3UXGO+Ck4NQMJekJP7zfj6DfXPL6quvsxAnQF9JVC53xifDbD/gGi5f+IeBlA/yLuP16iOPiUSD6xaUWyXEDUKkK+/UhXQrPFiWU/fQTCgIWsZ/XTj/c3SzZmw8voh7yW7T2yfgJbaczqdzfzPyq+YztquojYxv8M9CNpmG/Zs2kgF+BOa2NlkPeaL9050Y/RChTVJWEapCXxhHvTrO/9B+imMNpEFOAm2i5OZ/3X39zbaJ8X8501h/XfeI4kWzwWN2ujR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This series fixes under-allocation detection logic and an outdated
comment in uniform NUMA node splitting.

I found this while going through NUMA enulation codes. If I
misunderstood, feel free to tell me about it.

Thank you for taking your valuable time to review this work.

Best Regards,
Sang-Heon Jeon

Sang-Heon Jeon (2):
  mm/fake-numa: fix under-allocation detection in uniform split
  mm/fake-numa: fix outdated return value comment

 mm/numa_emulation.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0


