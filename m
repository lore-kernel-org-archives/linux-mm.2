Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F03CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA35A6B008A; Thu, 15 Oct 2026 07:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B9B6B008C; Thu, 15 Oct 2026 07:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BAAC6B0092; Thu, 15 Oct 2026 07:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8046B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:23:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF8BE1A09D1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:23:48 +0000 (UTC)
X-FDA: 85324625736.11.8AFC7D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5D2BF1C000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:23:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnEtbDY2;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792063427;
	b=Fc+auSo2W4IDXsFfVhJROm+tiNCPyGA/caRnLVEhRrRSPZ/U15y00QAfpTlUVjtWMdmEiv
	QzoWIi503cBrXyG5YaYptNT7U7bO5q42gTMgsVsVLCqdYrfNYno+ZzvssBbISPqk8pm/gZ
	ql27jGVgW2hoynhwU6lZLfOHtahxXb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnEtbDY2;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaONaJy9zOGDwLSiZZfT9M8YqFnUV6dD9AsnitmV1L4=;
	b=zVc40BoX4Hy+d3hV5h6ji2DkvWFMyp0ix6V3Z/wPgsBW/VVddHlzixNraUAReylgHa5JSd
	3vmGRDI+cjgN2d3r6/28i/oaSYhXOFv6tBMsohpKMklTeXc2jISNutOedGG96nVOxCmMWs
	Qx1KG9iN9/58SjkJLiXTFB++PEtijlo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 637DE4110A;
	Thu, 15 Oct 2026 11:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620571F000C5;
	Thu, 15 Oct 2026 11:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792063426;
	bh=TaONaJy9zOGDwLSiZZfT9M8YqFnUV6dD9AsnitmV1L4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JnEtbDY2s0Z1KQgEadlcp/vBHTVt68wCHGEaMq1/2FFqX0xuBEAs8a/DlSrO4nkR/
	 Fufs4obzoq7Dghqv6bW91bnv6dG3cbJpGNdfhPiZObvKS2tUqYHIHdyUoMYOXT9pRN
	 WPHDwoyjzSN+X4UGxiwjdUkr6o+tZVDSV9Wpu9e5+JHVDnqcNhkyYrxfqBnX16A19p
	 VJ6e4rpBDOaKC1CGexwODX6epOcWKxBp34FA+HC90Ig4PtO5WyV+VmMYdVia22h1HN
	 eJZNGyNU+zSgNx5m0fKyELsPBp4hA4o9rjhhq9TLsmUFBP33HAj0Ll5xsNOyg8g3fL
	 EMJ6AlARU0hhg==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,  Roman Gushchin
 <roman.gushchin@linux.dev>,  ackerleytng@google.com,
  akpm@linux-foundation.org,  chriscli@google.com,  hannes@cmpxchg.org,
  harry@kernel.org,  jack@suse.cz,  liam@infradead.org,
  muchun.song@linux.dev,  shakeelb@meta.com,  sj@kernel.org,
  ziy@nvidia.com,  "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Vlastimil Babka <vbabka@kernel.org>,  Matthew Wilcox
 <willy@infradead.org>
Subject: Re: Sashiko change proposal
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org> (David
	Hildenbrand's message of "Thu, 15 Oct 2026 10:38:14 +0200")
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
Date: Thu, 15 Oct 2026 13:23:41 +0200
Message-ID: <2vxz4ieni4w2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D2BF1C000B
X-Rspam-User: 
X-Stat-Signature: sp7jqwwodghgu7nqsn6q695w49ic5f4j
X-HE-Tag: 1792063427-617978
X-HE-Meta: U2FsdGVkX1/RFLfYW7CANrmuPjEzsD3FH/+MlB8C5viYJGqiORLQ1xMqBdm9D22PaKBL2tWI5XpIqrsAq+KR/TW6bqC/FT0kLwDIAiqaLY3z6mpMa4OfHWNm6KUBPn5NMFG4Pwn19yB3qyizf0x56WOJ5IJ7s2L8ngVoPI4cHHuutL1CRCDuVvfDkE/7E5cwRgkWBqWs0M41+NEdPNc46XN1uHkllTKkEbuNPrf7ugoVDJd31opWQcrG1mm6zxY7aMU3PhIjmnK2oWnMpnjpRyu3cTdJ4LIihrscTp5iPDNFq6WmeATmCs/Xk1VO0EKRMYSXSep10bqoLaqVqIIAc4h1ZecGzavWIJ4j7hw07nOhJdCVrRgI7DxONzJHxpSReggAwopFc4mMFUokM0b+ivSJzOzx5q/brGoZTm0PTf6p5CHML8tajd/SjyXQ94o9AXZkg8v4u/o4reCtukDsllfbSeAFOvjvC2+DM+Q5OeOmRfWF/8l4cuLYaGBqkXaZrmuxrk52m6j8hApV19lNLQk2u4e4blHnDXHsCNJBQiKMYzi/N3TioaEOsbGg71J0MDfUcHlj6kVj+pTYZ7PMDO6gmiPip175u0eZFZEgmZ2rhSE1E1eq1Dwgw/zTptKlTjzvIwfdNnRxS1kq1lnRyTJQ3OVe1ZIE0lxrPM755MEpI/VbFD+Oc+ryt7v0vYcBAXHra9fXeEEYFwN/XAyJy+uAtxaQIWnbDIccGXcATBpmBJW90bgMxb/2MjkTOBAOJ7j3hjWQsIuJ1NODbjiVWFrWMcljNeIaIM77Pm7QukJ3qAqOpv7rxix1yVL5tjP4b+ZdCddr+yEEcWPSzwsbr9jsUi258JU1wPGOCgq038Ccmem3ZbqFDqe9B5HKyVpNKc1ptIWHyB/jO1sgopw6VC4qUIwKwVOkBfL29+4KRr+sq8wL+6UuUorNcS2r+vzmZwDYY0+RWvM+bIwJ4Pc
 MGyWyhHJ
 wZk1Rb2+vNu2p0rhV9Ncd+z4rXQu3iCH2xgKzi9TePBGoULHE1mzhqrRje1u0q12GZXLnN1tSJHHCLlRKOM4WPImjlFFXcNCzIqQi0Fe++DHMxoHyIticeemJdX6AEtXG2WzFAykdiUOuE+OWd129ugH8LotQg5seLm34bXWyGVzZMC/wWLH5ow183kREoTPdAOxChAcJsCwcPu5NYAUe3vQ3gv9/sxnOytDHc71+XHLd7vqtFt4QXGMidpRBj6EAvIn3MbePJfW26QvDPNF4pH0yn4bVLDuRjsEf0KD5ALlZKa6nC8ps82JjfbXEqUuqcxuCIuFn0AUzfQ00RxofMQNVOx9vvG/VTY66JhMsghW/R8fXjs+yHett5mKIvjjSWq0TC8IQ9xlGkG3CGFxVs+KOkk+mcrJ0DHBr+j77NSag3MD/hxUYfXzHFUUgaSZg4qfihR9AukUR8Vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15 2026, David Hildenbrand (Arm) wrote:

> (CCing all people attending the mm-next call)
>
> Hi,
>
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
>
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.

If a sender re-spins stuff too fast after a Sashiko review, that's a
pretty clear signal that it is an agent. For me, that makes it an easy
decision to ignore the sender. I'm curious, why would you want to lose
that signal? Is the goal to preserve Sashiko bandwidth and reduce
mailing list spam?

>
> I suggest the following sashiko change for linux-mm:
>
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
>
>  ["fsverity@lists.linux.dev"]
>  reply_to = ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to = ["author", "list", "recipients"]
> +embargo_hours = 24
>
>
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
>
> I'd say we start with 24h and see how it goes.
>
> Thoughts?

-- 
Regards,
Pratyush Yadav

