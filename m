Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB276D39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD4E6B0089; Wed, 14 Jan 2026 12:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7786B008A; Wed, 14 Jan 2026 12:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADBB6B0093; Wed, 14 Jan 2026 12:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09AC36B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:30:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0626C1DA4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:30:03 +0000 (UTC)
X-FDA: 84331257486.05.7C538BD
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92C8C100007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:30:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yTG8mLZ6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411801; a=rsa-sha256;
	cv=pass;
	b=UC+L4CaYM6eUV93y+QvEZS4dd5SAjIx8cMI4tRlIFMbqd9g72rsU1FVBpXTe/HXClxM/FW
	Y49OTBC/f+bqEe9IJyfDJHIFoGnuD1PrdMftoucmz5YlnQlJ2HN6byIjgUeSH8v5JvyaSS
	TOf1vzsPLQb862wPql7yzgubxzZeGRM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yTG8mLZ6;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of jannh@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnyhC9GK7hBOachWXyV8AkYNbzuqJQ81tevxMlLvUM4=;
	b=KAbhfkpqjeGvQnGgbvtKFy6Gg5Noah+Ybe2c12cPpVD7kiatoIx/iM/O8tu4y+iXEEwF9h
	fgMEW4KEUOBNdjjpQsnfyRIxlQJ5yb+AlvYKW16B9O0ZKWBkylrHcmIjniwPGjTuzmXxv0
	dq72pVmzUcurLbsAe3FDYcszUqgh9f8=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so11576a12.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768411800; cv=none;
        d=google.com; s=arc-20240605;
        b=EzPbgj4oK8jo6dEik5Byt+y8pAFXd3nM4YPZMzc8jb0DxIjOv6UUAElgxKiEqYZXeE
         UQSYhOckaSLajwti79buaL3538pK/2CEhZ78i9LNJo+jUnDmRTeiIWwDHwPmkSOBC3bO
         taUWAocrkrtuz0qfgTnWZGq/MIcba0YhLvGnnwIoyJnddGEKuvJ5B8y6S/J1PJ77OMyO
         BVAQo3aLPUJ3+rKF6k5QhxsharThUhWiGHIyhYatK5Am8gSdqkfTC+LZ6x3oGKtLHNhT
         AtVC3mi9sfCq/mheocK8Uj9RMFXFCgYgaMwLXgHFojYC86AvXbnpD77a5JVdXV8gQyAX
         cUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YnyhC9GK7hBOachWXyV8AkYNbzuqJQ81tevxMlLvUM4=;
        fh=2Z9tzG58PwnIIWWCqnux6/yzbLN6rMwOxC4RvpO2hvg=;
        b=MMakw5aQeQucYqH1w2WvrP4ejiXAaJP/e04pPE5g8dDWe73Y+sMKvwZ4h+NigrXDTw
         P8JqwMfQirhQrD/py0xR6TfrUz+x0h0vzfZtB7odDk+sBLfaXf2EmKnVL9Waob9Q/hgY
         CAQZ01mUt+fhiaXoJqrMVpvVbS2mIET8Hxu+Xv0dTtwBml8wtPYngbhAknIYx/+xx2vN
         j19egcM+6zzA3FwBe6/t1xEjCWiIwgDH9zyitERa2Jay3ZrCe4hfdkCijMAm3NxoD13v
         RvFfK7pEUZFqCqD+Ga/Tbay2jUPx0m2rY8NdMufA1g7wN6xoBQCEjattsy7bscYWY0/V
         3cdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768411800; x=1769016600; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YnyhC9GK7hBOachWXyV8AkYNbzuqJQ81tevxMlLvUM4=;
        b=yTG8mLZ6oFycvl6WcYOArXOQr7UvBxyKKAOAVNUGIaqjtxP4uJGkSac1ABDcXHG6Ry
         0lhVjXrrsf8+dm5T4cTpLMTkaREhZol0qva222fvQgZPSjrOZT+YEb5LQRZVpwtKIJJy
         BW1qTT+NdLEMDNF9NW3q4NuXQFvac/4H5L6gDyK4ByIHvFQpIcnYgKfoGjTmI5Q8gEYx
         x6soIL/Kw7SrsX7WS4gHY+LoSgqreH7AwPg1CJuD6j1goRS7u2Rp9EwGLo8FL4PGbCjl
         Nb30LqJ7rVGvuOk6jJbgg/6VU01Z0P60IxTKBr8lW56E6sy9+wrmFCnj5vaSyU5uh4ru
         M0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411800; x=1769016600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YnyhC9GK7hBOachWXyV8AkYNbzuqJQ81tevxMlLvUM4=;
        b=MYDMPkKu83XA2la4j2eMJSlTgpqCgV2O7XDPFki6tn5Qpjqs9YHRFh+4qKiuHarkCt
         h7PwOrtyb29BzKwGfUrdpY3K7qmu49hkBZQftc1z7QChfCi5ucy9grMKZk470fMie62k
         aD8FmKNNFdZGnHReaDY5q0Uh2kjegiG0CnyjCkPzj1FU7t1wgAhavxferspmZ4XCW4g9
         TUEhyuS3VEwE3oOS5qjAg4uChiyTzxWqxy6I0ozELa3UivtooA9EpY1LaW5lMfrOBsin
         EjiU4RIQcwPBQWwdtveFsL1hHoTv3p6AXpW4qFYyzsZi7CyL9XXmJeQzVXyFsSF8H35R
         0AnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX20CoGpt+hPYN3r7t+Jv8IaZb2WyCN5hsNNY97NmOzZ86HxvpJFxKiaJOT8HBGc5vaSBtnOBVibw==@kvack.org
X-Gm-Message-State: AOJu0Yx9RnjKftKQ+57b1QkffC1S7YXQWE9XzxoPma277TQ4OS64PK/C
	yZ+D5ZwW0mAvW9/MSgcfnbCiMGaMbChMCaxM/DRnzR2YMH1YGq52opf6O3zl0/r+C1NvnoCshn+
	o/6CdMfwl2MBj8uIaSEWiOHsqKrVDpmNfXAjRDFqB
X-Gm-Gg: AY/fxX4Qs3t66aKBQertekFNxH4UyvB/aW+gvR0zRf/7SQAvChD2dL4VwJL/pYQm9rl
	/419Xv9f8BPXkVrY9YWzOWMXpfNilQWVHNuJLaZs+BR/hJL5EG0vMtLlPlTBa8Lk/Qm31QskfNX
	zzvcCy+TCdtFLDe/4NroOz8QYwaULcIn7whvwgwfil/HPkaWsUzPMYaI3+3Qi2KXuJx5lNVEn78
	ykYdBuhpHxJfMfN3f8bQCxE6eSmgXh2Zjvkc6fpI5jXUWJasn2NohW2OZwfjNtI+dWOsUFzGBf+
	7rwIflLwliLphS/ubm1T+AJ7QA==
X-Received: by 2002:a05:6402:291:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-653edfba76cmr36805a12.11.1768411799706; Wed, 14 Jan 2026
 09:29:59 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com> <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
 <CAG48ez0iyjjZn1U7LeG4SBXjRGo3PR-a0MWEhAJZ02vHOUA6BA@mail.gmail.com> <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
In-Reply-To: <CACT4Y+Z24oSCssMnYwtCkGHpCKTOX2J4x+8HNoGovVxeZ5_TzQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 14 Jan 2026 18:29:23 +0100
X-Gm-Features: AZwV_QgCAfK4wS_XUsDtZLsynTlKLNtwR3wPWS1VSCey_m0Q3Wts5Y5vpwRb2bE
Message-ID: <CAG48ez0q6ZXAk8D3frvXyeMsFDYfmY0sc=PkE6bRM8QP0gEVfg@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: hokcz9m59eay5ran8wckemiu7fkfpn3z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92C8C100007
X-HE-Tag: 1768411801-545246
X-HE-Meta: U2FsdGVkX1/vfwj1JN8QUbQbjCg53FPfHSH4KZ45AazY7vNZzUJ8OVy4C5T2NbiJhSDbpsGSAeSWg4hRvCFjfOcuhKi4ctzvk58gFBuXkuH1OQ2GkRz1rUInfcS8+gf9amsO7iCS1AktltwB6uXz3bmrepe3ns9qDFgTMYGXlxWO6Z0nRiw2JQhQ0+uxhwsV6GdN/txTz1tg9oDlDPrQb9rtny6y0uS59EyuXaxkf5Ad2p3I+h7OXU8GFDUNieJ4AcB6Hvu9a1QnLob0C4+3mhyWpDWd+U7GR5iFXxbt5smxJ2WhejMBJsnAJLFPH/QQGb2Qu+gDcxnxdQqJ9MCwy4pwGYQtQHVXR93hptV/foD5mhjvmwYr/Ypiuw7cUEi3FlMVpLXxjC6ThV0KNB9h/r39/zwm0/q6N2egClqoF5FArCqqVG5k1W/UJLKXoiTe/IhRf6bpgLrGVlMzFbAZJyi0PXhTO8ZoMc559JMo+QkpqeVS++o7RSwnI3poUPy6b45mqfeEbD4R0Rm8Vi7BSJwNPaYxIENp6mv2ksG6Tzv9/8ZWTsdkcY/b/E4gcz74GXkhKwX8AG8J+1R19c9x0nGc5GiebSldKpiAjgbpC2/CzhvWlKCVMtuJAembJJmc07uu4ixCXvYFAqx5hpS5gLkIDE+ZbBev43JnvqZUHOjkpbgOhIVv8yNdzYamlKQDeoeH5MYesxX0Pn6fBiP2iqZ+OcFQ/81sYZZ6Lp8ZUUGNRCwqpCKeZrOm71kdBdArrQ3CFOPGQGWJ69pG7JTkN7Jea9H8W2RxEbOg2JTPst5Wpc+ZlzSzvNaLzf5cl57xqRrVWNHME8sb3zsQBHHQCXaBF4F2m85DYFHz3/f9G/jmCwZJFnW4ku/UoWUZeeXD/d/u6kkzM3yMOi5Vbl5fHM1T7mwzDSJJQ2Z5m2tyJdKYImTorCn7+ZVqRJbVvydBdgnH2DbinpvTckL5r44
 cxJ7m06b
 BZZkqNJKXYHVMoSqU/JQIyXRx8RsiEnIx+hnsgLHi5kHKdKo1jrQCMNWgKB/O8u9J+n7B4muKzCez81cDIJ4hq/0Tg8lX9DB0IXs6jirzuhzKh9cJTiLbsmbHR4w8s6Q7XoKGr11WIlatLUZne99OeRt51JObEbnOgSAJ+zz4VnVFvUBWDjJgQHuG3gzCQhQKXOt2pkzRIm2pQkdUoiaEqVlK40jodcNrcVXnYQwsQgySKaX6mQxOTk3LYoyPqMaWX5KD3ENhUpWrByWS+F6yo9EA1G0b6dXk8tAdiIGzvMlJ7i4MLg9XkkHD3z1hdxW8qDMKKVrgHWVAl5Jf3k8v4YzDee+VgHx/V16VnYcoWi57eUs55u5ipTOTEOZdq54G61IReHD5WkO6fqAapWbigdd7D5qXKPYjuoOC+tmy5tJBPFLvB9h85mFKW3++xvZZa4+N9ZJ1wDH5Fs2Wy1EMGVKUjm/uBop0vrUSZOHwF4rEWdPx3yARBci7ZQQ3DfRSrszIoighGOMdFDBs4WCCfDqJXqtacAXL4efskbP4uqRgID8dDT9Av/cihwp3zp+BCNcbJUQCrsZ/m9aNyJI7Qu2ZHTM1S7tO8O2RA1OVfA7Z1Cq1q/pHYliyXWiXvkmhbPgmUuP2TqCtBDwG5PmkmpKPAuTfMym74/2N14HgieKU1URYNZdEXR3/H9oTa8vvgrks8k40BpyDDIJyi6s8DBQD+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 6:06=E2=80=AFPM Dmitry Vyukov <dvyukov@google.com> =
wrote:
> On Wed, 14 Jan 2026 at 18:00, Jann Horn <jannh@google.com> wrote:
> > On Wed, Jan 14, 2026 at 5:43=E2=80=AFPM Dmitry Vyukov <dvyukov@google.c=
om> wrote:
> > > On Wed, 14 Jan 2026 at 17:32, syzbot
> > > <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
> > > >
> > > > write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
> > > >  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
> > > >  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
> > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > [...]
> > > > read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
> > > >  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
> > > >  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
> > > >  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
> > > >  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
> > [...]
> > > >
> > > > value changed: 0x0000000000000000 -> 0xffff888104ecca28
> > > >
> > > > Reported by Kernel Concurrency Sanitizer on:
> > > > CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W      =
     syzkaller #0 PREEMPT(voluntary)
> > > > Tainted: [W]=3DWARN
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 10/25/2025
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > Hi Harry,
> > >
> > > I see you've been debugging:
> > > KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
> > > https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.=
com/T/
> > >
> > > Can that bug be caused by this data race?
> > > Below is an explanation by Gemini LLM as to why this race is harmful.
> > > Obviously take it with a grain of salt, but with my limited mm
> > > knowledge it does not look immediately wrong (re rmap invariant).
> > >
> > > However, now digging into details I see that this Lorenzo's patch
> > > also marked as fixing "KASAN: slab-use-after-free Read in
> > > folio_remove_rmap_ptes":
> > >
> > > mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
> > > https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.=
1767638272.git.lorenzo.stoakes@oracle.com/T/
> > >
> > > So perhaps the race is still benign (or points to another issue?)
> > >
> > > Here is what LLM said about the race:
> > > -----
> > >
> > > The bug report is actionable and points to a harmful data race in the=
 Linux
> > > kernel's memory management subsystem, specifically in the handling of
> > > anonymous `hugetlb` mappings.
> >
> > This data race is not specific to hugetlb at all, and it isn't caused
> > by any recent changes. It's a longstanding thing in core MM, but it's
> > pretty benign as far as I know.
> >
> > Fundamentally, the field vma->anon_vma can be read while only holding
> > the mmap lock in read mode; and it can concurrently be changed from
> > NULL to non-NULL.
> >
> > One scenario to cause such a data race is to create a new anonymous
> > VMA, then trigger two concurrent page faults inside this VMA. Assume a
> > configuration with VMA locking disabled for simplicity, so that both
> > faults happen under the mmap lock in read mode. This will lead to two
> > concurrent calls to __vmf_anon_prepare()
> > (https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623),
> > both threads only holding the mmap_lock in read mode.
> > __vmf_anon_prepare() is essentially this (from
> > https://elixir.bootlin.com/linux/v6.18.5/source/mm/memory.c#L3623,
> > with VMA locking code removed):
> >
> > vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
> > {
> >         struct vm_area_struct *vma =3D vmf->vma;
> >         vm_fault_t ret =3D 0;
> >
> >         if (likely(vma->anon_vma))
> >                 return 0;
> >         [...]
> >         if (__anon_vma_prepare(vma))
> >                 ret =3D VM_FAULT_OOM;
> >         [...]
> >         return ret;
> > }
> >
> > int __anon_vma_prepare(struct vm_area_struct *vma)
> > {
> >         struct mm_struct *mm =3D vma->vm_mm;
> >         struct anon_vma *anon_vma, *allocated;
> >         struct anon_vma_chain *avc;
> >
> >         [...]
> >
> >         [... allocate stuff ...]
> >
> >         anon_vma_lock_write(anon_vma);
> >         /* page_table_lock to protect against threads */
> >         spin_lock(&mm->page_table_lock);
> >         if (likely(!vma->anon_vma)) {
> >                 vma->anon_vma =3D anon_vma;
> >                 [...]
> >         }
> >         spin_unlock(&mm->page_table_lock);
> >         anon_vma_unlock_write(anon_vma);
> >
> >         [... cleanup ...]
> >
> >         return 0;
> >
> >         [... error handling ...]
> > }
> >
> > So if one thread reaches the "vma->anon_vma =3D anon_vma" assignment
> > while the other thread is running the "if (likely(vma->anon_vma))"
> > check, you get a (AFAIK benign) data race.
>
> Thanks for checking, Jann.
>
> To double check"
>
> "vma->anon_vma =3D anon_vma" is done w/o store-release, so the lockless
> readers can't read anon_vma contents, is it correct? So none of them
> really reading anon_vma, right?

I think you are right that this should be using store-release;
searching around, I also mentioned this in
<https://lore.kernel.org/all/CAG48ez0qsAM-dkOUDetmNBSK4typ5t_FvMvtGiB7wQsP-=
G1jVg@mail.gmail.com/>:

| > +Note that there are some exceptions to this - the `anon_vma`
field is permitted
| > +to be written to under mmap read lock and is instead serialised
by the `struct
| > +mm_struct` field `page_table_lock`. In addition the `vm_mm` and all
|
| Hm, we really ought to add some smp_store_release() and READ_ONCE(),
| or something along those lines, around our ->anon_vma accesses...
| especially the "vma->anon_vma =3D anon_vma" assignment in
| __anon_vma_prepare() looks to me like, on architectures like arm64
| with write-write reordering, we could theoretically end up making a
| new anon_vma pointer visible to a concurrent page fault before the
| anon_vma has been initialized? Though I have no idea if that is
| practically possible, stuff would have to be reordered quite a bit for
| that to happen...

I just noticed that I tried fixing this back in 2023, I don't
remember why that didn't end up landing; the memory ordering was kind
of messy to think about:
<https://lore.kernel.org/all/20230726214103.3261108-4-jannh@google.com/>

> Also, anon_vma_chain_link and num_active_vmas++ indeed happen after
> assignment to anon_vma:
>
>     /* page_table_lock to protect against threads */
>     spin_lock(&mm->page_table_lock);
>     if (likely(!vma->anon_vma)) {
>         vma->anon_vma =3D anon_vma;
>         anon_vma_chain_link(vma, avc, anon_vma);
>         anon_vma->num_active_vmas++;
>         allocated =3D NULL;
>         avc =3D NULL;
>     }
>     spin_unlock(&mm->page_table_lock);
>
> So the lockless readers that observe anon_vma!=3DNULL won't rely on
> these invariants, right?

Yeah, that stuff should be sufficiently protected because of the anon_vma l=
ock.

