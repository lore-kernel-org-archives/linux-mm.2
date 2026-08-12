Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F203C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71F36B00CF; Wed, 12 Aug 2026 06:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49F66B00D0; Wed, 12 Aug 2026 06:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F676B00D1; Wed, 12 Aug 2026 06:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867656B00CF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:40:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BE3B1A0288
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:14 +0000 (UTC)
X-FDA: 85092272748.22.44422B7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4204FC000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EJ8s9Wd3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
	b=5MTFbkhiiq5UjvsODmSC8Fu7AgmGRpIaDCMUMu7sELwBNQno3HxaxKTJabMRb4oJT3xFw4
	L67hqHgpfEdAeNrYSywQTWflf19NIiBK94FqTfupIXjQqbEwQ2HYMq+vvBTCZ2a1TWoJ5a
	0Yxv/OIO33cdndzXdXEvLEnKuaS1xhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EJ8s9Wd3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531212;
	b=zMyeezJUVbr+2Ca36fIJaC7iobMpsU+UvXr3gwFNTNJa2Rc2IVbg+DnKtFmlBtqRST7PJ/
	Aq5PkiMlkNaAzyctVWH5pLnMcXukJO45D2YyvlOqNohOmOyxKdTaFPsbkuMCnd6C3o0HuY
	FzDvo1kNEuvar98R1jWLG7/yR/YTy8Q=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d049069377so8522675ad.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786531211; x=1787136011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=EJ8s9Wd3qkETBB1gEuqvttGKKQkAx020euiPITNLO8BRzlOiUm5j4E+HsCew8+AOoj
         6K533/l42WAo9iMuwqf00q35PmOn80k6uWj43cqABPV6RxltPPBAVRFJOsGpkJZsKXHo
         DIXmI4JqXIp4JsJW1Uxe4l7MktHWfnxZa+vUPbJIHYMV+tBf9gPU6mYU2Gea+j3PqDBU
         Qh2IdKfSaJ7sciwNAjFGs0g15+Awft8QEbSbGlB1BH8jkO9YsCPn0jlCnyoejH6YntEL
         qKwrO5eJjcfao3mnk/5+wx9lraFl0FtnODZ7Zv7VNJ13fAF0uCuTWXpaG/vqQyo5tY5w
         hy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786531211; x=1787136011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JxZo8B7n4c14lfP0ZG1amHyFP5yaEQUN0LvXnBt5yBg=;
        b=cPu9lH5W0xleDgtxVh6d8V9vxddQK0pilT54wJTbxLYHzd62mVZMbdyaB1O7vEI8Qk
         1PF+zP3N6DKFL1k5WtjsDKYy4yjSlgkOS0wMl7wWxX4FkkQTtP3cLxBURiFOKK2QUOO1
         oZmc19aw3qsR+upN+gvtshsbTUqO/8edRTRISaTEZfRnNIJfogwHbIgPNWj3EFHc24qD
         yiNrACrfAiMfgwDbGuqnhNIdzxlrkUs0JrzPZSCBAgK/nMoTBwnRqncpR4TAS231UqrM
         OeCOu8cuo836FsrjBYRYt6JHbxpOnSg3pfBfpwY1ftdXllYLRULHVBuDznlZSTVzC5uM
         RmJw==
X-Forwarded-Encrypted: i=1; AHgh+RqyPNHc3mTXfFVBP453xD1155JsiYt73R+8Njvs0r/4lb2ggWiApjDZojxrHNUe3Yh23BENS+T+cQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+blikHSgi6SnBiZaY/n03PLOYsklb70DxM6BAcc0y9Y6W/FI5
	B/l2eKwHuHMF40u5xQyZaj8g+0FBEpOZ81BN6X6KXK6FRNfXk7nXqLvE
X-Gm-Gg: AR+sD11KCKaf+SbyLwFNC6/x+eH3WtEM46PFUUSdKd2Y/wUSt4XZE7L676BOA4p6svX
	vTDYbyd2uW987FpPJoolVA/w5x9xgc2bOfNab45ZgAYGX2Zq5OxRxgnE3XKzYUs6oNnZ6TCgQ30
	K0k68jdOKCdwl3A1ADW+Y8ioi6ba7OC7t8ARSuSaT6Zs8sXWluW+VFqqDkt8ZAsGkCCEn+mZEpf
	YN7V2nx+je2+S3awQ1TMORzsRbiIN6nCrt8jlYsm5WLDGNUfunN4JtlPqHnea3aWCccHa8s/X7x
	Stf2hLAk51l9Jrmsp7RGDgjZmNiH1/FxeQzrFgBQoj0C9WkzYGlcPqFgF14KqVuYmGU5cXwjW4q
	qoDuA6O1zFCyxyYmBTh+5s9hf+efyAsDw9OpSES57jvyJxN0b6okpTMoxtRgqogSmsxeEjYxi7A
	8mGpOEXGvqFbwhQgj6aanCg5T2nRB/J/wv84f2ziuu1IyN3Gx8iscJCexIYkUHUSa36DWv/EFnP
	wkzAKocR1Pc36E=
X-Received: by 2002:a17:90b:3948:b0:383:f52b:d616 with SMTP id 98e67ed59e1d1-393014fa36emr4204547a91.10.1786531211043;
        Wed, 12 Aug 2026 03:40:11 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3d0b432sm9931990eec.8.2026.08.12.03.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:40:10 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 2/3] docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Wed, 12 Aug 2026 18:40:01 +0800
Message-ID: <20260812104002.15225-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812104002.15225-1-aethernet65535@gmail.com>
References: <20260812104002.15225-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3rkkfd83hnygsjw19kcqg9h5um7bi3rp
X-Rspamd-Queue-Id: 4204FC000B
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786531212-822546
X-HE-Meta: U2FsdGVkX1+c8o1oMRp0wDMjfUqztTpLL/MjvWUPlnFyUMd23Efnkc5aPs8k4M8XBR+ZDeVdi8pbomWc4bQ0qbMV7KzebQ2XOmlLYGYt0YzqotxTRxQ2czPeGDzExsfoG1/aYIa8bdJMfXFl8rNjDV7xJvpsIWAhi0WZAg8StAJxKQK+98+pYdaqwuDY0A/2d9wql5CIbwFZlxOpIXF1fO+HEmznxSJN5Ui/3/8HjGojCH4mm7Pb0XNx16NlkZVQTecYvgrHtVgPQopdEseysMO987Na0rE5gRmzfWkH1EVv+oFYjNeWZkHcjlHllp0P9rHeKbociNI+aBfoBUj/JD+N+a9fnMMPuvMBIJagAPRNOYwdlmUBZBTETQ8aU0ij2oQb9rCA9sttwgKCP2Wq6syF+c/Y46SfOjDiq9Ec8szHvaRgq8lse/u0A0lLi+umuXmb+GySPGfHrZUOSdHOKdq96zWZH10u1VZqZNGNf6itvk5TCzVsXX5ALi9MhDtyZAy5u+cx3h+W0G/AHzVVCWWNFiAFEw2xeMlbrP7F2+WHv6/YvGuFgOe2CIHlbKI9gcmfqt/Bgj1Sl6gmtu2FcCD0OPMndtrNrk/bDfENknnXaj8tbcirCpVeCCCHsG9+NWSCDQPxO7kvZQFpoRd+79ViPDaFykHaAyDyo3juJl8LSUJIeQtlg7uNoos19BEbVKv3XBew5EMoQLF/IFbIlWGe+DHzIND1CPm8ls2LR1DKsDzxvmvQWAMECo19xJfbL8mVDflvKsNJCw0/yrjf/oVmcjXembxs+L45Snib48HhYoeHGBEIJXrwQES6rP8zsWDpjDRqMcEJ8MC8xuilWESMQeu+oVTAGhod8jD5tG9S+/clbB2NTYhmDZ1yIHVyaMnjq4cNgw5685zlHLZt+05H5j6TokY5Dk+IiwTTvXfV6qmjKZ1y20pCNMdLMKHHv0/Q8MBiDYo7RepMCxB
 k7PBwieZ
 tdGVmklZp43lw2prX+zUzzwRt63E2Ape9GiJ7fJufwAJycWZSPg8O34SWCAWnSnWROkFDBIzaayxmYBLHyF078kSsqgSdEyY9YPXw//ea/M/ig2E1Vg4275olu7C5DVLn1BpAGlFZvzvKUxF9mtOohVwD2Rjd2LqMInjUPbvpcPMy5LAHRIrdnvaM8ZcYm1zRvsn55a5AHyPgG9u2/PhEYbWRckpjAMF+8yoMcevaXV9FudQeY+Ww6v1h198OEcheejESBSONKXKNQKXBfdw+9bRxmuMl+5kcH3ovtdGiK7FXscF/58m4B9/hUGJD14tkxPOCxEs9ltS3m4xkf9DiqpmR0roloDK+FBy7Yw4lz8bRokpblx3aQaLytOe6FthlXCAKKVNYJdtbPUtWEt9COeLOpBNW3Go5w3uNR0rQPJBXFu61LB+qAkUFOryLUo85paHyERh5b3SQzYvHye68QkUcuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 939298f2a9b9..1fcf0b8c044b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -872,7 +872,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
-- 
2.55.0


