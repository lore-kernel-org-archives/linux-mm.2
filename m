Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732F8C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D2A6B0088; Fri, 18 Sep 2026 17:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E276B008A; Fri, 18 Sep 2026 17:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BE46B0099; Fri, 18 Sep 2026 17:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C8F6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:49:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BD7E140116
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:49:42 +0000 (UTC)
X-FDA: 85228225404.23.3AFC785
Received: from mail-qv2-f22.google.com (mail-qv2-f22.google.com [74.125.230.150])
	by imf01.hostedemail.com (Postfix) with ESMTP id B067B40006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:49:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sXszNLna;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.150 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789768180;
	b=PNxDXccLMiX0hAGeKuv+aiRG0NrKaD++MdznCnAwl3mplNrSYfeiDe3bXTlJymclnM1V8M
	4udAJpysNTMer3agBgvSSoNIrtSEriBoo69ruwP9LNUbsMbxnAFglbGbj6NmlM+PR2rTid
	IpFJ3Engt89QXmzHNQslDtNyz4iPHVM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sXszNLna;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.150 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789768180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBAPd36PjG3FCsBphgth6vU0KC5q9QsBR+dApbvK9Fg=;
	b=vyMcGz8yOsNxdDSfb6ze2OQGckDuOiPtImCE4UmDrKClrF1cgWAgoHcG3TC5romZHMn2Im
	sqOG4vmD2zn5DGBfxiTdRIO2FP3p4Kc60s5BI4AuDYXTODkOY9NDmFit29V8jGrXBJPOa1
	pv8jZUURht4svjJdWxHvHC0+tGnnfrI=
Received: by mail-qv2-f22.google.com with SMTP id 6a1803df08f44-91205165f71so8468876d6.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789768180; x=1790372980; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GBAPd36PjG3FCsBphgth6vU0KC5q9QsBR+dApbvK9Fg=;
        b=sXszNLnaou7lbL0n9FiYcgM2QzHLQZ4Nqc5oEXOqVOOirtWfysckZnm88V0ZkgPWiY
         nlbNNXY7eEOm4TyBs5jARZZTEtjXlc9hUxthO/i5h+TlDJGJSCzfxiOLsvrZRUE6I/4U
         DckzGp2cZ/LeK2Pp87dns+AomMR+NogvxOPhRuVJGrXrTQCvHuIdhdBui+72zuL/BP5a
         VV4FFv9E8Df6GYdFYthBzHRyBz5nYM1FfdTQ7ECTQMMDnDkSiVSmsrwnR/qTj6M4GPyg
         nT6yUDj0EVUvx1zPRbIJyza/YvjVddi2mbaIx2FE3mhc8mM4xmlqaTwZD5VokWFzBGdI
         XI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789768180; x=1790372980;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBAPd36PjG3FCsBphgth6vU0KC5q9QsBR+dApbvK9Fg=;
        b=MeeS7ttNisqyQfyuJKi6jFE5jXEHV5kGtwgYpaiWSEKuEnSz7391TOENBNsr+o6kz7
         Zgq6xlBQ1kttCZnMrtbnM3aXXtzsBIS1uduf4LSy/uj4Oh4TscLpUX0+tlJ5kQ4GUL8/
         3KwGulH5MvIJyY+TGOlyNXkZjBjA7XZ5oeV11jpoOvt6C1m9lhWI9BN+fS/06kzoB6VG
         ObnO+zbXs1kRRhmeG/TKorvlu1XpGcdZv0N9gBQbjm+voWVrlf3O95b7NVGZ26dUms2p
         /XdoHzFAXiOS35DnQfaZ83HZnm0l9JXrV83AP1L+9bi//mJkQHaGuQVNu5U2DyMy9wrD
         u9wg==
X-Gm-Message-State: AFuF++mr9DxniwKxqKMMy+DbHPAPK5EHjx3j9KCS8q98qS8bUF/0SlPF
	Vnir3V8VO0cMm6KvGkbA2Ma8FyDJzJKyKnKVW5GpaYR47Rob9slIA+6zUrA0eO7Aj9w=
X-Gm-Gg: AYBFou1fErHSsKxM8omuYtluHGj7gwq7979KSUOeY+v5q0ffGJfznr8PF8PnVPjdKnS
	1Tni4wUzAB27u7cXI9QwkxVGhwNyrrsdtlKuN8vXfvIsIz/ETuZk5T6TE3WsY1d8theKv8U/p5n
	B8+b0P5Dg5SxCdAqdQml3KKMu+/IMMUN1/WE07ysB00QJ6RyWxl4UdlYyDPRzICQLtRjV+bDMQi
	sqhcGXHUa2E9rwSZp5/QB7u7sBxXpwVK2Qsd1BKt5FSxol5/O/9j+GgmUu5okEWVNoMZApakZRa
	/D/X3TQRfNgtEWvMjUPgFOQg/GR0+PI6frAha0rOUm5r9Uw4e3LBsxP28TCnVMDVfNucRETWpUH
	9PDDM1L60yAKfLZ840qfd+/JJIXoVZ66Gg8R+WYd1UA2bYJGR5DFDdrkDFllxIsrTYzfffbu4tc
	uOR/L1dI7OmbrHcE+zGvkZAWVXsDNZueChLNPZwQgykPjHZaN0+SFX/I6DQfrVXHiHKeX8BptOV
	BiJI5WIwuy8Xm+1Z52nsF3/vbHqNQOtB2oUCnouheN//686UVFMKXQ=
X-Received: by 2002:a05:620a:708d:b0:939:85e4:44dd with SMTP id af79cd13be357-93bdc71fa8cmr573128085a.36.1789768179752;
        Fri, 18 Sep 2026 14:49:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedaf3e7bsm43010485a.30.2026.09.18.14.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 14:49:39 -0700 (PDT)
Date: Fri, 18 Sep 2026 17:49:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com, Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm: refactor find_next_best_node to
 find_next_best_node_in
Message-ID: <aq2wXTblglrP6F3o@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-2-gourry@gourry.net>
 <a817fe59-8549-4e5d-9ac8-ab5cc9e214f7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a817fe59-8549-4e5d-9ac8-ab5cc9e214f7@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B067B40006
X-Rspam-User: 
X-Stat-Signature: dq455435xgu8f4ibwkh1hwred5mcxqp9
X-HE-Tag: 1789768180-797359
X-HE-Meta: U2FsdGVkX1/yT1vxofxJa1N7nUGFAb5AyhtcRK3Cmz6ZcUni9rsMgTVUjWXPhOJexry4EUT+U9AE3IIzZkoUqDZ0bNwNHNnfp7Cauu1QCtMUsBjZ2+alarUwr0orfbMYEuRSXYc0F+0dsL9Ct6lu/IDCP78yrOqji2gJYE6N5BaZn3b3CuIhb21LgtD0WH3N39H9w8m+MITpcc+8vSuwXjmBOOd7BYffjbDX/tzW3fW/X73ARC3nDpLipVYXGAJLGvF7sDgkpcZPF4BIz+SOY29g7raf2RNfsto/J9NtdEciu4d3qpGzwuwz+k36AU308W3CqcONIMU1joEfp/lBheC3/USrQX0bWZSxNxqywvvp+dtvd3YSoV05BzUTBWl1U0SQTV6ilecHBNAI47v0gHTQn89XLtPEDhgYNWFj9jqXCt0gzX0u/Z5QxRXDesThKhOpc6azz5EtAMvS3JqB0+QI+alshgmMnsYF1kIlbCWC/ygNTC17WrcTA3g1M8RxZk6tUvkSVx072jFv9obV0LEcvj82YSW3cie1YKDO7NwChi7LRl3X6h639EuuIEqjl9wrhEad+adWwyqxXEX37oyozT5LJbXX2Gdxr+KeEWQMHnRuNLmIY1Zo5R3/jIBRXI+zdjFzACTXWtmtx7RKyCZ6RE/PhcOka8MWu3VfloLF/diCHZyPbWsXD/DKDGWye5yWrYBrR25UVcdVwgWn+Us8pQX/CeXtXppBHH0R6HiKRKZht7pVzIowVW4hEDmaktYKd24iIrHzUIlFItO2+S2/V+/YJ5vN18hGQJjao058ottbXYW6MaHPjpR/MGhgbHeCXJEZ5v4ucihFTycsI8sIRiIwMiMzxLks4RvZPjxfS4bLzXshTQ2Jwmk/YAeMIqjXUY0OlmabduL3nnonoG/xXPraRHaALpYFaoRbOMSlOcTvqNmv47osF3NzAA9IoXTbiO2FguTh5aZPAL3
 sx5vwGdS
 jfKUKROFgxoyuCv35zpwjto+T0zWfRccTKbVlNtPRy6rDvx4XpmWcxEmRMX2E8M8Ki+JRgMH96dW9185JvtmcTK/FFuRmRJ6sig3LCsdrA/Py51HNbmbk5jWX8DvOkrrxD3eTXutZEARo9u6cJz1a7S3E2OmAI9iqyUOMFATMd6vY+71nu/iAQO9m3Np/w7nwawBAZ4Fc2C+XP6roOGBTzlF77bw69xichv3WfV52+5EW5ium1PcorEDQwHbCM0mEHJAZ3wKp+wKjrLu2cFeVAXsvew3p3bX5svN59yjQurcwhkqRm3EqjT7e3/1zj8/9C175i50XtWhjCkDAxVrcFGVPkKcHXseqZTNbivkaNNHqxrTcsvZ7fWPx3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:42:12PM +0200, David Hildenbrand (Arm) wrote:
> > diff --git a/mm/internal.h b/mm/internal.h
> > index da14c56fb24e..1519dd21a900 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1133,7 +1133,8 @@ extern int node_reclaim_mode;
> >  
> >  extern unsigned long node_reclaim(struct pglist_data *pgdat,
> >  				  gfp_t gfp_mask, unsigned int order);
> > -extern int find_next_best_node(int node, nodemask_t *used_node_mask);
> > +int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> > +		const nodemask_t *candidates);
> 
> Just curious, for your use case, wouldn't it be enough to pass N_MEMORY?
> 
> Or do we expect to pass other actual node masks that are not derived from
> node_states?
> 

That is the base case today - and in fact that's what's hard-coded
in the current logic.

For the private node series we will pass:

ZONELIST_FALLBACK:  N_MEMORY_GENERAL    /* general purpose nodes */

ZONELIST_PRIVATE:   N_MEMORY            /* All nodes, including private */

ZONELIST_KTEST:     (N_MEMORY_GENERAL ^ N_MEMORY)  /* private only */


the ZONELIST_KTEST is something i'm still working with - but it gives us
fully isolated pgdat structures that allow a KTEST to treat the node
mutations as determinstic and otherwise unreachable by the kernel
(because the kernel outside ktest can't select ZOENLIST_KTEST).


ANYWAY...

I don't expect us to build hundreds of these zonelists - they are
expensive to construct (space-wise), but that's largely because we
haven't needed to optimize it.

But you could imagine having a custom zonelist built on a subset
of N_MEMORY so that you could do like...

for_each_reclaimable_zone(z) {
	/* Reclaim */
}

and hide all this nasty zone business from other components of mm/ that
really don't need all that complexity (at most they want the LRUs).

~Gregory

