Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C1DCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D446B008A; Thu, 21 May 2026 13:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876A66B008C; Thu, 21 May 2026 13:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B26B6B0092; Thu, 21 May 2026 13:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67A1B6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:32:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CE9D406AB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:32:25 +0000 (UTC)
X-FDA: 84792121050.03.BFF4321
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41BB5C0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:32:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WscmP3h2;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779384743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoV/8rGK/BVFZVwjIllhg7KwTXliGdwDTicZ059B8Do=;
	b=AM9Jf/W8WXQHjtXd/h25p4tIQp7GGTrWpMVS7Wxds0zpkw352O+P/aBWdqxFIOE1j1/t3g
	nD9eUvQmkhojSOgD4riNgOgq/GYPs6ovmjMTeTgLQrPk05oORWL2YUa9m/0CgodC/TeM5I
	A1nBqki00FbVYOJtn+Sa0nMHXZ3PfZ8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WscmP3h2;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779384743; a=rsa-sha256;
	cv=none;
	b=LdPrIfuy3XqjX58FDSEHLR0ROSkUnxR0DaeOiyXar87vK2CyK6zr7sPZPAzTI0yy602Mof
	LsKjNa1MPnFvovTxcnsFc5wDsEo/MrIk8qiXoqZDEGbJ0wQYBrRkMr7Z/OHT8xP8k0RDy9
	1Id24rpJTZBmPs5Rjtjigf37E8lSj+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4281440B27;
	Thu, 21 May 2026 17:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A276F1F000E9;
	Thu, 21 May 2026 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779384742;
	bh=IoV/8rGK/BVFZVwjIllhg7KwTXliGdwDTicZ059B8Do=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WscmP3h27+6dPnRs9IdepI6V27u9RJvQY5frQwCdBikrBlXnZLsIXQ3gLCXTtAzHW
	 cZMKCUJWJpLp5mxY4swYRZ9RkXfD4JVsayBVSCLYGU7yQ7p/luw8JUJQnIjV7pdG0L
	 DehRyqa3slCzWp5dQMWC48+LukF3n9KUE1ggiJyCTuRLNP6rDxXLluQBmtKAuGMoME
	 5wbbkyKHTZ2939QCGA17bZeo0P8b5DqPUnaZRmqw9UiqpkJVwXa3Xe1ZuFOIe3xR3B
	 4VrTI/FzuRP4pjLdFYBkTygO5izpaksGnV/tJFgEC0CiIBvwpmcjeFGRFYD3bE3mdm
	 uqs8L8MxGMWfA==
Date: Thu, 21 May 2026 18:32:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] drivers/char/mem: eliminate unnecessary use of
 success_hook
Message-ID: <ag880fujo7knsvlC@lucifer>
References: <cover.1779379804.git.ljs@kernel.org>
 <68bd08d2c7432f94b87f9e40f379336860a9997c.1779379804.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bd08d2c7432f94b87f9e40f379336860a9997c.1779379804.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 41BB5C0002
X-Stat-Signature: tz1o4nx7daxpazyhg9gmwehaseuqjduk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779384743-647264
X-HE-Meta: U2FsdGVkX1+nzrcGxI52RiHisrK3OFhu6NMpQRFrjdC0SDOR7j0I8NYtscfunYy6tCge7EHnoVo8dVxGf23yV+s9FcHSuK5nxBUlKoFpNbMaBonCqKB8cODVfwVI/D3r/IP49HukjYxm3msqDp30rcS9nssWBVI5sVSwj6T3LWaVRluFiFz/RHIVjQmY/dfz4Garuukw7vCUWeUDQyhHDUjLPRKhUQ0MY4nWMXO7U8VLc8BuruDY9zHzeyj+pdf1GOk0C/i0hhflIePGoxcPaI7n76ZiJjZbVRfr1t67vcEHGfPCLV8iwwuoKqtYqznZDjrq4ZA6QwMFIGnR1t2AMj0f9Uc1BTe7X2GU+geqC/E9N5Dyo7aSeC4ObJxiMXjXke5qU47UvRse2u7Au/ISi7353ojct1fOXVxWzFIOi/u6KSAHnggiOkHef+ZuuqVefKzLit+5+tY4f3HEeLV/pvjWInNKqJROUHu4QuhIsDx+cIrf1Lep72NkssOX9qboXEtMHOSmswwh83iZVgQWctkPeq+hgixltjSMKK2tXEDgno94zsER/nruTw48K9AqIdljjamgVp64R53bF4jTlLcm8vCjQZ2HXcWpbVAWQfCLcJbDgR9RvNLGyf65fLiwUsaJFnq932bwIHxNPMi4ZdBonsB86bgS5uw6ylKyj5896KeJbuoQHHEdFmgstwU80gwjnArKij80lzwJulQ6jEMT/X3YNjEyhvp9nk1VeELh/URCycPNZFcCxtmnKJaG/iotdcATX7ElVU2uL/GD8lfAHfWnCefb+cdQxptKrOwDjypnAkK5BIg1MlHftDLURuHnfuCI0BInCfl0p4jwjAxjyt3sbnr3sl1SDw8gWxLZqkK8FF0eArdz9YQ9//JkO74ZGBTPRescWDA0qWNBNSIQDxaxQ250yahnz6+X7HjnZcQkeL+NPF4v6iy8xOXFZlOkTmZwMvd3IsXdkE2
 XHs2yRgl
 ey+OPLTc0y4xJOy3n1Zafj8N5BdZ65Lq6NwKCDC6kuSOvotAKxEk0XiigQXWYMuYcnyc138AgdGalxV29VmXOdP+FebhywPIalArBOU7rM0f/HJf0KBlVuipMkbmQ+ebnMbDLUsNQZwWESdH9p7UdwTGyX/kwxEi2gCwKxTsJ3cQxzk90yLKRfWflE4d0R9S+HTBJzckrMKmzarHf+6uZz1fME15hykZOt5QC899PhN5BoUni7VxKS++NlerdrT+zsQoq+H4vHZN6Qzedko58f9ueeeapuaFCk5JGvXKyWgrvu06eNvG8IPt+fZ6JKzEsAcpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Ugh sorry, case of the hit send + realise silly mistake situation :)

Fix-patch below, can respin tomorrow if easier.

And my local AI review didn't find this :(

Cheers, Lorenzo

----8<----
From 1910fc9aa03dd49983cfe7605698f33c57b0923e Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Thu, 21 May 2026 18:10:42 +0100
Subject: [PATCH] default descriptor vm_ops to dummy vm_ops

We need to default the VMA descriptor's VMA operations to vma_dummy_vm_ops
so we can correctly detect the case where the VMA is made anonymous.

This is what a new file-backed VMA's vm_ops defaults to, so if an
mmap_prepare hook does not specify VMA operations this is what it expects.

Previously we treated NULL as 'not set' but now we want to explicitly treat
it as meaning 'make anon' as per /dev/zero.

We also update compat_set_desc_from_vma() and the VMA tests to reflect
this.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/util.c                       | 1 +
 mm/vma.c                        | 1 +
 tools/testing/vma/include/dup.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..2b2a9df689d7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1192,6 +1192,7 @@ void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;

 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
diff --git a/mm/vma.c b/mm/vma.c
index 07486390c692..9eea2850818a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2746,6 +2746,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		.action = {
 			.type = MMAP_NOTHING, /* Default to no further action. */
 		},
+		.vm_ops = &vma_dummy_vm_ops,
 	};
 	bool allocated_new = false;
 	int error;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9e0dfd3a85b0..306171d061e7 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1303,6 +1303,7 @@ static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;

 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
--
2.54.0

