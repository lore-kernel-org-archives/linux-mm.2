Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5945DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64CD8E0002; Thu,  7 Aug 2025 03:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13F38E0001; Thu,  7 Aug 2025 03:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBA08E0002; Thu,  7 Aug 2025 03:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBAB8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF49081E84
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:16 +0000 (UTC)
X-FDA: 83749208592.27.DDBED0C
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3169DC0008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gnc0pTtE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7lfFD0H26eQ3nJKq96zgfvg/HFsoB+3WUik64IcXqFw=;
	b=RjL2f1wles66SuVcaAyts/VCwDuzqBSQnZvkIOnlCdbfEaySDd6OGupzH2rM0Hwmvh7np9
	9hLLKN5lO2fXK/3O/255EsaDnxPkT28vme/5zuzvlVbh+OSAyjvrFiT8f3ALlo8PZhHaFl
	Mk8ScD2JpeFIvWxwNEYLffZydZrIaLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553495; a=rsa-sha256;
	cv=none;
	b=TFPAsJv/Kuk9wjrS71zkbcj7+PBqZrmHuGF7+gSH10rbNQA0aUSYFe1cJKo6ErCUZn/7Yk
	WxE7WCnOxGeRFkTVln1pqwAfgpvT+QDcEEFVKagzfONclP9hdWUHNLeqmL0rsY9nZcs1rX
	UkwXYKJdMrjJPygLoKY/JwM0b0TTkWE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gnc0pTtE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55b7454c6b0so740794e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553493; x=1755158293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7lfFD0H26eQ3nJKq96zgfvg/HFsoB+3WUik64IcXqFw=;
        b=Gnc0pTtECcjYuD4bHnK9RBc3sbe8X4q0oGYyPJDBCDt/7duWohKJvPOodeedAOkvwH
         X6A3d622eiVP5dTk6cR906Lbf/QyxiozqYFjLl1OJWaq3WTghRR9BRa8A1/QAT5i8TsY
         X8ZT5GryoK3V7HNB/gmyZd9AislaFA+aqW9bYWY3RokBXOf1NA48AwsjVzm5DpBIRr7V
         d0aNq1uxN8JpxsandLaI7u1ohBynu40/tXym9xybJI38EbEnwgYaViBm7ZLyWESRdLXw
         70pE26YmypWnD1iix9cahcrIwL7ZWkYq0djE1OLEuM6zOVMgQpsK5nnFhQuPkJsjPp/Y
         SUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553493; x=1755158293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7lfFD0H26eQ3nJKq96zgfvg/HFsoB+3WUik64IcXqFw=;
        b=bVuUvdzhxfqI9lu3XjgVqb2GR4wDUiWoab399xKGDtf2u+U6C+isqfGSSWHG7Hi+cV
         URbprMPCxMCtsPZzV7DDK1XsgQ57VfZSmKdCZkWhLavlsWP0iKOBMLAjiR4JZFFh5yak
         0mPrh6xh66/0CR6DMpd4vecO6lr6X/YBHFik/0/NGnSrubnjOmwzbNtKq/HdESRjRFLO
         2UoYanLpene8JJw+FfMCCaVAwlGDzpHQGdiz81RbSheriHxujAKtHFHQThS5TwroSdGC
         OU0Tusu485Ir74rJmI3b4OMK44hxlD7l3mVeX54toJksRcYmtmfc9aO6Ujy55ucuxbUo
         IRsg==
X-Gm-Message-State: AOJu0YyABV2nd86k0WwLnkZ4lBTarMCLA59ESB2nmxF98LOzUuvoeBsJ
	LCLQDtFCD6x91DdkA6q4nosqnmMRi+VA8hkpNJpmFuxP1BQ/LFqdYCOblc940g==
X-Gm-Gg: ASbGncu3DdDszAIyW57UXxc5D337ci2pXjKozTmMHFMSsX2GvOCkWIS0bJMJgryenv/
	ZwEfUyZvtGvujGdOYczjzNkU2bx+wP2WIS9KtyVX3C1ntKHzxtD26sbiVBl5LKxNIAcUtpRvrUk
	X+viIpFtEan/CZhCbP8cpTumWshF1tOzXaFFBMOczImQeZtBP1OqHMJTPbJp1TbSy0HT9aPJPIV
	VVS/uwM3+ldJ6a7GRiNUfjTonpD0Wuy9qOw7LUhiTGYh12hH2q20x4ewZvJK/QZKJshgmPRxFgq
	eYXmOq924gObCdy4ku47RgO/myF5p+i65bSnXVG9OTem3DDyjduFB4yaGXLP1ZLXmZXxnytFWtT
	Tp8ny/vjHlQ/Yd7WkhA==
X-Google-Smtp-Source: AGHT+IFUFvl/B+gKgVfcI+251dgjRYmvDV+X9oeio2bie1Pk9xKH31TU+OhTXKzuYvbgizg2DGttpA==
X-Received: by 2002:a05:6512:230d:b0:55b:81c0:c22a with SMTP id 2adb3069b0e04-55caf2cf94amr1594035e87.2.1754553492794;
        Thu, 07 Aug 2025 00:58:12 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:12 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 0/8] __vmalloc() and no-block support
Date: Thu,  7 Aug 2025 09:58:02 +0200
Message-Id: <20250807075810.358714-1-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kyhmd1p1ch33gpgwbcuhjqar9pnn44aw
X-Rspamd-Queue-Id: 3169DC0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754553494-766170
X-HE-Meta: U2FsdGVkX18v4RiTJgKR9FGGtVGH/GWNMu//CKTAN2dpFmRrSa2Om25ivuTRCDNfdahZh7A0OyXrvXFS5u2fmUaTTE5vUtKsSrmH0zopdsd1Nn+6twSRbNivSKYTwClrSO2roRX349i/2NOZ/fZgCUry2QymaD16uAw1nMrmKx9dmxjmWEGUcAl78qkjIjCx1Kvs1yxla82kLfYNkAq/lLrfdkjJneNd+C41Zy4YJrbcVUWKFljTZqLaTsNNkosYe+0XdqeZ+LiHWidTnM7XVs0tbeAypZQCfg26RG8aevQpUzMK0f4jFKIHlbkNkHDF9FbQjy1qlQNnakQ2oSbuWP6hHY4Fx6Pe5HpqfJkRWa29X3kpCPVz9meAuKBfyu8Tu34F+RbzZuRB0HXdSWxfNUjEORQCC+HuPk0Ur/eNgiUvCQ98TbGAexD4g6ZRKaIKtrslLsyh/f1ICqE6KE/79T3NVOX7FprxfCGD/PaBJ9mYJvj7keRL/PpfSY+DDT0uVvjawdYPnCHxCkDH71jzoldcGykPR7Ne4jAqwY4+15vq8Eh/gpLMaOiNUsIGUT6orfwEoWPQ7vbOV4Ri6sVAx240Snov+95MgujiN6rMvaYu44+H4GG59juXCNgjWN4sDFXdSzGlEvJeN2+BHYJDIIN2z+dtznTnFSrpVWkChy4p7CvYuUfifZNJB3S2mLFDsO8TLVZuGb25lSK8+qeDJfdN7OB3uIsUj42x9L+wZbrXS7rIMWU8iWU+oKGw/3yVcxbcAUjRw77LPqRRujlPIsh3NiYBRq/+BhqYqEvVfTU9UN7wRJJ1qLQ239VvB9gWhKwTu9OVMeIs1TLNNtU9iuVOapak5XHjQGCsplfK9Y/ZIVLdZOHa5kD4ELWrdfhoCH4UatZEBm1Y/a+1I6kC4bLquCkZR6AVqm5RrFRDmPSP6OsZKvJVSU1E3c11xZOpxBfGivEOKWUCoWhjCS9
 KlsYxgTo
 1uUhBQU8EgKu6xI+nHWrOOCFQbTNrtLt7/koazVc8kzDP7ZUdD9uz6KaYxNYPT0oaNBK2QUI7qZEXH/kOR+/V1FjNVqG+qGsotJh9/nmgyQczMnXRnH4QrTSnz1a92L9et8U6+SBg6g2Pl7Qn4EIR16icwQYF7pAW4Pl74WtmwJp+s3k1hss9tDcPchgpufJIiTNHN+4scBXfBXsRawDOy+b4vbar6ekpFWLaHLSpmNUXH0QNvYzTxPZUwC4MQGidJf8ABIAfo4jy+pA323bapsHvEe9ogDx0b9YuZPpEbp4npfNNQFYhOBlVLG+/ufMxv9a5fdhXwCMVA9gI3HaJlfg9IkWCbXyNsYLW0zBUtCQnavnLgbUeldCKPQxyNlx5UVkKRTxYeWxruRA54U92wX9O1y6evRpTMTvQsUgk3HV4+aN9zUUBRX8Rg/x8RkEc3B0/6CbEMSIsFMdgOe1p/xIP5kBnUmJW0p8eEGikdTWgWKPRpMCyZnkh9KLbdnUQeTU/xRhaRKso8844xyxfQxZS9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello.

This is a second series of making __vmalloc() to support GFP_ATOMIC and
GFP_NOWAIT flags. It tends to improve the non-blocking behaviour.

The first one can be found here:

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/

that was an RFC. Using this series for testing i have not found more
places which can trigger: scheduling during atomic. Though there is
one which requires attention. I will explain in [1].

Please note, non-blocking gets improved in the __vmalloc() call only,
i.e. vmalloc_huge() still contains in its paths many cond_resched()
points and can not be used as non-blocking as of now.

[1] The vmap_pages_range_noflush() contains the kmsan_vmap_pages_range_noflush()
external implementation for KCSAN specifically which is hard coded to GFP_KERNEL.
The kernel should be built with CONFIG_KCSAN option. To me it looks like not
straight forward to run such kernel on my box, therefore i need more time to
investigate what is wrong with CONFIG_KCSAN and my env.

Uladzislau Rezki (Sony) (8):
  lib/test_vmalloc: add no_block_alloc_test case
  lib/test_vmalloc: Remove xfail condition check
  mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
  mm/vmalloc: Remove cond_resched() in vm_area_alloc_pages()
  mm/kasan, mm/vmalloc: Respect GFP flags in kasan_populate_vmalloc()
  mm/vmalloc: Defer freeing partly initialized vm_struct
  mm/vmalloc: Support non-blocking GFP flags in __vmalloc_area_node()
  mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is set

 include/linux/kasan.h    |  6 ++--
 include/linux/sched/mm.h |  7 +++-
 include/linux/vmalloc.h  |  6 +++-
 lib/test_vmalloc.c       | 28 ++++++++++++++-
 mm/kasan/shadow.c        | 22 ++++++++----
 mm/vmalloc.c             | 77 ++++++++++++++++++++++++++++++++--------
 6 files changed, 119 insertions(+), 27 deletions(-)

-- 
2.39.5


