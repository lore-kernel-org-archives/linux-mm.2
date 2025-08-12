Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6238FCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3738E0145; Tue, 12 Aug 2025 10:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94DD8E00B0; Tue, 12 Aug 2025 10:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D831E8E0145; Tue, 12 Aug 2025 10:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C56958E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:11:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61BE81DC4AE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:11:28 +0000 (UTC)
X-FDA: 83768293056.10.1BCA43B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA06320006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:11:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=UoiYFUtL;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755007886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZii2UJLvmNKeXGMuaz72NT9dCsJEnkatza55WSNbWU=;
	b=yENhKnfLNpja0msiIL8tapZ1NvE6EUZaCwFzvoAvrgmbOfVDJ368PYmJmdGXQJoXENxgIo
	FRCkLaEmxyE5rKr55CpeJupRTqL1VnknslTjnEtAsXRx4VwSsCTffAkyNnAfajxEUaPLg2
	5qqbsMNMYF+P257zjLJl5MkYefnaLKE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755007886; a=rsa-sha256;
	cv=none;
	b=eWNgnv9U2SoX7hUZ49Ps84NfUL3hHOq1UQjLpkvGBvlGhPDEb8zgcm6j0W+Ps4Pa2YODwT
	6k6OCtQzdPjV88qp4Zq3f8ZBadRqj07I9R514t7fWUdEISf5jj6wdV9qQpRD09sH+rjP2u
	TlijUl1YpZ1YkkWv37PnMJwDFtqn+ao=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=UoiYFUtL;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4064441818;
	Tue, 12 Aug 2025 14:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEBBC4CEF0;
	Tue, 12 Aug 2025 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755007885;
	bh=kRbNEAZybW8bsdsYVLZsjN5ixwMs7RSBCCzBfeTNXJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UoiYFUtLjyQmEIhc+Wa/8+XncbxuAtrLvKU7RDhBHVEpfeTQEQvKN/Wnr9xR+vWBN
	 eUnNSqmi1edCVH5VjfH3bBQC2jQ/JKaAbsj/ZUY3E+apdlmuhCE83DWykNixe9NKjf
	 P4gP79OVSzC2yFI/l41Pd3HAyo5Ca6EhCTPpJpxg=
Date: Tue, 12 Aug 2025 16:11:21 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Baptiste Lepers <baptiste.lepers@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: mm: Mark VmaNew as transparent
Message-ID: <2025081205-bagel-radio-1c94@gregkh>
References: <20250812132712.61007-1-baptiste.lepers@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812132712.61007-1-baptiste.lepers@gmail.com>
X-Rspamd-Queue-Id: AA06320006
X-Stat-Signature: ufmyzq731duizh9etae3bsft8md7ptad
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1755007886-309699
X-HE-Meta: U2FsdGVkX194YzD92m04kngmoYr9R1nqZyskCMSoUomDUasXLggVfGK2iXvw+hoIvFYAl9/vSSdEVVaufLQ+J/fC3Qle2GRkF6uj+1ERfNzHQlfTF9LW2UVTqFqEfdR4hoT5/sh/uWD8xD7mWLB9uQ30G6wcCQRALrU7G37Q/QM/eMyp6XqIJJ2VSId6cifpNiYa/pQ0BSyzD5mWr5V8sgmvMZxdgZtD/alS+uDIH+19A+enbHcXHL2bzlx+8v16WWsUdkaFv57sI5cpK+p8LKbzSny+5hEcMqfdNBkxG36DUHFU0OB0bhBye65pLQhoMSVxz9sUD2j0M1DEUVwfOHnz2MLnAbCmWlaYXvG5MWJgn8+8d5fXMdIrU7qiTSQABlwSX+WZ3NmvYFdsEDiNKCz7ESfE8Mrx2qCimoPtJsmVBx8ocTZBU/HPPvElLgXMQXOrHVhLGkzE8JEkrMlPYlPreYx13h8hLxuXrIjfkViK0ImnyPqTeIcHUpII7JOicfD1WJX8AA+aSIHMxH+Yp8RY6nk7SLB3WDioWHtzfRz5PBgWSId2c9XVYTSSrzN50DQn8XkbySvsX+UJA1U+YYTWgh4ClRNb54D3i7USvEHFj8JRKNrMf9iZRN/jj8kLkQT+F5ohGyxk9Pit6K6RsnW8KxAf1t4DbT/pbcsWQEON7szs4vPfZ/WlkGNjj2aMvWR1I1RFWVf8sR5cH58olrBYlLkxgbKKBBxBhCIZpvnHdJOIpa6q5/sqywCkS86yyjRKBlNHKB7AOGj8RG2KgC323PjwT4sDTEVAV3fkTEWjrOC6pqyjLTUa+XVGQhX/0uDnoUZ05+Rq/R6OjVVnon7Hip96KWyfvUZZeXSE1h0Oge8jN2DP2rgMGXPDknq8CGQYKmzty6xCJShU+2vIQ3E+Et3ZhjXWrc+OdJ5aqdGdx2aikMMAXdFO7PB8kCETjLc2BJ5EqtBKWk86sfr
 A/yVGShO
 05MMZCaKIUAflV3tKAL+WKiSOspOGwDBhOqFEidCWAQY0iUg7X75Whx9UA2U65w045CEpGIjK15IzeqJxOOPV2Q1LNrbc1L7brLAvwIwuwpwV1tckbDr2zQK0qn71oJRMTgdYUU3lJJNuyMjKtlrcBX2xtoqCrH/r4KrxSW8kTDiQAG5evD+RQ6at4IDPQmkA9bLOgKSJ5x+lxklQ4THv/NyMO7Aihjc/Tw5cEQN/x+J8O1N5VTylYI7HCSP24nzEXlMLup6la3twwtAJfjhaiiZNyew6WA1s0owkDcKXBURBMuq70Vec8GNEJfl5bDwwLZFJGbMcxXT8EvIQtMOfU4aZWTovpwHWhA+nKCTZ9cLuQbGVVCn5yf8p7vP2BYRYmiM8+v9tHN9ew9leYhVM8daqt3CmgRsF4Hco
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 03:26:56PM +0200, Baptiste Lepers wrote:
> Unsafe code in VmaNew's methods assumes that the type has the same
> layout as the inner `bindings::vm_area_struct`. This is not guaranteed by
> the default struct representation in Rust, but requires specifying the
> `transparent` representation.
> 
> Fixes: dcb81aeab406e ("mm: rust: add VmaNew for f_ops->mmap()")
> Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
> ---
>  rust/kernel/mm/virt.rs | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> index 6086ca981b06..a1bfa4e19293 100644
> --- a/rust/kernel/mm/virt.rs
> +++ b/rust/kernel/mm/virt.rs
> @@ -209,6 +209,7 @@ pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
>  ///
>  /// For the duration of 'a, the referenced vma must be undergoing initialization in an
>  /// `f_ops->mmap()` hook.
> +#[repr(transparent)]
>  pub struct VmaNew {
>      vma: VmaRef,
>  }
> -- 
> 2.43.0
> 
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- You have marked a patch with a "Fixes:" tag for a commit that is in an
  older released kernel, yet you do not have a cc: stable line in the
  signed-off-by area at all, which means that the patch will not be
  applied to any older kernel releases.  To properly fix this, please
  follow the documented rules in the
  Documentation/process/stable-kernel-rules.rst file for how to resolve
  this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot

