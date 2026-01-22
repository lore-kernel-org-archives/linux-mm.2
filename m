Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A257DD3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F9E6B0296; Thu, 22 Jan 2026 11:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E755F6B0298; Thu, 22 Jan 2026 11:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39196B0299; Thu, 22 Jan 2026 11:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD0406B0296
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9909A8B9E1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:46 +0000 (UTC)
X-FDA: 84360088092.17.B45CA26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE736120007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNmNHAwh;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uE779tUdR6UCrZjNW+jJpzkWCsW+Ku0M24PP20dzMU=;
	b=X2MhZrnhogWMk8M5Ov1s5ix67eqQIQYyP6zzCUwQn0p/DfvCljC7idpVc1qkjTPY3miw+p
	drxCU3xp6AtuJu/iJcgke8XcVhGQEZeKKtr9QcioGui7LAgGLATrJqkbqfU2sVD2wYCvqP
	yQ8pmXaaKr+06bxbOlIT/jcrnFzKhCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098245; a=rsa-sha256;
	cv=none;
	b=BSLyWg/G3MyFOw+DYayiaB9+iKi5o6ObTefn1n3XLOKZ0NZR88nQ9G42SQkF+OLGlj3R7n
	GEsUmH1IyzR7cnCSDCKuQJlygg0+Mj9fnAdVmO5OY4LWjqwxCwpi4GMKYGYG+AbjMl+B1q
	ccmznyge6c4CaVnBpa1wr1fxtB1f2gI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNmNHAwh;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82E8F60130;
	Thu, 22 Jan 2026 16:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D3AC116C6;
	Thu, 22 Jan 2026 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098244;
	bh=QijF92eYDRa+yIK2vhm3tFsLRnjMqoXf04XxHtZ1MqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNmNHAwh6+Ee4JCUL4XYjXlSPA2GuhsMMlfHRnFJ6eE5hI52R5FhC4VvVlVsVK+JO
	 lSQ5dkSapp/JDxlyK2cEO8GQZP7Q/9+d4PHDlMoUX3+KX2V/V7GN+pFy+nXWOnPAjB
	 U5/uIxdgKucOEy9mOvYK6rmUaFPTD88lcW7WPzYuGyyQibKL/6Mn9MKWAfFdAM8lR8
	 t1wh6jYr2oHCbwVJ5PEK7wNKP1q36BAZHinnOMwwLtL8Ax95HNWPVSne5iLwxdxxD/
	 26apQxbErgrDUBUos5ALL/Cc5k44dWIBDqG3h0M/k/DTF8X3yvxvmRlpzUN4w9Z2Ai
	 vYcGFh2zIDG9Q==
From: Thierry Reding <thierry.reding@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH v2 10/10] arm64: tegra: Hook up VPR to the GPU
Date: Thu, 22 Jan 2026 17:10:09 +0100
Message-ID: <20260122161009.3865888-11-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE736120007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3tc5aq3owkxbz8xdrf8t6hh7q8obn816
X-HE-Tag: 1769098244-119322
X-HE-Meta: U2FsdGVkX18nih9iQ18wmYADHaZx52PBNdXXbkXuGXW9uZIy/hAkAsXQKigU+sFmMnextDUamnyg73hvdpYl7mbJJp6yD/JTlIiMG7ipag0OglEB9fF169M4ItsFAmIzdo7wY7mMbyl08bDPfuY3xrrFO1fhAf/1Bh8I+lYZBiYlMcrh25lqEzkc6f03mTn6hUl8cpVpsXbW18dq4OkOmksOU88L1HtD5YTYOHkm8PJ0OPHrMkdlCjDOpFGwvre4rckJxEllgyZMO7l3MWbi9Fb9QCe27gXvKTAMX6Kb/hnTKnz0AYTuuw7QJ2YIDyWVia/DAuBdCiMYvJAcpHR2QDcyXFusaTOLOGfPrnK2jP654NmWnCIQvJQiMaLEux7QbFlULWcuFaUx01FUgnAK85QS4VsACUsk/ynm25+NetNWMWjDWSf/RrbiKCqSJTIhg8/TKcgznv/ynGEQBZWs23Nq0wEGCUtGQXm9CJU1WrTSnuyIO0++YUi8Vkfpag0zO8UWNCUBQTJK9WT/aUaAbDRh0lXgTHCukfUbeS76lLMufRo+heHQDAuryA77H27jjUgLoCKxRtWd9LQH4BuMoCeGVW742jP/B7IvJsDbuyAuTuuzlT70mCfWDoKJ0jGPIfR9C4Ek4K4KofW/YAsz4/ndQ58FJP+ULOevpvxWWlZacD5XdZpSOgTgP3VfnTwwgbXdMJMvI9/rQMAwGuxY/D4yiNsdCWmwNZhz04i1gQPEh/iR0B8x6hwZNUgHLzXcw/C1SWDztQ/qwgE89TbH2q8F1S/QX1mN8DT+HfywXVi1l4y9p/pFVskTb9CCs8E/nMbkWuIb8/0mdQt5FrLABgxOdJ3Ie8zvmou5xZ+3AwD6SaLYrl+5quVFfZYqM9Z2ZI2oJ/47CvcfvgWEsEOsFmz6DVk2JBkeF9mRgmWUhMG1Xv3BrPWWXG/0Q1xNjFSC1vq9kOFfRt8uRqd0Maf
 BMCtFMdL
 dXJD3mEWAbBX+OAXRQjD62wuDCk0srgCzVJQWsOhZZRH0G+CarC1G9SkNghBd1sTpJ5aa294yNM8b7BpCD8HQgwk8WY5Nb08CI8vcir/eEPnJ7OhFyC39kKNZxvoUu9QDcbyatihER/NTQ1xL9euXEgumd4l9itPDeZpCVcV9iEUretF85ZYBtwB7tKnusr31TfevT/CNSf3/mz8M7+xe3Tx0dwz4nIB4mAB/NVSXJuAQkpo9Gn1sgM1TJzdwmCGQ0ZOa2ActMxPY2q1lkkqsoHHMVdLvVxUt3+0ox4bhZpNVMnFfaLp4pUF2jgXyVsFu4xwjwXtuTGFcuUj9ZsAxCPdDjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The GPU needs to be idled before the VPR can be resized and unidled
afterwards. Associate it with the VPR using the standard memory-region
device tree property.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index cfffa4f2f196..21db5d107bc4 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5338,6 +5338,9 @@ gpu@17000000 {
 			 <&bpmp TEGRA234_CLK_GPC1CLK>;
 		clock-names = "sys", "gpc0", "gpc1";
 		resets = <&bpmp TEGRA234_RESET_GPU>;
+
+		memory-region-names = "protected";
+		memory-region = <&vpr>;
 	};
 
 	sram@40000000 {
-- 
2.52.0


