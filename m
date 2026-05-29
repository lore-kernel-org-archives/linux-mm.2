Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE73CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630706B0005; Fri, 29 May 2026 04:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E48F6B0088; Fri, 29 May 2026 04:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7396B008A; Fri, 29 May 2026 04:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 402676B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:44:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E473F120A1A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:44:58 +0000 (UTC)
X-FDA: 84819822276.29.683A484
Received: from a3-12.smtp-out.eu-west-1.amazonses.com (a3-12.smtp-out.eu-west-1.amazonses.com [54.240.3.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D58420008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:44:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=20services.com header.s=resend header.b=jKbPFrL+;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=S4XfhCSI;
	spf=pass (imf03.hostedemail.com: domain of 0102019e72e86cee-5021539a-b223-4067-bdd1-85be7fbfae7b-000000@send.20services.com designates 54.240.3.12 as permitted sender) smtp.mailfrom=0102019e72e86cee-5021539a-b223-4067-bdd1-85be7fbfae7b-000000@send.20services.com;
	dmarc=pass (policy=none) header.from=20services.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/x2Lj01ifkva5AU55mmdE2vUwmec9pC/aDSBpZ86k9k=;
	b=m4rz9aP8BwINQ9XCJua0OJUccG8Ceaot0T1E/lwIkyPIV2JhMbswVMG4xvN9oLXUV9Ykwo
	GnSzbTluyJYVAdjiMEn1vht4fvyaxXdHsjG6LepQC1zIbw8MqXyMO6lljqiCqPMYqJEVIt
	0tsYsY1J6qBxYQQQvsHGb1Cuk0R8QRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044297; a=rsa-sha256;
	cv=none;
	b=hydWhJrCBm70lQwS1KFPeQl0Ug72dQNWMnZzMt46gG/aDmWZ4/FA8Nh4YhqZBhlPFMzGn/
	tzv6MNrMYaLWPItepzAkEY5Pd3fGPk+vqtcLQbH/vBRDXks7hqMx3q1oJZ9TSkSwmeQIgB
	K4UsCahRrXq9M9Fon1G90kRI4OzMbTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=20services.com header.s=resend header.b=jKbPFrL+;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=S4XfhCSI;
	spf=pass (imf03.hostedemail.com: domain of 0102019e72e86cee-5021539a-b223-4067-bdd1-85be7fbfae7b-000000@send.20services.com designates 54.240.3.12 as permitted sender) smtp.mailfrom=0102019e72e86cee-5021539a-b223-4067-bdd1-85be7fbfae7b-000000@send.20services.com;
	dmarc=pass (policy=none) header.from=20services.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=20services.com; t=1780044295;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=n9jgRDDPzgyJ6piRHXR6n9x9Lo18KmEJyT0Oik6KC5U=;
	b=jKbPFrL+2lIBU+s8RHt4n06nz7FYTE08eRPLrZwk3TZQJBK2ElU32PlQsXxzX2Dc
	OiXtOCNeFFK5UdjR3JsV+eSY8bJAsERyk4YyEEzzHWgK07kF9lJgmjsYVyav2tsseT6
	0kNlevdHEL81js4Cyo1dcxmrmUr/olf+ZlnUXaeM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1780044295;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=n9jgRDDPzgyJ6piRHXR6n9x9Lo18KmEJyT0Oik6KC5U=;
	b=S4XfhCSI7VWfNSJKEcbXTsk33oBnLKTl23XCQYaMKDlcjoW0q8oH0n0CbFEPfAez
	1ZPZ7RSFQ//UIZp2ifwsaBvHzgAEtpqCHJsljTgFY1WkzQxuIEQCzBDPawjeLsMSJ2p
	cbNuNs5qgjb/b+Bc0eb629X+gcv24Ndpj3zgbWTk=
From: =?UTF-8?Q?St=C3=A9phanie_David?= <contact@20services.com>
To: linux-mm@kvack.org
Subject: Essai d'appel aujourd'hui
Message-ID: <0102019e72e86cee-5021539a-b223-4067-bdd1-85be7fbfae7b-000000@eu-west-1.amazonses.com>
Date: Fri, 29 May 2026 08:44:55 +0000
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-c8f002b0c5017026-Part_1"
Feedback-ID: :1.eu-west-1.odfysvPh6zIV8acxyCJwJLcUwKPIFrHf3ZBMJqkLfJF4mXCi9w38U10W8+N+erwxUC6nILehEDZJs3esBULblR/lBi9guIyVkWzSGpDvIG9Z9juTZARUbOKD+6laLM0K/FfTFRvE6dVTmQG8pih15O8eChgywf33gd5jumDDWm0=:1.eu-west-1.duyiEkLYPi4nGdRFd7LaGmAjRWieZlOvGu1wIBVR/Ks=:AmazonSES
X-SES-Outgoing: 2026.05.29-54.240.3.12
X-Rspamd-Server: rspam11
X-Stat-Signature: 7youqwy73f5gtfycmhdwhkwozznnkhwp
X-Rspamd-Queue-Id: 2D58420008
X-Rspam-User: 
X-HE-Tag: 1780044296-474284
X-HE-Meta: U2FsdGVkX1+uNvug1A4IqKer7uySnTfNTzvjLR/Tj3nnCybKC1fsOnIJlFTv3arc4IYLrn4FAS5Yr283LngnIzjWRugNsbhmYZkpqPyegGJnUtgVpEYjx1T/vansJBGlmvuXFF7jkhIhkCvISVxPtNOB8rLgV+hRlVKM250bmkHW/e7+kkv8u7yWPUurdeWPRExC8IGtoj5yjUYen0/bGqvflnKcJnsixwEoZk+ZRf3xRJFoYBK1x3iOFbN0WxDGxPiv3ta7krPc6d5t/VwLTcjDtzAadvqXfRuPWLrmKm9qGVacIjReFNBCFQJV0Z2tZzB9FZnUqZbKDJ1sE1FpaYcneE4FgVT7luTnFUfEbXzjySgdsHd4TmJDblm6kmza/Po4jlFBGg6Kr/acJLYBJrstYmiYpUgr1PjLVQvo7es+IBHgHnw7f79Se9wVf/DHSu1ECfrAqaqLkiIZHfhZeeO5D3wH90NPI1nlwGWKVKDeeK8ijfznlSDXIY4zE8htJxbWppp5Z6E+FKhlFotuCMSSL4klu78yl5Nx7hNB/CAgzdUrBz9hgjH3VsmG4VMkPSH8xUCJRFuAVITrurqSOr9Cyw3X7c4dtln5b8Azb5D5qm1ialjduMWop7mmj2OW0lEMRLfAFVLhU2o7zf6ZCBZ3XVhK6wTVOQXdZMqAe9sjHu80g2FxtgMF+e9cZDfsfpUFJyYoiemw/Z8cUhFmgLufA+AKJhFL0CwsuFthxb4CLgXwQ4FZqxhD3FqI0RzK1HOZ8uOodStwgW/xHQo0kjrrbzk/dScE+Bz+lYGBBb9OwiZDqUYw62+bajtSFH0IZCCUoKwCg4Uu/MtmdQcfUchTppqJuRrpdYkr5dBKxdR4QiXfuxTCeurUsEIO2PEP8n4rHACG2KYwItHi8Kkk6ZxMhJIrEZLqO7MjYGyu+LgZ4BFgzjhT4XL8R4CtpwtZ7HgsV27oHMf3GX0FVn/
 49D8Yd/v
 OCRGGk02pLO/iDnkbDH2vGfrsk6WUg2FqKrX9jn15YYAukvSKXH59MGmYse8520LT8wQYZw/jeLqbHHrzNFfE0DGkmX+TS00J3vWFIeSwwPxq7ABklwuojKr2oTSkENioebwjNOT26tit5q1fOyd1y8iXvkHrE6xBD8b7lbAJp4eHgGz7EMRwEqeVJo9cUQixR1JNlIb77AN6cXXrMUrqH277OK7PzFH20TbqvFRaa+M5vvy9Kxr6LHeYaQrw8nuMGgl8tMNLmE6NVhm5YP67KHSAkLD4yLXB1tk+kyPQTG6D9NOz3B4B5UQ3YvSbhewcE317cv2w9lsxXDGVzUKX8AydMxqHrY0zZP0cOpEoP8rb7qgJsjA5VHdMjJOdiPMIz5pObQBqBHo0yLzrnkuhSnnSTmzEOE/IHJQA4vKrcCHI0QJ76pMKY9FCxnFwVU5NovgFgU8bkk16siDOeZpsisECqhNU67m7xM3aReOoPLyenjSu84diYuBdoDYfQsyiJRN8aQ31lpkHkCAkqb4ZmJFcY/Xt0fQu2OkHrt9MSmII1RgH2KYXnlvuuQF8Ib+hiKgdYT34NdzWRZZBvC0SNaRgxSihmUKudJRD9lrsecSk++o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----_NmP-c8f002b0c5017026-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

Je vous ai pass=C3=A9 un appel il y a peu, sans parvenir =C3=A0 =
vous joindre.

Je vous contactais afin de vous faire d=C3=A9couvrir la =
secr=C3=A9taire IA t=C3=A9l=C3=A9phonique mise en place pour votre =
entreprise.

Elle r=C3=A9pond =C3=A0 100 % des appels, =C3=A0 toute heure =
du jour et de la nuit, et g=C3=A8re :
=E2=80=93 la relation client
=E2=80=93 les messages t=C3=A9l=C3=A9phoniques
=E2=80=93 la prise et la =
gestion des rendez-vous

Le mieux est encore de l=E2=80=99entendre par =
vous-m=C3=AAme.

Testez-la d=C3=A8s maintenant (2 minutes) =E2=86=92 =
https://acordameetingsconnect.com/stephanie-ia-4-v4-light.php?=
telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%20JEAN%20PIERRE&adresse=3D1=
80%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&dirigeant=3DROLLIN%20JEAN-=
PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe

Je serais heureux de =
conna=C3=AEtre votre opinion.

St=C3=A9phanie David
Secr=C3=A9taire virtuelle IA de votre entreprise

---
Pour ne plus recevoir nos informations commerciales, : =
https://acordameetingsconnect.com/desinscription.php?email=3Dlinux-mm@kvack=
.org
Pour nous signaler une anomalie : https://acordameetingsconnect.=
com/abuse.php?email=3Dlinux-mm@kvack.org
Ce mail a =C3=A9t=C3=A9 =
envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. Conform=C3=A9ment au RGPD, vous =
pouvez exercer vos droits en toute simplicit=C3=A9.
----_NmP-c8f002b0c5017026-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0"/>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>Essai d'appel aujourd'hui</title>
  <body>
    <div>
    Bonjour,<br><br>

   Je vous ai pass=C3=A9 un appel il y a peu, sans =
parvenir =C3=A0 vous joindre.<br><br>

    Je vous contactais afin de vous =
faire d=C3=A9couvrir la <strong>secr=C3=A9taire IA t=C3=A9l=C3=A9phonique</=
strong> mise en place pour votre entreprise.<br><br>

    Elle r=C3=A9pond =C3=A0 <strong>100 % des appels</strong>, =C3=A0 toute=
 heure du jour et de la nuit, et g=C3=A8re :=20
    <br>=E2=80=93 la =
relation client =20
    <br>=E2=80=93 les messages t=C3=A9l=C3=A9phoniques
    <br>=E2=80=93 la prise et la gestion des rendez-vous
    <br><br>

    Le mieux est encore de l=E2=80=99entendre par vous-m=C3=AAme.<br><br>

    <a href=3D"https://acordameetingsconnect.com/stephanie-ia-4-v4-light.=
php?telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%20JEAN%20PIERRE&adresse=
=3D180%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&dirigeant=3DROLLIN%20J=
EAN-PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe"
       style=3D"color:#f97316; font-weight:bold; text-decoration:none;"
       target=3D"_blank">Testez-la d=C3=A8s maintenant (2 =
minutes)</a><br><br>

    Je serais heureux de conna=C3=AEtre votre opinion=
.<br><br>

    St=C3=A9phanie David<br>
    <strong>Secr=C3=A9taire =
virtuelle IA de votre entreprise</strong><br><br>


        <footer>
        <p style=3D"font-size:13px; color:#888; text-align:left;">
          Pour ne plus recevoir nos informations commerciales, <a =
href=3D"https://acordameetingsconnect.com/desinscription.php?=
email=3Dlinux-mm@kvack.org" style=3D"color:#e67e22;">cliquez ici</a>.<br>
          Pour nous signaler une anomalie : <a href=3D"https://acordameetin=
gsconnect.com/abuse.php?email=3Dlinux-mm@kvack.org">cliquez ici</a>
        </p>
        <span style=3D"font-size:12px;">
          Ce mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. =
Conform=C3=A9ment au RGPD, vous pouvez exercer vos droits en toute =
simplicit=C3=A9.
        </span>
      </footer>
    </div>
  </body>
</html>
----_NmP-c8f002b0c5017026-Part_1--

