Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA41CC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA866B0096; Sat, 29 Aug 2026 15:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A8D6B009B; Sat, 29 Aug 2026 15:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B466B0099; Sat, 29 Aug 2026 15:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156706B0096
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8E5D1A0181
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:29 +0000 (UTC)
X-FDA: 85155245658.19.4FDB9F6
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 06E4B40006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=uB3xh2hY;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3F3IHh5C;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tU6kdSXF3QmqklrLl9ZtFiNMxMnkDC8HoR+tVfS5rbk=;
	b=tj4XEYG5bFkVw1b2ADQxHqY7ICeAbjRmwOBU12w5J40luMceKVK+g3/8ZKFz6Q3cjBrY/C
	PwlsDB4ftl9R3SPYUHyjIVipc0k+/tema3eqF6hDe+RmgWYg7AGcg6PaBolvMYAoaZjmLq
	ktWiJsBEuluC7PeKs4YA8LVDmPLpY+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030567;
	b=hv2arVKyi7+x9TpbMNbmI86B6Fw0TCMbJ3L/3Md/tiCfqTo3MbsVgrGNTXFkgXyS9exFNw
	pdl//zC23TGUofyEar9zF9XoMomHSzLN/Iu8uEk2tDHmEx9FpTCk8715Atuco0ofdAoSLg
	DL+SKUue3XrtNej3VMRhRtBarpsfheU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=uB3xh2hY;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=3F3IHh5C;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIYvAQ1792308
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=tU6k
	dSXF3QmqklrLl9ZtFiNMxMnkDC8HoR+tVfS5rbk=; b=uB3xh2hYIMCJRblC/zPV
	0H+SqjqEnE5Y0CZXxMeBBBrGThAUy7m6XaO1dlLVeAVABRspY3K6xY48l6JbR50i
	d6k6rF/HlornDEWpsTDl0Fii8JDPFT6HEm3s7nfBEheEO1bZ5GzO13rcZW9FwJX0
	lS9rq7SrPGWIzWERzmEJzpZI4/ZAJG2utHhUEyHWcIrlX0G6gm/xQVN9PIXgKa2j
	ZXrtO0CITxDjY/bnvDo5wMNz1gx2KmTBUMCHpOBSi4vuDSYdk1CrW+BQNcX7GDlb
	UB8PmtRaeu1tMREYKZxQdIItf41ACW2korCyCZzm+8QBglfnYIO2z84eCYX1cD/i
	qw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbsppb0q8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:25 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so44797371cf.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030565; x=1788635365; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tU6kdSXF3QmqklrLl9ZtFiNMxMnkDC8HoR+tVfS5rbk=;
        b=3F3IHh5C2qDnAlv25slL4CPJcpQgODm84w11mRf+0aFVHDvQFFa62JAkmf5g/UWCL1
         P9+icOdbD5FODjV92S7cIaEVhMyule1cmFsCDs5vitRg+yUZ52ZoJBxwNmJDV6v2VDkv
         WbXt1FTV2+eEz9EJt4XsKjULMuXSuNpA+eDZSj7Y/G2i3YxrSmtXLiqu/tKBFlJJI+yE
         F7JKhVS1BUC4moI2g7wq4iqiL77GLdW85CG3iHVSlI208FHltqLuCwmMa8b9BOrcyYgv
         N0mOCjubHbeGsfAUuX0vu5k6hoamc4Wq+C2P086sh4zjgfKScSkwVfko9sG9J3lIKNzh
         o2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030565; x=1788635365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tU6kdSXF3QmqklrLl9ZtFiNMxMnkDC8HoR+tVfS5rbk=;
        b=J3Ehz0p3SkrXt74eANo2AIfd3HjvOe5+W2nm5dSxg1gKMglduAwOMCfjbhxzJQz3tI
         TOpYBEKGdL/kbglGQUxDiiIOTsUZYVGg3J0rhmlvloaF8y11iS3rtZnLS2P610YqFCkE
         5XHnTMl5zbb/JUWjCgUakVjbw+s41R1FJuWah/rLMudqDZfTOW05ywM9Xnb+kAWYLqll
         aQIyoJmR1qdgw9J8hvaWHLVf5e6xc50CQoyEUCMVV3+LTrX9Udtiqp8QlWT/gd0STNBN
         0g0/U2s5kIGeGbZyDwwrcALkwYP3uImdOlHvA9zTqhdvqK0vO39yQ1ntpd2PGgKhkgou
         vWHw==
X-Gm-Message-State: AFuF++kdJYNdp3NiZ7L+/AHn5+CLmQgsnPu4qWW8IgycTzqvIMlhhKa8
	/y8lUiRfsiWDMPuRUBSdYyKA1SvAyz9IF0Y2XtQyH8aWeDpwWLDK3+i/BPAy9rDxIALYm4JNJT7
	+XzpDtQW6DvaS84XGRs/+zlt0HZ9LNtMoJtKxyge9nVlpzkKm
X-Gm-Gg: AR+sD11G9wqDHzHAfT9hr/21gRlk44FI2mV78irCX52u5ACNgY9JU7Ji1JWPxggcKAP
	+7bTJI6u67BQIJXaTp8iZhvoUre0KMEZQr7N+3IKRAVh3aqCA8gDMNGx3oKobvUkvHPullrWatx
	+PHL0S84o4dWiRgZ7Zf2If1MxzpklcdqnxjaB5BCvNHt2rvPo/Jv9lvhyRmdNj/GkEw/cj3PcSe
	DmiqNbZYivEwWJwng1g54snX6tSbC454PeAwm5276G4UoXdjs3wnGLI6U5tPM2eSCu7+oKCwTwD
	TxYge0mThQtES0NQJLieazqnjlC/OlfEjpviEz08TXmeXWMNcaSkuNvX7h+To7tG+vQcIWH/ho7
	kiDc4IfP3A4lncOWGJddF7lWMXAL4/Z2FnR96WxdX5Q==
X-Received: by 2002:ac8:5f11:0:b0:52e:1e5:45d6 with SMTP id d75a77b69052e-52fa1a980c6mr256846691cf.6.1788030564840;
        Sat, 29 Aug 2026 12:09:24 -0700 (PDT)
X-Received: by 2002:ac8:5f11:0:b0:52e:1e5:45d6 with SMTP id d75a77b69052e-52fa1a980c6mr256846091cf.6.1788030564433;
        Sat, 29 Aug 2026 12:09:24 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:01 -0400
Subject: [PATCH v2 2/6] mm: remove PageReclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-2-649728091117@columbia.edu>
References: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
In-Reply-To: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=1135;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=BCcl2zDAdZHFcBdl79793ehAAmV8GYAzBaIVfNMP4qU=;
 b=14EcgAuY3De4UNPWTxyA1/SmrS+ExW1ZYGxseS5Q3cBlLwJHB+Zz1/u9LTefMgLRnhzLxyAEv
 HqHDtZXa3IDALuQ9bcTHL4EdKMg0Uwd10Zx16kVEDvPUdQpmM6VBMsd
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: AC9nW9qGlqQhgXgwz9PDfDjMiMsbZX5Y
X-Authority-Analysis: v=2.4 cv=B6qJFutM c=1 sm=1 tr=0 ts=6a932e65 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=dpU52ea7H0PVM4Hx00EA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX4A6/YamReRRi
 gsNIerQijK8Ow28gT+UxqPH45ulxdMAIcKtL2MXCzXKmXqveZyYZD5JtIVPySHvMoRgJFTjzORz
 sPjob5kFcIiX//YNQD9Rrg0Izd3qKcorvYvDB9THzOXScIOfyaQNjwBrg0SVHt9O6/7NZwWYnvh
 ygQ6WPh16r3s8RD019Z5tap5CMIUtaZEcIAKMeZQdms7BA4j9juwFAvARMmKhts9bOW5ohCLiOF
 oSacMv4agotw2lZ+X1+LJH/2FZHcLqRPRYhnwdgl4USfpSr9+XRXNbyiW7+qx9h6x5UxjI7zbmy
 otg2ur+3d0ymbsPNeX1AmIVBUw/JEc+DQKvJpzke0qQsFQayt645iMD/W1hjyG5pxKnggBN7uzc
 5o7WuGC7Yc/zkuAm3w75WhTgFnCgyCT9LgtntCt2VQgthxUQtRBDM1QtdosxUbZDcgjt/gE3a18
 H4sVRpDDT/KlsUWMg4A==
X-Proofpoint-GUID: AC9nW9qGlqQhgXgwz9PDfDjMiMsbZX5Y
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX3yQ7ksj4nBep
 q4FYYx0gK/ZgHnDSCCY56uriX3UEB83IPhurVyJDxyHIFeDRhwDR99O09uFXNjf1ZLabQRuUHNO
 LnkEWCOMweJMh7sGCdyUjl8Q0REE4py0JTDop4xX5CGgM/mfQjgG
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=10 clxscore=1015
 phishscore=0 bulkscore=10 priorityscore=1501 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290165
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06E4B40006
X-Stat-Signature: quynq5jyc1um4baeike5fgm6rhp4hce9
X-HE-Tag: 1788030566-292498
X-HE-Meta: U2FsdGVkX1/L8m72MA8REZxQXHUQ05Iu4rKeQhrgudD0KRZPUcb/YWjaftkbUpgHArhhfOSxNv/1uoMT7R+7obCDg791QAm6qtDQAGJJvHIMO2mZ0+1ujdZJTgRQuO5wJRDPeJx06OBqBK/2AyjSV+LhRVKVQEtJUSgI6naAWerpGbQ7G2XohsuEI+TWOsqEnzoI2WJCQzqtK1gy1bpEU/3j6WxMEt26z/nFPDKYUttVyFlh2siWaF9n3AkA1z7K051ZSjpdcnef6IsWSB0f59F5jUVYx5E+gnFLBiTQGw+lWeW2mTgXEIE2aSpaGq2p57dOmZHskh0lACkvfRL1Fw9kuVfZSakF+vDc+zX3IiY2KrpQcc0wdR5erVACIebBLEXTdxB3jr7d+V3EWmehej1AVW1Xi/dRkKVmnqq+PwIa+rmiqvD68m/glx2a12idDHTjvGbalFdl+qGU6SYiSTwedHioG3W/+okI9Ti9KLWrhtn37eYtip6t8HbQtJWBDtbU9kzZY8ZzxGnG10uFoigeJFT+9mNvhYrD4hXaNdysDX60xgWBx4Tr5CyIbryPSJzWnJrzLs5D7JaJ551YRhGGowVycQZHf9Cotxyj6cjLmPsihsr8bvSw50reSNwVIuPB4ly4gjFPPnQaAdg48qadxcBiS92IjCT2sDrvU3YHN15d/2ElP8wZfjsaUgslTABMTdm8y+RgoGcOZQ0LcdF3Jj7zja8ZaD9Mff+x1+ioXxojofMG/iM+X+wflqdGzINoVgGIX1UPRgsAQ0HoFfSKosANJjkSrr2IllBCNAcx0n69cnSBCj3FKeaQAAxXbliK9vDXIwos09PB6PKebS5t0SkuC1L1v+L4QHz8ttvgD2gaDAQPG4jArxesN66EwGVQz2RuEgijq9d+wJB4Nu3Ceh7gf6zxSLO40LAUh4Dz47Upd8mksenBFfX8WFpt+apvPeXmDpZRWvrkCJJ
 srF9um3/
 qP1W4SyPbFdjbkQZDlg+7bwvDDcovtqn90x7aUCmYsTB3K8NFmFZrxBa334hte+9eD48x94iidW2iHqJ5/L8D5IVFhSzJr+dBpgykYAkJJVB8jwJjEYevXdAw8gAeK9Y12lG0nqWt0WXBRrDUFjc8Fgf/0AIVGkWlqpyeV6u8EHJJfOIbiMnQeJu14GC12+tl3Xyusk7LRzmKCGxh9FwXnXfK9SQIhVmpfe57pitvGBK1+AGjxB3sJHDOSqit+/SCIzpSTy24ItoC0i0M9nkVtJa6NXC/I3OquCTqIKWYQSau965L6I5MpAPCWxuN2g3VPzahnzq/ntSiFybW2mGTsoe/Jr9a2fYlaJ5VUYChMVr/rv2fXzxZav8V1g8aXnjpF8LFromaw254ZbZz5SKOc+ct+YtY9R5fmt2Ym+q6jttJhdTF6Fy3zKrQOYp0onKk8OIf6FHCub6pn0mQrInKvAMaJOCLQmXTuvnDG1QG9mogTJ88naJZ5uvL8wdxig7ynonfNItkPn79C+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This flag is now only used on folios, so we can remove all the page
accessors. folio_test_clear_reclaim() is not used, so don't add
FOLIO_TEST_CLEAR_FLAG() for it.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page-flags.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..ae2ebaed6d4d 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -593,8 +593,7 @@ TESTPAGEFLAG(Writeback, writeback, PF_NO_TAIL)
 FOLIO_FLAG(mappedtodisk, FOLIO_HEAD_PAGE)
 
 /* PG_readahead is only used for reads; PG_reclaim is only for writes */
-PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
-	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
+FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(readahead, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(readahead, FOLIO_HEAD_PAGE)
 

-- 
2.39.5


