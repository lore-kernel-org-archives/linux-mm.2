Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D75606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aw5uQyVc
Received: by kanga.kvack.org (Postfix)
	id F31386B0604; Tue, 27 Oct 2026 20:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE20B6B0607; Tue, 27 Oct 2026 20:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0A96B0608; Tue, 27 Oct 2026 20:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B45686B0604
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:06:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BDDA80B1D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:06:48 +0000 (UTC)
X-FDA: 85370094096.10.AA8B6B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7BDD7120009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:06:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aw5uQyVc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793146006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skEiRkHWE+hnvc3/6Bu0ehaCi2IzacU7F2ubFvDKDvI=;
	b=J07EKzl5n/GbouiVLGtEsxSFcbOuBVE5H9tYptNrhUAIgZZZsxt2iPEjm/s1sZqfAcGE3Q
	B7TKuMA38JHAvnT1CWQWfcwCioG+uv12/ftGmREg5rBJr85/8O2quAY+8laJUuh0SrY29G
	Xbe4UQHWMhkLAMr1756lYtlpGRGnmRk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aw5uQyVc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793146006;
	b=xlmjUbq8K2aZJyiwb6NCwX2qg2fz66zo33yZ/dbSMQb2oklkQGuaa6Bmy/pgWhscU32Emd
	PKbu0Gvany4SsS9Sj7jQ0qRlBHhaQezW1PmcZ67gmGNht5jMNW9F4+n7EAdLMFlmrxBZag
	gUtO3BDSI41GWMszWLEBKh18UNK7TbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05567601F6;
	Wed, 28 Oct 2026 00:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B71B1F01825;
	Wed, 28 Oct 2026 00:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793146004;
	bh=skEiRkHWE+hnvc3/6Bu0ehaCi2IzacU7F2ubFvDKDvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw5uQyVcvUVcveSh7K0iQyIeOrp93TXa37xDmxv8jtEjFdd+gd12i98k4oFF+dLH7
	 Oc4j52g38SdjU3js+RwKx6LxGjjebgJAKoEDrJCIYpEBTKEpNo6QM8zB+4IRhiH3xU
	 wXNcyQ6m36F8wiWEPFEpfd32LGh6R/MRBDZWfuPWyhZOWymY2uzK/KTRwKpN+NWLlv
	 2rOZWzSSRgNaHglsAcvMsafcZCaqlqV2RQ3Cx5ITiIeCeakq+Np6KEh4aOkhbywjWG
	 DfU3ELOPRgKOPswvZAAQGZqpb3/yc/0Zb5gnbwqeuPrgwVGgF6r0RLinVG8tYXMxbd
	 Y7RNSFD+Y4Ddw==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/mm/damon/reclaim: improve grammar and style
Date: Tue, 27 Oct 2026 17:06:36 -0700
Message-ID: <20261028000637.157110-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027190503.2526945-2-manuelebnerli@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BDD7120009
X-Stat-Signature: dcitj981775hrd4oizmiu4ofizp5pupt
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793146006-491514
X-HE-Meta: U2FsdGVkX19dUqbS0Xsgt31hPWiZUyBXeeV/qH0JrzQh9NHJMDbW7V8roqSuEmcyn4nW8Q20rTG6GoJIBqYmS81FFglV6GxwkAJ804vw7Eo91uSdvePHC/h0a7gNdlMvyYF13M+eFCqfe02wTFlw6GzggLCBk2v69RT5BxVM5DYiHTuHPI6EtuUSM+Sq0vlOh+MrSgNPctiskYHcSYy4mTEObUCRGL2R4sA0UFdqxWqli3qcgzfeD8ZEIe+43FfECrOaKj80InWScevbRexjl8fyRZs3iR7CNAyz9STovZMEXErJrSfaR0aIJYgpwjlv8m9t3ISE3f/s3IhXbL3ALKU5smu6qYkyihzyoF9t6DVzIgZaXw15pPBoKHcXlfAHEcGRAT7PWzPCGzd/jMOiqoAlYUF7yrq2ccYE/6fQbCV3TRMedMOOd9SH5r893roF6z9jiGQOUi5uQEILn1BK18jkdvUI6IVqv49Neu/b09Nf5rW7o4QuhheLcuqStgmr7M8b+ohI+F71ak18dPxefg4YHLcLedi5hrLbgvmNKmh76ViQfggkEvXN+YDv/3ypZANNJqjGX7jeh3qkjrREL4bjITILwEQfQci1oJv6vvHQ9J0Ie0AR9A2MTyPpKMTkUUTuw0wM7UWOUGE1W3gL5PQIz29mqx9AXM1V3230Qg46IGKZBn2Q5yrBr2DECM9bYBqn/HDYRgHVRvdjDM8qLgZ9NtZmyERcLC9mhWo1CJw1MvIUqOBjGD6LDaS2NmkDK1Kgi3wiNRXQSwlZafQOFkBKkvdhcKHI6K4vt4ti6EjkWQbtLPrgd0ghLzYGrSPHrY15Qx9ZF4DC1rmryS5B5EBL6Y6V4NoaQU/aDSfRFQX21lkRPaP95hYdM6/3VVGrLjzXwKqXhVVWct9aVBD6FHjpPvxerStiaPSmFWD16orTlAWcw1Kz/vrGsOpAIyuvbNma+VeqNI/5So+iMPZ
 eqaN2bj9
 4w6j4abXvJ3WFIpNTRJDZOw3cZ9gQbRJN54zCY9AqSTNyE+c0DVgxWcYlrN5NW0WOJ7WT59fPUb/4wnG43+mog2OXjShkhY+a+cZnoTzzZSOIR6iPSiWVq4ZvFOM8+snsouEvFUGRAB6kOnA8Cl9IqvzWJlmziVOsltdb07osTot/1+6Ze8z8FdQ6iw7NHSiLcFvsRPUqjU3XmpbMXgPnVjDy35IaNcPjvFmaUEMh2/Nn4jw0hqxBAOylKxe/zVwqncDPb11aB1lVCxZvWn6O7NGwj1/RIpo0a1NL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 20:05:04 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix upper case. Fix tenses. Replace 'set as' with 'set to'. Add space after
> sentence to make it double space.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> CC: Aveline Noir <jm5905938@gmail.com>
> ---
> @ -113,8 +113,8
> Choose as you wish.
> 
> @ 20
> should be:
> -Free Pages Reporting [3]_ based
> +Free pages reporting [3]_ based
> or
> +'*Free Pages Reporting'* [3]_ based
> * the right kind of quoting/ kernel-doc highlighting.
> Choose as you wish.
> ---
>  .../admin-guide/mm/damon/reclaim.rst          | 36 +++++++++----------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> index e4e2ffa52e..0bab2299ea 100644
> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
[...]
> @@ -30,12 +30,12 @@ guests could mitigate this problem.
>  How It Works?
>  =============
>  
> -DAMON_RECLAIM finds memory regions that didn't accessed for specific time
> +DAMON_RECLAIM finds memory regions that weren't accessed for specific time
>  duration and page out.  To avoid it consuming too much CPU for the paging out
>  operation, a speed limit can be configured.  Under the speed limit, it pages
> -out memory regions that didn't accessed longer time first.  System
> +out memory regions that weren't accessed longer time first.  System
>  administrators can also configure under what situation this scheme should
> -automatically activated and deactivated with three memory pressure watermarks.
> +automatically be activated and deactivated with three memory pressure watermarks.

Let's keep 80 columns limit.  Same for below.

[...]
> @@ -113,10 +113,10 @@ quota_sz
>  
>  Limit of size of memory for the reclamation in bytes.
>  
> -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> -This can be used for limiting consumption of CPU and IO.  If this value is
> -zero, the limit is disabled.
> +DAMON_RECLAIM records the amount of memory which it tried to reclaim within a time

Didn't we agree to keep use "charge" ?

Other than the above two things, looks good to me.


Thanks,
SJ

[...]

