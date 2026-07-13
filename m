Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1D3EC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 22:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6276B0005; Mon, 13 Jul 2026 18:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B975F6B0088; Mon, 13 Jul 2026 18:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADF76B008A; Mon, 13 Jul 2026 18:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3F66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:45:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF9B2A021A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:45:39 +0000 (UTC)
X-FDA: 84985236798.06.4B5E34C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2AD981C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:45:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DjnhDYqH;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783982738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adnYTFi3hoT5aFMOesERJpy3+zRYVUFF+RkxLaSOV5A=;
	b=mveGfwbAjZpMeiSE/rBf8rD+JZqgcgkdxC4wRslpzNnJRIgyhwssViJXqmE73uIYGZX950
	vsLUvpiq2tNK2SywApHvMo5I6HWJSS6+J+B/m67EitGnu6ytd5t1wm2ABYdDwQVaoUsbeZ
	UtsckxqUQjl8aJoMM8Yd+pXryy5C7K8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DjnhDYqH;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783982738;
	b=4xJPIZLojR+9TpIbSER/xhVF3+i5UqzWU/FPnATZl4KNhz/XYkRWmPRm4ICNsf1+TzXxnM
	UUG+tGgiXiKdK0YvGu9Vex/f2G+8WAWBzn2jlXARuvVVUScQ3RdyEDLH1R/AabzckQumVM
	IHZObKxFai2g5/P5kHG0JGNYGpGXD0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D40B60120;
	Mon, 13 Jul 2026 22:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21771F000E9;
	Mon, 13 Jul 2026 22:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783982737;
	bh=adnYTFi3hoT5aFMOesERJpy3+zRYVUFF+RkxLaSOV5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DjnhDYqH05eQ/7HFowjW8Rg67YLnpNK8S5WnhB/Caim8Ni6IKziN7IvqqsTpwVRXT
	 PMtPLLU/mEWJPiMd3fD7JuVerRhg9R6QFlBw+PJJKVNUtuSM691nugGB6JmjFy2ka6
	 croIvxMU+tK89yt+R7GdUBAIMoJ1m8j6C4g4WY/c=
Date: Mon, 13 Jul 2026 15:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260713154535.7656b3a630e2f6f076b4e76e@linux-foundation.org>
In-Reply-To: <alVRU38lMfvmUFqJ@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
	<alG2-RSitzPWClAX@skinsburskii>
	<20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
	<alVRU38lMfvmUFqJ@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a191iciku9iu89egkzj6oo8xyh3tmmb6
X-Rspamd-Queue-Id: 2AD981C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783982738-104107
X-HE-Meta: U2FsdGVkX19e4+yqwDVGG02lGlKvV3C6llAOJoQSO+gvnRHWH/XV0Rat+DYqh49zx+0maiIOx0mhErEVtwQnqyynedaW6XwnRc2hPI8fb9bNNx2QB4hOT0iamdZ7+CAjnEZGjuslINPfiR50qIKEplQu6z+7nNqm3HQ8Th5/ZIpF8TI+HxwP53y2I92ZQY2K2tFFRzOUF05okJdcLguQL5bAvSIyRQnXtpB6AkGbDod/h4Nx5pPOoJEA7cbDVY0rbRyZZ4/LWuAAt+8RwAz3JVjCcdbSAiFB4wquDUELfoJrxcjsjx9AtSkmYTeaj3TRqstriyzwE23pAWNrlEvxVJx6Qpx3+eq7tDjllkgHgbRM3gZqspFf5guyDl4h3NgY1NeDoAs79L5SOHPJlNv4S+a5Do87mdLmm36X1XtTgIDSbak2PaZq4gIlP7P4sFz43pVRhuG5UgiFWMg7S46mb0LtDh4gb23WvHiX4j42dOmlVp6GAfCOeEXdOCBiHKorGWp4LRBD9r+991E1zSGhKMjrKtI6yIOUX29Yo/bTDsGWuA2MzDjmFde8OmxYMnS468goFxG1PGvdTO9zbBCrfYJoYGIo0vR1XH1Q6wL30mogU5IUYoZ3h0aA4J1s2y0i/4+rUaqr3O/cPyKwDEBzOMNF9ZA7rBFzXg02lsZPz1IuPelv7/bAkDam5aiExZGnDGCkVMkCdpFtPRCn4ZDsQKIY2bNfb8UDZUWptaIPkczy9Fw8hEu+9yqzNUDx/dGpgSJJkYpVG8Z0VnXcx8ZdXotbEbJ5AxZxrZ0/gamAq6xDu5nj1CCKR8hOmJCoQjJ+PFtet05RySxrJyRwQq1IMvttsxiTw93LYzeuuJYuqbxtY+u2rfylhqsoQWGgyI2zcPH7VYhEdE/EmPuydlOoNT1HRk4HilNu4n9xQkVnrnL79ou4gcZpMfsrnGZ3ZrYgdNPnIpNhPyIhugBcVQz
 hql13veP
 UjsFlazne6IV2a7O1AvFFDOSS7lcFHMo0UAhvYY28Nrn6op+KcwgTERadHfGTJ5GdkWa9XCP5m8lUbdV1rpCnKw6NLc7unHkRkQKDpphQ/IzVnGB7Awosp7CKpBDzBuzA/N/odHXxRQp6Y8pCW+JYYANb7lsysYQygbjERqOgGI5Q9YsHiNeVmhszlHsbjllU9spH0IuhyeZ3IR7gFlsie/E3x7Ep84WQddrJxVQBdxl5+K98f6KIgP7zxk6pgwD6/uprKL0/KUmUEnxbBvcKWEH0FxBgR6vgUdG59kYV8C3uPFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 13:57:55 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > I rebased this series on top of mm-new right before sending it out.
> > > Should I have used a different branch?
> > 
> > mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> > this point in the development cycle.
> > 
> 
> I’d like to send another revision addressing a few comments and also
> replace the `max/max_t` check with something simpler.
> 
> Which branch should I base it on so that Sashiko can apply it
> successfully?

mainline Linus would be safest.

> Or would it be better to send fixups against `mm-new`?

That should work as well, but it doesn't give us a Sashiko scan of the
whole patchset.

