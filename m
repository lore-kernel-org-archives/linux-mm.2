Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96421606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=dGcUTR7U
Received: by kanga.kvack.org (Postfix)
	id A85436B05C7; Tue, 10 Nov 2026 03:14:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BEC6B05C8; Tue, 10 Nov 2026 03:14:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923C86B05C9; Tue, 10 Nov 2026 03:14:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6506B6B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:14:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 004251208B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:14:49 +0000 (UTC)
X-FDA: 85418498340.02.DB83B35
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79E081A0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:14:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=dGcUTR7U;
	spf=pass (imf19.hostedemail.com: domain of "prvs=9774176f94=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9774176f94=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmo/fMBoxFe2B+JRVAByPcYqXixmz6jFWpSPY6BPjaQ=;
	b=kERnQVLk9bDkYtAcScJhG52kEQWsJO4zfv1By/Mgye6MD0wJq5M0LTvEdL+mFO5HEIBqZp
	TTgtxidUN/R3diKO+ZEL4QK2f2xZyHzTYvZ9YQgzOpxd0x4SnbzbkNmLjtp4QGFB1FU721
	AVnDYn5tW6XJmTM88b6lXMKl05xYWGM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1794298487;
	b=iraOI2mvuWUYcHH/qIacUaMEv9FPmtw/yJusKuUqyXgU5jJwsNOOzZB0VH0tj44/GVv5oR
	qjLCoRk3d2cuWNzMs9Pd+1Sl5DKPr5zWrAf7NHoj2y1XeHrn8BcUCPkaaY7dchw3WRHKGh
	6ovFCuK5kpOf4TeTe9irRsdCDw54hzE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=dGcUTR7U;
	spf=pass (imf19.hostedemail.com: domain of "prvs=9774176f94=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9774176f94=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AA7mYqx940598
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:14:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=hmo/fMBoxFe2B+JRVAByPcYqXixmz6jFWpSPY
	6BPjaQ=; b=dGcUTR7UegpYPr9sVQe8CKL09HPfRUWuwOKN1c57nl9yHNTzja6AY
	PiLQvqKh0JX8heGiX9XTY4GiJQZAxurl7p55D8IsGc18b9/4GOsNu1VRmbyPQeIU
	MOX43WOlhuNbF8IGA5ioOMSvnFn/NJYsw0ILMAVwPrVH7r7N/87kupsbnHnwV1w7
	eXd02F0kXQAhBrknLfhu0WSy6os+Fi6e+liGq97G8k8BpcwOSiiPZlrg7QRwAC0X
	BLhxR2xEfu3sl6Jj73oFwLCaAppx6iU1j8yHAKGbR+TKF8x647SVZPya27pNjMkd
	VryipeLzK+F4Aw/iaIKxVs1rRkHJohnmg==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ht1ycsbe6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:14:46 -0800 (PST)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c429d9d05f0so182129566b.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:14:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794298484; cv=none;
        d=google.com; s=arc-20260327;
        b=kUuomVL/1157dN0Ls3vp/S1cHYLVQGo+GKu+Aai50mJax+WpIBH57jHATiLUFhYBvj
         Ro7o9tXukCT4Ic1LgoFftuFGTN7D3Qy10sje89kYQ0OCjOoQh1J1SDKuvJB+4bAjiBvL
         OHyGFkm7TDrB3Ap/irj/Ee+YLjl8Ykw+QY0RHIz+MgsrEl1mhzDOiS8Kfa2NIIODRf4K
         ybV8lPmmuvVMOAndkO4uorl5naWqa8LEdTZLLiWxGcxqZqqy7PE7igfehOwVsYSkVb1z
         dnkULsCpi2Xm19PmusN59nopQKd1R/VdCkgpY+tkCvJqwwjE5l9Q/3fsmdOVEkXvuNXJ
         DK8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=gyLzlpGhZg8sniTvoRBctNU6s13Fevfb6cYKwRM4x2M=;
        fh=mJMO9gvG9ZSu+GlJL6uy77YFz/RK5OdMbXSl6fHs3SY=;
        b=aE51hSpIiy8qvQ8i3a21/Ec7agXadRYv+OPZJhBgm4or2YuunBRJDvFb7Pcr7tRU3X
         7MqZP3lkAZW0RMrFh7BYv29RmhFw1MDG7rGQ+SE4xKyP/O9jAhNizvYPqkx5lBLHRJ57
         u+dR0F+UCRZ+ykbPDrVkXIdPVGIaAGzMQMPDVfNFG5O6CUnD6midx3AHqPqM4qMg6YK7
         fKjuZUqQguW+ILqeyj2e0BuFqXyez7fpAk/AulbX+oxYuMmQNZjT/qDPuHMlS7yzxCtV
         r4jH9tDxuVotXfzGFqwda65cLdNAcoXoW+/FdTNLyH3XrJRHayS6p7nRUTDvmXGVMVLf
         vIxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794298484; x=1794903284;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gyLzlpGhZg8sniTvoRBctNU6s13Fevfb6cYKwRM4x2M=;
        b=0i6VutogU5+ZrEm8G8wGaokB++4jUqLg2tDOhnyEsKRusdu4P/vvGMxiWSXFEaDfly
         ZXwOGj4cTYtSGdEGhKfp3rsdGKOI+tWcoc+3JFannXSQbCUVFIeIYdNXLcZEBUkGgSwg
         TyNzisUeMSdVJ92MrCqsHPwTSvHaI4LOdCmA3s1NTdkJ+bkvaUXTPOUflQleVg0C/KIG
         p6dCun99m7Gw7sTwo6gMoi6k6zY6asybjxz1K10Vl3gsej/9AEAqU0aNVtGyNm/P6P0K
         SCmWHRE8wxUbJc6DRZJeGrekG+vEdLt+Av13EHdZXvTpGpbtkC6T3bE/QTwygSAqnYaG
         bB3A==
X-Forwarded-Encrypted: i=1; AL+hErEYBSXuPYR0A2WJNsrRsHMf9jIiKynAL1zRlcDHnsnRUf3WpMB2zo9noSf8kMdkAC16KCWVn4rqrQ==@kvack.org
X-Gm-Message-State: APuU4Z9qOzhvfRx7stn5rDUFA3cGwhnOWJUaWYYhLFY4rt0z4tC4+AoF
	hScIZUs7x7lEBQnwc6Arv9mWoXDy4i/F3XZjypFn0LBz/q7v4nEA5fTpYDWNAWDwapHxCfaW919
	YFIjHsYSg3YqgXMVVm/LVtlXDZuZl/WoEusrankRdjbB1sOitZN49i2YQXWDdu9J/qs4bpLDit6
	tA8k04DTtdY9BNTKfyUyPK2EA+5g==
X-Gm-Gg: AYBFou2fujT/U7sM5rtMlEybkzjgui7XxSGsJjSKNewNN9irxz6+fZ0/IHCttTgIDnC
	WLNeWI59O35e2SmGJ/5IQ33hKIrKbp8kPXm3ZEB5fVMxXszGGXv1OxoqCPs8PjT5o0fRUVp2Zi1
	GAWB8rbPoTAtffsWlUVFe3yptnCjYO3+EYSlQxboVZKkjd6SwJ5j/J44CCHQ==
X-Received: by 2002:a05:6402:13d4:b0:6b7:182c:5d4e with SMTP id 4fb4d7f45d1cf-6b755e6c44cmr1698850a12.5.1794298484575;
        Tue, 10 Nov 2026 00:14:44 -0800 (PST)
X-Received: by 2002:a05:6402:13d4:b0:6b7:182c:5d4e with SMTP id
 4fb4d7f45d1cf-6b755e6c44cmr1698829a12.5.1794298484159; Tue, 10 Nov 2026
 00:14:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105155032.240457-1-alex@ghiti.fr> <20261105155032.240457-2-alex@ghiti.fr>
 <CAMgjq7DpCCiEK00Es7yU_i_wyf7NU4fFN7QFO_RptF9tGvPZWA@mail.gmail.com>
 <CAEmasaWMKsBSQ_LrewZc3f6a2u15WARAk25AKWjS4oFy8yciCA@mail.gmail.com> <20261109152415.f7bb160e4089a17f15c8f42c@linux-foundation.org>
In-Reply-To: <20261109152415.f7bb160e4089a17f15c8f42c@linux-foundation.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 10 Nov 2026 09:14:32 +0100
X-Gm-Features: AclHuK9bds7F579Pncn9eD6wNRwnqJv1dEZAt-NTPVDd9Qni3oFVl8sFmvkMi3Y
Message-ID: <CAEmasaWm9KvUrfN4JtaqoF2H8z_d+Vyf+vxNXLaJoLZT=xFTJg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on
 synchronous devices
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: PZJeZwvaR2uGpMhAqujkhR40e4aIiNdX
X-Proofpoint-ORIG-GUID: PZJeZwvaR2uGpMhAqujkhR40e4aIiNdX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDAzMiBTYWx0ZWRfXy0LS7smf3MqY
 q/0DKFXQfbtH8SWEJ8+HL1ciAneognGw+4gT9Dwdzr06gqMpO1AGhNmd4pX4Oq/G8PglahsGjFS
 YSov2Nvc7UoHUSonMFCyWh6JWw5bFXw=
X-Authority-Analysis: v=2.4 cv=OIqyTiaB c=1 sm=1 tr=0 ts=6af2d276 cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=VabnemYjAAAA:8
 a=GvQkQWPkAAAA:8 a=zye6zbfopLjCFlMnxIUA:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22 a=HkZW87K1Qel5hWWM3VKY:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDAzMiBTYWx0ZWRfXwy3kn4LZBUmX
 dVGmFX0Up9ie9AnhG72DXG88MAHPG2Cr8QD69lw0SVnw2LLQt31E1xwwa/hreTa6OIhS+4W/XmZ
 9eFnPkvU+r1T0n1SBNvcKJ8lYR8S7F5ktuD6GjNuASMs9RkyEc+18auV9zWIaqXMikT2KiYc5js
 42HZGYXIlWnATjwVEZnBBmNzQulPIUh2T5YEhqLuGxYujRGr3ef5qftTYtygFR7y0/86ksx5YWS
 3kYRCi3w6MntGvCVeihcpVilHWuE8HWw8S85k84TxDAqMjwCvpxEaEjL07SXAw9U260ag9G/pwy
 FzpTWoSQwubOaejbmkWcUJF8g43l/sh3XM6RZpf7bpdMSof/oNI9BOf6IFiQiqMucWSQM+dttuJ
 LpkaYhI30d72Kjj8lA/FsvpDWKIla/iRGOzxujaouoC6iSzb9p0S9juVS/ZLxfqNbF8IqHcfzY8
 6g7zS1hdjQFHSRF5uzA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_03,2026-11-06_01,2025-10-01_01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79E081A0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zq5kgi8zw49y49pww3aojsgfhskrjzc5
X-Rspam-User: 
X-HE-Tag: 1794298487-398822
X-HE-Meta: U2FsdGVkX1/dUCQtpvcluXNCQcpNAL5Awm/R9UXNuVIotBovW4EwmykLmygzpT2WdlsVuSvBjQsZEGDQ9PN1BIGEGjW02tY9ueALKb7YC+PiEm3VVo+VvtvoLHPTRGEXS2N/J7cNO+j8hEmWTzkhYlVY4fDhiYJVXkJ6jGYUVflFWPeW92gVRGpQZXads3dLK8pDFCHv8hE4GFrWiCWYhU/WFNDilWFM/xm7PAxXnAHuiBK5NuM9oDTmAkYjGsVYi2ymcV/lEeM9LUkhtVKXOH7jF0T8bdkyifrfyCD6ogVlQPvpJm1y2sXSjgAynG273vLvtYTkynZgg1GhNYOyppnhUaNLED4GK/1bo21CkXnHqm+lCNrCoY5WGHkjOnGgGZ4kbRXDPYWf6WH0Pn7qqT+3nthvz+Bp83TbGQGCj/9hVzwaNPtcYnpOdshbnoV37RAorysH6r5NQkvznxJAKz3PY3HpnkRUBiDDtO+iICwOgbUeB1ecOLgPuOki7rzVdVdrQTx2vUnKP8yad7lhD8GNhg4UxamSh5GZUCZFxm59pLMtfjdwbdqnERl2LkUYzQA2HE1HTwBThtkbm6kaeqZMjDIDGkbrvym8z9ohbOEOIhhoNPp5YBrh0gdnOUQKHMYchtm1ucdAqVAqO1YRfOXIFPxrRe3hD99Z1YGaknKQ87nyv/CAPO1O+UwDrN7qbr1YxMF7dr/QUUvZNMsxiqjAKSLKikn2KLTlfpC0BJe8QEkXuLSBz20x/ABosRr2BjKoGtEcc0rgTJaIqmw8+/LodqS4LqxetypFRmF+C4EZNkQvJnYeMp1IqUDKx7rmSJ9NCL2hiSCUxXthyEMC9AiOya0oml9KvNEtsWAML/R54n209JO08e9fIXnvX4fse3w3Qo1Q8GYkLp/q1Mo3Ko7DL2kIQvnrm1P7Sfhh7s02Ii7LW+ZKZJ2dp+OubSTuIqEacXh5Gw+mNM6bOvl
 TINHvv7R
 IFn4u2RvBZ/hpmX/DfomsVp7ZfXAMKwG//kfQKw29nHMEK+jx3J+f7qlzy6iibDS7hhOo/p7R6L+t6YhS/YFM/nKF28JaFhsvjlMujcfQkZVikeGms7BbHktc3574dxjq8TqMS39in/umSe96XB7/GKPqh+0LohYRueEoH/fjTIa0wv5Ybz9IDDTLSohkozov3qduRG+TjZWq77rEUR/Jjg8E98qossEyldwR/HvkQmnUw2KmsPmwvcAU0QHFOc19dJNUK37sljvEuZeNphGjR4qsnfa8cF2FhZDslZi1fDNERBVp3hIy3nrqkuECYDP+U90kTuRspRnsIzpl4pIDNh6HizNAPVqLvA0fjQ4JlCM+RMzKLBg9PHTqNoYqanYaQnsaSE88b4H4IpQyrfj8gR0CRWGwHR5LhftX7see41K5cUIki3wfLwgmU/ZhJPIQf9oP7wgbiUK5XXjFbIOg+ib/O4luD0OplYzIWj7vc7EdQwGYZIAyqszRSO3iainS/qR05Iyx4Y4BpSIukfm0SMpEsdnjgnFtxT8Nh0mkxwD/yBOEmyUP1x/7eKRFHMtvb/kWbor9QUAdDHafm3H7wn3rzHiL26UPeCwpl/94Hr9knOPEBqAbbX9eQeiARRSG+SQZxk+xhf4cXZ8VNqumTDjPxbQ+vsoH0lggvEXqS1WVJzs1dQPxGNPARqkpP2FIUqLqV5BWtVrxBXSu+cHUhKAZSDFRhVlQN94LHsdRfHd4AHyYsDnciACAcKFWZ9hMZyQw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On Tue, Nov 10, 2026 at 12:24=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> >
> On Mon, 9 Nov 2026 10:00:45 +0100 Alexandre Ghiti <alexghiti@meta.com> wr=
ote:
>
> > > The patch itself looks good to me.
> > >
> > > Acked-by: Kairui Song <kasong@tencent.com>
> >
> > Thanks,
>
> Thanks all.
>
> Please avoid single-patch patch series?  Present them as a unified
> singleton.

Sorry, won't do again.

>
> Here's what I ended up with.  Please check.
>
>
> From: Alexandre Ghiti <alex@ghiti.fr>
> Subject: mm, swap: only prefer nonfull clusters on synchronous devices
> Date: Mon, 09 Nov 2026 15:18:32 -0800
>
> Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
> the allocator fill nonfull clusters before taking free ones on swap
> devices without discard.  Commit 3cedb745d354 ("mm: clarify the
> folio_free_swap() for do_swap_page()") frees the swap slot on an exclusive
> write fault.  Such faults now leave holes in formerly full clusters,
> putting those clusters back on the nonfull list.  Reclaim allocates slots
> one folio at a time, scattering a batch across the holes instead of
> producing mergeable writes.  Later swapin can also require more read
> requests.
>
> On a mysql/sysbench workload in a 256 MiB memcg swapping to an NVMe
> partition, 7.3 compared with the previous version produced 59% more device
> read requests and 27% more write requests per transaction.  Throughput was
> unchanged without iocost and fell 19% with iocost.
>
> Prefer free clusters first on nonsynchronous devices, preserving
> contiguous swap slots for merging I/O.  Keep nonfull-first on synchronous
> devices such as zram: they do not merge I/O, and filling holes saves free
> clusters for large folios.  Keep free-cluster preference on discard
> devices to spread writes.
>
> In the same workload, v2 reduced read requests per transaction by 14% and
> write requests by 48% against its base kernel.  Throughput was unchanged
> without iocost and improved 33% with iocost.  The RFC's batch-aware
> allocator also improved this workload, but this policy needs no batch
> information from reclaim.  Reverting the slot-freeing change would keep
> swap space pinned under dirty pages; a proposed 50% swap-usage cutoff for
> free-cluster preference was arbitrary and would stop helping as swap
> filled.
>
> The 7.0 to 7.2 kernels retained the swap slot after a write fault as a
> side effect of 4b34f1d82c65 ("mm, swap: free the swap cache after folio is
> mapped").  The observed regression requires both 9a42aed48421 and
> 3cedb745d354; stable backports should target trees containing both.

That's fine by me!

Thanks,

Alex

>
> Link: https://lore.kernel.org/r/20261105155032.240457-1-alex@ghiti.fr
> Link: https://lore.kernel.org/r/20261105155032.240457-2-alex@ghiti.fr
> Link: https://lore.kernel.org/r/20261022145615.2184343-1-alex@ghiti.fr
> Link: https://lore.kernel.org/r/CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+=
L3-w2xRvtg@mail.gmail.com
> Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Acked-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Cc: <stable@vger.kernel.org>
> ---
>
>  mm/swapfile.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> --- a/mm/swapfile.c~mm-swap-only-prefer-nonfull-clusters-on-synchronous-d=
evices
> +++ a/mm/swapfile.c
> @@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries
>         return true;
>  }
>
> +/*
> + * Prefer a new cluster over a nonfull one if the device needs discard, =
to
> + * spread out the writes, or if it is not synchronous, to keep the slots
> + * of a swapout batch contiguous so that its writes can be merged.
> + */
> +static bool swap_prefer_free_cluster(struct swap_info_struct *si)
> +{
> +       return (si->flags & SWP_PAGE_DISCARD) ||
> +              !(si->flags & SWP_SYNCHRONOUS_IO);
> +}
> +
>  /* Try use a new cluster for current CPU and allocate from it. */
>  static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>                                             struct swap_cluster_info *ci,
> @@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_
>         }
>
>  new_cluster:
> -       /*
> -        * If the device need discard, prefer new cluster over nonfull
> -        * to spread out the writes.
> -        */
> -       if (si->flags & SWP_PAGE_DISCARD) {
> +       if (swap_prefer_free_cluster(si)) {
>                 found =3D alloc_swap_scan_list(si, &si->free_clusters, fo=
lio, false);
>                 if (found)
>                         goto done;
> @@ -1159,7 +1166,7 @@ new_cluster:
>                         goto done;
>         }
>
> -       if (!(si->flags & SWP_PAGE_DISCARD)) {
> +       if (!swap_prefer_free_cluster(si)) {
>                 found =3D alloc_swap_scan_list(si, &si->free_clusters, fo=
lio, false);
>                 if (found)
>                         goto done;
> _
>

