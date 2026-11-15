Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4056606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oSoFvyOb
Received: by kanga.kvack.org (Postfix)
	id B44996B05B2; Sun, 15 Nov 2026 16:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CB56B05B3; Sun, 15 Nov 2026 16:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32DB6B05B4; Sun, 15 Nov 2026 16:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81B396B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:27:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 167A6A081F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:27:56 +0000 (UTC)
X-FDA: 85438640952.27.32012AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5E1A1140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:27:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSoFvyOb;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794778074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5CQ0U7AMIECPIk9f1fy3cqbdLwZ/RCPmglbZ5ldwRc=;
	b=CNlTXgrqnSFiYj9uNclGQgrCt5owzkvmuFVWGoq+3rcAqIlefRpSu9ch3POZFegLMhkK4t
	GDwn/uSQ+6zfzWRlKHRM48ZRheogxThJ/w0Q8MFXNyu+BAUuVxXS+loZscFjIx3omEsCLE
	1iOb9Za6JELZZOj9Wdo+S9MTnMU7XAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794778074;
	b=tZE0a7TPhy1AxBN2l9KfNIWRcrhi3cNRW56BfxfuEiXrdwK1a6YGQsZnsA0ycATgiwYBpc
	36uCUTPRZoNfSDIGt1s0qkoWnjZLLRiN6FR5e8fLjJJOltfVMMnnIVdESCkKPWWY3CU8Oj
	G5NgGYTayQDpa6TiCmTu3hMp2ZwOE/o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSoFvyOb;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4779543289;
	Sun, 15 Nov 2026 21:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024D31F000C4;
	Sun, 15 Nov 2026 21:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794778073;
	bh=S5CQ0U7AMIECPIk9f1fy3cqbdLwZ/RCPmglbZ5ldwRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSoFvyObHbygpxj3QEGtSb7Kni9B0reawWgDDpdDLlNSmR7kBdl7cp+vSN26EuEPH
	 LupE/ITVZ/LTwrqTakJ3FAG0vaCbBOvS/fBI3jSc/1THNozus1DPBabfz7Bev9ideo
	 ctsma+NBr4JgnPl1vv+Dfwpzo7xi3MD63smVETm2mL60qOepHUb9XQ5RJLPBjl6zyY
	 0vQVvk40LHc7pY0T/zyNtpefbEoCXUL4MHwgbckwGSw6F0zD/qYrkQEUyjE4fS9ntF
	 hQpRpTm3SPggxTxloPSE/yW/vWMSvJ3F9xiZhsQDA6/E1uhdZmScHYkyVkPinCBseP
	 h+omNL4ZopqNA==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Sun, 15 Nov 2026 13:27:44 -0800
Message-ID: <20261115212746.101668-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215843@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fp8c9ui8j3hf1owsbi83bd4ur815k7go
X-Rspamd-Queue-Id: 5E1A1140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794778074-941937
X-HE-Meta: U2FsdGVkX19JaoHwJH23MgdwweAg22p5G7O2pok3jl3ju+toLAnte1j98P0VCAwR8oky8uzBQfI5O10KVb1z1LLZVNb4qwbcQ/n3izefZjgZp9NYeMvxWorTxVx5i8ziBZ3PviJiLKw81pPmgWKcyXqefs5CQzXksOUv0TT3IZwtuYcHNhSJVsddv+9pLvEcaNR4yt1akXBrcMBPh06c3XgQGGGsKoDsq7FFV4qzBQe88vDaO4olfrPZXx0R9U1a4dla88Sfz7ViCxTxnhILSDphNZad2CW2kQDzywgQklzNObfwcnR0aLPbuMRPN1R313e7MdRisTZhjv2lOHUvwFaBIGQMXUqU0Lt/fU+T492f3B1PlEcxo2V0ap7mcQYPdnJos/Ilb11tnm4KDhCAQRoGoQhn061zR39KpEXLgunlJMjttqxoFpXIaVDem3yOVy2/XI6bhNYHpqC8RZsCwAHxJ6qRF1kKO/hDXdonCtnMQw6WsqkNlqjj2AfEBOiVWKJKJx0HsqLjpmAaD4tCuCa3NXzd/ZQwdF+dRC7WIvse8mH8GAogz8+qt26z5jwO/Lgh8AZvbaMvcLRP9zsFDAwCr1szo9YrIYRNKbLVLbdqgsR9E6AjxfKm0blj7AT0uxF0XQgctIp+mV1bRWaNo09u7mYhrSDPPu4toCllY2N52ayNUVQQyAU1RfujyAkXbNTFvAxtn5/6jPe5K6QjF5w5DTzTVY0eCy5H8lMZKH6d/S3Zf+Axz2Phiv9PvOXr8/rbUGUYiPubf045LwRLbI9RZQwmlGKU6QmfKeri43lmE+MuXVLOtVhgLI56w39faL0nJVH9aEPlc6ApbXru9tJ/WZC52KtGaOC9XenqMMSa7RXdXO5OvgtsrW04d3397loAGKqZX9EbAzbNLAkoALrGkZid4vO2WnJV2pgyUe0wCYkJIcBgzeQGs2BOgfCy/TS9+IGduMgR+JQPIhA
 zE5e7Vho
 cjusZ0jcYs85ch+AuDa5OyLWJcPEAh9rYsZycwBnmbec/s1UgtS0lf8/UabvWzUwTRvqtzp/IUHqf4hZBbTl8XbIF3/QKPo+G9sVSdjB+gMryboXloVnFCnsyFHnE8ReOQ6GDcIXUbz0k6oUBBHmDiBCZmTJdUaFsE0T900ZENLvLfgC7R1wDDBYRjFQ7KIbHsCY7r7dXNq21Zx5roK8wasFP25lBNpzFb88izJAfxUY5WjQdQe1eon6K+vYDgy4+E18gi4u7AW6XPjbu/ElllqDLfhu12c4yt6EM5GSphCCsUTX7fnHf+uCVT9434Vk/Qcma6ssWnPOD8x0npkas3hwWpNwrkHqoGtpDT4U0D11+vR//rg3HQeP1OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:36:01 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] mm/damon: missing report_type copy in damon_commit_filters()
> - [Low] mm/damon: missing kernel-doc for report_type in struct
>   damon_filter
> --
> 
> commit 4743cf0114c7407b0d8b853557595a3a4674cb82
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
> 
> This commit introduces the DAMON_FILTER_TYPE_REPORT_MADE probe filter
> type, adds report_type to struct damon_filter, and copies it in
> damon_commit_filter().
> 
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index ca0135c6f6700..cce7d344c585b 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> 
> [ ... ]
> 
> > @@ -834,6 +836,7 @@ struct damon_filter {
> >  			unsigned long range_min;
> >  			unsigned long range_max;
> >  		};
> > +		enum damon_report_type report_type;
> >  	};
> 
> [Severity: Low]
> Should @report_type be documented in the kernel-doc comment for struct
> damon_filter to avoid a kernel-doc warning?

Nice catch.  I will add the kernel-doc comment.

> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 06b85d00e38d9..c02c7fbc1d864 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1834,6 +1834,9 @@ static int damon_commit_filter(struct damon_filter *dst,
> >  		dst->range_min = src->range_min;
> >  		dst->range_max = src->range_max;
> >  		break;
> > +	case DAMON_FILTER_TYPE_REPORT_MADE:
> > +		dst->report_type = src->report_type;
> > +		break;
> 
> [Severity: Medium]
> Does damon_commit_filters() also need to copy report_type when allocating
> a new filter?
> 
> damon_commit_filter() is only called when overwriting an existing filter
> in dst.  When src has more filters than dst, damon_commit_filters()
> allocates new_filter via damon_new_filter() (which uses kmalloc_obj()
> without initializing the union) and runs a separate switch on
> src_filter->type:
> 
> mm/damon/core.c:damon_commit_filters() {
> 	...
> 		new_filter = damon_new_filter(
> 				src_filter->type, src_filter->matching,
> 				src_filter->allow);
> 		if (!new_filter)
> 			return -ENOMEM;
> 		switch (src_filter->type) {
> 		case DAMON_FILTER_TYPE_MEMCG:
> 			new_filter->memcg_id = src_filter->memcg_id;
> 			break;
> 		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
> 			...
> 			break;
> 		default:
> 			break;
> 		}
> 	...
> }
> 
> Because DAMON_FILTER_TYPE_REPORT_MADE is not handled there, committing a
> newly added report_made filter leaves new_filter->report_type
> uninitialized.

Good catch.  I will add that.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=12
> 


Thanks,
SJ

