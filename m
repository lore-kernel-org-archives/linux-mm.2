Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17FAC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EFB6B008C; Wed, 26 Aug 2026 20:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30526B0092; Wed, 26 Aug 2026 20:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B462B6B0095; Wed, 26 Aug 2026 20:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 914AD6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:31:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CFEE4026A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:31:17 +0000 (UTC)
X-FDA: 85145170194.06.04A3713
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8CC45100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:31:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYHO0fSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787790675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqB1m/96VTfRYII2vqeYFGWVPKUc3lqcw0NbwfK9VNA=;
	b=e8McM7BRHurxa2dInNnColtGx0yejbV0NwpRH2IgfNvuNBd8o8gkdoDeIp9R/5v1OD/cPo
	QMIJklxxhAuPGjyfJh6NqPJ9PuyJIGwAKyMmxwVQF4wON2j6GqTfB1vuF2pdgsUXjkd5C1
	DWVckYS4y0uaRkCkacHZrKJx0HtcHSI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYHO0fSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787790675;
	b=xhMkqSbkzHPlY8PLN7P4qhrqWlAd11qSiwVWlqdm7wLFMJ5UfJKo89iHNTXcf2oOrqmV5D
	WxMlxVKZ/0lgul5giHslL7jyfH5qb9QBUMZzXUB85Jn2xF4/kN0tsNVE7tuIVzPBhNqX4D
	JKcqWSdCmbwQnbJ/KHzI43YfMozEMlM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD6796020E;
	Thu, 27 Aug 2026 00:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFED1F000E9;
	Thu, 27 Aug 2026 00:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787790674;
	bh=mqB1m/96VTfRYII2vqeYFGWVPKUc3lqcw0NbwfK9VNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYHO0fSr8SyrOOkaP9GXUjf398GK+3yEI1OysuNO/GlArC7PeB6xLUseKHLBIH7Ql
	 fzUPFspXTr4IsF/XOkVZN7oKJ5vFLppAF301EF5IQx19cEutRw3lL5auxxuT0ObBmi
	 ax76vgMszl0TbJi+m/9f+g/kd+IMC+nc/dunpgVCA+6oJrNSK7JL5rJlVdNVVP6jiT
	 DxmDm5TicLGgKq4myhCbWkb3CqS0Xvs7ITPOiN2LQD41gyWfGhWc7n66sehBo5/OwU
	 N5cNPImDpWlqGYHIcm5h9wG5meIPnjtAucXhJeBjBoG0TfMjrxlr2mnJcKmpU5a/ve
	 0XglS0R/I7YGw==
From: SJ Park <sj@kernel.org>
To: Anshuman <anshumantewari123@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix line buffer leak in mremap_test is_range_mapped()
Date: Wed, 26 Aug 2026 17:31:06 -0700
Message-ID: <20260827003106.82479-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826061300.14038-1-anshumantewari123@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ct6xcxgo9tt58eax1zw45ytuq354df1a
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CC45100004
X-Rspam-User: 
X-HE-Tag: 1787790675-500694
X-HE-Meta: U2FsdGVkX1/DDN/0y1CrczKPy19Wmi5R6vJXNDxAQM+bkh+ld+s+pPaCCldQGWv7+YSY+7vhy5l+cm70lO80L3/9HI1dok3/4iUYbKxX+gSS4EeWyWIWlWIfkbV+379RrqMbZjlxv4KKP0n9jkOQktVCQ4knm3wLNvdjI2Eq36NwJ9eh1Nw2Cw80XtcmDHbApXamIQ5H/8Xx6eSoegWezDPe517qWKQyGVQ9zR0TvuI970reiywq5pe4eJE5be3IxyjyY8uXsGwfMIeQdw69pP1MVbj4esJaRavsg82c/WBNV9urjiAPN+KnAQn8k+kp9cIAc/nW6/58I0kjR+GFawOPEzzX1Ein6chCGIudBmj7UVVcAQhOH42VlX+yGBGO0aXkRQ4iuaTfBP+ccZaWjMRuiquzKXeqnKxWZaRZxc0wlg6IEAQTfRIvI2r/Ly04YEGI/V3lqtouyAmvP2KcAY2dpsZ1Akj/UbEFV9UpBO5rRumGBCPa1RJR8h6fcrCGHxtry69xgoMUYnhud/GxAq/O4JVznfvOow/4QPgdmCzbilGoDn90zxloQgOM/xngH9PTquWSKOyuKxsXeV/9z17bZpO75tg8kHp+9S+4MRmGakfEt1gJE/dza168FGs3f3vgFts6WdDGW73pNjtBXL9Ywyqy8WJ6TN/SXmWP5v/JCRqD/3XcHERP35O/UFO9+/HDRJx4xBje/enl+NisV/k9vewuEQ2qaDTAEQmEEQIkr2V37vqkVuaUVM9f1ojMOCcMo3MwOfjPzgA7/U7g7lgYv6jrnY+HRVXdJICoO4A2CYsnf5OOmrAgiJCqWnhStlv8KgUbcl6qjeQ9yXckFOCIuZvsx7lByn9kXmaIXYtlMOGqN10levSzFSlfnLPVkF0hZh4Z3u31HnqRlTLzXncs9jxsmIsnK5ccqhn2ETUJx6I0d5Wi0tyADIlLdG930h72CELtUQy9KBunycI
 faZQot++
 2XDByF80EYZl0NrQmw26OoC5SZS9xefoHWKDFTz/FARu1PdEm7BfXdaa6mX4FKEB5r1GuBqa0Min7eOwpQ2sX80Qso9WsQj+6aY/fEZmp/AB9cwIRsYjViBQJtRVYtMcflCr8NkJahegBbx76x5c1D2Hn+Ye3tS1RO7kiHMLqTfBCVeC1OnicsBN459Qy1u5pqb9ZEd/5jftH+He6Amb9DfcO6Qe0+/nZA6Kp0cp2Rb1nTxT9BIeoyYkBcJucM9gyVJwJpL9scERLcoMGijQqaBMaChCHhc6t+SDb1nPl0YhJchCauokJveF9Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 11:43:00 +0530 Anshuman <anshumantewari123@gmail.com> wrote:

> is_range_mapped() uses getline() to read /proc/self/maps line by
> line, but never frees the buffer it allocates. Every exit path
> (parse failure, match found, or reaching EOF) returns without
> calling free(line), leaking the buffer on each call. The function
> is called multiple times in this test, so the leak accumulates
> across calls.
> 
> Free line before returning.

Makes sense to me.

> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

