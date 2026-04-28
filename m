Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF08DFF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371886B0088; Mon, 27 Apr 2026 20:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3493D6B008A; Mon, 27 Apr 2026 20:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285886B008C; Mon, 27 Apr 2026 20:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152CF6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:33:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 981ED1A039D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:33:24 +0000 (UTC)
X-FDA: 84706090728.01.AEE5CAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5F761C0008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:33:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jmgxmj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777336403; a=rsa-sha256;
	cv=none;
	b=iVPB8zYNjQv3JUygo7m8ceMjIJ0BnI+NXBgWkB4sLuHlm7l9xYQexJYgk0iIgyDx/V5gGx
	lOgBmjwpWsY/py9thEJKf+txyYSUDhZ9JX/1pGBSVCXDH1Ocl123+le0m/vUGTFwaam27n
	3R4jQDIOlKwN9Qr1mXhVRkWpdZSmIHo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W3jmgxmj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777336403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bC+fZB8sGMmX0/gzU5FkhSeWEYSFhrpFlPHucRK29g=;
	b=XtRjhuCQbhgRik/SsbsfyxcPJ0LPhLJuGpgosO+Q/jNEANvPsGPbxksxIfPyYkIxniiqHg
	zdE6okhWtLOD4f8bhOlgoh0X6X5iw+4c5Xoh+L5+c3FQYm9hO6aDONqYlX6Be6R//PItis
	TIab2Q17Z5NR/uFNbSC6urJzyySeDCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BE8A4084C;
	Tue, 28 Apr 2026 00:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5E4C19425;
	Tue, 28 Apr 2026 00:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777336401;
	bh=ZcdrUd8JxPkWJLg3gCpjoRkvfIkDc4Y0TOh/l4kL4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3jmgxmjb5NsMB8nfzuMsp69890MkKukIXm/8fmi/oAu9/3CXkSuiXwt6PDYr0gZf
	 7fZ75Myat0x/3+Qgzk5m718sTFdDuSv+vQKMSlrXX5rtosbKcHZ6p66XoWH0KBNQz4
	 Mx39vjSDGQkzTkbLelRE2IvPFwZDZWQJIeJFo5tGEF0DcqEXfNVppjoXLU8wUk41Qj
	 IN1Hynk2iSKbZyrz7+rbQsGOv960XvAHG1pEJ5lXeNUa2ObV+UdIF0g6P1mzkSBRqa
	 2a0VvJrHZenwNu8kYf5JBAb+BaCTYppN0dzLpVPwU8MXCysmCUsbsFdTIdwW4YtxWf
	 YgwsXKhj6cm4A==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: Re: [RFC PATCH 00/19] mm/damon: introduce data attributes monitoring
Date: Mon, 27 Apr 2026 17:33:11 -0700
Message-ID: <20260428003312.113061-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <14036b07-413e-4dcd-a363-e7f834d85da3@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wyo14mf95ugj86rs57fjzcyr77k3zgin
X-Rspam-User: 
X-Rspamd-Queue-Id: E5F761C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777336402-526100
X-HE-Meta: U2FsdGVkX1/N7afGPnd7PtEwbLkFMUL69WvKHnYFR/+2MNDoTeEW4ChGbuUEhPOJoKhbu+NLmz8sEZ0Q7So1QB+See3UGXeLTRdO/25Y6ta/W1GGbq2Cwe5AaGeG8+Cgv0NEZ3Sd0ycKMiJ9Qfa99QcS0CeM+iaTVAy6EJHb8ObzydewkTRC2HC1eb9sETUSzVG89hQgCPosvi1tz779H7QZ2cBlLQR8HTpcTZh/sTRZKxqsCt2d+MVKVH9cn3xCDYcRi3DJM/oWPUKCuc7zjMR69cL4tO4nx6SXjWrzUDYjWGI/cqU3g//X4EosBaaWQQCNsUmHeo+g4Tq14DhkFgOyiiw2mwnkSpETpPkXdW4HqxSx1ZQIwWHitCySKuDqABmTkORZCSIBJDWtL1wKuvdXlmu7sxHUC/r7tnQkLiw7VayiCKgkOqAA1koUy6TMgIHKhpwv/5KvF+nmW/PfLmnfOBKfDgf4dkAJx+OlqTNi77B8pJyS9AKaIGNSTFrk8zD+KdId4ohjSMvr9TSSPHG2HB2BvicVY8oBRBCJoa8YTqmmQeJMHutmskmz6ZX6hbkQ/XlP0pftlHuZF01fxaRAdk+zSj6Lctf8p+cmmOBYXZCMHiOgHmUoCHoZp1UibqdrAMB5q/VCybbqPvp1L+E+TbyeFOJCKuojP6v6dnkgrA0M4gBuH14rpfmdI1l+Y/S+Bi+G5J3nZUK7lu1XEkgvErRVPyCST06wSRbvYnA/KPzLYV5prdpHluhkNGi0vfFG3cimdE/SmkcggyqF1PCj8b2CCxdUsslb6z1MWbKT8LeDO3wbWbKC1EBeWVoSJlCU+YTq8kILbqgcU/M4tcu7QyqaCzeRIc0F2LV+bTFofTrODYpjgEFeTq7GrchTttYqPnihamj5XZinPBCkZnT/vRdYsa0VuNKy9ItcHPycneUSPQtTGU6bSRqv5P+Rx/33wfJrvgQMiHG3dKI
 tkrd8nuq
 R1tfUUHbNnSLiRIn0FhVlwZWBmqI/BehyKXWKMpENIrvAY2TGAhv3m47SMMB/izMavJ2uaod5cL65cjsnMNgUfo0+e4icbayvRICb6+OMuYCa2JMyX2LhGyXGiGraa6f2EctqdOm+kUls2lEruJ4V0GsJNZ7UIBijw7xCaQK04keYtWXf/C1I4KN0qrnG2SkMaOt8C2RUewNtKhDtebyD8rlguLg0d8VyURebL4keA52VfIRmnkQZ6DlW9tGON4Q9+RrrLo2fMpr0FQxsBngH38bX+8jVwGwj72Qg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 16:16:07 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SeonJae,
> 
> On 4/26/2026 11:52 PM, SeongJae Park wrote:
> > TL; DR
> > ======
> > 
> > Extend DAMON for monitoring general data attributes other than accesses.
> > This is for enabling light-weight page type (e.g., belonging cgroup)
> > aware monitoring in short term.  In long term, this will help extending
> > DAMON for multiple access events capture primitives (e.g., page faults
> > and PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring
> > and Operations eNgine" in long term.
> 
> Very interesting. Looking forward to seeing this in upstream.

Thank you!

[...]
> My main concern is about potential pollution of sysfs. DAMON is already
> complex to set up, with a lot of knobs. Adding more configuration options
> may make admin's job more complex.

You are right, ther are a lot of knobs for DAMON.  Nevertheless, each knob is
simple and independent, so easy to scale.  We also provide user-space tool for
users who still want to use DAMON in highly customized way, and DAMON modules
for users who want common purpose usage of DAMON with minimum tunable knobs.

I believe the beginning part of DAMON usage document [2] is explaining this
point.

FWIW, I'm also working on DAMON-X [1] for making the modules based appraoch
just works for more use cases.

> 
> Do you plan to support this extension in damo user space?

Yes, I will!

[1] https://lore.kernel.org/linux-mm/20260307210250.204245-1-sj@kernel.org/
[2] Documentation/admin-guide/mm/damon/usage.rst


Thanks,
SJ

[...]

