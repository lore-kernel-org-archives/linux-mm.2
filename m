Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F555E74908
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2BA6B0005; Tue, 23 Dec 2025 22:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FE06B0088; Tue, 23 Dec 2025 22:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA37E6B008A; Tue, 23 Dec 2025 22:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC2056B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:53:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42B0DBA2CD
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:53:36 +0000 (UTC)
X-FDA: 84252995232.09.9F67FDE
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AB5140002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:53:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3vWNLaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3vWNLaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766548414; a=rsa-sha256;
	cv=none;
	b=36gV8wR6C8VTz/XSSB5xn0sMEuw1V/C2h2vS3uz7HWOds7BFxEW+UdPhdmZs4c6ETOAjeN
	2hur+hhkd9byq2aLsLEMZ9DQC+9Mda7363MOUKvv4/lMXahdbaDWLPwI247UtkuGDcSYJd
	WETMjs9oXaKw8/+hA16gSSS+qeK97PE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3vWNLaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3vWNLaQkbAAQw23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766548414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=GZ2XVruqgaKKMSb8eZfKARL59cGvhAsy4xuvzE/p5E8=;
	b=Jk35FRq/BIbT3c5AksZ55dkig9gkClLBAns09oIHiA0eLg/NG6a7dCjpbvaoQXduoz2OW2
	v2NvxglZKo9+VlBtErK4SK5ePWHjVnQGe+ocT3lclEpbUvg6O3zjUcmKfB7fl72OCiKyeQ
	FYPdl6pLrVtSBCSYltB1ScHraAko8OI=
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-3e1383751f1so13221467fac.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:53:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766548413; x=1767153213;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZ2XVruqgaKKMSb8eZfKARL59cGvhAsy4xuvzE/p5E8=;
        b=FtXrYxHLmsgC+yfpvx5h/pNeLqprj4ini88lNL2Zd0GeNMEDFlU/v1rU4CAgn3WstG
         R2+PApu/IbO1N1nzKQ7/v2GQMRSjXu7FnTyKZ3Jx4jwPYPA0cxRFZVeR87mWiJVWqt98
         W8bOinTeOQaubvWr+tLoVgvQ1uep2tzqhNVnPkwRXzRKR3ZbyB4TG7IHL+BqUqwwbMks
         4O0+9aBxiInJbDDqSGMeZo5sSOpDF06OKkUduLUfvADNYOofW8NBShRHCNOek3xJg/iu
         yGdOWdkHp9VlDT6WTiAfPDWoa0HaU9J3HvYbjTWBL0tOLzAyY9FwfUSgL1grLmR3ybYu
         dqhw==
X-Forwarded-Encrypted: i=1; AJvYcCUfb/qeIN8TxaA6ufQISPE7HYVuVbw6Y1TAVwr7Bn51lNulIHiAAPIPMnscHrTah1cQhS1lSiNdbw==@kvack.org
X-Gm-Message-State: AOJu0YwrOC1KnYqgmdlXDIsCVpLBvw5dA7N4rJSZpsOfGG1V8ptg8k4j
	IIF3FBSk2Oef4LBdabpF5NVP9ejDsVorhloBb2kKPuTwuo6rtQGSx+P+hNakkfOlDfpQ7mS4yjF
	9gyPQue2hx2SFkxNr2hNbpu/rQ+DsbYtzwWytaZG1XwxJqNNYNAIDqLMjCoE=
X-Google-Smtp-Source: AGHT+IHGbiqSB+vPnSXXoPD40uG5Ob06csM8wTfUxZCIqMfecfiMubQh0zTZj7guumcFVjCnmGdcYrDCs+nZOlejmqiKsejvv+xc
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8301:b0:65c:9e6f:f4d0 with SMTP id
 006d021491bc7-65cfe6672c2mr6065985eaf.2.1766548413394; Tue, 23 Dec 2025
 19:53:33 -0800 (PST)
Date: Tue, 23 Dec 2025 19:53:33 -0800
In-Reply-To: <20251224020424.52976-1-21cnbao@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694b63bd.050a0220.35954c.0012.GAE@google.com>
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
From: syzbot <syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com>
To: 21cnbao@gmail.com
Cc: 21cnbao@gmail.com, akpm@linux-foundation.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, chrisl@kernel.org, 
	hughd@google.com, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, pfalcato@suse.de, 
	shikemeng@huaweicloud.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5AB5140002
X-Rspamd-Server: rspam03
X-Stat-Signature: 8fojqztafa3jwm3qjynqgxu98xwifbjm
X-Rspam-User: 
X-HE-Tag: 1766548414-728656
X-HE-Meta: U2FsdGVkX1/H4bXgabkuqJ3IDjAxeTkzfeKqSSgpyZUktLZTSW3Qxw8tPRh2hAeOEsreS+0wrH/HW8oYadTfiI4MWVrCR/4G/EYI5GTKFaGbaspY0Xm8MfecWXYd8M2i0YD9Ggy4MeN6QSyd7FEep70DXp8Wm75Xdk1IBgcnb7cVH6RQDe3ia15xNIzYX+2dSPXvxIB0OeMhZ6TkFLjUAU6DsdMgbmmCJIwZAPIYJXXOH3VFEr3x0GbLwcHI9cNsrT7yndKTVe1c3Msgnt0Dtyw56I2vr9uwc1PLttSoTXEPrTcWAj7i3ZOeMv9uByG94Do14HJMDA3kif3c0STuVFwJqwI+fVLBqsT96ZGoUZzctWl/pCpG5sI0TMYsumlwMXVMw7i1j+TTQEwSS4N4h9+HtHzlAuBS9+RRwJzdrdvIh4vIP7JrhZ6CkV1iMiN/2KJnUAMyX6bbbv2NPDlPonO+HKAkOh05NSwruKqMjYb71nJ/YPHCFm6RIKIyVvEo2tKgiNWIAFB8cMRk1uA0S9qic5luxw7mqOotJ5+dK26zUEQcqPXf08A+p4h6fTlvsyIkn3rx0B9YCOGJb1u30RdcNUAUY+zB7vDsADdTKNz8JJ1CTLpRTWbLE9p0o9Tfx9zDLBOEuZmO8Lq6QQahYgu5oL1yJxPCAd0mg6AyJqLLNt0oA9tjQg3OOdvmv9NZSnDi6jmg6lRFEdmYSC398jErzXcBGf4Oa0myFUmeYYArn6iinquAQlwgLBXXqrdkZn69u0YiWhM7nanTfJve3pGoRsZNb68ItETKNxr4paiHrNPaMmUbQkTS9i6+ac8T0no6opUPApIrjwsopQoC397y2ebLBynfcbpds/q35MCiDVm+gJ9M0uzhiOiETtyArpzBUNJp6DEijlwt07AxRZgqofhw9tFrV93fDHjp/fGasatkhwN1IniTudm2qtSl/N4Z9J4F6sEio12XLHd
 qBM5fRNv
 oUfsiunZaPKsscoyl1a2/0HxAqwV2L8ikjTJs1/LtHBy99GeZb6c458r1htV6nz9qrseuGVIe6Bgtbf13aXys9Dz+WVOOB3TNJaatSvZNh43KNcwEILPqSEgWNZdOjcM3CRJ88vxXioMEi0sCYGbEBHzr7CVy6wRfZtO+3r8IniWCMJUtw0PefyH3LzEQ8LW722QfI0pdNxjTL87VjCHP0ngw8BrLCzcvYe0awL32O2hUx9Ug3KwKT0ASdd+4Qp4+r+/RpJcyLl+0cuSVaaLSFkyaKTFp4Irdk+4CcQNO+zVnosKwSu7sCc0vf7UcacgOwlVgYfBzHYTrToPTsHgTgMMlMTUX2vpV+KDOdHZOZRMcVbrrtyAjyDjq1pAw8+KrOs+2paI+0eMLDLTTzkuBhxiM/OgwGSJnusCOOFjihh+zyXqZ6LPI015uRveOzHcFoM3j+O1scnk0M/8BVTm4x5G16D43ND54y5dtYoI/vwDOg1oCI4g2fJCZtpV0YG59RX9nY7iUYcRRN7enL53P1yaB/j5qa/SMWXuf66m1Ln4/hT+oV8+YUUqWRzk/Z1zi9JzMQoHHdHsgpUwiMmdQpDsA6czso3DutbCeMku7fCMb1oT8AAJkqFC1Q5h4GHmsrHnbFZ+OV+bvZJ0+zJrFaZ0orgOZkuYie3m/K9ZChWGgBkA6dkWYsLfITVuW3qL9U0PLl00lU4zHSo7Kqz0RBZ/Rj6nFDDN90vC1zTd+vPevBV2bJgUOD9lyKwzi+3cdGJXriYrZ2NRNmUDJ1PgyP/yR988edug0AEvWnQJusgc0k1Er/9q2gSt+VsMe5DeF5JKIXfiukiYmpL3Ocqu6wRz1Hjs3TntdanCy8L0WUZhhRIjKPCOXsQy1FVlCjWEo3lbM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Dec 24, 2025 at 2:43=E2=80=AFPM Baolin Wang <baolin.wang@linux.al=
ibaba.com> wrote:
>>
>>
>>
>> On 2025/12/24 08:16, Barry Song wrote:
>> > On Wed, Dec 24, 2025 at 12:43=E2=80=AFPM Pedro Falcato <pfalcato@suse.=
de> wrote:
>> >>
>> >> On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
>> >>>>
>> >>>> Uninit was created at:
>> >>>> =C2=A0 __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
>> >>>> =C2=A0 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
>> >>>> =C2=A0 folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
>> >>>> =C2=A0 shmem_alloc_folio mm/shmem.c:1890 [inline]
>> >>>> =C2=A0 shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
>> >>>> =C2=A0 shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
>> >>>> =C2=A0 shmem_get_folio mm/shmem.c:2662 [inline]
>> >>>> =C2=A0 shmem_symlink+0x562/0xad0 mm/shmem.c:4129
>> >>>> =C2=A0 vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
>> >>>> =C2=A0 do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
>> >>>
>> >>> +Hugh and Baolin.
>>
>> Thanks for CCing me.
>>
>> >>>
>> >>> This happens in the shmem symlink path, where newly allocated
>> >>> folios are not cleared for some reason. As a result,
>> >>> is_folio_zero_filled() ends up reading uninitialized data.
>> >>>
>> >>
>> >> I'm not Hugh nor Baolin, but I would guess that letting
>> >> is_folio_zero_filled() skip/disable KMSAN would also work. Since all =
we want
>> >> is to skip writeout if the folio is zero, whether it is incidentally =
zero, or not,
>> >> does not really matter, I think.
>> >
>> > Hi Pedro, thanks! You=E2=80=99re always welcome to chime in.
>> >
>> > You are probably right. However, I still prefer the remaining
>> > data to be zeroed, as it may be more compression-friendly.
>> >
>> > Random data could potentially lead to larger compressed output,
>> > whereas a large area of zeros would likely result in much smaller
>> > compressed data.
>>
>> Thanks Pedro and Barry. I remember Hugh raised a similar issue before
>> (See [1], but I did not investigate further:(). I agree with Hugh's
>> point that the uninitialized parts should be zeroed before going the
>> outside world.
>>
>> [1]
>> https://lore.kernel.org/all/02a21a55-8fe3-a9eb-f54b-051d75ae8335@google.=
com/
>>
>> > Not quite sure if the below can fix the issue:
>> >
>> > diff --git a/mm/shmem.c b/mm/shmem.c
>> > index ec6c01378e9d..0ca2d4bffdb4 100644
>> > --- a/mm/shmem.c
>> > +++ b/mm/shmem.c
>> > @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap=
, struct inode *dir,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 goto out_remove_offset;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode->i_op =3D &shme=
m_symlink_inode_operations;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(folio_address(=
folio), symname, len);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(folio_address(folio=
) + len, 0, folio_size(folio) - len);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 folio_mark_uptodate(f=
olio);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 folio_mark_dirty(foli=
o);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 folio_unlock(folio);
>>
>> That looks reasonable to me, though I prefer to use the more readable
>> helper: folio_zero_range(). Barry, could you send out a formal patch=EF=
=BC=9F
>> Thanks.
>
> Thanks, Baolin. Let me request a bot test first.
>
> #syz test

This crash does not have a reproducer. I cannot test it.

>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..835900a08f51 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, s=
truct inode *dir,
>  			goto out_remove_offset;
>  		inode->i_op =3D &shmem_symlink_inode_operations;
>  		memcpy(folio_address(folio), symname, len);
> +		folio_zero_range(folio, len, folio_size(folio) - len);
>  		folio_mark_uptodate(folio);
>  		folio_mark_dirty(folio);
>  		folio_unlock(folio);
> --=20
> 2.48.1

