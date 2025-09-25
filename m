Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1288CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354398E0008; Thu, 25 Sep 2025 04:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304B38E0001; Thu, 25 Sep 2025 04:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3988E0008; Thu, 25 Sep 2025 04:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9E08E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:23:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDEE51DF20E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:50 +0000 (UTC)
X-FDA: 83927084220.13.23C0009
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id A0EBB16000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LDcaqnpq;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhSbD5B6IBnwKu21md5JvzsTHBApvKSCpLrxMRXz0O0=;
	b=pKit6IipMBaf0DogLLSZTVnOANdrXYqf4mKo/Tq2n1ZL0qxRckgDZ8tHIkWZpAbVrFjaak
	P8Hyrai7YB3/lIT/+PKbkUnSO0hAcChU2aJD0snsqs+WqC3SrBkNtBAxDxMm8k7lrE6UO8
	SqvbvCsIwsXsDjr905umSoZb34JMgt8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LDcaqnpq;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788628; a=rsa-sha256;
	cv=none;
	b=o2KljilYKR2L5NtwiZyBUgyEKaK/GDLfxGgbzREIWBul+JFndyRjtf+Rc5n4SjWUkqbwdK
	QcBeYCZ6glsMUeqXlkofbugZf70coIt0im4w1d/VaEzf3KDoaI+caukww6he1YEl+G8jhg
	KnnvWd9LMpi5hsawuqLFlUQz6EWo1q4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YhSbD5B6IBnwKu21md5JvzsTHBApvKSCpLrxMRXz0O0=;
	b=LDcaqnpqTa1jnHB3FACsZsHUCPN5Xyb5WrOFBWeYI0VslRYp6Ac1dfF59QuAFS0WwnoKhB
	+wh1y2r/Rxu+uOxzblYqnviNG22JOTZWU7fKpQCtM7DSnQnA7ke49wY6DMYD5RwrCx24Wu
	C6Tf83rHdev638urXCSDOYrpBvSzL1M=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-oX_FSuXeNmKyEUC-Rvy23Q-1; Thu, 25 Sep 2025 04:23:46 -0400
X-MC-Unique: oX_FSuXeNmKyEUC-Rvy23Q-1
X-Mimecast-MFC-AGG-ID: oX_FSuXeNmKyEUC-Rvy23Q_1758788625
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ee13e43dd9so291020f8f.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788625; x=1759393425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhSbD5B6IBnwKu21md5JvzsTHBApvKSCpLrxMRXz0O0=;
        b=PGiJcCLABocQqhyv0R4SbsZ3DBnNVMuAX16ApFA/esuteo83HYRCMwXrpdWvmgX5/3
         jWoEBqdmgCHu5oi0LKTkofGgkSLlbRTPhIMM7nHC/HC6+axYKaiFY526/LvM/GYYiewo
         q+01cI9kUxWcGKGUJ33yjvDzE8Q98zL2c+YtvhcyWCSV8bcLp94hcrqXXhFJl42S9OxI
         MC2Sp19s7LobVG3+ujspagOl16PGhZmQRXQO9GzeRwSx9rW5ZDukNzJWeMbXZa+rTHLx
         7Agcfg7lquLeP7AFQgGERBWEpoTfaEAVx9BPaNtUqTdil3xUqT6uEIXU7frgVf1NFlMw
         /ypQ==
X-Gm-Message-State: AOJu0Yz4UrCZJuD361nKjrxIn/NOsnYD4tjSojoUOSQMLC13r6UiTPbR
	+dxeMH8jADbsYiLiG6Uka75R4M8McSCHRabyyN0EVhwGeZps2OcUn0OunRUh21y1zytg8GyLvTu
	gGk1dXJypFRcgLBUu4I9F4kLmGNduvcPvoT0sOUcK0HZNl/pubU9u
X-Gm-Gg: ASbGncsSvLEON/T4yQF1OsfWmc5p6Ymj4yFpP2NaocfXpKHBVzKSzW9xb9Ai2RNsbHM
	Le4qF5bM+HWwF2URYRvUDvOiogzCcakZCQ4S3PCCa1aloSJ4edUEfvc23N45O/Y3mZ6JQy2BAtA
	P4bkj0EmwvdzF4TkQnv7il5DQRxNdz3Jk88PeSb+Y5Or0OJTrZZouYi8xZfiu6fvvtLgoMmagna
	Samg6Od3vmTaDrgJxtQCWH23xKTuOiBKiUMRXCNl8HyEHCmBXe7fyDaCvyqCgTac7Jlk05ARZ+5
	B5qI0VCx9Ny9/2A6fx+2+WWUBHZkd6aE/8v+sNqIhg5QPNw/MvrqbeuaYAJSMHUgtEqysSPwqS7
	48gz2fR6upWsX/yxplHJkQuzbQQ==
X-Received: by 2002:a05:6000:200b:b0:3eb:d906:e553 with SMTP id ffacd0b85a97d-40e4c1dd9ccmr2003053f8f.55.1758788625256;
        Thu, 25 Sep 2025 01:23:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkNiCkdhIZKuI0E4i9LV6sIBB71hg0FAowyLArQNJUOTpu9g8z2WgXGseImIfZM4zfRLDFzA==
X-Received: by 2002:a05:6000:200b:b0:3eb:d906:e553 with SMTP id ffacd0b85a97d-40e4c1dd9ccmr2003044f8f.55.1758788624900;
        Thu, 25 Sep 2025 01:23:44 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fb89065b5sm1962986f8f.17.2025.09.25.01.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:23:44 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.1.y 0/2] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:23:41 +0200
Message-ID: <20250925082343.3771875-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025022402-footprint-usher-aa6e@gregkh>
References: <2025022402-footprint-usher-aa6e@gregkh>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bxBLK7Kdgan_r0trbIsJsCcgITt8qXsK633rjhQ38aU_1758788625
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0EBB16000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mhmxu1ofz8nc4w8gpy4yiojxzaosgds8
X-HE-Tag: 1758788628-404852
X-HE-Meta: U2FsdGVkX1+LDWj8/3FM9ngR9D7hN5wiA65eHfv/uCnWJ6Gt8yk/pKQSkQq7kB3ENMAuDnuLl0kT3geQIl/i9+sQVt20M5P0exV3IHnKcZNPP9/rfTDN0fAlwQPe9TJETbnA90k6fuUKQwK6W9MbheMNx6SVzqoFD81A76IFqWYuMAm1vggogiuON22TughENsghl/g99IF1yTk1u9ORjAfBhvG60n4Qo4Db8azqc58lsviWlYI92khn4V7vZHlnnrUKbnEPUFpuvTEvLYXhdyHiRgPpghTw7GydF5yDl5fTNAZhMxzpqIl1jUUnIZWZMksbIKEPELWdx+f5WM9JaouCZCiOA8eMMgjQS4cnuZWKkLpWIlsIdywF4mYlvE/KIV/Z0Pm0UO/enhQsHmP4R9CaD2ajK6/E0AMPLdaQyPDkd4gUkqsWu+gPrnOornGZ5dIlbGOnw3zo/RX+7Eq5zadeojvXp5y7PYpMcgt4wSYB/Dl4IPeaCDoBFiVuhadWv/cE668UFuaBG+Q+4DSP7okDAwkRqiQ7VYvsZ6sq9D0nLD/OIaKcUcXeLxPU8oWSeNhBjM6K8Yp3h8V+DOiej0k1Q48x7eeQw7gangpM4JKjhhekfYLqbJZ9OO7wLFC7KZeI4jpFMF3PZX/ZKGGt1OoyaX2I9ogdhgGYJb/L+nEcXA+EnhYEq1B2/FlrEiiSxrcFNZ8mc1Qx+nvZW/ni7fmn+b8wYiKU2QYx9fWANdmQ3FX/ODNwptwusHrriHewnPQmWPYd52ZFwG/mmKEdWwf24xKVEalmfRJrrGDVI4ji/6KNAgDSc+n4GXF3VWLi3hZ3HOC6VgX/cLoJCNIU+Xl08N/moQLFt0azPATcUS/D63hIb4ZR3pPS/IjH+hZnkMv8Zm/kKQuzP3cN/EAotPrPtH8KSpKxrZgodTfe0fgcnQf9UacygbWleVYaj5CjiV6xthxhMnhb70STIB4
 CKPZwMFz
 Su3vxrGpOBktOrWoDS8TAGCU0b4OSMczM4rFNynwS3m5UcFTMP1sKRATDvCUMe8VdUlKM4uA4t6vQdtW60sfabXylVaqrlCtCVPox+2W1b6mp9tcH+vZtqr2ARpdezWHr7TvCzoyMpxAf/YjU9dYDsZNHrvwhYkTb15I6Uowx4QQIE/ZBjD9scPKMt1FSw0d8ReDOG/H2WX6aVzRo2D2UmM54p7/4YTy0JIig4uRRJkdpj8wEx6vamCe47UAHqvlr0ZXCEBVh7hSBueDunF91z1/fpCRVyFFvioiTH2/Efgj9NnF3h5MeQweAkc4UL5eHloR+xLa7zcCniNCofPE6AxsxTc3uhy8vyhW6I7bX2k/zgKXvD+XmmfgywwIIpCvicBUlPo5wjAvHTaI1fbwb0ahxlbIapimqryT8l2O9CpIhVAKGtysdUWoQfEW+Nhso5UOXE6lgYwq28L04/UjkEF4qvJsxUqdRuJzZ50BM7zeu9B2kFh+EE8sJq4p+tOt2U1SeG7BP+7NIs0bywlr5oA+sPPrbDuUFX1ysWXZqm6HcDgc5JrOKFK4D5T00D80Jl5wr3ZO8hv+Le6quunuIyWQmaZ1UiOYOGhwALNJL84dg98tLArhQqs9QoOMX5+Ns+sjDsky0iZWlRjQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just got reminded that I never did these backports.

Patch #1 is a clean cherry pick to make the fix in patch #2 easier to
backport. One minor context conflict.

David Hildenbrand (1):
  mm/migrate_device: don't add folio to be freed to LRU in
    migrate_device_finalize()

Kefeng Wang (1):
  mm: migrate_device: use more folio in migrate_device_finalize()

 mm/migrate_device.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)


base-commit: 363a599da6d9d9aaeea97fceff615580e845c72b
-- 
2.51.0


