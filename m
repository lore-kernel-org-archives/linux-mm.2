Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8040ACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602038E003E; Thu, 21 Aug 2025 16:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D978E003D; Thu, 21 Aug 2025 16:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4543B8E003E; Thu, 21 Aug 2025 16:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAD88E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E573A160532
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:19 +0000 (UTC)
X-FDA: 83801851518.12.0934CD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DD2140008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RpPHIlIz;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
	b=iyEXb/UFFK2s6dehqT/8OymLR9qgMoV2Tman7BFauFVt5wkyVZRBiOKFIGCfV/ggYTto7l
	r4HYV6Ldo9nFV2KICF/MJNdwOBpL3qDrMT6rYRutkP8lQ/qMkF6UchBUHdMCdALjYB0j6P
	7rRRAiUaYPm8VLM3IkszZLEa3WGtW2E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RpPHIlIz;
	spf=pass (imf04.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806897; a=rsa-sha256;
	cv=none;
	b=RB+COFs7sZzTLIXQCnVj1B7kUKa7kH3yp8k458v2hRV9KObOOXPpeK4Z03i/8XYS0St6he
	r9v0Mtxx4o2Sam9cS5PYvIKEYm33OrdLZna4+8FwQCMFPIO70xNXY5WBi64NEsPsp1Sx25
	XVIN2frq+AL8ZM7mK4ZTfqUXA20LFlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
	b=RpPHIlIzTn2wy4DImGCL6lMrvKPiPAG8KmWV9t7khMbi/4nUYWvaLrEGXrPwNwJ+42n/uC
	OErGeNh7AqwBjFtTuJHcMlvC/WwdcxMjwcrabUj3JwiQPwlUalSi2xA3/3xdEl5JlXksFy
	YllAkT3ItE+u3VH4kKDNhliOVy9zE1Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-mIP_8gFPP2OWWgdhyjtW6A-1; Thu, 21 Aug 2025 16:08:16 -0400
X-MC-Unique: mIP_8gFPP2OWWgdhyjtW6A-1
X-Mimecast-MFC-AGG-ID: mIP_8gFPP2OWWgdhyjtW6A_1755806895
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so7450975e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806894; x=1756411694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qEz5al18caSg7WeU7/xaDhHrA43/vq8xaUIrOF+uMyw=;
        b=Z0/gs2EuXR2YnU0v97bDZZT3NiPepAxibWAzwGAxtzNOAAsybWe6PL8u+qefNqbWnq
         VBclGIzQVzjDAC4DIQzGzFjoMbOqvJvBrmK9RGjH/87Clc/2iEIRxST5BfOtp47dYRAj
         8jKQUI+m5SpCdDgoF7zyu+aFYtvrBWVoX5Eei4cQFElIldzl56je3AK2PkdRceYFIjOG
         fj1DXp4Sul+5qutBIhLCHr9AZ5K6gF4FqOQ17ZLMTUmyxR+fCX5arBEogEfPbgysas1T
         mkJUwBwBgmjiSphubFSz1V3HJnJu5s68ub7nOp3noWiLjaGom2p6deyTuWPeNV5d1tUP
         shvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwSdCKVattw8ihM4ujDn+uvK4In0OVtRA0v24Ho1l04T+LM5ZqsaVQvbCcnsIwiMFCaQQibVd0yg==@kvack.org
X-Gm-Message-State: AOJu0YyIv+J15g/tEvDXzPQgnxC566a71gz8RYq6ZWQBlP87EbQUXehe
	hP3e15nebAISOLcMdrmA58bPZzpU009w5WPx25MPPUTESapD/SOLD8mdSwwwvRZ7DhywfRcN6pZ
	NSFKFy61JZjkoeBDCPOfwuPr+damjG4f7bZeuR7WHU6PSQMLT5wzc
X-Gm-Gg: ASbGnctqRYGWvYBT9RkKtmQ9Umo8pjD91zQcVtUR6/fL3v1z0EicJPVLhQze++WHtMy
	vFJLWazcx8rbMHbpXZN7vSj85R8iXZnVZNfgszb6PhYrCigvEI/fotmRKkkcNwBU+EyS0JdiAOo
	Hnq2pgydBc4YgXX/JNtifyjmk/3umr6lHI4n+fTWklB1JZLzTRK7F3dug7TzjT44g/7Z+Pc5yVd
	9zkf5UJzEcIywOHHPV6l+aDVWgiFn4CuytLVrqGkXUM+vJmg7UT5QArgaeCPauNheEwyY+hmTo/
	Q9sur8hRegLTVw+RHebNNqQI8wBo+8YZKaMtUNy1xhPyo7EKOXPdeaCWRwAY0BhlO71wv3L0aLV
	FaPvIIlR+8kmjD5ZzGcUBug==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215827f8f.44.1755806894482;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYrE9N2OTZOZSEOVxEUY9xhX4UsF8UOhI+5wOqBRpd/3VSIxUjVMLdiea20BiXkc+w3FSZ8A==
X-Received: by 2002:a05:6000:18ad:b0:3b7:9c79:32bb with SMTP id ffacd0b85a97d-3c5dcdf9bd9mr215789f8f.44.1755806894010;
        Thu, 21 Aug 2025 13:08:14 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c074e38d65sm12982954f8f.27.2025.08.21.13.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:13 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:50 +0200
Message-ID: <20250821200701.1329277-25-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ey-N-3r6xfRg1Qwqy3KcMsjuU2uA3tKygjlijEiaCOc_1755806895
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 9DD2140008
X-Rspam-User: 
X-Stat-Signature: 53cg5n8rx9mdbf84zidhxxtq1ffaywy8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755806897-954384
X-HE-Meta: U2FsdGVkX1/Dp4lsu8e6RqvxpoArxbTqbKmlu71zEpSzeJaIIRXmYpiOiAultjUWBBdYpkcuiIq/leAdRcoGvDDoXryY8kC2oabS0FxHjD5jwaFHBcW7HdKAs12hctx4N6veTFXP70lytEgMBfdr+qqiCFy/FPOAvQIvX44A9+J2WN9aypHOU2AZypAo8tpbhLNKfenW3EAX49ocq/viUrffwqK40eED033+mtqboKoKSz2tVZA2mXUlqWEd//t+ilVjWOtlWalSkNvgoXZPDauHsMtptch3WDwzhcBBrrbZNTW0azA5A5BQhCc7I9zQe7jBrviQfv/ozRwKZBCZX3QY8PPZA0cqV5ZOYwWUK8gzYKqVK/8BJ8AvgDDLuNl3G7dJAnDSEU+6Lrv2Jud7VNuk+6qdglYw9tvlLHKfJCnTgIxWOaRlAHxIAlziBfe8QaP2KMTNYxWW2H59QGCpBSoEqS85OXEoSwtqUvgBPfZp4QzU2zpKmDlOagzxmqB6x8AGdTHV0UivwI13Ef7Ule0/6DSKBZB41YdtctK+wZYjyvjRAusBNJwSN90aIe3KYGArxbCDi5RT2yIFPfz9v8KOvmcOc8lgqvMr8l8hleaZQMs2VoD6KYRjjpA9Y23ELLD2y/Wdtx/3SLJTjpB9XT5O46tJvIpCzD+EH1QtxyNU7Uft8R8nP7dXMr8hDc0ua91pKEzDDpaZeLUx+psJpEN+l1mE1X+EADzY4C9nRjkBbtjODUaDNY6Uae/sdSsC4JLQb4S8gJDw9JSyiwNql/loCuVvMQQtsOUd+wPFaL/1BeTvOap5lvzX160mz2G4eON3nhlmnYwfijTD+KzPqOWkTKGd0MI236MCx5isI7X2MgpTTS+zHa3eOlR2gdiaxguikxtZPo3Zg2rL4W5btN7wHWOpj+YJU+m9BwXurGNM0nJcm4h/ngLweUuZt59BRURx+1ICbAD4fUbbk7w
 1ShRrwz1
 zch0Iu8EGl06roUxGHUltTYHTA8dyM0RyTBqANC4Qx0Eq+eYuO84dFdKA+bgRINpmVZJ1GZcoIx21Zg1j8xj5v5fki75ghmcCpVaaJIU+uiyefvizH8Zf4Cbe2buyxCnlVhMxfsMHixBywdRJn39XMKq9FlEtlFCBReb5Drd0ue3FwGKRyHcTS55kWrAFEOTLMQA/alnUrgYD2SCkTGA3W9E6HAssMCxTa6FGGrHMT75B2Ji8IK34K8iHc9vHkB+1Zi+PAO4DaDl+s3ohd6ywS9j8JXr0orSULi6alD4qAyDGloyBp4rIR5K5sxnNQKTIHBayeHZQDw4binsmlQIGqE+eYoGRzJVozJLT2lg6OQYGE1DUlBeNHKKyZqRDJzyNwvj4drVMh2DPiGc2de2F2LY62MlbjkHyligUob+syUeuIDTy6zgbNQw44JQhK4AYTUTcIblK99RxxKpwTn+CY+CBYVws3unwAaEX/WlCUlD39FTTc/kNv73n9ofkeCqvWvz1zdbsTqQi7+a7y+MTbuEzhBkpfKG9eaWwy4CQy0qWL7ghdp4t8gjLAsSxtA0UM3n4iflvNPjGcts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Niklas Cassel <cassel@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/ata/libata-sff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 7fc407255eb46..9f5d0f9f6d686 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SHIFT;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
@@ -631,7 +631,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 		unsigned int split_len = PAGE_SIZE - offset;
 
 		ata_pio_xfer(qc, page, offset, split_len);
-		ata_pio_xfer(qc, nth_page(page, 1), 0, count - split_len);
+		ata_pio_xfer(qc, page + 1, 0, count - split_len);
 	} else {
 		ata_pio_xfer(qc, page, offset, count);
 	}
@@ -751,7 +751,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
-	page = nth_page(page, (offset >> PAGE_SHIFT));
+	page += offset / PAGE_SIZE;
 	offset %= PAGE_SIZE;
 
 	/* don't overrun current sg */
-- 
2.50.1


