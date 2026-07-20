Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5826C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73636B0092; Mon, 20 Jul 2026 18:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A116B0093; Mon, 20 Jul 2026 18:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AA66B0095; Mon, 20 Jul 2026 18:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 784436B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:44:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9B1CC02ED
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:44:10 +0000 (UTC)
X-FDA: 85010634660.30.C847222
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id D566740006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:44:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVLtTMau;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784587448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZotz6DMr/KESNQHMebtxodvrKo450DHNTkidmosnVY=;
	b=w6GAjmmK855i20mI1EDVcF3/V4CR2F02RV6wfq1E/3hXwQhX2yjy9yhSRdyCo/aTVROPd8
	88OMHufE6b0hYZLKZE96Q/UjbZncDn5GZHfdRU+zbJmJNMwhYKwMQs5q4d8ikw3TZG0Vqs
	q9k093oUaZe4U167vWNlEItjo4/W0W0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784587448;
	b=BuomPZsHc3QAdbZtL2IPOTehBO10sZEl5Ooy0MjMFKhqnYIFHfkNjzBlKkr2wuywY8ZgBU
	YhMAOPAx5RObZuZUB1ddVOm12LrZSjdcPYDLqlLYDTKD75FvTOgNIh+mOstqNhnNbMIIAe
	xhO1In/YFiCzd0ZJkk2AmD6SiJIP8EI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVLtTMau;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e50c5d14cso766131685a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784587448; x=1785192248; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sZotz6DMr/KESNQHMebtxodvrKo450DHNTkidmosnVY=;
        b=WVLtTMauSDUtIOPXnUkRDuCswCpE5HNthszsidwAe9KCox60uBWfZYC1THD0bfH6hp
         F5H7kCQ2hJ3aBpuhpa4+U5Q/NBjuLRLzNc6oGakfsqV8seefpWR/zvFbPLgm0+5RDfTC
         MYDer4X0I5xKEBcxLgzFKGYFNJsaVwtTtuEvf+f6U9RKK4RwYumV2TuCev6pGlWOmYUO
         hrGYiLAO4neXyaOzGiIljMjkpnJStyb2UZMm6C2ymtXmoHzMq/hjWHXLKnfD8hGUGWoy
         uS9YuTSizRNuGb0BBzk3rh2cUKpAUFZm3/negFS5D2SBeZ/20+UNuXhEg2ENriIQGLJx
         K6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784587448; x=1785192248;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sZotz6DMr/KESNQHMebtxodvrKo450DHNTkidmosnVY=;
        b=Em5/3h4AZupC2+G5lyBheduOw9e2mHlOBJbsG2r1muGCmRWhtrQ9Pb5Yuz2rCsawgY
         cgib5MehdNeRKNHLbuCDpD0RLKEZSBWqH5OTKNh1+DcizIm+Hs+BSKqtXrQKBULmbwPV
         1CiCOpbQXQS+FAYiyegTPZ7MxRiCsCb0nVpPXsOsgmatkKCl7F38czX6tKw9Cz3xhKde
         Sbhb8/BdVyqqxUcf4TQUPaD6xtvEh0FpyXuzP93JdTWb0ogd8pGxG7o00Wh62iHn2KPY
         fcoKTXWsPuQ7XPLKEIrITfm5iY3OrViyYogU1plmr+E9m38AyXJNkn6/8Y1W4Ovn9B/M
         sBDg==
X-Forwarded-Encrypted: i=1; AHgh+RrCMJqREw5e52O5k/qfBMqsZbmhirblH0y1k+8VVkkKBgSCFnxfjmp+btNt5DLFMJtRA5MTIyjGpQ==@kvack.org
X-Gm-Message-State: AOJu0YyUI0UyySMyCgp7iiUKiEHgjszk12gIAsbKorsrsKSdXqNjPLk5
	LmdsPkWmq8WyVu3BuCZMaOMfTtMDN9VTHbNve2ciF44qX03JhFleZ7Uf5FakWgwhYrc=
X-Gm-Gg: AfdE7clcU/dEscPGqX1Mz8WLY5qsnH7rtiMHVReVYEI9hg44DzMhhRoBBw1mE6VN2O1
	tslLu4sBt+kSJE6WT/m/nxFCHS4bKTCnda/Km1f8NWzDN3fvyoHaCDKywhsgg4OGC11vUtn4f5u
	Wm6R3D1U8OYk/icjQhKHhYPN60/fqwjLnZuDTPxQektWXJlkU5Ef7Va4XzD1tTLnya8sLQWDOFS
	Vzajn8o1RCVltlO3Mry6lVC2ZsenLkoy5tBzBRJfxeSBeIk1gM9ED2VEEPfcI/AB5tda4gNodO+
	Fj/EP0Xx9bxLofFiVSpsxcpXFxh9EKysR36J9MGQhIK5ixAbAhbuhFXdSzPKFIjCOG2gEOZr7jh
	Lr3QZr86Nv8feZPvrHfMBPBYPpe+YDx3UO5T1Chq1dwq5mRVTgS9RdNldvvQGskKZzrnkEVmJgN
	4LIE3xdgeCsb8SC5lajeHxa7+wf9yrB0mI59Hqlx4=
X-Received: by 2002:a05:620a:1b8c:b0:92e:d677:45c8 with SMTP id af79cd13be357-930b3f10083mr1694446385a.25.1784587447916;
        Mon, 20 Jul 2026 15:44:07 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5491329sm966366685a.44.2026.07.20.15.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 15:44:07 -0700 (PDT)
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
In-Reply-To: <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
 <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
Date: Mon, 20 Jul 2026 22:44:05 +0000
Message-Id: <178458744511.332171.13770778781241262180.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3475;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=ebC5xGcTEOi4wVqJ6ncnnXXiXaqDe2gAf8jcsdg4FFI=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqXqS1187zj8JXRe5lB5izbKlBKLqvYbVVBleoX
 4T2/h8BcwaJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCal6ktQAKCRC7dyhM23N6
 3t1OD/9Y1PR1oUKi0SDKwGc07m5QU9YJW4ylOoJhQmKBciDPc56xSO13GmZAfrbnoRNuEHy0WfZ
 T6WL+ngFtThbo8xKTV3r0pcKUNB0fuwCnI3x9Zw8CUDvHFEK6vS7Udecjo7dR9a1JLz761f7bM+
 12ImK0lfNaicDnArmbfqVQUZNpMPgdmK+CZXn7ps8uDGxF0IsSEhyuYhYJkhdoy94yjcRRrt2Zj
 g69n+kkIpTaDMvonbwXST5HwZTAjyIYDhQIP9IDt2Vnyd2+TWMrzNM9qVhyZjjrSwQ1GgV1MvOa
 jvy/0LcvwvUkcNGBNveq1/SrKCeS2+jijiLh/QmzloLFwyKAUOl98M9KaAaPMF6v1fHwAJhAY9m
 rilvw4STMhIk2+9yVSYSbxN1kBuPIwnwPodx6yjpYXsRdwr8TWEq3MAQ/07q7gArC8vtVFeZNIl
 GaAHAlFaMKl515UiO1uoW6JQxduFrwo/D1DtNaBca10N7bziwpVRj6pHXUMajydMBMoeJWOfrPz
 XOTLQBQYk9q+oZZPSV/fHFWIHlF1e3cocmdYNdnUwDNyZf+Mets1iR0Su9j7rbe1zSW1tgSuLgX
 nE8RRMA+RyH7M6lkvSgFkzdIBtfu1B1URfbD+EDaIzeqVHJAwYbjo7sEfPI46GMBtnmVSeum85X
 aSNOxJOHr7j1oBA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Stat-Signature: bxtbyeyzi9rdt19xuke5j43u8eb81cst
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D566740006
X-HE-Tag: 1784587448-28382
X-HE-Meta: U2FsdGVkX18QkMCYHpDE5V+0xaEiPUtQnZa68bHImTOyJ6aqrUslngeAAvBSndImVWvcugrhNExpsx81EOYyHdUwsEBYGyOYfkYEnA4E7a9KP8Iz37GNZXgwmh5BTPfFXWeL4x1MH233xrXjuAp03DIjzES+VWH5M8g6vR5OWG3wzC3y4DMkw60VHuWy38o0cLVkgyPIh+0CkBugabbyqkHYZHlpq3leKkEvXpPwqBvBGQsCRf4Mw19RGkfeACHC0Y+mydx5hohW2bvOwnq1VUCrIEepcKmkVjgTbWN6VeT5suaI46pKKinMw1/w2pxoQTTsVA8rs7LkNCMo1GdIp3XIgl7Iejnyki/sWlWJ26WncyzSj6qE7GYD1aMRfzBU2VskHhx+raGTqSNhzLprNoAmF0J0zdbCJfjLfwN9LtHBcaKzRJ3VxYYJN/fkjXy2QN11z1S70S3bMYas2XXswJt0IdHbC9vEr3IiAhyJCF9g4mFV60G8LR7hHxFw1ViwC61XTkx6oIBpnmObKhbS8b0aR46b92bCKiUj5A7aAL5QawwcW+o4VcfzOf1ouvMQyySmL2gelFf3xuNuMGpZO+/Vn8ekX5pLNKZ6RdPQh6+dUap1oy4Nfs56o9pPuBa3o0wK+KmOa0ZQkcKBkoT67ZjCTcP7+5xaIdwN1Lc7akIYZjtzn9exCmQeVJ6OUE74zJZOmo5xZIk6JYfzli9LEr7cvaHnhbng8LENXXn8moAei2NmGZEFhgJ+WdfPvEZfcZquYZETiHgxuHLPcIXP3TyhRgX9K4GKb/xXEAEsYhmm4zgh0gj4O3HstKSSI/klvsyT/jS/fY9EP48z9fwJKMq7D0o1axQWhCbSbj6Zfw0zrwH9U7zt5YFBvIYM4R/WPS3DoQgIe/D7IQcsDH6HFbF/8FLqZtQkbgQpIga/viVPd3PfFIijtVkqbhBEwICU6wSst7+u1IRo8HMoYLE
 Iw8q2Zg0
 BQxtD1XaQZPDrtu1A0866qOJi/T3Exg9kLugNnOQRyWfdRxgmCQjzjj48bdzPxGjBpwf5Nrr+CV0zZGX+k65j1WY2aCXnxyiwny/EOfDG6jPrUq+nx/CPvsNLRHCoA/GOT4o08bkogcB7bIMAaW72EfYyufKWbdf5CB319FeB2HUgzI1yfV9U+USdSkVs3GRl+F94UTR8HvSM6AcP5VRNxGrC6IlSHruhZUuS4lPLH2IFnagGRtLMqwdgfJQLgfDbbhH5nQGdXrnAFgJywn7xX25Je+2MAMxTkKjMFm/AvFiwoi6+GGeylrEkzvVNlTegQHZeIHzF1GpVsS3Y2gGqIpTAjzLEOLteGIALjlgkq3G4jC4F22KK2Q7d+ubpl65nuW9Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-20 14:54:51-07:00, David Matlack wrote:
> On Fri, Jul 17, 2026 at 2:47 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> 
> > On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com> wrote:
> >
> > I am confused by this. Each preserved PCI device must have an associated
> > FD preserved with it via LUO. I.e., vfiofd would need to be preserved. If
> > the vfiofd was not reclaimed, and finish is not possible, that vfiofd
> > would still be owned by LUO, and therefore PCI FLB refcount would stay
> > positive.
> >
> > However, if finish is possible, and this is the last vfiofd that is
> > finished, FLB will be freed as soon as the reference count reaches zero,
> > which I would think is the expected behavior.
> >
> > What is the point of holding a reference here, instead of only for the
> > duration of FLB access, i.e. to make sure we are accessing a valid data?
> 
> The duration of the access is from here until pci_liveupdate_finish()
> because that it when the pointer (dev->liveupdate.incoming) is
> cleared. So that is why the PCI core holds the reference from here
> until pci_liveupdate_finish().
> 
> We could avoid this by deleteing dev->liveupdate.incoming and,
> instead, fetching the incoming FLB and doing the xarray lookup every
> atime the PCI core needs to access the device's incoming ser struct,
> but that would be inefficient.

Thanks for the explanation. As I understand, the most straightforward 
way to avoid holding the permanent reference is indeed to delete 
dev->liveupdate.incoming entirely and perform an xarray lookup on every 
access, like this:

bool pci_liveupdate_is_incoming(struct pci_dev *dev)
{
	...
	incoming = pci_liveupdate_flb_get_incoming();
	...
	dev_ser = xa_load(&incoming->xa, key);
	...
	pci_liveupdate_flb_put_incoming();
	return dev_ser && dev_ser->refcount > 0;
}

However, as you note, this is inefficient because it affects every 
single device and adds lookup overhead to every access (not sure about 
the actual cost though, xarray access is pretty fast!).

We can, however, still avoid tinkering with the lifecycle of the FLB, 
and instead treat dev->liveupdate.incoming as a "hint" that we validate 
on access with a fast, liveness check:

1. At Setup: In pci_liveupdate_setup_device(), we do the xarray lookup 
once, cache the pointer in dev->liveupdate.incoming, and immediately 
call pci_liveupdate_flb_put_incoming(). We do not hold a permanent 
reference.

2. On Access: When an accessor runs, instead of doing a full xarray 
lookup, it just validates the cached pointer's liveness by temporarily 
securing the FLB:

static struct pci_flb_incoming *pci_liveupdate_get_incoming(struct pci_dev *dev)
{
	struct pci_flb_incoming *incoming;

	incoming = pci_liveupdate_flb_get_incoming();
	if (!incoming)
		return NULL;

	if (dev->liveupdate.incoming)
		return incoming;

	pci_liveupdate_flb_put_incoming();
	return NULL;
}

* If get_incoming() returns NULL (the FLB has already finished/freed), 
  the hint is invalid and the device is no longer incoming.

* If it returns a valid pointer, the FLB is guaranteed to be alive, so 
  we can immediately use the cached dev->liveupdate.incoming pointer 
  without xarray lookups. The accessor then puts the transient 
  reference when done.

3. In Finish/Cleanup: We can simply clear dev->liveupdate.incoming,
and decrement ser->nr_devices.


