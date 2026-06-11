Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29397CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350686B0093; Thu, 11 Jun 2026 10:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3016A6B0099; Thu, 11 Jun 2026 10:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217BC6B009B; Thu, 11 Jun 2026 10:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12E3C6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:04:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83D7D1A0678
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:04:07 +0000 (UTC)
X-FDA: 84867800934.18.0E2AAAA
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7529F140012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:04:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NkRgaMU4;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENvnRZyJjnEps3yiVgsX7HBb3e0UX6vr9hqD2coNcvo=;
	b=aZF7Cq9hpE9ADpODZrakYwkXNSgLuEIgHz8183cyKwcCxXiAhoX0DgLKZ4lHXSLRftx7Ot
	RzhZVFF3WZdv9zbj8NiiZFCDiMx887MTVDQPwlT0rdfn7oTai8jvt1KmLy/4+rL7S8FAV4
	YCSXpQwd6Eu+H0Z0sO3MR6x78/gbt1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186645;
	b=xJUPbn1DgUP+QbZwcxW22Ja+8ipmSCSA8uiCiv3xg6XYm9hzUg0gkQSukdwBnHjfVF0WE0
	t/SyWCyNqDihaOkKkaRORa15yesnGyxupe+ooHCeOuSqzKEadfSRyipYhqTW0AsOJHQWFu
	jXG+XljkNwL3OaYNz7e7/0B5ChYEfbw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NkRgaMU4;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-915aa0a9293so110684285a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781186644; x=1781791444; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENvnRZyJjnEps3yiVgsX7HBb3e0UX6vr9hqD2coNcvo=;
        b=NkRgaMU4EW+XvNPHHXfcJRHJPxHmh9b4Lrdf7Xheb38I/Pe7HiPXMxV80pHmauL4Cy
         cgFmhmitWO1iOoApjoGyqjxP8X20rCTcROdCSc5X1ktFoDSXBkFCCSe2JCRZelS20kqf
         RJcI/s+LZnPbuaIDmb0BVyVl8lNzx01aHVIP85Zr+mUpJy9uEVJt7IXe3fNLOk/xP/dT
         P0A35eY1sMLWSDCoRXAZ9mjO+v8BaX7KYRAm3rxb4oscnGP+Zkk++7aS3f7O06v1OutS
         ndR7VigwD1eze5bIbts33a1CVM8HZb/+U+ghY9HwOa7yTznbE60iv/QKqvp809YOBzWo
         962Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781186644; x=1781791444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENvnRZyJjnEps3yiVgsX7HBb3e0UX6vr9hqD2coNcvo=;
        b=XNPyBqEZN/PQ1N3adulS1KDOmu7ALdnyowIumeYQ6J+vDNIf+rudaRqgBc+Lg99rCM
         ZcQ8hjxGcFajSxxyu9Wa2S2ciA79nba+R+YmA5nkMKM1uVHYmT0YmEYIiWV5T+d+x2Mu
         FITHicSJYYyboRT9BHripvymxO95YwwMWUcZsk89DBZNRmfw05DCsgRzHRoOXFqHtO6v
         oQ+Ke2dmpdDSE+r8sYjYoIejaPIW26AE3SyvZUHl4vG1oMPLlTtRJqf+8ShJ22eZilai
         HKy39ty8qd1zJXE0kX3w3FbwnFaodedwMiAdr5yP8o4hAWMm4bM9wh8Z/LXQBWr2js5j
         wRtw==
X-Gm-Message-State: AOJu0YwF4BxJ98S38zNmp4R8pIjiG8JzREllGUegQapOg3s/9XkoabhY
	sftiSZ/VzeWKvk/UHrfeG2nQwZjHwe7rA+gT6hO+mnAVB4vYIQjff81t/dovEAWjxN8=
X-Gm-Gg: Acq92OHRt/fBWg43hOmfYgzwzR0VWtIKyOhrPyTz6Z1bXCBVgrkUQmHcgHiUAEId4Pw
	F7IqelOo88B+0/dVhHFf3WAMnJNCOfgMuM/VkHBclPWRytw/vyCAFE9C2vsTvYFdDvLlWl4twbO
	bSjJA+ZdawAPlSmE2CRIM+k76QRg8xFIrbalG0xmh+tsq+RXAaGjS7ThHItb24ZGzuVQEpCct+v
	rUan6a19Hkjj0mkXH9r45uy+rP/nRoeC9ycBCEpYBzR0UACnTuOdnjoXV4VsnwTKJuM0LcU1Vmk
	Ix+UpjtEk+0hBadQT7lt8eHF630FnQFm4UQ/d28GImkQ2PuPSCK9RiYyHFhkpyO19MC0jPJU+ME
	KRpr5VsBzxhYke06ftLQGCSBe4dg5hy3ivbVLNQRol6gjPZENrMPMG7wU450nLiQBow4p/yrHd8
	zkHPtnyLiowkaSa+/melhK9/wiYSfiYo+51oijgsgPSl7MAT8R9ZLbFD3Qap/542NxvFZF4tH22
	3QzwATLdkb0czzg0w==
X-Received: by 2002:a05:620a:2728:b0:915:9fde:9da3 with SMTP id af79cd13be357-9160ade2a98mr334272485a.27.1781186644129;
        Thu, 11 Jun 2026 07:04:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160aca4293sm196905585a.14.2026.06.11.07.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 07:04:03 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:04:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com, corbet@lwn.net,
	skhan@linuxfoundation.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com, rafael@kernel.org,
	lenb@kernel.org, gregkh@linuxfoundation.org, dakr@kernel.org,
	akpm@linux-foundation.org, rdunlap@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, kuba@kernel.org, ebiggers@kernel.org,
	lirongqing@baidu.com, paulmck@kernel.org, dave.jiang@intel.com,
	jic23@kernel.org, xueshuai@linux.alibaba.com, kai.huang@intel.com
Subject: Re: [RFC PATCH 1/3] mm/numa: add exclusive node pool and
 numa=standby boot parameter
Message-ID: <airAUSrNjbSEwuti@gourry-fedora-PF4VCD3F>
References: <20260610014517.253609-1-gourry@gourry.net>
 <20260610014517.253609-2-gourry@gourry.net>
 <aip5IWmxg9CWg8hQ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aip5IWmxg9CWg8hQ@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7529F140012
X-Stat-Signature: kd8jyga5ynoouyztr81r1bitkbnec1qs
X-HE-Tag: 1781186645-625417
X-HE-Meta: U2FsdGVkX18fUvvo16m87qHLojWZHGdFkevjJ0HAUIBMPkRo/AO/cxFltghMaLJpJLGYwUv4gHshIauZVlTA2ilOBfKiXWjMQdmp+4E0LBjorRiEduTyHDgQU4IlPceiFRO5motBbihVHehsE8GdQ1xQV7JH2f99SJJXwWZk7+RbUBAEEY0MDVqb4t0geZrq4ltV7b/RbILOrmlEEHoPxBhjAX1HPVwSmwtd1Drve1NmL6EprwKRbJkbU66aF3G31xkN/z2apDT4X4Z3Y6BTn0WW14tCOp78WrDZ2nqNS+vog2o8LIaE6z3xDz9bkDs0q8phyBr/uRV3dSKmkz7/X4q5zpKJI5TmIVzEAzSzIBAt4oRDIMDBECrFjtdPWqgpANuebqhZarbERTu+VPwjC+321/kMGZ5GrxBpyet/5SbEZMi/hLcdGKsfdG+JKwptqJBB/e7hCmIHq8beEGjL2/JO/usxSM5iZRFx0W0IU4nDeYPGMQG//dohRxWRqGuUIn59TAgL5fMc3GWrJJwcIIT1bYMWBmO792pL1LJ8HSgUPFKMg+JUUY4UlArsyVlKK7/vaDOWvsaJgkY+EAz6Hl3z5Bae3uyJv11SDuWXU0UPxU7kHkbYfV0M4YirGy8nhpi2qcqrd4hL9tT/P2FukvlYMwpp8hMOWQfnsS4a8eZBLooDICcLPSaGXVPthLZdBc5G4P0CKz++VN+l0bqHfF4i/e/cWg76ClOGFUWK6tSrjb2/7BiCe17aO4/E1IDrop/md/ZTcJmGevNDWfggGAHydqQxaRFlxHj40h583INWNLiXaU0uSE9uNQ0AqX3WR2QmjUrKH8w+s5Wpf65+dH4YGyECZ/v7ZgpecCx9UKyDlmwIKnJyCHwxWM6n9UYmLzEM6QwmBn9MC7nNw3pbQyi3ni6w1fKO9NJgb17hInlI1KqAmE+jAWp6ztIzCAERj69NHaGhLyj4h1WuGHS
 btxSDsHy
 Y9rWZ6H1So4rDMiM7/e53DioFUpH88JrxPmxYCu9atcyBegNmXssu1RIRJSXwDpJw9AiT/dqVj0s9/yG4lbI5XOSUYXVISS0nqszQ1TSMWgdPDJD2PcKcGTksSshEl1fB9xCTwm5HSk1hV+WWVzOJfD1741/2urL/2U7oG/7nxcRliUQC/Cgfh+O8/j1qEYc+O16N1TEoSC2Kj/a86xqUiuO4xBxO7jp5LyE8FM8V7EC4pehU81sxmTZmaKBM0e3WzSAOUaXgX7lWRM/9AjEJUaY8YU87ZnuvIg3xp4jl6WWb2FhHNB8+7gUQAGg9NcW2yr+pu66BnxrLUcOgefWAGYnPhatyBlZ8n8ehdjUl7KgvlTVW6cebSPtk0wMTm+2cgRzHwAx/QQG1kv1ufHFstCSfJJ4D+6ycEv7i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:00:17PM +0300, Mike Rapoport wrote:
> > 1) Can we do dynamic addition of nodes?
> > 
> >    Not Trivially
> > 
> >    Some services utilize num_possible_nodes() as a static value to
> >    calculate the amount of resources to use at runtime (bpf, md/raid5).
> > 
> >    Example: futex_init uses num_possible_nodes() as part of its
> >             hashsize calculation during __init.
> 
> AFAIU, we don't add the additional nodes for generic hotplug memory but
> rather for exclusive use of by drivers/applications that are aware of these
> nodes.

The intent is to use for "non-generic" hotplug (see the whole private
node series [1]), which would eventually still use the hotplug mechanism
just not for generic memory.

[1] https://lore.kernel.org/linux-mm/20260222084842.1824063-1-gourry@gourry.net/

> Wouldn't adding them to possible nodes actually skew the calculation of the
> resources by the services utilizing num_possible_nodes()?
> 
> With the futex_init() example, won't be hashsize scaled down two much
> because we've added these special nodes to the possible mask?
>

The result is the same as BIOS reserving nodes with PXM entries that
don't get used.  The CXL ACPI Tables do this for CXL Fixed Memory
Windows that may never be hotplugged.

So really i think you're pointing out that futex_init() here probably
shouldn't be using num_possible_nodes?

~Gregory

