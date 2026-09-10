Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9528DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453D86B0093; Thu, 10 Sep 2026 06:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A2D6B0095; Thu, 10 Sep 2026 06:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F29F6B0096; Thu, 10 Sep 2026 06:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08C396B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:53:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A57FA42EB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:53:10 +0000 (UTC)
X-FDA: 85197540540.09.35F3077
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D1C840007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:53:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="U LGwQTG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EurtyFPE;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+8rtwSHSrI9CyOt3ir8SRov9uZb8NBx1Vr6rpUk4gs=;
	b=cpnFVAmySA4Uc1tgP6VrD+lqTt0fC9uvkf6jhV7hhV1flc+vsP3kZwQbR6dBgxBZaFbu3C
	f4u3FLF2EPg5l4mSOh7ONJJ9f/ffF1g0iUGtKjNcMrepm/oGAmnA0CJcAgDHcsJUQ6XYHN
	gttW8PxJeoNkNQmVYDhTWJEdZqA8H3A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="U LGwQTG";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EurtyFPE;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037588;
	b=sHRaY5l5pBXXVka4DGY+vJlQ4HGsKo7BTf+M7ijpspf6Uca8qoQi0vpHT0iXsati9JSpFP
	YF+JWwsGiYW701UB5Zgsy5xbcl1jmQtIyu5sFEdR+CGAK0/FJUkxIp2wXtKxkboVjgnLDk
	edyF8Pt5tt5Kjnw7JBvpD/oI9zh2SfE=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 9A3D6138008B;
	Thu, 10 Sep 2026 06:53:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 10 Sep 2026 06:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789037587; x=
	1789044787; bh=k+8rtwSHSrI9CyOt3ir8SRov9uZb8NBx1Vr6rpUk4gs=; b=U
	LGwQTGozNl/IPGGjCXuDMOsntcCez3zg/Ha2dGz9tYT3G61pxwfRKRs0EByPsE3i
	gmDe4gHet0V520BJCZa4WZApFYAmztGqny8uYeuH6MSgfe71z/damSS4VimZiisx
	uQSSH7IbN5TwStxojrOoiha0msT0YF4RjZIFsxoonJEnCjSAEyDb4aYaI0mKniQB
	16NEF0NKnM8/CnlF3TIGi5f06y7rNjk4iR9PENFxKXmIoDuoR2XdN/wkii4qp7A9
	9Ev1sZ5MhM/tCDitZ0+KS21/T7KXKCg8+l+QctESd2ks4PVqbOI9BJiBlWk2hqBK
	83qJ3kQf7MKsUueNTyVfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789037587; x=1789044787; bh=k+8rtwSHSrI9CyOt3ir8SRov9uZb8NBx1Vr
	6rpUk4gs=; b=EurtyFPEo2JWSwfUd3esJ0OVwAFP3GtEbaey2gzLSLaSkJcZYpF
	im3hyvwRNti5b56UUztde85TylbNRDdBMb/14oIRnvQEmBTx/KfUovjS6k5HaIIA
	cAXSxeyZjzUqrKxy4bxfqFS81PpXgWqaU4SVn0Ea6NSIHenhzf7v2uClGPgd0Uyl
	YINnbhB432+Rr445boRrAJ117LZMN+nNnxaDMrdMimuJZCVwLUMpfMGiflTuOxx7
	R58WlvuFyl6Tw6diqkp1dybjQvAGKH/2MRk6uvelvEGMzLHjybMbdZigNl1ycEAJ
	86McL9Ltfi2sRcwQRGvLl99xm8Y2Y1p34JQ==
X-ME-Sender: <xms:E4yianSmG3oq4oWvK7XVEmK26ttXq1bXEEykZOHtIyRiCczvXPIJhw>
    <xme:E4yiapcjisVyAccKNATpuSjubLw9r1WC5PlgqSPXSvLw5M8fkj-lZELgGQDmrWGEZ
    G25KUplbXORG1TpgwvN8OrwLbxgLV-0jpc3AdAz48q9xo1Hi7KO7FQDNQ>
X-ME-Received: <xmr:E4yian449icMacN0l0Ek_WlvkH6qEiVI4LT9Gnv0ocDewhm3SIkeEwcZWYk>
X-ME-Proxy-Cause: dmFkZTGm5Ju+9RBw0LciogPg7Z02SsGVTwF8bQ54/MSBlaYiHGVbwMnPgwR4nFm7A5aN1G
    ab90Zq85LRgdUM/dlmRESEm7z20IlJXdxeC6kX5GhjGqwvlB68/Nv0mgLB37gddPMzpnPQ
    vp9rSZz7wN3LWzRxF0mP7S6VPxGBqvdpzzlswY0dXVqVuVn2Z+rEw/6GeA6qrvATGKiYIv
    Qy0DlhDB5aF38ZdmPHO0pPN3BhKBOXVShFmZniW8ukI3HgOl/hVw0fF02ROKLxbp64XEwY
    9Kca43nVc9tLTqn5zCuPcIXBRozBqbzB/gDlgSu6QP3tPP6rKHXjE+bjvXYwMnOtQmWRjj
    pa6OjPgx7sQ5JfXBq2VE3A4gkJiDRh3y77Ml8S03QUzozR5Xqkypwa9U83xSQK3612BPtL
    iAghnJJWMO8Lz+ZPfvgXWY68Dx5JKFsApypDKirsgwOV1X/pVYy4IH2SZNUtT0PtacMv7n
    jPihBak+XGcUxCduNS6qmUnf/qrf55FDJCCKseOBjlNEoEGxdRsf6FZvfOjoGmF7H+izJB
    06oKvbqm5CPP6basFX6LLqpZ4kCLBCqhSCuYbO3o5rNcBxMawrXGBxKfv93FRJk3ndLNYd
    HHCf8INfIhEhclCzHJVDroPuiahek7lEArIWASnZIZVfzSQBQWww/6EUQFjg
X-ME-Proxy: <xmx:E4yianATkPXaSjhj-I8Nr-ewS3NuNvy86-98fHFDzar2UrtxpKe_HA>
    <xmx:E4yiajdwYR0tCmPfEjFxfRUOJkdfAeDr_z0DkKzrTZ1-gIS0W2j5YA>
    <xmx:E4yiasQ8RzkNXaR3ONt44CbC5AfsN8zG6YVBl4iMYBJc78bZwkRq1Q>
    <xmx:E4yiaqkbuVPu5g8_DAWCP1vKZydRQsVRYdbMBsPY9ZBsr4ePvyO63A>
    <xmx:E4yiagwItsHBApP43P-SOVJ5ikHPgxGZ7aiXTyMBNVEWoPwhK669wPhy>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 06:53:06 -0400 (EDT)
Date: Thu, 10 Sep 2026 11:53:04 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev, nico.pache@linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, agordeev@linux.ibm.com, 
	jgg@ziepe.ca, leon@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 11/19] selftests/mm: add order-parameterized
 khugepaged collapse cases
Message-ID: <aqKKXuNWf7lUuXps@thinkstation>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-12-kirill@shutemov.name>
 <162af233-ae81-40e6-8c71-d13a41b5d892@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162af233-ae81-40e6-8c71-d13a41b5d892@linux.alibaba.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D1C840007
X-Stat-Signature: fkq53hchpzj3oth6541czu9t1pf4peyo
X-Rspam-User: 
X-HE-Tag: 1789037588-309680
X-HE-Meta: U2FsdGVkX1+fGMRlQRxoUSlZRZJ34MkYxh0hoKfJCWGn4PB8CjrxnWxOJ5/X8JREoAMF7T0Er0MZK4euw2HyZn1rAIpfktmXW4jTq4bBKNEMkvjwDhv95FbTXf7miaLYJ7FbGLJUFZZkV8vuOQZWmPpyo+siHFhL0gi2jUOwhZ7y/BQsywyTYWjVIS8d/G5DX5QF9sDtFTEdxwvte0mcVU7g1J503MWfi9/FbFr0omOE06b02p6jZqe3Gqt2nEpCtyzExIoj4eaGiUYfSJbjok7uv3O8DjspyRuy5xOnNp8zcyiXXOJiO09kZy80vGqJRHwBBxsvZJHuA//9T0F/u/P/PZZOF36dZCaBe/jVXrg7qjEKivOF4YWtlblLMsQOTE7v6Ha4dOweYq3Oaje9oARF4VNxjrsF8AdUwmsxwr+Ob6R7sR4LHE2axYEgUMQT1j/vI8HkZ0DlAVozI9Hn04kDMV6YmLhp6eg0V9GXDWcWWIPUvpmk/bX8uvyZbVNDtskote2WJX4hprOxMJXWiRHqfZS45abVltpuJKA08J5DiD/gAyPUwDcICkX9HIZZdAmVE8cmfPHW/6Q5P3DK1NLqMW0OMuKSm1mpCrdpZOttnzqf1NvGsXoptT7Dmx9e0nuNDP7U3Obc4paxssPxRiI/g5m4rZZLruRBKMXRQtYG+lIpeA0QE9HHfYLkdwNoCV1phTZFReG0hQGRrXpPg0JO5ziYvBNYkDKrHfPcBpRBmFyR8eS1MDp0oXxavoZJWmAHi9D3TmU6x/7b8ac3MuKSTgfaA+Ww9C61oUeFou1IoXnpV/GS0K7GpNfoyfD+pA3cg8XvbqouuH3VyuGr0RvE+Mud7HU7mxxGM/KIPLEUf6mIOcQq4zDYFcFUtup/ht2Jo5QgXBzATS3DAWRcdhITbOsf0NnM6T+70Y7VXcLXs//3dFh+L+6wJ9cHGO5CUbU57xQy3ID/RX5Kxbj
 glofxxMi
 SnKajbBtp+LHCtDl6rlnrgfRMEEOcjb+bMSufS+wV0LYUUt6zhPBdBkgvem00ZuHV9cwH0q1CTrEGo7WGHn4vvoBfTPtvVBTam3FSG/hqefCT81HHoIrwVaI/NOC3hFKHa6mZPY4Wyagwo1UX9h3m5BJFk8f9tSRjNbBLnDn9UWgX1d6XtJIAUOvETkactkAYZvtb2CsvRwOwLphz+SJBQ4cDSy0XbXDzufeaeo1ryAzf1UL3ul019+iU3bMgHqhMk4XxS2EGPq+iy1CN0V5GUcCkYjT83VsbjbddebA3ivkEijw0xddtJJS/mdLiPiXQ0T21E1k3Sv0QUdmBu3P2GCdZKVsmiqnC2bFRRxuGdwA7u7zp8KxIWUfVVk51F+J2R4HeEtyVQkp1qkWawfN0/14r3dRXGBPxrlK6rgRMNvG0sFHFwBwA9U0rx+G6Rvkl54ga
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:59:14PM +0800, Baolin Wang wrote:
> > +static bool all_windows_at_order(void *p, size_t len)
> > +{
> > +	return is_range_backed_by_order(p, len, collapse_order,
> > +					pagemap_fd, kpageflags_fd);
> 
> Like I mentioned in patch 8, you can implement these helpers using
> check_large_folios() in vm_util.c. Then you do not need to add new
> 'pagemap_fd' and 'kpageflags_fd' variables.

As I mentioned in reply to patch 8, I don't like that
check_large_folios() keeps re-opening file descriptors per call.

> > @@ -1375,6 +1569,20 @@ int main(int argc, char **argv)
> >   	parse_test_type(argc, argv);
> > +	if (mthp_khugepaged_context &&
> > +	    !(thp_supported_orders() & (1UL << collapse_order)))
> > +		ksft_exit_skip("Order %d is not a supported anon THP order\n",
> > +			       collapse_order);
> 
> This check can be moved into parse_test_type(), where the 'mthp_khugepaged'
> parameter is parsed.

Patch 14 makes -c optional and turns this into the code that builds the
list of orders to run, next to the "-c has to be above -s" check.  That
list wants thp_supported_orders() and belongs after parsing rather than in
it, so I left parse_test_type() to the range check.

> > @@ -1425,6 +1633,10 @@ int main(int argc, char **argv)
> >   	TEST(collapse_empty, madvise_context, anon_ops);
> >   	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
> > +	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
> > +	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
> > +	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
> > +	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
> 
> These test cases look good to me. Thanks.

Thanks for going through them!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

