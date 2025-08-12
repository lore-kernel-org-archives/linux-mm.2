Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D997CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11CE8E0130; Tue, 12 Aug 2025 09:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3328E00E5; Tue, 12 Aug 2025 09:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0FE8E0130; Tue, 12 Aug 2025 09:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC878E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:27:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52B39160324
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:18 +0000 (UTC)
X-FDA: 83768181756.13.C98D77B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E288A000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:27:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDS8zN6I;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ek84SNcPpQCmMHvcqQa3TlILZVgRFvPfl/s5BFwLTA=;
	b=su1aatZIT3AncYJQQc2rYJgQfg7rwSURyItmudbDYyEQQI3ATOYbSyVITTsU5aVwZcEjlW
	Wzd4LbrpxbY65ZgxIznyq8rLLB4FxKB/6P7icxlRlTmAsiX+lHD/1uDpi0TZ9jaO8D/JgB
	Gl7xz5+b8nD1TSNX0vuPCWgx2a04QK0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDS8zN6I;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005236; a=rsa-sha256;
	cv=none;
	b=ZMQI1XcVt97S9PC//wyiDfZImibTbF3ENSS/9WyQqf6mKeyDMtDX2U1wXurOp+26ybED+S
	inwFmBogWyO59ySCIP3K486s+fah7fVIDaqmXjeJ8Lfk/7kbjBxnRwEl6d80CSSp8coFHM
	4GKpAkpjd2BFL7tjXwoU0pmO9umeHFA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755005235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5ek84SNcPpQCmMHvcqQa3TlILZVgRFvPfl/s5BFwLTA=;
	b=TDS8zN6ILtDcti5ieUFOGNCGBIn98LI75i0ViiYG7oS/puQgk5l2EGCOkwhPqFp2EPR2Nc
	k2J6KD3uY83xZiecnFl+YUCFf+jPLkbT2yEgPcV2L9p/krcuunH/DX8E3oA85P0YOFedq/
	x1senS6YmJO5RYx1V2HahvNpDFez6tA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-l3ZgW3CKOGqqNd4zvWIV_g-1; Tue,
 12 Aug 2025 09:27:12 -0400
X-MC-Unique: l3ZgW3CKOGqqNd4zvWIV_g-1
X-Mimecast-MFC-AGG-ID: l3ZgW3CKOGqqNd4zvWIV_g_1755005229
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C128018002C8;
	Tue, 12 Aug 2025 13:27:08 +0000 (UTC)
Received: from localhost (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9513530001A1;
	Tue, 12 Aug 2025 13:27:07 +0000 (UTC)
Date: Tue, 12 Aug 2025 21:27:02 +0800
From: Baoquan He <bhe@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
	ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <aJtBJgC82CpUkwTi@MiWiFi-R3L-srv>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
 <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
 <aJX20/iccc/LL42B@MiWiFi-R3L-srv>
 <b5d313ef-de35-44d3-bcbc-853d94368c87@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5d313ef-de35-44d3-bcbc-853d94368c87@lucifer.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 4E288A000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 36xpi7a666ocrzu4rpm9mxsihrdhboht
X-HE-Tag: 1755005236-392916
X-HE-Meta: U2FsdGVkX1+A1APCFMXSjIFuAsStYdNuuAQXOhwG3EsScX7J/ISNHqSlk5rcHciyHweNDNWi6pa/wdjdAEvcL3b1U1hN3OPzy7kizRATBY8j63WPQZtBaHVCZFtWgE3KR7JIdoPKkLU9SjmptKI2jFhkrFqkGcr8DmBjDGuzosw8oTZw5q6k8Ad3crwEw3qtGWjLUfm47PqivRTkb1pE71T4O2KtSyPfdTN7uCKw6o69BXgkwh6aWseKk7zRW817tGyIPbpKBtXIeSuOK3P16NCCoLlIZIDZwAAPLG9ABsdplen3c+3TiHu7Usha6Mjs2EXouF4W30edGvScWxIdIX1pTGcALyQp16Vx9HI/8+oo/LLtNXClwnj7Mi3QbZ5P2/ts4cFkl84PNgeB96k5jJCgqLSh0qy4MBFIwwD2YaUffTRljRu26HY0DXFtlaU+h1kr0Rj+N7dNGN6fj1q5WbuuDD1W5pQsEZZW/fL+Az3zy2oCnNobGnaQQofyN+0E3PqYCSOLECXEx3Z3T/NCQNXWZLEq2/vvEfH9rk+ZIsWDOAAbvQovL7rm6J+R60hhs9wJ1fOBc2ykDP/upg8OEwXw3zCfIMph6gy/lrm14hrU238v60uzFrZsIvTxDR3H48Gjl6v8adsd62nxz9YsQIWKm0Kcol4Te4d4HGC78eCpvnUDUZNJyaBzHTpJqfQ2HpI5+MajIGr+K6FZJ/7HVfoCEtGyrbHTIEqPyHSDpe9wPagBlTno8jzc14SmgE8+JyNI7AUE6V8OMyhHF5n0YLu6xz9UCptT1iisqv0KlKT5qfvNptdLbwl28YsNjpF7997d+K1TQz4BSl6cANmzrQCMfodjGLG5RZxPWtnrNHn57kQlvThiB/koj4ZU9GE+Mx/3XBd/uPU0Kse0LTSFa/c1Ki4igMkmYBjWi6QwbkR9IFb/JV6yoGd+CzUAGD6ATHYCXbA3vKhaj2Y2iyA
 CpvD+A8V
 zZilqgjGcFnC63T+24pu155nLGZqrcFjp3fj0q07EP3719Py3L7sYfbIxGMgOz+hkf8bh2KAXh1TcRBz91kZvbZwU6EVkAaDU/h6xAx4SoPUGH5w/Psrn3AjI2zGIBUeM4PzRDMD8H217uILwMn0/pfj8bWL70jnqZM39QOxEHZ6LxEI0G1lPRqzINcn9Yuq1vaYZZaTzytOMhGVf3MJP0P6ZlAl1hhrcDu7QuP+rDjX/ljeu4w753uWLEECGdNA96CN8DCE1qrB/OjZC+9lmuo80ySl9nlaa2vRZUxjIIbv/pPlfgV2PTHoLiTdgF9emrOB+e9gWeu/cSvnkOnZPB7O2Zfe06Dxz+MFAgW17U1JhXKKoviRtIdazao7bJoBrj7PMl7utrg3YLPHCW92v6NSjR0R5Z9Kg3yk5tmE9cZtSP+1A0IC6hemFoRGw62wq6BG6cXkMauL9U1Kq4K7IJ/CaTPvCstmx2Gi7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08/25 at 02:24pm, Lorenzo Stoakes wrote:
> On Fri, Aug 08, 2025 at 09:08:35PM +0800, Baoquan He wrote:
> > On 08/06/25 at 05:26pm, Lorenzo Stoakes wrote:
......
> > > > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > > > index b5857e15ef14..a53d112b1020 100644
> > > > --- a/include/linux/kasan-enabled.h
> > > > +++ b/include/linux/kasan-enabled.h
> > > > @@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
> > > >
> > > >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> > > >
> > > > +#ifdef CONFIG_KASAN
> > > > +
> > >
> > > Shouldn't we put this above the static key declaration?
> > >
> > > Feels like the whole header should be included really.
> >
> > You are right, kasan_flag_enabled should be included in CONFIG_KASAN
> > ifdeffery scope.
> 
> Firstly I _LOVE_ the term 'ifdeffery scope'. Fantastic :)

Learned from upstream people with expertise on both english and kernel, :-)

> 
> >
> > Since CONFIG_KASAN_HW_TAGS depends on CONFIG_KASAN, we may not need
> > include below CONFIG_KASAN_HW_TAGS ifdeffery into CONFIG_KASAN ifdeffery
> > scope. Not sure if this is incorrect.
> 
> Well I don't think CONFIG_KASAN_HW_TAGS is necessarily implied right? So these
> should remain I think, just nested in CONFIG_KASAN, should be fine.

After investigation, I keep the CONFIG_KASAN_HW_TAGS ifdeffery scope out
of CONFIG_KASAN scope. Otherwise, I need define the dummy
kasan_hw_tags_enabled() function twice. I am personally not fan of the
style. While if that is preferred in kernel, I can change it.

#ifdef CONFIG_KASAN

#ifdef CONFIG_KASAN_HW_TAGS
......
#ifdef CONFIG_KASAN_HW_TAGS
static inline bool kasan_hw_tags_enabled(void)
{
        return kasan_enabled();
}
#else /* CONFIG_KASAN_HW_TAGS */
static inline bool kasan_hw_tags_enabled(void)
{
        return false;
}
#endif /* CONFIG_KASAN_HW_TAGS */
.....
#else /* CONFIG_KASAN */
static inline bool kasan_hw_tags_enabled(void)
{
        return false;
}
#endif


