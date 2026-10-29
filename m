Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E5D606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Kq24YAtb
Received: by kanga.kvack.org (Postfix)
	id D03F86B05B2; Wed, 28 Oct 2026 20:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4666B05B4; Wed, 28 Oct 2026 20:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9C66B05B5; Wed, 28 Oct 2026 20:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5286B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:56:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A23971A015F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:55:50 +0000 (UTC)
X-FDA: 85373846460.30.2CC301A
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf21.hostedemail.com (Postfix) with ESMTP id 290671C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:55:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kq24YAtb;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793235349;
	b=hvtyQ2ThEQ1dS0XsPkVht2tpaq97gaNsSX82TOO0/I+G2RZ+DVf+rYFQDNcNAsJVhzA9KP
	tqznlS+Gl0S8lPPhtebQL4/8kK4CTyqBYZZz9Q71VLUPaoOQLJYZj5i2JZw3vtQZJZNrUJ
	8ya+iJOqcJq0Qr3/hrCvoVlelsdswMs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kq24YAtb;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793235349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFzYuQaJCauylA1fGRQBnIg3JJop64i3OCtTEnPOz/Y=;
	b=IDamZpAq1mjVq51YNY9TFkYguVAz2n+QaHsRlk4DWYiNavKTdstm9nVN1SAZ9Ga29aszCx
	7Ubd4MF/5doBHHTIS3C8sAsZU28C9YDSB0HzuOqE5VV98/4t7jZLavvthJEJSwmRkmfhBZ
	JRDa0FSjJntA5T9dr55BMPlGkqB34C8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yT3k3zYkwm+Ajt3rhJuC2pHkaVqR6QAMaSTFBMTEmxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235345; v=1; x=1793840145;
 b=Kq24YAtbCnV/0p22oZCli0sPgTnpcN2bx8viUurrFAO9WCJaJp2aR7NIDOF4/Yw8EI4GLAaI
 pCTGfY/E/DPwZccPDtTVLexxHabyV0MFo7aEytvqGvktbi/HyfFYatgngZvX7+6lvTWflRGdixw
 Hwd8HjwFZxHiE3BoVCtNv8dg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1fc603a9cbf2cb33;
	Thu, 29 Oct 2026 00:55:33 +0000
X-Mizu-Trace-ID: 1fc603a9cbf2cb33
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:55:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and
 refill_stock().
Message-ID: <auKZIA-0j9WT_gFU@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-4-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028185034.3607746-4-kuniyu@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 290671C0004
X-Stat-Signature: xtjqmt9gqi1ih1bo74zkndtaai71w3jt
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793235346-423380
X-HE-Meta: U2FsdGVkX18v6fayk950bOFwO1p2s7nP+XKALkQ/cUcCKma0M6aTBbaLWqCoxkgLoAD4ciKwFY7OcPWp/YvPa3X2FlDhBUqOu87dw7F5HLeo3NI5wnrtre6GhzAJGbz8RDEWkItzZzX8vqINMN+Jyyr0nJz+D92Xx0hKDxfaKQIoi1boLzj6xGCShmfcrkHM3MDDvf1KUGVbAaWqd6A1Kk6jMzQL9oy20a8L/AnxDfuymWHQp4k9kB/6C1OyFHT7VMBHFIHQuLDrDiXtoVfVjOgEc9U0yFtZDe95kIe6Ko2gMHBXkGeGJTGOYqarAmVqTnf9HE7+GsXNyfvI4ryQEI6DzK/agh7PPARBIeS4In9UOvKZ8srCtNgijhf69z5+9EbktuN4juSNGpluFex+GZc1mcv2fa+UVWRkrps97pJs3NSwun7l1tzF0YyVrWUXTSLKW+Drx/QlmyrdTjorfR5jqidGT8Ru1raUeNEwm/nTxajvYG0tmlIifAv9s24bcID4zaGeHnURSgcNHceDssUyqmWZSHVHVfhCTzTsDWoAEOKejcZKVzych6d5FjeG4Zl6L1u+aphDkbKWhAJJrjnIwaxgPZEsGljZKL2tZ9AfJ4RAqAO/LRRmVNDHn358psnUldo3Yb0nzgko4Z4X7IZUDV+6zUqrwLWLlWcvvVOuB2MIc55Q7VfJGH3e6PE6ROqAPSxOgBe6GB7Lkis0bgh6t1dw0LV9RPMg+iclQsxtSxQRwQnKqKRc58GjsbbrzxQHQhb/rL7wFU7kF1EVER5/LFfGU2kOmvyETopNm/if53btxPNo3ctTIzecMsd1lH1RFDFJe+jfTQJO8ag6S3GF/8x301hfHHB2vhwzd+7jRNHl586xtxXUb3Z3dV0L9cXYJd8ovw7q5Y7XOkPQikpSXZgmjTykC1lEyMqaEJTceEcxu/joXLKdVwGb7qfglYIlGie1pYk+KXLkuvy
 TDTynv3p
 LMgA4QO1HHzopoZlZapj0gPvBbuDeJgTlmxEe79wOEzqRoUPO2EE/ti+sNXI0sNCRM26UzO4g07gasxwqc5Ah4D2DK9DZ7MqFW7xjA3P8cNTEYF3NwuKIcKyzk9nqGdL9FaQpQ+GhIf4bhTQshBiML01ogdyQDpqBJzrNRopk6jUvx9rNLiQjPvdTQRSlt71k2mewhoQ4ElbL+KM1zVMjzl7lyuDjPdHKN0bKUsA2oXeMNrixENlswdF+CO3U/pGWW2hJjTAy+ke6wiwU8PU3gGOo1Yw+MgtSoKxwFRCuLRVa2cMzPz7cM1zM7mzG2Voh5dux
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:50:15PM +0000, Kuniyuki Iwashima wrote:
> In consume_stock() and refill_stock(), each per-CPU stock slot
> holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
> consume_stock() (!stock_pages) or trimming a slot in refill_stock()
> (stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.
> 
> Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
> failure, and insufficient cached pages (stock_pages < nr_pages)
> are all slow paths.
> 
> Without unlikely() annotations (when building without FDO, or
> when an FDO profile does not cover a caller), the compiler treats
> these branches as likely and inlines css_put() in consume_stock()
> and memcg_uncharge() in refill_stock() right into the middle of
> the hot path.

Please state the compiler along with its version here. I didn't see this behavior
on gcc 14.


