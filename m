Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29402CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AD16B00A0; Thu, 15 Oct 2026 04:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272076B00A1; Thu, 15 Oct 2026 04:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1886A6B00A2; Thu, 15 Oct 2026 04:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA5596B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:38:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D461408A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:38:24 +0000 (UTC)
X-FDA: 85324208928.11.27D6EC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6BC71A0008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:38:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0cOU3Iv;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QUD+c1323PsztvrlF2fySDh5bNiRfcnbuB+/Bt/UW4g=;
	b=pb9Nsj+YIDY7Bh9mQQDl32nmTND5cceFMIL2hxx472PMOaXOhGUDfACe2I5zGbqZVRWPEs
	QYi53toygzjFKE7hvSCKABf8MCJb4yUSRhciK5axNIE9yZpOk6u+hDCzXtyYK69r+4vp6V
	j8V5Grt6DQO7SGnFadYV4pwol8gnnqU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b0cOU3Iv;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053502;
	b=ggGK4RvXDyjOtDgvHLVz4aMXVEgiMfEaJ5k+an7q2GX20LY51Yw3G/oQBS4vNLhYKdGTyC
	QLNYIjvpmgVoOpkUkKAL+CGlt7bsPvBXH8WKUvcws1DRQyZHknT2l8ghda+oJwGtWd5495
	MCpYKUlj0YzgKJCAaIG4cDiWlYlCbBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFFA0419C6;
	Thu, 15 Oct 2026 08:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8978A1F000C4;
	Thu, 15 Oct 2026 08:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792053501;
	bh=QUD+c1323PsztvrlF2fySDh5bNiRfcnbuB+/Bt/UW4g=;
	h=Date:From:To:Subject:Cc;
	b=b0cOU3Ivh6KJZ0UMuEmLwP+4LINdLABq3aKECPH9qOIAwgt/Gn8YGmbytywh4Vb9s
	 S6oVFJJ2GNGy6dp/xd1z7oQLNsfTzBi3cBlsK6CaqsHu3h5+BEQbSGMuhym+bHXhkH
	 qtqFcrZ9PKvt1IxIEP1yY+SFHt8JEs5xwQe77PDgBxzTXYoJhR5cUP2H2JVxAqx4M3
	 4V8f9HmHEJYjFkXyYUAxzmnUfUbH1Y8mnSuLaM+5Zp3dgY2JbYWYjV5t5jB9Ya3COe
	 YqFde4UYYuePZJlJ+pt2LVy/azeFWCciprIRge8ZwD7rSDUozYVKNgR5qjZf8Ec0ns
	 2Stx5xWr55aZA==
Message-ID: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
Date: Thu, 15 Oct 2026 10:38:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Subject: Sashiko change proposal
Cc: Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com,
 akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org,
 harry@kernel.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev,
 shakeelb@meta.com, sj@kernel.org, ziy@nvidia.com,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B6BC71A0008
X-Rspam-User: 
X-Stat-Signature: nq48s5hksekixhcfz47drue16gc4muby
X-HE-Tag: 1792053502-77179
X-HE-Meta: U2FsdGVkX1+fx/O5hBFXUmmuPlBkKldi7WBO4oOGmj70w2K9wfAEnyLl471AcqpPvmcv+jBL2AkTCuMjR4X0JtXuCyiPtwoo7jwQUiXqEiwZ6lFggty5iv7Jsu3SdjS75f0LCJdDEzECt2haYYIcFJ74eLoFvscRozExXX68X302cSTuokuRupIOXVo4lzbwobphWvG424ZhEErs6ucOrUx/wsr8vTp+50zuOBud/nVA8qYK+fWDkV5r5X6kRVHgZNbxmne7GU+JQr8jcuGII5VYFRDZnIBn0zwHKHMwWQrK8vlJYvVhmhaj77/dWDZMSARk//9kYP/ryo34RVFf1bifNUl+9ojZQxT2hU5PBYRSL7LEld7OSGrIzaljqBQX87FiBhAZ2dSkj2L58JWNnGNPY7tFcu79dIStw2B/i9VdesQBecv88rH5JLY4r3tFK/KWK8E5cTBIZlb8V6FoQsRGRY8d0/iKJLItigNGUIRKHqM6kQ5v4jx8jUX+Qe3zZ50s5gx8SMHAMZc92TLjxRCNsBOb8NASAPHc8M11u5BeMst09kQB0G9wilEeM+npyJnGdan3ZZ7BGsA27XE5JsYjX1ZdDVFanWDmrJXLjULdU/jiAOpRn6vukow4pDBechsKFRCM1bm786lalmRz9QXtFVB841HEpyDm/oFKQEEwyA6UJo4BcCG0IbN4WGzcqA4xV2CAI1ETgJYKI2YZ1LbZXTC+h1mSmjJf8LJQCbT5l4hiRNauaTX39LDxynymnQLjzxmbNgzv7F7PBVsKwRajTBSNvHVM3mADzlMyLxfTqRZOIeFmYZhoe4U60DfFgFG2kmETXpd2A20TBC+3u1ueNV5JP8LMW/aCc7WIBJsq7Ygvz3aI0OFVrrsh1waey9M1ZndpseLLusRkAlAj8vM84m9CDRLFtLt+TVDABUoHsVTfQhFVzJIyPPyH8OndtEGeMVpLpUcSNjot8/m
 II39cytN
 IdL0VfXohLKaDYFxo3N7TJPZYeyHUnMpVnjofS1dDubGiXg3+r0zcPFo3sjcYDA5lob4b4U1LsPH+mc6eynFAav8DXg0KJKo04X4NDo5czZ5o0gN/JxSS9D4uFiqTdQgCbdKShUsuHRnEShnHC7wU0CMjnIsNoS/IRdtgHq+tCXO/PC6iqpOluDNFbccT0ZtUW9X23z6lsRpQiws6VV9DiNI7Qn+pN2fYt1QJF3h/e/Dr+H+0jyPiOaT7S6CscjfUeJGRQpQAfkyAn0vCL9QFLZyOaVlZUzrAv8ySO8IFJeTB4gppc7Y7vRtWq1spfQhEtvb3FkiodZQ7aRSGAnUTVfFlPuoa2vpESU3/HrUW0f5yfNDiyJiGKkWZN1gPEi3diAA2jm5PW8Jq6T3qkmoshL0P0mg2jWjRifMZUVvrFTHgewOllproXlShpPSqfDBH8Gu5axH5JsPvf1TBThDn8HzLzYB/OrH20uthxauT2OhV5sdSIXvrzbII1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(CCing all people attending the mm-next call)

Hi,

After talking to Roman at MS, he just informed me that sashiko now has a new
feature combination:
- "embargo_hours": hours before review is public + emails sent
- Mechanism for signed-in maintainers to lift embargo immediately

That solves the key issue I had with sashiko: people/agents re-spinning stuff
too fast before a human at least had the chance to jump in first.

I suggest the following sashiko change for linux-mm:

diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
index a9198de..ba123da 100644
--- a/projects/linux/mailing_lists.toml
+++ b/projects/linux/mailing_lists.toml
@@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
 ["linux-integrity@vger.kernel.org"]
 ["linux-kernel@vger.kernel.org"]
 ["linux-kselftest@vger.kernel.org"]
-["linux-mm@kvack.org"]
 ["linux-nvme@lists.infradead.org"]
 ["linux-omap@vger.kernel.org"]
 ["linux-pm@vger.kernel.org"]
@@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]

 ["fsverity@lists.linux.dev"]
 reply_to = ["author", "list", "recipients"]
+
+["linux-mm@kvack.org"]
+reply_to = ["author", "list", "recipients"]
+embargo_hours = 24


Which means:
- Embargo 24h
- Mails sent to everybody (author, list, CC list)
- No positive-review ("looks great") mails (default)
- No other static email addresses that receive a copy (default)
- No additional ignored author email addresses (default)

I'd say we start with 24h and see how it goes.

Thoughts?

-- 
Cheers,

David


