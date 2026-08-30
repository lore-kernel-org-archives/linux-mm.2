Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5570AC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C806B009F; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E656B00A2; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D085D6B00A0; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCB26B009F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9C59A02A0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:34:02 +0000 (UTC)
X-FDA: 85157575524.07.4086FB8
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C71AA0005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:34:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hVKwFx0h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=KifiyCTy;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086040;
	b=vlaOh87kuGTsSBYDbk3gskwgnX+2ZJBP7IJ+yJJi0jjBXma5oBQ+KbK5c9XQWRUmJHp2En
	ddczcICHwxiocvTB9F7ByZ7mFstF3fze0mzDnGFKUbF9ctf32XZ2gmPQG9wWGZfgIt/I+Y
	WxA7EtLVBJUsBM4QIweLfFv3nZgyJXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
	b=Hst8lIKFq1AkQ8qf3Bo7R07xsQCMrNRXBFK2zxTphGltu+yoXwZBJ6kjhFSrwPfb88J11G
	OGRIxrQT9f958QS0j3NKLoMXglRGNti7q8U9N/Nm1bUa8yaq+ww4jAfsHPLrQLhh3yS0Bp
	72Kek6YdleTez0fy4TQvOd1nVAaMLI4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hVKwFx0h;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=KifiyCTy;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9rbqm3338109
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=TUGg
	y+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=; b=hVKwFx0hCSsZz5LmdePQ
	m0MIIXxBNMqk2TTE1r4loNFqwx04Lk+KyP0ANLw8p2b3pFEWesqV/I4u6L8EkBHc
	Ki+S48u1n8GvEGat8Rtjc3TUUqIdJhvCqYNrD9R/rIqqks3p3mk5CBvMuIVs8Oz7
	B//B9LqyRpbCSDnmdkjITeC47HXFSy+g/O5Z3/6qXde+vRLmNkS+cXQS3ZHR11ge
	pDD3LBJu+sx4wHBK7dQD+kY1QY1FQQgf+h+y0Woje8ozX0gMNvzrXuXCewHk+KO5
	0vROpyniv4JLtNCGRncW9+rPI79l/FNM6rRKlvDVfa7axqIxq4ZKLGZ0FZb3mDDH
	QA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbrhq514r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:59 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb6c7b680so32033581cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086039; x=1788690839; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
        b=KifiyCTysZsCHiKjrPCAlx2pNS/RayANLrAblkO8quNVJ+7MAc0m+fRXLLkwGgMM1X
         B3gxwWh007D1c/eOpthuK5NJ5wqz8MDYdfT5uPRXDvj1ox8P09MLf4ur1MoDkV0PbXDw
         9/xyokrRwk6eN2fWoygeolr1Mx4vMq1CCoWpXvC6k39iG9/1EOWe4CBhoT/KEUD7+3xH
         +5MNi4hHg0KSRZfQKs/a7a1ib+KaBazvV9Y5YLJo23nVBEZbTsFMfiAutT24FFWjjw+v
         6fSTgG8Gw7xO+9hhpxIJ/4ttiZWszLrVQ4NBnCOub2FpnH8TpCrkpwYf80K9A4jz8eBi
         TYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086039; x=1788690839;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TUGgy+CgNjku4PJ/FQqlsQRbEqOOlPzZGqKdff23MIY=;
        b=PrxiUx3HSlt3q0wzx/q4u0yesGpGNO5gLREWccGTZr4JdXBJstM7rGiY4Gvt/DK50X
         SYd8cpPSLIM2ik5pHTrm/efVcw25bBmQIA1f9KtoDGiE8iX9wV+CW5EzQDlorUd0BLXj
         tb8lW9KJ2lQ2/hq4+uggYJN/lp/E4HemHy/qN/S9PqmXtBf9fXGAoFfBSklSIqNnSi27
         FSgvec7vCsrfloRdLdJtlHLpxmznktn+4Cn28AIMyd0H4HyIrcDb5/caoBjdhidTjL4v
         hasyd/EExT/xh5SMGSxunySiTy/OmkptsXxFd/YrNoTs0ZIQ6l6hPGkrqwPgg7w4aCbe
         QcJw==
X-Gm-Message-State: AFuF++lAmdFD6rYB2prYnqoPAR8xSD6V2pJoaC9Xkxm2v/eLySWeIKdz
	sWakC/0o0l5MaYoHgm7iVRjEfz3K99GvtNYrexEx2wACe5eNpEpP6m+XI5WSw46UABWvYPozB7m
	At83D5TB3Hx8OJJPY/GBW6xvDZBNwjxeLQP4aNTEao5i+06gE
X-Gm-Gg: AR+sD13pd2HY9E8RsQPI08fNWdu4WcuzsFULvHDFTNSZC24LhDpcxt7k/0E2axW4vZN
	XnEs2/GWF1KihJPuVgr6uD4PVX6uWgbhear/n7j9jFNGbYCxWcKViRXyTwAf5lWVrTI4PnJJ6g5
	PwHacBnYz8S3mhsdruKoRDZ0H6DlEn2+n5v8ta8andlZcBXTD6EVV0VYXiGyOiMgpasCs8YPUA4
	BsaqTy+2WA7UQkIb2xFlh0k6dUK6GH+u+8D5car/j1Fdzf6e0vEtum4tm20DBxLmWpK5hBXUE+8
	VCYJz1c5oe/JhHvTjJmUGl7IMBVd8AFsWUpBYEINboeRtbQiCy+dKXvaJ04rueY0kTHI654HEww
	H33oiMaYET/IJHS2iC2IKt3nRgYtv+AcF1uAmfGSkcQ==
X-Received: by 2002:a05:622a:48a:b0:530:4ed:c251 with SMTP id d75a77b69052e-53004edc327mr39477971cf.12.1788086038922;
        Sun, 30 Aug 2026 03:33:58 -0700 (PDT)
X-Received: by 2002:a05:622a:48a:b0:530:4ed:c251 with SMTP id d75a77b69052e-53004edc327mr39475241cf.12.1788086033785;
        Sun, 30 Aug 2026 03:33:53 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:29 -0400
Subject: [PATCH 7/8] arm64: mte: pass the swap entry to mte_save_tags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-7-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=2617;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8STOz0RYKi+7v+knfY76tg8bbf4f7uqOVYm5Jf2KOls=;
 b=DZ1RAcNFd2t3tiLlyqIoCis24ccxkX5i8IRMFWWWvBGYd/Bq0q/3TDIYxtAmdd4DXmVWWJweQ
 rUY0XsF3guHDHQMeLSpYerreROURlWUbDCXQd6WCqK9O6SjIYu4z8Jv
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX6lleXn9UDIc5
 NnK00gfWX17yXG+q8VL9tJYNE/RMi/nJL0Qcdoh6js3kSK0pvuTYN2bO4desjDaxZTqTglLesY4
 bJlhMoE2DHd4saKvE3HwBwemynsl/AzviR6UrZx8NPc4Jf7j+IXjKw+Lpe4M3+VckJnrz0DRRBH
 aKBMbNtneDDfbvCe4cU1isO5QP2Xqik3h4HlTMWVwk51KQoGJkn7U85FwEyZG/+vqrarMuf7d6o
 M+kQTZNWavVkR271EG2N4BmJnxZSD8LoSokUMWQ71mGiZ5PHs5IsmCiZJvGxFsU54i4pZNSDuPm
 RadgGr+RP83+oja1KQRHP5s/9qLJFQ796iWTg4LcNrkYmHGASyVswyOmBrxBajUGIf0oTyHi+xy
 S/kVFJWZUDArcPpV8aZ0Jn8SIXXDPW1DeseAXzNERnRKS5xO/jPf4Gbm25jvSfkq0g0nOKJ9/9y
 J67OtU9Jm5YZ4EslLlQ==
X-Proofpoint-GUID: _vPLo3MkBvOqclatLfQjMzRWNmE-MClT
X-Authority-Analysis: v=2.4 cv=PeDPQChd c=1 sm=1 tr=0 ts=6a940717 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=p1CcqGZxNqfKctaSDs4A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: _vPLo3MkBvOqclatLfQjMzRWNmE-MClT
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX6khqycBaF7Ii
 9BZx1+PgHefJSVVsMKYZB7JTDEL2L8Gp4ZuoDBpV+DgzBEGQDybnxkijbAXUCsjpBy6ElYszv+N
 qz5D8W2OYLBh9pvzJU2N5hE28i5Nz6STrt1cswP0MkGsm2kyNSXY
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=10 clxscore=1015 adultscore=0 lowpriorityscore=10 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608300088
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C71AA0005
X-Stat-Signature: qp31kdycr1csuzx3oqgdz6kej3dg571m
X-HE-Tag: 1788086040-651026
X-HE-Meta: U2FsdGVkX19jE83LP2zkQpfuHvCfGvR29yJjIcEGOzwTrMs0uKz0erIXh1m2d+zqIRS4Id9jRFv7mh+x8WPsfpKvs0Roqw1tE0dlJWAZAUZBMoxgp/XBOKyU38rhwfWwz9k1SjT5MKP+kHVRDEJn0FTRklToxiHWpnnSDb1YFraO5YLInI8mZCyTeWQ2kprZYCd+dphOChDLvRUDjfXhK9ZyHjJhYyJA/c7AbfxxMIjjBKS75RRMKoTlgGpIu4PP4gStDpD5cJfExmaFIEtZkBOP+Rwtl9yg0QG5kbO92ShFEqxcUtelYw5ZSnSSaU7EQrWiunpaw/VVlbeFArDhBpONx12KzawFGssi8QyE8h873DAD/pr0ppLL/6Y9zo7QJQbVTtO1pW8+Q8kc3VKazRBpqC+TwUB2VepBKJmFG3MKFnQTEd0iC2ch+NcltsaKEq66CBP6zunwOubb5x8dc0rrQgRFxoJB4hLv6nEMFeeQHeiV4JqVHNIN5Id4v+0pSPh2xBPTwn5/3W/+cxRRxrBq6qGjPfZ8QAIJrPhLnb8VVKxW7rD9atU591eqRm4KN0myQc8jF/7BJaW9a2sSk5+jKePB533LZ0iwfAwqsp1XMDLDpMXN7qiOSec4shcP3ZyEQOkI0abEFZ/zKpVzi9Dn4UC2J0k6P/Od0mk/GPc4zcM8T7Vh2HJp+Gt0IbcsVKp/7YjHfJR1T0NmQXUHq81+kDbKPHtbv/HyRKMO4ed0Naogo90j9mRparX/E233A+8dYi3eO2pV7R1xo82g0ZquHXIyLJ/fHkEpHRdz5/BR4NLJ5Uw+W7GKIeLl39NZDuPHJxUHq5gvzchWM4IqWb8ZuGkd2LraxkwR4lsJ+y1+1/aRCWQ5cw3/+mb5DcTy9VX6MqLiq8LAdLjH7JTLhhNqEia+5IMxpQwqy710kVOdkyNMB9kjxKpWHGC1yiILGX16MccDXKBZhs48XXQ
 Tsj9fich
 VGwfYzGPjeasSypFYHuVax8jOlPAlQalw7xI0GL4wNIAbYApWsrIGEz9pHPN+l4sm2sk/Z52n3cSg8a+w1ETWStxM/nLqYb4/ra4AmsJ3lYbRrbsik5clr4Jhu3CXu3q8NV7IX+Vm9SYdabE7GFDV5trBBpezkSZg7jYK7uCiNuS4XgchF9aWWuWrFNRx2G8MAJe0G+zIK+xtAqI58kNId+KAYdqVDqr5TEdmQq6Snf+6396RuvhoTaJClNSLyy8Kn48zkjuODJDNE0AXd2zr8PxbYxkEqIToJNtag/aLYPRy3qTHteXyQInfpV9NLpPXOjsFlaB/wqP2hvfMuNo+IbGzzp5QzfHOQCYGGJLAR0I43kNUfLNX6y9ZWgo/cqNLqGl3U7JFiu+/zjqsQVKXhqHOy2T5bzdt9ccsZO5OlQ7rxm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_prepare_to_swap() derives a page from the folio only for
mte_save_tags() to recompute the folio's swap entry from that page.
Pass the entry in directly with folio_swap_entry(), matching
mte_restore_tags(), and move the page_mte_tagged() check into the
caller so we only compute the entry for tagged pages.

__mte_invalidate_tags() loses its only user, so remove it and call
mte_invalidate_tags() directly in the error path. This removes two
calls to compound_head().

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 arch/arm64/mm/mteswap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 3c54afc8b758..f64202b69309 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -20,22 +20,17 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-static int mte_save_tags(struct page *page)
+static int mte_save_tags(swp_entry_t entry, struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!page_mte_tagged(page))
-		return 0;
-
 	tag_storage = mte_allocate_tag_storage();
 	if (!tag_storage)
 		return -ENOMEM;
 
 	mte_save_page_tags(page_address(page), tag_storage);
 
-	/* lookup the swap entry.val from the page */
-	ret = xa_store(&mte_pages, page_swap_entry(page).val, tag_storage,
-		       GFP_KERNEL);
+	ret = xa_store(&mte_pages, entry.val, tag_storage, GFP_KERNEL);
 	if (WARN(xa_is_err(ret), "Failed to store MTE tags")) {
 		mte_free_tag_storage(tag_storage);
 		return xa_err(ret);
@@ -68,13 +63,6 @@ void mte_invalidate_tags(int type, pgoff_t offset)
 	mte_free_tag_storage(tags);
 }
 
-static inline void __mte_invalidate_tags(struct page *page)
-{
-	swp_entry_t entry = page_swap_entry(page);
-
-	mte_invalidate_tags(swp_type(entry), swp_offset(entry));
-}
-
 void mte_invalidate_tags_area(int type)
 {
 	swp_entry_t entry = swp_entry(type, 0);
@@ -102,15 +90,23 @@ int arch_prepare_to_swap(struct folio *folio)
 	nr = folio_nr_pages(folio);
 
 	for (i = 0; i < nr; i++) {
-		err = mte_save_tags(folio_page(folio, i));
+		struct page *page = folio_page(folio, i);
+
+		if (!page_mte_tagged(page))
+			continue;
+
+		err = mte_save_tags(folio_swap_entry(folio, i), page);
 		if (err)
 			goto out;
 	}
 	return 0;
 
 out:
-	while (i--)
-		__mte_invalidate_tags(folio_page(folio, i));
+	while (i--) {
+		swp_entry_t swap = folio_swap_entry(folio, i);
+
+		mte_invalidate_tags(swp_type(swap), swp_offset(swap));
+	}
 	return err;
 }
 

-- 
2.39.5


