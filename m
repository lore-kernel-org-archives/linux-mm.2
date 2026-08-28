Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9B3C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 02:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5726B008C; Thu, 27 Aug 2026 22:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B560C6B0092; Thu, 27 Aug 2026 22:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48BC6B0098; Thu, 27 Aug 2026 22:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8379A6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:04:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F35B5A024C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:04:58 +0000 (UTC)
X-FDA: 85149035076.25.BF8E95C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7158F40003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:04:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ey/AGnc1";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPYhDntKUbKFR0MvZcrkWVZ13EiO9Mm3bt/51nZroU4=;
	b=SKv9u9xXSyIp8VlVaC5hflv2SKn6nMWIHVJDpEo8r5p/aKzVLiSVbIWlBjvMwQeC41FCO0
	XCoendvBBEyUNVKVlsSgQPz9VoTyv2c+qu/MrT+0q0fRjnnxpoD+TwusxLSEdEUtoUa3U/
	505MI9ppSK1lj7/z77UZ5Bn2X8UGXtk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ey/AGnc1";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882697;
	b=2dbYcmQKdTp/4nfA8UYaMO2ZsYvYMkln+NsrsGTacmCq2AkEzYQOPMZLA4dDr3/biCj6ld
	3xdzxzNGUkvhy7PoR9HywZHHTGcLUYESWubNVGVF84q+pgs50Yf0QT4CijBttuNG00a0n1
	7cOLbz5ggY9r+ariJAubl/a7KkTevfU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2F0B601F5;
	Fri, 28 Aug 2026 02:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165661F000E9;
	Fri, 28 Aug 2026 02:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787882696;
	bh=kPYhDntKUbKFR0MvZcrkWVZ13EiO9Mm3bt/51nZroU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey/AGnc12E9eD9yjRs1EZ//iBMKvApH6ALON+TU8st804Gc/VD1RfJZMQVrPV1wmh
	 VK7Al6DXUGG6aLRCgsCPCR348LeP4oxbOjhhT/xtuBihtEItwnGqFKol4nCx0A5FcY
	 KvdtcKiOTHQpwFi2X/NS/4k6kxu0gPQ9pnZTJ7XtSFGxqng/CzmSf9nQFYiVoi5BNG
	 rHO0RBQmN9xVVp910pIoNnVUlFuQR47bL+L5gafdYycr1tluxMEg49hz8lSAnSFuU1
	 eZBHVb29n+eQY43Up8W5ZxA6+YGCqQO08rRvFpg7LoZ/qPvo89PfeZk935ob99/HnH
	 XwtoOUI21OIfA==
From: SJ Park <sj@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused anon_vma_trylock_write()
Date: Thu, 27 Aug 2026 19:04:48 -0700
Message-ID: <20260828020448.121914-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827071845.17636-1-hao.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7xyzcmdhnrz7mrnu376cj5nxpfr7wgh3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7158F40003
X-Rspam-User: 
X-HE-Tag: 1787882697-508593
X-HE-Meta: U2FsdGVkX1+N+tZcMITN/VzSvqORa3/okd9GoE/m+aKv/PIOXRDR2T6y2yo7yPfPP0hsYIfYD47QRFa0jrrblNX3TI8JFfudA7uz9S0ubi+yW+LLcgeMHfO3uq2OiUC/1nH6Z+xzRcYF/IMzySMgoYAI2s8kiiiEyehcNmVNG/Hk4XA1iVnBzaMnxgzq8sNazihRSogmvFSXdud10ZykqyjfN9XmoHUjDL6jh5JN4Xgk9ArAp3hb5t/PFYIqx7DRCMbalwHLTJz/cFK12ZYDEStVAH2vN/r+XT/X/lIkrBVnl5huFRmtw1iuz/rS7w6hdQRDxpW+ZWoB9ZAtLK4f5jBIYnqK9ujtfOIeU4BIsH1mhfa9xoZM41xjYYUN59HooATUMZV2S4XsRMFfpXGYC46shnirwd8uBMsF9LNNbGQIdrr8N+vcnAt9I8MUCtxPEMXUfy2qQ6DsYIJS5pG4Rj0kJRge2f5q9N6xZVWWYMGNoLlNBMKoohGTLI49kJJIx6nT3fV5Ki+N2jmGGD9U+05dBt47YhCeShuHt/WhVGyQF45TBt1Sb6hEDrymEVuzG3beJi6jAcu7S7vedvWQW+70GRWXBDwxgnTk4CgLLJmIkEcn4df4tljyUrFe11UB2Q1nJ/Yu54Lhm89a7deXF0qDCCjFY95orvqxUVP20PeFxThWpn7Rtm1GuapzrQY+3gG4dPRrO11/oSwuY60hajyvaRZtbLubGIxKLIZ1CweeuBdvud3fbStkH1sSnCoivo9Org169UYlank+a0Sq5VI02NVBX9NABa3krh8KOsDdGOpvDKw0zqUFaRAMT4CEK5Su8YlcB6L/jk3tHKFbDUn6VdhdND4oqXkBDbphmFYKtRFJEsNiVTqNDD+dlfO3Axj8GjCMwqCnCm/pkQp10W58TmNYuoJzEx5+JzKQeJYQCjZ/g4Ii+AWBLXiSraywxbbYrU0mWGo1EdjwpWd
 g19jJCAs
 9A7lr4wJ391HjZ1O9QzZaYUn56/yh+kIQRl2buDtiT0XKN5coONlfQqCKzE9URPP30/Pe+UlTS9sguP4S1D9aeFXU2RQZEyGuF/fyVzIkLCu5L1cywsh5ZtKczlIEOCaW3Tkqlvt2Y/x0tOrBbg0/vRfH8QvvxqItWevf/EAihkp+CR0dpxyNywD5h7EdCrR0DRxvbiudZoOtO8A03nY7rI8A2XWLNRo4r4fnCYnXJ3EGMWswSPaG9j2WkpnofODkx2oPMA8ToZo0ODFgs1M52m1SS2OWk9fPhdP5nC8hPoDSarSYZx5v0hfpAiKTyYrh5qcRtP6vKS1o7yiPmlgSZFOPqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026 15:18:06 +0800 Hao Li <hao.li@linux.dev> wrote:

> The last user of anon_vma_trylock_write() was removed by cc22b9978509,
> leaving the helper unused. Remove it.

Nice catch.

> 
> Signed-off-by: Hao Li <hao.li@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

