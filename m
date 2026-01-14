Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66030D38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D11B6B009E; Wed, 14 Jan 2026 11:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9929A6B009F; Wed, 14 Jan 2026 11:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1A76B00A0; Wed, 14 Jan 2026 11:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF996B009E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:47:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25E73160589
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:47:34 +0000 (UTC)
X-FDA: 84331150428.09.C515D49
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 396A340016
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:47:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cHunZRKy;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mR0xZVzYTsPG93rYPsbKDoH7TrzLvbtVf7Vpqg5oGxY=;
	b=506/RtfWOHj7iVG8gaJx7YP4EyHEJqUe4Vs9PBCFJXRl0wf9OAEOImfQyBYj4DEPIRVXEX
	2Y57m35l6C4/8Xuqxp8QIEGWwfALKfY5pFDtkvYo5TQVaLnKhCmy0mPXIjta/uFgInX0XS
	3BQMXBCi0o/dKuxiiR2KRcM+Igag87w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cHunZRKy;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768409252; a=rsa-sha256;
	cv=pass;
	b=l0Yonp2hWsPaha0eVUNMhq+lAo/2tgSy0oXXfrll0+TN+24bAujhjSB+Ai68JZKYz+cstl
	S/YNuFbBHJGyVDeOHb0VhOwvE23CIEwdAZIb7v/SoyIt1AXRzla0I2sWYw0UJiAKpWFIoD
	cW/Tiz+FRxjthmwRLp/49BV4Lf0UH3k=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014b5d8551so356091cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:47:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768409251; cv=none;
        d=google.com; s=arc-20240605;
        b=jZwaP2+01GhDf2MfwGyaNOm/QvDzgMmhOY6ak8m85NYgXb42/1dOoOnrhKnfAZlF4t
         scdUKBuawGM3r/gmdlwuvSoCSewCALMxpNGVRd5UdcNoes7j7vrUL+acv4QCS8HP4KHv
         Ehh5GOLCMfvP3ktKN7p3TuWMBry6+A0ZehiiooVhbFtkqwHPRGy12uuK7z8mBIN5NCfZ
         dX5Y+1I1VEgNxPRucZujhQF+H5xwoHfhiAEVoE8Ry6nYVz7Tpbdxw9kl6Mrxz4vMKtiN
         Rx/00gNyzO2SiawQc8qg9sub1T3xnc0O+2MxgXlFWVJwEZ0z8i6cvVYh0XslaPEnvCic
         pYoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mR0xZVzYTsPG93rYPsbKDoH7TrzLvbtVf7Vpqg5oGxY=;
        fh=9LH+2Fuhf9EsTtteAr+k6GddD7kRKW+/q3OzenKHDEU=;
        b=SKhUk7Pj9p3wE1mvr3qR4G2ZoGPcPMIvu0wOA6mlkbcrecawY0kEjSzjeqa2rjLd51
         1oYn7k3Pl07pg0I+y4H+Iva+AkcBVlgOgcZmeAxImu8ndnQXqG+Dfh1Yp865KuyqmUOB
         B96VNyfsvsicLYBxaeXKqdsMM8U/iQUgaoeU9adFKskJ8TeP/af89amFmxDRN/vmnofA
         JKZomFwYiYX/Cmnljs3Qnaunx5baBTS97lvhXfS1vpiptpRjIS8dUVf/p4prIh60w3WK
         Wy8ho4FiIZMVUWfhR0iCktZvicYaupRD2k17L3ep0GezA4zRhXT4mJZXE+OEhIpjvAXZ
         A2Fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409251; x=1769014051; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mR0xZVzYTsPG93rYPsbKDoH7TrzLvbtVf7Vpqg5oGxY=;
        b=cHunZRKywZEQFDj1U3gqyjKGoHTVoq0Pk2o3dtkonS7/wwaigPaR2k8plCPbYGDm0Z
         Bd+0F/bkQaa4fT6Y8ifsov78302E1zx8YeRULCphHuEZDFmkBMvQLFTMtz835u4lO0/L
         9G/Ko1B5Dv7oJlgjgjckSAalAPNBpgcMR8jMUn1e7sdC31kQEVDyvZKoFOyspqRCd+0d
         1IBAMuN/kridXLVDidGbdi0u8b4F35t3ZoPG8lndllEHnC5p5NlHaxUf16jcDb1k7Yui
         nLiJHzTiYSwLBNXj3hkDsoo40utZYaSox0fbCdC2AGA2yCcgoZ5n7DC/onJehC63RIIe
         VpPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409251; x=1769014051;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mR0xZVzYTsPG93rYPsbKDoH7TrzLvbtVf7Vpqg5oGxY=;
        b=Pydz/hHIDXem6YqxdjVKQNrji/gzEZKHVGPesxeyv07sMAQyCnszWcDs2vSh6hnUx1
         nr5jCK3F+TmrqYehdX7H4X79ZVqlU7KIAVZbqX7GYJG0HzqKeGUAZoT8Uxb8sF1/veaa
         ele6mLpEDwyQDdewSq9bPOiKlRw+vnDHmXtrQ2TNkQtDfoUET9tPMosJbPse8iWinxqM
         nysHEXiviHlM6Pwk8XBavjexHZRkYL87+KcgDJQdfaYfw9DQTilsZPT21AGzvgvm5RDF
         c1ZaUBw2ci5TtzUpx6Y+3HuH9RM9wLiPr8IvdorXKGA/E7ortYUw8y+R6nDZKUxJtlGP
         0H9g==
X-Forwarded-Encrypted: i=1; AJvYcCVRHqgXhUt1ga1zGtKnFZysNVZGMAethod/H7E7mwurgK1sS4UD1qej4RnNtzTAo4TWrFnDMKgB8w==@kvack.org
X-Gm-Message-State: AOJu0YwPX/XFWecyAMUbYhkeaiaQILqguP37YF6umEC6MZGyv9QwBYlC
	EPkY2o0I7Rp+Xm4qvKWT/EyrOE1hNThjPlbbnZfF/M9/BcMjRAS1a4840hTFCtSd/OjWHW8muR5
	W61U2ugcmzfu5KIsLhz1PtoL6jf05ZlMnCxwmN6tB
X-Gm-Gg: AY/fxX62/LuNlikE95VryuJk3+U5559KZPBC9K1Xwyw2u7Qa0FncNk5ar7O3WhNDrqO
	DJV7UOmt/4zfIYwHMlGkKjqSOj7AHhzemxZmACiZSOJ2OJrSUUt4pOd2X2bBwwDDttgNUun3cs4
	HSmAJA84RYSmnWf9eg9az+jReEok1MY1wUjKqNDTh6PSpm3hn5uxlxLFhnvtQpR4sEvWVtvvBBY
	LLng80tG9lv98ARR1/7HbaitISHMQd38JQPw8JvB4KSic0tuqqP2cPCjWnN71ovaO5XrHhCjdmF
	E148COxHGf4A+N//38PfvluPxZnUve00AJ5e
X-Received: by 2002:ac8:7d44:0:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-5014819f273mr12918591cf.6.1768409250623; Wed, 14 Jan 2026
 08:47:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <f0855a0b4e68d877baa222a636a8a14c4e820bf0.1767711638.git.lorenzo.stoakes@oracle.com>
 <lig6eozf2jtpyzccgl2rbsq2sinafipogezxhbyyqorelgxbae@ruu2blv4wvi5>
In-Reply-To: <lig6eozf2jtpyzccgl2rbsq2sinafipogezxhbyyqorelgxbae@ruu2blv4wvi5>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 08:47:19 -0800
X-Gm-Features: AZwV_QjKhy51qD2jcgk-YG7XCRtRsDHXq83OoEPDAw8Tpqe7RO6nNd_Kli1zEr8
Message-ID: <CAJuCfpGT9OEmYw5VhaWtWJY9ZCv6_UNYZwohT9iFXPx5mV5oSQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 396A340016
X-Stat-Signature: tu566t54abk1ppyueipszm136z1oahej
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768409251-457725
X-HE-Meta: U2FsdGVkX19BUlM+tgeLRZzJEVefn+F7XL1OPGLYNq975d54y/6UDY387/mDmAIkMny/TpfDPtjorFs2oMfte80MDK1b1+peQedeASLQSFthCuH20li/PDbIGYYdxa2VHp56eClwVN7OgfHgs+rtTPy0vonrYNSOm9l7ww1mz+pwdPExjJMLknAM2kOKMaxozrwznqIhCWh2ydHWXRzUsWZnNVMTa6BLmoLf4YoflWGBswTbg2dN2qB590N/4qwN9kx14SnFUdW3gkL43fDum+sdInDsZL30+bFTiEDfiFBMtrfze0QBgIKOcfbeIu/A5pKfEqDuJoyEooHHqtmJVhll5zFGjLPHZcJuJ0BS8S2LVaJPobTawqrCnY/AK4Tb0On5Kq6ZTjijnPywSyn6OnmNz49tQBw6F0Ef2EOq8Cx5zqmMJXpaM7NGfgpqOcJ/JOjFvKg1+jpebaRQD+sZ5UgX53HtzM3hRUkXggyyT44BIlfrO43VbJbgS3qoxizI9EyA9NVgyPbBRNnDb0x92ZA4kUOPbT68N3ulUb8bhvRelNbJZy4IPX1sR5WFS1ON1orqBgC2x+Z1IHgU1RS+7NNhsVjqkWBuPbKLUZYl/y+7IDfCQx3rBExjqFSgRG9cg+yO02SS2IVacpjAap1WT7PPvIT0WHM/LWwvYHsCGoduiqprn13iRXYOAzb4RJ1Dlawlap8xg6W754bFCHu7Us+nXk4+eANhGMj0pPeWDO6JVC1UHy4xYew7rFNwLYj2rSHgba2ICapASPhPA1xPDJ3+mbUzxxNr4Tq5zQ80hruGxVWcUG75mkkaLyXPWh5jHO1jVS1ckp3FxfstymfMRUt+vB8X1i8K29ky/SbV+uGos7Oh+OfPyj3QLCxeANsKcNv1f6wPyUULMheu97Ra3RFhSUGgX3pVlQ2o43QaN4hJINURkTMQ+1RrFzHhbJAHvNHMT95idPzI22nuslH
 5Ky9FMnx
 qHf9QchUkLYgk20pP57u98k4yz0kIC7yHykdOz0eJmvtL3aC4Yndzkuf0MuqwrCBufylWt/CwjvX/DLGG9bMPvmhNWV9+mnI4O4n/1pQgfksVWJwPDISPEJ40wCfXasy9vnrTXe3LDN+pst1NgrBdNkijxoDivKU7NWgchzybDU8tMeB3nMRCDIL6VJkTJHyFKChQO/nEOT0RL3/40UT/P2x0wwwyadHoQ8kfYdx+ePEYEnOS9ZTTsTIZdxv5601j3D0A004mIWdp/y3vV37djvmURw7KLIi4Pkui7u6pseh7T7opAMva/WenAMoPyyxs2eGXVUIfvPNuQLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 10:34=E2=80=AFAM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> > For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or =
the
> > VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the function=
s do
> > nothing. Simply exit early in these cases.
> >
> > In the unlink_anon_vmas() case we can also remove a conditional that ch=
ecks
> > whether vma->anon_vma is set.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> >  mm/rmap.c | 22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 54ccf884d90a..de2cbe860566 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -314,6 +314,9 @@ int anon_vma_clone(struct vm_area_struct *dst, stru=
ct vm_area_struct *src)
> >
> >       check_anon_vma_clone(dst, src);
> >
> > +     if (!src->anon_vma)
> > +             return 0;
> > +
> >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
> >               struct anon_vma *anon_vma;
> >
> > @@ -474,7 +477,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >       mmap_assert_locked(vma->vm_mm);
> >
> >       /* Unfaulted is a no-op. */
> > -     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chai=
n));
> > +     if (!vma->anon_vma) {
> > +             VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
> > +             return;
> > +     }
> >
> >       /*
> >        * Unlink each anon_vma chained to the VMA.  This list is ordered
> > @@ -498,15 +504,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >               list_del(&avc->same_vma);
> >               anon_vma_chain_free(avc);
> >       }
> > -     if (vma->anon_vma) {
> > -             vma->anon_vma->num_active_vmas--;
> >
> > -             /*
> > -              * vma would still be needed after unlink, and anon_vma w=
ill be prepared
> > -              * when handle fault.
> > -              */
> > -             vma->anon_vma =3D NULL;
> > -     }
> > +     vma->anon_vma->num_active_vmas--;
> > +     /*
> > +      * vma would still be needed after unlink, and anon_vma will be p=
repared
> > +      * when handle fault.
> > +      */
> > +     vma->anon_vma =3D NULL;
> >       unlock_anon_vma_root(root);
> >
> >       /*
> > --
> > 2.52.0
> >

