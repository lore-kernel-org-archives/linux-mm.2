Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAAFCAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D638E000A; Mon, 15 Sep 2025 23:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED828E0001; Mon, 15 Sep 2025 23:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5328E000A; Mon, 15 Sep 2025 23:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4EF48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:29:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62EF1C0807
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:29:59 +0000 (UTC)
X-FDA: 83893684518.23.C34FF08
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 741C6A000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:29:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oVbwucXw;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxUjhwR9VEHGUYwboJUS57OxMHHZMq7UtIv/Sk4NGQY=;
	b=ePkiHaLVjcsff7NHARNZSzrfSI89J3FJYDhDiEMTMrnu6AFUmYRMqjE88ok8s8ksrCZo/q
	cDYZsPB9hJj/IdZxsfYsSk0KzZTDP66aIH5lZq0s+PzVfqUcALfQkUCncFRzE2peyuQ7RQ
	VCEJuwgkD4lBuxbQBUVt15vcfe6qgGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993397; a=rsa-sha256;
	cv=none;
	b=cE/6DbynHMCvC3pvB1ygR+yhT/oKCpqHjmyeUNcAwY5kOqf/Plg6CTsrS9dKEefBkoZJ7j
	2UtSAe8MRD881CyuV414OuadmXjE44DFOahO02HD22wg4X51lznh0XBHilBh7WL8d9AcfN
	ESE2Yi+IYZVYTIpEtuDX8JjOENCF5e8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oVbwucXw;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-777ea9fa8fdso1419084b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1757993396; x=1758598196; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dxUjhwR9VEHGUYwboJUS57OxMHHZMq7UtIv/Sk4NGQY=;
        b=oVbwucXwpTHhPY8BxsNq8bavOOCafwXwKaAt73UDwkMtMcR3UTzpZp8mTVZzW1VcCE
         b/2scsb8c4mJX/KyRFqqgr1uZLtx1cdDmrOVnCXUbce9b6dxZI+0BQeCR14mHc9Zzi4p
         p7njPYiRkyIh7tZUFwCgidJtqg2iC/hO/vm0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757993396; x=1758598196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dxUjhwR9VEHGUYwboJUS57OxMHHZMq7UtIv/Sk4NGQY=;
        b=cGZayRj5gO4NVH+SdRHzjfQevFh/c51XfXhnuDOleBz8rflwfn8x7mkn9kpm88G/0T
         K0+lok7aiQHEX1aCKZMYcWj1PIdwtFC70JiX/3bAsmsnnT1JGGXoZQEwnjvub51j602v
         yNJO/pbkBg78bD+ygVyaGlNQuwZWclh1toQxAPcEdLauJRr78a1xLrJSkzM8nExDOb3A
         LqeAUtgLzKkAPnjs+acxJI2qNECF4PldqozGBJeXbPusrXErwXqHeF0IcG1NN3NKgKq/
         EeOpYOQKlv2JWaDpHwU0fuCAYrRVMIg3DD8cxlXLIWoEw2WTvb5nxHYEzB8QP0tgUAp/
         /6KQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhCn28nboJEYG/SYtKcAuoSP83CkYO/sUNz5w2b4/DXHqyzArf/+epEOAQ8+MOOQpZFoqm5KBLDg==@kvack.org
X-Gm-Message-State: AOJu0YzSDAAyr5rmm0O+xmEUR/amHbmJRXJL6RC9P9dbIWp1rej3J+I2
	Urpjn0WD0sV4QufyB+C68gs1fdNZWyYUdEdNzgBHwdITn6va28rdBuJMZ1wmW/Ahog==
X-Gm-Gg: ASbGncsk7gqrYW/bAoGlirSYXmRTv70lPiqNGKGJfDtGbvnNaFXJ8a1AocaPcuv6LDf
	RLcrl/JM5Rly8d5mzXqnVFXIbCnXP8K7UCs9eNzArL/SF5BIR59oYxaSdxqgirEMWjDGB751KDi
	cGpDv1IYwDES5MjalLEacuQjeLZEnIkKlCY0CBeic8RONbWM8b0GAdcn7qdyBFfH+09XiY5IKKH
	iyzooVb26x625r+JTVILLBXZ5g1gYyyMVYXBmz65LoOOYKTYp3hZAEgggoPFFAb8lpIkQHtx21l
	dAZMxKn8Xxm6DbQyquEpMoGvsAcut76g8mOUCCrd5ZGgp9dCgowWq2zH01wvZ6op25X+pEOkR4R
	RNcoMdmZK7S4+WuxI6QTWMK3l4w==
X-Google-Smtp-Source: AGHT+IHUdGvf+grPzySU6sU1K6kv4ITsptEWc28oqLzHAsC2Xe4Nyh/n5AaIqBF2emksjORbwfcs7g==
X-Received: by 2002:a05:6a20:729c:b0:246:ba:2d9c with SMTP id adf61e73a8af0-266f4bdfa24mr1303797637.16.1757993396177;
        Mon, 15 Sep 2025 20:29:56 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:c321:7d8a:f9b8:7671])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a36bf815sm13259169a12.15.2025.09.15.20.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 20:29:55 -0700 (PDT)
Date: Tue, 16 Sep 2025 12:29:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <u2kujkv47egugef25at3rykkwuztel6tg6rjqqadacv2nj3pkg@qmxkftyzmayd>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
 <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
 <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
 <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
X-Stat-Signature: i5we4tu1wwnwbergbdpd3skizo6znqw7
X-Rspam-User: 
X-Rspamd-Queue-Id: 741C6A000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1757993397-843526
X-HE-Meta: U2FsdGVkX19Hdyb2/E2gT/OnSCdQ5vMtU3LagYaTvI6bIiJUpGUFTcYzV25PaNHZqTlaVbctny9wtSxCZrD6DDHr/v0gh3SDPAhomMx67NGCfxyJoToJTaGfYWmEqfpQJpSwiYE9/yS77kpASPbX1ANN8zf2ccpI8wPVekP4rO4chPxztBaETDgfIs2t2OhSmvSnWw2LLi2dZB6hyOsgAs/iqlgw1OsKOOnZYxacUIKXiAyKan2dMhj5QVl1muo4NbLlw/3ScERhFNBOAE/8USYgLN8NaZ57gmMP7gqcWTIErvjjwjKr+gR8wFG1M0oCkjTzvemfpNXqmQiFBYblVyIpqxo/fyvm7q7WVpmyxtZQoPHTp1m2h6E0ahqONKX1le5tN8dsyFUPE/u6jhQWQgMCmt6m7STZq7RbPL7TX5BGvkKBLhvpxhuFSC04k6JoQYWJUmGoGa3QhjbgkxDj1BEu8vOH/f59CA/K1KPf8yhhlPDTHePnBOuSfH+QfxOiRU+cunmg9REv8uPLFm+vVUHmS65wRYIm/nNaDlYtvTkHO6/0Fcck80MUAS+JlTqYYekQe9A3H4Z56zdCPIv4CqFaZPtrScWRhJ0xcyxkKMjJRQYqmg6GuH+z2vwI4A6uQ/B5P4lfmkK+ONWY5Iu8wOjcwPjIMu4WcL00yQ/Rw/B2aPef4t9He0zOTrLAulrmcx62+oZxEbnpPd3CaWqEEsKpmhQPlPu8+6I7kE/rF9gf5qyxMKCTIhoitr+q7Imz/heE/9Evwv0o9m28sTK0AvBfSkk4Y4Lwl0Ut75OKQK1Hfgfp9oIX2yoi5HwSsiUfsYzfTfXR9oVCq2cvCSdRQsR1wza79mqyJyqJsBA0lLEGluJHchGWqb2YDbkCzZCWp4ksW1i9Tw1A+gUtwK+EE0p2bJ2M2C6rewcO0XIE4R5Aoxgaxo0gNFzU12HSHrE5LNEhglnFptYcfJpBz9v
 nQxCEsNy
 BmPXSofIeGgmLO3UbKm8DiDagUztJXNXCuXZ5wmaF4y3u0RMH2xvxbqb9UQJSU0g+AavBQgYJuduBIpvtEuj2Kg1dEgudPurJm7H7T78MQtOePgesPeBkWUfqvwF1CkRZfDkDTeSeRP8eJy1dX7jUJ3tdDRSrf8AEQSRRtf0RCiOqMQtxPVZihutFo8PAn+AN1HsaHGaDLJuPwiqmvySnHkYtRqZ/3hjMWIefGmoqdTQ6JjbKd1MaTdj/MXuzz+MOey7g9VBtxoz6FqAngMEyLJO6IwkqfBy4LdpyG68QFKogGogQuLK6rUhegb5uMNgEIBhtKBgXEZ5Eh5Nd3RfKVfqTFZwL4QyGWKeOmTllKAQGkOFoSkh4NMvdZLcbgeOtmudvyA00V2qudBgkWSIPRvD7jHJVYoUgtCjeS99xKDvRxz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/09/13 15:55), Vitaly Wool wrote:
> >>> I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
> >>> was a way to toggle 16k pages on android (via system settings), I don't
> >>> know if this is the default now.
> >> 
> >> While I don't know what zsmalloc struggles Vitaly is referring to in
> >> particular, off the top of my head, zsmalloc does memcpy()'s for objects
> >> that span multiple pages, when zsmalloc kmap()'s both physical pages and
> >> memcpy()'s chunks of the object into a provided buffer. With 16K pages
> >> we can have rather larger compressed objects, so those memcpy() are likely
> >> more visible.  Attacking this would be a good idea, I guess.
> > 
> > Yeah I personally think attacking whatever problems zsmalloc has with
> > 16K pages is the way to go.
> 
> Well, there is a way out for 16+K pages, that being:
> * restricting zsmalloc to not have objects spanning across 2 pages

Yeah, the big problem with spanning objects is memcpy()-s, which we
currently need to do because zsmalloc() users expect linear address
from zs_map().  This doesn't need to be so, however [1], as zsmalloc()
can return SG-list instead and then upper layers (crypto/zcomp) should
handle that.

I have to admit, I haven't looked at zblock, so I don't know how
zblock handles it.  I'll try to look at it.

> * reworking size_classes based allocation to have uneven steps

If I understand you correctly, I thought about it briefly while
working on configurable zspage chain size [2], I think I even briefly
chatted with Minchan on "should we open code size classes instead?".
Then I looked at clustering (size_classes grouping and distribution)
and it wasn't too bad.  However, I don't think I looked at 16K setups,
things might be sad there.  Another thing in my to-look-at list.

While looking at size-classes clustering, I also sort of thought
about limiting zspages to one single page, so that zspages would
be a collection of fixed size chunks and each zspage would maintain
a bitmap of used/unused chinks, so that we can pack any objects into
zspage instead of "one particular size class".  But this has never
been materialized in any way,

> * as a result of the above, organising binary search for the right size object
>
> This will effectively turn zsmalloc into zblock, with some extra cruft that makes it far less comprehensible.

Is v4 [3] the most recent zblock version?

[1] https://lore.kernel.org/all/Z8K10w-6fIpDhYc6@gondor.apana.org.au
[2] https://lore.kernel.org/all/20230118005210.2814763-4-senozhatsky@chromium.org
[3] https://lore.kernel.org/all/20250412154207.2152667-1-vitaly.wool@konsulko.se

