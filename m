Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD44C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDCC6B0375; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C2B6B0372; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE886B0372; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 409BC6B0372
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F21921604D3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:57 +0000 (UTC)
X-FDA: 83821856874.05.0968BE1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id C11FB180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FdWFdNk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMcsJ+55;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FdWFdNk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMcsJ+55;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283216; a=rsa-sha256;
	cv=none;
	b=fmTJgglLW1B2OjKQSga4A0m7wLxHrWtke6fcemtAkajs4EPN61ZRw17XSe/T+2pMZX9kxT
	xd2JqLSfjnI7XUHl0FIaHNXrJiJPbTqyDqrYbYUg1jxas1YK/IIrAq56GOSDFEx92iWR4Y
	GTtHZumQC/QfVIAQcPyebNHxBHJya7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FdWFdNk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMcsJ+55;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FdWFdNk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rMcsJ+55;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=jlMiC4dE+yhHZ16lv2NATnDYRGt5K7qCAl2k55K9YkRCfohOUoQP4vPdQuKgtpwmNBOSaF
	+D5675bzQ+QigDqyl2e3rLsAx6waHnfH8ncHIncmzPKrrEnOWq5aXFamPkdh37nsuR+OFR
	A7YjPIeOAF/NsBbCDcD+dqFL60XfkkQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A82312233D;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=FdWFdNk6TCZgy2nxkKnHyH/gOhW06MM52E144uaFEptFAWgOxxgZpiqOW+9oHSVGeomEKy
	DdHbsvEMgqP0LSxABJ7IXL6c5kahQ7XTNIg/Ygrjbua/aFMjbUk/fuPpn6sevEYHkYtLzO
	15n+KWuecNEPw09EzAeDbBnlnkLvnsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=rMcsJ+554wYvI1o+b4gPWt0Utnv4sbAmPE0solGOr15xwL6oebqkMZOo2VoWJPzWx/JCup
	CAhpVafhccTZF1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=FdWFdNk6TCZgy2nxkKnHyH/gOhW06MM52E144uaFEptFAWgOxxgZpiqOW+9oHSVGeomEKy
	DdHbsvEMgqP0LSxABJ7IXL6c5kahQ7XTNIg/Ygrjbua/aFMjbUk/fuPpn6sevEYHkYtLzO
	15n+KWuecNEPw09EzAeDbBnlnkLvnsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=rMcsJ+554wYvI1o+b4gPWt0Utnv4sbAmPE0solGOr15xwL6oebqkMZOo2VoWJPzWx/JCup
	CAhpVafhccTZF1Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9339013A6A;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6HFpIzvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:40 +0200
Subject: [PATCH v6 08/10] mm, vma: use percpu sheaves for vm_area_struct
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-8-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C11FB180006
X-Stat-Signature: 68e54ert7bujyebfww5mkjy6t68zu5j1
X-HE-Tag: 1756283215-610121
X-HE-Meta: U2FsdGVkX193t3+y3iHXbNmM2xKrS9z0QuxoRpnl+GWz2IWpV2LRDA+cuqSZDbPCYbdHHXZDi0pTngDPdnXrTs3peUjoL2wdFGyPLAaFjfHDTloDlclfhrNURhv0BTB2B5v2UkA2+sECDezf7g0THivsOcPyB9YkpweXysdYXJZcYH2wi/k6Dz4+Wo3nMpH/Sj7sgORizpZy4YXD5evwUbDJVdmFCEOTgFiEPSIDxc7z9k/VwRqOWDpE+kIZVfRqenqWBUYWSwUdYxLlvNpeDObkkaOusw2jkjmzAYhglLzj684s8/sboYwGEiQHKwbsYZ4+qFbLqWJsrxveNCHUQpLz0pNAjX0C5Tat5lkCJvbO/3baRZGZWVKnByh3hfgihT7OwDoZvCakXNgOBulr6wwAKjdFgNPDOFU06m0erCOoZJ4xYeHkWOJmhxKtJEXU6cIaYPRTXX8eaPfeM06fz7ZWcuO+j58JKZzgKkLGcSBehTWZ+ZqDBHuQVf4gUVcG+1JB4GqKXySkuvpefr3xkX+HRJRgT2dMwYMB/d9u0mWc8G31R6gG/rCdcPvD6UNvJ3jKS9PQRFxq5vps0cOkpXKWsA1jEF24nHPi4QGkQVhZtpfKAa35Pvm4vGfzN5xsGJZ7kIuWbCPHlsF5rKZb4pOrjM2a7bOqeDBrNfpYWheaVwjvmyDrYMVy5Tdq+YCj1rxHJWY7oH6v0zTeUdaElgVB6Lm/hzIUpu6Hg/bLyI/XtvHKGObgv0AWBcvuGW4zVvuIfdFuFxhBB4BYgg7f30edGUHecdouk7IlpWOptmdDuT9V7dFE65tKI2176BHNrkDFHuhDRPL8pAsmw3//ceaaTfS6oSbcm3/5NG+1w2ZT5ud+nR4VlyQkmHhSBgRxunvwle/IIJzN7LfbRP3FAD9/YRo5v2nq2BsBE/oemfPjPkBINKLjB5lDcugnc5UOf9pqXwvClN/GiafSL++
 Q97EEKGR
 NjugBuTPtsVbyCwM9P6ygKZYO/7Jl0hFx+DzqAecT7obOjGZkhy06uHtWv59hMS7Gi4UR/c8e3c6k61IbxqjFp7shZY457Y6yMA+xjrPDMVFM7bOrcucFIy0HH7bf57PZV9j2H9P3+zosq0t+MH9oMklBQsXRkj2IszSs2ni68qv8cK6LdyYf8jeSB1l6CRM1IHw3pj46chZjoyHS5h/KxVvyfDqFwAf98kW54IFJ4W2wsnHy9Jg7UPOvmvPbxa0G6aNbWgnWGpsKURlZI+rEMQf1RQ1dhjijJfFlPudQEM+HBzFowZdPBiXu41MKGvgei0spsaWE2TXKidnAK3nyAcEbpjPTc0E2pbw7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create the vm_area_struct cache with percpu sheaves of size 32 to
improve its performance.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/vma_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vma_init.c b/mm/vma_init.c
index 8e53c7943561e7324e7992946b4065dec1149b82..52c6b55fac4519e0da39ca75ad018e14449d1d95 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -16,6 +16,7 @@ void __init vma_state_init(void)
 	struct kmem_cache_args args = {
 		.use_freeptr_offset = true,
 		.freeptr_offset = offsetof(struct vm_area_struct, vm_freeptr),
+		.sheaf_capacity = 32,
 	};
 
 	vm_area_cachep = kmem_cache_create("vm_area_struct",

-- 
2.51.0


