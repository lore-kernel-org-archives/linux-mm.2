Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090C2FD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6F26B0088; Tue, 10 Mar 2026 16:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CAE6B0089; Tue, 10 Mar 2026 16:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61E16B008A; Tue, 10 Mar 2026 16:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0AEC6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:16:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 729181B6D12
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:18 +0000 (UTC)
X-FDA: 84531260436.30.6D23461
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB39B18001B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=hSQTQIrz;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LPZ7K6MI;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ThtO4ff3serJ2iRkNz/z2ChnYrwEifPTaTN5R0YXvFU=;
	b=guQgiTOTINHhMKomVggWl+/8J5o1TFUib2KdCqdNwYVjH8U1xFLAfJoJeGBFL3VQ2q1Im5
	1WZ1+4UwPUqx0v3j897/KU7I/M/Z1D09j/sb853/D61zvrBCR4TuFRVuIFTLFXs7UIr6UW
	OYg/jRIKhoUtUe5h1XR3EOoNGZZcrHg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=hSQTQIrz;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=LPZ7K6MI;
	spf=pass (imf06.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173776; a=rsa-sha256;
	cv=none;
	b=rzOvq5G/lPZXYIWTgK02G5gv+w1hpR6DdrU3nYuoqCiRwXlMiUTE2eLMFrnJsqquluaTdG
	ZZ8hUPVPIpHc60srzToJgosMzmZkAuWFrh5/1nI7RBqOiwlPdoZ4LM3GFEMOLQHfOikHeh
	d6lXbha1OadyaDM7SJa2hyhZ4xPl2BY=
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIu6lC303796
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ThtO4ff3serJ2iRkNz/z2C
	hnYrwEifPTaTN5R0YXvFU=; b=hSQTQIrz6fM7mQ9FBakAJiHU2KaUO4xKFdeWN9
	6nB8U8OhZDPqKzSpb4632Nkik7LDJxJ8XHt0CSsujXkhisIiShgPlBtKoF3hNaK6
	rjWGQsDzt0kHjfohOtzseFBYpuUaqvYe66Af+qj6RkOrSA2Q7F88PkYW5+J3U8D0
	Tgcnaj54t21qbjrG0HMOl5j1Zji+mAUosy3VNpQGLJUz26I3M/1EOBQuGBjm7I96
	TATJRuy6eIjZ5G2rg+D9YlsovD3CDNNhALtCazGAyHlF3SfvPjBVIJXdobxUFj1E
	lR18/+IeDdw2KCXqUEGcb0Zidx0qZSXjBNodX35OdMFyfB3g==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cthjf2aqc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:16:14 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829bf6406ecso9821378b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773173773; x=1773778573; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ThtO4ff3serJ2iRkNz/z2ChnYrwEifPTaTN5R0YXvFU=;
        b=LPZ7K6MIIGA7WhZSyxkHodv0WvIQyIl+5KONB98pxhw7/eutuEC1j8tzX+GIliS1+0
         ghS+Xw8BEHc6RpTE/8q0oyr3efZLUuHFkZZYFCp3KgYPVA77TnKppTGQdI1hjfjKxNUw
         l7B1PFNCMfilpQl6PE9c4qa2EJOWwZrBJxfgLJDs1o9mdELtU6TzN0XhS7OzSZK/MBGC
         VeClh0zOHIFuOJS0wUgytIQdaeBuKIPYiC4aKM/xD8m9IqD8/hXwV8cEliIOyIfl0vS6
         LaRSYATtwFHWbEIZy33S1Yc4dzl7pCtsgL1c1iJhLpDYUfLzUJH4rHYQ5R9O435ei1po
         ErZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773173773; x=1773778573;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThtO4ff3serJ2iRkNz/z2ChnYrwEifPTaTN5R0YXvFU=;
        b=gc2Aa2UZopBMrw3v97xSfI6HlIdNxpT+rQ0e3K5IS03k0AOGifSs4cZjuLor4g3MVI
         SH5wUKuMoN/0aLAMDjgr/g33CQU6qs8eaNVEceNcNPM4eeGfKjJB099ow2ZVyNGTCW1o
         X5P4a9fpcY+CpeClFm6Eb2KxS5KHFDyR1PW9SgGpSvPpl3Jtry1gLHzZzbKDbCI5j8dx
         cLZ4nPb82HstehIPGp64hkBwWzEP57V9TiMgvQrSRbf2zrLFu03aMmUNf/YM9izZyoBJ
         IkRFUt5q+/T2X0r1Jtosdi6XCKpdT8D5EzAIFh6/e/a8ti0bijryPq1R7gW2YE2Fk2RF
         h0QQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9Tf3r1o2BHEogyvvJnhSFJnP+3+3zucmClSqkR/Hcm9BT+gRhUy0EprWVYxPFC0n1uOAHj8VAIg==@kvack.org
X-Gm-Message-State: AOJu0YyLCWaRCucsYctuAdtlduDmj9p6tymLXfgn7wo9FmEgjLvdDoiE
	YQM/53x6XEugMHcPuqVMLL3IVpo0RwZg9r9vrlAU3lKw8Fo+h5yRIuj2p3ZnPQJMaL5fpfbrHPI
	+vj9TBRd6KmxeI+qKN9/Sb5sgwgwvO+sL9JvPb1CI0NcefXKq3itrRg==
X-Gm-Gg: ATEYQzxKMgmOXviv3MqzJXZYXeuxyc0MasfV8r/Ov9YCzoXfak9RjtlGZE38exrpZSt
	yCno6Uzcam07toxNjszKSRmu+i/jeFM0BD6Raj8rXJrWuST76Xj8tVPJ35Y4u+hCLQ/FFlrf03X
	iwA252XWTjmTGQZsa/jrUwcaTaj7oy4LncjztA+oZxW8yqJoRKDwA31dUGrrBSn/UFlEKTPY54e
	jgGl43bSpUMHOVJK8/7HFnu8tN17uFBs1w3Bh+6OpgGuDEQANJr42p8k4W4sSwWbKKx0M/kUgUD
	6T7bRX8nhHbAVNrIOCNkkTYaZ1stPMHlViYgeSyFaHr8vol7vUO1WIr1aHp+6YajQl9WWA4hq4l
	4fk/WyvyLIfql4zlkxhJPEGXLSR2n7jHD6/oYXWSCcWvl/IIG
X-Received: by 2002:a05:6a00:2350:b0:829:7a37:2bd2 with SMTP id d2e1a72fcca58-829f708a42dmr154388b3a.32.1773173772373;
        Tue, 10 Mar 2026 13:16:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:2350:b0:829:7a37:2bd2 with SMTP id d2e1a72fcca58-829f708a42dmr154331b3a.32.1773173771531;
        Tue, 10 Mar 2026 13:16:11 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:16:11 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Subject: [PATCH v2 00/25] Introduce meminspect
Date: Wed, 11 Mar 2026 01:45:44 +0530
Message-Id: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPB7sGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDY0ND3dzMvMyU0twC3TIj3dTUFIuURDMT8+RUUyWgjoKi1LTMCrBp0bG
 1tQCvVsxvXQAAAA==
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <eugen.hristev@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=15333;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=HsJWsaLIR7nlFJIMLlfM97huCJCOsOaJj9GJCCHxsbw=;
 b=GYFA3GGf90pN1s+AgXrT987m/HkJIgWDtfiElDelGeVa7vE2WF/4VfyYg7rukbtWH98n3JyPi
 clOAMzgTL+dBW7UK+DlU7Jiaf4sbl0GOUynL4QYEe1ApcL6YIW3b6DG
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: WeSRbID94wJO8NYByqixAzX0UOdBojrQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NiBTYWx0ZWRfX4CzA333K9U1a
 niNP18Xp7NWd4NCppG1pW1w3Hf5tNcS5GoTIs/aiRgZsFBInIH7vpOmZcrYtPjcyg6NGyq1OJpL
 SvQ1pY/jU9Fn9BNBAevdAZU2R7Uixh9o1s25l0QzlFW6iT7D8Ww+KxzKqQTXHU1kDcOTXAhXucn
 0nkQ+YM50JfFUX29okwWf9i2wWqTO0OtadnsX5wXfjnkt1U7Oco3IfCshIcZsesS1WWLCWK+AMg
 +fz+4hqiG7gmIwxF4vZdFLlyN/QquijA4R1dZB+v17N7cIquWCJtzIX8/Lbjardis1IThExWjhC
 Rh3nnhbcTUiCS/QtUawotXSNBfzym9muUsMWG6rxcOYcE8SCXRP9XsYGBJ5vcYyOYVTr04Rnth1
 pQqqvSK3/CY2sy9N/0cqm9WamxzGXXbr12UHD9HPzu+MxLrsm+M+10VRLycfVh88U7SZ8fTcnsA
 CvLuh5uy5iFKsByOOmQ==
X-Authority-Analysis: v=2.4 cv=A71h/qWG c=1 sm=1 tr=0 ts=69b07c0e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=vnREMb7VAAAA:8 a=Oh2cFVv5AAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8
 a=COk6AnOGAAAA:8 a=bLXd17yOAAAA:8 a=1XWaLZrsAAAA:8 a=Bnchvpk6DWnDitF8NakA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22 a=7KeoIwV6GZqOttXkcoxL:22
 a=cvBusfyB2V15izCimMoJ:22 a=TjNXssC_j7lpFel5tvFf:22 a=XOuVWTVwyKTMzSnUH6Op:22
X-Proofpoint-ORIG-GUID: WeSRbID94wJO8NYByqixAzX0UOdBojrQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1011 suspectscore=0 bulkscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100176
X-Rspamd-Queue-Id: AB39B18001B
X-Stat-Signature: egf74w41yuncxc6xeg6uyucfejg64utt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773173775-845929
X-HE-Meta: U2FsdGVkX1/YQc/xMCUJ2STGMbacomnYIvn06ndpDxoxbXADRQ6j7wQ9HsHwW8tbieedCOyewfUVpCtiS7vdGVvB3dTflf7i1LPoRA4MLEsNg/Ja5ltepCB+Zw4cnIHpDnyrZo+uCjnDfPcc0Z/7hBwgmlNMHrfD7b2VezK+32hSZ/fklNM/pWooOsyCR73S0t8zoFcDM3FQt8jBP4r8Ymq25hHFYO5qFdzxFzqa9Wmh3ePV7KFMKOFBDZNCMQRwhxvw1U+R3FgArexAWaBpGtslCKaEmHEHQSinF8TKU7IzzR7kFVFhV3LkEGW+Z5zVkdR3i2+odE9LuBsDUpFLF5wLHpYId5Ew7azFE5pnivWliGmp+xGQ2WwFdNYGjb6PRX/hvaD+EHzwcRqAqCkhZh762I4s9x+CkiND+kE23r8ZOjaSAXZFUUUdUg1TYPtzYIlBh0mK5ChvilsEyAfDazX/aR/MF2WHots++SWgkVyyc4UzSdxkXa9GwAuNfFZaC7qEW3G6EYCwA+bGEnhpWCdRCjXnMEpbFtGBjVDFLOyxqAby6rbpMYNwy0c/zVlpdgRajiX0fRICpMWUpsQgF5gAzVZzqxZA/2lHMRn/+wk6zMmzqTuTwEoCg78tSkfRFGuS+/SrpOgdQr5gXr/B4gYRndZgoYqkBkY38PHtNfyyX/YTcgqOmD0FXGTiiPDcE0KcvFQpoNd5IA/dT4Kma+H1cK5lkHEHuQC5UZEe9TwRk3QUPf7khuLb2d935JUZmMKdC8sN+aq9DYpxayEDfrqp9zzNPMVC4G5WC2rFBLdmt0hdxaAHbVsbX1Pza01zeYH9W6OktrTEH6tm8Dvli3znSTqmIbTBEHzFx8ywswk5CeG1PqLzRCap6Vak6WiyDusQRVYlrVTXgqKD5L9PQ5NUqa1+ifMYHI4XJ0MvFtH3vSabHhpb6jaYlqJkwFMcsOOmng+6BChcADAB/pB
 TK5hbqur
 FaPIxwbB9qRfytE9VFhj7WLbKW6MuJvcnTZmjnG2LiEhq/GSc1JonkoXg1OgMwBnL7GGy8ueYfWFIhNQkFbPH2o/us+quKVBgq5wWYpRNq1l1rJ6vLQfgUbIJa9SS1vEPwceJFnPeZYIhT1eHY5ntboXaIg01YgwPbKbdK1FmeUm5eSd9FoRtZ7hA+P4YRdQ8+nf+pFg3tYRjt/ZNWZtXXXx7h1TFok/nXy9G2JCsU85A/j7dpZpudIHewwcDV4pvvX3p2ZYe9uhbR5DpdXRFUOC9s3WQ9o9p5lhbZVmj+1lnioGKnWNj5o20/naTIyIof+/kMmtrBXD5YLsJTFYrrJOmCV4cW9P1Xa4rxuDfTPL8kVy0ub+OQ5ULPLyAMhiguIIHv2NLuKa9RXb2LceyFZMURhByR+jFv7X1RB7uMteErDgL3kzDZNI0f3wsBae+5KDBpWhulWcrBmOBCrrHhZvA4l1OIfGlAToKLQYPw2Zq/Jkmz6oQ4X7hdU3eXKysjGYr0koPAS2Vcw2qbcKoR6C1zi8l19F6JJ3V8Yx6qYZsMXJEVdtsXtugaUciWWbd2EZiyvLr2qUa3Wi7h05MF/3QXEudzstkqB2VozrFyjBIiL4Yz+PzS351Qn+nzKmDRZa8nP0HYr3xwtIZPkLfVRHRBJ1CH2+Caxjn+SrmfJLB/QiwYzf37H8H1iV4v75H5QWaiJ2FTl5OOjA/Cc4bKM8QU2rDZf+w54fvnmPhbKlA8ST8fLZk37Yeza2imjnoLBUQ2pRINelSQJOJLO0zt24ErFX7U3Qsm7uSw35L14d6VMFnZIPfLSj06waWR6dnVyII6eA5AjxgSn8DBhfduVWCc7Q1khAKgDtIOJknF41GcZdjwkf1orlGSliV0xPeqDfx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First of all, I want to thank Eugene for his excellent work on this
series. What began as the Qualcomm Minidump driver from me has now
evolved into meminspect. He also presented meminspect a few months ago
at Linux Plumbers 2025.

Video of the recording is available here for anyone interested:
https://www.youtube.com/watch?v=aDZv4-kOLSc

Introduction:

meminspect is a mechanism which allows the kernel to mark specific
memory areas for memory dumping or specific inspection, statistics,
usage.  Once regions are marked, meminspect keeps an internal list with
the regions in a dedicated table.  Further, these regions can be
accessed using specific API by any interested driver.  Regions being
marked beforehand, when the system is up and running, there is no need
nor dependency on a panic handler, or a working kernel that can dump the
debug information.  meminspect can be primarily used for debugging. The
approach is feasible to work when pstore, kdump, or another mechanism do
not.  Pstore relies on persistent storage, a dedicated RAM area or
flash, which has the disadvantage of having the memory reserved all the
time, or another specific non volatile memory. Some devices cannot keep
the RAM contents on reboot so ramoops does not work. Some devices do not
allow kexec to run another kernel to debug the crashed one.  For such
devices, that have another mechanism to help debugging, like firmware,
kmemdump is a viable solution.

meminspect can create a core image, similar with /proc/vmcore, with only
the registered regions included. This can be loaded into crash tool/gdb
and analyzed. This happens if CRASH_DUMP=y.  To have this working,
specific information from the kernel is registered, and this is done at
meminspect init time, no need for the meminspect users to do anything.

This version of the meminspect patch series includes two drivers that
make use of it: one is the Qualcomm Minidump, and the other one is the
Debug Kinfo backend for Android devices, reworked from this source here:
https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
written originally by Jone Chou <jonechou@google.com>

*** History, motivation and available online resources ***

The patch series is based on both minidump and kmemdump previous implementations.

After the three RFC kmemdump versions, considering the ML discussions, it was decided to
move this into kernel/ directory and rework it into naming it meminspect, as Thomas Gleixner
suggested.

Initial version of kmemdump and discussion is available here:
https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/

Kmemdump has been presented and discussed at Linaro Connect 2025,
including motivation, scope, usability and feasability.
Video of the recording is available here for anyone interested:
https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14

Linaro blog on kmemdump can be found here:
https://www.linaro.org/blog/introduction-to-kmemdump/

Linaro blog on kmemdump step by stem using minidump backend is available here:
https://www.linaro.org/blog/kmemdump-step-by-step-on-qualcomm-automotive-platform/

The implementation is based on the initial Pstore/directly mapped zones
published as an RFC here:
https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/

The back-end implementation for qcom_minidump is based on the minidump
patch series and driver written by Mukesh Ojha, thanks:
https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/

The RFC v2 version with .section creation and macro annotation kmemdump
is available here:
https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/

The RFC v3 version with making everything static, which was pretty much rejected due to
all reasons discussed on the public ML:
https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/

*** How to use meminspect with minidump backend on Qualcomm platform guide ***

Prerequisites:
Crash tool compiled with target=ARM64 and minor changes required for
usual crash mode (minimal mode works without the patch) **A patch can be
applied from here https://p.calebs.dev/1687bc ** This patch will be
eventually sent in a reworked way to crash tool.

Target kernel must be built with : CONFIG_DEBUG_INFO_REDUCED=n ; this
will have vmlinux include all the debugging information needed for crash
tool.

Also, the kernel requires these as well: CONFIG_MEMINSPECT,
CONFIG_CRASH_DUMP and the driver CONFIG_QCOM_MINIDUMP

Kernel arguments: Kernel firmware must be set to mode 'mini' by kernel
module parameter like this : qcom_scm.download_mode=mini

After the kernel boots, and minidump module is loaded, everything is
ready for a possible crash.

Once the crash happens, the firmware will kick in and you will see on
the console the message saying Sahara init, etc, that the firmware is
waiting in download mode. (this is subject to firmware supporting this
mode, I am using sa8775p-ride board)

Example of log on the console:
"
[...]
B -   1096414 - usb: init start
B -   1100287 - usb: qusb_dci_platform , 0x19
B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
B -   1107455 - usb: usb2phy: PRIM success , 0x4
B -   1112670 - usb: dci, chgr_type_det_err
B -   1117154 - usb: ID:0x260, value: 0x4
B -   1121942 - usb: ID:0x108, value: 0x1d90
B -   1124992 - usb: timer_start , 0x4c4b40
B -   1129140 - usb: vbus_det_pm_unavail
B -   1133136 - usb: ID:0x252, value: 0x4
B -   1148874 - usb: SUPER , 0x900e
B -   1275510 - usb: SUPER , 0x900e
B -   1388970 - usb: ID:0x20d, value: 0x0
B -   1411113 - usb: ENUM success
B -   1411113 - Sahara Init
B -   1414285 - Sahara Open
"

Once the board is in download mode, you can use the qdl tool (I
personally use edl , have not tried qdl yet), to get all the regions as
separate files.  The tool from the host computer will list the regions
in the order they were downloaded.

Once you have all the files simply use `cat` to put them all together,
in the order of the indexes.  For my kernel config and setup, here is my
cat command : (you can use a script or something, I haven't done that so
far):

`cat md_KELF1.BIN md_Kvmcorein2.BIN md_Kconfig3.BIN \
md_Ktotalram4.BIN md_Kcpu_poss5.BIN md_Kcpu_pres6.BIN \
md_Kcpu_onli7.BIN md_Kcpu_acti8.BIN md_Kmem_sect9.BIN \
md_Kjiffies10.BIN md_Klinux_ba11.BIN md_Knr_threa12.BIN \
md_Knr_irqs13.BIN md_Ktainted_14.BIN md_Ktaint_fl15.BIN \
md_Knode_sta16.BIN md_K__per_cp17.BIN md_Knr_swapf18.BIN \
md_Kinit_uts19.BIN md_Kprintk_r20.BIN md_Kprintk_r21.BIN \
md_Kprb22.BIN md_Kprb_desc23.BIN md_Kprb_info24.BIN \
md_Kprb_data25.BIN  md_Khigh_mem26.BIN md_Kinit_mm27.BIN \
md_Kunknown29.BIN md_Kunknown30.BIN md_Kunknown31.BIN \
md_Kunknown32.BIN md_Kunknown33.BIN md_Kunknown34.BIN \
md_Kunknown35.BIN md_Kunknown37.BIN \
md_Kunknown38.BIN md_Kunknown39.BIN md_Kunknown40.BIN \
md_Kunknown41.BIN md_Kunknown42.BIN md_Kunknown43.BIN \
md_Kunknown44.BIN md_Kunknown45.BIN  md_Kunknown46.BIN \
md_Kunknown47.BIN md_Kunknown48.BIN md_Kunknown49.BIN \
md_Kunknown50.BIN md_Kunknown51.BIN md_Kunknown52.BIN \
md_Kunknown53.BIN md_Kunknown54.BIN   > ./minidump_image`

Once you have the resulted file, use `crash` tool to load it, like this:
`./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`

There is also a --minimal mode for ./crash that would work without any patch applied
to crash tool, but you can't inspect symbols, etc.

Once you load crash you will see something like this :
      KERNEL: minidump/20260310-235110/vmlinux  [TAINTED]
    DUMPFILE: ./minidump/20260310-235110/minidump_image
        CPUS: 8 [OFFLINE: 7]
        DATE: Thu Jan  1 05:30:00 +0530 1970
      UPTIME: 00:00:27
       TASKS: 0
    NODENAME: qemuarm64
     RELEASE: 7.0.0-rc3-next-20260309-00028-g528b3c656121
     VERSION: #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026
     MACHINE: aarch64  (unknown Mhz)
      MEMORY: 0
       PANIC: "Kernel panic - not syncing: sysrq triggered crash"

crash> log
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x514f0014]
[    0.000000] Linux version 7.0.0-rc3-next-20260309-00028-g528b3c656121 (@21e3bca4168f) (aarch64-linux-gnu-gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, GNU ld (GNU Binutils for Ubuntu) 2.42) #5 SMP PREEMPT Tue Mar 10 18:18:41 UTC 2026

*** Debug Kinfo backend driver ***
I need help with the testing of this driver, Anyone who actually wants
to test this, feel free to reply to the patch. we have also written a
simple DT binding for the driver.

Thanks in advance for the review, and apologies if I missed addressing any comment.

-Mukesh 

Changes in v2: https://lore.kernel.org/lkml/20251119154427.1033475-1-eugen.hristev@linaro.org/
 - Fixed doc warnings
 - Fixed kernel-test robot warnings.
 - Took Mike suggestion to remove mark inspect flag for dynamic memory.
 - Added R-b for printk patch.
 - Modified some commit messages for clarity.
 - corrected binding change for debug-kinfo as per Rob suggestion.

Changelog for meminspect v1:
- rename to meminspect
- start on top of v2 actually, with the section and all.
- remove the backend thing, change the API to access the table
- move everything to kernel/
- add dependency to CRASH_DUMP instead of a separate knob
- move the minidump driver to soc/qcom
- integrate the meminspect better into memblock by using a new memblock flag
- minor fixes : use dev_err_probe everywhere, rearrange variable declarations,
remove some useless code, etc.

Changelog for RFC v3:
- V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
- Removed the .section as requested by David Hildenbrand.
- Moved all kmemdump registration(when possible) to vmcoreinfo.
- Because of this, some of the variables that I was registering had to be non-static
so I had to modify this as per David Hildenbrand suggestion.
- Fixed minor things in the Kinfo driver: one field was broken, fixed some
compiler warnings, fixed the copyright and remove some useless includes.
- Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
and it's now available in kernel hacking, as per Randy Dunlap review
- Reworked some of the Documentation as per review from Jon Corbet

Changelog for RFC v2:
- V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
- Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
This means new API, macros, new way to store the regions inside kmemdump
(ditched the IDR, moved to static allocation, have a static default backend, etc)
- Reworked qcom_minidump driver based on review from Bjorn Andersson
- Reworked printk log buffer registration based on review from Petr Mladek

I appologize if I missed any review comments.
Patches are sent on top on next-20260309 tag

---
Eugen Hristev (21):
      kernel: Introduce meminspect
      init/version: Annotate static information into meminspect
      mm/percpu: Annotate static information into meminspect
      cpu: Annotate static information into meminspect
      genirq/irqdesc: Annotate static information into meminspect
      timers: Annotate static information into meminspect
      kernel/fork: Annotate static information into meminspect
      mm/page_alloc: Annotate static information into meminspect
      mm/show_mem: Annotate static information into meminspect
      mm/swapfile: Annotate static information into meminspect
      kernel/vmcore_info: Register dynamic information into meminspect
      kernel/configs: Register dynamic information into meminspect
      mm/init-mm: Annotate static information into meminspect
      panic: Annotate static information into meminspect
      kallsyms: Annotate static information into meminspect
      mm/mm_init: Annotate static information into meminspect
      sched/core: Annotate runqueues into meminspect
      remoteproc: qcom: Move minidump data structures into its own header
      soc: qcom: Add minidump backend driver
      soc: qcom: smem: Add minidump platform device
      meminspect: Add debug kinfo compatible driver

Mukesh Ojha (4):
      mm/numa: Register node data information into meminspect
      mm/sparse: Register information into meminspect
      printk: Register information into meminspect
      dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory

 Documentation/dev-tools/index.rst                  |   1 +
 Documentation/dev-tools/meminspect.rst             | 144 +++++++
 .../bindings/reserved-memory/google,kinfo.yaml     |  46 ++
 MAINTAINERS                                        |  14 +
 drivers/of/platform.c                              |   1 +
 drivers/remoteproc/qcom_common.c                   |  56 +--
 drivers/soc/qcom/Kconfig                           |  13 +
 drivers/soc/qcom/Makefile                          |   1 +
 drivers/soc/qcom/minidump.c                        | 272 ++++++++++++
 drivers/soc/qcom/smem.c                            |  10 +
 include/asm-generic/vmlinux.lds.h                  |  13 +
 include/linux/meminspect.h                         | 263 ++++++++++++
 include/linux/soc/qcom/minidump.h                  |  72 ++++
 init/Kconfig                                       |   1 +
 init/version-timestamp.c                           |   3 +
 init/version.c                                     |   3 +
 kernel/Makefile                                    |   1 +
 kernel/configs.c                                   |   6 +
 kernel/cpu.c                                       |   5 +
 kernel/fork.c                                      |   3 +
 kernel/irq/irqdesc.c                               |   2 +
 kernel/kallsyms.c                                  |   9 +
 kernel/meminspect/Kconfig                          |  30 ++
 kernel/meminspect/Makefile                         |   4 +
 kernel/meminspect/kinfo.c                          | 284 +++++++++++++
 kernel/meminspect/meminspect.c                     | 471 +++++++++++++++++++++
 kernel/panic.c                                     |   4 +
 kernel/printk/printk.c                             |  11 +
 kernel/sched/core.c                                |   2 +
 kernel/time/timer.c                                |   2 +
 kernel/vmcore_info.c                               |   4 +
 mm/init-mm.c                                       |  11 +
 mm/mm_init.c                                       |   2 +
 mm/numa.c                                          |   2 +
 mm/page_alloc.c                                    |   2 +
 mm/percpu.c                                        |   2 +
 mm/show_mem.c                                      |   2 +
 mm/sparse.c                                        |   6 +
 mm/swapfile.c                                      |   2 +
 39 files changed, 1725 insertions(+), 55 deletions(-)
---
base-commit: 343f51842f4ed7143872f3aa116a214a5619a4b9
change-id: 20260311-minidump-v2-eed8da647ce5

Best regards,
-- 
-Mukesh Ojha


