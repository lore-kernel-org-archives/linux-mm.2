Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6FFC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 09:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D8C6B008C; Sun, 30 Aug 2026 05:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D346B0092; Sun, 30 Aug 2026 05:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4530D6B0095; Sun, 30 Aug 2026 05:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 164AE6B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:13:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 799C2C027B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:13:53 +0000 (UTC)
X-FDA: 85157373546.07.5982CFC
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id A7B6F20009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:13:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDYtjnfw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788081231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mZMnam9PuFjLpm1vuMO2JXE5Y2qa9SZWkY6IJ6iwGk=;
	b=mtAcFA0XB2yTmp/NY0oR7Nm8cPZQTXv/7Ox3gNnOQzgXRFG6Dos1KAGAR6FlrLGuCe2LSZ
	6Pb20lyFFAJFLWvcLW5JSuut8gQrBQI3aiiR+Vu7aKD/ZENsPdZFUWOW48zHLYEgid18qd
	JChguz8LZYSo7B987iZH17c7qCwfPXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788081231;
	b=mE/mHBaAtZEzqSI/IFYaYZsj1waiup1gmsCp4DvRaMEYijPaqhLg6Chqb7sIhKGV0XBd2h
	j/LxsKEEOC5PyAbxETln3pcy0JTEfsAKtmun8YiNKNlckibMpX1HDGuGziVEru0NH+So4s
	PEk01F3ZOC1QdZ9R/557ivF2oyybd+o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDYtjnfw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso2838584a91.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788081230; x=1788686030; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4mZMnam9PuFjLpm1vuMO2JXE5Y2qa9SZWkY6IJ6iwGk=;
        b=qDYtjnfwJFEf8EG5ltRvwu1fTF57qZH6ad+jRy8IAorboptgmVp7J1LzlRQgrlkVEO
         KM8Ex0dlsqorckQ/r7bIBAQAa6XtfO93mdWOUkwQ3aS/fiY1mzHGyUqOnjX8ogiQ+Nim
         GDbbeigdXPNiNpNDW5xLRq+ksScN3QOTAyhLz+Vimdtkwu4JtMdQmJJCQTcHkz8S/dCV
         BnrNk6kf71ffdX7WK+/Rj/d6oRrrvuXTI1FRwo60QTHuR3ce3cFlqZrDs7v523kylnBf
         SyWOGzuI6+LXjRaSLApMLSdlRyfcXLjXdUJsqRzu11AYB+XiD2pjQmKv3Jie+24uV/r1
         2zIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788081230; x=1788686030;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4mZMnam9PuFjLpm1vuMO2JXE5Y2qa9SZWkY6IJ6iwGk=;
        b=EaxGeQ31/ND4cOPF6Rdsk+pYKlRTBc/MnOGKm8fEFHmGR0DLoRcV+2eZbvpHX2qw8V
         OD1Wvr7FcbNvBUXhykq01ck91xGa4o6J68XDC00YIZoRwelqt0AjfwYCVgdNlwuaHlVx
         MajBzVMeGD1XD8nbjuBT/m2hfn0jLctX3ZlfYmomeS3RonwIxRRHpF20GbMzN88Z7/pa
         hH9LsQSrwJO8xYey5e+FoQNiojpsVBjQh17P8+AmpCMSEkQb+MjHh+M9obp7FQnfRk/C
         cCs14HLW1I/8vjbOp6+BiRI/eGM2HfKABAtue2cs8Fu+hBMADHSxXgAEdhblS1wOMAgT
         Gglg==
X-Forwarded-Encrypted: i=1; AKwUvBzgF9SxmAHEloj3Q35EQ/x73PpH3yJBywduBxWtHw1AvY4eS0bAeIrc/hUppH2afs9e4SFm4g0i+A==@kvack.org
X-Gm-Message-State: AFuF++koz8/csIrmJBI1vXH5lL2gxB/68ukeLgy/YjrMJhBm75c9dZfO
	23lO6UGLKcfxT5GSHJChB24lFs36dULyfhe+cHy1hkbW49iWtPwDEbdn
X-Gm-Gg: AYBFou2DIpLO9q7s/CsBSeDuzo1UqQ7ZuqVo2ReRmHpf0C0zNqoZbVghr1IDaLZzyZ2
	rTLvxVlhZwNNbYhVhJRTWi/Qpz+x1E577EL9LniKV02ZT/ttvB2KJPFUlrNWlzwHUsDLhHfUfv9
	jccYvrByyM3gE2dhOxl1fuZQ4Eue6VCfdICG3d4Ng04sTvcmS7DyGlGZNwREmiPUgo65bQVEOfg
	Z0Va/vQZusTrey/5a5z97fneG0LjaIoNxMRukpwKwEvMamWYPAbutnmaoDef2RJicbXIqkhjmDk
	SCpLNAI09lldzV+0Wf642I//TqhIkxiG8tWgj9H5BE6kfz1yuLlEONTa3WPJf0U8cCElkZjCJTH
	Rs8pJI0u6WDi4my6N6OHq/AouL+LUHrYB8evytT01V1dZK9d5U1k50cG/nQN2QIDsvxI7Uiq1Da
	drrLCVtmxwZ8P1uJTzz9J2wyQico0BrYXYmaUmQ2h4G2tSN82vbQSb4eFg4tt75F463tJl72IPL
	WOR2KHfZMpV1Ae9oMyHqg==
X-Received: by 2002:a17:90b:2642:b0:398:9be8:ea64 with SMTP id 98e67ed59e1d1-3989be8eaefmr17172526a91.17.1788081230369;
        Sun, 30 Aug 2026 02:13:50 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea80a2sm15459428a91.3.2026.08.30.02.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 02:13:49 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: baohua@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	axboe@kernel.dk,
	trond.myklebust@hammerspace.com,
	tz2294@columbia.edu,
	jaegeuk@kernel.org,
	chao@kernel.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
Date: Sun, 30 Aug 2026 17:13:43 +0800
Message-ID: <20260830165401.1788080041-1-qwjhust@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4wpUBOXKd8aGNz76U+87bwDUXZZFSW2UhNcq4qpjVvggQ@mail.gmail.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com> <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com> <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org> <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com> <CAGsJ_4wpUBOXKd8aGNz76U+87bwDUXZZFSW2UhNcq4qpjVvggQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7B6F20009
X-Stat-Signature: rse4z1di7af3bdd1gwfjkotzde5awraz
X-Rspam-User: 
X-HE-Tag: 1788081231-603610
X-HE-Meta: U2FsdGVkX19RPbwhmSLOYlniRdhDai3XDR9WNHRiszpGLlFecXnz5mIdIG2MALhYav9Qp87jGb+aUfsne72JrmN3ADuBVpy/Fp173xmIzVY/kSqZBGECpY73LrouUdUmVhBbBjEHOboJUFL5dh3aVUXbCQEME2MmRnMLvaPEeNPTlRu6Q32+EoHnVoIoHMX3Ztw5FJtA98fjAV9bR6OdDIWDiyYrIlZ+CyqC/nHpy1IzWGXMsVUgycZEBPiG9451yiR5tRNYWTdE+eg/cGgHAZHlsPtGYUkLNGW5dBVa7Roow+c4BPi5bwWFtSOxLnOLeau7N7/ZNjZCQceOCKBZQ6WWmiaeos9jq1Nenu69cbLyh7SSCxNS7SdDbJKfDuc0h5+lUGoDwkcZgtrPFeyakP+t6GCamfgfnbbw8MdzXwiNZhjhFvXIDGLvfd2MTbdwPfT2U1slgkic/h8a4lpsWpGgLFEWiFToiBJtX8UdlB8t9yN4/QdwuXScY0tJA+6QE+rW8D5+73BA376CgDPep9aJanINbHccm/m5dzSSRTiO695LMW8/hUbi8XXKPKg53PaoXVtH++wj8z7syahc6kJsi4o+E2d1rrkSw2bZpXeoOpsXi+qJV+4Cb0WqXjrfYV0t/HBaKjQ1AYQ9OFrl1tPtGaSeyUaCQsltS6krjlnkwqdOzh+vkndR2wSJhU4TnhxTvbYeZncbAyfdIy5yFIfpDd8cxYLCKXcEAykGhtV7y4EL3VROzonD6iHQ2+CVzQweVxDvnd4tSLdizkm9vMOwzN1yActFo4VmXGaiGV36DZFt54wJwiW4fLHiSZ8BWdPpN5UndCaYjV8MsahVIJoiBYGskRc/MQUFfIOdbXxWWzuMyW/Td69ARk+ZA49Mk4by/xAe7iSMf9JlGkbsKjGv5xGfVd0NaN9LOYtA1RlwAK0KmuQBKAWmDvH+Bx3/IHpLthTRlr469CBvEiA
 e2ws3ZtU
 5ry6NXM+wg9eUZ6+MF30HkMXkk8I3Z0GiK149M2WLT4kTI5yhTg/nG6jvAtjiw1fytmN4OPKKmdeBknRt09ehC6Ug7eEt2xKrzjrZm7N9fkl1XqgirIk9KJyQsGM1GDmo0SNfUv9eVfOdewKlHd8dqpB0AHl/HFJtqz8Eojy09jU0aByLwebSn0emgb36LO3X0hrK1d5VNFvBjW4KGkMOIa1wGWRkC3Cns9RRsaSrkc4iL46oiEm5o7A4laDsX9gngOtJL4dFJkA8hzLaNmqkXy3Brm6mu5RCgcN0n4AMwk4TgbN3aNL+2x/esVH/AU5a0zWOgQ18e9PxZ6IcKdaxXkjmlKmpjN4YHp5yGhmfW7X8kYBt8rQudy7Re03GfSl1nIPimlHtU4jntBwLtfGZn9S51Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yes.  The current path removes the folio from the page cache, so a later
mmap access can incur both another fault and I/O.  I should have stated
that explicitly.

For fault-around neighbors, folio_mapped() cannot distinguish the faulting
page from a speculative neighbor.  This patch takes the conservative policy
that an installed PTE represents a competing cache user and wins over the
writer's RWF_DONTCACHE hint.  It can therefore retain a speculative neighbor
which is never accessed.  Distinguishing those cases seems to require
fault-around to preserve the faulting folio while not mapping, or later
dropping, dropbehind neighbors.  I think that should be considered as a
separate follow-up.

For folio_launder(), filemap_end_dropbehind() holds the folio lock and returns
if the folio is dirty or under writeback before calling
folio_unmap_invalidate().  folio_launder() also immediately returns for a
clean folio.  I do not see how nfs_launder_folio() is reached from this
completion path unless the locked, unmapped folio can become dirty between
those checks.  Is there a path I am missing?

