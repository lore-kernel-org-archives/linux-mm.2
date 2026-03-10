Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2146FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D3A6B00BF; Tue, 10 Mar 2026 16:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1B76B00C1; Tue, 10 Mar 2026 16:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFDF6B00C2; Tue, 10 Mar 2026 16:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02DF26B00BF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:22:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5DD6585FC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:39 +0000 (UTC)
X-FDA: 84531276438.07.6234077
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2FA2880002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YlQ5esdA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=a2WZs7gv;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBTkKJ0zn2bqmXnFD9nCGkwAtPEKE3WdpaklXMQPzbc=;
	b=XPUW0My1jcTiUmG8KXxAXLuM+vGntxbnxsFCAtUXKpMzLvD5VBFkFrAvMfsuGxS1U9kZYV
	2JFP7priFirpMxgTp1dWyDXkTXxn4ekJZMEMWH0eI/yNrYNGX0LtbyZK6NQH54HBJyDoT+
	ArdgD+sB1HFWncwF4bhytRLCkHYGWRU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YlQ5esdA;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=a2WZs7gv;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174157; a=rsa-sha256;
	cv=none;
	b=L0TzW9f5451vF+ZfkfNZQcWpBJQRgr6WD0ni+FVcSTnicHJWVXX+0zdAjiOmuiW9cl/QcD
	H2/GD2eXEVO4Qaq3Xf2vwAKnz2AtzCoVWdrGiPWVRQooeR1JidAUx+W+u3ZhMtpKq5Y+XE
	mPw0D1Bd/f8LXwAXu2WEF78XaEir9HA=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AGGvL3508294
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BBTkKJ0zn2bqmXnFD9nCGkwAtPEKE3WdpaklXMQPzbc=; b=YlQ5esdAm3povK5t
	RwQEFi0AuCHHUZHLxolgWMrI2BTdg+umVX70+L8KhFsJi8lJAK5GN7gBXSz7DsmT
	tyO+QeO0EJUwH1sGy8qmT7XypT4oQTbX70UJRcwtbueGwgB7EjaRbjB/fh/quPR3
	oytUcM/biUg/P/0iOc8VOqXQ4xTF29KEvSfkjvqFClkI7zFmVLx9sVZyKiao/EHb
	pOO+uHxv2WTfPh3aQX/KtRc4wmvuZzPE6xE2WJQ882mcWmas5BiEpfrINkNzWoh0
	LXjBaNgwHXq6/hEhhHWsUOFWnq9HA20NBWEAm0swJQG153Lx6YtOT9D7XF08fp1K
	AjlOIQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctppagx8j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:35 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b6097ca315bso58414795a12.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174155; x=1773778955; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBTkKJ0zn2bqmXnFD9nCGkwAtPEKE3WdpaklXMQPzbc=;
        b=a2WZs7gvc4S7WpeDyMql0l9+AL6GZjRxhSFpMY061usKVc22OMl9UIBcz5LYWBixrE
         Tuzpn+GzX4gO+eNZcxij3AyQjzGG2Oqs/56el16z5TAabM84pODzzYfQXccZwsywqawa
         plJnPk1GLGa5e9efpa36IOWIS0dHUqM055jyF6cGW5u52EvH9E2Z8zxl4dqrHFV8oJun
         3GTZF7BxP3n5aj+SwjuXGRwVwlxi5aM3tVjtWWQH/PNy4fN7UF65pIawt1j7if9p5lxl
         ndBELemPl1fWK4H1PKPozHal1Bnddr9+UVIYEwjns2RcNgZoQQiLLq2XMbcgvoixXVSN
         Jh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174155; x=1773778955;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BBTkKJ0zn2bqmXnFD9nCGkwAtPEKE3WdpaklXMQPzbc=;
        b=do6VnrY1BPYXyWxIdZ0LQsWLN8z5OuUzEucxSAonYMOp6W5Jv7j4O0LtczcjiRPSEA
         uIdDp2FNK92pFpD6yHsSAs/uBR8i9LRRAwPmSyId/0tk2tZfkj7FZQ4/Tyc6F+cOXeno
         fireTtKOk16oUAwUSwPMu1XUT+K5431Rqj1HeQjPuNRSunsgHJ/mDAXFsW7hY9wIlWNQ
         gHu/aZQL4GRclGiCldgwebjqXvh6cBayg9qtIWakIrfllAiGsPUE1J06T7wlGOCm9fSy
         vlMIe0Evy+ja8Hh6lcYUZzGPD8O9qOt8UJjmt3AxrgpkU49iBhlzb0v5IarFCZv+DH5Z
         le9g==
X-Forwarded-Encrypted: i=1; AJvYcCWdM+sYG46eBOvP20fWATnGqcZ/UvW+7RLwAB4WeEkq39XWq0wtOYSX5I/GB/Gotf7KSVu58+0JyQ==@kvack.org
X-Gm-Message-State: AOJu0YxZs3DKgis9Dth5dS47i/NDB9iAXNtK/Lnt03y3q+uK3Gr74Spy
	D2TNbbGQQSsRi3g3OGoWq/7xwhKhNDYHm+hvqPxE1HuKswgzerHa+/B4NCoKHhKC7/TeQ0cK1wW
	TXChI9RY+3EKqC8XOguUHsIIKs6jXjGENFKvdKX1ADVARvnvK/BSqvA==
X-Gm-Gg: ATEYQzzy7ZFZ4l//SXJqgHaW34BlyUxIucEjWNsV6Pnb/7o0B4qLuUdjMYGjdXDcIIm
	k6PixsWrwBaC/U+iUeUO3d+oww5qI655btAWykMBfyH5uAug+CiDJXqZ2JQAhYBWIdkH376sygK
	3W54mXWlI79Qh8TMCn+hENvCWi116oEs7s158C3iG4evX5e/zixdhQAuVPgjrMtlga4kGxDQyD8
	+lvb05IhmWBfi+BHwa+77SLC2FfCL54AAei/L4afBhUN0x8rMXOc+WTAegIezwDSvaMyIePRRs+
	KhMuTwB+8ivuXvJUOq6mDB7ekNC1g9T286FESUt3AMBWhEZN5OTBA7CGasqV+elV8EbkGbsl9Xt
	taO5rf+mSDz+SZ8sNJbg8d0wgjlnbks9nYLXT0d0AjZvykOg7
X-Received: by 2002:a05:6a00:e05:b0:81f:994f:cb with SMTP id d2e1a72fcca58-829f6f4197bmr162935b3a.24.1773174154573;
        Tue, 10 Mar 2026 13:22:34 -0700 (PDT)
X-Received: by 2002:a05:6a00:e05:b0:81f:994f:cb with SMTP id d2e1a72fcca58-829f6f4197bmr162874b3a.24.1773174153885;
        Tue, 10 Mar 2026 13:22:33 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:22:33 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:09 +0530
Subject: [PATCH v2 25/25] meminspect: Add debug kinfo compatible driver
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-25-f91cedc6f99e@oss.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
In-Reply-To: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=10702;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=Fu2ZccKszsPFIW3mDDx78KzoZ/M2bBq595MQ+50ea4g=;
 b=Dq9aTau7pWS5++jEPermlk3PyA3u5vLiCYy56l/N6byo6Ehs5O+0mqEVX/Lzflw4sAFjgvESE
 o6sqrCyzWrlDex4eKcMQ1XncjJn+anEBgfVLSWSIY1dLgBGNLhUvjv3
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: vU95rrxkJ_9h7tRzDngxTIQJ_7FwmInH
X-Authority-Analysis: v=2.4 cv=D7BK6/Rj c=1 sm=1 tr=0 ts=69b07d8b cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Tty9oNO6AAAA:8
 a=1XWaLZrsAAAA:8 a=pdfXsOUTzs8LjTHvc20A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=cvBusfyB2V15izCimMoJ:22 a=Bts-Es6F1CBXvF7u4C_G:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3OCBTYWx0ZWRfX9ViqaYpkRm6Y
 q2Nxv1Fbl65QiYwhsumulvsOCBRvdXlei/61mygaAS38BU2eEE/THq3z4mBo8cvNxU7qjzkP+p/
 J9V9y87vaSXk0+SgvG0MyxHZaaOAptoKc9i5nxabMMPeYpGE2M2pvNhz+qMyv+5MJdTkp7Xyv0/
 +rzN1qzmD/geTZlG+ar3hpHrGy15ZXgO4D8EGqx8j0thI1AWrJZ2iZOjW5ugjZB9Lhfmzo70Cdf
 QkQ6mVZTUDyujreuKbIb1/MTM3wYnMFcIJ63bzGW0tncHQLMVSlTbUsFEz1D6zfqGWNU3ctdi/+
 TEtFJLYLuHRXANpthJ3DwJJzZf7RgcqueJUkv41N33ee3jnHgNQMvWznC7G3iQ+2+ikcxC8M76m
 pzLZjSBkGmdFqPE+lm5RG7nVsLxq36PxGiVB9euLs8nw0z2zpYaJKtsd8Hu4DAcCO7jQMWwLi0s
 cTZ3NbVQUWGL7q+fnMA==
X-Proofpoint-ORIG-GUID: vU95rrxkJ_9h7tRzDngxTIQJ_7FwmInH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100178
X-Stat-Signature: e5dtyxwe1enzx3ap9bppq7x8u9drj9sb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FA2880002
X-HE-Tag: 1773174156-52831
X-HE-Meta: U2FsdGVkX18GwFsB4qXvusNtT1r4rGz5pkG2acqwEkbYPxFQ47beffN7yxIvN6SbAzw6vp6CTnnqYMkZINC+oq0FZMr+b84dlj0fVODh9YBbiSIGUMUDkPffY5EIItbqmSQoN9M1Fd1dMcBAhA++zjjPUlpX98uuslcZkZ4RqaEdv5m/Z9yA37ROFfVY1CBELDlyH5CRUW+G49zbsF6BEfVNC1B7FZsVMc4Ttk5nHVUFMWuou6atXnrL8cgj+1PQk/49BpD0qJGEiok86gU7ETsbiLDl0FeVpASIDmQp07HioUoiGwVV3nbDr/nFoPpfsE9d6L/GOsPc8BSaQPVrwG/7WQMYEnn6Sts7YcZz0EsWa2zzH/YPalxvoVqeVA7nDmJjSUnwMPhfvF7szYyJXyUTolVcn74z3rT5E8P9tBSt9xE9oUR+apbFQq3rm/XGfegkaJ4t9SWdHHPrJUrBI/qU8PP9JbsC6KMT73+GEuQwjlND1vjfpO14iQqxdeOpHirenBd3TsIej1O9VGEnAxXy0l1HrKTA7xh+IQKJ/dlCRnvQnNiWG6AKGwvlM+EHNAVjPUPC5+TOcyAu+7xTM/RjWx+su+pGd4kaQtKDDqsoKKdOmqtcZgY7dreW2aGMLduDRVQIHOoqdtjXPvHxFl0q853WKRYb3rXOpoBGsaGmv/gLKjS2j0D9QMDN94Waxt/RDvB27Di27+U5NhHq1DY+2/JUG8X7ghO40Q4LQjTBAeNPb4pwmKZFwYP86AKePGGJIW+FeEEYwg9re4iwALmhuCgU3ovrgKax6XQULW4wFq1654/5nXKIbf9BsecnPiIqGezOYlwdyy2FGna+31IHM+et2aY/9q7p6hl/ffZHc4AZ8x8AGmgmZASb19VUN6fT9hsb7K8SefnylQ9HiNG7dSUd0uIeoMhknkktuknPI61RJ2nQKc7lhLuc3kcEQbc8M2hCOBiHz0Li1KD
 BGOCXHzL
 1fxsXkEbh2JHFR18ZndxZHRIe66U6Pk//W/gW/UemGNToF2V2aJ0OTDzuyzUFLLrXBDkm/85oE5h383yvYRsWALV7uAs+xBQyJotjoQid2PiVgxER4Gm3ZBXZJUCFpB13/t6e7g8IzQyHji/+swnf4VnjxpNq64tDioC8AgtKR/079sjzFIXXJfUh060Y1cdRDtbW2fzmWz89xOP4kmq26BXsfXpEQz2oyD1n64+bPvqdL/3VYNX3IVMAWTBz9aU6NbwSVvnVOaEu9LtZTvXytvB/VkZHRDv5mf3SQgZocqHBNLl7G0XHoF4Micnk7k7JL28mNPvLGy4xT0UR0nFyG9Wgfqu04pXes9to1awNlRDnrQ072P+DNR4vdQ2wDcQQTGpDB+PbE+LMYH7LfV3T9HQMMvkaR+2sQ1JfU8r5fveoeJ4sdq/fFFuMnD/JSgNg39/4nLVHldHB9A7owZk2fgOq3w0UXGyCbbCRviJBPSo5F0/7xGimeCG3P9CETHwVnNvj9Vd8XhB3X7EuLUMlaikJl/Z6di9zok3PbxPMYQFok+954aKTxiwqWudkhsCW4c0cYlD2ZNPGb6tTxHRqyIjBaVAQ+sGYvup0FQ53mAtb6tdsD6HowsN3E8fSznSGdtsvFcF3x1gBZEJGs1gCahYse1GDbVOPYXh77TAraxt1RkCM+FA3uHonURuMzD99FEpcGMLo2SGrAdJ4Bm/s9VW1mi8uP7hDQ6qh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

With this driver, the registered regions are copied to a shared memory
zone at register time. The shared memory zone is supplied via OF. This
driver will select only regions that are of interest, and keep only
addresses. The format of the list is Kinfo compatible, with devices like
Google Pixel phone. The firmware is only interested in some symbols'
addresses.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 MAINTAINERS                |   1 +
 drivers/of/platform.c      |   1 +
 kernel/meminspect/Kconfig  |  11 ++
 kernel/meminspect/Makefile |   1 +
 kernel/meminspect/kinfo.c  | 284 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 298 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2504b7df0e7d..48b5457fae98 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16597,6 +16597,7 @@ M:	Eugen Hristev <eugen.hristev@linaro.org>
 M:	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
+F:	kernel/meminspect/kinfo.c
 
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 2a7111e8354d..09047e021de4 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -495,6 +495,7 @@ static const struct of_device_id reserved_mem_matches[] = {
 	{ .compatible = "ramoops" },
 	{ .compatible = "nvmem-rmem" },
 	{ .compatible = "google,open-dice" },
+	{ .compatible = "google,debug-kinfo" },
 	{}
 };
 
diff --git a/kernel/meminspect/Kconfig b/kernel/meminspect/Kconfig
index fa2b5a84b251..396510908e47 100644
--- a/kernel/meminspect/Kconfig
+++ b/kernel/meminspect/Kconfig
@@ -17,3 +17,14 @@ config MEMINSPECT
 
 	  Note that modules using this feature must be rebuilt if option
 	  changes.
+
+config MEMINSPECT_KINFO
+	tristate "Shared memory KInfo compatible driver"
+	depends on MEMINSPECT
+	help
+	  Say y here to enable the Shared memory KInfo compatible driver
+	  With this driver, the registered regions are copied to a shared
+	  memory zone at register time.
+	  The shared memory zone is supplied via OF.
+	  This driver will select only regions that are of interest,
+	  and keep only addresses. The format of the list is Kinfo compatible.
diff --git a/kernel/meminspect/Makefile b/kernel/meminspect/Makefile
index 09fd55e6d9cf..283604d892e5 100644
--- a/kernel/meminspect/Makefile
+++ b/kernel/meminspect/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_MEMINSPECT) += meminspect.o
+obj-$(CONFIG_MEMINSPECT_KINFO) += kinfo.o
diff --git a/kernel/meminspect/kinfo.c b/kernel/meminspect/kinfo.c
new file mode 100644
index 000000000000..79918908968d
--- /dev/null
+++ b/kernel/meminspect/kinfo.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
+ * Copyright 2021 Google LLC
+ * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
+ */
+#include <linux/container_of.h>
+#include <linux/kallsyms.h>
+#include <linux/meminspect.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_reserved_mem.h>
+#include <linux/platform_device.h>
+#include <linux/utsname.h>
+
+#define BUILD_INFO_LEN		256
+#define DEBUG_KINFO_MAGIC	0xcceeddff
+
+/*
+ * Header structure must be byte-packed, since the table is provided to
+ * bootloader.
+ */
+struct kernel_info {
+	/* For kallsyms */
+	u8 enabled_all;
+	u8 enabled_base_relative;
+	u8 enabled_absolute_percpu;
+	u8 enabled_cfi_clang;
+	u32 num_syms;
+	u16 name_len;
+	u16 bit_per_long;
+	u16 module_name_len;
+	u16 symbol_len;
+	u64 _relative_pa;
+	u64 _text_pa;
+	u64 _stext_pa;
+	u64 _etext_pa;
+	u64 _sinittext_pa;
+	u64 _einittext_pa;
+	u64 _end_pa;
+	u64 _offsets_pa;
+	u64 _names_pa;
+	u64 _token_table_pa;
+	u64 _token_index_pa;
+	u64 _markers_pa;
+	u64 _seqs_of_names_pa;
+
+	/* For frame pointer */
+	u32 thread_size;
+
+	/* For virt_to_phys */
+	u64 swapper_pg_dir_pa;
+
+	/* For linux banner */
+	u8 last_uts_release[__NEW_UTS_LEN];
+
+	/* Info of running build */
+	u8 build_info[BUILD_INFO_LEN];
+
+	/* For module kallsyms */
+	u32 enabled_modules_tree_lookup;
+	u32 mod_mem_offset;
+	u32 mod_kallsyms_offset;
+} __packed;
+
+struct kernel_all_info {
+	u32 magic_number;
+	u32 combined_checksum;
+	struct kernel_info info;
+} __packed;
+
+struct debug_kinfo {
+	struct device *dev;
+	void *all_info_addr;
+	size_t all_info_size;
+	struct notifier_block nb;
+};
+
+static void update_kernel_all_info(struct kernel_all_info *all_info)
+{
+	struct kernel_info *info;
+	u32 *checksum_info;
+	int index;
+
+	all_info->magic_number = DEBUG_KINFO_MAGIC;
+	all_info->combined_checksum = 0;
+
+	info = &all_info->info;
+	checksum_info = (u32 *)info;
+	for (index = 0; index < sizeof(*info) / sizeof(u32); index++)
+		all_info->combined_checksum ^= checksum_info[index];
+}
+
+static u8 global_build_info[BUILD_INFO_LEN];
+
+static int build_info_set(const char *str, const struct kernel_param *kp)
+{
+	size_t build_info_size = sizeof(global_build_info);
+
+	if (strlen(str) > build_info_size)
+		return -ENOMEM;
+	memcpy(global_build_info, str, min(build_info_size - 1, strlen(str)));
+	return 0;
+}
+
+static const struct kernel_param_ops build_info_op = {
+	.set = build_info_set,
+};
+
+module_param_cb(build_info, &build_info_op, NULL, 0200);
+MODULE_PARM_DESC(build_info, "Write build info to field 'build_info' of debug kinfo.");
+
+static void __maybe_unused register_kinfo_region(void *priv,
+						 const struct inspect_entry *e)
+{
+	struct debug_kinfo *kinfo = priv;
+	struct kernel_all_info *all_info = kinfo->all_info_addr;
+	struct kernel_info *info = &all_info->info;
+	struct uts_namespace *uts;
+	u64 paddr;
+
+	if (e->pa)
+		paddr = e->pa;
+	else
+		paddr = __pa(e->va);
+
+	switch (e->id) {
+	case MEMINSPECT_ID__sinittext:
+		info->_sinittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__einittext:
+		info->_einittext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__end:
+		info->_end_pa = paddr;
+		break;
+	case MEMINSPECT_ID__text:
+		info->_text_pa = paddr;
+		break;
+	case MEMINSPECT_ID__stext:
+		info->_stext_pa = paddr;
+		break;
+	case MEMINSPECT_ID__etext:
+		info->_etext_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_num_syms:
+		info->num_syms = *(__u32 *)e->va;
+		break;
+	case MEMINSPECT_ID_kallsyms_relative_base:
+		info->_relative_pa = (u64)__pa(*(u64 *)e->va);
+		break;
+	case MEMINSPECT_ID_kallsyms_offsets:
+		info->_offsets_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_names:
+		info->_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_table:
+		info->_token_table_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_token_index:
+		info->_token_index_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_markers:
+		info->_markers_pa = paddr;
+		break;
+	case MEMINSPECT_ID_kallsyms_seqs_of_names:
+		info->_seqs_of_names_pa = paddr;
+		break;
+	case MEMINSPECT_ID_swapper_pg_dir:
+		info->swapper_pg_dir_pa = paddr;
+		break;
+	case MEMINSPECT_ID_init_uts_ns:
+		if (!e->va)
+			return;
+		uts = e->va;
+		strscpy(info->last_uts_release, uts->name.release, __NEW_UTS_LEN);
+		break;
+	default:
+		break;
+	};
+
+	update_kernel_all_info(all_info);
+}
+
+static int kinfo_notifier_cb(struct notifier_block *nb,
+			     unsigned long code, void *entry)
+{
+	struct debug_kinfo *kinfo = container_of(nb, struct debug_kinfo, nb);
+
+	if (code == MEMINSPECT_NOTIFIER_ADD)
+		register_kinfo_region(kinfo, entry);
+
+	return NOTIFY_DONE;
+}
+
+static int debug_kinfo_probe(struct platform_device *pdev)
+{
+	struct kernel_all_info *all_info;
+	struct device *dev = &pdev->dev;
+	struct reserved_mem *rmem;
+	struct debug_kinfo *kinfo;
+	struct kernel_info *info;
+
+	rmem = of_reserved_mem_lookup(dev->of_node);
+	if (!rmem)
+		return dev_err_probe(dev, -ENODEV, "no such reserved mem of node name %s\n",
+			      dev->of_node->name);
+
+	/* Need to wait for reserved memory to be mapped */
+	if (!rmem->priv)
+		return -EPROBE_DEFER;
+
+	if (!rmem->base || !rmem->size)
+		dev_err_probe(dev, -EINVAL, "unexpected reserved memory\n");
+
+	if (rmem->size < sizeof(struct kernel_all_info))
+		dev_err_probe(dev, -EINVAL, "reserved memory size too small\n");
+
+	kinfo = devm_kzalloc(dev, sizeof(*kinfo), GFP_KERNEL);
+	if (!kinfo)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, kinfo);
+
+	kinfo->dev = dev;
+	kinfo->all_info_addr = rmem->priv;
+	kinfo->all_info_size = rmem->size;
+
+	all_info = kinfo->all_info_addr;
+
+	memset(all_info, 0, sizeof(struct kernel_all_info));
+	info = &all_info->info;
+	info->enabled_all = IS_ENABLED(CONFIG_KALLSYMS_ALL);
+	info->enabled_absolute_percpu = IS_ENABLED(CONFIG_KALLSYMS_ABSOLUTE_PERCPU);
+	info->enabled_base_relative = IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE);
+	info->enabled_cfi_clang = IS_ENABLED(CONFIG_CFI_CLANG);
+	info->name_len = KSYM_NAME_LEN;
+	info->bit_per_long = BITS_PER_LONG;
+	info->module_name_len = MODULE_NAME_LEN;
+	info->symbol_len = KSYM_SYMBOL_LEN;
+	info->thread_size = THREAD_SIZE;
+	info->enabled_modules_tree_lookup = IS_ENABLED(CONFIG_MODULES_TREE_LOOKUP);
+	info->mod_mem_offset = offsetof(struct module, mem);
+	info->mod_kallsyms_offset = offsetof(struct module, kallsyms);
+
+	memcpy(info->build_info, global_build_info, strlen(global_build_info));
+
+	kinfo->nb.notifier_call = kinfo_notifier_cb;
+
+	meminspect_notifier_register(&kinfo->nb);
+	meminspect_lock_traverse(kinfo, register_kinfo_region);
+
+	return 0;
+}
+
+static void debug_kinfo_remove(struct platform_device *pdev)
+{
+	struct debug_kinfo *kinfo = platform_get_drvdata(pdev);
+
+	meminspect_notifier_unregister(&kinfo->nb);
+}
+
+static const struct of_device_id debug_kinfo_of_match[] = {
+	{ .compatible	= "google,debug-kinfo" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, debug_kinfo_of_match);
+
+static struct platform_driver debug_kinfo_driver = {
+	.probe = debug_kinfo_probe,
+	.remove = debug_kinfo_remove,
+	.driver = {
+		.name = "debug-kinfo",
+		.of_match_table = of_match_ptr(debug_kinfo_of_match),
+	},
+};
+module_platform_driver(debug_kinfo_driver);
+
+MODULE_AUTHOR("Eugen Hristev <eugen.hristev@linaro.org>");
+MODULE_AUTHOR("Jone Chou <jonechou@google.com>");
+MODULE_DESCRIPTION("meminspect Kinfo Driver");
+MODULE_LICENSE("GPL");

-- 
2.50.1


