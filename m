Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12593CEFCE6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF37A6B008A; Tue,  6 Jan 2026 13:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB8A6B0092; Tue,  6 Jan 2026 13:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA7A6B0093; Tue,  6 Jan 2026 13:07:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C05F6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:07:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51DA38C4AB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:07:35 +0000 (UTC)
X-FDA: 84302321670.22.92E1AF1
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D65BC0019
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:07:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GHpnGc1j;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767722853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9laVuKjYDSqLAjje1jBZcztaW2hTq+bS4g/OEUzif0=;
	b=cSNXew/8Vy1f2CkUnMknEmG/+CBIKEtK9mbkQLriRSu2NA/G3+/2UW72A7VMH2luPE628+
	bEPCCghE2MIulT8qUAd76wFr8E3gB1E0qw6kGNsBViIZ/tkfU7H81jnQX2Fz/BSpoOh28V
	zZE96EQvUKY8RoDWZTGV9UcSw0dykT4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GHpnGc1j;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767722853; a=rsa-sha256;
	cv=none;
	b=1ZScdSl8ecRkzE0LIPTyCVeD6Jx0Nh6co7Xplic3mS9+9bEKqF9hgp3szsy8sEDLeJgVJg
	5L9Wv2/UdosndOZy/6NYqtuWis/a1JTBsM5YQ8qUXKI36LHXFAtAhx39G2KJSIO8Z94o2D
	HKOabqZ/vUnzvmaFB+89Rf+0SBRzSG8=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a367a1dbbso16816306d6.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 10:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767722852; x=1768327652; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J9laVuKjYDSqLAjje1jBZcztaW2hTq+bS4g/OEUzif0=;
        b=GHpnGc1jZMGMSRYPgXllUqeO+v7C3yCrrF540SnC+mzvkGdlYUXD9Js5oQP0f/OKR4
         YJG1t6hC8+5BxgLXJysqOuOqglTQ0zqkKaT148a7bz6DklH5hEn8TYZvTIAeYl9HNKVD
         /a/NgtS6Boog0pcrZPpFLRcQTXOTk1zE4uI91mRx4UL3cvBvhKYhHSMGxK8sbVS5rfN4
         CP11d88l3tdQM5miHpYXBuucb6xYFCnKZBL6JvPt781I61AY+eQydI40pscBkb04HdoP
         SldLmuo3VBm3JnpQyc9qHM7kB9x1oFAhGSoMg4Qt487prjzSDM0eRioa4ECa7FqBLfpF
         5HGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767722852; x=1768327652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9laVuKjYDSqLAjje1jBZcztaW2hTq+bS4g/OEUzif0=;
        b=Hkm00G/XertYuXTYmYuFYeYbvvQ77Fh6J/wdhvdSJ0JcXpbfsKthW0sbIC7jO32kVd
         kOaLT2JRGET74IeYyU/OwYRep9zytvGy6rtPT/YNWxJmc7aaXd9+9QA0XWNjTF+MuFF3
         YTHZekNsGaQUDyAla3ogVtZ1/8BiAnQ9yfsgAyEkLwBqFvY4GKVs2ZUZYLx4iZBsAVf1
         lFWTE2knjyoP383QIUfs44WdF4SU1VZIowRHKPDwt8uXeszCM8VmlTpXMxaxNsG/W2Yy
         ZTUfAGZaG9/Lg6ZA2P4Q5kcoILj5ik2n97gqr+R/6lOhH4CTRpgJwkkrdjD+RUsY+Uy8
         gs9A==
X-Gm-Message-State: AOJu0Yz+SN9b49owdhfh2MhMmKCVq7DCKxpT66CknFFTQeLyP4zHoq3Q
	v1orxooIRGiyhqREotKNqWQVHK2gpoK43Esu5tWAjFwQLagQsJdJ0AmmEzkdGrm0HjQ=
X-Gm-Gg: AY/fxX6V5X9Ho3I4yB9S9xQg1Lt0YVBIi8goUHbb/IzK0FZgge+KKlQtKhYkYHC4tqH
	9L5YMo6VzsJelGDUrA7HB4dCwZLBUs0lV6URjNvwYPgSaOPTr3dzORvjI5/6ZRlW/57xc2PyU/F
	l1dlYbHh9MDgyJgmPttr1QGfe7ZH8Re8+4+OWCpsWKlX8tyxDoMF+Q4ZZAJtT3HtB0zDrAjOfoI
	+46FsJDErMlPik9lAKVmkwieCuokwG10c6PZJ7zeI7HaAX7yDgcHgK8b4sZRSgz4yFXQzDYTRoB
	42F9yYpzhLg+17qSX2I/39yUk3hkxDd45W6ewHKvmyDKbrjelvaUt+lxaSkWMkl6dFJrTOFWytc
	GPycRw2uH8fDN9h9skXr3MOK13wmcjFNdsTgKtlm314XDopkCsdrDaO/LHWaSLcd/S2oDqWPXqD
	9xniantkFJyNbOyer94tfDhFiv+CYa9tdRyFOo3GxDgFeGyyTYia0HhnXhSBw4FFeVFQ31PtpvW
	TpFGEZ3
X-Google-Smtp-Source: AGHT+IHmu9VTvtAeFwjCxaomaQKd0bZd4wIlSSTmE655IttQAEneagYSSt/nFbvLMBMJNomeQHn5pg==
X-Received: by 2002:a05:6214:19ed:b0:882:4e6c:5fce with SMTP id 6a1803df08f44-89075ee323fmr52661036d6.59.1767722852452;
        Tue, 06 Jan 2026 10:07:32 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770ce659sm17717226d6.10.2026.01.06.10.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 10:07:32 -0800 (PST)
Date: Tue, 6 Jan 2026 13:06:57 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, hare@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D65BC0019
X-Stat-Signature: r8nyra4sxo5negeco55pmdr3efbkgbc1
X-HE-Tag: 1767722853-838026
X-HE-Meta: U2FsdGVkX1/IiZQwcxZEEfQbBXztyMHB7/6CHxdtGTDOwqt0ebvKWAPRHNiYLrcI3LLEPgewpZ2s64Sa8IhRnjux7Wk+536yackJ1eyTcn3hreHNt2s/1vQ0AzL+T4E9hAUwoLT3OL6dgiGrGxsmqe2YvuqcJE+o4BSK9dz+EwS6XUD6wvVl6GgQfLx+PqoNCagOZzXo4nsvzxJlo+OCsdVfYtYC6kFJcLuKSYd2NvTsBbhM1TDt2+UpWCmaqKN0BzoelwZFFBzr5eKizj7jqJgEeNiVz8ytKY0VgKsFem2Nz4xL45gEl2YZvd9g5DX3s2rQrGLNY+bApyzTz9jgn/2NFvjb5O9lPPYnTe++clZY7udXPLfA1Set9KUOkhDKY9mZagjyL95awuGSYTtFa/3X9w/eyeK1q0dsQkDyrkDdTT8+4txbOxWoc7VCDxf1217QQ9Yw2VyVeGptXLjdIeXtFnWKrcPtE7hIK6rwm1pajBBcjeP86vltci+oDU7whAwGjQ1JhwSv2qmwbMKyZTVcgWQ4wNURavKbZPRdwz8Jw6ygeKQHROrABUqm848m/xgBb4OXurewjuLnLmvqRnVL8XXTfSBENAvPz09OIckxx1qnZ9kQCMthyIKY052kvX7sJh9YCQ91STVodVQOrg1qY3lH4pG51gKFIOdnIsO01W8+Ta2oy/nEKnV0H881TkDEQtxTnhS0RRIVYNCVHNFJf7MDUGUikxImd/xVDLupNckC7pUfiBd+EgTJt+C/2UEopFDirNtGwpRPeHwLgAgBUwD3M/7pz9ut3y5lNeh36uTQDxoDQHjrmI/KRmNMcAkAkdOM2ZeKD8qGN6IKHcprjp+FM0szZK7Cjmzn3mqPl7HaXiCmnrLHUX68F6JSdrEGmR7Go+yCyd3OlaI291boyifzy6qaDuNaoIDJo1XcfK5YhqU8CLh+VN94klqqt28GCNvQry+wLDXgylI
 uoj3GwhI
 zCHR2cl5EaY2sYJunzKZ4llaUy9up28egltu5IRw7bpla9upPmtSGZ2m45rh9MdVVKkBKo8d41It5rVRICxwL5g3GHO7qQr+NreXZwOe3iCpHUaPZC9lJvP9c+jkkE+XLnk5yvps0TBthVOagdRgeJ+8P9SBYOls6ZngH8OPRNCOio1GHe3aIgE1MwRzH/II/rkJgTT9gM2qHIywcjqYYF+xvC+t3Oxka4Yto5zdgqcr90TXMwroOCS3j3RzC5/QJNN3uBwOx5KaGsDYPzp/q6/b6hThEzCoeiL6s871DL8NLDdm+Fw79UkcGBlrBO1tmccZ9ndn6J+IvSXKldmLM5CLsSGhBOAzxy1+6NhShzDiBjgu5C9Qu3vbsCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 17:58, Gregory Price wrote:
> > On Tue, Jan 06, 2026 at 04:24:21PM +0100, David Hildenbrand (Red Hat) wrote:
> > 
> > I'm not against this idea, but it also makes the sysfs a little more
> > confusing (`echo online` now does different things based on prior
> > state).
> 
> Right, but only for the contig-zones policy.
> 
> But maybe you really want the default for such memory to be "movable" even
> when not onlined beforehand? So I am not sure if the description of the
> problem here is accurate.
> 
> Isn't one problem also udev racing with ndctl?
> 

Yeah there's a bunch of races, the specific ones mentioned by Hannes i
need to go back and re-listen to the talk.

> > I preferred just failing if the block wasn't compatible with
> > the zone (maybe making it more clear with a dmesg print?)
> 
> The thing is that this block is compatible with the zone, no?
> 
> In a system where you would never want to offline that memory, why should we
> stop someone from onlining it to a kernel zone? I'm sure someone with a
> weird use case will show up later that will complain about this.
> 

Presumably you wouldn't be setting the MHP flag that prevents the blocks
from being onlined in a kernel zone then - in which case this all just
works as intended today.

> But the patch is missing details on who would actually set MHP_MOVABLE_ONLY.
> A user should be posted alongside the core change.
> 

This is fair and probably the obvious immediate user would be a dax
device with some kind of `dax0.0/protect_unplug` feature set.
(With a better name obviuosly).

I will defer to Hannes on his specific use case, but I could see the
CXL-DCD (Dynamic Capacity) set wanting something like this.

> > 
> > Anyway, let me know what your preference is, happy to pivot however.
> 
> Restricting memory to be movable-only to handle a user-space problem as
> described here sounds like the wrong approach to me. You really want the
> default of such memory to be "movable".
> 
> Almost like an optimized "auto-movable" policy :)
> 
> Or a new policy that will respect a provided default (MHP_DEFAULT_MOVABLE).
> 

Fair, I'll revist this once Hannes gets a chance to chime in.

This was effective at getting the discussion started though :P

~Gregory

