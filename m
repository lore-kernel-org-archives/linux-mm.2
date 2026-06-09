Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B44BCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1E66B009B; Tue,  9 Jun 2026 14:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9722A6B009D; Tue,  9 Jun 2026 14:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887996B009E; Tue,  9 Jun 2026 14:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA9F6B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:44:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D638164FCA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:44:00 +0000 (UTC)
X-FDA: 84861248640.07.E7C68A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 612994000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:43:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdZRuRX7;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDdhMXu9kTVIt3wruTdJooHHQbl6lrTqQlfRXfiUst8=;
	b=cPtU7gtrqu165d4pAx3Xs7QelFL9RXFKTGSYgfqh2w4GABZjGQ2v74pkU+tt2JeRxswjJb
	jUhllt2OlOsFOpAzlpXkp7NwVqxjKH7/uQ6+6JfL2ojcREi44cT3Mpg9Vs4LA1sdM+h/dG
	o76FbIiwdVyvVRXLY0CLnXqrXy0qmaE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hdZRuRX7;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030638;
	b=5rztkL72pO114gJcshNm6QYtNNYlYmeaPbXDzOkxVpwzx6uJtfP/4WbW4/vOmRWaKAZbeI
	BOktLklenTjcGah1bopV4zUixghqhE5D9KrrVjNcjuG/lweAY3BHGb8pvjSq8JZiXbMBqL
	O5rJCFc2BK7hatijA/csGixdpKpTVp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8E7F602C5;
	Tue,  9 Jun 2026 18:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A84B1F00893;
	Tue,  9 Jun 2026 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781030637;
	bh=UDdhMXu9kTVIt3wruTdJooHHQbl6lrTqQlfRXfiUst8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hdZRuRX7DVwIWySSLtdp6y2vC5NLSzZuGYW1Uuc5vdvfxgj4MHQ1XGKPIixDOxvcY
	 L7WZ0ZvHDk8eEnT2U5QcZTntgqutkmJSwZcX7uS7iI2+Q+3rHg7QGyjN5h7B/MLP/r
	 ukL/MafBughuUa5kZOZqrV3QdmKH5QaTG0HUvleOZIXoP+URZgOZZ0bby9cbsez0dN
	 7R0EwPRa1SR2BnXm+symIHhaP53ayU0ccWRprQYy/kzbgP8nAfVINU33XnYC475aX2
	 W+L0CTWE/EF7PxET5xg1rout6m4fQgp2rQPQcQHY0e4MMDGnm+cRCdD21H/R/QWSqH
	 Hn6kDpfiPomiQ==
Message-ID: <508cad64-3b00-4a2c-812b-fee69f2d5f27@kernel.org>
Date: Tue, 9 Jun 2026 20:43:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm: Remove __folio_index
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-7-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608210618.3437216-7-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 612994000A
X-Stat-Signature: zf6bn8ehn56ihqgfguxcbktryafk38hg
X-Rspam-User: 
X-HE-Tag: 1781030638-326872
X-HE-Meta: U2FsdGVkX18yRgwtEYfOc+ixm9QPhMGyb1dqVcJcJ8/HEHiVsjFuB5O5yskf4bgl3fpV9W94rKfUxhv1JJ/OsI6vbBkLDRFCva1qX/SQzp7/8dZgDTrCemkrSocJ8r4OCUD5USHA3uiYdNgEW6vXoF90FUCNA+Ce/y8gzJwWXt/w3diiU7AZpIBKVlpCgikQtsQT0d+iKPacX6MYsDHi589TT9K5CCgw2NRayP6Pt6B/4mK1zZzRdlPxJL9emqEDpRFrZMqfbnw/EQ6mvSCON5DHzoSa8SpjiIn9ScKnYs3617o7XHdDgKH1M4V0t1T7eybHk6vYr1QYqRRviJXTT+FnnQqV0pdU4JcJ31klUgIyDhOXnTAvu8z4GUF5070/0DlZHYpqUr4uqJQt5ekiVGriRYCUqQjBARgJL27IhmDOev1/ceOutHYI/otBySqSBvxZW8EiqPPPEJ/9+cF0M+1Mviy0i9G+A3s6ta/vImOTVIuFAI7N5yM5DEk7qut3Vo70RV0bHiGEoEWwy3KELVTOna+UMMRh7PHpnyk4mUATsHRux2L+R/6+82ZaWIGu0PS5EsSIsgA83MKc/tW2ChJpma1pqS1GnrOQsqa5/D+vdOuoAD9jntNVpJ4tYk+akuWvvyRccqmUbP20lgYXiZRZJb4aGcgaGkiO3wZeGTGTEOhP574OPcdDdTQzCqiMluXnCU/j3oTPPDIL8ObgA2UTEl3kl+x1chYwGtbm8VUkE9vPueovxwv5OOSU7lx3IUDvZbPS7C+HoyVlNxs3qn/8K9GO11WlMPWWycMHSDV/TGEjgcq0qtMEJCuBPb4O301dhfLHgx+H5mdp+BIvju5KIRir9DqEnhCqpPfSjp3CQcyMEvHzGU9J4EyE1qzZneuW5KTo/w6QFXVeN4+prXkr+RsnajKu/Q3cr6eDjYRCQaiF4Gm4+h1NUrnf5eH+iGL1bDHZa7W7csQpccg
 ghvm+Dt9
 X2jT41lLdWSbuAfBWg9Z1EkZR6PG0rqHVxSOBRspxNvRI6b7L5Bd3EloBcbtdo5R9jVVE70sCo8KtolhKJjQbBU7SLllci0EGI3drmkT8/X2lsWbwlp8YqzJFoZKnaNTq34ePA0nmabt2cUSlOSsLDYV4dWEIPloadqqbePelX4sbpQ+kGx1Ci4DPXYh1zmD8MYEIAPGGcX93DC/e8qBmNK1ahvXsouwwJ1m5X292y5icGxtq6hMMcY0xfnRhWrWVUm+OBZlmIsM8L+uc33zJVfaNeiv9V+FAuLjTlKaRkRVIZYd/kedzxAoRrAmBHC3wlEVg/tUJvA3p4syHUnRo7NXC94F7DAV2DB7B1kGNBP10uy1RQl1p8z2M5wCT/05bYnqAh0IpowYVPoxGsn3LiHY5XVbyFu2g0ocn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 23:06, Matthew Wilcox (Oracle) wrote:
> People have been abusing the existence of __folio_index.  Since that
> was too subtle for them, unname it entirely.  Now we can't use it in the
> FOLIO_MATCH, TABLE_MATCH and ZPDESC_MATCH macros, but that's OK, since
> we don't care whether these fields alias index or some other field.
> Also remove page->share since all users have been converted to use
> folio->share and I'm absolutely certain somebody will start to access
> folio->index through page->share if it's not removed.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

