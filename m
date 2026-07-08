Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8324CC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C3A6B00A7; Wed,  8 Jul 2026 01:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644876B00AA; Wed,  8 Jul 2026 01:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532D16B00AB; Wed,  8 Jul 2026 01:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23F7C6B00A7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:35:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABBFC1A0679
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:26 +0000 (UTC)
X-FDA: 84964496652.08.ADA41A3
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04FDEC0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:35:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=pFo9WSIh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=klKwNL8O;
	spf=pass (imf10.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488924;
	b=iP/FJIDaMcKp9hK74GsL4V7SIngikCbVtccuRA1LOwBwRnZCDVHm3y7PPC60FvLWo0BUhm
	+Na8OUi2rBP+toYTdQls/GeCNxJTw2hm87okWZLPh8+rg7zb/RM+0cpurY6j9qg1M/TddC
	s5v27OBuX0NInWP5Lq3TEe63/fbHoaU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=pFo9WSIh;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=klKwNL8O;
	spf=pass (imf10.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3x+TMMzYs51Q57TTs1j42iOpyhdFk+I0hp3TICnwjg=;
	b=wKYmN6c9Obwh8AXiEDq+EBQfVmxaggQ926NM/0UaBn3vVAcAGBAXWU2nrCk1K00+E+AAlS
	WLFNzg57ver41i1Q7J/jZXXdCcbrBmKBGP6QIXCuFMDQmgu/kBr9G4w4E9XGsVSsx2knfa
	Wyo3yp+PQg48Wt1XkCGQnMRvaK+98mE=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842U901447476
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+3x+TMMzYs51Q57TTs1j42iOpyhdFk+I0hp3TICnwjg=; b=pFo9WSIhwEYdEYNM
	wWtorKvFh3bDjSxFAinXAxdKwm7Z024P8hmHhadMiLzMLCPdruqT4rmAkY4tQewl
	ElxyGsMl3gajlha+6ZroCW63wi4nK1ktdBuPuX3FAL9ZXixN/0lx3tvC3Y7lNvyR
	Yt37rMWQBgF6yWC5dLeTfFhuwBZ3VQbRD+U49GV2ROHTYrVtws5GaKRnlbgrdpHZ
	M9IeaDbto9UL5CGReS7Hx4YXldYcCpau+lqO1CfXLCQmq064VIbY5TSiGRZKMPxl
	6MIkzT6lV54A4TStfdW2tLHHia2uaiAGk/gWoiKa4LRQQf7oCcF59MGEh9tFrS5Y
	PF8WXA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f97u11ts6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:35:22 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-845df469a26so905895b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488922; x=1784093722; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+3x+TMMzYs51Q57TTs1j42iOpyhdFk+I0hp3TICnwjg=;
        b=klKwNL8OEDwzLaPGdjyai7Ic/lSAuv7GohAo1WALUKDALiS0MAP4JEob9+ZeHVNbXt
         gHJ0OGFDH3CZOJtM5kw2mwhkgmBCGw4PyL5gUzz2UlBaOuVGiPBXblxaO/3KmQLa8jOd
         EqBypMhgOFMfp1Z9G5CawTcP0GGRes5IKYGnomfB2iBdOUeSeqGxIrDFcRnuH/ENb2ka
         jDPFdo3AsiDWQBYfde7Os+CQZ41gIv8+5fH4k5WPjFgIjZaWNBsFaf0ZFNIbWeD4fPcN
         jU35F7/84PhsZY6gagt4W6LXhVAcrHaZ6rMuJ+5r48CKikuzIRYiMed+Co4AIVINviUU
         ZQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488922; x=1784093722;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3x+TMMzYs51Q57TTs1j42iOpyhdFk+I0hp3TICnwjg=;
        b=oc3jrDwO36JQEqLZxI24TTSYbwl7t7xmrXdpuDOuozW3yz0aBOJrVKqtoEHvFpG8GA
         pjFwAJZ6P5itXvabT0MCHLmZLaEVvG2zZT85xx86pHkiJjclm4/GFDZqNukaeLwKiLyJ
         RibpdobfmuQFsyj9PmfEq9yXUnNZX5Yvxxm2asmX4IyaUZ10ozDwvAxRIVMsydoSduIL
         KTsdLkTuxaar8uqIyAeD6mlA8UJcQxN+4+PlBT0zlqmqXGOPhsWOBemWvuOQ5JahdIqD
         r7R5PZNe0cjTlKMulMsl3K8ONPBjSi1NX9iX2MS17oYl3JpOI7Sd0fodvEcLH3wzRUYM
         vaOg==
X-Forwarded-Encrypted: i=1; AHgh+RrPvJUBpT0W41Pz3MefsMu8eorwJ5U8+LQESyY5F0wBqdFd1W6F5sIOb4Tm40ZMhFrzLWn3r9NH4A==@kvack.org
X-Gm-Message-State: AOJu0YzjfcFo921N2pmZTCd0aYk5xPRa+hb5ejaTD9X7yD8RARBl881c
	tn2K5aMOK3IQgrx9ZrO3O1d2TD58tJyazblK7cLpJ4zgS2tjxiX3JZOLZSmaGrAR1CZ8atp0FTv
	Pld5SKLIMvCyiDFqiJHgx0ufqi3DbyTxaQo6KbkZID6sYBKckukJlUA==
X-Gm-Gg: AfdE7cmdn1nnOVNhEsR1WkZ53mH+ZRstziVZ4ReewbcGZH465NYvY5emqc07bcmx5Z4
	VQvjnvo5c1/qjLFtzw6EAQpXdmrrtn2k63H4gv7g+OxSsiP2Xh7rGWLcDtHnB5pNBnWzZMK1n+G
	x42fQBb1LZDPbx6UOHvR5BjX/lEpADRCoXvwoo1nQLli/hzjmScePddsgZ4DspgjDESVBf4rzuO
	jMWhpFoXPGjf8TtOQ/tGRMCLhVHgP/ocT4pUoQ3KpokPjobhrSWk5CyBo8hhCDsWKMVMbBql0xe
	5g0caddbxsUNRdDJtluofqg3GcnoJGjF/0AKf2RXH3tVafftRJTbLp6VX64eioVFQiU0EhfqFlT
	MTutKGXUl/CselhANa7dxJAmC3IZTjEx65amnXw==
X-Received: by 2002:a05:6a00:3c94:b0:847:8bf0:b82 with SMTP id d2e1a72fcca58-848438cc8a0mr1132186b3a.60.1783488921804;
        Tue, 07 Jul 2026 22:35:21 -0700 (PDT)
X-Received: by 2002:a05:6a00:3c94:b0:847:8bf0:b82 with SMTP id d2e1a72fcca58-848438cc8a0mr1132049b3a.60.1783488920709;
        Tue, 07 Jul 2026 22:35:20 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:35:20 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:51 +0530
Subject: [PATCH v3 12/26] kernel/vmcore_info: Register dynamic information
 into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-12-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        Eugen Hristev <ehristev@kernel.org>
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1258;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=5yycsUBwoFxiKNQeKvCsF+mVUdasuljHstmWvn84Jps=;
 b=dh1WtDpiEGxqTk4F/COwgg2DhrAd3AuPXNJplwhLTNVJqIHM4OhNRd1Zmmkp2+owqTNHhWdct
 CiAtW2VX+qgAIDAxAIMI67SaI2XkeGHgfZ7O/D/Y9bcG/K5XSCTPfU+
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: wkxmmBWDXeBieZc6OwAe0Hg68j_WZqNk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX9e0sfQ3HfBZi
 nnPaAzNlfzroIf1rW8FNyxVaXlePaXTEPs4z7n5wU1vydiBfTVRV+vd91EnZFyjFb7l1b9qoGf5
 gwrYtTZPWqHG20LwcSXi+YizYI7w1Yc=
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=6a4de19a cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=v3IzjsPwLRQtBGjmhGYA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: wkxmmBWDXeBieZc6OwAe0Hg68j_WZqNk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX3XO30Jjvk59T
 hvxzMAcM99TrWN51747FnlSuz1KHccknv9UPi2iBfMjYndWQEWLTOqkzTu+bq7bG9frqVQDHJdh
 o3zco75Zst+r/qBC1qDwXZGtSJDBte0bHaWXJiBo67tb1LfYxrW0rkAxRbWbUYtJe3ZivGVTeSs
 VCzHqmM/Y8QJBfkj/UA0TakYOV8D/8G0tPPndAapGxCe5Unit5ANmyaUNn0OWMT/wfljQXC1H+a
 FUsP3d0b00B3mvJmtFPMHA/ZEF7/vPT7eG7W8jd/1oHhT7gSc6j92RZYDipbJC6gb1LLZ2+syLQ
 16Qn5Elce7RkrDfE3TLw/wF2zJ1BEaRlOxkBxGGygEro9xC6ETWlV7IgXQ66cVJUru6tDYu9dcI
 +IH7jS/Dh0tZq4U20I1yYf3CshvnUfeZP3i4h4jF9CDhjLHfZ2jF14Mk/40jnRxIK/ZCmsPlZoB
 Ou/tGdHYAKLfTrciZGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04FDEC0002
X-Stat-Signature: ng3s8811kwh1xtxb6xfwosw9jowq3ktw
X-HE-Tag: 1783488923-608686
X-HE-Meta: U2FsdGVkX1/kLaIjXb/txiR2qWLKm0mqD1QRpwlEIS9mX6YPIUT4zWSiL/eUWpWjpUunoqe4/YsgxemEXHfHLW0dAoPFnjHWU9MYB+lH6w4+g6DJi2DaxS3s8P89Hn0hzWRouLiIwPwKutRWaCWKrxr67WWuUmFNdwRiQOUOY0MFXVrWxS+4OZTX1Yu2a+jqn9diXCDA/XB+CBMbaqi85zU8T0IOJJjw0mmpaWhhGpSzRFNnwSgsqNkqh7Ifbg4aQ92TaGCKYOINUaNInHaKuLXXrqIu03pLc5FltEf3AbnjX6uFrN2vm1MJi7ifeBFrEOqrG5KUwjeEE/Uw61h0L19/cnX5h7I3R6lPvPc7LWLeqnrB/DSGGnq5oL6zPBmX502Ri0btrX2F8ZHAyMxRUBsa/3lFIp1aoQTLi2k70mdI/RRHa7HoAUei2tjgWZlJmeS/BIPIL/oLQBNmG8fhSWgXzI1OODgbQO5mcul1ZVgaoU606Wgo+xuFt4qpFwGMkpohM752f4D++DHOTU3Rx/8dDpQS02Blm6F8aJ6utjwmpOGNtMK9eoqKs5elOELX6S4IhLZS33oLf8wezfOE5rk3HLfVoHXN03esg0RCdZ5ukr2TqWMLeMPmnhKFFmg6eMQedXMSuuV7LqgJP3uiPto3q0QOiBjZep5uslKbg1qJIOIVzh831crgl7pxbB++vw2nwqiCyKMbpOM5F01QK+eipNY5oNUWFN4gcKYolviBYy+6n/6UaVdsZvRUdhjPcGUbaMGoNtRGiWz9zrAdj0ElJ+HyIJqPgmXJfG9NokPqezNhTDavMAT3YIAjLLvelZcxdEaZtPdqqpuatkkqeb3/i+1MCk5IP6XMzR6BqtXSj2ueRDjncTgHuYUjB5r0hZ38U4QWbALeLtpNJbDl3O7n6/hU7H/u+9KcI/kp4dEYxpqvir/sqJpiBR5kYYJLALggXtddhxnQl9QVzZz
 WDLOq6Hr
 q9+Xk+JvGsId/ftrVG1wpT+YJ1MVGDt65MV1Jh/mk4o94MqeCQ/G9LNbjPddLqkVV7lj/Pc4FUy9Xc7Cu2yi23UBuz/ue0A+7uz+CDPRBPDDa/6OgN+cCitIiMIVL0rFvjas7e+j3ejekdhQj7JAZI71P2aNuFPlkfLSBH3zeggykw/e+/ikhQ+Og7PqOxSdPp07JF3lizH5ygV1FoQkWpe1wyvxeN649SboPgVCpVuTRL/0Ukpf+026A0lPfZrSe+5xmQ93CT0cV8nun56+JWMGhCO1xdA4Rar/+GkWFWQ1eahHRAZBCEW1p7ZxTmLAJiveIoWpEEqc2obs+fyWLUNg19WN0fxcD5FhdkEgzKT/T0U3RrKdDm9tu0QFIt0OgpJeBoIrxN4DQyzy5FuspspzZR0m02P2ZpeWcOzQmXuO0zSVSF06ianOxSIH3c5wLom3sRBK9pVi5an8dtrjPvQKQ+HDHJHRz+AGRnWPNQ8SR7yopv75kEOwUAQVXCCdEH6s2TQw75a1I6SbObhBWy85MlOt9nOnWzJEYtUzo7m9thFQmt596O8V+roI6PFdEqs1U8Z8KDbBYqYdk3usRz8j1rIgL243kT/rXfRWoYIAa1ooZY3kV2k6uAZ81Q6m8VmV978BVQv6FJSH2hTClauT89kChxAWFFuGq7egAuYqJjgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Register vmcoreinfo information into the inspection table.
Because the size of the info is computed after all entries are
added, there is no point in registering the whole page; instead,
call the inspection registration once everything is in place with
the right size. A second reason is that the vmcoreinfo is added
as a region inside the ELF core image note, so there is no point
in having blank space at the end.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/vmcore_info.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212..c5181e9d049c 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -14,6 +14,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#include <linux/meminspect.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -247,6 +248,9 @@ static int __init crash_save_vmcoreinfo_init(void)
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
+	meminspect_lock_register_id_va(MEMINSPECT_ID_VMCOREINFO,
+				       (void *)vmcoreinfo_data, vmcoreinfo_size);
+
 	return 0;
 }
 

-- 
2.53.0


