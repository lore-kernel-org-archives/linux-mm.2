Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 010A1C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7F86B0261; Tue,  1 Sep 2026 10:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0456B0269; Tue,  1 Sep 2026 10:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA8D6B026A; Tue,  1 Sep 2026 10:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE8D56B0261
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:43:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D7B5C042B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:43:02 +0000 (UTC)
X-FDA: 85165460604.07.AF5253B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7DAD180011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:43:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUmYi5Bb;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273780;
	b=CvC8JR9CKcsAmYAVfI7PbH2cukTLXDYkWFhIoJi2QA6j4LMnpqLeRzyNXg2t7NZleqYR7J
	wtJOJLFUrxAbrTgtxP2m4JijxK+CAdzuew+TL/cFiWLIui4Nwgh9QhV7XeXTSDyAX4K1Un
	GBkPj+JZGkElZN7mdTqQBUSXMTUowA0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mUmYi5Bb;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNFqOdBLfVl9p4V0gB3fi8mbb5maVqgyZ8oGsuYhh4k=;
	b=diPnr0tBRXmaYYixUj30K44LqnvcrGZq2/Z5hjh5glt7rDdUzHqYh0bc30gOC/+4xkzsID
	89G5iOUqnWY7V02k4ePnpDEeexCK4wtCHDURyee0PZQr2Kk5psVMLRkEyBo2ZE/LTl6G0q
	2IbF/4vEVQHGCy4Tul/6j7/UzwBUq6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5D2B40205;
	Tue,  1 Sep 2026 14:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331541F000E9;
	Tue,  1 Sep 2026 14:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788273779;
	bh=vNFqOdBLfVl9p4V0gB3fi8mbb5maVqgyZ8oGsuYhh4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUmYi5BblRiOOYwxdx9bqjWbEjf5OaIktMr6qQ4fkHdQvbz3NBkGuvgzcN6ZEnXIp
	 Du0TTP70YtdMgnrNYdQfUHCMP5rVz5e38jfz8cy5f1BV5osKx2l2tujbzFoEkP7/Ds
	 uUfVbNgHo3/jxIhciafJ+Vh++lPdYtOOQJf29/Qouc8vhmzx7qDTiTE2GOocnmxRNc
	 anZQbnOOflmoACC/YpagMJqkxWkP52TxE+C+zkHZnyyWatRcIcLxmDbJszGdO0Et6H
	 D60Urk34s40tTOIuvO6+8mdvKbFRyarDC8Q7O7eG2s7N8EC4ejBsNBjvB+IxvIkllm
	 B0I4H6AcWz7eA==
Date: Tue, 1 Sep 2026 15:42:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: remove unused totalram_pages_inc() and
 totalram_pages_dec()
Message-ID: <apbkQIz1A03W-wps@gremlin>
References: <20260901-mm-remove-unused-helpers-v1-0-f092d086f7dc@columbia.edu>
 <20260901-mm-remove-unused-helpers-v1-2-f092d086f7dc@columbia.edu>
 <apbbw0A0f98nlVol@gremlin>
 <3a494e29-fad1-48cb-8ac8-d9a20d97f020@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a494e29-fad1-48cb-8ac8-d9a20d97f020@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A7DAD180011
X-Stat-Signature: sqmd5z4uj4ctanadjwr6tg7xd4sobf6a
X-HE-Tag: 1788273780-838026
X-HE-Meta: U2FsdGVkX199pNOJyAiUSrakxm16pLL98UuS2Qg9i8pY5Raz5u6CgKxUy7779qNZICO1oIkA/Kysr05SdJ58zE5HeQpNuNQRpXGnnGEbmU7Ac6SxiK4m6hQE46jC8vW2kaWL+xkWpeKcJwu4x81xAolVmyS9MCovWX6PAGEU+jAJ7FYnWk7rcx6uAIQkXIlRPp0wqYqmUwmapyNjqbYp6NL1by7ENUr7CeMA4sa2vrh9CoWASQ2MZxEHqzqPiej+DjiKly6+5KhvrQme+zcYKZbWbxSFeJlBafc8wyQptYupb0uxtoA26HmkQmCKUMf+26lZAfTsdP4H2sQ9Hu+wKvVUyKGz6QcBLX9o2n0PFEcLPESHAOs6hMJW2LSntzm8UBwXwUAT/uQpSrRt+Q3VoCX5NHrNUN4Tuvfv206PB2DSG57nJO2andkQR2UBWbVoR8yZTjxrp2wV7bNYYUoWlXKVIVML8K13D6In/tEGmvYc7UO+UYU5BmeHI424IR5olTafIvhoF6sP5g42TE6WFVhRVd3Su19rDVScFKLlJmy8QMHpzGAVlLfFvyY5xty4S2YTcAV8AN91bsO8HL8V3nAOn4Nj9e0DAlg78NPyvAItMEQNdIQVPw5yFsiK+X+x1732wHfBnpb/1rnLCp2jPGhTbL0NukR1bRPL9KgVIh3rvpGugoiEcUUFFPZo5nVycQDYpBMyqdLFsR132Re6FXyT8QSxSyK1rPNs6vMj69bqRZBd+iJ7f28Z9sxO+EAKsBg7ENzhT6LniCb7z5/kO8rDxtQyGL7dxlGcGBrKWq2DOPcrWDBMsdutsDfxfy4AhfNHyK7RK9ZQpNbT4KZh5FuXsR+e+cVlnUctBS5fQ1gIEUhl9Php1+woMh5gkxgoaAOr2v6qWA+u0UuO6++OIwQ2XptNM2p4CSuhisOOmIkoU4UwVORt64X9pspbdhn5A2vRCQq+6wdQ5m7ZQgk
 l7Vhc9iA
 ygRnjHARQIg7GJ+/DSOW0x8FHUCatON8ea+T4SVoe0tFWRcguRyMqb4ZhDKRFPAsj0UjZ6KOpGtM/o5KuCwJgj4pKFYfpDT3VvXJu2DqHVlxFF61V9wGOnP8uhLyGMEORyq+IFwFWXNtZX/pKnK2sWY48+q55cnnKcC31Lrb29LeB51qKvrQGINNZYSvFQ/KmfHWc6Ws9KTcEfSXR4CI6h7uT7m1N49B+68h/IipJt6FntrVPAmPmVEyzCD1T6/c8P8e//Kl7lZykoMAhBWPVhuDkcjilN2mS5iw3gOZBSarmzk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 10:29:38AM -0400, Tal Zussman wrote:
> On 9/1/26 5:06 PM, Lorenzo Stoakes (ARM) wrote:
> > I also see totalram_pages_inc() in tools/include/linux/mm.h - could you remove
> > it too to keep things consistent? Thanks!
> >
>
> Yes, will do. For some reason I was under the impression that tools headers
> are generally synced separately as needed, but that's clearly not the case...
> Maybe I was thinking of the tools uapi headers.

Well they usually are, or should be (kinda) sometimes. But since this is being
removed it's a good point at which to sync at least this known-no-longer-needed
bit :)

--
Cheers, Lorenzo

