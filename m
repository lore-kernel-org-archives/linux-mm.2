Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153D8C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95806B0092; Thu,  6 Aug 2026 18:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35B76B0096; Thu,  6 Aug 2026 18:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D766B0098; Thu,  6 Aug 2026 18:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C22A6B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A257E12061B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:42 +0000 (UTC)
X-FDA: 85072358364.20.1E689DC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 135DC100009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CuH2xb8a;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lf7tc0430xT4gOTJbtq5G4DzoBoGs9vPXXkZBh7qyk=;
	b=VDamY05w+uRfUgMkoOQPV2C7lGUUKYF4dMfdW8s0z8JoGZ3oAeyLFzI8NnqJWssa3Jje0B
	BUH9kbf7Fqj2hp3AELiRYXSOC583rtoU/i9p2djqBfZ3WoNAD2KTgNSDiphsHGUoSgzWWB
	iG0bmXQlOjVR14xazYkyvVwoFJ0+wzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057060;
	b=FJCJnLZcXeNiLI4v2LTsQlxAXURNMrfJ483wF+p8aGfrf0HDwo00hIG17HMnT+vY+KFf3L
	euSLfra9lfZ9kTkV7+SGxez4pzZytKkxsJJHeblT+IgADC0ssmMl8tOjzmFzYCQo5KAko7
	qlkD+Imzo/G/W2ErSvOvM5+qptaYNnA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CuH2xb8a;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676MbT49916975
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=6lf7
	tc0430xT4gOTJbtq5G4DzoBoGs9vPXXkZBh7qyk=; b=CuH2xb8aNhrirQRyvQLB
	qA8d8CpM1G5Obaz5Bg5nA3EQvWdOfVmDqLPvIEGhyNdl6HJSKt2V1d8z07uTcmjx
	LFDkMZf2cX7Iy925YnCqnzUvhIbW5xrx3nImDAgeFiOVOJYSE7quL0KSuyTNMVSc
	nTbYEhyVfJW4Bf4IwfztAjWEetA3TSuVoiDu5q/zqblBdPzDzJEuClHUT3xkA4yU
	Fa2a/VemsEGrUyGdJtbo1EyUOc81/0w1FzQM9DlTFoLAUkhB/NI1GCk4x4p+qc+D
	IkbCpvIzTfVD8c8W9dj6EGugHAoCsyFchbRQgPOMxsqbiqZJmlsPm+uNZFjNnA+R
	vw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvvqrujyu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:38 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51bfe3fa93bso29682481cf.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057058; x=1786661858;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6lf7tc0430xT4gOTJbtq5G4DzoBoGs9vPXXkZBh7qyk=;
        b=GcOhlP7bkMoAB2yhtwZiAkfWG8N/rHlJXrM7BTPtf1ikjJoAG13+Ghf07eeKmh39/L
         1VfRQLqXSjQww+mVXFOXCFcZjQZsLnemasO+6u7PpOUvK2SQ+LqCkLpBcInWWY9FncsV
         ssyEgfkuYmxWUN9dzcoDo7EWRze3/qmAHxBEnpqsWKenWyb/3fJ6M8RlWPgPJgcMCbW6
         /XZzO7lUEeCLIFjvLvL5/ag7mTkeKTs6EylwcbQcaeSK1Kl4cnOu1NhWZCXo3TTCwPs5
         gS2eezQMjXjBx6LKL/5/KO7oltk5q8mIk3LXyF8FuCTv4whE+I4V3bzrTp48mgoZ+EkI
         fR6A==
X-Gm-Message-State: AOJu0Yy/TtrwCZJ0NfABcSLp0cYp1GVeqrxT5vBl5PTmBwqN6M1BEtju
	QigGtsItayH7i4E44JSRq5N9S50vzyx45uPgSxQY9UUK1R+XjyK2+pU7cPgmkXzLY4ZpxtGixdN
	DHtJU+TEsamShRUhEJ7GKI/t/iYwXkcUgCYsCDDvRboRgRthK
X-Gm-Gg: AR+sD11tLIBva58Yb4D3LxkcCk1oM80/p3kgGYL4HOj+wwfjdk3wJSODhrYdp1sfaf5
	aBkZ11Tle70DwiyRRcsqQMp01cVkZedbfa3xCSgzFiXNDopcQzdCtQZ+wY4SKJ4/vy+yYgxnpY9
	mf5Q24l6rE0Ngnr9skn36mgP5h7R5uJ81OY8dMy9UhiAc3UzUYdGhIqrDxNijwqoww9uDkw9VDv
	/9DvpemTcXWoxqf7lhLSkGe/Cvr6CJvhn9H2MoDvCg7ZcVn3sMRDcvaDnuuH30K+jzP0+UNAJ7d
	+bTPuk6QezXF/Y8gCH/5ieZbV8RQ71Q9WDiait+tg1DxJqPBfdYKyQTuF44pq9mMCDl0QDME5/C
	vK+VZBh+5X8g5
X-Received: by 2002:a05:622a:138b:b0:51c:164b:b242 with SMTP id d75a77b69052e-52ce5fc06femr192657001cf.15.1786057057682;
        Thu, 06 Aug 2026 15:57:37 -0700 (PDT)
X-Received: by 2002:a05:622a:138b:b0:51c:164b:b242 with SMTP id d75a77b69052e-52ce5fc06femr192656461cf.15.1786057057182;
        Thu, 06 Aug 2026 15:57:37 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:34 -0400
Subject: [PATCH 2/6] mm: remove PageReclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
In-Reply-To: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=887;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ImZr535pNw3fhd2raTxgYzgeSnDSZnFM7CY4WW5zjLA=;
 b=stFLBiK6U2HQ9vdWfK+91RWhFSCfZKTgNnFMHS38/dwaiaus0/kzEM/uofDYgCT1HKOGt4viG
 7dYb1vy8go9Dj1hRMINw6GNjuC2MqdyDJb2bMx3q+3iQHYiOFKfIeSW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Mv9iLWae c=1 sm=1 tr=0 ts=6a751162 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=d9xi81fPSHklMBTu3CMA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: DhAYLSscwE-CM6YM98fGjZuSQZb_s0ZS
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfXyDQeEdCx3Jwh
 zT8bWt3TlOeT5NZXnc1rSbpHpJ43aeInUmjn6Hq1RcgCg/5J4x8SIqiAL3MtmNsl2wdFCANoLnn
 SMUHjuSy3ZmwJK9ECuJU0AF2xRtonynUFIOcDPKbS6nqd6myDfOL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX3VxcjpXilLNX
 tsZRIiAJmf9Q7JOOVX70zpNBG7D+6hWITn9AxSkV54dTp1VAsB9fZlVelPhqGor7WA/v6ZFge4S
 KnzrQu80sNXYqOU5IZnpT7xHTxZXO9jrI1iFwB8pS8VkXnaXY4qLTZ9wfpSXy5OkxGgnHYRRMqy
 sMG2CpJIX85G1RqLxCmn2BpsbKMYG/kRufs99LL/FQgXpT6/Bre/i3smBFvKrRI13p2zPZWqCUS
 4aohRK8W0oGKBZbLRGP67U2sTORi4+E/xuZoupY4s8UtB9PQ3rlYiZmLfzUXvqGMx8c31b8Ymn8
 ahcwUlrYvm5viGS6835d6B0BZLNu7grZqgJguM3qtUsx6estHWTDYdb0I1JdjnUwAe/LoQVwxYx
 nyzqYiXUMqC5rwPVrE+wwjrr1h6zNwjJPU1NW+7euK6H4F1h90oFLGXliMV7V7okiHigXKiyJ+0
 UzX2PCCUcjT08d09PHw==
X-Proofpoint-ORIG-GUID: DhAYLSscwE-CM6YM98fGjZuSQZb_s0ZS
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=10
 lowpriorityscore=10 malwarescore=0 phishscore=0 spamscore=0 impostorscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060180
X-Rspamd-Queue-Id: 135DC100009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ms1q5qu9umpp5sh6etdunzbt7adntyb1
X-HE-Tag: 1786057059-290733
X-HE-Meta: U2FsdGVkX1/2bS2z0X/VtOC1OD9AK1vd5s2UeBA511fp/8bxoZyATUzZvMDwVbebRSR1giBbtVFU0A5fPTZQGUBYdWLlHJfrQd9xs/pEHT/rsuEXEA9j2dYkhsF12kI04f30ZI615m6cMTqvErezFLsR/enleIIwLESINj/OHmsOkTcJA0s6Y/rFd6zzlEje3nxqN37i4shLyUQI1ccgWXoUdLbm9MDK/D73WQTPyxmkZsCGTd+tKYeogPe2n0cvaiIvASVDdlS/ugU25jeUtAXzcMI7FUJ2FwHuo1jBGOiNoYMy7uMkUbc/n506JuirKFd4Su78h2dqip+ixSxv3zGHQzF8vnzTgRPkTQXb4zR4zalZEO5lEzk/1+VuZIRvBbgYLOArYGHgRtHOhbHEZF+91LU+cyeE3brV530/pnSkbIaUO5ZMtnLDpBeIZkIJmZYwzvBAGdiD2AKxoz6YN4NWeMyvy4w4DpticeuYZiF6fdKh+kMtZWcqiT4ABO/iu5jIUU51fstV87l76UZIVg40HgCxXHj8j1+5/likl0WkyT+IJ5IzidR9cA5UVhgXr6BUMUGXeU0wiCixuWZMWEMT86pr9sT901IuV9Ss3OE96jye0L16HX02X/27+r9Ey8pczxilM4ix7TcGCs8NFTGgp/Z0yHSLhylu71OmafciTufg6hnJTtYBuC4VDG2xvlF6D/+DxRET+4jD6gJBz7WHiyuNBkxwsShzKT76VhF28rFSAc7XrICYkR5Q4zVcF2+mq1tRSsZxJSHrKH48Qpb1RfJ/ob9pC70eYW1/mJwhmu98aRTKcQcza8rOehmHl4AJeUmq2LVpSMQy6ZbffnEg2iUQqeiCYoxwxaoIj1MsjRLO0emdOx8aFBfX4pmS98fYaguWPvk5Vz+H4l6RtvpSQKdVD+zoO7Z1w8XOBDpADyJyTxDZgjNRV+wHgV4jicFEQnb4YdKW2WY8ULc
 zhuDsmdu
 Ai2SWj0fIQocbcOEzP4XX24p4eaLVuyPMYaWL4Xjw1BfpY3doDISDd6cplktu8aUaJUPwNeDV64to6NGWAunM4ohQqEk00wtXl9r6gp41Y355reTB+NmeApD7vZMu9Id4JegJTzhkHqp0gu7EIIaYtDBFy/m7SFyedJqYlvLJa4Er8Cx9X4qIiMDM+zUsKmlLVDm/aHZdXkoh658y5bwsBvrygo1dt6EcsQJz9/8bHyNcK3lm6ogKUpE0xBp32ff0TcQ6OP4Cv4G1xk5gi1AC7e39FY+w+fh8MmofBgvZBjiSifWBYdZVXrBzEtJRTR5E5YHzfVY7WaNvaUiRu3+HvAh+oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This flag is now only used on folios, so we can remove all the page
accessors.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page-flags.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..4cc83f41ef09 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -593,8 +593,8 @@ TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
+FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(reclaim, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 

-- 
2.39.5


