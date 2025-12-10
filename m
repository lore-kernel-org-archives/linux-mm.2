Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2281CD3E77B
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 20:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8CD6B0006; Wed, 10 Dec 2025 15:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA366B0007; Wed, 10 Dec 2025 15:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0728C6B0008; Wed, 10 Dec 2025 15:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E71DE6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:01:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 777455A2A5
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:01:23 +0000 (UTC)
X-FDA: 84204630846.14.5575E18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 178128000E
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:01:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjlK+20q;
	spf=pass (imf02.hostedemail.com: domain of dkarn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765396881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V9RbkySjzGfl0K9jXSqidi1BNCt8AnLcDnqFvp2ykS8=;
	b=3+7hsUDGOPkGty6Pf8XykmJaJjxdiyNZzMhD79a6vjdoc7VV5SL7UIkR6kKwiOklfmMoe0
	X3vlWE135fzMUnCyEDf4Z6fuyTQJ+cne3ePE2mdbVTkZ9xRdqzj0Ok0G0Qpq4d1VllocdV
	ZSv3Jxt3qh+S7d1LXyRv8Xy7TU2xUFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765396881; a=rsa-sha256;
	cv=none;
	b=nfiu7JGeETYOdK+KUoiEXxGtVpJN6kPlbJwHCpDuLaEqHfqI8REVQzWSanykQhUXFZKM2m
	znXXN1KjKD8gE62VgcfcRJwoeoS5pusP/WeBqQr90oJmxU/UsLQMTsSMZgmfICIJK9GcDt
	B92N7O1+vX0ja8Sd/Id9Rz9tYruaaV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjlK+20q;
	spf=pass (imf02.hostedemail.com: domain of dkarn@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dkarn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765396880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V9RbkySjzGfl0K9jXSqidi1BNCt8AnLcDnqFvp2ykS8=;
	b=NjlK+20qTmmVQnwAgMJeNSJY9lRM/vVjnhEj9N9NdJn+xs9XPufUM2XyaXYkx30z2kcbQo
	pj5pA6fMAizoCh7IFPlGKEduVtzCNCqa/0nYiKpoxjy69GHFNWIU2nzkSe1KyFPcQcXNua
	DeKmCjrIz/vYFzhFqFZg8y81Drilqrc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-fptdZsEvOhyLKmrsh9rQkw-1; Wed, 10 Dec 2025 15:01:17 -0500
X-MC-Unique: fptdZsEvOhyLKmrsh9rQkw-1
X-Mimecast-MFC-AGG-ID: fptdZsEvOhyLKmrsh9rQkw_1765396876
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297f587dc2eso4627395ad.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:01:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765396876; x=1766001676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9RbkySjzGfl0K9jXSqidi1BNCt8AnLcDnqFvp2ykS8=;
        b=aB4f5nniBLHm2IFsfCEW7R1jW0cewqut3wL5CLtWRc4jHZdvCD8UduXwqxJJmiC2IT
         JghvzjyDRE06qtKnCSFscLR98Z276FOM5SSKq0buAY228pTWZLz36POVPsIWLkHU8r5Y
         w6S/N1sT4WL5+eo0oX3CpMvu2QBG8TeO8izVcuBhbkpndXL3PaoC6owwjmxmP3xDET9v
         kACy9YQOlC24WvsF/AbHiiuCkNRKocm7kQanOXjTbvwoNDsK6EJa+prO1T7RAjUxsxfJ
         xqLHLZC40aFz5TKZIxTK9eKPUPHVmwCBw4ABbCtENssOPzazmGJsWHo2pTxgoJfALqCh
         THUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDe/I10cEa1u/tRoDF4wxA7euav/SaOIoPUIohCk0mhiePnztGA1BitDci6KMU4VWVwIxc0tzKEQ==@kvack.org
X-Gm-Message-State: AOJu0YzdRB382hND6OlpuWVGLS+ybGxwYZYqIjsB6/xQKr2tX7chMZHR
	EOhlIjZx/Ktbq2XUNAtNHRD+QU0hwjhLwY+Egk0lzsHBlW5rYWPR9BtcGPaRzSBJagXCWnEn7zd
	t4hiNq1e/PQqmMxyiLX0O22rWo8GkLy8sqhtRNPbd8cAa4XB39Ro=
X-Gm-Gg: AY/fxX71IumQacUVVaZ6RyCTW8PEjng7hajQO0mPV3fZQiHvsy6aseZwd1Xe9C2oXaX
	s54PGkk2vQ+/1ql+hAth9ld3bRICMKxfZq7q+CBfj3hed9ltXcTra44fwIEjduezLuwknskXhal
	9YG/D+XbJRo8d5sgvytZ+9RsqA+UwfXTwIhZfKG9gu3mxy5stsvyUeTOb52I6gUWCQW1xa7CNr6
	jjBFtOQAJt7cyjKq2FEvbBdOrS1kU/NpzNZ4wLs/lVV6wPXwwCg+kuIRORg+ilSfEGm35PZupks
	KrsrNWwjx6CNAeTPk4l7vJCSzMFpx6cNRdoiMZvs6yA7FwhprVJ/LfA8Rsb6glVKSMW/+LPAEOa
	W690LLJhmdXKWWuaq7Hurpeh5jD7HYAVsIk7P/A==
X-Received: by 2002:a17:903:3b8f:b0:295:8a09:bcf2 with SMTP id d9443c01a7336-29ec229b8bamr31841445ad.8.1765396876006;
        Wed, 10 Dec 2025 12:01:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrGjll388q8qWAtNsls6L1JpU1c2oP7akLc7evYgTdRMpha5cZhDbVRpAeZMgzYqyVmAu9gA==
X-Received: by 2002:a17:903:3b8f:b0:295:8a09:bcf2 with SMTP id d9443c01a7336-29ec229b8bamr31841005ad.8.1765396875476;
        Wed, 10 Dec 2025 12:01:15 -0800 (PST)
Received: from dkarn-thinkpadp16vgen1.punetw6.csb ([2402:e280:3e0d:a45:3861:8b7f:6ae1:6229])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b373d6sm1819395ad.13.2025.12.10.12.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:01:14 -0800 (PST)
From: Deepakkumar Karn <dkarn@redhat.com>
To: willy@infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepakkumar Karn <dkarn@redhat.com>
Subject: [PATCH] pagemap: Add alert to mapping_set_release_always() for mapping with no release_folio
Date: Thu, 11 Dec 2025 01:31:04 +0530
Message-ID: <20251210200104.262523-1-dkarn@redhat.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: REsmRbpzX7AIvJeB6XWaR-L3Kexu7FJv8VYgRiVpMIg_1765396876
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 178128000E
X-Stat-Signature: ho1zmhcigc1bojjzao6oanwupgouis3n
X-Rspam-User: 
X-HE-Tag: 1765396880-848042
X-HE-Meta: U2FsdGVkX1/TvwW1QoqQgsCnoK8UxSuFxvyWK1c3U69msCi8YlrH1rFrFYrJNJysOCDa3bzKvyl5BqEZ9bVJTMMX6VwAio7dLhP1rciNC+2zpxFcMdEH6yVGW4u6p1CzvB3d61iwBR+RGaQMyEr0on0uCPElU0qX8cvtItLsFpKIW2g3toIJIC+MTdTK8X6qswoB/PiwIQG+cQl3CfO1SxDSm0KAAwxjpUERStvVxCIC8KNFmzDo2tGaQy+4nZXR5IHeMyQuZKqUjBjnSD44dby3HM+//5JIcFUshxENBwvVpj8mgvTG201zLoeWkmMQSLHPwbPKKxYTDsOFDSOKeiO5kRCDd38hRE1igPYniwZktUMnyja8Ekur8+rw7TsBr6R73DqSnAz2il4753Hdp7Xkk3VJ4w6mvdeBGXk6bpw6TWrcqsW4sRscU4RekevbK7LzAclwxGFYuXyIsvw5CQSZI80mxWEChdjyKq/BRyrlbgrJRT7SJK+2n32F7ApaugIJn2LG2ABIpdhaGtriPsWF01utuO5DWUBJB5dli9/CE4bZjZupbQiHWW724O8dZ2koxyTCDy3xk+OwUBeJp+G7y3tJ9NRzG5D4stRURrjh71Vsx0HPVfoUnmeO0xdsERpxC6Gd89IFUUwX8qFCoyMZlStCfTETdbVaEun9TOKKh0c2nVngIpIWIdQH/AvA3lJ1zBsEQ4SjvF69uXNwOXRV94CD7+CqR8pjmBLLXrkindmU02LEBoQzRJPdDHWX40aAncpHiS2ssadAdrtmts/iE5cFp2YQ6TRSvboKA5upcATRCkmYZC9ECsjk3EQV1lMP66qeW1cn+6a7EGhdUg0njX8iSDji/AfTX2xsauRHn+DUr5RQ3YSRKwo61g5Dcn09TClHH+bGzsWH9le7Gr8MGjNAkv+196UDIKVFJ1eT/+DJS6GcIzEd+8Ut+3axV6OmyV8u1ELzjl28PMu
 O8V9PsjV
 EIbrCLO2787g3FobNN4e/IJ7vUSJa1NIGdOYatWic61TiIonOJ/7ciiUN+EqJ3f9zlllkTJtxweX6oo6oX5fvhzSuUVjAAiU2752c89agIost0askSCQP/YxDrlBiuRCcPTibQxZr7KP0v9iuSJCYDvJ4VGL6NeM82+9WpdfETdkY709WbY4Bm+yAT3i6buJwpLlV4iznWko+q2jxugkAlCdXgamAPLeCl5VtarWzGmmaSuY6UPA3uCNLfvSzfcv7sn64ZBENR2cdDoqYuf/Vvo4w8JZAm6Poc/8LvZrccjfvEaCHBuCbL4hMU/Kwavp926/3AYuROSjGd/8qedzR0LY1GsQmrodghVrIFo1EwIXsyMobdVfwkCnNNWtsBy+bTLvYA2T+HZrWIV/aG/0SsUXUlNPfvAlVCTPUzUK/dfLfaKtKf5odVYDiDH72lH7nTypzBDvDTzSCIUJz48pCvBK1L53ZeoAAtQ8LneEt/xSxLBlxlS0qgV+eCRcbxQnEVjHw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AS_RELEASE_ALWAYS tells the memory management code to always call
->release_folio() when releasing a folio, even if it has no private
data. Setting this flag without providing release_folio callback
leads to try_to_free_buffers() being called on folios without
buffer_heads, causing a NULL pointer dereference.

Add a VM_WARN_ONCE() alert to mapping_set_release_always() to catch
this programming error early and help prevent similar bugs in other
filesystems.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Deepakkumar Karn <dkarn@redhat.com>
---
 include/linux/pagemap.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..cc352e87ac2d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -296,6 +296,9 @@ static inline bool mapping_release_always(const struct address_space *mapping)
 
 static inline void mapping_set_release_always(struct address_space *mapping)
 {
+	/* Alert while setting the flag with no release_folio callback */
+	VM_WARN_ONCE(!mapping->a_ops->release_folio,
+		     "Setting AS_RELEASE_ALWAYS with no release_folio");
 	set_bit(AS_RELEASE_ALWAYS, &mapping->flags);
 }
 
-- 
2.52.0


