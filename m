Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A99FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DFD6B00A2; Thu,  9 Jul 2026 11:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225346B00A9; Thu,  9 Jul 2026 11:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BBD6B00AC; Thu,  9 Jul 2026 11:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D66376B00A2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:07:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EE531A018F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:07:05 +0000 (UTC)
X-FDA: 84969566010.18.5499EA7
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CAD81C0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:07:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PYtWtoJr;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783609623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LA4FqejTaFf1jVYUF/eNvlLLZJZ5tRpTNigHNeOPvho=;
	b=0+vUk5bNXQt4XUgEvLEj/T50aPM8AsrzTN4XlmGU8/D51zQS1iAAjhvdhdp9gfPjCZVMSL
	K+wUGDJ5U4+oEfrEhWrJJLotvJXnZ3fODS1vFR51RV/cvukKzUKytDdkVG2tYqDD1mKuju
	yElc08PUC5LYxkniYqQbKB55JyvVgvQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PYtWtoJr;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783609623;
	b=nU8wWHpu7iASxq3Udhe97kXqgYQnRGqGMqWJx8KwYINdzfaZzB90tjeYR6qCULwE4h0s3i
	fDgklY0flQgIMA32nWFFFat5lFtJDUhKVZ7Ctxx8WBu7wXNmoaRo1NIxypeOi7N9M9X5h+
	rt4CpK4vLaITjPMddxOPGog3v38WA3U=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c22c61795so13764271cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609622; x=1784214422; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LA4FqejTaFf1jVYUF/eNvlLLZJZ5tRpTNigHNeOPvho=;
        b=PYtWtoJrfiKiOytI0jZaZns7qLADISZE4+KJQK+X1ksJR4R6gCgzBk6dmGQ90qIrgW
         JMmRR3rLe/Pd9W9CUl6Qq6RLox1mJtK7HWXsh2MyOeZgoW2chKSFQdVpa3E8rzHyM1wC
         A50hZdz/7X6Xz3mgIzAr2A04cLwZotZHSt9eut1EDhj32mJOeeZJvIEHXK1vj24r5Eom
         CMYnCZ2HktvPiLdqJD0m1m3Q2WQ1ccgOf97vz9Jg2NrAQqRQYuVGFi1Q24L780GS+nUS
         kdnCrpYpIsuepMWDggZ6oGbqBy5WiUTOZCX4OCsRJL13MW+hOf1rYERcxXLi9VZXX5JD
         /0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609622; x=1784214422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LA4FqejTaFf1jVYUF/eNvlLLZJZ5tRpTNigHNeOPvho=;
        b=AswRaIo1WwhmKmIqpgUJtwn8DhswQ6gIXTmDcCG5cBj/VBn6ar64qX3CrJxp82R4jt
         yVIkSzYERRABmb85CYhytpoIW/6mV3G/tdTbFpp/qv2W1W7WZ45Jf9wL+nCr15oVfoY3
         Wj30Ni/OLGdYlXmXTzMDcbIWfKlHBGxSvQIgwtUN2iWSvvAjCpdB0WOgYRUkLdJhzUPY
         Q64GSe1OFJjfUaQmDo+BNmC6NxB+rr/yHJ4hN8TmhAlc/6B8gn4dCCRTKp1G0gsQ7bFX
         ysKxQlo7HqMTgWFcSl21Nn5Sq4LpCDtbHNkEWyxelMs6OoAkian2uxdap+8tFgRx2NQB
         le9w==
X-Gm-Message-State: AOJu0YzVJ/4Lrha1eWWEnWw+YsPMELvHUgqSFWbc8/cvzX9qmsUaGCt2
	kQgn1MnEJDCs+4TpJ4+zIuMVDuUaCbflN+UrsFWgeGVNiCEspcAmKWI5PU7zLBcACBU=
X-Gm-Gg: AfdE7clRP7AtU3OMstwaAOEzU6pHLFOWbz4E3qbULwCnpj8Z5o6TQ0sWsmCf1wPuuKK
	QWsXftQyeyyaF+aFAvptWKLYnxvx8q4LpCNL010Ki6No8zz6zZns7JcFUgJcTfearYXC520AGI/
	ujV51psUVwzRYPVmWiqwPCm6oF5STLnyFJvOP4wC5Ph++AhSk6RmQXgiOcTjBQX/o5MuVwk3Vuv
	lqzG4oE9FN8O7jJVPSprkxCAhDwNsz0XsDzn09x4A97cRzCs0JiwY2z4QyqhW3N7mbSNlrDUSNf
	sK26sxNht69QhdLXUz4Y6Vs9WN02En5pt970blhg8LwIuAOToDN7YX6NpvBhoOKFuMOFbQ/KIPK
	T4+QwSL8NbLaMiD7P/mz91ZUlXzaLad5kOVlBi4wTejm5o1tGE3dGPV4P07lJNmLujpat1Ue0b2
	JsknygsnmPXH5NtPVKH1mScb1sE6cZUN9p2o4S6skJUWeg9IjWgtLbG5xxSaUKbUkrReDm4FsGb
	7l9X2g=
X-Received: by 2002:a05:622a:1791:b0:51c:7b12:5fee with SMTP id d75a77b69052e-51c8b40f651mr77711651cf.74.1783609622533;
        Thu, 09 Jul 2026 08:07:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c42038c4bsm160321251cf.31.2026.07.09.08.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:07:02 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:06:57 -0400
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
Message-ID: <ak-5EXwL56O3G_J_@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
 <ak9ee95F7pJpCKMo@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9ee95F7pJpCKMo@MWDK4CY14F>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6CAD81C0004
X-Stat-Signature: frdzntb5y7yoosre4t3z1scojysm4ds5
X-Rspam-User: 
X-HE-Tag: 1783609623-456173
X-HE-Meta: U2FsdGVkX18USc4gDwW26C+ZwIQ14i9ZH0a/YU3f3iZMkUf08lx6brTtfMOdBt/C5hU1rvTuZpjOPOCXYJmudnuz+26+dKS7ul+2+jK1YK4uHWYQtJFXGSTY2Y97xDLRMZP2kyrKCT4Hk8YTLSRqHfHqVKvZDdRzazk6bmRBVuC7egFuIAFzBdpgoMhoXvnWU+Ha4s/5UhdksGqr9QNQOSCkhYLlzk4/oSy25ncpErFgobzChwyONTyHLVufHbZ6RHSMA4udRTk4ORkM6aOy7YOeHa07HlktietWeFDhCHvqfXWtFp7MBAdWl4+22c3Khut62v9w351OqNu9hui5HfIts/EshHXJ4QzHnXyRjCkhmcVuikln7D50IXSrJMdv2PLsz5ksHqUcaqjoti9Y8OHs9O7DveoHhqwggDL90VtttANBt3EuGXhqk7wZlwzTYELBMcc91fVngYAp3totCLjomejElzBHCMWVZ/JZLY7uWCrLt6FhrcFgDzkzqISbMFBX54Ti2PfeD+1RNyw91Im57zL57FXdWz5aZ+FNzvgoF/SiS9DZSW7BcfWUdU8E/o/T4P7l9yyKv4W5oXFxX+BdQSLHbsYjnEnORUr+LE1DqTUMJtq8zic6kgAefiWouQaPtGeFfNRxgTR0+E5Otlp+f0jOqUuAnLZD9pohSmJL5qU4d68ZtdiZSPDaKKLhy1E/b8f+wdhWqVpXmS/FdciuQg/n9NbULKmdp3xLWfkiZuar9/v4W7/3dH9VOEblGWT0K2nB5OTj+QD7iYJ5h0DPqG+rgq3owXcPAOrRVTO9ImRlmRrbYvEjK03d1A1ucIVWR5RE8hFximkd/QpuRKoNP2Ut22bR4zD2YhmyWJXOtUP08txFScJnUCEBzOqJwjKQfMPKldfrGPQTzgCUxQEgAUXNIwGOhWPifiyutENi+iL3SGgVM1B5XBE4xUedgmHiYICNi6ekXcl5CN+
 ZZ7+A+X8
 e/9jUUoBjsRasPdBxFuDVuJf+Z3UkeDzusAkfedDLu1bfI2vorDmm6D7GQWSu4xaLbT6xw7to9BL0LCarVX7GDnk4g1M+RXmZbtFJUeIPRC/LUiOMG0IaxOS9DqHlfFJyHxQRWo9ca4gyehvY2qlG+yI8dIxQ9N2UNX/Imn64XbWX8eAXrytzAVAaszVuA2I2SISCk/kvag4rzNlcLd281x5Vjukq6fvL9Tb5dPv36y0Vsuacl/JOZqaG+wrYMcXITnQ59+v35elrIEOCK1vAkBep6d82fW2Ey2bY8cio1/xIzFQEzxxGzq/cFD++uf9DX6MIqI1TtcDhIOxKOEq8dG8zLKBXztIBr+DRj5oBCy1sF5LMhTxHJoGJQrHsuoN/kdjUCfRlZRn5DcJtnVImXLQ2ZjAQHGKgcGENNs3KV4bD5t5KmvubL0EmT0FZyWA99i+EwdXbELRoLLo=
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
> Easy to hit with patch 0, offline one memory block via memoryN/state, then write
> "unplugged" to daxX.Y/state. The store returns 1, userspace treats it as a partial write of 1 byte,
> and retries the write with the rest of the string.
> 
> Maybe
> """
> if (rc > 0)
>     rc = -EBUSY;
> """

Oh weird, I thought I'd solved this problem at some point.  I must have
botched a rebase or something.  Good catch.

I'd originaly had some tests that race memoryN/state and dax/state, but
I dropped them because it caused long testing cycles (mostly because i
was testing force unplugging).  Maybe I'll re-introduce some of these
partial tests and just avoid the destructive ones.

~Gregory

