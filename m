Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C9F1093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD416B0422; Thu, 19 Mar 2026 22:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DDC6B0425; Thu, 19 Mar 2026 22:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECEE6B0429; Thu, 19 Mar 2026 22:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE4BF6B0422
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:39:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88F5458FC1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:39:17 +0000 (UTC)
X-FDA: 84564884754.23.730F210
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E7E421A0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:39:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ypH57gKq;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGiUso6XOkYhObhwBirbnCAilTMqjJwMQqr/MnCgaF0=;
	b=iq8drQgMg5wE4mGhL7YzvWmIUoDBml0I1S9olNGaAduXmBgMfD18W+xX1jWN5mOvkwCQJJ
	efMSS2YNOqLed7swRvGYhUEmlUK009ceZDj8dwH3hDAV+QaTTR6/YwMPVzKkEC++9wzYuc
	QQNuZi7HeSgrnfsY6HKhHJNuwZ96ogw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974355; a=rsa-sha256;
	cv=none;
	b=h6kWmZlUu9GY51ptt5ep2hJlNLDPDKPPm69hUkjDXscgoNxebnl98tU4yb6LZkzfvs7sXH
	mIlDxvtMKmmBUpFmcYeHO+9ylf8/WFjq6ERYsgG+d9WGTcX6tinrv+IzYDrgJ9GQYQyK1Y
	GEasJSG3xAesY2F9VMMLyWwY2VS0a3w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ypH57gKq;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D55260097;
	Fri, 20 Mar 2026 02:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD69C19424;
	Fri, 20 Mar 2026 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974355;
	bh=DI9Kcp+U8vLohFD58fGlbWJnlUtiSZ9bu+o5I9WX6hc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ypH57gKqZ0OwuS4fW8MKdbyIUFOBAIY62ge8wCa29QezHhC9yDlXbHSuDTqAqiRit
	 0nrRhN4kKvLaF3Cot165iP6LM4ifmdtzdwdQ9o+THs1G+Ia4c8j6RKJsXvBl0+a2l3
	 Bk+Jg3XbtZrDAMkhXknHaU2pjg6/iA+FxqrmW+yE=
Date: Thu, 19 Mar 2026 19:39:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lisa Wang <wyihan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, rientjes@google.com,
 seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
 michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
 dave.hansen@linux.intel.com
Subject: Re: [PATCH RFC v2 0/7] mm: Fix MF_DELAYED handling on memory
 failure
Message-Id: <20260319193913.eac97eee63f451ca325dd775@linux-foundation.org>
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d1t83uynmsscj8b8xt3cbojn7z3a5t7k
X-Rspamd-Queue-Id: E7E421A0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773974355-927452
X-HE-Meta: U2FsdGVkX18eAPT58USRHttEv3Mr/dG/h9WIDn2OfQiiaugI22pg913yoUvC+Qk5vXFTk8feg6pMpaOC945u7MTvcqc5zvinKHVVo5Xs5TZRuQ6MSZC0Z9OP/ETWD4aR6FKapfUzAo4wrrLUCm95d0U0aDg9IH6e14aaeFcnpDuSCElldprhemDQy5sYQYoq0xLPfnR4TxvFLtLD3dPHijktT3V7zE6qOEqZg3tX45IwWIBc6qDblh1/mL3Q9TMsp1MCsh3fPWsT7QnrIvBh+eYCfx3D/Q8OWpLMidl9R1KeAha5f5UvVWeZKuDOXGJb3UvLOQB79ynbvRLZUyTLBQd40kUD+HE9s29WeAJe5cq+1B/pnemRXwt/qx/gl6OlvZYLDHJG0aOZh884hZdeRG9O4sWSz2J9ypyUQpT33DBIklS27wWjLRRmpWk14T5koa61z4YZg9XGZT7FodfkAphNk0Ki9cu4vnqLoCmQwGho65Pj43RM57TbOyWFG52L55/OABPKoQezjJAsEwUE9V7celE7LZmkQCbhOrkjBf7Xv5nchtoAfROHk+3mKPsW3CS/ZzSn6/Zl7gTjgg81bc/HDbEsdxjHWwn/rRNhtHHke7s+tL+j4ao2H1Q67bjEjVSvj4I2a99eauRFGmSAKiahgSv2POQjDLrHlDUKHwsuN/fxR/sdZfnDCSqqw2DcnJHLo0jTLXZRGrgEWv9DWQoaCjRWwpUT5obqCoPjiP13PiVYTWWV5xEzGkBjzotWSanXWNbgMA0S4LXzQlpmAd9ElPQUl/tq8pundMntnttIos343qTIgcQwsZqvTbPa4C5pNzi/fR35JHE1zdR8k2WtQpSseLzNMmzghSI3CW6HfqVAMaSGdZqGofrlat3g/splg1ilpyqpoq8Y3LDdaJ2e/jM9Nqyb9NWSjju1SEgTQPkJ3QE8d5HgfInJ/NHyD8GBBWm6Plq7K5Xl+1d
 AdFQlmyD
 d17N2nto5Ej15NlHD8SAAAVjEWvZtY2HPpiqtVx5sJ89XgkiKFL6bC75BDgtD3/96Mwa3Q5TRL6WYNlHgTnFgXH7dozX/iAENM3pv0oAJzTv9+1akMod1ng//qHsAY3BWKrSRpSENKwslzTGPevLR7fStZRB3K6f/SnFuxJkiXYWtrJv3UC+ZgXeSSjUnCZQFYYXqsJejXxULmDmnHeT3Cv1RXzG3o4wyVNWAJDrj0NUHdOzLVZBVRRBZfXXCKHdgL5KLtPTL+rgYWO52TQKEaer0BXpXoPnT+Hu/h0CG7q1mgydx5oKqR+M0KIdQk22Akfjo5ppfUPDtYF5Rar47qIFWpU4p8/RlL0Lqa14ROaj/vuHW21aRDd8YVt4Ru0bLza55BCQs3ub8i+zH8D3eXuXtNW3BG4IWbnakJ6fj61EZXJIVtBonYH9YBpz33Yfjheh/UDeD9PWP7ZabhvrCUM83LIF3itvg8YvN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 23:30:27 +0000 Lisa Wang <wyihan@google.com> wrote:

> Here's a second revision to fix MF_DELAYED handling on memory failure.
> 
> This patch series addresses an issue in the memory failure handling path
> where MF_DELAYED is incorrectly treated as an error. This issue was
> discovered while testing memory failure handling for guest_memfd.
> 
> The proposed solution involves -
> 1. Clarifying the definition of MF_DELAYED to mean that memory failure
>    handling is only partially completed, and that the metadata for the
>    memory that failed (as in struct page/folio) is still referenced.
> 2. Updating shmem’s handling to align with the clarified definition.
> 3. Updating how the result of .error_remove_folio() is interpreted.
> 
> RFC v2 is a more complete solution that includes parts 1 and 2 above to
> address David’s comment [1]. Selftests are included for all the above.

A few questions from Sashiko:
	https://sashiko.dev/#/patchset/20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a%40google.com

