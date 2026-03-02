Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951E1E9B37D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3766B0005; Mon,  2 Mar 2026 08:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026096B0089; Mon,  2 Mar 2026 08:42:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74B56B008A; Mon,  2 Mar 2026 08:42:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D24346B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:42:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A55A9140128
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:42:51 +0000 (UTC)
X-FDA: 84501238542.17.59B6581
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E8EBC4000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:42:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1c4sB+k;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772458969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5nL6pl+9mW+ohWT8myYwLj00gIeNCohVyN4wXSCk7c=;
	b=gefTSclHR23FB+h9FCeev2dcFi90iuxK35nQVnKHpshv8n1DI4PvF9v8hkHBzdZKbxLJVz
	17WNiTVINXHHGrmAez/7OPse5CTkUCZrpVm/1qwahLTqUgIBmNT4HguzKui3WdCGOSAqWa
	X57hvf8FirpYPogMw5/iWCHdZmGSlk8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1c4sB+k;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772458969; a=rsa-sha256;
	cv=none;
	b=SPg78WKwF2KHPHCnw1fC09bxSb9rLojnVcRo90dKayFO5H5GJn+36fcelhOvYdP2qb3Xrr
	fjz0xLYF5wu/2OukcofxNQDiC4mqasJqtq9DF3FwfwcuKJ5m3/DzGDTK3eFJkTPkC+HDGT
	k+nxZzuUvWt8MYwKIPzvLEGFk125/Hw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3648060008;
	Mon,  2 Mar 2026 13:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D80C19423;
	Mon,  2 Mar 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772458968;
	bh=T4ELE2GlSVO5CmnLs/7hGrzjhmHmj0CYFEE/iaXHyhI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V1c4sB+krAO6rzRO/3BlZXIkReiTa+ctQFZ2SSgJsfzM6L3rNjATxtDInNdN5WDJU
	 SvsOiKiYjNzjT13mS3ZXu4VU2HJwSBVgvfjM6O/nAYJ/N3lneoUlCQBrfQ1wZ53plX
	 9/P7s2XoQ4uc3JcmUhEGXQXseHnftgmB1in8SfS8fZR3+vqQe55z9A/fmxr+TAE+xl
	 9d6rTSJJJPH7UqznRs/aTMLRtEz8YG5d+jEAjuyyoZX8MvGbPjTs0+gFaxH6Qa9nfy
	 tuYvLqBntsibmTWP6ykzHiUdCP5V8Ufby5roOZQ+DAzHmGiEsbZP7yiAPXNyvjh9Yn
	 ldNSLHYvatfmA==
Message-ID: <75655aa3-7d53-441c-aa08-59b99b999991@kernel.org>
Date: Mon, 2 Mar 2026 14:42:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] mm: convert zone lock users to wrappers
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com,
 SeongJae Park <sj@kernel.org>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E8EBC4000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 66fmxtcezw6uqq88wrmme55kha3ucukg
X-HE-Tag: 1772458969-256418
X-HE-Meta: U2FsdGVkX192SQmWMIxzv+b/mp/zIT8a9ARs4CRg7q/ixYRz7+X4qncOJrkLL2Gd+CW2/sY+TELohNijEds7f4Rc/07VghC5DMiu2o+nI4ufVrJHZMs91CH0napqSX+6xvvwc+pif5bNShsRmyTQIIkY+DZ0K8PGEzwY5HNv+x+d3DdC6fSGyBcec9oO773rpZluLoCoB+RoGNsybGqpHHH59jQMNM93WAUIlvV0G4G5OGgK0ksfdxRxApduWZPm2Tp4jOnsPSRqyamQeWd2c+2/L5Mymbg1WjjDGccmkcppQ96z92W09DKR2MoMHaupGxbvUZSp2D6mvUhGShow2am0ejoZtYq3jZb/+MrLHyROVRNAHeuClRvTDVFK/8vw0cQvheMNrqy/2f+gCPhs0sfEx7BTcuoflnGiu8rs0NTyvZJnxPqiCP1hnCFihxzOkUjXkFgyoKHWTd+m5eUFzK0K21KA65Rd5rvZiwUw5s1yD4J1SzaNLbSgweoHwfvP5S+PqWvxNGxIS5nQROruPt8noAFPhUYuJ6BfYotJiPmCGR2X6oLjbKll4tcCsrz44ioCgxrBqnOoPot8bpLp5FXj7sPf+4kanrP1pkphgTCkuoB57Oq9LquwcIgjzExZ04BYD3doNZtmofEobfEnGcuzkjZqaJIgtRBHNjTSvNLjM4dMVXp300+M1gAJ3Uo9e7uq+pdYfcU7M695bzvk9Iz1JO0TC4CqcAcB+us7hTycMaLID5CNDYUq1UvL5BOaIgvAdWLTpHgA5UFimCfa6AOGrmg0asZqv45LIUydn25AqZD35IdsXvjIb9ZkXXCTPff1WoraZCYJtZqZ++kLKCu+jdTo0nYxMiBoAt1gockb8kkaFaSlNeuwaz8QcdC7hCqL/yIed0i052adFDEDTAfSu1OwT2WtbXKgU1YpC6Ax4ZwhxIBVAGPpL9mx3i/V6od8tNWxwYRyPgzT0fr
 LUP08PgL
 5kaOXcNt8H9Y0I0e+IIUHPr8FRrU7DIihaGeLO/lzWVxL+3jxGpBKn/KdsxNv3BlWfluP9I4V23MXuTA3/lV0ceRA84zSnVWqZ5XjzX7ALLlUQFNVtKTLOM+YqX5vCflYfinPZkElGcXcTrNACYOqPqBSgzaX2CHUuLygoncr1nU9R9j1ND0gcV8r6ABZ+aCiEiLYqsjBEK6CswCQPMpWNPSOPmJdlNvPu5D1c21MEULTpGNaFPQnOvYw9tqKbKQF67XgWSA4XP+Ood+cfz0ZyU6JR446Q/t9TEnMMlhHjoDhfoRgAmc9uVaeBSGgEe1wC9ayGa3/w0TjlzzlIjHaRmKeyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> Replace direct zone lock acquire/release operations with the
> newly introduced wrappers.
> 
> The changes are purely mechanical substitutions. No functional change
> intended. Locking semantics and ordering remain unchanged.
> 
> The compaction path is left unchanged for now and will be
> handled separately in the following patch due to additional
> non-trivial modifications.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: SeongJae Park <sj@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


