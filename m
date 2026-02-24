Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2F1EEC2B0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 00:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288656B0005; Mon, 23 Feb 2026 19:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236046B0089; Mon, 23 Feb 2026 19:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1394A6B008A; Mon, 23 Feb 2026 19:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0099B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:01:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A13B91A036C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:01:28 +0000 (UTC)
X-FDA: 84477395856.23.3A261B7
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95BD9140009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:01:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GPGuI1ZR;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771891286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
	b=P+zy1g5FmrYzGR2BaWTqz8q5o6pW9EHIWSyLRONrD66e05T2GKKZiWgodg+o0bxUJOY7+Y
	q/b5EnjJP8/vYXGZnOaN4HeRyuWcSLvKa+mHzGoXgnyWwe5be9Axi+A7WXd9QcQou4WAfX
	T06TYipn3BK9/dUkuD49qXdq5MdFuKg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771891286; a=rsa-sha256;
	cv=pass;
	b=uNWKrCmFV9Y9sKSGVkbrGlw+JKpxnbggFOrXn9uBNWF1/Nh9rdbGM8njwgvQ2em5brSy05
	GDY3JjG7CLO35FpvlZ0y4Sa+NgJN9JrGnHWjmQkljLOmXtO4ceMD3PQnI8SAAJRFSWoxoP
	Q5OWPUyi3iY5m77cpbknm9GbaEm4bt0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GPGuI1ZR;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3870d178a9aso39909271fa.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771891285; cv=none;
        d=google.com; s=arc-20240605;
        b=QepO4WcSI+iCouOTDZFb/vvL+4fy/7Bxh77pkjd5uc/tuA+UUdk7zWN0wuEBs1U607
         jjdDaVAp+04QYKeOVCpklBnkKczchcwtGi0iP7MPf5QZe3M407x268bf9TYHPprA85l0
         XL7z9IpmS7hzhrxKMuR6ZVYZYWiFh33xnuvAAbDOIztFc+Cn6i5sxP7XaBLwNKJA+bsz
         fpTTa18mqryEeGWjEr1bs2OV5ADIsQqKEZH33KXmoBo3LjXkYUHUrrMrc/kdcR1PRWZB
         Xx9UpAqzesA7tPE8YYilkowtyDtfjjCPntLvI5rkvbiQ+pupMJKy8XeFoB5+QOSxVR0X
         DTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        fh=9yroN6wULW1EapP5plDzLhI5xK3luRurHHK4ifrmmIA=;
        b=KOxeXIemjnuyB56n32GB/63dkvkNWNv1s4qsydM8r2kBJX+z5pCCcpmHK4OiVdbtmM
         FSi/95wxqhj2g4QZhkriESZ8TsPrn9fGWtJHIlXeCJgu7xuiXsfjLB3B57ew+3eG7pk+
         sjx+9xnZGqMC2ox/5YuK1nGPUjjY/TJbQS0FM4FLhMxVywzSuRb39L3rQVjNhaIzKLc3
         MZYTWs8fXAvfRcs13MaHulYKaowaGGQ9bY1taixy8g6sVSUfoySRMo9sqQ3S77NHk9Zu
         XpT8lXuCjTnzfqVNK6ezgpiLAoklg+dRIXVqmfNLkT79mAi8XK5McBFKh9pV6bCdj//G
         kmAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771891285; x=1772496085; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        b=GPGuI1ZRk1bNpsEzxhT5ZVNrp7gywurUXMhko8gRjY6iP0QvcW/A8HID2fTCHqD+KU
         Dw7n44sKBezOENa+n2vdu8dpIAXh5hOshTHEbLTSiN1TBa/lbrh71dbAurzU/+BLDt0o
         xWw4nSZJLfFO2pwXFhdzgAiPQVVY15xiJM8w/Jns/Fqq9oZlwpmWdaOlmlF+ck08DbMh
         g+pvFRvCgwqrhCqvKG7TnucyhUS029yKm2kY+ppMGhyFeGMzPysLxXFFIBIpvr5Tp083
         bzIuBZT4xoGTcFK9mMzvClBD1yFr1Ktrmt3f40AGcycNqIRrgzaBEkObpMBU2NC5dB9w
         9E/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771891285; x=1772496085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        b=cPHPCcNFuzCU2ExW4HlBTlUQbvNq9pA6uk4Pi3JGik0NSxE0+URdtONGKaYRfaZFZC
         HzUXUo54Q7LZC/3HUgFrbwDNlqVuMemk0fgugJ2wuGeAuLEeCypAWAVjDmIlinFj1g7w
         KzriOSsyJ8DBguqo0bm0WQ3K/KBQGsEUahP8BcgqwJ8E+OC8Qn7v4Wd1XUpBNNmrNJB4
         z5lPF7VxEq5d5F3Zm40ekPeqJLFEvyQOJnTloEP3IzJM9jkd42tPFNpGbFYbbOT94P19
         Eq1yqPgL4LfmTH7NBaoNk4rU+luGvKtHYsrxdwAt9U0GbCDrYO6fGEYhuukEEx5tZEEr
         yEiw==
X-Forwarded-Encrypted: i=1; AJvYcCWd+OZx8Y+KWyH+tBNIGgBd0t2zi00bETcIaNYkLKZD8HesinPcb5kFpkY/XV8si/RKt2QSs655/Q==@kvack.org
X-Gm-Message-State: AOJu0YwFd2hMPHMHk7zcRrfW1zjqqCPdQ15o07UG3xd4wxaSRRVPgbbR
	p0hY3zWw/MhPzGGfCtgTF5O7WiWQgpCgHAJsA7/bbeeAvuxTHvI822/ZRoumDCP7ElvKr5fIbJO
	/9mhMYXtVGY14+RWT12+MT7M8PaborEUu7a4WXOxe
X-Gm-Gg: ATEYQzyTtWhI3vTnFJdDHzilo4WUW4LBiLtzGzrQXjnN3WgUFX+0nQyZGs8fTih9jKh
	NoL/p9+HnBXtBaGXN342QgXbPS8Vc2KOBjWDu1+ykxD/BjQcVXlaCz80Q9Br3Y8HSU+jG1SH5Gd
	/Q1T5j7nLMfFfC0V6hx0xhHUPOMelDX26Qen2tG+Aycn9+5BXK3XPLbWj2tnSYHFGtROV35Fq9n
	NT+3jSX/59OxCZRDe9XlDXB/g4ia+mCsWA8O2MXCJhQDucys6aFojPeen2sufLHkwPQsG/teO+5
	plew7Rc=
X-Received: by 2002:a05:651c:305b:b0:37c:c84a:99b9 with SMTP id
 38308e7fff4ca-389a5dbcff8mr25152861fa.24.1771891284261; Mon, 23 Feb 2026
 16:01:24 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
 <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com> <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
In-Reply-To: <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 Feb 2026 16:00:56 -0800
X-Gm-Features: AaiRm52Dp6IBp6nUtMfXlMTK93T1cVz8F1V8LZFFdJp40no7f29X-MFiBmci9Nk
Message-ID: <CALzav=c1P7aoGzhSuGsFi6VYsNjygPvBR5jWXb9uqbJ+3MqARQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 95BD9140009
X-Stat-Signature: mcihu17o1uuhx58jjxw173dm58o6iw3p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771891286-438200
X-HE-Meta: U2FsdGVkX1+vaVfTVxkU1Ktx5tbVJuLsIUv52PtWQ+e1zNHU2Hu4fzmTOW0/Qc3PLrko9+tacWV6jXc838gyVDJ167SPwX/mn33H8WpW7maKGE4lrxlJ2kpMXEnvBEnivwrXUHRIdAPwqGVzSIiNipBZOF2LkGKORY0AaK8WLwpUk8TxGgNPRKpi1GOMS3PaMvHUnTfZD2wTlaC/JqEImaluu+ly1PrrXURdbps0cVGKUe4zdA3eedfild1whhcCD90k0DsToV1VPHELAxhXAYEuy4TXtU5wsAs3Ia83FoBKjQj5KVE+vVwQkWtOqRQlE63sErB1WXpUHVlFUBHO02q3NDCDsSIsmZ92Ksa16m1qr9I+tSoDEimKLSjQuBCg20AvC1X/MXW8nLGnSVSuYRy6NInNzBpn3vSYzMr19IuEmY4S2Cf81QFSYFTG9W6tj1dEymdTfQrGGpcljGIOcOcw8Gd5C3fj88gjwZXXs5Ake2hlXJzhxg5C2Xp2N4csvQbQq/sWcFakL9DppYBB6tFD7jYJa3JWGSgYy45h3U2/VdDC/xZ2BLBfHzUV+tthSx1f7+Wo5JFosQQax55jGlPyizcH94PTodMXyimjs+VzVtv7Hc1NhdnMwnQhrThIkz0ufIhTINe3FI++DCjv57m8f8Fn5qOe4pCMS95sdfdkbn5aCl47DLS8Bomn5gJ8NWVP/EzDPfXlrmYbWh+wuSCosyek7LBeYwyE4KQ85u8vwCYvGZkevEGsC9wLUGlFG68vwvLYzlyBzvHdxkTDjAuAOeete7dOT7pHqeTjKmj0RMDPyJzFHmBLeySAk3D12FqHxYkvJJoP4okrC89kBnNFVfzukjozw0lHIgvvNp/kX9j5lrnJCiHy675D9j/+IknfPXqN7OlnwoJQJRV+0CTSbQ7Qq0cDKIH+zPUHLHfcfdIx4mfzKJ8owB+tH64jUwz5tWIkkRtWn/YwArw
 xkfA/wrB
 juaRnDyDRLdEk6N56umBo24cwx1QwUk/GRm4m/ziFGDUIdYu95pj/x3rb7lxI0nsup58A1McJJcYQnBg8fSbUA2v0+MQoCN1O+QmijldXUW5pBdg7GXafRG5I6Hsdk3HbqRZUJ4KAQz6RsZU9L+6WJMhTAm+FPD2KGHvlVMafKzZm+btIk4D979J6RiT4su0xwUCteFzNWUR1qEi+dWPJZ4w2wGw6Esc/MGAFM0i6eHhOkugcORS1hUClH0+oe/eKEqrLLWF6zNpItSw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 3:43=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Mon, Feb 23, 2026 at 03:08:19PM -0800, David Matlack wrote:
> >On Mon, Feb 23, 2026 at 2:04=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> >
> >> >Drivers can notify the PCI subsystem whenever a device is preserved a=
nd
> >> >unpreserved with the following APIs:
> >> >
> >> >  pci_liveupdate_outgoing_preserve(pci_dev)
> >> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
> >>
> >> nit: Preserve and Unpreserve can only be done from outgoing kernel, ma=
ybe
> >> remove the "outgoing" from the function name.
> >
> >That's reasonable, I can make that change in v3.
>
> I should have added it earlier, but the same applies to the
> pci_liveupdate_incoming_finish() as it can only be done with incoming
> kernel. Maybe we can remove incoming from it also for consistency?

Yeah I can make that change as well.

I was erring on the side of being overly explicity with the
incoming/outgoing terminology, but I agree it's unnecessary in these
APIs.

