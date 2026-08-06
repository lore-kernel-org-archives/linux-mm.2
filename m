Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9278AC5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023766B0088; Thu,  6 Aug 2026 18:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DF26B008A; Thu,  6 Aug 2026 18:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CB96B0092; Thu,  6 Aug 2026 18:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D32F6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D22ABC05BB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:38 +0000 (UTC)
X-FDA: 85072358196.29.B7A13FC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11C6CA0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GMdtXlFI;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slF9TASxrGjXq4oyPJrzhEUFsa0Hbx/RAJQ3YzomvN8=;
	b=sk5qaFlPDWDswcB/a7fI368owYuxOBF/b9hk8FXxOSHegiAf6VnfbQ2rOXXbyWIs4MDsnw
	speBFn45WSym4fb8Hj6ZgxAiCz8nvLi2702qz/ScVXyagGz4k8prarPe+IM3YjwT1quBRG
	E2RB7UEWFqZvHbOlTXeQxDn4LP2p0Bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057056;
	b=UFS7+fcXMkJXogvG/fG5ItcehuKwuOiL5tDEbyfHz02p6V9yTd5aI1qPPr+gZerPa0EW3E
	7xp865+C+tweGzCne3lNnMvDlvVTeDZPizdywzooLHS5QgBlUzeiaHtgc/k93swcaUHvHY
	vGf9M12I7rCKt9gf67Q3HYMZGWLjzcw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GMdtXlFI;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676MbZSf582536
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=slF9
	TASxrGjXq4oyPJrzhEUFsa0Hbx/RAJQ3YzomvN8=; b=GMdtXlFI5emvlPlZR8da
	nLq2wvBVZnzKgke6ziUdfuOCc7DQbV3ZFdL9pzhuswH7qaGG3GUIYPPEmasdN8Ty
	S0gFl06Ier0oZ/78uSBlBrH3lpjYDyxvGQDsaLrVmypqhNC7YcS9d12OElTfmtlV
	zyuyHwMKJXwIcNnm8hGM27iOskZrTrU+wWCXU0Lp/ZVb6SDFJq8cexBFBYidCeI6
	SSKJOH717oxF7m0RK6XH8a9Qv+YI0s5VeZQrc8wlDgsJ9GcgLNT6bH6QiBkmBZhO
	w4gLyO2hs6KGlsWEiOMbZiiIbgsDts/69LvogwR8yy7UZfZroAP/mAxi1CbjfyYV
	Aw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvshrw4gr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:34 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c0e702df8so31740811cf.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057054; x=1786661854;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=slF9TASxrGjXq4oyPJrzhEUFsa0Hbx/RAJQ3YzomvN8=;
        b=sjIAO89F1NHKgMpLM5bi37EKf9PqnjwCXAxzd1ZpUx62UguXcJS74WjfU2eVUEk98R
         ITgrtm2YOj31JEojLZKKzyZdR7TFvyPs54ayC89Zhsa0Ze9RRmiuW93Z9m09rAP6qS9K
         dmADI3rNlYkE2qebIYYFPs88K1slfoM1NVepFZcV93amPprrWQAeYTX/QtDfr2iJzd5M
         u1jRUv+ffoMqnnHMTzBE3cnUY+xRPO5WThqBD4t1wbRe/HyZo0GF4XgJ9tyoEjeMx57I
         3O0q+8Q9lirtP/5XPt1FPUa2lqlHBZQ7cQCkqnZTmbHQsVgFUjMGd9bm017QfjgZeJQ5
         TLyw==
X-Gm-Message-State: AOJu0Yygoc18Hp+/zJ6CJJ0Qnz78wLzDKzj7cw0g2kptmXFPrLEREVrJ
	LsXUa2K3cC9cLE+uzw84wU9nJB24D8WgkyV78m3tht/N+gZCp0rsFqZn3UnQOZv+v76awAIB3Oo
	nBV+DXiV6e4iBnqudOpPSDjMnHFeChdRY8xm/YtO6GcUwt1cF
X-Gm-Gg: AR+sD10vjIwJU/sCvyNgiFhcqws7jgOTxyHfTt1pRyEZKJFAs0DSXY5WjOvXGfpq5aY
	xgN1KtFO6KYl6Q85m+cojv+g3nRLp1iCaqCdayWS5nSAq38mF0h6a17Y0KgVBJEfTy1gTuplK8l
	CAAIL3LyRZWsi6uNhQWELmCHmLWIq5Q2rfWwJgG9ygyXaoGV8QMmw8AtcYzbiQ5Jc6Ous/OOCmH
	YZCeJcIyO07hPQwoT4SZyIbn/3l/Zcdb/F5K/kY1DaHEri/HzOeFEzWx5q7pzXX0+uMIlTwTOGO
	ekkU1YKKNiDs+MD6LrvWKtmI+RDpyKTlX3AGg+wNgl/cpnJ5Sl6I6Ge/f8i50DBUFvklKlCCLZG
	RA3YkXot9IWIi
X-Received: by 2002:a05:622a:5889:b0:50d:9e8d:9837 with SMTP id d75a77b69052e-52ce5faa390mr204667141cf.11.1786057053845;
        Thu, 06 Aug 2026 15:57:33 -0700 (PDT)
X-Received: by 2002:a05:622a:5889:b0:50d:9e8d:9837 with SMTP id d75a77b69052e-52ce5faa390mr204666601cf.11.1786057053318;
        Thu, 06 Aug 2026 15:57:33 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:32 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:33 -0400
Subject: [PATCH 1/6] mm/page_io: convert write completion handlers to
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-1-0899bac3b826@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=1844;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Z/Pf1wjPHp/5MmYoHHNlyHgCRaaKKmgN7D6wkWKiqpU=;
 b=34rWeTjzVbQM5iS9O77SE4hDvqRyovryFYlPWjzWpwBbPGodgVFihsld0G8libocRIvFsgrmw
 1WqAV8yEYMAAnsmmHzOMn3B0ip41kOVtn+PYzBklggoaRDpAzd8daqh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: fQaOVMaBBDvezfBQHDolLLBAz0xpO_Gl
X-Authority-Analysis: v=2.4 cv=T6S8ifKQ c=1 sm=1 tr=0 ts=6a75115e cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=rmnECYv2iy4ui3MlnykA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: fQaOVMaBBDvezfBQHDolLLBAz0xpO_Gl
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX5dFOe04kzwYV
 55r10WaRms5F+PT7qrVcggVkk036ZZE7P/0tlMLroqvciRu7/2mCHk88bdX1W6XRkCtdKWcLrne
 qXHPuPjKk3kIA9Hr6f7eouIkhL4PTamBBXP4g9i+w4IKh7kz84mq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX4wcPQTvc9Z7v
 0Ue76AMfUiqzz8G7eomDwtJECP+DMEu93HF3kOuGNIbm4WtFPKfWpkvfFzDAUC+NCc51NGtOCHm
 RbGY/gHBO0DHwG4qNMrb1U0DI1jAWZafBLGIV18Eh7OFeFuE79YIVl9+ZTpY+oPbM04dtj5nJtV
 xr70ylx9PSFMeyFeGv66GXYIvXQhdkRCux50die2RZmctT489OHIrgOiIS5v3ZrMbroFyxTeQqc
 HEKxucjH/ryhKpcieRwiUfUubYKhPVEvWSUmxOzfhOjYZ30Ohyako13WClbRk83pFvWt6OrRoOv
 d0RJJAIPl6GMZv0Qj7lkVgyg6QzSRL5DW+VKw1bWPGpE5xymR1gFkHVc4wu7crji6/rmEPQFF22
 pW8jGZw0lzQbjUq1awyUUJFfL7b6Y2j662Z0Q8/ZfPp1ckWQ4sN3XiRmHwLdA0+S9gZrwd0BQw+
 jSQFsGt0kzKAIATc6vg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060180
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11C6CA0003
X-Stat-Signature: 4udtc7okyqmswukuz4zt7zc58zsasrrw
X-HE-Tag: 1786057055-725827
X-HE-Meta: U2FsdGVkX1+NxMNlMo4fNQrRWw49Dt9FYvyS0w+ofaSqD6fdQ9hz/BGBVXNVBxuqCWcILGBl6EX8QqcMDLn5mAh+Jtg4LHcYJkvKVpnON88KLqptQ7MtKtBhEiCAY6/nMbL/fMGt1046caoixnvJJpKcAMXrJ61l0xY949O4jbCLhCMI2Pfb5gcySMq77H+RRqFEv2FLzqNWMdYYGnZB+WvKFkLqkrMZ6apkOBOo5MiEHoW2Mkv9McCB6iSEV/Le4RX3bvDeKPxRnC94Rh1z/B8bz/jLhQM5uw5MgoLmlWm+VYY+WuBzQBkxYRjPpZro1YlfKjXeCCXOsTuIbcq/xnafgvrvKqQVWA1X5CUoSkYA6CUecANRPHxmRPW2rch7kVVpSIh6atfyRCAJ924MfAx4pvDei0Ep/GEqiy0GxX8crWmIC3AqjfvRQrfsUX7hbr3u3GeZAKSS5TTHF4PTm1be2MbOjxNVyFwO9P0C0LbkX6DFNO7NELNjSNclYF5CA6HbJt1OikQPW6YI1JK/syvk7f63i5Rqj9Xp3mIKF/AGR9mjWorHFhPbIPHdZ/J6ESWZaVVrq29LtBqPC8IC6pe+HZnnX3yLL/ARSu5e/jJ9/9XuK5zh0NF5TOcSzUE5C502UHrhn2NHBdAGycRB7WRrYlGgJejc8VcFQM2cfTF+J43sB+nItWiur/8OkdKYnYoVyYMjCw8+cO6xxwOL1ELeDrdcc14Ey8okIC4+/FKOyCPdQEqMMlFHErB+MLqePIf+BGmJwQ2i3brFR1+e+KNHCOzrl2abvoOAHVE9QKKNTW1r6g9pVXemfelpRaoHPgo0CWpWyFMIFoyUUy7Ied0pAxNED9atdOw/VMug44oKMRCJhhxoXtb7EvAi+4xorDJl2yMN5lus9mJ6xs8bfSNCmi0ME+g8stRcLmbzFdf6TDotNiDtj5r//d7k+2jX4CTtbXMSggk7ro+i7OO
 1y01aS5S
 ZMPgdXqrh2DGjktNzPAHhWhVEiG748D5Ewl3el9ftLWnsTY6CttP0NlEvcjn0uVFu8MUsFchI8HTaN3hw4hO6DJQaLyLwDBnSEIQxka1PNoS3MHUI3vfYlyySqD1hobfi6T58vT2+hfqbZdRDttJ3M08uCbL7QZE8YkLWEoSc10y5y1EKEmgOVf1v+92RgVrWs6AhAK36MWcwg6/sG346Zn3+z3r2+KvbGBiHijJEsvuqpX6bul3822pM7fjSpA1YrIvZeCfqNI0v/wyqOyOl0kbebKDq3QETqn32cAVuYEqLq3givoP518u5vggd+oVPdh4tUNlxNlTiWj5kM7nsGZoS2wk7lgMORzyQtIym1Y/zeEeQHm1e/z6zwJ7uFsjnF+l5hwAs6tj378A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert swap_write_end() and swap_fs_write_complete() to operate on
folios directly instead of going through the folio-compat page APIs.
This removes calls to end_page_writeback() and set_page_dirty(), and the
last caller of ClearPageReclaim(), saving two calls to compound_head()
per folio on the write error path.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..43b4383a4729 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -496,13 +496,13 @@ static void swap_write_end(struct swap_iocb *sio, bool failed)
 	int p;
 
 	for (p = 0; p < sio->nr_bvecs; p++) {
-		struct page *page = sio->bvecs[p].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[p]);
 
 		if (failed) {
-			set_page_dirty(page);
-			ClearPageReclaim(page);
+			folio_mark_dirty(folio);
+			folio_clear_reclaim(folio);
 		}
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 	}
 	mempool_free(sio, sio_pool);
 }
@@ -513,16 +513,16 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct page *page = sio->bvecs[0].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[0]);
 
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
-		 * buffers.  Mark the page dirty and avoid
+		 * buffers.  Mark the folio dirty and avoid
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(folio->swap));
 	}
 
 	swap_write_end(sio, failed);

-- 
2.39.5


