Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D633FC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 09:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77116B00CD; Sat, 27 Jun 2026 05:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01506B00CE; Sat, 27 Jun 2026 05:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFA66B00CF; Sat, 27 Jun 2026 05:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59B6E6B00CD
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 05:49:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5C379088A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:49:00 +0000 (UTC)
X-FDA: 84925218840.20.FE63961
Received: from a3-26.smtp-out.eu-west-1.amazonses.com (a3-26.smtp-out.eu-west-1.amazonses.com [54.240.3.26])
	by imf08.hostedemail.com (Postfix) with ESMTP id 116F7160006
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:48:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bsnsportsblog.com header.s=resend header.b=l9bV+uAg;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=2W2Cvrwj;
	spf=pass (imf08.hostedemail.com: domain of 0102019f087b7867-d02dccac-8965-4129-8ec5-362487b84b89-000000@send.bsnsportsblog.com designates 54.240.3.26 as permitted sender) smtp.mailfrom=0102019f087b7867-d02dccac-8965-4129-8ec5-362487b84b89-000000@send.bsnsportsblog.com;
	dmarc=pass (policy=none) header.from=bsnsportsblog.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782553739;
	b=cmSm3w1gcw4HxtZ1aZO1aRK53RQHQ8yKcLmbf1Iy245D+tpPj+jId1npzQEgdhYvJKIqDu
	X23izTmCXxQJVPzFczcLOJofVgyIbUooBw/EVgCF/da7iKYedUGJfUWsYYTR3bOAQmDvZr
	0fOHpFn1rk8uBUm+i7wUDwdJbsq4iJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782553739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DlRB1QI6bKx2hkisX344NXshYu5FFTVKQvZ8kcF6bZQ=;
	b=gw2kbKEKCjGE9m57SZsGed+1yjK6uRH5kFZZl/+zJw1BVl002h7VNwK0ODEGu42XLEjHL2
	e/bf9f2vy30BZhESUHR9IluYfrm2ErN/IEsaioX25+J5W9Z2VZGhUZxgKWMlWTwIMjAIC8
	1TODR7g+7xbtE64IFxR8MunLnHsGiTc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bsnsportsblog.com header.s=resend header.b=l9bV+uAg;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=2W2Cvrwj;
	spf=pass (imf08.hostedemail.com: domain of 0102019f087b7867-d02dccac-8965-4129-8ec5-362487b84b89-000000@send.bsnsportsblog.com designates 54.240.3.26 as permitted sender) smtp.mailfrom=0102019f087b7867-d02dccac-8965-4129-8ec5-362487b84b89-000000@send.bsnsportsblog.com;
	dmarc=pass (policy=none) header.from=bsnsportsblog.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=bsnsportsblog.com; t=1782553737;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=zU1a9GjMMoFK8TgiBY3tDMIX39hjyyp863PcyO1Eb/U=;
	b=l9bV+uAgauQCs/bVVMHGOTrqnA/hTBIx3HGjZlBXxD2FME/1nXa/gmSG899zdBM+
	wF2idVg2xfuoV5VW5u6VnRHtBUxDY8yfaF1F8bj6YnZ58MHHe2k/6HUJh2eknxtdY1f
	19yqZhSxAe5WQnQJ/62LlGAABXcXB4ut0LIieYTo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1782553737;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=zU1a9GjMMoFK8TgiBY3tDMIX39hjyyp863PcyO1Eb/U=;
	b=2W2CvrwjSnd439ReysXocDEYvKcqewbxs+W47smS6c7g8vH+fiw48VCN3oBUQ8+z
	mh6dE2k+GTclUJZ53ARJ9+MNmgM+fulZNU53/32k5RGO3Tk4DstSPA0RHvEIViZcmjL
	LLLAd2qOfCJZ6P8pwG7EM/BBMBag6Rip2i6NJRn8=
From: =?UTF-8?Q?St=C3=A9phanie_Royer?= <contact@bsnsportsblog.com>
To: linux-mm@kvack.org
Subject: Je n'ai pas pu vous avoir au bout du fil
Message-ID: <0102019f087b7867-d02dccac-8965-4129-8ec5-362487b84b89-000000@eu-west-1.amazonses.com>
Date: Sat, 27 Jun 2026 09:48:57 +0000
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-59cd8c58a67b3617-Part_1"
Feedback-ID: :1.eu-west-1.eRMJvqouLcAhOOR5jrp23sILs+Nm7bBQxZhQKf1eHm4CPe7InMtlLrGVGo88vmKIwbwp9xHRquwNdO3qZkmWIOThkzFDMPjXEfIkVZOkOo9fr1aQkCFwQXdC0JtrsQ13GcqX4YkW6nS0O4Ypoy3Br7c473IE+i5nfqK5afmp1oQ=:1.eu-west-1.duyiEkLYPi4nGdRFd7LaGmAjRWieZlOvGu1wIBVR/Ks=:AmazonSES
X-SES-Outgoing: 2026.06.27-54.240.3.26
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 116F7160006
X-Stat-Signature: 3cykwbk5zfy5g7oyxcxcxhgtc8mdxc61
X-HE-Tag: 1782553738-179911
X-HE-Meta: U2FsdGVkX18ra4rQYPts0jduKt7g/TLCFf9mUfgDsUE0HH/WuJK+FMhb3sEsrSthhRqLITGpBLq8NCqCRYeC/7BECFeYusbP1omehfLZD+s04hlxfTivSBAjf3IWphyYPOul9oNtofSDMNV9LuBY9y1bdmuiPVcC0SRwmBEmU3+Z3+bCcdOxGECoOhvSbSD2laRjiVTLndYUodWduJLM1gt8RafajMV3KRO38mxBE3dc5s5KFpWFCrPpQGO4fnGwXExFWBqaXX4UAuCd4pPlEijyY6va8KRYRuhcdsTAnhyVF/u1cBnUl11xRgl6VD0BlpYYdHBJVcHHOYZhSF11OtGuTVEY6EVrD7wqIcFEyU+hGUFC7CZtkpITOZ+mywpoVkDf3hBO2JsIVBi6WK1IJpUJUqFXCoBllFXo8TT+hq5negeuHoND/aSZwEU9MVaIE9O+UPrW1V0zHrDRtrbbXzTrWn6irHRGUf+mH7VtOqiO1XoVsTKrT6ux5kWv0KzmkZl7XkJhWJIPPRUB7DVHjyLFF0vSMixPC+wwq/rFxN5mX2XUD393JyZBjKbXjgmdjw9hNMyZm5hHMwtQqusylZW1OJwL3UDWcYopgAOI7vW3z+/Qh6VxEwqWL56n35Y/0JAtbiwAmzOgT6kM0HaLpkuPYOwoZCstUY7TalNgM5TLfOUgiFgBQSphvpkz0feqcPbgTahDQyBRGdYbl+QtWliCjlCImCX23tkjRvCoHZgfZJ3mTibQzLI0aeoSxWULtohZXfM0k4nSMfzaco1TbooMNlfWBDpG5qUYWAdDHZiQ9/guxL87t5ueMjwk3wNDOyBRneYpVySEuspzCUdmNZO/aTaVssHyDQPP7d23CSXDViZwNwzypqu6bViWfGu35chAYvKiZEUdLnUNLQUB2T3m3ij+ryUBSWuGtppbnhpH8FBnx9H+MvkiYb/woul05pLsPPY9j8ATJbEnmAo
 noiZjjNN
 qvE7ZrmllMawq4ufCfIoiiZTKY7dZe/ywlY9n78DpPka2Th1UCCN4PdxD6Q87KBqhKzF/NNJ/7C2EZDw012l6npLAzq3ERISSrOP0lL2zcMjlYzmXgt5kiHquIMHjsat/oDrowrxzJNhSjt5RdWokpaCmp2bLKIFyyS6Cs7DQYF0bOxij3ABcO1ovWPBhIAa1Ee3XLmTOjQCnTm0ueBwfmlXUVGomT1XQD5HIMd0t8D+WumijHwTg9bvgZsE17ql2dlUzLUGRu0MLUt+1IPg+7jhyPx5ueVYISFuT3FIH5PvwwQS2sPGRIpx9PkZc4/mt0fWszfTh8AaFSsn9uIIgFzx9/iLN6IbSmsv+N3EtCJGKlTxC371rHJwjViS43u+yLEXrsQLsUI/SkO7Sm9aDS3BLwM8Vb1a1cd92+yEcuvIz/X6gXcwsC9PAmtr2LeVX+1G/tCojTFZpZmPJHbfG3yrA54sTzuFlnV6Y1rOB7bgrT6OWw0bjAK5IV7X7uAmhdrEnd0HIMeyg60p8BiXg54vVCDSjuQFj/z2qY8i08ykawT2szS12FIwe2XVxd2eTcGTv7EL48E08h5YrsC+tVrAq2MiwqCSlxCklOV3Jh3XV4wHItT2tB81whXf6WHQX0dS4hNsTTTq+oHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----_NmP-59cd8c58a67b3617-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

Je me permets de revenir vers vous car j=E2=80=99ai tent=C3=A9 de=
 vous appeler il y a peu.

Je vous contactais pour vous pr=C3=A9senter la =
secr=C3=A9taire IA t=C3=A9l=C3=A9phonique que j=E2=80=99ai configur=C3=A9e =
pour votre entreprise.

Elle r=C3=A9pond =C3=A0 100 % des appels, 7j/7, et =
g=C3=A8re :
=E2=80=93 l=E2=80=99accueil t=C3=A9l=C3=A9phonique des clients
=E2=80=93 la prise de messages
=E2=80=93 la gestion des cr=C3=A9neaux de =
rendez-vous

Le mieux est encore de l=E2=80=99entendre par vous-m=C3=AAme.

D=C3=A9couvrez-la en 2 minutes =E2=86=92 https://acmodhub.=
com/stephanie-ia-4-v4.php?telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%2=
0JEAN%20PIERRE&adresse=3D180%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&=
dirigeant=3DROLLIN%20JEAN-PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe

Votre avis sera le bienvenu.

St=C3=A9phanie Royer
Secr=C3=A9taire =
intelligente de votre entreprise

---
Pour vous d=C3=A9sabonner simplement,=
 : https://acmodhub.com/desinscription.php?email=3Dlinux-mm@kvack.org
Pour signaler un comportement abusif : https://acmodhub.com/abuse.php?=
email=3Dlinux-mm@kvack.org
Ce mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 : =
linux-mm@kvack.org. Conform=C3=A9ment au RGPD, vous avez la =
possibilit=C3=A9 d=E2=80=99exercer vos droits =C3=A0 tout moment.
----_NmP-59cd8c58a67b3617-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0"/>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>Je n'ai pas pu vous avoir au bout du fil</title>
  <body>
    <div>
    Bonjour,<br><br>

   Je me permets de revenir vers vous car =
j=E2=80=99ai tent=C3=A9 de vous appeler il y a peu.<br><br>

    Je vous contactais pour vous pr=C3=A9senter la <strong>secr=C3=A9taire =
IA t=C3=A9l=C3=A9phonique</strong> que j=E2=80=99ai configur=C3=A9e pour =
votre entreprise.<br><br>

    Elle r=C3=A9pond =C3=A0 <strong>100 % des =
appels</strong>, 7j/7, et g=C3=A8re :=20
    <br>=E2=80=93 =
l=E2=80=99accueil t=C3=A9l=C3=A9phonique des clients =20
    <br>=E2=80=93 la prise de messages
    <br>=E2=80=93 la gestion des =
cr=C3=A9neaux de rendez-vous
    <br><br>

    Le mieux est encore de =
l=E2=80=99entendre par vous-m=C3=AAme.<br><br>

    <a =
href=3D"https://acmodhub.com/stephanie-ia-4-v4.php?telephone=3D03%2029%2008=
%2040%2030&nom=3DROLLIN%20JEAN%20PIERRE&adresse=3D180%20RUE%20VALLEROY&cp=
=3D88800&ville=3DHAREVILLE&dirigeant=3DROLLIN%20JEAN-PIERRE&email=3Dlinux-m=
m%40kvack.org&r=3D4ro5pe"
       style=3D"color:#f97316; font-weight:bold; =
text-decoration:none;"
       target=3D"_blank">D=C3=A9couvrez-la en 2 =
minutes</a><br><br>

    Votre avis sera le bienvenu.<br><br>

    St=C3=A9phanie Royer<br>
    <strong>Secr=C3=A9taire intelligente de =
votre entreprise</strong><br><br>


        <footer>
        <p style=3D"font-size:13px; color:#888; text-align:left;">
          Pour vous d=C3=A9sabonner simplement, <a href=3D"https://acmodhub=
.com/desinscription.php?email=3Dlinux-mm@kvack.org" =
style=3D"color:#e67e22;">cliquez ici</a>.<br>
          Pour signaler un =
comportement abusif : <a href=3D"https://acmodhub.com/abuse.php?=
email=3Dlinux-mm@kvack.org">cliquez ici</a>
        </p>
        <span style=3D"font-size:12px;">
          Ce mail a =C3=A9t=C3=A9 =
envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. Conform=C3=A9ment au RGPD, vous =
avez la possibilit=C3=A9 d=E2=80=99exercer vos droits =C3=A0 tout moment.
        </span>
      </footer>
    </div>
  </body>
</html>
----_NmP-59cd8c58a67b3617-Part_1--

