Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE77ECFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072C06B0023; Thu, 20 Nov 2025 16:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0239D6B0026; Thu, 20 Nov 2025 16:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B6B6B002B; Thu, 20 Nov 2025 16:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D55B36B0023
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:27:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E22DE139CFA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:27:29 +0000 (UTC)
X-FDA: 84132271818.02.8FF21BA
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0985316000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:27:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEijFUi2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763674048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MQ2GPBHW83S5fq1wRW7v7lPo7wmxf/AYTgBtJy0YmY=;
	b=C6ktlNqdxrA8GGBm1gKcLqHeNNc5nQbBNgWBr2BubXFPL4iPu+HYe5ULXR5v5WMPIMhAbe
	NYKoNeMJLvsPMu9W2Ppr4aefhi3kx61200ZcP+VAJvKQ2gcA5dLajxhlZ9iiLef85KEnoY
	rm6kDiNJiwKRVq+R9DsLu8rxh2AwSmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763674048; a=rsa-sha256;
	cv=none;
	b=1k4lpJmrTbnAKKULEqzS9/HYnk6/4pAc+LAAi6U45Ghv1bcLOmjBD4j70SoysJK7bym4He
	t/BGJKpL4iEc15uf3zDjSW9ULKD+y+e0OqZh9qGgiPbXnJQqbCzmtVym2suVAuG3Q07aGM
	NCjjOCprV3XoQwktmipNK4y6TyJmIO0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEijFUi2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso1621400b3a.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763674047; x=1764278847; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MQ2GPBHW83S5fq1wRW7v7lPo7wmxf/AYTgBtJy0YmY=;
        b=BEijFUi2zUtNzdEZa7uXt7+45XeNj+A04+SmkVI91iwwxb5xo0ArpfyCyJYeFDxKiI
         SmNLe1dMW47f5NGBDX5RtbIujTF6gSgoV5yh9NMmRfaqUsSPW9JjgsZVcuHdn+OnIjaa
         N/WEWJEKovZ4JUcBWGMz+Zvc6yrD5n6Xle6Dfv/PKeMkixNSvhznrB0NWjfiIPIqTRHy
         FPg9+Y0QviIz+pclhWGiA/33uNVXC47zskuLrkHgrmkg5la5pMp0GZVYxujuywr1Nehq
         FDKIiP5agSrHmtqkF2xsX3vS5XU+RM3+NlticfvdORJQiaY3A02uiAcN8Z2D7gBXkeff
         2Jdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763674047; x=1764278847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8MQ2GPBHW83S5fq1wRW7v7lPo7wmxf/AYTgBtJy0YmY=;
        b=TtRd+4fZkqhjRlavPqW/bBR5BBg8tIwb5aF9GiUORDGCoFJn0fj6zxq4kMCJ6Zk8S7
         iiU8agoM/ETUrvBpxUwhbbjcNmwa6MZBXp93G2FXkJcolU1sivuyAktCjun3nrvTlfs/
         U8JEfdkbH9VF8rcL/01xnjioXFhYrZIBIwkKIhL8xb+03eRVH7i5U6SxqK9KFXl6cKJ+
         ID3opNVgRsogRu5CzEfitH1Lw+ADDsmtpayvxb3BK6EuSYcR8+tR70xtaTDFR93OEPdG
         lVmYdLMIkGWvwnYcoQeiRuIG2AT2K4fBR0ZVqcGZnHxPcQRA/6CUeRZbNObaTLsvIiQO
         jBYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUuW2Nef5sT4pItUlyIDZS7r5EnVYJeWJPqQf8ok4RyKGbaB+COGMOP29UEUCPp55gGXNcswqUxg==@kvack.org
X-Gm-Message-State: AOJu0YzfdZYiAEOczAbDToslHelbE8W/7NmxlaS2BSas2MCSOA2+uxj6
	17fkJGExMn2NLZfFUzBPjXfFwxvxT3hdm+2qqjwMNADGGSDDK2y+nzYl0GgYHjlXY0K25bYaDaM
	uebsyEGT7y/VVznEjM2YzDkF6JsHDW9c1dP6Vm2M=
X-Gm-Gg: ASbGnct8afLt7diw7GOA2RR0Fjf1IqdtyFrf/mlUgmGSPVpS0yi+jclWwgJPU4QFTj/
	ELfJvaeqVrWP8R/N4tO4gRov4MSyB9Y31j/hGUYxrpxF/E23dRcat0eBNnLNzwrLcwOU0jcafo1
	HtcjzzOojSnftJ2nexztInj+8hgbnQaZ48PP1R4QsRMURYJ3RtqdKPsVgxmeas9vt+u+i7jie0l
	dkYysIOPJiSuIViLmjPirGLlgb8POfR9rjWz74F2BvYML73oHoetENc6yYcNBpZkYDGtA==
X-Google-Smtp-Source: AGHT+IG+lg4eS5i0rptnxHqewOGmi9WIWtm3BkNS150hRV68edD3IKYERtGEqWDxSOmk7U8Kg75UXfI9iTTk7B7cmnk=
X-Received: by 2002:a05:622a:1aa3:b0:4eb:a0aa:28e with SMTP id
 d75a77b69052e-4ee58936cb6mr772331cf.64.1763673645433; Thu, 20 Nov 2025
 13:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20251120184211.2379439-1-joannelkoong@gmail.com>
 <20251120184211.2379439-3-joannelkoong@gmail.com> <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
In-Reply-To: <5c1630ac-d304-4854-9ba6-5c9cc1f78be5@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Nov 2025 13:20:33 -0800
X-Gm-Features: AWmQ_bknxKe3HYjwzzfUFST-_e4QC_Zgx5EeYqCXoRNHcbarFlFOQ1yJzG1WvYc
Message-ID: <CAJnrk1Zsdw9Uvb44ynkfWLBvs2vw7he-opVu6mzJqokphMiLSQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback
 hang in wait_sb_inodes()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, shakeel.butt@linux.dev, 
	athul.krishna.kr@protonmail.com, miklos@szeredi.hu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jmzkzdfkgafg9j6d5fdw1krpsnhsh3fj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0985316000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763674047-748706
X-HE-Meta: U2FsdGVkX189zn/51Mm6pGdnlpDCjwO844LgeSsZLd6oQpy1pk4KQJ5gL2fMGbq6qQPJpozFyHx6lQh1VJixWYTDrAwyaQoMik360JGWFjiXG+1qK94DokyKzBQlwfm+XCNcRcoCVJLl63Pvn0GPfWt21gl1no9xudbY8f8pksFSqHat4gcX40xUInflSle+8JUWOf1zZGIEHXvYYfk/efApVzBS2lHJDBuu4weq5I129FRlLK0gFQi2ZS9zGGBdyjZ3CvOuLO4cvPhad+2/S2u60zzAzgxh01z9XoNOd8MjEk6ZRRPw/tUSey5ILGBhqWejZatjS2ECFi+1pYAksj2s+GqA3qYt3LPWP+UZEthfnh8AMoQf3ndQTw1s7kNhbeXNjSPUpgYXBNhkqH7mM0PevIkQOu5a/TcdHJcvdIrrfCUSnQsgj/G9gAhY5OteT4HFyeADepfcQyoKKt2iW13wD3OOXhkJiuerTq/PjWc+2WzDXSlPEtA55htWbR3rJyiGLnTe3TXLarTgUZkV9xDHB09obh2qnj5kwPNsiC+wK/Yc1UEm0eBUo0IWy08fJoIvO/ZfSZzVPaUkN+0/5ivsop30XObqy5vCMUMCGyshwYHcLT+s/KpXSkPmIjVH5qXF/AShQ/Ocu1IRGb5h3uwoorNP+zDofywzXyckn3EUtIPjJE6GaOBrMhlotwHppcu26ctsaDU05B3v9DHbUE5ho75YTTOQujzh/PVZb6uAAwABME/AfZY2ZIDokWPfCxmWdREclZxx9kXflYNDwW6uFcbQPu7xEHJwrCUaOAc/+fTn6oE01vmqEUKSRvTWmuxEIwvFnmISTBqd0Gvp4B/dPAEzE4K1vT2vJQEkK3gF9lCFyUxx/dzKkT9OR4luOOesC2NrchTANJgddVpOHOq3FHb9DYteqhdVxGhJRJvT6k9tXxv0LFbBWHXUj46D4NN7I7DBgb/k295JBcY
 9+YKlU26
 Hq5Gqkbx4vYhgw75fLGXyyz0IiWWQOnkK3ik2kV57422Zahn8BJVWKGugrt7x3bJccwvqpSIrBjXOYmDrF3sC1LhQNRSjTEUfjhkkKP9ujb5iwx4XROlbo4K8nY9tTv/o4HoKgtpLex2INgEGzWVU0PiqXnz7zgFnqIQORpz7G+9o1U5EWoLy9O16R9JBnWk7QoxxpB5PJqUjITQfpinmZu9oL3WAl6adlxlVg966I6bT+uwvXhskJPLjWqTVozcyTF9iQYAgM1fPlL+vjIBFH+FAL7BbeDluqX4SnIb5howEui/a3BQKg8Q4v4fyWMo+kocX5p8kcnqytGeZ/5BMKOSO/fuCb8L+I+etnsGaRo1uhkKFSn6rh2Gz3M+i9ePESeFrkpxhW5tHU6sU5rAYcuqA9LrilvvzsCfkHR5qwJkM0KuGc0yFjwlKjyQLyHk0bN/DAS0ey/VXQGHw6G5P2pW1iloTfNCMZ9k7JsbZEvOiMeeNswpk8655tWfMt4bqy3NM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 12:23=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 11/20/25 19:42, Joanne Koong wrote:
> > During superblock writeback waiting, skip inodes where writeback may
> > take an indefinite amount of time or hang, as denoted by the
> > AS_WRITEBACK_MAY_HANG mapping flag.
> >
> > Currently, fuse is the only filesystem with this flag set. For a
> > properly functioning fuse server, writeback requests are completed and
> > there is no issue. However, if there is a bug in the fuse server and it
> > hangs on writeback, then without this change, wait_sb_inodes() will wai=
t
> > forever.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and interna=
l rb tree")
> > Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> > ---
> >   fs/fs-writeback.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 2b35e80037fe..eb246e9fbf3d 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -2733,6 +2733,9 @@ static void wait_sb_inodes(struct super_block *sb=
)
> >               if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> >                       continue;
> >
> > +             if (mapping_writeback_may_hang(mapping))
> > +                     continue;
>
> I think I raised it in the past, but simply because it could happen, why
> would we unconditionally want to do that for all fuse mounts? That just
> seems wrong :(

I think it's considered a userspace regression if we don't revert the
program behavior back to its previous version, even if it is from the
program being incorrectly written, as per the conversation in [1].

[1] https://lore.kernel.org/regressions/CAJnrk1Yh4GtF-wxWo_2ffbr90R44u0WDmM=
AEn9vr9pFgU0Nc6w@mail.gmail.com/T/#m73cf4b4828d51553caad3209a5ac92bca78e15d=
2

>
> To phrase it in a different way, if any writeback could theoretically
> hang, why are we even waiting on writeback in the first place?
>

I think it's because on other filesystems, something has to go
seriously wrong for writeback to hang, but on fuse a server can easily
make writeback hang and as it turns out, there are already existing
userspace programs that do this accidentally.

Thanks,
Joanne

> --
> Cheers
>
> David

