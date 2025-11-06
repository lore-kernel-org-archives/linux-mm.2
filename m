Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F97CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757068E0009; Thu,  6 Nov 2025 11:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EB68E0002; Thu,  6 Nov 2025 11:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CBF8E0009; Thu,  6 Nov 2025 11:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56C728E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:06:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0EB112B8CC
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:06:25 +0000 (UTC)
X-FDA: 84080659530.17.E1C7AD7
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD9C9100018
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:06:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aIbFNlJ6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762445183; a=rsa-sha256;
	cv=none;
	b=kO+UoAFDHlU6tVBnF/Um4kMXeiBo38ZyfqUJPk127m4jUVJdb9+vSee62Q8/8MXpW+2yE/
	HNRyZQtQuxSOh7g4ZRtFvEPbTUXKWw74AddaDCpV9J23SoAXlVK8kDz+y/SWoQSUeBioVy
	gH8EXyCw5VeHsmq7+GTSUmpe/BJlHRY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aIbFNlJ6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+3lIOUqNBTQh3n9CYA+4M4KGsXczp/rbUXLDwpXjmo=;
	b=JDzB0M9/P4KU1LzEsMKs4332NyxCdHU35Up+7rt8DlpESihj0ilyC2K1OCbu56GjR4hzFS
	x50nHblNDCZYTaVTWljQCmRg9tNFJRAI79+kJWixeQONC1Dp/rb03NptqDfSIw+TPMZreP
	TKGC1yTscJ4psh1rIlDfEdlT2wffr+w=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37a48fc48deso9951071fa.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762445182; x=1763049982; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7+3lIOUqNBTQh3n9CYA+4M4KGsXczp/rbUXLDwpXjmo=;
        b=aIbFNlJ6D1khmGaKcRFBr0398JwvnxcRHABxvgtql7QcQj+l9kQqpx8sQW3tA8xox6
         kQ2tqpCQwEc3IWRnP7bkBTzYXI1F2pf5Wiu8wR0um6ltjswoC58QgTcg+Ibvv0a6o9pK
         ut+rhqFG0PMQkdBBfBl48H8LXaja21RfkuUCw1m0qPhvwaoLAZR86p9iowYW99Vs+iy8
         /fe5WRo/hmBBXRLyGi0znDAaDwc4jvqES1ZKuVJ7q1N/sZAFWtOAmDeIkcDllQn4VYKc
         sYHDlrzdI5JsJrcMy4giSIGHss3dPKAp/f+Y3CBuDuPcBjs+Cet6fzFnqKkJ+Ry9ii3D
         e5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445182; x=1763049982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+3lIOUqNBTQh3n9CYA+4M4KGsXczp/rbUXLDwpXjmo=;
        b=BlkLJm/CDATzLQDdYp9EQWD0FtiK+tu1hZ7EZE++v7YFg21JI4T/N/uJXCtk0c09Ni
         PJOfVxNNSOrctJz7haeZ3Wp90iRekO0Pf3f61urBcUxavzV8S2EF4xb+bzAU0PUgLQET
         p0W0LkdJK97lVg4NYjWxv7fOGjZAVDRf8iRRXxjQIH/DxqdEmQx9GJFYs0R7QLm/nRlY
         87u2qfI5Bvc7D8iX1elgsJodGuzgzX2r4F9Jq7QL8jXQKUJF0neOu6fux5F2dshVVJ47
         aIQEeW0Peb3CMoO8XrfgwYspIl2JA/D8SqafuWEmhHBu0vtizWu0nLXvov9NI4Ospa5C
         lawg==
X-Forwarded-Encrypted: i=1; AJvYcCUxYsXvJtfA5lSI5zIKCBszCft2aEkouDezsmsbgL0ET1Y2RnlY2VoNH+th3rUFmhEoFzyU066esw==@kvack.org
X-Gm-Message-State: AOJu0YwEgImJmy3qQG3qjkFHwbGRQBeAaE5Ct/q0z100h3l/pP5jd0QV
	jORbsxmqbfeLRodvUUj7H3Y/eYcWnIso2KadlPLjCbvV1BtOSZTeYI9E
X-Gm-Gg: ASbGncuieOZYcXakJ5RxTwQ+0/FwKgr7j410s1KoLQHkytCFa+ath+v9T5Op6qu1J74
	DyJ/3ykbIPmri2j7oJnvRnGKy+T6usoYj+dhIRLdclaoQjTTXAMJB4LhbUn9Xvye8GlhKYXbgKo
	NvltNhzAGKiml9gYFayz2Mjahg5X470rDqkTcTKIGcR9n8UICjW6+I4f94YrpCou6hieEacVYMr
	Eam+OvIInWH/noCnykzC0CnFv3eokFo4vHoPQQ0AC/G5l2MLyNE+ni5YF2IDgiLq/J4+4imfl0I
	u7vSjlQZ28mh3TkIibsedZElp7qrmb860YuevMRYaLE0Cz+g7xeZrKc4CaWeC8QJx4L7T201NZk
	anSSYujdwUt/MJF9v/+UIkhErtJzk/j2TnDKxm/jh4fn9iMl/bz1omA==
X-Google-Smtp-Source: AGHT+IG+GOa0FwAU+D9wc2hOalDEt1xYX5HTga97mHqbsRvIpDR9OdEzoo4fxwLubpazlMX7fGBJFA==
X-Received: by 2002:a2e:ab06:0:b0:375:f77b:b308 with SMTP id 38308e7fff4ca-37a514c0b50mr22440461fa.37.1762445180047;
        Thu, 06 Nov 2025 08:06:20 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37a5f0ee46dsm6730111fa.41.2025.11.06.08.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:06:19 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 6 Nov 2025 17:06:17 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQzHed0RfWBs3lK1@milan>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
 <aQopoAj3i2jdIX6V@pc636>
 <CA+KHdyWxjqAxVEBjOun9VxoeErWEyba3OvcJveLqnRuBLk2RLA@mail.gmail.com>
 <aQvlE8Hcy0uYAAmh@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQvlE8Hcy0uYAAmh@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD9C9100018
X-Stat-Signature: imwz644d6c617tq119p8nqcn5bzm3y4f
X-HE-Tag: 1762445183-483773
X-HE-Meta: U2FsdGVkX1/7sY1nZcHOhWiGw32zMHSy24cuAI6cbjZM+NvSPC4JNQwt5hHtEAX9CWTzrZRX/+pk1nZli8Vdw716tqC16Hi6gTbmvCnxyRFWkExevEXLhhqVOI18i9IotD39gYWIr/yG2WZ5f+ToN0ZqPKSN8BCG9ccgGsnghxjoe9zntZMyX9++X3qJ7hjhxCuClAGucw2JWdaWv+cGVZj0kHdWI17OpxkLXmrkz+x+8UegEw8t3U27Z/PDH9YinSLzMqQIrIAUKioPQ7ufdNlHply+eV92ncv79rK+vCFqe5E/XrEDubtRoBhZE38EDPBk8jcBTrYEPkoUTwb9MB7TciaK9UcRL1p+218uznHPasRXa4iectU9V1pB+HlM/hxROzRaa64p5TmM+z40/v6TIyjaQ5NPM6zzRsgfk529wLIStMpEBl/W4G9DCRHJOOFCeBXXyTSK3s1nlZXswFjJRncMVtnOFbQ+ZA4McYDd60QTqGTvyVPiPlXK5Fng/dflB8RLa7ninQGMMdPujcX5jlqFb0AOGpIynwQh/slNmyDEC+hdqJ8TuMIhAYv7GlSBsZotMcxEAzI2ti5FiZEMKsx3NVzsTTt4bzwFtzYDIkol2AqxssT2DLIvt14BKf3xvt9bBFqqO6jHT97HbwfhiWWWZR1yem/mWTU5LHQopfv6JkSTWevwAZsVeiKsL75TPmiL1gCD2LDcgRDdCHbeGYlNEqVtvlc84EDj1K+I4mtkFYcXoIiRuti5Nn8kjXCOiRkiw5RfxB703YiB4A8UOQh+bAT/BZcJaDXpuhR26Mka+S0KV03vSdii7GitU6F3pYf7DbMFmVnNfcS4s5d2orpYqquY8hWOEbIuQnJfdzjKgsspmxHXnnbbGlRUdFvxtWqSzM3v95B+w8oz5mZ549cDxP5MkdItd+7cii+RDpaN2ylo0qF4jHupPGK6MCVfnis6JXIRYfKzUG4
 cyZfeEhM
 y/e1nQF6BRqzNfnxO/KF0gnnK8rinF57uvJXUyk4qvvD9DndVo5LdAQpxMzAT1dWYR1bhAln9qY6A0DbbvukgiosMXtWLuCOUHW9bf7lP4oUn0+ctmDfInoMi2Vh9J2X5G5TEQTS3OBx4Vjje+C9aMGzEMgdQpMgpYqGlP9mP6NNrUGUWnWgq5dfccyWaXIoJq3E/feruS/8qcqnXJxaAob+75zbm0jw18c5i89avITIGu2ydNQ9ldHCAxoJsVOa/gnPiiFE85hUYFGUu3ZN6GOEyqCuFM9plsxiUemVjOTi+fYg4Pzrh5b6vStOVSxYdtsCujQNDNYqakg0m/zAcyRb0DKeZbsZyyOs/Fpa39Ltd22MedVexrfQHkVtbcX2g7EziuGc+JQUGyqDFioJrPCYi274lwar+4SMIIOodJZ6DYook4lBFg1NNS3jxKPena5HzYAcdiRnqT42e2U/KHvfRZOLJPPAkU+FNllGbwkg3FmnOlQcv1Skgn78uAZN1+KJ0Dhd4v3Xyf8YbXGeThOEZMvnAt6Pv/y+Qd54EUXfK+Ks1bCGbHrcTkF7AwH4wt6JsYom4kWA6ULJ1+SAfm0JOqeuikBtp7ds16P6CGFebj50BWUJYijvKKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 04:00:19PM -0800, Vishal Moola (Oracle) wrote:
> On Wed, Nov 05, 2025 at 02:16:24PM +0100, Uladzislau Rezki wrote:
> > > On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> > > > Vmalloc explicitly supports a list of flags, but we never enforce them.
> > > > vmalloc has been trying to handle unsupported flags by clearing and
> > > > setting flags wherever necessary. This is messy and makes the code
> > > > harder to understand, when we could simply check for a supported input
> > > > immediately instead.
> > > >
> > > > Define a helper mask and function telling callers they have passed in
> > > > invalid flags, and clear those unsupported vmalloc flags.
> > > >
> > > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > > ---
> > > >  mm/vmalloc.c | 24 ++++++++++++++++++++++++
> > > >  1 file changed, 24 insertions(+)
> > > >
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index 0832f944544c..290016c7fb58 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > > >       return NULL;
> > > >  }
> > > >
> > > > +/*
> > > > + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> > > > + * This gfp lists all flags currently passed through vmalloc. Currently,
> > > > + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> > > > + */
> > > > +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > > > +                             __GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> > > > +
> > Also we do support %GFP_NOFS and %GFP_NOIO flags.
> 
> Both of those are subsets of GFP_KERNEL, so I felt it was redundant to
> add.
>
Yep, that is true. But then you need to explicitly check which bits
GFP_KERNEL includes. I mean the white-list mask becomes less informative
for people who check or review the vmalloc code.

But you decide, i do not have a strong opinion.

--
Uladzislau Rezki

