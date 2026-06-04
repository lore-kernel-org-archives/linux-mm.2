Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 891EDCD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 09:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42CF16B0005; Thu,  4 Jun 2026 05:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDA56B0088; Thu,  4 Jun 2026 05:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5806B008A; Thu,  4 Jun 2026 05:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154B76B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:37:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1F1C8F515
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:37:11 +0000 (UTC)
X-FDA: 84841726662.26.3C3ECFF
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id E580F1C000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:37:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="gk wQ7pQ";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="PO0OQJ/j";
	spf=pass (imf21.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780565829;
	b=nk5ZupcZhb9ZVkv5zgkez9X/BuSghZ4DxGtwPxdAeuRq2byJ7EozBPnhwV6TUf4INKR1/l
	u3eGXJCWeI9u2LzPY91vEGk+Ak1UZ/dIqYjOBYIVKNMjAxnjNwmKUZ7UU3dmc34I9JyC/z
	duVUYa4jrfzGe+CWKKBmaQ4hsPIeMK0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="gk wQ7pQ";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="PO0OQJ/j";
	spf=pass (imf21.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780565829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
	b=CifEoe1J71ByQTqpizzgLtwTH2vBS0HZpy/mjM7urHekXoIf4VrXe1tRIirPlIGuJxtnuV
	amAtie4S0JrRU2DU/nKQj1hjnbPLX6b4kepiTnQLXoe53pQcIOhyIEpzyKdhP0lZrUEfeY
	6wbGyZIPawSxuy+CSntXNMVI3UL8BQM=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6548UfG11132390
	for <linux-mm@kvack.org>; Thu, 4 Jun 2026 09:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=; b=gk
	wQ7pQGrydVH4blqAd03q/e5Ae1bc6NbOQrmi8+rkuGoe4hzxNhqsJTwdZ7wdW/+N
	qDxXNeOTPUwizWZs2hH9w8/Dguipy6CaRuCRoLEcFNj16hvzbndv+YDWdp5V7tbO
	myZCEQ905ekyZ8KmSkGZ4nHoSkeaSZo90THNZ8f1Ow09YhZkoFIQTeHNfhZw9Vx4
	PFfg/aVoZC4rsLW1ANya/izCW3kjD78HPRL82MviYJ9f77AWmu3ujblBlbiwXYV0
	1gWu4CL/J3Nn8B9UV26DMYO+HnPLUwIs+kzQRLfroybnAOf5kfTrCEXsRYwhpABP
	B5FOeZZdPcS6JqR0hCZw==
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ek5wsg85t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 04 Jun 2026 09:37:07 +0000 (GMT)
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-440e399d049so466614fac.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 02:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780565827; cv=none;
        d=google.com; s=arc-20240605;
        b=k804EEkgFqmfDsPFj0LGpK7sVLxZxHvPJYKgXM7fcrTXzahYeEvogqPl2UfwFblPTY
         so15HcE+5uyL+7nxi0mSGGGeQLtvMqBiO9Q9VygWuvHyOnf08Mg1XsymhzybK0D3ElYZ
         8dXHzPOHEslXdfBKtBg1JbblLHcluYSBnbuOAKQf//wAdZpKWFtebYQk+CtLBlaYqLaa
         Sidf5bU03RRKncCyBEFiCvLo4HGSnTJf668q4g70lpJZcT8hYnPoJ6L9NMFxyOu+DWWz
         zY6MINvHkE0fnmeVvNUS1W99VJxkQVkAACOpnKHeC1i3Ziis1uyuzZVaI0bQ9ESdxKLq
         AAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        fh=JyjqsHMbbXLdwZi3vMoiGOhIK9LWhTDxuAojps0vLG4=;
        b=aS6tEeiIivthdokmoRtiebFvhXZtISo9U65TXA3/8ZaNPXAKkyRayXrY0dmFgU2IdL
         F5YMxRsTnD7EhHKZKq7wg/wIlUe8Q/F9dbfpbJmr08km+qXS48tcHUIJEXvxr9ZkVZrG
         lmh2iY7Y/dcWOXzfimUVlws03XSG2Rrn8SW86t7bOLB11Wx8S634LsDWls/DWZAOSRwK
         JpwZOzKFk6cqH3I85hw7yH4xOpWTO9Aj4imqCuUH+Hef935TJtaxdZ0mcTpLvzXIxdgn
         Qf8+dIAIHgLsEb4aGQ9eaoupFTu8W7lCk0Fcz0O+4xpHNMmgwgawUBF42CuwBMS7Mihr
         Jtog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780565827; x=1781170627; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        b=PO0OQJ/jmrujRDiyNvKVUxyt5kNQ21it0uLdXZiZddXCLQDlcGyREHZEciqTMtevvk
         vEZDBXuRK2wn6TtIMc+4VMjSzR4/OF9FcI3SpZlkCQcPU5kUoP0gIzLIgDsw6O6BH5Gb
         PKrJdc12jW/uD8vS1Gsw0bPIwuIHGrzniBtASHeUgaEMeaFGadNKvyrQs2bQL/A8Vuvc
         7U4yWCZO8eItkbMr8APtg+ez3oG7h7bDRQMGqP8PoXY181MyingXFivAjV2b0rxyW4bt
         ZCqMnyO5X9/o4YeAJw+j2zH9tCnqlh7BNNF0+8qmQ/v75fWwQlWi6PwV1M4RSALR99zB
         tz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780565827; x=1781170627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        b=K8VVec2NuGOs5gddT7+gkiZ0CHzBwoOAJ3U4YiJI5ve96rvJGGfM5vttoK+IDJyhXL
         jlVVk7QMc6k8AgpFF+jodt8tGebVI1/sbXWyF63hL6xr8y7HYkFTsnZeoIqux4AQZgZS
         kAeK4sfs2+x4GIuNE/tIslnLskXU6Y3hH3ANyp7G3hYFB0qdH1LxtZRSkH9lh8uStiJx
         2wvaz7KPlI4GmgnSB6kFvv3UOFcbsf5JBwK/ojNr6YhU1eohugRxeG+DnNN0Ybu7HtPX
         W9H4flQ0SDNUOU2KTR1mCWIslC8fug/5dEIi7Ma1RF37PsMVDe1ROrBzPfWHU+wV69r+
         /RyA==
X-Forwarded-Encrypted: i=1; AFNElJ/tzJAlo34jfFOIikNWMaKYaqDG4RX/GVKvyb8vA+nxphcJxxlPTYbv5l7Y+zpT5Fx7iyvWUuMSVA==@kvack.org
X-Gm-Message-State: AOJu0Yw3V1MVC8vc/u97t9Ixs1b25D3vxnH1dRGhFJa1ve8vz9Q8lYce
	6J1W5sDFChAgrq1LalhpKDycHNuuN4FzOxnDW70DTTpmgI5FxFY72ZIyMLQQZYSLdrR/wm1Dbf0
	CSAhLswREhkk4gJUgKHV0IyIOEBTL+9cE8QgodxcQF8Cqg0BP8KxqX8vlXCWKeJkQQfZ9i4J9RE
	KxNWz+Ktp21a0vzOtGxQVx8CcogK4q
X-Gm-Gg: Acq92OGyEUz4kGXNOU3IStiwVAFnodF3ELuWzJZddp9r0MeORJ12dliD3Tz0uy2BZBN
	oHpU3KxvM5JQ2ZwF67tba9FFSE8IgFHvJ08Zne2tAkoMgymtUjiVqqIFQ+C9OMJGY3gXJtbi+ME
	hZRzsPfv/ZztbcNOJMqx6LYC2u0LqeOhjiqb3lZFZIXwXLwH/An+5GzJBD7L8QCb3RxS0CBErAT
	BO0FvnPFtwCtKIckg==
X-Received: by 2002:a05:6870:d0d3:b0:43b:9922:9df2 with SMTP id 586e51a60fabf-440db7cf55cmr4593198fac.21.1780565827200;
        Thu, 04 Jun 2026 02:37:07 -0700 (PDT)
X-Received: by 2002:a05:6870:d0d3:b0:43b:9922:9df2 with SMTP id
 586e51a60fabf-440db7cf55cmr4593192fac.21.1780565826858; Thu, 04 Jun 2026
 02:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de> <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org> <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org> <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
 <29bd5886-15c7-462b-8a39-f2ff25269ddf@kernel.org>
In-Reply-To: <29bd5886-15c7-462b-8a39-f2ff25269ddf@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Thu, 4 Jun 2026 02:36:55 -0700
X-Gm-Features: AVVi8CdLwF-PFxeKWBcz71YZzZxxEA0LQrJYMS3qkVqAqJLyt2EL9LT70o-g4fs
Message-ID: <CACSVV03Ez9uKw0WDm9G2HTfyXy8SLu9AFGGnY58z-GK+32DV3A@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, io-uring@vger.kernel.org,
        kasan-dev@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: KOwlHMPUeVE5qiaFZBvhfeaK_KXmLndc
X-Proofpoint-ORIG-GUID: KOwlHMPUeVE5qiaFZBvhfeaK_KXmLndc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDA5MiBTYWx0ZWRfX3W7xsyDSmp3i
 8RIgiCHm/wMr5dcrhVmIiM6JpaaIm7+CvktrKHUK1wxcxRllg3360+x+9geT71G7j1ssg5PUxjh
 /cB6oaohDdrtu68vYl7870lyxRqYJDwzMfdZQ8weC7BfW4++/CKQ1kk6ZKdgUx2E1ZAznp1ZsQO
 75kravJ1gnvF5MOWs2A0qO0rAU2POvVbx09Jt4/QoSOYAXe+hq+PSdxNodZgxqzAqDpZe0v9KDV
 VLIKdBIXQJbiBuoYm6jX/JA3iKzmIIYAAqR9C7uxKsDpHALqQ/kzg4ckDVPJucnZ/T4GWaW53Bp
 4sDRzLjhGGrMor0wNdD5bjOdJ9bo7gxFF71wMjMtKZbn7Yko4zT888q8TAU6PIInUxCFhiaEhVm
 cNG4pvUYY+M/3bd0ZycOVspDiUQNH+SAEYRQGVEgnSe2NesVTdkAhGajnPuCLPS1p/02SVbofw/
 FOr1y9ZJiy+A+Bdai4w==
X-Authority-Analysis: v=2.4 cv=POc/P/qC c=1 sm=1 tr=0 ts=6a214743 cx=c_pps
 a=zPxD6eHSjdtQ/OcAcrOFGw==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8 a=G_pyjxEXS8sYRXXvRXQA:9
 a=QEXdDO2ut3YA:10 a=y8BKWJGFn5sdPF1Y92-H:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606040092
X-Rspamd-Queue-Id: E580F1C000C
X-Stat-Signature: cmz4s6e9cibfrtupzrzd4eo3pcrjau7n
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780565828-845482
X-HE-Meta: U2FsdGVkX182x77OHqVKk0Ha+IqrN7/vooUbp8gPUpQPZwo9f08dm/akjxtf9CYRyOejEujkUC3WGLMYlL1ObGzFkmaQ2lSNIomDijZEPLQSEVDfJ9leBruHJu8Wn+0OJPPCocVqyAOxNamkBppE9Jo0hxWsBg1PKJw3Dbv8RLd/3H5xsegBJT2eN6lQrLqDuHrP/oDgx9ncC+JXjWk6fVYNyRRq0MOn5D24C0BvauVHi0i1jCb518D2aRmSfhbYOHK/pThZkJirRsOBuLbSqOhBBze6u3BXYzr2SBAF+B0SFjhFYKXfpImQC/jVNHnUQflF6+yiLnJDlyru+3dc2RvVCVU+o3OZfVpBfnyNEuHAft9x2ePObAeg0Ofc+Na2AxpHYRxZxUZ0DERLKy64uQE6QFFVgTIU2ISv/Y6HF4bucxQ+slZBWbT4uKUdh3EGiqBOt3MEjtPHLvCJ8BbYCGSFkHWd1D2gsAOqTkTORp7TivPrfEQjLy0GNPX6Uj+pyUIakqfCsg3ofsk5kh4XPKbWlnoxRu96XT5wEaCMyE3AYklh943gNcPg7TVwULSQDk2JKadli4VpNYpmSClNlJ8fzEdTHhV/BsogKqGSc0qDwMEQpIrO90dCclgiMetvGYBgLTnYiX4QI7MP3TG5wVwPNDDLOEl8zjbVoouAOs67ds/vy+4boXSyobKijhbC4bI7saipJM0uU7mnBuLelb8vX4vgq3UuEJ1B7WI152ZmIltoAFOH34GVRNXB/sI+RX68ksVWHIZAKc9cSBbX8FsLhIXRzZWi4cW5QGlJHcUeclDK28gz4Hpsg5aHjiEXNb+cylf0UtZp+w8hgC9YietPU8Fn/llNKuXYvIa2ori/KiHPuSyI4qaZaLWlDOAenOHmoWpohMQ4AQ1+kloJoOe7B6/PkqKs5Kb3lrhimkziC6ZQwNVDnRHQsMkmULCDMV7N6AB4pRJtWCUHCf7
 hKReX5zU
 S8m9h+U+vUYfQ9lz79NMAO3vlmDJz3yszGHvGN//83kCy1sgKyLmN3br8fL3zXhx6GATcFcWIvHYa4zyNi0ER2KQKw57b7jI4v9FU4m0itFl/nRxluQ0yQSBtKWSc1x6v+dozOS+tLoGKdefg7YYpZFbOq4mGnKLyxatL8OG76k4GkKoKZpn371yhywxD+sBZTSXFTA5WXYyfd/5Y9FIi+yXM2GGmwm8LrpvdS2rzEIMd+OMwPzTwD70p6hx9O/8ET0pKxtIHMA3gTCScCDc6excN4zx1pKVza2K+hAS0rKkqPvbWSfgph22xiiE8oKN0+2q03MbzN4QRSvV2Cddt8L75JQSTL1jGhgLfK2Zl/hMfnI82tBWNYA4m6QPGiNK8DR+kpQe9YbGr1tsYinbeLrvPp//pS/1wxm/tfMu8fO+n5Vuj9bdsFe4zh7JLwEZIjAGLV11FnZsRMSjmysHagwuxK3L8H7Ep3ZVbxDv/s4+D5I2bSlYpNTaSY8165NZRh9DPmASMeoY/Du6KvokN5TNWbyH+ekuQbRkvnCieflCOseejAcVgSzwZcljVtORms4eL/ljHnqhVn60e5MRGfCAh8WJExK3WU9PcyWMxmZhUHh1rGPcxjv+HG1aR6oITH9bYmDx6okU7/+ZXkTvPER9Xn70OhFTS8mH7ySQdDAiN2wxPIJpOPo2XMSTU/RkIxrbcG0uOpQcubcizln/+boFNKj3Rxj9CusetckbpXCfYYt28BuN1vV+YAwxZeOv46NhC/ZLkGZCKNZHMVjKDpmiY547w2qli/E4bR5SXfA4a5hBeBk56VCU8f7qE00S0u78hoGxPzjzWupSIdplc4RoW1ir5egNyM2oWX57+Y+tRIfi5VLiSXUJ5d8lCBbYNt/mZaIYzvR0w3AKbgTzrefF/mQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 12:35=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/4/26 09:10, Harry Yoo wrote:
> >
> >
> > On 6/4/26 1:22 AM, Vlastimil Babka (SUSE) wrote:
> >> On 6/3/26 13:13, Rob Clark wrote:
> >>> On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka=
@kernel.org> wrote:
> >>>>
> >>>> We know p->pages is NULL in this case, right? Because it was allocat=
ed by
> >>>> vm_bind_job_create() using kzalloc().
> >>>> And the job can't be reused with a leftover value?
> >>>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
> >>>> Or should we set p->pages to NULL here.
> >>>
> >>> Correct, the job is not reused.  But I suppose setting p->pages to
> >>> NULL would make things more obvious, so no objection to that.
> >>
> >> OK, did that, just in case. Thanks.
> >
> > The kvfree() -> kfree() part should probably be a separate patch
> > with Fixes: 830d68f2cb8a ("drm/msm: Fix pgtable prealloc error
> > path") and Cc: stable?
> >
> > ...as the commit landed v6.18.
>
> Hm right, but realistically, can there be so many pages necessary, that t=
he
> array to hold their pointers would be over what kmalloc() can provide?

Pretty unlikely.. IIRC kvmalloc won't fallback to vmalloc for anything
under PAGE_SIZE, so count=3D=3D512..  which is more than 10x what I've
seen in practice

BR,
-R

> >>> BR,
> >>> -R
> >>>
> >>>>> +
> >>>>>         p->pages =3D kvmalloc_objs(*p->pages, p->count);
> >>>>>         if (!p->pages)
> >>>>>                 return -ENOMEM;
> >>>>>
> >>>>>         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->coun=
t, p->pages);
> >>>>>         if (ret !=3D p->count) {
> >>>>> -               kfree(p->pages);
> >>>>> +               kvfree(p->pages);
> >>>>>                 p->pages =3D NULL;
> >>>>>                 p->count =3D ret;
> >>>>>                 return -ENOMEM;
> >
>

