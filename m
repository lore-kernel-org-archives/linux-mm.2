Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A0AECDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAFA6B00B4; Thu, 25 Jun 2026 22:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC946B00B6; Thu, 25 Jun 2026 22:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2246B00B7; Thu, 25 Jun 2026 22:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E052A6B00B4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 429DD16724C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:03 +0000 (UTC)
X-FDA: 84920524206.17.97FB407
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98453100007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xwJ+3ggx;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441961;
	b=Rhq2qeuvsK2MqnqZ5TbblTJsoBqejNwcJI3QrR869GBHj4KVGx1VUZV4PrfDMEhSaKxsG8
	xLRfyKHtOplrzahdE7llrDOGipcrIoK/pw0bEF0jCh8Tm5bJ0HAe2fzMWivjcRHUvNZQKH
	BDun3wg2mSb3EEgPT3vsXnZHkgDwQUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rcZP6aQpQG/oMe8abtKhEa8WDtm6cWM664IInmlteCo=;
	b=Qi96kduHVDth5OH7SmWzOiCdOweZb5qaXe+M2I5UaJNB/0Wwa/tHCZGJGmQqVVkv3cjAOK
	wMPysBereEtCA4LPwRzLJUpJSGgbjX3dDCbY7DcFEQTuccX441180u9jYzJYn9iVXk3mYh
	79Ua59OW66+4zwTkMCW4waAD1p4VxjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xwJ+3ggx;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rcZP6aQpQG/oMe8abtKhEa8WDtm6cWM664IInmlteCo=;
	b=xwJ+3ggxbWniXcN6F7c5ZZUTIYk9J2BnOGMNdafwBU3XmRYxXVPtWMZQ5ddQ2vgkLBFuQI
	OO6fsoTucQtTdVT3fWzlSpt7/dXvgDsc1vRVTh/Ib3pKkQ3y76O/Yc9Yw2Vhox/E68HSRw
	Ldpulh+SsfpMdY+JnXbnNSnU1hUsUfE=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] mm/page_owner: misc cleanups
Date: Fri, 26 Jun 2026 10:45:39 +0800
Message-ID: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 4xjjxpc3qsxahnrtw6shys8cek84ze7p
X-Rspamd-Queue-Id: 98453100007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782441961-238965
X-HE-Meta: U2FsdGVkX19tiRJ9j8uAoaGwOHAHEdfr8xxotUOnQFrJMCBfDEwAvRoVo4gqFDxsE7Boxg73K9l+k8j8wafW03j3dyMgAXBwowqTdzkDQOJSk3wgpl4QkNb2AYz5kRQ7z+yG6BSL2q8ia7XCHSAQSDnqPfNX4EsC3uRkOQhoKRMq9XR43cSrxFoJc502gNecYCjT0lvx0e0ceZclXCHZw6Atnrom0Cyu+8Yo2g1oMyZd6GEEfs0TnSgpugvtY0GSOJ1j5qUPaShcHsTUlntp+rbqCx86EtMgnsboRLyttcG8+4IbPKlokSQzPTnWAjFpsBY+7fkmbi/h2PPUfl2pHpYWNq9CXOVBhPRjZiHXp5ZeTSanD4uOUX1YgKL3Krz/ejgCtVlCjg+bs+95H/VjKVH/zeiaMkuKRGW7e4J6U03rMgyixeklsbVkJ76Pp0t9O9ET8dr6Ea0pykslGmqYuFK637CdvUo0lkNE6fep31Wm90+xmDOH0f/tHWAWBAqG4UZ/Ch/qOguZ9J3ANQ0PaupIcGOnpOfy1IAJiII/JBD3lZmIJDUd6pbQeW/9UG/eXRU9em0BUVKM/C8e45EX0f6TKJ/oIGVQ0poHc9sstbIak1EERl6CEEyyVV94m8cNl/1AgDE8W1u7sbGRTndLuwQXdlJ0wZWD5x0JN1hU2l6bwnCNP9NDtbDI95ML/9Hv27CLlBIsfrtVoT28WFWzY8nk4z+FWJ7Y7Q9AkUe7zEzWG9499dCgf6bRBv8XryE35s+bGjQoow7D8G9rWbqaVL4ja1HNM2ojGVRf4kb7htbzomzRW2LOvQHnx0HDdXiCu8xYAFApjqc5hmqeRncgFMX8RBMWy3ZiO8XslOzIqsV7fdCB77ELeK8Y/Z1fQFmU/UTEr5adnzxbfb+k8wgsZjOsvDyA2cQS1u9sCm68GZSdL+dMRieKus3xQjZ0O96FzPQ3wdjsfj1VoCUI79f
 ood5W7HY
 iWNRUMqJuht1dGT1MXbxLJa6zbn0tGL0RwxH81ilzPszF3/wovrvds9rLF0131zZu5XCh/RgLstOamghzclf9Ey0qAKFuZMiF9FvgPOW8iqz2bRVyMj0QGTT644UwC7btO/dysoNyZJE5xqX90otpIfXUo3EwuT7iEEoOX13rpsujzU43lBwX5MsYY4u64kmAibubWPgk1eC4p9uNe+YPvAqx9UDY9CGO/1LdDPuv1KP5JPth7RzTeGwKcjoduyoSNnusuYrRQdn8FqsuBajH229+mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2:
 - Add cover letter (no code changes).
 - Link:https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/

This series collects a few cleanups for mm/page_owner.c that have been 
accumulated while reading through the file.  There is no functional    
change -- the goal is to make the code easier to read and maintain.    
                                                                       
Patch 1 consolidates three identical PageBuddy skip blocks into a      
single skip_buddy_pages() helper, eliminating the duplication and      
keeping the lockless-read comment in one place.                        
                                                                       
Patch 2 replaces the -1 magic number used for "never migrated" with    
a local MIGRATE_REASON_NONE define, making the intent explicit at      
every use site.                                                        
                                                                       
Patch 3 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.                         
                                                                       
Patch 4 adds a missing \n to the count_threshold debugfs attribute     
format string so that cat(1) output is properly terminated.            
                                                                       
Patch 5 moves free_ts_nsec from the allocation summary line to the     
free section in __dump_page_owner(), grouping it with free_pid and     
free_tgid where it logically belongs.  This also makes the dump        
output consistent with print_page_owner().                             
                                                                       
Patch 6 drops the redundant page_owner_ prefix from file-scoped static 
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide 
across translation units, the prefix carries no information.           
                                                                       
The series is based on v6.17-rc1 and has been compile-tested with and  
without CONFIG_MEMCG.                                                  

Ye Liu (6):
  mm/page_owner: extract skip_buddy_pages() helper to unify buddy page
    skipping
  mm/page_owner: use MIGRATE_REASON_NONE instead of -1 for
    last_migrate_reason
  mm/page_owner: hoist CONFIG_MEMCG to function level for
    print_page_owner_memcg()
  mm/page_owner: add missing newline to count_threshold format string
  mm/page_owner: move free_ts_nsec output to free section in
    __dump_page_owner()
  mm/page_owner: drop redundant page_owner prefix from static symbols

 mm/page_owner.c | 121 +++++++++++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 54 deletions(-)

-- 
2.43.0


