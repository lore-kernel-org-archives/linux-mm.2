Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F2AC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64536B009D; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0006B009E; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9193C6B009F; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 656F16B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E386A80446
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:11 +0000 (UTC)
X-FDA: 85216241502.20.BAE9E72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4E0E140012
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cR7JWe2z;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	b=YsZY40iE+PPVvF8KVNcGTJODHUPcLaB5PmkcCLqRhqK7oTZryFKDXDtpF+nnqUUegba5bQ
	qGMkTJXz/xQOgPYXrxdf12qTEp1jCBQ7iUnPHGi+llPzNDKaRjZYFIGIA3qJPG0eyOmMzj
	uMhraPkQVU2aRYktL2hx3GVmOvVZt+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482850;
	b=Z6gDFGf4IIcb5hSxR3mNW9X6CzEzHlx8kPQW+UgiRCY7NtZ28saubpDE4pCHMsK1lQTzlh
	RFR9jMsmmYIVEq5BRGRjP1bHh6nJ+DBaiq4rHWip8K3VPYcQyJfPIA+R8EAPUub0s4G/cJ
	kz7vUIkbPh2uma7oiO+dXngvw8Lf9Ng=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cR7JWe2z;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 890004400D;
	Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4BA1F000FF;
	Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482849;
	bh=KlTkThYMNDC2bLrO2MA1hCJuFVsV7BXLwZ+Px5RpEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR7JWe2zcCQzbzw/3IUbtt6LlH6sxUB1CaBML78zP72aDs3bdE2z3u5y2S5kv5nca
	 Gkqaczsf3sV2zpyPAxB40mALEbAhCIDKi7+dyz5Yfuxd9fF9CwByOqmqEl1LTOZmvf
	 t9hL/XmYVGduQkZUUuzm6ZYrfKb6LANkn5EsdO+aJR5NiAmHwqLZV50Fpmc8060MUW
	 7jZHf9fyU30Vsxh68ReppviRZ4n5t0cLbbxz6WLEKOoKuEtRmB38FmWtSpLr66YYmr
	 lFUvml+ZfbI+v+P3RFgY1ZB58sHJqiIqMCoAG7290MGJSoEjqDcdAoSaiSWuJxXknp
	 IfOU5xVFxNf8A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] Docs/mm/damon/design: update for hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:55 -0700
Message-ID: <20260915143359.91472-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mzh6qcnhscpj3new8jdjup3pruxw8zjf
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E0E140012
X-Rspamd-Server: rspam03
X-HE-Tag: 1789482850-815355
X-HE-Meta: U2FsdGVkX1/ErXlYxZyG6Y8IA1xlTk/zyPdwRPQ+/gcAglFqEXfS1ZOgdria6P7BwjF8fufoXAqLD0C005P4/8p0lir54hAC6Lvb4mCN6S/YGs9cXTwFDkxBzRpkdsfk06MspKWeR7LirFRUz3ndF3SN79238kSnB6IBaNLRT7CcWFgHG/6IxQgZ4YH8iQQ22uMDURUb0AqX8OZaVpbndIVVocCDO5zMRsaJRR8FDAixbU34Cs9GW/WuEWQV4h0y2tZclbmgplzh5WISnbpJ5BLokhzuV6RpZ7YAr7XDfAdO+mbPOI6rh2VtdPHJTDWk8ESHH6liaX6aelPW2cjELAlrvZyOWN2uijUxgQ5Owz/4+DOJ6Vs6M4ll6SI8bnhF3NT+A8JHgD1NtchPXx234SWNaR0oSwDqGqOPw29oXwHVoB8RQ3OdVqCv6R9GyhTwEGh4d0fsfuiV7w8j/UuYcHuG7XH5wZwrUvmMsMTr46IqfSLrN8kABJ2TBFE2uZ7rfFb2h0UVGYEml1A24z6jkNEiJFX4sZiBiq5qyMpyrc2kx7hTgEOngjgTfpE+VnVmw8I/kBSNg4aljO0DPrYs0rpq++BgU68M1lXbeTN5zu4o0vV+MV6yTblJ0To6CeVIoWlctW/NjK/8DywIbRJsnfphkw3va9T9RhjYcRUUtqMZRD4ZBFz1cmVQxVtkgHodIjU0vxXFtMBdIKX0lHNjDFumOaPnynqJt/4IKI4DFRl7ZKhdxFfAJaypIqknmnmkuSBcY2aOWQBqDJJuf+9mIUK0pRcmIfQFTG26QQbdjy8CR0FAIVVmJn1Pk1TdSuteJDhE/6sT/vP4bOzlnQE36TDC2wBwxQ88whq5K3dLPaq2UxfZ0ARSxy9LKVWQmQAEMXSqHtbBQE5X1PILN7riOMJrhrX5sw/XvipzyxlIlDQsSFKswHHeT8Q2xP/ZfE6U+PwUQc+xwJdpekZ/Xq2
 NWxX/DrN
 GIoFoP7+hYKhTgVXEysyMQWHzmjwRR0IYYCMH6G4Ax+abIHobiQ6zxDvEKF5z4QCrlwtZwpzuoIYaZcpnmcUnrWyZqHWDlKNUbwpyMgALOJ5Mz6/N6FOzGmmgbNFnKjBeARUPBxXwf8qpwY7GfrM7963MJ0p9gMUcaEva+Ksj//K1jsb3yFc2NR8yceKCzZmbkNNlwGMr7Dd58cRXJRFnfAZY1MoIjDabb3xbft+9CMGgZjxCN6cZ8T2wcX8jvyLrGqoRuVZT3V2ZzJb3k21mie7bSOe6oQNNjSB/RM1WWCcF1jXAaHI33SAEMzg6Tvq7F5W7tiI7wHT+pNUz2LWzLt+SeDdHB/HjqP2d5daweh8NI+75x8xTid4BlYzdUConayzWBqwsBl8vGz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added hugepage_size data
attribute probe filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 707170bcd1b33..0a86792f90a18 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -300,6 +300,8 @@ filter types.  Currently below filter types are supported.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
+- ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
+  of a given size range.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

