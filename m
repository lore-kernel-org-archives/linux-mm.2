Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D6CC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375C76B00A4; Tue, 21 Jul 2026 12:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D286B00A6; Tue, 21 Jul 2026 12:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263A66B00A9; Tue, 21 Jul 2026 12:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9BB46B00A4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:49:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EEBFA0217
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:49:37 +0000 (UTC)
X-FDA: 85013369994.28.050C61D
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1C65A0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:49:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E8jsAncm;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784652575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jz3tCmNLomhxeSHRRM/RsgqxQHXL6/1WUZFNVLX32Kw=;
	b=PCyCj0zvNXVWqjqHQ9S1nc1z7TtbzbbxjHmycHHPMitFyggSxcJGNEH+QpDhjIrpHvlNx4
	amBIIRBc+5gwMsdRACJIfNrYpwFKfreNFlJxQOJFmxVFmCrz6+tqxhkPJTNo8ZokMjAGYf
	CsxGUxINupseHLzBTYhcTsomz7p0le0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E8jsAncm;
	spf=pass (imf15.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784652575;
	b=I27vbetvVJ06kNWv7w4YczMxND2hyLMk9blvLboo/o7Qxfj36ASjLvoFJNsOaDd2DWZ27P
	8dghqmf+NnEUUDAxdBm8oRd8xkf+Y+OwYttJjMKcLTdOgKruTfEnqZLdi8taTfvyePMYUe
	lGmpavaDFirtUjzjbr8SbZg+zY1HAII=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1013719b3a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784652574; x=1785257374; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jz3tCmNLomhxeSHRRM/RsgqxQHXL6/1WUZFNVLX32Kw=;
        b=E8jsAncm7EhXcHCHyRWWWQxLKwULv5OIXP7LwAF+Zy4aDEP9z9K1HOUs4/mHgXpjQv
         PpIhMD0XSfSq0VoKAchQZJfRbq6DMIcM3nohEAHbjZNNEWX1EGErKQS/9V8vJPLmqm+V
         4y+K3PuO7omM5k/EWkmU6L/jxWa+AoJtOKjxOH6QODidxFHB4mpx5nhotRcJfBSjMsUg
         enMjz+VXcmJ9n1g8PSKRqniQT/aJa1YNpsSQbOc8QspEGiIl1h02o2udcRkX7+et8onP
         pA4MhXSsofXf7rEd5BWLb1tT8Apb2K+YX+zROy5uEDfkNNkxHXxJKk7Tjkhz2af8QVX0
         1wfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784652574; x=1785257374;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jz3tCmNLomhxeSHRRM/RsgqxQHXL6/1WUZFNVLX32Kw=;
        b=JVvScXMyDlVdnlHR1qG9mUOHEpLIyDDqQByXpKwdvDS3xZHFguWztC70oZnKkSjOw0
         BH/We0v0rzvDweYXORIFb66G2PG5JgACZmlJdtSMgAmad0h524rmjQkiVxrQYRlZrsMh
         5HtnoFDinN0FPs+sz/wph04iKL5smhPYDL3HjAWIX+Mb8M7OIYBlGzRs36u6zR5I2Gok
         O6ELCu2k3CeaxybR6+Jb1ypZOXzWY1MMK18+lZvIBbWxPNcRPiGxzXO+gLdmfQpcfJBr
         mvIgrx3GRJyYwZnsUY52XPAwuocCZnA/JpbAnMEXpwGl744mZMjnpXNHAmfBoU0gr9Xq
         xpXw==
X-Forwarded-Encrypted: i=1; AHgh+RrnxJifknXjgofWa4c3cFZbGhKEhT0ypgUrv7Sgr1iWdeGzXwRS/TWdaUWV6vYKSDNCh9Qtowy9pQ==@kvack.org
X-Gm-Message-State: AOJu0YyJyo7zXxBECTf4zJCz5Z69eINZUedpDAZ5OKDmRASZAI4NVqBV
	2rgOX8Fi2PrxgC2dXuyHu/E+6EBtdcO1VhaPOU8ATBI/XQ29HfpUNm1y
X-Gm-Gg: AR+sD11iv2jSZ52uK8Qzk1RwyQ72oWFhfx0uDhUrK9TtD0gEecAhbtQ+piEQqX6UuZ3
	wcHzQMh2gWzuLXh04CA2PPoLxIqiIiCd0SBNso0Mj7TVt785kF42C1bhGUtS7Ygyvvgs13Pz3mr
	YHzgUabBxTanGqPq6qLg8Je515MQCBmk8W+ZAXlyDWzBqZ1NduRlvqnuwtgxC0MacsNqN2l/8H6
	RvRRlL7RM4+Db/o1z8s6yRodpZteKB3bbzKd2mFJINlDQO0z+GwT/YAPVDbW6IApvJmGa1LcPvL
	wR9PSDNVTD8lExqgLXZjhKz6cnMG4JRVQ9CX7acJ5CkU93wWRWlg4aGJvu1Eztf1thpxF99U1V2
	juDEm2vlzvzYgOxKK6Luta0jTaQdcRorcBwgb1GXlWu075hofOiIGSDSl6+j57OOGt4Ibld5gqW
	brtJmhMzz4k47zf3/PFopyIOqcnp/tKy9JQKnQetfz+XAk
X-Received: by 2002:a05:6a00:cc7:b0:848:6f5c:a327 with SMTP id d2e1a72fcca58-84c29270ea2mr18663190b3a.15.1784652574553;
        Tue, 21 Jul 2026 09:49:34 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e175aad1asm5186b3a.44.2026.07.21.09.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 09:49:34 -0700 (PDT)
Date: Tue, 21 Jul 2026 09:49:31 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
	corbet@lwn.net, dakr@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <al-jG2fROgMWUq_T@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413936536.1155966.8918127042760531802.stgit@skinsburskii>
 <3ed2043b-88e7-4a86-9efb-fe788191e8e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ed2043b-88e7-4a86-9efb-fe788191e8e8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1C65A0009
X-Stat-Signature: qt85o7kcb6jiy9p94k8p6x1gpn1k8b6w
X-HE-Tag: 1784652575-683419
X-HE-Meta: U2FsdGVkX18pifu8PRQuImypHM98I0qXwjHn9H5XzVYnvTx1SuKBDpViFn+F8+Jx0T84rXDKgd8wUHoPn7QT4sgCEFLVhgvidCgpp2z7te2bXtI4I49M0M/cFLsuftIlmWblYOTRJuztQhtMg5d8CdwDPmdfsuY/WwLsA6XZLnik+IzVUK6APzoI1NzGA+KGz+jZDpnpL0zzlYIpYhHwwF7A9YR5hCCxfSnohUWOrkBAwDGNizAte8BqJzt3LWwjATebGuJblLmZLGL7YQQ8r2PEugxtvvJlC7v9X4o5cVP7HZGOBsmDe62aIm1SWS0MgHEnVcDU1wVkcV7duff3zgi2NhOl2vZGdJ8K/8Cv+jJe2QWpekghzJwI4idWDNzz1LipjqkWLyvwQlG/RRIfw/zoH2cx8n5E5CrjEPKtMwhLmeNQ285Y3bcl/D1Uvg5iwq//UJihJ6OvjSRhxjwZHxYLZWBExksnprVgRKvOc5BilOizK1m9lkcCGLX/Rh4vWCsav1anV/rT1dP1xGg6HGZDIsLonC/nO3zMlHU3xUkHlUV3txffW6mBMFw3p99Nj42edEU7q5RiUrEdTDZzVSB1GBX64jc7LGVVan4BWejpq2PCKfkY3phhT4d16f+jxUiBE9irUXU60GTNzt9fhG05dkoRVu34Ar9pYQabyOEYPq6ldiaboBspphmtg/8Lc4C3NzG/Kt2ZVhiKSJ9HZaPfKaoSC7GC36gPYBnLzsm0bjLBfQWKlsV9MirMB5KT/aagQ1l+sx6VIxkaNkweoPlFuUx5DGDaJn4q56b30I7bLIRcacKU+gtHi7Kd4Z+ebpl/0wId1HDQ0sO1T8/mbrrwnXqc0Hdz1/IxZfsWl4E5Mtru7/nqWgV3l4eGk36OxiLbDPjqgN9WXvcj7bOAIzV4N3FEQCb/An8fGQzN6BZzjl+L9Zuwj1V9Al0nZWrHsD5VQ8v7mRUld8CrHPg
 2ltx526F
 jInlX+4gzcVIruO6lR+3+2MtLJzerS0DjP3zCeP1G97Mw9UJwrI2pNJeINo/GAdGDvQXsblMktJwUt4pIPqKD1ItNhZ48xV8IMgDyrxSywVetzKrd2KcBS49o7IR/TTE9IO+qde7mia3Yflo0wjX2WVKeG0UTq03HoRbJH/BVtExBp7ATikFl++mUn9zIdM9wGQzXXx6ayjLQxeDZMXgIbSnD2PIX1SGvAQ8auFx5d/VRlGD4RPbUkYMDgdo7wK1+GOYLj5G9O4pEXY7J0jfqO78qGqHYNrAqhDbJ6cl8Q9hAkkM0fX7lA5WTE2KB4IO+wZkhFwOubutddAVbRvH4twF7Y6OfaUZsUOj+2DopoAzrQYToQ7AePE/uy0/AwcsMn1xq/LNVWRloEvWhx9blKOxXXeqyfNenqaxV6w14Rsi1NKAK0qBjUOP/ryeNA3BEaIcHo1R+CPX4sGZ2OEzkpGCS453f4WG3NF9urVKcw0LfFkYY4rokwtQq6OaelGeb5RcXMCWrh4Ya1HAxB36nsEI3Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 05:42:53PM +0200, David Hildenbrand (Arm) wrote:
> On 7/15/26 20:16, Stanislav Kinsburskii wrote:
> > hmm_range_fault() requires the caller to hold the mmap read lock for the
> > duration of the call. This is incompatible with mappings whose fault
> > handler may release the mmap lock, notably userfaultfd-managed regions,
> > where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> > after dropping the lock. Drivers that need to populate device page tables
> > for such mappings have no way to do so today.
> > 
> > Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
> > mmap_lock across any work outside the HMM fault itself. The helper takes
> > mmap_read_lock_killable() internally, calls the common HMM fault
> > implementation, and releases the lock before returning if it is still held.
> > The timeout is specified in jiffies; passing 0 retries indefinitely, while
> > a non-zero timeout makes the helper return -EBUSY when the retry budget
> > expires.
> 
> The timeout does not / cannot affect how long we might be stuck without the mmap
> lock in e.g., the userfaultfd handler. And also not how long it would take to
> actually grab the mmap lock.
> 
> That's expected with the timeout, right?
> 
> [...]
> 

You are right. Ideally, the timeout should account for the time needed
to acquire the lock.

However, this timeout is not strict, especially with userfaultfd. It is
more of a sentinel to make sure the kernel does not get stuck for too
long and that progress is being made.

The default value used by most callers is 1000 ms, so accounting for the
time needed to acquire the mmap_lock does not really make much sense to
me yet, given the sentinel goal.

Thanks,
Stanislav

> 
> Nothing else jumped at me.
> 
> -- 
> Cheers,
> 
> David

