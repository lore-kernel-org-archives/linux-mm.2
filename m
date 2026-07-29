Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EDDC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF68A6B00C6; Wed, 29 Jul 2026 10:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33DD6B00D7; Wed, 29 Jul 2026 10:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DCD6B00D1; Wed, 29 Jul 2026 10:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E54C6B00C8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:29:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAD89A1A8D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:33:45 +0000 (UTC)
X-FDA: 85041150810.27.E964F25
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4AFD18000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:33:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=bwMntoPE;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of "prvs=667098ed21=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=667098ed21=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHOHSL7wIqwENHkVCRXYLATmzjW2mTiWLA1DQi0LJeQ=;
	b=tba9xoVwUcNuShG6RDBj9MbItoH6LJ+x++5rXFQKEUd1nB9ftNCRVp8c+T9i6cXwiL51hp
	jPkGfuSgp1x1S4pZlr6H3I3dMbmtu9M+5kzmwbm7be2l/mAKjZqaEf+KDlG2XuAPZnvgCD
	LI9cokvm6nUIWS858nN6qY/+T6USXt0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=bwMntoPE;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of "prvs=667098ed21=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=667098ed21=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785314023;
	b=LlitbcbkC6roy784zZ1U1Mcc463sFzQkZUakMdZOfmAp7Lv86T72JEOWla37weYrIF55r/
	scUrke0u1595SQLFJVAwXJK4ivft15mAVHXEQnlK2tAncH9l7ojdYmNTqGKVRuhMJjBtkZ
	RaJLE0M2v1iUa0b1eoEbDc/9JJEHR7c=
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T7aQ082906135
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:33:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=xHOHSL7wIqwENHkVCRXYLATmzjW2mTiWLA1DQi0LJeQ=; b=bwMntoPEGCfZ
	vLb4jl8esaFbW07FRkY+W4ZRxYySZM2TSnAelvAW4Obp7qdVv7Wj5Lm1CAlD3UBj
	VsHaobQLAmMjES+2B68Wgn4PUFXLLeHwgRIw0Bwk/UC7j/NjyLpDmCcX8uMqkvRd
	f5vzokZz45XYYCOWGrlM1SkhPTQDfeD6WYuMUmV4L7vmvzgztz2hwFgwqIQPwbl4
	bznkX74FdH0ApZlqNnoER1lLp3W/bBvXRdGWoMWJHhh69iEHsU3KL1C5k5+FJ5tj
	LxEP7WlZERreotV3oH3hp2XLhJPmpNJu+F00T93pysUrkBDxOeX7wbEXpbMys6h0
	q7EEcGJvJA==
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fq3auku3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:33:41 -0700 (PDT)
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-69e3aaf5ea3so769902a12.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785314020; cv=none;
        d=google.com; s=arc-20260327;
        b=rtw+16pVZ4T5Id9CsjLp01PWwCTs+wXcekLxUw+PgEGXlGmmwrPo7oM62cDD9+aq3l
         YIzlli4d32rNg+e57ZVYl80qyRYLWiscDrRMofo450gij6reSltiAtikiP+4pzmI3+7a
         fyCrq9k7g923+f1JsYx6c688hiwNOCIkJ/gU5Bl8sgM5P2Ywr6eoe5fZu7aRcrnrCPw/
         56iiqo0Ec0Jc65rZolkBZABm26xmGg2Ykan8r0dqJPEypWGQX2JLAFWNIGAp0db5JMgr
         Blwx0CwQODbyOpWO95ahN9xtHaJFYx1QYTEf9I2ujGUumEGXjQgAw2DBZoRXm2Va0l3W
         Vf9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=0m8FfkqDL8jxVw6MZ4LNfm2sDk6OhFIjZr8urbPEdTc=;
        fh=UQIrjk+NFrKdN/MjxDViTkr0+/pBMPxyyMm0MuTbWWo=;
        b=WVixQeJGTgdQsr99mZW2qtpxl/YO0SfylUm/MPpjXEf7OsA+R4crn797HNLgq6tdYo
         sMyMqpdkqQN2MEtLH4KQ4qLYzXsUcbiK7f6mvoZJxbxxqPE+xFFlm/BAYrBE3m5zlCIn
         +VtoSI9PZZjZKpspBqFV1B3yS/VWey/wKnfR5koGM90XG/SrI3/zsZnHjAWk0FNE+YDl
         1b0R63ylhY2PBEe6bj+jd1oyIuySLrh7cqCZ8/EwY361H7eZnEISxLvWOU0G12fWXTfZ
         +maVNP4UkED/E8o7Oj22R0RHhMC1nK5zAklJjgR9MYkHPEOqQadz62jHmEyE4KJLW+wH
         bwkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785314020; x=1785918820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0m8FfkqDL8jxVw6MZ4LNfm2sDk6OhFIjZr8urbPEdTc=;
        b=sz0u5fk4U+LWOWUdej97fumEVqK0x4tJcmrjn4I0JLmxsVI4qULKftqH0svfUZKhvI
         lvAjeTPUVYhL/DVINs/lRwsfzddZuv0wGsGcQe7fm73mKIT6JTBZVmB6Ey51DI4DYCjh
         vbqOKXKQr8xftZek5PJ7ch31G+7x5E/ZQFv1SAnwSHZIuH1xorFZXmHb5jz9Qfjq83oZ
         K/dP1G+TV087ZhSB/QvbuE8IAi9fon4r35wWdue5Y2XrQImmpztiIWiL3opcpEw1Z2xL
         AoL7Oe0qvQ4Bm0J6jVEzw/k2tGdt2G/NJzqgCNCMGGtfJ1ZX8mJ+nIbBf3QGA9PjO0JO
         K1/w==
X-Forwarded-Encrypted: i=1; AHgh+RrY0JwQQzfn3I1CJP004XM7lxJ1cNcw3XvTDbCMb7V4jxZxyNmwV+wHj/PRfctsCH/zNmj3H++8hA==@kvack.org
X-Gm-Message-State: AOJu0YySd6Sl5+vef0oVcns0+fG0MPXtiW3UL4DZj9jZfQJaDoQv7pfE
	tSybhaYPg+7ndSYmwYNwzGGO2Qb9tigyGv3YzohdkyzKZTLnUySdWNRGhOiPOjwus90i7VgAHG5
	ZIq25nvYmn+rIPFahj2IoPzsdc/AdqYcSzVDTJc9SpSBXOteChqKBjZhpqzaIPuURajzhlulojo
	JgFt5RWErTQ9STQRYdm1c4QbtMxw==
X-Gm-Gg: AR+sD11ivIr+QKTRSAJeQfj2WtKwIwVMQ/5EnuYcU62+D3XHwRGiiVeSDJdiZIEfxNo
	m8AMN4jprlv07L/6CA4I56byTbFF7udyRHJlSfiTRqoGIZYLUqaPXmKJso32ScJd5pR2NrmCiFU
	m7AGVlKzWJdmoaDmzswUkjBeccGaSUvfAB5Ea0VS1pMzfv7MoD0UUcnya0C8AwHiVLMwepDi4NP
	EeisXPLg5KilweCZQ==
X-Received: by 2002:a05:6402:190d:b0:698:663d:d7bd with SMTP id 4fb4d7f45d1cf-6a034a5289dmr3073083a12.11.1785314020036;
        Wed, 29 Jul 2026 01:33:40 -0700 (PDT)
X-Received: by 2002:a05:6402:190d:b0:698:663d:d7bd with SMTP id
 4fb4d7f45d1cf-6a034a5289dmr3073047a12.11.1785314019553; Wed, 29 Jul 2026
 01:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260727143618.1582318-1-alex@ghiti.fr> <20260727143618.1582318-4-alex@ghiti.fr>
 <CAO9r8zNJ1cfCVgxtpqx4Db380bjZ+Z0P842eAxPXw6Mh4XBrww@mail.gmail.com>
 <CAEmasaXR5EmGCv3T5AzM_2908R-VjfMcObrACyVGokY2U=+i+Q@mail.gmail.com>
 <CAKEwX=P5G=Ckafy6fm9ws3njWP_Zm_AHRKOFERScB9Pkd_KvGw@mail.gmail.com> <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
In-Reply-To: <CAO9r8zNsZUvMknjmH7MvkQ=09DnB9YvtYoA0ei5Hj_cESQAVPg@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Wed, 29 Jul 2026 10:33:27 +0200
X-Gm-Features: AUfX_mzrgjxQdJlYQ4l0vfOQ58v9c5M3PN-13He29IFXJZCQQKJaLgNVSTbMeMg
Message-ID: <CAEmasaVfZqXR36JoPkGnNDTW3qY9wni1+5Qt4-Xs8a+tFpdXrQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kairui Song <ryncsn@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=aelRWxot c=1 sm=1 tr=0 ts=6a69bae5 cx=c_pps
 a=DTy5UCxgudPLKrSn28m7Kw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=4VkJNWZG4ZaRP7SAU3UA:9
 a=QEXdDO2ut3YA:10 a=VzYV69SsQLkmnS9OQLw-:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: oAV23_7kAlff-_P7TvYVLAQm9USlipYT
X-Proofpoint-ORIG-GUID: oAV23_7kAlff-_P7TvYVLAQm9USlipYT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA2OCBTYWx0ZWRfXxXKGGKBJ6l3L
 CgcHxuwjeE08B1p8eONmbwtjvI/iLeO87KEOC6dYlxglv/vQyqC6HElEq4DlYgmzCfc+ITEZoam
 L8V0kqJwpQTVXEV9MmGiNDa++znSj2Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA2OCBTYWx0ZWRfX2Ip4MMW4Kw1f
 cZv0qokgY5+Xg41L8sytDY9SK4H0ictAP9cPYktBPvWqHuY8/7WnK/6E2xxNBnZ7jhakcUjmyfh
 p7QSyxRzpdqxGyycJfy+etYPHgHxNQtGUOjlcw04BtA7a7EpZIdHagHXK0M9w6Q8jPcFlYL1JRe
 VFWR+Vp14/rlCc0gCaZ3lPn7CXLQ4yHiZW+Pe6l+it+wBt0GNUuKg+KvGzcVTLmhgmxCj5QStYU
 mAxde5etVn4WvplYG/hltYnjyQIv+S9ggjcmOuusgTMr6ioxQc4TLq/GEk43IJ/sVe/5oPEpzdc
 jIdsUxZzs0KeJKiOs4ccGYctRyF7cgZCYv+tCxDCJTxkXVR9+2MVJAXK8nknAvWfT7cWtUGVJfU
 uC2fODkTvALJ6GPfhpt/+0/T6VrlpwgP1g8UXcxJFL5ziL9518b1YaJXEnbNRYkOkojXJkwnHXV
 CYlJki9927DJbe3AK9Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AFD18000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 7gok7p7dnoauh64tzd5fw8dc3ena58gj
X-HE-Tag: 1785314023-860619
X-HE-Meta: U2FsdGVkX18Vjz0yFytfJm6cXab67dx7KCR/U1LKNNjAby+vS17WGEY5izxweq7z8Y0Rfbou1gfOu1LnOnmJF1dHc21/M9RSZs5dJvjS8k4bsjMt8+ykT9NVWGqDEyaDhAbt7nE/J+0SQj0v+68nNX2tq1ecpHmU24k+k0hXJ28fK15/QlVAesB3Qyt1I6nqcR3/XKHZBbsB8T1iNmovQNKQjywrLNEooS8orRwcwGzF5ZZZywabbGTGEQhxRkF2m34qIiQ3O9zD4RdLuV3Ow7k7HPM9UgiMFY6DpXVekJgBtL9rwzahaenAPd+33dzA0gCpPF7ohUp1BOnhj13JRbEi80eM8RhZYlMiH26/pPuurc4BIiJOMzZMlGYpDTBWIL6D/dCO0UTzWPKYTEWpSEGZB6+HcPMyCWpWOhvF+BrjWHLkpk+J9OwMJa0862Ikq6DqiiAuuirwcSzkozrKbeRFpfq53SnUeXikCNwqvNvEOUpCkRVBOrl8MyHBHd1gvpWrKAkANSokY5Wab0aj33sN1Ssz6KnhlXcr1jRfiuiVbREJ8gO8TEU5PiqfLBteP4pTHD6TnhL+LoMhTTbJ1bVDP7qh0vfqzoRHNfAw0ZKm+DzkBhMO7nOiynw1cm7O2UE2NSia6xCrMJ6rOwAu8fyga6RzRr6JApFD17/+518Izu35eD0CaV5HJg6YpDnr32wNwhSTL4GWX1GksHGjrCghqCH6HBxTmYW/bHJgABox7PqpnnLCjacMo3UqG/RmBKaTGJ3375MH+zPTpykQBRfMJvSn8jX4kv3gF0bDULz13drqbEkvG8k3VjArKlEZrse0EL7WwHqi2QehUY1G/1Tb8PDYm4Be7APd/md8RPAGwXpgPPNE4OSA1YsuMYM50d3U6PeZwUdW684Ft715ZxsJcPQiZL+oy/zB+s6VJf+5GtBf6ZGbhuVihgs04KQOxXKX/KnpheYZIWR5mHN
 XKNgeVbx
 PLPuxanv7rrM1JJ15b5Tko9tP1nC0cc7pW52elONWbYw3g9/WwsUfCMVsR0WwD8nm/aSfVme71gcEpHk0AA1uUmfjG2RyRLU1fmA0osJ1xgFXvyscdEnk3pz3VVGUJQ7WHLlnyGUezr+Czvij63Icnwd7RRWaWN0rk+hgcseZHfCLN399JOdPE5p8928cSKrRY3MXo9todACQaYsetjjo3J+HQyKYhXBidsjlDkim+v0BcACJE22ldOsQENWV9CAEYL1UmEv2/Hmcdq5xjS8Ebna08fAHdzSdATaANw/EIuKWFn3gJUf10EZPIymUtAgxKF39wM3CvVxJymuzKbAVaZ9OEIfxRUwr1f13RxGWZDpSoexqjSekCd6uY8zhqFfbHy5c5vxZgfsmkr2bC+jk47SwQvXPzRcPhjlJZ56CPQPr3zCFVsfrzvaP9S6uboTi1FgPzoiBIRl1eqA/Q1An+LEjDFOO3gDfF/deGgDocNev+5PXUPry/QI+QNqCHbDtrpLgTRCKAjhNqb1ci1jcH4slpZdhqX806vMyQx8fC6v+woskxmKo8Zmvrkj6tfWtehY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 5:57=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> >
> On Tue, Jul 28, 2026 at 8:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Jul 28, 2026 at 5:58=E2=80=AFAM Alexandre Ghiti <alexghiti@meta=
.com> wrote:
> > >
> > > Hi Yosry,
> > >
> > > On Mon, Jul 27, 2026 at 7:05=E2=80=AFPM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > >
> > > > On Mon, Jul 27, 2026 at 7:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti=
.fr> wrote:
> > > > >
> > > > > zswap writeback decompresses an entry into a fresh swap cache fol=
io and
> > > > > writes it back. The folio is cold by construction, yet it is left=
 on the
> > > > > LRU for reclaim to find and free later, wasting a reclaim scan an=
d keeping
> > > > > cold memory resident longer than necessary.
> > > > >
> > > > > Allocate the folio off the LRU and drop it as soon as writeback c=
ompletes:
> > > > > mark it PG_dropbehind so the swap dropbehind path frees it once w=
riteback
> > > > > ends. Synchronous-IO devices complete writeback in this context, =
so there
> > > > > the folio is dropped inline instead.
> > > >
> > > > Why does this need to be handled in zswap? Doesn't writeback from s=
ync
> > > > devices still call folio_end_writeaback() and do the dropbehind
> > > > handling?
> > >
> > > That's an optimization rather than a real need: since we know we are
> > > in a sleepable context, we can safely drop the folio from the swap
> > > cache here. And since we don't mark the sync folios as dropbehind,
> > > they never enter the list handled by the dropbehind workqueue.
> >
> > It's a bit artificial, but you can try testing zswap writeback to
> > zram? :) Likely you'll see some small tput win there?
> >
> > (TBH I have not seen sync IO swap backends other than zram though so
> > idk what's more realistic. We don't have pmem device available for
> > testing etc.)
>
> I don't think it's worth optimizing zswap + sync backend tbh.

Ok, I'll drop it in v3 then!

Thanks for your feedback,

Alex

