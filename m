Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E181BCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1558E0073; Fri, 31 Oct 2025 11:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9018E006C; Fri, 31 Oct 2025 11:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F57C8E0073; Fri, 31 Oct 2025 11:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC138E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:30:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36D22160533
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:30:10 +0000 (UTC)
X-FDA: 84058795380.09.FC84F39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6DA811A0016
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:30:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc8FbJqr;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761924608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C6o2+gSZ7eQN7FQmmglEjFOqubdsY6GVquhxGt09nY=;
	b=gzxFHOztiad7pi1HFj8wz0reU24J7Ew7iIt5tEDTLZa9hGs1Zcytfsj9Mnans/zqa8RwCs
	RpWUTqZruvkwpXjoIN8YtezmspUMARvYORAkU60/r4nl/CAvzHW3PCwZvE5emOCZFjkQEM
	uBEjta9SimZgccb9CefgcxU/Xy7D9/c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qc8FbJqr;
	spf=pass (imf19.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761924608; a=rsa-sha256;
	cv=none;
	b=mrn4pKFaou8spNpKdbHTZ0NsW+Fo9nqeGYZFNycjId7bhnUpg+rdwZX9uda+OdvcTncLlK
	6RbspGeixCiZnLfkFRhq7QnVPn/ju2jyhXMPVLET+hya+AssFC4Ite2zupFfU85evM9I9x
	TZHKWXNuf3WN4m0Lge+mP9AQwNtEO3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06DFD43F89;
	Fri, 31 Oct 2025 15:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CA2C4CEE7;
	Fri, 31 Oct 2025 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761924606;
	bh=YN9mFpyOirMJG3gxerIW77pECs9cukfzbQfkHOAQpHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qc8FbJqrkdCIX64uhcGh/3sGHjyZ/kg6c299TYuVaR/EIJqJe7VvR4brCH0bIYjIm
	 ccsiXGVZz9k3yUOR3gfrmQ4kIjoms18UgykNgu+1CPsw1KuPLyFPYP/ri0CslMVeUb
	 vNzzDSei9y78K6SkntbzS3NuE/nOFh03zqzWcjMyZqDmbWPbmwfVj9iGHSmvPPXwPc
	 bLnL/UODhTrwTO/5oR0zP4Ffx/OwNa3rxctvcB2Auk1OYMjRRkNvJeY9CtHVN3Bugi
	 cKqrp5O5IQGjZsNXoECmy3q447y0cXLwfHpdovDId8J2RkKvC1IhxGiQRqQ+t06oEy
	 OmO8wkiAp0STQ==
Date: Fri, 31 Oct 2025 16:30:04 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
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
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aQTV_F-p4tGjdBEq@localhost.localdomain>
References: <20251013203146.10162-2-frederic@kernel.org>
 <20251014205313.GA906793@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251014205313.GA906793@bhelgaas>
X-Stat-Signature: 41me9hy1egpbrabc3ju7ytfksmrqy48n
X-Rspamd-Queue-Id: 6DA811A0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761924608-647390
X-HE-Meta: U2FsdGVkX187Lnez82vyhtP0j42jzDnWwRn4D3+Bm90JF4hOZo4vLAOoATDYhJhTh2a8a42OCAYDnIaRAwCt3qitOuapVGw3kFY+XBX6PHzy6puyxYMogvJHKqO0GrM24Xt1Qki9ksl5JXXsFvlivzW3GDgWnG1crBXA+Mi/Fn50ttOdgHnuzKMP3vD7kAJYcpWWdx4EiUccz7TeKi74iiNoPx8prZ+9lbWm991sk39ZO2nZFOmrDOhzGQwJXB1Vr5DtcTcnvpgpRDHyD93f8wnvgueAFD2YV6nDtDkFl8WSSEee/7PYqycmoUVgUSaso8vHLIhsXs4F99d7A/OL1Jzv12yXSf/YijTaYSTjA4N+KADxjBj2E6pA+DGR6i23bfIq/GjCCZVmUz0XoRGMm4ltwL+xkWCBdXNC2xH8/pjkjrx5vbJtOAqledtwceC/UNobpI5qfAnOQfseKjkAxGyRFmrqxCTuoIMxSyTM3kl3dlizUrMISrX4ALh+AowVL1VnbrVBvL+CNWpBskOFU9dVuw2Mry0bEOuoKMx+6mnpasq6Tuo79s2nRN+HQkf+553xDRl2fW42GcH0LDGBUVEy3tlQVUud3pkiRk1ssC8ymBPl7QcrUIJkWTSuDZjkhx+MI6QKY2DSD/oETcg5LyRWtz15pcjMHXj5VpcOsMvwKyAxvxQahv1ATYzzADQ1bwFB7CnqFe1ObQ5d5dswSBTGv3ta31xHOzP4yrdQJNJdGPckeP3gr96Hml2G6DK3Q03xywuaGyDZ8cGHolwy/jLcyUEw/1s4ErC7oaQKQaLW521recpkJkbKZUt2w+B1f7GdxakU3PthB/Ezf3hlfUWg5FhLFzvogJvuYKBW+guWjcBBHT0CXDDwhjWzg6O6NqQfvqtqMD/HzlWNa5HCroWGymwzKB+O/kgo40GHECdBj7zia+wdHhx29WM7OgVcoz2VWAHVHfZN6A6Mh6A
 gNFAXgO4
 bhu1PKfWychfJyBNxqKD3YqQEN5mtssPHePYO/Z9hioAVn+AEEnFY0z4eWK9TXR7ACRXs+N35d/7h65qaZYVTWmM6pr5AFow16Yf2gL9Us9dRRD6Lc4+VgYr+k6CeN2pC9Uzf5k7MRb7udlVfBT6djzbKV5Xg17p92S+7+fB05EkpfRi9a73RgQlGTEAEs/j3RmwhAtwAF3QLzaRGkiOyao1uIAM3OTcyLvIaZeT2OmINIlMRiOVWkapmcQV9PnAdmvt43+r8ALF/ARU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 14, 2025 at 03:53:13PM -0500, Bjorn Helgaas a écrit :
> On Mon, Oct 13, 2025 at 10:31:14PM +0200, Frederic Weisbecker wrote:
> > HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> > therefore be made modifyable at runtime. Synchronize against the cpumask
> > update using RCU.
> > 
> > The RCU locked section includes both the housekeeping CPU target
> > election for the PCI probe work and the work enqueue.
> > 
> > This way the housekeeping update side will simply need to flush the
> > pending related works after updating the housekeeping mask in order to
> > make sure that no PCI work ever executes on an isolated CPU. This part
> > will be handled in a subsequent patch.
> 
> s/modifyable/modifiable/ (also in several other commit logs)

Languages are hard.

Fixing the set, thanks!

-- 
Frederic Weisbecker
SUSE Labs

