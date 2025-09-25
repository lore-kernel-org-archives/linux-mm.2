Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E625CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EEE8E0013; Thu, 25 Sep 2025 04:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6428E0001; Thu, 25 Sep 2025 04:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC068E0013; Thu, 25 Sep 2025 04:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F22E8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:45:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F428160397
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:45:27 +0000 (UTC)
X-FDA: 83927138694.30.6BE404D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F6E6C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:45:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z20Rq3pa;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758789925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXWTj/yjoOPAq6UeO3tE9io6RSG2iM/aBSBKIJ60TxE=;
	b=uOjdvuqoY+BUFnlNTVBjfW6/zAR4zFGUVqJsoWQYacRuokl6/XrVChaGWsvdv0sjbVaei1
	m3JOPmoE9+cAoAY5I7OP+J2o1CUvCK+BIYOrPRkAKhsAPdVK3qptdA2rfH2PYa8bjx8mvG
	5rk6hw6gEjgnx1HI23BAbqsbfCz158s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z20Rq3pa;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758789925; a=rsa-sha256;
	cv=none;
	b=aepAmEwwAk9WXSnOPjwpn4auKwLwBhqvmiV2z7qh9pfVyn+vRU0f3qpDIWDvxYFPKGPd6h
	Ux1abzs8SlrE6s05SIPgDViWP26tekUYYzsYrUap7MTBrDZ6doVOApxSeQkFFu3xeVG/LO
	ZROCB1KuVRx9cf+ySTMQQIWpC2QDbjg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758789924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXWTj/yjoOPAq6UeO3tE9io6RSG2iM/aBSBKIJ60TxE=;
	b=Z20Rq3pa7Lwr0iZ1zH/V+yNsuOUWgqjzoOb80dLmhO7NHbKNlrwNY2G4ssmqDPB+pKgdXp
	AlAzxAV275D0aBA1defAP+5bDvFzipONo8QdAjFr9A5pGf7GjpvLPmdvgxTyg/alsmmUCc
	bZg9Vy/UX81lcwKqSBpX2LT5+Yp+p44=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-GMytNRLcOUWlQ-09xvJB3A-1; Thu, 25 Sep 2025 04:45:23 -0400
X-MC-Unique: GMytNRLcOUWlQ-09xvJB3A-1
X-Mimecast-MFC-AGG-ID: GMytNRLcOUWlQ-09xvJB3A_1758789922
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45e05ff0b36so8191085e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758789922; x=1759394722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXWTj/yjoOPAq6UeO3tE9io6RSG2iM/aBSBKIJ60TxE=;
        b=eE2wnCadlXVFUMcgzwZHV+6KDZ9yAwMCmpybTOwx3gku1dovGGOYYs+SmDcr6CSh1O
         S237iuAVsouBm9CKvK8V6/G3gmKZAW6kGnEfFC7HEtEQKK8m+Nrje2qFbGPpETetYStI
         pIXHjlnmJwijJUrop1J600RsPI/ztEeGPwdLZrDbGyLwKBlxU6znDLJqrzgJqHG5qqgh
         GVMKYvahspOMF/v8mu2mKfOiDIr/tl1ClL8rnnbH+yrfonfgunlvGpL40osSxLKUtPAD
         V4720+c/tHlCDCm3cijXlbyGW128//KvJuCuVR3d8JOlirzx/T4Kb4quRWo2/0+rXgQV
         OS5A==
X-Gm-Message-State: AOJu0YyFoy+YZwzkDTY3SrCVpjSqnWR8tnKupNXa+M/hKEXKnCR7PAb4
	Udp7WWbmgGDtbmOXz0R58c9a94JfSa8Jl+JVyCcNZGkYun2NVd/PEDYwbCac4ncKbw61L6uyMkG
	tyU/g+O6vkjTtRn8sZB+IvZg+kcljghtZ2NF04AbBC33X9GzvJSy2
X-Gm-Gg: ASbGncvwLWka4jiL/NVW2p+fcUjbdtdxWi72Z4PMmwQ9+OBrrPMJeJN3dVwve5k7p0N
	RVSg1prUZ6fyBzvL/fVKsAUOsn8BE5+Ve8pzdDMMcAoSz9WjfISo2/SyyH44HXbFD8fLJg9bHDc
	8U4fqbE8Vxp2tJQg87Xac9vuLfnAClWci3kES3SGx1wUsoElPGv5IjylFUs6XwqWJG5AlOZCuRM
	5YxzPM2JxX8MDIj8u4ccqQ6TIn7oGusUOAY2ndtPJIYyr+NMNMSn4K2UvMMzsKTxrxwEM4JiCtQ
	qRFe7CRjQrLMZJBVfTvLP4QIwHsa4yCCejUbZkQQ2Q9opMbvUJ8vK74RcLFnCi1ANSKA1wL5+Vn
	+MaZBPocpzFtSSPl/YOh4p5GzEw==
X-Received: by 2002:a05:6000:2909:b0:404:c253:a38 with SMTP id ffacd0b85a97d-40f69ec9203mr1506534f8f.28.1758789921845;
        Thu, 25 Sep 2025 01:45:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHcL9mwBhqGWiSkjInXXSpBiC6FSEeywCyzKqbCEZ+E6knAmcc1tYAu1YNqhpk+XsmsE9KRw==
X-Received: by 2002:a05:6000:2909:b0:404:c253:a38 with SMTP id ffacd0b85a97d-40f69ec9203mr1506424f8f.28.1758789920523;
        Thu, 25 Sep 2025 01:45:20 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e2a996bf1sm68443525e9.1.2025.09.25.01.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:45:19 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 5.15.y] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:45:18 +0200
Message-ID: <20250925084518.3832079-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025022404-rebuttal-laundry-1cf8@gregkh>
References: <2025022404-rebuttal-laundry-1cf8@gregkh>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 04t-Lx1l54TkDtYdza3mkR-I3swIp6gymJnrPqICho4_1758789922
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F6E6C0004
X-Stat-Signature: wdiq8z9jxpn39rfysywb7wbi6zx98hds
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758789924-385210
X-HE-Meta: U2FsdGVkX1/EUyZdwi/KNWPzbXTm2Vgod5+Uiy7kKCaSqyw+khsXS6qOFmQ0AaQmjNMqJzNsf6jHe5YDXv51DFi9gJc3dK2NYRLgKUKoQVrnw87mtEUBk+OHSqTLN4YrLNE9iNAu6c5VK3WfDYOb0fGL2QrXjmcMCgefuMh+ZCVOiq1dUUEB+6X9jVAn4GnDmxUMwy6L3SFGVTjLvc0nwGd/tEjNwjlJ0Eens/Q+SEynm16zNoQ/O42ewO1JpCX7J3GQXuq9XUuqca7bIULSklRFX5xOKC/foaVKRvoqBiTsC64iz24tAvIDLbnGgsBu3HEWFpkFatpjqNq+C6w+fkBfNiyvE3H+V6lZZPp82ZECQgDxVy3dxfOHpAq3b74c74ko/ZB7hXR39NO6NGNYkQvEEVwXvKTJCGI1I+dOgOgqXNqEoWm6b0Nve4dA4SCKfdMZoDm4+IYKfx2F0suVKxl8+sSanFmHEHXZMkDBVUFHAg2KyYq8OxPOOQxWuKjaFv5Ko+x8num93DUL+HPzSkvZXkmtFrXHhx4eQAoLKLSuscbaUd4rftOHxLns4UIUerPfVhtli90nt0deXBBhrOrwstXQ583v5k4zXsGoVXY7d+9fe6Td/g9lTrH9Udy/O0t1FOiDmTDPiZXMwyTX5LWndPQRhj7KFI3Oc2Tq9Vn4B+UMaAmt9UIiZjpTDdd7omkDlNCnCx9RzOVc6mqve1UnvEbhjhFIegeEYQkC3/2HNdo191svXJU7r2i6TI99r1uzhVbTRxmnUF9Oh8O/9sL+oTH3yD1AvR8uK/NAedSefU5tVUtS8Fs1DgjsUvJuFwnAiXaybn8FNpIqGa62+TFU2DNp97tqwW8FmsdPbIsdsZFgsowzC69J+Fizh7UrcoiobqfnZdxHx8zzRtE13AElVHIL/VKHvgeYw0SnEFYgeZspAVDKnyLYTaTgScCaNEjrPah33bH5nMnmH3x
 ja21QHY5
 cwupYH3WDX0lkwkqqrntw4y/hPYrDGSEQUum2hrgfYN2sGOxH0FAmkCvQzcmQpdrIScD5cXG6KMVLSHa2Mr+gb3NCdoeSG9yR3fl3la5NoPNYeluVNTC1Z+x5owTYiUAxkQ5duJg+NMahm+8Sv4onwf1empVkuWud+JETR0mLhhpUR1pXXFImwSH+PoYsq71fKv4V1r8zdhuimf75BiIB7xu8HUBE0yU5QeMkgFAM9Osc267/VUkcqwyzGh31tfHj2IqJuZv4QmyLpon/S7c7MZE/7/UaS+luqcIiiQPTRblhZuJftCaFBLnGjYXuoYUC1epHoN4DBj1PcP5uSDUjYGf9GnH9vTixdvZBuVSrzE9YlW2FMde8emHhp4dFTVkG0zfMn7XYVNSezjD51un2TLI5HeTDHpZzikHrsqCfj6H9FSPKQj3olPz6wBegSYeLtcSeMAKfuu/gWIqnbNmP08bjZ8mD7j4h9AHm3MsnJNmIYDKVBlrD7Qc6UTLjPxqXSgh+ch5yHUapVT+CmH7jhhfHi4KK664LJJBY4B3IWNolsc3OTLxQE5MSpxwNU7hzMs0FCItdoEgjSN9EcAPh/nmgG0Uu51/5Bz3r5s6/FhvNe3sWLT0F5YrBLqsvVI8rf9djFyHyPiISqKhqXWSVFyAHjocdgKLq3q6c363PjnsJO3aFldt3ChIEnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If migration succeeded, we called
folio_migrate_flags()->mem_cgroup_migrate() to migrate the memcg from the
old to the new folio.  This will set memcg_data of the old folio to 0.

Similarly, if migration failed, memcg_data of the dst folio is left unset.

If we call folio_putback_lru() on such folios (memcg_data == 0), we will
add the folio to be freed to the LRU, making memcg code unhappy.  Running
the hmm selftests:

  # ./hmm-tests
  ...
  #  RUN           hmm.hmm_device_private.migrate ...
  [  102.078007][T14893] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x7ff27d200 pfn:0x13cc00
  [  102.079974][T14893] anon flags: 0x17ff00000020018(uptodate|dirty|swapbacked|node=0|zone=2|lastcpupid=0x7ff)
  [  102.082037][T14893] raw: 017ff00000020018 dead000000000100 dead000000000122 ffff8881353896c9
  [  102.083687][T14893] raw: 00000007ff27d200 0000000000000000 00000001ffffffff 0000000000000000
  [  102.085331][T14893] page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
  [  102.087230][T14893] ------------[ cut here ]------------
  [  102.088279][T14893] WARNING: CPU: 0 PID: 14893 at ./include/linux/memcontrol.h:726 folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.090478][T14893] Modules linked in:
  [  102.091244][T14893] CPU: 0 UID: 0 PID: 14893 Comm: hmm-tests Not tainted 6.13.0-09623-g6c216bc522fd #151
  [  102.093089][T14893] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
  [  102.094848][T14893] RIP: 0010:folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.096104][T14893] Code: ...
  [  102.099908][T14893] RSP: 0018:ffffc900236c37b0 EFLAGS: 00010293
  [  102.101152][T14893] RAX: 0000000000000000 RBX: ffffea0004f30000 RCX: ffffffff8183f426
  [  102.102684][T14893] RDX: ffff8881063cb880 RSI: ffffffff81b8117f RDI: ffff8881063cb880
  [  102.104227][T14893] RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
  [  102.105757][T14893] R10: 0000000000000001 R11: 0000000000000002 R12: ffffc900236c37d8
  [  102.107296][T14893] R13: ffff888277a2bcb0 R14: 000000000000001f R15: 0000000000000000
  [  102.108830][T14893] FS:  00007ff27dbdd740(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
  [  102.110643][T14893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  102.111924][T14893] CR2: 00007ff27d400000 CR3: 000000010866e000 CR4: 0000000000750ef0
  [  102.113478][T14893] PKRU: 55555554
  [  102.114172][T14893] Call Trace:
  [  102.114805][T14893]  <TASK>
  [  102.115397][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.116547][T14893]  ? __warn.cold+0x110/0x210
  [  102.117461][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.118667][T14893]  ? report_bug+0x1b9/0x320
  [  102.119571][T14893]  ? handle_bug+0x54/0x90
  [  102.120494][T14893]  ? exc_invalid_op+0x17/0x50
  [  102.121433][T14893]  ? asm_exc_invalid_op+0x1a/0x20
  [  102.122435][T14893]  ? __wake_up_klogd.part.0+0x76/0xd0
  [  102.123506][T14893]  ? dump_page+0x4f/0x60
  [  102.124352][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.125500][T14893]  folio_batch_move_lru+0xd4/0x200
  [  102.126577][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.127505][T14893]  __folio_batch_add_and_move+0x391/0x720
  [  102.128633][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.129550][T14893]  folio_putback_lru+0x16/0x80
  [  102.130564][T14893]  migrate_device_finalize+0x9b/0x530
  [  102.131640][T14893]  dmirror_migrate_to_device.constprop.0+0x7c5/0xad0
  [  102.133047][T14893]  dmirror_fops_unlocked_ioctl+0x89b/0xc80

Likely, nothing else goes wrong: putting the last folio reference will
remove the folio from the LRU again.  So besides memcg complaining, adding
the folio to be freed to the LRU is just an unnecessary step.

The new flow resembles what we have in migrate_folio_move(): add the dst
to the lru, remove migration ptes, unlock and unref dst.

Link: https://lkml.kernel.org/r/20250210161317.717936-1-david@redhat.com
Fixes: 8763cb45ab96 ("mm/migrate: new memory migration helper for use with device memory")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 41cddf83d8b00f29fd105e7a0777366edc69a5cf)
Signed-off-by: David Hildenbrand <david@redhat.com>
--

Code was moved in the meantime and converted to folios. But the code
flow is essentially unchanged.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index c37af50f312d9..3050dd85910a8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -3065,20 +3065,16 @@ void migrate_vma_finalize(struct migrate_vma *migrate)
 			newpage = page;
 		}
 
+		if (!is_zone_device_page(newpage))
+			lru_cache_add(newpage);
 		remove_migration_ptes(page, newpage, false);
 		unlock_page(page);
 
-		if (is_zone_device_page(page))
-			put_page(page);
-		else
-			putback_lru_page(page);
+		put_page(page);
 
 		if (newpage != page) {
 			unlock_page(newpage);
-			if (is_zone_device_page(newpage))
-				put_page(newpage);
-			else
-				putback_lru_page(newpage);
+			put_page(newpage);
 		}
 	}
 }
-- 
2.51.0


