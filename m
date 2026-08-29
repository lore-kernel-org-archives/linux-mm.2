Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6340C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A08D6B0088; Sat, 29 Aug 2026 13:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951136B008A; Sat, 29 Aug 2026 13:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B3A6B008C; Sat, 29 Aug 2026 13:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5955D6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:11:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BACC3A015D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:27 +0000 (UTC)
X-FDA: 85154948214.14.ACF2BD6
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id F11DD180004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMwMb+x+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788023486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5baizEik9LVqkqVVxQCllEe5i/HuJak1Rsnjhc2TfXw=;
	b=aS1CJyASdo2ipins0FK/DkIOwfefGsqPijdv8HgMK30Xu9cHUpjt3VHgt5K6yHZzKMNYB4
	Or35kW3S55Ts+Y6ERzJB7sAWbMUawo668njaFHbG+BUNLRVWAsz/gYZUByhl2/P1kmJNlV
	9MMXYgfjsbYj+WjpyyDWQ4s0T66YbAs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QMwMb+x+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788023486;
	b=mPivHJcNEqNMycp+OLhnPEn2GdwHaipcTxvmMcrUw2jUr+iqmUzSnjYAqbk2+qrx7l2/Js
	goirwdW8uZa5H/A1Rk8DorYKaMy30BzoHamo55zApnwTtkrBYPkwf3Fr+V+veUv/hVJoVf
	6Ktgm63V4PLnqQ366/41ycfGqSnrgpY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so22701485e9.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788023484; x=1788628284; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5baizEik9LVqkqVVxQCllEe5i/HuJak1Rsnjhc2TfXw=;
        b=QMwMb+x+8AKq8VZwcuBYn3jobSGxvXDtyny+aS1N/NBe4VuwLpZZgV1gIo+Z7XAFgu
         UeYVLnN8XNduYn8iF0b6jRoCtjwHd6l98Ux6t8M00Ru9YsVX7sC+YWhf7KrI+JNrA+aQ
         jgJnz8UniaA4mAovrTOk+VZrJcH2CK/OiUsiAFk4XkkQ8Vrlpkh8i1KQgM+niY/cfBcL
         rXZNg29pigViemcq7VoUv2E8oeeiPrXsrCd6IJA39nFrkZ2d2CYnaHvAfVZM246LL+qw
         0mNVorfOhWLBm1T6yQIr0iSfbiQp5/T0RXuKIZxU+9oIENLLqAeSmvOFBDNxeELGXqEO
         Dzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788023484; x=1788628284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5baizEik9LVqkqVVxQCllEe5i/HuJak1Rsnjhc2TfXw=;
        b=QvJBNKDhUCJzLfOGvg+zU5LKm2f3g7LN5177GEZBqMh+omMAFKRpz5sYbKlFFIxm/9
         iADOC7Y4KEBNza8IorQ32y45Nd5OxTCZne2pVm7f9HLFBnLJtbiHi9nPS6uNlBG1SWbh
         z/3lcnghF0kbPfGac/rPkPLORnWZBLjhcki6yS0TXGRkv3Mz4y3DwgMLB0T1lwkxEAch
         hUTs4blec4F8POoIi42uqNjKrwr9RQXy/BqkZ9hEUdfQzHyS2QMddl3+igaywZO9DWav
         pHA64c0cgr9+UnGQalx40QAyYF3PaHn/NpJxTBWC603xsjYSkk/XGtDFbrF8QyKBHPtm
         4gXQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxzXtt5Zlm4DOWZQZAe0AyTPiHB70V2jJvKGH3/M9CsS1517JpzmSTuJu86Apr6LdXDnuSrm3lag==@kvack.org
X-Gm-Message-State: AFuF++k7j477e1qTQ9/YOxj/8OFgm7NM0M2wcLgcJq8kUOZ7UF3vCxGJ
	+K2nWbEQF0dJ9pwUUKcshGOcyfXE6drY1M8K73T5qfq1mqxwoxjmVcbG
X-Gm-Gg: AR+sD11Cfaels0O+SAw4U4tf9PFlV3luTjk8KL0snCymdLbVNBUyHlXxyFrugd3cnW8
	S9/vSFDekJuK+ICAqBIFKgaEHgcz21DK6Of9kLOniGUYcwSgS0XV1n1qwEdJthkhGyDpRPZgSaF
	GzxeNpnuzsa7wx+8O2KrP0DrdXt2FmJ06PWJ2yHfAgsjNoUaGfJR/vuvhy/CQil4B2OMYbuTtUv
	wkwNtdxU51zrRpJpxfrOJse3HqcAVn+WZBzMUxpJ9SOQTgzItR+xIRxPpVJK8vg/Lmza/z+aeJ2
	H8NhjnzWoMX9xdKzG8vbVff5y4otbXrTseGISp+xUCIXV5P0HttxrwVINxIMClEOcOWA49+4Hez
	+kvt4cu55CKbEWEi9P1kO8BGDEt3hjHh/lVRUP0iuYk0AL1YH09O1qiJyyxZpcku//cYb+ODpRt
	xdbxxUEjml0rewkcnsjBid1QmWRUWaEPNibTbHsydgU7uS8W1wlzFOEZk9JJ0iRXfWSe/Po2sS8
	n3LzBxCbQ==
X-Received: by 2002:a05:600c:8411:b0:499:4892:d022 with SMTP id 5b1f17b1804b1-49b91c279e1mr256215865e9.8.1788023484059;
        Sat, 29 Aug 2026 10:11:24 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a06:c701:4cef:8600:c993:2682:3ff:b27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c7cfsm154861105e9.11.2026.08.29.10.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 10:11:23 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v3 0/2] mm/memory: improve insert_pages() error handling
Date: Sat, 29 Aug 2026 20:11:11 +0300
Message-ID: <cover.1788022178.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: s7u4qzb5f3pmti4u9di5y8queifs5uut
X-Rspamd-Queue-Id: F11DD180004
X-HE-Tag: 1788023485-94369
X-HE-Meta: U2FsdGVkX18PlRvlQlI9sTg5C8qMDkp5+HGFYTbtNqraGKiwyumH55E1Jg5Vm/5fN/cPuCuCy6RqXLPXSz4k1Hh4qPIod8DXZYwm6HFfReLm0bWdlyqH/cTvcU4dQk0XJDxgePkW4dl2kD2xlSX2FwgBt/7bKpb8S23Jye6ZEfOwFch4pQImmtXydqC/hlbzu1yveK/pmHj88jfmJ2hSLJMxK1Q1s0I8ayQS9z/KucdKpN64EuSrcI5S5XYfjceBE0AXL66gdRBY9j52hHsQfcvLPlX9fO0XbZTqVUvZrHR+7W3HAtiuoquclo3GwciYmB8wL/ZIsQap47qt9MWlw9Jrx71WpU1ag+5GacHu+x38rasGlOKEiVxhD+YEwF4quFV5jolv/uek4Mj8jRgylB2dy7iUj639BLyH2TzBlYyjZf/QP2bOCDrMhxW0ChpDhOBUJvN8WgH8X4KJs0HPemC13Lz65LcRqhPgIW3UY0tXViEfQcSN5bOodnC/O5TOleFhYafjKap/azjzxfufzn8feJr3VeSDkf0PoD3dReDiIWaad31ULf27vZ7GH/xEMNuWQ+qTONpT6hL0pvqqfZFp4JEQvHswYYRIMDv2XSgKgu1VBdg2BorFee6/yVJXMv5Ny3KccPN9ohukOrYCK/6kyNlz3UAtkTUFJJw2n+gzAaIRNyufWhuL/LWNlGsOLrUpO5e994K1IuWahUHH5IewY3TvOnmt2xsGx2x4YnMouRyLLN9EyF1qj6sDa9Dg0pe0sVflj2G8dCx51ndYTdIhmmtQzti3isBzSnXFeDvMl/aNvj2P7Ffml4N3N/LCgIUL+opvlvtRS6vJEMP1PYcN9u6lKs8WsxD7TPXZZkh/9EEQhqONHMcDMSreLc9t44CFtFNZ4cO6UT1LjKv9WG67za3sDbsbv9dxMjPP/iotTCYM2JSm6c8i2DIH8pjV60kmMjKfYB0TlOYgEcy
 Q6BUfdO3
 aEzW3etl/9GfNKZAPsK6RCPQHRY/u17jfUykhqeNCDs2wQA0Laspjnyops0668b3l3u1j0BX0Smhzyc2eHcKJrgk7YE4Y/yC3cDKp213witPApEH7RbPSXUOtgTIyvXFz+IJmErw85os0i9rfZggTpBwXQjmm3n3q6gV/F/3qIBk/YxHSHWuMn0JLSNHMdv+XHHum14wzK+zaQxAMbMFDbO+c2tcK9gl8W/AFpC9i4anDAZ/5txJhLFcbRHKhC40/ThKRUEAEdp9CBbmZQwgsDxVS/a4ZYCgQEKVJV7DoWH1vY2d07TIaenPMXR1ygAwJq1TG5m4c++K9CUJw27vLEDU6u9bhWjueLudzwv1CaaZ4ducMjm6PuPsmIhN7i0Zp127NBZtvpcsRAqMTNcd4fFt7kPtwV7d0TUAHGv/4rEV/9pPlghszFJJhlQxEOFnQD1Ua12hQCzTJ6Qdk0Pyx3Ej6LGf4cG9QydBzhKqJ5Z7iPajaoMkzj+cL+D4f8H0m/TiNQLaV+arI6Tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve insert_pages() error handling.

The first patch simplifies error handling by initializing the error
status to zero and assigning error codes at their respective failure
sites.

The second patch returns -ENOMEM when walk_to_pmd() fails. A NULL
return from walk_to_pmd() indicates failure to allocate an upper
page-table level, so -ENOMEM is more appropriate than -EFAULT and is
consistent with the subsequent pte_alloc() failure.

Changes in v3:

* drop the walk_to_pmd() rename following review
* use the mm/memory: prefix consistently across the series
* carry review tags from v2
* rebase onto current mm-new

Link: https://lore.kernel.org/r/cover.1785847364.git.thnkslprpt@gmail.com/

Avi Weiss (2):
  mm/memory: simplify error handling in insert_pages()
  mm/memory: return -ENOMEM for page-table allocation failure in
    insert_pages()

 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


base-commit: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
-- 
2.43.0


