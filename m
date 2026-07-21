Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD46C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86796B008C; Tue, 21 Jul 2026 19:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E379F6B0092; Tue, 21 Jul 2026 19:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01D76B0093; Tue, 21 Jul 2026 19:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7E356B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:17:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D5951202FB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:17:15 +0000 (UTC)
X-FDA: 85014346830.03.4B1F114
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B58720005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:17:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hps/F98x";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784675833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ7qRUkeVcw09Vx52wAPeyyp7zrSxjZkAHO4XaqMzD4=;
	b=ACVUm0iMYIpv67JbVHlDSDxichRbRduqxhIn4SkBVznXTHRTrpST5ZCeU7V7iRe1lKsvaQ
	07AySxtFKIR+HbU92qYGc9ptfqzrx3dbiGcWJmrIMq5/mulHLy/Md1355QG/FsGwDAuo/v
	Z6QnnAMhLY1RX0wivpCyc3ja+tMFLk4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hps/F98x";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784675833;
	b=eXY3lOpPuLLjl8Y63nBXkDoTbZCHKZM1nGClYqdN2SsfGR5Vfl3cgqgjh2xmavpifz/43T
	hdxOTsnSjL/3le3d2IPvNfE7kL4lk8HJXiGJumohyugPjrtQXuBq0umvG78yFY58XSfj4p
	eDxdRcjsYCHsVLwFRulQhRwiWIwkBzw=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca12086c06eso9919825a12.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784675832; cv=none;
        d=google.com; s=arc-20260327;
        b=e9GhMNzezCXx2WIyGJqKm/olqDNefxuYkRQv3JiAn7bakceHxASOiI0Hkrvyw4Mk7E
         iq39GEJA0milzv7GPowzicnsjIulT/0ryJCiM045bvlCfttC3ustGIYbJvsVJ1HxQSaT
         l5AYKguxv3nsnWTXQsxz6RFVW91xt8QL3nnfYKXTD8cm5Nyz1VixSXzbLS8q69HNK0jp
         ccy5e+S22ZlxPUB1rqGywEFDZzcqwEtfFEXPL7PfVQrp77QOUxK4rNV6q/RPgtwyisMj
         qABFj/hNOh7bgDydvpJQ38wn1I1MO3uTo8NgDuCmfQB7j8jPPWNBEwOT/H4KUv2z+dsn
         uFeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XZ7qRUkeVcw09Vx52wAPeyyp7zrSxjZkAHO4XaqMzD4=;
        fh=thGIgfswGE9DwZfWwG3ejkymySVpCBIcRhvikPLSzko=;
        b=jcPS1xbs5fs9fwx5xlIKljtsacVpagKuXJSakyip7BhRFOf+LaEqYeQRBFiuswJiAH
         9rsAlk0dHGa9Ose4zX015aXUWHlSS9Xp1qU+5FMH4ubLs2zdUu+NnzGKeUrHFfA5tDNZ
         hRjxM1v77+ywYWPs09ewUfXd2Jwify6D0btL2EVGZodsROcIsll64uudY6bEcYHH/OWd
         mKoDlecHgzFj2YJVK9qmUqeNEN6sRnF13PXpsRTLptfoVe9bVe1IjmFakt/q+Uf4ZSId
         44izDdg4wvYHggDkTEtQj8nmWeGiPQIvjglEI97kxpuIapjm1MYvnG301XUl74EPh5bA
         em+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675832; x=1785280632; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XZ7qRUkeVcw09Vx52wAPeyyp7zrSxjZkAHO4XaqMzD4=;
        b=hps/F98xvq638qZaMBpX9NjTovziY7elkmJSy8YbUa3NZEkryqtxxxR8xLCGvCf3Fh
         PxJYR0abyZdnhQM0rAvixq3EM57p1Pa7+9u6Zn4xS8u0nzjgXV8YU+AU+mWJW+4IxWoG
         YGqyU9P2+kL911DQjFsgYV5AFYJHEMeeC926uPTbgnfwU9d5RpZ92gfVjEsM/9+BXrQ1
         tvHwWwUOGnneKzTsiMryckWb5aLc5D00qZlkpwFiDQXF4HtoglKEOAzX1i1TqRZ33s0Y
         c9lwNB2GuHbSBEQ2TrkiqgKexD+/s7Jt2UMwZvnMGctewLmeBodTeB9lW7THoPpvVZ0f
         e+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675832; x=1785280632;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZ7qRUkeVcw09Vx52wAPeyyp7zrSxjZkAHO4XaqMzD4=;
        b=ryiyeb62H01Hf1tb0eGRNIIfWJ9dcyjUjR4dyWjFz8Xw7q8d5OF8cXG+PzMdNnlxh9
         oXBUC3amWb99QOqud7pjXuH/sx5lMnncx2ixijma4MtiP1D9bhh3e1k2OynqVHHE/rWi
         bUE2PqAIYa67+H9caf8WMg0lUXSh8wpxrRwBCZd8ZFHqYyJjwwR0mbGHFu+FsUhS283f
         EPp2pM59m575IovSGaDtKgIsKIIgrwDrQtoFpiOm7tOsQJS/3qBkJn/2wI3KJVQsLZm7
         UfH1QjQ/cyY0Kud4I6Gg4mtswCY+7zBoWyCfh22QJ9izQhjrWS2W1ahdnvmajVJUNM2A
         R4Ng==
X-Forwarded-Encrypted: i=1; AHgh+RqTY8WKbvvZYJJDACrDObOM737ZIGSxRv+a1uW64iIG6KcXRCGnWui1Lmzj5zbxZNj0G+UEvJskvw==@kvack.org
X-Gm-Message-State: AOJu0Yx4XGDzMhTruCzC1ThQPm/h0Y/KltKuAKc4V6ycoftz10w5HgnT
	9rId1kXbl1t9XtWtVONDwcErK8ZO50VSMaKx4AMHrxMAgWqoinkTCUVFrxZXqznYNfuvf64eG82
	8U2tnl8PTActudtFy8F3VKmuOrzzbAXtFTCE4zVHL
X-Gm-Gg: AR+sD13Vsc0VybhFOzkE67DxjzkuTrAaH7E793Y7vRhRngR9ClYpibgjSEHTZk7gXII
	KUZsBMZ4OlpjnT4KEybqwS9/pG0vkVwdt5axdH1LzSEIzizt6WsK97uH7PHsDUQp8yf5lP0tXpm
	kfBT4jcqZkOWWNV435LzFc5iabswnQqsp1Bx5QsJgO1SXZTmttuWfMfrzGBTWD6/zNnwXZx1mVZ
	AO95HqFrh+vBIvHH/yDieHaIjR4p5OAccHaLW+e9mmb78a4oyx5pzTVI4Knkg==
X-Received: by 2002:a05:6a20:1446:b0:3b1:cce5:9140 with SMTP id
 adf61e73a8af0-3c3ad8537d2mr21934058637.33.1784675831570; Tue, 21 Jul 2026
 16:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4> <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <al_3nOssZoa6RoCq@google.com>
In-Reply-To: <al_3nOssZoa6RoCq@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Jul 2026 16:16:44 -0700
X-Gm-Features: AUfX_mxmcKg9wEWL8G2cbUIPdoOXypA3DIQHnJ26Qr2Bjm3tZvSdzwlvs3nabeo
Message-ID: <CALzav=dvc_bdmFtV1U2APfs1FM-6Zi5=VShcAYQjZ0wwNRfC-Q@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B58720005
X-Stat-Signature: x6m3b48k6p9r3js4msogkksn7eky7dgk
X-HE-Tag: 1784675833-215239
X-HE-Meta: U2FsdGVkX18bbdAjc5wA8X8Gsd6zjZSdz5SAkTjDN4VTkArII6j/flgQDQ8cxObVhIGgHphJiR2Kmqmr8sJOZvFtfqCk8UmooIsemCbmYD9VDc1+vcrz1Ld2Cnw4YD4uUXGh6PAxyeYtHdy74p8bJ/cLVa3vq879ORUNPIaIopcgLlkmlLFeqNCQUPoVhMQ/I/TrR9lZNr5EvoddBbyh76Va5fxwMoqZ6wzGEFpVjUj7uvQZHVgAdPDg1AU2zdT1oXKN8I3NdZ3O1rjDxUDKjCBskgXk/HSWm85DinYmgyJmDo6P0k1AzF+3OyLIaUsWaPM8GmBAh5r4Tp7GSfKyvUhZVctE2g5oG/Y8uZxQ0D7fOKoPYhgqyC0rkDgSTX3AN5KQU2VNxfJ9LWvOzfRVFrci9iQKaRuq0eiN67qFkCpV48X7QGCjBu8hVVtiQ3eBBqwxy+lopFYyJDR1skif7+q0lAUEY3/5Sp8fr4P04oTRI+1rB1oZdhP0Ws0u64XOX/tusX7x8Nf4dUIGP3JD5sr2IK+YjImfQyR5E2ILq9RSyeW/y/rHEFhUxPH0vdXtgo3Eu/Um8Sf664V0jSkiPdiTjqxq74uB2U8NCnjRE1LnNhREX1U5MbBtGBNC++qP7Q+ar6eTTtHZU10sr4kZbYXE9zT1PbUQKiHIXdhS0M9DRFHaSTGB3vAbZxwAZQa8zu2ntM+CZOkoIoc2Ehc5M7PIGeW+z550MYoRqa1biiQN4eqY9kMAGePLsZ3vV3ApTahHvPkHiMI2CfvYL6Z059i9Ahp9ucavDEFvfaEO7PNd3IB0jP5nkN93gaFcp41+3Oiw8HuB/mWyYT21RGdS4WyDdUz18CcNaGXBnFo9P4gW37UDzfDftrQtPRMEMIDXqpTn5UA34HBjfilcrNhwAZHNrxjy7Y/OxooBaBLY/RyfuB/lrhFROGFTPRSV/jjvx//akqWLSxmEccHkT0D
 e6EnMSuj
 LVFPPwG2NLz928hQw1xCHM5ARrwBtqYXUCx2L7wH2BGlscWaLmfBjolmeO+t5fwJ8/vPLoRY1nGjALtafpLvza1dla9rJYmbhSsik4CEcMNEmNipp8W7Irk+SwcJxGpfjZ2MsXAzLqNrP2ducKBUVyHWZbFvCOhWJv6wOl9C3NcmpdHjka+PMi9IlVOS208rIGEeJYnd9EAVOV0WVBySdyXxQrY8R80U8oYNjZ+JDTwvJpYX/H9niilsK6yOsRN1wmvAnDZGF/sEIXg3aHAJCLNT+mURAkO+JPxXgwosJbH+Im7RmdnpgnmdpR1YDbTB+/0OE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 4:02=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Mon, Jul 20, 2026 at 02:54:51PM -0700, David Matlack wrote:
> >On Fri, Jul 17, 2026 at 2:47=E2=80=AFPM Pasha Tatashin
> ><pasha.tatashin@soleen.com> wrote:
> >>
> >> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com=
> wrote:
> >> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> >> > index 03075ce06ac9..df6a02240aa4 100644
> >> > --- a/drivers/pci/liveupdate.c
> >> > +++ b/drivers/pci/liveupdate.c
> >> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *=
dev)
> >> > [ ... skip 76 lines ... ]
> >> > +     /*
> >> > +      * Hold the ref on the incoming FLB until pci_liveupdate_finis=
h() so
> >> > +      * that dev->liveupdate.incoming cannot get freed while the PC=
I core
> >> > +      * has a pointer to it. It's better to leak the incoming FLB t=
han do a
> >> > +      * use-after-free if driver does not call pci_liveupdate_finis=
h().
> >> > +      */
> >>
> >> I am confused by this. Each preserved PCI device must have an associat=
ed
> >> FD preserved with it via LUO. I.e., vfiofd would need to be preserved.=
 If
> >> the vfiofd was not reclaimed, and finish is not possible, that vfiofd
> >> would still be owned by LUO, and therefore PCI FLB refcount would stay
> >> positive.
> >>
> >> However, if finish is possible, and this is the last vfiofd that is
> >> finished, FLB will be freed as soon as the reference count reaches zer=
o,
> >> which I would think is the expected behavior.
> >>
> >> What is the point of holding a reference here, instead of only for the
> >> duration of FLB access, i.e. to make sure we are accessing a valid dat=
a?
> >
> >The duration of the access is from here until pci_liveupdate_finish()
> >because that it when the pointer (dev->liveupdate.incoming) is
> >cleared. So that is why the PCI core holds the reference from here
> >until pci_liveupdate_finish().
>
> I think LUO gives you guarantee that this pointer remains valid until
> the FLB finish(), because all the vfiofd that were preserved have not
> finished. And when all vfiofd have finished, LUO lets you know that the
> pointer is becoming invalid so you can unset these in the finish()
> callback from LUO?
>
> If I understand this correctly, I think by keeping long references until
> finish you are replicating the vfiofd bound lifecycle that LUO already
> gives you.

Yes that's right. I am taking the approach of not trusting drivers
(i.e. VFIO) and having the PCI core maintain it's own references so
that FLB finish() is guaranteed to never be called while a device has
device->liveupdate.incoming set.

Alternatively, the PCI core could avoid taking a reference and instead
check for driver bugs in FLB finish(). I previously explored that
approach and ran into a circular lock dependency between the FLB mutex
and pci_liveupdate.rwsem. But I can look into that again, or just do a
lockless walk of all PCI devices and panic if any still has
dev->liveupdate.incoming set. It will only happen if the driver is
completely broken so panicking seems fine.

