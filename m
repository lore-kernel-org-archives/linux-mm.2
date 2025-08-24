Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81F3CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 20:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCAC6B00D1; Sun, 24 Aug 2025 16:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4DB6B00D2; Sun, 24 Aug 2025 16:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F19A6B00D4; Sun, 24 Aug 2025 16:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4614B6B00D1
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 16:03:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D335BC021E
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:03:38 +0000 (UTC)
X-FDA: 83812726116.20.1C0D8D5
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18809140002
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 20:03:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x40XQasp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756065817; a=rsa-sha256;
	cv=none;
	b=BBINQQqO21ALX3Qhx4AENrDIyNdzHVH4gSHSkKLN1tFk8zVtUNQ5xqhRANlDvYdo1j0uOD
	L2/gfvLTofy3lrzp4TKHuxElOCzxtOVZ6u1YMkUxQ0TiMAOELwjwBLX9BUMRgiKqAL6e1Z
	k5Kkl3BsXNlZlDYR5U/thf9UGLxAZ3k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x40XQasp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756065817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HGeJdxflg+OSNnP7CbO1iIoz8WJ7W0qhiGLDCSBW4vo=;
	b=PJlXGr8iLZ4f846Krh8KrNb+zqimPPJAAwZmwEoJ1rDoxzobWuI7qOUbOG9w0KBNSFygiX
	ZKL7oZVdsDOvOKpafueMNnIudaJKdaC3iEdpOJ6ZveXzWOEamTWqMk0gYYFIDvk4VK6Kj+
	vPWCrjtb1HBM5as8aUn2d9X/5CIJuOs=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24611734e50so199535ad.1
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756065816; x=1756670616; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HGeJdxflg+OSNnP7CbO1iIoz8WJ7W0qhiGLDCSBW4vo=;
        b=x40XQaspL2iXZ2AEVgm0zwSntHls7H/U8ju0FNAbLBTpBNaEkQHNTJyi3VlgNSnWHF
         hcYi1SJuh1e/Nc7DJIKybRq6VYukHWwWjP/csBA6lNNGHp5ZjUvmSqy141H88rpX2GVf
         rYKcamNYjMt9xvGK86O2ZGBiCeWaexaQ87oFY3iCFeXALonyBLQenOXLzWCV6L4CwG40
         q+jJvgbMEJXnuCJgzMYNJFBvXnjhy0nJR8IovacTH40eycJFcbQo0zQ6ZiDeTNLxH3IE
         br8Hzn+MGi6fN0Eeqj9ENaYRU2Xhba6X41ZRF66idVDb7fnohsztIyqNVARSQKKxnYj8
         /1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756065816; x=1756670616;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HGeJdxflg+OSNnP7CbO1iIoz8WJ7W0qhiGLDCSBW4vo=;
        b=M0ncoNcOgR2CI2j0BvxoWT5M+q15xjdqgmM2y/ng2qVWyxBlxHyPDJOXSgOi0wuYG5
         IaL2a66pwMTuOaINiMS0ni3rOmHXoMciemkmjEoEYBTsEum1hZFWbsGBDcpra95TdUeY
         Rcc+HtPfoR4S8Un04KydoDIHhhJdYS1I3uQuYBJ2I3cEcnSZJU63MI9V9BkHPMLqoxuB
         0bj7RCji7Ja+Fh7B9PjTZrXtWdEynZzWGu4LRAeFptRHkTmcO2TdQsCdHaCQs1qhYRK8
         Ohjg4DXIueNunu3pybENjr0VJPxVRCR+TqRYPn77bsTyHPP+IGfGI0uocNEMn5kw9zNI
         ajaQ==
X-Gm-Message-State: AOJu0Yx7jCGpajWxR3w12oPmVWXJGwsQt/q0BmdsJ2JsUdj8FZyQKcxb
	9FMJhotnu07+aVxneu5jlwQwmPPy5e88sfhlklCHxHTWNwnPhp1p0oJE3ArUHZXeFg==
X-Gm-Gg: ASbGnctGnWCe835odD/A0XSwL7xj0rEmqDzOotOZ9kbyYSEw5K4RKBi2P/oOPpj0cyY
	v4dBJ/Zgqpwc3+BaTNHiV9+5SFiQRMuoOTZgLQ/aOwfUVIfuYqstdpsXP3eQLN7wZg87TF2H80P
	dh+OeJAd9ElfIqrjnc9nDkKox8uk39JwHPz5nZiRiEOtcu5VZde5+rqPzABvZ3+P5DKTO6s8/dn
	HmFbGNwHkEgFumf+FmD7jYzF/NQ0WrhnEw0HKThNzGsd7LKPxmvX3LIGNlWzN0JOYpszSOkdtVf
	RcAril9VFseqrOccXsvakJcsvs6eH9ShYNoSJo7O1Kidc08T3IKeOBV59fm4RhPn6dq7BTUzvSp
	9sST4CAoYkDzisVDxjobSX1s8YZHNp8vwtiJgWoso05KRDUGiePjz9RJmOF6FWvPjkmsWtrQooq
	QoYQygso3nvazxT/d123K5EhYlB8TA+0QbnKWY7Ksk+4P2zvlNYV6j
X-Google-Smtp-Source: AGHT+IEBkizRb5AOm4HmomONRCZ5EWlBY1x2iOyj6Q7u5nfkDELjRtZxkwo4LPzKn2rRVqy+vuxTOA==
X-Received: by 2002:a17:902:cecc:b0:236:7079:fb10 with SMTP id d9443c01a7336-2467a21e4c1mr3270305ad.3.1756065815516;
        Sun, 24 Aug 2025 13:03:35 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:da63:34a:a93c:1b0a] ([2a00:79e0:2eb0:8:da63:34a:a93c:1b0a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3254ad9321bsm4998298a91.0.2025.08.24.13.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 13:03:34 -0700 (PDT)
Date: Sun, 24 Aug 2025 13:03:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Alexander Graf <graf@amazon.com>, 
    Anthony Yznaga <anthony.yznaga@oracle.com>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
    David Matlack <dmatlack@google.com>, 
    Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
    Jason Gunthorpe <jgg@nvidia.com>, Junaid Shahid <junaids@google.com>, 
    Mike Rapoport <rppt@kernel.org>, 
    Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
    Pasha Tatashin <tatashin@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
    Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
    Vishal Annapurve <vannapurve@google.com>, 
    "Woodhouse, David" <dwmw@amazon.co.uk>
cc: linux-mm@kvack.org, kexec@lists.infradead.org
Subject: [Hypervisor Live Update] Notes from August 11, 2025
Message-ID: <365d38fe-50d7-4a1d-ba13-942af26297b2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 18809140002
X-Stat-Signature: a6ii14fgbkjoky3kiza11wqtn6fr5ju8
X-HE-Tag: 1756065816-647153
X-HE-Meta: U2FsdGVkX19fW7hrFUeDLkpHyHJGtMP3LEzUrBwaiKAynmir+3DEq3LdIzs5Xi41ABpe0mL+8kPyHR6uZo2o/RzxBxzGP7XgMPctRQkQ649hBmgt3TRfj2rAK63P1TubmnY9PnmHIK4knupvtnB/RT5lITyLet/1YkDNTqdGXKAlTgigwMHVJNzMFVyP2Y3mBZOhOVr0BgAd+H2AfD+uweATpQ6nk7JS6hhiamGCVdHw3Tp7ylpvKTzj1/JIKb1rDTutk+fuX1o5Nv7V0zwyDNbUCIxIvs+iPq4TwtDtU0Bs7aCmHj9PTWp/o/qm+YmGbkCCiJ9eZnEGrvZDzcl913+kuYkTBHlWpt2Hp/OVbtdfOajTVrDnU/+KC1VkxiPmaaDAddzd2EH1ty9kqGoJwVV2cmS34mRp9VRRhVPma3FqkbtVEo/6IpzL7p05LhkA6hB0WX2OcrqkJaavbjakRtJ4YVx+Qd2cD51qroQMKk6pECSMLV4W0dfvOyfC1A2q4y6Yp/vgAd8+ioTp0mTn53N4eh7nnvtOnUNMHPXKkUvHmp9aIjCNwBxrg/8TdIBe1DBIq5hpFRg22ACtHpvq1I9qxtugWLGZOPyHugOLTAs0nuzM0+xtORnfCdIMDMn/pBZimUxlW/KE0uDOQjTZk6/eBbvpYTL39Pll+lyDIG6CGjq88lGhNNpYMdc11ChQEPupbMAKzJ+vyliCTxjt+tLcP6BEkCt5oqn7DpWqaODg1dAQuFd6pfgR0IvEjquKZ147EMcBwDUCVj5e4ZUCvLQPCt/bLHYiOiAczcVz0G7swb34Ad6jiEnaGKNceyqsD3Zin7XlaItt5O7BK23yx038MU1iSyfalX6o5AjMuPBuRvL4kV8EJAzZ8hpr+JjwB2sKIcuVKRrigaIbwlmsBFdumUazhu6G9EKhMN07zu2cv70TubNPcZTMf4t0DtmmLyb+CmIvNCQqevQb//1
 0xEAQx3U
 n2rZBC4rGA4GWj6eQCpU5toCpEyLKHHFvNV+ctEEnnfq0wvirlgFtX/4iDd5rCPcjLfNw+Jgg8Yr8HTx9cJYRGKWCu7ZXt2YtY24q9Zq4i8Tm0NpZTxxKP0etMAKDPncEdFxdjJuNdJBob4QVi8vpiL0QW4JX2eQF+IP/QpnX1IDIyisRpkc2KytTQEEGOMcb+rh31rG8bAG9wbVnnFLu0tmIMkWIcDeUUP+HwNlR+Wx+5ic77FYxIMROxLJ6eUN88Ax1zCYgk1yu5llQ5jkSxh7H7iZ4yRA7s4W9ADYC5rwOO+KmFHuFveRh1FsuYbhPgbyp9ULNH4SbJdczzcBbgTFUu2hXzQ6vZz9p3HcbbIZs+TcTK5mbDgKSH1mpqPaEnOH3zUDzJRW4nvJoIRA9c5x9TuplY/5Rol4bLrBemvQcMZHeCazuYXw4/9Ytazexx5VdehpFHiNHSoeb0ihATqjom/CzYOU5f76O5uPuA2jPiZQLdK8vKPSFFSrnR7/n6QgikQjWD0oZp41icx6+jjghhQ1IdNW+OU+8Od551Bvysmm3AfqLEkg6B9QxaxZ2860PW1fl4jki8twuxT4ZS1NSq4R1OxTsKsG7Uh5n410bvRmBFDF8GpK76Txb0fDrVrtNst7UwzskiNmfMd5YbwMwnNNYQapyEBlsWCNcg9sALBkMDBv7qvOP8PoHzdFe9FgOP2o0WZ5Tev17wxkCMN+3o2ecLq1p8MydYsOqfOEjCrNrbykkSR59FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Hypervisor Live Update call that happened 
on Monday, August 11.  Thanks to everybody who was involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We discussed the current status of LUO v3 which was out for review.  Pasha
had pinged akpm about merging this into mm-unstable.  There were several
changes from v2 -> v3 as a result from discussion upstream.  Specifically
there was discussion about how file descriptors could be orchesrated
independently from each other; individual fds could be moved into a
prepare state before the global state changed to prepare.

There were also changes so that only one userspace agent could control LUO
at at time.  There were also design changes around IOMMU API based on
feedback from Jason (making it more similar to iommufd for extensibility
in the future).

----->o-----
We discussed Live Update Orchestrator Daemon (luod) and the external
design doc[1] that was shared upstream; this includes a description of the
luod lifecycle (started early, cannot be killed by systemd, and continues
after the reboot phase).

We discussed sessions in luod.  Previous discussions suggested that this
should be managed in the kernel in LUO but there was a realization that
they could be fully managed in userspace through luod itself.  This is
intuitive since there is only one agent that can control LUO at any given
time.  Any user that wants to preserve state with LUO would then create a
session through luod (its UUID is a 128 bit value).  This is required on
the other side of the live update to identify the session.

Imagine VMM establishing a session and then luod monitoing that connection
so that when the connection dies, everything is removed from that session.
If the VMM quits but still wants to preserve across LUO, it can commit
everything to a session so that everything associated with the VMM can be
preserved (after entering the prepare phase).  This also ensures that on
the other side of the live update that the client has to provide the
session ID to ensure it is connected to the right data.

Non-privileged processes can also preserve state if the admin process
makes the sock accessible to non-privileged processes such as the VMM.

luoctl was described as the CLI for interacting with luod.  This allowed
dumping the state in json format including for debugging purposes.

Pasha expressed a general concern about security including for a
compromised host; he did not believe that LUO should enforce that security
boundary but rather wanted to have a security review that would help to
establish luod's role for security.

There was no implementation to go with this at this point, it was only in
the design phase and people were highly encouraged to provide feedback for
its design.

----->o-----
Chris Li discussed PCI preservation and the latest RFC patch series that
was posted.  He received great feedback on the mailing list for RFC v1
especially from Jason, including for how to handle config registers.
Jason suggested starting from preserving as minimal state as possible 
rather than preserving everything from the start (MSI config registers
should likely be recreated on the other side of the live update).  His
suggestion was to minimize the preservation state as much as possible.

Jason said one of the biggest open blockers was how the kernel would
resynchronize with all the stuff that wasn't reinitialized.  For example,
for MSI, we save the registers but there was a question about what happens
next time someone allocates an interrupt and what happens then.  Jason
suggested that the interrupts should be reset by the new kernel on the
other side of the live update (interrupt preservation was never the plan
so far).

Vipin Sharma asked about how MSI preservation was never the plan; he
suggested that KVM be able to check that some interrupt happened.  Jason
said the plan to date has been that interrupts are lost during KHO.  David
Matlack echoed this, that the plan for now is that any interrupts during
live update are lost.  In the future, posted interrupt preservation may be
possible but this could be very complex.

There was general feedback given to avoid leaving behind placeholders in
the series that would have to be addressed later and potentially by other
developers.

Chris asked for feedback on the scope of v2 and the minimal viable patch
series to make progress.  Jason suggested preserving the bus master bit.
However, he suggested the very first series of patches should likely focus
on allowing DMA to continue to system memory.  Chris agreed with this.

Chris asked about which PCI devices would be good to start with.  There
was general feedback to start with a network device that does interrupts
and basic DMA (like e1000).  Jason suggested after that, that we shift
toward PCI DMA with an IOMMU present and start talking about how to
preserve the IOMMU configuration.

----->o-----
Pasha brought up the point that in the context of Chris's RFC series that
we have not yet discussed how to pass old data to the new kernel.  He
suggested spending time to design this.  Chris said this was out of scope
for the original patch series but now that the minimal viable approach has
been discussed, it would be possible to discuss this in a future call.
This was not predicted to use the device tree, but likely something closer
to KSTATE.

----->o-----
David Matlack noted that the deadline for proposals for the live update
microconference was September 10[2].

----->o-----
Next meeting will be on Monday, August 25 at 8am PDT (UTC-7), everybody is
welcome: https://meet.google.com/rjn-dmzu-hgq

Topics for the next meeting:

 - discussion on whether these recorded sessions should appear on YouTube
   to share rather than only on the shared drive
 - discussion on latest status of LUO for the upstream kernel after rebase
   on top of 6.17-rc1
 - update on feedback received for luod and the next steps as we head into
   implementation
 - update on the latest status of PCI preservation, registration, and
   initialization
 - [15 min] KSerial serialization protocol designed for exchanging data
   between live update kernels (BTF to extract or deposit data into the
   kernel native C struct with unique member id)
   + overlap with KSTATE and next steps for implementation
 - later: testing methodology to allow downstream consumers to qualify
   that live update works from one version to another
 - later: reducing blackout window during live update

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://tinyurl.com/luoddesign
[2] https://lpc.events/event/19/contributions/2004/

