Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B7ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1588E0003; Tue, 21 Oct 2025 20:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA91C8E0002; Tue, 21 Oct 2025 20:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEE38E0003; Tue, 21 Oct 2025 20:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A909B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:46:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C185C06E2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:46:43 +0000 (UTC)
X-FDA: 84023909886.07.BD20136
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 98BD340009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:46:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R2w2Escy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikTj+CvDErfHyWu0RhITh4peG7OROcL9SvOCvETguYk=;
	b=OKw5npKRYO/EuveQyp/ovdPBTtZUZJ7ru7iTwoHQbvgznEBRarQCwMrOarirkrsMohOJt3
	XD6IoUnvFm/yGQpsUgw8tq53IvD/fvC/goB4KOTr83Ca3n3n5u13IJK+zTkSAgLgYCORMQ
	AcI0HUREPNYggq2p54GE2SVtFm93RO4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R2w2Escy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094001; a=rsa-sha256;
	cv=none;
	b=dswiIPElXmaWVGP6mZ4izbJXlpw1YuDmnnFasAx5D1qbHX10FpCxcQQAZyoUSdMX0Q+2pT
	UHaeHLLXhK0rQbxd6MV9Nj2D2LgaqwSj+RiPET5JVUt9Z3v1wnseJ3ZU9SdTeZ6SRQOeLK
	UTr0MUcGb5catZsaVzXDdFVHOyMOJ6Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6851D40A99;
	Wed, 22 Oct 2025 00:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B784DC4CEF1;
	Wed, 22 Oct 2025 00:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761094000;
	bh=goRiRUZ7sLTgCensnC5aP5+GySLWz9riJcQIkmhcGh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2w2EscyYS5Hpa+kcsHfoJeHMyQAeTCA/OWsOxJNz+zmybaorMUOs7EmKx5jVImeB
	 OKO4hZ3q0yJxaT3ecb78et9Kmx5uEwg8uxRJyTgCih+7lM0Pl4WWFMBfqbfatlSoQ6
	 g9DsXHzlv08RiH1NFEUGzVlCB9fuxl0Xz4ysBXpDX/VE5jegPCyijZsELDzCvdrAHz
	 jM+nQrhTmrTbflWdiKigNM67gJs7JIWlwhNDJJ324cyTqgRfc5j90DidvNRsQ6JOUo
	 qyhlIhQnb94+EI2PC2n2ODYFmJF9aSxsuXD6+4HL1Kiy4TqWOsuqMpuQeRlIgXl2BV
	 0pq9EduwChm8Q==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list),
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH] mm/damon/sysfs: Remove misleading todo comment in nid_show()
Date: Tue, 21 Oct 2025 17:46:36 -0700
Message-ID: <20251022004637.119085-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021215323.29734-2-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98BD340009
X-Stat-Signature: 3taxq9ro5fttiuk75h3mx8kwzd1etsk7
X-Rspam-User: 
X-HE-Tag: 1761094001-72760
X-HE-Meta: U2FsdGVkX18KoJ1GmgAZ22pFIHL6eUbKHO6WG3sjz6y+BvqN9cpeDJB89McMEKuOGYavxsuU+WwvB85ijtaS6DqQFMU4viK3FMZG6CeMkGpjQjjYAE/lSqVsH6185YOls4dYMiiVVexhFrWCa69voUeyMv6fx0xNym/0SVhpLIEMyLIb131Oy2tonPMCf/QokqxdorlWwjeRqRUNQjo4my1Is7WY90X0emKh4uCrlCFnih2C+KZE4DUDWLY00+s24Bg/z8YWmAfJWa/wVEWnmPLz82StAj9uNX6dzrlzn6tXihen/fNwQ+rXSb1EQlSbiwIPvAku00LbxQjrHNrljdKQitebeSxog518zABxKwr3uDygDfqUkCBhDNR+HuPql50fhQzHTlM5WgZ1Cgf1Q2yV9WgUVKnhQtdC9XrVtFCkVVUzP6plA5pLSPPKbKcsza/eDLq9iOImHoNTQ8C2RZtC5KY7sbFBS1q/zLdG63V8oRSeATy59Z0WMzYYbRrLtKrKjbIkdPR79lR7Ce4aW/xNoSOQ96um4z8YkbgldBdKXUtoUTK41ladAbJ3it3ngxzLUgBnYVpRjI/743QfXkogKAdiQGeFSS03jkl1YIVxdHy/gyLhjkMTkMCnLZOVfeXEEKT0d8xpdd2bGiPJyxiM9F/xDnjwC/3yvzp0mckqwKcXzF/6lhQx9Ogek/8jc7L+3y1AHa/EaOj3zqIpjHRn8nYNow29sqwFchZfPRIqMIvKb/mlSBjhBP9N+jsKyR57mTYW4uHBz5vww7H/qRYiOb1q4dSyPjzyrg0OJVX+ZoNiPA8KJOT3n41kLtnpM9o2eVVDpgrM+SAJ+gVmSEoY0H4+c8ToAipr9dg+ppkzVK7t92EpmO7myjjsuaf5IvHMcLkI0rqsanACw+/HgjUVjN5/jSKBqiT99J18QMj12ZQBkkqE3zdDEMUh4WasD3O9/wPpoRqxehQsIv2
 B9jOVQcU
 3VQ1Cg4DE6oruk0CI8nRXoBdhPSCSK6j1KNGaWPZy2dyI8VCEoovQHVwo8LJWr7rce3h4pdr9hG49QThPn7ZvmgPZLVmliabtZmW2e1dHz1Yi6maNW2umII2fZf3JFYqAvNUuPRufYbW/qBzh4JmvmPtTAK1lfo0MEXADppvizVdgnRfQ8RIKIwDTjPVuD/kZn2zofWxFFpfGRBfsiQ6JK5WEkITkUaIFCmzSyuArn6iNVkIxtyFbPFzrgvw4HwA1KgEMiTMATr5MbjETmCDapYeFj0YW3E8hHm4xRw56YoACaU6RwBqtZjJCLqEbeC/BL0wx7TuxfKmXjrvkLew8FHtnbGk1Z1s01Q1pTBkyhcJB6eZt+vTSBzvMHiSGMOz2YNF4h6hN5V39VkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 21:53:24 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The TODO comment in nid_show() suggested returning an error if the goal was
> not using nid. However, this comment was found to be inaccurate and
> misleading.This patch removes the TODO comment without changing any
> existing behavior.
> 
> This change follows feedback from SJ who pointed out [1] that wiring-order
> independence is expected and the function should simply show the last
> set value. and [2] checkpatch.pl complain about number of chars per line

This is another revision of your previous patch [1], right?  Thank you for
fixing the things I commented on.

That said, marking the fact that this is a new revision of other one on
subject, for example, setting the subject prefix as "[PATCH v2]", and adding
changelog from the previous version in commentary section could help review.
Please consider doing so from your next patch.  Please refer to the related
docs [2,3] for more details about that.

> 
> No functional code changes were made.
> 
> Tested with KUnit:
> - Built kernel with KUnit and DAMON sysfs tests enabled.
> - Executed KUnit tests:
>   ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests/
> - All 25 tests passed, including damon_sysfs_test_add_targets.
> 
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> Suggested-by: SeongJae Park <sj@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>

> 
> [1] https://lore.kernel.org/lkml/20251020151315.66260-1-sj@kernel.org/
> [2] https://lore.kernel.org/lkml/20251021010847.68473-1-sj@kernel.org/

And you should have put the above two lines before the above Signed-off-by:
line.  Please consider doing so from the next time.  Again, read the document
[1] for more details.

I found Andrew picked this patch on mm tree, adjusting the above two lines
properly [4].  So no new revision would be required.  But I'm noting this for
your next work.

> ---
>  mm/damon/sysfs-schemes.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 6536f16006c9..760279092b4f 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1112,7 +1112,6 @@ static ssize_t nid_show(struct kobject *kobj,
>  	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
>  			damos_sysfs_quota_goal, kobj);
> 
> -	/* todo: return error if the goal is not using nid */
> 
>  	return sysfs_emit(buf, "%d\n", goal->nid);
>  }

And this results in the code having two empty lines.  Just one single empty
line would be enough.  But that's too trivial, so I wouldn't request a new
revision to you, or in-queue direct fix to Andrew.

I only hope my trivial comments to help your future patches be easier to review
and more smoothly be merged :)

So, thank you for this nice patch.

[1] https://lore.kernel.org/20251021021712.59017-2-swarajgaikwad1925@gmail.com
[2] https://docs.kernel.org/process/submitting-patches.html#subject-line
[3] https://docs.kernel.org/process/submitting-patches.html#commentary
[4] https://lore.kernel.org/20251021183613.C4A6DC4CEF7@smtp.kernel.org


Thanks,
SJ

[...]

