Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A006606A330
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DhQjNKNt
Received: by kanga.kvack.org (Postfix)
	id 572886B05D6; Fri, 27 Nov 2026 04:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5229F6B05D7; Fri, 27 Nov 2026 04:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3566B05D8; Fri, 27 Nov 2026 04:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB3096B05D6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:40:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D6C316027D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:40:14 +0000 (UTC)
X-FDA: 85480403148.15.2307386
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6A7E18000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:40:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=DhQjNKNt;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1795772412;
	b=sURp7vCklbB8m+UoBUINHQlU7A//6kYz1rcu4TSjfP1NFlSjvtAKll0wgU00UT8iQbiohs
	Yq+YlTJP/iR+q4sbuZZL/MvQ4s9jwsag30NgpD8sxX6xm9UY5o0xYFS+R/0kSCvDOmTOYC
	so2b/B04SDAlJjPMac5u1KmA8YhFQxc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795772412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is5J7r0Ef/xrmo4YxI5quMbN9FdWHv/9/YnjItP6Yt0=;
	b=YMF2DOlKxk9rbC+Hw67WbgDq7y7397JdBDe93Rd0sd0P02x3fl0b+TNCgEy5fw9czdujWS
	U5NSSbzqVnAUxxWxG/HaVaVrPmUWMQ9HlSdK2pECZ7X8wFIGlPyQPYbbwHHdgolMemorpc
	Hwktm2spTm7Nqod2EpMtCvnqaSgBm5o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=DhQjNKNt;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf16.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7HK3E654564
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:40:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=is5J7r0Ef/xrmo4YxI5quMbN9FdWHv/9/YnjI
	tP6Yt0=; b=DhQjNKNtWKTSVhjXUMjklBf860c2koaQ0BDBebFB8iv1+48TJ4l4O
	RK2rrVoQMZm1xxClAAFrl3sW8FYdfrZlX2bmE8a5oeeRyLxsQMwwjSD8dZHZ41YQ
	uL1YMuc8N/b4Z4HhoIJZSE98aDbsECIHIeFFh2Z1jsrr35DQqA8f7D3H9qbNAS4Q
	p7PYhI/I6441lOuYGk0lUMb/24xsx5LAQ6aTwxoDemHaoVRa1lHPa3tA36VP+xPo
	CWyX6iT+jygqJwYBh2UBjuFelbpXC7qPtXLUDr07Q3+2Kufxwvb74bIU18+5aemU
	uyBTpoLmo9qKqlvu0P/wtwwtUJO7bI3Qg==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5k9fxjqt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:40:10 -0800 (PST)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c50657eaef0so664001566b.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:40:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795772409; cv=none;
        d=google.com; s=arc-20260327;
        b=OKAlaIJIlELfreix50r7ahmgu51umxFDUHFG4AO0qLv6/e5TTcjhgvlqBtKXuA8Yaa
         JzNjuCXKv0N+b8PsxEdbOhhy6oW2+4MQieOSwYN3HyGKs1Fs0bv6xB1V/brQ1ijYardK
         DoeURNh0mD5W1zL8ALO+oDM23pBqOJUdBcpl+XkVsjfr0QAavP/5RGHRMOvgII/d01HX
         ri+kkymvq1iWc6/GZzmsMwbhHqdFBUNUw0/dVvE4dOQRu4MlGGPmDsaRUVO61PVZBKH4
         NAxOb04L4ETO5Zsd5c1VYe2SIzjEdDGdt9kdLQFisZWt6JciNuWbc5W/nI+G55l8CoPT
         ZuCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=E74cUDt+53y0CLiPmLFJnM4HNCk8BJIOGuonFAunoHU=;
        fh=GqnOcU51uMcYsPqgQWfAN0TbPYBbWUyyswhawVg+Dvg=;
        b=KQ8x/Hk9rx0wEEaZkaISZm0qV59MZuJcY19YwgteIo5zHPqSvMrPTfj7q07crZx94T
         PfBu8t4QFnkDicMbGhhg2Jr2KBCNFYZpbUzkkbOeyquUTQu7s6jO7z5l0A0b09qobAFV
         Hv0SE92joz6d5K0DPvc5OtpAB9QdQbAkDnKDzuH/H56o8bp1J+7161hmdE1lmej/c1o/
         c/tHisX27a0FWHNu/ffdYXXFI/oz1QU0aMW1XPmENtbBmqJ+9v1wlPLjFZRdzCbGQtBk
         LUC/p7nQXmMA1jFXvrJRBib95I6UQzHDAeAJgAMTm2PulItzsygVTmBn+u+NTyjc4fEk
         VM0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795772409; x=1796377209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E74cUDt+53y0CLiPmLFJnM4HNCk8BJIOGuonFAunoHU=;
        b=04NH7vf5z7ziAH0An6jsvRr56rdA+lvG5CDd1arDRM9c8TUc+qlldv4W6FSlld2uSC
         0mHf2r8H3gx69+49LCMrzU5O4HZZ0iLjwIkIddUbd7iZyNKgYCg0jB/RhWGchkpN+Oxa
         Twdr/0kqbSOLFVzyg8C12vcEQiWm7D4g19Wrlmc/k2W59Y7ZMUNOKhC/A4VEwGhFXvlE
         CCbD9pBK9nK3veFZlqRmX3N3AuhJoDk1Hz2viIZG6okue9nN5SIkpnEpKUFKn5wL/1Cm
         DDJ4HQ8sk9FWMNsYIiCPg2YC4IfYUPjm2kvwSGCP0sXe4sHVI4QTFUTaMMTiCQsM6bet
         DWvg==
X-Forwarded-Encrypted: i=1; AL+hErGEYEPeoCqdoR6GPXiXV9sDBB9EPmxUu2HDjSO/qzcmu2tC1Topp2WgrN+JHz7TmVgigdhSC7ikPw==@kvack.org
X-Gm-Message-State: APuU4Z9PmofGc1KDR1w/zTiyLv+9dbfAO4VVGuhPrjJ0uR+SLdx5yfhB
	/zHzGUA7jF/VrtH2s/ktrHWdz7m+9mXc+8JssQAQfDyPBmm2fSm0ZCppGss8uqglvqD7xPxIJbo
	++XEgg5CZdMo0PwnOShCfVo5Tg9o7vaSZhrxlu13th7RWByQIOKDqT8x+XpgYGLb9nkv3GU2bQu
	By+qVsppilN4vID5/gh/4lsiu6ng==
X-Gm-Gg: AZFdTZd5HMDCBW1eg9H5gWUdrRjDP+o/xzKvxoGI2qzJRLs+7mqxuzuNFgLsnk2WE2a
	ZMO73GLwcEKzTPnVsdl6489ADLwZE3nfXCwiH4+iJRY9QxdpRpQurfzg3FMb8h6oVb0ldNpIdf9
	QL1rkaqlN52GyH7Z9z5FjKoc9Up/yYnmT6qi3qPajeTIYk8FUkCZhZriL+uMzEZR8C25rj2TH1j
	SB/ZDMJ3pZMYb1Rww==
X-Received: by 2002:a05:6402:2812:b0:6ba:9d0c:cc6a with SMTP id 4fb4d7f45d1cf-6ba9d0cce2amr11603235a12.30.1795772408952;
        Fri, 27 Nov 2026 01:40:08 -0800 (PST)
X-Received: by 2002:a05:6402:2812:b0:6ba:9d0c:cc6a with SMTP id
 4fb4d7f45d1cf-6ba9d0cce2amr11603214a12.30.1795772408589; Fri, 27 Nov 2026
 01:40:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr> <CAKEwX=Pt1ke4MdjDB=bpQn1bBbdxVao4sx1ruTawYQUY+ROvNA@mail.gmail.com>
In-Reply-To: <CAKEwX=Pt1ke4MdjDB=bpQn1bBbdxVao4sx1ruTawYQUY+ROvNA@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 27 Nov 2026 10:39:57 +0100
X-Gm-Features: Aa3M54qcjTs8ofwTqh-jGgLfXEfH8dMC2a6-W8fsLMUfYshQ-oilOzocX_Q6zcM
Message-ID: <CAEmasaVP4FSKNqThkqtTn_Sz1EDkK=qb2TGVdoTAVa=9XBwcbw@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Baoquan He <baoquan.he@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Youngjun Park <youngjun.park@lge.com>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=I9nw19gg c=1 sm=1 tr=0 ts=6b094ffa cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=pGLkceISAAAA:8 a=vvh9Qk1aVFpNxidmG9UA:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22
X-Proofpoint-GUID: NFiVBbgCEbCTSiKLdxp6saLQR3UDuxMh
X-Proofpoint-ORIG-GUID: NFiVBbgCEbCTSiKLdxp6saLQR3UDuxMh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDAzOCBTYWx0ZWRfX+aj28R7gNzeR
 cDe9c2hVUtlmYOXfLo355ir52yY57Zy4YIlBNK1qD3qlIP/jqgaysAeDAeusigHSv74M+aq894+
 DJnWA5he+hQVHd9BUhZ+nzomvkjcmiU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDAzOCBTYWx0ZWRfX176xa3khle/V
 jh+3yfyw11yOd89PqooGqKXxjajdJQhz635uZ3VSp6paUBNIrdo9YcVb/E3uigzPM6ooxbITkSD
 XYuFLvqUIp2qTX0aG+SodJu8m2q09xBoDZhzinu2sT4gP/jIx1aMB5j8Zlagl6Xwuyl/cQi8QwW
 JHRbVrk0peqciAlo9m0TbtxoXYilT1O5BNnniQaCk25366mjlbQRwK97+YPOy5F00NgbwIOAyvk
 TSWDDXxilzaq8Mb7A+7VkKUsxuah9OyK8Xkb9Lo1Ix2yT2iZVHDI5sEDa4eX4iD5rz7t/75HBjz
 shxMqlwkoHtXgkIOuWj28yDuqD0e6j2HBKkqAwDVx3u6s/0a1Y179Wk30EmeP1eAP+gRqbfO/W9
 9PuuQlfd01+E/00N5XrHXTy9Tz5JXQqUsuQhmAL3ea+JN1VdmetRtgj/1094qJ0ccUvUzCY4fXz
 UevUNd1G7BSO7G+QcTQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_01,2026-11-26_02,2025-10-01_01
X-Rspamd-Queue-Id: D6A7E18000A
X-Stat-Signature: 6afz5ujjr9ndrdwi4br61ajw1pbwjmkc
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795772411-75860
X-HE-Meta: U2FsdGVkX1/xUwaPNZMJ4e1x7XtgOn8zrSI9Q/O2ITSjQizwqungLbpTrjwuxmjlRgfAoxbLvytVJL6xOc1+hHBKYnFpK/ewZ78IdwgTLCKYwkdEWdg0kOt0ZyY8m2neN1+Z4caqaqvLwSBCMWWWKoa4//yN19JNWwaucGXmZV8kkKR+SE8klv75PGn5h2EVdXJi5U/hPkGUHlzcrnGQxbjQHG3T7mkC/CUqNVqZqUOSLUAflcBwWtz8DpAkO6Hs1dXWUYKQ4fFzM9nTTc2iBPXUEJSODqkscXhXMcpYywwpONMNI8eVXuthH63NwRvlUMrBNNkPi25dhNMQlbVCnPyez4prCc6N7zMNKO+vMzaf6QOm3+gj63UfiUO50LPjYGWZlwMKM/JBNlbrZsjQRxlbIsv+Vrw5eAxuW1Vc2urs33Ulh2wjCje2Dox23zCIR64yfzv6huLxJztFLrSCEq1tgbO8uSSODHqOPXTbCdqO0X4n8+kRUihWSwYWd23NKbGbAusIMJCuAEcPR2QeBbOxJmkhjyMlyjJG+rZa/6hJmLZN+Xvym6GD9FXwlAkWNkKxl1GhTKdnNdyuKZSyqwGnik5mQi0ws22XHrfE+SQ2y87aoSnA6HRD7UsWJUtECS9ognuv8/H9FiRijRAF1NSnE01uRBLUeepGVNKLadVIJv2bZ299B5N8ql4XIUlBduK0a4cerOG+jD91xS79sLyyvVzStUm8ZVOtgzkqov8s8s+YZvzoD8idHAHsRTmxcGbZYZU22ETLjsT0DN3+uVXpPjeOx9W5ha3jn1ICQzrc3gVa80NOrhgUtNWRJQeWJGbREJ0zL1cxRuc4IxmkcKd6qh3wtFlAK6byWYJmj5lySM64UgY7EVwz+CLJXiguzCMMVOPO5CjgbxUk2S7g98yTN+Rx2Tt5+lKNsO5R7wqxzbzGiO1I3jMr1lE0A6i87wIgLugCXJgr60ERqQC
 1zlJhG90
 3tmweM61INJH1TTZKpg36t6ZDZz+AT3tsgbZHEq/MTq7VfkCh0I3ucUtzsid47PPw51LUgnxm9U6MXdjey3dwp/AGZ225l71+oTpN7+u1fLL9lTYkymbYh+zVw1rJxchU3Sr0DjxBhurAVVLjcMEMIIKzwIc6o0JjYR7qQv+ldiHKMjx+qFvc+gC0+RlzhhN4Z7f8YvHPbh0YK7F7nuSQbw77xli26f5KZKVdaRVwrTJpBW869GNvl6sSga84ADWR36UkupGbF2xM94AyUq5dJmLS2uPQM24CLUPCJUbgz+Dt8NP3iNG3Z6U8ZRXHekvsQJKm4UvfkVdHO5ZNOEEEvz7DDM3epPz9L/1KLS+mov8iWHc1Dcqkdz1bt44FrS1ZBM9g20QeXyrZhzlCck5C7OBb6Qh2mkPKeDiz+j9+CP4VeaJq0o81XE4bGNdhl1iYaxo9k3dADe8xQBswuMPvquwDlHpoxqkPHs2oBsjRWIW28TOzeE9hAUMJqgNhITHvEMiWj4OQcVQPa/zPlg2LNKURpk1VWo7i16UOyhmiPf3wKuqW6PriC0O0Fy9UGhUuAZGHFepYbbymwhzDAlXyNLaW4WkY0bCYlB4PiCArVcK/ofnWbW1B3ts8H3HFdo2l2siTBsvsvpMFnmKUFZFYYnJOZ2pCpyRuF9fjZx/bBLRm7pGdpFpir5nWKcACSU0yFT+WUyIT6TeLlFPp4yxQZSYxhaFS6QNovlj+PjtnZyim4OU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Nhat,

On Thu, Nov 26, 2026 at 7:15=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Thu, Nov 26, 2026 at 2:43=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > do_swap_page() frees the swap cache of an exclusive folio on a write
> > fault only. A folio loaded from zswap is dirty: zswap drops its copy on
> > load, so the slot no longer holds the data and only reserves swap space
> > until the folio is reclaimed again or its owner exits.
> >
> > Such folios add up, and they are expensive to free at exit: on a large
> > production workload, the exit time doubled when zswap was enabled. A
> > third of the increase comes from the folios left in the swap cache,
> > each costing about 3x a resident page to tear down; the rest comes from
> > freeing the zswap entries.
> >
> > So free the swap cache of an exclusive dirty folio as well, so that the
> > slot is released at swapin, as is already done on an exclusive write
> > fault. The folio is dirty, so it would get written out again anyway:
> > the only cost is a new slot allocation on its next reclaim, which write
> > faults already pay.
> >
> > On the production workload, this patch removed that third: the exit time
> > decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
> > memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
> > guest (mean +- stddev of 9 runs):
> >
> >                      base            patched
> >   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
> >
> > The cost is paid by folios that keep cycling between zswap and memory:
> > each reclaim allocates a new slot and adds the folio to the swap cache
> > again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
> > not measurable (mean +- stddev of 5 runs on bare metal):
> >
> >                        base            patched
> >   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
> >   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
> >
> > In the worst case, random reads over 4 GiB of anonymous memory in a
> > 3 GiB memcg, so that half the reads are zswap read faults and the task
> > spends all its time in the kernel, throughput drops by 1.1-1.4%
> > (mean +- stddev of 5 runs on bare metal):
> >
> >                        base            patched
> >   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
> >   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)
>

First, thanks for folio_free_swap() comment from your other message :)

> I think this worst-case throughput drop fine.
>
> With SSD swap, I think the number is even going to be less
> significant, and furthermore it will be much rarer to hit this case.
> When SSD swap IO completes, it's going to be in clean state. I guess
> you need to have a reader race with a writer who wins the race and
> dirties that page before the reader?
>

The race you describe would not produce a swap slot backed by a dirty
folio since the "winning" write would delete the swap slot.

I (and my nice AI companion) think the only way (apart from zswap) to
reproduce this is if a swap write fails or reclaim bails out, which
should be very rare.

Thanks,

Alex

