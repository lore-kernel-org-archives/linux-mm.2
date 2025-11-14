Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F1CCE7B1F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16208E0010; Fri, 14 Nov 2025 10:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED248E0002; Fri, 14 Nov 2025 10:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A848E0010; Fri, 14 Nov 2025 10:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F87C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:19:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CD4112E01B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:19:01 +0000 (UTC)
X-FDA: 84109570482.27.806A3F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C23B1C000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:18:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyPfeDpX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133539; a=rsa-sha256;
	cv=none;
	b=LwiSQoLzleYgFS5NdYLlsQ2MijcoWfxyJU7fuGAg5cpypnRxBKW64YHYwo7N+G0D61mGBx
	K9yyxuAo0nahcMZuohITVlYInJO3rYIQvPu8lx7zEwYQOv+op2wajfYVSYwFSSzyve4tSi
	v4qdf4bJRXhk6HxTnbNhVzliscW/DEE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyPfeDpX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hwC5SbuqU5yHKC2oGkCoPCr5JoKAr3PxjEUSBDGjRc=;
	b=IXfKoyMz0y8HlWj37UKnIP7NrdN+LRxmeQuyWJLHaAUifGbPNqb4aIup+cLYVzDFwmXNc8
	KHF1dLtKRhHQ2IHaz5IdX+sJNCBD4xlmCS5tPMnBOkKetUxCJyn+3XiG0ztyDwhx2/M174
	uao3Y9innCEhT/mqRF5GxPdoO9OX1Vw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFEB060175;
	Fri, 14 Nov 2025 15:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CFDC4CEFB;
	Fri, 14 Nov 2025 15:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763133538;
	bh=Q7AbNtbSF2oUgYwfiHMSGel7cR2NLanBud5yyhRwB5M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RyPfeDpXgdma8ly5nBSnAOq7bTR3bx+1HzamCgl4PbcCEMCz8QwFVr1XZ+1uO3PKn
	 2ucnRdF/OtluPexvPzApZfxV25Su8GWgb6oYZ4X9eBTuCMgxWyQjn/YV7bur+A53v5
	 7PQgitDLCRG7jW/wsH61M0y9dP4+J2op6YcmZQ6pGzlolUAMM39itAsKqZovcqwlHr
	 jDCAnKLQ5Gv8/FplaM914qSyHUXlPv4W6DClKc7WqWv3ijSMazklXjXWLWBjmUYM+S
	 c9KRa3foVW/Q1QeB3y0qVu2zEkuNhPvy1tDL0RInVUKjdErDj/c/0V+FN+2PDp/2gq
	 4vg+oGPQfV24g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Mitchell Levy <levymitchell0@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, Benno Lossin
 <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, Viresh Kumar
 <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
Subject: Re: [PATCH v4 7/9] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
In-Reply-To: <20251105-rust-percpu-v4-7-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <UXz9LMnhHE_mSMj1Dt_6wr3bB7I0jmR6ynJ2h8pSSiyeusmfuHXPFk5UVOYajJqnW2xhCubkwiRlUU5Q1jFFig==@protonmail.internalid>
 <20251105-rust-percpu-v4-7-984b1470adcb@gmail.com>
Date: Fri, 14 Nov 2025 16:18:45 +0100
Message-ID: <87ms4o3ane.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C23B1C000D
X-Stat-Signature: 7udnm1ne1ieucfitzedei64wqfd7oeaf
X-HE-Tag: 1763133539-51541
X-HE-Meta: U2FsdGVkX1/+60zvIVY5EUVxF43Dan2XFEoMLp2gTwL95d3HHmcS8WFWbS88wAlbCFfX0o+tpdfFPwB/ctvRbnplcng8eh0Zn39jFGGbBB7fa3dGm/x2zztAFx5/N1tGdn2RFF8vwJOmgWY63CeDG0igKRPUpZah7sRB6EMGvgj69tn7izcZEt3UXOxggToGcImFj6aV7VRKJ3LMS2YApp6FBkwzQKhDzuUCPfUeZxIeBaHVyTH8UhVd+qEE9yELMfltsj9Ft4XBSvQKYZDnlFYueoC0uJ64EsvkeW1jtush7kJFVj4hucUbbK6j/f7NFmfL7LqejTedymr6LgTRT60GRxcMXHJOATbxGTNW7ggxpk81RNMnokIGKq96Fa1Y96h17cmAH6/nfrVq8UtSwAQ/OyW3+r/eTHTCAJNd4lTNe8JviZt0NArY0U+VfgEOqLRFQUsYWFdC9wDCOgLB6Q3ykfZoqkdmbWXBS0bA7beND5tzUKP5uUETOrFCmZgZP9PHAPG7QjNMG/x1LJOyMXTg9SkMWzA49BAUb49y0265G4SRTf0GirWyqGla8LWx7sISXqS2dDc7hEDdO3ey+Bl8KIy2dEFN/GGa5Bye92Ug1IYOvkx+CdGu/tOHrbtN1TC7PcPjPAlJenW1l2Mq6z5p6F+mS0UOjpdEMjqglRQhB1BF+hWqoEkIbyE4qrVUGGjRHf7JLyZ3+yXHu8w/vsGRoUH82otPOOyl/8H70EplotHDipZnYHoGkmVU3WI8LQYAwufYkjv+tazI+0+NvBlzg0VbKGZfRiL53yV5YjG4h8fm37YG1yIU8U7aBej2AFXyxGZEqpfb+VprWArAyDOerDUbUy0BKsGuLN/gzEcLaWJLnYRFvmAAAiqwyWaqPP4xb6Pxz8XhVtQot6W+2yasWwIYfoAH5cKVt4RlPygJd8VMLaxlToWRzbU3HqlqMWfQ4ji2BP6j7BE5Uqb
 VBWG6BMY
 TJIZd/q8zBxXZCv5duUUmKUOEPodBqI2NdY48P7A+xmOUdK97jCkCsjNs+aRHwyKZ18Q3+dEJTFneSeZ5B8yE5R6ZC+vO0uVIHAsk6PNtjlVJK5AgwMY7cdTzV7to/bcrh8VmGFqccQo32SjUn7ZOWD5Gjt6iI7Rdqt4+d5bDZ2/G3kyy8kktfN+ULWQg/CmdR4d/Ey17WBP1gtxlGHFwx8MPDfEuFSluVByS49YvyAcYebgdN6jfdasw8aJQ9v3fadeBHMv3NN/Zcg+NymnpUXjpAkiFlyWtvPquNjN1SQxJdX0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Mitchell Levy" <levymitchell0@gmail.com> writes:

> Add functionality to `PerCpuPtr` to compute pointers to per-CPU variable
> slots on other CPUs. Use this facility to initialize per-CPU variables
> on all possible CPUs when a dynamic per-CPU variable is created with a
> non-zeroable type. Since `RefCell` and other `Cell`-like types fall into
> this category, `impl CheckedPerCpu` on `DynamicPerCpu` for these
> `InteriorMutable` types since they can now be used. Add examples of
> these usages to `samples/rust/rust_percpu.rs`. Add a test to ensure
> dynamic per-CPU variables properly drop their contents, done here since
> non-trivially dropped types often aren't `Zeroable`.
>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/kernel/percpu/dynamic.rs |  44 +++++++++++++++++
>  samples/rust/rust_percpu.rs   | 109 +++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 146 insertions(+), 7 deletions(-)
>
> diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> index 1863f31a2817..a74c8841aeb2 100644
> --- a/rust/kernel/percpu/dynamic.rs
> +++ b/rust/kernel/percpu/dynamic.rs
> @@ -89,6 +89,36 @@ pub fn new_zero(flags: Flags) -> Option<Self> {
>      }
>  }
>
> +impl<T: Clone> DynamicPerCpu<T> {
> +    /// Allocates a new per-CPU variable
> +    ///
> +    /// # Arguments
> +    /// * `val` - The initial value of the per-CPU variable on all CPUs.
> +    /// * `flags` - Flags used to allocate an [`Arc`] that keeps track of the underlying
> +    ///   [`PerCpuAllocation`].
> +    pub fn new_with(val: &T, flags: Flags) -> Option<Self> {

It would be great to be able to pass a closure here that can be used to
populate the value. Then the value does not have to be `Clone`.


Best regards,
Andreas Hindborg




