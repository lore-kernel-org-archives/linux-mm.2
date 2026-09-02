Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83563C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491FF6B0095; Wed,  2 Sep 2026 15:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443AB6B0096; Wed,  2 Sep 2026 15:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE5E6B0099; Wed,  2 Sep 2026 15:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E071E6B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69CE612036E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:24 +0000 (UTC)
X-FDA: 85169808528.28.1B464D7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 944061C0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nje5+gnF;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZNFeWBir;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiZSlMXPNQnU6e8k3TycWv1GklzL+eafvVQe1OpPlbg=;
	b=fh7PiyQxa+hi9iKf+V/RG59zCmW8MCgss/z3Npf7T3yujTGog4RN/bcufRJcsirC3NpXpY
	CYPsPAdNYb47NILcXKytB3nMCJNPRDAgsJsycGQ3cePT5WpqIPWKLN/shfiYsZwqUQW9vD
	ETp9xVHQZo3mGemFe/pdp6jIhmckkXo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nje5+gnF;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=ZNFeWBir;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377301;
	b=ZEuIw2OF8hxEDFiHm2+uPI7kzMme6xyVxwZIOaYtb5S9h1NkSLshRDFOaFw05CaEvroqhC
	OF5jnoRha+JQBGSDAMt7Jlp7LvHxFeEy3BQtuI19tvX38g5cVu4FBV2DrImpV/cpG+A+kS
	BJkvUzrHtLVNtF3NbLLI1QaerBOL9xw=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682JGUuL1243309
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iiZS
	lMXPNQnU6e8k3TycWv1GklzL+eafvVQe1OpPlbg=; b=nje5+gnFYNFeomEIdAzb
	OO46aLw4FtxnoW5AtquBni6728Z46UKLbG++R7XEKw9yL3/v2xSCMapeh2vE7ywv
	t0g8vHp4gRSeQLZV2HziRdNDTgFPY9xqXLbz9xVJiW8c5rvn/WltJLuDPb7g5JXp
	VYoVQVJBzPh8j4WkxiyVKXd7tkRTZRcvRSzeTGB6OwgzxlOlGRqg/fbCDXNgyKqt
	KIcTMDAtXdwplUOSGU100HyXNGwwvgwUQS7Th+WJk+T/HWv/D+d2uZQIIBdk+B+v
	/T/BaeyHzM04Hofh4BsWk/9vXeNbuQQaia5r6CNcdBGBN5opC6F85QW3/B5wXLPm
	WQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gestjg2pq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:20 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cddf4f59eso27276276d6.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377299; x=1788982099; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iiZSlMXPNQnU6e8k3TycWv1GklzL+eafvVQe1OpPlbg=;
        b=ZNFeWBir/tNaJ/PyTZ4rl3h5AVnGGwA+HuX2hpx2jclXp98tryV9s8MrlscwYukT6R
         weCk+ZPwwa9gl/JMLx/ng9mEpiecGGe3tW+Kt5BF5pKM+hV57qo6G7HnmmkhOSamFguF
         pl1tjHyTr2EAc3PI+bkJ8+9Wosv0MaOek2LXvVgSqtjDc3iJ7w5DOeDteiM+0fuGdnOj
         S11iA/YWjrAYLGz+UyroEMhg9rp83VAmSB/ohlG74DHK0XPVB3KoLbbeMrixr3HWSd73
         GAy6dE4rXR5MjJb2GqU//o7M9YfVPXxJ7mvnweA7uwSlOJAKRp9qM/a1DnS9+cH8UmbQ
         TBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377299; x=1788982099;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iiZSlMXPNQnU6e8k3TycWv1GklzL+eafvVQe1OpPlbg=;
        b=qSzrJWXiOPcIkA5ZEkIVQzJTMG2QGNoD9MecliNQPG+tIDnuA1ofAWbYmCcCrK6Dvy
         k6O6MX03LOWVH/+VjVQwR5iURehMciOEBBQzQn+z6jLvmI1BDeiB4KR+asZioXVA2D12
         O741vbS3mJv/qCJsCUJH4FTBU6B84UL2pxZ7llz8pe3+seGCkBVrXjN+tR/KLGaaCjcx
         FbCgDJ1vH0u0ya/GxUzkUQ+fJCbKCVUPcDTzRVcV/vQzz1U/CpqXnpsauAToHqtMPBAd
         724iw2TE8s58A7fRXyGx77mU0c35ISrrAkIX3mBVlTH7UEzdsoG8EzKiu2Zn1WxxFdAM
         /2FA==
X-Forwarded-Encrypted: i=1; AKwUvBwpwZQeIa3VP3Rec/i7FQTm0OmSeowsQTWDuCUi1zcVAcKOC9BZYfVViih+bLEXfx7MkjDhf/2+Lg==@kvack.org
X-Gm-Message-State: AFuF++kKq3xTONuW94R9OEqdnF7/bqTCjc08kHKa3C3uCRZgVGhFF42Y
	V/Lm3A0yxgG7stJDTE1f22FJiRZVFOOxYuxtkmPZK7pM0pQLR/vf1TOWYwvAASbNcRu3nSLhIUn
	ODJD+GYGu76gbUhzHaSdUhMonIXkWDHmgnWxlNwfqLtyUjH74
X-Gm-Gg: AYBFou1GPQHobEYP0rNoiMRA4BHjHvS0nuDP7Z84h0tVYyx+JbuUFnLCpc5u3UmsDJ1
	Dr0vxK2yYPf/F2vWpoJcpcMT+8SeeOXRZfYye4uxxNv0M5hASI41PUyvMSmWya241JdQIUU5MeL
	UMb+/m//WAZUlLCilZD0RYJTkMMs1re59wEdUvNrfVEFzCIUjg4nZH4qrDxSnIdAi+ZZftE0Xsj
	xq2O2vemOt8ApJg4pX0m/+vOpFxsIQbtnDXEwdsnc+AP1vRCB3jSFfqEZR2RN5VVIG3LMCdNuJ+
	xdO+DBOp39wPlB1qcwrvOgWclJV9O4ir9QagxJRiA/sKEYzGu8fHsQZX66kotEjTF9OHR8Gio7h
	wszuuMS3nTZCJFgcto0AkCWaKUXXN1bWNQMGvCO/P4hjHr6vmI7p6Ig==
X-Received: by 2002:a05:6214:23c6:b0:90e:8a62:3344 with SMTP id 6a1803df08f44-90e9f26550cmr86849146d6.13.1788377299030;
        Wed, 02 Sep 2026 12:28:19 -0700 (PDT)
X-Received: by 2002:a05:6214:23c6:b0:90e:8a62:3344 with SMTP id 6a1803df08f44-90e9f26550cmr86848496d6.13.1788377298486;
        Wed, 02 Sep 2026 12:28:18 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:47 -0400
Subject: [PATCH 01/11] mm: memcontrol: take a const folio in folio_memcg()
 and friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-1-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=8676;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=0RRq+cNSMCUgXKQ4BRhzRqAGgsu/pKvi0Pw8sEiBxb0=;
 b=0xdzCUhJ/ycbjStokNdzxmTsEbanlqA5lDPa4ZHEDUzWMBvo8RjwzZ+nzlNqbgsggKr+KFjb1
 bnjVx9Cd1cZAVZBCC0+Ox9np8fi0siYMn/FZsunbm7gANDia8OngPWI
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXwqQGtA8sVWoJ
 cAJe1/Jt7EwgM2QW8JMKqOA6QP3xuK5rvNGoQIJGejeuGCM+jVrXcamqtldaUrXvvnAG4/O588w
 AS21hCZj6SQqktxlVNwO7SC+de64jY8FeFFfmpkcmtV92KhEexJz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX9BRUDbrf5acf
 MF4E6vNOPkx0IaTvspajNyZZvbbpvRV3E1MzT8sy/eShcAupJ3S9PWQcfszPkudHX8JHwHtKjQ9
 DTUEGi7hQ61Znf9qERfXNoXf7Vh1NLdjJYS2KVRhOK/kthYt2+CdSEhrYm2tmo8WhGPaMvyAGM4
 WJ3Fbi2gNpZAVUNEjHqoCgJL/nRgzLfpC5I2Rc705c2XnwBeejiNnpceKrGeGKWTi+ScEKJL2Ym
 lp8A7p3kM/DOiH1dgCHOWM9b+Zm+LLHjukncNcza4RFldDRb06osO1bGufCWr52twx5quEeRiyD
 zb4C9w8pEwKTtRUQMe49v6uWpC6Wm6DR+KYschv1si1KBRGMykWMP9nrzMmImmBO70PzS8HFsaz
 /j0OWaX9j2uBSiJJzJUdTs31DIwdbcY7ah1NuMOZldKU21hqbhPwb5IhucEcpBg6gUghMT8aads
 Az8at57hobpUSbDHcBg==
X-Proofpoint-ORIG-GUID: FJ-xC7etOb1Qp9eraLnvnb6WazWSL4q0
X-Proofpoint-GUID: FJ-xC7etOb1Qp9eraLnvnb6WazWSL4q0
X-Authority-Analysis: v=2.4 cv=C7jZDwP+ c=1 sm=1 tr=0 ts=6a9878d4 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=mS-MXv6ntEAvCgPac54A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=10
 adultscore=0 impostorscore=10 lowpriorityscore=10 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xksn116udwcxymjo1c7mw8bz18aus6xt
X-Rspamd-Queue-Id: 944061C0006
X-HE-Tag: 1788377301-594431
X-HE-Meta: U2FsdGVkX1+/po1vMgwEPuu5IuwbGrGdTfs1TYh6brSJ7CzkhOX6qobUgdUx2n36xClTti6YuODAphPnFfIxVhddbOiQXVrZABS6OTZR5nJw/edVavPecwCCCfKxpllI1mD+Sf9hmARjcmiph2JzTXpDE+z2t8XTcZ0y7JNoqfewjAs8KltZsAvN99Uj/sFr0GUpAWwKdIuHjHkcaK2UUdn85xPU/xFBqK+egWZMkN0+j1kEX5sxy1aR2VbgckZlauvLSUWiAivZzJF7nZgWgJ6PCth1JMhGUd7PlGJRYRIU0gneXn7m0Fu+nXLcRGGX8GeqEHsOhLGEMGkKb0gN+HJoZmy59KfWMTIZUxVE77tED/oCNI9xT4mjuS2zekxunEaX8UcArtel+WLXcxUuzQqPMoW8q3JgRoru3nOtq/gT1kj/iiVdE6pu3wJVsMNeIo/r5nEXMhORi2KewTE37+h9qzccQ8zZz/gxgLv9gg8a5RWUvnTKYj/VCHHfjTgY+78v/sXevoI6WZREguQv/hpS+zWhZxhLESob9ZCvXfghVWOWk7cMHh84OnbXpQzlUzgQPrG0eIA3otbQSu9ey3SCtPwnhv5HkVmUdGfdSI4ZF6WiSComFc2ireGDXFlLNIwm3rlJNJkiep/ZZhGnxKJpBEseAs5XfOC0dhep3oUN2gTXVmye+as7GDfisVazgMl71XOxL8zxdYFIehWVu3oq1yCTcWokq0T09Uyrk3sufg21hTpXIaOm9RQYmqkIOtrwBtWMTSsU3VeVafC/aiLiTASvWXWIJvzyQSdB6eLAkMsvqSt+YPoQwJED67KbLdjkQRvJDL87N12lpliUozVhurIJU1FO5DMHy2dy9Ww3oJD9XhML1gjLCkNwPzw6A3GukcKLeY/ME1TQVV7cWYRJdMOKirDPUO/a8ivQlVeff9eL2WaJm28wgD5vwCBVJcfiJLyz2kGKuRzQEOz
 7SXxbGnN
 GFyrIhev+OYSZWIk6W5ZnDPPilkom4AQYOYpF6OpiWSPMQrCw2NQ3WIm7+RwXL+g67tZrUkfg0RN297KNlIqcvWTtApa8CkOcbdICfFeZTKSiFFA0BOQbuTW36eftSwK9wV9iL0Un1QnHEHOGefeeZhY5xUKpJHL1IbN+9vCFOHNS/5fR4YDBw8Rx+9SJZRFBCt1WL6lf7o5QuybEO51YRvsbMfz+gwAU1shwAv24HZb4tBdf1FZmUqC/nvdbeyL8adMshy7+I64zYVyBARj8sKuZXne1yGOePCnL1NKGhPYwmnuBpBNRwjSbjokBZMhmd/1QUx/8TarbycsqfpXbVuQTQGaCqTyPh13UXjdbQwbG0aJqvR5ygqGNfdBLQngvrUDDtHBQNYjLcVpUfkK7dEvc++Q0YHp8Q9HbtLFOwTnhF/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio. Constify it, along with the page
wrappers built on top of it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 46 +++++++++++++++++++++++-----------------------
 mm/memcontrol.c            |  6 +++---
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 945d7dbf1bb2..91ca94667d44 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -377,7 +377,7 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
  * or NULL. This function assumes that the folio is known to have a
  * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
@@ -415,7 +415,7 @@ static inline struct obj_cgroup *folio_objcg(struct folio *folio)
  * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
  * memcg associated with a folio from being released.
  */
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
@@ -428,7 +428,7 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
  *
  * Returns true if folio is charged to a memory cgroup, otherwise returns false.
  */
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return folio->memcg_data != 0;
 }
@@ -448,7 +448,7 @@ static inline bool folio_memcg_charged(struct folio *folio)
  * A caller should hold an rcu read lock to protect memcg associated with a
  * page from being released.
  */
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	/*
 	 * Because folio->memcg_data might be changed asynchronously
@@ -465,11 +465,11 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	if (PageTail(page))
 		return NULL;
-	return folio_memcg_check((struct folio *)page);
+	return folio_memcg_check((const struct folio *)page);
 }
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
@@ -494,14 +494,14 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
  * that the folio has an associated memory cgroup. It's not safe to call
  * this function against some types of folios, e.g. slab folios.
  */
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
 	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return folio_memcg_kmem(page_folio(page));
 }
@@ -743,7 +743,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
@@ -871,8 +871,8 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
-ino_t page_cgroup_ino(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio);
+ino_t page_cgroup_ino(const struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
@@ -917,7 +917,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
@@ -951,7 +951,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 	struct mem_cgroup *memcg;
@@ -1045,22 +1045,22 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 
 #define root_mem_cgroup		(NULL)
 
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return false;
 }
 
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	return NULL;
 }
@@ -1070,12 +1070,12 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return NULL;
 }
 
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	return false;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return false;
 }
@@ -1208,7 +1208,7 @@ static inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1366,7 +1366,7 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 }
@@ -1431,7 +1431,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 }
@@ -1861,7 +1861,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 {
 }
 
-static inline ino_t page_cgroup_ino(struct page *page)
+static inline ino_t page_cgroup_ino(const struct page *page)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b9e0ebd42ae..b9bf655cdd2d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -331,7 +331,7 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -356,7 +356,7 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
  * after page_cgroup_ino() returns, so it only should be used by callers that
  * do not care (such as procfs interfaces).
  */
-ino_t page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(const struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
@@ -1220,7 +1220,7 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  *
  * See folio_memcg() for folio->objcg/memcg binding rules.
  */
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 

-- 
2.39.5


