Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F01CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7428F8E00A5; Thu,  9 Oct 2025 21:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719C48E0002; Thu,  9 Oct 2025 21:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F5B8E00A5; Thu,  9 Oct 2025 21:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 524188E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:02:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2AD9837C9
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:02:31 +0000 (UTC)
X-FDA: 83980404102.05.657B9D8
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id C2E3A1A0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:02:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V31qK56h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760058149; a=rsa-sha256;
	cv=none;
	b=6GGamehff6pGCkusqINDV1sK7Fh+h0A7jxGY6tB14pgl+j41ZDniDhcxprFcRJIZFuNUVd
	FPZ8omaRNtDTYAP/EbCdcKgEGjl7eeXIljNXEJNp7wazJN3nGcV66wtwd+OkA+ZVBYf5q4
	6t4jFFy+RD0i2J7tiUSM0vr5NOjO7TE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V31qK56h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760058149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnR0uJiI/epmSV/1cEgYnUQ4eWwUQy0eIshJnBoMl6Y=;
	b=YHu7G784mHITQwcSit8u6olA4uPAgpC8qiNLLr5m6wT59E8Z13T9nkI38doMIyeVO7jxZb
	fXqRWfEy6Y8M3NYB/4VprxlsQAH6Is8SoZUHC/3+soyWOaop8L3IX7Zoi5TJjtldMfbX+B
	2fcTWVsSQKXJ3+IqFmRX9IiRKB0Jj8c=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so1345494f8f.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760058148; x=1760662948; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnR0uJiI/epmSV/1cEgYnUQ4eWwUQy0eIshJnBoMl6Y=;
        b=V31qK56h0b9TKTRWp5pPY448x7pOH/2mMFzyibmbfGO2U2VcLa6GDKz+Vb+ChDDuee
         d2suBufISZLwwtWA3BoWoEacse5Jt1kl52wA77cvrdQRZWgfe4A6g/1NCZ/BTJW5NPFk
         RbsNRtM62CVvtEut3jbadfTn6lnl1mN7ZhKLuJCKsqQZZfuwocz7m5fynqIsVjwf0Aig
         Z7uIFjBzcJSegXb61Fc/je+/OPNxhjm0KpD9CURb/B/HJIKo1II3PPvQ4v2N8ce7TPy9
         ho0cAnZLmndp2bvdvaTni8+nZipsFRVWpgofD5ulylCL1XKYmgjPZ0gl0wzjLWLVu9QH
         GRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760058148; x=1760662948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnR0uJiI/epmSV/1cEgYnUQ4eWwUQy0eIshJnBoMl6Y=;
        b=aIpK/lzBI2zVvtyCKFBnkgeZt7kjmlQQ4tjK3qS3i2sQbdqmD+TI2GIXWsjhC5cofV
         syYMllsv755oAxyvrYrPNT8k/l0Zn9gYnwGItJUSO6B/YML7FQ9qNWNZNAQ0R7hVckGN
         dAFv9ESCoeULM7JKv0orZ/E71s1BHgopTNTzGykWKLIaN9X2M25JP9oBgAtoQtyP9ZqC
         6Wwz8MhIQHH9IrxwpsS5y2zAaWaoJE7NaU3mO55iE1ufnILbTeEliK8tdyNtcozi1YMm
         LkEIzyXAMy1L+u9iXrNi+3zOkcajkqACnfiCTol/fRk0WS1TP6e1UBTei0NuLbKngaXE
         0AeA==
X-Forwarded-Encrypted: i=1; AJvYcCXMoqQa87G3Y2LCX4I4QJCylD/3WllyUDYgya3dxJnFqKgol8lFaGB+HNudeDdk69xM2TzZwz33/Q==@kvack.org
X-Gm-Message-State: AOJu0YzHKYDfTP3ODa6iWaoE6X41FTeeeh516p/bXXLGJmhQwsKDkqrv
	6TY9WD9SPZqdsZFClWyL5hNpwjK9SMEije6VG5Fwx1hrO/WM/4YtfxYrWoJi2DJuucUh3dkiJIs
	gEWhWMZH7uvdNTXxe0XYXiseyMjzfHrk=
X-Gm-Gg: ASbGncviH6XDyT2zKbnd/bpJWFXfxLsr+HqX5CHpwR7VgSY48ZUyxeMa6WtP8J2QshC
	m4hzHVtA5LfSV+NA9MwLGufUyGvpymEp0teTJWyPWnv6Wp9H1PStgnFMnBEiFzjt5j/aFIeZpMK
	WcbZM6tO4a/mkOwHBjTKn/StVsDloW1t879vnpzmlz4wwp9R3frYPqpT8TcdkJqtUye3qEt5uZ/
	BQTYLlc1TYquS7QPXTf/hpkSQxwmKMmw4ygmeq/gf11JL/az0mFCCwnZOYINDI8
X-Google-Smtp-Source: AGHT+IGH4L1PsW2HSLnPT1b+FvAV7y3XviS/A+70p3mDX7ru+D0SLH/bqU8GIUNA4SjlCEDYSkoogFsoO2+4hU5l5hI=
X-Received: by 2002:a05:6000:1863:b0:3f6:9c5a:e1ff with SMTP id
 ffacd0b85a97d-4266e7dfda8mr6665630f8f.39.1760058148046; Thu, 09 Oct 2025
 18:02:28 -0700 (PDT)
MIME-Version: 1.0
References: <68e7e6ad.a70a0220.126b66.0043.GAE@google.com> <20251009165241.4d78dc5d9fa5525d988806b5@linux-foundation.org>
 <CAADnVQK_8bNYEA7TJYgwTYR57=TTFagsvRxp62pFzS_z129eTg@mail.gmail.com> <20251009174108.ad6fea5b1e4bb84b8e2e223b@linux-foundation.org>
In-Reply-To: <20251009174108.ad6fea5b1e4bb84b8e2e223b@linux-foundation.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 9 Oct 2025 18:02:17 -0700
X-Gm-Features: AS18NWAbHuQ_j1bUNdwnvSYqJz0NpolTFAn_Q_jw8qP8y-DnFQMt1Zor-q5enF4
Message-ID: <CAADnVQKkLyJ0cbLet3q3X+X70FPAejcqTxP66d82WTO82c16rw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING: locking bug in __set_page_owner (2)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brendan Jackman <jackmanb@google.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Michal Hocko <mhocko@suse.com>, Network Development <netdev@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, 
	Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: stthjtxkkbqawoxb8chdx7c8jikcun7g
X-Rspamd-Queue-Id: C2E3A1A0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760058149-811975
X-HE-Meta: U2FsdGVkX1+cI2QloqYfBii5sHpufuzQO19nTWWUjKMtRzknCYIBa6VulM++aXoj+VbwwG/jvEDrHv4hCL0jr1CiP/VECDxe6ww4r3GWXQsxvpXqlZf/dYhPBv1RAjtjM7RH8NuX0MlV9/DjfCENAmeavKdvCIyBbzm7pZriCB3w8BShZtKeVC4W1cK49RLVzovbQOASOcl+EBzZphNtx5Vlpz8SoveUs2p/3ZIpceJlKivgVuvGfib5JIqpWFKaQWW/eyEvyGjPvDIqeCNPDeOPGgh+A5l60IcXFcBeQNOwUF5i5drYOwJIvFIYJEFcYmc9SdFtf9gHj54MQirOprddaw7ZxCcK3IDGP0/2xtUn7If23U5iQAPGpm/M1Llwlof7g+vdPI2nxfJn9T4F/+iAONxGVUYZHroCz5VtWRbOkg786RrUtpg0VDqTH+nZLNrhIhjJnRKtl3XeF1F5Fyz7DYpWEOvW0tflf4tmGRIh/PcTlFRk71vsDfEm5xMwYI2H4hwdLEAl2j3r1f72c4kE4D8rO/Vdpz/7eOivNPf4ie4DwJ81FFm8BnnG/Ri7kK8zGvShkS/txyL+25oq1ii2BkMH2d14J77l/d1ZR2NjP1Ru9Bssjyd5RYkwTL1Esl2vKFQMTXAgbbvSXFYFEWa0CNcjKpLdZz887hRvyvBBi33//5qK89FLdywhcUJMshaV6Se9gUgZHOygI7l+1nmnu6lDFsJmr4qzfG99YFMgbXTE59tTWYb5mmgXQPTP25O6mGFRNElUOR4xyTCdpQAwEBXaArl11aTr1xMIq+i9Hh3VhcAOQs6DBiIbs+UC7cgstznMcc+K6WClGgO9ZbRH1ZIizXYch+2JEO1uJknU7grz3lg1Vn0M630scT0UWWqzYyvhbxkQ6CPx7U+TMmw6Cj6+M4csPlrqhe0jKZJmf4/qQ/zEhrrP3lF4oJlpJSJmK5nWR4k6DapzEft
 V38olZFP
 eWcZHrGd8vBf0SdT2AMxsJTn5Qz6aftW6fm0QreSnVwzQ+GJyF3zCLKD83DB/njuGONYK70zZm19guAB7u0g9FDeRKG1ZuAqaX4o/eEjMmQN67iHpEyB2hDSDnE+Tgf9KYgiy/4aqc9es5cHIysDquaNHOiYF7dK4Or1/LqtlPAwlHSy6VKiJaZhMkgRdRzUSTyyJCrpxcaWnU8D76tTElqQtB7YwZ09y3spAbbRHv1aofdFZ+BrsCVOnpALNjqwejeqUFOoA2SIPdNLpWj7f5CuYY3LOVpFXgVwPFMZu6FZPTXf22eQKl4FjoV3rjSv22C86FT30lhImHf5qfgtYM7j0kKOgt9wm3NisjcznWMQ+X4b4/cq55/Kj3t+83dGkyb93jx1IXOmmQhBS6IcNAhu74+3dbhnQXgixg2avY8j6C8oxaMjWx8oToWBcb+l/NvLBOkgCdkWKROObpwUXhDaWBF0ueYM5Iw0gGH3E+1zzxmV1PCZ+P5B39caBKTbCyFD+ymwvv8xJ/BWNZ/44xFJCl7x+ux0T5jwVipyV68ZoeE09NbLoUkVWw/ra97dhHgWtASUDC+0H8Ef+2/1MNWORWoHJBJzTlJ+BN/ejg05elKU1hM8A1U23LIUWXpVpAVMrkVz+VMx7qaEvoneuReb2uHqPWtRK1Zm/lORsBOoq+nQooKP5ZG8WSo7PeSvyHjs2Czuj6f1dVMVGeDXKtXMZ+7cBxZ2T5nexYrji7/SW75iffxoHe+GFt/SVMipvAbPl+aTtZSQcwIruV6zFiU9lSILQjtDUXhDFN/0z7/eMao9qbty7TcPgHq6HiHANTsD9my/TCYrV4uidj1oS8M2rMli4ylpytzCNIpTsiDvCG4yBEsuY2myuxtAuNOj+TvNPILS1ZXWd1pk15veQVws77pAPjXrpcWpzVO7HFpxJy4BaUU3EfiMbqOAsyGuvjE4YalaJ3Q1MUqOArxE4hAw8//EI
 i0CTNLiV
 J3+fFIYtdo2Ah+cGwlFVBrnCkwS0/19xHG2sDetsF+hdlRCyS59aCcohAHlZbLGMVJZngBNYLGP83IiL87WEGEpWqIk9uCrHQRMrY/7bn8JBAuuE+/yMCajPKv11s0l0nkPxfXnoVWwYuK/dVHqzOqDTXnUiF8yqyBGMaKU6cA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 5:41=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 9 Oct 2025 17:26:21 -0700 Alexei Starovoitov <alexei.starovoitov@=
gmail.com> wrote:
>
> > On Thu, Oct 9, 2025 at 4:52=E2=80=AFPM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> > >
> > > On Thu, 09 Oct 2025 09:45:33 -0700 syzbot <syzbot+8259e1d0e3ae8ed0c49=
0@syzkaller.appspotmail.com> wrote:
> > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    2c95a756e0cf net: pse-pd: tps23881: Fix current mea=
suremen..
> > > > git tree:       net
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16e1852=
f980000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D5bcbbf1=
9237350b5
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D8259e1d0e=
3ae8ed0c490
> > > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f9=
09b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > >
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/8272657e42=
98/disk-2c95a756.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/4e53ba690f28/=
vmlinux-2c95a756.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/6112d620=
d6fc/bzImage-2c95a756.xz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+8259e1d0e3ae8ed0c490@syzkaller.appspotmail.com
> > >
> > > At 2c95a756e0cf, page_owner.c hasn't been modified in a couple of yea=
rs.
> > >
> > > How can add_stack_record_to_list()'s spin_lock_irqsave() be "invalid
> > > wait context"?  In NMI, yes, but the trace doesn't indicate that we'r=
e
> > > in an NMI.
> > >
> > > Confused.  I'm suspecting BPF involvement.  Cc'ed for help, please.
> >
> > The attached patch should fix it.
> > There are different options, but this one is the simplest.
>
> Cool, thanks.
>
> > From: Alexei Starovoitov <ast@kernel.org>
> > Subject: mm: don't spin in add_stack_record when gfp flags don't allow
> > Date: Thu, 9 Oct 2025 17:15:13 -0700
> >
> > syzbot was able to find the following path:
> >   add_stack_record_to_list mm/page_owner.c:182 [inline]
> >   inc_stack_record_count mm/page_owner.c:214 [inline]
> >   __set_page_owner+0x2c3/0x4a0 mm/page_owner.c:333
> >   set_page_owner include/linux/page_owner.h:32 [inline]
> >   post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
> >   prep_new_page mm/page_alloc.c:1859 [inline]
> >   get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
> >   alloc_pages_nolock_noprof+0x94/0x120 mm/page_alloc.c:7554
> >
> > Don't spin in add_stack_record_to_list() when it is called
> > from *_nolock() context.
>
> Seems 6.18 will need this.  Do you think it is needed in earlier kernel
> versions?

Maybe. I need to study the git history of that code to see
whether it's a new path or I simply missed it earlier.

