Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96080606A68F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iBp8GcxU
Received: by kanga.kvack.org (Postfix)
	id A98BE6B05C8; Mon, 23 Nov 2026 09:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F4F6B05C9; Mon, 23 Nov 2026 09:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACC76B05CA; Mon, 23 Nov 2026 09:18:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79A1B6B05C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:18:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1127CC08E8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:36 +0000 (UTC)
X-FDA: 85466589432.04.7BC5F77
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 42F7714000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iBp8GcxU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443514;
	b=1YkpQIrVmbR3PnjPqTWVmH9npJv4gaYjvU450XjsCbDk6yotBpd6x0968IHKYxJqBrh8IT
	cUw1aYnVQgqRx+ubgXG00sODnR0RFnZSuVepVmkVVNF9m0V9whP6lAHkizHssgGJbh3HQo
	M3SUZi6R/APbrI/KnZK7DcDkWK+2Yhg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phsdk8t17LQ5zdqcOPOzFghmL6S8vOZKS0iyfCAYlN8=;
	b=iSK5PI5uB+CL4MxE6gXAriWMHQxX25F9RIe5OqX59TY89kCsTon8O/5zH3nb6YnXzH+Za2
	bCZI9qtaDax0qKfJ5qOkjeoorUHNYyDM02ex8myEf83YiGI6L1NDOs82lvUyX1Qq6AESZt
	sKDdSJ5aAMwc0vA+dD5V7LAwV7oJir4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iBp8GcxU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15dd124bbe7so2089234c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443513; x=1796048313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=phsdk8t17LQ5zdqcOPOzFghmL6S8vOZKS0iyfCAYlN8=;
        b=iBp8GcxUVdXrl76Y+T8/Byel/4pwQIQydRlgRmjVk/QWKcv6HxCe0okAksRiYhhjXK
         dCdFg14NLPxcdTwuFqzfx/N51KODqgoSOCfqucETu18KcnD2OfukmEQmtG3ND/nCn3zZ
         84YUyqBZXjnbGIsVUinUJ86HZNeBCZ7aDmRg+Oc0SLbm1RM47hV5E69lJpLc9hGjXH8f
         3JdHsA1fv3LhirI3eT+cdwn8cNcrpp42METTFQbUyddnxud8utYQoe3NBf0dnbTEiowK
         6lC4dSy2Vl8AUoAxryumbROFEtt+7/XqfELv4nK3WE+UBK3ngSqzKuv0uW4rvIEIqTjF
         hb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443513; x=1796048313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=phsdk8t17LQ5zdqcOPOzFghmL6S8vOZKS0iyfCAYlN8=;
        b=rLgbRIhboG2Pg5ekzirx9Evn+EbuEMNCQ4X0AbDQxHTr9hMGx926zXVwoQBlapTJkT
         /C6kQxOrlfK7yvFsX1AV6gQ4Y98+1VdIQC1UZRoNlhTPxRXiyDJtan1zbHmR6AZdN6iL
         X5jWsh7K4WkH5iJgy4OBoWQTP6ceNctuWJMr6c5bjAozjOLjW8ZQk2GN0WOd2z4YQk9F
         dMuogF4R+Vdru3lGI8XFUasMNOcuUSiXpH69QwaSecW/M3JkCxUs5N3qnVm82yCR0ymL
         bTGgO3aPuICKtrI4qs/0mnu6YTI6nXiRKPYGA+/83tBPgAxbZvFltRmddbfUwKQKetIw
         S7rg==
X-Gm-Message-State: APuU4Z9AnoBGxFuY4Bm+JOqoRC81gEfASfXyYYrcW7sc/JuMecl9pRnD
	6NitTlN4385QBiHYpbVXDdMxMj86pV9H/sms7q7mRxiWWoWqII3lRa01/pnghvDg
X-Gm-Gg: AZFdTZcL45hfiBCLb6ddzeA5nAVrMvIpPrpk1RCxs2P5iOPZDYJ4A7Bo8/rp2E9q/8x
	wJn6V0U9tdMkfXqiz/Ho7peQ9xLCO/EHssuHFCj8Rl0FeFaCTHhRXdnJFmyYU+bvb/23WXD6tTB
	JE6c8IWQrb8K/wr3V7CQbTCaktjQN/ujz6S13qED7cglCNnIh1kOOvbwOP4J05onAhaiyFIe6KB
	p6osNSE1ox5VxGHB5Mo9qKDo/00dIA8lG9RPNBv1x9e0eZtzqahKr1VINfGbSobnYQ9FaSV+20d
	gY0mVKpCCsYDiO64Wxslx2sg5i2g7zi7kfHZNIYkOGrE41Bn3V5AxEthDMIZS3tk8VIwq3Vc1NJ
	QsGqjyh/FFE6Nc+t7vlDYdVfqqOUhN/eFuitTvVA9Jj8t7rq5AfP/EBC/D+G/r5lNFLqJbsxEau
	jaLN7Fq3ZlCNMrGbevivGuOBcX46byDQ9EDrDCcLDcuIHy9nTv6nIA8bT5YFQj77EP7iF40B6El
	hDfOS3VQun84H2LQohIJIwEjmtSfGNsZ5Slv400+PIXxbxYzMUwNzjK/e+lpJ87aJtCWaxBLlOS
	4kivo9z3wRBFCfTl0DtmT6Z+bHAtaHNp9d1mLUoof2M+DZJ+Lb+VMHXA3S/Tq231XOPP
X-Received: by 2002:a05:701b:450f:10b0:1a7:78a3:bda8 with SMTP id a92af1059eb24-1b56f87ae87mr4467587c88.27.1795443512936;
        Mon, 23 Nov 2026 06:18:32 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e2bd1sm27824408c88.3.2026.11.23.06.18.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:18:32 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 10/19] mm/swap: mask the off-list bit when checking whether swap is full
Date: Mon, 23 Nov 2026 22:18:17 +0800
Message-ID: <0d61898075921b05c626accfa34a60e16472b556.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42F7714000D
X-Rspam-User:
X-Stat-Signature: igxk8z1xu45zwwswy6cgzeqewxf945rd
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795443514-640936
X-HE-Meta: U2FsdGVkX1+YK5eMfLKYnZm8acyBQXGE4tRqm8xqQ7IzUkMoGKIRGhDfhbIr6LsWBNsJRZXqXpWDe9v8Eo4aZbjZ8vX4fTrvd204WTiU4fFtZ/3K9D6/q+eaHIZjp4MeK8uR/R3ahAd2/ifbNJw4hyIZWRTJxKoLBdHpHD6wJIUBGNv8L/aGOJdeWwzYvYgtNymGdOeUAO7wa5Qt5pTCYR9XOk1h3pzEQiiywusMqfRi6y85eZK+gLTC8C0dIpm8h8moeJRpMXHr/z1u03je/ngWfIt+11ZfNoKWbeWDQxFkJpQoJbA2Qh5vLFLOaj1NhORtIRpi9U+B6Q5oX+4V2qIwSpzdBprLYx0LyDfr+raj71Q0qCHB2WbtwkPRiThpVaM1uolAO81hiE7Jf/Kra/gDJzGwcqrtzaBpKM3uzXU3BEO2o5szkz3bL7hLpFgMp8FwRikq3f4d20R9SegZTdw0mbAfMMpdmvLb9BvmJUyjOI7ZEZv55SFK6noIDDCfsrZLrG3MONn7ZfNlfPn1gjVikI62+F1PqEKGwwsgWJGhtF9Mqyqyoh7wOjpJ5nHqeBvtvc9yLch786t9kIjbDSWN7/ad8vuikBoZzFyAl63eQj516vpLHaDsjJr6rWyWs9J0AFlwUmLH8j1W/667lPG8iCnSQBcRb9yZ+EF/ZIsxii+Aod9A+4mzuxzBLfXdNl2Qo+KQRxM2aUnHT6sh9s6seNSk6JYQUI9GIaalXyZ6geazG4FcDs+A3NsLP7obHP8f5bKfExVqhAtBbh6QLppvx4SdyXRXyj1iDg6NxDGi2a8S5dk9q934h7C7V3afIFJl0rB4HLHjPloDleqH3KC3b6y+q9a54tflkcvOGDtMRLVCYn2TBEPoPhjKyFrtvp0kUJJRa6UZLjkzM4p6nYcfMknv4C3bTfj5Mmmdnr40nH1EAEY3BBd8uGy79NEZ5yRjaECD8SXyZdctNLc
 Lt4mL9PT
 89aopw7sqC+zBZRxHwq76uqmv5SrKaLL+49F8TyiuqNszN+LzOUea4zQ5X7AbkGmQ6LPPym3MiS7KcOR8UtOZ4uTVR00ceVVNxmgHSg4sjfD4P3Nf79x7eIxtu1qSUa1CmV0aIp0rDuZPcc9LSJ8eHK+3p3jl0+87N/SLhV3X/mvNpISIG3mGxUrdmGsFYeSSDoykmWkVQuMXQOfwgDfe6sksdxm862I62d70u9LySQDx5t5FowKdobfvvHwnGqE4U4k0CqrEN14e95BjDbLJyYrS/J9ODEWsyyEWPa4UECqqD+F2pqDKLYmMU8WK1CJqrd2W/sAFG8hVZSudUrzrkqhTTZHaexSTnhmWwgPdMPYncgVUb4dPS2PLNA5irx0MoPm8tRnlDzxPRUGQfqXO18jmblPOvFM6TjBnf1YpwvvLYuM3TklCKCIJbWKGr33bd08mEOrIz4N+HPa+89gb65ZF1F2+fIiOQBiZaQ97+zSw2Uys5yFKoB57CSm8bTdTxNPMzyG4TY1lvRdLcRDTFhIrj3vVl5/DXAJQ0NSoaY482moMSzuk44KqFDWpktkyrnooOuo3HoPx+Nun9cx5FlSk/hftE+5qyO4INggKgF3qmgCPNdnvPwnRO9HqCbovGGe6rbMGQa4j8aMwQ2OD1UkwHIa8Q0zsSHimqL2LpmYoEp3z0L2QxyC/2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

add_to_avail_list() clears SWAP_USAGE_OFFLIST_BIT with an atomic
fetch-and. The returned value is the old count, including the bit.
If a freed slot has already been allocated again, comparing that
value directly with si->pages misses a full device.

Mask the state bit for the comparison. Keep the cmpxchg on the live
counter so that a concurrent free can still make the device
available. This also applies to the existing plist allocator.

Fixes: b228386cf237 ("mm, swap: clean up plist removal and adding")
Link: https://lore.kernel.org/all/f53b388e1bcf6840457fe5041e989a3c0d0cc4df@linux.dev/
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70913402a265..1ef5f1ead656 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1347,7 +1347,7 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	 * that updater happen to be here, just skip adding.
 	 */
 	pages = si->pages;
-	if (val == pages) {
+	if ((val & SWAP_USAGE_COUNTER_MASK) == pages) {
 		/* Just like the cmpxchg in del_from_avail_list */
 		if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					    pages | SWAP_USAGE_OFFLIST_BIT))

