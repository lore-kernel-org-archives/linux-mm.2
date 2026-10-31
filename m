Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9A6606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gHRZmNCY
Received: by kanga.kvack.org (Postfix)
	id BC64A6B05BC; Sat, 31 Oct 2026 05:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D546B05BD; Sat, 31 Oct 2026 05:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB43C6B05BE; Sat, 31 Oct 2026 05:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 808916B05BC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:29:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FB5712069B
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:29:12 +0000 (UTC)
X-FDA: 85382397744.19.8D7F099
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55E381C0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:29:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHRZmNCY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ll2fis6PW3e6O4+ywq8trqmNgeraIhRzhSrv/X2z4g0=;
	b=lYhvJR2p2XiuwluwvJdGPaHXmuZQDtSM3KdnLLEu35lN2dLmEKnprKVvd5sUzu3F7fg21q
	94IwHCpYyjp8Ua51EkoN05rjWugW//vgArYTlT3NewFQnHMig5I5nbtbxciY1v4GZ4+V/R
	+/ZC3tMn8YdSjby86+qvOwl+mFjxjMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438950;
	b=6s2UzC8NS4kpq4DeayGnuz5TZIeV8tqWAqAzPdLb09rkW0W5qo28gnAKQlz2FH4c0ZhAxf
	2k/sQbuDGEcqIsAMT3NBqXsSFyl9FKCXG+bHyq/olLp54uiWpZy2B2jnwZvv0KRfROUe+O
	W4hg+9QlVw9vP2dNoEdWtS2hNVf6Vg4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gHRZmNCY;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F02CD600D4;
	Sat, 31 Oct 2026 09:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA2A1F00919;
	Sat, 31 Oct 2026 09:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793438948;
	bh=ll2fis6PW3e6O4+ywq8trqmNgeraIhRzhSrv/X2z4g0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gHRZmNCYSYLpZ9UHoD4zM/HC7SGTVM0A+qag4isL8bPqhVyIKmMKxBwYQT/kurhLU
	 YX4Im7ICJiVFbQdXjxUm1jGIpb9SOovzJ75QNt/SEGA901F1JcUW6APRiOnIjH/HCC
	 +ttOQJloaaFWtPSM+g+SqBPso2zMPiqyjSHtv7cqV9Ikyax6g7vDG7OSYEatKBpZmA
	 1ZgClYcVbjTGH7ODF7ZiS7gVXb3tAV3KrkVcje7xbDH6dlhP5xEeUe9mkFlAR614yM
	 cnOW377XQtEtbpWyRBM4/9L3pb7HUxd0TF+eAaVJCD/wx+3adlIO7y5POMyH/klW2s
	 VEt7XUYwKd4VQ==
Message-ID: <895a3483-c773-4d5d-9760-c526c6cfb922@kernel.org>
Date: Sat, 31 Oct 2026 10:28:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 Tal Zussman <tz2294@columbia.edu>, Li Youhong <liyouhong@kylinos.cn>,
 stable@vger.kernel.org
References: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
 <20261030163553.c5dec200dd39cec4695e545c@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030163553.c5dec200dd39cec4695e545c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55E381C0005
X-Stat-Signature: 4kch435fsjam8seyba3upy8dro59x9us
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793438950-861572
X-HE-Meta: U2FsdGVkX1/PKuW+36Z2NLeK5dUkLsVCEhY1se/CeuSUpea191XGWOlF1q8qH1FYRod+Ch8nN8ATNJSoxStTzO/UHgCDFkGY85LIrAMQKJC5i6tcLNV94lpB26nDzNwRciZemLT4L4M5Kj7WtS08uppz7/wVCEjSlQag4J0wrNUxIQZwGKxkJeg9eOA9PQJTRUQfmZzjejygbDCLlNgadBRJrA5CE042DR6hRcpG9oCiiF5XjReBBrzXhNvJrgj2Ltr76YmzJbZsjJeYPoWtxrEZppAQ5EKAc5J5yu7v8/m7rpuwpcI44qdZaNKcpbVp4pp9Ycrt5miKRplvlWN/KuPhKTJVALd1tKMyPmBSRBhIt4DOj6ScWSaIOYelp6jFu0Sh92/Wj8Cn5TmkeZF0sXmAfE2od/1CjPsAxXVVr35aZgc9JKhryo3GXIpaCFMMVFrUJn9MMDE7mZ3No/Zn36u2Edn+W5qcmMqkYSox0Afc/0KwNXEVrB2Nz4ikPtSrnqkpFQZQm37tgvotHLz3HF/k4SZ8SC1frfffFV9oK1mdbVabs7DAnaUXsH+PLKN/PBlRxmz8O3SQh9CFb3oQLptILdaEhPwLKZ3wTfz/jnoteG8HTcKa3c1QRPP4vtbuw/TQy89qfaM+fZVbu6V4xQZ9haE/jMW3szrlG3oi8jL7qUWbupHuXGyi9Y1lI3f6pHtyItGGyc3acYI4zvGMzYR5uw2LiCA08yqlDmUoW1NBsV7UEKS1Cs/KR6BVumTIG6eWwYGB2BatN6qyiYBhkBV1VdXS+zhteOTRJmFTWsd2mDNVV88OBicwTvVJ5UoMyNb6xaN7PjoX6cRJIm0d5JJVxW9sZ0D+nLzbyhsSIeDGVyqHYO8/MH0cqknq3MnCEbYr2RLWa+F+mfZxExF1Y/XKFf34FxEFZM7jLEwvswV2PAFKAsc/fD2RJsaViPqGSZRLLJB0a6RWrtFcW7v
 F7w87I2f
 +tIwajDuVG+80bPzpyBGaxVkUThkd6gs3iNgjRI8FjgUKq7vs0AabAPkl2tn85Zh1smv6D+PMeznLGPDr0U1DxkiybGs4bih8lCr7rMY0KuwBNkib1coVubiVhx5ZN9obna7QD42f5hmywaqtI1j9D2Evmwr5YMZalyZYR2WA+ZgTJNoFBr2YEqvkbX2qRZ0sMQJ003uAQamC1+7ZllGP1+YR7quLSf4IbCFHYU8Tigk0xytGNUp6BiA3oo8X0KWH2cVxA06PB2JAWq42U+0QlASqrYgrFj2FDEJi3zYEaNr+F0jabtV/DbDwgKT/Le8CppVgPrwZl5zP34DhipE3oiLgP7r/ARvnLbIjg6Y9tr+fbmrJ+6cs6a2d6qEOytTGhBkAjWwivSGq5fIp3re+cCpaX8hI88UCf77j1cKOdV1i6yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 00:35, Andrew Morton wrote:
> On Fri, 30 Oct 2026 23:29:13 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> hwpoison code can end up calling min_order_for_split() without holding
>> the folio lock. There isn't really something that would prevent
>> concurrent folio split. Consequently folio->mapping can get set to
>> NULL after checking for "!folio->mapping", and if the compiler
>> reloads folio->mapping, mapping_min_folio_order() would try to
>> dereference NULL.
> 
> Bit confused here.  Is it referring to folios which end up outside EOF
> which split effectively truncates, or did it mean to say "truncate"?

I think above should say "There isn't really something that would prevent
concurrent truncation."

> 
> If the former, how is split able to folio_ref_freeze() a folio which
> hwpoison has grabbed a ref on?
> 
> IOW, is the race against split, or against truncate?

It's splitting (min_order_for_split() reading ->mapping) racing with truncate
(changing ->mapping).

Want to fix up the s/folio split/truncate/ when applying or want me to resend?

Thanks¡

-- 
Cheers,

David

