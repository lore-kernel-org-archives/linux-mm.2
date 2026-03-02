Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3347AEB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C20D6B0150; Mon,  2 Mar 2026 15:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9702E6B0152; Mon,  2 Mar 2026 15:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843C96B0165; Mon,  2 Mar 2026 15:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 715616B0150
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:54:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C17D8AC9F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:54:29 +0000 (UTC)
X-FDA: 84502326258.09.72E2859
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id E33DD14000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:54:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=S1YUcnia;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	spf=pass (imf26.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AlL7vxhF7VSYqxJZCFwPUyAPRS/ACVmqb7MXIrqcNg=;
	b=TU0iec0vtTT1K7Vd+7eQoqnd3J9dgrzMtzHyDf02C7MzAnBbTeeeOEBsE7BydOMTtHoNIS
	7hLSKPV1c8ZENEH3fB/AM+3i3Mn9OQ7rVvY3md3M2XSN4I1AAeBW9Nqpbp5Bitp8eV8Gn6
	Ri3a6NlGlCOgiApQapQvOu2uPtn3MhE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772484867; a=rsa-sha256;
	cv=pass;
	b=2mSaPgfOWiLFnpCP+dKgAXtuRPuZcTxr2DiUZr0or94eeUe4ExGdbIpuG0HZtSyhpUlBJB
	Pwra6mqAIg+X8qglJqTQDjZNLIfrQF2Ec5XVnm82GnFZi/uRgKxAmc7z+sqykuHxal8gSU
	N0bXy5WwzwCGMGaCAa/9t1oI978pjVk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=S1YUcnia;
	dmarc=pass (policy=reject) header.from=dfinity.org;
	spf=pass (imf26.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c187dfc82so7797738a12.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 12:54:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772484865; cv=none;
        d=google.com; s=arc-20240605;
        b=MAS7FaClB4pLrRZK66o9RJhOMd1Tb41IyGReQl/MVYjK6y2ms4OUHgwhop6q/cZ6qa
         jEZMkY7LhczGcNvPyx2Od5Zv4XSGZ5Lkh3hrQQ2cRxhRQxcfUfFHz4uXJxB76r1P7KWo
         7lxbGCwQngWlwAloSISvk1r4TPoiFwTBSplQx5ixMkOtV/61wBd3+KsGv82j0kZrPjxf
         Di1Lfm7xbdmT499GABnMq4sveySOF7lj9x5ViRy75/XgYBOsueK3fvv3fbGG8vG0QVyh
         3vvoYKxayzCm7Dkcqr5IIicNeFHrOTwcjrvATnsUpe5bB1n4m0R1LSKrwtTo93ZUOI4c
         ic9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3AlL7vxhF7VSYqxJZCFwPUyAPRS/ACVmqb7MXIrqcNg=;
        fh=B98T2+BSPEumyTmaGkNYzjHxhv9W302ARZd3C7ulAUA=;
        b=AzIs0tbCGXYEAs+ygp6TCHRy5LA7qT483Q2J3hyW59xk/jnCW0N5RcP/2DtvIVJRBO
         AUrW9YrHZPzXXIUStaK5Zk3bJFjkUPszfablenxoAZErnhkiu5Y++o78YDqxne+Gnwux
         6iILTPM5g6pszOfAGr28qfmmIz0LtvJPwz6kMXw3akpRLy1EekgpLyacWnRhu/vyau+A
         JcjEVqG2jF8R0lNjCCFOFZ6/fZZ9IAB7npHXK2SEaq+umyBcL/9rnGdsHf4aYFMYtjaf
         ITRIpx3w1HFH13b06s9bXSBURpieVE6YpKE+yebddWMqmS5QmRoNuxR5d4vqCM8Ri3KV
         BzNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1772484865; x=1773089665; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3AlL7vxhF7VSYqxJZCFwPUyAPRS/ACVmqb7MXIrqcNg=;
        b=S1YUcniamQK63khd/bMRGPQyFD41NmuDt1dEef7TLXkm7sK08D9WAt7NkTAfbw1I74
         sVZKCcYvZKoP7SwBI7YV7WmCG251XGi0/IrPvJDXh79SvFmHzDhNq2J7yx7DkXxPu4FW
         QxMblSxgALJ7FZhiRIAn6gIPcryYoXVcSRjQhc1BxMxEmEQq0mAKSK3iggVUTXJnzMzy
         mYXNDM8p216L0QeTwTGP76XXIiCZltolDE7ufzo7jV3s7oBw/FDY5OVsfuf09Ose5Ko2
         BhaTxsx5DbgewThlQlPGi+fuEgeWC3nqMNbZ3piyco3clNGXAPkodmj6nAuQ4UQWKiK8
         Spmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772484865; x=1773089665;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AlL7vxhF7VSYqxJZCFwPUyAPRS/ACVmqb7MXIrqcNg=;
        b=IkJ4HpG4b9+ki/30h1jZatycGZ8aegq2/nvSSqX9jKUyNweq1ps6JpV4pjm9Dq/K6C
         L8K9Y+H/UAgs+iHYe0Inrl+C1Xc/rRl7g+qONTIaLkLqrXyBnhrCxcKbsy4o4PZ7v/oN
         wigKlkGSHnUmNBlkLgi7ugaNTnI9BCkJNJd5JINCThyRS3sJqoPxj8ZxB9hDTX+5M6Aj
         qQ7anr2d/5VLZO8wdthxWcUcBCkYifoX90fylvDp6+ehVaqXakIonFpxvJ4bVo5ke0GX
         j+Ezas3wkQLszW0Fot5C1NonVlqT6paXtbj+EppLdtdn+Gne7XGsgBM15PLObzapzBRc
         pi/A==
X-Forwarded-Encrypted: i=1; AJvYcCXsIzPYlnB2vH1x1p4rz5yIXvbsmVlfknQpj3ZTTVWz2X90/AGkMQ88e4g5crs316jnuV9OoopRYA==@kvack.org
X-Gm-Message-State: AOJu0Yy20FiC8QoxrteBGRsCwjjqPPGeOivC+KmpbvxOre7LMK7onaxU
	kzULTbPYsZtv+sNyk9To8iYo0XvkrcJTOwW78cyxszm3WS0wwbmicqX/dp6SUlIKLuBs8Xii4Mu
	1HYHkgpsisgLVBx1EtVXE2sHJ1mCVpQKyh5MEZyfVpBSFG1z4zfH9RIs=
X-Gm-Gg: ATEYQzxWPUtfMp3389B3JDjUC2Pj659bkSeKsOCtGE+2Q1WMLgW/szegBkkI1rW+e5D
	Cm5rivR9ScTdaUxGXkpWdYbaJtzQQjWvgrfLuZ5fU8Ex41I/GHfcdaUCl/LteazjADNBSiWYPyh
	7XNnmGvo1gb+BKmbuRYaLNpF9nNfUf5+fTJk9/RxKmH7OCC4DwtQ3Pe7f9MM4BkbrwxZS78q14r
	023dlvnOlGOHZPWvZ4GterSCQ7QGcimHymtBC2p3HvKJVotw7E6lo+7AQ/vg6e5Ph1/EmvIKuVr
	OAbP7aZ9
X-Received: by 2002:a05:6402:518c:b0:65f:9c21:e67f with SMTP id
 4fb4d7f45d1cf-65fddcebe06mr8272787a12.20.1772484865079; Mon, 02 Mar 2026
 12:54:25 -0800 (PST)
MIME-Version: 1.0
References: <20260228010614.2536430-1-ziy@nvidia.com> <d9e30bef-621f-444a-a1b0-510c50927d9b@linux.dev>
 <64fa6a73-8952-4ee1-b7c3-8b0ebef3ea78@kernel.org> <6a568d3c-daf3-46ba-a3ce-0a0deca824c2@linux.dev>
 <A120B74B-D8E0-4810-B0AD-CC34ED7BFC9A@nvidia.com>
In-Reply-To: <A120B74B-D8E0-4810-B0AD-CC34ED7BFC9A@nvidia.com>
From: Bas van Dijk <bas@dfinity.org>
Date: Mon, 2 Mar 2026 21:54:14 +0100
X-Gm-Features: AaiRm51SEbyGo5nDIiNqDjwaKc7QeCbJ_ieH4NzIizD74X5p1Q0ZTsyaSK4UdJA
Message-ID: <CAKNNEtzE4f7QKJBw3F=SOLnLegVPHqLHbhMLs4L+2UbYxYM+Sg@mail.gmail.com>
Subject: Re: [External Sender] Re: [PATCH] mm/huge_memory: fix a folio_split()
 race condition with folio_try_get()
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Eero Kelly <eero.kelly@dfinity.org>, 
	Andrew Battat <andrew.battat@dfinity.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org, Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Content-Type: multipart/alternative; boundary="000000000000c0d958064c10ca42"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E33DD14000E
X-Stat-Signature: kfk5mr5cqgk7979iufs7qrqhcfnn7dbs
X-Rspam-User: 
X-HE-Tag: 1772484866-797701
X-HE-Meta: U2FsdGVkX1/0MUGSspyZmJ62OFE3cIxjeoR1zGFz3Y6/QdJU2hz9ivjuwygv9FcHqfxqKBTbvC6uJMozWfnTW3LW78DaSj/fB2w9Rmln0a0DtJ0vB9YWOQC8jwXO6E8+GPS2tmqEGMSfTyasxS3CEJmzlYpTyHX38IqpMHHyG6UOaOBdU5jhQPQtftXVbZgKoF/gCCSYCU/jkmtGSefPNHYDi5A6wyy7bFraFPx777fg3IcqyXwTbJEDSSx4tS6T1nN2KWqDOEXf4xg6Iif1CFxp5woxKWkFParbspi2krDG5smFCxVHPFwYlrhtNEofA0l58FHUO2L/P6cyuJpC0HgwhjwJNDDwYcW2uIJlCfY37eKD3WhghqdNARkeP6OB8+3EH+++r/7lxiEqvRrt01KQ5z3i8dvmQNC7fe2d0d4hU2zIOzXlRdhd4wX4R1lNe5p0ARIvHHc5wvJFV3uFRvw+tg3KMwidszfIHBAn25r+Qd4rhX50Z6hJKszRHwF2gaIzvwl6ELd6/A/SK7Ub7U7Jduy7S/XDbgCdDZ6f7SlEPPM46Isz9KpDOGwZymsvocfXLo7S2TU8KRYcy24ggzgavHEhywHqzsf2hKHFXYqNhjeHzVjyktcvjUn7+C59kku87rgwcGb3tuEWPzJrl2L7IKPtciTRxK4CAc7MJszBuJZ6nwYJnVSG+mGXYU44zr/2Ds6yU6TT4ZDt/QfHiIBeG1VJgoxeV9EVgXNpnykoCyCZn9fPy9pwIPdd4aNmkkDO8/2Wvh/7RyBWjMTew8TYl8SZmTG0NPfYHnL9NM02NqnyWTRVuqVb05AIcxWcihGrdDn03jRDILr7c9JIEiiRh861UmWoMoH1BSKhkPoiyjcLdoGVy1QPn/M7oJlsCnvNp4Kow84yPNnptSRC4UlJ661+24Ixg99dwm8U8xUAWSRPHYDU1SzF9SnM5b7GDeKzYJ2vdVim3iiyuLG
 U6/m4G3r
 xnjg6AGzzNfmvAZrhj+oHHDg8AXMSQjpMrznHVn/8lfI0pQ6oe9uAywWDhKMk+twDx9B9Tywr3VIzPhsfYp/wyKAZ4/PLs+LwtHizPZVqBcb9lCKWfFvc+yJ2Eky/7ITYx7BbJX9fb6PdysUvTy12qmYjaftsCJtoPtrOIKflKIFPcYqGM7/OMExUFYhYV3C7DCRDVqcHW9EfUdYJ9GBoZswV+WSmIceXY0HAVIhm7gw0nFVj+tFJuWNFAGxdIOTYwkEAsDVEwbjAsGT0mswOezn3r7JkfYFWgYBBecWx9wyZEJVfMmru90Q2Ztw1NTNIk50Nd/yFOGbS3OZQntDFdYGbBOq3avDSCEoV/b6FlyNnqBY+w6JSAGWFnbTSSBK4JsQAuFJOb7UazkkD/31VT8/qeHCsN5287+sNZm4h3lndNX2ojlbk9Rhux4NhhwxxZRcDxMuaogefukBvIEV76jyNxa9TlUVB9LPmGSjwovFxM/HlA+xvpq6CEEyObJcwmGDDKRmmEWdbIJtPybQMJnS+yW6FyxciIqYi3X27wUQglpwjIlgUFZOY9No8K1KGBX3FQcMnLolumfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c0d958064c10ca42
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yan,

For the record it was my colleague Adam Bratschi-Kaye (CCed) who wrote the
rust-based thp-madv-remove-test.

I don't have an issue if you include a C version as a kernel selftest. In
fact, it's a good idea to prevent this from regressing in the future.

Cheers,

Bas


On Mon, 2 Mar 2026, 17:37 Zi Yan, <ziy@nvidia.com> wrote:

> On 2 Mar 2026, at 10:11, Lance Yang wrote:
>
> > On 2026/3/2 22:28, David Hildenbrand (Arm) wrote:
> >> On 2/28/26 04:10, Lance Yang wrote:
> >>>
> >>>
> >>> On 2026/2/28 09:06, Zi Yan wrote:
> >>>> During a pagecache folio split, the values in the related xarray
> >>>> should not
> >>>> be changed from the original folio at xarray split time until all
> >>>> after-split folios are well formed and stored in the xarray. Current
> use
> >>>> of xas_try_split() in __split_unmapped_folio() lets some after-split
> >>>> folios
> >>>> show up at wrong indices in the xarray. When these misplaced
> after-split
> >>>> folios are unfrozen, before correct folios are stored via
> >>>> __xa_store(), and
> >>>> grabbed by folio_try_get(), they are returned to userspace at wrong
> file
> >>>> indices, causing data corruption.
> >>>>
> >>>> Fix it by using the original folio in xas_try_split() calls, so that
> >>>> folio_try_get() can get the right after-split folios after the
> original
> >>>> folio is unfrozen.
> >>>>
> >>>> Uniform split, split_huge_page*(), is not affected, since it uses
> >>>> xas_split_alloc() and xas_split() only once and stores the original
> folio
> >>>> in the xarray.
> >>>>
> >>>> Fixes below points to the commit introduces the code, but
> >>>> folio_split() is
> >>>> used in a later commit 7460b470a131f ("mm/truncate: use folio_split(=
)
> in
> >>>> truncate operation").
> >>>>
> >>>> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used)
> >>>> functions for folio_split()")
> >>>> Reported-by: Bas van Dijk <bas@dfinity.org>
> >>>> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-
> >>>> sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
> >>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>> Cc: <stable@vger.kernel.org>
> >>>> ---
> >>>
> >>> Thanks for the fix!
> >>>
> >>> I also made a C reproducer and tested this patch - the corruption
> >>> disappeared.
> >>
> >> Should we link that reproducer somehow from the patch description?
> >
> > Yes, the original reproducer provided by Bas is available here[1].
> >
> > Regarding the C reproducer, Zi plans to add it to selftests in a
> > follow-up patch (as we discussed off-list).
> >
> > [1] https://github.com/dfinity/thp-madv-remove-test
>
> Sure. I will add the reproducer link to the commit log.
>
>
> Hi Bas,
>
> I used Cursor to convert your rust-based thp-madv-remove-test to C.
> Do you have any concern if I add it to kernel=E2=80=99s selftests to chec=
k
> this race condition?
>
> Thanks.
>
>
> Best Regards,
> Yan, Zi
>

--000000000000c0d958064c10ca42
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>Hi Yan,</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">For the record it was my colleague Adam Bratschi-Kaye (CCed) who wro=
te the rust-based thp-madv-remove-test.=C2=A0</div><div dir=3D"auto"><br></=
div><div dir=3D"auto">I don&#39;t have an issue if you include a C version =
as a kernel selftest. In fact, it&#39;s a good idea to prevent this from re=
gressing in the future.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=
Cheers,</div><div dir=3D"auto"><br></div><div dir=3D"auto">Bas</div><div di=
r=3D"auto"><br><br><div class=3D"gmail_quote gmail_quote_container" dir=3D"=
auto"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 2 Mar 2026, 17:37 Zi Ya=
n, &lt;<a href=3D"mailto:ziy@nvidia.com">ziy@nvidia.com</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">On 2 Mar 2026, at 10:11, Lance Yang wro=
te:<br>
<br>
&gt; On 2026/3/2 22:28, David Hildenbrand (Arm) wrote:<br>
&gt;&gt; On 2/28/26 04:10, Lance Yang wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; On 2026/2/28 09:06, Zi Yan wrote:<br>
&gt;&gt;&gt;&gt; During a pagecache folio split, the values in the related =
xarray<br>
&gt;&gt;&gt;&gt; should not<br>
&gt;&gt;&gt;&gt; be changed from the original folio at xarray split time un=
til all<br>
&gt;&gt;&gt;&gt; after-split folios are well formed and stored in the xarra=
y. Current use<br>
&gt;&gt;&gt;&gt; of xas_try_split() in __split_unmapped_folio() lets some a=
fter-split<br>
&gt;&gt;&gt;&gt; folios<br>
&gt;&gt;&gt;&gt; show up at wrong indices in the xarray. When these misplac=
ed after-split<br>
&gt;&gt;&gt;&gt; folios are unfrozen, before correct folios are stored via<=
br>
&gt;&gt;&gt;&gt; __xa_store(), and<br>
&gt;&gt;&gt;&gt; grabbed by folio_try_get(), they are returned to userspace=
 at wrong file<br>
&gt;&gt;&gt;&gt; indices, causing data corruption.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Fix it by using the original folio in xas_try_split() call=
s, so that<br>
&gt;&gt;&gt;&gt; folio_try_get() can get the right after-split folios after=
 the original<br>
&gt;&gt;&gt;&gt; folio is unfrozen.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Uniform split, split_huge_page*(), is not affected, since =
it uses<br>
&gt;&gt;&gt;&gt; xas_split_alloc() and xas_split() only once and stores the=
 original folio<br>
&gt;&gt;&gt;&gt; in the xarray.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Fixes below points to the commit introduces the code, but<=
br>
&gt;&gt;&gt;&gt; folio_split() is<br>
&gt;&gt;&gt;&gt; used in a later commit 7460b470a131f (&quot;mm/truncate: u=
se folio_split() in<br>
&gt;&gt;&gt;&gt; truncate operation&quot;).<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Fixes: 00527733d0dc8 (&quot;mm/huge_memory: add two new (n=
ot yet used)<br>
&gt;&gt;&gt;&gt; functions for folio_split()&quot;)<br>
&gt;&gt;&gt;&gt; Reported-by: Bas van Dijk &lt;<a href=3D"mailto:bas@dfinit=
y.org" target=3D"_blank" rel=3D"noreferrer">bas@dfinity.org</a>&gt;<br>
&gt;&gt;&gt;&gt; Closes: <a href=3D"https://lore.kernel.org/all/CAKNNEtw5_k=
ZomhkugedKMPOG-" rel=3D"noreferrer noreferrer" target=3D"_blank">https://lo=
re.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-</a><br>
&gt;&gt;&gt;&gt; <a href=3D"http://sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com=
/" rel=3D"noreferrer noreferrer" target=3D"_blank">sxs5Q5OLumWJdiWXv+C9Yct0=
w@mail.gmail.com/</a><br>
&gt;&gt;&gt;&gt; Signed-off-by: Zi Yan &lt;<a href=3D"mailto:ziy@nvidia.com=
" target=3D"_blank" rel=3D"noreferrer">ziy@nvidia.com</a>&gt;<br>
&gt;&gt;&gt;&gt; Cc: &lt;<a href=3D"mailto:stable@vger.kernel.org" target=
=3D"_blank" rel=3D"noreferrer">stable@vger.kernel.org</a>&gt;<br>
&gt;&gt;&gt;&gt; ---<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Thanks for the fix!<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I also made a C reproducer and tested this patch - the corrupt=
ion<br>
&gt;&gt;&gt; disappeared.<br>
&gt;&gt;<br>
&gt;&gt; Should we link that reproducer somehow from the patch description?=
<br>
&gt;<br>
&gt; Yes, the original reproducer provided by Bas is available here[1].<br>
&gt;<br>
&gt; Regarding the C reproducer, Zi plans to add it to selftests in a<br>
&gt; follow-up patch (as we discussed off-list).<br>
&gt;<br>
&gt; [1] <a href=3D"https://github.com/dfinity/thp-madv-remove-test" rel=3D=
"noreferrer noreferrer" target=3D"_blank">https://github.com/dfinity/thp-ma=
dv-remove-test</a><br>
<br>
Sure. I will add the reproducer link to the commit log.<br>
<br>
<br>
Hi Bas,<br>
<br>
I used Cursor to convert your rust-based thp-madv-remove-test to C.<br>
Do you have any concern if I add it to kernel=E2=80=99s selftests to check<=
br>
this race condition?<br>
<br>
Thanks.<br>
<br>
<br>
Best Regards,<br>
Yan, Zi<br>
</blockquote></div></div></div>

--000000000000c0d958064c10ca42--

