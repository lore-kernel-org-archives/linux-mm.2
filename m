Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DFDCD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BCE6B0005; Thu, 14 May 2026 20:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505C76B0088; Thu, 14 May 2026 20:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE876B008A; Thu, 14 May 2026 20:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2732D6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:41:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B846314064B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:41:43 +0000 (UTC)
X-FDA: 84767801286.12.B50A45C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06FC740005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:41:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuT4r9ID;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=va39rpXGLdqHBiDYj+a/9hi9jm9un0DnHoH8FGQXYww=;
	b=dAB0fNptKOOjZ/NU+L4ounsfeITDGil6bwbNaaAiyvZA2QPwIJ3cN5n+lGqpUUa2Qpukpz
	OjjgOcez47COAqWj8PMxif3t7BYa1wM9eBn2tx/ba13bNctsAIEKU6yW+zNfmSbJjC5pHc
	PFD0WzD7QGVD2L8ctiD5NRwcTsr0B+c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuT4r9ID;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805702; a=rsa-sha256;
	cv=none;
	b=kBY5vci57TD4WVlafT5+d8SqYfoGeWu2GB0/Yypp6/EE13U09Gy7gO7rDGkVhIi8S18tbA
	VnL/4IybeEW84bEc0SQO/wpL13yPLjFthwQwImvaErQhOKhr/4G8uceB40vY17Y3YhyeBk
	+oXs34j7lTgwCDzB85YIZ4o8+S+RU7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 615D960008;
	Fri, 15 May 2026 00:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C266CC2BCB3;
	Fri, 15 May 2026 00:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805701;
	bh=bJO/kE6QL8D7YE9Smgjkz8t6WHx6lrXs3dUs2I0Uj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuT4r9IDxhWGJMY8i0Orgn14YjsiKpbutBYqr8dGd1vTCRBcCuUCOpewlaakfONzp
	 QsxEHIe9sDc85rA5RZcp8xojiuICNxgnTmNAHKaFbSqh4/ZzO9uvueP3i/hdhp81YG
	 jYiyZrgCfo8Qy2QtsNB8v3ogmc1aTR4A1K09bYtQm9Z2Ikz7l14XkOsJXtojO1qcRh
	 kLFrsPZLLMPp9TVihzV7qtthA/ALQQxy9k8u97Mk8qyfT25CgGPep+biWvpjLHeCzJ
	 JfkfUlUnrLK5+NWtxyZhavCQcKPmj9hL5Zig4+XRMQB0uhDBDOxozoYvru2IMCNlId
	 BV4SEzx1hK0jg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2.1 00/28] mm/damon: introduce data attributes monitoring
Date: Thu, 14 May 2026 17:41:19 -0700
Message-ID: <20260515004120.128430-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06FC740005
X-Rspam-User: 
X-Stat-Signature: ae8haac4gb433aiebgqmnwh6e6qc5edh
X-HE-Tag: 1778805701-724054
X-HE-Meta: U2FsdGVkX19dSzvE7cxNXiBC7rXXV96jdYL5uVV7XltlrXILDMf0wQXFgliJD9O7BrMAPQFACdyImiwanW1QikyLY7idvFbgjbZFsa8Z+PrslaZE2HTtTHB6nhN7RhXhJze5pB5BlM9G9/bkPFU5mEy/lelZ18tsqz4GD8jDUjXGU7f/L6RSlDgQqOzLRLPKLp1PH7KhMTTxL71qC0dFG1WcSx6/QdwV3j7yNNfMH2c9XtuUahjAptLdaWPm8mnBeua45HnYtMfp18hA+Hzr6EY8hY9zEAvzPPWObfH8l0anCOYsrRwDEBZ6Jrjm6XIMynpBOjqMyGaT74JUSqwEEUT7hsxSLFvYHU0EssmHvGHwace3N7JBAxafNS8ekrw8MhTaxRaMrtdRFYxSHJHYH1bWcG7SHOzulphFODtR+UVnt2W0o3rNc6V+MwHqRwnomSFkNhLzf+xdlQpfHY5hGagVwGWHUAVIxcSy8FPRfpEgKGU6MNzXkLCyH4MCny59/DPZXvCWg6q6CS4Wl4NVKfdhsDMjvugq6FnUcK7+aVbYz6/o4WIx24LRUKy/JjVZuLjkSIBCHDIsx4Os+Pg+dCNayflM3x9HOc/0YhDMDk8k3+AtZBeo4NQrYflW/wuxQYx92nyuMpDUr/kPADN1isPuVJPHl7Ln6wSHCGWCn1MrO1CCG20jYFMyc8yX+muzidxPeStO59YSEKZ5unMGwCNkj7EeTxd8iryTm1rsIkv/h7kasudX9fHCbWuMcjXx/zL7RHBWUTrJ4xG+pbht+iPjq7YmCVRZw07nCrj1jG5lAaPw8RsQBpgWKUdMkGuOgegNFbYIcjaurAPcuatEg9tGL692ahNXlwgSZwpAhdptWqWs1zvmyyKQlzJKoNgyWBV9x6+1nJRAtq11zQvfMwlY69BaxfUhdN4Fm3Ss4wAYuQV4FURXQV6X6Gm7bkZ71rBHPuFzacue9+9W/u9
 bKQTxCAI
 5Rm6Knp/ZRWB6tNqjVF7vpnENdeAMKLbz8u0nmD4/+AIXULzuMGMY3Gc6d1W5StUlsCHMhLz+Yf66njiOxKggOC5qbaJjurEOuEtfvNQTKT1FDGcPIWWjmoDq/avLTNWA140xhh4z3RR3iZKX1oPhfjmO6SgqI8FqLEPdXqn//SdqgKKb10rWEwRdytfXDGDpi4tm4+F6zqOpu5Y9WyjjDgzvsjLaWfkejEIPIt4b53Ztz1G0zyjWzrdIqreoqFstyOS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 07:08:33 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> The short term motivation is lightweight page type (e.g., belonging
> cgroup) aware monitoring.  In long term, this will help extending DAMON
> for multiple access events capture primitives (e.g., page faults and
> PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
> Operations eNgine" in long term.

Sashiko failed [1] reviewing this due to a problem at finding a fresh baseline
commit.  I will shortly post the next version (RFC v2.2) after rebasing to
mm-stable (7.1-rc3) for avoiding the issue.

[1] https://lore.kernel.org/20260514205555.51653-1-sj@kernel.org


Thanks,
SJ

[...]

