Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87C8606A887
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=kttlQ8SJ
Received: by kanga.kvack.org (Postfix)
	id 9A8B26B00EF; Mon, 16 Nov 2026 21:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959246B05B0; Mon, 16 Nov 2026 21:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84AB96B05B3; Mon, 16 Nov 2026 21:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEDE6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:59:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A5CAA02FB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:59:25 +0000 (UTC)
X-FDA: 85443105090.14.BA3EF60
Received: from outbound.st.icloud.com (st-2003l-snip4-5.eps.apple.com [57.103.77.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F81A40007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:59:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=kttlQ8SJ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf12.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.77.186 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794884363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tpP/9ykze2yQgtX589hLaB/y2/t7gDNGvWd4Bq6PVDQ=;
	b=CjQ4r9RWnKEPevE8d2c7LMFM40sVqBYJFvrf/8tw9LtiUnEjlHJkhlK46iBqRfYgfyLlGq
	YzV7l0Gwu6jQ3vgKsCySmYWNcFPM1dmQbD5+F90Ra0Vojq9XOQebZXLNwHDg6Dz80wzdjq
	sHkP38i6YigOkKTsITRfEMys3wRxoeI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794884363;
	b=ado0TXoBOv371saQdXiNnOQ/kavrk+PCWz3HNzeiIXBrGGwhyG+uE1Zab2+rArcUviV0pW
	qTFWqH9QGDJiRAl66fUbycd4Fclz5LriiSFOoTVWKoO3n6tOJ538TAcylXCNn1SQzuXPzH
	//Qoj898rtSQ1N26Cz2oEpZSlsqVzKY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=kttlQ8SJ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf12.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.77.186 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPS id 107BC180012C;
	Tue, 17 Nov 2026 02:59:16 +0000 (UTC)
X-ICL-RepId: 01a1e771-cb79-750d-8e4d-6fc5792d1dc9
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794884359; x=1826420359; bh=tpP/9ykze2yQgtX589hLaB/y2/t7gDNGvWd4Bq6PVDQ=; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:x-icloud-hme; b=kttlQ8SJHdu/IFhU98cq+x2zZC/Fyw4BTxbPpDUnJBESkMESAtqWoHyapLfzofrrMzCv/mO0DNa3Hz/HgC8Aq38Z3vmrVSyLO6Wwe8z3LmXnrrTjq7nxH2HongMk/MUF5oRXSSLEf8pChHfEbJRHo7cfPFywG2WoJwQtDG4w2DuTjLqN0rYFkiTjvnck9bZ2T4qSZ+kWG+6cqROdh75AsP8igVxQbybQgOEF51W3AHnJs7cdj3gXI4aphHoqLCERGX3hK+9vWKHf0qwDupQYSy/NxdO84F74MuAezd6FzgcAiyTDX0A022KN4cfnPwj/OameZ68jbNuULzeSLyb4EA==
Received: from [100.126.217.91] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPSA id 69450180012A;
	Tue, 17 Nov 2026 02:59:11 +0000 (UTC)
From: Muhammad Haris Awan <m.harisawan@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH] mm/vmscan: respect can_reclaim_anon_pages() in MGLRU get_swappiness()
Date: Tue, 17 Nov 2026 07:59:02 +0500
Message-ID: <179488434239.3564555.16227252580122398690@icloud.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDAxMSBTYWx0ZWRfX7SaBbDbCWNER
 0YkbbOlt7wBXFAcURAhC/DjrpRrS7Rf+Al32qeUpDpwdjTdsI8b2xwM7bWFqRc64sP8ktOrCllT
 gmEk80w727KGXD9+k/nvYYEOIOEB8pm8igFU1v0u03g9jMqt0gOehh4vbX64RRlLKT94sAYugeq
 5Zg5yvLTWFLJvCaGbgyQoF/yeLIgQKPEbThcpM1JYAuEPWGvrpPxtfdWqVyEFJwdyL+symKml0j
 9osHrYgiIQZS1V7URAYDfLGWaPVhMHzjoJAZaZMkycHqV9VNrtoo4nf/wiIJIc2hxVD1YjPdmkP
 uUsorlNXwbNO+r6u9h9d2b2ihDrzBGeH0hQhbPNuWLUs6e94SGsxYfFIOpEt/0=
X-Proofpoint-ORIG-GUID: 2kbiXhfF3ykzIRkWNzuzrHRwTotlbSw4
X-Authority-Info-Out: v=2.4 cv=C4Z8WgP+ c=1 sm=1 tr=0 ts=6afbc306
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=2kFROKt5_e8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EYaFdmsEC1CjpenOt5ir:22 a=ieB-HjlS9-5fP-wcyLUk:22 a=v3ZZPjhaAAAA:8
 a=pGK3NKez1_T4NQe4MgUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDAxMSBTYWx0ZWRfXyRYQk7FP5Cxg
 laGk+FIvKC0JA5D01fX9z09T2OSBLUbkBp23WNpr1bwDz7MMRe/qZfZdvnt3dOwX336MYkUweHB
 PBJK2pgQv5pv3Gx0oP7LuDq6RUZZwgg=
X-Proofpoint-GUID: 2kbiXhfF3ykzIRkWNzuzrHRwTotlbSw4
X-JNJ: AAAAAAABKX7+l7z00Xgf6XDZJJmtdf1hXyiTKcPoZ6Pb1Ih72AiU8hINMGwHN8jiSm1SX4
 VMB08z17KH6WVTM7E9Gq/SzNyph/yLn2hXBseGs9ZiqE05qfyI/1k2XWXdkCezxgD6vSAw
 SqkASoQH5G6gyu65J0GMzN8N93OhhclyrincYok3b46CPSgLAJ2CetS2jja2gVt90HtTUg
 gGowHO6yWTQc+1gtwZHcd008AG/tcRLdIZnX869YCDDOvGdIs7P29qASGdsEgCXGyyVxeP
 XT4JCfQ1RpuRv1Oln58mf2uz8yIIMTH1sbwl7IKieJu7Qum3nbwMvWtLRaUxc/q7Z04Y7e
 I9+14HxtksNNkDwyEm0V0dTGIDBpuxIjIbYRtZdo3FJms1z01mExV0uZJdchhcF3j/R7Le
 FSkK1XU0rbt6Cm6NuaqKuppY57cIf/QddYkEaUlS0I2oMaZbp3JNGPJy0r81vPGw/YLwuu
 srGA2Mk0PfDp/pmaKDoQIPyZ/mxMUWdVjsm0U1pr/V6BadgEbaAn4E898zYc5LkuUAbvre
 rhblZn7k2GQFMwtUUsHpHvzhx7+bPnIJpBk6fB9p+jTkgm3/Bkc6MyPoSSZDgW4seawUz6
 wj2OsHqe+LE5sWzNd6hOwQxdzEcE1Z5ooK0Vz4oS3F1SJOqVEbzRtsPTk1MyJeZ4lILCDJ
 Hgg3heczHnc0gs5KfL7QoqkhrlP6zasA2PaPLVEsXuqrX1dyM/3uWdAqqxebauXoxT3DGu
 pGAzqwAX1NXL+2W6XWkYGbnmyXje5Nfo2JYHxpe3qNooRnzQIfY4fsFeiK8/nQzHR4/olK
 sRS15vH51xs2szAihEOIuWHj08bM+ZvaplrSXYsg0FCsq6FYW6z9nMNX7FJ70TPEYVlcRE
 NSXRNbWFTnRC4Xz06vx+81BNH01iqMnayxR0IEusXYxTArekSLgPigTYHbfWvyK2cAELt5
 k/o+JfdX3WCry0A1N8a8USHWFV5E++C5yT3HgVx5Np7/UIBt52Hd+9bmq7PZAhljH/s1Z3
 uBG8fD7okrsCEJ6R0ZtpxWHG/kYuVZA228hHq9v2jsiq6fChAMuazevJJJQPHxNVJ6otsz
 yw0+DFmve9ea6EHPP/tpCXRywjz7aPjnX17KWeMCPJmS0RaWoffnOW8WdnLjZJn8ZaPlb7
 Lc8D+Ko9IodS+dzvvDZRpj4vP2fLMi/GJOflYFpMcFUUfoKFda2d3o+VRE3EEWdGYocFvt
 tnBg5292fv/S5n+6482JP/p1fea8C1NSq6wBkfQgD+mjtsreGQyIcxvdq09jweQIBf+m0R
 rwcu5k/PyBkxPcwjZNjOfcSnNCqVMcBh9d7F1d3u8uke/+OAnqDd1GPxh37k59xzlEPPMl
 XjzqmG2LpVDUp5H3O4nQFrAt+AY80TG9dWAywIJWhjlERrssE8WFSUELQd5YGsslPu0T7C
 btnmsmiFvSwzk=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F81A40007
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dmf9ibwe6ju6qw5879modw5xxspg49pt
X-Rspam-User: 
X-HE-Tag: 1794884363-725040
X-HE-Meta: U2FsdGVkX1+wYdlmraHzUYEDmyNgNHkpwcYQBmoEmzFIXsy80TcVfhDr3yLr4hIQNZJA43xcIOuxkH/zgD6iWieSvhel4GY5cK6SJuuQWdKDCLu7KJroaoNZk1eu37iCpipz9dY+hezsBV+PwH7Hh1JSiEyPvo2aQmBOS0sDBrfaW4rBTd0+aoFj3Yla+LMvjyafqss5qE7jS2VnBolKoIFcvNysRNQ/MYjSgbsLBV4RflpG4tWUJwZyOpgva2sFSw1AabdOfTme5h85hTVWK8HuhELZ29kWwnilMHLy5aNHoLbuSOQMU9neE6r/I11h/EbAy89vb3PARwdSYHde3oum4oBG2j4tMJ/SIH+kYyN8ecK8/ooeLMBkWjM+HF5N5z19IKrs663tsoBdbRs6aCDOrM3OllNKADgMuNBI3sF1TFad/RK0DjHpc1W84BY4/JuAAzdPe05RJzLabwjepc8BcJXySyZbwd2LJfzkzcPaUJRN8i0zlIi+JarY0XqWywFl3lsE8aNADZdObipaUIW/8RLxOYUhdfpgoktwSiXoDZciHO+nrFLhzPhhFWLOhsYhqDqCT37nR2iXvuIAnDoa8V9Gv2HXFGA9cAydm6Hneo66LV0IsCnGet+y8Zf6Iav9EjUdB8Bdzchl63LU5W052YPLfumV4ukrhPplEDcyvEyIdABn06ha2mHOU7pEVHcGy+paClrS1rtvKf5DtQrjts17TJYQX9Sp8t/IVtWJn+GWsETJkOkKmz/S31UwjyJLQmK7JYf5Uj7lAZCElrleYfFAvT7bdVi5uY4vvjlWb+06fVXpc9HDYJJHsSm4N/cxhEnf4FHwTx5SeLsvjQLqHpLs+oeMZ66X9xLIurrlcgLZ3z2Nn/v9+n2Chw1p+jZ0XXiwXsem9VIVP8foce5xGGEB+uji5ae+ucghrZmiLg8qal5Myn5+iYcSXc75SLZFvlYlu3ui/1R72gw
 uHx6yNTq
 6JqcGVRnUve75SJsQb4+j9gAOiNWJvHnPpQaD0AL/D+NSHkNAG4SWQ64uU2UdUHvKLNdFufsfDaGyceLtuYlQapZuDlv5PH1YQtXpwUvAFvilKvcI3HsW2gO7c4XtxuGQaV/GU6Jz+0/oGGpuoFj0awIm64Kqb3dhnnCHdQP3H1Tpdiug7oNpizC442Ax1Aj2zbFpGUDT5lara6OH8j6HOu/9Yvd2wmcX/u6/+WMZPG009oUUUxOiMN6V7Brm+2VGgXy48wUlFmykwiGfnMCmUednm77mHdgkE5Mj1n06fsGhNw0RJC5f5t21l/ukRLHA/6LtfM0+uzlOgQR7KheSofemlvpTiZc1PPG606+kiXXY7duAqyD5q38qGjuBujNIRBIEeIasrBGFWwoYWbdgofXpcy4LeTTISo+w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Under GFP_NOIO reclaim, reclaimers cannot add anonymous folios to the
swapcache and can only reclaim anon folios that are already in the
swapcache (or demotable). Traditional LRU avoids scanning anon when
swapcache < (anon_pages >> 6) via reclaimable_anon_is_low(), but MGLRU
explicitly skipped this check because get_swappiness() did not consult
can_reclaim_anon_pages().

Call can_reclaim_anon_pages() from get_swappiness() and remove the
lru_gen_enabled() bypass from reclaimable_anon_is_low(). When anon
pages are not reclaimable (e.g., GFP_NOIO with low swapcache and no
demotion target), get_swappiness() now returns 0, restricting MGLRU
eviction, aging, and fallback isolation to LRU_GEN_FILE only.

Signed-off-by: Muhammad Haris Awan <m.harisawan@icloud.com>
---
 mm/vmscan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92..f5fa67985 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -2893,6 +2886,9 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 	if (!sc->may_swap)
 		return 0;
 
+	if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
+		return 0;
+
 	if (!can_demote(pgdat->node_id, sc, memcg) &&
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
 		return 0;
-- 
2.56.0


