Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5066C606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ds96ycrx
Received: by kanga.kvack.org (Postfix)
	id 69FED6B05C0; Fri,  6 Nov 2026 07:43:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629606B05C1; Fri,  6 Nov 2026 07:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A61C6B05C2; Fri,  6 Nov 2026 07:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 220516B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:43:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD55B40DC6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:43:37 +0000 (UTC)
X-FDA: 85404660474.12.BECD612
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B7AE1C0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:43:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ds96ycrx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793969016;
	b=TnWeAy9st0yKKoUjOB13K4Igaq+OO1c9HAOVKm2f/rXUdp+89vugq9WftmoM5V15SejvYV
	dH3qoauOyPkFzXzPIOUtgGflsH9fqMA7wiUp9Jp0JyPFvSf2ETioU3M8ZnuCXOmZBsGL56
	ioG2jERHrotN2rCHYlO7Zo4LQK2gIms=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ds96ycrx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793969016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMj0Zv7LEs11ijZhAA5YMZYd2IgePJ+fzjhqquIjptA=;
	b=JGFuBabDfSqlm+nVYzdDT5DfB6cuvBtNWZUEwTNlNElDTxICV4O11rnxxN9W+Y/q5QQbUh
	L+YVcZKSb9AViFKeC5+tIh+hkbclCpBPvBoGYl5axUd5UDYZ0sP3N5vWHULy9Xs1houG7+
	ibr9LG56PUkMI+pxPGGjFMLVYhJA574=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D89D601E3;
	Fri,  6 Nov 2026 12:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD7A1F0089F;
	Fri,  6 Nov 2026 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969015;
	bh=cMj0Zv7LEs11ijZhAA5YMZYd2IgePJ+fzjhqquIjptA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ds96ycrxArfYfwXjimRzXeJPrlCovaGGoewi6ab+shIYOSTIgs2537NA+HjnpaRYw
	 Y9b6Q6kx29CcPuSTBig8SQv13MBZi98bfK+QWBmIM+tD4OuSosy2Brr1fyqIA2OH4V
	 QZcaR+YpJ6FaIztHV7/lI+HuKifvxG/YndC72wILpWQxqzlxZXG9nw9iD6JYOib/zw
	 Nlmix1WCMAMVUl7tlYZ/5hUel+PJS5EpO2WZjOtakzq8AK2p7Mj4jJ5bxXvi8BkbUU
	 WjcSK6m1vVtseYI05yqj97ntMxa7QSfNiw0J5/RUaCXUBm9DGuKU3JjEWgFn4aQFO0
	 wnOlXmfXD2Yxg==
Message-ID: <5521e876-3edb-4862-8b45-96118a21ab6a@kernel.org>
Date: Fri, 6 Nov 2026 13:43:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
 <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
 <auiZFJ7Bb6cQnqtX@e129823.arm.com>
 <d70b6ac2-a8b2-4c34-acc4-ee421eb70aac@kernel.org>
 <au2cKP0SWaaHQPrg@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au2cKP0SWaaHQPrg@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4rbewx1dnd3s19wp3x859u4jsbms9iob
X-Rspamd-Queue-Id: 0B7AE1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793969015-248437
X-HE-Meta: U2FsdGVkX18lcnbyqGMr5ni0WzwyrQApUcV72ANxH6fsLtBWAnxyIJQAC0dt4hPSCgLosdAo0eKA0szzlycowKPIcTJkgShpt8pcQnhSQkeNZ4pDXGy+yThbJK7AGQG9i8JS2oNwII516/1NfngcFCfL4ebOBbTJzmcJy3l9OPjQ2imcbNqGMW+sF2KV6u6s6Hh/zebcbl9joNpqHv8ncFEs+XbAwhGEiFHdgb6s2R0DPF5El1n9otWiMssjDVViwH4l8zRzHbtx9PEsIIKL6JL1j8AXSyCx7dU26W+RcZRryKNxYEhmzNOOKF8Aam7X1oX5MrRd7X+IQtQ+oeZhBD6xX/ggBPiAjM/xSHk1I0qpZGnCtmSv/mq9vRGUYhJqPBF88ueVIjVVT0THDV4RFcG+nkE9jxLnSyZbfiIkntzDuvO+79EmLSQgGaDbAwqscnLkBqXH59/bSQog6cLhGsg8Cnz1gKcnQEkVBqDfZGgcHImVeXS2suJRsgT5hmCggUqt90uzSYEmbzHI82wNA3HEOPrO7Gtw47JkQF47Udm0Ge9j7xdIIeww1JdEtmW84meQdCV1Re2K6hK71T8x4Jy4BqoRYAcORCCsVU62omc1sLl08Ov+jdv+3cxeQhTUiQ35VsxgRA+zwxlV0qp9WeWmwMqlfGtkSYu4/cyprn0YFaddIE/YPaef1K0VDmupcgxBHkJ/yImTgO5FKlnGLyTkcxpI43CC7T4F5+viYWAkYwngfEo+op53Ts9bxMzcTt5k5z+LPzm14NluVE+SQvT8fL8VxAd6DGCbbAJr+1HvdDgckEs98FGbLsZYJnvycag7xZY8YEgfACXDReMv6fuHqapE7QWLCOgX91D/EcXlHmkxSiFXO1Y7nj9JNaerCaT1C1wAyq29xwhNwxRGqzu7CMdr9+gBbhGzg4JKYjeZvytPr+P6UlcfTwPUTouXjyq9SliB43RATbcmgAv
 kg8LSTbt
 unjT2yErtKUbQNeGxhng2gcxhRZ2RJHs36aRhE+JsbW0M5HZY5OLDZDhmOqjnkuRWKn99+SrZjeIAb55ucVDwm12AAUCzj+bYfMEYqOcuMa8FlsRCXDz8XxlaxqgIUeriINNldYUsv2VDrPkU4bVwBgEWoC5RKUVd/QPVpmbgDD9htGBsz+X6vhkRcIKHYglbeGbTwjRMpUbxnegV1B9Coo5yL0eqHiLwsFc11um+kEgZv+c0wZ3sekHoat2SoyWvp846fuMpS0JQDUFy5fEIuzoHougkhWKiDVGvlncjSMhQrTI4VXQLvcQlyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 10:21, Yeoreum Yun wrote:
>> On 11/2/26 15:07, Yeoreum Yun wrote:
>>>
>>> That's my preference too and we've discussed :)
>>> I'll repost with below unless anyone has any strong comment.
>>
>> Yes, best to wait a couple of days for people to catch up.
> 
> If there is no comments for prohibiting to set VM_HUGEPAGE for
> shadow stack as David's suggestion, I'll post with this on early next
> week.

Yes. Can you do me a favor and move the fix to #1

Also, I think we'll CC stable.

-- 
Cheers,

David

