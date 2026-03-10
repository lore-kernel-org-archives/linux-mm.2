Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DF3FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B366B00BB; Tue, 10 Mar 2026 16:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC016B00BD; Tue, 10 Mar 2026 16:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1386B00BE; Tue, 10 Mar 2026 16:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4F56B00BB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:22:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E174713947F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:07 +0000 (UTC)
X-FDA: 84531275094.02.542EB4D
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 695CB8001C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YSJh4uFS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HgcI1bq7;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brkrGexervsDjeRqs9RzmRiixQVaocfEogoUtg08MW4=;
	b=wV3S1epTdoUH9J4JEYVOYTYm4G0Fzplgf9NF/l84zz+ZIbkC+kNbgwuF4KHqstegzL3fxs
	BpGPS2K3bm26tET1XW/zj776l0zZfanXu28Lpssc5O0WVXXI2cX3BMU9h464nas2tqmJV9
	AjCK0WRjz8KrfeBCNKm65guyn4iDl7g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=YSJh4uFS;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=HgcI1bq7;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174125; a=rsa-sha256;
	cv=none;
	b=nJisaE7XCsTwMAPA9d8yXfyOfpYufHNgQemBCvdQ7BpHZhhpRx8aXr7FSiJoPfRhOwEy0s
	EUnZTpXtn6hD4Qejb60v0g3vGvcbk9GK0ehP5hE8mscMB+zwYPM/ibWCVfdQcy6847QFnk
	JjpYlo24cSuQL4cDUb3NbJvngFDAPVs=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AI5EvX3295832
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	brkrGexervsDjeRqs9RzmRiixQVaocfEogoUtg08MW4=; b=YSJh4uFSvGRFmKbt
	xH++W5JgTe8Mvq0fGvsD2Y99YvKm3+U/JThznCK640M/4G1wZVGCwHZuJB5AL4uc
	BGdG2d5v0LPy05QsTa5J4pE91O5LS2IhS89xNVbJre3CaYQyhisVPdBrzA0Csrsf
	ch4dglNxZaJuU09OJoFN/NN/bZrojYcf+1p/WJ8VkvCTyRWoZfnLvhSr7kLf17QM
	MMnsMfF4h2wPWDlhwdbI84cesSWDUgqAj9pzWnJb+p16SotfK08GiYiZbRVt8sNd
	ckvjBYeQ1d4X6tW2894rVZYZgNXJ9STajqqZp56lAN+Eq/iY+76uyyg1rOD0XXbA
	cbB/LQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mtpqg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:22:04 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829ad81b132so12134321b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174123; x=1773778923; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=brkrGexervsDjeRqs9RzmRiixQVaocfEogoUtg08MW4=;
        b=HgcI1bq72rFpJDZjyB8Deal1pXb6UZE3hyVXq4VjDlTrlT3GeeB13Tb/8xCy3DovY3
         /w1pcOfssGZRi4ZiMkM9vfZOQwvP5Wip2iWFOqRBWiUr300MEEDW3kdn6OY5TKAtpunA
         W8AqcGi+pZmAWacyQTaD6ufszdMXUgN1BIaPoixyqNUdHS1+OKGGusjLkOqoNPtQsWjV
         fVOZZhK/xZdRJYpp/6qH5a2ZSry45JofvTEgWlQZlf+y6L3zu+xQed/KH4iC6jO90ro9
         Udv3YGS4wLtLPLi1CAioSwlIjW2K0nyZ49Cv3AwFdgYZvySxk/WHQmWbxiTQ/px3Tez0
         9AUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174123; x=1773778923;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=brkrGexervsDjeRqs9RzmRiixQVaocfEogoUtg08MW4=;
        b=gv6yv3Oy7Ppr6MB/6JYA5WKp19tV4yuB3aKuhfSxmyZXE4bHHZedfVCRN/ylsNPTps
         uG34tEzpLfDvhPXmOeChAJyLGp+Fos/wzmqiZh43TQZ8SmPT5DgP0U/ywg0j8/ccN48f
         J7/l8zSWs3l9yNDwlzZjY/Nx3seCyItBsJLiKuCpzUvt7rHdsSjK60rWz74WOIUDjTnG
         gzmFLaBhtVUkz9fU77nAhbF6VcPVJJHYLYPmG4D2ufI5j1H5YYAweZmku3d+x02HjQux
         bFBlCmN6y3l2PUBvBl5uPypHTU9vIeqtEd1fVMveRvYmNEH6HsHq/0/SXhi/6Yqi6rbO
         n/Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVxKH+ymFH/ng9WATA0UeBIcyROJiyD5eSwUTmVBhGQks6hbMNTB8qhdGcDPaitHfjR+ApFYE3xYA==@kvack.org
X-Gm-Message-State: AOJu0Yw47fqrPGLuWU+w45uRPgIepFWn/imwIa5eohgk0yqOGTQiK6L9
	4QrBbaEfpkaYKNBIlvcND891LqkhZAchQIbTeec3NL4Ve3DAoa2/MUI9azhdOIQvJkcpn3hcjXg
	9kE+Uum1tWMVclaX4KKCxaN5sqcQccHcM4qYtbSww1GFDJM0jRmnZ0g==
X-Gm-Gg: ATEYQzwMX7qDIp1bYOAayFUZMeelKUaskFoDMvMzxt/xCnkeCU3m7V/coolEy6MCXVC
	+CwvSUJCSGKtXdN4g7+X5NSGI+vGEb8OMbateFJz7JKXJakyUwM0aYHzSztLv1H0swR13zAMoxT
	fOsMJ2CsCEcujSGaMDv4k+HpBCKOW2Lhm2k6wf72iAtj1zGuicKJWuHavHl+OrcwwKb7Eo14jAy
	4yFLsxNC+nIBAzxSf30VPNQf8bVcTTMqbSp058AqzihDne/TtAjlD4fN6GOyxxeCtMhuRNGRLLt
	Co7IjN5LwBR23TDpdysO2PESYv0sc+2TY3+e8FXY8K6pCoyTExf4+TZSKsA33dHKZUdgGbz86b8
	6rN+XZcKyfY5ORhHr0f4za7dc8AXcor+Hb63GpTz3QBbzJ5Xo
X-Received: by 2002:a05:6a00:3e17:b0:828:f1d9:22cc with SMTP id d2e1a72fcca58-829f6f2abe6mr177013b3a.20.1773174123233;
        Tue, 10 Mar 2026 13:22:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:3e17:b0:828:f1d9:22cc with SMTP id d2e1a72fcca58-829f6f2abe6mr176989b3a.20.1773174122629;
        Tue, 10 Mar 2026 13:22:02 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:22:02 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:07 +0530
Subject: [PATCH v2 23/25] soc: qcom: smem: Add minidump platform device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-23-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=2191;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=I7h36vRINCl73eGOjCLTs1uEZfJpGZtYWsp4d/Eb0ng=;
 b=rMdSNPF/xiEgp7h/2PrlHDpbz9A7fwnRMH+HKK1W4eqdbkbtkF909spMFFFZNQ9yLATM6QiGz
 i5Npb95/nW8AU/UjvwC8S9P1wIPcyGpH6PiS6CA9GiFk8+2THVKvvef
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b07d6c cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=3CFpAjl5I9ltKDqHFfsA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: N-ev6-XUAUPoAk6OjXgYQd4HxDtQQ6_T
X-Proofpoint-GUID: N-ev6-XUAUPoAk6OjXgYQd4HxDtQQ6_T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX5GMxgxN7SRXg
 JeZ8cnpOzAl3IiOzD/h2n/4eAKm59eOYYCIjDIzAbZPZJiCVxe0Q2xHFMvsFXumop+HL8OQEwhp
 NVPMeex6LtBWTdvQMLhERTaRkTX4gGZoIHEhRbvHbERplijF2ghZ9c9QEG6O7UumQqbdkrQwFNP
 mwnSP0vaGahOK3XfyTQfshhmG7BRL7nEF+9TSfJIg2UnwodQ7rbtxf7GDcjYrZ9fuLlU9+csn/+
 PMzUVk7vMMauf1wO2eq06n88JV9d24V/rAgXNPsP82Wv9n3JxnqMMc0ZKGxqRB9jWucc820l5IZ
 xSeDW2/8OXtRIAnWZ8RrFE9fQG1WXOL8XkQNk3kUSvrQfmD/12CQQ0wZp5yee/aUcz+Q9zlfz+E
 hQ+u+ZGAeRXDu0hnCeKHzhG8x18I2fFuM21UWgeBqFJplIaC37q5qeOTJxh4r4mx9iVcZ3HQ3xq
 08o9fwoVg9j3iluGE6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100177
X-Stat-Signature: ude8ai3tc5nwobhrcoch5j4dnfnha1s6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 695CB8001C
X-HE-Tag: 1773174125-460184
X-HE-Meta: U2FsdGVkX1/U1oC7aIcC/9cG4Pene47I2uZftyuFbzlSUqQm9j2Enus0P4+8QnZYMOogePffYPpqW4ul1ajnquP9Eo5WkmeV+iu93b4kFyhPyEEWBQ6jxm/1X005EkdtHvuEOnLqbc7lqDk86jDjlhNWM8tvm0yXxKZAmFKjYD+KdJYZTo+KX4ILdiyT3LeiNzfpS+fKXjYjUWa1RWIm32xmDca2JmVO93rR+a7YGwx/3KYI5mKN8PLBgRVZi/CLxyvBDOrC0aR4WRiVG5G/opxto+NCb+6A/176/31NbiSXbFbEE1rLH3qwfJfuHT4g7V/TAsb44iw4S3KF/3c7iTCjJFjVBtWoY+JTFGtBDpYo61GOSDijMjKcNLAQ/tVy9NCupAenna9awsjiJvjlOEHggt2X3oAIsPl8fCKpz6WOOpe0J5kWVAYERTm3iDCH2YEwhYvvoKYszXQim+tLDvl1XPNwXKhdG6+Es375eiUgJDJMO5HSxD1E/8cUBBuCj2/MHA/X9zKkVoG6dy9E5Jf5FtJfc1rP+SeP4Ij7vXu5fApbVlXt0tJzho5KstjrYqaEXp9jiMXHf7ZtDWd/prAVdmgHjQBqf2b/ZyZEO0kMOv1Cf24pWbu2qfAUEQkkhOu9YPJZDroguioutdJkq8pvUkUmxaL9dB/Kefy7+sJgpWtOWZGP9v/r75+MK5yEP0ElJrhzC6jpQD1i+3hy3wINQodBsv9png9KKDjAaH5Unm91cOuLRDfFgkpaLz1nqmtNA0O69BEHcVMF7B/zb0/122fgOs+OXCwXIOKph9X3dpQFtvY3mnUelt0ttFIkfswqoJbfnVGhzdb04w+voXnBq2Zg40er5s+Jfy/SZlj9sd9AQVPEqUZHJu7kyGDpfYpv/tIXO0/aN9KWhbtJGEtFoAbcCjPYePT8lIlC57XypaOS5pDYLFLdkgK73EfwdKayVXW8qpJnc6JCQJa
 9HMWPlAe
 k7RTNcU0Z7GmqQHlOBdmi1PvchzYfkRX6RsMkVJQSFbyyDYaHsHBy5AyPAVx0RdvlrjlTIBrpXAeh4wGvSH+U/wVGCYIJHqSToKaEpg02MjZZkGMF6iLSG2etrHvBPm6nKuBd5O+SfDrZSmGbRiUQdtJ51izA+KC0qsd1gwjPL6XgehBCSWUhHFMWn3CHfgIxQ3ouQSUFwO3i834MpBLD0eAJ6BGyxTNFeU4+00sGAqMlz8mQsFZKvyBgPXZKxQt5CdL2k1K0HzTreRe7HlgLYf1Ldo9TZ0WbJVXdaXApQu2oiDWILvT8+5UMZdf0d4oFc48hbDtts8hNqtLkaOYdvU/LOKIOlOX/lfSsWcNF+ntdy/ng4j9G+PcHM49JS3e329RoeycT2MdDKfMJcCHohKC69W7M+qXuVcFqXbMyO0wK2H8LfHRCsz/NOzngH7BJQMsgO5aJBlhxU1KpMLDgbeQ+PIeLpNVacM88wAaPaijgvi6oB+5GkYt18at1VECowNtGQmmvkYPtWr0IMV3MGu4WsOfXSunGv7/QRymEN+4sCuVBx5AUda7YKfX3oKK2lgputmUolR9wR/6jXG/rzkVCzRMxR3ceY9VEuknERJIKSXK0SlwsmltaIzxch6BWynLccCE0FXCYFbexWaQGfcv99Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <eugen.hristev@linaro.org>

Minidump can collect various memory snippets using Qualcomm boot firmware
support. To determine which snippets should be collected, each snippet
must be registered by the kernel into a shared memory table managed by
the Qualcomm SMEM driver. To instantiate the minidump platform driver,
register its data using platform_device_register_data(). The minidump
driver will later probe the device and retrieve the required memory
snippets from the memory inspection table (meminspect).

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 drivers/soc/qcom/smem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index d5c94b47f431..65d7b4d99677 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -270,6 +270,7 @@ struct smem_region {
  * @partitions: list of partitions of current processor/host
  * @item_count: max accepted item number
  * @socinfo:	platform device pointer
+ * @mdinfo:	minidump device pointer
  * @num_regions: number of @regions
  * @regions:	list of the memory regions defining the shared memory
  */
@@ -280,6 +281,7 @@ struct qcom_smem {
 
 	u32 item_count;
 	struct platform_device *socinfo;
+	struct platform_device *mdinfo;
 	struct smem_ptable *ptable;
 	struct smem_partition global_partition;
 	struct smem_partition partitions[SMEM_HOST_COUNT];
@@ -1242,12 +1244,20 @@ static int qcom_smem_probe(struct platform_device *pdev)
 	if (IS_ERR(smem->socinfo))
 		dev_dbg(&pdev->dev, "failed to register socinfo device\n");
 
+	smem->mdinfo = platform_device_register_data(&pdev->dev, "qcom-minidump",
+						     PLATFORM_DEVID_AUTO, NULL,
+						     0);
+	if (IS_ERR(smem->mdinfo))
+		dev_err(&pdev->dev, "failed to register platform md device\n");
+
 	return 0;
 }
 
 static void qcom_smem_remove(struct platform_device *pdev)
 {
 	platform_device_unregister(__smem->socinfo);
+	if (!IS_ERR(__smem->mdinfo))
+		platform_device_unregister(__smem->mdinfo);
 
 	/* Set to -EPROBE_DEFER to signal unprobed state */
 	__smem = ERR_PTR(-EPROBE_DEFER);

-- 
2.50.1


