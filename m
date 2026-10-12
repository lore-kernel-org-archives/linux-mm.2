Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6CDCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDB56B0088; Mon, 12 Oct 2026 15:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F436B0092; Mon, 12 Oct 2026 15:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9986B0095; Mon, 12 Oct 2026 15:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCEA36B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:39:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A953A0A84
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:39:28 +0000 (UTC)
X-FDA: 85314988416.26.91A3DF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B2924100005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:39:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo6667aW;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791833966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmphcHtLoa5lN5HKZf3N/rNWg+UFc8RVpn9tVq5WvJE=;
	b=IBbRMuXcrLXJSMv75DMJwzYEoQDacT8YjEsrgBJulG0eTXDA0A8NNOVUttUw6PUt0r0lkg
	Qgfjw1ovnlmsxOwpx3/0Gq5nto7G9HWUY6fnW3MhUF5Q8JDu1i62M5pqL3ehHqXmVDZkjd
	0B3gu5r0YrcOubJipNDpWmqVBaCOTLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791833966;
	b=liB9WZmpgjcEV6ij3ycRnDpZzg4tiSxrtSYxpjqXywcbzMBzQHMdwZgglE2Qn9leURE66i
	RZ/goUp993xhTHDk79aF/sKuT2qtNsaZ25Tg+Y5iRzp1FEcI50CobqlfMTms5fz6haa6dh
	FaNhHNJONxH6ULuor0SLc9udeeaOei0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fo6667aW;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F56E60142;
	Mon, 12 Oct 2026 19:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB65B1F0089B;
	Mon, 12 Oct 2026 19:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791833965;
	bh=dmphcHtLoa5lN5HKZf3N/rNWg+UFc8RVpn9tVq5WvJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fo6667aWdwibX0X+nESPDpiEp8VM9vajSVdYVjODcvXynPJOd495Y8E7acv4Fh3AO
	 kBwB1PV/gkcS35mMdIi3lJgPK3EUS9pHWugLCbrlPj31p8OrSwdF9sVEq5DjtHB0wE
	 ElOow0LqSoID8aw3UG8jumaNQVSqplYoPKOj7hEwPhsbidU1FY0sHU6qpm3etSCyOj
	 utwPMgMBHQ4UzngvTJ5N+NwmZSxQYNAHY2+B+V3GEfEYXsY5jF2sBbGrH80o5MYkAQ
	 yW0VGOTjDCe00gX/WR9CXHJpW0OqdRDtwf6B505qVI3s67LNQOWKc6GLSQsZMXGI6/
	 188RxfXr1t06w==
From: SJ Park <sj@kernel.org>
To: Suhaas Joshi <suhaas@s-joshi.in>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Mon, 12 Oct 2026 12:39:18 -0700
Message-ID: <20261012193918.373055-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261012150045.169377-2-suhaas@s-joshi.in>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2924100005
X-Stat-Signature: r5mk9s3dut16ptqso13kcj1c4obsyhz4
X-HE-Tag: 1791833966-212102
X-HE-Meta: U2FsdGVkX1+K9vif54GEt5Hmr4ARrZE9dbfRmk4PmsqU1nRF7Fa2pMbJzd93LKIff9oQBS3un9QMM0DiQRqyJH4O3XchurKPMZtXGgZEV7qvMOeeCk3Z5tAURff0lhFag+BwrmKSpqtGv+34MXGVibjfl+0mYCROuG1VCZAHl0xQ1aon8N0sSaM9bqahGBrrKOw0rk9Ns3zTT6q4vU30p+9KtSpooF98UbhzmHtuxfJVc9NTp0D3uHLQSzZehyN1s4a8gw6NRpYwaQfsQ56DjRnhzmDmRfdt1SWeemGvQ/k/cCWjVU2Z6/VNQU0OnmUsdMdOex7WrB0xPjwHSP9LpSOxy6liwRzM8aG6rs9WgXaWl30BfCvnhxBVvdgXB6bOOMCmMpgY6EKmadCHykZGYEMfYnf8MkgKlv8CT0k40K4HaT7kW1JkuxYhqe9OUyKbDdAMKE+QDkZOlK1wHxwujMM4854nZZTiJ0P9K0QS8BuX24ER3B5ajZwa8I/Pg8d6xA/oE1Eok6ykU3nlglqRX57kJgquJXe27he0VjAGiU7b0fLBQnLy8CrqlZmsEF9Rr3YMJMYhTL2pe5dweIfZsxHIye+Sk3Ak3P67dNdV4maFi6NRnmJ2UcbiIjfWUOzJc1hvuconkGwx1z08Oum2rYXWNjMabCvh5t+jwA5qj5bOPt/BapP6CudfK2f4ULWcJtuysBHCvMan2/WDkT54EoC/kgt7xNno7YfhHFRvYk+EFIt5xJJxrXo+/lrCp8ScaVmfDgXqNzm62ldLNC+kLlZmcgUVGV6HSKQ2qbnNjURIb/+8Zvi9/7i7+cFUwVirgZ4oDN/htX7Ak739zUSFtrGHSws/6Fgvz/SRxmnDR+owoqIkO0erdPeqVVvbOGo8JG/8PsWFzNPhWScQJdbBLpqXajkfJBxNLlqpO7jhhziwWiZq/4l/pPo1K0QURZ0lpy7pZ4OH2JRRmeG7DsT
 0yC5XhtI
 70MwlUQcp7rkt8rOJRtwdvP45LMCJIivZR4KXgvtkVtL97LAu1OC+hHYl3Xii1bJr1w1rq2+w0+cYV2IAQCLx2WA5aDI+fNPTR98GPfI09HFAerNJp0tAZlEPSz8eE/y62ipX5/fEwsmBxy1TE8vbkcPuRKTdGs4lwzbPrlCOPRFtbNbPGrJiM8exvvnOB8/fhVMyeuUKtkhm8vSkb/5c7Ju/TF1kOYvNKJFxW4zpnoB2fa2g1DMog/I6QXK+Nn9TY29S/SLdCS3X1IgrsLDRL0lWtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 20:30:40 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> In damon_split_region_at(), we copy the entire probe_hits[] and
> last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
> that the number of probes installed is less than DAMON_MAX_PROBES, in which
> case one or more iterations is/are redundant. To remedy this, iterate over
> only as many times as the number of installed probes. To do so, accept a
> struct damon_ctx pointer in damon_split_region_at(), and update all
> invocations of the function to pass the new argument.
> 
> Also update damon_test_split_at() and damos_test_filter_out() in
> core-kunit.h to supply a context to function paths that call
> damon_split_region_at().

Sashiko raises [1] a few questions, and those look valid to me.  Could you
please address those by replying to the mail [1]?

[1] https://lore.kernel.org/sashiko-outbox-168321@kernel.org


Thanks,
SJ

[...]

