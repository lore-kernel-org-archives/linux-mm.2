Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88C9C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E0E6B008A; Wed,  2 Sep 2026 07:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945676B00DF; Wed,  2 Sep 2026 07:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E566B00E0; Wed,  2 Sep 2026 07:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 646296B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:20:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED097401B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:20:39 +0000 (UTC)
X-FDA: 85168579398.02.9401E76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6619940009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:20:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJgXu2Ho;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788348038;
	b=c6K+5e1uURxB330vnZo3hNXAqxz/8qBaJZRxfVYSnwoYKYwXRgb/krhzc/4BFj/XWESCOq
	QTJU3oA+4XXHxAecN3t6EAMKocF9ukzQMnmmGJjVQmIxyAAWumhb1C0XgkAj2ANPNN/jln
	ckFKGv4gQtRse6OXa95zlEVR0Nde7FI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJgXu2Ho;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788348038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82FLjh6BDEVMGyknI2qYmuGqw/QE2Q068e9cGeuIo7s=;
	b=qboizo7IoIMimlyL62aIR0UJts8tQRlTWJcUaSCNvMHu7aTrVfTGP/zdA9tZwPExReBuhZ
	f5EfQ+qpVTvQCWgwAQYtyNFcS912QwFRtEN/NtZqCVrWGvtQLkaWqUN9/EEWFC441BTpZm
	gfdHh43XhjzUNPzmWzlpCem4ARx8dBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AB07600C8;
	Wed,  2 Sep 2026 11:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4891F000E9;
	Wed,  2 Sep 2026 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788348037;
	bh=82FLjh6BDEVMGyknI2qYmuGqw/QE2Q068e9cGeuIo7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJgXu2Ho/dR5c+G7h51oEvlRzDxrZF5ByTgGh/dDpVmmKiOk4LrB13Xqis3iLy49K
	 cPzv7ylcmwZrXXE2Fa5KeJnLUOkzR9VXz7a4wCy+9mRy/clbFd9EgSC+PYHq++dpiN
	 h+gIbRjo6HtvEPKo7g9Q5yQuK5tS2IuDAqQyduuRbkFgU+RWUDoRdFIbSCv62zq6+K
	 b+TJcjJHuyHkZYn04mvQNh79msbGxY44+HGwvHnWd3Y2G2dhrBCMumQrjydoIO7nA4
	 pLohWJuweJJH8VVvNGH7XP8N2L7YKZbWR8UHhWFvbOYf5wgrFFJ92B5K149QNVn0ky
	 zgE32UZTIR7Ug==
Date: Wed, 2 Sep 2026 12:20:34 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apgE4TWLFGoqoOos@nixos>
References: <apPa-cGLcyt90l-E@v4bel>
 <apQU8wjMlvbKBQgh@dev>
 <apQ7osHcRj3vdJPn@fedora>
 <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6619940009
X-Stat-Signature: cq7z584oncjfmi3fwgnjwhd351ky1rr3
X-HE-Tag: 1788348038-456075
X-HE-Meta: U2FsdGVkX1+5gsw/dE60p6IzUDjsgJ/PQdVqpLs4TJbkQcqpLLi9TRzH3Trcn3h31i86QyMsVbUZBCL9UyNnvNx+ZkO/nCrsnf02spRFH5ZvA2e9XY4DdzILj5rM/ZH7Mom4gmheoT/sDbroyrPRTSE30boZMFxI9NE8Qgl3HSJoU14WV2LQ/6cALA5zIJzexlUOfQ6HPlDSdVLqLf5vZK4C85tS7qlq0wgYt/zSprBF+fkA7sNc4MFy9sHDzY85QBpXB0Z+CU4Yl+UQKmdCDQB46Y7d2TDvqlYpLITe0zqPJy+Sx2JdTc6aNwmboBU+POVXJUY+1fvhSce4yEKh2cQrb3s3CwPdL5baF3w6CzW08gGWyqwgh59oV8EpH1irGnt8fymMJgQmnS+Vn/zPCbkkUfcmJuA3DB321YtOC9gg/OsK7RfY0JhFUt+/jWTRz7oYREIExsw+oDFCPC+hmn+ks+PCihy53B7FuS52gWkW7vJPDWMISqUNIMhR5yEDBUeKBA0SmnYIAAcCUl8YOl8A5WNiNdXdzSSP08l7FugASzrLk5Fcliq0ll8dqJlHcJf/QqWfH7jv+/FMTo+fvWLLncYsWmzAyAha+n5wXTHsX329eKBsjdvojdVp09TsOh6B0CGUFh+arjNiqgNXnhdD0NgLNDP3u6V/dU89mjA0agoaSsl6IG0XierNWgXE3VSt5/xWcRrvXfBEZEKuVzNBBrrgXyL4cgkhV6q65eCtIApK8tBm3RxqOHiac7dSsQ13b7QAwHIVaBDKawkQjqrh24I9XCEgk/EttdoNVc8/yLU2ZkTS+xdckzGWGj3P15eyPVtxZt7FQq3u4voiAAqD77aNPp6G6crrZYgCKbgGvssgiGAxdJKt0MSBlNwPGp1mcRgTYn9Yxz6U5Iq4XWfd1UfBqK4ZxEkR/JmfOtVlD4P2TxOoT6XZ+YepeTA1V9JrqN/x/p5EDptExEy
 scb4EYSQ
 kziApEKHcWZpAJqPTTuNkYUvuyy8VVJJVFh4T9P3Uh0tElSUdHMuXJIn3U3hg1cVJ+CcaoUCf1Ajy1zemK7HbAS/Adlnbs7jqLEJPh9gW+Y8SyUxcscxIEHjfXd7Jmcd1HKN+Tr9xHUomK6epLHz9Pltv/9nWId1qRfeNHA2aLeUgrjdmMIlYlRzLU91A9OmHrGgNG9TwzuZ4rVrpBfVILj8Eq7aMQKgBD1RgKd0jtiufVAR6YhtA1KTJe8UOF4yZ6V42ejzsZyqHHCNLg1NYJgF+e9T7PQiCSrWHFGEADXit5PQb/htm6zsimPXCQhdk6ES7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 02:55:06PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/30/26 16:35, Hao Li wrote:
> > On Sun, Aug 30, 2026 at 12:45:17PM +0000, Harry Yoo wrote:
> >> On Sun, Aug 30, 2026 at 04:25:45PM +0900, Hyunwoo Kim wrote:
> > Since introducing a new variable seems unavoidable, what if we temporarily
> > stash this slab in a pointer like below, and then add it to pc.slabs once we
> > acquire the lock.
> > 
> > struct slab *leftover_slab = NULL;
> > 
> > ...
> > ...
> > 	if (__slab_try_return_freelist(s, slab, head, count)) {
> > 		leftover_slab = slab;
> > 		break;
> > 	}
> > 
> > ...
> > ...
> > if (!list_empty(&pc.slabs)) {
> > 	spin_lock_irqsave(&n->list_lock, flags);
> > 
> > 	if (leftover_slab)
> > 		list_add(&leftover_slab->slab_list, &pc.slabs);
> > 	...
> > 	...
> > }
> > 
> > PS: If I recall correctly, Vlastimil's initial patch was actually fine. It was
> > my suggestion to save an extra lock/unlock pair that accidentally led to this
> > trap...
> 
> Ah, thanks for the reminder. This [1] was the original attempt.
> 
> [1]
> https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org/
> 
> I wonder if the fix should be to return to that approach and just have
> __slab_try_return_freelist() handle the list_lock. The code would be simpler
> with not "bool locked".
> 
> It should be really very rare that we would end up returning a partial list
> and also have additional slabs to return on pc.slabs? So I think there would
> be no noticeable performance downside to the simpler code potentially ending
> up taking the list_lock twice instead of once.

Agreed that it should be rare and not worth the complexity unless
we have data to support that.

Hyunwoo, would you please adjust the feedback and post v2?

-- 
Cheers,
Harry / Hyeonggon

