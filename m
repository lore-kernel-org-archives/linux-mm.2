Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4F1EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60A36B0005; Mon, 23 Feb 2026 14:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DD26B0089; Mon, 23 Feb 2026 14:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF05F6B008A; Mon, 23 Feb 2026 14:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB62B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:47:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CEBD1B5C55
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:47:02 +0000 (UTC)
X-FDA: 84476754684.21.29F59F9
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7CB0E40012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:47:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nDZVQDaf;
	spf=pass (imf11.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771876020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWGMHvSfeGqfk5XPfGtYANRC2MhPaZ/zaXsvjt5yMqU=;
	b=cF4UCywZlAxK1ZY9jd2A+aKgg9dI4jovlvdh2esYqDD42NIkvxUfvIJFWltCyJEtMXhLXP
	XUDNqRdecTnwTD/5okLuZzm0wNuwwycUrJJKSTM6jQ/gBzT4xscgoAxmBY0NY9c72xl5wm
	xMiUUP9Xm6kehA0UMJ7OLxzIiiR+pVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771876020; a=rsa-sha256;
	cv=none;
	b=7RdB/5t86hTjhbXS/ZTrmYagiORGQRfMbdiNaBHtbDa1Rr3Yt7uzWIIRxWEnGg2wKUSfDs
	BOb9qgB+prrJplTYIGy6w5BmCZxyukYBewQyHcGKVulTO97ZHqTvS6ozQ5+lAG00oM8M5E
	c9jRlc2TX8t4RgOKB56xfglo5xNCyyc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nDZVQDaf;
	spf=pass (imf11.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-4362d4050c1so4970619f8f.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771876019; x=1772480819; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lWGMHvSfeGqfk5XPfGtYANRC2MhPaZ/zaXsvjt5yMqU=;
        b=nDZVQDafEfteCdw5KhNVH1jckpbs3Qj7zgw1lEDwrU8DMs3KZTKQmVnuirLWP5RuFK
         8NBQWXvAtzajbW6TUvQCvr4WE3kBNGdac9vYTVFAoE7w4APvfHhDuKnNX1wGiar8fHNb
         vE9YGHYt7xj8JzqBGYSfJJPgjmtCl2Vet4TDKsenq40epm39GLDk+dpsNYParoUqd64E
         K53tTFpdoLhy1ZOe/gge6WCbAe7o13bnnj38zXXM8e2D3/vdKu4tV0WPuL0xSWmqLIi0
         kA3FVj/OvtVfjXMzuBcgDHMjnGI0WxCyZDSjbwu7FHzCwYuZJy4yJNBgQa8+clXk25ud
         v9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771876019; x=1772480819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lWGMHvSfeGqfk5XPfGtYANRC2MhPaZ/zaXsvjt5yMqU=;
        b=IBier/GTA+nBhrWw+i8h+6PHIuCVHoEBA89IRQHMHET3Zj5YHgpbvwYQo/cuIde1Ag
         EqyxCG3v4ct4ZNT4DsBJCsnRT5CTv3HsNUarFwSNDE8X2g+4p8p5H42jg4e9JoAB4PqK
         UH48QLHBRBsOW1j/8PdREgFZXlASdplFKnZCo1W09tY1R2vdPKUZXKSLnjBSwYyYm4NO
         ajkcM+mqOnqBdIlXxqO0WiTHsDFzqUU8A/ldv/5/YkCdaCvA/op5zRE/DvVwxEcxuj3m
         pdfDIDsaVI4jNPFNeGuZI4IQqXrr5zp5pUdxBvwnBWL4P7ylqMKv0at7jdC2uASEELeQ
         s+Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWo6C8OwKE8qlynUKQMWA5BdSxBoTeYtLA2VKhpyy1FhWrz8JhqdwEUve1GqUpiX4QAb/GoL0OdcQ==@kvack.org
X-Gm-Message-State: AOJu0YzibyWWjGQ9IJLD6C7h4xgyIiG1TN46Aj+SxVsRCJsTH9r0+zCF
	8fAzrFIe3Lw97mj8Sdt2qJXR5fMBb2Ip6N1NHIDOht4GRrjYbtm1G/b+
X-Gm-Gg: ATEYQzwhshVu+kVzihA0p1uBBhA7HOVuM423ddndEfUUKiDgW0jv7tQYOVk6bFH7ctT
	ucl0gmKVwHDtyrBlxZQ+BhCQ1t3+laOJDu9ja2g4vZOHhsYghzTfQKo1hO6+ca8YFH7ES6AYzo5
	48VBerL47SsjkSUhaivLYLn8/fTvQs5ADJBe3bo0yH1Tk5pN3C4pRTLZ5dE2kHKRyhA03jrNrEE
	VkIRY08j9/kT81xxCjVnT+vwgZWOYSI3uXSwDj/Gw17/VLlIx4gct89i7ZAX93MelKM9d0zbg5D
	Sz+vGX0/elujsJ4A8UCHwRJ6isfa+sD0EMoxXzkTraaX2nDw6+5DIXH6GpfMEGY0k5dzWWhA0kp
	rCuWWANUPIeTNo4KEb1O8e1LVhwSGL27afwbjwk00BcKPXmOp+xgrdAJsjukfEs9QVdaQo+iXr1
	mg/zCiDE2RL3k+7w7Sf2PrBCMByGjfl+A=
X-Received: by 2002:a05:6000:601:b0:432:5d73:79a1 with SMTP id ffacd0b85a97d-4396f188996mr19687525f8f.55.1771876018592;
        Mon, 23 Feb 2026 11:46:58 -0800 (PST)
Received: from debian.local ([90.243.35.46])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4bf89sm20115642f8f.29.2026.02.23.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:46:58 -0800 (PST)
Date: Mon, 23 Feb 2026 19:46:55 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback
 is available
Message-ID: <aZyur67rmiOT9zY7@debian.local>
References: <20260223133322.16705-1-harry.yoo@oracle.com>
 <e4f3b873-7825-46e3-831c-d0f5d3761ce4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f3b873-7825-46e3-831c-d0f5d3761ce4@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: bfsakqoe6ybxixx3y5kzrugpdqxnkebc
X-Rspamd-Queue-Id: 7CB0E40012
X-Rspam-User: 
X-HE-Tag: 1771876020-7661
X-HE-Meta: U2FsdGVkX19xLbFUVrdl6lxkvdYXV+9GYWj77pY5slphOLocNQS1tdxTkVQIDeKeU1Gz5dIhq5UBOZTCpEiYlf2aikMkmuuqW96ddxGGnFV+FIEOjLUFxTsjK5CGQUO9i/s0WaqpxY/YjwULnTG2L7O/yoZxOvub79DRdoolRBU6YwLcXR8cOR69K3PHqGGCQKUf2y3HNwv4GFnUmpLjQQtljA36Bs2oRNlwlIAYvGweolUPxABjebkuBnf2aPchOagZNRFMgdX/ulL0GG5l0HmWHwn5XHsmUMcO8nHaVbKoUluOqtQ/dhpRG8wTa43D2WJ9kBb+4/izR685vi5Bee3C0fI2TzqT6qkt6r6nngtOuyzAXtl6zCc69OtujtR8FkyAxYeZg5ojWh6V+zLfvZuOe/iLp1fWcwB0PsWSsFuMdJn7qqeot7kyGESHr+rjVa3ZhaeJm9EtnX1Wt1H7LpRCczN/gtanQOKQ5B7NmpGrHdVzhWgSqL2pV1GsHE6blqmeKydI6zF3oCyM4mYrd6voNxVHfqrHL9+ZKvSHuMhopZxRHXpAP4qjKEaJpIWIl0wsTN09X5Me+/z1MFxj5NArZfCxIQQ1S3du6/bkcW4whEgBdwqaC/lWQN5xN9jsBYlf0qu3XsUd3oDLptvEUZ/b4FwRJbUEeTOUMCd1XrI5bZAomeEww5TlHdBwfjUgigW0lz/0rMalX0NT9kBRZ1vw+7odBE07xmYQKQ0FKwewFnq7Y8bZBrS8bBdTRRbE6UFvJGbF8g32dicvB4SZZNQ2fZ6OJ2zz5qUtAWFk4S63E1jYRu0AS+CtYKbivqHzjyHNUP/qQPnGEYPIZEdIisxjB1n0dKbhgfuj2m8UIDgBICJ5qFDdDTq0j+XBp10tg65AtsbE79+RRumpV4RrkBE4OU7M0oW0DZNUrCgXznEAxHghA9YlpmdXGgFIRLoOXdEYJ/Ns9s1Y5Ha/0h9
 m/Rg5wYI
 78McnbqsGPdOEn+O/7EgVjrs9UJm48upFXs8oemb2UZrpe3QwTA2mo6wxFzRlF5rEEl+6mdtfoX2vRsuqQDYr19KcQu9hyJ1J+7nCznQl8Vsu8JycU5gUSiuvXsrmb7owAWIaNoZR2YAZI2q0c7HYFvLIxsR3FF9CouX3iyvoH85WDKarM6c2eF0Oj4whnUAfd1jYNEzrQi9poioD8/XfAWXIYIUJaGNzNRAqKWHb78ugXYuIZyhX7Zj/bVmj4OxNbmB7cagomxIClNa9j03mo+G6h1QyMwIe7bkjISDNaqA0emEUSB89LwzcoXa8HQces8HT+n12an4BLaCm5FGyPrRsUrSEwZJhvrK2wcCtaEEgxW9axMYZViTB6FoMgzLoCXrpEn6iCOV3oaruSCoULiFpZJB7fRofYJ2XdwaBeNLksT6g64vCEuPnkSJfxVeEmwrhAjOtBFMP327FDgmpwa5wA9mkaw+XuMdZoY4WVyd7Fo8oDdCeq+2yydcEWTlMoDH7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 05:48:25PM +0100, Vlastimil Babka (SUSE) wrote:
> On 2/23/26 14:33, Harry Yoo wrote:
> > When refill_sheaf() is called, failing to refill the sheaf doesn't
> > necessarily mean the allocation will fail because a fallback path
> > might be available and serve the allocation request.
> > 
> > Suppress spurious warnings by passing __GFP_NOWARN along with
> > __GFP_NOMEMALLOC whenever a fallback path is available.
> > 
> > When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
> > the kernel always falls back to the slowpath (__slab_alloc_node()).
> > For __prefill_sheaf_pfmemalloc(), the fallback path is available
> > only when gfp_pfmemalloc_allowed() returns true.
> > 
> > Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
> > Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
> > Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
> > Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> 
> Thanks, added to slab/for-next-fixes.
> Hopefully Chris can confirm it works (without adding the __NOWARN to btrfs code)

Yes, it works for my test case.

