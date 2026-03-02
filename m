Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCEDD58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5DA6B0089; Mon,  2 Mar 2026 03:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3537A6B008A; Mon,  2 Mar 2026 03:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2354E6B008C; Mon,  2 Mar 2026 03:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 119E16B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:55:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83BBB160ADA
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:55:01 +0000 (UTC)
X-FDA: 84500513202.15.D72E54B
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id E7C5F4000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:54:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UiXClT8S;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=djeyJqok;
	spf=pass (imf17.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772441699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDAsilwm29vpqMN7M32WikMZCz3A2rKxXxCHXUW3bm4=;
	b=iK8ZLL6FwDkDp8keS4FPD3fqXcLfxkpY4uwReii9Je460PkTjj8FzW84oogdyRwGS3kPVE
	F7Ue+IAySysZ7D0l4zw/j7XdAI9Pu87JXUgA+7QptwlM8y2fiPmjxhs/yrKGu07PunJtsL
	R/wxsrWNyx7+RI/weA8aQAktA0yzlCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772441699; a=rsa-sha256;
	cv=none;
	b=Va9nM9qRTT4O0jYQh3CQNthH8m7+agz1FsVjJ3WEP8UlvG2bTp7+KOUXNlDvO8dRaTguXL
	aTNTLI3OfwwSz0jBo1KPJPjqDlnc4LyiWIGR/Yf3KcowsHJrMfXDPOjNqktfBvnFYGphWl
	Rx3mN6k0okmYr5hyeO+BGJRh0FKohjg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=UiXClT8S;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=djeyJqok;
	spf=pass (imf17.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6227ghe62280383
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 08:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FDAsilwm29vpqMN7M32WikMZCz3A2rKxXxCHXUW3bm4=; b=UiXClT8StLpOkcSl
	GGZSemcy/y3pud38KNf984akTJRGXanuWkoBn4K0tBx1GU2xO1Rw76YMi+MCilXZ
	d7iIiFsJxK6WvdkR61nk685Mf6YvuxHIW+Xg1lHEK+7HSvJvwT25Koj0QeNEi4KN
	pHZkQDdU6npQtZadSHXg2Izeon+kxnPAQS6+0u4DuLd67gnMzPE59qRxBkpu+y2D
	4dPyx07m12llki85ccLuuKRIvmVwbarFNUGXVmyt0CcEUNPezkVuqudZfx3+1j3G
	G1rO+zQEay0LFMFPXg11Nud0CFhRvzMU7089CwF4iuO5gJYP4X+2gD6UHeN+zbMY
	fBfEXQ==
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksgrvvkt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 08:54:57 +0000 (GMT)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-46335278e7bso97492161b6e.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772441697; x=1773046497; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FDAsilwm29vpqMN7M32WikMZCz3A2rKxXxCHXUW3bm4=;
        b=djeyJqokILe0IxMtsxqcBO/hLl2W0MROgnTmPHseSDjCTHDE6ZJzruCmZ0BBWCNp3P
         PT6aYxXJhmIOVuPCFSJ7N39XSJr+su+cGj587BgCjzQJmcOsdkx20h+qoHHWAY02ni3S
         zG+TO99ifL6sME1EycuFAj+pCj7F5gN5ZDB9jR7UX9pVGyhMi/6F2guD6Siwj0ZEhCGi
         h4pjQsaDEPVu9fWD1lZBcqqayKF5GjjRyMKzM/7B30K33lKf16KBPXWDz8chdWpmIeXJ
         I8c4OwAaDNZxza+QAZohAjH0ulLR9VbRhh/eU9u5SA6eY2bqMUW8VZpocgXa2IsAFXm8
         nHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772441697; x=1773046497;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDAsilwm29vpqMN7M32WikMZCz3A2rKxXxCHXUW3bm4=;
        b=fdR5R3Ae48wmIrCrqpEuFcT9I8zy7S7cFUUlYH7rhJtymJ7N73//iuI+ekp3aqAgpn
         z/s+EIfyusPXfQfj52L9/sw1eO9cCtAaZfBlOTBE+WjHM0AqGU3/9RBA7DTqf5758ett
         i4zFqTELmnUusQ+kjoBmpAX+P2t7+/GowO/FvzA1RH3QavwoyJh5/0ZEJHh5jkmLQPMM
         KkAnrADI0atUQfMT5PWB7MxKFDDr/SmtKzFG1yfGQQj9LYPmaeuiqgdgfkQrQT6ZLdik
         lcyCP2nF2Xgj9b9NxxViYKZILMUjGoo3eMYFZ28wxj9VPkDX6PGh4nUi1kwutYk7Pj8w
         WIiA==
X-Forwarded-Encrypted: i=1; AJvYcCVy8fhlP7lLMhrtfewjjJL2rgDSIlOpGkfWlYsQGEGwutDyAzks9f9Hw4l4ANukaAYqZZBZaoxGYg==@kvack.org
X-Gm-Message-State: AOJu0YxmBOF1Sb5Yb31RBzbMG+AknhxJ0tP5eJhSBUlGrAezA/N7sZfH
	kVbPfilxhgjkfL5T5NaAS9peNE3+oB0vr5CyPQa+rJ1BhmcIjIKU8viMEzE1UtkuHSIsgvIRZcl
	wXBqD3/ql2ZpS74PSJSnIOEoZ5IN6Pao6nay1ENBbOccicTc7m7swaA==
X-Gm-Gg: ATEYQzxMU3MfBPMYr0kiykR4CPTqTMbgdBggn3GZQ+z6Cm4yPhV4ElCFcuGXJUQZ07U
	Nxh+Ts32HcD45U4YWBN5YoItgZSNBUkXmErIhOTW9LdR6IRvbASsC+XhQCE1voJWDfafVdjTHz/
	QxOHxRwrtZhBqY/yePI5qLLFXxPGS5QzANzMZkloCpuzLCtSgsBjhpY7xaHe0rwSg1sX4FdTbzx
	YFrK201cEldmsdlVgLX9xxIYBiCdhA9M5ffrKhZfIwnQ3A1TLSwWy+BCuaGxIsjKzjHLTzWraVv
	fPXrya96FL5u1Q7RJQxTPB+Unc1M89K7ACxweUJE0e+eGx+aK5JSMRJQoO4OcuG0ryREH+vXQvW
	zwfw/trGCafifLiO+JO8X+GJSaSdoK/1EB/1UTjcw1SQ335S3WG/46B2TXPf/jPPNOv/0zRfx9+
	kNsUMD
X-Received: by 2002:a05:6808:17a2:b0:43f:28bb:2f85 with SMTP id 5614622812f47-464bed089e3mr6071946b6e.8.1772441696868;
        Mon, 02 Mar 2026 00:54:56 -0800 (PST)
X-Received: by 2002:a05:6808:17a2:b0:43f:28bb:2f85 with SMTP id 5614622812f47-464bed089e3mr6071919b6e.8.1772441696393;
        Mon, 02 Mar 2026 00:54:56 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab494sm6981075b6e.8.2026.03.02.00.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 00:54:55 -0800 (PST)
Date: Mon, 2 Mar 2026 00:54:53 -0800
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Michael Kelley <mhklinux@outlook.com>
Cc: Michael Kelley <mhklinux@outlook.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "decui@microsoft.com" <decui@microsoft.com>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
        "surenb@google.com" <surenb@google.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "jackmanb@google.com" <jackmanb@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "ziy@nvidia.com" <ziy@nvidia.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
Message-ID: <aaVQXbllLVBLZCwQ@hu-ysakshit-lv.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
 <c618e7a4-42c1-4438-9bc2-9c41450a81a2@kernel.org>
 <aaUE7M9QkfnYh12e@hu-ysakshit-lv.qualcomm.com>
 <SN6PR02MB4157D37B3D254251F0135B04D47EA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
 <aaVDiwEPl5t2UPX4@hu-ysakshit-lv.qualcomm.com>
 <a0133403-8ce3-45a4-987f-96fb7421f920@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0133403-8ce3-45a4-987f-96fb7421f920@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA3NyBTYWx0ZWRfX3uZY50p2E17C
 5WoKI14GYt6X3IzH0k3w5yy3ev/gx5DgwTSy7r5OSBqz7sswHsSIuEmxJEw0LXJsxluzCEVs8dk
 1PHluHP8NUIitMVOfkU9ppd8CBcMpU7fmbf2jekk6cGfRiDKm8X6Ftf1XovJQ1MJ+F+3QcshJ6Y
 7ZlksEwWcZ0WMYzMk+A48R5Fb355A4l0Gx+xczz/P89hDrIIQKTnYtlvGMrA9piRSSHYVpH/6t4
 bv+wkaeHlyjUvSEWFhsmLSwO6IWpqoEEl5jd9uGVcErH3PGDoBd85l8kdzDkOHrpSLZbBBeEBXh
 D3bljdrf/AyNHr5dv4O8WBCKMpgG5IxybTi6vXNvKqnbPZmZs87TA5/v6UsbITvIkRQp+mS51VQ
 6qkPVx2G3Hq2AYw2TOy6sfMDYmPcqnXn2b35PMiKjoQckWOaD8u+efSpqXj+i/RbBOPdpA3mE3z
 KnU6wYBa7eeMQESgBPA==
X-Proofpoint-GUID: eXRH5FzTJS4ToH9uVA9iqFcCKtCY4g1d
X-Proofpoint-ORIG-GUID: eXRH5FzTJS4ToH9uVA9iqFcCKtCY4g1d
X-Authority-Analysis: v=2.4 cv=Zqzg6t7G c=1 sm=1 tr=0 ts=69a55061 cx=c_pps
 a=4ztaESFFfuz8Af0l9swBwA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=GS-8L0ZNGZhbl8INtmIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=TPnrazJqx2CeVZ-ItzZ-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020077
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7C5F4000B
X-Stat-Signature: dr1d5okebeqnge414std91qg791towc6
X-HE-Tag: 1772441698-46474
X-HE-Meta: U2FsdGVkX1/a/btyDZYpYTgaPz7qdIIV0sLtYs1q6rvtBvQbL3fr9Dd6UpFN0UpcXKhhUKCSSF98pLfzyE71GoCFqWVnVMUfbx2HYppsbgxPqVqnJFybl2kG/+ExBykxMhLf6chyWs5zUNmle74lbTGsiNSVcouM2IBWZ3KTyN0hxg77sabOSsFlI92SzO0UWztNmK7ISR18dZ3FXomilHAvlKYNnoT/prczZuAx8jBHiVrEZvj8WYzXIjoqzA3nwTCLNyXrzZ1f6p17d8s/2sl+jfByUPrjs99yWArvt0qduVG0UQpd58+KTNDec7Cd2rrZ581dbb3o49bjGkLFP7bC6w71yXdiILQvu2dIuVvhV/3lRs4BqLvlpmWzuZAqoDGwsPtfYNgQGU0decHivYdR+qGxFKRW7U1GQ4QwMs8+Aix0C6aF640OHFtakcZ/wtcmMcdjJ495+Q+EYvn/BZNE/zL+Neq83yXvlqOQl0SZk6GQ7N0iqVkmN4HYd45PxDHaMdmmQXBlFHf6XcXMI+4sizomcKEG2hZwbBKwG3XPM0UXppk7fuiTzyp2MZJvuUHkwZq1fkcR1XnlKZl8F3X+xkRbh+jBLT8RFxjJa18I+crVx8r/n7Fj3IfvaFqLIoH+Fmsi2MVs/PZIorgbXzcNBpmYHzaJGQ2pxZcZpC61aqfyT6VFsUB+mHc+YWCzwXiWHcuJ3MypI79rE3WnUOAgIH1YdrVmniEGm5ylzIdmw5TaeYKfRDmfwONL+B11IODGrCkTw3BNXn/5RadOfa+nCGeAlEb6wU8KqqoCThfBJgmp8lUd/LA0SIykvrMRP6lO++/jEkqZZqu0FQ6ClJQfRcRNqmL8QZxAOROgbhzDT1NO7ebj6JA/fCZ+asa9dzuqlkz/rE/lYSCD5+D98Y8+jOYYelssEHQi/1fh55S2ZTfyZk327C8qdt6p7OXoW/y2AEARyhoUiOWuz1b
 x4Ryu9ip
 ONMnhM+ztJ8gAN3dhy/euWgYNdBzLdAOaJBTOo7zQfxj3unkMZ6A3ydVm0MzCcXPTTDZBWlrYAhfbvbuS4F4nCO7/DYPNcx7+b2WnG+uhAgx4OeilXZPPVyRlearl+LqKIq15nCyFfgxqaTNbIwMym0aLotOcQsxv7UrV/EPXtEDF3zngsP28k/otASFrHUj6IulZLvtRCWrRSkxwsPI0dBmkNujQaAtmFfWYIixSdu/g4E6Fy0Rr80wR2srBQ20m1zaAlyEGPhnqQ11lDgWgA2LZURN4FiOkUsX0b7Rj4ykS5TZakN900Rf+A1hLp7R8KmSsM9R/kdhZDKJfWKkEClJyI70I9Gn3u7FsMgsyTjGd58AAOULPCMMloO4VMe3nFdLD0mCoVRPxNYVTr89NKnP7jMCQmsQRaCPJV1rIIfUtHsgtZmdHbxePuSVf2qN4LJ9pdFhbKpdptr+yMyg/rQQlNaKGL9UVtftVF5PYnGeFbs56VZOEZIGV40NSxmb2XKCVB4g5h2YuSEMFNxPwECQca7ZZFlnNVQ/31IonQkTIwbBYMCaYxKKjnJ++PEHlo2J0hV//UDhgwSDFv8Q9GuhZGgxMGc9oPWBPqfE2GIg1w1AbHEoGb84loHYJ5Ajooxek/Ab7LXveE6F1X46598C8H2VbeMR8dhXS8dXaBvu5DSzk4oS4gKB6hjvNgTGpJuCD0mzE4NaJEVHkFBAPYniIMORM1JtqvD6banWOkoq0tgEjjArwiHrl5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:09:13AM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 09:00, Yuvraj Sakshith wrote:
> > On Mon, Mar 02, 2026 at 08:42:57AM +0100, David Hildenbrand (Arm) wrote:
> >> On 3/2/26 06:25, Michael Kelley wrote:
> >>> From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com> Sent: Sunday, March 1, 2026 7:33 PM
> >>>
> >>> I don't think what you propose is correct. The purpose of testing
> >>> page_reporting_order for -1 is to see if a page reporting order has
> >>> been specified on the kernel boot line. If it has been specified, then
> >>> the page reporting order specified in the call to page_reporting_register()
> >>> [either a specific value or the default] is ignored and the kernel boot
> >>> line value prevails. But if page_reporting_order is -1 here, then
> >>> no kernel boot line value was specified, and the value passed to
> >>> page_reporting_register() should prevail.
> >>>
> >>> With this in mind, substituting PAGE_REPORTING_DEFAULT_ORDER
> >>> for the -1 in the test doesn’t exactly make sense to me. The -1 in the
> >>> test doesn't have quite the same meaning as the -1 for
> >>> PAGE_REPORTING_DEFAULT_ORDER. You could even use -2 for
> >>> the initial value of page_reporting_order, and here in the test, in
> >>> order to make that distinction obvious. Or use a separate symbolic
> >>> name like PAGE_REPORTING_ORDER_NOT_SET.
> >>
> > Option 1:
> > 
> > if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
> >         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
> >                 && prdev->order <= MAX_PAGE_ORDER) {
> >                 page_reporting_order = prdev->order;
> >         } else {
> >                 page_reporting_order = pageblock_order;
> >         }
> > }
> > 
> > Option 2:
> > 
> > if (page_reporting_order == PAGE_REPORTING_ORDER_NOT_SET) {
> >         if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
> >                 && prdev->order <= MAX_PAGE_ORDER) {
> >                 page_reporting_order = prdev->order;
> >         } else {
> >                 page_reporting_order = pageblock_order;
> >         }
> > }
> > 
> > 
> >> I don't really see a difference between "PAGE_REPORTING_DEFAULT_ORDER"
> >> and "PAGE_REPORTING_ORDER_NOT_SET" that would warrant a split and adding
> >> confusion for the page-reporting drivers.
> >>
> >> In both cases, we want "no special requirement, just use the default".
> >> Maybe we can use a better name to express that.
> > 
> > Agreed.
> > 
> > If we were to read this code without context, wouldn't it be confusing as to
> > why PAGE_REPORTING_DEFAULT_ORDER is being checked in the first place?
> 
> I proposed in one of the last mail that
> "PAGE_REPORTING_USE_DEFAULT_ORDER" could be clearer, stating that it's
> not really an order just yet. Maybe just using
> PAGE_REPORTING_ORDER_UNSET might be clearer.
> 
Ok
> > 
> > Option 1 checks if page_reporting_order is equal to PAGE_REPORTING_DEFAULT_ORDER
> > and then immediately checks if its not equal to it. Which is a bit confusing..
> 
> 
> Because it's wrong? :) We're not supposed to check page_reporting_order
> a second time. Assume we
> s/PAGE_REPORTING_ORDER/PAGE_REPORTING_ORDER_UNSET/ and actually check
> prdev->order:
Oops, typo :) I meant prdev->order.
> 
> if (page_reporting_order == PAGE_REPORTING_ORDER_UNSET) {
> 	if (prdev->order != PAGE_REPORTING_ORDER_UNSET &&
> 	    prdev->order <= MAX_PAGE_ORDER) {
> 		page_reporting_order = prdev->order;
> 	} else {
> 		page_reporting_order = pageblock_order;
> 	}
> }
> 
Great. Much more clearer on page_reporting.c 's end. 

Don't you think on the driver's end:

prdev->order = PAGE_REPORTING_USE_DEFAULT; looks clearer? As compared to:
prdev->order = PAGE_REPORTING_ORDER_UNSET; ?

I'm thinking, why would a driver worry about page_reporting_order being set/unset?

But yes, too many flags...  


Thanks,
Yuvraj

