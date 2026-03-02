Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE04EB3637
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40976B00B0; Mon,  2 Mar 2026 16:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3D76B00B3; Mon,  2 Mar 2026 16:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5A56B00B7; Mon,  2 Mar 2026 16:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA916B00B0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:50:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C1B4140341
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:50:23 +0000 (UTC)
X-FDA: 84502467126.17.CC3E0FC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id A012740013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:50:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=edsmp5Uy;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772488221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5lnpElzH3MrjN324K8FfMsrblMzRrAFN5P279ZSW+U=;
	b=FYKXPWOum8RiDh+HoWYSce/UmCJnQlPifATTSStn6PsqFWfnb/IEZc4KucBTZwis2Rh56P
	VRm9h4LG64wWfCqxsI62TceN41DVsfAyHF80Wc+PQvn4I3Ost6JQGetm4yscuP2GsHRaaw
	QhZ7NWNBZIudBDbwdwamYMl1Q8EWd94=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=edsmp5Uy;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772488221; a=rsa-sha256;
	cv=none;
	b=4nULspD4fVzAqhFcLmR2fvnaxDVgEWgph64nPntKxMMrHCT0X0vdXHfwr0NV+9UWF8udC3
	n2UXYcTh7oPlctb0j9NOZyrRVS/TZG/KMih314ece2viWAF8f/snb9BAPIBbhDO62t9kJW
	DZcQc3TuA3nkZJhRDn1LgPA7o0aYmnA=
Date: Mon, 2 Mar 2026 13:50:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772488219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k5lnpElzH3MrjN324K8FfMsrblMzRrAFN5P279ZSW+U=;
	b=edsmp5Uyhp5+B1N9dEt7Ode4WQXTQ5NrBczor22gjqdJcfVOgy70wrAFZ1cjUnP44vX1pi
	OCCncG5ES3YLQJaypPSomfxvS+r+TxAVX8YGBiYEbd+m7bAfZdlq0d+1BuQnPhIlZKC6kk
	2jCr/YsZcO2DQOo4yubQ0oMIb/HONPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the
 !locked path
Message-ID: <aaYF-8p5Gvh3Kil-@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-5-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A012740013
X-Rspamd-Server: rspam07
X-Stat-Signature: dmo8sm87pcdq3358uawqgnmtkkcs1r4g
X-Rspam-User: 
X-HE-Tag: 1772488221-491237
X-HE-Meta: U2FsdGVkX19uS75e1hPnwCq28HQAxlTpOWnyoSmkmVZ3jIqoyrJH0ge+3DwrLvC/upjXYu7UihhbifS9bwVgHzef3Q9YqrOpvaSsfy7xolMNa75hebh3zP7KCBMp7cIO56P50eMJbIU8cX3JQcxv4IQrTUTT4Leu8cpHO3t/VrZ2AffEB5Stwk9jbI3adQN1FkSI2kWoZFIRvUaGu91hwm0LaQcVrtpDGfjG3kqtL2BYn0ViFj0PwYf3XSJq+lPpTGK84nCsRI2oML86Uk95NMYNheTPE/PVamo7BcW6DW6LySHvxddjbhUH7We27svONeW4MRojmelVRiEqbcE4Lp1YpQFjFYI3Rtfhh85Y/x8c8MKTMcodDYj4QaBsajyWCCbVmF2iQPVchCwDpi4O12xSX7K+U07DfV8UOykMYbB6rv2jsfiLdIzS2FuHmVmyPDv43+brs5SveRqqeUNMktwL+EzYRwWWatOi6nEfW4HjdYJgka+tVciqFglkoQWhrCzSQi8JNwmscxlRFq9oAdLj6cGXiVPAaL2k5ggntnup6MFvholR7RWiWvjGmHwNmIjX1QNbkVT1EdYFufuWNJ2CcSsFH7CXGkUm0O17qcd7DGqdR4L453iveHYW8sHrBOoplLuTu1jK++XrvoqGdUZKdACReDiHcEdXVBJCn1zNYtBQYDC2U1+qxP0Hb4WvPno3LDKmeFz4aFnPeXM6iSv/BrOz4NiY/nPstUNQOX/ewWqFFoOgkROPH3ICr4fKA4OEjvfoinknK/nsElLlv6k3LAEuB4Ybkm5b3wVu2GZyu+DJtKphmm/DJnNlCb6LIXoIc7P+DdarluUL6iIlV+ry6JXnMYbPC9C2oUsY/7sYJnvT5J4lnuYEGSVef6vDKUGhDFR1n5ypYRXmPf0DIWrqGFORTZdjoawscMoMGXrElXvOxqJI+LEnhQErU9XizDqF8GdydfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:17PM -0500, Johannes Weiner wrote:
> Make __account_obj_stock() usable for the case where the local trylock
> failed. Then switch refill_obj_stock() over to it.
> 
> This consolidates the mod_objcg_mlstate() call into one place and will
> make the next patch easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

