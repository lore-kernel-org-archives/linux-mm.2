Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8FDCFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CB56B0027; Mon, 24 Nov 2025 05:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034866B002A; Mon, 24 Nov 2025 05:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65B26B002B; Mon, 24 Nov 2025 05:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFBE46B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:25:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AA9F13A511
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:25:28 +0000 (UTC)
X-FDA: 84145118736.05.FB8FE5F
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8AE9C40009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:25:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWPhWHTR;
	spf=pass (imf01.hostedemail.com: domain of nogikh@google.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763979926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DReGkNlDW/Ucd2Qidv0rOD6+IM4LQcSMTitBPQSySdA=;
	b=OzAXt5NyAPEUapuOpbf/YBE2uay6CLr3yi0PKqpcc4DZdJq+MFWyuQFeF+/mXVpHUFzVVR
	N3jJzzH/xaw0UwscJNlMGXUUnVtZu78DeqH18PQS5xiavC1XtHQ9PprP7+fjlAqQqo5VEz
	NfXxF2h9MMoPLWE7sb5u0sHTPny3dQQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nWPhWHTR;
	spf=pass (imf01.hostedemail.com: domain of nogikh@google.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763979926; a=rsa-sha256;
	cv=none;
	b=uP3BtKG6Sww5iWTxjoT9XC5EEqtbKAjqTnmFgLbcB3n/s6Xfoo3ZqlENBBplnMvAD9/LMj
	m86TepuiY54ZlKHjM+QpEy04E3BeFIzU7r8y8J/ybkhNsLlgPF1KhWlrIxdeDTOOvTlHzW
	Jz28eVmxCd81Z/Xe6B2nBif7pvJ4B6c=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6574de1cda1so1704279eaf.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 02:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763979925; x=1764584725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DReGkNlDW/Ucd2Qidv0rOD6+IM4LQcSMTitBPQSySdA=;
        b=nWPhWHTR90NHtk8tLJfOUYs0YU44Fw01rYlNZJ/KsteVS7NiKAr0oseOu1n9iUS/Fi
         AkgyqZ8dvT/MYBnjdfvHhXQRfk7F5zg9lnkhJxguEzY953U77t4qx5vbALfc3JtFjFqp
         aTof/65lNYfkglJ7tTGs4VDJyuFpDrdHiGjSegv3pq5bTPGSRkHPDZgUK2rCiV1xQ7Gn
         zz/a76TZBCUvx1lb9w8WJUxX5AE7u/K6LvFFtSBZ/FrlX+nx36YEpiYLb9nQkv6Wdzg+
         MJW3GKWjI9ssQ0Z0vNB1DBJWq8O2z5bkFQ+b8LH8vO0v76Iwafa+28cUNaQ8lC/exhtV
         9iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763979925; x=1764584725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DReGkNlDW/Ucd2Qidv0rOD6+IM4LQcSMTitBPQSySdA=;
        b=YL3E+d6gvL1aIVRq6tOMXv4I86HjCYpTkHLRxIgyMUUZzX1ciJ4exaOPkuTdL+p0e7
         cLSgyt4vVIhMzQuVQrL38uefGjudyzyMEyR5/7UzutJwFRRy+IVV4hfjP6KV6uHCdmIk
         csSD30SDk6uoMEW1T6OFN4l+JX0cdngVG8wORHR8ksXu1gh7ahJyFx8+t0gQBLlEOuQm
         CKZIDbbUpQombkmZyRt8zPHOYN5+AV1798f7lAFU4P+iYFCkY2/XHJ1uBrwXfRiz91M9
         DN15n7+vkzns4VKsk5gWjZrvwp65YcBFWUzISWp9iLbJqAMw4SbtsB5FcUxTV1mSPc0l
         HQgg==
X-Forwarded-Encrypted: i=1; AJvYcCVewmL/yRVTRLykMGcKtratCGgfetTgIi/HuyBhHfB4eGGdJcF8tk1lQx/qSlC5tgewaE9B0pcR/g==@kvack.org
X-Gm-Message-State: AOJu0YzKuKNx9xXM1jEELwqYAvdrS7HeX5sBjh2pg6dtWWd3E46//RWG
	G4spX9rkYCo2cTfz6dv9XQbMUQzB3Aii2jqo1vHgP9OSRUn0KdUaFw1sioBJJkvYIBWpMIX/FjC
	vnpwWJdna7BSdwc91/tzXji5Rz246H7DJhTgIsiEN
X-Gm-Gg: ASbGnctC3Pz4g+YpySmLF4z/MVopFx+Ur3PusepyfZsMhHPyJo38eo6NUWrM13mLkhh
	wmCE4Lgu5JdSOY1vK/o2xpitDdEH5FZofQlJuYjKNscBOWKm8iqr9fMEqbVUzJAZNKjccLUyW1u
	EP1oHrmcm/9r0Qi8ln1LE7bWolbiFThaUJrcPOvZrKhFXiuDd6rmfMnPJ2/r96ukkJKKJc4jkVQ
	VT/7zdkzm7v/pABWaL8Xa6bqbugD74q6IY5jj+G2Mlpcb69ExUAohcn/40UmiJF7bDx8QHOdBL2
	soGoXu3Lu5QES9ahlF9NAKYw7jlQ1rqB0VLFivWHK0hR4v6/T2k+pHqb8w==
X-Google-Smtp-Source: AGHT+IE8N7G5ZMX8yhFrPWTo2+eyJG61iivqbSEnTKHNylAo98g72XT/fwZKtMQKdMIZ9jaL9LDILA03/6U/1ZDu+DY=
X-Received: by 2002:a05:6820:c09c:20b0:657:4e02:34a7 with SMTP id
 006d021491bc7-657909ea6bemr3364076eaf.1.1763979925341; Mon, 24 Nov 2025
 02:25:25 -0800 (PST)
MIME-Version: 1.0
References: <69229bf5.a70a0220.2ea503.006d.GAE@google.com> <744134e8-387e-4429-b878-87161a45113f@lucifer.local>
In-Reply-To: <744134e8-387e-4429-b878-87161a45113f@lucifer.local>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 24 Nov 2025 11:25:14 +0100
X-Gm-Features: AWmQ_bmwaRt-mF5ltu5IuMzYeAZdEdJO9bG_QkA3weUaPun_Mt3iu8vxulHWaBQ
Message-ID: <CANp29Y7zio=dAByyup8joNG2Ufas+ta=esOShvOMu3j9tRHvRw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in vma_modify (2)
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: syzbot <syzbot+3e03c904429660114599@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8AE9C40009
X-Stat-Signature: ctj5xodzcdmxsfueqt5ki8jd67xjr615
X-Rspam-User: 
X-HE-Tag: 1763979926-611202
X-HE-Meta: U2FsdGVkX18FvJRHEpM5hqE/q7IXQt6k8jJNjYseOK/VDC4kWokUQdHRdDi0is6Mk/GzZmIUP6Mhex25WxEe6HL11iPGle5Vl2+SsCGGbwbYCcXnD25pJrPKc5FzxInkXP8fawRHaCcsBIQ4fgj/qYC+JSS9k8A1WsfwtrZabHDbzp07kChbsGvwVejB/mebJ5yzjq1ndxotyTWJHM1GCAs7cveAeGhZEha4Ce/vq66Ab4L98PsdKIk8zhoE7Ly/lTtuyPw/H6NndQBC1bvsQdxOABB6V1mbElX8rCy9DbhqcyUhlMUajzA27r0bZp92YW5959Lv2qlNg1ZByxswNeBXO+s3/a20GRiw9TK3P4eWSUkKWx5FQa41kZ6Nxe/Q9q6kOU/3BU3uzH00jOmbygM5ise59x/9XrxjF6ubdQeWxASUnxNevoaiOlgE/7N3CIDdBfUASt7Vy54q1co8Ya1Hj4hT42IKTDTdyGH99gz5RYOrcNqZxJ9zPVjc15Lz3Uja5W8nl8V6Qjav+v1xUcT1e+HxnvGYtMdw+3T9jMw+/1zAUa4h3nA2e46gJThadv+YG7DEQ0WKE6IgLZn89PaWYxIo6HziR66EElH37nscxg9g9LRPXBOnJMdSFDb64Yd3uexFIRJC9ull3B1VMQaufqp49MSUHxDgHMgnFFb3p/9Q92IWdGTDNldk3f4Sfz/Vfqe3+DGouuey9lmlasPlviWLNO3etVxDSGFZv/WmnWrofDz4nqWOHJ++fmeZJTb0rIi1qddIWpgNZeUFuOuejL8X1AWdXYStOPkFZMelF6fXFBVOcmN3H17FtRFLeNCMdJMYMBnQO/StveYD0W2jJuJ7TktbkQGgTuOzZC5wF/dL3guwPr0Eek9uzccqsFT0xcvYLHOVx3eRjkcvFqk6K+HvaUQAufa4mGCN7KUiFgqghrqv13EvWWOsMIMkl1ja8BiJzGXE80o4Ki7
 YY3FKVDL
 qjHD3Ef5kFgzyb3CedlEqgDrQNKoWCLQH/YQwlEa+UvVuGKZSzL8h3ksIwohWn1KxKmx6+jXYqlOK2OsIfAShm3HkQUPxUPG/13i3SOUh2gg5XKHHHW8fvKuiDrqOJHPyDd+FupJHOE6Zc0dwPyN307R5yWhYTGDIy+9Ht1Hu5IeWjULyrNle5FSart0GFpvKE7TtyAhYDv3Lx2JjLkJR0H07BfrL6CUYQOUfSnBn7Lz5tdRmfIh2hkk1DYqD9Mh/mx8Ahdip0LgTAiWHPIkCIm1hmW7euvzjSZpykkgr8uiF4CuzNPbe96JVcKmPCHrqs+9h0pMv3qADh5t+6AG4y5oNCxjHqSNg35eFBm49MKqA6i+WkjzoTX9D8L4kHkMNawXD1i0286FuuTwCec/68vB+UObDHgujUhU9mXdboylJ9iIibyiCyJPYqJ0fzEOfWge202rDCTwMFx33PKAXIyA4PaxKxUBKnlqL37+qCC+DfMg0iNcLPLN1Sr9+QdF2en2nrHWjRFEw5RJCGqt1nWb/yF75udXgY4UTfBujyLhwBs/jQFN9Fr/SAwpOUhr9pU3nWxVoeTv4gzZMEidUs2kJ+V32WpPBJVVbTcpglDsrmM+yDwq3VvyDhctOkKEPb5EiM65yvzTnQ9ffP2+pWoIzPUfbakn9ns3gOEcdqBl/ukCU8V9LWQw/8tbdXQSLTkdtXBoUuZhooTX58ihc25g5iDnIyK8IfSdyWB/OvnaN/sUSjpd45/Q7n8Umi7ewPnho7PZDbAQHAvsWrmixF1N4QJgWShppGOk3jd9D7zONsKDbr6mxuMvPpMYB3cxN6oPJFNld45MS5odV+AMSrZ5DQqQqvmiJaCZlFsUmMWZ2J2mMbk1X9U5HOvtoQTSGrrh2Fbj2jmQ6d6X0d/iVR+madk/RS2k5/Lfiwt3Q6nYmUG/RjwkoY1ZZJ0KxCuxDL3kXaLatI/SAEYE+46xHBa0kyOxd
 SH4yJaOa
 4lg6Ubr/Smokp1JUf0Mg3QL+X04Vzpmb2dnANHhR2X4Rh3QwIq/gXq5DEkhcynV00l9K+eTsq9CsaiUHqh/28Qt2VWTSIf5JY0XiO+EbQJ5/UMyCi8HlwTEyH6/wwrkh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for taking a closer look!

On Mon, Nov 24, 2025 at 10:53=E2=80=AFAM 'Lorenzo Stoakes' via syzkaller-bu=
gs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Sat, Nov 22, 2025 at 09:30:29PM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
>
> Hi, thanks for the report!
>
> >
> > HEAD commit:    fe4d0dea039f Add linux-next specific files for 20251119
>
> Hm this is quite far behind!
>
> This is a known issue that has already been fixed in linux-next.

Could you please point to the patch series that introduced the original iss=
ue?
I'd love to debug why https://ci.syzbot.org/ missed it.

>
> It'll all be rebased so no syz command is going to be too useful here I t=
hink!

Yes, we can only close it as invalid so that the report doesn't stay open:
#syz invalid

--=20
Aleksandr

>
> Cheers, Lorenzo
>
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1011b212580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D151bfd5098f=
42253
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D3e03c90442966=
0114599
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12ed96585=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11b0f884580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/8ba50fe0f8f3/d=
isk-fe4d0dea.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/b6fd6a81a075/vmli=
nux-fe4d0dea.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/78cb38ef15c3=
/bzImage-fe4d0dea.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+3e03c904429660114599@syzkaller.appspotmail.com
> >
> >     7f6714fc0000-7f6715b1dfff: ffff8880734eea00
> >     7f6715b1e000-7f6715b8dfff: 0000000000000000
> >     7f6715b8e000-7f6715b91fff: ffff8880734ee8c0
> >     7f6715b92000-7f6715b93fff: ffff8880734ee780
> >     7f6715b94000-7f6715b95fff: ffff8880734ee640
> >     7f6715b96000-7ffdfe1f0fff: 0000000000000000
> >     7ffdfe1f1000-7ffdfe211fff: ffff8880734ee500
> >     7ffdfe212000-ffffffffffffffff: 0000000000000000
> > ------------[ cut here ]------------
> > WARNING: mm/vma.c:818 at vma_merge_existing_range mm/vma.c:818 [inline]=
, CPU#1: syz.0.17/6004
> > WARNING: mm/vma.c:818 at vma_modify+0x1614/0x1a70 mm/vma.c:1611, CPU#1:=
 syz.0.17/6004
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 6004 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/25/2025
> > RIP: 0010:vma_merge_existing_range mm/vma.c:818 [inline]
> > RIP: 0010:vma_modify+0x1614/0x1a70 mm/vma.c:1611
> > Code: 0b 90 e9 c4 ec ff ff e8 ea e5 a8 ff 90 0f 0b 90 e9 04 ec ff ff e8=
 dc e5 a8 ff 4c 89 f7 48 c7 c6 60 e6 96 8b e8 5d 85 f2 ff 90 <0f> 0b 90 e9 =
6a ec ff ff e8 bf e5 a8 ff e9 59 ed ff ff e8 b5 e5 a8
> > RSP: 0018:ffffc90002ee7ae8 EFLAGS: 00010282
> > RAX: ffffffff8b5d946d RBX: 0000200000ffe000 RCX: ffff8880326c3d00
> > RDX: 0000000000000000 RSI: ffffffffffffffff RDI: ffffffffffffffff
> > RBP: ffffc90002ee7c20 R08: ffffc90002ee7667 R09: 1ffff920005dcecc
> > R10: dffffc0000000000 R11: fffff520005dcecd R12: 0000200000ffe000
> > R13: dffffc0000000000 R14: ffffc90002ee7c00 R15: 1ffff920005dcf84
> > FS:  0000555555b5c500(0000) GS:ffff888125b72000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f1609b292d0 CR3: 0000000073528000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  vma_modify_flags+0x1e8/0x230 mm/vma.c:1652
> >  mlock_fixup+0x24b/0x3b0 mm/mlock.c:481
> >  apply_vma_lock_flags+0x285/0x390 mm/mlock.c:554
> >  __do_sys_munlock mm/mlock.c:691 [inline]
> >  __se_sys_munlock+0x150/0x270 mm/mlock.c:680
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f6714d8f749
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffdfe210298 EFLAGS: 00000246 ORIG_RAX: 0000000000000096
> > RAX: ffffffffffffffda RBX: 00007f6714fe5fa0 RCX: 00007f6714d8f749
> > RDX: 0000000000000000 RSI: 0000000000003000 RDI: 0000200000ffd000
> > RBP: 00007f6714e13f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f6714fe5fa0 R14: 00007f6714fe5fa0 R15: 0000000000000002
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>

