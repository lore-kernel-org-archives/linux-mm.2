Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A831CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581998E0116; Tue, 14 Oct 2025 16:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5319D8E0090; Tue, 14 Oct 2025 16:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4210D8E0116; Tue, 14 Oct 2025 16:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5CB8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:50:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A81EA5C5ED
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:50:38 +0000 (UTC)
X-FDA: 83997913356.06.507428D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CDF016000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:50:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axsarSWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760475037; a=rsa-sha256;
	cv=none;
	b=JTYc6nP7rsJJRfehjBk/VxwTDHNXIerbKmHPdexaO9m145E3EfRM+dDKoDgxVTHMsC47au
	CL1nJ3OprO5YENDI0SQt/7aqnwJ0hzAhY8J6BIBF8mTfjTFRXOo8OhV+Ow7fAjO8aIjvPY
	UZSUbe9Nvn/iYLF0Se89qhPJP4gsi2Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axsarSWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760475037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1mt7hrsHnt06SvjuPDDWU079eVk0nFE4tzseKt8Vbpk=;
	b=cFEyfWjtXswNWhgoiogFRp1Y/Gvplp503qam7bjvl7O5xmT0HZGpvwxpvGuGdXw6cWJWPX
	70Pj8z1ORcEOIItkYaRmQ6WSxuYCgGzUdfWs8KoOr0Lrqsh0GXr6cbbgY+OH12R+zh6nlh
	3pbKdwEc1QR0TQ3G+ItiVaNSMToj9xI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95BB940A85;
	Tue, 14 Oct 2025 20:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45767C4CEE7;
	Tue, 14 Oct 2025 20:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760475035;
	bh=5rxoTWolHOm4oraQzi00YA/zUXuac4iY3HiED5t3UAw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=axsarSWx827Fh8I2C7WoflR8ZEe8mbgEs9R6CNEb6ECRF5VzvbWJ7lxhJgY29BVla
	 00hCz190I4TJB55vPEw8SOgjqeKIwZNiDizKvjrSRahk1tH4/0AZQwjEGe6AFvBQW7
	 KMeLDw8WmfkNZa/bigvyqkE8GtU9qkyFABpYhCWiuxdm4ZxzvEPywsTf5N66DmsQpT
	 OK747OQH2ZOYXfuDc5kNybLckElodrxrtoImcUoDyIeBQJ3xD4cAtL9fAycICL2Oeo
	 VVEnQeIDZi1UX4ffYitoGKZ/qhA4CW0Ud24/ggKohRDgxpn3zp1xwRgHW83PZ6s3pf
	 Cz5dN01+ANVYw==
Date: Tue, 14 Oct 2025 15:50:34 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 16/33] PCI: Flush PCI probe workqueue on cpuset isolated
 partition change
Message-ID: <20251014205034.GA906667@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013203146.10162-17-frederic@kernel.org>
X-Stat-Signature: c4pwnkeaewqh6o667bj8kpndwnbz6h45
X-Rspamd-Queue-Id: 0CDF016000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760475036-631702
X-HE-Meta: U2FsdGVkX1/VULTDveSUGphVNJDGNkn3NDpZQvn33op1Rd+SQ1SiufpW0L1+pxUvBIVuIVej6IX4oGaeaq/OqNSEkGiWP/BusnXDN1qgU/b6yRAehqA5iChLFchYf7sQpCxUCik7hGnZl8LEpFFl4hH249ykBzs89s5VmCfRmcRVEXNgiCAeQ7Fyu4vckyG++OoxH2JMlh86BmgHAyF5RTMWMjnN5dJyOtk4p6SbR4DXwTTz1ure0e3ocll+lGTRCDBqY9R8NBN+2AzIB1tTq+ppVL4YU1zJrOIoptovtBcmye7hDzhSwzQ4jArCQA8y4zBZoqYwhD82e9vdX3l6EPA1+I99mxSu1bvZFmmz7vQzHBPiY8AGCYFdlQMlxSMwsSSIRmDuiW0+1ITkyqWN/GFOtQN/18ySN0KBUvB1rU99ComlOiIplQLndCTZAfQGJMqNdFssy/2gTw4SeVtmGfoZ6WOujsioGOwLKxHDCOpwBK7D8XUT8I3q72C4V4kTDhNuc18ltSQitx5bB10gIHzLla6e1gisEIhAKZhZWQd5ro8jGdGbgwGmix00Waf++jQKoW6QTLIyDltCTln2v2LR9Fru4abgiwdBnh5G3NCooiyHO40drQ1UDinH/x9JeBpufZd+7wpoV9whkCEDgzofhMjsq4nuCz2QkRG1GJ857AFRqXzMgZUmBNyux1sxL3Hxo1SpR3RL760dY2jsWsK1ZwAxedwu1bVwEGJUhQGxH6miEQzCVQA6PwCfLPqvSKSXKlrxta1uMoZ7Bh2eFh0bz4Kv5ZKf2YMtdIc4f/XM3eZdUdns9olnN+itf+v/HihxfvkLkX5b9rb4KKuiZbsCO0ZnE/cnsgeRBG4W3B3ZikOzarQh3W5IozZHk9+gJ0VRJ3JFKVMzJcKbiR3gt2t/MZQ04qMQUpXjchgoIsZXQ8FItQDQG6OQDZHZipLBh5jNnm6exV/AyOm8RSl
 XIHNN9LB
 v/6rERux27jYCeG/N9165VfDP6fTsrrfWrax5ycQ/Mm4YRPqJTXewTs8j1gZRGAT74iJq87AccTI1HrjpuVxxIVPbTwyeJOlWzxqBeni4KwmaNfBtdf2h/xK21u/9hKgSWS2kRS9UpXVuc4VaK0sWbWlEZilFszsglCHzAX9BlNp2+DePSagcy7+j3DP2Ioz7/9fOHiU6qtTkASQPpkOPSthuSIxGWsp3JI7YrYvRnkns/oDvlalH0/wi8dW54jOrgoLh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 10:31:29PM +0200, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
> order to synchronize against PCI probe works and make sure that no
> asynchronous probing is still pending or executing on a newly made
> isolated CPU, the housekeeping susbsystem must flush the PCI probe
> works.
> 
> However the PCI probe works can't be flushed easily since they are
> queued to the main per-CPU workqueue pool.
> 
> Solve this with creating a PCI probe specific pool and provide and use
> the appropriate flushing API.

s/modifyable/modifiable/
s/newly made isolated/newly isolated/
s/susbsystem/subsystem/
s/PCI probe specific pool/PCI probe-specific pool/

