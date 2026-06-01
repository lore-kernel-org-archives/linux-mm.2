Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51213CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B585E6B032D; Mon,  1 Jun 2026 07:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30166B032F; Mon,  1 Jun 2026 07:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D676B0330; Mon,  1 Jun 2026 07:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9937D6B032D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:16:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FE9F1C189B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:16:56 +0000 (UTC)
X-FDA: 84831091632.13.0B0222F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CBCFA20002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:16:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Se3REjaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtwzM/l8y3UephO/mtNnc8CEWonyb3evNARkeGrVMCs=;
	b=ht+gOnPwQ+lWEpnN014JlrIYaXmwwIj1MJwir1Nt1e/nlPRRlP5C0j2f/6zgazx6IJswKQ
	eTxcyytQ2oC2KDMtgbYbYXqK9gKTSUV3Dz3+I+GmZGMBgMyeXaOUFKb8LySTksND930eq3
	VtFzJQNB2Jyw/aghp3ZlcR/Pmc8iHvo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Se3REjaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312614; a=rsa-sha256;
	cv=none;
	b=2CHQ+XgWP4Pvqvs3yhn6bSJ33beKm2r3WEI4w378wk55cSm6toSvlGfEkIyzDV1LlXaOuF
	n6Q9U8IoZNIakOrjwvhEUQfmQIdEAs8/7abTtpaTBdJlKaUa2iZfC59IEWJbxWoIKTMOMF
	ykt4XqrezWEOSeWfvqpje7pBByl6s9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4170760018;
	Mon,  1 Jun 2026 11:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F591F00893;
	Mon,  1 Jun 2026 11:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780312614;
	bh=OtwzM/l8y3UephO/mtNnc8CEWonyb3evNARkeGrVMCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Se3REjaweR5q16QrSE2fTtEGtglkxumlmBsNUto7ugARGSpIeLcTdnFECTgZJGi5A
	 CScWKZseeSUrnqU2m8oToEDiJ1+ZULTViTTSBhnBgsUnPuuKosIeKUixojsliB8S9M
	 MMb0GEPOeJvW93sWkXrGegmBptY2n0LjOfqYyI7/xmARljawSAiPmemLLnY8aq6x2F
	 l25YhkU6fSYGA88eAmuWBWF4weNtf2j1c57dr1Ta548XhtCcx5mp5lUZeFXAopvXBq
	 moJjS4Ub02pEBKrJhkRWvlACBErJ8R8/Ekmq05DomL8VuPMrZDT9qNXSL5NNb1Ncbi
	 4GWMqppsEeBzA==
Date: Mon, 1 Jun 2026 12:16:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm_access: simplify the security checks
Message-ID: <ah1pqCoH6guhnj8X@lucifer>
References: <ahrsfJE3NkKjShEX@redhat.com>
 <ahrvv-XGt8SiZUvW@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahrvv-XGt8SiZUvW@redhat.com>
X-Stat-Signature: qwwhzbwyiy1wce36bfb1og3p1rfqrhpc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBCFA20002
X-Rspam-User: 
X-HE-Tag: 1780312614-572904
X-HE-Meta: U2FsdGVkX189yLrWMv+Gp/d0ewwnLnVGI7j5Sa+rLMSAkAPhk9PZecuXQtHI5OCjRkFRzBwIeNYVSVgv7FCeqsZA3vrNP+aSFz8rewHSHcYnLbbqowTA94QeRRVN6LBU10tCe3IkPI5nL6fI+b/MuRCyABqqYDevMsbZGJ+OtNxqYgwXYeYCja2OaJDkOBEzpc27ff7tdH2eS/Ri/AewyS1+P+X0t2gurPkGrgc4wx72TMt8sVSuo8cWBO86h+pnaspqjQciRbli+Ec/wgSfuT7mGwGLSH0GLnw9yjBuhzOIdxe59Uz7XShNtTrbvT7e7SZ9OKUk/OfE6yTzxK+LCHsz0uvA/cc19KyYTnXwT3dawGGBG+1ySWmSM1d0FMea6sgX+9/YKHCcpIMf1ghhJsT9u4vK68yGiyutSR6r7bfdRwoozNUQVc+mkkclMyumzoJONTc/f047aPAoLlW+dmLRpPnJPufkxTVtsvgy6HgFN3JsDTFxcRPMsQdSL145ZmiQsC9kvqdypglMo+97X3WLp4Oy/9wGbdZlFbvJmzSXUqzTBQSCpeB9vuf3fnIjRoTU293TqCYL/cj6PWWB6eZ+y+Yq8RrkgygFTeWU+zJqx/pzKx/IBKNVlVxTaeohT484cP/+TQFGMKpm2yoUQdeFyAnurIcgpeNpYs3EsHFEMUdc2NNEFqlFSeA/5a2bdR9NPStzD+THexuoxY5sgisg15emNfpiqHWSIIqBZmfhXFDBkGH/euI4v9FoQ/f671i7N3XR4FAVvDl193JUQL3SOQmgpUpXr8AZyZvOikI6X9JrlcSg6CuiL+1qMaWWZc1UDnmOXFU5jydS5RjMHoWwzcoLgD5dLEamHXsZK9qjX+HKg2ieH1c/paJnBWtHeTip5Yia0ylqqlnrOSrjS+FwuVSa4gni5yLzE+yBhBVB9t+88CF3rIwJJ+MO4zsPExZza0arnvRxFnxHW23
 byXdZiPK
 eG62ra1B3B+ftVsEXtfIwSz0no9vvkoR1zvC+UG3nqe+lkRckkMYO15V4UJRSIs9TGLNapsVHVWUfQbxaB46fd//Rkr99jjEk3dyvGhEw+iOT4hzmv5XrzSHeNWYCb/PLYvIQhEsfz8E8jbEiQsKH/hvFYJAsFKrbtdkLeR9elS/Q6aJBAIu9VJRt/4ZJmaX7E/Sxm+HsYeJs7ctRDqP0ioySnyGWFrIgRR4dGjXyeyVMYlTa+fx2vUDgo8Kp0fSrEX+6jkiyXIjoVPtbhLspoESo7uMteFFq/pqKCpEue2d3AUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 04:10:07PM +0200, Oleg Nesterov wrote:
> On 05/30, Oleg Nesterov wrote:
> >
> > 2. With the change above may_access_mm() doesn't need the "mm" argument,
> >    so we do not need to call get_task_mm() beforehand, we can call it
> >    only if may_access_mm() suceeds.
> >
> > 2. With the change above, may_access_mm() doesn't need the "mm" argument,
> >    so we do not need to call get_task_mm() beforehand. We can call it
> >    only if may_access_mm() succeeds.
>
> OOPS. Somehow I wrote the same twice. Will fix the changelog and send V2
> in reply to this patch...

Sorry, pedantic side-note here but - in general in mm we prefer you don't send
new revision in-reply-to the prior one, as it makes them easier to miss! :)

>
> Oleg.
>

Cheers, Lorenzo

