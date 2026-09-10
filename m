Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2598C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC166B008A; Thu, 10 Sep 2026 03:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4036B008C; Thu, 10 Sep 2026 03:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5516B0096; Thu, 10 Sep 2026 03:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDE46B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:46:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B3BE4045A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:46:35 +0000 (UTC)
X-FDA: 85197070350.26.68BFDF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B57B100002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:46:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DshBTtht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DshBTtht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026393;
	b=yaZ9SMiJHLq2KtmITuJmFcjiJdIw0toZnSvY13WIP7Wbe8AZ67IDa2/+bs9E7WUUR+757c
	QcRcDyoIUsFlFQxV35lvC3UXvSL67Dy2uV84+FPBjnSsjSgVWLYCRQvcsansd8r4aEODO0
	3gsk7rDcmNimgZ/15E6TJ9i0XmJ7Ye0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29OkshucG1BNkSs+y+pFdUotIXnKObwIPh26+8OnkMY=;
	b=idBYc06vY2kIXy87lpBlM4V0e5IWuBdxlu4+1JrJgX34lvOB7tLeMOeOtw940Bnfm4XmTy
	LF/GI7WG/D6Rxh+tx0Vir4pyN1y3NQGYDiBDLym+xXmGwCMR+wcZ6L6Z7H9devAHGXNGhB
	lo6M1/Ow9fJanVcFBxvV5uf2ePr2Bx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA23142B63;
	Thu, 10 Sep 2026 07:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1E51F000FF;
	Thu, 10 Sep 2026 07:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026392;
	bh=29OkshucG1BNkSs+y+pFdUotIXnKObwIPh26+8OnkMY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DshBTthtdUBmN7l1Oj2bJ3YEEI0747aoACJI0RvWyH62i32KQU9z9Sbdz5hnmPMsR
	 tzc0bPDkE+TldjydrUoLygFFEHB51YOHJ4OQak5Sn3L4rwWzyuiqpN3v52lwmpYs2h
	 OeUBFUvxUNp8Kx082KhL34odmTheA7aW1OW3brLTmfIJdgM0kFkJqeP3b3ibAtbXpw
	 2tEpMmtxYjFt2hmRlREQ6ipyemVGTvDGDLc7hasyk+xIY0knPkhfKwosEDju3QKEwL
	 Lbvo4CreG/VC1ge1+8bOD1jxOYughYjZ15Z231hCpKESGrIXRuG3LihcgYl4P/Lt4n
	 M3yr7RGxk3/aw==
Message-ID: <58173517-fb38-4508-ac8f-ccffb299be6d@kernel.org>
Date: Thu, 10 Sep 2026 09:46:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: implement and use vma_is_faulted(), silence KCSAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
References: <20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org>
 <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org> <aqGJx-uQjN8-DEBe@gremlin>
 <c1f21bf2-71e3-4537-a000-fd0e95257759@kernel.org> <aqGaNT1M-csCCQk0@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqGaNT1M-csCCQk0@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B57B100002
X-Stat-Signature: bjgd3nsctfrg4xeasxdifihm3nz5dqhz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789026393-611066
X-HE-Meta: U2FsdGVkX19KN3ZsnSukUHaKgaS6+uCdGLFQBKhaoufHcIbGWQDQpsUtdIx7znosWy6KilzHVKIqPKXwVjkOfbE6gl7rRl+d0BdSrTWwChk1vu43PMEldHJM2SU0UbZCaXfCyYr4DsWR6gvHzuFhZNMQ9+ht67Q95oGWuTWiUrq99IFrddxGbCkNIMqQWHDOolG9+PZgpIxa46dK5mtMiccOrTrNPyTpWbKrcTBGmFEy8s5Vn57ldX2ylS85ANJTsluy9NeOfzhwHEdtZD26jG+9IA2fgWKRhQq8yymFTj3YU4jzRnqvm0f2kkgWLvsMOnS3SEvg6Rofdu05YYVNtlgge+O8mbA5fjDelVO4jJn7xgyig3mNf3iHYebh8OGrIaG39GrGM3vFOJNDjllBziih2gFzhwgL4mtaF8M+szMhQoeXno+K3b4z+2YmCd9DZYHoNYFIqsKXG2yKNXYgvj5tccJckMMn4WtGzJObtBEtgvcFXfSWHCJ65pdJEf+MryzBfhxU6crEoce00i3pxn7ysAEAIz29cQlxNdCEcRSSvxrLfmhjM6h5rYWkVewI1RqOFbfiCD6t5cK6StKi9tpthTG7/ccxKWwWgU7owO3vt9A4eu9/NQvMvndlc0rqOaBZzLftGUlgdD51y3zksuQGaHp6zsNkp4LcjIAsjNlevFGHk1hmNw27pL8+iYyNUL/Q+nI7eWoVpWLpF57Cflb2gqEMc7aKdAERRyElWj7n0+0lukY9TV7jQEUo12fWxdPW06FfDKRBY9BoJsINejCjk2K7iGGjZoqupZ5cdnwlR2PMdyypQYCZ5vpNEH1dUIW6OL1lCamYYE5H/ahpneIFjDsDCB9YrkJmlQJcin42/4tO4BnRNqChiQgbmJqhMZkZuRGPEMtuuVl/74f0xRpcSc3FOhZYu8aR6jHculrHe7aPgaF+95Wm/LqV3jzloMHrR23kzyRkhZ4bERB
 u9YlHMKJ
 JScSQkcHPsrGahYKGbIVP7V+f2uYyzhA5kFfKCdOfuBgx42Q0s0c2Y2fulS6Eyun1cBgfYaVRzzUC/y7qd6OpHcKq56yvERrMX4hJroRJs0xsA2aiEqN0hnuR571yQ1JKR3AVBSFGzkLAi4rTeA9XOk4pJlqeXYrdR7GHkiDnmL7i16r53NwGbv4UkxpyI2mk5SH7NribAmjesE75103G8IPzBi9t9kTrbSm4aXOZlOGZemiyu7IpjqcRkksVN4KBGuH9i4QmyDn9tGetApiDBMyU0T6SffbhWN64VNYzxcTBQU8O4XslWOih4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Actually how about:
> 
> vma_anon_rmap_tracked()?

Or just

vma_anon_tracked?

> 
> Then it speaks to what anon_vma is actually for, the fact the VMA has an
> anon_vma assigned like that means it is tracked by the anon_vma, and it
> abstracts the actual mechanism?
Yeah, this goes into the right direction.

-- 
Cheers,

David

