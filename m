Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D360D25954
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114486B0088; Tue, 27 Jan 2026 02:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1E56B0089; Tue, 27 Jan 2026 02:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02CE6B008A; Tue, 27 Jan 2026 02:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA89F6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:02:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86B56D3FA3
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:02:03 +0000 (UTC)
X-FDA: 84376849326.10.4C54820
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id D893540008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:02:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=U7MC0Eee
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769497322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/eYheXWIcYmrXyOOF2pOYIDtvsZl08ZnA+sCoFz/7Y=;
	b=h03weOu2z+NmMhnQySnrDyZnWWKkyp4+t7X2Za5C8jJ5/yhqB1sa4AYCScEalrV3tUBSew
	PPgdzuvbKr50fMjEnRVDAPR0RIeT3ZgqpYyDOQ+xwwSXLjp6/Zq3hmybponfJc8xRW9iBs
	dSu9PY+a8F/Lo80B1Lcp86tqN4LPv5g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=U7MC0Eee;
	spf=none (imf01.hostedemail.com: domain of eppesuig@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=eppesuig@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769497322; a=rsa-sha256;
	cv=none;
	b=hn+IVX4UnvfPsAL3WQys5Q1gQaaKG3OFo84YobM6C5DbK/cslekUzO/Cs+LK61ryn/8DbI
	ojkuBjVQ2oq31Ow9+qGPhXjZ9VZoBrHdzPNZnh5CbPup+6YgZx06UTmCUuqNYUcGlODV7P
	RSbAU94FUZCVMphnO+XeiSIWOvUN6SU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:MIME-Version:Content-Transfer-Encoding
	:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:
	Reply-To:Content-ID:Content-Description;
	bh=E/eYheXWIcYmrXyOOF2pOYIDtvsZl08ZnA+sCoFz/7Y=; b=U7MC0EeeyatJCV4yWkPw0hKXNB
	mXO2Ofo0sddgWVbAc4w2tfSBHHCEdOzuH2WijgrlLIzBcVjbXWhFHHEvYEFEzgeX4NLMibAQq28ng
	ZtOZUFOWCP+OvlAbTeZIv23xJ0Z8hf9qujCT1eo8CmE0ejdkInGhrwT/51WrSnnZINoDPVD/FWL2x
	rq5txjppgBH5e/zaRq7qC1DD8lMl7kdoji0d60thsnfuNtmh/l2wPkS4zHucEuSa/wkDrApq5SLsF
	xar3VWMaz76M+qqbwZBX1HDKg+qs/e+m3TbELrH/3uiqJUWs8K3maT3YILWB5INpTrZEr29XuI4PR
	wzgOCLsw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <eppesuig@debian.org>)
	id 1vkd56-00GoQC-W4; Tue, 27 Jan 2026 07:01:45 +0000
Message-ID: <8f8a478ba50bd43d30704f0d74e02058810f2795.camel@debian.org>
Subject: Re: BUG: kernel NULL pointer dereference, address: 0000000000000000
From: Giuseppe Sacco <eppesuig@debian.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Salvatore Bonaccorso
	 <carnil@debian.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Sudip Mukherjee	
 <sudip.mukherjee@codethink.co.uk>, linux-kernel@vger.kernel.org, Andrew
 Morton	 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 regressions@lists.linux.dev,  Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen	
 <dave.hansen@linux.intel.com>, x86@kernel.org, Hans de Goede
 <hansg@kernel.org>,  Ilpo =?ISO-8859-1?Q?J=E4rvinen?=	
 <ilpo.jarvinen@linux.intel.com>
Date: Tue, 27 Jan 2026 08:01:43 +0100
In-Reply-To: <CADVatmNzTyUAr8UBvm6pHFsKz8xZpqUXh5NQR641JXsCWaPg8g@mail.gmail.com>
References: <6ba903ad-9897-42bb-8c2d-337385cc3746@molgen.mpg.de>
	 <db387081-345f-423a-a0ff-e13f3bec2d51@molgen.mpg.de>
	 <CADVatmM_mRnkDX=hpUjbyKkZnGynxJfRSujGxm2LaWWMEL_2ew@mail.gmail.com>
	 <ef9223ee-0a4e-468c-bfd0-0cf190d262f1@molgen.mpg.de>
	 <aVgjpWaIRkerdgCa@eldamar.lan>
	 <49cdd663-bcbd-48b4-ac38-77ce94ef0c8d@molgen.mpg.de>
	 <aVj-mz8vaw53TWtX@debian> <aXHeLGr1n-W-Ay44@eldamar.lan>
	 <CADVatmNzTyUAr8UBvm6pHFsKz8xZpqUXh5NQR641JXsCWaPg8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-8 
MIME-Version: 1.0
X-Debian-User: eppesuig
X-Rspamd-Server: rspam12
X-Stat-Signature: rq6d6xbedmsoccsaidbqcurccyctk7t7
X-Rspamd-Queue-Id: D893540008
X-Rspam-User: 
X-HE-Tag: 1769497321-453272
X-HE-Meta: U2FsdGVkX18QjPjieVhTbmRMbX0pIK9bbAn/7DC9CMwm1Ynlt2LJGlENr1ZHedSaQdtvWmIhhcyraSPRzHSxwlFcYbsCy5ULxbfucrhZj85oeDDwG9x5bjQyxdbqaFRq3FR9CRZPZF2waRNev707KVyDAQH+Q2wsxzV2CRjUT6HEcF+wcIYIdEwB3PR+thGRjNRqqx+gKgb7Oguv3/aeePMdfdGjHbWNCbjtWSEhtvDTINhkSojPFzZ3jQhOwyAnuElmjMZirYenDwMLA8hYOut2EehQC84gTXolHoiIOdZhFxJQN/6bFhQ7qf5y7nKBGszx+ltKSpDkmH1M9H1I04zMdlH2MDmujlM0a96NZtSCOEtdJryY3mgeM95WB3ej6J9bK1W60CkY1aYoGg+fCOL3DX7Ryt9GrWsxq6Ug5dXJrVSRmQIxX3kc7Rhcnc5CAFdf+5pQmQk2QiH7MUAazUjmsbT78+N+VmfHxwGDxG1rYo7Ye98UKrgdMIXv79yS/0ryg9ibRKnbwHTXCZD2cGbvyCwhzfyw55RH/M2WkR371rp+NMkw0FKjcCcocJyTy4eM5Efnmkq+l8eeeBtQ2XVuI0yZymYiIIOzcH9irSR4VQkskVS2ZN7yS29a6hBeY17Xz0CStYbI7zfoV6CrKBbDGc+OL/1h2/Gkw1jzyDlz5J1ijE3/9qx9DQF+hsf0CXoifCN2bW2h78rPObwNigvw+XC7XIV6NFl8wl0YHDdW2wLMsTj+2tdMY8VHcgRrmGoqyv+p1kKM0UZxym+611EhV6VnHb4SMqLRCNrVMLHrMVoADJqemrMksX5VNpZ7kO2pN7yjWcsLYdUrkjKf3J9t1OGxFZTzcs8rcGtsQ0M3xn6/gVpsf9bOppKe/lvE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sudip,

Il giorno lun, 26/01/2026 alle 18.56 +0000, Sudip Mukherjee ha scritto:
[...]
> I was going to post the patch today but since you have asked the
> reporter of the last bug to test it so lets wait for few more days.
>=20
> About the problem showing on the first boot, does that mean that its
> only seen on a cold boot ? and not seen on reboots (reboots without
> power cycle) ?
> Can it be reproduced if the system is powered-off and then powering
> it on ?

I am that reporter. The problem appeared only once, on a laptop that is
never just rebooted, i.e., it is always completely powered off and
started again after a few hours. I've built the kernel with your patch
but I would not use it until I would find a way to reproduce the error.
Sadly I was unable to see the problem again.

The only hint I may provide is that the day the problem showed up, I
was working in the wild, at about 10=C2=B0C. Maybe this has influenced the
hardware response timeing.

Bye,
Giuseppe

