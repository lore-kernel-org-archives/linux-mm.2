Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E19C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322146B00AC; Fri,  4 Sep 2026 06:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA196B00AD; Fri,  4 Sep 2026 06:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9AC6B00AE; Fri,  4 Sep 2026 06:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F22B56B00AC
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:49:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88FFF8088C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:21 +0000 (UTC)
X-FDA: 85175758122.13.3820A9C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id BEA52C0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GWJMTSIB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvTqQo1kkFi/Zlhj6jPmbfvUoufzoLUlgQD0pvdpiaY=;
	b=xw16alR5wPUoDmF0wADpSqVW3j0mZwa77rZtWVW9ahHCsi6XugOtgozn70P2XvWeLgHOKp
	r2ZDq9G6xaV+jKOZkHQ+nAA04aE1fcBRgJyoGUsdrhN4sY3MOc5gAtnAhW6cWNi0MaIUvE
	05GcHXCpC4vwWnNb70HEsrpKEvLR+gE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518959;
	b=5TCp+bgEAibXrK3Zpz5OuRmdXmtoKuHcMxP9dQyUSn6f16XfALhnK50T8HKxUqEISqHJKs
	KN6qdbLXck/yHfsrFZ1DRIrPIa+tRccs46sp525kHNxHBkbGmKwKJU/mKhSoK0ZJs3jPnP
	Mt+G6l19v6U4DeLlTBhZJr4VPWTq2to=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GWJMTSIB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d01663d816so6223665ad.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518959; x=1789123759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IvTqQo1kkFi/Zlhj6jPmbfvUoufzoLUlgQD0pvdpiaY=;
        b=GWJMTSIBEBX37o7YAJnl2IQ01G0uD869G832PVycphUb+zRLmS+/8pe0kodiEOdIXE
         7KS4BkOHpG/S8BusNq0UyNhDCc3HX2wnmZsSmAswy5rLs2SRtjq5SoKQqsfR/jThorhi
         5H/fiIhkDeVd6Y1Rc4yrY5IfqWB9ePOW4XnEbBhsyV136X9yXVAkekiYXoArPmQBgPUW
         uhDR3j2ctdaa7JPichEKOliVZzXbQTC6tKbPY9S+KJZa9DwebouX0LwHDMO8eZk+1lx8
         z8PSL01kjxdmxBT0Vg7EA5jKZ/SiBYclslkYMaNdWpVfSQWHoiWSLG/LvPoewfMRD+Ct
         zY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518959; x=1789123759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IvTqQo1kkFi/Zlhj6jPmbfvUoufzoLUlgQD0pvdpiaY=;
        b=kqKrhMpLS5PB8IBOhCmdE/GP5P7S2F86TgCMD/s1NwhtR6WrgUBVYDyvnnuYoXA0fi
         SlUhqrEAYgijRJrje+QStgl+bpueN0EL+fIQWFqQmWLpZrcO5KT1XGbtEC41tf3scT2f
         vSQI4TFJDagphptvxmWbmdynpxQEDgbfBBljneU9eDt5okaWb7g5t4Xqpl4Kc4iMBG+5
         7Lhb7mj5JsrAjEUokT1qASx269f8VIfYmhHjx4wWjbFScqTBBoVmBKgGtX7/YWXG8YzJ
         GVbvaQUC/rL72y96pY1jog5Fy6ObVRn5f1Xs16sXFQOg4dFbTrW+0swDXTYRdDTJkdmD
         q2IQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXDHIwY7sJQUFbABpJV4AOxrtDbx5bxUbaDCu8eo8OFZwAnXDV23ElSng/dIHVidhOubpiFZu7/A==@kvack.org
X-Gm-Message-State: AFuF++kvlG7osJZz8S2s2ZtVxmVeZYrFVtvKTl02n8x94t6F7tahM9OI
	SiNQ+Wwt7oxV3cdBdemRSX84+Z9ZPKyya4c1eCpE1ESA0+0XDWjnCZrkN7XWTWQUkLc=
X-Gm-Gg: AYBFou11YQGr5e+HCpZxIFJRwCOoYpm9ry+lekGnvmavv47EobSauf1qxKrU9/joDx9
	xt6YWd0yGrOLJ2cYOJHkKy7fBpF8/CZ5NyBcMdOFvAsUhhpMlU0gqKFgUhrwUUTZFhdAukjT8jA
	2XAEsuCALxv8ovnLub1xSW8eiL5m4GEGbkMeel9awQIwUSbKgx+XD8DP58/wpVybMJbCO5cJL3+
	CTus4T/4VN0H+fwE76R1LirCn+l2qzpPMHiu8sBRGC+Y5wOqDYD1X4JPMz9zPrqEXzmMsrPIs4F
	Jn1Z3jlQP+EH7H7sF4XabOb0qH8V1DG6M/G6eknDjq+n5pAaaPTpcTsypYWvdHduLJjAKXcD7Kt
	eKgb/OB79kUYIVavCzRWScItDoCuEFDgvmTBrI0/lc4eK5oqjcC1rFobqqwYKkKjuvpkWQPzurA
	jYUadtsUVk7wn7XaPgtOYIJjKFUtwQ3VYEca89Li/oGXfIRF6KkSPcccUtRiGoUjiI+f38T+Z2Y
	Xo3VEjFi3ZDLow=
X-Received: by 2002:a17:90b:4984:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39b26104798mr8006465a91.6.1788518958544;
        Fri, 04 Sep 2026 03:49:18 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm8583927eec.16.2026.09.04.03.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:49:17 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm: fix typo "mergable" in comment
Date: Fri,  4 Sep 2026 16:18:49 +0530
Message-ID: <20260904104854.25272-5-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904104854.25272-1-hemanth.selam@gmail.com>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEA52C0007
X-Stat-Signature: o1pq16fe8e9mwmwizenzpqrngg6769rg
X-Rspam-User: 
X-HE-Tag: 1788518959-85868
X-HE-Meta: U2FsdGVkX1+PzdpfA+rXwXN1oVMeoYTwJX2mL+JDEO0eEcHEFNHi8w+eKeGEhCNAbX+AqoCPcSvRBTYl1QmEbrhtKWxz93H33RgstpzynGNMUxbYruGdigqTJnGuM3HMMHnyK5wgpqvk8Vy+L6fGjZOG1cz7g9DRVg1GaQMsmwxpS7RAZKtCJPrjYZBiiZcXuqiiA2BurU0njEbs3wm/m6NYK3Q3cJqfqC2n/FOPcHIJcdoYyG6vOcI6zzJywC1FTmYpqoOZ4iNgNeIyCnpVhiYHvGIhW8WcFy9Q/xaBsW1n8bcsxqO3ZboPniNIx6J5QGLZz501M68gFun+uRN+Q3MxtUaheIKP523rVRN4e7DCnP4KtQ+hqfLo/JVpoI5FNh3a9zU0jZH4sD0TtFL6EPjqgidabh0UHOakpuiwzuPMtN3Z37JX+fOcGbEJMsRsUm3esbr4MYDS2moSjGbRK8WsfLKImjsyfz/1TfmtHW7oOX/j63lZKP71KW/LudoUDs+/FN1MRY+x7mOHtDNm2L48ksRWcdcKyB23rWrfsKaYe0kNFOAeSd4GAvoDEKAr3RS+QPNHrTMGDuF9cBameFtX3Rqq5thcZCd0XAhJy32RspQMcmBY7kjzcei02S50ONFkX1yIk2qAAtiyCfJCteBqKJ815icDEaVjlMw/rH22UTvwdR7aQZgwEBCjMvJ2rwcaE2Xl7B5a2e3I+DRMUsQz/D2yYL2iF2W9fFKrYgGYeHPq2as/NmUA2SYsjFmRbaiGyK89eCvbox1awF/Ecd5GftbSVyTf6yADBEk5oxt6037Ry8qPNdKUVqYNKr0HLWQsV+LZSnq/2WUs4QgHeoVgiiKUuGioESsItilGfifrxhVGuWxgRJpP2Ff3iFJEnguAa2cGnKAf9aoxdaKa2eU9ykGspRDv0C3rcp/iu+IwlGqIGWcpLa9Qnh5k3nCoSQQl28FBxG2Wy00tNgk
 8cB3s33t
 5NPpstxhmIxrxLEgbdcxRwS2yCGDN3Ezc/3SLaxAqIxTP3YCAl03zQXw12B9TwOA2sqfb4wXpBiI8CDgoe5d/yfGEowSyRDr6tooeon8SXvjxii2ghz7uLGWYIGW7wR4F/TeaDGvHmpoM68FcyqiOKSTFss+1MVNYsaWK13LPokNTswLIQFbUcz3c91POosermWpEbjAcNgmrWW2Pd9OXRLEwSDGejVpcO5f7AAnBvmc5b+6krEWR7EdImT6Hn0pPCnbsiyesFKlvPzhb6hNXN61oaL0JddRmJauKgXIcGezfFWcgpsiigh/1PKpGiz2X1/dvkVodHGok9DkcS89NCGPrftsAjHMsPxcCHpsgPUk348/Sv7r204OmvKTsTa5MJSA0k9CeGlnwUMnEn7MGMGuDzLTs9gAjY1v1JFHVjQnTy8I8l0sDWU7fjymqTNWTHK7l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "mergable" to "mergeable", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..5c856b78ddc2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -587,7 +587,7 @@ enum {
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
- * Special vmas that are non-mergable, non-mlock()able.
+ * Special vmas that are non-mergeable, non-mlock()able.
  */
 
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-- 
2.48.1


