Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5EFCD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C674D6B0092; Fri,  5 Jun 2026 14:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FA76B0093; Fri,  5 Jun 2026 14:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C4F6B0095; Fri,  5 Jun 2026 14:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A99536B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:08:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7583C1C11A6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:08:48 +0000 (UTC)
X-FDA: 84846644736.10.E37A075
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E202B40002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:08:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4F8rhaE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780682926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9s3sWRVpgxchzDG7N1rvybpE1WGp1wCd44hSTHObGaU=;
	b=SW7ThFLo2e5HSk6cw5VJZHEHFBPqoDYzvnVT6z2llhQmA53WPzFiN5qr0GywtRScEpTMOx
	mWVEGrXFNe+JdFhjgjqCLkNqKm3BgKgpUC+Ah1yLP5M+rF2aImXPcui9p1urmxBdOUMNF8
	AfxAtGAln44GYsnKXaencDQPTBlN6/I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m4F8rhaE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780682926;
	b=Zusdm3jv0w7N/ZA0AcAbdh65VZa4iMWMEtpbjsULUWZMUgm062qU900QkddaHMiBffUlJV
	RSflkJOOyJikZDvVXT0jVGSQBAepSiFTY4zrPHnm4q44Ay8gKaIHfSRQB/nRcTVVJGM6qC
	EgcyDmz7GI7Tw0h64p0nprO7qQdCsyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64CC9601E3;
	Fri,  5 Jun 2026 18:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF41F00893;
	Fri,  5 Jun 2026 18:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780682926;
	bh=9s3sWRVpgxchzDG7N1rvybpE1WGp1wCd44hSTHObGaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m4F8rhaEt+GK+VL7x3SnX9q2vkfvFX7ejGOsBF/4rIekkYBgP1rOzktFiKFJZnigX
	 RIV0a/pXmJJU/UWYsJX3BnonHa3WREq6pPkyxjLinD8A1jAb4yOOUKdWCe/lTsBghX
	 SYBdZEDDRER8q6UIV2kcQWkd5Ih9tVj3QkFBdzNY1t1jBPIZM4+BPMuPPNxoj0neSM
	 bZve4QQfFADDZ3UDYc9VmFqUpFDqy2z+ufwlsmUeaPqVx4I8wzQhhO2o5sTQ7HcEJW
	 Cyg9EaTRUxVBQlLY9HXHX1VsQPbIYgS9lOM8NLNTGFxdxRphEAydbSTBXYoXQiUjZP
	 98bKuTIEgcbLg==
Date: Fri, 5 Jun 2026 11:08:45 -0700
From: Kees Cook <kees@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem
 buckets allocation
Message-ID: <202606051108.380FB49@keescook>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-2-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602183122.747759-2-pfalcato@suse.de>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: j4qdpkqkkb3eg5wbjsficy76fcp6y9zg
X-Rspamd-Queue-Id: E202B40002
X-HE-Tag: 1780682926-56072
X-HE-Meta: U2FsdGVkX1/WRYBHO2CTRt9HWnDLF/EuN+oBhYTRKBIHcdQGwggE/dD1xgJiYBskQAJmtGySpinRER4hfzrlJCmULHNS+QqTIh3BnHKjEhoKM4np1R5wEsL2FBH61L3iT4++j2C+Rrs90l04DTSXU0B60JNF03T2GRbjYrNEucWNm2zAXFMjakR8yV2B1Jp2yFq4CbRPXQdh2a0Lh1wSaWH0CGrKDif0NX+q5su6U9zV45mEva0MwWMcsVtO7DlC3ml8ChxVFQ5OrpjNsf0zHsMC2Qkm34AvFH0TelRdRuMAeSVS8dpTOkD4Lb/LW9ArPfDLi9l+8tTvCtTw6nwO2CgJctf3Q7tj1Fr3eaxO92H2L+knIgZzYBodSP6lv7cL/IXok9S7KUgN+b0YdwGy0vxeZyHZFLq9wyMkgfCsu5SMtEy4QDFOXAxNBdh+7X/J9houxecKXuFPcfx9Mdks21UwmueEgSxM0FbOuehno4KCljxV/SeTmVJMdeumLu3TquOI43gXJqTNvCUYsF822GpyLZbJRDyt0/LnmXS5aH85l8ga7Nl7/DvvQL5TPQwY0+ncnL1AIfwrZ/ezOgP0Yt4E65gzXlkM1c6SdIZYMm4xRF/qX0bRghhmF63fAcGqpd2p8kglSiaRbW6eF5HluDVQHGXeQgD29Boed/B+YJc3bIx2E3Gq5QOarrZODSnCFP0Z5PFNdk7IcOr0JpD3fp3Q+cYk6marv0TtuorIUY/WXI79FARi1k97jlA/fWutTr9vBaVGMPvoUAR25oc2IG87Wsv38KKnvcuY3c1VIbzbPiRjoM6pkZnKFr7qAUw5s/+07jj076gYF1SKUhVQP/Ts5j7iDoorC9nhEtqr6CiEmpDif+4hkpDKVduNEBKYuLdCwLlKJntwRfu8gCXbqlJh0lZV9FGfROAs0b2fTHSQhHoYp9duwHctnI84F26kL/I1oQi9KrqAABjbJvr
 YryZn9mP
 X7iQE0jobFaSNBOUFxL7LAsUFcFByLDp4nywhkMaNZkbAcnuq4xeZnFjhNPOYp7wdq6M89zVBtYYtDYuqPpg2GFl08wHT0VwC+Hyl/CSt1NVS/se2R4czq0PbHgIEgJKfzauM4gBdnlxIlIcroiMmFtU6ej6vIAygGpa7iizJsCcCbMCFwZBEO7JWIxr7rTc4qCIWkeqR259F4eP8o7y6iJ8qQDZbI8KYo92FFfCt3ZjY7O+03eIsx5WzLSQXLRCoJYtTDRUvjszgjhfU+KRIZPQ1HBm56m5OHMfM+M4dQz2qGudohQ6YXS8MVuuni9Iegqcy7xOGCagbI/7e6+IbNj3Nkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:31:21PM +0100, Pedro Falcato wrote:
> This is required by users that want to use kmem buckets, but still
> desire specifying the NUMA node.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Nice!

Reviewed-by: Kees Cook <kees@kernel.org>

-Kees

-- 
Kees Cook

