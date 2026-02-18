Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BDAE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89746B0088; Wed, 18 Feb 2026 06:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36AC6B0089; Wed, 18 Feb 2026 06:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943936B008A; Wed, 18 Feb 2026 06:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD2F6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:24:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16B8213B121
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:24:08 +0000 (UTC)
X-FDA: 84457343376.18.5E98936
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A038D1C000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:24:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sas4Ja4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771413846; a=rsa-sha256;
	cv=none;
	b=tsxEqE77rTIQZSg0n+0+55o/esbXwDgVw8iuJ4u2YOEE/w0O/KvKQBUXxSmquoum7gG3ln
	g+LgglwZ7xXKQ9Dx9actDlQv3WpVdVOoROWrcIC8FTVTmOxncY6sAvZOA5Q+Rkmz03Lhux
	BKeMrtroAW6u+yShianZ14ZpwW2hbg8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sas4Ja4l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771413846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjcDm4OvNWAc/C0h8r71QKfYbrdjdZL+VMD9JOhvs6o=;
	b=MmSJCDkiOUJSZBYraRtwU8sdTQGPvlGD9IsbAif8RIhUU2rDPPqVR+RQh9IytapagBbihH
	bdyHd6n58OnVgE24f3wW5EFziAXROKtz69w1igkFzugJypiituJ8dt+G8s9BAaz6DOVJmX
	rHuGqtkRZqJrCf8vKcCpuB0MkmQMffw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA9976132F;
	Wed, 18 Feb 2026 11:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D184C19421;
	Wed, 18 Feb 2026 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771413845;
	bh=YVMv1ptFKNw6kEpdNrlOLxsWiwOQJELFd3S4YAz4D/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sas4Ja4lMC0iAp2bsc+/MKvz4KtmAhZsC8ejKyT2vUbu09628717QvJKpcXLHdEzb
	 SwYg+6qXmHKd/1gN6J/KMKc5WvdfBEjAgAapTw1rn6p5p7IQXpUjqIJoY8/86EOBKY
	 WCRHKZlK6+oav1Xr1hPOPb/wq/lvR5HCKrYJU+1DZHyF6ZQIsfPWkuEmGfEyigDg9D
	 LoJAWMpDDJS5teuqJFswrZGZHu8T/e65wDUCjJ5Lb2Wk44Wy1O0fXVSm7XYF9iuXBW
	 iKJof5st1/XGq5mCp18Bo4CLZxH6AjGRM8ACrSiSEuoM7ZVNjxJb4eWNjeozOAE3L+
	 FJ9yEJUlb7HXg==
Date: Wed, 18 Feb 2026 12:24:00 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, gost.dev@samsung.com, 
	Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@inria.fr>, 
	Kairui Song <kasong@tencent.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org, 
	Tamir Duberstein <tamird@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
Message-ID: <aZWfP-LyMvDsHVnz@macos>
References: <aZRncP-sKLLS2K1U@macos>
 <ix0mR76G9a_ieuQUUkkfHMJIviAsrFaO859172fuFx9Goj7QdIfz1jtnv3ptubGEC7uEFCvVfEoWxcisUnTi1g==@protonmail.internalid>
 <aZR-ItMBkiqyBdKd@casper.infradead.org>
 <87bjhncl7j.fsf@kernel.org>
 <CANiq72naQfG=nSiPJdCXgqM1M_7ynDE5Stt-jiBGPqS9pipQtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72naQfG=nSiPJdCXgqM1M_7ynDE5Stt-jiBGPqS9pipQtw@mail.gmail.com>
X-Stat-Signature: 8z71hydm1hydtjqougfuq1aybydkm81u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A038D1C000F
X-HE-Tag: 1771413846-890329
X-HE-Meta: U2FsdGVkX1/fnEDNdivj+ycNAdrXL3gWjI+PGyw/yT9CudnCZ+h3RIiKvMJs7QnMKWZfrqc3+x07bh0oCor3qmAX/OCncQbd2joUwkviUU4ufjttExTWzgFDS1S9k0aSmPFFnPk1on09X3c55WfNQDL1g8RLEHdse0CIorcgwDjTVvUwmmcXsac+MhSek1Jp3723ndCHSFV8k+XNGQkTPYgl3QVyUGr0yNQnr4YS6ui01Zjm2bX0b92UTw93e9V9qa8z2pTaNtytXMcqPbAt7yOl40IIl1Zlj6b4gnxzoTOUA1OYJfu8sqszOs1vxiKP4x4f6sWIwP9ftXY9XpwnpJezjYmwwlSxhooPirNBLudzoCd0Rdu6ObeeDwiHIWCDb8NwrafyI5/pThOb7UZ9ovN1QB7JRmAo6eCpamts9/4JwKc+0B+b2vTfokwS97NFoc+TVjm7HFaQD8N9Y/8rr1plDlg6HSnppIKk0rXj4gkBTuQm08slb+G2c1xEnoOst5VBBSdZ0LggQVEEgEQP7qXJFcmOoCgx7cdxbUGv0IJMmT9yC/CHX60z5m0qUF4lM/ZqR5XQvxnZvlXbmQBz58fBRXJW2100GoP/m+o1k8yeEzdDDJtelfU6LZ+Jkq2CgH8WD0we+8am/9haqUJpuKiQJtXlZjGEQElWF/QIA44pQ6LNsUUf2BQnQ7LncyuYig664BMgmB5S1Y3I5bjvZrQ24SEy2iUiPcaJ+U97BMknyP6g0HRni/A11SqpeFwiouzBiklACSXaW+WphAz9iBZz60SMeh3AnbXKVuKVwFLIFSf3cFz46z2DbOto6lz8k8lu2Jx3IpWweXKXBzX1nXvJF3JozoxqRX+IEynPFd2bdzXef5rxZy4cXdJ9yv9T3Ex6tsdVsmbkSlsbcDbZRWppSH5uzXwgV3EwoznWfkbuqIs9P+IhGt2FKat1FNSCsOnqHbiaO9z9m+YC/yd
 qewuo+CV
 5HR90wiwPM2X2UmCKwADc4Xjb8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-17 21:18, Miguel Ojeda wrote:
> On Tue, Feb 17, 2026 at 6:51 PM Andreas Hindborg <a.hindborg@kernel.org> wrote:
> >
> > We don't have to wait 5-10 years for gcc to fully support Rust, before
> > we start playing with this.
> 
> By the way, I don't think we will need that many years to use GCC if
> companies are interested on it and support projects like GCC Rust
> and/or `rustc_codegen_gcc`, given their current state (for context,
> the latter is able to boot a kernel with Rust enabled for x86_64, and
> the former is prioritizing Rust for Linux).
> 
> Let me use this opportunity to say: if anyone wants to support that
> work, e.g. hardware companies for their architecture, then please ping
> me and I am happy to help getting in touch with them and figuring
> funding and things like that.

I'm not aware of the official GCC roadmap but LWN covered it in
"predictions for the new year" article [1]. Quoting:

"The gccrs project will deliver a working Rust compiler this year; it
will be usable to build the kernel's Rust code. This ambitious project
...
The availability of a GCC-based compiler will make that transition
easier for many people, especially those working with architectures that
the LLVM-based rustc compiler does not support..."

Link: https://lwn.net/Articles/1052269/ [1]

Whether that becomes true or not should not be relevant for the
discussion, as stated in this thread.

