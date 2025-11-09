Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C9E3CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 01:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA868E000A; Sat,  8 Nov 2025 20:54:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B278E0003; Sat,  8 Nov 2025 20:54:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949D78E000A; Sat,  8 Nov 2025 20:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8F38E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 20:54:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E495160868
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 01:54:38 +0000 (UTC)
X-FDA: 84089399436.19.55A6BFC
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E2DD40008
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 01:54:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cda1Sdg3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762653276; a=rsa-sha256;
	cv=none;
	b=0yZF+k4NqidVwfbjOYoBCzm+CO4C0CDGNIJ5i8M5l4y1mMIf4fKBs3THaqzywME/+5kCBR
	wauSZJh4WUIO/kJMpX/mnrBGTdOQLj66sxnvulsqStZ8kYEpvhlYmDl+lPpTQIIO2AKZgy
	4b494FmlxACoOQbUL5LHFF+c5/X5BdY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cda1Sdg3;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762653276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTA68YLUrvv1QwWT0WiwLCQWXoEE69/jtOIrBRItPTE=;
	b=GlnllQZz+KxwFlMkaY3SlBHkNQS5skwSpoHy0hNrGhSQggNpuoUpucU2ZrptPl7x9/AqFO
	1d9R/QuLqP1xMDgkpFJqZpMMIzGiqna8Sm9gerFA9duTXSDRDa+tkUW15l+A2ENU7pRvcJ
	PeANh4NCbI+k88Bdp3+XiuLWV8Bu4Ac=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso602547a12.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 17:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762653274; x=1763258074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WTA68YLUrvv1QwWT0WiwLCQWXoEE69/jtOIrBRItPTE=;
        b=cda1Sdg3V2DJvfN5yYR8NkLOnHU8h1eXlUgPmZANAFgSBfV1b7yQXxRR/OYNF5YR+f
         aTNp+II3s8S1gjxRDawYRhW80zMiVw0vrA6pKaeCb9uWBHN12CC9+3NYq+zMXN0GVihT
         n76lg+KCd1kz1D05SxPkHtVeliS0zBGorlgXq7EfLQJyhd771pgMitRchBNLfg5Eh4zJ
         SvP/wProzjxuwxW2wr80xaFaev7NQ8dZQUEDNl7Hjuw4d8QphJw+NzbPcES1qn7Mv16F
         1931DyCAFIhbEB2/S6M4UDf3tTHtnpMilRk6MYyL+Fi5BMJNuRyvKp4iXTuTjOd/E+Ni
         UXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762653274; x=1763258074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WTA68YLUrvv1QwWT0WiwLCQWXoEE69/jtOIrBRItPTE=;
        b=BPpJqPn/HaCU9PKQTvkvfkPSTnDQWA9aFPhjTvBJRZWKhJyl5M29q3ryUuC1yujyE2
         fc2okERVS/UIx1HwCkpMcaMuugIDeEz6hHrAaEH/7W0SjMXk4nCs8YV08XhQ7n6sp+n9
         erGKeyC80UDXuXFe32aDDXIAgYeUpgMAZobtfLkm3Uf9H0elTZIRbs9DwGBRwiDbpGXO
         HrvYIvRFA9zNFxJPVu1xly5x8vuj+cbUVNmCfuEH2cdZHoyyZM+0h2KDAOL6A9ZbvAjh
         udP2k3eFgf8NdzsYI065YQZEiWLtMH/tUXN+TzjiiUQc87wWj20CmuUoJs7Loy5XZpmr
         9UJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeR5XnAiK48jLXmBWz9Apyjvc9lassh0w/m/bGLWse6YNOgxwCdX/OfmLIF6ITsrLOPwLEV9ExVg==@kvack.org
X-Gm-Message-State: AOJu0Yws9cuEykMkYu97+m2aL9AtUFQvCVsJyExkmamt4c8+1NTvFBNX
	hWwqhL0ETj1+N5HuitWDyduvTQ4E4qQ8kRBmuzdSYktz0jtTJUQ5mccSsKScy6OTkDnlkhXR1qa
	VYkPtNFRLVtaeoruYd+bIcR0Kck2Rq+3Lil8NB65kog==
X-Gm-Gg: ASbGncuT+Eh9prRxSlBnSYrp0jDl2fRqlX6Hj7fkInPkLfJFnLW6puT84iM+/oHcCKi
	EP4/dcSy+q0QNVHO3s5+omC8WpkPT1RkY0/Tm280VCvGAY/Z7dok7tiLQd7iCbVyDFSxQi3Iq7N
	MP/J6PPfUZRAd3r8ydw9CVn9VKLNrOp1NtmL+tD+W7c1CL13JvZ5uq+t2M6l4cxTzTY3nogQKqA
	b2pKuh7WJKajO9W1EslJ2Qm4y+8unwaMmXgS0ZmSYmVLoDQ8+ANOWGI4w==
X-Google-Smtp-Source: AGHT+IG65TefAfGFjfDn06mL+BHVcWewTC7OuXAXAWjbdoMW1FgcHSrFYAKWxturLKEwciGsYq0R5hsc5Ht7xlI2p9o=
X-Received: by 2002:a05:6402:1474:b0:640:a836:eaca with SMTP id
 4fb4d7f45d1cf-6415db532c9mr3165400a12.0.1762653274048; Sat, 08 Nov 2025
 17:54:34 -0800 (PST)
MIME-Version: 1.0
References: <7742456c-b248-04cc-0e1a-9da7d0546f1a@google.com>
In-Reply-To: <7742456c-b248-04cc-0e1a-9da7d0546f1a@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 8 Nov 2025 20:53:58 -0500
X-Gm-Features: AWmQ_blXD3pPkkLiQpz_4mPHNurHAjwPwSz8SvzU3BTsnNgEyjskvz8dFO-YRg8
Message-ID: <CA+CK2bAB84ziS1wWf08U5BbDO48uNqBDz6vtR7hxjakOGhEN+A@mail.gmail.com>
Subject: Re: [Hypervisor Live Update] Notes from November 3, 2025
To: David Rientjes <rientjes@google.com>
Cc: Alexander Graf <graf@amazon.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	David Hildenbrand <david@redhat.com>, David Matlack <dmatlack@google.com>, 
	Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Junaid Shahid <junaids@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Pasha Tatashin <tatashin@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Praveen Kumar <kpraveen.lkml@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, linux-mm@kvack.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4E2DD40008
X-Rspamd-Server: rspam07
X-Stat-Signature: j6t1uktcyknwphquqi8u6nk3m76kzk4g
X-Rspam-User: 
X-HE-Tag: 1762653276-203439
X-HE-Meta: U2FsdGVkX196+Xc+CZbEQC46ojGurFbE8FTtvY8MQq1yJ0VM3xYVAHPAAP5DDwcHfpsglKO/qI85JuHBAmmMGkt8z2nnwesGuLiczuSRagxzQ3EfbnXds194vHALTvYDtZG/q6DhB1tIYwiDeba3nc0X3o9hZULlprP4o4P4SCRJOn5yhis4KoUj3pYZO6OHlJrquVolWsbDm3qNABoje0uIhwazpOc2xL5jEpiaY6PrQvtzhDS3ZzDS+I2Z+oB26wirVRPOHfIUvgHrslyQZoRNAD1roBUB4raE8mHuDQfrwnoBi5Y15XMavG7FIdL3Rl2dvtCW7hTbjINqrm88OE838xIRhiXQCsMDEcXqOeX3pfIO2MD7YBYRtlwRovQL17RuxMblG9Cnlo09CROeNxTi9xZQkHUVTAmZfpqTp4YzCcfsVss5PMcPBvF20ZkoiQo5hXkzZ6VgffNgXT6t2iJ/TIAO+czb74o3YVgS224TLdWvzBgMBEVUjauSTXZLEMV3ZNcsdB/7P2GYBa6rGtmY6e27GmpbWyBdRNsN1oeLvuRdQOTuPp9mvaWqyho+/PmcepqGT/Sog5PLITqt9J5kiSd1Qy2qdcGoU1PzmebecmFyRo29jEwIkJYypgwCU7RDtfON/Ikkd9ngtmruGTeg3qj2wdbjctRORR/9MuTGDP9Cb4j6QdQ4VPx7i22ektjTut0KaTvW6hf+yqkrkiHRhVRzvUs4BXkQNxZfhjhsofZbk26MetgioDa+qeanEMab88dQhxkIudvS7cGSi9I6K0+SdodUtmVtqOLFcsggbcMpCrBOAowu/5oOIWu/+hIUke4TtSrxWu1ZMnDD8C4ivFfFoS4Q9BbG2RuJOQmfsw8vbYcCS7Yu7lFJoxZEaGVn5JVCvy2oPuOzTJSwLIYMuWTL2C3/JyKK5dFJF8Mc5XGHQ0gzAoYAa46LK+TsoqKJDoWdx83ej5mZo+c
 od1vkxnY
 FZKozXlv7bEJXsAVb+yd32EG/+Omddc6gFcYJ94Y2PQebseDgUOlUrfjetrBbIknInvgc9X60CZVshP65YoEr5LQB/N4SBmb3JTMPs6XBTAmxVEoIaFt0jSQ4ZX4cmnj6QUJ7cT50WKLq7Vxad/MI/9oYXBGw8P9eqZTl9cQgowctjqRGoJ6HsmqDePATUTShPczsUYmRQuHMRbroSRpJsqOJElnLuot54H3CqOUm75vC+CnZaxnfAlJA67LTR6q3IAJLiApjCxvOdvgPT7wc0KxCHhrDDETJcmQrKOxqHFzWcSUtiy8n8glvj5NRc5pCZbodJ93oGiVSMYmSTxVzzPKIXSWleZ6+ZSKnOqB/5/T8oZpsy0udR9F4ok11JCIOXsrawZw9ZQmG2Ch0/LVfYeLO4j5xRbFN/FSeKbdpqDn+uJ1rBXzg8eHo6vW3M0ommmxeuuofZy9mcT0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 8, 2025 at 6:48=E2=80=AFPM David Rientjes <rientjes@google.com>=
 wrote:
>
> Hi everybody,
>
> Here are the notes from the last Hypervisor Live Update call that happene=
d
> on Monday, November 3.  Thanks to everybody who was involved!
>
> These notes are intended to bring people up to speed who could not attend
> the call as well as keep the conversation going in between meetings.
>
> ----->o-----
> We chatted briefly about the status of the stateless KHO RFC patch series
> intended to simply LUO support.
>
> Pasha started us off by updating that Jason Miu will be updating his patc=
h
> series and is expected to send those patches to the mailing list after
> some more internal code review.  That would be expected to be posted
> either this week or next week.
>
> Pasha also updated that is plan is to remove subsystems to simply the
> state machine and the UAPI; this would be replaced by the file lifecycle
> bound global data created and destroyed automatically based on reserved
> file state.  He was also simplifying the state machine to keep the minimu=
m
> needed support in the initial version, but with extensibility for the
> future.  No exact timeline although it is currently ~90% ready.

Thank you David for running this meeting. The LUOv5 + memfd
preservation from Pratyush was posted yesterday:

https://lore.kernel.org/all/20251107210526.257742-1-pasha.tatashin@soleen.c=
om

Pasha

> ----->o-----
> Pratyush discussed the global file based state and how it may circumvent
> the LUO state machine; it's an implicit preserve of the subsystem
> completely independent of global state.  Pasha said the state is now boun=
d
> to the state of the preserved files only based on sessions.  We're gettin=
g
> rid of global state for now.
>
> Pratyush suggested to tie subsystems with the file handler but this would
> not be possible if subsystems are going away.  Pasha said the new global
> state is flexible and can share multiple file handlers; one global state
> can be bound to multiple file handlers.
>
> ----->o-----
> Jork Loeser as if there is a design/API link for the memfd and whether
> this is something a driver could use to persistently holding data.  He wa=
s
> asking if a driver could associate arbitrary pages with a preserved memfd=
.
>
> Pratyush said the memfd preservation was part of the LUO patch series at
> the end.  A driver can pass a memfd to LUO after creating an fd.  Pratyus=
h
> suggested using KHO to preserve data; the data may moved at runtime but
> would need to be unmovable during preservation across kexec.
>
> Jason Gunthorpe suggested using APIs to get a page from a memfd at a
> specific offset.
>
> ----->o-----
> Vipin Sharma had posted a recent patch series for VFIO[1], David Matlack
> will be working on v2 of this will Vipin is on leave.  Feedback was
> received about not moving the PCI save state and making them public, so
> that's work in progress.  More feedback said there was missing bits and w=
e
> need more PCI core changes that would be updated in v2 to be more complet=
e
> (but also include more PCI changes).  No specific timeline yet on v2, but
> it will be based on LUO v5.
>
> David said the VFIO patches are using an anonymous inode to recreate the
> file after live update and asked if we care about associating recreated
> fds for userspace after live update with a particular inode.  Jason said
> that VFIO would care because it uses the inode to get an address space
> which it uses with an unmapped mapping range and this must work correctly=
.
>
> ----->o-----
> Sami summarized the discussion on IOMMU persistence.  He was working on
> updating the patch series to v2 based on the feedback from v1.  He talked
> about restoration of the HWPTs on the restore side.  Jason thought that w=
e
> wouldn't have an IOAS for the restored domains and suggested it could be
> null instead.  Sami thought this may be slightly invasive including where
> we are taking locks; Jason suggested against a dummy IOAS.
>
> ----->o-----
> We discussed briefly about deferred struct page initialization support
> with KHO.  Pasha said KHO isn't compatible with deferred struct pages
> although when using KHO we definitely want fast reboot performance.  We
> decided to discuss this more later after LPC where there will be some
> discussion about reboot performance.
>
> ----->o-----
> Pratyush noted that he is working on the 1GB preservation but will take
> some more time to clean up and have it working properly.  He said
> guest_memfd would use hugetlb for 1GB pages so he's working on hugetlb
> preservation.  Pratyush was focusing on generic hugetlb support that coul=
d
> be ported for use with guest_memfd when it supports hugetlb.  He's aiming
> for an RFC to be ready by the time of LPC.
>
> Ackerley updated that the hugetlb support for guest_memfd is currently in
> RFC patches posted upstream.
>
> ----->o-----
> Next meeting will be on Monday, November 17 at 8am PST (UTC-8), everybody
> is welcome: https://meet.google.com/rjn-dmzu-hgq
>
> Topics for the next meeting:
>
>  - update on the status of stateless KHO RFC patches that should simplify
>    LUO support
>  - update on the status of LUO v5 overall
>  - follow up on the status of iommu persistence and its v2 patches based
>    on v1 feedback
>  - update on the v2 of the VFIO patch series based on LUO v5 and expected
>    timelines
>  - discuss status of hugetlb preservation, specifically 1GB support, with
>    regular memfd, aiming for an RFC by the time of LPC
>  - update on status of guest_memfd support for 1GB hugetlb pages
>  - discuss any use cases for Confidential Computing where folios may need
>    to be split after being marked as preserved during brown out
>  - later: testing methodology to allow downstream consumers to qualify
>    that live update works from one version to another
>  - later: reducing blackout window during live update, including deferred
>    struct page initialization
>
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!
>
> [1] https://marc.info/?l=3Dlinux-kernel&m=3D176074589311102&w=3D2
>

