Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3484CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4F08E0003; Mon, 17 Nov 2025 23:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385FC8E0002; Mon, 17 Nov 2025 23:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2748E8E0003; Mon, 17 Nov 2025 23:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 125A18E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:42:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3153160365
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:42:08 +0000 (UTC)
X-FDA: 84122480736.20.87C9049
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5EE2540009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:42:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ilLhvtZI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of misanjum@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=misanjum@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763440926; a=rsa-sha256;
	cv=none;
	b=j8VlXbcuFK/aZ0c/eaxbl4J4IaG3Z/x92vS7D8b81GdNcSF6BNCwrVoSayWLaR2Ba1eFer
	B8aTmnZ2dwaBtpTni9rmTg4aVGxLYh9DCU7ADHgz9HDE6moAnRHkTkYN5GJofLF31kCQ67
	FlVfr1qvUetnhIxzkAJZ6bbEXgrCG1o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ilLhvtZI;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of misanjum@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=misanjum@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763440926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nRFhvq2Uz4NA8JO4R785yYCp5GN2GZ3XDrcXeOP+C1o=;
	b=suqeIjoFh2o2Cyo9OOe7Byr2sIovBC7wlSDhdYrQet/qc9lGlmu/LCwxMakHq7agJRzzpY
	jR29DP6q5509iIvV9FWDGuG2K4YQRFWw+Yz7nGR7J27RpQQ9TrrBrX/cwpw1v4PstSBcMU
	ycb5YgxDXyFp+FPZ0ST7Xb5a+vXZWNs=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHFV2qd019708;
	Tue, 18 Nov 2025 04:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=nRFhvq2Uz4NA8JO4R785yYCp5GN2
	GZ3XDrcXeOP+C1o=; b=ilLhvtZI3yN55Daa9evGhhYcZHd8smX7BqL9S8hrQFYk
	7S74jOfi73w/cZt6ag53f0emBsWk0Q+QKvU940ky8orkhGrjRYH81ZKa/naHgJhs
	SDTH1WUItX5quVYkbDv0SWNC52krgUiWATcLeMxrhev/7TeR3UaiK4CDS17YffQT
	QJRuab4UDdvfZSzkCz78y/Tb6sLLkqW30f3aaqISHgo3/2a/xP9kRcO4/0ka+G1k
	rO4TbfHK/yK06VQMm9m3qHLf3B4k4KCwHzycrwX6MQ036JO+5irmfssTrV+JZ+b6
	xYZpiFVyS37O8vm7LVVbU8tWVbgTkvdAtXVsAZxKfw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgwruyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 04:42:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI1NdLC010419;
	Tue, 18 Nov 2025 04:42:04 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3us1gfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Nov 2025 04:42:04 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AI4fn2A27132500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 04:41:49 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79EA158055;
	Tue, 18 Nov 2025 04:42:03 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E606F5804B;
	Tue, 18 Nov 2025 04:42:02 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Nov 2025 04:42:02 +0000 (GMT)
MIME-Version: 1.0
Date: Tue, 18 Nov 2025 10:12:02 +0530
From: Misbah Anjum N <misanjum@linux.ibm.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [REGRESSION] [next-20251117] ppc64le: WARNING in vmalloc_fix_flags
 with __GFP_ACCOUNT in BPF/seccomp path
Message-ID: <dbe42ce9543dbc3af95f95d6a6d9540b@linux.ibm.com>
X-Sender: misanjum@linux.ibm.com
Organization: IBM
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dl3jukZaATzcvyZbsrEt5xz6YXoakvzG
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691bf91d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=eDBbsAWTgkdve4Kpa_YA:9 a=CjuIK1q_8ugA:10
 a=HhbK4dLum7pmb74im6QT:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=pHzHmUro8NiASowvMSCR:22
 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-ORIG-GUID: dl3jukZaATzcvyZbsrEt5xz6YXoakvzG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX64yia7Fiuaql
 EWJIRt/dqFz0YVbI7vJiUa7wAgeZLr0WJY7g5gdDJ15f7doSh2PF/L84JjWRv6W8kb6aIhkbjNT
 FOO8ZE4aschFbZA4vUUa/O9eXQFyw2L7Fh9QhlgrB8Y5p3C4yNeA9mxNd96HJnZzd0jDnl4gPCZ
 l1A0waUMoy0PplYoy3uF7oJaypN8+2k7tCOA0TtG7ZbHNIS9wM7b/128BcRoY1VlHKuALmGvqzj
 qag7OQ9vN0Xszg92OjJL0OW46pexRdBvl0jGdaWz3TUMtoNq29rbC+ljfr72laOCS7nUfyF+FlA
 gzCu8i1p56UiY1TRoe9rtxzHLAnHl4w9GamC5VHRWnr50Std5j8jaaj04k78kN4PYlwwmJh7kwP
 p/1AcUkQg6wyi1mQMuR6rhb7j1UQ1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5EE2540009
X-Stat-Signature: dwj5ghmz9195ase4zw5q17u5qhee1kuy
X-Rspam-User: 
X-HE-Tag: 1763440926-866125
X-HE-Meta: U2FsdGVkX1+VzIvdAVMpYwEYhRXyXmVOVvdzSp17efuZ8sB6Itot26Svwr2FA/rUmfsnYxuUhYqifjHVwemLy8eCecAi/WEO0POwYcTD9H1oodNLTyQCHtsqjZk7XLv4DwXbEdcjQ/m1B6K2FiSEIZT4ho4uONsGVjpSlK3R4ncaYLXCpfGMExe/UOjk9BuUAaz1zBCiRmPr99HMi0lk6NAMtB3DGh9N+5HRMhBdgrCbJ9FT5EUom8Sb0bB/EsnCpe0aUQ2A7TQYegnyagFMjz41Jwp9CqoPNvhQD83iQA+zKkisap51SHkxrKEHaAEzO/i73irYIEcmT5WgL8R6c39HedZmoZFW/GyFmy/lQF9ZyrsXGiPjeXc9JfQZfSERYot2A5Q20UM2diocvK9vvxP2ucXrW2QHegy2RULTaOm1gIQO/u1v4vftP+SNnp5xVXljoMQzLwK1KC0bRL5wh5gtNlhfcolNJwziE7FcwAjvTVrb0mVJs+kFCeOkfxrGx4SCsd8pPAJRoBdtqQIFwwLDVqVu4Fmgp3LDvrN7JZwY261Taze4EboLBZS6Yv0QZfA44n2j8SPtaRI+UHVz2ISejqH5taoW4nKzR5KcMQ/ItoNXYMkO3TXFOlwRoD8S1JRmxcQM7rnm0s7FGLeVkXIvYDxllyfai0TFdNiuJuxK23OciGlTfmQS5I6BHwqGiaEcj32OHgoIP16tgVKvQuvBl6PvDAxt/gGfHCuWOtLSE/tt0tcqquPPD09Z06QRjyDjX6dHjKop7K5P2wAgueDTfV0IlqF0xEWmbMN0WC7lBl8FqiASMUhq2iZkLTup2BzwNjbPMYBti7PmgQ3F9d/FU5Z1XoMXR+ai9Nmx/5RgH9PdYEbeF8JGZ5IRyo1pOZUHQCDoRdrPcoRy36lPCwP49waii0JK3KBIplJXHQKaarT58vy8/hOb1VkwQv0DkM065TR7GePpjMHYkOc
 ca3InPQj
 3YVY4Q/A/3dUb5wcpq1ewvtAT769G8peIBkD5NoPsulq5otBUH7wzs4qx5JT4/jw86sM9RtsqzLubWwHMnBzfUlRATmgxpUOg7EV1uVzKS9WFlvItiOFrMoixSol9zZiqHXXU21B24exvd/4W8AwDzx8ubvB3Eq+3xsOOqfJbFIPEgvxHSQ685HfpXOcf6wF6EG1EYad+Sfmpuj9OZpwjV70qfzImbM+59yDvi/Y/Nr/xdjg0bwEmr57ZU1j0FWMZhabpJiszPSajqTiAoQUTNJWhcB4TNDAJaTVmjTZtiPMQY4MteF5lqvzN0EhdaebTK/+H759mgHQvbz//j37j+CZlsKDmbw26UtwONQ0oCXBIsYN7DgX2iKjgcZxihA0FkxcSwA692EnkuY+jWgciDqoQpPEiqD7qI2Y6OemmH54epWSL60naXlJliWyIidhEExGjVSOw46bs5tLQSONRTAmyPdrd0ZpSK8tI7toHb7kdqRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I'm reporting a regression in linux-next that was introduced between 
20251114 and 20251117.

Regression Info:
- Working: 6.18.0-rc5-next-20251114
- Broken: 6.18.0-rc6-next-20251117

Environment:
- IBM Power11 pSeries (ppc64le)
- Fedora43 Distro

Issue:
WARNING: mm/vmalloc.c:3937 at vmalloc_fix_flags+0x6c/0xa0
"Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 
(GFP_KERNEL|__GFP_ZERO). Fix your code!"

Call Trace:
[  523.921345] Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to 
gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
[  523.921356] WARNING: mm/vmalloc.c:3937 at 
vmalloc_fix_flags+0x6c/0xa0, CPU#69: (ostnamed)/6500
[  523.921365] Modules linked in: rpcrdma rdma_cm iw_cm ib_cm ib_core 
kvm_hv kvm bonding rfkill binfmt_misc pseries_rng vmx_crypto nfsd 
auth_rpcgss drm nfs_acl lockd grace loop drm_panel_orientation_quirks 
vsock_loopback vmw_vsock_virtio_transport_common vsock zram ext4 crc16 
mbcache jbd2 sr_mod sd_mod cdrom ibmvscsi ibmveth scsi_transport_srp 
btrfs blake2b libblake2b xor raid6_pq zstd_compress sunrpc dm_mirror 
dm_region_hash dm_log be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls libcxgbi 
libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi i2c_dev dm_multipath fuse dm_mod nfnetlink
[  523.921485] CPU: 69 UID: 0 PID: 6500 Comm: (ostnamed) Kdump: loaded 
Tainted: G        W           6.18.0-rc6-next-20251117 #1 VOLUNTARY
[  523.921504] Tainted: [W]=WARN
[  523.921511] Hardware name: IBM,9824-42A Power11 (architected) 
0x820200 0xf000007 of:IBM,FW1110.00 (RB1110_082) hv:phyp pSeries
[  523.921523] NIP:  c00000000063f8fc LR: c00000000063f8f8 CTR: 
00000000005d7e44
[  523.921537] REGS: c0000001ad0f78e0 TRAP: 0700   Tainted: G        W   
          (6.18.0-rc6-next-20251117)
[  523.921544] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 
2824222f  XER: 0000000a
[  523.921564] CFAR: c00000000023225c IRQMASK: 0
[  523.921564] GPR00: c00000000063f8f8 c0000001ad0f7b80 c0000000017f8100 
0000000000000069
[  523.921564] GPR04: 00000000ffff7fff c0000001ad0f7970 00000027f9c50000 
0000000000000001
[  523.921564] GPR08: 0000000000000027 0000000000000000 0000000000000000 
0000000000000003
[  523.921564] GPR12: c0000000028fe748 c0000027fde3c300 0000000000000000 
0000000000000000
[  523.921564] GPR16: 0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  523.921564] GPR20: 0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  523.921564] GPR24: c000000001711608 0000000000000000 0000000000000000 
c0000001270c7858
[  523.921564] GPR28: 0000000000000000 0000000000000dc0 0000000000010000 
0000000000400000
[  523.921626] NIP [c00000000063f8fc] vmalloc_fix_flags+0x6c/0xa0
[  523.921631] LR [c00000000063f8f8] vmalloc_fix_flags+0x68/0xa0
[  523.921636] Call Trace:
[  523.921639] [c0000001ad0f7b80] [c00000000063f8f8] 
vmalloc_fix_flags+0x68/0xa0 (unreliable)
[  523.921646] [c0000001ad0f7c00] [c00000000064a7a0] 
__vmalloc_noprof+0x90/0xa0
[  523.921653] [c0000001ad0f7c80] [c0000000004addf4] 
bpf_prog_alloc_no_stats+0x54/0x270
[  523.921660] [c0000001ad0f7cd0] [c0000000004ae03c] 
bpf_prog_alloc+0x2c/0x130
[  523.921665] [c0000001ad0f7d10] [c000000000f39d24] 
bpf_prog_create_from_user+0x74/0x180
[  523.921673] [c0000001ad0f7d80] [c0000000003f2400] 
seccomp_set_mode_filter+0x1e0/0x790
[  523.921690] [c0000001ad0f7e10] [c000000000033758] 
system_call_exception+0x128/0x310
[  523.921701] [c0000001ad0f7e50] [c00000000000d05c] 
system_call_vectored_common+0x15c/0x2ec
[  523.921716] ---- interrupt: 3000 at 0x7fffa8750d3c
[  523.921725] NIP:  00007fffa8750d3c LR: 00007fffa8750d3c CTR: 
0000000000000000
[  523.921737] REGS: c0000001ad0f7e80 TRAP: 3000   Tainted: G        W   
          (6.18.0-rc6-next-20251117)
[  523.921750] MSR:  800000000280f033 
<SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 44244224  XER: 00000000
[  523.921775] IRQMASK: 0
[  523.921775] GPR00: 0000000000000166 00007fffeec77650 00007fffa8837c00 
0000000000000001
[  523.921775] GPR04: 0000000000000000 00000001524c2af0 0000000000000000 
0000000000000000
[  523.921775] GPR08: 0000000040000000 0000000000000000 0000000000000000 
0000000000000000
[  523.921775] GPR12: 0000000000000000 00007fffa9571520 00007fffeec77a90 
000000013fa85300
[  523.921775] GPR16: 0000000000000001 0000000000000000 000000013fa8a610 
0000000000000093
[  523.921775] GPR20: 000000007fff0000 000000013face248 0000000152102d28 
000000007ffffffe
[  523.921775] GPR24: 0000000000050026 0000000000050001 0000000000000092 
00000001524c4e30
[  523.921775] GPR28: 000000013fae0088 00000000c0000015 0000000000000000 
00000001524c4e30
[  523.921835] NIP [00007fffa8750d3c] 0x7fffa8750d3c
[  523.921841] LR [00007fffa8750d3c] 0x7fffa8750d3c
[  523.921850] ---- interrupt: 3000
[  523.921857] Code: 79440020 79260020 38e1006c 38a10074 9101006c 
e90d0c78 f9010078 39000000 91410074 9121006c 4bbf2885 60000000 
<0fe00000> e9410078 e92d0c78 7d4a4a79
[  523.921882] ---[ end trace 0000000000000000 ]---


Reported-by: Misbah Anjum N <misanjum@linux.ibm.com>

Regards,
Misbah Anjum N

