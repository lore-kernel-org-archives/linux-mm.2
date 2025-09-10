Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F75CCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622D88E0017; Wed, 10 Sep 2025 04:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3278E0002; Wed, 10 Sep 2025 04:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AA88E0017; Wed, 10 Sep 2025 04:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 368B68E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECA5513BB94
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:47 +0000 (UTC)
X-FDA: 83872596654.11.62420DE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id B049114000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kRgXuUVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v0Gmqs4y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kRgXuUVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v0Gmqs4y;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=oK/AFs9EmTo5QJV3NH/VjmJH7lNVCRJvnc2TqvJp0ewLMmVjmyUU5NNx1OXNC2FSwZ1QAD
	4wyTWN+yE98VTDesqm96BOF3D1HoHpQg/brCV2aowZyxQoZUFLTWKfv1Wj/VEXQjDC/qhS
	XTCwgZXel80BLRy1hoVLfASft8a7ZqY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kRgXuUVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v0Gmqs4y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kRgXuUVH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v0Gmqs4y;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491306; a=rsa-sha256;
	cv=none;
	b=KZ/+Pb7ePdwCuoSz8VVgh2TElq3LOKh+W4qnzyAGjS3mZ7e1D75JwPuZr7ED18on8cNGfo
	zGbHSX3wteVWmGXcLrW4DoC0emXtvK2WvWzvFNzoeGvtRS+bBFeeDf9WVnWdpXFJ6VG7bp
	P2mnUe73l7uRO7ZuiGURDd4RWWHSpRk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B9CB5CB08;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=kRgXuUVHckP5nGYOk9us7XwUxag1poVZHhieSiHTDGmQaabS697+H203GEA0HCiV/CqcM6
	gC5KI1Uih9wclAxbHLuiecmQX8sDy9gHY1rHD4e0RYvjELbSZNgEV0vpjF1XGsRs0uy0Gn
	MG4yepVyOww0/i8ykq9Dd1Lfg9vjyl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=v0Gmqs4yLSYMHbcmi4X2wd9y1mMcEnhGcOr6ySAvGAsX+qKc8Ycf4MarNwM+rsOxbtin7i
	XaZ95nBcMlXyNUAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=kRgXuUVHckP5nGYOk9us7XwUxag1poVZHhieSiHTDGmQaabS697+H203GEA0HCiV/CqcM6
	gC5KI1Uih9wclAxbHLuiecmQX8sDy9gHY1rHD4e0RYvjELbSZNgEV0vpjF1XGsRs0uy0Gn
	MG4yepVyOww0/i8ykq9Dd1Lfg9vjyl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkJLUdth35DaRyhM3TWCLrM77sXSdG1lPON3otYkBww=;
	b=v0Gmqs4yLSYMHbcmi4X2wd9y1mMcEnhGcOr6ySAvGAsX+qKc8Ycf4MarNwM+rsOxbtin7i
	XaZ95nBcMlXyNUAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB2BD13B04;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uAU6NUIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:16 +0200
Subject: [PATCH v8 14/23] mm, vma: use percpu sheaves for vm_area_struct
 cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-14-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B049114000E
X-Stat-Signature: rtoygi9soza1ocpr67wbapnfwytf1ouj
X-HE-Tag: 1757491305-364601
X-HE-Meta: U2FsdGVkX1860tMGxL8LIInL0L1Z6D3svmTIn8vHna28nJYuJ8b+Duw4C2nbEuo6axBkWyPD4+8nsNpENHFVUS2k/3GpL9eRKErLWPeoY4Re3xodxMKbtmmaMkvsOz5kG96rZDFODGDB4MI7PKDtU3+yzVz7KoSR1ZHkx48uiFZ0vlH8EKB7BYpEorhEVHouoxCe+YCLXlWr9JxHF/wwUlF/tQGUJDVWPkb8O5nr+PH3mq0badCy/fVJ9vMU4JQdzQq63aa5Fo36TryIHTOwYpMYSRj5DnAGbk1b2SwgZSlsQhyRDaH1QJ2CDQWS/1swSObQ9KZEC1Pw05X73wMWkCBkXIYZ9SKX+COvCWXk+5F+S8yosMyHgP79o0H0efTAZWUGtlUrWgbrsAMt8ZGayAf5qghuoa847weP7lLoUkFdEexT6RaByRRQdXaMpbkGp8q4JgFELwAkTFdfaYXtAMnzyOCF1JDPFAMhb77nrS9TS+gOdwXoGlL5cNlXOJXJbVweWo329G/XH+/o2gFNIvACCrW5r9T+C7pd/NduJbpEe31QoqsXPgvuLzWy06QVaH0DBMig4h2R36vAitA7hrjBJx6b5DZpMtzkxV6hO8QlUGtSGr108m/6H4Ew+dtkXQsD5e6MhEdW5dY1QVyNs5FIXZ6Jxn9BFtJVa+yMBomSXNw7EgAufOhKRyBnyPypPm8ipHsp69mAehzsxOBYZuLujNtucaziIdCyw8kC7zSO/yawUhJvoCK924jyB6kteIKhIE1pE7VXH/bdxXylXsFwy4wRONyWDxpuM6dC0SWVHq0r5GCU7776MLeE0pCAc6D09cvGKChHVFRGDCWvxKO3Nrxi9alttMV9is3aiS8cyVlpZgRWUFl4P/YkjYbopYaMaE/QJkJvSUYfBPIbJJk9TdshJEZpyIVntcU9+y7wEYbEbODHdzbyQyTZORe+vyAc9xE595ywIM5A3NE
 jRIOMbDL
 56usS14Yieoitj1pScTlz+4j8HwaUetyNERh84cWljyHpWc9Tqe5xs0sraXw2qnc+eBAKBxJteo5ji+cjBbxScm6u+sJSasFhOC5PAISWaGMRM9i8wcrAEPxUH3XpJyAon9yito74LEiZyTcDXQjsHCwVlbYkZ0w5G0bcT6IPNOVKJOKGoJ2E9wrciSQmabcDb4XOaTGM4xGmPBCgfyHoENrhk2oQTZe+PA+DCrwMV+96ONPhW7Oj/K2mOqa20Cbf278QNCfV8HMe14PGgXEUaBHaI7+4Z4Ojf/D8RUvILH8bJrHeWgkQnDpA24FKYiZtciJ0iQVxHKeApdv4B+Dgg9ai8hm01h3ZOXbo
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


