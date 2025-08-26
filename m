Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAE3CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56636B02C6; Tue, 26 Aug 2025 13:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6CF6B02C7; Tue, 26 Aug 2025 13:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980C96B02C8; Tue, 26 Aug 2025 13:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78BBB6B02C6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:15:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7363583B93
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:15:01 +0000 (UTC)
X-FDA: 83819558802.12.4566BDF
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id DECD8180011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:14:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HEqDWIIz;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756228499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIIY+Ur2rqJSQSBwUezrJ90xeU4rtN9bpG3yYRpDXzA=;
	b=bl7Eki4z8e2+rVYp96YuhQ1++zTrxThnEIbLIXiOU69FdBY0jdDVHNoqq/lVE1cqVAj1H/
	PNvJCB45yHJVvZ8gDJGmcSPOHfQFsEtGz9c3YIAg72ADFsmPKgWZEDeBJ451O9h1YOkiZB
	V7Dy6771sxlRBcgAoQMBswocfBTalD0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=HEqDWIIz;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756228499; a=rsa-sha256;
	cv=none;
	b=DXGHl2B0yYbSdjz0lv9u8+r2mf1adJTZSQeG3f3Gzmu4Y8IJHLUkk/W0rhUNGoLop+pcKo
	Lmrg90QkE05mmKRRllW8ZRWPKvxASWgrKum7dUqLkqVQTzi6hq5tPzYX89gffHO8POYIz4
	4oONCTR5l3KR/s4qK+womi+Dowd6NFE=
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCoIQt007747
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=sIIY+Ur2rqJSQSBwUezrJ90x
	eU4rtN9bpG3yYRpDXzA=; b=HEqDWIIz/efIx5MBARqcKHWuPgHxgk4tMAm6oh6I
	++GWgbsFKgkkr3/CttCsmJ2I9tmQFIE+1tV613LvgckmMOMGxylPNxOOMLYv+5fe
	1XC50jWzSd7swI52CiaIKg60OVxe49bo0uyElkQbneIXRqBgZ4CM2du+6NAPxW+5
	kV1QMMZcXfsCLU0HVmUcAbHVCbNSmT+EWBY/0dYKDiZMjkU1dpGtPBXM7OVg5Oe5
	cS3NRaMtilkYWb5v3Jf23ZLzZy+DKy1yPmV3zDcmI9SDRxxBp4n28UVcIM3kss5L
	uYFAjewYYPqRgIeokFpV3LRYfMTeFc5QGL1PQUgPcw59/Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48q5xfhrfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:14:57 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b4c2c09a760so1245651a12.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756228495; x=1756833295;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIIY+Ur2rqJSQSBwUezrJ90xeU4rtN9bpG3yYRpDXzA=;
        b=lyKaasj3tFtlwU/LLW3Jp+6KaRGcFCgR2+W2svI1w8hoxJI6C8n9H2XpG4e3Ise5Gy
         vtGK9hO1kF+FLaNc3ld+6dHcDeCDNrLIh+5ejyYdffpqaYbPCG62PeulGg2U7nclKtol
         ZpUcYE70rIWQ9Rx6B8QXhgFX0tdDQ6EoldMjDtQKWq8ZexWcYGE/an2D+8Owv1JbgBJ+
         00YOC0D1ad26AIqfYGoi/yiuTNooe6l7LWQgHlNQeMzCBghkrfOd+dTeCdkKsiSscoMb
         r0MGZo1t5jEOG6p7/IYMUvlbh0IiSrYhRe14L23oo5Hr1OAFSXyGLYC7CZxppFN1Z+BL
         5IIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAr6sJYSmp/cpPIcW+fos3H/jhv+3I2SAAF/r4TDAKMoSNBLTa0fjNY1q8yFDKX4jFPD1/lQITcg==@kvack.org
X-Gm-Message-State: AOJu0Yxepi6sFY8JIpXj8msq5VzC31MejI60qiztCbQcfmGWmxOTk7S1
	7gTxnm/P3lbTS/I6ISqWkKipReh43Le6lZvWFaEw5C1fZcY+k5HNpCUskV5ABtMz6lvPtz/aVXD
	WtyGecfAWDZZHFf2vGWFpNmHlRpPCno+itSgb3qOr9oqE56bPdjJqIA==
X-Gm-Gg: ASbGnct4o0KRc0HrWfh4WiZQ2vmv1bNmdZxehMJlH0XonuHwnWODK1dr+jfa4Hh/e59
	CtwZI/Ssv60p+2TELHZQSNtKna5DQ+ny7VaLOO0xWjdKcOv1xT7Q6dPTdZGZcDh+Pxj3G1P+Qhn
	Idq95w2aw2eharbpItkeYPsfJxSK86A4WtIDBrW99FS7Istp9l5W1ju8vxu4XIUSW/D+88epvOO
	EJIrDWDzDi8jX8d2CdincM9FrsxwCZBsrtEduR/0K9krhfDdMfunhuyFm8QhzAe4OuHtO0HKMWe
	GvuL7oc2lRL04lH8pyU8eyScloEUkrxSvf1581RuP2d6VaB8oZdiV/GXhGfv/wCIC0Y=
X-Received: by 2002:a17:902:ce8b:b0:240:52c8:2564 with SMTP id d9443c01a7336-2462ee8e8f4mr245573505ad.26.1756228494720;
        Tue, 26 Aug 2025 10:14:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHntt0G+q9NMI/UOZT8ywGbkhH4ZHMChCz25hbho9klF3RDxKSos+Um1MoE6z7OkYJ8G1s4w==
X-Received: by 2002:a17:902:ce8b:b0:240:52c8:2564 with SMTP id d9443c01a7336-2462ee8e8f4mr245573115ad.26.1756228494074;
        Tue, 26 Aug 2025 10:14:54 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-246688801bdsm101007075ad.123.2025.08.26.10.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 10:14:53 -0700 (PDT)
Date: Tue, 26 Aug 2025 22:44:47 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        andersson@kernel.org, pmladek@suse.com,
        linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
        corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
        jonechou@google.com, tudor.ambarus@linaro.org
Subject: Re: [RFC][PATCH v2 00/29] introduce kmemdump
Message-ID: <20250826171447.6w77day5wddppy3s@hu-mojha-hyd.qualcomm.com>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMyBTYWx0ZWRfX8h3s+Dak1dHm
 7uDQpaOn3G07SU0LcvOGZ60DoP2OEjMV+PZ3PbhVhtYyYZKiJrPXK7RLu6z1OKnu/GSY6RJyZEq
 7t1fkoULGpsNoqZgtyT1yDd++8sESFtpkgrQPaU8lXzKsCagh5z2Ket+Re/+IuK11CPH9YEHs8q
 4CKiAgwSlHasRDRiQW7/S/+6XCsJShQD6Xh70v7UyR9Vfzjbs0YInvvJd73MLjmNLqkvUiGW4qP
 og3a/LGsKqcFMGm+Q8WAszf6nnuy7dZ6jiRpX/wW2ePao8yQ+wkVLiKTh6Td6ujxp9oWkNDYl2V
 fSIYtI8klLbAXp3weUnCx4WJARewNQK1FXh7JM2QAVsNo9Rpk5NnDp9c0L0ZtRBEHLbHieWWHXP
 HQRelWI6
X-Proofpoint-GUID: iqg6kclpXpfhWiE01PRecGvQlh-HmrMS
X-Authority-Analysis: v=2.4 cv=MutS63ae c=1 sm=1 tr=0 ts=68adeb91 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8
 a=KKAkSRfTAAAA:8 a=vnREMb7VAAAA:8 a=COk6AnOGAAAA:8 a=bLXd17yOAAAA:8
 a=1XWaLZrsAAAA:8 a=349LBZSuyFQcu3wEsZwA:9 a=CjuIK1q_8ugA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cvBusfyB2V15izCimMoJ:22
 a=TjNXssC_j7lpFel5tvFf:22 a=XOuVWTVwyKTMzSnUH6Op:22
X-Proofpoint-ORIG-GUID: iqg6kclpXpfhWiE01PRecGvQlh-HmrMS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230033
X-Rspamd-Queue-Id: DECD8180011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: b3xif3hkb5et3h1p3g4c1165fnt81nea
X-HE-Tag: 1756228498-106141
X-HE-Meta: U2FsdGVkX18IheXxPGxXrS4Xa0sFWLK5iUgTKvZyQPj86/HUx50s15T4/nzJrcwFTZihg9E/y5vlqY3dY6E6ni5q82ix7t+liWFT8UIGFpM+X8XHSyNRNiGR0eG84xDysX1h85/5uQ9Z0iKkSv7FPTh+6zgD58IMg9ZgI8Rr2F0FuFArpT0kHlqunk3wnJoU85ngMGBDruiTdtAqlDur6i0tJDI6HOx1HGu8Ue/xMfq2ZgCg1PW4sCpNlXm9Kd60ywHEe8Bx7QRQysOUduHa2Ehwcmi7MuN9obxrl2bRH8IuwwtUVDBT/CYT6146A7+p8oUL0bPBXx8bEZERwYI2KgwBWdlgV08QeOnQHk7HXP7wjFkrfdM0lqiq56rKTYv5m73C+kLg4sbYHJPOrrhsx7GrMycOgRVdUTArzNtUUS2ZEO23Kb0MkzZ61ytMvGJ6WcDJ4dWnDUhV25OIVfkrqp8vg1BA4EUTzeHSiFvbEoqNuE+KlxzyEYpvNGWjaAg5PYM9naYMa04HtEVXIzVAIz9PVOz3lOpqhJt1mtZ1IVV1csc7xnKCgotzeB/BClfC9gxGuSHIWzEdjZB64p3alzcIC9SbSgiQ2xWbCK6anzUoe7qvLOCwnz6xANUXcbr83XybPjcHTTtl+LRKSnHjAm87NhFusJ+4X4hq2v3IWoEzqEvu2vYKH+o6FnoGcLU/q+pB/vsC/gQo+oz7DdqDIRc6SjjDv2bfZxoEcXh5vWZXbu3lJQ3Ym+boWe0RgEWMslPN3BkBdKfpZ4IjFy9QR0szMm4tXmD0Ztqvdc1dnjmiD4YTaBqIz8/bwiuv8NdJFaJQr8bQJrGQd4GJEhKBZKZQvSC4ijrVZGN6tvZhFkpfothd/k+9ZzMR+ngELOBuCMlOosw+J7HuAiNTQoqpRNEz9ktnumueEo9qgufiSPlJRRrkrpyIJ9+FjaxEhuKFkiLYWB4zjUgDiRBpMdq
 M+1TWZxY
 PP0j1ZCXO+KEVW2dufrM3JwpUjOKzy61gsQKgq4gWsuksjxxwG2r5e9qhq3lCQH1AhA03vcFVeiEAsYmZZBMHtHfA6ZpDE83VhcpU+F+CjGjjvCB7JFn/ffueEIWWV4h0qDqtC9i6CCa/nIWMvJRAqmmdeDiuh9aQ16dr1LabGl7xvpdnUKe8wD4FwGfJBXRKt7XPKn0CkDCmO/EIqx3+0UYySJOjv3F/7JwZ8ejVrYCI9dRjIOV6nna39yX4dA/xCYzzEsvxMY5YEEs/TSJD/H5qrullVR3g6KGtiSd2nhPCTB4cReiMvK7thGtD1VAZfFeViR9IY9ECLG6zpwi4AlOdD5kDlo9BR6UGMAvSCw5w77vx5UicAY5SuOVHW3jYWIhxZEd5IsVbkvXquGG7gnh66T1UyG9gvWbslc0G8Evp85yrVGd/jGVTYbfSK0BwWFsMSq2JbDVLD4eYkktGDDnzDlzveHEEW7jie+MLACom/uaOcF/fIZOp7R8/8GIhrA/2TCPiSpzbGdTgB8hlYi83WUyzJTnat52KQq4Uf5GOzQZE4qR3TPORhnFvd10ZqKFv4c1KC+7HEOM2QVOfHxG1m09lVOo7fkLpNN91nPwI1u1X8Fqzz88wkx4avwNqKnB3EZOixxBeIELQ4SRCXzZ9JTKWD3Oq6TyhoZhWnJ1TaKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:54:43PM +0300, Eugen Hristev wrote:
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
> 
> Initial version of kmemdump and discussion is available here:
> https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
> 
> Kmemdump has been presented and discussed at Linaro Connect 2025,
> including motivation, scope, usability and feasability.
> Video of the recording is available here for anyone interested:
> https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
> 
> The implementation is based on the initial Pstore/directly mapped zones
> published as an RFC here:
> https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
> 
> The back-end implementation for qcom_minidump is based on the minidump
> patch series and driver written by Mukesh Ojha, thanks:
> https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
> 
> *** How to use kmemdump with minidump backend on Qualcomm platform guide ***
> 
> Prerequisites:
> Crash tool with target=ARM64 and minor changes required for usual crash mode
> (minimal mode works without the patch)
> A patch can be applied from here https://p.calebs.dev/49a048
> This patch will be eventually sent in a reworked way to crash tool.
> 
> Target kernel must be built with :
> CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
> information needed for crash tool.
> 
> Otherwise, the kernel requires these as well:
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
>  memory/md_Knr_irqs13.BIN memory/md_Ktainted_14.BIN memory/md_Ktaint_fl15.BIN \
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
> memory/md_Kunknown46.BIN memory/md_Kunknown47.BIN  memory/md_Kunknown50.BIN \
> memory/md_Kunknown51.BIN memory/md_Kunknown52.BIN \
> memory/md_Kunknown53.BIN > ~/minidump_image`
> 
> Once you have the resulted file, use `crash` tool to load it, like this:
> `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
> 
> There is also a --minimal mode for ./crash that would work without any patch applied
> to crash tool, but you can't inspect symbols, etc.

Unfortunately for me, only with --minimal option, I could see the 'log'.

./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image

WARNING: kernel version inconsistency between vmlinux and dumpfile

crash: read error: kernel virtual address: ffffff8ed7f380d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7f510d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7f6a0d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7f830d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7f9c0d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7fb50d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7fce0d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffff8ed7fe70d8  type: "IRQ stack pointer"
crash: read error: kernel virtual address: ffffffc0817c5d80  type: "maple_init read mt_slots"
crash: read error: kernel virtual address: ffffffc0817c5d78  type: "maple_init read mt_pivots"
crash: read error: kernel virtual address: ffffff8efb89e2c0  type: "memory section root table"

Looks like something more you are using in your setup to make it work.

-Mukesh

> 
> Once you load crash you will see something like this :
> 
>    KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
>     DUMPFILE: /home/eugen/new
>         CPUS: 8 [OFFLINE: 7]
>         DATE: Thu Jan  1 02:00:00 EET 1970
>       UPTIME: 00:00:29
>        TASKS: 0
>     NODENAME: qemuarm64
>      RELEASE: 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty
>      VERSION: #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025
>      MACHINE: aarch64  (unknown Mhz)
>       MEMORY: 34.2 GB
>        PANIC: ""
> crash> log
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
> [    0.000000] Linux version 6.16.0-rc7-next-20250721-00029-gf8cffdbf0479-dirty (eugen@eugen-station) (aarch64-none-linux-gnu-gcc (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 13.3.1 20240614, GNU ld (Arm GNU Toolchain 13.3.Rel1 (Build arm-13.24)) 2.42.0.20240614) #5 SMP PREEMPT Tue Jul 22 18:44:57 EEST 2025
> 
> 
> *** Debug Kinfo backend driver ***
> I don't have any device to actually test this. So I have not.
> I hacked the driver to just use a kmalloc'ed area to save things instead
> of the shared memory, and dumped everything there and checked whether it looks
> sane. If someone is willing to try it out, thanks ! and let me know.
> I know there is no binding documentation for the compatible either.
> 
> Thanks for everyone reviewing and bringing ideas into the discussion.
> 
> Eugen
> 
> Changelog since the v1 of the RFC:
> - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
> This means new API, macros, new way to store the regions inside kmemdump
> (ditched the IDR, moved to static allocation, have a static default backend, etc)
> - Reworked qcom_minidump driver based on review from Bjorn Andersson
> - Reworked printk log buffer registration based on review from Petr Mladek
> 
> I appologize if I missed any review comments. I know there is still lots of work
> on this series and hope I will improve it more and more.
> Patches are sent on top of next-20250721
> 
> Eugen Hristev (29):
>   kmemdump: introduce kmemdump
>   Documentation: add kmemdump
>   kmemdump: add coreimage ELF layer
>   Documentation: kmemdump: add section for coreimage ELF
>   kmemdump: introduce qcom-minidump backend driver
>   soc: qcom: smem: add minidump device
>   init/version: Annotate static information into Kmemdump
>   cpu: Annotate static information into Kmemdump
>   genirq/irqdesc: Annotate static information into Kmemdump
>   panic: Annotate static information into Kmemdump
>   sched/core: Annotate static information into Kmemdump
>   timers: Annotate static information into Kmemdump
>   kernel/fork: Annotate static information into Kmemdump
>   mm/page_alloc: Annotate static information into Kmemdump
>   mm/init-mm: Annotate static information into Kmemdump
>   mm/show_mem: Annotate static information into Kmemdump
>   mm/swapfile: Annotate static information into Kmemdump
>   mm/percpu: Annotate static information into Kmemdump
>   mm/mm_init: Annotate static information into Kmemdump
>   printk: Register information into Kmemdump
>   kernel/configs: Register dynamic information into Kmemdump
>   mm/numa: Register information into Kmemdump
>   mm/sparse: Register information into Kmemdump
>   kernel/vmcore_info: Register dynamic information into Kmemdump
>   kmemdump: Add additional symbols to the coreimage
>   init/version: Annotate init uts name separately into Kmemdump
>   kallsyms: Annotate static information into Kmemdump
>   mm/init-mm: Annotate additional information into Kmemdump
>   kmemdump: Add Kinfo backend driver
> 
>  Documentation/debug/index.rst      |  17 ++
>  Documentation/debug/kmemdump.rst   | 104 +++++++++
>  MAINTAINERS                        |  18 ++
>  drivers/Kconfig                    |   4 +
>  drivers/Makefile                   |   2 +
>  drivers/debug/Kconfig              |  55 +++++
>  drivers/debug/Makefile             |   6 +
>  drivers/debug/kinfo.c              | 304 +++++++++++++++++++++++++
>  drivers/debug/kmemdump.c           | 239 +++++++++++++++++++
>  drivers/debug/kmemdump_coreimage.c | 223 ++++++++++++++++++
>  drivers/debug/qcom_minidump.c      | 353 +++++++++++++++++++++++++++++
>  drivers/soc/qcom/smem.c            |  10 +
>  include/asm-generic/vmlinux.lds.h  |  13 ++
>  include/linux/kmemdump.h           | 219 ++++++++++++++++++
>  init/version.c                     |   6 +
>  kernel/configs.c                   |   6 +
>  kernel/cpu.c                       |   5 +
>  kernel/fork.c                      |   2 +
>  kernel/irq/irqdesc.c               |   2 +
>  kernel/kallsyms.c                  |  10 +
>  kernel/panic.c                     |   4 +
>  kernel/printk/printk.c             |  28 ++-
>  kernel/sched/core.c                |   2 +
>  kernel/time/timer.c                |   3 +-
>  kernel/vmcore_info.c               |   3 +
>  mm/init-mm.c                       |  12 +
>  mm/mm_init.c                       |   2 +
>  mm/numa.c                          |   5 +-
>  mm/page_alloc.c                    |   2 +
>  mm/percpu.c                        |   3 +
>  mm/show_mem.c                      |   2 +
>  mm/sparse.c                        |  16 +-
>  mm/swapfile.c                      |   2 +
>  33 files changed, 1670 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/debug/index.rst
>  create mode 100644 Documentation/debug/kmemdump.rst
>  create mode 100644 drivers/debug/Kconfig
>  create mode 100644 drivers/debug/Makefile
>  create mode 100644 drivers/debug/kinfo.c
>  create mode 100644 drivers/debug/kmemdump.c
>  create mode 100644 drivers/debug/kmemdump_coreimage.c
>  create mode 100644 drivers/debug/qcom_minidump.c
>  create mode 100644 include/linux/kmemdump.h
> 
> -- 
> 2.43.0
> 

-- 
-Mukesh Ojha

