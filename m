Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F256DC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8766B0088; Sat,  5 Sep 2026 15:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879EE6B008A; Sat,  5 Sep 2026 15:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741CD6B008C; Sat,  5 Sep 2026 15:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0796B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:09:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD170803CE
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:09:15 +0000 (UTC)
X-FDA: 85180646670.20.ECAC752
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22794100003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:09:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cU8KeX+C;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xL15hCog;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788635353;
	b=CTXMVOpaLYaVPRDPjt0NRlU4JvmpfuG8cG6ZhHv6sB/k8dVIgqfgqPijmdNwYvGZ5MFkSV
	IGYTdTHVp+bRuRls4bReuF7nFRQxdthR8lDarvpiiUxP9pztNO1T7DYkNiidbYtr2mdeYn
	ONmtPprajNGI+qTbV6ZUwT+o8iY3L2U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cU8KeX+C;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xL15hCog;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788635353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yyIKW12sRrjzxO+EKvuTJeau7Qh7or2NRAOG3WxPlUE=;
	b=mYNptufXDyhrm+5U2Nuoqq0PWlKLNDlSP9QK4D81wzQ/IhcNBQYw0IZHCz2vRmlqj/kDTk
	E+1o2dwe3rgVHVrvsz08jH0w8dJf8xVAb8MSq9DTHuU4TkqoVE3Bp7TUA9low8RNpIISRH
	NMM//K8RlXiItp3XsC2dNTHoUnfrDM0=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685IbTEh1453363
	for <linux-mm@kvack.org>; Sat, 5 Sep 2026 15:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=yyIKW12sRrjzxO+EKvuTJeau7Q
	h7or2NRAOG3WxPlUE=; b=cU8KeX+CeDIvN534906XHmtkNJ4dKtEhmrGjehb62u
	tuWdywOhD0liFvdq3bhk+HWMXnof8kSBoDHs59mJN1HwiVPLsjkuqJmZ+/XwtcE0
	++C6tlm8opJ3M10klwV/KCJu6JwFgSHm8AtM9EKH+03FnWzrunRiBU+kbtde8Oeh
	kPL/bBcS2yCqDyhLa/OX2Z8EfTYcCs04NZYkKBB5+v1+XQU4v18BoEm2gqx4NGyU
	5UbLXDej5+62/BpNR3fl6twAnA7aVKvgdZg+4pSTN+xy7bmVLiDhsUfkNdeLOx7K
	u7A+DN+jPaKY7KD9MiK82+p2HNaRH5wZp8cCOHD5x/gA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ggcntat53-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 05 Sep 2026 15:09:11 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-939281526e1so159423085a.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 12:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788635351; x=1789240151; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yyIKW12sRrjzxO+EKvuTJeau7Qh7or2NRAOG3WxPlUE=;
        b=xL15hCogHFQXRR4MXK1p+NEZOvKLF7WUAv+6ezGEMjgSAP0gRigsjrf02fA7qxLQJF
         VFYOmKctWpILrnxsdowVWZY22DvyFjpuohLB22VHkndLj7tKLnUYUnNtmMivI3ZXIvUT
         txIQt8eDPBpuTrzuXipNtVj1LMkg3yaka8y0Y/mQ3euY5tM4RHNz0BkuDyCcblD0qV7d
         LsqAFc0tQvrnb4dTsxA3g9ghGxe6l8wc6Ct9Q4SDr5laqvjYYFttHgYczgl3pR3uTR/w
         dG9wGxtXJryLwiaRNLUsDerd7L79PQlR2H8ix6AG1jQK3k9zVZwVzgMoxsXq0RuMjh0u
         Y+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788635351; x=1789240151;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yyIKW12sRrjzxO+EKvuTJeau7Qh7or2NRAOG3WxPlUE=;
        b=WT3S97o2lEvOLonb2MIwF4xPfpUhXZipgCeFeQiJvOFGZncZVHRiDgwuH8jhZBBZrI
         2RRmMTI7VVr+iEflwjskud7GGu/mhgRlKLcBGXkEnlFUwlBHxxSz0p53BBKmBU8L+XqI
         Nfp0wTqaW2/wC/f6a4q1YwHS+Nnnc66zo8Ls3cOdaZ+pgUIMO4qMe2AP5DrRk7Mk+d4x
         RJut6qcgFfAdvNxKEY1uCkCRaIdRHWgZ6Q5CPDEumDRMGokZAFUvOHcgHQm7ywVDUavb
         f0GNXu2sQXxJltGJPcAONPNyoKi5tao5PVjfmwoEXk2pIcKrui/47lHCBawpCXeR7q2v
         EwiQ==
X-Gm-Message-State: AFuF++kdifpNpkP6jh1lo5GbEVAPThPwnfu7Y8LNdfIvautOlr0BVArk
	xW1NqGrx8YLxy04wg6kj+CO4H0XJj3FXV4ZmRHSXhdFssDLJnoWD2XuTbB/C4KDkv8m29iaZXia
	rgpnEIRoI9LRvZ1KOxEgEglnVGe/5fK8fQMlZlWGq+HHhF8EM
X-Gm-Gg: AYBFou0XpeSe4JcKwm+pWQJWjMunuzGmwOUXlVT2TdkY1TVVJvzgzDwYHQdpkmodlWc
	tG+QFh5j/RQ6fKXdiNGW6+HFc03OKye5d36ROb0oadCKUjlSausk7E6/klBriMky0eWmN6s3AeX
	pndp17+snofXlWBJFQxcjVcgmw+ywHZyWbe3h8RkL6lCaLhYNbTVJi9zhJz8ErKeonWBPQHYFH2
	UnZXD0/vk6WeaTdezWC/p0vlwCPfMkcpLsPD/srmzZHL5v380kEkOQGMl0uyyi+jsaBuFCRwkJg
	5vGQ2TaSWpRFK1GQTHuGGgjNKtQoBUhzQyWYjV3802uefwpwbifSggTf8jSCXDb9gXbo/wWX5x/
	KN7+l4lVxuSOaDcUCybnZOXSnpQC8eDLFb813clRgvHyM5a7RTdc=
X-Received: by 2002:a05:620a:27c5:b0:936:cd74:4f45 with SMTP id af79cd13be357-93980538f1cmr1288600585a.37.1788635351188;
        Sat, 05 Sep 2026 12:09:11 -0700 (PDT)
X-Received: by 2002:a05:620a:27c5:b0:936:cd74:4f45 with SMTP id af79cd13be357-93980538f1cmr1288595985a.37.1788635350558;
        Sat, 05 Sep 2026 12:09:10 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-57.net.columbia.edu. [128.59.179.57])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397f9ee9fbsm503659285a.1.2026.09.05.12.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 12:09:10 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 05 Sep 2026 15:08:30 -0400
Subject: [PATCH] mm: remove PageWriteback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAK1onGoC/yXMQQ6CMBBG4auQWdukViCpVzEupuUHRyOQKQIJ4
 e5UXX6L9zZKUEGia7GRYpYkQ59xPhUUH9x3MNJkk7Outt6WRvEeZpiROywqEwLHl6l945ircAE
 85XRUtLL+trf73+kTnojT90X7fgC0TKzPeAAAAA==
X-Change-ID: 20260904-remove-pagewriteback-69d2aa5b3ee9
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788635349; l=1311;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Knzv4nLdf0CUhDUXi+3uKsDl+EcnYVChUNre7uBmQOk=;
 b=eSGJ7KvLBuBnBC9GvLvaZ45PuNk7Tw6MDSd+SKqd40OqhXVY2UdADAnpZcwBTqAFfH1PJfje3
 4D+ts/JGrQ4BLGyJvAQoSROOEECXYnmRgGITfyuMI4bvE/bkvMKiI44
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDIxMyBTYWx0ZWRfX+ap9fZhVOHDj
 vIW5g81ScCOZnww0PePjDJqCTBmt03WQft3T/zNNK9bcCbQra5glbN4awOymrY37yUaVpyD7EKp
 VnRjGswpkUmTzRtoldXv/8ryIj1hNXGNMlOLBn4EYkb5fEcIwJdW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIxMyBTYWx0ZWRfX7gBm2fBI8NF4
 Qq/36NPxYbj00ydAYL8Otpd0feQJtE3ar8shdxUwy3nvKXXNZHNCweAh9GRwR2bL+1y6LHRmz3+
 i1JHvZzQ+Q9uHdqDjluf7AIIQurbxDmFYrCU44paELfbmBZHROurDJzhtb9qFZdbPQ36hWot4dq
 l6myszRSbzdCjVTH85T1DVk18fAsglcQaBv2OV/OFOzlRIdLwbYhvV/4GAAmCNNF7xSsvAaGWu5
 PSMNwPG5gfhUMNhR8VeJQ++5PG9KDE/Su9DDTgTVFDS8F/3UhiVIlKCTogcYI7Kg+/gDOrWi2gz
 fxQ08jkWM6iSMAG6OJ5N0LesKFvUNk2amXNPzVvGEB6qhU1DvvzR+EWBbui90IrN8rYDRh2Zbyb
 73LC3VLDPyLL5BFuWPJ2vy+imEi7tAOxN/PFY0TrgrFeXOFfKC9suEMA/TGYjNHJgOkJUsUWyvA
 Fy7hHpi4B2GMa2kAnOA==
X-Proofpoint-GUID: yOBY8395Nt1lAqrNeZpfmYi_LJ4CbjDW
X-Proofpoint-ORIG-GUID: yOBY8395Nt1lAqrNeZpfmYi_LJ4CbjDW
X-Authority-Analysis: v=2.4 cv=CNgamxrD c=1 sm=1 tr=0 ts=6a9c68d7 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=Qh9WKzuy3vK2roC+qB/eOQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=Z08UwzbLghVimfrVTBAA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11897
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 malwarescore=0 spamscore=0
 bulkscore=10 phishscore=0 impostorscore=10 adultscore=0 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609050213
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22794100003
X-Stat-Signature: edh5jokpa74frgxpepmbxixzxjhzjmr1
X-Rspam-User: 
X-HE-Tag: 1788635352-895388
X-HE-Meta: U2FsdGVkX1+g1nXXdPY6622wgvZGV/ekQvtv2gCcDlvUawjCQ6DwR9+pn0VVeomV1XgClyJ2bcImZ1S62vT26o+Whxs11v7z7F7YBOFEEw0kyULDPzk865d8tYKUTp5ezHCZZCxFNkZ2KW27R5QjhpGWBadb5zptMFtpsx/1Nw6J+d086Sg0jj+IoA++eDZGVJtwj5hVEpTlmqkH7SttPka15lwvUIa8LHzZb6VhoO/oMOH8D6PCclZwNijuDp5RfYbpY3mLjRVOydaEKV6pzrl/L7a8hzekth/eWNFpEeAziVl+bfrvt29452pVZZkPgf+T3HnbNYMrN7h886V7Zm6WCUzxHvb5t8aa+c1WjanFunSXwQfWK//Tw119G8jxzq9gmjV5Njnbmj2R4PPBJSAQBh0g0Seo6vLRAoa9bvRfpWmi9/vI9ZRoPTfR5mRQMSKY467p53tcONHRdwBIE5Kbx69h9stewd5MMht9rmrLUUv0FWAO3uShcfgRpRhxV9fs+euwvzrYbFyJ8Ve5EIuw5+r/PY/3+kwyBlIy2vm3Q/APHwMauOw95mWKSIwazP7Jad1NWfTHne063XSl4Pxvrz8MrompBLdIDQCldSnDu9pdBAjYwV0XvwMjTzVtBP6cJ/7b/OJduSWx8455pz1Laj+pjjUopwZzi15upBLEp7s1rBGMGnMQ8zxhxPes94oQPSofwUO+XpuaNqNhs39uOExef8+uYkOrEFKeHQnSj9Fhg+5MnSqlwPxaWd6lM1SywPVvA5PzKTs6yMkUOdfZH7/smyDTHni2RZd/jUox6sS5CDNqJgy8KJgx6UgPt2D5U0Y7mUuTNkBxl2RFB9FnqXJ4pgDap8OkFG420zp26NFfY3f0q+Bx9fTUzWcFvJ94SpWjAFSxs5E4PxYXdH5IdynF4WYGZviCTYDz0ErshvhWmZ2j0J6joWNwgnUWSHV5+l0WVnXWKfsPLlC
 AreA+JLX
 sY9cGj6eC0iQPnM+UbD3q3cpBqU/w0MnJ9xXql1h0UBa0cJaLaN3XGFp++GdtpAzzlYKLvxS/Kh19iNkOLIdb5aPZBpx5ppq7UaXUid2tpirV1yedtb7wIeDvy1Sn6YP9NWoXPHNHvnhD77wlqtA4/TEvySx6oCm5zceqce7KdaGBw/BsK1VV3CCvwrrsZ2ldTWczRG100TnBHpM/YmQqu266zhEHSGsaapjPcueFrVVF2zoaYHFmqMuWO9B2vsCQGrqLWHD9L7WCwG5nh+vue2+sHjt6BqWoO8kqo7UtxAjRkmAIeVA6gGXi/cnBfKMfbehxmTZNEtPxoY1yWGQ2Yana+1NOWv71xUzc8OD3dStYwokOajgGjl21OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller of PageWriteback() was removed in commit f75987e543c2
("libceph: remove pinning assertion in ceph_msg_data_iter_next()").
This flag is now only used on folios, so we can remove all the page
accessors. folio_test_clear_writeback() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page-flags.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 3dc79c0c5adf..86dd0470da11 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -588,8 +588,8 @@ FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
  */
-TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
-	TESTSCFLAG(Writeback, writeback, PF_NO_TAIL)
+FOLIO_TEST_FLAG(writeback, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_SET_FLAG(writeback, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */

---
base-commit: b733fe31e781ed45c56d2ec561dbb61a903693c8
change-id: 20260904-remove-pagewriteback-69d2aa5b3ee9

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


