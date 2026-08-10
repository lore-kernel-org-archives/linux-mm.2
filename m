Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ADF9C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3DD76B009F; Mon, 10 Aug 2026 10:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C146A6B00A0; Mon, 10 Aug 2026 10:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCF26B00A1; Mon, 10 Aug 2026 10:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 883E36B009F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1523401BA
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:26 +0000 (UTC)
X-FDA: 85085572572.23.FB2D5D1
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EF3F40015
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QE29lpQB;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371684;
	b=5L6/w3zOIe4wTsuk55TkXj4PpM4CE3+U25nlZFVgNeYaTSFG2M+HuIBPh1nLkbBtJ0lZ6b
	vUcE8N8hRMUxrbW79XhwMJulUXA2Y3xhYJ0kSrEfon1D1txmre2ADQs8xuYmYFCiSWLwpc
	qa335Q0l0RbCmhn8rCyIqGb9KXs8k6k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QE29lpQB;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wYX/ZIYKVfQPG27uMx8tOqEdGsdSAkMZMuyFrH1L8I=;
	b=AnIl3+sdQ3ZtZeDwO6TpTzyPDXeNo6+L3o3HfdwRN15DDQyfX2r8Guukk2YXsOonSkGrVZ
	y6f7srQi1zHU9TBbiNY6dKk5z8b70cW4VZ7w6rt2aVISeFsuJf9zGwAUiUzMJhTPuaoe/l
	vdGJaRqf9V+cLJ2lMZ1cBzpWZmQ8IFM=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaEdr056193
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=9wYX
	/ZIYKVfQPG27uMx8tOqEdGsdSAkMZMuyFrH1L8I=; b=QE29lpQB/ULYlNngi21a
	/hTWjHq6AZmD1jtPW4qIsTEUVkjzLRzyD2DepfK0JzhyI7UnmEptrsJ2EM1Jiatp
	930l2Adj9Cl8YlIXCq8v70vsP4kPoYlVYrCjZhD7o9N/Hg5Hawttp8xS1pxz5yyA
	tU0Hfq5fWnNyb2QXDXQW//vSN9M515bDPdIKyXQ67MfGCz63VTGRJlhEumOFuhXq
	mveUu3P3jcaaBXDl9JZensPr9NK+G+tKVBC8MLzutth5TpqpZLVlicpuw35fn2Ww
	fdUiRmfKanF+tCI1U1Da8edHrJKxx4LyRA4ArOgQi3zLi1t5TGtiFFWlnjHOlt9B
	Gw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fy0frkdcx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:22 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51bf321d786so24350251cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371682; x=1786976482;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9wYX/ZIYKVfQPG27uMx8tOqEdGsdSAkMZMuyFrH1L8I=;
        b=T+sH4tpQH6aGHZHmj/47/O0vvKs0HKVlwrqRWoyaDIZ+RCHEKPBZBRW03WAS6CfQRp
         QIEOU+82SCSSkcx4f3XI4MaaZBghJt1NV+8JD9G7PrlERiqDHF2aPSDoRyOWvqD3UGC1
         BlxiI/930/Ela/97TrYCyQsNfJYMRvhvqXVn608LU4klOV8PnYARpuQmSquwpEjdonPB
         KCJrL94ED06mzG3Qws071tlmuwOPU1Y7dXxxjG320t0ec5KqTF+9r6NOd3aqYmoX0Urp
         P+qo5qMAy3mS84qCP2qCoDNFfAInXRc9umK81ug2F4ViF5wFHbao/VUaBaRTJlPOhtqg
         LdRg==
X-Forwarded-Encrypted: i=1; AHgh+Rok61hrHuvEzmCISJkufckFs/Y1En5DNx3Uo1N8gYfmktDUU30nMKnMOsIqm4atKKytxw3OY0QMZw==@kvack.org
X-Gm-Message-State: AOJu0Yz13uVLdezxon6EYPo6bv7NQ/SOgryENmM2UyEuz+urWhaGmx7i
	0d2fzi2sT6IFMPpbf07bEee+aS9IRzNOLsM2lhDixZdT8pNZKInWQ+2fjpcaApuufhijIpQhUef
	LZ5OKWfEOLgCxxItfGHBeuVvHhcv8A5nrMJAfuTFY9o83njNb
X-Gm-Gg: AR+sD10xC/kGoNoQ9yalYvoGdxiegNBGWIWhDiZ2jOTIMBwgjQXVdl03d2unw5+VsbW
	If9NEDtfp3lFYZRvHHcPi6j06OOV9YplsmiNqh9FMHeqBGRq4Z+bNpnJVG1VQOnKiyd9xm1g2Tc
	iRCL4zQryJIyKXih2Qe3/GIPtPQF18Uh4V63gcks1m3VdACFU8Ig/Ao46gFeFtyXSQ2TYIM2hmY
	HC1Qr0Gl0mfZMlB9cQwaqEMPuTl2aCNR7BCV7l/xqaFt7ckEbDbY7TECsL0yKOCljhFhp7BB/JB
	x7ocfzudSdxMrfIvpVhjqFuFyje8so5jKsbSdF/ZT3i42p3SZfDMAfKFNSqyK4pr75xNqu9NyPw
	BUDPz0EbV
X-Received: by 2002:a05:622a:58c8:b0:52c:dffc:4645 with SMTP id d75a77b69052e-52d18e1a66amr253262281cf.7.1786371681872;
        Mon, 10 Aug 2026 07:21:21 -0700 (PDT)
X-Received: by 2002:a05:622a:58c8:b0:52c:dffc:4645 with SMTP id d75a77b69052e-52d18e1a66amr253261341cf.7.1786371681258;
        Mon, 10 Aug 2026 07:21:21 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:18 -0400
Subject: [PATCH v3 07/12] ceph: convert ceph_submit_write() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-7-dd7531704f26@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=4661;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kLEOqEnFcXW+rNVmQEljA3h0yllVd5ca9DQ3khlYlWQ=;
 b=joNh9X5mUvffrlxkKTmBkr0iWmzW7a5lLjSbuFRThbu6aArrCyt6TGzZNH/GWLmWekE58e/D9
 Y/+qkhPxIWUAoYE6Mj5KUz7ZnB0M9pwSraQitcVWKcL1lN5xiSjMjtw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: HoF0Gls1pwVKe47H-PCXxHye_lJY-BG7
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX2FFfXDMFi5hw
 rjbbbqUFoPQyHP6j6sjZF0nMg/hakkU5g+WFo293rQykEakoG7oQXEJo/Qh1mDMDKlEsccx27H/
 rJERiUE/uFLX7bXuZBBhEVr0zDW7HT25LWLVLeKiRsjEMaCGrLRU
X-Proofpoint-ORIG-GUID: HoF0Gls1pwVKe47H-PCXxHye_lJY-BG7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX3UkpmReVhl0m
 UiHbUNH4h35YRrC3PaeeExbLJeCIIFvXaWvZRzFOJGJ43elW4rGovHoycxH8EPchLfzkzoxZH/H
 duL6HCBxHL5zRX4MAHj7NSkpPyEclqYrTaO1igdhGVfINKwBWdy+g5pq5T6UUwQ9yrK0MZpkwJ6
 webyuxDqdKPlDuhLeH9tjQwsuUvHIM4Vo9+9P3Ucf673mtDpEffHlV01g33GyVrU4GmDbSvEFvz
 pieRye7G6e1QnGekxfctGBKNBAs2yhWXZIKDvV6b3Flokt9ndesNj1eyyVuUeJrLqqhfDE8PlP7
 AG9wOj9Z4PJW0NklL7jJAKnFOucIw5gRY/2g7aQDrojjwkNmaByiP+EdPy1bNNgCqqPmcXeDUDY
 hi1EoEMEOSXDiGBs+xXMD8x7lNyLjAYdty9V1qX7EONRDsTzXwJyWk/4xoCPd1jA/nm0Uiy48cV
 kppCLpA+eJhkYBt22nw==
X-Authority-Analysis: v=2.4 cv=L6YtheT8 c=1 sm=1 tr=0 ts=6a79de63 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=RfODlEta0-z8xtihUo8A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=10 adultscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=10 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EF3F40015
X-Stat-Signature: ykszd5n6ijrsfskz1u9qyhm39up89m5q
X-Rspam-User: 
X-HE-Tag: 1786371684-228968
X-HE-Meta: U2FsdGVkX18kcplOo5nacs8j5q9DYJ8RCPLrCF4nZn6ZFdiDfeaxhZs7tQGIKF0ot4OSctA+K7YXQcn8SMSl6NbAREBNKCMkefGfKXWqKEQejQf0xAxIh6xJV5t6y+5cOnSyT0PYcPVrfQFEljkmyv0sinj9ENe/GGspvYNRA1lvGZoakVhO5Znr5EvryDctX/m+O3k+jGTnv8ZaGB0W7XvyGKuYlwraT6GSzWzNC0LCvMswgjdDqRYfWxNysRNK5KDgu9RQcqC2XQS2kq+DwHFHB0QgOxxU4GkUsQ00OlXtkrWp3eG92GA0ZZuKNt+uMgWdhfmGEzkL8nn4OKo9QHEn2odxFAZZNPsfxar8I/4dvn+JZenjz58wm+Azb7oYr/dlcLeRefhSTCWwwD9gkeVKY4d4nSRP2HhD0Qk42RksgC4oYf31rDkc/fdRIptCGlLEsFuB5GBIXd2WF/8sU3J9LiCcDfhBfQ5Bj2VZ9m/YMQMfpm3WCCKp9Ii9dnLqtEtpQBcO2HwUt2srkZ+Tuogw2vOr0VIvrQ7+1sTmNnohKPn5dq0DqGE+IWPxTGdJIJ5Q44M5GSeX3PXD6NS11lZjniA5Y8TkZEIrJ/hgGYRNRqmM+zdzwFTOOhjw8ui4Fh3ZUSEWr62KPM1/D2u2h4Uc+emD9DFEb/xvLN5hitA24XPVUvfWUEH9NwEnxf6y/QC2GkYx4J8NWkILoa/ftZnYO19c7DO5685PpgTAiKgeE7JWawjX5YhmRuFNEZLgPD11Fpk0JAk2/dO9T9Vxf2eCgdoZTpQq4sdwz6OVlXVtl3Bx7MEO0iEyD08RhPQ4T+AyPVChs2NNRjsdtFe6ne7hD0enOXuemEUo9mlMvcpG9UCVd/b3Fj6krDOLA//qlFHtnqGDCBEvmpFkj3+93esFpo2NcuR2wCbaB5/LwRMyj88TsnfrtqpOwdlU+Wb5Uu8xEqPgxSArBBH3Ty3
 Ivc/jwDb
 j21afFl8KLhjJG8FtFenj7iDLqtCzUtmpOwV4KSqlu9oDcuDHzkFXQs2FtBKJD6D1NT4zDo7Q0lguJjjMduNx4i6MYE7RcqAjPOgAazwGr1xc708nG4dmwKiiJdZXQb+vCo8yVPS8/jfN9TNlJwySF5tMHGdC/Q1mPDF/qdR0w3U8qSpP4VqdiIkLmJAIudVQLsD0FeLMPr+5hQD7+mz7YKWexcAbVcF8PevdJagKDb0jwGX6I2VDsCIYbQCMYyoShACZUpotfxlFHnOG89oAdnqCyS1MfPYFd8ZMof++2oCf8sTsNoPch9CqiyAu1dsj62BslMGQcy52pRvEA+nCNcsZiUPQlLbZqEXIVHGACMSe99Ltfjbm9XxbZw9UbTzBUBnUnu+hDN/GAcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the request assembly loop and error path in ceph_submit_write()
to folios. This drops ceph's uses of the set_page_writeback(),
redirty_page_for_writepage(), and unlock_page() compatibility wrappers
in the writeback submission path.

Add ceph_folio_start_fscache(), a folio counterpart of
ceph_set_page_fscache(). The remaining caller of the latter in
write_folio_nounlock() will be converted separately.

In total, this removes eight calls to compound_head() hidden in the
page-based APIs, while adding four explicit ones via page_folio().

Note that get_writepages_data_length() must still be passed the
possibly-bounce folio, not the unwrapped pagecache folio, as it checks
fscrypt_is_bounce_folio() to round encrypted lengths up to the fscrypt
block size.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 28f0b16da2b0..a3324da08123 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -553,6 +553,11 @@ const struct netfs_request_ops ceph_netfs_ops = {
 };
 
 #ifdef CONFIG_CEPH_FSCACHE
+static void ceph_folio_start_fscache(struct folio *folio)
+{
+	folio_start_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_set_page_fscache(struct page *page)
 {
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
@@ -580,6 +585,10 @@ static void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, b
 			       ceph_fscache_write_terminated, inode, true, caching);
 }
 #else
+static inline void ceph_folio_start_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_set_page_fscache(struct page *page)
 {
 }
@@ -1448,14 +1457,14 @@ int ceph_submit_write(struct address_space *mapping,
 	struct ceph_client *cl = fsc->client;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct ceph_osd_request *req = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	bool caching = ceph_is_cache_enabled(inode);
 	u64 offset;
 	u64 len;
 	unsigned i;
 
 new_request:
-	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
+	offset = ceph_fscrypt_folio_offset(page_folio(ceph_wbc->pages[0]));
 	len = ceph_wbc->wsize;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc,
@@ -1479,21 +1488,21 @@ int ceph_submit_write(struct address_space *mapping,
 		BUG_ON(IS_ERR(req));
 	}
 
-	page = ceph_wbc->pages[ceph_wbc->locked_pages - 1];
-	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
+	folio = page_folio(ceph_wbc->pages[ceph_wbc->locked_pages - 1]);
+	BUG_ON(len < ceph_fscrypt_folio_offset(folio) + folio_size(folio) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
 		for (i = 0; i < ceph_wbc->locked_pages; i++) {
 			fscrypt_finalize_bounce_page(&ceph_wbc->pages[i]);
-			page = ceph_wbc->pages[i];
+			folio = page_folio(ceph_wbc->pages[i]);
 
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			    CONGESTION_OFF_THRESH(fsc->mount_options->congestion_kb))
 				fsc->write_congested = false;
 
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-			put_page(page);
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
+			folio_put(folio);
 		}
 
 		if (ceph_wbc->from_pool) {
@@ -1519,8 +1528,8 @@ int ceph_submit_write(struct address_space *mapping,
 	for (i = 0; i < ceph_wbc->locked_pages; i++) {
 		u64 cur_offset;
 
-		page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
-		cur_offset = page_offset(page);
+		folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
+		cur_offset = folio_pos(folio);
 
 		/*
 		 * Discontinuity in page range? Ceph can handle that by just passing
@@ -1553,12 +1562,12 @@ int ceph_submit_write(struct address_space *mapping,
 			ceph_wbc->op_idx++;
 		}
 
-		set_page_writeback(page);
+		folio_start_writeback(folio);
 
 		if (caching)
-			ceph_set_page_fscache(page);
+			ceph_folio_start_fscache(folio);
 
-		len += thp_size(page);
+		len += folio_size(folio);
 	}
 
 	ceph_fscache_write_to_cache(inode, offset, len, caching);
@@ -1569,7 +1578,7 @@ int ceph_submit_write(struct address_space *mapping,
 		/* writepages_finish() clears writeback pages
 		 * according to the data length, so make sure
 		 * data length covers all locked pages */
-		u64 min_len = len + 1 - thp_size(page);
+		u64 min_len = len + 1 - folio_size(folio);
 		len = get_writepages_data_length(inode,
 						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);

-- 
2.39.5


