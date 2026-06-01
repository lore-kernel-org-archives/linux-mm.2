Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37D3CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BAE36B03E3; Mon,  1 Jun 2026 10:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192796B03E5; Mon,  1 Jun 2026 10:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A89F6B03E6; Mon,  1 Jun 2026 10:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECB846B03E3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:42:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E1E4140710
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:42:29 +0000 (UTC)
X-FDA: 84831609618.29.8B61D60
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id AFDC410000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:42:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DpwsuUVF;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Cq7kPYGGpIpYYyEs4gWb/aAb8YW514oIdx9m9nGDYk=;
	b=EtV7Kqq9nh45iMAU+pT0gHYWhlvC5n7898iDaXWmSr8vtj6+uoPxaLn99+VySk1TKOXxUW
	EoryeABxYvdn7hqZSoKy8FptyJ5oncizcwE62yI+115G63eK+TWIa8BnZb8O9LljT3VQ8V
	4W2GHRey3i+XEm7TqbOaxrn4swEfWic=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DpwsuUVF;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324947; a=rsa-sha256;
	cv=none;
	b=0zibRHPb0iQpPBDF7RdiaCabzZvCRiCOdkKeUJj9ugoHP9F5HTqcInOgDTpNW2WOcTLM5w
	WzR16FyzSTzaKKcVQeoFyQAfS5zOxDnBxRjHQlkgPSl8SL6/FduhxXYMUnbQXVyhHqulx0
	Um01GcXnMANJ5ZBjArJh1Z/6yCZ/5LQ=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e6b5737bb2so1410210a34.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780324947; x=1780929747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Cq7kPYGGpIpYYyEs4gWb/aAb8YW514oIdx9m9nGDYk=;
        b=DpwsuUVFnudSOwK1au+blNScQnzCR3YRLtDYnjqYjlBLSO9AzpGB3NDOXMttKVlkPa
         r4NuEi1mF+Y1MRzE2CR2C33LQz7o6Q2oaK7KYnv0TmrEu3t0sUXnEwSEPaelMXZs8byI
         B1YOx/m6LNgChLx8ixh6R59/VMXXsVhgyM09T9sb2JG2t6EvpVuuAkfZ3rn65C4oc0Cq
         rIrZJdkSrc1UN8yTjmdfqytCa3TFc5/kDJKGCg88eOJSzGXSsBRYoZUlG3eSK86opCl8
         yPq77lmXJnfHZMKKo6mJTBEOFh4XB1DjcEgwLkTjeIHzb5VR6R0UnqGF5AHrmI5TR6FX
         SsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780324947; x=1780929747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Cq7kPYGGpIpYYyEs4gWb/aAb8YW514oIdx9m9nGDYk=;
        b=KdFPhfyXcX3Cp6vmkWMtD0ba79KBrtiW3j6QgJX57nf5sXZzzeN/aFqqq4O228vK5a
         +2yIdQleHzVM6/BsvEVDPucDiD4eaCTbnw3UeHosXFikrRlkZePeA3dnMc9ZJJwgyuOH
         br93XTDPLX0AKA/HwbOC9ZQbsA2BmtpYTucxFkgP+Omz9jhyES2EBkbq+1sDU1cjY5EZ
         TNvE+3gVYS8v27ujGruL96KTT19vSoJEJnNuYXKXC3cun1ujdNST4jkoibDxqrWdma9G
         xeNYgspaTGejXZL5MNJh3mDi919skruDtplr4JewUcBIo/Xj7J+11IibwtCx+ZcrdPmY
         lHuw==
X-Forwarded-Encrypted: i=1; AFNElJ/kQekiBKlRQslvVse+T7YPoyf9I6S0LF6kjDkxC6476QQ6RhF/4bZczUuD17Lr2A2n94lMvetTXQ==@kvack.org
X-Gm-Message-State: AOJu0YxalgBTDQL4iXchYTXUjewl5m2UbaJNAOwTD8dkN1w0NkBnEQiG
	Gju6lGRNfHEadyqeG96Kjpz7KFEDLKnvuR8u7qMQiMka0H38P9Hh/Wcy
X-Gm-Gg: Acq92OG9uFzJKWK3I/WBKBrlnF8NwzdmCUyVytmhs8zWvgFf4qsrIhQx2vyJzHnKi+I
	2VfB7r1WDM3BVZjr2bKhQie1rpjWi8jq/cgtZdNrobj2K1sxG6OsxjtmZEsFP1KFA5PiC15t6mT
	E8FCVZmyck06+SQ17QqxTNS+JSoO5Tq4z+pqJiWzZ263QblZB/KMck/ht6gbPZWbefiJ0alpzen
	1eWRdVyijFuEiqfpOHGxU4eOSvcAYhrX7AFhh28gYikOKNQtrxzpuartOd1iEMd57tOw/XNCgGy
	0Ku5FytNqZKWZZ8AN8RKPrscR+GM8TjaQVCKuj7mTk41gUdYW1cBWmay0/+wVVkKq7ZQA2A8Inw
	66qLmxKhYiZq7oASrtkrplF6+FFSqgUuukNrzGzm++Wv2/XyZtG811QO4lJXsCTtoepl3giC30N
	IaYANubo1vWFw6rfUzzODDr1Tnf2JjcWdx+FaH9F5szl0lGBuEXFIuAgOxZvlb2Eej
X-Received: by 2002:a05:6830:903:b0:7d7:f158:1f44 with SMTP id 46e09a7af769-7e6a1e76fb4mr6922963a34.21.1780324946537;
        Mon, 01 Jun 2026 07:42:26 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:47::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695b8fc5esm7765319a34.3.2026.06.01.07.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:42:26 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/nodemask: Correctly describe nodemask operation return types
Date: Mon,  1 Jun 2026 07:42:22 -0700
Message-ID: <20260601144223.2034903-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260530002749.87977-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 51kceayxpatdds6yto8mwnoqoy14xwd1
X-Rspamd-Queue-Id: AFDC410000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780324947-131766
X-HE-Meta: U2FsdGVkX18SpsrzDRbvblKr6/EtCQ1afzW5bI4Yw7VCVWtQQXWDThLyo+dYm4cLKOoh1aT6Xd4dczKI8uyTYrg+mNBpcUfFlMn5cJ38Yt9fw9fpd8zI3EGyadoWLkE0G/xMdevuVDs8Ha7jQ0xhbBUYQbLyMiAEeSPMnJ3jdDu5Is0e9EaEihuJo1XBMX075RcOusI7l/0R2KUA4UmpmdiM2xMPcqxrKdCOH5HUMC/J0b3ufe/fweJDGa4uSqCHXaTP+yQ44A9Fz2UBrui8C9U8TyfoL9UCKLbjpxGvFH1VEnoBacayEx/I97zyz+OwBtyA5RniHeBZ9gpCpFFdBVxUOgjR6KHyF17vDFu5a8RPmiJ/p0+BYtf6mEz8g/iolsehBTC2HYcuW9coNXEyNnMt40qqYkpMTOuxvJYDNTjo4rKJCcONFKjdtCykLHq9vA/2i13WwMOR8xWVwmHN+5pk+YHeBC/4xGmXahDkr88UjX6PrIzEIpSlUMjaAGGqHS/DzOQ09rxOoRaV2bCoU3fWLVdiagNMeDkfFYjZNDs5zWNcoMfHdGGjrN8L+opSRGLRrOnmj+D1COkbRbeOI5TDNAJ2w0eOInlEqiHf4Z2rq3PvKQSWm75m/Hw5x9scD4z/L3Z/gLSk/AbdTWU2O49LfY+jy68WZ1aUjjvsJV20Fdy5wKforwNrABLQ6Y/K19jGlAPtuy/SyzcH4LU061/utfLGaL4lqeVYj6MI7fPrkCqD1Zw7EFaX96UiIM/OgJFnLIgRCfWaQ/PTmp54svVMNywCp3mvmYVwFU54ZhuGUlfQcjWdSvy+iPzR7G5tmoEcNSixK7+LfWTT6+eyWGSI/78jrvh1aTK3DhQW+Twrvdi/QFkoEhG8EmhX2lsSIHyQ5ukf+ESWl+QdoRSEBtE5PoN1tnVV31h5/zaOM4ls/g3tyIY/XCWygyobWlgpwihI7Y2BMOnMJcMKq1Q
 bGa3USlO
 Q5RwIrrHGnFQGrVxSwIlnY6ahTLDgxBIDErk/dzL++5ArGcDVS9W0rmRXvjo7F05HEGlNyFjNthCIgiO7UcXYZI+blPcq3cOyMxr4dVKT2+G916f8D7FZmnvkisMDdf8uuwviASOJLOn1a2S66UqclaHvzrK2LYYBec6btFpl3r94riyAuho5nk28l3zDnwHrY5NbquEDw7d3D9WoiKjj7iPo/JcVabijQj1MEU49PWwDtaD5gySAnoJO5D0gdS7aYGaaaHJW8t7VkYd3qlMVCkedrz5r1Fnf6bQ49i/WgtalBNwjo9cuCFD5Tx4WVPLzGj2qunAmzNmFp30pYa17w/e+ZdUHilGHCZXI6wVjMZb8MWUUmzm2u4fB+ZvzP3R07w5q7FVK6MKT/l7UCYm0XZCpYFZD9SNnJRQnB8xSH5KThwtU6Mb8YMCV2JcubmaIP1fmP4usJFwkuS8YfjApF+yL0JVt5W4Uj+uA7XwbCg5S3hhZlvTiowPoqYAzOvTmRVUHrIubGpMekFqEB+gy8a88z7pnkzDjkb19dIuWR6TfvorevwcjCgPQQVBzIl39EX6vEB/SSC3QU3T9SQPWImvwcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, 29 May 2026 13:27:54 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > Commit 0dfe54071d7c8 ("nodemask: Fix return values to be unsigned")
> > changed a number of nodemask operations that used to return int
> > to returning a bool instead. However, it did not update the comment
> > block that described these functions, leaving the documentation
> > incorrect.
> > 
> > Fix the comment block to accurately describe the functions.
> > Also fix a typo (unsigend --> unsigned), and fix a callsite in
> > mempolicy.c that did not get updated during the conversion.
> 
> Nice catch, thank you fixing this!
> 
> > 
> > No functional changes intended; changes are purely cosmetic.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thank you, SJ! 

> >   * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
> > - * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
> > + * unsigned int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
> >   * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
> >   *					or MAX_NUMNODES
> >   * unsigned int first_unset_node(mask)	First node not set in mask, or
> 
> I feel like this comment block might be easy to be outdated in future.  This
> comment block is introduced before the git era.  I think this was the best and
> great way at that time.  But now we have modern documentation tools like
> kernel-doc.  I'm wondering if it makes sense to convert this comment block to
> kernel-doc comments in long term, after this patch is merged.  If we sure these
> APIs are quite stable and expect no many changes in future, such conversion may
> not make sense, though.

I agree with this. I'm not entirely too sure if we expect too many changes
in this section, but I could always be surprised : -) I would say that even
in 2022 (when the nodemask function changes happened) not many people would
have expected changes to this otherwise stable set of functions.

So maybe the next changes to the function should also do the migration!

Thanks again, SJ! I hope you have a great day,
Joshua

