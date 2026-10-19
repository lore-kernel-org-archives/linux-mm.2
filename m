Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9697ECCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689406B0180; Mon, 19 Oct 2026 05:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661256B0182; Mon, 19 Oct 2026 05:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577766B0183; Mon, 19 Oct 2026 05:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 238886B0180
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:08:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF75EA8209
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:55 +0000 (UTC)
X-FDA: 85338801030.30.671F376
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8160C140005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:08:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WBKo6szT;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvZO54TWJTuQkZMeWHo+KL3t3yCuPUOF5hA+fz0b8nk=;
	b=45pFCnLU0sam5xdnaa8HE4mtCUWPMgQlzvRQp+yfEtN1Xnd9DF2FTyBmJk4aqKctV4nTh5
	svZ5DMiTw/USdrLIgE+ttNhIJtpqzMLXECRGR8uLf+6+SxMBqmOCIGHTloRYFKORJ0k/15
	zHwkwnaKcndRB34iNaicz1xUYvdlMqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400934;
	b=XaVJ/iZnhYBeJyuTz+0+rvVYhdhGciYpIMkvXWAE1iuYFseLEEbeTh/UEgMrRFoZbK2/Ay
	q8a/ehl0HlE5GUeQX4hZ+nkcVnP4AMh58lpWwkiip9DDyVilIHtolQw+rRrelQ9fHycXo4
	M3lLnw3FZtgAoqXL4yBZkOO5U56kKqc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WBKo6szT;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e60f9af6e6so14436475ad.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792400932; x=1793005732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PvZO54TWJTuQkZMeWHo+KL3t3yCuPUOF5hA+fz0b8nk=;
        b=WBKo6szT56kERseCjaxkomGNzD2pqmeQKpOMqhhMFgIphaR5bUm+buwA0ytmBOoezE
         4gryeBLcp7fte+BI/yH+7KvNQ1VHQGox0jJF68w2FKCIaG9QTsECaXzJyUKhDYRe5QML
         +uEybFwpyy6x3hdEtAy1rc8WBgA7gfrHC2QtQumJ8i/+WO4Ueai+pSAgtAA9v3bVuztp
         84L2HnQWu9Q+ktrD2opFAgdsbIzDOwZHPKq0RPNaoCWzeYZceLlbMNstq7Jd3CrTtvlM
         Y9dSeIi0lJDZ/SeH4lnXUZMqIw75hUzj2gb13ShNW9bOvVaAvocVGuSJuNa2PEMvmLBs
         CWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400932; x=1793005732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PvZO54TWJTuQkZMeWHo+KL3t3yCuPUOF5hA+fz0b8nk=;
        b=wsrfELsRDR1O7vs131sfVESlNSWWu5uVi7SCiSpmM6vD5UsOcqCfzZMD2xq+MB3dSn
         oC/mqIFbN0vDoaJ8ahYeT4otoU4ElQ4UuzqaTAM6IJMgnoFHBWPgLekoJH4JExqdH98X
         /V8T0G9Wff44V0r31zUUYBa1MR41bV3l/CueTC75XTey0+lQZTbi0iBnJPMwPBxGduPZ
         SenXCmP88eAJelW9vINeMdIH/ofigZqCXhcJgeK7q52yaLOCOrhQTSQm3Rxx4Zo2WCCi
         Sgha6Z0fPwlz/2U6A2/siTpko8h5Em6nBpXaH8yCLK7LU0cQfClweMeiaCfZw4U/Tfbl
         fAZA==
X-Forwarded-Encrypted: i=1; AKwUvBxbAEqpdAZHXaFBiea62DFoKbyqGEGaVVP/EN6FF2PqhoPeww1EsTKhP38ZGaK5x38kbpDRClmyEg==@kvack.org
X-Gm-Message-State: AFq9FYIcNVtzC07tW7RcNjQQWebUG0oG6gtLUydFlHUXPe7yQ3qMKi7E
	W1dPwQSgtTFmi6EN6xtNki9Pbk1soSJT0dqEeLwVfcSeTfCOfP6m1gR+zk4XroxrB9w=
X-Gm-Gg: AYBFou0scu8cF9NqelY3ZuV5MNSFCpWWAXu+30ZhDP6+Pg2UmarjxqUz0oPM0ea7FNn
	Zt2UJIGB7SznQlg3lH9qxE5AZGUr6YoGYyqEygxyYuza+2D/marMBIZ3btiw6gtp6L4C7YoGvin
	T1rHWZg2DcZGmRDpYA82s3HLbgMZlp+hUbCP/HQa46Zbxi3CoUR4zSqf4qDWJengEZWfYpBanI0
	YN5fF1JbEkpz+AgQimOFMBHbPBF44iT7xItiEfrAT9b2Gzw3qW7wGtW8XHTwXm7Yew5MC8xmgph
	93s1d0AdA4CyZfLxqT4xKJAsWOm9+6OMxk0H88+XLbbqY4wjDAmXeoWMOQteououJOTfmNISS3g
	SM+B6Kc9kLqPZARZs4YpWsqEYQOj0rCxuoipRDuH8aDXJ7Sp3TvJF1qaWZHN6uCtJWCNm3jJxyB
	siid+6kduS4sXuxkIxhMjBb2w7QuuSpq4QhDTYTWFwJHmL9togftlgXfaErAjQnIcLC48yyxQy9
	uSKVh7WakQDsgi5KErQ
X-Received: by 2002:a17:902:e5cc:b0:2e9:4e83:1961 with SMTP id d9443c01a7336-2e9a6a0283dmr60030985ad.22.1792400932347;
        Mon, 19 Oct 2026 02:08:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm36707595ad.0.2026.10.19.02.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:08:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/4] powerpc/mm: map shared vmemmap tail pages as read-only
Date: Mon, 19 Oct 2026 17:08:28 +0800
Message-ID: <20261019090830.1917657-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ppaj9erwoa5i3amz3k6wzh5m6zcqk81q
X-Rspam-User: 
X-Rspamd-Queue-Id: 8160C140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792400933-385210
X-HE-Meta: U2FsdGVkX188F1aNc5j+MwCQJV2a+XTKGAIXlVJmgefwgp0KSS8Rj5Hoe1MNoS1dCQWjZo1Bv5pFjcZTVCezKBSOxfMS/a3SupdcCQq13ROlu/qf/fvKu+WuFGBpnef3x/kI53gIehQCjnAvW9EaiFeGBnb5VTy7mWZFhtO9B+g+65HYFxIBrRFA20I5x8edQZJ2nEPI1pqxRxAY0zBlOStGjOaJUikKiT9S3kJJCoupdkHayzg7gcJS37MiIKzJyxqGjMfhoWKuqWFe0VVPtUURHnfswivoha/fOMAlcrKV5ImfMvymN5cBL9Nnt44QlqoW43raaEary2XKtok9euUwPnHKxZlsU4mYies8co+MQfj7tpXh4lykP5EfR83T3mSfVIo8/EaI2qNdifAohbwRn2XvPD+Nnp3cG958pUYBlaKRnFSHpAE3fOjV+g1sbK/wPRSGbgeJ7vn4tz679dMQDD09sE1laMBeGIR4urI5maFijG3L3+mTFYZWKoRb3RNdTM2vyNt9B7TzyO7x5Q1BjZ+TYxzcgTGj5rkt0pcM6qYhAi4obehhmKMREVj85eQkDrf7iMFsJT1ql5Aix4fyPLIgOqGAALPEIUGIjNFqlh21o2oLkYV60ytRbcg7PU9kuB7EF+nOBvEtElJ2IcvqxuqcHGF4tg+Hwlv6YowgOYUCAXXDn35SS6Kt0U/ivMmAeEDk79K30DjOTtP5axWaTOVXbwrbMThTw3NwcfedKIPO2oX/kdP3RRaJQ5SvtR/BJZf050jpzOMrl5jWOfdzMfiEXmkJk3aTBAxZzgWryrQzrmABZkmq2zLcXHTucbgtWMTHDmiGbLphHDLrY3FjLj2dBzW6zsLfcWbZEA95rQI1EN0WuKY+W9T7vZWjcqn+BawP3HvjisDC050e/LRY41aWvM0A+yVr6Ror40/HJa96Evf5rpLHfPnOWyj05ooei9guHOYTFZMmHdk
 ohG22MDP
 6evkMDxG7eX0j+klaooRMunF6Gs1YzfxdBH+nruc0kMpJ7gwQOTrljW1wIUnGexd+1wNnYQy7jo56hlxpkJuRzH/kO3daDNwXxM3LZ6sCwS8mqlQ21KqEeCUTJMPzo5EFfj6rHIZQB73eUR/Xd+uV5S//jf/9aJk+Zz+pF5gRB7g5wo3xHKBh30KSHGMG4Ok1hAuTIZFtpO/5DSsRUNtYEMAI3JkIrX3pAE/90eVLvWFYUPYc9cPh7GiycuPRd0/bkXBq/AeoIG0sEc+GEho5gzwMSnYWofprI4zYT6Eb9XqCYyW+RRTMtMaXXCigcVggijHZTxaZbfw93d0K/tOQ1uk6ikr+GZ/THghwbANQ2VsuYVpAmaQrxQRTa6nddSSi/F9b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PowerPC radix uses an architecture-specific vmemmap population path for
shared tail mappings, so it does not inherit the read-only protection added
to the common path.

Protect these mappings as well so illegal writes fault instead of
corrupting metadata shared by multiple tail pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 44868b62b14e..ebac5f9058f6 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1059,6 +1059,9 @@ static pte_t * __meminit radix__vmemmap_pte_populate(pmd_t *pmdp, unsigned long
 
 		VM_BUG_ON(!PAGE_ALIGNED(addr));
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+		/* Map the shared tail page as read-only to catch illegal writes. */
+		if (reuse)
+			entry = pte_wrprotect(entry);
 		set_pte_at(&init_mm, addr, pte, entry);
 		asm volatile("ptesync": : :"memory");
 	}
-- 
2.54.0


