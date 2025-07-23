Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A782C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C59B8E0024; Wed, 23 Jul 2025 09:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076A68E0002; Wed, 23 Jul 2025 09:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A428E0024; Wed, 23 Jul 2025 09:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D30578E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:56:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A39D1A070B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:56:36 +0000 (UTC)
X-FDA: 83695679592.08.E1A8D33
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8478114000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:56:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=KX6jUStg;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753278994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Neb4DMdHL9YN2qZdu5HnMhnwFlw4q4ExiBgUXTApsC8=;
	b=qvNn9mlVIG/uDug5N6OYyb3aZmvFfElCExztd40/FdXRrrAR5Zmi4kn6wOUkqK5H1it56X
	vR0nt5mClcGVTz5u1rTIvhh8RQPmP1LsMli/SsSNogMxkCCdeZEjmRiRae8MeVNFxUXdFh
	m6+0ea9+kWR9SJDeDe+zUijAg7n0D4g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=KX6jUStg;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753278994; a=rsa-sha256;
	cv=none;
	b=uAe76xG2+FNUbhnH3o91Zu/4Wi1sn9FZN+DtvWECY2CoLTtJSdUeTl3+eGM9Y54koRoKnU
	Z6wqu1yPdpvI4OCPVZuc9wFxXkAau5FSQUHItpUzUD7EL6nXvOJ9Ipq8T8YSsMlIam57u6
	ZpkqHrghVDGa89w6Nn1V1z8zgSrXA6w=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab5e2ae630so79934951cf.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753278993; x=1753883793; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Neb4DMdHL9YN2qZdu5HnMhnwFlw4q4ExiBgUXTApsC8=;
        b=KX6jUStgVgeytV0J2gsRWGubgeAMR/raJAv76cTGbXbCIJX39KCu1DTC5p7A3ZhOmL
         HBTzXocMBo8cRgyZfhjR70plDsVcJLcC9U1zZzysPbA7dVbqeZeNSE5xgfWokwgozrZq
         60fqZ5/PDb70hZ2Mr5sQe8QsX9rwX6fX4SSOg4kD6qGWREChODAU/1VczAowP/smhz6Z
         R8NZzBA+Wd2ya/EgQPPRImcep1pCSATy4O1FrKFkpBPNOCFAPBcWXxf5YL2vTCX2vuJ+
         PB6DcCdxCADnD+6Nu8m3jTFbBLtuBUSYEFjLHdPrXmrIBVusqwX2AWEy47l3h1beq8WP
         yItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753278993; x=1753883793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Neb4DMdHL9YN2qZdu5HnMhnwFlw4q4ExiBgUXTApsC8=;
        b=fXNE0A4DX1O8GZ7HRHZUAFbbVP6qLckiv/w0mu/xbIbHaXzNgIULErumY31QYWd2Be
         VBfFyxwORpTxLnGKKKA3+Zm6Oe038biAu7eTCGp0xL+wg73eO6eSFH9XiDCPC7M+D2Ot
         N7Bt/VElQiTWwvKNO5FQ+Y0TsrUEqlzEGaRNdVw7lr0RFs3zdpYws7D14hPxOSRSUFal
         rQtnusJVeevBi1MPdvvNGn2h9+S1b2TfuCsnXzLHiMPNcbGBgC+zngLuYb8sFXitToSU
         jIi17BsPyE18FKb/HIBOSlAHyrhoyyCY9iQNrxAiLvlY5DeQ4rfdCUkn/4x3HMPZY7D8
         sLxg==
X-Forwarded-Encrypted: i=1; AJvYcCXpIGft3mXYqylL0LPpkMnMFQKfVNLGae/kB6aaFczb7Tldoy/dpEZg6atR9907nvt/aZBVHwKjJg==@kvack.org
X-Gm-Message-State: AOJu0Yw2OcK4s5hL6BkxCljxWnPQZ4UQuVx0Vyl3BikU0AzD0NBZx7gp
	62oWyURssdY6VaCk462vU66tmqbpvYS9NvYDd6rRDKnN2DHTr72k2+EWrm8aGvYf9cUt9QAyG+8
	k6CqZZwfjHGjCorMAIyz0Heimp45hKu+AdNf/OC11nw==
X-Gm-Gg: ASbGnctuCWg2LUhH+6uqyP15CiD2dSXR+73K3R1UIM4D0x66AKC0fvsQc+vM0wEGfFe
	ahGIhJb4XlRJnwzSX/vd1mM9ClTqQksMxkn+nMvJvqSdpvO7/yS2Teo40jGIC6oH5YPNbntXrTb
	c1xg7Eyx/rV2HR0ZwMY9RoPn4T2UTF7oadK1lmAGUxbpfLZMcUkTr3PnfFhuWnqXQjqVhyAFoVe
	FqI
X-Google-Smtp-Source: AGHT+IGrYMZ5lZ4waeYztYzZWeus2W5lvUIGBJomoilBWhgY/xZwdg1u51Z0y6Byizn2RRUk43nSuTfOAFLec5SGqvE=
X-Received: by 2002:ac8:7fd3:0:b0:4ab:6c5a:1fe7 with SMTP id
 d75a77b69052e-4ae6dfc4f62mr48555621cf.52.1753278993220; Wed, 23 Jul 2025
 06:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250625231838.1897085-1-pasha.tatashin@soleen.com>
 <20250625231838.1897085-22-pasha.tatashin@soleen.com> <829fa3b2-58be-493f-b26c-8d68063b96ed@infradead.org>
In-Reply-To: <829fa3b2-58be-493f-b26c-8d68063b96ed@infradead.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 23 Jul 2025 13:55:56 +0000
X-Gm-Features: Ac12FXwxkGX-ZyVenfoKJwxXGBSrng0apcRfW2jRFbfKFQccJBpZH-g5RuQibpg
Message-ID: <CA+CK2bDi+urd9FRftrDn3bwp2VCvb1f3rFsD+dhegLrMRPC4Zw@mail.gmail.com>
Subject: Re: [PATCH v1 21/32] liveupdate: add selftests for subsystems un/registration
To: Randy Dunlap <rdunlap@infradead.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, ilpo.jarvinen@linux.intel.com, 
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com, 
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bizc3ni5r698gyb4rohoi87r9ythmk6m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8478114000A
X-Rspam-User: 
X-HE-Tag: 1753278994-902979
X-HE-Meta: U2FsdGVkX19qBZNPLlZELdE9UirWMj/+0kdw59X8bWEl8AA+DGcIiOrvUBSsMFSr0C+aVlgBS2CMCq0uwdrts1+7rNnyLNRMvXcapf0q1cgCgmjoHEbYw5zDQybodsDBHBEtoKrLjO1fkgf/8oHQhxfl5uqyaPn0JiMltbkO9wbfX+QIWqQGY3cL1s1a8rSaPL/ozw0jU3qNemLCh5iZbPcQyLSAzUGawWJQ+r9qAT2vA7qOVxgwzgQ8LJxzHfj8GxHbCeA8EmMu2GBNLQPvgQ9VRp2g4LedZ+CIoXPvS8CvFRmjujeSA/HxeB/hw5t1Lmt7LRT8jc5rbsZpoIi6gny37WnQxXmjWe1pjgOOWyuLWi4MdQKCFYsz/hIdJtnHrNJ/3IF7QyCQxN7F94K7Y8R54rra1cJhG9G38Ti+341CXGvKVnjGydOKkKncvXZit7Y1xLFuknjkajMj4kJm4fOuFxZlaUXTbhJJTakt44Uco16Zr04qxQKyIAQE6d7/x5lRfrzSmYA1QCZpZSBdohJFkhpaUkmtCWbm2jATmWjHR8rNzo+oP3HbF1cgAYB7M+jZN/a32eTtdpsa5GvBys6mVL85pdnBCF204LmNektkBsX6xJ+tHU5SOSr1b7MDo/U6bMBfGWsNtxSSSz0yRtirxUeZog48cMpUl8fErz957r6hLCnY7Wsgf0DssmG2+7QHs+AUpgGHD06b1KO0GC0Mmu7dK5bkpLRQdItAMPJ2K3Uwn6lDpQemRM62cahO5huUH6pRNxQ7uVvg8aaRFGKbEOPRrO1Rm77VmIjbnomz8rJf5jBEYqLmNQdGWCqGELln5eBIQZMClg9zhSLDY8qRxb2PWfodsY8VeDuQRwiA6dZrBzCOWHJmJSt11GFdwifwCwfevTRIdilpO8VobT5cF1+xCcv6OK0OwE1j3bikK09nDkPHxmraz2EXp8kWMbkePzZmY9OS9ZKJ8f4
 7Wp7gX1U
 XH6/PoEuNtuchvbW/AQGzKEuJKVoHnNuCdrjwePrtxQhlF0S6e6fQoW4w1W5OsKVbH4a3XsF+glO2nVEg2Lg3x11JTaYzBnF3LSVZd0hyCsS1CE+xhLXKxtCBkL8LIyHxNkeOcuDA443TkLo3DSzK7qqaf2r/+NQxS27gdhKjNqFhPcMfUd27Bs7zjW9bWUHZFgqAx3B5+dDdSWFAZGNDK7xd+i29TrHaiSpWH/UgXY/kEBUidaTCgDIAi5phzjDffM0sShSUs5KBYuuaBsNtgueQU85O96ehYR/1xzcBBfzuYAJ6KqIuMEW4qgYF5quUSAvhJ57HoPbHHQZsM6rXC1kAb0P7aELbyjVN8RtRro7IfKE8Y10gJHgY2v3HUMpnFBLspTieU5aOdTsGnVWRClG3Bdy0K+s+4H/273S/aqspfHTIW552EtpizC/KkS7b9jvmEMmq6AyyZPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 26, 2025 at 12:06=E2=80=AFAM Randy Dunlap <rdunlap@infradead.or=
g> wrote:
>
>
>
> On 6/25/25 4:18 PM, Pasha Tatashin wrote:
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index 75a17ca8a592..db7bbff3edec 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -47,6 +47,21 @@ config LIVEUPDATE_SYSFS_API
> >
> >         If unsure, say N.
> >
> > +config LIVEUPDATE_SELFTESTS
> > +     bool "Live Update Orchestrator - self tests"
>
>                                          self-tests"
>
> as below...

Done.

