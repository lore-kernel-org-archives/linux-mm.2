Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F67606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=PKmEKf6k
Received: by kanga.kvack.org (Postfix)
	id C94476B05B2; Sat, 31 Oct 2026 06:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BA26B05B3; Sat, 31 Oct 2026 06:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80C66B05B4; Sat, 31 Oct 2026 06:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 898296B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 151D8A867B
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:33 +0000 (UTC)
X-FDA: 85382564946.27.1EDAE2A
Received: from outbound.st.icloud.com (st-2005b-snip4-3.eps.apple.com [57.103.79.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id 23012140002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PKmEKf6k;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.16 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QM+jLmU1TXXXeV05MNbrRo4VfZ263cK7rXlJYxa7fzo=;
	b=xvDgK3d8ZwVMFUmxS7Hh7oWPnE6wgEnNsXDFVygUpJnONywMOgRPzlabjyt6nGD0iMic2r
	EHCNK5dlz5q6F+/auyR0qF7NwHF+Bsyqh1JCrYw3xfX7e4vuKzbNtT55h0QdBKTEzelVCQ
	ZA1nE/sc73iKOl7UWecYA16tfbQAM4Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=PKmEKf6k;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.16 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442931;
	b=ShtBy5fOUPbVjKe/47tJRwOaPhQ+r3iPgaem6viaRKrPe/9fkPj9nU3OHveiO2BcL5aM/8
	dowp4J7XEfVeb7u95P4E6XJLIySLxUBLP+O+Y7uRhbph53Uy7fnL6vb8ecvQc7OIvzvGLR
	h4FhhU6uVXrwNYw/iLktpzMUBGgPSdI=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id B2E23180029E;
	Sat, 31 Oct 2026 10:35:25 +0000 (UTC)
X-ICL-RepId: 01a19187-4c19-7fe4-a57f-623863489c35
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UCQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442930; x=1824978930; bh=QM+jLmU1TXXXeV05MNbrRo4VfZ263cK7rXlJYxa7fzo=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=PKmEKf6kZLCCLiZqc70Tc9ZJfOJtkwkYM4iEswCgAuhCIyX1j86gcnITmdItxOOQZM7kSeUKKpOiiO0A/nmy3xiuiIP1vmh+AA3x4nrkS+i+1P/0t+IzPav85YdsotbUXO/S009FSOVWXSCT8k56v1RjIMNQf0UtDK2xcbxBQrOVZCsw54BdDYy3EIxZPYTi/byQDtBo099F0WYVEv0sasuuhVIgscAGnXNORGWZJpQW/ZABl+sg1ks4Vx/a/nO/00gH/ieM6rnCYEu0ZpJjHe05OdfUAJFW+O4wSHDkfK5QWxT4kqzgqS1CQJtZZP3FbeT5cYaUAlX2vx2izRXqNw==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 0BBD81800344;
	Sat, 31 Oct 2026 10:35:17 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sat, 31 Oct 2026 18:35:08 +0800
Subject: [PATCH v6 1/5] mm/vmscan: introduce folio_activate_locked() helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-batch-tlb-flush-v6-1-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfX8mYasr9KAWLJ
 V8d2VvTGOx9DlifFp6fHHxixCEQFOdgglKmJzj09zO1z0Ow4MRwGP9jCSpXG1b+iGeQ63QWya0T
 I775V3sj91jyWMGSE+PCK/rp2kR2lcnwCqAz2mp5bDKAM8mIuo98k3cbDYO9qJw59C91prEoR5a
 mQPhlgGt0rOsapZFMSS5N9PPGqHpAuUWNVpvKG8eUEcPXp/jFQPALobMviOMk/kRyjz1r4jp9+t
 gnw6LuKIJi80qUZkg+pkwupzg+hjiE8QTnkgG8ldZuY62dZNDqy6A5N92E8PoOAm0R4pWoJ62OP
 9gd6pIxaF5/a4VOrE+rZIeBdXfIf6b8x3qCIY1mk3mn5sKHbZ6WC+fkU6us5lA=
X-Authority-Info-Out: v=2.4 cv=e74LiKp/ c=1 sm=1 tr=0 ts=6ae5c470
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=SVDCxekAgo2Xo8Fb88MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: C6dZN2IwETpoDkRQO5cHXGBuFJNXMSc0
X-Proofpoint-ORIG-GUID: C6dZN2IwETpoDkRQO5cHXGBuFJNXMSc0
X-JNJ: AAAAAAABfsFAKmuRBLed/+ov4tC5LBUIvKKpZVubtD9IDhzyAXDN1P5hNi+Bi5atzou4Vg
 rkqJaoeCXN3h9iJvYgcYS+4NlsbwX+3m6Q29hNiFvjmvbZgXhcR1Ydhcq2eKrZL7BteXN1
 fIrLsolRT0FyIY32CM0Jaybnxltnlcoveh4nXKbgJs27e7S0SzVOdchWjSAaO/5XXFC3AM
 uzyz+nA8vEtAOdHjt2MnrnIgcg4BowrCCXbPsHfHiImqaVCliaHVHRmau59l8qFJ5G4bL8
 phprEP0/WD36kNuT6mpkaBuqbbmKaWt2JCySOohNM26P/1mHDp1AQVvWikmP2crhc2BfmR
 MTd57Ui6hMuPyNOi22hMm2I5/gjim4C7zlN2ZCxFuPbMMR1ih5vMpPyd32MWMACG1A6g/a
 o+TBR6pD72ki+gnu1wHNDPrH8kWspCXaSKB0m6aiux1XqdeL+9Hetr2nY3rjg4Cb7z7KwY
 9RQJqgxXaZ0n1wczp7+98SyZiwus9xzh3wALKi+dwxvvgJmF0DWXK977ftzcdShO9fh4jk
 EUSLwn52uNkwWi8vZiwNY1cr2vXQTUeTqhi0unxva/E5fH76339PvgyM7xLNHbelrkgrQa
 qrcrM77TWQNx+KK/8mVAssyYRFRnZnqoEdNx9jsFnwCOarDFAPbpd/2PIE73ILGXX+3Wha
 YCL7nEPirRTGd7kz61+EoGOIasedvzjfFSDSMhcRiGksFeU8nJipEOWsdUR+4hE6H/oi4s
 X5V5jS/vYGwjfI3iZ2ZwiuWd8hK90KfbyW/bmxFZ+WXzeHRbnu+5rhvX03TlJs+Q7oI7Yj
 SsfP2TwQb8zrcfuI82VnLFu24Qgakuye3TSuCmP/9W95BDcDs4kG7oYwBPr30nLS432sIS
 izkZXyJoKaBmkfAPPoPlcOkRcm2Plkl76iWsqQPrC/VT3vQsmGVW3L0AUhB8702XVpPeYr
 xdvzqO5y
X-Rspamd-Queue-Id: 23012140002
X-Stat-Signature: btixuiq53675km7xt3j8h6bj4gnmjnk5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793442930-325314
X-HE-Meta: U2FsdGVkX1+zFNB21g9hvRPPKc4dkkpo7kN4JjK0mzW8zZbwXT5+TX1S65Xk18l3AchFrSrgRX9pjvTRGP1qgOQOc1ME84sJQb9Hyhc26ze/atrNKAACCrhOBES0sJnUKE6HPp5124lSQERLBpIAWWhu954/Lz94JG7NPZZiffmIl+vGKu9/55uCxJyoQSrqPr2BWl/VB1gjoYbcVPYk+y2FOjVJL6mpg/YmeSfU2BSCGKHYdbyQYI9aiXu58eQ26ee1IdM9sH7CDKethEzDOOACVPhxhKP3WMB1lAnpdDvVCWjYFUshgOtcvLVO19suBIX6MUovgiBarVbC1Xe3+PvNs7xUtcyaxog6Fp636rEE8lZRPahio5vEJne7+jrQw68C41mZ+uh7NMWFdrJy1xpTf3BVSAbp2BLlWDZEA3R83bXvvtKij85ooHoae2S7bTiNo5McCPIRxTQPQa4w7NWFSYq2Mk/2KAC1icFZdKIQFSXhhPgyYUx/SeYa6EsivJLyMXpfy/RgalpR4OkR0tCF/FUqQhgiizrbmZbzpicZ3kU3PrGpIV8bp5m28gH45lLQplktCS7sDBjmXmUCqbD80Biql+UfRx+nb3yVJt6VSKP/OWJZgPqhnWcx19e4cX6Rc1LMex8t680OC8CzT6VyVv5v/WJ2yNM883zxfL3Jzsa6p82UsCCwH0fPD6i38hc2WKZwg0bVpURAn2lYIRFnp1+Gzhoaz+Q2f8qhe8mhRcFqtp0Hba1YcoxMnA9LxbFRW1aWEe6D5XQZRmXiBa7klg2UqxFaUmsDxJ8iaKZ29k+28l50lgk9FFSPg5eSpPjhQ4U6nUvZmYCtAcJivJz+f+SYxDFXG65Hn5s0MbZw0NmN1UQ+i4W2aBqiASDTrHqZIM43IKn15gM+RGy4svMJ25gANKMu6K7JeKqxCz70anKcHLB/xlfLUwSkJ/Mu4qRfCYcKXntCuQi+YyA
 MQ8OG/Se
 kDN2cDcFWWJ/dZb+ekozOa8xvJJrhJe4/q/A0dnQfuRjf2wkutda+kkv/4zQmdQN4OKvsXDCUT4084a8T7u/z3rf9+avwLlLXbrvYGkVJhOE3Y+XjiyRoXXGoTd4EMYqqpL9Vgb+OeI5DRVrY6CzADMTax6RR86NeYIiLjwB32hbfIqfw4VRXGPhMSIjR1Yp8U/KvPFYgvv+eyuhQ1Ellb9W6I4kD3wwyxd/jQkfS9zKnHicJ0bzTDgdQvyDUn24Ev+v1RQiT4KKxywBzq4xOApWDuIaTZtx5M3Y+nYwt4Ov3fBvLHywzZ2IAR+iNwFSk3VnrESgK1bkK19RfRZtYg/CdhwPa7wMJpcbRwhQGJtw4SDoyv5/aCYe0JIGUSqGmHXtfmin4K9F3n8LPEs6qLZ8dZQES8SPnpqmH3uoqhZm+28sEo8iQNDQfqQiCmJuma+BVpNf+7QmZ/Js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhang Peng <bruzzhang@tencent.com>

The activate_locked label in shrink_folio_list() reclaims swap cache
when needed, marks the folio active, and updates activation statistics.
Extract this block into folio_activate_locked() so it can be reused.

Replace the active-folio BUG with a warning so a bad caller is reported
without taking down the system. Otherwise, there is no functional change.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fb9f8f020f63..54f6a9e62715 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1155,6 +1155,28 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return false;
 }
 
+/* Activate an isolated, locked folio and account the activation. */
+static void folio_activate_locked(struct folio *folio,
+		struct reclaim_stat *stat)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
+
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+	    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		folio_free_swap(folio);
+	if (!folio_test_mlocked(folio)) {
+		int type = folio_is_file_lru(folio);
+
+		folio_set_active(folio);
+		stat->nr_activate[type] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1623,24 +1645,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 activate_locked_split:
 		/*
 		 * The tail pages that are failed to add into swap cache
-		 * reach here.  Fixup nr_scanned and nr_pages.
+		 * reach here.  Fixup nr_scanned.
 		 */
-		if (nr_pages > 1) {
+		if (nr_pages > 1)
 			sc->nr_scanned -= (nr_pages - 1);
-			nr_pages = 1;
-		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
-		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
-			folio_free_swap(folio);
-		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
-		if (!folio_test_mlocked(folio)) {
-			int type = folio_is_file_lru(folio);
-			folio_set_active(folio);
-			stat->nr_activate[type] += nr_pages;
-			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
-		}
+		folio_activate_locked(folio, stat);
 keep_locked:
 		folio_unlock(folio);
 keep:

-- 
2.56.0


