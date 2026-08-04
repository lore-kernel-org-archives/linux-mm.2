Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A771C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A106B0095; Mon,  3 Aug 2026 20:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AD26B0096; Mon,  3 Aug 2026 20:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AC46B0098; Mon,  3 Aug 2026 20:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20216B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:51:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6549B8087E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:51:08 +0000 (UTC)
X-FDA: 85061757816.18.B073F1E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6CFB120005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:51:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sQbGTxIu;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785804666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPAqf8W+SOmBCOvm4RdNKH3MkS75l5l76BrhoKYcVS8=;
	b=W4TdPUg0WUwGOrYhl9q3YdktXjkB53Zlby2VWpLnjB4YGZmSG04XdKqQrDQvqUaAcUyNSb
	xQWJsNoDYZVSwpdvMMLEQB0leJLacjg2WLZYEmBVWK9tGYOEINsgSliDITTq6y1Nep/xkA
	1uC38o8IPtzAKWPFLC8mxmLD4hjzIUA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sQbGTxIu;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785804666;
	b=JrznXFsNTdivvAvZTBiLK86nGNKedJcY/ugsxqRLg/tvrFUCImlyW3WVIV0+13GR4kYKJF
	hUy9KMV3DOCcSYaaZEYnvQZBQsv4EHrVSqSkjM9eKN7kdZhU3rSK/VyDB1XoLHbQryv1nn
	wwEtzEVZ3MlTkEjH6dbiFrgAnGNr9s0=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-934944f2d22so217655085a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785804665; x=1786409465; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RPAqf8W+SOmBCOvm4RdNKH3MkS75l5l76BrhoKYcVS8=;
        b=sQbGTxIuHlsAmE0TMCuOJ8SQQcuXbwjWQXeFJjASP/p7HJnpfIf5JcSBMqiRU/QcIq
         2sINoLYiDYz4JQ/Y1N55mUTTCmm+GjnAuD0Aa1p7LkojmBaQPFlA8G5j73AuP5TXpRo4
         basrsN6d/+yiO4zy07+MnRV+rTyL0GhkC27JwmQSHIwtQcwXPGJ5iRep9wLFUdpVkh2t
         CbhqUQkaOTU3UpISYtLNhDRl7APXm+nxkcl8osZQOSHL2Egc3VfZNRB8XXncsW3nnlaW
         uQcy1pf49JQFV4SDClSFezoywjY7XFmx8Tp1pXxjdydj3JyoLv5w01lXo3Sc0JJIiEUY
         bxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785804665; x=1786409465;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RPAqf8W+SOmBCOvm4RdNKH3MkS75l5l76BrhoKYcVS8=;
        b=Yb4TI01WiEG9ESbqi6y9/RXYk1tQJVwQnr2OT5/oszMHAmHn/7HCzwls5EK+G3O8cf
         TKn1jheD2QK72/toEEr79qNtTzPXuXH12qtbMjc7ZIl4S6hJQ0Xu6B/plZblqXJa2HTs
         7HvuWRuX52venQwWOZWc8c06Rs60uE/ZWbmR1xARHusysuANPBEXJzylCd04LT72L3Bi
         WGyyttxTM4Zv1FiC3+nycL7wkFrN4QcCkw1tzxgDGUeJOCuNW3wpMN1Qn6gxCbpGNT3V
         KT+F/OSsRoBCT6J2r/f+BZm+5lomE/6mnhVCJuFH8Yz4Ts4jJwqYia4086kjrOlsts3+
         u7vg==
X-Forwarded-Encrypted: i=1; AHgh+Roes3am7An9BTXCBNarrHZ5fRo0LHeE0o8RTnvFhRnONCJzWiSXxYgIy3lz3ALE5vRLC0IKRcJtxg==@kvack.org
X-Gm-Message-State: AOJu0YxyNpXtPS24+axyZlRhCrpRFid67FEGpa6v0hbNziUjwEslnwcW
	fHBgj/2ILOc1YXH22OPMnCY+hOzz9tbrgsIU1iBglvof0Edo5vR9dmmeZqo/UwgrkBI=
X-Gm-Gg: AR+sD11wQn17ykZhdA/56zl0XCMmcrTdv03YOizGa7eEP1zoXnM8Qy68e2VUQx+cCm7
	WndEyBgcFBjsyaWUs/s+jPsdr7MeyoduGXqrjidmsMdJWsCmVt+9Vus5axgsSax1l59bMT6A3CA
	xl3GQCmvGGVGn+0FiULqdQ8bWcHMNzpw81bJ95Zv6tlfUyt8lvXbucA9Ti5yHBFE1z5piV+tR6D
	pgJ/uRKXfFoAH5uwYqrs6BF4pYjXElmwF7J1HUJBKYAfWpFKcS4R5kSiZCHTB7azgjfcRlGvdCE
	c/KK/5GoDlkCmH6Wo/bdIrqfhQS2gSIMrujZuGuXzVqBtRFyv3CZdq9Mp+HtuaKzYHGyFCwlD5H
	fFmjS9HkmrdYbu3hxwAzqq2YTDDIQVwpjZWo6f1TS0/nGitvMhlyPVEuDYqekdAH6VbFQjryD4u
	qs/3EqbSJZoA7mgXGBYFdJKP46FDpEhdfjy7tCUgstJK3tlKJ24A2upgG04yw=
X-Received: by 2002:a05:622a:588c:b0:51c:164b:b240 with SMTP id d75a77b69052e-52b5676019fmr245291931cf.4.1785804665532;
        Mon, 03 Aug 2026 17:51:05 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4ebc1313sm75562751cf.26.2026.08.03.17.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 17:51:04 -0700 (PDT)
Date: Mon, 3 Aug 2026 20:51:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Message-ID: <anE3d-IsbkoA8X1h@cmpxchg.org>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <anCuGbQ_-pTajAed@cmpxchg.org>
 <DKFF32LRYH32.16JIXI4LUS5E9@nvidia.com>
 <anDHoYNn0lPc34cK@cmpxchg.org>
 <DKFM47T0EL9B.2LJLE3UFJ0E2X@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKFM47T0EL9B.2LJLE3UFJ0E2X@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6CFB120005
X-Stat-Signature: 39pciz1gkah5m7b9p577iffz3thshp11
X-HE-Tag: 1785804666-6
X-HE-Meta: U2FsdGVkX1/+8eQ0Zk/pYj4TDAwzHFUtXw+ozmdYpTwd5EUL/cK02zOt8jx9uT6MaQvwrDRP+hCqab8Al9lvPQ7cDRFj9mE2r5YOxXpQhn4hY/DPAVBZuzQaE3yzi/Tm43eJ3uy9Y5SK30b3FG/s+gWvs3HALDwuGg7i/xiiruiXc154jh0CSpKW0/ziP0kbt5W7ETFgWY3ro8fcgak4be9FIFXrLuCsRjNUxpPmk8ORkqqOdJalj1nSveG8TMo2x8VrXwUVgGSo4O1bI/N5kgYhfCH+GZLv5DVlETcrPOEc/mrjOT3Zi1vLsyqvN9NswFeKzkLmd586F1U4JuUN0LD+hDgAGTm1lsL0E7o96vhO6qjSTUvfLDPWhhvCFXr42+Weof9eFjulQp8Cq6ymBzQuVkXtJgQNMpmUUwBtAQnN3x7OIARVQ3FlDdcPGZKRZlO9F7FFAevB/3D3QRqxZOkA9z0+YCMGg8WQGXEY8oQf8XScpWFowSHHJtwV928XfAwhbEZXdQrp+AFMJHBCYN0je+/OJHouiJygMYyA9bvY5ZOvK9sNjRXm2+Ti5JNbsZrSwGEV3dI35Lk36UwfUpbW1iYvp42x8N+2Y6OoEjPJQRJO5UIBhXoRzVomejqi/LqYvOG10DMFJn0zAeI2fRW4cnwEnmhN/5xQrOq4BrDBkL/a6RoMMo2iNSfX+RinvGmxiwTXR4MFYHYysqxgocbBdZ19AGwG53SskipIcLpJXnq/maKiw+BpOihsqwXcnUHqHxp34cYv9jj7aWJAsxQpvM6XkLFHl/Tvh/8GG/U693BelK8XKV18YCPR8SjUhZHpfmTuhCIQWckpBD3YN2vz53Pp8cZhG/O7/TI+SuTb5sQvyHSThepAbNV+y3XJSWaYsmTu+zil8vkq97dA1Gz7+MgCUOxy85E0J4y5Fp0AewUNdWZQW6JLssus/MDOJSHpLUbhlffjVvj/E2d
 0qQopIPr
 uE+zOllc2A94oWNQN/Mh8/oUR7Fq7clvKvykNt+YtuH111IoSlY8y2KFI2m4lWEWapuUmDagj3RsXj+jFhu5Dxm3zlJ8j3X+i2s28SM1i/1fzlJqP6CJ+Sfj6/M3/0ZirSLqjgZDHx7Dh+A8suih7ctSXnEP5mk2qNtyqWKn3DEieE0f8zHhEFjgFX91jJR0mP0xzVf3rmWX5J5MnwbrzJEEWHu2KeW0PRemiHB00C7zSxaU8j6kbmKs4750aFcuYaWu8+Q8UIVQA+T9XloHjvth6iRlrcfm6qggV2bfnWDde0SQGFidktf36cs54YBobZVvOOx7IgC3sHfoPSdvPRSdD+AOef1FclCb8h9QzisPl5TvKwE25+P7ksT6kK0vYWLhZVb00PMMRJ7kGWZ79gxrl4scMwKqkGQVbEDDcccq33wwOtsTHHLVPDM4ifjM4Hoqxkmt7XH7p4mlbsLLTuT3I7AkhRq4t/P/FztA6TJKwHsXnBCRANGbyrNnJxfX64KYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good to me!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

