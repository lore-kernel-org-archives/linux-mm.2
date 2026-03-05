Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869EFF30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC126B0088; Thu,  5 Mar 2026 06:35:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96286B008C; Thu,  5 Mar 2026 06:35:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81C66B0092; Thu,  5 Mar 2026 06:35:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7D696B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:35:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D85413BE88
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:35:11 +0000 (UTC)
X-FDA: 84511803222.02.D76BBCF
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 470661C000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:35:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EE5OWCp/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bHvCW9+dpgONSqol0mDEJ0h5GgkhDHyF5RdxvmOey8=;
	b=HE3+KtVk4c2wZ3/X7MIKVLbSag+MlK1cS8wESXpp1dNUx+ZkOhzW3S9vnZrcEPQo6oZOha
	AiuvRplUqKMUSQvs8E4QX5e46um3lDRst5KoiFsDIzN1DVOavgPVj2UTna6Bh6vQTwkOQS
	ehwQaGhLS3Y960iw2wqadpkJeGz+XmA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772710509; a=rsa-sha256;
	cv=pass;
	b=FNMYKKPGRHY/ze2yhKxjmiLJHBUN/TYJYZ3avzbQ1PSQH98vsQUQYBnM9FMEpP1qvtjolq
	sMTIZRqNztkqJ9M9GwL5OV+X/sKLh/OLNeNsfmavfoXJA5XZXVEBScZaiTMpZtqtx0bwGB
	vu0sihmejErtJ1ksGhsjRWRvcCPo0aY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EE5OWCp/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a131870b72so760536e87.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 03:35:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772710507; cv=none;
        d=google.com; s=arc-20240605;
        b=cbH7jtCgpedN/HM3Gf7RXNaUtlcrFB3C4n4pp+UKS9e/Mv03Tgvo0rUFAUuef9DBjR
         Z7jW6pLVYNyv0fn4tO9TnAk8c7DphRxLTf6+SJmrIiJhL7oOginX3pXTVfXBQpY/MPzs
         jjOb19tMSdyI3sI0b9ZbbxniGJqmjzOqFtoFHl92QD1DG9cSj/L0syGEJI7qDTFd2aws
         ARCqi9CTDX2FsR37gej2wQpjygbYlTNGbc5eJARzql0g4c4YcIzhQ2fqe9m3pxA2Q6/M
         xZTp8hbTbMXJLZ+5EiN9AB56jlF4z+djaz1QJXKQQTB95Zikwcb24/qU5gQNUPK3tPyW
         RfCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5bHvCW9+dpgONSqol0mDEJ0h5GgkhDHyF5RdxvmOey8=;
        fh=kyW0xutFlYxYFoDQVssd9/I5tYG5xp9dlVzXsPR5j6U=;
        b=gTT6gDhCnkae80IjNX/4a6oBveaaZYYkBVsWUspM/fNxvTDWkB38ZgEBLK7SXGUwGZ
         7bohPFNb7MNinrMLoCrK4/gRhkfkLYkCJomlJMeKbR6r21+vmLyBF4ItsyW5OWlrvAUL
         dVp59Ra+Suo8NCQhrJSs/rese/qN1m+rxrySPvvY3K8BXtoW42767oHe8hP1lLW/8gS2
         jSJq4L9s0v5uYNKswzyQWEarbii65hnu8ITGI6E2vk2VXtDvDY3oY+/UJW2oOMwlt8MJ
         sJevhQwigUoDJHLEXXrKcfHwdBaAbD9bFO+Voic13bAX0ridNhYB1JT1bLQ/cvwqsVq3
         ia9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772710507; x=1773315307; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5bHvCW9+dpgONSqol0mDEJ0h5GgkhDHyF5RdxvmOey8=;
        b=EE5OWCp/a2Cad0kN9XMDvU2e1OuvMAjwa1u4m1wWhavRx/gXvuZgTldjjRwplNhBKW
         F3xu8//XNYTAX5lMnOAkqGHtKSyyGAFt2SaZ0QVS8ffR4lBYhJMVTbmYb3jYxfWTNqYL
         s8wjYB32OxOppH76X8iqfwy5E6wW7u5PJNlSaAQL8xNjg8ioS+jXs7oO/CoqiRgzlKpa
         uP1FYnCE3eOHNsndyx1ssC2+OVx9N6reujh9VJC9lcZVGTYwxa92ATITtS27+n8o1uiD
         eWw0dOAxkiAaSl6jxQVVdFuHsKJ/ED506aJOkJVRhwiuKNRvENASioUvnMBbsNU0MVRR
         79VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772710507; x=1773315307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bHvCW9+dpgONSqol0mDEJ0h5GgkhDHyF5RdxvmOey8=;
        b=ReDf6FZhcKwxLVfhLcFMU2ViffZot4G1OTcuK9iQgvlpIPLq0WYoG3iTghEbhCb6fp
         WTtm34Qs7VqbdO5rWnS8FYD2ypt61Tw2ix8uqptSAy9VCLk1piSLJDJEKzxg7dtUa1Z+
         ZOvBDo3quwOXS4UiK5xvOycTMdtz7aK8rcb58AHY38Ak+hmemQyQExQvYPkWqP5+Kn3Q
         9FMb+RwDme24pMt07rNMI3CBMhAdSaXANnGgUdc/i9SLYiGP6itAMxp3ki5KrjX+9mp7
         HIodw0OQDiYc7aMy+Pi5FbN52M1CLjAp4PObX2NilfxqcC2zx2PihGsLjX61tglEwvSX
         G+fg==
X-Gm-Message-State: AOJu0Yxly1uRUHHMwF61i5HanY2KJ8677k7wq3w/WnQmZDaIufKOaVUD
	vsf6fXj8U0nLYxbXd5EidMHP+ILN8XZDqFsLEZy3yfpedJrN1qGnAgWTGyHz9FzHVBEmPcabYUN
	ir7bzz/dzigYlvMhUxsWFMyEOyJOE1ZbpEcAm
X-Gm-Gg: ATEYQzyUS9EnVsXmzhxXCu52LOYfqLhTbpXLAewlPtOb9XF/iSCHUU5iHgF8SF+LTT4
	FE61bRuaj6o5yjFT8T7z1+xP1jIR7mp6xYy5taoYLGlv9neaxLsQaJhqwMwODjnYuTMZ32lXewx
	RvBASL8mshlW0L0CAK5fmDjw71MWMKnIoElHm1G9XUjd0wyH/2LnAnNP9p4XLSiLW0f6dA+81d3
	obsn3kUjSnbxflKAKy0nt/X9gUlVJmxCwYcv50/f7q8rSJlAz/v6JCIAxfwktsyecIvKXTolwCj
	StyHCsOAiSvli9oa2zNMoRaYDX/SwcOiIUMBBgtnUoeJxTFtW7p2AxRthx6RH4rPXooz9auLlWu
	SgP8OFyk3tyQMFEgguHxPq8TU
X-Received: by 2002:a05:6512:2388:b0:5a1:2e81:d3f7 with SMTP id
 2adb3069b0e04-5a12e81d558mr779281e87.17.1772710507125; Thu, 05 Mar 2026
 03:35:07 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org> <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org> <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org> <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
In-Reply-To: <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Thu, 5 Mar 2026 12:34:55 +0100
X-Gm-Features: AaiRm51H7ngKTzKcIfjBcmnq0unP_iSfw_NV-8Ml8Kl9NUMYOHMFukUzhIssNrk
Message-ID: <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/alternative; boundary="000000000000112159064c455465"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 470661C000A
X-Stat-Signature: n4jt9iykhoxmc7t9j7c7rc93nsnkj7jq
X-Rspam-User: 
X-HE-Tag: 1772710508-932733
X-HE-Meta: U2FsdGVkX19PYuE0V2hAVC5FcIipGso5jQPsfohFZqmczkoEBY2cv6Z4yG4TxK5cESrEbvmpiGV/0Z2TEVw6PlynGrkTTNxobxoFMUkWTokN1Lqzxw93ox3fC1aHCkHw4RuXHCHWeY0gSBMaijFo8hYrFbFQBRHNijkNh8RMt8E1aQ61IH/mNM2OBV4nvCFO6HrArRNfpMdkLgnhlGWFlAGOcSCHC+6GOfx3fP01woBP55KEKU4ZX3q0aeWO4o5aI64jYzBGp3OATiUp1wMMkUDSm8SOfoAsyolhFBpgul9013gmNs9LEI9TTJHL+Xh2H4dtDTjsxZQQ73o72v31/5uElqZ3UJLeFTrxWMi1DEHVSPMTi6QUd/x2HmnfksXSHOZMTEhPEYdDyMjoIWViynBGdVLw+i0Jd2J0MB8VVbqR/5l+gZ/toyN7cNNY4zxwpeKw0zPAqrH4cnN52pL8t9vtWqgN5rLZFZLtQmvnKqxBb/1Rk/AZIl5F+T566nmu3YTHCkYXPZR7inpcH0xx2RGDFrdcHrr3b7/w1v65IY2/62civG3AhO1B5y36JJ+mAdeAqfHVn4JaCQ8KvQ/gMdBp2XdlJpz3K3CbDULcZOad1EuaUvSrTQ/+J44vqM60Erz9pE6YRU1YZsF4A39F9wjPEEsmIe5Hcc1c/akuIT/oKEhjkUmEpYiAJk7WdVDziPX335foke4t4eFluABrbcfICrL+a+1AfmwaFO/JMZatDBbtV3XT1Vm3JUowvFMi82EcRLGMHE7aVcfOkKegL3x3cecMH96XxEUt/Vhxur7/k/iwsjln9PrCNxJMXssHQzp155C2wDF1fqEHOczfHmAlk4wB+Gamfxus5aBPk7QeRrrtpM3E+hMaVZfrTPddJJOtoNmI0uxYjPsbgph9theEJHEXq6dKz5mL8OIj9AQhW2JwXXqMVD55t9gO7+nfApV1BjGMQ+AV55tXbOr
 WhEcFr66
 YOKHWEUalhqnJA3IKzkePVBjMIFIqkvQQjlYYobFXvU8GvFFCdRzKka0E+c4LH0EmT9fBq1ZbqUeuLziEdnCgDFbcsPcrOCqHMYq3eG+krSiKjBd7iJS4VH3cvRRHbuyqO+J0ERHix6MG871le+iXQEFNFKoPaTeiZNN/xh29msf407Ok6mlNEwuDYtoJSSi852DtWkM7mYI9jXssmlJfZYJ2QfLou6Hdm3EnC91/XAhRs3js6r6zaHpbq93kASBJlkYkHvhA6Sdb0nAgSGcn6xKCajCfbgZ9ihf4PhIkTv3+Ir2YaFugtve9QMQCmCqPUGgRDmkCmyxXTztR3TQM4zU7KRhKdpoD1l/MyxgKK+Uc/IMvexAUahPfcwpBNVINiPG6NZzzbOHH2m8vNWB+Nys/UVjOrNtiOzA33Y1o24j0LVn5ur8PO0yq/3WgBfQ9//2NSjTUZ4Ahc4CeiJ9le48K7NXpI0oed3bP/SA/nB3c1OyJVh++Kg/mA041J0UQG5ww7DJlplCKNQBzEJGdjsbqkH9Yzdv9rIW9R8r+onLXF7cwzg3H8NcaaO/eidH7AOwxfQUkLqx6qIlcGXbvdHA3G05j/+hH8pFe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000112159064c455465
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Well, i would better not as i would have to put this on production as i
have no idea how clients are triggering this in their VMs.
Cant trigger this myself.

--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


czw., 5 mar 2026 o 12:33 David Hildenbrand (Arm) <david@kernel.org>
napisa=C5=82(a):

> On 3/5/26 12:29, Tytus Rogalewski wrote:
> > Memory space was fine.
> > I have big mem usage as i allocating 95% memory into huge pages 1G
> > so the rest is 32-64GB of memory for system. Anyway i had plenty at tha=
t
> > time when this happened
>
> Just to confirm, you were able to reproduce this also on an upstream
> 6.19-rc4+, correct?
>
> --
> Cheers,
>
> David
>

--000000000000112159064c455465
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Well, i would better not as i would have to put this =
on production as i have no idea how clients are triggering this in their VM=
s.</div><div>Cant trigger this myself.</div><div><br></div><div><div dir=3D=
"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">czw., 5 mar 2026 o 12=
:33=C2=A0David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">da=
vid@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 3/5/26 12:29, Tytus Rogalewski wrote:<br>
&gt; Memory space was fine.<br>
&gt; I have big mem usage as i allocating=C2=A095% memory into huge pages 1=
G<br>
&gt; so the rest is 32-64GB of memory for system. Anyway i had plenty at th=
at<br>
&gt; time when this happened<br>
<br>
Just to confirm, you were able to reproduce this also on an upstream<br>
6.19-rc4+, correct?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000112159064c455465--

