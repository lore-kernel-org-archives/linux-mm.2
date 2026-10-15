Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D474CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C6A6B009B; Thu, 15 Oct 2026 09:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D946B009D; Thu, 15 Oct 2026 09:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FDA6B009E; Thu, 15 Oct 2026 09:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8CC96B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:56:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BF59C09AE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:56:12 +0000 (UTC)
X-FDA: 85325009784.02.AE8A11C
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A1521C000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:56:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=CVZiHBK3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HjLxytqe;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Iz0SjV1j14iXIROKiV1q9pod0znZkHcJbWWiOIXZmo=;
	b=eCpXVsuJVIe+madMyxKZmfrQZNcBce3ElOE0ZYvmn58et0kc15np7in/RhJp9SohQt2ixS
	SwVGfQey6P98pV/J4T94NdtDqu53i5kT5REJ/pf6C9odGjENPCUgC8Ddrq19yyFX/TF6as
	XDiyFvquKVJtv3y82Zk55gnAqLdXV5A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=CVZiHBK3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=HjLxytqe;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072570;
	b=FEi/hc/lOKYHRp/nB9x+Rh/vD+9vppMXNTaAdNN5ifFRqmd9RwLnKdg0z/9Oyw6UzvpMBX
	JJi1M23WARM5OdBcN4uvDjG1TMJW1LyIahgjn0knDb9okgP1658zVjQpgwMxbW19xx2Phg
	WE2JmSTVoec5hrWuDWi+aZ/QgtZBQFY=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 0546113801AB
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:56:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 15 Oct 2026 09:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1792072569; x=1792076169; bh=6Iz0SjV1j14iXIROKiV1q
	9pod0znZkHcJbWWiOIXZmo=; b=CVZiHBK3lRFcJwycltw5lNqnUDrWkkXK6Z3FW
	n37bF6hXONm4/TGr++Oi/xMEqvex/KbMJzOzNegj29k8KeOQLfO0XdehS+vSf29g
	w8+kMirUNVbSlMeGG3shDyDXHxTmSxAcakk/s6bV8cjkdXtG1fI0rQRnqUEDV+VR
	qG3bIYWh5wRLiCEiz3jF9e4nNeLuPsxsiPreTaiIIjb0f3DXkdwZa32zF8PpkRox
	Mj+A7O4sGPm9lnbq2VOOMnyl9xKSeDHkku6aP3qdp9fd5jLAAh+bRlwO4H4Y6ZRJ
	FXiLELr0gFbbdOHtwSIapskCJvQ48/4uosDVLwJkxkaZuK1fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792072569; x=1792076169; bh=6Iz0SjV1j14iXIROKiV1q9pod0znZkHcJbW
	WiOIXZmo=; b=HjLxytqe9kiMUEwdZsMTwttwuZyKJ+MYCF2PCMY9dX7uOrFAs4D
	ddLIfZPa5V95+CskHlFauiDl3Jn+9cACUt6dUJn0pxuKs2g5Imq3pP+WayAH2oWS
	RROuHKcUGRazK0yHUuBdpGlMzaqaFr8HfZRgRnSt858We/69U8hU7guS54m3pYjZ
	LP0p9nJrt1/NaZghTttnrQ47cBWbyBkwlz1SOlSwCo2vgRDDAZrd0xKPngAHT5En
	dT3GXxbehY/EuOFSVuoiLrXoNr+03ffzhDbb7pIA2+w7Rq2FKKeqmvrWcds5FZKE
	bl1i0pBlnwyMS29ZkWIaQyQJ2R//sVxAD/g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792072569; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:ZmF/Vf3KK5aV4aYSVXTneiUzcZi5SBY5R41RTK3b/nn1VDh
	KknE4SiGmwtIdBKV2LVRDQtL3//zDkHnHP3okptZcR86lBZQxEbBAeTf1fZDKe2J
	isjYpsE2qIUHkqvxCYnlF+BjBGrEvPWpUtMxL6KoMdYa4sz0zDSVxNp6nz+jK5bh
	hMpCLzTqMvwJidPCy8HxYKvRyUabtI7NLwat4eJSNT9OBSukf7aO04GZZ+ZCKN40
	jUAgsYtxHaaUwhct6ZAOlhv8NanzBYe7nIq0YqHEq0O5jmAwXxmI2D3GNK+KUEIX
	zIy8rzd3/GAnzToNZbcHsWcsAgnk3e8PFWtEOKA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:3jnYft+Dh/qHjAkkCdxyFgGWgxlFEGjjq4ysYZhssbw=:yVu6IvLdlbItjVbGSeytArgWjbLhLMf049inMbErsd0=;
X-ME-Sender: <xms:edvQasCCxVT_BlnWZmfZAADer7YCSKtzVeO3vXGLwVvFZprwChvjpg>
    <xme:edvQan2bfniD9c65BFFzSEoviNOyFFQh_upymh7-lYZsKxSxC2JrbU5vWPtmp3Lh9
    EeRaZ9wpfI9bmdzSHdf06F1XN36-YAwPTbAUu7h4qG4UiaiKllPrFI>
X-ME-Received: <xmr:edvQam1RTDF8lUuylYMBt4ur1EeujR-MKXjivCEMXMj0TTbRHUGWuedLEw>
X-ME-Proxy-Cause: dmFkZTFMuPxk0+Wh0qun9tazji9kwhFpFI+8qyirmz22zfT2QMxLUvh9TE3VKO1Q6/d7Kc
    LsBd8rEgRoTWF10LBwEOOGSaXLAI+It4wZP4vNDmU3coAW4qLn/s8ZVCCrVLzU6n17fsC3
    1JmF+bd86tOabjc0lpAXKg2NQ5wJknYTpwG3fsXDbP2vq1pTc/TCzJxkK6b3f0oi6z+YDc
    /bBl7L51PnsOrIfHRhwlIW8A5LhNxTP4fFXdyDfPB34GP4qUZADUlH5xvOOamtkK5PEvw6
    PCldTt8QbCbdFwduMf9PnWO97z8iw0RcXDm0kKpDLr65NA7/MahSk4penFXWeQO7yU+UZu
    3CAU38I36GOyOzugBHb0ZHH8hvltGn1RZmhRF6o13YVJNOCgnKIFCLhiMQZFO68r9BvpXT
    wclLHnCeowclg03JfDpXwZKqxyaMB3FCdOzqAPnqrev2GsiA8lwoVC9xAy5IQ24NLMGEfB
    TMTGckuyT8Uti0IWBKsCWOw6QDYJ6ZmhARheQMgk+Rn3VrejTDuOZxv5Te2NeooVtzENLo
    2hXODHBEZ3IXq67OrD669b7EYKsegFtH9aX51tyma3DWtqrdsNwC1nLNA6mlH2E2uchLHs
    UImeg9664C7UXhf3SNNYL6nBGTU1ZuXMd9G4AEY8pXY6IMAA2//hM3cbQJZA
X-ME-Proxy: <xmx:edvQakC4UrRt2vRwYgVH6nPLYMbPqPjanlEGoB7maFNPEOFxGOZBxw>
    <xmx:edvQat5pyoEaa_AXaDvVarHyMXnB83WRsUJpExx_jazsJFpyG3CIsQ>
    <xmx:edvQatKLwjncucxVN5yzx6W5uMrFkYxVaHVWPcCQMvqKRvj6T_Fwnw>
    <xmx:edvQamsQUE5bRHWW0jtE8X4jeXqy6DdjLdbSG4_Z-JmJIvZSufcOLQ>
    <xmx:edvQanYR9i9xB1Wii1XgzIQ4BGJJ5Dl1gYok_EF0-PYXSWBwT_9CnOWO>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Oct 2026 09:56:08 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] mm/damon/core: Iterate over installed probes instead of DAMON_MAX_PROBES
Date: Thu, 15 Oct 2026 19:25:23 +0530
Message-ID: <20261015135533.18761-1-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wkjbp39dpqiro1pa34rkpnof8zspr6w8
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A1521C000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1792072570-546866
X-HE-Meta: U2FsdGVkX18S2RRNOOIER2PuYWkjouUc3r/smN+M0eAMRQTg2B1k6Qy9x0+aNVh8WWKwKxfLI5kxrT/fSTQBiMt9Xp5+89s749b+Llzs+JoGiJZ/3XRwCshPA4TiVoi6cVk26Bh34HHuyCpoflKRnzzKfJkwYMl7yDwMp3Yw4v2obHqVnX+dySp2zLt1BoZkdLn+QY+hr/Y8K3INEqTUi1o9ODjqFxwoi2fEK4NWoQut92dOguNgTaZHzAOODhpQIZehE6YXwYPau9oPiiqUBPvJLVyhXq4elvq/2p3NtgwENPybLQviqdy/0uv+cdTnIVFPwG7h2Rk3FD0Ke4m4vFRGGMW7IaKLbD8haRR4+1ALxAIhtQLyQGgS344sAsB8rNMHnDfQ+NXeotzbirIk/zD8g3SlAH2D/CLcVG3SJEcR7NwR35YQSlP+1l1y9UeIeX5+Mxup1X+QpOKvvpS0nuLPzEykYCcGDIojztCkJIk4Xpy8/P3SV27+EFwZgS1SP1+gp7V0LjgGjXiuUayhFEzdfxgiA5/JT/9Xc1M2KBuXemA/MGfA7cEzZZ7eS6ieh2YPtcROC0xlaEWa5CWVEZ4k9+6NYbGB5G5oX82q9dKvMSxwaTrM+Pxr6sPfRXB0+GnRFpGAPvziCRpdjeSDVWD9bhTN2N1gBpGyFysSGsrKcbWnDEbhL8p4Eun3xOk7MXTDgFNEEqgHsTHarMPyWe4wy/rp63liCaDM455XHzYqNlF+1YYTzadzCiGuKx3ps9Q7YqXjI3fHNpWVTLBcLzS9/fQRwuH14o+gr49Q0Q+MeOF1EWBJvReXMm7lI9sgWXkCgyEHNIacIQ5u7pN2zy95nm/SAAcNkJkldxrrqORY3spEiIf5+mOYIW+R6pINxM4YyHT0uucubnpomOKoYOtwyzvJ/VVsAD/NhLVnirPZSWPsqKXApSPqTiwEM/UhBznGdpw7afbts6UiXcU
 CohEMb5B
 dndxM58kuUHpIPkS4JXXt+N+i4MqBVnR8Z4z2lVjkdZj+7/LqHihyk6fPI4dZrho8iNmEZmAo+p+cBXA4Y2L1Nt0hmFYGQ1isJQw6yXY88ajsO6sF8DkgBMg2U8gJMA7swXrFWgbclHWKUCpVcYd/puC4Mw0Xl5UOYPCWvnuznPkOqGdt/nsnxs5iF+5Z+i5ISd3b/VpAcRmQF+NqMbpL/VeZwdMJxQe2m9kdSrsclA3BpyYyUFzgUt5NfH4gAZHCyYq7kDde/wGgrxs69zjjWKE0AiDS9QAmfL6i6Hl/8nxORS0N8z8MKf98C6e8Li0vULJg49dRiEcEDk5RdZQasrabe5qetZzcAMnW2PQbl1h00UrMRe0adVLhr2XWLJUYfHUz0VdA0secCBD5lcvij0alR5mGk6rucemWMv8bGGJmU3UbZQUgDy9/wKSeBx/WcLw1RFwWHAdDfYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This is v4 of a series I sent earlier. Please find changelog below.

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

The series has been tested with mm-new fetched on Oct 14, 2026.

Changes v3 -> v4:
1. In some places, kunit_skip() was being called before freeing resources.
   This is correctly ordered now.
2. In some places, regions were not being freed. In v4, they are being freed.
Link to v3: https://lore.kernel.org/damon/20261012145636.168436-1-suhaas@s-joshi.in/T/#t

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

 mm/damon/core.c             | 57 +++++++++++++++----------
 mm/damon/tests/core-kunit.h | 84 +++++++++++++++++++++++++++++++------
 2 files changed, 106 insertions(+), 35 deletions(-)


base-commit: beaba65d5704418b6fa03c96a389bc2c2b6702b8
-- 
2.55.0


