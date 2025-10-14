Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33726CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 23:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675DD8E0119; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DAB8E0041; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563AD8E0119; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46FD68E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 19:15:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC1F11B203
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:11 +0000 (UTC)
X-FDA: 83998277622.22.F03A8FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A9DC510000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:15:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fbjaN9j8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760483709; a=rsa-sha256;
	cv=none;
	b=7DJCJ5G4Gf+xXsqVM10HkRAaO9UcWvJKATXj2SOneIOLxOalFnEP9/OhxKbzKKrBbgV8k1
	meXjc7j1vSPKf3VB7g7gSVGQWYV5bnKTjyh552Z5MD4gyIjGCLvC+zj7l0kd2zmVS9SQik
	l3bBlfIy6xGruM3B4bG/TqjXIumQ6Bc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fbjaN9j8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760483709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gkEesdVP5klvagCiPua/4aXkAVndt2miK7odjHhrzGc=;
	b=k2qIG26ydBQV7QwziASEtWK2/q3toJYknnabfVYtUOkzqDF9q9Q0QTe06AGLUZTysaxebW
	FirBBcj59LOe+gQJWEb+1olVxT6kjo/UkHkCeqEGmkXWGK1aJy8Y7Yt4w4NPEaXEzHvCQN
	1P+kDT732C9vx+9Zhz6TRWZFLTMc73Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760483709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gkEesdVP5klvagCiPua/4aXkAVndt2miK7odjHhrzGc=;
	b=fbjaN9j8Wqzy+oxzcrVWHIzVLrzdEddPZ3na0WHwUnoxhvFXAZ3N7rpB8Z1n6rqkBMEpzx
	kfbUageF2n4CDRMX1Z9ZYYi0w0OGH+YV6TEMBlZ6Y/6E38l5TbHbUXO7f9V4j35mPoRthG
	c3Y16V4D0+B9K4BaHO6uONdiHwn+PeQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-c-6dpkS5PWyW7exgolbCQw-1; Tue, 14 Oct 2025 19:15:05 -0400
X-MC-Unique: c-6dpkS5PWyW7exgolbCQw-1
X-Mimecast-MFC-AGG-ID: c-6dpkS5PWyW7exgolbCQw_1760483705
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-88e133107adso72896385a.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483705; x=1761088505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkEesdVP5klvagCiPua/4aXkAVndt2miK7odjHhrzGc=;
        b=dvqKEU30N1L8pLXh4BD51qhD4AxRk1jPQluqmdjKBTUG3h/9C7ZCIsAu78AjqjpJMr
         oDBzj6pMMoSSttR2VXb9zjmsvFNViBUXnBeMtt+Bakg9Gnbp10ElSmPBsBweqpcE9Xoz
         X1IYlJd0P8rh/k6LgTYjHaFrM/m1LdAiPO+hc6bhlHt67EqKG5eBO/V00RZ4gHmzhtYN
         VNcjwuXp32NIJfVpPCFs6IOhz9M3cGPh5xEDrglhz2V8j+Osm50MY5NUjPo3u3jdcIwy
         6XdZdyeAQS9cdoUmtSGX/ncKfdgbz382x+qFmpAGJdT4uP5esEJ08m+1BSX7+TvYH7Fo
         1Ldg==
X-Forwarded-Encrypted: i=1; AJvYcCVdWtQM9AcwOpALhh2UbCgE+KL1aGN9MZiyygQQZi0z3krK76NbPytaep0cNuioXPRfCxPsDRrStw==@kvack.org
X-Gm-Message-State: AOJu0YyUeSBTmM/Mlt1iT0MQa9jPRABxe7Ncs1Sjfrr8VpOhWiwSCUVx
	uxGcvRFDDPN2vCgscpeKNVDV36kVQsIl8Pfghzl06STTXhJtelS0REnMT5rTXMxg4s71hWcEMKf
	bv8WEIRlYDXA5lSaVLbhRg0ZaRdh/pIyiB/xAN3nJDlXlQnyt1h5f
X-Gm-Gg: ASbGncu1j1CUuHOVVECIhzi5zTNppu7/7ch7SNSr7H98MOnmsTCTURtaWjgi/qBVgJi
	JJGtYEFD5xSpXqvlKRkbXPrhRXZPDh/Fd2C4f6eUl482AVdi211kAe5iK7bw4WSU0cAnu9zVF/1
	QgGOajAs6qOwHXGaZSz+HNoLdNQyBSbfOc/a8b352gD2LTJtaSFC1iZB3R3D/WdaHNOwbeI6CGI
	HXgP+nzMtYgVtT/as28te1ZVrlmrJt8Vltn9EE+o9KC73Ugq7ItoLsUFfBYeYrF24IPv19gG/1V
	x6Roo3jWnWfw8mK6jCeVwber3Y36mw==
X-Received: by 2002:a05:620a:3710:b0:82e:ce61:f840 with SMTP id af79cd13be357-88355a557e0mr3109207385a.84.1760483705027;
        Tue, 14 Oct 2025 16:15:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0p/fJJcRO44NvHEwHC39Jn7HH9sdaldnpLK5FANmX+q1MOcaF1/2rpEijkCSasuFRimulfg==
X-Received: by 2002:a05:620a:3710:b0:82e:ce61:f840 with SMTP id af79cd13be357-88355a557e0mr3109203585a.84.1760483704583;
        Tue, 14 Oct 2025 16:15:04 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693a0sm1280258685a.53.2025.10.14.16.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 16:15:04 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Date: Tue, 14 Oct 2025 19:14:57 -0400
Message-ID: <20251014231501.2301398-1-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lyexqP5dWmLlPm2NJkz5bTnGlYRWYZ8WQ9FiGyBpqW8_1760483705
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9DC510000A
X-Stat-Signature: y9szpa5dckz6rnwupzb4j3ar5rueb5ue
X-HE-Tag: 1760483709-705190
X-HE-Meta: U2FsdGVkX1+2IDT3bMUvgXQj96dZL2IovUx4nSo0JmEZawsTknMA3T52TXfYuvW1nb+34oTZhrLeWtRWuX36UV1TVaJnIEoQW1OL4iPl0pykqmRN+/IrMOh6hgSDU9rVKE+KeQgLaN0uQc7wL6zGlsZKg9zpHrDMMcumzLfUz1+uUnsSYluv2izy+XAjq0gCYMs4r8+sm86PjkC83YIkCvZCK4+CH+aLqZ9fAgePueXt+RXn+uKoQ4+BZ177Yi1FibYJHFZXvTc7myyFaehijx9oAJtpGoz/vz6MGWtLNLlp9N0usze/CsDELb5GBaF0pmsAjwm3iabsSWBrYaXfHb3THDxBlIP2sKeSLI/TBpTHsn2vnz/Uovfix+csapQybybDkGBJ9tPMqSEOvcZ57Gc4dNida6rsugU3baEgth+cg//EAdYkTKS0p9iFbkhR6MdTY3J5yYc68jxNIVMuZQ4VBk9V468xDmjKhE8LIUUU5EgLaM2UACxF/dkzFztRbSWK9uYDp0JqWOfFZ5cqxpjeKlKDmFHAGqcZlI3IwrGXanUhNqHkqkbtMQC8r9/CzWSfRiC99IoP0xM6bTG5zv+ETRr2KURONBef+LB5OVQHYNEmlelxX5yVTn2MvwyI1uPFvNheY3voesdeYgKuzNC1BEbYPuT2tCf3idMrxAJOtRvEhQRe1nBfTw7OuPEPNeXIIep/63BfD/ISZdz4XO4ts901KTbJOnPuJq2J+dQlS5g+/rMlnOuGtzWDquqfBWuvQhPi37oWsC7QjLgKxGbGW9ZN3olp3ffDeAghT5mOnIrqVqCpe0kZrXYkP7n59yFq/75PTWQ4vEFjKwxaY7qsK3uwN3vQg7sCyxWj+ZoNHhJS/gYKOBKX6ehdSwBniVcYXqcrkOCMzkQ49RS712PM53aKZt8XQjajJazfvLBwIj/Jqpq/EevAn29kj5u/yeMW1oJgBEu8SOzc8In
 wDiRVAsr
 OeXl6wRTVBQE6qhpOOPRMWSWAfmpIk+tGvT+apGCztULUIoTx3L2Q94VRwIvufGT+Oo/TCfQ8jhujbuiiR98z7d4LJeszIsE39gSaDSlwDf8rszG4dC/aA0xC0c/pE89eEzlRp+wx4s62KqYFfdog/go8uLn6FjGeL1oetF590UEQIVo5kLaiRKobhX6JXWTTm69DI0zaih0zRy8+TAOFIt48e8Xedo/G/mk87c4YG3eHKYgEhrTVYP/vAOsC4Q7CKuYzDJw9q5Q/RUExSq5Gm2uRUOtyfcZjrpWSaKaQP+TDRZoy29FnXS/0A5Y1ZJHCYoZZdnEai4k2k+pNzEOOcZG5+5HJ7W1AdOfFfyw9HCHHASaOoNZOnnK9F2GlEdptDUAdNgoUxrj+XBVX8eczxoa2nJutMxN9kSPGgswt7AttxiA0C3T3cYjgQAQm7tZV1Zg6mEsJmprY/pb5iq6/aCWOTzfp6jZ8pqKeC0DSIFD9NB/2oEIURmCfJAJiTu5TN2DW1QrZlNY5xOrpZZtYNKyUVNpa0nIMXmF/RBhzDqHBwarVP/DU4Au7os/VgkPaHDWLUsioW64tm9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[based on latest akpm/mm-new of Oct 14th, commit 36c6c5ce1b275]

v4:
- Some cleanups within vma_can_userfault() [David]
- Rename uffd_get_folio() to minor_get_folio() [David]
- Remove uffd_features in vm_uffd_ops, deduce it from supported ioctls [David]

v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
v3: https://lore.kernel.org/r/20250926211650.525109-1-peterx@redhat.com

This series is an alternative proposal of what Nikita proposed here on the
initial three patches:

  https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com

This is not yet relevant to any guest-memfd support, but paving way for it.
Here, the major goal is to make kernel modules be able to opt-in with any
form of userfaultfd supports, like guest-memfd.  This alternative option
should hopefully be cleaner, and avoid leaking userfault details into
vm_ops.fault().

It also means this series does not depend on anything.  It's a pure
refactoring of userfaultfd internals to provide a generic API, so that
other types of files, especially RAM based, can support userfaultfd without
touching mm/ at all.

To achieve it, this series introduced a file operation called vm_uffd_ops.
The ops needs to be provided when a file type supports any of userfaultfd.

With that, I moved both hugetlbfs and shmem over, whenever possible.  So
far due to concerns on exposing an uffd_copy() API, the MISSING faults are
still separately processed and can only be done within mm/.  Hugetlbfs kept
its special paths untouched.

An example of shmem uffd_ops:

static const struct vm_uffd_ops shmem_uffd_ops = {
	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
					BIT(_UFFDIO_ZEROPAGE) |
					BIT(_UFFDIO_WRITEPROTECT) |
					BIT(_UFFDIO_CONTINUE) |
					BIT(_UFFDIO_POISON),
	.minor_get_folio	=	shmem_uffd_get_folio,
};

To show another sample, this is the patch that Nikita posted to implement
minor fault for guest-memfd (on top of older versions of this series):

  https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/

No functional change expected at all after the whole series applied.  There
might be some slightly stricter check on uffd ops here and there in the
last patch, but that really shouldn't stand out anywhere to anyone.

For testing: besides the cross-compilation tests, I did also try with
uffd-stress in a VM to measure any perf difference before/after the change;
The static call becomes a pointer now.  I really cannot measure anything
different, which is more or less expected.

Comments welcomed, thanks.

Peter Xu (4):
  mm: Introduce vm_uffd_ops API
  mm/shmem: Support vm_uffd_ops API
  mm/hugetlb: Support vm_uffd_ops API
  mm: Apply vm_uffd_ops API to core mm

 include/linux/mm.h            |   9 +++
 include/linux/userfaultfd_k.h |  75 +++++++++++----------
 mm/hugetlb.c                  |  18 +++++
 mm/shmem.c                    |  24 +++++++
 mm/userfaultfd.c              | 120 +++++++++++++++++++++++++++-------
 5 files changed, 189 insertions(+), 57 deletions(-)

-- 
2.50.1


