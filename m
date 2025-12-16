Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29530D5B87E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529896B0088; Mon, 15 Dec 2025 20:17:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D73B6B0089; Mon, 15 Dec 2025 20:17:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABE26B008A; Mon, 15 Dec 2025 20:17:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210CC6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:17:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D275358874
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:17:24 +0000 (UTC)
X-FDA: 84223571208.10.BCD32A0
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id D272D1A0015
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:17:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WEHUZy1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765847842; a=rsa-sha256;
	cv=pass;
	b=f9XBpPeDX0V/w2CzbreBXfF19qHclW33t4GqEK2qi4fwGvgK6YiebfIIkG1qu2pET9o0Fa
	CejIlBw4bRywZ36AtCxVBlUu7h1FnIADDVKoP3lHMiMvnjsPypvbPt8orB99zgLloiOefX
	0og7VBmQan+LV4jP2Txr9S29hQ9BjfE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WEHUZy1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765847842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbFbdTrPL+zHHvbo9Ao63+CEQRJzq/44EGC+9mjFlL4=;
	b=K35TaBpNlhGUJVldlnBPv9rVb6kd0ZqgMsU8OD7nU7cTI64DRjH4rtPFM6kJAp2uw9tiPk
	D61y53McQsjg9y3LyKWKy/GgLA+EOcflovTRlL8LxyrBM+Nt7LhqCgWGoZr+tinA7HiGuk
	QqGCjJL2gZMi/BRk6VRZt74KQekXeCE=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f02651fccso45615ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:17:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765847842; cv=none;
        d=google.com; s=arc-20240605;
        b=TS73xgatkSrGqu7FqyOLvy4S4jT9nOiNfPylYKCTJZKnVBxQrjBRrqXKd48ZejnqJz
         pJBMDGQiDok93xg+Lgwf2VRtg25jytNeVR6DUTO+/ZdOLQ1qZDMb8y5spz3J8gSUHTVg
         thCyc+xKqu/ykUHBTfCuS+uDHRtHNAbw3g20kcXsGq+Js73hwIFVw+KL4dI0pPriy9g7
         /FNm1Ybb1FvQio7P+CgH4L/HCxldvmuyTCMCrNKukPSod1kpXIb5dc1A2x0LDQEyAt7h
         ddgnOvs2qMA2SM0lapCuuXxvYnqtqDXEESq//FF//yTspiUIPeTKWwsIIds4EP1L5lQR
         Sy0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vbFbdTrPL+zHHvbo9Ao63+CEQRJzq/44EGC+9mjFlL4=;
        fh=qxAuGFfjZ3wJs5rWSnBh6ocSSdOObZ7ubVSMDyim5ac=;
        b=bdwEejIJ1NSqr3bWLCpER9am/ztLc5o2Wo0AbxwgOym2jbLLJHeyywFuDXw14fQ4Ff
         VW9JrxfGtntBuLIoP5hVKyTwkiLKwQ5NrO8GVbVfPKGWLNYWxLiZlgKADDaPsbklcrX9
         7uTbed+OjCuYL3YHqXWlYzXNnEQHtKLmEYsX7pC7oGb4UL4kEw/PzUJfE/E0XLcQqe4Z
         UWpbG+udJHVWaZvbLnb+a74c+nQdLTKJy5m18D8BhnToEbqNHLedMCpf+BBZk38CzHHW
         SkOdvOrovcPZ/wNERhGdoEGeMYuirSL6XxjbsHf1Sfjs4Vj9tcgrP9mLM/Ojc3YXJ3h2
         Bhug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765847842; x=1766452642; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vbFbdTrPL+zHHvbo9Ao63+CEQRJzq/44EGC+9mjFlL4=;
        b=WEHUZy1LH/lwGoZU5Q09lx6iGAh2bfC8OZVjt86zbr4ii6kFaKUroDLF1iawvW+KNE
         SU7+9bGxNAzXkCPGFZTN0mycWwbY2kGOAsLGKME3z6BWDh848QLagZUuNQFxOZuhDCZr
         V4SM/sC8Tzt7Ao0msBgZH35eDhUJhZ7M0xX+kivjqL2S2t8euPpR34hIAeGkF6D2vEKW
         fUutKF72ZxHWkZud6AOabhYSeMfID7HRkbi5hWal13atsjKwO9Yv5sb6OwkTfYpyxPf0
         KGD3P8SNu3V9kKHodXWnIFvIEPRddUsr+EepDWmzqz1DGDX/NyNwU7VwfQhCQ1ymFxP/
         nWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765847842; x=1766452642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbFbdTrPL+zHHvbo9Ao63+CEQRJzq/44EGC+9mjFlL4=;
        b=lOP+nLOZpgUl5R2NLsi8iSyM6tB/WnqdNibAl1uCnxs1G+vE4LnJXlyNcCFJkFvLzV
         /fDdlrgASrJbVx9350X0yADUw/IhYGEM3/Rf6aVsD3O1fzaQZLZAc6dQLO9s1+vwY1og
         A115vGwKkJqED8E1hw4QuPPtxLKI8JdGwpBBTdEPiAHtVvbTWmXjk72Em2FAWf6Eey1v
         yD60c1vcc3aO1uNkv2q0IKq6skKsGBN69Mc5b/tisf/2u0L6ZXuVDED/Q09TsCOiuxrV
         A3VdFRbN90pOAchR60vUu9jFjUXMQpnqaz7Om7fzSBdW+GZSuWudUskxpTUKpPjxULIS
         +S3A==
X-Forwarded-Encrypted: i=1; AJvYcCWStzaVPLwwtv+D/DyUJEThGIoP3ytZ6ZLjtmichbHPLX8AHd4yLOS6De+FhrhQYimPYX01D9I9BA==@kvack.org
X-Gm-Message-State: AOJu0Ywbuym3+Vo+EJA4SpAQ9HWnCfGjEifB/1I7WTdOye5KhAj4yglc
	CcFpLlgBdtb7UIqL5kxY0iyduY0QgVdPFO5a22VEyEDSaYzs6DSeiaaR0xQ1Fk9+t9/7tUskE/m
	P8HPFpbxC734wqhZqy510zlWuxRw4W5Y0u3RgJ9bw
X-Gm-Gg: AY/fxX69Bp5p3gy4fMn9nAFrB4IJDF3mT46bCU+xFzEgvwox04fofXXHr6RaUK5YvrC
	JYYmYb9zdImmaJ1UTVDWYlnVwvECao6VM9tWGmeTvd3lqkyc3QsHYjCOlGlhPxGH/2yEIlNNF57
	ozPpAATRV7ft0omR5XwdW2AYUBZRf0PkBAshoUv9Bu9+BkcOEcYjHocBBnb5Uj+HLkwcWKB8NvX
	QstfWG/HYTCLbD5WOXYyVNznJuysQHlFJnSHaSNRbi6+f3jSkoS1JBlicmCik3trKdreLlPxCvW
	3GRJjXd0hKiK/LemfIYGUW4a2PAUep9YeOvHvbSIV7/HMOInMG33+9W44NMbfB7bEQ==
X-Google-Smtp-Source: AGHT+IFfFvvlvSzJRmMaDHuC8g+hgFF0qsHURCatE8P0OHJ3/6ojbrwq9tJQqZT78Gpjybi2YpgMk8C9ZNGeHyk5sMw=
X-Received: by 2002:a17:902:d489:b0:29f:2563:7772 with SMTP id
 d9443c01a7336-2a13daa1a78mr4235ad.8.1765847841115; Mon, 15 Dec 2025 17:17:21
 -0800 (PST)
MIME-Version: 1.0
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
 <CADyq12zu_o1fEz2B0nrZUFhbnEgiLPVkJv4ku5mrXYNBBNQ-Dg@mail.gmail.com> <gqkugg2q3hafwikx2wvnsh6oa44ifbtuskmigsqbrkaztjwj4i@33n5p55zq3nz>
In-Reply-To: <gqkugg2q3hafwikx2wvnsh6oa44ifbtuskmigsqbrkaztjwj4i@33n5p55zq3nz>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 15 Dec 2025 20:17:10 -0500
X-Gm-Features: AQt7F2rYjy1mnY-s_SBQeBi-9hwD0iecnZWt6xqvvF04OeHZMj-MXTC8NcLpyAk
Message-ID: <CADyq12wk_Ac-iinF=LEkzrwcu5-8FnVBXODX6GC4BjxxF2TBvQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] zram: use u32 for entry ac_time tracking
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	David Stevens <stevensd@google.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-block@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000004ccff30646077d15"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D272D1A0015
X-Stat-Signature: uhofm8duad78n1u6r8io9ybrd3qs7yjk
X-Rspam-User: 
X-HE-Tag: 1765847842-228148
X-HE-Meta: U2FsdGVkX19URsX4yyQ9yR2j9j+Vfn4zuspcOCZvnThcOMGKNkzEgbYPt8/m0fb3KVqiKdc67jpuSP+87xjHyKOJUsJPip105A6mF7jBeVTF9eBSFhJMfweS4sCr+ii0Gzly2jOHyj9r7f13MnMqkQDzCmm5Q20SGMZ/bIy+n0Xt6NLTJvymSkNDuGZ8Bl3V3yPSiTudAOzE6WkC4/CmXi24w/5ACdacNn7UxjGM0D94GSXn0M4hhDGitrHqtV61PpaxGrq4igbDdvPynyzEvUkHQWCR1HJUYG4AI9qGVBHOa1Ra9iBmWvvC/IjqUtQxAw+1nsipcby+kObj6KDowrI75LB+yBBWIf3QVMYHSiaRS40Go+jAwHRZL2WXt/Zg5m048HAOirjsfY5nwm734jZjYDXkpPSHYs9bi8HeXi+44GOqwEYZf47vLv3ZXM407BoMx2FFG1LJMjY8hvIrACbamx/hhiwonW33N6vSDlPVhtjGjOizhGTUW821f6Judu8xJATa6ojlXq0jKNe6j2NO0OiKVn/MdWZvcg4zHr1olrfse9uohbttqbuBHjPoxBVcgJ7VEddRW78U3vi1mRzINfuBwaJvzkUqxSs/ulJKgJ91Gp42o//jwN5SdFQtWzZQQnL+as9eTQjw7FEOZeti6myy8EAB7bDRejBdZOx1cl6dRI1aHLS3xcVb76v3oDLNkYhHv082V36BgQQgHW6zVKx5Bb61y7KkJsJ7EJOcuyURqzZs4AAkHCD9osIQm/3N1PRz4w7pC6v+mybMlI29awHEY9S/XMsRBbtIdmC86Sq19hYziuhikUji65zZT42aaEqL2o2qK0hbRTHO51yeCORr0Q0Ta01XxcodwaecDLDFlbag/zHvusnOp9Z/z/RHTnqjpqH/EEdRfassjuDejWxrLGNqXVmoGPOVnjfUE3A/b2CW1mbWYKdUF9IohCAxBKMJgKIt9CAMZBx
 cbAuFSa5
 JAlGX/IUdxhfTEqyVUnBQIdWy7n+o/SB4m9gjqRjjc+zO6nsVuqUHYu8GbPYB3uFDwIuAp8yBc2lfMY6whn7ookzYrihYc38dhNxrqgyCgj5GkecBO8xzJdrhkUwc9rpyLAtizF2ljGGOzDuBz+/We4ip0QkWwfr3ldxSO2TBQLzOTqDk0Vm4+w8tPp/pnlw21G2hF0rrjsqN8dKxqsJtpWcGTkJxwWddO4UoGKVs88voJM75RR3spCeWyiIeCcrDSt22rHXIAAAYENIh/+HyMfle4Je7bQ27buxLn+wNHhVdJ3CwP8HRyNmmiKx+uYLWxU3JBjf+gg+UCuJTc4agDluupO555kum42A7KlvvNda1YD8YRuqPmC8q0y8U0Rr3VnC0wcRyQyt+pGZlzRpvrZkuxSQtCFv9/1Vp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000004ccff30646077d15
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 15, 2025, 19:59 Sergey Senozhatsky <senozhatsky@chromium.org>
wrote:

> On (25/12/15 17:31), Brian Geffon wrote:
> [..]
> > >  struct zram_table_entry {
> > >         unsigned long handle;
> > > -       unsigned long flags;
> > > +       union {
> > > +               unsigned long __lock;
> > > +               struct attr {
> > > +                       u32 flags;
> > >  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> > > -       ktime_t ac_time;
> > > +                       u32 ac_time;
> > >  #endif
> >
> > Why not just always enable CONFIG_ZRAM_TRACK_ENTRY_ACTIME now that it
> > doesn't consume any additional space?
>
> It's "free" only on x64.  On 32bit systems the removal of
> ZRAM_TRACK_ENTRY_ACTIME will unconditionally add 4 bytes
> per zram_table_entry.
>

Yes thanks true. Sounds good to me.


> > Also, why can't we do this with a single unsigned long flags
> > as before and have a simple method that isolates and casts the
> > lower 32bits as a u32?
>
> There are no upper and lower 32 bits in unsigned long on 32bit systems.
>

--0000000000004ccff30646077d15
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote gmail_quote_contai=
ner"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Dec 15, 2025, 19:59 Serg=
ey Senozhatsky &lt;<a href=3D"mailto:senozhatsky@chromium.org">senozhatsky@=
chromium.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">On (25/12/15 17:31), Brian Geffon wrote:<br>
[..]<br>
&gt; &gt;=C2=A0 struct zram_table_entry {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long handle;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long flags;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0union {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
long __lock;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct at=
tr {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0u32 flags;<br>
&gt; &gt;=C2=A0 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ktime_t ac_time;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0u32 ac_time;<br>
&gt; &gt;=C2=A0 #endif<br>
&gt; <br>
&gt; Why not just always enable CONFIG_ZRAM_TRACK_ENTRY_ACTIME now that it<=
br>
&gt; doesn&#39;t consume any additional space?<br>
<br>
It&#39;s &quot;free&quot; only on x64.=C2=A0 On 32bit systems the removal o=
f<br>
ZRAM_TRACK_ENTRY_ACTIME will unconditionally add 4 bytes<br>
per zram_table_entry.<br></blockquote></div></div><div dir=3D"auto"><br></d=
iv><div dir=3D"auto">Yes thanks true. Sounds good to me.</div><div dir=3D"a=
uto"><br></div><div dir=3D"auto"><div class=3D"gmail_quote gmail_quote_cont=
ainer"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt; Also, why can&#39;t we do this with a single unsigned long flags<br>
&gt; as before and have a simple method that isolates and casts the<br>
&gt; lower 32bits as a u32?<br>
<br>
There are no upper and lower 32 bits in unsigned long on 32bit systems.<br>
</blockquote></div></div></div>

--0000000000004ccff30646077d15--

