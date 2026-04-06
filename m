Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73FBF46C5A
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1456B009B; Mon,  6 Apr 2026 12:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852706B009D; Mon,  6 Apr 2026 12:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7681D6B00A0; Mon,  6 Apr 2026 12:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61D4C6B009B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:49:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96490B9998
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:49:20 +0000 (UTC)
X-FDA: 84628716480.15.121FBAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C86151C0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:49:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjVk2u+O;
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775494158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrdWgK5OwzfdpV71hwY4tqcg6YFPTo9zcE4qZLZGo40=;
	b=TkR8F8hJXl4ZKEJC1dJRBVnPAsjeuD2jZ5XQ5EmoLqAHtJr20yH+LOvUNIkSVGmtqlbP33
	P9eluyfUYjh3khfekeI6iyxB1Vs30rhdQLACNMjP/yXFEGrGFqAIx+zs9V57syp+N5EzB5
	4VYWoY5SMSL8BXFz2uJqethR3ZwXiM8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjVk2u+O;
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775494158; a=rsa-sha256;
	cv=none;
	b=OyPFvsGIQWpDH+FrV53UWqjtkE1RtmqPTR4hcKZ/femgFReYUGSz8qUL5LB2APVyMxi8/e
	ma0j6U23SRCJQAVbHODWDzfto5KBBx7p5KNLtUy3rlvU6InOOj4D5nUoLLbWYukKSlg4Ha
	Nwv1g6fH7nSjmgk7IwgCTGJz/drJ4Vs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4F8A44217;
	Mon,  6 Apr 2026 16:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550FAC4CEF7;
	Mon,  6 Apr 2026 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775494157;
	bh=+h31anjlodIqSrDMTRCd87rH7VyvUE2n7uNwU5IzmM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjVk2u+OWCwejllUeeBb6pwZNUHHx905UrJoE1QX/OeCBU28l9f5TdMa5J19E4BZl
	 bSvNwybC/eVt++qKsBUQyDaEhKvsrf5d/bPofs5DHIolf3Yl29flNJVSUmbXITy7E/
	 JcE3EbEmem1Bo5W+E3fm7zQAwGt9zOk/L+Z7jbMyPwoYUX1sMFyCpFoJ8vALsEbHXV
	 PYqrvC88cou4AsfNPze29nqsYX9JsMI+Dc+nVNbEnJRvlWMFUbY82e7yAMLzwHfidj
	 7+A5R3ml0dK2vN00vP5uG8Hx7ERFpCYf6+qoilzie6e8aW+8LMC1pnJ4pvPJvFTkUA
	 P7+eA7VD5MUqw==
Date: Mon, 6 Apr 2026 17:49:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 12/53] selftests/mm: khugepaged: group tests in an array
Message-ID: <b3daea31-dee3-4d64-b0a8-4773176d1876@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-13-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="aOUOKEiGsonxJhzu"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-13-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspam-User: 
X-Stat-Signature: uc6jix7zckowa3dpu67rb8rnwstdwuhd
X-Rspamd-Queue-Id: C86151C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775494158-741347
X-HE-Meta: U2FsdGVkX1+kXU4Ki4WLMCLga72k1v02wUYObt3jntur5ccdjmUtmhPcjRELo3XFQQLgeyEy6TP3PLHkfSi/9VukTUzZzeegYbRVvD2D+pC35sX9gDAD0gaLhd4k2zYmkXFaZTs9+HidDIm6Bx9j4eVZA1Y2vozJ30LebY0wx+u6+6IB1djZOgJgD9KPswoKoIF763P92IZWSi+W6XO1VADcwUaTIfm4B1FO8bdR2gVSFdrYPnYZx7A4WJ/sI3qyRgsS904w9kQhYfU5ve4gTexg9HnO0+KIwADUibn0OQecXfAjLGoUHB+DSBqco4XoEg8JfSKwFsn85agtSke71eMsdEbged/52WXNShNDM6FLCnhIovlLTMaWMU0y7+/wb/zQ6NL/rjIM07i6U6L+Hi1/JYGAxO9okSsZ6SrRVHiK7vKp+trNTAe2mlrD8Z+07PRDtGGkaaH9d09qdt+7XF2htdND3scJKUJ58i54uZ71qoVItkXirIQA8fYwSPoCQkQGt6Yu7i50q2MrBuA9vqWpHFUJJItShE2u/cCnlYGwHIVoxv+zifnjFnxCH8LDoCXs+SgT1IYf9aFCHb1CYdHedXX2eKxAFTz+kFqtXAyUd8Ee8RdIxOrZbcMrQYyUTtBWutDykqPv7QD5B7qBlpQeqT4yKQurF1eOS9rLoUGZruMGxqhSui/b5C0BA6FAaaLIdSQQQoqT9w5K0bGR3KDDyeTO1AefC0wGD0R0mDjiCpvvNwARrCRkawLgZ1WK6rBqxtrHDy7/jsn0CDwhKkbcPQVNipUE76wRMB5bAl5/yJlqTNODe9zGcrK1kAv0U7E8p1wRXIY/3qgH9O3Iay1LJtB7LTIgQue5dpgD5wFfUb5N4xGw2nC96FmMCezY2dgBJGdVKwmyxUNiIMhvEfDqZOUpG28+v4bs8/QDxxEo5hDZG0v4TQ0KHJRezOai77OkqVfveQuebhx9vt8
 EEz4eb6a
 VpEWeeS0tS1/HFzDmh7ChyMuHb9OVmK6oYjrtHyzvESskhU4PXu5NV+9YyMVZNEDNTsMcbofpp/2SU6tKDnBBK0HLphL6AoIsssBkgUDNlMlHBv/l8qvAwOat0NhCCBaYYDLch6LsYH7gpJX/RfhcxT671dFOD2s9IMf0+IKjvphFaSV6jqL0ZitubA6cK1cSkhwNbLHUNFsD7rT5aM2RHPbym0/iESzPeJ6fKbfxY4pxGxwAxdXpTMuR/ejWJ2UY/TCwfGlrnvG71GZ2gNScTxQ6IISKiX/nzOnH1uGs7HFX7xC9nLBEH3DgHDusah/NsEaFp/iI+GuRp5n25OYaYIqyrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--aOUOKEiGsonxJhzu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:16:54PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

> Currently khugepaged decides if a test can run using TEST() macro that
> checks what mem_ops and collapse_context are set by the command line
> arguments.

> For better compatibility with ksefltest framework, add an array of 'struct
> test_case's and redefine TEST() macro to conditionally add enabled tests to
> that array.

It would feel more idiomatic to skip rather than ignore the tests but
both approaches work in the end.

> +	for (int i = 0; i < nr_test_cases; i++) {
> +		struct test_case *t = &test_cases[i];
> +
> +		exit_status = KSFT_PASS;
> +		printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
> +		t->fn(t->ctx, t->ops);
> +	}

The exit_status handling here is a bit weird but it looks like the test
is a bit weird and I didn't spend time figuring out what the best thing
is.

--aOUOKEiGsonxJhzu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnT5AUACgkQJNaLcl1U
h9Cq9Af/dIK2L+v6qUAFbxJCAZR90rEcaCia+4anZY3gyTO6tjSdXHJ26yxvhloX
K6bIZYgkLOp3VBdsY1eq8S4/yVYtAj0iAPMO+RBmqkDKodQSHj5vvxLTUCiqBuV1
0GWitlqeH65RC1qzeEnHgLIfhjhKNtrbPwGh4NTVTZ1cXcmfS+2/kJFH7OXOSaRJ
SuVIzRFlzkUmQZ4VfrK8d9UlK01C+9u4H/gVbVptGrao0TuOfokKgUY9ZsmZFX+n
+Gddk1kqoJJLq/T5w5lPHjG6mUXcq0/+VzErROCHQoWXKt23zf3TPNkWuhTT5mtU
Tj64uVWDhPRnHkupoctQiTPBo62yzg==
=0Jkt
-----END PGP SIGNATURE-----

--aOUOKEiGsonxJhzu--

