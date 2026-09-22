Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BC3C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 22:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594D36B008C; Tue, 22 Sep 2026 18:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F866B0092; Tue, 22 Sep 2026 18:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DEF6B0093; Tue, 22 Sep 2026 18:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E39F6B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:03:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40803C04D6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:02:50 +0000 (UTC)
X-FDA: 85242773700.22.03D8C98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 858351A000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:02:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIISGB8i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790114568;
	b=bO6fEQRtURh8eVnBbnWrFd1YzaRrPUXAX17Xpnc0vRRK1vWAVeY045wxhxwaKH41FlV7cn
	bJjY4lKY3l3ZRphlHh704nqDhQ5d/pRcz6aVRH9mszgnR9iQ2BYpD3E4xeuyhz3ufKJdu5
	dS9HSMWs+J3mBZl75QpAUe7Hvw+5Nkk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIISGB8i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790114568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKK9YycH0R2EJTI18dBMlcWfaIT8ieRU+CtcZa/oVek=;
	b=Rovyf0/v+4TSQl9NOskvijvl7TNPCJV6rBMYhPNIzGVf/3FvLz57JRl62Gh84W9CNzG/yr
	9qHFljq+bNFA0p4kCwOBge10TPKCBfoKGyRCLGHEwQr1CTPGXf6Ok0/+KwYrHx02/NfEY3
	k1W19HS6b0qg0fBXa28ic3EtRUuubX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBE0B600D4;
	Tue, 22 Sep 2026 22:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EE61F000FF;
	Tue, 22 Sep 2026 22:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790114566;
	bh=wKK9YycH0R2EJTI18dBMlcWfaIT8ieRU+CtcZa/oVek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OIISGB8iLktFJHhsseBPvUeW6nvs4ef8INNlkvc2mQqbl7kCara0wbYdvk6bmc8V0
	 mo3LABnhgureG84S77c2YVqFMW94a2U+tV9rTX/ZWRchLhR0zIoAIaPG/V8ADmWwVu
	 I+aPYtR6TpAo9fHOlsPuIzchTZz2+IDh6U0bnlw+y5x9r55c0cvQNRTRv5rENKtJVk
	 zYUBIeFNJ+yacsMvFYcZ1mG3uz516vwBoPKs6eXwjhkkj2Sa4g3royDjvUDKMi1pVf
	 GFN35lrWhQzMvApU+NSmRd2R+HxPygNOQnd/fKRAoFS1WB1dJVdiQDVwsV5LWkpm4c
	 dBPL+f78hp6zw==
Date: Tue, 22 Sep 2026 12:02:45 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, akpm@linux-foundation.org
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-ID: <arL7BVjrt9Fkv7Bp@slm.duckdns.org>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: jmkt73amq8s495ruzswyn6pfkuxxypyw
X-Rspam-User: 
X-Rspamd-Queue-Id: 858351A000D
X-HE-Tag: 1790114568-222681
X-HE-Meta: U2FsdGVkX1/uKF9tYLrKcYhg9ZCTKsmCMlHgN9D6u/ug5fTufuzrqzlWlHJtJpkdra41E8llHaMadWrUJzOrkJNAjc0VO2ICWaA1RzwCQz4CFYORqmZaE063k1AMRMJKZHUCGr+i5ybCHTdKFQornSBret5zWVOVlRHEgJipApp49TuihzATuOiWtW84AfiYevZjDJct5krurMVTJuaK6qqjxK0+LBy+OXK4WL34ny4Ua1iksaIjZT5k3f/hV0JJ71m0LsTJjzPFHLYe7JEyie1bzlszv9JYUiRoOQsuvfLGeUllGSMXTI2cOCckPqT5q6CNHm7z80B2MimIqlDVcMcMgI4k+mF7iHJeBAgDheQolEfAYOhN9vWfbQ//I0jRNbXp49ta9clxiIa0Hzr27QVms8W09DIvoBXfIhBVQHnuLD48xovF2ogUpGWySFvPlGxpK+ntH4VXP/UYTzIUjLgSG/K8FOTBFI6oz88q09zfy+ZLbUXfSct7UBbnb1Qi4oRbjlPMIvCRt3/Cu1sa0qB/4l1ezV6pT1MkTHZ3xvlwT7XyMmU93IPq4fS0MbjLedTCcCQOYFSLL/rfR7OMKFIxY1LkVUj0wmDdkeRvu5hpk5n9CTonw3qznCNjfqjnFWqXicFuFu+lHQzR3oPT1o0f4eKqE255Nc75rc1ZQY6NjuRtJGCeHxdPH1mAxU4Inaft+oTJUinqU1sOV+i8h26IEz/RfQ3Tm55WUBsbMUloPntVDXHW7zip8kpdosTy/UgoIt/kdmsIUzlvjkjm06+m6aZ2Xug+TTMphe9+TbtFAjrmucWPTGn+FTB8ASkjjHNK8lVYNYbU2eloqZgjUlGuO+DFxVxX67tACW+br4EHaJELJ8VWKairZ9JtDsaOndTy8koqtriTJZzE7MWo1xkJ9HudS8JT5PaumbZheAmcYsdAOYlkyY714+icWqcOWParDoLTCWzLnDzbqUT
 EztX1lZh
 Y8F5ceR4nV9YK3Q8vp8+ehx5ouALHuzR4La8ncHgZSXCaZjguso9SVd+AAvL8CCC9EuzcoffFJOeVKFM2ukmfOeiF6QTkduV10PFtwGw2E9S1D1rtNnnQZ29Wg3L498ZXDXJz2u69qmiAAmWLO1Wk1V+2s+pCHY0LrQtmqwz73iO6PnND20r/P1zYV5NsYQJhNjPgEpEJw1rcyoYPeK1QE2cSgDaMZWlvEl/c7YQa6CLSnzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the series,

 Acked-by: Tejun Heo <tj@kernel.org>

But let's wait for Jan.

Thanks.

-- 
tejun

