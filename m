Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9AACCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 05:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A8E8E0003; Thu,  6 Nov 2025 00:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201EC8E0002; Thu,  6 Nov 2025 00:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FFE8E0003; Thu,  6 Nov 2025 00:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01A878E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:58:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8241913B39B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:58:42 +0000 (UTC)
X-FDA: 84079128084.14.CBA40B6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id B543E8000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:58:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ibENVbmL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762408720; a=rsa-sha256;
	cv=none;
	b=cezVutWDc8eUqYepA3Sty8oUqdKTyUi1l4AmfdLWqBU7a6RQabc+Kos5gBDJNJ9WpBXX8Y
	ydUFPsbXs3w4g32Qq9zcyzEvhfh6b5HfrOpAuoXmu6xYjYVllB75U9vmAF1Gdonb/5MpoL
	JUgBMl4+k06Walu/24Asf9xOCRqP9z4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ibENVbmL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762408720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzTY9uLnmKMTRAxdEztuc4L+zqZ9LZYXdyYI+Bt2y5U=;
	b=dSr7uczaanDcnfB3JQOuLznssDpNs15CswgQyEe2F1Q0VVb+Lgbohs22xcLKhqPD5f5fR9
	3rzoRkbReTdfgYxDPGQWRRayDd5X5cIbEoR9aVMyenmOxbhYAa3JhtXnX42qtvRmNmLh4N
	gH2y7osOsou4bwmtinNtJ2sTynqGKMU=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so982741a12.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 21:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762408719; x=1763013519; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzTY9uLnmKMTRAxdEztuc4L+zqZ9LZYXdyYI+Bt2y5U=;
        b=ibENVbmL/EmfksRSrwS09KF3PY1n+30VZTvGvgm+ZthA71AN7HlKppr4v2RGr8yZ0L
         wxNyhZeZRZHt8fd/f41N+B1nONW7nxIWJwJot68Nm3ckmq31E8b3sNlLmAdFNbD0OeuK
         avyoMwvoFDxbDSM+NOmGeLLvlg6GeNaOSiW1SZr6wEeLxzrBxpRFxAQ8IPHS/l238h8j
         J0EL5velLWsEueWKU8lCZBpFSfGN5FV4qW2PabZCWi+4Yp3cY1F19sQQVPBbBMJEeWfD
         Op+srHW4lTxnyBQQA1n5ySqRLkKue/DRpGfdOpDJ0HrWlA09525nzFxRDauLh7Hx++0O
         WFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762408719; x=1763013519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzTY9uLnmKMTRAxdEztuc4L+zqZ9LZYXdyYI+Bt2y5U=;
        b=Xs7XewD2iuXUVscYskt9xQdmc19Cr6py68bntcAsVpMO2d9LOG0NqIe1VtDsxR+wbx
         7WpoC4vkKXws1ek3sY44izzMttTQgy0Ov+wz6JvD3YJ8XBjSHwNxUCv/Op6H8wbFoeDU
         BmqdmqdzdkTojdOQnWFSado1iEtKNVfQCfc0x4zdZycsi1SC0RfFB+TZSpSMDqtouHpo
         KNKqiPKqF6NXHNwcXRnOGolrfC7NWvVnUNxtC9JLjlXxQvxLzl+MVn6augSK1O7f2VVT
         KzYBmiwTsdejIE342Dbmpgc56JlCdyhGbYMCwArYaYkDX/eqMeEyYrgP5R1FiTonA8F9
         cekg==
X-Forwarded-Encrypted: i=1; AJvYcCXU0Afj3tWILJSYsWwZMwdCiRmrS28K0CIi5Q/EuZvZzSMp6X/gGbN0DZn2YrgG3sT0KCYVEim8Ug==@kvack.org
X-Gm-Message-State: AOJu0YzWxE/pKcOqgj3RBBHglrggIZNUvM99Tp96vRPTP63cKuV5m+My
	5t44WPuGh2tpavqtqD6o2xJhrjhcxiRrvy2D9Mu+4fBdHpLZzG96dGoR1u9dZnAVvpouN5wvcDO
	W/u1hIiG3q/mnDUoIrUmqvNEIFqiR/80=
X-Gm-Gg: ASbGncsdF79fhyAt3OeuSkrmA7VJnJ1BPcszh+IyNtFrY4jVR11Ucj+dYaa9FuHWKhm
	H+9RaC7LW2zbhbK/21DEUqbBiHHFb3xCJStTwsDgO0NEUiu3fWijNwNOIzr3rQYVOgky9Q9s/Le
	7dO6WrbTclxTxitiNhyfnXEJOURQJXkdWKicwGxfHPMxqytizdyEyu7vODxGacvjQYvgMZmwp14
	RkN3eEBYoGWIP6q+sTijEHPdqGOJEXHWSi+wQI5AsN7gCFNA6Sy9N/JfdVakEW2
X-Google-Smtp-Source: AGHT+IEsh0YfLrQ6Befz1e+5Z8Ke8inELoHU9k4IjVehY2VMbpWVDfJ96d2X4MolrEK4yj2WsuO8tzP4B9EUAmcajOk=
X-Received: by 2002:a17:906:f59b:b0:b40:664c:3317 with SMTP id
 a640c23a62f3a-b726555b4e3mr588270866b.43.1762408718932; Wed, 05 Nov 2025
 21:58:38 -0800 (PST)
MIME-Version: 1.0
References: <690b99ab.050a0220.baf87.0057.GAE@google.com> <fcikaqlrbqzc6utdbd3utgkkw52474l2hom5lzpbmh6wsvbb3n@tpex3btkz34q>
In-Reply-To: <fcikaqlrbqzc6utdbd3utgkkw52474l2hom5lzpbmh6wsvbb3n@tpex3btkz34q>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 6 Nov 2025 13:58:02 +0800
X-Gm-Features: AWmQ_bmVYfN0T17nYGfIatRf7DhVL4mqCPN_Mdqublj-P_yXRMvrkecHbryO4K0
Message-ID: <CAMgjq7Du2iVn65UOCWZvXKw0XkB6JRsVv6bHJyg72bGeafAD3A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in lock_list_lru_of_memcg (2)
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: syzbot <syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, david@fromorbit.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B543E8000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 7hu49uhtg1t5wo3dq3t1s5chh3omh7eb
X-Rspam-User: 
X-HE-Tag: 1762408720-848171
X-HE-Meta: U2FsdGVkX1/pHtcaFMPHcuQhqCy+MaN0nY16xZ831h5/WSc0uzRxMeCs+B/CJMD9VvLwSG6SbxUkKFKsWuqwnG+CjBUBwtO57SIyRT0px6jxyagw1S9zw7wSy7mA6OuD991EGpsmcnV7qk+xPsTelz0s5EeZPc3zGFB5cBGeBj6snF2yD9ak9TLPfHk+wMpbO0kbWwGkOX0jNe0DVU5eZ/lKJDzLCs9BxR9iDDMErOpRKp7Dbrsp7FAtgVyMtweciNaBPvdG2r4m0m/t0/cmwy0MQ02vHEFULgtMl7Nv+lZo1vbygBhOZW9Yt3E3tae8jXOFvliCSkgAGyo7oDgPaIrcxFgzrikvd7zNZs7k7tFYMLtSz/pdWv+rsnw3e6pnw0PaXTfXbZ8Daq3oEDJFKHYIIWY40TdeEz6VvohdioxbkBxBJ6rqlduRLIDAHzVntsOAlvi9ssE0QVREMiMLtJT4Irfq8p+8DmjHmly3XBSBvh/oIEpE2Z1YiPTnqE3h3ejlCPbe1Uu6yA4dRTDVMDn1x7XaXz/QiQpIvd8gPhC5QnE/MDgVRZvLQ7CCW1H7rylflA9rz+h8oFWFSUf2M0vAJsExSi84N+ur//gxIbtis6ou4Wdx7J9o6vSbfhuOFoYXOkD0ekENQHfP6r5iWVIwCEQH7cG9MrC8nClzc5n1vExYdnxqmy+mPcgAMb7OMbLdOV9vq2zoDv9X8QuAcxZszgCp+HUapPsdYKBIS289yiVFqLAxCwoiPE44OsxBkUMwODo6ohdGJ2EgGlrClVvVfq3bAikFn59Q/hj0Oc+32Z2UkKrEp1UpYFRVNKJFZJQ3PzD9K4ttyZI0Z0PHLeAb3StKnuHIhhLZdU16HtIjutvSU0pkH9jh40q/WGaFADJSHNlGVDacg8/SxTvwmQ+JPwV8iAWsF9iNamz+vonbu7llQP00ORdu7Oqh16zuAiB1FMedn2dXy1O1k01
 90akQD/3
 eSuDuBUnsds+oVmJuFqhyOUc2VWzuIAc6sIzlQdwLzMS/1WZ2aJPHKHy/ZBs2NKJkp6fhZnv7mE1pZ7GpPME/YzLOPnr4H+vgrKPTNKpDf9gQjhG2sta4dbxWiPPkcnIraqgdR95PSeujMUmL/vp3PWVKOL1vQuQoQzdFVysukkNUFMOhOIn/i2oNx/O0EXlTVFei3/M82Xm7PVO2MFzEHCatCtE1VQJ4DbTSb+AAIdl8naK6FZXKU4I/VcAv8jZYLf0C2+JvSk5+q+HOBP8StWjsyJbqHLDls0aLyRwMMqaaMOPMINdrPuBngRJWS7BK8wnm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 10:58=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> +Kairui

Thanks for the Cc.

>
> On Wed, Nov 05, 2025 at 10:38:35AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    ba36dd5ee6fd Merge tag 'bpf-fixes' of git://git.kernel.=
org..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16515704580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3De46b8a1c645=
465a9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc5b060ce82921=
a2fd500
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > userspace arch: i386
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/62471ef815ed/d=
isk-ba36dd5e.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/e7a72af6e621/vmli=
nux-ba36dd5e.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/352eec7dbce0=
/bzImage-ba36dd5e.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 13908 at mm/list_lru.c:100 lock_list_lru_of_memcg+=
0x30c/0x4c0 mm/list_lru.c:100
>
> This is VM_WARN_ON(!css_is_dying(&memcg->css)) in
> lock_list_lru_of_memcg(). It is unexpected as it can only happen if
> (1) list_lru_from_memcg_idx() returns NULL or (2) lock_list_lru()
> find l->nr_items is LONG_MIN which is set after CSS_DYING is set.
>
> I don't see how (2) can happen. For (1) to happen, somehow someone has
> deleted the given alive memcg's list_lru_memcg from shadow_nodes
> list_lru. Not sure how that can happen without some memory corruption or
> unsafe updates to shadow_nodes.

Last time I saw this was due to memory corruption from other components:
https://lore.kernel.org/linux-mm/CAMgjq7Dxv4JwebBtR18_9TpNX_7ej5HXEN1s1sitB=
+H+4rCE-Q@mail.gmail.com/

Another time was due to an allocation of shadow node missing mapping_set_up=
date:
https://lore.kernel.org/linux-mm/20241222122936.67501-1-ryncsn@gmail.com/

>
> I think we need to wait for syzbot to generate a reproducer to debug
> further.

Agree, this part has been very stable for a year, hard to tell if there is
any other allocation missing the xas_set_lru callback or something
else is wrong, worst thing could happen now is some minor memory
accounting leak.

I'll have a look from the code side when I have time.

