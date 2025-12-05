Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28EDD32D9B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 15:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F776B017D; Fri,  5 Dec 2025 10:07:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66996B017F; Fri,  5 Dec 2025 10:07:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4BC6B0180; Fri,  5 Dec 2025 10:07:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10BCD6B017D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:07:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B95BD1A01D8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:07:25 +0000 (UTC)
X-FDA: 84185746050.15.18245F4
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6DCD5A0016
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:07:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jU6SpZYj;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764947243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5e1JDxNMsKeBjrN3+x94DCexyw30V6kM+/jaZC8wkNo=;
	b=Onyyp02kNhd5Gji7wTmoIYvoJ03KR3zOgph5h7NMiOwup4b5Q5Ee0wTlaMtSAfC/Q0J+Kl
	QTlL3NTNtT8XMBhflWFZVBAY2Bxqe5W3Yi3Xt2R1u76iPeDnKcVEG5EbMgHaDsZ3uohSZ0
	T1ZMvqznKh8YLA72mUbyNPILgxLQFNM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jU6SpZYj;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764947243; a=rsa-sha256;
	cv=none;
	b=jspk2rUdLV8rHjoKZfV4WUTjrbYevHbQ9b4sL9xm1mthkKxmI0VcChdPNV67Z5STxb4pgf
	tpi6Di6lDujliG2V5lksfhJRbo5bRRfQZxRuPhdIBuRCrwjEPPsVRuOoQxtG0bZOnAGZ16
	XIB7VVnLDCrSmDfjI5AQ5TXtyN27fwY=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so28202315e9.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 07:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764947242; x=1765552042; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5e1JDxNMsKeBjrN3+x94DCexyw30V6kM+/jaZC8wkNo=;
        b=jU6SpZYjZbv3H7GWwBcNxquEiOw2lvcwEhSk8S77+FuKX9X25pDpbx9375H5qzquNS
         9yvw3QSNkS+XQFi4SadxVjZgxjwdg4CFS3zMJ1AKfTuQ/OGfET95mVZs115JFHDHYzKq
         j2s6utB3+lbEZzLFwpv+yxdixqBpElERtakeUAKoUBDr2w1DSE+VRYKg7sjhj7TznozW
         I40uWAnI7s9s+d38UFyZH9pOOYzW054uKxbT2t16cg59UQi+hr6zBQssXjP3pgXG5r01
         kKtfbI1hJFYZBTkImGAiE/Z9n8th45W5mBfStNYH7Tj2lDNTVAmUKi/9Q3ZsV2GRpGrZ
         hyww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947242; x=1765552042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5e1JDxNMsKeBjrN3+x94DCexyw30V6kM+/jaZC8wkNo=;
        b=UXcZRzGQ1FmbedrvsxLkAGkN4pGg11I39w9B30SraMI6axnPupl1azDvzlSrCd/CcB
         NHTx+PuNeFESa5XQcrU99ec4tykL+7FGLiIpSyzD3K6xUwi1upHG4Ly2I3eP9f41Yb51
         h03qmJ9KwGlF6hQLDGZn69xxgYzA7AlL4H0Rm4KARNMtEuF1GE23KZdTX4geD2ekRDpx
         G99UqXczpd8B/xEHOFfx3kmUq4Zcxkn+7Q7xkOQmXrxBn9hH38LiJZdSKjKx9d7lrkRy
         +vIa5tmq5hCdETSjHTx9V3bmMazdnMXIhUllnx8cO6ONzsbF8XXkvQDiuhxkZ/QtNGyk
         zhbw==
X-Gm-Message-State: AOJu0YwaV4JXZNT6Bgd/00xg50j4S9jjwHASV28twBw+1jImM20DCP3p
	2oKD6TCPscgEoHni7bMOBdEqNC05L2XKp93FVN8DvQEPozGweEhio34hUkjSy2DCJA8Oo1O5iwD
	LI94x/WKeEBTx3oQJPLyhngVp+SiJzuA=
X-Gm-Gg: ASbGncum/XFAiV8pusKujK5EkMYSsfhlU/FSA8OaZ+pXADrlzSNgrEODfuUz2XeQI1M
	WPSBWuNwDzjSGFg55D5Jz4XYEkz3f0s00x0JJTsvIPrg+JkfhjQCpVlrz9HuPnyBJwXo/Joy7l4
	SMX6fISWBGmitD8I6NsMnCDnoToW/GTORv4fQrySwPcklbvtL8cHxVUv32PrAfRZgky1mlVgJo7
	dvTrSMFR6dfZnw9JYoNjmElo7k7EUbKdww97vYgABqFYeLxHlthUEk9vne38dIH49oMPTZlPpgU
	/o+0Epe8g0IjyrryauDb17mQpAxe2CXDUQ==
X-Google-Smtp-Source: AGHT+IGM8UyEJTTT9Z6uFlHy6NNxt69p9mMEtv2ZpYk3WvAawcJYPmX38Eb9ObakRfbW3X3Kb6QvbtgtLouD0E5YqJ4=
X-Received: by 2002:a05:600c:45d1:b0:471:1435:b0ea with SMTP id
 5b1f17b1804b1-4792f38d501mr76181395e9.24.1764947241641; Fri, 05 Dec 2025
 07:07:21 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-2-bhe@redhat.com>
 <CA+fCnZfDYHUVKX-hdX3SgmuvJEU-U+MuUJGjs-wJJnfRDHz2sw@mail.gmail.com> <aTKHzmxR3JA2R7qD@fedora>
In-Reply-To: <aTKHzmxR3JA2R7qD@fedora>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 16:07:10 +0100
X-Gm-Features: AQt7F2oIzOZoI9YYmMGEGfR2euyjD-iV_heXJVsHmHq5B90kIr5LFLwzTYtsmlM
Message-ID: <CA+fCnZdZQFVBf_NkrKk0U+TAptfi6RRmCkPY5ZpOUeObBpwAnQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] mm/kasan: add conditional checks in functions to
 return directly if kasan is disabled
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6DCD5A0016
X-Rspamd-Server: rspam02
X-Stat-Signature: soqex37eaeua1w6ri38iz4uhscpztpah
X-Rspam-User: 
X-HE-Tag: 1764947243-480673
X-HE-Meta: U2FsdGVkX1+HmX0kFYImsb0zamOTdjsechhykGBuXqonTKVox2ycxchK93wZdT0UEhFBJAe1h3jaR7mD3hvZEuUE51jySIjBOqMOdYGvj4BJk3u7/TGEVqqxP+BL+xdXQHtZ7hHiBvlrHrRQWy9OIfiRgA9GyF2kQGWTawJiWnJw+0lwWjjM+Wy/mkQwuY6kKL+r/+Jfuih3EBUed74cKetLFTso4dZZ6oGuQ/vom+qw9KE88opVKxeDyYpGwayF85RPjZrO8EXzstnDpXWFAg/gfX+uZSp1AYIW1J3LIfQ1zzLgNaT1T8UDU1yPzr88+dbE2+D8GlXyq1bCkkrZ50BZ2NCjMB9dhHVKiAl5dskHfyYOILvR8G7bvzo/qXB248mATatzvxef3mwefXz8Qdv6JSayIAQSk0F7BSbFfEYpIP2AOpV4CEcjHzwKobLdlQm3X7lx+YNIE6ze+qhVREEObK60PRK24sDBuFTRrNHSXRWPdz3lFKvkH2ZS9bLZjWLOWVj9YJs619vFOSulqchgRhsmDpgcssHVlV4bL5NxwOn2lmkTOzPAr9GTxylEmjXIQGeajyfJpYpShw/9yUwXK4ujCTxcLmhZ5u4f8xhrKEIdDlWEQG/pLEY/jY/2CulG/1Y/zMnhAOi5ZGQ0WcWvNZz2WU5g7Q383LF9da1hnFyYzD5dXSYBvX6UmCb22X3LFVYGuqNdPWHjX/PZCN9kdoBBRs8ifrG2S2kMTwEdcyQENnpzrYeZ887cehV7W6KAu7WnIGsDieFYEniUu0hkj0aaVk8x7lDyJgW31t/ATO+ChmfVDqHM8yTHgJ2Dfhtv3qFWVFk+QdrhTGesKkIWhehGnsHfoNGHFe+upP3ZmykYcSAVZ9QmcDp0ydDFziPu86MASKlu0Cd+V+P9YJQm/9cY3+1FfgabWvf6ctJ9rsYQmo/rZND8uYKtRZb6kYtiIbrzOm/AcJ5kDor
 FgpV/Or3
 UaKTAecbR56/kfRz8LhoGOZg9U14lT1/UqJKZh/EeRDpqO38TZP1Ea6GxYhNncSHUzg1y2OHlAjRL7Osf7W8wQz4dqhHHXwocCzwWnclFDofORIJ3B0oQCYOlgBlEzA2nVlMotnrq3sn1kGvsyAL9NqEFgROVG1R9TM1vxPxGI8OBmfEypytdUry/1QdYmdHW6LBrFeycOosO2PKLaXcUZMWgGs83OAty29HL0JOylv19aokOunIociaWln52hwWfK+pxcH9wYiH5FRbrOnUGVcre6j74ZE6KKF6KWrTVZCN7vdavJq4P6RV0uy1d+tVp1pzjK3/r7RbvHT3gIW4oWHR5HAAoTlmoTp3OCjqyfBj5ua0eNP/ixBAjoa8vRiQlzGpt/mQWjnZrnpbiCgbX4LEVmtrtb3LrDXbJwQKnXFcKsa8FBW+hGw1bggJjqQUr3GMwZN7h3kw5QXlEvRRRVdFw5HbqMeJV49YiOfrDwerpUm3fqfY2d/ab9TlwVP/uml5zbQwi+Pvbt9S8fZU165eryaDJwyqQt2Iu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 5, 2025 at 8:21=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> > On Fri, Nov 28, 2025 at 4:33=E2=80=AFAM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > The current codes only check if kasan is disabled for hw_tags
> > > mode. Here add the conditional checks for functional functions of
> > > generic mode and sw_tags mode.
> > >
> > > This is prepared for later adding kernel parameter kasan=3Don|off for
> > > all three kasan modes.
> > >
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  mm/kasan/generic.c    | 17 +++++++++++++++--
> > >  mm/kasan/init.c       |  6 ++++++
> > >  mm/kasan/quarantine.c |  3 +++
> > >  mm/kasan/report.c     |  4 +++-
> > >  mm/kasan/shadow.c     | 11 ++++++++++-
> > >  mm/kasan/sw_tags.c    |  3 +++
> > >  6 files changed, 40 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> > > index 2b8e73f5f6a7..aff822aa2bd6 100644
> > > --- a/mm/kasan/generic.c
> > > +++ b/mm/kasan/generic.c
> > > @@ -214,12 +214,13 @@ bool kasan_byte_accessible(const void *addr)
> > >
> > >  void kasan_cache_shrink(struct kmem_cache *cache)
> > >  {
> > > -       kasan_quarantine_remove_cache(cache);
> > > +       if (kasan_enabled())
> >
> > Please move these checks to include/linux/kasan.h and add __helpers to
> > consistent with how it's done for other KASAN annotation calls.
> > Otherwise eventually these checks start creeping into lower level
> > functions and the logic of checking when and whether KASAN is enabled
> > becomes a mess.
>
> Not sure if I got it correctly. Are you suggesting it should be done
> like kasan_populate_vmalloc()/__kasan_populate_vmalloc(),
> kasan_release_vmalloc()/__kasan_release_vmalloc()?

Yes, please (assuming you're referring to how these functions are
defined with all Sabyrzhan's patches applied).

