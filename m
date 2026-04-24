Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F1E4FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99116B00AB; Fri, 24 Apr 2026 10:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70A26B00AE; Fri, 24 Apr 2026 10:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FD66B00B1; Fri, 24 Apr 2026 10:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960E56B00AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:17:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4126D160141
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:17:13 +0000 (UTC)
X-FDA: 84693651546.16.C3D6680
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3817E8000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:17:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6N68JKY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777040231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+wyR9J6mRA82cv/13Hb4OzZ1JWi5cUMIYU7fMR32Ss=;
	b=AhkJ2SM9IAg6cmPRnsbmH/1VeTJF6ZThKO93ldPBrKnyPGsxXoLLFSG+BnvBuB/VdqywKt
	Nv0EOkMLw5Fp+o/MfGBczMtggdBfpHRdfkEdpEhRuMihFT2abiZ3SIDPlRHkXCgY/DdraT
	nBqya7QjOyXG5OwPXfIeeQXh0xXICQc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X6N68JKY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777040231; a=rsa-sha256;
	cv=pass;
	b=sLCGySQdrPyP0eq2NDAfrPdDM3A8ZQJDuaoAAcX7KKMYpJDgUf2FGxjOGbMJyoSZz2k3TM
	ez7iwChT+95ppz95y85kmascSsAkC0Wyu6PUgUtjYjfBf6qOebte/M4pC4kzYhWvGceeRK
	/cjmpvM1/ogWqsganwyrlh1ntW8bRQs=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-678a1642a81so1893678a12.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777040230; cv=none;
        d=google.com; s=arc-20240605;
        b=LyfkYmup5/hrl33LGVCYuxAMv6iU047vdGphnQAhT0jge3f+MCraN5t1U1JAqxUwD7
         I70C/EFai57PnFTbWCA4runLMVDtwtRGBY97bi/i/CXhmIE0fBg2Ar1XgC7k10QIfGhJ
         Jkiv44Njmhm+s7+zdE2GBPc5rwnA2cBx48vZKJ+qGtp18s7vJVkCXWaq44K6rO/PaY6I
         bj417qdLLf5AEGyBHWxlLOoC8nl/AGjJuYAVurEEPip90dYKjwgng9QRI0yoRyB0l8Lh
         BILei7FW3fLmsdSb0IiTAwJQLhMg0pGyrNEPcEKmHGtIO6cm8j0lWHEsUiYlo3t6S8z1
         ShVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x+wyR9J6mRA82cv/13Hb4OzZ1JWi5cUMIYU7fMR32Ss=;
        fh=rg4IpdRb5F0f7ix/7c2rhqkNyYTwz+s1onNj3XZSiNw=;
        b=Wdo9ysvcdttq15lEc8SlMobKRMtsa98n+zEWwv57PpdQdFpt71nt1AKbqIDQ40igAV
         WUMPyNwDzL96KJVLWNC3VEzXCinAnf5AxJtbOXahLt2K0Z1o99Fvkqli0DyO2pdw3uF4
         oZyIfoSlwdCv5KBDyLy6zrywbetzwEKD9Z210Rb7GWykNzvX/s65uJ7qI5MM2NwPnvx+
         H9tb1VyOlPwwYqG5gT2xC1SPD/QEC+MEGKUNAZeZB4p8IxzlwAveqULis5b3o6WO0i4P
         U5xtmLSKSh566GWwOZD3gy6qyKiYq0+H9aV7mHzfF+SUhxYdMEuTANTx0IWdMpP4MYGR
         tzYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777040230; x=1777645030; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+wyR9J6mRA82cv/13Hb4OzZ1JWi5cUMIYU7fMR32Ss=;
        b=X6N68JKY/zY8C4dpsx9ave81sex85/XVDWsyTRYyYrWsnXMAtsrpq7w39J6fsjlDIm
         qHS9ySWh28XLrM93OGpBd4sxTDnGxy2d3lp/OFAVMgezyUfbLkseyYrAmUD+e/K8Yffo
         pX3myHn3qliU7gjsqsSr5HZBCfQPcBbOsWrqe2rVH8E/0OXjMm0qj/MDagg3zhP8VqwX
         68Gdr1nKCk8nqu5JO+U5fJI/94g7zIPTldiAxMBlquzGhZMstmgjbv7yLYE7iB+E5aJ0
         BnqegGJ5LYYpgrjj1HvAfoxBzLoUR6ZJ7LD1QA9KXiwf/+uSxh1AKRjFTsfmZF0zFzLr
         kh8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777040230; x=1777645030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x+wyR9J6mRA82cv/13Hb4OzZ1JWi5cUMIYU7fMR32Ss=;
        b=bC3EIHVhruOfRelAiwY8X8oqDVUpmgrETWWofWay6HTc9H76pGI4mN/lRubcQTZkoV
         hs48dZTBsFmCIdchqbi0Gg9ZnXA6eNgt25YtjxBSmmNzw+/KfvLrPWsKIRYaC5dX+V4n
         zxavgDXX8i8xFqBOAg/k6jRXIXHJy+xazjm3LXO4ZYtrKodr4WYi59fAQHauG09Jjww1
         hSRatQ2ys+3eIcaghBIICFmUUZKyTXzzZwdjNzruezad3hqYy6vuuUWRAAYQWnmaCClo
         gptNoY8R7bmunbH63dkMLo0wfVkwkwqn5sWMUkxu5+YbfUlP/LqSAPqb5gXy1NAVZ+hI
         Accw==
X-Forwarded-Encrypted: i=1; AFNElJ9WDcluc206WANC5WOeclRoUd7OcvyuCxFWxMwOjYrQKPWCplfjiaw+dhxRJo65RL1Wbxx8x8uHtQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy9zmOaOCJP4S+mSpoI14KHJii0tYoYDJ2D6nT8ExJK5TqoF3g
	JNKfcvlPTDJZzJS2N6VP8XkHQBJ3tZ9OEzyU4apNRraSLDhhEAmlCEsj2NxOE75PVbpnuXWXOo8
	tJtEYJXBibXzHS9Wg7HyGzXPDQhbkPQc=
X-Gm-Gg: AeBDiet3uvi4ziBas24EgsmFxgJdVz8qzkZ4ytGEU/hzAoSuPc9/jMMT4Ujtk9YNB8F
	fWWq2gqg0mmAG25VybARjxXtdPvkitBxm+p1E40RUhJ385Xr1yhXag4KEtOtdA/d5hUVm1wcHYz
	GQ6goTI/K/xO9S8Kg3WiCeJkYi0R2FQprqiYdHvZHLdStI9MuSUz4YgiztLcgSEaoppjM8kLd/v
	0kLh3tr5fd976DH1Vd+u5MyuH0aOJVrvZHf26e23eK2CyEjZGdR2JEi3UnS8ytU3nFCMX28fVfX
	+EsOfRXrpFD8/okJtXbaLaA4mkNWk8xDc4sUHdLg2O5NRi1z5rs=
X-Received: by 2002:a05:6402:e9c:b0:673:f729:c7a1 with SMTP id
 4fb4d7f45d1cf-673f729efcdmr12444569a12.14.1777040229397; Fri, 24 Apr 2026
 07:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com> <20260424063636.539c202e4d1326088843a0f2@linux-foundation.org>
In-Reply-To: <20260424063636.539c202e4d1326088843a0f2@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Apr 2026 22:16:32 +0800
X-Gm-Features: AQROBzBO2m3qsME_fb1jALjDKyi3brSJgNggaZ_EZJlHlMYrpvwIAde5-tpDcvE
Message-ID: <CAMgjq7A-WbFpNcMmMH6baTA63f5dsJJ8=1p1yWT5JLr0i79Pbg@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3817E8000B
X-Stat-Signature: 53xjyf53rqh7hdqtiafasnj9j9gwp69d
X-Rspam-User: 
X-HE-Tag: 1777040230-125807
X-HE-Meta: U2FsdGVkX1/cyVhFJooM7G/Z6q+IPvBheY55qP9tH9+NOB0U7alJIb8S2QhotpMdlyM6DYOsxMkeWAFTqYP3dAblZQ6cYSmXmvDTup6w2We2Qi0+D9U2Dfsb+MCtkhLlJju4n/tnBkO53G+7mwhKSYMCfas9iPU9cgg6Co6TEtBqC3b88lqV3YqvSBFXEOE7F9qv0JzY3UCqjU1ZSc7tDG42aNEbzp+KfOlQZ9O+2ldeIZ+3v2dUpIvrnV9erlKBrBcskp8Gbch73vh8FgN2Zlho0wd346znWcs1EB+l2garmb6vfBaWUSWjk90K3zyuiuU9tjt4SdVYiz0uOIXTbJa0+ZD+VkmpUkJ7phcWOTqXMrYijNV1mUT20rJFtpUuf00Vc+B0zxa2SrBXVS3qC/ti16QWPC/9JIql5KTVyl5gs+u6FU8istyIdgXfnOLeYGNO1lqFe2byRk4GxbIPGXPWCERRCLnLa01CxfOdsW+2rimdc+8ugVpX36lloFkngZC1rYIMDZB1IsjgraeTPgbNssx3/UjsDBLlDyRtWDjEQeAYMy8oYNMUz28dUW7gVNxjQmdrG2ju1Sm2FdwwyjzGqygH7powWka65foKNqt4GXoaE8HxV4UP6IizUdZl2PZWMXX6ftAdy1OpHn4Mc8P2kcnEkdWn18jTJ6N7A+nsOhycVQ6vE0QdldPWy2vNuMYflr8tOO8iQT/UVQ8RLosn+aBEZmC+628EkNVnBOmtaFDO0reZxKVwO2/+2SS+Z7yUvZb1i7tm2qnsO+jsyrOUPeSll46GPMaz7KHgbKnXtTnoRFXRjDWtftLkrdVGJCb2fCiwHRHJr5kYK8cTEhJjwnuqEcBF0T2G42euevH5bWvMTmIzlsvE09OB4z3IBCCZaQjMxCU0oNpv6PTj+7JdhYDOcQB+B3u9K2BZXvjwowZ92AtsrotFfB7l0t9f6aNuktS0K6YwmX5ieHb
 VCzErC1e
 27lmh/LLgLMroDgiHHBqmHBEpb/FTtVcmQwtOHCUYsPCaqC+EBwXB9+Ep+/PoM7y1tUKH1pZAPQJWLwp6Ql6Z53enbUPsV8KVnVU5mShNFtRQJ57vNz6LZbS2znZxlfRzGN6ioOqYRwK15FM7srRtzesFkP9ekKNNXIgrLKo4dNTNEL3uXas+V1fYdJRRXeTrZK4pvXA+gWbRMVrJiN6hJdjEVc1kRrGZfLtPWuaXNnQ3Xtpcsg2/5jf0wV3XNMlFvyEKn7GaMbNjT6UY5EBt6kf5gDCtV+qGfsCllv9geZ9VgEBhmB9mUZvkabOayFpGF3LWzkXz0m3Had6a5ajsgoFRQqXvEHQLgj/Wd38XU9kdMW1L2p8EWqxTVlJBbwfv8TBW3uaUBvYxomICsWNbZt1sNMYQKAn31Xghl+D1oAbKSzr8OoLGglTCxASr3eHzb+i7gploDd3WFttpsb7FLvJq1en7cOLsl8TjW8NQD/JPW0xg5gTgNWX9K217j9jTNndAEwWfRqr+xJ6UZpPGCiyO96AZTK5WGo7YYAkDZD7LYS7ag1ANLMZfXbUACxW02ySxGUrLY2rxwWsqzrZuiSYN/WSOvhEFeebbwsx8PQiOKsppP0a9g7LNAqY2qfVUPbHb+kDIO1BVSuWJ5rtegxNsRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 9:42=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 24 Apr 2026 01:43:11 +0800 Kairui Song via B4 Relay <devnull+kaso=
ng.tencent.com@kernel.org> wrote:
>
> > This series cleans up and slightly improves MGLRU's reclaim loop and
> > dirty writeback handling. As a result, we can see an up to ~30% increas=
e
> > in some workloads like MongoDB with YCSB and a huge decrease in file
> > refault, no swap involved. Other common benchmarks have no regression,
> > and LOC is reduced, with less unexpected OOM, too.
>
> Sashiko:
>         https://sashiko.dev/#/patchset/20260424-mglru-reclaim-v6-0-a57622=
d770c3@tencent.com
>

Thanks. It's interesting that I followed sashiko previous suggestion,
cause it's a trivial part, and now sashiko is suggesting to change it
back to what I was doing :)

Nothing critical and I just saw a false positive, but anyway, I'll
forward the review to corresponding patch, I do prefer to change it
back to the previous design, maybe do some other slight improvement
too. Let me send an update in a few days after double checking the
swappiness issue reported by Barry.

