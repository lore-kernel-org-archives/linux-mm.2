Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E2D606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mAgoIiRR
Received: by kanga.kvack.org (Postfix)
	id 0F7A96B05B0; Sat, 21 Nov 2026 09:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081FB6B05B1; Sat, 21 Nov 2026 09:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8EE66B05B2; Sat, 21 Nov 2026 09:54:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD3CE6B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 09:54:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED9FF14051A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:54:00 +0000 (UTC)
X-FDA: 85459421040.29.4765C40
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2DB22140006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:53:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mAgoIiRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795272839;
	b=QIzax7TohYROZilyoD3Cx28u/9QdjkzcYE16i1EayIeM69E3HNT/tb7zYkEzh87j4dCnTT
	h4k7g7DSgZ8SbA0b95oH7ajG7YB5lKoN/YYncgODTA+6mCciURDXyAM9x0YgrLHbbEZ+Xo
	zCFZP/Yzixokqy1j13NSA4Rb0z9Eo0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795272839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xQen7jffo9TOqmP57pSPAWaS55BmCTfx9maqH6h4dU=;
	b=5zP0rpzJqsfXvt5kfxvm2u8rXMpiDXpYnkK6fxK2qRnSP4qx1okpzwDlkUt52XsNKc4hci
	GRI06AzFMvaFOuQ6lmj1Sy70UA9xbA68MKzU+JcwAUEOw2KqKtPJQmH5EHlJE508Jf0tx3
	nFUukqpkMpbaVjpR/oqxgbHPUZiSDbo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mAgoIiRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so13871295e9.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795272838; x=1795877638; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8xQen7jffo9TOqmP57pSPAWaS55BmCTfx9maqH6h4dU=;
        b=mAgoIiRRwmNN3zwnwZVo7WT76Hh0WimWVBQA/+jRZHyO28wfCBHanKnkSxLzZw8Gi1
         Gp6S/U6TEammKl3Fd2JZdU+2CWPbFTxp4orzGhYj5J/jWh671gJWfqYBtYG5JbMUjVy6
         vrLQnANL3Y9ekVoO1snA+T6aAJ+ODotbTmhvG/yPcdKcBUyhpK9GZEcooLWIsLX+lY+s
         DAWDix09wpVdQWHFV2CYvqfC8NYziAqX0jaJjfoXyaWu2SY2eJrpGBPgdTR7snzjaOfw
         BV8B9GR3n2GakrubglKpzYRS/pDcs8Z5jnPLvHOb1yWEFyT5/gIdit9uBg0nO7JJ83hL
         2kmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795272838; x=1795877638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8xQen7jffo9TOqmP57pSPAWaS55BmCTfx9maqH6h4dU=;
        b=ebEJV8EgeD0BdfBwkazm9cvm3Va5cDB1AnDxGz0dUKJUKsyLRJ1kmY5Z/J3UtFixMD
         pzuGktJfw9tU4Jyh7EXYA42xLCOiJ0r5qBFYQeYHksyjjAKMD1Z+a9R5aEChXBez53Zx
         pPfh9jUjr9S0Ur01lN72aYqPcN0uRwHJiKdLpcY+mCIju+W0VMbcNP7PVQgSx5hcA+6y
         JAEQKLJf0tvHqEaJlQPfT6KF0LjEt3y7Di4RqMCYX4ugFegzi6OfATRCgb3A4srwYuq1
         SaS/L6fORF0WQcCcl8XSUzybyPIEkGzX2yGd69oDcnwEHW4hoKLQGn2xbSVdA3baG6Rl
         gCFg==
X-Forwarded-Encrypted: i=1; AL+hErGn+CrkRg/rjNfWe7Y3z4a8hB2jRyMIl0UmV/dBQ2vFAxVCdncVfnZf0GeeUnEcfM/ALkuc4Du3Xw==@kvack.org
X-Gm-Message-State: APuU4Z+7Cm/rv1PSEV4bdxk+xFmPDxQfOSExHjtekx5r13VjqCwSWo2Q
	ZpibaW8+04aM6V5JOqe1/H0AmWjil/mFNhwwfOcqrPJEtfcakE3vrMHy
X-Gm-Gg: AZFdTZcX++/LVZ7EGuuiAYEG9kVsjE9dmdd1HXYU7cPpiWSYlgV9OoluIIMN/Y6rvNF
	HrgOHGSnUEeqdGRosvgrz/vtmo/rXd0wiVUIiZkGvZWXM2zUVnAsMZOILH7/tPsu6v8PHCREFsL
	GQa1X/gmrlaG9/TsS1/dYIS/uNLWFjRsqwIrcl+2PPkLq6oVnS3vnd3Ag3UjG1vgJeyuCdlByHo
	m+WWvqwVZmpjMJFLDe2cp4HfbkBPiCopukU1vaFD70KKUoQwXtj7MLPP7E1or1L9cSJvqRCqQc4
	jyXF8k69oMcYZr+0FuCv5ESZCBOlDrxunBXU5Y3vIexW1J/bOrAuC7r8ZI8lJ0rSMOJ4XAMWt4a
	0I1kL1H2JMfsvRzLC07os5jUtPz7lpRxqNib6s4Yjjs90vCECT0ePe3PLses6qhv1KLPVrUI46t
	CA8t68RsIPDDgxcb60nh1Va7/4mWa0T37GN0LQnoLtblkobNJZ2eiFhm0R77yFeNlj7v9WrappF
	xOXT9hsR29upC4ItL0h7AebtztgtnrCt67vZMGDHq4s8rYAcUJetwqEMYeCY22aUMmbpBhPjCTG
	jU0ZLClrIO5E/hKYolKllEiKGJLisadKZngX3+sb2nQLK9ipaCtKFWW0Y/CHoAC2LQTMNDb5ZGG
	uNOMUkVEjuI8N/Q5Lh5+EtjQ+j70zwSMo3Ri3i9PiBJaVpojbBtmmzQJK+MN3JZiwTfm6CtLI+7
	hr3J/OgfljwQNR5k1+oAYYoZ1ox9I7QXk0
X-Received: by 2002:a05:600c:3ba5:b0:4b0:a307:46f8 with SMTP id 5b1f17b1804b1-4bb8880f29bmr157832755e9.10.1795272837521;
        Sat, 21 Nov 2026 06:53:57 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a02-3100-aeb0-6801-ad74-bca0-dc5f-7242.310.pool.telefonica.de. [2a02:3100:aeb0:6801:ad74:bca0:dc5f:7242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90660cb4sm89121285e9.2.2026.11.21.06.53.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 21 Nov 2026 06:53:57 -0800 (PST)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Donet Tom <donettom@linux.ibm.com>,
	linux-mm@kvack.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 2/3] selftests/mm: fix false-positive KSM fork test by dropping init_global_file_handles()
Date: Sat, 21 Nov 2026 15:53:44 +0100
Message-Id: <20261121145344.73908-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <sashiko-outbox-226795@kernel.org>
References: <20261120074230.40269-1-xu.xin@linux.dev> <20261120074445.41446-1-xu.xin@linux.dev> <sashiko-outbox-226795@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DB22140006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 6i37szq5htodbmtfmrqygrk58uux8q9n
X-HE-Tag: 1795272839-924382
X-HE-Meta: U2FsdGVkX1+6kDaUBPck+2lxL8CZRG1z7yc2fiV+KBlDyAUX9HtPKV7UJyKdehuhhU1ux0rtoJqecpgAbfdMVmlKH1OyNsF3Fzol12oSSoih5yYMf2sRav7NgLVamZBfhi7Oo35UNwj3pWjWQI8qfUdGka9HW/tjJiXXnLIjPF5My1Pd0av+D7nKD4uh9emz2jgm1sRwBSWVG9D6x87hcf5PAfnAon/wjzrtur/CF4EBVTvh0fSfLpUjd60cPOziKL7jNU0OZUCYAPUIladHi4uBxNXkZMQ9jkmVR/LyIFj4DvnC/7cB3Dm8GuHe5UkJ4nFaQ9EqsgKRbNnoa9bPAA1lDEzqrcD8JBRcMXp2jyoALhVwkhbXJtxW1hKvMDIEpC+B9sXjwaqjB7xyvi6DjMekMrzG7kIfxXFfDgl6wzJnXFA6SWWPG0lOsCC8nkFkQdJwOsPaGnhb1ctAJMtp4PceiD6XA4Q8d2VzrbdydMiEYZWh9m3eeX6DiJY3DBAKlVOJ6HQ3Dz4IaQaaACkE61t5DyprVptlZGWr1etklzWLdanAjKsju2dKtFNLbT87GKXlDEYCzTXhk+FbPytQeMWFoXjckeMUYSiHF0RUTwjyXXmMal3f+b+9c636wSNjIe6ZVn1XvqXgkznaJ1nxKnLfoUkmHbzEtFBsauRI8BXPGX1+ELaqQzhhR3Bx33RNxX68P5ybhwpA9Dr4xRvwNsyrcYrXat8ZfWFPsNZbJ2tWSAhpeNLQuDuybxBG5xRtrJRmSlEFhnPbuuyGyTWZb1XmQuF3FzTAyj7RHfJfPW7oLPVwftDx1/5dd4VZkukoSKEfS5yeehid/AE8Oqwk0nqJgcxub0AgRfFWbz5825R5VfGSQwzxYCNIra5TiwqPNGlegkmQ2smfeZ2+mHF+VFiB7BIRhyioYR19QmlfPn2ucQTtfMPSgap+e2GV0VhKWi6MLoYTQp5gfnCiLYJ
 /K261ibF
 NifWcRTgjP+1jH7UAjz6b9rRFJgvB/dgRFVpl2oGgehTXkabHlKcNrTHPKcwMW3gWxMPb84JKWBtU7Sj7CbqIVQbYWwXHhsqCPq/nEUjUdoEaE9fqvIr4fi18UqH/UGQgBerhJQHXDBkyOy8Vlylo+iLWAVP0ZgzR547gI2cPZnRlM9uyaMUq02I8XGthz5Pud9D+MLzW6y8RG31TPsfxAxDlZVAZgM1UJgd7/q65vXjT+WxlTMu0Cj2zv/JfXLul1xj3mfXFzo5A+OqgG+Gx6vYxWLi0WMeljCdxrnMWpRVSeHiuq3xEF9YyVPBDQkMMW28ElyuQewd8RFjaWYucenWCqozkmKKm4vEIr+dCdtGU5VlPssWdZ4L8wU02EOqMA7498rZQzw9oIAzd9drbsN33EOnaLvSKBBIwfoiRrgfw214v6QLZesuRmqstk+bC2MOnV9Zui+hXlKw5LkoL/V+Kjb/ze+Wx2SWVSkHXidrGVWu7O5qwcLD9oQzaVekmIzJbE6iqnMD/IuGJqaYYqyogA7kfiRdAapu7lGO4wctYjGPD7XEUPREEbR363Y8nv4rHTh2GK7iA5vEkU7LjfMerfjhzNFnVWkVJuXOLirF2c5Jt4uGgK4fgaV/i+ym4kePuPK7MhoABQjL9ga+XLSyFBwTA0CoJaIWIlzNi9JCAitQPYf5+69E5K/ySK7iV6XR/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Can ksmd race with the child process across fork() and cause a false
> test failure?

Yes. 

The check in patch 3 failed once with the whole series applied, while ksmd ran
with pages_to_scan=2000 and sleep_millisecs=0. test_prctl_fork_exec() sets
these values and does not restore them on its error paths. 

With the default settings it passed 20 of 20 runs. Writing 0 to
/sys/kernel/mm/ksm/run before fork() avoided the race in my own test.

Thanks,
Karl

