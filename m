Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED83BCEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F676B0092; Tue,  6 Jan 2026 15:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF076B0093; Tue,  6 Jan 2026 15:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50FF26B0095; Tue,  6 Jan 2026 15:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 421AE6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:59:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3E665CC65
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:59:16 +0000 (UTC)
X-FDA: 84302754312.06.CB14F40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F10640011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:59:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M90BQAfj;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767733155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vk0TSqk+Q3gNiVjVEI88qN3K4YMlNT3Ne1LbxSQjNXw=;
	b=Q4RSPwzvkTtn7obYsl5bMZoFFG7y6Jz9VFsva1UiH1ThveOXk1Yc0VGC0CygM3NILNjbLp
	l1qr0TfX8DBLtJ0pOJUBERUvXRqFw/pbJUz1eALwyEZgtHN2Ke/7Wh+R+/phR3JMf6nzzJ
	hmYeF9z6+BOaV/YkergymhTcDiY3vUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767733155; a=rsa-sha256;
	cv=none;
	b=1X7lHregdDuiemYkhT8CtKZ1ZMVAzdV+87Ss5nVfZuALyD9qGkAuEhZVFz5ZiOxgW9V4vv
	aPbueJiFCh+pmFKQoFeIyxRyIqKUCtWYqNhLkQjAxc5YpBkUvwEvGL/lZEvOmJU5QL+fwj
	yrIEaTRhYe1yCYDNHNXLTBw8WRaaQpE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M90BQAfj;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D937443C19;
	Tue,  6 Jan 2026 20:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D739C116C6;
	Tue,  6 Jan 2026 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767733153;
	bh=s8JI4AVlsCOv4ICnt24mH5HiGOEafgKJaj9Y+ffuZNU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M90BQAfjWTj/KzZmq+K81A45dxfsHv9/1iVIGzvsbARktXCStO6+lsrcr4YtC7rdk
	 nGKlxUxiSEqxTjbX4CqDH72MgCAo+HoVCL6GPpNCqh8lC4GzkBUqRUwZ5p0cTnoKV3
	 ANz1NdRwS3hmq1B0O7jGws/IMbqxlBplqyx63Xwk=
Date: Tue, 6 Jan 2026 12:59:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, Mikulas Patocka
 <mpatocka@redhat.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-Id: <20260106125912.a4975dd1919c913c22fd5101@linux-foundation.org>
In-Reply-To: <52bffed4-d9b0-4ec9-85a6-ba70e22106f3@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
	<61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
	<20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
	<52bffed4-d9b0-4ec9-85a6-ba70e22106f3@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fn7ipaazicm3gbsr5d79j1neh66qysac
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F10640011
X-Rspam-User: 
X-HE-Tag: 1767733154-540779
X-HE-Meta: U2FsdGVkX187WULEDgi8u6cOquyBSnoy0pffwxZEU4WW+GEGXGT0ISWo/mjxDkPP9tqw4myBmw8Gx04n0VoSX9msPfA1IiZHi88bqWlMbfp6dJS1oRU/468Ec7HnCgRTWxezGui8u3NW3NTPJPhjbzly+YXpEpZLqc/NU3NldOyaqMH/J0tbVVvGJXA9Vr7N8OOdq0xTVos9G460KLbcVijV5dNQSLhNNta972rppK9gZsnc+7aHHloFTFWm55lyzeJtpfmvpFlLpNgUSUE+TN4t38zh3KDeghYwd6/9j6quEPVoz2MJTYiFbBqz5xyAdxwaLNHOJ/0+uYHjfIEAVK0wjO8t4TpTaidXQPi/cuAtpDNW0LmeM6utp0IEupxqg/ZszO4VfI8XdCdUqufaU40ye2ddwc2x6mmqgsEt3fGKALp8lur87U+W4sSCXMQQnuyArl+1dSO7+Eblzb+2xwxTSDDocHpAJepzBnwLH1UyU9/eBIqyWQ2QY8ALxuOrPMC/DC9fFFogc6TLZaG0H04tA79x6mqftQMF3ZYD3JFeauQ/dB2DksQD7SJDPzZdaqw+LK4+jHqELwlnOBu0ccaUTy8KJ5lGCFDC6c2dFN4GdryCLJfrOnNxa/VU7L1fnOl/vxF/nE6B+f+KbowAWYBDpPCWXPLhzRMH8CLtuDX4HOPLgliJpYY1clNZwJppSQvxCQslFmTmrUOac/AKdLmSP4gn+CFyFz4/l8j5lJJy72j3zXPDNqOONsz6KZ6kzs1zFMWy86vsoT1cGQx8Gh8U7grcSPi7RI+4MeaIgUZbyEcCj4Ge32X9MmdsbaLMGoquA3nIrAPBSkIuTrdgZNZdFzxDyM4s/a2sqP+AbtCFrv1ta7/T6VetA2YY0VNJGaZquN34UlIbKuNQ37GBiyk1ia3SyISPbKHDvR4rlK6Z+prOhQR91uXINdrhsdZS6QIN1dP2vUguiuwjDAZ
 qqqrZbmo
 3/FYolT8JNHTJS4RSi9w0O7rgUKgUlgQ0/WOeQUJOGCYtSDb443HA3haVCwWvYCAOMduHqmxHCqZp2Yl1PKesh9VPbvuxqYKIKNYgdxdMmOI6qKXqEsw3TtgxFQkv5qGnWeHkqeEMsngznqVVO0Uhx7U6YkujCeLoLMDyhHIzOgfxVgtM8f7k1oqPqh3Dt8Od4k5ryxvER1ILW0Hnv445wNa7wwxdXyy68JDLHnYZWoEclxfY70xX26FlMckYuOagdVuef+dtl27rnLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 18:24:10 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Tue, Jan 06, 2026 at 10:12:49AM -0800, Andrew Morton wrote:
> > On Tue, 6 Jan 2026 11:51:49 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >
> > > I'm not sure if the git repos are lagging vs. quilt, but as reported this
> > > patch breaks the VMA tests, and the tests are _still_ broken.
> > >
> > > Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.
> > >
> > > This is interfering with my work, can we please drop this.
> > >
> > > Also the v3 is currently being debated, so surely should have been dropped
> > > until we have this resolved?
> >
> > Well.  I don't drop fixes unless it's decided to be a non-issue or
> > unless a better fix is available.
> 
> Even if it breaks the build and that's been reported on-list?

I addressed that.

> >
> > I've done this for ever - I've held onto "wrong" fixes for *years*.
> > View this as a weird issue-tracking system for a project which has no
> > issue-tracking system.  It's to prevent issues from falling through
> > cracks and getting lost.
> 
> I think a lot of the issue is these processes seem to work to you but those
> on the ground are finding them not to work.
> 
> The kernel today is not the same as the kernel X years ago, esp. in terms
> of sheer volume.
> 
> Having a patch that none of the relevant maintainers/reviewers have seen
> land in an -rc out of the blue is a really serious problem.

It isn't in -rc.  It's in mm-hotfixes-unstable and it's marked "acks?",
which means not to go upstream without further consideration.

> Also it was taken 2 months after it was submitted, so nobody could have
> _possibly_ picked this up by reading the list. This is why I am really
> underlining this case.

That's why I grabbed it.  Had I not done so, this issue would have been
lost.  What I do *worked*.

> >
> > It's unfortunate that this one causes disruption so I guess I'll loudly
> > comment it out and track the issue that way.
> >
> 
> I think we need a better approach, yes.
> 
> We in mm are really very responsive compared to most, I think asking people
> to wait and resend if somehow it got missed is considerably saner than
> 'well I'll take any patch purporting to be a fix from anyone so we keep
> track of stuff'.

If someone wants to step up and be MM issue tracking person then great.
I don't want to be that person.

And let me reiterate: had I not done this, the issue Mikulas identified
would have remained unaddressed.

