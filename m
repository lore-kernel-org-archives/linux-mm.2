Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8381E606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0HhVEsC
Received: by kanga.kvack.org (Postfix)
	id 210006B05B2; Sat,  7 Nov 2026 16:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AA46B05B3; Sat,  7 Nov 2026 16:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062006B05B4; Sat,  7 Nov 2026 16:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 865E36B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:06:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 090A3C02F3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:06:20 +0000 (UTC)
X-FDA: 85409556120.08.C91EB4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C86B40003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:06:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0HhVEsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794085578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKOpXDTka6zsRI+o/WN9YYaFvky2KJDqfkcQZqbSnuk=;
	b=vGBaLThdr1C22z1dGFx7XWRVb5Y84zjdHaEOp5XtfhFmlZGYqJ5/mfrd/1emSkml24lKUN
	P3VnTDKBSq+tUsDHI5zYYRLprlQz/LPLPeKhh5hGT/QmXgJ66ctRcMb6xQSveSlFc1EXO7
	pubNLwgqBI8ynyLH7mP/hN/6f4Uo+v0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794085578;
	b=lNt3RhcyPBxLvZKP3Svuw4K2Uac1OgvVQHgPMWx3iYvUtENIwna7lMK2bfgj8kjLYu69+J
	JxN/rG/+huqX1utLLUhbpqEJ84NCOhvafhCriv61lCmfV1c1WWK573yEzaD4l+0zPY4n8a
	EuBfm7qbpEM6DZn9JFSwHXHm4lKWrh0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0HhVEsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44CD940867;
	Sat,  7 Nov 2026 21:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AE11F0089F;
	Sat,  7 Nov 2026 21:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794085577;
	bh=rKOpXDTka6zsRI+o/WN9YYaFvky2KJDqfkcQZqbSnuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0HhVEsCCO989RwnIKRu0YCBkukRW5SoTDDJrsDOmtPFdYdN2GP3+kmQOBs/AVd2X
	 AWDWlh/spnyvqU2xCNEKf+OChocFfOc+KgynHefki9QebPyg2I0M1cSmHpxh47KAmg
	 TonPYIIqVjVMD/jQ2c0Qss1fkKnJVC6RMdMi3r3etcVgzOP9p0bN3fezOHkGG9jkur
	 gxD9w+LzkBi+Pm7cSjzHclviioQ9qNXiKdiIy/F0L3uG1ApFCvXuNgiBnwzbkjS8M7
	 X2qH1lzNWuifeXlfzVs1X2qemCMTpWB1YLyd7pGDdEylhXmhjnreWeOZyMU8KoOtVn
	 Srr38yUNYRbVg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 13:06:08 -0800
Message-ID: <20261107210610.270916-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203262@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6ef3whu8wwikxemzh4c9446unstr6ja
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C86B40003
X-HE-Tag: 1794085578-377972
X-HE-Meta: U2FsdGVkX18JZv/1NskjpwKCunaqpM0Q8rKXg+MLm0qF6eS+XIKUksHWsQ0ZRiBclPvgObqQSoqqdl1KZrFQhZJzekCaYaKh6MHhGqmytzqSFqqVD1iDr+Ngcmqzp5/OcnZRAZLaz9v7PgHrsgayWU2BvFXFpYD3g00yuCCHgqvPi5EXSoNnYTor3wPdzullaMezL4ce2jBmx0xaFEasrTSpuNaU/CyvF+VCds5CmzHcOpa93eHbjRkCp008kbbK8As7nhz4LQlyTMp/uDAtAv6HjYBa/RlrQ6TbAW5xfalv8SpcQVBYosmf1vufVG9XFQCwmwuqRc7F+Z06k2TFlmDmwyaJDVqFaTZFOCBwFgpdZItCK9aVFsSUNstzNmyhlXrl8kS9BC2jw1z7/Z3f+faJQAzUL9F68GHjTRl7Izn+fM+Hb76XEnBShEjqi4vAkOHUshU2+HD540KFsOZFp2n25EgvsgC1+YwZpdfLBw/aPVYptuXve8aYBvk1grgFr9byIb4zfheL1i5jUeqi2dAPljrgzfGnRUmZAQlgFJ5XjxVMIqBUXPNqQzti8E9dXoQYRy5J5V13kh4Pjt2Y8iTvOf6jWuPa3IdInA8z6erIVZLro862bN/FxiDN0J8Z43kH9vYZudLa2WDyw4RzhgPKVgRds6cpGgUabzHoztQ26uVHGVJXbtb5LiiHygldD1jjN2aOrTpp4nhzPT8gutgc67xZcp4jnkRPfE9rYrFhbca4w+bCjoxGSguPl9ianVf0kpzH3LcTaw4spWBAAnt7hqI35zaRzQrXZ4pKym2h2QcEcyhu5F4sm+m689Fr8jFOVw838eUsuA6WegYrLBS2KWrZhU7WZ/C8z4S8UTd4i/tu84/aBa7HYwPLCJJRH3VqESpRt8H0lQpb9xUuZ1h2ahE0+En7YvhmOIEDNOwH3CdCkyToW0Tskdt/Dm2hgotyCjeQ904QUPoB32V
 MjVq4meZ
 gN7BlLNHTg25nvHBgjh4h8qpv8vdkuoem9q9KwQSdD/Ph2FpwCEqExtHv2kCEmkdp2ux4QaT2KGnRAo1LforXg/rb9LBBH7gRFLg63P1Sw0baHbBypF5kCKJ4BET+NboIcuHwgJOK4CN/+2UQFcuKJFP2YyLSE2a6zfjdvm7si0KVTHwdPtxuBPV0SOx8snYj5Whdz4CmZCYPbM9A7DiYoDFgL9O2tV+uWWRgelsIvr5ROf8XW96fjY889T5t6LmI+mBhiwJKqQTdegvZq5nBQRg39JBL39t+eYPAEfIPtJrp2sBMoCSjDowvWDmemfy33RH2bmyxWWI1pSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 20:18:33 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon: damos_apply_scheme() inflates stats on region split
>   failure
> --
> 
> commit dd2b638af6fec217ed7123ab31fe119102f17f78
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit updates damon_split_region_at() to return an error code on
> allocation failure and skips applying the DAMOS scheme in
> damos_apply_scheme() when splitting a region to fit within the size quota
> fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 8fa788b0d709c..4c536a9b958e4 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  					c->min_sz_region);
> >  			if (!sz)
> >  				goto update_stat;
> > -			damon_split_region_at(t, r, sz);
> > +			if (damon_split_region_at(t, r, sz))
> > +				goto update_stat;
> >  		}
> >  		if (damos_filter_out(c, t, r, s))
> >  			return;
> 
> [Severity: Low]
> Does jumping to update_stat when damon_split_region_at() fails inflate
> s->stat.nr_tried and s->stat.sz_tried?
> 
> At this point sz holds the non-zero aligned quota remainder, so
> damos_update_stat() increments s->stat.nr_tried and adds sz to
> s->stat.sz_tried even though damos_filter_out() and c->ops.apply_scheme()
> were skipped.  Because quota->charged_sz is not updated on this failure
> path, subsequent oversized matching regions in the walk will repeatedly add
> sz to s->stat.sz_tried while allocation keeps failing.

Good finding.  But too trivial to block this patch, in my opinion.

It happens under small memory allocation failure, which should be very rare or
even could be argued as too-small-to-fail.  The inflation would also be also
capped to quota size.  Hence it is trivial.

Also, same issue is in the mainline.  I will consider fixing it in mainline
first and add Cc:stable@ tag.  I might conclude not to fix this, since the
user impact is quite trivial.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107201001.206120-1-sj@kernel.org?part=1
> 


Thanks,
SJ

