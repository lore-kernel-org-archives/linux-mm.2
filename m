Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507CF606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Try0UpDq
Received: by kanga.kvack.org (Postfix)
	id 5A1266B0B32; Fri, 23 Oct 2026 06:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552946B0B34; Fri, 23 Oct 2026 06:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467C66B0B35; Fri, 23 Oct 2026 06:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2300C6B0B32
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:21:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A13971603C9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:21:47 +0000 (UTC)
X-FDA: 85353499854.22.2DC2E1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF8AE160003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:21:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Try0UpDq;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792750905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sYRuHapo9W9wmZIPuuqoJgF5i8UHavCm+9OHunlMqfk=;
	b=zlRIiZJfDBOtjub9nZpzZuCXqpzSLqt0g3bJCrOy3USjlWu8qW7cJLPTMb6vSwtLiEDwR6
	o3347dcND7C9oL7sZTgvWdcSGAply5agEVO9jxwQ7I8fOFRnCT3Rq4beDWnua7s+6GVjbN
	1R5FN9CBR/wrniOfVhzfVHqCFJAReQk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Try0UpDq;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792750905;
	b=N04ydtTKjPZl13IzNl+UOih67Ft0prPH92qttFiY+Cw6NAolPbwyM9Ubt9NM4wX2mhELmy
	eTUMswl3UzseK8pGpbTJuhBw6c10zFsM+MpuRqtvOX/RY+5BSxMYwEN8RKvL2l98XynSe+
	aCDGld4VrhB316FF1rqMJAd6tfeTxvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C8C760232;
	Fri, 23 Oct 2026 10:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EAD1F031E0;
	Fri, 23 Oct 2026 10:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792750905;
	bh=sYRuHapo9W9wmZIPuuqoJgF5i8UHavCm+9OHunlMqfk=;
	h=From:Date:Subject:To:Cc;
	b=Try0UpDqk13dUQv8kNuuSByobmY1fv+iclYkBIhj56IHmpUTI8tuRlRsH16FD3C4j
	 zlRVStaEGZsGe4E+yRPuIHMQ4+GCJnlUCLFsvw2nUUP/dVbCKcobPj4Bh1rarhPd1+
	 WhFNy1vksDUeHtjnnGksLcd+NVnrZvnjxckZ1g+fHk0ZduQ3zzuC5CR3zYoyksbrOe
	 B21ZbmW2ng6gNc7qt2Pb5ZltyDn4aRsyi0YvfArfp/7Emn9PsJL1L6+2n7IHbnww9V
	 c+FVcJJVQ+SaumXh3oNCS9OCKVrnEZcM3bIhhtnQ22np4lLR5rnNuTi1xLyLUq8VEE
	 9BR2NjC9H2n3Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 11:21:31 +0100
Subject: [PATCH] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvxJ7bkE369BXooPlVgtlohRC9Pek4
 8DMPJA4Cifoqwci35Lk9AV0XcG8Wb8yiisMpKjTihpcJOOVNNGOh2R2hw1IztCiWjsZ0lDKELl
 o/3UY3/cDviw63GUAAAA=
X-Change-ID: 20261023-fix-us122l-mixedmap-2d42f05ab421
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Kazuki Hanai <hnkz.64@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-sound@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
 David Carlier <devnexen@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2436; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lNhw2btcFfOxweCD1NL36wEg9RyU1oHp6QFW0PYzg9k=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJum5o5/ivQ58jn8zv2RHuxzi4vhWen7D8p6M6etdBfY
 5r3okNzO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR62kM/yM+mvMtYtvx6ciM
 uftbnaPzCq2FbISl57UbXspvlcp99IuRYVPi7DJ1jvJy103L3t3cOpn5Eh/jpN/FLDZ1Z82T+FP
 +MQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF8AE160003
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fihso1gfaxmsjyf9p9be7rjiuaht3r7y
X-HE-Tag: 1792750905-893829
X-HE-Meta: U2FsdGVkX19L1fBybMGeBc2l3iABT9YwMPBOyv3Zgy6Hbdv0t/6o6CpVeyQC2GnDQlEgkqZc1iXggoT5Bg8td+ZDvAFAXD2dMaOlEWiEXruhcGVde1+lZwcruCFcr4TA6/JStZV+zT3927EMZsUwFwtf1qY9SaqqI1BPCsW2BQaDUq5WDeAWjamXB4VeHElgp70Seaj6AEEA/NUazfml/7X3qUAZ8/NPrRBkVwG64UBS5IIDnK+KSc0vLZNjruyxttZyGvlC7+M6ab/x2uf9GVY471eEDVd3A4XajigkZjfsjCCtAyv5wb6SXfSli1IGEb70Ob8w5b7cYKQtuoKafRDnrrjtMOi/fRHBpNyxq3ZCr/v5e1VjEKlrWWdmjhX21b+2LcTiMlC5B2zlHjT+W9xxkpmAd/ShK88SeqWGEHYy/yWe39R7T99UnDIEVBUvn7lJr+EFQow9O0S+aPStPcaH7/pM5JlItO5PHKd8TbirRlfl3ToIieUPqhlLsezCCBI6myYkQxLCKGoZ2jAuSP/wOZLO8+qfT+0Xlu2e7k2Y8CQ/i+zUIiLMmxMo2ZV2RqAHlPxsocrTB5shNoMsb8/caeB/ZHDY58uyzAj610UHBkiquPMeD6flp6VlFrBxcstvWcJA8zaF9Z0Y6c/TCtXNPin8HwVEbRYLcNoQIr2r9bGsUzktd2w8F/aOSv2dUyt3wGAfK7+W0YLypDwMklyIQuh5aUdKQkvKaOrPpU21NVU3rYX+O+IdHYOCLxnfDMVATuaklnE7vFffF9JujHq7rKtngGFWbTng+vOQgKt4CHWR9z9iwPcFwnTwypbbn9Qpr7EhGujtxbqQU7Hx1nUK/KTdb9Hk88rnLL2RfWh4x1MUUYX8q+3G77IudwPYW7Pu6G6pPnbz9gsEb6sa8RQEZMzCo6ufKiDTbvxggzOj4w+MSX1RgyoxNv/dxsQIKlY1+LBId5Eq1hj+iha
 4tDEacbT
 7QUOc8DtDgy/BLWpQHNdMyU6E4vQpXap+Zhv1lRtgF9mKLMihgI/5hgvp/Ahf4wlL1JGLU+hP1QVcllYieOp6HEYkDjpH4YMLf+K3EaoQpbaXv/ZogEkNeyhXo9clZ6/Rq3WaeBChO2wTR8A3wa2U4OiV+AV6mKCb24ZBIXiz6uTFXi9RRghPeCfr1e6W4TdxRBQaBTa32G8S+XqYtmkTpc8THdzC3MwhROgd12qs6MgrsFTqC6EAtB67lMixzuyHAb3NAqBJzhJyBhNZxUFIWAVk7SF8Ubt8g4qYJfolqQjMU7/qtOY0WBtQfdxB4cKMYJvl2g4I5xLVnWI+nhTZNQxQNV7TiYUKJ8KyFUrDAOpIAzTy2lLlEdNTC0dpNIz2iv+meuJloffv1gXnwtdu/EiIMDjLCHu2wBzabFTRo8taSv6ETAIDcnh1PlTiZK1lVxti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mm has recently moved to a strict model which requires any driver which
clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
(VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
error and a kernel warning - see "mm/vma: only allow mmap to clear
VMA_MAYWRITE_BIT if not mm-managed".

However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
write upgrades for read mappings") updated us122l to clear
VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT.

vm_insert_pages() and friends set this automatically, however this driver
maps its pre-allocated pages from a fault handler, so never calls these.

Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue. This
correctly marks the mapping as one whose pages core mm does not manage,
which has no meaningful impact for this driver beyond preventing the mmap()
from failing.

Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
Reported-by: David Carlier <devnexen@gmail.com>
Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
Cc: Kazuki Hanai <hnkz.64@gmail.com>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Andrew - I think easiest for you to take this.

It should go in before my series ideally to avoid bisection hazard, I think
while it's a fix for the driver, that'll be the safest way.

It should be prioritised to be part of the 2nd batch of patches for this merge
window.

The commit it fixes is cc: stable but this does NOT need to be backported, it's
for 7.4 only.

Thanks!
---
 sound/usb/usx2y/us122l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index a5db0d044ef9..2986a90ea335 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -193,7 +193,7 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	vm_flags_set(area, VM_DONTDUMP);
+	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
 	if (!read)
 		vm_flags_set(area, VM_DONTEXPAND);
 	area->vm_private_data = us122l;

---
base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
change-id: 20261023-fix-us122l-mixedmap-2d42f05ab421

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


