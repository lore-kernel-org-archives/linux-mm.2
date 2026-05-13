Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FCCCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFBD6B00C4; Wed, 13 May 2026 12:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191556B00C9; Wed, 13 May 2026 12:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0802C6B00CB; Wed, 13 May 2026 12:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6F066B00C4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:18:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CE6A402D4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:18:00 +0000 (UTC)
X-FDA: 84762903120.16.7BB44DE
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65E41180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:17:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L4En+7DZ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778689078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt9FBP1WGsw6Z9zRkqY/PuoLWJVlBgBrADxve8fjIWw=;
	b=ZUnlqdbSPPZrELtsFf0S8BmvQRa+fIds6wXbLHhqoshaHYV8AML0rFqjhk65IOoHvu4poU
	R7I34aGcWgbmoedwQfpUMin+1itlYxszozs6bLt/NHVew9sFkdXJ1K6yiS4GkBqRJimbZ/
	Hxf8CN1Wuml2YDujxM4ezPGZ1n7xepg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=L4En+7DZ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778689078; a=rsa-sha256;
	cv=none;
	b=AU41oS7qJdZjsrZ8kTgvWv6QqhMlO9Nl99V6MKN83S3bNdIVxZj3tz8RJTMU61Na2QWdDE
	ZM53Vwdf0e/bbH39xxxUq0PZDW8sgVVOKrI+ZswZ0P56trbzZg9L8oblwAPuOkuFc/geA+
	iWqnl8NKswez8kqo7qk2Iw43rn0jewg=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-636970cf66cso1334643137.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778689077; x=1779293877; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rt9FBP1WGsw6Z9zRkqY/PuoLWJVlBgBrADxve8fjIWw=;
        b=L4En+7DZtil/Dd4LVFjqLSUgbnS55m9LsCysiSP79rHlVSX9cO80EgALXt9YtQuib5
         2dTBFvaRt8BT280muHcFEj9V/w9X+/r35cm1B/rz8YsXYX+fHfaDddh9CfKz4sTh1X+8
         M/6AxDbycNdf5a5puRYQpAAXu6TDmHaygxgjpS0/ypY0l3f2PBQ0Ll2ZyHtbZHI5MICE
         bkd7W2xKbAUMW48XzzJD8HwdBj3x5DH0GCTnroGyGi+uNXolk9OWpgJtP/tdRQpymalP
         ACEwnaHZjJltHzZecpKXoxnONpCAoSJE5bPfnotxKrk3muLCwA/c4dirjB2X3Sb9YRH8
         eNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778689077; x=1779293877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rt9FBP1WGsw6Z9zRkqY/PuoLWJVlBgBrADxve8fjIWw=;
        b=Z9jKkV3DYm73cnNKJSGtaaDEOPw+917BnJJ594lcpQuRpVzzlam3g1n26MzQSkzpAI
         hIQ/GCiAxeO6E51JC2xrhJLyTNt2wMkW/UPCX8aFxSwjQrpGa4eoQGV4gdqUR7Oe0eRM
         UVFpcZGdsLoreX4vzWY2nFbu4J/2Aj26yA59gLBlfhKuldl/LVhmnt5TleURj+pUUeZ1
         wRcyTipa8apJHmKw3vYudONH5y6xWddezt5R6bLyvF4g5IsbQdJCHchFkKfIxPYIDty4
         /2pZu0p4FifY119MK6ACuFUHXfahNPR5LkZ0MEOgWtId93+Fx60qrAmcfzVkSc/HzscN
         oHHA==
X-Forwarded-Encrypted: i=1; AFNElJ9SriDQidvENV+ZvpC38NtxNh88DaQ00QFEznicp40MF9/3ctNvKSezGnVFPBpioj+y4WUTR9I6+A==@kvack.org
X-Gm-Message-State: AOJu0Yz52OFHuXlEzN13BqxnmRwA4+hE+Yy1Vhjp7yQOKvjmJsALSyYy
	2DOE+Nl9F0CExu+ycbCWCHKgQMJJ7bOOQA6DLr3h4akJ6mCyrCNOWG6Y3rGLiOAUZQM=
X-Gm-Gg: Acq92OFW//tAjB3MFcxtQbxIqHjv+YR4Zvh16guQskHws0uHsraSkAPwmlIKtN/yqNq
	aDtzj8z5Th0m2KaDUQCS/H3KVQQ/btMb3yMbkAIEpblBtJaWB7WcblHFp7JWPuYBFZ1GR6Co5Em
	eqWP+ldA50OlQxQRQbDi3LqIZOMSP/R/AYB3sSIT3AGoRWMyqG0d0ue1DRXBmAbKBYgqsL5s4gI
	OFGXcoHpfmKcGmW+WHbCVS0WKmZ+h7bqeOYlQ+Kl8KtTY7+NdO2bqoB5wWIvlYYZSHXbNOMIBmX
	OY+D2XxbPBqBq3PWjTrXnh9TaMJHHQip/1EahajcuC8dlz9tB885NrygGojtZfiTo5GhXOnsUGX
	4ei6Et90X1HDqKI65qA1BKBRdO51ZQX0E9HEXrHoi1ScqrDhHKt8+WP5iyNWSPhKhRhY5zFgej4
	1nxTlaskhT+4AvnUFEoivOE087Q5UFSt1WtDyaAi/XknHgAEUe7WJWTCu2mTIpm0oMLIA+tTW6u
	jucHm+Fwdjjk78r3aZ4kz0=
X-Received: by 2002:a05:6102:441f:b0:628:95d9:9607 with SMTP id ada2fe7eead31-638b4c4ffffmr152334137.2.1778689077262;
        Wed, 13 May 2026 09:17:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3aed2920sm158507606d6.7.2026.05.13.09.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 09:17:56 -0700 (PDT)
Date: Wed, 13 May 2026 12:17:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
Message-ID: <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Stat-Signature: hzoqzc5uebcsyszznzt7bffghwjnu69t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65E41180009
X-Rspam-User: 
X-HE-Tag: 1778689078-313082
X-HE-Meta: U2FsdGVkX1++EoR/BmUxDmZgmRnALHWd594csUuzH+msYQ8lEglRoOnr+3xfj6iOPxpxR8kWwpL+gDZza0wPmwq5yBWcvgj4NHhxLWBxLxMTMKzgGetfdIP7BBifCcp0O73pMM5F3BDMJbGP008ZOOseAIpp81rC8kVLJBs9NH2nuw+JY4oEChbPuYEq+9K4xbAuv7VbJul7k708ukQG6SV14qXWwpZJhpetvyjdfRmMDrcJ6/arTGW9YU2X+/j4zV+RJH4ltR4tzkAHBWnC7VgoDeSuzOGZy6CJGBgGAD3zfq97TWwPOs10yys/Ye0SaSTE07jszf3mN7xMMI91qCDYlpS6lB+zLelX1xQrrPpF5l3bGlK5BV6xpEr/SfqMt5LZbtVPNQJBbVN7/qO3aRPlm8yuVgT4aP9EoafkGIBSpkwfuLIrSyS9fRpKmBoJiu7S41etwoIZeI8RF1JwRFiRaO6M+hynDvpHPHBq5UdE8m8iwTwmhMnU+w4n6KxxfnkytRwHuPub6VVEqKgIkH4NK0xTeHpCYenWkBEb+Kojc1lIuRhA5XkazQka6kJvJJHRfYD4iH3NFQTdRfDNdO4hH1pnrhJg2ebKru5cPwgvFX+y2mFazJUYqY/Pi6g5nRw7kfMSLafXb7dN7fQZrPma5oGubwT5n7zyHHaLt95sDl4CDaXihGIpqH2SePlft/rXZ3vFJzlX7VyCPFqYP7aP+V2S+H7g7ZxVyKQ8Rtse1WgFMMO37skTSDzXaRdz7wU1w6fLsuTotl6K4QvpM9f9ZXMrd3nlHNMstl0iWoowodI3LTWpYynD58VaeXB8IMRmwKBd9tyPwz57fg+jvDWZsK4lxDupYlRtSITtqZyWtTABxMLyH7bFiFgnnhl3tJJX+yHKTewkp+duNcjCtvo2aDIPtWgQCp44QokyjybzVFAwIBg+goVTjBOVvhLkKplfiZ2wvi03lzdQGka
 kXyzWf7S
 cKWyw/6i7UHW89VfNXYa7J1IoTTn+eZmsn6kMHSg4Qvy6wRhRF5drCv8372JNMUc7DzX1PPpfpTkUk2n8vSq98z6mxzxfR4AChRyQmsS4/1zzRFH5JJ1WIaNx7s7mMBzIE3qEp8umGO/tlLAKVTxMhdGNGJLyxNug23gXc4wV+T73krEoy8hS9c1QMG0Wohc2oGWtClN+7pKzKXTyCNoVV4C1oDl5t4BjeCPwM7r/wYddj+gLB3lAw2o5Jw/ENQyP6MnWGKace9PKJpdqLefWMb0sK/gAznNS/JAlBCta9erCz1oXbpvSbcTET6NtsQlOIQkY2RoNJVhTy4IK1XOo2rxP4eB0FJzZNUJfy+35fIXoWpVGEExDHaE7br8VIIsYxvm8v2CPRFUTBYd3fKRIUFCDvAzP/hzZZjuH3hKW28bz8FUis9oCBNysZiGfi3YPl2slPKllPjs48zCgL7RHNIXWmTAPZjhgvnacMXxNpijXJ9ydnewB+XNXchmAZSwGiSYg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:23:24PM +0000, Brendan Jackman wrote:
> 
> Because of these ambitious usecases, it's core to this proposal that the
> feature
> overloading the concept of a migratetype, this extension is done by
> adding a new concept on top of migratetype: the _freetype_. A freetype
> is basically just a migratetype plus some flags, and it replaces
> migratetypes wherever the latter is currently used as to index free
> pages.
>

I'm a bit confused why the need for additional level of indirection
instead of just adding a new migratetype.  You still end up increasing
the migratetype matrix, just with a new dimension.

(apologies if this was covered in prior work or discussions, just now
 plugging myself into the series).

Why not simply have an unmapped migratetype, for example, and on steal
you convert it to movable or whatever the preference is? 

> .:::: Hacky bits: simplistic secretmem integration
> 
> The secretmem integration leaves the mmain optimisations on the table;
> the security-required flushes of the mermap areas are implemented via
> distinct tlb_flush_mm() calls. It should be possible to amortize the
> mermap TLB flushes completely into the normal VMA flushing. However, as
> far as I know there is no performance-sensitive usecase for secretmem.
> So, I've just implemented the minimal adoption. This will at least avoid
> fragmentation of the direct map, even if it doesn't reduce TLB flushing.
> If anyone knows of a workload that might benefit from dropping that
> flushing, let me know!

Crossing a couple streams here, I wonder if there's some mechanisms
introduced by MST's latest multi-zeroing-avoidance [1] code that might
help deal with the problem here.

MST wired up an optional user_addr into the buddy that allows us to sink
the zeroing step for folio_zero_user (or folio_user_zero or whatever)
into the post_alloc_hook - which includes some cache flushing.

That conveniently gives you what you need for a TLB flush AND an
indicator that the allocation is intended for userland.

Unless I'm fundamentally misunderstanding something, the pattern at least
seems similar.

In that sense, does this just become a post_alloc_hook that unmaps the
memory after zeroing and allocation?

I get the intent is to have the majority of memory unmapped by default,
and then steal those blocks and map them as the kernel requires more
memory, but I wonder if it's cleaner to do it the other way and simply
have the buddy unmap on alloc after zeroing, and remap on free.

Seems like the free path would be trivial, check if the page is in the
direct map and if not, remap it and move on.  Entirely hidden from
existing users.

So, maybe a stupid question:  Was the opposite mechanism considered
(unmap on alloc sunk into the buddy), and if so was it rejected for some
other reason?

[1] https://lore.kernel.org/linux-mm/cover.1778616612.git.mst@redhat.com/

~Gregory

