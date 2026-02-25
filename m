Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5431DFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1E56B00A5; Wed, 25 Feb 2026 12:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F9A6B00A7; Wed, 25 Feb 2026 12:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC576B00A8; Wed, 25 Feb 2026 12:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8486B00A5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:18:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23E718C261
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:18:22 +0000 (UTC)
X-FDA: 84483637644.17.AE6679D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6450A160009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:18:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YX82Y4nb;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772039900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23hLqUqZfb0l8tMGYPwGo0r3f7npeoJfW5VD98Q2BVM=;
	b=7EPAAnzW7E5K0S//o00k58J+JrcllcqxnpeCY7cB3fJgAganIc3x002+yAfswBLN2XgE/4
	QNHaJfKhS7LqJ+abFwgu4A2sjHpnI1IgTf42HWcPV+Qm2d3VucAoa703SFF3tre7QW0Qzm
	crn3EpvSSarpY9k3TtBPrd1qzzstEVw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YX82Y4nb;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772039900; a=rsa-sha256;
	cv=none;
	b=W1VUT7TFoH67TKlM2LKOlEMBXaoKNytE92/wb5BjoLtSI3U84ehfpViVHyoGv4NFFtYLQE
	wY/HPTS2cJx3dqlZZN7NfoDT6I2sTanq6IdNeBrjJur1bTR5I724i0kcQFKKRhtFXqKK4I
	cecvFaBMt3N4lOILrsCYQao09pmIwXw=
Date: Wed, 25 Feb 2026 09:18:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772039898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=23hLqUqZfb0l8tMGYPwGo0r3f7npeoJfW5VD98Q2BVM=;
	b=YX82Y4nbN56zvalwnSX4B06QpBK6Gkz2W3LObAqpusvYzGWRtdMDO7XCeQpLqyddb+ZI8/
	dSWSlpSuQq0eWaYOWsaCwT689Fpca6PLhWXO563ZSRvNyUJJ+kr8jKm6RxykD2FdVfXrsj
	scA2lrFSqv6w9aRWimPW1czr9lytm2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ8twGY8HEhV3-Mw@linux.dev>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225002434.2953895-1-axelrasmussen@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: spe1ptzzg4y6myhf9p9w46nscunya7ap
X-Rspam-User: 
X-Rspamd-Queue-Id: 6450A160009
X-Rspamd-Server: rspam01
X-HE-Tag: 1772039900-367798
X-HE-Meta: U2FsdGVkX19Bq3Hl+Kg+0UbzAlR29stqaFhXPZMq0nGZxmE90TFuFdKtcVRH9B8fJWrGL6K2LGwtUjlNeivZlrYaHvJee30ma9II1+ltgpWer8ZZOf+N4ott73sQQ/226RG4XwTAOU4XYoZEhb2CNIs181SDUZ1GjoYD5NJ/WI4ZTC0cBYLe2drCjGeKFo5ezf9VwQMPsq5OY2P4ynUcWs2w39Sa3tKwz8ErO+ewgqV+5tHYDHkAlEFs3JRydsDZgS7YQAl8NIGGlROy4KwHJTQjxlaUXAkMtpcSwcuOlqQeYRt+7Hg6UsHjFWo68IgJNwb3/6yviwuYzC2BU5+ZIY3L/9QCB2xITex93vWL90A1we9FeVml5RVECOzH+SQfnYdwMxthdzI/SVF8NWNE8zKA0JztZdcgkz7ZBdOysLYW2FS0eMbXTgqSDVMjvZLrdUXugxbtt/v4im8t98vt1ylWXC1XLeOb7aGe5BxXFmxPH0vbQDSZwoTELjkOjSt10TCqxa2uap2gV0et0hgKFvVJWVFW1qt1aGIxjUxKjeRC/0XXz3YmzwdgdGKFWwu8p5UuJdzjSnh7DdbSohdOTyrRC86NqAu61ub8+2+aCKkxPL+1yhb+miJjzwER/JuYHDAwpnF875kz9X97Do4LWIEdG+Tg3lVE0qi6kHG90owv0NrTiFccac/2EptAul2CHlnna2f3WYCPTmN4W1zyxaRw3fV3t33s9MFDr2LeQb8v6WAD9Fi45W+98RvaoR9La0PTRI4wk0FIRgZmWF7rBAMiyPJ03gN7myj7r7YVhzKj0RwmT3FnnwOmTYSGZDtibyyBr+bR1seJ3QI24RLDQOfGBuu+jRU+GAusI0A7SqkdMHjAOLB+84hJne85+j4x42MK2K7bfBPWFIikYWrNPQW0N+fju+qaTRF5l5laxYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> But, these two APIs are not interchangeable: the lruvec version also
> increments memcg stats, in addition to "global" pgdat stats.
> 
> So after this change, the "pagetables" memcg stat in memory.stat always
> yields "0", which is a userspace visible regression.
> 
> I tried to look for a refactor where we add a variant of
> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> folio, to try to adhere to the spirit of the original patch. But at the
> end of the day this just means we have to call
> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> accomplish much.
> 
> This regression is visible in master as well as 6.18 stable, so CC
> stable too.
> 
> Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


