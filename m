Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559E9F9D0DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2286B0095; Tue, 14 Apr 2026 11:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BA06B0096; Tue, 14 Apr 2026 11:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B186B0098; Tue, 14 Apr 2026 11:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9076B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:59:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 589DF160156
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:59:38 +0000 (UTC)
X-FDA: 84657621636.20.54D506C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B1D788000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:59:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6hJTblw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776182376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7dQ2sY0+Cgcg8ERbF3Uqu25eLsPzXjlUxjT5Sisy6c=;
	b=VW1b6UiD5VdR2iiOdbSMEjal9u+7ShEtc6Mln+EWNxSxEsHOT626QxjhGat4D7tGmJTl/b
	bgAIQQLY6YZAq4WnQlu4uOVN33YDUiR//JCWHHduaJcY9czzcWv/d3z207d3JCt0SYjlL5
	JzZNb3lwUKzl26s8pMCmbPxRJhL3MVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776182376; a=rsa-sha256;
	cv=none;
	b=ioadACzQw/l5eD7dzMSzdq1ql4EIjnkjhY4o/JX9Yoo4GwIN8bshBu+s7oug0WHJh4HmJW
	3v1YoRke+WUD5X5JGMa6GodgQS2dqbCvKD5zEyeunjoF39dULN5aKcmBLaiK83yKE6yNzQ
	fvXV5Ip9RPz4Zz/6C5nxgCoXbHHEf/0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6hJTblw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06E6460120;
	Tue, 14 Apr 2026 15:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45174C19425;
	Tue, 14 Apr 2026 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776182375;
	bh=aITV/bfMgGy7U+vXDq1yQ40U3Qf6rGvHxss7gbOty50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O6hJTblwwImBWinV4rrS0Rq2sW0tatKUsI/BBl35P2SFrQVGQ1Q3kcLnqd9zpNd4W
	 BFFXsAfzVazpyNReR/Kqin+KcIIPb58+oK5HmBXDETUthYMcPBISlla5PDu7o0AzOl
	 q15GhqbEM4kzho4a0UkxfEmasilmf9N7h5GuxwDQaLzfRX2girh0yP5hFaapnSKWuz
	 RjJydrSpmGIIA64+thIZaim1mSpS+lyhi1QEGgK+KxNJuMcotXD53Pkmdxqmn/mN8N
	 XXZX3tvZvF6T87Ai5kTV08E9H4MIB3zu6AF9Y5VnixXiw7yEnWO5pwTGZJrI79e0xq
	 ZT6H8ksG+WJOg==
Date: Tue, 14 Apr 2026 18:59:24 +0300
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
Subject: Re: [PATCH 12/53] selftests/mm: khugepaged: group tests in an array
Message-ID: <ad5kXC-F_YyWD590@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-13-rppt@kernel.org>
 <1524b172-a5f7-4fe0-9bb4-29287762dbff@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1524b172-a5f7-4fe0-9bb4-29287762dbff@linux.ibm.com>
X-Rspamd-Queue-Id: B1D788000C
X-Stat-Signature: e9bkexsmmmfqgdm1z5romyrppwikoags
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776182376-787312
X-HE-Meta: U2FsdGVkX1/oaUEGQG0jFLcVY69mhpnfwS0JO4YqZdu3VKcXxNnz++gQo0QrYiuYGVsDzMybPntxtUUpPEEU4QZdkoYycQXJD8ZcDjfq5P8s6Kt5xHZ3giteG5dHsArCcdNfT2CQoI0EqlvgzXG5iAkQ1LlxP9VUhAIZyu8t/wyR0klDPWMKtAN5b9mdbgy3CAPyZ/Ig5BJ6VoEfVAkdUdSN7U3b9hdcjg9RCClezQ/BvmUbRDb7ilA3Aium3CAgMMPeWvVeJQFiewddq/p1VO9pBcqNYXADtz0lgp29vIWP3BCF5zwISRy+i1oIUT64dIkXx7ggm/ekWiF4aX4336zyjvfTb9i5/+BWdqBp7U3kYNgM0aJdlzuK/Fk9fPdA2PDKwUhaoX+GMe6gqzeqfdu8iN/BjwmN36/KtV2KjePREEkfRnrQt6yuOa3cwnGM1kzllxgCnK92zqCaovWuUqJF52Ybf+6NT3GOKmzIB0Hxf30YLMkshDRq5wcx/f6XKQZVosYOeRdqFskw8+RX15s0iRQwDlrds1IuZJVRa3bxEGepZg+fRK3uu7mG1+z1Id3jggCfTxBVIH1oyKIRAWfX56ZCeSDIURnqD8LqooG7cUt3bUiRMPvyEwerX9Z6QgzuzHKw6k8O5XgD+n+xjmlDj5ptzqmIponhR8DHxtR4Vqx7ltqIYK3LVDyIQegTpWwTvJX3xFl8Y7QQ69LJZ48/UCwpLT4y8ZKl1pItLl4fR8y/WgRblE3CDHOMGCKCKKa030Wb5sKGpIrYv30xkmLZHu3868nKZ2UikSKqWzIZJx5yVdu3+X+CTQbN1TznIW0s6SurEGJiuTBYKODVeIf7rC7VAzxetoRrs5h5vPSk7TmvSV8vsIJgq/bz8cEruY+M0OPQYBMDo7DxNNGdG+/Ozx/hpc/tNCyW2KZmk86mgnEJMAyltFz2r2KFQCDfnRJs9zjnJ5p/3KWAyqK
 JYcFbBwn
 YQXaaiNXPb9f3q6+glbwJCdtm+G2Ee+fhriJgXKcMtvLZkfMroErgiR4aI97sm2AeJTs4fMx+E6A8bZiMhC/E6C/a29dso50HqJ/PvJkXlMC1/5TEdSl81AaONUx7WsMShF07WKnct63v4EVBlujiFiRlmfzAWQ0x7IiFKnkNTOeeaYuOr8OYdLHeyH/f+jbG0QhkSW+5NXW8vitCpKuXfUWQHlHdPbF9SKq7VTu+Z/ig6lHQyV6h/N80U7AC3OYM6uxRZKTEhVGqgd8m0S7X8wbZXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Donet,

On Tue, Apr 14, 2026 at 12:32:48PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
>             get_finfo(argv[1]);
>      }
> 
>     +typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
>     +
>     +struct test_case {
>     +       struct collapse_context *ctx;
>     +       struct mem_ops *ops;
>     +       const char *desc;
>     +       test_fn fn;
>     +};
>     +
>     +#define MAX_TEST_CASES 45
> 
> I see 48 tests in khugepaged.c, and running khugepaged all:all results in the
> error below. Should MAX_TEST_CASES be updated to 48 instead?

I'm going to bump it to 64 to accommodate potential future tests.
 
> ./khugepaged all:all .
> TAP version 13
> # Save THP and khugepaged settings... OK
> Bail out! MAX_ADD_CASES is too small
> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> # Restore THP and khugepaged settings... OK
> # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> 
>     +static struct test_case test_cases[MAX_TEST_CASES];
>     +static int nr_test_cases;
>     +
>     +#define TEST(t, c, o) do {                                             \
>     +       if (c && o) {                                                   \
>     +               if (nr_test_cases >= MAX_TEST_CASES) {                  \
> 
> 
> I had a small question—since the number of tests is fixed, would this check
> still be necessary?
 
If we add too much tests without updating the maximum we get a nice "Bail
out" rather than SIGSEGV :) 
 
>     +                       printf("MAX_ADD_CASES is too small\n");         \
>     +                       exit(EXIT_FAILURE);                             \
>     +               }                                                       \
>     +               test_cases[nr_test_cases++] = (struct test_case){       \
>     +                       .ctx    = c,                                    \
>     +                       .ops    = o,                                    \
>     +                       .desc   = #t,                                   \
>     +                       .fn     = t,                                    \
>     +               };                                                      \
>     +       }                                                               \
>     +       } while (0)
>     +
>      int main(int argc, char **argv)
>      {
>             int hpage_pmd_order;
>     @@ -1216,13 +1244,6 @@ int main(int argc, char **argv)
> 
>             alloc_at_fault();
> 
>     -#define TEST(t, c, o) do { \
>     -       if (c && o) { \
>     -               printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
>     -               t(c, o); \
>     -       } \
>     -       } while (0)
>     -
>             TEST(collapse_full, khugepaged_context, anon_ops);
>             TEST(collapse_full, khugepaged_context, file_ops);
>             TEST(collapse_full, khugepaged_context, shmem_ops);
>     @@ -1284,5 +1305,13 @@ int main(int argc, char **argv)
>             TEST(madvise_retracted_page_tables, madvise_context, file_ops);
>             TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
> 
>     +       for (int i = 0; i < nr_test_cases; i++) {
>     +               struct test_case *t = &test_cases[i];
>     +
>     +               exit_status = KSFT_PASS;
>     +               printf("\nRun test: %s: (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
>     +               t->fn(t->ctx, t->ops);
>     +       }
>     +
>             restore_settings(0);
>      }
> 
> 
> -Donet
> 

-- 
Sincerely yours,
Mike.

