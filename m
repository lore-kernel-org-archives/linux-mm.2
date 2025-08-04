Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D70C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F866B00A1; Mon,  4 Aug 2025 19:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6479C6B00A2; Mon,  4 Aug 2025 19:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D306B00A3; Mon,  4 Aug 2025 19:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46C386B00A1
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:15:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5B38140A30
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:15:58 +0000 (UTC)
X-FDA: 83740634796.11.2B3A380
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18E50100007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:15:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mQ7fiFdt;
	spf=pass (imf05.hostedemail.com: domain of 3Kz-RaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Kz-RaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349357; a=rsa-sha256;
	cv=none;
	b=eufqYlBEzyMBqj5JHBelfmKPmh4+Bvg7no13C5PD60hCfQVQOGjvEDG1vkaps4C68zX0ET
	j07LQGvD4FIhyp1siB/bdJugHZKivhr6IHRlqaM35yWFF0ZcLGbFM21qupKm7YZ5w06GvK
	aMYTDjs5ZhIaJOcarXoq35h1RmKCQak=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mQ7fiFdt;
	spf=pass (imf05.hostedemail.com: domain of 3Kz-RaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Kz-RaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C8NgMA0HX6GfrkP4AehXbgu9Qzh9g7nw7slgx4SS+9M=;
	b=aR3HkrpdqYmejyu43DXdRXURhavacHhwpKVTYD+HqxPcoJ8Q9REluPBVfanMOYIDbfLBCw
	hSNmIMSayDN6hdkw1HCjnyW0W+YTKSpn39MMXGFj4PidKt4OOssukoBJ8MkyeGTOEXzOfM
	QAItWKH0tphBwZfpWAju+lKNQfw2O2Q=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bfab12672so3886337b3a.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754349356; x=1754954156; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C8NgMA0HX6GfrkP4AehXbgu9Qzh9g7nw7slgx4SS+9M=;
        b=mQ7fiFdt6x2fN62NmmYIOhKdfTSGQGdj5m6s5XNMurvTfONe7eUFJspRRGCJRTW0N+
         O0i7KpFZpY6QzzBq0OZLVuTt7pB1+2DdQe0Vlk7rwYqjPjYoXLPDBNh9TZBUPjRsXMQ0
         y5pfLGaTliPvUZvKXSxTOpV4QbUt00lBMKqLe8lbBVXs76dFatPA3NptyL46iW5Ubumk
         mBzyHz3dJpRjlU4O3iIPQF3U4KQIehq77+P+Et3QoschXyLWWI9xTN4RFAo5ssw8KyBy
         vM0BX2wAfoIGMfm4Cph+8GSlCRPWyUbONkb0HJ8FBlo7hF4JWL13rkJPNqvulMqMC2XW
         ZURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754349356; x=1754954156;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C8NgMA0HX6GfrkP4AehXbgu9Qzh9g7nw7slgx4SS+9M=;
        b=FFLwaOoE2pVj9nbua4piyWu5DgaTaZ34PrHoYVdQuI+LoOqq29b+Msvj8fIAs+ZaH7
         0S8wkeCxq3y9rKwzRRLgH4YFJ54rJwc5hWJBToSni9zhIyUamOzGdFUNnB7AePDua0mb
         l+E9pDFdc1DAZPTDM3Wfk/Lak9Yd+AXqjF7IlLgShPxtq80BEXopJkhirrdBRwhuT3IR
         xdnJS4FeJYTlMX9i2Tu9TzZZq8CFh27wfjPC5YMKEGmtBN0l2sOT116f3Zmx0s7vOCVg
         Ui12FuBCkSnEzKtyDxZhbhYDfjydpDVYsu7Ncg6KVrNZQTVxkoukFKkqEK/S4OHBqzfh
         ul4A==
X-Forwarded-Encrypted: i=1; AJvYcCXZxkA4CvaBHHgxuV2luro4FSGAjFL3WWZv5rpaoNtGtDr0IgR2HvqKRUjgxvaNcnAkmvpWsSVYSA==@kvack.org
X-Gm-Message-State: AOJu0YwjQd4wXe+zwBHl4Uh+a1FRsgw2ic5/on8e0PdAW+/QenVYFvfj
	HDZUFFt9cJ0pyUxQE3qbA08zbHGCdmrVMR0q0lINS0GyTm7WzvuW0pDTD6zzd9Xfclc6ot1suhO
	tW2tdKA==
X-Google-Smtp-Source: AGHT+IG2q4Q/icGmfZqa/AQL4Y/7ixWiXboOhyChxpBm5zefJHZYEBLAPMKg6t2vVqdvtV/Sahk/uwOkeqs=
X-Received: from pgan189.prod.google.com ([2002:a63:40c6:0:b0:b42:da4:ef4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9994:b0:23f:fd87:424b
 with SMTP id adf61e73a8af0-23ffd874f47mr10654460637.44.1754349355847; Mon, 04
 Aug 2025 16:15:55 -0700 (PDT)
Date: Mon,  4 Aug 2025 16:15:48 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250804231552.1217132-1-surenb@google.com>
Subject: [PATCH v2 0/3] execute PROCMAP_QUERY ioctl under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18E50100007
X-Stat-Signature: 4cwufeok9nubdnwcknho99q8wnojyk1b
X-HE-Tag: 1754349356-530858
X-HE-Meta: U2FsdGVkX18t5VbBtKndtQzsMlsh3DAKXyR08JtplE5qzNTV43fnVjnZVewbF919JcLavVREMr12t2z58NDTABnd13KEXvYrNpSZ3NZGWjBYE4dH6TfU5gql7pJsKhb0sPhxNSchvw/HUKJEfg01IZF2SOzwPNHvKNIIpv9r6MgEirdYDcuPjv5/BHxXI7kQG1NnnVZHDsdvKRWY4wCiXYYkqopCyJAcJh8HMhJScsemryqWPiStwbBpvs8xzQMjZ0rwC/7PJxcDo+P2xnbeFZdkUlpAeSZeJ+KC93XQ1XFFCz07sNdVYz0rfWMI4pO2jnHUwtA+9SusH8jpaMGlav1TahtFqg9qcp1iF/JiY2pbRUhzlfDTICRVn1bREYcUCt96qVl7jhUsy6Zg07vUjOwvV7u1JibrCMbDQrl7uDhIcxR4cyhoMn9M+/Z2ZzX0Z2m6Wu/IJqjftdsTpiMtEkqOCzRIEDJPkzUPkAIXcn3aEkP0b4/2FWH+Lsqv1e/mSwjP2ShhGVz1F4UUu1UjYx8+6763BRkWkJNFerw4g0ZkGT3/EovtQun7hQ3wdyl5dZUXTj+CMj14l+oH/HTDVkZdzan/CidMkvJCOeYop5otaiKE0AiffqsHHWj5adJo6GpFLxsLjBg92jQNMSXCfg9LS3uzCNdhdBU9AlNT+8YY3HtdwrxR/YgZQ5zVmDSobN/wBp/J5P4bwQKzlh8hmx8xCG1Tdehna6r5U1+CA7FeB9mqzgeqLYQBgKSje6xeDgCSTE5jv0NYdjxdALSxaviW8476qxj7HTldkH/5NseTlBgO/Hsdq4RP7TAGOm4cCtVJns1VNx/55ygkysdf35pprCnUoUf9IkE92oEsDqH9ZCF2/3r0jiFQ5gkQhQW86pxbhyd1qyZTT57zBCy8BbMG92YCo1VlcTf2yhKqEHE7h/fZZzvO6j4jJSNENl0DT8l2aOJTAVMLCCNdKxs
 xPnrP2d5
 TgMXBoVCTjcjq9NNgXIORRebkpIl0vmEINh6pGZ8uGnCIbmp4tsuGFYnVwJd6PkP4hELbBUN58obPz4N/AAqZQS3vUsbGa0VT6v6LOoMKSiQUE6veRG7MN+tPLWbffupZ7I9a5Jn2i71B2+qo1WTvBowQedKPHXyweD8G8Hx9OhgQ45cAfCQOoHpHXsJ4ISrtKKwzhUL7P8zRXf0uoQHuFx0sSu+1Xy2sWOi5nBTQEHsXMqIgSwnJ8hFxghOwhTVMjcAJZYyGVkkVz4k7ufPxWOIU7okKsHI4UIOZ1pdpn7ED91SXC7MWXS7yfD+WMyXXBPPJxR4gHJOxflYCT4AKK00lixL94cbHVvqutX1QHovSWZm6J7gZrdzGHGPNUziHX501VqnG9W3th+DrTpfUN4NLvHUoPwiXSNPiVMBoPml00AB8MNLFUVkSwopPEz13zqRRaZgoLDDIlNnRETXmKsZH9SNP0tnHc7RpXnY9Sjs+Zs832gPevBhKqoTGI/Ghul1DJimGkbUyjzja4rMbN69xQqKxh3jkYWGaYHn9gd7RKUpDuDK7T+h0qxtrS5xZGWaOEr/3aHBfeLC5fJrPk/or/hxk2twSdU7cqYN07hxjO4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With /proc/pid/maps now being read under per-vma lock protection we can
reuse parts of that code to execute PROCMAP_QUERY ioctl also without
taking mmap_lock. The change is designed to reduce mmap_lock contention
and prevent PROCMAP_QUERY ioctl calls from blocking address space updates.

This patchset was split out of the original patchset [1] that introduced
per-vma lock usage for /proc/pid/maps reading. It contains PROCMAP_QUERY
tests, code refactoring patch to simplify the main change and the actual
transition to per-vma lock.

Changes since v1 [2]
- Added Tested-by and Acked-by, per SeongJae Park
- Fixed NOMMU case, per Vlastimil Babka
- Renamed proc_maps_query_data to proc_maps_locking_ctx,
per Vlastimil Babka

[1] https://lore.kernel.org/all/20250704060727.724817-1-surenb@google.com/
[2] https://lore.kernel.org/all/20250731220024.702621-1-surenb@google.com/

Suren Baghdasaryan (3):
  selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently
    modified
  fs/proc/task_mmu: factor out proc_maps_private fields used by
    PROCMAP_QUERY
  fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks

 fs/proc/internal.h                            |  15 +-
 fs/proc/task_mmu.c                            | 149 ++++++++++++------
 fs/proc/task_nommu.c                          |  14 +-
 tools/testing/selftests/proc/proc-maps-race.c |  65 ++++++++
 4 files changed, 181 insertions(+), 62 deletions(-)


base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
-- 
2.50.1.565.gc32cd1483b-goog


