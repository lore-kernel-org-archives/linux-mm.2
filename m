Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D58E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8367D6B0089; Wed, 18 Feb 2026 12:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783046B008A; Wed, 18 Feb 2026 12:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618966B008C; Wed, 18 Feb 2026 12:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD956B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:15:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFA161B480D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:05 +0000 (UTC)
X-FDA: 84458227770.14.24841BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90B88C000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GFRArwak;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771434903; a=rsa-sha256;
	cv=none;
	b=ZMosN8h81zymYz6bbv6YgojO3MbR9GASXWRg0DO84yjvaNiogwZqBVNA0t0un18+Ti1HrT
	QRjvW0ydL5YPbcL4NPUOMHj48lk3RSJbVmlJmLRLf396jUfKKNTb1zEx9S4C0GoGktjAS0
	fr22yY0O+mn52OwO9OfWq9HHBFy4NEY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GFRArwak;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771434903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xm1Nmfmv6nKrRksdRVhDRN/vEcg8hHt9kLWtxxaZhMo=;
	b=CqHtgPxQ4Cc5C6kQ5/dEPZYokeK1ycYsEvxVc5y6Ff5oSExC4qdBoeOtK/w3pZAi+nejCT
	A02ASO0uXiHekspGHIIfNwvdZZWKepm+Oy2uKtochodTa0buqvIY8CY52WsMMog2DhnW/4
	Xr69kSrQ47chMex80NnKbOrxmolbf20=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771434902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xm1Nmfmv6nKrRksdRVhDRN/vEcg8hHt9kLWtxxaZhMo=;
	b=GFRArwakIGUmHbFQQBYzKRPvbeC2pXa+ESHx29ECN2qsEZ1UCtYXIXi1beonkSTn65NKju
	MhCU+jDnHsYun9C7FZoEJMQP4hBYCxP8nK0tPOt1b7nlFGlk1fPyGBFIWY3/eS5sk8yFHU
	0F6K0IwILzubU8/CVNoxhtwR+SmL9xw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-UdVPV-vXOjeC57RrzbzAtA-1; Wed, 18 Feb 2026 12:14:59 -0500
X-MC-Unique: UdVPV-vXOjeC57RrzbzAtA-1
X-Mimecast-MFC-AGG-ID: UdVPV-vXOjeC57RrzbzAtA_1771434898
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-897021ebe91so2809196d6.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:14:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771434898; x=1772039698;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xm1Nmfmv6nKrRksdRVhDRN/vEcg8hHt9kLWtxxaZhMo=;
        b=BhzuTnOGdiR80+6HJPmrsLoWtd1Y3HkkAMQAFU9SVM6Jkn7qTE54dC8r6/eAPWBeqy
         Ve8/GG8dxp5chq/lT/5E1OMURoQ6vZggLANo9gp3hhbrB0JN3KkrHRGABi70vU0ftz47
         vP6qaImzMNYQIz0V3r6gRAxqnmwrcVvsmPRGK5Qbuu+pEl+Ck90VY7ThoIpO3qWJcE94
         7uxocWFvgB+61CIu3t4/JjYag4QGS6cFLqFC+eo86dXqaODfZPGROY6XgjT7nJmWT9Bd
         xDurYbMXvK8pvQc3f1/HZAJu3jqe9vWgcdstrY+LQtRcNP1hBJopVf2Ibg8+tCW673hE
         5y1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcN1yY07o/8tLG3KD59LYWJo/Nei6SALsqMFmo7kLfsN/dNQlO1Qwyz4NKGTrRb1eE13mLBQeM+w==@kvack.org
X-Gm-Message-State: AOJu0YwDs18x1zVnyNAMbTfSwg5FHXdrigIbx0WQZgjLvg2kBjJUcrm+
	I/+VaCz8TwYCc/6pk2INcV8CalwTmadzWRaLPNy6Vw4SkR2hTq/Q37x5VhgURytMQKNfoHWX48Y
	nNnCAZn+0f2/389H2hPYHJPndpORh4dQelebrGaISpqJ0xBWfE2Qi
X-Gm-Gg: AZuq6aKcWKTeXPns+L2t4suuCOVdnjZb9M7JUqdne1fEkSMrjJ8m6Uoo2SsTMFFrW6T
	pssL5T2EyC1WRqIJRT5qDUtMRF5YZLVUlKYnpRRBlKCiyeqrukWwzGHqBG6M8jM/7tzG2speDYm
	1CLSs+hmwqI9fJ2LCd42m8zKSSICShvoWgAayyXK7v4HU9h0EURmnkslLQ4hgWciAYkxf8wkb6B
	Q3DDWvbsyo24nwmjGZhZQnGyqe4SG3DGrYw2XhAggbTHQZGjsWV8AusLidDu61S35NKXXSaq4Yi
	digr7dKY0oZEiPen9qbPObG4E7MOFhxcltm4kvHLc/HrHEDNarqBRceoypkt654LJJnzWBTGvuy
	QhPsLai2vUsglLvT7cuiPH0q+9pgla7k02ZUgpgIg39shIWrcHd8xAzT+kd4hzys=
X-Received: by 2002:a05:6214:c21:b0:894:73b9:d31c with SMTP id 6a1803df08f44-8974047b86cmr215132986d6.33.1771434898346;
        Wed, 18 Feb 2026 09:14:58 -0800 (PST)
X-Received: by 2002:a05:6214:c21:b0:894:73b9:d31c with SMTP id 6a1803df08f44-8974047b86cmr215132386d6.33.1771434897854;
        Wed, 18 Feb 2026 09:14:57 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cca6fddsm186357896d6.19.2026.02.18.09.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:14:57 -0800 (PST)
From: Eric Chanudet <echanude@redhat.com>
Subject: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
Date: Wed, 18 Feb 2026 12:14:09 -0500
Message-Id: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NQQ6CMBCF4auQWTumLQSpK+5hWIx0arsokBYbD
 eHuVuLS5feS+WeDxNFzgmu1QeTsk5+nAnWqYHQ0PRi9KQYlVCuk6tAEuj8tOqYFx0DFHNA2Ugl
 SxjbUQTldIlv/OrK3odj5tM7xfXzJ8rv+grX4H8wSJdZtc2HSumat+8jG0Xoe5wDDvu8fvz0pl
 7kAAAA=
X-Change-ID: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 linux-mm@kvack.org, Eric Chanudet <echanude@redhat.com>, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4XQ6mStzHC-LT5iRayZCRwgrx4RPpNk-3A2Fgdk_aJE_1771434898
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pbzhn79q3k347dztixsat939bsu773sj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90B88C000D
X-HE-Tag: 1771434903-327801
X-HE-Meta: U2FsdGVkX18muCRaBYa3TdLWWh/pJhIqZsli9t1/+w7J9r5UBqbYqP7Ho++UdArohtvfmON5Zo4xYBzIdlb8FHO252c0wxoV/Ivq/Mz8swdLZTSfBs7URpa9QtWZTkdFmG9vJVyEMjD16/8kpAQeE3rh1EtQnYEnvi98005V7i6AcZBOkFjBPEkXmp9bb+EG3WPGyHQJATxd2MxjlmVBTyJx0CLbIjZIeSbVEZR+OG+LISQEdeo7/GTJnbHTPQjGe8cxx9DUa+FoR3747t+6WqDbovo8FOEwfrm99GCK1S68HAp6g8v8yjj3cci54znaKp06eGcbTH5H1JXoQGpVf5PS9mal4Ftf5grd7U5IW3s45k0PvFTYOvUnY1F8BrXaijO0pdYNJqNrz4Z+H0Ih6rhstC6E7s2uRrvnzVnRCjmW2K6OUOyizVfgqvseK1rcq2iBUgLzN1SXOsLrqiRzXHuTmXJEhwkiIGz+b4SYaY28zyfVw0UhjHgi5Y+cBJ5dfvpLvymjMsuoPxBzZlEu7lwwm0bOnh9ZB+KQBI5TMiJeiVXoB5ouLWTn/cVd9IE/AmN4QwC9zOUirchfsZwj6ZL8860q0VCkZjr+LiYNgxtvP1V93KBGJdXVyK0xkIKhLIut+n+j3Hw18X/6r1aydanfoXH45tYtrYsEbpMrYTYyzKv+K0enDw5Hnx3Ea+efkOJhL8jImtYvRhLCLt/tbX8A2NKuqZnqq+aAWy8yfvt6J4FNruGcpPIC1/Il5ObRojdTyjo9LW3TucSd6KMqWaUsiee0osVdan3NaW324aSqLtJW6hLYERIAwrKji9izEpS2XE7jRy+0w8vT5Q9jZtJ/C+ePIt2+r0h73Epr7jMEdwEe2pgsDV8oL1PpMY+BA8Nh4l6OFT1pdyqSwgP0QYk99otuWLO6raZpbFrsxmQG90Mo4mGHGZDuaMBHHkJM7XX7RL9nb4X64ULl104
 8J8z/+uY
 7zyC1K2H7ZXjK5cFG1oisfaJ0jsDr1xHZSmMLiTy1SVQoAypqGHUZgPcPxVS+pXt/IZXI0xXIbWY/t8M7fefdk/2CegQwwVSn1QY0ipHCNGtQXOb7tycT/u0y5HI8Why+nmJvtRpsDxlBon+Kx97tHz5yYDPDHT0ukFumAyMf3y8FS6/aYA7X4SSqQqxGp84WXhgl7sEZ/0JSVVqU+jP4EcIXq1LWctPzh0NShQHe1Ams7vUln8Og1f+I3m0aLx5Vf08ng8vZt1K8EX+Snz193zpii0bSHRYFGSTEUWRd3nh+eQVAGXINltgKF8RUykhs7RqYTXyDnEvmQEXqKVazjKpsKBzDhbAscbzdyEpIJvB+Cx74HH9Hev0ffdNGs/P+5sV10suxs19Du/DjvKfor1N8Zm+U4qo7DfsZmA8CAv1Z5NAjXEHuv1K4X+Ps5jSO2v8GvkTZC5glX4cucBWgFN2Bi3EkjS/ZsQg8lI/fQpZhztk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An earlier series[1] from Maxime introduced dmem to the cma allocator in
an attempt to use it generally for dma-buf. Restart from there and apply
the charge in the narrower context of the CMA dma-buf heap instead.

In line with introducing cgroup to the system heap[2], this behavior is
enabled based on dma_heap.mem_accounting, disabled by default.

dmem is chosen for CMA heaps as it allows limits to be set for each
region backing each heap. The charge is only put in the dma-buf heap for
now as it guaranties it can be accounted against a userspace process
that requested the allocation.

[1] https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
[2] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-0-ecc6b62cc446@redhat.com/

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
Changes in v2:
- Rebase on Maxime's introduction of dmem to the cma allocator:
  https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
- Remove the dmem region registration from the cma dma-buf heap
- Remove the misplaced logic for the default region.
- Link to v1: https://lore.kernel.org/r/20260130-dmabuf-heap-cma-dmem-v1-1-3647ea993e99@redhat.com

---
Eric Chanudet (1):
      dma-buf: heaps: cma: charge each cma heap's dmem

Maxime Ripard (2):
      cma: Register dmem region for each cma region
      cma: Provide accessor to cma dmem region

 drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
 include/linux/cma.h              |  9 +++++++++
 mm/cma.c                         | 20 +++++++++++++++++++-
 mm/cma.h                         |  3 +++
 4 files changed, 45 insertions(+), 2 deletions(-)
---
base-commit: 948e195dfaa56e48eabda591f97630502ff7e27e
change-id: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8

Best regards,
-- 
Eric Chanudet <echanude@redhat.com>


