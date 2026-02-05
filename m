Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0231FEC1E9A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666E36B0096; Thu,  5 Feb 2026 05:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B2D6B0098; Thu,  5 Feb 2026 05:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFD06B0099; Thu,  5 Feb 2026 05:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 375536B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED14D1A0480
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:48 +0000 (UTC)
X-FDA: 84410087496.27.1DDE785
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D533180005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HJhjXYmO;
	spf=pass (imf06.hostedemail.com: domain of 3QXaEaQkKCJIw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3QXaEaQkKCJIw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AP/JFqXWkX3OpU6TUDwkTdWwj0hDDWhh2cwk4JKQ6LM=;
	b=Dy1/JaRxrtGQYCOSysKmTrRwfsjHoUX7eOw0AF4NKOxWdGPg3cTuCFxIiOviB1sU1ZL+Ow
	TvYJF3w+SSgJrNxZ+zvgC28IKWI7mMa5JXT3gDNp7kWaDTFB90S8j2AW+w7ZAaRp0zmGZV
	R8qemsomTem/UwT78S++JL1ERxzmpgA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HJhjXYmO;
	spf=pass (imf06.hostedemail.com: domain of 3QXaEaQkKCJIw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3QXaEaQkKCJIw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288707; a=rsa-sha256;
	cv=none;
	b=yPmLC97VYeVqP9PTfzeO+NGuz7szwQuzCwLL5PrxxklI9dOIjWMrmsjYihMdx0oHLS4yiP
	NtGPF5axPsmu8KyzHU6X3iyuSQOXO4K4JndmT7Yg8TXuPseNIs14akjDsVmaWTs2Gi9Wlc
	PlUp5gM/IfwBTnLWRv+XXTc/vZMI5Z4=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-658b82db375so839319a12.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770288705; x=1770893505; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AP/JFqXWkX3OpU6TUDwkTdWwj0hDDWhh2cwk4JKQ6LM=;
        b=HJhjXYmO8v3lxVWV5jzm2/PmDtefb0/DETdDU0/EBACDIqjorNvOXxCmyNEMdXhBFo
         yPwfPg9f597q8M/RMWfDpqXcuvLrXD18M8Wii2ZquXZ26thv1eCL9x1I2TmKehlUrAk3
         VfROI4NrLUY+4opFijNczDE1iJGiKFVKDTRTl7IcJQk6jM4+gdhnyHEcwdRARZgFxysm
         Z2LeO9bNDNwlZ6CavilWjXF6DB6mvdlmfSNkVjobrXUO7szYrtdRjQBEME35LKCbHYw0
         dRcxztera8TkhiCaDyGyEmIPL/ZzvhbusmpjavXtjtOw4Tt6HGPGbOgbEVN8DpEy9u8A
         kvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288705; x=1770893505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AP/JFqXWkX3OpU6TUDwkTdWwj0hDDWhh2cwk4JKQ6LM=;
        b=Gb+hGPSbi9pOxkcEfmIT6tgRBjh/PMM40ojGSjxSR+y+OJOutJg6SyIf7CpuZq9TR9
         v39Rv+FezICV5OrYzh1HMD8qEWrXUTtCLYDsWXj5pN6pPIj+zBKXrmMwSgxCFslMDWG+
         y6+vTQ9DUeoOzTNeCr9AYVl6FTjfFPh00z9UGPTZdXqMUkSHa5Gq1h5/V9XWOyB2xe6p
         zvhk0bLJ0a5MQnlUWanxc/TrlO+wJb0/mkLSjIMrnj9CkAt7tvxz+efRaTFIrA2V5SHr
         bvv2+stsai9+lBdD+u6gTDRdPv6m+eufbhmU5YhsfOQrUSR7+2y8fLVP/6YnaJPLHHVr
         9JyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg2DqAZZA7NUeYoMG/mIoBrlDkmkiKzPDXrpowhxpJeuZrr5n7txaLYAMKVfmLv7L5cRmniYFy+w==@kvack.org
X-Gm-Message-State: AOJu0Yzy1z3/gLjisTmx/5vZuAor/BosDV6X4XHXAg3Vr9qNE4eMOgwd
	FjL8iIuwSSvr05zfpSaB1KnkG73BZM8zganq7NziAPp/D+x3zmDUVVwgxamiazPEpljpVX70vuk
	UXnRSjNMowctZeJwIzQ==
X-Received: from edxv16.prod.google.com ([2002:a05:6402:1750:b0:640:f53e:dd40])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1ed5:b0:659:408e:b7e6 with SMTP id 4fb4d7f45d1cf-65949ecd24emr3465734a12.29.1770288705209;
 Thu, 05 Feb 2026 02:51:45 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:28 +0000
In-Reply-To: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1866; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=7nNbabhQli00eKYXyBEya1GgL6seGPzs0VSa7Ef6UeU=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHY4GykYgqnAddZwhAJstuhv/o/aLQBkNGp9h
 QcRdesjbOWJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2OAAKCRAEWL7uWMY5
 Rq6YD/wKnkqeQiAcPzLSP8eM33RuuO4YudSw/EWJpzvDVL2FRsvqG+V2wVizffdP/6LYRWB/v6p
 Jqxwl3WBoPazV6eYFmbQ7WkUae/bNPfKpw2rRI+GxtPrA0EXUWSHDGB0bCp3kpDiWkIW9piV+jc
 zyAyp192j/gCxBD9q5VGxNqj3fglu4FV2cwElNzQIPs3nL+6cljxCnHhUAuzD1oSAYWZqAkuAsT
 MqEzlL5SSG2Rfiwbmhejf/KqCgG9blnH33kNdm3KehQq321SPc6PgGPT50jqjD3ay4+dmITJvnQ
 wOPK+VLCMD+OsMCS/P9DqxPhY7KXw6hQPtDyqRyI1jaGiHSj/7gj3OdnaZ3Bfux2anW+MdT5lRj
 ACUeamuoq1SUSCgNh2Vn7wSbZQMaYKsvyUfk6Mh/qK/OlkHOM/tVGClAsne/JWWu1WdhIy6UqrW
 rViiGmDhW/0oqW+hkQuWxEGoGRQWErMDsiWkA5VuMf/eh4LogZDWpEqKFr0ZQYv3G204RGVoRdR
 HzwRdgPSztNDiMJUf3XdQ8l4/BWYvULyzliWBh8Bav+Ia+fRIw8T84VjQJWazB68y1lXSTqSzVj
 YlhURKpOqlpm9XqDLSINCdFRkmGY0keD/CPIvSuvRKsQcd3rcnRoub0YtmTklMJCkMXUvre3Jze jjS185bhgckt4IQ==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
Subject: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D533180005
X-Stat-Signature: aw5n8huq74y83ze8o9pbtuk4pzzocr4k
X-Rspam-User: 
X-HE-Tag: 1770288706-594855
X-HE-Meta: U2FsdGVkX19Teqh1hi3EMk1hwcLpEPBL4tyaPP9i617cpHKyuOUZmtxStHHlDDyGZsO1Ki/2epeAEKfEi1EA8haB7ge2G7JjFgv8Huen4mTAP3DbJTjEhFu1XIR1A5RZjlhtq+JCZobzekm0udK1CAUGSoQTXkhizQwwpJQtr8nIq6ZQlNPm/vvXpe1rDgTQQnvyct5SEB2mYXv4jzqKnLGwMWBQIC5i/mxpfOsnft6j+ICUUHl+iRebugF9rd1sqUJlfGTg5mGu/OS+hdwFzojkTGNC7ZQWZrQyny1vuJBUMMa5m4Y/tqSC/hVfDsgWBynUFRdOWyl1fTH+4Og+e68lKNBp/raBrpWBta578vheatHhOhl6TpfrFV7yeXZG4RyVEvE5RXcbJwLWzMuTFQdo9690g6pR/Ys/upPJ2dIfU7pvQp5mY8EpSs21psc6Y+EzKLp4pwixI/vmxttm450Hf+tVC9r+/bPiTpMhE+Lxhsbr8ZvP+fnQ7FX9rNs6Z/O9PmGDsSNJ2wKOJrHVQHDg7rfiMXBtxOS/3jRYwpYsdo+LRieiphn2v9MnLTwPBvRoAVY6iu2AnQFL5BO6c8CvwwBKyVErhhFKmulFeQon6jr7OV7ozJeBGccpjWk3Gla9tch5NNMn2Z9ha1xpEVMYSMowiMsriXNMMHxqOygvqRXjc2j67MeJO0pAnnbybGiNweGZqXhbmKhAYqyxZh2JV+KKMDt6k2UW3VcVPCm6cmlP83QhU+tnqTphVcj3qiHj6Doe2rmrlnop49mCY0x09HZgq0bvlGhLauNOfRXN8avz0N+s/KN8q7hXG9mpJRPCdn+ypzeu0tbaghxwYEv0HWi3VkSfn5saJq2cM5pVOHWW5FXcpoUYpYeX2OcQecdkxE7VIDbwwbqwPXBnAyvd8BvNTQmgLrRQuHWe6OUQSsIcFzMDs5A4KtD4MB4bm0GEr612FM7XszhxBUC
 oMiHZ55w
 1W37EIVflg5uclIKz6hS/nNkqBcDAitPeEh6qbjL3HCJXOO3j0BhF+MBwBcbtcDzgBRRAVwyGmkewpBBpWvVA7kC970ZUAoLXHG49KXypvq+qwk1JBKZKLzc933/sUo5KeTHDR0gwGLEr3/+o6k3PN/yQdmgREfQe6+eVc+J3sA/hnWuBqkZTpmNNcSQw6/l21kKGT7EyqCaAyHRbZPQwkevY3n2GaBrIY8RVzuWyxIAE5zfHyl7YIuoNEqJdgSJmValnXkJEi5YaJWykLfo2J0/7OZIWKZVwyYZwIiNW0XrnbaoSXT2Rp78O4Zc9LZZ8W1aUwdexgejqM+KlcdZf/Gi3pe/Pu8QYr0+JRZGOtea29vatD8L+Rh8ULh/0thsV8WGVaIsS/n1WM5EMyIqMVnLNsp9ntoSaEN1hMV0WyRUBlWAoId7QMoY8siBjMWTyZb5Oc5Ifv/QSj0sOgUpIBBYvyEqM5zpPC4SbPS5gNpdlGaU9FO3u8AsOdd6RlSNDrPeg6IzctoKhfeQPfWDuKGh8eIF6d2K0TM2PZqdLkgAy3sVeNPbyn0UhkzfMap2YUKtWJRzhKSuL/HwDkKEZQuwBcV/BgkQIVGuEiNfPh84pLUeXB6aKYF3EzULXD/+qVSG1QsPfXIKV35FNn//D1mpWs5gx04ZUVe8/+8H+1/p0366a+51aploK3s7liuwpfTuh4gD7/MwxdrtPmvD8wkltPNsh57e3oraX8uoaJl9duWo+oX2bHQ9iAL8rusxii3Qq+vIqpVvYmTFTFdfWvDJxfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are the functions needed by Binder's shrinker.

Binder uses zap_page_range_single in the shrinker path to remove an
unused page from the mmap'd region. Note that pages are only removed
from the mmap'd region lazily when shrinker asks for it.

Binder uses list_lru_add/del to keep track of the shrinker lru list, and
it can't use _obj because the list head is not stored inline in the page
actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
head computes the nid of the wrong page.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 mm/list_lru.c | 2 ++
 mm/memory.c   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	unlock_list_lru(l, false);
 	return false;
 }
+EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
@@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 	unlock_list_lru(l, false);
 	return false;
 }
+EXPORT_SYMBOL_GPL(list_lru_del);
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 {
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 	zap_page_range_single_batched(&tlb, vma, address, size, details);
 	tlb_finish_mmu(&tlb);
 }
+EXPORT_SYMBOL(zap_page_range_single);
 
 /**
  * zap_vma_ptes - remove ptes mapping the vma

-- 
2.53.0.rc2.204.g2597b5adb4-goog


