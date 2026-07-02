Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BB0C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B496F6B00AC; Thu,  2 Jul 2026 20:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB296B00AD; Thu,  2 Jul 2026 20:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C24C6B00AE; Thu,  2 Jul 2026 20:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2E66B00AC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63FA01C14B4
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:08:29 +0000 (UTC)
X-FDA: 84944470338.19.052CB1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8BF2100002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:08:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRMRTBVo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012107;
	b=OT0c+nMkgGE7xz/M69FNeJEGND6GAGpO0Wto1y9t/OU4ZoUftdA9UmSEC1ciO8LIFDjKEy
	Q0xzG6j4MNbNLNfsQBx5vIJGIYUyf09Uwlfz3dPgfxCZ0HdogduV0KROT+w5gUzVOao6Uk
	AvYxtVQFjN2+4FlAO0BKeXo3wqJB2bE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jJqNVr8Hsvf3MHzFCrbJPOq4Wm5FEZqt3fAIHQW0gg=;
	b=qtFFh1mHSW0ImFgdtvXKs9QHK/Sdvc2pn6NHtazRtE66TWnEsvHGe0v55izrXkDcPB9I6m
	tmEdsEmKoBFyfFcN5YAPkG60Ss3jZ0ENsQl0pQUqa7QaYoGDp7dK+bxNUwGzNRr+QjqmH3
	CRV8Ri7udV+3FN63iMSBJNnnuWA3bek=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRMRTBVo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 212A1601CA;
	Thu,  2 Jul 2026 17:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F11F000E9;
	Thu,  2 Jul 2026 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012106;
	bh=7jJqNVr8Hsvf3MHzFCrbJPOq4Wm5FEZqt3fAIHQW0gg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SRMRTBVoa4lAT6KM7k3eRzm4Lw9ObAh/DvE28AvilZEGwxOUA98Nu63MsdDL2ewHd
	 2uMvJU5Ajx0JsTOrm+0bOC6enU25l80IK1JYxuXsOZIM8OdMGOrncG60+YmHpJbqiI
	 aq32UkRTzMoFpFVmx66QG8R1lsuRhzQmQnFzDi8eB0axutL6Oxazrd0JQq8/r9TveC
	 Rvcl1+cSYZnij5A3tufnG5ayqqJ1PEZR6jbaybNwmp7MDYlH9XIKMGZAH3yEB/wqe2
	 LerkJ8MTtjGI08geMp3REBEXlecU6sDPo65xJiIqlBkYtX2VSE1EXcOkbgbqWJFsNe
	 MZ2HrMOS9s4yg==
Date: Thu, 2 Jul 2026 18:08:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <akaawVcQ4D4XSOKs@lucifer>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
 <akTJsCTKZ5hMBf5V@lucifer>
 <20260701164613.008aa13cb6187ec9597bf652@linux-foundation.org>
 <akY_L-yuaCXBOXb3@lucifer>
 <akZis7j6xSjl8K_D@kernel.org>
 <akaXQyFlZi82SePE@lucifer>
 <b110c415-c9bd-4e70-ba49-107e355477f6@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b110c415-c9bd-4e70-ba49-107e355477f6@sirena.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8BF2100002
X-Stat-Signature: 4k4ekjw3jxyy9uy661id6n946hc6cjxx
X-HE-Tag: 1783012107-730574
X-HE-Meta: U2FsdGVkX1+DaGJln+gvyxvA+08sLZCa9Kll83iQkWfj1qbpHtNqNg1gjfJS64l+IXALiKoL3vzhr6nclkiRkqD2jWUxLWsrlgZLgO4y/fbBsz43UDkVcWNzIBA7kv6mH4BJWn6DxDvHkxtt109CJagROCY4Q448+abqdi9Wl7d01B3BGis5UiC0EuN7uWiLlI8+iF4279YHINVq3jXqlBK1BomOZSg2tZHqDg4oduoTOOWuZly9qu0mH6hb4x5o53OZQrfUoQHfOzQp6Xdje11k3ttltjPBgcg/nW+yXvEunk3/VtbD2NFS3YALaaFAnY4s5ssPagBgpVtsH54qwTwBD8cA8rhFOVbmROckjUVOTl3yYqqbkftJZ2lC3paDvgR5vp0ZTtuB4N+KtepfureDHx8Fh5/vvw1cnnYD2INxgMYa0kU/2TIc5+K2lacM+Va0MakDIBn8jqwnK+KiIUDFQIRDWWAhuMnTFbF+q2CQnQOht8N/nW8MV/KDZJ3sanXzwRlF6rp+bVEL0M3CdhKeKd3p8oRbkZ+Hs0d/vwjy8mJfVBoSHqt29FB5HkcYK+yDVtTYe+UwxaoRjVx3feWrmJumxGrh/tlzhuqVSAizuLHhhNtZziTfJtlfww95aOAR+7//kD7xSXSQJ12lkmAU/9Qn+9BtnCtSpjKSIXr9bRObyGlSDcvPRMj48MgKsp8rX1AGpCAh4HZoyOlmgYFAdcsuCplWCk1pRo65KTuhhAeyGdpMbgb4dhPC6TwWR0yiQgkhwlXalBqO37NdAM0qp+Z8NTt1xy/EZMUW8YUKy7YDUEHj99YuovVTSuPpjfZsTnLO5+If7qaMkbjUdJA84/+poDAnruJVe648fbi+/6NpRdVZFicT/7akoCdGeuaWz7UKae6ppsjcP1qv19pEAw5qZK6/yH4A9G3b8+M0eMYiEFbg0AbdCWRuyNRLjexbNJnZLi3wPTEpToX
 mnXaxE6q
 mntXUq/gKq6e4vJsvEnkF1eE7b2K/BYnFw5EkA2YPSp3+1vt5Rdkdq4mSX6IYHJcQPslmSAekY9Kr+PWjnCxw8+AYZioaGBPu1VMej2cFL4Sf+hFaktIXAWLO7QHx929a2X4B5iINPSFfyn4AEJqsOv2WNo/TxAhAJtud+8JnENBH3zzy4e8Yix2xvdv//eCL26F7VXiPmGXkq3jG5XjPkk+4eMOWcNCT4xh7WvaK+Zyg99df0Sggzt8luyxxZrVIs9Di
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 05:57:34PM +0100, Mark Brown wrote:
> On Thu, Jul 02, 2026 at 05:53:48PM +0100, Lorenzo Stoakes wrote:
> > On Thu, Jul 02, 2026 at 04:08:03PM +0300, Mike Rapoport wrote:
>
> > > I can't say that CI I run has a great coverage. I don't know what coverage
> > > mm-new has though
>
> > Well we're very grateful for what coverage it has :) and that's nice to have it
> > work with email like that also, makes life simpler.
>
> > Mark - are you running tests based on mm-new? I'm not sure where things stand on
> > that?
>
> I currently test -next, mainline and stable plus my own stuff.

Ack thanks!

I guess in the long run then we can figure out a way to not necessarily even
require mm-new at all, and instead let our CI try to handle as much as it can
before -> linux-next :)

As that'd be the nicest way and help reduce confusion about branches for
mm-next.

Cheers, Lorenzo

