Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB9DCA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58516B0088; Wed, 30 Sep 2026 08:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1B46B008A; Wed, 30 Sep 2026 08:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1096B0096; Wed, 30 Sep 2026 08:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAD86B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:11:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5B7A1C3859
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:11:38 +0000 (UTC)
X-FDA: 85270314276.21.7F878DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4164F2000F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:11:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dgkq7vbH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790770297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggVAIA2sklo26C9Otz288zpkz5G4DsOLLNzvqX2b/Wk=;
	b=bQ+gjIa/JJDJYw4LWt0MFK+Tyn6E0VneNyQ+3NRtfLg67eKjiCbBbkwFIAxk0uPI5wZFU6
	2MdMiS7dP4CqNtbnYGlhIXiDXHNmXjFm8MprXX6Vh6RGxpBKZykWs5i1VMObv3Gt07KgJ2
	l8SIS56O+2/ALDeCk/Awkal3Qn8ZGeA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dgkq7vbH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790770297;
	b=pbDU191muP9irPkwTGWVIXHoI8+CAKn/YJiAnayt31J3MOLy8vpCClHqq+jl8vv2jUXyuI
	R6uKm9ZFPS3JdwmdsbbCsc1CFCI3LGaBHVolWvlweqxWmNA/F26vU0GFPKYQX686f2jrAl
	1LlaPRmZ0iUMkQnWs0z4dNO3QJ0mQ1I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01FA260008;
	Wed, 30 Sep 2026 12:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660FF1F000FF;
	Wed, 30 Sep 2026 12:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790770295;
	bh=ggVAIA2sklo26C9Otz288zpkz5G4DsOLLNzvqX2b/Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dgkq7vbH6iuUzbjuylfytcS5yxD3rIOJNZhiLtrf3pZ5RqbPANHofyLv8z32oVlZD
	 kb6w4Lh30KCwKW0+474FKeAlGGS6TlsV32FcwgiHvxblgHKp4igQdE8R9vVD5Z1qET
	 cKkC2/iWQ5UwUaL704IInXn/CdNJ4aOufJ2huKOxLnUjeVB2chDHPpb8uUuWd68Wwf
	 eenUMpMbt7ybdsG80FZaOSqq7PEqpDSb/y5pUcP1VaZ+PqE/WGOIPhPW3/S99XJnoE
	 qLHNU4G5LVQgXfg85M8+MAY1oMnY8VkXhm7XKaRDa3cBSGbsHp3QQ08+HR298m9Tr2
	 1S9ekVyRjwNAw==
Date: Wed, 30 Sep 2026 13:11:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: =?utf-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
Message-ID: <arz8Plu6J4YOTi0a@gremlin>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
 <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arz0auULA33fqoWu@gremlin>
X-Stat-Signature: qmcn5itd1mdetb6icdhing3i7trxnhj4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4164F2000F
X-HE-Tag: 1790770297-151892
X-HE-Meta: U2FsdGVkX1/3h4uucwR8kUCN4iou+WQq2QWOc1Q7GUg75Em/NlGxHmoWD9DgRCK2V7u391NcbUvxK+xHYlccj4wmUQw8+kMmPx4sNiAq+jduTsLtmLiBq/QBvx+2Xf+A5r7uyZxNwQUKDw1Q48I2DnoC+xVZixjEapPAPlCt9S+5kA6Wa3CtVOL2Q7G306usz0TdZFK8QBUMxX+jssWF7175R5Uo3r4ooaZGxX3zT9IkH/9Dvc6PYvOtcrIyNytVI/tfZOqyvv7Mjd/+ukHhDki2zcl+n/PF1O7OhViD3DLif/j2VdBVNgL+D7xh9HtyhpAUqq/ILTxS0QZSf+Mo4NpZe/OvxWoGh0t8a3Jw7tTiR0CsCam1QPodTO01ArEs29mcztne3n0PSdyV3Lhqy9YZNtxJRSGBX/DdxbBeaiu5RNhp7OTmAqZoxHvhgoGfxUYROzne0HH2rNs5OTw0EN5Z/d7lpHQn964fz+lt900M9r7f3LxRoewOmHk1Wn9/Ks03oNaDc1EI7igPOFDmOPrmmwEqkLx+IQV0nXM3G/qDeq3oiwf+IHy9QFKvRjXDsOcU7GfLwKH4Ms8jqcKSkIQw4JeUFU5/yNoSgJYMLDS1bz9eEY4zvu3Eq3BQHPgL6Q6EZWGRcHqfL6IMPFEHuCgeIuMUAuZwd4/viUct/1qJma/AIvLk6DZip6Jn8CowMkBPgBOA6I3EfyYOZhk/wK4o4c4vdlPpGnnqsrYZMToCLa2Sive91MfDzOWLpiQx0UtA4hYYvglgkK0ZElkEs5OCCq9NHgZAVHU/lgSIXwwVioL6COt60UWtiV0nK/fkDkLSckbJ4bsez41ZOU12o6MhQty9XidcUkTjFMAvXZAgHOHttfcfpQAazs9qRjzCGcaKHxmcHN/ZMAJ1gHXzZMfKMGZvV9rxiLFGGqXXhVh0LY+NG/YA2ezpNAgMyJufMJVeHzR3JOkd9aF69Ov
 +yv0FrGq
 cOCnjo9b19Bds+MN5L+zaD2VOST7OQpHKDWWYDyo6l/VVvQsIyrZDZmmIpR9dzdkCVcC6+rQUy/0i7r/gkxBNb/6rLu5VUjHBkYilqcoH0HSm9BD5xibwgZP2r7SthjJfskHlERnXECW1UgchJxo/J0+jsNfLiuf8wrr6hlpZNCmFlvctd8NshRFbFAxHD4AL5Pj8JPs4JjO2vsm/xPsfh696OuXIzIv9/nxCmXq0pRSYJWYOrSqYwQ8SrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 01:08:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> I'd say in general the shape of the solution would be something
> cgroups-ish, but since all of this is global stuff and the knobs are all
> global I think you need to think about your design a little more.

(Sorry to be clear, this is - if we accepted that this was a kernel issue that
truly needed something like this - which I do not. The solution here is to use
shared memory as per below.)

> And in general we've seen a pattern of 'writes to MAP_SHARED, experiences
> problems' before.
>
> And the solution is generally - use something like memfd, have a process
> that does writebacks manually for you as you need.
>
> So I strongly suggest you do that! :)
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

