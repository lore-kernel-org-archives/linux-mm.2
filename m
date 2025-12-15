Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72EAD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 08:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD306B0006; Mon, 15 Dec 2025 03:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E306B0007; Mon, 15 Dec 2025 03:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CB76B0008; Mon, 15 Dec 2025 03:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12AC26B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 03:34:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A054F13C49B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:34:57 +0000 (UTC)
X-FDA: 84221045034.16.423BCF3
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id B41CDC0002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 08:34:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MjVGxWEO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765787695; a=rsa-sha256;
	cv=none;
	b=iREV6LDfO3JKIabtEflAnaFTxAx5O0z28XzGR82NxKWTsOhqhe8t+vWt5s3jaQoO2DyTEq
	fRtwihokwvwEh1A/yMuB6DK2OOoUyI6RkCfyeaqJAzui3T5pXKIp+P8krTIKItaYvRG3by
	8bLWgnGQwgP7XvUtLKNmexvC0zjabw0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MjVGxWEO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765787695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBgyeGbHN2SodTK0wWtpIL1GUBJVvlQwCc+Aeou2HCw=;
	b=jJpJZE62WTSjsn5Stu98FxHRY3EC/JfbohuQECOB0X1vcdO/Rre+kDaU6uPG2zHIRj8nbB
	ZLtuxgsVWuT6Ck1oVtlLmCXn4/XXNQ+N9tfyp8/Z2PB7FesgwgLAu4ecD33A4TBgY8PgAG
	HrGSnGTG0TlisaeBAOxOSq32HY4w/Xc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b735e278fa1so604631966b.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765787694; x=1766392494; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zBgyeGbHN2SodTK0wWtpIL1GUBJVvlQwCc+Aeou2HCw=;
        b=MjVGxWEO6eoq8QgeSVnxeL93i19BqWJMZs5dC8rQb0lB4Vf2KNXGO1zLe4M5tvHwFs
         1zKxL8Th7b1i75jceCWtseHh+xRK0wlfnxpTAaFLd2/0L2g/PLVyfMN4QdI6dS5QQoHp
         bA+8ZJZXZm5r6E/GRWk/c0H2XCL7gsB6gBW7NBCE0XQDA5L9ZeAJhDjw329kE+Gx2Kv1
         5HwvTr1Mo+g88uOTYMgg/HqSQm3NUqzDTd9kBXNgXoyS4u2W/k8Gom9HulhEjLylu26y
         C/UMXKBfwCOPLRhb/qOMEumoW968mdq50+mm8MuX0b7WDyVH6D3oug2pZ7STh5uFF+D+
         FzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765787694; x=1766392494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zBgyeGbHN2SodTK0wWtpIL1GUBJVvlQwCc+Aeou2HCw=;
        b=r1lzw8L2exed6IgqFD0q8ZVMeVefhPjvmPTuTHQH/DQai57nOPSyeuFalPtED7B3VH
         igC/DXaNPskR13IbhPCUA8FyEhkFOGsXZ5OOGO2WFRTzrfJdxRUtOvLG6jI41yXihrdf
         Mf8ZVi2ZxJ1Q1juBMMiiQ6CXefA2JzzbDcYdSR/im/3PPIBVtpa298v5taKD4+739GnC
         6wh8oVPjP2Y+h8kwwUkT0b4ZUYP8H96jIBtx1pmInx45Wr27o/W3ZLOdfEYL/BRi842L
         kqaFh4HaKysREcZxBRwXELE5gG9m0w8ibj2y3FTwwYWMBzDxNAS1wyzMUTo1U+WBs8W0
         iypw==
X-Gm-Message-State: AOJu0Yz2CZF5crS7RWgcFRyQFK8Lv88fbni8D5Kh5IftOR/0CwXeKVnQ
	KhSDuBalef29YaOZdmZy0zk/bCC1qeo0BrhMbx9vgxsMUSHwAilBQKUkjRKNaxWsndKQ9t9Xyt+
	GcUDVAfW7R9iUY+6UEQY+rjYDolma888=
X-Gm-Gg: AY/fxX6hFzml4M7tgjtzQF3eSNAo59t7+o4JAqega/pqLwA7eiBCZUD/+wsT12Y2N1z
	1oa19YpNHRiwspkWxB3NWCOcToe0D2axKFSCo7Q2ZT76nRqOm4yZRZWV4pLjqXLRLbaXs3UlMpo
	MCdfJM5XtAUWEX12n2bxw/E48cvc9kNqSdlA6RTHSMUO4uEaPDSSAKJIZQGTg/j6jwr336iTMZ6
	BFPaFS1AimX806nbwLKc59p48ahwerFmYqvx4yCcsXt06z5HwzFZPdFXNJSYIMYF1Jaxh9vFp1C
	546DYZPCny29IG214DSz78qNHgk=
X-Google-Smtp-Source: AGHT+IEdPsw6LWLnZVtbzbSshokghbt3uunpoIWpZ93Gd6GvGnig9P1J7Eq6pzuEQ16kDkQJ8DmhLycdKIVNGPz3TCY=
X-Received: by 2002:a17:907:9618:b0:b71:ea7c:e4ff with SMTP id
 a640c23a62f3a-b7d235c7ea3mr895067366b.6.1765787693758; Mon, 15 Dec 2025
 00:34:53 -0800 (PST)
MIME-Version: 1.0
References: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com>
 <3edf7d6a-5e32-45f1-a6fc-ca5ca786551b@huaweicloud.com> <CAMgjq7DVcpdBskYTRMz1U_k9qt4b0Vgrz3Qt5V7kzdj=GJ7CQg@mail.gmail.com>
In-Reply-To: <CAMgjq7DVcpdBskYTRMz1U_k9qt4b0Vgrz3Qt5V7kzdj=GJ7CQg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Dec 2025 16:34:16 +0800
X-Gm-Features: AQt7F2r4063AFjyBxwSsydfHRTXqRFdqQ-4Mr0P5UbG-7JLS5WKSYc4t3qrG5Lw
Message-ID: <CAMgjq7CLw3Sq780qDo_ANtNxNC9EgB+5bKbAAQD5YLDPMcSZMQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B41CDC0002
X-Stat-Signature: qb945aj4t3etmjq9713wfe3q6su6wccs
X-Rspam-User: 
X-HE-Tag: 1765787695-261376
X-HE-Meta: U2FsdGVkX193L5gyJg/rUjo3SKWR7ES51Je4ZWDUdYCevin/Pmw5kx+f9tHlmh/vi3tZhDUudT3MkncpRd0qZp6lZBWggphyzwPPImBhldLt4yZdkEO5dD/ydvHb6E3vzoglztFKao25rNZtIB+U3Ew3IX+qR7Blvnx3T6yMfCW46PavqKLWDHo4j/sZJjW/VI6kCv15/vrXvf+FG1tFm+m4nGN5I0eA0p8sGwtLLxvk2r2a8/tbStcCHPxfzbHPJg2VFWNp32v3/pSii5BLM9lljhOuOCrhDXkYOHHUtBNm0v7oYf5J+3/4L8C2p2CaHa6maGJirBKgkB0j+0pZzguVm2c00q+U2mUTxwo8Squ5NA3hED0+3Hrdjmi8Dj+AM01mPJ+LJJmkHb05q/0+QDc/7kPHOGZs+akltLATZLU3IV8Ff66ioTfCMBndEJ8BMS5QHJQu7U/mrhN6KcX5C6qw/X/RH+YrewyatDJSE3BXTOcgk5IY2rhWPv0iO9DlxLpYW8a3GrnvQRqzNoQzbzX9uYW9jzrkkfTYqzwxtKAkgT4ca9of4dYT5S32ectNzFWbWiZL2V3oZUbA6Y4+LfsxumH9UWRAhbDmm7ktKwJed7nYIT90kdzQyU7JtjZEQMlWKH/nAxF36C3vVwnTYZeeg6mFAStfVyWfHNCkIBIiVLumAmMu6c10cYZAxtQbfRqeDz/njXHNmLO4Cebgy6gz2FjaK/p5PCSVOow+ZWdfBLadOp3f++GdqxvMzd/sFuRjoQPJkfOlIqlmp4DSk3gQ/O2YsibKUySIi4sYufjQv62LM5Ij4/1V1Jhcsg5+X1atSSpVVgKy56ksugK/fFqJobZZCJRbr+VInivn7TJSEe59y98EsukvhVXFmC3ABwgu8ZbvWdVs7XSUYz0q8rR1hNEvTkYgewga7eTs6r6FwQc/xp76cWBZPZjE5jT8K436d6+64QOpU+W0yeg
 TERsoyoO
 yzxaFhQjIrEZkgqKzErm/Fv3Cd4VarC5zTslim9Zn1prqA80ugqrI7yT8W0Q26kodxisTKelLd6JzecEAgZu0MH00e4yCd0EUhwseINbR1MEvETPLH2kG9HG6MWFD5RuIUupO/GMNf4P8MbVqLcpcr9PMQPY4gJ/wh0PdMI1baIlBKmCQW0gNdPtgKdN9v0/fqhJWEqmHlEvod1OcHHYEljT39gLuN6ankH6pxeP4e4+/6uhF5gqvSMyJOzIaCxok0B8JM8j/YmjLx9uF9XFNq4JYCCmGioBhXZfffbnot85wg5c09hNQ4ZavqnJrBm1yLXRCedNVE6v8bmWgn5sh78pmrThVnOD6m4FmLiZfWkl9pYa9i/r7AuyyFDRT2t9deGlxGGLBnNBZXOuRd6OjiwVTv1INjcpLe7aKLvi/WxBBNC4ycxWiuFEOjWYXBC+r7NkaObuopDW8qsSYJoYzkqYkpXW3G7FteTDU1hlStKQfIFKYVNsdFO0y9amL5ar5tiaZ+PT2TbQjyw2vwMHLcnSQHpNYTUZ034Gi4gEW9OXr9/1i10wuvjkgYvW/2qk3eZdH+XEY0RluzR0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 4:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Dec 15, 2025 at 3:38=E2=80=AFPM Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> >
> > On 2025/12/15 14:45, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size=
")
> > > introduced a sanity check to catch memcg counter underflow, which is
> > > more like a workaround for another bug: lru_zone_size is unsigned, so
> > > underflow will wrap it around and return an enormously large number,
> > > then the memcg shrinker will loop almost forever as the calculated
> > > number of folios to shrink is huge. That commit also checks if a zero
> > > value matches the empty LRU list, so we have to hold the LRU lock, an=
d
> > > do the counter adding differently depending on whether the nr_pages i=
s
> > > negative.
> > >
> > > But later commit b4536f0c829c ("mm, memcg: fix the active list aging =
for
> > > lowmem requests when memcg is enabled") already removed the LRU
> > > emptiness check, doing the adding differently is meaningless now. And=
 if
> >
> > Agree.
> >
> > I did submit a patch to address that, but it was not accepted.
> >
> > For reference, here is the link to the discussion:
> > https://lore.kernel.org/lkml/CAOUHufbCCkOBGcSPZqNY+FXcrH8+U7_nRvftzOzKU=
BS4hn+kuQ@mail.gmail.com/
> >
>
> Thanks for letting me know, I wasn't aware that you noticed this too.
>
> From my side I'm noticing that, lru_zone_size has only one reader:
> shrink_lruvec -> get_scan_count -> lruvec_lru_size, while the updater
> is every folio on LRU.
>
> The oldest commit introduced this was trying to catch an underflow,
> with extra sanity check to catch LRU emptiness mis-match. A later
> commit removed the LRU emptiness mis-match, and the only thing left
> here is the underflow check.
>
> LRU counter leak (if there are) may happen anytime due to different
> reasons, and I think the time an updater sees an underflowed value is
> not unlikely to be the time the actual leak happens. (e.g. A folio was
> removed without updating the counter minutes ago while there are other
> folios still on the LRU, then an updater will trigger the WARN much
> later). So the major issue here is the underflow mitigation.
>
> Turning it into an atomic long should help mitigate both underflow,
> and race (e.g. forgot to put the counter update inside LRU lock).
> Overflow is really unlikely to happen IMO, and if that's corruption,
> corruption could happen anywhere.

BTW, I think maybe we can add a few more WARN_ON at LRU destruction time?

