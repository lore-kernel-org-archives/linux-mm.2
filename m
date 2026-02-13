Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48213EDF154
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 12:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FA76B0005; Fri, 13 Feb 2026 07:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8610D6B0089; Fri, 13 Feb 2026 07:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763826B008A; Fri, 13 Feb 2026 07:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 690646B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:45:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 095F6C1E1E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:45:42 +0000 (UTC)
X-FDA: 84439404924.24.8308380
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86268120009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:45:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eb3XMWT0;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770986740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wy6EXxbv3f/6I1EFWhjgBzu/GuEETHq6yGUPnyDD7MQ=;
	b=a5JS8ZisDcjeceOOoJeX8h2QsGtgcorum4iJF2KJTTM5hMuxKRuM88vVGZhrWX0f+vUpJa
	Lee19ghuyXs3wG22dR1du7RdCrfm9VyUaYgDu/Qccd4+UPcNS2dQeaYsoSepDZmruuCRm4
	BcNaFpXoxwv6AusSUVY954knJ0xm+o0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770986740; a=rsa-sha256;
	cv=none;
	b=sE5KLGfDA8m3TPKlCEZD5SPze4EH7pwVs4xpyUdPDbwweWILuueU5IONmvQTxX0xTILW2f
	N4eqAeiXGovybh5CwU5C+gmJ4GL7CD56ms9J8KD7in4GDDQ46uCR68fGiIT7E5RpdNII5l
	GHbrGuyIgnPa0OK7xvPP40r8sz3zoCw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eb3XMWT0;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D14886001A;
	Fri, 13 Feb 2026 12:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61663C116C6;
	Fri, 13 Feb 2026 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770986739;
	bh=KS5OyQUGwYr7RjzTwiKXxGKlic/PWFi6BwMtgn/vHxc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Eb3XMWT0Y0yEZN4X+QeqeNspRK0AUqY0KUDwdhDD8l9ocB1RlRwwd4D5bB8FpVKm+
	 o7JKqjUp2YhxtaKxdnWUYvusu7lX9pRjxmuavV/3kJVuTwdZI1oOu08O6iXAssNTof
	 FozvICy9uiBZ1VwthY6RGmCG1wW6/Nq/zhqp2O5d1Gwr06WByfWZLAlbLwMuMRFLwq
	 BF+xbltbYgYOQB/l8nc29cakD0j7VXIOWN8ID+PvH1A/euiOd5FAuevJ1pfYcBgu1q
	 r6+b7yObGCE+XcNyoBYciMMgq1jIKdnPyb6yUONwWjtK0nduyV8A0zfFSD5QIEJi5e
	 7cjPufpBajS3w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <MJX-TLnHWp9yJ9t7suTC8ExghroIz2g2epZG9Rmp6l-9W7BylahrPTqXQBI3D0EUah4xdEt3UXh6ROBa4LdEDw==@protonmail.internalid>
 <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
Date: Fri, 13 Feb 2026 13:45:28 +0100
Message-ID: <87a4xcu80n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 86268120009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9aj7kyzhy5xpiqbiji14ry3m35mdhgrq
X-HE-Tag: 1770986740-647815
X-HE-Meta: U2FsdGVkX1/BgX0C5DpS4/P9Sc4URy8iEohzqGHOdGlh31yyIFsNu/9NmmzfYBhI1s9NYYly0rifg9Nc2uhEEZrkt6wOMbgmjeU2BG4OBIGeGGPmS/cRx6gjKhQhGdH7uARrzXqxFTrVhEUXwI6V4EEo83j40dKnsDIWdUWPWxZos2jkIXjjVHOibJaLrTWx16UYEGtnOxmLNQujCmyJE+jwudefeJUS7YlskfgvijDzXt0AhZ4wdq2eszJ9UD0limeTmTf0aqvC6BhSDOcXKo7ADG1JZl0U+J8NkOpGv3JAusPvr3tSOnx6PjVXCZVBgpLnvnZitW5Z6YB9ZEc/4HQLEVpqWRywrn25z9u+8sQzR1dI6KBv1xmnCtsK9+E5G4Iov1cskkL1vmiRNnfFFJxS1QWeoCo3UxZKG5SLXCy3gJrlbEIa68Iu/cu3u5Pv5az2KK0fBg52JXIL3qcdZicWKsRid49VWk16U+PqlZ7FGUOXbtM/8bZawyORVwuj09MpqKWnBA/44ottnpwaBANP6BAT/3KQZA+QlBWzEm3q460AXLyyAhQcM5krCiXRLh4Ipfz/1q6gvD1UCG7ZH3aWPSL9u7AArE5RPwSLNSy0Y5ghL+6V04NO2KOzT35mA8Ok5VPFakH9tAVHgRuozzz14jbCEge1/+52a48JF9tIKG2z7zyNTdkKFQ84gsSnk+I4E6VA3Jr3tA4ZalahXKYudwOHxZhX3scoDLqf0q0Kkh/BKv4XTj5iokrTrV5JAurhUwIf2K9OgEMr5y47JAauMrTz708fC8DBRXOX9RLHjqP/zU+Lve1n3cFmi6krKKWTO53bUSP3xNBFZC7o4LAK8KEU4NdMi87Myv2QaARGxCIRtKTZV9uPNJ1pD6ka+iWotBRZj1WZOJhfhFN3zwurY6u5MM/AT4rqcyW8cQD0EHWu4skHVgQYuFzlUR5QuFy01HH4w/YInwWebdx
 3ul22vhU
 GiMH/w0KqJjgHvxxbPpTmytKmr8jIPLg1N5otSd3P15An4LhGgQv/arYx4/b2ps4/imOv3II8jLxsn2MkhD5syvkX36lncaNsEEU+1QcR69pNz5XXsIMJoQ/elrckVdSPvHQamv2GVRRjQZ61eZtQmp5YwoUrntHx/GrZtCwa2l/4R68hjgb1ugTx5bdAleJKKRj3AjyRT2eqt8luBUCzUqTOugcbH0uSdcV4SEmiT/SUbFA+rG0jfLhbIqkANW5qwM5ZnoVvHzA1079rbY6z505Ni6q5HyvdSz3qXz7pNjwsYYqTxpdYC9iPx0qtwq4UbtCAf94jyRnTp90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Peter Zijlstra" <peterz@infradead.org> writes:

> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
>> When copying data from buffers that are mapped to user space, it is
>> impossible to guarantee absence of concurrent memory operations on those
>> buffers. Copying data to/from `Page` from/to these buffers would be
>> undefined behavior if no special considerations are made.
>>
>> Add methods on `Page` to read and write the contents using byte-wise atomic
>> operations.
>>
>> Also improve clarity by specifying additional requirements on
>> `read_raw`/`write_raw` methods regarding concurrent operations on involved
>> buffers.
>
>
>> +    /// - Callers must ensure that this call does not race with a write to the source page that
>> +    ///   overlaps with this read.
>
> Yeah, but per the bit above, its user mapped, you *CANNOT* ensure this.

Not all pages are user mapped. If `self` is user mapped, you cannot use
this function. As you say, it would not be possible to satisfy the
safety precondition.

If `self` is only mapped in the kernel and if you can guarantee that
there are no other concurrent writes to it, you can use this function.

>
> And same comment as for v2, none of this makes sense. Byte loads are not
> magically atomic. And they don't actually fix anything.

I am curious about on what architectures byte loads can tear?


Best regards,
Andreas Hindborg



