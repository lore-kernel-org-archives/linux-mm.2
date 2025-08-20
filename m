Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDCFCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865066B00F8; Wed, 20 Aug 2025 05:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815246B00F9; Wed, 20 Aug 2025 05:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7042E6B00FA; Wed, 20 Aug 2025 05:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD066B00F8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:33:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA628B986A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:33:42 +0000 (UTC)
X-FDA: 83796623484.15.E35F526
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00CD0100007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:33:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JNVniuPD;
	spf=pass (imf05.hostedemail.com: domain of pmladek@suse.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755682421; a=rsa-sha256;
	cv=none;
	b=UVqwYztfLCwlNGWpf+i3tfgjs6jUHtxa7sAgPppdCctEUGLkfjrJNLyewhEeccVbw97ZoY
	Har6r7PxPZHEJJNr6ehXJmQ1h5FU5MOmmK+rYv8tNdNhoNbOS5MQYHtDjbWOjdtqNCqmZY
	XcSRYvP9urGTIYFHVg9HRSai0MHCCPU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JNVniuPD;
	spf=pass (imf05.hostedemail.com: domain of pmladek@suse.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755682421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUtGYQFblf9pQrLVu24aMqFiXE6ucdsRYulZCvjWiao=;
	b=071hO+/hJgffkt+VDJMsxX4Q7hD3XW+L6p+o2wbd+VQYcEXSy/cPS4BzmFTadsN5hQMUyU
	uELqhJHHxBpzbVZAGWOnhlzmaSwmvBL5qmjcPU208BhWqoixX0X0WJlAEH0dxvx4AtdcX1
	T0FNYBrYQQ+0bWmC+NRDF4Iwk5oeb6k=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6188b5f620dso7029889a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755682419; x=1756287219; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lUtGYQFblf9pQrLVu24aMqFiXE6ucdsRYulZCvjWiao=;
        b=JNVniuPDMajglJ5ZXpzgzExqE72qhGX2nCG/JPU439z1arQtuBeu85vBpVabrdyxXs
         Hf+yBqB+/RHcGTMDqUTgUzjIQqTrxsXDkGUlmThnJwywxChgy+YL0fm2fLjT0Y2jCPrY
         e11v7JZtyqgcCy/zsNOHw6f/u7SeSIdp7LmA+Rb0INoDQfpUUD9XKXzF9R2qPzJGiXvc
         PmMaFFpFyFhKCkDnLxxhV6Xvj6+RC6F2HtlqGBEsCFsuGROhaZV1BlQTdcvLyAg4zpkS
         o+FqtwldxqWQx9z+hRjQzHOWfR8ztNAMhIwSuQbPt228MF4OaM3j88GHDpeRzUir9XeD
         L50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682419; x=1756287219;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUtGYQFblf9pQrLVu24aMqFiXE6ucdsRYulZCvjWiao=;
        b=O9qvwekWtJ58eD5bwqHG5+6Dn50SHrnaTIfVeH0DghGNo3DgOi51PGTHYFQ75pzstL
         +wU8NYA0IBEgUpiJl4go8UsLKABqAzUOMgZHTLplvvxDzwRCXUiMZGRXQLEVECMCd1qc
         3c4ttTle803OUXH9tBk5hY5fjROw26QjYQuPstuBfrseh/sRcxguqtHwtjEJ4z431KjN
         PNZBROZZP+oYIAouMhx95XVyuk0qM9Kx8BPnT+USqZJaJ3Oo3x0m3cU2V+MVTBxrgFX3
         zvmHxS5cF+1g3n/E7ohiX1Nj9INJmjqoGhy6uSzRpwg3TwTVbj/pEWTf9C5/9hNsNu4R
         16mw==
X-Forwarded-Encrypted: i=1; AJvYcCWxbVy1dcicD1J7DKHhSXZ96LCNWTz0t7HpFvbJYDKaa3qUIIFdZ/25gwP55lKA4En60NKz7Y0g1g==@kvack.org
X-Gm-Message-State: AOJu0YxdmPWWESbKmZrW9Lj9P1L8wwrmFQWn79GOBwPyYlaWbAh6y83S
	TdlhiB9XS8vHCzSyIavI/zkDRbgk8TIj1NFHvSgChdLcsUgnEDZ+KoG2zXt762RFpy0=
X-Gm-Gg: ASbGncsT5vX7fQAlwgce8OqpQ7ZOKw2ZdTbx4iOJuBSDLOECOsd5JYQbyyoT6WX8CAz
	PYdDoslzhZNb5DwAI7vV2NQ1ebJChKY0kTxSSehIVtvXiv4S7hu1tPQPlbiOljMXb/Q7r+T3n/w
	zpO13wceTD7thlHziY0VBD0H66pqdfvzGJqSYstiqjUa6hySIgK/Nl2YgF95V8Aue2HxGZqWBIi
	3b7wINBTwJ57PgrmRZlT4vtBxHFidcSwW6EY87UnN5J2R2Bzm4mCIdX8wq7akN07e1Vq/zpAeNU
	uwPTe1rC/r4zrhv8JkpTE+taVNygvEtt70HeSiMOyK9ljCOKuHzLbCk11mIDBrkFOK7rbeZ4Oqu
	jLAhTeOhRhaB9+K7nL6/qj73xv23ILwCMMFiv
X-Google-Smtp-Source: AGHT+IGXHe3+t3BEKmunC18D/1Y6ekjPUy9xaq9clkZufAl4R+B2NGg/Uju7EdG3WK9qHxpL/vyc6w==
X-Received: by 2002:a17:907:3e8f:b0:af2:5a26:b32a with SMTP id a640c23a62f3a-afdf01b27bcmr193049566b.30.1755682419377;
        Wed, 20 Aug 2025 02:33:39 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afdfc4bfe65sm12791466b.85.2025.08.20.02.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 02:33:38 -0700 (PDT)
Date: Wed, 20 Aug 2025 11:33:36 +0200
From: Petr Mladek <pmladek@suse.com>
To: Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	paulmck@kernel.org, john.ogness@linutronix.de,
	kernel test robot <lkp@intel.com>,
	Feng Tang <feng.tang@linux.alibaba.com>
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Message-ID: <aKWWcPOf9qPIoCe4@pathway.suse.cz>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
 <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00CD0100007
X-Stat-Signature: myh8edqcp4mfwy89w9pfziyc37p5okfk
X-Rspam-User: 
X-HE-Tag: 1755682420-873232
X-HE-Meta: U2FsdGVkX197px6MKjL1s3Aae3e27kMel4y9OAlJOJ2KxdY4xHzKYVJ4Tv466ina5r3z8GPqG+nOTHscSV0agYwJ2On1CGwe/7jwjWzZj6CgBesI/7QBWnBmUlZSRf05+OeySzxcfVq5CU94i1kMmwJy6RFFWupTDAKm5KJVISFdcYfI6eo4V41iT9YZYP7Rf7/uhsB/RMZwImkUhzUdibrNgNBTUWCFUu62v5iR9HjyHRSTfilCQCm/ytZmN5qS0TbaeMngz99uKIUvL7Eb4IRUzQFrrQH0rJmwjeg8ZXFE0T0dFN2r4QRh3KnIES3uPBFnYxMk2KCBGOjdh3L1h4qZnF2M6KIlO5QO3zrDIexqCzLqfctJw3wTG7ZXYSPwF5DpYPjjgVNThHs02Fx5VpYZxBpUc4qym4GGCDNHxOVTJ6JigGnhXK+8zdKxD+6f8keV7N+Q+TJmw7CG0bsRHuJeWWh9cBeXkQvtVXqNXzyi4eF+FcdNpGDEauRt4cr52gvM+BOdjeUaLF47JvArcDWJMhpJ9ds1AUZSBuzp3IePUS3zGqs0bdDESmexODLuq0Ywn1k7PInfXhNrjmfdgtLBUou7ivQzKsLB81iS3IrFGckfIrV38sk8g5rBw3NXSdH0K70NdpINY7tqqr3vTEEb0cj2SHnLXkpNtY1cI4zrBYH0+ODE6Lj4A/9ImawgcmlQnFBCpmJM9EDWr50icIQyjrd7gtLeSkJi9jMroMTsLVEVllw7d+uL/U7ElC3zTSw5OfrlDYMbnHxvBVnQszX1shwOBWJtqvKqtgSnqs3OHvHXrE83ZIjeQ/P7YwBa1briasG9khZdLIa1u7Ifh3YZxk8xQf7L0dDv8a9Y2EwtCIJtYAPrjpB/hyYBeCNHWftOTRAsVDPhRwWuZoDMWY/nUz6RJuLknd+mVFROCFByVuSz/tI/9GxGW/RTcltswxQKBXo7FBzhON2669e
 2WektDIs
 zIW5xjJIpfvi3LjmVcXwvoCn4LmvMJ0c8dmvgTiha1a+zTT/l8VeAgLJ+FWIJaLXP3OIIDht5Zq5H2vKrPR7meZsy/dpYRo8TfgFbOzI0Cjdit19R26Sd0MKrmkp5srdxRzgCt97nc5KKP4OhlqHu4VHDVwecMB2YRGT88GwTmcEGa1eprHpvFqdGofuHkMne2xEv9bdqdyiUKCYTNOoIrWSUU9WKU6MuA5kHVue7U+gXz73bElZTW8BwFN0SwMKOGgxMTS8W9NkVO1gwx9DgaU0L+ByPlx7qTiFKstkL+p1YwplWTp5gBLVoeCr1RL0AJ5hxrLDTLgFa2Iga97uzOsIpqQ8dfghS6dLiUby3Bp2H3uO1D+xtwLZGNG7buTXW63PtA1hlhGy4Fe4a093r7fxZMuFXvuWNsSEz/xcSpJ7W4T/zIPC8vDko8OxN9xvjct37
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 2025-08-20 16:57:48, Lance Yang wrote:
> On 2025/8/20 09:56, Lance Yang wrote:
> > On 2025/8/20 09:54, Lance Yang wrote:
> > > On 2025/8/20 09:31, kernel test robot wrote:
> > > > All errors (new ones prefixed by >>):
> > > > 
> > > > > > kernel/panic.c:952:2: error: call to undeclared function
> > > > > > 'panic_print_deprecated'; ISO C99 and later do not
> > > > > > support implicit function declarations
> > > > > > [-Wimplicit-function-declaration]
> > > >       952 |         panic_print_deprecated();
> > > >           |         ^
> > > >     kernel/panic.c:958:2: error: call to undeclared function
> > > > 'panic_print_deprecated'; ISO C99 and later do not support
> > > > implicit function declarations [-Wimplicit-function-declaration]
> > > >       958 |         panic_print_deprecated();
> > > >           |         ^
> > > >     2 errors generated.
> > > 
> > > 
> > > Oops, panic_print_deprecated() is defined within the #ifdef
> > > CONFIG_PROC_SYSCTL block, but it's also called from panic_print_set()
> > 
> 
> If Petr is cool, @Andrew could you squash the following?
> 
> ---
> Subject: [PATCH 1/1] fixup: panic: clean up message about deprecated
>  'panic_print' parameter

The patch was malformed probably by your mail client.
Below is the fixed and revied variant.
I am going to resend also the squashed version.

Here is the fixed followup patch:

From 35ded31e9ff2c9925d7a78472115c9929b582c63 Mon Sep 17 00:00:00 2001
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 20 Aug 2025 11:25:31 +0200
Subject: [PATCH] fixup: panic: clean up message about deprecated 'panic_print'
 parameter

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Petr Mladek <pmladek@suse.com>
---
 kernel/panic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d3907fd95d72..24bca263f896 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -77,6 +77,11 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
+static void panic_print_deprecated(void)
+{
+	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
+}
+
 #ifdef CONFIG_SYSCTL
 
 /*
@@ -122,11 +127,6 @@ static int proc_taint(const struct ctl_table *table, int write,
 	return err;
 }
 
-static void panic_print_deprecated(void)
-{
-	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
-}
-
 static int sysctl_panic_print_handler(const struct ctl_table *table, int write,
 			   void *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
2.50.1


