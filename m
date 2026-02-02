Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06C0E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112FC6B00BC; Mon,  2 Feb 2026 12:46:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0F66B00BF; Mon,  2 Feb 2026 12:46:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4656B00CD; Mon,  2 Feb 2026 12:46:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD2276B00BC
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:46:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9456DD456E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:46:30 +0000 (UTC)
X-FDA: 84400246140.22.574D8EA
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5564140004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:46:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PCgWJwib;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1wm0NexTqa+iJZbv1CobgpMNsP/JgzOw/JXCIX3sf8=;
	b=mvWikcLz58/ERrzOZcAB45Y2z7HVj+hz5+7vWPuFLwnI+PknKdmc+1+Y2Uk7mAjTeKc+wX
	85MfZXIwaGXWPkiYNSdaNg4ckYKtbOqofbu3d9xE3XhyL0aXdULmtktcP9kM+kttWNPA16
	uFmqtPEhFubA4h/L/ihPjGkY/C19P7E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PCgWJwib;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770054388; a=rsa-sha256;
	cv=none;
	b=IYv6xJ/0pw3nyVdqskCIFUA16kEut5/7v6UAH7hXgF5pqDWDMNHox9eYSR5qXX3z5fqI12
	RmG1H4JVS3g3ZoWxJB60lX0aTHXxHm7uWUGY4CTtlqgij1EXWTvXkEkLtrORHYTeoaDXJ+
	GXshhDUFCuPlAMN3G7axwgUUnR8zxAU=
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8c70ab3b5fcso649742385a.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770054388; x=1770659188; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1wm0NexTqa+iJZbv1CobgpMNsP/JgzOw/JXCIX3sf8=;
        b=PCgWJwibT919hbhjWNYnEV5ahDmdu9cmt9tP8qbSxVJ3I75Bzl/ARGZWwkEN3zSOUa
         UajrDuaKf8XoXX43OvqRUHBAiefSUGjtorYh4LrSKuDhf3H30WMO58wDr7K8Yrctmgww
         qCtLh3eO9s55v9AjFsAUUm4ZeCvVtXlyiTdG0sfHYkqRi6otha4SKy+vNaOkeAeZU4De
         w6zKJ3LO5qnhWJwP+fwOtQH/z5reIROBl+PJ33/wVzZIBOrIrOBCw7txnfAlvX1hYJLH
         NPEiR/WunMkjNTAnVeRePLNullG9pe7YMMaSWPA4wyEohZbCBUij5WMm+Uf9CODao0kc
         M6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054388; x=1770659188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1wm0NexTqa+iJZbv1CobgpMNsP/JgzOw/JXCIX3sf8=;
        b=lQa6l+aLy+XBdT2dDDQB9sXwxZrDwUx8xpbXbX5vDR9BItH6RLQCr4a3WjWCdC/Wr6
         rnbNc7qBMo4+EFxZUKtCw8mPgzkhmrvZtYXgI/P/hF4qYcdt97nDGbJOg/MraIWH2eYa
         xqBJ5X5581JaaQRMzHcZX/DfYnxLxm0LqlN5nqs/qUB9WZcwRRJv9V9K+B7TrHGTqjg0
         mjFPmMKKPVBwOkt1jDfHik8bVe1S0iiSZg02hdFqy2vCj/uizCFDancTm9zr51n6JdC6
         0U0GpTF01fyHdPWOaCBPWfKwgS/P1UdHUpUBkaZRukdmLTdwWDHtWtl2kTI/Q0zf+p4G
         wBSQ==
X-Gm-Message-State: AOJu0YwuAX8gJWRvj8POpclvh9uH6WQWKx1AovtxmuNESY+LQ/rPdsXJ
	0NfV/298wYBhRwZ5vFxA/3DOGj2d4h0Yaxuwglw+dgpVRgRJjwmqfAN8l350MnHo4iLASdThuKE
	9GhQpTU9d9g==
X-Gm-Gg: AZuq6aKlvSgqMtwNvzsJfKCUovbfXEhyAesVxzaFRtV9bTdhrJ2EDkT7tTomh0v427o
	MNwcn3EyYKE4JZ2p7H/PrAb35GOEdIK3B2WpdYM34iTPwlzkljHt5+0Ki4NhUcgrXJmtlgn1Dtr
	zDOVsEFO7X60eRFaudaI7wfXF1NIljXhmvDvUpgjXR7uerS6fB6vj7bOQicDcenZQB79FgEjwKH
	Jx0iQb93vW4XbzRdLn2/HX5PDEadpnsc2ADYYMh8f7mnSGPnDzmT8jmP/dCzR89jC4mkAfAfwfR
	h2rR8MKjwjHQQQClSebxEDfwwweQXjCVKMW1owqyZg2EK1csexzk2JHLOz0Pc6+XpHvtNK/OFg0
	fq06PaqXQAltdHITJpmqmCuRDbcHaezUF7uJWcokj4t/N1vSwFCSc/TOL7UvCFxTd55CbVBWyU3
	iusdrZhA6Wp+hzaB4jhoy0yRUN+ztPJYJNkHvOWSmgpMngxBZdcVAu1vLfzPFvn5Jw+dwOp6PD5
	JwuQ3Me
X-Received: by 2002:a05:6214:c8f:b0:888:4930:82aa with SMTP id 6a1803df08f44-894ea166512mr179211126d6.70.1770054387847;
        Mon, 02 Feb 2026 09:46:27 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d47e13sm1267680485a.45.2026.02.02.09.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:46:27 -0800 (PST)
Date: Mon, 2 Feb 2026 12:46:25 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH 1/9] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
Message-ID: <aYDi8bhxFnvMWl11@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-2-gourry@gourry.net>
 <20260202171029.00005e80@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202171029.00005e80@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C5564140004
X-Rspamd-Server: rspam07
X-Stat-Signature: p5ffcz6hd3pmeoqmhfah5t1tp8fsr511
X-HE-Tag: 1770054388-540714
X-HE-Meta: U2FsdGVkX19DArgVbFZfCAVBuTh2wNLHn5ZTo1x/kMh0yea6n71vOZ0TeLft+G5r89SUL/dvza50e5rD+q7RaScAKJYDED8GyVgo0HlQM8Zqi32ZMytz1zmZEIXJ7jewtHpIKEFRxo1ihdYrC5lzNj9FxYAxKobg+OqQEf6c7lE+GxTr5tTPOZM8O+j/wsGPTizEBcLtVRcGKraewtgdT4w+1bPSLCL4GXZ+4s5c3Sis+eunHYwMpAOagEkghk7jwdJe65G2UW21K3pjscE5DTioZvpij2v8EvWT2y4Pr9e0mdvk7AoTWs7U1KcJBNLeAan6eK4Lie92Ogar39blQqOxMnm4ePwE5mceNt4/CcV2VCRyTuWlVI+F+ncFpEzxvd9kuHrNEOQJmpnuqeA3ZkA50bOeovkMXFUdwbfsQh6p8fVlWrEAEuZH72UK121VDdwfxG7Bv+iTd//d0MAgbqoK2O+hWMygEYVWlUn/5Ii/9NCk4eJoYa/iXA6oGWctUVeqfMnz43o33PAsQlYWf8WJcmBIa+wZ359Bb3RP55RwJ4a9PVuJFso83Xpp8GLJm8mXrDuTSOQDw6bHUZ9eGBQueeOWnXXvS2OHQjS7kgTM1uyjc2Jzhwnm1oi4O08WYuXtI5D7zX71rPmiBsRvWF+W8nHRHdk1/lZ9AdMWT4yDpLcwyXLH3SkezUHrXeKtY0mp8idIvqREkfkBeY5SkXWpzJPhNcZS2BzPAW11yZiyDEV54GrnYQ9bIwK5ZBH48ZzTvJlI+i7SGRnn9s5MnJ4mUQuRfmgKkxHaTLovGarFPYbHbNRkmzLjYiTmAOXvjGirrAMRB8s89ky5uOVW2Vzc1ClsYRmkxkkDzcrj2zUBg+UbTng1+SW6RMhcL00OrouWPj2ZNBu06+acOKPlCvkCc/Wm0R2CGQGzkzWUko04jdavapEvDVTN72JL9adalFOz8y5ZuEgQLm+qbU4
 drhagqSd
 MYPz80QuwxcGZyRwzokBS6t6o9sTx2p3U1C4oBcpPE6O6t2AOVUC8MglOnPb/o5gprO2dgEczO5dxuKAMQTNf5khHhHu564PNe0Cp3771IU+HOdL7+GKIeEwYwO/pT1CUfFKsUXnCeM2GgcLqfzhHtDJIQHOkY+5S7YaWiYmZENm+kViB6+2MnL3osm0lTGsWu7IFjE72QJ1YShIH7B36BewoHxmFyLKJSNZIzW2PAw0ZupR6Aewm9mpm1AJSJ3UcZ/qfTzbgQEgP75P5M9MCtBNNerDSzCx66tLqK+mLcGMigQXt6MI4S+yOSC3xbK+wFJ1QA+otZRIYf26u/qYFBU/D8yW7A3BvYHbiNy6ynh4C3Wm0spb5DlcvVWgGuFf8bcYiHoL3PU22mRFmlVKtwOWPn0HP5hmTumuxW1/owKdzfQlNEnessopFP0MWTkaeAfx8goGwwlHrrTpRTRt+wHWmEA1DdRmwDzP/Dmg6iEr57TN7wOscpDv0nemmn7ZoWYxaPMi1TngBqtVpWUSjvCLs+SNmiWU4xC5J2d58e84ApURZVVK+CirJY2xuqPecsVm3/FLpTmA3VwUeSo8v+9JpYpLdMQ4CLEat
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 05:10:29PM +0000, Jonathan Cameron wrote:
> On Thu, 29 Jan 2026 16:04:34 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> > Modify online_memory_block() to accept the online type through its arg
> > parameter rather than calling mhp_get_default_online_type() internally.
> > This prepares for allowing callers to specify explicit online types.
> > 
> > Update the caller in add_memory_resource() to pass the default online
> > type via a local variable.
> > 
> > No functional change.
> > 
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Trivial comment inline. I don't really care either way.
> Pushing the policy up to the caller and ensuring it's explicitly constant
> for all the memory blocks (as opposed to relying on locks) seems sensible to me
> even without anything else.
> 
> >  
> >  	/* online pages if requested */
> > -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> > -		walk_memory_blocks(start, size, NULL, online_memory_block);
> > +	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
> > +		int online_type = mhp_get_default_online_type();
> 
> Maybe move the local variable outside the loop to avoid the double call.
> 

ack.  will update for next version w/ Ben's notes and the build fix.

Thanks!
~Gregory

