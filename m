Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44B1606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FTEfOe7a
Received: by kanga.kvack.org (Postfix)
	id B0E046B0467; Tue, 20 Oct 2026 06:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE946B0468; Tue, 20 Oct 2026 06:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AD116B0469; Tue, 20 Oct 2026 06:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 752EF6B0467
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:00:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E164A0973
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:00:20 +0000 (UTC)
X-FDA: 85342559400.30.C55A7A1
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20ABEA0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:00:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FTEfOe7a;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ngocquy0700@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=ngocquy0700@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792490418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRG+niaM/RLVwmoMYr9HgdIDCEh4eOSBv2P+DEP25c0=;
	b=77OBkX9emBbxjvgbYEXAwLK5cZhq/HsHMZfZ3KsKlufb5vmPVNAq8dx1J1X1vc9pseH8Od
	phl6BWQvdATUMGiAR/Yd1U0BqT6Qth+pLqPDokq7J6jqldlvRGkwg0X259HVzOCHTIPvaH
	9tiMc+yYWYI9iK3lIlViW1ho6AVVxgQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FTEfOe7a;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ngocquy0700@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=ngocquy0700@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792490418;
	b=YgpghUIwYIwI4n7jB4qXBPhOzIUq7HUfwsSaLEFadQcw90Mr/2Wpa8ACzq/0U7fb812gAz
	UjyhS4W0IeHM+XJa4M/CKMsuip1095ez9R4nxuYofnx9TMi8uSrWjh1KpJDjS97xl7HIUD
	3I1lpPvtmHikCbJVt4hiCc5axcG9ozQ=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-46556b9e02cso378886fac.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792490417; cv=none;
        d=google.com; s=arc-20260327;
        b=TEY1VpKqPTdBwO+/8kUPoklRc7tuT78TXq3Y/xb/1x2G0pUzSSIL5B9wd20yqbmIJ3
         qcJdJdj5IH/MCfMURKKUtXHZjby9nFfNaRgsznbBPT8xbqEWizCezsK736uKkaFklPfb
         8iLv32KjU/SpUVWBd2aykWHLxGHpJPcUHXBxDMlnCPDdVYiLfblvRLgx0Vnb6oz/JbuQ
         ovkrg06lcPrK3A9WJTwuGNbQZUqU1s6MvGv4tKjyt/dNFVXjEp7Rjcz7+Vt9lA5rOV+4
         /i/RJv/Uq0IaXvw3o3anNWMDxpTu8DCBQG8b6LL5nq9W+Gax+oU9DVZ7ExxDSF6w4IzK
         wmIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cRG+niaM/RLVwmoMYr9HgdIDCEh4eOSBv2P+DEP25c0=;
        fh=ReY8BRz7EidavpHbSkm9XLC/+5AOOxReqmAtsIwN3SQ=;
        b=mljN93ZT2FtiuvdILe50W3K/t9JnO4D8+SuYJ54oFt5G5lifvsMSFr4Lk2qYWdZmTq
         sQKzKWKCfqEmSJSSNUYGzfCaV9Z3zvCiBZ4itNdL3YrL5CE2VLZLTEF8aqT/tta3g8oM
         cvqbAVVGRfLGRqHAQ6FkIKk16nUu5mRKoidSo3PVD5nQMjegoq1JWmuKrYsqk8YPxvH9
         FHzLm2Oy301H9k3dx2MBhwhH6+bW9sRfOQfvsPPYzRkfEmMpqVIIdYNH2BnlDUmEXG3L
         718RfUlNySpDWK/sQuUQOnGeuU+BHxkVC1q9AVVKo3Ej6Rt1f3stHb7I+NRFN0zCfU2r
         LkZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792490417; x=1793095217; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cRG+niaM/RLVwmoMYr9HgdIDCEh4eOSBv2P+DEP25c0=;
        b=FTEfOe7aSWrUu0A4aWPJupwKQZq4mwwdE7lXxomErRYtECxBUv4q1ENcXv9bUrkbjO
         Ek00ZciY/tMPtckccU/GS5p71P+84ZzkjrKLp9YYKrMbPxjeCofVCA+gXteJoQBxRhtn
         u6Wna0fthW7ilDNAPo7tG0MInWqaHzyZn88N9H+3pCboIcLooj7/RecRg+pDybUKVUqt
         F2KmGw6RLg8Gympdpa9NG6ewtEuMuNfAxa6HL3c4+VYjvsk7PooJAMJqZCXllbVN+dOX
         rS90ZkLo1U6pNe8ttz8xVmIyzZxmH7JvalJRQqq0Ckhf4LT5pxsgNCdpPwK52qUa4e3G
         eZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792490417; x=1793095217;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cRG+niaM/RLVwmoMYr9HgdIDCEh4eOSBv2P+DEP25c0=;
        b=PkRk0qozbVHvC1zz6C104AJHoOQbmwbaCUWU9MF3cridxAUbKHaQ4jXvNBmBF20aNe
         0KjDNWyqOadyMRi4pf7+TnQVZjVdO3yDNPI7EsOGT+jShKK3CufK1mhQuZREFsjOwoBS
         X9AF9KwixV46cKAJ33exsrn5S2V57CH0zwE8u+pO7EgUe3vQ4fDycvopW880kaUre9Ms
         4BfTKUj8UYU1eNbmf4WPcjQiiCAKbQRHyuoARPA2PmLkJU9so74xc8//ciTplaDogls2
         SUQdHFRipjAiv28A4/0p6+s2D4s6tWWhbRz3nmTjptTWRWISdLBcObEcYsfzGI41bHkp
         KwLQ==
X-Forwarded-Encrypted: i=1; AKwUvByzV4i6J/J2a24yW8+kia0/2mRnp4AeDYW2LnY2/fSSV8envnAcbQABF1GRFu6qokNu2BNX3x/OMg==@kvack.org
X-Gm-Message-State: AFq9FYK1HktqOsyMgdbqlqt2XOzx4znY1CMuVE+XCaMW3irzyjixSJyD
	D3sCrQsEptmJis+SU8qr34NF0mGenKMswWg11Smpwm2WvslqR8eD9EYMJAfoD2n9BgOHDjjVjrm
	MHzxG8VSVZ1poNxJhmxTBkIc2OMNiw8k=
X-Gm-Gg: AYBFou3pqms6R+F4MAtv96tZ5iWzgTJus+hIXsN6uCyPCVk/xAW5cPbUL/ROEZS+Hlv
	qrtvSta7rfoo2TMFbhFjHDSgL4oijw/YGeL0966OQQQ9t5lQb25GGuNApWESqP+fSSDVbISEJZr
	rdqxL/aWlzT9E35E6ZYSjyivRi/N6Me93N/0PPB2VFDGnBxteTxP0NSWtQ/se177yulcMUv6fnl
	aZQ8kPlongNQGiofVyMsyJFoxoH706Zm/ATteb8cLiqtg9PcV0mJAN88B2tblxvTu3A8pAAm5Du
	xcIpeJmdxgbcdlYNwWYV5eUl6K05kAvuYeNiF3SnTGArjn4+9zCDCv1ndv4lug7JGoOLbSQniMV
	XP5HD2eAipH0=
X-Received: by 2002:a05:6870:7389:b0:4a2:4e0c:5964 with SMTP id
 586e51a60fabf-4a7baa3c653mr881438fac.18.1792490416692; Tue, 20 Oct 2026
 03:00:16 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261014095540.3261469-1-ngocquy0700@gmail.com> <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
In-Reply-To: <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
From: =?UTF-8?B?Tmfhu41jIFF1w70=?= <ngocquy0700@gmail.com>
Date: Tue, 20 Oct 2026 17:00:05 +0700
X-Gm-Features: AclHuK9ZZ26UfjNxCfvhB3TsKqNb_GsiJpyG7ykLcUMZwCu2MO9en7mPrSv29nw
Message-ID: <CA+4X5ouObi3DTfrDtMsVyCVRxD6dvoQV9zWdofpMoLJkm8ZmNA@mail.gmail.com>
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liam@infradead.org, ljs@kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000008ce223065e42b267"
X-Rspamd-Queue-Id: 20ABEA0008
X-Stat-Signature: e836cg4gdxbd9nw4iztrady1jnwcxpxt
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792490417-78047
X-HE-Meta: U2FsdGVkX1+Y1IonxVzJkKzYDx8Tpj8ijHZQ6302OB5Jp3tD36JC3JaEAhRDTzOcKB9lrM32qHdxN8fXIL1Q7+kcVJXYuFm9Jvd52ECOXpDg4BCeO6WAbGHoL7GvqdPch3jk+D7liRlTGEE9hvWO7UErEkPu0UlvTbW0zBYdg8NQKW4ofMJx6kE9JEfW404SpiCn0Ei7qyD3uF6rwrSNpUI+DR2bbbyioUhPYnJOkRXuc9vAcqQaYLFdvyhXeOGu6kJ6knyhiCfrIB9IkOTHuIrezGqBGc39xHZPywLsq6VjvbUk5rFwTDW6dELN6Qkk6retACh/IIUsB4Y9sNQGMeGYwQfBHj2SGMCZapWR8XKmY3hxecSr0a7bIcW6+RGnLeypGLpQUC++exjOpMCh6bwHtqVhkpvapHbUXCN5eACoHaLm/3ZZ4Dv0v7Fp/5dB1q/sDQHh2osdECSDM9v6zmrDBXtlySMCzdJV8fU5GQGmeBr/CqNrJ48LTp0SC1Fj0350JBIUNnyB0hljtrOpxmDz3HpIqptHg3WH4Kn4UlmQDesZ4i0YFcbSwTmgw5cd1flBK8sDhMWUqo+NB0KGTHO4L1G4pmBFBaLi5BuXS1cpJluSpiqOTq7WDDgqijrQRHYmwWQE80btFq/RF7ckjBrF610Pv++eulxhHGbby5znsPvblJNzC2Hoy7C5/Z81buTsSmW1qKh48JytL+OXgOiqQqA/Boc5nwQblPyCr1m8fJ+JjnkPZdAt+vWqkSAWp5Ng0DXvXEXVnPR+UtwterriF8dPEwgMxhlD99xFDWmhet6wvv+Xa6fR01zY8DTdG9Nh70GEiuQkXQMKYzuHanLAjwgKgb5U4IRhPFjUqbRkvEDdOK1pH17eMt9myYvchsii7Q8uFl8V/uKM4OTxKWOg049Gykz/33z0lkWlkNywBsTGStdcMax9BDY+sys0hYqnrg3OFo4O4O7VuWP
 1XoknOfX
 9dj9OGtUweXUgKXy52+U6F+HdgXg12oE9q2qRfimklmgLD8bm8x9d/6teimJWX3ZOsYC0ILuG+b3IfMA1W8RiO9RwRd5UMXjwaX070jsroaMScuFPBKd97d67hy/ca8bgVYfJhgzS67NAdxkVq4SADA8h9AYC7sme88+2vL1qByrvK6JF5UjgklafDiqEbe9guXJT98iPMixqDjoaN8/+pfPsRzq3KXoDaEfEj2ZJte0g7SyHGBsEduRcfswH1WpOKEVzCr408Y1ze/ANVI/oMIq4Eg8GWA0KAG35F6P4OxmR/F6agSNlDy5/qT91pnp/gAkCNXMC4CwT/4Je7sJluH09dAEcdV7fFUG2r60thr3OukJ0qwtBSYEljxD2G88xLMXRw9W7vROPaskH0F7M2RgOMUzWJHdc7KlMFQeSIeR3Axjzrrq+ht/b97+QVblAaMNB2yMyGF4kHBXxA6SkpQOBZaytyBmWmX/KaRWs+WwFYxoGzqvd2gFHkHmrx36DuALVzbfOCj9nIvr/PyKq7YGWyOxNciTO6XGgRGdK0r7BnHMlFGrAfk04meA/QKNCa81P+lp+kkL2sZgCBrNYi5veHL8v5vme0juQfFlKvyto4w0uE7bD/AAv0Do4pfbFVUELTK3VbwLx6WJmUYDktcSyJsca7KEmsKBp7iWdAO2YY8w2fYwcaWVr8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000008ce223065e42b267
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 20, 2026 at 07:47, Andrew Morton <akpm@linux-foundation.org>
wrote:

>
> > > +     if (!mm || !mmget_not_zero(mm))
> > > +             return -ESRCH;
> >
> > Why the new test for !mm?  The current call chain guarantees this is a
> > cant-happen and the current do_pagemap_scan will cheerfully oops if
> > mm==NULL.
> >
> > If we start getting mm==NULL passed into the function then we want to
> > know why, and an oops is a good way of bringing attention, Quietly
> > accepting it reduces our ability to find stuff we did wrong,


Thanks for the feedback.

pagemap_open() rejects NULL with IS_ERR_OR_NULL(), so mm cannot be NULL
by the time do_pagemap_scan() runs. I had copied the !mm form from the
other consumers in the file without noticing that m_start()'s open path
tests only IS_ERR() and so can genuinely see NULL, while the pagemap one
cannot.

--0000000000008ce223065e42b267
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><span style=3D"backgroun=
d-color:transparent">On Tue, Oct 20, 2026 at 07:47, Andrew Morton &lt;</spa=
n><a href=3D"mailto:akpm@linux-foundation.org" target=3D"_blank" style=3D"b=
ackground-color:transparent">akpm@linux-foundation.org</a><span style=3D"ba=
ckground-color:transparent">&gt; wrote:</span></div><div class=3D"gmail_quo=
te"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
&gt; &gt; + =C2=A0 =C2=A0 if (!mm || !mmget_not_zero(mm))<br>&gt; &gt; + =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ESRCH;<br>&gt;<br>&gt; Wh=
y the new test for !mm?=C2=A0 The current call chain guarantees this is a<b=
r>&gt; cant-happen and the current do_pagemap_scan will cheerfully oops if<=
br>&gt; mm=3D=3DNULL.<br>&gt;<br>&gt; If we start getting mm=3D=3DNULL pass=
ed into the function then we want to<br>&gt; know why, and an oops is a goo=
d way of bringing attention, Quietly<br>&gt; accepting it reduces our abili=
ty to find stuff we did wrong,</blockquote><div><br><span style=3D"backgrou=
nd-color:transparent">Thanks for the feedback.</span></div><br>pagemap_open=
() rejects NULL with IS_ERR_OR_NULL(), so mm cannot be NULL<br>by the time =
do_pagemap_scan() runs. I had copied the !mm form from the<br>other consume=
rs in the file without noticing that m_start()&#39;s open path<br>tests onl=
y IS_ERR() and so can genuinely see NULL, while the pagemap one<br>cannot.<=
br></div></div>
</div>

--0000000000008ce223065e42b267--

