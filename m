Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0C8EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 17:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCDE6B0089; Sat,  7 Feb 2026 12:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A996B0092; Sat,  7 Feb 2026 12:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C7C6B0093; Sat,  7 Feb 2026 12:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17A6B6B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:44:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B43C01B2D34
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:44:11 +0000 (UTC)
X-FDA: 84418384302.20.1764C6C
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB0C3100008
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:44:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ExRQUoJx;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770486250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6DicNOmWZ7n9ZunuTcEGYIoNqC3CEOvjvxh77mUw58=;
	b=uR0w3r9dGOo5jsj63yTYPgAJyjEr6PAoA0IgZRFzotreF6Pb0Es15lg7qe1fpEqM0RIjz7
	0BIdn6AoBmWawsJw/27QnNncAjHQ/WDuU1p19bTxsroSKybdnsl1EIxisTQnNJmhtZRmN8
	53sdSBfBYyNRkJ1sy/B0YyOSLTAo4tY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ExRQUoJx;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770486250; a=rsa-sha256;
	cv=pass;
	b=VodrVKrS6tgOgbPcshlH50r7wiH39YKMQt8tKjBj1Mm/MKWTDmAzVY1hqPIowRFbFzkort
	nDfVi5HD3CFyPia4A/bkfHU+IQG4QTHtep5wCX1IrLX8xdEukiiRDRAczbJ/6Mh6b5phN3
	Apu1gK89iZdRbEE/JxfreKMSS62iwX0=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6580dbdb41eso4349399a12.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 09:44:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770486248; cv=none;
        d=google.com; s=arc-20240605;
        b=XtHLHXcVomNDv+2A4tvzXV5GaifMZA//eQG4BksZnG71ZnAkKAI/7B2j+Il8FMZcDk
         l5UG0e4b/tsyG1O5+4tRGz5ZU4jssKq+jlxXTFE1OZZFAu7QcteZRomqyR1Gi4OJ9NZe
         dR+/QrentaO3FuAXHBMlbenx/VUSe33mSy3vlAQAV5QUo9fwCTQlrnJLOTwGw51TOQdm
         crS/FUPKFssDlCdnozfgp4CuzYMS2kx8Ca1J1Ar5mTy76ts/UpSRdIrSkmE5Mo8HIUne
         PUcowEVWg2waZdqTQfP8uFSC9R77YqMgqCcGbHHBFIL9OCm5+ex4haT6Tcz6V2kiXUA4
         nLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6DicNOmWZ7n9ZunuTcEGYIoNqC3CEOvjvxh77mUw58=;
        fh=w2tPMecADUVpGnKCIEM5gCfoDTuZS7DqDB3TajP+yxE=;
        b=WYi67NQecaZ6BvmRY8gajV77vjaIOb0O24L4bv2w/WciyAV5/3F0CSZTnkBlebtvKQ
         Bg9Nl3yMdhIV7/5zDZESOUadxqPq2gxKCB1AoAWhKM2mL0Mmu8C1wUVeo3Jjqc3hWy0H
         zpGRCDkAlQxFeu2uN+Ncvr/S9hM+ex7AqxIAWJOjRQGqYOHR1AC72qRb0W6USjk0S3Jg
         8Ih1gQAMrQb+uN9TEyJRNKWWVA+9WZY3l9cXkqJaSG0M+uFuyMwxjBw72+n0AZMkmd2A
         ZUbPwkRkTLO/VZxysuOGE2ZpV5Fv6B98dLHsZp6MgaBoK13SS2IU2fnSf/xOTku/mddc
         CZPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770486248; x=1771091048; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6DicNOmWZ7n9ZunuTcEGYIoNqC3CEOvjvxh77mUw58=;
        b=ExRQUoJxXe5stXzYe711oak/9xugq7fY4tcidBRfUEPswtncM3WSB6xBIYyw9mHGX3
         hzw1iVvkwoD4b1yh6PFX7TIeEgZWqe0P42NwycExeo0kae1+nkYjlAnW3lT4OUZCtGFn
         vralmxGXSRELZQ7l6KVFwNJQ3imQDYlE2DRwtPZMgPSe3xABeAsn2KedJSZcvkBvagx7
         Um6NJJe88nxYk200SvUxc09R1Qa/bjBFBDUob/TGpFJ4B2AJVHli3yrvddpubEA6GjEO
         aPdSUtihVbOs4p4KVsJKoz8RFUtBXXBPzYV2Z3/1cIAy/RJaxzrvexQX2sp20GyijG3j
         l9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770486248; x=1771091048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6DicNOmWZ7n9ZunuTcEGYIoNqC3CEOvjvxh77mUw58=;
        b=XKeuJC0Y3max71FAXtLEFDFIRMzdV+qKu0QqxbcLW0gDTalXoUov1jqr769AIuhLRs
         eCwJ0O+LauOSCkSIHQayK65brDRuPL/Iullw1GrQIYJYNII6D0f5AC6+MaDn93nO30Oq
         d6J0dYGhYE1uT8xUKvKML2hCub6FtCvJLaVeByBVECNTRJPM+H5bfRpRvIO2UHFYDXL5
         tQ261PUQZxsJcJg5A1gz94k3/d9vQft86L14PKO03WwYCjNUtdYVfPWU/1I0KGQnkScC
         GLFkokCX2o1TPe5elqciK+Z5tVEAQc1v5m/ZdOscUN1SLDz+ymGKbCOOSpoW2gyGcolf
         0vag==
X-Forwarded-Encrypted: i=1; AJvYcCUmFCTkuzk5KSpXKStjp1F/9pAFscy/XXM+/asnU/QNnF0vcskwUQyVcyl2/NSy1mcpRJUhBjrIbA==@kvack.org
X-Gm-Message-State: AOJu0Yzs8EQC+XgqmKeHknT4eH/tFGnRkyE5QJPsbiyRQWYJKWeR4sGe
	vrsEj5xNYejKWP8yrZ/V2U/W6iaxIA3/VhPgdymyUkbQIjy3m6jxs5HcxqeN2Hx+JJGKBx1QfTL
	jk7d9nW7Q0NG3HHl7N7Rr5uDmR+sxUyzRkYRON0elsQ==
X-Gm-Gg: AZuq6aLbgnBREuZ85cKErkfnDfEj2UTcj+iH7hKCQciWmYzkvAjQRMTKyJ7MePqo00/
	cmi4ggs5EZRf6r6ltcpPQlTQ/Q0qD78XRFFmI8k+RHhlkbR2+mxzaVLrY+3203bNRkS1x9ljPNX
	4LkRmRLTMdSMIiYlXGFjhmjysZJD7dqB5D16odHPIUKxgrhMp1nFcPy5hziSzTAKIt1axdQ7Ifg
	lb7RkalaHLOcmecV+bCPSpksNQxp3GmYBHL1qyzMmZw3yfumevVpGMZR+9sijUzf0BcZCItLobz
	FG4kyAHiogFepCWrszMecwdltx8=
X-Received: by 2002:a05:6402:2706:b0:658:da9:787d with SMTP id
 4fb4d7f45d1cf-6598416c231mr2602855a12.21.1770486248243; Sat, 07 Feb 2026
 09:44:08 -0800 (PST)
MIME-Version: 1.0
References: <69851c62.a00a0220.37c87e.002e.GAE@google.com>
In-Reply-To: <69851c62.a00a0220.37c87e.002e.GAE@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 7 Feb 2026 12:43:32 -0500
X-Gm-Features: AZwV_QiGYNOCDa8IAvI630GE7Icq-FtxiT6Kxmlkr3aXzAbY_BV4pDuMuDWt6pM
Message-ID: <CA+CK2bBsdvrftSR0eEPsqyB=eny-64-qjnGqn1puPe=fduz4eQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set (2)
To: syzbot <syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB0C3100008
X-Stat-Signature: gpw61fkuk4u987nb6wixfctyxxxmz49o
X-Rspam-User: 
X-HE-Tag: 1770486249-612061
X-HE-Meta: U2FsdGVkX19Hpd8iwMT21YkLTqVAMbQJabPuZT2USGAy+I0Y8HZu0RBz19RzfacqLTuK59BLKQtVS4nccUDCB40gHh5poxmKrW0h7yMTbq1u59ntgv1/I2cUh3SBU1S4Toyozm0AVXumbeYHPgSz/vW4dHYiabPHL7E3X2m+m/9KiL79zeEjGvi0WHh5Imamn4uM0zDBaQX8+gQk6b6Wd/HcuFD/UHE9XdsqI+bqP2bgVP6uJoO5V6x/YNiB6ZfOWPWfGDqTZNJaxn8TfpjPbhR1FpPSCFhtN3u0y7Jqz/iwszhLzqL7pzfbzn2hQaqPasIgWnOyeXcbIkX0kcZ22g0o5B238UDwaquC3sjZxuzXhlEMMioljzReqA0VByM0BncPjDnE8j+9w4njBE5d0pRfZptwsJIQb6Z8HdSKNK51bGylgl1V/VO1scHOQvE8bVdt0ybcbCrKTWDuHY5IQVa0iBdZgdhA9DavmU3u892rca7bvbl2iOm6Z3DHXzP7sIoJe9/BQlu5Q0zxBkh3/7PboPFl+vE8ryrirkMpqJ7dVZGoIpEUk/Tg97BzwqfxvkoYhohIT1+FoNmDzEFWOq3C1Rtt1ZZCxcu9ZkVygXrG0fsB28xWqZLgKpBqbhji4CQ+C+0EtUzkK8eGSQgv3Zymhaweqi+hvK16bPRS0uMbKq02qndNyZVZYjv0T6CN41uwoMoH4/QKtH6XXr/KPJJbGOXIfAGsCFANsCHLyhwYPabXrEEM345xzAYpqOf5IC4aRhyfdeLDkysihQcEQU7HRjxUDuV/qMlL++RZYwAjtMRkgzF3F3Mofo4i7HJzVtZ3KziaxWnJYhNN6bS2gdYGNpZebK0UVuqIdNsNcpA07f4g1J8DVZ8Pli7si0+52+tAKbqlWZvYOs7zPo4AVOuZOTP121WMdWo5VMfWGyQEH85eqOMhXnwh/DGzA/+vBzUmxSsiLVnTnjHnfGO
 qEmYUZB9
 R94YPALHIytC6n29lr0jQg4S+yrdGjE9371qTpiDzW7yteaVNTJA5gql3a+nv4om8UzBQTGViH03QjQsMOnq3GnMzyWpH7mcz83eKClsFg2fAU+mMuF8wGP8RwWWZAxdixHnN2L/DqFzAAMrnzmBJk/MNprtl3AxGiwimF2ercgdVRA+JmM2npshIetU8lHKoMgmwvY82VnEjvc+o0heOuv6aX4u8pyWybh6aMEOXNVKXXt1hVSy4kNqQ6gNsVCga/i8lAv44nzf/NeeibRb37ETrK8Puqux1D8h8UWmJxr6/v+10T6fYP+Zvzys2F7/Jp3BCm5kHgFk5H2Bk0+vPY22QCZoMrhBz6L3h6GI6c346dXSj4D3SSSIeHDx80OaqpD4WXvny4bamm9BzwkB9pZAlhnQC90NoOpQW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 5:40=E2=80=AFPM syzbot
<syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    099ba40b1bd9 riscv: lib: optimize strlen loop efficiency
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux=
.git for-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D158c8b2258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D781a4eb079214=
64d
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D227179d5a8a87e9=
df90d
> compiler:       riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (=
GNU Binutils for Debian) 2.44
> userspace arch: riscv64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/a=
741b348759c/non_bootable_disk-099ba40b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/38fcde8ce410/vmlinu=
x-099ba40b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9246b4696c47/I=
mage-099ba40b.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+227179d5a8a87e9df90d@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at [] mm/page_table_check.c:118!

BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);

Looks like on MADV_COLD we end-up with false sharing on an anonymous
page likely for a short period of time.

Pasha

> Kernel BUG [#1]
> Modules linked in:
> CPU: 0 UID: 0 PID: 7886 Comm: syz.4.1009 Tainted: G             L      sy=
zkaller #0 PREEMPT
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: riscv-virtio,qemu (DT)
> epc : page_table_check_set+0xa74/0xd30 mm/page_table_check.c:118
>  ra : page_table_check_set+0xa74/0xd30 mm/page_table_check.c:118
> epc : ffffffff80bfcb7c ra : ffffffff80bfcb7c sp : ffff8f8000cb6860
>  gp : ffffffff89f9df20 tp : ffffaf801c80b500 t0 : 0000000000000000
>  t1 : fffff5ef026b8409 t2 : ffffffff9136c6e8 s0 : ffff8f8000cb68e0
>  s1 : 0000000000000001 a0 : 0000000000000001 a1 : 0000000000000000
>  a2 : 0000000000080000 a3 : ffffffff80bfcb7c a4 : ffff8f800b83a948
>  a5 : 000000000007f948 a6 : 0000000000000003 a7 : ffffaf80135c204b
>  s2 : 00000000000b5a00 s3 : 0000000000000000 s4 : ffffaf80135c2000
>  s5 : 0000000000000001 s6 : 0000000000000001 s7 : dfffffff00000000
>  s8 : 0000000000007fff s9 : ffffffff88825fa0 s10: 0000000000000000
>  s11: ffffffff8a0b5d80 t3 : 0000000000000001 t4 : fffff5ef026b8409
>  t5 : fffff5ef026b840a t6 : 0000000000000002 ssp : 0000000000000000
> status: 0000000200000120 badaddr: ffffffff80bfcb7c cause: 000000000000000=
3
> [<ffffffff80bfcb7c>] page_table_check_set+0xa74/0xd30 mm/page_table_check=
.c:118
> [<ffffffff80bfd300>] __page_table_check_ptes_set+0x264/0x47c mm/page_tabl=
e_check.c:212
> [<ffffffff80b5e6c2>] page_table_check_ptes_set include/linux/page_table_c=
heck.h:76 [inline]
> [<ffffffff80b5e6c2>] set_ptes arch/riscv/include/asm/pgtable.h:640 [inlin=
e]
> [<ffffffff80b5e6c2>] remove_migration_pte+0x1136/0x2494 mm/migrate.c:436
> [<ffffffff80a0df26>] rmap_walk_anon+0x30e/0x690 mm/rmap.c:2861
> [<ffffffff80a27da6>] rmap_walk_locked+0xa6/0xcc mm/rmap.c:2977
> [<ffffffff80b69a0a>] remove_migration_ptes+0x18a/0x1bc mm/migrate.c:470
> [<ffffffff80b90dc0>] remap_page mm/huge_memory.c:3434 [inline]
> [<ffffffff80b90dc0>] __folio_split+0xeb4/0x16f8 mm/huge_memory.c:4069
> [<ffffffff80b91ae2>] __split_huge_page_to_list_to_order+0x7e/0x140 mm/hug=
e_memory.c:4200
> [<ffffffff80b9554a>] split_huge_page_to_list_to_order include/linux/huge_=
mm.h:385 [inline]
> [<ffffffff80b9554a>] split_folio_to_list+0x22/0x30 mm/huge_memory.c:4264
> [<ffffffff80ab469a>] madvise_cold_or_pageout_pte_range+0x1862/0x2400 mm/m=
advise.c:412
> [<ffffffff80a03002>] walk_pmd_range mm/pagewalk.c:130 [inline]
> [<ffffffff80a03002>] walk_pud_range mm/pagewalk.c:224 [inline]
> [<ffffffff80a03002>] walk_p4d_range mm/pagewalk.c:262 [inline]
> [<ffffffff80a03002>] walk_pgd_range+0xcc6/0x1f84 mm/pagewalk.c:303
> [<ffffffff80a043f8>] __walk_page_range+0x138/0x7a8 mm/pagewalk.c:410
> [<ffffffff80a05cf2>] walk_page_range_vma_unsafe+0x212/0x868 mm/pagewalk.c=
:714
> [<ffffffff80a063a2>] walk_page_range_vma+0x5a/0x84 mm/pagewalk.c:724
> [<ffffffff80aadfe8>] madvise_cold_page_range mm/madvise.c:586 [inline]
> [<ffffffff80aadfe8>] madvise_cold+0x1a4/0x5f4 mm/madvise.c:606
> [<ffffffff80ab66c0>] madvise_vma_behavior+0x1188/0x251c mm/madvise.c:1364
> [<ffffffff80ab7c8e>] madvise_walk_vmas+0x23a/0x970 mm/madvise.c:1721
> [<ffffffff80ab85ae>] madvise_do_behavior+0x1ea/0x5c0 mm/madvise.c:1937
> [<ffffffff80ab94c6>] do_madvise+0x18a/0x22c mm/madvise.c:2030
> [<ffffffff80ab95f0>] __do_sys_madvise mm/madvise.c:2039 [inline]
> [<ffffffff80ab95f0>] __se_sys_madvise mm/madvise.c:2037 [inline]
> [<ffffffff80ab95f0>] __riscv_sys_madvise+0x88/0xdc mm/madvise.c:2037
> [<ffffffff80078192>] syscall_handler+0x92/0x114 arch/riscv/include/asm/sy=
scall.h:112
> [<ffffffff86391c0a>] do_trap_ecall_u+0x3d2/0x58c arch/riscv/kernel/traps.=
c:344
> [<ffffffff863bb61e>] handle_exception+0x15e/0x16a arch/riscv/kernel/entry=
.S:232
> Code: 7097 ff90 80e7 4580 81e3 e004 8097 ff90 80e7 9380 (9002) 8097
> ---[ end trace 0000000000000000 ]---
> ----------------
> Code disassembly (best guess):
>    0:   ff907097                auipc   ra,0xff907
>    4:   458080e7                jalr    1112(ra) # 0xff907458
>    8:   e00481e3                beqz    s1,0xfffffffffffffe0a
>    c:   ff908097                auipc   ra,0xff908
>   10:   938080e7                jalr    -1736(ra) # 0xff907944
> * 14:   9002                    ebreak <-- trapping instruction
>   16:   9780                    .short  0x8097
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

