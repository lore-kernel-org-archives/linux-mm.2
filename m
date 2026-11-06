Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F49E606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v719N1eg
Received: by kanga.kvack.org (Postfix)
	id 6DD926B05B1; Fri,  6 Nov 2026 11:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D786B05B2; Fri,  6 Nov 2026 11:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CD06B05B3; Fri,  6 Nov 2026 11:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 346E46B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:04:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95543120116
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:41 +0000 (UTC)
X-FDA: 85405167162.20.CDB0008
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C3F9340002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:04:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v719N1eg;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793981079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrPqOBbmQTC7cKWIEZPDDl/+MmJimjcBhJLEmrI30vM=;
	b=sco9mgqHEQqLVI7l8P+RTF2ZrBiXLJyLAxCfVaP5+pjVTbeovqfQUuWct8R3qmoy8ldCld
	0oD30zcGZQAuYh475wlmA+NOsCXjXSO+dboX29wGtneKRBIefAw11SfrT4DaZ97OJN5d8w
	+kaTgBp2ZWys+c4MN0j+wixXyn0WeCs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793981079;
	b=0RHzerX1hDNthbP7saDuxgTb7BnXXqC0zkPJT8+5rxK2Tsp7BZL5dkrjBpAFzoFzgp7zrz
	L8ZEkmsR4eMOq1c8kt4+G91kFXv+duGsCIAVm8m35ObEYu+TNx+uiKnkMe4Jcs85xcaR52
	bJDm60X34FK2+McN3JCg0uQpO73tXC0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v719N1eg;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b31448caccso6912547b3.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 08:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793981079; x=1794585879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrPqOBbmQTC7cKWIEZPDDl/+MmJimjcBhJLEmrI30vM=;
        b=v719N1egUsqRli+e4vFK0D8TipC7YYuZ5q5b0aE4J8L3NJqsgQkk8zpZRMTGpAXq4i
         O+s8AYfs2ZgPdL7Yghu0jWn9FyllLiCiAZeCvjfBn4+A8fCd5bJgNh4pcfMprqHkPMb3
         vdKQ/eWIBgoW+0mwtCbSCiC/Anx/cNPg8BUsEJysx1+oQ6+bDbAG1UTKhX2TH51ERYp8
         yCnxIH39u8rQssEgu+Ev1+UVqYwUce5tk1RMgEHg79kt5COL8hahNb35J82l+bvXDjqc
         1MAD/IH0CqAUeNVBNFnnQQER4FMDZ7IhW9DnAIWquVu6YAupZUYyQvy9UCSNAYe2ydb2
         VrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793981079; x=1794585879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jrPqOBbmQTC7cKWIEZPDDl/+MmJimjcBhJLEmrI30vM=;
        b=hD4gu/63hGjcW2GFNT+nyCfeZA8gPw4BL6hDXJSv19tdULtY3899YoynBphiIMe/qd
         jCwT4qJ58TTHElAVcS+oyVKVS9Ccscy63mxsQZKRGqVcb4dVTGF6BLCvAk1VDo0Tpz7v
         u8P8bYczaCf/eRYt8sDwXxKc0RNs7jHTufRc4zxXtxTV4DPaV97WLIDE7FWG2aun/ISx
         H4WdnmGdJ4/hLxXrKF7u9dobDZHKhgSc/kleJ8ImvtY4k1n5UM7mkSFK0POY/aM2bZBh
         NdO6R3+F7lsr+q3Mfx+JdUvkvUOFMillvmnVN2nXnQ9LJUp5lJe5DVEN/IOdSg3XAtjs
         38bg==
X-Gm-Message-State: APuU4Z9BmkhKuO5R3Q+wY7YVA2GXKxuclB66iH2G03ZHDEM6LnDxGi9G
	c2McXCWSy9jZhsLVsrUIRqjqpAqIB96axiYhGZ500bGGEIYVMxtnLvtL4sNcVMDB
X-Gm-Gg: AYBFou3SB+VbpJDAuyhhki64qJ37UJFYaYV/FAixObucdj5xJNuqyQTDxZAuwsiXZbX
	t97MNWl3Oqjd/J8RJKcmdLwo35KJWrJlNDLG5sZW5SLuVF8iBpv3DjAh2yy9uax8P8++i0+8QCK
	nh3W41qSjInQ0FFEd0j6pyUQGrHDcgQKk/hBGteTaiZiZ+uXomvm9o9XMWg03ADb5LqRuyOwt2y
	WkMIfLuiRLwtLhndJF0s2bEZj0gfknTVVmh3TaDf95jC4lizTMeeUJ2KiXAYHdTJh7WjUjQrkLf
	5pVxuDknE3aoLVwXrBJO/Wq0rVC/uJemJB7lVeyAT0IBkCYi+Hut9v00PpfKq3/Zy/3evdMUgTg
	t00Eim65NEOmVc5FakxwVZ/7FCARdrrG9EJ3og3Z54w7vrYClsZsV00WqHAfpH3KVAc1vE/2X0J
	APiN7fZdeRpumQhQZRcPTjlASL3jboycytZirgmUCeXTM1iaMOY1ABJ3RBdvKAInm6bNOMyHC88
	CxtHaKTUQaipSLDWLOKYsRE3WKbsmJDx0sjAIvp8K0L6MmrocPxSUxakLwPKhf4rzgtZ23o3L58
	J/pVSRvvYqpp77Ukp+eyLHw8LtSEscjZaMwYWyb4js9KgqeeLyRGvPON4VHCjRYSIQxWzMe/VN/
	gXM4I3wT4ZKPIEM+krFtslanJ5L+AA8CQ+IaNFQ==
X-Received: by 2002:a05:690c:930a:b0:8b0:ca83:c5a1 with SMTP id 00721157ae682-8b34157e11bmr14898427b3.0.1793981078714;
        Fri, 06 Nov 2026 08:04:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:22::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f7cb4eesm21953687b3.16.2026.11.06.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:04:37 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	brauner@kernel.org,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	weixugc@google.com,
	willy@infradead.org,
	youngjun.park@lge.com,
	yuanchu@google.com
Cc: stable@vger.kernel.org,
	ryncsn@gmail.com
Subject: [PATCH 1/2] mm: vmscan: allow writeout of swapcache folios without anon mappings
Date: Fri,  6 Nov 2026 08:04:31 -0800
Message-ID: <20261106160432.2552507-2-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106160432.2552507-1-nphamcs@gmail.com>
References: <20261106160432.2552507-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: x4aqcyt76ewrbsog47kpwakzs4yadghx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C3F9340002
X-Rspam-User: 
X-HE-Tag: 1793981079-415202
X-HE-Meta: U2FsdGVkX18NflSgimGQ+0Hy3dllEqH1IDG9yCeCy65hE5cKEdHjdVzJ8hzORxjfauCDtWtA86ogDC0TxZbqwcyDac94r8kWXzxON78QRS2K64nqgzvV84AmLKf2KHAaqUJQ4gy5xUlDZZyM8WZnAxHnLsm1JXA31FFNi2YF91sz99dU6frWJo01/JsorCM0L+3Cm4RdmH4t6piEj3QS7pemhAs0SsnncI+OQ1AH/fuWrXaNafzLB90DcI4l0cE9JPO526ymmflRQJFsWegOWP7EPpv46FHOKp04FfS9VrPv67ytJ7qmFrnxXOMMaeZwBYiL0tm4LR/6wCW6wPglVipSX/gGIdaD4EoZnvgVt6pKjfWuzqp9CUzGhgxwHWOyKIFxSJpfGafrY317BuKK5/BauFCs+ME+E/z2DwsHX/4UnUdCABIZA6hCzvdCQ/E5SM01KmyyaQQ/QkBH9DEaohjljCN2/DioFndfkSMCVaL2URdfFn1Wh5uvMfSFi2+UreH+CC39mo5xcE6Oyx8ITPvJum9zJQs87WPdJxjIf/rVsPbkFgu/PvDTHb7my6zVWo4qbvS0K4n6Nm9ouqRrTCcKSPr043zwJCjQO/C0Rk52pnFEKz+zBn6PuayZC7c7jd62Eah2xGDuRzjESEYjeRHvY962mtltQnWvpoE3GKMKBaZlenX7LniP0kM33k//h96maiUaVx5kQ0P8r54coBEbrPYVHnf5ih7uZFJM6TujlZleU1r2YD8AOBYlcvfBJoy/nQhuCWRgAjy+AeqCFQziPWx7Dlod5i5BBsfoU85acnVmwqzkKJLtDJFfcLiKJD1c3tIcfZJI4emWieurnfIqFA1hr7AmImBcGJ7J9NsnBvR1Vx28aQKbXYxLZgYl4RlN6v81kAbmPBNMChlXECbCitJo5V5KqxjkjSOY2UIZ+ID4avCJBpBubjjxSDzqGElhskIMkJiNQRn8N5I
 okNxCXo5
 /5OzAz/DxU3bdT6ln/6q2mN1v0H1Y+dCzd5OuLFfz6XdHBYTnqyD/yKegl7wvn/2tETnMkgfBjaF03uocmBviyeR//hLUtUj6rJMC2VDWyum7oxOEkG7/HiFCZygLFBFp7oamlJMboLFyelYoFUql3Dbtxv3Zjv9HPJCWAnRmvgNZOymfoxYf/m048fBxqlQqrhv8fOsolay0JMccWOm3BGGOZpZPHcB4m8/8rwl5XElM3u1PisJJJ1jHlQDv/DVKDZYALAgXRiLeyrFdl8zCtsZDkFleSF1JKGSvcqd6dR4sNv6E0VxA2Wd8M+egcdIiqh7RFmEFQOuKFQ5ggS8nyyJGN7L2+7QQyXoKaIgQBAIyx6o7+W46/YRhm40FzHM8hxU8yEyQ+T7YFGTLEuEhR1BtEYIyAnkXUozz8FyJmjJQaqurup51NirSstaz7nkrmn2BURTFZaSUQvIpqPqtGuDShlrsj8+4D778c+BBiYyRE+RS5CA1EcmQqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unfaulted zswap readahead folios can be dirty and in swapcache without
an anonymous mapping. pageout() rejects them before swap_writeout(),
so reclaim cannot write them out while their swap entries remain
referenced.

Allow swapcache folios through the filesystem folio check. They already
have swap entries and can use the existing swap writeout path. Anonymous
folios outside swapcache have no mapping and already return PAGE_KEEP.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-181078@kernel.org/
Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7db6be53f3a9..4b014e3c07bd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -714,7 +714,8 @@ static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
 	 */
 	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
+	/* Anonymous folios outside swapcache returned PAGE_KEEP above. */
+	if (!shmem_mapping(mapping) && !folio_test_swapcache(folio))
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;

