Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C38C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1FB6B0096; Mon, 10 Aug 2026 10:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3216B0098; Mon, 10 Aug 2026 10:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA596B0099; Mon, 10 Aug 2026 10:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C13F26B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E3E31201B2
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:11 +0000 (UTC)
X-FDA: 85085571942.30.780BB7F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 87056A0013
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ccHuRGEe;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUdJ8GftPVQWe/bytIhh9qzgnz0Y4e69yuiSB69qTBw=;
	b=geuzO0vwHcOh8qIYNfcsjdAAJHKvT0JuUYnDA4M0jGj8MYMKKZhqT6aIWu5rtf5FSCOfhI
	gwY/jmtH+RAa38gK/hC90fMOCYrZm+ubReCqGiHz2B8Vrb10LwbsioZEuSOUp1uVJgh+mf
	3ktC2L9u3cxfv9FhYS3YVoihhoR/bXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371668;
	b=H/NuvI1hbyre+6vEGd5qGioBDFcm5aSDVezCHdW/kalSiRoSh0uMWoovtaL/oH1Yi5FnmI
	RNqe6EzdaWCkvbUJK+yP4VfJKuFp8bBc8G4lmdfXDAn2+RyYZw+Ribg9twxczG+Kwxiyft
	tTFncWTdRGgrURtCjj3gb6QnnNIw7z8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ccHuRGEe;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaC3W055931
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=lUdJ
	8GftPVQWe/bytIhh9qzgnz0Y4e69yuiSB69qTBw=; b=ccHuRGEeALBOBGJMKv6L
	A5Til3j2/Eu/yO/cO8rSg5+O05x+lVf11ATFBAh+1d8SkfsYyLcuM0taPN8BRW7h
	Ihj3MmagLVOT/uSeoL8BH91px9Pzph+LZ2Hl+263w6kka3H9tK6BR1TLpJTNAazs
	x+pz84aOE4pSka49HRgte8Hp+KH3UiuinLP4FiVwIfxcrM/i7WwrFrR29/GjiiRE
	NRCtBDXC95QVSifxpU3sgrL7T0dK3HMcnFqlCYyyZZjDMvLrIRf4nhTpNNV2yRO8
	ewO4Txvzcfu+W7mt9oUdEAXr+7vcv5qJNF9sAYMGhbVFDjv23ELqkbTM7K1INQcU
	Yg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fy0frkd9q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:07 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1d137a68so44550911cf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371666; x=1786976466;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lUdJ8GftPVQWe/bytIhh9qzgnz0Y4e69yuiSB69qTBw=;
        b=GskTKgAoY1ZmQiFEQWMm4WwfGYT82J53raK+iBGf0fgsoxLQllUko6auItOUVcqoDR
         FNxOBuL6VCEU80YlNBs6JFc3ProExmozFbZeAm9RnYDogBgf35r18qT9EKyRtyHhFH+i
         EjT8JSEM+vyS4JoSWfeAEB60wRARfvl3f+hPcNW0FUGbETVjuWLkjOBgF87eBLDUsmOf
         X5OnJTZf0OPDQ5ZyxzVFLqaNnBUiQVD1I7Qg2cT+yxNJ2k5AO/6FD4Zwgau+yuYMskK+
         Ojb3+Ri52vvyvwBc9Z7jBS2f+nbXWGIiOgSZiKvd6OQJG4t+vmy95xSv6WiqWDOVye2b
         TQLA==
X-Forwarded-Encrypted: i=1; AHgh+RrCxUcpCeT47+B/yjbSIK4LqizXozTSclWI5HimmL4BgpUIZ7raIuMjVGxU6AOK+cZDp1O+CD6o3w==@kvack.org
X-Gm-Message-State: AOJu0YwSDBzGQKlC6m6lhwpr0JYJK2CbgRXsp185sbm6Sr/RleFJqe5a
	ov4MPEXXhXmufcOb31wCYJ6MNJfKMU25IEpNaECP6FOhMOi4RPx9PgaI9xelhfpTsQqbX3EOg3v
	5FUmS7yoxCnJZ3t5c5RQm2RqheZFn6FN8xXrHAq+L4+NRa1/x
X-Gm-Gg: AR+sD11vPolAR3EfI75AUYdbxnIo43E9dWnYYwuSOYqwuu6gTWf31YszH81ED8dxOn9
	wRoBvcnRJ4OcwJ1bu+2N1u6Y3j7Q9w13rfIcR630CMHHSM75PDNkM3ptXR8E9cy3XBl2Z4xZKI1
	F6yXEbUKCUFO3zDa7eoz3KXyF1xfdMJwYc51EC/V6uPZivWxsudbEcdXVLjknfWBZ6A1yqLdFRK
	zvCNHn2r0kTAbWNJhJPR1H13WyJk5ESZM4pTqt/lrS/7DKEyWoRG4yoKh7aPO6WguHIq7HjsFFn
	UyL6nrdj+rIHDe1bHEOeTTdxpe1OKpC4fXnHrzAyBldlCalyQNzBVceSrqXIOFNv+btrGEISnxS
	kZ7r8J6bv
X-Received: by 2002:a05:622a:a0f:b0:50e:635b:5579 with SMTP id d75a77b69052e-52d20975cb7mr245780371cf.19.1786371666021;
        Mon, 10 Aug 2026 07:21:06 -0700 (PDT)
X-Received: by 2002:a05:622a:a0f:b0:50e:635b:5579 with SMTP id d75a77b69052e-52d20975cb7mr245778981cf.19.1786371665399;
        Mon, 10 Aug 2026 07:21:05 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:04 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:13 -0400
Subject: [PATCH v3 02/12] ceph: wait for pending fscache write in
 write_folio_nounlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-2-dd7531704f26@columbia.edu>
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
        Tal Zussman <tz2294@columbia.edu>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=2136;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bC/X5LUNCwcfzqxhGB05BNOZAidcTm2p6b14nFOUhtA=;
 b=p/ml+Ve4lftJD+H+kNATKF2FjQfAQG2I6SrAiFbDZQLHfjVFfFFrODbMCdfNhfz5ZM35qVRfQ
 /xPdai/ySDxCiFP5iaL/zocXJ2PC6z8jt9HKL1MXrWU9AH1wPz/l1MU
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: GA6NPNes9zXLYHwbB1iBBQNpNivTZTII
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX0MsCYQFNpfKH
 hhPMHnMcRp7Nk/I6avAagrta/OjFZHT4b/qN8gC2vBUPSUHo/XsxbiQ/QO4tIt29Y4bIfBiOwQz
 6XBgeQFQuzTCB+E8JzWRvh4mL+rLDsl0Yvcf3xVcdWh+pGk88fww
X-Proofpoint-ORIG-GUID: GA6NPNes9zXLYHwbB1iBBQNpNivTZTII
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfXzTc6yegcr6MZ
 wREhCN7ISKOiReNORbQCdez9c6zClpTsr2jrToMUFmplgoF3UKhtmy3CT5PoCouV7lBeoSILMsQ
 XwMkasqoywaPglAlwuXHjRSVMiUe3PmdLBkWDmZG73wItlCxl+r57BUFe6tqIEIOq9CZFpE2KDF
 pvklL4mBO6+fd99pcGLOUUX/OAeMszCvHheKuPLQcD08ZBWI5J+aVPsaBXihO14uAnj6wQ5jiwj
 BU2EdC+R583H3ksBclut8OY0r+/uXnlE2qDvIGmGWRBhBMegqyOHMTuZvIVmNr3aFcXF2eQTyLj
 0EUppmOe5dyV9amG3AiXuipMdIxNRjg0xmRFqkAbM1SriUW+H3On6QZSrkjducuqTt+7BndZxn+
 Cx3SL7BKLlD129pRuq3tlR6qfEmueepvUmdzR2Yq7LHggkef6VuyEz9TLyvFISFMZYU0AXf7JAg
 px+RwMUxADS3iJClz4w==
X-Authority-Analysis: v=2.4 cv=L6YtheT8 c=1 sm=1 tr=0 ts=6a79de53 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=c92rfblmAAAA:8 a=VwQbUJbxAAAA:8 a=zYp62tllrndxtlEyWVMA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=10 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=10 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87056A0013
X-Rspam-User: 
X-Stat-Signature: ds1msos6p5nf4ne7yu5d4shgnya13kdw
X-HE-Tag: 1786371668-826689
X-HE-Meta: U2FsdGVkX18Gs5jqekeuH3rSvqBKdVvm7XpwzuZEp4EhZRVCkBiAoBEqIlPtX6FhlbHMWF+kuivbGFaASJyCSt4LmWlRYSzqYLqcN8mgysv7hLlzFQhkCiZOkjo3Izdsf5vVoj3NU4WtrFCgWIvwbxl23nKxXrJtl9mRuIJ8XwOkOKBfaqFaxPHbDdLUfVvtMUCs4tgQOPYPKbp6oA+PaU+zaetYgf6vSDMKpC8dhwziIiyStYbXO3ZJmNNpdQzOQx8gVjdovpnCFG43k4CG+cwv+JxKDVuK4H2tDffu8xUqod/slzmNQ7yDstixGpi5/++W6+PrJC7FVLgjDonkIYWHMb1Tl3MQLdV3N7IJl3++ZJjfhp7buF9dySA5Uo+KOQuO48XDEiIhQue2y0fJ1/O84b/2jb5JuZHXofvB69Mq4/UWV8+8i0utvK1seqj3lqTUh4mPU9IGbdeH+NvvkdhTUCDiVVRRDh35RqSGjTrG3wlx+/i+2Jri+KeQQtWrJfe/eThwNsUbUZ+9gKe+U8xtgAjvJf08R/r0bkA539Ici5Hj2VnZ0L/bkt/0igOTkRypl5y5EtWrGYpJTcvxh8sm3YHK1I6dZ344vomv3HGvL/TOLuJnQXPlgu4gaBuFUm2e8Fg+MevguqHaczrCSU8hTSjWyOxQqpUbj70YzHOehBEHJziFZkJbFBvWrPCE0Yl5ZQY9wwvxNuPzZ14uDP+6/HTRi9z/l67PMRaZfI/LOcBhaIuRpcaqUoNyruoVf4rDD8bISLXZfM5biLOghyzqrFwaBIkd4bDpbuak/yRbBYfHoYqHvDMcPrDqRGbdQokwVMmOwgq1FK8LNKiOmf5kQvz6QLs8uvH9w2cKH+xuEN6YGbrMtJfezcpTGscYj7XWsCmrTYUBkmmhZ71HmUL1LT19ATu2Vr/BA7yx90d5AXyfgem98/S79e52PGdh2Cx9uEggDTG+5b/oBhO
 FOjWXxLY
 RDPKX4uaiNOlMMSMpAjLJgvGwErz/qx34fKtqyESp1zCxVpQee9Arfprx1EUWVYia7LNrccq7L7dfshShBsxZ0m30GOY+HPhr2DN1YL5UpApn9Rhv64j3QlB8iL7g73EUeWzZ1F7EgJkem2w01hwP66lvrszm6I24DJ04lUk7P9w84FXYw9xZB/Sx9nqUgsvXoEILFSFrcFPeoutZtvSoShxNT7BcockmufsJrsP+wJzyK6toCpA728dXG6UUnx1M1P6tPezwVYa4aUSXwkP2OhRuXrGb95aPonnmHSp5JO+N/hzZE41LmdYJnNrDWqyP/YkHDT7i68ynYiJx14M3DNpMIkQFdt/5YRePNGZTjDh/UMcULazZXv293iomX+uG51w3TZTq+w95h+XFU9sFJ0/J1EWP8cU81IdOxelFiqkhpeigpOihtpGQItAL3ZoDnfwhF8xgpVFs4f5iZcQyz21N7OGdiF9++MRz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

write_folio_nounlock() marks the folio with PG_private_2 via
ceph_set_page_fscache() and starts an async write to the cache via
ceph_fscache_write_to_cache(). PG_private_2 is only cleared once that
write completes.

If the OSD write fails, the error paths return without waiting for the
cache write. On retry, ceph_find_incompatible() would wait for
writeback, but not for PG_private_2, before calling
write_folio_nounlock() again, which would trip the VM_BUG_ON_FOLIO() in
folio_start_private_2().

Wait for any pending cache write before starting writeback on the folio.
Add ceph_folio_wait_fscache(), a wrapper for folio_wait_private_2(), and
use it.

Fixes: 1702e7973410 ("ceph: add fscache writeback support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284%40columbia.edu?part=7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8cd24f66c981..de0113b23940 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -559,6 +559,11 @@ static void ceph_set_page_fscache(struct page *page)
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
 }
 
+static void ceph_folio_wait_fscache(struct folio *folio)
+{
+	folio_wait_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_fscache_write_terminated(void *priv, ssize_t error)
 {
 	struct inode *inode = priv;
@@ -580,6 +585,10 @@ static inline void ceph_set_page_fscache(struct page *page)
 {
 }
 
+static inline void ceph_folio_wait_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -803,6 +812,9 @@ static int write_folio_nounlock(struct folio *folio,
 	if (wlen < len)
 		len = wlen;
 
+	/* wait for a cache write left pending by a previously failed attempt */
+	ceph_folio_wait_fscache(folio);
+
 	folio_start_writeback(folio);
 	if (caching)
 		ceph_set_page_fscache(&folio->page);

-- 
2.39.5


