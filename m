Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2992D10F9314
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856686B0099; Tue, 31 Mar 2026 20:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8347A6B009B; Tue, 31 Mar 2026 20:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B636B009D; Tue, 31 Mar 2026 20:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6790D6B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:59:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DC871A0504
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:59:21 +0000 (UTC)
X-FDA: 84608178522.19.7E9ECBF
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 33F3F20003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:59:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xl8e16Nw;
	spf=pass (imf03.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xl8e16Nw;
	spf=pass (imf03.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005159; a=rsa-sha256;
	cv=none;
	b=1e20gM2CedCtec8hoNnxg8usrwT1SQjeokqEMTamp8BBRL/QAJZLI+2f1TRpVWWEjydvAx
	x8rQBqeUgB/GjLcS1E5h7OTYBkxbrzvqghzZm8EEyzpCD40xa1rhrf4CuJSoPnbm3vGl8b
	ajgnKFiqDZoXq4CKoCBVL5Rp8mDlQa8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enPi/jTnBX40fIZnKN4ASLdfaf8/Sda6QK+UaHUO80c=;
	b=j67+O7ziht/zoZSFfK1JTDYSVmnvGk6plJDzEHhP8LfIKIhQ4X67TFMQ5l+T/GL+5NknAg
	pUzml3R09TuJGSHrEgfnpaSQoZI+S8+6zGp7S3Gwor1ghnB+LU7aSvuruDaekLg5mWBeEc
	n1Bsl/z2oHa4JBmkiq0xUac1sioy/tY=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775005157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enPi/jTnBX40fIZnKN4ASLdfaf8/Sda6QK+UaHUO80c=;
	b=xl8e16Nwx++zzLIJJx4lfsiW1ZlfZYmgPc4Plymf6QFTUcDhp8VOHx8MuWCO1AahnSm3aA
	8wQcqySZYelDiv741yiatvcwusXHIrtsjF6hKBSddjrwrNKeV0hb66E6jL2aeW5BExrR1q
	+2n1Aj/LupdEbRvan0ENHPwqd5up1UQ=
Date: Wed, 01 Apr 2026 00:59:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jackie Liu" <liu.yun@linux.dev>
Message-ID: <2d001f10532d0c89ab118c6734d91ba3a4b7d89f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/mempolicy: fix memory leak in
 weighted_interleave_auto_store()
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
Cc: "Gregory Price" <gourry@gourry.net>, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org
In-Reply-To: <20260331192105.109847-1-joshua.hahnjy@gmail.com>
References: <20260331192105.109847-1-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 33F3F20003
X-Stat-Signature: q76u6wf4omxsy54fr44gcc5ufm15mxed
X-Rspam-User: 
X-HE-Tag: 1775005158-165681
X-HE-Meta: U2FsdGVkX1+QSbSemedyBvjsCf3ANPWwcR2Cz1dW1dHnT3XORC09m0+uNJQXj6xiAGihF0B1c3tuCNkDE8s22VzRwlK+2sxtEMjKMp+zOUPJmg9SlL7BuE1CIK/lb9fHrvniPw9pP6InClaX1rAcxnTqgrILjf88N4sfIgG06LssXTA0Idc1nZwkF1JIe41ctsB0E4aQHUzZXA/rMIOVYMxdIMLb4Q+D/2pjjbxHq97SBQ8DX1JJY2peYZBL/gdjjWvZsbpbWAfo0AngXa4VlWlokA5uK/fvpB+pKLAPHUbroBCucr8O6RhD9BfnSFFcifTpZWY5eyqxhZVkxekQ3b37VgDUgC7ZNBHf2nwRVysr9tro7uziA2yLDiuH/ry5Btcp1T++pKeOlYWn6MQLIDMO9T0cAf7OJx3KCfkDlk/HwsA08it4376zMwmbg7tYFcKgVk/SjFLJfDb9pfwKQRRyVFZI86L+RujYrelG+Hi3pBHhhz0xTLGl8/2LxI2L/MTXVMQId4UKq2fA7vcWRuStvrQ9k1FKGPVML3XeQ1K1Y4r41ThZE/zKNIrnfF4/mx23Fag8kGhSMbPZ8x8CJy0Npw4AlfHdWENmImZ+OgKRiI4yXzv1FdiskoS3TOUuHCQMpQV8HsRBuRMawXd2KGxBG15SQ99Ff2rFMPI3BnHuzOctEvccz1GOCishLZetfsBsjFCIM5aOkQOTu5v8AKRQDnjMXaGKEQ2FyuZIaVJ8lvHEsacT8+oB/AUB2JwNQVcNCtsSpg4cLqxuz3TNnziYgr+4JJyNpyi3is+GKz693Zdb+pZDZxAwMreFNH+9YB8gMzP72vt4C+p/F5Exjuslf2BN08R8u3v+y9chTwNTP7nQysqDmWsLW5GLQgi4ADW5oog9OpNXYnNVHeR4+g0OslKYZcQP9Fbp1VhCs8T7yekmjFrbfrCnkEQCONETxJfRdsxy51oSBW2oY5y
 7VMCjTHs
 g2qpOS5xEmImk+Ja56udm19YMb5yUEBxI8uM8jgrlUBYcphISTzSKvQc12fTOPYd4W1VfvSOB5qGzmAdsUrHdl9STaU2Dl9r1mu300HFUfqKXXbkjo7pm3mRoDxwX4kFBb5NmBdES6BlAgfBhSP3Ckpllj8+bGRGb+GadPJTRksTZDax9IwC++sg0OWqeO8MEnh9KTNy9u9Ro/68izFZ5dtbQk7PcgBjHJMshs3qVolEh2ZQhNCg7+7q799+ewtI12VkE0NL4ZGh1TlrrnXtZVWS0Ttq2+kTVOYIqKXH3QPHKhCGr6LGPJ1YmyAeh4cW3gYqKp8R+XzxaprgTEQ1MqUSCdhjjIZkpuPLbNVLLAOf7HVq4/ECtvzWfAGpU7NhPAM87P08C8SiSU2e0aD17lP+WOuvOH+6HKVCCsimWc4pkFt69+fmKwzge7wKt8sUvtLVDxL4u49MExjwk21UTtxiwuZs0lLvagyWq6CDrT2/oa8NKilELRc8jZHpe89E8gy2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B44=E6=9C=881=E6=97=A5 03:21, "Joshua Hahn" <joshua.hahnjy@gma=
il.com mailto:joshua.hahnjy@gmail.com?to=3D%22Joshua%20Hahn%22%20%3Cjoshu=
a.hahnjy%40gmail.com%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Tue, 31 Mar 2026 12:01:10 -0700 Andrew Morton <akpm@linux-foundati=
on.org> wrote:
>=20
>=20>=20
>=20> On Tue, 31 Mar 2026 12:53:40 -0400 Gregory Price <gourry@gourry.net=
> wrote:
> >=20=20
>=20>  On Tue, Mar 31, 2026 at 06:07:40PM +0800, Jackie Liu wrote:
> >  > From: Jackie Liu <liuyun01@kylinos.cn>
> >  >=20
>=20>  > Add the missing kfree(new_wi_state) when the auto mode is alread=
y set
> >  > to the requested value. When a user writes "false" to the auto sys=
fs
> >  > interface and the current mode is already manual (mode_auto =3D=3D=
 false),
> >  > the function returns early without freeing new_wi_state allocated =
at
> >  > the beginning of the function. This can be triggered repeatedly fr=
om
> >  > userspace, leaking memory on each write.
> >  >=20
>=20>  > Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tun=
ing")
> >  > Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> >=20=20
>=20>  ..
> >=20
>=20>  > --- a/mm/mempolicy.c
> >  > +++ b/mm/mempolicy.c
> >  > @@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_stor=
e(struct kobject *kobj,
> >  > goto update_wi_state;
> >  > if (input =3D=3D old_wi_state->mode_auto) {
> >  > mutex_unlock(&wi_state_lock);
> >  > + kfree(new_wi_state);
> >  > return count;
> >  > }
> >  >=20
>=20>=20=20
>=20>  Thanks all.
> >=20=20
>=20>  Am I correct in believing that triggering this leak requires eleva=
ted
> >  privileges?
> >=20
>=20Hello Andrew, I hope you are doing well : -)
>=20
>=20Yes indeed, writing to the file requires elevated privileges.
>=20
>=20While going to check this out, however, I noticed a different bug whi=
ch is
> that the file is no longer called "auto", but called "__auto_type".
> I suspected this was the result of a newly defined macro, and surely...
> commit 6cce897a37dc "compiler_types.h: add "auto" as a macro for "__aut=
o_type""
> seems to have defined auto to always expand out to __auto_type.
>=20
>=20Of course for using the __ATTR(name, permissions, show, store) macro =
this
> is bad because writing "auto" there no longer works...
>=20
>=20I'll send up a quick fix to just manually write out the name instead.
> Doing a quick grep for the pattern thankfully seems to only point to th=
is.
> I do think it is a bit weird to pass a raw, unquoted string into the ma=
cro...
>=20
>=20>=20
>=20> I'll add cc:stable to this and shall queue it for 7.1-rc1.=20
>=20>  This means (I assume) that its entry into the -stable trees might =
be a
> >  little later than if we were to upstream it immediately.
> >=20=20
>=20>  AI review liked this patch but claims to have found another one:
> >  https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.=
dev
> >=20
>=20Sashiko seems to be correct here. Pretty neat that it was able to cat=
ch
> a related bug when analyzing the correctness of this fix!

Thank you. I quickly wrote a patch and sent it. Sashiko looks amazing.

The link is https://lore.kernel.org/all/20260401005702.7096-1-liu.yun@lin=
ux.dev/

Please help me review it again.

--=20
Jackie=20Liu

>=20
>=20I can send up a fix for this one too, or leave it to you Jackie, whic=
hever
> you prefer! Just let me know : -) I'll go ahead and send a fix for the
> naming issue though, since that one seems orthogonal to this.
>=20
>=20Thank you, and I hope you have a great day!
> Joshua
>

