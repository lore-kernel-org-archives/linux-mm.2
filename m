Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EB0C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 04:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B85A6B00B1; Tue, 22 Sep 2026 00:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069D66B00B2; Tue, 22 Sep 2026 00:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE92C6B00B3; Tue, 22 Sep 2026 00:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD3F86B00B1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:19:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D4D11C2652
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:18 +0000 (UTC)
X-FDA: 85240093596.13.AC6C9A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D634C40006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:19:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmENK7hI;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790050756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3B9ThvTz5RGopdNhG1qzUIIExt5TxIgr3PrinYt/7I=;
	b=XsUHnU9kO50l+DwhF2bDHWWzosgYfeZNzSBwHq75i3TKaTdO2xp2mXETVnPtyAlDtA+J4n
	NXd9xA+2gj+jhFA8rFnhvmT53Z/Yk3R4gy0ZZCt9qXq7+kdCSpN9RjAzjr46OVk7fJnbhn
	scCsJhwI0e7LvUbLoOBOobqqKNxtu3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790050756;
	b=njiwxwIy+uQDiueDIGqPrDw2sCZZlG/UvNSDIPiTmxA6trRC1Xf1SyOmwfFkVRuGX9jH59
	3KEmRA2RwMbVeXGW9MrYr4IPxEQqIMDkz7UFhl/ynEbivvZWYheVn5C8bkaFEw1U6n1Via
	ET4p9YdLkySjeDlJYTFa2eROzAfpa2Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmENK7hI;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ED0B600CB;
	Tue, 22 Sep 2026 04:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E0E1F000FF;
	Tue, 22 Sep 2026 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790050755;
	bh=k3B9ThvTz5RGopdNhG1qzUIIExt5TxIgr3PrinYt/7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmENK7hIfI4nkqA98Oh/niUu0cIYksY6wSgej1XD5+GYL6UXYorVaivtQlNyJiSpX
	 nivALJV8ZrE7rhhAByx7cYv653GwJshpUX47k6uUQFnx5+BhDo2hnkqJvqBaKu8Kcw
	 5kMLFDuvGBAw1GqmMdPK2hMzY6yraEn+9mzKbOYvqVjynlIICrYbanO4a00LJ1hKGf
	 gt8roYO5nUtNDUk5yGSvSZ1FAZ0JvgPEoiMFQBfEzxCb3Y4jtyqy5ZbqMnBE30e7v+
	 Vt6XOWIKes5R7kUjN3pLm25oTTAPCGJ+vkJy+7XIE9X0KXiGe2DEjJC1NPnNwKtQDv
	 uQYg1gExUb+SA==
Date: Tue, 22 Sep 2026 06:19:08 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
Message-ID: <arIBvO3cFQ53ivG3@localhost.localdomain>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903053535.17611-3-kaitao.cheng@linux.dev>
X-Stat-Signature: hthseifki9ohzdy1ycei8oon8s8nqti5
X-Rspam-User: 
X-Rspamd-Queue-Id: D634C40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1790050756-235401
X-HE-Meta: U2FsdGVkX1/4BY1YTfdCoVnrQMFE2IqY2bkHHiBs5hILmtlAt1Vo9Ziqelvs5vkJAKQzQmNDixbaQVbjjrGquR/CHMlKmw6FU/wOU0GaSQornOxWh9bt49esfulLAeKBQ8yfPooT2px27pANQFl5egpO0ay/VDkq7qOnLGyfdTDkMx0Y4zygTUw00KWK4OOu9C0dPbx3Rb/aiZGtp7+ys0Pk+kOLgyTAyjLMgCcCvptpbeR/X4R4LmtJJB2PLtV1fFitthYgXKkxRgBBN/gXVMTjL56xTy5OMUf2F40ASxj3z3pE7toXNdbPvDkF6lxnjtuGqu03ktGBgsY6g7WUZlxd8OUFNRMRtJUkP61oFkVh+HxkFNr99CG1bnGPGWYB4puBwOq3ySMF2D2gq9kBy7uTGKEKuNXQqoCD4Sj3rnw097YrDYxy7nveGchYsg2oOna8hnC59430hPYN58odZFWWB1Kb+HrLh1Z2lRS7X9yIJqtl8hxlu9QdI2PgYZqEKHHfIdY6YIBRjedBLfkeQ44ZGj5iO9WZUNQzcKw5mAidZZvQyxY/RRI/AhMC6d6gXEtHdPpt39TAL8V4Eh5/aIUCt2AFP0KimETp4UPWqhddamf4uEP7jP7DJdo8bu/PDeOGMOFk6lP8lqULMIyeWSa819xD8nr+A8jDsi3y3CiIApxWkizfQye3XuzcC5X4nFRmcsP69Fuo18oe30z7wW4dVBEMyZHPoW7lvPZ0WJHC1xM9vRJFnqq2KBrNWjdJVomM69hgVTA2x/SYT+qYxKaBqB+qwWVkqcL9DVBL5uNIA2Vm8WBa9okHH0Zx3yD1Y2lWDqbgDOYSJTOymbduBLufGss8CUsmp/vEX2CDxQ034uLoQ+02KeMnQCRnHwEfIKFoP3XHLK6Pi3IqfHQZ23SSVGjzRMwF7r8eTP/oA88f02deSEe9mOcXBGXQO3Q4YBSSnsZUwosdw3s0zNx
 6jBRP2k8
 34JjRmWEHDBXYQrRPbXOSBS2E8DTuL210/jK5Y0rKP9ZE4pXuKQ5pI9kvfwmPA8foMSgzIkgDqHzRbfNCxNtSsjsgpD6wx83O4anX7WmsPuiYi2pqa6tf/1sMOELTfW44lr/uerIgupCWC7MG9SdsSoy1/Rvmnlaw6+g00Na2dRoA1fBtTTFX0ja4RZGH12cby83SY80z43hQiEjZRafOskv2ifDSKE7RjYhNShOXQheGJlIlpI6uNsIpiVEZ+sxPsKIOA2zbcGH0UEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 01:35:35PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> TestClearPageHWPoison() is now defined regardless of whether
> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
> handling is unavailable.
> 
> The test_and_clear_pmem_poison() wrapper duplicates this configuration
> handling and has no other pmem-specific behavior.
> 
> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
> This also removes the need to include page-flags.h from pmem.h.
> 
> No functional change is intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Nice cleanup, but as David noted, please squash patch#1 into this one.

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

