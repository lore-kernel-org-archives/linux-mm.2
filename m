Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653E4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65596B0022; Wed, 27 Aug 2025 11:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CF16B0023; Wed, 27 Aug 2025 11:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53106B0024; Wed, 27 Aug 2025 11:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 956246B0022
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BD131A06F2
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:04:17 +0000 (UTC)
X-FDA: 83822858154.04.AA7DE63
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12693C0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:04:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="dt/RfV1L";
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756307055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FN3etd68yjlykSE7mt0F2RHD6jpI0nU5EsyPecY0KV8=;
	b=5Amm3aO+ubLwYbUG2pmZqnObBg0uK/SHKauDoKZU8DBUkmN6JbelXspRYgqpvpypn7/yWd
	NmlTPOaeOpSizQJ4z102Re3DXFmXty9oa2b2SIi4C+IauMozsr3nAXWiHc46v2XwSbKKQf
	mZfeRtqX7V4C3ej7SLG1P/h7IXPsGmQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="dt/RfV1L";
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756307055; a=rsa-sha256;
	cv=none;
	b=NLUOlUm4orSz5IS6DX7wYbMjn2NSJfZabrebeurB2HAFLzL9Nr1+zuTb4V7+soh94P1QEd
	JI+bPXOMiXaXgw+gpV5qjRQiWLIbJ1QpomKdkW8QnwDeVQl2ANQ5iZQCIjVK2wguoA8O3j
	mDtrF+M6bvWfz19amb67FzF81TKbUUM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3c4e9efb88aso3843498f8f.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756307053; x=1756911853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FN3etd68yjlykSE7mt0F2RHD6jpI0nU5EsyPecY0KV8=;
        b=dt/RfV1LR175m4bx3Kw9lcil7BTRPMfd5xZ5wFvFOot1RoyWgyqacD9LgFqXoy6Bbm
         5o2fbN+lmBEgdO++Ter5CWrVB07YnDlUZDQ4ovdcibyALCkD2VnLN9vmNzmVixtMLlsq
         AHjuBRa6HHYrr/WddNZf8Q70mdyZSpGSaRZTlIviwdj9dZnf1BljIWv9Hc978i70K2FO
         BXFdCd/ChEtweMLeS0iCicGSy/4dh7Ox++MJZ0aKBn8h3xvmjpU4YM/A2atNzqAi3wy+
         IQHmHB65r9CusXP+axq8XCZHZuTXqUY7msVN7JxibkHronlUFRtj86SPD89bj3nZ8Hb8
         FLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307053; x=1756911853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FN3etd68yjlykSE7mt0F2RHD6jpI0nU5EsyPecY0KV8=;
        b=q67ybiEDNpn0vn6NN0Nilj16fPsQ54EvEhWcVJ5nNin1yVSpdtDUURt6vP0M9VTEJT
         GuMUHaeqSX5QIywqi6ROUflAQvB8w5egTYOPOiZi+uWLuSlbgreglQXSIpCZTbfTcrYm
         Dg+unbNyfrWEM/Ftp1yYP3R+3SQD6OcfLpIGysC7T424KO0IirivRUQJYazxNufueeYX
         +vnjNjrCmeklefDcrMSfgcl8or3KWv8wwcUZcdaQi552guM72rJE8N4uIt9vZ+HTcpox
         AV366y92fRv6BV2qxRJPys8yTYXdzEnnfE+gmPdS5wywoQN+T+45cbfHUYsj9YiTp7TZ
         6udQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3w4fuw+YS/yqtu+Tbl4d3F7ehpET8MDMyHVd6SrGrUFYlTVcI+wZRde1CA/iIo1TTqySh1euTjA==@kvack.org
X-Gm-Message-State: AOJu0Yw5S8zflHzrp6pyd+j1IpYNkNRlT1JR3FgyfsJ/9HsTcjXq2Nto
	EyCUdIHmUbT+Bw36N0Ohd7a+vVPp0RI2seqsAQrKnTu6WqSZFtm61I2Q6w0oTH7V7q8=
X-Gm-Gg: ASbGncv9bteBLC4Co6CpZ+gwR+1MUVAOJGEvsYkDr7IaK0Mv6XxzgJM13q7VKirQY0S
	ZrlHwEkYmM4gtpa58rF2WKNxAzKj9JcdPbvSTe3VzK3e05sftkru35SiNWHtB+77TV3cRMOUSjY
	WNRXoFFNvdljXzewqcdPi7WlJDcx7pBjfCSN9XTctRSOflLBjyYSDFTc4SaEOXSbGyarqhw8OMc
	NiHsHQbVANHC+fynUUtV72EEFg0hmk70/0LqfS8C2UkqnUjpEsOX04eGFYjcsfa6foW/od7tt/w
	AVsppamOBK8z17iyA4EPSySy0jV1rV+459xJzLwqungVKod3WAeB0cxzEbditsEoDmGTI365COu
	k1BznQbbqHEnmZ1qxcns13f800IFTzQpI+2pu9lzKkb723FCpo3/1Hp0KPF0fMLAgdOQNiiq/wa
	g+Q4NvQu7uK2GPg87ja06CKA==
X-Google-Smtp-Source: AGHT+IGrW72g0ILq4UifqCK6TBTWBT1mHH+uWmSaygxM231xFkoJ/nzT7KcZcVt1YLhfij5DkpLHmw==
X-Received: by 2002:a05:6000:26cc:b0:3c9:9ec0:2055 with SMTP id ffacd0b85a97d-3c99ec02f3amr8669458f8f.39.1756307053288;
        Wed, 27 Aug 2025 08:04:13 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc98998781sm3421790f8f.49.2025.08.27.08.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 08:04:12 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
Date: Wed, 27 Aug 2025 17:03:30 +0200
Message-ID: <20250827150330.280399-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 12693C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: iqjyd6xscjjadm3xh3cwmas6n7aeuun1
X-HE-Tag: 1756307054-784349
X-HE-Meta: U2FsdGVkX1/xv8mXNfBi9qOTNPHTo1cEVDGpgRWbaz1HrzO/eHY2qM5WgsBA/eRJgPCvVt9E/UogultHUiBiTzELLnXTorVk1i06IVavzYh9BscL+onHla3aFw5hsagCLX0Vm3f/Dztg8FvkHDQ7ZC7+NUbaw5Sstj83MzexGP6sy30N0vL4MNqXidOuaFdqRl9m9jjwwFR0JYNwx/LPst4Z0viL9YMue74K/otNOw4n+geBink3Bpvw0hTfYBKJmIU/4GXxnM4zfTYys3Ssi/9C3W6N955n2Ip2zczBFLQWG8zDYJnQWctjAGZYCjpltUvyfRQJ6mzlQU2Yd+c5ye1qLrQGOSGD/MRBKxcl2Px7pAvbtWnLKhxPwJJyGSl8jnBSciP8H5qjr0FIeLqioJq7W8C5IP3ojOZPwlRBkWqNJ7sR0qLayg4GGol2jrYl8N/ad/Hy+jJp/NLnCW1Fg+1BmGnz7ag0lUG3raNeMJWr9HN778XOm0pbPvu8ONRz/LIH4/nUVqBo1v3iMOdzTd2FQX2ViqSha73gASccP0oZtJhdmUX0rWU6rkWKUrYIIPMLpMhfZ5Lz1Fw7c7wfojrz+5Aq6ns1N4k/avV1mNHjGyknePuAarY/zRhkKypPB9kWcxUMltlpeFwEpPajHYquUMERmTx63QLb17+hbn9KqzS2YhzIYPjz3WHxgiTjlUtUz0C/ASbb+bmV3LNjncVZj9ZF6VlRMojnLDRkcr1U9iZdf4Wc1zPkTt8PrXNZc8O2iW+bVQXya87QcuGisxnp9wBEOkqQZBvJCH9wfFTNxzQC5DaeNChn6UkzWhFN3HoN/eelACxIOt91N4yC7XWC8EsFXcZlbuM5YIn3Ly/yAof3Fur0dDCyIBDyX+9S0g5ebztJiilRD4EOp3wua2XMLcyFNt8Ei0AC1Tg46qz7PGyYek0aRmDXtFwXK7gQX/VN9XFtE/EaldtcJvW
 MTkaC/Gd
 XLj3lQloxBpk6aByT4sP3M6xGVzYeVgMZtEUmM1tah/0Pz+jtdDMWHuHh1L2DSK09uXCZVbZAiN+x/t5m4ON2TCvuXBtvrP5rkuPwQDyXZ0L/btDzmysEOWUnqtPsDERtskq4JfSyphAz91CTnmwjmBIuRKX40qBcvEjQSW8FTSOx0euOJwXtmzsnTpTlrVUUFqkrie5xvqZNrea/cjwW0nzwMplxylr+II7E3scNUzvpNW7vwM1nwehmF94sdzbpPIe+/LHsYJmsiOcIP+fNiqUE2/OvPU5GQheD81I0pnyVrlCIBiPYBI2LE6ZDMTKvXvwknE4hMibOPjrF0WyPUHzNW+cs64w02HmGYFgwz7wnysqD69f0YWZCkYybqLjkCXqHL3PK8ENLVarMBl/mwodKfMIKBxSUTmJd5pD2YR3Fmt2QagTJszeZqARAE1OFT4Gxe1o2SdzQhk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling is_huge_zero_folio(NULL) should not be legal - it makes no
sense, and a different (theoretical) implementation may dereference
the pointer.  But currently, lacking any explicit documentation, this
call is possible.

But if somebody really passes NULL, the function should not return
true - this isn't the huge zero folio after all!  However, if the
`huge_zero_folio` hasn't been allocated yet, it's NULL, and
is_huge_zero_folio(NULL) just happens to return true, which is a lie.

This weird side effect prevented me from reproducing a kernel crash
that occurred when the elements of a folio_batch were NULL - since
folios_put_refs() skips huge zero folios, this sometimes causes a
crash, but sometimes does not.  For debugging, it is better to reveal
such bugs reliably and not hide them behind random preconditions like
"has the huge zero folio already been created?"

To improve detection of such bugs, David Hildenbrand suggested adding
a VM_WARN_ON_ONCE().

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/huge_mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..bc9ca7798f2e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
 #include <linux/mm_types.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
@@ -479,6 +480,8 @@ extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
+	VM_WARN_ON_ONCE(folio == NULL);
+
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
-- 
2.47.2


