Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F86C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 22:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A765F6B008A; Wed,  9 Sep 2026 18:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9E86B008C; Wed,  9 Sep 2026 18:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CDF6B0092; Wed,  9 Sep 2026 18:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 582C36B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:50:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCBF51A038D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:50:08 +0000 (UTC)
X-FDA: 85195718496.18.85CCEDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06C31A0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:50:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U+PeqIpW;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788994207;
	b=OdXXvbVRbqwsgCXkbURyWQ5G9YO02j/U5EhtP6w9jryBHCe8ofBRvOLBguUl+KHPvsNyG+
	acOPZIiHU37OAJd+5IgY86Uuux3DXJuNkDbLJ6add13bYj5Chv4BYvdJWVTppFsPrx1LvY
	+9YP4leglCK19utNO0GKRgPAKcp8J6M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=U+PeqIpW;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788994207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uakFVAIIg+dbHdGGvnXSLW6H1vVCapIuu4+L13nJJjk=;
	b=s0iFq1FenvqBhpiJSb0tz/cjQLsI3NIJ3dV4/nPqJs1aFp6ltaclj8ie//q8DR2/JmI9WP
	cY8lqL0u5f0ziKPSZLVXM2T0y+FcLS1pK63iheh4fP2R+WRwq+NglhzuCToYGBgVW2cjp1
	NhJHES1sa/C1PkHJGuOVi6DnEWMTHkw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A0DB600CB;
	Wed,  9 Sep 2026 22:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B7B1F000FF;
	Wed,  9 Sep 2026 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788994205;
	bh=uakFVAIIg+dbHdGGvnXSLW6H1vVCapIuu4+L13nJJjk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=U+PeqIpWC5DBh7q130lXHtII8ntvQj6lTQyojE9Aa4ICHDsKDcddEAQ9+1CLiYlQc
	 x7+ZxQ1yV/yDo+LuIT+OC5chsw2pvOUEhzMvkqoEDtuzInX/VCiD9d2qRnqjPiAo10
	 TfAJHc5TmbunSfpK8c7oUec5KvYaPajoE1nEE1Sw=
Date: Wed, 9 Sep 2026 15:50:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ackerleytng@google.com
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>,
 Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham
 <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>,
 fvdl@google.com, jthoughton@google.com, rientjes@google.com,
 vannapurve@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Fix HugeTLB subpool used_hpages tracking
Message-Id: <20260909155003.e6c2f4fe3c0bbee3b34578fd@linux-foundation.org>
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06C31A0003
X-Rspam-User: 
X-Stat-Signature: qxshwsi16ayt8wewup1b1yr85yy4axiu
X-HE-Tag: 1788994206-129946
X-HE-Meta: U2FsdGVkX18tjYb0mR4Q1uxppSeomJZFOJQEmXw2S8kZ8hSSfd0TZG0yx0HQlb34WA/MF4JGPqKNFbUwGNZa5bNeNi1eSBPxpmcXPzRptNwhWsU/MkKdu8P+1ld1KtiQXKxEpGz6lOrDjLIjvlCMiwrl2HgXG//gkkhcUZruvpDh1c45sP787aCJKWywE5Hn3eEm4gf8CnybvJX2dFBPl4VcOHzRZq8ci81hWb3RlIZR4bd6DVQw3d0Oick0zdYnTZFfUsBB9ETqFbI0H3aYj+rsDcTtiLnBmi7Ufx2bbKC9DFsTpAMzyXm8p9YT1AYVSKFa+nKAQKOG4L9PKknIKVBBJePgj+cx4vwu4uIfAmBtfNgeIj6RLuVMRj74hS81rE4TRGWGYcBjJJPwvZ+/fClT9FPq+XOq4kUbsjtoFAUEf9x5Gzj/FhK7QRcs51E90ozEOlgwgbThFS1tWGNw/uBXfCkfPA7laPkjXWcj8/CYA2szImpkVJUXXqshEE28PRfAVFwFjYrdCoCERzu0zSM161pIm+31ZdHSjhWBEH0wQ534E34mAs+3N2njYSRdNZusVaARvXcEgqAAC7jSmC6lnAHClOk4ZtkheAG7hKaiOZivSiAkcGvfvBHcCEjR7x4rtkUYjqRd8NmFzuBdDaqUYxKPqsdXGDtVB8UW4Ez+Q/jNIyWS7F306Mkvo85fTtkxnYMI5IBreqV9TYgp7mHZboctc5M0a193Ij6kUkh61AqGlvlUuKmLjzblIf63Cz59n3YfLgVZr2W+PfLZpgJl6PWJfkDzIHBnvRZVO/7dlJPk/hBqqmv9M4oBwRgw9wQNWgAQm3QlWc+0gJR2UebCWzZj+PfNxofIjom1hHvMgGAOjTn1tk7Kdm7GYq/XF8+8CVf9sBE04Kj9LsVBsgKINcitxI8Z2KT6fX5lrZTTfDUUH5ftghQuiTvA3UXfUEKW4tSmkf+ED4vjOF/
 nuxMHhzi
 INvxfkvP9kr7LU8VeSZXx5kOQf1IKS7GeYEUQTjPIpkJlRKt4Npbaojxszk+dpvCh8xyfGB+WSvcKeLKR76O00/zIDdG08EuTiJlypZpTznpqlZJJMsxbj92QBGVQVca/16oe8RijfAlRKRXj4GySAeLrHOHkV8/bakwUOqIbopBEggGHnJtBkVJ4+R1+hFMYd0AdUUJwhC6IW49RznW1gj20zGPgPpdAdzHNC9BE13Y2/puYtXCJM9S4z32FlGh2E2O/D0sBRXg9tpm/bgbOOu5IaS2AOv2UnTzZ1/uNQu0SgNcbEuJI96lRzSpsnbClVlyrk7GjK3hq4b+qyjlCSmMFYCXDZ6vgWD6lsSGHGzFzizW2lLVu2Wzs6jiYLbhf5gaU2OxpgwnbDPxjoFPQwlOjKinWjPSjF66GP42p4OgQDDaTEyvN35VHd5wiL919dtSBJtFQ0Ub5zsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:25 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> HugeTLB subpools currently only track used_hpages when the user configures
> a size limit.
> 
> This is buggy since when there are existing allocations from the subpool
> that would have satisfied the minimum reservations,
> hugepage_subpool_put_pages() will still restore a reservation to the
> subpool. See below for an example of a false reservation.

That sounds annoying, although isn't clear how this affects end-users.

> In addition, the subpool is considered free prematurely, is freed, and this
> ends up causing a use-after-free.

That sounds alarming.

Do you think it's best for us to submit [1-3] for -stable backporting?

Is it feasible to come up with a set of small little fixes to get
-stable out of trouble and then to prepare broader updates for our
ongoing mainline development?

If it's "shut up Andrew you're always saying that" then OK, I can take
that :)




