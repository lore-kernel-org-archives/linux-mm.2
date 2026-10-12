Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B3ECA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969656B008A; Mon, 12 Oct 2026 10:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ACF6B008C; Mon, 12 Oct 2026 10:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5816B0092; Mon, 12 Oct 2026 10:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 584376B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:57:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DF75A0EB3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:57:27 +0000 (UTC)
X-FDA: 85314277734.25.1206928
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf24.hostedemail.com (Postfix) with ESMTP id 463E6180006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:57:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=fWCjle4+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WuLhkgrY;
	spf=pass (imf24.hostedemail.com: domain of suhaas@s-joshi.in designates 202.12.124.138 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pu13YpKtGky8tPdtL89/ZJE76RVpEXfu65dztzSTlxg=;
	b=Lc78RH117drnefroAphoZkXwfmE81JFq4kw7trQa++dOyVMEKNYXUJd60ZZesO6qiCCBU9
	LpcDISk/F2t8d5fcSNu12FrCo4XAnz95pRSJBKclaRKD6msQkaA9b375wdUjI/4IK+140r
	gQJ54aF4YdqvlDf8Bo/rORRLatxUVtA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=fWCjle4+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WuLhkgrY;
	spf=pass (imf24.hostedemail.com: domain of suhaas@s-joshi.in designates 202.12.124.138 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817045;
	b=p4e7WKV7uoxu9Me0b4IG8aZ9mAv7v2ill2MVnsbxjRb88CqtrGgSkR5FH1G3cUbbzBvmur
	rDWZeYAE5YLjS/+UO5pMBYSQvdcQcFQqB1pEoFO0BOTMvBOjp1Bjx0TpXI1jlA/FWv6739
	TwjctZtG3uPzTd0Oph2APAqtLHxDOkg=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.stl.internal (Postfix) with ESMTP id 8D2CD130122C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:57:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 12 Oct 2026 10:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1791817043; x=1791820643; bh=Pu13YpKtGky8tPdtL89/Z
	JE76RVpEXfu65dztzSTlxg=; b=fWCjle4+kDvG3CJenoGoGVOHvD28bHOluWkMM
	FXka3vmIvW3hp0I0q3moDDsyFY2DXZd7b5/udaUasfDZECbaPbe68RrmskqTaW6y
	+5DSOOcrb1uYRgLt5Kl5mlI6N7/NMMFbOqyebPe1CfpPsnZVhIVVDEf14Iu9Ftly
	eUjztaI/4m0kKbEOR52DNOiIv1js7M6XHdxpuz0A3bR3p6PJpy7P8wWAU+dXSKJC
	SsvZd3BwSVLTAT0HIIiTK8t1L+18MCXwykj2CwckleyMjTm1wwgK1mAOl9lR5Jae
	BToFurkXHhc7Ew73ilTJ4oNBJrS0uPVj4T3fcN/pRKdycOGPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791817043; x=1791820643; bh=Pu13YpKtGky8tPdtL89/ZJE76RVpEXfu65d
	ztzSTlxg=; b=WuLhkgrY+Xo+knPrPI/Ng08TLcByZnJlTaVAaUxGnV6K1FdcIu0
	clsAyHx0Xm7S3yDPZ0i2vKskN5PfqFr1YclTVMkxakt1kdSS+uIlqR0JLO2ZuHsx
	szH6gRMVh8uO3d7z2Jo6fN0yM9auRIYOuOIYy2wxfKe9s+GtJYFlW3KUdFLpq542
	AQJKKzyM5dcGeUvcT7btE7voW7tZ1uzBHDPVr1DZa/f7XbZcv37dNXwFITtvK2+p
	u6CFgLtLAsLOmAyvCAjOhkRTB/Yq5e1ph5cuZ+bhd5+1Gv9V8qdUruOgwKl5XGTu
	kAaCwpsqWm4DTbFiFqB7rC4TXg7Ux53xYLQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791817043; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:UeTz9iidnAg7cwCBRpksPOpC7BHXqpZvi/F9HO+KPlc5d9s
	L9iaGXT/FhYSS/nveXzhrJB/KgqAXtJy/z7zGXtnw/H0+p1a0IpNaaMsOcis2Ouu
	R+Drwx3sLnewESbjRaKIb8HeaJ5kr+jlGngeablR3H7Ex/K5apkj5HE1tJ+ooxPB
	Vi6hyw65aAkOzv7EXj3Mbhz3Us+A8JEQ7pdnodSlHm32yUAWgW2nKasUMzy9gESu
	V1kdUK0E95KlT/5m6Eq6F3AHv1N1KEWAcfHjF3nmBNNYscVC+hFUu22V3Yu/ArpC
	XertbwUK/E87JCkrMDXloauhgURKNYeZ4kxKsyA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:K3S4ELdJFLAySkcvaXr590/l3Nv+7PaJDetms1kIPHc=:7C4dEkQnMLz9TMFBil12z3bVuTnUQHMzsSjRJ0bhEdU=;
X-ME-Sender: <xms:U_XMasNye88xTrm3IfSKiHn3trpJTmqDo1bXMW_YU0xisNKvV8kgEw>
    <xme:U_XMasR-XAolPmOUrQOVr8E_Bvq-svdNnJIuhIfInl8XC0Z6PSiNtrnMWcM6Z1bo0
    ROylIF9QMoMEUnO508y9hKJTFqZrQ2C-bNJh6tOWtHJ4Qw0rS4fuXk2>
X-ME-Received: <xmr:U_XMaqjga76Uujkb2w00aH6Kbk1ZTWQkBVuq_3nm6we5V8vAtytmgaVACw>
X-ME-Proxy-Cause: dmFkZTEXjfH5TD6BbZhKBuZ2eKA3t7u3UNXaaE6kXK+qJSJ1FQBQL/xgKeqXzvuID6nIDq
    v1B5cfciV+B4y8D5FB3SF0E6nNt8FEUQFycJoyso8ID7CWldSXl2TsWi0XR5RtPocR2J8/
    kZ2oJ6acL5tqX+7QKX5XsayWqQ6YLVOeX4Q4t8OhqTF92tW/AJkvJkGhYW0TJWf7rb+8pi
    KhAfjtk3qCBeo+oc69WFKMjaMKWTzuCzhqD+j/hj0C5sONKbHoh9qoHG+WMr6mr7xdQhSH
    6Q7sK5b2XPTuXCQtPUBM3SUgv8KMiu2hBMn8l96di7vN85UxslUIWrFNVZ4RRCk4DH14Di
    n0zy2NRuNo77QRtfWcaqrG9+whFGuRGRpa6L1qdrULefD113KKZ2DSdZp8io4AS8J/fR4U
    RIhbv4UGU7eueeQAyenc60wk9N8qKa1XQ3jBv3bFBb5Nvak7UpkAhbSvk9jbpKE1D7fNZu
    WePNqbw/ceFBkUEZ6rReu0gfT6McDY87a7wqTTi311mOZoIgex205pLcyhl7HoK5g4ov7q
    8KhuoGsBN6wUskXp/Bd4sd4U1CKR3oBgntemSZ3FgrQ4lW66Oqcrj6qeIwwCOearLcfoer
    fRpSNRulvJ2FHd9YDXca0Ndg4KJTTJCO+4gNu6gaXN8NY9JNmVzmfLL8DapQ
X-ME-Proxy: <xmx:U_XMal-21VmYH1B1uGIREc4gA-BNlaLFGaz6C7YwQNNVGdEI_DKMtg>
    <xmx:U_XMahF3dNEUrpsrNIlJ0BnKjSG0fJQHMO04-FfRPHxgo7mn9LS1Fw>
    <xmx:U_XMaon8CVIbeVSdW_WLBiHsmf8O6Uyib8zA_VK8p0XqFO3b3Zvq0A>
    <xmx:U_XMalZ4s27t9ZjURvY1Y9xyqTld3AdQHB6VcuwPvJJNhpCmhe6PAQ>
    <xmx:U_XMav3C44gIYdD1255VPF6u631jorDfhrT5N3MEr6kn-dEjLlkNCCyd>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Oct 2026 10:57:21 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] mm/damon/core: Iterate over installed probes instead of DAMON_MAX_PROBES
Date: Mon, 12 Oct 2026 20:26:18 +0530
Message-ID: <20261012145636.168436-1-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 463E6180006
X-Stat-Signature: fpszoojtpeh19dtxqb8nppx4erfnt6o9
X-HE-Tag: 1791817045-576885
X-HE-Meta: U2FsdGVkX1+b8u1NptlcdRMpv+0PnHhkkxlLFXDvKpSn9RmnNppPVGtkEAoKoUWoi+dcAbdLhObE6axmpclEFYBAq5yE+dc9o70FS58k96ATMaDEPgPPkoh2b+82gB7TIXqz3m9wy3VWoasTHyyMSOqhhQ+cDyMNG3K7jmPABVqEpEUyOpArPAZWsszvq18fdn9fg66QHVCfBgncKYlNbDxR8x27VAwvoAbZ4nDSJm5rWmpBJwdQEPt4Qt6qmU57Fp8LhD2oepnHAu3H897VHV4rohOwBTCvBVllJilhWzgB/7R0L6jUD9NA1FIbXmQCc1CZBQc4hw04MO0xmkx1IUh15y+0wrqCZ788e/74+XjbZAmXb3k2nLXvl+bhpUK9IXt/DmN3TDPWcSSTqK1TOJkgCDJDXSXHnctrRMW65ZlPcOGxNHDCrMr1n8ptpa7xnQiYv0LlLKPZkAHpt6MyPFRKSyZYRm2zYCR+KZbWmvfwQ3a6eznAH6AOWjzN+fZU5CEF4gFuwTHFN//ahmlZXUJo0jnMs77K6NIzzMUKrvKo+xGOqfFWNPGmfx5StQJySXZZDhvS6MKPX8Dl34EdJbcxtmrATdHnUMwI8rYWCSb4hd7flu6x1W0utKdePMjywtMzU9Nx2taqDd+HeQmtRlFHtgQ1YZL6Rg3SyryNaHjsILSrlHcn50WIsAneVh5QMILpHBcOrKL1s5KeJGGiWp/LoimNnZdzcbmGPg+7YLuNULrSUkc5m2OsQFfh+o0grIpAcx2rYLAj614bq+TBnMZCL1VjVQMjG0K0EbuHX71RhbM0hWkOhnHEBTeXIEl6XE79tj1WdzpP6v2ZJqvh8udYNgeAcaWku/MSDMVjeRjWJj9/EjyDHf0DWjIBvaeyBMfGslkp1G6zm2rdBrNtGA5cOjlLEeqWtAS5Zz92Sicgla0lZqrYwt7fMsccpsWT1I02Nh0r9dL76Ww3yTg
 i1c3UXQp
 HopyVyu6XjlDGi0H7W5OgChJK3/jSgBeO8IkKJqLT0tdjxKBqW9WxHN/Z15jZKg/JfRYQe5PYxICwszjqaNqM5L+GFXS9XQ4e/p/otDP+48Ass1sFQDjc9p2GhlVxhIYZJeIWY+HNi3JdTYKmCpgRkJUDDTnLQAnTbge6k9bBoemaCcvALp7tTh9ZqKx+GMCU8B/J6pD5cfjNaOtW14yOTnWhvfED19+0GFspFS2o/9bwgFFzReY70BLlE2cTGL7hF8+RHvsGaZfZGJk4SZNCttIegF673En8684p2urmpVz/vVKfZozf4CGlLCptQJQqaDmTCocORwDA+AZuP8MMVTZFTYUAc/1sDydiNI/wrzCxrlP+wzGkW3uVnMpSSva748saKCHcgCvWydFO3KN7Nlbuz0rHGYXhphgit543J/mUn7xJD61noeHsDd7jopA9LEVe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This is v3 of a series I sent earlier. Please find changelog below.

There were two "todo: " items of the same nature in mm/damon/core.c. Both
of these suggested that we should iterate over only installed probes while
updating (last_)probe_hits[] during merging/splitting regions, instead of
iterating over the entire array, which may have empty/unused indices.

So this patch series does exactly that. It replaces the for-loop over
[0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list of
the context.

These patches are based off mm-new. They pass all KUnit tests related to
damon. I have boot tested (but nothing beyond) on qemu-x86_64. Please do
let me know if I should do any specific tests and link the logs here.

Changes v2 -> v3:
1. In test functions, new probe and context allocations happen after target,
   region etc have been allocated. Further, target is added to the context.
   These 2 changes help in reducing allocation code and improving simplicity
   and readability of the patches. This change is true for both patches.
   (on SJ suggestion)
2. Earlier, if a function's argument list required multiple lines, I was aligning
   these lines to the opening paranthesis of the function. In v3, these begin
   after 2 tab spaces. (On SJ suggestion)
3. damon_test_last_region_quota_reset() uses the older version of damos_skip_charged_region().
   Make it use the new version.
Link to v2: https://lore.kernel.org/damon/20261008151944.113714-1-suhaas@s-joshi.in/

Changes v1 -> v2:
1. simplified commit message of patch 1 (on Liew's suggestion)
2. wrapped all lines at 80 characters (on SJ's suggestion)
3. added comments for new argument in function (on SJ's suggestion)
4. added damon_ctx_destroy() in r2 failure case in damon_test_merge_two()
   (on SJ/Sashiko/Liew suggestion)
Link to v1: https://lore.kernel.org/damon/20261007154851.45368-1-suhaas@s-joshi.in/

Suhaas Joshi (2):
  mm/damon/core: Use only installed probe in damon_merge_two_regions()
  mm/damon/core: Copy only installed probe in damon_split_region_at()

 mm/damon/core.c             | 57 ++++++++++++++++-----------
 mm/damon/tests/core-kunit.h | 78 +++++++++++++++++++++++++++++++------
 2 files changed, 100 insertions(+), 35 deletions(-)


base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.55.0


