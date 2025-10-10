Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389EECCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 00:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1648E0079; Thu,  9 Oct 2025 20:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4791E8E0002; Thu,  9 Oct 2025 20:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38ED38E0079; Thu,  9 Oct 2025 20:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 268F88E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 20:26:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE65B829C0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:26:36 +0000 (UTC)
X-FDA: 83980313592.03.E4F4830
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD7F5C000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:26:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=REiBgGHL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760055995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUW4z5PB2uYt+UHHfwXSoWrNlo9PxYnuvCzympehrHU=;
	b=oWsq43FvRcdBKFK0/vJqYx+xgSPG+83eZUJX9bXL/QAJP2oAuj8wo2Urp/wYFXZmSZC/Y9
	igxFfrLKmv9Fk8akk04ZPD7KsqeBUzEVkub97eVd4KME7/VpH6Ch1I2kI9vtPEh+gJCrKT
	VWmo6l7rp4NSf0usK3mo3oU6vs2YWwY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=REiBgGHL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760055995; a=rsa-sha256;
	cv=none;
	b=eKsum1AyQTZ/Lk0MltD07X2Cglg2cHW0BuZSPne7MQwJwclqhd01o+b6ykxdXRWLZ0dP8W
	hq41DQ5nk2ZxcudITFAO6wqIJ9puuFv/GD3/9+KvhwPQUckAeq3Cg0pdl6RTmRfrykMI0Y
	O8X8AdR8mBI7PJm+/zB9wfxj2X1mRyM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e3af7889fso8244925e9.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 17:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760055993; x=1760660793; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zUW4z5PB2uYt+UHHfwXSoWrNlo9PxYnuvCzympehrHU=;
        b=REiBgGHLQGlraKhnaYNlHicIxf0A7PK0KrRvTWy1BT9ItjZPzDL2Az5yep0nOmsHuw
         Y8KAB6+bhkwTyAumuY6zjIVWY2ytF1zvlWOrNjM49uFfvPPMNosBIjgdT10H97Kw7xXT
         yO1vMDN2PPNLC5bgeOfprVBeAoGaKkqx9/UcwSAu6JWV2wkCw9wNAcbMtmxAokPfSh3S
         mVEmSa1Z4ZQHJTyb0YGSUSMGhcDOh6s/oTOzxejmRa9H1ixieackuEepfcRkBSpPSvTh
         sK/j4ZvSCaifukHLCTeYhaVxScEqGasrgUQ6kb62JeSlZ+oQU4sk9X9rYw1b9NgbuMdf
         uZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760055993; x=1760660793;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zUW4z5PB2uYt+UHHfwXSoWrNlo9PxYnuvCzympehrHU=;
        b=Zofp8W/4gNWiP1SoU/jaxYyLjahtvbA/dOAWkRbzk+z+qQ7YzB6QsqJnINlu5BG6Mb
         3Qnj2SCzAqlzz/7zjNWD/4rUNz1x7iTV/ix/ZcbXsK6+6BFlGqG+6UFoT0Gja8uolxNb
         Ocg5xUMcV0RSlz5XMuRwUjwaZlJuiJgme2r7B3ViLH6Nm4qLg5TC5GjtuQSnrMEZ070r
         BxtwbyCeb0BjK+NRY5ghQQu0A2B5SH5B3Ut3xEQ7MpiJ9MgzJIjYyeJYjYaxbFYnZt9P
         Ka96Rk+3hHH+WFmTGWR557jdeAusVzXYbBwiHF+gDmMX4akvJZTbsw/+zk0+tP/1RLC1
         qyrw==
X-Forwarded-Encrypted: i=1; AJvYcCXTnl2wU1ywDqg87RK34NH0JNZDMaPQpyIVYMwH5NuixthxKCjI9q3kQB/rQkPAb9nldJqTC1UmZA==@kvack.org
X-Gm-Message-State: AOJu0YxjW88CE1GBWiplUJitUOGlCI4UPJujZ8nivdrNZns0IE8nFz81
	MqFtX0QQGTCfo6NYODpD3FNvpy4/dXbhm7/u+TKUpHGzKwInzldlBj8U/x5v5SgblQQLeQySf7A
	tNBvO4UFbwt3W5z/lB/xxijB1QfWOWY4=
X-Gm-Gg: ASbGncsIXpT2QPzSL8ca+eQc1VQ9hQEZKjqhWJVebVrQP8duBqUK+TXgkda33icn7uB
	VD9jl9+kqA5E3Y1fi4FEJzrTHOwqfTnUy3jFtwPoZKoHKktV7ElW6kKTYHM8EEVujeMFVm6+RMz
	UzyWiPGj4s4PcjcI1sTTTyHMBgErzzhmL2/+9453O/imDiAzvwKDr8DG6Bmn9Ip1esDxk0d4uJ8
	+2xZfuoCfXumtF8jqUCPP7QccI7neW09HFG/WUhH2s6lpX4pyc+KAHFNSPgqkZ6
X-Google-Smtp-Source: AGHT+IEKhtlRs7io6HG8uJV/pO+2akEGSzzZFCHHiFDcUno2eR4NPpeVNsPtm6HRWIbw/xBK09T31f2XH3b4EnhpJ1g=
X-Received: by 2002:a05:600c:4506:b0:45b:8a0e:cda9 with SMTP id
 5b1f17b1804b1-46fa9a8638dmr69082915e9.2.1760055993199; Thu, 09 Oct 2025
 17:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <68e7e6ad.a70a0220.126b66.0043.GAE@google.com> <20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
In-Reply-To: <20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 9 Oct 2025 17:26:21 -0700
X-Gm-Features: AS18NWBxXjf9R6H60KDIOONvstVA7iwAST5osQQuEMTaL13eeM1e3CKmUs6Ja48
Message-ID: <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING: locking bug in __set_page_owner (2)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman <jackmanb@google.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Michal Hocko <mhocko@suse.com>, Network Development <netdev@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, 
	Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com, bpf <bpf@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000428a840640c2f8e6"
X-Rspam-User: 
X-Rspamd-Queue-Id: DD7F5C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: r7nqiagnhszd3p6yk8i1t8z843rbzs3d
X-HE-Tag: 1760055994-433705
X-HE-Meta: U2FsdGVkX1/zA64f7qkk82rhEnHWSqVdYgugzd3IPkIn9XRasZuATnZp70DkpNxYyJfxokVCdweDF+B6rLNgHFLFZkHSzgDjJdJ22+jzwXIZkilB5NK/eITjCTwbal/d3+Y2PqfbLcGVqiRcBZPZfZaCZvR8CihnvsoQ/DMLWUQTZ8XqhIvJT3qvBLO10VeLYN2QMJHwP6GDZfiMh1mtX1hGaKlML2+38UjWvaB74rzXGj7HiQytlSKTQ2MFcQeKLhOP0jwmR82dQ12+ZhQuXnDykLn+QiXH94inWYio4qGdhp4HWlg2l/yu3Wp/SZmSzrNNocsFrVixWd9kz5rNWplXkIwqOCBA79LKdNv787cSjGHclxQlFZLaLxPB5nPHRn4PC2yrvScEDgdD0uDClJB69V+h2tpyCk6bA8flTk1ErHGIKapf08yi1q820qolQAbWfNTXTX9qlGkgJL+zzTRdVWszIgQ0j9ri1d7DqysmBYMiiA/keqtQos5OPFczdsR9Y7IwuPDR0t2plA0nOAfrYDbs5Q52YbeoFc7EoJTRDQ0yVyrXjrvZO9WxoaEkd+fhgdMld33YyyZRfqoM0Q3UVDf7AmazEda9+S7U+xBXAXBKv4sVXvNlisZbHAtm2KZ7TzIb+DFXIhz4XPNRSpy/5KUo9J52qOi9g+y7fF2DKVNn/pKJqNvbdCaMxvE4+/S4wQb7yMS8YoaD4Kx9dN2h9YOLPINg+gzJ94MtlQ0Od7P1OVXbvJrgw+x5YLCEVPAigR7RkGOvAz+AK8XmYORQuqykSF0rxLnWVKjE/BCaiNChzHIpaSaIClFcJjWE0Gwd5r1uDI9X04mN9OT0mTKrmWUQ/jrXqFOL8cMIvvUhqWjvrS25jX3mguTJRX1WPLgJEdZlYKGR7gC3SgbAyBhdREdr2563BEwX9GPnSezDjtlh1ZTtTerGELU2/+TCQFWJ/aI4E9AZEvzyHU7
 hdhPfAv/
 Kzkn/Hhu+zAoWVta+Dj6JMgCx2KA/jL0ZYi9ibu+bYZ8kvqHWMtC3ujgE9wpgEv9FIZUAyqDpvqqSHg6nA3pVHYDcgk41XmXB/XRcg/exejU+ZN8/k/1mGZ4XpVPgT/ba/ScX9ZPkZhtXKmqK6vhEHeJMWMW96T+0A/o0LnjzfgG+CAbRWi+Kj/oPocr40R96wCzWkjT/OKk7cYt/fcUvXvAhqTcUpPhX3MQ+PjdU2W5eGewm4ED0lyqZqDxg5K+cHKfMTHglkDX2FIeA4xwgM1iPb2ZN42b8y3Dgm9s6MD4s99q5a9GtkKlOCIYdpU8DZapJLBBWElBfGcJ5JurB4GNh5wWbWoz/CmLr2qgIXvKydgyA1lRWYOFYBRze6uDGHNCTxzJpARYlvL+i4QxVAM6J9M3W2mpo41TwTCwztwANT/d0Z2QOZVRcyifdm0uKM1k6x8xy7DYKgp4lX7LgHC6f9rt+2R6aXtT+0zQC5CTWyIPf21lw5cl5nL0/1ftiMtbCBhOs3hcrAlTE4u7mFvY8DNZxKFYdoHgkjjmZMaYVJL0eStP9AKjugEH3aoG7arxu3Chis3TKFFJbuVa0qR27RTvZ8k7g8oiM4aAG60sFff2jniXMG2oVLsXkgqGyVsMb1dslu4gT115OOjol8vKAXrn1W/CL32fImWn4Z6SZKu9lHWPLIiiSQ0NNQydHEitDyP3DCtfNgu2hd2Z+xjw/qEdQFhKzPA8brwpOb5a2dja56Hkrjj1ffPm4maMr8Lm/HxbzuRukw6uRqIH+08cw8nEEkOAoUYhXPMMxZtU25O6mWFesEyoRCV0n+NNYRPp43tzaqG3auuu62cCDkpLKhJeilsjH99g0MaEkbGwbVc3lZ2AklOvccJDoi9c14WC89Exb1vrJZqKvDMg10lJMPp5oxyPnDD2yJWFUR2b0OtDfIBrIJwr0lF+ASiVIL3l+n5vFaW404XpyhXZGteBzev0S
 fXN4ojoc
 o1Aqu3XQvWeG9yzURsbocD7vjSurRnWf7unmGOOoPPWcDZ4mOh/i1i0vzDBVBNJNHnsRM9P6G3qDH91t6lqBrzP7ALrxv7pdBTkaWOuPp9oZmcW4F61f39rRAnJRVM46AI862CE8EhpnKjhp/ZMbML1/1dji6xechqokIIsNQylM67YcXpzvUSm8DxVnqxMgNIIxl0RK9XWHCG7HVp3Ydtfu1qiFzoxBR7zQNW7SOO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000428a840640c2f8e6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 4:52=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 09 Oct 2025 09:45:33 -0700 syzbot <syzbot+8259e1d0e3ae8ed0c490@sy=
zkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    2c95a756e0cf net: pse-pd: tps23881: Fix current measure=
men..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16e1852f980=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5bcbbf19237=
350b5
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D8259e1d0e3ae8=
ed0c490
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/8272657e4298/d=
isk-2c95a756.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/4e53ba690f28/vmli=
nux-2c95a756.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/6112d620d6fc=
/bzImage-2c95a756.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
>
> At 2c95a756e0cf, page_owner.c hasn't been modified in a couple of years.
>
> How can add_stack_record_to_list()'s spin_lock_irqsave() be "invalid
> wait context"?  In NMI, yes, but the trace doesn't indicate that we're
> in an NMI.
>
> Confused.  I'm suspecting BPF involvement.  Cc'ed for help, please.

The attached patch should fix it.
There are different options, but this one is the simplest.

--000000000000428a840640c2f8e6
Content-Type: application/octet-stream; 
	name="0001-mm-Don-t-spin-in-add_stack_record-when-gfp-flags-don.patch"
Content-Disposition: attachment; 
	filename="0001-mm-Don-t-spin-in-add_stack_record-when-gfp-flags-don.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mgk3vgkn0>
X-Attachment-Id: f_mgk3vgkn0

RnJvbSAzODNhOTllYTlhMjM4MWQ4Y2VlMzk3Y2RjM2M4YTA5NmE5ZTVkN2NkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPgpE
YXRlOiBUaHUsIDkgT2N0IDIwMjUgMTc6MTU6MTMgLTA3MDAKU3ViamVjdDogW1BBVENIIG1tXSBt
bTogRG9uJ3Qgc3BpbiBpbiBhZGRfc3RhY2tfcmVjb3JkIHdoZW4gZ2ZwIGZsYWdzIGRvbid0CiBh
bGxvdwoKc3l6Ym90IHdhcyBhYmxlIHRvIGZpbmQgdGhlIGZvbGxvd2luZyBwYXRoOgogIGFkZF9z
dGFja19yZWNvcmRfdG9fbGlzdCBtbS9wYWdlX293bmVyLmM6MTgyIFtpbmxpbmVdCiAgaW5jX3N0
YWNrX3JlY29yZF9jb3VudCBtbS9wYWdlX293bmVyLmM6MjE0IFtpbmxpbmVdCiAgX19zZXRfcGFn
ZV9vd25lcisweDJjMy8weDRhMCBtbS9wYWdlX293bmVyLmM6MzMzCiAgc2V0X3BhZ2Vfb3duZXIg
aW5jbHVkZS9saW51eC9wYWdlX293bmVyLmg6MzIgW2lubGluZV0KICBwb3N0X2FsbG9jX2hvb2sr
MHgyNDAvMHgyYTAgbW0vcGFnZV9hbGxvYy5jOjE4NTEKICBwcmVwX25ld19wYWdlIG1tL3BhZ2Vf
YWxsb2MuYzoxODU5IFtpbmxpbmVdCiAgZ2V0X3BhZ2VfZnJvbV9mcmVlbGlzdCsweDIxZTQvMHgy
MmMwIG1tL3BhZ2VfYWxsb2MuYzozODU4CiAgYWxsb2NfcGFnZXNfbm9sb2NrX25vcHJvZisweDk0
LzB4MTIwIG1tL3BhZ2VfYWxsb2MuYzo3NTU0CgpEb24ndCBzcGluIGluIGFkZF9zdGFja19yZWNv
cmRfdG9fbGlzdCgpIHdoZW4gaXQgaXMgY2FsbGVkCmZyb20gKl9ub2xvY2soKSBjb250ZXh0LgoK
UmVwb3J0ZWQtYnk6IHN5emJvdCs4MjU5ZTFkMGUzYWU4ZWQwYzQ5MEBzeXprYWxsZXIuYXBwc3Bv
dG1haWwuY29tClJlcG9ydGVkLWJ5OiBzeXpib3QrNjY1NzM5ZjQ1NmIyOGYzMmIyM2RAc3l6a2Fs
bGVyLmFwcHNwb3RtYWlsLmNvbQpTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFz
dEBrZXJuZWwub3JnPgotLS0KIG1tL3BhZ2Vfb3duZXIuYyB8IDMgKysrCiAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvbW0vcGFnZV9vd25lci5jIGIvbW0vcGFn
ZV9vd25lci5jCmluZGV4IGMzY2EyMTEzMmMyYy4uNTg5ZWMzN2M5NGFhIDEwMDY0NAotLS0gYS9t
bS9wYWdlX293bmVyLmMKKysrIGIvbW0vcGFnZV9vd25lci5jCkBAIC0xNjgsNiArMTY4LDkgQEAg
c3RhdGljIHZvaWQgYWRkX3N0YWNrX3JlY29yZF90b19saXN0KHN0cnVjdCBzdGFja19yZWNvcmQg
KnN0YWNrX3JlY29yZCwKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCXN0cnVjdCBzdGFjayAqc3Rh
Y2s7CiAKKwlpZiAoIWdmcGZsYWdzX2FsbG93X3NwaW5uaW5nKGdmcF9tYXNrKSkKKwkJcmV0dXJu
OworCiAJc2V0X2N1cnJlbnRfaW5fcGFnZV9vd25lcigpOwogCXN0YWNrID0ga21hbGxvYyhzaXpl
b2YoKnN0YWNrKSwgZ2ZwX25lc3RlZF9tYXNrKGdmcF9tYXNrKSk7CiAJaWYgKCFzdGFjaykgewot
LSAKMi40Ny4zCgo=
--000000000000428a840640c2f8e6--

