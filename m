Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12973CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBDA6B0005; Fri, 12 Jun 2026 15:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4466B0088; Fri, 12 Jun 2026 15:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C97A6B008C; Fri, 12 Jun 2026 15:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 080456B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:08:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C8FAA01E5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:08:28 +0000 (UTC)
X-FDA: 84872196696.20.6EE7EFC
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD82B40010
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:08:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y6r7ytzO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781291306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s08faKqvDPkMJtxJMkDBvBUzs4ZbUBDPlDmo4vFtWCY=;
	b=qIRdO1IDWZ1K5dXbTzhqlWNiVDxS2i9eLR6bAE+DstwJ6ldZCMDizUa3Y46UygmGyG2LtX
	4D2LABXlucsbeoDEMPCQshJeSP3LBca+hwtEZjWiYyLZbR7bwSQ9MeBtmi+1uMwVr94FPl
	FWwEDaht8L4bkmzw1prbx5K1xDUUpro=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y6r7ytzO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781291306;
	b=NWam8BI5J7Ov4zsgq3R1/IXuSLj7hma9MgXpYCbN2Ay0BkaG5wf2WZ+m4+nt6RzjLX7qOB
	4WB9XDRCAqFwwpILClecHlfNizg8MZeumckWA4nsU9bt3N2WOhuhpCyO4aL0UtleP8TYpw
	piZByUm2Smn5mIpY1OS9BeXFVIroA64=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91587626ae1so151269785a.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781291306; x=1781896106; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s08faKqvDPkMJtxJMkDBvBUzs4ZbUBDPlDmo4vFtWCY=;
        b=Y6r7ytzOPrpOnvUGQiPFTOjI1IubpdGBhknGceKRu8HEXGgzUhbWll8sfcmzMgCFfS
         UzCiBN9qt/mwtajq6XycrStBp+z5tBaNpFAuyDBqO+d7DKJP5IOlhQa0jBlUm3vvbzmK
         WFj8lkWU/7KUD7X2NxsYlWBIJ66M+Tn+ojlfZyFwRTfgedhzryERdO35SqyDR9w8JnZP
         hhgW8w8bKiVyJMLgjTYekA1TLh1wfEtYAMZbtbH5ttrRJLsIbmFjyXQ5KUUVgF8UWvT7
         htTZxGDdQmROLK6wEN2K7jsrOgYRricvHqNpGw4q7eDaL3LdROn9SiK9nksOlsA8RlpM
         rSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781291306; x=1781896106;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s08faKqvDPkMJtxJMkDBvBUzs4ZbUBDPlDmo4vFtWCY=;
        b=ka58frYJJrOpTvc2zcDzcNlymOD4QbU2x7/4cteZNFGTca9bLhUtBhLFpu3ycZ/9oj
         rZJGvkbAVG9qp1rwNABP0bOeRoYYLa5GOi8edex4YpVMfRv6l5ROcYL5bL7o69tHOXt5
         Ecc7q2RAVLWEs/oyr0e3/8zFc/CWEifJTWnNSGzYNZm21qAEIkNXlfw2xXj++jiXewYf
         DKKtFGbqORHztAE7hzYU65ofAr/sUcmHJeYKEmo67LxKJ/nagFbmS2YVCpUxC50oEGP7
         zJOhPJx0+26m+Lyj9p4Eigd71PWmFiyHWjxcC74ZK2p86bLZLTMMGjK3kywdGhU/l9qL
         HV4w==
X-Forwarded-Encrypted: i=1; AFNElJ8+zrDZtfSA4+OzBJCcf2Eo/kOHyaRj0HLBFGm5Gob5GorPkg43Y6RyQ816aPpwU2kI24dobOTf2Q==@kvack.org
X-Gm-Message-State: AOJu0YxZvOICBmAXO12pciMUW2bxqWUTgmpp+lgQsj1FWHYv9jLe22XJ
	VAlgAw5dqm6rQZ3jWPhGnT9VcljWCghJu0Y+oYSQoIZI4qwyUnXH5V1UYYzGeuzbMK0=
X-Gm-Gg: Acq92OHHZbzGEroinYH49Jqi9FUzQPIByv1yANVgmyGSdTACNLrUWZab360qqsBczBw
	QzNwNsa66kNGYP8c6Rod73hdvMp11Tc6vEoIKWrOje2NdOGHawh60dcC229+bLrvnhj5UcDWT+h
	Kv6dQWvoSUIQ1fGjmooLNlijSTEPSVzTzgBDOzJomydwxTGt7WKqCrm0Z6rpfmMhlDpI1lO+X+c
	oB/IWpWwn0+950e6lxcDC/jRr2UkdNp7TAO8EvBdj13l9JpVlYmrdw8wW+cxMYRggI1RxyoRsjt
	uNXu9I7LEPfAmyZlQOyngNPEsEsTl7oPQwCN1hxeBo/eICCpRfNcWDvgrQ0Gk0ANE6j4sT39iNv
	I6zo8vK5eogkxnpnf4uUTOBUfPb2gNN6UuBnX73tB+UobiOkEgQm6BIt6wkNxYaKTYPEfbd2DAb
	gxbS6HJfw/E10DdmBaTAnjY6iXuDkIADAOmKw+MhJUcxHY5ltY7hE=
X-Received: by 2002:a05:620a:c45:b0:915:c858:7d42 with SMTP id af79cd13be357-9161bae70eamr627465485a.18.1781291305692;
        Fri, 12 Jun 2026 12:08:25 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f2d6a5sm291127785a.20.2026.06.12.12.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:08:25 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:08:23 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
	linux-doc@vger.kernel.org, jasonmiu@google.com, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, ran.xiaokai@zte.com.cn, kexec@lists.infradead.org, 
	graf@amazon.com, Logan Odell <loganodell@google.com>
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
Message-ID: <aixXuoCOCZZcBDci@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
 <aiVp5RlbWRz5VnPB@plex>
 <178091437240.1648214.10761111570005003901.b4-reply@b4>
 <aibYJvzQQnpoN6YW@plex>
 <2vxzo6hjss8z.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2vxzo6hjss8z.fsf@kernel.org>
X-Rspamd-Queue-Id: AD82B40010
X-Rspam-User: 
X-Stat-Signature: x6q58y6qo46cq3apdacjhzzq9nj1ga54
X-Rspamd-Server: rspam09
X-HE-Tag: 1781291306-93049
X-HE-Meta: U2FsdGVkX18ufd9Rbj8MPlmhz6ycZYKQ8ReyZ5zMushAh6KC6cM64kW1Xz/XZpCDTI7hwJrMwLx1goTkLXOgT1hIEudnk+8NnLNIawzBAEclte2lP5VQ749l6whP8eGjUHwaDAB4R20d/uddOVawV0BcH9m5mJ6gN91ChxGEZ5KSaTMWLXdxhJvjMJ7JY1C2DCWNGgs7a7oOH+d+qK8W7ZWXOUJG12jdh/QcpKYGKZ0tH5AIGGyWigLmMcNi7XXL44Fj2cUuzqX0Tr91QQl/qkF/XX4kpQD+nQOfAiW4bBgPKaJmcrnas1s+z5v0e2gO94qzAdYCtEgUvsB+9EHVFfMXeo2L3h9DTtXbeeiNqG72HkntoI+H7RSw6QxSLkocFJ6vlWgw8LT5tR9awmo1YoJylQVn2SdyokRHRvPnYtHpiuTT6Hc2YmHhlx++sskRvfgDBqbB/C3aSq2bCXp+6rWsf38pC1gjqMfucKQfja/BhKP+zWhR3YX0L28IhcrWPyV/fOJGN/GmPbafJriOjdY9i2n22N29UAytaFqkzdIrwelSUoi9ywmWnDkYUxL3jS9Jz/LK236eJqPUb0y0UHd2tMDzdPH7f8FqHnmR3ECyXuAukGpWwQY5Ff5XeN7UO38RmYfhco1whVD3N3RIN2UKtYE9K52Y8IRhD3UJpf50eyAwferwa4zOVBazNpbVtkOWljW/SIcZlilXP22J7X5u8zi2LMPfr+PLHmGuBTpqIBLYEqCCFig/dQ+Iflz9BUKkJ/satLfZBc0QWsM8FQQGaoM7fNHxgdI+S6xW4kTqPBzU8/H/23oENeORMUxNYcRM1xqjLBXl+xSPsPjnNj2PVEVCOTx0NKJQGcelCD4qigGSBF/AeMqgrg7E8q38ofBvVK/70bwJDKvXQY628VnxQm3I8RnjBaTxkkSD3iBlO/kbAeGvZM//lNVQz7tyVvfW8mRJXrm3vMR4LKR
 OUulm5t/
 yEQ36Q8ofoqCrGb/+2MMAtwegYJ7ha2bcO8Zt7pTP0jB1cDY2UvpdChaa8EBrJxvWC1WFQfxIN4EisEB6f2gN+OUOtjrRKPSNvTfdCzI4+SVQbt8DuSEP7p+Bh4MpHVs5l3SPYFLqBBJTTWmyMobBCVw2zRGoUV3T8rTN8uk0vnnaixamJMgYfxrNJkcSQEMgg0v6N4pZMWpsb10VGK+I+yj15f/pBICyPrzuAO1mpyzZyk1AG9H1qT/IEooLnH2L7T/NlitR132QTwrrLwHz1f2Ug4KRdIygAY9jz+GKGMFBFeD4ry7E3fd2zJHXwsnedb40EEOp6ofISQYLM/VpscmeIqcB/Fhz0uSnyvlkLPS+GHLvQC9njAuHkADMAsAI32WFNcYHg/kd9IUKqETLb7hLgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-09 16:28, Pratyush Yadav wrote:
> On Mon, Jun 08 2026, Pasha Tatashin wrote:
> 
> > On 06-08 13:26, Mike Rapoport wrote:
> >> On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
> >> > On 06-07 14:58, Mike Rapoport wrote:
> >> > 
> >> > > On Fri, 05 Jun 2026 03:32:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> [...]
> >> > External users only need to include the headers they actually use. For
> >> > example, LUO shouldn't have to pull vmalloc or radix tree KHO
> >> > declarations, and memfd does not need block.
> >> > 
> >> > From a maintenance point of view, it is much easier to catch ABI
> >> > changes when the file with the appropriate version has been changed,
> >> > and most likely the version of that file should be updated. If a single
> >> > header contains compatibility versions for several different data
> >> > structures, it is easier to miss the correct version update.
> >> 
> >> No matter in what files the definition lives, someone can forget to
> >> update version and we may miss it during review.
> 
> Perhaps we should have some tests (maybe with kunit?) that can catch
> this? If you change the format, the test fails. So you'd have to go and
> update the test, and at that point it should be more obvious that ABI
> version needs bumping.
> 
> [...]
> >> 
> >> Sorry I wasn't clear. I agree that kho_vmalloc, block and radix tree
> >> should have their own versioning rather than rely on global KHO version.
> >> 
> >> What I don't like in your proposal is mixing versioning of a component
> >> with its dependencies.
> >> 
> >> I think that versioning should be completely local to each component.
> >> LUO should not care about kho_block "on wire" layout. This should be
> >> encapsulated in kho_block.
> >
> > That is a fair point.
> >
> > As I mentioned in my previous reply, we can definitely look into making 
> > the version checking more modular. For example, each component could 
> > implement a standard compatibility-checking interface.
> >
> > These checks could run early in boot to determine whether each component 
> > is capable of accepting the incoming preserved data format.
> >
> > Whenever the component is later used by LUO, memfd, etc., we can query 
> > that cached status. This achieves four key benefits:
> >
> > 1. It avoids delaying the compatibility check to the actual time of data 
> > retrieval, which is too late to safely abort.
> >
> > 2. It prevents a local incompatibility from triggering a global kernel 
> > panic, allowing us to handle failures gracefully for just that specific 
> > component or session.
> 
> I think the right time to do the compatibility check is _before_ kexec.

Absolutely agree; however, that is a bigger effort than what I am 
attempting to do here. So, let's remove composite version strings and 
integer strings from this series altogether, and simply make it more 
granular. The versioning will be solved later once we are ready to 
address the pre-kexec compatibility checking.

> That is the only point where you can safely abort. Once you boot into
> the new kernel and discover you can't understand the passed data, you
> are in a bad spot already and should reboot. I don't think think you
> really can gracefully handle these failures.
> 
> For example, say you fail to understand the incoming PCI data. So you
> have no idea which devices are participating in live update and cannot
> correctly probe any of them. Which effectively means you cannot resume
> any of your guests since you have no idea how to restore their device
> state. The only path you are left with is to reboot. I haven't read the
> IOMMU series, but I imagine the same story applies there.
> 
> For a more benign example, let's assume one of your memfds that back VM
> memory fail to restore.
> 
> In this case, you can safely leak that memory and run the other guests,
> but at that point the host is in impaired state. You don't want to keep
> running it in this state. You likely either do a reboot, or if you feel
> more adventurous, you do another live update.
> 
> In either case, there is no "safely abort" after the kexec happens.
> 
> So I think our energy is better spent solving the versioning story
> _before_ kexec. After kexec I think it is perfectly fine to error out
> and panic or expect a reboot. You can't salvage much at that point
> anyway.
> 
> And I think how the versioning format looks also should be based on the
> design of this pre-kexec check, not the other way round.
> 
> >
> > 3. It keeps the local version local, as you suggested, so it is checked 
> > only by the consumers of that specific component.
> >
> > 4. It provides a clean path for backward compatibility, as components 
> > can individually decide whether they understand the incoming data 
> > format.
> >
> [...]
> >> 
> >> Actually FDT "compatible" handles versioning nicer than composite strings
> >> You can have
> >> 
> >> 	compatible="kho-v4", "vmalloc-v1", "radix-v1", "block-v2";
> >> 
> >> and check fdt_node_check_compatible("vmalloc-v1") for vmalloc and
> >> fdt_node_check_compatible("block-v2") for block.
> 
> I agree. Even if we don't use FDT, something more structured than
> composite strings would be nice to have.
> 
> >
> > That is actually very similar to what I am proposing—individual version 
> > tokens (which in my current series are concatenated into a composite 
> > compatibility string separated by ';').
> >
> > But let's not get too fixated on the composite string formatting. I 
> > actually really like what you are proposing: using integers for versions 
> > and having each registered component carry its own "NAME" and version 
> > number in the KHO FDT.
> 
> There is another nice thing about numbers that Logan (+cc) recently
> pointed out. You can tell which one is bigger.
> 
> At some point I think we will support multiple versions of a data
> structure to allow for upgrades. At that point, it will help to know
> which one is "newer". So if both kernel versions support version 3 and
> 4, you can use 4 to serialize.
> 
> This of course is harder to do with strings.
> 
> >
> >> And we wouldn't need to reimplement string parsing ;-)
> >> 
> >> But yeah, I do see value of making components versioning and KHO global
> >> versioning independent. I just don't like composite strings and I don't
> >> like mixing versioning with dependencies.
> >> 
> >> Since we are moving from FDT for the most things, version should become
> >> a number rather than a string and version compatibility should be
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

