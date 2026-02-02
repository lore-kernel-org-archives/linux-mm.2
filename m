Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068B5E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7263A6B00D0; Mon,  2 Feb 2026 12:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711036B00D1; Mon,  2 Feb 2026 12:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6139E6B00D2; Mon,  2 Feb 2026 12:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6366B00D0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:55:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FEC3C135B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:55:07 +0000 (UTC)
X-FDA: 84400267854.14.14C9B8B
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1605F12000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:55:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OT0t7G/N";
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW3rqeQBw+wiRlXROk9Rf7V9dPEEI1xcsNHwCaeHahs=;
	b=jAbAZr22x2DDoNvMUP8LHwBEAeOKeEAN1qC2TqDLYlpw/hiR791oFqayTzQHtWgahcvaET
	LHKQ/tWgswUicyK3ryseliDPBrjNEY2hk5kJ5ZxRHnjkI8XwQbl68YvbH4cT4Ym1ZhbK0n
	7ETPQMoFfOX1wOaVOPDQAyuwoZH86Uo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OT0t7G/N";
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770054905; a=rsa-sha256;
	cv=pass;
	b=YwTiFtM+RPPTadHUmB5vNH354O1zLKpYiE6ax6HsYLaVoy6i5QrKPyYfjZRzdfjNTZgC91
	bx+fQ9FW+Gv3bx98mhUQsJ253EgiYkV69pWVrZI8LyDXV8jcRHDFXVdjckwhWn95UKwEUY
	x+i0J0KLvea3O7WHmtU7Nc8VVjoCkuE=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-658d3d3ac37so8129450a12.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:55:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770054903; cv=none;
        d=google.com; s=arc-20240605;
        b=L/+UZASDRa8+MGgUinzfyzC+HwoVyL81W7jIXY3cu9nuAwyDcIPDVWmXXmJwIARVIr
         j2ZMta035MgBto0jhmtzV4nr7zE0Q5v7R2napX0cwVKGQC318wuaK8ruZs1snevO2sWI
         sCSXIV5Fe+gl922vsIG3VDjmvBeCibAAAfafGqIWrup/2M5TPlb3D8+gemFtLEBdCQdq
         7xu5b8iGHpO8xPyyVfOzQ+k5CqN4Cjxh0Vg1ShK/3oTT1VSt7uawGsM0xXVIsFqmyLHe
         3lrp1z3Ft4VkdVvzZwgiBllC2BFkjCRYirJVddjnpcran97Icm0ERyLVdw4LtcJqQItp
         qBfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uW3rqeQBw+wiRlXROk9Rf7V9dPEEI1xcsNHwCaeHahs=;
        fh=93kFg1MXbW0hqR/MdQOhZfZq85DQQ5oy4J3th1gwT+Q=;
        b=R/uUmG4sb2aCzkgz6v07OMZgWv+GVzIFFLdM/ZBk2GxSNPJapYQAnlJ/5t2DqIApxz
         R5MqjHR+Ziz4kKeFWbturxcvRrd7UXZKOVSwALJdtXGuelKmL5gKNl3qgQmA3LWfzHb+
         YymZZ/22P85N1c6O8VsVDHteO+LsgSKwFGecC3VbmvikNyxZI9SEPmDS2jFIvir+J1xS
         YHE3Qq+fSMe10buzpZsdR+p6+2e1fENWOdW5N6s2r/01sNWBTLSDb35z/Mw4sTX+Ioll
         kjg7Iz1q6tM7uNzo2vCLL0bvOqo3+aYREFs0Dw1pUav7j/Uhe8QcbYc3NNiBN3jYHESw
         uzyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770054903; x=1770659703; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uW3rqeQBw+wiRlXROk9Rf7V9dPEEI1xcsNHwCaeHahs=;
        b=OT0t7G/NWz0aYhkYTTnNnuHIYGtM/2EEC28IcQUic5OAbpumw6JOlHP4d4Lyg3vR32
         4I09eRPaP+0OaCrdbL2/XOiDUtG41u+GcWeeymN4vv1psXmo2LCG+Rh1rwwaCt6YaHV8
         7NxvonoWARDAzVStxYDMcpuGKazG8HAJhN7GoOH1QOv4xDQs0T+75zvKLNn6HMvN5BHX
         1Uz4P49Y1OhxIPiRLczKJYEQg+DSMnKzdb284DbnZWdL2o8G5vFa4uJR10lnfFZSz/yB
         WINVWCHIiOmksZ20wi08rtr+Imn7UwyiN2JwGS32FwR0AJaPnw2KYhHta3ViquHcHd59
         Bszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054903; x=1770659703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uW3rqeQBw+wiRlXROk9Rf7V9dPEEI1xcsNHwCaeHahs=;
        b=MRqcFh0fOGIjROU729zPXSIErxo/HVNPT6ACcbyxXyi2V3fpI2jkaQacCdjU05Wuka
         F8/+Ns9aYbMK74T3cYTooQHZKUpaEH5scMLgAYC2zymHS5XJ3yPKohCEA8y2wzNUXfoM
         uXSGT15iXvSVDghveLK26Wb52xA49DMJEF8iIKHuiElmAhy1EmEsyfilKj2M/nrQ+mhY
         /3eZ+3UEpwJlf6Mg3UpXtjg6KzH0CEEfl4xPXlkkMlL9ALXE8HGnRAN/m7hfBWBTVAiW
         54tZUxfLNpfm5dhjc/YcRj7gH1naCIvkIgP3cA/w9I585kAtWG0pBVeXQyBhyfraz/hR
         x60w==
X-Gm-Message-State: AOJu0YxGOGFPhgvVi6EhHH2CWrwagn3snUVosyzEZkQAOHFs7Dq+aBjQ
	y2ap87c73i7Jh53humNU/Wjysn6TEU4LYJYDxe8xwTCurB5nDaEfV/Gs5z4lrFp1hvmQUTvuzXu
	36wUCzKVD/BBh075WI6DE6LyFQfQgx90=
X-Gm-Gg: AZuq6aJ0fbRrY2GbxOH01k9WRTS1h51vWh++ARAWfKqxefF4/KY0eKmahf7rEfNI042
	K0KlRI5LT8PRIotHFlkQ5wf1DO4nvIJpgE9L/VlrVOr2QJh/MRz8vooCJ4wuLGDQsurDXehaEDg
	+R2ynrwT1oL3HWF4dp0YqTojdkExIjFpyYaQ8hC3tEloDn67rNaTJslnBAovzEBr490dTvk5wTO
	Z8JCzRol8ryubSqZe0z05dOZFzP2jJfwg4OU5dqfIR/l9xNcS5IZ2pPRime0kTD6gAyQ3jGTdNV
	7qUubUvdpMtzTWTypcnURXKcH3/AFZlE6lu7hpw=
X-Received: by 2002:a17:906:d554:b0:b88:5722:700 with SMTP id
 a640c23a62f3a-b8dff52ba80mr865652566b.5.1770054902916; Mon, 02 Feb 2026
 09:55:02 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
 <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
 <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com> <CABXGCsPwjTNfT0eYMJqQ7UaiEMObpvLh0BOmev9HGFAqomNpBg@mail.gmail.com>
In-Reply-To: <CABXGCsPwjTNfT0eYMJqQ7UaiEMObpvLh0BOmev9HGFAqomNpBg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 3 Feb 2026 01:54:26 +0800
X-Gm-Features: AZwV_QiDpMhoy2QFqGryoD5mVt27CyMThS5ErNGuhgjoz2Y0RlCF-3AaJ2YEhvs
Message-ID: <CAMgjq7COo_-xJwXvy4sLjRHmb6VohMHub0TctS3M+gKwrfjPSg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 6dotpiu4ygjo1sbndbefp5onx8cdxtyr
X-Rspamd-Queue-Id: 1605F12000A
X-Rspam-User: 
X-HE-Tag: 1770054904-553716
X-HE-Meta: U2FsdGVkX19SQ4dGLIlxYWMyxJjQjynLc6uOFvXuMAw446KtrxfPBWHMxxvMH80MeqyCAW2nfQTAhut5tnJ1KTa2ztA3tTDYPfaTGTl584nMTIrO2xU4mgTUbTmp3UCcRYQrznTduMsACcnE3BZsqposTPzqCv+b0pyMVJ6rJ1Gy+y1IAhGB+OBK5yj42OtGovzj4fr0xSPoCueh/oSoAXuoYIwB5e5iRkAzqOBZXLDdSSo766Z2yDBNuABX1d4cxiLCj8im6n/Gz+P5Hyd71MoSCQ2yMD4Px0DUl2iJhVf+ERYrJps59NPmquO5wGcBheHttlVDqliaptbAyEzxMRzFWnXbM6Fc5xdQnCitgW+FMbHqXT6uLhlQs4SmtCXGjfEATcpZALgG5u1bYObBqlbBrleOx2L0S1Iexc5nhuj4/lc5NHkwkTr9A/6BtfR2A7cW7/SJVi6Kh5xeTlm6KphngX5J/qSXqpIqOpSz4rbodnPJPcbJYshCXVPLzQRSbZmrTzx7BJqPl3ERfKKNfFg7cK/h23qe9GLPnxyEhNHYpzT2TsSvVkN4wzDCW86LkIN7IFG9kR+gh6VhcZt0P5hvCua2973jzwpj9jFvmfFQYZTVaaLq+19RbktvNQgzTjDL98sbT7YFrJ6oIdSrj3ky5Q+KhpOESmF01dGD2ftKeHujpjth+E9X1MFYVThutsGBnd5fcpIaKa11RHTEKG3EmOJNSeeH2hnkY7lzLwnyITJrCACbIydyy7L7vS8Cy2rAWXEsqXsFBKD2YY9N4Hci/C/D4P3ZpTsekURGWiIAzsDQyFo5dfTjKzuP7jySDONf/LUinxig3t6qFRMZAE+/5uvKTfUV7Ls+0gIo4ri3vRH+GGsp/saN7FWG4QZ3kBIxpmrAjMcWfpTcSuFi3YwOOhg4rSN6Usm12DcSaVDRDD2S0La5A1lYRcJ4fNKHT6BmM1WxQv0eYrYY/At
 DEPZ+Szy
 t+Lv8tZ7COl6Yj8hnnOGN5HqkhinFmKn9ryNPyVEbRXIqkuz36qRbah1WmQfK0esHqboDObFnLR6XtuasRsEnzwbbQT71INbOu2Yz+f0RGZjZ+qW/23rzuJMMWxSo9YwGkXA0fnGtb6dMNfQVC7xDfauGXU9vKq+FsqjocVCXkVEAqjg3usRcDFYKe/PhSjtqSjw3iwMOo0yArq7DuzFgAtCe8Kw09rfS2yv2bNFcTVoHAlSXCjPiWsFkHXCgpImysRf59AVz1UPG3e75OB4h+0YowuI/q88jK8VEZWeqOuimF3LMR07UFfRm8sBIchsD//Qn/MQbuzpURtbQ2J4jxgXbDplbeeAA2VdlRLMXZA/NIumB+uNUH101MYJZaj8InUlaBsgixJCPkdwTjKiM9CT6MvN4VRxrfsRgeqBtcdPBopEFxOhL9pXV9txglWBofZHQ8+ME1p4qcO8bqPye81L8qtG9NzmCprJsjt+lGB1oQnvfBBKpPnJznHl3/CUPjDswR4SJ9d7GFaLxytexuUsMymEjFFmg43kDxMS8LBs+Rne4B/cvKGntr4B/rN4sv/EfG8ZsBWvw7Ph/JiEYdPl6AUGHmeznttVEx3hv7yUqrBq+1afNsp3qtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 1:27=E2=80=AFPM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> On Mon, Feb 2, 2026 at 8:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > I took a look at the history, commit 3b8000ae185c ("mm/vmalloc: huge
> > vmalloc backing pages should be split rather than compound") dropped
> > __GFP_COMP and added split_page, that's the commit added the comment
> > you mentioned.
>
> Good find! That's exactly where the problem was introduced.

Right, then I think we need a Fixes tag, and is swap really the only
victim of that change? BTW, swap's usage of page->lru will be gone
soon. Still this definitely needs to be fixed first for stable branch, but
it looks strange why nothing else ever hit this.

> Or alternatively, fix it in swapfile.c by unconditionally calling
> INIT_LIST_HEAD() - the comment there is already wrong, so we should
> fix both the comment and the code?

Or maybe clean page->private instead? The problem is triggered by
free_swap_count_continuations which checks page_private to tell if the
page has list data, and ignores the list if not. So the pages should
have their private cleaned upon allocation.

The old comment in swapfile: "Page allocation does not initialize the
page's lru field, but it does always reset its private field" does
suggest that vmalloc should take care of the private field, not sure
if that suppose to be an convention, but if swap is really the only
user of that, patching from swap side looks cleaner.

