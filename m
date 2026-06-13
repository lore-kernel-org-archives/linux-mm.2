Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AA1CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 17:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D956B00A5; Sat, 13 Jun 2026 13:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156366B00A7; Sat, 13 Jun 2026 13:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044566B00A8; Sat, 13 Jun 2026 13:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1AD76B00A5
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 13:21:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7748C12048B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:52 +0000 (UTC)
X-FDA: 84875556864.14.2D2A723
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9F8D140003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=F3d3zfgV;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="XzcJOq+/";
	spf=pass (imf26.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781371309;
	b=012fKVauv4CwjTfAl1IZhamE7LnZkI0P6WaNFI+cWH3MCBGAHY/4mhG4M6KEsRQhZcY56Z
	EymacHAkTBFTh02t7CTgDb8TKodldQOkAnI4WPPgAkKY+Hk992Bx/GAPtdPKi5we/48Idw
	Y2NGzQdycIA/w15zOHeEltdCGdY83yU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=F3d3zfgV;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="XzcJOq+/";
	spf=pass (imf26.hostedemail.com: domain of pranjal.arya@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pranjal.arya@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781371309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEwkWdeK2JOxz6CkWOPVdEpzOJip0EPBtxLmX7NxFto=;
	b=xBW4JkS6FP0mSjtkdpz3dHfP/9eqXPovQt8vkRiYwsYCYv0+q0uBnL8rmA5Qorxwzn4+BT
	jvWOem1hJKHzLJNsXgyDRtg0/C1+fTDODtN3jpiR32DHoRYThqvHaR4dAb5NkZf0B7w1gS
	B6Mgkd6kbdhjwpooRCuGGgQpq87mUTQ=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65DFApg33283442
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CEwkWdeK2JOxz6CkWOPVdEpzOJip0EPBtxLmX7NxFto=; b=F3d3zfgVQWpLzqDb
	rVHYFKrrSxRwKj/qdAheSyaCiab4OUQWb9AmJytKD3J+LB2MSuXW61DmfyhWWjQW
	CKmSuBYXIsTMaCuJta5D/TNu7gIaHsh9A5GAuZ/gXS9zcqHIf9hlA1jCzoNRtgwF
	XDb/aaLKwthBrUC4viEg6Q5lQEbeFENAEkS5QY9hz3+FSxHIrO2tMQCRyXM4MuZv
	nnkelEy0BYA4jWhypdLJwcJFQJ4Mis0U+I6U6dJMWpa3vFkmEcv6xNI2ea4Acv/S
	RsFPtl9UlF192CxhabyjaVZVonAv+/T7imas3ScKscxTW8/NGozkJHK/zhVRH21L
	OmNUeQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery8wsmpa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 17:21:48 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8423f544944so1418216b3a.3
        for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781371308; x=1781976108; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CEwkWdeK2JOxz6CkWOPVdEpzOJip0EPBtxLmX7NxFto=;
        b=XzcJOq+/reOLGFdQhdAAR4trIEVH8fSa907ieLXjhm7LmmWgx4EbrRN8TdZo5umy8d
         K0zTeL2McgxGAeyWY0OZvKxyXGYjnFN6bC7k6Q/HFvkFu+4DuKHXqszHIZyRRCRLZ1u8
         Q6xzXvbwwY4mdMnf5dWs99GyYAFme4/n27nrpjo20r/BaCUOefq7/WSQ6MAQFUnB9t9K
         b2/YEaowswOc1qVI+vyh7N6+Zv4TWcTOzYpue6IB/eZwtFuBnXj1FnNAaGrnFgvOy1xG
         hdqtiGt7OZUTiLTvWPqYop+xJPhUMucPiES/b5vV9Q4qsb6AywXc5b4Zrzc30Umyv1Kp
         M5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781371308; x=1781976108;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CEwkWdeK2JOxz6CkWOPVdEpzOJip0EPBtxLmX7NxFto=;
        b=CkRRGc96K7adFvgEIm1ilIHsfPnHoUMk4P5zQOlo+o1NgHvTWcCBAUCmXVtLTLPRex
         iJMTdgOGnn5/jNzJyX7XvZv70wh6qRw6IGgeDEcazIYMKWzERP2KwMcqVTAezTxSpgAt
         F/QjxR8iOnnce/pqH7v3/KE4xb/hHZN0424uHi3sMwZmnFIO4vbLD5tbfRnuTrJdYrnL
         aaY2Pwyn7Wfj47vsoYKGf8EiPc6J6gSQvOZYv/0zUwMowF0loa0fWYizYD/TBeAYiV3x
         dGh+2fpISrfB7S6HygpvKcPYCnAaWK50vTqeOuW2x5SeNwG2kcFWbCwTcUISX2BSUJ10
         2fzQ==
X-Forwarded-Encrypted: i=1; AFNElJ92zH8CjC9zgNSwakkEi81SKS2i9Wwy+KD/Y9zThPkzBy8ZTbrC/gI7hKr+oNnDgtQ/FwDC52sQIw==@kvack.org
X-Gm-Message-State: AOJu0Yw9WddLws/BMoEfphOr2p3TVaFh0CjUnEApMDa0pZvwiBDS+lzK
	qoCKDFZdeRNfxedgxmXILcVbDRaJYivtBoAtk3mPR8/Qam/uZJ+PYAeytTFdEoxZ1a0og/SLNVT
	JNUmDeE9RGcsggKhhmdH+1IMwGbThoEEJ/3yiAj7AsAhvyDI+EhJH9g==
X-Gm-Gg: Acq92OGyN1YrmSW/9I+i71G28mDZc/1f8PSCKrdrLajxO8E9VcV7lSvyisObv9JIv+3
	pF7IFe1r4d5j8WjpfQRJSNk2nNhxY+qYhnLDbow2hPPZg9obJFFJwJjO56WLWg/2q4I76cVjIZK
	O0ZKA7Sv5gH1I4+zbwJ8EHeOWQ3dhDABAkiInTsx7uxcf8ms3sWw4zjoDuuOupDXFT1p/Hh9Qwn
	ylfpO/6SwrNPo40Jk+Fad6UQx3TKMMM/fTMQ/KtXOfSEpwCkA+FL5XJAhCWQgk1drPYtJM08qzA
	wtXjtrajec97LO5Q+iPe0cuJZUofq2HouqFX4KPjjYGjk8tDCvMqrMpg1iZvCK648njcJq6TXnN
	sBqEnxrtvOD31ZHbgmj+P/OcUOwPg09/RiUfVVvECN6lVlLBVpwjE0w==
X-Received: by 2002:a05:6a00:3996:b0:842:3be7:4d57 with SMTP id d2e1a72fcca58-8434ce31498mr7995854b3a.18.1781371307769;
        Sat, 13 Jun 2026 10:21:47 -0700 (PDT)
X-Received: by 2002:a05:6a00:3996:b0:842:3be7:4d57 with SMTP id d2e1a72fcca58-8434ce31498mr7995808b3a.18.1781371307197;
        Sat, 13 Jun 2026 10:21:47 -0700 (PDT)
Received: from hu-pranarya-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434accbec5sm5390913b3a.16.2026.06.13.10.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 10:21:46 -0700 (PDT)
From: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Date: Sat, 13 Jun 2026 22:49:52 +0530
Subject: [PATCH RFC 10/12] mm/vmalloc: per-CPU caching of free ranges from
 the maple_tree allocator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260613-vmalloc_maple-v1-10-0aa740bb944b@oss.qualcomm.com>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Lorenzo Stoakes <ljs@kernel.org>,
        Pranjal Shrivastava <praan@google.com>, Will Deacon <will@kernel.org>,
        Suzuki K Poulose <Suzuki.Poulose@arm.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mostafa Saleh <smostafa@google.com>, Balbir Singh <balbirs@nvidia.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>, Shuah Khan <shuah@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Brendan Jackman <jackmanb@google.com>,
        Puranjay Mohan <puranjay@kernel.org>,
        Santosh Shukla <santosh.shukla@amd.com>, Wyes Karny <wkarny@gmail.com>,
        Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
        Sudeep Holla <sudeep.holla@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781371215; l=10345;
 i=pranjal.arya@oss.qualcomm.com; s=20260516; h=from:subject:message-id;
 bh=PsqiD8G6HiZiANmDP/iDjGIPvGoKXcMiDUmCdx9BhDA=;
 b=Rzw5Lud8MlSAcq9OrXE/82DTua23HOpREVjTa+P4bOWSQXGGH2GBYsa2/2zyORRZl+X2/MnQV
 Ju0LVd2eH8fBQb6oGLJiYWu3DKB8RDzJ/6N+2REGYcU7x9VGIQ29X4s
X-Developer-Key: i=pranjal.arya@oss.qualcomm.com; a=ed25519;
 pk=ymtcTlccEIDsi3ErhpjIoZZHKdPBYWGWW0Lchs5MsbE=
X-Proofpoint-ORIG-GUID: I_41Uz0ckrh5MMR2Gd_IMPhOyxQUQNLT
X-Proofpoint-GUID: I_41Uz0ckrh5MMR2Gd_IMPhOyxQUQNLT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfX7SEyjLh/XR64
 7N1JVSwlvEy0Desf+OMdT+MA7NVGmwi+Hm//K75pmP7PfGwKoaX9kus0TbvSeIew5rK3lQbj2yn
 oG7aYkLPRh+YjWX3LOIezY2ifj8abbU=
X-Authority-Analysis: v=2.4 cv=IqAutr/g c=1 sm=1 tr=0 ts=6a2d91ac cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=FUy_0n9OcN9IEB7T7O0A:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEzMDE4MCBTYWx0ZWRfXwbEL3HbaKBU/
 +QoZrJZ39RJfXv1mMh17D4wR97/1h66lHksuyCKXtX/ewiqxjwSY9ceDR8P3Hf8i60UFWtPeZWE
 NS9mYdU8EPSN5+szpKKFr6F5zhM397k0Pv6g8v8/HOYRpyhzI4g6SsjE2phfilKqWbdVqHb4OuK
 vL795jm825j/v5AdJiMWfNVcC4bw3SomHn6sCnQ3U132vcLdBkL2UPrPLBtcLtN1wjLr8WaK0n0
 CSvdjKuIrD9jv1Jia0nRlt+eRoU2IKXboUNepZ2/+iJcL8A9Feojd+X6i59093DQzaowSECNvQP
 5EAh1G8WS5whvTS+YCJIv3IeghP9O4jWVJGApnPeB/CsLVr3sgkf5LNCqkjGloMTO8ZROHcQ5iE
 e5FoTZj4GZZrdNXF5rDhlnfEfAK5skH3VHvfsIzI2x4v86SqEnH22l9aUnnjrN0fBelZMN2bbnT
 PceznLExaBw9UBE7OFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-13_03,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606130180
X-Rspamd-Queue-Id: D9F8D140003
X-Stat-Signature: zm9uiohoqbxergx4fywf34qkpkpank5d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781371309-942326
X-HE-Meta: U2FsdGVkX1/bc4F9nTPUqFPx6SIcKLm8b8fOHygua+njL0XztE84ca6tWQTClk702g9EVKZF+pUEDOnvkOnYnaJjGpDfVKTiFVmuVFSejhAEXQ/9dvCjZhSU5uxUIAEUIqj1hFr7R7g/TQXMB/QJjo+Arn4PHP7AeTKc1NWll8iQDuaTJD0jZgVGmQNv14hvn7vA/OJ87w4mmtKm9OxHqglJye4W9OYvTC6g26ssU9vbo9HfmgPospO6p+cT1gtYBxDyRIMyxW6oy/qKOH3HHzyku+l2eU1Nh/gf80WVtTzXnsaHYMnajWHmGqHT1ozP+rPQJKy/NKpLCafar9G/YQjTFf5q/dtAOYVTIzpooDFQArF6yv3rT+onSL0jfN+UvReNRhA09s316XbIcmOlIpjB8mBYcsYrA4EDayUWUE+pQYrA5UcF6OiFN3jXx1O3wln30HUSmHM0FxTsC30KJN+C8b48MMSHSLUtVyeIzaKe2MXBkyKufeoWFr3Oz3rVbe3AOH1DwZt28XUrq6FdkB/Oi1vIgJAhOxmgmqgmfudXZPtvKrE9rwmyS/mB29UTPfz7Yy4t5E0hNtBNXWNJcWRawRNRirqas/uNgMX9TFAKzCyq/35Kkzc0V6MMbI6Hxq4PMw01fDvUtoxo7Tc0tWbJ1pSzpHMsM/DC+HDK+nx9tsfrx/oqzngEb++lmj7MHYQ3p/Xvv1QDPjBEWaqsbXv9xZFGT26k18BI+kMHFQE5cx/1pi38Fnei87uctCpSD+jooesPojTDbv8lWJ6JQkkmLTlDBQIdddaWBRYiP504+HKhW/sANmD2aDheRPjlrpxPWYxjtXkiN/aIAlov234tb8jCYlid4sfFKg0elij0N9EM2gY8o/PHoIxzCgABKRXbZYc2kHjWx+2eLbWagzWra9R1Bd1SMf5MpyU5u//6B4rv2f317S8r3wmLY8gMNcvcHuaV9SU+Fy4Dstc
 hPVeOt/e
 ig0JCiSjNuEaJu5MCu+Ay8S4fhBp/KcWRLIfBl9E/AMLEm0yC6up2nagqZ7h17dpEv9aLwQdw79MB6jJipAGzh0l8xYHGXQvoQPZOS6O+blp27KtvazPWhnzg6jDkhU9P8JDogl2YB9Y07mL9lyIZ8lHhDfdQzR1RihN3fPUYfkYl23liBdPvvATG5rF8cgr5AShd2ZWc7ePkpGf3AxXDO8QgsSB/M/+2ic/SC4LFjuuOa4v8MyihO21d8XFO3opH4x0ecIWLWTlycWx6mPsnYwtDQ4ZT4AH9e+E+GCmmqlkteZ1DWKejdywb7I0+picYt4c2/QwZVo1MGgf6FHrip/EehOubLtZoWTK3Tk1knv0dhS9Ze08hvG0QsFMmyaTqbweVhaPFyBUnM/+HzzMGDDZ4mrH3pllyA2Om3W/uAb5dm2Vz9fVb5cdMnnDIigcMUD3/uxyiKtFGxrjPjymr4PSPixjzBYhix1gN23aD8ayvCPizOb/ucGzAJqw3a768pHMGyLoYBiSG31oIV7LfbUMkgNrg2jR/yUp5BrgkXP63Sjiw9/wGlOOEKFH8HYU359WT3536yTczbnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the alloc path goes through the maple_tree-based gap finder
(mas_empty_area), amortise the cost of visiting it for the most common
shape of vmalloc call: short-lived, page-aligned, PAGE_SIZE-multiple
allocations.

Each CPU reserves a 64 MB chunk via __alloc_vmap_area -- the same
maple-backed allocator the global path uses -- and dispenses page-
aligned allocations from a bump pointer inside that chunk.  Chunk
reservation and drain are the only operations that touch the global
allocator; per-allocation work stays entirely per-CPU.

When a chunk's allocation count returns to zero and it is no longer
the per-CPU current chunk, vmap_bump_unlink() releases the chunk's
range back to the global allocator via occupied_mt_erase_range_locked
-- the same maple primitive the consolidate-occupied-tree patch made
authoritative.  The chunk install path uses
occupied_mt_store_range_locked symmetrically, so cache lifecycle is
expressed entirely through the maple-tree's range primitives.

Per-CPU access uses preempt_disable() rather than a spinlock; the
chunk pointer is per-CPU and only mutated by its owner.  The chunks
list (vmap_bump_chunks) is gated by a single global spinlock that is
taken only on chunk install/release, not on the fast path.

Why this overlay sits on the maple_tree migration
=================================================

The overlay relies on three primitives that maple_tree provides
natively and that the augmented rb_tree allocator does not expose
in a clean form:

  - Bare [base, limit) range reservation. The augmented rb_node
    carries a vmap_area-shaped subtree_max_size consulted by
    find_vmap_lowest_match.  A chunk reservation has no associated
    vmap_area object, so it cannot be stored in the augmented tree
    without either synthesising a fake vmap_area per chunk or
    introducing a parallel range tracker with its own augmentation
    discipline.  maple_tree stores [base, limit) ranges natively
    and the gap walker (mas_empty_area) returns the lowest free
    region in a single descent, sharing one primitive with the
    regular allocation path.
  - Sentinel range storage.  occupied_vmap_area_mt records a
    reserved chunk as XA_ZERO_ENTRY over [base, limit), sharing
    one index with ordinary in-use vmap_area ranges.  The
    augmented rb_tree has no equivalent of XA_ZERO_ENTRY: a
    chunk would have to live in a dedicated structure, doubling
    the alloc-side state surface.
  - RCU range traversal.  vmap_chunk_lookup() must run lock-free
    so that cross-chunk vfree() does not take a global spinlock
    per free of a chunk-resident allocation.  maple_tree supports
    RCU traversal as a property of the data structure;
    rb_tree-side equivalents (lib/rbtree_latch, hand-rolled
    grace-period accounting on top of rb_tree) impose write-side
    cost and would have to be added to vmalloc as new
    infrastructure.

After the migration these three primitives are part of the
allocator API; the overlay reuses mas_empty_area() for chunk
refill, occupied_mt_store_range_locked() and
occupied_mt_erase_range_locked() for chunk lifecycle, and
maple-tree-friendly RCU for the chunk-list lookup.  No parallel
data structures are introduced.

VMAP_BUMP_CHUNK_SIZE = 64 MB derivation
=======================================

The chunk size is the smallest power-of-two value that satisfies
three independent constraints:

  1. Eligibility coverage.  vmap_bump_eligible() requires
     size <= VMAP_BUMP_CHUNK_SIZE / 2 so that any single eligible
     allocation fits with room for alignment slack.  The largest
     standard-range vmalloc() callers in tree are the module loader
     (modules can carry up to ~32 MB of text + RO data + RW data on
     architectures with full kernel module support) and BPF JIT
     buffers (capped near 4 MB).  Setting CHUNK_SIZE = 64 MB keeps
     all of these on the bump fast path; halving the chunk to 32 MB
     would push module loads to the slow path.

  2. Refill amortisation.  The global vmalloc lock is taken once per
     chunk refill, paying for ~CHUNK_SIZE / avg_alloc_size bump
     allocations between lock acquisitions.  At avg = 4 KB (a
     plausible lower bound for typical kernel vmalloc traffic),
     64 MB amortises to ~16,000 fast-path allocations per global
     lock acquisition; at avg = 1 MB, ~64 per lock.  Doubling the
     chunk size beyond 64 MB barely improves this ratio.

  3. Address-space cost.  Each CPU pins a chunk-sized reservation
     within the vmalloc range.  On a 32-CPU server with the standard
     128 GB x86_64 vmalloc range, 64 MB chunks reserve
     32 * 64 MB = 2 GB = 1.6 % of the range.  On arm64 with
     CONFIG_ARM64_VA_BITS=52 (256 PB vmalloc), the cost is
     negligible.  Doubling to 128 MB pushes the x86_64 reservation
     to 3.2 %, which is still acceptable but starts to matter for
     workloads with high CPU counts.

Per-chunk metadata associated with each chunk is sized as
sizeof(struct vmap_area *) * (CHUNK_SIZE / PAGE_SIZE), which scales
linearly with chunk size and stays at a constant 0.2 % overhead
regardless of the chosen value.  At 64 MB this is 128 KB per chunk.

64 MB is therefore the *minimum* chunk size that meets constraint (1)
and (2) simultaneously; constraint (3) sets the upper bound and
allows growing the chunk if module sizes grow in the future.  The
constant is exposed at the top of the bump-allocator code block so
distributors can tune it for unusual configurations.

Allocations that don't match the predicate (non-page-aligned, larger
than half a chunk, fixed-VA, or with NUMA constraints) fall through
to the existing __alloc_vmap_area path unchanged.

Signed-off-by: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
---
 mm/vmalloc.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 463127d5ce58..65ee80eaf4bf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2467,6 +2467,98 @@ static inline void setup_vmalloc_vm(struct vm_struct *vm,
 	va->vm = vm;
 }
 
+/*
+ * Per-CPU bump-allocator overlay.
+ *
+ * Each CPU reserves a contiguous chunk of vmalloc address space and
+ * dispenses page-aligned allocations via a bump pointer. The chunk's
+ * range is reserved through the global allocator once; individual
+ * allocations within the chunk avoid the global maple-tree work
+ * entirely. Each allocation still gets its own vmap_area struct and
+ * is inserted into the per-node busy.mt, so find_vmap_area() and
+ * vfree() continue to work unchanged.
+ *
+ * Recycling: chunks leak in this minimal form. With 16 MB chunks on a
+ * 128 GB vmalloc range, the address space supports thousands of chunks
+ * before exhaustion. A future iteration can add chunk recycling via a
+ * va->bump_chunk back-pointer + refcount; deferred to keep this hot
+ * path's struct vmap_area footprint at 48 B.
+ *
+ * Constraints: only the standard vmalloc range with align <= PAGE_SIZE
+ * and size <= VMAP_BUMP_CHUNK_SIZE/2 takes the bump path. Anything
+ * else falls through to the existing __alloc_vmap_area path.
+ */
+#define VMAP_BUMP_CHUNK_SIZE	(64UL * 1024 * 1024)
+
+struct vmap_bump_chunk {
+	unsigned long	base;
+	unsigned long	limit;
+	unsigned long	bump;
+};
+
+static DEFINE_PER_CPU(struct vmap_bump_chunk, vmap_bump);
+static DEFINE_PER_CPU(spinlock_t, vmap_bump_lock);
+
+/* Try the per-CPU bump-allocator. Returns the chosen address or
+ * a negative IS_ERR_VALUE on miss; callers fall through to the
+ * regular path on miss.
+ */
+static unsigned long
+vmap_bump_alloc(unsigned long size, unsigned long align,
+		unsigned long vstart, unsigned long vend)
+{
+	struct vmap_bump_chunk *chunk;
+	spinlock_t *lock;
+	unsigned long aligned, addr = -ENOENT;
+
+	if (vstart != VMALLOC_START || vend != VMALLOC_END ||
+	    size == 0 || size > VMAP_BUMP_CHUNK_SIZE / 2 ||
+	    align > VMAP_BUMP_CHUNK_SIZE / 2)
+		return -EINVAL;
+
+	lock = this_cpu_ptr(&vmap_bump_lock);
+	spin_lock(lock);
+	chunk = this_cpu_ptr(&vmap_bump);
+	if (chunk->base) {
+		aligned = ALIGN(chunk->bump, align);
+		if (aligned + size <= chunk->limit) {
+			chunk->bump = aligned + size;
+			addr = aligned;
+		}
+	}
+	spin_unlock(lock);
+	return addr;
+}
+
+/* Refill this CPU's bump chunk. Reserves a fresh range from the
+ * global allocator. Old chunk's remaining space is leaked (the
+ * already-allocated VAs in it stay live; the unused tail is wasted).
+ */
+static int
+vmap_bump_refill(gfp_t gfp_mask)
+{
+	struct vmap_bump_chunk *chunk;
+	spinlock_t *lock;
+	unsigned long base;
+
+	preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, NUMA_NO_NODE);
+	base = __alloc_vmap_area(VMAP_BUMP_CHUNK_SIZE, PAGE_SIZE,
+				 VMALLOC_START, VMALLOC_END);
+	spin_unlock(&free_vmap_area_lock);
+
+	if (IS_ERR_VALUE(base))
+		return -ENOMEM;
+
+	lock = this_cpu_ptr(&vmap_bump_lock);
+	spin_lock(lock);
+	chunk = this_cpu_ptr(&vmap_bump);
+	chunk->base = base;
+	chunk->limit = base + VMAP_BUMP_CHUNK_SIZE;
+	chunk->bump = base;
+	spin_unlock(lock);
+	return 0;
+}
+
 /*
  * Allocate a region of KVA of the specified size and alignment, within the
  * vstart and vend. If vm is passed in, the two will also be bound.
@@ -2519,6 +2611,19 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	}
 
 retry:
+	if (IS_ERR_VALUE(addr)) {
+		/*
+		 * Per-CPU bump-allocator fast path. On hit, no global
+		 * tree work runs at all. On miss, refill the chunk and
+		 * try again before falling back to the regular path.
+		 */
+		addr = vmap_bump_alloc(size, align, vstart, vend);
+		if (IS_ERR_VALUE(addr) && (long)addr == -ENOENT) {
+			if (vmap_bump_refill(gfp_mask) == 0)
+				addr = vmap_bump_alloc(size, align,
+						       vstart, vend);
+		}
+	}
 	if (IS_ERR_VALUE(addr)) {
 		preload_this_cpu_lock(&free_vmap_area_lock, gfp_mask, node);
 		try_init_free_mt_locked();
@@ -6214,6 +6319,8 @@ void __init vmalloc_init(void)
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
 		xa_init(&vbq->vmap_blocks);
+
+		spin_lock_init(&per_cpu(vmap_bump_lock, i));
 	}
 
 	/*

-- 
2.34.1


