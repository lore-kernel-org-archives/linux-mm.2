Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DF0CA0EFC
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 01:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180438E0022; Fri, 22 Aug 2025 21:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131758E0018; Fri, 22 Aug 2025 21:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E3E8E0022; Fri, 22 Aug 2025 21:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB2ED8E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:45:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C5E01403B9
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:45:47 +0000 (UTC)
X-FDA: 83806330734.22.C7E80AC
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57255C0007
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:45:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c+IHBkVA;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755913545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlKW5Pgv256mFzDnuzti/r6dmiOCKNtOIQXBnteKRRE=;
	b=i5MRzfGdjbc92Mt7tijP2ZwFqEvf8YqA0oddXXxN1T+rHPWk2yEmtZEgR44yPvZCOxaVIh
	VreUP1MHgRQmfsmffK1pVu3wjc62w/jpDMMnH84bS0rSA9kklDT8XPsP4knDPfe31sRgMA
	HLCDqb5wvilTkDXcAK3LpX3CxPNvsy8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=c+IHBkVA;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755913545; a=rsa-sha256;
	cv=none;
	b=V0yi7itcGfDQUyd82hiqXKjTXb1KakIcQXNpZrZdOVSHVMGNSYPO4HfknDBV5WRhToyptK
	ff6y1BUCR+dsiQU9IdRwpzvzXfvdX5d5CxtAzwL9vWajj2gSudc2SKX8UXH7B2clT77Vi8
	cvuMnmlBnKgJauPTqu8X23VJsRfXcng=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b2b7563392so9563881cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1755913544; x=1756518344; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VlKW5Pgv256mFzDnuzti/r6dmiOCKNtOIQXBnteKRRE=;
        b=c+IHBkVAAdY2a/mau7902wzrhwq3zJWIZTt9brbzP933YYhzhDQEXYoMCJVuEP9tur
         Um3Cy2Kx794tOHERAf5OK5C1R9TgZnUFYyRe/2rwXexHP/+HVjqF2udMd8kzbfMzfHQi
         Xcjzm3juDHFWA8Z+ZQ7PkBafVER285XARASrMRAGdxtIeejuxpJefBIg2Z+FEvsyOOpE
         ElfBsN182lMmGho4V9xljArO9fAy+nBMbmo7XM7IZlseUtVCf8Ab605CRrrtcO/aUExS
         Ef+WQSoPKsdMZpHGAZolV5vLpLaUnm6hxzUR6oqmuAbIBbBo7e9DPVbo6u26qRFwYUEG
         ZGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755913544; x=1756518344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VlKW5Pgv256mFzDnuzti/r6dmiOCKNtOIQXBnteKRRE=;
        b=qsktaqZ3Ns6HmbXD9h31LgrjlcoHcpoZ7e2g/gJCBjMcNHH9/rOl1w7qHJXrejoF7M
         9bGbenFJuNV2C/mP451z/5UeTOztuA8EDogWpcSf44w+lEbXbj4gFk7zA9AIESK0vZsG
         c9FISQpZaINrroc3Z3ABe+60tGJp6yZa0H/RW2iArudC3jQPHFtzCoTo9IQ5VVwjCY1r
         Yo6O9U1QIydpzN2xxuMtP8kIDe/MRxunxNBL7ryViPpCSuQr2g0a0kIlrinIhMvrw9gT
         YkqjM82XYXILCenN7a0WsJNBIpJa4sAqCV6pqXqPj0Uavv0Ei3fpwhxDp3UF6fu9sdXX
         i1vA==
X-Forwarded-Encrypted: i=1; AJvYcCVo8v+DGOO7LkYUWjrqfDZGxh0UnyjXo8Q2skhQ7fGGff8IItzpyB5NVCigeNhixSjmVQH2nTgeAQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0x7YW5XEmbhZH7foumSZjfEmPo5tFDEYqyYoa7I7Mpmy2txQ1
	x0eZCkthCZsfHAqGcG8HgkxbkrDaezcQwNiOffg69+m3JIcVnP0yYbvZtWWefZN3IreJwiePtzE
	aZtnfCtpHU9pBf89hxVniBJklZFKNWsyjAozNCLTXfw==
X-Gm-Gg: ASbGnct8zjx/q6J/mRRQarf73CoudWRVsa5H4DjaK3hy3ynqAphP1PIfvZQbdlqkNt9
	w1iJPsxuK+AU7nsm9qvcvCSZMN9OVi3ul0sTXiThndOJJ4ID1utD6H5tfgo3FJjqRqMgj+A2eR1
	u6JiwwDXimGp2YLVPIZOf+zoEJh6aXRQGew399bpP3UhDuEMttG/i0W2BHDhm0bBGqJfmpON5L6
	rLyjQJpXW2zvp4ds369Fz5/WHQTSy8dan0E
X-Google-Smtp-Source: AGHT+IFJ3PRRZe34Y4dSRHIRs+lJLBqamedt/1JiUCGODfabndaZOKA8Y9oOxhqNavyQwvJCLdmtJ4j87/jk0IKCppU=
X-Received: by 2002:ac8:57c4:0:b0:4b0:f1f3:dd71 with SMTP id
 d75a77b69052e-4b2aab3af96mr62370361cf.52.1755913544346; Fri, 22 Aug 2025
 18:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <68a7ef20.050a0220.37038e.004d.GAE@google.com> <20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
In-Reply-To: <20250822181653.cd2024360870ef94cdb7db07@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 23 Aug 2025 01:45:07 +0000
X-Gm-Features: Ac12FXwM4kAP0laHI3d1brUQefKqoyrow-mZmbYi0Nok45Ky9c4wi2PUkolUc_s
Message-ID: <CA+CK2bBrv_Cvhce5N_RoNjaSL5380he3ZRaDeTC79hhjYxSmRQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] kernel BUG in page_table_check_set
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, Andrew Donnellan <ajd@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 57255C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3ykzumg947gpc7kw5fbpkky7hinuxqhu
X-HE-Tag: 1755913545-558392
X-HE-Meta: U2FsdGVkX19gpSkine/G2r6xWEFNWm/x6W7As5QTKTtB+ocVZhRbaie0ESTqWwzidWqxZhqP4LrYnVru68UZpU8PQWQ/Pf8ceYxoOwWqvwKrQRh3L2tI0hW05QqKy0v9IvUjes3ojknh3HPz6XuA/SQttb5WBI1xlXvF70jQNXBjT9+4TfTXAUkGf8h6MyGdvP1OB2GI3ewofu5zplLxSpnZR7qCRF/WtFJuAiLHYw8zmUTqKx0igDXInI1aDWmxXeoRSF0GnQpZfxGYW7qvHUvFJuJsGiv6IYhv2Zhk78onxRRtdEaQT9d/YciAHP9ErHZxKFxp0sU6AYxk9S0pwzX03NzWs2uUFkkZXOD5ZbNfafrqBoGf/77aD2WBbaL2wDqhLhhuuZ95LibEXjpRLXSjYucuEaNTj7zEL54m5llXqir49nJdKvLfwIDHf8+bR7XwujQ2N/FWtgtrIFiboLIWUmItoDbB4y7i6VU28aQKRFF2dclf8ZK+tB4djsDIHK95D5Ol7AbDTi6Rnap6A6Lmbm0xfULQgTqrn4UFM4ZMAt1mrcoeYeeH1e0V/Rtr0n5tzBPLJNWHdyMKotiOKZRx8lK23M+WnZAAPHnkHNjwJuJRRrwRd28XQ871mHlKmIZSOvV7lc7eNOXKudcc+yRdyb4eJ4skWkP3MdhCTG7nF1WA+YVlMRbQtreUpHd64Ho+wM6sw0wsFhmTITJDYY3A/kHZnw68xOkIWSjzI1NZADVtELYn9kM6PDC8SiyVN1mnb+zfHplyIfWImTW5lLm/+v1VyOZGpw1mH6LIEr33Olzy5LSlaBDCYQRVfROskp7Vp9RVPJnSe8HBVbemi9aJPOC7GNRbfLJezHgOLoQW8lkdmB82FQZaeuIEQ0uhAfVuJ+luNjVc/B2Vfv34koC3zy6MJ+h5ogs6rfo509lx2u4EnigCpkAiwVTOqPpNz72lDbSQEYY4z6fNevG
 BQgMW1Ud
 j4Jm/tolXiAuAj+wLf7MZ9tOosZWxTudQssMhvuQcrWzT7A88fiQhzZYjsP2TE4Yab3lS+DnkPXTnYrBtdZxeygdrjUPam/Kez2dteJB47gwBf2p5mOGTPHZwAOfyk7yQl1AaX8RM0+f/Mg8NY6tJqRFZLNClGoYf1epwEc8sYbmSE+XeLiS74stVjQnOS3Sr60n5i7r5TUMDY5c97zAN4ewRw0EdkRLdRjh2La/rCmF+9gXH8/Lj4wFt3x5LEvzM2YxXHoK99qP8q9gB8qb+HImrIqWEEHzhxUp3HQa5URc3azZ956fXPPEQAmaRZnfW2WCHXpqdREV/zG2F0CiGfXKEw8zHaj2ubm0cMPsX71Gp41FtWdI4ge51o0sWtgR7LsWIQjB/Enw3+JObqdujATpuJ//80agf8I/EhKwa7D3Glwd+t3D/tsXY7MsquAHBW9neZDgTANcSfXDlZKwqNaZPLWlPrexWbob9xXZleeUb1IctRrr+ohwFA35EVpORO7dS87Vc6GjLcbr6Zk7UnsXgRZpIsYGXtZVYs9y4qCVK/Ue/cGOYSfO+9SfdMH2YlyF4vXGMhtDPPmVEhomcMvpXvuggkPJawGJxGouGGk9TJxvsOTsrV9KGzHxjr4kcKH+FylMt/1CdMlBo6jUPnilU8C176EhC9bZfj6DrQJCJXT2Di2kHf/k2dtOzgmKD54BUXupRKtI2wtWjfPR1LCHBZD+GtSInNDgsDB+rKYdzyk79SVerXPP4jHwetJFGLZSbIwDb23JmD1wGCPHINbWpsPtL7XHaZIdmjB0ipIm9XAYwRAeBLiAcHPpHpw1ka0tx4V0jbCNEycNnXGKZjIJgz28pp4Z1EjxQwxZyZIOqhxDQA5qXX4niYJOEWU7SNNNj/1/7ut/fjD+lconPcuX0T2Upc2yV0ICe0TxUHGzmqf0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 1:16=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 21 Aug 2025 21:16:32 -0700 syzbot <syzbot+49a796ed2c9709652f1e@sy=
zkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/lin=
ux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D15f926f0580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8c5ac3d8b8a=
bfcb
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D49a796ed2c970=
9652f1e
> > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6=
049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15faa7a25=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D144143bc580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/d=
isk-8f5ae30d.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmli=
nux-8f5ae30d.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff=
/Image-8f5ae30d.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+49a796ed2c9709652f1e@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > kernel BUG at mm/page_table_check.c:118!
>
> Thanks.
>
> Presumably due to the series "Support page table check on PowerPC".
> Andrew, could you please take a look?
>
> The series has been in mm.git for a week so I guess the impact of this
> is small.  I won't drop it at this time, but prompt attention would be
> appreciated.

page_table_check_set()
     BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);

This code triggers a BUG_ON if we attempt to set a new PTE in a user
page table with RW permission for an anonymous page that is already
mapped elsewhere. Anonymous pages can only be shared with RO
permissions for COW; otherwise, it can't be shared.

Pasha

