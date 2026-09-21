Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C38C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEE66B00DF; Mon, 21 Sep 2026 11:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5AA6B00E1; Mon, 21 Sep 2026 11:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB496B00E2; Mon, 21 Sep 2026 11:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBEF6B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:32:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D54D4A0219
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:32:04 +0000 (UTC)
X-FDA: 85238160168.23.75B4A2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 066DC1C0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:32:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PBMnD//m";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004723;
	b=wnHM9Z1tW6tBFdBcCWFgqDZyuplfOK2UrzU2CkHyKSjKLKbIZNkEfgVEQQiTGujH/aBo3n
	e1MkvhA6IYi8p8Tvlini+LMFCR0PJHX1d4VH0MeF2T24q+mIEAQQlU89S92EmGqQ4KQKEZ
	rXaInLTdHVUn8i/FIk2IqKhvjvagv4k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PBMnD//m";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Xkowsa2yFq1oP2Gf4FeRryPZ9BRFkiL4/i+iNDUq40=;
	b=1rsT5YoY/NQ7QiYhHRlngBJZyAuGp64E4Wcq8mqwGJWfy1crsFFNFXftYV8YFWXsi6Sm+q
	lVxFtgaR74if9wkZdZGCE57vZvd+i0QZ1aBAbDxbHobJCtE2UyekpTTStyO+4qzBSTfrIP
	D6tZuV6ALPtMZ5kT3oUts1BYyNgAmA4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CC784362B;
	Mon, 21 Sep 2026 15:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC211F000FF;
	Mon, 21 Sep 2026 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004722;
	bh=+Xkowsa2yFq1oP2Gf4FeRryPZ9BRFkiL4/i+iNDUq40=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PBMnD//mWpAl56A6hSWB95/JUorzxJ7Jc+oWq0Np0UthWaZnzOC+qkKHg6SEC7KZ5
	 xDNfMdcXdDRwVhUpE8cwtCjMPEVNdEOepf9mklyufIb39JCHSBxvZqRhAwDVJgZor7
	 uMixfzhkspgi+NnDN0frJeWczG7EO97cHicFqJr1uM7DI8wvu2R0UjifzFPVB/5nbV
	 Pt20htIhGkyZyIgHps/qACpv8z+yHFLjoL3ZyICPRkd7NIG3JaQUqIxJZ+ps0QA/1d
	 W737KK51AGzPicSLYgxsKDv69yNNsQYfyQZHn9it/O3DMLxfc+Cjl/TX/Udk78/O6B
	 CZfJsvZMILu+g==
Message-ID: <8b1e9356-527e-446d-afd8-0ad3c4edfcaa@kernel.org>
Date: Mon, 21 Sep 2026 17:31:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] kselftest: mm: introduce size_to_shift() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
 <20260921-fix_hpage_macro-v4-3-cdea4fc6ce3f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921-fix_hpage_macro-v4-3-cdea4fc6ce3f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 066DC1C0009
X-Rspam-User: 
X-Stat-Signature: 9io96kpf3sxuz5cxugkm5xzpjegxi4je
X-HE-Tag: 1790004722-177699
X-HE-Meta: U2FsdGVkX18Oj9CK0jRWr/Nf66t14j7HjFK2NXDqJKfSATZs7DkDmBW8Ni8Mq5veQFbmofB2gjttuHUtPEBQYr35D/IrrV4gbDZs2VFVun9Q8zG/5jabAUg873H1vWB93aaCkFxa74Vf8+X5VERvfWlDvjXTyuxuHRNadXEAFNcyoJFvC/8/cCknY5vSTs9y/P/8TahB9gqk9fmRRVRK+/AbCo+T7BsL9GbL+eB5oNcwofCPUgWttPslNkZYsCr9jULhtcwTbY+l1Cp+aV/+OkvIgGt84k44BIsqBzqxouLCud4LXhz3yHSX3IuRE/RfGrVp0Et0yUqEt01hs37P+WR8VB2KE4BzDAdBSJSmCZLrEKy8tXpDa5egsT+rFDiHANH0cn5pViEnUbd7FqcGbPmiOwQ0h/jy4D5UxLWjzAup6wKfFygiOtpT1f/wmZpqExAFRleHYUgTIhpx+rNeQl3IRnozs8H4p+naV5uHwHCRdUOw0XCaUgk0FH+QFwmWIqv0qwzUrav0J6nZmqWRGR0eqhS0cQn36u9ylZXmE3alu0iemPbG4VJxKgLPwPunPMEknZqxAis16ltxCYAArdwdgDrTxXTCruDr7Mz65RDsqeJ1h//azSFD2AP67ZR5U2mKP8kI3jDgwzKIX7QJwPSi9NWRlBrp3AGDnNTHtNKwVd313ejpj9nAH8PUbcAHddLVzHj0tPpcjrhY9JcEXIJ6tp2NNWg9+SBVt1URnlv2JBDpivgTIXZFGfn8g0DfHFmwW1mRjIvLdoiDbm+yL1bzgu32o+p5kNHtmrynpixtdu8nzENUXvniyxSk1/8tLXzerdFd6UdHMLioYLxUwZ8+AKdfwEwCbDgGmaleSBmRfzqJSY/GZJLLS5p25MasOY+3xjpdQnJ2kHFPJQ4bumVI0WPZuq5drtOkwAFQQRLMt9l5Qyz+mc/Gc5r4RuyDTmaIU6nRrMESv+2n80h
 3lxd6HLe
 xAvEKlVxEwyrrIB1hnRcorl1EU1gDKRQOSNUuHZTMK4xbMOWW5POcd8tiLztIvxpgQGk8iaLvNL7Aw/UtplobysEEfvYynw5T2BcIMW6OX9VxTypNanbtvysdKGBnmFaheNRY9vf/BmgWmGVdzAN7IvbiQfRlFeWzQxm9fjUDIm7yj8jSfber+kYXRqJhCv1r141yQgk3r5xXXzWh0HVXOe8mGx1yJwgdUN/qCK5xM3JNfRIXac/ssRWp20y99OYlTGeemUMVP0pE7eA9X20y+G+V8ZYglkbCAwzhk0JUXvqHSvwUZxdr6avSIYOUwyJ+Sbw7B4zZle0VIQVZsP5CTpIcJFf1ycIh3veH1dSOWzeAY/aY8oGBcwWvem5K5jiDKenYJaJocHqVBx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 12:36, Yeoreum Yun wrote:
> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

