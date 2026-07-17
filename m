Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35254C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F7F6B00B9; Fri, 17 Jul 2026 13:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1355B6B00C1; Fri, 17 Jul 2026 13:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073876B00C3; Fri, 17 Jul 2026 13:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBA096B00B9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:26:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FFCF1601B0
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:26:31 +0000 (UTC)
X-FDA: 84998947782.20.B4C7F15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C645020008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:26:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eq8Ng3s9;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAK2U1t4VLrXzqivKyXPpAeDcpRK9SdlLlYcSqpm1Rw=;
	b=PSW8NoOD78LCy6MFXtMe7+zEOII5rVR/V5tmRuycGI3PXuDofFjdxHeDDwF56nKoBWNdl6
	wxqeYAR7nMs3QspF9cLDB3sz6YwBfG6iJPyyMlf1H1pAXvkCxYz//5uJSu+43IMIX9CFHh
	IzURFitaUFJE0pcgZpQXx9kjsha4pYo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eq8Ng3s9;
	spf=pass (imf13.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309189;
	b=oW2eQ/VF6C/yQPJ/ERufxBurVtoJSCmPEXJNIWbhAGZ3OWf7SJAyd+N/UoNOS5GmHmuEmW
	4Vv+QDDRzIcLwHc7w6RKHkJn4SzVusl08TL7ZI+923xICrUZckRiwUom0FYZaY6oWmXstP
	hLN5TDs1IBScGojV2n7b/Gg63txjC4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0724642E10;
	Fri, 17 Jul 2026 17:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C0A1F000E9;
	Fri, 17 Jul 2026 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309188;
	bh=RAK2U1t4VLrXzqivKyXPpAeDcpRK9SdlLlYcSqpm1Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eq8Ng3s9VOHlQriXV043RpXIKYLuUf9RjW4hvAtu6sDVA/4G9Mbxo/KnTh34NSH7x
	 b/b+WY0eX/zEOqxb4W8NNh6MIhuokuqDduyk9ApGElOZdzhWymR4OUOUZrfJx5o1n+
	 JMUDsDypZsONfslZznajb5UdJUfTcu0dS8xHfzanEWV7z2sIQH4S3SY5fcW2J9EWwQ
	 y6rSV2CUq5XBSRJh+ec3PKt80A5XCUUSdAThy00dJ+rfDR+oy62Vi3V1B7fdXBzHDI
	 4DLuHcOZyO5TJ7kHPkf60PybKmnptNzVFpuih2M0CYbOq8nYwI+Vwz4SllZyrf20Dg
	 SdO2hpsuYlbSg==
Date: Fri, 17 Jul 2026 07:26:28 -1000
From: Tejun Heo <tj@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/4] cgroup/cpuset: update some comments about the
 page allocator
Message-ID: <alplxFeazzK_Ziie@slm.duckdns.org>
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
 <20260715-spin-trylock-followup-v3-2-fc4d246f705d@google.com>
 <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4e784ee2bbbc23b4b97913e144c0d9@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C645020008
X-Stat-Signature: g13jq56pkjowe7br1dqafmhzohisyfk4
X-HE-Tag: 1784309189-139939
X-HE-Meta: U2FsdGVkX1/VdgNJGnaGLbC7u3/8nbDFQ9s9ppBqc0Pk7KImIAYvkih488I/astFSv9VbzknxE9s74pj7v16svEUKfXMPenml7vhC7kG0VOvf10YczvC7h5dgEdSgc0sOPSBBkD4EwGeLcTtGc2N85v0/FAhblLxVAldZ518mzrZezSEBUU0+HCXlDwJHIWdCEKN5JitJnBhHGzWtMNhr6azC5GwJBpsJ2bfoOECdY/tOb1Gv+E/eMsQEtJl4+rVd5FGN7sy6o+y50r0h6HmX7PY/V+GDnexFK0UlQlE/Sb7Bs5NenYF8ws2iZ2EY+IDZCjTAEcZUU5PQTvKdloniuQw2eeIsBsIBzWk0jg48ok14bdeWGMThTmKq1J109XR4CJHtPUNlAL9scz0im96AyXxhNEhVFHvsUcGK3ubsqH1xpHTstmuNhoKZcJ2YvBo3esYX7UTYqgYusRAKHp2cOPk46mzwpCpvmOozBrxU0LD8tg4RL/9269e1oijbvxFdyvh8449WFBdSVAlnijh/giFFSV62pqPlQDQIoqM6Jxbpkuu+/Zhglp3m8+Fo/QrjPkBCmKER4KAz8YhqieG6Uk6Zgn9kVybGEaJK7LjgyiD/PGgNfepWJUjlZoEWiIj1OEiGpMX4SR8P6ChBY8bX330syybvocbt2KUuPgLBIBoMGZ/EWgz5nZiC6I1HtmAxDGemie4tgN12qqNp0Hxblj121f/LmqCW9K7YvdS5tgplP7Geem+XeLLs8gkq7C7ZppJfLU6/7Dsc/2jHyj/G0XYzcZV04CyIoD06Mx01UF+nVwcFWA7EjpcaLkVYl+Kn+G4zMHQoIbDGsTBfVi2CCFDhclJNnPoF3x4dOFHUTa8hyAbDbJQSXG6tUh2fyRijojRwZlFTDljswB0H7apYuvNE36KnaErWCtZAJcLp0o9JAABeHzpcWfZtK8G3yeqiOZGPjZ/NPzlSy4sRaq
 L75fkdg7
 IRaXva64BO4k/4Kkd+qMJKeLd9WXjrgLxJEwSopsodbTlcghvgoTlNrI4J+hBTV2qR4THR/8xiAzHQFPxrADBL9AgND4m4vwwOY0SsUXsvrhK+N/A8cBmQNTpT7w3xtQjF1gqvyfv5xpf6zK5WWrSik4Pu69F/AX6mI1sF5ADjy8pnRXFpE24nPcq0j2pkbWTG2TT9T5di+t6wvfoCquFVmdRW15sQztP63C/MVg7y3NUDhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:23:58AM -1000, Tejun Heo wrote:
> Hello,
> 
> Applied this one to cgroup/for-7.3 with Vlastimil's reviewed-by and
> Waiman's ack added. Please drop it from the mm series.

Never mind. I'll drop it from mine. Sorry about the noise.

-- 
tejun

