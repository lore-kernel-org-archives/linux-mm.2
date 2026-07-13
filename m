Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B403C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 23:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3846B0005; Mon, 13 Jul 2026 19:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294736B0088; Mon, 13 Jul 2026 19:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DE76B008A; Mon, 13 Jul 2026 19:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6BF96B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:38:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DB581601F3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:38:23 +0000 (UTC)
X-FDA: 84985369686.22.F815BD5
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50F91140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:38:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OdpxYBWn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783985901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbeC0G2r0+fJphZIiEMA3U3mQUgbuZ2yGF2MPyVi8cI=;
	b=NsiU3wmPEn7Dms0GtsFiPTuibFPM/IIZaTpC+W10mpP/FpjTg05Kpf2orVdwFKVT6MqZaR
	QyrGI95D4sIf6SBClP2WXUxwQxxHM5tAC5GO4vDrQXwgGQ3dImqsGlO7v2iIWUZhHNRK/w
	DjS4hEPMm01DiYLXsgIY/eGO+kd+k54=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OdpxYBWn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783985901;
	b=YXkn7GYDzpCnD/JuxiLWNDcDuCbDO7zwAyYNcXarzpyqiW+MxJ5oUD2+mtUXqYd41yMPTN
	ARgo2IulRG034AUcAK00Uh2ObAMQUQqKLUyY2dKfyzSJr13pdHJWLyMfpeJKCDqrwTNOoE
	AjNFLIRP/2JouBqOVePEqMXxaLrxb/Q=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca913a601fbso2537986a12.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:38:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783985900; cv=none;
        d=google.com; s=arc-20260327;
        b=St9+bkQy+RNRZWs2KeGs5R7y2/SdzuZmZ0gP3L/sqXY/NoQpZyjAMyyfGn1OKTdd6j
         gDVsb1QpErlx2RBiqZLkaOXX16Ubzj90Vswyvnq7W2pHHuQegRU1dn/OnYuaY5ZCgUp6
         vs89r2Oftg89RhRRHJ0LE/cBn3aCg/7h7Jkd1uXf27eFlTnZRWI8SBjWNaXhOFEUn1/u
         GiU0mmbfitXnZPkfmS+NW0L8Hx1tjT8zOz0i+wC2XQQt4Qt6+sZMhWwKIK8yQumi5Cqq
         Vcs01vE2d9yW17ln2QxKTSOsqsSKpqVLhIEdr+7TeSOE2NBcy67QSvxZRRsoSWB1TpFD
         u21Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WbeC0G2r0+fJphZIiEMA3U3mQUgbuZ2yGF2MPyVi8cI=;
        fh=c9ycvD6DQ5B2d8WJwKMOr75NkGUaV/EZeeDNVGuUPd8=;
        b=YlVO+3TXg1yD3UaAhJ1mG8Z/9Xr6LSHmklrC7eQepJ++aIQ7nPyU3M6LV+dlgiIFCG
         6wHzhb65xPOT/Ll5jkSqbOZI17CrH802dmZ0KVquxAC3IhEp5Cjd9jxf0vxhG2SSwo2N
         eGVY+kLl1CJsR2RNlFn26+OU25F/sNTLtBw9tchxO9O833tSw5FBkYH05TVbaZSyhPM3
         XlnBY8nJZ6kJy0263dX0avJlf34jDwKPgqK06fGiN4k3n15pPRaTSBRIsf84vhZ2JUty
         e4w1d2gxE64xCHJXdklXSeqCloX1HdSR8xC5Y/M+9t0SpxEY2alesC38yRanfc55zgAI
         fZXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783985900; x=1784590700; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WbeC0G2r0+fJphZIiEMA3U3mQUgbuZ2yGF2MPyVi8cI=;
        b=OdpxYBWnIUJBhjyk4S1/tPGTXfFnBxGopC66EFYR70wmwU1h+4w6CuVxcIeleDArav
         GNUaGcpE4nOSNbvLojivb4jELLQ43sC0YbnryP6dHFZ+FTesbUgI+yZm95kIuiTHBbVp
         BJHV9Fk2+h0bI7TDmuWSWJ/xiGNimYolJ7brXzYjndSyDe45L68e5HNT+b6QDhx4WLtd
         /bjMibnEkmXtGlW8qQ7B4XW4kErzwgUUHfoDNc3K05oqrr+kwRNpGFS6N2UDUeZfU/L5
         TY0Y4+blurk+OAOsH6aU3DbJqL42Tio+2hM3DzQtzFEjz3gExR6nnbhvOQTwq+mtOEVx
         4clg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783985900; x=1784590700;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WbeC0G2r0+fJphZIiEMA3U3mQUgbuZ2yGF2MPyVi8cI=;
        b=rBZRYhaxC85U88KdfAFFXXbk1BkkoHYeJPt8xQgsgphpPwLGJYAnlJgCtJZJDNUmeu
         OZYTHabGlJMjTH1KNEZqnMMDWsxEbP6DQnlIuDhWH08vz0QG+EL3vlifT6arQmYU4x/9
         2Xp0QGh3EsBkk0/kDucMBFADC8CdkjVV3lzjShVnYTDAc+Kritv6rZt89De4h0l1Z/CU
         GKSWSGDs/Hc0+MB8SEhOzVbTuPcVauZedZxUkN+UxZ1mL+djIqdTgVJgnWHoTaAhxN8M
         j38E3aiF8d18DaLj1X5zLuCvXjS91JbjkphLGvcZabIc3eaGKaQohX5JwgorSum/3lBe
         3VLA==
X-Forwarded-Encrypted: i=1; AHgh+RoP9eHRrOyShZpiYHHk2yUThS85d73CyeokE4GTPiT0E+gJcSs96J3PmPJEipQGt6lOJBKUPzz2Dg==@kvack.org
X-Gm-Message-State: AOJu0YxsnIJixkI2KsaLDsorXvON6k3iOlVh5IHI5HR6avAcsJRmYbjW
	mHFZL8pL9bWIMMDn0BM/2hS5R1yuI4NxDsSux/kgCTfTFiKMU8dOcsOfno0hWPgbf3K7OdoEvuc
	DxjYA2WF9sDJ/Mf9unk+RwH7U+oUCKHJcO9YTpuzU
X-Gm-Gg: AfdE7cnCZIqr/5Bee3JzCHCI2k3uOSbmoMBH2SdzKh8HuPJ8/vX4QxISTl0pFSp6JrH
	Lj0lmsWDFOj2Zz2lOknvhxEgtcMsCwmpEEQWXA4qX7vuaDiOSLrxErsnjyw+Q5/pBIjaLSrTLUb
	sxXkBKJDtsAqu/Cq1eMfmmBJeUFPN318/TJq0Jk+bSmGO8AKgwVG3nTnOKoa53RdpWUqZq+SqV2
	Edsg4yVuHpkf03rm6KixfpdWdahL+53A1AtrSdiewZx79EkwuXxbxokH46XiXUXZcIciMJ9G0QB
	+ylbUjo=
X-Received: by 2002:a05:6a21:460e:b0:3bf:bdb9:f602 with SMTP id
 adf61e73a8af0-3c1108b79bcmr11388010637.22.1783985899795; Mon, 13 Jul 2026
 16:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260702174033.32116-1-sakacpav@amazon.de>
In-Reply-To: <20260702174033.32116-1-sakacpav@amazon.de>
From: David Matlack <dmatlack@google.com>
Date: Mon, 13 Jul 2026 16:37:53 -0700
X-Gm-Features: AVVi8CfY9nmLyptjh2AyzFeGNNgc7oKcQvO8AS5RIIVcrg8HsCOADDuDwJVvlPw
Message-ID: <CALzav=fJrcaOFbP-rpOPeRNW59e0mXCgX120xHPnyrpvNH2JgQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] driver core: defer per-VF sysfs creation for
 fast SR-IOV bring-up
To: Pavol Sakac <sakacpav@amazon.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, David Woodhouse <dwmw@amazon.co.uk>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Alexander Graf <graf@amazon.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 50F91140009
X-Stat-Signature: 4yof4er6nrsnxr8cdydioq5nygqn76jz
X-HE-Tag: 1783985901-228443
X-HE-Meta: U2FsdGVkX1+I82Ab5ARH13zy0hQTRxIkjhZYUVVl0vCvVFhy9+7T0InBr86BVc+nxIDWj1WrhSaT4nO6w7RKdnR/k8/v6+eEB4b/mBgbY2VXPHSE7bxTbgrVhVdJJrPNJLLwqKTv7EaIehIReD6iFV344C7X2Rvmi9zrURnz3xzt/HJXUgYPqVDh5sMSpHBHoxPHjeh5X1rS8MiFfPigGC++H4CzgYzj+Kn8zOIb7Ahw27NzJctEVQREofL0fTHEyFpZYrPBtNNLUwIMz8VmVZZShZ49V1vwsFZ4gtUrRg9KDEKR7VIeaZps0khGroMg+6TnhEKKEMBx2anm+qHwuphWtnEpWDrh7MAm2a5jFjIv+1r/XCBKF1fFg4ewLnPvAxwAzLm5aEOBAIwzAy/K9tZw/nT7acPJlL9bbj7Bqeto1gRXM2kL2QSB8Pyl2m1a4eEJes3Pzdx3ZNSgFHEMLk99VlfXbnE1m04INPkpvFzDKsEgvkJlH5k07Wzw9fNl3P8IMPCQU41X6Wp32SOzJJLysaMcno/EKprhzZHVZJFOKkKJfP/knEik1T7HTei3/9by9NTQpD31ZUunGeujiW551r7PhQephAh71q9d/pW9gcVnGy+2ZLlxINnstYnPHL2DoFzQ3EnQe2yiMR6Kg+98+dels7m3OsvYCvNtEeT78BNnyNHdvr8vDZH3iF6GKjCyCPdOQ8/4LfBDoCPKPVG6K94A2wYwlaIs2fvKHllWwQ/HevFxtmgrq7HDUOnSLb3QOeo8ehc+BOxGrW0ac1OYYFBYsrfaFFO3zSmm3A+l8APObQ+cJC4XnLu89vHWiD4d/zTbnPPLY3iM7aN0Ol7o9GKLa69kbAxfuasRfAmNWDnJjUhUmf3ZLS8EDraDb+fJ7w8CUBzutcL3ZvkXZCrjGOpQJiygkkD+8JV1rIHKRqf99a6sATEXxncS92jT7udS84cLf4pNDUbaQ9x
 lPZE0fAu
 TFOLQJdSDl/OQwqIyGwtUhOEjYyS2GaPMoD++fKr6Q7NI0LkZiO66kHHH7L2wgYx7b+qWoWjBqB+Y5a2UJEDE7ggkki8U5wVj4l08aQd09zRz6ML89HbPDtppF1Rp671exoDbtJ0pIN1USJHFt1X9jV7H5zeZKGeP9fAvzrAh+exMMX0Io4O4SpdpnDv2NnwrvoYsJfxrlsQjgosVgkInGJ1G070c2d5zk1V/ettcpZVFukBwa3RYTi/ZTLJgOGRptZhR90fBiGOR6t0XkoSm8jjAktQTc7ZcfEjk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 10:40=E2=80=AFAM Pavol Sakac <sakacpav@amazon.de> wr=
ote:
>
> Virtualization hardware keeps increasing in CPU-core and VF density.
> Kernel is trending towards preserving VFs using LUO across a kexec
> which will put SR-IOV in live-update hotpath. VFs must be re-added to
> the sysfs tree, along with its supporting devices (e.g. vfio,
> iommu_groups). On production hardware a single VF can consume ~80 kernfs
> nodes. With thousands of VFs on modern hardware, hundreds of thousands
> of kernfs nodes need to be created, which can add 100ms+ to the boot
> time and to guest downtime.
>
> Proposed here is a PoC of deferred materialization of sysfs files until
> first access to avoid cost of kernfs node creation in hot path. In the
> reproducer below using a synthetic VF to isolate the sysfs overhead,
> the per-device sysfs-creation time is reduced by ~74%. It exploits the
> expected access pattern of hypervisors, where only a subset of device
> files need to be accessed to attach a VF to a VM on the hot path.

> Feedback appreciated for:
> - table-driven attribute refactor targeting common device add path /
>   suggestions for more efficient/less invasive approach
> - mechanism of interception in kernfs, materialization, locking scheme
> - fit into context of LUO - complementary or is there some other
>   mechanism already considered to mitigate the sysfs impact

Preserving VFs is still on the roadmap [1], but I think this would fit
in nicely.

My plan is to have the kernel keep SR-IOV enabled on the PF throughout
the Live Update and remember which VFs were preserved. The next kernel
would still need to create all the pci_dev structs for the VFs, sysfs
files associated with them, etc.. So speeding up the creation of sysfs
files for those VFs would be benificial to reducing the Live Update
blackout.

I have some questions similar to Greg's, but I will follow up on the
thread he started to discuss.

[1] https://lore.kernel.org/linux-pci/20260710212616.1351130-1-dmatlack@goo=
gle.com/

