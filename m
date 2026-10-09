Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3185ACA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323846B008C; Fri,  9 Oct 2026 07:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB326B0096; Fri,  9 Oct 2026 07:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238E56B00A3; Fri,  9 Oct 2026 07:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 024B06B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:30:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CFBA16033F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:30:00 +0000 (UTC)
X-FDA: 85302868560.11.26E3D6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FC54140003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:29:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/1GGXq9";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iy4q9fYuwuvIGKCe7XdYXqcAN5Dor83AEgknEF3WNOU=;
	b=f6J7XXTvrvC0aoeZq497cTSo1PX3vOOdlR415QX04foA8UB4kmGnOomByOM5Ru/a6zj+Aa
	HOTH3/5Vee9oIpTAlB8e3zjOjLfBcyVIE/2Lt3LDQdhvmXR1w0H+pjY8BTe+qiXys7AVK1
	1OgyqJBB5ixRXlPoS0tRxFZb3R5o8GI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545399;
	b=F1UoRB7AuqNkArhPOnyPXo8lZKYFHs/ceFGWpfMHx71Ifzb9W2A/X+MuV+2YAu3omNrvKi
	c72hshXTAFqgEfCcMUmQJ2tdhy19VhWX2lq8OZCP7AKSEL/VNfHd2ADnT++moHIV3rGGWb
	nFO+83jU7xXQLBNZu/wAULZg0cli5Gw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/1GGXq9";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DAD560DC4;
	Fri,  9 Oct 2026 11:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FFA1F000FF;
	Fri,  9 Oct 2026 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791545398;
	bh=iy4q9fYuwuvIGKCe7XdYXqcAN5Dor83AEgknEF3WNOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l/1GGXq9dDWhsGGVSPhOO0j4/mw3Fcd5071LUIq/IIdK0wJT15ls9ds0Udc1xXMKi
	 XIh5scCsG346Ny3fe1h2GLqz3D9Y7njVvsPyhr2pp55bL+/nQuHIfGAujMqjlEM54Y
	 t2FgLiTDlsitTB7WuAxcr3E13mX6FCVLbcvFiV6KnCSPl/9qHSq5VqC1MrV4kK5I/i
	 0HbeMsYWg5OHjmcYS+WHFjm0AeJGcrKTrd+TKxUBXzFCPOkkeuVVKDTnn8ymYLF2Ry
	 hAxvmSWbA2ss0+r1lySgr9l66xA+OuwohuEyuDKU3xxWg2ZFgQ5v7ZGh9+BjwsxJTV
	 g4kTv1QcinbHg==
Date: Fri, 9 Oct 2026 12:29:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
Message-ID: <asjP0A-59EN2xSsh@gremlin>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
 <20261007194708.2009-1-okerixx@gmail.com>
 <20261007145329.dd944233d7986bc0f5b2d63c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007145329.dd944233d7986bc0f5b2d63c@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FC54140003
X-Rspam-User: 
X-Stat-Signature: fgtgzej46gn7zfjmxkohmx8bs4gxcgay
X-HE-Tag: 1791545398-905706
X-HE-Meta: U2FsdGVkX1++f2u+gd8bah4J7Pgo6wBsiwj//psnEcBfd+1j73id3G3M3h3U5O3pBhd3zGqeUs5eMt4x1keUAccR/Kf9EekEcDG3sj5JSrXVf/Ta1d3bQ9MZtTqIKJub96lUoors49vvXOkU45RCQ3E9sdqHE/YIHGus1cwV3eQ5aA6KCZu9LJJbwFHUnMcdwKUKUA+6+dxkIq0DayOQcM4cN4RH4wYcVutMt/v5SQFj4OAHc9zNf3kPclKyyOUYDI3+vy1BcLOqXQVlJQfq1HOMw5FP3tEhR1lk0okRJhcqGbA+WvYgAex5KFDx5I/fDHCpmRctahNsSEEypt10kjTYINCei8n1wvXgDgColC00N4DZ9wqkhKktSP1lkF526JHPE4H7y26Hi+6U/g16o4DtpWWIHDiVt8B+oW50kfemBolkfMcARDF5gDAIcSUQPVcnxS+CUdb1dw/BPt7OF8oSoMtgJVoNjtMWmuMeEBgwmANkohD97YN9b8vKWSSMSi3gAJUAzg6qu2JHpdnfD7LMJsclqxQKinHEZh0Wpo9nKZm27q48k902/nEHhAaEIdNLjFWeOZZmWoA4i8p+Fe9pHwQ3R4EZKQULIxxDYtdEwJi1zYrwe6TsppKuaXyhhiKVZRyXTMzzPf6m1Lj+dcuVABrlHGvSetEIEBzTJHAmK2c2fjN8tWKQn6ofLFkCQ9+AMLPbLUYMuccS2itP52RNlGDCu3l2WgWkQo7Tz9KR2LjKlueFlk8bS1Jh3J1CHbT6Zh6Ea7BNLGh87Y5IIweG+NBlFzFknv9LVh8kAcLhkG13kuF8Xzk0AVFIJziQK6FncU6bmrVYHv5eqYffJanKR0Edv6lSOvwxFri4HFP0sKF+Cwtcfs9njCyRoemFUvK5gpMLgytEnf8+HT50dvViVKy/TKAg5W4t4YN7GYQDWCUqzT+zaxHZRQaNUDTbOe6d2QcSWOOxUUg13m8
 7olb7cTJ
 6NwwYl9GgjOvegk8F0y6Y4jjCOtFxO2HwfZAE0xFCpvokfrddtNzFfACc/PCtmU5yScWGT8VcsChg4HxkgC+opvchx7ARFbGRlr9lT836hq98TsGqZfOu40H8AKKWzyYvDIvbrnplZQXcS27FXy6JBxPvKZK/wY3WmZ0X1bFR4a4OOBwBt0FCeqMiUXnxX/byvnxgU5cULkLb7uRiN7LL3df0ltDFiM6bztKuehmQdGoluPcF//e40ikcCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc slopper.

Ack on there being a problem, will respin with correct fix.

--
Cheers, Lorenzo

