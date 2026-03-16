Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCF9F53D67
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965AE6B02D6; Mon, 16 Mar 2026 11:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2F56B02D8; Mon, 16 Mar 2026 11:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829856B02D9; Mon, 16 Mar 2026 11:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E69B6B02D6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:09:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 372C1C150B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:09:14 +0000 (UTC)
X-FDA: 84552259428.17.6F99FDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F7BC160004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:09:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfDufog2;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773673752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uogRjvtEgOO2f7N2/dIOk/39p5GeHI9MKxecpWHqq1E=;
	b=kyCehcEZexSJpm1gsfm3+Pcci6VP+gR+kZYXIgRfG5/noocRSFjKaCNtb2BG9j8wj6XO3i
	33XtekSamui2IxT7flRuAeQW3Bs/55TGXmDitlvcO81peTvr6nfBXXXlIMHDZxNmaNO1bC
	B6HhcUH1+GSL/9RjQFGk7wRNkB4QzxE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfDufog2;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773673752; a=rsa-sha256;
	cv=none;
	b=AIK8WRfz77rpZ9Uru6uSIa26uTVhlTPMpOAP1b3i0pI7cJwNeuzbir0j9dkIq+pc0NW/ue
	o97nyeR+dxWzIPT+DQ02zF+aZsXfE9ztwJe3yvEN1adCiw+dpxTBD2pNfEiE8sjl1Vr6uN
	lK5RVDTJSJ/V9aF0Ux+nAq86i4KUCsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D766960018;
	Mon, 16 Mar 2026 15:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DEEC19425;
	Mon, 16 Mar 2026 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773673751;
	bh=HPF/v3WoPFEV24nIvaRDll4p1q2/19OPsfrmQMWB690=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KfDufog2r8xXqjzM5tsu3ZcXwn9SVxnsslaBKPpbuBvGc8Re/xOPVzbund88z5qJy
	 z9YxlOpKgdu7FTofKrrMAcrvPe5emwpcKD4iJjy0SvmZqMuRKNMGUnDRlHbrZ1gcJs
	 Gxaq+Mqby7cMoF6i6uIKct5/SzpVhC8p/h5KaM1V6LaKbQpSvAccSmtSqOYaW41V9i
	 Q89Ya7EdrTLkGvPmDHbCKpWybBGFzJnkbChMSMEwVQhifxhYWKgBlEYL/PrPz6aZj2
	 rroC4xacQGUPW5DvvUpM+bh2N6p2FNLiFnZhpMDLyqpHgbJW4RkNx+leuqx1BwFHtY
	 n82jE/3J6GUvA==
Date: Mon, 16 Mar 2026 15:09:09 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
Message-ID: <abgc5cn8Co9ft0Wr@google.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abgbx0YXbxu2mAHU@google.com>
X-Rspamd-Queue-Id: 7F7BC160004
X-Stat-Signature: 5h1nfz8reo1hg6yajtrbheg6yte7uzqf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773673752-754831
X-HE-Meta: U2FsdGVkX1//hS1/XwcFUuoo0nZY1Cz5BMj/gSaPsIZP+UFm0l43Qo9Cw+4/9omr18VvIO/H1ebqzOpO0q1x2XM/Za0c82mH93E4agL5WH0C5W8mopXJrwSTpvMdcb902C4a9sjvHU5MMDRTFnRC1hVChjWj+Mz5m5A2bSc0w7IDemTBrBMRbEMSxruk0982L+Ui7vIxWHfBsYVbw3ZkrBqH9GBnqHLRKWcCdic2W2yTG6JC4o5Ynn/Iz//Db6ITzJUVA8jpzoN+zAxUe4hByALICBNhcC8QMny3hKyrXwVH/h/PIW/7LBrVP5CFeFoB/OMMaXMqzIT3fnElRy6Hb/DUxs/qDoqH0zWgO7drPr6tlSDfypLI5BH/1S7HnmFgd7PQIht6xzgQrxidCdMJY9x5me75JB+ox7gPThkuD0xnmPAmeU3FUWHIJHVerNJYqy4VDOL7hPEes3ni81+/etey57uKKayoLpvyUQHm5erzqeDQoC83PWWbR+Xhm4vpJe9MLz9rcATPeSLM7Jza6Cxej44RjPv0nMGlmpeKOxaA+lsjvA1WnOeWfV0ub5lDJ3+ZwqzerEo1FOuUdrGFSiJ4KleDfrIWboHhOyA8KEO3t5DMFzp5aJi46+QzntB5FQRUEgn3uOQI4QdTsYWta4NLDNt5UPEGnpCOo4I8ew3W2uy44kPBpo00UzJPiVIIiKBl5fqVdaJ9v8Qo0EUKCqVX1Ak6GwmCcolnPog38Z1FwsYvx+M7Do/rfWdKeU3v2wdD4U7+RvzBIg59h61agtwcCK90nflg3xD7SmvKJdJBBIM4uxcLXhB9qWz91GOLQBrjUJnxj7aCR59xftCqmNTN9pxJkzeLyKM6fwjGnkAytlj5HYgCv729caEW+jVtOYfIEr+hpt32vpfCmA03SkT3xK1HMUXoZ0Kw+rJL40ii7i9IRVm/vAo8uVsarbZDn6N7S3C01x7e56s7Hjj
 3UmemmbC
 QxwEEEbMdhHnp3B8Rze2970Jlq1lww72daxceAGfSfT6dY55RIrVfb8C7mfjDmx1KzIqWMNEz4yuoQJ9wNiAXwunA1252/yWyOnZyd1F180VCvvF4W6TEKi9/8I6tKHDCc9QXY/iaqZHESXWlHT0rfsp9gmHvxGmK7V8zRB8F21K50BHKIhVoxXPFhI621pUDHxRuDgLjuwR04pXG0yFZPNZWA0be88kWXptWByvQLLLIcRNlwh1DXzU8q3TiIwNgAmFNIf3DmJTGF3gH5+1+27o+koePbBf1TKeoSZ09rB2yP9Skj3nZtFCdciiLWpgvxYNY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 03:06:32PM +0000, Yosry Ahmed wrote:
> > > > @@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> > > > return ret;
> > > >
> > > > acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> > > > - if (IS_ERR(acomp_ctx->acomp)) {
> > > > + if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> > > Does crypto_alloc_acomp_node() ever return NULL?
> > > Looking at the error handling just below this check, if this were to
> > > actually return NULL, PTR_ERR(NULL) evaluates to 0. This would cause
> > > the function to incorrectly return 0 (success) instead of an error code,
> > > hiding the allocation failure.
> > 
> > This is a good catch. Just to provide context, this patch was
> > introduced based on Yosry's earlier comments in [1].
> > 
> > [1]: https://patchwork.kernel.org/comment/26282128/
> > 
> > crypto_alloc_acomp_node() currently does not return NULL. However, it
> > could, in future.
> > Since the rest of zswap_cpu_comp_prepare() dereferences
> > acomp_ctx->acomp, it depends on whether we want to future-proof the
> > code to handle a possible eventuality of crypto_alloc_acomp_node()
> > returning NULL.
> 
> Hmm upon revisiting this, I think keeping this as IS_ERR() here is a
> better documentation for the API, and the incossitency between this code
> and acomp_ctx_dealloc() is arguably documenting that the function can
> only return an ERR, but it can also be NULL-initialized by zswap.

Also, sorry for leading you astray in the first place. Looking at this
initially I thought the inconsistency was confusing, but looking at it
with fresh eyes I think it better documents the API and the different
callsites.

