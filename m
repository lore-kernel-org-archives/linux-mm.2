Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F5BC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E767E6B00A9; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB26B6B00AC; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A2D6B00AA; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 816CE6B00A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:58:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C212A1C275C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:59 +0000 (UTC)
X-FDA: 85191051078.30.2DDA6F7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32BF2180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D2nnI675;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=N04oC10o;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5PWEhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=;
	b=wKM+VIIAJ0nfn3bPRQnUhmkkq5ExzJ3MKC4TjKDrms8bEvPsGYRYBRCGWIWjPW5DoI3bO7
	0LWKwGhWueAcMipTN5XjUefDTniV+oXV0X6hMXMUQtwTqgviMVEUkrVOAeOXC2p1rX128I
	vatYanryEZcf0GRz22D2FeUqos3iWtI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=D2nnI675;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=N04oC10o;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883077;
	b=h9xNo4bSMNgf1x8UpLuBmohNlcxWVJW5vx16xpTrpgf/1Lyo4Ke48/p+ceZ6WWjrRaSUGd
	k1Ni8Ltx+nPfMqkdzNfq12kSPv5Y4sQIzmqnszEND6URSlejLFeywq7l2+NR/pbad9wwZ0
	StdOF/Xt2wMrmC3hKv9jVzKFCil14R8=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbjf52588951
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=X5PW
	EhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=; b=D2nnI675QKoW3vsTbh84
	noxvPtrO0oIE+oACTsWTer0nTGC6SuY5MV1GkuEp98LsqCbADqgXG2AfPS3hZ9o2
	SPbG9MYVulpbvkiOEfNlvAkzA1whzn9torjbtPPXMGcACkdZG3ad5Wx9p16VuaNh
	43YABGltso8zySJOjCR1jCK9NsR7sX9XK16XxCnxu7Hj+fIv/0GOVCTaZPDnjXvZ
	/eopPLuOAqfkRLnNj+PVvHJsyE/tXrmYxBXxS+cSK08xW/R2iSoukABqrjaBs+xF
	Xt9wn70RBks0yh3iv/Q0OlWFZI3AGUzL24h83w48tPIHxDD/7GryI2CHVHtwtMQ8
	PQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5dm9d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:55 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5308af39ab3so25815271cf.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883075; x=1789487875; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X5PWEhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=;
        b=N04oC10oaKeb+1EQuldGufES/5PDMe24risO0NZQk9iMJfoNB9jnL3pdir6gXq3DPI
         sJQW/9kVgWLi93foVRfSxzFB+oepTGuyyQojtM2PbbCQq7h1G4A9J/f+ESJufIzSRNpc
         Bvb+qnYT9TtRL2dGdmJU5OltHf5rkrUEIT+T55bXhJ0kEwcvEz0VxQbcH+1amIfeFWy0
         4ThOer0f+kq1S1HJ2NCWVLhr3srIYOqEEoiyZfPaRzSxILqa8Ud2cti8OG5/O4PPm/Fv
         lHEhc/qxjiYikoajUzNPDkr2cxih4E+EL2KV1WDBPIuGuN0fR0XQNWTwDtFyGAGmf1CF
         p3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883075; x=1789487875;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X5PWEhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=;
        b=PYszdB1u6UfltWhCVJCwTLfhoXshtWFWkzxhCU220YGWQcT4talgo307jZ44EKT0j2
         iWC0lhx0jrr9ETdJHSdDjBROvUYh4G0i9/ZoJUfaY3i0iU7cBN86SlKFTJ45L9M/Vptp
         aZtpi28EdnlS/lZNrYoYu78V+yQc65N+KDS/dM0fy7+E8i+Uz3LhhNrxFdYDHL3GWl1d
         MHr35RrmzBDbei6iyxJZtvdB+Uo04bZ71e10l3suhcLVOGf13b82QNvjQdUFUwy2f1QP
         rpj6HWhjxivC0Oy+MWSE2Dr4oFgLNCi02Bx0Ho0sYLe8146TDWlniy7uxFfE/4yTNCs2
         SrFg==
X-Forwarded-Encrypted: i=1; AKwUvBy/8sjFlgFc9u8cz+SGz3piAeArt+6L9lUWXp6G0WvdFfZD/ubG92Dw4lL58fHqKGxcSC+8JA6NoA==@kvack.org
X-Gm-Message-State: AFuF++k5FgRmQomF+g8GDJ9k3GU8h8KkrpdeW9HO8Fybe8wSO/BRQgGm
	bhnpyU7Mz4J8OFSubG9C1JuIWGVIbYhe0fGzEaUvkcwxrcKtnLTq/Uis3z6GbUjsuinyX7pn8vW
	v5KkLw84hDama2dxmnJkQr4GTB+Nz3mKpzIerdGL5AcDt7FqM
X-Gm-Gg: AYBFou0dq+BkxcMl+tRD1DHJh+TkifenzJyH0Q2Wnpbr9BaLatSHr27M7HW+mYS+7HD
	TbruUeNnhptGue/dM6Duxct501wfEIijYUeVxLfBY5KLFTL+GB4Yv9PV7aiOT2EtT/AYppURQFb
	Wvfbuk1/QYbCcLr5+vxXW1z4h56tlETo4lKs1etCq4e1ZICeGDHC3ZHJ7VBN22UOekvFnjkbGVu
	cUr9shXOzV6uV50ZPb8AUdktahYx6aAxb4d3Ob1FgCfT812soF2aPK9JQEUAivc4egA5v2J+pVH
	wPUeyS+lFjKxC3c+YNgYDLcKYyIcxlC7hA42mfW0Zn3Tidw61CH+j21HPmeDsp/rFaoSUxapoOG
	SEJ0z/n18IHnmwtnq1TPUJ6adftx9BsUxyfffQzAzYpK9qilK
X-Received: by 2002:a05:622a:4807:b0:52d:f63b:94d9 with SMTP id d75a77b69052e-5305498463bmr430145481cf.30.1788883074820;
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
X-Received: by 2002:a05:622a:4807:b0:52d:f63b:94d9 with SMTP id d75a77b69052e-5305498463bmr430144561cf.30.1788883074196;
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:44 -0400
Subject: [PATCH v2 08/11] mm: memcontrol: constify the memcg and lruvec
 stat readers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-8-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=6756;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gH8aQB3aEdF5B4e4hdlbYc0wkoHxT4I3NtGuwmHbbfc=;
 b=fX+qGaKT/C/xwXemduVzHicWQARbEqeguciHNhrCLFBOcRm8ooCp70Pe9tfr3DXKYwmxfLVUP
 WqflGGr5E4mClUzFmq5z5bHbLQODv5Vq8d1JNxXux1xLmaEQgXEGLz+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXwPRBwP3CsTm1
 BgyQbkZXxTLc1pcSALeNEnmi2qefbSWXEYtCLFoAs1Ey57wc54gr3dlTDJ0Z1H9Y/BtU1VZFy6z
 3InXch3VFrSa52ytYFRYMof+A1iqWS9DPa8Amaz7nHR7Fn5R9l+oE80IWOJ/xWbzR7G0iwb/ZYr
 c9eEVCdfHGXLrsPN64nKMiCg4Ye9mDjbcwd8eXZlXQvCjCd1V2UTj4kcPmKlmGlx2UFGOTbza0b
 t3SXcTabv87CJ09gKTirC62d8dEcG36vfWJ3m7WbJcy6zmWqR4UCwbrYBXE+QfE8IOSzcNmnvST
 IqJeM/FgN34TK/xiTf9qCmZGGBVWqP5wRfSBW8g7t6dTg/oBjXInZRimx+faxhEG53TBmgDD5g/
 giS8UxhjPcc5JD5aell/M45g5DuJgL5kPLASzUduiDLCS+7f4CnVzteORj35LqOkS2ZhkvOz6nk
 nfDgpww7tt/6oA4pERA==
X-Proofpoint-ORIG-GUID: M2fyd9q04L5ImkXjAmekCMAkq1W0wFEi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX9D+e9Zlhj4aR
 s98kKg5JnKUuwena+JPG59f4YIm7w9muGzfs9DUvtB0I3aRYc37TutDH2DGLXQBj6SqOK+AdAR8
 xdSRDe9FK+MRFrhNokPfB5ZKuNg8wXbLtlQP9c82jpPSGCFYFN0k
X-Proofpoint-GUID: M2fyd9q04L5ImkXjAmekCMAkq1W0wFEi
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa03083 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=Eo118cYSGe3kRcDbF0AA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32BF2180006
X-Stat-Signature: uxmp67fe3up1zu5nr3dgxr6q6ctfaqi9
X-Rspam-User: 
X-HE-Tag: 1788883076-6235
X-HE-Meta: U2FsdGVkX18kf3wNVUDI3rJQhvdQ12E9Gj1rD5KYHY6L2IMobFWvhoeAO0ieFvf9tla54pbDcRlAIU6AzAl4pwsFDimcVPjHss8PssJ0WzJqxQE3bsjydwr9P5NdoVmG0Gy2xp+8kcLuHjEA5MmA8SsBx9Ta7VcqavRiOLs6NEEXn09xyrv7f64gZHCpkEMAI1tExxOU5RWaKEhnAu+x+oe6SRMa/gvyyE95qWgHqHeOBzu3lBU7D1T0g5RcnYMO882BZH/V7jcxqUDNxOFVaPUrw21lzFVygBI2jvCg+yzUX5cn75+tWJ6R6FNPqFQ4hZ/ixT05rQPJ0GE0MWlLsMrLMRxCW6NH64HpN7UBlmztr4vtQLFbErsFbRplMqLlY69NXNeNSAbyCy4jiAk+VoQWb7dNfi4GCHP+sRbkKyU1ax3SsgucWOjVA+FZG6JZsjx4xAGanPz9WQBZokEgj4f3/u0CVI/BXLcmZ4xDJXfpDbvHpKNECaPHBQetENlXH7+J8sOzzn6Td3K6hg/IxL+uNHshCwAnf+9/kY3bpLo/XLH/M28a8S0/MdiIwt9Je7KMv7vuf4lMlNgmr0QyFxqklB0SmjyRkVOqZj+hMZvOsQrre63ocuL24lHVBzzyFgEa471W7ji6qDdtLiFRpF1BUG4O/rBm21/e832Zs+9ONqbdFrY/do8Ir68TT+dUBRqkztOJjwCieDroZsuvtGpXNSgyYPm2t4aJ2Zuzm1WbOTfQJetq6RqRuCaD3c+Euk47jxCrJMxhoB9LITO8Nibi06Vv8BO/MaScGuIvh/OLYrJ84/vs2+aIQqEmIHMM/QuOZiXw/bdri7FThmmWa8bremjTJIhohdfvEIpsEtQIPJtsr92nE0iaDCbyMpBzYQwc2LqMpV5MRJqlX0rvs6588mM/cWGa4YlaaCy8Ba00vlYI6KtvqMkR0z7RLbtWL8rpRwq30hbOMNcMSqv
 NjYiXT3y
 7elP0yyoV2/wNtgNd07SqAVXcu2NzJkiTcrDWRjQGPsUXPJX9RYiu3/KqG/g36fUbZNrVqAv3fjmWmWGG+Io1N0s7vfHr4vMnfB3V6Qy6UgglF4ogefE1cDqDbQCmyrwgw+MVNufBH0Av+tb1OWdcgyo3CXq1AIpNa01CalUjdGjvf7tFkpok25kbQCsEaFXxjYNF7v8qaY8d0jeJYCctwmJGgYUvVfqINV4qVxc+qZ7dhCIlNQZqQotw+kiLgmkPg+7mHaC9pXUR+LrCBpz2W3buldYOQasyHq5Goy1/y5vpDC4UlRq7D5U5lXrWsstxqXLiu7qXf0yNhPx/n4WJobd/0/X4YCqx213PWObc76PVoO8j5zQqLkVGnqDxn+DlM30e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_page_state(), memcg_events(), and the lruvec_page_state() family
only read counters. Constify them.

Use container_of_const() in the lruvec_page_state() family while at it,
so the const isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 23 ++++++++++++-----------
 mm/memcontrol.c            | 24 ++++++++++++------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f04d2b2b47e7..d8600f1444df 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -971,15 +971,16 @@ static inline void mod_memcg_page_state(const struct page *page,
 	rcu_read_unlock();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state(const struct lruvec *lruvec,
+				enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx);
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
@@ -1412,12 +1413,12 @@ static inline void mod_memcg_page_state(const struct page *page,
 {
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
 }
 
-static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+static inline unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return 0;
 }
@@ -1432,19 +1433,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
 	return false;
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state(const struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 							enum node_stat_item idx)
 {
 	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2456ffeb5241..ad9f5e558814 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -490,9 +490,9 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -503,7 +503,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -531,10 +531,10 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * monotonically-incremented event counters are stored in
  * enum node_stat_item.
  */
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -544,14 +544,14 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -562,7 +562,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -827,7 +827,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -1113,7 +1113,7 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	put_cpu();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1715,7 +1715,7 @@ static int memcg_page_state_output_unit(int item)
 	}
 }
 
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state(memcg, item) *
 		memcg_page_state_output_unit(item);

-- 
2.39.5


