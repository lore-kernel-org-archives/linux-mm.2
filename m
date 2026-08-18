Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A981CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D77D6B02B6; Tue, 18 Aug 2026 14:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487476B0374; Tue, 18 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0146B06CD; Tue, 18 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151EB6B02B6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:55:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A16FEA2B52
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:55:30 +0000 (UTC)
X-FDA: 85115293620.26.BAA31E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C36C9C000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:55:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="PIWRAjy/";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787079328;
	b=sOv2BkGNUpFP0pzabP3HaBp1URAxqYmYEW8jMej2tLJuw+OR39r4dGpOLxiXRdpYZ88IsZ
	/4bymhoZWd+4TtotSpstdrNV7CD/+LNDfL90HA9x7ORt0APEBwy1og3I7ZAIemYijYp3gC
	P4r2VjugZVpkzOfkIIr2cHGoIJlkPPM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="PIWRAjy/";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787079328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kxgfrlp2b96b1Tag3e0eQn0yMgSkp7tX9f63gYkk8iE=;
	b=gCCIq3a8qO/lBnL1qQI8/5OuJiiWwdTKfwoKxJOEnYRAWmutypE7xm2Vw75ES4kk8JkS6S
	uwUQpYVYfp6U6aQ4HCqIyZ0l71GHcOlbNZ+kyNGQlHtqhmf4kM33m5D3pj+TsluCYFyP9B
	rOuf3K1BJ7F3t8gLl98AbNU3JJPbyWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8124410A3;
	Tue, 18 Aug 2026 18:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A50E1F000E9;
	Tue, 18 Aug 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787079327;
	bh=Kxgfrlp2b96b1Tag3e0eQn0yMgSkp7tX9f63gYkk8iE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PIWRAjy/5oJNJn/fK01KZLb0cu0dMb+1q6gOXSZv0HgjZigigaf+sKMqSUxCH8qbM
	 iUIjpVKMyv7FlX2YB2MVqGWRLvhKjQdAtJ3YJkwvPOLHyWfTdoovLRULUihsbKP1Qg
	 PEQNTZGJ3nXffRRCZzHNla2ao2+ro4yAtBGKCHfU=
Date: Tue, 18 Aug 2026 11:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-Id: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
In-Reply-To: <2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
	<3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
	<20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
	<2a523945-825c-45a5-a680-37e941e092d3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C36C9C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kaaczwoc5edmzhmgba741jt4nn7zexin
X-HE-Tag: 1787079328-449210
X-HE-Meta: U2FsdGVkX1+v5pB+6z44CXAM0eWEpDJ6x4PXnhwBMnWVqLhLhQ2u/ASfdroPLOWSsHoTwcLigr7Q5x5PxyaEZt7Z9+lVHBaoXQLBo4LG1mnTztOvXDxb2RkEPw/1ZS7KxUrX3qFKobsgUSTGgD6wXzWXOabFRmSfNstTl60gWlMh4Uq6bLR7SgUdxSckCB/BU350MZz4Mkhy+WM5rsKi+zUIoW6cjpzIk6UFSks+a0LTo3UJVQzn1iKDVuOfztGefGr6xhjsB5iUO4Rca/JuNLNydBwxCn7iPxbNewEvqGRhjvpA4i8U9EhNIaapjhjzEsYK9UJBKsJrilNc9dRs0eQpf6bYqxsDn9sIbnkPQMAQ2gsQxxMDJRwkJgGoJACFYx6ynUjLMK7kJKvpxEim3qKwJZXcr/3sf1Zzi3NpYarMltXzFH8Veb38o+UgbFlWtbw9GXtLIgkZN3nh98aEtpyu9Eh4lijXQr6btH53bvPg3EGZHggZc9jTbe55Ln5FpSZb2KzpmHoTuTcrVn++2z8VpgFsX2lj+51dCj45fzx7qw9b1gQnJLx2UfWtf1VYsuid3rspTf8uoRvtSJpWoEFGwb2ljmxySScgI4ojug2z6I7MLG3u0aNAX2BD/gQwpr/A+OH3+CCcBNbC72WUNudw2RDUTsnkPaS7291Ho1vQzVrkeEc+rWCOBVPDBTkUSNbCCzpIkUFgbGv023wMLxIhJ/KYl3aDrIQbL+pVijKmHpg2ZpUp6ZDaoGyKY2un7Hf5WkRfIxZKqEvTp8026i1+ccxmblvbC5opLz3SkCMjSIKXceoxK3D11vmc2jwXb6txxhfebAvrkdZabxH6uqCri/OVhwLDEXd0JeCGRO9EHepE80n6KdGoLDnjzOZwnuDbA3ZL8MnKp1ZWGpC4xYPXM9px9zMgs2cf2J6DVmAR/NrLbuNW3+h/rssehaRzo+Mfwt7+Zgd63hHsyCr
 L7rErFy6
 9LFp4LsOHalDDSLOo/6O9pU3D6zKsOmOOu2jx3pxn195x0BGGc3gdle947Uu/pj79EzjNW1djd94g1h2AyOHQMp5u28d1J4wFVH15n2f31sbDC/GLqmhVsUDKDZQphGl5isoJl2WYD/1oIyO/CojDg6D3WpOQ79OgDL8rqmeNwhL1+o9KfgjVp1OelZNyJcvWtHcdMG4ByVOS9uVvn4vioPc1+oRBqwF+VVoNv5mN7nuujfsacHm8wKV0NTgIhdwvnuZnZjYG/TkeakNNOSe1KrrOzeGYL12PiMfedgiD1i9YEc9K9NNm34sI/X4cbdGziawk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 20:21:37 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> >>>  		if (!ptep) {
> >>>  			address |= last_addr_mask;
> >>
> >> As Michal just put it:
> >>
> >> "PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
> >> removed. Is there any reason why you are not using full preemption when
> >> requiring low latencies?"
> >>
> >> https://lore.kernel.org/r/aoRnUxUlgf_kRlm8@tiehlicka
> > 
> > That's pretty bad behavior and we might want to fix it in earlier
> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> > existing users?
> > 
> > If yes, we do want to fix older kernels then we should merge this.
> > 
> 
> Okay, but that would be stable-only fixes?

Not understanding.

Maybe you refer to adding a patch to -stable but not to -linus?  That's
against the -stable rules
(Documentation/process/stable-kernel-rules.rst).


