Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E0C606A333
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ZWqQZ5ju
Received: by kanga.kvack.org (Postfix)
	id 0EE9A6B0890; Tue, 27 Oct 2026 14:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078456B0891; Tue, 27 Oct 2026 14:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88A76B0892; Tue, 27 Oct 2026 14:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF9CA6B0890
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:35:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F4251A0ABA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:35:19 +0000 (UTC)
X-FDA: 85369258758.08.D79E76B
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5668818000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:35:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZWqQZ5ju;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793126117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68JN5QHnKCq47WQPiHLxuMujC+xRd0JDDXBuUw27i9U=;
	b=mtzQUC6PL8njvaUbcmKD7292LRxIwnaNdCTwIlnEyprD+iPMQSAZcbLnyf+GF6MPVVTuBT
	ZOjlHITCnwOiRsEX2L9fMDT7pVI7txnh3RIHjChImci+PhI4XSAwK2OXiGnXB5iaKuOTvz
	bmmtNOAobJbzvdOiNrYVRMnIr3kcz8g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZWqQZ5ju;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793126117;
	b=S9yRo98O1gK2PTB8q2PdY+xeu01Y3LKDTaDBNWaHTO8GVIBWLBLAzpFf25SOWioJ32xb0r
	zO0PpZCqnqQjl1oFG1tWSpqzQGoTzOiCnbpQ2MXk4yHySFwNnbQAmoqjFDEg8TfdvF1dsW
	Uc50cZa/dQoiAytuyDkWRH5Tp1LzKIk=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91c79a9a739so2560666d6.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793126116; x=1793730916; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=68JN5QHnKCq47WQPiHLxuMujC+xRd0JDDXBuUw27i9U=;
        b=ZWqQZ5juO5xQY1GhfBc8q2Gh29Ybe1NYJudlUktEU7DLc5ZE0f2//O0CIe2GzwSGL4
         9vt4xQeXzpKiW+VXEWXW1hySbXnfYPXKJadyRlN/7Bw2GKkbXvnIf0QjMBVQuEU2sVZr
         3HCSfe3AbPwIqGNcfEDn0PQ71PQph4P1YIK+CM5NRXsjSjAfjQzZHwaXxE9zgClf93e1
         pwptr9rYZWj737ODnitpkAGS90D2DubbUiZbxNcTYOa857PoE/UDR7d0jK63Jvtg1KjM
         4Z9VGeUdtF3hhw4E2+Cpek0k7eHT49jlI7WK3vhEGKpgR3VhL1qpY0H/Aopg86OeUKp2
         MYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793126116; x=1793730916;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68JN5QHnKCq47WQPiHLxuMujC+xRd0JDDXBuUw27i9U=;
        b=FX57dQ28LRcsgrSrL2fXXKtgnqSCIWlJLvjhL/S7qBzE9SakisCYGteZl2zLn4B3Uw
         J37yIvteyYg2SXV5fS7TcRtpQpRXf5WhIJKrCphZWgfA9GKakuMM2n5gWeTibqWFrOrR
         7dRbdmD5FeR7xcQP5jQlY7WWpdyuZyUN6OSEF+4v6huUR/0BR+rFnmJ56M+GjeSe0a11
         xO7hRBVsJecqzkcb0UqVtBDjDdERYW8mdoCfBY7sn76xXwbCvKRYLvBuFsQ7sTrVHtdN
         dq132o/UXKmJjO1ZdFl7ejNeVGpUo2W1NMn6CJfh5GAaTyODiGh1aDfaGGFx7QEv+TXk
         dmNA==
X-Forwarded-Encrypted: i=1; AKwUvBxG7VqCuawVClp0aqrh6sclMZ2eoWa/b/01LFU2U7n/zCTsNWbMN0kaNNNr8J/wLmkXUnx29EQ4kA==@kvack.org
X-Gm-Message-State: AFq9FYIbtKk58pwBMc1pHrXxZTC+eagrvaPQJwl2eziEKWO0cfZ97y8U
	q+AZIMrnQmECboWYrvv5tiKJRlomiCzDSi6QAdoDGe7o1tQyB4oTQ1MreQz+PCAKZ1M=
X-Gm-Gg: AYBFou3JwVjrG/JwLVpis8bP6ecLiQP0zkyiXiE6v23FU4ADQLtcMhTdu1sfOxeIfU7
	lE3T7/xaw4H5sBCgNB6mqurwv8Z71qfBtcSSqYWTMapLaAIkiUGJrBxRX7botTpKyBl7ltoqCFw
	Fkc8PqvGyFIGbITlYLIhUGV0a5kTyMPlpD+iGfUeKzCZ+svWqPaevZV9yGwxbEMcrjY140Ijg3x
	8HiV1IuGDX8Q1tKbJZNFOlXcdp/P8NXSQ0Jz0hZiZBuIDwxQ4Tc3YmgPA1LxeYkUt2PpWeYRWz/
	CP9q6NjzzrGFltgXflw/g/zAei4LGdWCGh/ISiMENzM85Duc7MDeDNgU+2l/JS+Pd9PCDlT63Yc
	ZjR6jBLApB/2gZe9I2Afo0ZBb6De7z2XmEsN0aRWLfdPuospfEDVgPf7cGE6zotY91mtHmWYsK9
	S758sWhch9cD7DX4Kr/aIBZiw+ab6uLFjvWxVd4exfM5eEaS588DeckQRb03dvtS8wFD+JBIFO/
	QiCHsr/N2BOe5ZLAvYpOmQoK8K1n1UNlg/yYkTQLwocbp99SokcvXE5RKu5AV7SJN/ekXSC2NgI
	8tyl+gn51t/nA30hJ6WxygymCWBcBQrlRwkoIJHHjr3BhCok
X-Received: by 2002:a05:6214:4792:b0:91c:6d83:60ed with SMTP id 6a1803df08f44-91c6d836156mr52476076d6.55.1793126116366;
        Tue, 27 Oct 2026 11:35:16 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c0ffd4sm110412956d6.16.2026.10.27.11.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:35:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/9] mm, page_alloc: pass zone pointer to
 trace_reclaim_retry_zone
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-5-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-5-9c7d1aca801e@kernel.org>
Date: Tue, 27 Oct 2026 14:35:14 -0400
Message-Id: <179312611485.3837667.16073234237109614963.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 5668818000C
X-Stat-Signature: sxqp6fwmyr6i6h3y1j6eb7ddtg53tcak
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793126117-462751
X-HE-Meta: U2FsdGVkX18Maouej/Z0RvAH3KPaA6Jf55N+kb/uO1sNxFdTojT/gEdkaXA21WQrVbvSVkRuGIBpEvBv9OLYmMcCvsNnt98NuaY6usgIgOICttdIGRKHRoEkDb6adOEhq3AuX/VakHHFoqapbeMb9csk/um/rasjmthd0FrfIHz5AVQuKHQ51cNwNImwZANg8vc13HoL6r2z0HyXcQOXrnf2QjwR/FeFRxTz5sQG7/Q8vfTD7R0h0jcQq+opG40qYAwDpCgGbtoQcgJQClC/hBBPX+Gmhc8Jy1TGYwmLXq1SSfnagL7/V440AQX6DyGkNOj1KJ1HezdqyyO7KhSqOS5Wxr3mjPP8R3CIeYuIOyzNj2oXJttHxwCujqeW6Ze5R++vE9BbnqpQ6JM9kcQiYkbYVgEaQ/8i088NLD665e5nWGNG/YiilUeMTEPf71Olg8esz8X8JQ3TvYN8uZw8KHoCgc0S/0sDa/6Z22Lbav4K+fGQjtpLTh/HxvKL9nJ7zt06J53tBh9xi1IU5bcNTahrZF5V5fWmusCK5WsUXqLeha7KflI0l1L5phmW6a/k1AibkVbS7HaojzD578V6JRtRrBAFIN4j4kh2FXvG6fN35AvZ1pl+B9rlI28ZCo+Z1bDin0wcqunv7ZzpIamuV4KGCnG9zyzZz72d5E2srNptdrWuu2jwFTrFYcxeohdnbb4oomqGdQMoJDMCLPiZOB6K9ee4352Y937wpe82GUO3j6rHfxeZQshGth28KxHwy5xwL0AIXiyFoUgp3Ut/7Fof/M0hyetgb22EA+73Q/wg+xNxCnaIb1Xx+cezMv1fDKWg8BO6AwiQuh7LYoBGLHPNmNxZOBM11TS33wZlDhx1t2nN2sF/JcvG3Ji/npOWlvtObPbdmY06obROZlE3Ex8h3u1nFMZFQEr8BwAdl0tkZv2EkfjCTGOBJrPk5u3s1G3Pqu9gLugzPYiF3Ei
 obmAO5qo
 0o/e3Y7OxASCCSw2/Qg07ZhzP11uJ9zjibYwfq3bFGssYa7Rzqa+oqG1EWhBAZK44FLB9AqZrBOYEOXzrk5zZHqZ7V31pR7mGJgKJs7wk+8Ag99kzvbaBd/fmSjxiQdPXhtJE0OvE6CnZMLrxQRhoCiYc+7rv3I2FjqABmrfqZhL3QkU3bM6+3+4DmU92K/RGNLUeuaPGs6nu8BcIMfyzR1sp3jbangfrKR9q3HrfWnwzJ2JNeSGj5U1UmnzSQlI7pfepgNavYqXqzjjYlFk1Nyt0ZuzKmoBSG51qheKamxbKg5mgjgiu9OI10Cw73i9BlmUZITU6ErZn1e8cubmON7SRV4Y+MjKWU4wX8oQ05RI/jI0/EswCbJINenROntd2J5h6/skaEFz3QhCkjsi6AIYPoOmf5WQD2ax9wPgujPoocj7blWL9tYgduF0u5omSbqxZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 16:46 +0100, Vlastimil Babka (SUSE) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> should_reclaim_retry() walks a zonelist and passes the zoneref pointer
> to the reclaim_retry_zone tracepoint, which loads the zone from the
> entry again to find the node.
> 
> Memory hotplug rebuilds the zonelists in place while allocations are
> under way. When a zone in front of the zoneref entry has become empty,
> the entries move up, and this one can be the end marker by the time the
> tracepoint looks at it. zonelist_node_idx() then dereferences a NULL
> zone. Short of that, the event can name another zone than the one its
> numbers belong to.
> 
> Pass the zone pointer instead of the zoneref pointer.
> 
> Fixes: d379f01de095 ("oom, trace: add oom detection tracepoints")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Similarly found separately and tested the fix.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


