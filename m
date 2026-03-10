Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958E9FD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34136B00B4; Tue, 10 Mar 2026 16:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01D26B00B5; Tue, 10 Mar 2026 16:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFFF6B00B6; Tue, 10 Mar 2026 16:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB7496B00B4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:21:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 920BB13A4C2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:05 +0000 (UTC)
X-FDA: 84531272490.12.29CCA1F
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B9321C0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=WsqaEFjE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=h4RdFce9;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773174063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8G6ao9c6IrCim/s3l50tkoj/aPJ0c8mCOq1F3OVXebw=;
	b=6ONNHcPj3Ctxs0XglNqGtRNtQICJ+nXMyDifjMVe+PX/4IfIxBHRq8YgY5wYleyIbLooft
	ljxV3tgEbGvYVBF7o3I3/0beVZ6BHlsXE5JJ/Odkqzt6Y/vt9MnjYmnHi3tKOI/M5w/OZw
	M0EBNh8lDbdG6l4AOdb6Aay8Q2w5G0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=WsqaEFjE;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=h4RdFce9;
	spf=pass (imf20.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773174063; a=rsa-sha256;
	cv=none;
	b=SEfOi4hipbkLzYthsmHWGWOFjKTmVX3XRimD5cGn/KqqA69L04pwW0BNRgOo/9daADNWoA
	4IQCjuesc9kJkNGz3Co3XtoXC7DJ0uLDf1Co5fzfGoqi2LV27HOnkEt70rWjZ/9rTwVAtu
	XS3Hpl4NQuRSq/g9KsIHmen/HS6KlXA=
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIXIDB2861962
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8G6ao9c6IrCim/s3l50tkoj/aPJ0c8mCOq1F3OVXebw=; b=WsqaEFjERT7rg3s3
	Wxh4C+QCKApqmb0SH31sntHGAvWc+qf8wmPqySjMHCo1jeHhJI60NHr0zphUZWHZ
	GQosGveeaBtzUWQ7Q1IAkpdoK9yn08lEhaKJWCAufgufRB6Ior1EGFC2N09sczDb
	7/cx2WLOHllX2osb3iSyttxtVaavlxwEtzl9WjPZXcdjz6WFzIgmYLhGX8eL3AlF
	/KnH3dlStqUuteY6tdTF03fh8MY/DmVq9JpR31DcLm3GeTOhb3PIoEXaBkV+t5P7
	AE2LZZ/2jv+N4eRLEYL00c4jqi+yORHOQGiMaJOCJND+Gilvla1St3elnPg4ssDz
	G0nEOg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cte3wb6ff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:21:01 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358f058973fso13205092a91.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773174061; x=1773778861; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8G6ao9c6IrCim/s3l50tkoj/aPJ0c8mCOq1F3OVXebw=;
        b=h4RdFce9d9lyFOVEQSQd+26tENjzWvM64Ai0CCx4bj+uThGR9ZZL0KMHsgfhNPEA9l
         ywH1ZK2liPDg4ibJWxtMPsCJZ0pM2d3j6kfbuL7b4ZlRVeejcb4XnQjM2WB4oLV1rl7A
         t4h5eBuQeP30IXU38pSB930cjKwFAKktZE0RyxceaH2jSfW8MTCdMWYOJ9Vb7Mp3TtaC
         U4XP5ehFa20cg4GXahWhztEdjbyYs7HulO+mxB8qkWwPnGg0/Nh2OR9XA159ydNY7u4f
         kRVq6aAYPei8G3CdzpZLBlpX69NF8iQ70c7V4+kPoOm/14uG84I47KnQBJcchrRXmm0X
         nKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773174061; x=1773778861;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8G6ao9c6IrCim/s3l50tkoj/aPJ0c8mCOq1F3OVXebw=;
        b=bUAE43Sc8UDiLAWmyS15OmH4sqc8tfi+Tyly0zvjcaqTnvCdUTHupPLmdkE96Hp1Wp
         smaqcAR0diYbKWJQrSH5/2Q8XzotXkpaZvQiEybYaSxbB9MxndYHCpxdUyT0ZudXaaJs
         Bcth8kwCB20MqvtUm7owQFEqxBoNvQnKnHJUSFrIaXO1BWJt/aoT8YTqznV/bPHrFiCl
         Haq2ZODbwlrV6/Um+NNzdjj02k6z4hlEWpoB6CNcZ7qBufKr4SK79ftOdZCkmVJloGHM
         BIsGaAx8siKf5rA9ostgGS/in8c/KchyHP97BdOeQZkICLfTqeHMsWCU7GT7bXkZ2sKl
         vQOg==
X-Forwarded-Encrypted: i=1; AJvYcCXZNWTWKL7lJvZyNXvYkkzKe4CJDq9Ih2er7mFjv/wOf16J1Gwi+VorIxdm6OGfB2WkY7AvneoxbA==@kvack.org
X-Gm-Message-State: AOJu0YxN7MYqOE/5Nf+pkoGVtHn0sO5JnQIPZ91nNs8ILkPTr/vjypWn
	zUqWN93xtbHwt/T5rZK/VRfXmV6XQF04FB2L2mkyVewQTwZ7sWkg32i/JdR+Gikw6JNEMzZfJb5
	0Sh1LMh1RqFlwPlByejUnldSHgoBzpSV3RldevPt0IwDLsVhWPunMZw==
X-Gm-Gg: ATEYQzw3sU1+fbZjNrXjNTPr6k6d2I3YaZ4fgXmEpfAEzENFAln5NPEe4W6ZacRSzVd
	v+IDQWqY84/LaX7xkMoK0Rz3jLrmJhRE46gEI6Mh3yXpPmW+h50FKI+aMlq3kGn0MK27+Kobc74
	GEjgrA2tdyiYeFwe4s0Hs1ObUj0f1QVsOUFDyn9zGLeL/6mLweSm2sNcnWrSWW8MKuEEk8iTJlL
	OkrAJ85m1zOGRs3sIeCfs3tvewuj2bHdorZERD31B62COLijEiA1ryD1JjIk7yd89OaLF+PDk7K
	MAZ7S4fnzq73AlK+wOyZa1sIGlGEaDpDqiniW6dyTfIq8OQGmtwW638yGL61XSqd2gq9yMuOwf2
	sxC8h95fakpQuzus3c/hioIP0IxjK44DPohyVVyt87CvE3XU+
X-Received: by 2002:a05:6a21:a97:b0:398:b5c0:587 with SMTP id adf61e73a8af0-398b5c00764mr2440443637.42.1773174060664;
        Tue, 10 Mar 2026 13:21:00 -0700 (PDT)
X-Received: by 2002:a05:6a21:a97:b0:398:b5c0:587 with SMTP id adf61e73a8af0-398b5c00764mr2440378637.42.1773174060015;
        Tue, 10 Mar 2026 13:21:00 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc2d0asm115262b3a.13.2026.03.10.13.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 13:20:59 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 01:46:03 +0530
Subject: [PATCH v2 19/25] mm/sparse: Register information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-minidump-v2-v2-19-f91cedc6f99e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773173756; l=1623;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=s2cfwUngtIxx2eV9eH8Dr8bBdhICSaTG0klgQVpqdHo=;
 b=xNEeXQa/cNWC1GXYckGzvwIw/v3hCspjDsNkZyY1zYhqsFA/V37X9XsQTlN0zIgnx7o5WUfXP
 T8fHWKWsvkND5KTzL/sjt54KQs43AGyHROp1bjPiWExrBXQcpTK+mk+
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE3NyBTYWx0ZWRfX9a7AK3A8rHVZ
 WaIlrhLmPOZbV4+xVBdUlQQ5CJHrgUCbKhE/+tSchVQrm4aGA7uMW987t+coUk1UV9ZR6cCdtu4
 ofVWj+YD0MOUIMUT5COHKooSsBuXj3xQSG1E0L9slRlRKqZQ7ENaq7oYA8WE/gSzRwfLk7Dngqq
 2BXJ9JqDDKbQ8T6JVwrIw+gCns6UYyYmjf9cQ5El+xxCKW2BDpCAEUa4mpMSGWloQPBd4qna7jI
 DMnRNtf+oyf31NUFquJhFuAp7wSHBaU9aIN+YT2X+9T1izLvDYf2629sl1cSKachyUQCgOnx2Qk
 bSV00q8xKZEykJ7QF1Gm9PWSq/UD0NpWfi+SBIeAOLpOlkXgSiwioqhVlobjDWYwMi1oW6UNkar
 79rRuffjNy1NSVwsMLLAlzRehKLYExgdtPKCNoMlk1Dm0W1mymcrhpE6UP8FYDX/p0LJ2G2Nn1j
 PyzOYH9mEByzDdT1QTQ==
X-Authority-Analysis: v=2.4 cv=GtFPO01C c=1 sm=1 tr=0 ts=69b07d2d cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=hPKMzws2jpgYMEASFUsA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 9FONvyTD3ilHyLTsPtKDfgQOtPe8H2un
X-Proofpoint-GUID: 9FONvyTD3ilHyLTsPtKDfgQOtPe8H2un
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100177
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B9321C0003
X-Stat-Signature: 6zr3hpcf6bwuxxp3q1kdhteospt6pisk
X-Rspam-User: 
X-HE-Tag: 1773174062-776452
X-HE-Meta: U2FsdGVkX19+JhVfemLBafaRwU+c1Xf8oq6JgddV/TI6W6RDmUpP4eKsobIQr4dT6vc9Q8v00FL20czwsJ8IxKrrLNpikRCON/c3k3yfUjn9nRNE9bypQpofw3/S3gN90BILLqpmUDdrMCmzMR5hJlOaEKlSV9Pi7kn94aslSpICo6RH62bijj9Ka2PDjnoxb6TbVp5g2rBPMS+H9FTUXWO7kJNUGGvbgQeAxxMEDnGkwTU337MYXjKNdV9F41/q8Qq3PanobDh+nnG1JZZDB3RKaKp8kYQcBm3eWQ/XpzwLLwaiBY8FNQDqD+OiNck4I/3ECHgDaP3zFumVD9uCh+aj8lT3mP5aWRi41Ymw1U65/FmzBQjw+zWIIWZfZbKu4c4uX61IRae9rnkJlRe+b06dLBV1B3k6vycMlCvalGcAwoOYdFLtJSExbSe6b5SEL8fQ1Q3wJwvfFxV7l8JqnZTapN1+nceht8H3uH14OFFMRaFTClT/mmltWGxRnVju3A0V2e4NABMnyjaSQyVp/1HFvwNE8dHsH+IkeDzeTAuszyVEPCbJ4TtCkBCr/clt9X5h27SvhpO+bxxAjY4n3Jgzn7d33aso/YQO3iBqqFlehrqwsIbWvu82Kauhhje2XIHX+W0zKBvvP1aiMh/ig+mhIOoVEWP1Eco08oLJfhZRDxT8kanPlq9qRmI78NguUBXRwCDlOXQcIa5r/47QUewajqFhfTTo15O1GpPHm1lh03GTW1fl0FWjWLq4DDvO+8iAEwiAq2cohUU7R8D+i42iwzwQpRlZyDvcBdmCpZBwnLSJQfNkZCD/5sDHktfg8zv0H01Jf8Hh3ESCoNBNU1JCrUG0kE7tMmFSq6uv+sNTVyakv37rGK0yHf8CtxqQdcKW+mdkQDLigPzAJRtn1RMPcLfR711LpKgAzHJyQNHi7huAQ8C+xHl9hCezBd57eEAoJ+CrFHSem8hnbvj
 czOfJcye
 Dvjcso9vC5XdK/r4uy3aidRMiaf8DC+NC2+ctPRQOBWXLo0JEGaJn/XkTzC/M4pC1FelqgbF63HJEUA4v37M0PlqKVILWcF8FuFVhXDJPAIfN9fEab1a4iA4nPLmvpGeU+VPcMgevRHK3mWN9ZKb4cP+U3aym2NaLNz6aMdMtVQPQGCI6qr81QNB8PQ2La5svvtiEJZmGhVoPumNIVqfw58jcKYaD9aIh6u/SNsrZUIXdlEoFNsV4rywJfOhro0ejN40xwtP4vMKZe8wjThk8mfEM1Q2eeKixjWYN+iD/XcIksd/7U30EcyOEH25jgFrDvacRnDohCDqt8yqfkMHL/HuXQNW09KyxZ4+5W9P5FIHxI/wukUjcAjeT10RicI/Xj2YxeAFAf37wGeRY9UJS6vP4KRu7xlc8URWCs99u9ERwE3jJ2lq+Uf4B0h+vJLhY0ibP5FN8nmS5Jik1pkEyLdfjkheaDEvNoJnZ0X54KDLTESf3FJkRKT+P7JfY+3XI7Vsdu1MedKg9bFICLx9QpV8lfHPc0emM84zaTq64Cu6FX6jwgKdmEDo3mzgbl4WaJor9/b88tHbc5ADFzhIOri1MUrOvaC+UQoAVSptS7XnSwVf1YDTa/TVmNoUAhbWOEvSaeguZymaOrX5ZWnenH7dfjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static, dynamic information into meminspect for
debugging:
 - mem_section (static)
 - section (dynamic)
 - mem_section_usage(dynamic)

meminspect uses a different API to annotate variables for inspection,
and information about these variables is stored in the inspection table.

Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 mm/sparse.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index dfabe554adf8..38beae2d4294 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 #include "internal.h"
 #include <asm/dma.h>
 
@@ -30,6 +31,7 @@ struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
 	____cacheline_internodealigned_in_smp;
 #endif
 EXPORT_SYMBOL(mem_section);
+MEMINSPECT_SIMPLE_ENTRY(mem_section);
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 /*
@@ -253,6 +255,7 @@ static void __init memblocks_present(void)
 		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
 		mem_section = memblock_alloc_or_panic(size, align);
+		meminspect_register_va(mem_section, size);
 	}
 #endif
 
@@ -343,6 +346,9 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
 		goto again;
 	}
+
+	meminspect_register_va(usage, size);
+
 	return usage;
 }
 

-- 
2.50.1


