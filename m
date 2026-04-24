Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA510FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DD96B008A; Fri, 24 Apr 2026 15:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE416B008C; Fri, 24 Apr 2026 15:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE276B00B4; Fri, 24 Apr 2026 15:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24BC16B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:19:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD74D1C01CD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:19:04 +0000 (UTC)
X-FDA: 84694412208.26.FFF4839
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 018B4100007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:19:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h+YNOXLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhGQGfrRr/B8tE8HwT4ER0coG6uDCjCBjZH37IqV6J0=;
	b=fG6PjJGqDEBIDQWK3eH4vI4wiQX9AQ5Zp24vIGHpLDiXD9EcNseCVMa6UvKdh3FQv0yNl1
	cXZE41NOrwL26Id7htGC2XHfn1h6fJPnl361eK9u6FtIqvwECJiqH4q+qbZ9rZ5WZ698ua
	WrzpZADB7TGxnQmD+32Peia98ePA2Zk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058343; a=rsa-sha256;
	cv=none;
	b=VqHfNMZaXdVtHE6+LWimi+tgCnpx/exVizalqex/2KkxZm4xdj5PadabTbudyqTNAYDyhC
	AViiIbj4/di9BH0zVXmwTO2dWX/FWCgceHvnKhjS1NbY5Z0ots9HciEs+no14EY8TlYDTX
	xUIplhEictJOO/CJvDgr4YRWCntlyfE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h+YNOXLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7042160125
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F8EC2BCB8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058342;
	bh=TjoObAyADCrST/Y7w112PE3u3cZVRxOGJDu7cAPas0s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h+YNOXLPMp39PBG3Gr9uLo0BRKTr7R0w8PsGZ8sjtp/4fqSauRop3zzrKFWK9EwYv
	 Qx3MMCrtXEVro0XeS18cFL9iDWpyPvH3WFFA2bAE/7aRdmSoZhqArZ0Cqk/RKeHCfq
	 Pb2i2ATkGohu8TGQ7a7S2jHfz0emIp8QlT/AwKCyFZo9871F4KTzJACgRFN/l7+quh
	 /0b6RoBFxip1Hb/l/lU3HNZQI7AkIrzNLd+rURTItHfGF17ouHDpidvhUySxE9Htbb
	 8/Ve0ItcVl3MNbqZnVaBx1M1eBGI85wZ8jjXL4oiSZz8xChk1WVTkfeiwYsDDHiuT/
	 jM9dWyJwBqKWg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8d7f22d405so1379812766b.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:19:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/oujfVYmDZCO3ciYqGA05XWAaj6eyYDXpNZdvoz6XoMmN/YESmqTH+gydJPfGOwWM+hLvPLdZ6+w==@kvack.org
X-Gm-Message-State: AOJu0Yy7sazpPWO6XdHvwaO62doDmN3XEdl0xIS4kORB4eyYdru8H+C5
	M2CqKdnkhvbZ/x3xpMobTXZb8rY3epbeTTxj/ErCSnyrrjyLdrRyGyRCz/AunpJM/dz+/JmKsjd
	q9q1LlDVFG1BsBXAry2bJzKfELykISPk=
X-Received: by 2002:a17:907:c10:b0:ba6:8f34:b419 with SMTP id
 a640c23a62f3a-ba68f34b5c5mr1407089666b.13.1777058340906; Fri, 24 Apr 2026
 12:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260424062528.71951-1-lance.yang@linux.dev> <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex> <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org> <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org> <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
In-Reply-To: <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Apr 2026 12:18:49 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
X-Gm-Features: AQROBzDBfOuUErZMfxDCkdpEwLja5wXxHZ0y9sOKUJXXYUWA3b3LIrTjfVdzPRU
Message-ID: <CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent them
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Lance Yang <lance.yang@linux.dev>, peterz@infradead.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com, 
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com, 
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 018B4100007
X-Rspamd-Server: rspam04
X-Stat-Signature: hnpo8784ffkobhwwqfwjjzkmt9p4szrm
X-HE-Tag: 1777058342-68328
X-HE-Meta: U2FsdGVkX19ONq/pvunYZFS0khkutBG/IGfK3p9Lg9HOKaJG3PweZpa2hGNUpDpS+4R9DsLb3tt6eA3m2JnhCTu4mQmGlqVvju9jpY3BsiLE2uTxj4NjUgjV/diUCe3BgsjQw+QRxoo3vbbzEqRsgKGGABG6NXiiTdSEc+05y8l794cDdVGdSyS8eQ8UfvmrlaRgQ+YrVsEFMjEIf4OKM1mTKjlBUA1g+fTckeDk0cJQ33TQ8st2oI8+dDAAKBsbD1Y+5M/RQeHUlR9YcBuCzUQ3WOTUHdPJAQcjTaNWzO+j6hUVUR1gmytNfkMcO0rGqf6Lq5PqENWBUaUYcPUhr4fCe4QKb6qrJs1kG+cVe6plsz+/aw0WEwQXFq5O7FYCNPNHPqA6Oz1e2Eqe6YvXC+hzNy+5ZXTKcsUj4C+k5m4EOFC9Z6pvByguItWVMZq4Uc83/L/d5DHWwHINAbq+npVvf20H55g6UjPU4BYdx8c5GzMuUGZdFqQSIs+879JMDDzS0oF2EENIgzSYhlrjwsyQ2IfvTjI+asllVnyuSNvyosDANjxONW2PqTxn4vL36PkPxeGL2GZeZfuvkuG3KU0N511s70XqGKWRwQ8FYZpxDOznHvJzlrsGlSxeaRKYMkjVElgjbLzOLB2Z8oCmOe0vUJGZGurhgoMu9RG8XpCvnk354mUal4ik8VyhZZpTyotxNx3xoFgZz39yKhs8/u2cZEn4hB7kVV5mWsyveEMfe4PNWqM5rUMRoZVIagf7txaQdCtyGj1HSnVJbd6WmxpuXgMVFuywo/TJbRyGa9+VI9jCRd6J1tQZ3riPu5qsF1sLDepyfc9Lq0A3VsYhJWApoucKIZmAO/s2MnvwoKI8QN/wvlaVsia/3aSxgypJwdbQ7CuWzhogsnNaYcmT+5z/f2MIngxSwPg5rENRFA5gdu33hRL5GuRQWdg9CCs4ZrLFuKEo4IhlQ/0Hjx+
 6a94FDC+
 RWVoh4rEHMc3OvEbbqoU95o4mD809YWxyXDYlP9zQGjRZu6ufTIP2MaW6i482FcPDuIyTKssC8feRJTkBXBURJn430DK3Sbvuj7izqf3VWhbDN3Pe/z2cB5SVFgbF5cIoXkAghepoPEA/g5yVttDnIyhsC+AF+Yo1sQ8mtKOOG0EYZkv9f7hgggW1BKJlsdPgs2yoH2dHP9ZQ9YZYXdPLl+2R67tcJ6LGcHF0lTtMSukobBK5FcqPc0vTCBtZcTOafTornOdg4QCryXysM/mTgwOC4KRtuL/dR1qTKTvBJkOAr/doTArSziISh/zZjShLJ2ZmtL9E07nTIIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:09=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/24/26 20:50, Yosry Ahmed wrote:
> > On Fri, Apr 24, 2026 at 11:36=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 4/24/26 16:31, Andrew Morton wrote:
> >>>
> >>>
> >>> Why do you think so?
> >>
> >> The most important part for me is that authors are aware of the report=
s.
> >>
> >> Sending them as a mail forces people to publicly reply to the feedback=
, and at
> >> this point in time, I am not convinced that that is the right approach=
.
> >
> > But I imagine it's useful for reviewers to see Sashiko's feedback as
> > well (without having to go look on the website).
>
> I read a lot of them, yes. Maintainers know how to find it.
>
> I even think maintainers should  briefly go over it before applying to sp=
ot if
> anything in there is still left unanswered. But that doesn't need a maili=
ng list
> posting.
>
> I enjoy if contributors are aware of the reports and use that input in a
> reasonable, like Zi just did [1]. And if they are unsure, they usually as=
k to
> double-check.
>
> [1] https://lore.kernel.org/r/15191F7F-0D10-4907-B963-DA4EA0E36EB6@nvidia=
.com
>
> > It's possible that
> > Sashiko is right but the author isn't convinced, so getting more eyes
> > on the feedback would help.
>
> Forcing contributors to reply to everything. I don't like that, in partic=
ular
> not as long as there is no way for contributors to run it early in privat=
e.
>
> In most cases, contributors just do the reasonable thing: incorporate the
> feedback in a new version.

The usefulness of the mailing list posting is that it makes it easier
to respond and discuss the review. Yes, what Zi did is great, but it
would be nice if contributors/reviewers didn't need to manually quote
Sashiko.

That being said, I understand the concerns and the pressure to respond
to everything as you mention below. Maybe at some point this will
become an easier decision to make as reviews become more refined.

