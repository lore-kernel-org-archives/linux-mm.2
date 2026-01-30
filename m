Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCD8D49C91
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 09:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E176B0005; Fri, 30 Jan 2026 04:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BBE6B0089; Fri, 30 Jan 2026 04:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3496B008A; Fri, 30 Jan 2026 04:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4A86B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:37:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34D3C8B5AA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:38 +0000 (UTC)
X-FDA: 84388127796.12.A7616BC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC0E818000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KC28qeJw;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LuI0pbsU;
	spf=pass (imf24.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769765856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/puQwaBLz5Lmr+tvScFRuqRcPotfc32Rg4M3hvdm8Do=;
	b=m7ezcAUAS8x9ifvfmQi2ZXfcW0I0ctWASN2smr32EQHtCJ50FrI9wiI5WTeBkZqRGoZLni
	cL7/C0/qFt+EiwZ2/BdbI7j0qC3UWX1o8VYOVqK/pWeSJY+GPkllFezitFMdP8odMSke61
	uZ7aRH1sO8Dnh6hmDawJDV1fvbKXUTQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=KC28qeJw;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LuI0pbsU;
	spf=pass (imf24.hostedemail.com: domain of zhongqiu.han@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=zhongqiu.han@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769765856; a=rsa-sha256;
	cv=none;
	b=NuJuy/65MkG27Dk4lWIHZ2obF/8aG7fOi3Oy5rhKZXyy1/tyaTFzLSnF6cz784xftEWlOi
	qPerG4fKtlxX0dOb2+YsLN4SrnNT7g1RyzuGbqjoX7K1B5N1SGRIA/AaXxPUUE8CQF0zU5
	DYHCkGiCyBzIt0xpYLjH04toPCTzezc=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60U3VQ36891218
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=/puQwaBLz5Lmr+tvScFRuqRcPotfc32Rg4M
	3hvdm8Do=; b=KC28qeJwEfID5n99BD5AiAd2uLe46+K8Smw0D5PvCjvNcqDoNfj
	/bI+JMM5Rp3mlINqlnXGWKmaN462s6X6hRsNGrMDQPyHavNbKSmFEvI+SC7e2hC2
	6dank683JvcpAhPaLr0LKFpEu/SW41JBReIzPzL31esEkCgHiEuhaIbxlYdQhFPm
	mhTrL1+PZEun3irYjzKkf16TixGVLTXIeHchtyfQXCfyQ6mg1+oVANOuJajl9eNG
	AzUXeBOKmWi+2RGrD/cqybFjNhZl9jM6tJPNhSrWpYfRSSsIM6M7Qsd/e88uVFrm
	5YBkOR+I1CoinaTGBkUphjvFPIptv2nnguw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c0gs7smec-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:37:34 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c56848e6f53so1256024a12.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769765853; x=1770370653; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/puQwaBLz5Lmr+tvScFRuqRcPotfc32Rg4M3hvdm8Do=;
        b=LuI0pbsU/iEX/H/WxSgU4ygvGMJ1sNWR9kMDX1A8bjWSzQ4dufsJpX1q21GfIYgKOr
         VysbF+YS+2FsU7MxnP2sRcsifgKTR7DMa8lfOEN2im/WLJQdOXrLBbiseo3xWV2rYOFD
         XxZnRz78N1gWY9nzbWcaGNaFOvoR2ASaGiPdhkXQTlL2hsXD4es4dWiuKyz1hFtselqb
         tExA0o1nF+L8Dhdv/kU23QtYEqajNddcv2athX2xKQ1PUfm7h2yIQYQcrIqaxfOhmz6T
         apHkzHKCqRZrv5JPFi6jm0H55VHlk5/qzO5OIqzQuM/rISqjp6+2WGYrVfQmEC/MHXah
         C2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769765853; x=1770370653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/puQwaBLz5Lmr+tvScFRuqRcPotfc32Rg4M3hvdm8Do=;
        b=PmI3kZ4M+40hFt+KF4AqhgKrtvsDk/oV7dwa8lY29y6e19qCEsFnrGTxUb6RTWdY0f
         zn2OPEIEZT0nQa8NOcbJCULVN1APk7Wtl057VMiCFh9bib2pilfrv6i9GC1z8qnMRCA0
         86w0TH9/7+bu3I/zl7paP5Z3ejn7VwxdOZUEuVQq5tJyrDlsRHoyfRatqd4HT3iCs38W
         04EAw6zXAaR8Z6BJVrz3A3LPJDO6iXcY21bvLCIW+DCNeTa8lQOnFIF3pix6lPBbUTxg
         ZXYbShiqMR10OkXQVEKdVfusNuOREa2fzDFOoKJYWwkYmmSlb9cZBsNZQTb97n4l64eb
         fsHw==
X-Gm-Message-State: AOJu0YyKVk2ZGJH4+4kzST1mskGf18bj2VJ9eGR7orso73AyjL3FaW/u
	vGD5ZL0NAlggXx9sB3PYYlrOJMg4b4SsZz/2jJ9IRjr2rtmDQkjuKuDq0U/hy8zU8fthEP0auCh
	T9sSg7Am+QcYR3lE67BeXl5IqTaRYNEcKz2BlDrjXLVyGUG7WyfzT0A==
X-Gm-Gg: AZuq6aJDQA2VChEMhRl9KzWeb4h8PWFPcsMdB6h2G1p5Z+0ACCY+7L0cw0jeFun6wX0
	V5YJLjF/q3gV3wxPUnge9YqjZHp3hyo4LE+9Qsabrw46bT9xjqvmfBQpeMfKt6oKwx74hyrgXMJ
	JgTYHvNlK7SrTKR18M0mFo++4iz2wYCUQ31AKVC7YRs+ZrnEbxseMKpPZ4vEUqWXI0wcW9riLaG
	22IIPJog4YgvbA1o0g19Ili8GGrZ1bx9AphMkqBfzEktACD/M3OFpUwF0jVQcq8DYnlodO1I+TT
	s1YYy9Ip99o7oA1z4zzWLGXljcmfkDULuLqu9DANs5mf0YKYc7AKKe+ZMO9mhxs9m7yOjOmHmd4
	eFV1FiroT6t+1NYd2wiVZjd591d1DE/JpSlYZHy9/mPLu3m4CfyBCb0EQkc9ss6frcUgunC3zPq
	rn
X-Received: by 2002:a05:6a00:80f:b0:81f:852b:a936 with SMTP id d2e1a72fcca58-823ab67e4f7mr2219652b3a.15.1769765853573;
        Fri, 30 Jan 2026 01:37:33 -0800 (PST)
X-Received: by 2002:a05:6a00:80f:b0:81f:852b:a936 with SMTP id d2e1a72fcca58-823ab67e4f7mr2219636b3a.15.1769765853064;
        Fri, 30 Jan 2026 01:37:33 -0800 (PST)
Received: from zhonhan-gv.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b49fecsm7650432b3a.15.2026.01.30.01.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 01:37:32 -0800 (PST)
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
To: catalin.marinas@arm.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        zhongqiu.han@oss.qualcomm.com
Subject: [PATCH 0/2] mm/kmemleak: Improve scan_should_stop() implementation
Date: Fri, 30 Jan 2026 17:37:27 +0800
Message-ID: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDA3NSBTYWx0ZWRfX13qHod2/7d8D
 5n0OuE/sQqyfQ7xx7np2mUIS3bUhnb/KA6tr8DKx6dTwJmrNk7quyTiOQnwzLdlFGZ3iFdr/lA4
 7DIkrfuOrnCaLEjMtRCiXmpZKAf68sY4SH1dK7m/cZ6ef32AgyG4gyQbNTRVFMfKPxnqP7A6Oje
 t8Lz659oevk3v97vbGhvhosvdvOkqqevF8tCA51sCdAjycWvV6sS6RdsYfCwBpGQYhcCnyMpz6j
 geknOlV0yocIsoT5fIaWYkAaiox+rWq3k+1wtz4hyujuBmMFK28HoCDjvrZreEpIC9InD3G/n2/
 nWdZLeuN2m4GRQ7NuiCK+e34c7zEWJKgQtPm3awX2AW8i2FKXfQJWxWcuVj8mpa8AfX1xRmPV28
 Dnx7DoZ9Hhrj7crCgzsqFqJbW4/52i8pbzZ0hY/yFstKKJS5KKAFAhWY56pQz4h/uTecl7ruV8Y
 Uyb8bE3iV1uhqEWVuxw==
X-Proofpoint-ORIG-GUID: hx6oEaOpR-vDVCrg8ON1El1AWdwK0rlo
X-Proofpoint-GUID: hx6oEaOpR-vDVCrg8ON1El1AWdwK0rlo
X-Authority-Analysis: v=2.4 cv=UPLQ3Sfy c=1 sm=1 tr=0 ts=697c7bde cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=3Zif5_ZR_uF9N0ESeooA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_03,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601300075
X-Stat-Signature: 8pejaa57h15ndj57t4jjgicjb1u7rgqd
X-Rspamd-Queue-Id: CC0E818000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769765855-794395
X-HE-Meta: U2FsdGVkX19QUKYLfyguQy0Lw5XArKh6EA7jLo+OcHmZd/YhT7MKx6zqJ/eFM/6r/G/pdrm75LxaFOp49mQFIeGgNCDQgiVCgC9LYWfWnbZMsSYtizmxtdwo3GAzJCLELSThEFEdraqL8zMlRR+UXIiJ4PLt/2Y0cI/a3NK30xFC1J5EpLJM/JUbHGHFjLtDiYhCqzRC5XiuqkDiLzSylC5NiqhT9ln+WdBTlrPKn+ydyn+NcH+PYXMaVjn03rllBTBJ41L8FJ+hYHdXjRPgZ0zdHdAsGXctfesX2BhRwoRLluXbsz/msBvFd3woUMlbjoXJhjLXk2eYmvfUPplMAFlqQk8iK++be46+kceJaveyykbBl6n8jo9Qusnt5SgdM44SUtNT98Ve6SvYwb9XylAbHn9ZqZrYqWj4MJ8mBd81r14NA3o3O0jDCkdpBjK131TGezABjW7/Bxf47gf8dpWmgoueMJxD3Dvgcpnmfi0NmNffz1Ss4+Rha90oLItm/fmqVDDWCUH9cH0LOvoqzXI7hEWl4JIC5YsZrXKJAknBKoMJ2Kq6WcwC57PiGBaBDdybLgVAicUQRy+HMPYKiVreVUYGk4EuF0ZinZp0QJOplVU2dT2qdghJd/Bvjb8/Rr7YbBiQumprqO9Z86jPoqXNz/WBuyiYeE1C8XejFhWxfavCw93Kffq9E7SvwPq9JFYCDdEYkkxWzsMuMNgqcn9GRtgzaDBEn0UWo+woGg+P4mL8q2QGTXCl2JKd1gPdyCJA2LNxWWNKMDOSUzxDjJQgaAdIjxvhV9WUCp+0SOLPgPg6J+RN/gCJz+IBvFx+GumUYjCnMlznu5/MfK50PbWQydbKbedf1vds9OejpXe18jBnwvnIpl4Alf0tZHNyNc1Yb8wKQUIjZ+nJeTUQhcqwptBVUZhA7qVdkYPgg8sEYonCAzGLZxQIv46Q5r+J5f/LQ08Ysbx1yZ1ZSeC
 JhM2j1wz
 9xV4dgfQBOfIXJFP/bowhP1iTqey6+w5wMzoBgiKCzWT/xonIfuF5j2kHiba03sZtFBa5ePipPiUCB2d6FwUDQAoxlQTKqYJ19sPSOJLRu8eX36rwGxRIjGtx/mCyyfOxnVrjZNfrKOAMmhieVWiPb2sinu8yinAUJjkjgvwIRftz3ysUGg7n1KX7thdx4oh/HOvIa+ALruVrRB/3S+TLfw+jyACVfwei64uwrWwwA0WaBdXP4nz60r8ALST9oZIg0H2INu+mKDqTglLbuPIqCUl3ajs9cB6Csr5J7gM0a9z8qsrfCugQd3so5UhzzPtmMigqK4gN+XiRmmaYBWJ2kbWZSPVbJB2Qyk++0KSQ1yWVZMxTWUjuHG2IcYZIY6i+Q23knfeozeA9YUL24fVGU147UGx4UgrFtAJEHnQCoEx//3Cqbf3SAJN0cBwsycO3eP9aaJGXzAXLuIicbsr9QHXLBKoNVhzN2JRYrQ0TDI3ZRg3mDvAnLOpfWc5aNa95Gyiv3Dv8pZ4BLfBGPpySG1KiGok+04BQE4wL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series improves the scan_should_stop() function by addressing code
quality issues and enhancing kernel thread detection robustness.

Patch 1 removes unreachable code that serves no purpose.

Patch 2 replaces current->mm with PF_KTHREAD for more reliable and
explicit kernel thread detection.

Zhongqiu Han (2):
  mm/kmemleak: Remove unreachable return statement in scan_should_stop()
  mm/kmemleak: Use PF_KTHREAD flag to detect kernel threads

 mm/kmemleak.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


base-commit: 33a647c659ffa5bdb94abc345c8c86768ff96215
-- 
2.43.0


