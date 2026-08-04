Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF205C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBDA56B00E9; Tue,  4 Aug 2026 14:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D733A6B00EB; Tue,  4 Aug 2026 14:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35B56B00EC; Tue,  4 Aug 2026 14:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8783A6B00E9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2581C801BC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:58 +0000 (UTC)
X-FDA: 85064484036.20.1B65730
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9BD32A0013
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P7C0CHDi;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXGGw2at+L2vnEOc5GYny4bpp2wSKxYA9ebiI09IaVE=;
	b=P7Kky/Dm6KK2ds1uNwMo+qFIEtPVz474491mE67uagUeK2PG8c5r2z8avc4EAtwonrP8r9
	lqNWj4v3YuSoWEADVyg0RT0DWJG3Ap2FGSVaTVIgHjWja108FbPmDLBsDS8OatslXzj+IH
	GydnFQn61KhvhqxS+WDntIjq4L+LJNI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869575;
	b=DOZM65vgN8Td4lWhdVQf18ONwQ8/72SP4K3s7EFxn91w9CiLaCFjsfVwBeWraSYWjsUQeQ
	JbhFDrjUr6vgEpRyaMp95PQ5UFha3F77DrxSUYrR1Y17CerPykwLow2LCnzP4wKPSLFYwi
	P+9DubvyINL3xzj182fZwPM6FjDDp70=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P7C0CHDi;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYOYO2598213
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IXGG
	w2at+L2vnEOc5GYny4bpp2wSKxYA9ebiI09IaVE=; b=P7C0CHDiaLIMwRlERVCQ
	2JS5t1syYGUmkwtfAi4bkz3mbz0/zBvmII5X/9F7bQopsz6mbaEwVC/gm4Cxmx8i
	N1jgbz26Hs6k1PkFKqKmzWfR2gFjWsHwNImqgzJmhoIteaEpMFp1wDv40+vHf6x2
	+m1YVI8YOAHYv94djGb2Tg9dQN/K6CnSKWo17X51RkWmZevfH35nQ9TrYeztgRI9
	hmB+IJ2rcRgYg7iXpx0WLaXmWo43pAzj2TGNgWgKjglYg2D6Kx8xzhlN4yiL9gZ8
	/yhLAlgaZE4a1r156ZckLlvpA+VC0x580HwCaQ5OnIXpW7TdO27iVYuMBJfHaa5V
	jQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fugvvapfs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:54 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c20762d21so1325061cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869573; x=1786474373;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IXGGw2at+L2vnEOc5GYny4bpp2wSKxYA9ebiI09IaVE=;
        b=IbV6uUCO91HPVxyGNHeg4kYInLiWK5i/EVAIVJiGgf+z08knMyQ8rb6McpC2EpEcSv
         rlhSU+3Y3hyFZSkaEjhf1wETeV1YEqIU2RppfGSaTt2iPhFmKI+iukjsS5kdRgRYJ3xo
         09u3TnXOFw/+kFMDanrJGgD9tohScigcQXKMoDdxFotgRYW4VKKZe48EywHpq2fMS0wn
         oAQLQQ/LQWHlJeXRo4pNhhD0D8ckasimYjACpAEMb9nHGnT9kh7MB3OSqNcXtWmtGAPi
         xbFVWGV6/rl3mEnY24bLlrPvcubNLTs886NTYVPdTES5KOjTKBCjSSl8mcK5/rrHXE4L
         yhTA==
X-Forwarded-Encrypted: i=1; AHgh+Rqrms1U9yU6NPJtpOUC0L3cFaCLG6A9iK99aR1tbg/SCChnWyGvWfsf+ug6OFPEe1FaFoJB8CZ82A==@kvack.org
X-Gm-Message-State: AOJu0YzXpOY7Rb8triM1PYMmbwponGYWBuZf4mDADFW4IiDxZy+ifdQ8
	aMvRCLeTF3jKLIhP+xX37QL4DNAlBZM86Q3izwt4kyjWF0x2zP3CM01m3Dn1Y/h8ZNX2TLzHVC+
	5BSaERZ35Wvv2FdbFy18Lmi/uEfQKVX8CuJEuoPv8yWrV5bqvv5ekfPYt
X-Gm-Gg: AR+sD10T8bXanOY7qzBXy5SpxBwAgvAQItE+W1PlBMl94qu828khBEuYayNcN+TKMbY
	tDDHim/ieijrZkxQmMFQESDzO3/rI9Ijm5RkE64x9AfSWWRXUNPR1v2j89BwDT2yn30gqtYaaEO
	D3S9d1TVGVtGTPygRE+/PCsBGdEO0yjlBQPNpERLFg51ZPXgGWV6TXRZfxXjxYgWKiYdFJV3DIU
	ibyl2m4Ubm/bd54uf0JGkBRcXoN1Z9yBHU18ck07eR3ElELufvZKk831ib5wxCBle1+VbytHkR+
	m2emK2a29ZQ2b67cotxYvQ0q7aLgK1AlmLPsXw1xL3pd+0iMOpbpLNzH4NjuA6t/G6QkfXW+m1G
	k68TCs9At
X-Received: by 2002:ac8:5a12:0:b0:51c:1f97:e860 with SMTP id d75a77b69052e-52ce5f2752cmr13886961cf.3.1785869573302;
        Tue, 04 Aug 2026 11:52:53 -0700 (PDT)
X-Received: by 2002:ac8:5a12:0:b0:51c:1f97:e860 with SMTP id d75a77b69052e-52ce5f2752cmr13886441cf.3.1785869572780;
        Tue, 04 Aug 2026 11:52:52 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:18 -0400
Subject: [PATCH v2 10/10] ceph: rename ceph_check_page_before_write() to
 ceph_check_folio_before_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-10-81f0ab065284@columbia.edu>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1302;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Fy0wHmd3j0nRih2sYwsjYIDOGoKEx9pprPd7Ycd1PEY=;
 b=0IePVxuLC7vw8rtzQUNlq/BT2+vfHxRsOOG3aH3xK67+jgzeo9E2ec8vR2z6rFQq+G4a62iq2
 yew0TORASoFBpyZLd/LrUzrNW1mBhpUUwLMTTyU+1n577jdtw9woP3n
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX+t77N+XpXoBY
 JjLGPwFkWhdekCOJeyrlyTZJVGeaD8F19/Qme2w33DkpKh0RagN5G/YDYNgEYvaAKhi4rAXtTqf
 A40VaaTD4uf8pNDtPdsVP9/0z+FkVUM0PFquyBSa9WB+tk9CZMTs5bOyM9hOMq4xeZuiABGY9/G
 dbiTPJiuMRmVJogCopInAM0Xn34lMgss+2vvhA170hHOLzKKbzQYbw2bMqZgVqWjDlLEfbQ9MJI
 q3g1bIpiqSsDcxBPRzCelwcb41zZZ4TuNv47z8dQ83FXF/RtJ9m0DDYcSlZ5IqNFTotsEEy6KAe
 uQ9KYU9SA1OxfKFXbdA3dm085IoUC7edVKALNYSSoqR84TKZYYAjzIR9aPbPeHzXZ6HzVVcluPL
 NZUjpoqTtUqFOP3llq24+iW29rcABxLLszTQoSpXRsLS5q12XMobEm7N97pzApcgkkq4BY//bX4
 eRIxq1kpNb5fpVIbfLw==
X-Authority-Analysis: v=2.4 cv=ZpLd7d7G c=1 sm=1 tr=0 ts=6a723506 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=pveTg1YcNyQK2WBy6c8A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: ftM8t5afF0yPJRmVpjhHc0i3m-BvQetN
X-Proofpoint-ORIG-GUID: ftM8t5afF0yPJRmVpjhHc0i3m-BvQetN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX+Hp4aCCjWP41
 I/v8tZXOmYiTR8a7QrC3jpdzWbW352QNM2qrGuxAn3ZoKqPqBlNFr5VXwVFspC+ATMEFKRat/0U
 qHieyd01EmLjt5zfzXkUWlQqfP171FVXqHUInuIm0DbgmRoLXdhn
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=10 bulkscore=10
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0 impostorscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BD32A0013
X-Stat-Signature: x9ej99ubf7bmtem7ar7cmiqzq1y9jebh
X-Rspam-User: 
X-HE-Tag: 1785869575-316281
X-HE-Meta: U2FsdGVkX18FSFQGxHSnBhvGmMvvXYhJGmv65iE+ncrXJjRJvo2d8yVTShdlaJM67t6EESQxBirC2BcsVH34PntDttfuZLnaFzsSlctCqbSALOmjcti9tG3AIwqd0GGHI1ghePVpLX35axidtTlJo2NsNHPzHBeFwZ/gaUzGXO5CQwZO9t5qXV5Fqs1t3SRjmnmF7xB0+7f5PzW1a44o0ONdp4C+pb9g+0wYRleZNQ3g7o872YYNUd5uX8k+dWn+mI97OjbSWV4c1dqMc98lxwW6BNRVe4Tt8bQj2Wtjgv2w6es9+v6wgXP0dVXL5oSuaUhlM7ZVy2S3iLr1RDXN2StC2b2DyH2z2DxiBNAFwnjKL8Fn87+YCH5npMLaRwiuxzf/97+0C5lGienryr8Ui8vRYf2D3xixQUH3GXH87JMSoP3YC4QWqH/uH72iXDdFoady6CXYnYARqDZ8A4qMDHGCiH1Q+omcyMyyVQMnok9nm4WWVpj3KwTvqov+oDzfvg22z8KmfaL1kW3Uu5zCTxeukglwrkoQfiFd1wjtqGprcksCz6JJsRqkkHB070PfF60A3LA7gY6+uhgUUXEqWr7a8xPofJDsLmENLny+LgYu9bf1dvy0ngBYapD3oOQWdEvG5FcyoHuAKXyc304omRfrZLbIPQvvQMoa7aLkHadJHshfgkJhHari23jxhtYchQVB3j78NcrjHcAhGP6IWkd/cAr6O1pfLdBqPtDp4QKq7UE6SZr3A0ekpe77uLSidx21SMArAznCp5k2jpqVVhj8Cx5el9rWkrk26AvId3TUu8hc4L6BTdE3/rx3jTKcEKk4uq49PDtF7tDW4g2NzR8av891WRuegGlrEThzTzir3LdBbIK/RYCyI1FFMJ7CwbcfJjLAxSuA8/I2EK822sNzIqieCFxAwFfu9F+Eqnk3rl5mVJM2zjGwNrxnxhOVRgaVfbSXZNOO31O4H2+
 YDxvhLA9
 Dz1yPmDZ+7BjxSI8HMa/nfzCSWbTplrAXkero1Y52mvyoY24GcfKKjWaeXqdQLtpj/FVetoR1z76iOBDeRk4ias/f4YgAWY5Chu8nIBnsmrn/qmsbfjlDdQvuH201TMMtwjHXOspkt5/MBFvxz4NjLh1AmnWC0VDJzX0CGkdaYbEkRWlLC3sdKMSRrCJYJjZsZiajfoOQRNmJRm+b8WRlgGVt1wlSvlqdecAbhttr2Af1u4n3lka9zfWmUOvfUG+pGSqAdJevn9Ef/OuwHori9wEJKxfe+VzZ/gudhaavq8EuvWVEl34RZLbB0NfW4J05jhIjkOhC6LSK5PxbAR/yPhkDXK/1qcWzKIa3wxK3Wl7zTm/TaSgmOMBad5unw4Hnh6/sSwTzzEPbDTs=
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
index eaf5b3f6d13f..08d854ed663b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1153,10 +1153,10 @@ bool can_next_page_be_processed(struct ceph_writeback_ctl *ceph_wbc,
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
@@ -1340,8 +1340,8 @@ void ceph_process_folio_batch(struct address_space *mapping,
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


