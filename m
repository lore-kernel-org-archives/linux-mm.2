Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01530C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CF36B0092; Sun,  2 Aug 2026 12:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AF56B0093; Sun,  2 Aug 2026 12:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6806B0095; Sun,  2 Aug 2026 12:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD936B0092
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:53:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80C0AC0528
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:40 +0000 (UTC)
X-FDA: 85056925800.08.3CE5CAC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 01B15A000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VJFCRnFc;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785689618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzSqCN2ouqH/79hGb/FloWxsYWLiwWNlCW+sts7/z0Y=;
	b=UghJUCJry+HS3Y5OLfBQQhB9Lk85ffvXwijede2fZ4HVoRwn5kgwXs5WtuUzzjJHp+z9pU
	in14Ewsajfi8iBfnvfQASPTbotiaTBKV9nQ1l01zjzq7LCIVgaoxhcL1Y8GflaoYBOA9ji
	z+lQ1FgvZLdEPh2AvZkl1F9EUt97p6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785689618;
	b=o4HxSyeriUnn5RUIzEmUS3HN0as6Y0rGwtX4SStPjssVgC/YOzu0AEmlU6ST5mGk48xD0X
	xIGmBjnlkrYQ1k7RlLNANs5F+l6jUqe8AGdJBKjukbqtUp/vxCwUgrg+jT/HGDMQf6knvp
	EG7agWh9R6po/BGnlM8Jh1JQ5CCW1Ag=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VJFCRnFc;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672CZFF43464499
	for <linux-mm@kvack.org>; Sun, 2 Aug 2026 12:53:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=bzSq
	CN2ouqH/79hGb/FloWxsYWLiwWNlCW+sts7/z0Y=; b=VJFCRnFcbNLUu8cH58YJ
	s7DAqqc6gSH+kjyFskxBpwJixkUKaah7HWdTfzrfwZzb99FL1a9M0wAc6C3OUvIe
	VVuOskaxSaFF40fVu7ekQrsIeSnNoyHq3/WxLkOq6VCTu7BtSXjRpS1qxb06Dcm1
	rKfOoJ9oycpBp+0sTVCcEwouT7xKNGcxHJGnBIm/VPxHRb2YKzRbn1bBcLDXG1i1
	mEW63dNyT/J3l8Wcjg97vn2TQNvp3wFE8Q6zdJoCZr7Nr94DLYx+IUJuI/7KXgyl
	16+MrjJHWuvrM/Lvhme5FMtgNwUQYoZguefFID7Ig95GccXsf5j/c+g6RKJA2ygQ
	SQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fscyp5hrn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 02 Aug 2026 12:53:36 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-520a00c7a03so48629461cf.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 09:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785689616; x=1786294416;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bzSqCN2ouqH/79hGb/FloWxsYWLiwWNlCW+sts7/z0Y=;
        b=nX9uZCeW9CC6UcDPRO2jD1vz2fvvoGBaL3wNmJb42mNztjFMD4sHiY3Woe27Kq21l8
         4PxdZB6BH7AZfm9FJiMGbQ2J4K+u712/MGU2rCM6uWq7v9YPyxnLVl90ngu+miin+1lJ
         7TtPV/2/Ou+L+wVEqXUh5WS46PkVHkge/V/kofrkLOwC+KQEDkivblDsU3Y/79pN+P4Q
         Pw5D2v6owMVAu4FA2KwKv8XCHgyg+kX38Z/TH7nv4v2dWfdNpWoi6gBJS6IsjStFIodG
         useVRu+8tMfQ7bEDJvwbFLZXJx/24mfJUF4DGrEXNgep7A6dJCG17XMsBBsxjvBPNeLJ
         FpBA==
X-Forwarded-Encrypted: i=1; AHgh+RrgG1LAmfa/3I5Nl8zFkgWFMCtfVIvOWleDyhGodleuUteClQ6rORLR6ZHCjnXUOpbf7EEmlGYX+g==@kvack.org
X-Gm-Message-State: AOJu0YwkWOZwYDhyxXLdW3TXhYaItbUDFg3vLjbkjh13eh5MhQMUwFwH
	rlWaIurxdQ4So4YWXTEqXxRc2GwXbjhDNpk7Ega7KQqoJ0S+3bpwDCdpK19zS25PauZoW/FB/e4
	wQ82nVAH8X+bSngIa/p7ZyuSV5jEg8svd1+FNYKCrnNkKpwgv
X-Gm-Gg: AR+sD111JMaNnXMILtvMDgZJsrtkhXhMZs8E+g+83TW57m/eaOYrlSL0ChzI/qqHomT
	Nh0AeBWLcZAqM6aBcEHJuJhJZxhZyovO3wSnnvKEpSV7J8pTn4A0FqHwoQYX0arAzoP+572zW10
	sZ48+qJkD6Dy/IZOGMXdfJI9IkNTC81MGTfAhKKXZ9Ir3lSSC3Xzbj0obgaQhsacK7Xoc30uGiA
	ARDzP0GF2+UNwUppBc7rIfTdCE+u08Kwcydgd5K5yhdszCaY7kyhMLwfhAbT/xVeRwW/wGl9hdq
	ZkU0cJrY14Cew1QlxYCkjv8BeLULiYfBJUdSF7TWBLMvIuTqfCSWJl3IjrEobbRGqGd3nFyF/Zc
	uga4us3QH8JTZM7TDPRlk1rK2W6s5tWcufy28ni5uD2i937QvlSA=
X-Received: by 2002:ac8:7c48:0:b0:51b:7af7:77de with SMTP id d75a77b69052e-52b566abe38mr141990861cf.14.1785689615761;
        Sun, 02 Aug 2026 09:53:35 -0700 (PDT)
X-Received: by 2002:ac8:7c48:0:b0:51b:7af7:77de with SMTP id d75a77b69052e-52b566abe38mr141990671cf.14.1785689615218;
        Sun, 02 Aug 2026 09:53:35 -0700 (PDT)
Received: from [127.0.1.1] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm24064574f8f.34.2026.08.02.09.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:53:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 02 Aug 2026 12:50:03 -0400
Subject: [PATCH 2/4] ceph: convert
 ceph_wait_until_current_writes_complete() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-remove-wait-on-page-writeback-v1-2-6c35d6b3ad36@columbia.edu>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785689606; l=1458;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hA71l4zps3FIZrXce++oKUdmiZgrWiFFt8Rlg/EPXQg=;
 b=NXcXcTwUKpw/VIbn16Dx6cegEB7ZHn9mIgTG7Ygwab6MpVdeUesY1ep5jkehOa6xD+NThEIbd
 Vk1axHal36zA+fFgqbopbWbRnXaom8Fun+tidHpPwN/TLt6hKEzLiKm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: Cg7RDH4yLad3dY1fK93myCuLf375v1th
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX2yiSdS3DSqby
 lblzO1A2Vxm9vx3CIKbqoo2JPpQXX9AjHfnDpMRpL6pfN5Tu0UJM15omHLHchQ8N4A3Jts456ou
 J20r6jKOk/TWC32K9GD8x1bc2/uuFF/WYQ+FhDVCoLmuiesU1IsW
X-Proofpoint-ORIG-GUID: Cg7RDH4yLad3dY1fK93myCuLf375v1th
X-Authority-Analysis: v=2.4 cv=LJ9WhpW9 c=1 sm=1 tr=0 ts=6a6f7610 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=oBeIbaJldBQvbLH65vwA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX/B06bL4ad44V
 uqK9EeTewHNv4tavoswDt+CRDFjlYQ5HW0S6tMJIYGN017WkYphg0SGOP1WwzesP6k0ENz8Wz8/
 t5HWxAq0lZXlNVmRUeQAGOImVTiWu8SRwE+U3XnEWwsMkltp5ucHFmPvMOkJXbb92awLQmBj9lB
 dBzKTqhQzZouJmqgwfDsGk+YJdwROawyTQkyozm/Jvzum/jz73gnXPPV/H790+ApFhUA9YGGZuO
 lSKwhSa+M6XsqZx7zHRuLbAuL3Tc1LkzG2kWFc0pInt7x6mK0e9ufNvgehU9+5o0G58lH/sNKoJ
 SenCz6Jpl1I2pAtK5VwPkYK5r5EgGV3BONEaxAVahvPjNEAYWWph8gtjJRTmrhmBGRjwtvVQ3p/
 WN5qZg+3xGLGqmN0fywXTcPJIJTGEaK1mbCjBkz3j+tI0gp7/P6A3V5yQQm12h0Ye+akzpqoBuv
 pZrR9JHj7Ff3cZDUDtw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 phishscore=0 bulkscore=10 impostorscore=10 spamscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020153
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 01B15A000B
X-Stat-Signature: 1ddorfuoryka3wxfndhhyyfus8n7ehh7
X-Rspam-User: 
X-HE-Tag: 1785689617-512502
X-HE-Meta: U2FsdGVkX19meL8skV2iFWPRavdG6yBNBL4oZCfcMUkSU/tLDWuQFbouFxgvGmGZxCWKKir2QDf0BC1MtDHcMzooTrEooFR7RbcgsjZzdoJho5xSHCSP8zPFlssf+YRLwpW8sgAl1S95dV5LlA4JadmJhmO5j9qfxkj2q2flJBtdZk3gOaxJXnOS8YW4J9u7meE8djmstTT4Fz8R9tyEJAU+f7ZcAnt4M9TCPHbgDXp+S8Fb1vxsQxwHuAOCe161UMh9YSqFjJpULMRVg1jnxwvQ4RZavz1sexPQDYIRybt2V+0Wyibv9cqSysypD6bYfQvc9SDzkyMZiatIZb4MTu24zh29xSouN1jVlTxFE2vIfQj5rQenXsKO7iHZrUisRbRLHlZCBoqOIFGlzV0UTU2U9Lbv6ktuVGjFWwU6Syeza2t4isZw3Va0G2ftc5szZ4SolQnnhT/65sN/9wjfgvdt8jmytEenb/xyZo2n428h5xtlfEc13zFZlYj8KpDifzyaEGtDPvGsB8qpmXwJc/vSuY3WsJFZDwIB9NGjIEn/7oDz+6ujOHx+vmiLDuJI54MaBdHqphN1nSezHyW2H9pksueja9+xabFZaWweAStF31w5PzzrrIZ/raJDoXyWAxbMJKvDHSJZgAddJX02enpRf4exAY1lvNAGT35yicIdTJAO/N2D8NojSG0nk716B5cTAW+MwdRT8bEnT4+WU35AKYFqeW0ayEleKI3FSMR5p06vJCjQD6P7fJBOe+FxFvxrTOQXDVRHIidXyHs33UyrZ3INB+GkDW9umg7ecpXMigTene8SAs566B+6/5jxUxmGL4oxQ4AeqMkq/ba6qZUuawmSsUHbBqVkj0SXhXqWohil9aeMeaQBjce/ZYbnkljdgAiom0F/8yCfZiouXwNJvZIKFJfvdA4RRWUgzZ8fHWBfhHwycHE/0MbE5lIbQpj43QJqqdpP9LVg3Si
 tdqKDmJw
 nkTcWGm+3JoCqwv6uqTwMhZPyfNaRaer+AzCHupD2qJOkA2nwit+YiC/556beFy+/R+ITbNNoTWXoqUd5G+/LyolnROfFtG5bt7MVbcQgcosnZNHwRevLK8jb+Icd9bHNXc/KLnkAdGwNxS4N1MfP9pGzm4canMhJTF+OEpqoGz0NBlw3GB5RF3Xyxb2X7WrJ1cTbI9CpuN21s8IZ3ECDbZBkH6uqxvBoxdul7EtuPPx0LHf1VbyOKAvGJgqLlBvF6FpzinijPLKaRf4ARLti5w8QIbxqlApJY9EMA2NnYivD228Y1402J0FdTZy7tVzi2tP6E1BQ1jaPfqY3ucdIlNRGBvC1voImVs8CWFWbYBvanudV2BSuIyxzx0Ev8M0/heECv9RD7VMDCqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Iterate the writeback batch as folios rather than using
&folios[i]->page. Use ceph_folio_snap_context() for the snap context
check and folio_wait_writeback() instead of wait_on_page_writeback().

This removes one call to compound_head() and the last caller of
wait_on_page_writeback(). No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a8ed2a14da44..f4aaf9a5f196 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1625,7 +1625,7 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 					     struct writeback_control *wbc,
 					     struct ceph_writeback_ctl *ceph_wbc)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned i, nr;
 
 	if (wbc->sync_mode != WB_SYNC_NONE &&
@@ -1640,10 +1640,10 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 						     PAGECACHE_TAG_WRITEBACK,
 						     &ceph_wbc->fbatch))) {
 			for (i = 0; i < nr; i++) {
-				page = &ceph_wbc->fbatch.folios[i]->page;
-				if (page_snap_context(page) != ceph_wbc->snapc)
+				folio = ceph_wbc->fbatch.folios[i];
+				if (ceph_folio_snap_context(folio) != ceph_wbc->snapc)
 					continue;
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
 			folio_batch_release(&ceph_wbc->fbatch);

-- 
2.39.5


