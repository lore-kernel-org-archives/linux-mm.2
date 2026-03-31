Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BDE1061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE9B6B008A; Mon, 30 Mar 2026 23:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0704A6B008C; Mon, 30 Mar 2026 23:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7CC6B0095; Mon, 30 Mar 2026 23:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE7086B008A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:04:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 762345BCF3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:04:49 +0000 (UTC)
X-FDA: 84604865898.16.28CB371
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E382B1C0003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:04:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flIILcqn;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774926287; a=rsa-sha256;
	cv=none;
	b=G5fWgJTGZrqEL5z/gdee6mxffeh9TdMnuzs1mhd4KOVbHUKP4Gwh9OeJiRHd+xv9Z5gX+b
	TF1BHEJFYiXXiC6SQedQrgnGANGvxCEvTzIR0yeRabOqsijWw6G1etKOdIeI31Qm/UDZie
	12RFgzk6SGkd9pmzX06pL4v+mcjgt9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774926287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Um4ewX29gXehgCBuoDL9V3/KYIC3onz/0fTJy7ifeY=;
	b=x5IkEexgwsCdShukMkWbHupVH3ZH1Uq8Yd8jTyZ9b1l68pu4sDzz5UrAaEPgIVfWIQ8dJn
	4GggEMPUJ4Oniu2zEfK4zsRBNoo96cCQkW+/oIj44ImbOxm0bqbmBobu1YZBH1OT3XEXZE
	oHlqKqviEOBZ1jWspCo90EPjbxxHMXU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=flIILcqn;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A27E6001A;
	Tue, 31 Mar 2026 03:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85681C4CEF7;
	Tue, 31 Mar 2026 03:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774926286;
	bh=cvVmqCKIqLKepAb7/80JpYxt9nnAQhs9tMixAvmVgaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=flIILcqnDvljYA6KkCUeMvcGhPuCzNuoPmsc+nmaIP4sbX4GrpCTV4G5GPLX5DiE7
	 imZ7GclJ33lI56dY9oJJBu5y2+z1gsk6l2rgrVa7fpnAMgn+39FZR/Y/d+1CZqT4Fk
	 UpuFeymZPn772kqHgKSkqBpdHKGiJhGi/efGeYLeaSEsBbBq+IjrnHzjiMS7hdfpU1
	 F366BYEv7zJHVVVaRRRRee0GQIPySZEzUO8dTnqkhLfAymbkY56bj8hkPKmN7IDr9y
	 6oT5g6KTG0BtUalGpkzKgYfGZ6d7Q0RxGK4ILi2/lYOJo5u2zBIb2lhGsThkxpK94q
	 9Z5s9oUgVurcw==
Date: Tue, 31 Mar 2026 12:04:44 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] lib/tests/slub_kunit: add a test case for
 {kmalloc,kfree}_nolock
Message-ID: <acs5zLWBo-eQnQme@hyeyoo>
References: <20260330120517.104743-1-harry@kernel.org>
 <20260330120517.104743-3-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330120517.104743-3-harry@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E382B1C0003
X-Stat-Signature: 7fx6uprcyfwtnugxkzx8975ke3kfrkct
X-HE-Tag: 1774926287-56499
X-HE-Meta: U2FsdGVkX19GH0DLQctNAGJvirkZiRawSBWV4AuNXT792C0e10FHjPtyqm01tI6+j7SIj30Aj4PPD20mjRaLV5W26W6uYF+NVPsZync1EDIGiUzRhKYF3R9JQwBRpTMH64hA2keVKvGfzE/IWRv0GrihymkAEgMcDfambBmW18WszL67nqvKKmZs5CW8yGK8NJmhnk5Iz1r0EL4yS67TgyBQs8H5TRmjrWlUBISD3pYcyVQReq4tmtEQDGLVggWaGaX1+EWrmSCyh0vnZi0RUnf3yRrLbJB/rdhnNdX4YYsW46tVtzMRbkn4gTp7INGEzwfCa/93h2J3MEQGmHCX3KJT11QMaPau2IZImmP7xvokeKhlh5RJzvdk0xICe33/MWVWsKPvLdmFVnMzRMyeCI8Gs2BnhK0mzN+JhcA98U9myFvC5or7tNM2OvMwil6caRmQX/aMFqfwGaJ8mjRq5CWtJaG5tiul/BQb/Koz4FUL7aYNe/cmkIINOmjQe0kd0ZqV99VKVYuQ2mhpf97RI9nA0LpvfjQlWU45CKBBElfl8XY1MDQpN5zv+pcktcXi++GsCGebLSw4QGumyEP5MsFKQNO+R4zegbrVAOZgRHhzmpJetD9YNm6cv2Dxdz5uAyqsI/sXgCB/SyfXFedbke/NknplDIZO+liOnBboAQ7cEGQ7ayBfRhYezi8qz5G4rrWcvMI9otOiWgJKYythjNxJC17Ghvpf672oUxGXVD9Ilof5FrYu7iY+bkgbcDRH6+3y4hd5XHvH05K/zuRnEl9EetWjhPCtUa9LLhn85UO6KH35z5+3LTfTdaazM4zZq5MDQsrSGE2SasTOgb1F/qPO/mEq6ixAY80HkKgGfxRV6JSO11OjpLVt5u7e8rfRc3cnrd5vyw/lis9J9nNhW/Anb7w3S56qyFyliMhUczaPnPOmKLAAB4QZzAnN0Bcn5m+EuoLmf/FKUR9OP7q
 wfAg4peL
 cb7qrIYh3JFycEGHZ3t8TR3oqHJDkupd4F64P2JFMHX5YLGjlosIzBDris+F3I/RDCczfsFKytt+ovTUWOO4i9Si4Scc27W4ZuBCXC2EjdHbHy0/Sn9DVWI2XqM7f61wUK7FAvEuvLw9OS8/2AJdVt2pD0IGaeI4HiPs2CBSEdgG3pMTXuPJ3xOBaM8E4dl3z318RlscVGuFYKSRvrsEzACCXvzUtOYHI69Mh/nQY8gdeNZZLXwBI5Jo+7QwlM7X/c6aWbCkFAlvbjX9x/vBC1ztgo38NoLW1Gg4SQ6/einrhxpsYYUIjB+KXKvGadjDLuZdEY2m+ifn9huh4npo+76qV2WhPzi73CAaORqbxCSQJIYOiIq6KLUP2vT53gyt+0ncI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 09:05:16PM +0900, Harry Yoo (Oracle) wrote:
> Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
> kfree() is tricky, and it is even harder to ensure that slowpaths are
> properly tested. Lack of such testing has led to late discovery of
> the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
> !allow_spin").
> 
> Add a slub_kunit test that allocates and frees objects in a tight loop
> while a perf event triggers NMIs on the same task, invoking
> {kmalloc,kfree}_nolock() from the NMI handler.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  lib/tests/slub_kunit.c | 88 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 848b682a2d70..2ed5f90a748a 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> +static void test_kmalloc_kfree_nolock(struct kunit *test)
> +{
> +	int i, j;
> +	struct nmi_context ctx = { .test = test };
> +	struct perf_event *event;
> +	bool alloc_fail = false;
> +
> +	event = perf_event_create_kernel_counter(&nmi_hw_attr, -1, current,
> +						 kmalloc_kfree_nolock_in_nmi,
> +						 &ctx);
> +	if (IS_ERR(event))
> +		kunit_skip(test, "Failed to create perf event");
> +	ctx.event = event;
> +	perf_event_enable(ctx.event);
> +	for (i = 0; i < REPEAT_TIMES; i++) {
> +		for (j = 0; j < LOOP_SIZE; j++) {
> +			gfp_t gfp = (i % 2) ? 0 : __GFP_ACCOUNT;

One thing sashiko pointed out [1]: '0' as gfp for kmalloc() is
unnecessarily restrictive. (it's not kmalloc_nolock()!), it should be:

`gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;`

[1] https://sashiko.dev/#/patchset/20260330120517.104743-1-harry%40kernel.org

-- 
Cheers,
Harry / Hyeonggon

