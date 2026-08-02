Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B347C55177
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADA06B0088; Sun,  2 Aug 2026 12:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036ED6B008A; Sun,  2 Aug 2026 12:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7D796B0092; Sun,  2 Aug 2026 12:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7206B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:53:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E674D4050E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:37 +0000 (UTC)
X-FDA: 85056925674.21.4458615
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 46E22C0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GCggjXSk;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785689615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxVdpvxkC5zPJOy2sGwkp20ewyXEsgwMMwkoFsHT1cE=;
	b=uyVOCbXOlDInJexkkywZ2SSjZqk8/Od9ZCLhbF73trm7e9JLphSLwZDK5ac1bSYZ4QaHE0
	a17E/LERYcicDubE2XGaPqQnqh6vvu0Hgj26OuJ6/KpXF2RoH4EI/9zDKurrL8o43zni1T
	IO9u3LaLk25ZER6kW1bRuq/qykY+ZjM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=GCggjXSk;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785689615;
	b=yq86N10RaNDTL9mcfyFUYWYIBk/bvr8K3nsyoOlS/sdosp/nK3W9cnTsyO+0HDLWwy9BcS
	tFTMe5GqbH4hH+c+Et1iXjURa4WHqJKiK0x5AWl8fnE3QQilMdjM3q4ns1eRuTpWPjBSHT
	/2i5ykCn2/9bDpLMyB0OpIwKN3oweP8=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672GfWpI3923228
	for <linux-mm@kvack.org>; Sun, 2 Aug 2026 12:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=gxVd
	pvxkC5zPJOy2sGwkp20ewyXEsgwMMwkoFsHT1cE=; b=GCggjXSkylmK9j0b1Jp8
	oP3vczyvYz5vManXcGOZUGpnAR3eQwyYlptq2RtkgZamFQKTR6CERuIQwtPdg/lJ
	YU3rEa2IxVA2JcK3L11HOSw6DrcgmmFBe/itIo5NvHQLi4e82RkV3Fz8/Ek/ZfPJ
	qK5nBCYxhMOFwQXtbCO1RzQVAzlv9TXeIvtqngpMG8hjyG5/mgNBFtYehPoDBaAu
	LHIQG5RNx5PAMEh+jJHUdIhgmJX1OeTKP9SGo2A1c9srlSeGdVfDdPtjWGn8xlkX
	4AdkHPOgB/s+3gheu+wBxieB6FXuhILGq2RdNbBfYj9Ajd9/HuEJJl4QgoJmX87F
	Ug==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fsdrgnepy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 02 Aug 2026 12:53:33 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8eec6acbe21so55692026d6.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 09:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785689613; x=1786294413;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gxVdpvxkC5zPJOy2sGwkp20ewyXEsgwMMwkoFsHT1cE=;
        b=GLNkAztPrbiPVZkRGZgCsypqVgl/cUsBmWCQrHXiv4Shbakz1rtpyVom0/S2AgbgDo
         X1+0YqaOV3bKk1ECCuxXcxcrJaXy7aHBhwpr6sOQR7Otovkmr1aEQ01Q3TzCW7g1rR4g
         0FwQv7rlMow9YVXQAke//nc1+BOuD864/DXAAayFQ8g12zOaQ7iZNSemzJaUn7IPxmcP
         OrBBtiEqY8H+5bMqxvBqhUH9pSBZueNaxPLkOr1Ovetndr/j27gbqKCJHJu0kXvmGFur
         rPOlPsrFFXe8WLpnpaZGtQz3uZwCAP2IJPWbYrjnIvAFf1l1H2uCNvU1+ifOAWtYwWld
         oRSg==
X-Forwarded-Encrypted: i=1; AHgh+RpuEs2C/J0aIzvirTC+rmnnwBTKnuPCz9T9Nk7VN3LAzgK8TW7gA97f8LR7OEUlH/sJFgnmiFEkYw==@kvack.org
X-Gm-Message-State: AOJu0YzAiRWWsLbMxD0x82v+VQeLmDUoAVoLzGhnqYU29jgQywZD80g+
	BNF2NoXr++IQs63p3axMu4haZsZBoVGdi4TtQ11IRFtw30aQAM3uN+qgNPCMI4y9TnRyFn53J4K
	dB8GhKeczlf5c3u7y0vFCm9/m3kBK99dh0kzQ5KON5rinXnhU
X-Gm-Gg: AR+sD12P3O3HXq6ajGDAAgwWRtmHrUcRZPWgf86Bg9IKT6ydcvak661iOZcUE1gNHzg
	CWQe7+AtdAQA9crc0Uz1eqqTjeqRfh6MldOBn3moJISYz3ls3r851FEW5PTUYbvX9kmdXudQSeX
	96BZ1AVbE/sYTvI/DUdraPG5CJCIVNAbp9KmZVx+HOIPW5JD27c6IB/Da6ikjfpuX/+2F8cfeUp
	RJHqWfxyTOhmlyOdAMCmJconSqeEOMtMZhVaXkIi00x/8XbKKO+/KbA2pdhATMRzTBU30wCRukD
	jD2DkRkrR/3Ks+/D8Z/q2gS1Bu8ll64MPMkBrUXYaRefIj+oKk+pUqTDHoimRuAXTa88JO488ll
	ov7Z10O4prK4AWPbCPjBXJEmq8k6Kg9othD0UEraIGuwlDBcKmss=
X-Received: by 2002:a05:622a:2486:b0:517:736b:e0c2 with SMTP id d75a77b69052e-52b5673f0b6mr159137761cf.27.1785689612920;
        Sun, 02 Aug 2026 09:53:32 -0700 (PDT)
X-Received: by 2002:a05:622a:2486:b0:517:736b:e0c2 with SMTP id d75a77b69052e-52b5673f0b6mr159137361cf.27.1785689612478;
        Sun, 02 Aug 2026 09:53:32 -0700 (PDT)
Received: from [127.0.1.1] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm24064574f8f.34.2026.08.02.09.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:53:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 02 Aug 2026 12:50:02 -0400
Subject: [PATCH 1/4] ceph: add ceph_folio_snap_context()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-remove-wait-on-page-writeback-v1-1-6c35d6b3ad36@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785689606; l=1979;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QqylW3bsSIhF05NLxH45ljAlwMTCLlW2b0M3h7Ydtyk=;
 b=dxZbHRsFgGPdfbaM7ZuaRZB4wbT0T9ysMyProgY4c8BR9d6NCgfGc+G/TZXj0NJTYAzcPrmn9
 AlW+bBeNVYvBE31GxwJr7e7QgAOWIYuQLUSYFlUILQVrkd9oIz1kjwh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: hhujA7xw9TQyWfRi_gQmyc5rh5J5kOtq
X-Authority-Analysis: v=2.4 cv=WMxPmHsR c=1 sm=1 tr=0 ts=6a6f760d cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=ALYDsW89DncSylXEcn0A:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX0rMfPVzCyAon
 MCln/CUCyS4cVgDppb0llt9VFQ5aKGjCGw/jibV5TOnBPRIlhKm4dVxfAHahY5NZECzP2HDI3fu
 H4w83xFr1dZhU79/66CLYfaqr7ovvAAENoktw2n3sDsNPX3v0kn8lf/tNRH7291cKYcWz1A90Ec
 D7V5LMYuvgb1Zg5ivQEdY5YsNVcMR/iwiBB+uusATpnnuKU/YGfQxiJ9KG1+Gl63OaEl0IABekr
 xGoYLQMhKuuDpOyx3jLdoxpk3fMG416UsWJeXbdUHywLtmDwEWV03uF8H2LUSnxdG3Z6tE6tpa5
 lNRKMU6dlqm/UmpM4HKYziC+dykDFPNrkTwFajHOm5N9FfmtuXcupZUKThxZuUrc4W/ks65+MOw
 WT8bfFA7jD/3hKYb0/eOlwLbE0FQ3IqilvXn9TCeAiY8pAq4T7GF3w6r2Tgfqmn9a7vDEyj+Ve0
 w/lbzeIA3g0ohLHc6JQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX4hvYHM3iVZ02
 6gjbBeZM1WiNjYkH3s4QUs0ZYFPajp/Uj600r2+GgKv6aDgO8Ut2r+yVwdENSF100nYkjJVlN12
 nsNH8EGeABOsKAkkZo1M1GHB3pg58HaQJp+bhuu8fKU5ZBQFOA4P
X-Proofpoint-ORIG-GUID: hhujA7xw9TQyWfRi_gQmyc5rh5J5kOtq
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=10 malwarescore=0 adultscore=0
 lowpriorityscore=10 clxscore=1015 bulkscore=10 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020153
X-Rspamd-Queue-Id: 46E22C0003
X-Rspam-User: 
X-Stat-Signature: g95qdna4a9t7zepc8bbf8yx1g1h158qt
X-Rspamd-Server: rspam04
X-HE-Tag: 1785689615-77868
X-HE-Meta: U2FsdGVkX18JwKE8sbH4WC18P3xJfj+Rvzpguos9llzJMhQ/1yWumlfs8X7M+RqQ79l5cQ04MWDebG4fOaGfj5r3oWMIsfzZ/s6wXkP+XJiv5a9lBUZtRMf+AKxS/0g9n88M26e2nJHOB4MAOkp2u8ceQz2Y5yh4Hi4x5D7sT3vmto99SWHnkaJCE48LOlUg3M6CwjLCjctiC+Aa2Y4GgSMn0xmTWaIDXXs9n+r5SZ4xeeBC3jf1w1HyQAV9LuV9P7uV9elkgikc6tBQVc5BzumFMgccky6fOdNbmKmHahjytShqraT0pbIlQvcHqlgX5VSS4C3akq7OzalRNyD2BhbJWjJngMTjVkKcgE+/G7FvcTfgdRXTsQrrOXuiS0rXAk5kt9D3NSsbkYaOEqG1VmyoSgXJy+XtAjVrF6Ztr1eAfmeg5ksHdYyNWeHWqETZa7cAvMz9XpYiexao/TomXAdtMW4PYz07MAkNB0G0Q7ANBuojaImtNbHsbXkny1KdBP5MlKO2XCnBa4KbwRp2sdlCykC8iyWu1CnHoOSCkvK9k4PwyCin3YbtmKl17jgZbJm/KkrlxCHJTMbFzfbkhwB4j+sWc3EzjeFyhGDT4e2HBD3L3ZNknXb0CG/e/LR0KZg5cqIlbOF3LuTorkXddp4piiLS2R4+u2P/BiD43X9HScrJUAXwzkxhELUxzyTFXlphqfKnM4f7ShyiidYnmfxfEi4s1xWLPTMZ5ZlhDUACxOiKzpltpusMc2nT2EyjdBsdPH12BwksfxXvIP8EtjI0ujTjVXOspJU7SRybKEcEs828A/HOfoXCkLuAfdVPlOCNVTaX464pDGTRfEtbGmKsg7Im2t9GRY+MsqcpjC1myIlOclvtdNNg2TgypI1Iuj1Qg4HnNB4Q3MiQhIXQ2qKUUJXh2RadsyT+70WV43ZmxuukX+0zMlXC3XH8Evg+TbXkxUdZYnh8InqZqOh
 JavnpGhW
 Ho6c4m4/vjWnNx9YF2ljqD1NNo9mrMe8AjiC9Zhf3zhM1Ql8xFvFTrWz+q+XDpg5GJcAf75ZsXlaTJquSidnBTlQmCShgFKB6HjgUOZ7dIWy+EpJmn9ULzpjMUT0wezPQloPm1sK1TJe4fyOE3Dz+pLYAzOKlrBnzWmqyTYtJfykuS1xGiCAq1c3L+ze2UaTO+2xwPOcWy6ufTxHPwDp2EChkyjIfBN8GkpxcWhnAHVxEMJwR+vUZ4KEHLB9iSb4xq6RMh8Q0FEwxMgwOiuzJVUjnzlmPjcjFN0/eFLT9DXJpXO7jvjYvb+RgwAENv+P8x6zJgCg5zGN4JT7BNO5etmLVm3eyNzK0v1XAutoWZfaSCjVFl6o/bpFmiGtG/8M40k5krwcivMbxiAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a folio-based counterpart to page_snap_context() that reads the
snap context from folio->private directly.

Convert the three writeback paths that passed &folio->page to
page_snap_context() to ceph_folio_snap_context(), removing three
open-coded folio-to-page conversions. No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ecf33b66610c..a8ed2a14da44 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -75,6 +75,13 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
 	return NULL;
 }
 
+static inline struct ceph_snap_context *ceph_folio_snap_context(struct folio *folio)
+{
+	if (folio_test_private(folio))
+		return (void *)folio->private;
+	return NULL;
+}
+
 /*
  * Dirty a page.  Optimistically adjust accounting, on the assumption
  * that we won't race with invalidate.  If we do, readjust.
@@ -745,7 +752,7 @@ static int write_folio_nounlock(struct folio *folio,
 		return -EIO;
 
 	/* verify this is a writeable snap context */
-	snapc = page_snap_context(&folio->page);
+	snapc = ceph_folio_snap_context(folio);
 	if (!snapc) {
 		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
@@ -1171,7 +1178,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	/* only if matching snap context */
-	pgsnapc = page_snap_context(&folio->page);
+	pgsnapc = ceph_folio_snap_context(folio);
 	if (pgsnapc != ceph_wbc->snapc) {
 		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
@@ -1824,7 +1831,7 @@ ceph_find_incompatible(struct folio *folio)
 
 		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(&folio->page);
+		snapc = ceph_folio_snap_context(folio);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 

-- 
2.39.5


