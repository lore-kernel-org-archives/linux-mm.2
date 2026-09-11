Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E544DC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0570C6B009E; Fri, 11 Sep 2026 13:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F8F6B009F; Fri, 11 Sep 2026 13:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86736B00A0; Fri, 11 Sep 2026 13:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF17D6B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:00:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 426991202E5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:00:46 +0000 (UTC)
X-FDA: 85202095692.04.1C03F82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CA3510000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:00:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqzLbr7P;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDhdb+1yueFGYCfGv2/iY4/JhNsnY4MHmhr2o01xj7U=;
	b=dgKvcLPSDG0mDRzTNvweR/ttb65SyjbHF4LM6zVwRd8D1S0fDuY/p4HmEBM5U74EVh8asx
	QT1/y2wod6RNPdFS9DH078qTIrsEFP+BTs+Xn9wDX4dQ+QIE9bApt4yGgNRHT2Q4w/MftR
	Zs9KV2NwaH6ZzMhZy0svlvncnhcrTi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146044;
	b=TA+DUd1flOL1mZRV/Ka+riUZPG7XRsbNtoXFuPha7PZpekX4l++NcfhXvQSXICYMaid2Gu
	j6e74wcg6if45eGXw3Q5yZHTrjbOhycyvVnRA6u8+6nUCzQkNgfsCaXy4nOnkFLazLiOZg
	/2v+Moaj3y5qwASO4DbVjAqdcxjGj18=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqzLbr7P;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 718C64376E;
	Fri, 11 Sep 2026 17:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B11F000FF;
	Fri, 11 Sep 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789146043;
	bh=SDhdb+1yueFGYCfGv2/iY4/JhNsnY4MHmhr2o01xj7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dqzLbr7PT9UPg2vyaVcVWkqDnTJLnNl/+9rbrIO5j+Xc/wJPxcpDAZtHGb0O5p3wx
	 xxwXDj+5wfoXizGaX4IUDbtQjoGNGIBmbFh9r+Ih/Swh0lmJo1x2rXjXAotQlrIA5i
	 8CALl0IKEmojHmvftuOoofMkLRwZj2jPgwYN/P9EP0Ge2Yy2o0vx9O1Tc9LnRc7d8a
	 ECioA+6R8JEa+dnDWQvYkyKqpHAO81tDbTlKvOLsbaMVoBHTGt5Y2bsOxTUhPmn5m/
	 bZSIlx+oLSNnrcP6gkKiSYENsTC+1lLLRiHh3dEhvB47zpFmLxPKtk1t4g8IwsgehU
	 sPQt4Xy2dY91w==
Message-ID: <e430cbf2-52a0-4fee-8730-06bb9496c1f1@kernel.org>
Date: Fri, 11 Sep 2026 19:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm: introduce hw_pte_t for PTE table storage
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <20260903103002.1091859-2-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903103002.1091859-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CA3510000F
X-Stat-Signature: kf67jgmgton8pijimtwjeansw6etaqbr
X-Rspam-User: 
X-HE-Tag: 1789146044-792604
X-HE-Meta: U2FsdGVkX18xYnB8ZnaiGfHb1PJi4eWdcCtxsRvT03L7ouF1FXHgQ1Kq9qfljjk1w1YkD9XwXGl5jqmp/fgKoTQzKT9CaGs8gqZZtRibAH8fMmaClxTC9p8wOMLOVwPWlrXjYyRmdpTG8DX9H9XFoTaB8cXGDxtk5fGxzNuZ9PO59g0ClZSMpq8q0iwmFFV7p1oCuLbDJYz2D0wM17olHNzNt7ELvS+lg258kyOwN3RZNJ/yCPObW6s+vuL4oUr22RJZkZdjquW+r+9irhgBoiyUlC+M1KeAF+RL7L/8S+eEThbs7DbFaid5uJFwAdnuyCklPuYEvEuCXYJuTMMnlYb4xDDS5CzZbBQjcVgH6PoR69KmsvQfp6PypFbpYQ2ABx0YCMrKqdCzZa1azlUSxhJgmm/FT6hrPw6CFJPz0yB5XapMxsMZHUVmNNxqoGoRQ8k0uO9Jbl1TkcffCL05WLLrTgb5oy8pTfZZoSmCFhgHNxIzM4K8fm0PAoBsd07P9XBmLb5Z/jn2/1+9sU8sZ6MVPKmU/FgUI+uXYAvHdhpg66ZAmSYP5DG4YBZAv6rxTUoGXj6W2lK3+9JGLUbRzAjongDP+PYsx8knObvpDvuGVoBtdDbtFjq1hPlcTXLOcnqBR6sSVL8Wv6sDTB3AI2JxqDnOfeIk8Q1Otstk7Uhgc4p8SVNx2U0oTVTFakr0KLll/TeLLni1R7Jg3h3a8xmiIqOvXH7laVXIcuGkF2UX076wYm9ZtvPEH/n9RII4FotTqJKts/C37J+X1aRG95XTCRgAG3xFy5FaZXf90fc9HTf80ZIuFM6I55ZlcYMvKJ1+7CluBje187GBsR/FxoLSm62XNo/nK2ZF1ietk4eXUVFHUVZOVX+4KTA4cIoW0OM1ICU7Ic8+b8icFYzrvmaARbKzXdG0YoNoiHUh6mer4R+6mwYgu8BS/F5DkYRQyEUU2hNAwz48UXrxrAe
 k2P1VY/I
 s1jf3BLQ2ZbZXQj3MJgUhKmOFcYMDufDtCyoF3Dk0Mx+JSiNKqxgOjdjvOLqnqzrB8sy4lUSEaOFUEqnRgk/ES8D8to0uSpKKleXyavGBz5nmTut5M5B28OW3srgtgHw3ESQpTniE6oTZE/VCSWPG8GjiwW9No2OmB5gPaTEYSnyvzxHpkDTploW+8TAhk8H/0327FttfEC3Dyw7Pz+CSEs41YKeuwlua20b5+cshfNRlD/aFNAn+CeCH4vn5oupQWFhQg1zGGbNaUdf9zS0n8FrNz4tk/8+E5vHl+6OfICXNAB947YUj+2UQ3trru1wyTlvioM0rFYBGCeguGyv0UbVyXflRbFiqpKaU28OUfCPQw54l1TrimArkpp5rNGalGXTnW/tJr7OZ7Oh8eQ3G/qiKf+yY5FBqdD5qxWWqIiWp42r9wkwvR/N8kk2JqWAIeKjiHJrRNPM4x+RfrER3EzYyxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 12:29, Muhammad Usama Anjum wrote:
> pte_t is used both for software PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a software PTE
> value from a pointer to table storage.
> 
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as a macro alias of pte_t by default. When an architecture selects
> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> This preserves the representation while allowing converted architectures
> to enforce the distinction at compile time.
> 
> Name the generic wrapper structure __hw_pte_t so architectures can
> forward-declare it when pgtable_t must be defined before the generic
> hw_pte_t typedef is visible. This avoids header-order dependencies.
> 
> Keep the C type definitions behind an __ASSEMBLY__ check because
> architecture assembly sources can include this header indirectly. Include
> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> they previously obtained from that header.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

