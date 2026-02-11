Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBA7EB5979
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 07:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9EE6B0089; Wed, 11 Feb 2026 02:43:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683D86B008A; Wed, 11 Feb 2026 02:43:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DDF6B008C; Wed, 11 Feb 2026 02:43:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7116B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:43:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B9D91A02A8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:43:06 +0000 (UTC)
X-FDA: 84431384772.13.0FD8487
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6069C20007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:43:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rVhm/HRD";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770795784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DHYPWc9qq0NwUTMFE5Zyp7B8aU2GKwRoK5gec/F18g=;
	b=OJyVn/qOybLuH38dAHJ3Z6XjquTIyLMUL5Qv559PhR0h1DDSjOiGQCgJKi3EwcgYBAd2C5
	Dtsp4Dt4fsTZdmKtOjfRpurwh5dl3AKVfaSniZeb8tBS0EgTUjj0FZtUOinl1uCXnxP8Mg
	bnxIi38k2XosDbxx+pFnv4SYgDAQ1dE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rVhm/HRD";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770795784; a=rsa-sha256;
	cv=none;
	b=yyAqqsXM7Zu++gMNL5rfE9p3wjVk/puOzHpI1L/zLGs7Z45+dbs0XKRiaw6xTY0ASc2KvH
	+MuVax7F2JwnuH+88xylIZpphCSPL4VAwQek7/RiSgYVAm3a3Aem4IKz9HCw1pGRBurPt3
	9cvAUNod3hUAGdAl5icEKMHzC1oCsQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 816FD4364F;
	Wed, 11 Feb 2026 07:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2682DC4CEF7;
	Wed, 11 Feb 2026 07:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770795783;
	bh=ica1Ebj/m1NL4pYs6l4iDuSVu6qcBN3gjo8gIeyJWkA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rVhm/HRDb0EmeUqovVDPd7UlILZrIz5H7xyocmof1XPFUQjsyHTeZAhql8GLZrEcw
	 2+kZMr6lvN/VuC+dDLcfOyXpoRahv5qMzU9Fityj9/dmJvls8NcwT4j+PlA1sKA5t4
	 GkeHF5kSqkvjF+S3pe85Zub0ITcs1ioJxjezXv1m/HOxJSMnCyy6ng5M3WfjWpQtTx
	 QuHAhbA1dQngY93qiR8h6C8i+1axp+Wqh3mpG8wCtDXFWTrWi3D3M0YSV9rvVDrF8r
	 MfzSB/ya/xDQTzU+wupQZFTzzKjLQKkLUGVBu0XGM/HWaWjl5LwsOLmXzhiDUYRpIY
	 ueB8yoQlz/TMg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
In-Reply-To: <aYtcdGk8zcwaHfsd@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
 <aYtcdGk8zcwaHfsd@macos>
Date: Wed, 11 Feb 2026 08:42:50 +0100
Message-ID: <87cy2bvi85.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: iuahe1uapsfw4yo3bhmotym5ju6ioq8m
X-Rspam-User: 
X-Rspamd-Queue-Id: 6069C20007
X-HE-Tag: 1770795784-920748
X-HE-Meta: U2FsdGVkX18vrfF1F0QG0RpPYT8saDm0lAZ85aEzdbeluOWxbarFWzH10XsJW6EPF97Gj1p/OE5gSwrnCtFuXUfOwPcP9DgS1taMtOs2cFmcPE+II4We9eFv+lbpfoYtv53QWCC5//khbQb8zivD8B5xOdsja2WXZH2TOiGZ3aw53NQX2w19MwehhRewqDv39IoVPHAQeSdB4IzJaNUBeki3I1zBBC6XiLgA+VM7DYRKlHEyhMyxXkhDGP7iHIkElX1m2g69Rz6pFSfGqkcnfcJTLGMCCM9wi0fZ8zOYpt+qhWpCdG2skODUfwsWHf3Eqq5Qt7BUKdknaF4rht6AixGCtfIyabng+s3HQvPbWldpYGgSVPnopAx7pHLyEBdYAw7sSkIFuoeKYtu8bftDIFRB8XMNYs3STIAnPFUVqbba1zZT6Pnhu9F1QBzCOy7/Oe3+skhg+DoUT5V1423o1FvtMMNTCqKVumzF9RGAuV+GdWUaaDVnsKnfHzz3UnLo9qK8kXQrmlmVXLrh5STK0dWWbc3OKzIiSsW21YAeFaN2JehhZjYfPDUaBaQZvQJVmvpiqd5b8lnKiiCzsiNaRRFmwuNPl1OWXLr0qTnZ9p+RExptCcj4vp50yUrtMiUHiKkPFP7Yi4Eei37TtzGXNQQw3b/LbiOBvTANXt/j09zALFjNNkr70H1D6eB5jKyJ7p24l430Hvfwu+LWOaNDR1509XI62cODkjJIHL/YLfaRGE0eHITiwg2R2gKNKLA/ua5Io0N1zQAtBizP1YmZY62mj9b2Zn6ska7SK5Cj01vKAHQDt63nKguakIbshmt0xqgTotJ85+fBiXOQc0ZwLJDQi66ASPhQSsPen2QUmFF26hIrD1NnYY5KTb4jjX9gdBg7r6hDrDDEygKOcnBrzuGubfBCpMW9RZWuHvix6NUwP/AcVK3VbpbRbAh0d4+bJh+NZIKvDq+dOthoIhd
 AN1XBMpI
 5qfjI+O2U5QARa1/EWRX4MUbCwDCUjoa7HzL2MRHKTOTjAq41qkzEZVjw7IS6K+y5+X9kw6yaKrx0p5gufjPssPGOLCyzLlznms4iIMgjXnBZoXPPM5he46t7PcR+hu/z2cV66OUDqXQ0cC1nnD6RX5SG/SViIsKOP437lW67kMslnbOSA0oJ8kQ2zibHJUeDybrUh2j6DSFFqb0ul4Vsy/z3bY0UDAF9ie65n3OhUALuq4HaKSr3znSAJRbuFObGMn0mtxTi1g0xeQ305dO2eLl+i19awYzUOSxZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Gomez <da.gomez@kernel.org> writes:

> On 2026-02-09 15:38, Andreas Hindborg wrote:
>> Add `XArrayState` as internal state for XArray iteration and entry
>> operations. This struct wraps the C `xa_state` structure and holds a
>> reference to a `Guard` to ensure exclusive access to the XArray for the
>> lifetime of the state object.
>> 
>> The `XAS_RESTART` constant is also exposed through the bindings helper
>> to properly initialize the `xa_node` field.
>> 
>> The struct and its constructor are marked with `#[expect(dead_code)]` as
>> there are no users yet. We will remove this annotation in a later patch.
>
> It makes sense to me to merge patch 4 and 5 to avoid this.

It's always a balance. When I merge things I tend to get comments that I
should split things out to make them easier to digest and review.


Best regards,
Andreas Hindborg



