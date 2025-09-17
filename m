Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EAFCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32DE8E000C; Wed, 17 Sep 2025 05:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3EC8E0001; Wed, 17 Sep 2025 05:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21558E000C; Wed, 17 Sep 2025 05:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01388E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:20:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74ED0140444
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:20:53 +0000 (UTC)
X-FDA: 83898197586.11.834E736
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9ED0418000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:20:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M07d5UjR;
	spf=pass (imf16.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758100851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox09wceLheN9CV/GNKAbltAUFRxxk0VbuNEPceF8/DQ=;
	b=WawfulN9/MLsWOT8xA33se+U87RIKfpL9KoVDez1R31eB+hIb5+yoGlTcy3UhSswW50+ZE
	f9yHv9BeyGQ9ZmJGZZ9mogH2/HdH977lukuxNpL23fTg0Ou//Yql4FUwYGtm5HElYRzJvY
	oBc70xbAKFlfV746Xcn9WX7TqLzlstc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M07d5UjR;
	spf=pass (imf16.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758100851; a=rsa-sha256;
	cv=none;
	b=PyNZlC/iNY9ms+jvpBlQ+2TY2V4biXhZw1AlroZbPnhIA36ffevEeVhWCLAAriaqm/mk5q
	wd2gJT59kHKPQIYMPgJhHmUtAN2go/6hQqlo/HOKomYLiHLZihGs8Qs9lv3MFhzCvZVjy9
	lyc5qypyC4/XYxdEkfZFR+yPyzse++U=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-30cceb3be82so4637605fac.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758100850; x=1758705650; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox09wceLheN9CV/GNKAbltAUFRxxk0VbuNEPceF8/DQ=;
        b=M07d5UjRyL1fkpo62fDShQE1zdIhJaI4Mm0R1Sxx0Qpvqwk6cP0DQGSz4BRmbMJ8RA
         Rf6ZxgvQw5RtxxkB/AVW8LTIldv5soXpGKJC0jri/U6LSWbStsV1bK4KNgPnIYtyNOMj
         vSgao/Yzl5xfOtIy9TZhbzOZVXh4rgqYUSuCgOUCkpRAwfFDCtusugjC/l7zInmlV9TL
         wuhZucNhGFu9AaCIKsgBpX8CSCR753H36ThPN53inwvNkZc44xdLiPp5E8CygcBH46t5
         oPe1AaZcwzudpCJDSKtwzXt0uA4Sn15F9c7ukh3l3bmkiNxLCyONNqloeEB4tSCftZMn
         PtyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758100850; x=1758705650;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ox09wceLheN9CV/GNKAbltAUFRxxk0VbuNEPceF8/DQ=;
        b=IKWN4QYhZ+132FOKljgTlec7ZwXgniMceKJCDHEJ1Ci71TA8Q7fxnMyQDq3oIyMsGv
         hjqOhYfSleL84QM0fAH6vfV+Ah7IrV2ofIoIBO/uh5znIJTk0ThTaG6RotqlLQ/or9iG
         3PssiHQH9cvsgpXaZMQeHDVOJyTsW3FRyI8mMXceup4Le2qxSsI9E+x38TfYRZWGpqWC
         Rj0a53KOaTFxTltLVlyhnPLUZ1/073OGLcH81A7zf5OjK3EKUDERO9VtoN49WStk26GV
         soCWTr6DwRKzXz8uXND2ObuWz9qJ3jC+mQ/UmbpEHs2nrWJbYbRrBcH7WKitYeywpUF2
         5Hiw==
X-Forwarded-Encrypted: i=1; AJvYcCUIyc168O5Lu5Z9jrTioDvWaHYRZ7xykSFwrUxFTvYlpUyHJsgqrij6Cy1PLAi2TUEiG8+7P5uU7g==@kvack.org
X-Gm-Message-State: AOJu0Yw5FUNomW7W6VMUd/1LMfORIqQeeITnMWXydv3d3ClnxrlVSMTu
	A0ISqr6Nte+28/Vq71vDEHPo1uQZFUUjUCzKtrDM/6Zg4i2bG71VYuDGAJ1+bRqwsOGLXnrIp9t
	+oJgKxwRL9fsfJoaCIop0sXLXJkCMNjs=
X-Gm-Gg: ASbGncvDhHaYAXhto1j4MtzirvsL5Z5Wdf//JwzLet6GnWi/HCtA42sjiuyrUsIa+GB
	bKh1CRx1KQpXKejzJxqw1msMFLrgmamfrRHg2jPMAQ8KaRuhDBQeSaBjkkz0MkLESYH5VVEPn1F
	WMdZJBeawnOQN7iULtA5SlzgjF7vKX5M65jSVEaFlBpKNQNiVR5LCZ1OnyXkj1XiT9CawTDVgFw
	KnUoA==
X-Google-Smtp-Source: AGHT+IEvi/vcvuNXEKryAobinAuQaOybDNziHzvdIl5fQxCUxTSrL6UDLu1P/TgPbjPopqUhtAHphiQym0mzQtaf3UA=
X-Received: by 2002:a05:6871:d618:b0:31d:6467:3ddd with SMTP id
 586e51a60fabf-335be8c863emr772149fac.3.1758100850540; Wed, 17 Sep 2025
 02:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
 <20250917033703.1695933-3-zhangchunyan@iscas.ac.cn> <bc87f2a8-7a9c-4416-9106-bdf4b98e40a8@redhat.com>
In-Reply-To: <bc87f2a8-7a9c-4416-9106-bdf4b98e40a8@redhat.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 17 Sep 2025 17:20:14 +0800
X-Gm-Features: AS18NWA4SAC8zxdE-h5_sRhBzgX8xMPmN4jL9phgOErltDfEWb2iq0mEGYtEXpk
Message-ID: <CAAfSe-vjgcgFyvVoci8F9ra4JwbDcdbhsxjSL0j8=0CCKAzFHQ@mail.gmail.com>
Subject: Re: [PATCH V13 2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
To: David Hildenbrand <david@redhat.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Conor Dooley <conor@kernel.org>, Deepak Gupta <debug@rivosinc.com>, 
	Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3ez8t36hztu8h8r3soto4au4qetc8o3b
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ED0418000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758100851-884692
X-HE-Meta: U2FsdGVkX18qb4UGNhyYKILPhkee8pmhiMZwFs1YiTX+ob/bGbvWh1cb/IgXteZtZz5e8jZsH+FQrTdOTKZfk4+6UjktQjnKFsamGtkCrgEb4m2TEQ7ArCvu5kQJn+0Bq6pvnkSr6Ac8FwDY9BheFlz6a/eqh1qi0KmVtO26q6KlxdNZs/BQ9bqywqKbEpGfS6ZJYuWrPtO9StZUVQMX4Zpzh1xB2d8/lhWBEVX7feSm7CUU+Pvvqg7TSeaDdL7Em5CFgU5c88su1mn/9GR/l2ph5+g0wdTTzDiRqtaSOdJ3W+tb/MuHBrsUzQA0JbdNAThV9gMq67kCzuGUoKqgBsk8MZwLoFAAqS3VlUezL48vgl37OLUJw7WIyHkWQqkGv6ibJwkW3MZz/N1m7if0o8TkjVNjS8Ev2K49KTMbMdyiwA2iMS0gcl+EqUQORL4zai+LHp2PSfz7fHQkHd1aVR6u0VasPn5yU4WP1g6qls1buxTykkLu+j1sEoorCuTHk8KFR2fkRw/mL5ywtZWqto5BvowQEb+NE8agrM70WEf9jofAEhw8FNsM8m9pPdjItFBTmKHXKs5JLLuv3mtm3vcPfuPvzs0kUVCdTAfliJ20laJBL65XHol2ecvoZVduTVA/ba8lcEXzzejTcrwGpziwloZU3icc1y+7lYTuN7u2hRQX7yf187+eP5AkyBu7Ri0knc3LCOqLjWIjI2Apj5O0cdITdSa4z+0/2IBkqa8m1bzvSN+3NamUBMJYEle5h+VXSxNoJbjkgIBgSD3tJZF+BjlpmHRuYOjrNKtCsqk2XauWR78CdMYZ/2BNSMIs0f56Sgt3KprEKkjS4Tbtm0csqk3c5zkT2Wn9oGZ5xjvZiEOjVUY0fmxc5IKvadK6GG9AE90S0whp4+jkrP3KS1Dd2zk/mMqYCSYpwANMRBDfXE5MdeSgMsofGxcLQINR9NQJg2C7PYgntHcv/sI
 Xdj2joRI
 rNattzyqLRS9SOdJENASq4153q9G5wNMz2uBb60kU1URNwvA4BhT6JOlT810+GO/5KvDhrIQdMTEJimhUVTgpSz6WaOi5y5Xk3zJqYJ0vDQneZ5uAmG7aO4WUGm5hryW4xEAl3ZGWPDtzMSgrBAHEAAPD/l/xL5povjB+grIUVBDq6RiVHkZAiKPcvL28qtAXTyX4GCVQ+jh6mmca0I+T2T8O8NGaTKhoU66BrHSdnBgHQBtbhwpiUh3o1QD5siv2PIJnWR6LBdPeZdzVK0RmqOAPk7cH/0FDm+klLYHrnRngORu6IYhfzfmGWRQWsCx14DpVQJdkIAH26r3UJgMzlKiTF80NUKOri/I5fYcvO99JoIG1G8RwNHvAseJ44IMZhib8yc1ASCkiIbhsxWQWP3e3dsq6XADcOJkDxa1RLSMkj1Ji5zHSzL+bME8B74iI4KP+tUGrrDVUxnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sept 2025 at 15:25, David Hildenbrand <david@redhat.com> wrote:
>
> On 17.09.25 05:36, Chunyan Zhang wrote:
> > Some platforms can customize the PTE/PMD entry uffd-wp bit making
> > it unavailable even if the architecture provides the resource.
> > This patch adds a macro API that allows architectures to define their
> > specific implementations to check if the uffd-wp bit is available
> > on which device the kernel is running.
> >
> > Also this patch is removing "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
> > "ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of pgtable_supports_uffd_wp()
> > and uffd_supports_wp_marker() checks respectively that default to
> > IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) and
> > "IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_WP) && IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP)"
> > if not overridden by the architecture, no change in behavior is expected.
> >
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
>
> [...]
>
> Taking another look.
>
> >   /* mm helpers */
> > @@ -415,68 +475,24 @@ static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> >       return false;
> >   }
> >
> > -#endif /* CONFIG_USERFAULTFD */
> > -
> >   static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
> >   {
> > -     /* Only wr-protect mode uses pte markers */
> > -     if (!userfaultfd_wp(vma))
> >               return false;
>
> Isn't this indented one level too deep?

Oh right, I will fix these.

Thanks to you spotting them out!

Chunyan

>
> > -
> > -     /* File-based uffd-wp always need markers */
> > -     if (!vma_is_anonymous(vma))
> > -             return true;
> > -
> > -     /*
> > -      * Anonymous uffd-wp only needs the markers if WP_UNPOPULATED
> > -      * enabled (to apply markers on zero pages).
> > -      */
> > -     return userfaultfd_wp_unpopulated(vma);
> >   }
> >
> >   static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
> >   {
> > -#ifdef CONFIG_PTE_MARKER_UFFD_WP
> > -     return is_pte_marker_entry(entry) &&
> > -         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
> > -#else
> > -     return false;
> > -#endif
> > +             return false;
>
> Same here.
>
> >   }
> >
> >   static inline bool pte_marker_uffd_wp(pte_t pte)
> >   {
> > -#ifdef CONFIG_PTE_MARKER_UFFD_WP
> > -     swp_entry_t entry;
> > -
> > -     if (!is_swap_pte(pte))
> >               return false;
>
> Same here.
>
> > -
> > -     entry = pte_to_swp_entry(pte);
> > -
> > -     return pte_marker_entry_uffd_wp(entry);
> > -#else
> > -     return false;
> > -#endif
> >   }
>
>
> --
> Cheers
>
> David / dhildenb
>

