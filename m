Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F900FB44A9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 05:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B906B0005; Fri, 24 Apr 2026 01:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CDA6B008A; Fri, 24 Apr 2026 01:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51E46B008C; Fri, 24 Apr 2026 01:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE16D6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:07:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B828140628
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:07:50 +0000 (UTC)
X-FDA: 84692267100.04.092655B
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id BBA5A4000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:07:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kvvMUI+9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777007268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oUFDhoYbNqo8dXYU9en7BHWBBYUPonRzR5+Mg8X7c5M=;
	b=0w23SkGA1Wy7BvwM01FnItx+e4UKLRoKKLXM8c3//KeT21EsKYGDjwZKyYgur98CJoZbr9
	RjQp44lNF4TpWwsHIN1YZUpSsyeHFf1e8avicgYAhl1Khq/mRG3fd/ApEpuPjMp0tVmCn/
	tYILXeVBy3CFF+VSePeUEmCbS/3Tc64=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kvvMUI+9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777007268; a=rsa-sha256;
	cv=none;
	b=k2WUYvagC/vSPBnRZI8UEq39rPkZvA6FbFKezF5Rn6eQ/i5HIMx2e7PhoQ2qxMf2ObXbtV
	mMs2qADPHJYfK6nn0ccSKl7/l4BWC87/gvAyV5ce3yg1XEp2tirw6xkvgMg6ArmRgqgtFI
	SWtlaSeJ2XuLUgKcbzNxbb1dBTcxYOQ=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35fbca04006so3807670a91.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777007267; x=1777612067; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oUFDhoYbNqo8dXYU9en7BHWBBYUPonRzR5+Mg8X7c5M=;
        b=kvvMUI+9JlxcTVrTwkrO97WI4qLj0SyOwqSCqI0KOuk67nTQ/IqSK0BOoEKmhCtCi1
         tozhB9f4z5prKhc4+Zvd+E1lM8jUnd622w8KlAy+jzKl4er/L0x6hS50Uk+1X1ExKpPm
         D0AAWY1xpwAhGW15yfjceL2ykdsucl+cKdWNOY36ukIfEDmTD29DwEGFdm+iGdfTyVMm
         uvih91oLfG/zhlcwKev7II9nvhBr8G131EKTNycSZ/5tKmmxuYKOa5AcTKtN9Ao9ZTTG
         rsZcm469NGe01txpWOLrj+u2zEi0rDpHQXaRqRP0gQzh2CVHwLEawG+lcv0x944XuFSQ
         pYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777007267; x=1777612067;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUFDhoYbNqo8dXYU9en7BHWBBYUPonRzR5+Mg8X7c5M=;
        b=ssk/k41rxeHteuY9bXIhFXr9mHkxSlvuJkhMLnkI8dlBBOzbPLYKkWreB+j+z5EDze
         r/7kuxNcZ3P3RwWtCyV0DL40m+QVOn5j9vuErAhZC3a5FG3G4MUvboOkn3cv3Knvdn1M
         +HbqGlyIUUJlWqL8eK+Jg1iOlBg2Ar+TjcJqMqpNNBaQ848KkwO4q+JIsoD6U/bh42jt
         koRfYFxUyV4oPF+1BYJnJcPuZVSfANb5l904zMcjgWgRyx//9BiT86njAFvrz/SHTp5+
         N2OJfWPzunfnbA09wX0qD13i48WzOBTuhiEvzueoYM3WxqY8ChO/0SaUG6HV8FvejrQN
         A/Sw==
X-Forwarded-Encrypted: i=1; AFNElJ/gI+LA89cdxepOdsTw65cY02h7cTJdkkEZU8CfRh2cdxSNlylmlAK9QXR9T002lsxhrKdaww0MaA==@kvack.org
X-Gm-Message-State: AOJu0YxNiVdWydkxTg6LKHMhj0KwZQ5ku/oBH34D0JJZOkSNf1tCcdJc
	210oQ18/dukokFJOckWyq0M3/o99EVrtYagu2l1zILbY6AxSEFWB+jCN
X-Gm-Gg: AeBDiesFbHA4js7wkwNzxMT51DCHhNufw3ahp/8BPtLBF/9/oz2Cb0lrPwmbcT5tQW/
	/1zu10bTUGEsBsTe5+3AnjyjjZQ+oCFXDJh2D+vGB2BWfSXSvOAu0Lux6NZU2FF/8vKEat/0lRi
	lftzlnPUYg2r+CGE9td/j0eMDRLjkX4H3LbUuTJzNcO+DY7vlq+hT7ZjuQm4PkTAovGsJ7SJo5C
	WYK0YIqsgnOV27Y/MR2+zFLAeSL4784qEM1LwIQZVHqVPkLS4dSm85tjlu3ieJXfpRqdQxbD0lj
	2F2EwuX9PG8HAOU5+wCb9kH+E78h0AFioRbAkSgR0jJf3Zru+//I5skPYwTmXbupv8VBqvn3VLg
	PN6WtMK+vWoqIGzkxRKZ/YI2QY+8vt/M/GmkptmVCPBaMkmfEuuv/8V7LHIRmV4rir2QNX6V3jo
	qYyGo9ol7PhORKwuodtgdFVKKLbp8ud92xT7xqTMHNx8c=
X-Received: by 2002:a17:90b:5890:b0:35e:5723:85e3 with SMTP id 98e67ed59e1d1-361403f12ddmr31417110a91.9.1777007267369;
        Thu, 23 Apr 2026 22:07:47 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fab1c32sm8342149a91.5.2026.04.23.22.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 22:07:46 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, lsf-pc@lists.linux-foundation.org, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, Pankaj Raghav <pankaj.raghav@linux.dev>, Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, hch@lst.de, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
In-Reply-To: <aer0wd2Ig0hjN3R0@casper.infradead.org>
Date: Fri, 24 Apr 2026 10:20:27 +0530
Message-ID: <v7dhrmgc.ritesh.list@gmail.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <wlxxrx10.ritesh.list@gmail.com> <aer0wd2Ig0hjN3R0@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBA5A4000B
X-Stat-Signature: 6u5a5wgmdjwj9m3ckbsun53cs6piuqhu
X-HE-Tag: 1777007268-896432
X-HE-Meta: U2FsdGVkX18FVmfkEWc00tajW3if4axckYunvJAGCOwIp1UxgQaosJ6fARbZsu+50b+hk6HlXmVQeOGuPLHpwLZPcWWFPdO1At+LVjYoCWbq9w1c8veYhq2QpE7Am0B5B1Uum0vT7j780pRR2q6wQt+fjvT67IGbzuaDfrmeKXiNzWH3opvysP8Z2EeXGbyNA8PehEx4MimX8X5UQCtbqa24ijIXVZHZ2kuVwjhMl9xFAWQB10E64E1YJs1vYBdCQJJsDzVDbV9nCrILY1mBBqJNZ4sclC1tUivynq6ROxq2Be4E8y4fe0kfxaqxqBwq8p6sHUmnny3xDAEVJZKeE3TQzVZdaFbDQcAJOqG6xiAvXgP+jvwuwMb6TtVptGazUVzlm7nMdx4eofoUF3G/3iG5OZrhKQ4Pp+oku/M0VXjM21HTdDp+ZBPfg1yUd/WNJMnTDa+tfp73mEN85g+spwMm6lM/YemkY+3Rn5WStvkjQwaLz0MV69qjr4rBwysfsLS0PrQzG9x+x7dAgUDzZvo9XOPkR0yP7SWI0fPUcsrr/pwALNhCyBasRiGOwE3TIKUkmP5DBFQhtz9ey+MgGxP/nrqo9v4i96+weTDjQRdSlMv06rD1MBs8cKXFKq4goSPMdY60xAoVdZ/gCosA67/e3qHWe8uN1KQvy3rpfcUkPaazQKR9IoZyRmJh5VCMYp7S1ROPl8BH40WmgfPAPZyvveX5jC83OH8/0W06jrOl9l+peErWnHiKHoJFwpwictf4LQ6I8v4JwcVjIZ51b/C5C12MhdiZgBl7ZTVcW8rKI8QhmOF/K6xWAQoekj0iEHQwCgSbvur9m2I0+AbXidKwPZ9yvNmLfb/yeOKoo3+zI6dv0yakMZvGaEL/hkkvoe1Nv3FM0nuvGte8rlBzyspSst060IZ8r9d/WXcgw12nLnzOklZTc+iKTVNpDBI6XurQJxN3tjLgb6pftbi
 1eqnWupd
 Gtg4OgSszM6CiAUbpLOEu3XeU48sl4rYr6CbitW3LxxW0fej9fKZO7NaobDHFoJKu02Ylrmb8pYmtbKCC5lVIOQ4VgbO8EAAxqY9Upv374mLs0gW3i9im4ctxQjBBgyzFKujYFy1+YyWckZnZP2ReIsMah9N7Hwr6/umy6XbgoF2bRVW47vXrPNDO6fHYekb/h8vq8nHfTsuAj9P9TVBxofsOyvXrzblJNob/LHMJgBis6iwozPe1VF76r+oCIds8+jKKwWqgLlcs1N3aqs3ZTHmp5dCYhftkBvF4SRiu5J66EFfk4KyP7zmTUTaiBVyZyfMT5rqDNcwMP6nBDQ4SwzgPqnGVFYiXRuYQsV4naUipkKpwNsENxqL9VhIi4XTm4nalzi8yrog0pjllTk7vmr5DXtRUYCUyT1V08+S6r85vFN0boq0jUlEeH2Fkq2BQkagDJPvHrMLQkkGgqhf75ATt9Lloyz5v9ewy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Apr 24, 2026 at 06:32:03AM +0530, Ritesh Harjani wrote:
>> We were thinking if it is possible to extend the Buffered Atomic Write
>> session into two "continuous" halves of 30mins each (total of 60mins)?
>
> This is painful because you've requested me, plus both Storage and FS.
> FS has lots of space, but I don't, and Storage is also pretty full.

I see, sorry about making your (and PC) life difficult here. I know it's
a lot of planning :(

I think, both FS+IO folks will be interested to discuss both of these
topics. Do you think breaking this into two discontiguous session help
us plan better maybe? In case if we don't have any continuous slot, then
maybe we can split those into two.

>
> Do you need me for the full hour or just half of it?

Although I understand buffered writethrough is an FS related area, but I
am sure a new writethrough I/O path is an overlap for you in page cache
as well :)  So, yes, it will be good to have your feedback on the second
part of this discussion which is - buffered write-through for buffered
atomic writes.

Thanks again for considering it!

-ritesh

