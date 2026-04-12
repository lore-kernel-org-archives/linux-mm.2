Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4587E937F6
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 18:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429C06B0089; Sun, 12 Apr 2026 14:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBBB6B0092; Sun, 12 Apr 2026 14:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318026B0096; Sun, 12 Apr 2026 14:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BEA46B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:08:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9A8EBA44B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:08:04 +0000 (UTC)
X-FDA: 84650687688.10.9927F72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB7C9100003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:08:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ryq/R4sz";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776017283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbhRfphS9nGrhDPH4YeRn8fVWV2MwWL9a7GHRSyuFvc=;
	b=JtLB76dbkyubAZEoGMgQH00cBEmzUAPcAm5QpqBeprs2VgsqI16vfRS7ARJEr1PeYlZiGG
	92VU33iwaI8Hyn1k/qv5iJzkI37+vL9MDloKw4fv7ly8uzgNsQmfQnHRoUmgCqEwmDFJGg
	9cPdWRTo9XmZBEd08IC6d+4QL5+9zJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776017283; a=rsa-sha256;
	cv=none;
	b=E1pc4RHQA7ofJb8Bethr7S5o8g1KWayffSNmYi1+j4qfybcKqMzJdmhKoON6qcoYk8iCvT
	0C5cOaXfCVLOTBFdNsPSMWXlhwU9gZzKcXmjT9GzWYAPqQR9cYViiHe4HfGY/O09W2vwm9
	nF8KLPk6HnDJDgLR7jjxfg0+5VQIges=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ryq/R4sz";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A2643827
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D782C19424;
	Sun, 12 Apr 2026 18:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776017281;
	bh=j9bCpUOAdgji1Ws6v3/WY+Lm96551bwnQK0kjzDhHR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryq/R4szgV+5ALXTSVljN9yRPh/6sm8i28Xk+omd9JFIq6uriFlNzNbNnY694jDEL
	 r+ZZYGdmE4iAtn6PJo+gOt27mXt1xbiq7OpvSQhxn+DU5xJ5F8vJrjVaVE905jjCLx
	 NIUBFhTW9zmaCg+974bNluzu5vqbLTK+8CU9TMXxarX73HVQfjhaZd15XcMJeGuDsL
	 JydkGXKQ7fyxZJBESfJxMjRIsJSzZ5O8+4hEAuHRPtyUT/AsMu/3YP3scX77ajjS8h
	 xqLTHXcsA+R69QRD9et3YUF2jx91gX+xVIgQwPHlnIvz3d5yUOUeRKM0xlFhL4LPAw
	 RFL/PUYLVzFqA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5.2 03/11] mm/damon/core: introduce failed region quota charge ratio
Date: Sun, 12 Apr 2026 11:07:53 -0700
Message-ID: <20260412180754.84182-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: iuzuetpyc8whmwa77bdkb3a5jax4prmi
X-Rspamd-Queue-Id: EB7C9100003
X-Rspam-User: 
X-HE-Tag: 1776017282-278302
X-HE-Meta: U2FsdGVkX1+tYT92db9T1KQVjSi6MmrPWmM7pWWQq5loFe8aJnquhGvmKMBSfH3M6EW4ihxgthu87wI/Cjt9xwj1NHepUqM62JYrxUPBoZpkDHycaRkPaM2sg7N/cyoCBIzI0E5hHSPe98hiagxVpSr1OI0jA8Z0PkdwZ1ix63bW6uQ9liRSzLXhy/bsauF6NXWLsF8fx2x897tPUKdlJ7T4CRCuOfa4GwmzM0ZlCxLhek7m18XriJx/Jr8dNbFIGfgiky1rXcwl6BblNE1l4Eglj1NlSz6r49ehB/WKNb/sMsguvQaXbqqfzAXAMt9m5rQfDBn/bVSWGcXNkpMAg8mSThjwpULlYbSRvnDHwrxty1P9jwH4LU90vCPdT+hgixWmn03yZ6ZLuzsz75mR9Hw+EbkhdZWD1DBcSpH1wUG5hkhSt0yWWQvuzIdnb7AvP2pXyJTBUVWtJeBqiKrO48gvgs6JmGia/OCjr61ipijiACrCXUPCUNtkcfY9FzwNBy66ETdSNJGJZ5jN+ycuYDrRsGDofD5I4kqTZf4STaTvfahSzfuFvaIWYHpoy8xgMpuVv1maul6eT5bQ83u4uqKrn+bWsftzV099Y1uFqjyCRBx7jMNkDNpP57zEsiRSm2QYCu9H9YXSWqclUF+w+7ERbYoFh6/FdIKoRbdHUgweQvpuYLM/oHOUzWx7ysGwy+Jwxnql50e1DRcRbgnhPL3OdoZLIQLdlcBpSdNs7/5Ks66COYzZGW6yZXPgCuMo/MevLqDEedXxx3ejrysKAHSVRcLeAcQqDieFe4MbBOaRTCqOQSwveiMYj6nxayV4Hv4cXuwhqkcFfoK7lF9J7+Khf0gzVHmWqv12pXGuzme7y9zNyYeVQcisccq4jPz7I7Sw4Irpt82ztY1dzbLYBR4QG+pLBWGSonV4vVXfRp++X6dba3AowGZlOOJlv5uFDlpIKcSGwt2rTdaKCds
 4k/YF7YC
 UQ4wrc6PRNcYbLEkNaFZbWw9/gypZApf2m1XrDsUpvdPEgh+gXzEVY7eCcxJdwAH5IbjFT9ep81KNL0o9JkqtM44STod1bKy+Y+4ZnntM8HG2nNH9d8n3wHCEkTfBrwnlIDmakJNS7U6i1VjpcYPNh7i54CS8/MEaQLacXaqiMGoNgjv7gFvgHWXVwXxe4YqaEBl4UavYuBU5T7J5G8U6mK+7CFVRvuImmyMg94c6GvhZAcuVkeJDZnHaEIPdS4j/eDgCmBC3UU4zsq/SS//AaTk5gSdw0dAVy1MlOm65a+cwNE1axGUa/50HI88wNKgo6apw7ZViAhFalHBGyq82gsHS2tMUysaEKh8THHtNuKpVXo6OEkCK3QSBeGxtJg2o03y2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Sashiko found no blocker for this patch.  It is just asking a same
question that I decided to ignore.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260412161957.82835-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit 45b2671ba02d19f0991caa536696cde623c0c081
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> This commit introduces a new DAMON core API for setting the charge ratio
> for action-failed memory. It allows specifying the ratio using a numerator
> and denominator to make charging fairer for successful vs failed actions.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2041,6 +2043,23 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
> >  	mutex_unlock(&ctx->walk_control_lock);
> >  }
> >  
> > +static void damos_charge_quota(struct damos_quota *quota,
> > +		unsigned long sz_region, unsigned long sz_applied)
> > +{
> > +	/*
> > +	 * sz_applied could be bigger than sz_region, depending on ops
> > +	 * implementation of the action, e.g., damos_pa_pageout().  Charge only
> > +	 * the region size in the case.
> > +	 */
> > +	if (!quota->fail_charge_denom || sz_applied > sz_region)
> > +		quota->charged_sz += sz_region;
> > +	else
> > +		quota->charged_sz += sz_applied + mult_frac(
> > +				(sz_region - sz_applied),
> > +				quota->fail_charge_num,
> > +				quota->fail_charge_denom);
> 
> Can this calculation overflow during the mult_frac() expansion?
> 
> The mult_frac(x, numer, denom) macro evaluates to:
> (x / denom * numer) + ((x % denom * numer) / denom)
> 
> Since both sz_region and sz_applied are unsigned long, on 32-bit systems this
> is a 32-bit type. If fail_charge_num is large, couldn't the remainder
> multiplication (or even the quotient multiplication) overflow unsigned long
> and truncate the size added to quota->charged_sz?

A question that same to what raised previously.  I decided to keep this as is
in favor of code simplicity, unless other humans make some voices.

> 
> > +}
> > +
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260412161957.82835-4-sj@kernel.org

Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260412161957.82835-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

