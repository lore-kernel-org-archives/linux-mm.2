Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42E5CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F8B6B0088; Thu, 14 May 2026 03:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED06F6B008A; Thu, 14 May 2026 03:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6456B008C; Thu, 14 May 2026 03:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDED66B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:01:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7192B1C1383
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:01:14 +0000 (UTC)
X-FDA: 84765128868.27.946AFFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A678B40015
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:01:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E/Pad0pc";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778742072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRjpyDIfj4nn5gW3WtBopxHhxgIgjUntS696B0U1kT8=;
	b=qV876WvM8cin4s2hKWFEXCkM8X/ig2BdJMnR//Qd48ujqiK77agEv49cdPK07dU2b7lqFv
	v1j6WNZN/E30oZu3wzv6p9hDtfgDhWL2k3WMGvORyzvzHYEM3Sd2uB97vLwg/FPxk3hbOy
	SHyvZY+ec1cH0j64dC009JGVPYE1lT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778742072; a=rsa-sha256;
	cv=none;
	b=4viL8cOjcVE7kSeocUofwcVHI53oLWTHMUvTAKhQWLqMjEkt9z04xsATaF3jqsGU4633aU
	je0MBupVX/b21VezfI3TlyhGSBNf/cBU88RZufgsFlJKl/mvTjlXn73XjC+83ulk07kWfj
	1mBTt2tez51NmN4XeF5TlRmEv9Vkfyg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E/Pad0pc";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 424AA445AE;
	Thu, 14 May 2026 07:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE54C2BCC7;
	Thu, 14 May 2026 07:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778742071;
	bh=uHrx8SzunZGJpKBZPt6MTGRxOUoJM0biANuKfqgP/XE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E/Pad0pcD1toU+XQUyj/b7Gyep0t6XijuzJnganSWoAfjTyJ6jpciIm/LyrqKjfSN
	 e1NB94oWnTqoYqtWwg1/Y2VVxr+UfndLALhtPQUnuq+8gpOJ1g0Rv2jjhLx+M+2IpP
	 /2ExdhPgdxpzeIWlveRyZpmmNC3XO4bn7HPlMFDc=
Date: Thu, 14 May 2026 09:00:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH 5/7] misc: reject duplicate names in misc_register()
Message-ID: <2026051446-glitzy-quotable-c4b6@gregkh>
References: <20260514050455.2954509-1-justin.he@arm.com>
 <20260514050455.2954509-6-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514050455.2954509-6-justin.he@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A678B40015
X-Rspamd-Server: rspam04
X-Stat-Signature: tkkw3fpdbxoiw683af3qfrt8abhaxpxu
X-HE-Tag: 1778742072-674425
X-HE-Meta: U2FsdGVkX1/3+M/epfhqvOMEmA2x/XmRskqRn2ec5Z+05aqHTBW+k4qBhzoETbDyxvhCtZ/1wPS7DXFZ2DDOvEpD0cOhrg/fSj5F45IR7jvRlEB5DqwjVMckrMBLSEpkQZG7IJ/wCtPzua/VI5lZOWPHRfntQSR0C5GrcWE2vO7Lh3PkezL3tWAd5lsf4pGUXRGhohZSyFzF2E6LlF/9I87yrtcr/h69w+bA+Gn7biAAYtNsjC+khTYQL3ocYDZHKdBKUmivQG8abDKHsGxpxCmP6FfyCwYAQOk1O6PMwInMR4BHFyUUzonI5CPaN92H7egOgRieupHXtmE8hluBQ5FsclDcvWotD+dOVh32v+dQnFLSzykWil4rr++GNu9PSacI2zGyv4X/zIk3NYxbfLHy+y804iV6qQJlRCIrAMlwmgEPJlx33CI3g6dWoubDV3F5vw736IQSj0Iiw9qFVSyYMvvi/ODRVUTcP7nmCoQYDSXREtWjwaGkg2LCgRiMC8gVg/azxxBBI/X2xfApoXQ9qXvHrBTLSqoL0Pd5f1UJw5tYnzJ0OQ9fr9NOI9EL8jZAi60nKc9uPpbRf/azqHg5dCEURfpQszKNfUMfeGWXhUsVG9QW/VLY6lrd0ocreFiLdOaxsRXLVoz2M1iYrPDC1J40pu/mfXX+xh09sWrdYkpHnO4i2vLa9JfKaQlEW5j9rzoKFe6Lnmrc+eaeNp+Ie1mjplLnO+Qqt/+i0c7zpIFVxoC12WGoLSzq+zeAptqKkayN1AFbcsaduJi64v4/XEyEMKud8zr+dRgrYE9/hQjBhk7czIpE6ni9swAxvewEFZPLyU71VwWkcDhHedCHqEKUNHwd3bgDjssJL1KevNGxgOESBltD+2LZb3jIEnwQOuQlvEx0lF5iMMZPxPKuKHq4pwIDIB416gI80PZiwuEX61JvgyPNAzTsY2nt67QwAjhxGKEOkbAqpKo
 U98CGBOi
 URXYY9dFdb5yShOYFogfgP/Evv4GwPsc9lZObNEUwBcXeHspLqLImMuQwHym5ap4O/0LtC6I4Y3E6EtGPt789LnOdJe8KkJi8lodMPdawXTlCKg3W2ELbYoekVfpkdnBQEOnTJ1TnHkfJPBKRLXzuFfb7SQzBVEFPdfbBh/xvRSSOHryigDRdRYW22IOyBA45SsJu1cs1vCIOin7bH2hhhwVYBBLeQVygEBV81z/4Pae7J+BRZHNZWThjRa0A4WBtne2aNCRB6JaHzenKMveZbE8MLJ0zF0zfgdjFRNYhosVtGPddlMpzBrwlSOz3jQigH9bak5pHK3oJkqJBMRCXCNDQah/PXNJXgLVHAuV+rHtvnAScL2njVt+C0d3Ob60a4HebHIX/YrDSOnkiEIbzaIMRACLpTBZwYj1qSODsMTn+MJOmUDiUWrDWrGqBnseqL7wBArIb3Cb2T9EOcBoJdPYjTZxHLrel+Rwmfu3fYHv4vy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:04:53AM +0000, Jia He wrote:
> The miscdev kunit suite registers two miscdevices with the same name
> and expects -EEXIST. The second call currently goes all the way to
> sysfs_create_dir_ns(), which prints "cannot create duplicate filename"
> with a backtrace on every run.
> 
> Walk misc_list under misc_mtx, return -EEXIST on a name collision and
> free the just-allocated minor before returning.
> 
> To: Arnd Bergmann <arnd@arndb.de>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This should be Cc: right?

> 
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  drivers/char/misc.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index 726516fb0a3b..d6ffa21ac495 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -248,6 +248,28 @@ int misc_register(struct miscdevice *misc)
>  		}
>  	}
>  
> +	/*
> +	 * Detect duplicate names up-front so the subsequent
> +	 * device_create_with_groups() does not trip
> +	 * sysfs_create_dir_ns()->sysfs_warn_dup(), which unconditionally
> +	 * dumps a stack trace. Both the existing miscdev kunit suite
> +	 * (miscdev_test_duplicate_name) and any caller racing on the same
> +	 * name would otherwise pollute dmesg on every -EEXIST.
> +	 */
> +	{
> +		struct miscdevice *c;
> +
> +		list_for_each_entry(c, &misc_list, list) {
> +			if (strcmp(c->name, misc->name) == 0) {
> +				misc_minor_free(misc->minor);
> +				if (is_dynamic)
> +					misc->minor = MISC_DYNAMIC_MINOR;
> +				err = -EEXIST;
> +				goto out;
> +			}
> +		}
> +	}

Don't do additional {} where not needed.

And as the current code works properly, we are relying on sysfs for the
rejection, why do this now here?  The stack dump is good, it shows the
offending caller, so they can fix it up better.  So why change this?

thanks,

greg k-h

