Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F9C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cheapcompositebats.com header.i=@cheapcompositebats.com header.a=rsa-sha256 header.s=resend header.b=GF5RNxHY;
	dkim=pass (1024-bit key, unprotected) header.d=amazonses.com header.i=@amazonses.com header.a=rsa-sha256 header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=usra0Pht
Received: by kanga.kvack.org (Postfix)
	id 5EB836B05B3; Wed, 11 Nov 2026 08:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C116B05B4; Wed, 11 Nov 2026 08:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B416B05B5; Wed, 11 Nov 2026 08:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CBB46B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:43:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5676402EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:43:49 +0000 (UTC)
X-FDA: 85422956178.05.44DC496
Received: from a3-26.smtp-out.eu-west-1.amazonses.com (a3-26.smtp-out.eu-west-1.amazonses.com [54.240.3.26])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB13040005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:43:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cheapcompositebats.com header.s=resend header.b=GF5RNxHY;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=usra0Pht;
	dmarc=pass (policy=none) header.from=cheapcompositebats.com;
	spf=pass (imf17.hostedemail.com: domain of 010201a1cad9ad94-a92a6a18-2893-4ffe-8963-6a3266f86524-000000@send.cheapcompositebats.com designates 54.240.3.26 as permitted sender) smtp.mailfrom=010201a1cad9ad94-a92a6a18-2893-4ffe-8963-6a3266f86524-000000@send.cheapcompositebats.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794404628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BPL94qBP0bvJcIJ2euVyrYUqikSZwTAMNE/4mr/0Sig=;
	b=t2RU6m3F/zxlmpS7j/M6iBb0K6Rqx2oNzP0beOyZVqYFleifA9CF5DOWQabyBY4xRos62F
	0KRB4XQnUJ2IaqKln53U7nsUblaXGrXDJAXdZJAOyD8FeHmlFtphyKDSGDc+FeZ0XYGopr
	xNVOYIW2qAtH089eGFUVbeeYsc5VzsA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794404628;
	b=lWINLP2YJP7oeqN+FJvJ8ijofIl3VmFRNUduiDwg3wwcqfYdk1zXsw9sOrOmdl1qfmClsg
	zKS/Eag3Xs672DUrTzHuAEa/PYo39VxN3PzGQ9J6VNNqT8cEC2AWIjNW47rIvjKBXHAEkz
	R4vhaV6E8nI81InK01yWyJUsGO7eMwY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cheapcompositebats.com header.s=resend header.b=GF5RNxHY;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=usra0Pht;
	dmarc=pass (policy=none) header.from=cheapcompositebats.com;
	spf=pass (imf17.hostedemail.com: domain of 010201a1cad9ad94-a92a6a18-2893-4ffe-8963-6a3266f86524-000000@send.cheapcompositebats.com designates 54.240.3.26 as permitted sender) smtp.mailfrom=010201a1cad9ad94-a92a6a18-2893-4ffe-8963-6a3266f86524-000000@send.cheapcompositebats.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=cheapcompositebats.com; t=1794404626;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=RWYDswHyArxemu4gVE3RxLwEHqKloGqXoEeqfi+GPrs=;
	b=GF5RNxHYvCBDF9+Boogs4lvZHycuYOTt3OhUsRd9ESu4SMzTIxgBW2liLf1tecB0
	n5ZqV9HcJpYCLjdJuhlhlfB3d2DX7U4RuW47Sv2/P3zV8cEHPOVX6a7Zy6klaCEQt9N
	cghfwmmJx473kYHNKXqNCVleW6U6SbtQrmY3lMwY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1794404626;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=RWYDswHyArxemu4gVE3RxLwEHqKloGqXoEeqfi+GPrs=;
	b=usra0PhtYwPq4Y8xzMNvefi3zYnHrzdk3qaqddFDGGF0odkRWb06xaJPEKZrFkJH
	AtdMYjF253NiC8uV1vYEgc//LrfbGfghlLR39Fp5r6ngCAKqqzAoAwX08CgqLKrgYUo
	jeFlQn8VT/fFfNnDLYldqjvYMwO/BJ5B6rYt8VOQ=
From: Stephanie Vidal <contact@cheapcompositebats.com>
To: linux-mm@kvack.org
Subject: =?UTF-8?Q?Remettre_les_dettes_de_ROLLIN_JEAN_PIERR?=
 =?UTF-8?Q?E_=C3=A0_z=C3=A9ro=2C_l=C3=A9galement?=
Message-ID: <010201a1cad9ad94-a92a6a18-2893-4ffe-8963-6a3266f86524-000000@eu-west-1.amazonses.com>
Date: Wed, 11 Nov 2026 13:43:45 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-61bb44a5f7189f37-Part_1"
Feedback-ID: :1.eu-west-1.nGOymYh2eFtX6JAKshudFQu/+855x7PwT1L5WYbUeVOifLBcp1qbf+J1j/H5LVaJ0q5rHxSVaL9I+/dAdi1BgKPcgFrsUk/tBccZNQ2WUVWVhNmHOckl5QP44MKkEZ3MK3C1gEm+u+Bdu+a/q4NKxtPXBdDwcRp/w/+1snAqlOw=:1.eu-west-1.KEYBhYy5skZtLAf2ooWkoQwfhj0g1VAvm2T4fzvEpSk=:AmazonSES
X-SES-Outgoing: 2026.11.11-54.240.3.26
X-Stat-Signature: mjueb8xomabbemp1knw4gzyfca47eeqy
X-Rspam-User: 
X-Spam-Status: No, score=1.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB13040005
X-HE-Tag: 1794404627-647653
X-HE-Meta: U2FsdGVkX1/jSy2pZiXMo1g3EGjM95GhU6j/09agX/mDEO1PB0G8/fVvZp0Ke+9BFzfiN3lt0wZV7OraO17kBd/uZVCDd99yOixtu5Mto6ixUCDzYq0bAiBG3e0EFo8p0XaETcujy8vGvBczaYfw1cVndjSLvwNVJ6HC5EHrRqbwr5rA5rdTcLQqq1IUAxPTRLrIVQw7AWloBvayZuc7fHeKcr8hBWT4gFivZlH/crBU42/RCJ3cWCaulVktH4vx9sHa0S9LDSaaaWf3xbswiXbLAb+3wW2/AnY9KYuE6WGw2mD/kJWKS1ornv0GYbKzVKPsrZFUHOzCi8ZpK+hdRHv2CiStlX1AvXAk5wlJ5mfegs/tmnDBTjhc9AnjH84tauDxdQvhaxsI41ztqBSUnKEJ+jyD4bm2qOK34+kmIKuAM8c+yIWV9EpaLXiW8weoTyIp7tR/tzAAMbmu7V6DGviJQq662iWmTuLFyZHeea6BG8Qoh6H+5aTaGWeYvmZTTuHhBT7thKrQ1QC/J8Z04G8AH0F7t4raF+WJQ3tWj0bZntbUSE/ImdcXzss/JKUsU0WmAFq2mZQnz6Jixq/bgdHBomCCNJqJpTly4V1MheFhi8pG5knPLJP1Hh49IafP8ZMI+Til00QSqUhzGnXgyL4ATwAtZfY0x0vKWWeW1iIv17QiThvtOKFC0/6UVaVyib12t8oac9HWw9M2ha+CcVVML+9MykzKP5v8IsT7pOTl/dKtP5bggIblJcb9OMLMv25Mtgn+7sfUXbDhXspt+FjTVzJSPxqnITKkZBmp0xmWwNVuL/orBjTOINN5pLYYBXVSx73gdAypq4XpPN/gck277++xOlqPNgT8N7SeTx27CPgT9Lj/D4QA/grTkOLcgH5Vc6z7DGD0d9SQuNilc5N88AyiCUGfwb2V1nfi0Nqbku0enAUKfIRiEgIhOB1ofbqO6WdWo2EQp87ivXP
 h4y9cnUL
 O59ZZhsqQYVr70jPYyvcoprOCze1XdUpPuEozKyqj/kWD4TDNGjVGWJgK75c43mznJPAzb91UZd5XOgZYnXIrk9sK1T2peLq6gxl2MbTx5rGTVQf7iyC9YZQQ0sCyp2M+/i6ibq6R61DPJyI1pzGgLk4z+kRQpO7WEhiLCgfKx2tJNZFWAll0wdhyCbMyPNeSMIrgpHXG7kkl/a0Wkpxuvc9PVv2vMy0pbkU7WF3EtjuUtEj6ArREsmUOw4R0BQoDAolS2uNiT2ZnerY3fAdp80ECVdNuhxUw3usFg8cFa7xDteIQFxNkg0RlunkHWbOIpsZqTZ5tGqjJntq3MDN8r1g72c7Ticn4p1BdAXyJ5W/cTDNENlWlPrE43CACfeBWwDl3ShgXOH6wbpPS1aflPzqnSMjyqvVppN6qwevFPS0pIDAoTkClWcfeAnq0SXq4y1W0fBR+ldKWDLCYlXjKlnkOtNburzNQgAtufouee2NUAdsx2oNmqw3ZX8Cuifg2sPm2LtmTQL8zyDuwIxEEKD7oJ3pmK6FveEv+k0CcMAEaJj/K1k7fRWhVhzXYDNCpVnha0CzzuetWg1tcUHyTGpXon7efDw6qWu717MzEOsYVW3LFoE6hRJSbnDvXzmBd+c7ZdAv9Jp99te8M/T+hVQHnhM8onX7XpxLrNAlQ5551SoUbq7hwmLZgKVySWlMCcrLpPFSPXfulllyTHtM/Wq5FKyBUMFAYwZJmEoJUGGmErozhH6q/Hgl5N5TkCGvKuDvcGeuNCzDlkmrtVgP/75R+1NAj4zvCzX0uy4UXlmf3DTrcW0EcmM7V6C/6orYTlttnbcOClExQx9HcFjrSZq5WHlWqVN37thF+lFXCMMSBhVzd6nUNfXxk7wnFneebt7s2Gtg4ecIkqrtRhrCElvZEAy5zy1h1YFeTQpmFTJ04kLMLACuNiLG+ebq0R5CopkTvhe7ExInZeOvN7LrwlFNTvXSR
 SPUkYIRS
 /YDCkaQCqbSLIO4kVUtgMB7Pss7MzE5JzXN67OHJ0liH71yqRqg7/IMTACB2y2Qa3Zr27YS+oE+G+LZz5I6VQlGR+rZISj1u4cQt6moAf1cNZQcdQRLja6ieBUOU/JMRgaII6DiZ5YXm8ZdioFxZvA+pNTn6JMxN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

----_NmP-61bb44a5f7189f37-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

Imaginez un instant : les dettes de ROLLIN JEAN PIERRE remises =
=C3=A0 z=C3=A9ro.
URSSAF, imp=C3=B4ts, TVA, fournisseurs, banques, emprunts=
, loyers, salaires=E2=80=A6 tout y passe.

On a recours =C3=A0 un processus=
 juridique m=C3=A9connu qui neutralise toutes les dettes de ROLLIN JEAN =
PIERRE.

Pour vous, aucun risque.
Z=C3=A9ro interdiction de g=C3=A9rance, =
pas de comblement de passif, ni faute de gestion, pas de contr=C3=B4le =
fiscal, pas de contr=C3=B4le URSSAF.

En quelques semaines, tout est =
termin=C3=A9. Vous tournez la page. Et c'est parfaitement l=C3=A9gal.

Notre cabinet s'occupe de tout, de A =C3=A0 Z.
Des milliers de dirigeants =
sont d=C3=A9j=C3=A0 pass=C3=A9s par l=C3=A0.

Vous voulez qu'on en discute =
cette semaine ?
Z=C3=A9ro engagement, et je vous explique tout en =
d=C3=A9tail.

Oui, je veux remettre tout =C3=A0 z=C3=A9ro : =
mailto:info@agence-onp.com?subject=3DDemande%20d%27informations%20-%20ROLLI=
N JEAN PIERRE&body=3DROLLIN JEAN PIERRE%0A%0AVous%20pouvez%20me%20joindre%2=
0au%20%3A%20%5B%20VOTRE%20NUM%C3%89RO%20DE%20MOBILE%20%5D

Bien cordialement,

Stephanie Vidal
Cabinet Conseil en d=C3=A9sendettement =
- HAREVILLE (88800)

---

Cet e-mail est adress=C3=A9 =C3=A0 linux-mm@kvack=
.org dans le cadre d'une prospection commerciale l=C3=A9gitime. =
Conform=C3=A9ment au R=C3=A8glement G=C3=A9n=C3=A9ral sur la Protection des=
 Donn=C3=A9es (RGPD - R=C3=A8glement UE 2016/679) et =C3=A0 la loi =
Informatique et Libert=C3=A9s du 6 janvier 1978 modifi=C3=A9e, vous =
disposez d'un droit d'acc=C3=A8s, de rectification, d'effacement, =
d'opposition et de portabilit=C3=A9 concernant vos donn=C3=A9es =
personnelles. Les informations contenues dans ce message sont =
confidentielles et destin=C3=A9es exclusivement =C3=A0 son destinataire. Si=
 vous l'avez re=C3=A7u par erreur, merci d'en informer l'exp=C3=A9diteur et=
 de le supprimer.

Pour ne plus recevoir nos e-mails, =
mailto:desinscription@agence-onp.com?subject=3DDemande%20de%20d%C3%A9sinscr=
iption&body=3DBonjour%2C%0A%0AJe%20souhaite%20me%20d%C3%A9sinscrire%20de%20=
vos%20communications.%0A%0AMerci%20de%20bien%20vouloir%20supprimer%20mon%20=
adresse%20e-mail%20%28linux-mm@kvack.org%29%20de%20votre%20liste%20de%20dif=
fusion.%0A%0ACordialement. Pour toute r=C3=A9clamation ou interrogation, =
mailto:abuse@agence-onp.com?subject=3DSignalement%20%2F%20Contact&body=3DBo=
njour%2C%0A%0AJe%20vous%20contacte%20concernant%20le%20message%20re%C3%A7u%=
20%C3%A0%20l%27adresse%20linux-mm@kvack.org.%0A%0AMotif%20de%20mon%20messag=
e%20%3A%0A%0A%28pr%C3%A9cisez%20ici%20votre%20demande%20ou%20signalement%29=
%0A%0ACordialement.
----_NmP-61bb44a5f7189f37-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0">
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>Remettre les dettes de ROLLIN JEAN PIERRE =C3=A0 z=C3=A9ro, =
l=C3=A9galement</title>
</head>

<body style=3D"font-family:Arial, =
Helvetica, sans-serif;font-size:14px;color:#222;line-height:1.5;">

  <!-- Pr=C3=A9header masqu=C3=A9 -->
  <span style=3D"display:none;visibil=
ity:hidden;opacity:0;height:0;width:0;overflow:hidden;">
    ROLLIN JEAN PIERRE : URSSAF, imp=C3=B4ts, TVA, fournisseurs=E2=80=A6 =
tout =C3=A0 z=C3=A9ro
  </span>

  <p>Bonjour,</p>

  <!-- Accroche -->
  <p><b>Imaginez un instant : les dettes de ROLLIN JEAN PIERRE remises =
=C3=A0 z=C3=A9ro.</b><br>
  URSSAF, imp=C3=B4ts, TVA, fournisseurs, banques=
, emprunts, loyers, salaires=E2=80=A6 tout y passe.</p>

  <!-- Annonce m=C3=A9thode -->
  <p>On a recours =C3=A0 un processus =
juridique m=C3=A9connu qui neutralise toutes les dettes de ROLLIN JEAN =
PIERRE.</p>

  <!-- Annonce z=C3=A9ro risque + texte encha=C3=AEn=C3=A9 -->
  <p><b>Pour vous, aucun risque.</b><br>
  Z=C3=A9ro interdiction de =
g=C3=A9rance, pas de comblement de passif, ni faute de gestion, pas de =
contr=C3=B4le fiscal, pas de contr=C3=B4le URSSAF.</p>

  <!-- R=C3=A9sultat d=C3=A9lai -->
  <p>En quelques semaines, tout est =
termin=C3=A9. Vous tournez la page. <b>Et c'est parfaitement l=C3=A9gal.=
</b></p>

  <!-- Prise en charge -->
  <p>Notre cabinet s'occupe de tout, =
de A =C3=A0 Z.

  <!-- Preuve sociale -->
  <br>Des milliers de dirigeants =
sont d=C3=A9j=C3=A0 pass=C3=A9s par l=C3=A0.</p>

  <!-- Proposition -->
  <p>Vous voulez qu'on en discute cette semaine ?

  <!-- Rassurance -->
  <br>Z=C3=A9ro engagement, et je vous explique tout en d=C3=A9tail.</p>

<!-- CTA -->
<table role=3D"presentation" cellspacing=3D"0" =
cellpadding=3D"0" border=3D"0" style=3D"margin:20px 0;">
  <tr>
    <td>
      <a href=3D"mailto:info@agence-onp.com?subject=3DDemande%20d%27informa=
tions%20-%20ROLLIN JEAN PIERRE&body=3DROLLIN JEAN PIERRE%0A%0AVous%20pouvez=
%20me%20joindre%20au%20%3A%20%5B%20VOTRE%20NUM%C3%89RO%20DE%20MOBILE%20%5D"
         style=3D"display:inline-block;padding:14px =
40px;background:#2e7d32;color:#ffffff;text-decoration:none;border-radius:6p=
x;font-weight:bold;font-size:15px;">
         Oui, je veux remettre tout =
=C3=A0 z=C3=A9ro
      </a>
    </td>
  </tr>
</table>

  <!-- Signature -->
  <p>
    Bien cordialement,<br><br>
    <strong>Stephanie Vidal</strong><br>
    Cabinet Conseil en =
d=C3=A9sendettement - HAREVILLE (88800)
  </p>

  <br>

  <!-- Mentions et d=C3=A9sinscription -->
  <footer>
    <p style=3D"font-size:12px;color:#888;text-align:left;line-height:1.=
5;">
      Cet e-mail est adress=C3=A9 =C3=A0 linux-mm@kvack.org dans le =
cadre d'une prospection commerciale l=C3=A9gitime. Conform=C3=A9ment au =
R=C3=A8glement G=C3=A9n=C3=A9ral sur la Protection des Donn=C3=A9es (RGPD -=
 R=C3=A8glement UE 2016/679) et =C3=A0 la loi Informatique et Libert=C3=A9s=
 du 6 janvier 1978 modifi=C3=A9e, vous disposez d'un droit d'acc=C3=A8s, de=
 rectification, d'effacement, d'opposition et de portabilit=C3=A9 =
concernant vos donn=C3=A9es personnelles. Les informations contenues dans =
ce message sont confidentielles et destin=C3=A9es exclusivement =C3=A0 son =
destinataire. Si vous l'avez re=C3=A7u par erreur, merci d'en informer =
l'exp=C3=A9diteur et de le supprimer.
      <br><br>

      Pour ne plus recevoir nos e-mails,
      <a href=3D"mailto:desinscrip=
tion@agence-onp.com?subject=3DDemande%20de%20d%C3%A9sinscription&body=3DBon=
jour%2C%0A%0AJe%20souhaite%20me%20d%C3%A9sinscrire%20de%20vos%20communicati=
ons.%0A%0AMerci%20de%20bien%20vouloir%20supprimer%20mon%20adresse%20e-mail%=
20%28linux-mm@kvack.org%29%20de%20votre%20liste%20de%20diffusion.=
%0A%0ACordialement."
         style=3D"color:#888;">
        cliquez ici
      </a>.

      Pour toute r=C3=A9clamation ou interrogation,
      <a href=3D"mailto:abuse@agence-onp.com?subject=3DSignalement%20%2F%20=
Contact&body=3DBonjour%2C%0A%0AJe%20vous%20contacte%20concernant%20le%20mes=
sage%20re%C3%A7u%20%C3%A0%20l%27adresse%20linux-mm@kvack.org.=
%0A%0AMotif%20de%20mon%20message%20%3A%0A%0A%28pr%C3%A9cisez%20ici%20votre%=
20demande%20ou%20signalement%29%0A%0ACordialement."
         style=3D"color:#888;">
        cliquez ici
      </a>.
    </p>
  </footer>

</body>
</html>
----_NmP-61bb44a5f7189f37-Part_1--

