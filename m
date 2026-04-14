Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D12AF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535B56B0095; Tue, 14 Apr 2026 12:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D346B0099; Tue, 14 Apr 2026 12:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC756B009B; Tue, 14 Apr 2026 12:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 306566B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:02:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DEFA9B6512
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:02 +0000 (UTC)
X-FDA: 84657627684.25.E75AF93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AB99180010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvVB5+61;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776182521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbEj2LyVUNA8gQFTEt6qKvvcK4iFWJz9TIb6m2XBAqk=;
	b=pxrRO/8MkMFvh1nn87/S/XhHNsSaph2lIQqQBS0cBZRrBt9I5MqjT+dU4lIxjzcc4ZCoMy
	AYlnx/6C+w9DXsVI467JK2fUySm3fjeXYO/OuAdyRgyHgIcKQ9WrHRvf9Al7p5AiluHXPx
	QIixK6QXHzwLNekkuAV6D6YBTkugpuQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvVB5+61;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776182521; a=rsa-sha256;
	cv=none;
	b=BpibEarlqigjfCx7sYPOWu6GgnoR/xuu91amI1CIuqC2DGgRmeoGnqS7E5EOeILcLrsAJb
	s11GeyYJVXkj+ODG5r1kdWVoIIbb4CWYaLWGHOJVJCpbG7/+HLdrwyQzrGTD1tLEVChcJ0
	9rLXupyU7ICTLlN356q3sdjTwaVZ78A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8578F600AE;
	Tue, 14 Apr 2026 16:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD26C19425;
	Tue, 14 Apr 2026 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776182520;
	bh=G6aj/wFjZndGjV7ENj1/lu2f0AQQk8e3wnWoyQBrrnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KvVB5+612x88340ZgClvhkj5uO5DaLDgzWKqI9IpbZQgs564ILoKeDhoot+qaZnpc
	 6l5JhLTfhW8v8AmpW4SQqRcnU2HubQCO8j7Tn6risvDuvfXAPw2M00KTjc/J9qRUc0
	 jH4z+7i3AK9sih4Wu/BfBkN5Gw9jrA/PMpQ1AufxlMAAEw6+NRGVqBeKVHzQQPxm7W
	 ukleHFR4okrRNtBEtPVOFNpb/ANLtfz40psL+rBYdQQCP/MjGKw+QddAusYnAjZwk0
	 ecLJufohiWDvt4LDd8NerHXP9e+NU7ZStfh6zObDPeKKW5PoJpSZc1z1BeHHyBns8N
	 eEe+caeu40OXg==
Date: Tue, 14 Apr 2026 19:01:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 14/53] selftests/mm: ksm_tests: use kselftest framework
Message-ID: <ad5k7-wmYc77sC8E@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-15-rppt@kernel.org>
 <b49e883b-d666-49cb-bf4d-c83a8d92a0fe@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b49e883b-d666-49cb-bf4d-c83a8d92a0fe@linux.ibm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AB99180010
X-Stat-Signature: kqzucrj1p9ctr8uncrdnu9sy7ndg7d7z
X-Rspam-User: 
X-HE-Tag: 1776182521-133858
X-HE-Meta: U2FsdGVkX18SDe2Dt/9UnjagQj3ZxfZTjUGkMznNp9st/8l0dz2qRymA87AbIBNVVpnmT6LaMmJX3V42mNuigtqisUmVnJxpYGWgefGsEBISaUNUEKMmzMbvbDiJupGRu3RdhiMgEpbZdAQ99qvCHJjcXht0pU2FO9c9GON5iBRBzGZw4GCEvDtfoN5cKeqk40kOcNrrh0OgEd7wOMPWpB+WO4tdjbYbp4CkjKvVALU2bcexurAE+8gC2/TOjg6oFo+Cy95akF4sA0sOYcGX9gRptpFKEeIySYkawbACrINiFv9YyWfSy2JeOzwTR5fLKHrylkw0bI1UfLBhgzGG5w7dXY7xrMmnPzELkzGdciNTIfSwuQRWJS2yVb6D1RNCBsgkEav8SzTompCIyvb4fG4mAXnfBTdQ8hFfBoHMAV4N7YRZsFe8AZJbpzDronGVUw0dMRq1o4dmyq/Fd8eEVNjEcKh0q8p/z+3lZYGKmmAvQEQfOU1Sdg0V3683VBD5u0P24qJzmRWG61JoGOnByZQJTWvrV/XkJG4v2vtVNkMTwDbtsCC6vr4/QPFBXDS9Lw3201+I9rO4bFWYnz8V/bLlJFkjMo4k5vpkDYHno3Bx6+3OMuGchU2grj/BcNdfQ5gi6LV6l3v/eF4M0YrKEJ/Xvw2pyu33AyF8NJh9z/z5OJ2wtv9tinev35UffwJdoaoWgGHcZgQLsA2s87T5yz2+W8Nva5NP5Xy2w64kYpcyHmp2q3dtnWeAx5iNvKXvlqxs3+G/KKNReFgdF5FjRf4xjzbMX3Z/R2G4qTV+K6d3zQZ+5z25WO9yvPldtpaEkKlwUv8uK4vEwXt5DdJu2SKizVekwWKsNoD6j8EUyAUqxxS/eiWPY4kwjBjCvgtdmA66Q74SX0U2ogwVnCtwsIxXEXva9ajGZKn3v+nYz3gg5GKZpdLRTBzvSb46N3Vtb/Mjx3TSny+k3h8lO9q
 zAOzz1lS
 95QtZp+nKP3uxpxNJzBjLbOLxhjRKq7fzGRCIcandLAb5oCZHgncGsxlbJcXIR9wZ879GZiOGCQmW74pB9B+GRNyXh0XPxONnazTxekyuwKI5gHeu/xq2pdx5UBomeOj2B+ryCHr01hIBgVluYxVcf0GTKwh0jEu5BlOzmcAXd4uyjaXvsX1q7cdo0QKLgWwdUvWRxzSxL0CAM/X2eIR/F5Ha7OO6OWhm3Zm2zIhnsoiH0xPSVhHR1KxbfRc26+duO5MR2SnthvYkAOc9zjMTNoJXftmPzwAWA/NWaNUQD7UF1mCHffDRfREqR0vx9ppiP2dvdFYo7myuOoNflw91Zqw59qC5sUwNVCqLgFFj+IEq3R50fIska+3YHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Donet,

On Tue, Apr 14, 2026 at 03:11:44PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Convert ksm_tests to use kselftest framework for reporting and tracking
> > successful and failing runs.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/ksm_tests.c | 180 +++++++++++--------------
> >   1 file changed, 81 insertions(+), 99 deletions(-)
> > 
> > 
> 
> I think we missed one change
> 
> diff --git a/tools/testing/selftests/mm/ksm_tests.c
> b/tools/testing/selftests/mm/ksm_tests.c
> index 752a2c0d06ab..5219ee54577d 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -104,7 +104,7 @@ static void ksm_print_procfs(void)
> 
>         if (!f) {
>                 fprintf(stderr, "f %s\n", file_name);
> -               perror("fopen");
> +               ksft_perror("fopen");
>                 return;
>         }

ksm_print_procfs() only called with debug enabled, so I decided to keep it,

> 
> Otherwise it looks good to me
> 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> 
> -Donet

-- 
Sincerely yours,
Mike.

