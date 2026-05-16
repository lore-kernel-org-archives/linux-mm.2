Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1341CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0054A6B00BF; Sat, 16 May 2026 14:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DC56B00C0; Sat, 16 May 2026 14:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33BE6B00C1; Sat, 16 May 2026 14:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF56B6B00BF
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:50:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DC86403E0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:50:39 +0000 (UTC)
X-FDA: 84774174198.28.6FE107F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEE0240003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:50:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VN3fGvEE;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778957437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64GXMPG4kyxjFk7XqaBiJN96XSWwaJWDXnCGYEsOrXg=;
	b=5Ec7FXJEPwk4LRohW7ut2jexb1OWMbMaxYCFhcbi9nYR8+3oqBlRSS+u61aoqPV/VKA2JR
	ipgymHxVnkujQDDwaNNm5XphypGvjFxnJ+z9c55wVF/2tk3973NmaR3dBj6/13QCA1eNnq
	/v7jWfrksnKRQFuJoUpoUMlX1VrSCag=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VN3fGvEE;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778957437; a=rsa-sha256;
	cv=none;
	b=pq8LH32+wCimUzZaRQjrJ13sBCFbLH0nE5rwjzqWsQrQu16JLqZr/a3VXLwM9OzmjCoUoc
	xjrYsGsPp1GpbOpzuhC4VsosiR/G0qSKMrSOsVvEbd7/SPrnaKlmbNIgQqqaLVDzPeuapW
	z+6sXfbAYYDK8wFsYnjVutluTXfUHwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 793C7423E4;
	Sat, 16 May 2026 18:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D941C19425;
	Sat, 16 May 2026 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778957436;
	bh=/mc+Cv8/SoyCbsJ+SUSfV3aQIXou0Zvtdu64a7r8qYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN3fGvEEmvdhLyWQADuEhdcDPWtnDsteqJlC8SSPj08SiA2BC7rARwfG7WMURFPKL
	 f8yvxnb4/aE8Gt4eDMYAMxY9o3xfIU2L1g65OZoy9QyfOH/VwwWprRkgWmFU9FrC8C
	 t++NdPULqY8GumqhbwZ/npQZ+2soy480LiAvhD7e5/mS7syRAckwtveY3ZETiiNVpi
	 XUh6HIio2/H6vUKqL4DFe0uGf9TNHJRcMu4EyADux72g6DnaJGeTqfw0kRh9/b3Tet
	 Y/dZ1iHkp8Z/1b26B0xcD6Csi8gbq6y+UFYUBRfwD7+YgFwrVu/g+r+Aa5cy7G2t0e
	 /aFo9vFPiNAJw==
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
Subject: Re: [RFC PATCH v3 00/28] mm/damon: introduce data attributes monitoring
Date: Sat, 16 May 2026 11:50:31 -0700
Message-ID: <20260516185032.82261-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEE0240003
X-Stat-Signature: uftndputgon8fth9xkr5cg4gb39rurau
X-HE-Tag: 1778957437-496805
X-HE-Meta: U2FsdGVkX18ES7zyzymi+D+sllRVoTA6J9GnKjHqJlKYgP3I12QTHzVsRdzde7GjOLny6K6TgpC/yXxT7Q1l7L5p/CFK1d+KDy6u3G8q8vm/iANZu6xfZIsTkvZkrg+XM6UwLAbpKRn/n/MFoO5J8reEaTsU+ax64ZwDGLmmVLWhVWL7zhbq+drD5i7H2lrwCPCOzWO7rbi3MziFGcTBeLYqo08hOnQPR94tSYFQWR6hSYujyxCxmjIB3UQd5jwYEJYy20aYoPmKz/R/PO062nPQEqPTovvylSpzUwh/l8s8MYnOGqbSvSVam0o5wOWA0n6wMBfAiJMYKmF+pQzETPe0DB+vt5pOzvB5e8e3bLDW3+K6emBaeIdWxG78cMRCTkc/oVSiafJXNj/TQJpJmaRzpSINjTNB+gF6iMg+Zm7U1gEbSXaeHYlHRFrzYjyenN3C635jbf43mmTvz0LE9r0CQJxHCRUEqf11LUmLvphRz6Mz3IWTK/DHTNcQMMpc41/nmF65ZfluqBB4q99YRLYYroKIxgU1+1+AdZOdxV+LlUsB0+BtHSkobwZckBtmmxRsxe4Mh3IvvqKR1porOZ97AHHejopYoGYQB5No8PvcGooXLuw/nf7E4WbDN7IHsMRS2B7+mVZ5JwiUUC9QFQJWh/98Q1v8OHC6YPBh/9eaHxOVlWWxtDhocEFySX46v77rsM8YFKRslrJxUt0zSvcDN746ui+vUFuuAVXdlbpCDxn29uuk8svpkzmUGZ54ZJtuhiNXvvMcGEobHOPypzG6O1KahxbFHSpvOOF5jgYcIU4p3PjpBTRSUtdOYhQVWNwTStcXJEqwne7hmbgn3QiHK+AWiRWg5j8IRnqpry89CMz25clucVLHUTN86+6XvTrcOexCT5l1YKxm/8BrlZlFu8UIy4Is4iWgCXAnq0TpqxUHfipVY3TxXX97bBDJEZHnqj+iC7P/B2yDk8M
 m3zQQWcm
 WScI6tzY3cNVaeb8uN7UdPVJUeSp9w5nAtVmqgwt0D7CsMhvVwtxUOIxjZCtidGTvcOZ8BmSh/O81Kkt/R1MQrnNMTj/8Ge3dMe9VeSDzwz2l8d2HbJQQArTberUbb0ch9XqqRyFQ/iB617FHNYuzspI/ir4ItxR8qHhPC4RTEcUP7jdDiMwMLZrEHwK6T98Mh9eFgxje7noJDwD3fcGIyyXMt2kLn8HILbgtOGUp2LLgXUiQZEgslDQqz1dv4/fGwTCZAWwsHlAVSDwaYiUHYCLT8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 11:36:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> The short term motivation is lightweight page type (e.g., belonging
> cgroup) aware monitoring.  In long term, this will help extending DAMON
> for multiple access events capture primitives (e.g., page faults and
> PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
> Operations eNgine" in long term.
[...]
> Changes from RFC v2.1
> - rfc v2.1: https://lore.kernel.org/20260514140904.119781-1-sj@kernel.org
> - Rebase to mm-stable (7.1-rc3) to avoid Sashiko patch apply failure.

Still this seires is based on mm-stable (7.1-rc3) for the same reason.  The
patches that based on mm-new is available at damon/next tree [1].

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

