Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BACC79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA9F6B008C; Wed,  9 Sep 2026 13:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B886B0092; Wed,  9 Sep 2026 13:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92896B0093; Wed,  9 Sep 2026 13:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF5D6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:29:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2098D802A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:29:58 +0000 (UTC)
X-FDA: 85194911676.02.79CD8AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BBD62000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:29:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/7puuK3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974996;
	b=6zQYaj4TqFgX1TBEMYDMYg4cnDgTpFb2tZlGHoFwh0PVOQ5z/rGjg+BV6xDob6v+NaeuN4
	2kKtbfGPGC70AnvUJpodzte3a8BnD7wehQO3rpg3yGWiJJGdFKBWZVrjgJxf8nbLI1Q3dg
	71Zsu5g/rDWvseb1PidunttNPygfGVk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/7puuK3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0w9/jZ373p7P3D897CyML/dHbeXZJ5LRmmudsSZnbA8=;
	b=JiT4TSa+1COt2TghIfwe8dJjzyKYpqzdUM4t2ZmgDj2WqEFJGXJa73w2Dxx7FMr7dl7TQZ
	a05H2czzHk8EilO3EeC12yeOJAjljqzQr5lrxxHdvkMjyv9i0/MqgyAfOmKdeq3uG3d1wE
	+PihSMrLxRxUycDw3h+bILL3nVtvpfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D9F0600CB;
	Wed,  9 Sep 2026 17:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C0A1F000FF;
	Wed,  9 Sep 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974995;
	bh=0w9/jZ373p7P3D897CyML/dHbeXZJ5LRmmudsSZnbA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/7puuK369h+/RU0Upssw7MVtmraj0x6Rj9zF4O6OgWZnlNJihorghvvebmE9Cyjd
	 ++IFKHfLwUDTfoSBpciBhMePZ4wD/JAyGV7PmX6HI9abSqFt5dEYcEDSgtGxvIE5+7
	 BBs/6zXUasvCCFpAEHb6QW41wuplou4Y684LOjzVz0+r3V3jYQ1EQd7/nDbQQS+vo7
	 ur3Dfzuu+MK25g7g/uQxaEWKYMcL9d/bKaN2gqDMFRCcN8r0F4s+hz0/nBrG9FHH1t
	 nek5fYJ5rszq0OtkMVVnrYHYqogjM7ZUr73J243o4dR70lvbj7XD4qVNqSH+G3fQI8
	 WV9HdsOf/6hQQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org,
	Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update memblock tree URLs
Date: Wed,  9 Sep 2026 20:29:40 +0300
Message-ID: <178897497730.1618256.3526476873258774957.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831102143.69265-1-rppt@kernel.org>
References: <20260831102143.69265-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7BBD62000B
X-Stat-Signature: tgptewcj1rxedah69mi7ft4oim6tqtmt
X-HE-Tag: 1788974996-281748
X-HE-Meta: U2FsdGVkX19or7C/3KcSY5QfiV6WNwGM8j93rUwjzbZOjz6dmZNnI50ri2SCreK1RQCd6mom1PWbLtzhfIkCciqemFj7mszSSKvgf6R1FLsfdjSi5GWqeSt/pRE8ujAiS7TEmBTh6lg9l+8a0Fbf/lg1/URBCafKsxAP8HDWUdUM9SCMXqpf8wrKlpIwCbizGg+kFasaLKpvCls3mcLUazTOVePIIK/j+UCzJiEM13rzcQMow0mDkqYjZQ6xgZ5KNVkhc3qioVH0ZWBDCFD/OwAgVEUK3LZ3QWp1IgX9bN3mcSDJJUyvHep2ik+YjINPIiBN4gMmHbhCj/bmM3ohgBaQzerCTtbJzJVe1+m6Op1uz16bo2L+MDIzObuvQquBIjfsKcdeGV8JLA7xuMonG1FXRP2zY8/ERqE2qNBC3VwCn6owJIJkCliu7fNbM36hcMNaMI9u6pMHKCPmunmCsRvTc6NIODV7QgZv/64MvBavl9Ogj+CZhJuB6zqM1GzdSUVEBiNwOZbDg9PZfk3tahZMftDoDRhzFKEuAodxCv3Jo+MczfxKw8Uul/GdopWvcBlMJ9Crn1nrPR0P4YlHJLmKpskB2k9slDYempeE/k/yWY59b22lgAO72cgElM3bHvCvd3VngBS7xweFQaExjJNkSbGtEO5xb+U/HigHE3rQBD6CitqNlr5tyXAnjkBiI/UzyzKHEl73G+/dTBFMx1SRJdH94t8b2woK7TNXawWGUQJtA7IhZeaze3Fz4ix6dA5H2vOmuwPsXi0Uwjhzp3q9cktUu2T+cMBw+MWVMg6sx2MHyvfdSGNtOZF+3XLP9bRSjdQ8VaPY2M3HzeJLxW/PqFqEql5tw0on49yhjJQbwUQ2tkBwDSpkHxIEcozr9ZnSR7PWGY0+zDYgxGzN9+2xAJvs3iP9BQjwb6iMdSrQZ7yQrvqdAVEuUfn9hirlfiedFriB93lVxfwvk6q
 ne8zdQiI
 2e5tUPtji6CniHjfy9z9ADZg5MWzobIQqFGb4ZhI5OB4e6nl8J1VjjnIMezVHzlSsgEiJKSbVl1HBYHw5TtLZPY1ywYZEmyn6iNeFVXi8ZmhGRCyB1dF5yB6kXM1tFKasiYJ2ZmqpSYhfDNXj8iBwftZy6tf9RkTnrjWs3ZbKw/YU5D73SFDcM0/hyq4jTPBMGN0OO6hK/3qYFxBMXxvtVJhGLv/KNDmtTho5xVstfUjdtmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Mon, 31 Aug 2026 13:21:43 +0300, Mike Rapoport wrote:
> memblock tree moved into mm/ namespace at git.kernel.org.
> 
> Update the T: entries for memblock to match it.

Applied to fixes branch of memblock.git tree, thanks!

[1/1] MAINTAINERS: update memblock tree URLs
      commit: 6e33dc90df108c76899dc544a42d17adcba61668

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.


