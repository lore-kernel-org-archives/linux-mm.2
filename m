Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64063C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 02:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069FE8E0002; Thu, 31 Jul 2025 22:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041E08E0001; Thu, 31 Jul 2025 22:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AAE8E0002; Thu, 31 Jul 2025 22:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5DA28E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:46:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63CAD1DD673
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:46:38 +0000 (UTC)
X-FDA: 83726650476.23.337D219
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 05CC920004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:46:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=NR55NY2X;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf03.hostedemail.com: domain of efault@gmx.de designates 212.227.15.19 as permitted sender) smtp.mailfrom=efault@gmx.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754016396; a=rsa-sha256;
	cv=none;
	b=qPPr+EAWHalI+jZmP3M68e+a2ZIVF3iXGI3d2jqgCVJC5R72J3SfjUgpVXcxxOvF0hPCBf
	jIhUWQpc7x4f1K+JYwUPaJf4AMQOyMwg3gRHHjqUkct6ZEapAwdxfsO+Fk4Xr6j+e+jiAR
	rTkJz8wiLgq37XV2OCbOh8GqgnASKQk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=NR55NY2X;
	dmarc=pass (policy=quarantine) header.from=gmx.de;
	spf=pass (imf03.hostedemail.com: domain of efault@gmx.de designates 212.227.15.19 as permitted sender) smtp.mailfrom=efault@gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754016396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZjzgheKUHHzd1RZo0yhm7HuB0fzrr1IWLPKAHg38yQ=;
	b=Yc1CS127Qtc6MYrgssMo/9iSi8av/COYZa64l1IuGV47BsBNyRHjUqIITYQ6B+Gdo3a3M5
	Lppaai4u46Hpx6TEk5MOl5pgEYMZ3H4wk0uN/MHLn/sNOrRjp/tjVJHGERvZI21OKBw3p1
	zm6t5RuqDUQLbXK01FqXE4duXuAHWDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1754016386; x=1754621186; i=efault@gmx.de;
	bh=OZjzgheKUHHzd1RZo0yhm7HuB0fzrr1IWLPKAHg38yQ=;
	h=X-UI-Sender-Class:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:MIME-Version:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=NR55NY2XmGM+B6hp8fDM9b9vOSKRRdnaVjzDc5WpuAQPmaWZpyXNZbBVBqQnfRwN
	 gHPMO0r0vZi92cV07Lrqt2by/KzyWcoCNkpwezOo8Khp5Rr5ohCUc+BNim/hfeHcC
	 Wua6IZsMPTYuueWp3g++22WFqA52CCaWRqxed5XFe82PVAnC20fMFzfg/0I5KbIZu
	 ap/PubPrJmsR+9KDjDk//a/6ZfQyi7whgJ4WEJ8I85TnrhFm9x3pQlOL+5aFKGWzs
	 K7gE+/YWi9Zh2M4HMJftYoNN5t3wq25OPt8d5Kt8nMWEkDHMlUlwD2WeTYT2LFMFk
	 RPxniMi+LFAhLSt7jg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from homer.fritz.box ([185.146.50.25]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbivM-1u5r8G11Is-00o939; Fri, 01
 Aug 2025 04:46:26 +0200
Message-ID: <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
Subject: Re: Realtime threads delayed due to kcompactd0
From: Mike Galbraith <efault@gmx.de>
To: Vlastimil Babka <vbabka@suse.cz>, Frank van der Linden
 <fvdl@google.com>,  Alexander Krabler <Alexander.Krabler@kuka.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, 
	"linux-mm@kvack.org"
	 <linux-mm@kvack.org>, Dennis Schimmel <Dennis.Schimmel@kuka.com>, Daniel
	Braunwarth <Daniel.Braunwarth@kuka.com>
Date: Fri, 01 Aug 2025 04:46:24 +0200
In-Reply-To: <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
References: 
	<DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
	 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
	 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
Autocrypt: addr=efault@gmx.de;
 keydata=mQGiBE/h0fkRBACJWa+2g5r12ej5DQZEpm0cgmzjpwc9mo6Jz7PFSkDQGeNG8wGwFzFPKQrLk1JRdqNSq37FgtFDDYlYOzVyO/6rKp0Iar2Oel4tbzlUewaYWUWTTAtJoTC0vf4p9Aybyo9wjor+XNvPehtdiPvCWdONKZuGJHKFpemjXXj7lb9ifwCg7PLKdz/VMBFlvbIEDsweR0olMykD/0uSutpvD3tcTItitX230Z849Wue3cA1wsOFD3N6uTg3GmDZDz7IZF+jJ0kKt9xL8AedZGMHPmYNWD3Hwh2gxLjendZlcakFfCizgjLZF3O7k/xIj7Hr7YqBSUj5Whkbrn06CqXSRE0oCsA/rBitUHGAPguJfgETbtDNqx8RYJA2A/9PnmyAoqH33hMYO+k8pafEgXUXwxWbhx2hlWEgwFovcBPLtukH6mMVKXS4iik9obfPEKLwW1mmz0eoHzbNE3tS1AaagHDhOqnSMGDOjogsUACZjCJEe1ET4JHZWFM7iszyolEhuHbnz2ajwLL9Ge8uJrLATreszJd57u+NhAyEW7QeTWlrZSBHYWxicmFpdGggPGVmYXVsdEBnbXguZGU+iGIEExECACIFAk/h0fkCGyMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEMYmACnGfbb41A4AnjscsLm5ep+DSi7Bv8BmmoBGTCRnAJ9oXX0KtnBDttPkgUbaiDX56Z1+crkBDQRP4dH5EAQAtYCgoXJvq8VqoleWvqcNScHLrN4LkFxfGkDdqTyQe/79rDWr8su+8TH1ATZ/k+lC6W+vg7ygrdyOK7egA5u+T/GBA1VN+KqcqGqAEZqCLvjorKVQ6mgb5FfXouSGvtsblbRMireEEhJqIQPndq3DvZbKXHVkKrUBcco4MMGDVucABAsEAKXKCwGVEVuYcM/KdT2htDpziRH4JfUn3Ts2EC6F7rXIQ4NaIA6gA
 vL6HdD3q
	y6yrWaxyqUg8CnZF/J5HR+IvRK+vu85xxwSLQsrVONH0Ita1jg2nhUW7yLZer8xrhxIuYCqrMgreo5BAA3+irHy37rmqiAFZcnDnCNDtJ4sz48tiEkEGBECAAkFAk/h0fkCGwwACgkQxiYAKcZ9tvgIMQCeIcgjSxwbGiGn2q/cv8IvHf1r/DIAnivw+bGITqTU7rhgfwe07dhBoIdz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
MIME-Version: 1.0
X-Provags-ID: V03:K1:dd9ml/xjV/fyreDw1IhL02nv3C0HFPR0UxyHbaThvfvbXeWPiz8
 sHhdz4k1uAa1c1IMzCy2kTvoParuv9jXitBur/V49W1xZFu33hiGg+/WLHcFloNVUruaPkK
 vY35O4YCLkp1ZPoJyyripwNXynRW7bjy8beWkTf4Ro9A+bREhF+eZs8EUiEMnfVCT8cB3dX
 qIrWEWdvDRRC2csWozmJA==
UI-OutboundReport: notjunk:1;M01:P0:TD4NESOZaj0=;24N7s86a8TZKyYSo8I5YjSFtw2u
 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
 4mKruFMLzFA==
X-Stat-Signature: r5eypmwscj5e7ubdriq8oe5r7kcfci3b
X-Rspam-User: 
X-Rspamd-Queue-Id: 05CC920004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754016395-479804
X-HE-Meta: U2FsdGVkX19dm60UutZYsFdJSRGPOnHqDftWzbOt8IOSggrUwuZ1Mc8irVy5PdhR5GWlidzyu0oiAikpIXMcjQqEkh+reTIB0oEXCf765mrjKUyhxZvEbGtgRwq3FJoBxLSM6uYY5oXA09jrYOwz0uxeOmB6XBWfY+1+VG1p/hXW9SpJMwfcoXWt9xiiuc/EKYrdsUK4oLOdh/J0yNeHFF8UAgrT9FyOZz/4dBClkpVZX9MboosiXqneE/jqpOaFa5pZgDu+TBb+DhoPSV2hUY59j7Qo8y7d1gsawcL/JReRdCtoDSraCrI4np0Ee4Sj1bHqt/GPef3kwRg2DKKEooCi9gbCJxoNkmiCaBv0/0htqLFOt02OvAfiFsh05OCUl2ZXjJNShuuUMkw+5WO23diUflWKQKGlxkkvkaJMEZaNq4kdSZNhwvkUKa/deuz2uIXiW8ure/SFN0nSvpCXtjzkTtgHATzAxWcfGGLB+wWBMK/pLwV2jljf5h+VvpO8ujgALc0+rmBo3eZ1pDFeN/LdW+k5Lf2Q+w8ZChgb7YlY+9lNXfym7xBrx0S7vuVf1ZfLdM4YvRb+xNpxHgL18HvhloVaaL8jhpjoG62NMHnzxJ75OWYbT4jsMl57Sj5WzWcfsaRH/sjUPExVAQBlgTUkKLCWMUOhY8WYJu2jraIU8VMSjIvNo8G0DZ6rwL4QbUnOTkTesMRxyg7C/xVlx1R8r2/WvpBaz14aAM009XlBJWlSMYP5Ucw6KOBZyvitKFXYp9eaFb+BlqWtRFNR3QLulOmhS41S64CWS++HJa7vsa/awZhCqx1BD212G90VF+j7xH1ytrg1InPQ3DyVbhRb2n7NkdVQylXVJSuo5g9i11+sO1QrGcVTnr7qTmCp/rClfM3YM+vVkWlzYHvOmS1Yv6USPOIgna/Xw1+UAw1P06wlZ+5pqJOrLKvkqvXTsB/njG4l0y/XZzCUsOX
 G3ZzsYQ4
 ku0ZQn1IqmXp5aLU2mQVmAQAW+zEQVlZMFIELI3h62+uYvRsnhHq70EiwW2NHU61TRIeSAqtEhbjrhvZnKaAHX19kCR5O3WIEdBIIb4ZiG8o8fCxqSdSSPICnzPXUPIjK4KDaRU0xjHcc9IVjSo1UFMV26gaW3yMbtMajRPfNl6Io9+hLN1MFHwEpNG8VgDlDaKMwldLWPpm+5R6dNIG8h/Rkm9jnvpPDmEZB0/emFSsHrKaRXOUWGFgc/1UKN8gLTcxW1+n5QE3UJV9lHCo8aBPF3XDTogqhM2pAmtOe0LPVHvImWUxhiKfGVZV9FnpbK7IzaBkWc0n7hg+ciWIEDWMbOBEw+8oyeUADe5uZFaheFoJBr6+cJoPBskJvPZC8GRBJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000529, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-07-31 at 20:41 +0200, Vlastimil Babka wrote:
> On 7/31/25 20:34, Frank van der Linden wrote:
> > Not sure what the right thing to do would be. Either explicitly boost
> > the priority of a thread temporarily during migrate_pages_batch, or
> > mitigate the issue by dealing with 'busy' pages more quickly in
> > migrate_pages_batch.
>=20
> There's a workaround for realtime tasks. If you mlock[all]() their memory=
,
> setting sysctl vm.compact_unevictable_allowed to 0 should exclude these
> pages from migration by compaction.

Hm, per documentation that's done automatically for PREEMPT_RT...

On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fault,=
 due
to compaction, which would block the task from becoming active until the fa=
ult
is resolved.

...but rummaging, seems other stuff can step on it (contiguous alloc?).

	-Mike

