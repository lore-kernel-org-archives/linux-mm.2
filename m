Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95C1C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2546B00A3; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771E76B00A4; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613936B00A5; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3231B6B00A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D184FC070E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:53 +0000 (UTC)
X-FDA: 85190947506.23.A10876F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42E09140011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lLElZI4W;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EWCdEKQ8;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lLElZI4W;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EWCdEKQ8;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880611;
	b=2UzSIoOkixX+We5Drl35p+DapIzB+hPAYZlp1zfcrier3VQmwcCVFCkUoHy/oNkdWh6Pin
	m0DvueVdo57cnJn6oplxbrFVDizUJxv4gfRZ7WAquSj0pW2Q/lJ2Wu5ft8AuSu/t9vq3gW
	QBPPbOv23eb9XpejkTcAfmp0AM1XOfA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JCgFZ/UvwntchAgFQ3Xf4ZwQOPcJC/BRoTP7E39rY0=;
	b=jyhnqi5X3lnhKoipfBzT1xpULyvweFXQO5/b/PhQYEBTbyNmAwy8nu0eEiXj4byRh390ZA
	eJklOJ/NcGKKm1jXujAFpGol780GFqQBrOFMZL/+8a7+VMnASVhLnvDwgEWWr8EQVscUp5
	X7FjjVnaNeIsqUG8SuuOC7dEC/xEo/I=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FGldY383216
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3JCg
	FZ/UvwntchAgFQ3Xf4ZwQOPcJC/BRoTP7E39rY0=; b=lLElZI4WDBND/j21exF5
	0Oo0dMdO9bK6mmbakjQG25BaF/L7tpeXTa4lsAbU7J6DLIODHXbFkgUc9Qy4VWNZ
	miOS3hktYN8nFsIztOvv6fGpQQzbmdwdNukcw4N+lvUoFni+Azb+HOgUKlu62og/
	kdkOhzVz9gsY5SNf4nJs7wS/lUGsLtw+tnCSrSp12tZlGKEmuObDblJd83vCj7+i
	BsDGyaQDazVWO5dGobi6JIHwuLEjeSep3sgqQzPpHDu18ysVvCoaZLp55N4PSfIn
	ac52oMyDBnOLyIb5Az9YtV+NV97ocITLWBqkMqR4xmloXiNhGmx5GR2lW6pao+so
	CQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7g01m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:49 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9102f07f2fdso96611296d6.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880609; x=1789485409; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3JCgFZ/UvwntchAgFQ3Xf4ZwQOPcJC/BRoTP7E39rY0=;
        b=EWCdEKQ87It/E7Z2YfSG9K7jebuIbcpHa+sNRQTPB3dppcVOiglUgwJRixPsN03l1t
         0BOuxsvLZX+HJeNae6SRlTxOCfZzvpev15vTg6KNdHaGJ8zluizYZtMbUAXjyPcnqYMe
         l7AqnAaGUMYrWgu7IJv0W/CIa2X7tFH9q6G+BBjkGoyiHXgcuH8sLsy9KSY/h63h2I1N
         wzYBMxY1yv5QMCx0JRmwZspTDB3HUjtFMFg2SflAXy0ZojgIQIRkS//jYYg+0+jQGg3n
         m+VflEQ4YXr1lHMieW5a/d2iz9ISGxT803yjQ6uoOcTnv2tL0eXQVUu9xYnAnEY6ylxO
         Aw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880609; x=1789485409;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3JCgFZ/UvwntchAgFQ3Xf4ZwQOPcJC/BRoTP7E39rY0=;
        b=f6TWUHx/1TDijnrWAn1A/3Or/LoNif2kN7gEKUZV+KRAb3CmTY32UXy3X17HYMHpIA
         ev+VVhWcmOFfXgOsXu+Pl7eBKK7aL/nmIq8oi2JfAmAH9UfyNZZvDJPcmObJNW96gI7d
         1tUSNqmmM0QOrRxeTy3GK8EwbkC7WqxtsfUin948BEmU3/+GmuCwDt004Ajzt1FwsFAa
         Bbm0ODt5c9K3l6xXy8REwvxCagJ+xMRJmjA4u78dykS7g2swbCL/ecBMVyMtHP3bJdl3
         8RvTWtO03qoGK4UP7bFK4kx2RNpVp05NHL/+KAVvEyUqBtg3uHhq0WxJPxJQBK+ZV6k9
         H+kg==
X-Gm-Message-State: AFuF++l0+LvDX57pa/K7o4asmb4ujm+YhmAF2Zi1w/0wALI6oepucGuW
	3E/LmYMoB1kUJhsijcDxGIIfwx7GTQ4UFuXHZy12Kotz3Z7ArijRKqwQ0r7DTOM3CraNBbGfh6K
	YScOl0PGNsdFnKrVIL3MrUFxLn3DgsAL7Guko1xHXVCJW0rdP
X-Gm-Gg: AYBFou0u9HTDc+waPPfShDHQzCeWXUmbiI3IfM1+qsiykLQrmfrXy8GYYtauTk5syLn
	WsP0Q+V7URPfQxpJIcQkHFw4ewxJx3IhEi1rt8g/JAol/PMdwi3+MOPbiqQd1212jzmOmAVqT2e
	JG/qD9CBAMAJ8VDQT534VOW34qgsM6VdwPfr2Kx399JmQPUNv+8PKHwRerx3QDp0olDQ/t4p7HV
	ZEo0/3EUbEYaAA2lCy0cYaJSC/qMftWVahUFV5TvFs9NIyTlnFrkhSPl84crDyexlNgyIpt7PNZ
	Rd64gSA/SM9QiSGF02iep8zxOxOxYJTS78e/om9UGOZ8gpTiJYzz5XzuJcRmnsTJIhDjmKUSTNx
	JfWJ5sNFIee8dTy+rEVhQUDeCvII/DPFM2ehVO5OZlvVGMrfsF1cSUg==
X-Received: by 2002:ad4:5f8c:0:b0:910:3923:cc74 with SMTP id 6a1803df08f44-9103923d1b8mr310711976d6.29.1788880609105;
        Tue, 08 Sep 2026 08:16:49 -0700 (PDT)
X-Received: by 2002:ad4:5f8c:0:b0:910:3923:cc74 with SMTP id 6a1803df08f44-9103923d1b8mr310711206d6.29.1788880608454;
        Tue, 08 Sep 2026 08:16:48 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:47 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:35 -0400
Subject: [PATCH v2 5/8] mm/swapfile: use folio_page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-5-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=1012;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=LABp5i3bhJrVd0Am+oCrRIeAA5xV3hfOSmtufFDiLIY=;
 b=6+jR6HpZ06c4dXTH61RnGlMCd2W093XLytaX4GORE5cv8EMZGRyemEpyApxc9zi+TVZItLfVO
 XlmbNtQmc6vBOGaiS1COlSt98pZlWdcycp/k1+8VHxNkEwfvnIXk1gR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX0+2nqc8yKLm7
 bZqiUcdmq4vavClx7joIGh9wOsDVcq5bMN+OR/bn5QN9JgiZR55wUIWVqbKXu/DyVZA3Kbz/4JD
 x00fbJb65SubLgS+gsy08o/6VbFZpGFLtDG/V8TcT9VITcBkVr3UjC261yY1GuFnRMBzhfBlpJU
 jmcJ1UUokVv5EIDczjEHo+bW/eZqt0o5eIc8mZl9HFDsUBH0BpG5nrlxp7fushh+lXBeXkW4Vpj
 zpq2JvXyDhO590XrsK+5BYlJK3ki24C/k9RTSxvNXZjuZxbKSbPBBGXmwRK+Qkf1+cf/tLBc5l1
 4JNuTEtXYuaCI7XPW0sjC3zg8/mgeB/AjChMdYWKDZ4Wk8S3W8VfuXFEMQ4/ymbombt0jeTclSw
 kpSWdd0zvsC0BDyPTeBZqmKtHxhsLo2UQQiZ+dY+bZsrS+IzZS0Azj5Y2HMSFMFN7pKWq98CeRB
 frUW/MGGYefoP+CCH9g==
X-Proofpoint-ORIG-GUID: PGg_1xjNP40IoIQDj69HHr5nv9L0bOaN
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX712JIvEPN4Nv
 yax+guXjXxoYN5a5y4p00dBLOgK51TBLqmIW8gFLk6s2SvegH8epfIbpP1QM5q8U/ovdsgnVZSM
 iYpUyHmC2FjiwJR6KHKXJbdTPqIyTqN1raqIp353mLKZrKhyalM6
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa026e2 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=xqDBoplpeononJk8d44A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: PGg_1xjNP40IoIQDj69HHr5nv9L0bOaN
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Rspam-User: 
X-Rspamd-Queue-Id: 42E09140011
X-Stat-Signature: a1tofdpxozjzpxza4wshx5fggqkykzt5
X-Rspamd-Server: rspam01
X-HE-Tag: 1788880611-67639
X-HE-Meta: U2FsdGVkX19LGfRJgA00RlhXDrMGHH245nBAMt6kP1Og8TrCcRgotYK6RnyRSHuhXfLJmg8mfvGELPa+nVvKrXKqCpDSsxFfi9or79zQBelpmwuFEV3ZMjG5EsAxQw1np0A4DhLdt4fTX3m/gFrzbwKIQpIgQ4yxxJyZZQyjWBgS1iIjiaHS7dY/Pmd0mTDtV1zJo8U8MVgmQ+U3utdTxeKIvXNsb/Nv7rGid+EHEcOi8RcpZHM/0PTnxqSPjh9hh+WxWgLQQPbz62sc+sXoTbaedZJdJlhPFpuJKZJswbjGMKmQAMR207F+nQf9G2CNs+RZ/OHckVfJ1unmOzzDBcNBmATkyfVtdkrvRqEQXzHbfZOAWaCdpS/aBR/j74G/OdH5Hip/13W8KFkCKTOGzKleKriz9Hwj6GOu9w7JYYfDugJ5DqqeP3aIJ769PUoba2Rg3HT3Pp20e/l0IAXkeBoLEc6wucfrN20LPNUgnHoXfi2CaU1Xt3USupDNV32MRftrwy9/w7uNIn3neeiY2dOM+CJZOTqHdhZESOl1YBQmbTwQAPEUQMO7DDEdDAfHwDKeShV+86Bv9T0Edorm9XgE6qiS/gdnACw1tuQLhXXEgZwt2aWRVGeXqdrhlq94W69/BM2sYrNP/SI3/yG3svH+Wp80TMC2mSUW997Pxr/Srt4JLX7pHvkw1zU8ZGDokCmc6zFvOrXllBsjefcNVvUYGdbRqBNpRBLgz7XN0JVI37CBfH4j6RDsE30avRUXLRSnMMK9JjY1E5Arl78DJ0/zQGBy4WaMgyp/ohOgNeQxFCfosTWSeiuuS5TYUgLxrf0uEFQOirh4QgCojIk2Z7a5MeG8Ex7et5WcEqktTVFIN+tjysyRULBDTDXIqCUsPRyXmhLpRgTBt/KY35rLwrMHTd4uXzqfrNMnA08xXLO+garOPhYs7ZwEysa5kuX5JBVOCiZBmJXdXzoZ7uZ
 886QuMI7
 V00uDJ00TxS3tP8KYPdeTyl8uQlUlVfa+bFJqSQWu5qbns2SSyN13Uguyp9w3vIX8a2ggxdkjRJLdk7Gu8ILWIl/jhnE4wPV+BL4rraWuRDzARiv7Ek42/nNlP6amdFDAl/KzAwp5MNzzMSrYBwLb7Qgr5WGTbknc1MHpZoFg8ezG2LN6r4uxnTjupXy2roMLPfRpdWYHM4NHDehOXTLHEtjKlwO2cjUQoEMHOa+rb9YEwTPpJ0qeROzsl/qa0mXfCQAHcJANXao55S5HXSpg8UjHCQoNM9iUslNo0HzFqEza6OeIS+/jxy3O+QzT9y9E7JYcEM6TCrj78h1WV2+insznAKSKJpwA79gUYbaRn6n73zznShjp3jZ9i5IjxoCBhpVC0Pnd5y+LAknaWEXfdqw1es5FWb38cqAWYE/Yvb4dmuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_dup_swap() and folio_put_swap() open-code the swap entry
computation from folio->swap and folio_page_idx(). Use
folio_page_swap_entry() instead.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 869a918b18e8..0a3a3b2218c7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1822,7 +1822,7 @@ int folio_dup_swap(struct folio *folio, struct page *page)
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1849,7 +1849,7 @@ void folio_put_swap(struct folio *folio, struct page *page)
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
 	if (page) {
-		entry.val += folio_page_idx(folio, page);
+		entry = folio_page_swap_entry(folio, page);
 		nr_pages = 1;
 	}
 

-- 
2.39.5


