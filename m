Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE64C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4754F6B009E; Mon, 10 Aug 2026 10:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CE66B009F; Mon, 10 Aug 2026 10:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202D66B00A0; Mon, 10 Aug 2026 10:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB4F86B009E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62E6980172
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:23 +0000 (UTC)
X-FDA: 85085572446.05.B7CDCDE
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDC832000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=V7msvAJD;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371680;
	b=btk3PBWw0nI3CwCk/AFEqAqYsl76ypkXFCbVvv+9HV6TMKRM/k1Kvo7yqaJUbZv7os7E4L
	1+OXS5z0EzlGdnK54NMyJvssnh/qo/9nLZJ4KYuGbGAwt8UqNsDaKyYGs43lrg4GHQuE1H
	MgGDUkYzECBi1ilNXcwCqS6eYPKjwdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=V7msvAJD;
	spf=pass (imf13.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjHtAt6xPrS0rFFojV7YCtn1FnT734JGQcpGFzyUn3s=;
	b=6CNi5DpQY2zlFMgURLTZWgz1yQ8vjQ6g3Nzu/snJogbS8JAo1EdX0k88hfxzsn1gCbrIYj
	KM1YWFsQyN+6URn+1FokP4t8hEocFzmO9j1PNTjxWXNQuQWjGEFBZVLSHk9n7tM+HJ3J/h
	YfmPwwZwTkoAEmUDBCIZcFbwUHcTago=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AELIZh3538941
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IjHt
	At6xPrS0rFFojV7YCtn1FnT734JGQcpGFzyUn3s=; b=V7msvAJDQO6Cp0c3wmcU
	OsBbKNzMS8p4Jxu8pTCQLs8bvpvt54iQ/MKjfLvFb3+Hia7gYfRahFqsF7i9LqTy
	uaddPdJTZfQZe16KitfFHl3vdC7QN3+WXSuoCYd0Ot3lHNw/b44jSYDKTmKeVGzy
	6ogFrjvZFadVt2A/WLbYx3Xjipg2BQPOTgI/b/dQhUaPy7XjFG521zhpHHd88XNv
	xkV8RvV7liSGrNkJeCC3qM57WUq6DeNKhA/z3tlA5zYcn2za1oDF61c/MvzLHJPg
	I2L6sfzQo2n7M2ms+DxO1sw2KZfCyurkO2Rm5l+viziasFL20v/cTBUi7V+nwgvD
	EA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fygb6g01q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:19 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-529ae8e96e8so17536541cf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371679; x=1786976479;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjHtAt6xPrS0rFFojV7YCtn1FnT734JGQcpGFzyUn3s=;
        b=iSjVej3721hplagu/mmhqrV0HvmgnXJLg8R7lyXViAxYcfFsju6J+xYSxyBFRV0doE
         QAoIzy1bbprrrxRytdCqEvqTAIEZMLKAFzAze/8AogV3Usbfp0FitHmej/primSDqXSB
         GNkLByQo9EZLWiTFai8cCje4347V9osbN84h66F6D+neKih8kkU2kQDaJtp5sLa1EVnc
         lB4KHWWkweuCrswsO6SBe2+b5K0rhYDG/b/doeDtRSsteL8fgWj/kFPhGfB4aOwDr9Hc
         f9z/J1j/XGJ1v+eq/K8XSol64IClfIUL5UvCytCAOwy5dpWcq8NnsxJ2vby4oujCQ7u0
         67KQ==
X-Forwarded-Encrypted: i=1; AHgh+RrlBkUNzRZk/a1FOcmjC9hAFDsCj14W5PGBudf2SBgre5ac71TBfeEiuAIdfQZSH0LQ2c9LFm29OQ==@kvack.org
X-Gm-Message-State: AOJu0YzrW46rLTqnNQtga6GoPzFxVGqCuYLcKpOJEZJti/wCJYQV0j8N
	bG6E1M9PWUVcSmKwupcMxE54G3SYqhXBJZoW2umxkrTxwDKcIit3N6Q8qxnpQhp6rrK5nWSSqKi
	XogTcKluNyL6I3LPTldUY0WOpRb4s6yi55uE2sPa8SUjz8uAO
X-Gm-Gg: AR+sD11z/98DML1T/Ukmq2+xcB8xin+RxvNxiKszej+rG3VvWYk95hRvgQ16X/cWmRi
	p4G+vvsnR93RLamBfWW8r8rfbMZvKH/Oe303BlxIz4mKtqZnvWqDcBy+f66rGqEc8gh9UK0ZunA
	0X6CBJxXjbIaqm29nd8AuvHVxt+IBQVa+piHMycIEPhKZfEs1UVOTms4Tj5t4qrXcYMjtn/dZka
	gWLWoCmdihyo1d/iVjmdSaOarcy72MaJ4PovhP+phsi72a4KWrbwoVoLN+A+OHXmvKpTdm3Vwpy
	EJRSB7Zve8WzJSr5KkwkW20wQKu+fVjcm5FMsdI9e3nDgmDtv3dyrEBA+dXbUtBMeDrZe/UL0mD
	Dt+FnVFvn
X-Received: by 2002:ac8:6f0a:0:b0:528:320b:305e with SMTP id d75a77b69052e-52d4bc980b2mr25354971cf.35.1786371678755;
        Mon, 10 Aug 2026 07:21:18 -0700 (PDT)
X-Received: by 2002:ac8:6f0a:0:b0:528:320b:305e with SMTP id d75a77b69052e-52d4bc980b2mr25353871cf.35.1786371678214;
        Mon, 10 Aug 2026 07:21:18 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:17 -0400
Subject: [PATCH v3 06/12] ceph: convert get_writepages_data_length() to
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-6-dd7531704f26@columbia.edu>
References: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
In-Reply-To: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=4666;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RB6EAm4khz80XnHvU3JzY5JD7tO097AT2T3aOYQsk5Q=;
 b=2BYn9jC9xqnkpmGWEmWnzu3nuFMYF00OiM6zRyuG/a7lH6IXJCYQWgiT7LYjcZIK1HYQnpMw0
 TnXJAaYK7n5BTN+QpVQmimzFaXlk3oIPuNmUL7EPbH/Mzj24wYByM5G
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX9GeYFDTTyMdI
 py7NGY3aDtjGLjani/+D6xVD8tVMP9laHz/Qe+I8+Mhc6w+830aBB2cscngf4A/KpLo3od9+gz0
 qjKm0RKq+DUqLT07UoJCcANpmXvlQKHfSK9zAOr+hreFYar1zY8j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfXxnLCqaDZwz/F
 WSNUXhwpmGQS22oy8pyEJk+DVaiqEZiobfpm5/MAIY9zegMxB1L6QwrZodurxm3EPz5TG2bV9Dr
 jA42G/4ii3s0b+D7qDXsZ/ssKI3Y37PzZ8RFjceusE6UHcnSZCMKDArCVv0eUDjsKx/JDmyeUl5
 gnpsJMTDYxL2/PAExEv5nbzvmxd1/L0W17WqoPS3Wmi1RMKZD7hFSxXNWvunhlVLQW1PVrL1kb3
 ucC2AwVOdJOa2WV5jHZMTyvnC5aa5gDvSFL745uX9327XlrTeXRXyUEWHzFlyJScTST+XVKh1FL
 QkeUHt18D9GwlM2lyD7D74ZCXmyVrhGijQi07Afji8NSGvT3AWhBOezpfcQ4eJVpcdat7Ct56SV
 1DwxoC7ObLUrFy17pegddoKdhiEKyOGbuNVHp8a6UFbfOu3bf2CCxcLL/S0GdLbcr8Hxehk7TDm
 xSsR/ni+dcY5kS+VK0Q==
X-Proofpoint-GUID: lJymv1w8PPyj5x78RfD-tiPDna19IkKS
X-Proofpoint-ORIG-GUID: lJymv1w8PPyj5x78RfD-tiPDna19IkKS
X-Authority-Analysis: v=2.4 cv=MuZiLWae c=1 sm=1 tr=0 ts=6a79de5f cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=4S3DF5rXG3rfafK4-1MA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 lowpriorityscore=10 clxscore=1015
 impostorscore=10 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDC832000F
X-Stat-Signature: qm8o1a5idy9capf4poj3g9375sf3agy4
X-Rspam-User: 
X-HE-Tag: 1786371680-1102
X-HE-Meta: U2FsdGVkX1/urc2CIKN8GRCQPBYsmA8boJqbrR2ZpzPxBcI/OK6au8f2CCUTPwxZjpaGeMBuE14wt+k65dvWWkhdUMhUZ6JInj5tvw2348GVCyGHVJUFIWWtaAzXWmo5FopDImENBpQXDQaNXv1tPzEJojKa5HqOJQaibPsU1L2PHIsEYr15VmFRUZ8iBssNyLNVONXE50nvOcUoJREtC/CZxLkjCzjAe8gMbKSFXC/3TsT35SNRWA5rx4w6BwzQ/4LuH8e1LmTj4quKKSkr6239Qk1bR+kBuckqokikr5jdNnKPGBpbTB03QdrFcOOWsHA0I7cM1WrJCQU4YP9eFN8qqbAMedly/2zj/B8e/q61q65wnoxEfahjdimsaBLLIIf1ujC2gyG+XHPgN+aZZfB3Ko2E6abtKzNa0121d27I12CnqhaYQ4h57A8hVMmitBmtHClyJIZqk18N+0PhL3H1gifAco8XvyT43LWJruGBMGtpJ1JtvauB7hXkGxD1x3CDoGNMD6WtapNxfrkPFjnWBjDtjoCBqpF4v7Hrp5EbUrAqh4UyweWW1QvuUCPDvd4l5mGeCoC1Lbj2CfH38/K4nqzaHCDSiXFVRbtE8WJnej2iEX94+h2TzrF33hEI3iHBTjdrUsQe+FFw8jtIKZPXxZWcH/BcvQDpSGQPTdcoaKm0SelUYtrKvM2IPk23i1suG1LrrANrLvXs7sYxx6xYrSTlUQuGNrwAk8FbtoVuf/OhN+o2nwLvGTx3T6JCtHQZ4q+fk4vefewto8s19NOSSQV6pigHBvvOej22E4bQVzajSfvTR29rvIBzapYHhq2drCgaFad0vWoe94MGEhmb5scgxKKxX96mWuk5QpAZ4xEf+0Iq/k2pkRFUzX3logFSIkj+OmejdSVNjAZiLgwanzGS9tBbtbBO+AgSmWXl9pAw/S7LFKvyKpIcyuOtHgNJSopYwr5zG6NA/4w
 uBrqQVH6
 JYjVoLdNbEpP/eIvAVQ2Fj9KYIo9v399FOZ2EAfoLhX3S/uktZXhpMlD9U863TDf92jqUjEIqC4Oer31N4qibvBL/csPn39gBGiNEuh9crF99erHUWzXnsVIMGR6c7Ut+KGfRnIY7Sh0mwkSJIiZDdzjmnQNpqTv2TdlVyogiEtTsnoVGeonADSFBkGUqSxCxXo45KCdhWaQneUAiNT7C3NC3Ic/CV4WZsqwPZUtHpWHmB3DDz5JHBbA/b7XoQY3CCBY7JhiideiOykWy+vFxPHlzvMWhKKMWddNGgpAShyfEB+mGt2KVEK1u40Jug4qfGSFP1/TBSFkGBShufGv8cjkSC8WFTHx1dq+jvKq6Te4yTBvb9rvUK1JPCylXEvmFFpEajLJEB22XW71AGl9NaKShUEno9sLeCjNBTh4WRdPVrdPmXRv0Z2T5Dq1g/qJbWxwyl3TWdN8US4HoEVVKaAreR/ZL7Z9Sw33GDGylD8JcK9ELEgaY3/aBmCJ79qlys/nU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ceph_fscrypt_pagecache_folio() and ceph_fscrypt_folio_offset(),
folio equivalents of ceph_fscrypt_pagecache_page() and
ceph_fscrypt_page_offset(), and use them to convert
get_writepages_data_length() to folios.

This removes the last caller of page_snap_context(), so remove it as
well. This also removes a use of page->private and a call to
fscrypt_is_bounce_page().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c   | 25 +++++++++----------------
 fs/ceph/crypto.h | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c08fc70321e6..28f0b16da2b0 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -29,9 +29,9 @@
  *
  * There are a few funny things going on here.
  *
- * The page->private field is used to reference a struct
- * ceph_snap_context for _every_ dirty page.  This indicates which
- * snapshot the page was logically dirtied in, and thus which snap
+ * The folio->private field is used to reference a struct
+ * ceph_snap_context for _every_ dirty folio.  This indicates which
+ * snapshot the folio was logically dirtied in, and thus which snap
  * context needs to be associated with the osd write during writeback.
  *
  * Similarly, struct ceph_inode_info maintains a set of counters to
@@ -68,13 +68,6 @@
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
 					struct folio **foliop, void **_fsdata);
 
-static inline struct ceph_snap_context *page_snap_context(struct page *page)
-{
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
-}
-
 static inline
 struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
 {
@@ -701,7 +694,7 @@ get_oldest_context(struct inode *inode, struct ceph_writeback_ctl *ctl,
 }
 
 static u64 get_writepages_data_length(struct inode *inode,
-				      struct page *page, u64 start)
+				      struct folio *folio, u64 start)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
@@ -709,7 +702,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 	u64 end = i_size_read(inode);
 	u64 ret;
 
-	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
+	snapc = ceph_folio_snap_context(ceph_fscrypt_pagecache_folio(folio));
 	if (snapc != ci->i_head_snapc) {
 		bool found = false;
 		spin_lock(&ci->i_ceph_lock);
@@ -724,10 +717,10 @@ static u64 get_writepages_data_length(struct inode *inode,
 		spin_unlock(&ci->i_ceph_lock);
 		WARN_ON(!found);
 	}
-	if (end > ceph_fscrypt_page_offset(page) + thp_size(page))
-		end = ceph_fscrypt_page_offset(page) + thp_size(page);
+	if (end > ceph_fscrypt_folio_offset(folio) + folio_size(folio))
+		end = ceph_fscrypt_folio_offset(folio) + folio_size(folio);
 	ret = end > start ? end - start : 0;
-	if (ret && fscrypt_is_bounce_page(page))
+	if (ret && fscrypt_is_bounce_folio(folio))
 		ret = round_up(ret, CEPH_FSCRYPT_BLOCK_SIZE);
 	return ret;
 }
@@ -1578,7 +1571,7 @@ int ceph_submit_write(struct address_space *mapping,
 		 * data length covers all locked pages */
 		u64 min_len = len + 1 - thp_size(page);
 		len = get_writepages_data_length(inode,
-						 ceph_wbc->pages[i - 1],
+						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);
 		len = max(len, min_len);
 	}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 79cb563fd887..948c8b5dca06 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -162,6 +162,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
 }
 
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
+}
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -262,6 +267,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 {
 	return page;
 }
+
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return folio;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 static inline loff_t ceph_fscrypt_page_offset(struct page *page)
@@ -269,4 +279,9 @@ static inline loff_t ceph_fscrypt_page_offset(struct page *page)
 	return page_offset(ceph_fscrypt_pagecache_page(page));
 }
 
+static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
+{
+	return folio_pos(ceph_fscrypt_pagecache_folio(folio));
+}
+
 #endif /* _CEPH_CRYPTO_H */

-- 
2.39.5


