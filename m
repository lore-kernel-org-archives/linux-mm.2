Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1298CCA101F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9E88E000E; Fri,  5 Sep 2025 14:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FA28E0001; Fri,  5 Sep 2025 14:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458228E000E; Fri,  5 Sep 2025 14:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35D5D8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:02:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE17C13A8D4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:43 +0000 (UTC)
X-FDA: 83855967006.10.A2093DC
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CA1E140044
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:02:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jQT/L6Tb";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757095362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dx9xTgCy72/MrGwJEKodSiBTPmC6Mwn5gz5BEaZ5f3c=;
	b=7fvxNC3iuB1WOEec+cZ2W84mK7pQ/u5sHrImGfzU1HX5THIc93N7tgjyTuTHCeMZG8Wqv/
	eR8uOwTOgyVs5694HGI0PQxjErXlbwaS7YXIK7A/dKyVaGuTwhcoj8Hm/x2UxuQdHPKtIo
	xdAO7Zmn2/O0c4zMEmnAEfGEGc6cJOE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jQT/L6Tb";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757095362; a=rsa-sha256;
	cv=none;
	b=FdGCOZMv4LMYQRY32zmoPfoBg4/fBW22/Y4GOZVeC6MobQZXjL/jVqcV7hy7EVL3JBCGaA
	RolZU2mNsnRWepXv/4phgVDpa0fiDYlbYh3s+/nCivL/B1IL4YTQnwuK4WAPJ6sUp5LVRw
	sOr8xyjFVq88jF1abWLND/o5Y7PeJks=
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3f66ad3fcf4so19866045ab.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757095361; x=1757700161; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dx9xTgCy72/MrGwJEKodSiBTPmC6Mwn5gz5BEaZ5f3c=;
        b=jQT/L6TbG3UyPb91sXL54d/m4lmkhgfSJz/J8QAd5lyak+noouFncE83Nq5C4Ri8yE
         5WoGwdfsmdTvgtobN3eHGEHVMYYiQ29Gff4dHiLQNW9WzZ/1lfrwcSZ+gq0hyD6wFMVp
         3xyAaQjmvJDICXHbd9fzyNEyJ24iSC5VO4PBjCwrt4SnqltTiPn6Y6vcj9vda/ZM5AcQ
         CG2ksMNx4477Qw/McUQD/zEWfi1+gPn6aKvwhYVo6S2Gr4W1J2z9CcNXB9lpMYFTFcmV
         Wies3W7P3NAuZHPcUWROpMHilUtehwqXcwmGgGRBXo+C8TR5/J4wLAS/sbrsbaePVwS4
         7A7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757095361; x=1757700161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dx9xTgCy72/MrGwJEKodSiBTPmC6Mwn5gz5BEaZ5f3c=;
        b=k6aiZ2NzvtRYjFZLcC2UGgtom6PHvRdhQiYAQwgP3riMCn1yRClH+m0aAkhUBqrIo+
         bUd73uslGDwzpQvY6oRiYeU/emEdkuoeQTeeYQEc2HN7fIgE+36QUHJQ/YzHEF1hrczc
         1lhb7HaZucVBwsTVT2sPtfu6GJaCLJsYA+9hnW2bjJ6tbkVKcvyKdT7OtkgER8ImaJd6
         CVfewLfz0unTw0Z7cMlwDPDyzqcB41tE45axxTlgcJileDasCtRPIhFbN2MIrTxBiSy5
         Ti/Zfsn8B8qB4lMlWt7VVcVlQrPRaYjrmcjRS3bTGwMiBc0PLkT6KjhKBr+t7tUUG1bp
         evYA==
X-Forwarded-Encrypted: i=1; AJvYcCWgCNZGzcKpGPA3J340qoO+0E9pEy0O4mCxObCNzQsC0ElFDB2TaGHwdfZ5u1umG7tceY5qw019DA==@kvack.org
X-Gm-Message-State: AOJu0Yya1NCHcN2ETSe/2tTY+yrPeEG2Oq8ZXos0DQM+TXZ2XRMShtkh
	dr/6qvrCzd5jfI7gflCEWxbfhoX3Dm7TK6pE4dGNhbGVIsziyiYvr1gv1FzAkf0CESfvaHeyWsA
	ylbkdlGxA0orGeDSu29qIC7R0QYwOg6U=
X-Gm-Gg: ASbGnctba4CQltNKJolH9loiqhI+AYtjYZb6wKhU7m37odL4M2mSK3pjZp+n9NikeIw
	8Pbnuzvaun3ezlhHZxcEr7j5L0HLXeAjDanJx2BsRvcJTouHGYpw5iv5DNyNFjJVNIoGb5CHRNE
	b2o2QBgJTG/g89sdrCHwW7CqN7wWUGkKRcZs2vLEIge+KPLd+VwDASCAJMJNnZ0e5a1/dx9QGko
	O7o
X-Google-Smtp-Source: AGHT+IEUfIwkviQEN15ms4c5dONy5PWOugl2vpJmJN5pI2IRPqkTjy2HY+0hhAUB0Sd4G+eYatXIm8q1LTV9tZhQ+6o=
X-Received: by 2002:a05:6e02:1a41:b0:3fc:7359:a850 with SMTP id
 e9e14a558f8ab-3fc7359aa77mr9736775ab.16.1757095360837; Fri, 05 Sep 2025
 11:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250829162212.208258-1-hannes@cmpxchg.org> <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz> <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
In-Reply-To: <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 11:02:29 -0700
X-Gm-Features: Ac12FXyset2Epjt40edRs0yWUbEmmO231z0PSN40ziEioBbvE56l5ZG-g-ZhWSI
Message-ID: <CAKEwX=MMNSg-QdA2XdBpzhi_d-o9Pv4OOPR5nqrvUVWRdnnpLA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CA1E140044
X-Stat-Signature: rd4jy93m1bmdnx9nr8proazfgrg38bt5
X-Rspam-User: 
X-HE-Tag: 1757095361-485813
X-HE-Meta: U2FsdGVkX19IHPfJb9k8kJpGQCaoNqswzov2n4Z8a2MEfaIljJmJcrp8zaL0ASyyPfygmgid+mc43rnaOycDc3uG57AceTuQnx7Fn/6weRhiGS1zT8GdkFmZEiPz0FFUYRM/NKJPj/hQZtCIcAPz5JBGtiznxgxcHOb1ST+wP87GTnSoeTEHOwU57cLA0wfGEaVQC3iVuk+gn5aQybRrPfIPl/rZFbyQBoTKnIWgHHAezUq87w++44TBYGgoc0z8rhr1dVd5BYS69rAQPWO5vRuj0H65/cKMoJPwEepLL/csm8NzRa+llsr6VV8+MJ1E9v6RqktCR+MagiJUl7JHT4vsGfnIQHuLKqWChixL26Plhwp/7bZWq0LbX0jMe7TfKAAr8va/NIErpwKobR5tNt1wmssF9STNKt2QRmLQf3ca/IbkOf6SQjw+SdV7eAu/x3n/kGqrXEZdRPm6X1JBoDosdGhg7VQT4edZ430rW1kyZY/ZlwpNbyvOYDUFjh/eVnh1zUf8YJQA62jrASBHSnvc2yuGQq3oPHwFBM+W8qLk8n0TzioNxmpY/7I1EaLOewoK4AdZRYwQolGyU+8iZIf+DUndBkxhcMGij7o4beemMtmJqJKrq7yPm930ctjTIKmj5ERDUk+kJWHOCLpsrO2jy7mZQEYYv3rZT0aQEirRkIen983HkqmMRPvF384fY9FjKLSvSeFfh8/hueFDPSmwqROZTSRfZkriHRPSPSxCBBcaZ4bZ1VCsSc5F0ZGfxRUErRTlZVBEIW5XbnnpOCXFGaI1xVKPZ6mOcWesVdijAg/6aaT/iqpD6vZKPgoC4jJ97wism0MGebvbtPhhOSy7ghgI0wXAbFlT60dy72z8fDHZAkhHSlE1smofzQaLEUH0KNfkI0xDb/Xr3McEPV0ma8FKFKmoyddGVSYfdbzOna3ETq/f0+qJo5KIhytafMiyPCueTiVrKubiffH
 jpdqOGJM
 hakAubCpGp3HSmubOwUPNZ3daNf3NnfKazbmtiB0Gm3uS6sOMyGFD938DsFV1u8+a0n92K1BXy+Z8UtcRtEwcZSzGT+aailQZgcPHfIeLmBsdiES0BfhrcPMohYgfeuSx9ifDzYoa+c21XsEbadtur221JjGwQgzrjLMb+Cqw3po+iPPdYCniFrQMEkkZ9psi9/qq2F2+eJ+EbMxOXD93D6dVQ7gWFGmRZ1k+lsaFtWIM1EOwRD6IzTA4L5V8mOClu1F94YmpuJm/RL7EbEo+wMOg/G9hVpXdfcNtH31WU6ErTyd5VfU+Lf24hCkM8wjpMqNrPYZ0NG8QJMrSacNSNXA1XTaiCizVLSd/zKziftW/YtGeExWJRQNpYaZUonBR93preITSAv91tHpYkFAEf9TKed3XXKJgGbn0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 4:49=E2=80=AFPM Vitaly Wool <vitaly.wool@konsulko.se=
> wrote:
>
>
>
> On 9/4/25 12:13, Vlastimil Babka wrote:
> > On 9/4/25 11:33, Vitaly Wool wrote:
> >>> With zswap using zsmalloc directly, there are no more in-tree users o=
f
> >>> this code. Remove it.
> >>>
> >>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >>
> >> Per the previous discussions, this gets a *NACK* from my side. There i=
s
> >> hardly anything _technical_ preventing new in-tree users of zpool API.
> >> zpool API is neutral and well-defined, I don=E2=80=99t see *any* good =
reason for
> >> it to be phased out.
> >
> > AFAIK it's a policy that unused code should be removed ASAP. And that's=
 the
> > case for zpool after Patch 1, no? It could be different if another user=
 was
> > about to be merged (to avoid unnecessary churn), but that doesn't seem =
the
> > case for zblock?
>
> For the C implementation of zblock, no. But there's another
> implementation which is in Rust and it's nearing the submission.
>
> > My concern would be if the removal breaks any existing installations re=
lying
> > on zswap. Presumably not as a make oldconfig will produce a config wher=
e
> > nothing important is missing, and existing boot options such as
> > "zswap.zpool=3D" or attempts to write to in the init scripts to
> > "/sys/module/zswap/parameters/zpool" will cause some errors/noise but n=
ot
> > prevent booting correctly?
>
> I don't expect heavy breakage but misconfigurations will definitely occur=
.
> > I mean if we were paranoid and anticipated somebody would break their
> > booting if writing to /sys/module/zswap/parameters/zpool failed, we cou=
ld
> > keep the file (for a while) and just produce a warning in dmesg that it=
's
> > deprecated and does nothing?
> >
> >  From Patch 1:
> >
> >> Note that this does not preclude future improvements and experiments
> >> with different allocation strategies. Should it become necessary, it's
> >> possible to provide an alternate implementation for the zsmalloc API,
> >> selectable at compile time. However, zsmalloc is also rather mature
> >> and feature rich, with years of widespread production exposure; it's
> >> encouraged to make incremental improvements rather than fork it.
> >
> > With my history of maintaining the slab allocators I can only support t=
his
> > approach.
>
> There was the time when slab was the best option and it was more mature
> than slub, which is now the best and only option. Thus, the "maturity"
> point is indeed valid but not being backed by anything else it doesn't
> weigh too much. Besides, zsmalloc's production exposure from all I know
> is limited to the 4K page case, and zsmalloc is truly struggling when
> the system is configured for 16K pages.

That doesn't sound unfixable, if I recall our conversation correctly.
Perhaps all of this effort is better off being spent fixing zsmalloc's
inefficiencies :)

>
> Things keep changing, and some of the proven solutions may not be a good
> fit moving forward. While not suggesting that we should have a handful
> of zpool backends just for the sake of variety, I'd like to emphasize
> that there are good reasons to have zblock (especially the Rust one),
> and there are good reasons to keep zsmalloc. That leads to the
> conclusion that zpool should stay.

IMHO, the needs for multiple allocators do not necessitate the zpool API.

The zpool API is only needed if you want to switch the allocators
arbitrarily at runtime. This one is a much harder sell.

We can always add zblock, and select the backend via build options.
Overtime, as zsmalloc improves to acquire zblock's advances, or zblock
implements the missing features (migratability, compaction, etc.), we
can unify/remove one of them.

