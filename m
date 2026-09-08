Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42626C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05CD6B00AB; Tue,  8 Sep 2026 11:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCC86B00AC; Tue,  8 Sep 2026 11:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A090E6B00AD; Tue,  8 Sep 2026 11:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B47F6B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:58:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCDED160677
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:58:03 +0000 (UTC)
X-FDA: 85191051246.06.9F669CE
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E90CA0010
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:58:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mFTLj215;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=LvuPDp2t;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZAoAKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=;
	b=AeQWx4wsFu7SWKZZAqaGM0gx0Gg7/tUCnkMcNftgajLecSKbYZYO12VxQ+/Jpq8q1MMfSV
	L5LzXqrKfh0Kf3CL0sktwTC7RtELvDpnyXjYVIdncQrOYFKEBnc8elRT2qKfM8QUUJrpT9
	CqXxfCjAfVc9G5WVrT0+Yj7YN5fgGR4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883081;
	b=koMGkWucB8GGPTWDL+6BlSn7LKTvYlZXNT8HAlRhc2ocuF3TDr5UmR2bpK9nxzhipKz86W
	CtlZMZ8ep+78SOeOtEJzOVxx8of5sF4Gbi3Dq5+0gZDSImbalmNXfoAq8D8GGZXBKHSnvL
	6Vmv9Ly2T9IHZC6ozMd+daoh7cdOp4E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mFTLj215;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=LvuPDp2t;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbkTJ2589012
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=VZAo
	AKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=; b=mFTLj215gL9krPEnghEW
	BkCATtqnpnf81Q3cOJ9R2JvvxdtoE72lSDbkObhiFhaV6HBGqwfUdjUjppn5EdqR
	GwHg85a8euVyqr7aztrEESAwfVl2NJgSn+BiCgP2otwtdP7F+iBNyTJ5OvjqUH+X
	0/GGR+uLCd7RNZB7DA/wERFnd4GEGFJiQ9IhGZD/eiHLtXtg/5yvN1H5C94l/Swo
	KKGqTLtBwwSt89K+jVaHjX3t8EpIb3Am52sasc5eNersEdmkInGQu0yRjBqc9n04
	bNmOUNsFq8FBtcSIK5iIVMJLjcCWsoR5NGEGzKZirP//87jVf3mkCXbLf8IK/lPz
	ew==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5dmac-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:59 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52d33c89a29so106163301cf.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883079; x=1789487879; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VZAoAKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=;
        b=LvuPDp2tWHIFVrKuI9QFbNrOsHPg5EZ9tYfEPCDgyC1Gs4uYiQuGdKQDzAPICIli8b
         fX/cG41xDcRYT8+8wrsz5iABE2Qbd7w8Dw2GlMtBQE7GyPJ/l3qprvtmn6i+OzdzuMAg
         5LfxWvCgnSmZpbe+S6LAyBfSN1IkNRem5m0/48BqWd60m1jAjCKIW+eTUPmoWIS5Uy52
         WRzCuhIGr1cf0jgABwyvnku6u9NmlyVx+98oxw0q5gFiDavbWJivJR0y+V73exsDoUT3
         /x35auUwiJa8n+gYKICjKdeGQCbBo+P6uuFnw7+1hiN+relqUqv2vPtbGzHRm/T6Zu+5
         n9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883079; x=1789487879;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VZAoAKs2Ax9DnjZGlZmzQZMg+pVNkC6x9N/eAHovH94=;
        b=jHRLxZPYR+PjU9H307LTIX3JO6l7RktKq6elP/sIGxiz8/JBvQ0jpsrDIPOa72/GmY
         0mGcXkawg9PRsW2vwYX+kGjQHZKdf0RzpJh1scQXz2swpne466T/HwIh8jEr7Y9Zt7tj
         jRalq2IXxbcPyHBNewyYlC2f7DT303p1d8wnxoQDPSDRScA+ioHi8pnQqPSYZQFEWwAp
         okJVnLNMnWuiTgiWxwLSkMSmHXYH/nHysUp4NjJLuCEsXPVY+L1za8rS6XRetBt1zfvW
         KE0JLW+JEG0+Sgov936ra671ijjz5DJvhznDZAExoN5surh0P1nKyJ4NPb5EZXQASre/
         f4Vg==
X-Forwarded-Encrypted: i=1; AKwUvBzN5klxyJi9B1UxX/0/cvT4zvoP6k/j1rYzFMCQ3rPWmFNQW3p1ELhMZZjxOBrXLxOrP1ej8czDPQ==@kvack.org
X-Gm-Message-State: AFuF++m+58TEd2n2H3MixHzDIcMNJ3VoHq5EZzdx9N3QczEBFMk23TkK
	B+OuK5ZVnd8rwCijQUnSaJOC+XNIUyOPy2AFMtAAzhjar/yAl2lRFi8QHko+V+fFyhxeMMytG0t
	YM/re1ipytwcUVz/Zl7A/KdG2JwmZ4c5Y9h9FpyI4C7xA+0aT
X-Gm-Gg: AYBFou0FpZ24ZldBs0T/01v4TWhKSmLVU6Ok/jAks73FDMSsGMmVi5qC1eJHmq2SEdS
	HjaCpFXzlc8qfQaFCw5O5koQ1JckNdn1ECYArMUZNkS47uX/i/H9HdktGWfWNs6kzTDDco/HHd+
	Rgqq5rpeMllk1fcK3sdSlSdITVo6HRiN6sqvXLDKP073jhHYsA/KoCDCQ69nqzuhufnKL7i7rJw
	O4Kun+RFn2xHPEkZNJxLPdA7KNZ7W757mXbbtbZ0u2jTNonHR8/yZhIxFjO7yvcfqDFTPvTCgxP
	mUKE4UBIdauaR/xff0zY7vaSfNGGtnEXVgl9HXTghLGElo66poNsVPiAaQfUph+L17D7oCFkzq6
	o38Vl5j9HH48FFI+gtU7r66sblxW7D9Pe4F+Bqs61Kor8nQ9+
X-Received: by 2002:ac8:6f1a:0:b0:530:2146:81c with SMTP id d75a77b69052e-530547ebfa7mr375745691cf.12.1788883079038;
        Tue, 08 Sep 2026 08:57:59 -0700 (PDT)
X-Received: by 2002:ac8:6f1a:0:b0:530:2146:81c with SMTP id d75a77b69052e-530547ebfa7mr375744731cf.12.1788883078431;
        Tue, 08 Sep 2026 08:57:58 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:58 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:47 -0400
Subject: [PATCH v2 11/11] mm: memcontrol: constify the zswap and socket
 pressure helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-11-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2712;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sTxDvcBSc00s+E0SSNkYgU0cKv4ApygZkq2VbRV+db8=;
 b=sJizXWoGo1rVvGoDXQiLVN33M72gG7xZZyNbel4ui+3OC9JpfjXFuF9ei+YJLkZw7mYNNJkGq
 7hffOHn34/7AqSurvRku8iBT7qln4VRWvcwQhBnarz3BH0ZJAGefK0G
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXyNZ8Cu6vHvfH
 RlVE+MpI78tGg4n90f77VMVvw9Ya+xwHFPov9uaScBJ6ekhlzA84BMvAgR3dTi02ID4Ym2v9A4I
 EXH6oxpBZnf5hwFstU2p3MkPef3SfOCk8mnZkNhWFXRB1eRtGnGyPa/fBWDizYJHSFNNssHHghL
 2aRVj1BMIq9VTzK7RovL8UsvttudeOCUKRxaZNemvau+jy43bt54gQE4IZXd12bjQ7SW4Klbkgl
 c9/iC3DV7YG98fq5bZbhOJll3ULjKujZxS4h9Yd3S9r/3hnm80wQw3M1VkeFVwHhRReg+PMACxY
 FNYxt4bFGI8VIq/dgg/ozlpUd3Jl8TkSaJhrcOCAHZsu70/8Wo17E5ge0pDDdTYU3p5W5t5IOj1
 2gS8/URVr5w35scmaWuZJUCHYAzBCdSolq2MGp3Hf2AZh4t1Wy5F9F7Q++REoSHgBx/KzTE1rV3
 ETCIaVyewzYTDocmGcw==
X-Proofpoint-ORIG-GUID: 85LlQIIiAm_E2pn8nrYmFGEAiX1EaDY_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX380tdzp1DJ86
 l9dyEOXav3wPFmpSnqdwM6t0cTQbYZq4Tn5U/kZUBhXyBB8VYUXxM1qH3UT9Cflw5Hx++Hz6p4j
 9MxZRFYQ+0RNI4Q0mx6ySaJjgfO6jGp/qgwVnbm+hb4pvC+8W8O+
X-Proofpoint-GUID: 85LlQIIiAm_E2pn8nrYmFGEAiX1EaDY_
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa03088 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=JrvLMZgmaQ4VKr8cMrEA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Stat-Signature: bxff8ui88y15noae79y6pkn9yormqu5w
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E90CA0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1788883081-463615
X-HE-Meta: U2FsdGVkX18RlEke/4N11yT1h6IRDw7WohxfCkQFhtbr0FmQGlSUccusjkWisbXdmKTfG87CQgOx3mO+uTSMqw6wwVhDle6ohxS62a/PZJ9io3LqQ1+/cJqwJ4VRD0KGYPAjtqO4zRtn91Mh/FT61OAlS9DZaoUir0Z/EpNeOkfNs50mC4k3n1PjgX1PJwP1tIw8po5w0w/s16T5+lg63Cf0+Ay0zL31OT4comV+rH7UfK2KVc/kW6Stxy4ee7rbQprDe5KGnfTMdSVbfRbz7Etk81SKxwCpjBxej/9lRLFS/n8/PL4FeBr7Umy3YGTPKoR2FKYaOf0iJJ5D0FMwTgqY9ytiCs46UyZryL3EMZkEC8MlQE8Hn2pu9MJOUk+IwNw3zjIPMLDUdwQkonPjsCZR48Tej8itXXcsIDXh1h2BY/5I7kkTHQ4wALlWnnKHs3bYjnOW+MvxoFN5q3/N7bIRhZwXCSo4khBSESZjCmIcW3Z8oinp8/tU+GRouSWfp1M+S4kfusTFNqZlPcCczIlAT+1Mz2nwSqjfCdjMTpftlRHu+bku7RrYv694TctRAyK7/PF01KcmLci+8+5NmSA0MKvSsiGa3t5XBp1X0Qlzz13JSkcqNdMpcpWrtOQvfFIj3jRpJ67NgXSfWlAKRzsGyCtzPF+aeXO/c7vyJAjRPpPZagS2oE1PEPu5w2TvKKrvM9ncRxcasb3S/JEUPJxXFCsoBVzBR3titQB49KJCiwQ6JZzdtSrcK4kVg6e5Ekvwaw3kkgcxjX7UoHrKW8x4pdWTxG14BKvjifLdyTQK94vOckB/lmoSXAimp9W8hYxPJSI92fuy/GlclC8L57tgIpmstzRjbAvW73XnKjuYFRL0L1I2KimxDBMLcrAH08zO60yix6ILd5YP5HeVhVyZVZcQ7CtYb4nBkyOmCIYmQm31FajFh3w+XgC2jtHxwAMXki2AeEsTOcyzu/F
 +UzGFavF
 iiQZ9sTXnA426zc9AfYCJtKy2oox/DEYKrkGOLY8Jl6E/jLZagffq2sIJ6kHW1isGF9kMVfbxGOsZB+gByiGelfsMWTw5I1aQGqjm/e4Lh8xkwvRhCFYzQyaECI7f//ebvTuo7BTZbFs6fj3DPnH7ebsQYLpTecevNi+snQ+9K7NHXhbGkotaoWXQ56/tUSiUZFV6Nj7Vx8Cidh3AwpBGU9KrMIGt5v0NGYPFZbBUrm/NgWxnBTBi206hxJemaCDQz/YlchIOm63yCvbfg4TYHg3ms5LHuAhW8Gf/cZ1ucin9dwVeEGIoVdu6sGlpXTvwL+mge4ZNT4seXO/hbfVc6/w990/rzRq27cACU1ZJq37Zji36oYQMAYN409Dxk+mCvHNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_zswap_writeback_enabled() only reads the zswap_writeback
flags, and mem_cgroup_get_socket_pressure() only reads the socket
pressure timestamp. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 mm/memcontrol.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fade4667d9b..ae044d77c79d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1684,7 +1684,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	unsigned int seq;
 	u64 val;
@@ -1702,7 +1702,7 @@ static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
 	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
 }
 
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_get_socket_pressure(const struct mem_cgroup *memcg)
 {
 	return READ_ONCE(memcg->socket_pressure);
 }
@@ -1927,7 +1927,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
@@ -1941,7 +1941,7 @@ static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
 					     size_t size)
 {
 }
-static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4de2aee45ac8..517995e418b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6259,7 +6259,7 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	rcu_read_unlock();
 }
 
-bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
+bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
 	if (!zswap_is_enabled())

-- 
2.39.5


