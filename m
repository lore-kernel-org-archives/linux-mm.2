Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E7FEB362F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 17:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394C26B00A4; Tue,  3 Mar 2026 12:43:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3429C6B00A5; Tue,  3 Mar 2026 12:43:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241996B00A7; Tue,  3 Mar 2026 12:43:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 133EC6B00A4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:43:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7A481A02AC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:43:05 +0000 (UTC)
X-FDA: 84505472730.18.F994E0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 669A840014
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:43:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AmmOc0AS;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772559783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXyJq2jhL63XCeCGf/kk+0S1SsVNcL/cSZ0UgVWv13U=;
	b=YAZUeOxf5QuMh2QXuvftZLcR5ApEppvCg3Vd2X2o8XO8+mz6RsWmD/EPZE9eDzk85HX9jd
	4m7Ejz9lXo5rfkbV0tERjty7KYtrN7U0Y/mLqkyJoHxob4AcZ+rXFxYJnmc0NcwLT/jJ5G
	q6UpBrrubB1QeY4Tj619f3s8B2+cVzc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AmmOc0AS;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772559783; a=rsa-sha256;
	cv=none;
	b=e2fdGTfCAkT6KZ2qi1TZYWiaa37S+qhhpFYwKBMeP9gGRsPoALHvhcS4ryo7sac8PYykFj
	afNb8qajhL2/mpccqExvQR/GVIjr7nTMme10NGgiEP6ZB44NM9IYDUpAgE5+y3iAK3Q5qn
	fqaxyL+5rnJ0SIjvR5TfB8fHtPYMYL4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772559782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DXyJq2jhL63XCeCGf/kk+0S1SsVNcL/cSZ0UgVWv13U=;
	b=AmmOc0ASHu3IL8AxnBmapiwFNGgP3QdktMUR/RMHNJHpX5UOnm5zqjdPXfgBqj9ygOnnGd
	q96mk4cZrWQCvRB7jmpDrKKeJbvv1S7w9pmm5AtQarIOQ+MPCXE3Ys7sRlbENCxogqDH7E
	ay2dJ/hz7+Ulxc68QqoWIeoLoKlO3mI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-5kH51iTuN8mTrUDwkyz27A-1; Tue, 03 Mar 2026 12:43:00 -0500
X-MC-Unique: 5kH51iTuN8mTrUDwkyz27A-1
X-Mimecast-MFC-AGG-ID: 5kH51iTuN8mTrUDwkyz27A_1772559779
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439ba9b08dcso1659104f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 09:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772559779; x=1773164579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXyJq2jhL63XCeCGf/kk+0S1SsVNcL/cSZ0UgVWv13U=;
        b=KM6Mj9gRaT5q9hPgGLsKeqK7r8ZK/spuCyrk6fsSEjDlOHIkf0GAtI8phZI0HdKw+b
         of2SlGx1NfJU76PRXxB6IZBiGAW7kmBcgQcdODQMPsV1sXeQaiY23nNuBy6yEMZJ9sLi
         AQMY1DX4D3kGsTOqzI8e2RgnuK3HlFakgyhKgRpk96jm9PtxQfa5yDg57ji/EJ6tDPVr
         IAKerajOleKjPnJwY8fJGME3kT0/LLiW/8MVrOSTb0OOI5T8m3FyEBSDOXUxGxZ+Cki2
         Ff5HxQ57E+qUqGa2eKCbcHogF+oHYfPxAW7tLwnJH4tTCjUqRCHV7hkXGLuFUuMyg+By
         OWXg==
X-Forwarded-Encrypted: i=1; AJvYcCVvdq4QVKh7dOPHnZVsvX6rL2WWeOIifh0rT05ppRPkwNOxJORCiU06+FQXy9vi9siO+OiI/EBW0A==@kvack.org
X-Gm-Message-State: AOJu0YzCiKV5I00SctJtFRjUkZccsW4qegNxjBmKH3tKsp4TktgAOF0C
	2Acqj4nix3hzRTxygRCKwp/SigtWu9Ah8/qlNwPSTYvA2uGUpif3IVEjPVE5A1khib6riuDniry
	sbHeQHallv3zcYPEUk1/zhKG9FTEAqY6dCCNnDW98J9e5gZONAtXI
X-Gm-Gg: ATEYQzx0fh5ZxA/coJ1p7X3iKEArUGajfm+fiPlPKtJfByS8lKdnN7F01VV9okCDHwD
	hMZynYDX7F5tfArs2JQRWvRc38GUZFCBBYOI4R7ta7ptC1fiVOVr9Bo4khpPJqTmr58vLgW87Aa
	Tp9zlUovXmO0CJSBJrGaEXnX6If4m+G6eATkkt6cxsscXvYDfnc0lTWAysovupeUN7lKSX1vTuO
	P2q8o8ddQEpfobG6mp1NN1A1HV4vegyZvnn6PtzYXRZSw8sGMkvicKncNCwO5OUav2vtPScTRr8
	70pwV1ImXckbue48TAZRLY2Mamb49YVafgmtRV3yRKacYlcHHH8M9YliCKBW5Y8WiCmEVr99pMv
	RkODhkEUDNwzN6ohYonrJfN4cjGp5WziRFFeoUTwSNLVweQ==
X-Received: by 2002:a05:6000:2902:b0:439:b265:6c61 with SMTP id ffacd0b85a97d-439b2656dd5mr17084994f8f.12.1772559779091;
        Tue, 03 Mar 2026 09:42:59 -0800 (PST)
X-Received: by 2002:a05:6000:2902:b0:439:b265:6c61 with SMTP id ffacd0b85a97d-439b2656dd5mr17084962f8f.12.1772559778587;
        Tue, 03 Mar 2026 09:42:58 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ba2a5970sm13000276f8f.33.2026.03.03.09.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 09:42:58 -0800 (PST)
Date: Tue, 3 Mar 2026 12:42:54 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Cc: david@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
	wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] Allow order zero pages in page reporting
Message-ID: <20260303124236-mutt-send-email-mst@kernel.org>
References: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
In-Reply-To: <20260303113032.3008371-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q5WYwVYpggaC8G1bRSa0I9uqTCrSuSOiWr5VM9qsV-Q_1772559779
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 669A840014
X-Stat-Signature: dt9sdbnzuenab6euiyxr7a1u8cdnxwbd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772559783-605236
X-HE-Meta: U2FsdGVkX1/YAkQdVJUZnOJTTN9P4qsHsfi+wEXHIXJFlIdIa1Uqo4rgv9QZsHBco3f0sET3FSQXUJXbhHLduxka1ER7gw3z21Zna2wPZ745tF2zdcRP8cYQRblu7MEHiJ1cTIpdqPQx9B5hXuo8g2jLiHuA1ypWEuU9kUdksfCBSpJRDisY+wnNo0QtbypGMVVmAbW4eAjR5cABSNNPqjdi1YbdgsHqHLQ49YbRl/SBTI5lPio/GOMCVpNUBZYN56OPW0YPeRxY4/1YiRdjbJE0VzBtm/3xr0EUNZ5mWzW6qyg4HRR8DIkZaDk9qc+LZI1vOzrSlCQbSy+ZV0pFYFvv61dty91+YmdI8eRi0+B3zNE34gGtSMthjJjh9BLexNz7YKhm/l1ty687R9MYZFLzA3UicHku/0rDhMrWJaD7g1DhWTtm6RB20wpNcSvwaCql8SdzO3pwORGjg3gmEGK4OnbI4+51bSIAKnnALZ9RlR9k8Bzk7mIhjHuGNNeBwnGlgOR6zc4MSqpenRA9bMI0zirmXi1e5wJe9YXzrk5bFB/QvkOfIhqp+7VCUJqivxVPAKyEsF260mgq+GT2nQN5CjN5ytzvH5QvWE+oENZYWf2sVusO8r+bQKuE8OPGAGJX6Ly5lhxoeY1Q81z/FpZ26cjGsTWD8M0hD1mBWtVj9+8vrHeD1Z+mqxHhfqUbF09Q2Ijd0dSbmvPPwNMBS+c/858R9pa3BZdgiI2RiIXciQP/TCocAv31q1QR/ElugW5pXFUvhLKn3pDYUq76Patb1wmQO3FvNl9n/EiyPZH3ZXWajS0OKr+ZfMtiNT2oQD+oRFHLxWGWQhRUhCTEwwfltfSxdDDBhTc2taidXXBuwuRQvq2E+K44f8NBlYWZpWAwTud+l0M0Rq9AmjvF3IB2g3mobUzQWw+D6YfbDgGOYp8nGwVd2tpkPAmreD4mLMYwQGtGILlYCYpAPEg
 YpbPXFRs
 gPlFDMNNxzdZKs835ge8oNQAH3w038NJOehRAjc2JgluraaAQqBAjOSbxqIOApNnem/JtnNgc4UrjkqHQPoiP1JuImpLTNJmMfcyKa3kqVJ0/cf///530o7EdaL5VHxx6u5/Ei1H2U+68sDhh2Xa+2+RJk6/OZrXnqKDJX1SRCrKUEms7+/iMtO/C8mstjJO7lceysMUET0fK3Tqg1KXlweK15XRQMngcvvaNhiAWHIacozxUIMaZG572hyTI+ZibF+LAPWuKzSFlQZc6b0RtJldHsPZn3cEStmTgLJ/A1UQWiko5/EpSmcS5mv1VOfDQJpz6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 03:30:27AM -0800, Yuvraj Sakshith wrote:
> Today, page reporting sets page_reporting_order in two ways:
> 
> (1) page_reporting.page_reporting_order cmdline parameter
> (2) Driver can pass order while registering itself.
> 
> In both cases, order zero is ignored by free page reporting
> because it is used to set page_reporting_order to a default
> value, like MAX_PAGE_ORDER.
> 
> In some cases we might want page_reporting_order to be zero.
> 
> For instance, when virtio-balloon runs inside a guest with
> tiny memory (say, 16MB), it might not be able to find a order 1 page
> (or in the worst case order MAX_PAGE_ORDER page) after some uptime.
> Page reporting should be able to return order zero pages back for
> optimal memory relinquishment.
> 
> This patch changes the default fallback value from '0' to '-1' in
> all possible clients of free page reporting (hv_balloon and
> virtio-balloon) together with allowing '0' as a valid order in
> page_reporting_register().

virtio change is a technicality, so

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> Changes in v1:
> - Introduce PAGE_REPORTING_DEFAULT_ORDER macro (initially set to 0).
> - Make use of new macro in drivers (hv_balloon and virtio-balloon)
>         working with page reporting.
> - Change PAGE_REPORTING_DEFAULT_ORDER to -1 as zero is a valid
>         page order that can be requested.
> 
> Changes in v2:
> - Better naming. Replace PAGE_REPORTING_DEFAULT_ORDER with
>         PAGE_REPORTING_ORDER_UNSPECIFIED. This takes care of
>         the situation where page reporting order is not specified
>         in the commandline.
> - Minor commit message changes.
> 
> Changes in v3:
> - Setting page_reporting_order's initial value to
> 	PAGE_REPORTING_ORDER_UNSPECIFIED moved to
> 	PATCH #5.
> 
> Changes in v4:
> - Move PAGE_REPORTING_ORDER_UNSPECIFIED's usage with
> 	page_reporting_order to patch #5.
> 
> Yuvraj Sakshith (5):
>   mm/page_reporting: add PAGE_REPORTING_ORDER_UNSPECIFIED
>   virtio_balloon: set unspecified page reporting order
>   hv_balloon: set unspecified page reporting order
>   mm/page_reporting: change PAGE_REPORTING_ORDER_UNSPECIFIED to -1
>   mm/page_reporting: change page_reporting_order to
>     PAGE_REPORTING_ORDER_UNSPECIFIED
> 
>  drivers/hv/hv_balloon.c         | 2 +-
>  drivers/virtio/virtio_balloon.c | 2 ++
>  include/linux/page_reporting.h  | 1 +
>  mm/page_reporting.c             | 7 ++++---
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
> -- 
> 2.34.1


