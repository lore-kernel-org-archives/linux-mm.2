Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8709C606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z1WvDcxE
Received: by kanga.kvack.org (Postfix)
	id 6B4D26B0AC1; Thu, 22 Oct 2026 22:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665986B0AC4; Thu, 22 Oct 2026 22:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B6B6B0AC5; Thu, 22 Oct 2026 22:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC7B6B0AC1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:48:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A762B1601A0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:48:01 +0000 (UTC)
X-FDA: 85352356362.09.D87742D
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf28.hostedemail.com (Postfix) with ESMTP id B79E3C0002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:47:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1WvDcxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waGF8VthxuGr2cf9AIuvHuwULN2Uj1gYJg+7Hv15GnE=;
	b=JGDUh4BzGz26PSgkLvc59t61E4CkrH4Kh/QTGRbbPZCseAbkH0102/qgprkZVfoBi00MYh
	blc5JjWAwptiJE7eib3+y0c3lU+8EF4ulmtKy2rRclQBERXEpHCWqqr+stPgDc0N6iAnxm
	UkADI+6GPHIl8L9CVUvrRt5oX6PfGV8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1WvDcxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723680;
	b=C1sa82joib6y/2Y9iA3FowI3O9aaQFMM2ALT7ETSGjTAAL9alYHAOeYUKuEp4Z6RfjVshE
	PUuvaQIfYCJ//g9pa/GLqTWDVmncM7ODlaIZ4AhGUNWpSP0ZL4IXqb6oby2GmGpW+mXJkB
	NTpgUGhnyoyAoi0KIMEsI+fN24AX2cs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=waGF8VthxuGr2cf9AIuvHuwULN2Uj1gYJg+7Hv15GnE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792723678; v=1; x=1793328478;
 b=Z1WvDcxEZIoKaKFWzQsDJQ3hNk2osq09+g+LsdI9P67ej0GzjsQw7KKTCvHdiKgKcBFW4tbC
 Wx9/7k3tyx/DC+298g+YxsxhTWw+6BoqdFNTytfmDHY8BXvGX1vVH3NJ0CXCn5INaQ9yfpqc1oe
 CeGeSMubO7h3adC7o5CjwB/8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2cb42ed3f8acdf14;
	Fri, 23 Oct 2026 02:47:58 +0000
X-Mizu-Trace-ID: 2cb42ed3f8acdf14
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/12] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Fri, 23 Oct 2026 10:47:48 +0800
Message-ID: <20261023024748.28413-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-7-songmuchun@bytedance.com>
References: <20261020115824.823278-7-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B79E3C0002
X-Stat-Signature: 5wu5j8o56wbrwywqgdpfqb4j1ttr5gmh
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792723679-677455
X-HE-Meta: U2FsdGVkX1+ULbgGfH15W3V8ZXkjCfKimIAiPTHSoLjabd57wC9utZ+H1UTba1YEr8+7MJ9QqDrT3js95jqaOGfgjx9etSaL58mGYWqz9lDo7djB4Dyux2zTROYLxETBEbT1omXjeyZNDS2kczasuXm8Fz34BO7/lR/YgO/zhHG8wYvrj1X+HLIrk6dHR40ZeCu5rRK/IEu2D8bY/xBvk97HaowwsHjoUETnfA8OmYq0PrKKqVmb6Nw3Kq018jrmjuLCG+7rAmfnZsEK6c9F5gE1VLEFjron47W7GMtA5yhYmzOQVQhg7M7XJ6XSPxlsqO76ltZ0XGd+B8oAF3Lt9O6nWbihOhbjH/rJr5iD2TQ9pp/V4KIPGAnLPznl6Ho7jt+vnioSsQ424WcvZT+QUOL9c7gatYm1xC+AoRASbFggZdFDkqRhAFPUT35v8vr9JJYB855HUZNTNHGME2fzIrDr0W3MS4Eh0UOAncRxDvFQk3JWuACGIb7mmeverN4+p57wQt9w6t2zPdf+mTLqnEbDOvOiYlqRUj0qGwO3zJBSeNjNpV7MFAtM2WqXtAuUY/A+LHqR2CsNMGs2K9++JPoODvaHbl/Y5E1nEIARl8cnPyyPJkDyd3FMqSCoJ2hMkEb3+0hfjtMm09T6DSErkzxUNkIbQI9RmZ4OuH3LJgg4xXNb4OAhVYKOtKVYaMnAw8M3Uy63xjvaTiu568T6luXS41J31iA1UxxXKUoyKoTKGLGox01xij729Yurf18ZfGlcvzzThht1a1dZeudx3sTWAsZb+i6ScnCE9m7mlxbmz+0JJWKyJwffHuWt4EcU6vu3ZwDuPik2dWpeixVPQYHoAmqz7vP7QAhRNeD6wqqrwI4Uf6EyTvNTJhl7nCULnFtJIbgGr/cQiPXi8v9zENUmxt5zGokcVEEkl7oEGiiEUYPVeEbQy9ScDiBrpbMYpxjsQDjJXRlSm46pQ7/
 nc5TfTM7
 HPbKRHFf/MT6BxTaDRAYWGIM/7d31iDKol6jTP3CA3am2oisJrlgsFevwTBv34nkAgZni3z16P6r9ueCGWJI8QEICyENQubhNgfBq5DI8T9OrVnkMg6IzK+wti7ukzNpg00UTP8toCm+FyGdkDbkpuO019jXqT9oxrOh8DeoA7mKC/uqYdOK41raHLVdspvLvfWweXVnv7ZTApOwMqI8QRqV6MFKEnE2pC7z3uurWYp+qIbG5QmreLoNs2h6d+E9VEnoxvp7QttRbcLdHi8IXFdyGNi0woiUDeSAWjtq3uwhVyOzmRaC2d8gyng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:20PM +0800, Muchun Song wrote:
>Keep alloc_vmemmap_page_list() together with
>free_vmemmap_page_list(). This also allows the folio-oriented
>optimization helper introduced in a subsequent change to reuse the
>allocator without a forward declaration.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

