Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3064CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276678E001F; Wed,  3 Sep 2025 09:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9418E001A; Wed,  3 Sep 2025 09:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F7C8E001F; Wed,  3 Sep 2025 09:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCA5F8E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8600C1A0684
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:11 +0000 (UTC)
X-FDA: 83847949542.12.925871D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7F75E40015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Aoc32Y8K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OcxShp2L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Aoc32Y8K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OcxShp2L;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904468; a=rsa-sha256;
	cv=none;
	b=jd3/PCYaz5a8dp/YT3Jkh8yCQ4TxIc6y5uFti+EWbndWHgab+F8BPfqsQs5ZrdAH2FzM2J
	hcNoUr+vMBGoIzAGQ7iRcrQtV8eOKHpKCjWF3vUuiJSfPjC/jeo6AfXsybugR1EU/+TUYe
	Tt5lQHsonVtwy4oE72TamPFXsfVjMis=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Aoc32Y8K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OcxShp2L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Aoc32Y8K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OcxShp2L;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=gHlQzZmQE8BSuN5CYuUEms7GaJRlJhX4OqcVfrOTDZlomXfwsj8SXlJHsfNNPlI0g5arZ8
	n4sdOeLMvF1R8pgqxyA2J36Ms+GByMWC9OtL8f8PVkNaV+qO08XegOo9b6wZNYaDfmoyaI
	UUUxMoSVmlR1NGHM8WLBvNA+pwdivM8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8C432122A;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=Aoc32Y8K6z/D1jmhEZ0JziBmWP8l/NTAykVCv7X+avgX9sLROwv0cL8g6wou27QGhylw7v
	d/dK3sDQAs8zGnhBNuwlWmrptUZnGqvAocyQ/u6G3JLk1jwg/zkB/vyBexwHZDDWmsSbsf
	aDsIHwrULTDpOEyitOtk/62ADIkIfJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=OcxShp2LaA80zjS5jwgpwcQZbrYHyDrvFVkiNAtp5srKA8xy23EfU9tBfRv0hPzRSXL5GZ
	x0Xk7Eqz/O/FhwDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=Aoc32Y8K6z/D1jmhEZ0JziBmWP8l/NTAykVCv7X+avgX9sLROwv0cL8g6wou27QGhylw7v
	d/dK3sDQAs8zGnhBNuwlWmrptUZnGqvAocyQ/u6G3JLk1jwg/zkB/vyBexwHZDDWmsSbsf
	aDsIHwrULTDpOEyitOtk/62ADIkIfJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=OcxShp2LaA80zjS5jwgpwcQZbrYHyDrvFVkiNAtp5srKA8xy23EfU9tBfRv0hPzRSXL5GZ
	x0Xk7Eqz/O/FhwDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0FE9613B05;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GLKgA9o7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:54 +0200
Subject: [PATCH v7 12/21] mm, vma: use percpu sheaves for vm_area_struct
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-12-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F75E40015
X-Stat-Signature: jmibij94od7btktk5dwgnj4je8hdjshs
X-Rspam-User: 
X-HE-Tag: 1756904468-269069
X-HE-Meta: U2FsdGVkX1+9ztV7Vhf5XufEZnzbLYQViHUiOXPNAcatJQiyiImHNMfE5CqVfHG26SjqP22U2vS6EL/M6ZKOlQNrSfp91mAi1UONvgs438RhrjO5J1KUbxUrFVTdgcBHltLSzXodQijtkDgSoVSJ5u4EjL1vlMVcCQ35+WWVU4/JlV5M9C+BJJgvd7tXBUYMJ+1A8KdJiXNRv99jkDHRb5apMf7F0F48WIqqhh2bu6ml79O74k/XAG0YL7d8ekKmI7GDXkopG65+I3wsL1BOP9C5MxDufZXtl4zyRWjdff7jTyzwr3sYADGgQFBHrsPsj4739k182egMO5bmSncmBJXVviC8fpMSCBmcrY19wSzPgf3GPCdG273/v6UcXt6+rUcfnCFE/dbDSsGTlJ0XI6P0/B9TDomCGQAmop9XlNZiaQbqjCex8OhMVEyMLTYk9BcJDSYsTJpk9PZ4Rx7YK+LLkSDvMn9TvREreDj0hWtcSxV3b+/fz1gXzwKXB3kS1tE4fQ9a6MNkslMJWRTR2EEFyKYamvgR0t6+eHYrwVBEWjVh8wkPnsDQ1DAS/3ji8pdZVXdaWH3p8i/JYDSflutqi3lBpw4o1ACefbSKfmOXROn1eEDDtwSmorJ5/MnAGideECkydnfhnj5f5MIML87S2ANxm7J0R70iuuMzKjhQ44Nvl05RwtUP4V0h+RZWbrPRw/gpmbU+a8twW26tCxn/z+Yv/xAVb5s6zBTJg4vMvzc48HTic34ydf7SodEkp0rJ3/UEmo/Ve1LhcdM8ZYF/D687cd1JngO5Y9KJAT3n8XOcPyOmpCIrxlGoKEtUSKp3VBE25IMAOk3meOl2Vvk9P/SKcdXRuEHkqNNC2NBVorXjt4ruYxPj4NjzYb8YHhSocAwUBuSyvrN4QCXZm/VHXPxJHIKVDRHOgE0ZTinGql+zrlQ6xrepTRcuNyeRyiJ5XdZQnxeP6NmMvqN
 eTVSNxxq
 oGqF9cBbsMz3IRae5nw5m4CrXqPE/o+DdusDIs1ZRr+9CjG8hMV7Zqy4R7epbn7bXv3QXypsqfQoyvNYNc8nnT6Pcbh9EV6EsnCtqI22gbiXuHbgZa6PWNpYht+4/iXI6fhV8P8tW7BH9SsvDns5DZVoNcu19GgOsETvrN4VeAgmf5pJfRac3CQFGggRKN10/1gTze7oX9j0FgnuEkO+YzGG8WL2CWqcy2zIfNnZwGsYoyAY9p82uo1ntECcW1wtHpsSwtn4GGWl4housNKDyh+UGX7f2+QeYl8ZQO2aUN2AexkSFRpY7obCCTUnDn9ciea/wFPYH9q5LiHhtR4waq4b0z9DAe0c+6xcso7b+7cQycSE=
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


