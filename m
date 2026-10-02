Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1606ACA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279F06B0092; Fri,  2 Oct 2026 19:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202596B0093; Fri,  2 Oct 2026 19:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBBD6B0095; Fri,  2 Oct 2026 19:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27C06B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:35:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4E261A086E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:35:37 +0000 (UTC)
X-FDA: 85279295514.11.32B7581
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 136E71C000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:35:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=moBNsXSa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790984136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKOGocBTPT6zEDfsTu3TByHMk46p15imK8zAdyqUzUs=;
	b=JMqJiNHDE7IAgodiTbKJFO1lnvQpLENLlq1O6z5sPf25+GC73gVcSENKumphypKviFGvqY
	yaSKYQPeO4zhC90LJI9Kvg7qzB4s8vBBezaDh/NZ0N2HmI2VOGJ9n9HQ9c3esEUCSFr9WS
	pI7DtqSZpOExPQ1esyxoXqGR5stdaVo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=moBNsXSa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790984136;
	b=VqaooZB4xjeu45boN2gVheRQhQsm+rk42HDEWXOwaxU+TfhGJXp+zqDlZX0KQhbHille9l
	T12v+Aw4KBbA/Tk6glvgL2IcIgl3tzjhiA9aPnTuDGRl1JSJ5/v+pWcsPI+cwYdHN+7mq+
	M4h1f8sENqCe9EFREKSvTuc4W6nzh7M=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a169d33ef6so109385e9.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 16:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790984135; x=1791588935; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cKOGocBTPT6zEDfsTu3TByHMk46p15imK8zAdyqUzUs=;
        b=moBNsXSaaa/UigiMXRoow1CswhBq42TV3JrD2earFHQMecay4Yn+/9ovvn3FJIpbP/
         T9aYz2DRO7cUi3jerwbXiN8pGbG2dPDyKg8ytejEhyT4xEzQhrwxvGaX6p0uWLkB2fFo
         KVHJX+/qsJxSGHX5MBnlWAnh2ZF1zKAYfGE7SY9WrjgKaLBjX41TA8+3W7kRZ2vmEKQd
         AWts7k25orAlpJ46Xiymc9sK0ymbf8t/bVfPYZ5cYigvRXAeAhFbDtHtuIq2F6NyfoZA
         s2znFnyK+vZzUHklS6u/8o4VjrLYIrkFiNJnBcbUFvhLPw7YdewSeY4aRfQqOdvk3PTx
         Ogow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790984135; x=1791588935;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cKOGocBTPT6zEDfsTu3TByHMk46p15imK8zAdyqUzUs=;
        b=CgeVaziF0GCCPbnroycEwl8X0JD9etC/3FiKXIsK25P2w95sB7vMzlViiUo3g3ccjW
         PGZwTMWPHgbd9ZJXcjoX/OrpPhpsLtOOkFfeuTG4Nr14po4nufa35UCI3k4cTHQ4SRhe
         5Pokm0WhHNEQESsdWWApazm+gwlQ0uzIST6SxFBoicZLoJGTAizLsIVtnaZOcAZNuYjS
         /08RW+iwpdgzY9SLQXqez3GUw0i+t7x9hi2gRnER27w/HQjsavqFypvIJNMVYBnYD/oJ
         OjYcfUhFvyUJdN9U+DtmNsLSuXcE200v2yf4+CW7sOL6M8lZR+a40s37grpx95Whj2dK
         IDaw==
X-Forwarded-Encrypted: i=1; AKwUvBzw96pFVCJGW/k8ByU4NUtIryAwcvK3BaAq9usYURFTjtZ413w7WGKVkq879e/puu9Eciv8qReb4Q==@kvack.org
X-Gm-Message-State: AFuF++m2wqeJXKU3penKSBAtOb4Tp6/8nHFavXrYdvv00Zi2apbHOaOJ
	ipA0rqeUBlyKYHiKiYHaXnxDi0MSLRXA4mv8ur5TWxcMf1ByyLPwmX7t
X-Gm-Gg: AYBFou1eKLYWSzDZl+U91uFty4Q21g7NHcIBTLLvoDg5WjSak9Rgwhidxp+n51MS7yF
	EWFBtKD7k8qsh7msVMT53WcqWCrJaRV8fllXDi8Y7Lc2uz0djc0BvwftdcoXAqxsDa5ijU7LK0x
	mx7EA6CYnAcIjbKEgbCdVc4WSPf97C3vvOWu+FkldxB9XeHh/5F30n/6aPUqGUW5+poq4TlGcDt
	vSo8Riq06CCuql54gFtRHIe394rZoLcFxpLTu1jlAa8p2VUoQKTCLvSZoRYq+OKiy6mz9WPjkiB
	M4zHjIhgQ2nY7VypI/0icOSRQP2JAbISeTPK4Mp+CZWRdpWZmWo9Yprs/ovi//G4X4Lq4o1/TMt
	eFgUDgNECEPA4ZvniMkglCYwDUGVZdRnAwB/3ciPtpVZbA8K1axWHQ1dL3hMwjn6oV03nM/QTBq
	CQKKfnJxgCA2QVjKsRFSj7UNLWe/HzD+vaBH/KdoA+F3UNK/WhahNvxOFOEhrsfcYiE9Q+BA==
X-Received: by 2002:a05:600c:8b2f:b0:4a0:f0a:976a with SMTP id 5b1f17b1804b1-4a027579f41mr70898005e9.13.1790984134620;
        Fri, 02 Oct 2026 16:35:34 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0280be5dfsm130059635e9.7.2026.10.02.16.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:35:34 -0700 (PDT)
Date: Sat, 3 Oct 2026 01:35:31 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into
 vmf_insert_mixed()
Message-ID: <asA_sDgh676AzQkS@gmail.com>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-4-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-4-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: 136E71C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y44n19of8izk47eap1fa4gtb6xm37mwh
X-HE-Tag: 1790984135-191626
X-HE-Meta: U2FsdGVkX18RaWzORUWVFd6zq8K1CsJqQklCBwQ/fK8rKKnXNo9KvQZ5zJFEbF0/0j+4Iy0hWjrzWgnC4/dSk6VCVKriMr40TSW/Wm0mKi8VTXO/ZMa4N693jRb46L6RodNspiOFBANt9CRjERqidl3mlamFd9E1VUnrpKI4iL0O6gMt3VYr7qT3Nt9lxJIm4HWf0OoqpWO128yezaz8N2A1xo6sw7Hd5QeElAkPCBkejaRKMj/9e5DOVCqCYEqF7bLVdb7hPFzB6WCAthAW1qhrzPEL2vyYoSzdxFVmxuuOfbiKOmjnxaz9MW0CKfbvcPxHLh/nmObfSbFGUDyXxFK2LfOC9DWEgstXQUFbHFUzdefvJWBgcvk5EphTJgKGahjMemc0O9pJKVVIYkyzBgXjWuw31RVrNdMx10O29pGMqbj4RXM+swNwiigylpJBunXpVRUdzaEQ0D/RR7ohhCZH1tayZPDUk09mzS0S32U6Kg9eZL86Z3Cpw0c8+8gJfnN3VNMGQiHiZgUb4eOq9qsyRbx2ljgR1Zh3ewgPi2EQcETv9Ew8HFuD0QAdYUFv3aEwivq7Z02f2ELUHuBPtxnDYVPaa4vEcC5W+4Jvxrg/CVpGTdD7JMk1KHzc35rtUOO9NZwXa8qnl4AbzqM7U8kiSw2fc5T/Tpxxr5bxEARsHRpg7Kb/HDVcui/GclItY5CkMYB8miUGFVP6njUT6pYsxhFbGePwgr3dyW4Bgh3ST9GkTrshTFskgwRRuoT8iVtEoMJpxZoMk9W1xun4rBFU23yvNNFtm2E3W3J7K0cSyAmizPEQ5FimJv3fK6NEIyUfc7i2tlQJIJQEpVHpZKNYM6Ie2RY+rKCxaqvj1O8fGtC1asnqcdaL0MTl67NFUFvtjtsNwgTcHBQAAstC8NEeOPjzr4Zw7gj8TZsjAIzTJ3pVUd/siGlzhL+1Q9x9Cqv7LYq/NDl2iEUraLh
 gRNTuprz
 Z78Ao7lp/sf0XAIFaWUXchYJ8tOhz2GJaQNVeEWOFC+V1uwBi/cayx2CX/X9H566hjvMGlUPF/aFvM7XfikNOZCfPgaPTeSED1uf6/xN5wzKHBJ+b8nqliLAxerN5W8xLeuNgnsNkiL2s1cJmTOaLFjbMLa/abHcaJQiwUZ4ZX2rPNQQ9a5cppASv6noQVk7Usgyao57qw8OXu1ChvmyDUTD53chTNhTMbqFFSTVXBiWRyBxMmjD7b3SQSlFemCybHjUnW0GSn7yx4wbdmqsHE24hhx6nDtTKv+5fewG8wwjoIia/Jy7FLUeVaAnyp9pDIDFk3Wij+tvZ3DgC7veKqSeMntXSycLy3AAZS7Elio4MXxn+66t02hut8X4Hx5Rg9R9RjwGmAyFfFjkpagNdCldhqaOgNySDyim5hzPvUlF83SOFwVXTeW9/+W3N9PjljR628llCp8XV1B8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:34AM +0900, Sang-Heon Jeon wrote:
> vmf_insert_mixed() just calls __vm_insert_mixed() with the same
> arguments.
> 
> So merge __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

