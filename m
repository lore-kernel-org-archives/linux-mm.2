Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E480DC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BFE6B007B; Mon, 10 Aug 2026 06:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15FC6B0095; Mon, 10 Aug 2026 06:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE126B0096; Mon, 10 Aug 2026 06:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADF66B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:05:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB3991406B1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:05:14 +0000 (UTC)
X-FDA: 85084926948.22.07D72C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E55B100006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:05:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JpRiZOSv;
	spf=pass (imf14.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786356312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTE9q723VNHgSKbOmtVFOArX1damMhZ8BQEArvWAKkE=;
	b=uFeLBwykYPt8lyrX+p19I81/A8b/8PXYknTaUx6Co3rrJf/NA1vPKOE4+8YYC29i6WqUh2
	aaHbc5IHA0/mTOkJQCqEJ/ni7XklmyrYsk7Tr++vlNeRPCUshpAInZAyEqWSX18Iv67WX2
	aiNBytsZhLQDtz1WjrSJirGmMbNiRiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786356312;
	b=XLGBnHb32vswlXlULDu3aJo6dUTvpzCWg6Ze45oXFMIrf9P63QsVhKq3RlG6jf/IjeajA+
	KAVFk5Mln+CgVeRQsE5xk2VL7lQgco1mN5vYx85mlB58ghs3fIBuEcuJgV8um97+l1h6wk
	Gj8fagRLbJ1WlSFYZT9nZk/0clneHqo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JpRiZOSv;
	spf=pass (imf14.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786356312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KTE9q723VNHgSKbOmtVFOArX1damMhZ8BQEArvWAKkE=;
	b=JpRiZOSv4tw8Wa54m7BrbPEkIx4lOYYSdyb9V/0Uj06Zdh+k9Cs4LU6rS18Gt2eGC3nNOb
	Eeuoj7kEapzqC3YYows6hnSRpLsaYoTHkPwpjReMNIZ7Eyv7N43Wny8PIweIIjamUr39VF
	xdTPaV8WFph+GalGJhpKFlyZHSzXmGU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-_Hf7CNNANAmTF1fhDo_M0A-1; Mon, 10 Aug 2026 06:05:10 -0400
X-MC-Unique: _Hf7CNNANAmTF1fhDo_M0A-1
X-Mimecast-MFC-AGG-ID: _Hf7CNNANAmTF1fhDo_M0A_1786356309
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495529a93f9so18777945e9.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786356309; x=1786961109;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KTE9q723VNHgSKbOmtVFOArX1damMhZ8BQEArvWAKkE=;
        b=PfBtkmu2l/m2F89kW+B1BycUiA/Bnxiin1I2IStGJErbkmAQKAVBNqmcz0LaDnIN2j
         aBKfY4qx/qsY5XSgb6cVcEVNKJrhvJ9OXxLR+A+AJZcLzVXru19o9OnmtkNNKokVD2Fg
         VrV2b4wExLHYlQKaYv3Me0rCwwostnIUf8KysqJGcgp/HreN9QGWvVyjlR+JIsARQ3PV
         MMc1GuofVsC06oWo8KRqjmdwaN89n0dD55KHYxjEBYLnSy2IGZ/XQsYVr/YgWOWJ9nZF
         l0C8UE5zk1iu+A1oJ58VSqVbX3RRN+ACzw695jlNSS4LsHavjdZF2Q7T3K9MsqxMcXzF
         HRLA==
X-Forwarded-Encrypted: i=1; AHgh+RodcHv47uFlI8JTnlbKBCesTSuR3AY6JLzGu3k6ajCl8em90CS9yAg8jDMzwuPBMmrDEKpRDccw3Q==@kvack.org
X-Gm-Message-State: AOJu0YwCV7PBXhHX7gQ5UR97iR5j7vw7IEB9fK/sEbMNdqIOPoVBIEEB
	1ZZwYinrtHFz0qmXssCzAHez7XCSzXdqEV12YmXlyjBz7wovec4p2J6pOnqC6XQPAkr8W625Wsg
	fUKi6uJPcqBTYeDQAbQ6h14nrOEPjtt1pJ6RGPUAkS8/R7YJxx0oCCzPAKstfRo2hq4P3HjBcaD
	rJ75bY4S6diCvZyxt0gkrBKUtgEEA=
X-Gm-Gg: AR+sD10rO8kmV1ZDhV2qHYuI2Oc8MzfFl0lg42AN6uev2cPmf0T0RxMedOf8Bz30AxJ
	lwu1LbfnvycuTFVNeJKBoa9KeUfA9Kqbfcj1+nmlO2UrYSzJddmlehHqtvWghEtpAMZ9EGsgrEl
	QawGuHLjQDsGbRylRAPtqfKCzkCpJc0iGJNGQaU4CuqIjqlhRx5KDQXxz9l2DUaC0fcjwB7Pck0
	cLw2INOeYYvMpAvWqBuawopGPiehJbQu3j3nJ21UiTEmsPlGGEFmxWkVW4=
X-Received: by 2002:a05:600c:3226:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-499727a3b84mr5344375e9.13.1786356309308;
        Mon, 10 Aug 2026 03:05:09 -0700 (PDT)
X-Received: by 2002:a05:600c:3226:b0:490:e5c1:b8bf with SMTP id
 5b1f17b1804b1-499727a3b84mr5343835e9.13.1786356308812; Mon, 10 Aug 2026
 03:05:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <20260804120529.1730187-4-pbonzini@redhat.com>
 <49840a84-6d73-4a15-adae-800eccfb1c7d@amd.com>
In-Reply-To: <49840a84-6d73-4a15-adae-800eccfb1c7d@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 10 Aug 2026 12:04:48 +0200
X-Gm-Features: AUfX_my6VzuSeHJgh3uVKaTYyn_VnWzP5xLi-qQ5sWEuv-5l4TAmINZeor_-704
Message-ID: <CABgObfYvz_SrBBXmzJfiW0VsQyRa8OWQdP7myfY=WAws63oguw@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] drm/ttm, drm/vmwgfx: directly create writable PTEs
 when mkwrite is in use
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Boris Brezillon <boris.brezillon@collabora.com>, David Hildenbrand <david@kernel.org>, 
	dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, 
	Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez <slp@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E3vaHgNsJQi2eerdoz0lQpFro2qXx-ms-GLjvvnLn-8_1786356309
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E55B100006
X-Rspam-User: 
X-Stat-Signature: w58spq59gz9w7thn9s1i8ipz8zrpgndr
X-HE-Tag: 1786356312-64872
X-HE-Meta: U2FsdGVkX1/2Zrt4dr9kIUYFaUiSW0qPgbXTnJYC4dr8z2PWQMUPfsVuWO3zlFFf7WGhoLZGkgzx/4FtgQcAi2csfOBX2IHftNOW584JC4HIxV4733CuWVhzjFmiGYYonnHTmXM9XrOYAh92RAFfG+95YQ9p4e3CeIeLc2yw6wHSFmVy9DMmhodw3KClSM9KufTK9RGOqz/fBBT6lRt5mTtbIFuKGaj8+l19WQEed9SzmR9auro38C2dALAMnLc8YvYjSE4TPmRLB3IDXpgIb8H+gK0fDpK2bl6qZoI7CHrWQm0lq8nTGf7Kvj1DUsT9IcaK9kFQ++F6fMI0Mgj0s8MIliZ+zxh+0Evb7CCd187s0lHOMrNIYF+IFcZ1/wgjgCAQyT5iAv2yPqqNOob3zZAsa+0PJnL9qzXoDJeN5Fq/doEfaofeLbhG5TstMfJXjAv7VaN9sJcBz/V/GQluMQnjlLFaXXJtgtAVzDRWjOIfrsZijsmlGkj2uko5018aPRhuDps7w9+y51cW04xZe0JB9cTboasbUyO7G2EhVm4w6ezMUrTpUa4TdzeeJA0cU9Y1NTq8vmcJi/pxVLgHjEZDZXNU7M5scy3YJFoSWYhVBxQ7SLMcVz9xTRl8jZAFFnTYUY6wGygr7Bf5Wof53+AXdjx/OCjsb+LD5ny+hx6gqW0DxxfilzLweDEAB9O50V60/IlvP+hFJ2+bAxAogHyos15aNQphshoH3skt/0LdNkVxsNGB+T8WOp1H0ZgbiUh7AzjWccwjxTEiXV9TP+7zEffnQm4xLbLJel3XdFH6e0BxFh0uKOQ7Dg8qkbn6em0V5OjlqMwjbS39enrW3yqiKL75Tfm/fIyfx/ScGlcBkBO7PIHfCm+rQFyJ3Ul+9JW8FvolCTPTfZgSzUxY6UEtF4G9BAvGeo5xAD4fysC9rvkHhqQ+11rUXr8OTDRY9tO0NlIdo4C1U4rtubT
 +37RfgjJ
 fdolnXbdPXguquN2iAKT9ddo5MtbKFoVRiDKK3mD91qVSF9iictEiAbXgqB9Bs4TNDABWYDcFSOKfRpAlaQ+r/9toWj4Il7VIPZn1NFFt1kL5c4zPem/zc3IDLTz6C3LMWjhaHzdwazWg7XjUycWauJO10obcoM0OsWIgOaMD8RVsDvi+H1jj1bbBZJNa+yYptlToS7+A4KOLiDpFMcvgZo20qroR6Ng5XoaRnD4GV5gLZ7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 12:01=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
>
> > -             /* Never error on prefaulted PTEs */
> > +             /* Never error on prefaulted PTEs and never map them writ=
able */
> > +             mkwrite =3D false;
>
> As far as I can see that is a really bad idea, we do want the prefaulted =
PTEs writeable.
>
> The whole prefaulting is essentially an optimization for cases where taki=
ng a fault has massively overhead (virtualization for example).
>
> Wasn't vmf_insert_pfn_prot() making them writeable before?

In general yes and they still will be, but not if pfn_mkwrite was used
(as in the vmwgfx driver). I'll change the comment to "never force
them to be writable". Setting mkwrite to false is exactly the same
behavior as before, setting it to true is a superset.

Paolo


