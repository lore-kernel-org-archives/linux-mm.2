Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AD3C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB416B007B; Wed,  5 Aug 2026 10:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CEE6B0088; Wed,  5 Aug 2026 10:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BA06B008A; Wed,  5 Aug 2026 10:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CB36B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B98FC404CE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:28 +0000 (UTC)
X-FDA: 85067481576.21.9871A9A
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C14A180011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:42:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HIzzLjtp;
	spf=pass (imf06.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785940947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mCrelJAti2S/Rp6s22ZLk20Nrw4yj8Y/bW/BPR3eDNM=;
	b=XoQKuU4o+6OhN1XJKHF6e1OX/hM6Zlgibft4abQFkaRORjvv5HZZRdytsfq9/3a867uhhI
	sYZUJ600SgsmVi/7HTUSj7nNyLZliJHnjDEr8NkfWRwGZUC75s5vS0iwPzDGEyyVGuMbRV
	OLbTyVFpQeADRnjXslEGu6NV6eA9vpc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HIzzLjtp;
	spf=pass (imf06.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785940947;
	b=4tRS/dAakHtBmJntXqoqHP2AtPtctgrxpmlSjiLsqS/lCyzWoPsN+7gUHSIU+IbHHhn1Ak
	DNI2OCEEyWLJh4sM/Er1QBQ8nj19YSSzL4NsW3Pc96Qux88qVnE7KkK79ZAyzP56Vlrkax
	hQd33dGS8aaYnjtYT9p5uHf50akBiGg=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47de008b020so661853f8f.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785940945; x=1786545745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mCrelJAti2S/Rp6s22ZLk20Nrw4yj8Y/bW/BPR3eDNM=;
        b=HIzzLjtpSdRLzjLsKR91I8d8XwISjS+S8HHXPosbA1WB18oBuLdfBBE725xUhjXKWA
         G2epUVfO+hN3kkHhAIvNcVsUepkwpsGP98rtGW8A6yS+Zkzi9Qu8wMzJuOi2wXCVEI6X
         cniZylDU0dL84Xh1M/nwa9IVf5xGzEqNQYqruXI5pxXyW+wgYL2WBx46hADQL8Yvudzu
         LhwapMlqZO178ReINjvQnXXNr6JnB0Ze4Oy/Eghy/VSKmYl5mmSsQKaJqZsBmxqha7oi
         rFgHtWRzaQro1JtWu3EJ22wAgvt/HTDTPFYIiNAz2LMlk3+VdRi5gNq9e2hUVpSTbVQr
         789w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940945; x=1786545745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mCrelJAti2S/Rp6s22ZLk20Nrw4yj8Y/bW/BPR3eDNM=;
        b=fB0iBcUD9jwXQIgMZ5mGL6po+43KmRsPUz3x4szCg1jqMRpXtczDcUvTkmkK3Kdvlm
         M1eD/XywLLB+rswD5Dot0w5g4s21PDARgA12PT7B1ATnh1qyaZULtlpEel36zbUDt1WW
         QT/pCxHfsmpzbSoaMEohMxFXxGvcIc9y339rA9RIgF6zxV1gStvFDTJeq8FvQ4ekqXsX
         IcTNJiUhmdCLYWmVWBpn2X6MV1ZCRT8ztjM4yXAb+O9t35p2221PoiMEJSPn5ir6oFmg
         cGulurZyohCwpRpDI5Qe4cXMe+jQDkZcq3zkCedxV2YFAJWND376sAgrEcSi0EMwaxXE
         l+Uw==
X-Forwarded-Encrypted: i=1; AHgh+RoT7x33IVcabVwI8ueO4L8inZ8q011fbsJJFCmEE2WcYKybvCRZLTVN87krsSg+kKxjah6n2LXNlw==@kvack.org
X-Gm-Message-State: AOJu0YwOlZqcFKwuXFHrrR6inAJCreuospPaeeG4tZMTQNwGfTpnBefT
	ov0h0dUFS4KdPZ+hUH0EQ27vns5Qc+WwXlIVXICmgkX/paKkFyim02mo
X-Gm-Gg: AR+sD10jfM/fJ0HgLD3rHVTlWVrgGj7O8d7FPNrJ8xoWPWnQ+p7Uyk7MQDdP13S5ky+
	ZvJW1LJtGLzQ6lG4mgTaMG1xC1VimYBtcJQ2XIrtRQ8cfpiE4R3QkbGvvMTiJlIX0QsXVi8Dmtg
	UgBSUXVElJwkHGQABP3s+Nv4g+N1bG1NbDIqEjOHAVYXg5f3dy/ojgngoaNepFKqdo0LX25nGhu
	6B8r3raCLjq0AVWA1fqi3WSpJO9tfZQ21ukLtK8cE2dYru3DNTKCWMUeNVM44gNumn/d3JAc1Qh
	o4hsBXbKxYCYk0wgiMjqw6HGP9s7DPg+s8RE3kb5IOaIiuIIy0IbTrtY28aj1zHgmpZsrtNNRFj
	UONaymXtNuDlnZsPWeWq6ZU5ug2xaZ8d+/1ogCXkYinQlGtWHD0VrIlb+VZNCVs0NPBx8H+U6S8
	CQbRir2TfrzqzDe5Zk8Zaq53f3ox4tm/PG8p9rvPaCrCwHpzgMX8MbIigEc4D9T6NLTvch6zxsJ
	ITvHV2nl2nomeblSzlEMs4=
X-Received: by 2002:a05:6000:4a06:b0:47f:8603:a879 with SMTP id ffacd0b85a97d-47fec51a8f5mr12905406f8f.11.1785940945311;
        Wed, 05 Aug 2026 07:42:25 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:6df7:ffe8:d01:255d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232333sm10094289f8f.18.2026.08.05.07.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:42:24 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2 0/3] mm: improve insert_pages() error handling
Date: Wed,  5 Aug 2026 17:42:16 +0300
Message-ID: <cover.1785847364.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C14A180011
X-Stat-Signature: coxgfmice6xn9armxfbdi51pgit4qazy
X-HE-Tag: 1785940946-662357
X-HE-Meta: U2FsdGVkX1+ws2JXhyY57PXzIPD7LvqgUgOky6ZbFaimPJcsYL6Rm4E/XZqsHU1XL8J0fqVGS/4/SfCuAqcn7gEkPPhjbGSk8DBjZ/g0v5x5jqYcr+oV8Q+BidJlKkK8j8mMxhjGlN9dgu8kYWGOkaJo6LbHUZq/EoQuqFwc4wwKRqIWfpKCXdErUScXSBZLjA9hBRJwaRngbXt7Qh+IZV9F0G5ibVPCVJkEsm3MVFP35W7MbFuPOe93s8ZutPi5crphyIrzGFRolQY736nuEn2yfaQBaxUPhAyHD2/JxPdxqNWJet7GTVbEeh0TXTJkVg2Lok9mRqBxKPgfOqhUDdOzvWYg49P8u86EOIk7zyU+2rszzOFMRNtROUg6zHnAWHCgV9zbOn88voC5INvloY4Tb35tNPq4hZF5H3i5j1lv4/vcthoL61Dh/vwliLjH7FnZjrdTD/Mr7r/yEnpp1VyPCtpVBep3/83FODaZfyuTtDZbkkZWhuUz1DkrMVZXtem9ivngIebA4cb+pBhTBRmjd47bOFZQTwUGcGzTTpuzc7+1/AyuxgtbQZ8aWxLBO4y+6rcGdTiOII9Sft3pENf3rozc6Ahv9F2CXRfOTizoNpJvChCFAooWk3DB/80V4+zNTxP7X2fHgB7x9l8HgY12N7G0WYGrJQC438k7cZ+UpTEhX5JD0LZwVn+BN+n2Xm33RA/n28RzNLWFmHInIgzFCdYDfEEOV4zOV3ZObLiNCYO8lsSh4LRibRmzQqiz2Gn/bZldns8DVZqLLk4eJzVTq2h6wlcY72wIuS3Kj/PCSFTNtaU4NmQwZl8IbhbtFtnY7GLMbduhoxUUhk/auHFp44a6p0RyTCCadliC/Ff3HejBMAgh6lhZHtYvtzcxS0HVpUS5to9Vb8m75MweZAlBW15Ff7bopH01dPPN2Me7vvkg1o8Jh7httxKXtr4/V5bb5UTxLwE5BZQT0tQ
 m/VMhF4G
 z0KW8eYPE4+PnHJgqJXD2IDLSlc4AS5zDpHQT21Y/MGT1XT4ZwOUt2CgwvDnxWj1+Mauh2vm0sR+n/Szs0Q3rsiUsfokeVth0VEHw1RReZaavzA591sROTZVJLAiAt59jDdMOt4iLryTO905+N4HGx4bfXT9WhUQyrXgDQguF1LsUSxficA3OgX1UYAO2XfaBZnR9qykZ2Br9y1fQH7QWrslwvFPITPqiKrGysSNkxbunTZCRUgu3P0LNGJ0AtSzn9aVYISboHddwiV/RK4vRdLAYt72yutFKTPSr4nE+24yAfLnvvS9CQ+0d+A3Rx6AE6XcGthOeXXu++j0hdW7pqfV2lRqRBCciVbqKfNck0d0MppmihuKbSVI6UEfmKlxZCGXAxVtMIAHlnH7gIXSA87b0XkVULsO2yXcB7U4EWYrmwdnnoBsYjqsJxrzLRrHQKPOUXy/eIVrEsPG7m02a/gbtPgl5Byjf0O+EySdIw+e71V50wl42+WadvwLTs2ZFkxf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve insert_pages() error handling following review of the minor
cleanup in v1.

Rename the helper that populates the upper page-table levels, set error
codes at their points of failure, and return -ENOMEM when that
population fails.

Thanks for the review. I'm new to Linux; most of my previous upstream
work has been on NASA cFS and RTEMS.

I agree that initializing the return value to zero and assigning each
relevant error code at its failure site is clearer and more idiomatic.
The second (middle) patch implements that cleanup.

The pte_alloc() macro returns a boolean, so patch 2 tests it and assigns
-ENOMEM explicitly rather than using its return value as an error code.

Changes in v2:

* rename walk_to_pmd() to populate_to_pmd()
* set error codes at their points of failure and rename ret to err
* split the cleanup and return-code change into separate patches
* drop the Fixes tag because this is a general cleanup

Avi Weiss (3):
  mm/memory.c: rename walk_to_pmd() to populate_to_pmd()
  mm/memory.c: simplify error handling in insert_pages()
  mm: return -ENOMEM for page-table allocation failure in insert_pages()

 mm/memory.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)


base-commit: 848acc8ffe1b7cd5f1bf427b93069becfebc2c9d
-- 
2.43.0


