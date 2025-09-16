Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1382CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 13:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39FD8E0013; Tue, 16 Sep 2025 09:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D114F8E0001; Tue, 16 Sep 2025 09:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E318E0013; Tue, 16 Sep 2025 09:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3EC98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:59:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 514B51188BE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:59:24 +0000 (UTC)
X-FDA: 83895270648.26.1CF2770
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6E4D91A0014
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:59:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vLzesQEt;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IvnXF+cQ;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758031162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eEokiboM8tmZkAlMvBN1bGzcqO+asQMBDxG4dhVmeBk=;
	b=teA0xhWixcYRqyN1Qji6qaoM1lC/GCEnIow94Qmio7rglPSVKS+RGsuVROl5WTiAyDNsrJ
	4MJqbG+/+uZzBd3JjJZwbgs/8dzF3VIt8BVrjWQgdrgZW7hb6o4wvkXm8JRaJhZJlkFFup
	ZWXWzkvmxMAe3Xl/n6NX/HD88jovkRw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=vLzesQEt;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IvnXF+cQ;
	spf=pass (imf19.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758031162; a=rsa-sha256;
	cv=none;
	b=8V63bFJady7jphWCOVVjLTr+GkFOtqi7k+vjdF3QGsuh6iFie2eta6HxDv1ZrcIk0ybRNf
	Xkc7oSGtR9UQQRNcc8KGblDFLy6x9+Gm0OV7uM3rDc/BD/YRClaXSlsXdV8MzfbLxHFqOS
	YkOZgOmi/mh01bFvpw0ViJb3rbcXd5g=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758031160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eEokiboM8tmZkAlMvBN1bGzcqO+asQMBDxG4dhVmeBk=;
	b=vLzesQEt79T9vEZS87nGJ3oFPBeJCNAwazyD667XiAI5WjR+RUthQ62DZrdqo9F5Z9bfyy
	FirvLO7u0l0zhVJM7WM43Isrg/X2my+VsK7/rHQrfzQBqW+nRMM0YsdkgSviK3jMlJM0yy
	KvCUjWsxCTQIymli3/xxvksfN7ecZOMGfvo47kycpMkwbU9pOeWhHk4Z/0EBccFWMSQ1TO
	wijnI2Sh/Up55tPS/3d4NspG7ZMlMxm5X5YGdi9penOHevjsoWyg4vEBtzBkCwOrzNgU3m
	Ekt/vfw/gyZfcEL+B80tBc7HiqJeXXQ4gh2O+qjTAUmXY3lNG8/k/APY3HEqIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758031160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eEokiboM8tmZkAlMvBN1bGzcqO+asQMBDxG4dhVmeBk=;
	b=IvnXF+cQPlSxoKRVcUugTsHSI4/Vc/Y8F9duk+4CtplOWJFnS/t5Gyv9LT/FrCqazDviWB
	uQ8o/S7i8gq6igBg==
Date: Tue, 16 Sep 2025 15:59:08 +0200
Subject: [PATCH] mm: forward declare struct rcuwait together with
 rcuwait_wake_up()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250916-mm-rcuwait-v1-1-39a3beea6ec3@linutronix.de>
X-B4-Tracking: v=1; b=H4sIACttyWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDS0Mz3dxc3aLk0vLEzBJdA+Nk07RUS9M0Y7MUJaCGgqLUtMwKsGHRsbW
 1AH9cvMNcAAAA
X-Change-ID: 20250916-mm-rcuwait-03c5fe95f36d
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758031154; l=1328;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=ZNw6/Pkl7XVlQGnaKL39G6YlmhiimA7IoIxBZICvlEw=;
 b=n9IUalFfEZypJVfZ5xG9sKuoLwQY6WLapbIL5Tsm0Ihq9HdJyfjSxomCoNNvVRfzoRMRKlwwU
 w2RMLjLCyeTCivvRtUHgdpP5S2lf2S+ufnTX1SHxylc6FYfu3OKX7LE
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E4D91A0014
X-Stat-Signature: ck9kg3xu168ferot583hmwbooo55cwne
X-HE-Tag: 1758031162-68368
X-HE-Meta: U2FsdGVkX18RAGjoz+N3GLp1U4Y9ctB+wD+ADiwLH4ofxtGxgROymRUlcrNsM0vONPXFIK2ZOQd1wXXWeVCMVQLAVlKU6x0JPrJUThCsI9cJ1dEfCAQi5A9/31GQ0JWZ6A10w5zz11LCG+2wC/Qsyqascc2Ce+oXLHKIt20Sq3IKJKgEOfIf+u96o0eZJoH4+XIU5OHL6Eul7kK5HH8y5fKzNW8K4l4jT7c37MBbwvEG7h8CPn3nTfksJ4pVguk4+cv8wOZOFuNKyO5OchK6UBOIrP+fiZM+kxWxNbBrXBGm6RZlkvm29HhWF4/twVnuOsXm9gMLQKJrV8lwQ8Rq9URytYgDsU0foRgweLkYgckH6Z8CFWTLjofLL+3DefGnkpgi9KrWChQ8osMpVUaNrBtRY4KX6j3g/HQ2vvcfb8rqrhgo5dZ6maK8GMrWaVT6o9TxOGUbCG8ckNFJF3oNELAacehSDrg2ujfZXnXqxupIdEL2AAyPxl+GfWDGXvfZZ7NpE2Z+fkFpzszQi2gmst3+bJB9js9DQ6nVr6Sf/8+PsIEl/ZtnERWQzkxevjJMjGQ6D6uDSqSJ5hOFYujELBm/VWDWv8KH8ZztbSwiglueccBdsxAWjC9CH+OdXYXO4147qeHfVrlXOCmwlv9kHEXmJuZfEd8ES5VaEzvslhIStFNr46zu6ICSM+RgnVLx/mbdKXcE5v6sPUidQBfxD0lyA93gIObcSGSfa9Hw0bH7aTsMGhHMcBR6QDTebRO6cmbMYRbT52+0Eu0YIZ1xWwzKnDIs9xwzdhXoSumFmY4Enmt+dZB7cNNtShep8HWPLvrTSYllAaFU8nNJtl2tcm8DUkT094n9oIokFUj7qarN7esZZm0vZU02DtRWDJPj1FL5Rcl2B0ZLTE2OyGG2MotJ1ojBmEMc39TjuSt7CtnDvmoZYQL46ancpfrRBGV1nI3D0kGkeYtZJEq5ypL
 0cP2QVCe
 DhE1O1ixNITfPC1s8IlD3CJIyPqDnQSBguocZ+xONWYWKzcqfONQKWfMqN9wxMZEYCAoCGJE1mJl4TfNiD/NUULZXfJhXTzp5F7wVxprudXuvCQpwuMqv54i1XtHgpXWOMgyTuPNy54ni4l8JrPSbRF68svO0RX+cBRYZL3VrQIMYnD8d3nUBGQXqncWvls+obNaM5Qdm+NwOq1OTyw5tPipKAhu4DEg1ep3yegDh8u12Cdd/PSgQk8hJr4lWJMglTGFuX0v3bos8weSdsAdqR0DMdwRJp90KniOxy6XfOURnrHrWmyYXhmbUXd4r+tp836PXiS3XbB3TOMUkW9ekyCqDzPM1jS5Dc0CQvI8RFT0C7oWeF3FcKYAQkDaCPkdvSIgW93UAOZUalh8JN+xSncYWwIvRlh1pAhUZ9GbS0VLAKrBrppB7xVn3MdXXRQWR5Jv1e5rQXmbGcElIjHe7HFK/scWl9UHKuQoJyO5B8+CYr75L/Y03FrYP2CgyeQoJ608L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the point of the forward declaration of rcuwait_wake_up()
in mmap_lock.h 'struct rcuwait' may have not yet been declared,
leading to compiler errors.

Add an explicit forward declaration for the struct.

Fixes: 75404e07663b ("mm: move mmap/vma locking logic into specific files")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
This doesn't seem to break any in-tree code right now.
I stumbled upon it while building a series for the next cycle.
Instead of putting this fix into my series and spamming all the mm
maintainers with it, maybe this could be part of the last mm bugfix pull
for this cycle.
---
 include/linux/mmap_lock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 11a078de9150df1beff4f0bfb16e199333767614..9792dd4fff0ff73829833aae8ea3229a31757d61 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -3,6 +3,7 @@
 #define _LINUX_MMAP_LOCK_H
 
 /* Avoid a dependency loop by declaring here. */
+struct rcuwait;
 extern int rcuwait_wake_up(struct rcuwait *w);
 
 #include <linux/lockdep.h>

---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250916-mm-rcuwait-03c5fe95f36d

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


