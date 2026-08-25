Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A37C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D336B008C; Tue, 25 Aug 2026 05:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDCE6B0096; Tue, 25 Aug 2026 05:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9149B6B0098; Tue, 25 Aug 2026 05:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67C966B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:30:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D41841203BF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:30:54 +0000 (UTC)
X-FDA: 85139272428.05.5EFCBB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 349EEC000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:30:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKF+y7ah;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZJp1vykiBBg7jSWOFYXU2rnni57JcUVe3Q+SFvtecA=;
	b=B08y7FdbXySWGIdnNoyIRim4rT8qSA+Y3XfAw0fQqsaW2T/H8++Pf5Mf6/yV7jRgbCbLuz
	5F8QdG5GrMWsCV0Ov42OAcqOKAC1k2yZLi6LC9aix6ymEfmUUq+bXPnULjeCNxV7cQBsJ7
	jIYp/PEvOdFsgKexZBljKeMMm1cpSzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKF+y7ah;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787650253;
	b=c4E0SgnPwwSronWTYhPc4hIPeeS0BjNrWrbnj42yTkux2IGPjDBaaGapRWvilPZ6S9w0FP
	FWLS+eKBCqzd3roDdhzYNaXKE1yj9pkuTdzd3dMjZhJ/NC+kAGvAVxxx6ROyN2OPZ4XuI5
	kKLbyRVt++xqPe5Lu1SVHqUViu4xiVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C0AE43C7A;
	Tue, 25 Aug 2026 09:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70EC1F000E9;
	Tue, 25 Aug 2026 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787650252;
	bh=AZJp1vykiBBg7jSWOFYXU2rnni57JcUVe3Q+SFvtecA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hKF+y7aho1w7hBDs4D3oYLClApYzCumBNriz7FqKLyJijE95MVTC4u0EqPEJgEudL
	 /UYmvYO9Ulr4j5lS5sBBuKxCk1dSplGVT68bK8BB5YR4BvqbhTAUOloyrRoAdkFsOg
	 V+uZts5raKeljNBnlFxLTwLW+1uoGNchdI3Edx52VI6AG8KU99NkUlJySGiS0qeYY/
	 wmEfGxUWeImBPjnlie4MPDyxQRuYYV+Ciz3S4LQtWIcL5xd1hi5bFsT3ozE7oKTzGm
	 C8SpdUt+t2+Ap/cIb8ZOCsr2eps73K4V1RKV0rcIn9aMrlyLwA+cCn1yKzeru0vChg
	 DqaJxQMYpeUeg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260825084608.47437-4-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-4-songmuchun@bytedance.com>
Date: Tue, 25 Aug 2026 12:30:45 +0300
Message-Id: <178765024511.3691569.908186399028844007.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 349EEC000B
X-Stat-Signature: r85oa3tb5an4awc364xccqciddbifbo4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787650253-225795
X-HE-Meta: U2FsdGVkX1999otmHfVIg0LQe/sX40p0V0Tf6E6krNEhJjoMkd1pe9xrnJzikbnulG8wXdgtUwTIx4A1xudidh84Zr0bKAZQ2O5ntOyladrG+kffHCksgCcRPVOLB4Adz6HDCUPOAesvB6GsTEADqPbVvPky/rrmfn5NDAr1JjvXAM5wCDNuX8ft9cWgoCLRp2yZwE0R4Zh/Qn06XMCMf1wSFe/3eHcexrVRrvP6yNnIIiVH6cG/OFPgwH24M4IbhXOgk7olVRijO0Fc6r8/gWk6YmTuOkK6ckZjtn+o/i/OF4pfNmiT6w+kkrXnTM+r3nz8WMIqlzcvAEPvIScIkwHMKwNVsQVPujL2NfK2S+aLKOWYp5McBV91uRL2we18m+cC4tGYZDBuYHXUxkgMGeQjIzgVOHLDiQxtep5tUpslWx9rUOayjbpC3Q6g4O4v1xJuExVl8cprh9xKZUnAxb6sfSEuL0TK8KMD0UiGv0huabOZkUWhK2hE+fiBUs9KByBIAEr02fjR3ovTaZ6QutjJyRQV3FdFUuObbJBe3ViBjQoJPHTHEbNzSjCVV9e64Nu+nod193sikFuHDLKdXLLjGHiNzCSn11hSkk0SGb2J8TtG1wbjyqS5PgnZOiIzknaUBZRtkkHXx3eEJfcHTjT9fRhmNW40+z9qMlrWMuNOzEmB5KphF7x0oxqd4fgHs2agb+e5ELepfMQoa1k/UVsyHILbgIggsZ8Vt9grclzT9iyqF/Zcut51TzQsztMaJAcCod1tSJKxttXlK7fnO93SscpWMFQLxfNzDITS1jRWFkuY5u09XYQ1nZ+VPzdH6Zq+mDPljRtxXM5SR8rJ9uBtXx8ptKscP91QH8W2qPDP3zCc0RNZIxJ6giHa5HlE/4hYV7oBNccG2f+9v0iwPnbd6JqHdOqHrhyVeKjD9MJ/riGpJ+295DutiaRiGkrxFqNTOjtUjCgoQ10HrNl
 Ug7ChZci
 EL7UiJlANCDZdqtyKkdpJp/BUXI1O1R0SzoQGF+O52EktHyHcjuuvlFvrLLxYjxWwQ0h4/zLfqUnkjb94x3+zkNKws0SQgVmk2vEl+54hhncILWirBRtn08DITqSjGwayzWh1LzH68BLG0gcwoaWpatFYfDe3/xE1/9h2Z9BYvpsqVS51IjrZovSdq7vo2+LPZTd0V+pyGrInIiAPYaWA5W2IDBd7/eIXJSstmrxrMTChst1y9J2UWaEAecZwf9O0TAs4liyTt9RfMnbYvn0vA3tVt9WvHh/V8kZeUWkI6wUx9JOqodHjjW/ZgYJm4kAQub8Hqi3TIGMpg6I8Bpp0gATdAR0v2zf5zG5t0jtBB/7EJGM7Wh02J0N+Sj0+hkdgUyut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 16:45:54 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages are
> backed by a shared vmemmap page.
> 
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


