Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EF7C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED746B008C; Wed,  9 Sep 2026 10:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5286B0092; Wed,  9 Sep 2026 10:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCCD6B0093; Wed,  9 Sep 2026 10:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFBAB6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:20:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4563C401E0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:20:46 +0000 (UTC)
X-FDA: 85194434892.24.A037443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6765F140005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:20:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnHLaMAo;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNa+R32oRzIlggZcI4nA479nmzN6Ja3e5lLkInWTr24=;
	b=ZlmCLZWlbrSZAeZveBP32mSmQWZlIDeiUSEgcBS8NOtZENm1FtTzN2H4xWusJT0PRyha1b
	denx45fnL8uZWz3I19b0C1dbJnzE7yboWuiVdhubsxA+CIouVPr5+1GxZNF1gYxLkyCAWI
	Rz15rMWpQ+zkhP9cQYcUxWDaCciQN2w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnHLaMAo;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963644;
	b=pbM8cm5XtUwQEr9mUOsbK4i39UyrtY7PQWuHF9eUkmVkGeRfYFhfksTJtuWicGuOUmK8Mv
	rg+ioGnIn6nsunIejh3oYlZOhhg4rT6EnidSQ4D4KmYn95fhMW5qi2lqhG0foCflenbILp
	QnnPe9RmDFlQfX0mdmrryhKwa0voHVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CDC240BD9;
	Wed,  9 Sep 2026 14:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844AF1F00A3D;
	Wed,  9 Sep 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963643;
	bh=pNa+R32oRzIlggZcI4nA479nmzN6Ja3e5lLkInWTr24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lnHLaMAopxlt4KS67LLWDWspk5zG17ntY3H9Pe2yIVsiFSE2BRoYW00yJg+xHoh10
	 vuNVVQC2bfNK0nyBX1v9GN1Psf3WbkOKPt/kAIud/e0yPLkq0JCsdntmOD5i+4fY/Y
	 Ml2/4whKkbL2iUhms0DZo9w4Hej2h47PsPoV74ZUvFvumYQzyJ4Z8ZXNQSLwcAc2a7
	 kcdfu2aCv2kKeEPe/X0okGepxzVjumyPE0sHnCzfrTf8KARGjVRH66h7+/8ZjOKTGa
	 kk2sXnk6fjbWqOFkprZPu77oQxxro0cxZu5khxthAUAiRK9hcw7Lb8/S3rgn407qQ6
	 2GycK1VAQOOXA==
Message-ID: <e31d07a6-52b3-46bd-8a1e-03238428a0d0@kernel.org>
Date: Wed, 9 Sep 2026 16:20:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/14] treewide: adjust comments on PagePrivate and
 PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-mtd@lists.infradead.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-13-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-13-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6765F140005
X-Stat-Signature: t3othytx38bjric3dks31ou35ujf81si
X-Rspam-User: 
X-HE-Tag: 1788963644-881169
X-HE-Meta: U2FsdGVkX1/DSA4znUnpFvP8kDin48a4J0SMoMSEfKl+qtk3E7Hds9/XX0r3dKmphw+/VHZq5QEdj+xqUjiKCVmvbhfmYqZ7rRWS/w1gpD7Z39cS5hZ3eUQYGwwdltSmsm/NLg6/Nyy0GBY+VvtkxUEhQ6niubRx4ghRBcs8P/zJuPn79DLq7qVnUC6Cd3ESi230MXz+4AsTMna+OJCsSJaim4GIVM9gQF6o+JPLL+dcyczZP1SkZFoUHwre2w0+lzQSed9bQyw7kVYKnpaHYCCVEdLDTB8BCjp7soeCgIVEeOTNpmIH22zoCjoxbStPEbD1g4fBikl1LoRz4Zq8626KPzQRmaAdbX4Im3BKXNkIf3eknwWelhI09R/4pmvL8vYMiEVnvr1KXhm5gVOrOQhrPyRXV2OwdAnRjw9+1qUeB1TAr8jGQUWLpTRVFgZtQ/GmjxdY1oIpY3kdo3Iz799mMV8CyxxxHEHIK1YTwWRR0jm4WTgKb6sxT3MNJvjW4XX/FQUNrRgDp1GtQ54aKqffmJPOy+wrYxsX8KbzTODCm/u+KM4AzUmUxHRiZrkQbZNelVn8TyKIIwsmU5CLr6pVRWWTBSnjL+hiCL2xfv5cDt160k6E6zZ+1FNRetsUEC0H2A+Xn7nueJtMJQ5wGR0pmPTHxND9dfRlbcztfC5+6i5Uy1pm7UuvskCw3dFKKwqzFskMtxz6HTMTuctDMbX/6nud+6S+LtnIgVS15FxlAluhknFhRSGiUpLdK3ob++eAackUJSlyKRYWHtsckQmN98bDU/HOCUPTDRII7H8YkJhfZo9kXyTvL1IBwDSWDZMCquucptur39n67Vc8pzHABVjZcntI9Svhx3F5BFfl/14zZ8dqDU4+s06TqL3mAGPgaRjGOwbc8IT9PXHYVUtwiNsVKYvsmrkoLDMYkLJDW7FLKLNda6/BOsZkMjIXYWyfl3WUqz0EAFXrA1E
 55TtmDKW
 Yth3TLmiF1PyUDIBokTSHdeGBbsSJ1pafB5DmwqONj7NCPjWa497/NE706UUMjm9A+CTfb/RzxreWmCJ8r3KSTClUveXspAUDu4KK3d2hEHFm0CFEIWm3zHAP532wWqTduMKM7FZojb9epD/6nW2ub95K8139Fp/l484yPXmJaAm5ZXyfqWABTBl0JUPAKXhY8LFKZ/EGRLrAgAY8pjvmwXwog/Kb9DSFXAouyT+IHEPQk7VPa4n4E3gXEz0viyaKEWjk4YPMcQ4T6O/z9roB23DkZzded4+oqJ+c+uFk0Odxl32EvdsaHCIsOVCfnfIDLmEInwUyAw1yuIYfrV6iUqd+yg8gZNBGEPid
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> PG_private is going to be deleted. Adjust related comments to refer to
> page/folio->private instead.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

