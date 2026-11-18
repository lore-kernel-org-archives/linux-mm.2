Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61342606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IDBUo8uz
Received: by kanga.kvack.org (Postfix)
	id 79A846B05B0; Wed, 18 Nov 2026 05:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B986B05B1; Wed, 18 Nov 2026 05:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662146B05B2; Wed, 18 Nov 2026 05:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0E96B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:21:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF77314066C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:52 +0000 (UTC)
X-FDA: 85447848864.12.0537BFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0983D1C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:21:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDBUo8uz;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794997311;
	b=bIRwg1XqbrT9Ljp1/MjXZFo11xTrmzaHvLxjBnA1NVlE+Ixwg+wZx/IeCJa2aevJu94B7y
	ek2etA7nF7frppowIGeX4MvLQu2FclS5bP3kkASq1B3pVLFC5wtizBOjcH8mLzmHVKPo6S
	XT265wosJxe+D5xyNyz4zvI2syclpm8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDBUo8uz;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794997311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5kqdiRD/HYKUIZ2lnUjvtSkH0MkXvXRyGaLJhx7EKZM=;
	b=RzAUZd5x9mr3ICOHGMQHNtBqMOZSsyNLnkcOmNgQnZ2w2i4I6nDDCgwqIXwbw8N/MM+hZw
	1WNN2w/FayESuyXWAEma+MS8UmjwEyLvo0g6ChGR42ykmCMmlaFOcUWu5Z39LCCFDVBe2P
	TJ9dg2pl4Jcpwy5re98cQdSBCigbsUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 375AB4553D;
	Wed, 18 Nov 2026 10:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35E71F000C7;
	Wed, 18 Nov 2026 10:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997310;
	bh=5kqdiRD/HYKUIZ2lnUjvtSkH0MkXvXRyGaLJhx7EKZM=;
	h=Date:From:To:Cc:Subject;
	b=IDBUo8uzH3moHyP5oqxoKhIz3h2VWrYUK+XPgBw59fy85kTZcZdT+gS7sFSDaMqX8
	 rEJh180MS5GgZ0gJubVBSHljWgMPmk7HE21EZjt9SJdLCj2Q9sBEVAezfif87TWJsI
	 IWpMR5cVTDwhzTB0ABz+FIBo3FQP/ASL0sXM2lDt7LL9Np7SeGMm/XqUb6yIGYsDrw
	 tNRbA249bdMkeoDrsbDa+MsCZ1AR/0WvtjRjk7QydR4A8jGpi3DAKR+ocwTZNDetUH
	 0/LZITfjIQsMHeZFVSId2OHtCSrcPI/xPKsbBtMEbXJOFQC/2aJ3yWztB+Nn0L4hkK
	 fZPfq5L6Ugz3A==
Message-ID: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
Date: Wed, 18 Nov 2026 11:21:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Using In-reply-to: <patch posting> in mm-commits mails?
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0983D1C0009
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: oidfj9dujphabgtfne4dym31ebgxeb77
X-Rspam-User: 
X-HE-Tag: 1794997310-702077
X-HE-Meta: U2FsdGVkX1+YUTLEC1IbAfPbAZQkFnGURr/BQz4EVhDHdnlseZffR3CtH9/zOGijmgfxDWkx9eIH2fQIpBFxlnJgf0gm7rHGknqHoNP8zHb/foPYnzEfeq/tmn7JGc/yXOm3NO8EX4ziGtMECmPVi6F5TXiQOzDSWEOTQEt4q929w9tjHXwUttBTgwRAsRUJtoOa7CIk86NUr56l+z2CbS1cXW45dq9WSItyvXRcfpbzGBI28el7ks5phClIQsY5PZlPgTKFU6/Mru8GrNm94IjtAt1becvAw/IV9EwG7Ds18Zv9IL/W6MKym3yxZlMeqnbWKpSJoCnO3AzaLfJo1zhxPOdE5XzBqG7drc0Hw3cAIJkJaI7Lncyf7WoN1RzcLzldKjeDasjg/ODvLfA99yqeO0ihK8iDUjDv523nkV87UeolrlK813HrC5ctW+qygrzCwBaLQZ2s2xC5LdNSVsg0ApmbpZAYifrFNp0pv3HffVYestO3PEMsfHGXgiTUWjRndw6rHhT5HoUX/hs2aO+rrsk4B3ilacBjMvbNOcOreWa200rFqNBSCk3fFfDY9wy1Go2/Xe6GcHbk17CFgdqcK7gvQOsYx2uhyUwccNisoB6XB3Hr8gaeVGoovXNezx15tJgH8wZG7ipw2l289kp5ZhpcxJPcP8IjOpA2x3cgZZuFt7KT3M/pikF1byPMDJ46pYzDe+TRRPUHQ4sai3iYQ0BtIPHhuksrAwddTdsI6PNLgM+xrdxjt6FG4ugjBB04OYGym3nNu2Ufl0bcxulgtOTydp3sh1ZnFKq4qoFOHDPntSOq6cOOHCFP7sSR9ZW5nvhdvcS8Cu9IcNQPosMRc+ApybBbpHaPnmar/Z8o1PIx8PzI1TdR70BzZ/iw6XyP+GCFxdNIJshqhT7udL8eNSnTSGF0X8gJwWKH6ScgJ+QgJ7fDcMxcDzX2mNrapVhuNZMrYq6AO7ihI/Y
 Nlfa8A5J
 NtDJURaJN0E1KYGbnLe+OSyyk8urIaig0uj5T/wHha5f5PuAPcwuF68JGVgS5cHU3K6tkgZBh+pcftqMlxmFFqkZAcyU2ugJSBVINGeUygQ2jqmtRZOrLf/ejGg4ijU09I1rNBBhnBZuofJdFDCz0s15GB3Tg+EjOFGk5VGAFqx0xs0CYWnk/DBgukSmaC7P5WPcBVnwvdOa4MtIjJwGnj+YwodT7wh+IR0ELnSNQ+ljPTZyoMmXYIC9qQRKr2/1oF34xDDC841zblEorrLkOUu+p8a2o2oK2SfgAUFfiRS5vH+wVDY6TbFvBoDnqT/KfpuPorp1gf6E2q0Rr2gSW/jF0MYQUzEMUj7X1w28LiIU8Wgl/FaVVVYli+jb6S5Wb+kFcoRa+OdjbrLIIogbAw07q9P6uJgurRv/ZyHImg8MI3D2JJjI4vgSYHd3EfmcaNGll
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

during some chat with Lorenzo, it occured me that it could be useful if your
mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
the respective patch postings, which would put them next to the patches in
everyone's inboxes. I think Lorenzo started to doing that on his receive
side with postprocessing.

While I haven't checked your scripts, I naively imagine it shouldn't be hard
to add that In-reply-to: <msgid> header. You already have the msgid for the

Link: https://lore.kernel.org/<msgid>

part. Maybe it's tricky when there are more Link:'s than the patch posting
itself. But actually after Linus initially hated these automatic Link:
additions, he later settled on the Link: https://patch.msgid.link/ template
as acceptable to him. It's sort of documented in
Documentation/process/maintainer-tip.rst too. So changing to use that
template should allow to easily grab the right msgid to reply to even for
later actions on the patch, than the initial addition.

Thoughs?
Thanks,
Vlastimil

