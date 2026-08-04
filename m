Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E59C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8226B00F7; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257866B00F9; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149E36B00FB; Tue,  4 Aug 2026 10:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7D286B00F9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:34:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D83DA1112
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:34:33 +0000 (UTC)
X-FDA: 85063832826.22.188B7BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1F46A0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:34:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ix9ZmZ4W;
	spf=pass (imf15.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854071;
	b=rOnVUDwyWTBaxTXH9/jWAl99yyyAnKbg7KxrS3QgsGmS1PT/yBHsTTFASoHajGET4wmoI5
	XopZyihKIVyLUPYtYzrkMPreepUou9FEVFBIuq7nm+wQHnPdMuJl2b2Aj+3YYpPd/ryAT7
	+z7qu5jMS+nzKQMhL4Evq20NYbA9Jf0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ix9ZmZ4W;
	spf=pass (imf15.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkpbKoqkLE2ago1nKO8zeKKdehNgTrIPaOMhneanm5Q=;
	b=BdpKHJWZc1mcchJz/mytqXl+KbeWSu8AZyqae0o9DJnL69AOGwe457Skjfu5HYFr1vmGlb
	wfpidnvctwiEFjXzk7XSCjWT2l5XgOFrFr0hO1O5YRlfmio8dDmoDHDS85yy/+9ZCWjo8/
	G8PxaTlK5J4sTtMe2NRoxqdX1tai1Ug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785854069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AkpbKoqkLE2ago1nKO8zeKKdehNgTrIPaOMhneanm5Q=;
	b=Ix9ZmZ4WRYoxds2pDL9KA7iey9IBtFV12pU4CqvvtADUFN12AJW3fpSlwXBbu49dt0ZdJ/
	wgX2HYHi3j9vL7okwWAYWIkiWPbfoO4jj6NnWVviq1H97WQfRTNHIsLFV/zuYsBkMaZOhN
	f/7tVNS65NWFETbz9/J6Z343Rs7pqa8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-Y37kaKJAM1eLsH6nAfZsmg-1; Tue, 04 Aug 2026 10:34:26 -0400
X-MC-Unique: Y37kaKJAM1eLsH6nAfZsmg-1
X-Mimecast-MFC-AGG-ID: Y37kaKJAM1eLsH6nAfZsmg_1785854065
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955d314945so18084605e9.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854065; x=1786458865;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AkpbKoqkLE2ago1nKO8zeKKdehNgTrIPaOMhneanm5Q=;
        b=SakyKR3vrrHf/m0UzYm7SDZvKUWP8PNzzvbH7pJUgngk6QP70vvcyYBQ9v4CwUurQa
         hw2OCC1MFoHJSeEN/KSbEWgJe8sU2SkEG0ul8cVi5k6n1uNRdKaduDBxDwrR6ZMh+wvl
         pxEA11gaCsYe2ctLYjygl5017nHJ1cH864jeLUxshEp+Tjk2V857zCuQhk2OYbt1yR+g
         mTVR7XMOaxIcB3uYLI1j2FLbaXlMxHiLBbCscB/awNJ/6zGgq9O/BKRfaTRTX6p6ZlJU
         2UaXFqumUP4lIYyCO1UnVCSPDEZIPCkr59ZFlpVpro4a7cxF50fIYAPmjjAZdCIc5JMs
         ZaaA==
X-Forwarded-Encrypted: i=1; AHgh+RpTl5GfXwc4D96WKuC56rV/pT3i2FeJpZbZO9XH9/+GoDoxTDK8OhQ5vxq3Ob3ZSgy0fGQHLkf0OA==@kvack.org
X-Gm-Message-State: AOJu0Yy/xBb3vZsp5SLqEE/HvPlClA9z0Rhw3d3bwzMvEEaScwYNe18X
	AvtKR+HKo9pg9wh5sC4+ergcfHLcYabAPJSXNR8GIMyDv6wTtoStdPyF7bmvCQYhKMyPVJcAuaZ
	XeWFY0LfuV504S7bGgqi8H4CbBQ3Ymsr/tB28BDUD8OiOb8tLfMIfpaiPtacwxywLj4890R9hbs
	mkVrRBZAo27fjfXJA/RNzXPR2a104=
X-Gm-Gg: AR+sD103NqmkgYJaHsdujQUSUF7KXeH3Dqg3D6G6FPjV4xZfhEesRiC5WU8nmTU5IHr
	smLs45L/gsHc9A0u9BVga7JEqCo+nvodqnyF2IISihuWu2V27WDXk1q84L/sL5CPr7pBOI/4hDu
	mG0+AHHeKqiMTcJ+7OKLMXsP3cFkvRJMeyNW/UzPy9H8i6lfnmipvA+lcjBqipBcrwCa7Lzhlbi
	L6ohPYzaO1FX6v7F9IaFCpgPXTr8dZkrLFA1ThEqwoaKlAtADdYB+8FMWE=
X-Received: by 2002:a05:600c:4fc5:b0:494:6baa:ccef with SMTP id 5b1f17b1804b1-4980f23257cmr337369085e9.11.1785854064950;
        Tue, 04 Aug 2026 07:34:24 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc5:b0:494:6baa:ccef with SMTP id
 5b1f17b1804b1-4980f23257cmr337368035e9.11.1785854064514; Tue, 04 Aug 2026
 07:34:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <20260804120529.1730187-3-pbonzini@redhat.com>
 <20260804161549.4cd9a66f@fedora-21.home> <20260804161850.58c55c6e@fedora-21.home>
In-Reply-To: <20260804161850.58c55c6e@fedora-21.home>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Aug 2026 16:34:10 +0200
X-Gm-Features: AUfX_my1qzxj9_dJklyDF5G5un-IXavjOuTxcyczoqFAniCfVGichGNEROtCVP4
Message-ID: <CABgObfbAveuhkjXzmemvGtycmcmDePKABr8Q35Y9mZP0den5aA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Christian Koenig <christian.koenig@amd.com>, David Hildenbrand <david@kernel.org>, 
	dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, 
	Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez <slp@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ayMQt_SkPP-Vw9GA6wmoBfpAyzAd9SPIqmjvDmW-xBw_1785854065
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1F46A0003
X-Stat-Signature: yrynnze6gsq1c3yi3pmzg8jjjkn79b6a
X-Rspam-User: 
X-HE-Tag: 1785854069-556063
X-HE-Meta: U2FsdGVkX1/H3n9DVNhwE8agY7X7Gjyl/cD/aBZ+PU//U/WOgUFBGaeX//PsXPg4g6aujX6ykoJmQ5ok6KaZ/TO0sEByV0rZUpqwtdlsmS6qgZJ4cAgZCMz9CJmKJwO6QYlGKPzfCE+It1egUQOgo9/f43FzmEHU4kYN1ysVjI3zcv9Aipd5SETn3UI0AjpplWsP95UWGke+23ekbS8REqousfvIILNSOA03vQKKCaP4qpJnW+LGDYbilVVLW2lzY6DCqtV2bH+YYwqq8klEJF4/UghxCq3BvzYJhz7FzqiL+CAmbr8lTzrSjPx3cpzfiy+ps7noDFlYfZXRj0+LLIb/xSS3J9OvFVFwRfQx/oVpySke9kNjudoRiS3De7O5ykY9OVDR4QmYJrXBtuyj9U2k7FZpqPkYPfqhhikZek6h7Xb6uUjGhfa4kulJGLhOex7zo4VU5sZ7K3Lp8QLbsRjZQHhwJVbDq5SQ4D+AoYiSh4vO4hZGbYqZgq8QBJj884jGl93CZihGmwNLmksuvDyIoaaROpzpfX768D/LzqyyKYaZTEXfa9VhNroRwBMKY0GOYT/Q0o3xmReZb1WuEvSgVPpK/U7F1vMdLFVY0VNAEDKrA8cIoTnJjyPK1k21qLzUkZMvIQ8EsV2X+Nj+dBgGow8Oel7qnwgIgyx2IWwg328lPUIMdfpOy31ldT9L7/MonLex/C/RSLnIb3/Em6Ca+VBsVrPUv3683osUjVj7aZQh31d3g9qiYF2xp5TJh8b/iNIE9OxIlwqJhbLADkRHoyMRVgi3jHZzBtJ9ylI0fycK9lMEZokmnp4Rikx1rKdRLun9TwHSzc3tlFkOb+pw0EHjGxKqLI+Afay3A3NDWXlPIww1NwrsOq+gBaBHC7kzcsozvTrL8T+enfYRG53W3UpWE8RGSus3bNFHBCVs6luHVsJGXJCw6jS2FMsNs1+CXzdi2ydmxaVWkrP
 Rrld4xW6
 Z/Pr5dorhvlj87cKaAUT4ciQ9FgCqYAg/9Pk8qSwyTtgnaCP1PwWCmzGMRHMqq8kY/mobdkk4xV5+f0ug7TAXjSfD2Q0GBFYzaW+Mk/V1471KAE/pSl1fScnAZ9Juaf7N9lo7Wf4AJDj6Y564WfpOUGpuHq2IvONatRVrrS7k411srhCbUIKei2OtcyqR7uSd9eNzCrEyV71fuxnnLhP4cnP88qR2r43FphG3SLzPmQ0vsdSCGoyDW878+e9Re5RH6rmzR9/uzL20Zx8DRZXEFbrrREffdl3aX0QACL9qVa0mgl7Ow8fvr6e61/EtVzVv9QYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 4:19=E2=80=AFPM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
> On Tue, 4 Aug 2026 16:15:49 +0200
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > Actually, if we're making the drm_gem_shmem_record_mkwrite() call
> > unconditional (for PTE and PMD updates) in that path, can't we drop the
> > drm_gem_shmem_pfn_mkwrite() call living in drm_gem_shmem_pfn_mkwrite()?
> >
> > Also, I'm not even sure we can end up with write=3Dtrue for PTE updates=
,
> > because our pfn_mkwrite implementation returns zero, not VM_FAULT_ERROR
> > or VM_FAULT_NOPAGE. This means the default RO -> RW PTE upgrade
> > implemented in finish_mkwrite_fault() [1] will take place. If we really
> > want out try_insert_pfn() to be called for those RO -> RW updgrades, we
> > need to call try_insert_pfn() from drm_gem_shmem_pfn_mkwrite().
>
> Nevermind, it's all explained in the comment you've added. Sorry for
> the noise. I keep wondering if we shouldn't call try_insert_pfn() from
> pfn_mkwrite() though, like is done in other places.

No, the .pfn_mkwrite() callback is invoked when a PTE already exists,
and mm/ already takes care of making it writable. So there's nothing
to insert, you just have to take note which you do with
drm_gem_shmem_record_mkwrite().

Paolo


