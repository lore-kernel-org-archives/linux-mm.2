Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9169606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPocwhfr
Received: by kanga.kvack.org (Postfix)
	id CCD056B05BC; Tue, 10 Nov 2026 07:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D486B05BF; Tue, 10 Nov 2026 07:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D836B05C3; Tue, 10 Nov 2026 07:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977B26B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:03:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A1F11C2C98
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:35 +0000 (UTC)
X-FDA: 85419074790.22.299D81A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE80F100009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPocwhfr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312214;
	b=cYQdUX1wE+Bbkhqw8GmycI35CWBu0HKPNpmB9974vnqcxFwKo/QS6gNX8TuhEPDvOqaCwF
	Z2xSdt0Mb1E4C96jOh/Q+F/cEzUArLx7JQx2qh8lYMtPFD9q5zzR2SkcfFIEUSYKiqju7t
	no9rw8Yd4o3/oBhL2fFnf9eVEPxu814=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPocwhfr;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TI1T5UEakcFCW/hN65+9GVK1NvkYkGyn8kT8/oGVat4=;
	b=XCKT8XWWsZMefrle/wef+YwvB7S5f8mKVbleBA84lDwpxPASzddA1Xlf96cxc8Y6gsNbrG
	speAhKFygloQnsoOGVxay1eUPmMSnX0iPb0bof5JIQh/FAGf0mdAatlPikEoe2jmt+uc9b
	WnwsrVIthxoesZpjBQNkRVgd0WyAMrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73332633F2;
	Tue, 10 Nov 2026 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38B51F0089F;
	Tue, 10 Nov 2026 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312213;
	bh=TI1T5UEakcFCW/hN65+9GVK1NvkYkGyn8kT8/oGVat4=;
	h=From:Subject:Date:To:Cc;
	b=UPocwhfrTcka6Jg9F8LF7zn2qR/0V9QoQoXrd3GozUtn5Hk0w1nDCmDSEp4+87mBE
	 3WFAAzcj+rgUdlirlEo1Mgn97Se9rCjIiJRh/jCDf5qAtl8+PqC4HRTd70YK78XeC5
	 4BghLIMT1BcaHMlHkU/KRF/63RovlWUFT1VTz0/Wnsx9BB8uqFcyvWauI1Wh98paJn
	 VT8jN47ZwM+o+DUcD3THeQEj2JJH/hTu8h/+fZULBTTuZirj+VKGC+WWjjk82CKMDB
	 M9vmeDN6jfjsy9yDBousXx06QjAZFr8O/BESOqB3I7zggOdTjG9pMIwoF/viFrWqn1
	 K+qsluotQw7/w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Date: Tue, 10 Nov 2026 12:03:06 +0000
Message-Id: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAMAzAviI9O7BjKvgV8eC0ai9ztKDC2N+dH
 gNJEigJk8JQJRC6WPkMBbCuYDnmsJPhtTDYxnaI2JhVzmg+k24SPTiqsZ1betd6RN9CCaPQxs8
 /HaecX89JO6dkAAAA
X-Change-ID: 20261110-drop-reviewerships-264c745b11b5
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1291; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dCVSMtwDwE7/hcxW0886EMv9/VrEruWg6lsa6zaZd68=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+c3Be6f/26HzVeq+JU8/vM5fUY/1mb6KfoHhgefdhx
 uO53FzlHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIwmqG/ymsz79EHL8mran3
 uVx+iWiWmGgou2Lu6eiv8xm4OZP4BRkZVv85HZgX99aSgyf9qmER4/57m6zS9A6ZTxfOnGj6c8Y
 1TgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE80F100009
X-Stat-Signature: c998akbxw7k9qy9impedwyqwbmgnkst7
X-Rspam-User: 
X-HE-Tag: 1794312213-930744
X-HE-Meta: U2FsdGVkX1+mT2D7OnC3V6sRrc7A1ZIFoEDkvqEu1QLel0pNeO4e6PZ/TctNZ7ikmIs+8hOtGIPt6XniWTBwtVps69JuPIHECjpqt/5Ld8A6wIb1/XXegS7D5q8YHxCwJ4Y1KMcWeeMGlVjvAxypUINBVf9B153ds/ByLE62Y3h8oVOh8E5qsQsgQMTtep0E0k3h2DNkxmkipNTsykE7zuxdckD8iD1G8pP5aLFpdypktGKxPGvpaqH3B0JVEODYh1x1VjGFzUuH/02H2dO1bSZlJSOSxhZcUjKALK/sER2+NL66NqSaLltdEz49G6I456qgin0h2kuNxzAPO4qL80N5opvwIrRENZokmov27oJFSyxOvbb69vA4avRFIo+XsFpaHJHoCKuoJ1ciifD5qb0xxe8skoWujEtdWruBLba9ASP0Th7TY8CIi5qUMr6O9wLDKxUTT0MODyzwotuyhVUly+d/bhgS3PjJYGsJCZNXOJO0KerSfCH1g4hFbAQU7wpwyleLyiVmqO2XbTE/vmGkZ1nLrDzXXVoGCRFbYCuWCT2Gl0NDLHlSkYUR+w130rnk4WA7y341Hh2eeypN4xaVEn/3+s6rwP65s4TeK64At/xTv0VpxEXobxnjpQXmG+HJobHTaJR++yQOo5Fr/opWpgSRPX3+m9/2OHnK+JkH6S5MkxQFrLGai8zDQRD04TcKa9lcs9z+bMSpprQwTpLe8gY/R83UAFtr0xD1X8x/2+6CPgXpJcPow8q7C07X4KaNk1wg5mlq5TQPpFYQ+Qe640T3Upw+/Dq9EinxqhQ/K+F3oPwEfJyGG5tqZRfQH7w1YgkWjPHGyq+r+5blzUqVqWkPIoMa25hPH0g1jvB1PMEqDXUT3aZ17Ff61i/uvjaaGbZf0VmkQ6E+9N4IBqppOO5MkH2ANoXFFDJ7Z4ZhyCPKeBBnxIsCtlbKJOLvLxd6BnN585KL7Tn2j4n
 klnHiHvu
 6eRsfm2mjuc3+Autkd3IsBBT9HQX8o9uwfOgfsQZAuKgAIndqeeh+25sVr4YR1JGcrRKmXE4/2X1J3aOxhZdA+sUeeNl3VviIHM9ktGplIvjYjxo5vWdMAP41kd9rp3/GtnzR5MHR3XlS3tGeZFWc+Y5J+F+YpCoBbEcw80cp6c+4txV7sUtuzFDPsTNpTxr9HESL/yejPTFxLemOiJiw52Ikb7iv95THSAgVX+5pbKOh9h0sgoEJDDDznw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

I have separated the patches into areas maintained by David, Andrew, and
Alice + Danilo, so each can take the patches relevant to the subsystems,
for convenience.

Apologies for doing this, but given the current trends I'd like to do
something to make my inbox a little more manageable :)

Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
appointment as co-maintainer there, I have no fear of needing to step in
there, and so would like to record my time in that role.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (4):
      MAINTAINERS: Remove myself from MM core reviewership
      MAINTAINERS: Remove myself from MM misc, reclaim reviewership
      MAINTAINERS: Remove myself from MM rust reviewerships
      CREDITS: add entry for THP maintenance

 CREDITS     | 6 ++++++
 MAINTAINERS | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
change-id: 20261110-drop-reviewerships-264c745b11b5

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


