Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF1BC44500
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F5F6B00B5; Fri,  3 Jul 2026 20:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F796B00B6; Fri,  3 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357EF6B00B7; Fri,  3 Jul 2026 20:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0898D6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:39:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65B051C79FD
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:39:10 +0000 (UTC)
X-FDA: 84949234860.20.16766B1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2784540002
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:39:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OsAtGgpf;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783125548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tmeyv+yKDLe4sMQPHYRfOsYX6yQ2MKLh3F1KPVmHY7E=;
	b=sYKRZWGaU+1HfCsvvqjaR04YXjn9dtOD+8/ivXhwbJolw/3E3mIDEztLYMxbTFW0mSJE2Y
	7/ZSslbGhyW2YzbZaT1jzhTLN/RUqXL9FpZPiHCirc5JOriNOqadGDfrtUJNo04Fzx5jA4
	XntQw1Gvx1yR/DV45xg8hA3GjsHxH7s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OsAtGgpf;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783125548;
	b=GQbUr5TC0a8wx3ngDWlDUSkMq7AtzoUGI95TzINWzw1AO5Y6+U5PhvO48yNSJ6We9j1yid
	KAOQ1C7Xnykfm+KyERmsGu6+gagV64MUxBKZfJCdss3zMhghqBZPZ1LhPq+z8pfu8gtxms
	HtDuG/r7uys3FbmhDToY42S+0Oq3Lrs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tmeyv+yKDLe4sMQPHYRfOsYX6yQ2MKLh3F1KPVmHY7E=; b=OsAtGgpfn2ZZr0zNc4ly0ohzMQ
	Z1saVpSbGF+o9EzTKmnHyHDrG1P94ZdjNxe/AYOxM5ySV4WyAMi5CExkGLqhrGWsyK45WZfXv1apn
	W1x1PEsN80UGsHRRAwiIODsvazzWi3XAygJQe1DUvSE8nsEea3L6Duq1274b1yJOisaPgEAlvTYaH
	Nt5TLyFBGOpqcudWTvSSKo0929jLnRELP+TeHSGdJojjcBA8986JvN6uf4/QU1H6sIJa1hQ3TnePo
	ugM72E4JglvxCjXwU3XF8q9nG36o59d8rFIGxrH10IIPiljDGFd29QxUqaJsMkAjMYeKA21TPfsVN
	tlQYC2dw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfoPQ-0000000B5D1-34RK;
	Sat, 04 Jul 2026 00:39:04 +0000
Date: Sat, 4 Jul 2026 01:39:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Alice Ryhl <aliceryhl@google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Message-ID: <akhWKJSZLfDusVcL@casper.infradead.org>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703022507.187457-1-leon.hwang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2784540002
X-Stat-Signature: ya6yi4hkusk8qdqa9a11eyzmxn56or8y
X-HE-Tag: 1783125548-86787
X-HE-Meta: U2FsdGVkX1+QBxkUo5FhHG6dOfUZteLfj77Dspac9f52XSg00v+379IeXmoowDKZdjm6E88la41hiEP/nf6RfyxvqeH2QfAOH3AVSdY7oZdrxWrJTQrP9KVe7vYn1Lk7ZUnZ6qAnnDFf+Cuko6u7eW8+VO3HJcmhdtSW2naXMZJ1Z4ThhbMjsYm7tKVZocZWFzQnpZsfPIqExdNto/nMReBOsZvl7BNDo2YH8LmJDKokK40F00ChHxxrk/NqTtIl6yZi7b5eJpVOlgLnTInaErRFXX80eGDC3KWev2IFR4TcvAf2T/hy2IQpAnnEoVQ5aOPD272QSZoVZSaHoSqDTG2uUG1WIpAXvZFGouYdwDxT8a9FQN2pm9b7OxUgCd0p4KQfFJ0HBzO/PrNMs4nigbpzfXb0gdM7p46CjYHx4mxsu8pvInXlAm+I3Y/I/BAacgyNgo0Jiby+VOlljH2KRDSyWCCZ64bz/xOZmSbQst2UR/Nty3en7ttxPlXa5UFDtPjfssB0HEpAype2YEoToepvLHHqMvr/tbBzuOx7bmSkki3v0AL1qJsLLIKq36DHgKDq23nlkJzYvq7E+FWo4M9IA4EmBC8kozrRyaAufMqTe75bZ0i4WUj90nfCfGAjkGx7qLMBK4RiH0klUg1gK/UCWXGCDzFpyzt+koBdQCtGwfOQRkmGHVkYHMSpYtliKcJXf9LVBePA5GP6lnhY68t2UOGlbb6bqI53/O+vvquiOlW+0hR3BrfOj0gDSzi/OYHK7Jfw0cAJUfqpri0+RovI/vtNaDM9Lriy/TpjvoGQGg2i4mOgRgtMB/OBKps3546HWNBodsVQPmM2V7Ved8f1RIMBzZm3dclbBsWBfHRfBeWQvLZDbbUo0DPf73FRW+SkEwOMwrmalUCsDX34NvoCjcwd2E8p6CHv8wMHQsHAqgQJQ7FoYswU6B86idihrIUV/huZkHGzU07anM8
 4bzZnlL1
 FNQGxtbJv9rqcR1CT2CQlz3QIXfoJAYvgPkO1zMNnDEtkug1W/pVr2H/+SvQqS2DuzWaJdNXHVSrAfyt+6M+YC8bxWAz3+iY195IrRDSSXa68fTLd5MWQ9AXdx+bwuXP75Cv/uQfDipnzHmCf7xpx3dvPATvDzQnfn4KPEabyYn4ODwfOA8firiBOAeP2KvaT0aZILY4OgwZ7a7j5esnvAPBXTopyK4hNxa+18HWYlSrIFR1idh8AmIp5XrAoCAgoKIV5dLv41N51xb1GKW+PfLht8i43/q2aAKeVO6Ue/W2KiYFOBkV0hf5PXpu528y3/ZPl/zATxM2cIbYKEcea7p0cCTJoApnzFkHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
> Document the -EINTR return from mmap_write_lock_killable(), fix the

No, you don't understand the whole concept of "killable".  If a
task receives a fatal signal, it dies before it returns to userspace.
So userspace never gets to see the -EINTR.  It's fine to document inside
the kernel that function foo() can return -EINTR, but it's pointless to
document it for userspace.

This is how "killable" differs from "interruptible".  Interruptible allows
non-fatal signals to wake a task, and then the task can see the -EINTR.
But many processes do not check the error code, and so read() and write()
(despite being documented as being able to return EINTR!)  do not do so
in practise.

