Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F038DC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE1E6B008A; Mon, 28 Jul 2025 17:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5C46B0092; Mon, 28 Jul 2025 17:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2ED6B0095; Mon, 28 Jul 2025 17:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50CC56B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:44:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11E6E133B49
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:44:29 +0000 (UTC)
X-FDA: 83715002658.24.AFC1A5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7042216000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:44:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J6hlhVKs;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753739067; a=rsa-sha256;
	cv=none;
	b=lAjbZ9wQag4GZTeBiwMDUbw0aTDDbSx4tVWh2eHpHdGIUkdjhoLaw24AuSDZnrE2XEriRu
	YL0w3DYwRWJWxSkj912q5on1zasHL46B69U4ogIEU3ryyHsY6CiPIMZYgOFiuJ9SW4FaPO
	k/FjnVO03yGMYQW6suuGRbdYaXPvoGg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J6hlhVKs;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753739067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VglhGWi8jF+GPgcQbYZE3R5zfn3/kAxrVKimW8BsY8E=;
	b=c7R9qzEcPQ7AithkgQrlYm5zAf+0vq1WcfFDuBhUzqh1o7UZPpb+lujPHesjLBQlPyKskq
	sk+DkqR8LGmen5vYBuQPc8RUasygx/nDvTi47Fl9zrgyKBFJE8Gtur64wZJ8xkZRFbEwY/
	9+UPlSFC91ZfzzA9NCSLi2y3/Kwfo8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A40E600AC;
	Mon, 28 Jul 2025 21:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C71C4CEE7;
	Mon, 28 Jul 2025 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753739066;
	bh=e4qpRsRlxizUPvkIKw+wZTEquLyTGsFG6AbZAuYAuf8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J6hlhVKstfGAVfcVCcw6+XhmyqGiw7p9N4a59jQox7nDjH/qkEppQae1cRg7vPy4n
	 q1RrqH34k6DYMG4jKgxjZLg1tJ4JOGrVtQ3V8xcjRMN20mFm03JPOSfwTtx4WsVfNI
	 i3c8G+aflc7MLDU69A6WWrv7OkJu5tu0A/ETKS2g=
Date: Mon, 28 Jul 2025 14:44:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: hughd@google.com, patryk@kowalczyk.ws, ville.syrjala@linux.intel.com,
 david@redhat.com, willy@infradead.org, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
 simona@ffwll.ch, jani.nikula@linux.intel.com,
 joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
 tursulin@ursulin.net, christian.koenig@amd.com, ray.huang@amd.com,
 matthew.auld@intel.com, matthew.brost@intel.com,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
Message-Id: <20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
In-Reply-To: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7042216000B
X-Stat-Signature: dy3fwqk58cuyyz9rya59f4xh7qb4bdkn
X-Rspam-User: 
X-HE-Tag: 1753739067-823452
X-HE-Meta: U2FsdGVkX1+QVHdXt6go+TM4oHxPDioWemfdmxC0DuTPCm79M2qHNc/C3JVuyqbuSGMpacJ2WbEjMGpLD1rn68QCu60vPzdQtzIzQLpXrcCwIcklEGVdQyOIdz4QLKGA1JbZK8JKtY6Cp4tW2dbsbkLeaIwXxb/vinz7YrslSJhUMjCzbVKkSQoTELiONF2L8RusGWcISkVhyR45QcKqY3k7gB5U2/j9j/X1/gwvYlIQOfD8ULfsbUX2ZbKjlluwQvwaoBWtswreyOV0bg6IiThV11bYucuPqZLutFZNqaxEqshrCi59+Vc7v8e49HLNZQgckvIN/arNVgbMXu8sOHd7XYpuGXX9/TL/jhcqOpFAQsE3eiUi3oLZnMQvkubZ4EYrTcZdzJadA2vs+ztwfRaL4ZOZn0LGinRfcCcAo/+y4IMYm2/ui1FSNyhzTi6NX2/gXXovjZTOSvhVLHlYpTn+28eR/SFTTvrFMaC7xxujmBFkWEH2OIdnyXu3kpdG4iSXuORwPBcSDUwldOP1Iz0UybtTK+bWXFZCBdzjeocFHPq9Rl6rPLqhGpBUpsOrbeA1hcVB5A0cxvAyzlZtO0w/ZDxFVU58ktMt+9syleTOTJ2qGqg/2qBXGyKiJ8o6S9CLwb2Z4DuXwFmSuyD71iZU7DBkYkrR/VzGnyuF/a2IGomoL83GUy9PrhOpKa28xg5/SWOeOsGixRU6nB0ep5tr2NQ+2UXeZTR+w7fx/I7i/OANv0jts19BNO1EdSaa0nxisV0ZP6jKotJoZ/4joYtCQRi2Gq8/Rzs3xbM5eNzoSidpoiz3crrHuzEuCxSv+5VOWDTbZHTpdNeBr2fXEhU+pEJKQZbZamok7eGotdwyFpXqhWdHgi8K2wlnhYSNCoSAQyQLL4LZmqZ//RG1cPDlyBqY5iEkMAgC+fg7VUOU29zFg2I/8zAlLSzB1pvVwW9XPrh3NnNg/8c/azl
 HmJcOR8w
 VGiGwb0OeZKLwpKKDcMzwjXSq1JlF4IUm84k7cZwEZH/re1oHc5k69dJR/DF0MHCC5/3+lqs5K+5fupo/mnMMRH/axBWYulMZcE11iHTUx2s/ByhrG7WuZLV3rQrUITTSwv5KXYILmTKMND5LADjPLloS7tljIOPHMSgUkdgtWICZA5Y89OUIMZkB+eTgy3z3bl2+N5QOVxk83AQ3nhgG8ZUZIzy0PDX6EFHD0iZgMxa2CQWff8pVQuxxbKpLsuFC98aRM7iKgGHiKRjz+mJe7yMTaUMLbNaR14cmS5TqYTq0rZ6HUa8wgDzIMs+KeJUi5VpA7Cmi2St0iQCvdbFlDKtODPwvnCnHuoVM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 16:03:53 +0800 Baolin Wang <baolin.wang@linux.alibaba.c=
om> wrote:

> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"=
),
> we extend the 'huge=3D' option to allow any sized large folios for tmpfs,
> which means tmpfs will allow getting a highest order hint based on the si=
ze
> of write() and fallocate() paths, and then will try each allowable large =
order.
>=20
> However, when the i915 driver allocates shmem memory, it doesn't provide =
hint
> information about the size of the large folio to be allocated, resulting =
in
> the inability to allocate PMD-sized shmem, which in turn affects GPU perf=
ormance.
>=20
> To fix this issue, add the 'end' information for shmem_read_folio_gfp()  =
to help
> allocate PMD-sized large folios. Additionally, use the maximum allocation=
 chunk
> (via mapping_max_folio_size()) to determine the size of the large folios =
to
> allocate in the i915 driver.

What is the magnitude of the performance change?

> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Reported-by: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>

This isn't a regression fix, is it?  acd7ccb284b8 adds a new feature
and we have now found a flaw in it.

Still, we could bend the rules a little bit and backport this, depends
on how significant the runtime effect is.

