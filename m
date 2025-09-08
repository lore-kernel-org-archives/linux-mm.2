Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805A5CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D725A6B0026; Mon,  8 Sep 2025 05:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22DB6B0027; Mon,  8 Sep 2025 05:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11D78E0001; Mon,  8 Sep 2025 05:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA12F6B0026
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:45:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EE1813C063
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:45:25 +0000 (UTC)
X-FDA: 83865600210.05.43D01FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17EE8C0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:45:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CvhefCPH;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757324723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TGVC13WThJMLd8fP4vjGxIOW9dEwd9L7U4OPiTcFDVo=;
	b=FbDaBcB6EkCiwp2QEHc33sFbsYFjrHTl0xHpV0zmWnwWdl1JnwFHGUBpx+aafm+vqlVyyX
	eC/8Aac23zWbiMgZlMu+yar+0X4RUMRQIFzvGaj01Zbno3dgVQZZQzfqFzzaeAhtPfGXgl
	khnAKCAkZUyJTvnPBXkd6eHobRSx/ks=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CvhefCPH;
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757324723; a=rsa-sha256;
	cv=none;
	b=m2MQffc+kgx3APpHP3XfPBpMYmzoOfPlEexF0ZltBV9+UAgSRutXD9BZS+CU4mGqaKSH1T
	8uPnXA0gU621XnwQA2AtgyhNPqRAkC5Kytm323cLZHvQ1dslttZIaBibCSMXeDmkPuA6qe
	PDMX0EACHD9M8GxsPqGqq+JgVOjcu9k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757324722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TGVC13WThJMLd8fP4vjGxIOW9dEwd9L7U4OPiTcFDVo=;
	b=CvhefCPHmoO5Shq4xSQ0EiHngBN0gYy973TfyLrCPTWjJax9Cr7/g77LQG9l9lIFYBw5u6
	N0A4OfglEWOcsEIr4/QSB/KE6CRsUJi9MxaxoXePbE8vmvEMt1HnLeW/u8NBTH7L9NxPX+
	XroKfCIiM2GvtrU0W4IOT4cK2+bj9Pg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-8JC3MSpVMRKxzK1qase6YQ-1; Mon, 08 Sep 2025 05:45:21 -0400
X-MC-Unique: 8JC3MSpVMRKxzK1qase6YQ-1
X-Mimecast-MFC-AGG-ID: 8JC3MSpVMRKxzK1qase6YQ_1757324720
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e424a186fcso1191448f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757324720; x=1757929520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGVC13WThJMLd8fP4vjGxIOW9dEwd9L7U4OPiTcFDVo=;
        b=u1YunVPI95oxVPpsxuHH9qEuKCRZX38l2rH+w5fHpm3iwD50oR/le3+PgjYL5uJ/vb
         FYsSlOlUjGmj6xbPzlTg26Zle9nZCS5BOIgk0lWb6Td37Cup0m4jCxX/n4E1QFU+qfLU
         7rLSZ9lT78M+7j7ZfpjY981x/Mt9KWsFdBZAjwKpMaU33BHmemGKcr3vfGdW2ulrrYXn
         0tB2/N2o3VQHIZr2rk9J15Z/QYyZppADALGd22J921bbq2Oh1MpiQjk0VL4bL6ZaDsou
         xUIKnstraFe4IqlhsrFLiSzBzYc1q0KjMRAbVDH/wq6f+pv5TA1PFHuh+OOLQ6U/7C5C
         4nLA==
X-Gm-Message-State: AOJu0YwIteTdkcsG1oii7mfGR62S6k6MTyYlVk/hXXxwDNmMnb8/S4L9
	/HQGvT/H2mHccNvjDVQM+yAqFaXIAOGxNiwrNvFMgqDZAYAVmGCBgZgJT/x83jvroZ1+zlEM+Fg
	A53BmuweanlTuLxdqyuMpDdgkoxlRMZ4Tv1eYYpaff7fkcpzhD7ac
X-Gm-Gg: ASbGncuXg69TWs3XHwOhMkBiYWIgBFQ2003eI9GFj5KpadtZyzO29O14GguNcSiCCoB
	ZgDwKmynxNSPEkfm4d3/kYJYGONm9bwA5klpPcUmd6aDl+C4+1dZe2JKG82hvcrSwiyIWkX4r6y
	fjX1IBX7gAA3eDsx1d5//XW71XCkSvXIFdFtRqMGAw4JtCkrswRE/Rxaoh9A3Ft7XrRXQKS+LRw
	R63/FQgSM9BDW+/XgryiMOYT2xpFQI23Ea1NQ5xxZpOolSs+qNF4+nK+8QQQ0YP2YiSSe8vYySC
	e1t4Ejeu/w4vaMNO2FtIo3ayXbPqdMkXwpleHD0skFr7y7Lxddz1xFeVnpzq3Ziko9c6/ZZ89Hd
	eQkszHX31QedMj7OioiqqpmA=
X-Received: by 2002:a05:6000:2302:b0:3e5:5822:ec9e with SMTP id ffacd0b85a97d-3e643a24592mr5191218f8f.41.1757324720058;
        Mon, 08 Sep 2025 02:45:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBtlUA4CQzXRrmkdIYxDOgy8QrWzJ63klyMxD3fvVe5qGUrWCpW70tUsnwgk7JCg7Jp6MrbQ==
X-Received: by 2002:a05:6000:2302:b0:3e5:5822:ec9e with SMTP id ffacd0b85a97d-3e643a24592mr5191188f8f.41.1757324719563;
        Mon, 08 Sep 2025 02:45:19 -0700 (PDT)
Received: from localhost (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e92a42asm434745685e9.20.2025.09.08.02.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 02:45:19 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v1] mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
Date: Mon,  8 Sep 2025 11:45:17 +0200
Message-ID: <20250908094517.303409-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0YBE0KmRe00gajJM2PgAz9GnOCcMXFXwN-4oRDtvsyI_1757324720
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: i4nfybqykte585mncimar566nw81gobt
X-Rspam-User: 
X-Rspamd-Queue-Id: 17EE8C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1757324722-370452
X-HE-Meta: U2FsdGVkX18cre2kh8B3r2ghVdZW5iLDv9Tf/9gMUUo2BZI3dI4Rx3F5IFz2ITaQyF0K7Yab0urdDao54ewMhiBs6TuEPXY+rXUvPkwhyWCYBr++NKFhsgC56n2xmm+t4MgVuIkcqhjEfYK1y+kFzTD/IUK1qsKUGgx4WQWV7+p6QO+N1dpkLHDVLDRWFwNWX89/TuQkGYmDJJonYg+g+W/pEg9H9YWmtuu8vm0QRi/qtCiUGy1G4KmB/PlfGJExxbjcU0WVuOn61IczGMUCMpuZlV206HKBl0+P6ESE3FXOuCI2JQYa/XjwAUpJTgzQPwvICEojPEBfsuw21ztPO5T6Gtddhwm8ZQ6ZfePmbB2nELSnxxhjuShJqo5WTNOmMyNCbxAab1Rp2uTj1spvftTth1gcQc6O53Gu9V5i0oOyJKlaoaVJPwlVDSnun/kOY7J9GWjK5zHxF5hi6b0Z7gThZrnF1pIxJ1KzICrmgzBzlo2nAWWPGOV5+aa5PBdjEOfaIu5Cl34Wp+qpF1ymHU/Qc7eo4s336XbQ/LxaQh6gYHaVia0rlVsRZsp7Zz0wxquV4qvuwK8UgbSUa8L2tNGU/eaM00NOasqZEJBmf3OAmf0VPw6ddSKQKr8+ELH7nW5RbVcAhHVQewvnKYCt5qhF9CKOISwIAmPYYRZkte+SW0306Mbj1tenT22RtW1dK0eZLNC/9UA//RPKkIsXsCzfzj3HKsKQKUM9/MFmeynmqi5nrF19L9gdyqYtXRROYh6QNgj+tFwhe+6s4vKBIv/1xfrvABDj+VvWP63aVoeSEDJqh9OMLVANXWtEv8iprNWb6ujodXtRaaDH/U8YonOd9/lv7/5rzyGuNesUKITciiVPH+Vt2vBJ8xyfP54VFMMplCGNZOKQZcXyyOR5ejdKnLx5Tqh7bPtjzffpXehk7UUkOf2koV62o+zdbC5Wu/6b5711y6X83M78l9M
 BxbttBLd
 TCAHx9q1BQAZhicPyUNaPF1JCAQ0QlsabpnxFS+Kj+dJ5C2AT7bsiLkZDTGC5TWd+hOJak8aF0QNX8lrav51fOAxHOabJKtC4R5dKRMbr7dt7GXuVdbv4Iukt+AKYYsESqZNvp91+/aa0+f3UBFdPjomEWusqEoPhgbpapSCGrDKgBsLaY8bYncFoATNoQQe35+H3eG1jk0NSyQdLGWyjbqof4nrqM7vqXtEwjsBORSTwxjcKN1YmdjNhwfNLHdjwVCKRPM7X1CueWFkYS9t6pdf71yxnB7j/ZHrbYQa0AHeBSULutHptwknhW0TLRRMMOTzP5ySC/RFUC5jIEb2UdF/UwXO6oxpX3Wmt5qCMO7vi/Vo7efip1SwsLxgNBpWHahYg7Mbt5PCY7vqLqoJiWmca0IXhdTzuRxYtQ0P6GMD0erVTqAPNU+q4Yvr5s+2njELpysAHOX+mH3WXYPurdW8Wtam5mlSSgepJa1k/gxUtuN/LxjbWf73mbDUYWS6vXX06grYar0ZvxnuU+NX4gfyJBnbqEjxOicKUrYMbGN31UyD1iX2CIwrmoggSYgZFIh5QjX4eEnFTCJefGZ9UV9Vxizh0JAdQyyH6R9UGitpiQXkOzbyYP6d9zXDwfv+JWfk5TnsckTNwgRpF0yp9/M3zMoEvqPjoNw9F+Jr+GkJVPewRlkiDxVo+Lx99ns9I1k1EnFeLtRJjNQ7JA/7OxNEHUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In case we call arch_make_folio_accessible() and it fails, we would
incorrectly return a value that is "!= 0" to the caller, indicating that
we pinned all requested pages and that the caller can keep going.

follow_page_pte() is not supposed to return error values, but instead
"0" on failure and "1" on success -- we'll clean that up separately.

In case we return "!= 0", the caller will just keep going pinning
more pages. If we happen to pin a page afterwards, we're in trouble,
because we essentially skipped some pages in the requested range.

Staring at the arch_make_folio_accessible() implementation on s390x, I
assume it should actually never really fail unless something unexpected
happens (BUG?). So let's not CC stable and just fix common code to do
the right thing.

Clean up the code a bit now that there is no reason to store the
return value of arch_make_folio_accessible().

Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d27b6b9818a18..c969259d095c9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2920,12 +2920,9 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
-				gup_put_folio(folio, 1, flags);
-				goto pte_unmap;
-			}
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
 		}
 		folio_set_referenced(folio);
 		pages[*nr] = page;
-- 
2.50.1


