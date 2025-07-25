Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89ADC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD3C6B008C; Fri, 25 Jul 2025 15:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4F46B0093; Fri, 25 Jul 2025 15:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2C96B0095; Fri, 25 Jul 2025 15:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327D16B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:36:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDCDE160901
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:36:42 +0000 (UTC)
X-FDA: 83703794244.19.62936D2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4389DA0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:36:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HidX9jYW;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753472201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pA5236NPJZsQg9Io4MU6BGSNRLzxfARoZjybzjcxIKA=;
	b=R4IGQ8vvJ1JCjj4ATciUY1QgSIN9zDU86D/g6scLbbchRpOJ2DNmQ37UkHH69BPv1z+Wy+
	dd9BBdjPvrt0hU5GCKWZBBmADkhBajWn1QdykL1K6B5FVda4gYLeVpW99DXdSV7SEdVsFV
	8f+CZ9Y3xMG7PEQw+cKZ9QyQM2Y4bKY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HidX9jYW;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753472201; a=rsa-sha256;
	cv=none;
	b=F1PhB8DzzyRwrXTQ0yzVo14MYKmazdPOTG8EtZ9puqUj+a9rGElh4gHgUeKnXKzLLsBG25
	Zm0HbP5NtV4sVQz7qr5p2AZF6YLwz7mtp0dG2icnSy8c9IHJ73bEUjnGaXQHToEaHYKkth
	/c9NO9UkMcnnYFOz2bY9nXwx4Q5Y0OY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 7EF3BA5648C;
	Fri, 25 Jul 2025 19:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB68CC4CEE7;
	Fri, 25 Jul 2025 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753472200;
	bh=VSgxj2goV+n6GGKzIUMd/swrr83Kq69rPHQxxeyypAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HidX9jYW+avyV7QJUSPLcMwX+nCkBSnajdFU9hEHohCxtRVLA3a7JKQh0TBeTnEBD
	 0yBFuQmYzyCxPkpNlp4avKEj3O2XduO6GIvXMT9bGO1pT10wY1DaoBD22NqyQZZ8P0
	 sd7W/laphrp6u7LBDoWV3/JE3Sa9MUPub4WYrNAD5RoNs3ScGt1EWFtMcRvbQzZk26
	 cs9KaJcLIUNSUPqd24wHNAbHltfDOn9nssy122au6D3CaVDzwDkexdpGAju8/ygA/s
	 QUDrAD1gu/yl4OwrCoCFh7vDZEN07IGUdK7/FaAqfd0OTjQHT8LM+LiBPVyx3v5fVj
	 isomO0jzjD/vg==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH] mm/damon/vaddr: Skip isolating folios already in destination nid
Date: Fri, 25 Jul 2025 12:36:37 -0700
Message-Id: <20250725193637.49389-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250725163300.4602-1-bijan311@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4389DA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: psxsop5zrr3n4utqisrifxhd5uxjiz3o
X-HE-Tag: 1753472201-743687
X-HE-Meta: U2FsdGVkX1/vwVkuynHV5zzmrRXp03JZoU5cfMxZlvDPQyZjqhPWSDhN/iIH8hsRWmuGLD6NdHF1phY6Cr/oxPfgiThk8m3iSh3eqouN2Cndw4gjbUAGDuGfzv71fFeCx+p9Wu+DnY+6Zd3LwcwxUkmxeNCVFAqPz6/4aKF/r0Cnr3hrgy63VEYYFYa1CWxK2sr+bhxG/7E2RJS/E8z5Zrx8ZZFt1rtDCca/Hb2VgAKsnIryHZdyT1Y1Gt2s2ro5TvIa5asjocVYUgGL/nafzP3MGyWNSZISOspZ5AGmUdxxTpM4+9u5SFmGDcMt+hKJvly/E7L590apJ1zlAJWmUQZWbLYC+7YzpOE0nWZprnxhoUFRm2mYQSw7TvH81RYnOvTd6CqY65hwlay2TPfd1NwTnIYfJ1laiu8MEI6HXNmWlr3rTWu0InaVhXdOTVcutt6lqsXGf/oX+fgdJykSZ4VNh07m0VDEwt3Vf/66hwb4ZpUDXiL3tKCA7KN2sxn/CJMRoNGdtwWOPMjVmuh3VDDzTETXFaDcAwA6xcZtc2EVnLZFUZYGfVBOrrGVYbVo9fexS1wHCWVWpfqe4jxnM3gEVYEUDh1XFpGUkVjLFN2RddqU4sgX4U+vfvoNog4pEXGsc3xjF8BM4p5JDAsRwobMz8WztThIaKL6pinh9rARiLSgZU43ILAGwNUaKbmw+zZKfsBbCter6Z+KRALOjNUV88ohxy7UgH6s3teLPOQ9HFvpaXOBKg6D9A/px0+MTCSGk9fFOb3TLVFFuk2N0feYcLYSs7uiAzbnI46LE1mfCMZFXqR++H8uXFqM2D48CQyJO+ZQYj18sWwIZrYLxGsIbe0NkrP6TcC23Xa5Mcn3sZ9Aznq+XFqFJ9nY3zOUj7ynWoEcuyIHOsjcJN/fTPFWXqaqKCZRzHfUJ6cDgACVCXpsvgO4TtRUAOJ4OJHt297SBlUVbZxX8r22J+G
 gMqEK7U4
 mI0G768SUXsVScsr6A7R40uDwygiaqGgX4Y6EfqCGKHdpeGGLhZRauMu+mGAYp+cvvAOB0HXKnqS937+wPNyXzW6pGsnOprT8X5Hi7383wOjKeB2v6KZTZjLUPguB7jL3tOiLkwSN48JRMKgkXqCerTxlSRVB/rV04evty/kWFZ1XGXcAm7IwaE4sc+F5ot0ZPYjOEU9z7yc4HNvV4l7WJOqgkUZUtzHMaUBiEh7T9hh1sqXAtVRHXVgDh5zTBsY4n0sPCdAwAkCfRmVqzZIzW+wKnQcV53iWdJMiRHXFv/ZLSDi9w55X3jFD9gjaJzk+GOpsZADaDyfpKcK+vZzjTFylmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 11:33:00 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijantabatab@micron.com>
> 
> damos_va_migrate_dests_add() determines the node a folio should be in
> based on the struct damos_migrate_dests associated with the migration
> scheme and adds the folio to the linked list corresponding to that node
> so it can be migrated later. Currently, folios are isolated and added to
> the list even if they are already in the node they should be in.
> 
> In using damon weighted interleave more, I've found that the overhead of
> needlessly adding these folios to the migration lists can be quite
> high. The overhead comes from isolating folios and placing them in the
> migration lists inside of damos_va_migrate_dests_add(), as well as the
> cost of handling those folios in damon_migrate_pages(). This patch
> eliminates that overhead by simply avoiding the addition of folios that
> are already in their intended location to the migration list.
[...]
> Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Sorry I missed this in the original patchset!

No worry!

Andrew, could we squash this into commit 19c1dc15c859 ("mm/damon/vaddr: use
damos->migrate_dests in migrate_{hot,cold}") on mm-stable?  I think this is
just a simple fixup.

> 
>  mm/damon/vaddr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 7f5dc9c221a0..4404c2ab0583 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -711,6 +711,10 @@ static void damos_va_migrate_dests_add(struct folio *folio,
>  		target -= dests->weight_arr[i];
>  	}
>  
> +	/* If the folio is already in the right node, don't do anything */
> +	if (folio_nid(folio) == dests->node_id_arr[i])
> +		return;
> +
>  isolate:
>  	if (!folio_isolate_lru(folio))
>  		return;
> -- 
> 2.43.5


Thanks,
SJ

