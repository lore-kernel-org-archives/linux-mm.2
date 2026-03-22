Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96457FC72D4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A786B0005; Sun, 22 Mar 2026 15:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B1E6B0088; Sun, 22 Mar 2026 15:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C410D6B0089; Sun, 22 Mar 2026 15:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B25BF6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:03:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4328C661
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:03:30 +0000 (UTC)
X-FDA: 84574622580.20.62C730F
Received: from sonic303-22.consmr.mail.ne1.yahoo.com (sonic303-22.consmr.mail.ne1.yahoo.com [66.163.188.148])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83D41C0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:03:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=kDiCZnDi;
	spf=pass (imf28.hostedemail.com: domain of abhishek_sts8@yahoo.com designates 66.163.188.148 as permitted sender) smtp.mailfrom=abhishek_sts8@yahoo.com;
	dmarc=pass (policy=reject) header.from=yahoo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774206208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:references:dkim-signature;
	bh=quVbbkHKpp5ZGnxnru2x/5vYGBdSIgBPbh1s2Lh97YQ=;
	b=KPiTUN/yEKa1bsvkQWh3r+NCZSmsf0bmMOqG+gStfLtusL4xUbwjnjOZg+6y0WeghnFy7d
	Gq7jgrAHqSWXPP3lhbr7jfhkmDywVGpnos50dsChmvE+S1wc6mp/PGO8XoYR0ifhNlNN9H
	74NWvy8f1OTHvbE0N0W6t6QAKxn21nQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=kDiCZnDi;
	spf=pass (imf28.hostedemail.com: domain of abhishek_sts8@yahoo.com designates 66.163.188.148 as permitted sender) smtp.mailfrom=abhishek_sts8@yahoo.com;
	dmarc=pass (policy=reject) header.from=yahoo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774206208; a=rsa-sha256;
	cv=none;
	b=WKBN2Ne+aLAQ+CfQrvMEaRJamvvZoB+gusT9OWW3niMKrwFJ5vLmmbLmDFEfzAWL01rX1h
	BpNK2O1GyIqVluU2BR6cqSZAbqP5s15XbHU9CjeJ2gdX9gStKY5hsCM9opUCdgW+d+0dS5
	YLZi4TCqaIKft3KVIvB7f2Ggjf4vu8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774206207; bh=quVbbkHKpp5ZGnxnru2x/5vYGBdSIgBPbh1s2Lh97YQ=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=kDiCZnDis0JKHWS6BlbWXoNxMbkSE6hviVM50nZ7NZYjMb334RVrcLBSggF98VFCGbvk5TlnIweWmHOoENIXIBjoNZNfXoucG+vxjJVjbMsJ7pnLib+kwYh/ChZ9Hy9pQgOklSQcTZLBaO+7+G62TicY93MtUUOvAxtClXJHVC4ZJtkdsrQZ7ExabWwgoDLHbbpzEdGSJrF3qZcA6jkLqNFYQIHEg1Lnpe+xPOhs3ikkcgONXiPbKbHtfsJruomnfi40Pwkko5sbvrpDC10OL4rZPSTJMeQBz3arNnWqgT63NPI23prAVUNQvWQO9PvdxmuT9KE1GhVOsbjsx1BCiw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1774206207; bh=Q1Wl/VAHwHa74L8+7wK4Nf+dzH1jmWWgGcqp4T/MAVy=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=PpkbLf5zFOnc1AGk/Wipaaml76xrDNVL6zAlP+3Q1UDUVLuU25vm/jrC1X44DRi7Trs2pAftlQrB9Dylv2Y8w+URIrhcFADrj+Dn0RtSIZde4IswD8AldO2t4Lfq4kon+PVOrmeHhuANv4qywnkjTKo2yqJgPL/hjchyQbQlZdbJIOFBqNvp3dOU3L2bVpadmVsmpMhV68OytvcGh4Ni1Eip1EKVyN4RCWPcxonRzznFPb6ABYcq3Np0LEPFuU69ko74GhuwdeohgS9K3R3u3ODjJg4yYTgcX/6vUetX+1kd3Ug4NpFsry5wGEMADLP4taWzcUBlrkKAF6bY3j5i0A==
X-YMail-OSG: TYhOdaIVM1mzMs2NfJDujBCerfxoWUPwJ4wyk0iwCcX91zu.5OxqtTiJHb6j5Qb
 c5jELhdwpxZduOHFAp33EecgydlVyVXHhvk6RhKEu19XNauNwN0KK55MHVPbgzSIczqetnX_0Mi3
 2E0Z3VbuKQ8NhHdm0kCmPoVCEnKRemn1zN5ksN5mik3QTJuXroqiIUrXVUGXCw.uzz4lSKSQX6_a
 Ord5eBjZKKv9fI.QROL8o4hxtIcg7Y7.Q2mUtGV0Qm.it1AlAeAhaJR4wAouexhEUndSq3dGTAUx
 Nq1tilAb6zkYRKvypX7lCcT18fByB8J5NGrrhzykNgueHfbUTkPKYrBB7K15m.ivQn2s_8PwMkPG
 X8gzCT9GdnXCV9ckKRefKibNvTpwu5vc4CB58zSseMznJc_ktkyFUdS.7E5z5E2AAnVZN3377GPm
 eEnmGRYwbwrbdsEhtmH_bo0zCUqKSgsq1iRo5bL7bOS1ZL6RPUtWSk8RHbc7NXui8ViX6wQNEEcZ
 cLpz9Uh4ser2ru8IUv17HbO8lc4j3ZK7h15jg36sjGnivMStvRoqFhiA9kiDxdDRiRoOM.DtRNQb
 9wu0FPliHbbJwQhkoG05S7BRyVUC6oOHtXwH6JziXvH7Sntj0M8TNbGDUPEeUMtCrZT_2yxgMmWk
 2RlIgUtxWx.obzUeR_WShr9tfmWbd217HcR4HZz09.8zNUzk0q5xW1CmKKt7odJHqDrjpqyY0DE8
 EzsXgMElTke8VMcflhR_1yXWgMILm.0pxeMN3zxZSDgcvajfUfKdwQ6tbzZ8ZbJiDfypxf6smtY_
 4IqUJsa2eOEM1B4v4Fbyig6RBNaqgas2_KTik0Hmy2tVzjn2ATSqNL.e971IswxOqCOLcrvL0h9W
 W2PmyPm365JQkPqapHfCu_BKtmvP9Xavx3BcYLUphQ.qbEw0R0vd4XkNWnzXQ8SBRtKxE7tauRfO
 54BUzgh3cXDe9ziXzfaHBJ5HH9a6KHlax6RZ6PmpFrkBrb.EWCY7cuDqIqsuhoXBd72IFMS53acC
 onZJx_bgUJ9c87.cp0ae_Ni7zxAt_6_c5ScmfVbD9f866SJTxdeElxf4m28xRG9_uzoyi9sIWvWU
 hsmglMmNcetDFQhdjd7jG.jA8fYIIagCDOV9dOMPG5xHF79oFs1ya4w.0sDdsjNf1cVx.WTMPC8U
 r1s0R_XwrlG7SlwUhovWe.MLLf1AIBWDi_h.ZWsNMICkem.M1rrYSNsKW8nckOPuMskUOvRYVvqI
 xNmF1geHrkuxB7CO.xAjgprSHnz42hgDFSGxmv0OMxkhyIXPCoV2gp435.eEq9E2SyqHIoVRH7Z7
 k51xNKVDzR9tOYvP7kA_laYl9QeaXzgU12njR6FOBgZS0yFzNIDfCfCZWxGbygQcIn85rZTeWp41
 PpJxW_r6KgXgX.aUSd8EvQQAQyL4Y.umlSVv9wbERq5QmYaoGT5WnkUBEacFSN808rQaRHOryR7E
 V0Dt1p1OBMHjuwz3h7_jAs2ZO7wwwMQCgoVGCMUjfKWizbTlR4XWlZZiHunnk8NR9eVFQ32DEGNy
 GxKMJFLzOiUh_ceOBeUm0n_NI0f_1OruKCrOkgD_ckkZezjTWazBDEr_z5BDlV5HzvHMgzrrV_Uu
 X1S_2vlLSTz720oBkcslDIrryE4y8uzZQeMaPn8O0UXHrGfoByg4Js5vYuBnRSalHegtHhvim.kL
 _dvDX94UWnYhegKcA8dZQauM.oWFf66.LWMgEXn4TLFENSR17z6kz8x0JdV96GgTm4_wmjBEI8zv
 1p2df_OgoKfm0mA_eAUtFCHbWrhV3yXJcspnEniQs.NKub3_I.1.RwhVbnuyaa_tpcF2Zxeb9C_6
 IEhXKqixA5ncXAO28likFPLM712AcltAm1c4.iC.FRpLTkx26VanahxQlHqnzy8jBLwvr1jH0EFP
 RjeMu.Wcff.LT.U1Bkeb8rWi1t_NZCqytuknSMK5hoLZSsuF0Wg9Q0b1kUvoa8A5luvJyiaTbbMs
 BYaV5ZTnk2lEEzRaIZJdoAcRoHwdY_g1LIYY4g8NRRovGaoMffVhT2S9ZS_X5.9d1KsKk1rmPaVZ
 ZZ_38MvUUfzbVyxZI.LOS8X8qGeM.daq4f8t.Drk4bSccNPwk.hXnIucd4NqezLAIB1pvcCoSYgo
 8Ec_0s6A9PbGMC1WkWEmOu7.NRtvS66jbZrxNai9XdM1qJqw4AAJIHZNsyhfhF719ljFUVPcfM_y
 o.xILmJHvNAZT65egRW61Ae6rF2nYjlqcTPHSbMYzsWyAoGDgWpuhkxQXwMgBLt1kGy6eMaNtkvS
 Z9tuDTNCBNxLbv.efZtkuxzLhNWKF23ARSw--
X-Sonic-MF: <abhishek_sts8@yahoo.com>
X-Sonic-ID: 6cf498d8-3ca1-4e87-acd3-718318dc6144
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Sun, 22 Mar 2026 19:03:27 +0000
Received: by hermes--production-sg3-6959968fbd-n4v77 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 78a103301ef87a298a8f046ee42232f7;
          Sun, 22 Mar 2026 19:03:25 +0000 (UTC)
From: Abhishek Kumar <abhishek_sts8@yahoo.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com,
	Abhishek Kumar <abhishek_sts8@yahoo.com>
Subject: [PATCH] mm: fix data race in __filemap_remove_folio / folio_mapping
Date: Mon, 23 Mar 2026 00:33:19 +0530
Message-ID: <20260322190319.85301-1-abhishek_sts8@yahoo.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260322190319.85301-1-abhishek_sts8.ref@yahoo.com>
X-Rspamd-Queue-Id: 83D41C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: bhhuz1rkhwm6umwsy88mcbhxcjruairx
X-Rspam-User: 
X-HE-Tag: 1774206208-346262
X-HE-Meta: U2FsdGVkX196D2mBF8Scb2a9LLAcNdUhWshw+AZOY3sU5cV6Zo0UO2xQiZ5fH5GVtDAhgROcpk4Ih5ybNPUtY/oQGG6rfeSC1IbeY5Hbs6SfyO8xo4SgHpMoxRwOF9G38pZVL9d/HNzs4zqldWGaNJrSFpDVylcfd9Teuk8auNpoGd75+sFzIFv+XlTruhUQsovlsC3h6JICVWsJDxXJkPLlpUcBuKsgOQy3kAao4ykfIn3mOfM78FtAw+wXh11EECDoJi+BgLjUv8k7RR+8eIY3LX9QqpQcAKtUwaCOwSXQpoDI4va+lmILgdVbmMaKlJImpGLd4MzZTI1HM5/mC4Y3cGjkXVvQ2KqCk4E8vk3Ud7tBEQcSRddNwUnJz/jWXivdFyPf1kmy+XBbdyceyY9xbitMc2o9dO+j71remO8aUnl4HrGzbd358MbkX3TbY13UDtv+aKOe2RxzE09h6rU/cawi8c9g5DY75jSK5oxL3LnAnKCD+w5NXVrwJxJRzS5pqCnMOF9n/2PKkUJj6zOcRrWhyxJlOOhKkDm03CqdIp9mgInW2xLBV0RHTS0jmOXWzNB0lVMY90V8QLjQEw0/vkl2wqjL2yzPCgkIJ19P0kHXwsAq/3Qpx0aPCLci5gt1Kt6rmygAWHEzz9K9p9rY+JSyzq867ZdNfpDCsYByYYG1oWvvIeKBs6bKyrZK0Jplx/jVrshQ6wnHOQ/OAUZoDM48Skcf6AwOeSkh9p17qGiA//WG+sklJDAmL8BwrL7NyaCgq0MdY4G+idhNIXd6S/zSNJkG2yZSHr0K8A8kxKX210ziYuD46YL1Ei6PpH9JZl4GUfoOTL0EZ2VYclRDdvZYiLA5Y+disw3ATmksdG8W1zACqMSZQd6TGOePZMiL+/VxFA/721GWqEggT+8j41W1oyGDmYvNsQkk0K1Pk2iD2oWkSPhjsXay3pqICQLaMJdRqAO0+T+UEE9
 98D69xn8
 6WKa95tX6rWkpSLWUvBYYn47sy1S1jCOKXDaLnKab8F6cgeuGc1kuv6obqKDDyUnH1EzxRfVBqEDwJh24gqSNfGI72LY6OdpzY04iAmZ3TXYzbPhoTXX30MFt9JojcdBINJBURsFSKi+PmOmArg5WXfbcIhaNodu+hpYZiLtixbKil7MjB5KlxXUqFPI2Kfwwlzl06RamSpKX3Y9mcqCnw0WS0l6yNccNPQWNJaPgh17o7u4VcymdtUw/oSUy061wSHwkckyUoD4jPrrt9gDfioFPaq6xo5fAek2htwSVJpuS8lJKEfyMJk/zZ8S6RHNKqETo+DWq1w3jX2yfYGNaOtzX6l/13/9nQwEqBf7suxRokMbR/Cziao4ElavN9Y7a4duXONdBuQeAg5Bec6pr7y1kVNiYSt7nJRMfYJWAgvUOeHOdK41K8X1TnP1WkxScQXSBjoyuxqxfRSV+G/cWZiFACGGohT9hPkBCdkQ8blKWaosUpmNbpgmHMylBs1BJgbEIABgi0YK5KuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN reports a data race between page_cache_delete() and
folio_mapping():

  page_cache_delete() performs a plain store to folio->mapping:
    folio->mapping = NULL;

  folio_mapping() performs a plain load from folio->mapping:
    mapping = folio->mapping;

page_cache_delete() is called from the truncation path under the i_pages
xarray lock, while folio_mapping() is called from the reclaim path
(evict_folios -> folio_evictable -> folio_mapping) under only
rcu_read_lock() without the xarray lock.

The race is benign since the reclaim path tolerates stale values --
reading a stale non-NULL mapping simply results in a suboptimal eviction
decision.  However, the plain accesses risk store/load tearing and allow
the compiler to perform harmful optimizations (merging, elision, or
fission of the accesses).

Fix this by using WRITE_ONCE() in page_cache_delete() and READ_ONCE()
in folio_mapping() to prevent compiler misbehavior and silence the KCSAN
report.

Fixes: 2f52578f9c64 ("mm/util: Add folio_mapping() and folio_file_mapping()")
Reported-by: syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
Signed-off-by: Abhishek Kumar <abhishek_sts8@yahoo.com>
---
 mm/filemap.c | 2 +-
 mm/util.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b684..bba669bd114f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -142,7 +142,7 @@ static void page_cache_delete(struct address_space *mapping,
 	xas_store(&xas, shadow);
 	xas_init_marks(&xas);
 
-	folio->mapping = NULL;
+	WRITE_ONCE(folio->mapping, NULL);
 	/* Leave folio->index set: truncation lookup relies upon it */
 	mapping->nrpages -= nr;
 }
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..5ecb19ddf026 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -700,7 +700,7 @@ struct address_space *folio_mapping(const struct folio *folio)
 	if (unlikely(folio_test_swapcache(folio)))
 		return swap_address_space(folio->swap);
 
-	mapping = folio->mapping;
+	mapping = READ_ONCE(folio->mapping);
 	if ((unsigned long)mapping & FOLIO_MAPPING_FLAGS)
 		return NULL;
 
-- 
2.43.0


