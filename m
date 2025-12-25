Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3319E784A6
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 09:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA5B6B0088; Thu, 25 Dec 2025 04:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4586D6B0089; Thu, 25 Dec 2025 04:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339946B008A; Thu, 25 Dec 2025 04:41:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 244B56B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 04:41:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3CF960A3F
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:41:27 +0000 (UTC)
X-FDA: 84257500614.20.6188B96
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id D63631C0005
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 09:41:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIlHeufL;
	spf=pass (imf20.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766655685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=taHYriZyJqrb06FJIXQ9lPxs5LOD7T/AS3erG0rvuQA=;
	b=oX9O3TYOEUd1rRMSS8es4t6OYZcnMlM5TFgn3RmSVlmbzjHdAnZ7nKwrZR+m03n6wc67Mx
	knz1mb4jiNqZpJe2UAUkiQbuMV9sPUwFdy97gfYB4VJX4RF88EfJuZnbJJMWYDLTaJibAH
	2d9eGEa0KsWByU7HBjbAM2etCnkB4/U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIlHeufL;
	spf=pass (imf20.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766655685; a=rsa-sha256;
	cv=none;
	b=uIOyIQPuCPCsCqgAqF7eJYjxj/CIYTP1gAwdjoEskA6LZ+CUSrfIris0IjFR6CgLRrb80k
	/G0VSAQ5/3mMbYicF5rG7Y1ezytULk4cKrkwTH7zYjCB48AcIhErw2aIKueXcFXZeoiLUZ
	5fTWejWtuqBDRQ7aXKK1PVzeJXmtZZo=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so6262694a91.3
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766655685; x=1767260485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=taHYriZyJqrb06FJIXQ9lPxs5LOD7T/AS3erG0rvuQA=;
        b=cIlHeufLx3CO/+a+iieGH8Uh4YaFyyiYIL5rPC5TIhuKwrmnmv1lHvbvy7Y0ahkQ0n
         ToTrRS/NVTWR22ccOh2727Uaj2iUIKr5xlLm00TFVrLj+ohmo+wT8hWVwLs12L4uym6/
         OdqDYX0hoG7KDlzMHltnos2N2KCAvsR15LttIwAqRhEqAcy56DZ6Upp0ALUBmXf9gYJ2
         SYsZsvMn0EgnhRgNK/G9KSD5xrcdh88VxwXUi09fspl5hmp78taHAJj515QvnhrDde2f
         RfTdZo23CYXMOpV4eS7kG9YX5OToMajS+3tHUi9O6JPYQqdC4P1rVIGvfCsPWBpO9GfM
         q9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766655685; x=1767260485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taHYriZyJqrb06FJIXQ9lPxs5LOD7T/AS3erG0rvuQA=;
        b=NiA2YNeWhwFqOaUhz1zvu8fQGi3bUj3IbeILhOLki1oBN8y4Sok+hsCCi4+6xA1S7m
         YSk3mPHH7GhxjU7FGdloJUaYoS5JXqZsZLlSj19/m9GnB9ofv8uwOKwyxnJ/SmXNLiPn
         rlrEIAtKzX9dUxDd1CTYcEf/EnQsCObQqHo5cnk4hGhTMrfJZne8RSR1eaTlRBVbon9x
         KZ7DWx7/lByIS9siW7wk5yZyiQv0LQfwfawdtA4JH2ikRZiI26iYCfXXUXOzCxnvWVhG
         8+SFGP44QE1vwjxZ5q1VMa0j0ZlMTdiVsvQ8t4Xs0TCRGawItKVYyQHtKcBXMq6SErFY
         EE6A==
X-Forwarded-Encrypted: i=1; AJvYcCUqtETCWabBND1LRNPswSilbSw2fAVUk4M1V3LN7Y091m6u9KZy6em6biRyvmvwK0TICP2WCkQCbA==@kvack.org
X-Gm-Message-State: AOJu0Yx9+OOIqO6xTZ13j0+6rnOqMRzn17695YIQqQViVtTyuHP0bJUN
	I0drMU5OnLs1Z27sZGre5z497dfv8BZqdtB6jJpqvh6MAlIMYVV2WBIL
X-Gm-Gg: AY/fxX54eBscl9Cg4Vmyd1wQ/EQKGvZ0rAGjvStC6ffb3UiMlzQ2QVSXZCkioRkLStx
	5AD8pnTr3AYdPkIeSJdoKWJXsvy0SYUrWVW/d1zLnJeWwlRkRN65zjSwgW9HRTPpSDJEv4rzoR2
	KwMlbjYT6gK1c1q7knZHryWfz7nLKKa1gcHof9SLPespt7vIyZWif6ilp/gkS2oNIn8aUX+Sf66
	UBhwLySDqHESfVzZcUoP1MFJ1KiUhF91iLcKaftsB2e22EYbU7+0bPahW4rBCCg88H9ANQxpgKJ
	aOeqjow2va3KKupKyDaf/4GVbnEQz/+3WDqEnjIyBvw6UgWRUZ2XRc9jNjKYnF2qpjFNGu/zSMa
	KHKhLhAdecY8krmTXXltZzsipzk7EELERllrCjZClfphcYIz+XKgEx3oL+GUtCoAmeWiJDlGZWp
	zywGNunzb+atvXNYMiqhqlAWCDwXb0NKJumAwKbs0=
X-Google-Smtp-Source: AGHT+IGrqIle5cdI6z84baeLzzXnwVkIIWKcs1QdFdPCQ67SMYvyYgcBa0IqJ8b+0pqT2JepSg7pFQ==
X-Received: by 2002:a17:90a:c885:b0:341:8ae5:fde5 with SMTP id 98e67ed59e1d1-34e921bec27mr15691054a91.18.1766655684598;
        Thu, 25 Dec 2025 01:41:24 -0800 (PST)
Received: from DESKTOP-LBGNL84.ugreendc.com ([209.146.12.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e772ac1basm8865105a91.10.2025.12.25.01.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 01:41:24 -0800 (PST)
From: Wale Zhang <wale.zhang.ftd@gmail.com>
To: akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	Wale Zhang <wale.zhang.ftd@gmail.com>
Subject: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
Date: Thu, 25 Dec 2025 17:40:57 +0800
Message-ID: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: sfhuhjkd6tks9g4ebfdjpaomfwg1wt4m
X-Rspam-User: 
X-Rspamd-Queue-Id: D63631C0005
X-HE-Tag: 1766655685-95724
X-HE-Meta: U2FsdGVkX193n1idqNd9TBzgCVgK2+mEPA8hGtlh9TfPPMHIRxhM7fWaF7w9JUsgiPYtfg4INW9o9hvLUTuMzWvfJtmflu/yhb+rv/vh8nWx1tLizOW0qefi5y9eG4wcw43g24FcOnyOIQKrHMERYMdIe4iYCum0s3v7KN/nRrFDbdbLVaQeFsKgNXpt36ysL27ZTS5COHFazZ1Fr3Vo8vC/m6+Z3QHejQdIXDdQi5TTzZRAIzg5WwMb8W8VPdtKWKGTq+r/D/Z830FlBtT9xKFlsafTLkODbS2siIlg7kx8B+R4H+F9qUyAE5M5QTJRxAK4dTM2zFhbBolCh4lcq8WesISRFL6PKLyaNeFtOaUIswHa9kSMhSR1tPF9RmALyovLzhjQ1BuVENx4xFLzMF8QB3alszXz+Kj7yD5/M6QiH07sjDFsUXwnXdicHGVr/jf2yMGTWkKmT/AXiFO124v2EBEcTw2qvcnAlefBozDPzvjFY+H4WuqodeXhnheaYeR92k5I+LoOowQBetjuBQvdiHv3Tz9ncedZaFPBl5o1IcNXVIChKadsiLMHx8iNqkAUD0aYHBoKn8zdGwOeIA6OBaBpubD1Y348q7wTTWEKDLUH5FfYBu6WSprsAjcZ1YHH8nszWHH9XliXklBl5F1HTRlZpHAVpOPIK2Qk/p8AP6/XxqJJ/DYRcUyLah0iQ12AWeJ9keLMKqVU2XgaBiZy1Dm545s7h7tXp6BjAIAGsVzOSkxGAP8QJ3eAU14z4+RHPN7vvWENn/bt4GQGi0vOHmA83fY0q63+DxvyBhLgrgkcsGOZKL5nJ7J1EslOQEoIp9AWy6zVgpyqGQf0lBire2/ax2bNO49daVPa8A8Om8S7rR0Y0URjVnVIGlfyU2Ast7Uw+pn52wObIbOb5qj2m6KoQJEah4Fv55HCVw5LhPzzr3RXrLR4cpENYtY4XXCMhwYQu6fa+mtfbqn
 O35Vkch9
 CDZLI+0g+EpXncgJK+9WmKHFyE3Y5TUpTcQs7sxTxXUGb2E6M0OaOSFLSKRH85b5CZEiLwdP5RR+nLS4GKIbx0joZ8AErYOPh23U6dtOerWL83w9aY9UDIanZuVNEBAbik4EcdDCn2M0gssp9PF85SN2icDKqNseevEoSqm9EppBNz5CWX2CZ2H1BY0fgfuZhBF88NgHdRyy3kehBtOpLLqQuYKK+rgyR+8S8viQPTusJV4z/Mf8SH9BQR1WGiVhGiuoAuwo67/Twu974WOnzhejzze2eHcf7MXiyrfFlMzmF7ixreBz7Zx3US3xOyHL6ML4+ZW+qi0Bwr9zwpfZkFjt2RlkbfQfDuABy74HmcG47qdCQWPmXAQYZ6o7AI1wgXKNf/S02QQxQYfAyZcZLw9VUY7wdkhNQ2C+CLzD4rNR6IqEXB56P53NF0OreqgEX1kJQIZgE2CyXLKhvy9d3EZu2gxGTfTJ0n5zonIT438S+f9LPS80Ima5tSpUeqTy+JY+lD4hjQ5m5+i6HLO4MGRJCQzpCJYdTyos661ysmXFIjpWjUjPuvvaVAhpXea/p4wZB8Ah9xv+k4G3VxA+KghLhAcA1duNIkKNMXv2ahGLqeRxRNFsvRUjfng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

../include/linux/swapops.h: In function ‘set_pmd_migration_entry’:
../include/linux/swapops.h:346:1: error: no return statement in function returning non-void [-Werror=return-type]
  346 | }
      | ^
cc1: some warnings being treated as errors

Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
---
 include/linux/swapops.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..84eb36d97212 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -343,6 +343,7 @@ static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
 	BUILD_BUG();
+	return 0;
 }
 
 static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-- 
2.43.0


