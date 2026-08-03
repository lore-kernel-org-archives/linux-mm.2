Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67817C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2076B008A; Mon,  3 Aug 2026 03:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763346B0092; Mon,  3 Aug 2026 03:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651706B0093; Mon,  3 Aug 2026 03:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 452D76B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:30:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4553C4060E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:30:30 +0000 (UTC)
X-FDA: 85059135420.22.4AD414A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C278CC0005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:30:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AGJZ0+Xh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of slopezpa@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=slopezpa@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785742228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZHfgjHxp7rmkfsNqOH842ODn9NiNueK5c8Sz1y2gF0=;
	b=XVa2h9PpeChlcXqsqwo44lA8KlOm0CAylz2Z2bQmtr4UrjElSqT89fpVvT4pXnRoa/fMmz
	cVqFZqQgTCFtY010j5MtmWaN4PVB9sngIE4IteuJCN9IOCC9fYePpymt9Eocs+p3bTPtbu
	3Npmlq7JO2bR8m1WvUwUWEnoivpQ8ts=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AGJZ0+Xh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of slopezpa@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=slopezpa@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785742228;
	b=eJWK0QRC5TBYpO7+y0SHIQOnPfXcor9jc5YQCpNAW8JBuN+oYgi5TZGzDZNnrsFBvUiPKd
	JsykqIaTk0zH8GBjzbhtxYDnGBSmSch80095TZFLQZIQR5ZU52N4RZXGV4Jk1rAyDGUr4T
	019MZJMh7bzagylKivOC+6nXsbPpq+Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785742227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aZHfgjHxp7rmkfsNqOH842ODn9NiNueK5c8Sz1y2gF0=;
	b=AGJZ0+XhbjUJi9/e9lLwBK0D80lF8PMuQRBJ7LeCzlIkdEBJMLkiAREEf0SlOXhQG1XPkF
	Zvifc6j8V+hhvtyLGX0tjhmal/xDsgRxPEa3ZyPW5ApzUP3J1CZ77zk+SL/c9O+1MFX88f
	C9eA7UW4jYSHpndkb4K4uFW7fKsIJvs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-mBQIrhLUOv6Wg_zxHasuVw-1; Mon, 03 Aug 2026 03:30:24 -0400
X-MC-Unique: mBQIrhLUOv6Wg_zxHasuVw-1
X-Mimecast-MFC-AGG-ID: mBQIrhLUOv6Wg_zxHasuVw_1785742223
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-907a1e04111so39842036d6.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 00:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785742223; x=1786347023;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aZHfgjHxp7rmkfsNqOH842ODn9NiNueK5c8Sz1y2gF0=;
        b=bazvAzGoPAoSw4zu7TAgDM3fxrt42pML4/0Qaldj4rFO3KzYy6oo02VQldqWAd1M1p
         9DkiCJ/hjaQpzrNNxFCDRQMZsjkdFlLPa8d29+dP/W+qnMlGf6KJDjkrNPIRnNbgAE2k
         oAwFubD4aF1oRt054oWf3R4QQwSOcThhwCOcRIU7l/qiG9hfhX1QgtWoiwUCc5dW3tWo
         JtaS9dqQJqIy8+1xYcJr1369t/5sEwIXq2DixZirZgDim2rWqDt6I43vRvMM9Jw1l2+o
         UtOx/PsGyZ+HJQPbnGzxfNQxbdOmEwy+42AP7GRonZSeUC+uQfBMRqH1k/YHns2l4VpK
         R4hQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr25/nRV/53eU+Yjkjh5ODJ22FpB+IDlCl5eT74VLRGwtrdSamjzGjgC6psUcDKAVD9XLyh1MrZug==@kvack.org
X-Gm-Message-State: AOJu0YzQnWDAhFuEUJca/ascAyzqPcIVPrMA7yjgm8cg90jSEnQsd1EJ
	MT921MuITGvop4vuEt/9tfLSyCn9WVxaoC9MzZClF+IPsRD0/b8MmPe3ZIAc7peHCebHqaN5TSv
	RF3lP/5T04iKTPEMa+femStJn7XNM6hCJJd4/WxxXvccJGAuIiUSuAQFgHMsMc7l5f8V4wYtUkL
	1BaUMXNZCk9UC9/qxaWEnO1IBKQ3TU2+8SqiU=
X-Gm-Gg: AR+sD10Hu8474RQ7f+9hF01cmJpeg/LKtMU4fGQZfrVtYw4rNbv0M0tWfjfm4PBlPZJ
	+TraVUCBayj5EKKWyLiLUdUEOObyPx2ws+WZsrVD80TP/IIyNMSIDPHbwvNAoHpO6YVbXymldye
	SqfsBkothwyGD6himDEi0ZhlRwMmuoiv3aoOFVEEJuKLRH/g3kverPG2E=
X-Received: by 2002:a05:6214:84d4:b0:908:4a89:587 with SMTP id 6a1803df08f44-9084a8905acmr175819836d6.25.1785742223354;
        Mon, 03 Aug 2026 00:30:23 -0700 (PDT)
X-Received: by 2002:a05:6214:84d4:b0:908:4a89:587 with SMTP id
 6a1803df08f44-9084a8905acmr175818926d6.25.1785742222720; Mon, 03 Aug 2026
 00:30:22 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 3 Aug 2026 02:30:22 -0500
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 3 Aug 2026 02:30:22 -0500
From: Sergio Lopez Pascual <slp@redhat.com>
In-Reply-To: <20260731164341.1109827-1-pbonzini@redhat.com>
References: <20260731164341.1109827-1-pbonzini@redhat.com>
MIME-Version: 1.0
Date: Mon, 3 Aug 2026 02:30:22 -0500
X-Gm-Features: AUfX_mxqss-rUQV3mA_uJr2b_Y5VtnMHlbVczKQGwfQn5ZXTxPjmLx2yGIYEeRg
Message-ID: <CAAiTLFV-n3hdY3dUGSeEwfmAAgLE+tXBqZH2=eAU7EHiYorD+g@mail.gmail.com>
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
	bcm-kernel-feedback-list@broadcom.com, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C67tRKyU2j7vTG3ZMtz45slnI8lQu9kZ-1auo9dV-4A_1785742223
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C278CC0005
X-Rspam-User: 
X-Stat-Signature: apr6ord5zt7k6pq4rmau4rgnabhut6qa
X-HE-Tag: 1785742227-464056
X-HE-Meta: U2FsdGVkX19PPVKqP7JqAN5E9NEdnFjaSLlImVVM+grAmRWdYY0g5W7fDAvYAz6ipwPqUga+CcsfPZVNMpzheXlnoPOZWA/SXK+Y4/8mtyGNQSJrcpda7DogvBSJtjOQ4H6d3Ra0SWQJYIUN+4GRj+hCNOMnGbGg3GL+S4sbqjJfWZQ41E1o6RQlMTkgC39Ocb74qMGbVR6S2E9u3Vtlg2D3d21iF8YoGJKGNkyfR2gJdOJ5NMWAhjTwbJiAU/+UtmR/ZAqiDDGjzjPD+TXKGqhCHPOHd4VQb/t6YIBLG1UCoFPZMasRGuFh8xlM4kaPN/xHcHGdguf5DjfmUdmfwdyD7BArdw9sgYNxChkp7SuQx8QLOeiufWSkLRXMwJq1aoR92LvevvBB5XW6xacAvwiE/lTlW6L5peLYuZ//DNpbrv1i8Wj3yaDGdO98X01MNKQ3h9fM5Y24nzYVYshd1i7qtTe83WNqvkkFqp9aCQMc/SRsOXN8ywgIIxnnivS3QiY5Tvw3Erls/zL3xSpiJAGZL/t9m9EVn7BcC669ANjSVrs0+YUQvJPjg6kWfAzmEzghKlC9ZYA17hz+hcBR/xRdwn1behisGiCWSX4/o76+2fWBwPEytn0oD+O4dMUtsKuWI1zek8o9LX9CWJ18kzae15/lZEPHzAP9LQPPrWTB399Y551PmERXBI/BdJBqwVy+ygpsSi1jkYxWa5BCGnNyoy0a8Mdis9bfiwPw57KmfolA4swzSiC6lpUXGuEMVBYf9YcyfyYcmh1Yn3nfCZLCx+XL/mJ407U4GfxSWEvq222Zf7xiB/bylErei0UKvoUQd/dT+dRJ0qlOJ1nghWfskliktsGWFtxIvoPneKun0UkqWbhn8NUDUqagGMraoGlPHPcL4Uzwpkw3cV2FeNI3N0VcwTldWx+YCga763cwWeBMfr9iYeP8pQ9jlXJtVoWBbe/PKe2eS4T8hQb
 Mroy/HG/
 AszlFXv14AquW2vTIFU+VWdf+7pQ9ZqurACt0AINLr5rGp6mKj4sPBnFwBVWvA3DoDMERYvtKx0bOA/ZI9NXzC0u/wppzga646KnbhjNbCNdJfL3Ff6o/B6DZnFphnfRJ2R7yOyqfR6K46IKRbWyt0eewiMhZuFkNIYA3om+ebP1SRH6Mu0RbWPxxr974wabLuePwQkCs3/3WpAWcrew7UiZgVJPN+x9aiO5NzVjwclZ92JsuyVEJHDf5MdbuspL/bp26rt2mMC56zSjHsEDLGp2JPMi2ao0Ep7+QVWPnEVWNImFaZNSYPDhzxbqMfQMp8nZszUu5A16kIr90qcpEoeoEW1K+Upx2vCHpBm9FzjSsWaNbZ4Oe/lEiXIPFU5mt0sl6esmdkFDurCIl84v2wH+WKPVZQgko/bjJBCV4XeFcRlNYWgO74AhVFBVjeooiPxwjULnmzw3OR15GV0dfNm4C7Rbt6Em91De0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Paolo Bonzini <pbonzini@redhat.com> writes:

> Warning - DRM parts (i.e. most of the patches) untested; I have Cc'd
> the reporter to help with testing these patches.

Tested alongside with the mm fix [1], and it fixes the virtio-gpu
mapping issue [2] for both the absent PTE case and the pre-faulted
read-only PTE case.

Tested-by: Sergio Lopez <slp@redhat.com>

Thanks, Paolo.

[1] https://lore.kernel.org/kvm/CABgObfbkqYNsPQnKxK1_4adXF_tSdtScPU5-Xrg-sXyeWfMVfQ@mail.gmail.com/T/#t
[2] https://lore.kernel.org/kvm/299bddc0-fafc-48b3-a9c6-ec171136a46a@redhat.com/T/#t


