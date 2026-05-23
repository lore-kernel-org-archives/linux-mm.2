Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8157CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 13:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD7A6B0096; Sat, 23 May 2026 09:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E296B0098; Sat, 23 May 2026 09:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3B26B0099; Sat, 23 May 2026 09:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B04E6B0096
	for <linux-mm@kvack.org>; Sat, 23 May 2026 09:54:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5BDF1C0A13
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:54:32 +0000 (UTC)
X-FDA: 84798829584.20.7CFEE9F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id 33AC51C0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:54:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=CLspGlc2;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779544471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azf2cAACap+DXFF5XblNSQG+CE81RY4YaUZbwOo7nr8=;
	b=zYwh+MAtB/fq/yy2rObgRLNmAnTBILwGFTa3ZrB45md9RjM2u9slMKxNVPLp6BMshCLPpH
	8273sxo+qGc7p6q4MkQ+brj+xmL8HuHHyRcTbfOmk4nlCnfvhexr1+t4sLMWLFwd3cl2y5
	8CHCTUVY9AxpSovnjqrTGUgSCNuPzsw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=CLspGlc2;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779544471; a=rsa-sha256;
	cv=none;
	b=S4klRg8cbHksAq7+iynt5CMVi3QCeU1PJztck1HC/A12LXWf8eu8nIZKbDCTDls6Rft7aX
	lZqh5NgtjYuIqJvJaYjtBt0Yi2JcUKZPShTM21XSDTXNOBVBTMZNK6Jc2iZOYmTvZK7/pF
	tDr+aVQfit+Bb8+aKFxQwNl8IgcPYa0=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B0FF4D0A95;
	Sat, 23 May 2026 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779544469;
	bh=azf2cAACap+DXFF5XblNSQG+CE81RY4YaUZbwOo7nr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CLspGlc2odvTlcOlSaGOKqJyQ0zvxfpUgXERroy3jQqjlKBfGGVV1sZSfI9urVVMu
	 FVXnieCF6FSx14EGbfjSkRme5YgdnafmNZyCrZM5Ys/mhHnPMkLacrcYClUJb9cig7
	 70phs+OApR96hELJ6Dm77X+96EY0Y1ItQoTzip/E=
Date: Sat, 23 May 2026 13:54:28 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <ahGxlAUeUwSbbYi4@shell.ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33AC51C0005
X-Stat-Signature: routx6xjcwmhwu1bqjqj55u9eoykdzfr
X-HE-Tag: 1779544471-998056
X-HE-Meta: U2FsdGVkX18FLjAXdPgiZtZFkcIfOSIoN1hL2vRSj96Zw//LRgXojlmdBjhpJkHeWqvDaAFw7uBKogmyqhNV67Qc1pqmSJWmPNSs7U4RHzPIHp6RukUmCqjljXIv0IVJ8dzQXuFjCJF9GoxdbPwQtLPYX2+27LLFeGi9mg+wH/9e9Eew3Z22mlDo3Y/aJZVgUhge3CN9EPcZXIe1D0quNFnM7l7II3K6ZAv8fh8ReL0CW+vDbAKEzg5MZAT6wuXYncHCVbwp0rWL98JCHUuWbMBczaiIVAVp878DkyPSVU2BBYEZF6e1GB0kpVRdtL8bLhqNYG3Hctp/FFSPKPFjVlay6pGCWwYE1LzDg7giCpD/1qsdCLNFIpZbP4qPdo9Wn7Qv9YECPKUMQEcL0OD9YCEZucKiIy4yH5GKTfvypGfzSpzKEyzsHnh/szupqoG2yap7Jn6WHK3qjS+VT5cTtZWt31bnD0Wz+leu99ow+gT3n7YFbqSSge2SX2DD0Ui0FEuR4L82zozWu21GxLaHSu0jS+7QcbbhYh9JoAS7JNQFL8u4dDKwdHQwut/Gx1i1O5K5jdu7k+fbu9cO8EOunJXTZ4pSIB68t/7IKUj+c61gEyjxOshd4biIdQK2s65DuEGsuV0C8cEaCPIcv7fndQqmtq/0Id5T4RF9/WheQhv/9CE8zJ1i5W0FqZyA6tER2nbeN6vIWpBhmewyjqzvAFG6fJUkhAH6QYA/qeNRXL329XEZ74xoU1iuLAjwGjXstL8jpmR8efOv3q6ZiMsdOWQ2rbk2u9Go/IgSoc8uJPlsCWaVnZAI/B62CI369hJyMDxbnPKF0jqTGXySVxZzQKoO6jv9WmG/bcux+MqK9wQRm3RVq7h+wbWg93YUbwvkcQuQHmLxF1xXigTD+UZMz9J6sAawW6HPetHVxR6NBuz5pKRI8QZCdA7Gh4Hbd0QHvhWCztXq9CqNl0TxDmY
 t5Kbmp1P
 2VqNWFyp669+kFDUydMjxKXAuG3JtR4BdBJ5/BIoFCxr64KkYz7c/aFhOFFu1sutpAlh+1hAOUrMSds5kBjas29Mf7EeRgzW/U/0v/H+EvDx3Xf5JBDnNNM7OAm3PBEUapcZ0hrSOog4t43KvmSbLBJ6sfdVhfyjL/IwyxYEECcXQqldsp7LdcDKrw1l+H7QsDHMo2FVsC7kqU/n758sHKLyAZn0sRgqrM8yTiVbD1307DoHcyuTRxqWwiP2qj8dGEEp4cuPZ0hMzpQkSzTgZR5J9tAOukIsr+CUHlrEwqTwmPNKfCbMMQfYBce1I4CTTFGS4q2R3bBgWLSgfRrsjPWUbHb6HvZylixryhrgbguZUYmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> On Thu, May 21, 2026 at 07:18:03AM +0000, Dmitry Ilvokhin wrote:
> > Add __nonnull() to unconditional guard constructors so the compiler
> > warns when NULL is statically known to be passed:
> > 
> > - DEFINE_GUARD(): re-declare the constructor with __nonnull().
> > - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> > 
> > DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> > pointer arguments (.lock is hardcoded to (void *)1).
> > 
> > Define the __nonnull() macro in compiler_attributes.h, following the
> > existing convention for attribute wrappers.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Miguel Ojeda <ojeda@kernel.org>
> 
> The build robot found something to hate in this one. I think you're on
> Cc there. It looks to me like clang-23 is confused somehow, but who
> knows.

Thanks for the heads-up, Peter. I got the report and will look into it.

