Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494EECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3466B00C5; Tue, 26 May 2026 10:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883D96B00C6; Tue, 26 May 2026 10:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A1F6B00CC; Tue, 26 May 2026 10:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 627106B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:50:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CB79120358
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:50:44 +0000 (UTC)
X-FDA: 84809857608.16.B988EDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70112C0008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:50:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3nZbm4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEQJG1vq4rGDMIhKxxeJ0wlS7AcPEZB5ET+d2oh5USs=;
	b=YEFsfOM0GnSh9XcSAGZcEusDiwrNFG7zPjeXVX+xBEgQIksiuyIW3TIQBBlM0cqOlrAf8K
	52cwA3C1T4kHKWKtDnbEIrG0+bM5fM+YhnN/MbLungBUIs1EGY4BHgWe6ayMSO4YBhd5oX
	p0cmt2Z1wpR/MZogG80EIGWSeJZqX7o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3nZbm4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807042; a=rsa-sha256;
	cv=none;
	b=UFUgtpztk7y6lXEXp220mNOfkLRrS2QS6waO5tR0lzLYRe/SKjV3Q4mGBXBuNoFEcyxL/d
	M0tzhPVlBRjoP/h0tuZMP5Nmlk1cbPlEbszuiHfF6W+V9l19FJLrxnyf7u/CBlZsdRph7a
	sVS44exlvNb75Cw+UglldtYnSBqk5Tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F002C60123;
	Tue, 26 May 2026 14:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF7D1F000E9;
	Tue, 26 May 2026 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779807041;
	bh=KEQJG1vq4rGDMIhKxxeJ0wlS7AcPEZB5ET+d2oh5USs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3nZbm4wfDe8twAoPsMNgGCiU3R2/CjmxN+VmSdZhT1xmCleCgJZxsssDCZAuaq1C
	 rMaEvcmzADTfLAtzNZzIUQfIVPXmQOq1jEBwq6d2jCxUvLVHRRPJD6m7hdQJTM2/rM
	 U6YzHFhZbL7EQiD0KXkBxqj/H+TYwEAMEcYyY1a1lsIOA0SvQejW2Yb8zllV60E6sc
	 tAinYJx11XGZbBK6XF3ss8zxu3TzgOYnaF3VUBAwsexBwkMWpWtKEs6+Snib9BlBvw
	 ixAZPQQsKxXKDlHudjO6mvAIKMbP1RfbP/34Qn+jd/5nxqu5EYKI+O4tP3BP5gqDsD
	 J8ZsHkA2n8qiQ==
From: SeongJae Park <sj@kernel.org>
To: "Kunwu Chan" <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	"Kunwu Chan" <chentao@kylinos.cn>,
	"Wang Lian" <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
Date: Tue, 26 May 2026 07:50:33 -0700
Message-ID: <20260526145034.91594-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3d09f6b9cf4a9b275876185f5b234253e7af0225@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a8z1au97ypn9bx65qsrua5kz76jnmdo7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70112C0008
X-Rspam-User: 
X-HE-Tag: 1779807042-696013
X-HE-Meta: U2FsdGVkX19ttQFCh0orqaHCOOqK+IG67Zwu5YqWTRAt1zNgX/CMkgTs9jkjmL0hNAxAV75plLesw2l3dDN2lHHniDOULcmp+L9cyRXxSyj8EhACSaeEK1sLcKNmOYLECkakJF1Z6etfsDRTuKGDRnn54TXsRfF/f2Aot4QIlMswmgQjiNvr0sJPlOJOF7kPggNQ8ztuoGXPI29biV7a0VQ+FdgXQIGLN3zOhATgM7447eHMYWtOVqIxL+GJ1ZCqXIOjJiRE9rw8Hd73ycwApRzjvopMzk/coz22pxVSMBeuYwBeMPKOvOSVvo86TDU8P8HlWy0aoHCR/K6V/sDIUmOEApiIbyXzNAFKn7XfZ/MBZy74I81YUTIEbHtdBh37JCqyRUfRrazPzkJ5ZQM3xx88GjunjQ5wxKkkGkiOabgtAoApwYXmVq9dAH5GVPmP0O6nEX+JPC3DHh6dDdhhUhkurowU5eEpjSBSS5sOgqTOiYJodZxrMuQdfw2akbuRGaLG20fy/VXa6+ZaSuGJbxFghl/TWSQi7ExHnDCsPtyOg9oxfPIOMk0KDtTYmkK3EZNlNbx4DFvh1SQ/dDq6FEQ0V0L9kl18fzIxln/O4dh+P6jad4V7AWuLEPy3xQnTKypQUjaIc/bOHucLp4AeWhFawr0E0BhbTzYK3mbWud7ZGMdmXNhGSN0MrKDprqjck+GgPm2CSwbSDxe7lcxUVh08CM6MT269S1fmTwrA/eahgjubc8DA3gYqZgfwOvH6cK9WCYSUHWI7tCM4ozrOYmzZjLiwz0D5TEv3+wNMtKaxLn7A8OktsF+baZ/5nwpr7B/TwoQS15lqQP+1yuum5DyvkkiUp2IoQq8TKUbDZ96y5J51s9QNwTh8ol9mZYrUURsk63X+r4L0V78OTd7KTOTWBR5Ojt+9xRg2qtaO5B3dQn7hLkIlNKrtilytphaU/utP1k31iXwqllTSnBS
 8Z8DXQZG
 DvPqL1Cz3MScb3E5bwD0/m3EEVCUtYhYd/CfBIbZi0I47qLXD85ICpBVK7IVeytLg36givHbROv1v32CrfflgAI1tn8esDfMovT/xGG9RXSJwCZfD+fs9PL/Lof5FivIUmkYQ890TuVqfjFU/ZI7Olj8KFEu1EvqBENpWuaprjT+BO+ufJSif24T2FMMyOMp3PLSVslMP6nqZH3P2KWtGqif9HsxqSI92bNBLRBjOiaFm8eGEsHwFTOyLfsRUsXkKwpHywWQWGKfsEbamBc5JNcjSUSAl+Zeqz88EoNofhJNd+gA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 08:57:32 +0000 "Kunwu Chan" <kunwu.chan@linux.dev> wrote:

> May 26, 2026 at 1:46 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel.org?to=%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:
> 
> 
> > 
> > On Mon, 25 May 2026 22:48:46 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:
[...]
> > > Reproduced on arm64 (128 CPUs, 7.1.0-rc4):
> > >  
> > >  before:
> > >  WSS estimation: 50th percentile error 100% (reported as zero)
> > >  apply_interval: schemes never tried
> > >  
> > >  after:
> > >  WSS estimation: 50th percentile error 0.08%
> > >  apply_interval: passes
> > > 
> > And nice test results. I guess you are referring to the tests in damon-tests?
> > Clarifying the context would be nice.
> > 
> Yes, those results are from: make -C tools/testing/selftests/damon run_tests
> on the arm64 test machine mentioned above.
> 
> The before/after summary was extracted from the relevant failing tests
> (sysfs_update_schemes_tried_regions_wss_estimation.py and
> damos_apply_interval.py) for brevity.

Thank you for clarifying!

wss_estimation increases its working set size up to 160 MiB for this issue.
Seems your test machine has large TLB buffer.  I think we should decide the
limit based on the real running system configuration and apply similar approach
to other tests including the apply_interval.

For out-of-tree tests, we may better to provide a guideline, too.  E.g., run
this sort of test program with this DAMON config to find the reliable test
working set size on your setup.

> 
> > Also, have you had a chance to measure the performance impact?
> We haven't done detailed performance measurements yet, but we can try to
> collect some numbers for the flush overhead on a few different setups.
>  
> > So, I'd like to have this change. But, unless we have very clear evidence
> > showing this change is not increasing the performance overhead, I'd prefer
> > making this as an optional feature.
> >
> We agree that making it optional sounds safer unless we have solid
> evidence showing the overhead is negligible. Keeping the current
> default behavior for production workloads also makes sense to me.
> 
> > For the user interface, we could add a new sysfs file for the option, say,
> > 'flush_sample_tlb' under 'monitoring_attrs' directory.
> > 
> The proposed 'flush_sample_tlb' interface under monitoring_attrs sounds
> reasonable to me as well.

I was thinking this again.  I still want DAMON to be easy to test.  But, is
this making tests that difficult?  Users could increase the test working set
size.  I'm not very sure that is too diifficult to add new optional feature.
Meanwhille, adding an optional feature for only test might make users be
confused.  DAMON usage might also be diverged and add maintenance burdens.

So, now I think another option is improving the documentation.  It shouldd
clearly explain how and why DAMON does not flush TLB and what is the expected
problems (in tests) and recommendation.  In this option, we should also update
existing DAMON tests to be reliable and aligned with the documented
recommendation.  If we find it becomes a problem on testing even after applying
the recommendation, or on production, we can revisit.

Regardless of the decision about the optional feature in DAMON, I think such
documentation and tests improvement should be made.

Maybe I'm biased, so any input would be appreicatedd.  What do you think, Kunwu
and Lian?


Thanks,
SJ

[...]

