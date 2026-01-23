Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE36D778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ABEF6B0577; Fri, 23 Jan 2026 20:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A3C6B0578; Fri, 23 Jan 2026 20:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3176B0579; Fri, 23 Jan 2026 20:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 153616B0577
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:40:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C561363F6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:55:49 +0000 (UTC)
X-FDA: 84364435218.05.A0F9108
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F23BAA0009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:55:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sS06KUKX;
	spf=pass (imf15.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769201748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tGvbj+I0xSfb+Rbo7fH7Df3pTt2BvVPmdjfavW0Oxsg=;
	b=bGtPq7cHxRaAtPCfB4itJOxkfqMyqBJgqagnqX3xHobV/OTazj4zSkAI03RRYUWjmcPKiN
	rDiks7W8UzE2dwTwcFWuUBDZFw/XVGAmK1s7vdraLLVUo1IBgQv26wZ+ulOd2FlpsLwVxM
	ydJqf5AeRrDcmmO/3ExBIL5F49l4aEs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sS06KUKX;
	spf=pass (imf15.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769201748; a=rsa-sha256;
	cv=none;
	b=yeuROUpeKaKKf+T4LGgBbxfGIhd12BOjgE4B8c92TImTJ5CWOF+i011SlBd4tpx+5r3Mtu
	tfjhwQ6/n5zbaWqLkkKGaOZ1F+x5QYoZE5y3g/IGu5tCtQIh+ZVtx+oeRPF+Rk2VofyaSv
	HIq2aQqlQhe9zmJC5rdRoEdwkpX8WQo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F4DE600C4;
	Fri, 23 Jan 2026 20:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADDEC4CEF1;
	Fri, 23 Jan 2026 20:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769201746;
	bh=MRLIJHMes6O1llUqkugm5ytuer8+s6cgNaGPzgrEq9U=;
	h=From:To:Cc:Subject:Date:From;
	b=sS06KUKX/sttv1aAZEgo7bIfPUpctd1CZk53JrmyNARckS9LWxwiw6f5LWLdiKDT2
	 jGnctg2GFb/TSC6jQrGRXzCV3NTUzn6TwpeXv7Gy7unA5nMGP+JytGH7yeAg88tNxA
	 myzW+r2amqWLf5l0udCOSqcWxEaQI9E+CmL/l5bxwGyY1qM9PBU8IWya0zRZz8vSxG
	 AgNToFSwtjFcBuGGsfUqBH/CP8xEfS12OTieC9bsRGleFitlVQgjkxM7maBHgXs5Fs
	 cvVLN8VBXWY2Eo8pXwkCfvFIHLMLqyG5yFLQVF0+/hcWFvCBO00Vya/6yXb6j1Jap3
	 io3sPYa9DAcjQ==
From: Dennis Zhou <dennis@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v3] percpu: add double free check to pcpu_free_area()
Date: Fri, 23 Jan 2026 12:55:35 -0800
Message-ID: <20260123205535.35267-1-dennis@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F23BAA0009
X-Stat-Signature: 3x8otjfrt75i6eg1oy3wtsaqxz6hstyp
X-Rspam-User: 
X-HE-Tag: 1769201747-390624
X-HE-Meta: U2FsdGVkX19gwTeJ5vsLI2xtX7IGYuaGBu6nCHGToSI5T8jKYcwPEIa8Iyy6HUKDYFJOOsplt5QfKiDoS6duSb+xCxb9K0sQnh7ePzyfwtaAXU5uviicYA/ePvy8/b+/aNWnWkA2Wlh35N1pR93fwvotryVw/y8cCv8cGaHrlvRwiSkUitZa4vAOzzp1y4BPUIqfGajByNK0ok/5KdMmdxzyAjXKkOu6dKTwTZiL2IdpH4k+07MvwO4WgSLeJjSlxA7vPhJn0oz4vo+SEN39WPwD+qlVFd8zz431aXxYn5SQ4NSjSII0IbyBtkEtKUuQWV06QvO7tJIf7l+iMy0UeB6sBTUj1RKXZLcFT0B5T0pn9TixnsXFX2j/HxcyH0fiweZKyi5L6YnpFHLa5X0ch025DHwfa1D2+gdxroqRgTVdtyr+/wJHTwBl26etv0woLmo1TZYqVks5L3kp9KAWVoh0FdhOi4uq0DXES78vNjWYSY6YZ6hYX3QFWP4q3kaeBV9HAFgaqGoxurOpgSAcWGIJ3VMeZnz5fDaHuxQSowxhdKONheGiBNU46I6q90MZrSxyxeXRMeV7c5G+fj49jQpTZ0UxAiyxjhnqJrCPDJoQFrVFZcYUwqN4hsLkjjL9uqBN1Z+jhdsSyA/Q1Hum870Ga3Htr1OKN9ionS5prjHmC2VcFoXx+a47jdGWc0JxP27H8u1DJeivVlfAzAso//KU13VRn6tzvVNfLnW3u3N2WpOxGqlwB1786+WGNOwSqZPNMw7dWsL7es/fG+oKLqkyht0ogkiL3JJvfYy5KtpcyYFXL5rwJi9uhJPm1gWgNt203D6QhbNroeJd9UxrJmEyhFpK6+GajrNRBd1vjzeSVfk04thboN0CoikBwhpG85QJbUb+udWTx02HA81IgEIzADTC6In8h5NylF9X7Q3q7/rElOndzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Percpu memory provides access via offsets into the percpu address space.
Offsets are essentially fixed for the lifetime of a chunk and therefore
require all users be good samaritans. If a user improperly handles the
lifetime of the percpu object, it can result in corruption in a couple
of ways:
 - immediate double free - breaks percpu metadata accounting
 - free after subsequent allocation
    - corruption due to multiple owner problem (either prior owner still
      writes or future allocation happens)
    - potential for oops if the percpu pages are reclaimed as the
      subsequent allocation isn't pinning the pages down
    - can lead to page->private pointers pointing to freed chunks

Sebastian noticed that if this happens, none of the memory debugging
facilities add additional information [2].

This patch aims to catch invalid free scenarios within valid chunks. To
better guard free_percpu(), we can either add a magic number or some
tracking facility to the percpu subsystem in a separate patch.

The invalid free check in pcpu_free_area() validates that the
allocation’s starting bit is set in both alloc_map and bound_map. The
alloc_map bit test ensures the area is allocated while the bound_map bit
test checks we are freeing from the beginning of an allocation.  We
choose not to check the validity of the offset as that is encoded in
page->private being a valid chunk.

pcpu_stats_area_dealloc() is moved later to only be on the happy path so
stats are only updated on valid frees.

This is a respin of [1] adding the requested changes from me and
Christoph.

[1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/
[2] https://lore.kernel.org/lkml/20260119074813.ecAFsGaT@linutronix.de/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v3:
- Removed bit_off in bounds check because it's derived from the address
  passed in. If bit_off is bad, it's because we are getting a bad chunk
  from page->private. Let's do a better check on chunk validity in a 
  future patch probably behind a Kconfig.
- Removed ratelimit in favor of WARN_ON_ONCE(1).

 mm/percpu.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..a2107bdebf0b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1279,12 +1279,16 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 	int bit_off, bits, end, oslot, freed;
 
 	lockdep_assert_held(&pcpu_lock);
-	pcpu_stats_area_dealloc(chunk);
 
 	oslot = pcpu_chunk_slot(chunk);
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
 
+	/* check invalid free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
+
 	/* find end index */
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
@@ -1303,6 +1307,8 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 
 	pcpu_chunk_relocate(chunk, oslot);
 
+	pcpu_stats_area_dealloc(chunk);
+
 	return freed;
 }
 
@@ -2242,6 +2248,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		/* invalid percpu free */
+		WARN_ON_ONCE(1);
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
-- 
2.43.0


