Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD709CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18386B0088; Thu, 25 Jun 2026 09:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0EE6B008A; Thu, 25 Jun 2026 09:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5A66B0095; Thu, 25 Jun 2026 09:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 696C66B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:35:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA0DE1A011B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:35:19 +0000 (UTC)
X-FDA: 84918531558.01.3AF7F2A
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id E8A9C8000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:35:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QzY7QLc0;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782394518;
	b=Slt01AmfCGdcXvmJsPcMY7LDxQDX0dxqf2WzSoHvmCq/SHMR22XImF0fWSXj0Pvgv8gFiV
	gj2OrdUb8jLDgFnxCSvOeLLKQVY8AkwrT7gEz9YLoD/444P+BPMncLv70fYJf1yXO50Zwl
	aYhYrSGGdC5Me7mVkCVFzhMMNOVMuTw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782394518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8pz5eRLl5osDfg8s+rI8Lgc8KwmBuE9WN+Pu83DenE=;
	b=XatKZHAjUoBbtijzpxMB0IwcvhIKFbxJATpryJbiCfWKsHC5Mgh8NXsOxT/OU8PfA2c45V
	qfMVMpezuhFMKnI15YQ+j6zmzC3sQuGzGKFA1QZaiKefVxf48uA2TQiHt03Qq4riZpNNp1
	rEE7yOAE5Zb/FoGjVlnTmx1DLCODHug=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QzY7QLc0;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8dfdfe27ba0so29044476d6.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782394517; x=1782999317; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8pz5eRLl5osDfg8s+rI8Lgc8KwmBuE9WN+Pu83DenE=;
        b=QzY7QLc0keYNx5lB5MuWdTiSA0mkmC8PqZ2tNhDOHC7Hb1dG5EA+RddPn+TEOo59BP
         KTuJnNyaw4VTBqiiYxGgVY0DYeeQ+DTta+Ju5yadAc3esKzNgw291VIijQpbxhAw243P
         IUlfEJK57OHgHC+uP2572vV8f3R7CrmZsjKdHQmnkR6uSMHEPbnya/sn9ycc/oz+R+sy
         R9oiYioO3dQbbln2JUJVsVEbmIF+rkHC+FiecU55IXIqoMB2QbP544TCnfCmtsmt0EK4
         RcldZq48yqRDp9+gf/kWAIxtz3QGCQ1YNCPXG8lO0Z5ttpN+g+3NMosZ1ZApB0Bx+8ma
         aB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394517; x=1782999317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8pz5eRLl5osDfg8s+rI8Lgc8KwmBuE9WN+Pu83DenE=;
        b=UyMi1riFOs3ZkCWHS1jP+0ThlGd/1aJL0vKNwnXZf1Ts2nmGWddPlC/lW49XdpMfj7
         X7AqmjgayVkjRyat6sV1tH4wF/4nizNOY+noP06/n4rB9vZ0BTA1TQ1JMJuu24846oRP
         dCXnYEydNQIF4UxgvcSa1O9g8bVMIo2HlS98NRiePvqc3OVMwYsPpmtV7PdOi+Lqb+L9
         JHQMiO0tosuOzinDMwq093aci9z8yShuVRwKc1WkROre7j3zsU5cqagV0GX6y24b/Aar
         FBl1Zku4A2LPpEkDeWJmaPVB7lhV1alAozvqohQ0YFrYJl/T9bmTn+IT3oAZM2JhxhOJ
         eBxQ==
X-Gm-Message-State: AOJu0YwSBMgRb5qrGJaZKhAgbNPD56D0l7ypNNtT7TQUylBbu5peClK5
	tW62p2oOd842yASwGXCG62GFXq9JcxQWM9E6UmyoZKhDMubXXoaad+hrWrfScTJLhh8=
X-Gm-Gg: AfdE7ckYdkEJBPfYnq1dl44OErQ/QlAAx07Bv6qKbNacrs4vq3kq86HAA5sfHkiXDEq
	CVcs4Bq86KHh06Hgu5qa3KoQ61cPZ/Nki/PMClrTtmscgBajwxa6J84SESE+tX2tL08RSTXgIk8
	JVtKFf9tuuwkxQCDXsYwKe4CRpfQ6PjPeMlP8WpfFba/bK5+e1JuxvhzRM9eKWLJOnT2cTUAERl
	Q4h936FCceyn5fEANJCs42zhX5EiAK118FGCL3Y5FYDG18uVQGANauAmqIgUXYXqSrgDpCkXVx2
	F1asulsVJFrn0aMntslcEm3LDLYG6jUB4n6fyzICdVcxOWQwaSzov8eWSlfD3n6xHoz1OmOwDX/
	vjbfCdbVZaiWUoXHCf7eRSGSq21TbXtuhJwUw8SuEDTZ2iI4S2TE+YjR5TAhJucUwc3ht0P8W3Q
	cSwVgRGbLr2AZS7kBIMtvZwUhNxpbH+tBrt45q/b8PtXM5C6JmjWpuLMxJ9+9iYJLcWyC3
X-Received: by 2002:a05:6214:2686:b0:8cf:9bd:744 with SMTP id 6a1803df08f44-8e6d2ec8509mr48772246d6.12.1782394516856;
        Thu, 25 Jun 2026 06:35:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df81cde319sm183477356d6.31.2026.06.25.06.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:35:16 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:35:12 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <aj0ukAdiKRDEtYeN@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ztc9r74fnyhz6wyxfajr5r91tkq6aput
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8A9C8000C
X-HE-Tag: 1782394517-156875
X-HE-Meta: U2FsdGVkX19RWZnAO9SLRFfvqJOf5oYhAb1WtEQXSkpV0D1ykMYQ0HQfL6njpmGhhT9TEGisR2RY/cicCphmsuEsK90ZtUTL5hHD6KVAK/A+lsr/BsGZHQ+CtJOh4oKoZR7LuqKgaQMlCji5Vi4vn5MlkDtW8LoZNf+d6LzNpP3ZKvMoCTL/38BCaKSUK/bmJQ4Nh5wbZcGAOdmt02gOcO6/P37H2Hc8crHTNC2wwjcAozDUsyYdcIQdvANcUwP07is2VBtUsT1lw95CSd3c1N10yaVwETlEEP2tfXLfsUmUrx+B7eZqvUUxEePyEV74niU03OJnIZpn8DeEnQzUecjfDE5VUtXhpchA7IPlZcx3u+AxuegHGIr7h0ESu9QBeJ2wiSI9h/wD4g6O0J3X+4HSwtLvyZT4N6GmXMypxU/eQXn9VJNH7deYpKXXl3XRWx/K7kSUxiFLz/66tFbtYYjk+uZjfkE9TowmxY3wCHkrFkZOTaVLLBTlp7sz5t2EzE6qAJQ+uBjMleqcKq6VLdVFurq7wUQXZFVshAbUZzo/3RWO8MXoi07V6atGHQa8xUbuqYVTaRitbp8zesd+QlHHShBtQrt2e55SoUqbG06Xk9D2sf5Qgzdgze6OW/sIcafAgZ8FUD/FCCcPVPXS/gwwifTPbytplM+52GreiAnRBGC/UxjgSvgspEb/VcMtO7VA2XGMYcLYU1MDArSpubhHX1eMojfieeke9HCQYi+e39k4LkwrEtHGmAUa6Us1q7S1DqhNtfa2PrjLs4BM0tJ/ERXIMwRbhAobTAwzKKS9VuOWcpkWDepWShmXhOgEribLLuNzliXATzAcb1fXJIGFZwl56jgTOykxG+pWkxi7XfK31Ok/LNz6iDPrMloqIUbWeZUMwSOFALWb0aAZJZFzNFtMsJh+R0HPZke4ZkI+0TnZVGZyNfqtn/6qYFvTP5T8OpKgWQdOBRVxoMQ
 SJ4AUjs8
 bhstaIp7hKHOTRPhou6QrhcGs5qca3aMeCuu6ZdtyO7v+vBY671oBJmAf9Pz8mfH63NXPUqyFIFtSgBSWLH5mrxKsedZO02ZYnhFPfHergmPTrVcxzBcBl3MHUBPLnPzb3dS+TrQMXR+E+cVss/zVM+hu3fbVt+GGI2/9bvp6zVgeuHFyHxoe2AnmCChwpmYZ/O1VJg0gmTkqyJkxgaSSDLN+XbSktK9WsWiYwbuNEojtU3dTzqyhj+bklWQgnLxoCkRHSu/4yPeUlFWKbdurZdQjZK0YQ0KKJqWS0xmP0hbLiohSNYwfy+6m6lSp+NR/RzhCkeLbJAaPZYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:40:02AM +0200, David Hildenbrand (Arm) wrote:
> >  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
> >  drivers/base/memory.c                   |   9 +
> 
> Can we have this ...
> 
> >  drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
> >  include/linux/memory_hotplug.h          |   1 +
> > 
> 
> ... and this as a separate patch, please?
> 
> Nothing else jumped at me.
> 

ack

~Gregory

