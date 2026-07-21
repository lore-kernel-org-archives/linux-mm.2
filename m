Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D46C4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 21:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59346B007B; Tue, 21 Jul 2026 17:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A056B008A; Tue, 21 Jul 2026 17:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB066B008C; Tue, 21 Jul 2026 17:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C33A6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:35:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02E04A09BE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:35:44 +0000 (UTC)
X-FDA: 85014091050.17.9A2078F
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id F074E4000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:35:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q0O62z+l;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784669743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/L09p9hjhfnJuq67NKuGgM+hS4Xq9h8jqqROmbVMupo=;
	b=QLRn6FNfuC6i3ZHuSBhDPbcZgI9Qh4kJn6mJG6LkKjcfIoK67I1etaDAE3RatFfzwhg1E7
	A+d0rItLKQMDidU9Tk/gbzeHiT8pQJVV0RTHiEQHbCZN4FjwL0lV3N4HmsawTXGsoHm3Bg
	ncV4mBivS5r9vutHNsvAb0Zodx/LNPI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q0O62z+l;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784669743;
	b=vuzvCKBsK86+uICeIdFYqKpgyeZbepN/5NBedhGN8GGj0TK4tBcZBxxxS8/hZ2qqHGnhaG
	XrJ1RSAAvykTrlb52g/qBP5EBbHN4/0rgDHAu4bCV13+o5Z87vpX1e9bE5ev7n/I/cFhIM
	/PuqPc/9xGF65vYZ174JpR9NmNF0+Bo=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92f03daaa97so937027285a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784669742; x=1785274542; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/L09p9hjhfnJuq67NKuGgM+hS4Xq9h8jqqROmbVMupo=;
        b=Q0O62z+lU6aM2245YOUc0dNOvNxI3Mu8e/9zng/P3lPBHUwNwhnUJ4iDO2BeRsJOGv
         A2MD4crsrCIAdTudN4n/tu0W1BN97LMWSb+OZV2F0Gw4FUhun3uRD9GaOt901IpWZfyM
         NCA7Vj0xUVKWE63StAOxC0uLPzaBK6TdaIPK4E3EwuSDsLUWLtYeTkbRRUES/OSP/Ew3
         /XvWRStG7wPMUuP0Ag19iZrVp0fTkcBnzzYxOUq6KWmvEC6p69GozkgKvcpBsDx2okka
         BrW/93Ar8x0LqbsZ3NsV6LwcmktmsnSeSojkMeqVcPdBCsqPPPVLp8U2bZd4bOHYDiI5
         sqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784669742; x=1785274542;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/L09p9hjhfnJuq67NKuGgM+hS4Xq9h8jqqROmbVMupo=;
        b=O1MfdTI4hy/ae0f/idXnqMFwXIHjJMq7SHtGKUydrrTFyNuZ/GlPdqmBdjWVX+twEM
         UZo6w7ud2P8DOU5mpnKwRzT/3MWJo9HUE9fjxHswa04V2XGC8CxVbi8cqzASJFlViw3x
         /4EWrpMKKjujXqvl5T93d5fB81IO550upTcxML9srq9RPW9CAxxRQgBPbYPtorhHw8kd
         b43d1duuzFPLObbpOphy0IB0UeysJfcBzm1n1S86GU2gY8OCm2ehT3KnLaB1WqpfTrce
         PinwDpswaDIIKBD7XU1lbVO0W2vlTUeQbEM0/YvIuD1F4KQ34mATblfwG5X4X0BSKHwh
         FBAQ==
X-Forwarded-Encrypted: i=1; AHgh+RrBQiiWJpyx3iZyAixvYh1SqAkfJnl5X4MEtcgbvtzXg+xHMJH0tjCUOi/YpEcAqttxBJBH64L+PQ==@kvack.org
X-Gm-Message-State: AOJu0YyEoNsxy/byfLTtFbFxCTterJMPmoQq4jMcJ9kZyvpuGM1XG27g
	GY2UfyMVSBT1MTWyMPdVWmJpYEP/geLs6HuHRXl8emgO+wGdW+BxN7nWJNBB5c1HGNk=
X-Gm-Gg: AfdE7ckanlugcUnRggTzzz1gVSLhCAgF/Uzo/iz8p7luj3trZI9fn+y7TcMsQPnDkZ1
	cs/vR3GROTOsCnj4va5fgfZ1mkZ4+VijE5xQlEoDXwbOvHh1r/yuLdsxIiToGoOAACpOaam5uCe
	SCECvkM1uBKU5xv3CTb/zUhYyfcg3xmshEmcrhVJO/NZ9IWfWJtUthqEFPb6tx7Lo1okwraml4S
	dmwGVv+deaB2RlZ8DYiwuT7isvPgRNELpy6TwKN9IAUCpQ9SZFXQVqsJUY3+aUy8gxoeoRCy2zZ
	if2ffMZ6IQWtmqYa06TP/0+b7XuWi05s7LtTD6nfFJHmz9PqMMcglNNv2cnrsRD7+EjOZok2T3r
	yjLTIbNYusfmBKyA9MAyUi1SP1gHQ2p0wLYosY0d45XYciWV3BcctbBbUrVAVtHpbNgJtv2/LJI
	24FQgfS/6ma4oMzocsL8es4MWWY3ej//lxQZ2dgAc=
X-Received: by 2002:a05:620a:2b82:b0:92e:fc42:2c1d with SMTP id af79cd13be357-930b3ec9e69mr1935028585a.20.1784669741912;
        Tue, 21 Jul 2026 14:35:41 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b54773fbsm1200457785a.39.2026.07.21.14.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 14:35:40 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
In-Reply-To: <al_VrpvPE-RLCF5X@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <178458744511.332171.13770778781241262180.b4-reply@b4>
 <CALzav=fjTOnyg2++GFFe5B17rHqNCWW=afjsD0A=EEjycPW7Sg@mail.gmail.com>
 <178465652971.412167.17838319728990505256.b4-reply@b4>
 <al_VrpvPE-RLCF5X@google.com>
Date: Tue, 21 Jul 2026 21:35:38 +0000
Message-Id: <178466973829.1257886.900641450757526076.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3133;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=n9GCy6FourVHMw42pszPZ/kxYjrtx0ToMvEFR8X96Jo=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqX+YrXoUG+/twOz13pZ+ErnnGUFKhvMcK9TUHm
 5U4aFzfcD+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCal/mKwAKCRC7dyhM23N6
 3h7TD/4mAowZzUytWw/GBQF/1nJIoe+y01Mpv8f7eHQexJ7iATsttb+FbfYLpomH6zguTcBsIoW
 91QFuHteD+mVmq6lMNDVxqr8K693bfjCPLXN5Yscg9ZF7cQ25fLLtxm5K8f1iQ9lYd9lRKq032E
 bx9u4OycAUnkuka7y3ETFu9ILaNao+94NQxkZXKetmUfOj2Zz1N2sxm7lbEMnLru1NFm9ZcyGp9
 1ytJ+H9MG3aafd5hmEB2IAZjS2BBgeB5SFG6rsJgcyd8OWKjWfsxvsY6PnvPeI2F+dEF2sM5wOX
 FQehPH+uHOqKk+AGUFUaPR8riMnzcbRju3SGFc3oJfz0BwGEokGw+DydfGI1bdP7qQd6aNL/2IJ
 /oKDcb131mYKVvU/sNoEjbbEHAO1W0Ikr70/GJ+LK7bki9dd/f2BcCrB9t2AuIcJfDDJxViqOEG
 b87uMr6gD7FDN0UHaiiFE22QN/rS3oA32+ABhGQumkv0QRBKnkS6s1wMo+56rTyxpa7ifn5oYRC
 B/DIkST6h/nSQazKrWUGhUoecK0s/AZgViO/YvZCJSYUqPh9noqC7hBiYGoXcmGAKZV0YjRqJpz
 GQ/C03e3p+3cug90wTpUluvrVrvZ1jal6JH6wzs0MBiaxFP24X1zUtHUitFs3Qj8g0M/aSUW7Hd
 g5Jx4S1u6NpTsjA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F074E4000D
X-Rspam-User: 
X-Stat-Signature: z6ixw9ps6zhw7mpojo7uo5kqbd73d581
X-HE-Tag: 1784669742-459926
X-HE-Meta: U2FsdGVkX18X3RLMeRO/SL6azuZRSlleeBHbLptti82O95qu5QI99NFddFl+EEd60+jbETLXOYAuwc96kucTZaZc0lgQSZOCwVMC40vsrYR2ZBHdPgg5GJU+IZ71G1CEDjW43CVfa98spitKmBq3lQHDMxjcVSkqFqLLUeU91NPEfDHwSMHLwwhoRM3+R1/J7vsbLd5SgUV6sbCkC24BqJUd07KqxF2FzTF3a/z+hihJUksYbdCRmsVvpyXM4lqVJVZKUFRib8McUAiTNJVTfTJBjqZIZ2NjPorQz5MnsbCRYSb1NMip7p+sn7DlzuVgDFgl27pwuS5N6VsXm7bwwQhW61IIVsOztlYXLIXdcQRtb2z5Ng5iUdJdRALsbo1U45ZJinpgK2a9F1yKZtFPz3wSl38HtoXEx6gUetai7A9iJIHs1z+k12JlzNitRVlab+ZFAETUElee5VUWsySrlkCtq57y9vvfu6gXmY+rsJeA29xweaNi5K6uU92tv9lH90hqfaFvkFRP6vKvyklTqLtII0lXgn2A31Q0Nh0XsWXIOqWMZSJN28LAPg3SZoaE8tUriPV1yfbo9Sifu81gW4w30yGXDOnl3tZR7ijLnn+mkMA2+2iWWvKU3zngIRln6doY5zVnqCwtdUz0Gsv8xA/DLXWZ1yT8TgbKJbAdD8IEFOyYSe5jyyOmxB2r6Vi9OSQwX8At/Y+QjngHWigy7OLSx4Ok2m1Bba8jSAoz8MGturb0BEExGeL2iPBdSGqccGtU/u2EJIVCfPrgQSQNi0zI2sKjb14qbpmgNwHN9GInq77Pqx/vXhA53U2UhgPwqi0SN6/03k6vOJTCbMGi3IeiHyNRru/7+du6CtlXj7O/TfWUS4COswU5lGx4lkAN5ve+M5dhLwo5SnbgpGu5pe49OSpVUlcUD6fhFZ7OXQ3Y/sDx61VH+zxWdGkGyNE/yQN2KAnwHf9d52DR2EH
 idkdxDtc
 qQzTIJgE04eKlnsAmagmwa39EkFvBDsf5WtxRQeWxU/OS1i2DAIiWkmYYDzA+RdI2weSIHZ7vNPwe3K7XFTRh865YiCvcCMF9PMhljlvffcINC5N+LitZJFqvdc60K5+Al2g1NeQCZTtRxcg61iP4S4l9uDgA26FkHZzVT2rFTpM/Az0wzFB+jDuTGqGrIVq6bIrOkLAAVzNUafRD5Y4qUL8gqWHPKSXbIi7iUkIYP4NUWjAdYGvsq401zL1RaOSeg1TfTShUa0ini/izyEZH8NCyzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-21 20:25:18+00:00, David Matlack wrote:
> On 2026-07-21 05:55 PM, Pasha Tatashin wrote:
> 
> > On 2026-07-20 16:07:47-07:00, David Matlack wrote:
> > 
> > From a design perspective, liveupdate_flb_get/put_incoming() is a 
> > logical read-lock/unlock pair on the FLB data. We use a refcount for 
> > optimization and sharing, but holding a get over a long asynchronous gap 
> > (from boot-time device setup to driver probe) is essentially holding an 
> > unbound lock.
> > 
> > Unbound locks make it difficult to trace refcount leaks or debug 
> > lifecycle issues.
> 
> It's very standard for refcounts to be held for a long time, e.g. file
> refcounts and device refcounts. LUO FLBs themselves already have
> long-lived refcounts taken by each file that depends on themm, which
> aren't released until that file handler's finish callback runs. The PCI
> core is just doing the same thing.

That is right, but that refcount is tracked internally by LUO and 
follows the design of File-Lifecycle-Bound objects, not the lifecycle of 
the FLB's users.

It really seems backward to me to force FLB objects to have a different 
lifecycle. Let's start with a concise lifecycle without setting a 
precedent where clients of FLB try to control the duration for which 
objects exist.

> 
> > Can we do a fast-path check first?
> > 
> > static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
> > {
> > 	struct pci_flb_incoming *incoming;
> > 
> > 	/* Fast-path to avoid unnecessary FLB querying */
> > 	if (!dev->liveupdate.incoming)
> > 		return NULL;
> > 
> > 	incoming = pci_liveupdate_flb_get_incoming();
> > 	if (!incoming)
> > 		return NULL;
> > 
> > 	/* Check again, now that FLB is acquired */
> > 	if (dev->liveupdate.incoming)
> > 		return incoming;
> > 
> > 	pci_liveupdate_flb_put_incoming();
> > 	return NULL;
> > }
> > 
> > This seems to gives us the best of both worlds: robust refcount hygiene 
> > and a sane fast path.
> > 
> > What do you think?
> 
> It still seems like an overall worse approach to me.
> 
>  * From a performance perspective, the PCI core would still have to
>    acquire the FLB mutex twice every time it needs to use the device's
>    serialized state (once to acquire a new reference and once to release
>    it).

I suspect, acquiring/releasing the FLB mutex in this case is trivial and 
won't be noticeable in any  real-world scenario.

> 
>  * From a locking perspective, the refcount doesn't actually protect
>    against the device itself going through finish. So we still need the
>    pci_liveupdate.rwsem.
> 
>  * From a hygiene perspective, each reference is held for less time yes,
>    but there will more places in the code that need to acquire and
>    release a refcount.  That is more room for bugs to leak a refcount.
>    So I'm not sure taking more small refcounts is an improvement.

IMO, short-scoped acquire/release helpers around actual usage are much 
easier to audit than holding a refcount open across an arbitrary, 
asynchronous gap waiting for driver probe.


