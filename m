Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D97C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A606B00AB; Wed,  2 Sep 2026 15:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32656B00B0; Wed,  2 Sep 2026 15:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B211F6B00B2; Wed,  2 Sep 2026 15:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82D726B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14623160359
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:34 +0000 (UTC)
X-FDA: 85169808948.12.F2968A9
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99002C000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="K//DCJp7";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=iS1MXM77;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377311;
	b=G/T2DEGYpp+cmOi30FHpxrAYvSDEtnvu0JZbWuTfR0rNVycnMyw7qk+/HERYOvOn6dUjj0
	zGqOwpsrYti89K6LI2iOjXwMqvQa4isW1jugBmiM+Dg6VsLwbJ7KrbD4RMDMG7IEq/cXhk
	jXhU44Z53Kwp2VEMMx2X9sVKSl8BGQo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="K//DCJp7";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=iS1MXM77;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRD0l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=;
	b=1j7S62ediszMIM2HegYNDbFSeyOtUzuvDndqFpJ0iij1hxN+6ix7+qT2GgRZewYX73xz2W
	++k3YqduC6zRqjkRdDIi2PhQgbDMJyJzePai2bap4icGLxdfJ34SH+LSVp1qJcbL2yGfTH
	EvWhOji7PJGphfItVSrQqMcgLRiaRqg=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682JCftS1004788
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=RRD0
	l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=; b=K//DCJp7WgpW3EhluvHb
	mxXUG9Fb3PRtnkEWPz60NFmBC0MAx91TgdqCGDany6pjl/eemgTV9tqsZCdZ09b8
	Pnfo2Z7acPGF+Kf2yjLzi5rlDdcRED25bblFwXz4C5GTQCpVDDu4YmsxUGebXn3x
	yT3z+zt+7t/lDyD5M5Yz/Y9OdXJc+07bkCWLG2OaYNInncTeXLPlIz+62PQASuvV
	hP8DulwrXxGCDEak4wZKQ7QOH8IaVzDSYslbmyB7qCJ3JN5/w3PweLz5mlLgFiCR
	tREMaIy0dW12A5PGs+cht8YW9hS9xBFMhD+wChNjsfk0kiF5+zuwX2a8A4jiivu8
	GA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesrr03vc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:30 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1d137a68so40056821cf.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377310; x=1788982110; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRD0l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=;
        b=iS1MXM77z+0ICkRMe2+2QQ3ZHH9lKgrwQPnfl0kSSOU+KnhYm7a7/093QiUJrpZhLR
         k6rwo9QUn+nzwYPZ+c0AH4KkIuOhJtvExT5fY0Njihu/efMRsbh/v1GNHV4S48cx1Azl
         kPjUIIXiOi4kU52DY1qpczMtjWnKoLtX3ol6VIKn4felN55ck7wCEtw3bO4PdpSBZd4r
         fSWku1uSnHqz4ptREI3VvXKzEl9zPboZ052LJydFjt3WVQgUMoFgGtTAPx5O50UflNaX
         w2QPGR5tK4+lMnyi4ExlfkOB4h+wq9udr9gxDGZuA3hcGjQjEGPRZSl8zgBuuVhZ9W0H
         ow0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377310; x=1788982110;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRD0l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=;
        b=T4u60QX7yvkwHI1r6awSkl17AOIVErtRoeJxI3+xxhqgBAG4+WGdTjvr6nOItY/dWX
         roK1kn7hT1foTDs1JVpU3MGnGtASWvRXWwd5Rjc8IifSAJgsKeyMIyH7fJT29fsbOkia
         I5VOY5QhOa4uJ8KtavGupWJVwm6jljJ468MCQPU5bZBtYRdTo78N8lA34V9xf4U+DFu2
         svl47W104wKz6BDCSe6PrMHxyNkdUYMTz1Le9/fA+Fs8kwctvv5PGEKBio8Q9e4Ecmly
         zPG6ds/GWYLz1gkn6r0IidFgxG7UWizDD3sU6bmt6Ho+rHZMZ8oPiYKqiWZkLPtKo/UN
         qQNg==
X-Forwarded-Encrypted: i=1; AKwUvBytWnVkwWdpeaCc2WAUBJC8DQgFGDmPl4Y1f5H9tLFtQYHEwVbgyDMCT3KtQvObg3EU03aGXj281g==@kvack.org
X-Gm-Message-State: AFuF++l7uhXeSIRMq4+to2orOdG0JIYwysoVeKuWckNwNEp9DXUr5Etx
	PvYogNU0r+hNQTkTOWvEyIF6V7tfwYYRcyatryjF8sWO4Sfv7f5chRxMxPsHbmOx/+VCEMDeqgf
	WAX/GVGaYHMQpGzUDN05KnMhd1FQxEzEMBIDP1jBtV6JBkvuY
X-Gm-Gg: AYBFou2Zyc0bIOFF/S+8JIAtGdEuvKy8SfuFX2peNhArdxV6hYRXQM449Ehfxb27SH8
	uTsYJDm1J2H31ibc3ai7QqNE1ncdd+8Ng03NbYNT/ZkEn/zAvTRcpI3i3j7f+Kpj5jAqM4iNIJ9
	Dj/MW+BW0JzveVjW1C0CgnVl8IeHBfN4Q+AVvWXob8Fvn554uJK2dUO8QT8HjUNVJ5/UFyi7bSX
	QWzFqgr5yzR4r18HOXlm59d4YZSJOPmhU6KOGUqgdTM88zzdl+KTNH98t++lVVULgsVFQC70iT7
	Snm456mHVS4xFKEeX/92jRxL53YbRtEqyJMcWhp1GmSywDigWaw7PZkvJa2mbKwleR2jm12j6T2
	XuOQdn2G3u8Xr0BxYSVIrscAG9zyikyFgKV+Fspz8Tdr1uCy0sc4usA==
X-Received: by 2002:a05:622a:a08:b0:52d:8679:ba91 with SMTP id d75a77b69052e-53036b915a4mr87035481cf.8.1788377310021;
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
X-Received: by 2002:a05:622a:a08:b0:52d:8679:ba91 with SMTP id d75a77b69052e-53036b915a4mr87034531cf.8.1788377309441;
        Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:55 -0400
Subject: [PATCH 09/11] mm: memcontrol: constify the swap accounting helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-9-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TSz32dlKErH2sHKGkXoZorQQsSCc5csvXiTKsSs8af8=;
 b=Ofsue+qcEl7OkCtIeQUm5s0CmrvlITgSUOJlrBEvUC9pTU1FWzglzUQkk9b6peUbGaadFs/oC
 dhZIsw1VOyXD4Lhobqfa8HoXX2OiRc6aLAq9gXxycrY3BVJApmYidjS
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX8OJVSoyeehIS
 DG6HBhwO6Ng3loNKKDoWX7neJYKj2DF3pxhxoNTWSh+cn4+UwXKaPf2UYT0wUjVVKdxF8IPLQut
 K8gGjfqOTiwAkv3vfMLaCAniFupgREf7WkpLJvdAQOu9gWA4cUGO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX550qe3cUAy3c
 bA+km38HPI9d6qro3cRg1gOPr6HidcWLQt/qRMN3xsXZNmdidGly0kN5RjbLu4YNpPj2wgY40WL
 IddWmnmUJ63BG/sWF7IMcds6QaV+wyLDGjvzy1dfGxPvbsKyJNEH6ApfP74ZdxKenhK6wGz8nst
 DQEV9hPyAYJsi6O7T5Q5hQv0U54cJfYFugsbIHi05Vq3iSPgC3YrjkqAH1wGgqgk6jXfRbo6ttJ
 kihZFX9C60XK+MJM6EY8lUnBrq7ADqzB7lFYtobXISN60pdoME1HJSNz5lo1CtM6O0E4UJxSocv
 qYavVh9KNngHeBMEVusR5Jpl39/CIhrXlnGLxaAAe8Dac5l8wCLAhy+J2d1QL2evzrrDVJ/cFWu
 70EyG8kRrX2nY5f7HeVQynjE490DQb8zoXqFmSSNvmoHJM/uB4FxJqJja0dG9yu4Mm9rVKR3Oiv
 CzY9jQ+Fe8VRicOUCTA==
X-Proofpoint-GUID: nVenRxuZoLZWGTf4VVbOZa-soq51Tvh8
X-Proofpoint-ORIG-GUID: nVenRxuZoLZWGTf4VVbOZa-soq51Tvh8
X-Authority-Analysis: v=2.4 cv=cPnQdFeN c=1 sm=1 tr=0 ts=6a9878de cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=10 priorityscore=1501 suspectscore=0
 spamscore=0 bulkscore=10 malwarescore=0 adultscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99002C000E
X-Stat-Signature: e5gf84y9q5gr7m6hthqk61h4jh5mg1a4
X-HE-Tag: 1788377311-938712
X-HE-Meta: U2FsdGVkX18/ot6+UJ2p7dHjP4EdCjClksypHyGCxdnY/8RnmIG6JyPYnSfl2wC9QuItS4OOpjcvmGyLeEgGi4zgyTSqTwwVM7jsq7sNqYamhg6fnPTik2vQVdK84yQ+ZB/4wQWauoGtZWwnH6lOrsBUZCP/DiGlGXlak/0dbIQic9HWQ09bl3GMr1HUnEUGwfBN/HwmdaWM8pN0HF6ccyEkzy53sJVsboIH/TMnqLNr+tzv7e/LwlfeECp9XbtGefYpTmoSnq7WhXCSncuEiftWR2Aem5yunqwbjx/V+MELzLo86Qx7ieSJmgwsi4eXOu9ekjl05hOyDrST+Esra+4guQl0Tc6jrgU1cD91yiA3d8ov8faE3+PepheO54V8hVXR1nY+eDXS7aMqRazDCzK1K8oVgdEVdQ4pFGq+Lqcl7W6sW7EUl8PpsZQVNSn9nIB80C5os/V1cq6HLSD8yyja2J6Ta395OgdWYRPw5UV9cBrroO5k3KoQ90tVWMM3abx0chWI9zIINHtXfRpOXAXTtdQXb02UAdoRWcHzm7WIICNiBcAI7U6Hhr34VwNsDbYfyCvSVku0+Qbpk51K+duV3b7cgfOhpMgCYHqNRlGAy2MmuCM25YHPBsa9Jk6gYJFNPMeKqWsCIOX1vQ5Z7N+JvI3dAWM4fbMJrrxXzYV8j1o2NSoM4NDbcIsnY6Y4PMF/P+VwyFQHDEfjF0SPAtpmZkf45e1WgToMorWcXcP3UGztqEOcmCZYV+ZE8b219n6q21O3et4RhrzZWC88oD18A9Hth7uXT4PJQWX52eavkPqYYLI0zQwy7mRK1OXu0WoZaiLkka04nki9bonWZYBUx/qA+5pVGbMsQzmdQzcAXd1hfOjH3Kv7oEbO52FMgwT4yuiNQ703r8aveUeYcdvEScT5/RcN13cwAzW14l7+AwgeoSS60qqHXwRiZZ7mUkiK8S5yPZq3elUx5Cn
 YYounjrO
 vSiHpDFqpmvgPtmSwyuPPIY3MuIlnkLe+XtWgVtZnQXeYi11a0sFqxWtqK5A4Ssr5YhAhcUkH0Nhj6yMsA63QcOin2iuCO252raZ7W7v90pDkEunzScll7LtFDPQnMXam42a29LEWx2F/uk7HLbn/NraedsTWRN/ulmt2in04AJF+loTNl5g+bpFI1iGw4Q5ZiMEvsnSk106n1erzZwvrSrrjvguIBCC510uR4Q0ez3jtqXk/3d5/BLiGTFK0BdrYGb6ZG5McfGzqiVQmZov6N2Law2O4mlOur5xz+gtewznqNjInJYOotAFb1Ka5BKsoaggeDkmtO5le+CDOuIvn0EkxMq1GzF2w0mmPmJs6NkDc2pf13rxu74yjmdsp/+QHVElt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
mem_cgroup_swap_full() only read swap counters and limits. Constify
them.

Remove externs from function declarations while at it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 12 ++++++------
 mm/memcontrol.c      |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a72ecf12c00d..a64b5d37bf36 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -510,9 +510,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
-long mem_cgroup_get_folio_swap_margin(struct folio *folio);
-extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
-extern bool mem_cgroup_swap_full(struct folio *folio);
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio);
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg);
+bool mem_cgroup_swap_full(const struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
@@ -524,17 +524,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
-static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+static inline long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
 }
 
-static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+static inline long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
 }
 
-static inline bool mem_cgroup_swap_full(struct folio *folio)
+static inline bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	return vm_swap_full();
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d3eadddc130..2b8705a88f6a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5839,7 +5839,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -5855,7 +5855,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -5872,7 +5872,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5


