Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7E1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC6D6B0005; Thu,  9 Jul 2026 13:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C106B0088; Thu,  9 Jul 2026 13:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6361D6B008A; Thu,  9 Jul 2026 13:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 411236B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:15:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C346340264
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:15:25 +0000 (UTC)
X-FDA: 84969889410.17.A59C2C4
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA81F1A000F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Dk/1J+SW";
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783617323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46UkRwT/i/djJx+KopbYZyKUrVPhRVpwIJdu7TzJpII=;
	b=ov9h8UTkRXHzqTETTIY7PQ6CJZ/ca4i83KLUZKgMJlUVGwczFdKic8ZRNrcdRrd1ma6MoX
	AoNfmzPc/keadoyykb8P1DpaFvh4Jjb7TdxC5zgdRe+n0Dk+FuXaeyZ0aZ7JXmK97yJgdO
	CGcd2ZVlVrazHbdjhcSjf8jEhrxtS/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783617323;
	b=NMRxQw2NJv3RYHwYFoDYz6k+pdymLmCmTMAlRNGq79T2wVjNl8HORUIWa96NL2mQsDjnhn
	BMvBbYoLu02gIdz9GLoww3Xz6koYOI0s2fMxrynNcFxLdtnJa+cbALoX/BsWe1Fxeh5PlD
	wGBZBloq1fkLwKm28C/7CF9Nav76H+0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Dk/1J+SW";
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so1159946d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783617323; x=1784222123; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=46UkRwT/i/djJx+KopbYZyKUrVPhRVpwIJdu7TzJpII=;
        b=Dk/1J+SWF2s6FGd49vBduRIGeyYbQUjYsGLQhvWA+FDGWBYeGyrakcTQyL45J693rW
         +OPGfe7I8h6PHyvEsfI/MDCcYPuHfKAUSojIzZr5X1BDqTPIVtxcPd5yA9l2Dtz31V95
         0d2SkLB5oa9QDWgI2291HJ3UKw6vp+72VVK0gqQW3MSqNCVSj0Xz4SVDTUAKvephrOPn
         V/+tUdWCAcfq2KMkGq1BGKPEpZOANWyULJsTzghzRnImjVJAevnTbDvuFLwZFIf+Cjfb
         4zeoLGwFFGPPOYWtTIcAMBwc1Fi/K9krZbSiJYyB6ABCBLaSa6xTrKBhEBZ0mpa/nHoz
         XBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783617323; x=1784222123;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=46UkRwT/i/djJx+KopbYZyKUrVPhRVpwIJdu7TzJpII=;
        b=CPOn2EHwNf3KxBlX3fVl3v3rep3ZA8HnI++7r+e9bn0MKsHg8OY/QNcOb3nwSnsBu8
         jkpwjE/AwA8UTsmtcz944bMKwojmLlHqV2kejLp/3XsUW5I/O360MUgR+rBnq0dipxkI
         jHHzcHqAUjaBx9qXnynuotMP5HbgIJp8Xx7fqws/et/t8ccpL3XkO9IjxtKJXxegTo2X
         yc1C5iciZjvVm7vDL31FhfijVUHkxaQ6I9X8/3DVmJBZ4kigz3jyCu8PA/1AZbwzUd8e
         0/VF9dAvW51aDxSO+k2oTiA2s1qWrvHjyPPJL3WoivCPwY3qhKSuZg/CPcVoXs2/Doxq
         8+FA==
X-Gm-Message-State: AOJu0YwCJI+OI9b49DMQHh3JIB+iQPeyNGOaSnkSXpKSkCrXGOhYkhFO
	/loLYw9cZWCeexDCNjbKvDnoqsJ+T6OUImxI29Fhvr+6cX0dTPP++CL4NGCUOResvlg=
X-Gm-Gg: AfdE7cnBN8F1rzFL+uVeteH4TLQUWga2rFFj5dfqRvSqW++ocOyX0gCG1htvNsItXbc
	R1SOw4WBOMJiJNrzSXYIdGD5rpuQGOfqvxAeNXm4UPl/AjMG2V/LPgFAXV2LggJ64RuWvf3xWtL
	BuoEuS0WorLeA0LxfCRmuJBT4wWMjl4hSz7FowlDRvLDegEbpp9KIc2LZlextuiXN+rkKUhcbAM
	uUyBHufwwPcpP0ybWVNhPglVSaJDyEdhscn4+p85q6cl9HGezP13TJDRw+OKjdyA3CCWqjb0Csz
	Ra/yYIjvVUA0OtAyip8tejM4WqYmkL3eCE3xZlt4dWTpBzbqzSiN4mpts0MRR+jRGJfOQiz/HW3
	eonrW+K5snYEK8y+Gz00FzzCEgYPJXcN8l1kNNq/ivvKLl/O8iTwwIuhkANPAypTZr8OmxcD8vP
	EbAnBGRC65yz9QqgVBc+BPOnAigoF7PFienFGR8TQozCfTWUCOgZ9Aoab9svm5nNhzPGpp
X-Received: by 2002:a05:6214:6014:b0:8e9:f45f:107b with SMTP id 6a1803df08f44-90242143c3amr1641696d6.34.1783617322803;
        Thu, 09 Jul 2026 10:15:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d8fcsm22085656d6.25.2026.07.09.10.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:15:22 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:15:17 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
Message-ID: <ak_XJWglABmKfSiU@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
 <ak9ee95F7pJpCKMo@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9ee95F7pJpCKMo@MWDK4CY14F>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA81F1A000F
X-Stat-Signature: 95kqrd5j6ynb4ka5jda6irndfnasj69b
X-HE-Tag: 1783617323-938977
X-HE-Meta: U2FsdGVkX19+bL7itlwhOYvqzSDecO8ZEqgZHtMP8LDi/DaB9dr8ThfbPFeEoZCDBFlUKiHVNisyjYfJGYXVJQVVdN+BpKRV4Rn+KxdK8FmIVHjJIAI1mYuNbKUyyp6td7SM5Ch1c6/qaZ7Q6RuCr6ScjQm3x3mmsJAFYCsn8Gyoulnt3SZPbA5MAUWjgLD3A1SHI/Kav2NroJ6UE+kmhd0AaWw2NJVIPi/U0xo6EuhkHFZFy9WRI77TzCrisZoutyKxZd1Jdj0qPa8PMGKuq3QYKgFXru7okgjWolWPsJpG9gH/jql6c5fGpjemJEReJWuY5Q46HGPpGl8sGpb6aS5foAWEjLkUiDA9+bxU42g47bTVihalPl/jLLxzfGSPQDVwSJ61GaWVxHjCXgKAwlJpmfc4+2jBKmZAZkmITEHqzkflBmKFgDzgCcfomRTRdiCD3YpNvtSqDn1D2JcGiflrO5w1yrWh3s8GbIoFlr2p5kUcSDrF/kGyVaURRnWf552WBuU5um0w2IdK2NTCoGk0Xw6fxmNPWwHf3LGNZfwpJy/h7tVOREblG+WcRVXL07Zd52JnN3VYitUXYg02+SBYIoagjrpojEUmBkVVuVMciT0Tif2mTJx9g7mbv4AI7Izrj6u7M1ZZxRc4FMxVRzq7rnAZL9Dun1bCMh6RJtMqZHAXsKbLksC+8H7yF6iCelThAHeTjYgYs4sS0377u7MOUs+BPM3QKOUdg/wPT2LmDqsvWc31JegYVsykq9rsiRiXZ+qi6LWf9Z9uPX2pgpkYsMSP0eLaa18WDcgR89hytkYlNbxQ0R/2xN9nvSL3pm7EWAdeOGU5xN1otZoTH5bGB77L87EZRnhTMLez6KqQo/I0rin30pqm2e6AnuFMy7KWDnVbrxLCLafClVd7Yp1ylyZTv2BseKGqlheSAz/8G+R39S81EApQ9nYeM2D09vwBLup6/LZi1My6SmG
 T9lmxhYP
 OIni61AdQFRtAx6GRI0kQouJ8g5d9pDQqHnbRGApQnlcxhyH2Gkmfct2x7BeY31d2AMozZXL7ws502Zp2JkGQuF1XLEw1QOzLfq5+1NX71iklCzKkAPjjMg4TPATNDN7olkr6lGQl4W4vrbBej9xw6NX0roEbSnuM8uAx+n1svCc8Ufw5424aD8n0g+6tC4kQ7xEt0c0l0FIPZ0QF1gqeouXGgYgrbN6Nl3n4JYzOfgp5a8jQ/9IEVA+HPVeN0rN4ijB8q+fQYGfZgeRUtpLeHvpuVHal8DvFWnVPG8MHrJv4LASD44Kvprb58TuYDYBdZCyhc3xVDOmAj4SlxiBhY56/xf9q/rUH9aQAl9sp9BfRZWS8LbFYY6k/RjEgdiOYq3YgprTXWptPzDtUSgCt+aPCnjevVZo0xTPlsESnPeVfdGGJROgRhcSzA0oimxKqgkn5zPXEWF4juGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:45:51PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 05:18:38PM +0800, Gregory Price wrote:
> > +/**
> > + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> > + * @ranges: array of physical address ranges to offline and remove
> > + * @nr_ranges: number of entries in @ranges
> > + *
> > + * Offline and remove several memory ranges as one operation, serialized
> > + * against other hotplug operations by a single lock_device_hotplug().
> > + *
> > + * This offlines all ranges before removing any of them.  If offlining any
> > + * range fails, the entire process is reverted and nothing is removed.
> > + * This provides a fully atomic semantic for unplugging an entire device.
> > + *
> > + * Each range must be memory-block aligned in start and size.
> > + *
> > + * Return: 0 on success, negative errno otherwise.  On failure no range has
> > + * been removed.
> > + */
> 
> I think this can return 1, and it shouldn't.
> device_offline() returns 1 when a block is already offline, and phase 1 passes that value through as-is.
> 

I just realized try_offline_memory_block() already clamps the value to 0

static int try_offline_memory_block(struct memory_block *mem, void *arg)
{
...
    rc = device_offline(&mem->dev);
...
    /* Ignore if already offline. */
    return rc < 0 ? rc : 0;
}

But this is a bit non-obvious, let me see about making this a little
bit clearer.

~Gregory

