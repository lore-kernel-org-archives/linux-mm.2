Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84522C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6676B009B; Sun, 23 Aug 2026 08:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE5E6B009D; Sun, 23 Aug 2026 08:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE566B009F; Sun, 23 Aug 2026 08:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 673AA6B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:16:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFE851A0306
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:16:28 +0000 (UTC)
X-FDA: 85132432056.05.835E2DA
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4794A40008
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:16:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=OXmPImyF;
	spf=pass (imf11.hostedemail.com: domain of "prvs=6695add880=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6695add880=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POJC1GzZ2bMoCTydGPHIpZg1q9JbW1LvfcuzWeRBYBc=;
	b=ZftYFnmRgWmpksw4NFlD2xB0gYf1wrPVl2U1eIXzNmWq4nw6NoZ1It3093j/kGB563MHFd
	oRLt0h8XQrQTfhN2zoZyvqKXcwFzg2GoBW/t/Ek9X2mGfZZbikKIV/dEfjkiEl/tbGddvi
	Ze2buCsVD0FffreYdEPrZg77zBUXrJo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787487386;
	b=lSH88C7a6OtYnyC2sjonDzuaGNioq/WrfXkeQI3yDqxfG/twfXZz/A8yBuPtCffh/GDpVS
	GmhN7jkULDhtv1LnLL2SoTUIFG1jWy2W6yhNNeEN/JIhmBhY4ceNqrq/6Vl13C2pZRxwyF
	fhl/qBWBkZ8Kws9F+IWfbLwNuzBiDJ0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=OXmPImyF;
	spf=pass (imf11.hostedemail.com: domain of "prvs=6695add880=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=6695add880=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67NAOcwj1366066
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 05:16:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=POJC1GzZ2bMoCTydGPHIpZg1q9JbW1LvfcuzW
	eRBYBc=; b=OXmPImyF8yZcC/zSCX0YR3Lsy44slRt6Oq2yxCt28qSR8nOtMlgge
	Hbl5TxS1P2WGyuB4HThyXYqCap7rMnXny9OGDnvfsG3b6cuShtoxqiLd8YHhfRoA
	OQ01smf4G8NITt1T+KoDDuabsAQ1XhxYSTeMwRH5QHyTVrMQBWorVMNjIPUkbiTK
	h+0UYwO4VoliDrnibfgEMkrw60Rjq/jA55evoAPYdJ6bshMNNITk8eWMjA/rjE59
	0luF0mw7qA4trW76yKlMP/7vhQxCVJYZh0EsZLaJHT7Y4X46zQdmADEHKEM0PsZk
	sA3uNEgr/VqNMAMZVlL3nel6qjzJlEjDA==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g7b2hmp12-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 05:16:24 -0700 (PDT)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a3899d74c5so3548491a12.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 05:16:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787487383; cv=none;
        d=google.com; s=arc-20260327;
        b=i+NR3A+nqkOSzRLF0g77hK3aSfTLZKJQ7Gp1IBBzP8NcnJBpToJUbY16Kw3+R/JJa/
         1RMGSdORPLN/+xvnIcxcBDLEqk6AHTeAv8COvUHK4YhxIQlGEf/uwMKcgIeoQe6QUlyT
         AdemLL/tzS9KFEfB7akYBgKXEQ5YAX4anQULUi3s/YBLKYF0+vUNq46mKCKpTJklJnEy
         gUDeg6ttaf+uFcFtBwW4MbHD76bHHEtTWK4505oZixUCoMrZ0NN7/KoglsQOxzzOB4aA
         h0sNLmoK9wZN+5pup9V6nKQDDubj3Qo+ZlmoQA4jLEB+UDwtKYbdd7e86Sj73TdPSKbl
         3y9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=z1aH2v8fzTldce+j6y/HSMAL2BN7CY3YKQrXS1d4+xY=;
        fh=357refkzQ4Sw6GMc1KKLZ2TfOYvrRtJJiYP0Oq3XaFA=;
        b=T/fB9T9AoGd+Yga805vyi3XY4OuIpD90CbknPSD5KfhdBKvpB26Om5ZoSSQJHHhZY3
         X5l7WFOQ2jvWFksoKur8kaQuGw4mQuW19ydVeYGeHQqDJLPtI8gFSE9+4sXILNBeXhUw
         imib3lpasomWhsyJxcpNz8Au7i3cF12qY6R+oIDSs0P9Zywqa2+PQa0mlv5EVN7dd6cg
         KWTkEALSDp+VXgD9x4AdM9kdxMRtiI1+ih6ovXnRkAy2/LH1PJR8YEga4nFFP7YiJYW/
         gJuvkBoIYnabk2U0wSBgEwQ369r0mPKOb+ObmUHBPD97pCWOurUbzKHjVkFXZygQP/r1
         P36Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787487383; x=1788092183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z1aH2v8fzTldce+j6y/HSMAL2BN7CY3YKQrXS1d4+xY=;
        b=onSu7JStet45RSnjpnk3qtEv30KOrQ+MmB2RphgqMa8a+wGEPXw32qEO4dsntebbDJ
         8x5zOL2tgIfMfE/zGVclCGkeCc2wSIbbkvKekYK4QkHKEdhfkks2wy3dNic1fBWEKw10
         MkuTYYbBDYMlK5kqgLXqCG5HGTC26FMVOzpfxLWC3yoz6x5G3CwnZiocgEzP2mTLlJDc
         Eq5ddAPpbEuylNd5sOyLczuqzVF2LeaKTJlRwTjjC4GRQfQwbnnr4zFKpAq1C8xBU8bI
         6r2mwF5cLCWn2UWIMnl1qxe+Q/eRA8v/ptfXNckzUiBbwmO7ZRhrSkMZ4tiR6sOr5y7Y
         1IRA==
X-Forwarded-Encrypted: i=1; AHgh+Roj7hiIxLjNDMy3oe+opTFadm3qTC6fh/nEytMMHeZ/NhNc3GP5pWkZ3uy3dPc8Obj1Wf2u/vDQaA==@kvack.org
X-Gm-Message-State: AFuF++lmmls1AwdnIAWcMlLVzlGiunNAfmp/uSuE6Zdy+KIHq538IOee
	50GuQPc5GnDHa4t7h3HfwK+OniyXgcXTFOBEn2a8lliY6q+BVd9i98QzaldgjMzTafvM2GZzH6I
	q5yKXDe9YSg3oUy9Kp9rxQYWYbs2tL3DaC+l3kG3xG64BeuQlW1b7CLUNG+ntfERSxJEH//P0D7
	H6SX5CzBPvd4FIC5oNDlWlQQZIGA==
X-Gm-Gg: AR+sD10+Uhv1HlMSypgOSm+5dTTSKvz5gmiiPARQeTzxUsYEfiwUfMFBFX07MKKwaEM
	xRJ6SPJfd0fGPLpDLaFRV0siYUufUQwpNfSba9pNX5FdyXESCrDIopRAFmqGfy7MJPxQTap9BAW
	T6zZl3z3/10D9Ci5ZGQBRXzas4TFL5fxKBYiyFwAVC/eOzWcY6n+KnAL/pWQ==
X-Received: by 2002:a05:6402:2b91:b0:6a1:fd13:48a2 with SMTP id 4fb4d7f45d1cf-6a42f238138mr23120180a12.15.1787487382904;
        Sun, 23 Aug 2026 05:16:22 -0700 (PDT)
X-Received: by 2002:a05:6402:2b91:b0:6a1:fd13:48a2 with SMTP id
 4fb4d7f45d1cf-6a42f238138mr23120122a12.15.1787487382505; Sun, 23 Aug 2026
 05:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260821093606.2231216-1-alex@ghiti.fr> <20260821093606.2231216-2-alex@ghiti.fr>
 <CAGsJ_4zHcW8oJBRmCDB2WYFc_uv9KP+M0fxOgnnfmA3+x06t4A@mail.gmail.com>
In-Reply-To: <CAGsJ_4zHcW8oJBRmCDB2WYFc_uv9KP+M0fxOgnnfmA3+x06t4A@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Sun, 23 Aug 2026 14:16:11 +0200
X-Gm-Features: AcwNN1U3XHFCCXh2e9IyvcncJYHiK04yHqGUaAsZNCzHY-dGw2m5XrMTZ7d1lcI
Message-ID: <CAEmasaXU9n2Kxjf-+gvjevGJ6LS0EU8fWWHtb09SDEi3phUJmw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: move LRU insertion out of the swap cache allocator
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIzMDExMSBTYWx0ZWRfXwIl+gHrPgm0b
 n+h1IXH3ztPTF3OnA2I44gPa2oASY/WG0DG7rLA3RVLumhk2JtO1d4xCYBtPCzDZuv/skViN5kA
 IXaMN56EiqMAhRlEtR976N34G/iW1AKoREDeGfxRMORyLf9NrgSkW0p3ENTP0S/bi1TJNuvKgLT
 Wu5dKvr6Rt/BhX+cMWa7xquUnnu8tUPMJm0s3HKp1Y8OpUVrJ8xOTxzmcxM/HFggln0CHd4MB/U
 vFOL4GLl/DpZAhlHRs6oHiQGg7uG4XJSd2EonyyAMXHM4rL7AvbNwu7vQ8kx30xceaAqs92ZQ5z
 3LAOl1cED0mb4zYQ9F7xsxq3rHMaenx7RUgdQOv7SvMypm1kMQhLhUSx8qEVK4YREhgMxbROW1K
 Tcwx34RaqpqcD27zjKkxYXHtiPWXxtgxfxKp41D3DgsuxYFkscLnUGMsRZb0MHM3i+GRI7Ubon5
 p5NHqgqpr/OrocX1Ayw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIzMDExMSBTYWx0ZWRfX2Rt5hbF0vJOr
 uW60m/c+Mf2D2bti/Onqz8fE0QLp/Xd7gUA74Osfc6YbjNAaPS3rk1dxfL73lreieZZkCH+UYtf
 Ki0SkMpfniJhR6NG2Gdo/845MSd6NJQ=
X-Authority-Analysis: v=2.4 cv=RLCD2Yi+ c=1 sm=1 tr=0 ts=6a8ae498 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=crHB47gyY4rKiduisYu9:22
 a=VwQbUJbxAAAA:8 a=c92rfblmAAAA:8 a=GvQkQWPkAAAA:8 a=EWyKgnE13kDZlodUj_sA:9
 a=QEXdDO2ut3YA:10 a=j5kO0B45gQVIxiUYEfTy:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: y-zg9hwbqQ6JJTNR1XhZsax8OArqSpri
X-Proofpoint-GUID: y-zg9hwbqQ6JJTNR1XhZsax8OArqSpri
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-23_04,2026-08-21_02,2025-10-01_01
X-Rspam-User: 
X-Stat-Signature: knpstwpob7rjokbopeyzcqmr5xbk49td
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4794A40008
X-HE-Tag: 1787487386-789265
X-HE-Meta: U2FsdGVkX1+wvlOYB0kSx0UqfETwcrszq8TIqM2UBnyaZZ7PdbLGJMyeyOcQymSPsZyPdQ/+oRbBNyHyikQQROVl96IxEyG/smpukB2BgrinhCV+0l+rFvXCggSOPRvRl62n3AFkkSb13ma2UOBrkHkVXf5avNWEHdlL/yQonIKeJ2aq4yqSeOo0AmRKIVsd+9x2cgbnWVCgvfiRFhwZkWqJ5ziLqMRs5CpiPnvnM7wyaiq6N3IFdNGcX2xE8kCFwZjqpLr+vHtNKkLs9t5cVo8LcbzGrWBBbNFxySRL6vajlt464Odged9ZUQBSaO5Dgcd0EYALJfNJK6Y1bTau4Zj2qd0IlFNaOtT3mvahVbFK5vRa1BcWt87ofnePV12u3JstXY9rCvJvmn0SFkutFhwJmykwUhLx4dqxdgY2hHGhdH7EFzHRTPj3rzB3shFLI+/kU+6Lwu7PlF+HkMtQXGldGehTAliqxiBeBjM794HcRt0vZSGs6dYte5lg272RmISjFBmzvrhxE7YUKPP6qO2tdMuTjbSbuuuGI8PGBZNuZaSxkQ49FXmdKudwWUkvcVBujEdaD2U/d3GZMpEw4pltSFIlKu1zs9OzrzdHMujEMMS/NZRTOT6sS4VOXTmRhh1Qr8+y75GPITZwHiSPgJAAi59rPTMbVu0d3VAehdkKI15ozK6w8NC/ZhVcsX3+n3JItKRGfyJrYyqQCfj5cvdlte5F63Ff336ylEulcsBcEHZQnAQvGZiWh1Qh2VDHIGw/8x4F/yPtF4sMLI2JHCbSLzz2y/lto9iiOhiOdNqqHCAm17Sh0gxpnu8nrrVJ+7a+UJLnjlhGyfPOcikkr+VqOPa3TXHcyAEg5hC1xHFqdZwHk2Y3MGVNxbg0II7fvf381xmASScnZmnpaJvU72JiK0e8zYy0ko7VgnPSwXjmiKjofVrumjhB4d9EjenssNhRwJj25LTOkwg+jN2
 YHFYGHqr
 jwhvpovQXQU0JZjEv6G09whMAibNW1tAo9akdA6r57JRnIm54tMuxRehFz8HBS1yvH1E3jLhgBiq1ciFflIuDo25OrB4KjD+GaowUY300L7sJ4gV820d0t1dBvNLc9rD28vIfz/2hB3uuhGp/x/Z+hSYgVKAOZFXAVnrxshVe/jHf2+/2x9D8salxHEf+LaZwodQzTAjR11HQDs4gF82JtQDJyH7IhExcPC0QcRpsk6ln1Aw31SsIVeOhrdnrp39u5A+YxIuI/cGCdB1CASO/EkIJiOoEK58jW5iZrroPXxFpt4GaBCgOerEXkUw8OA1Ex/gqqJ4tk+mm9k+mw/gcasmET/Ia8HjBDie6qpfr8cPJljvNGhCZL/oh1dQOK7z2G3I9Oz7l2mw3Ncj7myCeG/264qYPnin0LKJsYZxw9sjdTfBTLmvNoA7MwqQTNvun6XzMYRTFLyXgER3r+VIQCZy7BeXAhRkWZIOjo9hGZ8Y7HvdcUUBz51Fzzu7nuLlUnDGolYATUELLeU1tzCTd71nvhFAKTJTed7QKrVxlXyBXpPQZCKUBv7c6QR3GFKdzA1nN//tpofn36j6M7tWELduQKdV7U3t3H/RJNmVu4M5+aiLflnyj1TqJ51Y45L66Edxn9JNr9+jbVOsNSh5zaZ0gQ+3T14cCXxcRDmqF8nqFn5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Sun, Aug 23, 2026 at 10:39=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> >
> On Fri, Aug 21, 2026 at 5:37=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > The swap cache allocator adds the new folio to the LRU itself, which
> > forces every caller to live with that ordering.  The next patch needs to
> > evaluate the refault of a swapped-in folio *before* it becomes visible =
to
> > reclaim, because folio_add_lru() consumes PG_workingset/PG_active when =
it
> > picks the LRU list (and, under MGLRU, the generation).
> >
> > So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
> > no functional change intended.
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> Hi Alexandre,
>
> I=E2=80=99m getting a bit confused, as I noticed that you also have this
> patch in another patchset:
>
> https://lore.kernel.org/linux-mm/20260818163221.589352-2-alex@ghiti.fr/
>
> Why are you including the same patch in two different patchsets?

Sorry for the confusion, I explained it in the cover letter but should
have explicitly answered Sashiko's review on v1.

Sashiko pointed out that moving workingset_refault() out of
__swap_cache_alloc_folio() breaks MGLRU folio placement:

"swap_cache_alloc_folio() calls folio_add_lru() which places the folio
in the per-CPU lru addition batch. If this batch drains before
workingset_refault() executes, lru_gen_add_folio() calculates the
generation without PG_workingset being set, placing the folio in an older,
suboptimal generation."

https://sashiko.dev/#/patchset/20260817144622.137133-1-alex%40ghiti.fr

But good news is that v5 of dropbehing will drop this patch :)

Thanks, Barry, for all your comments.

Alex

>
> Thanks
> Barry
>

