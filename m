Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F921C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1BA6B0098; Sun, 30 Aug 2026 06:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9206B0099; Sun, 30 Aug 2026 06:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8446B009B; Sun, 30 Aug 2026 06:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02B746B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 831DF1202BD
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:50 +0000 (UTC)
X-FDA: 85157575020.16.DB469F8
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 19683140008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D8u1sq1d;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EaA+5W8j;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hv7UB85+3sed5S3Bw6RQxVg14F7gqMHHFVjFXK3+ME=;
	b=smL8R4stEGmQ5VeaY0nwxrH4n02mZEmhflhaQcoWXSSlQjIUwOjsL9jqDVHlUjWxwsc1DG
	532ayggGIQ4qDskHvMQ/jZm0ySejA6MPT0Sy8M8uHe09PbYiByBjAA4l1YzWA/XFVca7ZD
	FGlWICE5cfahYRN+SpgeyHdSNUmyyVI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D8u1sq1d;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EaA+5W8j;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086028;
	b=wyad9vQYqj2ZspupbcQQ9uVICJ7R+Nx30j0Yo/ec656FUZNIwHrkK4ouc7JMhuOHoX8r0u
	pd/dfDPTQd9Yka1Mr8nQd9Co7SINyDFGz2TsVJ5XQM/WJ/3kynQk6CNj8F/H0RbrZJnZQS
	64vZk4Hy+OIja+SO3xADoeOH6ZZFUR4=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9vws73342277
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5hv7
	UB85+3sed5S3Bw6RQxVg14F7gqMHHFVjFXK3+ME=; b=D8u1sq1d7VwcqZO3Q3C+
	o140neDrpn6FYbpDuNcy11Mpm/cKasG/+o6veAJEI3BO/Rsc1KJWrYTwwwXAoDT3
	VjZ+nncd0mFRsbL225J1tQ8H2RFTZWvaeQbPSlWP64oXd3phUUb1Q2YZtzye8gFt
	yoHfhJ0JvGUspsm6NJzAoyz9bVVUIXp22xCl2nNXgscFko5Ogpc8axyoRovjNCus
	QljAheSEYgDqkd0WqgbBAOWFo+nDTBK7qPEoPb7u315/J6hYsNPCcK1WhCEuHIo1
	OAZCLkpA2gnN6UABkyZe4YXg0RsHVRxYswQPc7cxurnuh8r9XZkDB9Dhd3dIdSQZ
	jg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbuaa4n5d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:47 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so51267021cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086026; x=1788690826; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5hv7UB85+3sed5S3Bw6RQxVg14F7gqMHHFVjFXK3+ME=;
        b=EaA+5W8j6yx3/Nz43C/9TrF8JsNusykE+jw22Ky1cw6YRjQWh8HZHno0Cr60tG7FoQ
         CTHTok4vvJji/O/pByPt7TqHhNgrSENqH5qC9cTmQNp6T9E7R7wwGhb2YVPf24O5fkay
         zw75WHKEEnUWKVUvgpGjYZBVUHNvmHX1EEIMtkQBP2SbGA3SDQIgXbayKBFdDzNWBqUW
         xtdtXFUZ6Syh1jt+tCMS4j6xKqHWfiIgYNDN6Djh3a8E4cPXJi+S11nOGPfKO3gRGqMN
         kSiROcOxwrGWIxaIubrpaTSrQf22zmFzuaVCTUtICpMw8ANMLkJ/x8hVXiVMUTbnfxA7
         m2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086026; x=1788690826;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5hv7UB85+3sed5S3Bw6RQxVg14F7gqMHHFVjFXK3+ME=;
        b=Eygd2zqA+pAcinc/9VcI+J7ps/TfgT9KHKG3DdwWZ7Le+JrzNZumh+JpXFNYe6yDct
         KTs3vFh4aYue1W+BoQuDyKqZoDG4siOkILdBdcXtuR5UjAVOD92y9kGTHvJiiiMgpdPp
         ikGnJrJ+AUyfcQ7VpQwBX14ONSMWLxWRn8GGossn8Gpb9o55YAZyiY3/XVLiWpndmhVl
         HvSxMu689yzvNu7ZfNCpdhkxzmVockPOLhHiqx1M67nZBB93qI3+5/x95CmuEd5fb3n6
         AxslGvuWc8Rdnr1LOKEMycIN7zAfyEHs4gQxkw6PN5pd2DR4lGp5E57SQbY95oV2T+1A
         /7jg==
X-Gm-Message-State: AFuF++lwsBopiy5jWBd6sR+K17fI09wd8wbxlm+AJPfynar/xl/xr3ka
	fHU0wnKeUTalvrDjItE4R/wPOt1fr0DI36V6waaUFe0v/kwGwgeWdgZs9CZmbKWfCENpwZHqdWW
	z5Y00uLJWd5743+7MHhx3geKLT6DW2iwTRIj/tnaySB9gTKi3
X-Gm-Gg: AR+sD119XQTKmaGpj3jfLLUUa/qYk4AQx3xCh047gMsNsm7KYF8ynh7PyX1L1QZSlar
	p8YZuvH0IVfY8H8ludGPs9HOMH/Sx+lSYQ8MJW6nLLuFBj/JoIyCtEG/+gN9HIfY4qiHVZlYwrM
	XW/eiGygP+tMnCXwD8hwrzH9hemXqkYpK4uw9qfnA675Pex9jvFtFZhmwOvCM8dgp6bPsTOZfsk
	tauDBFO69viCO0zyQLUpFf+4nzfnm+6HMAK2mJmoSqgptdNrICS5mJxy5ZGUnW7ypsUX/tgWCBr
	F/rnMvFoxdmBRuZhV+g14NFKRbSYlY1ie49dovY6NFhIrKQii7vuWAV2aJjbSTOLJhoHyrWm7ps
	73cZSryIRbrYAWLQv8yLUINf6dF1mW8kDMVogGySgsw==
X-Received: by 2002:a05:622a:1dcf:b0:50e:474a:47e1 with SMTP id d75a77b69052e-5300b8aea8amr14550651cf.10.1788086026554;
        Sun, 30 Aug 2026 03:33:46 -0700 (PDT)
X-Received: by 2002:a05:622a:1dcf:b0:50e:474a:47e1 with SMTP id d75a77b69052e-5300b8aea8amr14546791cf.10.1788086021397;
        Sun, 30 Aug 2026 03:33:41 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:26 -0400
Subject: [PATCH 4/8] mm/zswap: convert the store path to take a folio and
 index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-4-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=3733;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=zHKyX7u/bn4nak9pCenYEmsbJoOA3IZ5m1jHPNOzKoA=;
 b=4eGm5s3wMRhMtyl2KDA7tHu6Ni8dzHC/clJdeLywA4tmCGasoudESZYVbGlzGooeyJ5yCSNiB
 DqkznY1tScvD7VGLmhid2OffaI9AHRU0q7WT5HvTmnC+5CEXfKFG3Cp
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=EZv4hvmC c=1 sm=1 tr=0 ts=6a94070b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=Zkbyt3CucH-xCIxE:21 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=jHxIr1HyPKZ_Q5_91PL3:22 a=ASlJD9JRYGfELUMjv9QA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX2G/mzRumTrf0
 1KtA63sVF/S5qw1DFb0/eK/0G3hHPLYwVlG9ItbJEIAiJg3wBwfROcAqVUGJzRRsV93zVOBXJcL
 XM7YLdH4lkY6VlB1fDSE85s+A91tR1q2fBRNoXOvk6wCgNkLayXv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX//xlK7WtNIWh
 oTrsnCT3kQMAv76UxsUoMxAyLHRxjXrlvuCDQWpJFfASGTJdTT8ysJABqR95Zl1EvDM8+SEQgg4
 9mdHoCH2Q4YGiSw5PxC1sPaRbtuLmtYelbRo+9COrkb9CsgA45DoBIYobg1VPuqDllKsXo3c5RD
 StxWZeyWHEZDwRCH53IpsMMmW8tm0myhoHfKd9QaJOyKXq3YaV10lyQyHaSD2YBcY09l5GixdjY
 C85xdSKPbDxH5J5ksCI2ldiYifKIgDDsM51SCRxkJBihIKRcbgwchjGNwNV1J4GtVNxdc1SeNVt
 UpVOC2XjZEJJ2noEiPGyyPFqlQkoqDMUQZ3gOi+phiRENuGpyRyqzz871b5ijcaLtkQz8ud+Y/s
 VoTclwfnRYvaZgN+BEVugcj46GsAdcs6rpJv65KnsC2gD6WZjA9rpNOEaJIoFF8H5XktZAJit9J
 GFXWaI4iIyufVYNdYiw==
X-Proofpoint-GUID: KC5sm8knV9g-C4YS2x60gXYUBCHudyM6
X-Proofpoint-ORIG-GUID: KC5sm8knV9g-C4YS2x60gXYUBCHudyM6
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 bulkscore=10 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300088
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nzfwjf6r7cr46d4oi3m6z4q7rd5kbt3o
X-Rspamd-Queue-Id: 19683140008
X-HE-Tag: 1788086027-426510
X-HE-Meta: U2FsdGVkX1/9fmopA3cxj805rX0IBQ6kGQ1A3XejG6G3dgBW4pr7ndQ9fEyrIP63eFf3EwzVokhny3yl2IT9DRaOxUWLcY11Sntlk9hsmr2Kgvh+4Ov2+HMNHyEsaItEnyHJw3fDnUgfIPopkGl7TRm0IK1rUFomZ/6h8PvdB3QRv5S7w9mRx5UNrw0xOj/8E7oDseTgAcn3mcP+Ew30K7ftwaQGfqUUY+n+kTp81lRfclNu6JNYormXK67kXITx2t5yxHhzIddDikp35VUljrNpCJRPsWCqd1KRGxDJAlPN4Sha8cVSjtL2e3UaMK46K6ZiW45R8YSuNzSy9zOgphDHoQRSys23fDk7H0Zbq6h1NHeclVgSd1p6nyKgJ/jhXkSQawkP52g62V/74xUlFwq5dWcJTLZ9HmLa250ZtNx9RdHLYgAQpg8smbbII/wy3xPRCa8CrNqKMeZDPfIjZibT69gKo2DqLVhnbHF8HR9nmUuPZK7Nr2XqLXqPTBVAv4nuDyu6pnzv2Uxiaebg8JNJ0z/OKR2wD3m1f4pHaMQsdnoKhaGh3vJIqs9555FXCQ4HFxcmA0x0rqhf+HBN9gtfAk8YmWv6j8jnitDJLR3Oh/Pw0ZSDVJTQNZmIwJSDepPcqruIEwTDa0zQIZjz+JefR2lqeOmUmj4iFIr4SEyphCrTZhOrgfzb5PhVt8+hTVFiGCUZQ/gaZlvIeBJhfaILoTSqSM7wmC0EM+QZq7mIjUg9m0P6lhg7OWIYeLVKBX1nSvdJsN04AuncizK7KQHO/kvLwvxnDKzhpEcHBSgUCWA3vEN0prxEbp5yDU+LYT5vD/EeYVAcLwqvFxj4qv8nTn29jCPF/f3KdrlE1SQOBGDYUHMN1dlkaVOgjtqfDj0u0jBa8W1kk85jQlGn3ZDgX4d0p52x2RCDLtkKnh5kq0NK/Uw/ksTXaOO8Kw+CSZILPamVMnLOTAX9tBg
 ypwbsyQ6
 5+v4+3vJL9t9n6ogdGoiBw+pujXJ8mNYawz1+wPXhyrpEuSKhOuhujy3FPcJZiDAdmYWnT0M3kwjosfdZS3c7KbTSFTIVYMPrT0dEScwLRsF24wMGrvWlvgu1M4j5Bw0Lq/+78UOfEg/JYgx7ao5CrFalZ3WLmPMCzacFw+P8CaecS+6SNnQtiD3PQCOSPwemP3AvVUkP0kwpDpbSEVmiPgX7zbpJVlUxKNG6/ESsqVmUD7uqcYxI8GSgAWmPnOiMb0Jmc4g9MX184Q6ZUScgAcqDYdGYGHEE2InsV17U+f2yCOboQxudKZvr9NvPeWtumBzQh2KhCrBfvoa2mXYgA4DbdbgmWldAVobxUy9xSLxHvbhtSW/qNugQ/ED/kAeXjKKJROMHvAvt/ydiTQwcaDq9389DJAiDDig/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store_page() and zswap_compress() take a page that zswap_store()
just derived from a folio, then convert back to a folio for the swap
entry, memcg, and node. Pass the folio and page index down instead, and
use sg_set_folio() and kmap_local_folio(). zswap_decompress() already
takes a folio, so this also makes the two paths match.

This removes the last struct page usage from the zswap store path and
saves two calls to compound_head().

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/zswap.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48e..3a6f89017646 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -824,8 +824,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+static bool zswap_compress(struct folio *folio, long index,
+			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -841,7 +841,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
+	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
@@ -870,8 +870,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
 			rcu_read_unlock();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
@@ -879,12 +878,12 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
-		dst = kmap_local_page(page);
+		dst = kmap_local_folio(folio, index * PAGE_SIZE);
 		mapped = true;
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
+	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
 	if (IS_ERR_VALUE(handle)) {
 		alloc_ret = PTR_ERR((void *)handle);
 		goto unlock;
@@ -1392,21 +1391,21 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
+static bool zswap_store_page(struct folio *folio, long index,
 			     struct obj_cgroup *objcg,
 			     struct zswap_pool *pool)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
+	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
 	struct zswap_entry *entry, *old;
 
 	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
+	entry = zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
 	if (!entry) {
 		zswap_reject_kmemcache_fail++;
 		return false;
 	}
 
-	if (!zswap_compress(page, entry, pool))
+	if (!zswap_compress(folio, index, entry, pool))
 		goto compress_failed;
 
 	old = xa_store(swap_zswap_tree(page_swpentry),
@@ -1515,9 +1514,7 @@ bool zswap_store(struct folio *folio)
 	}
 
 	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
-
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_page(folio, index, objcg, pool))
 			goto put_pool;
 	}
 

-- 
2.39.5


