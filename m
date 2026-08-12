Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C6AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631CF6B00CB; Wed, 12 Aug 2026 06:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1BA6B011E; Wed, 12 Aug 2026 06:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D29E6B012D; Wed, 12 Aug 2026 06:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20BBA6B00CB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:52:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94383A02B0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:52:27 +0000 (UTC)
X-FDA: 85092303534.10.0F4CA5B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 84B3B14000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:52:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Dgh8EKnZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=77eZqBxk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="o/Cp2yz/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8UOVGQ3G;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSpsV2QEqj7345TXc/IC/jKaxhWsafTuvXiJciVUWZ4=;
	b=vaXRN5luhywxU29bQ1QbEoj2EXYwxHd2QBhXzoAsGNdGbIZf1i9GrQuh9PxjCAua9CcnR5
	iA00AJ6tFigrpaE0corSvDjyjfaQAxWsZBwiJaQr+LxlXQ0MaBIf2RXHNBdbwDWzitSa/c
	E7a5l+HgSFoaDnKCgfY0t2J0tF0wpyg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Dgh8EKnZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=77eZqBxk;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="o/Cp2yz/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8UOVGQ3G;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531945;
	b=1nMsW3oRXCo7QVWHTHvqB6+Se9FM5JV81Yauq3S3k/DQGPDE1rflVvB6vHnDdY0o6Jdwbq
	CdKf5YyJA7W7zjBZXQ2UxBVrS9ilTRZTWNlg2BtfW6od1TMDLEMuhbU1XMw8H8SCwzL9m5
	APDMjzhYlxy5vdLC/O9NcBrCMupB9TA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2752D3E4A;
	Wed, 12 Aug 2026 10:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSpsV2QEqj7345TXc/IC/jKaxhWsafTuvXiJciVUWZ4=;
	b=Dgh8EKnZeLCtNZQqYb12z548wjZGWv32QaeOfazH3Lto0xyIpv8ru5MXIeiUbkdqxnsJU0
	bHCkUnixKHiH1l980XOfDG8Eri7Iih1AS21oDVtLz6DMC/UvDCZ7R7X7WptYvxst9hLSBn
	ZC5iZEoEmT4tU2Ze+Q0gqWdbDjgaA04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSpsV2QEqj7345TXc/IC/jKaxhWsafTuvXiJciVUWZ4=;
	b=77eZqBxkHD6SnP5GbxOcK7s90/HB90NqdF2I6zlm11anWjXbDNX37gK8ERk1wlJAiA6lFh
	unbVU+y36+YnfTBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSpsV2QEqj7345TXc/IC/jKaxhWsafTuvXiJciVUWZ4=;
	b=o/Cp2yz/lFLii0PxE2QUbFNA0McVpi01R3Ew3RpiFFsvHrttbpI4tyKoAA4c8Ms0ZkIp6z
	7UvPd+HNrrYUSLQXS5Bn1eE3TjqtrbS7WS/6cYTslvYqak/tAYARM7DQ/T/Za1p6EqtUYJ
	KMqXtlkIugMm/jPSn1dv2i3ODHrH4mU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pSpsV2QEqj7345TXc/IC/jKaxhWsafTuvXiJciVUWZ4=;
	b=8UOVGQ3G6ZimPrMtVkIO9yuCQem9Os9u+Wb21HW75y6YpE0HtjRO6OfJDetCaemd+cdxCK
	cA9TsW7j3/HkKAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D437A779B1;
	Wed, 12 Aug 2026 10:52:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DqhIMF5QfGoOTAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 10:52:14 +0000
Date: Wed, 12 Aug 2026 11:52:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 7/7] mm: Documentation: clarify where the mTHP stats
 live
Message-ID: <anxQTcDupfEyoN1F@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
X-Rspamd-Action: no action
X-Stat-Signature: kzkffdyuo8h1s4ccjdgu1nxyscqzxsns
X-Rspamd-Queue-Id: 84B3B14000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786531945-656443
X-HE-Meta: U2FsdGVkX18hCgDSHws+jr947z3C18TkBveFzQUUGQ3ZIFHaHylZ1RRT3SvMYiIsIjzcnUK6cEjLZDK5A4oF3oRRmVrWQvM/3VNUXMlIEZYiZUCB7hhLf+taJLSZyGMNQxXnuCKK+4OiLlQdrbGAgK75A9eJ8gAlzl7AEiI8OqvFvUN89nhy/jKd516AUwNV4Qz08fex18nWxO906P6JtdFNMNQVdQLoMlEEuaRINs2uEMn9DdS3+tqRFJJ2OBf91SsJPd2oBR++0bd6YtY2zBfhEnhQLtgy/8NxvWikZps5SCN4vPrVZrC5PP6+f2/STfdgtVnC7+NNss0zDk3WXJTm9e/jd14dH+G240jNaS14xbXQbFxlaD3+XIQxqkevdYUlCfOyCPv7INDxgWyMd1y5lmou+87I7NdFr1+/Sd5GCw81QFiWLnOCESVE8RFxfQeCZc/xtxAHqO2Fgj5VrVWEv98sddbDVlAvVSY97jGk3pXIo4Z/qf3b4ZtKVWnRc9Cd67MO1h9xbCBOuniHPGmVT2DySBhh4ziVf6tw1bzmRwjVec3dG+m+BZiHY/2dX5cI8IF96Pitk5akZMTiqVajMkuL73aNWJ4VS5YL4zFa0xSupPk9MOKDj5038/Ann7mR+/wWZ9hzY9OdPPKkiTi86CU7/50jw3ug0oIpfnBfw56TBhk0REBT+laQZnpsGr4j86noqp8jHOnwIJLBNPKmX3Djw7htlfBYPPUs52YJjrDRW8yQpBK6XiK3iVirp34GgB0EcC1RzevVTD+iDC78c7EypodJdfP+8RtK2SOzv5wKmCJvVY+9+gcqZa0Nl288xXbvWe0k9JxKnAVEkuKurcpGg8cWKRex2ixxTLny2eyvDX/kSkVAXQiOkSs3rpCn1iMtrWh8Lv38jVHou1gWPy6T2aTDuFRBuea9FxeR5E/X5Hrn43lezfspVWAYY1LQjs4LroK2XM6LETf
 wCUsdbIE
 UfmfbIwgsfN+K2yb7u9PoIHNLwVBln/+7nibDc3tEhWE3EpALQo1Q1xKIqII+3j7uyUICt3SUpQD2Jt0VfqqhWg8l7osRoXY0Ije/znzzJD9TqshMU18D5HtIcoYAxkv8qh7R5+ScZ2cekLiFg4Z43dounnBtzD2pp/gzSVi05M5hNs6DqxoMOo91d/GDdace+PJ/pfBY097aLwMUvjnCbJ8jQ3PkYDbQzb6efOr+VME7kMhSo5i8REd44GB5GCfW5bd6TjTSH3U0NCfNPLLFKvZmQQ2qQN1J4mAwJcszuqkeGchEKoUWBaOSHr8JybVikfQymeNghLqmm/78VogBwT9tX29dQD+naG7d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:39AM -0600, Nico Pache (Red Hat) wrote:
> The note about khugepaged counters references /proc/vmstat for the PMD
> case, but never mentions where the mTHPs stats can be found
> (i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
> Add a small addition to this section for clarity.
> 
> Also fix a missing period while we are at it.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

