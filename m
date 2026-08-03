Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34721C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2B56B007B; Mon,  3 Aug 2026 03:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AD66B0088; Mon,  3 Aug 2026 03:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3FC6B008A; Mon,  3 Aug 2026 03:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6FAD6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:24:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48FBD80601
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:24:57 +0000 (UTC)
X-FDA: 85059121434.11.881546F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 56DBE1C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:24:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSPpiq2C;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GrvYi48T9rtj2ujdtWafZ3iv82Xqtkh0FBbmVAxavE=;
	b=QAWItAnnGM3DnEe4uHPLV/VaZlzxgWptyL/hBfe24dGnR3XHwb+PKH2eWHGdf5L4DRmTqh
	RG6Qz+/7Md+YNn4lSbKLAvSnLklXXOEBlyyxWwUisXKLkZAGXJThgGcH+EmQzjuhsEXOij
	iQXXnpNNIzh7SAdPAvh331vZFhQ8HkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741895;
	b=H2cU0MewtsaJCPd99SxwTdAiD6+fwpBJY+Wf3sakWq1Ma/YZSqhVWrhx5lB1jJEyvJ33O/
	+SaVASYUtphg1C8xael8CKcvirWuJoX6qdSqUSmDxRXlu4G1cV58DhCDwrz/SfDJoUoU8e
	mb0gWVKel3FhIUBWqOkeGWT3F2Wy32o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSPpiq2C;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62ED843FA6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190561F01558
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785741894;
	bh=7GrvYi48T9rtj2ujdtWafZ3iv82Xqtkh0FBbmVAxavE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GSPpiq2CoXn3x9HS9f+7jsqNfsTpt+AL8b6nYeX6wlCPdBn4s799YtV8nqSHNEVRX
	 JZXCv0Nwq7gLddHIsytn28preC7plUrOhtM1LgWqt0OWhcIt/bgKFA/h4mAkXvIMC/
	 iUMU+6LvotLy/gZIpjjpy0+eyZsc2aZFIpchm23fDVm8HgCzGCWzXAxPll6aJrqESg
	 bnLoHSGaKS4jiJQ+c5rKMvvt6xkrlUwTMaiiyLIQo7lrPIWA4clnNeDdW+ZnTOqqS4
	 e0gpW7aRo1I824lqhHq7VX5Eydm0+X1lGv3U16cG0QkzZFJ4ZCjmSE8ps1yXR+NHSo
	 NWX3sZZz+MygQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e50a650a0so131033685a.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 00:24:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Roh8cVqFyFGsoRESLzysOwvc7AGvCuI7Ty255wtArb6wVGd4vID0IMdns4w2kWUVB11peo+99xbag==@kvack.org
X-Gm-Message-State: AOJu0Yw5AZ8v9cNVIdNTpd8ketNCn70FKaU3CH2bvLFra+7RSQrii7h4
	/dfjlFXgif8svg3aPWtresFE3G8bXqBQDB/pygSB6AYfF5cB6hOBP37hHYSOb6Y/ITAfuZ+k4lF
	C1Hdh792TJzurgFNGZflH9pw0gQ5/o08=
X-Received: by 2002:a05:620a:b89:b0:915:7e22:6f1f with SMTP id
 af79cd13be357-934a0944051mr1354619085a.22.1785741893224; Mon, 03 Aug 2026
 00:24:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260709081536.82768-1-baohua@kernel.org> <20260709081536.82768-3-baohua@kernel.org>
 <8f74bd51-11f2-4837-9463-d016444e45cc@kernel.org>
In-Reply-To: <8f74bd51-11f2-4837-9463-d016444e45cc@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Aug 2026 15:24:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xTBvAsqSano5dG1m0BDhceOR0VscfQxuH5oeexSX9kmQ@mail.gmail.com>
X-Gm-Features: AUfX_mzoeY1kBmJzvkkfwakV5IQyXI4UonPJMRBLEf8YhYfXOpUAHSdWURH55qw
Message-ID: <CAGsJ_4xTBvAsqSano5dG1m0BDhceOR0VscfQxuH5oeexSX9kmQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/2] mm: improve large folio reuse for LRU-cached folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ljs@kernel.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, npache@redhat.com, 
	ryan.roberts@arm.com, ziy@nvidia.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nbg8xkjn75tjtwaxdq8utopgssd647ip
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56DBE1C0006
X-HE-Tag: 1785741895-467132
X-HE-Meta: U2FsdGVkX1/78Hc7LJoX/RrVhv23VpbygGQM+8dImIxkyz9EWiax3xP0Ax1jOi8hp92uVInsbnViPSL58cGQaf04Q6H7Fa/ytxLWV0ZQkMClevmRLS/eOyP0XgCbZMjs12aipu7n/O79U61nGDG2TPepHxWhQ6rmO5WXaalLLG6amAZ7sMAU25queFBfS0AZ9OjCo/IVPwBsKrZ59BlD0SLS/f7LRnlSjUmK/B7f++KLhhjWwAxBNDyM//yAc33hjqdOcAkfoZxxBByjhfZjqhQatvR5215AWPHtP3vZnj/bCmcMi2tlhHqVBBbeIUaG/LJoxMViSfhrablGaFR9N3F6RqlADvWyqZwUCrFvLpT2kuTuppwBsGDQOJ4wNNReCfx7R3lPC86UPDE/F8JXaVWwNQhHtvrX/U6jDyK16A1DjmHUTmD9RVJlk8BZCGEX9wQLbQyhqsvfGk89pdRxKRnpmyjmdKGzUfAk2QLeq47/Tn66ErsqsxY9daCpwxHTyKj9YOu5pGoLJbOQagwxK/5yqofEkXerL32dMsNOqeUR1JUw92HFDa2d2s2361FFfi+L+2WTbEZNI7qdQFjgM6dcRtmLLEhTngFvGr0KIolcpxhLoJjpwc6hUW7Gonkd726FGeWifUiCP5nuvGzMotwCjqSo8u08wkbOQIWaON9YXLWjHqyMhs6hg50ch9cWimose82/8aC93LGB/uam+Esa0rfNCOT2kJXUBKJvuYMAamdiGEyLZ0F50mmMeZiy4BHtfi2KlEsxLpsafw7Y/WntajSIXflVTBevRf4gcVqAtJU98C9hkO63da/4dL8JtFTlQXUrW/JfCLwsYO5sGyLvUDIoWwysF2Qlo1mzy6Z7GpmklMsPmRHhPpsOEKV/Pyw3DgpYQuQwqhUlpJZf3CcVtfABSdrlqQgsKGsE10ENNPxqJBhArgCiIkGT1aJ79oxM9sQ7R+13kWhmw9j
 qkT0Xl3P
 vUN/k6CjkW9rG/FKSg3BdchCa9+tlKjOCZX+9tcDLeULd8yLSDrZsmNS6HJJe2OjhgzxLz8GqKhb8/2cbp8jWMYD13M/E37VvfAxWpNFacGWHou5KNVwwd3xHEHHXddkFtnfNjkX3waUiTV4C3HAPH9/ATtPOtLiBnWRs0CfyrODNiq9gzbogUAcLj2JWNMZvjG79dnPphMlLqNo1SiumGBvdYc28LOmCbR4im1ppveNFdnJSVqLVLM2f1g3BI9quAvUIMrDjbj6OFb3I8PSZhT3JhYC0KPzxrCNTWmZpf8BCoD9qqgyREREJLZdSFZkbKy0cAS/+gvtYJ7yQBQjHKDyY9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 8:11=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/9/26 10:15, Barry Song (Xiaomi) wrote:
> > Large folios may now reside in the per-CPU LRU cache. Before
> > attempting to reuse them, drain the local LRU cache, which
> > can still be beneficial in cases where the folios are likely
> > to remain in this CPU's LRU cache:
> >
> > int main(int argc, char *argv[])
> > {
> >     int i;
> >     while (1) {
> >         volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WRITE,
> >                                MAP_PRIVATE | MAP_ANONYMOUS,
> >                                -1, 0);
> >         for (int i =3D 0; i < SIZE / sizeof(int); i++)
> >             p[i] =3D i;
> >         madvise((void *)p, SIZE, MADV_PAGEOUT);
> >         if (!fork())
> >             _exit(0);
> >         for (int i =3D 0; i < SIZE / sizeof(int); i++)
> >             p[i] =3D i;
> >         munmap((void *)p, SIZE);
> >     }
> >     return 0;
> > }
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 5689b7cff76c..1d08ed5ba99b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4136,6 +4136,19 @@ static bool __wp_can_reuse_large_anon_folio(stru=
ct folio *folio,
> >               folio_unlock(folio);
> >       }
> >
> > +     if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
> > +             if (folio_ref_count(folio) > folio_large_mapcount(folio) =
+ 1)
>
> I assume that can just be a "!=3D".

I was trying to guard against the case where a folio is not on
the LRU but also does not hold an extra reference. For example,
the folio is off the LRU, yet
folio_ref_count(folio) =3D=3D folio_large_mapcount(folio).

In that case, we could simply reuse !folio_test_lru(folio).

Maybe such a case cannot actually happen, since paths like
isolate_folio() take an extra reference before removing the
folio from the LRU.

So we should be ok to just use folio_ref_count(folio) !=3D
folio_large_mapcount(folio) +1

Thanks
barry

