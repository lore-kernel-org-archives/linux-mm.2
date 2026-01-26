Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E12D1951B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 23:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C7E6B0089; Mon, 26 Jan 2026 18:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F306B008A; Mon, 26 Jan 2026 18:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C90B6B008C; Mon, 26 Jan 2026 18:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39E9F6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:03:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB7F7D3CB5
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:18 +0000 (UTC)
X-FDA: 84375642876.29.1547561
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FF571C0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 23:03:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCV6O+SF;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769468597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba99+BHF2nhNQb3Q/k8nH+M0McCg2V+eqTHNmm440LQ=;
	b=fsiD4m1Hap6/AIwuvfmC0u4GElctJlMsDCd9FVH4ntfn0rIVSAgTR/qxj8UuTmnC7d/cOs
	7tFPFCHP0VaPY+zDRl+yjWKrpyxRL2ZfFmVjl6XzTmbTbtYX0h9HkTJsqiE5u1LpEr/879
	dR7kaLnXE9y+ouazMQixINLjZ9d4wWw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCV6O+SF;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769468597; a=rsa-sha256;
	cv=none;
	b=C5mpmWUFWWxgup0g1awyXFtlSYgF3ynYYtFZjEme9h4AkB6pUmFrZDaHZpDMOIvBrUpbR3
	8q2PNPN0cik9Yawa9gaVBcJV9NLD3yW4w4o+m842fQK7l9HNgh9VXBgb6NK/X2oTryjKk4
	pdR+3wPU+IYkhGUJEELf5MM0XWb1EsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DFD060051;
	Mon, 26 Jan 2026 23:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE2EC19422;
	Mon, 26 Jan 2026 23:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769468596;
	bh=aWlSs1QnR62xNLtigN3Liyq3kVc1pzDFOlsqird+/cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCV6O+SFK07souvAqzjLyiDnTe9poLJbhqeZIzzTR2zs+qoyCfx59s0uXMaN9S/vp
	 yMFLFF8jg3p+4dai6tPBARnBYbF0CbgZmjMACRaniJ2zA8oLu1BcJU3zKDWZOLx62/
	 haJSAWs2bRGWLf8NnF2gl/DJUKJS25ygfYG+F2m7ka+FZgaXIGphoBWyrkHno9x49e
	 XCh3Tfx8LMwU2wBbXoYr1BIIe4JN4x+4bJf58PG26DsXzuwdw7URh1Ne5gNaFCKDPn
	 UexVxNBzUjH4wH72//khKCUkk8R0SCw/RlL53WEUtuVSIYmp6/m38QFjUy3RnqM/+x
	 J6c812wty8Dxg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] liveupdate: luo_file: do not clear serialized_data on unfreeze
Date: Tue, 27 Jan 2026 00:02:52 +0100
Message-ID: <20260126230302.2936817-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260126230302.2936817-1-pratyush@kernel.org>
References: <20260126230302.2936817-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: im61mouj1diiad8e9f39qgpgqd8egmfs
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FF571C0002
X-HE-Tag: 1769468597-656688
X-HE-Meta: U2FsdGVkX1/m2zy+H/AwplVX5RVdhWHrR+ZZDG8HJdDlc7xcTCSdrTqm5GvPmzI2eT7M3e/8J+wvUZjTbZ0Gx/TEyF1Xy/MB4+5X9XDSB7ixr9b0DOn8LWo1rkzDpq3a5Agv0Wrk16cmUMzA4wUT9Xk+95Yi29x9hbKG1nPk4+rmQFtkQE0+aqI2+N6i7pW7xJm743SLbzG94zTQaU5RXH2ITvjwLaRcMiWwE5hhhEtOkPpX0c5UTeXYxEUwO9wM0F+1l1r65aQNynfm9cf27xQXvFDjvYDhvPbw01erJIKvxi0q54ARwtAvp8TfXC6Zaf6EogRD9QOKH7VsfKfXeTP3utfc5EN32xkijdf6JXq0Ilhp+/fdp0DKPImFN49V/pNFpqvOcPBmHk24Ld1lV0jRNFNIv7QUeg1L5WDAKkjYjnwl8VHTVfElWsnNtIDsK1spMRrL9a/T93omGhvtrN6X7UwqHgjA1l3XUQPP3jgVumTwm9+1Iw1oMJOvsvu80utCixMCEaGl30mflN9HZX5I/rfGBQe+3rJwOSX10LyB23qDm8CaZ98ZBwbsmdjGnsq/2YTxjIcX+qctVhxJ+h9AF97EgpnspCz761wGu9bQi1ML5Hb1ektcnc0qGnxgx9wOlC1PCdiNPTjP+y5JitMdfsCwTc7Ri2tlmDY3wdxaOFqF8fqLzS0Vx8THmsOYlBTu1bS860n88j0/zOfoN+JfHaJQ/oLcP9fvm6ZbsKS5dZpnmpldugUZGXK3tKHNiqiP4EQec6sxcxXnjy6rEU2YzOQZd6a6dkks/ghshZyg6Bi+z7eFYFtltOWLgSER96rStjG0TcMH+L7NPXMxIHux+JFxRkdwIrqBQ7P40FpfMDm/AlKXE104/wGdM9ZiYKYaLfXy7N9zr17ts4ULJNWePcRRWkjdnJ5bLVL5nwDIJjoAsmHIVH1Jp47oCWjrCNSUTWEkS50ZbJOLZzI
 mFIZWUpP
 ChckdxvNgZcTZQFCCkHmaYud1g5MWBSqqA7JcFzVEB78ryxphqHlkZncIbdFcXMukXjI1LakyQumwyjk5fnh7flspIL+k17FEDXVIdqDdxeZOHRA+oNbMl8vUeZ/zJX3dyrczodSys6fDyBlaFHDyyu3yKP8v6qGqAeC5JPWwgXRdISoqzkONnpU0oI4SyNZJbwuP7U2xIRVFZAQstMynY3LTN5Z3wajmF5c9H8njsFR9XqE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The unfreeze operation is supposed to undo the effects of the freeze
operation. serialized_data is not set by freeze, but by preserve.
Consequently, the unpreserve operation needs to access serialized_data
to undo the effects of the preserve operation. This includes freeing
the serialized data structures for example.

If a freeze callback fails, unfreeze is called for all frozen files.
This would clear serialized_data for them. Since live update has failed,
it can be expected that userspace aborts, releasing all sessions. When
the sessions are released, unpreserve will be called for all files. The
unfrozen files will see 0 in their serialized_data. This is not expected
by file handlers, and they might either fail, leaking data and state, or
might even crash or cause invalid memory access.

Do not clear serialized_data on unfreeze so it gets passed on to
unpreserve. There is no need to clear it on unpreserve since luo_file
will be freed immediately after.

Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a32a777f6df8..9f7283379ebc 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -402,8 +402,6 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-
-	luo_file->serialized_data = 0;
 }
 
 static void __luo_file_unfreeze(struct luo_file_set *file_set,
-- 
2.52.0.457.g6b5491de43-goog


