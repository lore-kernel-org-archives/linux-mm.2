Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97F4E68151
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374206B0089; Tue, 17 Feb 2026 04:33:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E516B008A; Tue, 17 Feb 2026 04:33:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257C16B008C; Tue, 17 Feb 2026 04:33:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1361B6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:33:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE4DA1B5808
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:33:56 +0000 (UTC)
X-FDA: 84453436872.14.3A82ED5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA45D180011
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:33:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dYTU2ydm;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771320835; a=rsa-sha256;
	cv=none;
	b=ihaCyINm+TYRaqKiH+JJxtiMWd1OA5SOjH1AVUN+zuQh+Vv5UPudbI3OMrvXy2JRm/qCPt
	Hk4ocTtVSI1ulZIRaOybO/XrxkPM6J87NGAkREC7DKAf1XdiQsj3P6i8rRnM23ci88K1MW
	DI7Gr16uXFPOfYB4KUu/RxBaLoTaslw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dYTU2ydm;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771320835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bBTf3wXkTuk7e+nax/2etObEgTBzMf/7JIdQqw1kF4=;
	b=fiDULJWDuMeMOzBrtWePNvTug8Arstp4PLvlX8zPCXvzC27Pi+xwqefrQP1OUZDjPdNXNe
	FeJ9OeRDxCO3JkWXwFH+VlFWEf26PFyEqRefMiEgq8b5lbLPRa9ev6HKmACJ0r0XLQkXKb
	PPi/luYMNq2avkWgsFqp1IvDhNiiOJU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+bBTf3wXkTuk7e+nax/2etObEgTBzMf/7JIdQqw1kF4=; b=dYTU2ydm7yvPcT4/57deVTHDi8
	vDKzJDdcGCvoWWLz3P85baYyzhQgy/1crhJXUMyVlJi+FHf7C0LZJ0sFVObDQiAg/yzngNvlsbrrl
	43aAD5Ya+YZ/6sPV5YIjjrRud70qPji/qtl32uph/7htvV4WqfIlAarFNt3AkxuMZCzxr9vNq0NT+
	Y/d71em1yzb2hmlmJA3wsYz+ldrQ14lhem7WWmfpNhA0vXprRHfd+4HrT3/+EhtQ2lxUBadubkOvn
	raNmBUfi0dhHUsYbKyHtyFNbe1F2W88j9h2MG6tXTFXxORJ3fI/0IuqmaRwXqyzmoRifqLywH12Id
	bx8QGfUQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsHSo-00000004E6o-1Tsu;
	Tue, 17 Feb 2026 09:33:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9ED57300CDE; Tue, 17 Feb 2026 10:33:44 +0100 (CET)
Date: Tue, 17 Feb 2026 10:33:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217093344.GO1395416@noisy.programming.kicks-ass.net>
References: <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA45D180011
X-Stat-Signature: xam6puy969st4jx6xgygtrok6ghfyhow
X-HE-Tag: 1771320834-981697
X-HE-Meta: U2FsdGVkX18KuortN+R0iZ6UC4SA/jb9zzc9L+0j2b/KrMB79KPghpPuU5nqmXjkeLfx6G+2WnvLeWPaDeWjvnBxBBvOy+JMbiekTrKxx2yxeeDZtlHfkAYxhc5yjCOr9+V6qv5eE/+lloYGLipbaWyzipJsxOnWJ5ZzzyVmuLwgwYE1UisaCChhlzrL5EWuhC8Y1RTZ3WCmdh2U1hpILU5AzvHRhcEAEguiMs/nlb2R/+5XWmiaRl86jCWAcmhMcsyx8VGHYjcPZqrU6Z6+nm2UFetL2DT0Q5BY1wqQMbKp1in377R3ikPno1tSeHkXXeCwdqjVtWFisplZ+0loQwTAltX0Y/rBgMSDIkfU9Z5tvk/LyE63i8cGQjU1sTwXfsJ0X3HP/cErnubRoPebRd/P7hXuNWLJ1yIKqevW8GU1WE8yOJPCT39JlQRfV4McuHGPDXxGqspY64KFzm8/WkIuIohmsgFVJ6mT/A57/4nx2dkzkV09wcSffmfJHUBhOw6YfmzEske4Y/xQsO1YcqBce3J3lZGIS5O4+Ojw8kxmTNpb1pqIzYtCDhRB8d2NOmXAUc1+UwVQh9iwJf70N0cTet0E0iZBe+eZ1UI66izTUejgIbPgcT3wT1giehDBVrxtcJfihp0b2vVkxGU/UdHjh5uT33fp5OaQgtcM7C3zu6MesavEU/b7sVJEVSVsYyT/1aBqHvdOXWMKl+6VdzpIKZtprkkusm2WTutPxMHeh7lkBpVwoIFD7/wXg5pDeU5JBrCRaB5725h6fPPRWDMlkoRw5JJKluyDfjcm/YcwFbiOLW4YSwfeBFcwNXljGtkYWbT1lBTlPq4k3uP74d+Wg0y++VYMJRiI7bpWS3ukYnqKzw9lu8GdsM6uxCwpJN+QGL+QCCUI0XxldvuYHTcKX585VJR2DgAiaXdymH7aTaNKZkiLgs28JR/GwPt6hXDUIxPs7MJpIhuuRkk
 S/6MwBtc
 oNoonlRsNYiiV/jGIXTDD8EHX3TE7u50iT3qzfhp1aQ8iC4D1GoZ7rLA7Xy6mDVgBB9haZ6fEgZMvkrLJ4r+kV5eIWaOthX5d15VUUQjzeQpw3aOwqEawfqR7//ppzx6r1f3BLsWKMI2sYRpMYX4vPqTWs+Y8+GlOw1m/QYFZq3vpQwYquG2CZayJOL45x+Pqpx6j4rpMW8kjpvBRKSwyDAF+DHPC0RCwWbN4HhL1ip/+5j+vx8HzaPzOdvPQuMWImVOuZDtwpquWMonaJOfI9vcQMqm+kpMnwVUjJSNqAWK9SiRHv+oIeoQuJHNFlPFQLE1Q7nxC0rVdM33052k/YJ1p/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:17:23AM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> 
> > > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > > to be 'BBBB'. The resulting copy can be any combination of
> > > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > > 
> > 
> > The idea is if using Rust's own `core::ptr::copy()` or
> > `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> > not semantically guaranteed atomic per byte (i.e. tearing can happen at
> > bit level, because they are not designed for using in case of data
> > races, and there is no defined asm implementation of them, compilers can
> > do anything).
> 
> How the heck would they do out-of-thin-air? Any memcpy() implementation
> that can cause that is insane and broken.
> 
> Compilers are broken crap if they do this.

The only way I know for a compiler to cause out-of-thin-air is
speculative stores -- those MUST NOT happen. Just like hardware must not
do them.

We must all collectively say NO to a compiler that does these. Life is
too short to try and write concurrent programs with a compiler that does
this.

