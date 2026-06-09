Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05ACFCD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9386B008C; Tue,  9 Jun 2026 11:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662C66B0092; Tue,  9 Jun 2026 11:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551B86B0093; Tue,  9 Jun 2026 11:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 458586B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:35:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F0AA1C2CDC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:35:52 +0000 (UTC)
X-FDA: 84860774544.28.9D24B2C
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C3E3180010
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:35:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ToVdkFO/";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMNVrJ+zylUZaoWsNGMkq8FYpb2q8Its7Sc70f0OoMM=;
	b=tiFo1HAhaDs04HqEpOpmGTTK2f1b+XFesHXGQLyCUXcSjg4ueBWYq7sc+nZKslkA/BlH68
	8I+alrKhTkgh7vcjvIo8IH0kYGO2cva0YL31ROoV1lPhv5d+0mVQ82KtEVS/TUNmfCvh/Y
	6Jg9GqLKmcTShSpbjma+pCVcimG0XPI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ToVdkFO/";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781019350;
	b=TCKCoL/EKxlUm9yxbeBgk/TtqW1sgF2GeCIBXu12ZVVSMLSWWOIqWeDudn2fY6/Q0INP74
	l979l1e9x7S2QM0JyN14o7VmJcQBw9GkvIAeq/J50ovzGe4ROrBZA/bj8j+lwDEnuvVDFw
	aBvt20B3+9ivdJcpjec9C5UJ6dfpKm4=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9156b74006aso411970585a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781019349; x=1781624149; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMNVrJ+zylUZaoWsNGMkq8FYpb2q8Its7Sc70f0OoMM=;
        b=ToVdkFO/j9BmN5+D6EEa9Wm/tNvEGe7uN9t/4JpYaZj8tQ6NbFI3hA9zemqPSuaqXQ
         1x3ip3dc7j3MUynLE2Wmz/MO1CxtI2bhV3mdPXKI/kgtbTR4KJqXoHgSDdwUvBeBzeCY
         dGF5e38sVvPS/exKwrVBIGrbBvdrX4hzm9kPuTmFp9TPHPVw5XLWLXZwgVaTBvso2fhU
         yhZpG+9dElqPavGbSdJnIRVj6so8c2RGBarzUrejh7rtZ3eh14dvZmOXdE4GOF+UvobF
         /Ne9KxQ6deaoZlTyVmHYXwmiouztNCuH+2pVIzi5LYztqEjv3g/TyJpoECLvEdCTd7QC
         OyiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019349; x=1781624149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMNVrJ+zylUZaoWsNGMkq8FYpb2q8Its7Sc70f0OoMM=;
        b=BBc/RPO+LxDG/3RuIb7iXtD5BlXr3hkdMH1ZcNtFhQaSZze5arS3g70nIJE21U2lN6
         QshHn6vIIp2kARgFkRs3el3M+kSs0cdI8q4EORy90eOk6yH/AiU5FLms3nHx/wZDho7v
         0bG/rFtyVUdBzhoIbNTr6mZf3Ni85aOiVsM3qVMXhc4y70ggpbAlgwl2+wl/3KGDqoDt
         4pjDzBWumvgU+GesbtpizHDrYEVMx8EuCPneZE7utfcC02uZEMSAp8Nd6xrnGOPKYZ6Q
         F4XgMguGRaVHFMS1VzpKH2lRxj+FTfSq9M4rnN3L1Y1HJJ6o+em5acSHJ080zE/09zhY
         NZdg==
X-Gm-Message-State: AOJu0Yxl7bIUfYgqmDQo+7v8N2a5Og3nKh9q8eJqj/7unaaIiYxDhscc
	zXbTxr5K6fB+j8doLMCgboY4SKwmxUN5zqQnoMLBe8/6JYxtzwj5dE/qJaySKd0QSPU=
X-Gm-Gg: Acq92OGSW9hCKAioksn4L6/rJ0PmK6o5muZe9E2gZ9D60rumjm7ybHqyI3D3dEiI/qF
	Fe+LgchKxOvRiscTv7WbaN0F622r2zhxM+NEfd66Ka56cpz13RChCxblR/+Q4/I84AkvHf48tar
	WgPyQDBhN5m/ncuNv1E7/xdfB4BycLI6K1ao9Jc8lyqBkLPYw24mvGMboXr1T6BbI7cOMcSYrvB
	EiI5xasYCS9Ggq4YI9cADo3ilKqdRM8yIOtlruDzhAyG7pX/sO3LGsLYle8vmoqIjGhZ0b0KYLY
	HZv4hIoNnx2iyodLlE/5pzgbjOwjyykW2UyTAXYYpYFMACHoPpjIbBS4BIOyOWyeIPqFLiZ9ZTZ
	YNLvvugjP/X8Q7Y6RPcfSWuogtjY2j+sX1sSCwk6L2hCgkVc+YxUtvKZ7wemh5h3Pu352tGbyer
	t+rSMAjRFIEhlEwLYMDDw21FXSjYvtNkNbwhuizYE/YvPaGMAwmOAAmzUbRbdYB2InsXUkU8XFL
	8lS+mxExoUxW3k+eg==
X-Received: by 2002:a05:620a:454b:b0:915:7732:ea7c with SMTP id af79cd13be357-915a9da3801mr3475555585a.43.1781019349028;
        Tue, 09 Jun 2026 08:35:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a3bf5f9sm2173658385a.35.2026.06.09.08.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:35:48 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:35:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Message-ID: <aigy0ut410TItkgB@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
 <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
X-Rspamd-Queue-Id: 3C3E3180010
X-Rspam-User: 
X-Stat-Signature: ffji8euetc55mu9qw8ayud8akjwckrgu
X-Rspamd-Server: rspam09
X-HE-Tag: 1781019350-75215
X-HE-Meta: U2FsdGVkX1+bkbXrHfGc3r+/6OfxW96W7wEQ1mrauCnEPOB4gaPoKSCgnwP5425eMRJj3CevJha9fqLiQLw0szmG8LWeNJfTu2eto4GrdqxP5WV6jzIsq2UKHPLcK7iNq787Q8f5JfuDwf3ZR0zpq4b2L7H/gOrr931LooVR/Sj58KjHLpEPU6x1e3/BFN95TVWIIIN4JBvYjxvBt8CsEEVVA4SyQ3XEkKd6wTyfhfLfNtJqQN6hZ7DnEF3zTnSc4Ha+h7CADiQWNiZ+E2lrrTT0M7IGTNLGSmhisybIK/LhfZhFQa+aUreDis2QGpD9mVl3MBmZR7XUOZJZEe2OnceTEIt+SD4mDWSvwXlHAH5KOydK8dvlhvGl7hnsWkJKBbof0o2ZEOoAcl5D60lxsn9mCyARI1KCvoJ3ImmoUxP9uZUpH/ZCZJ8alAcsffy7/ChUhbKBPZeYv6tdukLtKTocZeP5qB71LOofXIHvP/Tu2aoUbb7fImRPBhwfcUUjFJMYFes6GWAwm99Ygx03p4QD0SkyMqX3o9s2Tz5DUz9EvRl9ZF1wfmQ0Hse7SLM9fV6//U4U+PIsvXEi+AT8tHSn7lgYOmFx4PCczYV+maYpgZ0VK4HkIE1nQtRNjmNYs1zaljdUD6/gN1h+ya/+ZISFY79jMWPLPTdUTyc1Ad4l3Mz4CEBoZlE35W7mFfbjyswMd1PoNIq79K9U8PENRpzR3iq1MpaHcLzTRjhsp+7w7Q8jOjDIqDK0rD30AiK27V0mTOo56t9o/IX32+hQwbED08lSScd4gggJdhnxDgQ7ZQI46mIWymiWeC2knuArL1os+/0DnuD+Ty/ENvdiQqvnib0tO2I5ylK6Nz2ZUgf7yKvCwm9T1Kz1H1ZBDrJxQvra+MlhuMYIskhntsAYs+oTU3z6DOgjSEQTlejIrCFEubeJhs4nccgOALKHNWazxCnnwqzdMts+PK4Tha+
 Js39KUEi
 HLMPHBh3N7m6sKzGdY26tjYDtWcZ4K8EfSt3WH89Usp2CI6vZqINjb58SETXIV80yGfJ/D6luWXZI0zqP5XJwQrTuWWWXMVMkuVtd1GITp9l1EvnNkDL+VjMuJBAbYuEZmbIPJQdyE3scai+CumYHfDoI5xbjHnB7+uGySDcE7ZCLrtpFCp+Y2fmO4KF1ebgXpOhXdr/Kb07AOaEf9l0kIlyZ9A5t9y011myOE0v60/Axa0K7MrUheO/gCr+LFv3txMVEMUWN609/fObCC9P3ekkLEdZE58+fSXy/hM9oiH9R7IBsbm53dsiIxUeme7dgsmJE0RnRxAilUhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 12:26:07PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> 
> >  
> > +static int dax_kmem_parse_state(const char *buf)
> > +{
> > +	if (sysfs_streq(buf, "unplugged"))
> > +		return DAX_KMEM_UNPLUGGED;
> > +	if (sysfs_streq(buf, "online"))
> > +		return MMOP_ONLINE;
> > +	if (sysfs_streq(buf, "online_kernel"))
> > +		return MMOP_ONLINE_KERNEL;
> > +	if (sysfs_streq(buf, "online_movable"))
> > +		return MMOP_ONLINE_MOVABLE;
> > +	return -EINVAL;
> 
> Should we try making use of mhp_online_type_from_str()/online_type_to_str()
> [possibly a nicer exported function for the latter] to avoid duplicating this ...
> 

In patch 6 response i point out adding MMOP_UNPLUGGED

If we add MMOP_UNPLUGGED as a state that is only use by callers of
memory hotplug to represent the current state - but not as a valid input
to memory_hotplug.c - then we can simply this as you request.

Although we'll need to add a couple lines to memoryN/state parsing code
to disallow MMOP_UNPLUGGED as a valid input (otherwise you could
permanently unplug memory without the ability to get it back... unless
you want that?  Seems useless to me.)

~Gregory

