Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48855606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NU55q/eb
Received: by kanga.kvack.org (Postfix)
	id 555306B05E2; Tue, 10 Nov 2026 08:06:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504D86B05E4; Tue, 10 Nov 2026 08:06:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ACBE6B05E5; Tue, 10 Nov 2026 08:06:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 119E16B05E2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:06:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A13881A07A8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:06:40 +0000 (UTC)
X-FDA: 85419233760.23.98D0199
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7023A0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:06:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NU55q/eb";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315999;
	b=lER7NSdcmCw5a9WvImNGS7RfJduACiA9Hbu5dfB5LxGVjDTqzt1BtsYjlk8fqnFBTfgWa1
	jp4XXw/SQF3TZsSeioYcSG1vbgPjYGvlDJdia6/NtGTVr6aIrWU7y0R3Ce51dJF07CP54T
	L/DZll1wglbSWLbthceT0MAI+Pw/H+o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NU55q/eb";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pK3VqSg4+AHRpwPeJDStu8IPDFJWjmvhTQ7EFdoCBFI=;
	b=tIADBnS2V5Yv3+rRRkyfoXfUlIvjzsSxvBagIV4ACu1dokID7Ett8E7kj/TwXaBPYmGALG
	XaVxuaT7WoTPMbXRJr61tHIZXNty1wlj6yBo//aSnD2twMigmtuWM7EyqRuOXOFIuSy/LU
	MaJpLnXFFjeQhayJIHz5EQHiJPLHjkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A6BF45E47;
	Tue, 10 Nov 2026 13:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A701F008A6;
	Tue, 10 Nov 2026 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794315997;
	bh=pK3VqSg4+AHRpwPeJDStu8IPDFJWjmvhTQ7EFdoCBFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NU55q/ebrSoPO0qK/eDjxfhlUabcj1z7A2K4fdJ6Ze+P1hzNcD5RAeiuTQ5FO70b9
	 3u88yzwzdOIOnM2d1uZDr0DPMejxdwfclnifYqLhDXsJ18TeyqgjxT2AgX6SdoczTA
	 NPvAQ3zhsNAEsMKu03ieBTkG3jY0mUrsa0pf/X2fJO7SwkfZ/D2XeYbiJEw56YPa/Y
	 iPhjXFYqoJU2gsASwx87ubQWCKhDzhWmEN9mg0yEZI4VZyzaOklsm/vXPW6FcN2IWy
	 3GRLwJUnjn6X6GE2IskbREYdSAgo1ZkY35cAzgObl0rDwzvL+2DkKiFaZCMNBCf/z/
	 PshgKYBHYFF7w==
Message-ID: <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
Date: Tue, 10 Nov 2026 14:04:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avLqwIWHa5CAbHO2@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7023A0009
X-Stat-Signature: hcerah4qsq9jzjzosyr1t7n3wyukrjw9
X-Rspam-User: 
X-HE-Tag: 1794315998-85680
X-HE-Meta: U2FsdGVkX18PqZdu9aJouIcI1Jv7UjLFMXrt+nLkvd2P40WazEtfZxOtDvvHhX0kf2yLPsBkLhRcFn4g2N3+oHRFNZLmyWpZDXTPiUg+YhxBtv6KcL8J61DOHImvQl+hFHH38MN4+zvxI6Vy1gu4Hwo4WFcSU/sv6PAC1D6TW0l6nOeI5dmbx0MBaKMUvDGMpMIteoNTdv601+a1PqEutntJYiIKZoHq6LCdc+fW2pN+Jnqa2/CFuwVqW4AIMFJvH835KH8D5XzdQWS5kZ2n5VbpPe1XOv+D30pAo5+OcplfWDBQXmvDDsOAUTXmVS1sM/nJLSf2Goa890h83z+95sD5YSvo+yb7Ko9j54Pv+JZ0UBS/DiASvNdkg7BOVwiG/yGmm5cd5EXkvz9CPVuZXWCvlxpDkREYscAy7EofsYHKs44Gy+oRLRfmLNorEFl/B8WaEP3kWvUsRzyKxevg2VCc5i5xPiCh0eoC7dNUCwhFx3/HEsWopkAclLDIOqFMXl5dP0yynkFs6OJYHwedZ7P/H1AO7YlvfzvFJ0PYnxvnc506itK6wrKMK2vM3l7oAkRlNktNEwmc6FT4QpENLZb0BJMK5dwGQT+YtQX2sJYB37ZyUEHSZPue0nMRJuUMo9/OwLJuTOerM01DYypAoRP38ZydX6dXyMdrC7KrnYVUZbC/s1qcKlQgNn0fHrEEvAJ1XC2Bo0n+XtLVDTNEEazZmKop9HuqqV58ovPvSefIDweL/D1W0GcsSYbMBLrX2o7kS6BPmq7GLnVI1cTh+bgkUY4tWZgH5J7oK9XdZQADMylFLpPqgPgEzGDh5POhZHKcyZ7u0Blt+7LPo26ejNqbbsrA7Mv+pCQ8Nvz3siDe4b1gH7E/s1+qli2pElpdOs+odSDmKjupsu70vDNojhd8R3toFpSOKNNlLNsUQPdQidGNJF7leboDvHcs6KNlUzD/HUhgZV+3V2Gqj4Y
 Sy7k8FwX
 BG/Ch+BnnHeqKm0yD9SKN4s2O/emx1DQ750spWoEUZZ66zO/j5Pj7Q+YJldcaAD9BGToXWJ/PFlJccyWMkW31nvGGiTHPI3gvWkENqbmY3eLlz9NFaFf0WhcyORaVs9U7re2GiqEvDU7YYR+Ut2WkGYh/H8qkbavwtZXZSlRA1CNcjB1+KLotF1rZu1ktUIBD1fe0V58dIg2PFNOaiUt7MlM5DqTz7PRXj7p/6feQT6O3IxnJ96p3tqujNZT9gg+glo9bVIBwX7x/iuH7FJp4kKUYQX6pUdEWYPA4cefCWERpbONVCC4sGo0ZJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 10:58, Yeoreum Yun wrote:
> Hi Rik,
> 
>> On Mon, 2026-11-09 at 12:32 +0000, Yeoreum Yun wrote:
>>> This is preparatory patch to make gup_fast_pte_range() batchable.
>>>
>>> Introduce gup_unshared_pages() to count consecutive pages within a
>>> folio
>>> that do not require unsharing, and use it to implement
>>> gup_must_unshare().
>>>
>> Could gup_exclusive_pages() be a better name?
> 
> Yes. This seems much better for me. I'll change it in next-spin.

Not quite the right semantics. For pagecache folios we simply don't need
unsharing in MAP_SHARED VMAs. That does not imply that these are exclusive.

So it's all about "number of pages that don't need unsharing".

Any idea for a fitting name ? :)

-- 
Cheers,

David

