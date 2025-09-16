Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA7ACAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 07:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2D48E000D; Tue, 16 Sep 2025 03:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A4C8E0001; Tue, 16 Sep 2025 03:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90668E000D; Tue, 16 Sep 2025 03:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1A648E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:49:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2324DC08CE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:49:46 +0000 (UTC)
X-FDA: 83894339172.12.2F1897D
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF916180003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:49:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=I7buFBUL;
	spf=pass (imf24.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758008983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RD+ta9axnzkY+q3MqSd9MuBTTuCWROaoN5jRYETLo/A=;
	b=WOEibj4b2K4WFlzyazkh4uQNDNxR0ZoY4b880lX7RxCDYJBYo9yGn535MyFXmRenj4/We1
	UHoipSrSzaXil+KnPq+2M1NKH5mplWueqrcm+/u9z14wKftzdzP5uuPXUwBo+FWW6KEuOZ
	HkKYOL2MdMGsnfsMaBTN0I9PJjtUzdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758008983; a=rsa-sha256;
	cv=none;
	b=JGbF5YjjFn19wl+dBC6mOKjaY0O3fjHMbwLx0cxTwxX73dP3hcwYksxfbPrjVurfJoS6Mr
	Bl50kDxh8zoSZXxPLkRvAnTT2tOm9W6BmIdAsPNDDOFqjEXK9LbFB7rqd+p+4ukvVoA9WK
	vlqM197wFEOE4vllNuk/yf95BIzyN2U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=I7buFBUL;
	spf=pass (imf24.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G3pefk013763
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=RD+ta9axnzkY+q3MqSd9MuBT
	TuCWROaoN5jRYETLo/A=; b=I7buFBULgQ7+QkaIef/7yOl7UguC+gMEx0Ij5vpV
	Noh/LrnFwwOJtcf+6VAhT1I2Ma+zWJ5wCa2mlpeKUR45GfzCFteXlkm2SZijoNlq
	nmpN88Nh4gzW4+KseiaXIgZYmKOFP7QJAJyy4YBIdDWvVD3b4gMUP6NcIhH5TXoW
	u8JDn90KmJjpKdF1eb+qLmBr0anruvwnCxQyEuyb30dOVfuA+BPqS97An+Ircd6L
	iFwMRSscsmJETgBzzHdRdoGQF/eZVKMRv4q9fomluj5u6+KlMX+Y4yF7uvFZsUoB
	SGmhn5kVGk4FPdg40H93BFbupKJHiJKzzeKJql3Cod/NDQ==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 496x5as1wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:49:42 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b54ac2658acso3104419a12.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758008979; x=1758613779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RD+ta9axnzkY+q3MqSd9MuBTTuCWROaoN5jRYETLo/A=;
        b=pfkhEzW/pFTJ3UUxYBKpEnpqEZ+q+hD7TCr860cwP6cL4fQ5DcPnBAf8FhpAZACU+x
         r0DZwRIF11puYkYwGhXKH9MGceEw7R0HLLYRJwRPd6DGTr5WE3ML/maIlf4bG7+Kj4ny
         oCOJgAKqutZSyo+u6DMNlocCc3NEMKKBhbiA4v738afm0UvVAnm80RVoKJMA4UFzjvkn
         smnSuS7gHcmDHxRYOfVMALGaVZRnMU28zQuUAQbU07jEvjE6sZHQ6VFHzdYCcqN2ubQL
         K13A1Im0Y84Aa256lWo+5RSDFFGWBTVwdiwnInMBaByHJnRPRxFvG+l9BKqzFoXH+DS2
         7Fvw==
X-Forwarded-Encrypted: i=1; AJvYcCVFPk/Cjw2hNvxgS3Z5iTYOFQU6kFbJ66S1HPORjVLQggovott1TIiTQonUy2Uc1yE3A4xgQ83Sog==@kvack.org
X-Gm-Message-State: AOJu0Ywmy2s9dUvjlLtAJNXzOiUOc3oX1yhyqC1Ti5jJzuPvU5lT8djh
	huYcqFqL7I0g1l/MhwvFFjsVTweqvzwlaM2TCA3h2BV78atl8v8OX99RhkanfYBkqTth+KPcyEI
	zthoCjzsNHGyYrfJp4S5zvcfWwDizXOAf2XTD4U/29+HCl2ghgmHjSQ==
X-Gm-Gg: ASbGnctWytCPrAlF8UBw26ev3gB1AOBl3dEGeCP2Qndsq76O+avDcjw6g8Mp7hgNeC2
	8YuZ4r4Zy0XzqBGnSFN6eNbTWyq9HrtsjBk6Hq42Wi8t2MD0XQjClMFwzB7aLLaZTGkeEmSX6BL
	JwyfTpjAJ3fhmyPazrRYvfNCWh6HiOMqRAT6Lyrt4TyY0lkkncIrVZadRgRgoAi8TaeDbZGnbXS
	rnQH4RO1m38plyBoq9jLQDPa58U8ppGYS4Doxg9v+d1QU+xXqaf3rJG/skaqMPlK3anw29OMl/y
	/oSrvJ7bBg0V0hDnFbZe+MpPQiSwtAXKLYeppOCmvolq/xU0Fm1q1Q8O+ADNma8RPoA=
X-Received: by 2002:a05:6a20:258a:b0:249:d4b0:5b2c with SMTP id adf61e73a8af0-2602aa8a4d8mr21370485637.14.1758008979099;
        Tue, 16 Sep 2025 00:49:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwdeHuLtMjTN5imzmMBdIsYKSIeC/AVXoqz2e7UTSBmIIvssIp5vod3+KGhF2DpoYErJqm1A==
X-Received: by 2002:a05:6a20:258a:b0:249:d4b0:5b2c with SMTP id adf61e73a8af0-2602aa8a4d8mr21370433637.14.1758008978380;
        Tue, 16 Sep 2025 00:49:38 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7762c225d2asm9332136b3a.65.2025.09.16.00.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 00:49:38 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:19:29 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
        pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
        david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
        jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC][PATCH v3 00/16] Introduce kmemdump
Message-ID: <20250916074929.xiait75tbnbyjt4c@hu-mojha-hyd.qualcomm.com>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
X-Proofpoint-GUID: qkcHGwyYHu9MHD-LawAQsbh4cXfRpbCJ
X-Proofpoint-ORIG-GUID: qkcHGwyYHu9MHD-LawAQsbh4cXfRpbCJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDAxMCBTYWx0ZWRfX8F526NkOnik8
 4VAxu6XbUGMT5OPxT7/vI49uNImeDHgUXZJyYq2apviDzxe878Jdv8lZslljHHeZDh8RHqROmBL
 wHOx3A+iKmR1XkpWMKx+zBq5AjZgRLyLT6/cvwaVE5l1oRLngVxwwdS1C5+JVQECX0X6XZWp1bs
 PtoF1f5Own58p2bCRCvgbJBrO3kK4qM/cmYlVi16XoD8Iia9JQSM3MvcHA4ZlKU4SEyM+iAd/5K
 kZjvU5MOQv6SFnSIKP/mSjIeXFL8w9qNekVn2ZS2mS9RvwW3cqgHK3qWppS2H3KgohmJhcQoisT
 yCgvTCeHb/7na+chUBN0M+gLkvH1nVwmae2vgZ61L7VK0RiT5+kd3lnv5d1mbcRfFQLhnqdyouu
 qX54hII4
X-Authority-Analysis: v=2.4 cv=WpQrMcfv c=1 sm=1 tr=0 ts=68c91696 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8
 a=KKAkSRfTAAAA:8 a=vnREMb7VAAAA:8 a=COk6AnOGAAAA:8 a=bLXd17yOAAAA:8
 a=1XWaLZrsAAAA:8 a=349LBZSuyFQcu3wEsZwA:9 a=CjuIK1q_8ugA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cvBusfyB2V15izCimMoJ:22
 a=TjNXssC_j7lpFel5tvFf:22 a=XOuVWTVwyKTMzSnUH6Op:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160010
X-Stat-Signature: 4pusqen8usbudbidwxbs1fedtn5u5gpc
X-Rspamd-Queue-Id: AF916180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758008983-317657
X-HE-Meta: U2FsdGVkX1+OAspaCApYLCviM/Qu4AQVheObWhN77Hszu0/xEBWUSsYDc0YKk84GRKzmk6gBnquPOKWOQkFi4mOStz2zUbHX9RAwkyJi1t4Gw/x48z5ZNHM3ydGvmXtkdkDzWgeV8a7mwvJWZHC3iihMo1Fglz6bBg6Fe9oSJa6l26S8SDZhE/B/diYalqBhxtD+tCTwfUE1PcvoycIKkdRc+pv7thn40XxXvdLlzkzdS+VhjOAR0hhgLE5jaZc+9U1g72bJ4IZVNRsDDH8rJbs2x5hXZLQzg4tPZ59bZvCTVxRrIfKZkulWgIPE85q2/OCgwByY4El0amQtmFT7aBh+iqEQgoz4BdXs1RM2Q6J9WhQkGihxqfm0GQni8dXN6FsZnx3LPDC/BrtdejtaNTKFaWXcy9oa7b+xSIKjUJOv9Gh173pS/psOffQIBXHtzr0mps5d4tYSCWcMq48n2wuGnc84Mj3hCPBI9jCrHSFmbr7kC2+2e1pz56pHwz8wGrCYRomH6y/zUOCFpeg8cRZD8DEf+wePoDaN4ROOFNvBVrdI1Cx2cMHe+8OnNyik4e4fXzHiIknLEUnUxIGvRVqiUVI4i+/j5NrIC2cdcI0fN8NQQagLoWl9OhnEcQ2RITjQFLtRSwMMrxGeFTA5K97J+Qo0BLZ/L376RX/6Oq2hq/sOYtr8XWpNwxvc4iQmeChWvvkmuqFQRx++/6V0K1Cj+eZglUI4ZXz8zXclC4/G7VZ2zeRKdhbOxvc46zSxY1GT5mW6p3KcKWmq9azw+bKrBKFqhmMBNDcKUX4UtsRd2XcNdbIDOKSlNZhagfz+ydPpkWr9mh5jCyFOrd5Qqv+YBU03NER5K1AqrVCATeJSrYccUNxIQDfiouoLXMmlgbSf+lDRoyukiq0UcX7agYYERsBfF/gxQMm5S+LWAm4uTvnKPJ1iBMgZxIMhroC/1ArLPkuDYME7MHbAuqM
 UkLQxQhr
 JHwcjpln69Y1XdpoU6RiLvbBLV2Gwsn/Psqeaog3/99fmJlyNy2P863c4Bz6zgZ6i9qCeW2BbhpFEVDJJ267EkDanE5HOIB+7eO64xfzDiB4zk1RprnLvsXHgesZi7o+7DiCeEIzUBUO73DxvHfzL77rbahiEBASMpx1vqgEMk5fN8eez+c36xpX0aoPiOhx2vG0xpR3KB2eDl5lUr6yHAXf/LLaJkfza3lZNXsC7vRt3wQi7JgZMvdNr5UhAzeKmNQAc4IJAYOyqOH536MGSDNYgt7+oZetxPACVvKqOqsiQ17657Y4XUYskxDs12ehEeTXJ1Ad+y57y0yuwR6RiaVnWYPtyJTqz2oH4ZrJN77Ku4+MLODh/sAETlewd286sJl2dWHNwttsFheoacFi5P6VSlRl9RSt8CNpp+exgHJW9AXYCuXHeH9mapeynT0Bu2iAzd3j4jPFV51DmCkA81rpianrRjvzklDbxvJAPFMGSEaNRtChC4zJew+p6pOv/z8660aA39mxkRz1wisQbwv4r/t/DgpIjLoVAuezwGOFWFWNBOEuefuobf/ieFVQgpx8t5dqcfL9Y9wki3gJuDjcTBG99NUCkKeuUafUpAWlEpz9JSbeFpG4Oxifd8t9tdFWNdOMzj8Sv4JanmiqKNEJ+xaCbnLcOkwdmM/IZKZC0GmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 06:08:39PM +0300, Eugen Hristev wrote:
> kmemdump is a mechanism which allows the kernel to mark specific memory
> areas for dumping or specific backend usage.
> Once regions are marked, kmemdump keeps an internal list with the regions
> and registers them in the backend.
> Further, depending on the backend driver, these regions can be dumped using
> firmware or different hardware block.
> Regions being marked beforehand, when the system is up and running, there
> is no need nor dependency on a panic handler, or a working kernel that can
> dump the debug information.
> The kmemdump approach works when pstore, kdump, or another mechanism do not.
> Pstore relies on persistent storage, a dedicated RAM area or flash, which
> has the disadvantage of having the memory reserved all the time, or another
> specific non volatile memory. Some devices cannot keep the RAM contents on
> reboot so ramoops does not work. Some devices do not allow kexec to run
> another kernel to debug the crashed one.
> For such devices, that have another mechanism to help debugging, like
> firmware, kmemdump is a viable solution.
> 
> kmemdump can create a core image, similar with /proc/vmcore, with only
> the registered regions included. This can be loaded into crash tool/gdb and
> analyzed.
> To have this working, specific information from the kernel is registered,
> and this is done at kmemdump init time, no need for the kmemdump user to
> do anything.
> 
> This version of the kmemdump patch series includes two backend drivers:
> one is the Qualcomm Minidump backend, and the other one is the Debug Kinfo
> backend for Android devices, reworked from this source here:
> https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
> written originally by Jone Chou <jonechou@google.com>

+Adding some pstore experts to bring this to their attention if this can
be followed and if they find it useful.

Is not a good idea to add pstore as one of the backend of kmemdump so that all
the kmemdump captured data automatically flow in a separate record(section) in
pstore(e.g.,ram) so that all user of pstore automatically benefit from kmemdump
captured data and later kmemdump section from ramoops can be recovered from
userspace in next boot and crash utility can be run on that.

              kmemdump captured data
                |
       ---------------------
       |                   |
       V                   V
   Vendors firmware      pstore(ram)
    backend               backend
    (minidump)


Thanks,
-Mukesh

> 
> *** History, motivation and available online resources ***
> 
> Initial version of kmemdump and discussion is available here:
> https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> 
> Kmemdump has been presented and discussed at Linaro Connect 2025,
> including motivation, scope, usability and feasability.
> Video of the recording is available here for anyone interested:
> https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
> 
> Linaro blog on kmemdump can be found here:
> https://www.linaro.org/blog/introduction-to-kmemdump/
> 
> The implementation is based on the initial Pstore/directly mapped zones
> published as an RFC here:
> https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
> 
> The back-end implementation for qcom_minidump is based on the minidump
> patch series and driver written by Mukesh Ojha, thanks:
> https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
> 
> The RFC v2 version with .section creation and macro annotation kmemdump
> is available here:
> https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> 
> *** How to use kmemdump with minidump backend on Qualcomm platform guide ***
> 
> Prerequisites:
> Crash tool compiled with target=ARM64 and minor changes required for usual crash
> mode (minimal mode works without the patch)
> A patch can be applied from here https://p.calebs.dev/49a048
> This patch will be eventually sent in a reworked way to crash tool.
> 
> Target kernel must be built with :
> CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
> information needed for crash tool.
> 
> Also, the kernel requires these as well:
> CONFIG_KMEMDUMP, CONFIG_KMEMDUMP_COREIMAGE, and the backend
> CONFIG_KMEMDUMP_QCOM_MINIDUMP_BACKEND
> 
> Kernel arguments:
> Kernel firmware must be set to mode 'mini' by kernel module parameter
> like this : qcom_scm.download_mode=mini
> 
> After the kernel boots, and qcom_minidump module is loaded, everything is ready for
> a possible crash.
> 
> Once the crash happens, the firmware will kick in and you will see on
> the console the message saying Sahara init, etc, that the firmware is
> waiting in download mode. (this is subject to firmware supporting this
> mode, I am using sa8775p-ride board)
> 
> Example of log on the console:
> "
> [...]
> B -   1096414 - usb: init start
> B -   1100287 - usb: qusb_dci_platform , 0x19
> B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
> B -   1107455 - usb: usb2phy: PRIM success , 0x4
> B -   1112670 - usb: dci, chgr_type_det_err
> B -   1117154 - usb: ID:0x260, value: 0x4
> B -   1121942 - usb: ID:0x108, value: 0x1d90
> B -   1124992 - usb: timer_start , 0x4c4b40
> B -   1129140 - usb: vbus_det_pm_unavail
> B -   1133136 - usb: ID:0x252, value: 0x4
> B -   1148874 - usb: SUPER , 0x900e
> B -   1275510 - usb: SUPER , 0x900e
> B -   1388970 - usb: ID:0x20d, value: 0x0
> B -   1411113 - usb: ENUM success
> B -   1411113 - Sahara Init
> B -   1414285 - Sahara Open
> "
> 
> Once the board is in download mode, you can use the qdl tool (I
> personally use edl , have not tried qdl yet), to get all the regions as
> separate files.
> The tool from the host computer will list the regions in the order they
> were downloaded.
> 
> Once you have all the files simply use `cat` to put them all together,
> in the order of the indexes.
> For my kernel config and setup, here is my cat command : (you can use a script
> or something, I haven't done that so far):
> 
> `cat memory/md_KELF1.BIN memory/md_Kvmcorein2.BIN memory/md_Kconfig3.BIN \
> memory/md_Kmemsect4.BIN memory/md_Ktotalram5.BIN memory/md_Kcpu_poss6.BIN \
> memory/md_Kcpu_pres7.BIN memory/md_Kcpu_onli8.BIN memory/md_Kcpu_acti9.BIN \
> memory/md_Kjiffies10.BIN memory/md_Klinux_ba11.BIN memory/md_Knr_threa12.BIN \
> memory/md_Knr_irqs13.BIN memory/md_Ktainted_14.BIN memory/md_Ktaint_fl15.BIN \
> memory/md_Kmem_sect16.BIN memory/md_Knode_dat17.BIN memory/md_Knode_sta18.BIN \
> memory/md_K__per_cp19.BIN memory/md_Knr_swapf20.BIN memory/md_Kinit_uts21.BIN \
> memory/md_Kprintk_r22.BIN memory/md_Kprintk_r23.BIN memory/md_Kprb24.BIN \
> memory/md_Kprb_desc25.BIN memory/md_Kprb_info26.BIN memory/md_Kprb_data27.BIN \
> memory/md_Krunqueue28.BIN memory/md_Khigh_mem29.BIN memory/md_Kinit_mm30.BIN \
> memory/md_Kinit_mm_31.BIN memory/md_Kunknown32.BIN memory/md_Kunknown33.BIN \
> memory/md_Kunknown34.BIN  memory/md_Kunknown35.BIN memory/md_Kunknown36.BIN \
> memory/md_Kunknown37.BIN memory/md_Kunknown38.BIN memory/md_Kunknown39.BIN \
> memory/md_Kunknown40.BIN memory/md_Kunknown41.BIN memory/md_Kunknown42.BIN \
> memory/md_Kunknown43.BIN memory/md_Kunknown44.BIN memory/md_Kunknown45.BIN \
> memory/md_Kunknown46.BIN memory/md_Kunknown49.BIN  memory/md_Kunknown50.BIN \
> memory/md_Kunknown51.BIN > ~/minidump_image`
> 
> Once you have the resulted file, use `crash` tool to load it, like this:
> `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
> 
> There is also a --minimal mode for ./crash that would work without any patch applied
> to crash tool, but you can't inspect symbols, etc.
> 
> Once you load crash you will see something like this :
> 
>       KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
>     DUMPFILE: /home/eugen/new
>         CPUS: 8 [OFFLINE: 5]
>         DATE: Thu Jan  1 02:00:00 EET 1970
>       UPTIME: 00:00:22
>        TASKS: 0
>     NODENAME: qemuarm64
>      RELEASE: 6.17.0-rc5-next-20250910-00020-g7dfa02aeae7e
>      VERSION: #116 SMP PREEMPT Thu Sep 11 18:28:06 EEST 2025
>      MACHINE: aarch64  (unknown Mhz)
>       MEMORY: 34.2 GB
>        PANIC: ""
> crash> log
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
> [    0.000000] Linux version 6.17.0-rc5-next-20250910-00020-g7dfa02aeae7e (eugen@eugen-station) (aarch64-none-linux-gnu-gcc (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 13.3.1 20240614, GNU ld (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 2.42.0.20240614) #116 SMP PREEMPT Thu Sep 11 18:28:06 EEST 2025
> 
> 
> *** Debug Kinfo backend driver ***
> I don't have any device to actually test this. So I have not.
> I hacked the driver to just use a kmalloc'ed area to save things instead
> of the shared memory, and dumped everything there and checked whether it is identical
> with what the downstream driver would have saved.
> So this synthetic test passed and memories are identical.
> Anyone who actually wants to test this, feel free to reply to the patch.
> I have also written a simple DT binding for the driver.
> 
> Thanks for everyone reviewing and bringing ideas into the discussion.
> 
> Eugen
> 
> Changelog since the v2 of the RFC:
> - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> - Removed the .section as requested by David Hildenbrand.
> - Moved all kmemdump registration(when possible) to vmcoreinfo.
> - Because of this, some of the variables that I was registering had to be non-static
> so I had to modify this as per David Hildenbrand suggestion.
> - Fixed minor things in the Kinfo driver: one field was broken, fixed some
> compiler warnings, fixed the copyright and remove some useless includes.
> - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
> and it's now available in kernel hacking, as per Randy Dunlap review
> - Reworked some of the Documentation as per review from Jon Corbet
> 
> 
> Changelog since the v1 of the RFC:
> - V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
> This means new API, macros, new way to store the regions inside kmemdump
> (ditched the IDR, moved to static allocation, have a static default backend, etc)
> - Reworked qcom_minidump driver based on review from Bjorn Andersson
> - Reworked printk log buffer registration based on review from Petr Mladek
> 
> I appologize if I missed any review comments. I know there is still lots of work
> on this series and hope I will improve it more and more.
> Patches are sent on top of next-20250910
> 
> Eugen Hristev (16):
>   kmemdump: Introduce kmemdump
>   Documentation: Add kmemdump
>   kmemdump: Add coreimage ELF layer
>   Documentation: kmemdump: Add section for coreimage ELF
>   kernel/vmcore_info: Register dynamic information into Kmemdump
>   kmemdump: Introduce qcom-minidump backend driver
>   soc: qcom: smem: Add minidump device
>   init/version: Add banner_len to save banner length
>   genirq/irqdesc: Have nr_irqs as non-static
>   panic: Have tainted_mask as non-static
>   mm/swapfile: Have nr_swapfiles as non-static
>   printk: Register information into Kmemdump
>   sched: Add sched_get_runqueues_area
>   kernel/vmcoreinfo: Register kmemdump core image information
>   kmemdump: Add Kinfo backend driver
>   dt-bindings: Add Google Kinfo
> 
>  Documentation/dev-tools/index.rst             |   1 +
>  Documentation/dev-tools/kmemdump.rst          | 139 +++++++
>  .../bindings/misc/google,kinfo.yaml           |  36 ++
>  MAINTAINERS                                   |  19 +
>  drivers/soc/qcom/smem.c                       |  10 +
>  include/linux/kmemdump.h                      | 130 +++++++
>  include/linux/printk.h                        |   1 +
>  init/version-timestamp.c                      |   1 +
>  init/version.c                                |   1 +
>  kernel/irq/irqdesc.c                          |   2 +-
>  kernel/panic.c                                |   2 +-
>  kernel/printk/printk.c                        |  47 +++
>  kernel/sched/core.c                           |  15 +
>  kernel/sched/sched.h                          |   2 +
>  kernel/vmcore_info.c                          | 149 ++++++++
>  mm/Kconfig.debug                              |   2 +
>  mm/Makefile                                   |   1 +
>  mm/kmemdump/Kconfig.debug                     |  53 +++
>  mm/kmemdump/Makefile                          |   6 +
>  mm/kmemdump/kinfo.c                           | 293 +++++++++++++++
>  mm/kmemdump/kmemdump.c                        | 234 ++++++++++++
>  mm/kmemdump/kmemdump_coreimage.c              | 222 +++++++++++
>  mm/kmemdump/qcom_minidump.c                   | 353 ++++++++++++++++++
>  mm/swapfile.c                                 |   2 +-
>  24 files changed, 1718 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/dev-tools/kmemdump.rst
>  create mode 100644 Documentation/devicetree/bindings/misc/google,kinfo.yaml
>  create mode 100644 include/linux/kmemdump.h
>  create mode 100644 mm/kmemdump/Kconfig.debug
>  create mode 100644 mm/kmemdump/Makefile
>  create mode 100644 mm/kmemdump/kinfo.c
>  create mode 100644 mm/kmemdump/kmemdump.c
>  create mode 100644 mm/kmemdump/kmemdump_coreimage.c
>  create mode 100644 mm/kmemdump/qcom_minidump.c
> 
> -- 
> 2.43.0
> 

-- 
-Mukesh Ojha

