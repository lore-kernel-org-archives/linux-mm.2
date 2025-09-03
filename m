Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6DCCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77838E0001; Wed,  3 Sep 2025 03:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4DC26B000C; Wed,  3 Sep 2025 03:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962F68E0001; Wed,  3 Sep 2025 03:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85A726B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:03:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20EFEC04EA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:03:01 +0000 (UTC)
X-FDA: 83847046962.25.2FF9EFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC4654000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:02:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0cpN5eT;
	spf=pass (imf27.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Nc4ZGDL32vdkqTp2UxmErkTt7s51BsabNhqnOcOJ0vQ=;
	b=uXWLJPwQPIMqqOD0z2HpNtkFifFugLxI3+4ZNeJZB9xur9eFxdrzlGOj0i6BKI5oXU1wzA
	iiMI0dYkWD41KYwrXXY/x6w35EtOi4wLqu0TVWxh5/Oc5OgqktkZRCqiOSmZJs00xtIqbV
	xxAOeEXaB15fpGQQlk38vstMqK6KdSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882979; a=rsa-sha256;
	cv=none;
	b=gqNSjaaS3UhQETgfGeQltvrrCmCTkwA7gY6F4/we1yVrD8MNXKdLs8SFRF5MFAyGbMBAo7
	opNUbS8PsEpaOkCqtcG13r+gZvy2UWc+JmMNSbYPU4HSUymhVoPGtzBDXgslh2IaHAdpbF
	tSc/hhZLBU56SDe5dEYE3QnAeF+j0cM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0cpN5eT;
	spf=pass (imf27.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756882978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Nc4ZGDL32vdkqTp2UxmErkTt7s51BsabNhqnOcOJ0vQ=;
	b=I0cpN5eTzrM2KUDEGLxuB2pEZHWy//rjKFKoEbDWAjHiWImQO7sscwh5lSM76I2XOInYHs
	lSMY6XPT8cNj5CpR8Rvy53IZJIJy/zhQmkyJBuMKajdOFyMDKHU0Da+BoZV0u9p4yvppkC
	+rjaizIcJOfFaFIvKS0Umc8Lb9XUdXU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-sH9l3K4bO9ahkkxD1G5pmg-1; Wed, 03 Sep 2025 03:02:57 -0400
X-MC-Unique: sH9l3K4bO9ahkkxD1G5pmg-1
X-Mimecast-MFC-AGG-ID: sH9l3K4bO9ahkkxD1G5pmg_1756882976
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b9c1b74d0so7188495e9.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882976; x=1757487776;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nc4ZGDL32vdkqTp2UxmErkTt7s51BsabNhqnOcOJ0vQ=;
        b=gvl3Kd/6OGy64RsOZ2RPYeYRFa2ETQMIK71/H3Tev2Es6mxXtb/QgVYTNm+shg7i6u
         iUs6Jovu0LjM2BQ4TkkjWLtOkG4uIT8AdJ+wcuhgYlQCCLe/lyfvGUwOFbSQePYyEnUP
         uh5ZvCcPSFKhIqbnC59RRDdpdzyQyteeK7AInqcqRhzYbq0klZPiEajyf8uPU4J0fWfB
         38Fp+blIyKrZGE9ssSKO1P6mntN6bfIhPsNJ6ko2toKYsrC7BVpf9SRqVl5/abPuQjv/
         IGfLao9NCbQc3oHLaUPbjxxJurAISGsx+K9IWiV2GL6+Ystnrht+BmzrJkqSlm9c9PYD
         4thw==
X-Gm-Message-State: AOJu0YzMuqLn3tq5xQUXXKcWQ5/fIYXVLbMg7DMInQ/VmqvEqrbDSFME
	XkMUHWweKY2mmnlEn49dyt5Z72hB+kFcLw5p9fTtwxmtTZT0JKOT2yi/CNH8G7zmAXgNtWmZFRS
	OXeT6gCsHgpH8x5ZWfMXExPDtac7t/ZcfUcSV6eO6sNzjz+w8alDI
X-Gm-Gg: ASbGncvjMFZksTH018i3JhhENq40t8kYSGszD3TqSb8OMrzLdL06t1I8GjRqosovBKd
	jdcvvCc8j2YpqkfyRN5BLsFVHYbsHXNWpd81L5OHWpgWlP5BCsnFsKofXkhDhZpChTr6/GcCn91
	BQdLHePm1QpiSL/1/qHJEEaE5ILLBVj3+c3MhI7EInmBmZRKx3hICPNhSLluQTOO01Rp5fmmKs2
	KTruO2jAg1yUqvtvBOLMkBmHvWGHS7ksSMC3F2bo2Q+CohBXp2E5bxe34L40P4hsrw8+21+H5DU
	UhpmOHIXRMqz8w+apfDoX/yUprYoTY+AcBfxoSsgN4Z4ZgdyCbSroy4rLxNf0ibhv1abVHwEZJf
	wctJtLWT2FRiE+IcfQYsIAtPe
X-Received: by 2002:a05:600c:35c8:b0:45b:8939:8b1c with SMTP id 5b1f17b1804b1-45b89398f5emr91180595e9.27.1756882975828;
        Wed, 03 Sep 2025 00:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/9mgihyp4H/Sd6HpN2hGIHH2BAgbt8Nw3A35djnCsNu46HxzvDh72AIsbnyyE/AU8sxs5IQ==
X-Received: by 2002:a05:600c:35c8:b0:45b:8939:8b1c with SMTP id 5b1f17b1804b1-45b89398f5emr91180285e9.27.1756882975345;
        Wed, 03 Sep 2025 00:02:55 -0700 (PDT)
Received: from localhost (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e8ab093sm237018805e9.22.2025.09.03.00.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:02:54 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v2 0/2] selftests/mm: split_huge_page_test: split_pte_mapped_thp improvements
Date: Wed,  3 Sep 2025 09:02:51 +0200
Message-ID: <20250903070253.34556-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QrQHx1QZ1qvGgp-vBxKqRYaGlRbzj1RySUYrDkORnLY_1756882976
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC4654000C
X-Stat-Signature: 8sanip1w76c3bn5jazxaehs5cdwpc7sn
X-Rspam-User: 
X-HE-Tag: 1756882978-798346
X-HE-Meta: U2FsdGVkX18aTHUAt/WYX9gYaWOy/EYWheZrqSPf4DP4Wo2v44aYZRert6GaU5pjALEMxbRIaYplVoWgWTV1CQx9MII5nr505XVoohIdokUU7lDFQOPXSooJLuT54QGUHzb2g+sjdR5RykhtrfBjqWpvSmUoW+kVRLifpX42P/nn3WPdE0Z3U3CGQi4z+ftWPraSR9e78/tDbuyMm0vGwS23QKO1RoULcTkYhuNH4TOvhcUB5/YrW96Dm0e7jDNxcPR80FcwXmNck8oVHyOCX3HB+rNyVwiaPw2E0RIAIUVZXuMKuD8TtNsdNaD+ywOjtH4qVztnImlBSIozGkSyRhfp5Gf1dC94aZD6Q1jqbi2tiDp18+9YqphPBFPShYeGP66TqYD2r6Jvb6VjflWR/d5ruUDyrj85YwUPVxVfj+Bst3wKpmjBzOgYy43Yjdxv9NS6SnR86Sn7BAduq5ZrQWcBd6otFwjwAgICw5y1g+JVhGPO6lTybaNO6DTXYIAsXCsJA2vjrEp83gRhFuYAItOhWJ5BcCa+D0UYAlIU2HoEh0vK4i4sEjM3vYKJyYu2E4FnfDK2aiVnU1PYqJ0DBVz/fCYervY36TJkkhhN5veY9H/EHmFWET4yZEEZk7qMnb6CtcaUCsj5nIytJZZKBnMdYr6ZqTjI2G8C4c+tPGg9DETpkVosMEIeuoeD9vmbyFm/mFdEsyuOLfrHgj6OGdn2xyvugCbuogfQoy2l5ubL9N3mvawXW0jHUYqOb8wjEyY4whfz1L8wKOERTGvgGlUD8+Y0nHp+hkFFWCPMqsnszGUiPllzpYF7/0dq3evwX683n6u4OsRlZaNiWRxXdC+LgFb3F/oJ5sfBhy9lV7+3+fstzEs+fnGXEzpv8Du/l3cCYE1DzOlWS6cfRBom22ueLHTZhB0koWI2BQsMyi7kL4usgkrHuMqMArDs3RyTRdkSyVuEcEpjtiaugJn
 g9GW26JU
 W89fYjC9BsC32hgQivwUHWsJnMIlWUBXFwZGI9oMHRAPsr9icmGgnZCQqs9xzKiHKL1OfQiYYaEuxIB68WzhLU8kHV4JUDgm2uvON4khVio9+hJhOCdvvnN1b1U9dGB4GKMaK5MCELQZnhFpP4ToRJPf9qJAuuPEft/28mD2SbebsFlzCjXGMSeLeVIRVvZ1IH35G1DTsa7sRSOfYgHeDfUI442jW803WUqkMtjjp82z9kToRCmfTCLn/nJ9yboUImo+zqFZvpzGXjqaPJhgxaAgXoXZNMiKx/ojXDFgPDy91Nu5AWwzVhsxtrqya3NwfL92acEbh2SQ3hAUuIeGV+Z5uxIk4HsjBXPQseJXq1d3xk5K9efHP4BMU1/4RzGBxpQWzYuglCIkDgd0j70NadqBlhr72+W8YTduALIX4yiLT6LNHT2VMpEOm1ZoLWrZLLr37IvjdluCw0h03PgtxRkD1/5UFYQO9AEAvEsFqs1Ype3vg1xKgUFW8zg5kRArp36QfOkiMBrqxiVYubhDfonc8860p7476nx8J+JHr03oOn7Rx0iQHpV2Kyo9J31CH+l47RKzkiIlcF48iWpZyt6tn/HB+2c+DX3NIWbiqB10jRzjOlUqfzjeKsFzZhF810ZhUVGkVOyZJki1a3r+mnjKC+WGK0X+FOpGqjqRzfilmqnSi5u3JKTp9UkSYOvLBjGvugj4cazIbQgrMMSzmWpdxMoNvMrFo4I7X9nfRwxM8WgoRm5AoOWSvX3i5h8fCZNgkwMabiJjcEONmvOcLfVbX/QB+UBZA1DY1oaGQX5VqNC6pJ8JLD+W6Uka5PNy7fy/IagFgFie8/sj6QrD3FCO3xv55/xVkP9NV/B+FN7iSa1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One fix for occasional failures I found while testing and a bunch of
cleanups that should make that test easier to digest.

Tested on x86-64, the test seems to reliably pass.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>

--

Mostly a resend, because I accidentally disabled "ccover = true" in my
git config so people were only CCed on the cover letter.

v1 -> v2:
* "selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio()
  wrong results"
 -> Fixup missing ")" in patch description

David Hildenbrand (2):
  selftests/mm: split_huge_page_test: fix occasional
    is_backed_by_folio() wrong results
  selftests/mm: split_huge_page_test: cleanups for split_pte_mapped_thp
    test

 .../selftests/mm/split_huge_page_test.c       | 138 ++++++++++--------
 1 file changed, 81 insertions(+), 57 deletions(-)


base-commit: ef42a39c44ef6da64ae3495d27e28dd6fca62a51
-- 
2.50.1


