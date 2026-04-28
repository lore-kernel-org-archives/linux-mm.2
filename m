Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9BDFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7D56B008A; Tue, 28 Apr 2026 05:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78806B008C; Tue, 28 Apr 2026 05:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967656B0092; Tue, 28 Apr 2026 05:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 810216B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:17:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 374D21401A3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:17:24 +0000 (UTC)
X-FDA: 84707411208.25.5C8BF4E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0AD0980002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:17:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUgg7TRV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PvulbjN4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUgg7TRV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PvulbjN4;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777367842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adxW3bE/UIQhlebHqAzO4xAfXbzuOewNVGi1LVMnILU=;
	b=V3Z6KFshpqwpoYCLsNs+c+q6g/6oveM59K5LBH5G0G+0+9fHHvmCLuhJYhvOFa1EP2nzSl
	hkQHAvsyyPTvhHata57jxM5BorlPCaZXRBnQwPxpAAgtUhSwlwqhdpy8w4zqdhTHPU3opy
	4Plywg7nTjuREnlZ6g47QEqa80zhVps=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUgg7TRV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PvulbjN4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUgg7TRV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PvulbjN4;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777367842; a=rsa-sha256;
	cv=none;
	b=k99qQngjbiwfhWVHf+G+BOQumTS5iXAKfwOQVnmF3TGT9rDexhEfKeJSHpXk9xHeqNoXb9
	zdY4mnJHtvwmar30Pbr71TVX4lAIjt1g2wRRjNN1TW8BSlt3vHylsKbNKDQwFpmscoHTQ+
	hgrPWU1aeXnPlNj3R18TjL9L5nBIEpw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7AD8F5BCD7;
	Tue, 28 Apr 2026 09:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=adxW3bE/UIQhlebHqAzO4xAfXbzuOewNVGi1LVMnILU=;
	b=kUgg7TRVOIvhvznpuoMH3QRC5b4qXvdbH9zq8EU0zh9DZEZ3iHH48TrwTops0UY3vsC9jK
	CJs/XrSVUW2pRq0/HnB8oe30+REtCMWFyBNoNp+tMdC/Y9qPhHJ3JgmrDPTkX7Jt4BQOAw
	bASmqtJMW6jff733Qv/IU29/QQ05ddE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=adxW3bE/UIQhlebHqAzO4xAfXbzuOewNVGi1LVMnILU=;
	b=PvulbjN4QowOK2dqawYsA6yf4ixa0za3ASQd7XJZ9vDerVbkUEn3HuEc+x1VaKyjN/Sx7G
	pyNk9z8KSSM0kCCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=adxW3bE/UIQhlebHqAzO4xAfXbzuOewNVGi1LVMnILU=;
	b=kUgg7TRVOIvhvznpuoMH3QRC5b4qXvdbH9zq8EU0zh9DZEZ3iHH48TrwTops0UY3vsC9jK
	CJs/XrSVUW2pRq0/HnB8oe30+REtCMWFyBNoNp+tMdC/Y9qPhHJ3JgmrDPTkX7Jt4BQOAw
	bASmqtJMW6jff733Qv/IU29/QQ05ddE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=adxW3bE/UIQhlebHqAzO4xAfXbzuOewNVGi1LVMnILU=;
	b=PvulbjN4QowOK2dqawYsA6yf4ixa0za3ASQd7XJZ9vDerVbkUEn3HuEc+x1VaKyjN/Sx7G
	pyNk9z8KSSM0kCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6FA7593B0;
	Tue, 28 Apr 2026 09:17:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YkB4Lh978Gl1ZwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 28 Apr 2026 09:17:19 +0000
Date: Tue, 28 Apr 2026 11:17:14 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
Message-ID: <afB7Go7JqhIpjU5J@localhost.localdomain>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428085219.1316047-4-songmuchun@bytedance.com>
X-Stat-Signature: e41p1h8xwoikxwwg4i4j6yaykeogjpm5
X-Rspamd-Queue-Id: 0AD0980002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777367841-763775
X-HE-Meta: U2FsdGVkX19r4rpyC8gS8n44RQP7R43Cas1BZtVBALWWztdMN+s6XjxqxZzEToFWNOV7e88KGwk7aj0xrytKQafMo1nimTPMtakkILhsRgnNhm5iKEeoKsYkYgMpmlBxnPXpGSwkX21g9FKXeNsUA8tHsi8NnOpvK6zn3hP12iLIJVJoLElkhf+du2xTxmmR2c+22RHqAKErIH1QzYPdpxjtAFxPbYuImIr/iRJQfdk1UzHuoaMRi0v0N4F+27AE3sDvJojjpF/G9Pp3Pqj/cQdaoNbcs1HN9VPPx6kbchiV5HjLxrVLc0XaBDTzSlk5YJvHaWJJiJPcFfWOanyrVyPzgSpdh2UdKnBt350WiK1foVlXaONdwiCHAu9q/5WKGdni5rOBcixoQ9xMz1vJvrVfQnj1c/oefDynatrAuf+4dIYaNnL2bOyVjdLGN5H0AmItLB8lKvW4V4uIOYWEdrOCJzk7Ls5iXDSmFcHlNwHUa8OQFE3ExI7q7vZOQbkouURtp51DYlBAVq5EdXdoSpPZveto+HEleRqcU2hPp4ABVEBF6DQHkjlEgr58ceBKleEs07JjSuO6hphGIpwckZkL7iu0ZFitiE7Cm5gYmsliM7WV06CwMG6B+FtN+p0tS4APl2hwIJ97TYDaLoXmXtyKdSu0kucmKzuhemYHn+B85pqHlC7uWfv3S6E2PN2uNiPrXRcIogJo35nOWfItodccF+VH8PqhNugeyauUFHyEnA1kiCcEBrHIJk7+sFwm+OqpT6XPEdkYpbfZ3GTvPi9pDrXk7jRr4gAYCFenanYHjkVrgp9d0A3CvdtRnytheDYY5ukmSB/ntvaVXGLM24xz7vrq2ShlpmpPY4sIlZi333qe1sekKN/bXV+VDO5jZVU32fSiJRX3XbUUg9tb6Zo+iu3KcqcKymkbUXhXQrFxV5WwDS0KmC2h6Rw1pJ8NNMprpF49iCSp8s9Afke
 QEfnVEgO
 zN9D0rrAsdrpg/U1fm5TbFr8xSLGt7Q1DnQK0zk2pEwV98bw1QLUF5lxLKBW8F48grEOpYrI5sUrA2f8AK0S3m4GTzuiDi142AKB1acblOB+NVrWaPa8eEUyjKPsvtLwsjgNMvcNV8UBs/4hUhFuxfgQMNJu9un9jS11smYZYK9wxA0+W12+JmiFkeS4H3l2s9x3ZAbtFYfjFMctGCOqIJSYlAO60HfV27X+e7IBaUF3VrudSiOCHWpRu0ABce/kwLu91EVfXXGizzHc3Y/CHp/9JB0entzMHTPBYwcvy/b9RUqUhICLrODHwa5xDYcDBQZOkJe13pUVwMwzAAQYcIy3ypculUbf1B0PaSmHvFQ+luAQs+sJhhj5Fb1Zk+N0EX2sz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 04:52:19PM +0800, Muchun Song wrote:
> memblk_nr_poison_inc() and memblk_nr_poison_sub() call
> find_memory_block_by_id(), which requires device_hotplug_lock to
> serialize the xarray lookup against memory block removal.
> 
> Take device_hotplug_lock around the lookup and nr_hwpoison update so
> the memory block cannot disappear between xa_load() and get_device().
> 
> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

It might have made sense to join both patches? Anyway:

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

