Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F3EC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 11:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF896B0088; Wed, 26 Aug 2026 07:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139D96B008A; Wed, 26 Aug 2026 07:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25E16B008C; Wed, 26 Aug 2026 07:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C668D6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:04:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 216B5A22F1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:04:31 +0000 (UTC)
X-FDA: 85143137142.26.F09EED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 652EF160003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:04:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZrL8Cym;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787742269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBmI5fOjIx+W9VbSYdym76cV4ZkOfJL66crn6l8h18I=;
	b=eQA74G/NjJ5Wqez638X4qaSsac6ZyzI5BIn3Qvg8Nj979lc+2BnDExyQvgICUJfi2MBeMf
	r62UtgZYzg9HhueprfLvGkE4zlU9/8F7TA0jDowcj7UHoeFBy7wCEHaG6EV83CJ5wmGDQ8
	jaG1NtN3BPSBIHcKDFK8LtglX1lw9A8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bZrL8Cym;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787742269;
	b=Bj362KQQagmCPkgtLCLYnxZvK6ghX7eKc0un01kymzME9L50Ie62rN0NUjZe9+0rTnkLQd
	e5rIht5d10HBbo7TcBE29AEGRWt83A2QU0DMw/7ruhS1qslo6rM3snTvCVxLvZ/cQAOgTY
	SfI2ne2WhmP7UNE/e15G1PHZ2LQzdT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF9843F59;
	Wed, 26 Aug 2026 11:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E301F000E9;
	Wed, 26 Aug 2026 11:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787742267;
	bh=uBmI5fOjIx+W9VbSYdym76cV4ZkOfJL66crn6l8h18I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bZrL8Cym9mcGQkJcKIk7xOUgiBjZIJX94P+HYk4/+Y98Rcj+dtnsz2aAJKHXYSjcP
	 crRdTnHRa+gDVBDG32Gh8c2MqG8su06iqxXVIfZLr+asmvfVqRc5Rl+QiazfLF3ib7
	 5mnAvpmPaYX75J1rq0YD+FW3QYIO9xsMzeQq3b/J8u/OZYHujlTzEU0QbtWhIl2nKe
	 MSEgzBWAyJp6Uw3/tBOXmG3KDJwf5OkuOjD040J2mhSCdB9CPGxUbINA5LTqwVkhpq
	 Gaegv6rmFp9/gxAZuGvCw3YBo28aoTkAxX9IQaOZ27ytBKyrVfd+vufJEaGNnUzhXW
	 TIILx9bal2q6A==
Date: Wed, 26 Aug 2026 12:04:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <ao7IG-tK1NY5n9ac@gremlin>
References: <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
 <ao6c6Oe_KV0O1LJn@gremlin>
 <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
 <ao6fSHW_nX8YC9QK@gremlin>
 <42695df0-3962-4126-9afb-9a1905d096a0@kernel.org>
 <49aa013f-f613-42be-bc58-35956ef189de@kernel.org>
 <ao6jVbVHLUmuY2UA@gremlin>
 <330789dd-94e2-4827-abdd-23671263608f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <330789dd-94e2-4827-abdd-23671263608f@gmail.com>
X-Stat-Signature: 9u1ik17u76uxqeztbzx1zgqcwkqkifwh
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 652EF160003
X-Rspam-User: 
X-HE-Tag: 1787742269-627888
X-HE-Meta: U2FsdGVkX1/sXFHzKUiYjgxyweCcRcdKDxHwgxsjKB+mDnaLrfAdAXyHJUumf2Goab3S6oAIp8BaBW59ynprCohscbLxK419pVuYjtxouXFez+Zy0qJGw18ikL6RCxyMgbMwUTTLWVycEYNoQ8GNlNI935Mk+G8usNNyka6UBMd5HtY8UKnjjnSJz0lzXSdopXx4fPRctK89H7Zli3r4+Yc0g3pBZBtc4ZcLO/EuXxyx/CVH4rZRIECdQhqIkFc6OQcjPEg/Bv4Yx+goWH9KLBsqOYtFRQ9YVhSSwK9+LwC9PdFGB3AkJtpps7EaOrtVWu5WjUKS2L1B30DETecr9MjVgAn+v/F9mRTXVuZKr7kLlFAg4lvaxQjPqqdpEg2j5HDfiQxgwhbkZLLDnr7u6STj1Udcc6Z2wTVBjWfe7i1EIFkpNAJ17iyC7MpCQkN5e882Ye72VV1v5PaAeK5I0EyOexyuyGwYza7RPV98OABbE+Pg60cPJw3ZqSAixa8H5OE6ryeNE5fuoCqirOOGS46ZkuoGGdzGBaqQvhw3jeLBdwQteF63rQU38loa98fXgonfFNvcH1lu8Bj9oVrWf4SDUN/hhOr56CnOTovoeZzRi5h15SQgYrJPblePsUUgndJxn5DoWTgeb0N11sjssUHMljWv+bcUSW/2oF4fm1F+1++Zd/t4kB32blIKtbbwDj0b9ChZhdXy9hSER1tFsUx1Df8t/sRbIzwbnUrbuoEzjzW8kf6PqBZpsJFp6tFqeb8sy43dtzSypIc9grEyBTe7hU6lVSCwHeRHmc7vYVGR27dzsVy7aYf7z2CmSVe18KqhAyxA6+FfJWsYA0YQTcxyFZsTjoLKz/PcMu15XKyfW7CjRk4FncodySAYQ605MZA9ss70WxrxFlwCNx7rOGbd6ssoei2j+rxq83v+uk+d3X+6wcXdSkN1Ss79MZgOth2w4xpz1wKut7i1Uj5
 U7yBy604
 lANxSln1L7pJ53gUr84t6zHYjppoYIjg1vIJUaZysvv+uz7UJBSIbrAFzfRQ5Y/Rj6ak/M1m+R4E8W7Pb3YFCX2AkBJLeAysCNX6ZZ9x1rSR1+6wCePOiu51CGYdUFW2gtvCnxx31/7+CgsYzfXhj8h+X6JPADlqrNTQRBCux3qhKS7XN0PmtHCD2EpDWWY0wq3oCWhzQ3adpYfxozTx+ewGONJE2VP/Tz0dAzUOpwzNJF1aAShkn06Dwx/RKcUUdWcMd2iqn1Eg5WcfPfdCSgxABZVbfEVZ8okbwAevIvlBESMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:21:51PM +0800, Vernon Yang wrote:
> On Wed, Aug 26, 2026 at 09:35:38AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 26, 2026 at 10:24:56AM +0200, David Hildenbrand (Arm) wrote:
> > > On 8/26/26 10:16, David Hildenbrand (Arm) wrote:
> > > > On 8/26/26 10:11, Lorenzo Stoakes (ARM) wrote:
> > > >> On Wed, Aug 26, 2026 at 10:08:58AM +0200, David Hildenbrand (Arm) wrote:
> > > >>>
> > > >>> Elaborate.
> > > >>
> > > >> It's overly long, I read it and am confused as to what is 'problematic' or not,
> > > >> it reads weirdly in English and pfn_xxx is the usual convention for naming of
> > > >> pfn's anyway.
> > > >
> > > > Excuse me, what? Are you now just making up arguments?
> > > To clarify, we have various users of "xxx_pfn" in the tree and I fail to see how
> > > "this is a problematic pfn" -> "problematic_pfn" is odd and why
> > > "pfn_problematic" would be any clearer.
> > >
> > > I do agree with the "problematic" aspect. "failed" might indeed be nicer.
> >
> > Right yeah. Mostly the push back is on the word being a bit confusing. Fair
> > enough on the pfn thing, failed_pfn is actually the nicest name suggested so far
> > :)
>
> failed_pfn is good to me.

Thanks.

>
> > I still think:
> >
> >        	if (result == SCAN_SUCCEED) {
> >                	...
> >                	trace_mm_khugepaged_scan_file(mm, -1, file, present, swap, result);
> >        	} else {
> >                	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
> > 					      swap, result);
> >        	}
> >
> > Is a little neater as then it's only on the failure path that we trace the
> > failed pfn, and otherwise we explicitly -1.
>
> I understand what you're trying to say, but personally it isn't necessary,
> because failed_pfn defaults to -1, and one
> trace_mm_khugepaged_scan_file() already covers it.
>
> If everyone clearly expresses that they want two
> trace_mm_khugepaged_scan_file(), please let me know explicitly. Thanks!

See David's reply, we'd like to go with this thanks.

--
Cheers, Lorenzo

