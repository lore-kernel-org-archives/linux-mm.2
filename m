Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675ABCC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F0A6B0095; Thu, 15 Oct 2026 04:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740536B0096; Thu, 15 Oct 2026 04:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656306B0098; Thu, 15 Oct 2026 04:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41C856B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:28:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F67E1A0984
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:22:21 +0000 (UTC)
X-FDA: 85324168482.25.43A2B00
Received: from a4-24.smtp-out.eu-west-1.amazonses.com (a4-24.smtp-out.eu-west-1.amazonses.com [54.240.4.24])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7FE9420005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:22:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=granata-sial-paris-2026.com header.s=4vj7o2dqjpszhdz2rsqt5pymrqzhnzt3 header.b=EgH7qWPy;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=KpF5n7xa;
	spf=pass (imf31.hostedemail.com: domain of 010201a13ea7a6a4-ff54c3b1-f5c1-40d3-96c4-520662a52266-000000@bounce.granata-sial-paris-2026.com designates 54.240.4.24 as permitted sender) smtp.mailfrom=010201a13ea7a6a4-ff54c3b1-f5c1-40d3-96c4-520662a52266-000000@bounce.granata-sial-paris-2026.com;
	dmarc=pass (policy=none) header.from=granata-sial-paris-2026.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792052539;
	b=5P5XscuWqdvHJkB8egYZU8aX8gXyTF/RTVQVQ0ubkF35Ntm5r2HTH0uVAeb+ykWOlKHOwA
	qXME7QBsFT+KJCq3M3aq056fzgQUXoDa25tFU5hS208Esb00uoxzJg0jdZoKs7bEfJZOur
	RYpwhIUvyPl8Cig1ukS+yEUnr6CbTow=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=granata-sial-paris-2026.com header.s=4vj7o2dqjpszhdz2rsqt5pymrqzhnzt3 header.b=EgH7qWPy;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=KpF5n7xa;
	spf=pass (imf31.hostedemail.com: domain of 010201a13ea7a6a4-ff54c3b1-f5c1-40d3-96c4-520662a52266-000000@bounce.granata-sial-paris-2026.com designates 54.240.4.24 as permitted sender) smtp.mailfrom=010201a13ea7a6a4-ff54c3b1-f5c1-40d3-96c4-520662a52266-000000@bounce.granata-sial-paris-2026.com;
	dmarc=pass (policy=none) header.from=granata-sial-paris-2026.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792052539;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SkxwZCSghbmvuu/95L/wyFDjDKzX40K+WggcCuIxfIM=;
	b=Nt276awwDo254QMXmRon+Rew2y+FTs72uaG9LGHTvkMoS42bN4qD45+4kt2JUkUFp2TpA4
	H0m9b6JWuab6AbqAWkTx+uiVqMEmq7EXwOjL4FwIzpaBsh9XZ8NA/n55dOWef2IydEAQL5
	OBnEshLVQNLE8Cuw2Hw47JBATJtxY3k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=4vj7o2dqjpszhdz2rsqt5pymrqzhnzt3; d=granata-sial-paris-2026.com;
	t=1792052537;
	h=From:Reply-To:To:Subject:MIME-Version:Content-Type:Message-ID:Date;
	bh=SkxwZCSghbmvuu/95L/wyFDjDKzX40K+WggcCuIxfIM=;
	b=EgH7qWPy17jDo24IOnBx3CFYsRDRHgFyB2YyEdLIGJYZFkZSugZUqcFItnRugfZl
	DsRyB8vgsvRh+wpRXAu7p7ZwDkgOnS9BFXwn9i/hDifk+7tu8D7Q+3rbdpCo7Pqzh6h
	O6pEDvHm2bHv5xBal8RgkVEwyVy34jONaeUyKMOn7MlESjR9kVUoJxLzloSDY45IeRr
	QTozw835SJOSaitHr4dX8luJ3I6FPn1oWIGvc29VMs/Ss1xy78W+rkPzvly8ZrJaU4L
	lcr+E6meHTyE2CnsL7Pni1DyD1nnN0dsJjZSb+GyNDwamTEG0lMDJNMN5aNRLPnf7Jn
	CoTR9ZRIGQ==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1792052537;
	h=From:Reply-To:To:Subject:MIME-Version:Content-Type:Message-ID:Date:Feedback-ID;
	bh=SkxwZCSghbmvuu/95L/wyFDjDKzX40K+WggcCuIxfIM=;
	b=KpF5n7xaFLOUlRBRbX+TXJA62TeZ6ImKKs51Y72RE+sZoFvwFjbD2xE0BxzMLj7C
	Z79DBG+71FuOYlMnIeEa5oVKnFmY34GQbOMSYpT5UvIXXcX19SfpSwkZ6TpSpc6X+HJ
	OjwKmNr5EJfFk44Vwnw7n0LZht8822ATZCzXgn/M=
From: Silvia <silvia@granata-sial-paris-2026.com>
Reply-To: silvia@granata-sial-paris-2026.com
To: linux-mm@kvack.org
Subject: Avez-vous des besoins en olives italiennes ?
MIME-Version: 1.0
Content-Type: multipart/alternative; 
	boundary="----=_Part_269313_221934219.1792052536996"
Message-ID: <010201a13ea7a6a4-ff54c3b1-f5c1-40d3-96c4-520662a52266-000000@eu-west-1.amazonses.com>
Date: Thu, 15 Oct 2026 08:22:17 +0000
Feedback-ID: ::1.eu-west-1.YbPVrDFKMqIai/PZSqkauNNVyu0Bi9A9R29gQ/Iz/tU=:AmazonSES
X-SES-Outgoing: 2026.10.15-54.240.4.24
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FE9420005
X-Stat-Signature: ctnpqepe8utzj5mytu9a3bieswjbtckx
X-HE-Tag: 1792052539-617802
X-HE-Meta: U2FsdGVkX18maGD9Xt0nLQcStC1VjqYCzr6X1Bf+oN0j7PyANnj/tocgu9CcxkCfFQZRHfxB1xhtexghomRLBwf8zYhQfGMW/0Sl58/XozbxqNV85dNCNxUF4NiEj/kbSmYrkVRG9eoDPaIrxqqfdZC6YLfAuJWWczLWLh3wI8j16vedLcV1Y8YmM9Iyh5KuOqeSezT+1JN6Ta2ytEBKGVH4+q7vKVX4ktKH/NcTzvaKW5SnGfM0BOQVi+PZqphqmDoURRJmegM7LBtd//V28FN5oED+zw8eEZFU939jd2sAO1vHxh471qvAQHBkfwx3GfBK3flAiTNw/2+5BCmhSHo81zZs+rt1OSFLsy5XB8lf1lHww6cqXfxcakHljFjKjj9E6TnMgfeQtRfrbFjxmq6qXkDWHyBwuFCVVI4KC94gEoXbu3ubzSv2oOIwJig/cvmSglQLTIvk88vKYg9gVk/2sIQ+R0gfsmyKLENpLLMKgiuDUG28mWPzZoADLVoYNreSG/VslR4/y9AGL+d2ptg6QuO70LU7ZkxrHFocI35AbgpaFBUrZMUOiBw2VyvXZtyHNJY/UIrkMZavtHVmmfXLgD71QvARkIgy/HdW+UeJHu1OWM/kXDFsj4mTqSRHpYhru4vvs1VZwwffJVmvpStIhPWeUi/huNwL6M2kn2gnWTrMk6rFPOHxvRBQOCrnpxtEHZsU35WY85W4s9QtuhzLW6ne4wujVmHj9b6mBjEy1YMhYro94RsMOqxey99Bsj+V6kl4qygi5iY7kbV8CJpo/vp32vH95T/7XJY5iJTLcHxs6mR6ocjuFKtble+gA0v0pozsSn+AoqZZ1k51BIg9kBR3LbjJiLYM1IoAv7NDyIMe/io8ItBclJJOXqK7bTOUJrpyhgWNBxeWSceAKgJdyGYpNqLqLrJUUPYAGim3QW1d7CpO8hCUoERF9HSh/DSxXRGO4fc3SUqcqZt
 2ufyixoC
 MrLEFmfplBFGjkOQskYpz+jo2ub1tlGosphya/+vZkAm3GogjWmGGi8jZIOJHiCqyF6casRGKRTv/CDzjUTn0PD3ujO487z5Gj1HbZEM+BTlklsk2AllOwoekrb8CQIS25Dx3emZZwjgomQ+tnVFVmgWtCB6M5F27yboMANxS1gOVDW9+2Zmh4A8itNqWTT4zCsHldNligrvU7Fdpeh1gU5ARVrFWfcj4FAFvzHGahOhKN2RLSLMTSQdq50lZVzCz0XyP8h9zevMM2gos2KYiFkC/MKhMrcEguuI2MS41bIttaPNk4O7IPesSg10Xxh7KPmamAVWXquq1tHsXR0hdb8CGkbZ2pBWViIfKYCgjftWrvgvW1i6E9UCMBPmushUEzzyJWqRW2Je6FulngXPrdnPdav9jGnmyOYpP8H/9HwLV6J16pOavK1Ns+x6v+ucSzFFOl3lPzo9JAKs/DZLIFDg022ToFZVsK7lqqzFmyWDA0T4LM9vMxIPspEXKLGmTcNt3fvAZLbw/NojBkr31GIjrY6zG/nF81AoCA1oCNMKws74MrdiriSt80nByE32oQMdWrt5lmTps4ZHTvmfX4VmTbWR0J+iPpaxJv1U9d92AAb5uR7MHPoVLFAtcM7+9hbZQGab52omv6Rl14kgcR3XliTpItgFXx1NWg4ATRI9bhJXWybwAjmY8NwcEEiLcYKtGGQebRG9Sh1EGBCIHRrtMARCVWRmXB+rbFodc0+k2Qd+NAnrKBNpWPWgCExG6HF0W7/387fayYevu+K8xqQbraCeMqFaWwcZMvZuYuguLJc/ROXPBi2lRr6BuwmcGL4nZqCIRSISUB7Cx5UY42pnmHxu1AheSubRg7uGGdWbfiPB+ZmpZjBhbYwcjCksmddERsAOop5XW9bQzXrjoOjxA4CVrvsDzNrSqd7K66APMC2huE4hPRI+ppoIyKIk/T3wF4Mga/uVd2ciApaOhv7qSvgFP
 MTTN4BRj
 7hoLRgGjbzIT76+nmKGm5phzQBf/+oTPrZHVs3xTp8OPEeEjIRNRKAqkgfZMFnk77PAoyyL6Bv9IhiVR9nKCZ309nV3f3zNec69dCsRPVy3kR5kuVz4RW2qLqwX8Icedhe/XTfjdC1p//HJTgnaVzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------=_Part_269313_221934219.1792052536996
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Bonjour =C3=A0 toute l=E2=80=99=C3=A9quipe de PHYTANIM,

Je vous contacte pour savoir si vous avez actuellement des besoins en olive=
s italiennes ou en antipasti.

Je serai pr=C3=A9sente avec GRANATA au SIAL Paris, du 17 au 21 octobre 2026=
, Pavillon 4A =E2=80=94 Stand G026.

Notre entreprise familiale produit des olives et des antipasti en Italie de=
puis 1936.

Si ces produits font partie de votre activit=C3=A9, ce serait l'occasion d'=
=C3=A9changer sur vos besoins, les gammes et les conditionnements que nous =
pourrions vous proposer.

Pr=C3=A9voyez-vous de venir au SIAL ? Si oui, quel jour vous conviendrait p=
our nous rencontrer ?

Vous pouvez simplement me r=C3=A9pondre ou choisir directement un cr=C3=A9n=
eau ici : https://granata-sial-paris-2026.com/

Une fois votre rendez-vous confirm=C3=A9, vous pourrez s=C3=A9lectionner le=
s produits qui vous int=C3=A9ressent et recevoir notre catalogue ainsi que =
nos tarifs. Nous pourrons ainsi pr=C3=A9parer notre =C3=A9change =C3=A0 l'a=
vance.

Au plaisir de vous rencontrer,
Bien cordialement,
Silvia
Assistante commerciale
GRANATA Antonio & C. S.r.l. =E2=80=94 Italie

Pour ne plus =C3=AAtre contact=C3=A9, vous pouvez r=C3=A9pondre =C2=AB non =
=C2=BB =C3=A0 ce message.
------=_Part_269313_221934219.1792052536996
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html lang=3D"fr"><body><p>Bonjour =C3=A0 toute l=E2=80=99=C3=A9quipe de PH=
YTANIM,</p><p>Je vous contacte pour savoir si vous avez actuellement des be=
soins en olives italiennes ou en antipasti.</p><p>Je serai pr=C3=A9sente av=
ec GRANATA au SIAL Paris, du 17 au 21 octobre 2026, Pavillon 4A =E2=80=94 S=
tand G026.</p><p>Notre entreprise familiale produit des olives et des antip=
asti en Italie depuis 1936.</p><p>Si ces produits font partie de votre acti=
vit=C3=A9, ce serait l&#x27;occasion d&#x27;=C3=A9changer sur vos besoins, =
les gammes et les conditionnements que nous pourrions vous proposer.</p><p>=
Pr=C3=A9voyez-vous de venir au SIAL ? Si oui, quel jour vous conviendrait p=
our nous rencontrer ?</p><p>Vous pouvez simplement me r=C3=A9pondre ou choi=
sir directement un cr=C3=A9neau ici : https://granata-sial-paris-2026.com/<=
/p><p>Une fois votre rendez-vous confirm=C3=A9, vous pourrez s=C3=A9lection=
ner les produits qui vous int=C3=A9ressent et recevoir notre catalogue ains=
i que nos tarifs. Nous pourrons ainsi pr=C3=A9parer notre =C3=A9change =C3=
=A0 l&#x27;avance.</p><p>Au plaisir de vous rencontrer,<br>Bien cordialemen=
t,<br><strong>Silvia</strong><br>Assistante commerciale<br>GRANATA Antonio =
&amp; C. S.r.l. =E2=80=94 Italie</p><p>Pour ne plus =C3=AAtre contact=C3=A9=
, vous pouvez r=C3=A9pondre =C2=AB non =C2=BB =C3=A0 ce message.</p></body>=
</html>
------=_Part_269313_221934219.1792052536996--

