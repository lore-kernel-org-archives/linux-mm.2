Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CED4FCA16A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 17:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1846B0005; Mon,  9 Mar 2026 13:51:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FAE6B0089; Mon,  9 Mar 2026 13:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570F36B008A; Mon,  9 Mar 2026 13:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 466946B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:51:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBC86C17E2
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:51:42 +0000 (UTC)
X-FDA: 84527267244.14.1EED6A4
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	by imf26.hostedemail.com (Postfix) with ESMTP id 912F3140004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:51:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=D1XZMIpw;
	spf=pass (imf26.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773078700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3Fzs8McvxZarCfglw/7QEh51lw3Bd2bcGArr5kH+tRY=;
	b=WDvwCluleD5t6PGc6HfQUrTRmN7H8IoRvrqjdfeY2yKCftb8NjtCOaSeO/VuYKEB/MFsFx
	y3/uR6LfOlkpRTZa5mAIVovLuF8eb7ElSz7L850IfSBwW+NSW6zo6lD78FHnD2w0LxcCEw
	c+fcxRG2OuvH5qLblatxdAuR7dDN1Vo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b=D1XZMIpw;
	spf=pass (imf26.hostedemail.com: domain of mboone@akamai.com designates 67.231.157.127 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773078700; a=rsa-sha256;
	cv=none;
	b=kAr2ObgFAf8VDEHsydRgmFCbmk/tLerGnIG/nRuM9qyc4aBYI59jTcyGvMdMaSPajxEjPh
	vMLsihWD/7rjJCW4ehNSE9ItlsxZl2NXJX5/aWJFvhEIW6HRoepqrR1HVvFZu1ZG0U6cPh
	A+HbNH9RkbxrHjyk9uEgkYyudePEQXc=
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629HU2Kt798477;
	Mon, 9 Mar 2026 17:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=jan2016.eng; bh=3Fzs8McvxZarCfglw/7QEh51lw3Bd2bcG
	Arr5kH+tRY=; b=D1XZMIpwzaOmYREaSH3Dlessz7Ul1IH3WcSYPXRP4OnkDqq/V
	LBadjtzMuDz4zfS5Rjy4RiyMz4QQlJvhZaq6IIT8E4XSEH+YoBaut2beVJ+5KZaN
	0v88L1JV+YwF+zOVtEJOgrBdlAGDDCdi0HZFZMRPYUVeWa1+MYI408gkqDwREWg8
	RxSj0N0bW6mhmw4drsN3hmmF+eFcxRFYaLpX3N7pMJB/sSKFR6/ku0WM++dbI71L
	FqeapcM+Z5tno9GBps3Q3tNSSbBbi10tLxBCiEvNnRz1tgY+Kgj8QINxLwEBH2h6
	WZCpIWPFyopihI6Kd2pfztNv4lV/nztdULYlg==
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61])
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 4cr9rusqd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:51:30 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
	by prod-mail-ppoint6.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 629Hmvqu012722;
	Mon, 9 Mar 2026 13:51:29 -0400
Received: from prod-mail-relay01.akamai.com ([172.27.118.31])
	by prod-mail-ppoint6.akamai.com (PPS) with ESMTP id 4crg7yh65d-1;
	Mon, 09 Mar 2026 13:51:29 -0400 (EDT)
Received: from muc-lhv4ep.munich.corp.akamai.com (muc-lhv4ep.munich.corp.akamai.com [172.29.0.215])
	by prod-mail-relay01.akamai.com (Postfix) with ESMTP id 4DB0884;
	Mon,  9 Mar 2026 17:51:27 +0000 (UTC)
From: Max Boone <mboone@akamai.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@akamai.com>, Josh Hunt <johunt@akamai.com>,
        Matt Pelland <mpelland@akamai.com>, Max Boone <mboone@akamai.com>
Subject: [RFC 0/1] Avoid pagewalk hugepage-split race with VFIO DMA set
Date: Mon,  9 Mar 2026 18:49:48 +0100
Message-ID: <20260309174949.2514565-1-mboone@akamai.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 bulkscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2602130000 definitions=main-2603090160
X-Proofpoint-GUID: IhDo1xtWvIeZ4ATgEP8gNVTxpFnVSGBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE2MSBTYWx0ZWRfX/lr2FHIN3A+v
 vJliNDnFOhJWINlIYOMTsCNJ7gEreHOQbFgd6kjziVC3Agmmao1XbS5GfADbRtB4uc6SrY9kbBn
 I1/+HwezjCBTftihehhRx1jzjzmxTrU7HvQRrTlfXfzepZwy+WGIyTufk971bfd13v9jdTMccpc
 3Zzm1qMG/fujlFmHsCe1+EkWXaA0k02mmOoXJkEUoT08izxe2drrYjX84El2/gAleR3nFKprFym
 EnTAwcPo1DYkWD3U6KQ0xS50fdrUKa9jVnuY7cd77RA0lB7fH5PelvvgPKfPzUkQemDUp3FNLUX
 l57OY0NLoFWKHJDeacDj14p7xvSrfBGNvUCFjVZadBUvqDpdJizqvzOn9qabeIMaC7cpj2sC1Uz
 wbnVrfPr4N+Rd2wITAXhO/JGfxzvUvQv+X0atPNMmWQ8RdEEp/RMCxYSPDGdzDSGD4vaPA2Bdzh
 eoYAkZcN9rXe7vDfHdQ==
X-Proofpoint-ORIG-GUID: IhDo1xtWvIeZ4ATgEP8gNVTxpFnVSGBT
X-Authority-Analysis: v=2.4 cv=Wuwm8Nfv c=1 sm=1 tr=0 ts=69af08a2 cx=c_pps
 a=WPLAOKU3JHlOa4eSsQmUFQ==:117 a=WPLAOKU3JHlOa4eSsQmUFQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=VcQvXEo1OZcA_IiPcy3B:22 a=NEAV23lmAAAA:8 a=X7Ea-ya5AAAA:8
 a=J3MF52ijxDzPJOGfDI8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 clxscore=1011 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603090161
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 912F3140004
X-Stat-Signature: ci383kdcmdb6qbzrkyyety4oor9cjw1s
X-Rspam-User: 
X-HE-Tag: 1773078700-651576
X-HE-Meta: U2FsdGVkX1/L38EGrzg+9GX6BRFH0tOQj2IRR3Jn/XrEQscq0PrjL52VU1iGUfXVH1rDmFPsDmRkEjB+2koSuEOs1nfrQYkBVv0l5ihSNnCxUngvcjuzlmEoRcp98II5zvUTwqpK84T86wftru5z2Oz4qgrzvBVq0EsqTXPOJ1lzZ85NIXcpeYQm2co4gRI8sKovIF7d2ld1OJRnWs8h3lB89TTn77D8WGRIRdpQritazC9zxgebiD+uha0X2DT/PROfgUGhCMTcl1lGXKO7Y8ODDUtxo4C4GM3bs0EkH4T1DnR4ikc8jnfl5rkZxS6Kv/jmCIdNboFRBjfZctJP8aSnCBz3vTrJZEzJUW0cDJ/l1s+pDdF+jXZfGMmmWX7Br2NqsQhaar7caqdwrSp1jcOELvrv2nH3KxL2YkICryUBUTSueVATaJGmKGU3MhSLahhdr6Mf/uz8CaCqIV3EP8eImVGRLkNUpVpirMiAANlld9PD/G19KRs7hQwmVsE19rPJSJG2aZorzw5Zi7Es1YlUoPIH+Vf3/eScRXZAR3+m/GyIWXav2PpoN2g1YWJoNLEtEbfC8rX4aO7e+Z3+2ZbZgdr1ay4yLDXrCL1lBFBSbk8+BpMEEjf9mar0wUW8PJtqrPD5cP7dus5igvAkotBevbJibNSd3w7JkzYBtj1v4H1zr77ntyovxHhxidg5x5YwOVJnZV6nsiCpDus8xLgHQV4+UWWvstkxn7SI+O0GeBc0EWSpRAD88VTHFjIdwxUgsBDF43l12zzdZipAxcpAh/6kiZ756wsPELZcG3v6sW/MD7XcnlJFwhMA8p2QrGGXwn1YuvEIhq1t8PJlrc8wzCAEV9e6qN4bYbtIZgtT6OPGty08B0Na+icgwJRcf9wm0jAkB5tVKX55vol6ByXzteloHq9ZgdtBkg5KVY+nkUAQF45Avdj/flp/I49OaYSn0eLhtxH6UvQaY5z
 xqyJShcr
 kr/YuT8LbdTNupK/JnP+QsF8XnKiBBipZfiZAizIxQ1JNxgNTQw9CunTMU3Y1fFWh1+E6S4KnAiGetdoOfq6laFIwx//j9cE+5EAcqKVIc5IZp2zBwBomM1N8qPnHG2A3/X79kZfhfVyrIgoXK4T1rYt21bQ/jets6PvbyCuEc8elIsOZRmYBKKJXTczuJrE4PoiH06MKmtUdSAWCE7gjdOQZsQIg+yfHJOYTElSMzu+Vr7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel BUG can be triggered when /proc/$PID/numa_maps reads are
hammered by one process, while said $PID is setting up DMA for large
1G-aligned memory mapped BARs.

The 1G-aligned memory mapped BARs get set up as PUD-order PFNMAPs. When
the generic page walker (mm/pagewalk.c) gets to the PUD table entry of
the memory mapped BAR in the walk_pmd_range function, it tries to
split it by:

1. deleting the PUD entry by calling split_huge_pud
2. checking whether `pud_none` is true to go to `again`

		if (walk->vma)
			split_huge_pud(walk->vma, pud, addr);
		...
		if (pud_none(*pud))
			goto again;

3. if has_install is set, it calls __pmd_alloc and further descends
into walk_pmd_range

again:
		next = pud_addr_end(addr, end);
		if (pud_none(*pud)) {
			if (has_install)
				err = __pmd_alloc(walk->mm, pud, addr);

When VFIO is setting up DMA, the PUD entry can get reinstalled between the
split_huge_pud call and the pud_none check to goto again. In such
case the walk continues to the PMD-level and an illegal read happens.

As a mitigation, I propose to skip splitting the PMD and PUD entries
that are marked as special in the walker, which are mappings that do not
wish to be associated with a "struct page". The only occurences of these
entries I found were the vfio pci and nvgrace pfnmap mappings, which do
not behave like regular memory.

For a reproduction, the `vfio-mmap-bar.py` script repeatedly DMA-maps a
1G-aligned BAR and can be used to reproduce this bug:
- https://github.com/akamaxb/repro-vfio-page-walk-race.git

Run the `vfio-mmap-bar.py` script with the device you want to passthrough,
and in the mean time, cat the `/proc/$PID/numa_maps` of that process repeatedly
in a while loop. This caused the `numa_maps` read to crash on an illegal read,
when testing it against a 128GB-sized 2nd BAR of a NVIDIA Blackwell 6000 GPU.

Signed-off-by: Max Boone <mboone@akamai.com>
Signed-off-by: Max Tottenham <mtottenh@akamai.com>

Max Boone (1):
  mm/pagewalk: don't split device-backed huge pfnmaps

 mm/pagewalk.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

-- 
2.34.1


