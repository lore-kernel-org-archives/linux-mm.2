Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620E1CFD36B
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA0B6B0093; Mon, 24 Nov 2025 20:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A926B0095; Mon, 24 Nov 2025 20:11:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49516B0096; Mon, 24 Nov 2025 20:11:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937586B0093
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:11:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DCD8B954A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:11:09 +0000 (UTC)
X-FDA: 84147350658.27.BA0EE04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88C6220006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:11:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z2yl4AG+;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764033067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q/Q1rpTtBI2X6LU/rLqHqgoLAqAd5mU5xAALzVAHcI=;
	b=podjYR3x6cNsqdfUKyocDIIMS3JNiJDjFfurJoks0L2jsU92Yzj5YGVuCDlitUotr8nfGG
	Cv6iw75bjT9UbC7xCm187q6U546+tPEoNyNRaAYrY8l9zPeNaq99jz/P957313y15pJilO
	ppwtcxsx8S7E+8IN9/D77t6ZB+qqhmg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z2yl4AG+;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764033067; a=rsa-sha256;
	cv=none;
	b=eJj4DVUrXoaLG07BKd1MxafrEKrtQM04Ih6oZ3eD52jeo1vCu1X7brRBlnQEcfMmxoghdK
	uhUhkonq5P8P/e6AunDs3T8V3aLV5iryGWlb7k9w9bUZ0hrEJDKbHMACzR5pgws/gmo1FH
	w3JSDyxF8AKZWDEQhbbVHT0UsGQEBR8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF92560187;
	Tue, 25 Nov 2025 01:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E91C4CEF1;
	Tue, 25 Nov 2025 01:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764033066;
	bh=nf94rCquJc8QNeFgFlkRJuDarMYsAcZXnLtUPJTYgJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2yl4AG+DDuiNKAIq00L1ydlT+ob+tHWu6IoW8eaCQNKBU446v5PU5RoTdVkL7pK7
	 BCsXha16oPM4GNQghIHtRxWSYIPW+rCKuVWArSy1vJLUCq15l7JaeG63krPAp19JU8
	 A1ukokpCAVnGgGymDNhBIgDBUz1vb0wkH64MXvTp4R3gFwpJOHewtjyh+qhIcX3zEf
	 3QbhoUH+5uk9ADUrqlOh7kADfeoDvYK+Ve+9OSoVh8mq8HCmz5HYUAx5Ny8SLADEox
	 FU87babFFzF9nLmkQ+1Zik1QI2vjMDN6CrHQOk3Tza0sNj/qPwvcSr8Oxp2NRKPJSO
	 TMnjxC/5R6Nlg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Mike Rapoport <rppt@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/mm_init: Introduce a boot parameter for check_pages
Date: Mon, 24 Nov 2025 17:10:57 -0800
Message-ID: <20251125011058.74734-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88C6220006
X-Stat-Signature: ae58dkxgqqc8xcb71mqia3g9idb7ije5
X-Rspam-User: 
X-HE-Tag: 1764033067-196141
X-HE-Meta: U2FsdGVkX1/TgMouWvoEVOwhhF+aX3L/ZQjCUKxCXyINZxppq5yPEabYB81yZJgR6pfl4GTJ3D7Wy1ksEDeHdo69scsWLhV6tGBw0V1YDrzctowS8cyMa/doMZMnGs8cQylYrzW1iqHuEbX5Mn/kI0Igqg7bEhKGNUpJUyWHTp2EDLZgKdMqhAG65L1fFwFozXNG9e93XkrZhXy7PB1VWKOh5TuwxaAK3OZk8R/eh2RF3k8HUVK6bJfkVyIISwdfxNj13A1laaAo7vjx8hSD724b4SbzB19vqlw9htC/F8TtqAgxtH6O92Y6Xi2Qm5fkKgQTOdVvDp9NCuxF4sSu08kKt6+t4e1jSifxwxjp6psUzZyUh2WkDYcMLlcPmpNvNXwU/Gc7Q8nW+Zv6NLEW35ZA4lfaP2D8b2iBw9JJ+eO/Njj6v171Os7FWDV9GteLj8ujbBS1JCxZDlcSkF6l07BmHfT8KzyMhYfbniefHuf83PKgPRKOcw3S0uayM6Oj5baKPnmiXlen1HUUT0Rhg69zHlPCTog1ok+vJhj0AxFlm62lcY9eOwl+/XcVoSreRtbYvcLLo/E/aoKAR2FjGoG5oqCjAEAT7S/4JfNleSLiHjEXDILswrvFPwZal+CdiM1RDrkS81THDQv4jpymfBdbdTr+uPpzdlMsyrBWgHeJyY2rkrRQcO7LlG6kBkKjW1o3mRwm63o7O1TLFEnuy0eGnMJBe1B0K5xkN0MV6h4srlaQ1xfJNFT5HBb3OztDD3pclVntMwHdLCQvv0o++bg3WDiffyjeDb/IYBL82O6fNPSojoSPOBHONfzgaqn7myiIOUUjZ/vGXUeaSgGvPvCFMCJwZzDKykI0UnM9/3AaruIFd7bcNBu3K+n4NtF3FUF/Y3bDibzVS6tyAnGCv0PpNQFv479Dkl6WodGE5MaZwqjZl5uMULWYZmZBZd+hpEf/Mih1qdQkx8j+5+k
 If1c3tyi
 gO0QWR4vvtqz/IKpYcklO33I4kGfq9Qc5OTG30aG4aMndpvEnSwNe6cyce4Ujvur89ExQnpnRu3+um8pWO2jQ3+vy64dU7sCsDDcaGj7TgQAutAIIrXJlqJmYf0heE1XHL0dkNFePFFgsjYBZs7SoYe3Z5TYEuN53pbNNSw5Ygje1l0gveXiJB5mRoiGzdJjd0PvtDT3oZRdQOFY9bE+NLEqMr9bmFpvkefjpJePJZdtAOjGuum68NtH7es//BqiZ1SBo3QY2R8KIcBavbL/V2R1AFnDywlC+4g5n55pwdfYToXuOShDGZHqx3dAcOg2pnMoQvKAudbyDs7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 14:54:06 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitive production environments.
> 
> Introduce a new boot parameter "check_pages", which enables page checking
> with no other side effects. It takes kstrbool-able inputs as an argument
> (i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
> setting CONFIG_DEBUG_VM still enables page checking.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

