Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E8ECAC5AC
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 02:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687B88E0007; Tue, 23 Sep 2025 22:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EA78E0001; Tue, 23 Sep 2025 22:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574428E0007; Tue, 23 Sep 2025 22:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0098E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:35:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B781B13B5ED
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:35:15 +0000 (UTC)
X-FDA: 83922576990.03.46F1BD2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id C96D51C0006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:35:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZHQFiypz;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758681314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8pUVu7ebrm0X4wJheoYfCWuw4PuHNLvghKI3Pai2MA=;
	b=UoMx7gU6wjIYW8CDq7Vcni0iEcfKRsQiLnLtjdk1sRKOyO4uj+AxRfgi+uMClmYSD4IEmQ
	oF/gosQbYiyjfwq/gdW88upcJUlr9407O6LUZXrFPh6VTg0sI0XLigpF27Rk245F3ybpFe
	GxKLKQ8VUkycHJ8zvUUwEzj08cQ/FlM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758681314; a=rsa-sha256;
	cv=none;
	b=1y1JOASGPsGhIrd+rbkY6uneZ2vl42h59b0ClGnk+RI8pmvnUKAh+2/A92PiTlKlDwHmUx
	C1nBOwJffChh+VZD2jhRTI+KU3BLlfePpznuRG00khNdovoTTMJmUrqLxvgJH8zMxONj3E
	LD3L4zo6BWuWmM+DCOgH1BPbBOzrGMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZHQFiypz;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758681313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r8pUVu7ebrm0X4wJheoYfCWuw4PuHNLvghKI3Pai2MA=;
	b=ZHQFiypz6QRpCuNpKx3PvVK/yXKnjgy0IYqI0n+GEFES0Inh+d3nAm7PZ2u+3jenYBpVku
	s2JwPBQhjEWFFgKt/8xo6q1RoNVRQVyyOrmZBoOhXHh3JPY1GAXOWZXvtoGUz6nSNkQoBX
	bv4TQwSg9eZhi6iU19Uj53OlHo2voFs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-215-MVxsJoxEMu6l8sCFbwGk7g-1; Tue,
 23 Sep 2025 22:35:09 -0400
X-MC-Unique: MVxsJoxEMu6l8sCFbwGk7g-1
X-Mimecast-MFC-AGG-ID: MVxsJoxEMu6l8sCFbwGk7g_1758681307
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 006D61956096;
	Wed, 24 Sep 2025 02:35:07 +0000 (UTC)
Received: from localhost (unknown [10.72.112.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06F6B1800446;
	Wed, 24 Sep 2025 02:35:04 +0000 (UTC)
Date: Wed, 24 Sep 2025 10:35:00 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>, snovitoll@gmail.com
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, glider@google.com,
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org,
	vincenzo.frascino@arm.com, akpm@linux-foundation.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, sj@kernel.org,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv>
References: <20250820053459.164825-1-bhe@redhat.com>
 <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
 <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: gdtcjun4bzze7xobba73yxjsd781dc7q
X-Rspamd-Queue-Id: C96D51C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758681313-822073
X-HE-Meta: U2FsdGVkX1+5EEO5aAnZQxsE5eDzkTfNyfntrZE/3E/rr9xDM2Z4gf20PlLxzSg2clV1/k1uDynYurjzHdfTSLzSXTPL85mW/4d+Xr6UzxAhU2XI2evkzrXp3u8AZmswYYLaB9v4qLTCLQvb+cQSbd3XixYT2j5R0mb46P68YcwY/8saYMEKzRMJdwAomTapaBPNVuaBZnQUmT9GZ9xeg8of5YKUf50+v+r28WVwPoGyI1T1K7nNp6ADz90R4RJcG9wVim3ThAgaBnFmRMNbGbPadFAA9Vb90YBeEPJ0ZMaUzpcw68pLsKbEJi8dQKjagCBDhXYd6McHY5YQuwnGwgLy1XGmIxZ7yIwkRegrTUYGCzEGZOPmgYeraX8Y8nuDj8VDpzq3hYRA4L9uOHElQm3y1Z4QCOxMMa7aQyWi/cwAaZL/NETEs4wt5oyEhkat7BvZbjNMFkpyO7c1UHTtvRWLSUOIvIevRsabvXiVHG2JQDI+uiU3eYwK3fAw8Wvcqyu0hgnvC+po/M4v2cscyZZ8MvWu+4ckjmMkqefdjwgQH+WwdDfHs99G2aD0oU4eMRjulgJZ3cYyXI9OC27lkNwofeWeBUz5OzawoeN5GUdqZu9BA1PKQXRgRbj+sNa1F/bqXHw6zFFZdmvQvWPtAitLmb2PuT0zKbSdZDICRa1oH7xYIjEXzJQbZZxvIaT11LshxnRIMkBO+NIXHeYzdkzOfP8IM6NdCMmj7R8ZCJZLyvXJZWEhaXaBawdoyiA9QcsXKo4Ty21rDLjuzz6K7YsYSBEUxjNEsd5KwCCsWXammOPG5NNa9dUPgTP0N1VaGUYZntRN8T4rLPQwMnbkeKCLggnB+qjcNTmwB1I5Whka5iNlLY5RLmW06B0zVhMHO+f8UNy1a+BD4K3ZYC8yDCyQBO71FtdtaFKwMVM2IkmcdgQQ5ObKVL8TYoIj9DRmY58cFc44HuzEpzZsUl2
 OMNZ4SfR
 LGc0xh4lx3TKzF9loeAFoClPeWpkAmnCIg84ewxUbCTVxPcGG6KpYZWfCMe1TdMNCslgcrxy0jMCpwh6exi/lMW1Qy0B5mpsE8mutpCM7qliD9KJdSOarkpDAVFS0tX+k8AwwZPUPhjTmTK6iPXB/CSLt6+CaIgWIyHqCTANNn03MU+dc446FxPm14hfblhhqOdiec1I8lcE5WiMuA/zmqMbEQmC1+0rjR8CRCLqIl9NzRKIYx584wWj/23ZI3FocU1mkqorJjh91//ICbUz/P4FnqR1lSrt1PpoHnR+CrvRF8I48pbeBPlMio+X0DAKJ2bKL/sbcjTNopI4yP4hQEXMFa2yE3Q15sb9ipbl1tck8oyrSsrJaF5USFszqlb0CgD56xese3E+5R18hXNrC0O4fCAS4WZn8I/fxal654nS43Z5dgi8GUe9ZkDyoQ+Bhn6duIpMt0zZuAZjhbovfdbOaagPs2wExndDRaJMgNp5pHLH+tp7gHEj2kpkmFxYQfQW4pGEnfR+hwZXs4Li1uIqbQTYa+FtABfbzzG1DUckIOVk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/23/25 at 07:49pm, Andrey Konovalov wrote:
> On Mon, Sep 15, 2025 at 11:05 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > > If you feel strongly that the ~1/8th RAM overhead (coming from the
> > > physmap shadow and the slab redzones) is still unacceptable for your
> > > use case (noting that the performance overhead (and the constant
> > > silent detection of false-positive bugs) would still be there), I
> > > think you can proceed with your series (unless someone else is
> > > against).
> >
> > Yeah, that would be great if we can also avoid any not needed memory
> > consumption for kdump.
> 
> Ack. Let's add support for kasan=off then.

Thanks.
> 
> But please describe it in detail in the KASAN documentation.

Will do in next round.

> 
> [...]
> 
> > When I made patch and posted, I didn't see Sabyrzhan's patches because I
> > usually don't go through mm mailing list. If I saw his patch earlier, I
> > would have suggested him to solve this at the same time.
> >
> > About Sabyrzhan's patch sereis, I have picked up part of his patches and
> > credit the author to Sabyrzhan in below patchset.
> >
> > [PATCH 0/4] mm/kasan: remove kasan_arch_is_ready()
> > https://lore.kernel.org/all/20250812130933.71593-1-bhe@redhat.com/T/#u
> >
> > About reposting of this series, do you think which one is preferred:
> >
> > 1) Firstly merge Sabyrzhan's patch series, I reverted them and apply for
> >    my patchset.
> >
> > 2) Credit the author of patch 1,2,3 of this patch series to Sabyrzhan
> >    too as below, because Sabyrzhan do the unification of the static keys
> >    usage and the KASAN initialization calls earlier:
> 
> Since the Sabyrzhan's patches are already in mm-stable (and I assume
> will be merged during the next merge window), just rebase your changes
> on top.

That's fine, I will rebase.

> 
> But also note that Sabyrzhan is planning to move out the
> kasan_enabled() checks into include/linux/kasan.h (which is a clean-up
> I would have also asked you to do with the kasan=off patches), so
> maybe you should sync up with him wrt these changes.

Hi Sabyrzhan,

What's your thought? You want to do the cleanup after my rebasing on
your merged patches or you prefer to do it ahead of time? Please let me
know so that I can adjust my posting accordingly. Thanks.

Thanks
Baoquan


