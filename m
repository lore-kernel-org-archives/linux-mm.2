Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1009EDEBF0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028F86B0089; Tue,  3 Mar 2026 16:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F217E6B008A; Tue,  3 Mar 2026 16:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37836B008C; Tue,  3 Mar 2026 16:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2B056B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:08:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A5008B20A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:08:29 +0000 (UTC)
X-FDA: 84505990338.13.FD5183D
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DBE44000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:08:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLxKDyTs;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772572107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
	b=7am1GpR0ZUC6vUNHs3mpUHjeAJeg+uMysREQqFt/R0flkyoMXOupLRYOyTOyDT3WDLULiq
	N9/4pIdcEMm5JEZRLRa4kBhlh45AoB/oYyqcJ3MNuGs1nAPfThLzGBUX7lgi543Yv0VMgt
	O/SoS1tnlWLufjHIFuKShmeUsNBeX7c=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TLxKDyTs;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772572107; a=rsa-sha256;
	cv=pass;
	b=vvZHuWQLWMyd0c/O380LTdU9Cyrubbe72A2hGnyqChzjrwhEspPKJ3c2AbwISVj7oLWybB
	FyfKX/sJ3IbUo8lR5Nes6vbbut9lMGKL7XEBsYmKe7XMWrwhgkfI8h7KCy0s9nZpN4UMm8
	1xWg4XkqfbvFxr87iRvBRLpL3cTRdIY=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505d3baf1a7so652381cf.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 13:08:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772572107; cv=none;
        d=google.com; s=arc-20240605;
        b=JvUOJltf39n6IYQMLQYL4y/Rb8jrLeFgC08U5/bXfjjEO20IS0HbjwOg+7uGLK+NXo
         s7YUC9U+hsFlc5akTVCEoJl9QMzHn2gUt6Ed23vM7aVHTNJ9BjrSrGNHTp7k+DL/nFkd
         h+FclHs/gy8XK3e2AAgi+OuXCc8u39FBBvOWiaCt9dgA5fZ24Q/JNM2Y0cwUgghBm2GO
         ZlQCHyRhdUl4mhMLYqtSdhCsFMc78uvyyUenv/veox+212i0r9ROeAUHNeBXqZagq6to
         P1pDQR9B1i9iRf6czJm4To7lFK62D1cjSWN6dUGIIM/6yYp05SIGK2OLWV+ObJJ83/4Y
         FuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        fh=XkSSUkk4M6csfIMmHpZ26cwbmUGRpazrWQ9JsTW7Ka4=;
        b=TI41LMq/AHy0ZVFGY6SHK+ZAIMFd9kSTq1pmyXCJT1tbQhPLpWfhJdDbLMjoMcbtjN
         sIgjBhVzuKfwIFMKYuZTnp0iGuo91Q+rOiomOO2/wjqlNwQrtqd3IgjlgztzAjvy3lhm
         vXWTzkrWbomLaDYcUesGkX6n74LRxGdsfmLFucWQSxha8VKprjlkExw81r2eDS+dE7fc
         hfOc29RFlYrD2J6DxHDcAniXvzMcPbETbsKnb8wbKhqmdFywfM2DHHF48cE20Z+lRN0O
         E2RPCkfgx+ITiFDLT3NwNYWOfxAY3Mlt9dvDJETbdzwA2pYYqwkpO9AuflR9+20qfsTz
         XqBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772572107; x=1773176907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        b=TLxKDyTss8iNGFX/A7QXzk/fWj5EW5ICl6txkbcVIN84kj+RmxG9Xy8NkapoXMdibK
         YDPJz4uIMLunRqC/BLbd1zjg0O/1z6pURwoSLIlb2TgOtIF8ZRpBbaLsPLbc041I7Z8k
         k0mKKXIrX0pLo8/EZA7FlhZ6y9Iz/+SXY5Jg5nGawmPWqMbZrlVcIxtC+Ri3KNfsvdH/
         XgJSgRRZ752BLbXtt8G5mclJ8YfYvHky6mYM8Y23gieKM0Wp6eB+y5tNHDwDlPCQpBpZ
         dogD3y5kCeE1ewIe8ri87lZiLwZsRbYriYQ1Sq09rDJTAY1jcvaPOPGqGmvxU6vNDdA/
         dzrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772572107; x=1773176907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wn5qswiKl5vyNXCasCn1z2S9Z34vPhCjx+1iyWUKiGQ=;
        b=GiW2ESUwQ+mM58PRzIHiE26madOb2R7nKcnB1vEmtkhawnYQWUSHSjz0l2iy9YUbvM
         BBbnfnC9MFWUCmHDZq4ULcBaUioaa/uIlu5W6zDeK+9ZnYxKuXUvXdgWu0xJkSE4BF/A
         sJ3sSOKCeYRP6SK/c+RiyhjAemzA6nivoU4rq3X1aq07Dg5I3q52DB21q2w5Rq5FzqXu
         YWBnVXRoGFtbdLgeykZQyvzibUYEvn5VBQXQCnyix+AGbC3wF6eYWg4lPrr+rN1VZ8z2
         GutqAjG2J6/7kIEtia2MVU0FA0q4RyAevwUivvqZOtrigA7dPZxkw6ciPoLoW+djIN84
         yFvA==
X-Forwarded-Encrypted: i=1; AJvYcCXR+BjN2F8LzUKL6Iplq01WAlq3KIuvMd/I5Y3vIMZ1XULyY6y04FR55SkYp45uc6YDFD8S9wpZ2A==@kvack.org
X-Gm-Message-State: AOJu0Yw4r4FlfkJVqE28FmV0kJtb4HkMxo2gShm4oYT3sA9RdSuoqjkt
	Z6KWY279jM/+rYoGFySGSRCRhMz+fCs5y+fCGg49NdFoDf96W86bH8doRsCCtispfb/gIWZFwJi
	TDKvsva4bCh0C5O1aD0l1/Umwi6YKWd1z/9PfPECh
X-Gm-Gg: ATEYQzxtvAzDnSb+NTlPxg0iJzHvE5FM1a3SwqCGoYnk4/sFla2ATPH2jV1Jd9sg4PN
	zQjAup/c6vqrYykJiORF5CKntUaHeLTQ1OoXruCaG1LrCeuXR+Rhp0RhUzhDhiIgZ0UXicLMmKg
	iQC0YJJZPAsx1jgV3xVJCzqE+fLKgfUOH0vEb3LKR/S37+dIn5u8UDglMBN/b6K0MwbXkfbeYNS
	1NBYAsHXp207YbpZKhnu5tj21ilJK7uRwhq1UHLg/gVsoR156I6pD5xPY35za1Nzh61XH3q00Hs
	myGdPBnO7a0SR/x3LdV1vS1r8xWbuB3NtqXB
X-Received: by 2002:a05:622a:1999:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-5075fcedcc2mr43645141cf.6.1772572105403; Tue, 03 Mar 2026
 13:08:25 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-2-surenb@google.com>
 <877a55ac-b12d-4997-8c0f-fc0405220a63@lucifer.local>
In-Reply-To: <877a55ac-b12d-4997-8c0f-fc0405220a63@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 13:08:13 -0800
X-Gm-Features: AaiRm50S7J7MsSFOK2DH7gtLJxKekAGMKhFqAJWn8DaN9ladXIEjtSX1nx_7JMk
Message-ID: <CAJuCfpHD8wKJTpaRjZtUR3d+e4hSPH4GyL9DCKwbVWDVxWXRug@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/vma: cleanup error handling path in vma_expand()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9DBE44000B
X-Stat-Signature: jgygqzrocr3q5hf8uoguht9jyynkwa9i
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772572107-996774
X-HE-Meta: U2FsdGVkX1+fHj4R//PDnZ5AG1akm1d8YY18YCOd1GPMeMMjLlaFwgFfRD22M/QqOHCo/WU6LSlJI9KWmG0lePKU+zjwY8dxfCsiLvW57ePTaDBTrOUdFY8HDBUknFcW/LiqO1uF/wN26dI5/KZKrLgqkE79KOkeb88KdYY+34zQZAbLu/jSiiZOpgSJf8O1RrJfmxoLvVhUqLCnibW/898qmbv4kepAs6cUiaZ3ZfcXMWBjSGzJj5favOEAXyRrwqT2rH//waEYZ/nnMTp45jH0syaLHaegrSQWLaMw8h65Wedad7cDvXlAi2jiJlBLVFtnakwydrgHNKsPaq3mQ7oQnqz2/NkUwXW2iDLR5I1UM89j52ktGvHGv2PDQdpJ8e7NPXPJQgSbiy24nMPxALbt35SsHybrHkcXknEB5Ot1APPyOKquBzc7FrQ49TJFO0dwkWyIbNaN6JK5kw9UYjCUio7HYh8ZVJBK3UpkFQJlADw7pV6fddCzMrlCEuIS9eUMucGOBh+kJGePt6/UZkNsuVMsMkRqWvPa6TqwGNOt1LcY2nQpL/6ZDVhPTxEEKHxqDT6ezpWD/xGeAaJAe7XI36J1ISu7tv1ic76zpWhejeUlszwU2n9SOb0+Mq6vpICqSmT27WKAdbhWavJzV/uB6wlHHv27FcnAwrdxeRrUxAz0+dG4v2rMxY5jfjpcV3QdB3xFC5whM1MfLOhibyIkuM1Edzm9essmKke+bIR9Kpwz/cBWecuJSONQlzJPZS53iCWxiBOM6+HgUyyheJKrx9rRSCW2H28Knoo318mt4e5/seSARSRz66I/FSBrxft6NWQPsauqIf7erFMa8dTAdpcO1UudrNyRk/eGKC2H7K0e/JBdYcyxcMqZhF3xfKMaOBcmLe2NuhDUoAz/FTplDBcHUHWM/hxyiAyeesbHpHEDCz6Dg4f90+q8QntXBe4watYmJ+21AGdJpJ4
 vW4p64OQ
 eIkOoLFotGIzu3oRQ2OLEd3kqZ56Q5DNVFcYwbT3T7OyERxzHlMtm1fZ8kDhJPaXHIP2xUwao+Y1RaTP9PAKiQx0MJWVDGlK/VArvSByl2ANeIqFCPruiFvO4IcZA3RSW4037Mm4I9pBNY1ZSVV083egEQ7AD1FaBGvFBfMCn3tDstpszrdcPnzaVosytmowrPz68PxtZctufNZJse47oMUyK5FRjYaklb9vwZUo9DdaYg8k66kmFIpUi2tp6HJ3DKgl6pvSs15GejrSne6TLRClnE4VWCZzRZHWBsPa1AOCyU799e1jBf595pUH9orQETIfUSUpdoYkGt3vWWoKhVsojqAswCRoS0nmRcSuGhtIzscpoJehqH0Pc4ze+ScqrnG8CinOn/KaSoi+DwSGj/d3atg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 5:57=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Feb 25, 2026 at 11:06:07PM -0800, Suren Baghdasaryan wrote:
> > vma_expand() error handling is a bit confusing with "if (ret) return re=
t;"
> > mixed with "if (!ret && ...) ret =3D ...;". Simplify the code to check
> > for errors and return immediately after an operation that might fail.
> > This also makes later changes to this function more readable.
> >
> > No functional change intended.
> >
> > Suggested-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

>
> > ---
> >  mm/vma.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..bb4d0326fecb 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * Note that, by convention, callers ignore OOM for this case, so
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> > -     if (remove_next)
> > +     if (remove_next) {
> >               ret =3D dup_anon_vma(target, next, &anon_dup);
> > -     if (!ret && vmg->copied_from)
> > +             if (ret)
> > +                     return ret;
> > +     }
>
> > +     if (vmg->copied_from) {
> >               ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
> > -     if (ret)
> > -             return ret;
> > +             if (ret)
> > +                     return ret;
> > +     }
>
> Thanks that is an improvement!
>
> I was going to suggest declaring 'ret' in each block but that kinda adds =
noise
> so this is fine.
>
> Maybe rename 'ret' to 'err' but not a big deal, this function could do wi=
th a
> little more cleanup too I think!

Sure, since I'll be posting a new version I'll do the rename too.
Cheers!

>
> >
> >       if (remove_next) {
> >               vma_start_write(next);
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
>

