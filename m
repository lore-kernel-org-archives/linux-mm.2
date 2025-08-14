Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D37CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F148C900109; Thu, 14 Aug 2025 03:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EECEF900088; Thu, 14 Aug 2025 03:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28E8900109; Thu, 14 Aug 2025 03:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34B6900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:55:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B5F7BA207
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:55:20 +0000 (UTC)
X-FDA: 83774602800.16.13894B0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8F3F7C0006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:55:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kytYbp93;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3ZJadaAkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZJadaAkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755158118; a=rsa-sha256;
	cv=none;
	b=ZVBb5kuQXuCvRW50+27p4WexlWaPrq+0lev5Ec3NgwdfKBM6WRg+vDpaQerYl88P0z4QDr
	73ibifVTAbA4KD3VoUbY8DDIgx+ZKeqTzeg5+9+w7eeHFZM/5q2PZiPXf4dqUF611+8xLp
	JBMtu83mECOCvxfGUynoJRxrm6Za9VU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kytYbp93;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3ZJadaAkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ZJadaAkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755158118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pkt9ozF4HjNo8N7YGJsDJbGhL2IzfusvyUWTBzPyf7M=;
	b=TFyK2k/3Bl2+hm6eMkaXiO0PE915OFB0Zam80q5qAO/Jh8svU+liX/FRykZ94eGtk0TMHc
	ZJCJc9wmz6GxxbGFINEQZUYTkEM2kM2aZ/cI1dILE3VNrBAGo0WN0+kx/7hv0Hb0XOpUC8
	AEh/l5KdMb2bZN5arcJ4hA7+R8NjEOE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso2136835e9.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755158117; x=1755762917; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pkt9ozF4HjNo8N7YGJsDJbGhL2IzfusvyUWTBzPyf7M=;
        b=kytYbp937TQQqynHRzMCRZgw+hysNCLCfrXluzepBkHzNaCUu1MZYmIbAgI1hLNUnu
         4KhOlPopvi9pMA9t5Vfk8jhC/boX7cRFHrFJ4Dhk38UL+5Jef9IprBXIceELeNWKQMX8
         pZbVmaooqXIyl3Ts6EeSekJf4Jf/P/5lEzX8384ILPWOrlA3bbfSdfZyFd0YARbGQeHa
         V70GTsdYOlHrDzVH1iEIvMGpLekRRIex2jwxoIznXl1gnM9eYUNi1y7GDIOeWqNOgSIu
         9JgTzNmQxoQs5fG7quCUocWqw8Vy+atU/e5rXbkAWEZ5sb2vBVt4DUdgIkl4Eq4rP0sJ
         MJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755158117; x=1755762917;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkt9ozF4HjNo8N7YGJsDJbGhL2IzfusvyUWTBzPyf7M=;
        b=SNwNem06vZ+/kMo/yA/GMo+HblaKvGOX01C6UOQDcrTtZ0KXvHzOnvnCMRpi4bcxlw
         CCgP8CDU5H4yd8yVBZjAbEBiEthBoDOEeiPL6Kur0xnRdofWqmYB4jqta1fT8uRQi4WC
         r9DezSqNUZj8SFwsMwwnCAJcrdF3/LQNCO1WUdYbn8B13fe8tvxpm+GhlOlc7RqFA7Ss
         YknejfUTvmWyg0r17B9AyNqlTnIjLLEg5ExUfWtNDyp1wWEBDEQPj5/TxaFkt//t5bWP
         u1v3U3N6YC/g6yKQR+cGV+tA0Dok9UlESdPh9yBR6DtnFKrAzMIhbOSVcgy2hWfNXbEx
         ceHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlsDnAKg0jwAlv35Vm0g7WRHPGrc8AsRWATay/Zouu+ekQ9gw5cXo1OrsPwOPt+nZPXCuaaCtHIw==@kvack.org
X-Gm-Message-State: AOJu0Yw6QYP7JfT2UvovDrhYQHeahL/2krPsrHZxd33XhJ/nNybeRO+O
	DpIH/KAlC6+tjceXvRXAkdPxJqOlWj/wcJR2+kE3OwuVKnIpkgGNJfOjDUuXFrjVNU5Aw03YnCx
	X5adtV/65mZ9qExQlGw==
X-Google-Smtp-Source: AGHT+IEwXLvyCAoWDtNfNW5WIiz6Y+KDZTy2eN5q6Eu1bB6BXaaznui8SXDAth8yHInJovhcWZQN9Sn9q2E2DRU=
X-Received: from wmbem15.prod.google.com ([2002:a05:600c:820f:b0:451:d768:b11d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d16:b0:459:94a7:220f with SMTP id 5b1f17b1804b1-45a1b6577f9mr12470205e9.26.1755158116883;
 Thu, 14 Aug 2025 00:55:16 -0700 (PDT)
Date: Thu, 14 Aug 2025 07:54:54 +0000
Mime-Version: 1.0
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1090; i=aliceryhl@google.com;
 h=from:subject; bh=VMoY9uH+QCsljh5aA/42PVLV0HoLhQc+LEs/AXP4pXo=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBonZXTyaGB12UQz+He5R88gG56onLNWGp1jIqZ1
 vmC6SORLquJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaJ2V0wAKCRAEWL7uWMY5
 RmxKD/9XTAtpkY0tqkvQ/KI118GdnayeBzkBm3Ju8ZviwzKu1pt+Tj6C1oq7NXbmw4VPt2/JwEr
 +R97IGMF5xudWN38Ee9hYouRwVKyE4412lVzr9KrDd0L59UpOvfYViUFV2Jt8pZynbJUUdDeVu4
 NJ7AQJguuboQVezTI72dlooiVSoEqQgjqlTI5695l8FS31ddO7IBRt1gd3402n3emVpGjNUq7FD
 QJz4++Wa2QsJ2SK8w9beudiWP1zXoFtJFQqQJp7eYVbFCtYi044prekxwkOpZayKSOa6YU6WfCq
 dtSPrqA9zQESg+HbayhaPci7lGtJyGIqO70/gLuGesr5Ql440rigeOD8lO9OXkVLGw7+q5tAZWi
 M1PQffntwdm6EQBR+fS437Z6Fu+wD6hXnDjJDpv/r/0DN22z0WH2Vd4+VP5qnsM3GQcl+GitSXo
 gvbx3C/SuktLE7U1OMFFY9X9fzmV+lwi9ToMuL6OkwGpHYyX41TuoftVpF+qhDcqfoSXKAA2SI4
 O54FedWn8jTp8GeasAV/pVgFAC/aklaQ5CBrmWyaZ4GH7kBSBzC9EEMz41LXZK/0jCJ4DamiqAh
 guRlN8WW7goErG1vaOvwNELh0WlekDFeb8MoU4WRMBtLwLYLaqie52aaITPoleWWXJoept+Lbc7 83Xlpn3nO+wY5Hg==
X-Mailer: git-send-email 2.51.0.rc0.215.g125493bb4a-goog
Message-ID: <20250814075454.1596482-1-aliceryhl@google.com>
Subject: [PATCH] mm: rust: add page.rs to MEMORY MANAGEMENT - RUST
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Danilo Krummrich <dakr@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F3F7C0006
X-Stat-Signature: ajhbr4zo4hoexd8moynak4df7tmyaqgw
X-HE-Tag: 1755158118-527073
X-HE-Meta: U2FsdGVkX1+0tisQZdS8EPCxVfBawPPXk1mzDbhJ+RMaElaMe8fDeEoiZHFGuzRJbI0OLxqyOS0GfwsTVCpfn/WzXA+/WMm2CORExDMbJJZloLw+lagr7lSIiDKfD7CtsUm/DpAZJ+H8AlR5nMV89SWmK133R6J1NGAGXkF3Gk3fkLtBPFe+tH+MuQ0bL1zPXW3fVL/QXeFdCXUDPiPseL+dpyLYt04+A60wWtGhhPOWmn31d2mvtuRVgRmyfLMIrO/eyCesKOkLPBHGScon1dwqq0jK8Y1OR6Yfu2ZlsFZKX35Sw6xHwJeLJaDZ1/V/NaqO1ActIDjXVTGTtCYoUwMd7LxacdPCAEgIqGch9SC2jtaKgr0gjlgzPcsICa7MYMyrhQdWLjzKBjsUu9KdKdRFJjwVzFRNCKX8lziUZMY1o4yeIDT171QGIRQEmOKN1pfENv81rJCg5GQl5kGCAxvjbJP3nw+3Mzumka9ZLUwg4Qk7UMLyZtNfuK3r1oIfSs0pZVlLh6rsOAdhXTkH2X9VBx8yJ7S5lit1kHiDrKnu8ZWch9ap8fyT7gtA1mjje6aOVFCJqLc0e/HJJPyaxWJ/nfUdkpQ9b4+YwT5nhV3Ln8ixdjrJALrbpY17FHG2K9xtMYvgZG7r1zrYo7uIRlWTz9FKJBmRgb0TCmopXHocd9eR2Ego3ik8jGuUK7rzaJoH9hJBjSsQPr0P1dDHx85J3xr1UKYHgo4PJ+aYkvKMPBc0I4uyOMTt84T8zGyq3SKujw1g57mY6pB6tRiIRk1asYfBW80UfRaqKUmYV+PszqnYJhEFavehVBlvfnIQ+NhFb3ospy+cK7AUrdAXRioPHFWalBDIoAiDy8LfZwIRE224gNpxqUTGL66JWfQkOyJ5bDAY52g8jf9JKO3HFHQC5+MIz7/U2TaO9b9NpRDPnZV9QelEQNhtnurQlPU1CRNX0jYk7qPP65gUVkL
 DT0KDj3H
 KXBZ8yfQwDIEE5TVP7dqc+muN1csHiYrSSp23jrnYBEQK5WdIbkO+UOQ9R69NmEzkRYN7EYUagyB1M4S8Mp12F+6blynilX3qt8gJ/8Epoj5/nXPu5F6wowAs+agDyc9oom0yzho277XOYQuV0BE5NDY44JT8VTPx3Su2eoEQNuc6gNvlhzWA/f4uX3h2T3fjSkQNBEsgMvUz1NwfC2kHnX2rWfZAkhpNf8DfEaPREW5NQKRTx6nuwgTsbKYfRL2iwS30QHqzAx8KHNLS5dcYSMqcHs+i937+wrGqaPjED14yYJ0+rtPl4FQhYs6vplA70xPQI8uRj/W4tAa5pZAPc/QeWAD/P/33muJ6IvOQDKdtCY5xujtTUdw9yTO/BT5EIKcozP4iWgeBTEoD+cylKmn6N8OJf3AnbuOWRucqEbvrcm5wNm0LBHr26bF8Fewd/aN08A/KCQgrTcNtyX4f5/gqaso7e8vPc2heCZRnMypHqJvW12GVXjHf7quVnEOe6VYpMqu8+peozaib50zqzoV5qVBzNgvqnAEG1Ub1OhdcOgKBR0aObL+RbIxDC4ytZ3gAkwAUp/5gp6A9MFFCUWxbYNhLbf2ATqIgO0iLOi2cYZvJxzbcWBtdcrKtP1C7dWuyU6tB2DZ8SwyZEig4rlt+u2RfB5lQ/4QVtx6VUrGPPZ8gN3DUW3DCuDyrqv667yce7LU3sj1/T2aR7eytNoKyWNXbKmLy174aate/bYWBOblsYh4ArBS9oltsBmIMGsy2GNAk7vuw5iQohNg0WYkulOck5fG/S74K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page.rs file currently isn't included anywhere, and I think it's a
good fit for the MEMORY MANAGEMENT - RUST entry. The file was originally
added for use by Rust Binder, but I believe there is also work to use it
in the upcoming scatterlist abstractions.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..45f7a21dafd4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16244,15 +16244,17 @@ S:	Maintained
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	rust/helpers/mm.c
+F:	rust/helpers/page.c
 F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
+F:	rust/kernel/page.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-- 
2.51.0.rc0.215.g125493bb4a-goog


