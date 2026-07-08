Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD17C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 21:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6B16B0088; Wed,  8 Jul 2026 17:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68496B008A; Wed,  8 Jul 2026 17:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80386B008C; Wed,  8 Jul 2026 17:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5A36B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:13:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E761AC1651
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:13:44 +0000 (UTC)
X-FDA: 84966861168.17.F4F09BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DACC18000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:13:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YyDX2QRZ;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783545223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRV8RZcUgp9koMPGwe0xKyk7ys1YKTWHC+0HjcxhXIc=;
	b=S/qKc/JHK1WOf4XsXPaIth5HmO479bkGDP1lAKvnX1wJv4jdm4p8XRxK7frrN9UKbH/20s
	rjouhjvkCk6qBawlqNjuRiPKM3QobECYqnZh++yQMTz/Xe58+ZL/FGnaNO3f3DHCi+gPY0
	n5PUIs3du5xEZn14+eNdfgFjEfzqNO8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783545223;
	b=Z5W6fGSLm3tb5mRSJ1CFd5jhIMoTjjIakBdn4Z0Ki0G0cwCKBHt436jbExyDoQfXHdSfM6
	uknuRLdpoYwiWSJcZmk86EGC98emVbOFpp8caW1o5iB+CJHSicvA0EVvAPK1dEv58Fm+A6
	L2mh42Oy9gb2/97f1MpbIMVMJRSGmmM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YyDX2QRZ;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E1F46001A;
	Wed,  8 Jul 2026 21:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2861F000E9;
	Wed,  8 Jul 2026 21:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545222;
	bh=DRV8RZcUgp9koMPGwe0xKyk7ys1YKTWHC+0HjcxhXIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YyDX2QRZGyO4x2WFzpzwDfX3EZIIEl7M8KugZ11wKCSdJcUbehz6ToqI1PYLf+ac3
	 7m82cp+LKCckDKAKW09runSGNC4vN6ENxM42OMO250gdWfdTYbabl3zYw2c0+d46B0
	 IhS8yBDBWMuTQ0sa/cmcPj5SHnJbdhQFndpZmqqA=
Date: Wed, 8 Jul 2026 14:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Subject: Re: [PATCH v8 0/6] alloc_tag: introduce IOCTL-based filtering for
 MAP
Message-Id: <20260708141341.972033b394dfcc98439b36f9@linux-foundation.org>
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DACC18000B
X-Stat-Signature: s9pyhq6ty6gq9ke3udws7f68og1c6qxr
X-HE-Tag: 1783545223-477146
X-HE-Meta: U2FsdGVkX18ygjnQjdic9nct5prkR0J5gKFG+W58VsQSJy1yTDpd8lAI+E0q3A4NuKSbdEi6Qa8FaH8aXpCBiASY426o8/KB9re/u4s0cKeFcvsaWh3ylW+jtuZ8KIa59o6EoqeT9T6HZ0BfRhZRBLxXLKlhtuy3jJDRnz9iK0GQF1DrLsgWvR5VDjyYNGxSA2j+z2Kyg2pn0ZjcpWuaidaJ/ddfu4nWHB4ZgO0RkYQooEE9tIsCfclk4gyZ48veomO1j0l5I8U8D6aSkMTE6huM1+8GCZa+SN8XndToyKFEF+0Aa9MEsTF1L85HC0eBrtUtxFCL8/J6JKQbAHS66IidAc/MRjkRJHQC8OKqk1nc5sV/AiM13K1tWnFBLrDM7BQ1oCfPHj2qJSKqamjtMSSmdOTVnXyE7JEHoVB7qKi8LyklKo+K6nH4rIQoLHM9K+roc/8ZjghfQWA22y6eABVcIq2ujWIxw/Zt/GyQ/A+Y4/xKtmKi8XDyJZiL+rAArwcbXIe3Dy2ThTxwP31e/knvxKidD6PLBGVIeyZpx/54K4KND6Bx0biqdRiXBC1Z30PQVLX1TQk1y3lTTTo7a1N9+jJ29PhpHle1Vb8ufq9PFg5+j4vJz98jhq8ehHD9Cx7vKCpmlts0SG00HXE8E7x2IK+5JpoBGbBJg9ysM7OAMYk6/fCj3UPCJfB+9tDhVa8TmkAYfdXXYBQkVwcKKZklravnaLRi80pGJOpof8WuZxhWtnmCaCB5KPMokAiIytjzsRRs9UPulnPnrvV+BZre3F23xHekOsuxzyuUPSdiEUcEk8ZOoYIQHVDb12rr6mFLmhTlpt96gTHlgJVpGnlB3jJmdJcHFAZEGhRvnElYflMbtb5lYDkOHVER+XYQHApL92HwwqBhpuzhJ14ZRd2RNAO/rs/DwT+e7uLhYN7Guz3TZT02PVn3jJXsKdrfpvNROZVmPnyHU7D1xXA
 KLA0DNPl
 PE+TZgMlA3IPBq92kZtNc+2STpoLBK6GPQHBVR1FjAkSllAecdXXZDYfQM/bqKG8kGhU18q4EZiVPyAB051KhKzKDoTnLDaooxTU+4F1lD5rtjZDc+Np8O+oiBpi1Mzu4QRmldqIzsty7eC/EbQxkNi2u1KlgNcrLx5leonE1qxsdeKdzzqJdQQmvn+Nrbq9EmadFU2Sp58bPgJHMjXAubZb0hGfwmLNuVLGCSFij8uUZi/1XV6YrX1DOomPTGJNvWeEbXTBtkDpkHJm40SMBdFaIsv6FDeZ2VeuOckw1qg52Ag8WTDhjl01DD4QSJZCNVAAx7tSpjFDOUCnSF8Eozj+gwUm/IjZpssCexZmla1ytZfdY7KU+gZHl5B5jqSv9r4Kr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 18:01:22 +0000 Abhishek Bapat <abhishekbapat@google.com> wrote:

> Currently, memory allocation profiling data is primarily exposed through
> /proc/allocinfo. While useful for manual inspection, this text-based
> interface poses challenges for production monitoring and large-scale
> analysis:
> 
> 1. Userspace must parse large amounts of text to extract specific
> fields.
> 2. To find specific tags, userspace must read the entire dataset,
> requiring many context switches and high data copying.
> 3. The kernel currently aggregates per-CPU counters for every allocation
> size, even those the user intends to filter out immediately.
> 
> This series introduces a new IOCTL-based binary interface for allocinfo
> that supports kernel-side filtering.

Thanks.  The important bits are reviewed, let's get this in there for
some testing.

Sashiko had a lot to say:

	https://sashiko.dev/#/patchset/cover.1783532853.git.abhishekbapat@google.com

I think you've already been over this.  but please double-check - maybe
it found something new.


