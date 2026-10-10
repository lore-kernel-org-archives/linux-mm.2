Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A57CA9EC0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 11:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5667B6B0096; Sat, 10 Oct 2026 07:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E7D6B0098; Sat, 10 Oct 2026 07:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4541C6B0099; Sat, 10 Oct 2026 07:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3296B0096
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:26:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73E3612081D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:19 +0000 (UTC)
X-FDA: 85306488078.27.66A9ED1
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E98820006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:26:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WKVx3eKZ;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791631577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKSY00uXgysUXVkY7SlpnwG5DQxZo+OZZK+2IbfOVaE=;
	b=su4Y8OKt+R/3Y0GNIMzM0NWpEu5fM1v9m5hhIRRwDYBfYNqA7tfJqAK2nRrQadEctP/15q
	RanU2M6yQ7mbQjV2r0dabpzRso7NOi/fntwRzEVy0oUKH+PEisiWKG//oMmGfW2bFWEpiu
	JuvJ1bBdH5eLlyjUINo7Rdaj9wQf+M8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791631577;
	b=Xe2RXbT1vBmAxfsKDGz1kI98XMJVuTNCldhQzAfp4H4yGqfd73UTRug7CkGvNu6lZiGXwH
	YWqfVSEgLthlaDSx/t8YePv+lnt8+xBXcgVDPwgn5By9RjIxcDb62RlUxf+MYIgfrh/0DI
	qAj3Xmc7Qi/Qt1R3nYq6pw7Uv+kGCec=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WKVx3eKZ;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so517939a91.3
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791631576; x=1792236376; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DKSY00uXgysUXVkY7SlpnwG5DQxZo+OZZK+2IbfOVaE=;
        b=WKVx3eKZ4R2q73FQ2bVtRI4xsbysE/7KGk/w4hCXKg0KkLWqgVH20U1PWF30fNMxP9
         DrW8EhqXjSS5adaPPERBjbcKDlfPTkXah59IMUqa3nijoHuW9i2SktTOCY85IvJYabFP
         yAgAnzYeA8F0OckKLttdKdGWlKx0t0AToVqjYjb2yFgoN75ZsYkGXraiEMc98grm0jD9
         8M4L5m3vQGDvSOzM3XX71uDIFIfXMXHk5481Jv9IDH99XyvNciDG3SzwDHKokMLOReEF
         nwd3yoCAmHpwh4vyayCD+X+kt5pe6rrEGnM+U6XhDEhKdzY+zvMUuo10x9InfxsfIN+t
         X3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791631576; x=1792236376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DKSY00uXgysUXVkY7SlpnwG5DQxZo+OZZK+2IbfOVaE=;
        b=LwcDUnIkZLQ/lGPMQlPZyRs6/N8N9ZLq30Hb2XWGshKcH2C+htgF6LGYlyFxuVO3xC
         12pBflPcJeXhKexPwOIskzeu/C6pegb2qHMsenz07F5wWxguCopkk/Je1ryEtxj5hRhJ
         OwomQLtgBGafpzXHVkqslg7AuJcTCQzjGrLRVh8g9ccaypHbrEYB78XssY8veWkh9t5Z
         Ur7f2Yegn6MlyG3AL7zVwRK9ul0NM6C83I3irkKpt1XHPva+cvV91teIPatflyqhEl9k
         ofp+zR+XG0dqAII1xzO0EXxh6cd5NPgbflFfc8waOKuZ0Gx26stTU1rSIQazb4mH89P7
         vJPQ==
X-Forwarded-Encrypted: i=1; AKwUvBzlgVILlA3WmbVoFSNh5AJ8MipmytXpKdgyJCBr/QffM0TusFl+KBSsmXH0BBeEHA4mLlSnIQZvdg==@kvack.org
X-Gm-Message-State: AFq9FYKueMVzEeTuwg1y8Z+l7hJKqtoIfW7UjCE+JBNGQrjiDTrSANcH
	K/3sts4Q7IJhgjSATlLtb7T88r5XVwq78giSYyNZkGhhrCb8FbwkanAK49hTzYmb4rA=
X-Gm-Gg: AYBFou0CS34ceLsEb+o9TVKk3uAQbzTw8omnuCorK6CW+zEoQIKHcErd1mL92lH7sxx
	lnMAKLLSD4KQz+yO4JWkJ1AWLSm1CHCBpHKyfgHc+dgLx7xbZnaIv8HRuB9huznwIArBTJFgN3/
	Y6SrFz3Y694k5/L+JY+PUYVd8GJyc38sh7nXcxAYavPkeNDUR6nguz/fzRIJ8I+mbjSMN3HlhIN
	jxfZJSzWbKZ7G0Q2PEJsjsFpqXfXMhdDc4yahQ+d3kf3zLZMQ1kmIz0oi2I3ZFDnMTFTa8C47x3
	9KT0kguWskitsHgmbrXX4ITOS9aprw37xJUJVAc076jFvEKCy9KWbIOFPcdEYEDcrUNfa5TNbwL
	MsJbvn+EQsJob/KULrcklVds6jYNMH8UHGvnSeP4iuTqay9uRAF39sDc2Uqq+DWa7hIWiBZhQ9i
	z84bNeV7Ab9iyZDrqND1/VuEQgHJOmUuDM7UbYXMLf3ok3Eaao0O7K0jw3E4ZdleXw+BUjgGtCb
	hAlBkIODmAXbaf3zysO9DBVAP3W3dNChW/ZuQ==
X-Received: by 2002:a17:90b:1dc1:b0:3a8:96cb:fe8 with SMTP id 98e67ed59e1d1-3ab3a2fe583mr3989437a91.9.1791631575680;
        Sat, 10 Oct 2026 04:26:15 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab3690474esm7900233a91.0.2026.10.10.04.26.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 04:26:15 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 3/4] riscv/mm: fix missing destructor for hotplug PUD tables
Date: Sat, 10 Oct 2026 19:24:56 +0800
Message-ID: <20261010112457.49485-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261010112457.49485-1-songmuchun@bytedance.com>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E98820006
X-Stat-Signature: dfost5joazz3zhjaif9aebf5a38hph56
X-HE-Tag: 1791631577-520762
X-HE-Meta: U2FsdGVkX19rg4CLSd4qA4F1Vw84Ei0wmUsbKvFUAgsXHViIzEE5th/xeP5EniUoL0L9uqzUCb5ksLnDJ12Uo91pB34Pt2IgUnXFG/IZya29pia1EjDWCZgVNS3FF/l5cvFFHbHdLdm1PeVoLuGCq1LUiTUEy8U+qdsZWBlcF6/6kmNCcw9awnd0h0hUkgA8IeEXtDPeG/NQNBf1bPFH7GPvs8UKL6gpWtX9xuBClgL7BwtXcBiHB1kRXAKehQ0Cap4699wYHokRMJtb4bj9JkjZjsR8QvAQhb+4cC98fQfY6Z1JHIo0YrQBIcpGy4rueazf6wagKTvUOE4oNpoJqvSGVlscU8b1jL9NS4VORJiF2gDc5Kb3onmdPZjXdldNLy3ALbV0N5/dM6B/TLIGA7ooYyTSFGUFEVmeBz29dsRmB9wcGNdzX603mWxXoSDRUj90Ld/hHBl1omLMVeFNIq+1RZopmnxhqQm03+vzQ7GeOGk1DjerohBFcOFllIlQGXlMtol/u5IjUjMUg8QYFWSlcnG4bCt3fQJkYWG3pfWwedIpVK/l0cgN0zBBTjn1ZJJ16YMw7Iss6qganfWlUFLga7UW98oqc04fPsXu/7HEq74tQsMx7cQQ8D/G+j65ACwMwJ6wP9mqCEEg6QKSkiW2pYYOtoIq5ISXgu6nNpnd/zALpC2THEzIOk7rgB3pJ36YAmpvRahMT9v192GVpvt+lUxvF1rV3PFqdbL34cKKOlCI+5fb1cWiakeKcX5ZSYL05vayp0AkOV7UqXbGoUfCpNrMY/LX0OD1XHxYyU+lnC+W5hWccRGS+sF6OqpsFfz99WpyzPMp11jRY802UVkBbei98NJLQOR9Ln5X15ZZds+KvOduRFCky3b4SL3Z+/p09bQFKUDBShpvYEf72UWDoCtoZihdBGshVr/u0hCb9yDcrW3+8mcQcHo4XmcEKXTt2FdPfsPZtk4flxR
 tb7SajqJ
 blMk47LjhA/CvPDYHcE5I64vBEmEBTVbI5HD902nuLxl144s18XPsPcoO8jeN6qCXxds+tLhoUQ0Oo7LLfi1oOEwe9R0pLQKgLKp2yKaUKmbNrgbSP9qs/HFAz638FWXVd5q26nmvyGJ+XTRsD7SQgNUAyGC87eXMeWNDthDdpziugLmcps4WY0/U6EH1jd070bFTgWW2paBhIgTtphFSEnV4ISZD4NJe6tm/FNxS+MocpmzZOv7aQLATQAMzq9R1rKuw2572IT6c8xrwwD29Sjr+Tcs1rzEhVbL8J1iDz3euYTZBWqDozCzOeobqyrLf/p+xwmXPQ5x+61g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel
pgtable alloc") made alloc_pud_late() run the PUD page-table constructor.
However, free_pud_table() still frees non-reserved PUD tables directly
without decrementing NR_PAGETABLE.

Free PUD tables through the common free_pgtable_page() helper so that
constructor-backed tables run the matching destructor before being
freed.

Fixes: 8472cc4503eb ("riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v2:
- Collect Acked-by from David Hildenbrand
---
 arch/riscv/mm/init.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 151eb197cb09..4914864cb350 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1538,10 +1538,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 			return;
 	}
 
-	if (PageReserved(page))
-		free_reserved_page(page);
-	else
-		__free_pages(page, 0);
+	free_pgtable_page(page);
 	p4d_clear(p4d);
 }
 
-- 
2.54.0


