Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C974FC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76C06B0095; Mon, 21 Sep 2026 06:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26CD6B00B9; Mon, 21 Sep 2026 06:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15866B00E1; Mon, 21 Sep 2026 06:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3C216B0095
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:35:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDD0F1C0210
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:02 +0000 (UTC)
X-FDA: 85237411644.14.DDA74F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD70A1A0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfrmaCFp;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8KXjch4NKKbC7ef7MxukElCsyctRkNt4j8KRmbVcQs=;
	b=pheqCWa1ArnJA/TG/v7bfZXs5arsqDAAkONqxBtFqVnXYIyVeJYTXXRkD7pbUBXP3nqRER
	VXFHnVup4sCesEFexkzlOWR6PqYyKZ0lkhtx7g3HFL/LvP0XxCYtgNCi7v/ztpfC48TFhv
	blbYc7rXnHvrgRVtqCnekFF9cziv6rY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986900;
	b=CZzUkDuAp1MCcZNgJZi+Sin/hiaaxVTypnD3KcniiByS00VXsnX5ZyO1L8oR+hDypsQjvR
	QYtEvIcuZNYn9zGWr+BiwJDGy0dXcPYBNSpS9voTFaLSb9gAzu1kShDLWOG3WaLgaLRftN
	Dyh+zbcAajTkRseK/iYOIpmHcYq99Ew=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kfrmaCFp;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5458C417B9;
	Mon, 21 Sep 2026 10:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466561F000FF;
	Mon, 21 Sep 2026 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789986899;
	bh=x8KXjch4NKKbC7ef7MxukElCsyctRkNt4j8KRmbVcQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kfrmaCFpTGdnE2iBeUj+IC8nbqeeFbOJoF0hShp/7cIKbBMyqLj2o3c0KFnctsuAv
	 QdAqxqCaGjUn0T7HTwG2TrF8+TGv1ftRZiR0GVgqabW2nhqqGDhgKqBCUowa5wBsYA
	 s89KAHOKUrYwRSUfVeAfNOv+yUOnNhXVLKkrBHHFc4jJ2rZG7Fzs4W3uFHFOM1oO4c
	 LOG8cDc/wBMUvZaLGPKJW7GsGdV2Ia3YT1yMhAyRiufyNwl8WvLQ2c1sGZ+/dQKels
	 jshtXAv83o8A1VfettpXbdGQhiAEXPb/yVCLcZwXj4GG6Xrp1ueKjEmiAcpQBLe3yS
	 ApsR8LouNLSPA==
Message-ID: <0baf8c5f-1327-4cb1-867c-e0b08085b9d3@kernel.org>
Date: Mon, 21 Sep 2026 12:34:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add CONFIG_SPARSEMEM_CLASSIC
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260920070406.95354-1-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260920070406.95354-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD70A1A0004
X-Stat-Signature: qnst6psmj4y1zmon9ee1xquz344tg6wn
X-Rspam-User: 
X-HE-Tag: 1789986900-259489
X-HE-Meta: U2FsdGVkX1+EX7kwmkVvTSrpSf0SSfFuUUA5f45VWzzIJGn72lrtwhQU0drmhmbGFVq6uXB3rqhh5yuITKExSAMb+GBY8/yJoxFrdRCZUZCt3TdSFk3Rmafrq1RCPdCGE4OPnnDXYD+Grh9jtwZAtB/IxrKIf3F5z0HcLHcWGubLC5MV0solBCcxAekPadj/kOwscbxQPn7fDRQCXPXH6CHRl0WpTyysPtmT2PidivSgmL1N/WXmnZawK/0jJT3cObyf4Tgeq9gYaUqOo8meo70h8u3etE3b00KQTM7/Hh8PdPB3Jy37jjaBADgFTu5b59ka2+RuYWfuxuOVO0x0PUlBLNoaSIcOX2RKjMp/mGCGfCeKCqh8pRuyaJhJvqr7ofTc4pC7Fgv5ZrlgRbrd5jMjn+TBadbeU/JIIJBOk3hZwLkNlGMF/7xHCC6y4yOgMJpT516n97dUPTroS3OTDmJmSZlWzf6osvPNUaPOOZF8duSPKKyyStKOulPzEWY3XCdARrW+hPZWwk64sdXdp2mjueiZngcY6Bx76jw5MvkqdpIv8R/Ga0zFwyLfooAz44v3YEqp7ss7R3fP+L8RJgZGGV5MlxL35/6R4pTDRB0L9NHZYOjreEE4E2e241BnvGxeCWv1rQ2L9YcJwmuEVUnYTmVTxTbyKZZJyzvYKEauL8Z+AKaZav5/WHopcH3y98rDzBFHW0eb7SP/Pvr3iTXY5qkwWI9TDuVlevb2f92e1tRWNtSV/p9nGpxl2Ukq9kZL/wVhP3KVLWxnzqZ72pqdZiGeAnaFIgpZvmCOSxQlZj5NOKoJ8m7wWDvVqroDJGhQpvbthI4Dscw3Pv2MXd0AYdZUWOBy6uFLOSFmwV/ewOviuwVC6HNj3Pz0fAo1BVRx2HoOeHmlU32rtUVTDB2QmwglWZDo2pFTswFOgiQMwXsBnf+OAqNq+CMripy4T7wxPLXQpRsIwRCM8ga
 oOAIgkXf
 zlz5oI4cgtYbplImrKqBQFaQaFwVYoFjaG93a5fT5Z+7ztnA6/+lM1+kJL6ZqX7yv/RYcsgXAH5PCkhCmGyLmkw7gUvvOjXpbg1x9KJSsdTH5rjQeuYtCXBj1YWv6CfNFpnQnlOLoA8C6JZHLuwGBOtyjldWWuNMGgE9sGzXRMmDGaMv1yKDvcJ1IBI7cgvqpCtVT+ivg04wZ89YXhhgH4WLRE9Ij1Xj9+NPlJ9xghFeYCyabAzH/I5Zg8OiOY41ZY4ZZOTbIiXHnTL8zHbJhN6OFesH8s7qfao98TnYzGZMZK4bgB9kcnJ71pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/26 09:04, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> Several MM paths identify classic sparse memory by testing
> CONFIG_SPARSEMEM while also testing that CONFIG_SPARSEMEM_VMEMMAP is
> disabled. Repeating the compound condition obscures the memory model being
> selected and requires the local SECTION_IN_PAGE_FLAGS alias for the same
> state.
> 
> Add CONFIG_SPARSEMEM_CLASSIC as a hidden derived option and use it at the
> conditional sites. Remove SECTION_IN_PAGE_FLAGS and test the new option
> directly.

Sorry, but reading CONFIG_SPARSEMEM_CLASSIC I would have no idea how it relates
to VMEMMAP.

CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP

is pretty clear in comparison.

-- 
Cheers,

David

