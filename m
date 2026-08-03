Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFF3C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478466B00A0; Mon,  3 Aug 2026 08:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FF76B00A1; Mon,  3 Aug 2026 08:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365A26B00A2; Mon,  3 Aug 2026 08:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 132586B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:52:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 681A5406EB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:34:47 +0000 (UTC)
X-FDA: 85059902214.05.97F2A80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B121740005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:34:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWiG8wLi;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785760485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvxejhTP4YjhICa+U9feAto+gAswzfWwuxi4C6BTOBM=;
	b=rdqT+l85jqPekt8WSnDOqjE4AnWxlu+Zf+CGl73bwW+jPfEJeZFR2SmqPdBmXsoVEeEKAN
	Tt9gJnVj7tWemCWkjH/qSwGL8cO2hk0K23EuDb0a8ApVqE+ew8+xeDoAZOzC82HxnHhZa3
	bUas0aSpBtx4sLqO9WmkaRgs2U2ZYgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dWiG8wLi;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785760485;
	b=X7Br46NRm9Nvx+eQ5+r61Z82F6YdcE9NvuNGcMd4FkIxz4/o77qCSDs9THiRSBxfaQ/Ome
	gZ1NhE5bK5O6r5IxaJVZaD22zWgHXfou+YgauLlhLWz17rJnB14q6gEDksLBm11UpJeNE2
	TmesUxNsdzW5Yv7IAJZDtkuEDqtF0D0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29C3460A78;
	Mon,  3 Aug 2026 12:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777DB1F000E9;
	Mon,  3 Aug 2026 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785760484;
	bh=FvxejhTP4YjhICa+U9feAto+gAswzfWwuxi4C6BTOBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dWiG8wLiIGChnm0xxMpUtGn/AJjxURBqLwsiYwR5SsU30zaGZ7v44kqC1i5F/V43E
	 gXExPllep59KzmJXmKxQCphfepcfWHZ5pGMCsVPE/VFBIYm7A5T1QxNRMBKMA1+9gW
	 NGfJrZMhyzQN5IHPpPONZ0t5ICuctB8tj9p7yDchv+y0glP1MUHmR+H641GzeAyidZ
	 F7ET7iNpvyfBfcjTqTY2e7QOmGgZONlU4p4ZzD5TsL00fgL+z1sPDkQ/8CHDi8j4pz
	 BADW+tayOZX3TMDTo3FL0zDDxdknp/nRnc8BA+crsdQT9ztnmnFLUlnm8++Hjg9waP
	 p1X7EhtVuoF0A==
Message-ID: <6e594ae3-88ed-44f6-ab92-091955cfd14e@kernel.org>
Date: Mon, 3 Aug 2026 14:34:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: remove wait_on_page_writeback()
To: Tal Zussman <tz2294@columbia.edu>, Ilya Dryomov <idryomov@gmail.com>,
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-3-6c35d6b3ad36@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-3-6c35d6b3ad36@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B121740005
X-Rspam-User: 
X-Stat-Signature: waua6xz45mqekkcscj8wjpd994axhc99
X-Rspamd-Server: rspam04
X-HE-Tag: 1785760485-88613
X-HE-Meta: U2FsdGVkX1+FDHDv/6SZQLkhvftUNXw4OBABSaK1JeMv5ffM4RzQxxwpF4SEW02EYHI+GbT+XNNK73SAvotwbkrvP8W6va6sP0aFi3jjrLM5RrolSTuZL9eS1p7js2ad3unXVgzkVBmSxp4EHJWy4o6HAdbMPeBzEaADz5p3OSREwlPB06LmlQ3OjyJvoZtzIX2II/NFJGVmDlFDW1rK0AexNOW+JO8/h1Wzivg+MC6T+m8kI7WTa3l7ogIGRyvj5D7jhTsVeG1y6RvYmtgcbGltBMCDJAR5ysCUhU/67WDoMU82aBqjrC+jSlaPeZ3Yy5E/nmHj9CRFR7pjeyD0QVHpUHzrYBHfW+5ZLG+5oCb5jiUA704J9z4I2ERkso4iIgdKgyi1m9kre7PqQ+Ev1EqHNV5RQ6kDAVC7mOg+/Qw9Jjkr2uYSBcMWyTOQnlz8d8HscJH8IiY+fQXpV9PcjzzVqSmctxjm69ExxRlBIX4/foYSTdd2VDyy7I0QbtY1Yv8rmUpN6Mr0B1CWCZNfrpErxoqL6KOLsBXxUXuL7uGgZ68+6BMKC/STfmX74HyYne+vQz2NLjvk9ou7TSOPjPVlrXnlMeRsyle3u+f8jMa4YqzPONfqMeO1XlgVEnJ/wRR8YaN58YLccxcx2Ejm2x7al4ppNhvo8/yIhx0Tilj80e3dxFhj9+uYMM7kd0SQi1+IGqWRNXl8mPhrla/hhyISEm1Fw6coeN0ubJxr8/ehxxIIrVXmozr+LMDAZQBNNEg/MwYrSp3kMrErYS4c4L3Q5zypgFj84j6SjLJtev7+PbJd/6bZ2nrpGZUwmRMH9Ccl6cVMwz9RfUnq/eVXmZLABoysPxirTFRqSMA/A91UoI3ncojLNE/p62hzqdXR4+NbWze8/zZM9K6CA7HFcsXHKIqYW91hgFtO2wSGTNjMuIUS+DtH3eUP6DjGuyywLJjTQpRUB5GdeFqxF8z
 JzYYgV+K
 ytcxI79w68+X0zJti1Pl6/BezvbqN3rjHJY3CNUziS0yar58ms/D9fI1xMhVCjFNe3xr41ea6dS4GVFlC0VZb/Hc1SQrseBXPoBas5rLYkARDQxM+oq/7jw2XiU08Ph/+TdSDrd0YPfke80tCU3r6PqsXw7wOknFbLpRfAS6d1/otrMDcquWETLDMDu4g2TXiiSPVdXTm5WmBzPDVNaeXejyxik/Fi52OCOBqL6Jrp+/Owq30XKngTX2Mv4ZvwXwYyNKGev8e8yP7HRV95lrnp44TVpc/QT2c8qIKT9Jf4Og/vJl/q0GmsLcXshKKkmZn1YOPr1AxbddFgGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 18:50, Tal Zussman wrote:
> The last caller was converted to folio_wait_writeback(), so drop the
> wait_on_page_writeback() compatibility wrapper and its declaration.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

