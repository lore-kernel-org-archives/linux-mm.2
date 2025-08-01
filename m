Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A406FC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85358E0007; Thu, 31 Jul 2025 20:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6B18E0001; Thu, 31 Jul 2025 20:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89BE8E0007; Thu, 31 Jul 2025 20:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A182A8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72FE5BAD85
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:57 +0000 (UTC)
X-FDA: 83726300994.21.541BFEB
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5FC4540013
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYCtB0fO;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdRz9q7dLOqqdNdkm8h8OqDbX3LI7OI2JzdfLntQtvE=;
	b=FpWCDgwAskAN+k8vqrXq7BrZnS8Kx7WY/W9UryQeVW+DlY+UEXZVRu7BKnazB1177FxnnC
	LpIw/GNuaRUuedszE6QX0G5mi/07R1oCnx3bf6yhJ/DEURRohPy5jqb8s1KvJkabrm9KgL
	zueb2ttWPBiefHT2uX8W1DP/7a2HTwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008075; a=rsa-sha256;
	cv=none;
	b=vWGTpOjfJUTBJuPigJKWwfNL6cjuQi4PM5KpuWfCtFB8K92HzcbjUvZMM3DTu6M/Hkvqdr
	DG84yLqROPWTvKiQlla4MreL2mkkFGxi4r+g+Bq9r2Za8UryWK4IietpnnKPMrPTYhD5ap
	FJv6ozqpdgTq0eEj4KS7Ov9WJwwHbOU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYCtB0fO;
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76bc5e68d96so1117622b3a.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008074; x=1754612874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdRz9q7dLOqqdNdkm8h8OqDbX3LI7OI2JzdfLntQtvE=;
        b=jYCtB0fOQzQpT6jmx2qgZiVEn3Fnlwqb0F4zKEjfW8H7WZckqkJ8Yg1HMNgkl7IwEo
         yS5eqyzeYoLkBLa15uX3oilCDeF7vbq9SOjYwhQfz2ADqRhmReijv5WWz3h75czpXheD
         Cq+Q5CMhgwvDxQRhDL9+AFTj2iKvovPs/HJc5zz88VtaNA1BYugxfZVjPwwx3OuWMWuk
         wK7iChzEM7bLhsDREGUQka61QgmoPDRKCuXmUdBAUsVDI+yLbSK9w6vproTup5z56IGf
         ATk3bkhTAp+1/oHW+Z+Zea1UpoAhow5V818z/0hjj5cwUVK6c56e7PdZZ4vG6H6qYl3D
         CwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008074; x=1754612874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EdRz9q7dLOqqdNdkm8h8OqDbX3LI7OI2JzdfLntQtvE=;
        b=sIYKqN+hDVIhMPu4oQkwscuifshcxm6JX6E9opgJBeFrvWDhnETZFODy9LPo4dARrR
         J/wpg7RtS8eCiWnHZ8AXNlN6JjcFZfhflnTMClA8fAFCM8DKuEBUpHxZta+9t1tjEKzb
         +2mW1UopEL5MaWClWdq2SsG5fXdpTJnGaXTufrspYJBvVN0oH6o6sl+EAN2wwH/YKTop
         MDqNkqbij+WDNlJ/M8/01cNuoGjzO8js/dBBPlp1ymGjnLOHyKJlOwHaxzikyX7IUMNA
         KCvI1RHKTQfDdZ12L/uOF9THCI84vpufnj7qE0Ph+U6ZOG8/eKd7yiWuI0FoxvB729FX
         aT0w==
X-Gm-Message-State: AOJu0YwVKVfLOPbc2oqZCIWCmbOF7D2oh0yB9JNKe7lBEGbloLxkkIsB
	uqeQogyDcZX3d08RiYj86dokYWZp9X5kEBOzNpWwrpCeZZZR8/RwGOgJKCjHWQ==
X-Gm-Gg: ASbGnct7yFRp24DOGY2ipM6bJanURokK9nbSueQByglAJTwDxP6/e/8jaDB6/yBXPpR
	1E9LyU6n9WNGsJG9l5ix04vwlVW0/cQDlneBafJ2X1yxQvECJu3ynDzy5r5mhZLeLrbihUOxnyf
	QNQ6S3ePoeXEZv5bO2djn0+EzFDz0SEwrJ73bT7DqhawnWgIa7zr/W+w285blfDcW9XTt6JJNG8
	9YgbfEf/zWoLMVktfGZVxI0I51EPK5+vtK5KQIVlQqsIH2G5jG/Ooxjbgw97da16G3mF5T7lQF8
	7SjHSDghQnhvDAOLfMqW+iNRXyXi7MJgMEWVbQWjToQ+Wq105qpI9rJrRVSweN1X+Ac0Dl2oa72
	EhLIjnQZ+i2xH8z9ETg==
X-Google-Smtp-Source: AGHT+IE2eTaDl+wmfJliugEXOoJY7F7v3oLACX+cFUkV/3LGNbDY5rsM5LpXKvBPnATgOkUarm0T/g==
X-Received: by 2002:a05:6a00:7083:b0:749:bc7:1577 with SMTP id d2e1a72fcca58-76ab1614e85mr10747796b3a.9.1754008074092;
        Thu, 31 Jul 2025 17:27:54 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfcf5f7sm2660467b3a.88.2025.07.31.17.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:53 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 09/10] mm: add clear_dirty_for_io_stats() helper
Date: Thu, 31 Jul 2025 17:21:30 -0700
Message-ID: <20250801002131.255068-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FC4540013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: zxqak8n8mu856adacoq5uyxipz75w37d
X-HE-Tag: 1754008075-530978
X-HE-Meta: U2FsdGVkX18EzCcqqFutsnvrfiS9SnWjxK4TnphdpQ/cmqz8Zg4aIDvt/yUNMAT+++uxQKJ69iajMem/d8XRIDNYhOZEiPJTV2fivS9GCV6k+0WxkYOH8XoBRAQQyGzptCD8UwNWdq3vbf+lA7QT97Ed5sAt0+Q7PJ+2g9tyIYuqmIbO6oA0FQKbzAM56Q1Xq3JESFiamZq4eC4VpM0ZuDNxLFkAIKvnuw4tGm8z2nMUJ/ozicmtCfiRBS0Rdh5nE4C1dCkK3cVMo8CH7nYnk0GhVsewJQ0Jy9OwgqjZ8MOLybAnljV2F7K/omKY9hmIj/tZCqw4LEZsJxsfguocqZFI0xMI6s4wk5bE6KGYD4WYNoK8+4ZK8mNgYc9KYjue1CI7zES/mzjAMUSRwyvqVa6WHJHYTpzFrl/uUccr+mQ1ES4CKfrLMxcFpPKZlDWk1xQlGj7GtJatvMCvkJS8s+vxg3Qw59Kt/FovdIvpiuAgPImoianfe8EH02PxQ8n6K11gxmWrqU5YPoS1GrjFCiwJd1BgpI1UONjeOyad4WRmycys9KEr3VaO4JtOv0efoCk4HmxF/vkMbpxsw42o6+CoIZvLO1Cto6yNV92/iPpM8SE6uibJLOMrBAS6dtbxhxxUEhWS4jMxhvFql6lfT7LIHNhV8pxAOD+4MPtVPqfnC+yB1Ig5kWUF2wPUrSM4HH2qFGLK42xGfejZo/3+4wXawtsA7HMzWLV+sCVB7qz0wj/zYrWpIZuhtEwHa5lwlzd2jJNPnvswnBy01cq9sob1ejTYsOCnZKFsjxX9AuYvg+ykojboJQhINjWxGzIW7nlqhc4/+qQgmXQD2FEnPBb5klef5ZlSVp3Ey1QzjNX8FSOXKD3wuaq0/6DLRBc/V9twenmaCUm4PBiANpXARTEYiBFkLGzhdcxdATYlsKbsmmDT3mU4yzhe4Z5D//YvB8//lEiwhorC0Aj2VoV
 41qg3yAQ
 N/02hk8zl21LsgwRJjHM5SZfAGi3nezxv42FtZPyR7D5kW8hnnGRtXb3DZx8lSZeSqllwL6qwjzWQARynqrGqi4ZJ/eBCYEjvmkTZIQCO5d4Uyj0dF9QKDcweADdHRtgOh41EUU7/Rw2ugn/eAXwfUf7gac9HhR56hHZehxJAhcR7Ti3KEH0CGiB78Xz5033Vt+shFQcHwC/8nPjPyPL16ehI3HqR2cPChJ+ugxhafrZO7VvYhbw5SqqTlxpPJ+6cll7/dbZCTn01OjjdoAVTvt+TliaCZHUo05+oI5fsBAC/rkWIXi9Bzidb8HVwYZS7TfIxfNqmPFmPicdFRXbYK4KUDzSEOxw7B6sF4EsvFWA+0nktIWh5KoHS1i8w7TBSWpHiXJODSaFr2H58jWHApfk86S++rwxaai7C4edpU8qMGLFjgn/8wIWpJhPSPNlRiL3dE6hIGE6YQEN/mlCz/0KwBrOtqSvCozXpSkXOaBk3Exn0/7tmSPj8Aj05BikdE60x2kn6VWwVyTxQ0/yOddFujFTHr7plYGn2A29G1N8x7X4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add clear_dirty_for_io_stats() which clears dirty stats corresponding to
a folio.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/writeback.h |  1 +
 mm/page-writeback.c       | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 000795a47cb3..8ca0e106cef7 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -382,6 +382,7 @@ int write_cache_pages(struct address_space *mapping,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
+void clear_dirty_for_io_stats(struct folio *folio, long nr_pages);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f5916711db2d..d49cea4854c1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2711,6 +2711,22 @@ static void __clear_dirty_for_io_stats(struct folio *folio,
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr_pages);
 }
 
+void clear_dirty_for_io_stats(struct folio *folio, long nr_pages)
+{
+	struct address_space *mapping = folio_mapping(folio);
+	struct bdi_writeback *wb;
+	struct wb_lock_cookie cookie = {};
+	struct inode *inode;
+
+	if (!mapping || !mapping_can_writeback(mapping))
+		return;
+
+	inode = mapping->host;
+	wb = unlocked_inode_to_wb_begin(inode, &cookie);
+	__clear_dirty_for_io_stats(folio, wb, nr_pages);
+	unlocked_inode_to_wb_end(inode, &cookie);
+}
+
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
-- 
2.47.3


