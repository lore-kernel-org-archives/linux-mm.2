Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C3C9CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637BF6B0005; Mon, 18 May 2026 07:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E78A6B0088; Mon, 18 May 2026 07:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD7B6B008C; Mon, 18 May 2026 07:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC0A6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:33:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF9D71409BB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:33:29 +0000 (UTC)
X-FDA: 84780330138.30.7F1EAE2
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0835120008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:33:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WzWBSDuX;
	spf=pass (imf29.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779104008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9JNa0e4F+ytOG5iLqFqL2Acs10uYejEmWQ/5hUNwWU=;
	b=vop2tx6//RY6BmVe03tUJAYkYCkGZ7eQXd6fajLD6zVUXQ23GyS3NAGgOJr+uCGOw/Mq2W
	3BTLhSDufMFa9uPvo9a+HwXyEqlXkO/utqNwo2ges1rqflC5rTMbwkz51rdaDxT1XxNkhl
	D9AuNqleONoBQ4hjQUpl1Q0Bb9V350U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WzWBSDuX;
	spf=pass (imf29.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779104008; a=rsa-sha256;
	cv=none;
	b=Y7CBUIq+KrS+6ZThNk7X9DCiCPcdSjcGlvD3MOeQ8w/C/s4SFPkoWzq+mdTKJpUj86PTKd
	7IHbuTfSWVaOBaLT+XQj7hIsXqzN3P+9bRK6+c405JEgb1/AN6gwZgyiryuO13V8MQJRMM
	Fj2FULf+pDYx5XrA/RK1PbtWJ/pahgc=
Content-Type: multipart/alternative; boundary=Apple-Mail-E18CDB4D-D2F0-4E7C-999C-FEDA211B62DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779104005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9JNa0e4F+ytOG5iLqFqL2Acs10uYejEmWQ/5hUNwWU=;
	b=WzWBSDuXYY2IC8hwoNL8eI75qJUb6nynu6cHWSNcav194viCPTVEMtU+VWPmu8rmLi72XF
	/IqVbxebc6msQ7U5gBnfhn6J6n2UdwzwXApTF3d1PB9FTMqXPwuZBeCukMVfI6OApY+d0p
	Ty8U1sU2DR073N8FNeNum1I0Cz7h8dM=
Content-Transfer-Encoding: 7bit
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Date: Mon, 18 May 2026 05:33:06 -0600
Message-Id: <33ADFA04-4A58-4B3F-925B-1A9CCC53F300@linux.dev>
References: <agrmeROd6Xu9m680@lucifer>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Yury Norov <ynorov@nvidia.com>, Thorsten Blum <thorsten.blum@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
In-Reply-To: <agrmeROd6Xu9m680@lucifer>
To: Lorenzo Stoakes <ljs@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ud951gfi4fz9iwhjxdhinynpwdwdiiae
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0835120008
X-Rspam-User: 
X-HE-Tag: 1779104007-212300
X-HE-Meta: U2FsdGVkX1/CLZOPpQeiJ9ZQyFOTMyT8LcA+wDx9gKgJ/ARfCIlcVVIHqZXW0lgsJAf78zNSX732Ew8UqHomhOdyFNPGMsxLeIYpw6YlePhVqYINSkZV+pd6azCkJrss6YhRzhDODTfjkfJxQUA1g9SPnJSXVkjlHhu/d8RcGtzDttZimyxe4TeWWVoEjvSpEOXdlBtHxvp9blvJs0wWfl+WQWLHTIgLACj0kC3wwZpjSnhlPvj0BO8U9wPlo7VyefZoVzf8RX/5Ly7se60dyEtZAe+Avjo3UEowXGhOqaDnaRtgJCrJ05YmAKON0pNlqX2oxpCIBNUjc97qUQ3yog9G1ZEVllFtXJdUjFj2HSyJfN36uEVq7JatxHLXWt900tNHnNdzCbHzvEZX99WqTBKUIkrzzNZKl8HkIHGiXz1SK3751WBBpkljbIBx8YiaKY7Nlul8ttvoMbvexB1XMkVaTHMTbiuw/mrzI9kU1jzzfdU1Q30lIolJM1CHpZT3bsG/edGwlLZhJZSRW0W60/rqtuiE+fg3i4zmltB+PPG1lZpYc5AoLO+d7o7yRPtEBKLZGX5Pyy+Wu5u4VvqmWmKcRnuLNv/NOrCy8bm89C/q/G02XhRJdm8lXZuhX1TWZdeswHCL5a5DPxrWTek3FCqqaavQEY/O2DUwlvHvYElY75+y6nN+EThWfZv9MvofTiae2Xo2qd12MtHvSTMCHIjkG6RsN7BQiW3DT1+L2rOR57EJ6VV1iqsSX32Fq7c2NnhqucrqlfwQ0bWui2Ht/sQEC/BbHJR8cznFQHz07wjEA7CpbptPYd9u0IDLzcoE7niZG4+Rzpsy1e+e96JAP10B57IXaBaRbo8MLgR6rFW0GXKCxJMzN+iYdSPtyDN543reiq/ceVTMEOk3ws43ZABDPusW3Izatg6Lefz1HHzdaAHjf4EqmNcPislXju6HCLdy0zVj2zv4pkhwONC
 DIxhkm6y
 hX+UNZuib/lsQz/mLnlLPJem2hC9M7ciTs618zetJDp/GVukVfoh1GW2ak0som7eMiFEG9KEIgF2sq2fbJXYEs3OYF0ujW8Keb0hPUBLOQwI/LYZQsZvXSAwGufD0FbrTjFwnkxfs0JKofeI62flC8GJ7e0ddsqb+rSXyoTou3iqkvar5CPTOPd0eV1GWk6+pMDLydAHR5kGzGMM4wbh6D1QPitodzDKe965DndTQVlGkbMf2Ku139KTYB5gCVchvSKj6qezmiutyCDh+EmHWxE5EmSaz2EUTegFFkf8QoBpgla+Em5IpLVklVX2zmTR1TJU7BXy3ynzWGovFleWIjdhQyL2PdLZJBa2gJJyliGlUp3B+XC4Qi38S4tL/M+Y2AAhAAlpjY5Y7KeZmKhKoQkKiJWHAUartwHI6BxUgLRLKrapDI20DWAnN3LB0y6xXiB43bI/+W4bYiKlINJ1qftj8n+6CGZ87uirt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail-E18CDB4D-D2F0-4E7C-999C-FEDA211B62DC
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

As with Lorenzo's concerns, my biggest issue with this change is that it bec=
omes unclear what "page" means in this context.

Is it a base PAGE_SIZE page? A 2 MB "large" page? A 1 GB "huge" page on arch=
itectures that support it?

The "rest_of_page()" macro masks that distinction, where the current code=E2=
=80=99s explicit reference to PAGE_SIZE makes the basis of the calculation o=
bvious.

I don=E2=80=99t see why we would want to obscure that behind a macro, especi=
ally when it makes the code harder to follow.


> On May 18, 2026, at 04:28, Lorenzo Stoakes <ljs@kernel.org> wrote:
>=20
> =EF=BB=BFOn Mon, May 18, 2026 at 09:48:32AM +0300, Andy Shevchenko wrote:
>>> On Sun, May 17, 2026 at 11:28:05AM -0400, Yury Norov wrote:
>>> On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
>>=20
>> ...
>>=20
>>> I've got a series for this
>>>=20
>>> https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
>>>=20
>>> The feedback is surprisingly negative. Please add people from that
>>> thread. Maybe you'll be more successful convincing them.
>=20
> There's a cost to adding yet more super-specific headers where stuff gets h=
idden
> and people don't know where to put what, things quickly become a mess and h=
eader
> dependencies are already a nightmare.
>=20
> Also in the case of this helper, I don't see the value in adding a vague,
> untyped, confusingly-named macro when PAGE_SIZE - offset_in_page() is perf=
ectly
> cromulent and clear in what it's doing?
>=20
>>=20
>> We always can simply fork, but I truly do not understand the pushback.
>=20
> Well, be my guest? This isn't a hugely helpful or friendly comment.
>=20
>> These are simple macros that are way spread in the kernel, "include every=
thing"
>> kinda linux/mm.h is not needed in vast majority of the users, hence the
>> split is logical step.
>=20
> Right but that's completely orthogonal to adding this macro?
>=20
> I'm fine with moving offset_in_page() to e.g. mm_types.h.
>=20
> But a series that doesn't even give any actual motivation for the change i=
s not
> convicing, and we aren't required to just accept any change.
>=20
>>=20
>> I'm in favour of this series.
>=20
> OK, I'm not :)
>=20
>>=20
>> --
>> With Best Regards,
>> Andy Shevchenko
>>=20
>>=20
>=20
> Thanks, Lorenzo
>=20

--Apple-Mail-E18CDB4D-D2F0-4E7C-999C-FEDA211B62DC
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html class=3D"apple-mail-supports-explicit-dark-mode"><head><meta http-equi=
v=3D"content-type" content=3D"text/html; charset=3Dutf-8"></head><body dir=3D=
"auto"><div dir=3D"ltr"></div><div dir=3D"ltr"><p data-start=3D"182" data-en=
d=3D"264" style=3D"-webkit-text-size-adjust: auto;">As with Lorenzo's concer=
ns, my biggest issue with this change is that it becomes unclear what "page"=
 means in this context.</p><p data-start=3D"269" data-end=3D"345" style=3D"-=
webkit-text-size-adjust: auto;">Is it a base PAGE_SIZE page? A 2 MB "large" p=
age? A 1 GB "huge" page on architectures that support it?</p><p data-start=3D=
"350" data-end=3D"540" style=3D"-webkit-text-size-adjust: auto;"><span style=
=3D"font-size: medium;">The "rest_of_page()" macro masks that distinction, w=
here the current code=E2=80=99s explicit reference to PAGE_SIZE makes the ba=
sis of the calculation obvious.</span></p><p data-start=3D"545" data-end=3D"=
658" style=3D"-webkit-text-size-adjust: auto;">I don=E2=80=99t see why we wo=
uld want to obscure that behind a macro, especially when it makes the code h=
arder to follow.</p></div><div dir=3D"ltr"><br><div dir=3D"ltr"></div><block=
quote type=3D"cite">On May 18, 2026, at 04:28, Lorenzo Stoakes &lt;ljs@kerne=
l.org&gt; wrote:<br><br></blockquote></div><blockquote type=3D"cite"><div di=
r=3D"ltr">=EF=BB=BF<span>On Mon, May 18, 2026 at 09:48:32AM +0300, Andy Shev=
chenko wrote:</span><br><blockquote type=3D"cite"><span>On Sun, May 17, 2026=
 at 11:28:05AM -0400, Yury Norov wrote:</span><br></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><span>On Sun, May 17, 2026 at 02:34:3=
0PM +0200, Thorsten Blum wrote:</span><br></blockquote></blockquote><blockqu=
ote type=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite"><s=
pan>...</span><br></blockquote><blockquote type=3D"cite"><span></span><br></=
blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>I've go=
t a series for this</span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span></span><br></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><span>https://lore.kernel=
.org/all/20260303182845.250bb2de@kernel.org/</span><br></blockquote></blockq=
uote><blockquote type=3D"cite"><blockquote type=3D"cite"><span></span><br></=
blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite">=
<span>The feedback is surprisingly negative. Please add people from that</sp=
an><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>thread. Maybe you'll be more successful convincing them.</span>=
<br></blockquote></blockquote><span></span><br><span>There's a cost to addin=
g yet more super-specific headers where stuff gets hidden</span><br><span>an=
d people don't know where to put what, things quickly become a mess and head=
er</span><br><span>dependencies are already a nightmare.</span><br><span></s=
pan><br><span>Also in the case of this helper, I don't see the value in addi=
ng a vague,</span><br><span>untyped, confusingly-named macro when PAGE_SIZE -=
 offset_in_page() is perfectly</span><br><span>cromulent and clear in what i=
t's doing?</span><br><span></span><br><blockquote type=3D"cite"><span></span=
><br></blockquote><blockquote type=3D"cite"><span>We always can simply fork,=
 but I truly do not understand the pushback.</span><br></blockquote><span></=
span><br><span>Well, be my guest? This isn't a hugely helpful or friendly co=
mment.</span><br><span></span><br><blockquote type=3D"cite"><span>These are s=
imple macros that are way spread in the kernel, "include everything"</span><=
br></blockquote><blockquote type=3D"cite"><span>kinda linux/mm.h is not need=
ed in vast majority of the users, hence the</span><br></blockquote><blockquo=
te type=3D"cite"><span>split is logical step.</span><br></blockquote><span><=
/span><br><span>Right but that's completely orthogonal to adding this macro?=
</span><br><span></span><br><span>I'm fine with moving offset_in_page() to e=
.g. mm_types.h.</span><br><span></span><br><span>But a series that doesn't e=
ven give any actual motivation for the change is not</span><br><span>convici=
ng, and we aren't required to just accept any change.</span><br><span></span=
><br><blockquote type=3D"cite"><span></span><br></blockquote><blockquote typ=
e=3D"cite"><span>I'm in favour of this series.</span><br></blockquote><span>=
</span><br><span>OK, I'm not :)</span><br><span></span><br><blockquote type=3D=
"cite"><span></span><br></blockquote><blockquote type=3D"cite"><span>--</spa=
n><br></blockquote><blockquote type=3D"cite"><span>With Best Regards,</span>=
<br></blockquote><blockquote type=3D"cite"><span>Andy Shevchenko</span><br><=
/blockquote><blockquote type=3D"cite"><span></span><br></blockquote><blockqu=
ote type=3D"cite"><span></span><br></blockquote><span></span><br><span>Thank=
s, Lorenzo</span><br><span></span><br></div></blockquote></body></html>=

--Apple-Mail-E18CDB4D-D2F0-4E7C-999C-FEDA211B62DC--

