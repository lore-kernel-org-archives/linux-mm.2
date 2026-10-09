Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF54CA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60E26B0099; Fri,  9 Oct 2026 13:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11636B009B; Fri,  9 Oct 2026 13:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EB56B009D; Fri,  9 Oct 2026 13:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A52256B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:10:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DF4214045A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:10:50 +0000 (UTC)
X-FDA: 85303727460.30.93A210E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2DBA1C000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:10:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFBPIZNt;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565848;
	b=qBTaOhY1ZcxuLLvO2NlvGpBNCu9AdLZOlVFhnaYCYPtlkAtxKZ+TutlT4LpV+6Xce8IVel
	wpyN34c+BJUWY1ws97tCJ+BYBiF6CD4PcLGYku52z97avG9jzaNENB5mL1Rap+cyPMxwal
	Vn/AmJThziJNVJhNOBsS3Tvm4gYEWs0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFBPIZNt;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aqd3uQwMtvSY/3gTS9yVRJCLWNsanEVfWT4x52uKYqA=;
	b=hWVjmisEDNGFUXhx4Fkfb3yuNGMsfCKMQu6vVD4r9oZp62sriflHgWx5YDxewu0vnri/m6
	z5rV9G4hX/w8LY1CZLp5+W5m8nHTiku5HaVBWsKPf7JgSVdk6Oc1e4EZrczYn0AK0EWvkc
	CiozMXVS+4QL592PMm2/4dMRIvk4fQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF9943CA2;
	Fri,  9 Oct 2026 17:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB96D1F000FF;
	Fri,  9 Oct 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565847;
	bh=Aqd3uQwMtvSY/3gTS9yVRJCLWNsanEVfWT4x52uKYqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFBPIZNtXOKKLziQtDBIjQML3/ed7XwmHPaL+By9/WkziS9pwYeFXF3X520kOgZJl
	 Uz9GeMxFI5V6VKNXnz8YUrKzhfUROljfvi8BQ5BkoEAifBUCsKxDy+1rDE+konmzVX
	 adFRgyRlEAfEig81DddlSRnaNpPciKivC6ZOoFjVEpbNNhw3E09fX5b3TFBC2ZTg59
	 jvKol8EK0aEceFSwpsaN+bksgihSFwZGZnoIxCBUnMas91+F4bFecNgAxUsW0SisAC
	 iHtoPTf2BvQX7iB0EWmvhJO7/gbsnP9jLphVrjmBP3rVc+PHf6S5ABuCB2BN/90G1z
	 w/5WFO/h2pg3w==
From: Sasha Levin <sashal@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	stable@vger.kernel.org,
	shinka <shinnkka1@gmail.com>
Subject: Re: [PATCH] fs: Free any excess xarray nodes in clear_inode()
Date: Fri,  9 Oct 2026 13:09:51 -0400
Message-ID: <2026-10-09-1-daily-reply-0014-xarray-clear-inode@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5048a2c0-8e55-429f-bb1e-4b888a728579@gmail.com>
References: <5048a2c0-8e55-429f-bb1e-4b888a728579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bg1ytqca9wdwaueme7t6ihug4iwhrc4q
X-Rspamd-Queue-Id: F2DBA1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791565847-600859
X-HE-Meta: U2FsdGVkX18Ec4E0HMersP8GBLRlUJrpjk83VfK1+hjQ9AygRBcN0Ykwgfg+ZJ/5Q4tpvCsLdeUM6LaKjZbvTrO738McBW9FTfZdCG+le8vtHl6h1kmPcYKFMJDB87NlbwPhErVOl3Qs8LWx154wbExSCX1LbUFQlA1F2r55RvCfDX7ADWNf0dnO7Y8ZyC1Myzi+Ah2e1V5QIeck4KPVu2BAzcJ//R289SiLOhfGXutgQROVDT06fbGjchJ7qmB9yQSrGD0FlWW7in2LNE2fVwxm0ZoVaLKPVxLVdciXFDF4xjAOolZ6wWt9EKtYR9ONxW2SMq/ceCX+bwsEomPjWQR46zp8b85BWVnfTCqJv3CJV/r7Gsi+gEzfl6ecO3zNzLv3AHqJgKRn7B3dbXSOyZjiTFM7QJ1Z3nvmCI5JfPgSTZqRU+RuoAXRTLYAHpbCPiOadKFLVHj4toAtL9+oDtPl5xaTErkCQcjh7dhQqk6Rh/jTWk+GI5vGdj66qEqo+r94cEBLB67BT+M2Ti7xvURyAF6VdTOEL9rTlG4YwLpi9v9ibV1a8BSc99WKMEl0RXIvtZPR4Tl/ZQv0+Nk4MPK23CUOPonH1t28a5zDbgtiFGXK0WSGATpQj7e3vjMi3no4CDevkpjiV79E+CDhE/JEkSEUBIKJYFTzPrki2g6DDlA8dI1B2FeX1yxTasfRsv+QsMfUhuM0p0bFLioroX5iSm2i7Tnmwf7zBFEa0WO6DtHHhl7ql/Vy2xfGguRwzC+An+LzihwAfPOoIcccNu02WAW/d1PPUPKMyeDtLScpQUN0Q44ybQVVzskMgbNQHwGJGDgHLqUWkrtN/RMEd1u7kaxGKKbVT2Ow0X/QJgCxzmOiHEGkOX13tQevww5YHcAof4DbLCDlEKzGtQp3JdFPnDRUyxJ/HNwenme8TrnCs7LwF45of59EHmwekoiju9mqzf18GGk4+e01Fpw
 4qwlaU7G
 KtqDWpTnl9NO3qipiEAQ4Mn5DIfdJXxCg7wRzZiUgq71Ewy5eBOAxLrqqiDD0u/P5xn6ZxkTFEoOdK08uzB91XXiNE6QTHc5blHywxD/pPzZ/Z5wwnS2W2IJ2dNjAfMhWpfxi329ZHoVvBlpqRp4mMYUdeH8KjcPrsBY8XyGpfz1e/l9Xc/ZRmpkuXoJQhPo65EcfHIAhM0MKTSzx0tZ6uSb+lrRTNj6pGnMa0EA3xFVY5R9sonHvfTw9c0/Lu+fvBZmu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Could this commit be considered for backporting to the supported stable
> kernels?

Queued for 7.2, 6.18, 6.12, 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha

