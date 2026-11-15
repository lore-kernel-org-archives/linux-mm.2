Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FB3606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Sb2h8eI7
Received: by kanga.kvack.org (Postfix)
	id 78D606B05B5; Sun, 15 Nov 2026 10:30:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D936B05B6; Sun, 15 Nov 2026 10:30:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6534E6B05B7; Sun, 15 Nov 2026 10:30:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 451A16B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:30:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D20811607BF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:30:30 +0000 (UTC)
X-FDA: 85437740220.21.F6A7FED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA9F7160005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:30:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sb2h8eI7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794756629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8b0NcOCbgjT502LwxuI3125LQaHRINxYB46l6CFgKcI=;
	b=caoJ500zQhVq5DQLI9PIfsBJTS8Gk82p1AAnFgb4UyY4uOWFvBQv/rdVlYSpgcx1KH5ts6
	w4IeOEzDZv+E0Q3LoqHczgbE3N8wkjZOkWSoPy84X5n/m6ogpTBwg4da2xvxNl1rRXHeRS
	5z1/oaauljISRS/j+ISRq63rReasgeM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sb2h8eI7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of jocolema@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jocolema@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794756629;
	b=aGEGPFz2O028KXPvnisx8EusrfBwxWAEHIjbTx8ot8NgdBOoHjR//amWKkWkrNBQawnEE5
	RV99wGh+VNSaXT40GQTDnAAE4SSv8ITZYTcgPlJf4pMC7aFBo31BEbuCuRjh+qSzL5a9Ns
	WX9GqXk843u4V4iNKMBJzRpTBd5R7xk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794756628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8b0NcOCbgjT502LwxuI3125LQaHRINxYB46l6CFgKcI=;
	b=Sb2h8eI7WZQO/SvNxdd2jG5neOi6gJE+jLYNFOz1ln/GYuQjhEOItRR6EVopMgHEgrPiQu
	VDsmTOkufEplvS6DG4t+XPy7H8xMP9ptodcJNyw5gSJXuaZ6vtT11Cz2KYBDuDeUBv/UJv
	xl2wvsBhOF9GzJriTq2WLsA6SKb26ig=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-yztVjPrgML-gcgHTrusa0w-1; Sun,
 15 Nov 2026 10:30:24 -0500
X-MC-Unique: yztVjPrgML-gcgHTrusa0w-1
X-Mimecast-MFC-AGG-ID: yztVjPrgML-gcgHTrusa0w_1794756622
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81E9618002FD;
	Sun, 15 Nov 2026 15:30:21 +0000 (UTC)
Received: from jocolema-thinkpadp1gen4i.rmtusco.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C49541F;
	Sun, 15 Nov 2026 15:30:17 +0000 (UTC)
From: "John J. Coleman" <jocolema@redhat.com>
To: akpm@linux-foundation.org
Cc: audra@redhat.com,
	david@kernel.org,
	jocolema@redhat.com,
	liam@infradead.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	rppt@kernel.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	zenghui.yu@linux.dev
Subject: Re: [PATCH] selftests/mm: allocate nr_pages based on pmd size for uffd pmd_move tests
Date: Sun, 15 Nov 2026 08:30:13 -0700
Message-ID: <20261115153013.1801047-1-jocolema@redhat.com>
In-Reply-To: <20261114104457.6b3247d9abaff0497a9ae545@linux-foundation.org>
References: <20261114104457.6b3247d9abaff0497a9ae545@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ljKlN_5p4WhhAEc28q1cLZ71ZvDLSPIbCvIzCzejRZA_1794756622
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA9F7160005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3qpd4znnjzxcr55a1sejzyuianomnz7t
X-HE-Tag: 1794756628-558752
X-HE-Meta: U2FsdGVkX1/oav8znVCTh/U+mdGlMk21dTpedrhT8VrGDEstrTlCwt1hklcOCwmjSjMOHCMB/ktFEI9kPRmL7B6t+e+CrYxMUklhaSpDgdA9gsJQWwlTFtOMaGM0jLnk0JOzb5a23b1vNQiFBDbBiSHfMFLL5y7EFEOP942m+JyU+Id5CykEIOjKWgnpvVKNOCENMcM+WJJv51eXe7suAC//WJBTuN76b5XFqXDfgvoHl343unOq5MxsyoskraspQjmp4rnLKVcKVWAqhylpMEyXuEP9lX5zT5YzRdHibagYNPc1lpccnkEQa0SDfhIr8kH4Gv9X1j86nfD5k+2IDj+E/T9Jv0nzjz7jg6g5wNInCVvWQlpwaP4X4P96OTz4uCk4Uc28L5ixk67eahiPdvDLsa2SCJDFgQT6ScG09frMEDp7zOLW55xrygkRWzMqJ197qyJws9PorSqqLJTnPoEG1BTfbAc3X1V+KKE2g0AK1fUvB6FTWqJX7lAxB47/fKJv6w5rBkpvZ8OAvQ6F85daKsVoL563wKzJ1wDaJnvfa+fK+lV+TPVjcSmrUwkJ21Ac4deWoMATCAX+gJXIyRWxmnyX3mRZAacXm/lfwkbGW9NAGqa23BxIiylCVD+b6lqakxHmt9XJD3bAUoSlmr5ChrspDBHjH7P/bQ4Y5EkipF6hrGPFUI2i4Png85p0vgSlIBg70bbnHdAbuh3li5iLMcRCXqtkDI2wHUEv2bUCDrFRGbNdJ9I8CJWfszQOpoQncrl5q+nprYsjmTUX3tgwH+EeuCmZMNfuP+QIu2DFsxMEPMVQG6IutUMH2DRCy7lyxPSHUp3gredDrkTBZ//bClk6ByBkOicLyjmYLhVKxybv5tFdTdcErd6HY99kXSURBOoH7r93eYS+jLp9rEVMZivVIQ+Ii/obr18VBbFzNT/qAYAxpmcjOHERQsC1NvJj0NeTKHgrEl/SYMG
 MX5/1DQQ
 R9hq5bB9YVBFl/51o+j/0o9HD/9t2vTJJaqbb/5FWVQj2kVmnN51kNTgNzLHNjjP9j93JJKApAqqVLWobF522PLpqFN11pWiFhD1GXBceLqM40DUkbkLovbpM5/A75v81UOv00vmYbjy9DYViAyeGPHAcgc6RRIkS4L4LvqDMJ32tcfJFA6GojRl/geLjYQHckU/iRBIOTXz05E9VbkrNTB6nyrF8HRf3a8kXUBooTMXPywhzDOLWKsdpjXvDVkQYRMN9ZB6mehFgaKlsDKerVhFmoSXLfwNfhRkBjxvw2h+0Hi+pFZl46/HArLQQnRVfQm9HuAAR2aGySdoEOqFpFp+42Cv50g70J93bFHbuzkd+b7mW+B/+O4tHaNd6c5M4iB2jl9f1K7z2pJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew, thank you for checking this!  And me-- for missing that MAX()
input especially.  I reviewed your patch and ran a test with the changes 
on my own systems as well, and it works great for me.


