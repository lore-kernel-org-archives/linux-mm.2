Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AFAC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9856B008A; Fri, 11 Sep 2026 13:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0D46B008C; Fri, 11 Sep 2026 13:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE1D6B009E; Fri, 11 Sep 2026 13:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 170FC6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:00:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A56ADA02F6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:00:20 +0000 (UTC)
X-FDA: 85202094600.04.761A432
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDFA2C0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:00:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HFaDaZnu;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwDk3fh+JvGyN78BSU6J48zvCwmsI7FUHYkydOLS1VI=;
	b=mFBDDbFV5KjqUdFanpt7zdRkEwAWwnYTfAlUTBqH0N9zc96raO6KNqABMzcbMRsNR/uwFK
	CaJwC0WJHY+Fh4uKgOR8cXaqqr6kEM1IRdYfmLYoSUEHR/y4Kf23/fMU4r1ojWPhvABqtB
	c/3ZJrFDciUzsxQaexBtQZkmTn59vvE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HFaDaZnu;
	spf=pass (imf22.hostedemail.com: domain of dmatlack@google.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146018;
	b=IoRStJH8bKaCYBQA43UO6lsxAFfS4Dpbla/wN2R2YEpCj/3PbClJttt6n7ZxL3GOex0NtJ
	hAJ+Fn4a5KSH+7vJ+UsQ/1TE57DxAuPABFzZS85pve/iNg46MBSe0Hcb0YpecnfcYaKPps
	UH+ddzVT66buR0usQi8Bl4Olpu9QVdA=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-43b7e186a0cso597819fac.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789146018; x=1789750818; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mwDk3fh+JvGyN78BSU6J48zvCwmsI7FUHYkydOLS1VI=;
        b=HFaDaZnuAOXVp17jndDK5xRo4DSVDZGvVeBS+ajV3cAzlzYE0EXFDAuE6crL8yGRRC
         9Z4n84ULqIt5OXwEf/Dt2W9A8NVEI+OY21ZnJ9Yzq+gMR7u31pqgBXmbTyMQZ1a0Vvj+
         l1qggd0fhQ2RIIpGocJWBn2zqZUc4JXJ0iG4UqCfFBeQCzNVUYFFQLFG89YAnkuKyfm6
         c5m8uY9KysKlwXNhMLc/Di5pi9zk/udVXnb3R5fpZ16jASH8sj9n9LEKUwUiERwtqBgE
         kR+AcVdr3Y/GSaBEPQvQh4bDGeQ/vSXWRQSOfz56kY6mIRC9oX4Rih2toDL53QsRov51
         Thhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146018; x=1789750818;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mwDk3fh+JvGyN78BSU6J48zvCwmsI7FUHYkydOLS1VI=;
        b=izK9QnS+g5UwkR6XpqrMW0SXYxIyyFdmWZIXxyNSK96XnOj8OwYMtI09/Xv361w3JN
         XePn6bjaSWaVdh9WTkMNnsM/4nwRJFNcIPAyd/jany4xmu/ZL5N3sJ/4DzaSFQtfPMUN
         YNFRF1mo7qvV+OZh9LM1Z/+Q0oNxPbJUrI9tePPe7+9xPwDGmNnNiED/zUp96YXAdofY
         NlPrETEtFm+ptTyjzpPGQVD/SnJITAudpeqcrt6wbowbfxuaaTfvelYthLGvFjJC2WQA
         LvzBsTrbtEWzg6a/q9bmKWrKNc77OGDgWHq332bmdQe2ys6fP4rT+0hkPD9AuqMj5OBE
         6yfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZ9hVlazlupShVuaqqlUXlAHoVKhE5liWK6XHorRfbfdHfc/PS9PYKpNm+T6rQr/UNLle6PhtHTw==@kvack.org
X-Gm-Message-State: AFuF++l+thVtP7jOsuXJhECLiCxBcnFLoCYQADQ1FqByPD2eVdBPF8CH
	euIxZi9zkYTkaJPHaUDtqq7nUIqEoPyl37a5tB2F6NdiykXmPaOHTd04nC0MK0IA2g==
X-Gm-Gg: AYBFou2Tv9QYsOPLwoANwLbD6ksnMFpK2sIINL7X3JYFhA0Ni8zKn9AZTNUDS86VD4q
	uh+6Qp1tQPAykRo13kqeTVYYtY26ntoRaf2N7YV0Ttr2wVmcZSFosNUfPl+OeHfwprNZYDhLPdt
	JgJfvp0FC5DnmZrQ/S0zQX9htd3kqGBcwJ9L+0GV7t0EUekjTTuuZ0WTELINyxzheTTp9JvaVrz
	v0rWCX839JxMeoMRbKUF/TShkLGiYlQdQEBRfTrzsV68cCzRaPaDnBeLLzttY78v0gwFmXZdYEu
	qFIvnXGPjbDw91pMGo6Al6NYArbAfyyb5rBmqKUfS6NNUscRIoOoCPMSV7a278eIsE1xa5FkeDQ
	zpE0DY2FBh/xtcjjb/J/y97h7Kevu+LYy2WnVo1vCYSBsPbmEqh97/9L4YyXv+yOvy25gNoykxZ
	XnttOJ79JE7ow44UTOx99XagoZwl9/5KQqhNgzZKmxm/TGk7jGzmuvqy20WmBadfcZmMjYF2VZ7
	FQQVf8+THcgtmQUPmoyZR6ASmZs+EkRfp9Qb6TP
X-Received: by 2002:a05:6870:7183:b0:475:a112:1275 with SMTP id 586e51a60fabf-47debded110mr3337322fac.34.1789146016740;
        Fri, 11 Sep 2026 10:00:16 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-47df8bd0284sm2467114fac.9.2026.09.11.10.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 10:00:14 -0700 (PDT)
Date: Fri, 11 Sep 2026 17:00:10 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <aqQzmvgILmU8F4TR@google.com>
References: <20260728221007.2098560-7-dmatlack@google.com>
 <20260910235126.GA367952@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910235126.GA367952@bhelgaas>
X-Rspam-User: 
X-Stat-Signature: pxbumbs84rh1rkomsc6ums8fod53tm8h
X-Rspamd-Queue-Id: CDFA2C0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789146018-661490
X-HE-Meta: U2FsdGVkX1+yudi0dViWEyYwNsV47U7d3Udb6sFy5W0Bx8oc8ttCXp13xXl9aHet9iZWMQc4qx2vnLvRsYZuYoH8Y7H0QNwYsVS5b/u7s4p9cHHrcWvF8vEGjSw0nMLODRN+snt+n/qo2rNVr9c/AM+nipswStNcxQXDw7tRpOBiHvJH5WZLke8NpIImsgkTr++2qOUAm90ZfuEJDO0mh4epnSX8gZw5rUg/vug/sDyGkuZR5rjB0dJKW7+uHHPRJAmARIgfTnBbf/n7PN3TAnxCfRfwwedaLCtb3HT0ThyR4a0tBS/aaodWwsWOPb02947J0Mc5gvXZAqaX44Xafu0DEcbJttwhzcqeuSvj2Gf7yxGUB+GO6dkExanCMwFiMOYgDtzqRRN6rgZS5k0VYFPmSs4lebah2i3/0whtZqLXhJmu6KrEBFoAejXOpSTWItpNuE/Y9C68OyfY/cDPLTVFxsBMvEqSZpFCaLHPpMPNkOzRVNlJrpvweBPdMPlmhJMEHQIRi7yuTh4qokTZvKL2dv/k6/0Qinz2PG/a/gvZAz2zw918z9SKqto8lkbUDEvjhBuZ4VqUdkS0M2mn7oHRQTR9ItD7oJ8QkU8QtedkCt+VCkddqUOmcFMyK52F3ugnyyIcgTwVQE701M9Tnew3bHfG6Gbdd122t9916eRUMkxQfBdcAbW2Ekc7J9p053Ie+l6pyfm7QYnuPJp+dVNfiYD3V9FV/jo2EHSpDC6z41CDu+ZX5q3AY387muVlB37TOPhTkeUUpYR5d0ZPmm50wKuHxpyjpZVyg84W/GzE5QqVhYr3M9BOLgcRkZAJSIglTLC8P81vfX/jTy8v8zHD/4hX6TnKzQAVUTBs3+VYvBMIPhJRxmcEvVK6DiWQSeHFwpPTOelSx+3T8GWaf7861Wg19zIkXer3iwU0SqsVtTuTrFd+n/IFak2BVEOUXNwT2N8user5Ui7+L0l
 SohhItM0
 yloWK2RyaWtlbX25FLeXqrHYkAGesrwadjE7eK87TwHREOm/LHl1DN8jdEvtDndp5X2I1a03a5nvmumMUJhUb3/4imYjBA/Ibs2XVUeFX16oi9mYggk3LagfYG+jFMlDMr2utwl28raHw9dQnk5yP4xqBSe9DhqE4eff6F9jd0sDmgKsjad2WNFuUDygT3enGyz8xp6d5atuk85J6c9rl1LONuFVdNl0P7OY9WYKi7ysS9q7YrJ3tw1bCPE2rF/8h8HbCPG9FUjUll1aUYV8a4QkAKFGILbBkDpNLkHzcIFXUNUVuhWuhvFgm90LQ9nzo1/0W76BXc9A/eHDqu3EGitFjm4teJjW3ES5qhb5cZfv/TGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> > When a PCI device is preserved across a Live Update, all of its upstream
> > bridges up to the root port must also be preserved. This enables the PCI
> > core and any drivers bound to the bridges to manage bridges correctly
> > across a Live Update.
> > 
> > Notably, this will be used in subsequent commits to ensure that
> > preserved devices can continue performing memory transactions without a
> > disruption or change in routing.
> > 
> > To preserve bridges, the PCI core tracks the number of downstream
> > devices preserved under each bridge using a reference count in struct
> > pci_dev_ser. This allows a bridge to remain preserved until all its
> > downstream preserved devices are unpreserved or finish their
> > participation in the Live Update.
> 
> This seems to hint that we're going to allow bridge reconfiguration in
> some cases, e.g., for hot-adds.  The simplest case is "leave config of
> all bridges the same", and I thought that was what the previous patch
> commit log said.
> 
> What's the benefit added by this patch?

It is used in the following patches:

 PCI: liveupdate: Adopt ACS controls in incoming preserved devices
 PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
 PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec

to preserve certain configuration on bridges that have downstream
endpoints that are being preserved. To support P2PDMA we will also have
to preserve bridge memory windows (future series).

If we are ok with applying those policies to all bridges on the system
whenever one or more endpoints anywhere on the system are being
preserved, then I agree we don't need this patch. But I thought it would
be cleaner to track things per-device.

