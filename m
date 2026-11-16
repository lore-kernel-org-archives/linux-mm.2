Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B283606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A5HmYzsz
Received: by kanga.kvack.org (Postfix)
	id 7B1746B00EF; Mon, 16 Nov 2026 09:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788516B05BE; Mon, 16 Nov 2026 09:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6FB6B05BF; Mon, 16 Nov 2026 09:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1D66B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:28:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89C111C00D8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:28:11 +0000 (UTC)
X-FDA: 85441211982.17.57673D6
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id E9BA5140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:28:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=A5HmYzsz;
	spf=pass (imf09.hostedemail.com: domain of 39xL7agwKCGgINXOYcOYKSGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--chriswiseman.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=39xL7agwKCGgINXOYcOYKSGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794839290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ESXbxwCMg0EOUGyatJ1Rbb2E3CVLZe4XssO0nIxPkVc=;
	b=NECKtsGUNFzdFZ2CeJJfd/XfcVUgBisMeFeFDvhIPaoosfsZSXYor647y8D6u8NSGzVsOI
	IHo5D1jqtSB9qq/lKc4nZJbRSKgmfk8OFTIVL4qS3w77yKaTA2l9mX9zJaWMTR1D+WXppr
	2WD1kbUqW3xyOxDKhm5ApNoC5Iue1Fo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=A5HmYzsz;
	spf=pass (imf09.hostedemail.com: domain of 39xL7agwKCGgINXOYcOYKSGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--chriswiseman.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=39xL7agwKCGgINXOYcOYKSGTMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794839290;
	b=fZJMyy5+OM8/xDuiMVdEhAkEacnnAHz0QHeDcx8y9UcKJEbY1n1UiJtogtqCQAd47vyvAx
	0kKs8nQPWvKmB9Q3tzxQtmRBSqfBLhuv/cOhzDKcunsoTN3zPTNPRVmWOaciEC5uoo3/Kp
	uBbrkzfuLIGoOzRA9FYrT6MTrcKi65s=
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b25d977b91so318847c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794839289; x=1795444089; darn=kvack.org;
        h=content-type:cc:to:from:subject:date:message-id:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ESXbxwCMg0EOUGyatJ1Rbb2E3CVLZe4XssO0nIxPkVc=;
        b=A5HmYzsz0KRdq0NG2IhyC+2ctUcgLV7fenIQGXNNDN4oARIQVd82dnfxGgVnUBSC/c
         1S8wYyBhMZb5Wk9FaUpiNtEGL2w8RiiAcWiGRIaDM3q6E+jZzlQBV4m11a1YVMBlFa9t
         ku1BvC73PsrdclzlEa6XLkj05mrw4WfKx/QPPR5LcAcpQ6Gh5PMVAzspPrtn+F6rhydN
         +279cWb0JQn6sq5SKAqfHUb39RJDqpfYukMu/8o+cOTPErGFuN4EVwNnAr5ctSgqNbQ/
         BaPeQN2CvH+R4TI+uct6KryJRLuIfNqbnSefSC4F0QEehWvpsEiCZA6ICYKGTugg9yiI
         kzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794839289; x=1795444089;
        h=content-type:cc:to:from:subject:date:message-id:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ESXbxwCMg0EOUGyatJ1Rbb2E3CVLZe4XssO0nIxPkVc=;
        b=gUicrR9yxCizDKE9g4E1LSUyPA4xsW+kbzc8GMUmRp0/CrJkSymMtKuPQAJBeEdI1M
         9Avto8PbrXrWyLJFI2glE94ArfBQ5xlQtKP5pudj3IFjsHOLgMRQJLC633YS3sdkr2Fb
         jPXvqUM0dVnKjmyn9QfeRwjbUkQRp0CnDgYif9vqXi+QZNACER9saYC8lJLCzpKjIFDI
         xhydNbZTc5qJ0NbqQgxcoOXck31IZnugSkdCzgDP0m2/RnG4AMOmJrb/aTpbIoggWtZA
         Gqq7/4DwA4U9PSkpSEymTzK1z6VJhmNcHogb531MRBMT9SULGC7OhckXjyHS4KSdl5YF
         IidQ==
X-Forwarded-Encrypted: i=1; AL+hErHcrR9MNMsw1JjkuGpoYDZJs4kcqc0nosELvw7LtxePrAdLNPnfkdtxTdj5C68z1SFM3Pg0giOxsg==@kvack.org
X-Gm-Message-State: APuU4Z8iBm0+mpFZDH2kb5lQktLes1S2QQoQ27mVhdkRd90UYyVs1pND
	AlnqCcul/XxbM+6bd+vnuY9TGLQNLEvV5y4H+iWf4lHfy7+GgZXt2yLkZF/ZEo/uHi6GH77Peab
	imi0X7hhJD3M4rmDKfxh7SuBeEsmlMw==
X-Received: from dlbtu19.prod.google.com ([2002:a05:7022:3c13:b0:1a7:6a69:e56b])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:ed07:b0:1b2:588e:f89b with SMTP id a92af1059eb24-1b503169362mr10450930c88.47.1794839287889;
 Mon, 16 Nov 2026 06:28:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Message-ID: <18e88cd2a725491b.3137322e32332e3235332e313736.c1dd7.0000sendgmr@google.com>
Date: Mon, 16 Nov 2026 14:28:07 +0000
Subject: [PATCH] percpu: skip sidelined slot in pcpu_balance_populated()
From: Chris Wiseman <chriswiseman@google.com>
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9BA5140007
X-Rspam-User: 
X-Stat-Signature: m77n9p7q7wwdexnzd814465ihnrsomtc
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794839289-753678
X-HE-Meta: U2FsdGVkX19vivWO8i/UCMiMmwmm+Hl76Tq2uub19GGaxY+xkS0YOdKvUdzC6qVKrU//T1YqCH7nNcqddYHWS8/9HtwagTxRNvvt5NrGkvZaTYbZ322WbiCbGNysBa6T3/fvvpDAEvrApqIyQsLEXDGLzUiU5THTj34Mv4CZLCH/xkwF8HiUSw2+KzeyttWZ4hVyWza8o8t1I9cWzuxxiKDdHGUPLrOntFJOhZYItvTA7Hr9Byr4jWaLdQ6Z7EvIcU8CzDGsZlwzeZ362PyxqFdVA7esqAr7PqpGxkYXZLA3FX2WCxVqDYTSg4RfGcA6K2QBrLeTG/wB+J4FNYfvZAPCaM2N9vLCFGnAXTBkZ9h5C2jlaLlSkOTKe3SXW2i3QDOmYTT6UgvXjvG9jZDn8EXgJ7uBm1c20Iy2BM56fAhYHen6mgatg7u1eahLyPDQFndhe27l0uTko6ZNziRBromUjJj59kMrIL62KFyTIhayXbZKOfq/EaumPP9tG0hq0kYaFAH26DwZ7i9CPMMlcVMUemDzsLb8YgbC/FI9X6FhB4Y+aEtNJWUtaQ3zp7wEQfGxdO8rwVLKVYz7CviAUPf+kOW+1Uzth41TGd012DvO/OqRdTnbfPTIgY4uusJ2cXCDaL/tVry8D0ZPWz9jrp7keNkDJIpcpxxpBG1iBwjPvcM2oG+Z44J/swNSDYNvDdiWQ0mE6h5zMksc1p90AiGukKXOal/7wcofeWCBB+Tfqnm1GwhsrZqLQrOS8brdiOPbdmkRZK8+CB9GxnktUlAOUyn94JRY5+9A0QpXtgNHkUInf5SmXtEvXhD30A4Y4YE3IoWgCoXDp5a5rs1PYvqu+Rng35Oh90uklSyWd8M+sVqVIsm0r2emhlCM7XIzI7brYRHrtihkCwkgGa8bVoDIerEJUyOep5Hh2QnSp49uU3oxfNbJ/BJEuF9PRSkyKOmWAu9vfpQadg1NOcu
 nZZL4FL4
 OqBuMpDBnFlKKqZaE8X57yxIAO9lzMTvGf2wlrk3iFmlTRkh2bHpveD/P6Sv0BvP5sglAOxAQySqq1vlKdq6sTbOvxaq6h2vmnAsSiCh73CFTQvZpmfhRa7rcZHc6scXoouX8jpeV8LkegiLh4FSUbkQ83hfEhzw4Mpn0rMhW86ezpisK7Fj1nkRpao5G1Za3jtOIsjLxIXu0g9MKT1xfgBTxY/L4/aCEHfMApnvVHfTwp/Wko0ND3Ex79F6ZNXTppuVGnX2RBdPpdVQuU/m8r1e1CLWNAx8s4r4kFAGmuq8o0I8yPpfcNxrZ2dtdtByc+G5QYh9EF/LDOOwUcWam5TXqWvg9ZGY2EqUbmOVwwti47+W3v94+LtIIsKpy2Z+cL8JLpWqgCzI5YtYMUK2S+ZoAF6kVhG4plTRGkoJKWWMnaZh4XA8pznr90EKCd+i3N2hWHphRmbYOM0rfkeP4VKphslzdPu5pkBpz5KBVLi8D+PfcbVv3mHyYPocXcuueQvHAOzSuYdvJspFJkDxKDSI9CSiWAoCKrobeKbBSXqfpaIMCi+adadC0x93WGJJ2SVEtRuhcZv6PNmd3OChEyen1UzLOSBSzVWf2SXyT6IAeK2p1nJoglCE6wKc7zzKSCMlaFSf6XvkbrX5D4UEQGHUE35lP2sA/FCF21ADXURPSqBHNA6Qb3wdyi7C29+gL1U1inpmcqvjg5+PsE7bzkEIqsul2qYyx8qyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit f183324133ea ("percpu: implement partial chunk depopulation")
placed pcpu_sidelined_slot at __pcpu_size_to_slot(pcpu_unit_size) + 1
and moved pcpu_free_slot to pcpu_sidelined_slot + 1 so pcpu_alloc()
checks sidelined chunks before free chunks. pcpu_balance_populated()
also loops from pcpu_size_to_slot(PAGE_SIZE) through pcpu_free_slot,
but was not updated to skip pcpu_sidelined_slot.

When pcpu_nr_empty_pop_pages drops below PCPU_EMPTY_POP_PAGES_HIGH and
active chunks have no unpopulated pages, pcpu_balance_populated() walks
into pcpu_sidelined_slot and repopulates chunks that were just sidelined
to save memory. Because chunk->isolated is still true on sidelined
chunks, pcpu_update_empty_pages() does not count those newly populated
pages toward pcpu_nr_empty_pop_pages. That leaves the global empty page
count below the threshold, so subsequent balance passes keep refilling
every sidelined chunk back to 100% before reaching pcpu_free_slot.

Skip pcpu_sidelined_slot in pcpu_balance_populated() so sidelined chunks
stay depopulated until pcpu_alloc() actually needs them.

Benchmark results (4-CPU arm64, 4 sidelined chunks with 60 reclaimed
pages after triggering pcpu_balance_populated()):

   Metric                                    Before     After     Delta
   --------------------------------------------------------------------
   Sidelined pages repopulated                   60         0    -100%
   Sidelined backing pages (kB)                 960         0  -960 kB

Fixes: f183324133ea ("percpu: implement partial chunk depopulation")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Wiseman <chriswiseman@google.com>
---
  mm/percpu.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3eff382e565a..ca83773a6728 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2045,6 +2045,9 @@ static void pcpu_balance_populated(void)
  		if (!nr_to_pop)
  			break;

+		if (slot == pcpu_sidelined_slot)
+			continue;
+
  		list_for_each_entry(chunk, &pcpu_chunk_lists[slot], list) {
  			nr_unpop = chunk->nr_pages - chunk->nr_populated;
  			if (nr_unpop)
-- 
2.47.0

