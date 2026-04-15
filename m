Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0277CF433C8
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 21:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1426B0005; Wed, 15 Apr 2026 17:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1E96B0089; Wed, 15 Apr 2026 17:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B907F6B008A; Wed, 15 Apr 2026 17:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A91516B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:27:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A208E1A9D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:27:41 +0000 (UTC)
X-FDA: 84662077122.04.6FC4695
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 673ADC0007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:27:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pVapXXVf;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776288459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVzjcAt8w/sQ7zfG9QtJrIvP07qNZxMFyNOmVK2J7Es=;
	b=A5hTjbvSjT6E8u42MBf6JSngwH3vmNrZggsbjb8MDyz7TIEoykaV4xdVBm1/FR77FAw/2g
	d/O2IcYs7bbX83R3kypj9bK3QGNmDqKtz9XqS2VSi+NrYUkOBtNMF/Am5ET94/bu2Saekw
	c9MnxvObzZESblzGWZzPw3ZkvT0hoFg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pVapXXVf;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776288459; a=rsa-sha256;
	cv=pass;
	b=ZXO++aFote+DR46yegKEdW3bf6FPvh4P9Fe1mTEF0E/cfunC9RXhjuP2DTmC16ZfW7ZvKT
	YD776SOlGhPYMeNcWYE1QzzvtKIuanmM/87d7E7neTdM8t/a6odAqvr8tK0FCz9k4ThRc0
	g5f39b2JGEDjyqtnDtrUrLVXR5D/KUI=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d864c23bdso23241cf.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:27:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776288458; cv=none;
        d=google.com; s=arc-20240605;
        b=VOa8lP8SwduWsNUANDmWluSdnrpnc1zHH85CpVS6Tufd7Q1af1Zr/MsAXvx1ddt4kb
         2NwueyAliP96e1UdrPLn9+UIF/PnOGMCwMktRT/6YwLfQyg9k5YnFxucuMfugFkSCc92
         XYjA0i/3ilY7+IF/eFWX8fU/E+x7sqXUxTiDdIKErCaQRo0BTeWH6BZ74QsEk3ZCVR5M
         6nsEie2mjLIDVU8yIq9obvkH0E9cihUxyCrSMR4hKAi2USl9AA/94KF3lJvPJ/41o0+1
         KLw6VolTkGFrLkue5m/tItawZsUt6V5h3uVh/zryos3XQB07HCvMb5/SqUeiT8SimTF6
         g+rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iVzjcAt8w/sQ7zfG9QtJrIvP07qNZxMFyNOmVK2J7Es=;
        fh=u96hMU55uD5FNxrIh/Yubu/XQGIsSC9g3558igKBKyY=;
        b=UeZzhpmhtIxrpT9MSfDX+B/zuWFnZ7f44h2YAquYYfN6Nzpvju9/N5y2c9UQtTIz2w
         KolOFeflnd75jWw40xb8BT/1W+omoEYOhGvChuo5zh09UIfu7Vl2scL8mhW/tjgMn+7g
         tUHe2cVjpNvQQG1wMEkIqoFbkJruB6vDHOg9O8Ij3k96m0w5JitX/qLQpvei4vyTiLCG
         27IG093gol4heqO9CV9dzuRHWyk4NurQNeSNZVDR8DTZBWrdFLlY/+3uO7CiNOVim6ua
         EG6CBh1aXoD6gz/9BnOr5v8jhi+lyyNLcHmajTtyQ7pPd9nQd59MGOQ/QAfiCnTHvbbd
         g+Kg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776288458; x=1776893258; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVzjcAt8w/sQ7zfG9QtJrIvP07qNZxMFyNOmVK2J7Es=;
        b=pVapXXVffULpT855J9Vb7eTSjROkRc7wrPWZjXgmuXIektRmybHT9hI/KSVhRJEH/S
         pfPRDL4yJGn0Izu58OyxTW3iPCbheuHszoVVRUXLEakxaqsEDx83lnEglWzAiUe9d8v8
         0UNyeqrZSHLECl09773/0YrkJdhUZRs/P5gbmwduiOFpqUAPUWMjGb0uZPmJm87WcVGY
         HmBRUg4/uzYUMcxbNwfSsui0FwPU6QXFWT/KatHkbTicr4q7giDm4oLLkVCj14cOeeLx
         Js1UbPqy3HTQ/UMpTU0q7yfe+Gt5Zu9RlGDnh6diozAC+xDf9iV8a7JGgag6XXolP3B3
         IAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776288458; x=1776893258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iVzjcAt8w/sQ7zfG9QtJrIvP07qNZxMFyNOmVK2J7Es=;
        b=s5Q76ECWrA+G2Y8jApwbIQVwZ6bGY6kGX4IB1ZqZaZqpuqHCPywaH/lOGJOXUVLuYV
         PXC+ZzBHjLX2ykLIZI0t+p9X09td6csYiCt+AoBU0aGr719jAmC4u9WACX/YcHKHUWf8
         HKL0rj7jaKUh3COlUunbKnVuuCAnAFUCtCRkC0HPja6LVP6jdCiP4Lr09zs8H/KUAlI+
         U6TTsiSSpZYA0YLxpgXjs1Onc+nAgMUG2W8KtEYcAe5xH+dOmadyGW8k52FjR8UP6QVS
         lLDZGjPUKpHcbSK9JLHdHgnXWyBcOqt4WFvk3hhNZCnIlJlyTs9dJqZ7AoA7EQHQLlxZ
         rOAg==
X-Forwarded-Encrypted: i=1; AFNElJ/4RKz8nkEOulYCgGt0MSk85U68bcIJym2QryRVmq4aNM98QuesO+re/x7E5GduDNp8Xv1bcoiViQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6ISsGgEI7a64UaKnCYPnRlAlVsXGS5rl3mUXH4w/HvDmCWctR
	4QuMRDhS2pB9HYQO02/PanjsdbEvmv+jrCHghNnFtXhNYNywQRtVYzuytpneiwwmhY/Zn5ljaFq
	1V4GpYUlNegw50PSlF/rolD8JAln62vQB8AMu06s8
X-Gm-Gg: AeBDietWxQ2hDTfZT/8t8GTCakpYhU0LZkSylG2Ef4dL5NGFus36IxJ7JkSa0toQf0p
	SwANzndbKzHYXa1zHDJ2qlfAjP25V6VoIJn9gUy3Tg6A/xp7WiyDmyQA3a5gwYMbuItgfjJElhg
	cbjkgUilXczyi0a1DbB0CL7AkguePL8d4xbmotDf+cSpMq1iR//nOcABw84SkEjIY+EFLpYK/UB
	HKDYwfPTrgFZnhiU40Fs3AJqmSqcDEs9Ew7kNUh0zW/vdMEPblWMW1GjSjp1WZVfC8dW0T92cw2
	PjuFdyrAQqo1PpJbtMFGsWYYADsdbNesb6E7NpU4JCIzXomAZujMTdfoJTs=
X-Received: by 2002:a05:622a:6:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-50e25722afdmr4667971cf.14.1776288457927; Wed, 15 Apr 2026
 14:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260203073757.135088-1-ahacigu.linux@gmail.com>
 <20260204033553.50039-1-ahacigu.linux@gmail.com> <4FEDFC64-4EE4-4FC5-98DB-FAF9182FDFAB@linux.dev>
In-Reply-To: <4FEDFC64-4EE4-4FC5-98DB-FAF9182FDFAB@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Apr 2026 14:27:26 -0700
X-Gm-Features: AQROBzBHiI6Wha6dqkev2JCNeXyqJ9ZSQFtB1X5kp9jpxOMPeM0cAX7DjOFdLqg
Message-ID: <CAJuCfpHRgc-xBm=wYyh+AgD7FhJ93y94dw9JDzgBS1v_=bqCZw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
To: Muchun Song <muchun.song@linux.dev>
Cc: Altan Hacigumus <ahacigu.linux@gmail.com>, akpm@linux-foundation.org, david@fromorbit.com, 
	zhengqi.arch@bytedance.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 673ADC0007
X-Stat-Signature: hhxyix7cw4r99kdeeejr5i1zb4sne9e6
X-Rspam-User: 
X-HE-Tag: 1776288459-173679
X-HE-Meta: U2FsdGVkX19zFgmCxefcQshofCuOUY7FPrRQJ6dZKTns5759JjYIE7gaa75Hi0IANPdXjKznfPRhOGcdlCMgsJ6jW3BQuzwbYTH0OX1r2uXpycjZTS9q4ttJWYOn0v4FN/KTmFK9Mksts2bPajm9BT3ITyE/p2FEALMYJevOANGOKdNXVcQOVuliOErUGpbrIiVxZ4uJbqMExV+I+xq+kF+95VPVOyZPqiYnIOPWYlt8WLD114k2vu7iRrrXboMioa+OlKNXPVRVf66W1cYBl80k2ED5Yjq2eZEHer+V7nj08lXnEPf2KkZYGI8S9rVTA5wgYwAhGiyoPIEZ0/ZqZ7LVI/eeLmiyEyk5eml1f6LyCsDlgcWSS0hwQajYxBjitZ+okhk6wrZ/gP0eyy59AdqHqRudAlQdb6HUxIV2pFAfAzyV82JqciOd3ducRPwazIXeTjb3ra7lJ7/YQlDArdHRHYs1Os2oc5ZStRoKZQdidpenGblkj61VS7GEHaKisJ0+FEL0MWTFug1KquAODKJeesyqRgKeaLgNJELuzpFDQLlF501ZkwF3SB+chNqRBgx4f6FkTIfcd8M5Sks9vQfTGyaVVvklCIW+vD37YmSuMykJ+B1oEnYlGs141NYag3BfcenrQYNkup64XrXiopf/8CIAuPIKccupUvYe17ExCVfhPMPvu/LTft4PBjaS/PZnBK2LJSftVC5Wiuas99XyVGLcXRepL9765H3iecHkGjbbHqdxit2xLp8VqkhlzP0Zlwpu8SP5rtt0+gR57PDN5QjSUMxM+69+6YS3WqCZFhLJAnAQ6DNSoMNZz1Noih+vSsZgwhpIl5OrfaOpdXOZCMx01WU1/2nYp5sO4Cv9Y7EEYnFBKV/UmAA4QUelDXADEK9/9GvcBX7whJqGEWQxyT3/mkJ8vwMEkidSjSbx4kcQedE5SOyL2S/2Lq7DV2iZt0Tfl5W8eX6ojwT
 OSE20wBx
 EcjLwpKq83XNcd5RAlK2VT9RuGhq6/zJIlHbK3BE/GCWqRoXFZ6CTrI1mpcVRyWfMLI+cBzTRYTeEQ8sEaa7mNn10bgAGpJQ+573/DCELZsQh+WkK695uDsu3QXfXbsuYnYaqw1I6H91/cyBzHa2qvddxk1fQ+Ya/n6c2jJ2WBqWGj2qfjqaHQBuvypgdSDITHaMSavVAlIwHZM+mWQGXmmga3WrjcUYIF5wLj5U0Y+8ev6YljUOznYjClXzJ4ForR3Z65z3TnikU+Ol1QVnXffst9Hy7Ku1Bz6U/O9uqkV029TOCvNEqsD6Cy/X5Bwuj6fXfnp8ixBpqX5kyoRPqFV4ptR4MAwEakFx+kBX//pRFDxlJBduwLSePEvxytxIUIBMPYEE1GMBDZ5JdS4QVGZNYmAupoXaH8PbpG7gjqhQDrd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 8:00=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
>
>
>
> > On Feb 4, 2026, at 11:35, Altan Hacigumus <ahacigu.linux@gmail.com> wro=
te:
> >
> > When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> > However, shrink_slab_memcg() doesn't drop the reference acquired via
> > shrinker_try_get() before continuing.
> >
> > Add the missing shrinker_put().
> >
> > Also, since memcg_kmem_online() and shrinker flags cannot change
> > dynamically, remove the shrinker from the bitmap to avoid unnecessary
> > future scans.
> >
> > Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")

Sorry for noticing this late but 50d09da8e119 was introduced back in
6.6. Is there a reason this change is not CC'ed to
stable@vger.kernel.org ?

> > Suggested-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > Link: https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@g=
mail.com
> > Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
>
>
>

