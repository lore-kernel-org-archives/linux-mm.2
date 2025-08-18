Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58815CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFAE46B00DF; Mon, 18 Aug 2025 12:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2826B00E0; Mon, 18 Aug 2025 12:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8536B00E2; Mon, 18 Aug 2025 12:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE70C6B00DF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:46:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86EBB1DE4D3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:46:59 +0000 (UTC)
X-FDA: 83790457758.13.938820F
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F3E920004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:46:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=H+JPyDOQ;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXyiB6hArPVvWf92xe0IOfWpU3yyicTL/mf5Bbgn5dg=;
	b=EbK+CBMIZooYxUOgVJ2O9rJ0Ukidb7cEj+vxdealurz6CnQLehM3bqSl34AqxDL5oQ7q5k
	5NeFFCxlR/jkzdRnxVOfJOkS9J4Z+csk2HjBtBccq6eZLFIAwVKIIzEuL6jBn4GLEbk0RZ
	kKsfqX/6Z10Fg8O6IfiVL9ylZ/8Wht4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=H+JPyDOQ;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755535617; a=rsa-sha256;
	cv=none;
	b=xU7SuCKTpD5jE+BtYm8VBc0y5mW4pk+sWTylW0G0RM1F9qXoQLRVP32Dr2l1yqsPgHtcE3
	lHc4u67/2Nw/MzqH+5+zhtO/iQPZYzisOUOVemmlx3tHXEfShVr+9SL7wiD+iLmoIhhpy1
	xRzg78TZH4OWWxq/aYrlx9/AQYKm+tw=
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-30cb38a9247so4225906fac.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755535616; x=1756140416; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FXyiB6hArPVvWf92xe0IOfWpU3yyicTL/mf5Bbgn5dg=;
        b=H+JPyDOQodtaLfBfXy1h3pBoqU9mo6FE2EqDmnUD7/SZyXkk42ZATcrWdS1dZZf1IP
         PPcgXxxryExjEgXqjZHd+UBnT2Oczoyex+TuZ0odcrgc+gbxrHIrkosvIaRMRA5udme2
         PHLebcCbfa0Gf/0aBsKlkKzloUZN8v27l6YzpUcpqCaZfL7gpClOlf7W9wOjGvY0qmx4
         rX6B2aupi52dZae3Q2PIG32RVxCIuE6w4kKlE5Mq9VPfnmqwevPIUW/eMi4tkJerhqKq
         yAOpIGwhz1V0BQNhH8j5oVyONP1IFP8fgXgrOYZ6VjNgnDDgL6eRJLv1BeK3xoKgwiOW
         ZdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755535616; x=1756140416;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXyiB6hArPVvWf92xe0IOfWpU3yyicTL/mf5Bbgn5dg=;
        b=RIEuEdtj90pNPJWEkqYvhKVCCI4ipVL6hNzrSfoaD6phX3nzqRyj27+zyrxV2Ktf6G
         pu2SJ/NT+OINafqcu2giE/kwgOI4Bp2fMvcKBH0DzZH040uyH12rMpDqrkB5KzQr37D8
         AqFa3MloReYZPC8MiVyF1tLdSawtyTiiRvoqaCYSAgx9mKU+/EzSjb14L0DDjYcPBzG9
         x9m7vkwRAYfEhXmPQ7WzArzyzE0Y1LijPTK+XHdeqXisgGJuqKs0OF0n7+uNKUuGI83U
         as0uacHgTwz1H0LexOKgBSVk/bXbRp02Ghv3zwmHzL32j1kWq8IEhtQ6uq164OuE/B4w
         PwAA==
X-Forwarded-Encrypted: i=1; AJvYcCX4A3ScJBatixuo3O9UH5+kXvk4JybyC+lDPCX4T7/A8l6JtGYC2cDC8EwgUUBn0AmYqSAT0f2qPw==@kvack.org
X-Gm-Message-State: AOJu0YzpqsTkSuc+IpTl0BKEmBAyFqW3KjowVKG6W4kWo31cN0vKvmbj
	TDIcTbXrkrfli99K2jyqidzd2crWYpNGE6QWK/JO7JKHEygFPPMLm8jqAXuH7IdNq2Y=
X-Gm-Gg: ASbGncsL6gn61v4o4qxAH/thuD1cxhIU3QYnKP9jVf69fFYanQspMbGLw4/9WkmX2V4
	E3SV5lJGaGdxPKpFWW0RDqlwvHbocu4VZYWx433+4606kaVwyVX4pYE2F1WfVMhnQGb7gir/wu6
	YwfVoH3dcSD4lxsV24+C8X4hx5srQmybHgqyGBJOjIj2BTOfBH+cPXQZoW01t5y1EuPF5bX++BN
	XF73aHyBMWlvloVtiUYbDwS7LWqJRaGPy92FlhNekmf2HrN1dg4ZR2q8kbfryT9kebF6VyrnFQw
	1MF43jQwmIyxDEMGujchm0RBfKlvOvy0/+N5xqRB3tP571420fxCiZ5wJhjcQFvE2OQttxnu
X-Google-Smtp-Source: AGHT+IFvKK7UXZdTHshbJKUB2QVJXZtwhaBYoKAz5pKipDZGTWMsdrO+WMZc89+L2egtQ6zzR0Akiw==
X-Received: by 2002:a05:6870:cc86:b0:30b:ae4c:2e82 with SMTP id 586e51a60fabf-31108286d72mr194239fac.12.1755535616469;
        Mon, 18 Aug 2025 09:46:56 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-310ab952d79sm2706690fac.15.2025.08.18.09.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:46:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uo30Z-00000004RPM-04Ii;
	Mon, 18 Aug 2025 13:46:55 -0300
Date: Mon, 18 Aug 2025 13:46:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <20250818164655.GJ599331@ziepe.ca>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
 <20250818160726.GH599331@ziepe.ca>
 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
 <20250818163617.GI599331@ziepe.ca>
 <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
X-Rspamd-Queue-Id: 8F3E920004
X-Rspam-User: 
X-Stat-Signature: 8tgzw16sjjhkqcwag1a8nfyz7ucrwrw9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755535617-660749
X-HE-Meta: U2FsdGVkX19eE1hg5mjo2mKuNOYBy7+tbTvIZuomHHzMze1J+pt7X0D0OkVDjwtuk/fhjyquJswIv5Rji/8zUxcaH5o+bgE9tvB/rnZ7sHOfSLhWJmXnFS6lLzzxUMJKdE8sJZoXbpcjK3oqli4Exu0cKJO1RSXd9kQS9T5jaPvPNGDcTAb2vGj30s8iJ4HaOCuzjUcycBmuiroT+2CUns2iTa8sse5KdXm/oP9Z7X0Gmmra5agtxeaZmIq9eqfRlcJ3787QEC6qam/tREnaOQo2Eh4FOPSmB+9JigdxR1p3P1zGk5N1gQGtgN9gTe5OoC0nCOh0kQJcT4jhP7S94QqyJBxCKd+DVjCrtM8zQXhCdir2e//ThGlGwYMzuwG+UrwxZMQSHDdY+lXyIX4zBZTms7NTSLhTNw/Od6iLY58F3Qz0KLBCahV5fuuFrbvudRBAS/wlv2hnDMoM616GEh5kBo+GJBAp3ayOO6JLCEsKgBXR8AVdmSVhE+tW/F9cMgmyAkoJndKJrrdrnIb0DFEoGFzAhyRiWN1QTS5WOiUnui0KHRcMnPwIKjDpl6TcMqOgvBBT2tPUFqpFwu0ud2QJ0kVL8e/CBj5Wu9uq7wa0wHXe5v7dTkigpdlrsPo0DU9siBSbtzEsds6Gq1p15mlz4hN+2TbWKIdmdbwoE2lfSU1uSshnOit936/7u04c7v+yg/pB2/7t+g8enrsMUJdZ5DwLxpMofuOzDPTOeFMCbS5msn6IPWnu/z0yYd3nucN6j1QDbu6qs4NowsqqhQEi2ifWXpbrYsBctWOt9KI6utsLoOPaceOmYzsovFXxVOitAMe5cs76WTBEB0nyQorDCBKlAsWESO/sGPg1DFeIcuDhlYcAUxwc+vunJP3A7bNCzX5ycXEpK1vtqC3pNrHjRePDxL8V3g4tgqWAxheBPNs4Y9dIaZ624WpIt3QPDOT/7gQ8dCJvPxSZrdX
 Cp9TlL4u
 g+LiS6g6+dZwZAzAiOG+8Y6O3vmB6b0b59J9Lifkj4JARKSU3jHZfxQs9DIUWO+PEYETw3AWkyHPaSVIQflwTSL0ejccTYPvGFrJZEKXCAywd0dgCOTn5aV7XLA/pkp92aQy9HA1wh8pqtRvT92u6FsjqcE6PtvcOpzZdwjHQXJpWn7zAueHTqAPjPWFyn9wUwNp9wjTfAVvesZYaHa0/Tes5+zYMC3onn9RzTtpY7Tpv0rx8glNV0ufFCX6Y40PEyJR1L6tqXd3lHbt49e9aTiv2W+ISZuxgXckhJjhj/b5f8QycFc2j7k7qHQIuUAm/MPNzE1O03GZBSKvpV8bj+3oRTdQZlYUNJt5VJlu2LF66u8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 09:44:01AM -0700, Matthew Brost wrote:
> On Mon, Aug 18, 2025 at 01:36:17PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > > I think this choice makes sense: it allows embedding the wait state from
> > > the initial notifier call into the pass structure. Patch [6] shows this
> > > by attaching the issued TLB invalidation fences to the pass. Since a
> > > single notifier may be invoked multiple times with different ranges but
> > > the same seqno,
> > 
> > That should be explained, but also seems to be a bit of a different
> > issue..
> > 
> > If the design is really to only have two passes and this linked list
> > is about retaining state then there should not be so much freedom to
> > have more passes.
> 
> I’ll let Thomas weigh in on whether we really need more than two passes;
> my feeling is that two passes are likely sufficient. It’s also worth
> noting that the linked list has an added benefit: the notifier tree only
> needs to be walked once (a small time-complexity win).

You may end up keeping the linked list just with no way to add a third
pass.

Jason

