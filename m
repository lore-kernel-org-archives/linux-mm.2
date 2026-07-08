Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D7EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA296B008A; Wed,  8 Jul 2026 01:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4911A6B0095; Wed,  8 Jul 2026 01:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381A16B0096; Wed,  8 Jul 2026 01:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 076EC6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F3C3A063A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:19 +0000 (UTC)
X-FDA: 84964491318.26.AA1B20A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB6EF80007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:33:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=A7BSBhmn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VxnllRrR;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488797;
	b=mNn6E7ZIey6Rt33MOwba9EG2Y9MPCjhvv9Az/e0wuRjdgJcznf7DuIQoADhdcINkYeCCa5
	/+sUjI/UPkJ9gi1TLDeByAXk228fRetHkY2jNvZsQ+VPlPFSc2C+oCkhxY8271dGgZv+kB
	CXyRxJxTTyE2ZNmwgVcsd25ZBQh3cKk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=A7BSBhmn;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VxnllRrR;
	spf=pass (imf30.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KS6KjK1VRA0E19Ye/3uABUACVvGYCQVpFSdxjmPI/eE=;
	b=3pwYC6WuRKPI9cmx3s7CHD1L0fb3AHsWJaC6jtrAFjrQgS/kvRc4nqm+wBpqjxDk8VzkPc
	G/YHWhFGUslGto1egIJ2PmXRAEEzQhrWrFStgph0eyp5z2WU+o5j9WroQmhEzPzi2cVltH
	REpLKJTFB3+/ZcjZ9UJAKrNAEylfQ3U=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842U8I1447476
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KS6KjK1VRA0E19Ye/3uABUACVvGYCQVpFSdxjmPI/eE=; b=A7BSBhmnYL9DWL2C
	l5JDHhwJ7GrYQHhPPKjA404myQsOdZd2oyRn+UsW04vWmNE7TR6RTv4dXk+7gp/W
	3y7LDxyAXAauz6Eua/VvYIpk4vTPWLT1P+6f3kJrlN3vryFcLA2EkxxJBRVZeR0C
	XIW76Mbl7R7fNY2naLO2rYODQ3AAMHozxgt2IhBGFH2mQJf4H4S2sxqSH6zxuT1O
	XfaZ3LN+qpSMwaexOrXBNB5vW0FoS88oVDIKRiNzYTuIz+vgY9Hj3jeupq4y/6BC
	q3ZS3yRSpez49f7J/yMTrYGBbGA9hrUu1U9DFw4X+jZKtpgjgo5fTKGdSYV7oNtf
	oRNmsg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f97u11tcb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:33:15 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84770f89b99so569532b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783488795; x=1784093595; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KS6KjK1VRA0E19Ye/3uABUACVvGYCQVpFSdxjmPI/eE=;
        b=VxnllRrRiND+gMQTXVsp4KAudtDp2vegpyAbbyakz2qbDbreYmdGHg6mm9cirZQIwN
         EaO5dXQDvOGNnbBOvOnOoW04uHlIcFYYLXh0ZvE2McGfYFkKS+YdNrEOW/s42Y6rV3zY
         494vpSD4NUZjv7GSS3VdAjPhEwDjphbbTOwAHBqosFqhWsAkn+AFHs5uvbEOggohPKgc
         qKyCb9tfzuhrvNU499o/5JUlPDcHh7nUYmvH9tNPivqdLt7HRnMmc9lQUZCyNZxYoYgK
         glRIFyYAQ5dOSGsm1EG2hdMagyZtD8Kv0S/Ii6sCLOO1LsByybbPWaYQEPNXhSwdNsv9
         5GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488795; x=1784093595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KS6KjK1VRA0E19Ye/3uABUACVvGYCQVpFSdxjmPI/eE=;
        b=NNMtzAbfvG07EBXezmSLHWSapEoUJvj9VBA9kwbKz5eQPiHZKWaO8uciPhHed8o9M5
         7/S5IblYwskKltnP+2w+5lHIYS46Vr48zuTYDb8ir0VfSuhNowr8PbX2YiW/XhjZmHbT
         buGZrCO72dP8wKdwReJ8UOe4nDAR6gFKhLlZQBjGZK64JBmIhbLptrCCzr6ND55AMsG6
         PbrSUodm9U3Hts5cOiUNstzsdq1eFbJf/qsMSWov65aw+WBvTQU3n/rgK8ls0pGUpmLL
         TLCJTPwBpFnqUufm/JAbGDWKMks8pDbDEDZgtAqmdosFRgkdIRR9ADee5t7ImPNhuONr
         dzaA==
X-Forwarded-Encrypted: i=1; AHgh+Rqedx+vaa3qstaXqgLUEOjE+8tIywYL8GMMqO9cmZQg9gs52INjqJi2BD/NkdTPr45dVMqru67hvw==@kvack.org
X-Gm-Message-State: AOJu0YxvKfsfxsuyF9fkukPlY5d7MbkE1hIk3tsC/Y6dLleVgLbXWBIN
	X+JYn+UIu3idCHXDld8pT+8SsammHOdvxHdQ1PMr/GviTlWGfr7qV10Nhn55W4xI6GMt6h3WdCN
	da5UHhsR4j+LanhpnL9Zoo88dLhgNRYA6w/dOWSguNvj61ZNlrFMNGQ==
X-Gm-Gg: AfdE7cnHMvnej/S50AU6VWgCfAukR+N1ARXeQx2bQ/79ALfDuBowoJSH1wRO7tJ/jDm
	Esozm23xAU3SH8mOQd5h1HPDc10V217EIUfYWTuQ76aL8LCzWopwQ4kMnp/JpgGz1UpFbGhQwHi
	7XskN4NCKQEUlt+0a6rxLsr4L3tNSawZymL9bJtU2lL3pQRLZzxtdTA8DKDjmyzSmM9mcCdc2XL
	9N+cw5cHoTGv2Wni/VRV7tcQXsZLRa65kucIBHxy43SWNZaUGSnyR8GUyEbvyplXaiqbpfxjZGo
	UArq12VW4cUJMiSM/Qk9O807GumFzjfnQAdGEagjO5YEHeo5f9bg7N3uI6+ov/YVrDKxNtt10rj
	exkohYcqdOXfeWwlYnx1clUnb8301qsyaQAJa1g==
X-Received: by 2002:a05:6a00:9510:b0:848:2d1d:836f with SMTP id d2e1a72fcca58-84842f090c1mr1174821b3a.28.1783488794565;
        Tue, 07 Jul 2026 22:33:14 -0700 (PDT)
X-Received: by 2002:a05:6a00:9510:b0:848:2d1d:836f with SMTP id d2e1a72fcca58-84842f090c1mr1174746b3a.28.1783488793925;
        Tue, 07 Jul 2026 22:33:13 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:33:13 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:01:43 +0530
Subject: [PATCH v3 04/26] cpu: Annotate static information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-4-7aa5a0a74d5c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=1623;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=7tcV3EojDUJDYXtqUmecbHdHj5TxMJCFkfbTBXEPzZE=;
 b=uPlnXmsDJ/5XV/qNRqQUBd29GoRnPLMg69Q8kK5yzcp43jc/cas0ETVH8wiJJdiYqnzbfi3s9
 zEovQovAgGzBkEvohecMwfP1GUVvyzxtLtHFt9S/LksPawXMLNMVZUu
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-ORIG-GUID: p7KUPvXDArr1-5-w8ban2CHzMX5QFBHJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX1M9h6M+YyZJr
 b0KHYwaKzRcWbDces3wQcd/Ng3x0XSgBwf3hBsxMurapLcrndklzVO7vhYpu4nGpywV2OtBv6gU
 uDyYePNXlip0bxPWjSFzKeUbOdyjX6o=
X-Authority-Analysis: v=2.4 cv=F9JnsKhN c=1 sm=1 tr=0 ts=6a4de11b cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=3A8An4GuCW952TOlvi4A:9
 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: p7KUPvXDArr1-5-w8ban2CHzMX5QFBHJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MCBTYWx0ZWRfX4RTVm/d4CTIB
 oyPsKR1/p5N7dycYYVO3TqcXF3IF6SnEdXMNnBssgQ6pq9NiHAw+8XkS94Jw2zremZEsMhltOkJ
 JNsJm9iNg3KY96CM8qj0HWLJgiSkFpPIczKqIoNRaJ7Q7zXBrfIgvTGgzG6QbrXETDAycuXty9k
 meSfsFvvvBZEdJd9TRYjkiG3/w5lM+iaViJyrQ+Z+cNbeVewpvxNxdSuN/OZphRvGch0GcbrgvE
 9itZkjQbgS0lDbp3wxwbkwpgmJv/nKh2cTUeL8uvlarBvDYC7L8AQfHiy9ymHrJuEFb5C6Yd7eY
 NlkeYkUfjq5/HYjpal12r+Xxh2OVW/bzj2cQqDoLXwBzyUSkX35eAenr0ntNcZq9uTr+g8WT3Aw
 ICi0qM1XiPNpIw70JcVKxO+MVaU6GdLs2/waE5eMfaBv+jJeImVeJBy3ebGgRCvIkCEIVDayDdk
 lx3qnbRY6SHciZlGntw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080050
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB6EF80007
X-Stat-Signature: 67jtynypw1esho4pjrtqkzxwuzqiua1x
X-HE-Tag: 1783488796-524827
X-HE-Meta: U2FsdGVkX1+AGeF1payBrXu/uj3mycYZ/0Fk/u6dL+sWMk8FOp9q9uyawdyKyWDKfZEpplPfjn98Wn9sG+3qU4CDqENeTORjOg96HhIw6rpuQYU8PNOrkw1dhRNxF5oJAZoT7nsoOh4i7Q18/t1rAhlnmow9uT/SNEbDLeRhJyx3zXcYHks00AygflW1YvMK8scW/dFt942zDN1l7MexI9SAYIeGDRO1UmEpO+n717XpAeCV47HBaGmXV4k34iqUcm7ObbrLrAG/Vwkh7WxWelxLBwwqBAD6Da/zoo5hX1xyebTaxAIRf71jIeZOMlGt5zjRky9RLzDWSE5Ffj6J8uUA2MXnH6KAwGkZHSQuVbjeCFaQ3K8qpDax503mj8seZSTezlLDm95uPJcr4NyIPN9V4h0SaWZetth6Dnqz+J2C4LB3HkW8812Hakq8G9l1IPZMhtk+GhntxcE/rlUsdl5QrUyin9LkA87x8mXhNolXYIArQsqUFB8Ey8Mcimk5B/KnpkLKk94L3SWDm30Klfp1CpcJZQXQMd0OscEeuT0b3SLgxbxi2bk3gv+va63NAoOF29dfPzhq5LttE/TMYfGuhgWkoVhma9t3X8xNwoieKaMY4U7XlRvJA4STvhwwVf2GiER7BfYLIMNVXSwEBUjXrfziwp930RpKCS79/jCvlkNo2bZgmNexndYCB7VnbTkxdSibPxC0ChxT1bmYJcsyrSxZrUVOPN2d0TaSyH7fGKPzJB8oNmveDc5DwPaVPa/bqu6ApSy/uDzPuTX4wO1PirR/Zdfqpt1dCDvZVUcE4oZ72KwcKLEcAq0+ZzkI7ZxIodADI9K3LlH+DljZKS0UiGzi+Rn80L9GdOqYN1Fdf6d/Sl8KqF+RF/rSDNibV14hgNwKZSsEVMJq4joC0UeqWUZqmiAWxXaIxU3OnS1NVewVv+qWIoK6urKRPMBMZ5ZITESTdmHCf79uCdm
 YImOpkcI
 pLfImOka+Mn5XCagK/6EnMKJUd7QlG21vQWsZQlI/0A2E4zAg9GwICy3OUS2GT9zPxSXz5rtbVVe+hclTgRCbUXwFujo7pm04xrbuP9rMNwvhBIlJQnzKXoQ7/TnHJE98qAqndZnDSlKHcaRXHrbtomPrybiSoR6JrwBjLBasGUvBFXADMQL3l1apWfg7MhogzIa/GIDYHXLOHfL6Bsy0wbbGjKgIsvL551C9PgpErqXMN3EWgaOSQY0289vtOIU7u080lDN8tddeQK8ZCs+bYhW4diWzEU/9srWIUx6uP/zyBa+73NpxsI0x68MmkcKfBtdw4AxQtqhS5CwQ4RzkDLDHpppdwTxs5sO5hGpwqBAJQV7Fj2NsmgqiE8Ey1XOm2vUok3TxoLs0hQaN52H9TEgXwpqZ0gGoaGUFZZ36v9RWQmcz+ES5nwsn+Cqlu8789nQtUiBrkm7yJe092372BYzv87aeLvIRRWy0foajSo1fsZZwioPjV3z7ZwatUs4EmQE7v+FX9bjw6UbDJpLCAVwvpzIGFRowOTaWdFgcn/Dsr34vNL/xJXd2A4GKHXfu8q8atOvp2vlYcZ5hczz2FNy0CeE3f9fo7C2f1EBTTb0Pe0noSrKjOCPfYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugen Hristev <ehristev@kernel.org>

Annotate vital static information into memory inspection table:
 - __cpu_present_mask
 - __cpu_online_mask
 - __cpu_possible_mask
 - __cpu_active_mask

Information on these annotated variables is stored in a dedicated
meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..01c86510124f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -37,6 +37,7 @@
 #include <linux/random.h>
 #include <linux/cc_platform.h>
 #include <linux/parser.h>
+#include <linux/meminspect.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -3083,19 +3084,23 @@ struct cpumask __cpu_possible_mask __ro_after_init;
 unsigned int __num_possible_cpus __ro_after_init;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_possible_mask);
 EXPORT_SYMBOL(__num_possible_cpus);
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_online_mask);
 
 struct cpumask __cpu_enabled_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_enabled_mask);
 
 struct cpumask __cpu_present_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_present_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_present_mask);
 
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_active_mask);
 
 struct cpumask __cpu_dying_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_dying_mask);

-- 
2.53.0


