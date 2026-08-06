Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA480C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979256B00A3; Thu,  6 Aug 2026 15:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A2A6B00A4; Thu,  6 Aug 2026 15:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FF06B00A6; Thu,  6 Aug 2026 15:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60F4C6B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:03:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9C44C01E8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:03:40 +0000 (UTC)
X-FDA: 85071768600.20.9868B8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 33F5C40014
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:03:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S6HabWo4;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRt0s7vfM2bnz3NqZRZ9IExdeacv27vJYYUrCTtxIiI=;
	b=eL0Pux3xKg4xcG/gxqQWiao/3d4hAGCLKBNvamTeQEnO9Wm7GhzQAlA6Lz//yIGIKu1WwE
	tQQfbkso9zC8/fFKut0dzu+1UdRvqjrVW0MNZkjBLD6pjcOMRCEW5GRlieVF/5QWGgAapA
	HchEIzcvt0JQC7DsaGP0prxeMdF3clQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S6HabWo4;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043019;
	b=fkFojKxqjb1kF1lKazQaRepqU3vJPEMWDr/usZHaAMk/0VYHrVpFg06RxyXzD8v+FdXCvZ
	oima5kEOU4WFpefl5GJMvftilhhdrC3JNnj0nzFNSIpQZ09Fi7X2pIBj1gzZCSiqJCLosL
	DwAdMfix69wuUj62xoz3ch+MLRogR+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0B8C417C8;
	Thu,  6 Aug 2026 19:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D21F000E9;
	Thu,  6 Aug 2026 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786043017;
	bh=dRt0s7vfM2bnz3NqZRZ9IExdeacv27vJYYUrCTtxIiI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S6HabWo4OztTo/PiObEDh6luKFIDnwMqPcGG/RkJg9S5pUwEXj8utnavmqMb/S1+t
	 YdwJzCVygJOtG352PEat3qf+0bzmGKHiWhmRT1DC19OPC6j8ZyjN9m3mXkBKdw0Cxn
	 Kwru4dhgGBMyzpD3DN/wJTzu2U6z1fu54kScQfIA=
Date: Thu, 6 Aug 2026 12:03:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Kiryl
 Shutsemau <kas@kernel.org>, Ackerley Tng <ackerleytng@google.com>, Frank
 van der Linden <fvdl@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fix always draining LRU caches in
 collect_longterm_unpinnable_folios()
Message-Id: <20260806120337.2c7d65fd7f9d534bf4ffed1b@linux-foundation.org>
In-Reply-To: <564e64b2-1b71-4d8e-a29e-dc98e8deb006@kernel.org>
References: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
	<f616e9fc-339d-4430-43ea-0ec8810c5f3b@google.com>
	<20260801122040.7230a8eb0dc846ce357fba67@linux-foundation.org>
	<564e64b2-1b71-4d8e-a29e-dc98e8deb006@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 33F5C40014
X-Stat-Signature: h6gchjjcoq3iajx76ex49tqbewjudnny
X-Rspam-User: 
X-HE-Tag: 1786043019-662352
X-HE-Meta: U2FsdGVkX18MvK2IWm9elAs63uClnqRKP67NUxpKUjbcpk4hknOeIXYw5ebM7z3ENq9ptbuCWcW41LbeVqDi9vJSfQaZo31PzOsjqNKwTFGWOR2QHEczZL4vxUev8uoiF6TpboJQCufV/ExrNqEn8eOihU2GH521RPxCtyWDuXcTLEh+48g2uK+3vhhRIPBlz9xTPauJ2IGEBysPDFjkknkNF8KECP66W9NyuekSKvCHyyjKw8PEdNDaWR6S6X9GBG2JdKYM8UaJd2Z4o7WzIF3d7kSWn1vV3eJKmHpq0B7+G569bhaQcqVnvKbTQ3Wcb8r7sg2QacvkBrWcrRDjESBv/1oEPtKfXDMax+tKS25thLHHJHtVBrgV7xWlB6xd5as0aJJ4K/a4bPK9P9U1HCjtmvgRrlQcKM4R4hQA18+fHsAqNLuvESzBxYHkljLx2AcRoMb79xGrsoTkfwfTGxpnlUJzaTStS/DuET+14/laKTx1WRL9S2nmD6lqBqidC7VAxXWnFcyBddr9lYIfa6aarYCeCQ9rF8i+erN2o/a1sV5ONlA6uuwvqSpcWvpX4z3WBd/UIjn0I3Kt9MSpzwFa22mzD6xdjKGC2UlrwrMeayFXcZbVR8PMt7X2i9XA0RlI3dejeNCyBwlLqAIZkzhvx2h0iWERuhLzhfJe8raRwSs6lpvh+eqCegyIzJHqLbggBrCkXSJioyEh55frOaV3G+pAUvpyzDhXRGwuMf6RLqRSs2/Uissk4E3kypqwcQVfAC/AwkPt7t42iVTi87Ewh1v8HxAaqn+UKtOl35YfAhOCFUSLtqVnrkzou6Vwkz9ln+s4i+O980IPCPQtytZ8xUpMe9xueF0Jwc19b/YGU5wW/azFFwMPMYrZja4HPLYeVcC5wSswnv9TFYczjxnvF0vD8Wq8aJH0EKQJIDkLtXIt+uK0VwEPPjc/3Dw59hmSNBlefgYfMb681cy
 4hEl1sHf
 0qzTc7RQxiED8HNDuV6AIz7k0gH0XzEzKuKhCJmJWIOY5gsr43gL1udK1qBJcwbBrGL1VqaGacFB1/Ajlk9gLOPiZ85Gz0+ge3SaKNKp2VzoDojnfqFZg+nmqQ5fHWbkOmEgeGJtKZumzAHnMm2CUEjHNZ/gWhe/wyb/Odj6ORmz00MRS+RUlGnGgeqxmQfIPxA1aEyU2bwNaUDfCkcZEMCjmZeaokx+18gWZeAJwvTRXeDxmkfryggnEu0H/Qrmze4QSPUJZQrEYor0h54WIG9wpfK/8FcT67r+lF5X4BXfEBGMYcrI/e4c8jGs74taaCYgi3LE51siWvst4DmIiCopIcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 18:29:39 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 8/1/26 21:20, Andrew Morton wrote:
> > On Sat, 1 Aug 2026 11:49:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > 
> >>> Found by code inspection. If someone has a testcase that can easily
> >>> trigger this and result in migration problems, please test! But this
> >>> change seems to be "obvious the right thing to do".
> >>
> >> Sorry, I don't (as perhaps is too obvious). And I'm a wee bit afraid
> >> that some of the problems which those changes happened to succeed in
> >> fixing, might now reappear once the drains are finely targeted.
> >>
> >> Am I arguing for a delay before advancing to stable?  Perhaps, but
> >> I think not: it's probably best to get that working as intended,
> >> then deal with any fallout if it arises: just be on guard.
> > 
> > This patch is in mm-new, so it's still some months away from -stable
> > eligibility.
> 
> I hope you meant weeks :)

I was unclear.  The patch is (now) in mm-unstable, aimed at 7.3-rc1. 
But I don't expect it to be released in -stable kernels for some time
after we've added it to 7.3-rc1.

I don't know what the latency is, really.  Seems to take a week or
three for Greg to grab these things, but how much longer it takes for
it to get into the 7.2.x and earlier kernels is probably quite
variable.

> Can we get that into 7.3-rc1, though? There is quite the overlap with
> guest_memfd work, and I'll send another patch that depends on this.

Yep.  In the second-week-of-merge-window batch.

