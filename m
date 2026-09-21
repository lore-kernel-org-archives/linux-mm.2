Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7038C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 03:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782556B00A1; Sun, 20 Sep 2026 23:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732356B00A4; Sun, 20 Sep 2026 23:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6211A6B00AF; Sun, 20 Sep 2026 23:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E28D6B00A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:30:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFFBA1C2CB8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:30:01 +0000 (UTC)
X-FDA: 85236340602.09.EE4A5D1
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0865B40002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:29:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=trDB9T9C;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789961400;
	b=rlBo27e4WRiqgo1D0B3HmOUAO/syDHquzwIVGcT1ps9ifwSd6s8Pum0sOaUuP/HqrZP8hO
	c2fANzcnNaCrxCQPXImdJ6bVeQYoX5X1+Yfm7j/1S1gDBwH4kPsxMHBHRN6HYzaZRgQ3pE
	+7Ei40g/sY87Ig1ysCBSejweUMfTGgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=trDB9T9C;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789961400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycUlz7DSy4nva9AM8PqQHd06zeVWx1ZyueB3ugH+fHQ=;
	b=sVLv2glHdwmoj1kFB/nTyUfg4zFUhsCWEOLuKQUW3yl1zvTHKBzJpHDtyzuhqYFP1iuAbm
	jFWvl1jeIP1kE5KbL7kxYdh+uvUD5hl4zgVwNEiSDDF0Dhu42E+lCA39I7p40OfqYxKrtB
	67+B1Ev10EWb4Cj6u+ems4ApxJcghmI=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910a0cefaso229795885a.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789961399; x=1790566199; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ycUlz7DSy4nva9AM8PqQHd06zeVWx1ZyueB3ugH+fHQ=;
        b=trDB9T9Ci2idgXsLxdxNYvXxqUyuRNTQ0XxtaxBR0xcBNmmTuivpDpPaM1h4GHSd6f
         /ouRo7aG8xciVG77ps61tAokjwOx9I57PNEnXUl0F5PGu/+fhL0FjFyaiA+Vc42GGSUa
         Zkkamae9il4FoetlelI4AUndnBRUZxBxo0fvv2RwnsoQIu1hLujT4rngcqcssvLKjJy6
         QTy1kZiueilg0JRkowXG6mqUpnxSTEUq4HSIthdF8GLE9hqUb2kPsXV2oGJfhAiXCzqv
         stWjAa1PpXp64Zm8Pz/ijt/ArEPR4r7FJVamU1McrY+EPG9uFAVDy5Pld7KFp4dO+O9n
         LnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961399; x=1790566199;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycUlz7DSy4nva9AM8PqQHd06zeVWx1ZyueB3ugH+fHQ=;
        b=YWypwY2HqE3BJ+EQg5CbDAkC9827DUORSbXAQOKEUOIB0p+T4wXIUPHgj9cDNt+ddI
         9Tp3qpicQC+1ALE9qBizd4Uxyr/CiQzXBnSMRFZICwOXaior5nwHxvIA4n0h07e3SPC+
         HJzcOxqN5N58edqfMUgCxjopiE5Ey8WiJjHkdguEP/xT6s5mwBeYd5uJl+czNEBmxN3N
         jEC6UGk5UTLEKi2SASy6xc/ZlhVL9K1FdqnfCcWBUEDpdek9LKG+dFw36gUkI39Mu2fa
         /CYiz/idexbZp5F2+PpiHRLqU8WdrZbv7hdQ5xN/ibp0gzITY7yhOlcGQ1Ynf1ZXhzg6
         P26w==
X-Gm-Message-State: AFuF++nINfDU0NRAQ0S2OZcR/xFyn1Wgt+CUpoLlWiVQJEhY0ou1DqFN
	o3FUNQpo1+6fGYSqIaclJj8Vupm2XDi+S8/QkuzXY9+ck2vKQoIqQ9ZRUtGzL+Rt6vgoByb6Ciy
	QeEXb
X-Gm-Gg: AYBFou3Ez/b2Qhi7bUv3KnUfRtISJxUqr+zMa6UTksS9DgUv7/FwH/vxtwiJXkfUuAa
	VTrsLgthdnc0L9St6j9Du58IPj/WcCyFzFcJmPZhQskh3uMGzrXvuM6viWsepEQlKL/CN8WV96b
	bPITpVdi7nk3jJAeKW4GlFtSbzMS1+i90gugMOADzXeDrSLV3zDT2a/28NusneiAy3d5k6J9kDy
	4CzsHOQbdVs5jJG430x8FtAndiHzNiqu46tr5SYw4pl0dlz18j+61+polGTXwPrrfmyBfPmPIoi
	gaBNBgKuWxnI9bGdNmsyuCZtYnPzXhwUM2Rn1azaaQP8XDv3XMKyUZuKMoMbpAO/G0cBZ8wTT5i
	db41P/bhj4qJjt27bSvqiL2ihkcAWvWokTXhUhF+tJ1307gEXZdbzg39fmxTsZftIt11OEFTorp
	cEtmotpz2HG0rwcnxQWx5+r2znuDpex2JmS34Tu70BiTv8AUIY4gkGTMMOzDz6fQQZD/+KF2l9w
	Dfvk51XSYuc/ORbWn9vzhnSKHjKUgPThHraW4fUECdxw7lpxjcY6Xc=
X-Received: by 2002:a05:620a:28d3:b0:939:1d67:2231 with SMTP id af79cd13be357-93bf56f85fbmr786905685a.34.1789961399140;
        Sun, 20 Sep 2026 20:29:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedaaf901sm553769785a.21.2026.09.20.20.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 20:29:58 -0700 (PDT)
Date: Sun, 20 Sep 2026 23:29:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Message-ID: <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0865B40002
X-Stat-Signature: ffojgzh87x7ynxr386uo1cewoxg346u6
X-HE-Tag: 1789961399-185667
X-HE-Meta: U2FsdGVkX1/yFgihqI5CDASLzDrNExgoz709+bUHbHdacECp8H8YqN9NdV+6FhROs5l0N0cgHZ7iUF8YWUGzLmaPPbiilgszQvY18yAHeZjvWzv9JjFzn9gtY3X1udrQmUqPdm8yFC5++RlW4pmmvhaz6r+DZGCbINZ0G61tO0Jmu/vI0bxP5X/4D7dnCiLst4rs+J/rZmTEbLS8BUS0JbQnIyCBzEmYDV074Rx8i444wyiyjnffyxEgjzQpogrFBengR0DkoVZDDrJtNFLFrZsRe2uGk3fxU/RbKKZav/JC0+yyJLJLwTTuDzMrGcKKX767DrEizQNYkI5bhPZFgBK5Myl2Cv073P2S7mx3fDT9BK3+hP2vAFDA6XH/lCdKMNRLU5Ms7qeAUemJBmypMurhoUK0LHecfB7SGxGS+mzqO3xhZtbyW3zKvRhRBoC/Ub1lSquqo3f2Uu+dTJgDT1pkk7lH4CXLeZH8v8apaHOvddOGzT4b1pMBouC2a0+7x64+4OYjGNQIA7847D3poTC31b8Qf0/AdeiPFRM1G6IeOewBi1R1zomVjABzClnWHI6AfTo66h/pQI0VJVzcilNEq60a0f6HNZaCk7j3fXes7Pw8AimGkCB2gM5yI/AehD/tl5p95O/Q+stONFHzY7CgPW3y++NPBfLMUBJysSsOVBUiWW1Cgey5Z2l+uxj0e6zHUGkVBVFsOdBwDbpv0yEBHzaKMM4Nc2LbvCKbZnemhJ92wy8A2wKlKG3jl21D7lKZlJpJ04aH/OKV2I3s5vV9HmOfdv8XRtrs0hBtMSjp8UruFDaDc2aRiHYAZOUMCRlHbs9gzMFyONh7BuQOleX1+X8P37eCJPcZ8E5NEtLEYxmQx1PgbfWU/RTebg3E6Dx5MhH/XExkyp03OvPKgZl/6cfGJXYB+msoDAgIDaU3MQi55ANPNh6vwySPRdkMEjsRGY8xOk4yDISW/o+
 dU95I1OR
 YSL31bxk9jLBOd0nSpeSOKPDiJ4aFIpYmFO/boAHMRGgIPTvk2Rt1ubkEO4UlPizVjYwo08g17MPJHNT15bu0W0rm3+iXY8ue5CVEXm30xyb6kbHGwLT9/Lrb2aUchbjaiGpSiW59YRNgoXBS7lIvI++YqnPETuGFP5b7PwQxwFzfAGSbjT68vBfgqE0kvtgCNSMCAhNo2e1DcJ4o2Fby48PON8gNPDX7jv/0iANfM+hw6SXY4Tbme65P7LIjZYYjRdRlYuRiwvNT0KXG9kPeaXTBUmatxLeXCRrfiI8nGGHadNoClEOsfs2ehjFL4Y1XSf/rvR38J2WHtxdfV/BrW7dsd0ELl5PS/ABGflI4GELJ6wvRil3T3rh9ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 10:49:05PM -0400, Zi Yan wrote:
> On Fri Sep 11, 2026 at 11:04 PM EDT, Gregory Price wrote:
> > +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *candidates,
> > +				int zlidx)
> >  {
> > -	static int node_order[MAX_NUMNODES];
> > -	int node, nr_nodes = 0;
> > +	struct zoneref *zonerefs = pgdat->node_zonelists[zlidx]._zonerefs;
> 
> Why does build_node_zonelist() need to have a new zlidx instead of using
> ZONELIST_FALLBACK like build_zonelists_in_node_order() did?
> 

The intent is to build new zonelist over a set of candidate nodes, and
it's also just clearer: build ZONELIST_FALLBACK from N_MEMORY.

With this we get:

build_node_zonelists(pgdat, &node_states[N_MEMORY_COMMON], ZONELIST_FALLBACK);
build_node_zonelists(pgdat, &node_states[N_MEMORY], ZONELIST_PRIVATE);
#ifdef PAGEALLOC_KTEST
nodemask_andnot(&private_only, &node_states[N_MEMORY],
		&node_states[N_MEMORY_COMMON]
build_node_zonelists(pgdat, &private_only, ZONELIST_KTEST);
#endif 


> > +static void build_zonelists(pg_data_t *pgdat)
> > +{
> > +	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
> > +	build_thisnode_zonelists(pgdat);
> 
> If build_thisnode_zonelists() means ZONELIST_NOFALLBACK, why
> cannot build_node_zonelist() imply ZONELIST_FALLBACK?
> 

thisnode actually means ZONELIST_X+1 as opposed to ZONELIST_NOFALLBACK.

Since folks are adamant about not allowing another GFP flag for zonelist
selection (beyond GFP_THISNODE), the result of this is that all future
zonelist additions must carry a FALLBACK + NOFALLBACK variant.

The question you actually want to ask is why build_thisnode_zonelists()
even exists - it should be part of build_node_zonelist()

I can probably follow up this series by just folding eveything into

/* build zlidx and zlidx+1 (nofallback) */
build_node_zonelists(pgdat, candidates, zlidx);

And add a BUILD_ON_BUG/ASSERT that forces any CONFIG_NUMA to have
balanced zonelist additions.

But I don't think it's strictly necessary for any of this, and we're
just shuffling code from one place to another.  Probably I can just add
that improvement when we add the next zonelist.  In the meantime - this
makes it easier to add new zonelists as-is (and just makes the code more
readable).

~Gregory

