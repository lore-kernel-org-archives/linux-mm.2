Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245A2C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8226B008A; Tue, 11 Aug 2026 12:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0515E6B0092; Tue, 11 Aug 2026 12:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83046B0093; Tue, 11 Aug 2026 12:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1B966B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:10:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67C5C1C1455
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:10:21 +0000 (UTC)
X-FDA: 85089475842.15.785EC11
Received: from a3-23.smtp-out.eu-west-1.amazonses.com (a3-23.smtp-out.eu-west-1.amazonses.com [54.240.3.23])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0DB3FC0010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:10:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=supercompraya.com header.s=resend header.b=Xjvbr4fx;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=m34NzGre;
	spf=pass (imf10.hostedemail.com: domain of 0102019ff196bee9-0704c9cb-045a-4b1e-89ab-94c832a87ba6-000000@send.supercompraya.com designates 54.240.3.23 as permitted sender) smtp.mailfrom=0102019ff196bee9-0704c9cb-045a-4b1e-89ab-94c832a87ba6-000000@send.supercompraya.com;
	dmarc=pass (policy=none) header.from=supercompraya.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786464618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dx59UC/wI1l/6J+xMatpXqYiN1ZCSOlw0MlDPirYVBs=;
	b=p3Dp3jSUlpdTOpvQzLV0L6mWCnj7ace/aEHi+Osp9BqD7luyhKynoTM3hBWAHbmCBgstU+
	rIFrbTsUmr3w2/b+cvdP47zX7+hqoE9dn8e+jld2OQN3YWtu9Xmjg9HI9MdNaZX1isWkBx
	W6/mjqlHnTMW9RFaReCKCYnqS8XpyE0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=supercompraya.com header.s=resend header.b=Xjvbr4fx;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=m34NzGre;
	spf=pass (imf10.hostedemail.com: domain of 0102019ff196bee9-0704c9cb-045a-4b1e-89ab-94c832a87ba6-000000@send.supercompraya.com designates 54.240.3.23 as permitted sender) smtp.mailfrom=0102019ff196bee9-0704c9cb-045a-4b1e-89ab-94c832a87ba6-000000@send.supercompraya.com;
	dmarc=pass (policy=none) header.from=supercompraya.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786464618;
	b=KTnXi7DjBlORiIL0YdAE0bQQOjfq22nKqCTHKZNZG/SLiDtbatyp1kFeIiHtIe2zMToH15
	8ZNYQkI51LnvraQFV2cptN0ZTBtfTWP+wakMXnoYZOOHWdMZq1eZguIzMDR6zvL8MY1w+y
	51eHdSzd4fhU5obWZd+5oWhJvr7DGaE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=supercompraya.com; t=1786464616;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=R3Pw650fKUwdZmvGrWTvkIbBZNTvQSV4Zs2fnayHC0Q=;
	b=Xjvbr4fxlG0RZvpar1rsZOOUAD6zyjdhFVIaj1yFOAgI2gZ/aOuBGJIPOZ5lErm1
	Hb9sbnigo/YLHpBPmdrP6XNLi/kLJZAo3p9Mrep3Jm3n3iGmCuOkByHnIHxF7t+BnQq
	eRaz7NS5UsfyRS1KlizSAxO7afPjheA7b02mD5go=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1786464616;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=R3Pw650fKUwdZmvGrWTvkIbBZNTvQSV4Zs2fnayHC0Q=;
	b=m34NzGrezrNyeRwcvENzfRjq95sY3lLwbB3ozcF1NEyS3C9fJLfiGPeYRVljkQvJ
	KcEvhiHoy5TK8YKyEXAjaEB/9BxPmd+Znp5cHrbowXFOC2bOpZ8qbZa4oKxKmQ17jph
	95qv6tPW/WlEgNFjbsnCDdSEKlqY2nYatCQNj0No=
From: Stephanie Moreau <contact@supercompraya.com>
To: linux-mm@kvack.org
Subject: =?UTF-8?Q?Suite_=C3=A0_mon_appel_r=C3=A9cent?=
Message-ID: <0102019ff196bee9-0704c9cb-045a-4b1e-89ab-94c832a87ba6-000000@eu-west-1.amazonses.com>
Date: Tue, 11 Aug 2026 16:10:16 +0000
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-5f1087dcbbef026a-Part_1"
Feedback-ID: :1.eu-west-1.fBpGdFJ3RZFeIV8d2SX/ll6YvKACVegBf/7VnvnVjF5E8g2UsfIo0w+gtB8ejRsF+nWwLlA2Tj22qb13hdHVto0T0O2gbsQ1WitGYESFrn6jCNaPcKI93XDufY44qBDZBkVvmw63VM/vRQXexmDzahTMKO7S6xypbTkLQklqsIw=:1.eu-west-1.duyiEkLYPi4nGdRFd7LaGmAjRWieZlOvGu1wIBVR/Ks=:AmazonSES
X-SES-Outgoing: 2026.08.11-54.240.3.23
X-Stat-Signature: zipgfuhi5a9z3jpoy3znuuzew8b4gzgt
X-Rspamd-Queue-Id: 0DB3FC0010
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786464617-983267
X-HE-Meta: U2FsdGVkX19ooElkA/MFa04gRP6XBloQgDGM0ckyW+0ACcJJBQRglk/re7ro4roQBLUEgmJfVd6t5PYQITxtBlExBXlUxeR24pTm7oXd0z8SXfLAR4XPBE3PGTSJFEnRvvJYVD6n4mAqasi7pXCuPocffD9Dh7kgWnaWvwi0WJMzjOIATf1cG8N0aZfnVUKJ3JG2moLAsIgjzgKWLDlCqgAEpg6zJ3WPPMYvCT3oF7KLLnsyBPbRxKoGAhIpz9pr/0ouZmUr0bFvt+2kFAEsk62tOWQ8vh6Hybv48og/nN/bBXgc5Prtz0jEV9dKC7udknsitaKTCtvZs5aTbmTMZiDHklSTW1NyZTHRwtsGZLusIMNV6N2Nm92wY8HhMhD8VK2wZQ4ZDKIhiVi+YYYZq0mUYv9ltIFQMnHXMdubVAI/9M+Hby4HPMsoRbZAQguHiHYpg5tKj+T31Xwwv/lAwlTN3ZuVsxZUti9vfVBpixe/KnzS1JOc3OdMci3GMnzAMh2p+W4Ylsu5NwbCT6ycdJUxBiWAXvI27DD9CdERzOJn1rNoLfM+95ntNODL3zV5pHk62Yub1M1kK+vw9KNhFN59bnvxre86+vP5fwilj4g0atUzooWwnW9FuUl8iNj4nRxBb9lxcvs2TpMYDozV6hyFac6kPzs1jwuaD4T2M8wDvwMpEVnqrPOW5FBysQidC3FubuAZThDGJvPI4kyzsYs/5OWospcj3/MTKeOieAJWycxduEIQH+Ls+7tH6UMajW+hgptY5ZnQT3ntmWGRNA5RwoMMw/TWvpQofT3FGVMx1s0O9wi4XmJVoAUquZbE0ILaka1+qC1d+Ln6y3GxIB78YBq2mF6OvmCRUijROlvk4BjIO6LMeTE+CFv8mSqcPTXNdpjUij7IZYmqSEsY4kPqWNWEX9ok/Va9d6gK4qx2Xiing9BJbZ+OLjYCguYdafUSsWhpZaSSdDBifnq
 SBqDLClY
 nYcqhYdgTlJMObR3Q+gMVzOe3w4vbacA3PZhrE0rsO2HVPOmmQImFJsOuk1znRphABbttJOZx0NOR6tFyT9E2TBS9PG5jUcG91mTlQEM7UcG4My8Y6smmxTqgJaDvRMLui1DX2gHzBRsSf/EV25de6yCum2W39ryDV4rf/E+iykzfoLzNepI+jnLpYeHVIU4XdkfSjBD4n5uk1FHIywVUifH+8kQrMSC+ZgkpWLT4bWn7QhiLxYszuUB6gFHCfGu/C4/2cBP4u2QJQ93rlfDP2suwbTJsfxe930gnqj6Eat/52SLOu6B70TrbTpZ1oSuYkIX/eQSWuMpgLtwgxGsNpWEPs8bazt2d25aTdL5u96yqVRHW6Eo4GGoRmWatwYz0tz/5MbPcEnPbb8AhTAytapp5XIV+X7LwONrmGI6hdZunE20nTgxs3zLHoCg6DlW8Y19jCkHFu27E/uVEvbI7PTd/3J+U17SqHmW0kMxVi1j7gjAm7gfKcEFSm7Gt+jXSdyzaGqNd5GMCbpukvZiv5LD/jTJ4pbVKRovkt2PSISi/VdSAgIkdCaMxZHo01gCov2bXSHzwqhcaM7B4PyiS5qXuRYXpQ6mHQGoACIf/m6vx6A6YUt9Lu9pjnzchSipS0VFVqoMoYIy/RGdyONx8kApj1/lCXmFvzEpsQGdmiLMpHzs1jvFjME6rOoqFumytXs+648RkyYVetWTScyxVIVJk6MFTl31xOM+IjODMNQbkz2ZAZqRzHuGEHbDXWlyBaAYHwtxeYs2It3171TvYROftNXkzZMcjzSJqE5PO6UD0pFdXDEECTtId4sMjYRBsrooanoj+8QcZYW2GbdmZm9HHEJlTf+dWJjD6qKUtQ2ojKH0M9SrYBn/X0fTtxnR721x02NC7yeXntGo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----_NmP-5f1087dcbbef026a-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bonjour,

J=E2=80=99ai essay=C3=A9 de vous contacter par =
t=C3=A9l=C3=A9phone r=C3=A9cemment, sans r=C3=A9ponse de votre part.

Je vous contactais simplement pour vous faire =C3=A9couter une version de =
la secr=C3=A9taire IA t=C3=A9l=C3=A9phonique d=C3=A9velopp=C3=A9e pour =
votre entreprise.

Elle r=C3=A9pond =C3=A0 100 % des appels, jour et nuit, =
et g=C3=A8re :
=E2=80=93 la gestion de la relation client
=E2=80=93 la prise de messages clients
=E2=80=93 la confirmation des =
rendez-vous

Le mieux est de l=E2=80=99=C3=A9couter directement.

=C3=89coutez-la en 2 minutes =E2=86=92 https://acetaldigital.=
com/stephanie-ia-4-v4.php?telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%2=
0JEAN%20PIERRE&adresse=3D180%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&=
dirigeant=3DROLLIN%20JEAN-PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe

Je serais heureux de conna=C3=AEtre votre opinion.

Stephanie Moreau
Secr=C3=A9taire IA pour votre soci=C3=A9t=C3=A9

---
Pour ne plus recevoir nos messages, : https://acetaldigital.=
com/desinscription.php?email=3Dlinux-mm@kvack.org
Pour d=C3=A9clarer un =
email ind=C3=A9sirable : https://acetaldigital.com/abuse.php?=
email=3Dlinux-mm@kvack.org
Ce mail a =C3=A9t=C3=A9 envoy=C3=A9 =C3=A0 : =
linux-mm@kvack.org. Conform=C3=A9ment au RGPD, vous pouvez exercer vos =
droits par simple demande.
----_NmP-5f1087dcbbef026a-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html>
<html lang=3D"fr">
<head>
  <meta name=3D"viewport" =
content=3D"width=3Ddevice-width, initial-scale=3D1.0"/>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8">
  <title>Suite =C3=A0 mon appel r=C3=A9cent</title>
  <body>
    <div>
    Bonjour,<br><br>

   J=E2=80=99ai essay=C3=A9 de vous contacter par =
t=C3=A9l=C3=A9phone r=C3=A9cemment, sans r=C3=A9ponse de votre part.=
<br><br>

    Je vous contactais simplement pour vous faire =C3=A9couter =
une version de la <strong>secr=C3=A9taire IA t=C3=A9l=C3=A9phonique</strong=
> d=C3=A9velopp=C3=A9e pour votre entreprise.<br><br>

    Elle r=C3=A9pond =C3=A0 <strong>100 % des appels</strong>, jour et nuit=
, et g=C3=A8re :=20
    <br>=E2=80=93 la gestion de la relation client =20
    <br>=E2=80=93 la prise de messages clients
    <br>=E2=80=93 la =
confirmation des rendez-vous
    <br><br>

    Le mieux est de =
l=E2=80=99=C3=A9couter directement.<br><br>

    <a =
href=3D"https://acetaldigital.com/stephanie-ia-4-v4.php?=
telephone=3D03%2029%2008%2040%2030&nom=3DROLLIN%20JEAN%20PIERRE&adresse=3D1=
80%20RUE%20VALLEROY&cp=3D88800&ville=3DHAREVILLE&dirigeant=3DROLLIN%20JEAN-=
PIERRE&email=3Dlinux-mm%40kvack.org&r=3D4ro5pe"
       =
style=3D"color:#f97316; font-weight:bold; text-decoration:none;"
       target=3D"_blank">=C3=89coutez-la en 2 minutes</a><br><br>

    Je serais heureux de conna=C3=AEtre votre opinion.<br><br>

    Stephanie Moreau<br>
    <strong>Secr=C3=A9taire IA pour votre =
soci=C3=A9t=C3=A9</strong><br><br>


        <footer>
        <p style=3D"font-size:13px; color:#888; text-align:left;">
          Pour ne plus recevoir nos messages, <a href=3D"https://acetaldigi=
tal.com/desinscription.php?email=3Dlinux-mm@kvack.org" =
style=3D"color:#e67e22;">cliquez ici</a>.<br>
          Pour d=C3=A9clarer =
un email ind=C3=A9sirable : <a href=3D"https://acetaldigital.com/abuse.php?=
email=3Dlinux-mm@kvack.org">cliquez ici</a>
        </p>
        <span style=3D"font-size:12px;">
          Ce mail a =C3=A9t=C3=A9 =
envoy=C3=A9 =C3=A0 : linux-mm@kvack.org. Conform=C3=A9ment au RGPD, vous =
pouvez exercer vos droits par simple demande.
        </span>
      </footer>
    </div>
  </body>
</html>
----_NmP-5f1087dcbbef026a-Part_1--

