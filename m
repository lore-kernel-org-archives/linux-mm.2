Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED0BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8366B0096; Wed,  8 Jul 2026 10:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A97C6B0098; Wed,  8 Jul 2026 10:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770126B0099; Wed,  8 Jul 2026 10:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 322996B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:06:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAF951A0140
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:06:24 +0000 (UTC)
X-FDA: 84965784288.10.3B8E549
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8965940002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:06:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=IjNCeyOq;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=BxU5mGFl;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	spf=pass (imf04.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXZNu0Za/OOMa318wr8xs0J+7OvkEgNoNQGLM6QdaVo=;
	b=U3DTl2td50+tbaUqNnuYjvlsl1vrcaW/iz9wI6MKTIBG3h4j1gN3LGlDc8fci6KZ1A+HhC
	N4wot0F6p3p8k/qCnXtNNciI+xHh+yQkeArr27jjAHol9RDfiAEPZJo8PDToYC7737CTKb
	RnV0a+uBPHhXUt8NYGi1FZoF3txkKh0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=IjNCeyOq;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=BxU5mGFl;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	spf=pass (imf04.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783519582;
	b=sp8RnA6fO8edzcDzsb5KJcKNDv5RtyYizUf/eABS7L6EpVbGAuqqXMHkXDc4V1TfFrEdBH
	ZVcBieS4BbOS/nEfHznKLtFv7A6d1IE1M0P3qcxFTs2+mHb1vs0yV7//bmQtgMj1C7WDop
	fne4RKCMoEYe3ZE+03P4+zPMyhyIt5Q=
Received: from mail-lf1-f70.google.com ([209.85.167.70])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1whSur-00000009bPe-14Xc
 	for linux-mm@kvack.org;
 	Wed, 08 Jul 2026 10:06:21 -0400
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aeb351bb5fso793717e87.2
         for <linux-mm@kvack.org>; Wed, 08 Jul 2026 07:06:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783519580; cv=none;
         d=google.com; s=arc-20260327;
         b=BKth1nisqRIG2RT+xIxtshTK9zviERj+MDH3kPkoXrCJ4h5D5ejoNAappmm1NQlOef
          rI7EGZTThoLJUCoi/Wtoh7vRmYcWD7+3hR3BO0rjLaLyIkJ+Ri481tYpSYmGnuKaKReS
          1rlge2jUfSp9IBfwBG+0FLPREl3GSEnhsh4aV1R23kZ+oQK/5p5/SZqWM7Bd/bMLD0yW
          m08tLrGWxrUv+BjS5Ab2vQQW/h6OSKhEN9DtIKV+yRuUR9bmW865yWAmL22Di2GEG5J7
          LwJLnkOh2VFC/+ORQp3zmM6zxVzKHNYF0zNJOqNGQCgikc+JCnINNn0oIUq8wttIY7/S
          GOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=PXZNu0Za/OOMa318wr8xs0J+7OvkEgNoNQGLM6QdaVo=;
         fh=5xwA9BIrIqtaPi4UMtpLBaleW5zSHKLfjs1YUvtqNI4=;
         b=TbWvCfV/K/XLZjN7CzJfKgmIAscJsANOEbjv5Dpi8hEL1rRLBmizeyMRp9/uIIC6+D
          CrGNOG3pGPMjE4w1YXFWk6dsd/INv7FRoWIY2sztHGjBUJ5HMHZ7+w9NbxsRDGKFMqzH
          GLcnCwFID+GCoyHFm+EIBEHvV6yu7SKzsBgGeoi5jRuPiDG8y6i6UocQ+qfGDLsPC1GP
          mOn88JQUt9RQwb/oLZAiaT+6iyu8lG9H128lbBac/TZ2v9E5jqflu5ixD9huirZA7ZAU
          fcjxseDl0RFjnpzCFmxWVCJnFksPwMtVh3VWrrrGo027NHk3A47pmqFHFNION/qEf/d0
          TNAw==;
         darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1783519580; x=1784124380; darn=kvack.org;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=PXZNu0Za/OOMa318wr8xs0J+7OvkEgNoNQGLM6QdaVo=;
         b=IjNCeyOqLUt6eVcAmXV/BJ6eZfJfo0awqiUE4OUvxScEZmMo+UyzOOywOJNzqmksAw
          bFYxu4LydtmLQ7mGy0vdTKJu3Pxeoz5e8t6Dh0P9wJp6LAk7D4zzsaA9pQQ+GitRDnAM
          UdnmPVLaC4VSDKcA7wG1IDll/PfE+FBAxnX04=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1783519581;
  bh=PXZNu0Za/OOMa318wr8xs0J+7OvkEgNoNQGLM6QdaVo=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=BxU5mGFldq8IMv0+h97hQakVi/A/HenZaAQTjBdtx+ps16u6Pbl1IbqWKbbJuxN+f
  WtEeyY9Eqso27S1VYnvvJzMlj2qCBPQIFDcAPIdx/ciwQj/fVry25zm2gzcgfNJT1Y
  VszeD6phYhM/Y1DueE3gyVEhWYnklNkTWzRmOtFkABWX7mwl6CEr7m61EHwIu8Tfcd
  812xYcq0M+MmvFs0eRcEyL+qMNoolJ1Xaj4MfXDxZxzdcH0MwxSa4drpV2eHoqH501
  LEhG65+/T/WgvOOG1ksbsgP9e6KLgAoQcwcNSOgX/l//tXpcey4r/tlUlSkxgZf74T
  qTUzqx/dFo6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1783519580; x=1784124380;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=PXZNu0Za/OOMa318wr8xs0J+7OvkEgNoNQGLM6QdaVo=;
         b=cBm1S13gduQac5FuR0GQ+aj8OnQ+YsFamE761wsTH9qkndVyVvTB1YjaAPxeXw10KO
          lDMJbIyD4ujexNRv0I0Occ35EaLXIBlF1mQlbMFaGwPjIBxk+VA5yv8Gq/J+LqbMMr5/
          cP7cRQ1pV3SlluwDhJkIzew01sQKcnvlXkZC2lNdFPctxsj6JjllM1fXZ9Oth68lC/b0
          EAUFrdvI4kSrq2ce+HmvNWwBpbq+Pmoqm4qeARVjIq5AS8D7gygOrnoU+ItqhIv6hoto
          tXtynBHYjnDEfY1MHs9xovDRHhnKNO9NsJnps4xpj2LT8khbcfWVI6pGQatmguKoPHqc
          yY4A==
X-Forwarded-Encrypted: i=1; AHgh+Rq8BHWBFP5UhPy+0U/iHskZ/A1kQLlIvkySmvvS9dUaI/uSJ6dR96FvX6MRdtgPc1jhYFnlk6Ag0Q==@kvack.org
X-Gm-Message-State: AOJu0YzaoeedQRDNsqxv/fV7arZcRBa8W1Gs1Sz5ZxwXYciN79kGp6dx
 	IjlEij/3bzg2A9pGDsAFCNGmEpdHVV8jiafR+lbVEmlzscZfyycScjXzgXM6+H7ZnH5PTTxzL66
 	L7Fx/lBELBMAnvmz75z7QRdMECOqk6/52RkPiN9MlqYuYSf5KvnReiEPPFJCMmMiU9oeaxhpKum
 	ghJSKsagsSFQ0855H/wZutmUmkAA==
X-Gm-Gg: AfdE7clo/zhJ6HtAvw6MqH0IREoQMqmfgJm0rltUK6x/1+Djrhe1x2+BfHzZuK4/o+y
 	jMOh1YufWFBrqmw+h6vZVcxmlGxL/n6Q2LxgsKlNzuGioPQuuGPI511Iug8tUkDhEyWQegR4TS9
 	pTcRAFeZnoyUhMDZygX/80zuEmUHmxuzevPFwSc0WQfXXc5fiqT6RxLORQa/gKhuecZ50=
X-Received: by 2002:a05:6512:340b:b0:5b0:11cc:2284 with SMTP id 2adb3069b0e04-5b011cc2571mr701648e87.21.1783519580632;
         Wed, 08 Jul 2026 07:06:20 -0700 (PDT)
X-Received: by 2002:a05:6512:340b:b0:5b0:11cc:2284 with SMTP id
  2adb3069b0e04-5b011cc2571mr701620e87.21.1783519580206; Wed, 08 Jul 2026
  07:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260702165409.164568-1-pfalcato@suse.de> <akhYu66GmjyM8l6a@casper.infradead.org>
In-Reply-To: <akhYu66GmjyM8l6a@casper.infradead.org>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Wed, 8 Jul 2026 10:05:43 -0400
X-Gm-Features: AVVi8CeMh2pp3lqKg47ZNV-_AiaErtleKM17gc2gMeTGtO_5NCmQTr7BfEwc8Wc
Message-ID: <CAFN_u7HkJry=iFLbZ2vjzv5C=HnrptHfFJBLOqRq2m4LyhqV_w@mail.gmail.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when collapsing
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
 	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
 	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
 	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>, 
 	Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8965940002
X-Stat-Signature: wzc959tyd3de5fch4pwp59xud5a3wtdb
X-HE-Tag: 1783519582-456625
X-HE-Meta: U2FsdGVkX1+ayzxNVThBTVKtKBlDute+02das7J+0j3sNfYpFpXgKPaNYjr4fuO1FlrWZX1tNrBaha4mQhCc/rWKCchneCUjJ0YKPenfXs+f37/mCPbFMT5+6iTNcd2At7PaVaxOkd1giQXu89pF3IM+ssTK3cB+xzv6+E9GCA3K2/KbGLOQfpf9mTKK6ugBqv6Htnobe549aSwWHZX5Oqa2DDwB6wq6ne42sXbuVHrtMaehh+IMEFUKiSEcoG70MINYOqX02rM5CO9G3sLjWgjqwI+OGrToLLf9uc5Y7UPzgGBvs56FhOTYzwMK/1rbP086nAtSP64ICCHmZijwafSEy0rQ7KbmLMAfNQc71FGSW6JOiHoUsy1cxXXpKJ/Mj5iHmZis8Z69Omzd01I6HPwbSggzDOpIo+D6OQoz/h5mRnyRasOXQhGamtaOBxZukOLmJMl6L9ZiU37aeCN9hAmRECCX5jy7/yyy+SQD5+fmTNezup70ZCVAMYCzulDKmbZ8JnfVnx0ix39N7alEhCrnh7X5ti4fsyLVRUgvma48m+ZCNXzUYDg0lp1hOYzMb3mvj2eVkaXwAYLoKwNufxRghV+MoS6wXEy2yzjYL1iJcY0Ym/JTL1FeHIbH8Wf7V1pJBubWmZCGkAXBJyRe/aXQbRwQrvMt0LMmZT4bLdP2YP9gtUvJ8TNl/Xv+WbSHOGLxwrV4g8+aEe049roOfnd+mlCYU5+e2i66D1Ufc1OrSHeMavIC0BZb85wzzreumU2x/ZEliHc8Illrly7s5FiTLt4k4ow/fvB7ie4VIeCQZFNQwX3gHsIG8PMGnnM/XEAF+LIxJGvL1UN7UTKTGTILaWIx3p6z3HT6O4ULOkYMxgb+RoXS5UzVVRhjtdkuL5XwnEWO/nV5A25BAKhx4axhr5Memox6LVnyqp5hjRe4UrPUkJTigdwaXMe3jX5z1JoLlEXcb7XOBzv5APw
 qJF9nrVu
 ThOiHUL1xZMmbojix/cqkwbpSFuhdNl3h8CHTnnfBmnb3kHPHh17PXS+UF/WjyZNLDytxZ1WyuWUFReG1KZ10zFWwcBBNTMOrbTmHacHfzGAXV1S1kgXl5nr8K52DNWWsPyRK67Xym3srmB8cqHLXMHLFvJIb2L+bbxmUO2vaqckBME0q+3b7Cf+bynI79M44z4TZT9ZbTQTvy3LNDGIY9WKdSMPEHr2mAWpRV3cj3zJjaDoPLyJpeN47AtkRpNqSk1hNpKsH6bjwV7IKj20LSAkS8g2xj7oac2FAob1AuBWkOo8/s+GB/fG+u5m155gSVgdY+x3IQWIx8U0k5jpT+fT5F8n8Vc6FFK2uTO1XMti3LyI6kLPYX7uhI81+DxIyWfBulqGxyds8dORR5rcNXo3gQD/hdND35si3P4JKDKhPbs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi there, just checking on the next steps here.

@Pedro Falcato Are you currently working on this patch (mentioned
above, re: holding invalidate lock), or are we perhaps stalled on
something?

Thanks!

On Fri, Jul 3, 2026 at 8:50=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Thu, Jul 02, 2026 at 05:54:09PM +0100, Pedro Falcato wrote:
> > +++ b/mm/khugepaged.c
> > @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm=
_struct *mm, unsigned long addr,
> >               goto xa_unlocked;
> >       }
> >
> > -     if (!is_shmem) {
> > +xa_locked:
> > +     xas_unlock_irq(&xas);
> > +xa_unlocked:
>
> Hmm.  Before this patch, we increment nr_thps while holding the i_pages
> lock.  Now we aren't holding it, but we are holding the invalidate lock.
> Can you put something in the commit message that notes this change and
> argues that it's totally fine actually?
>
> You were good enough to not point out that my suggestion of calling
> write_and_wait in the existing !is_shmem condition would result in
> sleeping with a spinlock held.  Silly me ;-)
>

