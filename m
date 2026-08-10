Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553D4C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 05:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFDB6B008A; Mon, 10 Aug 2026 01:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0B86B0095; Mon, 10 Aug 2026 01:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0176B0096; Mon, 10 Aug 2026 01:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15496B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:46:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5494B40673
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:46:43 +0000 (UTC)
X-FDA: 85084275486.26.2DCC15C
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA2D820009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:46:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QTQgY9fA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="F1xg/awu";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of prakash.gupta@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=prakash.gupta@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786340801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1Dj7BlpoxGwRzdnJpfUKDqCArhBsuZ4in/P+GRdEWqs=;
	b=LEFhpxJj9WDfuUJkqFQWgYQDv8iUF+5VtOCIVdeIE/d6VkomXdAQpycxp/fQ5YnewdLKj6
	bTvKryZEo2l4GktP7AuB46w4Flz8Usw8yXfw9qhNiAne6PC0JQ3sNU0VAVH6n+MoPbjc2U
	mcBa81qUZWoKGRnJJkmaXnCclKbcBAY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=QTQgY9fA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="F1xg/awu";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf03.hostedemail.com: domain of prakash.gupta@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=prakash.gupta@oss.qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786340801;
	b=T4bUzzNpORhJmTBR5GWr+depM00D/aRVtMzZyZ7otZMdnQBYbOQexkBa94CM2JKjdVyjDs
	XC3ABdf2VRoRXWKJq5DUmTEfg5AhV3aBP9w4pAo6tJ+8YxzjCrCa0x9WRb0GAnyH21xXdT
	mGEThMr5w3nIN35Gt5EshBgGPDvn05I=
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A5HckW923814
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=1Dj7BlpoxGwRzdnJpfUKDq
	CArhBsuZ4in/P+GRdEWqs=; b=QTQgY9fAYtMRz6rM9nNNt8WssZlgBY27uWyUgR
	rUVr2NOXrPUO16WgjZSlMemU94ve0SpjoiXclan4muYXdXfyaqnzPbdO/8VpxjD0
	mxpDrb+A6sEoK0th5ON+3mAcBT0BZEoeshPvnfW54LxQQUoJ8WPCBxX2I87b3tWo
	4TSdez3eeCLdxOpZ96Kc8kOXH+1fVZZygLfS6II4Aykjk7DXHYZaicxkvZih23GS
	nnVnRadCZ9w522uzUMjKWUE/pBl6BPOaylzvdQm1q460ZK+F4FxygFWY9v74FvuQ
	xZ2/6euTzZXZO72PbpvlSELyks/npMpvjesjTcp7pR6USQ5A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy18xs0qc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:46:37 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso3189965a91.1
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 22:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786340797; x=1786945597; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1Dj7BlpoxGwRzdnJpfUKDqCArhBsuZ4in/P+GRdEWqs=;
        b=F1xg/awuODqIW/pZJFiGestuvQfPJkBtY65c4y1LcPmFs7u3Ng8B0Um0/o9lxkNdn1
         hnGd3yC6FXUupaUKJlIQyPfcM5miJO6sv9RbM8xgnkH6g9YJcsgc8rK0u5klv1Ho+6Ip
         NgN1iYy8vN04QDATKebMjYjgze+NeCERrJnoAOpNEKmpaZdVRCe1tH73BaweELlazQlD
         EEWLt+x9xfhbOdFZ4SxElKXZcJ2uT9CZX0DSnonCEDMh4/LEVQUI286gFAw2e4rX5+mL
         VgXe1Gx7V4VkM3XsIakIRsT7rCOiVIh8Pdk8+pvrooTE9lTvfZdEDEKbkxZqWFFVGp+D
         h8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786340797; x=1786945597;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1Dj7BlpoxGwRzdnJpfUKDqCArhBsuZ4in/P+GRdEWqs=;
        b=QxCcO2uwwI5vUwLOmh8EWj+Eu/ItChrjmLyvvb+QUDQTVgbw2vplXSZyyVo1v6DWjN
         wXu9hYQ3D20xYVgYvUafkQVhbqv3voaIPisGimCcCHEYXYePenTkUYUNQ8+zVmN24IBI
         FBYS0tafTcgF9o7tOdx4/IPjmgYv8P42CHqRztDON/0+NiLZim2F4XtYoG8UVTR6SWEB
         ZOBPrGMnUZSuqtIChHo18dH+VzSXiyxmAJXre9CmG1vGabWjDMw0xFvZoYZhPJZgpMvC
         /XGxJaluZyQ7zqDMuV0SWAVhCiqMFhzOIPnT0GkXDiPu+vlDsb+AWqIC/Vkdlk5Lnehh
         t6CQ==
X-Forwarded-Encrypted: i=1; AHgh+RrofIV+2/YGx10D8Cg5J/GT91SRye4hnuPyxgQum9GWzqcjgtbZNqDO9wLOwNF4D+d/izNE8/2jyw==@kvack.org
X-Gm-Message-State: AOJu0YwMXEdughAcM5kYCFPrzUh1pnsMc7sCtbzN0Y3g29MpQOlz3XDV
	QpGFCJ3UtshrXkAdnPl//g1gYNqIPap5WbJzU9JgFH7DTS9sCV6DvikAV7Gl6sfAB+/j/191JjA
	YUUn5iARrsULYsxYfKJVIzM0ZdZcgcw6qxTtnMaXNVP493/X02J48/g==
X-Gm-Gg: AR+sD13h/hm0OaYqbsRh6o7sPcAzmNLB3ukVo9aOaIHxoPUG5eBiDFaicmFZ4s2zNOt
	vXPFrbMtfODnLJUVjrgP8s8Crte+rwAuNvUPCXfjfEMGMJwkJLlnjdKT8N4l+I1BYmEbMyPljAU
	nLf1wVIzHuyFEUfLVurC6uL4F3+WyujuXcgfAiEXAUpXPoEHk0QdR2I3X5JozD3CW/6uhQT+zm2
	U8ntA7A9HoF95ukjguCX+od4UHhGvInCmUCLUAJ/53ZEPoUR56h5MQKuA3+jH6Of37C535XD5SI
	X0mXj3u77o8w1ampBTDH1DOMOCS7m8fkjWZjK+YxV0UvKXUiL2p5tJ0YPz7RpTYMnKPgR7bH6GC
	uhvFNjD0A9tOdDqrHdf/VGAccei+/ypw=
X-Received: by 2002:a05:6300:670b:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3cb85ea6f5cmr48532885637.23.1786340796747;
        Sun, 09 Aug 2026 22:46:36 -0700 (PDT)
X-Received: by 2002:a05:6300:670b:b0:3c3:a1ed:3c23 with SMTP id adf61e73a8af0-3cb85ea6f5cmr48532843637.23.1786340796277;
        Sun, 09 Aug 2026 22:46:36 -0700 (PDT)
Received: from hu-guptap-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bebde308sm39107186eec.20.2026.08.09.22.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2026 22:46:35 -0700 (PDT)
From: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 11:16:30 +0530
Subject: [PATCH] mm/memcg: fix NULL nodeinfo[] dereference on late-onlined
 nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-memcg-nodeinfo-null-guard-v1-1-77a73204d63a@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIALVleWoC/x3MTQrDIBBA4auEWXfAmB9Mr1K6EB3NQByLkhIIu
 Xsky2/x3gmVClOFd3dCoT9XztLQvzpwq5VIyL4ZtNKzMspgouQiSvbEEjLKvm0Yd1s8ekdTmAe
 rh3GB1v8KBT6e9+d7XTdGHwzxawAAAA==
X-Change-ID: 20260808-memcg-nodeinfo-null-guard-dce5f63a2349
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-arm-msm@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Prakash Gupta <prakash.gupta@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA0NyBTYWx0ZWRfX3UGPnpwIztmM
 Sj+jKJzSpLBo/r54ljYneamN21viEYn0rb79K//q/zeHu+kkyLvLYP5lMchrkfVTRShVaH4uQv4
 WiFzLLUNZ0tBatDtdsw3AYOIgi3paHo=
X-Proofpoint-ORIG-GUID: XRoFf0Zr5BJbPWkQXqCFOU_5-FB72cma
X-Proofpoint-GUID: XRoFf0Zr5BJbPWkQXqCFOU_5-FB72cma
X-Authority-Analysis: v=2.4 cv=bfZbluPB c=1 sm=1 tr=0 ts=6a7965bd cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=GS4ghhMgoEJMoUnwAloA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA0NyBTYWx0ZWRfX6VLacevN9Xgq
 H5uqxKPumf1IMB4vlbKnN7bcIXq5eprLGH/sC7BWq62xagAa0fdDpm76juDYTh3DL/HbXFBgA+a
 S30DPeMWj/LjnnGKDkrImx3YX4CJJJTUZeevjycuOsh3DqCUHHYqG4YMFsOZE5pZ+MmP3R0w6wp
 xp3eQ3OTXM/uoT1OKl+vi8yxP4NTB/5Yl8FNprG4tNW3rTPpbK0z4BpGQAxu1CuA4ZDRuQUjiWu
 6DWACxov6BXZQbw6qk8ygGR+hnrNg6N0uU+XLOfrDtPSrJpEVsezonnGT+2tXEARkjTBxBa9ZnR
 x0nVz8DvT59pKVt3p3cp32EAVdKlj2OqhgLdlDE7SJS/EqhF0sXFvhy8uuXYAK7bKhVUbnDMFye
 vCsml0z5Fp+aT8LfICaO6s6YhO+drD25BInR3MwwivsC4nQVvN93RCgj5R3mdWBx1UX6z/GUf6a
 pCTX23w6TUsNnbo+fSw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_01,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100047
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA2D820009
X-Stat-Signature: dqg3dodq8h5fkp3pcq1pzxzmrawo99kz
X-Rspam-User: 
X-HE-Tag: 1786340800-822199
X-HE-Meta: U2FsdGVkX18RgdD8cZqDl7cfFBxOHxxfYL7H9oS583PFf7qwez9Jc0ggtL8lc83UkPeWZ05rtaADv7UucNdCBUz0OHQtf9ePF4+mafeyZPbas0D8erEiJgc38LEWdyFNzi+bhdZe6eP2mJU9SNBi3uyhP3Ld0NOeXJ5CNHVUJQzzAsY2gFEdg/J3PfUVY4qMsx58wtgX9712sseFCMR/P1tLDqdrMhk50Wewt0jBkFNDgKtvIJBcV04quSaAvuk88jrqb4/9C8BXdSn1f4RoHB8PUvWcfUVrkFyA0qvabj5//F3UHefYpBCwquFVIFTU14GbtNlII5CKT6ENQ3vN5tSpbTCxOvD8wHAnjEU4jKeigpqQ9JgdQvS2r/zZ0r2+UKmDB7Pmhly6lccMvwfAmbQ/yFR2/omKXCanxMmPPiHG5+0IT7N7v2wFyHcJMGGqBad7J6Cw9YiPCpstpb0AWkhMfpJgoSklQDTAoEGMBQxDMuelQossuZHWqgPHQVBDOjlNhNHjv8hM2PUmZsmOOzwNWMn5VyIsDaMgPvVUC3s4mL5i/rHqnN7wAlO5VVWdMSR+CC0QpYBghP/8/Z4y0kM4uRdWSwBs2d97YxJms4YZBbJRmEZVUtw/DuvGbCioyXOIz52W+rwcV+GutHVTHKESNYbnI1ZyxS1jgBJCiCyY7r2scMyXaEYo82QjzlZ6Euu3wVPaL5vB5xq6MMelchWv9sSyxcHS1nlGDoTOEYQFoMcDiaSUBlORIMQg1WGOTEfJ9Ssy2Dha3A6C5Moqj8OONEI1K07K06+OoNAC8PxSpL0+Iu1lZ+nJFDpdBURE7VxhBBsDT+7pS7uXnvXebSAIfqvBVLtoVYK5l3asHmrLmruFuJdjC3vfaTy8BIPkbykbGEULxAcAW4IeKiM+9TfnJ/nn9rp6d32JedAeLMJIfJOQTjCJ2/U2uuqy08QrsWVk5TkZaHGVNrNfL9E
 4vXiGLyn
 V9uzYtiR8oFZun2Gq6YkUsz2/Ui+F7E+Z+t7vN1ACp2iHuKsb9yVS1mMj1O5oZWWzpWSHdsgQ+9kFxBM7vhjdfBlYLEY18YktMbSZ4+9ZxH5qBYZZY/Mh33nLtdMUjF/F9Fx4ohgNE+GRw4osDk5VsOsuGdgXxkavnbvWx7PV73Il7cSQEoRSK6js0NQprlrCMsCeBldjaoNGLPwJSza7x0XQ3iGSx7ZC/aanxJ4HXszTj6fOpsRooNf4HuBE1eXtG8rpBa5NF3qHgVDs5X+qwrONkTlLTn5/rUxLT5eP9okfCTTnDTwy1K90n27D/6HltggLvBrcIszCMT/SveuLkZ/qJTpQHbbrn75bAwgjSqtkkRFbVb58GlBfVd40KA4sW8t3WL5hMNXn1W3kNNkEH5FwQlaXdejqO5LZ6F34OhgUGf5kkF4E181zZCMI62n+mSb8HXvNTw2VKryjRcOFHBAk1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg->nodeinfo[] entries are allocated only for nodes present at
css_alloc time. When a node is onlined after a memcg is created its
nodeinfo[] slot remains NULL. Two call sites dereference these slots
unconditionally:

lruvec_stat_mod_folio() calls mem_cgroup_lruvec() which reads
memcg->nodeinfo[pgdat->node_id] without a NULL check. On a system
where a node is onlined after the memcg is created, any folio stat
update for that node crashes with a NULL pointer dereference:

  Unable to handle kernel paging request at virtual address ffffffbebf7e1908
  pc : lruvec_stat_mod_folio+0xf0/0x444   [6.18.21-android17-5]
  lr : lruvec_stat_mod_folio+0x88/0x444
  Call trace:
   lruvec_stat_mod_folio+0xf0/0x444
   folio_add_new_anon_rmap+0xac/0x2b8
   do_wp_page+0x768/0xc80
   handle_mm_fault+0x37c/0x8c4
   do_page_fault+0x140/0xa1c
   do_mem_abort+0x54/0x74
   el0_da+0x48/0x8c
   el0t_64_sync_handler+0x20/0x130
   el0t_64_sync+0x1c4/0x1c8

__invalidate_reclaim_iterators() iterates for_each_node() and reads
from->nodeinfo[nid]->iter without checking for NULL. for_each_node()
visits all possible nodes, so this is reachable whenever a node is
onlined after the memcg was created.

Fix lruvec_stat_mod_folio() by checking nodeinfo[pgdat->node_id]
directly and falling back to mod_node_page_state() when NULL, mirroring
the existing !memcg early-return path. The fallback must not go through
mod_lruvec_state() since that calls mod_memcg_lruvec_state() which uses
container_of() to recover the mem_cgroup_per_node from the lruvec
pointer; passing &pgdat->__lruvec there produces a garbage pointer.
When nodeinfo[nid] is NULL the memcg has no per-node accounting
structure for that node, so node-level accounting is correct.

Fix __invalidate_reclaim_iterators() by skipping NULL nodeinfo[] slots.

Also switch lruvec_stat_mod_folio() to folio_memcg_check() which uses
READ_ONCE() to safely read folio->memcg_data in an unlocked context.

Fixes: 6c77b607ee26 ("mm: kill lock|unlock_page_memcg()")
Cc: stable@vger.kernel.org
Assisted-by: pi:claude-sonnet-4-5
Signed-off-by: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
---
 mm/memcontrol.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..2a6f02956b89 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -977,11 +977,12 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
+	struct mem_cgroup_per_node *mz;
 	pg_data_t *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_check(folio);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		rcu_read_unlock();
@@ -989,7 +990,18 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 		return;
 	}
 
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mz = memcg->nodeinfo[pgdat->node_id];
+	if (unlikely(!mz)) {
+		/*
+		 * nodeinfo[nid] is NULL when a node is onlined after the
+		 * memcg was created. Fall back to node-level accounting.
+		 */
+		rcu_read_unlock();
+		mod_node_page_state(pgdat, idx, val);
+		return;
+	}
+
+	lruvec = &mz->lruvec;
 	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
@@ -1320,6 +1332,8 @@ static void __invalidate_reclaim_iterators(struct mem_cgroup *from,
 
 	for_each_node(nid) {
 		mz = from->nodeinfo[nid];
+		if (!mz)
+			continue;
 		iter = &mz->iter;
 		cmpxchg(&iter->position, dead_memcg, NULL);
 	}

---
base-commit: 075b74841bd0065a3bda3440873c747938e69b68
change-id: 20260808-memcg-nodeinfo-null-guard-dce5f63a2349

Best regards,
-- 
Prakash Gupta <prakash.gupta@oss.qualcomm.com>


