Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A619ECD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB7C6B008C; Wed, 20 May 2026 16:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1116B0095; Wed, 20 May 2026 16:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D672E6B0092; Wed, 20 May 2026 16:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C75706B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 939C71C02F6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:39 +0000 (UTC)
X-FDA: 84788991798.10.3F7BA19
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 42AD0C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CxuJGpWL;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+gjtILqDLOQsRHv/xOkAmWQ2cCtCFJ6veJFyW78pUo=;
	b=wxS8oIfzQrrJCNFSElYNo4bN3QpsV0ZczKx89BS+LhgSqJ0bvpC/qhfTtvkx6p9C1d2oIT
	nQxlt0FTzEliyFitkVh0SV9tbaWX5b3ZIzBcCbcvZxl3PTkBEztrLqM7Z/ALVVhVWKxIM6
	0CBbsRC8ylMli1h9FFjcseqDfLZ4EZ8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=CxuJGpWL;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310237; a=rsa-sha256;
	cv=none;
	b=3W4Y/83ggsju9EImO3GEztSrvb5Vr5XWODTZJmvaDkXsmUnZ0ER06E6bbEErG0zs/WJ6A0
	Yrg+SUlIRmRmR8CdKGs6hHlzjn+ZMeY5+iFQAMF6kRSpR/FT3ASUstmt7Lu+wz5i/NpW7U
	TwJoINRfRtp1CxK+0VFOhoTLJ95iS4U=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOAjt2145156
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=y+gj
	tILqDLOQsRHv/xOkAmWQ2cCtCFJ6veJFyW78pUo=; b=CxuJGpWL+kS84wunAt9h
	U/LMKliWuP4nB71UXrm5g2rej0P5N7Idq6BmiNfKDH80LLeVfW44ieNa0/BkXXsi
	+L9TIuteWD2e2V/oKCwp2pBm8/BevB3hAA68MBGegIkV4f6lcMhzEeWtaWIZ/onj
	AS5ayl3chCL64tG3bR5sORVXXnch8+A3TP6eyrsP+oZjdBtNP6ga3aSMnRwc0p6/
	BYV5Iilum2otM/TkKY8H/+zERGVJ7saJ/nflnYcYRup6RXfZY6tt6SAiOZhn8cYW
	OdnmFxoq6yyFwNO6fg+uSBMB8Kt/ndgipMDZ0G1TcX+iqata3s5oeMrGTtuoq5nS
	pg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9ccqvasx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:36 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90d175ae5a0so587765385a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310235; x=1779915035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+gjtILqDLOQsRHv/xOkAmWQ2cCtCFJ6veJFyW78pUo=;
        b=TUquvPG3Ofgcd7jwC44CBCjJupuWmrQFp6w206YItalCWLzwgzb6T3zK+w9DwVMDKj
         AEbM8XHJ3hsBD5gytP7EoCf/r9UrQnBCs8TYnKKL1IJr5bvyV13ngOjL04PCHarTfTsj
         57AWKWGqjomNzHfb12mV5eo9vQUqpKZr1OXFWMFq1xglyMNIUfg2zpZJA3nwplQKxqPt
         9/ZtAp44Z6xoaekZtl0j0/Vs+ImKU8D3JMxtv7QkwoMoFNuIV8O9HDaQqQgX2F2xK3Vr
         y60YesE1LH/hZ7xSskjnAvVv2AWSuo/4a7xAbDg97WuiJgCo4bAywU0v0+qVtHOQrbaj
         7nIQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ggffYyPvj+UvrxKzvrDWbdEwSHPT8eMMYZ/p602yVzUPgVNdl1S74AzLkLqUP/GckfsSGBsvNuQ==@kvack.org
X-Gm-Message-State: AOJu0YyUsAOtG/MjhJbMB9aWJ+OuSXAgKMpTGJIR72zsIB6GL/3BIlk8
	1W6SAMG14mFiJHRnM5kbM8fMRPDDHHkXn/JfuucgRa7+kI3NO9wCiV0aMgOdIRpEm9CYOgzotTf
	l2pB5J5n1MqflyNcPeTQsE1RzbUmy6mVpi2bp6nrXMWsOw2gB
X-Gm-Gg: Acq92OE9SxajO0uvHgXCZ72oPTrl/KRpJWMfRiqC4Jp3YXzh1sSFaJ9O/pDhOp+zMEY
	Beu8Vo9XhOrQKCeijOyO48ZgwgcK3o5choPovR0OXwkHRyHl415DBGRKmHpV4NQ0O/JFBvJmG/+
	gEe15tFrJiP3INgNpz+R6mN9Qea4TzqRq2xB+oebHkzIzjU9gdFzRjQkXCjhkWGTIN1NOSAvoZr
	wGUQjFrh14UxS0sfB1TaeLhgxnu7QDR25uNlOg1iJgtNgcWp8CxI4zQpeiFBunXZAhZHvXjyrTN
	qOfVUdCkbSTyEqAWvw6BfWLpkmtxUQsiIN4zRCECwBGEc0PAvXa6hoVjkhpBRTh9Ww/RZL2ie1C
	k76uhIM2guZZGskwQjYLjGaNFAXId3jTx3wcutEqwKSIul7Ry1mqhNUOpAfPV46uALhM=
X-Received: by 2002:a05:620a:4542:b0:8ee:dc47:3b70 with SMTP id af79cd13be357-911cef062demr3495259985a.39.1779310235407;
        Wed, 20 May 2026 13:50:35 -0700 (PDT)
X-Received: by 2002:a05:620a:4542:b0:8ee:dc47:3b70 with SMTP id af79cd13be357-911cef062demr3495254485a.39.1779310234746;
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:55 -0400
Subject: [PATCH RFC 04/11] folio_wait: move folio_wait_writeback() family
 to mm/folio_wait.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-4-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=7803;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=MdnqSRc2FJHBhrARlYsy3cs/9UevS5fEoCvn0pE0sDw=;
 b=rkMG4EwgIAXfDMJhpCN/bphiVIHAebicxGt8s33PBw5nTp2DJPdH7PqP6gawcVTAxyPkOdXvw
 WsorbnVQOqHC4h13v+JdnPOZqm2wLrEZ0r4jbfVOfOBi4GxGI+ybNHp
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=XJQAjwhE c=1 sm=1 tr=0 ts=6a0e1e9c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=oq273MN9QaURjshXV2UA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: wlFu6af2b2YYfvLEGjQRv67w93uR32kv
X-Proofpoint-GUID: wlFu6af2b2YYfvLEGjQRv67w93uR32kv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX/gXu0QKgw6cY
 UwPySWXJ5BLrRP1bIXcDzt4nDGG3T+Jg4DTFB/SGe27HIDUjRX4M7HCN6GVzsXJwlVVv7rlpnBi
 DcyEQNq07noz5qmbWD70Z7ZBKLJP1CxXeIIFviS7Qr4iw8+CPOi71G0xeEpg0HAT0KX+ZLs3MeS
 YyCnUsahOew/gposXPaoirgT7gdqhyePn9OuEJdSPTQLiSf3lXBNPCdtwyyfw2dZj07sVyeZYw8
 Y97v4t4JRIuibq0Kv6rys0V49o9d9FTjg+QD02fd7p8u4dzoCxCeGINs1wRCgtT2GGsE9SonHT+
 We3AMKkXG5RQeZCNIc/tXaGRYEGqjD3LgbJW4nbCh/Ak9DU6RgTbr+LMi9b4JwYJxdv9SHnCbFe
 jdPlyuTFXaktymaOyGe2OxzOs7YiDSpjI8xJRYoieAHorocepbhuXIAUS941PnqCHX5Opr+Z9Xz
 IlMxj6wlJF2C+qmqg2A==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=10 suspectscore=0 spamscore=0 priorityscore=1501
 bulkscore=10 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Stat-Signature: hkyup8rrpdp88ug1661mfxogk1wk5ox5
X-Rspamd-Queue-Id: 42AD0C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779310237-231625
X-HE-Meta: U2FsdGVkX1+HIeRe003DWBlnVYn8XkAD7nX0Qd0pNz0C1ly75TsCpkUOI93ykEWON6UK17+WrzJ4R6z5fHa2Uh5mBFeIcGRL3adjsXY/sTddTbX0or/QAJjO7qQbWJCLjUwvKwkF+F4qVJg4MJ4oqHZJB+EuaCWReudul8ovUn+q/WAFWhm6QSs+tgJ0iP8nBo1daFdY/z0XQf2MFptLkcmUDZX8djEPmjyO3i01FyiETMrG+QZFHp1M6Lw60yxqiH/fy/r2OtvpFZowQWNDVBnMQwRz52h3QrlfKqDjcz/KvziHDL2FCK3tEAztWsyrlK4jVGCdqjySHXFoaOfP6O2ySDdH/paO3WvhkbuUmSEymGsHPSASJEdej4pjtdJRifXIQvLfs7c9nqTnTchN0/fcTRXGnRImJKZgUy8A8SV3AMKZBOV/Xa8QwvlsVs5/ywCMQg6dgTUmSi0bBB2aV6Eg+ekbBvYuy74mpHTGe1I9L6v4sI9O4ksiYBnVGUB05sUZuzTsy4980JbuKQm6hXUIjRtcn2rA0/3Yik5jaER3wvffiMpyZOe2RDZrvwNnF2Yp/nTFznL/W70kaZM7GXRDp0gNivgc3zMeGKGVKLGa2AY3pgNX994h9SZJijWFNno6+i4UcJSfcKw4YhB9vCbxLrO0S19SMLlj5uVsqzK0Nkc48ELu7Z3KF70XV+HBWR06TYaqc1m918ExjKSf2+nT66Xd6SwfEFylNVCUcS+aQ3BOwcvGVJD2gRDzxwZxahOaYmZPjZ7x5QB6Lf6BfpdpIKcfNabw+Di+/Ewpv42qzZDQjj0rVfZvggH8DzeXZKsHBcXdQrw0Wtu7TNJvcuDmD4ZJEC6lpqmvVy5oglq/j5VsQRlZJyftcswS1G9sFQ8vaNMFBhAJdxsVDEowiLRoM/7QAej6JhPZXP2rJktaAqtCv4zpMAAJZIt/vtglIsRu+JXYkv7Azg4EBJz
 mmurfVVc
 Ak91C9bFlW08IatkCBc1AdKf1zBPtmtgqbZEbj9LGiHuxWtgltv/S2QhO36c2hY+gXXdj1I/f4nmj8LJSEBbkY8cih1e86U5wAUzR/14XLneWjXb8RNMCZ0lXm7xhOJEzRmYa13sr1XcuhrMNjxHaWn3eqIm7gTUIsPQdeAflPC6LTo8Kh2wqybq5JVp7zweiRx/sUmgo1Vm+pyv05COzH4iiY7QCfOPX8y+hHw9MQOZdD5JEq/K8aa1zWcBjMk0LnNYhfiTe3Lw5gunbLZ7rsNtgg6iBVrF5yHpsv5TgHf5sGNr/wSHOH1OtwrwMc792CZjgzpEIbVdxBKj20iLa4jef+2bnCequMpXpdQbN55WwLyi2r7v4kJiDzJhXgArycaADRDFweCliP3pi4Q89rMwlF022Rs0+daEN2rvreXifIQmQaOluZzt0emJco+vR9b2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_wait_writeback(), folio_wait_writeback_killable() and
folio_wait_stable() are thin wrappers around folio_wait_bit() and
folio_wait_bit_killable() on PG_writeback. Move them to mm/folio_wait.c,
next to the rest of the folio bit-wait infrastructure.

The legacy wait_on_page_writeback() wrapper stays in folio-compat.c, as
its days are numbered, and it will be deleted once the remaining callers
are converted.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h |  4 +++
 include/linux/pagemap.h    |  3 ---
 mm/folio_wait.c            | 67 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c        | 66 ---------------------------------------------
 4 files changed, 71 insertions(+), 69 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
index 80ddf1ffcae4..4a5cb2fcf046 100644
--- a/include/linux/folio_wait.h
+++ b/include/linux/folio_wait.h
@@ -178,4 +178,8 @@ void folio_end_private_2(struct folio *folio);
 void folio_wait_private_2(struct folio *folio);
 int folio_wait_private_2_killable(struct folio *folio);
 
+void folio_wait_writeback(struct folio *folio);
+int folio_wait_writeback_killable(struct folio *folio);
+void folio_wait_stable(struct folio *folio);
+
 #endif /* _LINUX_FOLIO_WAIT_H */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 7f65c2b0097b..84ccb682cca8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1074,13 +1074,10 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 }
 
 void wait_on_page_writeback(struct page *page);
-void folio_wait_writeback(struct folio *folio);
-int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
-void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 06156e138c09..9d3328717bb3 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -15,6 +15,7 @@
 #include <linux/delayacct.h>
 #include <linux/psi.h>
 #include <linux/migrate.h>
+#include <trace/events/writeback.h>
 
 #include "internal.h"
 
@@ -572,6 +573,72 @@ int folio_wait_private_2_killable(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_wait_private_2_killable);
 
+/**
+ * folio_wait_writeback - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ */
+void folio_wait_writeback(struct folio *folio)
+{
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		folio_wait_bit(folio, PG_writeback);
+	}
+}
+EXPORT_SYMBOL_GPL(folio_wait_writeback);
+
+/**
+ * folio_wait_writeback_killable - Wait for a folio to finish writeback.
+ * @folio: The folio to wait for.
+ *
+ * If the folio is currently being written back to storage, wait for the
+ * I/O to complete or a fatal signal to arrive.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
+ */
+int folio_wait_writeback_killable(struct folio *folio)
+{
+	while (folio_test_writeback(folio)) {
+		trace_folio_wait_writeback(folio, folio_mapping(folio));
+		if (folio_wait_bit_killable(folio, PG_writeback))
+			return -EINTR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
+
+/**
+ * folio_wait_stable() - wait for writeback to finish, if necessary.
+ * @folio: The folio to wait on.
+ *
+ * This function determines if the given folio is related to a backing
+ * device that requires folio contents to be held stable during writeback.
+ * If so, then it will wait for any pending writeback to complete.
+ *
+ * Context: Sleeps.  Must be called in process context and with
+ * no spinlocks held.  Caller should hold a reference on the folio.
+ * If the folio is not locked, writeback may start again after writeback
+ * has finished.
+ */
+void folio_wait_stable(struct folio *folio)
+{
+	if (mapping_stable_writes(folio_mapping(folio)))
+		folio_wait_writeback(folio);
+}
+EXPORT_SYMBOL_GPL(folio_wait_stable);
+
 /**
  * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
  * @folio: The folio to lock
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 833f743f309f..50f548bbb375 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -3042,69 +3042,3 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	VM_BUG_ON_FOLIO(access_ret != 0, folio);
 }
 EXPORT_SYMBOL(__folio_start_writeback);
-
-/**
- * folio_wait_writeback - Wait for a folio to finish writeback.
- * @folio: The folio to wait for.
- *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- */
-void folio_wait_writeback(struct folio *folio)
-{
-	while (folio_test_writeback(folio)) {
-		trace_folio_wait_writeback(folio, folio_mapping(folio));
-		folio_wait_bit(folio, PG_writeback);
-	}
-}
-EXPORT_SYMBOL_GPL(folio_wait_writeback);
-
-/**
- * folio_wait_writeback_killable - Wait for a folio to finish writeback.
- * @folio: The folio to wait for.
- *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete or a fatal signal to arrive.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
- */
-int folio_wait_writeback_killable(struct folio *folio)
-{
-	while (folio_test_writeback(folio)) {
-		trace_folio_wait_writeback(folio, folio_mapping(folio));
-		if (folio_wait_bit_killable(folio, PG_writeback))
-			return -EINTR;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
-
-/**
- * folio_wait_stable() - wait for writeback to finish, if necessary.
- * @folio: The folio to wait on.
- *
- * This function determines if the given folio is related to a backing
- * device that requires folio contents to be held stable during writeback.
- * If so, then it will wait for any pending writeback to complete.
- *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
- */
-void folio_wait_stable(struct folio *folio)
-{
-	if (mapping_stable_writes(folio_mapping(folio)))
-		folio_wait_writeback(folio);
-}
-EXPORT_SYMBOL_GPL(folio_wait_stable);

-- 
2.39.5


