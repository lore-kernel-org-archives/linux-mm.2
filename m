Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8289EC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C5B6B0092; Mon, 28 Jul 2025 13:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCF96B0093; Mon, 28 Jul 2025 13:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A356B0095; Mon, 28 Jul 2025 13:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02FAE6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:14:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B86BB160398
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:14:48 +0000 (UTC)
X-FDA: 83714323056.15.3DB5E0E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id C74D140012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:14:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rVRDE4Kh;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753722886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YePw+ur+BCoo8sm0kyxEpDL6zMyyNBj7pMYmP8fOofo=;
	b=O0AqS5E7VWYlYLHKrJszO/QYkdNhzmdifSyc4V6iEjXykcmkukvjGP4A6jk5jtAiok6/R/
	uyNh7KJZAXtw2lEhy8M1wMYow4Gy5/RPbzNK781w2hQ0FFGC6xMVQiQXyYnV88kpEGCjt/
	WATnDdnsMqsKnn0y4YwPYqvUCN7+oog=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rVRDE4Kh;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753722886; a=rsa-sha256;
	cv=none;
	b=mEN8KE5HDsDS7EgePP3RddlFS2PginNMB3y+ErqzNjddI0791UypdYIRhp5oZvx+EMD3eX
	W/+JLcK0f5SKDpxaRft9in5weFrBqMocK0ZJAu4oB/falyFuQRpi8B46wjq3VyzN0LuqiW
	LDl3ZAwcUAjQ4sE2TUm5OzQvxQ3U/FE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab3855fca3so18611cf.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753722886; x=1754327686; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YePw+ur+BCoo8sm0kyxEpDL6zMyyNBj7pMYmP8fOofo=;
        b=rVRDE4KhOOM8N3E7yFGPb+9PaqLa4d3p4bOfJOuJT8sYueW0TIW1/idxZ9bWL+qcb9
         7ubHOkl56QQ+xI2npW1fKmdVbpjn8IEzKnN8FzYTOMhIg9auuWPgw1GAwC4RO68Kf4y9
         VN7ANgOckgAZJG/lUM1E3osLkEp5HkPbMcg4Ytg+AnEajyN6liavLPxnn07c/Bi+TSet
         obESRxFevRL0VBx00kvqrc7iYXo/CWn5L0veeviGZblTDsXGXoo/3E5BVau+3bYtEznX
         SKNtz0eCqnNZQdsr4HwtDzyk+2ePesODF4X4Vx4cL3DgxS6bkChbJ6McSmwwA3LPxJ9h
         ZH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753722886; x=1754327686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YePw+ur+BCoo8sm0kyxEpDL6zMyyNBj7pMYmP8fOofo=;
        b=FaORT0O2unt08m2h/owPJ1EWF3XMNxAJ0Oiil4lvZrqMDHO9XqTUb/2yip5qQ5E5t3
         ouNCUbLk/2FX8jomQ+yxJICksEvaK2zMiNHrVaw4fdfcQW7douHa4uRgSInXF+T6KB9i
         mDJsZxgvu6B/4+LRWmsDVX46vrS6+lZMA3UWEHiJHaqcmfmKc72BUL9BcXz5XN1HIXSr
         3n+IkrYQEicjNUJLTEekRP+DIPDNyVZEnjvvNqZYuc/YNDgQ2Ub6YGNefZwjbz7gMpi7
         38Y4JfGY0w9NSpP49vCIV8ZM2TmrBgLv5ZxNjtO52tdRZj2FOUJ46OZEGD7Q8j99dakI
         rDGw==
X-Forwarded-Encrypted: i=1; AJvYcCVcRWBqeJmkQXm5WT5STEdIfPCGCZEPfhxT6hTPav4U+5Tfg0YSgwiWlBFTzE7ai2LsI2kNAUDE9g==@kvack.org
X-Gm-Message-State: AOJu0YyMFTjEWeeLlhojNI6YC4QFn6n577WrI1gNnnG5r/oOLzx9cnKk
	gIsq13QgTqT2DAQIUJ4+asTGOWf9ZfLv8s3cSWVzEsHeBIqgDgcDzICMnjXGqjCIiCZeXw21rPt
	D+KE0iMhv3O4LD3kGSvtugGjkTh9Yb7iZJ00uomeo
X-Gm-Gg: ASbGnct0BomEAhbIzQgAPg5rVA3s49vUybt3OQQdtK3SX6Btxux2QSVcKDGvwFdll38
	w3PcVQVlfOIVj52MyOJxm6etX+nmN9X5wC+T07UbpGa5rBjmw8G3bVxjQWv3ETXNMHiYdFvoSnO
	+GsUN5B/JgRzefhX8vW5hHJCR1nvwFf0sySODpsaZUUY6Kv3fLtsfKYnelgzgMW4vBjwZfLpyUD
	78TfK1uXnUT2Zc6h9rqvAnCXl70p0JZqAYc5w==
X-Google-Smtp-Source: AGHT+IGCBgO2XeXZhEuM/rhGLIGSYtuHr4E823f6VQotTFSU3q8PaEyrvPPnSnoBBL0wzUawPuf5si6S8YbGzqod29s=
X-Received: by 2002:a05:622a:180b:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ae9cc0a9eemr8919311cf.24.1753722885418; Mon, 28 Jul 2025
 10:14:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
 <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz> <CAG48ez0RrGX-UDhUF+1x5-euJN9z448dsrXMgv4+7-_s=zan_A@mail.gmail.com>
 <CAJuCfpGPjMSMqL1p=dMK3NJ_Cytk037Gm63TU5OuY6QK7Vi+4g@mail.gmail.com>
In-Reply-To: <CAJuCfpGPjMSMqL1p=dMK3NJ_Cytk037Gm63TU5OuY6QK7Vi+4g@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 10:14:33 -0700
X-Gm-Features: Ac12FXz5IIXYMk4-THiDSYlFJH79TK15xvMyn-AQQrpPQLDGdjaOkq22QNqqBU8
Message-ID: <CAJuCfpEMhGe_eZuFm__4CDstM9=OG2kTUTziNL-f=M3BYQor2A@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sbx6d45zah9yfspnyyab483yb4t13iy7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C74D140012
X-Rspam-User: 
X-HE-Tag: 1753722886-308679
X-HE-Meta: U2FsdGVkX1+mwzKBJ0OC+L1ZtIykvbRsEj2jA7Qb71uSkRiBFb2Br+RyaqfSoftF+LDZiuUdInYHQOmcEEgK63rtjVmfEqVPWuFFTBB6wntw0dViDkAByt7Bty5osufKKhbXTQCVUGAsO/nZAaP6k7xo52cT1V4qxt0lniBhEXaXeMJTrPbVfhH3ap1NKHvrQjTiycjdCnJCEo6+agyGm61lc458Pd3f4Ygo9vAR1zakBiHfqenh2N/Q5T/Knn8AogY/40TL3bMoLiLlf5vs7GxtYcsRrvqTXS/VGIAmy1JTqmIPGjdkAheiqO0lhfwCvgKDl2ZOROhfquMVF+V48FQgOEC4U2jHgSe0Q8d5Hm+uAGv3P3+ikANJ3sqfYEEeaJC/MSumA5yIRnC1mbYyR6fRt03F8WTO5Os9pzuTifb/WDQi58TsehKWr6j0XH9eFxUQSNB4SE72HvYLsufRjRK6BoC4XLhnrKPkeCBfl1nm5iT9UQG6F6gKAWVADw1RnhkPwcSQC//ACzbNmeDebej/EK7e+9OLT260fodtzGAbSZLdTurXBIiqwEcKEpReNrfqB70tvQdDZORKx4PbX6fzt2MQsFD8lCs7wLcZxQ4m2Bc683x9knP17wPHXq3t6DViiDTzOUWM8A7eOXKavZ/CAP3A0stsz3UWUfbGrgrcUklb4WxoBReOarDrWIH4uPBOB7x9ylCuSHkPSa/FTyZEVIkGP18gouH5b6H+KmGennTczcb2q5VRWz6ot2j9oAQwiKnjAhm7ITfEscJO8Pq9zvFqe0jWelZ0opzfPw361TabxsaA8UFCz9++aG0Cv2ElSZZcJ0xfZ6rC9pyV5vteXPFizyB6qzw7i5rqPdkM06jKlSwJ1CG9X6KXOsqj4Seoz+Hbc0DBhXF1tV06BBJOJc/pD5AAoQhF9/xwyJE+NvkslbdqNt3TdS2o70fNWYVCT34QDjteyjQJIkr
 ChtFjxbi
 Me1fuxZmixw4hI2CZ5oNRw+O5FGt1cJ0qftFKYaE4t3RX358AZU7mTUJDD/InZKzDBkkcWW+fYb//vXOJCl52OAXdfSIh2KPMI8SxK82Ke7f1dFTOGLlh5yGP8LI9Jb2RkRBA64l2txB7G5+1W0lLknj54qdvwGfCYzD1+c7oKc5ujIgXmGHSl3ooG1xF0nZB6qQF9/Fbjc6IKQWBu45BAr2bmd09KwCxQR+6IlCieB53Yo2aYMV/bvJeyJF9qLjL+qFfoUvIubwDI1p7UcKq4Uf+UYZzaxUawJc/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 9:36=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jul 24, 2025 at 2:45=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> >
> > On Thu, Jul 24, 2025 at 10:38=E2=80=AFAM Vlastimil Babka <vbabka@suse.c=
z> wrote:
> > > On 7/24/25 04:30, Suren Baghdasaryan wrote:
> > > > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> > > > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> > > > after it calls rcuwait_wake_up(). What do you think about this
> > > > approach, folks?
> > >
> > > Yeah except it would be wasteful to do for all vma_refcount_put(). Sh=
ould be
> > > enough to have this version (as Jann suggested) for inval_end_read: p=
art of
> > > lock_vma_under_rcu. I think we need it also for the vma_refcount_put(=
) done
> > > in vma_start_read() when we fail the seqcount check? I think in that =
case
> > > the same thing can be happening too, just with different race windows=
?
> > >
> > > Also as Jann suggested, maybe it's not great (or even safe) to perfor=
m
> > > __mmdrop() under rcu? And maybe some vma_start_read() users are even =
more
> > > restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-on=
ly, and
> > > use that.
> >
> > FWIW, I think I have been mixing things up in my head - mmdrop_async()
> > exists, but this comment in free_signal_struct() explains that it's
> > because __mmdrop() is not softirq-safe because x86's pgd_lock spinlock
> > does not disable IRQs.
> >
> > /*
> > * __mmdrop is not safe to call from softirq context on x86 due to
> > * pgd_dtor so postpone it to the async context
> > */
> >
> > So I guess using mmdrop() here might actually be fine, since we're
> > just in atomic context, not in softirq.
>
> Thanks for looking more into this. Even if it's safe, I would still
> prefer to make mmdrop() outside of RCU read section. The code might
> actually end-up cleaner that way too.

Sorry for the delay, I got some time over the weekend to work on this.
Unfortunately vma_start_read() is used in one more place in
mm-unstable and it uses vma iterators for the lookup, so combining
lookup with vma_start_read() is not as clean as we thought. After
trying couple of ways to fix this I decided to follow KISS principle.
The fix is posted at
https://lore.kernel.org/all/20250728170950.2216966-1-surenb@google.com/.
Reviews and feedback is appreciated.

