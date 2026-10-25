Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F70606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jH0j22qT
Received: by kanga.kvack.org (Postfix)
	id DA63E6B05B0; Sun, 25 Oct 2026 16:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FD26B05B1; Sun, 25 Oct 2026 16:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8066B05B2; Sun, 25 Oct 2026 16:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 942F56B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:28:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0375C405F0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:28:50 +0000 (UTC)
X-FDA: 85362287262.09.748747B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BAE6180002
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:28:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jH0j22qT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792960129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3QpwVadsToTTIZHjTnSYVeCQ+y/jH63pDopLFhMY7s=;
	b=V7e4r3QE/5E+ok2go9N3ogIzURa2tJS6LgnfbL5w4ts+y6AKuh3kvyqe2Ak8uhoSKOMEMd
	+zn8RcKg9LeTje/0dbzPmpc89Y232MbFRggEcM3EIpVH1Cf2UFTvww7TyXhCX1Uj0wfRNn
	oCLipY7UhmJkIt7ZsvvKiPntKPEdeJg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jH0j22qT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792960129;
	b=58WGRl/0jfAX70jEo9rYgaJ/xrVCCaTKnhZsBFGiUrrQDCAABgfhqGHwjSIiTk+hGw3V4N
	vM7YYKRAJVUEMh18Ycg9T+XPO6Pyd9rzIdIMoGC/YjbqWbuCZSKJtywbtuB9FM0HdMZBPB
	tB8hWZGwQUWUppY6ZD8alrVVmP9L95M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDC79600AA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F251F01825
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792960127;
	bh=o3QpwVadsToTTIZHjTnSYVeCQ+y/jH63pDopLFhMY7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jH0j22qT/1qvUBwPfTArCbUdeNnDHQ9mp6FCgByI8BQKavsqMGHM5KI3F5frbeiFk
	 YrW+tRElBeGayIXKkAtZ6cYOqVjfhqIbg0v0c1GiAMX79ibWWGIpFLgzVMvc4NRTm4
	 hpv0ARywxo9vw8/lX130RJWjNoWewWoa8MKyV0NYCECeb3aaWWdLTG7nbyh2xEp+P/
	 aNa86ScP9UKnw3SEm8188ffsExwm5MaOi9FugVxpjbwRyrxZCK1zcan0CT8EDrMwu7
	 4Om6/EAFxquJWWwU/K3lnSc1a/RzHacMynWbSroxUnk2fjYJn848qQbtRf2bWOjr10
	 yJ5vB630xcr5w==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93f2493c28bso198595385a.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:28:47 -0700 (PDT)
X-Gm-Message-State: AFq9FYJTaauRk1ut8wM/xBqmq+lI/3SLeBoLpCFX2BUt3HRE3bZ7tmXe
	9DcNf6SH+ygAGz0KDIsns0FEJ80XrgFsLtXryaH/p+j76VBEPYync82MtON9kJbrEMnJJ/j3qy5
	lV+IoxjeObUUOIShut9HFsl8lYYjSyqE=
X-Received: by 2002:a05:620a:3914:b0:93f:6c76:215 with SMTP id
 af79cd13be357-940ef97c118mr729100685a.50.1792960126963; Sun, 25 Oct 2026
 13:28:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev> <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
In-Reply-To: <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 04:28:36 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
X-Gm-Features: AclHuK88apne2qjXZS1-h2NsEBqpBIFkZPWsGITw6I6ajwe4FfnoOYhR2bwtZ_s
Message-ID: <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BAE6180002
X-Stat-Signature: 3nag7ccipk6zwtkhn8kikof4rrbxr7pb
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792960129-344854
X-HE-Meta: U2FsdGVkX1+XPcMnhs5AesN8R/kV2G68sU/fDwfY/V6fSXdYwc3BhxLjFs6t9NZbEZAPOnJtr83wJr7/pt2PQYNP8YYxkrHN5qZ4hVdHRiOr4pMRhbWesgPf377+V0ssEXP9NFEMG7xFc4u/OI7Ji3jEkJ1wqussakBlNJV2gUowspswdZ+9hKlx+DWf0RGU2/Ie/O/i42Ww07T5xILeZyHhjurEGC/brhldL+s+3xKnOKRDO1Ngi3rQHabEjLh9oPns3QAUX7BM0oUtc3GMdT4vctkZJKGm7ENHSrVORu0o0d5oum3eCFcRaSAstdzDVE+teqKq+c72/SHnH6SLoyqYYeR5CVIbqD7RK+R1iEtg/twSoGRkM0ypgsGGltpcvQSwXnCAC3102F/594sMBKCD/xV6ggdieDpCIZB2mHbzV8xDAcD2/a64iiQgXJ6tGwphJyOzQGY5DlGIEGpbqTszCKxfTqLggyPz58VstsSa1ryWqLQS7nW3NmFnaLzGvLF1t5xkYSsHH2eBlJjbwCDwwWNpZyXkSJwLgDJG4myixwLwcsJjbQ7//zrUx2K9/ipNyurKHRXO4Ap2sT9XeI1u2ae/ChPf5zqFJsWylT0mkQi3mHIY2uVvjwQRsnuBTVo2IzU7YdfUfR0unM3jwoeNIPDsV8WRG48h+ySmtiXtTxq0ovACXO+kU6Un6PtmslFkoCNY2x0mR/Uqe6Z0oV+IPn5a3fAhgC2rLDRLCYkRJBnjsrK+L2AI3sZIWHpXNCIJhggSGjBUkHZOpYdGXYauRRZjjR2O3mOSSZsrPSTIkRjQVextDQn4kuVo+gVLedjyGR6L0kJHaG5SR758z+osvsa9TLD19jLySaUawrbYuc1b7nQyXEfdr2aA2cxLf0+cNw8gFCh6PsxNox0D/cAOsAGUcy+0X5FwOHCQ1EFFU0Zh6ZNFey9NbwZyjPD2lXrkkWYc6VyP+15B0jc
 u7j+XKMw
 WuaEJg0s6qpDesNwB83lX82VwOOlUUl9rND1IMX1mOf9eZpdK4w6r1929Nps0QQfiEiGE1TeJktUWxgZ9Em9WTRjFLpMa7mU7TdF0jOtuAD8DQgxn9SlMrFJQqfK3/Ykc0S6LaGoIGlzrRaALLkUiF9fEL5GHMSCJHtxYIo5slB0I4tC+EIis/5P+tp0tdQtbF4+DmE0nObDKeRfzek/89n4wVAA8KfWtP8y5NbL3M/kpz47SC33G2XzJ7m4fgTeUHJA7R0KYmC+w1TgoFRKSnZqWaQpOYpHQmKpzP1hlFMh5yWTG1mcwKNFZik7wFEfYxrtKzn74CzZyhjgGsIffOJvmhzhyRFrQPKTdojaK1PdOBDLnoZbc7l2NQ/YZzuPnxoJL6/ZC5FnEuYlTYIXsqMB52rPNPIPi/a8j4tuG7rsYoYUQkspqYS46MH7gnEFLEYzYQkxCbm6lCL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 1:40=E2=80=AFAM Nico Pache (Red Hat)
<nico.pache@linux.dev> wrote:
>
> The zero-page remapping in __folio_split() was added to support the
> underused THP shrinker. When the shrinker is disabled via
> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
> to avoid scanning subpages for zero content unnecessarily.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when s=
plitting isolated thp")
> Signed-off-by: Nico Pache <nico.pache@linux.dev>

is b1f202060afe a correct fixes tag? as
commit b1f202060afe has no even "split_underused_thp" there.

it was introduced by 81d3ff3c6f7 ("mm: add sysfs entry to disable
splitting underused THPs").

