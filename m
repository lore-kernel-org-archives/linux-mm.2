Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139C1CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 21:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940926B008A; Wed, 27 May 2026 17:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1186B008C; Wed, 27 May 2026 17:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807416B0092; Wed, 27 May 2026 17:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70A7E6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:37:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1882A40417
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:37:26 +0000 (UTC)
X-FDA: 84814511292.13.3B25A02
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf01.hostedemail.com (Postfix) with ESMTP id 61BBA40012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:37:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ry1fcRv5;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf01.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779917844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbEjDuB8QT7ntVNRCtRvDOMAIGrYlu5Ux8lyrH785t8=;
	b=MB4hKI5/GomwZe5V4UiSi9Q5FXpRvgpUm/euZUHjsVvXSvvc2fKJ4N7decU3qCCv2E1tC+
	LgySzFgTqm4rOjkQryvJ6ZzWpWIDohGmO+GEfFcVVfTXNJIRrWE8eBWv3F0lmJAlAwIQkT
	EO3G6WrkdDxxr9GRDEAPTZNk7bwYX24=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ry1fcRv5;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf01.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779917844; a=rsa-sha256;
	cv=none;
	b=v8u2xLjJUbuVmYyUkdRRCaY/OScbRwHca3lMrtgWPck4cMBFztXe/ae0nIPW7NkN7VlBN/
	LJBNIbS8wmJMX7HPg3ixfrRI50QeDUehyovv5lwb2pLLvGelA6x+jxLdidojXPTV6+0A/j
	E8szJIQxWEEcv2bMDlrHKwDqp/4N7v8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1779917362;
	bh=hbEjDuB8QT7ntVNRCtRvDOMAIGrYlu5Ux8lyrH785t8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ry1fcRv56f8LZytezpq86CcLJFK05vH0vyllw+PkpmCvo/fXjgnI4IcoWFPTgBfdG
	 RKNe3NcwPvEafLP4L5tVnwfPGjeudpurWLMF1G0iIZJmIvWV7t/eT+5tLVowmDar8o
	 DDBxdhniC+j18USoHJjDRLV9rqYTWeQLvhvCTnHw=
Received: by gentwo.org (Postfix, from userid 1003)
	id 0F496402E4; Wed, 27 May 2026 14:29:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 0E6BB4014B;
	Wed, 27 May 2026 14:29:22 -0700 (PDT)
Date: Wed, 27 May 2026 14:29:22 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: lirongqing <lirongqing@baidu.com>
cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempool: use static key for boot-time debug
 enablement
In-Reply-To: <20260527104634.2434-1-lirongqing@baidu.com>
Message-ID: <4da5d090-8272-7f26-9e83-ea4ab489f1f4@gentwo.org>
References: <20260527104634.2434-1-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 61BBA40012
X-Stat-Signature: nsr5kjepocywninj6rwmhh54s1ihugb9
X-Rspam-User: 
X-HE-Tag: 1779917844-306056
X-HE-Meta: U2FsdGVkX1/747ZU1JmXc8Pzh5qrl6Qqef2yupaVyums5NNZekXzGkUy9smgC4TFN5stXygVc9Fm/FN5accT73nyZ8t/R26s+AY/yyOWmM6i3u0nWY4eJ0aqFWcgphrmXDebXp9rCGF7U/TfdLxfa8pEFvy3DONuDfOOEUZLtp20ZsDIRBoJ/C4R+LSCEFI1V2eBMg9MfuUfk63q4zoouwFUMo28/j0o0rdV7LneSkek8+a/eXbJGBhuZsnf7MMW03XzmVs5ewhuCHajulf9Jh/IQjeA2NBm3s3xgmD3qK11HMt0qOmo8UEtI3j9NHUv30x+v38U+2z6VfeoN1dVhUQUQ0n4MMYpi5M/TNxZetdXxQTAwntMGjH5ucPCPWhowsAM8Zm+9G7GYSET8h7RGNUbqtwIfApe0pNR48Caxo4PJ2Gf04EwyMobmlz4TTzm8Iudfm6GU9hCwPwG9FWjN+QepUp1hDDNSsQrCEzaoF3jb510ISLBB59FAKTHigP2oCKCRH5IKmmqtrF6H80P3y0XqTFn6W/0vxcTAQgVXV/5i08osKMuEL7ysTo1Z1SlstVlj/CY9EQgN3mUzkIOsi4WElUwsDkRPmdTKdfNrF7Ujv14vlk/nlfyGR36lvFbOItVpr23i6iqbNvf8xKjPWSbwiRVvVsXj+mdaliiHD1+D3zKamKOY3dcz69iBZLZkD3rHHw5nFmELMCxMi/jVbzDxXbUmwkFRdYsAv49uZ5C4tT+cIEaMDk6bC/KtoAkgjkIKuCaMQF+QU49clZwjjJLG9yS5cUACYyVr2DYxhl+awITMl+SAy7iG3Lhd5qF7Ft8WeW4UtWRN3Rwb/2kElHUQTvPu+nRfBVr8UwkGTep1Y1rDy0om5cCEPrtz0zeRaCOeZnM8DDtKsHrSmkfWRG4PczPd9NhSF0iClz47y4g+diycV64XY6zkWWYWbJzgeNXPhiBcF70/WnDdPS
 WYsIMH5t
 XJjFO6vMY22+TNYuNSijBhYCQn6/AVu2BZwxW/xwPY29BRvOtKntcS8hRNb9x4Cfmbii261fn2PT1T8BjqoOOivb3jHE0L57gb60l+1fZ0wwi6r+Tj86EGjjaFfMy7vq31JX7xwYp3Oq7TkV8LGogV/bMoeZjQOKPZ35LF8uaUMWz5qtQdZRQh1NH0FI3SDIVmxdJfd/YtR+xM4fzHUSgHLaoBTAMOGKcik10NvEwYTZm/MdI501sRcw4iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026, lirongqing wrote:

> Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
> static key (mempool_debug_enabled). This allows enabling mempool debugging
> at boot time via:

I am a bit confused here. CONFIG_SLUB_DEBUG_ON sets debugging to be on by
default at compile time. If you do not use CONFIG_SLUB_DEBUG_ON then
debugging code will still be compiled in but is disabled by default.

Debugging can still be enabled by specifying

slub_debug

on the kernel command line. And AFACIT it would be easy
for the mempool subsystem to switch on slub debuggin if needed also.



Why is there a requirement to compile with SLUB_DEBUG_ON?


Oh someone put an #ifdef CONFIG_SLUB_DEBUG_ON in mempool.c. Overloading
the meaning of SLUB_DEBUG_ON as it is used in slub.c with something else.

Someone was assuming that SLUB_DEBUG_ON means the same as SLUB_DEBUG?

Please clean this mess up.



