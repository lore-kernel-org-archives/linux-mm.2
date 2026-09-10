Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDF7C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4639A6B0096; Thu, 10 Sep 2026 04:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412816B0098; Thu, 10 Sep 2026 04:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351F66B0099; Thu, 10 Sep 2026 04:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121126B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:34:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EE67802B2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:34:01 +0000 (UTC)
X-FDA: 85197189882.09.1151A15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1608A100009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:33:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CazkhZSv;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789029240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htWrCuWloy0NONsft45RDstF/ATea72DavKG8+QtMK4=;
	b=J/1nqniRkyFCOEsT3ECaY+SOcuW4uc0VlcZP1AH5b84uGWeovyqkQWfergvvBM76A+vPjm
	m+y7GOJLjG+xgL7pg0qwKoxMHxANfyiZLrRpYNYHD6ej7Uzur8sE4PsW3J+OQeskdLDkC8
	QHx8iSbVKw4IWgGNrrtXVGxniR/zHqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789029240;
	b=UhJN7/i9oPoXUppXYr0UqLT4c+PqJtp7NK+F7begOiGYbtgZ7R6XNcNWiuguTpvfUTz3Zc
	MRR5vwajaP0K80wyUt+wtA+9yF/wSM9ceyyr/pqckG6MHH6Pni0+0pzMjPniIsxCoeJQpL
	ZVmxzm/nVVGIWcAaKE99JcxiAopRdNM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CazkhZSv;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70B49601F0;
	Thu, 10 Sep 2026 08:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8C81F000FF;
	Thu, 10 Sep 2026 08:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029239;
	bh=htWrCuWloy0NONsft45RDstF/ATea72DavKG8+QtMK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CazkhZSvT+O0NgogGiXHI0lYcotwsei+QChUnDurF+HYFaqB31jqAAsP+ioj1RnJa
	 slgoF+ChAAr/n4Lv1nBu2JaW3o+ffaESC4PwPQHVefTX1rJX0ZIIobfByVZPcIh8yU
	 cx/VjCtD++UBLeRhzdko4P4UG+Pz1IlPG0jvfelVuUSkAqdjNHPkX4ImE2iLnVR4zh
	 ECN3fzt4IyI8LStfLku08boRFArVqEJj1jo7jmqw3U74L2Mq2EXSNraAwkdMbliJHb
	 jqTXTw4P0h0kyaFkuFMztWx28m4l1WJ72RCkKhiHM7UOl5XVdmfYEX46V1wJWF6/8J
	 lsV+jOV4QvQfw==
Date: Thu, 10 Sep 2026 10:33:50 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
Message-ID: <aqJrblWch-lajp3k@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: zmtrmbqf5jjq38u9gr5dpk9sbybxhb7b
X-Rspamd-Queue-Id: 1608A100009
X-HE-Tag: 1789029239-814878
X-HE-Meta: U2FsdGVkX1+5s/5Qmwfsc2USgg9iZniJ30LT9SCtYmYRDAB5xeT6HzzrT39nJfe9mMB0MtQ+zm/ET/CS1pAfLShxe/BCGOpLvDD1fVQTzfACZPrY3n3McTx1mEhPYD4JAfh66iuiPeouSfwXiJartKA1JtLAZKHgA7h5VWfjUrS8/S8a1wuO2aYKErzz+qKKVQkHxZPAsc79uHBHpdNoubtZXxcC6w1aefX2aT1St4wNnYToHh36i+Cvg1cv+vnUZk7LLQPYyGCkEXCAXjkGNqXjLHvuZHstImYbCHsmSQaUD1zXZpY+YbnMk2/q15ccQDx6NlTKBjSFdI8N9NfCXPpzyUi875WUEMzOayX8jwdq9whnd228xC86Ltwi1svbZAO/hfL+XOLya4LUxlVYwu3VjwiDOl2o+FYCqAsTOMOF2/5A0Z3FBvj6BKzUU1XtabdOT6plIT1tJ4cs6MybfraxCAUsA0wZkimD+8ToJDSideUVzo1sTuSFIvWiGrDhZ5+YJp4jOq9SO1f0Ps1bKXHr9ifi82q+ZIrUbAo6GXIDiUhy6phfQ27ky3f3VkTsWbIIW3csvdbW9+239DmL6EQj+iPwTTdyagNBYlveb9Ze92lj4RgXOratIRfr07LPBaNAt5FOEzN7d6nanPGTUvDhgKeCSMEEJqtAXyvIKFt4t5D5AdarHPBIPp1OsKLAh6FY6kHnbQ+M8IEJXM560aCVifVgkwBFWJPCb4ch/dnRk+JK/0XUp2tGKPP032aNUxj0lA/T1PtdyQizmkBDj9973cXtNjGrMf5t7rGuEfH69e7Sq6U1sIs1GkAbD7t9SPMQ8xeq1HqhkBxToq4tp+bmnQ+1zLB9qxJ0TKg2ZKtnuK+r1gyxKzAOr9E0bppNCYB+USoCJeoCoUXnd3z/+g7r1GwDYAMqoVmWWzVpVzG+3htJ/surhfM5bwPy7pu6Bhop9oUSb/TsSHxM6av
 tVAkEpEz
 VsyKLQHai2Nl4Z/xuR4SG4r2xUNhA47LvndY1ImdLKdtEq+WtCez1rwo6zT77NsuonXdTYoPZU+Gys9Q14xnWirsCROUGT+s2R5AWwpVNPt/WuaXZVLCUe5CiyQHEgnDLXPvmeQcIprTgOkNtXp1Z5S6hlC6dFMx50Ur5nUpW2PI02qJzObYJVw4v/NFOnfOWUIr+2iD5u+kV7LLP4YXIORx7Z0tI0oQlrhfrH4RiVzunR+IdEPTjcKqPpDI8lEe3JULu+nQARPxmIds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:01PM +0200, David Hildenbrand (Arm) wrote:
> Let's move it to sparse_init_one_section(). However, to keep early
> boot processing working, we also have to initialize it in
> sparse_sections_init().
> 
> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
> Probably, something for another day.

What is the worry there?

sparse_init_one_section() calls should run sequentally due to the memhotplug
lock, so there should not be parallel updates there?
 

-- 
Oscar Salvador
SUSE Labs

