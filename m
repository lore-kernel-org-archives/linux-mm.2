Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC514D3515E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E0D6B0005; Wed,  1 Apr 2026 04:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5956B0088; Wed,  1 Apr 2026 04:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BC26B0089; Wed,  1 Apr 2026 04:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 320AA6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:44:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF3EBBA8F0
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:44:42 +0000 (UTC)
X-FDA: 84609351204.11.3163D33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8E485120007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:44:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzbTWXiN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775033080; a=rsa-sha256;
	cv=none;
	b=ywWQobFK2w5ugGfUKG5L3lAuQBGPH7Og+F25I54vl+qcDi98PZm3D9KFI5Pz0XymihVUoA
	sR31WlSMaFDls60GjLYyHDs4E3Vx1YnvFdsxLKMVZcBVlCHAPslOhMozj6IG+bMZ4VjJzo
	GybS2FUnB1JMIlaWQA3GlhPGNUELbPA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzbTWXiN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775033080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VTKemEY4CMnXuTlNCjNoZ777F7zIOeMz1S1dcBfefw=;
	b=32LxzT6d80esG5SvQnUyGWbU7Pk+oBo+YqZtJ1GVgArx3QiYM6TggZS6msF7C6cJjhJ4s3
	Zy/OIre/nbptQjDNS+tsPdO9rXJ4k0C9JYzZaywnznTUVa8CN+0wS5FnGBtCqjlTwaI8k5
	RC2sGjv1IsT09DSQlPCboiEzvh7qzjA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775033079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7VTKemEY4CMnXuTlNCjNoZ777F7zIOeMz1S1dcBfefw=;
	b=LzbTWXiNNe3zBFNo9PYeZJR7xCs+fnAV2VfcxL1FaX/zoFzXY4z9W88OJZPxIvrAxFqvvA
	HJ0PUmsyEZry/slRqf2vgHrjv/ACNkhxsHCPb4sMj+j37bmcOHk9VoPobL36zliZp1kACF
	8S6ldPWeXKAi8uqkO9JNRFgeeXgQ6IY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-4LCD-ptHNjSEexn1x5y1MQ-1; Wed, 01 Apr 2026 04:44:38 -0400
X-MC-Unique: 4LCD-ptHNjSEexn1x5y1MQ-1
X-Mimecast-MFC-AGG-ID: 4LCD-ptHNjSEexn1x5y1MQ_1775033078
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82c6929bd26so10814917b3a.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775033077; x=1775637877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VTKemEY4CMnXuTlNCjNoZ777F7zIOeMz1S1dcBfefw=;
        b=ROxgsgCEbTaTp6eAmlUVE7d/elJ8/Hb5xbWXAyohughNOdbp5YYNMv4ju996kFPRwC
         SMPYYYjA2E33iUT8l43iWifrHHYqHAdBvPo1m+pYtk0l2pxNuNpMpsPhsyFLVgqJYtDB
         5tZZQaWyC+l6jwTkVT01OMFnerppl8M9lU7tk+rJD2ojd/6kCnppDRdF3PeGWnTfzddS
         pQUysxq1zV6ilLpQEocW3FBGKFMqvWmP+5fENkJvExN1pLvmpjzQ0Ut57A7dcY+2gsS2
         DJAg5+pvF0yrpipEeuZ4huFKj6+5Gz52qRBo+NMK8t5jkaVV1JefGmdKftzk1ZKXMJoG
         RTFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiXGIpsc3QijeaLE8uaYlLuj7PxDAzwcARRGZHpyo7ghDug2zdqpW/tUfpd5Ri9uV7YDmaE20/pA==@kvack.org
X-Gm-Message-State: AOJu0YzQ/tH+py6BsHri6+A1d6GmAw3EuqeVBizqmMnvcYYsFaJZ3sL2
	7Ykld3Mmsz7KIaaxgF2akCMAS9pPjLiWZkZBLuubt5J60mXNe1AOEP0u29cjEL0qpFbXJ++m79T
	/Ux9hfnNAmKVqBMdQU9oMAu256r0/Wq4nHu+TYyV6EL4XQrSaGHwx
X-Gm-Gg: ATEYQzzerKyvOomeF2JNdX7sImJnAWIE8IDkNGzfSYmPXvMwAL4/M7S2vqfY4lxnE8C
	KjkvzkxDVbNHEKzhTDRgVQKFomZGAW4H62T2aaXsKtl5w8lKdC3RxZDMUDXtyXJfyvgu1mtoj+5
	8Nem3tEoTtgkT9zgH2jmm7G9kIxTf7fz8/Ndo6pVCuWCNjrYWa3NQROpwLHvikXiErBrvjk+3e7
	2ZYK6bQWlo3RvEDC7JqrTwWl4sSx2CnC9V8jThEP9MmtjYYtCI9v5KJRoXU9OmxXNyw6qJ3VZEx
	5ebNlLl7gWpY1ZUGDkcnjv+yeeNholAPsLaYsg2989CJcBSNHkejxyyEt0PKmh09QlTfGZTdMqy
	3BwF0zNTmY7ByL66hPA==
X-Received: by 2002:a05:6a00:3d47:b0:82c:217c:98ca with SMTP id d2e1a72fcca58-82ce88f50ecmr2952036b3a.12.1775033077486;
        Wed, 01 Apr 2026 01:44:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:3d47:b0:82c:217c:98ca with SMTP id d2e1a72fcca58-82ce88f50ecmr2952007b3a.12.1775033076966;
        Wed, 01 Apr 2026 01:44:36 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8465746sm14068621b3a.21.2026.04.01.01.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 01:44:35 -0700 (PDT)
Date: Wed, 1 Apr 2026 16:44:32 +0800
From: Li Wang <liwang@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acza8JhtGD6sE3N9@redhat.com>
References: <20260330125307.98581-1-liwang@redhat.com>
 <96d14f27-ca0f-413d-8b61-768933ee70ba@kernel.org>
 <acxpVd5hQUuGPQCF@redhat.com>
 <b9625c60-2b1a-4890-a703-49e31aaaa168@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b9625c60-2b1a-4890-a703-49e31aaaa168@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ErUe_PHUJYHvwne5w4tpND8pozaZ2Jwj3X4AmjYlMYs_1775033078
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: gnmp1fbafd9zbproi3kefbhhegz8ntdg
X-Rspamd-Queue-Id: 8E485120007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775033080-396370
X-HE-Meta: U2FsdGVkX19PnBKtykBat7w0GmlRXG4Q/wVTyKMqrx/TiDxI23MFDtRJSXloSs+umz03WRbbrmOsxNjNk+0c/iCpWVSSZT2nSJZwtJU06C76Tsayk5BlNsVgJQB31ystxkdHa+oHa775rUEHrg6LKep1k9nOsQyvSQiSIkCXf3ClqNEbL8v+TSqkW6TyNuGu/7jUKtUOyRPb6r/bXTIh5SmB//PC/QKoq4OXAby21hWByaE032H7mKy/035dZVRIT8CSS9smNitdELdl7ndvHYABxeM6TnitSG1LiGxUtlzXq4yr/zaNdLe6OoQjijpVy2lcZU4cOIZcQ9Q2Aaz9n0jAsG5hqo9iWVi92gPeIwUBES1ZrHruyraEqSL4kJXYTJHO5gqMN6352v0zzSJA8lv0B9rW+3JCV50XOzaHnHZ0RUqNkZySwDRBpCRSAKEOBMJ6psTBvxMjcP8rs0Kzr+rBIeADQhbZQUZLtED1zgYRyt8jrIMQ0/xkVTWVez21Q/bOvuU0hNQdbbLBwBK4RnpPM7G4/ztYNYdienlXWq2EOwfNMkKt3dXvCB9vVa196ibwTxsKLzF8Z4n5srfT6X7PK2QtM3SP7Cdct3ibRmOff3Uv7gyVrFqZ3jmNwXY01G3Fdm/aMNTjsEJWKvI/w3ZrzmhPEfGPzy16fZBYM7XXTcP5PguAkPu0Hz3Zr8M2Oo0bmUYGNGFoCo7cWvbiMxea7kmffux5GKCdS20x5aCIE1MHeKJZn8UWbFKbZCfEEEyye8k8yoHqU1IdLs2rm5H89kJJ4+vmqXH/IjuJC75ClskI/Cwy1Zo/neC4Q1dAA+xQ6ch0s+u08JMTIPNG3BETUSE3nsHdxpKRCXgz66U7FH9anHy52jtm33BJ3upJatFj9f/kjvDF1YLKbBRJ+UdGF21s0CeXyqLENhMnOZ7K78yMQ7mGB5QOebuRqQwf4MLGYekuB0V3zrFUGe6
 SeH7LNNh
 AVcaMBtrNwnQY9SOi1nBaGpA9r6dJWerwEszTO7H+9LAJqt45mnqnPAeIonmSZRQN0sxlrC2l41DKI58D7Ky/KkpfKDFIGjrsimTSseCz1nba1Nh4B/p/oa4Ek+d+huDZ3ndSS6Jrz1mzSeOXjRfn5elBce+hMWlrjVREP1YhQ5quC/UGEYqQ+vOcEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:34:40AM +0200, David Hildenbrand (Arm) wrote:
> On 4/1/26 02:39, Li Wang wrote:
> >>> +static void run_test(int fd, unsigned int start_off,
> >>> +		     unsigned int end_off, unsigned int align)
> >>
> >> Nit: prefer to-tab alignment in MM land.
> > 
> > Yes, I noticed Andrew (thanks!) corrected it and added to -mm mm-new branch.
> > 
> >>> +{
> >>> +	if (!check_dio_alignment(start_off, end_off, align))
> >>> +		return;
> >>
> >> Is there a reason we just perform that at the beginning of
> >> run_dio_using_hugetlb(), avoiding run_test() entirely?
> > 
> > That will make the run_dio_using_hugetlb() have too many args and
> > uncomfortable to read, yes, it's more likely personal preference.
> 
> Nah, just squash it. There is no need for this separate function, really.

Okay, let me do it in patch v5.

-- 
Regards,
Li Wang


