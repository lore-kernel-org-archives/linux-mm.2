Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CCEC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D13B6B0271; Thu, 13 Aug 2026 10:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A91C6B027B; Thu, 13 Aug 2026 10:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6256B0285; Thu, 13 Aug 2026 10:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3804D6B0271
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:32:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2A5D1201AF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:32:26 +0000 (UTC)
X-FDA: 85096486692.10.43EECB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id F12671C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:32:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIpq61fY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786631545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IG593WwPZHkjAHpEh+qnkEZ5lNUNcA7qjwLsO5uxs1Q=;
	b=K5Yhd4E1m8UqBb2jQ5DjwPWc2Wkow1U8OefLz9/I02Ry+rEztkvtSgzzJkm717fAfoF2ic
	9rehsIdMxjVV8XCVi5XWEcpkXoBybassBg6+5nk0UGIU6yNk5dlNxLbz43tIJZiBr2wfrt
	6iUlXJgNxAU/50d+UaGHjoJ22MyF8yM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIpq61fY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786631545;
	b=m4VvZK2ICNW1YQyUhwoi40udQnnSVu4yhvILGxIn0NIaJMa4h4CAuGxi/AKaELzbxfzL87
	yQlsycdeNC7t6Az+NToHdHfFaCZQ2DF02KvGnIU1NFn3FvOpw2s2HEEmgzGZuzmtyFhlyr
	aXhKgspaySyFk3OBCwqCe0c2RUK4vRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44E63618A8;
	Thu, 13 Aug 2026 14:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239041F000E9;
	Thu, 13 Aug 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786631544;
	bh=IG593WwPZHkjAHpEh+qnkEZ5lNUNcA7qjwLsO5uxs1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cIpq61fYzk1dxWEdXEUCp16LoxTYoW+i9fW+HkgxV8mPgI1kWmiKvAvbhqO7rege8
	 D4WBjRsiJBmYFZ4x/ANT8VYdzB4jja+mx0CeeeAAZtDQK0u0gfKAmFXuj0NIl2rhjJ
	 g1Y4G/QIsHK9yryXNKb8Xw7oc6L2te2z/OrPxkketN/hBBA2lTD996Hs+poYAD7kOa
	 skFHZVF6659buG0et6UnjqRrB3ll7cdhZ8UMjlmrOnnlrSs34J7NkFplvnOsBuYoej
	 ENPENjuAw4Rwwzc1rxRSRB6CA0/fmMvtIplA5k4YCuiGnWDgEqHu4qDnXDeXf+dvbU
	 BFmcha80bjpHw==
Date: Thu, 13 Aug 2026 15:32:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
Message-ID: <an3RcQgDuhmcAb37@lucifer>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-3-tujinjiang@huawei.com>
 <an2g39TIN9v87enG@lucifer>
 <b35d14b5-65d8-4b8e-8754-de35f03d4b2d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b35d14b5-65d8-4b8e-8754-de35f03d4b2d@huawei.com>
X-Rspam-User: 
X-Stat-Signature: 8tyiqof1pammaym8yebawt6yiyfq8q8e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F12671C0002
X-HE-Tag: 1786631544-1469
X-HE-Meta: U2FsdGVkX18mJIPhPYlclntakmzsszo8H8AT8oE0lFbd1kxI0+Msc1xurla4D3p7sq/Hz8dPMI8gL5B2B5Y9nNimXDNJ5K1kwR+WlwbUVGqIpPOBdBdNGF/Tz7wESEeSVO+6ectAZ6T6kH+WJM4r3yjGbb1aL+GOQu2AUG0/3tPBkauoc8ExuxnT9xZHWlQHH3esM4svaq0h84+Mx0AhfJfQJRfEsD+JOIiRAuDJ+A22l5JbWqV9ndyFsMB1smkp9WqqaeGauyanUxImHqMMDnCu7sN8WTXa2oOy+dM5dJiGloiHOFCBgc9yM5VxiJwZARrracy16OYDRBdxu50tOexQ0LFP9lH1iisOwq8/DZvPHIYdk5C8ru3nC6VDvzOw61+oFkVWq5LcKir85q0PcW6c0zu+b213g8FjloPudlAzb6ITcW29/k0i6M9OFb5w/jNs0WlI3+pNBKfozD/OzByRGK1tLRzHHIjT5mCgN9S2TsRA1qlfWM4HcdtWLPaaK5j3GfPRD7t+NTTNo6fMH8jyXrdZ32Qn1St9wdbTrmYszI+hmz0Fr8y3t2MRbawf6r7pjUoXqNAgdnuvsWN9D4snawkeT3NVN7y95nMhJPFejsGPzRafJ2v9s0/PvcRzR7jTFWvC80XuS2Gg7aoOXgYvAjsekw9yClcC+X6Mey2TsS9xO6Y0WWL3RiPItbxoj9M58ziXzVXVLLAvvaH6lMDt4cosb4R1OxJC1PffDGUO5prq+Z6ykSfGbJA5Kku0Q/tK8Rv/GoguViiYKQOpycfZsjzot/xYYrpOeTBrAjxPhUg4H5AztdUCq7SU1PtbsqBrkjR6EOfj9kiaMn8jwfSzFBIsToJrv/ufuhmvdSEAD687fFB3ZnVupEJaIhkaD2Hu7xeYaJqxxgnJj3ZcYvieVzdrQCHtCT/EFuDt+9iV31tEnuStcY4w3UBSwHBKoPW9r4a2f0+vcuypJI0
 9v7CqxNR
 J9ndvZ3fmvfKcp9TFeQXd1oE6ZZYvq45RBs5Z7PS6EIjZVXZhNGkQ695lkfkKo8NJ5Jgam8zuC7O0KvpY1VTCEcA4hsAveMNTT9/dKWvx0gPXN57RScZhIbA9w2hnKFDDAmZ6E1FApf5HEpPKPPzK57qoKNkCdbUBNKDVVqYizn+ABsHi58T077qieTbU5A6QGJci19tt0Nr8xKnVkTOqV7yzwsCdIgPsxBmNmsBOI85kYAQGok9q50DjU/mau9y4nVIbLV9QnrTbhwv+MoSph8n7Q6PidKJZM1YaUWUtun0hZ6aFtGmBcO0hLd2msCNPXyLlzh1zuo9NDrgzviIyBtw+m7OfYuM7X/wKXxazzNCKzt4Q0MOHsBm7MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please show me the common courtesy of responding to _all_ the review given,
not only the one point you want to respond to.

I'm not happy with this patch, sorry, for the reasons stated that you chose
to ignore.

On Thu, Aug 13, 2026 at 07:17:05PM +0800, Jinjiang Tu wrote:
>
> 在 2026/8/13 18:56, Lorenzo Stoakes (ARM) 写道:
> > On Thu, Aug 13, 2026 at 11:17:22AM +0800, Jinjiang Tu wrote:
> > > Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
> > > variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
> > > lower limit of the pages_to_scan parameter, but that is not how the
> > > scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
> > > advisor") only uses it to initialize ksm_thread_pages_to_scan when the
> > > scan-time advisor is enabled. This will mislead the users.
> > >
> > > The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
> > > [1], but the documentation wasn't updated.
> > >
> > > Update the documentation and comment to match the semantics of
> > > advisor_min_pages_to_scan.
> > Umm, firstly if this were wrong you'd need to change the name of the variable
> > too instad of documenting it as something completely distinct.
> >
> > But secondly AFAICT the logic in scan_time_advisor() suggests that it truly does
> > act as a minimum bound as well as being the initial value for
> > ksm_thread_pages_to_scan.
>
> As the cover letter[1] said, 'The initial value and the max value for the pages_to_scan parameter can
> be limited with:', ksm_advisor_min_pages is used as the initial value, not the min value of pages_to_scan.

(Wrap your lines properly please, it's a common courtesy to learn how to
send mail according to community conventions.)

One of the part of my review you ignored:

	But in any case, you are making a claim here yet have provided no
	evidence for it. 'It is just the initial assignment' means nothing
	- if the logic can then only increase it up to the maximum value
	then it still acts as a minimum.

>
> The v1 patchset[2] uses ksm_advisor_min_pages as the min value of pages_to_scan, but as David suggested, the
> author changed the semantics of advisor_min_pages_to_scan in v2, but forgot to update the comments and variable names.
>
> [2] https://lore.kernel.org/all/20231004190249.829015-1-shr@devkernel.io/
>
> >
> > So this patch just looks wrong to me.
> >
> > But in any case, you are making a claim here yet have provided no evidence for
> > it. 'It is just the initial assignment' means nothing - if the logic can then
> > only increase it up to the maximum value then it still acts as a minimum.
> >
> > A brief look at the logic suggests so.
> >
> > But in any case - the onus is on _you_ to prove that that's not happening.
> >
> > And even if you could do that, since it is _intended to be a lower bound_, the
> > fix wouldn't be alterting comments or documentation, it would be to re-establish
> > the minimum as a minimum.
> >
> > > Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
> > This patch repeatedly states that it is the minimum time. You have failed to
> > provide any analysis to suggest otherwise.
> >
> > > Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> > Assisted-by: ?
> >
> > > ---
> > >   Documentation/admin-guide/mm/ksm.rst | 4 ++--
> > >   mm/ksm.c                             | 2 +-
> > >   2 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> > > index c9f533b10f6f..c329ca747b8c 100644
> > > --- a/Documentation/admin-guide/mm/ksm.rst
> > > +++ b/Documentation/admin-guide/mm/ksm.rst
> > > @@ -183,8 +183,8 @@ advisor_target_scan_time
> > >           pages. The default value is 200 seconds.
> > >
> > >   advisor_min_pages_to_scan
> > > -        specifies the lower limit of the ``pages_to_scan`` parameter of the
> > > -        scan time advisor. The default is 500.
> > > +        specifies the initial value of the ``pages_to_scan`` parameter of
> > > +        the scan time advisor. The default is 500.
> > >
> > >   advisor_max_pages_to_scan
> > >           specifies the upper limit of the ``pages_to_scan`` parameter of the
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index 7d5b76478f0b..4a6cf8cf5d60 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
> > >    * Only called through the sysfs control interface:
> > >    */
> > >
> > > -/* At least scan this many pages per batch. */
> > > +/* Initial number of pages to scan per batch. */
> > >   static unsigned long ksm_advisor_min_pages_to_scan = 500;
> > >
> > >   static void set_advisor_defaults(void)
> > > --
> > > 2.43.0
> > >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo

