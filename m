Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A22CACD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2B28E0008; Thu, 13 Nov 2025 12:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72D78E0002; Thu, 13 Nov 2025 12:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0068E0008; Thu, 13 Nov 2025 12:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B99008E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:02:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FC7513C035
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:02:32 +0000 (UTC)
X-FDA: 84106202544.16.76D4866
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 75A2140023
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:02:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RHKrX0eL;
	spf=pass (imf01.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIwv+CwuWqLYgHQJzqazscKZkTF1jtywZznxW87RPa0=;
	b=daNycPvtovkUWwAdQODXiTlTKycJuy5dSrpCWQNzo4ORnFWBaZqJei4zadlDLn5pM8pG0G
	964ul0KiK/7XIaUIF/4vbNKBezQn8k6f9ScwLvMT7s/afWpvjWjYQjYYs9Ncoc/LkvEW+c
	0b/uMliXMPNICAIZBkozH87DmisB6iU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RHKrX0eL;
	spf=pass (imf01.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053350; a=rsa-sha256;
	cv=none;
	b=bK7hYKe5v9cJe3zpZg20NFDIFLK6tiGSlTAXV26uI0S9GWHetGRZzZdYIA/hRyDFkUkwZM
	rZs0KmU+aCYSJiDRXv/k3n5v3r8fVDPTadthpbVgl7LSRhjM3lgueAlY9jqc18uI6HWonv
	+ypv6gxkrzTBJlSDlt8h6Bh1+r6829g=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37b996f6b28so10136211fa.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763053349; x=1763658149; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UIwv+CwuWqLYgHQJzqazscKZkTF1jtywZznxW87RPa0=;
        b=RHKrX0eL/rFcnWlDPkNQIMmB+RwzgKk2TVEyCHaiDPpqyg2MdYDLrENiEOTvMel2GZ
         7fOCKoZuLWQD2iFG3xF76v29BPI+muSzhZbU9hDyLdC8+ZWpBrzcWR3CA764rWsmsPoi
         yVb5YbnruuO0Jtq5LeQ+wUS/g42hcj82sI4bGLFrg0A8QPztBx99B3GWuD19iaV6KAHP
         DdRj0/NigIeqCqpFMEDkXNqXzly3Mm96EfLzQaqsYTJYNqDAHA4KET+0QNtO8dWIK8Zj
         W4Vh0LjjAOt0vbfNY74kKE/ZuV/1EebkysigCsLXemR6bY2xjgUH1zu4e+1MY0QbMk4T
         8Nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763053349; x=1763658149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIwv+CwuWqLYgHQJzqazscKZkTF1jtywZznxW87RPa0=;
        b=EVJf9d8rm6DguHU0qSHbAe55zxz3wOmwwTR/NQcO0aj+pMD/Ddo6YVedXYSUr5VgIa
         O0L8JB1XwRC9wvCQ+N+DP4emGUnOkISL6rxpFs4YreDC/HsCWAGIJGexPBldlPeDynhC
         cpSL9ijIS9uwPQcy92ls0DASMFecc3NGV4IQZpF5wdK4nVVL+DaLpCzW8NL4HKAE4Qa8
         zNlbg7IfevJC7yNLD0ZIoDq8xTqjHNnRbG8PAoOoDY3/ho1VtIDxn64rcDvwAVvBjHyA
         ibNwjl2m95+fNUiapCD8U/y1BZSnOcpUPuBDl9Cl+wxWsjUVQ6M+ADUCsCP3COXniXbJ
         wkPA==
X-Forwarded-Encrypted: i=1; AJvYcCXQrUdaj0kp4B4XssPcI200TH5oS8p65N1I0rwlIVP0++jk6XJ6uvTnquLIZQ+Ece0eqFxCpfMqeA==@kvack.org
X-Gm-Message-State: AOJu0YwtSyO0bDOrm3BDUmoWdvsuZYZJWWMPJh0MBojmWTOcW6e6ht1d
	Il1OwVoTzQInjXI/JPsWFpMV8OCZbtu7vEuCkWg3mYodOHtlEYs9rvlB7LKqyXAyzftStkJ+9pb
	mT/vQWUVgZ2x/KmrDcPrLm9463KR0K120KuQZHB8=
X-Gm-Gg: ASbGncu7WecMeFp87ih5ncpbi9KMECtdJakUejPUiSBjEutddt6uJBGkwlaOCno6aZg
	j6CnYDmofLOVYsoxubpWUL25cj7YKPDuOQpnJqbi+jelSm/m7nnOlKa0nw5O4Qs+GpFwLLt23BG
	uJCcrvM62rmgM0A60pUO0+hKIafr93dtLb/PWGHD6zpnQXriEoTeQKaWHybThAK1efsIT0tNfvT
	JwgPzvHNhodabEkPMq6ohwe1QekROaXBti2umAK1zM5o8uRCjqz/DQmotFJoaEokTpHjXY=
X-Google-Smtp-Source: AGHT+IGGBxEHWN1/dY/0ilx0C2LUOClRwZAU1DnIsWfO/K2WaCmXaO+kwvUV3nGXSDl3HIOu9fGCodamZm0udhozE0E=
X-Received: by 2002:a05:6512:3d25:b0:592:f5f9:f5a9 with SMTP id
 2adb3069b0e04-5958423edd9mr45678e87.36.1763053348287; Thu, 13 Nov 2025
 09:02:28 -0800 (PST)
MIME-Version: 1.0
References: <20251111125331.12246-1-harry.yoo@oracle.com> <20251112184645.GP196391@frogsfrogsfrogs>
 <aRUpqFS8pU0qGIsb@hyeyoo>
In-Reply-To: <aRUpqFS8pU0qGIsb@hyeyoo>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Thu, 13 Nov 2025 18:02:17 +0100
X-Gm-Features: AWmQ_bncxnkNUy4AWwVbyPyzKr9BBf9obz1JPoxTOaPSxIu-Yf6AxJaBM3VqGU8
Message-ID: <CANfXJzsha8NtY6SwVzq=w1fNYSF46x3yeGk-ZuGCUj7CGrn5nw@mail.gmail.com>
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="0000000000008b780e06437cd86f"
X-Rspamd-Queue-Id: 75A2140023
X-Stat-Signature: 77emxwrb7gs3botw6yuebwraub99kwnb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763053350-549202
X-HE-Meta: U2FsdGVkX18hmcIM8OYVbBmr16QG8RqCUkG13xsE2NgrZhe9bBrhvpS3uMPNmtkHkcvlrMWvgR80SfGUBuRGFk1srdKSZvdAZXUW7EEYk+gfk1LtacTG2z7KYmjHvbvFYLOvFijsieYrUZsHMzqxNSmy98csOlPy9fXkwso1GRXRQjSsxZUVbcul4bnOdUwenW8PcyjqkHx0B0INlpUnJYHYykVaNkrO5R1zPBSeZMnEv23x7y9Y/Yq1/IP7+mg5wdJPJY/UPnV8OHvJi1WRX+1yaYc2QiSeMNsgd8Sn3+2vLCct3QDaNhMmFGymb3YzFFEZESJqskkdeJFK3kuXQOaRiNiiryJm1Dy7tzdpJTNbgJhmG4efXkeL2mTu/a70KY5UiVFw55v9hBaJqPq+S06Bbe9eIZ1Ba6GTaN67thZ2j69AVR+XyDWa120PfUJwAJ4guzxNfSQSY9JJ4Q3y9RZ2NkcS2wHCVHudZVHYNjL4GoJYIZPl1TMd8I17WsutZh5bzBbBIBHD4qM+VbMQQU55khJ1VGtX+LWfKcBSq38IWHVOACy8HGXN8azyhYTMWPof9HMarEjHxkob4XwtfIU663kN8fcld9L48Fm9VR3+G+hekGD0A2P+na5XU5cGm7w5ONVAa+ng/GYTXYoEvBYVlWUKVjI3R5g4qn/NgiGBSsr/VE5yBmEP7K7zStaDhRpUHUdDEGeEiffDMaTULidUXFlmrnBGC+01U5XU4uegd4c1E0+qHdf7uM/2zaxmzJrZjnjuEfrw1oesX4ug2ydyGm/n/SzfsRNBW5m1OuAGZ1O5u+H6LRVzDvCGHy8CKby275mHD5BlMVM75rrPxHc1ao33N9hh3kUaktLHYzddOb9FJPYoeMIbZZl1ukhkqGNtSnD6C8Yx2YJhMKWLe8S8q1LiHHyPtJ3AexyAbbWBoVtPeH5XOoBNBHlFlxY/vgMR5zy5GeLw/3iv3w6
 v6gbpGjZ
 BhCb8JLREV1/HrdR2a4lY1iB7q+0U1Sw7CBgMPNAjNClqmxHcNXiGMqh8mvpowVw5Qm/nrFTE3AnAJjm+OjIkDlJXwPfACo8svvbEGC6fEcHO1+iqNlsxmHDNDUEC+u9r8mCTVF9+hTgebA51eWdrZDu1ZxeeGSjHfN+UMygUPSnGywAWnXEtHSaQJgfP7q1R7Ev10IsKAoP+IWOHLWhfMw6FGkZJfPoQatx3A16PEze7+wq/p36Onj/aZWs4aRMTOi3SqMp/cQLSihig5iovJB60juJgyAMmK/f7UFU3SiZTQrEBtinaywIPTc+AHYXhU1DS1BO5IRvnvRJIZ4iIHSrDDDP2U/j3E3oCfrbtzXOwSkeVVJDB4nlPydKm0Gss6vJ6KSVZLwB5JB5s8BUwFUn/9fQODT1LkluEdlpIeZ7cX1AuTAnybuJou2HVdSJc5WKwcSnwISryFJWeoTLOzIq7YuqYzfQTUOM4Yv3j/VbNtErauFqs4UQfuPQfWdjtrltOsyoU0U3vgunq+ouc6qJqfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008b780e06437cd86f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
OK it seems that this in deed fixed the issue, and i do not see leak now.
Thanks for fixing it :)
Btw if you guys need VPS with GPU resources, i can give you free ride on
SimplePod.ai for helping fixing that issue :)




--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


czw., 13 lis 2025 o 01:43 Harry Yoo <harry.yoo@oracle.com> napisa=C5=82(a):

> On Wed, Nov 12, 2025 at 10:46:45AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 11, 2025 at 09:53:31PM +0900, Harry Yoo wrote:
> > > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > > freeing") introduced the remote_objects array in free_to_pcs_bulk() t=
o
> > > skip sheaves when objects from a remote node are freed.
> > >
> > > However, the array is flushed only when:
> > >   1) the array becomes full (++remote_nr >=3D PCS_BATCH_MAX), or
> > >   2) slab_free_hook() returns false and size becomes zero.
> > >
> > > When neither of the conditions is met, objects in the array are leake=
d.
> > > This resulted in a memory leak [1], where 82 GiB of memory was
> allocated
> > > for the maple_node cache.
> > >
> > > Flush the array after successfully freeing objects to sheaves
> > > in the do_free: path.
> > >
> > > In the meantime, move the snippet if (!size) goto flush_remote; outsi=
de
> > > the while loop for readability. Let's say all objects in the array ar=
e
> > > from a remote node: then we acquire s->cpu_sheaves->lock and try to
> free
> > > an object even when size is zero. This doesn't appear to be harmful,
> > > but isn't really readable.
> >
> > I'll put this on my test fleet this evening.  Thank you for the quick
> > fix! :)
>
> Thanks for testing, Darrick!
>
> --
> Cheers,
> Harry / Hyeonggon
>

--0000000000008b780e06437cd86f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div>OK it seems that this in deed fixed the=
 issue, and i do not see leak now.<br>Thanks for fixing it :)<br>Btw if you=
 guys need VPS with GPU resources, i can give you free ride on SimplePod.ai=
 for helping fixing that issue :)<br><br></div><div><br></div><div><br></di=
v><div><br></div><div><div dir=3D"ltr" class=3D"gmail_signature" data-smart=
mail=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"=
><div dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">czw., 13 lis 2025 o 0=
1:43=C2=A0Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com">harry.yoo@o=
racle.com</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">On Wed, Nov 12, 2025 at 10:46:45AM -0800, Darrick J. Won=
g wrote:<br>
&gt; On Tue, Nov 11, 2025 at 09:53:31PM +0900, Harry Yoo wrote:<br>
&gt; &gt; The commit 989b09b73978 (&quot;slab: skip percpu sheaves for remo=
te object<br>
&gt; &gt; freeing&quot;) introduced the remote_objects array in free_to_pcs=
_bulk() to<br>
&gt; &gt; skip sheaves when objects from a remote node are freed.<br>
&gt; &gt; <br>
&gt; &gt; However, the array is flushed only when:<br>
&gt; &gt;=C2=A0 =C2=A01) the array becomes full (++remote_nr &gt;=3D PCS_BA=
TCH_MAX), or<br>
&gt; &gt;=C2=A0 =C2=A02) slab_free_hook() returns false and size becomes ze=
ro.<br>
&gt; &gt; <br>
&gt; &gt; When neither of the conditions is met, objects in the array are l=
eaked.<br>
&gt; &gt; This resulted in a memory leak [1], where 82 GiB of memory was al=
located<br>
&gt; &gt; for the maple_node cache.<br>
&gt; &gt; <br>
&gt; &gt; Flush the array after successfully freeing objects to sheaves<br>
&gt; &gt; in the do_free: path.<br>
&gt; &gt; <br>
&gt; &gt; In the meantime, move the snippet if (!size) goto flush_remote; o=
utside<br>
&gt; &gt; the while loop for readability. Let&#39;s say all objects in the =
array are<br>
&gt; &gt; from a remote node: then we acquire s-&gt;cpu_sheaves-&gt;lock an=
d try to free<br>
&gt; &gt; an object even when size is zero. This doesn&#39;t appear to be h=
armful,<br>
&gt; &gt; but isn&#39;t really readable.<br>
&gt; <br>
&gt; I&#39;ll put this on my test fleet this evening.=C2=A0 Thank you for t=
he quick<br>
&gt; fix! :)<br>
<br>
Thanks for testing, Darrick!<br>
<br>
-- <br>
Cheers,<br>
Harry / Hyeonggon<br>
</blockquote></div>

--0000000000008b780e06437cd86f--

