Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6500FC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BE36B008A; Tue,  8 Sep 2026 12:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD136B008C; Tue,  8 Sep 2026 12:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3979A6B009E; Tue,  8 Sep 2026 12:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 028436B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:12:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DCAE160646
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:12:45 +0000 (UTC)
X-FDA: 85191088290.21.1FB249B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 869EDC0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:12:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jn6ISzO0;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2abXUw7v;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2q7+pK/fegvYO/+H/qvJUigNWbet/T2/smxNKvcI9ds=;
	b=e0vWNMDb7Z+UY7Ge4LLsIbEG5QBrblmzCAzVdkhlmJW/cXc8VALpGhr7oSeswXp41lm4/a
	dWPeeD007WwpLYxDHMkCDgmoTH9F+2LPVi5KeApofrb1wpCBD0VlmCvw1NMDWBz+yvH6iO
	YuDi6hZUFqU1xPhMZKDTrqdBp75EGho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883962;
	b=ouIsYhjHulgVX8VT6VIFJsKz8tfKBWW7IFJSo61wHva17KXlx94RC/qGchq2hEWvHwMmN6
	FPBx9y4DR5ufXN7jD3vM2F9cOUtEUUsHu9K9T/hJViQU6p/Cq1a4m+juwZ8nn2wZvy7Zk+
	PtU9E6H/TpNsDMuUyXpgC9SFG8jZSA8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=jn6ISzO0;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2abXUw7v;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbbSF1250139
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2q7+
	pK/fegvYO/+H/qvJUigNWbet/T2/smxNKvcI9ds=; b=jn6ISzO0RRsjI2PFcS3N
	AO1O6lCxHPub8krMWbboGE5MUX5VvM4lsoGzXMDjV32MpMviOAxlzULP9eHWVaGL
	StbjXmrC96kWIX0abBypOO1isKiCxDxCdBv+CZiJFIgRuopj5BJlaCCyZo5OlOoC
	FQyZ9Y1LruBeNtv8kh0dHowU2sIbApGhvx36yXecwoJHmFe1QY8h+ulxEK4NvAJ0
	D1k+KVFBt8oeSfiUbOITCv3G8kAOLwN8eaR6czj/13MxpJ5GtJgnDqxNF7RZ5F1G
	43a3ejXWKX6JTyUCkkXMkUDKTyiCgYwjRYQa3AwZz0u3ywdUPHFaevPPre87Ft6v
	Rg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjhqkts1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:49 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fb2a46cb5so107819761cf.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883069; x=1789487869; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2q7+pK/fegvYO/+H/qvJUigNWbet/T2/smxNKvcI9ds=;
        b=2abXUw7vm390Oq2SUeMbGSsFxcfU4uJpBojjJ/FZ9kyJuW9AI+JStCtPf0fBaWVYQi
         8aB7AIPmM82q+bABRC8eDShxWlSK5nM/BTdUWgfv62qelRaI4uiC38KvC8jsdbFytmi+
         xP2BQjXGOTmhnyJXEq2cxlPCQhJ0Fd0Vyg/usWNpKnQSpFiYPziZEzchMGkQobFfkv7U
         XIw3cHnF2p6vgP/5/R2jHQ+uccvEz5rGLB3OL8uIMT+ltm8trhT832yU//uhBuwHKxeI
         ENnfeAqaBn/SnSd8oIUGZqc7JX/e/kgflPJDHVyVsqRTMYv4xagbMMMoaP19R4EVorby
         09Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883069; x=1789487869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2q7+pK/fegvYO/+H/qvJUigNWbet/T2/smxNKvcI9ds=;
        b=jAgMQxmcixhfFkEWH95BUFWM32sojlYpb6v8fZTzWgfsEIYtXC1ouwzvfLo4frLjK5
         zr3b0quMCsAea1Hp/oJxwU1UUGh/IjlYB+ZreMqiBZgTP1fgLyiYjWVY7eE/oTSy8g+e
         hRDrfuETLit8YuURTMCqCgAPG1ZRHmsUMmkdDVjIAIwqa6uIVDg34PqEoU+cLmnKUyDS
         nGjDFnr2ZwH9A9FV+Wz3mwJcj/QogK001iclGs0RJJFqlHo3mrC8nIk2+rlHMaxF3C3J
         9O8hxqlX7k4B2Ui9bG7GOMerCrK8phA49BU5c8tte480XSSwWvT0g8CyGZYYvBy9DX/k
         FsCQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+zgzrsbDfOxaRlgZPaGNfUFuhxQUAZFBjKWJRK0gVOwYt5K9N9ONRgn3mrgYJnxkCXWx/NkxtEQ==@kvack.org
X-Gm-Message-State: AFuF++l/JOLJm6D+jpjJ5Hrs7NMbt5SHCmAhcN3QgelNLgODwWzFfFys
	gedcj9puPENK7EpVPRtDohfhObzTK57DIGs2fKNgYAwQFKkwPrfxuSgo8W+H0ACboDQSBjunu1p
	xYiEtRuPx9Q4Hax3vzCUOBpA4cMZBNBlxc1BeLlHzzN+6778i
X-Gm-Gg: AYBFou2PnNe0XZ2oZGRm4THg/oPaRlAyysBeJuNDr9BfYvKuLH76955lkcxNmMB4gBY
	iX+ucE8aiIyGUiXTnUwDgrKmvoCKwvteBO/GzrPR7+Ck27fYyqKGz43sZ3jTjiNbb6DXvmOUAAe
	bMUGZOYYdkgs0+knoNqjgqSiVTTnVKa8mzJ2r2wClrXy7z2s/9LQHJkKYpIGQtkb53VoH4X1k58
	W7O7I+NURf4+xwXbKjXr6gNWL8OH5AQiRyBsBteM/EmVSzgbyYZxww2/IBqJbW1yEFfvXJheY0D
	3DXtkLs0qvvmhMQ/7/cFSLJhmVnEaiFh9udAAiRYFMKpiO2lVtBa7MXgHvKN6FkZzTK9N3XNDim
	9BBDFC20oQyVkTx+1mju5w+ouy0tulJUZxCZEtVXyIjSeXBp+
X-Received: by 2002:ac8:7fcc:0:b0:530:5152:75f0 with SMTP id d75a77b69052e-53054877858mr367351781cf.22.1788883068904;
        Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
X-Received: by 2002:ac8:7fcc:0:b0:530:5152:75f0 with SMTP id d75a77b69052e-53054877858mr367350791cf.22.1788883068272;
        Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:47 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:39 -0400
Subject: [PATCH v2 03/11] mm: memcontrol: constify the lruvec helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-3-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=8627;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/+62ulVzAM2WXnRhGUmPvVQj53n/Y8t1Wv5NdXRJejI=;
 b=/2UbPzrXSADG9Kn0tAviqEfSjsr2c2YqXCtkwjOFFU9fAPZ8gjJ3GpD1mXeo1sBfEzVfKuMrj
 NoGDbj9AqcABjBSVT9Bkb7oUKitfrh2oJ4MbGA+V/SCRhlTKxTJ7w1y
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXxCP6vfXrX4OP
 U0L9hkEV2oxmYPbSuJavgkGyspkW/RLA4xBEQQeDsYQXNUkKnh/KD3orudlKJGmmKXQTaUsoBfR
 qpRyvHS1hBLTsodFP2erg3J5/zUERe8g3TxMnB2kOLIWycOpxLpttZmjH8hHGbFqxup0Xm4Xk3S
 D/DekhKrHYY1jnLFXggYD364Vp0KWBQYOR/LcDRIyypRZRk2rcwoGUKOa77zaSBXGqkd2Vp4l9d
 b5AgCSuTKqUJn4ZVKUJoOsOJN65dt8Yg4GLQkuMGecsEItkBwhmlitwzex/TwdxO1XhqVXpfMbW
 DvUv+s7hi/WveAzqks3im6hiCU0BwkV6rkZjGULGGpE0DGxgK8y0fe6Bm1jpuZE60JPL9LHWs75
 k2BoKMyQfyGUqWtrb9fGpGE3p66ZYvjzDzMoCDkH4Q3R86vi7xKtK7daoS+lLrNFdiR2byZ3iLX
 YhquDETjaYXjiHIJuoQ==
X-Proofpoint-ORIG-GUID: jjr8spZZMhDkejQ_1cHZzx-xbBRAl_LI
X-Authority-Analysis: v=2.4 cv=CuOPtH4D c=1 sm=1 tr=0 ts=6aa0307e cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=KOoHFShP43Ts9fVHKv0A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX95Zq+iiGKIKD
 BzVv6P3ipM+Zj3/ZUR+nfuLUFSPmrjcAnrQvUvGoxFqY3fBPkiChT/w88/IYyeBGRXFiKQm47b0
 Xq6zdP2vl7/UBZgyXNeXK888zCr7Q8Y+p3gvAVpLXP3lJTt5Mux0
X-Proofpoint-GUID: jjr8spZZMhDkejQ_1cHZzx-xbBRAl_LI
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080172
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 869EDC0002
X-Stat-Signature: 4uweqymruc1tqp4tka5k41yys6dqps1z
X-HE-Tag: 1788883962-380841
X-HE-Meta: U2FsdGVkX1/eOjWtOwP+6TAKz6leD1Hw8rpBkcMTLZxdf93jtULAvZjcsf7pN+KfjntKFkdoSGE6ucTIGbV7sM2K5rXkz2xdfeRZWRLGAD4Bq4N8Ms+Tp2CCA8JbX/GZc058mu7hfea8Y5cNFOOgzbLzColfdmH4/uvnV4HlXY0FJHU84+SI+w00LCGBMwey7fxCZdCeEWn3otwlaf4SIi4y5BKs5tmtqnV5tybrk/zq6IAUWVHok3ZAU1DY3YejWVPcHuh1OnjvCUFy/uMombZv4m5Bu8NJ7DzDoyfdgBHfIGOJVaOmxjMZHhSsAc95wHqv5ihJvbQhSYv+PxDWT12/Xoj3feyYbp1Qvptg9Tjv+Aj+SquSIc7HbFGFz8jTkVvmBEjd5k8VR7vKuugTtG/Ryr3VA6vuPeYzU/ly/7joIJ9I0IDvQYALjU/QukDTGSVIwSaS84j3EE+m144Gs51p3fZviL96h4qaGNArHU59QhKUf05cs8Sm42H5F5VsiiUr5t6/RYFsPrySyBwS/OzSy/BoPvgESwqLfq7iCA2B/hFE3dacPZEOjP0NXs8lxD3vAlpp83AoW0Uu1QjbHIeNZXxoLYH7UGz/3K0MeVZGW5sC0WT73iTog0+0CcVVxrGlW9/LvX5+/sOfdh2Xq8f5E4o5NrO76uuPAJPrmsvTvQbSrRcfWhs8nw/RW/sBUitOvdV5ldoQBcKjQff0AAKBobeSnLiep94ivHdEmYJVW5Gx6Qwh7D/S05dO3O6yo9eiD8vwCH8SP2Z/pfun2zi3w5gsO3vfjUyHAhwokLMhVudOoIcfDekra7Sok032LvDRTK7iMGxKIvK1o9NmFUb4GjjRNOSVpXJvpNa63yTbVDsKjYBwZ6V8UfyyWW4S3oAaC6Vc9xpqXDWEnk/9/okdKEVIXb5OKk4BlmTAJ/LYMhx4nFOY13GkR4YcYVTExwfKZQLveo5dMmMg+5t
 ZYC9dBEU
 X8yezRYwTZvQdy9hKYgE1aKrjoehhPip+kdHD4IZYW7eDz5c2GbZ1AXrKWCGLC5zZQhgnaGG8DUFBF18T65LLXXXSuLEqXfG4mDSqkirGk7XvOdO46616fDhj8ugUBCLMqObAL747WceRS7h2jiOuv7WnYF7ast9rrUCda+W7PB08GG8QymuXSWPSRhtaCyYM45H0p3RI/SSBz5Fz25aK5Skn5/ocBn5vKoCAPvWpr4ySIdihIR+9dfCMxpEJeupI5dW8QnE3o3qpA5OCzZIEZTnOZT5rE7tiDbRnsos0Af48CPaKHN7ZXHjHAOsHqux97OYB+ZSPtqKVD3k3KWpY+/4CUqH3Wko3eYF5i834+ATntZTeCQzIUJ9mFBCHm5IPy4QZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lruvec lookup helpers only read from the memcg, folio, or lruvec
they are given. Constify them, along with lruvec_pgdat() and the folio
argument of the folio_lruvec_relock_irq() helpers. mem_cgroup_lruvec()
may update lruvec->pgdat for a newly onlined node, but that lives in
the per-node structure, not the memcg.

Use container_of_const() in lruvec_memcg() while at it, so the const
isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 42 +++++++++++++++++++++---------------------
 include/linux/mmzone.h     |  2 +-
 mm/memcontrol.c            |  6 +++---
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d2577a064894..dde828a1206f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -722,7 +722,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
  * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	struct mem_cgroup_per_node *mz;
@@ -763,7 +763,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  * their binding is stable if the returned lruvec matches the one the caller has
  * locked. Useful for lock batching.
  */
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct mem_cgroup *memcg = folio_memcg(folio);
 
@@ -779,9 +779,9 @@ struct mem_cgroup *get_mem_cgroup_from_current(void);
 
 struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
-struct lruvec *folio_lruvec_lock(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 						unsigned long *flags);
 
 static inline
@@ -861,14 +861,14 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return mem_cgroup_from_css(seq_css(m));
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
-	struct mem_cgroup_per_node *mz;
+	const struct mem_cgroup_per_node *mz;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mz = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return mz->memcg;
 }
 
@@ -919,7 +919,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, long nr_pages);
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	long val;
@@ -1215,13 +1215,13 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	return &pgdat->__lruvec;
@@ -1281,7 +1281,7 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
 
-static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1290,7 +1290,7 @@ static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1299,7 +1299,7 @@ static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+static inline struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flagsp)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -1354,7 +1354,7 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return NULL;
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
 	return NULL;
 }
@@ -1365,7 +1365,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	return 0;
@@ -1505,7 +1505,7 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
+static inline struct lruvec *parent_lruvec(const struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
 
@@ -1568,15 +1568,15 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
 }
 
 /* Test requires a stable folio->memcg binding, see folio_memcg() */
-static inline bool folio_matches_lruvec(struct folio *folio,
-		struct lruvec *lruvec)
+static inline bool folio_matches_lruvec(const struct folio *folio,
+		const struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
 	       lruvec_memcg(lruvec) == folio_memcg(folio);
 }
 
 /* Don't lock again iff page's lruvec locked */
-static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
+static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
 		struct lruvec *locked_lruvec)
 {
 	if (locked_lruvec) {
@@ -1590,7 +1590,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 }
 
 /* Don't lock again iff folio's lruvec locked */
-static inline void folio_lruvec_relock_irqsave(struct folio *folio,
+static inline void folio_lruvec_relock_irqsave(const struct folio *folio,
 		struct lruvec **lruvecp, unsigned long *flags)
 {
 	if (*lruvecp) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9ae7991a8b2..da6f84530022 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1660,7 +1660,7 @@ extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn
 
 extern void lruvec_init(struct lruvec *lruvec);
 
-static inline struct pglist_data *lruvec_pgdat(struct lruvec *lruvec)
+static inline struct pglist_data *lruvec_pgdat(const struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG
 	return lruvec->pgdat;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ad7de092611..49d2e7e3c023 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1463,7 +1463,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  *
  * Return: The lruvec this folio is on with its lock held and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock(struct folio *folio)
+struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1491,7 +1491,7 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1520,7 +1520,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flags)
 {
 	struct lruvec *lruvec;

-- 
2.39.5


