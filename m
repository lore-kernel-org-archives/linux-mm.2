Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764B0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F4A6B011E; Mon, 29 Jun 2026 12:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447256B0121; Mon, 29 Jun 2026 12:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383F76B0124; Mon, 29 Jun 2026 12:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15CAF6B011E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F37E1A0179
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:10 +0000 (UTC)
X-FDA: 84933507540.01.9E5C4EC
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5117140014
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wc6bEquP;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751088;
	b=iv+9w6ZAx737dODlhBtlQiU/poHQgK/iQvDINE++LYtMR8/MfjFfkNQwWPbMsp7CqukeI4
	t3CyURDtp3MZoI4V9o27oguml15MckFjFsskC9ZeHdrsk9RaYp7GHJex4tZJ0SqE9sGgx6
	yPwcUM523ZFnJfWbpk9J9TDZX0Ef/WM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
	b=UaqGYBnT5eUuhLbSt3V4luIC/JbTMmL4ztJZwS2rMl4nB3i9/MpAOyIe+No3yQlEVbZEin
	/ofKmz4oDfNyCOaDXXNkF47R1NgJHNKIe/hQ6xmUIho5ML4OrV8/GHBxkQoD7lkNB/FLbz
	B0OWB5c9JEQiMMU9y+DlH7PnFSmIc4M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wc6bEquP;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8478a25f268so708889b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751088; x=1783355888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
        b=Wc6bEquPaXZaIyh5+RupKT5cxRLPemQxhoMNx7wCPSzjkFf9Xo6MJPYmoXiyGMg6Up
         8LkvN7i58nFS3P67IK+Vi6szcTCQf+pFRtTtk//XXMDT1v8NeKwugJyBaLcvz8cJvzEc
         I0/WnuSdCzeffxbAHBzZ/0GJHuG2Rd9FA8xPw3YFjwNIAgFKTeU4mGaPhCY7wkmLGGOu
         FFh5ThDOuklPeeKHQYX+LgfqJDQHTJVX+1iZVfU4F/q1+p5UydRM5/ksxPPE8u6oLwDP
         BHlr+cghysJJisgDCSaKQOumzFbJbLbmiAIuLs/bHGYMQf7z5rnpWEGnNtQ9IQY+77q2
         YLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751088; x=1783355888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
        b=f5wHIOQDrDen9t2ECiK5T7AaUer/n+E9aSsIhqYnCJykZLA4IhxhTb9+1gtWngB1j8
         0/qaptBELDW1dD6mk7gjx0+wJ/ejlDQ4EkW3sLtuOXnZJkqVCjEVMG7KXWhIiMIgXfML
         Ii8+2UBu/aFePp2N4xBXnAY73Yw9Cdd6p0Gvr9fK/2C+6/r7Hsk/FVu/MQnRC/FNtVXX
         +JsaZimVmhR4c7q5hpaIJeRuUIfJIH+gcoDx77KnslidGFsGD/bWxBA+THWahsmyIr+n
         vZN9t3cG80cVvVQOw5Q3HMG75+9YZM7nwKRFDD+8tfFShDohTuNcMxvAyWQHaBMcJJby
         s8Qg==
X-Gm-Message-State: AOJu0YxFv0YmbEvePCvd3uVkrRfVFy/VXZDah32/5HwuclA2aen2UnCl
	2merInHbj0MMITwzESQ9IWyvT0klUU4EIkOO98w3KRi6OvleWSQJ1v/t
X-Gm-Gg: AfdE7ckF6WYnVJC3ntzdHXs1WD4Xw7bDzbw3wu12u67zTyh2QXxCtZTDDMXiQU/g39Q
	lwQYpzDKW8QpoTp7gKWMLNSvfy8FdXNwq6TsCLpTNRppFt4EZe6I17Nef2co1r2ibzu5lPI09ud
	E691WyySrTadW6KUJRDRvMa/tfKLMrFePWx399D+hrL3yxs3b7Yp1H1/xSF+eAEdHlNsE9HvX1L
	vN9DUS5BDNOTuR4GT6xNA/DqtG+W68NMnr9fO37cDM8/k4O7vob/QVOr+zdpXga3lZyaV116dfG
	MXNd2cNewCxGBN/gIOQ9obQp1sjO9RCuu1h/sly9zDItR0lGIY55v1mWG7f1R+KJGkl4gUpvwo1
	SZi/HkoKidL6ppizSOJwcnpaHAsFsuV7Rd7rRxZbVP6ihMu2eRzHSECGSOIPv5gIjuFABRM0zCu
	Vm7tkxufk=
X-Received: by 2002:a05:6a00:995:b0:846:169c:d815 with SMTP id d2e1a72fcca58-8479f2d139dmr206694b3a.60.1782751087602;
        Mon, 29 Jun 2026 09:38:07 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:07 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: [PATCH v2 3/8] riscv: remove unreachable invalid range check in create_linear_mapping_page_table()
Date: Tue, 30 Jun 2026 01:37:31 +0900
Message-ID: <20260629163736.1606688-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dtgqcz85814c9brce99of4ttytxr1ckw
X-Rspamd-Queue-Id: C5117140014
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782751088-99077
X-HE-Meta: U2FsdGVkX19+FQaUDEeNBiQrOrmmE66EEqWTguZpVQLou4gxK5XCWWTKZTKffl+L+0szCppLW2BiLMIhrJ93AIWO9+F2I9ij2Cx2aXwqkeqhibWMP9viKt8fvSEheclMxdRNPV08KsgkONmhXn5yyUbPJaSBQxuVbQ33TDkiK+l1ujBhbrSu88Q4v/E/7jKlxT5nIiIi6jASQ3MCN1QzQ/UmAo5R9QaqVVhWOkxstCQ8i7gAhScOisJFDpKg+mdCz0rqHuth7VybfFX/j2BXDCAWEhpTHAKKpDScL7vsB6x3wZ+T+jxGVYYRwhH6ZLj/6K8qfu7CQAR4ocuehY1uKMaMVca1OB1/3CHf5S8TNQmWrEk73RSl7vl2VZWh/200X09K8CncsVZyodP7ZXueaSqLavSfQGUBJJUbIn/WesDByPjFtsuHb9NR0YmbuTrVuTlDcYpNVbx2Uzp7o3lxrF5VzLeMf9PAZaem0BcqnDnnEBNXTYK0kMpbG/ED5JxYGLuijohvtZIPEQgdfYOP/r9cZ32AMJjo4aJQl9nZNRRqHTbVe1WT6loK9JxtyEOgKn5MIZV7FxkBIZ3tBNYY7Wb2qVS1+VrEfET/TQb9XWEz6ruAAKDdvfIouOrHvA62037GFOLMVhJeO+22Lntk4ZOqvfR/akC+1ZjGlnYBobQjZy7PZkh5/U2CWfq++j8/SylKRcSYZoAhZkcZT4Tf4eTFX3MzPPn6NU9IGdjIMbc2pOTaBPks+chZTTZpT4bJ4wAnK55f79Kwc1n8EYibBaDhKc2eBvRZTJ7dV2pMPw88k7XshJeBERJMmwhUWj0guSNDkliAikwqGYZSPokaq0wwNIrfuQzDP4sjEDMIWDrzFBE2QS2rYJEx1yDifAc5grCxrpzv/FF2YPCgG6XiZN+kPZ6DuKouuTmlQXI7IbREPlAlaI/7VsP5JtMRa/g0sygS6uQt+8Kj1jYO6hP
 U9MDRbOA
 sLwbJm1RSIz57/ri8Qvb97ojNpeGJH/f/lQ208J/wD+IG5sw9JPr2JvenCv5ZfVmQkmd1Wu3KK51wjxG1LbXl4Hwyh+RCSFWkkR3oRNtmkX+G4Vlolr3oQWJ17iuA6YlhD6dW6XoEhWL8x8A82S3qPoxK0FRFWUcGhzzWAvZHhIHJqtgKy9UvItNwGeNu/gDCo9M1ofADzxMd9Y8uHY7HGbm+tES5Ee+QpPDuqXxoa2RD1f2xs48pBpOwdmOb8VZjP+MAkL+9dVx1kerY8RWmHTDDjG4iGz3/BIk6RIFZQsHF0mXU6X6qKClH2RnJsoFSHFGxuCDAtrMrFcjmeVkD7IF0+dzho8DgYY9lDDh/PpNfBY8ZUI88vEre8vQlHGpRYT0I1ThF+6wYkSd4fbC0W5oA1WApRhfgPsrVDSrD0aFzQBRQ3dkjqQtSkZUU/bUaklio/kiu1C1VqjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_linear_mapping_page_table() iterates memblock regions with
for_each_mem_range() and breaks the loop when start >= end.
for_each_mem_range() never returns an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
 arch/riscv/mm/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..eb93c2ac05a6 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1229,8 +1229,6 @@ static void __init create_linear_mapping_page_table(void)
 
 	/* Map all memory banks in the linear mapping */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		if (start <= __pa(PAGE_OFFSET) &&
 		    __pa(PAGE_OFFSET) < end)
 			start = __pa(PAGE_OFFSET);
-- 
2.43.0


