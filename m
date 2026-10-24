Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8588B606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSsZEjmF
Received: by kanga.kvack.org (Postfix)
	id 9078C6B05B4; Sat, 24 Oct 2026 18:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDE96B05B5; Sat, 24 Oct 2026 18:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B286B05B6; Sat, 24 Oct 2026 18:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 588166B05B4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:27:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6F57A04F6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:50 +0000 (UTC)
X-FDA: 85358958300.17.245AC38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 092C1180007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSsZEjmF;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792880869;
	b=rKar5u5y4TOldzydFjS4UJuUlEcx+Y9WSjlXisEFdnmYFJ1bfeLcs6TWi5gzhE58ucM3Iy
	U2LfAECX6cNULsIXhNplRryOB6+s889pzCoGTPs+cFxJRXIEj7xdpYpAV2N9GuaoWhS4TB
	AUbeaa3mwkDKLHPnz6eUklu63pNUz3M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSsZEjmF;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792880869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZIKDKKS2FdRJ5bhHVdKxJNVCBF7h98gzdI0qBLThok=;
	b=DDEc1Wv9WR3T8NsraiujwMVSh2+JVHf9CytJyHXP4qjlnRhY5WcP8f0A2g3Ox6sb9ifBGG
	VFYZHP0pini8JPZuKc3J1Tdqd+6pQ4pYI7b5r5v4TMVV8a1txS4paKFsqrEH0R+WinrOkc
	8VHFwB+7yUSfPhHEu3VduaA21bO2LjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6FC6025F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACE01F031EE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792880867;
	bh=vZIKDKKS2FdRJ5bhHVdKxJNVCBF7h98gzdI0qBLThok=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fSsZEjmFpPx7gWLUDKT75qvXylgPoUNbQkOLf+Oyt8mLrKmFtp/pm60U21UnyGh75
	 WzjMSWgFxIV+yWtziTLWDffjK7YhV1XUbIFFjO8XC1WL2sPRkwOCFcKSx8XAyHcgga
	 G3sYpF0HbFKOAHNF3nud48Ggy90jwVzbO7GrmvOrfY437cSqqSuDPith1EwwSbFFKp
	 oqLpiX1q/nbOBAaLJ8EOFpB8klsCYVZgl9CXGLTV7QKO2QaOHHfMGJk4oWdhz6yeYE
	 vgRC3E/qPSlyX21qeNFVV4o8z4dPn1EPpzpl5BB4pAjI0zHZbYUBKG5pd0c9l1UYZs
	 sSx2LzUZO4r9A==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5365d26ccbdso22242561cf.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:27:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzKEKO0BwG+1Tq4nLs4Luj3T/yEZhcICoEVOoX/FUFS9wXu9GYBjrJQRzdoUrQrarGUaiVSyaQmZg==@kvack.org
X-Gm-Message-State: AFq9FYKdftt9XIWZL3SmugiYDFU0AA8NDPNMtuYXlUVHWDEECNv+eGBs
	MSI97uQOaQVFkw/3yb/uYIoGwRS5pVDAXRKBN/p9K1ON1t6HmipCSXvUNyhqLpHpZgXT+e7n2C1
	sVDjMLVjldBpP1oXYDuQtHEyxXzenR9o=
X-Received: by 2002:a05:620a:6ccd:b0:93f:43a4:a47e with SMTP id
 af79cd13be357-940ef8db9ffmr456761185a.43.1792880867226; Sat, 24 Oct 2026
 15:27:47 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019034426.2354049-1-ridong.chen@linux.dev> <20261019035252.2357900-3-ridong.chen@linux.dev>
In-Reply-To: <20261019035252.2357900-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 25 Oct 2026 06:27:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuFsooOk+PEaSxCGJXm__uS0d_sGbGKsniB+vkdMqAGw@mail.gmail.com>
X-Gm-Features: AclHuK-TQu5lTS1fOR976skmXR1N0B8TphWnkqZazAAO_9122YtVC3DM7Ag6eek
Message-ID: <CAGsJ_4zuFsooOk+PEaSxCGJXm__uS0d_sGbGKsniB+vkdMqAGw@mail.gmail.com>
Subject: Re: [PATCH v4 3/9] mm/vmscan: move struct scan_control to a dedicated header
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 092C1180007
X-Stat-Signature: 6jef4dcqm5q3fnsy1n8e3tza45fjm7ia
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792880868-462128
X-HE-Meta: U2FsdGVkX1+9JzG+5utrlQIsHMvAH5ouU/S690dwiBKYvOTHOF1DNDXVtHEZKVsSWFvSrP4VTQC3xotQHozZqXBfrfqjYEM+2VACZf+Ezd+lAkwuDly28gdp5Y1L5upUkbr4WhgFlY9s53BCo4cl1T3OSBF78qM1NaJPV45GTmg3FpPgyZbqCOG0cpMQxRmSU5DN/4zdm86SrRz4brnOycl4iNpMLWMQ3s+kAEQJFV5RVkJha0zsdlYr6h7dRQxwxl1WFraLekqkCUGi0gJMgydtwoSynmF2kAsPmPMA3rriF1mY1a815b2/CxW+ip5rYw/gfimTHjzQWUqXfgzYZaxH66IwGY/lTnkUCDLhqQwP1NVZeddxmxWI5Mxmi+1jYrf1YujrqCjVmLnn2HIZHVZIPKUUAZKPKn4+etLiykzgoQ/97mTaFPbDdDYLmTKXcDGM34ffO8v5y93MEu1jxiPGA7za0U0lvm+JsE5QEkyXZLV3GOfV/JkcDWLpEnT/TJ7yd+zcnx2J9ZRay15CYeAti6GgOfO3Dr7CI6aJi0b+bf77KIk2jPIz/aLAegjIY9QhkkQnMfgwbzDyuS9k6ds7GumjG9ImxV1Rd9e4WDOrLxMip5EDpnf1npO+gSTAY3DR2fbWY82hc9w24GulyWlqPOtymsBZBZNEfLpRyB8RZpe+1Q0X0XQVwlYOSg9kNHpDDTdphTOoSPo+sTNEImY7lHH61ozpnD3pPaWs8sS0ktXmkKwaYLuYeIHse0WKsVcvdjLJpIPZB1+0NL6JJ/vuSlXK3A47hIEArtdJJqz9MgkHx73pvFFwAJkFiwlunrvoozynyJj2WopExQmXEcOpc97/jhTExERIXJU9IUS6LKH39SiZj2/QYVR8s+a50pTRlajdProP98HTzV6/mCuKWjGjSnq1VkkM26RLdwrFRBqi12eaYtL0XqbIr11cEPNrQY2PSGfeZR5V9Rw
 sozpwBbg
 /xsAGn/G2ee9BM/svkSgeXuTbFusc1DTGsOKar8VdcNMzMf2mxqRB56zZ9+wNnKd+1Gokf3j9nlHod8Y4X8gLLDQR4lYtAK2vwqBpQ0WLABvFnciy6PwuNVAC2U1RNZKHsDjmOPyW2Qtash+ZljRveA2dYtgNRn2VhrpUFBUIiyBBBwAcjTeJ6XJC/ADfjJqNslJfyog+bPkx37bby+3wabC6VJXWTypOo+XIpBOiNF6SxMQOTbDwvTpVkz6BzCaaEOXONFLjsyNRnoHl8+6OSEjw6To6up6C8tZQ5ZtSb/ADqyRxbAiYYStthMKptG/A+txC9fz1btQ3NE9J4lBPzWJ/tieVPhCcwd6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:53=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The definition of struct scan_control has lived inline at the top of
> mm/vmscan.c. Move it out to a new mm/vmscan.h so the reclaim-internal
> state can be referenced from other reclaim translation units without
> duplicating the definition.
>
> The header uses an ordinary include guard and pulls in only what the
> struct needs (nodemask_t, gfp_t and struct reclaim_state).
>
> mm/trace_vmscan.h includes the new header directly so that any
> translation unit pulling in the trace events (mm/vmscan.c, mm/shrinker.c)
> sees the full definition of struct scan_control regardless of include
> order.
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Well, vmscan.c is way too long, so moving some common
code out of it seems like a good idea, beyond just serving
the needs of tracepoints. We may move more code out of it
in the future.

Best Regards
Barry

