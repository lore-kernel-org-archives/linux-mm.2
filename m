Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AB0C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 05:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99CD6B0088; Mon, 28 Jul 2025 01:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71A76B0089; Mon, 28 Jul 2025 01:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE8E6B008A; Mon, 28 Jul 2025 01:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA9E6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:35:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E14C80141
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:35:51 +0000 (UTC)
X-FDA: 83712561702.10.AA2A73E
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id C84BB180003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:35:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OPMHZSba;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753680949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8i5NnplGFIPS17ImJAs58zJ/RPpA9q/iksJNZ0TpQgA=;
	b=1CaZYzhKQ2pwZ4MSHy6zebEkqnYTF630HYLWwZXeB4uButdUAzKPvR4ub/gNXrqLqNV4DP
	nx6E1ho0GfTDMrJ7OvfrRol2CQPBGlw4yRAAzjIbE/JQPOi/WQpghBXffwKcbL0zQRPoG2
	emCRy5jtxsDlSxkxTF5bj5FdtquySAA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OPMHZSba;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753680949; a=rsa-sha256;
	cv=none;
	b=LPGpMDdbyZEZmdtI0cK/LSplKMBkvmvcaMvWS5Qb4UfThBsRRYMiLf3SN2SASQVLXjqB5k
	Y2RuhpM53WI7KinH0SAd0XqT35/1wW9NyXftuB+nKOGOe5w8SwUfeIfSk/dqG5oRNUxox4
	wtcgPt1TuNLszx5RCZcwAPx/KIimdkU=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-718389fb988so35227737b3.1
        for <linux-mm@kvack.org>; Sun, 27 Jul 2025 22:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753680949; x=1754285749; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8i5NnplGFIPS17ImJAs58zJ/RPpA9q/iksJNZ0TpQgA=;
        b=OPMHZSbaVBJHEKz3zeHjAGhsXp7QUMRACucY0B8VRzXfR46ARIbcM/WiDjp7LYWZ5J
         Pegqtip0mKBUOs2XMv67PGey8eg9ic5w9qQUBaDITgcXwZfnxmPRyYYfRicP3gjo3Yd0
         KmL3OlbkHpyYFNa03WGw61ocItzLnTRkPGJ9D5pfJ0IIIs6Gv6YsDj1AJVo7LObhL4TU
         3tjEwl3uOPnW1Q9WjCux/lRVijurHiLWfAIHhFguUV5oEqQXfB98mq1f6VBjoBilLvIW
         oau/yHSqV/bDf5X4eupgs4rg+J0H+eo/5SeNODU9kMEseJNffiz0fdTu4QJeItpjHB0X
         LByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753680949; x=1754285749;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8i5NnplGFIPS17ImJAs58zJ/RPpA9q/iksJNZ0TpQgA=;
        b=l+4eGuh6CV/fAHB1Q5gqoObaUthkCU/pSv3MlaJgINT/9Hrt4RM4Ar1AZ2vB+FZrV9
         npe5awqQ5eVLmTUpyExtizzJkuXYIs+7qFDWF5KtzQmF6ioQzcam5TMMXGKW1zrcYZoj
         7RhpaZwNT9WaPIO46RafQFfUkYju93hQnIH41nOjGOXq3FgziKT08WYf/ev8H/SrOtOi
         4iP2oUJZBZL9VeGGcGkWdArOIqicxppSV3ziWdyO1/6lLL2JdXHE4bxJmpjYjeQtg61N
         Ltjh4vAYteI95olDIXBsK2asuaGfkjePFtO7Ie0STIfPoXYkjkzEed32FqJuINyW/9rq
         bIaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpO1Lu2Bqjs1jL0mHv41nG2bOjiQsxdh/XprHKzPctPhwBhrPdn33cilBZCS0jo44iAiiqKwOw3A==@kvack.org
X-Gm-Message-State: AOJu0YwEelx+JgQoBqVE/vsweKUb630zToSXUveN5Hu51EyFqvqRG7HI
	eauc1x8pqfE9Tbpl+APXjmDrMrMmoZMqPiBYa4aIExSye1sjHvtaMsKxmifygP5kMA==
X-Gm-Gg: ASbGnctm5CMsoSp4jJ4uBFOYOL7276i5GSZssNHOXNKE6qk6ufhORIuBDgmjEaHZkh4
	6973NrjYOU0BI3g2CYIY+gB9exZB3CyWV8hMoVQGAbI1A9f54V+SVDH+VHeC/ImhbnWZ2EbiBG1
	WFH4RssQcEkyj9OuLSqKMQ4jz9ln6zx3Y4900tObWamY6ZCSDtf562Fb+rHQOjqyy/zsNy+hdVj
	NW7mPjcyaO6JQUR8aub/oJsxZw7W/s19G9IfHs/CQ0rulRZPI8moyfS9xGCAELTxPb9z9FPgx9r
	+GGKmvad4r77wLdQgxPTmH5IJnewBoEiaQPVqodC+VFE8B7fVXfD+SZi+soGWdlypuzR99j6MJA
	lT5PRJjodEntsN6hg/BuMaTlOoUGAQSffk03wt8NLdaQXduz7CRtrm48dXm2GLkt4XAsdyJTvq3
	AB/QXwH5M=
X-Google-Smtp-Source: AGHT+IFjJE9dD2Hm3OqFJBk9mtcpa1HWvzqDqvmdzoGTScjibYBqO5oQoMtL3WLJhdLzPEMm5No04w==
X-Received: by 2002:a05:690c:ed4:b0:71a:f22:28fa with SMTP id 00721157ae682-71a0f225ce4mr54608607b3.39.1753680948282;
        Sun, 27 Jul 2025 22:35:48 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f23b135csm11508557b3.64.2025.07.27.22.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 22:35:47 -0700 (PDT)
Date: Sun, 27 Jul 2025 22:35:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    Patryk Kowalczyk <patryk@kowalczyk.ws>, da.gomez@samsung.com, 
    baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com, 
    willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org, 
    eero.t.tamminen@intel.com, 
    =?UTF-8?Q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>, 
    "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
In-Reply-To: <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
Message-ID: <df580afe-f7c2-c5eb-b575-373908e0f6a1@google.com>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com> <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com> <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com> <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com> <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com> <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com> <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-729545462-1753680947=:2934"
X-Stat-Signature: zdrhc7r5y3kwmxfqdbyxn6dzkx6mwiqe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C84BB180003
X-Rspam-User: 
X-HE-Tag: 1753680949-331095
X-HE-Meta: U2FsdGVkX1/yzFoFsp0t6igLBaFH8k/bmCKssnDfK9xYwcpXuJH3SG61Wtpcb7fC6oAgtoXYnTaOhBxwiPOk2sSkZf9HQhbe/25rHEzCQmZRPtCm6xl9Xm1heZIIrZ8m5HpCAHnpWGXVqLiTdkvYSVTSutfLWk9EjUpHgg3mC1zQ56DPT2Xr2Yc4OuD04w4Ye4pA1sfeToETcGfrqrV5lK6kRoF1dVPy0uA1Sxs8YTwAT3AEKxayLyFO+zPL8AQb+3xQec7vIoTK6iAiPKwMWkoKrWV/jyYV81XKz8LtAEo0BDYzEWeiA4kAZGyEjBghASbM4fjeO52Jrz2XNOroiInP2WnS0jRU/iGBmW87/fVbBwnb0b21CVgcJsuFOqZ1EvBrEQABcbvDqLGIALgeWFNq030ETMwtufPGFufrb8dsov69/zKxZdpGg8pPRf9oz22QPWx1plHzrV1Ao0Dbmzf2Gy14ZClAJzz0SiSVlAm6DyOUh6I+2un45liOFO/kO19s3qvWu4h/61Itn9ia/uvhbthtOI4ZkHdl+SS2qdA2M+U5GXIVhZVEqS9+lr6skPnjtzcrf3+OmCMdDTMRWkB9twbzOrAl88qo5WA7jTSsYss73A26jrOc3A2nmL7corSxdKpwiqnAdh3nmcB+Vx3KRD44IRBO6q28QYrQzF0vA8xfhav5ylueUzUFp3nV4T2hH6DVXuYifMNQi7yUxyRzIADqiUFKtatVM8KM8eTlYqYrmgKs4qtPjp1ahCmLA2v2JYCUqm7pBSNE+nAyRkBd7lzD3qa2Yp5r2EVQvBwNAquvOG4nrILiFSM9HsSOA60kdWPoc846g8SnOwHUsM2WflNBdnhM0ynRZoJHXHI/uDIzI3W25q3rd5r6uZyegrB6BlBRAJ5j2ursRNkkgylyqRzE6T4RmPGj7+5nqepAGmnYmUNIIwXNv8wZDxJQ05K+F2I+tXzHoeSAvB8
 Wsu861SH
 9a1nQEV9ad5uuw13kMRhCAVOLiDPEJTgNocQ447iewzSJW2SHO6GyXb8sG8O2gUOaNzUGtd2g+m5P4o5j1TCdnNrjtLS/HmFc1RLFxwn2gPK2fiAqNiPabB24aO9adHDBly/jZZbvEqc2NfA4PzPHUHvWuUlKlE78zAZwm7Msk/aS/naAiXWS6i5p13TlH9wioK/nYyquahyiXCWjGLF5DbzxxNKzaYizwH5kRmcsVUZsLPQOwfIjOEcvrglTr9y+e8ts5CaBeNCCrIiABp8WVMaa4MnGxLnPpsSoO/bTNMqkGVlzbyZ+aFqkPvEFoEQ7AsftZvFZrXYgyXzlRS6HuHMBeZHcqPxwn0sUuZdpSIHGrxs8S70B8r10mqIaHET5iiA1Hp9DSYE13fQU2ihwi2ZYRWSb5eahHwPaqqtYhGA8LLitTqPuqiO+B8SWuOMms6tR80ZlNBn04XYccxRdb+CKdZZ8QX8gD3jFrM4/2+Wz5n/DYsPguAVLuuTIWFQ+OzqixMIM5/wikdZM2PQ/Phkvojhxmbual6mlHzrXp7lvqEHKy+mawXNN9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-729545462-1753680947=:2934
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 25 Jul 2025, Baolin Wang wrote:
> On 2025/7/25 12:47, Hugh Dickins wrote:
> > On Fri, 25 Jul 2025, Baolin Wang wrote:
> >>>
> >>> I hope to correct the logic of i915 driver's shmem allocation, by
> >>> extending
> >>> the shmem write length in the i915 driver to allocate PMD- sized THPs=
=2E
> >>> IIUC,
> >>> some sample fix code is as follows (untested). Patryk, could you help=
 test
> >>> it to see if this resolves your issue? Thanks.
> >=20
> > This patch cannot be the right fix.  It may be a very sensible workarou=
nd
> > for some in-kernel drivers (I've not looked or tried); but unless I
> > misunderstand, it does nothing to restore userspace behaviour on a
> > huge=3Dalways tmpfs.
>=20
> Yes. Initially, we wanted to maintain compatibility with the 'huge=3D' op=
tion,
> meaning that 'huge=3Dalways' tmpfs mount would still allocate PMD-sized T=
HPs.
> However, the current implementation is the consensus we reached after muc=
h
> debate:
>=20
> 1. =E2=80=9CWhen using tmpfs as a filesystem, it should behave like other=
 filesystems.
> No more special mount options.=E2=80=9D Per Matthew.

That's okay, I've not proposed a new mount option at all (though that is
rather how "never" came to end up meaning "not usually": our shared dislike
for adding yet more options).  I'm proposing (shock horror) respecting the
long-standing meaning of "huge=3Dalways".

> 2. =E2=80=9CDo not let the 'huge=3D' mount option mean 'PMD-sized' when o=
ther sizes
> exist.=E2=80=9D Per David.

That's less obvious.  The collision in tmpfs between anon mTHP, file large
folio, and huge mount option (where shmem_enabled in sysfs provides that
mount option for the internal mounts) is certainly difficult to resolve
in any way pleasing to all (or any) of us.

But what remains clear is that we should not degrade the behaviour of
"huge=3Dalways" for existing users: they were given PMD-sized when possible
before, and they should be given PMD-sized when possible now (not suited
to all usages, when "huge=3Dwithin_size" may be more suitable).

>=20
> At the time, we should have sought your advice, but we failed. The long
> historical discussion is in this thread[1]. So now the strategy for tmpfs
> supporting large folios is:

Yes, it's a pity how limited and unresponsive I am, then and now and foreve=
r;
but the principle of not regressing userspace is not a topic on which my
special input should be needed.

>=20
> "
> Considering that tmpfs already has the 'huge=3D' option to control the PM=
D-sized
> large folios allocation, we can extend the 'huge=3D' option to allow any =
sized
> large folios. The semantics of the 'huge=3D' mount option are:
> huge=3Dnever: no any sized large folios
> huge=3Dalways: any sized large folios
> huge=3Dwithin_size: like 'always' but respect i_size
> huge=3Dadvise: like 'always' if requested with madvise()
>=20
> Note: For tmpfs mmap() faults, due to the lack of a write size hint, stil=
l
> allocate the PMD-sized large folios if huge=3Dalways/within_size/advise i=
s set.
>=20
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled' still retain the same
> semantics. The 'deny' can disable any sized large folios for tmpfs, while=
 the
> 'force' can enable PMD sized large folios for tmpfs.
> "

Thanks for the summary, I'll have to come back to it another time: on
first reading, it is not incompatible with "huge=3Dalways" always trying
for PMD-sized, but falling back to smaller large folios when unsuccessful.

(I'll mention in passing that I find it strange the way shmem is getting
large folios of a selected subset of sizes from one direction, but large
folios of all possible sizes from another direction - often dependent
on whether i_nlink is 0 at the time, but maybe not.  My own preference,
so long as those tunings exist, is that shmem should always be restricted
to the selected subset of sizes; but I may well alienate everyone I've
not already annoyed with that opinion, and it's probably "not a hill I'm
prepared to die on", nor even directly relevant here - except that I'd
better mention that unhappiness while I'm in the area.)

>=20
> Currently, we have observed regression in the i915 driver but have not ye=
t
> seen userspace regression on a huge=3Dalways tmpfs.

I shall not object to a temporary workaround to suit the i915 driver; but
insist it not be taken as excuse not to fix the userspace regression later.

>=20
> If you have better suggestions, please feel free to point them out. Thank=
s.

Sounds like you're disinclined to fix it yourself, and I'll lose the
argument if it's not fixed during this cycle (since 6.17-next will become
6.18 LTS); so I'd better carve out the time to get into it in coming weeks.

Hugh

>=20
> [1] https://lore.kernel.org/lkml/Zw_IT136rxW_KuhU@casper.infradead.org/
>=20
> > Please reread my comment earlier in the thread, in particular,
> > Passing a new SIGBUS xfstest does not excuse a regression: strict PAGE_=
SIZE
> > SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,
> > but not for the long-established huge=3Dalways.
---1463770367-729545462-1753680947=:2934--

