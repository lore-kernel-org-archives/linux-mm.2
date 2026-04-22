Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4936F94CC0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD6E6B0088; Tue, 21 Apr 2026 23:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E4F6B0089; Tue, 21 Apr 2026 23:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773C46B008A; Tue, 21 Apr 2026 23:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 690656B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:11:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC33F1614B0
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:11:48 +0000 (UTC)
X-FDA: 84684717096.06.A432FF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A0A34000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:11:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K9K/S7g8";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776827507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DllDhPc+da8h88LtBkpqjKegE3sQCMm7b+HwZVYutLw=;
	b=Q3xNkAwgdivnVnnQGvPsA6DoZOHFxtJ5D5feTamaO25QfFmaJmb5dG5ELlX4NOGdSllWSV
	WxUh8KYYRtA0gmdYBjMnHkin0xGY2/igAVllqaRQV3c4O349HhslCBn03AQP404j2trDFy
	WVSG54yL7Pho0hkJ1CtryK1KOMb00PI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K9K/S7g8";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776827507; a=rsa-sha256;
	cv=none;
	b=VYLDiAsqw1mLc2o76rSYsNjvNtjCDy59IKNd8dajG5E6SWx7FTpgEdbQm6JyLh46dvLwrE
	lkiYdkaJcJuFsH+Z8Yo7o73iXEDfYk3lJokiy/Jv044vpFlB5aia7ma5Z/60/ftbIiM7ab
	nTGlpZbb14Afsi7RleqKIQHVNdKbNaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3F4B60141;
	Wed, 22 Apr 2026 03:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F2C2BCB0;
	Wed, 22 Apr 2026 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776827506;
	bh=kyDmemKWiRVmNcj8mIjUyyIMCr2+tlzmxpx6KyHDAgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K9K/S7g82VubryvntE7tz9shrxbGo6BMot8rVkwMFJUhKTxw7lLPIsHVBTazfsHyr
	 nJ7r+a7qeWjau9IqpxLfqG4iFDYZZ6G4+BLbdNbBiXpPwL0ggI2dhNosCaeXJOktMl
	 JUDbI/ycmVAJxq/xHF6O+N06DvPoJXyXVEG4H++ENlxs2eGQusbJ24hDyNOnQaQRtX
	 wvp1c/4aHF7l9ZaOceGo6nmwMC3mwrmv8BKqgP7SmgG3W/ARRm6U/2cnDQw4wBXNKe
	 Ee+O2yllstfEnczIQgNjqZvEGPWyuNJqGpOZPmX6v3xr0e1e3vFZLE8RGdFLjMbF7N
	 +ySpw+V0a8LIg==
Date: Wed, 22 Apr 2026 12:11:44 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm/slab: introduce deferred submission of rcu sheaves
Message-ID: <aeg8cLodwO8tCurb@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-8-harry@kernel.org>
 <DHZ78L9HZ1YE.JY63DXXMN9NF@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DHZ78L9HZ1YE.JY63DXXMN9NF@gmail.com>
X-Stat-Signature: rbmu9rm4as5hody5u84tstqh19b9gajw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A0A34000B
X-HE-Tag: 1776827507-392299
X-HE-Meta: U2FsdGVkX18l29aXHprnTGrxiIhVrQt+5rIoGMpXFuRSmA4K7nJB1pDihRhM50xlW0QaozXcSdgK1yUOzolhBc9BhhETGSWfKUU83+oWo/UvWndeYS2E3fGD471Po/nRpbgoAatH9/xD0VrLO3j+w0yJZh46GE9YPPpmOlcPVBsIvHGogrb8XdRBrckrIMbtJscbmjnnOoq4MkypqWCYA4MTHCILWECM7txgM6xY4nodocCNx3ofHSD1rrSoep9A+qZvJKlEpD84KYT6VTZffhgQp9JK5pVtxYzJeQMpfAhrfT/EweTJFCae5pz1Xu/ayjlMPZcdhhVJs92xSdcByHrn5BTrRNO0be6EUMikj/+7fVw/26cYPDMowJuCMfy2+dYZXy6an6B7A11QqZrvrnloOIBnLroEwIkVJnOnfziXiVZVCm0w9yJ5XU1rmzun229LlYtGufJsG2HaL1pWoKibdXKanJ4t9KUP2rOAjHf5Ksj+/KfOJhfmTzW0Z5pF5IHP8RiLiIEBkyVpRGa9ev4OvDKDVM4fELADwAG1JLRGdiKO3tjMxB8/RWY1X8JezmoCeoJAeNfsq0GvRmiGXf5p//Y5DIDASwOhy8laHBO91KXAmu8xka8o0QkD+qOlFNyG3RSWLb7uDmKm1rGXUFWAYaVOKv+1QOzRhYyQabcdW6uhd88qqAxFp1G3L3UbKAs9048eQhKs4ka0F1olbawz3iBjK/eNjpv2qWl7ceSecXCCqhfJdpq3Lwf94g48nCcJYVx1kLnvF57U50ui029Nc7/z60uXJUcFqOeAKyph+/ehk5+G53vD/2OUE5zG/f18Z+1icdq0+TbHioejxQWvi99Y1sSNy9Dvtqwgst7efKwQ2ffCILNHW/NOAA3jG6cUqV1Cs2jphDWtFwDqZJE8v1ADoaatkPYrP2EDbS3KeBaYFWR+KhuRapHJD64Fp7anLkCYcU2okON8HLW
 ccHe2v8e
 o4U/8bYK0wM5huEGK8MMPaP4DFRM3CU9GyjxTos+YrqBMX1Who+fxW3OnyxHCLjO6uwX6UxqohewzJ9Al+owxnlS8+gLgn6sm2MAL0e7O0ZyFWnFvxXawCPPD3Q6511VG5FL+q45tlbydoWALP0cWyhi9WbJWdth3zFPjawcUI4cIC4fNIXoHh9VbhbahRaRdQKt2tTxmjY+RmMul43iNQ4KOI80LW/3J72J082v1YW5ua6AuWdLe44IcVgmxgUWdg4Yd5DnfPXHsMmOp5Ldhij8B56YjUy7InLZ3I+4FThpyBg2/9zL59VFEtIrPvL7HZsVKzT3GlZFz51++IqWgRD70a8ZPdLfcN+I5NEUN2FrGepCWkPWiSphZ1mlqkdtWVILYPh7fe289C0tNwdxsFSrPCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 03:51:02PM -0700, Alexei Starovoitov wrote:
> On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
> > Instead of falling back when the rcu sheaf becomes full, implement
> > deferred submission of rcu sheaves. If kfree_rcu_sheaf() is invoked
> > by kfree_rcu_nolock() (!allow_spin) and IRQs are disabled, the CPU might
> > be in the middle of call_rcu() and thus defer call_rcu() with irq_work.
> >
> > Submit all deferred RCU sheaves to call_rcu() before calling
> > rcu_barrier() to ensure the promise of kvfree_rcu_barrier().
> >
> > An alternative approach could be to implement this in the RCU subsystem,
> > tracking if it's safe to call call_rcu() and allowing falling back to
> > deferred call_rcu() at the cost of more expensive rcu_barrier() calls.
> 
> Yeah. call_rcu_nolock() will be really handy here and in other places.

*curiously watching whether RCU folks show interest, so that he could
 drop ad-hoc code in slab*

> When you respin pls pick some tree that sashiko knows about.

Yeah, adding base-commit id appareantly didn't help.
Sashiko doesn't know that we have the slab tree :'(

> So it can apply it all and review it all.
> Currently it reviewed only patch 1 and failed to apply the most interesting 4+
> https://sashiko.dev/#/patchset/20260416091022.36823-1-harry%40kernel.org

I heard that at least Sashiko knows about mm, linux-next, and mainline
trees. Will try linux-next next time.

-- 
Cheers,
Harry / Hyeonggon

