Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAE6606A338
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=znnEfTQ+
Received: by kanga.kvack.org (Postfix)
	id F2D876B05B2; Mon,  2 Nov 2026 02:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41816B05B3; Mon,  2 Nov 2026 02:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB876B05B4; Mon,  2 Nov 2026 02:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42B06B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:44:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1423A40C8C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:24 +0000 (UTC)
X-FDA: 85389391248.29.02BAE36
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38FBB180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=znnEfTQ+;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793605462;
	b=4SngZf+0A3Zgc4ULZOBA61FHJ/a6o8IyP8h5e7MPmkw2bSq0CUM/BXEhKMMz6L2FmpdFJV
	KoEvjeris9qNSmRxvCkwWl65TQggNo+cxs8w3dFBcLr2L7lI+MWiftMGau1cIoqBsyW+Wq
	mEiOaOy/DAsS3ArZ3rX0uniHdhuYIAk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=znnEfTQ+;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
	b=kak8C93vQVXOYbfrNPcvEppfZNaNsAO6HTjZYFl3AOQPJ7hUAR5PJEKZ8d8beFEa1ruNzY
	JZsAZ0wpK5qIiRIAe9lCBkIcMxYxKNcZQhQV3mzpVc/ApQ2hFJ6UIDxYO9nNMJmyPry8yS
	+JeD1mLgK3lDW9NEsuxp1dTBQzRX7hY=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso1543815f8f.2
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605461; x=1794210261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
        b=znnEfTQ+YdotkZ7nUGLLv+eR1tdssklLoJAEK1Z49aLC7ekOkDXwNoqJ5iHq9SL3HC
         i1rrb6ac4skFuStSpuPtrllSAouP75si8GWjj3TiAzRfvOsXNp68S9Oziz7oo5gdWqoz
         e3lxrqOoyddVcyqjYfCrZzsPWEXxmX21LEXvgYjpy56y+Y6ymUmfy0NjILW9GRUDHFtl
         hMXFteBwQIPuuJqZCACxsGrNsiNyCK4kTn44XRe2YZHBL6tVg7bmg8sSw8BTPZAJoQo3
         MNqWv8Wh060zJz3Pe+IKrZqwj5DKtszNtJCu9vF26eZSpjJLtSW7/iBHVZVOWfM33sB6
         GZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605461; x=1794210261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KUnvJpVPViW69AF9NkZWmBblFWCE3alugKf4rSddKS0=;
        b=1hw/8zSLpP++rrWtcsHafWjeFFy5pFJlfINyw6gN38HwVePNs9A4s35iEWtO3IFijm
         4A1PQz5CUsU6VqRytisfqcJTvjXb+IadohWamVHFsNpa2YaTB7nc69XVuRRzvAYjGr0u
         ZE0NX7NAPJMsMEttXTVceBnSEb2W//p+A/rvOUMX7OeqDDwQbwrSnAMxvSSUwLRa6bNT
         GxSzRgOVpx+zJx8JmBcIHfOicttisuxSEzrkCuL3EE/DdY6epS8dd/N6j5SKIZRViRi/
         FJA+gixsOe72Q+XoHzmHYZOMRHCyBz+LQ7Vb+24S+67W1Bw2lW/pDe4zPej6++l2HGq2
         4A1g==
X-Forwarded-Encrypted: i=1; AKwUvBw95eudLp2CESDYJJ8iFukcxyuIpa+1/BTRKeiODYX8x66sh+Ev0ykFJR1wQOCCS5ERI35BRB6Svg==@kvack.org
X-Gm-Message-State: APuU4Z9dCsY+mZystZhktfd4HeyI6yFDE1QFPKmZXDUr/e9nhYcIAbvj
	l9fzqApdfcviVkHgmWnPWNW1TH4bZgxertPdvByoZWpi0WcS0CpeQwrE
X-Gm-Gg: AYBFou2rs2M7UJkMOEd1og+XVtK6MV3e0sIm9RXZfCXpFQ7F5s6llm9rPs91feL6Ikz
	vabWLBR6aLLa0IaEbNez6/qzp7lTZYqd7KiLl+0omfS+zw28yjQAl3jo4VWfjwSiERdml+NcZhw
	SSFmueJfWsPc63Y2k9xaQso+zOKS8MyXd49hNWV7lYKavBWUXp7cqkcZRb6TXKsXIuXgrUY1wEh
	CoAlhH0S5PsQfUkM2i3HuAAlDzKnVrFgha6n+oH0idU+B/Zf0TEz5dM1Gbja5ER8WVSKqjgGHCy
	B0ICbdNoNDkeNPME7XiJKoPlJIXiUsI8c15quJT+v5M/vpPQPJHAEL5hekNymHruaHOCj6JoK1p
	wFGp2EjwHQr83l0X9TQtTaaNrHXrZ9wOJnfSEpljY7Sn3y8ve/EygBM5eeeE5DZmMvGu9B6Dge6
	gMOh/vk7jz/1ESyu9LOvzBAdpx3hK7+YeiO59NceZO9/NCciOpVtVE4inlB5piGwxIiS5nSDjEL
	XSQnr4zl/5gfzRtWAEoGd7baMdr159atfW4eHQtpXoXq1VfVRKIK/jgptMVvNAUMUKJOvGnQ3rb
	mj+X5+W8ueFt9g==
X-Received: by 2002:a05:6000:310f:b0:48d:f95e:6e8 with SMTP id ffacd0b85a97d-48e6e2c3586mr19528998f8f.1.1793605460880;
        Sun, 01 Nov 2026 23:44:20 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:20 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 1/3] mm/mlock: make a zero length request a no-op whatever the alignment
Date: Mon,  2 Nov 2026 08:43:59 +0100
Message-ID: <20261102074412.189554-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102074412.189554-1-azpijr@gmail.com>
References: <20261102074412.189554-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38FBB180004
X-Stat-Signature: isz9fwtt83ujz6p77o4bu9hqtm9h5jzn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793605462-778871
X-HE-Meta: U2FsdGVkX19y3DKhHrgIZU7Zo100PGgqovVUdxrtboFzs/kmV08Cr2L3e/VnRQ8NrNpHkTAaYufYqxGVz1ZrHI5qkoGuISTHK98iK0bhVLJnB7koa19TtWRBHzekTQ5iIH4pThWJMaqi+QahWDoBErV8siMJkhJwoBNi6ZKNDfxTAUKvLJocQgJQ84U6YSE63qQPwshbw4iVFVNw9KdoG4UNG8Ll4NsgmJoo3ay9F3khcecnc29vWZ0NgUEF1EmMaUKq0NSHrftmHiu8pdN779Zp24OIYDR+uJlX9JxkF/n46oQlXoFI5ugIOLjf49kMI6fdtMmASMZRwHq6JdcykHRjXj94KX2TsIXTTV84J8+SlY4rbDh2tGLa52UteFbdVtyXNIxEHwPAIbANcLnRp16V3ZHudRerrtlXrXy7QlGK/RgyH7HH/JFFzPtcUBj8B0tfQzO7uiiHpwFv9jsaxIil2/OHGXnLc+PBK+Iecc9G20rLJgdZiCjsXswsEe8L8cFqDD/gVOyj4XHjLF40Vn9sKfskQFaRQ9FuPo7klLI71vOEwil4xePMtr8+1CL1S811iHsikaeKN7+rDQtgS2ptR2BzvS17XlVq4gvC8yIumQLjeb7POlfklpTO8KzqoC38lXpb/c4OfhzyYk66cz7Y07M9l4W+6a9hRMeY82ytqOEb8j1hRKRKDy6+H938ROj+TQrQeKhmOoYry0Ci1ckXBpY0zRzh06lJOBRyCWIARLtVjHOF7Mdh2bQ3ay5TKfv74E21uclLrhYCfrp1mELD8vGcHexOU9gMREJaJckMIpKVKAeHDS/RzhJMyGjKu7mM+m+tCZABxPwgr+7Tx9Quih/qQDgDgLAJ0KT6OE1bKG4xNioVEzgw+OPkoI+oNH0isykup/ng2LII1gVYb8vBGqMRniwuv+6MyBLP3CNzrj1C0D0xalPGQgde6RloJQw5pAM188kEzja/dIg
 2BsAkZU/
 VwDRz1q91xpePRTV8ekwVzAn6OFdoeKJauxMheo53vdUX2JWsdub2OvsbkKqHY7nOv/nhH8fY88htaXKm++P8LSo/dloYLItw+ypVI83VHOawssJma1ZO2nl72IA88FwGGoWWbcbToLoKaTszYbrMsp6U9ut2zbuqsIZ5uvkcxJ93XMBtbWGS7ps1l8u2GyX3wrtmjdz5lkfWPmvROFFapJW5rHm1PNFycoVAvBMDsKYxFvHCb020+nM/w2WBYPEGW0NHJ+PIEXmPoO0Vc+hwj62JcCLk6SDNLOgtkVe8M+wfEl/wOQ8Y6T1NgD++5llGpvC+JTNf38jhtTco/pZNfzm4xWziZJOz/U4KuQ9jkeaxu6cttEAlcqmNiDtNrcd+piYdw3pOuuTFWPNY8gsxwYsKM3ADBIc6pJxvwrNdIhSQjNvFAFdvlyHBNPTAZhygS9IjBoXMWgnoN4GPlKfYR+h8KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A zero length mlock() or munlock() at an unaligned address is rounded up
to a page, so mlock(addr + 5, 0) locks a page that was never asked for,
and munlock(addr + 5, 0) unlocks one the caller may still rely on.  An
aligned zero length is already a no-op.

Return early for a zero length, before the rounding and before
can_do_mlock().  This is a uapi change: with RLIMIT_MEMLOCK=0 and no
CAP_IPC_LOCK, mlock(addr, 0) returns 0 instead of -EPERM, which is what
munlock(addr, 0) already returns.  man 2 mlock does not say what a zero
length should do, and -EINVAL would break callers that pass one today and
get 0.

Reported-by: Park Tae-sun <ts930@dgu.ac.kr>
Link: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/mlock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/mlock.c b/mm/mlock.c
index 1c70a7829394..673a8433a0a9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -612,6 +612,9 @@ static __must_check int do_mlock(unsigned long start, size_t len,
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
@@ -678,6 +681,9 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 
 	start = untagged_addr(start);
 
+	if (!len)
+		return 0;
+
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
-- 
2.56.0


