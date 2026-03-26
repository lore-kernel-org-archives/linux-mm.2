Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFE9106F313
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9466B6B0005; Thu, 26 Mar 2026 05:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F74F6B0088; Thu, 26 Mar 2026 05:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CDD6B0089; Thu, 26 Mar 2026 05:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7185C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:38:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CD54C2C01
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:38:13 +0000 (UTC)
X-FDA: 84587713266.05.E127735
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7614612000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:38:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+aPrqxy;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774517891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXWoC630kkL86uO1MklBOoypQIYKqyujmWaMUWlHdwk=;
	b=jeWESGPHu91BR0EHAYUOCmGKGfsYG+XNPiHL2mhoe5LZjsfsoS+JoD0CU0Xg0bPytjmcqG
	9VOQJPMKOw/BdX9Pfsps7CLSGKCnugHLwG+/peUtLU4a+AayJNGPwlDilh75tqw4bLDjas
	y4JrKqwFwzzeuIp0LU2t3QyYI7ZaD/Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+aPrqxy;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774517891; a=rsa-sha256;
	cv=none;
	b=Ga7WGPXeiRyRw0ptTzmidIBXJ+Ehho+tcCPbR6JdjlinnamuC3XzlJz1YZQ0WJXgf9JQVl
	FsxBaJSr6Rsk/NJluADFAyp8WWyop+zhnWKUgK9JmwFSGddL8i2rjauqHSOO0LEJz17/nz
	5lIi+isIX4SKPVKs8zqp3fEhAH4n7Gs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF9E260053;
	Thu, 26 Mar 2026 09:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5CBC116C6;
	Thu, 26 Mar 2026 09:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774517890;
	bh=/tRLfdcbHEQUbbuestvceMrsOrIvmRjLvFDlY4s68c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+aPrqxy25vF3Mu+gBiVvrPC56J/hm1a0lxfYbKELx751ipBm4BYCE5Km4DwHGW4q
	 7GEVDSnr/qkPerbT8DlupMSIzFIX7OyJxLl8ZTrrUbp/wYdh7ddHGO5O1Cp+wBcxVu
	 gjjHJfGfyIanxqctc9ERFgZtw3Y798k1Hney7PQsDXZQtOKEmTmQrhOoBCrTaEIoDs
	 6ypwSOto+ITP0MnWWR5KgV6qpIfESfNat/QOCjecywgoWMVt/7mBiVHk/Zsw/gPaFj
	 akDlXh9Ipjr7SBlRmqRB+ACQoDFhUnPsOqD0rpiHhxppYJ8oXwfgbNMVSkAvCwvpmR
	 hJVHefBLm1HNA==
Date: Thu, 26 Mar 2026 09:38:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-ID: <9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
 <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
 <b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7614612000F
X-Stat-Signature: ysne5jprwgzsg87eio4dgd9cpawsyets
X-Rspam-User: 
X-HE-Tag: 1774517891-241966
X-HE-Meta: U2FsdGVkX195pmtDfR+0L9e86k/1vPnBCoXqb7OQcqpRcgjH9p8dHaUnQ+eL1GdR9XzweRx3PVTSGx499rg4A4Py0NmKXL+mxpn3NU0NzvUVsfoyMszj83thw2O+LFK3HJaqe8W8tRZTAK5Zyu6D8iZp+tY6iI672xUI0w//LTU0DQo+E/uUraRO3+XfNbFfAoOLLJXGR6XgQwrLnFhmrSK+/TZCaqhoaRFgMJRgzT1kmlabp3uqTEw71JxJ7Br7kkrz59rdxZ9HGO8Q0qOSb2yLRj9H6T6i8Motrh4eBx8cOJnV+bPtajqA4GeJ9QycH8tqwk+mRLPhqPnrFl71+DUC1W/JSZa/CyWCxYwRaKOpFNWRzjBKvpBtjECknCV0JTLCKKBDrDpMOuWD2Ap0fMY6Y9etrsfJ7hFI8jnN4QlNz3w9TEJY4/BmDFgfwPK55DcZHcJ6bPiiS3uHISML0Zmha8rUes+EQPJxmxWa8KW0xJYUaU/QKWh60FvDJ+Avc+OKEhgq/UKyO9xkEBAN49D5EnbmKsuXk1Vg+xkdZQAodkaXoRQjIhfMuUeLKVpnVVeOikwiuQ6Bt6cDqJwfDs1vETypp6PIMZ755BpXTgHm/0Xkknx9ibSmEqWvqwYuSH9aD7W7a6be0gYQogrgEvTmnKqPSPjdTCW9ONHyPltW2R/wIVyPf/2BoADo7J7sAWeVpNsKUow3RUoCFfA3YXIG9bOEzn4+PYlW/GHzuECflsGRxHQNnSNYw470Bix0Yj3QkJGh1+jhGG5eTqdOeys8s78JCJsNkGwEOK8a4jP5uWz6InQowDJwTmSK26b/FsvclbJnAD5K7pgu/dRRjP+H0lCuiu0lRjiDpbzPprklspDAL0N8Ejt7Nvb6euWEzJ6LlzGFF+h4pWg9T8sOHw7mCX5oRXos0FmIgctL727vID8oDk4ahXDffS6YlqffJ0w3MncXyRQR2ivrXBl
 pNnXSxCf
 ikgiwSkUgJynH43UaSqJau0mPDiOhAZpw3mmHe8X+YB8QtruRDHKC0iC5SOKVS+Dx5VKRQ9jmhBH4MCLWbmEPemBZQdrxD9/avWubpTpZAXRmU3taVrN+zaCYoYi+iaV23nT4XeiAckVy1UMITKY2s0y6823njLUSHV5y5gH3m+vpQNFz5pfsjH37zEWMPw09OP4ebUDyRYTYQOFHRB9DyrvPq/j/zbfAYLk+pgltWmUd6lGzo2hp8AVtnte/3FoaKHWKZD+GokDq7uhOm9yhTygT92ZryNJFBaHNb8pvCj52raktwMpBEL+WsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 05:32:05PM +0800, Qi Zheng wrote:
>
>
> On 3/26/26 5:16 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 25, 2026 at 10:13:25PM +0800, Qi Zheng wrote:
> > > ---
> > >   mm/memcontrol.c | 7 +++++--
> > >   1 file changed, 5 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 04076a139dbe3..0c249255ebefb 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -787,11 +787,14 @@ static int memcg_page_state_unit(int item);
> > >   static long memcg_state_val_in_pages(int idx, long val)
> > >   {
> > >   	int unit = memcg_page_state_unit(idx);
> > > +	long res;
> > >
> > >   	if (!val || unit == PAGE_SIZE)
> > >   		return val;
> > > -	else
> > > -		return max(val * unit / PAGE_SIZE, 1UL);
> >
> > Hm this was already fairly horrid, because we're comparing an unsigned long
> > value of 1 vs. a ULONG_MAX - abs(val) so this was intended to make 0 -> 1UL
> > but not what you'd mathematically think this was which was to make negative
> > values (logically < 1) -> 1.
> >
> > Of course before it was just broken and would promote (val * unit /
> > PAGE_SIZE) to unsigned long first (thus massive number) and return that :)
> >
> > > +
> > > +	res = max(mult_frac(abs(val), unit, PAGE_SIZE), 1UL);
> >
> > This is way too compressed into one line and retains the confusing
> > behaviour.
> >
> > Could we split this out and explain what we're doing (sign-extension,
> > integer promotion and all of this stuff is confusing - so let's just accept
> > that and spell it out):
> >
> > 	/* Get the absolute value of (val * unit / PAGE_SIZE). */
> > 	res = mult_frac(abs(val), unit, PAGE_SIZE);
> > 	/* Round up zero values. */
> > 	res = res ?: 1;
> > 	/* Retain sign. */
> > 	return val < 0 ? -res : res;
> >
> > This is functionally identical, but a lot more readable, I think.
>
> Make sense, I will update to v3.

Thanks!

>
> If Andrew needs me to merge this patchset into "[PATCH v6 00/33] Eliminate
> Dying Memory Cgroup" [1], then I will develop and send v7.
>
> [1].
> https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/

Oh that's your series too :)

That would be ideal unless that's already in mm-stable, as the series ordering
will give us strict ordering on patches.

Anyway let's wait for Andrew on that!

Cheers, Lorenzo

