Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E84BF47CCC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 20:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEC96B0005; Thu,  5 Mar 2026 15:24:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CD06B0089; Thu,  5 Mar 2026 15:24:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8706B008A; Thu,  5 Mar 2026 15:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BFE06B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:24:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FD08160287
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:24:25 +0000 (UTC)
X-FDA: 84513136890.08.54F9EA8
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B195C0006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:24:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=psK4wZaX;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772742263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BH82XF0wTs4O8E0ts/qJuVTlWmsqTS6pY4Qf35UCzxM=;
	b=wskZIrleEafrgjp/X4YcBt1RABLf9ld7Xx1rghbUJC+cMP1bVp+eRQFhnNgGAwPrV34Sp8
	3nXecBQrHoMtMcKJkdg4W26gijZiRtuexAt10Jlan9A3O/3lUmnMT+KyANS9FYlWy39AOy
	Sm4PXU6LvYUXglzjvEhmi6qnoEQ5FzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772742263; a=rsa-sha256;
	cv=none;
	b=4GUOQfZDRpZM+R9QEeQid3wkFGzuyHqJsFf4uAlIfITnzIk2VPIH9uGI8EWAC94zdMNDoB
	g0cI3iVJzjS8wsRiYZKj9Vv8gDRugDeRtnOcvVkTutMl71nY+qUbqAXJY4IFLvcLcYh3IZ
	tsRTfcw19nlhn4BEtT+deog86x8zFTk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=psK4wZaX;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772742261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BH82XF0wTs4O8E0ts/qJuVTlWmsqTS6pY4Qf35UCzxM=;
	b=psK4wZaX0AmqORIgObeuNszbt4Pdwr0bMkPwaWwRwIBjVysaU8pBe4d787ivtWp7tUxiqY
	OkkErAEvNgWYky73318wD6+bPwz88xYnByfkrTyDzCRbV8TVgnWf7qT1gn5T9QEjpp/vYD
	n8hkJKvQnTrW5/s639LPUxPugJvPLns=
From: Usama Arif <usama.arif@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org,
	rafael@kernel.org,
	lenb@kernel.org,
	pavel@kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] kernel/power: fix swap device reference handling in hibernation swap path
Date: Thu,  5 Mar 2026 12:24:12 -0800
Message-ID: <20260305202413.1888499-1-usama.arif@linux.dev>
In-Reply-To: <20260302165334.1278479-1-youngjun.park@lge.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B195C0006
X-Stat-Signature: 5f16czustrpc49kyfenoefnf86z4bmje
X-HE-Tag: 1772742263-34758
X-HE-Meta: U2FsdGVkX1/vvxkbjlixvlFHiXc6CT32syW0yzvYYTGXQEM0wh7/uIStDW6zUeM5tMS6o2m7eIPgQub/eqh79DGrU/mDm9inwtWThTS6AmCggrYHeh8zkTE6Co4WNne+z8WRB6rT9gsET14C/mGJ3r0qLUD4Qy34WkJKssj4VwyrhcirGBijxYypRV5iI3gb5z6CieRRXLW1hINKxn3i+ncWBF0vle7ajW8pKrvQDLpIkXY9msE6wZ8nv4wynqDFkCEpTKL/tJG+MP2es+gRzpaZPyT8Y6+xjrSTShVGE0VX/1msYxc9GFvqE9jvenKKDw/TQl3QpeOKlZG2a6pYSMAxQmICpxr8xL8GNMbKhbhSxjdxIBYo+yNb/+ctS2Bw+X32SJmKSsKgzPHPCrdEN5J2z8amUFEP0yrH2Xr+jGyVKVD/7hjrDLO2qNxwQBF065wY6hxm9cNLrnrVCxZgVAYBTWvWY7kSjuLHO3a9RI6qSWLz6IdLxeLZiWznD6JzPW9eUww2Pa4I8JoNAYT3WSdh6DF3gtd49yAE0EGJhFY4WK2jZ6l/brrvUXEdZRFdoFp5rPLsENAW0w3mfcMK/w7UsVhrx1Led48miKOARQ4k6DQz8snWpZ2DYKrqsT5wpNKZ7sl8ri2DZmXASaXtgQL1paPPkj3UOzQqql+6lcDe1VvsbkBTkySzsPVEFELMZaKuIK6LQLXiicXX1gypcaJAC7J8avlAg6RnKNSYxS/hVCH6xyYgEZfrDZvjiQpEr1hJC1F25SqxK973LWM2B3lLhJ0cc/kXTnSSMkJU6MZkotvVgELyE/jXh6E3V908M/IWyYcKfxT4n92dzWBJPm4aXTudYomgUIoRLr7t/eqCABHCv1U8jaV7CRhBDb8GMf6iufE/VYYj+aWLgL2O+SrzRKTB7FwmTbjnqK+JvvUaTRmVbT7TkcgdKkNJb5srIGqjXmKFr2KofaviJqu
 J5rsXwVr
 B6DvhUQus5BpgRveWyhDmk4te8ujGSTxdnCsLhVjPcHyuDdMT/g6x6Ll6+75bmucNR8TqlpozRqHjm22jpFLr5xG4y6gKGk1vvgyTVagJMROOeFT/rZ8Yg8geOH5GhjLuN+08vkyQIq7wJ07u72275G7ZWvMqsz0U2fANr8fcNKg65Mpe/sGs41vtDg9ZTkLNELaPb9cjbIX0d/SPHRZ1cTiDwkWcXNOyBiED
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Mar 2026 01:53:32 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> This series addresses two issues in the hibernation swap path.
> 
> First, grabbing and releasing the swap device reference on every slot
> allocation is inefficient across the entire hibernation swap path.
> 
> Second, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the
> type is acquired, subsequent slot allocations operate on a stale swap
> device.
> 
> The fix is to hold the swap device reference from the point the swap
> device is looked up, and release it once at each exit path.
> 
>   Patch 1: Release the reference immediately after each slot allocation
>             as a preparatory step.
>   Patch 2: Lift the reference acquisition to the lookup site and place
>             put_swap_device_by_type() at all relevant cleanup paths in
>             swap.c and user.c.

Hello!

I cant comment on the feasibility of the approach, but for proper series,
you would need to squash the 2 commits, otherwise it would break git
bisectability.

Thanks

