Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C1CC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0B86B00A7; Mon, 10 Aug 2026 10:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8536B00A9; Mon, 10 Aug 2026 10:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDF66B00AA; Mon, 10 Aug 2026 10:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3596B00A7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B45401601A2
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:41 +0000 (UTC)
X-FDA: 85085573202.26.E784136
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A389180019
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="bojn0z/I";
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HS4++7SfsgCqjVhck++B6W9XvkcEaVeM763sEjq4goQ=;
	b=nsHgw4+2B5IAouzmBjCpYWnbdSQLxRxAaLr4rNkVtfiM5NINVoLcuMxI1kLp9BhDjKMM0P
	OQHLXh1bc7bsB/4/OVhVVBG7LnrO/pZD9l8iK9LmgQse8HBAjnl6H6d8ymHrrycwUMRSgB
	585A0r66ha4fbBcOI1a2R9A+BsdBVXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371699;
	b=mponvHRWmKBDxgm/5RC52OPvsFMkp7RWKmt0DMSBXu70TNALKJILWPQpC5aca4om8CY7MP
	NKhGxMdAti6PNtqdNelvlUkr3KpxjZ3bJOUeBhurZ0786LoI8ym1gU99yp7Qef45OvMNxj
	3854VgZf5jrJJH+skd5inSG6Urd7OPI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="bojn0z/I";
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AELIDG3538923
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HS4+
	+7SfsgCqjVhck++B6W9XvkcEaVeM763sEjq4goQ=; b=bojn0z/IAr5WNLmoq+w7
	vS/X8WLw0/NTfqXqTGcamUIQWo4g/1L1wzi+AIV++Dhbx53xF/eodzujqjggv/dp
	Wjl0FEdLtxLDhDIo31SXiluw+6npK4Acz30nLDsWhvE/jjhT7xs4fRSt1DLPX34s
	a0p8FYeF/EvPTQo9DDd0DA1sr543nK5+qGslCJcvF4AH9g+k4Zqi5OnxofRnM0cf
	dC/eTYsHibBWFmdQWofYkVJ1z30MDCp6hzDaDdibLrbeqEbrlElFkVTP9CieoFIX
	yR9YAZg9zzfGmOkedQz15nZ1R/gVgQxhGlD8I0nopJIAskQHX9nrh1vLNO2JGaZv
	yQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fygb6g05q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:38 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0199faafso23198531cf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371698; x=1786976498;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HS4++7SfsgCqjVhck++B6W9XvkcEaVeM763sEjq4goQ=;
        b=kxqBleaEAD8yiSTbOj3Wu1RxB5dnRmUZ5P1DSoNfwo6UlB/fL49BwjeBbsBjrTmcmV
         wsD38X3Cun+wd724+8OigcyflSaX45LdAWN7e2RFJ2srYX4bNn4/UP1FL2mSlRM8K9DY
         41Jp6dqHdGQxGOi6gJaAlQ04xup1QVyLt1b6FfUJgYeFSjkRqCFzhdgIAHpkPaRrdWXi
         mjegl/eOC/t3sakCDNL6fJ3vi2QaWPPS25xz8TPgTOBE/WPkmw3ARMfldqIr/LWHmvxq
         ijHXYQz3tRJtGHbXFcWPTVKUN5GiLENCQegGhtIGXmog57zYkT1uyBQuc2IR4VeZYTqc
         5sTA==
X-Forwarded-Encrypted: i=1; AHgh+Rpdwnl9rELWipBvo1mL1OPe/7CReuiym6RbpsoHtTIobLldmqOtd23ZOayenXpKPaQuxTKb+FDFZg==@kvack.org
X-Gm-Message-State: AOJu0Yw92a8cd1/YXhDSmd4gWABBCntXCKZdv2ISFCNP336k8DvITUW7
	sSlTrUtU3K8g3EwN8khAuUkNAMJS3bcp9JtfI3b4OWQFysMcp4wOqbQLlxRr8pWxb2zSuz8CTlx
	4Jry0AZKIYuTLOB9b+WK8hOG0IvQWbxXwTkF7oEpHSi3y/ycF
X-Gm-Gg: AR+sD12phYVs/mDbEdfKGPQqRCgpGodJBZrdhEq08EFc1WX85YKETddUSO88ob1hb6f
	cdc/CPis0T5nKl6M8+NvGKvKS+qAdl99Zk14Yi7TPbFm9Kg/BQzFFBEosFUUftkUWEJ1fAicCU9
	fB8r+TE+NnLKFfShYLYdm7bBUQoSYMDH19dPl36V5tdveQbbSvzmTFNaSVF0CxSjsDAfQ2jYuhD
	PDtD5I5UMAJHllvo6JgXEzdtLyCp8z7kcxk93oNi53vIZAl4Z8DFvWQGdCSQzAPIQTAdygy3zxm
	kxoCCbYJBcX/oLgN7MyFZXtiObUJwA7IpmYtlMAfvFftl4pEvdCmTB03+0aRqN9HciBlRtQvnHD
	BEvdDu28z
X-Received: by 2002:a05:622a:4811:b0:516:d60f:6438 with SMTP id d75a77b69052e-52ce5e01448mr479946461cf.0.1786371697310;
        Mon, 10 Aug 2026 07:21:37 -0700 (PDT)
X-Received: by 2002:a05:622a:4811:b0:516:d60f:6438 with SMTP id d75a77b69052e-52ce5e01448mr479945641cf.0.1786371696835;
        Mon, 10 Aug 2026 07:21:36 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:23 -0400
Subject: [PATCH v3 12/12] ceph: rename ceph_check_page_before_write() to
 ceph_check_folio_before_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-12-dd7531704f26@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=1302;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=H+WPEAg6fNk21OMcWq4m8PpfVy6prUL5jC+rlshnioU=;
 b=Wb7zxOOE2mdK7NryczQ1B0RD/gwzEja+WEduJUoRi/Dwu2V70eerTkzJiLplKw68Da/YSBGCZ
 nq/6m0GxSXwBAU0HM+984/XsYO0YrPj3RTxev/kZTfV8Wr3VvludnS1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX/uFlMcnyMtcm
 tM8skkhsOZ0pi33xkYnTBrPOK6P49v2wHkh8co5LlrxqvrfVl2ObOlXO5qrAOkEIKMOgyigXVvh
 l4tPKmbd/M2LzmBdBR9DwJEaeunMFWJW6AhRaNenV7vGowukregs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfXx6pZhpY7ZTjs
 OWU1uCvmDEHGItnVgFK0eXhsU+rRzc4CJ8IZdixIW5gb6ZWsQO7eQFkSg1bydcHd3+lihdDYqV1
 c3LOS6sRl1wXq5Hoj1/gOLCrmYlRoNkC8mZUYbm4okFmFlkH9anlEMYhZ/6zlSfaA1jztTtd0AU
 5SmtxeTSMwoCJfCXWN6BwX9KZ2QMjftta3V+yDGuG4nmk3N2cYcrAUxpgpIZ22rEYb/wxEAacFN
 MPncFIj7QCFss8WdLVtiF2rG+i9yv83Ch3L+xxL9X4cSf6Pl0SgWpm/oeXZ77NYixVeGgK1yMx9
 1R6QzhGOE7LHWfTlo7D7ahk+9r7wmHUtlv/2YElxPszUgEl4I2GgSKAVvJrx1lJG9e1yA59kOnu
 KVhV43rnbe3jBcDkiFmoxGLgxDP3NptSYfHDEyXn5PCWpTg8NSlN25jKGgMl99cDHOXFWvQzrsn
 Qxa+p+LLf4X/v6hEruw==
X-Proofpoint-GUID: C_QwsbwupuC89eyv5y6Zuig-56yfjxAr
X-Proofpoint-ORIG-GUID: C_QwsbwupuC89eyv5y6Zuig-56yfjxAr
X-Authority-Analysis: v=2.4 cv=MuZiLWae c=1 sm=1 tr=0 ts=6a79de72 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=V3EFW1AtJEMGhprvICUA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 lowpriorityscore=10 clxscore=1015
 impostorscore=10 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cu3tqxrtdb88g5jctjn8pqmmk93kmuds
X-Rspamd-Queue-Id: 2A389180019
X-HE-Tag: 1786371698-369929
X-HE-Meta: U2FsdGVkX1+N74WDV7J/L5fFSa9uVTsNM14JVVMdg4YwoZDxPlXBYzDRCAnbrP8Y3etzAh2BoENSCcx9sjZiRNdCPQtPDkesxVwwKWL29rUP3arXH5XVKuvlhhikhm9grilJZ+qdnFpWEtYaCwvipTPLA/bLzeo3ykptJNqr2XvOd4/+4AkCXv7I0ozDGBx3GLhfVPzeq7BXQ6aeVw6GlTA6JCRF2dDpPwWAsAhHtlEyXmNzEmsJ4Qj79hM23a+zRc8PHRJ7exWi6vWZgUDoD1ZXCIeywGsw2xpIoP0RXmi1/k5lUWkNqkfvKx3YktMNkbdMQEK/1/BRiljnz0QKWCADPPTSGUBTG69TM2YpFv6QOE35TbV3sU5iY6zIQvaYqlXL72gjAjl4fb0G2aS6BiZEi6w1lVm58LlZpMHcp4/lafe6oVzNrYkPmsRVvAsVGVTiTvTD4LS+iVXLyzgBMtZSbTtlKK/aciwhKpclF/6WhLYK6+w/hYR7zcw/796vXiVoUV4abICoY37zF6HtrzjXrGxFXildZOiPqnChj21USvZli82v9L4psj9BElahn7pFJk9SPjHROxJ7xxQyhhtK8AojoDv4xeynXzHLWu5teK1XEwFlygAdlgqoCPhH+a641MRXolWwbGgIXcHGjAwZZ7sB1YQJ6/stXxWeJERWouGC0YtdOZPiCjCr7Aq6ot/6OWbpgkRbhrhB/05puNuueuastJ8BUMcr5x5I1wmqnY4EFyQUnRO2hgKVDgfUL1HLEq4Kub63J1E80t8tYHik87QEr4Qk1E4Lyf5KeLMG/mwddVLzQEGkzWES3DeQzhr6rUKAXzl+nWDDCzx2X/hc+X6amaNbEJMrz+3GJNZCni7nTFZP4xs38Ov8PnVtvvK6ezZqelaqsclv9SyfwWc4DeTFvuisx725sjf/zH67HT4eoNrmAIxrsf1bQZZHCKLichZkizD+3l6t0wQ
 13wYeroB
 C1BRyGK9Wcd1O4Kfy3Y8FW42pQH7S4R79cX3BITWcDgC9+yEAp4z6uWudr0akY7DryQOWzCOrbg6cuqeaihiLFHpuH1KtnuKBZHRKZ7wbwZHYba8/Yqy9bOUoAY7c7m9oTPIoSyskJTMkDMaHC94yXKGjBsTZOIiDeT2lSdpg6T08eeACNldHR8YgEeARfSRjj3h+Ka9hdhZARaGk+o8a2BHrmxKR8TN/seWetiPbn0hfhv1ZdQj0FmcKqfBs8S7bIZIUwAxIyUAllN+GMqjJbi8A880yVoWJOujJWo8wfJbaKkCBTxtf2UYvFF11PGgCt0WlgXXY0i2U9M1tczJ3xru2y1k+ivC+RRkcf61os+Rzpn5Fse72QHnajULDGz7cg9bYVBUvgsHk94Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function only operates on folios, so rename it accordingly.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 708343a8bf35..68018fc097c4 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1164,10 +1164,10 @@ bool can_next_page_be_processed(struct ceph_writeback_ctl *ceph_wbc,
 }
 
 static
-int ceph_check_page_before_write(struct address_space *mapping,
-				 struct writeback_control *wbc,
-				 struct ceph_writeback_ctl *ceph_wbc,
-				 struct folio *folio)
+int ceph_check_folio_before_write(struct address_space *mapping,
+				  struct writeback_control *wbc,
+				  struct ceph_writeback_ctl *ceph_wbc,
+				  struct folio *folio)
 {
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
@@ -1351,8 +1351,8 @@ void ceph_process_folio_batch(struct address_space *mapping,
 		else if (!folio_trylock(folio))
 			break;
 
-		rc = ceph_check_page_before_write(mapping, wbc,
-						  ceph_wbc, folio);
+		rc = ceph_check_folio_before_write(mapping, wbc,
+						   ceph_wbc, folio);
 		if (rc == -ENODATA) {
 			folio_unlock(folio);
 			folio_put(folio);

-- 
2.39.5


