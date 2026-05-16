Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE2ACD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 13:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338B16B0088; Sat, 16 May 2026 09:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9E56B008A; Sat, 16 May 2026 09:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF566B008C; Sat, 16 May 2026 09:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 102716B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 09:39:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E0BD1A0388
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:39:38 +0000 (UTC)
X-FDA: 84773390436.05.50732E2
Received: from a6-245.smtp-out.eu-west-1.amazonses.com (a6-245.smtp-out.eu-west-1.amazonses.com [54.240.6.245])
	by imf21.hostedemail.com (Postfix) with ESMTP id E56D61C0009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:39:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=948hub.com header.s=resend header.b=mtXrfNVa;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=zK8R5gNj;
	dmarc=pass (policy=none) header.from=948hub.com;
	spf=pass (imf21.hostedemail.com: domain of 0102019e31038677-9c18078e-85b5-446f-a301-1b43c19b3bd2-000000@send.948hub.com designates 54.240.6.245 as permitted sender) smtp.mailfrom=0102019e31038677-9c18078e-85b5-446f-a301-1b43c19b3bd2-000000@send.948hub.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778938777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6vX3tjzNED9C/c+iH7V5vTmvgX4ryjv2Um+uoXU2FVQ=;
	b=zAh99aUqISXHi0ZRr0S8yuTijZAZa71kGdvkLhLvlSyjj7+807BlhWpwmsafD1Izw4KFLK
	0YeFE3XWLyfE+XmxV4p3+I1MxASlD1t7z+nNmO4KtuPatdWeNCqtIJmALqHyplXs/3uoJz
	YcDgOJcg+t0xZTzVV3jN05tWj+F6FYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778938777; a=rsa-sha256;
	cv=none;
	b=C1jq2/pzc7MJONnxFT5jOFw/55xGlvEyzUjYFsRQwIGo0fyrxNnnNTdkAlPcLP3PuzeZji
	ADLsdn85ZHu8iAK8f93GM7/dpGKzk5A3NK4T+XbWuh/fHi/iXR0P/sOsIS6R0iEcUfUkve
	U2IWAzWon4uShJvaYcD7P4G5RoSNHEg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=948hub.com header.s=resend header.b=mtXrfNVa;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=zK8R5gNj;
	dmarc=pass (policy=none) header.from=948hub.com;
	spf=pass (imf21.hostedemail.com: domain of 0102019e31038677-9c18078e-85b5-446f-a301-1b43c19b3bd2-000000@send.948hub.com designates 54.240.6.245 as permitted sender) smtp.mailfrom=0102019e31038677-9c18078e-85b5-446f-a301-1b43c19b3bd2-000000@send.948hub.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=948hub.com; t=1778938775;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=zCMTm1Khduq9D8xJF6o9ZQ1mJFRFPNlrUoRscSfrwNk=;
	b=mtXrfNVaZx2YB5h7IcgNgSv+tLGBD2G+vCBl1aqP91iQ6qaPcP+GwNnukz4SchhZ
	gc0SweOUbmXmK5ITawq2jULz4/Vbji+T6rOT9wj3sQsmYtEZ4JaZx6Opm9eIBUrDkq5
	HNyK+nCwQ2R/DVa7g1HcCU5ZHLGZ44QxjcjLJuYM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1778938775;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=zCMTm1Khduq9D8xJF6o9ZQ1mJFRFPNlrUoRscSfrwNk=;
	b=zK8R5gNjqV+bzmuGryB0nk9OYzZKM+MaiJ4IDryWfqLL0sMeT42VSYzUmnvf13ql
	FQa9ncVi2g8GMvEECowX+p9kfad4z590HAvFV5QtTZD5NTM8m3znkwZBg6oM4g2b+BX
	qxBGeBOY4wH4o7IZJQKzQR7ymVKCE95+aA6njtpM=
From: =?UTF-8?Q?St=C3=A9phanie_Lefevre?= <contact@948hub.com>
To: linux-mm@kvack.org
Subject: =?UTF-8?Q?Je_voulais_vous_parler_mais_vous_n=27ave?=
 =?UTF-8?Q?z_pas_d=C3=A9croch=C3=A9?=
Message-ID: <0102019e31038677-9c18078e-85b5-446f-a301-1b43c19b3bd2-000000@eu-west-1.amazonses.com>
Date: Sat, 16 May 2026 13:39:35 +0000
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-76718dab8be65e71-Part_1"
Feedback-ID: :1.eu-west-1.zwmMo3LCZo1IDP0SxmXCmVBF5VcGcIlsaZN8ETRVuZm0dhDK8/PRvDgpdakS43dpnUewD0vcw9oohT5v6s3UwzFKqkeI5iCB20msaUHyoV8PMpOMVPSptjhTF3vfafsXuSbtiDm3U42oAvC6FkCKw5viYgnLzqglZEoRZtAFN9U=:1.eu-west-1.duyiEkLYPi4nGdRFd7LaGmAjRWieZlOvGu1wIBVR/Ks=:AmazonSES
X-SES-Outgoing: 2026.05.16-54.240.6.245
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E56D61C0009
X-Stat-Signature: gpzqy1remie1uhsij98yxywqhr48qr95
X-Rspam-User: 
X-HE-Tag: 1778938776-683600
X-HE-Meta: U2FsdGVkX19F8YLEH0nzpt/oTfrg1UExFr94aYV6l608FzK+KvWsLKaLWg4EDDsub2vdmR00X9EdkNy5TuLf9lrWECVUxaop6jggghUzZADThUONHgeUihts8bTk9BVeA9MEPkUfMCtWJW1QTC+1iwdMfY9PJHL3morpZ45eKeYgTSx4BatmyxmStXQMIyyuSFZzEl3kdl6LxoNOmyCOKEg09WgfVAZpioKVSlZDYEaPgbHDOh9cQhYZorsdgHXQfiZTjqLxUVK45e8xEKuAJAKyVl7rol8F01InQfCfBqa+JQDJ/Oe3yMrtaxUdIh1dgj24jqcUiIlQMdAycYokaeOPWG0vsI0hRoUlrCjyBMnCp9GdRu8dDqmh8dFj8MeGKBlAbwnjX3YkXrXxQKu56LVSLgt3D5tuLULlOqBIqbgPfWFpZSNP+jO3PswmifF0OGDMrdW8r3gX5GV2cYqW4BekjrsfsRxFbFVqV6OBgGrOcrNLE21iSjICuPKYJTv9p/PZxEaFUYsxky6OCYD+dVTMQrhjSNHSCorkzbSsrhqEc1JKrEXaU+3kTbmzw2CGmMMji3xmnaWUAIlEWkXB8xdqihjDDpityhJT6HYTGNgBJXwCndGlXTST3YcBDA+/x3qMxi1huVo6zhH8rXDsyEjyvUK7pGPxx+FB1R8+Vkhx8VPKxxjpuRDThWz52tFz29bksFiQMynXDmDTbm5rpVNAvQCqNLbop7FKo0tq8hkcfR31PUr/u98GiTQQ3WREW/HtIhLq/RoEh/Gp/rihvRC+4BZupPGTpUw2Ie+QjVp+HR71uim2MpBL1jysNL4ExsEzBOpISr4sCjWO7L4VXlOVJRG5E9oEkIjksQCZbMo1Jtc9mvTLnkDjQu4r+W8UfN0JWxKsnaN3u0Qh9hvAZ7n4HcGsDy8eKTNrFTK4ikhfjnFvVMR8TSxZhmmOV+BhD8/DQj5MrTpFRBqZbN5
 4lKG5Ugi
 01uZXKQxVFHzmOWuWRZxpWm1VtlvC9aCAXZgyZhU24o/AfXeDI+pw1alIAjBBJPNZvp84sWPT+VU3Kp8plZn9xkr+7R4RIsW06G7HiFpJgaJf6k+mbOXWcbr4JaB4C4Bbcv0XZpObT+jyd0FQGh8ko/3XurFUJ7hfcCl3DrKCJugu1PVe37IBBrRbhtK52xsYCqbYsihs0f5x7rW0g6b3wYYyoEDMK/o74HEcudbW04c2Ji2YNIJLp1sHnJemQDRkQ2yLy7rV7OQFrk8o7s3Wiue2f4NIJ5CcpEhQrfvU9PKq1/Ppu09HwIZg26Dwip0DfvAUgdN187SkxNRTxpc8WzQXYSC6np0bYLTSPhkQvrhT897WYwTkKK9B1dAonr9i85Zh5YAEeh0VsV5YhaBFk8wcKjA8o1sKyIMnZ1GCu9OaN91qv9y6w8jO7J0UNS3y+wevZP1sZrP1cL4rQnuJD+wI3badEKrgDOSm5dBGEan0HNB2lEusFrkBlpxdY2GiCnl16Trjka7NuMP2T9hnX3WYOSciCJwJRo1qC03feAzAFCgsf0ZGCFxNo8WgNGfjmbfG8IdvkKIFOt6AfPQFil6m+t7M+mjsQ2YrsJGX7hayQmYH2ulXONnfmndUQunNIKMAzculTh2DyDXMOjptuVmKHQiVwwd29V2TolhaAajrXJW7SRiyOZq+zJy7lqQWflgre7SucL9HR+wT0jTIXtQopLoUyEizSxQrg9BBAfPAlBqEsqHQvmQi+WkfM9xnW2fMO3gsLnfvIFazT3SK/xc/YxSx92d8SPpjQZRf8SBHjmfzPlTs1Nd9QCF5Qyoep+m9CCt0sNStAMn2HL8aXdMWkpc7CMCK8KIY9cLoHnlCe6j2qomU3NLyjbO755cZNbCaSHRy5HPrnKa+sCjeEgktaKoNOyPDblqy+LrDhsGycbfpnUi8UqDjNAAyVd69UC6YxKVaS6d91pYhDHi/Fz7FSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----_NmP-76718dab8be65e71-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

Je vous ai appel=C3=A9 il y a peu, mais je n=E2=80=99ai pas eu la=
 possibilit=C3=A9 de vous joindre.

Je vous contactais simplement pour vous=
 faire =C3=A9couter une version de la secr=C3=A9taire IA =
t=C3=A9l=C3=A9phonique d=C3=A9velopp=C3=A9e pour votre entreprise.

Elle r=C3=A9pond =C3=A0 100 % des appels, 7j/7, et g=C3=A8re :
=E2=80=93 l=E2=80=99accueil t=C3=A9l=C3=A9phonique
=E2=80=93 la prise de =
messages clients
=E2=80=93 la gestion des cr=C3=A9neaux de rendez-vous

Le plus efficace est de l=E2=80=99=C3=A9couter par vous-m=C3=AAme.

=C3=89coutez-la en 2 minutes =E2=86=92 https://acrylicoat.=
com/stephanie-ia-4-v4-light.php?telephone=3D03%2029%2008%2040%2030&nom=3DRO=
LLIN%20JEAN%20PIERRE&adresse=3D180%20RUE%20VALLEROY&cp=3D88800&ville=3DHARE=
VILLE&dirigeant=3DROLLIN%20JEAN-PIERRE&email=3Dlinux-mm%40kvack.=
org&r=3D4ro5pe

Je serais ravi d=E2=80=99=C3=A9changer avec vous =C3=A0 ce =
sujet.

St=C3=A9phanie Lefevre
Secr=C3=A9taire IA con=C3=A7ue pour votre =
entreprise

---
Pour ne plus recevoir nos emails, : https://acrylicoat.=
com/desinscription.php?email=3Dlinux-mm@kvack.org
Pour toute anomalie =
constat=C3=A9e : https://acrylicoat.com/abuse.php?email=3Dlinux-mm@kvack.=
org
Ce mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. =
Conform=C3=A9ment au RGPD, vous pouvez faire une demande pour exercer vos =
droits.

----_NmP-76718dab8be65e71-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0"/>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>Je voulais vous parler mais vous n'avez pas =
d=C3=A9croch=C3=A9</title>
  <body>
    <div>
    Bonjour,<br><br>

   Je vous ai appel=C3=A9 il y a peu, mais je n=E2=80=99ai pas eu la =
possibilit=C3=A9 de vous joindre.<br><br>

    Je vous contactais =
simplement pour vous faire =C3=A9couter une version de la =
<strong>secr=C3=A9taire IA t=C3=A9l=C3=A9phonique</strong> =
d=C3=A9velopp=C3=A9e pour votre entreprise.<br><br>

    Elle r=C3=A9pond =C3=A0 <strong>100 % des appels</strong>, 7j/7, et =
g=C3=A8re :=20
    <br>=E2=80=93 l=E2=80=99accueil t=C3=A9l=C3=A9phonique =
=20
    <br>=E2=80=93 la prise de messages clients
    <br>=E2=80=93 la =
gestion des cr=C3=A9neaux de rendez-vous
    <br><br>

    Le plus efficace est de l=E2=80=99=C3=A9couter par vous-m=C3=AAme.=
<br><br>

    <a href=3D"https://acrylicoat.com/stephanie-ia-4-v4-light.php=
?telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%20JEAN%20PIERRE&adresse=3D=
180%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&dirigeant=3DROLLIN%20JEAN=
-PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe"
       =
style=3D"color:#f97316; font-weight:bold; text-decoration:none;"
       target=3D"_blank">=C3=89coutez-la en 2 minutes</a><br><br>

    Je serais ravi d=E2=80=99=C3=A9changer avec vous =C3=A0 ce sujet.=
<br><br>

    St=C3=A9phanie Lefevre<br>
    <strong>Secr=C3=A9taire IA =
con=C3=A7ue pour votre entreprise</strong><br><br>


        <footer>
        <p style=3D"font-size:13px; color:#888; text-align:left;">
          Pour ne plus recevoir nos emails, <a href=3D"https://acrylicoat.=
com/desinscription.php?email=3Dlinux-mm@kvack.org" style=3D"color:#e67e22;"=
>cliquez ici</a>.<br>
          Pour toute anomalie constat=C3=A9e : <a =
href=3D"https://acrylicoat.com/abuse.php?email=3Dlinux-mm@kvack.=
org">cliquez ici</a>
        </p>
        <span style=3D"font-size:12px;">
          Ce mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. =
Conform=C3=A9ment au RGPD, vous pouvez faire une demande pour exercer vos =
droits.
        </span>
      </footer>
    </div>
  </body>
</html>
----_NmP-76718dab8be65e71-Part_1--

