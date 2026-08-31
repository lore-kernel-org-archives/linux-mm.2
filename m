Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA20C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D746B008C; Mon, 31 Aug 2026 19:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644FD6B0092; Mon, 31 Aug 2026 19:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583BE6B0095; Mon, 31 Aug 2026 19:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31B6C6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:45:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25B711A02E9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:45:36 +0000 (UTC)
X-FDA: 85163199072.05.F85FADC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 672A4100007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:45:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vhuqq3dh;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788219934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wj4I/MKj2L9b4J+c08D7cj7b3uNtuGqLdKw3zvVsGww=;
	b=0H0g9HvJxoJrc0Rbog10iEv/RBvW0DF7N/bTgtmUd1aUCO283pDgTxHQBoOWrMBlX769We
	z606pgJyRbjGQaLrV3YvWsEO+Lh4vwYwkF1M59vPAOc/MZVHp0d9AxDoZRcrCx7CCgj/8z
	w6JPsPsZiiJncO/8/tiSkIx9XCTFmto=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vhuqq3dh;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788219934;
	b=uKpb8lOE9lgMe54X1kuz6R4ASQMhvmfkQ0Nh32DdWBKzoC3Ll7uNWbIiSL0IE+MxHWC0gO
	ee5W4JRrV7gwQcSRvAaZ3/Q+bLXN4IEvU49T+fIxaKjX3+EWAFhSiGzxN5aI0p6jYeHU0r
	VQnnFFZsDcTqcUehfNT4rMY467MYrdA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DA53602D4;
	Mon, 31 Aug 2026 23:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0781F000E9;
	Mon, 31 Aug 2026 23:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219932;
	bh=wj4I/MKj2L9b4J+c08D7cj7b3uNtuGqLdKw3zvVsGww=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Vhuqq3dhS0xj/pd9jp9IoVKDsg24dq5X2+kEEIBjB+a3vki3RCwS4uXdfJC4jqTXJ
	 thxERrpgvXlbZtgTioLwixWVxFgiZUzOmhCn0EbPB0XODc4QSl1IVOk2OzQ56ZULUD
	 D/eOxK4ZSBkWfhM21240hACSxmQV00dGRsxfsSsg=
Date: Mon, 31 Aug 2026 16:45:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
 <kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>,
 <rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v11 0/7] mm: optimize zone-device memmap initialization
Message-Id: <20260831164531.be5a8fa210401830e85eb974@linux-foundation.org>
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 61wmbj3zd4jqwfts3whnya48cjtewpp5
X-Rspamd-Queue-Id: 672A4100007
X-HE-Tag: 1788219934-207424
X-HE-Meta: U2FsdGVkX1+vNvf4pdT3tWPWw6pKr4eYnAhLNWRjs9QRrNE0Z/swuePtiouvrPfXGeb1xHz2EM16jQJqXNxoACqWsA6XFMYxceIHbBkfIdj1cAZuGg/nfB43RId24QO1Vw3YvIQhFbwbe87+3X9o0XAwPZiVQDXrrm9vOE0V9aEaSZccYuEXvkM7uCLQkhIhgC7X3km5th5ptDWukPgSQbHDe8vsq8us2mgktSmccyjbV6Bkdyuno+3J3iJEGy32HfsV7MgiqV4RlWVwQu8jktB/17F1J7bOitCEq0wMY47W7NSd+BEDYAghrnjfSIaDEhYYBWqZP0qLgvkJfRa1wAd6epYpUWXI34JC51XzUZTYc/pf7nq6YfQJS0Idt40I67ASQDq/GBirhvliW4yaQtszuR2ZL2KcSTWrVQbNF9F9TPdQjwaJtAJhkDoS1QRS4ExlpYMQMzOkCtBMG9fjyiKeu9gu+H/OBqOCZSHwQBN15Q576Kn//F/EHGLQ1+eiYaimtwGyT7ACe52Gk9Clz7FFeLtLpLtZzqnEm6yOJFF9siSFkR3qg47kF8hvCUZfPOhRx5nW7unpyumbew8RAE0ogRDg332WuhIBDb+82Ncj5q9mgheAo8N/CKGhVMpIcFlcW0phYCi94c7oQaIr9zgQ7YZYytJPdUbPW8Gj/FD4rStbcyeeum6Qv1w9j7J/HqvVGJAGa3g+65YxCXrDe32fpFH5RGJVvocLubhc8pkszmtgLN7mRjZjn7i6FehlSfp1RSHr19M61kS70YQZ5W/G2RHbfcFmdl5zvu5181Yc+X9VoMVi1YG4OhbQsTghGjuOJ55+bz0aC7Mk7TXE6K9zF2/Dq9RWW4apQTZr+8Q/K6uT+DIP5QZ4Dz64WkRJd6wKw7iL/NmAwYXDr+JAH9L5PijIPujpolBEq73ye3OxZYCrkOG41uSJ6Vqbnkg/qtd/lOQWCGtaeS9UwVl
 m/zozD/E
 6kuKL7ciDflJlR4o7gJe2PLbZI+aZHbs6LRv0EcwyOaKUK9Tz6lKvTlVvI5tk03/2CnbbCJWRweTx5RrworxLAQWW9ACWwlJIVIafqs/xB6sJF/8gOZxF0uVh71U0ADJBFOZd45TQUx5ScI5lTuz4j10NuGPwr+V8X+Wd76EYbLmD0iETJl5KOsy8vPKkv02WtSv/KviH+Z4AAGXfM71HDyPh59DZt5fQ0kGQY23eVEl616DbwHpPaguNg0Gd0BsICBTDSSh55b8fvgrSB3di78TbQtte2VReknFnAK/rqK7GohWEyDs6u8wEL10S8Zz5my7ijOmK/x6hiJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 19:16:31 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memmap_init_zone_device() can take a noticeable amount of time when large
> pmem namespaces are bound or rebound, because it initializes nearly
> identical struct page descriptors one PFN at a time. This series reduces
> that ZONE_DEVICE memmap initialization overhead by reusing prepared
> struct page templates and, on x86, using memcpy_nontemporal() for the
> template copy path.
> 
> ...
>
> This reduces the average memmap initialization time measured during
> rebind by about 48.0% for nd_pmem and 41.6% for dax_pmem on that arm64
> VM setup. Since this arm64 setup does not use the x86 MOVNTI fast paths,
> the result also suggests that the generic template-copy optimization can
> benefit architectures without an architecture-specific
> memcpy_nontemporal() backend.

Well that's nice.

Sashiko seems to have found some new things to complain about:
	https://sashiko.dev/#/patchset/20260831111638.76012-1-lizhe.67@bytedance.com



