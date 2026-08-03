Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B2DC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3286B008A; Mon,  3 Aug 2026 14:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53186B0092; Mon,  3 Aug 2026 14:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69876B0093; Mon,  3 Aug 2026 14:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B165E6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:40:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40EDC407D7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:40:26 +0000 (UTC)
X-FDA: 85060823652.29.A3DDF69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 97B421A0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:40:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewuN8cuG;
	spf=pass (imf19.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785782424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZb15sPo5N1TfPjLBzaNxLa5T1EMEuStHZ3GRvUGF+E=;
	b=x2OxPOhnGMCIN1rYlzxShGdtpTehwvRvke0440NOdbSg7hrJCrPehaeVeBI+lCWAOLQfg7
	MwcvoObUmQWiiYdPAx08lL9beziKl6P3vr3X9IcfMnL7HYiuyEoqFZFDLf9Yv+0u4N9XAJ
	dchlWZ8oUfGdsejTyQvTLYrV+Kdzm0A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewuN8cuG;
	spf=pass (imf19.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785782424;
	b=RwTeb/05yJnXHCIWYM0JeVZS05LKP2OBRRJClH9H6oMQ5KAPeudRWpUBb8ULteFBw/Gjyk
	Ug3XVtT3P/KyUvH7noDwS1tBX9mPioODH7sN9xPSK0u9QvrdSHzEkoKof6oCmJd7AeA/Op
	PLlmIH8+TiZpNF/EzW6x5SiYV15yYF4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73B4C60AA9;
	Mon,  3 Aug 2026 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3022C1F000E9;
	Mon,  3 Aug 2026 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785782423;
	bh=vZb15sPo5N1TfPjLBzaNxLa5T1EMEuStHZ3GRvUGF+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ewuN8cuG7auUrC7UW93BEXpJZzHXJryz6zIWqRe/yq9BMaTlYjkUb28PRwxSvit0y
	 2pDbSrYNK7TfuZmyUpGZEGEIV8ppjlFGZzpHg0H0VrHjc2wCuS+q+H/vxdHWzEjkhR
	 q6mr2g6ltg5Yn8xfzRIdBbpHY6qb1tYvh0UN2HC5cdtNrsbnW5+r1nT9Bja/o/FhlB
	 D277qAmcxpkZU2XPn/KOMlTi8XaI/s041vXXxE0XKXuGivOMw45WRqW93vkF00kggr
	 j9OzfuJoeS9E1sEE2NU2gxILZelXTQp2gLQc/LVID10reyC4xYci3Yf6/QtlAilc0y
	 OK/54yFAKSDBQ==
Date: Mon, 3 Aug 2026 11:40:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
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
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH RFC 04/14] fs/crypto: stop setting PG_private on bounce
 page
Message-ID: <20260803184020.GC2062@quark>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-4-142c97ba3562@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-remove-pg_private-v1-4-142c97ba3562@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 97B421A0006
X-Rspamd-Server: rspam01
X-Stat-Signature: 97krde4ficx39o16nuet83uotxangnkr
X-HE-Tag: 1785782424-400219
X-HE-Meta: U2FsdGVkX1+2h0gK6wx/7trvf3M7ZcmH7vS7lzgA5DxwAwE0b0Ov6OyQjDIrN4okK/bbeXr0v4mZmymfeOqFWK3rq3j+SBw0j5cQYoDswoT1Pa5qqQkWkSYqe9UVAdCmrtNNHySXlBWZGIDnv+XCWG7BaAx2qOc9xcV6nojJwkMs/luViA1OGO4DarYsidihYeha7RjUO8OV5j98Otpf0qHkG+CaPHgwyhzU4v09WH5BPJ8cMdqoD21A9zwlsuG0SS7RqiDrHNeXqmLz07ybq1w6rgIdUZwhljiZ6wTjwrjdMj8+aueKicyXz0WxaMeHrENkmMYqqehNEgptj0nW0LrmA74v606djdHGvTKADkjpXpnVwbysnzV3TlHNsbMB3qLGC37MNtJgToVGa0C3ODG+wtvM0viv6P3CeCByt+r8GxSmrLoGrG/JikTNVKpAdklvqnGm0qRu2R1AscY6HS8u1IzuwP7Q2nHsktPbTTnWxFShL+wP6/QizsgUr3Tny6h3IpsIgHgRz+bKU79U+HaVaUuXm8T3uHkp18BPGJOjhc5E25nHaX4d+RP3fs8PFGcxvNHJx8tSdXDbdTbKmobV5nThKrwB0ahBLeNEhmCXFt08CiMqDvSFDvl4uVSVbjne/+W16kpEsY8d9B/9+43rMGpZe1XTqR0YRjBwGIy4uoXeypr/vqNVVfoxTg3M7bW9l3NfyE6riYuUVA7dW9dMFJ6Z8z5W8Yo3d2xpffCdgPP1l9pXSyt7oOdCAzpl9Fr2xA2fxW8mZO1MFBtyzBsjji5r+rFBmB4eIHCCZeSEejJTglabF+q3qW8JmTPRDUAzs5HGfqe3v4zcwaOh4PobSa+2v/3z7KNYN9/pR4za/KHRcODFNnoNJk1UPRosSKRVL58IaaWPZAxPpnek8lXROVYVYziLHq+MlXN6vQbHxT0PmxWlJnt/sJ9T8XT69c8/fpIDbD63LfGI0Vc
 0ZxStYFi
 ZIT0lsvwCCp1V2IY4nq3lKf6LH2RANEDdnpewfe2uLg80yJ4jDSmCgJOD6B+TijzOJ2ynP4CFvcVobY9uuJrXBJQFe4j/z4zcwitQhcKA/reYER+ebitda8bg01uDAP7m/2j0ybwC0LASao676oc9fYIEsAj5t/klBezLwMTgnhjlapbUwKpRkGMbLSw1o3qjl3OrIcikEWjSb5f3vcXRlaPwk6jes3HXW+YMmbhxdq44a2nRkJgBZPLzzR4u/MJAVBbr0CQgQdEDJEX1mRXVuvSL/oaOuN1+r8F+/0WMryeF3HKQ4MDCUiSHU6J6+EHaahUl3sC2rmtPND/NszZdOXylRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:13:27PM -0400, Zi Yan wrote:
> The point to a plaintext folio is stored in page->private and cannot be
> NULL, making PG_private redundant.
> 
> It prepares for a future commit that remove PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Eric Biggers <ebiggers@kernel.org>
> To: "Theodore Y. Ts'o" <tytso@mit.edu>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric

