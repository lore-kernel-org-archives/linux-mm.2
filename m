Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0D1CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F3B6B00BB; Thu, 21 Aug 2025 11:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9A56B00BC; Thu, 21 Aug 2025 11:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25D76B00BD; Thu, 21 Aug 2025 11:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0766B00BB
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:58:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49C1116045A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:58:38 +0000 (UTC)
X-FDA: 83801222316.23.CA47A1C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id A248A1C000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:58:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CA9HLcNd;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755791916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB0LpMCPOYaWwGiNMIOXNIT+kz7RGrjl98q4AqLw3v8=;
	b=y3QLINDTPaobZ6t/nhvikIMQCQ1eiZTgdPZQu2GrFEN1UQBOOYLliKDpuT+Aqjh/kTwx5E
	bvB0LxVLziDDgYfNb9zQ7QUDH06bue3WwEGofNj3Ymw5kVhAX9DQ+wBHX4dD9OiS+nMxUq
	9zQT9bjQSXsDaIeDoeLktg45rzadjo8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CA9HLcNd;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755791916; a=rsa-sha256;
	cv=none;
	b=4ecBJzRW3h0HHTXoTlUy0rmlE8qYo0hoEDso0ylALSQZVwuUUjylhNNp0zOUy9UzZr/3zU
	6XntJ9T6RHDTl+8WvOqQCY0TD/RuwHbmdlXXL6s3hR5kvE26vtVMGKA/gUFE5TtpGGkT95
	8sXMz5mznhA3J1x59GkvfTQSwCc+AkU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D492AA584B8;
	Thu, 21 Aug 2025 15:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0C3C4CEEB;
	Thu, 21 Aug 2025 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755791915;
	bh=bP/JIPfZE0+HTDUGADbV9HkxcIqfv0r/PjlTY88pRt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CA9HLcNdWGreQdR/bOKT3h4J4RPEjFT6PqTpNQ6bviQdIcRNWjWLo/eM/I6Wbzt+W
	 I4iQoqeqT/fgPPvvVT83BIJQrD4Jd71Gjcsam6nIYIi2ilknP2dzeft4n2M25gCV6D
	 kNTtDeFKxvNUMG7PJbtDNWIiFEU1jjkD94Ekwh1CYrbpW0f1RxAeblY3Cgj7utlatV
	 85lQuSJcenxUUCH0IjE0HPaTMC5/atOlWMe348626sZ5mrCtyw/iTV84KVhmHBpK3y
	 DCHeamXOEuXVodv0UUUzZTCspCSVHOZTD6qF4hemf4zWNyz8/oqUikz/Wezlml1s0K
	 GRXyIzLNRnw4w==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Thu, 21 Aug 2025 08:58:33 -0700
Message-Id: <20250821155833.57597-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMHgOPt5zx3q=KRxGGfp86R4V0AgO+FrHDftqLYoG20BWw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xbzh4fd6byza5awbiee7axedhyho5t4
X-Rspam-User: 
X-Rspamd-Queue-Id: A248A1C000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755791916-366895
X-HE-Meta: U2FsdGVkX1/LiFWX65j7cL2Sagg524V7A8ZQE82KyLVjH5AerXxF+mopGaPT+sLamDaS8yLY2gQdIK3Dmgr0OWRgAyX5kEuPWOZyew3NnUYr/KgBT0H2/2ShKEKCplTADZD2MUQ/I2Spx7WsBwRCVbmQIMyxM5rUpFVGbw4Vh+tnagkgHHSps6bo1zFsMZ86h2UrMBt5y62MS01gqlWUhXZJYaxtFBMygaWS7BOiXQhGhi0rKqL/BFLTKAekC7tMofbv4d4piCFQrpKmsNDG4Qar4gUDe+3n5R+cVbdT52vYfnBo2iKCsBkYdaeWb+/V5hrEQP887bOOE0XfyEbLF74cVQHOfV1jBhYhVtkddnMD0gRE12kReM/h2sdzJrICxR4Xnyzu/uwmJW2v8hgd2MejVcTJpJl0EtUQ7gYQp3n/8ijt8s0ken3feCZUDD6h3Sh06a4V196KDZQ8bCAatk8LyJl5dIYmj4w0J0R4YZbBDspExB+ze90cA1lnwCfRV4cmqAGr9+rTkQQPxa1UhxLzVhIGbi5p4FhM+s2YUDqoDfBz9V6B0+GZPjwxG96lMirkA0SygSaiYCDbKZm3bh6wuWAvTDy+vpP0Fh6LEJSLmafQwxHU+c/JZCCbnTW/ONgah2oPpPIAXu0s7DW/OlXzQsxyocZ6TrFQWqrOgl5z5FwVcRsd4TvCRX2EOaqujpqCkipALqxhGXv+3ksR24YBZaTq2Mwzm0W2imRW0YyiXR04udyY7N3mcZ1RDfou+FNGvXPrq70XbCE3v0jkYfLl5niAJEY83AXwrS/5OswiFpLsza4INf48FpGkzPomPGb1kHdR21CVt/wsvaMI++ER7AOLrRY0rjSDt1ZbvYjm3mShahLaCFEa6B8qoNgXAvBAh7X98kRxnZNS3zBEBuEZzxIoP6ptsf5wdJdGRgiapSWE7s2RHmnjaRxpV+t+VFBpacjoSBLAvNoYTEU
 cBSmEkc0
 jTb0Ueqy33P9WPLmtA9CMo+Rg0NswhQkSpQ2ws0T6SfRLPSD3GF24IAUx/BRLYsfY36tOYVEsCnnELKso9nbug7v9C+XD+m9jD9Zv/di3cwdkkIPjehUxQATCX2OMDvYgsp2tlB3iyx3G3fMiuHCu5HSNo49GBJc7mROA8kMBWegyBfWySTm/Bpjs1vsp0cwSZmCuRXOBn7qclVX/DC2SzaQNzXy7RnuSIBLhvdIWpmdFP3P7bwZlSdjWyHQ5pwcAkd6dI9ZuEdXMCeRU4q1ueajOPOsPEY16bxhRb16AR4Dd93sO2z+PpIWvMxCYKt4XP64KOcLceC2RLrd1BPmFIzJ1uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 20:06:58 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> On Thu, Aug 21, 2025 at 2:41 PM SeongJae Park <sj@kernel.org> wrote:
[...]
> > Let's restart.  Could you please rewrite the commit log for this patch and send
> > the draft as a reply to this?
> >
> > We can further discuss on the new draft if it has more things to improve.  And
> > once the discussion is finalized, you can post v4 of this patch with the
> > updated commit message.
> 
> Good Idea. This is the draft for commit message. Also, Thank you for
> your patience and understanding.

Thank you for accepting my humble suggestion.

> 
> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
> /*
>  * Have the 32 bit jiffies value wrap 5 minutes after boot
>  * so jiffies wrap bugs show up earlier.
>  */
>  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> And jiffies comparison help functions cast unsigned value to signed to
> cover wraparound
> 
>  #define time_after_eq(a,b) \
>   (typecheck(unsigned long, a) && \
>   typecheck(unsigned long, b) && \
>   ((long)((a) - (b)) >= 0))
> 
> When quota->charged_from is initialized to 0, time_after_eq() can incorrectly
> return FALSE even after reset_interval has elapsed. This occurs when
> (jiffies - reset_interval) produces a value with MSB=1, which is interpreted
> as negative in signed arithmetic.
> 
> This issue primarily affects 32-bit systems because:
> On 64-bit systems: MSB=1 values occur after ~292 million years from boot
> (assuming HZ=1000), almost impossible.
> 
> On 32-bit systems: MSB=1 values occur during the first 5 minutes after boot,
> and the second half of every jiffies wraparound cycle, starting from day 25
> (assuming HZ=1000)
> 
> When above unexpected FALSE return from time_after_eq() occurs, the
> charging window will not reset. The user impact depends on esz value
> at that time.
> 
> If esz is 0, scheme ignores configured quotas and runs without any
> limits.
> 
> If esz is not 0, scheme stops working once the quota is exhausted. It
> remains until the charging window finally resets.
> 
> So, change quota->charged_from to jiffies at damos_adjust_quota() when
> it is considered as the first charge window. By this change, we can avoid
> unexpected FALSE return from time_after_eq()

This new draft looks good to me.  I find nothing to further modify.  Could you
please send v3 of this patch with the above commit log?


Thanks,
SJ

[...]

