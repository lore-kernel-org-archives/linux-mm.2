Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD11606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fhu9MpVt
Received: by kanga.kvack.org (Postfix)
	id 7B0A46B00EF; Sat, 14 Nov 2026 09:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712FE6B05B2; Sat, 14 Nov 2026 09:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3F46B05B3; Sat, 14 Nov 2026 09:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D34E6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:49:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02499140427
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:11 +0000 (UTC)
X-FDA: 85434007344.30.6527680
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38D5D1C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Fhu9MpVt;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzMIfhwwfaK5hfbFxkKSCWJeCOa/IqQHzX7VS+tqj98=;
	b=LJzjd+r0HLH/Ig3dJtI4xAFvxZbr8rCncJvwrjYUBjO5kvALSvV17l/ebWQOKUard34jNC
	0hyoMwkW3QsiNu8BkJo9W8D7sgTpXdeZ4+/2J3yTjaOHTuap0DYhU9Sps7KdEUNQJn18cX
	zK0rvrw3R238SyopvNzFNHemwmlZaVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667750;
	b=YiqOYtl8vjDbdmsjgDFIJOWbt9niwiRwWW18I6MC6DYic8goaJcawpDdSn9RjMpgDXzyy+
	XAm5xFsa1YMudlBKnT9UdYqH1uasExAidZvJ7yduqVJDc8HtXOHM7Wyj2d1/I8ppAiVoTI
	YgJ35FE6TQ0FGqzZXkZjyQhnn9xzGaA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Fhu9MpVt;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so738653a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667749; x=1795272549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kzMIfhwwfaK5hfbFxkKSCWJeCOa/IqQHzX7VS+tqj98=;
        b=Fhu9MpVtq29XgHnz62vftLqSClv9PrZV2/4+5AHXtu3vk9ndDKxUrcpCUdh/4yQP9w
         wVfKHVrA74FDXEvMaOWPPv7/V30bfWA8LG10jVm+qCGB3IGT7nz7QRJsoLijuZrVsUTt
         tA+nPzblLLpVCrPYU/je0Xq5ZCM28uwZcKrVu60YxABeVhFxRCzN2uQ1zihBGyTK36Ig
         DpkN/7gEmQ5t6vuIozOM0uf/Fohhm5dlkuSB7Skt45tVEdmNH0e5plhQhNgFIJFjUHOs
         l2cNXAyodGVcSqV9UP038o+QpMFofomyRDLglWoRZQVjbjxiXEDI+CcvoKSyCHtd/s9F
         3doA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667749; x=1795272549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kzMIfhwwfaK5hfbFxkKSCWJeCOa/IqQHzX7VS+tqj98=;
        b=zq0lgB67ysNyLxoQNAjWXXYw7ofS8XKDaqrN6FrP/g2pTB0oWP95oG0pgZJJW4He1a
         J3l1iTSrVgNpN7GdTXVuLJgYYFrXN9SnH6151nbBfjmDdH9WQe+klVruAUaGOnrRqtdh
         d/M867AF7zDY5+1jgjIhi0rKUQFanxnmhwb4CElp/mrfR7T6rwYZ1mW4CZDaZ/oLEiSo
         DRNzelngOSyc0dFAJb2bdYhzWiI5aSCEuTX7x7VUFiOWXVqG67+eayhiJAqeOrNbOQdw
         El1/M/uJn9GoC8nVATspb1OzHYkw9lVzj32yJuIFyQ4yKnh7DZ0bOeEkyXV4/XvkNfeK
         vzXw==
X-Gm-Message-State: APuU4Z8S0mdhQ8rP6Gq21tXMd2euZRstF+lMCPuV64Cg+H2xrVEtFTG0
	zska4Jm+yWVJ9dFACM1o4pMwkGFiUiwsDLa7qOw/li+QPrSECKS55NCeA1QTxQ==
X-Gm-Gg: AYBFou0b9YGBGuzqhXiQbVwvwduIPVQhvHMD89SuQIrt4dg1cuM9teeLbYfKq5xp/Qa
	eUU+/eGgLh9OvDusSUxvQ9ieGd+RJcg4oXuUoIoy6nefOHwuoo6jdtGdCvRppepvofJxnMCJDiL
	MQCaVYFJHHUzdZfL5GytAY7SYHCRQXe6jtuaLcmtp34Ww19kATrHEQkWGaqKrh1AGRQO+WyP03o
	qlzWxJ5XOgf9n6xGBy2tXLURf6nwq2mVdi3MmLmP2JCj8ti801GbohUrc8SqbAVXZduk542+KTA
	EbF3Mba7Md6uysSWtSy4vuJKpCxpGM8uS2sP1yR+r4HCvyq87LwXlv3Ds2jtMWMmwBLbFZdjzG4
	LUlpNmulfXkzGpZufYnzd6UPW5KxWeNLHkAcZz/zij4r6VBBqCuVAKZX8yDDPnSv8cfK3wP0FVU
	YUOytNUUHlM8eTg9/5h9rSgtYTFdoya1HC3yTT+AoH+U5mR1d7XGKozfLCW7HuS7FHkaierEwv3
	eNwpXcWJN2/Jf8JFZr68/CLApU73XAE/7aKlfUKNSGkoZIMUyT/SX8qYWTQVNbYWieAFxmxYW1L
	j+eeBuJS73ydG1iF/T+66Sg7du5+5ujVHsHNLu99d4cJIeDWPMi9mc/meqHWZighQLI9
X-Received: by 2002:a17:90b:39ab:b0:39e:6795:f7da with SMTP id 98e67ed59e1d1-3b1b0a0e87cmr5694907a91.19.1794667748842;
        Sat, 14 Nov 2026 06:49:08 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc186fc72sm2599953a12.5.2026.11.14.06.49.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:49:08 -0800 (PST)
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
Subject: [RFC PATCH v4 01/18] mm/swap: remove unused parameter for reading swap header
Date: Sat, 14 Nov 2026 22:48:58 +0800
Message-ID: <f42af36d7ec66fb36fb7024966f4a7114f338a77.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: u36ow3gn6989qzbwq95z43a3wx1rc9dc
X-Rspamd-Queue-Id: 38D5D1C0005
X-Rspam-User: 
X-HE-Tag: 1794667750-983219
X-HE-Meta: U2FsdGVkX1883zb92XvBuLQWBkFjmo30whiim8VsG/nxm9A0dbNX2fdxLXLCo+I5WJEeJGYm4ixAFXMvD3x/35m6/hRyZinlhkrWxQY1woVe1ZyqnJdoDfzCwZ4nnfo7oiy2JpekEeOzjmthQT5e210noYSfPZvMWbp5E00rOOiexYBxOLm8m3Ik8QEglQbJ7rpGx/hY58Q4gkGZ7jfDNJ7nyim59PSbvkvqpCvJBBdDpUnOtytOydvUCNpDRyfTehBzfAPxqRF8ZU5NndESZWsoXaFp9h9Gypby27dKVV1axbWePaYt0HGmty6sZws8inm9nk2SEUC5DO4pzHGnDDpQZXq7PfttIilJdNJO/Liyd+zug6Z/luuVQSL68WkonVVr6XBwDZOBQ3SALYEU7N/nJnHFXSGkPbYOPjPSip45xxQkaefauppLC5xBGPmAUt5E1/iLiKj00JdMTAxJ4msRW0lMT8f4ZSF0hLxuL0ktwitKsW1Z/hiXNXS3TjCDFyZRmCGxVAC4B64c3xzfPbwa7g67eJRqiefqZValpg80mO/xoXTgOjSBlL7N6x9UeXlioU3PLfwQh0zf/dSvoyCbGU1Bdi91xQzDN0MZrMnkauzbTSxc7a+zLESWUHmoTMzRlFTqjJoHqXaDP2Dvn+AWS56p34n+utQBu2b8fvpC4ibnn8HeFDxOCter2g2l+oIKn67WDR7ujW9xSDeZ/LsA1y88yEtrkMw0yMqYXANJpkwiOKPehuX44c8x5B/Db6XOapK10SM4Q+DoQo9sHqlrUgqYXbUaK9/fIJMGPQjP3lRVtGFne7KLqyCSOZQqMCXQXotCbOFEk2S6fjFK7JqUdIG1DsnXDsWtZOwR2V0sTeJW5iFWQxXldbbZzOkOKIMnxLjvUYz5NIl9nN2loqRh/nFClSqF6Kgi0R9/4trx9J3UlFVwN1K6FwNnQg84JazSBxjefFOR/xvZGk1
 /kI02WFs
 wKiDD3cVJCAzpXaqf2cMizDCsbTk89ru3O2xU71sx06nblMDzwShcLTUo6GSW9rfycdSV9cdHSBj+2zYjrJmBy+fnz0K/sEtuxWAjMKDy515ZuNH/D8dagcurRmkOKATK17nJlY5j2Yic3vavalUAUSaXTl/bT3BGsd3DPA3QW9n0K3kcEmwjfkMry0MUws2ilK3Hy6IuRiGOIyr1Q5BZZmSchd1VB0z2H6i9zln/2NWOtYBlNv3Bka8O9ynxQDf77QiSPFzSxzxQ/YyRFDM9TMjAkaK5NHiQ8kiVRJwciLeESbiBaDAaVhv8VjNFSOAaVKDqVw1nnVIGGfo1GZtWbDzp9w2zb0dnseJvKP0K+5Mx0Z16fkZ7xY/uqyCBJ6LfMShrn9ie+L/aoOaK89nCnRBFufmm+4zR4/RR36bdSUrvh9naqjbu44yCWA4Ep/tMhQ2iUQBjkFSFkRgO/taV5akCwrpyx0lHC+mR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The swap_info_struct argument to read_swap_header() is unused. Remove it
and update the swapon() call site.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index fcda5eba1714..c41c4d26a7e6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3630,9 +3630,8 @@ __weak unsigned long arch_max_swapfile_size(void)
 	return generic_max_swapfile_size();
 }
 
-static unsigned long read_swap_header(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					struct inode *inode)
+static unsigned long read_swap_header(union swap_header *swap_header,
+				      struct inode *inode)
 {
 	int i;
 	unsigned long maxpages;
@@ -3863,7 +3862,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
+	maxpages = read_swap_header(swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;

