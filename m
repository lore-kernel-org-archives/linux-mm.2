Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EDFC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F36E6B0861; Mon, 17 Aug 2026 15:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4D86B0866; Mon, 17 Aug 2026 15:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571F56B0861; Mon, 17 Aug 2026 15:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8DF6B0861
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 998C012089C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:53 +0000 (UTC)
X-FDA: 85111716186.30.3E129C3
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 188E3C0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=oJk6CbHQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fhdfTzfa;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994151;
	b=a5pWHkiop8vqnsVFqi4xWPuNVkEQFWIK0PEx4hf8Mbale5gUKn8k/8wmArFffEKLX+F9kU
	1x20KUu6yxKmNF5tMgpQJVZ9a18J/cJWtpNZXzD2x1SMx8CGKKh23eu5dQFonFc1qPJ5/c
	usCrxtMSjX2J8ywaVX/9H7MPcLDPdwo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=oJk6CbHQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=fhdfTzfa;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvtelDgcI1kH/2E5UCPRf+p2X7037VcyjW/+hck8OJM=;
	b=k2Vpld1r7tkOUi6IAv6QyCCODkwrvrqQTAnjHvpmpAcLUgDdgQ+PmolNqt22ptog64OM5p
	iLmbxVtIJ/ieWxgLTibnwQatE4XW/i8g+iIwH3res/PiEacJOiDcR5bTwE+YaEzqNrGUM1
	LgY9aN8tRlCjzshJZZph0ko4F4RhSB0=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIvhJU3766716
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rvte
	lDgcI1kH/2E5UCPRf+p2X7037VcyjW/+hck8OJM=; b=oJk6CbHQWAYPKqC2k6SO
	7ruOuQuC6l5zSeQR0kTEx07+l4/MKffLRbjYBCZ0fZH1H4amv1qf+uyLKNeeKqFG
	ajS6Y5FFHyqLh5AEeWNVXT9z4g99ViN9+Cua86tmzxDN+h8JzimTlZ3jXX5j0Pyk
	DggTC2d7/1VP56wxGd3yVrbVUHIiXIclL1lNDYE1c3vI4VlKwUgblhst9uHkMpHm
	xmtmawJ5lMhZ8VJ3F1giL8kX40pEepLQAcjonQFRrfe7fyjZfwSgjV4xgPDV12wU
	a2B68mj16nhav8JvoFXb+YGPDrYrSfHi/NNX3M5FFpT/tzwXe7XtJeyr7hnOGW8/
	Pg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g481r85hb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:50 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-934963b2bc0so371592885a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994149; x=1787598949; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rvtelDgcI1kH/2E5UCPRf+p2X7037VcyjW/+hck8OJM=;
        b=fhdfTzfalS3T+Cs2aLy5wigiZaVPfXqvQuRJE/0NuFwLa8JSFUGtBYiOszIGtC16Y6
         CYodeNoEHK9Kk9yibkRzt6mFl2nUbqlRpRhdAIcrhXpG51ERVuE2UGDX1FK/xKs7EvCl
         Qp1h1Wsor+qu/IYcRqj3VwCZA9jo++K7bycq5sNPFlORU/QZ423ezd37sM+MNPzCMsvJ
         cdnctIOpre9Dn4VCtHmt8r41njneHHUHuu5sdx/sl2nILhecQSMAUFIna8XmbA93Wvx7
         tkwFJjrONCLZNHM1ZMKgY782lKBdV3umUHgZmlhrJ0LfXap2BJ3RrdymVcYEoyyeDdIW
         SgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994149; x=1787598949;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rvtelDgcI1kH/2E5UCPRf+p2X7037VcyjW/+hck8OJM=;
        b=jt29A6ntinb/SBJW5VjGq6h/JDAogEYKqJVfGvQIfl5T1ebFstw96Zz25o6zjMHjnO
         2APUMtoKwf2iqKe8D1ont0gf+z8Y2MAvXItOfOosth5HidWvJHRVpwxuut8bLn5OOvds
         f/AlRt8GtGeIegHLHCUFYiywrru7jKlLz6u4CDJ6VE+cuKnVl31KLoq6Pi13xhC+ftuQ
         KO8LXdJLxWpX15cnNBrQFOVn6BXYyCOqBIdAp7HBLXegXaWP2cUR0h400WG/VuA+Catp
         gXKktlREco3N4+fyAbxsE496Y/MLh0lIJ3zFo+wxTyvk8kMJkxAck7i9oggcIh4ui6gU
         3D3g==
X-Forwarded-Encrypted: i=1; AHgh+Rrvp07uqU7mtP2goozYQ1+nZG4N7joy54MvLl06jq5COdPj6Cg5Abu/d+PTRSFnP+m2a8mg/0xplg==@kvack.org
X-Gm-Message-State: AOJu0Yws7JSlPqi1TmE/fBkJs0jXTfOR0zWmyOddInA9UcEMFb+l+UKS
	oRyVm/LNzmReddXgsPvQX6jku6GSPV4H8S5TjW6HkAbwVIhdkEC28lQxiHdhjtxcAgVTT9FXihd
	A2Tn8WXCRIngt8RtHp+WEVX0sSlqmrhxxHTGcyTOPFMtn0R2X
X-Gm-Gg: AR+sD10b1Shz+fZtpQNcXNscNwYrYFhYRJZY38pI8XHlLTsOiSGBg2X8VVeOgq33pqh
	LUdAq/JZ1scumGWLEuLhix8xARc3C52DsnZG9HTAUFp20DgmR4B5bZvytRXJF+zmFiEiHio3WPh
	nai7WvBgSWnqILPXenWSm/aaSFvtKobJDFnmZGX5ytHOk2oik2zWbWDNOR+CMXRItnsMSS+lJ88
	ti//1Oy1GNi6643FOHM7QrKkcqCXXgY9OpvYEqwcN7/FS1Y7Q0YR1ZExn+528b4DUmDAipG6xFA
	svhhwbODeZDpxK+XpmGUOtLIniTYNKFRPQ4ExFJONFPtEsR1vOf2OkpnGHY475gnTirdeFOGZNC
	eY4dLVotA
X-Received: by 2002:a05:620a:3910:b0:936:af9f:4c30 with SMTP id af79cd13be357-93704b8dbecmr244834085a.25.1786994149430;
        Mon, 17 Aug 2026 12:15:49 -0700 (PDT)
X-Received: by 2002:a05:620a:3910:b0:936:af9f:4c30 with SMTP id af79cd13be357-93704b8dbecmr244828985a.25.1786994148981;
        Mon, 17 Aug 2026 12:15:48 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:47 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:26 -0400
Subject: [PATCH v4 10/10] ceph: rename ceph_check_page_before_write() to
 ceph_check_folio_before_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-10-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
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
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=1302;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UQQfnH5oUv5WndyYs4Z+J0hoxAEI77yDbsTq+QWKC34=;
 b=b6SAW1tG4Jl7P0GV3rFpdHlh4xB2uPa+WeZWFSPqUDH+h6emiOeLsu5ztyI4BoxstaWB38VyA
 ugdc1n00cnnCTPAiaUPYSjTX970hRVzSQHXW4Ew0kljQcrR37cPRDJ5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX0/RG07+2+erA
 K1XdRM7qG2PfKDCTvIyYlMN7+qDtBjGoJO/0S2CYy9Hr/4CmhkU32OUU7Z6emWiEePRDew1f5QA
 bPlESW1iSB6NnXt7s5wEv89xLgUbXhfJVHV+wvvVUDdy5zkUbOllY5nIDdpB3zAflBFKlBLnqCw
 4N191t3f42T36f9Wl1pizp8tjEHk4l9rQMqZWO2LclGHDPs5aTwVtoWAzv1ptDzqo3xOobT1s0y
 sppn81cuLkicr4dbWlt4vs9aD/n8Rq5GcoEAAaCcAQV54/tGChZPrtkK5pH/0VkmyWdBuyU285W
 hZTczkd3q10AggRK8+/e1h9YL5hW3j82tdXv4NntEVFSZ3AG/6CFMzvVyWDpwKljBH+VKIkJPzF
 AhPOqj1fDiTufAkhhWCBvaJBRu2SbcbKvdCQZBjjG2opLYVVkqrpNL74zb/89x0LX79YPv8yrMI
 z5vqRvaKehmDgr67ekw==
X-Authority-Analysis: v=2.4 cv=PKw/P/qC c=1 sm=1 tr=0 ts=6a835de6 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=V3EFW1AtJEMGhprvICUA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: TbPL985vk5cm5wy2PLW12tei3mHYmij8
X-Proofpoint-GUID: TbPL985vk5cm5wy2PLW12tei3mHYmij8
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXzS8QTmeF66iM
 lhCh3C6A1eXfCaZG9RgXymBDPpLuEujMS/i+MngLPXOrG7KLY0N0cvIGPgW7CVnel7ZlEDLmpDZ
 bQ9iWbRdIBufBMjEArs5Me2uJNTMJeqCWnv0SLicR1bS86hqG02i
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=10 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=10 lowpriorityscore=10 suspectscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspamd-Queue-Id: 188E3C0003
X-Rspam-User: 
X-Stat-Signature: kxwpmrk4qay1nj8a6sq5wxn83b4769z1
X-Rspamd-Server: rspam06
X-HE-Tag: 1786994150-229388
X-HE-Meta: U2FsdGVkX19fiXRa3R1u9qvL221Mx17EKy/D7MW5jynqiTAz3C86OjiEM7Mp48mqqRS55SFYrIjb8GgXIYPdLgCyeDKQnzlMfQx3uAXHkMae6olofx6+t3T3rhPCOU3tOdl49qKdZCdJ8OOj7GrBxXTiBIYY6rv3mAgQUK1qwUs1wJZiB25lzV7UOm2/jeHfNUMTjOszkCeJsfrHkIDneYEpXtN7DpLRWKbf8xPhErgsVCnR6TwaU+qIBJzlsiQbB0laSpp/BiSvmDHo+tmoxjWpRA47Hkk/pfIZJWwZ8AQIF5PoJDljw5/epKFiFJ4wCotP/woVCbYgdVbYKyK63g6tlKDa2Cq6MwQEbY7Dsm2PxvkdhlcS0eFelhzscOmAYX9/ciFc0c2DKyqdwZniuSoFrt6K2r1PUMrHkVKPsbtozNa3pMWHp1z/k+aEqJ2oUgcA5yAO47wYl+hPm7h7mCJ1ZVmy1jP4oS2dLJofKOQYRv+4SYW4xZYcBjx+iQJUc74y54F+urMezYHUnDlykWpoPsVwxZPClEOpCG6fHim15nSg74VHbHFxBy8Q0Tl0NBjApiEJIlNGgkbPwHQqo9JimdyWasvtem2pWxQf3gb7MgG0oCASbT/o3Bz6zfg80DhTlmtYx5GEwlgAZNnweO8cYU8KOQOZiXYIN0SrO+duxEotwc2e08Njj+CCSDu1ss4Iqq9ZD2t7yFSuOyqTHM4+Oi05ArLwVbP0xB9FNLAfpvR+QSVxJPzkjEw++zGRj23mpKUPGpMZgR47IDMOiIizkch0xQznMCezY8XbssCr/rQEFXYVYNsGeA0ngLY28W4BzJSEdCTxeMldW2xk9TBBhr9D/TcTFp3/YwUsWqePr2/Wl7iyDXZVzU9uZZFB0eB2xVrylu86nixbvheXLFfcDmz+jkaDpl9zy1LTC7yUkyspSwCPtTy4Gfexg+kP57NSt83DzvVkgrfZ0CZ
 Pc9cQRfF
 haGagrTCCIzXVEDvcnYgRhoGqz8uUiypY3YlhYNNINtRg4pRUknfnYGw3LOvmRe6fdw9WWaTe5h8vr+a48IAq+5c1VELLLBl6YUrfRHIqGXgFKn1w8LdFqgKlaaUmfKCNPKyF3lkE0rrTTbxSTijNTeAfv6/wQWbVd/tWlDZ84i7jyPZUSgAZxJZ8gs7gaW/iMjVhcYwWFGBhE2NAEkmmuCkQ9Vt9QahKCk1gRJH4lrwfYnQ20XIwJQvoc16ggySbvZKl9Xr2O6Gmg3/Mq2JGxXucOfBAitsaGzwDdWErptEn/niH23qAS1h0dybQ4ZbjoGAbERpaMSJ6dWasfifQgILxkEXW1blEPoyZ/vyeg3rW4w8IuKMdpSvTQDF582mInhflxvabM9VwfXgnA2k4peEQmTMJMJURklBHIFDP1K8dvSFrSEd2XmiHH1s8E0FUZAeeEiv5SYKvhhFGbkthSNIKLdbNgxyVlr8AZeN+Z/PTI7XaPhROHuxsrA==
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
index e1ff5d9fd121..595c8a1518ed 100644
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


