Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11673FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542C46B008C; Tue, 31 Mar 2026 05:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519DB6B0095; Tue, 31 Mar 2026 05:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4575F6B0096; Tue, 31 Mar 2026 05:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3830B6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:16:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D46DF1B9237
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:16:33 +0000 (UTC)
X-FDA: 84605802666.18.81E74AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73FE2160004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:16:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LSm6382N;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LSm6382N;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948591; a=rsa-sha256;
	cv=none;
	b=SAohXqBQVPOwBD8m3JUJ1ADt8OE+EwifGXY4aVjCdUE2cQ8y1io63a8SvU7Odb5U0+6Squ
	FmEKhyiDI6g0mN2poFUKJC7q0jkQ5oRIDZV5QpWQcXzkw7rvTrE94YeSUSr1JyaZ3bI3yP
	Crai5zi7aSD/qUjjV9nDbBDQC+GTTxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW7ru+MxIsYT4TWFYD0hCF8kOfP+CTkDbU7PkOx95xg=;
	b=LsLPM1+dwC92ftzXPgfyNoLp8H2tglmtPd1zKhiKls0ntR5cQknfUiNutRZ2ZjGUcnHcYB
	YDeIxzJq49XemT8YiK5pHyoZLvPbMWnWKId3nbBK+1WEMD+JI2r5D/ujcEBSLrSJqNBeMV
	qu9MDFN67pfaWpAcFzwNtMsxLMp+C80=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774948590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YW7ru+MxIsYT4TWFYD0hCF8kOfP+CTkDbU7PkOx95xg=;
	b=LSm6382NCxLik4rC7cX3+2WxXvJGXkQv+z20XXOamNXGqKZ2dAkeKtGp7jOnkTXfVHWijS
	1JXCL2BpLdpUAOSnapTiZs9Nvfw3jyOuQNdnnuwHfhzZV+I9Z4qFt4xz1bvrGM9LRT840d
	/P2KuRV+55jLOvjY2+TuWSKd/pKl740=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-FpFiayT_OfOo-w4F7-xW8A-1; Tue, 31 Mar 2026 05:16:28 -0400
X-MC-Unique: FpFiayT_OfOo-w4F7-xW8A-1
X-Mimecast-MFC-AGG-ID: FpFiayT_OfOo-w4F7-xW8A_1774948587
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354490889b6so11564383a91.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774948587; x=1775553387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YW7ru+MxIsYT4TWFYD0hCF8kOfP+CTkDbU7PkOx95xg=;
        b=N4jlPhGfQtY5BqaqMj/q/krBk1zhI/HlYVH6/Pzi0JBjHi7mojTvsXrzX1j30i3hdQ
         Hv0tJ8mFfC+IEk1tqwQwt4iBe3S6J2qhmYZUv7sRCLhdxSaZopIjDrIwy9zBznkN4LoF
         dt2X679sVRppw0TvRmQXnt2dp/Vc4FRVfLNDhYXoceciZAKh8vQrA71ys8h1GLD8MCK+
         2cXSxsu/2pn402Y2nNDGtzMGb0mQE0jZdPGb1E1bXDNjS1TCDGRmR2PqZ69M+rNzWZji
         fX2gRzBJskZL81hfrT14yL95osFKgS+FqhwkSe6uaDn4s/B6qVUA/hBNV2pTrqUHU4/e
         1Img==
X-Forwarded-Encrypted: i=1; AJvYcCXG6919YgcOS3ZCck27SL388SLO9pld6kd/Yyl+ZLCJTq7rS/oNs5DaARoqvFT20ATI9HhCoVUPgw==@kvack.org
X-Gm-Message-State: AOJu0Yw3w54K+/ElNLpfJMwTUhxjK18bZ9Fj3svuVwudA6jSBrVAZIR/
	nykuOHXoD+nB/ZzGJ63buKtecUIr0jn6qOiM+PEwnoNMB9tplmFHOK6leFSP02K6UMNscvJ2kTg
	z6wjN/Wy20+kxWB3sGZwSGM/CGgnKc8CtUIPQY6oMAv87HvP0Igqu
X-Gm-Gg: ATEYQzzoGdtt9MvlBDsm8VyQHFkusWpUotCx4QIqJarEvdxqGX1FeQO0m5UtwAPH8Dj
	U9MGcU8RTklsL3lhUEpdiXF0SSb5lLdxRCplGWVKWyL8HWjD/UCfYi7ybseWBPAcOdPTjRLXbE0
	na8VW3GtHcpEOnVd5GxWqnUmLstU9cfdr2+8lRYZAoKngeuy/JCVuen8JA1o/3yrfNQQFgIGhWA
	rCV0F9ElCSDpypSoP4g59gXizkTQTLDuLPVvDrmvLpsbn+yTduD1m5ekocT0gxn7K1wMelg1C5p
	eaLf+ZuuYKrkXCv9bMX0ZcVlUFyhvrKpOeZvKonxxcWP3riGzj2bSd+38Urb6UKCaplLtK7hDgz
	IMHyjEOfGbwVFedDgHg==
X-Received: by 2002:a17:90b:1850:b0:35b:b52d:f34d with SMTP id 98e67ed59e1d1-35c2ffaffdcmr15364787a91.5.1774948586993;
        Tue, 31 Mar 2026 02:16:26 -0700 (PDT)
X-Received: by 2002:a17:90b:1850:b0:35b:b52d:f34d with SMTP id 98e67ed59e1d1-35c2ffaffdcmr15364761a91.5.1774948586559;
        Tue, 31 Mar 2026 02:16:26 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe6fcea1sm998457a91.16.2026.03.31.02.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:16:25 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:16:23 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/mm: serialize local_config generation for
 parallel builds
Message-ID: <acuQ51e_qd6yfa46@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
 <20260331040156.119158-2-liwang@redhat.com>
 <20260330222948.c2cc6544492e68ded355abca@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260330222948.c2cc6544492e68ded355abca@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fWboNWzEx0KkIM1P4iB8ojALRRFbxuEm8Vjl5i8wcps_1774948587
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73FE2160004
X-Stat-Signature: 4ms8rorhwdafndzi1muusmu6ukzn1zgk
X-Rspam-User: 
X-HE-Tag: 1774948591-846335
X-HE-Meta: U2FsdGVkX18rJJpC52u20bbyRruLAWsERea4ZCvh/kGc03YB9vIGDEGzZE7pmCHyIvnp34XT/g52uXu1SDQWKlXCWVM+48Fnu+amy5yPmOhxLxwwBR6Gv1Es90dlVcW1UuDfj4gjZ/xMtqIJnfwdGmSi+5AF2C1wxapsfK24ADg+weeT4Wi+nISgNkcnxvvGWgerzkTV4kVLwI+wJUwQyrlST+Fs+xQ2Ww29Cp5QIHIseDcbGp/iJ04j994UWKIJm+73o2gjcxWq7mCYFA0C4znaPY0H2+4LkpN7ECFKASizkPFZo+iGdYpS0dP9Oy0YkKbZ2QsWmyA9pLYhglJ0mFIFVnIYIhzG+LDBFDJuNO6C8S8iFdhmrcvkYm4BmlVMf7sPD2StGJRuEdFAVvxw2nc3Un59nS/5GU1FbAkYlnU6AaxqfCskF0C9ObgokBGNHYyxgCX/eA38nZ+mPlVrwRfw4eKt8ZBNglriXxy22BnGpCHmuhAI89iHjtIkbP8Zcn4c8fjrV9Vjn/6bHooZfRSTSJocSWm3py0rx0eFcy6UdZ6M5Yu8gVZKkoLYwARRcXkgMRDzTsKwSwispPMo8et6Qefore574px52A2Jn0HghLgkTDWM083uCcuYjmzAZSxGkghY+gs5fIH5FFEqWFMvGYxWQcMq379D2LKlBub+XRpe+2jiTp2Nl0gcs+UlrPsR1Wm1yX3OuqAQFr7LjmwzXuAYImJVD1mxVsv+SpY7oa6fy60nM9hgI0S6COg9AYD3dnEu9pNGlfUncU7rOzQ39ARjiuyAjIauiAJ8YSbomowp4VDcV236/D7+7G3wpqlcoJ8LzyE5RwkQD3RQrAG1uwO/M3HcH77UkEQKMEQihg0SEzsNQoEpXnFv60fNQwiHSoqy+A5jLleb+jWjf8gjz73ig6wEi9exJnbIr3Rk9zOA5i2by5ZId85EBVlTWxvo9pPL1xutDMYq21o
 5ZCAzVxh
 w2m7faYoPkpdDyX/dhgQ7ffUkdP8re4a02Us4c8liDiQD0vco2ZhSpkFrepgsKUdFOXBoqXS/0UY/zP5xIdzQmIyp7bPcikkaqjKdcE8Kz6lo6anbqaymOCLKSTS2c7wjlpuQXK5RQ7utjyck6HkjNts5DJettx2anNMNbMetu1bV23akGkfhCCdXenoY7kKd3Z4ei7eFYT73pBNZZZ1leTB6XYX7kGuTPmfWnWrjBEaqK2S/7fdWLTfnsQiD4hOOhkaonUa9NwfFS2ghZIHsraRONE1/mMbscYAHc9KoUPQ94KoaYe2gRp/DGsnSR8njj+59n1DC2zNPM5dj7Oo8HZu8xdsNI2/EqydKa8tHrNNTGaQqzsugZtGMU7zk5iyq/vcX/r4hKZWJjirravNRTeBWPwnfwnz1rK7lW2ZynE2Vpg/GaIo98Zj9x3DJORiQByvXsCN46kNKiV0S8HrXmXxWsOsVsxoqRzVX1i0uyq2K8/GZTnpLONokD0r+pyvZB4fQJFCMnWPPy5LKHL/MJllBuXgELgsb3lnmLE2WnO+SJ8iZhPlJsR1Wqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 10:29:48PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 12:01:54 +0800 Li Wang <liwang@redhat.com> wrote:
> 
> > The mm selftests generate both local_config.mk and local_config.h from
> > check_config.sh. With high parallelism (-jN), this can race and lead to
> > incomplete target builds (e.g. only a few binaries get built after
> > 'make -j100', while 'make -j1' builds everything).
> > 
> > Switch to a stamp-based dependency:
> > 
> >   local_config.stamp: check_config.sh
> >         ... run check_config.sh ...
> >         touch local_config.stamp
> > 
> > and make local_config.mk/local_config.h depend on the stamp.
> > 
> > This ensures check_config.sh is executed once per update decision and
> > removes the parallel race window. Also hook local_config.stamp into
> > EXTRA_CLEAN.
> > 
> > No functional change intended for non-parallel builds.
> > 
> > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Well, the wind changed direction.  I saw this race a single time today
> but now I'm trying to produce a reliable before-and-after report, it
> isn't cooperating - everything is now building with -j100 with and
> without this patch.
> 
> So not very helpful, sorry.

No worries, we can hang this one as well.

Let me send to kbuild ML with the two valid fix (1/4, 4/4),
I will reformat them.

-- 
Regards,
Li Wang


