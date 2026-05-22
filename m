Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A33CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8406B0093; Fri, 22 May 2026 16:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799596B0095; Fri, 22 May 2026 16:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688266B0096; Fri, 22 May 2026 16:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56F3D6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:11:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBD08C31ED
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:14 +0000 (UTC)
X-FDA: 84796150068.29.7952B6D
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf17.hostedemail.com (Postfix) with ESMTP id B992240008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779480672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL5vm2UpNBC+PY+37RcqMjcjlEwTbKqv5Yb/Y/xCmVY=;
	b=7o5yB7AatFkCcr2IZS8cWSntOdef4pRC5rUI/u5tyUDnou043blIJoKUq8krASyWbiQahA
	5M1ikOoZHYSwWdrxzBmBuVW3wxTucbvNSv60oSSg0bxeeCcacwnXNZc4ni+KAW/vSfOYZp
	0hCO5y1kpz3Yeaj2BEeQARjHKJnp4wE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779480672; a=rsa-sha256;
	cv=pass;
	b=HScbgZUlaYanT5ghVma39WzdGeGI5p0Lwed0LlMSB0JWC2OvTMSSzwS0DTP5W7Cf7S3uYQ
	cOxbu2yHVo0bgscaAmaMbhRkcgJpSmRafc71/ABbAxYxhgMbeEFSsbdM4rG21nVWF9ACvb
	BBxUmYVHV0GPwbLXwNygcbJiRYEVgo8=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 539219169A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:12 +0000 (UTC)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 266181A0AE6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:12 +0000 (UTC)
X-FDA: 84796149984.07.E39728F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6350310000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:10 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779480670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL5vm2UpNBC+PY+37RcqMjcjlEwTbKqv5Yb/Y/xCmVY=;
	b=MlD3Me3TBG6GfRy11xODVUJxNiL6sVPyVCzz8gRUZc/3vt8o2zxhfVrcgr/EVRE0v2zYoC
	cvPMenJH/mr8619Jib51h1V2wfce+yBqyDhqAA+v/z3culeZWe8rVG90LO1JRcnMZY2Ikg
	Q8/Ye4cdMGLfGW8Wgs/1rmUZfKr4fAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779480670; a=rsa-sha256;
	cv=none;
	b=nDjEaUk8BptTgU6VJnGopSCcUdWOvQoH97wQaKHGhIosaZMPGVKZeSVf1knQhBcQNb1RAX
	GUS97gaC7XfyvhG/DFQ2BCQI3XTl8x4Rh5uYkp8Wm3vYB+fIeoFiM/NJyJSDe9MrXun9Vu
	bpZwocryiZAYCe0fq8JAb/pDQUsNV4U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="J/QtPeu9";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B25A960136;
	Fri, 22 May 2026 20:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129051F000E9;
	Fri, 22 May 2026 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779480669;
	bh=fL5vm2UpNBC+PY+37RcqMjcjlEwTbKqv5Yb/Y/xCmVY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=J/QtPeu9ojSLdlqg3mEpo0WN8+BvCpHUmVYlo0DtcxdxyX3/J7PM2QnMQJNJecNBS
	 Li0Tj0nx7+HgrDhk0IDBhfT75dffs0fofFvWtC+ae5bOtYLoMr6/kRT903VWHJKWcA
	 hKB9gNAZEIwNIhjuz9KCygR/mIbTPuji474A/DSQ=
Date: Fri, 22 May 2026 13:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Subject: Re: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for
 MAP
Message-Id: <20260522131108.f972659717367c67082f3766@linux-foundation.org>
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX18YVo5WKzdLJqSQZ6kyesZwL9o9mfUr/UGwSddmhh2WzLk5iiZQi/XGpMbUmCxTqWnvbWYANPj+W4UW2D475B6LmJWoqj+q+v4ub9uB9bS51iQUOJNLOkigPbOFzx/7ZG0ic+DL7v4Zh3FR0fjgnRvNQOjUulIVBf34dGLTfcJEJcbZrYUnz4ITeCqJ9CyqlHvNfMGQoRktGH6lGx0e/4Ol+7DFnuErMl85iwxGx5UW5egERjd2HIozb2eSswOxJz/PgKT8pWwOtrfiI+MVETqDm8YLCdzxFUWb2n3vAcxS5FzFkrUClljHEfh58F/NEH2pqKUwhpA+1Dn3bg5JVZ1EDv7Ymk1ZVfDGkARjoawKcB3T8Xrk9brqYb8nlNKzA1fk9uJ2ZpjnYoHxi78umZ8ILIih5oNG/5wDOiBbgRw2NDS/b6TMwOPqvEZWi1PqjRHbV/+hIFsXwxLYjnMvCmcE+94RgYUVTZXVbsShjEKOmv27DLXuPrNWeplXjXp337tI6s8XlIRwLQ1Qkm6Uo9Xoo8XOgyqlBauL4xra/ygmd6cOwy7OPt+uZqF8Slml1+ox+k5ZGzH3zl04pWCgBU7tGMHEMMbCtbTJl+XDYhAxCGoe/bB4vGv+tS2c9dy1p+30Xp8qR6e4vK45mKOIctwLBB2inxMffzPXet9T+lhUG2S2Aowntp6sITQ/GMjqsWprgpXHLSuXK9IQp5atT2HQCd9aOHJC8umT7P0MFi7NsK7HNXT3zIkkkGauuCnFg6KLmFgOv09kKUCxy1hPX47d6jMbVbH4TfmaXH37BNbQXynTqR8wVIAjnevcgjl4oRAe4DF1iaAHxSEOi1Yb+HDQQSK6cG4y81sioXqKBSV/wxTM0lj5Hbm3IO7YcmnUNbZ35CZlYaYRHv+osJALCPbTH6dEsecaJY5UGGD/zDYVJagjDgo5oSc7OJP1ccPgZyfmkQMIDIS
 JbnEEvUd
 jirA0/iDyeoFcvhappgUy4cNE4VSNJ2d9h6BOSvnP3d943EOTLL8p+xMGLv0Ymjt3smXdBfP/8lbmjDd40OaAOV15TnULaNFeDrE1GqyZ7jBrgvZWWH2I8sY7UXnIRAxxJ0GuqXO6UBwWhOOzhVOE1izYIv0eWBkgMArZKhhQ4VP3gKJeCesbBVC5OnUFk0DWUSVH97vMMnVKn5KdyBDa6J4NsSLvcorQMd8dk3aOeLBq5otMOFTkTiXNAJXfW0qc8kxCj5Pcm4P30UOvbqPr/Gem9puEpgRUE60VyoGcDRK/nc62M7lVTBli+h9ND92ZN+s6r/1nuokWM0nDiFL+k0R+M7XU+MbTpxT9b3gj+fSHnV+IkSLBosyVkzeaZUtKOneA
X-HE-Tag-Orig: 1779480670-767450
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B992240008
X-Stat-Signature: wy8nodwbom6swn51i3kf3xzxubjgp8at
X-HE-Tag: 1779480672-830438
X-HE-Meta: U2FsdGVkX1/y+ODW+JCHNSfgEw4HaUCb+l9w5d2E9ehdB9Bir3PS4sBf1uXrCOCc6F/y7omKFVrrp6LS65/gZOpioBc8Bazcjasa1+Y8Tg+fD4E6p4Rnpp9zeQn1gd1R9PEMgYBYRROc2076W8H5fIlsdw5feJjhanzc2oUhERJfaDX6fLRxkmwnsgzAZ+xBF61D9ODAYs8hALKGK4PCtODFDBscVuOre4LoZ2uvwX1PisG70XrJO/pRTTaHjEmbrQx3cuNCVV5aa173Qe6DRWz9BveHV4pkyfQEfAG2l+0d+1LmbcQyeiGuFrVl3izBDGS1nQp9hXOVO/kp7BqAQ4p0b7IgJ5s74g54a6kVmLXBGh1U9zGtsaHZmIh3VFYY+dMxCTomRUKzGASB0kLzewyW5LhWdstlhESQBadB5/OK4Z6kkHA6J70nPLBr4V9rffaTYkW7kPltJKZcl8KxR0tEyK8SUd6+feFicQv+aojgPjD1+xvUuvMI6LRP0JqRgMlwtVxz3RWBD0hSLFEBhQDw/D8AbNGYSQs34yHS1Q3q7sSFB+ZQ25UvhCq6TgpO8PVWm+qTHC12etqSordaI7KnkaDlBE3GNOFvF5dVFvPCFuENdnV3UBpdhsvehrv/Lhf3xQtZZIKqUSgbFhTLq2UjORMAciaYBWhzKZhzTb2yKTDzG/cZbL6DqaObrGy/sk+kcrsOGaXZ9MGfwsxexLLsMsDvnYO7OGuHc4XU2HRBFhdS6MqkYPcK89u+CP6XYr6BbJK2e5VXNptdaOzujWp2Q9kVZNz8kkeL5MIyGSWdiRwvmUyd5iayy062RZaLDZD0P7KgHgyumbOgJXfeF5JM6e+SeimB5yyJg+TwB0Ml9IjtAOKQF+ir7sXY/t2Tmrg78oGMxbzs33yQmS1ic++Q8oM0ng5NzUyaJ4ZVayWf46M+lfSmW/SHIS4iLMKmR2cyH+5WfhtzRB5/WVM
 hpB3gzdh
 YKspiuD40Bti1RR3QeFg3YEikrkGsxs0qNud7BRAmgdYMrsthsYlR5imZ6Jlp7mTXQYCpdp/o7RtmfRRqH8vxEBKU66irDrzPprf1v8VZWsuUoOjrxL92r7Sx7uMWa0e7RGEquSUIinoFxKFb9XFkP+RGNmhU9qUZXtP3SN5HtTwXktqK7C8CLn8j6UdmlxkZBkEyC8i2BXItWD+Kx5B1EC56naqSyjM2Wx/v3/AK1MYrRtt31GsUh5ZCc0/Lj4UPzE9J9wkocuusUNIm5PeSWpvLO+VwqDzsKii43biy1dl+npvwePBRomn+hAQrrgJaaByH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 17:45:32 +0000 Abhishek Bapat <abhishekbapat@google.com> wrote:

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
> that supports kernel-side filtering. By allowing the user to specify a
> filter mask, we significantly reduce the work performed in-kernel and
> the amount of data transferred to userspace.
> 
> Performance measurements were conducted on an Intel Xeon Platinum 8481C
> (224 CPUs) with caches dropped before each run.
> 
> The IOCTL mechanism shows a ~20x performance improvement for
> filtered queries. The kernel avoids the expensive per-CPU counter
> aggregation (alloc_tag_read) for any tags that fail the initial string
> or location filters.
> 
> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> 2. IOCTL Interface: 1ms (sys)
> 
> Scenario 2: Compound Filtering (Filename + Size)
> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> 2. IOCTL Interface: 1ms (sys)
> 
> Scenario 3: Size-Based Filtering (min_size = 1MB)
> 1. Traditional: (cat ... | awk): 21ms (sys)
> 2. IOCTL Interface: 14ms (sys)

Yup, textual interfaces aren't fast.

And ioctl-baed interfaces aren't popular.  One would prefer to see an
interface which uses read()/lseek(), pread(), etc.  It would be
appropriate for this [0/N] to have a discussion of why that approach
was not chosen.

>  .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>  MAINTAINERS                                   |   2 +
>  include/linux/codetag.h                       |   1 +
>  include/uapi/linux/alloc_tag.h                |  87 +++
>  lib/alloc_tag.c                               | 303 ++++++++++-
>  lib/codetag.c                                 |  11 +
>  tools/testing/selftests/alloc_tag/Makefile    |   9 +
>  .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++++
>  8 files changed, 918 insertions(+), 2 deletions(-)
>  create mode 100644 include/uapi/linux/alloc_tag.h
>  create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>  create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

At some point this should grow user-facing documentation, please.

And the right time for that is now, because such documentation is
useful for code review - it makes that review both easier and more
useful.

Sashiko had a few things to say:

	https://sashiko.dev/#/patchset/cover.1779471082.git.abhishekbapat@google.com


