Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD29ED2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4AA6B030E; Mon, 19 Jan 2026 18:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C22C6B0310; Mon, 19 Jan 2026 18:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE946B0311; Mon, 19 Jan 2026 18:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0776B030E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:02:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 950A21602F1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:05 +0000 (UTC)
X-FDA: 84350238210.15.4104BB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D93C320007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:02:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcsvvCSb;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkAMfu14ban9fbdKWJY9K317QICByqTTdI8XjZIo7V4=;
	b=fqlnXYdq+a5zE9B9/g0s9nuJhAc1n3idpZUd2eeTSzjjVEglLQUL6W0rFuqB3zJliNZHtA
	AM1oXSWyC0k+3E7MuL9neZkh0NhN0DL4Bf0XumUFTynNVbbisxMkjmOTNE0P+94brYZWGU
	sNMfGn9Wjq12+i/gGIdKV5Qo0RwR+zA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcsvvCSb;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863724; a=rsa-sha256;
	cv=none;
	b=ULJNcR2gg4ixKEWibn/4bymrfO0NdQAPZoUztaOAUl00UjAIbGjjlsH6XBT/wNfTl1n/wF
	PcyPAI1lOomVMke8QZIhBqr2Vm9mM0opjXZuMCKe8YHP6/CW15wlpPFnsfvSrsAp+K7eFu
	aACWs8uz2ljIABoRAz4wySSZKRmm7l0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 008F6442D3;
	Mon, 19 Jan 2026 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE18C19424;
	Mon, 19 Jan 2026 23:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863722;
	bh=U9h/5fXRDF7W7U0nEHjVvjxN0NehshCtdso7ivmglXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcsvvCSbK+FAI50L4LUCy7S8qMDHa7BZczOG8V34OArhg9CDqc2V99o7JHKrpTQjV
	 zNbzikPTwWbtWAipBQP/qpedmcfzVJZniN847kfNIHb0ueiGuxV02dEsCdufUu0Mgm
	 7pYwd3/ivc1I1KVKmPt9HnVuL7asbQd50TAani06TICtRE0Kpxx/9Cd6D394B3sHIl
	 +XEoM4GL1jrLJTrKt3yYImBndcgY+WEVGXogMP3gOlor6Nbs8cICwyWE/en7a+Be30
	 FhUclUMPBHmYBJcwElvhXgr6nfEQnR6KQS1JuRWMg6JPVtw4oGhiy/LoIeUJSN5crc
	 vqAXwFaQSWUKQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 03/24] powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
Date: Tue, 20 Jan 2026 00:01:11 +0100
Message-ID: <20260119230133.3551867-4-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iyr88ibydrrn46wadgb57f316un6cr3i
X-Rspamd-Queue-Id: D93C320007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768863723-914942
X-HE-Meta: U2FsdGVkX1/naw2J7XC+zIKSpoJXuxwmN5ltX9aFnyf885fpNK/Km2UI0xbpqCHqiBQDgB1UKgbcx7Q3mygvAVE+b73i2Pc28Tn+nRBKRpIzEOkJ0PQeNucMC4lhLL4uRTDi1xY2kb+B1bODkmfw2cb8ovehhKn3SIOFQGv9ELHhw9ltil8slrxLYuLCpbzwzAh7fAb18Du5O04fST5eDWywdBKY4ZJisOm2EQ/o0RcVp8SchBUW9BMEY8830we1dyfFZ1ox9fxqnTFna402/rtNJhEqLSt/oyf515Tghom7j3EFhoDj1Z/ciH7wfvZ+DD5FDliAI27cgGIXIZaWR7zc/Qja8ZNTfr7bxOaTPk3Z9xZ8yFT5P40iRrv6s2K2DtpaofsnMv1DAXvfXwxu/yPUjKSWEVIgnaAIGLwOpu9kElSDwIZvE3dpdWLLgtpuiz+rOzsDqKJYhLlkvz3u65t2uyypWsPT8illXSnht7pK6ksuQ21/VS3voIhJp/2zgmzEjHQvtewfXqlVhIcs5MJnoRsdukwJ4x8HgUmcvIN8ENngXFLhCkBLGfjt35xXYen8oazSu+8XoWvYnlKI7JddjofSMQWTCxMrZ37t4fDZc66jVtazGG78hG4P1NUZEME4QpAKMUNtujjjyHMVbrFLft6rWZa5Kq9fjDyoV6Gh29n5l1Fcr3NjPa3qUmn3z6Sh8wfCo7tCcip5+67m12DwpOVf1L3gJXxHc5Lv/YlwLBmzlJzzCQN5TZKQsfu/WnC/JOA9ykCrS+SKMK5fMFH1Nqxpb8ZDAf6dwPQGqkDLoj1y5KSn1XS4kL/32+5xd4SdTyPndDHlg80zseWMwXRPHciu/HwvRXHCrkeLgGG1KZ0+7Y4SpJ8ZHzarnTXedwyBTRfaajl88XxmB6iAsrIkfIIME5pSBWl7FI7yfxeW/eWD+PH8ydu3rtEImcTRXUiXRRi1+JvFKBWKjoE
 lfcP+ks0
 VNfNF4xdQk4R0kUg8edB/fzjaOElSKVFOIzXTzcvmhSHwGl8Pe1JdQjVX39RsN3oDhed/V2XTD3waHcYY1U/2B7/S7sReX0UYtfqiWsWC7AccIQnNbtZ356BwzU1h6oXLmQ3eYR+mlk8VpYrctF5TdAbVP6Is07BkJO1kyxpawhoYplagDX1ZM3s5phFUp4szGmku8I2PPy4795T+UanRb6cwBNrFtWS599G2OgJyhc4yGNytYrcKqy/Hy7BT9sHCetvueZ3ExVFjfy9Htz1KNTygxpdZqjaKoFGjtrO19XcexeN8zHANa0U9gA5RahgEl0bdFV4QTqhAIMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that there is not a lot of logic left, let's just inline setting up
the migration function.

To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
the compiler happy by only providing the function declaration.

Now that the function is gone, drop the "out_balloon_compaction" label.
Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
to movable_operations") we actually had to undo something, now not anymore.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 arch/powerpc/platforms/pseries/cmm.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 4cbbe2ee58aba..9a6efbc80d2ad 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -548,15 +548,9 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 
 	return 0;
 }
-
-static void cmm_balloon_compaction_init(void)
-{
-	b_dev_info.migratepage = cmm_migratepage;
-}
 #else /* CONFIG_BALLOON_COMPACTION */
-static void cmm_balloon_compaction_init(void)
-{
-}
+int cmm_migratepage(struct balloon_dev_info *b_dev_info, struct page *newpage,
+		    struct page *page, enum migrate_mode mode);
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 /**
@@ -573,11 +567,12 @@ static int cmm_init(void)
 		return -EOPNOTSUPP;
 
 	balloon_devinfo_init(&b_dev_info);
-	cmm_balloon_compaction_init();
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION))
+		b_dev_info.migratepage = cmm_migratepage;
 
 	rc = register_oom_notifier(&cmm_oom_nb);
 	if (rc < 0)
-		goto out_balloon_compaction;
+		return rc;
 
 	if ((rc = register_reboot_notifier(&cmm_reboot_nb)))
 		goto out_oom_notifier;
@@ -606,7 +601,6 @@ static int cmm_init(void)
 	unregister_reboot_notifier(&cmm_reboot_nb);
 out_oom_notifier:
 	unregister_oom_notifier(&cmm_oom_nb);
-out_balloon_compaction:
 	return rc;
 }
 
-- 
2.52.0


