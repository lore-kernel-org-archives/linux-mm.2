Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B05606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wDEjKZZR
Received: by kanga.kvack.org (Postfix)
	id 1A37E6B05CC; Wed,  4 Nov 2026 06:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178916B05CD; Wed,  4 Nov 2026 06:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F4C6B05CE; Wed,  4 Nov 2026 06:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8D1A6B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:13:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4051DC06B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:13:10 +0000 (UTC)
X-FDA: 85397174940.09.36A4B13
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 704D04000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:13:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wDEjKZZR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZQH8qK67DPjzVzFRy8vpMz0SogpfmebsloyVM18dBc=;
	b=H7JzW13chQsAjGHRaa6lTmjMss9ijoMbGuk9ZqD3rnbLNnj5lkrD556eiPn9SxrGc9yKxG
	dmbsV34XqZCqvaoZwd5pY0ORAfZfsR3j1Lc/t/tBi8mKvUvAhzg5F1VPp0pO19yVjbbUoy
	soLt8Wrgq05+2457jqoEeD92P3qXcqQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wDEjKZZR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790788;
	b=wtlW7q/xVaakCPjTUp+3pwfmFZVgYgUzqW3yU0xhYP8RHdoNrUKL77pV1iN75Mr2kux0uL
	JLn4G9ULUNRuXubnUkFdb/wHu66kJTbnwq/ZqIW6hjhxcXML4WuZ/xJAfv0/OGxDehgA3P
	i1dA4Tjt7i/t372Xdz4vpz6A+fZsBLE=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eabf243d05so176845e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790787; x=1794395587; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dZQH8qK67DPjzVzFRy8vpMz0SogpfmebsloyVM18dBc=;
        b=wDEjKZZR0lyersLXy2FqFpRKKiOMa+kvwxX4GZdD22HnPDDYVq4XmrzG752Mx8+0zx
         J9d/OXV3HYzGY9K7Jv2zeY7n+NrWEmjHX5aZ8j773542CvcTr7vaHIgV+fXIy49UUjtJ
         dpjpmEuKTE9qc932wm9D1lw40rWNL0aOcumdQb9LhVdIc6HVgt6ZygJ/t10F24HvhgT6
         MOk4Ng9cw6Yx91VLZJYHPi+8gaeG655Vb3DNCOtYuZy99bQKroMl0Jr1Wq5JTYuwS1YS
         e9gQgNvLuFKlHXZRRUP4X+IIUPFl0q6xDQorSLPAFux2vTipaK5YXWuZxkKxrQg4O7yM
         /Mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790787; x=1794395587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dZQH8qK67DPjzVzFRy8vpMz0SogpfmebsloyVM18dBc=;
        b=ZAvdvysT85rcJYokGkFscGVrz3qmLULivoNUvggUeIg4vBV0sqk7WcBqHwVqQK+biG
         C7TNaM+T2f/sjGU9FFKplyTt45u9tfYiZM8lNKRAyg17d/yDngAwaawY2TwFV0/bcSlK
         lVCizokCcZEOvIR1nTqSuIpUslcK8zbJygdPP1xIioC4OPm/sSZGwm0nwdStuGNzO2SK
         plnLnGJbnbawFEAkzG2FZT7ofSkEECOqwfO8NSt2uQXqHO+YkHNG7m0eM0+Gqs4mlCp6
         92nafhDcqOXBQueVG1tLz+AMmJFiqZWq0eb9o/VAoJYF5Dv5oNmRCUVDeZSB3zqWGtnQ
         J4hA==
X-Forwarded-Encrypted: i=1; AKwUvBwOhtG3pFOu5C0zqhtO1pamgOxxn36HtVrqHRbaO/dqc4Qd23PpoN9cynf6l8f5B4PsfQcVfiqrxQ==@kvack.org
X-Gm-Message-State: APuU4Z8g3eOCZP6qmXaicDtA2GlqnIh2xbL8ru7+H42cTJTN/nNpl+Yf
	cfSgMssMHrsLejf/bL9dTHw8ucbueWHFkcfpG/jDrkKM6ufysLLXormo
X-Gm-Gg: AYBFou2MiqIc39bF41vDSnfsAZ/zqbEhNGqwIf00sUwcwDjMBuLpD2WF6RV/CGYq4Zn
	97SF/myhANAoNdT7nbeUhKVtAvFA7Us6NWVlJRKoMMMpHd5apT+HGCF91xoGKo1OTFF2p+ZJeLr
	BISvFOXXJuElF6MgN3hE4xO31bwhaerwGoiT67OIsM9+VSMaiSuMUa+05Pni5yWmF5rFmeqUyQn
	SaPInF4Y/MqoeIOuB6ekASxWBeaFk+vkDvi62DoSOMbDb0deLO34Qsutum8UBsD9JHqBRw8TXUw
	CT3BiRyIr0m9dNWGbOj50DYGr/JZFu3bxcXAwXrovai90Q4UBJx+k2EcbqPO5+1aFNuvbsr/gck
	zDHxfdlLtyNKKNFVoNZULeD4PNuc2OTI6tTe/fyuMx0wpP0ljuPnPpTtgRdWUosY1v+zWt3ScA/
	Jp32pqtU1VFzeo+WHQJln+zqeOaywik0iBrJaTWj1HP6tDFXSNtBuxB3ciI3e9C27VR5kmEHbCa
	eD9CfiugjQLkeHV+AotConX4cGvY2b4Heo7/my4lodWtV3vEpEt2twHBm2Rud3dbYTGXj7BzfRf
	6YBZQ/FEvvRcHS1E7c4KQYfSQGZLoLHd8scZQ2vnIr9RNmRk/VnHy1LCw1le5dAQBF9lXaMgwxP
	k+9FF8Qg=
X-Received: by 2002:a05:6122:218b:b0:5ea:a0f0:192f with SMTP id 71dfb90a1353d-5ec6881c31bmr6232105e0c.10.1793790787438;
        Wed, 04 Nov 2026 03:13:07 -0800 (PST)
Received: from fedora ([187.120.134.44])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca89b6568sm1403664e0c.1.2026.11.04.03.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:13:06 -0800 (PST)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
Date: Wed,  4 Nov 2026 08:12:54 -0300
Message-ID: <20261104111254.320059-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
References: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 704D04000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: eh7thh4ry5pu7etgejfqknchukogrp16
X-HE-Tag: 1793790788-863815
X-HE-Meta: U2FsdGVkX18VFadBzERhxKwDXr5AfSEF25aco83nOR+51OzeJl3eLuCXAYLZnPTofBkTGBM/omexol9vGp4/o8O/m9WclW4qlAzDw5Nn5DGgtmGW9+hH4BwWsmzcU0mR801de+9b21+2FCcVgxPj2ugynYsem8G1JkTyKWNYRw6+alJ6WbfT28uQZd6R4gAF20JIXNbDemFcUgzfxfEqxPCQ0F7kFM2PU8Cw/Asmf79+6GJdHtCeK0eWvQ7c4ZW+n3YrYC/irgWL1KO55iFhWIJ3KVYf/LVAf7q8A2YB9Sn7OGetFRhzBeAp4bE4dKQMKIs0f2XW/sspBkUFH+Oq2wAVmfchLwURjKV4BS2/f+ujvofflK//tGBAPR45WwsJG/sqkVb5vAW4p8KSxQ8wZ0e41khWMmCrCao/hmUD3qG6kL9cT+0eguCRwW+op+IdhFDkYHg8g/joD3+9SXFFlBLat+9G9ZyLsYDEcuwUWdrKDMCBL+P1XrEQnOni5Mhb8QbmhuMqjw48+xvitu58rx/4oCwj32ZsDJvDjIb0O8f+6FZULqmzt2GlTb+w3r+wNnEuFwpXOQS1K/5aLa4XD8fwluHkjUH/09fS6RtrqowCXuEG4dmIcevFaHiSF+fNzcP214byIb5x6mNn9CcZwo2coo/crhLZ0yLDoKdRFyaOeXBIqRn7o2CviMw4zL67/KuCPQGZbqkhpu29E177rVw9Tf0HxKYqH9Cg3BS+WUwvwR/J88g4irToA3r2zbQ1pW1OJJpH9ruIWcWlEmWLzMGs4UDKKjHWtruapEeKc2IQLQGzfHqUcLdZWdy2TYT5ZwnCHv5JfOVC3Dq768cTBzOGEjV0HCW7wl86T51wDN3ESJUz3I7/oaNzf9UedvpAGbFZciNG6DTYLFVixiCo6VpZCeB8N4XAu1r5QFeu69OYmhe6acxSHU8Qh4NxlLuZbpJ3L+2MkYMie5X/gF/
 KCnYAHQt
 Zi0tia3duuZRrby825exrkR2mf1YqUAf/5oOyRemaIYqqX1g8cnffsQLyAxCwfMn4S5gSZaA1Gr/XfP6Z4wPGTkw6SZmlLnTmwiLGCj2PqOg48eZcMA05+gnvL4l2WaGbVo4MbQJEmBC5FurZreju/BG5KAuJSphsKeJyJO4y3SLsQWCUjxxchEw3RRXz0RBedY+pZwhm4+wP/TQ7u7VdUf9MiyO4cybxlpc3McUw1nw5ojblKlEHqhdG9gouSbt0hUnh8bWMMGKvTig3X/rgvVR9T38PLGhZcZeYmkeE7t0cUJgcai3P/RQDPeuk3g1UcN3VQhQybL03qctzdNmqiuYXPLp+JtxK7fDbTLK4myHDH9Cb5kXP+UXF/C5tVwLEuzq2hD6Wxme/1xq7GJzhqcp8kJMmFM1lwYFcBxt1DRWs0SXRBPRLkTz9ENcsVuq0jnIjLdYI8k2BzLci3agfGX3oSoilDT4HOdFVhvPM45cl8NI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David, I haved immersed inside this problem on last days, and how sashiko-bot
very well apointed, I'm haved doing a wrong duplicated clear on pmd's. I not
notice that the pmd_establish() already called the page_table_check_pmd_set()
wich in turn call __page_table_check_pmd_clear(), my bad.

At first time, I thinked the problem is a duplicated
page_table_check_pmd_set(), but with a LLM helpful I ruled out this hypothesis,
because I not found any obvious call to page_table_check_pmd_set() before
remove_migration_pte(). At second time, I suspicious that maybe we are haved a
race condition, that make no sense...

After a lot of debug and tests, I found a thing.. And I attempt to test this.
If you see inside arch/riscv/include/asm/pgtable.h, the pmd_mkinvalid() do:
```
static inline pmd_t pmd_mkinvalid(pmd_t pmd)
{
	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
}
```

but , the pmd_user_accessible_page() check `pmd_leaf(pmd) && pmd_user(pmd);`
and pmd_leaf():
```
static inline bool pmd_leaf(pmd_t pmd)
{
	return pmd_present(pmd) && (pmd_val(pmd) & _PAGE_LEAF);
}
```

and the pmd_present():
```
#ifdef CONFIG_TRANSPARENT_HUGEPAGE
static inline int pmd_present(pmd_t pmd)
{
	/*
	 * Checking for _PAGE_LEAF is needed too because:
	 * When splitting a THP, split_huge_page() will temporarily clear
	 * the present bit, in this situation, pmd_present() and
	 * pmd_trans_huge() still needs to return true.
	 */
	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE | _PAGE_LEAF));
}
#else
static inline int pmd_present(pmd_t pmd)
{
	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
}
#endif
```

And the TRANSPARENT HUGE PAGE , is exactly a page that I was allocated with
mmap() (see my previous emails with my repro.c).

So, I change the pmd_mkinvalid() adding PAGE_LEAF flag:
```
static inline pmd_t pmd_mkinvalid(pmd_t pmd)
{
	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE|_PAGE_LEAF));
}
```

And this work for my repro.c.
The problem here is what the documentation of pmd_present() say:
```
	/*
	 * Checking for _PAGE_LEAF is needed too because:
	 * When splitting a THP, split_huge_page() will temporarily clear
	 * the present bit, in this situation, pmd_present() and
	 * pmd_trans_huge() still needs to return true.
	 */
```

So the documentation say that if a THP is splitting, this should return true
event though PAGE_PRESENT and PAGE_PROT_NONE is cleared.
If you think about this, maybe make sense.

And after some searchs I saw that was already fixed by Yunhui Cui
<cuiyunhui@bytedance.com>
https://lore.kernel.org/all/20260523042052.35476-1-cuiyunhui@bytedance.com/

Thanks, Guilherme

