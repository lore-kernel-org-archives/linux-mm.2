Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21ED1C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67116B00F3; Mon, 29 Jun 2026 09:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FB66B00FB; Mon, 29 Jun 2026 09:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D9D6B00FC; Mon, 29 Jun 2026 09:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 694996B00F3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:24:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8D67C011D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:24:54 +0000 (UTC)
X-FDA: 84933020508.06.A4BFE2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E3971C0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:24:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=McCDVAlg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782739493;
	b=w+lkvNyiOIIlfrU2wdpvwmCHqfAH8kWjc6IuGmmNQytcGjmHEqDA5IC8eqQ8AgK5PqN+97
	XMfPIt//K4JLsrhVkLi43kxVrBCxKatWEu/36lBwm/0x64ZYNWyEkdeCovo0gx18igS6Yi
	/4NJPbvqbj1I1WdzqjvXYOMP8+L7GSM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782739493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOUoznpXkigmh8oYSHGFoXWsuDrCze7tnG/NPKBj+kI=;
	b=wlSyiUPcJavA9ZIJI09hJ1uzu71LuhAcdzZnd41d63hodn+Cz+Q45lNDfKQILeozFn7fWC
	PgACHE0VInNJUSVDoWoDcoQFY+nCUDiIyxsva53CzMpXD1H6VdNgQ5MY70Lby59rzHZWgQ
	/oKdYfx4tTg/Tw48jhU69fiYRmu2GYk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=McCDVAlg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA6F26001D;
	Mon, 29 Jun 2026 13:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1DE1F000E9;
	Mon, 29 Jun 2026 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782739492;
	bh=HOUoznpXkigmh8oYSHGFoXWsuDrCze7tnG/NPKBj+kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McCDVAlgNmf7hxH7+bscDwPdkzmimscS8MZcUXGzbNACev9Cbl3/Gt9n76Loyme7F
	 F9wUCbQhG+nVhWV5Ql/rgHXwXLXV/9VyiaGG/EaWBjxU2bAxDmZpHm88v6YFe6VAf/
	 QjL4XpEKAOXjFB4TgArmSN/Ado46MJHFKNF9J1ACGdm2d3rZRAuUP5QsFx6p72psSs
	 1q+34rIl9DucWrn+soFGmXkJYH2WrlXVPo3I1DkNW/iW22L76x+NthU9H4lYFo6LpR
	 9mCsw+SAWrkLKblgk3xNkOPA40CvzUaJfSYgT6HyMpl/YV44A8zs3S24rmLzFezFGq
	 tDn4dutzhZWBQ==
From: SJ Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
Date: Mon, 29 Jun 2026 06:24:43 -0700
Message-ID: <20260629132444.159703-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <akI8_W0mnQHhXS20@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E3971C0005
X-Rspam-User: 
X-Stat-Signature: kb61xqtyfajj81y5o7qqkicx3sm7m3rt
X-HE-Tag: 1782739493-43060
X-HE-Meta: U2FsdGVkX18WzD4KjYa4g2WMPWVq+0tOwtJ2ZBejsKS5+MqZrv1TwrfG/Xu7hfshyBOQM1AHokkleUgPgMRezB1ej/snUP1ntqynm+VJSv35Zup6W6Sbhc9drTu0zkIheIpSxY0+iKgpHZca+I9IrB+51L07qY6fpojamcxZA+16DoeaY/LLggN8fD8ZZ6c2z3UuzKzcYqqvB9i7IcBLqafuFym+4Adijp4EL1qmUJECkXy5AJXeasq286B182N8jVYCYeT8buPPVc1ZqPGXjr70QxkdjLD50oMoDcRMoF5VZfB96odwHoAXfZhqYY7DoTftZoaDBbrr1GCu4vh5oNCjMZsxcBbOvtZwncdy0wGakTC29wjywXleCXVQocFst+RN0LNPqp+fc42ESnL5BkVlX/T188f025+gdTd22/WFAMNqo/LL5gb1toA1WsmzeVWTlP0ag0G4XBn9iG8YVelFkKk04VlzHvpY0PEJ4swEeUXa8LJskgzL+k+SdB3WG12A8uR641TGmEfDgX9ofw3POfAHR8CVcce0B6UER3U3cr6CXIONFgrBM9Y3S2CpB9vCS/J0jy8/8207LPT4tnbCYC6B/HLelo2ikDX/BcNMQwAVQn5CV8NtSxH9DMT6hwt+yfiuBtsun3Z64o+BPdQvo2uvyTVXnj7j8+zjseDnVaH7NW6YFvD3FIjtJobAfzm9PmwUDoavbV1NUWUkDyEwDHAxdrpOG/btDoKHikR+23DUXssDEZGiW4IRd274R+Kgda6crTBcECHrv/UHWU808abKaYTtYMZSmFu3qvHhCkQ+A3i/PTsCpSLURLXzPyKpjc/UFRxOikRrFCm7Y1q+2rf7KS7CrivdZf2svRSrl7RjNgpe9AbAv+BQ1iuqke6soIVMo8X4BsDnX0luNZUgXfSJGY7Qtq6Zk3naRTXyyUG0kqtLrnLUL73XrzMivYxSccP6lQSfRUgDhRG
 VkolvtmY
 FSmz3bzVTXRJRWxpdZToTtzUy+H3ppSlwA6hQWVToC9pYXs/YGne95u9gj0+cN/GIqEWVc1VXC/8Pe3S4XaFk25w8Ev2pVfBOJ8FLK9Nj+1i9hutBbGtg1mx9ahAw0e/jqqSpv25UYN+PjV9DW3TjIyCfeZtpHhFsBTGdVYYsKxnKxtO15EdpZq6ZdUuxuv7o1ZlaCGnmcja7wwxV1zdlWX4ApBc4oSMOBOV5VgBw0KZG87o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 10:38:31 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> On Sat, Jun 27, 2026 at 12:56:29PM -0700, SJ Park wrote:
> > My legal name and preferred first names are SeongJae and SJ,
> > respectively.  I was using the legal name for commits and tags, while
> > using the preferred name for conversations.  It sometimes confuses
> > people including myself.  Consistently use the preferred name.
> >
> > Signed-off-by: SJ Park <sj@kernel.org>
> 
> Same comment as David, but in general LGTM :) so:
> 
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>

Thank you!  I will send v2 with the clarification of the removal of copyright
notes, and your kind A-b: tag.


Thanks,
SJ

[...]

