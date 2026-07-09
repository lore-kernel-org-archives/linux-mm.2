Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79EFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9379F6B0005; Thu,  9 Jul 2026 18:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1B66B0088; Thu,  9 Jul 2026 18:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2A06B008A; Thu,  9 Jul 2026 18:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2FA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:23:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBD411A02DD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:22:59 +0000 (UTC)
X-FDA: 84970664478.07.B753294
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25772100005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:22:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PK+54S25;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783635778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b50SGMSOIyssQj3plHocLLhkQW1pcBLVRqoMkWAD4k0=;
	b=eFKQNjJx5heh3NUrZXbQ5OzFo+vxl838M3wodsW4fqmunjmSQZT5Nlpmrj7j2JyYPBjpIG
	gm6KUHzF+x/yfwogdMQo9ooA7jaP0y8k76zuXDB3K7IFkbosrsIlGEjsIMQDaPvK3IBZWq
	c/BJ2Tio6XalcRENH+vPYddsoytCHrE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PK+54S25;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783635778;
	b=ng6BrrQ+iqvIvqMvyfGszFZmfKaNN46pqVUx6R+QneaEzZtQCwuLWPq9EKQdaA2s9Q9IO0
	Ivu14lXQ5eI6ym5NWe/jfWpScrBnw4Zmb0nDkIyUCXLNSW37rg7QW14nbNANht6mtVlCkp
	jg91/CnZuKCOxxFyt21VrD5dDrtk35Y=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2149571dso2171771cf.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 15:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783635777; x=1784240577; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b50SGMSOIyssQj3plHocLLhkQW1pcBLVRqoMkWAD4k0=;
        b=PK+54S25paHQxpc2tC1exMpm8FLpBBZIl5GE1EHj0kf7eD78fHbuTMh4B5etfOsqOu
         vbCCgxYWB4jTD/kWwIbyS6M1IH9dfuvFF38gcURMVMizgU4PfQBQ9jpbVOkZv327T3IX
         lW487wtjLVujjbaV6C0fE/K648kAQnGuKHH8h5vWjsDWUDrKbxf8HjW5IvDXJMDJ/D50
         ALtqVukLXQzbgSfq+MK/FT+ofE/nGbJp5KoOIHs/9gs8YR37YeE2TwPhvrGYiJDb82Za
         mIpVP9ZzBBmiMab2RWQHPWr8ON1TrjvqBS0B5mPdEOemRFwtjuIhY0GNlD35zbFKDKxN
         lorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783635777; x=1784240577;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b50SGMSOIyssQj3plHocLLhkQW1pcBLVRqoMkWAD4k0=;
        b=Xxjs05k8e3VezhFi+7RUaoipYdm3AsiDCLH5rHeujHFrQEEfIc0+r4b6ouTFQxW79W
         xkJEimxLBFCoTO+b5iYAwwjSWhixYjB0onrCxgM0phZCAErGyidwZDoOYoH7nPu+JXOz
         sOktQruixARPHg2tc4gzUStKaWO2KuZ8LlWfKCjY/JVVOYqLexhIruBZ4Mcm2C1zipOO
         7JQPLeerpoonwOJJcn2cvVFQemak2/RnkQzwZ+DqhHEGAOJUiluTlccdO0Cxf4aKX6BH
         WQ9KWo9L+3Nr5GXaMnuTc8K8sX8f41JtdoY8oHE+m41KEZTVdrpACyqxuuaVYQaNejFK
         OJ6w==
X-Gm-Message-State: AOJu0YzQ7kHj/Ahid374tiJHV8/SUsBPNSbzCJB1urFmulbDQ4zPlA5W
	y8qVTPYi0eU94geq7nwBwg204FAIgzCZbNYKkRv/qT5xZfaBpmvAECy6VEatCia2HUo=
X-Gm-Gg: AfdE7cmWvyaBRRinOwrCAfEnXRxoW1LuvBj0cUGDVXnJK1fyHNfKwjeJfgSG9kD7qVI
	h4rVh0c3KT9VaAc1wR5ODK6fLNn6ETnZpB46I/P1X1vL5d7NudX4jxI0HkYqs93KWYu98WUNckh
	X1tLgHSners8clC8EljUBKPR1htjr30iu1bqXCuy0EaMOo+M4YoP0zIc5iE/9+T3//iKclX66HO
	5dJerUnvSg8i3tBKG5zZRbL6C/9mV3RGeY0hp61iKi/OEB7HCWvg6xk1zPyXfHlK4p51Bv2H8nH
	kcHnOCqP6mOxEOJXYEiWu/kJvz7jWI7Cr9vK/dstIZ6/tPXe2ngxF9mui+Rr8e37tFyuyzhtfeL
	ZQz51ERc1uJGlIlspjyQrQ2+Gl8bydnWS2K/XIm1wHSeJiy2ZYsfOlwA6PNXmR2FdSzozqR5OWw
	D9iOC/dKJrKyWHKbwzI+64cr8Jb9TqXzuuWDki5v8GYdYfjFKi2oPf35XniZKHEYZjqsaX
X-Received: by 2002:ac8:5a02:0:b0:51a:8c97:fb91 with SMTP id d75a77b69052e-51c8b4bac92mr100050501cf.58.1783635777304;
        Thu, 09 Jul 2026 15:22:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caace31a4sm4283401cf.12.2026.07.09.15.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 15:22:56 -0700 (PDT)
Date: Thu, 9 Jul 2026 18:22:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <alAfOxnnYQxPW8DO@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6fd50351-93e0-4d65-960f-53dee655a786@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fd50351-93e0-4d65-960f-53dee655a786@intel.com>
X-Stat-Signature: nr1gedryptau9uengogde3qj6ah97dd3
X-Rspamd-Queue-Id: 25772100005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783635777-331588
X-HE-Meta: U2FsdGVkX1/jwuiSwFYAlYpctdXatIhzvg2AEw0cqsv/w+OOy4+NifXM67awBheRApCF4ucRLAZFBUcdEzf2pvDiaEewZEQjGFbfneZYDDe2/bbks1TbNxG00IRtIq/BNnbOYIaYpXRbxbFdC2gsTjVq9tqdyBAOFf3FG/HO9f8WEUXU1txt56Whp5goLlLQfU+Vhp3lAIdLvPBiMkF45xP2dprgIsilu64SHI7Rfcnbqbsu92MAmY8lQyFiuU4qgB2dlTlXOAYzPZ6pXRdm/JOZobPGNjNlsQHPQkIQ7gUuHS1psJgaym63QDcwicnq8LDw96/60sZWpEBrdp1ZnXERg4t+Sht8L05LU45zMKw329gX95lMrEYVtlXt/TD11qp6dVurJx8/P/XWVHG35Qa8r64fsO/1PWkMNTOEEjosuwaJ+MchqGk+KipRyEarT7whwhByzyBKkLwxkHMJPgQtWAeMpV1v/Fgp3kYyoQola8YI+KBxi2y2W0qzogE+lYbREKIpvF9jpZ9oXMOmvf/vSh5afOoqql6c7QRGwTK30h1PoA1TG6ntU4G8p44k1fTOdE8X4t7lINVbV/YMoAlsvcCiw4JIqV4zXiDo71IQAgImqcp7+Ve4AON5UigaxPeMQ1YvXhpohRRGbNsh+5Bcsn1wOScfg7Gp/hDn1Z3TojsWb/Uyadhf1Mm19zdLuv4w2rAa8bynpVLpXLuA6r2QK1kBz6fXR2cM6FfPkGjasy+Y5gM1VBgFGjOB64dFiRiYABMxHXcrdDUL8YsR/9JXxxfOKfGhbXbTLcI6yiFJ6MNRQ+rmTdFBX5Vxw+dbXXctWzn5WV8P+RWxZYT0Xc2YNqKLshByQogqCiuxIEDtQzVa0X23v7WIGIk9bZ/eOWjfpdTYf6Dqu8YM9DheUiaLPYtDEcWkWes8MhPYzlb/QRgO4Arm6WCxFsVXd/IfHRqU8s+TTozF6wiSRq9
 QXc/+asP
 hDyQxCh8LERoBlx/F3qbhuUrBMLCgo1anaa7eztG8Q7tevBA/Nn7qSdUsJIHT/KRt6vAuRrZQnbaOerylN9PJOBPOj2UwZvGsokyYdM0sfUJ6ZfxcZk5oDM4+Oo3Fg7KJFwSmmPkHl/vcstKokbNijX8Uk+1pCFeKuLHfP251FnmlChdMuSCpgDHWThEtQDJE2IBy2yUSe2LJ1/DKmAcstBwGL3lgRel0k+CVwjmwQCuEksWKGN3gkdweoNaufge3bDNUwCYsjcy2rQuE7nMCgwOMjbep5QrWvnNopqis9VZMjv80byuAhTADL4Nw5SxGODsap7rwlF01gfhkzBeYLYXU7XaLpr3MIwZoRzToDOacwqKOIyCGPNF52S1vsN09qgNSRoWB+LtdRqEWOY6Q0cl4Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 03:14:26PM -0700, Dave Jiang wrote:
> > diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> > index b34266bfae49..2dcad1e9dad0 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-dax
> > +++ b/Documentation/ABI/testing/sysfs-bus-dax
> > @@ -151,3 +151,29 @@ Description:
> >  		memmap_on_memory parameter for memory_hotplug. This is
> >  		typically set on the kernel command line -
> >  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> > +
> > +What:		/sys/bus/dax/devices/daxX.Y/state
> > +Date:		June, 2026
> > +KernelVersion:	v6.21
> 
> Kernel version a bit old :)
> 
> DJ
> 

It has been a hot second since i started this n_n;;;;

~Gregory

