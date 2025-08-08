Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C68FC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8432F6B009A; Fri,  8 Aug 2025 09:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4186B009B; Fri,  8 Aug 2025 09:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2386B009D; Fri,  8 Aug 2025 09:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B62C6B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:08:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10F98115200
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:08:50 +0000 (UTC)
X-FDA: 83753620020.02.4147F9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0CFB01C0011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:08:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eOug1dTC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754658528; a=rsa-sha256;
	cv=none;
	b=HgmHA/x8lrCul34zbArroQN0fSZUp7sfaBCUxMuGzpU2YsBEnfnHBnT4aVV/vYAqMFs7L2
	UYawtuyb9elqiQxhkQF1Bb5XIDLAe0mTjVUEnM3TpLoTXSEJYajKgYxMk9Xh4AJPjY2O1W
	hMVDsgCmC0lLM2KBiKHzjTyTK9hGjWQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eOug1dTC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754658528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UiEs4Rh6Bq7jrDzS2r+cL0UHOZ82z9RlYdz/rMI4Q=;
	b=sXy9+UOTT4wls2AXWEuUWQbfSV7rKKfYCKjw2J5GDTwIfHl3IST/N3WxLsBnglNGnClP+J
	f6t1feRt5Up1qC9Oj/WkLNIE4cPaDnz1K++MwGdXuotFMeDL9hTZKNTJVZvpKX+C0s8Pq9
	qPfQDiN2mqmloey+EfWsa3f+g7JEdso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754658527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M0UiEs4Rh6Bq7jrDzS2r+cL0UHOZ82z9RlYdz/rMI4Q=;
	b=eOug1dTC6it8n8wYx3lwF4SjTLLQZaR5+6iBNAbH7pfkNjgeeNk3wpTqgxCk8izfZQvPmR
	jHsOiKQMTx+4Cv1G+v2UuY6xQo19I0S0X/eXr1DFH/k3hRXqBvS3D3CCoYZea4njtHdZfU
	qK36HanQtazl6yv+2yhFkI1oFEmbZyo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-228-46aA9S8HOqitMnE-iqR_lg-1; Fri,
 08 Aug 2025 09:08:44 -0400
X-MC-Unique: 46aA9S8HOqitMnE-iqR_lg-1
X-Mimecast-MFC-AGG-ID: 46aA9S8HOqitMnE-iqR_lg_1754658522
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03A801956086;
	Fri,  8 Aug 2025 13:08:42 +0000 (UTC)
Received: from localhost (unknown [10.72.112.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A81B19560AD;
	Fri,  8 Aug 2025 13:08:39 +0000 (UTC)
Date: Fri, 8 Aug 2025 21:08:35 +0800
From: Baoquan He <bhe@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
	ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <aJX20/iccc/LL42B@MiWiFi-R3L-srv>
References: <20250805062333.121553-5-bhe@redhat.com>
 <20250806052231.619715-1-sj@kernel.org>
 <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ca2790c-1214-47a0-abdc-212ee3ea5e18@lucifer.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CFB01C0011
X-Stat-Signature: bp3ncg18mzujrj4emtfahxt9kgbbxgru
X-Rspam-User: 
X-HE-Tag: 1754658527-375705
X-HE-Meta: U2FsdGVkX1/xKDQzMLdfRDvRkpjL8H7tXmpRM3RrglBV3zGY6fcMdTBiPnMARW8uCQ2mXtzji5AG5hytEqHkpwD0OFfWsi191MCA/bcDFi4kRX1MkNIVI5+OVr2QlhiaQKQ8cOiz245G5JoexuSfiDxD8+el1SJ/5FdRdHWio5dQzGa9pcDHRfB+rSRpJGtqbAo9r3dpcMzsEEZjLIPwwxnDYRlUIdf+UfGs0lvwHQw9wU8QlFSGLcpm7qN49pY4VNwlLOTMPzsjosSalXAwzjVNegEBupaMuLEac9MN2B5R8fI8QnMq0ICplJS/uAmvE4U+YnQ3zRrOaiWiir9hjgyP8Q4RjZF14fVa6qjdYRERRL5oDXQsAoaVmLymoc8sk3rMGOAJmBw6csmoaglR5PdMtODUctmUw8Klue4mTI575l1OOA2M+C0oM8M04bUf/IjEL222TkIgrizdljFQ/nsr3J8/Bbwj1+X0IQp/aWL5liPsI/yoejUPoZdgwIY0tczhCEamU8fNU+B/2Ur9JxSRj0DlHaLlXse/XfhjlpPd9//DnyO7MH8CI80hMNklTo/bNdgAOzH7JRNCLYyYjGn8uRwQ/vbctNCiR6BM68/lDyO3VN9pvah1fxqiqaWu023IYTqMNEKD0EwdS3VVK4pSzm2JZDs9Isy5gjsQNhvpLw3FO94/nOsa6IXMsLR94tpKy9o+su51y+YWWt67x7jlWASyA6vei2B5DEzOl1aVFdK5cP7E0O4Vcy7E+cU3BLSd87juRgde1Ro3ceXxCDfPSNUJMDCSUeszcc0SlRMba6I8dJGj8qpny+Ot+IbKRc3F5xqlyNO0MjW1m5WA11a9RxJGI1Lq/KzhSodQIDHOrqmbPcvWAoE99ovSlNxVGxjWv5AHFA9f4QabTYECIMTKh8wNGRwrpycGgk1Y6xa+NOSVHr8hmuuzZqi+1WdqEaP6+f6naRQo2bm6iD8
 JmEgpImX
 b/NEYWkr9i0BCeOi8KY4jCDIDHEgvdvyrDHjxc1YJT79vrv3sRlNzDcO0wKCiAjcXPIADCHAplNGe2GjtzUa3K7YvNONJ7/AGsh/riqv7vdRQXmKixJcYAeGmLIijQvDnYukBvDNItfJXRbG+Zw9mrL/2CsVATXqddeeBUOG5EEWasvIjYJoTn0W+zwA72+kKJjuEHCP5i/9RJYLhjitWvaWEiAfSujIIpMhSvY3dd37cjGsTqkh+Ri4GOzMF9D5a4p5UYdb6L+iS1y9518vFaUpFLPKP0Ltv0AdBUaXTFxAXNMbD+MRHgWpImNXrXqyEB98E7K0vAQ3CzfcVEwkIOmgsPac9Z4KAmWG4FVucEJ1yYyn1a82OFlPF4hpToBTtl6D6dVPAoPBhoRz5uH3x1ti2dKQB7BD4xcT8UjjDITVY1ngLdXQ1p5g0uj38fIq2kkFUNZgqi+7wYiMjav3qhnw/HQxZukZNuSI0r8vDFW6yYMVjxbCLqjUPow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/06/25 at 05:26pm, Lorenzo Stoakes wrote:
> On Tue, Aug 05, 2025 at 10:22:31PM -0700, SeongJae Park wrote:
> > Hello Baoqua,
> >
> > On Tue,  5 Aug 2025 14:23:33 +0800 Baoquan He <bhe@redhat.com> wrote:
> >
> > > Now everything is ready, set kasan=off can disable kasan for all
> > > three modes.
> > >
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  include/linux/kasan-enabled.h | 11 +----------
> > >  1 file changed, 1 insertion(+), 10 deletions(-)
> > >
> > > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > > index 32f2d19f599f..b5857e15ef14 100644
> > > --- a/include/linux/kasan-enabled.h
> > > +++ b/include/linux/kasan-enabled.h
> > > @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
> > >
> > >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> > >
> > > -#ifdef CONFIG_KASAN_HW_TAGS
> > > -
> > >  static __always_inline bool kasan_enabled(void)
> > >  {
> > >  	return static_branch_likely(&kasan_flag_enabled);
> > >  }
> >
> > I found mm-new build fails when CONFIG_KASAN is unset as below, and 'git
> > bisect' points this patch.
> 
> Yup just hit this + bisected here.

Sorry for the trouble and thanks for reporting.

> 
> >
> >       LD      .tmp_vmlinux1
> >     ld: lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'
> >
> > Since kasna_flag_enabled is defined in mm/kasan/common.c, I confirmed diff like
> > below fixes this.  I think it may not be a correct fix though, since I didn't
> > read this patchset thoroughly.
> >
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index b5857e15ef14..a53d112b1020 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -8,11 +8,22 @@ extern bool kasan_arg_disabled;
> >
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >
> > +#ifdef CONFIG_KASAN
> > +
> 
> Shouldn't we put this above the static key declaration?
> 
> Feels like the whole header should be included really.

You are right, kasan_flag_enabled should be included in CONFIG_KASAN
ifdeffery scope.

Since CONFIG_KASAN_HW_TAGS depends on CONFIG_KASAN, we may not need
include below CONFIG_KASAN_HW_TAGS ifdeffery into CONFIG_KASAN ifdeffery
scope. Not sure if this is incorrect.

Thanks a lot for checking this.
> 
> >  static __always_inline bool kasan_enabled(void)
> >  {
> >  	return static_branch_likely(&kasan_flag_enabled);
> >  }
> >
> > +#else /* CONFIG_KASAN */
> > +
> > +static inline bool kasan_enabled(void)
> > +{
> > +	return false;
> > +}
> > +
> > +#endif
> > +
> >  #ifdef CONFIG_KASAN_HW_TAGS
> >  static inline bool kasan_hw_tags_enabled(void)
> >  {
> >
> >
> > [...]
> >
> > Thanks,
> > SJ
> >
> 
> Cheers, Lorenzo
> 


