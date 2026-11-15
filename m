Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2A8606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F90J8gnC
Received: by kanga.kvack.org (Postfix)
	id 1FEFD6B00EF; Sun, 15 Nov 2026 15:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B05F6B05EA; Sun, 15 Nov 2026 15:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5FA6B05EB; Sun, 15 Nov 2026 15:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCA916B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:34:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61F6C1A0828
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:34:34 +0000 (UTC)
X-FDA: 85438506468.17.3E99222
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D4E2A120005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:34:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F90J8gnC;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774872;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqQj+LhXy/HJqK5qflQTdS7lc9yLAalOfiG+XBv5rgM=;
	b=y4K7VxUljD4UrObyJxoA6HDQxY/RqB8vUwim86PT88o7NessX2EWJwWuBw0KWHqLoAnAGl
	eILEQBPQKSKKXFlUc3XYB4wnquMc9SpRRDACX/CURINtH3Xi0EitXALgmYWgTTDYLZsS42
	ldM3B3s2SWSl/Nt1RxkT6AxUnUo8V9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774872;
	b=G/2rpKPc3bPXJoIomgr9sQYhsf1mqkpVFiLa/cs6NgIdvv8FUCNdOtxlh0hdgB4HVnz0Sk
	gO5LPhqMUaxs6/lSqxoPJsXOtHEoLMUAXP0lWTlQMbugjCsjWconXvvZlgNyU/gO3nP0pe
	V1dDDDC1SQIMa3i7T7yDW+5Y+bkT+ss=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F90J8gnC;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65A1561DF2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70341F000C9;
	Sun, 15 Nov 2026 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774872;
	bh=EqQj+LhXy/HJqK5qflQTdS7lc9yLAalOfiG+XBv5rgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F90J8gnC8Eq5vPmXRXyEAwOd0lCVJlYzY/zGcwhzULyN//yZ9xN4iVaKPxv3by8YT
	 o5sA2X6j4UTM0OOGDLaK5TzsOYQ5m6HW+7ROK3J5fuC0zuhFZFljKv2qr6JMYqxe2K
	 2imArWHhHD3iIlylo5JYgGsmcY3FRVFnCkG04KAWzZAor7tdq4SB/+v3b1R5JwUS17
	 66eXkMgSIPOYxD6HuEuNwK+SuvGQEzMnGdFX00BQ5fduG3Rr2bPA//BiW+lzGYcfqC
	 8dm4LxopjhnFMRG02VMcuh/HKCxVQ6S+nEAOmYDsJZ7Dw5gboe/oNYabrd8vX7s8W9
	 8qbm2f91yY7Jg==
Message-ID: <sashiko-outbox-215838@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 01/27] mm/damon/api: introduce struct damon_report
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261115202849.99134-2-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
 <20261115202849.99134-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 20:34:31 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9tpbjzb9hjiqnq4b7ret4unmduepxu4d
X-Rspamd-Queue-Id: D4E2A120005
X-Rspam-User: 
X-HE-Tag: 1794774872-216306
X-HE-Meta: U2FsdGVkX19allqofU6BRoVvJujf7WCstdaFi2WZH3g5YX8xNYjsCEWQw9ByvhL8Vz/c4pNkzGHKGON36QDba66AyyqumYV1YlKefrBQkNHKIS2RbB4u1UhPQiQ2CwCLJkKdRtlOZq2tcq7qHJmIO5VKx82aOFa7BOXA0zS4mVHbokxv8QlI0rNWiOCUgo89NI3lh94fxw7tVTmDTB3tPLnUFdmTCJs2RgKzB/Mg+FL3uG6JCUk+BtqePhu76tTA72oWS4of1KtsBcKubuV9gA9eClHrtcdFXO35p+vrUV8KoHRoeIVO0W8AyvXmKMRb9Mx6tqkhIYTOs2KNZa3C9J7m2U7QwL+JW7JcThQ1/93VN0r3SL1W0EA3yBACLPlbMr1J5C11PnmzP3CTgNKfUc/Z1ZJG6Gb9IpRyfXpkCxxtzoJaiRt/U8CkVrC53BTMfAvrKp5BgaIWEHVj8NmJawhV9ijIBhoBKUKoKVHS5AYKaYjn1Ll/UbAPyDHP4eaA3poDONaQdurn8xbjoKTz9Ju0SgZ4a97Uc0+n+PG08rSYKsZwECSuCx9zONdJV/BigaPOFg+A7vt0dHTAbW6NgncrCSVwCPpSFP5c6k3udW93qekpXg/66p2Eo/jnF4p6ucLOykea7McWo+eFfpIZAm22ubita95SDxBJ9p34Sn+ENaNKsjccOEP16soxxDuTO4E8Ax4QwRtHroJZtVxVWiSKo9EcsU3I116wbngkiSwLdHu0JQcARP6SMpCtTImRgizRgScPS/gfgVwSe2y6YmcZrn3TGhQ7suHiE4d2K1OtjyjSe8j8yaMISg1Oey8fce0TJIc6VqkYFz3R31JEf+BbKgtGL7jTT04FcoCrSY6nps15Nb0kHHeQdh1SCII6LHKTO1xxlXxx+PljTiWyCAdpzyWkt2t6sj/1By4vO4sabZjehYRU/5sNgtlJdE0z9CBuJtx+1pPuT4UIjoI
 uT+yywTq
 zJIrP14btE+KcRi7yIi3uqhu2Z/wMYTYYtjBKZ0vQ43EiAXr2bdfnuKVR1BxR0dTs7hiMJv1VegOPEvAXkM+OLwCZAlIRM8SEpQLaI77aIxSSoZl+fbjTLb0fgQ9M3QU1wPPlF/2T+Yc+QeOxvFoqKJtb3UQm/yc3D67eZdERJ940pLDKyRyK/mL22RyZTsiJgEUg3/KWlQEhEESNvYxojTT2Z6xruBNawwGukWPAhCP98P6Bh7MgNHsk/3zfabB9jCeCHIb+0bQpbmP0c6rhX6BMXTNM1SYqUzv9oomRBd0bJLBMHMHl95OWcN8fb3iFCb+N0kJLW0g73oDOHmYVmeEAQ6LdldPu8G7el7AUd5/1FQxObA61rIWqpkLql2QN+gGoFOBCTgo74aDJnvuzK8/XxHZmDUJ1bzfiFHw9XGt0mjrLpiKvtqwPeystALdV3KdJq55I5mJhEnr2k5ypmll/CmR9Mus7PiAI0i90V5zXxNSR8QGV4e7UZXs56ZlTM0ihzGzXhp8yntn76zgCDWc5Cyrvq42B4FmyFTkewPJrd8e0UbBnSOIEhk2NhdRyuJLbvnupBOqxvwl5iS64uggZxtkvMyO6rkRG0aONCE1PQEdNMM9q3KWX9Id32/kGDaOesff1VuumkqcMg6i/GrJtICubf4dP/1BVOUsb+p/et3XYfy5olmbp3kfl1NZguSMfZT3nwsL3eFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/damon: nonexistent fields in struct damon_report kernel-doc
  comment
--

commit 919e8293a0141a206eb1e31c857deac8b6249a6d
Author: SJ Park <sj@kernel.org>

mm/damon/api: introduce struct damon_report

This commit defines enum damon_report_type and struct damon_report to
represent data attribute reports.

> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 06bd92981af21..5c32ddebf4625 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -751,6 +751,29 @@ struct damon_intervals_goal {
>  	unsigned long max_sample_us;
>  };
> =20
> +/**
> + * enum damon_report_type - Type of &struct damon_report.
> + */
> +enum damon_report_type {
> +	NR_DAMON_REPORT_TYPES,
> +};
> +
> +/**
> + * struct damon_report - Data attribute report information.
> + *
> + * @type:	Type of the report.
> + * @addr_range:	The address range of the memory to report for.
> + *
> + * Note that the @start_addr and @end_adr represents an end-open range.
> + */
> +struct damon_report {
> +	enum damon_report_type type;
> +	struct damon_addr_range addr_range;

[Severity: Low]
The kernel-doc comment refers to @start_addr and @end_adr (with a typo in
"end_adr"), but struct damon_report embeds @addr_range (a struct
damon_addr_range with @start and @end fields) rather than defining those
fields directly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115202849.9913=
4-1-sj@kernel.org?part=3D1

