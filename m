Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10025606D821
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=UP8T8JT4;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=vIcaJIWD
Received: by kanga.kvack.org (Postfix)
	id 32CF26B05C0; Mon,  2 Nov 2026 17:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303D66B05C1; Mon,  2 Nov 2026 17:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1851B6B05C2; Mon,  2 Nov 2026 17:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA7326B05C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D23E414022D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:30 +0000 (UTC)
X-FDA: 85391684700.07.FF40F8F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6500E140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UP8T8JT4;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vIcaJIWD;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QB+Kodww0YjbqkDlDn8auNZEe9KRZmhyQt/bq3VTDUw=;
	b=3oqqi6sfrTc993hQRe4vosul3lZ7CeILxbwiva/zWxZCI4nqnP39rSFNFIdsz/f9E3l/tP
	omjta5C6hFuJDwmadxzxFrcRcEy+GG6lftzRD+A1N6tc6vGUWubDhysB0tt4TxGe/bg4c/
	/CgO97Y8KyaqJRRUuoHSRArDqp7pPYU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UP8T8JT4;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vIcaJIWD;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660068;
	b=ax964GAOyiH/r/e9OlxmpM5nFEB0fsE/aK3yicyG/XaJKe/sUbLMBD2/g8kdUB3HsShiZp
	Q1qUXHiBHe4HGi+zPr7WQc/97YT1rlG7ywajXyPpkAH8aC2NJM45qOIHjTKeTSHRD7WngQ
	1mCNDOW5Dn7sYZb4e4P5CckOaKf6n4I=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LY9h63681482
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QB+K
	odww0YjbqkDlDn8auNZEe9KRZmhyQt/bq3VTDUw=; b=UP8T8JT4XhH3B3sSFq+4
	S4d33LXKxSWafg7fr9TJab9HY4RmGgw05xsWTPtVL0/Oj/7IPg1vPUzPNT1AxWTG
	gowuNIsMzJ++Bc/463BsrIQAU9Yiy8fjJyAxclZot6aKWaBilVnZcFqFKUsCsUrk
	Cg3Bdr109dijpn1mAOjZ64MgjnPJ+YteMoyAdlXDa9bSUG3dbRQ0pS8W4RfxDsyL
	7/SpTEkKJnrhtY18YtsN9hTYdsrJSqjXnGUBSJY5Un5Zx8oLcB1Au/HEd3XqsTCa
	Nq3QH05Qh1dWsWPyWVDLih82j9abAz/iXHzQKJw0snjkaZO0qchigu5Nu7GGZ9+B
	Yg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hq2bnrqef-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:27 -0500 (EST)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91c6c1e082bso2733616d6.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660067; x=1794264867; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QB+Kodww0YjbqkDlDn8auNZEe9KRZmhyQt/bq3VTDUw=;
        b=vIcaJIWDUeHSPWjy9wEg7GVWGknADVuzUiabHLgcvcid5a05pC6BIPQ5QZYPOyv9Yh
         zyYObJdabzL6a3ZWRAZfU8/mq3DeBR5Ac/7x03l3Nlla30vNEpSvLRgXQpL4Sf04zcMD
         xCSJFHC/iS+rn8d3PzzfqHTxRUCea6siyo0mbHSSf0gUlaRWz5lftixfnUm374SI6hAi
         echv2uX394woGBUhx9Ni51xPhbjU1EuBsAVEs+tD/WgMzWzX9Uf3Mha9HE7I5eI8qAUY
         uGV7rE8WFCz2aYNjamcFxS6z5hOGlYTNmZM73I4VeR+6adj1kgnpMxg5o4I0OPwa/5iS
         N+cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660067; x=1794264867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QB+Kodww0YjbqkDlDn8auNZEe9KRZmhyQt/bq3VTDUw=;
        b=cMsNI/s+IWm1xrrwrYgBHp84osFe+d8q8g2lj17Z6lad23/bX5WPOr4Kbc5pMYdNRJ
         uycjRQjBCoD9q31Sw5DmsYbvHpH2f0OOkJOWfVsoWlQeYghoyq1M/mxqg0zdO3SyyvX7
         7HT3AkF2FDtTskD0mH+iaMPBpXzzk2n2dSnlx0Re5sbzC9vV8e1yCdkv2JLqnBDFeJg2
         tA9idQGiEvFGIeGpto2A18m0sfPAgoxK7WA+Upz38lElQW/MSpLMdeLd7dSYjlrg8Rtf
         x88zExYbHHVnu3xaDh/wNLhAg3sR2fP7irfVG50jb/gdWwWDHpo4wRl1W6yk9tjALImm
         XlBg==
X-Forwarded-Encrypted: i=1; AKwUvByXpIxVCLNpq6CTc0I5/M/KMFFTkx5awj1uYmA+1EsHh+idMD6hv2+UOJjMQpr7i8wirWO9uYkHDA==@kvack.org
X-Gm-Message-State: AFq9FYKtpYjhYsQbNoQD3qckcJMcJ66F8xvhw3P6LjWsIyMcZxO/q8Iy
	ANXHjq/liEPXn3mwxfpfmWQQaHH1R9raYgwNAMrmI1q5Xv2VqHFH+h4GBMxRKJByb2TnEw0q5qD
	BcUboxKI/Z7LbHARjf1AOHyMpKrzV+umTJh0Sh5mpLnAetFVR
X-Gm-Gg: AYBFou1v6/SxsO/gmFFGdYbuNFn4RQoS8GaNiO/6LjzgQKnBmJ9ke9ApSRh49iprzii
	EKoS4rJP08CwjS8WPOP2Sdhr/FXgUHwS822yuyqGf0WYealRHYhFeSd61MIhdV67gKezJ+ka2B0
	Ah+V9Prn8I/GpgcNq6YD57cUGEsIvzYh+lJV1PGlIOhYoC09QOFIIaeV8LauAT1eXMtTpFEYjFP
	Tgq88OacGWQWxvUDKKe99w39pNd1jBxV5zgD9e+5xkCY90/4DXewxk0iBx5fp1bPlPdDYXvhhR0
	z6DZULcQ4nEsSWYUGoax6lxah42Ljr6OXknAcDgZ1SdqV3EeX6lHX+YHCkfVaW/tgRdFY1jJM8d
	ezuzJd/sRdifEywOtKRlyqDdHlGBEe8u7sTGyfp89hzc7jk06DJdckOxqE34=
X-Received: by 2002:a05:620a:2696:b0:93c:65e3:df81 with SMTP id af79cd13be357-9441335ea19mr2262640985a.13.1793660066872;
        Mon, 02 Nov 2026 14:54:26 -0800 (PST)
X-Received: by 2002:a05:620a:2696:b0:93c:65e3:df81 with SMTP id af79cd13be357-9441335ea19mr2262636285a.13.1793660066393;
        Mon, 02 Nov 2026 14:54:26 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:24 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:07 -0500
Subject: [PATCH 2/8] mm: remove end_page_writeback()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=2548;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=WI+DTq2D7/P9pyV6U4b9t4H3I0UxHbIun2IjS1qcWJ4=;
 b=+gkUHqILM6e53SAF7LH4ave7gB3KDeZbj+/L3ZVPpR7W3XY5YPpd8ejGvm6Y8Kug5izztbeU2
 Kx2Td9t8LjDBADg74xb1FJwpNiM6tOe5WEBZ8mTh85PLkgrh/HiAcjn
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=BLcmP1QG c=1 sm=1 tr=0 ts=6ae914a3 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=K3LvcDGZF8AM--xSYNkA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXwO2e4+4ihgtn
 uq5LbFdXf5ihGFXNw7d7Y13ifHtyj5JCBIjG50j9bDo3azzcPUzrBnXRu8HJmQplfiNGIxOIXj2
 hhI0faqILTZEAZRdYW29warMPw6UCCwCVg0WRSAQDkqZza0zuAfE
X-Proofpoint-ORIG-GUID: Oat0H2N25i27vn0qZb3zBy8Bk83txsPe
X-Proofpoint-GUID: Oat0H2N25i27vn0qZb3zBy8Bk83txsPe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX6HUA9XLFYIL4
 Dtvo8tipiHd1cOZGNhNzkbEMent2N7H7iljp9EW6UzT9DZDogdW7fMx67wnGjTUt+EvMqP57j08
 bfXzCbVzsT8OAtPL/XsIxND2A7XcMmLJXW6pKcPqwPSM2oNyurvZ8IO+up5UDoduQtW0Fyu2SRp
 2bJ2by5Hs97xN3W+z330EGV+554i8KrInl7kwM6XooQVidzHPeDNVSEiSrxqN3y1VuerLTYQ4v+
 0E2ZJbawj0ySIHcprvzzRwI5ZkVa9wA4k1xusqkh+PwvkoY6HIUP1ARZt4QQ3p9aSUGJVDWyHQR
 PtLKPgb/opydtrBZj1V5f7cc3f6bfXEddpJcO4XQt6+gnblsNuWVdxlN7tK3xlci5jFnewW13fV
 c9CnH/f3B/Fs0i0IjfF89qc781g8BGjSIR83n48iNs9n+GTLxpzaZnPGzh0+bkzKNBoIT7KlEmm
 7vgknExHhrdw8xK+9VQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 lowpriorityscore=10 bulkscore=10
 suspectscore=0 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6500E140003
X-Stat-Signature: 9isqkz785uki5mom8obo7m3mzzrd8sfx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660068-368315
X-HE-Meta: U2FsdGVkX1+vIcD/B2iqKO4OyeVnJMY0svsPBvwSFs7oHQSS+UyqrZo7B80tUZGmMChyt99R2osv1vyEgnaRmvZWPQO+w+2AGEcYFQELEefDbYsEeZWfNDi2kIse6g8MtwLf6PmZafdMM2WuDg/9PDcNIpVcUJSBwDCxDNpijAljU4lwHJF++i3sCLizzM054kEVNxV0qCRhSujbBVqZPqJ0HtevL1XOxNj+30leTuPNGqjEd1IgMNCszYu/kR+QdN9yWPk8euv87zIuH1NQYlnRc+ZMGOYUPB/aAbCPhclVn21f+BzGzJ6iogeQg7RaFFYUWLO9GwWmEDqZBrDAvIRa0Xx5Kvh5a4COn0uiAg9uAKxC426WA9qRWxvSSPfD86hwOQuzdTDwUIsZI21kTtqy6oe4rf2vAiEf2JcVMlgouSJkyAKMpdMnZ7aQw2j5l4zvTj8FluezTkWTREu6QRNd4qRg+XwRvNMmDxT3AtMistzJr3eonArJ6XDa1GcJ13+Jvg12xflRQnEGpe74qYc2ZJPjtSS6+iCW1GYT5JcinwmcuKIg44ZMSQvpCDqGThOFs5SPcTLnw7PIF/LEfMVM3Uzw0+E/RL7OJQBloMEzEJ31jqM+LzPTSSE9viEv0vRGvfyInptc4IIv+te+Cd88RRKQEFgPQhvAkbhmzosBCO+Sl79ZVAvMhPUxwANk42DgkB79fgmMj6MZyucNDOjTPfzinFvDAA7AXU1fbbSEtVo93E3tO4WU4KcDGdxWZVIhdA9dKAj6rBeeh3qj0/2Xubnenf7WBBew7g7JDWA3V30L+/Ixy/RXRgN4uJ6V33KLiNYt0BoaYdWzfMi0aMg0e2HHbEoy2NDcpZPabFMHtHmhtkBzFezv9njvwpFOPP3+9O5xkv1S2KsFfaJl4zeJHTBbxRQUySDnREvwrnNjW1ZzAsT6gtMLY0MSNco/6X2RO/moiW9hu9yZ1NV
 DGvJkEDa
 NNOoWGf/+qiRlSyExPD4MOofUzQPEg1gFGQVJPDt4MytTdOgObCQYz79q9YYAxlCsDh4anh2TpmDzEdsOR4TRozzG8ZETtG1Hd0Zr6iHaHoUL/1Qzd8LBUxBlVIj5ccwrd1oUzByrYvf4V1ZkBMVpnYcrSp4CzJzbKcCBgnAxHtq68t8tFMFnuWmgtqEMJbxcIsjw1OYFINc/3KKtm3DQApW4TnmEbMFRpDRmPKrZrs41hO8tjJewaUfkidrRweCJonvhEg4n6v8GuhFgnbM1rW2TjyxslDmh5hzX7+wTPOZiV4rpnbOcKwAEg4wf1kCcdqrOLuxsr8fyZ7NvmxXwgHf2/QbSOZtlUDgVcCXat3Sc3ySI0FwttXLmT/GS59HrTwQ9htyCqFoA6848SB3bP8qu3SinvmN29jNoJvuS4zGrGR+9CEvgZuQbyQAGbgaiRqQWUOgK2lhDYCnvAX30L6Hn1D5qcuK90XqsRi8ZVNMPG234IfBIwlY/KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left. Update the two comments that still named
it to refer to folio_end_writeback().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h   | 1 -
 include/linux/writeback.h | 2 +-
 mm/folio-compat.c         | 6 ------
 mm/migrate.c              | 2 +-
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c0f7c06dc6fd..692ce3867a1d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1301,7 +1301,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
 void folio_end_read(struct folio *folio, bool success);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
-void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..c50f404141b0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -124,7 +124,7 @@ struct wb_domain {
 	 * writeout speed.
 	 *
 	 * We do this by keeping a floating proportion between BDIs, based
-	 * on page writeback completions [end_page_writeback()]. Those
+	 * on page writeback completions [folio_end_writeback()]. Those
 	 * devices that write out pages fastest will get the larger share,
 	 * while the slower will get a smaller share.
 	 *
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index f880110ac980..9f2cd0ebfbbd 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -17,12 +17,6 @@ void unlock_page(struct page *page)
 }
 EXPORT_SYMBOL(unlock_page);
 
-void end_page_writeback(struct page *page)
-{
-	return folio_end_writeback(page_folio(page));
-}
-EXPORT_SYMBOL(end_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));
diff --git a/mm/migrate.c b/mm/migrate.c
index 94e8cd46c6db..953af633ec0d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -859,7 +859,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 
 	/*
 	 * PG_readahead shares the same bit with PG_reclaim.  The above
-	 * end_page_writeback() may clear PG_readahead mistakenly, so set the
+	 * folio_end_writeback() may clear PG_readahead mistakenly, so set the
 	 * bit after that.
 	 */
 	if (folio_test_readahead(folio))

-- 
2.39.5


