Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF84DCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BB58E0018; Tue, 21 Oct 2025 11:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453768E0002; Tue, 21 Oct 2025 11:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AE68E0018; Tue, 21 Oct 2025 11:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD5D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:00:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF4DE886E4
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:49 +0000 (UTC)
X-FDA: 84022433418.24.3A3881B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 276C7C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V7RcHXIM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36pQ3u8jy0FN5dn5JcBHYlI7xvHgf6+mb8fY5UQyalU=;
	b=w4BnrmIhw3JRxcSULsGyLTQizb1/QlFh4jeCkeHkmJIH6ltY3ioAzQC/goaetQD5k0z/SF
	Sa/UotyP+ayCXItL98JBl/KsO2Uu4usZdQ2iMy527stJ0JT699thfagPDShLcKvRtsGF5A
	rNKFrTHvS/6eP+LLv2S5vS0uJNaZNfA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V7RcHXIM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058847; a=rsa-sha256;
	cv=none;
	b=jeIBMc55CKUqlAcyBlAQv/Q+61Bc6cUjgZbOY7qNnq9k+z1c4BTFfb8vVaYvzxiaOQB5Ig
	ZCs4T1oFTpTVOCPCY6AYVYUDiyE896BLNI8ttC0OsserapRhxu1w4IQj4dtYa0S37vpT1e
	DDfBudo/Qb7RNaXVY5gHdW0EiIlRn4k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36pQ3u8jy0FN5dn5JcBHYlI7xvHgf6+mb8fY5UQyalU=;
	b=V7RcHXIMS+gv6XWZCVFVy6wpawjszdJ+lx8e7bkM7DDbvYKG+FiKUe3/itPKV2Y2qycFAw
	my7H426y/rYJoVTjxv0sk1sZK33mrG+2dKKFBcSBbYilm+8xk5SOseawNE3yieG3EWyHny
	b+NRCNiaSsj4BE8V4JVFTuGrknWHN1E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-dwdNq3ZiM7yYOEW0Dj4wCw-1; Tue, 21 Oct 2025 11:00:44 -0400
X-MC-Unique: dwdNq3ZiM7yYOEW0Dj4wCw-1
X-Mimecast-MFC-AGG-ID: dwdNq3ZiM7yYOEW0Dj4wCw_1761058843
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42705afbf19so2330869f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058843; x=1761663643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36pQ3u8jy0FN5dn5JcBHYlI7xvHgf6+mb8fY5UQyalU=;
        b=v9+8awcBRPWbll9u88lchRxdJiNEPdJW4PUfac/RmM97VFXM19HNdzFqOmtf4GVZgi
         b6Ud17+Wfthc7NTumcQRo2Sfs6sqRe9DTCkgTQYm8Or0N1XMgCEQX+yZFhcV/JbHNk6X
         nAsyqX4n6V7Gq9gBU1ap4NEWk1wE2QmFQ1BDrAjTX7JbT2IxqyyMfX/u+f9+sgFECbAJ
         xz6op2ZFB327VsaAJlgauvc4aLXVKd0ueXD4yCDwt0LDWFaei/ZABeDbmoR00vJLSkTC
         LrH6Ek1t0wMJpQOPngkCweBrD2Wt26WoV26biFAb6ubUZ+Wognq8GltxrRqiYKi3JvYl
         iN3A==
X-Gm-Message-State: AOJu0YwEM99JMtxaEGobsmyCa977Zjxp2UuX2KryveyuFjQ1PrBUParN
	unUUip5DozyvIwmP9yJQbiVa2ptV4oJBeef2B6tn7kti41XYThyp3RYnwtNY10xGBMftB1tvcVb
	nPz8rRRAB6nRJtRczDAl3TjU6/U6Gsj7qMhoc/iDEzdTUZPDCB7N9aMUvd4SN
X-Gm-Gg: ASbGnctSDvNmMP0wVg41n3moqmVaCpw8TycG0aYqAkqB+C4BAG/j5n0YVnNFdXC3UZH
	1M1NIsONWSu1uZB0kWI2leX8KnwXBi+mergC0wfsRh5aptA1qxD0g/uvjHf7JDPAykQF90rpdz9
	qq89jE1OChoDc+D5I47t977qM+7B5Kq6vhJ7vVjHaGLDKyW1BZD0SESkIfefLwu/TjYrJCMO7qL
	WX1/adrrAZ3qbmud1gsU1TJjLPnMc9W4TPgKflfk5nqkBKmYHKYM7687BKriMlaP+TGz++fXBnZ
	SLKgsdIznFzo/tFdYWSAUmeXXieNzQYCCjvUr2maeC10MKV+wNu+eAhs/pWArxOoW7EshJ0ZhHA
	t9tVFSOxeEtrHC/fYM3eyGldVhHneDoDf/DKpqLiDBQpS7aKfhDdQhId0FZFR
X-Received: by 2002:a05:6000:2312:b0:3e7:6424:1b47 with SMTP id ffacd0b85a97d-4285324c1ecmr15530f8f.6.1761058843336;
        Tue, 21 Oct 2025 08:00:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZSHalSV1qtXRSgl0VFWeqe9iy+sxBgka0ewlzc4+wG6jRvgfqUYrrl7qKB5xy+AtSOmms8A==
X-Received: by 2002:a05:6000:2312:b0:3e7:6424:1b47 with SMTP id ffacd0b85a97d-4285324c1ecmr15477f8f.6.1761058842857;
        Tue, 21 Oct 2025 08:00:42 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427ea5b3f5esm20480663f8f.20.2025.10.21.08.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:42 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 17/23] mm/balloon_compaction: remove "extern" from functions
Date: Tue, 21 Oct 2025 17:00:34 +0200
Message-ID: <20251021150040.498160-1-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FQScCihStXF5_12gVOyqtlOZI0MhRbuI7552e2ROdP8_1761058843
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 276C7C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: s3fjhs86jpc9z6mc3nej9radxrknassu
X-HE-Tag: 1761058846-506981
X-HE-Meta: U2FsdGVkX1/j7GeVZIo5DVukzCODbzvzDkArlwNrd2Ee5PVbQunV96XRnanP/M7VauxgoEzrxMG0Kwj3vvLJA2LJOUBMXmleF3xtXJE2DJe+Gz7vfG0mKvOXHlCnYw6YckbafVXaxYD0zRZi8gtsccmrg1kUyu/98FTSk+kI5U/qEC/DWq4RSVJKtt7GyBW5HX5YIdd8wMk2bqZ/yPTJQ2m/er7XKSaCkVscA2O0zuZRfd3nbmn3REQivp/uGNOEVlQhkOx0GocjUVWlmAbL7sfmP2zvoWG+ztNY6fmn8txB+STURndi5gVw5/7GHmdMGKc+FQpLUOZeWF72geOyoohVvp6Cr4991Jc8VGtuBe7+3IwaIqVfmlWgrIxrmmWIlwBFI2ZxCgQisjUjjzpI/ZSfKypBHJTk0GxD2Rsv/uA3w//MvtKvJ0ZzmwFuj1ogsBxruVw4+RJfJQFDSetgUOjhjbZwSFz0XfRQbjElQ3OOgKxKa1k0pX2nNT5q0C0pnFXOdM9B46exfh6/exAXL2CBKDhYx8QYENCVpMwGp6e6hRTimcp6RWjnZsxb/DmwnhLHg99U4K6pAsxUrQB9WbaNdUZgJkYFLP7bcNKXujaNY83BGV9wcBks8wVYGNB6YHCecWx8U8PL8HeGPPDr0yEPn3AxEkoSRRuiG1mIGF8+VE9fd+VQJbiSfu7YJrFGWAnwgFiiq+q+phG0vwk2Gybz5ETk3xD8RCuHvt09YpXcBF3cohFyN2gxJXDNR431U1ThBdHAJeWYMHaiwszITgCXgC3sErPLjdDWEhtOkUYZu/6353tgrl2S69A97s0SefV6W5a1mBYqUuceXsBgwLSol45dxJbcX1wJ/mDVecvhUvGjc9sgoI0ORh3ZUJjQHNHLEqa0Cg4DZYSSaMo2i9+16Tqt4M25OOF2dn6yKIjyOjMCo3x8nUzNTXMKJOiU1en6EtocYRENzTO7zIU
 TL1cCKGr
 Xyj08fDjDyE5aDRvtolbDg1LyhfzKLug3F/74lQrLcuZvUKzy0klVGwpGxDIz3Pf1FGX4eL1G6Kg76zcjkNZYKmVYyK7jj4wnpH6xulV30Q7laUK6GnF2YvQRm9rBLwyQZXSSzk9xWglAY1Cto2PSztgXLoWR0Oh+o4SssyMokVuH7lZMurZk6POil2LevgRfqC3cnPFSd/be3YP8PiS+7OCLzzp8c12WGwskqUEQiq1oQKf1zHfQU+5JYgBqXTHriiCUikyWkMFxZiYb6nOtJXdReHhILXEME6zmfQv0YEaNgyx27pzIkabpt20GHb531o8GISFv6Z2XTmUwJUJHPw7Szer6IbIH+U8+f05IR6Rcm6wi+HkTYPPKBWlbsMoNczE6kjOEhejkaLRxx4MOda3ZTaPT8HJ/ebKJPsp1RQc7hs9ihLU8EyrHMga+bHhBuajICjskGGpi8kZUbxjZbvRkky0TIWoLuI5e+tLz3RFP2arM68M4ulz3lHvO7oUAw+htWEvaIcX2qgBx69xXi6oRTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding "extern" to functions is frowned-upon. Let's just get rid of it
for all functions here.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index eec8994056a44..7757e0e314fdb 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -59,14 +59,14 @@ struct balloon_dev_info {
 	bool adjust_managed_page_count;
 };
 
-extern struct page *balloon_page_alloc(void);
-extern void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
-				 struct page *page);
-extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
-extern size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
-				      struct list_head *pages);
-extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
-				     struct list_head *pages, size_t n_req_pages);
+struct page *balloon_page_alloc(void);
+void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
+		struct page *page);
+struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
+size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages);
+size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
+		struct list_head *pages, size_t n_req_pages);
 
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
-- 
2.51.0


