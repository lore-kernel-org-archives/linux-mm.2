Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08378C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 22:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F736B0088; Tue, 15 Sep 2026 18:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A366B008C; Tue, 15 Sep 2026 18:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7546B0092; Tue, 15 Sep 2026 18:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD0B96B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:21:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 663E71C2962
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:21:35 +0000 (UTC)
X-FDA: 85217419350.22.AB82A2F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id B650980003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:21:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="IV /k2TQ";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Q0neUfMh;
	spf=pass (imf02.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789510893;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnJAniUUz5UpK0eAzqlFlmnyP+PG3E6KxIttKsrRd1w=;
	b=MqF22wo9RVhk/scPII1iXOuVsH/r3lMG0mNy57d7sfEtdWDitN2VNQG0N8VxjeQi2EowYb
	yzZl5soVhMfR6Rff80ERZZuUcsfnZZ5GiIAvK821U9xbCgiMNihTpyMitGPTjyBf+YScC0
	UWsKgf7djRNMdcAaCiT2/41WxMAprSo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="IV /k2TQ";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Q0neUfMh;
	spf=pass (imf02.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789510893;
	b=DFreFA1uKuKEF4XcXuXvkfHOFVrWuJRbEB+PzPQEUyePYn9O8qffKIJVgYxAq/1YmGL97X
	d29Ai1ke+C4vKcpS3zvROuO0qzGUYuiPgJhKjIKuSBYqmVHSHXV5Ti0eXXk9lXoJo72pgE
	YXQuk6CISZJ0drmp/J6aWlIaihR6Rog=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FLYp7l619836
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=hnJAniUUz5UpK0eAzqlFlmnyP+PG3E6KxIttKsrRd1w=; b=IV
	/k2TQjkUrsTGpshqW8f1AkLpzgE6WqJLnJXyVNHKYz8mozA+vLQbIOpShvI99Nvk
	BGk11nj45xZQZMebNdo7NiYw/EO7W5wcvHVc8eAkRKtGrNMclkKkbe3unomYvdUd
	vFaT1byqggr1zubtRjDzuTG9pECEQdOzFAiv4kdIU3d7CXM0IsQ27dhrP8NvQBkU
	TlOdMgPnM8h4FF25SXM2n03VFD94RLvjnLlaGSHHxie20ptztZeSDX3B4EelrzMT
	n1DLEJiB1mKEp0dVH3Si7JCiMZpC8ZcIigaByfbQDV2F2ANWVcL1rru5kNRyAlZ9
	ag1DWjYpUlLQQuGalXdA==
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gq2y2kj75-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:21:31 +0000 (GMT)
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-45e83fd0663so6244515fac.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789510891; cv=none;
        d=google.com; s=arc-20260327;
        b=I98lK+23H3JMpFrBH04qEpMvT11oGVi0V3MgPT2KiuolDPlHx0/BZcAfV2wdGr6dto
         TmF/brImUe8m+95OXbkD6AYPIZ2MSO//3+ig6+AqwPBsE0KGqMQbAmeA5eGLVGGae29J
         5griNI3HCRxc6FFRFgOmedBQTdKLM9CvTwJHgnpEbtQ5rRhHVKfSqW888cArBK5iEOKw
         RxCZqTS6I7qOnGkVRsUHdlzIxVLupL2QxL9zUvpIE9kaPxOdqfUu1o9Aj15pi2liFYPq
         /jdQw1x/HSyTiaYV/u2SFDDJEdIiI4wzhaoHGybHIXTbE54ZLR3dVsQOtEYtPGska8bI
         LrYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=hnJAniUUz5UpK0eAzqlFlmnyP+PG3E6KxIttKsrRd1w=;
        fh=woE6QNjjm/DHsIJcTo5UWQI5wsr4oShj0FsjTCndakI=;
        b=S7ERqFFw0AzSB1xc3ffrOktJHwm+zIQLcLKylAt91cgCZeBuiybrHf0i57hnTF3Jwb
         wV/KlZMO0//v5vHhQHaFmt6f9xZTFhbH9kIJk3cv557C8ts7rgqfCxRMX8V+0ibSn7QI
         MtCTDC6w4PHGML4r/nQ+OqqBc3wVr31ifyNldSllJP6izPmaNAxvQRmcruMMHoEgXiJD
         uX0BRggbEVmn7r9wXyD3HsZbhIM31Oh8r6Db4EEjI0qMpDncizg8ilg8NuWkGc9Fi3V0
         A5uQWcBKwogdFnQhn2supCw7jmLxme9EuVKE0dEqvMMgevQkRYXU+lWmGGRwTS58jAaZ
         wjJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789510891; x=1790115691; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hnJAniUUz5UpK0eAzqlFlmnyP+PG3E6KxIttKsrRd1w=;
        b=Q0neUfMh2v2rGApnhZsSb9KI/OWa499M+Iz3rdkhbBpc/v3lwrvKf215xQc6Qw/Npm
         FscjAiSepcj1vdaTz4qLXAsXSoVP9skY0zAYmR6wUtxkKE379kNXlqmXkns1u6DPePCl
         iWZaOAYfTqu5oF/GHHv6sMRFjcjplXyKalMMAjMaaPg3dR6yeBxUXHaX4pSC8q/wP0EJ
         vudwei94hMutEkS1lXuU54iwRQz41rZGd5WVNEvqK7vlYJwOR5cjeocWPJQa9llDVJQ5
         Pl+VOeYINw4+HCKxJxrKhTfVmDUnNR9dnCv7dKZm4CBpXLoCnoiTMO/4HJlkhPoUSq28
         tuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789510891; x=1790115691;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hnJAniUUz5UpK0eAzqlFlmnyP+PG3E6KxIttKsrRd1w=;
        b=jK7qPiURXQkwQTVIO24whU7QErMm5VYpb8tv/IqmHF/UXO7pXfzGgUnNGXRd/4MlHU
         zw9LZC2fzI65oUN9+byehPqJstwuozSBw1g1Zt2sILmpZOwhxuxuLLUNXVsonhiZOpIJ
         ybXRaXD6sedYwb2mYLcCGM38X02Me1yKOVlrFfpR494pC46mm6dwQpRbcBT59Ch3wykM
         zFIaHzQO51CUtdfSROD7IZd54lldkIIevqfd3a5xWzoKZlbmmF7Z5gA5IyEYjctqDmUc
         DcOicv46Cf1Q2NUPIPwOy6rA3rw8wgyM1F5CnOxUyHpc5FmqKQQktMpsBxCh0olYhQh0
         y/lA==
X-Forwarded-Encrypted: i=1; AKwUvByH2A03mgsXbxBrLsgqYEZeNZCLtuB7Y7PHVAEizjdmRFsn71xQG/PpRaIZ0EiXwhjNpHGBjIq+0Q==@kvack.org
X-Gm-Message-State: AFuF++l5DgWZFsKPcQ1fdgC8yTYBjdwdaFP3bJQTHTwZ7U4Z1utqVOHH
	vmHbXqAorh27yp4WfWSZVHM7LuZQ6uWD43RP64D0GZHSOhvQP0yye84pT4ekJoD1r0ivjiwjWem
	HXvERiL55N9sM4zSSuO3L74KHTq3EQnyJgYEf96qlTX/Gxq2+vN3nyZlHnFWS5IZMnKPAdep+S2
	YSqUcian6MTDrDlnNH//VknGrkQU8P
X-Gm-Gg: AYBFou1htge4QS//XGLqB4oniXw/ghjPYPQM6zSbQI4L+FWmgI4ZFaTS9QHq/SbnFEJ
	gLESWg2Ysb5DR7C3opcPL4m281/DjxO+D1ueNPO3EiTrUa15e0M6CriV5IHWWml27AH7hE90twV
	lZ4V4KVWPWN2mkRyFijb8NmhRGoGuUbqwQLAcdltZ9hKAOLmopZTx/RJqT
X-Received: by 2002:a05:6870:30f:b0:45e:2de4:95f1 with SMTP id 586e51a60fabf-4847584c51dmr189758fac.2.1789510890852;
        Tue, 15 Sep 2026 15:21:30 -0700 (PDT)
X-Received: by 2002:a05:6870:30f:b0:45e:2de4:95f1 with SMTP id
 586e51a60fabf-4847584c51dmr189724fac.2.1789510890430; Tue, 15 Sep 2026
 15:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
In-Reply-To: <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Tue, 15 Sep 2026 15:21:18 -0700
X-Gm-Features: AcwNN1UxxSxAxz0XPK7niSod0Tx_HsUs-C3mKdcqDSaFkh659BGkCorPygYZGHE
Message-ID: <CACSVV028AdnTYa6OKDeoJYCau58uTkKMgEdqTn7crNSV8QZxOA@mail.gmail.com>
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        David Airlie <airlied@redhat.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, kexec@lists.infradead.org,
        linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: KFeM4ixX0sPJTs5xUx-4JcIBOr9aepK7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMyNiBTYWx0ZWRfX0dOy6JoBfjGF
 mrRfLnKJJEQA72eTZ1/dHSS7w+Wu6XXSjdZs69DyMASuLE0YCFfKx/ibnR48NJC3Ax6ito22zEh
 8IFFr4/IzmCJZLxltyS6IHPzpBEqpbH3o2uT/d2Lr4MyKyvloaGgxwPXrjc2lHGW19c0HqgyaWu
 OXzQ7sSC6PgsVTUhg+ymllYXHQyWfVipL4zEFXoIxZacHYRCrvKJA9VVtWyB5wgVZfmsxX0WAA2
 UQlFwSltcElrHgjzysn2Zf7qUcJi2lMa0qOhkHeQ73cVkdJvc/pixosWA9TYt3hbSlufqe5xo46
 MMltg9mskJ75uvwNhHE3B4S8kP4FVqEg5foIHfJ+UKxWZN/OfKKxdhHtvK1I0C2I1eKek3JcnCt
 Mh1V6l9fMYXR0zNgPR1wldO+bByOjnwMqXFdKBCla3eFui0h8FmW6l3KUAaV1+J+NRPxmQbTGXh
 XHCuyPEd07QrsTZK71A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMyNiBTYWx0ZWRfX8FXIe8S1E+V0
 qSXnLgPVpIPIimHdRDmskfWdNk5rtXaIw7eJ5pufkXlObRmD4g34/Q0vdnzoH5pDJcKcf3DYp6l
 yOJ5EP2S2MqW6SaWLpMe2AUnJD1rLa0=
X-Proofpoint-GUID: KFeM4ixX0sPJTs5xUx-4JcIBOr9aepK7
X-Authority-Analysis: v=2.4 cv=IcISymqa c=1 sm=1 tr=0 ts=6aa9c4eb cx=c_pps
 a=Z3eh007fzM5o9awBa1HkYQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8
 a=2Rxv5svHm-zNKBYa0PsA:9 a=QEXdDO2ut3YA:10 a=eBU8X_Hb5SQ8N-bgNfv4:22
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150326
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B650980003
X-Stat-Signature: 3zjea9147x88rqk1wdm3nj6p8q3dfg5d
X-Rspam-User: 
X-HE-Tag: 1789510892-165010
X-HE-Meta: U2FsdGVkX18U+1PuCMSK0hgXfNiWutqGOxVMVakFDaSZ+Ssu8mli6h017mD8CRadsvD2gCdA/Q78M+uaIHtLb1MfgYO8dWsX2nDwNNPxwSX0PczYXY0OL828lysyuj12UY7GVfbCsQQOIljhSyVhLO8O/AKTYC8k8hK71yJ2YHdqbKDz/e1jH4M+fD0u2ZT+pIKY8P9gvFhwB/hOjnl3hJ1PoWs7tWv0RbTUad9/33J2CoedFzVv+6hGQspDL09Xdcz3MsBIqvGIZdiCh+Em3tq9doOWHAdclKUqvclKb1QGwDqxssk0swpqHP1NTUpIkEIbxHqXjpsNof6ewnrXqTYx6eYhrzX9UozsNCCmeMhF0pchlCNs8eMM55rJ+enUl00lXXSgVuON5bsS7d8f9xQs9h5PqZ4R5qBXCi5V2RKDYDcOQt6/HIMAsqSPQINYE9vMFVuyAehRslLOktzs05/0puErztBv6MpEEGoHhM27H/0KzrZP+6CT1eMwfIE4CncEAdAfqJpPqHx4jXsGZdkRysJ8jAHSvSmLW4qSzxZCuQ3DT/d3bFy3XU0wtH7Hv67+qz0kIS4mDBK+wizVh75pyQbmBUMAigHPQ/Rvz5yXSzZ6qXS5WYI6/+9Yx/H7fXB5tH1kLKASAeqG2C3ERCgmAzuSeSGltbPpoyY9kKew/1GIU31P6E8E0E8qDcp5BNK4H4Nr1pM9Q2kd3pYkXm44Nw9ZgpDdkD0yRydyd+xz9aqxKLlEm0Ww795hXclZPL8xe8OS0sW+oFC3k3oyQfcbbIE22bFGT7XDRl+2aki2JlAyw5dicDctuH8UoYq5vnsdoXfqzF2+2icRIGDD/e1O+l3MKYGmhZzwX37f+4zSKVFYlhd23BNGyZlS3iIUpS2m/4KZ+iezdWzq3TaTfS+hUySmzv9tznzZ4J661+IuLOjQLV3uexolTPbYn4EEIjw8QNxFEacFGHJV1Sn
 s/UoWQ30
 CbFKhOUay/bn8Iqo2SxFt7y+QoRDYSjjvLYRyczJXu28C0ENd6md2YhrdbDcVTVXixtRF/PjZth8zjq+rRVJPqNBxV6gLbnglldbY49gE6AflAP37HSjk9m8gdu/tMO5OtvJ5bU9Lu15+YJG/ZYN7BJNiKPlO9soK/gbCVR6N9CCIrzLOTWZrY/8k9sqLBeS9juxwDCn3JlRUnFGjaI6XATY6ZxqkFIka3U19I2IJngfQ892LHmYnbYz3/6WS5s1llYozXbW6zau+DjqhD8H7guji67nk6+aprBzJKcDXIKWnB+cRcxBpk5omz+Y7p4tVSxuwuI/Yrc5bun1EarIkbd8sYF6CS/hnAWGyVoCQhkXk5slDPOflbIsBAcLvkSve4zyUzPB33qTwwZh///CzuP3s/EUej/iJ6PvQiuil6Aa9n6xBVzidLcf8+MfT3I1hnYg1qlr2LDUEQ9d5sW2RY3ADIuo39OKTtVHH0RXOrE/FqmDGNdrJ9bYd+12lV7dMe/RV7duo7za/lzAtNdjr7QND3qP7fZctbYrjyabxUq59V4DN56AAnycXkbJCIoEMBuDt8vWsWOhdpkgJmS1CXkGLZO2jA2U3JcBXePWXcFbxj7doILaJ9bNZ7xGU6/EjRFRO7nOgk5XSKcL3wYoJkZBRknDQlgIrTEWIv6SHiKhmliPsrPOWljAhDYnrzHgpfl8oQarK2F7oZicyIAkEuQvVHv3zafYwC0WrfyYmQCtURIB/J4X2NUuxP7DlPw8lv3IwdO6MJO6M3fKKh8DErTr1UXY08S6usXq+uyoEGTV0hB8s6TNjA7x8cP2tRKi3ORNA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 9:02=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 15 Sept 2026 at 04:31, Christian Brauner <brauner@kernel.org> wro=
te:
> >
> > TL;DR, this lets arch code handle fd install and cleanup. fd_prepare()
> > allocates a descriptor like get_unused_fd_flags() does and records it i=
n
> > a slot on the task. fd_stage() attaches the file to that slot and
> > returns the number.
>
> Honestly, I am *not* a fan. At all.
>
> I think this adds complexity rather than removing it.
>
> The diffstat tells a story:
>
> >  106 files changed, 962 insertions(+), 861 deletions(-)
>
> in how this adds a hundred lines more than it deletes.
>
> But to make things worse, it adds them in bad places: low-level
> architecture assembly code.
>
> Those extra lines are *not* making complicated code simpler. Quite the
> reverse. They are taking fairly straightforward "just deal with errors
> with normal cleanup in the place where it makes sense" and makes the
> *straightforward* case simpler, while making the big picture more
> complicated and subtle, and adding new code to places that are not
> simple and just blindly do somethign that makes no sense in that
> context.

With fd's it is more than just about error rollback.. exposing an fd
to userspace mid-way thru an ioctl is an easy security bug to write..

OTOH, "just use FD_PREPARE() / fd_publish()"..

BR,
-R

