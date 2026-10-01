Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFC4CA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224656B008C; Wed, 30 Sep 2026 20:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4DE6B0092; Wed, 30 Sep 2026 20:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073F26B0095; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BACD36B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40D9A16029C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:45 +0000 (UTC)
X-FDA: 85272244890.30.7057AB6
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 821F140005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oHoG9BPu;
	spf=pass (imf27.hostedemail.com: domain of 3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjMDzPbxoDZc0HcBqdKOJdHnNAywAZ6wV/0yHIoux9E=;
	b=0qquMGl9v/ogbDMxjU+3hiWrwqQobpEkMPQjTvGtNfCoZQWj2a+U/IWoPyrK+qPXwR9GE+
	t20ue3SB1M2xyTjGF+IQ6cL9RbRo7pxLS9ze5RJONban4mRKkGB3L+LMIzjv5rT3J1MaAj
	qh8J7T3UWZdkRqpxvdkgaJDieT38VbM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oHoG9BPu;
	spf=pass (imf27.hostedemail.com: domain of 3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3BrC9aggKCLkrjgZvZiZfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816263;
	b=VngCzoaEVQXMYd5olia2bNOGPhA/xsKb4p/+Z0TVvOXhFXrP8hLfTlk3UvXXI8RWDJgg0h
	wmAayWP03iozWzZrOTNsEvFq2dRM6WBQLdDwdvIgozrSTbOzTeY40v9TP2ioEyccYYQE4L
	maic7Oih88Qz7wh6KPCgFwGuB/LVKmQ=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e2d4a8623bso17428905ad.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816262; x=1791421062; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WjMDzPbxoDZc0HcBqdKOJdHnNAywAZ6wV/0yHIoux9E=;
        b=oHoG9BPukvkmcsk5cGFl3MQTGNGmKvtClD94KNS/wyWyign2ZRW61Z9OmAJki51RrF
         H4sHQkrpDOmGbWOYq4fvIHNeJwbxw6VO3bdiETe0cCkibNXZugGpWxtBDUK/jJh/VW+6
         5oa9wqaUfqjsbZUJrol3gAEGuQS/wIj8rkKixUyyVuq5ast9i4B0NPC9fvkU4r663a/0
         dGIbfEytlscTT5xRjTbNOtb6hZAYzo8WqBtu/M3Gc5n+u25fIh9fbV8hDu8mzyIDbF4y
         XfslPaChzjB7ADjETQX9gBBY7Q4IOe0dQF/ugKReci9jg8d9YrqXIOsyLVf9/WyvDcRO
         qCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816262; x=1791421062;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WjMDzPbxoDZc0HcBqdKOJdHnNAywAZ6wV/0yHIoux9E=;
        b=iO6aJ/y0Y5A+AAWMt3nU3zwwAMf1EfRBqx34sRtvyqD8Kmh1fzbxTw0woSB48l7/vD
         S1nqQ5lG+hzI6wRTJDjOGu2MQsnHpZQDJWbuucSz4FWYMywQ8k7+PBWmRJUAUcKuCgd+
         +7eKyA+SKdwH+dZjuxxpF8owzbwww5qtauAdnZ79A4WoEV1CLOjomAnwuYI6IUBb45Xz
         dZOcazwtsu6/PQVcZMISse94UylJ7drQx6Lxv4h0+p0oetR64u+7ns4LwAywq30f1aPl
         ls4NnhvsBj5sT9ry04/Uaw74O+YUjnuo/6Lb/JesDNCEXdu5jKT7f+ovDPGQS+fVTE9J
         P7hg==
X-Forwarded-Encrypted: i=1; AKwUvBzyQ0IZ/8zAuzYG7RPp1QekEtGsz9sHwfTbppY+EU9gOATsoQXbYjjgv7GgQeU/9fQLVk3HxWMnDw==@kvack.org
X-Gm-Message-State: AFq9FYLa/ygfOIXNXQhB1vVx+pugCG5LeizkOyQeCu3gj9fRePvNq/aZ
	m6Gf9oqvfPS4s72kjO3mFzdEZvNrs08KjGXoES8sWbODtvEdkwz+FlMghcknWwVQJNyVR9iCXXE
	lHFaIGeaCfV3Z3A==
X-Received: from plcr5.prod.google.com ([2002:a17:903:145:b0:2e1:324e:b311])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:8cd:b0:2df:7e40:6f6c with SMTP id d9443c01a7336-2e2e49f818dmr25929285ad.46.1790816262111;
 Wed, 30 Sep 2026 17:57:42 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:30 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-3-skhawaja@google.com>
Subject: [RFC PATCH 2/6] mm/memfd_luo: Set Liveupdate level of a memfd file handler
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 821F140005
X-Rspam-User: 
X-Stat-Signature: eo4scya63r7h6gn6yzwbhkpjayemn4hg
X-HE-Tag: 1790816263-956979
X-HE-Meta: U2FsdGVkX18KQ6NSaFqL8zgvXPxVycohliW4VPhvPem0FADZIIMriCejAfBXmAlKKgxZySGeAhPiD3SE3+7XE1DA9z298bF9trfZSVOcbN5u0tXm22zHvZDANNHQnLgYouuHwvy9MUSsYcZlzc5hSvBzuiSAd35iqrT0SyQnvy5HsmhggTknFV8OxXlnyXU7hB3LF2b9oDaFItbZBA8zSPuQZh3zDZJnT7cpvSXEG2Awe+KWQ+uzVEF8gCWWwR7D5aP/izYAJSa6pKPa8Mc5u+AndIAa7CDiLxM63Neb3JGmoxzGypXr5O5ie0S+Wn4ErNZnQp32Qnv8SyDkmagIv6ZyZKwlfgO5F8IGexV/IzO0EPWoXbi/eeC7NKOq3We8dgqvB7q+l1+WAkbMJwfW5VCL3nAC7w/wuhaUboqySv5AsaX6hefYOkcv3CVv8fp6vqjVI6jWRbDmXZSNv9swT9zG3axm9DeX+cNj5OFp8sSE/vsRTkYfEYdevEtf/iW3lrMMWpbp8QR20q6sFpe0QyDfukGpDWyGHuG4JxQKaCrg3iQMd5cGbXAD/GIjj0t+SkptPaUx8H7FgdybV3+ASAJG6TC61p5l9pS7xoLT0RF73xptBwmmnuycYJAsFmvj3bA3nTeSkV96pw39FOblioJ3EvyxK+lm/VUH6XUaHlpn0AyXP8NoFbdLzcGMmu5QYloYbzu4Oxu6q84WUWY1PuP3XB1l5LTwC0aI/IeIe0yzCWUldJL5/Qfou0Q9IDNZMh8/5H52aCxROnXa0r25D25eZevtAta97p78j2Q8yTkyK/D9blbZ1LypmkwhLd3LDMcGUQPrS847rCf9OuD+NSsqy06NcszuYAm/6+k/hGlrdeMwlMZwcS3X0ZbaIYcJftUfuLZBcts/ZXaKsbJ/92sjDHDHr4Ol8u1xSI/Z4sQJJz0pOfcxK1uclq+Qk4hM8c3EWbpJdAeFoXMSF2q
 TBHQ5avL
 k6lKoLVSf5DvtEiYXe+3svGtrbOou3luxhVapoaLelhkp33Aw2m4mUr7kIVmysJmMYp94hWHO9SARczfyOlgK24iyK1BQkLKvlrvxiEUXL7Vk1e5t+EBxmP8aTDzNBhI4PvJA1DtGZdsp2/q2MmRZWEwTCLdyy0azd/f2V97+l9kdZYteXIlohLhhvlTNnsGD7EEOUEf7SOIQt/z0+J2B53KMsQJTBiBNJcVGkVfyCP2mUsd65Moik40ZRyYeAKIO2BbWtPNY2QvwD/qAk+nDSLQpVNRolE0QyT6536Naa5KGZUd5N58nqBMmzJn0djPQNmNgJsjQlCqeH1RKXX+bQCx63I0YKcGGid+MThctBFVcthpV4s5vWYm974+ynuOPKZaLeWGxbMaWPqt1dItGGULkW1oq/7WFGmiCkUb6d9+5Sjg3v5W9jAASWBfNRnBW+TZq4WPPrLrTKn6c8ioPZSX8NiIlt/Zm5hmmNoGY9PTXACVSiHvwx0Vqevcsbc0/0ak4LgVRXNs1xwoikP4sXXCXFnkzigGDMdNaPVJwFr3FVV4BQqjdRcxDnB8WaBuu2F+urRLIHq26kz1GubqaBTqnvENMrkonNKrvprWWyrQY5Ap6yznFy/oCiLx4jxGcqmkQR25kJpD9+aY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set level of the memfd file handler to LIVEUPDATE_LEVEL_MEM as it is a
memory provider.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 mm/memfd_luo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..91ddd7ae64b3 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -604,6 +604,7 @@ static const struct liveupdate_file_ops memfd_luo_file_ops = {
 static struct liveupdate_file_handler memfd_luo_handler = {
 	.ops = &memfd_luo_file_ops,
 	.compatible = MEMFD_LUO_FH_COMPATIBLE,
+	.level = LIVEUPDATE_LEVEL_MEM,
 };
 
 static int __init memfd_luo_init(void)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


