Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A239AFC5901
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124BF6B008A; Thu, 26 Feb 2026 02:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1136B008C; Thu, 26 Feb 2026 02:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E5C6B0092; Thu, 26 Feb 2026 02:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCDA26B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9456313BEE7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:34 +0000 (UTC)
X-FDA: 84485712108.02.AD2306D
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C2544000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=C6sMo5Ud;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DF7yccdK;
	spf=pass (imf27.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKSAahOYvACBfhspLoB+yDM9PsACZqr7CJChzc1vka0=;
	b=e7eDyqoTJAkiHY0qJjWnCgwCcYndBuxJaP9s2qVT0RiqNbloRnuMXAgAH6v0zO403XB+Ty
	itjbBXrgFHBSFcn9+l1tRW6JRKnGA5FSgKtPsu7CwIunJVSnxLId3kf6p79e/DXC1hC+1x
	g5PhnfpHMVc26KlYtzne4qRU27Nc4bo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089292; a=rsa-sha256;
	cv=none;
	b=gg+HF+6N4H7QGzrjLTJ8ZPQ+r8Kk3oygzC2+zP4bkeA/WiWdULqTXiui1xbkJEqF4cRj5v
	aelH+PiWxzmhldNsu+Ppw77/5LG0XyBHZkgLqYQAPV9Wfkxzqwr5/Ktshz0OoSzPM20ryI
	NIomQ+q4BvK1IJObboG/M5GtvBMMBQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=C6sMo5Ud;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=DF7yccdK;
	spf=pass (imf27.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4VKuf3721809
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=yKSAahOYvAC
	BfhspLoB+yDM9PsACZqr7CJChzc1vka0=; b=C6sMo5UdFEY8ev0ii8sDTQWBAp/
	Tp/oPfunqK42/Ax8V/s5ZCt0NzltP7tYJMak0mhb9O0x4k+Db+nvw++MFjlN2koD
	m6jWyTWaG5+FJIG9Xp9bXpbKfv7iJa6JhrwMoghwxJfPqeP0uxIi2H60/FVBH3uF
	x8c5KBVhevXytXExn5k/0NFMagIioZK4pQ2maCwP8ySN/K161qUDbHFUPFZzTNAo
	QypGflLzQKPNKkktw2VYtrKE6qOLg5Cm+HEi42++X1KrXalWePpDO9isiXkGSmOL
	7ywD5n5h62s/QRzgAqyInXRErUS/30BFm4JAYG0Xppl7cC8E6D1f5EvW6sA==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chyvf38sd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:31 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-678f3fef828so5161048eaf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772089291; x=1772694091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKSAahOYvACBfhspLoB+yDM9PsACZqr7CJChzc1vka0=;
        b=DF7yccdK7e5xMT85lhDt1bv7D3pMowBHvlf0tSw2X3sGyAbEpAIDEEnBbc2SHLI0qB
         XOiQXqThLsl34faP77U3bZqFjmeIpLl9+B3Tu5ZK/uRcLkPGYhaUCrjlCXyZO9FXrdia
         bEodmibkydGIFWckzPjYoYP9wl74Nl8o6CU9HGwGNH3H64X2CFOl1AcwMJsTFHKAWcJ1
         aYjL15tdyfS8bllxJxnYA9+xNqhWds/QpN6xgbDN7Mh4V9ZWSxaGHqL9mesCNsNjuOsq
         QSE+P42kiu9ZpyraS36wyvF+kt0wFPCstWxxbqh/pxp7OQ/hKud+Z0+/kxyKRWlC2hPX
         s3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089291; x=1772694091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yKSAahOYvACBfhspLoB+yDM9PsACZqr7CJChzc1vka0=;
        b=rJpK5t6hdxUzuREAcfedgarbSG7nBwRgbcGNl48I3BU+SeiYt7AnjkQx5PMDVdNkXi
         R0Q+fbYTUM5secvL4KisxKp4j1yndNnRZ8yIxH8OwFHmAMlA58klBrCMRSQolg8Y3zxx
         rMSL+t8G5geThA1Tq9kRdQT4uHbkG7C3fva3sYnmv+urUJ+VhhbY8wrNgs/LSApw/cya
         aSJ2Lt5AVv/AcvuSetSHWqBTY9JviciHqIv/OEABRTf+Yt/lM33fRH4Qx7CSXM4DqcnB
         1jnyGdzwf6Bf5ARoBbGJMT1ymMQ8wGCy1zF6APmgr3FAm+Bh40AZIAswkwUIiOfKeR2V
         7FuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlIQjOb2PMfA5Chelb21IUi1UyU7KQ5fYR1RQvmz27lXh7ixTR5oU69Ic3175GYSDpq3swPdMn3A==@kvack.org
X-Gm-Message-State: AOJu0YzhKrBbIzoa48Dt1h+H7igv5SoA97kPN+vJD6efXTM6PkST1JZS
	yYDgqxMHLiEMfASM1e1awA6uPNut/zdIuDLnADcP7DguZ/xCOHOPltdBF3frprIgyB6G3d2C7SM
	c/0DsVbHuH04W9ZCIOiUMo7x11Mv+b3ZZ3T4CnOTG0elMDn4eUMk8zQ==
X-Gm-Gg: ATEYQzwUFBhdAk1peGTBRetiuP1JAI7v/qvDNTITH3LOCz85G84yA9HqE4c/8YYDwUS
	0crcdDUNZe8UxmGs1WWVzQiWvmtETAK8Q470sEE08AOofaK03VItPA2LH2rNsGTL4tykuFCwiQX
	Ecb0tOenFffBoVXoeV5Vdqut2wMetG9SSvgBJ54X5MmxxDYNiexdQwz+j8igSbEDJ3JN4dLLGkB
	h8JV0w4Comaq8IA7S2tZxrRKwxX8IOs+5KhK1m7hlP9FLF+XiyvzgTuZxm+GiTcnkviuYujxJaT
	Ojp58nYL8r16yx41RsGw9FKw08HCqJMXGPVFxCteXdTblYo6FoF1Jh/c/vZ5wHBNhrW4uxCMGK6
	Z1E9G/unOa/P1zj1iMakh3k58LKkrbjbu9LdKZNXv9cK+NwPo4M/0m26Wf3NbX/ek+oZk/+zUXm
	tPgTU3
X-Received: by 2002:a05:6820:6ac1:b0:679:f37c:f995 with SMTP id 006d021491bc7-679f3d79437mr569675eaf.37.1772089290307;
        Wed, 25 Feb 2026 23:01:30 -0800 (PST)
X-Received: by 2002:a05:6820:6ac1:b0:679:f37c:f995 with SMTP id 006d021491bc7-679f3d79437mr569358eaf.37.1772089289794;
        Wed, 25 Feb 2026 23:01:29 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm1013246eaf.7.2026.02.25.23.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:01:29 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mm/page_reporting: Allow zero page_reporting_order
Date: Wed, 25 Feb 2026 23:01:23 -0800
Message-Id: <20260226070125.3732265-2-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: HoBo85zhxN62nbUVSx3kQ98jtETOYi3G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MSBTYWx0ZWRfX5mFktcfLec9g
 +AybFGjpI/hWlZYrZG5SsKXo9kkXhI4iNWo7P+yCDPzyEnm6DigfS/jisuZKdGC7MG3mJWJpQic
 sxy7rAJKQ5LdO+9t15H7W/bo+PyR1vllvE+TDrvmTiqum27+zAkfyykCtfIkWE4MOzh0jNSzFyN
 xGW84H5womw3wmrVmJKylhnX9OD1MzHuyUCgXjUqorBhtuU2Cgmr3kj+/nJtwYITQjgbUjJyZ1T
 lR9reqvfNatAJn4D0GHlSusXTImEJ8y4kuLTY/TUbfrtJWWBA6FYBu6a4LhJDJrc+TONP9GR0K6
 HVYAWS2Jb/5Q3cIl2FghOKsgapudh5sP+Si6OoDQnA/PAOIaHPf8XB+V21j8VS00NHvJIgvMW0K
 YKqhlDAIUIZniYzlpN7Ev6KloOrHFePSljOT3FHXYnyClwCV7+zpibhFoTAX0Agr8c60gVDH4Oc
 gLT6aNQxW6T5JWKj9ZQ==
X-Proofpoint-GUID: HoBo85zhxN62nbUVSx3kQ98jtETOYi3G
X-Authority-Analysis: v=2.4 cv=dZWNHHXe c=1 sm=1 tr=0 ts=699fefcb cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=oYu5RVeIbCLf98ibfWoA:9 a=k4UEASGLJojhI9HsvVT1:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 suspectscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602260061
X-Rspamd-Server: rspam09
X-Stat-Signature: n7xt5xn1jsd5uwgpjgqwj6ayfqht5pke
X-Rspamd-Queue-Id: 4C2544000B
X-Rspam-User: 
X-HE-Tag: 1772089292-170708
X-HE-Meta: U2FsdGVkX1/1+bp+bj77p4VAeR4v77WlZDJUvql5mpv6UyybCwO6qKZBpS9zYEPyy3kN4PhJwlBlkBnJAjXOYAX/VY20WzGZfNYH/cbSYCJcv6rRGN0Yr1md5siYQxGCECSf8X9bZe6uteDlJl+HqZ7xrhXszMS3s++wPtW99J3D/mrTea+N0sH5mKTCsQNVg+eknKXqpAp4K/3H/fupxANgiqCxHLkZJr0rVBNF2hLFGxcr5Kj5rhmaVx9kdHkwlLla0l668hhmrUWEXBNquGT7EQHZRWEgSGOzUVQNtPl44tTEfwehK3rXMNIp1c/svGuE3Pf6A76U1aLhMYlrLlV6IBuIQV/TMEvbcMaULooBpbiilyfoSBVNrlLZmSaFp2E6box4TN1hm/RX/irZ1WSDRjhXEIsfKxYPa/a4/XzjPYGsLnLUHLUWYH0NEgk1Ou9ufGuEzMPsaY2MG0ENZWdkWB1zpse9We8I2yej4dGSdLXqVZYPGjeW50KcXayR2KEXLm2H5GMzdGi/dmkpmmcCTLI5SrLSO1y047OmXZcdr0fxoBkomRbMH9BvSjl4FvxyhscWb9+xKPTm3tSdrCgQIE9e1LIzsbTXyfSb8Etp5FDke2NouI+m2Do6F0WOYhpzTgGi/PiIp9SF3YU5ccnRtdoIRzKEvDUAA67AH46CduLXqAQjZe5c0oBesLWZx9/PABdRiXnoC6mi1RelRtcOJ2pQtuXKwpFI5GnrKE8qjuW7yc+XPdjKzjvV/pKglxSvJJs0wNOHbzcpMb9QHA4pLn9Z8CCFlCpl2zG2aejY/fYVgqN5m4g5qgdxMFK995wxzXWnv/OmF0DSqeMLkq12rl/GI7JpBS3nBxro6nVk5Na3ZaNEFDAr4+U6i4qapmskV9u1/ZiI28YQsMks0QkXm7PVzt9I8XetgJt26qyxZ751uYVgY6k3q4A5prjjkViS3N0dNQnNh1hhfCs
 tSuGmb7p
 kgnvCE9fFiqptR+amgvMeaT7WA4QmixDw0XC212ugsjA0E1WihpycnhcoQ7z8LxIy4DXd/O0sZayhSMjauvIiddm2bP431YjqQFtALUhrHULzhnfvJTWHYrsSSBZmgf1M+QYo85Z5TCBopB8nvX1oUmL9qM93ueJXbSiEhOfkUdk2fopAMr30pRVybEq4BuNku20DPPtmo9I1fgD/mWdrkQ/o4cTDIVdOQFe/JSCPT+KmyVLJnJAKMOuTGmpdHL+DtYb1D4tm+cs++RdqQRki3of92s7/mwS5ZZVZGG0tt6QIf3x1VQYthbz1gO9p3ksGQXIw/H1rwX0cbAdvMx3uwy/6AkJIAwlOIOWeKYYoYwuoH2P4o/YVb8vR2D7xsbRXkWC9bLufAfBRnLlVEfCDDQ9zkxa7+8+c5GlDGrdjhTurJ+hpIDyi/OEg5tvakbUZ7v/xr5+bIHibuxU9Xv3pWCJNvovNyb6scgA5/hECV1Ux7VbCga5ACJxyjDDyQqkrKppbBeayiKsEW4+fEKbQWQoxKMJGZyKWOM42i2zoO9+pjmprBpcg1761qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some drivers might require page sized chunks to be
reported. This patch allows registering a driver with
order as  zero.

Example use case: virtio-balloon driver running on a
guest with very small memory. After some time has passed,
the guest might not be able to find a chunk of 8KB.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 mm/page_reporting.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e4c428e61..fd7c5f0de 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -370,7 +370,7 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	 */
 
 	if (page_reporting_order == -1) {
-		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
+		if (prdev->order >= 0 && prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
-- 
2.34.1


