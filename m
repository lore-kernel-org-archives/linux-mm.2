Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0CDF588C4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9D26B009F; Mon, 20 Apr 2026 08:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1D96B00B1; Mon, 20 Apr 2026 08:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289BC6B00B3; Mon, 20 Apr 2026 08:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1749F6B009F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B49C61A09D4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:18 +0000 (UTC)
X-FDA: 84678919836.21.1A4CC16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F60BA000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=feWAaAzH;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/g8ZGQWZ8XlzWBJ+7NKr3kj7gz6pSemT6E24/mXHPA=;
	b=aOU8cyslBRREWhEfbstdR+kcZQ7Fi4pVkZ6W18QeQOBrg6R+hmeiNakVCQrGpgCb3k9x0B
	FYL8CKmTY2rzC1m/3wHC0zj/Pv62SAgjeZeVx8YIBo4a/dlhLTTB1IN8MtzAKrqvgHBzkd
	l9gjKuzm+c42sYVBefFDh0hwmhmNVu8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=feWAaAzH;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689476; a=rsa-sha256;
	cv=none;
	b=1HZ6G4c/zwnVlqGXTns14ZgPK/TwyiUcd7VU2sVs/NyMvrI/ljtc4Vwm8CwQeuOVtqv+ro
	wyAr63CQZz8Pn6R1O0t4DPQfEa90NbgxHGFDzeG3lW6LWRCgftY0juap4a3qOR9ddjuswU
	bUNg1+Q2gSK1GUNHf8jZyBs/Oo3bpcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J/g8ZGQWZ8XlzWBJ+7NKr3kj7gz6pSemT6E24/mXHPA=;
	b=feWAaAzHQUNe3h0ICt96MLvjEQ3qp6IUJgmlyEJ8K2X1iVb26x+nB4huH6yy2pgkf1JrfI
	avAM3a2uu8Nfjt/I8KHlU3XlGWXP3R9Rj0hDR1ItKLfckikKltc1qvqjsCHH39oH+lz2V+
	nr9RVlv86aIb9GxCcQcOm3z4pSbyaAw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-0kk3iR61MTSdel5SL1YQ0g-1; Mon, 20 Apr 2026 08:51:14 -0400
X-MC-Unique: 0kk3iR61MTSdel5SL1YQ0g-1
X-Mimecast-MFC-AGG-ID: 0kk3iR61MTSdel5SL1YQ0g_1776689473
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4411a1f9601so832936f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689473; x=1777294273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/g8ZGQWZ8XlzWBJ+7NKr3kj7gz6pSemT6E24/mXHPA=;
        b=Xyw2AloiO3jqPP+s90o6SreipmgDbaXysttq13w8baDQ718mcFusZYweOU4VbD30Ty
         NYKzuQAzqeCVzbIkRcnpoLMP0sL1d9M1Z03yyMUeBSoulziRUUjnsOrvbMgpHjTpgH0h
         yiAir9M7YCq4pCZEz6yfZ3Diw0/WaOs+bxCfsTBsIeqfQGpsywWccmpTG0F1f08WdADZ
         FZ8vBVGW4ChTbfdrgiXa7awt+IZwKoxyFXNOZWV+o5LHCZUWDCkgcDEutNzOPc++w1nS
         TvsyROabx1pj+ljTTg5Av3zGZbUQd7QRCn5sUjQPlUl2JlXRwrWFyHxr6FexYqA+IOes
         CAlg==
X-Forwarded-Encrypted: i=1; AFNElJ+iRiWW31aoIlIvqK1iCi8Tdmi8QY6rEyMY9CH4slNhUxaUS7rQcwN/HrKM8S0vibLUS7xxe27lmA==@kvack.org
X-Gm-Message-State: AOJu0YzBUTUqy6sbzvqUB9RxrfjUQ3GpI0caI4exgcXXQgvDXIHbiZr+
	wP2NRy+gjhCctjkjzWOAC8eIKcOf5hvIPYrXGj9E8PdXVvb70yI5s9z5uYwaTizTRHNY+QP880Z
	BkT0OWiLRlO2Sy0UMoZREF5L0bViEqzaBGXq4Wves1cugASkH9w3r
X-Gm-Gg: AeBDieucpqfChPV/Xbo2vGi3QoILHZQ9uSqSaZrE4R0uwy2PyvcMEsFUo9PIj+N/EhL
	uWzL7cw+P6lG+mEFWKsRY8ke+4jADrDx6OB2h7ZpKx5gN12yQA/eOdZVMPg4IvQnTH5GctZqaaj
	ufYvKzvMjxeYm5pDSbYLI6E6eaDssMQ27gFSDxXAQSLrjhk+og8PH3WM8WnKINSS1v3nS+51s2F
	I4jbh3MPAlPAJqLlXcuVhi9SnVSPxNeWg5d0SgYJM1hDdv1Oh9pvnshr63heAjv8DFwA+LONmmo
	F/SEBDA/KZ5W3k+aaJuu9d54C1Ek3AbnhOuhOc3Gv1W3y6BStBwUEst5FDAGMmKVkiZ5htK1ds2
	5es+Bkgn3K2kndJjSJLaATb2HT4vekZNJK3mIbMq/kRKPY5kyYwV0eQ==
X-Received: by 2002:a05:600c:4ecf:b0:488:caed:5cc7 with SMTP id 5b1f17b1804b1-488fb76fddcmr200447865e9.15.1776689473374;
        Mon, 20 Apr 2026 05:51:13 -0700 (PDT)
X-Received: by 2002:a05:600c:4ecf:b0:488:caed:5cc7 with SMTP id 5b1f17b1804b1-488fb76fddcmr200447555e9.15.1776689472840;
        Mon, 20 Apr 2026 05:51:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891c320084sm125770965e9.2.2026.04.20.05.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:51:12 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:51:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: [PATCH RFC v2 18/18] virtio_balloon: mark deflated pages as
 pre-zeroed
Message-ID: <1b1f7c79ef36716f7819c8e2a65a3d4a1fde3b46.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MJM_7w0Ef8SBz_iqtuzcqEbzhpoeQK0QbkFdINVP2bk_1776689473
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F60BA000C
X-Stat-Signature: 9sqfo4usc4f5etaam49jij3wqu7wff16
X-Rspam-User: 
X-HE-Tag: 1776689476-459499
X-HE-Meta: U2FsdGVkX1+ApF77zSsiv3OOlN15x6+spjt/Oo+yb64zIoKjDZNyceykBTowOvnOsuu3EohwumRf0UWgMEEDcsbzSV/ZKYWBiTcHk+n/PgIgsjVBL3ky8Cog2BxHulWVEOvcBs+eXKR5VvcKJkFbS6KE6feZz8D9YY1wjzZyfgnWBvB+7idC1Xpb6sZzoG/i4wuVgbATIg/vgZFG5xDjG4boc/Eq7mHdgraRDZcxLCroJ/R+GyNxQ+s3WBj4oJ0i51VOezokaQKo8Ro8l+3elcf73sNW6fT9oKI6MxKwprsVocnrk/DwpD0DMehipZ1ckymzDCUVe7JwKXP8/EAZukcgv8Qz7VRaW72aDPPB1b6O6pAS3pYA0XuGd/GL9KXqo+4mqWI3MfkA9qhsDWtdiqxQvZ6Sr/2DC89kOZZ2biOG6ocB/FQ9DFFU3AAID0Xd2k+wTkfu+bp0uAdqW49Xa0gDPz1xgZOFquHGEBsXduVq1k/UhyoBV1I+HT8+SnBk8xrjii90G4VaE4bxmip3ZdDiUIbydZrsuZ/wtMA1mLvrdG2J1+gzeSMqKL6aj1HE+2InxcvlwQIRUxvGfBGkYicxFLQTnk4qw/PvRK+ENWvrPZdVB7IjG7LBiYSr8kkERwzb0AHDVYwR/XxKdU26nd+wpkSIpVERMhnNHMccYc3IeUVAtFGmlEYyhyPHP4KU/LKniRW9jCA0NfFbz7EMRZYWj/FuZqQ0Ipkpnuw8qBfxJIMa5OoNyp4Up8+SeE/0TCptKaNHN8Y8BspCZ8vZitUyWs8q7voTCQRIETuwrRBIe4qP8jrGdZBWtLqBFhiQvkoMynMP1FkloojmpL3d4LTRx1LNBLcd8ktWAGugNK+tuEs0ruo1ApkMAuLsdwGd99RmA5VqLw60Zs6tEl4yriQPKi+trZSZ+La8YQAUMg3L9JkcbvpuCQcRqlItBT349Bk5TNHyDHz8BzzierF
 b3pzjNzD
 l+XmM0YLkj87dE1V/dCFgryjMOIYEpLGEuGiFpilBRcNCqc7e2PJZ/T8ghrjtCtdkWp5Yj7WekUfHZLci4H5iIb9cDKiDV3TY6jXukvdJ4pbVBOrbsYIRAjlyUGqBoKomVyhEijqiExBfv1f8vC7H6aDFV7/YJnmb4l66SQaZl1r/3jLgTEcpkl0pBSs/edxiA5HGiCGC5vG4swIMn2B5/E0w6JyDNClqQOMoF7iMzxCT97f/pgXQf16HFKz6rHuNRLmlmsBjD5tO0hjxYR1MgzeaZh3uH5QsGXD2DNwhW7AHxVqd+T0KzfCCgXrguiqwCjNnd07/2ZVHQqJ1G2GqIjCWGOidG0p/PbEZAx8BWASxokKdnu838nro/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark deflated pages as pre-zeroed when host_zeroes_pages is set.
Use put_page_hint() with PGHINT_ZEROED during deflation so the
freed pages carry PG_zeroed in the buddy allocator, allowing the
next allocation to skip redundant zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 2e524bf6f934..9b35203f579d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -299,7 +299,10 @@ static void release_pages_balloon(struct virtio_balloon *vb,
 
 	list_for_each_entry_safe(page, next, pages, lru) {
 		list_del(&page->lru);
-		put_page(page); /* balloon reference */
+		if (host_zeroes_pages)
+			put_page_hint(page, PGHINT_ZEROED);
+		else
+			put_page(page);
 	}
 }
 
-- 
MST


