Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822CACA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8393B6B0088; Mon, 28 Sep 2026 11:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB086B008A; Mon, 28 Sep 2026 11:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703626B0092; Mon, 28 Sep 2026 11:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 444E56B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:19:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF7AA120218
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:37 +0000 (UTC)
X-FDA: 85263530394.07.0EFF959
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id EED29C000F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:19:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rC/SNq6h";
	spf=pass (imf28.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0NvfzIhMgoDaAcmLO9lnbeC2A03mNxAZEcGsZ2ya18=;
	b=WGcIRIGYUXbQ3628k0crm8vDhn3EHD+KF0EfGcP98W+kR9YFFjHPwODcJZRoJkLp4QrLyu
	HzBatQ6FJSr15mdmk4S8yYhShW/ibVSGlnx7u2P4/dNL9whDLfOKmNdP4uLLn9zmMaFHvG
	LDIEW2q6Hb3QdxbDUVQd8+ka7xnZ3fI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608775;
	b=SDtPcz8B8QmaIsgCkBKPe+oH0m8e2+OZ/lUZo/q8GRF2QKOr4gajQPqyIiukNEtOK+tPvn
	8O+IPb2krEeEvZmimqflXUX8XQxLVZheVcG2Tb3iT+m2CQdvDuXqFV2Uko2cd1dKk10aTc
	bhHGAvTirGMd5EpWWYRZ6aKgLz1+404=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rC/SNq6h";
	spf=pass (imf28.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so1708979a12.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790608775; x=1791213575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b0NvfzIhMgoDaAcmLO9lnbeC2A03mNxAZEcGsZ2ya18=;
        b=rC/SNq6hz7WGRpCPNOB6DLlGC9nSOA/weom6TREngcx8wdoZYNbDlt4p6m5CBtkeTu
         MheN3PtifJ250nvK1VcwXIiyFBtQc8jjvnQeZX1fS3vZwN6lnX5navsqGD3ywHMi2vSd
         6DUrQSk2SqqNah3dQeo///Dw4rjRR+TV7ICCjRD9cvdsj4wycFRComsgggdSHq1C2hx9
         FBeJaYn6KS2jgdyFFKUeVWvq4kfwNJwF7foVsoo6r7q7hqgNuixbBjANVDuZWd+w+LLW
         5eH3H1wEv7AIThuYumm96zasLucMNRRoitB4PfcmcPT/wk1ZmTYwPFHxKCOw7kiWGEOE
         Z1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608775; x=1791213575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b0NvfzIhMgoDaAcmLO9lnbeC2A03mNxAZEcGsZ2ya18=;
        b=C4u3zE9TPcfG0ND42NKqgNSO2hLWN/uUel5L4V4QmZF6pyrHbtwQUTLPaqiJT6H/Rm
         UqZLmN1/MmdKuEkkWFb5cRpTW92vZhOAhv247msjNcJw0HpicFPCglHsINNK2fIiN2fA
         5v4UdkDMtcSWtf318QabctRc+tyhlhl6Q9TaL9+ExKVie15Qq2lQ21v4urhQ31ICrfBQ
         X57I4WNAriHSNtOeETYlhCq9tsQnLEDxE4ZdFf3lCJ9TQSKNVtUoSzZTQ78THf1f1Vhd
         WliZrlI6VKplWt9ZdVzZ4HH1cnGwduOflVnPVzDO6dTjLnLr9OThjvacdoJzw9DLUYEg
         zUVQ==
X-Forwarded-Encrypted: i=1; AKwUvBw9hE3hz9aRBSihR+iwhXAXMXxFPguTEJFDJKSvdix/v5WusEbEcvys0LoooZOIVzoHis5LtkO3EQ==@kvack.org
X-Gm-Message-State: AFq9FYLIccTl3lUL4eBs8UYL9Zz2+bUS5K4Pu8QY1F9+74vecAzHxFLN
	dH27C/Bzvk73wUjbLurRwPnebF2D9KhlDNI0Agb6M6SvjN0qOgQaxXIM
X-Gm-Gg: AYBFou3IIMCB3Gqf6kKhvMs19gaw7LdU+hgcj1EK7hk927/lCY9ZVinMjEXkLvxOOff
	Vup89kiF0faHPHjohXD4cLkSqgRmxtU3Cvrw04ks+ZXE3LAmX4chETllZ4s2yB1rt4GOMhJXrfc
	4RcNPT3O/oSRQgTMq/lxGprRikKPmkxHPcENX14DWi0J3f49ze9h6/LKUCIYUIjuP83MViLet25
	K3vyJAaqf4Ug24Cs0mdpHyH120IAzPDguxnMLpsDgJTIt7UjV3hHf26cPMivHTjFW7lqCFeJ7s6
	GYVTA9ww6MyXDv5ph/+ulz39208YqgXNS4eHgR+V9BWtWl9FYO4Y5QUmJI0fGNYOrq75g/DyiP6
	w/BLF7bMAOH8vu6URBvDiTyYK4Uz/EQ+NNTNbCpalv/7V7uNSbpkkT2TrfbFMWg0h6HkheHQ4rb
	zS+yMJV7DsKIASYH57co/8obzaObCpCG0ZuDGTJR+gqD0cVHhX5SX8qCWC9k+xNmrmEqnpy3fIT
	pEYcWVb1qhI1olJtcZOHv4g3SsuTx+df5+zzBgtoJMlW7w3kbkWAS5ApINvGdjxFH8+Hn0iiLaF
	AEBtSZdOsqiH8owQCq9UNDtyQMbcVkVpi5QuHm4ETVMxbsZndrNzaA82v5c=
X-Received: by 2002:a17:90b:384c:b0:39e:5acb:2849 with SMTP id 98e67ed59e1d1-3a0bb576e5cmr8742632a91.17.1790608774215;
        Mon, 28 Sep 2026 08:19:34 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99e5220sm20891502a91.16.2026.09.28.08.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 08:19:33 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 28 Sep 2026 23:19:24 +0800
Message-ID: <20260928151924.2686290-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: as1551rnh4dcac6wpjom5q31gcqx8o54
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EED29C000F
X-HE-Tag: 1790608775-946334
X-HE-Meta: U2FsdGVkX1+J3TFJgPwUoeMtXVUksfF2qA6mSj6M2rL07awAglow9ZnIRQ5FMt5rNhEC/DNLljs8d6LTXv1DL3Pt6bumO5RXuwNORFWTxKWgRt9o43nAHBWBHaGIjsPKZHHEmAG93+KrHWQulDr0Qo6mrvUvytEQ4jWotgT14V4yKp7QoPyEr/Izkwf6k+ktyR/djQnrZ4CaDD24jsWXYfifmYFjKXToIviQoon/4dBx0EiAZZuy+WjfCx0sD08odNTvjYl0modv/RA2HhHxzbE7L6rxkHYeBL++GnL9pDmvuPd1lzZianWRspMirgRtTzpKxu/8VKaofYiOY2Hk4COYHaPp5v63RnM9cnyyO3n8nLSfndnABvIY4ErY7X8TrNTqlU5OvJwGi3UyNdhUhnRCfKp4zoCT30FkRnWLcovh3CtG1pvSCfnuVVfq4O49pk8AqaDHLjjltCrSjREApPCnv81Sev66pTa7MBsUNxbTm9GVe0oOCfxjMjb/bij69MhvNDgNdImSdCFzDzs4+Q9W40LDN9t6gNYbVo9SGkpwqN/6FrwoDpRvZP7T/TvWCZ+2kGBketbZSFKQyqjQnEhk6SzZ3JWWW5p1fxMjBW93gkYZi2fFKHg5gWKXFOenpFoo6lcCHTV1OTzKJo8Hp0uTExaRNo6tldS7u2EDJcualj3zi+02DT3KGGic14ZJdBHFm7Fv/uXd3nawbP6VE6VZW06i87rqnDkJXVVm80uMB01dsDXxz7S9jnriq9RAbZ1I3qb3ap+wE1v7jUS6USNNRc2VIi4uL55zkrFc+mVvD5LM1sx7EZv792ClBSw8M/edz4KTxXK7FG/WApz4NM622IdeuQSoMMAzGhydMhus/dbPDask+sXY2aTQpXHBRXPY0ov6qQlVhqk0qMUUeTrVG05HaC7pcXds+n5RdagLtrJs7YiujryEDE/h7hgF6AOZMrXrlHsFaeJkme/
 6Fha2eUV
 X93OihNgXIG8r7D9fwmQRnFwPkhEDRm/8NHbsEFl3tIOws0yGUma+vsKFDdnOP9ePqGqoztiPkASnE4YSxJbLAGPTtOa9dJDLLY/A5O76gRtfGWOym5JqmHjEqtCLZ0SelXMFjWSHVsWW1a6ZrduztQ09n/15/I+qK5H39FH4sC26RQQgNWkUMyvMcmD/FNoGGxFdu5698TLWSuZuTm46WLqV7HyXVv8zaiDICuqXyXXqHSIuQK9bwAWVKh/ECtsu3J6F0uJ9uTgZw+tWSfAhbFD4ybwJqBBwgegHV9I1bbvlUHbQHV2e4xGWU7Jqx4cW2asVvFY4sTbg/3+bhPq+yf7rNIndv070ZpEclACCLCC4bnBgP4jvL6jLWQDP17pGWjhXEd5wY1EsZno3YlvpbuX7ZV4R+fYhdLFvIr4lYKpO+io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

Thanks for resolving the conflicts yourself and reviewing it.

> What is the high-level user-visible impact of this series?

Being able to use more interesting swap backends and logic when the
machine is not under memory pressure.  It is much easier to write a
swap backend that may occasionally allocate memory than one that is
guaranteed never to, so today such backends are either unsafe as swap
or ruled out (btrfs, for example, refuses swapfiles that are
copy-on-write, checksummed or compressed).

> I am curious: if we never run out of swap file space on the
> non-offload swap area, does that mean we don't need this patch series?

No: running out of conventional swap isn't the point.  Without the
series, any active swap area may be written under pressure, so a
backend that may allocate can't be used as swap at all, however much
conventional swap there is next to it.

> However, direct reclaim can use both types of swap areas.

In v2 it can't: only memory.reclaim, per-node reclaim and MGLRU's
debugfs eviction may write new data to an offload-only area; direct
reclaim, kswapd, MADV_PAGEOUT and DAMON reclaim may not.  But I think
your suggestion to flip it round is closer to what I want: mark the
areas whose writes may allocate, and keep pressure reclaim away from
those, rather than tying it to what started the reclaim.  I'll work
that into v3, together with Kairui's suggestion to build on the swap
tiers work.

Thanks,
Matthias

