Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D9DACEFD01
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E86D6B0005; Tue,  6 Jan 2026 14:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996366B0092; Tue,  6 Jan 2026 14:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877C46B0093; Tue,  6 Jan 2026 14:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75BC56B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:49:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AFB3CFBEF
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:49:21 +0000 (UTC)
X-FDA: 84302578122.06.1BDFD11
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D183120011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:49:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0p91Y5X;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767728959; a=rsa-sha256;
	cv=none;
	b=r1vysuL7sYck2f6VDsj8A2U4fbXSp5NZdOEr7mrh0iaA0tPURGYBQCnj73b49MulhgVb8e
	HF5Gh1N1MsIhKL51lE72pn4lDOfaECDoQRKBdtdL7Fa+Wb7UchH3JhU9J3lBFW9JPc2rgM
	mYQKV/x5/0fBURQjSPpYrhu7pb4h08Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=a0p91Y5X;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767728959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHkRaP2tx80Uh6Mi6taIl9DuPGNq0u3ufZRpaBi3H/g=;
	b=zkn/+ODLYKM/51ZE9vtLRG1/DyUMvGuECuIO2YwHD9DSzK9SqHYJ79PSEYt6DbfjSFx0CK
	YwZ1Lx2UqjEo0a06oEiXfc8B3IlBwTm7NnZTXa4a9tSgvrkB9iJdXNo6QSCclEqjBIaZ+4
	iALpGgkjAEEsFW7TBf5E1LjKkWy0nBw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42e2e77f519so819621f8f.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 11:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767728957; x=1768333757; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHkRaP2tx80Uh6Mi6taIl9DuPGNq0u3ufZRpaBi3H/g=;
        b=a0p91Y5XYxzOR5bbEoCgkTveAy1Naw2R6UcpMA6MhRmmLODK+aDCqMQKYfXVV10BX9
         pumptWTMReZAwr+jtPUEq0e9ZccAFeu1k10dXGeIoAkRRW71D0agFkdGCeUnR02+52So
         FftQvcaSy7To6FT39U1IgsrojKD0JPQyTjba+c1Ceg4o+zSqpZXuG3xXR2gmzLYzWu4v
         JN14c65DTIc/XVKR+oP0QMV0iR7pDwxGl+KlyS2FXqqMSCD3728jmJz+MhSVNSgMLH16
         GTHxkec5LT1mT7+ZWHqNoxMqTc3ZSFGLA56I97R0b3ZsvBAeuXbuCeTFKBVdP5bUxbUZ
         Bv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728957; x=1768333757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rHkRaP2tx80Uh6Mi6taIl9DuPGNq0u3ufZRpaBi3H/g=;
        b=N6Np9m5lW+YASSJj+UwKZBZdYQvxQprZqqEKSF98fPZrtrup8xQGL9Ih83cOKPI9VL
         doNAVdqV1Z0joD/DZ8tBwSlWXFF5uyKbRZtXDhDH1+yL4B/MEKkgcBCZoi0h2lFBaAsX
         jLcSeH1gPPpBkIdbc25HLS7VG5eBga9B3dRkKD998x0JKgVSJTJZAqMUaXwoVLyNpyzP
         lUWT2XUVxBc58J8qyghYSgwjuhToLkQSFXSYQIyodefhXrfMJCzxwuXBGARStvNOuVUN
         Mg1Pd47Cx890WSw4KYR2ay/B8clLSucd35E8OTftmXQ4B8dbetarqHds3kW4v53s3gAl
         mZNg==
X-Gm-Message-State: AOJu0YxOJZ75CsTSEGZdflbLCeWQrwPUDy4HNqLoSaFJdcH3zyaa5MIE
	qcVGnXKPjbwhODvTFXvULfSKLTiF6wAZH3/xuYnkEpsPXFwnWu1xQv4Ht8OMXbG/GQM=
X-Gm-Gg: AY/fxX5bkq7eSrw9hXDpCrhM/N1Qr6a82QGjK9neDS6GeQCAHqHiac9cOxORGmye4vG
	aOMQraF/iN7Jc6VLPbRyZe/IAqjvO/M0aZnaPNmpJfD8KNj+a44JEC+gHX6l9s+6n6fScD5KmpR
	iAwp9hNx2TnmU/SorhPz2H4OMPjFY4Nov9zUQ/bS10yxZyzduNeG8EAO+clCF4uWiJIXSrihTPt
	H1PXAiW3d7hx3rYfN3jhHO/vzTq+wDUC15jKDTMVwpPF1smjT3hI9GDhsFOsC2yFDSzJrVoyYPO
	QpQtcejmHqPyl9WlbwENIKhon23mz4clANLK2xO9dIN+7ShGxvvwfrkn12ozn7pQXXryiFf6uWA
	77w1adIocF2lVEMLj1q4EWd//rHF2+XPZQcs2OIgOFNC2ASFpqMxPmb2GYBHfCz+W4U51AS34zV
	lioErHhtw9CE9PhKgFBwWYreYc
X-Google-Smtp-Source: AGHT+IF4JLpTosJ+ky8JQbfIvRxievBhMEnNPfm14TESXhXn5qIqhxbBa4jTREutDNhaOuZNhuKI+w==
X-Received: by 2002:a05:6000:290e:b0:430:f704:4da with SMTP id ffacd0b85a97d-432c37a74dfmr265600f8f.58.1767728957407;
        Tue, 06 Jan 2026 11:49:17 -0800 (PST)
Received: from localhost (109-81-93-164.rct.o2.cz. [109.81.93.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e175csm6163158f8f.14.2026.01.06.11.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 11:49:17 -0800 (PST)
Date: Tue, 6 Jan 2026 20:49:16 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@redhat.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV1nPG1BgBQDWkjE@tiehlicka>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka>
 <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 1D183120011
X-Stat-Signature: histi7fqzrx3zynsaktfhwdxe8w5a589
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767728958-161504
X-HE-Meta: U2FsdGVkX18u7k0i2xdv1Fi8SpAGTnSUEh3Ghz65F0UqV0Z+qXCAgCb1f18rRDh2c5H2JQW84h+8Gb+DtEXdkPmYwvXyAAbvxxBKGV7RHPnLvmsj3gOOTBk/55KiQJOJuG5N7ZdmduF0PkekrleSWaZhaBNfW6mVw64S5LMY9OmJdUa365MCcLJfWgQ+PAP6OjPFWK1PpjxyQCupPA4MAjSLrRyT3tSPZnLEiqQWvnd3rhvQdUGsWMTx3kr+0Xscq7kT0jwsR0i5P5wJxe3VkGC5t1PqMxe8gXx6Z3JOUz0Bd1MCtMCZ4EBDuNtYV1YZXO7OoDAOa8yvRogsip0xUtYbfp+KyAyWLBnNYz5DZoXDKeKyn79Z633vwsjj6iVgkOaNVTwm6iNUcv3jww+Fb1I3q2a45btcW8ecKXa8BEzKqzr8tGsgLmBM6xesQBEfzF+sn+Vxfpb4kSHx8pRNjzlRMxOVaIrhj8AdSzXrXt4qmz8hKgXh5O09IGTGv6sMPVwHILyxUiHpvQfZ1j2kgDYm3CBqZelFjDqWDyX0Hc8gwiCAlB660Np65dSKZBeQyP22dNtLcT43b85mxAHtkE8z9bm90afJMXK/5DY9W2jhU6iOyu/xDZIDHuWtCrrRQh3rgbEUB9X/xm4H945N8dd5cj3g6QgDrBsyGnKE7AbVTNVdZgvEbrxLvBLBMh7u2KbOER/5tUIWiWe28rDvmBy9XuyrzZVMdgCvTLMPq2wLrgi1ZR9CISDWc6pVkN9Gr5YFylxh5ISjodzcSYQ7WAxZk8IJVx0G0cEJvCqxqGPrnlqPsEkRUd5K8666azPmFpJMDTX3YEKfrPic49dnaMqP3UYgZt5Ku0SBvpoVT983mNHmc7Uyc/QR8jzSVbmwQJ0ZDRLob9wFGmW0eXb9WJMQmZVBKXaoGwaZY+J0pocduj/2CtFv1OibUnQ5JQ/p2pknGM1O+clgyHjcpNA
 tJAS1obv
 PA7AmZUi6DrfIa1kTgSQHx5Wd1wazI8IGtWG/loqkfofUURpjgnSvB/soQES8DaqMd4fPczV+dVoDnsmeS6wWnWMJ70PZYE99Kzad89OAh23CYS1Y4MhHal18LwoWXRxE1tUixy7/BMZ7ei14tWm1aWWvtj7AGrbLRd4x7iSu/fDpE00LjMkNPtS81YnnNtptCyWhKIxPo/xeqfWCRTRRrt0hcwPOIbBYHBQDqUq5wng3WQWyuD/5YoGVcBtvJepNStcMknAwVAaLErlorTWJRGEqHm8yJxowiEniZRS8I9nfw90IM9UFg8h51eGH0QRFpf5d7c7nEL2nqp/WYHjmf5qWd6YPQ8+Eo30w5FT5yuhnsdl/V/UypL8xBNsQcp9eeKE242CmtdNCPFQ+QeigBEwg9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 11:53:30, Gregory Price wrote:
> On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
> > On Mon 05-01-26 15:36:11, Gregory Price wrote:
> > > It was reported (LPC 2025) that userland services which monitor memory
> > > blocks can cause hot-unplug to fail permanently.
> > >
> > > This can occur when drivers attempt to hot-remove memory in two phases
> > > (offline, remove), while a userland service detects the memory offline
> > > and re-onlines the memory into a zone which may prevent removal.
> > 
> > Are there more details about this?
> 
> The details are with Hannes, I was just recapping what was described in
> his devmem talk at LPC ("To online or not online").

I know of policies to online newly added memory blocks but I am not
aware of policies to re-online something that has been made offline.
 
> > That being said, rather than movable_only, should we have a mask of
> > online types supported for the mem block?
> > 
> 
> I briefly considered this.  I went with this for RFC-v1 since it's
> fairly simple and because movable is really the only zone with hotplug
> guarantees (any other zone makes no hotplug guarantees).
> 
> It's also significantly more complex of a change for questionable value,
> but if people see this as the way to go i'll happily pivot to that.

Sure, I wouldn't push for more complexity just for the sake of a
theoretical extensibility. And I have to admit I have't tried to a quick
PoC to see how complex this could grow. I was hoping this could get into
a simple mask for online types with default MMOP_ONLINE_KERNEL|MMOP_ONLINE_MOVABLE
and special cases just choosing one of the two and zone_for_pfn_range
checking for the compatibility with the requested online type. But I do
appreciate there might be some obstacles on the way to achieve that.
-- 
Michal Hocko
SUSE Labs

