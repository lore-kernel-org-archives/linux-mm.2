Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795C1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DECE6B00D5; Wed, 29 Jul 2026 10:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F186B00D6; Wed, 29 Jul 2026 10:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057C66B00DB; Wed, 29 Jul 2026 10:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D24F86B00D5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAE91A0692
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:52:24 +0000 (UTC)
X-FDA: 85041651408.25.9068A10
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4B524000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:52:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=daSQqxUj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785325943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgAN7UnWx3H6BkdgHgHpTJ4Fnou4I35eqyGgnu4T0as=;
	b=b2itpomiaIbFkKVQyHjXGsqxZ3Op2Nfo5nyphu9kGzglRtaqAEnYxpf6ney3WQ5+KolOSo
	6mIia56FPgU5AF4b1jpTEHhkGXmE+y/pCjj0cJAZCpsYmB9dgPo+WhQ4Yb3DkCbfSiiJZQ
	z4qy0weInppOvRLoz9UcYpJfAPU2ado=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=daSQqxUj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785325943;
	b=LRNSygXB7R1N4atW4xkyjkTf0gaBenbjlk7179TuA4+K6x9B8U3QdJrUyXR5+yuwJ5B0tW
	CpqwRnWHU1fQTVOADu/8ANSGBXtJHSggVInkPCYsJY66HA+fJiuzjRHUokO5Ojp4qfusc7
	cubhD0ZaG9IgfR+B0YEYVJQP8zBhoDc=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785325939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IgAN7UnWx3H6BkdgHgHpTJ4Fnou4I35eqyGgnu4T0as=;
	b=daSQqxUjeLR8iF7yEXiHx8SjqwVLuNWGwqCP9X3CJcXaiYnu6rWMnkSAghF/orVdbI+afa
	ijtbXVpWmUQLAT/u4zL4c6BKT2guXWEneGNWwEGGAbxQtDpYKcKLm365mjueRWnnrn+/LX
	KISZJJ+3fjZiSwzLopVzw3q1tDT+Oh4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 29 Jul 2026 11:52:05 +0000
Message-Id: <DKB17ZTE9OMW.3NDH8J5WFITC4@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Wei Xu" <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed"
 <yosry@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>,
 "Nikita Kalyazin" <nikita.kalyazin@linux.dev>, "Ackerley Tng"
 <ackerleytng@google.com>
Subject: Re: [PATCH v3 00/26] mm: Add ALLOC_UNMAPPED and AS_NO_DIRECT_MAP
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4B524000D
X-Rspam-User: 
X-Stat-Signature: do1q43mjybmi86cpjy3je9cgo7qthsnn
X-HE-Tag: 1785325942-494647
X-HE-Meta: U2FsdGVkX1+BFUyqKFtVwdW9kSnpaOjP0gkIiQ12uclXaK/qSBmy08W3w7cYkAFeSIo2nc3A0NQzbyFpj0g+RgN3YjJCCb6h8AOmZ37im2hSEi5+1w4OciTOK70f0qLofzFNw3Cu60+duvKnOXA0uvPAZRgKV7PvQDLOfqn1BQaluh5GKVePm2ktX3dDDo0OCDSks4uKuCY8gL2v3kOMB95ZxLw+wtFWo9PFm6VMjl263GbGTXb5wtQUrPYnsb0xhVvAVOFihBvAr/d6TJMDJawTvCnxkBcLLN6OX3YUThFVlfU3kZTwy0tur0G7/R+PzSK9P04jdfV6GN+3oRfY512VufG/p5PK/QgsHMd4Piegw2JMoGn03Lmpq3ByjwjD0oSOeuIbXpNjmly8Baom7w/SC1Lxe5pcYgBG1Jzrwkn8t9RmMJ2mbflulKAZTGdBFRN55FashNFWddQGLZo0VCp3mLr9yrQ2f8YaXYxGpVIZkMYVwzuBLMbSn1YNDkLQVrzAinr305Ujrb3KOeg0ix4iZOsn1aTCEBRJVfk/+6BO/aTOS2zZ113AGlW39iZ9Dh1rGVN2n/GshiaporeUmyRsk9meRIjX/fGmd2CKZ6HiXci00V5rJA+YH3slhEI8lx6j/te6k7zYCe/2xmfE0zUciE0QxCw3YxhxrpL4KZE6fOvAT+DO5+b+EY3tmUhnXcGYZ4W8TejJXZZgXhQlyfhh+x3HACI6EU+jbaW22znX69GBLntAJmAfgxQDxax6ukVk2RoZsFPzvBPzZInXiIsjh4Z5nv4xhIZZ9gfFFE73GFYOPvmr7uNW5jqGZJVKI4Mk7R3sa84snMGfNjiN5bnuiW5UuDKtGX6bZY8msl/wtpg/U+ewgi3IrDS35zLeTghno3mWIhSHPNHzywaMUSvGGyGlB4fyf4APuPeO684xQ5m9cOhNGltPwN3UsxTyFcOYvEf3RhuRgatz/rw
 3kz3zLBD
 519fWeKQTNXOA7V5wYZ2DMiHdQn5q7FoXP1shzMPIs7cishDmeoomZ8Ufl+mQADtztlsiA1ukjUBC5tWxHAJrhVFGh6oxuwCxZwd64KUsIAPv25CRAH794C707clSdS6cl7hZOdb4cIozYTkIMqkAdqA5wwMfQOM4FQigXNu5uuYNa62LpAhac3K34kXkUS+KL1/seuYYYuIyJIMJdNkuz3zxVnfGclqzqxSoaff+k+J7PDFOkPx+MHqCquBpcm4DwhKL7rZjz7JH87O4dIPDfU5PgI11Do6FGcpH/pJKSIjKcIaK+sC2sEsX5kJSNc64A/iOMOaHnZM3hy5sIAKWCwMFUqgDUtul7BdKqI0SIOTML2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jul 26, 2026 at 10:22 PM UTC, Brendan Jackman wrote:
> Based on mm-new, plus this series:
> https://lore.kernel.org/all/20260716-folio-alloc-cleanups-v1-0-5363b8e92d=
33@google.com/

Sorry this is slightly inaccurate. Due to the discussion on 3/3 of that
series, this is based on mm-new plus _only the first two patches_ of the
above.

