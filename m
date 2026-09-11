Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A68C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F206B008C; Fri, 11 Sep 2026 09:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18CA6B0092; Fri, 11 Sep 2026 09:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E376B0093; Fri, 11 Sep 2026 09:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 726C56B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:51:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC81612022F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:51:17 +0000 (UTC)
X-FDA: 85201618194.16.677CBE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DE5340003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:51:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JK6EuNJm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvaClzPibMX8sDId7DsBxokq538mDXT63zj8aRNKY7M=;
	b=0Nvpslm0dgCMxZT16tzKNJT3LHzeGlfvWcdvgmV9jylvkqhhjW+6I7s6oh5LDdsKJkm2m3
	AjOZWTML17ZH+1dSC96Sgpmo7mAB+OJbCfsQC6Fys7Oyg4UYohJf0xic71CV23mMTscdrV
	WIInrdDmF5KZrrlOT5pebrUrCB1PftA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134676;
	b=tyer0ZtaSqp/DCvkYaLm7Gci/zB1UOTuGklnsDrXVbOtWN2E1aXVHs5n3PpPp+IF6qNcqL
	ogVVcvqAEyPGdHRK9xkMvLm65PJe7lsWZmsEguhFzs8RpEuh7ZukgRJdzNJ7IH5NoGXgli
	tIBbkmKzWAY4y/d2zxbeBPt62rEOdB8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JK6EuNJm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BAE243CF2;
	Fri, 11 Sep 2026 13:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E561F000FF;
	Fri, 11 Sep 2026 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134674;
	bh=fvaClzPibMX8sDId7DsBxokq538mDXT63zj8aRNKY7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JK6EuNJmEr0lM0l1PtHdk05vdILf1KZ3cHgK0LH1/k3ct3M/29gKSqzM5MLwZbHAe
	 1gUFS6ovwrEcu/B9ZWAcXtG9bvRJHVAH5z4f0Yd6I42s3f5SbhyIbGxJoewuXr6FDB
	 dFducW2cgv4lQDDhHwDWxedcTAtQNfEsaMek6YQEPExnKaYpOgoxx7dyd2M/vAG1A5
	 a/mlov04vWmIQ+nWhSaCYLqCOYyiF/6ZwcsuSz3nwv5d9tECM0gUPedD4kvHGFwE9f
	 Zwt60k8LPtqiGwoWswLdjb5wD6pPNvcA+eF4Or99UGjoWpnMO+GnHyhkiL42dlYKpq
	 wtWxeBy/4zWvA==
Date: Fri, 11 Sep 2026 14:51:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
Message-ID: <aqQG5LgqXnrmY1_l@gremlin>
References: <20260911123534.1181501-1-yeoreum.yun@arm.com>
 <aqP29-H0iKl-2CVH@gremlin>
 <aqQDbfMOVasuejA3@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQDbfMOVasuejA3@e129823.arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2DE5340003
X-Stat-Signature: dx65hi3b7x9z51w5q3nb7ximt7rfxpft
X-HE-Tag: 1789134676-100459
X-HE-Meta: U2FsdGVkX19Sqvt7m7t9WxB+HQGUE0RD3GBrzvzYXbu6kAdBXPGLVFzJoQCaEB4LhWoEBEetSwn3And+njsHEcHE+fld7UnKXXIyBvBt5innDHlmJ8KbjFAX+uheIf0vcnYMUd2lXRsUgOqySwV3Mom74gLkPn+YAKF3D3zV0t868KbiLJxtr12l25Pt/Qu3h+2IBIxyr6FQyUWtiCPLXFUOZxbHjHNqLv8up+1OUtgC4TeB6Iwh8rSEiQD5yfVYRr8ckyINN61yA7QhkSFRC+8rcFW3rXHKH8ZJMt80QY1gcJ9mvqW8u9cLcfcEz0gFkOcFrevoQw71CgWitkoQNXFM8UrgWB0AdALeWLXjE/XYf7ZAhKOWhxYgByir6z3it4g8dcsAJW2TC3u97goTRSmovNapYUePEnbOdHrdVTeOzMmi6chdNVJk1nluURuXC6UjP6KgyT5dQJdsFn19gUB/fnLQBWGalxfawP4MzU2711VnlCiPcDPHskNpsOUj1UBkQ+7WiEYYuuyq/U+Uj/kZoSZG/ps4QkxEjXtDre3Hs6SjcCa+uRcdrDwEwpcqm0PncXfQd1fnZOiFoXdzaHkbv0ticefqcqo3/aAmh/0BQiPHTFS4NXnKHIvDqQ645aA3AB7usnFHB2rXH1xmCXncz8idIlu2sZvsJm7FFHN64FZ8+7nGumgXpecL3He4Coc0AoM9VvGSkZ9q1ZJ/CiSW5m9FR6cvAbwllXVgpYjVIV9pgjyNyj8rJBR7p78U4kOE4KnzaWy2G8ArE+58L9ePT7F7WqiLfmJ0MmiIZYn09rUArjVp1IBoYdE/Z2H6/fGjiURjurnhdqyYwZgirnDjMSY3tQf6U8rxThk0y+eTge/ZleyoDf5cFXuMMCf8IM7Z5Rp7e/TWREmnmkyPAc0DrcxfRtEXLCybVa3TEBj3FB29UgFlxRFqo5KnrsZDSrPEXmDksDzHBWLtX3y
 magAnWWs
 TKR8iogHgJtzOufbarRz8hFn+u1vx9N+NqgD7gGD/lEgiqyULfQD+An2yHswDXYwDeFf81NBfhDqtLmO0yazLYxGKdc1tqBcdbIRRjzaV0mDd/1GjO3lZWqvCIlFCgmTavd1aZVdVfiI+oLLp5ON09Iu52HEDJviY1620V5wHzy1lojStRzph96I0JWGm+HbnsiaB43Vq4ChE5yIG4dhwnTuoTroOrPbIQ1NPhwMXZT+CYWD1fTHOyUn1HQ5lAF8Gh49ahsfsa8mQwoyQqHgmt1cQXkxqAEpKNI6a3SHrmoL2Vv16qvY2RVK4WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 02:34:37PM +0100, Yeoreum Yun wrote:
> On Fri, Sep 11, 2026 at 01:59:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Sep 11, 2026 at 01:35:34PM +0100, Yeoreum Yun wrote:
> > > check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> > > but this can fail if the mapping is merged with an adjacent VMA.
> > >
> > > To avoid this potential failure, first allocate a temporary region with
> > > extra pages at both ends, unmap it, and then map the test region within
> > > the temporary address range, leaving an unmapped page on each side to
> > > prevent VMA merging.
> > >
> > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > ---
> > >  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
> > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > > index 5c8ec3ca75d7..a28a57d34e97 100644
> > > --- a/tools/testing/selftests/mm/guard-regions.c
> > > +++ b/tools/testing/selftests/mm/guard-regions.c
> > > @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
> > >  	char *ptr, *ptr2;
> > >  	int i;
> > >
> > > -	/* Map a region. */
> > > -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> > > +	/* Try to Map a region. */
> >
> > Map -> map
> >
> > > +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> >
> > Should be PROT_NONE otherwise it'll merge with the below.
>
> It doesn't matter. since this memory is unmapped and then second map
> at ptr + page_size.
>
> IOW, though the first one is merged, it unammped and then
> the second is allocated at ptr + page_size, it wouldn't be merged:
>
>   after unmap:
>    [existing VMA][ 12 pages ][existing VMA]
>
>   second:
>    [exiting VMA] [hole (page)] [ 10 pages (for test)] [hole (page)] [existing VMA]
>
> Am I missing something?

Yeah, unmapped (unfaulted) VMAs can be merged with mapped (faulted) VMAs.

In general it's also better to be explicit by specifying distinct attributes
anyway to spell out clearly that the VMAs are intended to perform that task.

>
> --
> Sincerely,
> Yeoreum Yun

--
Cheers, Lorenzo

