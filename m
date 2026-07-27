Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02929C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA236B008A; Mon, 27 Jul 2026 05:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C016B0096; Mon, 27 Jul 2026 05:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D7B6B0098; Mon, 27 Jul 2026 05:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 875C36B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:26:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDA3FA06BA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:26:46 +0000 (UTC)
X-FDA: 85034026812.20.C1B4FD0
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 29E694000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:26:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s+IA7mfp;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785144405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LY96VBCIVCWyS8BG6OUhwt1DEXbhg7+TrPUmrkQFJKM=;
	b=XoH9X2AVWeh6CGNFLNsEvqddbBppE2nuTDzZs/x7YbDMemHZssx1ju3JFvGA+cxqMAewG6
	L3FeeUO3YLfCTSxnTyj/i6Ai7Hy6RCOtUsgVt/YbKBDR36GoxWjr2NvJwGrxohmErr/bml
	xu3pPVRPGeJPGnu8qY5RItPe/8hZPrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785144405;
	b=W1a8O6CnnIgtvzTb48K+rl9mnd+qCiIqnjyOo6LXGpShsyIHmnCfMuvZsDPTv5HuQ4kWHN
	3qnHUx7mOe+1rwSV1nVwN0jv3mmstUZRoF+e1DtRXiior74OQy3dpDZYE9uCIq8Mmeczbp
	WN5DwYXuUR0KG3lS3BcYcCHBGXxgnGc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s+IA7mfp;
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39ca0a30148so23997541fa.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785144403; x=1785749203; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LY96VBCIVCWyS8BG6OUhwt1DEXbhg7+TrPUmrkQFJKM=;
        b=s+IA7mfpALNEdD1QnT+oIlkFX3Vd44uXXcfYaXy1nYOY4PCPxTKzERjEcFnFTlM5XT
         73HBy8sIC/Rp0Bgci+SzwoFAtiQrPOkdo7f8jb87CkC+T4DONI2Qj2mn3uFm6OLspcER
         RYYY+GEcGdtsRpRKvjHVGWsxMzPPmOGIymwEZ3SLt9XO8vK6vvlFssTM+I0bc1PAD2c/
         cJ6VettX0h+8LDNYvTuJCVufyzm/jkw1i+4iwCs0PVww2ABmC9YOvq0xCnQMou4E/2+p
         OLg60O/YMRQ2cqOg80lDYpWclbrN9qh5JAaqK0HbJHwoYWVBLl+ldmEC5Fw/JmJgQv/Q
         zHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785144403; x=1785749203;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LY96VBCIVCWyS8BG6OUhwt1DEXbhg7+TrPUmrkQFJKM=;
        b=EsMjvE5G9AO9Ajd3q2mHR7ZnLPa6imltq0W+2AIKtWBlNOlHi+YulWBsMBN48zcGni
         /WKrviREeL4pNxPtjcuptFxSmwUoXvqxDkqNQfFfsyR+OQ/2yaXfW13m8fUDuKGGAey/
         TaiZ3hT7pWWh8qyIaw7qRrrDc4NfXAnDJxHqYYP1WZ067iWoBfdQfv1/TUj9nRWapqwM
         X7bFu4qFucujsXVyp/VAJN62LEX01tWN6Eb4pD21bQj9EajdrewmezNQjtu3zDtr3P4A
         fIZJ9ZvblJSHbMhmFaS9+D/WnQWIq/5tWEfknijdJPAaj/FQkd3ARsKil6eMAbO2dMsE
         Cxew==
X-Forwarded-Encrypted: i=1; AHgh+Ro0/251Cm/ugbbrM2wcWMK4GHWkYA9LTJoPmAiUg+/wNOBcpKeKqoZMQCp+wdnrC/2rTFUFVwdnZQ==@kvack.org
X-Gm-Message-State: AOJu0YwnGtAxqQyLjsm8sF99GugilbHecLt+3zFhJQqje01dKRxgMyQy
	kD+sU/oeCMYx758b7w8AIuOyNllW9C0uWTYZZxL59SpzwP8EdaDim3FY
X-Gm-Gg: AR+sD11QzMjST/pEmhQSe2Y2mpPenh8ZRGDsz6MJwwugQ0DM+nAl8tECdzvQfXqvlfZ
	8+5Btk7UOyONnI/BlBjGcNn1Qjqljjqvpdkt8gRrza2esQ2EHRESgVhcgQDIOc8Qzxh/LaG6NdZ
	1hryLv2IEL9g4fvjoVBktqv2dzl19lAd6NZPxzDiKRou7BN2hc197EB/xAKteO/lmIgDuR4R6bK
	q0CEcG/rbMd8gm0MHlZVueBB4U8qK43RKU4ZKm+CQkCOvh8dap5CcE55SdL8hFWTBPeR0FN0oc9
	rmun30hnxIyCiU+A0tlWx2UXpm6EPgG2B43CJoPL58O+Y0a8a8qTT4MXyGM/WJ8hbXrk1t04Swd
	ICtvtOCaNFSQKr1GloJ7p3Ao17GSQsYbdxm1qAOxDyvkGK9Vrb4mnDg==
X-Received: by 2002:a05:651c:b22:b0:39b:1776:6577 with SMTP id 38308e7fff4ca-39f2886d316mr12710311fa.40.1785144403210;
        Mon, 27 Jul 2026 02:26:43 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f22173131sm12238271fa.2.2026.07.27.02.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 02:26:42 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 27 Jul 2026 11:26:41 +0200
To: Dev Jain <dev.jain@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, kees@kernel.org,
	akpm@linux-foundation.org, gustavoars@kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
Message-ID: <amckUdXO-7TtzhNg@milan>
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
 <amXldUo3LfIGs-zs@casper.infradead.org>
 <0a312983-3d63-4d60-8ff4-d53dcfff7819@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a312983-3d63-4d60-8ff4-d53dcfff7819@arm.com>
X-Stat-Signature: t8u6t8794uysxzxqpg9mcezeosub5js8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29E694000A
X-HE-Tag: 1785144405-428974
X-HE-Meta: U2FsdGVkX19iAWXw4fPqYc748Wfu/EILJk/XAhXQT4GKvMWPFSbQR1sJjTjiWwg5OjSqvNiKV8zh73i7KS5mQXeBWUardgG7OsVrtMqnhebh4Ws559OqcRWMbf3IZXjMelh2FHL5oy2KIDtGr7zePCf7Ex/wsILIAz4qa13GLn2D5ZQIY3iDNruC96ShYtjdc1lnVb55Ofb/gJVzrX0qoK279YBkZEbgYSLufYw9pSXhhHTZboR0aKrqgUHDreItfmefLKlW4cQ4Aiu+Vb2RnCcgXbusikA8+IlhqYb92Gd7+CIE0LLkI7II6ncF5I8a6QBGp9du8E4F7nD7TfpgJi0G3YFDaMOYpVswMdxReh3lN0NGdPv4we+u7d3VQRoz2+AlievPUwQtwmC5mtTbe8bMX43kQt+SuJhJ3pYSHOkZejYgX38GJCMUEvTMawGccDP81AqQNMXM9jUg3RKl4Or5peXUOsxpAcI3koD5X6EJUx5aSYayhu8iVx7JsZyw0usiR7pflB8r+IvPIagI55VQjjPqF+lEdVANOu2B4hF8kOyfVrs2U3JGa+1dWTJJ+e9LjbMmUlIe5JFaEFpdSWKCCU1eJFzW0X2cKfzt5DOmrJPhOpBQdS3T3FpV8AvD0v/UlH317jzx3B4oMkip7LPDuJNZwtayo4iQXSjiDDAOpjq7N3cAiaRnb/t3YGo810VrcBO4aAlfyUb8WXdaha5EDhJvWDzmgN4+pcKjF1AZ1JghQChRb+Zqf6HTHNW7uMwGTEtdm1Ywg1lzmiZKXI6ig/TajxOdlY8+ApV4t9CGrzIPOHt6ABIHD0pixOXqSTsThOqENgw/VmGCC1O10/Yo8luxM1XFU/IEHr+L9SBrdk0xkxI7HJCKOxJzWdz6fKSfSF9QI8oAwK0213XgasMpsnAviJO78OQSPCvcZAkzaUOH615QPPrX30sC+wlqr0NNpA3T+hpM8CP7my2
 +XYzm5Bh
 Q90ZIqN+zrT9J3s+jV/eU3d3aPjb+6j+wLNSKlrvDMKAm26ou4+as4hHqmJ/Lp4t4CpkD7tdJ0jnRzRiL8aXuwAyRhV34pcmkUKWLLyp/gtQIrHQ3fcXYzdEMocsu50dJFxwyOGz5knEky7Had2AT5zOFbkmPxSn0SQcRhTe8s3vpc9F/sg/YE20nciYoiNavPQNsuKuEDPylodubugJMNM9kiue3whoE62h+vnH2dI7veyZEGNGgDxbCSCfGkpZ2dq/hEc3lf3L5jAq8KHQ6ZXveJpoYhJl4jFNfL7tlDRY5nk6xI8MjUVMk7HEV9etDu5dzq8LAKgegZ6msiGXgJ2VyXZTQciMBn8l1nPFq1CrzWAMJWlI3AoITZI35o0+L5MjJ1gdY3elp+WgLTMtSQ8n194MRCmNAYAzXYkcY+XDpmkA8zn25LsC4M7xHlo32F59d+n8bWmnxYsu6FZ8eeSHzVmSMXzUQwU71aaMcUn6FKzCVpoIPdwQdMWSRhsCZ2IjQVw0pxfcOtBCXD4s/m+QzAVsQhtomO/wM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 12:33:49PM +0530, Dev Jain wrote:
> 
> 
> On 26/07/26 4:16 pm, Matthew Wilcox wrote:
> > On Sun, Jul 26, 2026 at 02:23:20PM +0530, Dev Jain wrote:
> >> On 22/07/26 7:59 pm, Dev Jain wrote:
> >>> The vmalloc allocator stores the actual allocation size inside the
> >>> vm_struct structure. We can use this bound in usercopy instead of the
> >>> page-aligned va_end to catch usercopy beyond the actual allocation size.
> >>>
> >>> For vmap, the requested_size field is always page-aligned since it maps a
> >>> certain number of pages. Same for vm_map_ram (alongwith, not even having
> >>> a vm_struct). So the check is only relevant for vmalloc mappings.
> >>>
> >>> Because there are early vm areas registered even before vmalloc_init,
> >>> requested_size may be zero. So also check whether the requested_size
> >>> is set.
> >>>
> >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >>> ---
> >>
> >> Sashiko:
> >>
> >> 1. "Does this locklessly access area->vm after find_vmap_area() has dropped
> >> the busy tree lock?
> >>
> >> If an out-of-bounds pointer falls into an adjacent vmap_area, and that
> >> adjacent area is concurrently freed by another thread, its vm_struct
> >> is freed. Additionally, when the vmap_area is moved to the free tree,
> >> area->vm (which shares a union with subtree_max_size) is overwritten
> >> with an integer size.
> >>
> >> Would dereferencing vm->flags later in this function cause a use-after-free
> >> or a wild pointer dereference?"
> >>
> >>
> >> I don't get it. So usercopy is checking OOB for an object but shouldn't
> >> assume the existence of that object while using it?
> >>
> >> It is a bug in the caller if someone does vfree() while usercopy is operating
> >> on the vmalloc object. I don't think usercopy should handle it. For example
> >> we don't handle it for slabs currently.
> > 
> > I think the question Sashiko is getting to is how we handle:
> > 
> > 	char *p = vmalloc();
> > 	copy_to_user(p - 4);
> 
> Thanks Willy, I completely misread Sashiko's point.
> 
> I think this is an existing problem? We are using area->va_end currently,
> so we can access freed memory.
> 
It is a bit mess here since now we need also take into account a
requested_size due to vrealloc. We have requested_size, nr_pages
and size in the vm_struct.
 
--
Uladzislau Rezki

