Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0765AC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6736B00AF; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65D16B00B0; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B075C6B00B1; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B936B00AE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8F7C40228
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:21 +0000 (UTC)
X-FDA: 85126187202.07.E7B91B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98D1A40008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qs0L3KOQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
	b=pxwKgDlgtj+pErzuyxtYf6xAs2lkZCc8JtlXwzVKRE9atRhBuPxwR/Q1p85aPZhB+E6/D0
	MNYPLNnWNHPkQXzoMQoTTLmpcSG6yqqUWDnGgzE46rwuJ/Fw8UppFy7esHjJX4AZvexq9H
	Kvl9AJl6mL39C9YMnaxbwLRkxlxmPtc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qs0L3KOQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338699;
	b=HVb12EIuO2/wQgjqDxUsiLt5x5EL6PBiQ1HoycTkEwuWXCGRdoMln56wvVYwAx95O4lXRk
	3DG6X8VZsRcQXvaVRUo8BMQ07Y2sYNSGEkgfoShThDsJzP8LTEQm/M9mbVxvK12z7+bcJw
	xg9CEX0RdAfvUhVg2bKmUam56PgbmIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
	b=Qs0L3KOQebDIG56XPCr9EkuLNWsfzFz2VfUJAhSPHGykHKGKWRcrHyoYrmUaKil8pD/5c0
	ufbpHP5MOjKoDygKNTS0GdBs7+XpWwuOC32U5rr/1KZaiS0giBV1KF8GQRRU8aqK5NAh9s
	RrXSzbJyHqqSX5m61T05dDRbHN5YY5U=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-LcR-DxndOeqtKKQkhsP0Jg-1; Fri, 21 Aug 2026 14:58:17 -0400
X-MC-Unique: LcR-DxndOeqtKKQkhsP0Jg-1
X-Mimecast-MFC-AGG-ID: LcR-DxndOeqtKKQkhsP0Jg_1787338697
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90c4da3d504so8736016d6.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338697; x=1787943497;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/8joInrEG3wyxgyxVErJ5zORrPbi9GYjPiUJzUhqISA=;
        b=VMun7MmlUydb1MMD1m4PaUpLrgNmzBHoYeold4KqX86hgI9XFI0bHtmjlwPvuPKzF7
         UjxK8expQOj2QY9gc2mSu0EEaVQOho8rWx0emzfBOEiJrqdiuWH2WfOu4EYWLrXKHihA
         9s9QwWiAR0Itkuq7PfQQ16uy/8Jzny8YTa7qwbJpDe+WjMMDZK5UuFx6GMnoKGSe8p/c
         GzdX5/16mVjPVAB7sCsFU62NjtoddxUoztEABOa1iL0SRZoJjNkgERV+X5uALAcpOZFj
         zQkaMt2UKf+X5zzsfMm+vIkVfjdF4FOgbAhE/q4dHiV2x+jhNyUebP8LQFTGVRDZd22Z
         5KsA==
X-Gm-Message-State: AFuF++lBIj7ZwB3bifsrOSqzYPAi/x7bBwLG/1G8A5vPICVDbKIFR474
	RvIcSh8uWP61O+WUnU8bwklU0DKWjDMueM6uRip2/OGX3GCg3D+CgnD1R3fkYwLgyxrmOdQ5qF+
	eTqXBMH2dMLexye2Rwm9P9W82ggks00+9Ubc3AWn+tWshDfq+JBs6
X-Gm-Gg: AR+sD11e8PXqQbyggMntVZFb365TSTyyTVoRa+V6n61Fj2m5PeOTbUwLM+4ZPctnXkl
	GAimgv3E3gdGb8rVfV1tHQ1omD1tKb3B9fqUopnlC2VV8bsTiAcfZG4JOYi9PGIOODyRIvfQv/m
	FZ3VOopbDehkLBkn81KLJdPn5mGS86OzwsiqP0BHzYhryor7YAnd9QYAy3wxlawREo9uStHpCKY
	a+IexBkW94EexcKMbeS0cdt53GQbSMMFzWvm3YU+6kXUEqH7zIQyAVw246qwJEJOahvt/72IMkU
	xHuYYu7VdZnAV3cMBErqCJGKUKIUEvm4r6A4gJ35lHNCKnaAuIRQYk2KerLtTCr8zXP4IsgMATM
	tinLkpTnDbnutK8Geax6p/shRmycAJlmsDOKQn9GTdSym
X-Received: by 2002:a05:6214:21cb:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-90c8098e804mr82074716d6.9.1787338697313;
        Fri, 21 Aug 2026 11:58:17 -0700 (PDT)
X-Received: by 2002:a05:6214:21cb:b0:8f3:cf36:15ca with SMTP id 6a1803df08f44-90c8098e804mr82074206d6.9.1787338696872;
        Fri, 21 Aug 2026 11:58:16 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2905d6sm68917236d6.29.2026.08.21.11.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:16 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:03 -0400
Subject: [PATCH 11/11] selftests: cgroup: amend vmtest-memcg to run the
 hugetlb cma tests
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-11-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9YN8MRwqfVQlm1uEzjveeM6muVCtfz3X2sq9TpRExjI_1787338697
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98D1A40008
X-Rspamd-Server: rspam07
X-Stat-Signature: 6zgwx1xhydued8ngjnuwar466yt74u16
X-HE-Tag: 1787338699-265285
X-HE-Meta: U2FsdGVkX1+MgmoMJDjkw1xBnhUOIExLF6SI34TWAFAK82NOIYKKQ7YK0yOHPadIt45naXYZ15ewwNr2qBiknlXnhOKvigVRxhLUUyJisHhod3T4xIg7g6cyx8kpiG+wLNiEAEqOAVL1rhtUdnQ17C6VWQQ4Yo7BTJ4wWnwbqcBeHj4HUXksKKs02Wqt3qSYdRLQm7cb1ZKZu/vrdEihq+u7BjDI2nmAVQsdKH41W/865sTjX/peF60ncrRU64p03YF9oRnJ7dtqBv9y0TYH/tMc2fTAxxfcx1O/a71IUp1/OmSjQEC9opVUINBypV/pUAePjZzdeIvCmeK7iwcFO1RT5iO0oRou1zift1lx9Q81IYXq12/n/ExrpLm7Q6WwTPOHd4hwLbN4nNbqel4LjWHPgZY7yaMwd2o8ti5k8H+WRksIFxUDlabRCHk12cr4HcQD58sM8C0+xyi7RjUfFV5oZo+aCek09j8jFCoD8BgmBMHYhB5jrUzoxaPYZ2GDvq5OLSe3udmDWXHc/UNM32y/PAYzO/xVAk0BE4vVWmJSvA7tb590YI293YnycEI+3YTmcLOW6Y9ZB0vlRYJbbqSccZDtWQFs72eDzVxAbxm85Nyv5EKEk5Gi+kSP8IT+qEB8ePRhf1Y4gu73mkpGq1xMIz3sY2Cuuyok9S9eevcui3/9PsqIeKFZe6glT0wC0fnVtiNLSH9M31OOnZ9Z+HTPK9kb8/jhx//rVaQhGh9SU2DA/gaVQVCn651Yb1MWHdFzOOxMaXzleWwDWX7uDkFpYB1X8XIADV5ts1bMw131Hqp9IECCXrElSC2mMi0PpDwX9TvHTd1nHmyeaxTji8fknrlLf5Tx8GX42V3sfHSPjE5HKUG9k0TGA+pb6HrmIA5PqgsRitSSfQdgXq9CABXP67g8PZD0oMPZDKmcsNJ/1jX5e36NEbbSise9hIUJIr/ItveliDHHEwwrBqf
 +zPxikXG
 XOil1rdBgt339UjACFJfDF+DTfLPbkIyDQv1SLpgE021H5gclb+DtW1Hk7xAhvzTHuxQLrJLlwrQ3eWiyo9CdrFi/fIUOFq67padPXBTHpthTvkOfsXHt8pZ9nNIZr+CQoL0UCbxWOWddRufcGYEqiCASIB5zYLPTXgr2A+v9mZ1zZgRZoPKMKQxYVMD9Q/T0ZaAW2toEq7U0WEjSeIdHFNzNc/md6s0lPot/p4/J2cjKO+bUqm5b5svyjesXMm7/8FuJHN7dFNWpno4Pu7AcOewjJUbE9I9lVEmK4NbDuDltbRy5GKAsGhHWIdUDe+wxhxG6CmyToA6CppV1R0hZwyZui0NL73ml71UJZGsta8AGvE9/r34Yc60DKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add HUGETLBFS to the selftest configuration. Amend the vmtest script to
pass hugetlb_cma=1G and hugetlb_cma_only=1. In order for hugepages to be
available, ask qemu for 3G of memory so the CMA reservation succeeds.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/config          | 1 +
 tools/testing/selftests/cgroup/vmtest-memcg.sh | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/config b/tools/testing/selftests/cgroup/config
index c4f7df4f1b24..1c9034017682 100644
--- a/tools/testing/selftests/cgroup/config
+++ b/tools/testing/selftests/cgroup/config
@@ -8,3 +8,4 @@ CONFIG_CMA=y
 CONFIG_DMA_CMA=y
 CONFIG_DMABUF_HEAPS=y
 CONFIG_DMABUF_HEAPS_CMA=y
+CONFIG_HUGETLBFS=y
diff --git a/tools/testing/selftests/cgroup/vmtest-memcg.sh b/tools/testing/selftests/cgroup/vmtest-memcg.sh
index b19b96731784..534a95ef5e07 100755
--- a/tools/testing/selftests/cgroup/vmtest-memcg.sh
+++ b/tools/testing/selftests/cgroup/vmtest-memcg.sh
@@ -116,7 +116,8 @@ vm_start() {
 		--qemu="$(command -v "$QEMU")" \
 		--user root \
 		--ssh "$SSH_GUEST_PORT" \
-		--append "cma=64M" \
+		--memory 3G \
+		--append "cma=64M hugetlb_cma=1G hugetlb_cma_only=1" \
 		--rw &>"$logfile" &
 
 	local vng_pid=$!

-- 
2.53.0


