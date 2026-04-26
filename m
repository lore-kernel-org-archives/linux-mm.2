Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1740DFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 14:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685E86B008A; Sun, 26 Apr 2026 10:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CFC6B008C; Sun, 26 Apr 2026 10:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573706B0092; Sun, 26 Apr 2026 10:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 490696B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 10:45:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12733160677
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:45:22 +0000 (UTC)
X-FDA: 84700980084.22.67D5C3A
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 399981C0008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:45:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DvrJzcTf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777214720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYEWwYPnxNhfjfvrN9NBByfvj86/jsr9iqTYqVjgdNU=;
	b=ZWQr6PVmEinckGdvWkJGvnG+VW7huGbF6MZ3VK9839eV5amh1jSQUahkRuNpkulwKLVG7r
	YbS/0ulGcWrbStVtY2DdJpmM+Aq1soISB2Jt4WBctAQHFFFgZOKWrP7yHnikuaY2c/Zdm7
	7l5BxlC7lswEu1bhIzHnQ93Obx97Ffk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777214720; a=rsa-sha256;
	cv=none;
	b=vwqVDaa9SPrwTFETAgum5akJ5nldg1WtfQl1wiP4nfStxTo/xT26LmG0QU6tGX0XID2K2O
	Km55p8YOfZy/vZhYVRNuRlluI/nBynnboH9sn4IZXOa+l4fEVpUnT6Kh200cl/B0cZQyKM
	JiD/nAr8Xvob8IQToBuE0hw7Uq6iQ9o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DvrJzcTf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-362bb3260f1so4078892a91.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777214719; x=1777819519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYEWwYPnxNhfjfvrN9NBByfvj86/jsr9iqTYqVjgdNU=;
        b=DvrJzcTfI8SiqIwPV2eSH0vqLS7TozCQfWlibYLw1ivTFWKLjcpbcqkfifJf17zOAK
         YLI9pgbS/bkhhBZv6A9mWN7VLkPUKPbUWbwWvb7pHAv1vOwDwAFqs3OOkdwYbmpzDikl
         PmYmehJ6uUTadCKDur3G4GR8OSGq5ABn+Sij9inQH12hmG7r6CKsqFQ/2HwB6/hTkhvv
         yR5eKP+6bhmpr1irWiEnNDFd3Ocse+AriEoe7SCBDUeOiH+ON5cZR2Ku/L0ph7npeqAY
         j5yU5U6LBUiXvPu5QGybkCHhAnzJFWgjgUSX9oPeu+ZKVcGuyQ/QTFIZn0xwKyPLzfE/
         9lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777214719; x=1777819519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mYEWwYPnxNhfjfvrN9NBByfvj86/jsr9iqTYqVjgdNU=;
        b=I9EPVxRaw7fylViTsZM9BpUowJYw3ybrqoYNgPIc71TKhCEnI48FloA+tVvfxn5QML
         Hy4FHTNGBCp3QxvEkMmgmnAB5Nr6Uaoa1L11c5QwFCoW6FBlm6GW/qQdHrHr4oKREPxo
         j6kDf0Cqpi2ePqMDwzeqtqIrcGkUY/Jn16nSgqaswbFOC270JpS8iRn1A6tTdwsebwhZ
         XE6TSHmL8/TwgEZDbBLoqpPoHk6Xwr+KL5X/yvGXRE3wWhgCzNPJqRjA/NXYc9MBJd0/
         4DK1A2A0UqiPLwBdxxg+K/XKps/Nr6pz8cDUwjqPP1x8g7ni1dPhDCYevEw+DhRUyeMK
         inSw==
X-Forwarded-Encrypted: i=1; AFNElJ/27tA7Zq7gTROH+x7IImGI7q2oN33ac9jxtpRs97K/gwau/SJrcM9h9DQtIHlpIn7sc1FnaS+y4w==@kvack.org
X-Gm-Message-State: AOJu0YwkVMijqCA6Hf2VKAdGdEewlXhTk4jYGszwKWVujB6u4HC3ZhrC
	ZuB9YEjNCyVbiVFZLKJboxRtLSfEZcf2Ie9iSZ/Iwf1X7mIlK2yt4dtENEYQqtiwGdg=
X-Gm-Gg: AeBDiesprhV901B0d+yJ2wC+8rUNicMQBxhQlk5MOz2rB7qM29yLZsPcYYCEdUKOOWs
	rZChOU+pa+x5xWpqkA9tuHC5ZZwt24X8OqOmFlEZeUQjEcsLJOzORXRGmzBgsTlg1BZD6Z7Zt1I
	WO/fZwkn6EQO8HMCL7KCAQlWaOtu4hEgOKoD0YrOipTARiElSuiL3xnx43/2zH18KhIHuGa/GVu
	lTG0ueclBnHOgdroOIK3g+XcxNm+jdSesuhTqWiqN2IL54dOiJFJc9r7uRYGmPjgMkUENpfiR7P
	vKoXdaejMqE76hsUpzNqNk4X2MBY+DamaLI9gUjHbr/rjloAH5WiwENkmxyifhHrMuLNm8X4eYg
	zuQQgLNurLS+Nj1VuCFoUHkBYlk0+WVXqmsHJNxFVa1yYGkO/59YnrKtEeOM0iN52I5yuS3V9jx
	smG3T57TlibmzCHzeK5Dr1UvlBg7s9
X-Received: by 2002:a17:90a:f94f:b0:35f:c5cd:cc5 with SMTP id 98e67ed59e1d1-36140498686mr40821690a91.24.1777214718891;
        Sun, 26 Apr 2026 07:45:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::349])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm22340550a12.24.2026.04.26.07.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 07:45:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: muchun.song@linux.dev,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] drivers/base/memory: fix memory block reference leak in poison accounting
Date: Sun, 26 Apr 2026 22:44:47 +0800
Message-Id: <20260426144447.817722-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426144447.817722-1-songmuchun@bytedance.com>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 399981C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: e4ttmj8gf1qscw14shrjkxzjrzwhrhxm
X-HE-Tag: 1777214719-777447
X-HE-Meta: U2FsdGVkX19fqaHCrw3bsl+3cWMFW1Wr0l0d0rJELUzhcFTStwpvUGxO6oQW3XsDclnnzNhYByVYvaLtj74+dnbK+edvGbLnLr7nhKs/guXqqLr1iYuEUrwnaWCyMrv2kgRo+nfXO3kgfRF0yXxuoLu5lAXet33jg0Z8yD/QU2Am//CZHAGd5i0pVM/DEbTYOC4tT8y9kh0mh+0J1EgmgLtD/RiF2RKwcv2efhfqjOCjjCIimWki0l0KTq1GInrk39BuErPm0ZsPVTO0uifsZ/0fwE7p280emSv6S9LwF+DGyyD//JcmHw9MxKhBiQVeIBdPzR8JYLpGFqn6nYWx9F4p0PycOu39vLoyn2Een3TNUu8Op/t86ko1X5cjLOpAukCBvFGuUAskdlNIX3V4NakydHnNA8dyl3dWxIW3rDmjzrXpc7EiEuzZ76lpRLQSG1UojA/Mfq9loFjYt8FssDq64vgxjoz3t0wkQMWz3UIdTh25LvukwjCQ80UznjEP4PJD2PJfHTM3SG0IEDEngwdh4Alqf0FgVJWx/LOEv1RjryqECnngnx9NUICkiX/1NnspYnoOelndHppt2YWY1aTcdROUwejzyC8YlnGzMvJ7CFUlWcWkcM4qCgEc8/1aqd1oEn+fCLGEeVYgu8wP5XASuSbj3SIq80+POwJeRfwEpbTm9b2vWqIn29BrN9c5AOmp6I+zyot4fSsztBQ27K2vF6mjlKHsgxG1v6LAZfYO2IbazOcsfgtWkhDG9+JZPcV9w+6ke/Q5+2RPOFaQ0eOKIn9KnmvZpewskeM2xYDBeZZSWTuZDE3nQk2492laWcA19GtZsrgF8Lq42YQoiJMtsYIHRb+WZ/qv+aHheJCD1fGp/W2wlgNgZ5o7dLwTR6vBZ5DUB8pV+MhpIF4jLZi/hUhi8KMuowxY/7njtQzM7LO6QCGBrIUon89InXfiCZfKIy5xCOdaGnWP44M
 v24yyf3O
 oZ+16qXZ1rVujPkvJtDwgSfFvd+HtZeiRt4EwtewhGdz7jAKtU/uiMV/R8W3Bz3xMJ5cqt0kE1YQQTx2NGKaTLzbSpYr/cbLFnV4EFCw6GlrAlo3GdFVqCBA50tj7HCxiSLWuuU7E+Y37QzuRM+1yhTr8jyqn75skOvBOC2/lN3awoSZhR0OF3J+tpoBXe4n6zIKgtrcwIRQoOFM+/ZD/60mplBCQUYSEUIfY9B+3MQoUJWz8nk6w0jHoN/v7KWE03Ub7LrPmfrF1YIxl12dYZmzHrNQOduYmuKzpyZ4++zHqMZFMblQBsPUMjOro2H+gJ8MTsyjpwZjw8EjyyANBtvokfUgSSVLPl2q5ZsAHrED4WDWjjmQUGm6QVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
block via find_memory_block_by_id(), which acquires a reference to the
memory block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup. Drop
the reference after updating nr_hwpoison.

Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/base/memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index f806a683b767..6981b55d582a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long pfn)
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
@@ -1239,8 +1241,10 @@ void memblk_nr_poison_sub(unsigned long pfn, long i)
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)
-- 
2.20.1


