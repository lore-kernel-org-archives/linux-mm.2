Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EF1C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432A56B0093; Tue, 11 Aug 2026 09:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3FE6B0095; Tue, 11 Aug 2026 09:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3201B6B0096; Tue, 11 Aug 2026 09:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 186C76B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:48:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91DCC120474
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:48:33 +0000 (UTC)
X-FDA: 85089118506.01.FDF713F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DEF2F10000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:48:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=biAvzbCv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV2lGD3Wqra4hjarElg97Ux0YRUXDXkhMbbuBCPstkk=;
	b=f/pEtB04+E+gg8lTkI22pUr6395CLDkAZVIWV/RmUvcXH7sDq3Ba6PqMI+0n36duKuJ3G+
	VUVC1akjfcm/XxDCx/DsPSM/fdpkJPBr7uMzmWcOd8UDptENNKrawVddtSCLrYdLDbhtkj
	GcMk+m70Lq3+eMbfvW858Jne141OQlc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=biAvzbCv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786456111;
	b=YWPUZk3Ia7xuSb1U+36zjQY4GDC96zcAgAr4y4IHbfdmfKWkskchKRKLKVY1tCT/+2rLF6
	rqwE+3mNa5zbZvwwFo3VWhq3hrDxPATOOZs8xrks1nuC+FMBEPh+D3UbLP4ZdzMZfnOA+j
	1KVbP0Vg6schGXHLoDqgkn+WEY0wdyI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F0D143C0B;
	Tue, 11 Aug 2026 13:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71B71F000E9;
	Tue, 11 Aug 2026 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786456110;
	bh=aV2lGD3Wqra4hjarElg97Ux0YRUXDXkhMbbuBCPstkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biAvzbCvtcpPGdF+4LoJsvRg70YEs6XO/sUAaX6ZWHkVDiPi4ag/BPVaaxSDtZ6VY
	 1gDgSNFO1pLJEqWPXXsV0R4bgd3qg1EiiuJD+2c1DM2QXLS305cyRsi+FpQ6h/7glz
	 vJsGsDYwH8kz0NVES2Pd8NkHc+NgjFGw+NhycI52ECtTEHcuUMrDcihLa1j5rN6J53
	 DzR0kyoo1s2ufNTsNkEqQFCVqTJgRf273Ne8WF7eGLjJRbrEmIvPI3TiraPHeiEZ9z
	 wa3RxAfpucJgOYGzRuxBx0m3c86F+Bo9hV44UpSLUL7c+vBE1yjmVVHFKOY3YOv49I
	 CKlnYAVwz943A==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Tue, 11 Aug 2026 06:48:27 -0700
Message-ID: <20260811134827.4557-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811101841.804596-3-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEF2F10000F
X-Stat-Signature: 3skd4dbj3eqytyndgfurjfbm7okp6bbm
X-HE-Tag: 1786456111-88206
X-HE-Meta: U2FsdGVkX1/zxQDoNKnBBO2o3UELbmPhCnq/rQkF454qIvsG7BLqO68YshRxqSXiSZX4qHSopCpEeLEV0VSE2keZxrJr8Lfegt9dt6D7WvsnTMt7MkmBmvUd4zGigQyW0t1wSOxIhyn75h3KpU7/ZbduEG99/NtD6mlFsaC6BbSH05PBaZjogKoy8wfWltMSKaBGuNufsFO1gssNXtMLK842jPh2WvNWs2al2fB59QRmZ3kDvSUhdCzSLuqhEvdqjc6UAHsuzbodi9/r7It2Lo9gaEoaLEvf3d2rFUE4kPkg4mKSL+8jh109vZPTdHvRVQ2nuCu73r78T+amjYV26a6/VVZvCtnCa72GMwOQRw+0xBZCdGU3wpuIWFQ2oC3CbIk63c+dJIr7wVnF4aD1YM42hGGq0IA6CBaJ86VhBwg7zL56ta9oR4zWI67uva96fRG9siSGUJAco9uVqwJolG1QBKjfY8lU1r35Ps3BEU6utxADigfknd9Oc86arS+4VxKVGXCvuUPIY0EjXefUrNc880ESbAeVllJ2hS7kFUv5R/TeV+57Rdvffl/cTiySix3qwp0qxO4K1/Ziee4LPvbPI/3xuTLsCJisN/vc2KJe8Ov35yKXWhGGVjofWiePXNTQWuzW+11QZdNC63Yn2dQmaAZkYx3Xm2kMGjTbNCk5HnRtoLxZNgjCUKkFAlJnrGOMztFQULn3cBwgr7zgT6pElYE7PiLZWcZPq2s0k1nCOLsUUR41mSKN7fWOOpCwALDFo/IS4PTn+5ro5mt538vywFNm7JRLk1pQKLSIcrjm34fvX6BG6N2GZss3ZjAgor5tj1KIeYvOnSIK3t/ok30SziJA14JWc0Jp45tFkm70vVQUQS/IKxAbX4dq7YyMyVlXFbYgFvujiiNnSPECGJ9ZEBizNUkjsl/+YdPwYzWLC0GnhxQS3ah7zmKqvaB4hDVnxnZWpHa+4DCQVuu
 o1kxbwqf
 iZn4/APbXAiJOSSajX8jTs7Ma+o+mCTmJqfg17zFdBGGztRUYOSel+lXUN7mvWUr1nabmG/B0JYaRIWAOmGBJe1ZAURUonwKWZkeM1S3iJXLqGftUHF47oTuIX9WDw/8tMsK6fUhWIZykhwoyzFBOAICS0/qugowrXI4xL29vbc6m14ZCgozdY3Zg09zE3mUiQpths6GH01gkwpeeS62QWI1FeH7+bHKADlv4WznyGnAaQIwA6Qil/AxH2oiWzEJB3NMS8P2mb9JgFIOBH/1HrPTyG0Wv/Tb72l6d7pZZri/KpbdnyTl1cq7KFgI6/F07H9jt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:18:40 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Explain the difference between nr_snapshots reaches max_nr_snapshots and
> watermarks.
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
>  Documentation/mm/damon/design.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 939298f2a9b9..1fcf0b8c044b 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -872,7 +872,8 @@ the action to the region will fail.
>  
>  Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
>  non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
> -scheme is deactivated.
> +scheme is deactivated. Note that, unlike watermarks, even if a scheme's

Let's use two spaces between sentences, like other pargraphs in this file.

> +``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
>  
>  To know how user-space can read the stats via :ref:`DAMON sysfs interface
>  <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
> -- 
> 2.55.0


Thanks,
SJ

