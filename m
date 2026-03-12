Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A54105A595
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EA86B009B; Thu, 12 Mar 2026 08:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A552C6B00A2; Thu, 12 Mar 2026 08:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957D36B00A4; Thu, 12 Mar 2026 08:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84EC76B009B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:58:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 550E156F30
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:58:18 +0000 (UTC)
X-FDA: 84537414276.19.8CB5F00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BC56E180006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:58:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RaHxunvW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773320296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWmGakTAuBOaXs12cOlovdF8h6ptXGeKrnQGoZnLCaE=;
	b=ez8xhnGYqtVk6NYSZV2WzmmDVWNXYwoWALrTf6t7RUk5tMi307+VjtgM1hJ8QlQR5ZFndj
	jQtQY761uD8S13Sopu0WWzmYodUZf7yeHNNvViBDCc/ZR8ZNqGFYYJCySudV+ZgFlHhxK3
	61PjFpl8zy8l3e7eepwBSOU7DfsbhFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RaHxunvW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773320296; a=rsa-sha256;
	cv=none;
	b=kcplg2HgdVcU/B6fGdyWgCzsXjzfEuW5jVtCUc+uWDWgz3S8UNDBLBnEylyKciLsRlbGWG
	ZboqocXr8IcgTM8GpVFdmCzEKHNKnBDbdqGpQruoQjRbYKopBiUhXTSSfLLFOfz9Du7Htp
	RFDfk4oYtZIFRjVuQ79SwmmrhoXdOdw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1863D60054;
	Thu, 12 Mar 2026 12:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F7CC4CEF7;
	Thu, 12 Mar 2026 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773320295;
	bh=gBep5553txKudcWrJjtiLDf2/nYBl1x0tWwim114nHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RaHxunvWc775N6DoRn2pN90dVZoeFWgrpJ7+jfJyZ6O3Zea15fV0WJLuDTRsB9GCZ
	 YA7K1fWEjJZs3MxMrKj3Jjdis6B0IkCLLELznFgMiATBpcCbbknnADJNDa42n53jsb
	 qeQW8XXXDJZDUbuS72taYDtkFt6zwVqB6pE+Iu88vEnsiPAgeenD5irTONM+XhQGty
	 KnK00EYdzl7UTaeQCi1WL/X6MeVvOr4fnhZwcltKpdfz+bgWBp9jLeN0yYZJ0eCMOp
	 9tZ972GKZjgFuHN4j46U2n9dhdz2AoJEBMg2BnPcz98Kk5cyHRkxRwRcA2eHyk2SoM
	 BsN84yxHZiuow==
Message-ID: <0761a728-34ef-45b1-9aaf-0e6c5c360299@kernel.org>
Date: Thu, 12 Mar 2026 13:58:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it more
 explicit
To: Byungchul Park <byungchul@sk.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, alexghiti@kernel.org, kernel-team@meta.com,
 akinobu.mita@gmail.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, joshua.hahnjy@gmail.com,
 matthew.brost@intel.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-3-alex@ghiti.fr>
 <20260312052831.GA60352@system.software.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312052831.GA60352@system.software.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC56E180006
X-Stat-Signature: 8pnseksyyw37egmko84cmgwc5rx4hhc1
X-Rspam-User: 
X-HE-Tag: 1773320296-803263
X-HE-Meta: U2FsdGVkX1+cQVHGbIL6wz0OYbajFqCTmUse37zuGKV0ZqW8SnY3laPfddeXYHE46QgXh4rr+qyK2xeq91X+NctrRZUcyo41DQW8U4gk0DAgUHsLJap5JJE0it4wR0JOqFzHaNfjcxtQC+jd5DsSa0Ib8zkT9ZKrZ85HejXY+/QVaCgbeXBUrsXQ5IDEVEP/hpcz+URd+wc2y7BzAabX6mrXrdTWBaxlTOJ0irw0Upg3z1/ymbLrFJefNDD9Ia4QxKrDF5iejDJMLjy/Y3huybsikwKXV5rANUPPEKRiqWKqHmxCm47TOBXMc0UqqBsdGd4LPdxrndVBoNEdjVKvkKrx+4TXav4IyxM75n1+w6nr25+COPuT07pbnjOr3gHrtS8BcJDht91roajaUQL9KnUxmffKy02fsb0/bvC0E2VigNFXg+vWpP5DoafSOtczkB/NiwX/A8t43GBaTmXezaFWVuK4wV5z8JP0+60hujxqsfDcqJ2NUZdPdH/25dz1tLoVJjumUouPP6WEqSbVlL5t8aBxgsKb8DprcalcaHbyCXOx+0BEwPGbU2ahbgA/fldADZvO4ZRlgLp2vWnOQRymMMEdEuU3CvEGf6m2yTIityOtEc+bQ2xvVbaudsde0vDybCATzEb4QXc50yt0oKpofIDijVMSB52lesvgjUFecUjNiOkYNE+590ac/VEdd5bDalAhg4LJTVwH2BFL3Q+UqrDZ+l/pNMVUybXcgo0z8B1lJJQXxUiFoDn3WdDDNMpwigZDLN4T2BrZ3uxuOOFLa1oy+ZB6/HOeNKWuMD750kFUwNJT8zznbxJ4gCyIRAxgdsOHQSkQOhU/YjdsJsWKWKjo1A3r+jt4Rzxhcs3y1L4KH3eFnsXNzzHcxW0EJw6TtMLHzMc2cBwahSckEvPy3HsOxioVkHanGJZwmMhjVqGt8o2Y/gC5vN5jkIBIMSdInGlEV6/o7pQ4ygj
 1y53mo/m
 R6U6QLW5lNlFQxRYn4tpgUxE3y8tununFkBghw68PVtfShDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 06:28, Byungchul Park wrote:
> On Wed, Mar 11, 2026 at 12:02:41PM +0100, Alexandre Ghiti wrote:
>> This function actually returns the tier nodes that are targeted during a
>> demotion, so rename it to be more explicit.
>>
>> No functional change intended.
>>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>  include/linux/memory-tiers.h | 6 +++---
>>  mm/memory-tiers.c            | 4 ++--
>>  mm/vmscan.c                  | 2 +-
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
>> index 0bf0d002939e..ec39dc3c39e6 100644
>> --- a/include/linux/memory-tiers.h
>> +++ b/include/linux/memory-tiers.h
>> @@ -54,7 +54,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
>>  void mt_put_memory_types(struct list_head *memory_types);
>>  #ifdef CONFIG_MIGRATION
>>  int next_demotion_node(int node, const nodemask_t *allowed_mask);
>> -void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>> +void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets);
> 
> Look better than before to me.
> 
> What about just node_get_demotion_targets()?

+1

Maybe throw in the mt_ prefix and call it

mt_get_node_demotion_targets()

-- 
Cheers,

David

