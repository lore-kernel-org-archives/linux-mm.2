Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1A5C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA716B008A; Tue, 21 Jul 2026 13:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B13A6B008C; Tue, 21 Jul 2026 13:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FEC6B0092; Tue, 21 Jul 2026 13:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2236D6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:55:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6238A0947
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:55:35 +0000 (UTC)
X-FDA: 85013536230.18.F26EAFC
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5A0816000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:55:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M6hLoHlJ;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea/F6w9Zt+Er+ldXlrQTi7dDqHaImBI68nyXrbPqNKM=;
	b=lV5mwclCh0jmvaFDzUJg+LsGmxGtbp+5Pmj5KVs4XD9o48pyeDyBqkVzA8ZFG+OTBs3Lu3
	VC4/QCZgWYiRLIi0lA3XclnyFz9sxBYEMYKtH4HeMxlgcpUhfYw2gCB0DtHgcCMZlUwyVR
	y+f7yoRoUmZNgoYJplTCzxe1+1G+UYs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M6hLoHlJ;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656533;
	b=DS5FXcrGC/xYvUWo6CVnAuK2Hjtdl1SO2KEENiFebIAlVBNr4hOPxwX4SeVVo7zgOKVLav
	KopuElGuw0lsRzzDDsUpG7Fg5Qnz36ioCaTRgoYSEqtAmt8Aq3kx30s9ki80ygBFDMHjFm
	igxWv5rOUHKtkH+9a3//yze2PuHWqeU=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-907ae240ac3so7488296d6.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784656533; x=1785261333; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ea/F6w9Zt+Er+ldXlrQTi7dDqHaImBI68nyXrbPqNKM=;
        b=M6hLoHlJHzaauhbYzB+kSj2FImiHOnnRBayjpRMBWG9LZtVg5x53XGahTcaPrS6qYK
         D2y3ev3PDXZWr9KYdHrW8qQZjkJCKwrNdif2KOVBfSdxRf/SmWfoM6zSAIVyJvBE9AHX
         39piMj7j04s1KIFTz9JCr/r9fGZGMNo7pe4JToilvP9NoTHRwqAmsgU2BoHsKJFuY988
         caJd83VFP1VNyANNCqPQr3QbuA6th8j+pJTNOKVuXfkF4bScNjb5Rla5edPtLNPTc0AT
         OPUpIXO62RtzbBZlLX39V9IIb63NDo4t/uzGpL45paWq+2yiUyGgfUZo8rY7/Mo55Irn
         4u7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656533; x=1785261333;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ea/F6w9Zt+Er+ldXlrQTi7dDqHaImBI68nyXrbPqNKM=;
        b=soivFgDNViCTlxW6DY8BPqC03CEjgLj9tEU1iDxpg10YYVcrJVHbu8m91X5FANOPvv
         tbh4BripfluNqaLPxFb7Yhq0+fi5aa0YvqOi3o7//CRvZbKskVWpPQ08VfjDxXlIdFO1
         4/B8H+h/V4/NKgxuhyel5G9N2ByYK8XBi3DE/QneV05IjtCSHXYid5GMFLePLHg5qKbU
         X/+5NN4ETU/xx0/mkT8FSXGQ6wWWlM/k8gRHyHYZlBp5WhQgvJA4xM9uVlA84Q/Lda0h
         oTqhfDwW3GS9lz6VLdjJAMp1hox6v1gxlC4cHJm9cnWgnLq7B/zRqL+PYQfSZw8elabw
         kD0g==
X-Forwarded-Encrypted: i=1; AHgh+RotSE8cXfIu1VqLaXlCwMwAiUqCP/uUz4f7Z42UGOYJDSUAnKITrw5+91DrSSKxFOv415OzeJkykA==@kvack.org
X-Gm-Message-State: AOJu0YxApim18O8noc+jm404bP6Vc0Y3/ctMXJltg4yAf38AJBDMGBcq
	CKzTCVrldhMwjphpP+7j8nbEOQ3j1l3LEjCDAA8rh/45AKz6278h6FBctNlvKsF3R/I=
X-Gm-Gg: AR+sD11N3Y2Q1voQluwJL2NHJ2kFFI/GZOR6vTek9+YjKatqj6J+pV/FJBLwZQmNGNR
	YX0sVSTHlCKwkerJdGYEMJlE/qatq2TYhVtq1NjmXpjOmtf9qoqXaPJ+g6+tonS2wUNiFZXbgc4
	V4iZPxfQUxQ0TocF61GwUCp1AZfUgh92Sot3PrLiKfvlV2YbqfZUe4+Q7omTX0AxiRAvrNRwmkP
	3LcPsj8GVMPDaRchlAdxgWg4MENNcAKsFSuba/zfMb2XK1yjUstIViPL58RSHsEdQJWhmNDTnW2
	QSZSYNR1z7Ncdj3JEQ3yKkLYEbenhnUCLxwNu4XqhOQAsNx9psBEzjEcdNKZa2wvwYeZ6w6cfiv
	LrHF6pcSEEOsDc1pDx28t4Bnax3I3g/Yx7kOrxXbMsRoy6SmUgxqYN3XWTM9swhKUjyNvqn7PBH
	LjTwTxGsdRb0uzjijnByVXCwDQuYYGtC66pjJ6hzo=
X-Received: by 2002:a05:6214:2269:b0:8f1:8937:5dc7 with SMTP id 6a1803df08f44-907784ddf91mr239817166d6.56.1784656532475;
        Tue, 21 Jul 2026 10:55:32 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8df5d0sm1663826d6.18.2026.07.21.10.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:55:31 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <CALzav=fjTOnyg2++GFFe5B17rHqNCWW=afjsD0A=EEjycPW7Sg@mail.gmail.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <178458744511.332171.13770778781241262180.b4-reply@b4>
 <CALzav=fjTOnyg2++GFFe5B17rHqNCWW=afjsD0A=EEjycPW7Sg@mail.gmail.com>
Date: Tue, 21 Jul 2026 17:55:29 +0000
Message-Id: <178465652971.412167.17838319728990505256.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3765;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=fzgF3V5HF54yEqsnjagon7PnrwUxx4c7CuxO/Uie8BY=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqX7KSG2dHPEQ6Mkut+xegrodYi1A9KSpnUO3pn
 xL+SSaK1qOJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCal+ykgAKCRC7dyhM23N6
 3sbLD/9VJw+QusBVAbX9+6asMemVQiDftMc/hr+I22YGh5yCipWq3pZjfM7mP8bljemHy6oIbj+
 eg+gEXv7pWzzQ+8GV3PpuOBYxkjLRkI0gemShPjl4DIrRF1i5QKtbirG+j8HJShkbA0MUFQYF4w
 etoSvEkZ5OowXog4ZxpFFJrtp949gwoLonQntZS2YEdepjeuQ6O5+29aDjXTwrqt8dr3iq97QY7
 PEegM9HW0HVvWmt7PoJ0dx0EEaKZJ0GqMpr9O8W2GdxDoZXl+Sk9BxKiwyOX4J5Jz7rdQAn/o7I
 Ns4QUk/VtBQL/1irI528G9H+z0gGxw4nCxP8fANN7VQW2Y68d+e7tNZOgJEXmtgQe6lh2ihna3W
 AJSXMdazYky84+h1aAgVPom/cLGQhgzwHgZSps6nDG9qMSTLZGGAP5VPvHpjCAt1MsLtajskJ9m
 Pzp1qdozYbecunkANckh7aN32FTvRvmPFrVjU4a/bjB1bsG9O6ocEd2lvY5VLJoI/7EpNjFQENT
 gzqd9ygy3xIcDV9ifvMhU0XWWUteFUjC96g3UGsi04IcPbR5Oe4Fe0S0UiiqqUxgncTyddsTlmF
 IyJ5BW5Xc76J0oYVAhS14CIxQNY+9LXWUbBAgmqx4XEDE427j+I0Ic4eKf2seStQEq8rQZ1xQbi
 o4SPKFvgFZN6Jyg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5A0816000C
X-Stat-Signature: k6ozxchp4nmpgy174a9mwueps3ubfuke
X-HE-Tag: 1784656533-4977
X-HE-Meta: U2FsdGVkX1/ln6kU6Pt/XCSQxaJCj/xVRzakx++jocELXlGXV1SBCspBrrycpWYrVJ96lWojvslUjWT1GDj5lDzSVOLcM2OvuEMDzg1FRm12QL2j7oT491Wjmiy6mB5Bxx6MgeSI7L8nUfDDkho2I0fnZBXIjG2yjpmpUcLB5wk4fUJAygNSW40akYByeMtpoDMrbcprhIc0Zh1Fmvnk3VplbrWKo7VYlSgr0ASUpRX8fjfJ1rSLgvZAskJnFCXIOpLipEPzTFWgEoVdyv8vU0JLzL8Vf29zH5d9KFtWuiz4x+boW8lq1ipK0jWExYuSUVcERELVvaKiZvxbBfxwVuQALQzEVSJBcBspG25Kj+jQo3U571WREmO9pWbPxVd2mEKgN5/CgMMfFjMpMTIh9NDr8JrqZxj8kUEcfVr69tJT354k0Bx+/MKZd2hPuKj+XQPIXeIfsmJhQa4gvDcZKIuqgkuz/vjlp7D5hn1NxqY897CZ4FQBqZUrGAmJCha42GrKO/f/KEC1lsHtvNkPCWUFwvm5Dq3cEfTD4m9fd6YRmu7Hys7PqtD833yQo2rDDMWKi1jxfxmZog/GhDeLEwDgSYYWR7fdSRoqZZHB8Qyav+ZoOl6Q0hg8/bIPbxdpEr9TweuXHd8sR/aM09oLzv6/6lEfOv1Arvn1rw0RdjfaGUy3eTA4Zo3dd1H/iNzdmf56HVXnMhfy37/SLHj9jb3fpcthaYxoLZ19dGB+9bHPgKBzM8poBDia+s524XzphvRiShP/kXWsJ1tvAC61BlS+Hfa36ibs/sNnlkRUqWBoiUkMvVKuLlwOoR6kBk2OGUBqOybViEHwgO52s6TVZzK+Kz1/VT1zRX/3ZqpkfSsu9yppLjkQ9GNr9xOkm4ua+4+a3IkJ1dgzG2LusoeZAlHudN9/mzIydGb3XTPNJ8iUUtosgSDNXeCRCdToQ0Pr2h2HaFWTsj4WskSTdx/
 yCspxy4n
 JiZVsbvYW0hK+UuCibjIKeTFheHIztIPD9a1j56OwKqjeWqIXR0RvLe6Te2cye0NpggT+X8e4lxf36sEBpkCIDPt2cagOElg3NkZid3JMSZXD/a0R7NEoijR/AXr4VDmYjZMEO23kuJ8dcUrrSF9XXewjyo+/GQdsG9esf5xp97G2GupXn9Hh86NpgmJlT21flO/c+3mTTDjIfjoW8Rr2iNF5y3kihDVWm4CyvCZUumdfLY0WAVwuRflNyuwvRVfnSug5IOB26rwsepXWVDI85Mif2tF+FxjpulIUcNW8mMIsbrAqw5WLIOuZYgE1oOi53dLvHKmhc1+B4WGZV4lv8zvdwMB7yLNpL0TXL6m2AS7Vyec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-20 16:07:47-07:00, David Matlack wrote:
> On Mon, Jul 20, 2026 at 3:44 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> 
> > On 2026-07-20 14:54:51-07:00, David Matlack wrote:
> >
> > Thanks for the explanation. As I understand, the most straightforward
> > way to avoid holding the permanent reference is indeed to delete
> > dev->liveupdate.incoming entirely and perform an xarray lookup on every
> > access, like this:
> >
> > bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> > {
> >         ...
> >         incoming = pci_liveupdate_flb_get_incoming();
> >         ...
> >         dev_ser = xa_load(&incoming->xa, key);
> >         ...
> >         pci_liveupdate_flb_put_incoming();
> >         return dev_ser && dev_ser->refcount > 0;
> > }
> >
> > However, as you note, this is inefficient because it affects every
> > single device and adds lookup overhead to every access (not sure about
> > the actual cost though, xarray access is pretty fast!).
> >
> > We can, however, still avoid tinkering with the lifecycle of the FLB,
> > and instead treat dev->liveupdate.incoming as a "hint" that we validate
> > on access with a fast, liveness check:
> 
> Can you tell me more about your concern about FLB lifetime?
> 
> The lifetime of the FLB will not be affected by this reference unless
> there is a bug in the driver where it fails to call
> pci_liveupdate_finish() during it's file handler finish callback.

From a design perspective, liveupdate_flb_get/put_incoming() is a 
logical read-lock/unlock pair on the FLB data. We use a refcount for 
optimization and sharing, but holding a get over a long asynchronous gap 
(from boot-time device setup to driver probe) is essentially holding an 
unbound lock.

Unbound locks make it difficult to trace refcount leaks or debug 
lifecycle issues.

> 
> > 1. At Setup: In pci_liveupdate_setup_device(), we do the xarray lookup
> > once, cache the pointer in dev->liveupdate.incoming, and immediately
> > call pci_liveupdate_flb_put_incoming(). We do not hold a permanent
> > reference.
> >
> > 2. On Access: When an accessor runs, instead of doing a full xarray
> > lookup, it just validates the cached pointer's liveness by temporarily
> > securing the FLB:
> >
> > static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
> > {
> >         struct pci_flb_incoming *incoming;
> >
> >         incoming = pci_liveupdate_flb_get_incoming();
> >         if (!incoming)
> >                 return NULL;
> >
> >         if (dev->liveupdate.incoming)
> >                 return incoming;
> >
> >         pci_liveupdate_flb_put_incoming();
> >         return NULL;
> > }
> >
> > * If get_incoming() returns NULL (the FLB has already finished/freed),
> >   the hint is invalid and the device is no longer incoming.
> 
> This avoids the xarray lookup but still requires taking the incoming
> FLB mutex twice (once for get and once for put) on every access. And
> if there's no incoming PCI FLB, the LUO will iterate over all incoming
> FLBs under the mutex to find it.

Can we do a fast-path check first?

static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
{
	struct pci_flb_incoming *incoming;

	/* Fast-path to avoid unnecessary FLB querying */
	if (!dev->liveupdate.incoming)
		return NULL;

	incoming = pci_liveupdate_flb_get_incoming();
	if (!incoming)
		return NULL;

	/* Check again, now that FLB is acquired */
	if (dev->liveupdate.incoming)
		return incoming;

	pci_liveupdate_flb_put_incoming();
	return NULL;
}

This seems to gives us the best of both worlds: robust refcount hygiene 
and a sane fast path.

What do you think?


