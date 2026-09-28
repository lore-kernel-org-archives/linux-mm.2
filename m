Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B6BC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B92E6B009D; Mon, 28 Sep 2026 05:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869F06B009F; Mon, 28 Sep 2026 05:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7A96B00A5; Mon, 28 Sep 2026 05:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 547B06B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:05:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4A281A015B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:05:55 +0000 (UTC)
X-FDA: 85262588670.14.1913EAD
Received: from mail.hasspetorleum.com (mail.hasspetorleum.com [45.131.66.38])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A95520007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:05:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=hasspetorleum.com header.s=default header.b="DuTE/A/D";
	dmarc=pass (policy=quarantine) header.from=hasspetorleum.com;
	spf=pass (imf13.hostedemail.com: domain of vashoopar@hasspetorleum.com designates 45.131.66.38 as permitted sender) smtp.mailfrom=vashoopar@hasspetorleum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KNXPqlQY/CN8csacq2qcl46brPagnI6fYse3tRtIQDY=;
	b=fg9L6UyiiAxQskBqQ80l7eL50KiD0scBetqyUubTbq0WbW5N0Rl93NULZvEzMYpmuUKu3z
	VntaR38jq+cITnItIwjBsOHyFVDTFX53uAiRgtB/Qtse5nryz0Vaqv7UJAqHLgxz5m848B
	XJscyWCjGuFoamZFla9kTU7+NrzFvlA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=hasspetorleum.com header.s=default header.b="DuTE/A/D";
	dmarc=pass (policy=quarantine) header.from=hasspetorleum.com;
	spf=pass (imf13.hostedemail.com: domain of vashoopar@hasspetorleum.com designates 45.131.66.38 as permitted sender) smtp.mailfrom=vashoopar@hasspetorleum.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586354;
	b=1ngkl5lDvCRApIoCmQ5XAXTmuB9oR1Sh14ZBc3oRxq/SGElIp56RNGGcBXVS32WJrt8sdi
	g1ccVWHnLLrbvIyYZDJ2qH2sZLMllQ1m09qbE/sRJT6tKFbk4MZf1OXf0ctontyWTHx+eE
	wwAiAxBKT+Fglh7HXaxYgGZ/UBIcL68=
Received: from SEALORDS (unknown [67.21.33.64])
	by mail.hasspetorleum.com (Postfix) with ESMTPSA id 71F7DC7184
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:05:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hasspetorleum.com;
	s=default; t=1790586330;
	bh=KNXPqlQY/CN8csacq2qcl46brPagnI6fYse3tRtIQDY=; h=From:Subject:To;
	b=DuTE/A/Dtp3WSK+lrx24adVHwqoVOPd49fZGHWbrQAEUt3UKd24LNP7oeA81P0TlU
	 ggbMRN/tgn+H9EGgXxcsvqi+X37TJ+6si82vWeEh3i6UzRauXM0+WwokaJAtSoVhJP
	 BSYFl4UfNJ3sH9j/RAupyeN9qXxPG8kkM/Qw/+sw6B1HprogUchOW9aUYXVxFcPvAv
	 BGA0BdbVPTTfylkNht/XG1eG5SO1LztLjTEjNMP8mM2ytITq4nFyxux86cEMibJpSy
	 q5ga+GbvpXxBfXQ6XlPhO4cLe2Ib1ojjUGL1afiMG+epDhPMuKzIBT4IO7CRhZTIfG
	 rmv/EzaYk2nEA==
Received-SPF: pass (mail.hasspetorleum.com: connection is authenticated)
From: "David Bajada" <vashoopar@hasspetorleum.com>
Subject: Private Investment & Strategic Financing Opportunities
To: <linux-mm@kvack.org>
Content-Type: multipart/alternative;
 boundary="rVC=_E5ozLyW9lBTNKh5urDoZ4dSXsizRh"
MIME-Version: 1.0
Reply-To: "David Bajada" <david.bajada@schr0ders.com>
Date: Mon, 28 Sep 2026 02:05:29 -0700
Message-Id: <20262809020529D67096A149$6B4F2E1906@hasspetorleum.com>
X-PPP-Message-ID: 
 <179058633007.1723530.12144656654383449852@mail.hasspetorleum.com>
X-PPP-Vhost: hasspetorleum.com
X-Rspamd-Queue-Id: 2A95520007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gdpzfa8dr9fu6fg4buxqihtx8sehp5kn
X-HE-Tag: 1790586353-624663
X-HE-Meta: U2FsdGVkX1/RDZWPUrwsxy/XoHDVu7CfFLEdqLCNnXZ4YDa1PMLZriyx3I+wxbWpbwWcTkZ55KEF3fqDxXGG21hl3ETJPFPvUI6Ah5jWdNGNZMrfNZPxDmo7n1EE7Jzr5EBaP+cnHVoOw+pHabrpcF27NfkOnQ4SLXOic/qLflWLdw77HVmN5hm7KtZN+b3tf/2J2oPI4kLaP8cSO2eapY1Pr2YJu1z/cfcOwHPiXcZeiefY5QoTXbrhGnj/6FyEZuV5n57F7iXZbAQ589a2UfSlaU5Rfv7lRgwrJhiyN4y0gcMXFDohnc37h0DV8J8vmSX5yPKuy33cUjqmxZGcj9i14y3l1rRRkiihed4KwOvlDzoGnncj5NhC+qThe58L0Qys4H9+LAoRJSAYWGNil65uYulPACqcwEf4SFGujxeBpOVbZP/EMaTtQnhC/hfen8mULvb/QHjwQQQxVFaYatuylRdm1a7iIcDMtOUeFp57wubCsXVXURCa5l7Klv3/Ef9NrAlrPGfH3Xpid+uo+YixqDzInYvmNqT+DsZKElG8fekF0X/76c1BwZYL0H97trm2YPJaZbKhAUh+UhaAoCDObgINBGvDvyb2r3YjP+lzYm0N+3m76fcx/f/HGiqKG5ErzaxIu3VcCePbj/xj+U5panqpizy6awtHxTgntiVPiJhpSZbOqlKYGcP72fFsFoDV1DNTubcVD+/aAfvQKGsG7YLbQULOVjJg1AGb5V7HaYIcwtVU12YTDIdxqgXMpoQQlQMPKcwG8MZ8KUVYNAES+xAigSidn0OVNq92QWnoytT2Od20f9BrYPChwqMo4crxixmZtFpYJy/ssgsq+HDxp91+WCdlvZxGIGLYWMmXHATr0KGiqqR3nkQAv9yjf9xPdp75s1dtdGMlCFGmhjtFML8RnlcPXkrFWJ91VcGcUDcXqeRTzNirtA3smmyvRsKgc1tEEyZT68w+pyk
 b5ZrtiJX
 MeFRWQpvxkF/baqQFZzZIN2+yMwfs6fYH3VaCW3/zkb4csT6TVYYkCq8mHVCVtXSgE4ZHU3YJNhor90LN5GPNxBnS8fMiAE/z0fB9z2fIO/g+0WTQbtW+oKJjIqtZgw3WHaEVEUUfs0larP/usNoh7UoKGSh1kTnGcmeEKuHqKy9d/EqrDnEDoxUxPFPE13mXNULRc3xMnzuesBLseU+l16Gd7nAlOWBNkWiDsCcp4f+5hfFOZHStbfrm0wWycY7ca48ge18ZF77zd0Ki3uFqVrpQQ3avM5Pbhr4VCSolqbHdhthOWAumf8sVqK3URddo8PW05XnQ7TdINwpahqhix2m+cbtluvkaXlYG8DKGt3cu+UOThyKZ3MeVsmjLjmk316hZTIcmwrF/ybD7Ymap/AH2D1eAzGc6M1Rqp12LVwDK6rgPcOFdS7ML7rAAHwzwSQ6CCgPO0a/WnA6i4bjc2aoJUc0bJA53DP2SM8/kjmDc6OFRJ6ktoWEEWC8tw+mdHg63uSJ9NTfGGq7yO3Nh9UosMQ8C0ZyMFnHb0DvuJv2YB6o+V38ns+7Uixb/SPAhJoSGQipqtI4t2QEvN67Kt5crDFTmu+1oNcyrvVcBvT9gm41g8l8UJS2+4ACERaQSl7/97yHYRZP5p7RfX7ecT+RJq3XOyL5ZpOaoRsjkIPM3pEpb4ATeZdQkZM8trpoHgzCOHk0+xIfarih6cnXhLbfjkQt4zDBczcNhF4YzHoJo5Rr1hJviD/PfjmvNA+ZlK+FizJyOh8aHg6bN+uuRdTp5VHl4le183Ctj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format

--rVC=_E5ozLyW9lBTNKh5urDoZ4dSXsizRh
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable


Dear Sir/Madam,

I hope you are well.

We are a private investment firm seeking strategic partnerships with r=
eputable businesses, project owners, and established organisations wit=
h commercially viable investment opportunities.

As part of our 2026 investment programme, we are expanding our global =
portfolio and are open to opportunities across a broad range of sector=
s, including infrastructure, energy, real estate, manufacturing, techn=
ology, healthcare, agriculture, finance, transportation, aviation, hos=
pitality, and other growth industries.

Our investment partners are prepared to consider legitimate, well-stru=
ctured, and scalable projects with strong commercial fundamentals. Dep=
ending on the requirements of each opportunity, we can consider debt f=
inancing, equity investment, or joint-venture structures, with a focus=
 on transparent terms and sustainable long-term partnerships.

If you are currently seeking funding for an existing project, expansio=
n, acquisition, or upcoming development, we would be pleased to conduc=
t an initial review.

For an initial assessment, please provide a brief overview of the proj=
ect, including:

*=20

Project description and objectives

*=20

Funding requirement and proposed structure

*=20

Key financial information and projections

*=20

Current stage of development

*=20

Relevant company or project documentation

Following our preliminary review, and where there is a potential strat=
egic fit, our team will contact you to discuss the opportunity and pot=
ential next steps.

We appreciate your consideration and look forward to exploring mutuall=
y beneficial investment opportunities.

Yours sincerely,

David Bajada
Co-Head, Private Equity Investments
Private Investment & Strategic Partnerships

Confidentiality Notice:
This communication is confidential and intended solely for the named r=
ecipient. If you have received it in error, please notify the sender a=
nd permanently delete the message and any copies. Any unauthorised dis=
closure, reproduction, or distribution of this communication is prohib=
ited.

--rVC=_E5ozLyW9lBTNKh5urDoZ4dSXsizRh
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable


<html lang=3Den><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-=
8">
  <META name=3Dviewport content=3D"width=3Ddevice-width, initial-scale=
=3D1.0"><title>Private Investment & Strategic Financing Opportunities<=
/title>
 </head>
 <body style=3D"FONT-FAMILY: Arial, Helvetica, sans-serif; COLOR: #222=
222; PADDING-BOTTOM: 0px; PADDING-TOP: 0px; PADDING-LEFT: 0px; MARGIN:=
 0px; PADDING-RIGHT: 0px; BACKGROUND-COLOR: #f4f6f8"> <P class=3D"x1yc=
453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qj=
w xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm=
 xrxpjvj" dir=3Dltr>Dear Sir/Madam,</p><p class=3D"x1yc453h xma8rkl xg=
oqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4=
adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3D=
ltr>I hope you are well.</p><p class=3D"x1yc453h xma8rkl xgoqxah xutxf=
r x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns=
 x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>We are=
 a private investment firm seeking strategic partnerships with reputab=
le businesses, project owners, and established organisations with comm=
ercially viable investment opportunities.</p><p class=3D"x1yc453h xma8=
rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr=
 x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj"=
 dir=3Dltr>As part of our 2026 investment programme, we are expanding =
our global portfolio and are open to opportunities across a broad rang=
e of sectors, including infrastructure, energy, real estate, manufactu=
ring, technology, healthcare, agriculture, finance, transportation, av=
iation, hospitality, and other growth industries.</p><p class=3D"x1yc4=
53h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw=
 xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm =
xrxpjvj" dir=3Dltr>Our investment partners are prepared to consider le=
gitimate, well-structured, and scalable projects with strong commercia=
l fundamentals. Depending on the requirements of each opportunity, we =
can consider <STRONG class=3Dx7amdea>debt financing, equity investment=
, or joint-venture structures</STRONG>, with a focus on transparent te=
rms and sustainable long-term partnerships.</p><p class=3D"x1yc453h xm=
a8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5t=
zr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjv=
j" dir=3Dltr>If you are currently seeking funding for an existing proj=
ect, expansion, acquisition, or upcoming development, we would be plea=
sed to conduct an initial review.</p><p class=3D"x1yc453h xma8rkl xgoq=
xah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4ad=
c xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dl=
tr>For an initial assessment, please provide a brief overview of the p=
roject, including:</P> <UL class=3D"xonam98 x1epdd7z xemmon1 xn020vs x=
fl32do xluzp7q x1yc453h x38giro xat24cr x1xobyvs x1fv8qjw xdj266r xrxp=
jvj x1bxe5rh"> <LI class=3D"x1datfip xp5n6w9 x2xbuc6"> <P class=3D"x1y=
c453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8q=
jw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6z=
m xrxpjvj" dir=3Dltr>Project description and objectives</P></LI> <LI c=
lass=3D"x1datfip xp5n6w9 x2xbuc6"> <P class=3D"x1yc453h xma8rkl xgoqxa=
h xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc =
xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr=
>Funding requirement and proposed structure</P></LI> <LI class=3D"x1da=
tfip xp5n6w9 x2xbuc6"> <P class=3D"x1yc453h xma8rkl xgoqxah xutxfr x1f=
ie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2=
l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>Key financi=
al information and projections</P></LI> <LI class=3D"x1datfip xp5n6w9 =
x2xbuc6"> <P class=3D"x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25=
 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5=
 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>Current stage of develop=
ment</P></LI> <LI class=3D"x1datfip xp5n6w9 x2xbuc6"> <P class=3D"x1yc=
453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qj=
w xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm=
 xrxpjvj" dir=3Dltr>Relevant company or project documentation</P></LI>=
</UL> <P class=3D"x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1x=
obyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw=
7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>Following our preliminary re=
view, and where there is a potential strategic fit, our team will cont=
act you to discuss the opportunity and potential next steps.</p><p cla=
ss=3D"x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs=
31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2r=
x x160d6zm xrxpjvj" dir=3Dltr>We appreciate your consideration and loo=
k forward to exploring mutually beneficial investment opportunities.</=
p><p class=3D"x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyv=
s x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688=
 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>Yours sincerely,</p><p class=3D"=
x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1f=
v8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160=
d6zm xrxpjvj" dir=3Dltr><STRONG class=3Dx7amdea>David Bajada</STRONG><=
BR><STRONG class=3Dx7amdea>Co-Head, Private Equity Investments</STRONG=
><BR>Private Investment &amp; Strategic Partnerships</p><p class=3D"x1=
yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8=
qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6=
zm xrxpjvj" dir=3Dltr>&nbsp;</p><p class=3D"x1yc453h xma8rkl xgoqxah x=
utxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnv=
auns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>&n=
bsp;</p><p class=3D"x1yc453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x=
1xobyvs x1elgs31 x1fv8qjw xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 x=
uw7688 x1pjt2rx x160d6zm xrxpjvj" dir=3Dltr>&nbsp;</p><p class=3D"x1yc=
453h xma8rkl xgoqxah xutxfr x1fie51u xgyxj25 x1xobyvs x1elgs31 x1fv8qj=
w xcy5tzr x1ht4adc xnvauns x1c2l018 x14l7nz5 xuw7688 x1pjt2rx x160d6zm=
 xrxpjvj" dir=3Dltr><STRONG class=3Dx7amdea>Confidentiality Notice:</S=
TRONG><BR>This communication is confidential and intended solely for t=
he named recipient. If you have received it in error, please notify th=
e sender and permanently delete the message and any copies. Any unauth=
orised disclosure, reproduction, or distribution of this communication=
 is prohibited.</P></body>
 </html>

--rVC=_E5ozLyW9lBTNKh5urDoZ4dSXsizRh--


