Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB653C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58E26B008A; Fri, 18 Sep 2026 06:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09026B008C; Fri, 18 Sep 2026 06:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF84D6B0092; Fri, 18 Sep 2026 06:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC416B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03B67A0632
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:59:28 +0000 (UTC)
X-FDA: 85226586858.02.38C793E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCD37A0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:59:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EInWYjd3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lB1Oxv5N;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="EwAOVwe/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2YsIelFU;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789729167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOJeqwwdyN7Rfx+8KM2mx7P+agbiN1R3+YCRT68JAO0=;
	b=O0znd+h9r8xEyQ25N9A3KaBCwKpm41Lepfr+xD29MJNGKZincIYjEdOIDjzzYk3Se/ZrBe
	aleB02TrvrLMsbKmfCXBY5Xigj4ThvVhILwku+a1oY7jc6H6XNMFEXNJoydHuVrpXBcXf5
	KN7CY+S5l7WFDqX6G+pyF0e+9X09AbY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EInWYjd3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=lB1Oxv5N;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="EwAOVwe/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2YsIelFU;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789729167;
	b=lKHifVHomgDCop1keTrb5IoBvnQ9Y4twvgy5NIWUs2VnvYlW4JGCATutRmLfAT2mM22mhU
	Sp455L0Yq6upBeakgsQ+6PO1WRsa55IM0CgvQedwZnkbBjKL89IH556VMmBOCjbDnyNCEN
	3hkF+uxUw4Z8M6Y0PZGrRsYtzCaS9t8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32D5A21DCD;
	Fri, 18 Sep 2026 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789729161; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOJeqwwdyN7Rfx+8KM2mx7P+agbiN1R3+YCRT68JAO0=;
	b=EInWYjd3wIEndLn+ncg16Kv+zlddW5yVr5w9o60XUCdtX5Px3RiLpGJDsi+LBxXg9RSSez
	OZY/ozOIu+8i5LiGvEpuVXP5GRwANhkMaMjJ52bh9bmHIzRvAHc5XPwgrpnqQe2s7C0Ps1
	BbLQEP0WupNyuvduH1sYaeLrW2oBI4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789729161;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOJeqwwdyN7Rfx+8KM2mx7P+agbiN1R3+YCRT68JAO0=;
	b=lB1Oxv5N0Vp7QFFcxurhoN4s4UL7Q6CiABKWsjNecsKCkg0cdxPXAdS7G8iHxmF4kavJB4
	kI75+HmlGnYeOgAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789729157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOJeqwwdyN7Rfx+8KM2mx7P+agbiN1R3+YCRT68JAO0=;
	b=EwAOVwe/O7Krjm024KAokp+SMBqLQdtVQduoVoqDau0C2i1pQ0T43em24ibX/ey5nHWrOK
	F7ad4ddfgKH2kQ5cqZWGU6j/UB1OEEBa7b+WMuBj/7GzI+rNPSPZg6cyq0M9IAH48MwFgA
	8g3qPAMWeSf9d4nCso1XFhc7nkfGQlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789729157;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FOJeqwwdyN7Rfx+8KM2mx7P+agbiN1R3+YCRT68JAO0=;
	b=2YsIelFUwdq0AneCoq0ktLKn6yAxxvNR2JCTmxkx1MKbQyQXnBmOJT5wbQjqdqKsRGdLMP
	rMqjMjvAaSP11dAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F050133CF;
	Fri, 18 Sep 2026 10:59:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xIqhFoIZrWo6HAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 18 Sep 2026 10:59:14 +0000
Date: Fri, 18 Sep 2026 11:59:12 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/vma: const-ify vma_assert_stabilised() and
 associated functions
Message-ID: <aq0ZTaEHTeGEgYCQ@pedro-suse.tail5790ac.ts.net>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCD37A0004
X-Stat-Signature: pnsttuzam6ojrmgqfypbj1ejbiosm4ed
X-Rspam-User: 
X-HE-Tag: 1789729166-694360
X-HE-Meta: U2FsdGVkX187cCqkBOd2dF1QievHTitTO6apOPq4F2Pxt6vzfWo2ga9iaQekZJR8TaGXzrlLekm4PDjqCo8bdZH8i0H0+0sviwH4cm8u7eiNWcoFvSTLzlaTQJT6he4SB6UVkbCnH3Ai5VV2QyByADh4GJSnzc2U0taUqPcvE3XXgbI32V8bWf7rH4XGUotwK7t4yIEVJJ8g6JzNXlFYkTu3r2/eMX368106kWlqRceczzfJhJnVxOQ5ZxvrPl2KP/5yqgdN4+3CHHsY6XiST60zGTWoOl2Ja9/47x9xEU3V1kn5kE5RS7L6MHEHQ5ThCo/+8Ybc+yv3gutZ4kr9u8/jtrlaOTkjS8mcPKfrdf8xrwx6PdJR09ixpGix3muJddvcivekJVdPMb5FGjeocaNHkOaGU9//dBUPezTTAZOsV80tqQP7/44wM5VDjsLg+YjxJblpEK7NVcf81xjDDslmZeNMwzUFJPGjVGr9IJLt9vYArjxlPmO9T6gCWkTe7quIz3v1nFiaX7hvVowi6ug+hXNuY3yMU748Q5eki1SRc/w3Ic1yPzSUrLD3vBBqlE7br5h44rkhttAGfUWtSDyABbrw87i+O/tyCbQs9SonIdAFT3KnIH4OhlvGQEF5jGZdahThsZP9h+auBFESgy0V4r0Iu0G5Eu8gInMda/w1wV5F7W5xzLpiai2yAHjlnqwR32+rTnlMEIiTg3x3M4xH18JV3Z6imsdc+vs3QTfvVUCpecX9q/cR+jrlKd058CKnkLq4/ThbwvYHFkIu6fiH8vzvXkzocs6+ZlinNrL69/SEVL+5/udnPirRaqYFlgluqppnSbLD1pBJl7+cktrWIouQ4RQgiNn7G3zlvNYD2+UeYR0OHeXn3lc6T6ZIaoioumz15fRQvxDwSJIQcA+9Xz3PvsERc95IATCtA4jD38903KpBVVhgHXVte00jkvpy8Dl9BuEx5uEu8xd
 XCL58Ibk
 0lLSHIIeCvB1lPVjnJI/WV8KeQTTHQ5iQLvYoGfTAULeLZRLNDHF+R8dqHJnINVtNK7rFrdB8beyqj7b3vO141MYklfOU8rwfkkgz/plSJ5khhxPa8IMFMF29IV4zewWqIfMVxGgvGUjRhnl14mUgF8oD5TSQk45dWmWoR0fnKyam2KLevg6l8lq0Vm882l7bOuXyYAcBmgI1czrJABV6Z4qlAa8nj4egf3n46B5ewVKvgS7opbi58mlt+1ObBoqnDDo0IRckwxBAjv1VnMEKEhYstpkpB23NrjzRPegu76psovvjHWsud9xEqlDG7AwKbVO2u2nCz6PHfRd8x1Xl8jE0u/3NQtvQoWYNkpuifrH0xd2pytOBts7gA383xoEtbjCBfO94YHyIv8Wyo10DafQZVHWlC5vf1NmY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:47:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> The vma pointers are not modified in any of these functions so make it
> official by const-ify them.
> 
> Propagate this throughout the call stack.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

