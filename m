Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FA0CA9ED5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2276B0088; Mon, 12 Oct 2026 03:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6735D6B008A; Mon, 12 Oct 2026 03:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589146B008C; Mon, 12 Oct 2026 03:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327A06B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:11:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A6A114093D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:11:42 +0000 (UTC)
X-FDA: 85313104044.15.5E934EB
Received: from a6-53.smtp-out.eu-west-1.amazonses.com (a6-53.smtp-out.eu-west-1.amazonses.com [54.240.6.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1C8CA0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:11:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chennaistudentinternship.com header.s=resend header.b=mQEzyLv6;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b="J/Y2LaCU";
	spf=pass (imf15.hostedemail.com: domain of 010201a12ef3e89a-2ad1f8b5-8b0b-4c25-b6de-caee909f768c-000000@send.chennaistudentinternship.com designates 54.240.6.53 as permitted sender) smtp.mailfrom=010201a12ef3e89a-2ad1f8b5-8b0b-4c25-b6de-caee909f768c-000000@send.chennaistudentinternship.com;
	dmarc=pass (policy=none) header.from=chennaistudentinternship.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791789101;
	b=FmOFfcqF3ngD2/P6VkY6dLRr7Q++MEaxgdX6/YYsx5am1RSR+LnlwHe4rZS4cKhCJ082M6
	87mnMgZzpuamDW6BMNUMbKUeGOwPrT05Q5XBc1p6ARRK4JpYPkckBZ9+PEMN9s4NP0dgJh
	M0qtgDVZ9ZpCX7SxeT7kwUdONH3kwIE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chennaistudentinternship.com header.s=resend header.b=mQEzyLv6;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b="J/Y2LaCU";
	spf=pass (imf15.hostedemail.com: domain of 010201a12ef3e89a-2ad1f8b5-8b0b-4c25-b6de-caee909f768c-000000@send.chennaistudentinternship.com designates 54.240.6.53 as permitted sender) smtp.mailfrom=010201a12ef3e89a-2ad1f8b5-8b0b-4c25-b6de-caee909f768c-000000@send.chennaistudentinternship.com;
	dmarc=pass (policy=none) header.from=chennaistudentinternship.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791789101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Cucbqc72cSYD8C7VdPe7k9NzOE6rA83piziy7EdPbCE=;
	b=hmqipyye/oUvsw6dHJCbgMG05d6QTbitwj9ttzMjuw1nbny3LsvGHGpVtS/3uBlODgtlLh
	SN6eT13ceyRRbRu+ifmzoFUpKjiECgYJ15dt4CPQ+25G+IBm7zs0prhT8CaXqsHcDhM+y+
	Mohz1Iet1fIMshGsaJGTDy/hWSIrvKI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=chennaistudentinternship.com; t=1791789099;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=LeeA1gBtxEaySOzYzsygD1m3lDASpLft2cFvR9LDpL8=;
	b=mQEzyLv6flHlJuAxRmk6sb9psC3bnae/voEs3VaG5xDvvqpiUibEUXJTPRPv8upa
	DLXv0aBDkqz8PncYGLZwaVJHAHOmgT1xWOr+/cOnhI6Z0eLwR3/7y8t37mXDZq2gbZL
	eUMZw+8FZF7D4tYJDxyowSS/9KBckRMKFvYO4yiU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1791789099;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=LeeA1gBtxEaySOzYzsygD1m3lDASpLft2cFvR9LDpL8=;
	b=J/Y2LaCUSBsK/4Ow32qktQB4D42OK5S6n1wreY/bJnRRHlxEenNuOJdLc9cf6Qjp
	0VScQRm8Kbbaq2Q7MHJmtGIZIREpUkgP8/A9A2KOkzVzLAv9rM84rMXRGgc6uz2u3gx
	l8sUJQQ5kF/p6UtknbCIKg/5ftRxxdw3kvD1Rt5g=
From: Stephanie Collin <contact@chennaistudentinternship.com>
To: linux-mm@kvack.org
Subject: ROLLIN JEAN PIERRE a des dettes ? Ne liquidez rien avant de lire
 ceci
Message-ID: <010201a12ef3e89a-2ad1f8b5-8b0b-4c25-b6de-caee909f768c-000000@eu-west-1.amazonses.com>
Date: Mon, 12 Oct 2026 07:11:39 +0000
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-75ecc4da8463d12d-Part_1"
Feedback-ID: :1.eu-west-1.PI927KaBJkHpGi5FL/XpRMwgI4Gx+ZvSSrK4S5HzHHaZyR2xaMuqFptZL2j8shi+gCbCl47dk3d69PsptXTZ4vllM2mkjtk64ftRqkAL4y70Jyj+PjwMDtkNv0c0Xv+k811ALegiVLf8fhUBqmxLplwnOkYAx5lj1nPug5j8Tt0=:1.eu-west-1.KEYBhYy5skZtLAf2ooWkoQwfhj0g1VAvm2T4fzvEpSk=:AmazonSES
X-SES-Outgoing: 2026.10.12-54.240.6.53
X-Stat-Signature: n17noa694t55w77b4ih3p98ird7gn7o6
X-Rspamd-Queue-Id: D1C8CA0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791789100-687757
X-HE-Meta: U2FsdGVkX1/A/ZarbHu0oLeLA5QhMwm/NCRXmMnE6BfIukpPD6KG5VYdZC0B6ZzlcqPISJb7WG5CLLmIH57UvTWCOBPbrNVDosB3QsW+tkfbs1eyFPF69pugMbrz0ZibcQdAhmpCvf4BEH7xckAZe6RliYkmCZfQZtmEadTzc4qzl6V+CFcjsP+m1DWS2H1h8DSAxhXBdp0VlKDk9w9gRMFaIyxoh83jBp3Dn45vf33BIrSkBr9P0S/dRMNpQNsJGUkrS4IJoZImENpxfB1SscfUPGeQrx28qP2Tb7c2SDvZ6GVN8yhd3y0yY9UoRwulswB3XUy9+UYCdTUmMUTYhl+FrHasmR7mGqeEUYY7a9xBp6B9qAu8GN7YtB+MAwUXS+iUzEzewL2rkYJZB2Fq+9CJL61Uw7vOHRVdl+8dkeLsmDgqdWH/U6iIf8Zsh5PAe3cfpT/9LLBHCbupqXKnXrmi50AVUSvij4xbXyptATVClFFs2TFu/SGapgSbnJBGQoiD5OCWsveJ5ahNiitJxFdgDIaRB4jKvMjxUubEmwgng5SFORv9+npe/t3KzRyWhRntCPKUqYXhsEh1nd0beVu/preEQPmUuVmq3N9vUwcSHtppDj0ILc3IqVw6CvOpZh8X/74NCZioO8fQdM06BB52Z1xFsWwo9id2ZOcMgcjDgfHJwS0aKwdI50lRVzC/uOYean7uiRpS0qRBNMtIUmYcmFMiyGoel9ZGLjdo9IZddm/Hcs5rr/0otdeqmyO5jW3rTFfp7em242vD5rqonW/DBvIOR37mZyX8I//DgBitIEH0fj+iLMnogp4CigXAobhR2RZHJi+hytJMyKUuKhXc4Hedov2SCOTrUV+o9e0qPbqxm4kUxs2UyewGfqMs1BBug05Shx1io2ns9xtW5YPG+Qr5TalkgJ/C6n+YI6hPBy7pDLIeIMEsIPeahmw0ei/gtFH9O1yzA9GsN73
 SCnO0DTn
 0P3jeNQK3oPmCT7CBBAIOQI2INmnQ/66IawwlL9nFaOWdObOxoDn1u3TygWGZ3TBCXA8OxGfgnwrORG/quTAlVc12mFBqNG0HmXIOrhUGhxXTMFYmIla0LUJ8rzipEyOnpnc16M86QQA9kdEAc5Qzvyut8iNRqd35UbLnOsUJZ2hQlWkxdVCudBhmiEEcrATLb2GKT2PgULKYcB1EaEM6XntbKdgCk6u4UEM1j3pBSGHBpIfZp+R62QVtF2WjMW1Jt/Z2qLj1M9bQXgcZqBfE3/Ws8iq6Z9CN6VFmo/Ei3xaLaX1PnYvNgjUB8EcySPLPTCo3lD68OjsySVedAiHv1InO/RXrbYdrG1rC/ADhBAh577M9tEhnLbCZQuMrHHUEMwQox4dhzUm4x+5Lio3bwB3WUa8fx0y6UJltPUyIrpoiz4Q9vrXBQn7JVU/BIA2ZyNJ5k43or/Bb+Fs5/2BYjdcjEeV6YtvNN4uDomOSUuy++2En4Vz9XW4GMVzlZk6z3iyozfIVb1jx1pL7vANUm2RHqvJBnle1s2oFBDxUXAsuIgrXdXkU03kb9/8pIz+pOK0jea1qklv0XF7pi7WbsdGdfrsMfcAKHGOGjhba90CRYxiSxzafLeBMBgCDoO5fdeANWiVP7lqmlmpbZJGhwhZe3zi72zMhdb0OoRqfWP26SOv6gqlm9XQFPrTcZTyQTUSteiaHSo053pz6SWd8cc7BUmJT4Av1Oz4RNuUaZkYrc38HXzXz8VeSPFnxyRrZy7hWwHB1aoAsaarlMKIYwI9dVLdIStV2HDhDq2Au1xcVyNhCpez1asbuicD4hhbpq+e/A6AasZVDR671yk+WtdfEVT8mnh5qOd5WsVyu2GRp4AIxdwvFiQAMx/fIyUPCsydDM64+JyPAgZfr+fijE8mxW8U663H/D3dgykdnIGsjD46bIbbyVDZfmf5u6UMIbGRTtYbwEEc3Nek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----_NmP-75ecc4da8463d12d-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

Vous r=C3=A9fl=C3=A9chissez =C3=A0 liquider ROLLIN JEAN PIERRE =
(entreprises de nettoyage) =C3=A0 HAREVILLE ?
Vous imaginez que =C3=A7a va =
=C3=AAtre long, cher, et que ROLLIN JEAN PIERRE va se retrouver avec des =
dettes, des imp=C3=B4ts, et peut-=C3=AAtre un contr=C3=B4le fiscal sur le =
dos ?

Et s'il existait une autre voie, l=C3=A9gale, pour fermer ROLLIN =
JEAN PIERRE sans aucun de ces inconv=C3=A9nients ?

La m=C3=A9thode que nous appliquons est simple :

Z=C3=A9ro risque : ni =
interdiction de g=C3=A9rance, ni comblement de passif, ni faute de gestion.

Pas de paiement : vous cl=C3=B4turez ROLLIN JEAN PIERRE malgr=C3=A9 les =
dettes, sans n=C3=A9gocier, sans tribunal.

Z=C3=A9ro contr=C3=B4le : ni le=
 fisc, ni l'URSSAF ne se retournent contre vous ni contre ROLLIN JEAN =
PIERRE.

Z=C3=A9ro d=C3=A9lai : en quelques semaines, tout est termin=C3=A9=
, vous tournez la page.

On ne liquide pas ROLLIN JEAN PIERRE au sens =
classique du terme.
Nous appliquons un processus juridique m=C3=A9connu qui=
 neutralise tout : dettes, URSSAF, imp=C3=B4ts, contr=C3=B4les.

Notre =C3=A9quipe a d=C3=A9j=C3=A0 sorti des centaines de patrons de =
situations bloqu=C3=A9es.

Nous pouvons vous montrer comment en 15 minutes,=
 sans engagement.
Voulez-vous qu'on s'appelle cette semaine pour en =
discuter ?

Oui, je veux comprendre comment faire : mailto:info@agence-onp.=
com?subject=3DDemande%20d%27informations%20-%20ROLLIN JEAN =
PIERRE&body=3DBonjour%2C%0A%0AJe%20souhaite%20en%20savoir%20plus%20sur%20le=
%20fonctionnement%20pour%20l%27entreprise%20%3A%20ROLLIN JEAN PIERRE.=
%0A%0AVous%20pouvez%20me%20joindre%20au%20num%C3%A9ro%20%3A%20%5B%20num%C3%=
A9ro%20mobile%20%5D%0A%0ACordialement

Bien =C3=A0 votre =C3=A9coute,

Stephanie Collin
Sp=C3=A9cialiste en liquidation d'entreprise - HAREVILLE =
(88800)

---

Cet e-mail est destin=C3=A9 =C3=A0 linux-mm@kvack.org dans le=
 cadre d'une prospection commerciale pour des services de liquidation =
d'entreprise. En application du R=C3=A8glement G=C3=A9n=C3=A9ral sur la =
Protection des Donn=C3=A9es (RGPD - R=C3=A8glement UE 2016/679) et de la =
loi Informatique et Libert=C3=A9s du 6 janvier 1978 modifi=C3=A9e, vous =
b=C3=A9n=C3=A9ficiez d'un droit d'acc=C3=A8s, de rectification, =
d'effacement, d'opposition et de portabilit=C3=A9 de vos donn=C3=A9es =
personnelles. Les informations contenues dans ce message sont =
confidentielles et exclusivement r=C3=A9serv=C3=A9es =C3=A0 leur =
destinataire. Si vous l'avez re=C3=A7u par erreur, merci d'en informer =
l'exp=C3=A9diteur et de supprimer ce message.

Pour ne plus recevoir nos =
communications, mailto:desinscription@agence-onp.com?=
subject=3DDemande%20de%20d%C3%A9sinscription&body=3DBonjour%2C%0A%0AJe%20so=
uhaite%20me%20d%C3%A9sinscrire%20de%20vos%20communications.=
%0A%0AMerci%20de%20bien%20vouloir%20supprimer%20mon%20adresse%20e-mail%20%2=
8linux-mm@kvack.org%29%20de%20votre%20liste%20de%20diffusion.=
%0A%0ACordialement.. Pour toute r=C3=A9clamation ou interrogation, =
mailto:abuse@agence-onp.com?subject=3DSignalement%20%2F%20Contact&body=3DBo=
njour%2C%0A%0AJe%20vous%20contacte%20concernant%20le%20message%20re%C3%A7u%=
20%C3%A0%20l%27adresse%20linux-mm@kvack.org.%0A%0AMotif%20de%20mon%20messag=
e%20%3A%0A%0A%28pr%C3%A9cisez%20ici%20votre%20demande%20ou%20signalement%29=
%0A%0ACordialement..
----_NmP-75ecc4da8463d12d-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0">
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>ROLLIN JEAN PIERRE a des dettes ? Ne liquidez rien avant de lire =
ceci</title>
</head>

<body style=3D"font-family:Arial, Helvetica, =
sans-serif;font-size:14px;color:#222;line-height:1.5;">

  <!-- Pr=C3=A9header masqu=C3=A9 -->
  <span style=3D"display:none;visibil=
ity:hidden;opacity:0;height:0;width:0;overflow:hidden;">
    ROLLIN JEAN PIERRE : la m=C3=A9thode qui neutralise tout
  </span>

  <p>Bonjour,</p>

  <!-- Phrase d'introduction -->
  <p><b>Vous r=C3=A9fl=C3=A9chissez =C3=A0 liquider ROLLIN JEAN PIERRE =
(entreprises de nettoyage) =C3=A0 HAREVILLE ?</b><br>
  Vous imaginez que =C3=A7a va =C3=AAtre long, cher, et que ROLLIN JEAN =
PIERRE va se retrouver avec des dettes, des imp=C3=B4ts, et peut-=C3=AAtre =
un contr=C3=B4le fiscal sur le dos ?</p>

  <!-- Question sur la =
m=C3=A9thode -->
  <p><b>Et s'il existait une autre voie, l=C3=A9gale, pour=
 fermer ROLLIN JEAN PIERRE sans aucun de ces inconv=C3=A9nients ?</b></p>

  <!-- Annonce m=C3=A9thode -->
  <p>La m=C3=A9thode que nous appliquons =
est simple :</p>

  <!-- Liste des 4 points Z=C3=A9ro -->
  <ul style=3D"margin:10px 0 10px 20px;padding:0;">
    <li style=3D"margin-bottom:6px;"><b>Z=C3=A9ro risque :</b> ni =
interdiction de g=C3=A9rance, ni comblement de passif, ni faute de gestion.=
</li>
    <li style=3D"margin-bottom:6px;"><b>Pas de paiement :</b> vous =
cl=C3=B4turez ROLLIN JEAN PIERRE malgr=C3=A9 les dettes, sans n=C3=A9gocier=
, sans tribunal.</li>
    <li style=3D"margin-bottom:6px;"><b>Z=C3=A9ro =
contr=C3=B4le :</b> ni le fisc, ni l'URSSAF ne se retournent contre vous ni=
 contre ROLLIN JEAN PIERRE.</li>
    <li style=3D"margin-bottom:6px;"><b>Z=
=C3=A9ro d=C3=A9lai :</b> en quelques semaines, tout est termin=C3=A9, vous=
 tournez la page.</li>
  </ul>

  <!-- Explication processus -->
  <p>On ne liquide pas ROLLIN JEAN PIERRE au sens classique du terme.

  <!-- Preuve sociale -->
  <br>Nous appliquons un processus juridique =
m=C3=A9connu qui neutralise tout : dettes, URSSAF, imp=C3=B4ts, =
contr=C3=B4les.</p>

  <!-- Preuve sociale 2 -->
  <p><b>Notre =C3=A9quipe =
a d=C3=A9j=C3=A0 sorti des centaines de patrons de situations bloqu=C3=A9es=
.</b></p>

  <!-- Proposition d'appel -->
  <p>Nous pouvons vous montrer =
comment en 15 minutes, sans engagement.

  <!-- Question finale -->
  <br>Voulez-vous qu'on s'appelle cette semaine pour en discuter ?</p>

<!-- CTA -->
<table role=3D"presentation" cellspacing=3D"0" =
cellpadding=3D"0" border=3D"0" style=3D"margin:20px 0;">
  <tr>
    <td>
      <a href=3D"mailto:info@agence-onp.com?subject=3DDemande%20d%27informa=
tions%20-%20ROLLIN JEAN PIERRE&body=3DBonjour%2C%0A%0AJe%20souhaite%20en%20=
savoir%20plus%20sur%20le%20fonctionnement%20pour%20l%27entreprise%20%3A%20R=
OLLIN JEAN PIERRE.%0A%0AVous%20pouvez%20me%20joindre%20au%20num%C3%A9ro%20%=
3A%20%5B%20num%C3%A9ro%20mobile%20%5D%0A%0ACordialement"
         style=3D"display:inline-block;padding:14px =
40px;background:#2e7d32;color:#ffffff;text-decoration:none;border-radius:6p=
x;font-weight:bold;font-size:15px;">
         Oui, je veux comprendre =
comment faire
      </a>
    </td>
  </tr>
</table>

  <!-- Signature -->
  <p>
    Bien =C3=A0 votre =C3=A9coute,<br><br>
    <strong>Stephanie =
Collin</strong><br>
    Sp=C3=A9cialiste en liquidation d'entreprise - =
HAREVILLE (88800)
  </p>

  <br>

  <!-- Mentions et d=C3=A9sinscription =
-->
  <footer>
    <p style=3D"font-size:12px;color:#888;text-align:left;li=
ne-height:1.5;">
      Cet e-mail est destin=C3=A9 =C3=A0 linux-mm@kvack.=
org dans le cadre d'une prospection commerciale pour des services de =
liquidation d'entreprise. En application du R=C3=A8glement =
G=C3=A9n=C3=A9ral sur la Protection des Donn=C3=A9es (RGPD - R=C3=A8glement=
 UE 2016/679) et de la loi Informatique et Libert=C3=A9s du 6 janvier 1978 =
modifi=C3=A9e, vous b=C3=A9n=C3=A9ficiez d'un droit d'acc=C3=A8s, de =
rectification, d'effacement, d'opposition et de portabilit=C3=A9 de vos =
donn=C3=A9es personnelles. Les informations contenues dans ce message sont =
confidentielles et exclusivement r=C3=A9serv=C3=A9es =C3=A0 leur =
destinataire. Si vous l'avez re=C3=A7u par erreur, merci d'en informer =
l'exp=C3=A9diteur et de supprimer ce message.
      <br><br>

      Pour ne plus recevoir nos communications,
      <a =
href=3D"mailto:desinscription@agence-onp.com?subject=3DDemande%20de%20d%C3%=
A9sinscription&body=3DBonjour%2C%0A%0AJe%20souhaite%20me%20d%C3%A9sinscrire=
%20de%20vos%20communications.%0A%0AMerci%20de%20bien%20vouloir%20supprimer%=
20mon%20adresse%20e-mail%20%28linux-mm@kvack.org%29%20de%20votre%20liste%20=
de%20diffusion.%0A%0ACordialement."
         style=3D"color:#888;">
        cliquez ici
      </a>.

      Pour toute r=C3=A9clamation ou =
interrogation,
      <a href=3D"mailto:abuse@agence-onp.com?=
subject=3DSignalement%20%2F%20Contact&body=3DBonjour%2C%0A%0AJe%20vous%20co=
ntacte%20concernant%20le%20message%20re%C3%A7u%20%C3%A0%20l%27adresse%20lin=
ux-mm@kvack.org.%0A%0AMotif%20de%20mon%20message%20%3A%0A%0A%28pr%C3%A9cise=
z%20ici%20votre%20demande%20ou%20signalement%29%0A%0ACordialement."
         style=3D"color:#888;">
        cliquez ici
      </a>.
    </p>
  </footer>

</body>
</html>
----_NmP-75ecc4da8463d12d-Part_1--

