Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E52C9EC8C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A3F6B0005; Tue, 13 Jan 2026 05:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8676B0089; Tue, 13 Jan 2026 05:11:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA0F6B008A; Tue, 13 Jan 2026 05:11:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADCC6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:11:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 328811AE6F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:11:09 +0000 (UTC)
X-FDA: 84326522658.07.2F44685
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 719C9140011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:11:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YlbUVuRT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768299067; a=rsa-sha256;
	cv=none;
	b=mJuZ0pST1SvR0Y6lfXBw0tgUGCXMXGwTNR5In9tpY9RbVBqJfkLpt7T/Ycxwmbyrg32SAQ
	Mt+h4WMSnkDQSDSC70ojx/eYSUIYkjCTLKujQU+TGxncDUyHhW1ES8HgGuAYgtujnN+XAh
	6c/skP/deY873TtxPHQfomn6v1+k1gs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YlbUVuRT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768299067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhwdsNSIXIbaUSh+z+YEwKaaf4OYjc6xkjJXOa/xwrc=;
	b=58bmUOHd67CgCiyML510tcPoTCZgURiWbDnheA7WCLuCudrKeOFbuSfKm+bAAAln/s8Z7k
	VBS6DaR1OdCirWycDYL81xJDDX6BGP2KAw6EoGaZ2pDibg5cplbZGNUjjyXlO18k2GLd8A
	nAuXsWjd1cqsit18U3ScanNLcnrEqnk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b87124c6295so309841966b.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768299066; x=1768903866; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhwdsNSIXIbaUSh+z+YEwKaaf4OYjc6xkjJXOa/xwrc=;
        b=YlbUVuRTpPIp6r9OMXRRvATqcE50wPb8Pxnma88WLDNyb/SBa8JkUWw3ntoVq2iQT4
         iffTmWsldnP9NJ/Ac6V8yDWg7j4otCiz1oXGHDW/payRRZCHlk29sTzjLphlPXC9INlV
         TiRcKJb01CB59hLwXfO5z1cyfzlKslbwYSthvTI+JWtGiGR1E4CLJoOyUjMuL2LQ6JoU
         ycqADKHQdCtX7u6+LhdaKGHnrDIZq3alTLVqsNX2vjcxSRgE2efYyVEvI92Ikyw/DXv0
         rr4bOSbCzCOe4lLgGOlsqhoHRW8lOFVAJ1UV38vIffAoHjs6GT3fJbDEeRUAaw/NWpKx
         pZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768299066; x=1768903866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhwdsNSIXIbaUSh+z+YEwKaaf4OYjc6xkjJXOa/xwrc=;
        b=S2dINfqQZ/VdtHWjbKrKILt3g54abMMyYr9chJL5VDKSeebPlfQoDnoMfH6mwuGlkE
         HF9Xg4aVxQCFgOuUXaWQrubZJmKYFVTXeO6JoPp5FCCvId+wCpyjj8FH7Po5axf88euQ
         HGx8NZL/mRH0zbsnPthjLWEiDDY2j4JKPaTNPgAA5NYOnmUTD/zPxflqr1AOFkEUcrIP
         zZ3FHbZKfzlmF1pIq29SAkowMAXkfoutPyoufkyQ3fg322YDdCEElVr0p2R/6fl7ezYK
         9Qon5fXLRLgaIhxVptfJDoCvml9/AwehR+GiYijAvmLu3hu63bY+hJT2Rbh9J/1U7AM/
         j00w==
X-Gm-Message-State: AOJu0YwOzk1xB/rmuYLUXiLl8uXGBRk3fKmdQF409ZwxJquluAugG9fR
	/SQ0ao/927IHbwp05RbdITOIolRO0ly9AEASoTloGKSbAdwMBxRL2NV4uPUNKvZaF1mxN5bovRs
	BsX/zsqPiMUDcRXo7p3oWN4asUCw9T9o=
X-Gm-Gg: AY/fxX4n20987G3UhXFdi5emB5ziWoqktTIyT/Sw7zfogAzGlw1VsXwpbiJ9x83sgvI
	FGiAvF8Pd7MOZCMf0IGyHGMaYtstpC8XrKGqYFLufv5UJWJvbhz2QTrec7NWJrQipeofsSKsByL
	sK4p6Rogm/1DkPFM4CM6J1rMTsf+a0KYWW1vzXWB3zZvV7SoSTvsrD6aHnDFBRzpwDUmCpTUuUf
	RXkvn0dv6HXTWpzdIvn3X0wub2B6bev0C9cbJvDE8Dn5H6uvjsOB9LWrGAV26Wqe2N/SaduGKVc
	gGREma9H1CI7ArCw7nm3fGjLZfmA
X-Google-Smtp-Source: AGHT+IG8nDMuMXGfVeKqpMCZnsQOH/yz01ostDNqxQirjqiwcV4e0MoqHe3mJyooKErDq5lHg+urzMnrBlkG6KaxQWA=
X-Received: by 2002:a17:907:cd07:b0:b87:24e1:1a4c with SMTP id
 a640c23a62f3a-b8724e126cemr380790366b.35.1768299065444; Tue, 13 Jan 2026
 02:11:05 -0800 (PST)
MIME-Version: 1.0
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
 <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com> <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
 <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com> <CAMgjq7Biq9nB_waZeWW+iJUa9Pj+paSSrke-tmnB=-3uY8k2VA@mail.gmail.com>
 <d95f9ea4-aa47-4d85-9b76-11afd0fb3ee7@linux.alibaba.com>
In-Reply-To: <d95f9ea4-aa47-4d85-9b76-11afd0fb3ee7@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 13 Jan 2026 18:10:28 +0800
X-Gm-Features: AZwV_QiLPLQrDBWAFzoULxVjWOBFLZ4KBEQ7aukTazW3S2GoIToz6cLvTx3o_yU
Message-ID: <CAMgjq7DrrCx78K3uccsfpGeQfC-_+LuONSefJ+Vd+aCjyncwKw@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xjzixeukxsw6fcx5o1hoaqas5zpw18br
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 719C9140011
X-HE-Tag: 1768299067-232311
X-HE-Meta: U2FsdGVkX1+c1tV1XraIXsrHpqbQRh6Kpl2eoLEhkkM5dWZaoF1uu3/R4l1ySuhRDr+JtwgosZSAGXwWz7KzBRTTHlAX5HPoBM+V5yrAhJB7jnWJEMlASL/3RWTTs8eGJVbVrxp62s7M/IRDBoQmT3C/EUJ+pwHm4Z4njitFt1Ap4/uM7KeBmA9yfaNyaGboacZ9ps9VuMfE4c4b4kBSxQNpnOaYdFkfurN1Y+aNzPgn3JdSG51HNVDamm0rmUb/21DgPzOj52l22cLgE1NIuycPnSTUKRoTB3qZLhIBHrG/gneve59sDf5hGqsQHoYvLW6c7slRehizxxIqFRj7liG3dJnx9VuLQf88sn9vAcd4198LKPViUiFi8CZXZgWLKySBJ3ayoOvUzn9z/FJm6iqs5MCcSCyy0tu55dG5l6tcX/SNjx9prTJyrxqJDPDLuTUpnexWn2eWC6YtHei+GB/1fZ0XHc0TaQVfse9BKEPepwLSELlAuzpc6RTLsVOKOygSrldpypo8XW0Dmygfg/QqdTgBuGTEQdcTjggYC6r2W2bu0UzJaTU1qOqr9oBxu9j72dsQIs2H70w1PsLCO7sI162oiWiVdTv46DjodDGwUx1tfsYRETF6idK82PXE1wrwLymNWLMjuSm+zHGukEflRbZZ08sqcDD7NwfJwNKMafwDMuwL4KlkpxXIwb8gCYPUA53M+2qUbt00FjcvVsTY6nUZDhNrjTOzkSuICsi7UNc4D+bk42RLpl1kkOw1WRe/A7bP+gQFn5Fq28OpkF7VwDL+cIwmO4h5tR/2+oslybrv691zvl93aBF8sZbJYl0Oo9AvmYl6KN0PJDVo1Sjx9YFJmvBemlkKK8hpYzQJjoD4Upg2iU4Mc5zdeO+yMRAnI7U6zRaOZr8cmyYJloTT9cXENd7BuzFtfaZpOBHjzjF6CPYzOGeU7cALzHX68l7EowbFSMyvqqx1n93
 zn7LhWoH
 YBrcLjgtaqlJidJo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 3:16=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Hi Kairui,
>
> Sorry for late reply.

No problem, I was also quite busy with other works :)

>
> Yes, so I just mentioned your swapoff case.
>
> >> Actually, the real question is how to handle the case where a large sw=
ap
> >> entry happens to cross the 'end' when calling shmem_truncate_range(). =
If
> >> the shmem mapping stores a folio, we would split that large folio by
> >> truncate_inode_partial_folio(). If the shmem mapping stores a large sw=
ap
> >> entry, then as you noted, the truncation range can indeed exceed the '=
end'.
> >>
> >> But with your change, that large swap entry would not be truncated, an=
d
> >> I=E2=80=99m not sure whether that might cause other issues. Perhaps th=
e best
> >> approach is to first split the large swap entry and only truncate the
> >> swap entries within the 'end' boundary like the
> >> truncate_inode_partial_folio() does.
> >
> > Right... I was thinking that the shmem_undo_range iterates the undo
> > range twice IIUC, in the second try it will retry if shmem_free_swap
> > returns 0:
> >
> > swaps_freed =3D shmem_free_swap(mapping, indices[i], end - indices[i], =
folio);
> > if (!swaps_freed) {
> >      /* Swap was replaced by page: retry */
> >      index =3D indices[i];
> >      break;
> > }
> >
> > So I thought shmem_free_swap returning 0 is good enough. Which is not,
> > it may cause the second loop to retry forever.
>
> After further investigation, I think your original fix seems to be the
> right direction, as the second loop=E2=80=99s find_lock_entries() will fi=
lter
> out large swap entries crossing the 'end' boundary. Sorry for noise.
>
> See the code in find_lock_entries() (Thanks to Hugh:))
>
>         } else {
>                 nr =3D 1 << xas_get_order(&xas);
>                 base =3D xas.xa_index & ~(nr - 1);
>                 /* Omit order>0 value which begins before the start */
>                 if (base < *start)
>                         continue;
>                 /* Omit order>0 value which extends beyond the end */
>                 if (base + nr - 1 > end)
>                         break;
>         }
>
> Then the shmem_get_partial_folio() will swap-in the large swap entry and
> split the large folio which crosses the 'end' boundary.

Right, thanks for the info.

But what about find_get_entries under whole_folios? Even though a
large entry is splitted before that, a new large entry that crosses
`end` could appear after that and before find_get_entries, and return
by find_get_entries.

I think we could just skip large entries that cross `end` in the
second loop, since if the entry exists before truncate, it must have
been split. We can ignore newly appeared entries.

If that's OK I can send two patches, one to ignore the large entries
in the second loop, one to fix shmem_free_swap following your
suggestion in this reply.

