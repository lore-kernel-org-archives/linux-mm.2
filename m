Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1900C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E503E6B008A; Wed, 23 Sep 2026 03:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27826B0099; Wed, 23 Sep 2026 03:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EA96B009D; Wed, 23 Sep 2026 03:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B42FF6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:20:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C1991203E4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:01 +0000 (UTC)
X-FDA: 85244177802.27.2F9CC07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C1C98000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:19:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pjp16mZs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gziUiBPvy7xlnA9Psh/XnuMh7PkIHbeXiu+KpjWd6go=;
	b=j21GR1CHG4SHegkypxqHx7ZjFm64oAIr8rY+LIKARYUQpdWw45MXdSDbaNZL0GhtKkFUOH
	YM7NDfFBzzds62/QTj7LTGLsrMLiuoo20RekexEQ0K87I0IunxQ4bqjkSoo6DqtiG/93nc
	3Ii0anAqPejTQ9mmP5VqI2FYHBLq8pU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pjp16mZs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147999;
	b=TI564GeV+uKmHo9acX3bPHg/2lHz9uxN5GZrnHeBch+24MGerluiMZskwvsgrjwpb3Y6DX
	pv/gNpMoY7nh3CE6GwcauYE/ooQGrfiKppWOC1KCe6srXwplLDY4l93R3wCjRmRKXs/3WN
	kbU0KFijtxrnvGqb91IWlr0sJW7+hL4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D64E241B6D;
	Wed, 23 Sep 2026 07:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F2F1F000FF;
	Wed, 23 Sep 2026 07:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147998;
	bh=gziUiBPvy7xlnA9Psh/XnuMh7PkIHbeXiu+KpjWd6go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pjp16mZsVP5+uIktXkAWb55DfP3vzDdpoxGQASzoYolcqBMemw9oonzL8IBUYGRnk
	 ekxdXaZVkK34HQAlc6hY2aqFH+PmdtWeo1hBB0QnDq5yilA8uUqhKxaOGoq/PJZQQp
	 cnyVDJpmic/PRv6PaC7FkDs2PnWGVeT6AM7PvYm7BfCxZ9athTVXREu2RIp7CB8pU0
	 n8Z0c7LBPlb2eJmswE3Jm+jlRG71Ls2cTJwtJKVQvdzgNKpsGxmsntfxjD85mfm557
	 vfXzAJODkO0Qp3BJdTUAVR8W4knmv4REgN/mFN0+0h88Atr4I8A+aoFICQpSo4pRBo
	 pXCeKZw1kkSCg==
Date: Wed, 23 Sep 2026 08:19:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Daehyeon Ko <4ncienth@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Hagen Paul Pfeifer <hagen@jauu.net>, Jakub Kacinski <kuba@kernel.org>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/secretmem] 97d34aa65c:
 stress-ng.secretmem.ops_per_sec 99.5% regression
Message-ID: <arN9UtxVQpWqTZ8C@gremlin>
References: <202609230824.7a9189aa-lkp@intel.com>
 <7ea6e90a-e2fb-4793-b6ea-e292388bdfdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ea6e90a-e2fb-4793-b6ea-e292388bdfdf@kernel.org>
X-Stat-Signature: j37g4dcifqzgf4obm5emyq8s3m6drsnz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C1C98000A
X-HE-Tag: 1790147999-882922
X-HE-Meta: U2FsdGVkX1+ve1BPTJKm/YPlkJL5FVyQEN98esiPL2PZdaojHUlTNy3ZTmBWkvevzV/u98wf8vZyNyX2ZyWOCtnQ6Hpt/L1svWAMA6V0Odu6dRSHezwTOllEXwGa46NkZayenXkwWX7XiG+jeF9qeHIcTix4rhlFHbms6T7edCzfLBixtlJG+DaMvd3sMHxR7f91pFGqoOcquyEUnfq2XMisU1ANDTwgoxvUQO/X41MKqsVajEmncn0+Gk0tuaJYWi9M15ADez8IfcS/B9hy5lgOqCWt1tZuW7T/aAvbBbRG0fGYD0mo3g4gqu5XDv1fu3wCs6sykUnJD7TkwsY1heuQnmL1ccU4J50Y3FkyfPswjb5N59YMbYxr+GQFRxaYhktnidf9FdmFegScrop7xtyO/m5jS1V29Uyf/Fa/pF/xKcH/RTLccpD99bE+qcsaC6DUnbZjXNRJfg61wWshNvDMQEpowjnVKVa47eRDcrL9bquyNivkBC4tMkGUbSEjtQyzWcn4V4TimUPN7G8Lu4JeLgSB86TM21NnLPJtKLe1sReq6zkrw/knzkwDc0GCcr5jcbJ8PZXGACycqfcacIYkJQxPL+FMdsqpgAV38/l1HY/4quQdwJ22gW1EZh19nsvj4anJKdskMjRN3KYatT9/55Mus40w+lhUmMEDeSG3iofA+ns4OnAuk6QkJ++Bb6+y1m9EiBV/IHTdcMHVTxxMrzBvj1t343bRvtxxaQRzYduNrHZvIs8XGyw4i5aYJZrIqUqBtyShozYgb9okGM6C2HgvjGnx9en+DtQ5BBn0MK7/ub+EBeY8bMpXPUlHnamtT1ueq2pprSLMbOmtM9e9mWjfPG9HXEgUkWlT/foMWNVnguruT7AEuV68JRkNzvDLfJ5ROPGgDvcyORGa0wD7CNY5Vzal6fqfcK5sBldGz0dsoM03Y0jcBYehF2bxj3OykJVu3sKY+a8ED3u
 BxbxFOar
 mSO7yXPJgxqTBDm7HAkh6+NQ1KyXZzw984AGST2yH6aiMWrgIvjKRueEhcSaUzL6/zN2PFsB9XXXBWFiE6D2/HLPfhyDH8/dfUiKrtci3kXROefo1o43+PA4977f4kJ9FJbab1CnMBsULFgk70FDF72B7oMMTAjmOI0fPP+HrQlh7kxgfZCVjSX79PWnS80pagUE/IFZn2U+z6+hGmnVcoiQJCLLVukbbreVYX7Olq1mmPwiForBhUFMZntNco3do3AE+l8lCCYG5hftwJ5nFmMtgDfAFNnwYcEiUriYk7W8g8HW6+ceJ0w80996AaL3B1AsLHpiDftEx4jVLMkhjhlgjIRCS0GYpNYTe+6BwW2cTr184JksUF5JWlrC0AVVanF50KsqLJl44iOVu77oRozgbmmZZPbwzTlf76sLaVKNBpnFvF5hP20v1uo/wcUvRy0hg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 08:35:47AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/23/26 03:00, kernel test robot wrote:
> >
> >
> > Hello,
> >
> > kernel test robot noticed a 99.5% regression of stress-ng.secretmem.ops_per_sec on:
> >
> > commit: 97d34aa65c29cca85e3e9050f4c936389b38a054 ("mm/secretmem: properly account locked pages") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>
> Well maybe there is some inefficiency that can be fixed (haven't checked)
> but if it's the cost for proper accounting then so be it? I doubt creating
> secretmem pages is something userspace would have to do intensively enough
> to matter.

Yeah, exactly.

This isn't something that should be benchmarked, this is possibly the most
ludicrious benchmark I've ever seen :)

If establishing a secretmem region is on your hot path you have engineered your
software wrong.

This is effectively a security flaw so I'm afraid must remain.

--
Cheers, Lorenzo

