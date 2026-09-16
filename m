Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 187E7C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6336B0095; Wed, 16 Sep 2026 09:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD9D6B009F; Wed, 16 Sep 2026 09:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4F66B00A0; Wed, 16 Sep 2026 09:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED9696B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:03:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CB80140726
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:03:37 +0000 (UTC)
X-FDA: 85219642074.07.A11F11D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EB5C91C0010
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:03:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxyNB81U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563816;
	b=Arzc/3nDztDL7Q+zAoMRX+p3d9v1f1MEpVOEFJITKEKWoBJnGtehNf+lfVJqNYugJ+6SLW
	y/4uyquF0qr6vHKZ2fczRPTyhmlOSoE7/XCM1KGedrBFYbuzbhg/TZ6WPXV1Yu3tzT0aPG
	vbgNe3zGtTe/IvDR0vbNfbus9sWyXX4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxyNB81U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiPclxV1NiqDsfmVc5H/wnm3CGtWHcyg2RThJ/0Z7Ac=;
	b=3JV7f+DIKY1m+EhpOPiKrKIeWg8nU0XSC1EpFIuy3cwNii3Imd6HFY0EAtOP+l++zLZXD6
	hYqoX50nXlo9SLVjJgorpIxUcYy5GBS5eaGLR2LpEJCTN+h1O0Fe/WbMbo/DOMUpP3zK69
	dGxzP5NUxPwOUCSM/ACltDZjjqu264Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2343643784;
	Wed, 16 Sep 2026 13:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDF81F000FF;
	Wed, 16 Sep 2026 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789563815;
	bh=uiPclxV1NiqDsfmVc5H/wnm3CGtWHcyg2RThJ/0Z7Ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NxyNB81U8f6PAWeUwwzdOtXaPmfXw7FN3QcqQjIIsCcH5VI5wVZu0Ri+B0XMGGqpJ
	 sOXEJzTx0wNrc+VdxL3vKDs1JhUbhxK4wJuuvfYYtqSK8osdipx93Lqyd50Pky+nvC
	 UZrtQ+Niv5k6gGiLF7ncwKcd+kzEUPC1tec3Mz7daR+93cf1lp3WVCpsi31K6y0lIq
	 SSOVvte+SXrOBSFM5dpv9604d1hwa2RLdt6tBQCVXUG900N+sQVVK9vlB+W7DPcK65
	 vUgSD7hSlWBD8L3frOT8VdZ7lOAwwFziaota7Gqui/gjq0EwTIpm5sqrKNeOzSN3Vq
	 la0AaQFHvyjJQ==
Date: Wed, 16 Sep 2026 14:03:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqTbGMJL86TzDrf@gremlin>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB5C91C0010
X-Stat-Signature: frpoy3teuj7mmprjgbycshbq9pubpipi
X-HE-Tag: 1789563815-847988
X-HE-Meta: U2FsdGVkX1+ILs0uqDh80vCqWvhn9tDMRrPSh5OgacNvCX3bvQSMVAT1zmEoHm8TeDm8eh7BLR5+I6Ot90siWdK70TcHJF1e7gCH3AN/twd9wz2T16cI1g9VoKiZlNbDXSbsa452KyVq9yoOc9mpD0z0Glv/0zrJcM5LbVxtjEROk5LtcgiZ8ZDiH8MAmXjZPym1Gzdo4yefmgxtoungDHe6F8DMwfmo5JFMsq4Yhkl1GSBYaaRACTmQeToBh/8rdlWli5eQPvlF7AxqNSV1mxE3x+GikTnF+TnFWo5TOT3RojaSA658I6hCFI6Cw7axczRnpgAuLGMvSuPHA16DOzrwHVT/S/jzWJE6no5Rmo7TKvW36KcaDXo+VQDZKmZopyEJeddENST+kEZ8lwd0FzA83LrRIl5HJZERD4Pck/Ph1qcY9/N9pB1a66D42bcpG7DNYYcZBz5nI9ErLoUCILF2jiqFE4lteRNJSlZggDvJuZUw6zC8xJnGnlQfAsq/JqX23zFiuw3lY3OYeUjoPHb/+KcYiXs3biQmYCcX+oi5ahmSMPcQ6IXj4M8kbn6k/XOP2werx7vJnpubMZTKzxrV3fj380tt0sdKPnMBH5as5nht/Gx5Tn23Y8ViKCk/S44t3zm4FjjDDlHHEbKSL50vqFF9Wn6UPHUqO7Oq/MTB5D/lfVvN8IytvCpr1LzS+IV0e8p6sAqJ0naMYsNsfhPb6x3ktIcxuZ2yYq2Tj21t73x3xAa4dZU36MjzeynfqCqD0krQDSr4DS2NIC1x4lZ6/J+teB/RTMI1u8D156KpNhFd7DQc0F2OACkmfga5IecrLH5FG3akViOR3CpTPcQkwRj9zXGXQeyZfvAagsc8J9A67yp42ucvcOb/LFJLqIjCuO259uwN6opjmuhvZir/yvp4SkJeOVegiBQ9vU96qPYh/a6U8KuPsWjmZWze7t0NjAsM6yh9SxbnanW
 gkxb9ozE
 tW0mkZHxdoXgqtGeVF59/CzaCQRGLKfXzJRoO54cpxBb6r2KXjHwnRJU18eh8NTxY11lfi4qKiuuiAhmHrmHmJzkIJWtBaARaMBLVzf0zeo0QHwklJvsjOaVnIOn6H6bvBs+eLSFo2NWz7ShRkie3PwyI8CuTdAKyW4LWlePmBZM0h1kVMPjLATBFjkp+6R0oGJsEo9TGLpCJ8Qq4p1Xv+NSFSCKZzDKra4IkrTj/rO1hs23znnIu4ja3viNvrnXTbXf5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 01:12:03PM -0400, Gregory Price wrote:
> On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 12, 2026 at 07:08:32AM -0400, Gregory Price wrote:
> > > MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> > > them after the PTE walk.  The reschedule path drops the PTE lock and then
> > > restarts the mapping with pte_offset_map_lock().
> >
> > Is this reschedule path even necessary? It's pretty bloody sketchy.
> >
> > I thought the modern approach (TM) was to not do cond_resched() and friends so
> > can we actually look at removing this?
> >
>
> Sorry - meant to reply to this.
>
> Honestly there's so much jammed into this function i can't give you a
> straight answer. I can take a short detour to figure out if we can
> rework this as a whole.

s/short detour/long journey through hell/ perhaps? :P ;)

>
> ~Gregory

--
Cheers, Lorenzo

