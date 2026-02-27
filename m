Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63581039894
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7956B00EE; Fri, 27 Feb 2026 15:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2586B00EF; Fri, 27 Feb 2026 15:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D19A6B00F1; Fri, 27 Feb 2026 15:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6E06B00EE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:55:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A97CD1B8385
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:41 +0000 (UTC)
X-FDA: 84491442882.11.8F30B0E
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2B7A80003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:55:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZoQs+ztZABr8RI/tnJQw2j0xRNuFCXJ5G6F6LpHqCU=;
	b=0+yxwWVe/X6P56YWXAmj4/JslQT9h9b/5XVqMkDvtLc4UalVW1MKG9L4CbAnfyX1mpAj7C
	K/Q00KPNTwCGbQNSmc0w1IiFCPMlltoakekZQ8ezFftZjyX9gBl6lOAR+xSoC0ONDZOsD5
	TcI/vYTRYvr9sP/rjmLVoPZ0ToyJBFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225740; a=rsa-sha256;
	cv=none;
	b=uVWjdGQUPWvMygaZuzBkIqjnseISJI8Zp9aH0ufonP7xGUW7+s2aGhMi5s3KWynAaE/TAJ
	ei8alEYY3PCnEFGVy3jchNgGCAQYyDfO8mvewpbLkFS7i8pShZKIk1/LVnkIY1aCwugCZZ
	+KX06RRvh8Tx71EBUCThzjq16aVkw1c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB7E95BAE7;
	Fri, 27 Feb 2026 20:55:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 5D34A20029;
	Fri, 27 Feb 2026 20:55:36 +0000 (UTC)
Date: Fri, 27 Feb 2026 15:56:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Qing Wang <wangqing7171@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Message-ID: <20260227155601.18ebd3ca@gandalf.local.home>
In-Reply-To: <20260227102038.0fef81e9@gandalf.local.home>
References: <20260227025842.1085206-1-wangqing7171@gmail.com>
	<aaFrmHzIAkEe7ufy@google.com>
	<aaF0zS3xh5KgM_yy@google.com>
	<aaF-bhAIhCgusG9k@google.com>
	<20260227102038.0fef81e9@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/A+ALCsFBkYLx8AEDKBhKfkPGlnqTTPEc=
X-HE-Meta: U2FsdGVkX1/p0bJvgdjQs6KYjXcFpyV/MlnSMf70JAYln9Pl7jBwo+VNmi+k6W2glnyq9Y6jfimC97v7pHsSkWNa9p3COcmXjYbQnCcq8v1Pg3dB+ZwLEQkcJTSFI5Kt8AjINSE5Xuh5TGtNcIuITM0fvReHL2HrrdxcCJaVzhgyKTir7B3XIoHWgF+Lzs9oH6Futp+ioSqhN0+BIcSUAVFT0TZ7KYjBYNtRSRlAp0D8BD4Jm2NT95EGfTqLnJFRheCnW3EfPYZc0bMgE+drabNVuvOFVjpsMlVwPlLM9d+lFdLhcMGQnoVN0Qzg3q6LsPAkq1p0TVH4KNkWyaMcFj0MUlHGE1ahqT+8RtRqgC3YdgN+W/h8sanqZlvGC1EJgM/CwkbuWk8Wf3yb/t+fdyyizo91m7hQbjSXxkkNrJ4=
X-Rspam-User: 
X-HE-Tag-Orig: 1772225736-585346
X-Stat-Signature: qowkdzp7am53kdeb57n39gue6stf8zay
X-Rspamd-Queue-Id: F2B7A80003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772225739-596802
X-HE-Meta: U2FsdGVkX18RhhWjhHqFJRyZQ6+f2ObtrAF7KNGMBlzTW8KWF0AYVjwu5P7ie2IuUR9r8tYMlPxYptU+6NM7adpsg6wvIuCTZT0qBG/uekIaskCboUacwHK6slRYpRq/MUvrpp6xc/f7TUxX813uWwmB4csEH5WELN5frRmAo13WVzaNkdQU/uFFKcDNmaTdc4roj60rUl06LtBK9V6jRAJK+mNlZ8C89AiRgN0a8DgBTlNP3hbq4pEpw8VR/ieKa8Gn9Ap0KNYK1yMXlsKSDGp/26uf6MVSOcGdzaWZHEeP4lrS+QeFHwjnrvdUaIx8br+49Kca2ZnJPlOS6JjZWKtX6MsJ6LIqMJGhc5H7wwKyR67fY2c1wBvfYWk3TiQZyGD32U9Hn0j3eZFZeFiR+tXegGK70R/hzwYpJnqy421xhWdnUgEP78veINke1YjobpHKKwzQAF+OtHoitG2Tq3QMKd8sVTUukRAWkHY+phml9D2ucT8wunLijGG7n1Txto6AierT3VEFI2Q6NGHFFCFE8A731xgESfyhLoBzvZLCc+TcLr11NHlI+b6ap/AUktBik3nTN525CM2b5B4VxM2Ga0jBRSYBUGErxV6HpsJcVA5RCsAmIfFOzBlVc+YkizpZ2uW8UPMOyxPn0wgOZ2eyKEHpXqZ2kA6/QD4naSLECTLcqiyMyoZle3HdRYwUZruVjy7vAbXDl681meNWyLpXwPEFZeA43vXNnE9AIECJ52upzAY5skxDmU8GwXIyhQWw/ife6fYAPUoXFajn62vuFLSIB8ohcblZ+KPG8UsO0QiLcQigpTu8MMF8Ggl7gFPWm6sSpkr+IDhuZ9+vGjjcEpmFycaQAqWDczW7DYYzgZBiQfVGsCY1gV0Nlksgvk4yvI6GNeK8oT7WJK23Zqs/GXgRM9U2cfgX3/YaQ9RmfaYmIYMhsgoGbZn2qwCUQw32MFvd961MGakJWMC
 Wiig2BiH
 /PanEThhMLnUsoMsJVcMP9zej0ZVcEwy6uueylVwua8QtZ+qIsSZiLABO97OHG6sOMLmegXt57i7BuNq+KLDUw4BWtIYy1D0H7Xe26i6VStCVeHKaZ4TD0gLRNYsCn6F+N9TDiKNGVzpqtnqWH4c4WXWjghvI8Vu4Q790f21mYpuxaU9KsU/nJH+t6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 10:20:38 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 27 Feb 2026 11:22:22 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > > Ah right, Syzkaller is using madvise(MADVISE_DOFORK) which resets VM_DONTCOPY.    
> > 
> > As we are applying restrictive rules for this mapping, I believe setting VM_IO
> > might be a better fix.  
> 
> Agreed.
> 

Adding MM folks so we do this right.

Dear MM folks,

Here's the issue. When the ftrace ring buffer is memory mapped to user
space, we do not want anything "special" done to it. One of those things we
did not want done was to have it copied on fork. To do that, we added
VM_DONTCOPY, but we didn't know that an madvise() could disable that. It
looks like VM_IO will prevent that from happening.

But looking at the various flags, I see there's a VM_SPECIAL. I'm wondering
if that is what we should use?

The effected code is here:

   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/trace/ring_buffer.c#n7172

What's your thoughts?

Thanks,

-- Steve

