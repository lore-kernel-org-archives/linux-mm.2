Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD91C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFA76B008A; Fri,  4 Sep 2026 04:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870CF6B008C; Fri,  4 Sep 2026 04:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F596B0095; Fri,  4 Sep 2026 04:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 533116B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:42:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFC96C0D25
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:42:11 +0000 (UTC)
X-FDA: 85175437662.15.80322B0
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id E91CA12000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:42:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5tjUv8E;
	spf=pass (imf29.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788511329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpKXVaZHdTdt6DQbL+myc9NHgl411uQ4fphQjjYjl8I=;
	b=bwds1VqnKHnSgS/ZaHjazI2l5C1LtXZoCsavgpw+FoR3RZIK6o02XvhQeXkHXzdrZuyWEB
	gaDOzanyCjV/UY2tYo76rbBKuZf3nkfy2fCo+iudyn3V8creWfdFxyj5tWC894gBq4rJtw
	nCSRT4w1osTH+r9KnSHQYdKz+e2gdIE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788511329;
	b=6fqdpZEykyvpzzbyllt0fA830FrGr7kOXO7ey0Ip27wzZ02c8Ki4NrAkXGRVY+oYn+6QRh
	InTrEsnKlsU5WyGaEeNkiDj9BidTYVwnZxzBcqV/fw9SJba+3fzmJr/0rY4i9e34Na5PIr
	cnbFTyF6MVy5jW1g7Ib8Ysti6jg8kKg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5tjUv8E;
	spf=pass (imf29.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2569aa5116so300977066b.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 01:42:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788511328; cv=none;
        d=google.com; s=arc-20260327;
        b=sWhD8uj87bHFbBbw/TpPMCS6nWzCAEdr8IBIYnPwxnKMFnzVtEIld73jJCYp+8I9dp
         Iytlz7zjxEgPwr1jr/o/Jg3rqZsdx5FQvZm1cBiQ1UhduqG926KUVXMvUFTn/0b1F4Fi
         z6NV1tgQJsZrs4A7msGO78QzXOe/u6x2BAckSxfa9YX7E7s9tpLWS5tOz5Ifdixn9R92
         Vhj/04VU1doNA8hQGQp59ICeAPVxh9u8hQehwrD9ywI8nQ2zMcYZ8h3dlH3UIW38IC4u
         oucGfcw05jFt48NFMJClE5B7ZkHv3Lwyc4IvcGW1bEoul9lBtU3kzWFyxCHElePBz5sj
         F6zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jpKXVaZHdTdt6DQbL+myc9NHgl411uQ4fphQjjYjl8I=;
        fh=I03k7NTiBD/pZA0EOqy2gqX6dt8udV6j5kgZuMRIBuY=;
        b=XX0rufVIhm7IuIRGlfkazQCREo8giNCSnTtEXQCttQiPQMIIrOsTfovDt+Aq9hdjo9
         7kmkEZQ7WwQACneU5H6kGBY0WlRg7iY5wqN3hkrQ+3xkT1/HEUtjJZC/ZDmoiJjNxruP
         OM6Uv+DdvB0QzlfRpYzooQ6IQjHyznw3T1eTV1ARliwneAx5lGfSo98uQKVf8+qMsjom
         nZrHklYMdw1FKyvyiz0p7BALhd3nZof775Odtt2fwyiO8E++ajFl5agyOdrbd40n97AU
         nNVkx6rAo7ZhNbTfr5LzDBa1ObnFDo+s1J0xfZgGmRCCWm48qqhX6V7efR9FOKwEaY69
         ua8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788511328; x=1789116128; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jpKXVaZHdTdt6DQbL+myc9NHgl411uQ4fphQjjYjl8I=;
        b=W5tjUv8ECwWXn+1bMdRGUk8X6xnRxcODIsLTg1J5DY8CtKsjZa3Jmo/GIzBZkh6q2E
         IoDvlppiIB+sYCRsRsx7jvjzGkc6INWtae1zkrrExzgUQfU4otFMbTni/wLXo80LT4Bw
         7cXzsG30jj5AX2U4u7jQkF9RaA0RywDk+/Ackr+n1Cy7TXqlcVxP+QphfegehMDTlrok
         sPnow72ttra5PRV8zbn7keHpSwm/pJRyvoOpmTx7K0fqh1pYgY0GE4PZW7WuQkEaZetW
         xhAz2h5/PQ7sh2IXzmZvVTF3RXK2EpSCysPTlD2NWK1Hi3JGkDUiii0ajSGUZzWZJNdG
         0LnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788511328; x=1789116128;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jpKXVaZHdTdt6DQbL+myc9NHgl411uQ4fphQjjYjl8I=;
        b=RZtT3U0Mmyg0mt9nzTiYqZBMOIBTXx6qt2kxQkRvVOwF6lw3WkECQx7ILTYxRxNoi5
         zdHd96dUQFTF3DUxge0rbG9JRJXqaXIaT2Ar5xcqgobDJQNg98CtKW4GjUQgs/dKW6G+
         Arj60HPCu/R25f9Q70Gw/IYOM+1TprEg1lCVkQSZ7smHKNr7DX3Q8jLsgLkNfCAoE5DL
         afpNNX/lm0NTDWaoi9476uvDZ6nmIzzz9745wEdRbAx3j5kP2jtcY6HMRFknDKJcYgo6
         cNrE/0nOLPRva92qyUMT2GO8lwKU5F5lM/voVdjtQTvzNOTmxB0ymBfHC1Gf+6iy4kSP
         Y1gw==
X-Forwarded-Encrypted: i=1; AKwUvBySmtXaTA+W8tQEM7T5iudya0Rw2IZ7NImaI6lneVxyQ3+vNRF5kZqr1N8P0018P91vmdT0FpLKQQ==@kvack.org
X-Gm-Message-State: AFuF++kFkRTvd5pwSIWL0HMqevPjHywz1gh5AOwaD/eW57bKBodQGdRc
	9zJ3rCiv4qNj/uXqC+qqAdZDpFtOvEB2Tbok/YJYGR4Eyoe+Qb+2HS+uodDRuEV7r1UM5bhPSu9
	p5kc1jEOQKxNcvOCONPbtvcHQnt2HjRI=
X-Gm-Gg: AYBFou0TzYLE1S5OwQs9HSz2The3VSaIprVhx/1ZMRjbvK7w3tjKf0eAHT0orr3Dmav
	/nL+ks3mjzI/UGmf0kEAXW3VR74cEHmMdQZAZ0nFpNjF2tQQq8SWe32JylbrRKWse77MYATIttu
	IdO3ezFubukUqImgKNZ+WF36mF1EZt9bMNnpcbm/BNr+o5tVpvg6DIXLZCRikWZbgN2oHddKeUI
	kEa0FnX+VDd08Pmi2eQghog5ITI28O7nU3SCbIQZc2mtJxTG1v/dy9zdbdtwK5scBVIebORb6Sn
	gsnWVBrxpjbIfIpmICc72Bdrv2F/DzESdudo16OpDtoe4E7WJ5I3lFSit/zXITHSjq82zNDYkX0
	Nk8ZA+vBEhq+U9Wi/NByazDwZKAU4xZJocQWHGUsrkWzV4NozYCGToc//UPFp5zKyRFIg5Kvr6J
	v9tNzoblayW5V8Y4UHsGQxQw==
X-Received: by 2002:a17:907:c80d:b0:c25:f7dc:2d5 with SMTP id
 a640c23a62f3a-c25f7dc0956mr335630166b.22.1788511328113; Fri, 04 Sep 2026
 01:42:08 -0700 (PDT)
MIME-Version: 1.0
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
 <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org> <app_o87YogZExbwm@kernel.org>
In-Reply-To: <app_o87YogZExbwm@kernel.org>
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Date: Fri, 4 Sep 2026 10:41:56 +0200
X-Gm-Features: AcwNN1UPcs_8BNTcRCCyk459e6bq8UmS8tThJGN_9UH8aSGnVOrR9_EbHYN_fL4
Message-ID: <CAGJbn0f+s3U0G=1yUx7a10-buHgA_yu0REG01M8hgFo=t+3Y1g@mail.gmail.com>
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot@kernel.org>, 
	syzkaller-bugs@googlegroups.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: multipart/alternative; boundary="00000000000063ac95065aa43eef"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E91CA12000B
X-Stat-Signature: jwuu1ihqgkyn54a3zpdpddturku1cqas
X-HE-Tag: 1788511329-959431
X-HE-Meta: U2FsdGVkX19c83+qAjKj/Se3LvNEyEpRsdJPgktFxqJwrbtQ6df0YfKzTm1ZZuVLHNQuWybdar4YCVeK+7xXgwTwxfyunagCmPFa3iJj7Fb9um4m+6xvxhdp5bewyxITflH8snhL0ihzfaYH/uq2IgK9aIzqnSbBfDvuNchq+ChcvTZ/G04lTPoDUFo5DwrVG1/5WxA82RZeI94XHI2ZNjIMaSFOyrtsdMxYO7PZOO4fjhYMZ8VEvzp02rEcTalDvyD+hAIPEqfKhi7f4ZRgeFbmXMDaVnqcJsaE/qUBdBFlpsMNEAw+JGCSZ7fn/pp3NcfsdClaIIMxI65wyNEIPwEUNTiyG/9d6hWR6QNxIZ/fpRx1bUMwOEAwfzQkaw/ggdaFvWSaEJz7A4YKuNw1uRHDfXibUD/VgZq8OT1Wq0ZrtaCbm4oaL0y1F+8Q4rxw1ztCXczJWqQVcmcZmKGtXkOcxmNocPdgKbQwywfu8xfpwftMjmbukUxAoiG5cSVQKs0nlB6A+Vf+OxsqxLkYcRsrwRhQ78Rp91aufTUWso0/3iy2vAzWZVIcegtl+U8HFnPe/truqSIU1625e32MPixaVQyALkEPCvIrjjt/UoOacM8S/ZD+s1G7c1aJYgiU2GUAJDF2yogtzo9YoKmFazb/KVgkYeWuMADYrbaevS4WKEzYOxWmwCPYEjLli7M6FVe3ke6+cmeVoAvmhTrUttKuCiD8qo/ph71qqbQo8fhsVJPurvHxf2AB3fF1HQlMrQlZO30ONuFHWbwkWP8Y9/6uBEaZAdlKZcSKVwFrp8Jkfc1XLikEca+qagxLbbO0jjTW0eg2NRHpPkf6PXrXnKy1/2UxqwaLxd4n2A5AhfGyowuQGtd0gpFq9BQLZOLlie+AMWoAl3CLe3eOBa+FD9zJ4/PV2vk8q4xstBd8Nq9XcKL9SITdhlgrhPgHEjNAm/5KZIPB6qs/922rvg4
 bcpv57Zr
 morlSyLz7kylf1aRnDUCBFDOd80gmd3aexfqZg/gyTaeF8A0b6eHSFDv78BT85jhSp0lhoWv46RD8wsv+W6ph2f8ZGzEbEBXjc41EkaH+9vtiP6PXGamkD78xqUOqh10NZiMbJtRy5SKlFWWkj3uSapTX/bpGRsQTHctsxS4PJbT23KcRrFr8TbCoQe2tgtsebzHPEVT4Ls9Wtzzj3/SJu3uOl9ZFMkT7A065/muEXep7nkNWTdfL1dOhON0icAdp4mwvZwqDH52IXSKRbhFeTdVNsoyChjAoKm65pgCBiSqRaIQsAjI3nv2fyH3m8OqQYWg+TBA7eBEPQUFyBhPtueyeSDqKS5HM2Ifne4eyGKLZ4r+PrFGZhixBkSB8rwetHBrW2pZADspS41wLijg1ny22HaOhYR7BkYqhds1ZBaSelnoIb3/KzES7A5UFkjWPJMwul67FUfjs0uluUwNYtI/Gjf5Y84zosBkkLC+P7CINZe1bLC9wF7bTeC+vgF2E/yZw7Oqbx+lcvRa1Q+U6z66wgnpZA7oReKuMjNWuDI/XdSER/Kgwm6577Ni/wGgH5SF5QVXg73cKc+PcFANiok/yh/WOpM5HgLpk7jId0GFdo2nRbSWO0shkg5A5zqHU8XikmuhNVindQQS6Cp5OmnsQrI4kcGNWWh0ViizWxd7cpvWYenuTH57k6V48KAnOQFny
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000063ac95065aa43eef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thanks for running tests on my patch. I've quickly looked into the test
result and the problem seems to be related to check_multi_find_4() test and
not the fix itself. I'll send a v2 patch once I get the test fixed.

pt., 4 wrz 2026 o 10:22 Mike Rapoport <rppt@kernel.org> napisa=C5=82(a):

> On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:
> > On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org>
> wrote:
> >
> > > From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> > >
> > > A bug in the XArray iterator xas_find() causes the iterator's index
> > > (xas->xa_index) to jump backwards when iterating over a multi-index
> entry
> > > (like a THP) that resides in a non-leaf node and is concurrently spli=
t.
> > >
> > > When iterating over a multi-index entry in a non-leaf node, xas_load(=
)
> sets
> > > xas->xa_offset to the base offset of the entry, but leaves
> xas->xa_index at
> > > the requested index. When the caller subsequently wants to advance to
> the
> > > next entry, xas_find() is called. xas_find() attempts to synchronize
> > > xas->xa_offset with xas->xa_index before advancing. However, the fixu=
p
> > > logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift)=
.
> > > Because the THP resides in a non-leaf node, the fixup is skipped.
> > >
> > > As a result, xas_find() simply increments xas->xa_offset and
> recalculates
> > > xas->xa_index based on this new offset. This causes xas->xa_index to
> jump
> > > backwards. If the THP was concurrently split, the entry at the new
> offset
> > > is a node pointer, so xas_find() descends into it and returns the
> folio at
> > > the backwards index. The caller (filemap_map_pages()) then calculates
> the
> > > PTE pointer based on this backwards index, resulting in an invalid
> memory
> > > access such as an out-of-bounds read or use-after-free on a page-tabl=
e
> page
> > > freed via tlb_remove_table_rcu().
> > >
> > > To fix this, check if xas->xa_offset matches get_offset(xas->xa_index=
,
> > > xas->xa_node). If it does not and the node is a non-leaf node, set
> > > xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before
> advancing.
> > > Also add test cases in test_xarray to verify xas_find() behavior when
> > > iterating over and splitting multi-index entries.
> >
> > Thanks.  But the changelog omits vital information: a description of
> > the userspace-visible runtime effects of the bug.
> >
> > > Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> > > Assisted-by: Gemini:gemini-3.7-flash syzbot
> > > Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3Db72767277f29b640708=
3
> >
> > I see from there that it was a use-after-free, detected by KASAN.  I'll
> > update the changelog and I'll add cc:stable.
> >
> > I'll queue the patch for testing while awaiting review input.
>
> The testing shows there are issues with this patch:
>
>
> https://github.com/linux-mm/linux-mm/actions/runs/33815757662/job/1008474=
25973
>
> And since it's in mm-unstable now it breaks all CI jobs :(
>
> > > Link:
> https://syzkaller.appspot.com/ai_job?id=3Da01c56bd-74d0-411c-afb4-ee6f0cb=
6cb61
> >
> >
>
> --
> Sincerely yours,
> Mike.
>

--00000000000063ac95065aa43eef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>Thanks for running tests on my p=
atch. I&#39;ve quickly looked into the test result and the problem seems to=
 be related to <span style=3D"background-color:transparent">check_multi_fin=
d_4() test and not the fix itself. I&#39;ll send a v2 patch once I get the =
test fixed.</span></div></div><br><div class=3D"gmail_quote gmail_quote_con=
tainer"><div dir=3D"ltr" class=3D"gmail_attr">pt., 4 wrz 2026 o 10:22=C2=A0=
Mike Rapoport &lt;<a href=3D"mailto:rppt@kernel.org">rppt@kernel.org</a>&gt=
; napisa=C5=82(a):<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:<br>
&gt; On Thu,=C2=A0 3 Sep 2026 13:48:55 +0000 (UTC) &quot;syzbot&quot; &lt;<=
a href=3D"mailto:syzbot@kernel.org" target=3D"_blank">syzbot@kernel.org</a>=
&gt; wrote:<br>
&gt; <br>
&gt; &gt; From: Krystian Kaniewski &lt;<a href=3D"mailto:krystianmkaniewski=
@gmail.com" target=3D"_blank">krystianmkaniewski@gmail.com</a>&gt;<br>
&gt; &gt; <br>
&gt; &gt; A bug in the XArray iterator xas_find() causes the iterator&#39;s=
 index<br>
&gt; &gt; (xas-&gt;xa_index) to jump backwards when iterating over a multi-=
index entry<br>
&gt; &gt; (like a THP) that resides in a non-leaf node and is concurrently =
split.<br>
&gt; &gt; <br>
&gt; &gt; When iterating over a multi-index entry in a non-leaf node, xas_l=
oad() sets<br>
&gt; &gt; xas-&gt;xa_offset to the base offset of the entry, but leaves xas=
-&gt;xa_index at<br>
&gt; &gt; the requested index. When the caller subsequently wants to advanc=
e to the<br>
&gt; &gt; next entry, xas_find() is called. xas_find() attempts to synchron=
ize<br>
&gt; &gt; xas-&gt;xa_offset with xas-&gt;xa_index before advancing. However=
, the fixup<br>
&gt; &gt; logic was incorrectly restricted to leaf nodes (!xas-&gt;xa_node-=
&gt;shift).<br>
&gt; &gt; Because the THP resides in a non-leaf node, the fixup is skipped.=
<br>
&gt; &gt; <br>
&gt; &gt; As a result, xas_find() simply increments xas-&gt;xa_offset and r=
ecalculates<br>
&gt; &gt; xas-&gt;xa_index based on this new offset. This causes xas-&gt;xa=
_index to jump<br>
&gt; &gt; backwards. If the THP was concurrently split, the entry at the ne=
w offset<br>
&gt; &gt; is a node pointer, so xas_find() descends into it and returns the=
 folio at<br>
&gt; &gt; the backwards index. The caller (filemap_map_pages()) then calcul=
ates the<br>
&gt; &gt; PTE pointer based on this backwards index, resulting in an invali=
d memory<br>
&gt; &gt; access such as an out-of-bounds read or use-after-free on a page-=
table page<br>
&gt; &gt; freed via tlb_remove_table_rcu().<br>
&gt; &gt; <br>
&gt; &gt; To fix this, check if xas-&gt;xa_offset matches get_offset(xas-&g=
t;xa_index,<br>
&gt; &gt; xas-&gt;xa_node). If it does not and the node is a non-leaf node,=
 set<br>
&gt; &gt; xas-&gt;xa_offset to get_offset(xas-&gt;xa_index, xas-&gt;xa_node=
) before advancing.<br>
&gt; &gt; Also add test cases in test_xarray to verify xas_find() behavior =
when<br>
&gt; &gt; iterating over and splitting multi-index entries.<br>
&gt; <br>
&gt; Thanks.=C2=A0 But the changelog omits vital information: a description=
 of<br>
&gt; the userspace-visible runtime effects of the bug.<br>
&gt; <br>
&gt; &gt; Fixes: b803b42823d0 (&quot;xarray: Add XArray iterators&quot;)<br=
>
&gt; &gt; Assisted-by: Gemini:gemini-3.7-flash syzbot<br>
&gt; &gt; Reported-by: <a href=3D"mailto:syzbot%2Bb72767277f29b6407083@syzk=
aller.appspotmail.com" target=3D"_blank">syzbot+b72767277f29b6407083@syzkal=
ler.appspotmail.com</a><br>
&gt; &gt; Closes: <a href=3D"https://syzkaller.appspot.com/bug?extid=3Db727=
67277f29b6407083" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.ap=
pspot.com/bug?extid=3Db72767277f29b6407083</a><br>
&gt; <br>
&gt; I see from there that it was a use-after-free, detected by KASAN.=C2=
=A0 I&#39;ll<br>
&gt; update the changelog and I&#39;ll add cc:stable.<br>
&gt; <br>
&gt; I&#39;ll queue the patch for testing while awaiting review input.<br>
<br>
The testing shows there are issues with this patch:<br>
<br>
<a href=3D"https://github.com/linux-mm/linux-mm/actions/runs/33815757662/jo=
b/100847425973" rel=3D"noreferrer" target=3D"_blank">https://github.com/lin=
ux-mm/linux-mm/actions/runs/33815757662/job/100847425973</a><br>
<br>
And since it&#39;s in mm-unstable now it breaks all CI jobs :(<br>
<br>
&gt; &gt; Link: <a href=3D"https://syzkaller.appspot.com/ai_job?id=3Da01c56=
bd-74d0-411c-afb4-ee6f0cb6cb61" rel=3D"noreferrer" target=3D"_blank">https:=
//syzkaller.appspot.com/ai_job?id=3Da01c56bd-74d0-411c-afb4-ee6f0cb6cb61</a=
><br>
&gt; <br>
&gt; <br>
<br>
-- <br>
Sincerely yours,<br>
Mike.<br>
</blockquote></div>

--00000000000063ac95065aa43eef--

