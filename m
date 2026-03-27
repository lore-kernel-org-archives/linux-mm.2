Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF6510AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2700A6B009D; Thu, 26 Mar 2026 21:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247DD6B009F; Thu, 26 Mar 2026 21:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E086B00A0; Thu, 26 Mar 2026 21:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04A696B009D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:20:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68EDDE0E71
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:20:10 +0000 (UTC)
X-FDA: 84590086980.30.CFA1D9C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 653A340005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:20:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YCuuvbeX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774574408; a=rsa-sha256;
	cv=pass;
	b=8iJigPKYNGU+wSMNfYW2fnIE9Y4H6/gpX5tZzZA2E/RERfTAg77dCnp7sIla2KcEIODFHt
	jckjEcfCcQadiKEckYCBZea9J4E6/j0xkUyR1TbNvDJSFskxJfL6qI84YvM2BXQUfs0wRn
	aEEAxy42gphPSee9JnzmRhudNACz0cM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YCuuvbeX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774574408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKNd0ZoQ4e2MyB7lOtX+V9t+pfGExxQ+F3Bm8VJC7q8=;
	b=J906C5P8ntVa5MrIgoNvAZN7VUcuVPqpjVfET8wFkWtZzH1Hyr4PAOxpY/0nL1/9lnxMmJ
	iAdPS5WhLzs0KEACVUSgHe2XBmitsp/oQX6tYhBNi+5J4L+9o5i/kOYsq2mBvjghepFFiR
	cEVGuTFjPDSXo3toCVCB2VEJO/DVl7Y=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-509069a7a7fso272101cf.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774574407; cv=none;
        d=google.com; s=arc-20240605;
        b=O8+fT+e93JmZfX4n6A9bQrii0g0sRPkLDvHfO5QDdrKLtf1T2wefmlqGWZ3JBrOM1+
         UEZHXv4owCpfciUIW+rgJ6tRdgZtIfNwyK1Q3+luAJiHvU4MCy8qvto0wur8KafY7iiW
         yHR+vb8t1k6UG0eiUoXzixYEYZlC+ai8pNuDOMjEBCcJ0xhIdfQi2Wvz2/XDCVsp+sOv
         nd5ynbTIfQcQhJPkJ7BoPuBkY7Oiua7ZrgSdHHchu0yfpy2oJJVG7yqLbCjwkJa4DT2L
         /KA7TMoV9isx3u0VGXm5GZvKI1xDEnJ0io8Cy/RuLzx5OE3F5nfNBZwmfo3wfi0mGCDk
         e+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yKNd0ZoQ4e2MyB7lOtX+V9t+pfGExxQ+F3Bm8VJC7q8=;
        fh=faGayRYMBZgbUkHjjnu5EzulkopXMQwmkkifpVeD3co=;
        b=kyTEG+CNBq3nq8bhJk7CwTH0xkcEd5i+o6GJor+/844lRCPMRSxyOAyw0QesTV1WGW
         PNwxmz/JZZqGdWTJpgNWsnoILRG9fCYT4Q8sgWRoyRDcBq2P1lQsUbc2EMMLPOv8qHNR
         IDLovX1jI07t2AfCzGGkK3beKhJSHoXujT2yqJH2pu313PcqIl2GkZyp2tZBQlLu7pSf
         cQEN4xOymqsVKxVbIB0Utws5QE5S9GrWIIOta6kL0dhgqU0scFfaOwIZN/KL4ITI6PPd
         l/g5RqjJ3ImQm17rA4xIgkVp0mtzWVARRyym7DfjApXHDwYXwyFWd/4oiDFU/deQgLas
         +tWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774574407; x=1775179207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKNd0ZoQ4e2MyB7lOtX+V9t+pfGExxQ+F3Bm8VJC7q8=;
        b=YCuuvbeXmZgTDiNGvoiSCyxtAot3LtkUnxuVbRmcYranzhvU8Y2AsqHAFIE9g9Y5Jz
         GYYsk7VobSoeiUrACZPRg6DhM+fAOqw0nYFL6KaSkP4IYokOODZ4brepGuPun/qsVydD
         GIfH0hJHSxhWRBqGLfOCKIBhn0gFtKrHJEILK4GeQeWLbjFRP3kxB6Mnnr7NPJYWHl1F
         qN1q/tjfcikfPfQqVG0IaFXv9hwP7CLIusP6r9Yyg7bpuBP4PJ2krnmjXbyiJJ3gOZU0
         u5x6RJY0AQ0NfLcuooIO8zZDzT2aH4C5lbhx+QA1P03fiXIuTyNA4oOiz6OpYE5Uu/Im
         1OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774574407; x=1775179207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yKNd0ZoQ4e2MyB7lOtX+V9t+pfGExxQ+F3Bm8VJC7q8=;
        b=Ekq6HTmvPdqVDYqkXvoZC5kwD4CDPqwPx+0dX5tLAgp2Kq22twDMyRiXpNvsLmJl55
         ZBw0DCtvu8W/t8s1MntAHjxS4qJhK8qRFpsvb4eDQ7DoMfNN7s+oicp6f7p7TarW7Z/k
         55RqoL4aYLRZMR9naK4L+m5RZheub0QN5oE0MACwb1pzgCkchqYZfuizWIOqfoJaiYob
         sjaxFHGmj/WRHDKr5h+ahsetLDZ8W6bcmbPWVHOsWu5noVK8Vdazdlj25NWCay9rxP2w
         dzlpvjHMM2HkJy6jUVTdFysTxUBx+GWkVYo+cwkezVtUeo3v/zhqJyCSPDe5p0iAnxhI
         i6Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWt+DS1c8mBFr0qwX4qW7U8RuhGBsvtD9XTBYkeoox3hppbetS6Pp7F/ywT9XFgpi/9TeEBWFstzg==@kvack.org
X-Gm-Message-State: AOJu0YxAvU7VZ6iZnxTcnPTo9NbX8demTXgLy62b5/tbsi5cAfXvMG5S
	yPobJXp6M7yk+M00FCvIFOSON97MLHSfLknZ9F7tgF5mp16ue2uI3/9kvvFKqlz8LA9q2YB0Wey
	5qAPt2gsZlGoiPEysuqZ53ePStaunjXH1lG3QwXwp
X-Gm-Gg: ATEYQzz9e9DkBlMCKUjLU2VHK8ppSPHH7rGNbpyJNojtKfFf6bIzP+hRFbDqO0ZX1Mn
	atiI16PhKtVfZpVSovfmL0TlPSsSbWZR1fran8JdUOlThEf1VexVbkgP+XDhlitlxtjgy61mk+2
	eN2y8lnWXS2P7liNxVw/Bei8Vfmv9CBz87fWoZasMZgcOuul9n/MLmTeQx/pMX780fKYktqKAWM
	wdAhn22ll/qXw5StIN3FlXkbW9DJq+uIPu9vgaDBfYDmNysQZNQrDl8HGCmDF+S/sTgNlbXWZZj
	wkAWT5nc6s9s5wbW
X-Received: by 2002:a05:622a:4cc4:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-50ba1bcc884mr6606631cf.8.1774574406996; Thu, 26 Mar 2026
 18:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260326140554.191996-1-hao.ge@linux.dev> <20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
In-Reply-To: <20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 18:19:56 -0700
X-Gm-Features: AQROBzBJpvUoyOTB3XCtYnNjPXkRYxHCWOrqxT-ikGoxJhga5jbZYNEfZVJUJeg
Message-ID: <CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 653A340005
X-Stat-Signature: ix1jmez9mm9eg3zn4wn1hw7kitaupqd5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774574408-895101
X-HE-Meta: U2FsdGVkX18cAr7K7kkrOHTROOPY8A56+iNopj4VXnqe31tvvC69DUz8Mqs5fnBXrt0uqa2pBFtfleQlqcf/9MNluY3Z12TzqCka299LTkvu+p3+SJ6dmjYg/zWzuxFEcB7q1r+9ODiCpKRvBZt5Kdy0510ftBl2Rk4Hyc0hHnxrdvlsxeiRaqTFrCKd4jcclKAwGmnBlpyo1f+96S93w1vs8c3wtABHqjcntkZbhr0u0fkZGEppIFpbVTM0kqF1FQZg/ULsYjVmBuTtz1JGgEFEw1fFY1nWvH7MUSM4lbkxAchGUAy7XsaVH2GBpAGXBL1gR/5jxE/dHEz/srJT6K9gzlRs0SzpWS24y81nmqW2eWqlq1IOW5xc5rHJNlcm9vKvKOHtR6McoxaIbssi5CALH9EtfdIULsny0Se9N497OnoHH8I75c1VO+FdsY2p2JQs95ZoNlGx+ExP1ke677OWgpZuSxBD1u4hYgxjDhmQhkyvPE1Re/I9dZfz51rbuuHptVKVSFImBSUJeMb71F6jxk5MHrHdVzeMRVIxuCazh+rwIdVTStSscjAvH/qgYO8kSow31GXKPZVJ3pcK+cx4laATHpYUwzbsYOjVvbJNyfbPjv9Nu5kLkO9OGyeeI6KVnguw8V323mmLDAdPPkbY+Zbb3rUpYII6hUz68bA+HtedflIxc47Ppnk5R7EWJvQybpLWic1jXIkfo3q0xZ6FgBeRPucvE23GDTAk4CpRS072Nj4c6RmRH/SRuTzd3Critj75N6j/t3GCuYa61nDA7GyavdexS5OvjI9XojSA7vsMg7YacG5MYLJOFXiLxxhzbVtZdR77YTaFsOB8ywvoCSk5MieDOQnKR8JYgKpZVt38JHDshpeyumtlpXoVxGGY2CsMFNseBgQs7Cxyi09Kbw397L4XSxxdC/hdL32gXYO3/G1r7P1rQVMpDmPsZp5hshEjQmdHYAFKP0z
 NZMmI6Y8
 zD8wJBSlhUEzbCIpgsltgpGuJMD8NRuob8heGlsEA+DycktLAGlvYIPUTHv90Pv9fqLpr7kpD7y44fsC39FGITlYHNvhgz6/zJGcXhfT/z03fYHY+R8Vka3eTEVN8INHQzh82xhTFEU9dw1aoLua0DhLDCALThfquwI64sK/4XUgBTAyUkRYTqtvZRy0unsb2jSUWNG49XbqRe2D+kttKBIdPRw5BXGo6e/2ULAHDOLWvqufg3BnivC405UvYBrRQqfim1mI7Hp6QALUce3+rp06kLjqU0seLK1KAPMnYaflZiYmzUzS+GJrj/UL1fuJbwwbO0PpD9D+s+6aKaFzuiULIsH3pLoctsdjfbP3shbVgOS8zEqMT0cBOpAvpObNZqVkiLhto7G47jNrT0T+A7G+BXrlKY19aSbzJ65lLza6ng0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 6:11=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 26 Mar 2026 22:05:54 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
> > Due to initialization ordering, page_ext is allocated and initialized
> > relatively late during boot. Some pages have already been allocated
> > and freed before page_ext becomes available, leaving their codetag
> > uninitialized.
> >
> > A clear example is in init_section_page_ext(): alloc_page_ext() calls
> > kmemleak_alloc(). If the slab cache has no free objects, it falls back
> > to the buddy allocator to allocate memory. However, at this point page_=
ext
> > is not yet fully initialized, so these newly allocated pages have no
> > codetag set. These pages may later be reclaimed by KASAN, which causes
> > the warning to trigger when they are freed because their codetag ref is
> > still empty.
> >
> > Use a global array to track pages allocated before page_ext is fully
> > initialized. The array size is fixed at 8192 entries, and will emit
> > a warning if this limit is exceeded. When page_ext initialization
> > completes, set their codetag to empty to avoid warnings when they
> > are freed later.
> >
>
> Thanks.  I'll queue this for review and test.
>
> But where will I queue it?

I don't think it's extra urgent. It is visible only when debugging
with CONFIG_MEM_ALLOC_PROFILING_DEBUG.

>
> >
> > Fixes: 93d5440ece3c ("alloc_tag: uninline code gated by mem_alloc_profi=
ling_key in page allocator")

Hmm. I'm not sure that's the right patch. Technically the problem
exists once we introduced CONFIG_MEM_ALLOC_PROFILING_DEBUG. I'll
double-check.

>
> A year ago, so a cc:stable might be needed.
>
> > +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
>
> otoh, it appears that the bug only hits with
> CONFIG_MEM_ALLOC_PROFILING_DEBUG=3Dy?  If so, I'll add that (important)
> info to the changelog.

Correct, it affects only CONFIG_MEM_ALLOC_PROFILING_DEBUG=3Dy and only
if !mem_profiling_compressed.

>
> Do people use CONFIG_MEM_ALLOC_PROFILING_DEBUG much?  Is a backport
> really needed?

IMO backport would be good.

>
> Either way, it seems that this isn't a very urgent issue so I'm
> inclined to add it to the 7.1-rc1 pile, perhaps with a cc:stable.
>
> Please all share your thoughts with me, thanks.

I'm reviewing and testing the patch and there is a race and a couple
of smaller issues. I'll post a reply later today.

