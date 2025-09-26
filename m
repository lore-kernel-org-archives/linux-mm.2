Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E7BCAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166B98E000A; Fri, 26 Sep 2025 17:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E628E0001; Fri, 26 Sep 2025 17:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0548F8E000A; Fri, 26 Sep 2025 17:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E770D8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:16:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8445FC079D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:16:59 +0000 (UTC)
X-FDA: 83932661358.19.EB27D3B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 795074000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:16:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eHbkpEr5;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758921417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pZu6gR0HqznnFJ7wyYHzy7twyjelDSGtnmT3D9hiRco=;
	b=cKhkmH85kWj/j/1AnR9QAWIZ83OFE8QKC6ktcE+BiEvwS8UgcpGa4zIuTQChpVUZ94RYHf
	BP8Ee5cfEEq507MMLmLFNZLLY8i6fWh4HRH7S2ecOsd5nUTm/8H32i/TB8zWq3PrVzxXwZ
	Pr4qB9CKCsKSqJs4lUqddGu2bkICZ0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758921417; a=rsa-sha256;
	cv=none;
	b=VOA5pO3m5lqibFBkGdLbmqs6MYDTqCUmb+fqvxbZBP+DVCtpiBjGFblSuqwu4bnlmTCfMv
	3mVdd7+7ReEJEk/kab4V6tcTRvKmAbOwRAlXrCVIA1WH3vvPD9YfHQRoVdWqvQslO0Xb7W
	CaOOFkTsBL5ZXb73vZKDK/qQmQP2Lc8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eHbkpEr5;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758921416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pZu6gR0HqznnFJ7wyYHzy7twyjelDSGtnmT3D9hiRco=;
	b=eHbkpEr5SuYl1jpdXrA5nn+CU2Y9AWayuzDJPIyQW9dxsCOv5tzAx2tEtfPfNbyhHE0044
	rBFCYq2ThupOBhj15oNLzb4Pr8Pfgfk8AwYRMQ0e2PmtGM98OFGIjzm6VoBHtQRkN5A2Hq
	xwkCiUt8gghsoyVHpwiS5N+s/khBG2c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-2lrWv5-DMsil-Uqas64CBw-1; Fri, 26 Sep 2025 17:16:55 -0400
X-MC-Unique: 2lrWv5-DMsil-Uqas64CBw-1
X-Mimecast-MFC-AGG-ID: 2lrWv5-DMsil-Uqas64CBw_1758921415
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-844772ccee9so528183485a.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:16:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921414; x=1759526214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZu6gR0HqznnFJ7wyYHzy7twyjelDSGtnmT3D9hiRco=;
        b=DpX3hIc99AKK067msHH4ioq8vM1SEbbnlG89fyi5CgICG/EC0xW7rs3NwYsjIoMrz4
         sJfg6zRW90fJUosORfoXcspJ9raOViUaVS9Lzb8RfX/LBiEQf8iqR3riylTon5Zztm/7
         1cf/GFBNV+EJ/3M4JJ7Dn2v+52VAnEAqyhJbA7M2qYumD3I4M3qy7w+eATx3Ts86qphQ
         z7GbYYizz0dDmRHMIj1cJyVJbuz4KofsrT00DHprqVYfUUQHCv0p8wQ8hhm4NVgvNs/Q
         GAz8pIFqTCupZ4O5vWKsj47vgqLBOkLXWV/i2OH78GXJ4MdV9pweMthgvFSJdUYeckkt
         9N5g==
X-Gm-Message-State: AOJu0Yxy56Lvk2OqXQ2ivkb3qRa/MUipykdepoJHfEwYzuOPSP4WWkUF
	eAkFd9OZNNiksYrav+9ORP/gVDGkDGah5xVtgBsNNW8JUdZeIDJdkkh7EN9CVzJiAjZJO7lXUBx
	ifmam2UbJOAYBNr6+iR66W73Z/n0FPe71tIyhradWJNZt92x6xU/KiX2bQxulckBhoS7QO8IsfU
	xULvhH2di9p4FipvRHKURVBR1iqoaJ6tItkg==
X-Gm-Gg: ASbGnctsxEOaHdouFVaxoodgQo234zy3pNlFpSuFbKyckJnKW1GTw5fSJpv2k6w/877
	wT/2DIqKJHosusIvEkms8JWw2XVMjRb1LG7N67QylzIzM2lf+43DZ3DVD/O/EH2SdDcf5kTQUxk
	3RRGaE8QRp7dJScHNILO/EUmgOWyya3tKJt81n7BVwqOi7DP9t5TKiZCWB/1EcgObL0VT0zqegu
	PGxBimX0TxX3kobBGljVBxbPuMrxOW8XFMVEF9NT/KWrcjzb838u9LgK1GFlPTjeB5SeZnN5yGk
	88n71Ut2vd0pZtZh7Ek/K+IoQkABtg==
X-Received: by 2002:a05:620a:4010:b0:844:9c74:e839 with SMTP id af79cd13be357-85ae0dc231fmr1383426985a.22.1758921414461;
        Fri, 26 Sep 2025 14:16:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiAxabx7r/K6xtC+G+7Mvff3t/oz7JvM0JCJVRVTnSujlCH49LXQ8vENfM3WuriZPZ3r27Ig==
X-Received: by 2002:a05:620a:4010:b0:844:9c74:e839 with SMTP id af79cd13be357-85ae0dc231fmr1383416685a.22.1758921413650;
        Fri, 26 Sep 2025 14:16:53 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-86042e32249sm210604785a.44.2025.09.26.14.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:16:52 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	peterx@redhat.com,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v3 0/4] mm/userfaultfd: modulize memory types
Date: Fri, 26 Sep 2025 17:16:46 -0400
Message-ID: <20250926211650.525109-1-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cqaEw_EdIA7rXrTvtUWuxvYFO7wVcSq9OZpntjUo_gg_1758921415
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 795074000D
X-Stat-Signature: dxcex7yhzaa8kxjd4ro3mhud65rd3x58
X-Rspam-User: 
X-HE-Tag: 1758921417-341370
X-HE-Meta: U2FsdGVkX1/i0khrDDUC9ucDP7ZlVqlDYS3kvkYDbmoDmEpzUP5Mz5waQM905P7mCRjwGxACgfwtUCApUe/9HjGiHlVubV4XAaR7HMIlmXiqfYye7gZ0kbXSHmDo4ebmRw/3/MsdIMKGh3Vel2wE6HwGc0rxBWItIoJN+m3joQRqqlsXSA1luF41R3sLk99k+CYt/guDKzBwvqgig1QXYg6Of3/k5AhE9JuXS0P6V+yQwelMopA5e83QAecENyjPQpyUcnsiCn86sOrl46o7I5E8dBmNbHXBo1w8aRaVURv2hk6g4M6qKKknYcF0toSkp3648KzsExNODbuW9LJ6Th14CsF87MT4Z4+FMDZ0+lBT7IcHUez9KE3A1oi1SJ4iBk3Gc47IkYgvHNYES+vUYeFDRDpSJXPGHh7lys94tV/zx1haNaw2Jo4o2t6JFLPHePNeVA/5dEBTjz0Yp4b+WLFnlH8GNBNEkVyocIqFNQPOORotmLBtUd8LXm0HOBKhfOkdAkV50Vdt8mNwmMCHJycSxTE47jjDWP9IbpPUueTfD03Z+O5p4LQ5OzezXDwQNUn3ywZtRqeDR+tZDgHuGIFGSvWWWV+yvghYk24zZAZJskpXpYVnLhRVWTnyhPJKR0w+BPzQzp09RKBo4L787X/G81S5lgDsXFSM6hpujuZcR7VmxW0zvXe7S1Fr+Mb0D1aW8/RHyFiH8xFsiQqojDpzguc76uADYLSIQNkoPkppovViwOCXzGjdaayNizx53nZyaX90cQd2xtIyPuJ7TGOoO4h0iCaH24CvBB+2YeoLMaYpxjgO6PO8NRngbwiRFeZJw8nQn16WvCcVwri3GcD5orfARC0IhqAA/SdxT9g3s7/sKG1l7YH4SOFpR6bZ3nouCbrzeeZ07PJZ23yxrk9Elj1kgr4Rc8VpbPqsb+xqfYzTi1OpiE+2ZRWkohjcb5MeKz7sz4MYagtx9oH
 mIDgzBm1
 Aiy3Zpyf8lIslILbMbXA5r/2eWlyL2fRyKcFi7xcx57i5vZFVlExbHEEsHjs8VhQEOv78ZSdURix6MIhJc0l7dULrwSpdLxjAY3q8Xw3W2vCPKCEcREcs1vHxCn7OzHpR5MYk1b5Mcvzuo0l5CwlP9NZfZuZxugOZ5fgOZ4ARQiN2rQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[based on latest akpm/mm-new of Sep 26th, commit e612c80ae0aeb]

v3 changelog:
- Fixed checkpatch issues on spaces or typedef
- Dropped uffd_copy() API
- Refined commit messages here and there to reflect the removal of uffd_copy()

v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com

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

static const vm_uffd_ops shmem_uffd_ops = {
	.uffd_features	= 	__VM_UFFD_FLAGS,
	.uffd_ioctls	= 	BIT(_UFFDIO_COPY) |
				BIT(_UFFDIO_ZEROPAGE) |
				BIT(_UFFDIO_WRITEPROTECT) |
				BIT(_UFFDIO_CONTINUE) |
				BIT(_UFFDIO_POISON),
	.uffd_get_folio	=	shmem_uffd_get_folio,
};

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
 include/linux/userfaultfd_k.h |  83 ++++++++++++++++-----------
 mm/hugetlb.c                  |  19 +++++++
 mm/shmem.c                    |  25 +++++++++
 mm/userfaultfd.c              | 102 ++++++++++++++++++++++++++--------
 5 files changed, 181 insertions(+), 57 deletions(-)

-- 
2.50.1


