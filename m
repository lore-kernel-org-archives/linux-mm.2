Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392DBEE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EDD6B008A; Fri,  6 Feb 2026 16:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202216B0092; Fri,  6 Feb 2026 16:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EDD6B0093; Fri,  6 Feb 2026 16:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3E546B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:55:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6897C1834
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:55:39 +0000 (UTC)
X-FDA: 84415389198.16.E56BCCA
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1568C0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:55:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=fdNIJB7F;
	spf=pass (imf10.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770414938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87FUAVihtGZ9V6acpjB8qMDvXKM8qmBODfmUAeswVBE=;
	b=Y7YsXnYIwTw1jni08GgHHzY80brLlrCSobgImpLykrn35bAJkLt4yDBjFG+RazDVNZxtHe
	kw+UeDIvFWh1t3YL+3ner8HdB797vWQ8ATwmVK7DnqK42dHFiaq36cFjPF//2PAovSrwSL
	eKpTNOzkMvtPTaX9EkqLlL58+7KIrNI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=fdNIJB7F;
	spf=pass (imf10.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770414938; a=rsa-sha256;
	cv=none;
	b=SvngrQ9dG+TBCfCGn7Kyno4SAM/sGAH8HTQj6e+0j1fR9xzmr0Crr+3Hfqjh4pMFy4NaBL
	a+P02ImkNG067KSDcavwTMZw3IVerRtBO91xLhC69bzb3krk0OIH2JKdds/UbDwcA5jDGO
	3wT9ldG8rzJ/bLsZO/4IyoxZme4RH50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1770414934;
	bh=rMFN0NlTz0fAsXU+PIK/v/nmJI2k2Us3Bgd4+RQXh3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdNIJB7FIvtFm3J6JQ0v2iYLkGIjAdVY/1wUa/FYxdQLo9VgllRDtY+NP0E4zOnJ6
	 jV+0SafEsgAPXPE0rNeY2lhdFw9uWYKFCaA/Kmkf0qtI34Uyjg56cY1TRjZJjS9auu
	 NxDQ8jNHZaalhZScvsgEWjBAKa2F4xiEr9wwE0G4=
Date: Fri, 6 Feb 2026 22:55:34 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Jordan Richards <jordanrichards@google.com>
Cc: Willy Tarreau <w@1wt.eu>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Jason Miu <jasonmiu@google.com>, 
	David Matlack <dmatlack@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] tools/nolibc: add ftruncate()
Message-ID: <ebf0c9fd-9c45-4aa2-8cd7-fe8d5956ce52@t-8ch.de>
References: <20260205222329.2419035-1-jordanrichards@google.com>
 <20260205222329.2419035-2-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205222329.2419035-2-jordanrichards@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D1568C0002
X-Stat-Signature: 9sg5xtx8zcjkugfe14psp3fy76en91wu
X-Rspam-User: 
X-HE-Tag: 1770414937-641636
X-HE-Meta: U2FsdGVkX19gQXuNW62Oa0fkbJkDSrAJBWTuTut5T1IFP6+pFKWMS5OP82GoF5l3uLst6JpBR/rOyoIyx+OyT2SwVHBhDDEyXCO+MLUpn1O29Q1LnhcXt9dgL+temtqlNf3/ROIn/l30dBgp6t3RmAdsVIfwZrNFpcFtLNRTC18nqcZawGc5SfzVX0PyUup+nf1TOLn7IYU6HAJ+BX7mJLlVx/nl5Q01fnwhicLAJ3EDrZ+AFPATNxMgCh+51mU+2QatsSDLjBVu3Xs8qosGqzdhLZ8SIwR+hnsjAn/r72vqVZEgDA1qlIc5CoHh9rQXALoyEFVuBg1UO5UVrGv1kC0gy/+Xk1aNWtjfOCIluNtF5K/IKtiI9eQKIAIn99hRVX1+0+fDwBQx6VsW3jkjUAYzmeVPYpjBAGhJrYd9tUwzejYnIIK+Yj4p2qK9nFa7CbF6+VOplszi3fAzppZexNgSlVBZRXqi9pzDPgzZcSb0T7Q2+9rR8cfpi0aHHiZgEc7N1cjom3IO9WdafZmaBI1z/KYKAxgug2eOcOOqJzlyv9R6rL9wYZ7lZYs8DbstJ6ULjavn5idke9pieqXCkaGWw8PIU80niyb0ASYUJIruZNWlmCwiX1XGE8an3BohpOlcLE7DweFP/kXmn9PEnhVBlnIzAADIIuyB+Rj2UIPNeTfGiG5i71C4ALyeQXZIkqVosgCUEowjKLEXYXv2S6VRZekoQu6U2AiFwMvUdfpyLRzLcrX5M4n1GijYRQaw3W2KygJVtUXRWXzwcAvsfOBOigIQl3DVC8sKk/OCM4HWOeoWLqz/HzoxMq85y1cuUH5jmBP36o2jmmTHq5FdqAgNfREWgTgA4OGXe6iCKW/E5u6LVbRWoPBm5R6FnJTIHHimZpt1ZFMYzu88u2LlF0mj9u0uSGOeCAMAQaJrBDncrUHoXdfiX7w7sKl0OMZ2ARFXvE6NUXMGLLhytSG
 EbQ30uQ9
 wbar6q/1bP5I32Yh2skPOZy098ntyoLbLgTe8tADZKj9zo0NrhFC8MENB599dDlsgI8yW3vBrxAmoNNoiQIkL7OlVeefPq9wyN/MLr4a9l+buhPRYfw/Y10BKXpHRHQOvSXe+UoOJFL3yJC3zGqKaBWInbyedk8hWtC6p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

(please Cc nolibc maintainers on nolibc changes, I only saw this by
chance)

On 2026-02-05 22:23:28+0000, Jordan Richards wrote:
> ---
>  tools/include/nolibc/unistd.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/include/nolibc/unistd.h b/tools/include/nolibc/unistd.h
> index bb5e80f3f05d..845d10f48fd0 100644
> --- a/tools/include/nolibc/unistd.h
> +++ b/tools/include/nolibc/unistd.h
> @@ -48,6 +48,17 @@ int access(const char *path, int amode)
>  	return faccessat(AT_FDCWD, path, amode, 0);
>  }
>  
> +static __attribute__((unused))
> +int sys_ftruncate(int fd, off_t length)
> +{
> +	return my_syscall2(__NR_ftruncate, fd, length);
> +}

off_t is now always 64bit on nolibc. On 32-bit architectures however
__NR_ftruncate only takes a 32bit value, leading to the wrong kind of
truncation. Use __NR_ftruncate64 instead where available.

Please also add a simple test to
tools/testing/selftests/nolibc/nolibc-test.c

> +
> +static __attribute__((unused))
> +int ftruncate(int fd, off_t length)
> +{
> +	return __sysret(sys_ftruncate(fd, length));
> +}
>  
>  static __attribute__((unused))
>  int msleep(unsigned int msecs)
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

