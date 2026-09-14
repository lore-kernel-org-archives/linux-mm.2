Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9AB8C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E186B0088; Mon, 14 Sep 2026 03:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCED76B0099; Mon, 14 Sep 2026 03:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97276B009B; Mon, 14 Sep 2026 03:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E1F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:51:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E2AE1A1223
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:51:00 +0000 (UTC)
X-FDA: 85211596680.23.BAA4700
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf22.hostedemail.com (Postfix) with ESMTP id A82EAC0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:50:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=WCFguKN3;
	spf=pass (imf22.hostedemail.com: domain of "prvs=77172c0111=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=77172c0111=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDOIHgRCA92fBXr4xcQP2Sz2dW6sDDwTFYVMgoMYlcs=;
	b=oNNcC9mTPKT4ZbHnYUFdFStxva/2sgNJmMu2ZvdoTSNC+q0BfPaCyLR6+e+ovjxDKSuZMH
	lR24DmaozZtpeLAB0ctCNc3wdzXELaDbclCg+3m/4aJ9W8hInlQR21kPtFlDWIGl6e2U2I
	kinc2W7FR3DN/PLBmFNqOy8QJbYEHEw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=WCFguKN3;
	spf=pass (imf22.hostedemail.com: domain of "prvs=77172c0111=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=77172c0111=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1789372257;
	b=oziQYZh4CaHTYhaE5dUxYhEHep6W6LItufRtAsLgksZZIMCTmgP6whYTDMKbuXH8cZ5ZpG
	QvEdT8mbUZVHwNqKKGlkwUF3hWHTpaRKKGd2St0J4VRbFsGndcvzXVaSJ48w4FYeUEwJkd
	jHU/IT4gu4LWmTbZDIYr5BFSETEyc8U=
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E5ib2k800639
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:50:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=NDOIHgRCA92fBXr4xcQP2Sz2dW6sDDwTFYVMg
	oMYlcs=; b=WCFguKN3aEEwflv8ror5uZKo6cmU7rFOYUyrhkHaXhwbfgu/10bre
	/RIqLx6XQ+UfkHiamM4+KrEiC1lluU6TZHEe2VjYHcoaHewvVPaqDqon4tUihXRf
	DzKB4y/+twXTjzgrGKbAihp11yQ2bDHSASDcjU/v4pNk2XUQz8a1R5jkXJzefoeD
	7/DL8aTU7Uqc4PO15WwNgw72HZVFuBGWWDBixr6v6R0NIADx0h4A00KlL4dZEoR6
	PtDTyRr/V+9mKFbdX687c2fMWBJWhVVmg+yiQXPlJrpXIfi9KxmKWFqu0FP6N3of
	7J3S/+7uEydaQ6N+VnHXGaFVFF0Hc2/Sg==
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gn48br1c7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:50:56 -0700 (PDT)
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c25edb54d22so57852166b.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789372255; cv=none;
        d=google.com; s=arc-20260327;
        b=LkqJ2HNTuYXf4q7y2pevzzHVavUlgv08xoOzPnZM/SoxtCQ9AUdxLF/jYlhip67B+a
         hD/3pjuUzwfI2GV9XsFCUItFUEunHTk63rCl8lypw6lBUxCLT6ZoRI2E2aZ+qoRcoC7C
         VG86rGyfkka6zppQBQ+umOrNmfVtbYn4fMh0+72d1ssBzi395kjD/JPnEh/tLNQe38G2
         jr4kpqDpZfJS7KmP7iYqMHCJMvueyqRIqfiBQLCinkiNRKSSPJ6DN83fwfleEbht4DJV
         RwJD5GN82RA8yUiXi85yl5n+kJNQBxD8NBa0ZZp/n38cNGvYBr9DBuXiwe5x9ScNMCsM
         xm4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=b5IHm3fbXcJn7XNfv0FO+D+UbV/ZMp7hfv/7cooIizg=;
        fh=QYhuE9m57ZBO6lsdik3cdJb6AXIHXnPNnh2IxqMCZd4=;
        b=KUuMxYxtUxy0pngnRn/wB80HP9Mo2LPgFM0PKuyDoXfoHrYQWlcEqnpNoY5tgAU/cf
         +tEy8GNWSrMUm2Vz5P72U6LbNrzLcPuwyiTYlJP8HGlkaK/62Q8kIx+1db+mG6dq2KVU
         zcAZGvkdJmai/h7MbkGmxc7nXYBMbysv9y2RoBskzayiCyQfjrmbRf4YI7lRjg6DGzdb
         5Gu0tIKy5qqQ1QNziX9DjByeCPhIIPRY7Lix6F6R+I23b736rA+oHsKGqP8rICNTqGsC
         FR6WiL8/ZNMSl9mvzrmnyNDIskGcF4psWwJxaxyhrDW45LBQ/hQfru7mvOcCk18+bQzM
         WYnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789372255; x=1789977055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b5IHm3fbXcJn7XNfv0FO+D+UbV/ZMp7hfv/7cooIizg=;
        b=cdrosKxE2xy9ZXeVEImSaQyQsk5lD/+zoWO+mkkvIRWjlVdbLe2n4a/nCGsOgKj6je
         0/i4NZ7hcxiFi2lxwvFsl3bFWV5LZn2alBaBnm6WucmUe4VL/eT4XW0sFjPLc8aDRAD0
         8Y2JTrjizisDmk7i7kNnL/nPurz3pzZDr56IB4S9kbtF/KYW9PcyVPsqoUmpQq6HydMF
         vRZe2GBhj+pt5UqNctgiYYYKjsnD/MGR3oRtUwbQ3BlZ1+ITfllSBbwFshnlIks5vhDf
         ZadbCMZ9zpn/qkvMuEZI579plQLt0aAjfvuTAT6z1RWiVfEbG45CpN1DKLldA9k0nxZs
         QdTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwFnXXIZUWjXESlIEj+YDvEV9JVBUNMPEKBYcYhRmep1G+vjCuNNdjBQiVoN5EqfEdrIGv+MwEkVA==@kvack.org
X-Gm-Message-State: AFuF++nEmAJOHdKawOMBIZ639IrMLiQxMRHYtV7vjpUyclxOJpD7OyHm
	a/vxPz3IbV/Mtc6sb9gvwC0zbdkiVOJaWLz7YUb9ro37kNd/k7LwvhPC90WAG9Cdze7spz2kV4z
	XZuhhSYn/vBjVEP9btSrCHOXm/wslMqeCaT3nJLBLHgCJfpKyCbCgRKevUNJ01aHLcknaUdr8Xh
	T8Wbu8a8dHlu/pBap7A9h3mOi5Pw==
X-Gm-Gg: AYBFou38tMf992cWVUIFQHE1y3UmLAVTVeHsoXC9pshGPq5qy/5BPOhmvatWrsSZ6eA
	NqAIGe+5PPMZMXE5Q3sfjHC2a96VG74pvk5VLLnZAySF6PxcivegP73CRY6DVklzAgJ7kGreKqZ
	IQ/CI8g3yL01gHxUlmWKZ1k6TdeCuH/e4z3wre7ghI3vL6pwfheE6ln0GZjavyVYbyoZDJvWQIP
	CbL0X5ML7KDimP9kw==
X-Received: by 2002:a17:907:c18:b0:c25:8e53:45ca with SMTP id a640c23a62f3a-c29b87655b6mr140824666b.21.1789372255347;
        Mon, 14 Sep 2026 00:50:55 -0700 (PDT)
X-Received: by 2002:a17:907:c18:b0:c25:8e53:45ca with SMTP id
 a640c23a62f3a-c29b87655b6mr140819366b.21.1789372254932; Mon, 14 Sep 2026
 00:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260911121341.178028-1-alex@ghiti.fr> <20260911121341.178028-3-alex@ghiti.fr>
 <CAGsJ_4z3bSfMTKvkXsKAz=+dzhmdGOerSfL33t2RkN0CXZV-hw@mail.gmail.com>
In-Reply-To: <CAGsJ_4z3bSfMTKvkXsKAz=+dzhmdGOerSfL33t2RkN0CXZV-hw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 14 Sep 2026 09:50:43 +0200
X-Gm-Features: AcwNN1U5dS5EtcARkFGKnblzleHf1kNpbwhWpFFrqeypIiGrF-7Hdyx4M88AHOc
Message-ID: <CAEmasaX64UPFX=OTQ6pC_XqjMqiuj+fD76-7TFWBaZFE+LODew@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        Kunwu Chan <kunwu.chan@gmail.com>, Tal Zussman <tz2294@columbia.edu>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=JMCuIMKb c=1 sm=1 tr=0 ts=6aa7a760 cx=c_pps
 a=jJvPsHQLKLf2UdvVr97r4g==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=JnKecZnUtZousrUlYMGU:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=ufHFDILaAAAA:8 a=TYz18Bk7nizorY65d84A:9
 a=QEXdDO2ut3YA:10 a=q7aydO1c4wibL4nb3gNS:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-GUID: cgPCbh8ZEtVch1rSzBnrdabo2jaUAYk3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDEwOSBTYWx0ZWRfX4P1OJkYaUHe4
 L864Wly9AFDPJvvlGg8ppCdQLGEXuAL2EAesuOgPqWVC8syfmorVdR2vwnCIjSIMb8xt90XoeD5
 +hYuwaT7zb3fEQhJEP7AKqrGdLhng0s=
X-Proofpoint-ORIG-GUID: cgPCbh8ZEtVch1rSzBnrdabo2jaUAYk3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDEwOSBTYWx0ZWRfXz1RV+omlhOAp
 T5Dt3LZs4m/HEfLLMndozVw9l2RRFE46EeSLdqviExpKVmmhiMRycqSNKLG4DgH7PdNBggOXRKG
 tdSq7/vdnEFMprK6vUigT2yAP3qte7sMO8BSTc0hSdGr7rTyBHRxKR9vAZS/eMOw0H9nL+8S/pX
 F3tR7ngJfluHYkKfZpkG3Dquf+/M1U/hv29mIatsHBFa3dX7ze7MVxjJR4G5nmofzOm5VNOEnYj
 bVDXpwfkT52Srn3FHr5sjtubc+Wp/9kIXnx0aMYx3zWwgqA2qUX9q4yd5qWsE8Ry278ZHMBZZ4W
 LettgRBdRAroNBD5h6VP2P88Z57gN4biSpqR6PEt69qPhlW8GaJuUflzTLW2fZ9QwkrW8Yg0Bj9
 I3XaOsf6LCQwUuJXXWFVojHLyQA/xQViy7W+VH2SDJ7PeJS4lmgtE08wXeE5mSu/WvOuJ+vy+zG
 g8+fUFs2ZjeoYz3wlYA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A82EAC0009
X-Stat-Signature: 7ghffpfiia3t1nr4jgg8nqkf45e756dy
X-Rspam-User: 
X-HE-Tag: 1789372257-680242
X-HE-Meta: U2FsdGVkX1/1igpdfginRqv6IxF2Y9RPAtGA7GMtLrGfDQ2CkR7cHjidp9sONHbaxqZwTgkXMrDdY+DU9If5qa1N5EzIJZ1dkUNjJ5qo+/Pq5DC5YG3rc9JcRfVXJAZ0RSTrKQ1lPa9rb6l2RXLTjA4i88TRTFDQLcF6hc1cFiWSMGp+65praXXi7wffu4n44sGICrnOtoECsx4bpTpun2Pb55p5Vo/bxKDEaxIda2+h/Wvw+cF1sAkeKxuQsb+PgGzlky/mLggo8Exh91oMzpSc62d3VY4S/DpjIb1hCIGx/4PSyblo5oS7hTC3q+QWnyGvHhsqmXSOvqeBrCquyIBBovWT692otHv9G82U05dMqEi/ZM7g56pzaCLJQsHHE9BM1CAD3M8GGPpSc6KJHC0PVTYyf9InYc29jOh5qFuxv9ZcQkDQEZYSOypYCH5A/R3/k1QTY8ySzAagxYn0lnnPsEYBHPJ9CaD7+98MybQbHY0XVb0wJtzUlSRSupXYTv/ptU++WKKHnH/QS4k8SHCVTaX5c82WIATliEk3hOWrnOeUuvIyGN7HyJV1fWZ4C0MzwlMkRjgApuV022MynCpZvspu7QwUuAKZZmx4/0wL4RgXEuGFthdBD8T9LebghkSurnkOMpD78ag6zrpoVmlEfvQw/F8lyBZ30RCOJgL0nHdIB+FfmGCvju3WrkECkGT+wtPtQsjDGayNwjFr44d+6qmEPkd9ho36VMRiP3cCwj/jqm5s0WGNj//JG+OdTrGfQuyndyd7+j933AY8iEhFmRM4S+jSVPnRtN6l54AeGNC/rgoKBEgP6xgoU4zJU4pDzHUvYG7K3KU9XRioU34jTAW23U2YdyBWh5AaMjDbFTSLeUQ+f90HtJmakomyre1maC6Z2BYX8YQm7nc0bjMKaMEfHrGMKsXIl3hxuu6fuZq77i4mUC9EF2lRIZ4Ka9oLdRo+Yi8XA6xjsYY
 dBuhAMQd
 8yfJFOQZa+0BTTEUSYNe8QagKUHF7UwKtIWdAtANeDvcVJXCQH8CpTuJ+WLIiD11kbgJCPG4Ky07k9Y7ARcskyFbHDZ5n5dDO97Dd21C63OQ3f4bB4u0xeRRZnmCbsxrRfobTBfv/CcUnpWMJruEnKfzWK26jQKHWhQKm/0xFZpI2rqOu2dk4LzgObto93Zcr5haraYvbkepVrMhRwiUdhWvb93IgZILhfhyuniAOeoda+lpRhpW4nZC+5ssu/izcSwngR9rEn7xoHptC55LBmstLVGEtB8NJ3Ea5VGSf6QgrRC5uCSAIcYLOoIAKkAMluutdDKGqP3csf9ImMkSExKHwSOBfViHwUDPxwREtic6zzJQiyhG+TJtOUo47vfprF9KRYDBJqh0kEnEmvQvI+ZbRaVSi7ijTbZzdfC62L7dOXa3yAcs8FBgcMWOrWtZP9eBk7cOBFkgGunLaSlY9ffisnUdzAWkqT50F59OqAmu2eE051CQaJWzaJLPGAQQKVz/JNY3mxG4ARFiJ2fw/UZ38LC1zS/T1Hr29NAfgY7R3/T6vbRXip5dyalwemcnNgF5wfyJyL/A/FZswLn5nKD1q4Mdbfpjsfbz6k6N6wHnpG9Z6bXO7TrjMyWTZ/7H1Jx1XSql7swg9GUbS0hZ4wMfUwIsASWi6/wFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Mon, Sep 14, 2026 at 1:01=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> >
> On Fri, Sep 11, 2026 at 8:16=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > A PG_dropbehind folio is dropped from its cache once writeback completes
> > rather than left for reclaim to find later; this is implemented for file
> > folios in folio_end_dropbehind(). Extend it to swap cache folios.
> >
> > The drop takes the folio and swap cluster locks and may sleep, so it
> > cannot run in interrupt context. Set BIO_COMPLETE_IN_TASK on the write,
> > as the file dropbehind paths do, and drop the folio directly from
> > folio_end_writeback().
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> [...]
>
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 88962571cb93..52eae99de6e3 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -602,6 +602,15 @@ static void swap_bdev_submit_write(struct swap_io_=
ctx *ctx)
> >                 submit_bio_wait(bio);
> >                 end_swap_bio_write(bio);
> >         } else {
> > +               int p;
> > +
> > +               for (p =3D 0; p < sio->nr_bvecs; p++) {
> > +                       if (folio_test_dropbehind(bvec_folio(&sio->bvec=
s[p]))) {
> > +                               bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>
> Thanks very much, Alexandre. I find the code is really much,
> much better, but I=E2=80=99m still struggling to understand why we need a
> sleepable context after Wenjian=E2=80=99s commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=3D=
848d2ce2fce15fbdc083fbf9691bfa72911033c4
>
> With this question:
>
> https://lore.kernel.org/linux-mm/CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz=
-cHaDWLkxaQ@mail.gmail.com/T/#u
>
> In short, it still feels a little strange to me that we need a
> sleepable context, especially now that we no longer call
> `folio_unmap_invalidate()` for unmapped folios.

The thing is the zswap writeback folios are not on lru: that's because
if we put them on lru at allocation, the perpcu lru cache holds a
reference and it prevents remove_mapping() from freeing the folio (I
measured that with on-lru folios, the freed rate collapses from 99.9%
to ~3%).

So if we use the folio_trylock() approach, we'd need to put the folio
back on lru otherwise it would be "lost". But I don't think we can do
that while someone else holds the folio lock.

That's why I use folio_lock() which can sleep and then needs the
sleepable context.

What do you think?

Thanks,

Alex

>
> Best Regards
> Barry
>

