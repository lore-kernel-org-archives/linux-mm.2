Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51B2CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050976B0007; Thu, 11 Sep 2025 13:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0282B8E0002; Thu, 11 Sep 2025 13:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FBE6B000D; Thu, 11 Sep 2025 13:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D55A36B0007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:25:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64F621602CC
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:25:12 +0000 (UTC)
X-FDA: 83877645264.08.EB290E2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A4FE40010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:25:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYxICliW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757611510; a=rsa-sha256;
	cv=none;
	b=5ns7HBvPDrRUwBjMWFImqIm3BXXC+A8KrveiDXzgXBLTcqrVqVwB2auhBgb7vmBMbEbx0s
	YH8sQEn43ar1/VTwSNu+sboNSvOdaLIQ+C55niqagZCErYJmH7g+ho77J0OfPq5WGT3jiA
	Mw9SX8wQoGaOmRb2kVenT2YtO8mubkU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UYxICliW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757611510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66hww0i42bGnBY1WyrFAxgF0MA47MP7lxex8W0+v584=;
	b=Y82ndS9N5Xua/UXiSZz4pSx1b1IQHjy6rS0EzHPPenRTSBg1om/biswbLniz+JW7gVShrD
	H3DSNbsiEauS5HrUijBop+KAvjqm0Qz30IiXdjiPHYIoPv3FFmuCEV/YdIsfSE0jPFcTaj
	jMR3uJsyD4XJh/7fDR26MkuC4CC/3YU=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso7660805e9.2
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757611509; x=1758216309; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=66hww0i42bGnBY1WyrFAxgF0MA47MP7lxex8W0+v584=;
        b=UYxICliW4s8z7RaaXNVHKr/ktEQFG/E84oixQNn0xYMXIf18WUBVFIcQQbYNIRJuk4
         d+eZB8UD4D3QnJzGvy49ertOoy11mtIuixZP/3trPyaVOe6QiDSBONPZJzTF1PlKy3xi
         YSeYmT8rxoAU+rcesx56W0Dp2F+fi5+FPqfQfxlkqXTtJ+NOaeYWvCTED7mF2OomVEzr
         uSr3SbioPbs+Xl8GKnKoo/v1a9FMYYJiqoZCBgK5wMsqVooW6pDWleEfycAx9efKZMrj
         zNgGD6RO8Tywa5SWi4vTFJUzph81E5MJcYMMme/H9NplEo68jv4o9EGNe7VjR8GCy/MX
         ASQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757611509; x=1758216309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=66hww0i42bGnBY1WyrFAxgF0MA47MP7lxex8W0+v584=;
        b=A1oiU0ESuL4SAqQkRLEjllxeWjkXQa6y4x96By2bh68hVN1ZEii5TSMvbEzQe/6jrz
         dvRCQ9g9Sd1M3rGplpUVAvjuyxikkYZRhKvVvwkZx7xKRThu7WomFADU/vscTbcVjmtH
         aeVdkbsR4LLFArUnDBFQyHws/pONQ2WCHSGh+8XfQ2RjUUFo8ee71gKArnH8J14de0xk
         IXFByhgDZkQUZozdQeTKuJ1EK3LBrD4MNlFawnTU45jL/IpJWKyKojbdOih746fQkE5R
         3onWy20acwoNjskkbDSK2jvwRfa7oO+Hua3Q8M1Orn8S7SxsUe9os2oQAANjsowj0pgy
         6rnA==
X-Forwarded-Encrypted: i=1; AJvYcCWPSsTCmQG2C1pKbnCoWl82d/nAWb+MPzMpJ6hIsONtzSrrmzvVanGXj8Rym+R1t1v6YYU6K31nBA==@kvack.org
X-Gm-Message-State: AOJu0YzsTmUh9TqhjzsUPPEQKwRJ4U6MIx6+7m8Sg3ytRSB3s5PzFw3i
	kpYsXO7DwJnqUgX8DlyLq92lnMnz8uaRiGcfIPi5fItM881ewKzgp7td
X-Gm-Gg: ASbGnctbSvUWKu/udlaWDppo9yNMiG6Bx/sRGGzJ1CU5I3fCKYzJTPIlB7QpeLJQyt0
	0mHIrjtBYWs6OS0cXo4qJ26lmJh777E0Ssfotclc/Brz33WFRX1C0mlGiaQNO4h2FOJvArfueS3
	QmceS59tP+o8pYDS0P/8icti3Eoml/OEFNQToV9OA0LrgGB8JCDPy2O+T7mEctU36clSMZb5pae
	5iueq97iMCUEemA6DyGSFOyoD2Lxpwk8r/Ix/7+NitL0ugnCE/lXFYYMrTQZBd7xphR8GsY/ZpB
	D4/6WEcUURWwKFbmoAL+MF8/Zo8F7GejfMe359f4FgTT6trdc/vTHYgijUM7kAHC5khDLRLTwvo
	zsm2QbtXWgyDb06e1xnDymQ5hEDkSlPmhIfwdCwAvdsmCvfETHg==
X-Google-Smtp-Source: AGHT+IEaEQOTywFYBJnwC3JrY90Mp6xQbmA2EeG+g3Ac9ehgcskjHnu2dwm7OKqmhaMFqIZZy0my7g==
X-Received: by 2002:a05:600c:19d1:b0:45d:98be:ee8f with SMTP id 5b1f17b1804b1-45f212609f5mr1816215e9.26.1757611508226;
        Thu, 11 Sep 2025 10:25:08 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:70::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0187f0a7sm18431515e9.3.2025.09.11.10.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 10:25:07 -0700 (PDT)
Date: Thu, 11 Sep 2025 10:25:05 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>, David Wang <00107082@163.com>,
	akpm@linux-foundation.org, kent.overstreet@linux.dev,
	vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <aMMF8elYvlPoOF+J@devbig569.cln6.facebook.com>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
 <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGezf06eR7WnzizpwTaxZ5Rm8jbeW4y87zcr6LZuJ9MZA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A4FE40010
X-Stat-Signature: 9wkeje5df9ux3qp9h1hrxun8c3eu8bwa
X-Rspam-User: 
X-HE-Tag: 1757611510-880672
X-HE-Meta: U2FsdGVkX19SpLKz1azIpwiPeVDtdiXN+L6qdZbREccVbgFYeX91avrOTViC3K09j/cbRLRsc+hPIebqHRdIkZS5A6Ho0u8rBD0bgar67u4OEtmyyA060nfKkum/YeiM5lu4uwV0GFvrti0J1BmNWHriiVOX7rmThuNIcy1u1I0+kh99Ad1GyV+gXV1FqYXsVS/qu/5NagS/2pVIbAMc5c+r+LKhWg9QPHEj5pwIoaKW1QxhheWwsfTs2jFkhhNOMVrtB9dqZ7JuXkU9BRN4yyIPp8G+rC71fOJOLoOE8Pd8ASZJ8tME5luwQNXyxl8YYvbucMuvwQLW3tpvVZTT1F5H0D6DYg9gtUIlOtrRTgzRRno+7mnHoffpJKddkYk6kiRa1oY23gsn0seFopYv/5HvINzywVPoGadIIHCHcao43D7Sioo+O0JYNQQP2N4NX8PYzwdomflmU3Jp2nwXYq4ExvDAfY/Oh87avxUIbqjEWd6e/y6ovBXcjbF4RAMH0WEw+bJdQ04KDdWtEp2XL2yyb5Ga9tX2Zm5gpzZWhTk1Z7JE84k7RCldmnXLTCx04EHTXEsIfmBJDTlZvIU9V6XkJtvgqO5+8H4wlSp56IqXD9xq+Cav3FrBbWR6DcnxNqleZNHKAmikVxwxPfNLrAnuNco1SMfqGhXmOKWRMHWi/omJgU7yIsoaMOk0VtLTnDO1ZqMhDMbOb7UGm9iChh61Zet7um+9U+4YsQmPwYbCDJiTh3CLiKaqSm90pwa/DfnkXQmW8p729bFObgZp/nZA3sSljxKw67k+glJahhKQO2zp5HSp03dR5m2n68vZROV9AwHz76f36+QoLMNBUUCSzzD6/xndNeoWe+ZwHwcXwaCqlnM566Iq0M2fIoEaow9ZDNArrKNS1e3qvy1CaE/jc8pm3VtFt8Mrbjj3/iA2jzkdSnYS72bWHQs9QuEL97MEANqa+zkXKRRBrGS
 mQkvvo9v
 sHimEvfDg/4PC6k+rFgfoLaa8lJzhtSEXVyj9O4n9SUYt2pD998Nh6X3sm18Qd/w4p3hWUr9ToFQk0+ac9XDKE1oP0RwGESVsAc9lh6xelOEjZ7nyIIMABVRpdwTCZz65DbcQrZ0TlJ0rcnMsb+7tjkeMElBDni+TkTEwPhjDXCal7uxEPiGKqbUXSVpsy6FCz7I+R4aI9S1sK+kV9Sf2Af67MRdhziXMjOW5A3Uv7N/rW9BIKJuGCki3J6w1tzaOarj4ihGYNR4VFA6lTcLWxVjoWiViOMGSFlMcT/euBEoZHaqrzjLNWFgdVvY6q+wGVMoHnkskidYiVymvN7ailH7oBsvnPX295erEuF43UUtTqkCpuucb0ZGdZkG/yzLAx8wmPJta7uJ2hKtEQJv2aV+IW6Sd9kP30l8+w+9RO8aE/MmQd8K76Y/GQTCFMX+q00yihibXoChj262cAdXiV8q5c5lKanj5/nqsU+qZy76DW2DylIRbt/tTQeEQzIuoMRlUzAAlLQzmvDDkUlxRNZDSAnUXxBMeWF5fz45HXehGO60CCR1LhB9gKYSosPeJxn88oDjpvv09B/JTtRDSHPK22IYGSuxPXTV7YzqJX88ZJjUVXFHGzOfO9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:18:29AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 11, 2025 at 9:00 AM Usama Arif <usamaarif642@gmail.com> wrote:
> >
> >
> >
> > On 11/09/2025 16:47, Yueyang Pan wrote:
> > > On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> > >>
> > >> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> wrote:
> > >>> While rare, memory allocation profiling can contain inaccurate counters
> > >>> if slab object extension vector allocation fails. That allocation might
> > >>> succeed later but prior to that, slab allocations that would have used
> > >>> that object extension vector will not be accounted for. To indicate
> > >>> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> > >>> output.
> > >>> Bump up /proc/allocinfo version to reflect change in the file format.
> > >>>
> > >>> Example output with invalid counters:
> > >>> allocinfo - version: 2.0
> > >>>           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
> > >>>           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
> > >>>          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
> > >>>           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
> > >>>           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
> > >>>           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
> > >>>           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
> > >>>      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >>>       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
> > >>>           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> > >>>
> > >>
> > >> Hi,
> > >> The changes may  break some client tools, mine included....
> > >> I don't mind adjusting my tools, but still
> > >> Is it acceptable  to change
> > >>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >> to
> > >>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create*
> > >>
> > >> The '+' sign make it still standout when view from a terminal, and client tools, not all of them though, might not need any changes.
> > >> And when client want to filter out inaccurate data items, it could be done by checking the tailing '*" of func name.
> > >
> > > I agree with David on this point. We already have monitoring tool built on top
> > > of this output across meta fleet. Ideally we would like to keep the format of
> > > of size and calls the same, even for future version, because adding a * will
> > > change the format from int to str, which leads to change over the regex parser
> > > many places.
> > >
> > > I think simply adding * to the end of function name or filename is sufficient
> > > as they are already str.
> > >
> >
> > Instead of:
> >
> > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> >
> > Could we do something like:
> >
> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)
> 
> If there is a postprocessing then this would break sometimes later
> when the function name is parsed, right? So IMO that just postpones
> the breakage.
> 
> >
> > This should hopefully not require any changes to the tools that are consuming this file.
> > I think it might be better to use "(inaccurate)" (without any space after function name) or
> > some other text instead of "+" or "*" to prevent breaking such tools. I dont think we need
> > to even increment allocinfo version number as well then?
> 
> I'm wondering if we add a new column at the end like this:
> 
> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> func:mce_device_create [inaccurate]
> 
> would that break the parsing tools?
> Well-designed parsers usually throw away additional fields which they
> don't know how to parse. WDYT?
> 

It would break the parse now as we count the number of string to decide if 
there is an optional module name or not. I don't think it is a big 
deal to fix though.

I think one more important thing is probably to reach a consensus on 
what format can be changed in the future, for example say, we can 
keep adding columns but not change the format the type of one column.
With such consensus in mind, it will be easier to design the parser. 
And I guess many companies will build parser upon this info for fleet-
wise collection.

> >
> > >>
> > >> (There would be some corner cases, for example, the '+' sign may not needed when the value reach a negative value if some underflow bug happened)
> > >>
> > >>
> > >> Thanks
> > >> David.
> > >>
> > >>
> > >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >>> ---
> > >>
> > >
> > > Thanks
> > > Pan
> >

Thanks
Pan

