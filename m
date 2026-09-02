Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4BEC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0E46B00AA; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8CB6B00AB; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4E06B00AF; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6AA6B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3074D120291
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:33 +0000 (UTC)
X-FDA: 85169808906.01.6A2ECAA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2F2814000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Q/m498FH";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uYKNWynT;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ek2VVn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=;
	b=l4pU33WLIIbzygZzvxJAkIlDHZPrshk+wlcddQzmKTLQZRJFWWuObtjHneT0Xv4+9s8fki
	jAjr3y45bZIDgnxYZquWg5dB7IwQnzGIMda25hoo87dEBkGhk3txkzqfwm/Wk8BsH0T/sx
	0m0S7iE+i8UxCuOi0NrG0v/D9U1NT7c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="Q/m498FH";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uYKNWynT;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377310;
	b=SmehzqSgQIWgkUh3ue8SmpDKRo9BfL7++nDzQBQHJ5huDrlidfwX7mVg1HP/B8kJNNlyn0
	lZfCDoFmXHGavssxNPS+GjsN9qjcRkS1fXb3rICcLxA0qJVlj12SU5MllLhgpThZ/b8BCn
	DhdrxkisR9XOkFxIOB75p9Jzq+PU0J0=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682J5aX41027254
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ek2V
	Vn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=; b=Q/m498FHzhHCYykvxZ4l
	v21h3KKPs5xyCNbckieb5WDouZ3XbqBGjLJTiWts0FcYyBmiTndo97Loj3VabsHC
	Tm9WObX3qSXHySDlyDAkC3BLbbfJYWu9kD92+zldreloEy2rlIVY6jhWX+Vbz6Ro
	SCbotox1nmHlZz22+tpevgw8MQUqt+B7GYLXRZ9WQwFC5YZg/jc9lAL20e9kyfa+
	r1j3rf1w+I2uCPlOew/9fUMuGdsSjwAqw/HXjWm+ZhJgnGVaneHfkV0fsyBJQeKf
	DcQ5o+2WA1o5DqJY/7x9E5m9SnXsxVP0HNBppg1A9zkmLdiDaS/eifkWpNy5Iz0L
	Bw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesner53j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:29 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90ce9ff466fso30531696d6.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377309; x=1788982109; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ek2VVn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=;
        b=uYKNWynT/axAJW6aimErYNDryf1zLDE465LRseUwr4W4ZzO9NRCtAWJhdqj64Xs5Es
         KcDb5CEg6l8DKWuur+S7sRA97FA15QcpnmpYLom/FFpgAKB6/XYd6nq3HGHdWUQVplU8
         MNUO468+qxQQiLHI9bbNh0QuzvN2bdd+XxivCIVVgnlCgOM7Qe0BBTsDbN3VpRdPNxPD
         VsNu/a6rD10ghBlc9sqoSO4KNgKjkbyB+BeCBagZgEhkWZG3svUJf9S0jrOqDXGR1vyQ
         KyG72qI6Jzsxzsfvnd81dr7QEHMKATT1BQgNdM5OGWrl32aQ2ts2eVJYIvFXNVj2LGC/
         t9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377309; x=1788982109;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ek2VVn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=;
        b=LhPDZhXuXSDrplx8yht2rDDF2BfCM7dKZddgNLDVjL7WOsz/bgYMJhAle8xHjPqO2J
         iacd8zbezfmw53mkIwo1X0X5MwYbbZmCwXl6eAx2lrz8QCuPCLId7bAZcbfrmO/zcjNs
         i7fccFgUC8vhsaoAdw3kMZihboqcddlWDlcvd9T5v307gcxX7/efn1XB/5OfcgaAc1Ky
         /hH+HsPgh84sL6QK+lOlk/yCSyBLI4lvCCXW1ROPpeua0pCLSx88OFmUa4JcivZVeDGx
         PrNH7PstNJfUi+CNczgv9kz1r/jPzPrfFZx91vrexu6hpeu4XEt4I9s0hh9f2SbX8DVC
         qQew==
X-Forwarded-Encrypted: i=1; AKwUvBxcNygcAUQ0NA8W2+Vjtkxh0Z+oD6PMg/MLaLt8/4tTWnDq8bW8Sdi1Td9s+GNhmm3yTxxUW/Gztw==@kvack.org
X-Gm-Message-State: AFuF++kFd8ZRiugDay35Oi6FxMjAOT7OHRS5gsADZlNVZl4DtGVTdS28
	bkYPQdIEglvHkjdFXbqOOj+EwDnbnpIsGpXytuqo3mtH8WXsgtkJUby4UYdEKGWvmqhpaqUjqR7
	sTms5OqBlQTjG6q3OSRuz3GQCPlmXOn44QTm9rMcxyz9b35j+
X-Gm-Gg: AYBFou1YF3/wgUkz4KrwQI/BmLKRfMxpjyTxiOYbywVged2FWxJFfr3HVnYKZSfE/5b
	8TDR4CI9aSL7z4Lsew8Qgim7dpqNps6VUePVO9a4oY0+KZOLcFuveHGnbpC8Q+eNX5OGisNJw6n
	Ep9my+5oWaC8GImXe2N6kxcx2ErDUsujG5J66mFJhmogrJV/ZD9JhBKqSHBVfQ/jpoE4Asic5xc
	cIjjBke9HSHBHxcj/BC8X6VY7C7UKUmCItTjHxjChZnqUltXVSaldKdgmREVPtNaLlwaKvFRpkI
	Z+xXpUC3DZhxcpB6icXp+z+h8/c2w2W13SCcGna2Im1k5SpTgl3oa093HnX9gNk2sQvjcqj6Cjx
	pj4YNXXtipRQsO7pHDCnYOrKnOXX4YHblRgp5JJgvNURyer0ROMEuyw==
X-Received: by 2002:a05:6214:2466:b0:8f0:afa3:594e with SMTP id 6a1803df08f44-90eca358387mr93200246d6.8.1788377308917;
        Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
X-Received: by 2002:a05:6214:2466:b0:8f0:afa3:594e with SMTP id 6a1803df08f44-90eca358387mr93199426d6.8.1788377308183;
        Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:54 -0400
Subject: [PATCH 08/11] mm: memcontrol: constify the memcg and lruvec stat
 readers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=5368;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wC5jQEJdvXNDOvELuZJOYHxO0UgTX5KCQayPHi7yS98=;
 b=29lTNNsiv989SgHNrVYYq1ulj9KInk5RyRFJF1EeMhjajtR8sVabNMOFw3PWq2CkX9nOTKWI0
 K4q2P2wcva3DUoxcEdjh1/PTJK6MBR4o6aEDcXIu8XArbq+1DYS5biP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 8-NWVQmR6oIwc75pDjIxhorBWgcWdEUX
X-Proofpoint-ORIG-GUID: 8-NWVQmR6oIwc75pDjIxhorBWgcWdEUX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX0qNobGe7XEyL
 D3bCYxYwUz5TuFV7QRwfurpAVVGjCB1W53Cho10pT0EIdKDaW18anSKp/WvzAzhrO4R7PU3y+Ig
 K+941ZZ4en5StyIzkPtBSfA07woVOUvZzwUzKunNb4cvy0qFslNv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX2pbaEf5unh8V
 ohsNti8Ydg35Je8flq9ER0d0pmNdruGp4XwQ7qBAuT6NmRIwFhBDhFFlLYZfB5WV+9zZ/RgkWM/
 /nGuZ8iq0xtmOswRLt3Lo4AL4i0coj4NonGS6MkitM/DltHrxQw1PliZSUYMv32RkeNeOqQoZGr
 e2WjvlmY56Xo/V0fqETd+kKXXh8tup32QidA40uTSDWqp6KkQgtWXxnR6dql4Qec8rzDVW3DDA7
 /ureo0HYpd/uqayeAQWF47+4aeUcJfCuGBI6BKGI2GtDdQs6wCqtYCPtyVwD/70SY5J5+rAQgEo
 VbRJWby8mApDHFxNzqBDsb6F6SSrAvdRO2wy2RHboBPcHA2lGyIxfeWGHXhDWkS0XnZlAJ14U+Z
 SdJ+VBn5WuICVmDst9i2KV9yVq7HvYcIYN2qOmny6H3K2VM++HKQlmIu6Gp82JgmVPhpaEY2eDG
 kkbbi8W+qead5fMjcag==
X-Authority-Analysis: v=2.4 cv=LsSiDHdc c=1 sm=1 tr=0 ts=6a9878dd cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=ndtaMpzIUFG_VZog7AQA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10 impostorscore=10
 phishscore=0 clxscore=1015 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Stat-Signature: 5pep5jyeid1nh897ec7sczehnjnnbq1x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2F2814000B
X-Rspam-User: 
X-HE-Tag: 1788377310-789686
X-HE-Meta: U2FsdGVkX1/YKDGGMh5T7aDiHww46u4CZVKxKkrosuNtp9JDoKuUPyWBYP0pzfR0/qT46eMcv5Bd//spZgSoU47RzKMlUqn90bXwmtPT7xRtLEb0KuH9vhT+gPLoAbva2/V1zBm3NkqCMMuFVY5muiBc/QQqc5cclHB3BWWe8NB1lBh+OOOTImVyu5E/BWElBqhKRC4+xPa+qAAgzgFDpxJT5YtJlaZ8g5WUdrczCEtLBKqfwSTFTve7pcci5c/B2o2X38higrUaEnKPGkWBfk3WgA2ju1j475jUzgJG4Lwk026HjyVavpGfmByVUig6YsDlI/UurytgXk4ue8YUPtHEzZrrAYM13IF9evQJQwIPs/ltkTaQZEX0zfyvSWaWcjpXNMoAawODJp/+URDVuahxQq5KWNsA5TPpEYCghFTPD93qeYZzrTdn3Z1+soCTqPVXH1CpMM6UjKVmZnrPVkvfyoNpFWGW23ETJybEc/W3Nh3i1GORv0FMO/PIJmLXEIGFnvqEMMCu7rZ5k2UUB59gU/EcSmqqegrfl3XHTIUuW4CMTBY3rlRj1cgOlZADzmJA8AkDtcE1oaashrxOnd/gu7JOCQ130LAiv+6NXyu3PMP998meI4ur1W2vAIsZx/3eli0mWR2uL4QTZoStFAjrhpQPKO/zEISUuFCrOgG6Xx1xOBQ6a5QnPlalACBlJSUyNKagrssN6NJP5fo4YqsK/XeHLHQQgTe6OiSiqkevxPqhD8Jp5N4SvHBJjFbR44RPnOMqzrGVdO3kHUtiznfV0yU4fmb8SDfjKrJSiDOYnqWOjpskDBgdAjIcXnG3xQYjkjJLCm+iAE5nTAr0nH0C0ajaG/4GergCfQj2bc2ub5GaAljfEKe8xYGgaERzEJi7ptUqWr6gJ9cGZwvHTyp2eDyzBqOz4VEQkyGtED3ZrXs3bG4+pG7sVgp//GqeyxWHoQNL0ET6atflGq9
 oDjXwSAC
 cFOVmcnZdlYl4kJnCXoCX+D61+/IFe53ea9ooiT0+eAiSsi9fHIM6ob49BBSf1UpN/4OITaGegFFKjMQwI5qeGEzGQKpxz7rxo0j1WosDBRl7pI2qVkGugbdhJudx1gtDKS+RC584HcIequ6hi5rKhLza3AN5wY6MbpicpDBPAZ/yLXnPxKhrAxGFEoH3gBQPnNJT7TL3ZT2Lt2e8Vvt/UkdLYIyoGo1ihTkPiNZncRmctNiJGC7E3Z9h584MdD/NEItXSWsmlHKcJuAG3o9AiKSKC7ZS4a5qNM2dU4Ew91jmAHxmDJGQxH12OMIvdhqd1jkCBVo+VoT0CIVlT9/fdcR33zrdoec9BOijjyTJsu+yc4PWWzVPYrQ5Cd9vl2y7lbwR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_page_state(), memcg_events(), and the lruvec_page_state() family
only read counters. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 23 ++++++++++++-----------
 mm/memcontrol.c            | 12 ++++++------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bd82628d0d72..10a197886f31 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -932,15 +932,16 @@ static inline void mod_memcg_page_state(const struct page *page,
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
@@ -1372,12 +1373,12 @@ static inline void mod_memcg_page_state(const struct page *page,
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
@@ -1392,19 +1393,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
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
index 35f924c9f2a3..3d3eadddc130 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -489,7 +489,7 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
 	long x;
@@ -530,7 +530,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * monotonically-incremented event counters are stored in
  * enum node_stat_item.
  */
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
@@ -547,7 +547,7 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
@@ -799,7 +799,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -1091,7 +1091,7 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	put_cpu();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1709,7 +1709,7 @@ static int memcg_page_state_output_unit(int item)
 	}
 }
 
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state(memcg, item) *
 		memcg_page_state_output_unit(item);

-- 
2.39.5


