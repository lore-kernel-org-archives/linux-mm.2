Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A523CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756A26B0096; Mon, 22 Jun 2026 10:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E6C6B0098; Mon, 22 Jun 2026 10:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6856B0099; Mon, 22 Jun 2026 10:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71EE6B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:15:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32FC71C4735
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:15:08 +0000 (UTC)
X-FDA: 84907745496.27.308AE96
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75967100004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:15:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Rh7s5zWv;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=M0vRHFR1;
	spf=pass (imf05.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782137705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=piffdiB759PLk/akI9k0fYEicyM6im7+yWgCdw1Qj5g=;
	b=oihXgYs26gn4VsMamAuywxlMJaDJKGtBYrP4JNCw1dz0CGUmid5KgBagG/kbcDLYvbodkc
	oEle+n09KwfK/g827iWfDrmbfDbIo6J0d0YkyaQ6T6E20pSY2vG8UlfiRwNSih13006xOc
	HvlHXtO8Fpugu1+30o41aKsPNstwloA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782137705;
	b=FCxdH/mvNBH/RjwzxCV/9N3BkbTQjK9Kyoo73JwgRbNsCXZawPspKeoptjoUsx6ohrXYx9
	EiIMBp7ca5YIQ+OKjksALNtBo5dikwUTzGvZZdUAgWh7u0TXunBKzUPvptRnpnCF8CpKFZ
	6woXOk7d5p/wc6hv+R69f4AAnOGMiXk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Rh7s5zWv;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=M0vRHFR1;
	spf=pass (imf05.hostedemail.com: domain of ketan.kishore@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=ketan.kishore@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDG8x92386992
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:15:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=piffdiB759PLk/akI9k0fY
	EicyM6im7+yWgCdw1Qj5g=; b=Rh7s5zWvgufeNB3bcG4uRUdrek+rbJfP4Oku2k
	p1xL/ot+CjmuaNijQvcxpY5baDYBLbwfomN0QvggpinaCcPWfPQ+vclc8qW3thrv
	DwBbFvFk+Zbhs2xc53qmnLZ0sLJiQfd2+fERbv/J77pbqU4wqFqf5cChyPCWVvI7
	ys8P+q8YLWlyaJQXe1HF6V3hMArJvNGE84Wx09+Djs9rqNhmzeiZY1c53rJztMnQ
	iPSVPphpF97fa/BLe+yuZM/nAP08hQSjHuPUPPmm3JuRftHchK4so1R8EQbcRrJE
	kBcfPgLPdIAXOWXCKCj2Ur571JydRPqBGEBMm3gVs0tvwpjw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey5sn06ud-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:15:04 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-37dc9b82e55so147024a91.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782137703; x=1782742503; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=piffdiB759PLk/akI9k0fYEicyM6im7+yWgCdw1Qj5g=;
        b=M0vRHFR1ogk+HyP/iLNIo4rNSakXAWvECzAB0hzn9zQkK43X/0lPTp12k+Gi1QN71g
         dRvjtMnuuMOOqNlrCKArrKG3SArwk4nEk+HI7EEaDIAsxN3cJZglC2e+BQPoFqnnBvY5
         I+3UAfdAqKRq+QX5AWpZZpp9Pe2dPvnCaV/Vamchfrh63smMXwGzqf5RETCkAv5QRKM5
         kVvyXDF3wfhSgJ12Bdm+SqVd0M5tHehhBL8//px8aSXFHdEir3NRAiAz3a1/Os75HM7O
         eeUWKQEdGvcPMxs4ZAmTp5kxpJ+/tqmXLqysHRQEhnaJUIGZ9n3Wf9Wpsdmtnxxy5rpc
         jIPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782137703; x=1782742503;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=piffdiB759PLk/akI9k0fYEicyM6im7+yWgCdw1Qj5g=;
        b=XN6AmhFVIlwrWzrrH9I35mcWMR++8iv6luL5yjma7h47mgUfN35ziiAHQEFZtYG/XB
         I9oqMPCgAjX8/L4vRxdOzK8w8woxwvHOyLWuHgL0xtDiPlQYyKkgOHObXoP9M10lJ2h0
         h8GeGwHlO4RS5i5zOk1K/QEY+JkznjWSDo0PF0UJHEnPgiyBbBssZFXO2gm9ApfXS9TF
         gwFiprCc4DRL/83R7F16gS6e/cF2FVnCTjD1sv05tpX+3lhFztOExk4wW0HR+1YXhYex
         b+35QF8iZzo+fim5q7Ff3BkdLtxdBd6JSr8wtu8e1+DT6dOi7A9vEJ5+2I+TnluapMr+
         FljQ==
X-Forwarded-Encrypted: i=1; AHgh+RpcWtgybpyRq5y0wQl0MnaHOVvqYGBj+OlJvmQ90IVOWv3T072rv3VwBrMKJMNhoHxvj41uYpZi5A==@kvack.org
X-Gm-Message-State: AOJu0YznV4ki4BlNMOp7Ps886ESRykohGZnZxK6ilaYZ2jgL4hrA56Sz
	yiFKKd5MS1/IAYveglgupf7BoAU8VLmYE/epeQ6u236VIbYxuyu4HczJq/quAAm3n5GmqOexAF3
	TeM9VkAK1Yuy9wtpoogjbVQZSW8CiqfWlFt9kp7ntYZic29UkaJ1zIA==
X-Gm-Gg: AfdE7ckqFHoT0+1ADduM3LcAGNS4HHwO3J+VPnWsbMvwCzVPkP41NIMoHfIkaAMTtls
	PTQItRkvsAs7tCtmEzwj6PSrWrxot+ZFfs5KMu59mRoHroYwId+Z8JvJz6LIGjQvyqPqfTUX6Bz
	MV/HXTu4X8gyFkkJmPa4Nxousxq2aoN021TtuXpD6dPBv0t5W1uU4asXTn1i+rybcy24nn/5Wdh
	4IFpT/2OR6fGQFnrOmWsNatx8WEwkLM606sEyCUb8/mbCGTE3E1TYqJGxYA71jpzL92RF6LcUdj
	c2wqhga0wDMw4Vo0e7R0TkcLd4+lXUBa85avCcO0VyOkOr/s6ZG1VKw5PEAKZVemKCZk85vcTEI
	VjrnKPk1oCAPbxBBfnzhiRpSLzT9uoS/47bxssRgfawI8
X-Received: by 2002:a17:90b:4a05:b0:369:a359:b181 with SMTP id 98e67ed59e1d1-37d4e86bf8amr11351181a91.23.1782137703297;
        Mon, 22 Jun 2026 07:15:03 -0700 (PDT)
X-Received: by 2002:a17:90b:4a05:b0:369:a359:b181 with SMTP id 98e67ed59e1d1-37d4e86bf8amr11351115a91.23.1782137702690;
        Mon, 22 Jun 2026 07:15:02 -0700 (PDT)
Received: from hu-ketakish-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d1558b599sm10382253a91.7.2026.06.22.07.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 07:15:02 -0700 (PDT)
From: Ketan <ketan.kishore@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 19:44:54 +0530
Subject: [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to
 prevent invalid PFN access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAF1DOWoC/0WNQQqDMBBFryKzbsTEJkpXvUeREuOoKdXYjIpFv
 HujpXQz8OD9NysQeosEl2gFj7Ml6/oA4hSBaXXfILNVYBCJUIniig26wTsuI0s51lLKs1S1gaA
 PHmu7HKlb8WWaygeacd/vRmtpdP59/Jr57v2y2T87c8ZZmukqT0TJdZpfHVH8mvTTuK6Lw4Fi2
 7YPXaj/8rkAAAA=
X-Change-ID: 20260616-page_ext-31ef555456fc
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Luiz Capitulino <luizcap@redhat.com>,
        David Hildenbrand <david@kernel.org>
Cc: kernel@oss.qualcomm.com, stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Ketan Kishore <ketan.kishore@oss.qualcomm.com>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782137697; l=5361;
 i=ketan.kishore@oss.qualcomm.com; s=20260617; h=from:subject:message-id;
 bh=NNyPibn7P54f63BQb5tNU5XeaeS5Q9Dj4omuy0PXFws=;
 b=x3ahtd2rZYMUyig22NRD3pdqrNVhc/v5mZUHL3Dqupr++LwdYEppRZ4I9G4BQiccDsqOLvMEa
 UuRC8mI5d6mDeEqG3F1Y87zdS+UczTa95RQVa/JXI0h+AWiUbPPiT1T
X-Developer-Key: i=ketan.kishore@oss.qualcomm.com; a=ed25519;
 pk=4sb5Ima5x03wc0KSnl57v8kR/7FxMt01+xlZJ53rSJU=
X-Proofpoint-GUID: 0SdVvlkg2zov1RFOXztKhSRQTOs0ic0N
X-Proofpoint-ORIG-GUID: 0SdVvlkg2zov1RFOXztKhSRQTOs0ic0N
X-Authority-Analysis: v=2.4 cv=PuKjqQM3 c=1 sm=1 tr=0 ts=6a394368 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=JfrnYn6hAAAA:8 a=Z4Rwk6OoAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8
 a=37rDS-QxAAAA:8 a=v2oVMEoAPVEBj90iUNMA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=FO4_E8m0qiDe52t0p3_H:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE0MSBTYWx0ZWRfX7kMQyEiQvX61
 3rt6Cd3Ag4Ec9kQqWKs/WEoIfhB9WG9DvWy0Ca4RI/nNWpFyfgCmlzM4amVfzruHwazGDDngrer
 hxhTaBYlDDAjE6eontrKaVmMXrs93xU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE0MSBTYWx0ZWRfX2EuyrbASnmpg
 s8dozZ/3+bbkJ0UWLG3yE02SV+sgA8n1uvtVVPJeg2JxKqqx0KaDkkyOJCjd/ekZbW1B3GiFZ9I
 pvpCz/0tKewZxLvn1dQlizzjJEiZEajiZJgGYh0UyD3osDJjkXo9gHIejsGIIjRrZ/QGM3qpVFf
 E+Fzau6v9jK8gmZZiaqqYPy7Dsg7BhvTg63WTzR2kNtu3n9y/N/gpgiz1uBWDpGe/2R/u7SSmNX
 Et41VFB6+31I/y20EheKPA8tgvJ2E56IgjOzfG97vpF2gt0yQNmHln1qAwP0U7Z0kdg3NkwC6DP
 dCyz2MjW10w7FpaOgFL7KwOnWRkj2SzhKQO5MHrg7TxvXkLccNCqldwkXZYI4IPijhdhkNXcXGB
 WePrdpi05JOneIgNQWhw8tytR8uGlp1GZeFzkexSDV/lBIl6REAm7xJRSg9WxGhaMUeTbA8hUh+
 qyWT4EtnuS1SH3UuCTw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 adultscore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220141
X-Stat-Signature: 37n188jesgch6bk5pa9bnztcfsu84qjg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 75967100004
X-HE-Tag: 1782137705-57176
X-HE-Meta: U2FsdGVkX18Yue95S4rN3GOzDVt8PKQlB18vCzROtBi2giWF6xoYaOK722HCgCa0OD3HOVSImr1hbbWjb0T8FLeXbwh0o/4MQPeLVeTr1WwqQytUqVcmVh35PzvDEutFiRGiFKSNVTIVXJP+v8qP7LHqxyN26Dczozkd6aIbSb78Eh/2mjypM2MR/ZRebQMFai0O5SKf5Y9j5XtZIh4HWZ/GmiYHHZIlauZoae+qb0cKXBLY3+q4uWrWVXbB2uiJPYPVBMcz35WEIkaJC1EPLAxxqpyh9WP4nT52VHk91rWZyzSsTKocAewTsNWYH/1uGwYxZZ6Ag5vr1SLeA2MeyJWwJZpEDYNctECp0g2xsHf/YnyKeWZpv1I5eZxVYuNjvvFQ5ratSED2inaTS9drQHlV4Pk2AG7d8zzyL2mOOt8kbLee1YrQ5tHDUEOrmCkfRfc20QV9C6Eooiac4Lts8P2eLgEgJP0KDDtRqU6NOide/d3dhbtFGE76kQJIFpyMgdZq84G1YHW0a41wL9/1K4RZ00rLW8m8QEtJ61uDm6hllIvb1P60CWyKwvmUVll8Lh+gBIVxmfuoiDBt8UfauTQMBp/NYBhnTHhOETXjYz3ebQ+5TEH71We9VBo2XewbrXYtF5kCAoo2MqrB7idYSGy9PTFmnSrsnNQ1E/giTXFSJa+alWzV1rp6Umk3+UBsDK+bWgZKZHuDixLPQrxHbQwCmXawvc010Us7sNldYE7ajV0Q5dgAIhcQQ+cwXTfcBte7tM/iZVTbIbHf4h8rYwz4sgcOE3B1EBgZ1osiXImoVxG0E2y9HwRvd0MHenu/VdVZb78iQ/mycr6tj4zF3yavG10QZo/BWHFVGhFodj1fQ7xvpkA6K2mktHKtRtqFUO1A4OAk2Pt9V8qKtSknAzCLkOW7ofaowkQu+3AfQu91+EivKQI6fzPQkzFMUrXFQcvjWXKA8K4eHOs2VWM
 NGP0V0Bm
 EgrWZ/qfdVDcj3nAESchkk3WFAWQCr5sIobdzg8yZfPSGdnXb5ae8wJsujtUQ7P29rMy+YH0s55+LcAYBlxSWLjBpUW9magmNz3/8vTukEToSbuwTvT9uW70nR7R8pQ3RJwNSNQmTGrnL2PLtONArkbCcvUroxdGrT4TQwNjcX1P0bFdWjkvYf+5PrYi1P9s56eaOEjdKKCzm2CzrTOMhhmaPY/KCFlAgS5EsmxMTyX5pxVjznP+huih2bolUR7G3IRjDx0HF7xvHuJvshfFkjJPA/xHfFz2Uu4ufQqfNrCJuEVDaAcx+earL/d4v+wq28iL8y3IlaTyUuXdEPCtju15C49AfrKybioXmtwOcedq5zR9EK6L6KJmuXlHSzhUP5mg4CJyeFfxnDELWdwKDBzPZO6Q8dR53zcM+wKR/z7ku79JCaD8cVMPljPidrkHhRpescRZIz6w2bZSm1V/l3kz2sLePTS7ZO4wnyuyzA1DaJ9VzDJHfJg56Kb10UBhbzKnf06o/TD9oKK/u7xoAsW5DM1sIRAiHW/3N9PKtakTteUAUrsGMQmP1TLUaXj0qEsgvExESLkVEm7cdJpyt73F7MD/oMd9efcK+pmjo2PGsP1SJgtfBZFzRXIurU1+BtqwNkOc3kKFO9if96AQglU7q3j/uD6x94v77eHJrjCnYd+XYQg7FE+hCKDS/n4OlXfHD0fR6VNfVLj6uMYPTb8VtTTeDrs33m9bNzYxuRiEmp03IPAF3GFoTTlwF1Y6p/Wua83ztAnaRUzTByo/9yMl/MCJSAdtOxumYj4VNDEPu5Z+3fTc/igN7G5pBC1cRNqvCBEmqxL1nphOQVwUFsljf5PmUU8gqi6GP/Z9m7Floa6ystcbaDhF0iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_ext iteration API does not validate if the PFN still
belongs to a valid section while advancing the iterator. When
dynamically adding memory in the hotplug path, it can lead to a
NULL pointer dereference during page_ext_lookup at the boundary
of the last valid section when iterator count equals __pgcount.

The for_each_page_ext() macro calls page_ext_iter_next() as its
loop increment. for_each_page_ext() does a
"__page_ext = page_ext_iter_next(&__iter)" at the end. This
causes page_ext_iter_next() to increment iter->index past
__pgcount and call page_ext_lookup(start_pfn + __pgcount).
During memory hotplug (online), the PFN at start_pfn + __pgcount
may belong to a section that has not yet been initialized,
causing page_ext_lookup() to trigger a NULL pointer dereference.

[   14.555124][  T846] Call trace:
[   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
[   14.555127][  T846]  page_ext_lookup+0x30/0x3c
[   14.555129][  T846]  __reset_page_owner+0x11c/0x260
[   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
[   14.571204][  T846]  __free_pages_core+0x78/0xf0
[   14.571206][  T846]  generic_online_page+0x14/0x24
[   14.597782][  T846]  online_pages+0x178/0x30c
[   14.597784][  T846]  memory_block_change_state+0x284/0x32c
[   14.597787][  T846]  memory_subsys_online+0x4c/0x64
[   14.597789][  T846]  device_online+0x88/0xb0
[   14.597791][  T846]  online_memory_block+0x30/0x40
[   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
[   14.597794][  T846]  add_memory_resource+0x280/0x298
[   14.656161][  T846]  add_memory+0x60/0x98

Move the iteration boundary enforcement inside the iterator
functions, so callers cannot inadvertently access beyond the
requested range.

Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
Cc: stable@vger.kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
---
Changes in v2:
- Incorporated comments from David and Matthew to check for invalid PFN
  in page_ext iterator rather than checking for NULL section in
  page_ext_lookup.
- Minor improvement in commit description to include the issue with
  page_ext_iter_next
- Link to v1: https://patch.msgid.link/20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: kernel@oss.qualcomm.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/page_ext.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 61e876e255e8..4f7d7a8709de 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -120,14 +120,18 @@ struct page_ext_iter {
  * page_ext_iter_begin() - Prepare for iterating through page extensions.
  * @iter: page extension iterator.
  * @pfn: PFN of the page we're interested in.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no page_ext exists for this page.
  */
 static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
-						unsigned long pfn)
+		unsigned long pfn, unsigned long count)
 {
+	if (count == 0)
+		return NULL;
+
 	iter->index = 0;
 	iter->start_pfn = pfn;
 	iter->page_ext = page_ext_lookup(pfn);
@@ -138,19 +142,22 @@ static inline struct page_ext *page_ext_iter_begin(struct page_ext_iter *iter,
 /**
  * page_ext_iter_next() - Get next page extension
  * @iter: page extension iterator.
+ * @count: maximum number of page extensions to return.
  *
  * Must be called with RCU read lock taken.
  *
  * Return: NULL if no next page_ext exists.
  */
-static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter)
+static inline struct page_ext *page_ext_iter_next(struct page_ext_iter *iter,
+		unsigned long count)
 {
 	unsigned long pfn;
 
 	if (WARN_ON_ONCE(!iter->page_ext))
 		return NULL;
 
-	iter->index++;
+	if (iter->index++ >= count)
+		return NULL;
 	pfn = iter->start_pfn + iter->index;
 
 	if (page_ext_iter_next_fast_possible(pfn))
@@ -183,9 +190,9 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
  * IMPORTANT: must be called with RCU read lock taken.
  */
 #define for_each_page_ext(__page, __pgcount, __page_ext, __iter) \
-	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page));\
-		__page_ext && __iter.index < __pgcount;          \
-		__page_ext = page_ext_iter_next(&__iter))
+	for (__page_ext = page_ext_iter_begin(&__iter, page_to_pfn(__page), __pgcount); \
+		__page_ext; \
+		__page_ext = page_ext_iter_next(&__iter, __pgcount))
 
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;

---
base-commit: c425609d6ac4012c8bbf01ec2e10e801b1923a7b
change-id: 20260616-page_ext-31ef555456fc

Best regards,
--  
Ketan Kishore <ketan.kishore@oss.qualcomm.com>


