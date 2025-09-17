Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781B0CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B3F8E002E; Wed, 17 Sep 2025 10:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEABE8E0003; Wed, 17 Sep 2025 10:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9488E002E; Wed, 17 Sep 2025 10:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67CA8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:48:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 482B81405D5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:48:48 +0000 (UTC)
X-FDA: 83899023936.03.CAE6778
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 54EEE40002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:48:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fbXBvLN2;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758120526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQPUKsmAc0liILowvxQAIT6pnimYT1OvWOFQs2iiA4k=;
	b=Tvb/VO/LReGYp/QBd1TAcTFbiZ9IW2CjhFHFLiUjJ9wrO4lp2m2pcN6E9K8Vb9dBOcYjPA
	dXRT+zR+SjaK6HCl7G2eMm8Rko9zpf1BhE3hkkA30ZTUanY6C8BaB6KkiJ+j0W3/aNfGjz
	cSli6fYhQWDFzJEH5+daOHhlkb15D0s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fbXBvLN2;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758120526; a=rsa-sha256;
	cv=none;
	b=QCrE3SnxzPtrsWSKAfK5EpJoCZPeS3lvuDOHTWeJP8ix+8vFNB/O44V0o7+dgb0v6qU6tA
	EC7wWJkhIBIdt88GK7e8fe8A8M/agW1Ei1HzZDVAsek9jaQl3GoWDtA3TPZ94rwMQL9ywp
	8+tuBbHn0++2fW5MdGfo9H7X1gtMHwQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b48eabaef3so68762911cf.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758120525; x=1758725325; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQPUKsmAc0liILowvxQAIT6pnimYT1OvWOFQs2iiA4k=;
        b=fbXBvLN2ZB2J7delks8VE5aeUPvyIDFy8Z9TPMF4xZdwhCZA38hwiyBzcPc5/jy9G9
         r4373rwNjuLWsuDYWN7TSIPoUt1ibP3n4MCxNsRRfQ8dd3R0v9w7bn5GohT1Vb16Ez7B
         pxffm9S1fvukJETINQVsBBZNIyYRbTCfAsgOQHU+8RjX/5Eog0Jo0wNxTik/T0/2O4AK
         31t4enfvAKx3kNZTO94iJj/wtRj4j3RuO3LzcK44o+RrtaphZVux+iC0nu/dOs05jUUc
         obuuOWb1EPYI9u/ZiV0NYwMC9BJuiumKKSOkedTlzKK6nQnauaIQtbq3ym0hsDw3YrMR
         1Jtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758120525; x=1758725325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AQPUKsmAc0liILowvxQAIT6pnimYT1OvWOFQs2iiA4k=;
        b=Q8aeoJ5LnFUZWtY5cEd9NiBWkWdTaksuJxoo8MM3hw+xaYD9Ph7snGHyMG9cS2UhIg
         hMU3WtriEqYr+5zejrSM8PecJT0hZNbpLSk0q+bDlaJSZ2k7Ott7lYU5TQZMxUCjqWOm
         iU/UgMrrR1LCfVOFo8Rsn+P82hPoZOsGksQrn8pFMO8Ciqw5GQID0+MKBU8W4Ve1mrpG
         2DQB0OnxD6QDGzTIP66LhVSC85ik0GRJc/Pbw9f2SFlCyKljC9Y863UPR1nBB3U3dtHK
         EGPinc2gYs344qx912dwpi6kR60T9lP1EKGE5OMJXP1tAM9UPm/Dbe44Gqb2lZr9+rzI
         Kjdg==
X-Forwarded-Encrypted: i=1; AJvYcCX7FmkcDYBQGLMiUQBP8Pay6MgElOL1QWFe7t+FnOuMzOwiTbzjeJrC8YXezBd+C9p+lgSHhEw2FA==@kvack.org
X-Gm-Message-State: AOJu0Yw0tfc7Br/D8kTrVFG/azkuPMA3pQMmmtzqbCad6XKToGkHdrfd
	jK4carzX3c0EhpCk6IF4iEUQFIq8MQxYTQwzFitoJONJCYAR9fpCNkL1dydncZe/pBk19wa58kU
	YzVQlRqdFRd/r+c4rhbsLQVpT8Sl538gmhd2Gbhi2mg==
X-Gm-Gg: ASbGncuqkdSxfhL6Bbnep5V7BX+qvJ/YOXZQ/KsGjeQJUcsRYKyh/6H3KEEW760YOSB
	c3LefEYaTR3cNrWzLRctQH6ojeMR2NpF3g/qfCKeMdGH0xH7xxS+HA4qwPeqvgnxRhDeSm+6nsV
	2iUizjr9DbEJolaDTO7Gvb2bjQI/SJ0xNU6P6Fg1/B+1KhX6lnFsNOFePmiJ6EQRltLZ63P1UfU
	cwq
X-Google-Smtp-Source: AGHT+IE79GpXyjBV89Avr2S09fmTlI/L2wNAUrwa2E6+rwL+V03nJN++UHPUWlE+FIB9aveMjDTolm2gyToXUS/Nfzg=
X-Received: by 2002:a05:622a:5446:b0:4b5:e9e3:3c90 with SMTP id
 d75a77b69052e-4bbbe28e2bbmr8185321cf.9.1758120525123; Wed, 17 Sep 2025
 07:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com> <20250917113609.GB1086830@nvidia.com>
In-Reply-To: <20250917113609.GB1086830@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 17 Sep 2025 10:48:08 -0400
X-Gm-Features: AS18NWCrgaurUWlppllqWMXv6puRwIeZOjcCB40WylsCdUx_uF-Iq5DWN0oZ-N0
Message-ID: <CA+CK2bCV-UbfDb=QmyJrX3xWMToCO5b5a1R+Px5QOXafF_AqRg@mail.gmail.com>
Subject: Re: [RFC v1 0/4] Make KHO Stateless
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Joel Granados <joel.granados@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yxgg4419me639hckm11ukq8t5rokqbp4
X-Rspam-User: 
X-Rspamd-Queue-Id: 54EEE40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758120526-394334
X-HE-Meta: U2FsdGVkX1+KJK64C4GUAE1yU+67MbTH8cFluV1rYjoh0G/f8JTR3XpR1gcnaPtMLUMOybodPX2th+0l8lbmvqm/5NKNZP+Vkb6qVaqZjoFaI4tbtjAD0G38MBMaGl3TyXyqzDHi7t9MSuwK3m1gq+6dL1xlExIADruHDbP2oYw8mehlFJL4Ecl/GYtc0iSaLRqOpsAPKqhv49FeBZIHVUG12gV7nJH/QO/o/BthLoI1eHlZVaI/cAkgMoOi7XTbFOUohhpCxqZJMMe21uNMNCUFZkPlzTGaP7APM/hTyRyIob0pw+pQfCksKQVaJ3uyVOZ3lTuUdMZ5bGVZz7AhICxHkdLJALcZwYJKZtdPR12J4cXOt786B466/akGm18koQAdD5aj9q8wqHsjHKz11GUimr4YuqgFCZnE0e0Yo7JlxvyHsrf6be4btRHIwrNc2I6ggGWUUAgOBSdmaSTc1OEA7Z5MAt950AgcPiTKcMK7vlNmjn7xQyKKezpv+mXO6EpJf+Hziz0X9SMF2ngPDpRJ/6PMpmITKgH2DKyhZOWZ6sxqgX7jBavwcgBmi+7GBYTeoexvtBoUO8ATP9ukBZfoYjJ+VXMrCC/g8FxuDXPzYiL90A4N7LiWVQNfO/MPZn8JL1HRipaQcU8r6Lb1C6miEyHpmoxzfeRDpGqCVRS+Zz++deshwkwUHi61e/cpyEu7bDwbQLpGQDREIx6spSsZjlM4PiyffHsqN4gVPQ9LChJS24KzNSXp0apWlgwDOYtNRk5QeR73j4W24sgvDvv6XYTz1wh8bOQI6RjfykSLjPoYE12xQ1CAlbP+HkPk813GjuQpt21CV+ps1noHaPePED6/yuSPglOYzb2I/RpcgCp1pJ3hjgxwz3SRrBdDPy4aFIDvKvXx6FgIS3wL7aYsfHKFdjYARbbAAEq36XBy80NguEiosFe50IQWquB0KGVF4UCjrVfisMuPMak
 QY52KLIS
 oxj551EJD6xE6HKSlo6Xx9rhJnUQcSxuxe5v3qyx+25fJNbxvx00eDoaz5mWdcfQStTfumPgtRPr71tU5Re+14o3ci7ap0I4zrC8iQyGoV+N+1gn75GNiQ/hHd7qCO9aziB1xlra1iI3nP4DrSexAGOlIwml5kwldqKVF02LQHNzZy5thHn8ntaycKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 7:36=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
> > This series transitions KHO from an xarray-based metadata tracking
> > system with serialization to using page table like data structures
> > that can be passed directly to the next kernel.
> >
> > The key motivations for this change are to:
> > - Eliminate the need for data serialization before kexec.
> > - Remove the former KHO state machine by deprecating the finalize
> >   and abort states.
> > - Pass preservation metadata more directly to the next kernel via the F=
DT.
> >
> > The new approach uses a per-order page table structure (kho_order_table=
,
> > kho_page_table, kho_bitmap_table) to mark preserved pages. The physical
> > address of the root `kho_order_table` is passed in the FDT, allowing th=
e
> > next kernel to reconstruct the preserved memory map.
>
> It is not a "page table" structure, it is just a radix tree with bits
> as the leaf.

To be fair above it is referred to as a page table *like* data
structure, but I agree kho radix tree sounds like a good overall name
for this, and it might make sense to rename from kho_page_table to
kho_radix_tree in other places.

>
> Jason

