Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D73CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B82A6B0095; Tue, 26 May 2026 11:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768716B0098; Tue, 26 May 2026 11:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657576B0099; Tue, 26 May 2026 11:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5668C6B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:10:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0220C1ABD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:10:19 +0000 (UTC)
X-FDA: 84809906958.08.CB1802C
Received: from a2-155.smtp-out.eu-west-1.amazonses.com (a2-155.smtp-out.eu-west-1.amazonses.com [54.240.2.155])
	by imf03.hostedemail.com (Postfix) with ESMTP id C82E320017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:10:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=expoprimelist.com header.s=um6q36fww74cuyd2wba7foslierjrai4 header.b=i6UJ2J4n;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=oa60sX5k;
	spf=pass (imf03.hostedemail.com: domain of 0102019e64d6241e-da6b30aa-37c4-42c8-a4b3-b59027a51b69-000000@eu-west-1.amazonses.com designates 54.240.2.155 as permitted sender) smtp.mailfrom=0102019e64d6241e-da6b30aa-37c4-42c8-a4b3-b59027a51b69-000000@eu-west-1.amazonses.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=brJnM+51sAR98tEiBgN19u3bWUhxbSDIKtpRz45bX4A=;
	b=xitQP03fl0SEu7r0mjd5zjm4g6vstvfsXjN8MTf2I0PvoAntnOsGHF/dOcRHVZS/HzpWij
	y/7hifH2Bm0YYLdAAc1cv1tla9ufdQNlQcQHa5NxEDUxQkoBkI+GL6p6OUp1el5bs1PJ1j
	9O/SFknIvzxYvV6nQYGpjHiTetUZ6PA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808218; a=rsa-sha256;
	cv=none;
	b=Qk6IhErtJxlNa2T/yftB5kHGnlWUXFC3VuJ+Ef9Zr2hxP3/TzC3oPttzc96Q9GMlI8GpAR
	9UyEAiO7UuaDXPUlYFkxjSAyEZTxC8C3vt3Iot4onBt8YTv1M+WH5GoQ76ohnTinD3+fo6
	SKXOgAUxMcj25Q8kcLjOrYDY5EzbxuA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=expoprimelist.com header.s=um6q36fww74cuyd2wba7foslierjrai4 header.b=i6UJ2J4n;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=oa60sX5k;
	spf=pass (imf03.hostedemail.com: domain of 0102019e64d6241e-da6b30aa-37c4-42c8-a4b3-b59027a51b69-000000@eu-west-1.amazonses.com designates 54.240.2.155 as permitted sender) smtp.mailfrom=0102019e64d6241e-da6b30aa-37c4-42c8-a4b3-b59027a51b69-000000@eu-west-1.amazonses.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=um6q36fww74cuyd2wba7foslierjrai4; d=expoprimelist.com;
	t=1779808216;
	h=Subject:From:To:Date:Mime-Version:Content-Type:References:Message-Id;
	bh=ekP6W3L2ZxOsmh/vsCq+hNmMvd3USewC4TsixkcA4Wo=;
	b=i6UJ2J4nDDzgl7gMpq4VryiHHABhPClJnlXLvhfv8nhD7TA1yg6dvDmOemk84Sq/
	5ByoHRJezCStPrQNRTqHrp6Kg6OcCYNRuGb3FBbya2XeMo1hIhImgOtWQE8NunHJh3t
	63LdBVrNkP/s+u9RMfMLTYl7YW6xda6qWNSg61Kz7AJcPCsnS75k+wJ7+XmhZbans7o
	wOB6VbugCSeOKMZGUXV3zzn9IEnhdLV4mBaMv/F21uk89jWG90v9lIxi7noasOAxMlE
	UskNlHyTNn3fgmdzb5gK1wiTb9UekoxeGnr3o2kiXckbE3D+PutJFnJ+CiV4Js2DUcu
	SEyk3N1vwg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1779808216;
	h=Subject:From:To:Date:Mime-Version:Content-Type:References:Message-Id:Feedback-ID;
	bh=ekP6W3L2ZxOsmh/vsCq+hNmMvd3USewC4TsixkcA4Wo=;
	b=oa60sX5kABg4IEcRTrvlyphe22axY4tf5JCgGXRRQT6Dy6Ez8V0KuLFBDpAkHICm
	WIR/iglodATZUW+Dxc4xZMOfsSVN9lbxrVEFi6s2ZgLJiw0htBad3+36UufokP1gk12
	if9xdiISRl2HzFPqHMcY1o7ekLba2fj8hxwMZVWw=
Subject: Practice and Experience in Advanced Research Computing 2026
From: =?UTF-8?Q?Meghan_Wood?= <meghan_wood@expoprimelist.com>
To: =?UTF-8?Q?linux-mm=40kvack=2Eorg?= <linux-mm@kvack.org>
Date: Tue, 26 May 2026 15:10:16 +0000
Mime-Version: 1.0
Content-Type: multipart/alternative; 
 boundary="=_nvr5ra4StUc+I7ZfRPJXkz5XcpYKluWRPsOe6lEyHqXcdip7"
References: 
 <!&!AAAAAAAAAAAYAAAAAAAAADqSpoxM/41IsNlzT74ll1UigQAAEAAAAKdfzPJd4epKvVRnSc7TzS8BAAAAAA==@expoprimelist.com>
X-Mailer: Amazon WorkMail
Thread-Index: =?us-ascii?Q?AdztIGuLYOFqx3TgTG6H4WBcv3QyRwAAToigAAAACiAAAAA?=
 =?us-ascii?Q?KgAAAAAmwAAAACrAAAAAIsAAAAAmwAAAADkAAAAAJcAAAAAlAAAAACAAAAAA?=
 =?us-ascii?Q?JAAAAAApgAAAACwAAAAAKYAAAAAvwAAAAFMAAAAALUAAAAAmAAAAAGiAAAAC?=
 =?us-ascii?Q?vsAAAAAsQAAAACrAAAAAK4AAAAApAAAAACXAAAAAL0AAAAApwAAAACtAAAAA?=
 =?us-ascii?Q?KMAAAAAvAAAAAC2AAAAAK8AAAAAtQAAAACvAAAAALUAAAAArgAAAAC4AAAAA?=
 =?us-ascii?Q?MgAAAAAsQAAAAsBAAAAAM0AAAAAugAAAAC3AAAAAMcAAAAAwwAAAACwAAAAA?=
 =?us-ascii?Q?M8AAAAAvwAAAADPAAAAAMwAAAAA0gAAAADCAAAAAMEA=3D=3D?=
Thread-Topic: Practice and Experience in Advanced Research Computing 2026
X-Wm-Sent-Timestamp: 1779808215
X-Original-Mailer: Microsoft Outlook 14.0
Message-ID: <0102019e64d6241e-da6b30aa-37c4-42c8-a4b3-b59027a51b69-000000@eu-west-1.amazonses.com>
Feedback-ID: ::1.eu-west-1.b24dn6frgCi6dh20skzbuMRr7UL8M6Soir/3ogtEjHQ=:AmazonSES
X-SES-Outgoing: 2026.05.26-54.240.2.155
X-Rspamd-Server: rspam11
X-Stat-Signature: y66ey4yy3u4gs1kxp6snkbpapz76skjq
X-Rspamd-Queue-Id: C82E320017
X-Rspam-User: 
X-HE-Tag: 1779808217-739306
X-HE-Meta: U2FsdGVkX18nie94VOqIs4PcV0wYGt+wT4mtTmj+s1rdAWJEAM18VnYL15CL3JatmgXY6dudM+Vb4xWfT/E7coeRLkMUb/h1AFVyQvhamoL0DIJnrHJufRkXy+Fnih0Lr+kXuU65eQdlKrcORN4itMIj1idInKFZwbPkYy0ieNMCl9vOEgBVgkcb8JnIqvVhPi1mOIrBRGeJfhEtBl8BNdyA5v4t0vepUVu67Vbb9Eim7UE3ylA6d7A540MSA0klLb8LnMiLz+aDhIFS4IZAdQXAVt5psbqrC3KatunSyXd9Os3Jg0xociNeeDmt5YxSHGlNe1B2Uxc56Hc+MgcVK+1mBWSdofqSVHJVNd7g0CLp8V4eXKdBh8yPGuO+dSI3UysmyIEIgNHRqrQd74RSzIh8nqGMYED6pTiaJZgYopiIdgsQBLcnmr6OYV3aSt+gqJ+XTh4V7WDQJ9D0dBNreSJbBDLz9OFQPHvIL5IZTWAzRh+F7C5TPX1fHfHiR94G1kJi/dxiy0k5gKuPraXYDXJfMzAiwSw2X8t7KRY6KWSKoLo8O5dbT5sir3ipbFVUGKOOLbGdIT78ojWwEZgynRlH2OOfjW4Qruo5Yn2nmYrr3TMJGC4h21q5vnNDuhKUQfyguhlxXgxT9Y/eqSMKP5HeAhAVM6K4miL778S4MbiuW4ZvCxv1ZyeCQp5s/tCsG5w9/1VhjbYUsIHqSEh3V1DQr1lCCzvxsVV+yalxcKH7X0ribheNJXECedtuUDsOUPjWrgE2PdvvOn6+knDn7m0j3GxlK+YQke8CsDI6SqJRVYFASmD8FRmh/a3ZlE3dhtIvuL9iTjiOs3sV0TP698P8FoFMCGWPQpXSLmgB2Umk2Inm5OTn34rbNXiB/y06R/52d6w+5yu8yDgHDWK+hMKAr1eV/zkbdn1YdsUs6aAslByruig1adlRWMA0XO+BpeTH41+I1Ofo3bRBCks
 dQsFHg5u
 DyIWeKT6hxKrT1frGMnP8Ob84hPyX1RbQnaDsZFePqcpWb5y6So6gcDOtLWLURignmw6GPgAUoNl8kms/hkw/f+7h7WcrXfrVodlb6L3W1ansFMs25xJCdHXyaFOLYT1ZUgbUBoo4GjeKnbsjOo0GeIsY3Dxqo+IiMfkFjYIk70s+nsKcb29QX4XFVafh0Ty8fSGEC/9JtQQV1+/MkmyiBFG2OUz6312FF6P1dGRjIlpY5Fsf9Bb2aVUwxMNpRO0QtCeIFpaQ8yIGLfEJGHYqwqH8RYPNk4PT+nazrT0rVk5FUkOr2idQyXDaYMrsQdC8lhgha1SJJemQ8N/pbcnqWo20HYKc9dGdZPwgWjuSKfFcsCm/rb9WkZSV2PjyoJJvteu2VGmvL9VqPmbTvmpg/ktCLQFSaryh84bhm2BkHcc2wBlg5LNU2lHBEZ8wQvJJ55vckkmc6AN6detdReyxCwoxmpeoCaZBCTO9wWSqud+aE1OfvG8p7WAZF+zD2eUDx0quJ2Nplq3GRc/FlqE/epKOgVOXqORxXdPQCyPbemV8b/nCLBb48bkkoZNhK+CeEvBZWPh397zjSI1RnUxwEm3shlV+gCdzIujNhhx8J8EorI/NBPR4xNe2TAuligQKHCJ04VXUtDJsr0+rYU95OmgagslE9a8m/vsAQd72nKCDitNyedAF3i6X2g6a2VCil9iL9lpIzMK5r/0qMHaWmXvu0QwXKNTJFW+3zCokyp3TiqonUqG3zPKLFc0+jRgS0dDb+knjbZG7SRq3PPHDj/gLOyuQDJEoOFi26bQ+r0K3JaRXArO55zLEAltL5VH2Xqs+c3wOTGwdfiZJ3VJs6GonXeJTOdrXuWLddwhpvugoVlqXXafBWLog+zkbH13s8Wt+aci4vdIkGkDQLR4E7EL08cddrZI2ulcuhsa2YdXJJFgzn4XWl26QDC8p82ehrz0jyq48eEE0VwlbaYY+v+6lWdny
 KDmJYslp
 ZiwFLt4++vA/X0fgtt2g8Btc6GiGuRpf3B9gNuf0MfsPX4gCiP2JKQBrbOkkNiA+gYzm0f76fp+h11NMf0wIyN0Ixox9mnjvMoU3DN1TwBHh2a+iDmywzmUfl3Ws6nrOrsgdKWFkNns38/pFkymUXLRVTPl/3lWSEn04fj22wbYMu5hiQqh6lH7L/dGonAflWx/gqJbVuK/lES+ewQSSDepPG4dVVRmf+2ztVLa/pLBEL2vCtDNP31ALyEfMavvvgxJopZB4Z+1xJQZ9j0/P1Ml123B2tfWTioeCJJ2zNgjx7kfapTqNI6/SE0cc7w+/SDCQo3cllTWQzxqbc4vQ4GhebEAwq/5z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format. Your mail reader does not
understand MIME message format.
--=_nvr5ra4StUc+I7ZfRPJXkz5XcpYKluWRPsOe6lEyHqXcdip7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear Exhibitors and Sponsors,

=C2=A0
To help you prepare for Practice and Experience in Advanced Research Comp=
uting 2026 in Minneapolis, MN, we=E2=80=99ve just released the early atte=
ndee list.

=C2=A0
Having this data allows you to reach out to potential clients early and m=
ake the most of your sponsorship.

=C2=A0
Would you like to see the pricing and access details=3F

=C2=A0
1. Yes - Send me the full details, pricing, and data format.

2. No - Thank you

=C2=A0
Best regards,

Meghan Wood - Events Manager


=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0


=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0
=C2=A0

--=_nvr5ra4StUc+I7ZfRPJXkz5XcpYKluWRPsOe6lEyHqXcdip7
Content-Type: multipart/related; 
 boundary="=_nvr5BNMnzHH9mQUJqZVzSSI9WuSynhKh1LgeELGcoN0JFlCB"

--=_nvr5BNMnzHH9mQUJqZVzSSI9WuSynhKh1LgeELGcoN0JFlCB
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-mi=
crosoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:wo=
rd" xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://=
schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/=
REC-html40"><head><meta http-equiv=3DContent-Type content=3D"text/html; c=
harset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 14 (f=
iltered medium)"><!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
=

o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
=2Eshape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
=09{font-family:Tahoma;
=09panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0cm;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:purple;
=09text-decoration:underline;}
p
=09{mso-style-priority:99;
=09mso-margin-top-alt:auto;
=09margin-right:0cm;
=09mso-margin-bottom-alt:auto;
=09margin-left:0cm;
=09font-size:12.0pt;
=09font-family:"Times New Roman","serif";}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
=09{mso-style-priority:99;
=09mso-style-link:"Balloon Text Char";
=09margin:0cm;
=09margin-bottom:.0001pt;
=09font-size:8.0pt;
=09font-family:"Tahoma","sans-serif";}
span.BalloonTextChar
=09{mso-style-name:"Balloon Text Char";
=09mso-style-priority:99;
=09mso-style-link:"Balloon Text";
=09font-family:"Tahoma","sans-serif";
=09mso-fareast-language:EN-IN;}
span.EmailStyle20
=09{mso-style-type:personal-compose;
=09font-family:"Calibri","sans-serif";
=09color:windowtext;}
=2EMsoChpDefault
=09{mso-style-type:export-only;
=09font-size:10.0pt;
=09font-family:"Calibri","sans-serif";
=09mso-fareast-language:EN-US;}
@page WordSection1
=09{size:612.0pt 792.0pt;
=09margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-IN link=3Dblue v=
link=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Dear Exhibit=
ors and Sponsors,<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p=
><p class=3DMsoNormal>To help you prepare for<b> Practice and Experience =
in Advanced Research Computing 2026 </b>in Minneapolis, MN, we&#8217;ve j=
ust released the early attendee list.<o:p></o:p></p><p class=3DMsoNormal>=
<o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Having this data allows you to =
reach out to potential clients early and make the most of your sponsorshi=
p.<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMso=
Normal>Would you like to see the pricing and access details=3F<o:p></o:p>=
</p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><b>1. =
Yes - </b>Send me the full details, pricing, and data format.<b><o:p></o:=
p></b></p><p class=3DMsoNormal><b>2.</b> <b>No</b> <b>-</b> Thank you<b><=
o:p></o:p></b></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMs=
oNormal>Best regards,<o:p></o:p></p><p class=3DMsoNormal><b>Meghan Wood <=
/b>- Events Manager<b><o:p></o:p></b></p><p class=3DMsoNormal><b><img wid=
th=3D124 height=3D49 id=3D"Picture_x0020_2" src=3D"cid:image002.jpg@01DCE=
D00.3679B100"><o:p></o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p=
></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoN=
ormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:=
p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMso=
Normal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o=
:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMs=
oNormal><b><br clear=3Dall><o:p></o:p></b></p><p class=3DMsoNormal><b><o:=
p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p=
 class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o=
:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><=
p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><=
o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p>=
<p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b>=
<o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p=
><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b=
><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></=
p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><=
b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b><=
/p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal>=
<b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b>=
</p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal=
><b><o:p>&nbsp;</o:p></b></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b=
></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p><p><o:p>&nbsp;</o:p=
></p><p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p></div></body></html=
>
--=_nvr5BNMnzHH9mQUJqZVzSSI9WuSynhKh1LgeELGcoN0JFlCB
Content-Type: image/jpeg
Content-Id: <image002.jpg@01DCED00.3679B100>
Content-Disposition: inline; filename=image002.jpg
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAoHBwgHBgoICAgLCgoLDhgQDg0NDh0VFhEYIx8l
JCIfIiEmKzcvJik0KSEiMEExNDk7Pj4+JS5ESUM8SDc9Pjv/2wBDAQoLCw4NDhwQEBw7KCIo
Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozv/wAAR
CAAxAHwDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAA
AgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWG
h4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl
5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREA
AgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYk
NOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk
5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD15mvQ52QwFc8EykHH/fNJvv8A/nhb/wDf
5v8A4msOXxVdDULi0ttJe4MDlSUck4BxnGOKu6Hrx1iS4ie1a3kgxkFs+vt14rCOIpylyp6n
XPB14Q55LT1XUv77/wD54W//AH+b/wCJo33/APzwt/8Av83/AMTVmsfXtdbRfs4W288zkgDf
jGMe3vWk5xhHmlsYUqU6s1CC1ZoI16XG+GALnkiUk/8AoNQ60yppM7sbwKoDEWSkzNgg4UDn
np9D2qlpmt319erBPpE1qhUkyPnAx26Vt0QnGavEdWlOlLllv9/5HMWRvj4e1aaOS8E8kbtB
A/mM8J2cAM4yxJ544BOB6mfSSf7bxbSai9r9lO/7WJdok3DGPMHXGeldBWHrfiNdHvoLb7P5
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
KKACiiigAooooAKKKKACiiigAooooA//2Q==
--=_nvr5BNMnzHH9mQUJqZVzSSI9WuSynhKh1LgeELGcoN0JFlCB--

--=_nvr5ra4StUc+I7ZfRPJXkz5XcpYKluWRPsOe6lEyHqXcdip7--

