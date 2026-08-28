Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964A0C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFA26B0088; Fri, 28 Aug 2026 15:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A906B6B0092; Fri, 28 Aug 2026 15:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE686B0095; Fri, 28 Aug 2026 15:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3946B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:26:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ABF1A3FAD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:26:24 +0000 (UTC)
X-FDA: 85151659488.03.441B8E0
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F86DA0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:26:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ninNHkWe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787945182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaIYA33bfbm2PwS6YNoWgTCXkvAH+DCZrhBuyhFZLno=;
	b=ETJjAbZGrtzMfM7SLEkZMkFv6PImF7sLpKsN3fPOstwHD4x71Fz5xOBU6wx7UERKvZ5EME
	CPXI2r8pUKEHtyZ9a1b/K3UAlsdJhTy7MBDBx9jzpaQpH1czS4KRknqr1aZnbOpoMw+eqp
	vy4xTZtj1KoSN6QViH524GdMox6cDnU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ninNHkWe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787945182;
	b=RplhphysFV4zfnFf7FksNkUGjEPzxmZY9l5v1W8GXfPOpY9p2rMr02ebirTrSn1clUtX1e
	ayqtY+p7lng40h+RMDV45LvfpfDl3KPDHrBOcXzWtPE6b/KcH0/+QinIDt1KxYEPnEmyls
	TJQDgzkxnY8myfk1b9h1KqXh9YVyF5Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4Tq+3yiyziT25C2am1tdF+0Y0aNcGtVzhTMU07VRJLo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787945180; v=1; x=1788549980;
 b=ninNHkWepWX5vcAx9rpStjUaG3oQEHdo/D7i7dDo5F7dabvldZ5DgainjEQ0nyefEnYY9Ur1
 BoVOGqRpjRwfcJU7td4uuOFFyieqXHE7zONIWdkch8K2MS2Rp+IFeeR3/D7xXkNwik5nl8zXVLt
 3AXRGElwa6kRnh4SzX866QI0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d6f9c93dfcbab706;
	Fri, 28 Aug 2026 19:26:20 +0000
X-Mizu-Trace-ID: d6f9c93dfcbab706
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 12:26:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-ID: <apHgs2ZAxAdy8WIH@linux.dev>
References: <20260828135036.7d44361f@fangorn>
 <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F86DA0007
X-Stat-Signature: h8xddxtcid55qnjt5y5crxtkrq15c4ur
X-Rspam-User: 
X-HE-Tag: 1787945181-937105
X-HE-Meta: U2FsdGVkX18VGUGiWJZmbRiYYhL0/9srPtNcgBFaJF3iWoD6uPKe4Xa6hpf79xT+W3UPJll+SuKNh+bugWDLNrheD5Xqojge++YdAjQ/2R2ur5pNj2UV01adWZwOa4DUEqBdaDXPhZt5ws3teQvECoIdeNZEjS4dMVMHVZEDon9oprbg6wpeBe0eP/fo2EL879QwRFqKK+i8kGecVZLi2cQ0ajW0u8aL5upWC9Oz8DbwMHDeYOR34YvVeOJeV+eiuhsiXZmENqwfTr75ggPNidIGWfoKzXJNeL5FvYODQtg06ZHCq9Eo7uK4xwjQYN9WRX+LCiMAxOctbyczjT/+Ww6La0DM6eiAx5U3y+SHeIs4Fx5N4IS81JNTxEDLn9CJclw4skgW9mchFuWfJQmPZU4bua3UZNRo8zlXy5geZ2OmUS5MEgGwDxuxRs+KKnDgkrSmaEhNtTBikURoT1Shd9TPfcKw42yS86OBQ/E5hbkKP5PqUFPJ41Z1bTrvmkzr33ucDM0nwps7GtY91WhZbnQdtD+KJ4MHMr9IS16+D+ERiVja40etz9bXtAvQd6NWpG4Axonhopzwlz/HCC9uZvaIn7gF2I1QkaJ9Q20MgMFpx68lhc5sEb1r99JwTZ5AUFsLxn5uzgOiPjE91E44UZWMonNf+JprUkg7KD4Nx3elrQKrtrD6Rt/KyysbhCaiSAugwS96zb43jylgi0/lJV5gbjGQrzpO7DYwGs0sfBOGxDXSdx3CWan2V+nzN1SQaLswBiuhPeWlR5nrTGE5/fTTaTYiBjHp6CgpkOXy3Zx24u9xsXYDju3b3W+MK4iy4NSnML/H70VBE26G0USo813OFcGsljgs4yPbrG0lfZ7dm2MQV4TaODuzNzzbGvAy/AMYpN9pfYHyRZ9bsdtBaJaTqpVvuZtBw99gcSnxrcymkYo+bSzrZ7POnTy8ZspuShtgLm8IbK2Ca/BsO/L
 xatFzJRF
 3XwCwvKVKtKqpHRKu1cL7n/T81eS3YG9OIcanSKQu+kZmW2u0A1kIvSi5wMy1ys6h71DH/5RHz0HIvTnWjrMnC1rQ2EhqA3/wAjA3GJ5S/zeYAmRynCsp58QIcIZHylnwNxapaf44ReJhWpQxdROMegaik4hSn+zqN+35+fhCQwvooMC0HGtJZm+w7fH8oSEM3sjWP4O/kKcot6ukRs7MujX/LfMz9Ln5EPh1dJvXc9qbwFX7rZKT/ogXIpz3X90sz2WwIV4aa32AQqWzzrV1O+6qO7o8Oim+gZD1kxWeUWrIGaxsSdhZhMUTVPj/Vlg31vSfsBXosjSIbog67x+uwO3A9eqLCd2g5yHO9IyZj5+CBXqWMFKSSC0vd7v3SfkxkNu5aNhhu2dnNVOwywANtEa2LLhDEZQeB7101jFZx3PKQo0LJhilyYU8eLGHCEX5fT4mF8kBrv2vR3rMzaY/MvZ2+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:20:18PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
> > When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> > isolation, schedule_drain_work() can drop the work in a separate RCU
> > critical section, and housekeeping_update()'s synchronize_rcu() can race
> > that second check, leaving the flag set.
> > 
> > drain_local_stock() only clears the bit for work that ran, so the flag
> > remains set and the stock is never drained again.
> > 
> > Have schedule_drain_work() return whether the work was queued, and clear
> > FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> > isolated, so future drains can retry.
> 
> Is there some Reported-by: or reproducer for this?
> 
> Given the complexity of the reproducers which Gemini developed for me, I'm
> suspecting "nope".
> 
> > Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> > Cc: stable@vger.kernel.org
> 
> Why is a backport being proposed?  How does that benefit those we
> serve?
> 
> Sashiko suggests that we ain't done yet:
> 	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn

Haha we are never done. Just sent the fix for this new report:

http://lore.kernel.org/20260828192419.3057939-1-shakeel.butt@linux.dev


