Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51CB0EB491F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CC96B0093; Thu, 12 Feb 2026 07:59:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83ADB6B0096; Thu, 12 Feb 2026 07:59:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7131B6B0098; Thu, 12 Feb 2026 07:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC9C6B0093
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:59:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DF2F1BD60
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:59:14 +0000 (UTC)
X-FDA: 84435810228.07.0B55BB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41ED2100013
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:59:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FILRQXDz;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770901152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrC+T3EC2WmBao965eJ8GXFqikx4iTal3qeLrhlTtMM=;
	b=yMqvSYdLERFd9Y662WiCn/W63zIjpXKMmA/R7yx5o7J2VQ9g7/9HENQYyo2Szn0ZsldQEn
	1KCNjxAQKyapkbvrMTXXtVFBCy7A+9PSzTBABSkQTmxneHMP/oTspg+1bPU8GHqnyt/GNE
	de492CKLyJD2YjrKxg9OSji3qnj1jmA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FILRQXDz;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770901152; a=rsa-sha256;
	cv=none;
	b=jRhvhS5Dbwtahyt3Sku4jjmvQNTWplSa5hIaM917NNXk3mtpJZDb2zGARbiSx9ZpZWMMeR
	MegcxHPow7UzRYIZGFoK5stOiSZMhKOtKltfJ/zKCXVzSQ8gGnBqMKN5QAqC9KW2iP2X0P
	HGoG2qiUmI1zBKJdSGQSfQvHWbrhtD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E5114429B;
	Thu, 12 Feb 2026 12:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93959C16AAE;
	Thu, 12 Feb 2026 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770901151;
	bh=NpzLkdW8jXvjXyCAdGJ2aaYK5afE0bKYG7engXl5Z7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FILRQXDzGZKfXmuKAK5ZrnbeyItSpJgxWSqHXBdroPiHoCIqjbba730FzEi+WFI4W
	 k+Fl4YWxJlJiZBcU9xiniAR8O6RhDjaRFAy/1FUP3U+k/IW7Tr115GvL+dz8ftH240
	 bwu3kNGquh9vMZdHyJKw94B4PbK7jX9Q5h8vnyWA=
Date: Thu, 12 Feb 2026 13:59:06 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, arnd@arndb.de,
	brendan.higgins@linux.dev, raemoar63@gmail.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	acarminati@nvidia.com, linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech, kstewart@linuxfoundation.org,
	chuckwolber@gmail.com
Subject: Re: [RFC PATCH v3 1/6] Documentation: extend the 'Function
 documentation' with expected behavior and constraints of use
Message-ID: <2026021221-grading-clatter-b7bf@gregkh>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
 <20260212124923.222484-2-gpaoloni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212124923.222484-2-gpaoloni@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41ED2100013
X-Stat-Signature: nntgwdmzrh7j4z1tgnhj1jcabs85fweo
X-Rspam-User: 
X-HE-Tag: 1770901152-912731
X-HE-Meta: U2FsdGVkX19mnnBROXSJMvH7/xUcZkGxe16JqQ2cpzBESUcttBnrlzVvCVDziE6dKRsKHwWgiEWtl61Q7CAZT7iPHiZCcyoaapfK1H2MWPZRBcduxW6UqEzBdpyDy56mT49lDiIHxVFVWPh2CGvl4EURshbS5apPSd/xXEz2PWAyYS5AgTAcMihrM1wd2BZW3RcCq3RU/BCy5ML/zuptPT8alJPf391/Ht5De3djLvtnbnbSh+Tyaek+PlZT24CbffwbRZtL9939rST/3DU3jMKvbcaae4RUAfkzHXpPlWXPgGuVZlVBIdJV4GVioOatumWT4ZlN5C8lomMCvKAt9gX2EyqyHz0JYjfZvEVFtln0F50z54ei3QIb0PQGkbwRUa++tO/HwOn0+jC9oD8Pwdkf7mU68CHxQsSk2yI4ZiVjgHRApQUGsT0/0HjEeO/Z+TamhFQvdEfAsy8G0aChjNwe6iouoHhx0MifSLY1yvrtKGHh4hEzJSAw3goe+ug081i7y72R32+kM7HxlBr7RdgNlKckiX7Sdo8zRCLFNfQ7AG8CNa/kNP3AH549nPWo9F7xcBMUnUB0XenzY/CODCxJ/icl8jwLH1imcEESA3lw2MXuAdY/KAxvo1Xl04aGmw2BdAjA9GEscyC/VBKtZPAcfGlEj8MjjZRKPGFaMYvMkAo3iTj9pmKA9TakthxLDFZ+Uo91KC5Ja85EDInqtvYjRzOOl7daCmDQExc+XlLBHM1CLyGCGt/BogH/FUbGL0nvjP9tS72pjV9mYMkCJRVysErDKtEimPmTJXXakl0CGXtWwQd24KqywINhWOejSUciYbelx9oLh9VHeytS6eGPHhYlYbbMWA8DNzoUswW4PS/z489WRPqr1ke4fYlJhyqfqwxyhbzfrvCmY6+EIwP5VFr6F1iMwIaSYe5BDnHcd4ZVuJybUo1xrUlUdqjIRmgyHuW5u54TX+4y83l
 1XbXYMhN
 nqcNtlTwogKGKhznYvK8AgEMz7ERXK7B7cXlNG5pqzzDtIhhkHOfB6sQ5yk5p21nCEaNvjPjuEege+HiI3yOnSBQuWHO85h+E+5lzVprvcCWhFHQYbVfEaB4NYHJKJknV+uxhqiFQBgq07hc2tl7yGa6UPi/+LBd5PuyXfIVy8dBokC89CYjhQudGGSShW0MPPtE9ImOltcQcCbeTrqL9HOP/piuk54mY+PavXdEv/7AwBHm5QJu8Q5gjgX8J2y9QX+7sB4Uu0ETDuuDA62puxGaZVVM9mfV3xv2zp6iHFXGBsF6RS47Ve2JWCjlljGweKv0QsDZBZpvA6qnQL55FzUad1ZuFN+Zz8xro
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:49:18PM +0100, Gabriele Paoloni wrote:
> Extend the longer description section of a function kernel-doc
> header with an itemised list of function's behaviors and
> constraints of use.
> These are useful to link and trace test cases (e.g. KUnit) to
> the different behavior IDs and define the constraints to be
> met by the function's caller.
> 
> Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
> ---
>  Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
> index 8d2c09fb36e4..23e6c4b45b14 100644
> --- a/Documentation/doc-guide/kernel-doc.rst
> +++ b/Documentation/doc-guide/kernel-doc.rst
> @@ -83,6 +83,25 @@ The general format of a function and function-like macro kernel-doc comment is::
>     *
>     * The longer description may have multiple paragraphs.
>     *
> +   * When specifying testable code behaviour the longer description must contain
> +   * a paragraph formatted as follows:
> +   *
> +   * function_name behavior:
> +   * [ID1] - [expected behavior]
> +   *
> +   * [ID2] - [expected behavior]
> +   *
> +   * [...]
> +   *
> +   * [IDn] - [expected behavior]
> +   *
> +   * function_name constraints of use:
> +   * [ID1] - [constraint to be met by the caller]
> +   *
> +   * [ID2] - [constraint to be met by the caller]
> +   *
> +   * [IDn] - [constraint to be met by the caller]

So the same "id" is used for a behavior, AND a constraint?

And what defines an "id"?  I see in your example you use number.number,
but is that specified?

And how is a id going to stay in sync across different files?  That
feels impossible to maintain for any length of time, and puts a burden
on the developer who wishes to add/remove a test or "id", AND a
maintainer who has to remember to go and look in multiple places for
such an id sync up.

That's just not going to work, sorry.

greg k-h

