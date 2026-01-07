Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB44D0D141
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA7D6B0092; Wed,  7 Jan 2026 12:19:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082E66B0096; Wed,  7 Jan 2026 12:19:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED13F6B0098; Wed,  7 Jan 2026 12:19:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC68C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:19:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9748FB9605
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:19:10 +0000 (UTC)
X-FDA: 84305828460.18.3A918B6
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9519C40002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:19:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="EmUk/+Az";
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767806348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZkL50mhnDpoFPWVVnY8H/NR1OQC1T5+YS9OD5apd4U=;
	b=GAR+GpdyJY4eLwzIlh1MspbnjeONUvTm3NWYQPVpD/sw7ZjAkuBeyt6Ode95gKKcNvULDY
	LubomaO8gb0zvKGY3ko3DcN53J1guU3klovI8oJcHEeBFsjTMHsz8KU0Eno/Icim87DrG2
	WxesHTwTK6xssctb5n3Fq0PkyCL8OvQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="EmUk/+Az";
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767806348; a=rsa-sha256;
	cv=none;
	b=67aEfFGTQ/RvGobvcJlTQiu2E3xBSacyeOgmkjvFPTd60rjT/iSyE/5kBHWkrGblHZmCS7
	CR44ofaVUiCn6JuU49baCEq3Kix3bWMwiw7oy7V+jg+ztQR+zIm6AHsLTreVWlz8SfiEdG
	scrukrfap+OEmuDGAs4Rnc0xMb5CsvE=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477563e28a3so8499965e9.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 09:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767806347; x=1768411147; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IZkL50mhnDpoFPWVVnY8H/NR1OQC1T5+YS9OD5apd4U=;
        b=EmUk/+Az9OTGlGzmsmAIpat6iRb60QgOgoP+uL0DPy4LQ9PJvmwbdeRlo0SFb9HUI9
         MU6Zo2dGcaT14BqsntTk2wWRzcPT0xp/zzzRwDbGZ7FP1pGu6yvNJfPXA8Jg/Vdzy9Uj
         +5CRVaADGzGbxQWLNTOTqem31L3M2RjQ4KJ/01E6dMKJEOfnZU/yfHxNDpu9Nd3eklbB
         OEIc84C2owFdoFTw4AcnZlYfdQL5PNnYWpTQ0B6eF+alS/zZXlgyfYFkKdGazTwVsYXo
         nGNMUbC4xI6nhDsMXWbhi9Ev3V5JwMU2+UTbcI5pdwWCpJmxDd0dv89ibT68ik3oPC77
         R9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806347; x=1768411147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZkL50mhnDpoFPWVVnY8H/NR1OQC1T5+YS9OD5apd4U=;
        b=Mgt7AZQTjRK5t66hJ6JKBZx3iv1duiUMbMc9nLHxBIBNaOUlqJo2S0uMiE5D26NKhb
         T1NfYTGcCKKnOhFqdJXx133/SW6ySRCsCxFXzZd4dRKdhNg1j5ZMtcmJxTyWRO9Dof9V
         //CKLRUqS7AJimB6Pep7+4bhAVlMBMZxLKkkmzU1CODZ5L4sZa5i4p6i7ht9HGH5U3HL
         Vxq9y60AiS70yq22i+eWuEszQlROI9rNHe45eSRaQ9nb2My+uV8T3/Nw1ItkTtgMsLFH
         gCLFrTQBXQCzMbxBGYyWoukPmj6TI5DN1ooaRa3ythfR4TOqxdthMGD3CUGVjwb6Z+3d
         X5NA==
X-Forwarded-Encrypted: i=1; AJvYcCVuVz8K7YV1JU3jZotoJzFT1tuhN3qMhn7LoTNKHPBpb92dNXa72eh57KU3E0NHfxZMO3YTbr444A==@kvack.org
X-Gm-Message-State: AOJu0Yx6qmWWmsnZ/xhUyI/xPB5endsQiT2JJHnqdQEQnIep3ZPETWO0
	eC3tH+exofQV39T/qVdzayAa2XXXDzn1K8elHTFvs1VYjX1zUtJ8fW8j5nwSpqJ3oPw=
X-Gm-Gg: AY/fxX6WJTXuwDtN0hg393TXG0jjw6YMkVF5qYAkDH/fpCZDcIWV/O52Ftj7/+MGN32
	sTHoDpVc4F7dD41sxjoL3OtGE+Lx+9NKNFbawTrBaBbiAtFRkHcfHBCLMIEd8pgaqYJsKSxaekm
	q4u18zo4rlUqSfQsPSmb5oVEwy5kshTdTAPx7tFhYeU+VL0AQoaKv3L6TocCibxCMg1mBsaqo0X
	PXWSWrzWQf3r17sRyvIYfnnjHkqgrNjaIUfFdmnx1HlwQtq2UO6kGKSiInalu1SyKNdByHX29CM
	Nhj9QJMj0yuJhYzvN777F1ZQeHto1VpbrkAE83mzoa/r8DkcXF2CwpqqMCqOWPcfE+x/Lw+qLBW
	TzjIVcSV0ovG0WiDm4TfHvD9UKXwJDSgv1zVDO07jdBmRswLc1Krj9AklW2a8JeqckRhanp2mtu
	owscuC0xomkVzmMC6XbT4I7UpV
X-Google-Smtp-Source: AGHT+IEllamjyhFAQ4tTTzQKWVVKUc5/yvNYMGDOMELkUlpSdZ6gI98lAOXxkJFjDQicynDzogPRDQ==
X-Received: by 2002:a05:600c:8b37:b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d84881c77mr38098245e9.18.1767806347146;
        Wed, 07 Jan 2026 09:19:07 -0800 (PST)
Received: from localhost (109-81-93-164.rct.o2.cz. [109.81.93.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0860f5sm11228980f8f.0.2026.01.07.09.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 09:19:06 -0800 (PST)
Date: Wed, 7 Jan 2026 18:19:05 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV6ViYWwA6OBdtMQ@tiehlicka>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka>
 <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
 <aV1nPG1BgBQDWkjE@tiehlicka>
 <39533aa8-ca78-41a8-b005-9202ce53e3ae@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39533aa8-ca78-41a8-b005-9202ce53e3ae@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9519C40002
X-Stat-Signature: axfmem9adwn9m37tw39jz7kmswbaba9b
X-Rspam-User: 
X-HE-Tag: 1767806348-561207
X-HE-Meta: U2FsdGVkX18UrwRclau6qBskh6zyqpP9dy71uc/abrMSnR4hF6+KEIGIlHqo3/cNWnSFX0jhMjQ2zHPX1MGIX4WI5v6hrDAFFtD9D4LSPtLrDWhuKxfAzUhgybMWnItMjN1sdVEXNZo2+hQK7LlkOsnx3Iti+xje04SmpkHYvYUDGIwAZCv2Zuifww8GUnOwEzycBjziyGWf00ZfWSVxMiZU/2RdSEpirAsKbsh40uct2SnJ+2ZEOI3sy61ejnHvq7/YlaLAaBdjLFvlzl0YDVohlZ7MF+Lp1oEyFpEbm88WMI8l1Vi6TfaRKlsW2MW0v/9ShgNCHLl1FArG4sHNcR+x8zZ+7WFPcJV65P4WN1RJtXTrwbpTuRm2f4DL90Udoe2xqwO1i3QCxoimYu9BRPoeEXehTTFkNZgJz+PPlvOANgmslKTgLeVklw9KBysDLrfFf2mWSdSz91q+qbap7Mpj5f/pDaebOOOLh20c9aqE95FJ33XJYCVRwNpSV58/ScMjKC4qqzsCGjdeGroby3DLzKHwWKmkEYLmd6ay+PXZHLcIkb2vrjnmL76LQi+XskBMvvlH/QR3Lm0U2CfgVnyewrSGGMFHkBoKAuplpCuPXGvBeuy/XaxjytJhrgeu7kR+OX656LspZuuJ/cLfStLMR1MCRUS/d1+etCr8oXt92MfgGR3to4YhnEmAT8LY54YaC9ErRUXJ3DEjzecrm/w1WllbgBVoTjqSycTY5yT/B0oPdhlGZpiEYufzzgLjv594NCEy9PHxSnwvmXAoTnDU4EoN9JYWXKPUtxltycMLmM4BZZ7H25WmVXEvdRrCsdJW19SlmM+bLolhFKE9Xoy7Xsy4H85aBKvlpIQc2p4t+fjL1Z+HdxyfQgrrkWmp52lUOWVHHXzpGq2F2i+3MHKQQ5GkieLLqmHMa2PLy468kcZMaIkXY3ebMslYX9QSfoWiaK9GMg+/vY2phDo
 cX1tpcVx
 8vLYOjV3Y9WZX5RIx2WVzY6AtZO42kz1reCdYxh4/paXlSmwwVw1tKhdQ2+e3JXfAqtv8Vo42ITxeYnQTJMLGdUrPQa4EuKHtBYUvIBoK8O+XduR8VsZSNeZYWY2K1gdi2EV8wtFOXoZIwnR/VHHX8r3w9fxayypZkiBvIKS32ay1Q/n+4HkPRSKvJZJpjI1/yZgwxN3j2MiNt9EVicdeQ5NqD+vtTefhR7GNzKI9MwPkMdMgRRCV1eXKbJZIQ40Q+nkdS3KY5Nu2SKZlati9JsTWgKXAs64EYJr1Mlr/QU8FBpePjTOv6wKZZN2XdNl9X4qLOsE1ySGQu8h/SXGGIs+CRCDivEHhBV3cvhepEDmvAi11z3qBscar9emtfzCntHSzuCo3AVdmvlOdt49OHQHCoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 07-01-26 16:09:34, David Hildenbrand wrote:
> On 1/6/26 20:49, Michal Hocko wrote:
> > On Tue 06-01-26 11:53:30, Gregory Price wrote:
> > > On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
> > > > On Mon 05-01-26 15:36:11, Gregory Price wrote:
> > > > > It was reported (LPC 2025) that userland services which monitor memory
> > > > > blocks can cause hot-unplug to fail permanently.
> > > > > 
> > > > > This can occur when drivers attempt to hot-remove memory in two phases
> > > > > (offline, remove), while a userland service detects the memory offline
> > > > > and re-onlines the memory into a zone which may prevent removal.
> > > > 
> > > > Are there more details about this?
> > > 
> > > The details are with Hannes, I was just recapping what was described in
> > > his devmem talk at LPC ("To online or not online").
> > 
> > I know of policies to online newly added memory blocks but I am not
> > aware of policies to re-online something that has been made offline.
> > > > That being said, rather than movable_only, should we have a mask of
> > > > online types supported for the mem block?
> > > > 
> > > 
> > > I briefly considered this.  I went with this for RFC-v1 since it's
> > > fairly simple and because movable is really the only zone with hotplug
> > > guarantees (any other zone makes no hotplug guarantees).
> > > 
> > > It's also significantly more complex of a change for questionable value,
> > > but if people see this as the way to go i'll happily pivot to that.
> > 
> > Sure, I wouldn't push for more complexity just for the sake of a
> > theoretical extensibility. And I have to admit I have't tried to a quick
> > PoC to see how complex this could grow. I was hoping this could get into
> > a simple mask for online types with default MMOP_ONLINE_KERNEL|MMOP_ONLINE_MOVABLE
> > and special cases just choosing one of the two and zone_for_pfn_range
> > checking for the compatibility with the requested online type. But I do
> > appreciate there might be some obstacles on the way to achieve that.
> 
> If we want to go down that path of failing onlining, we could likely do
> without any core-MM changes: dax can simply register a memory notifier and
> fail MEM_GOING_ONLINE of its memory with -EINVAL when it sees !ZONE_MOVABLE.
> 
> That works, because online_pages() does the move_pfn_range_to_zone() before
> calling MEM_GOING_ONLINE.

Yes, that makes sense as well and it seems rather elegand way to go
about that.

-- 
Michal Hocko
SUSE Labs

