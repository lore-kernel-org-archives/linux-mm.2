Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD36C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 22:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F25B6B007B; Tue, 29 Jul 2025 18:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA526B0089; Tue, 29 Jul 2025 18:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307E66B008A; Tue, 29 Jul 2025 18:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23BFB6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:41:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB16C140236
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:41:24 +0000 (UTC)
X-FDA: 83718774888.24.AFFF444
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 59FD840002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:41:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753828883; a=rsa-sha256;
	cv=none;
	b=tAx0ZZmFD4UG/P9w1QIyvmnxZqRi7Ly6ZsinI2o6YgIY+HxTFBwLWK5/00/6g8DkeumVhV
	CfYojDIfOxHjGtxvpERwOPQI6AzD47O21ZtyqZhVl3lAes93htOVDh4YRh+l2XxrtFz+P7
	ahSmyV1hjRuRGfxhNJN9ejmBL31/iGA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of honggyu.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=honggyu.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753828883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kT/Ex2jTkUzsrEPekU4+War9rr1v+CRPz85T69gXYM=;
	b=EG7xup5ReYRcj2cjpuIi7PGa6omsYfwjWzNcrxQUNEcdY2PUx9Beh6Lrp2El8ZnJnYCxg0
	U3o4diEuFWY7vuiP4g4AuHQDwlmRhNPsawuyNhg5DDc+cMgOmSZWj0yzWgFBJVx+qX/hNE
	LdqSV382rcCBCJvnhSCyqUaZ/yTeEUg=
X-AuditID: a67dfc5b-681ff7000002311f-79-68894e0d6978
Message-ID: <dcbc29a1-fbaf-4e34-a5a5-64a7882c0013@sk.com>
Date: Wed, 30 Jul 2025 07:41:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kernel_team@skhynix.com, damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] docs/mm/damon/design: fix typo
To: Sang-Heon Jeon <ekffu200098@gmail.com>, sj@kernel.org
References: <20250729144414.31958-1-ekffu200098@gmail.com>
Content-Language: ko
From: Honggyu Kim <honggyu.kim@sk.com>
In-Reply-To: <20250729144414.31958-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsXC9ZZnkS6fX2eGweHfjBZP/v9mtTjxIsHi
	3pr/rBaHv75hcmDx2DnrLrvHplWdbB6bPk1i93ixeSZjAEsUl01Kak5mWWqRvl0CV8arhQkF
	W7grjs+awdbAOI2zi5GTQ0LARGLT7H4mGPvcsbuMXYwcHLwClhI/ZtWAhFkEVCWO/3jKDmLz
	CghKnJz5hAXEFhWQl7h/awZYnFnATeLq9XvsIK3CAsYS1xbGgpgiQFNu7zIGqRASsJJo/Led
	CaJaRGJ2ZxsziM0moCZx5eUksDingLXE0fO9UDVmEl1buxghbHmJ7W/nANVzAR05g03i8aEz
	jBAXS0ocXHGDZQKj4Cwk181CsmMWklmzkMxawMiyilEoM68sNzEzx0QvozIvs0IvOT93EyMw
	vJfV/onewfjpQvAhRgEORiUe3h0bOjKEWBPLiitzDzFKcDArifAWLG3LEOJNSaysSi3Kjy8q
	zUktPsQozcGiJM5r9K08RUggPbEkNTs1tSC1CCbLxMEp1cBozVfIvkq2Va42gZWpaGmM61W/
	2KVmrxXf1xf/+3SvPfGN6MvsJwtZduRfvyfBcb/v1twDKiWBgfNlWdN7PtV6JizO25N669eB
	fc8tzsc41rzn+/pOcf3ErPs9r+Qu7L9V4+DhUbruxfcdKcWV86qvn9QXfCf4nltr4vbCTYJX
	j3HV1uS35i5TYinOSDTUYi4qTgQAWTZcq2sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsXCNUNLT5fXrzPD4HKLicWT/79ZLU68SLA4
	PPckq8W9Nf9ZLQ5/fcPkwOqxc9Zddo9NqzrZPDZ9msTu8WLzTEaPxS8+MAWwRnHZpKTmZJal
	FunbJXBlvFqYULCFu+L4rBlsDYzTOLsYOTkkBEwkzh27y9jFyMHBK2Ap8WNWDUiYRUBV4viP
	p+wgNq+AoMTJmU9YQGxRAXmJ+7dmgMWZBdwkrl6/xw7SKixgLHFtYSyIKQI05fYuY5AKIQEr
	icZ/25kgqkUkZne2MYPYbAJqEldeTgKLcwpYSxw93wtVYybRtbWLEcKWl9j+dg7zBEa+WUiO
	mIVk1CwkLbOQtCxgZFnFKJKZV5abmJljqlecnVGZl1mhl5yfu4kRGKzLav9M3MH45bL7IUYB
	DkYlHt4dGzoyhFgTy4orcw8xSnAwK4nwFixtyxDiTUmsrEotyo8vKs1JLT7EKM3BoiTO6xWe
	miAkkJ5YkpqdmlqQWgSTZeLglGpgrGVh802Ya3/kE7/AGaZVScn2y+JFfI40ailJ2SdY+9st
	nXJEnVH2wlJnPeP4u98DgyJWtmmccmA876ewfY2Vo43y5kWlPB6sO19+r+RhKlttIyV5Wk90
	F5uGq/w+fSErvs3u3U5MjQv9Hqy+2btvUn/xomPOJfOcr4Xz/vz+/WXpurI3M+uVWIozEg21
	mIuKEwE9yXaZUgIAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 59FD840002
X-Stat-Signature: fani5sw59sqpwouymo7qd5m9e7de3hwb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753828882-973344
X-HE-Meta: U2FsdGVkX1/B/a9YPqcnCk3/s3NWK1X4Iu7R3HTzY4jZbxmNIhyhraN4aI5XQ4SCaN/pYAEyo5HCN9i/63yYcY/5522FEPHoa+j/YOqSxTntZdM1DoIpnuJHgG/OmitrTglC4ALjiqJBb2S3S/SGF+xYw0rGwsyJUGVQSC/FhXOb0DFKQnL1/QufDoU7DooJrvGrkmn1yCiOglMCM0/H1RmTCgOoIEDYGUpV48yF/9/Eow7DlyMP0h3VvDIAyZRXHwWhOOXN5v8YsFPYlwrZJgp+onZUXsCIFFkl6DtdUO5Tg4Lfq2aGiq+6HDA5t8RdqEbdJSyxUnntUN9wgugQ13vymv/X/LzjhOkNHhF8QZFaivEV3uAMi1lLLnhNKsc1krMLEoCUG68qHhC7BZgvCAW+rO5eQJ8GfXASah3pCTw3MUTrt2uRgrh0Lt70vJhhG58pDv65X77ZhV8tAHJzYZn9F5t6MzigJr1VyVQJm5DE2bAM886ZgKnXJOLVNVanW6jQWGe2nMk7r1mKdV3bZe7Ges2R+oLEm7pygnCrR4DPXjFGTDkg2LvjrwUGYxUhXYpvx0ehcLRKXou1OkvLC7yVixN98Vsd3iiKMe3ud3+aGN2jgoKPBxJp5g2PCy6gDv82Y+zHOKMPSXdS/cJ7njMrpLvDEgWHLl5YoeN4kgF8vl7dcQzugcWqS5AINcYGUCed4YVu0PUSBUT9QFbfDJvWKRafg6SN6NAx1DyKyW0eoFXmlOd7WKZZAtNY2Anih8elgRAw2Dh4I7psRAPkgC6T3GtXguw38h/zo4+VFiNXXBzuuNp+CciD9aJXliGDp/jjzrmnx+l6aFGhIBi3Q13zLzQK8qyxId1TfdiGkyg0b2gvTCW0gL4sOKP44PdAuxRBo8UyIPvPIIknT5uUzkrkcJyINhcqcJNYWoYGQeWC2oajH4l1z3Gid2RUgXDyocOgsuip6epP7fED0HI
 itWzi1BI
 xtK5e8ENxzeKXzsbXsO8SUL5CoZ0RXLi2kD2d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sang-Heon,

On 7/29/2025 11:44 PM, Sang-Heon Jeon wrote:
> There are some typo in statistics section of DAMON design docs
> - sz_trtied -> sz_tried
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> While studying about DAMON subsystem, I found some typos in docs.
> This is my first kernel patch. So if there are any mistakes, please let
> me know. I'll try to fix as soon as possible. Thanks for reviewing.

It's great to see you here again :)

> 
> ---
>   Documentation/mm/damon/design.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 03f8137256f5..2f6ba5c7f4c7 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -689,7 +689,7 @@ DAMOS accounts below statistics for each scheme, from the beginning of the
>   scheme's execution.
> 
>   - ``nr_tried``: Total number of regions that the scheme is tried to be applied.
> -- ``sz_trtied``: Total size of regions that the scheme is tried to be applied.
> +- ``sz_tried``: Total size of regions that the scheme is tried to be applied.
>   - ``sz_ops_filter_passed``: Total bytes that passed operations set
>     layer-handled DAMOS filters.
>   - ``nr_applied``: Total number of regions that the scheme is applied.
> --
> 2.43.0
> 
> 

Reviewed-by: Honggyu Kim <honggyu.kim@sk.com>

Thanks,
Honggyu

