Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC511606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QpeJ5DQR
Received: by kanga.kvack.org (Postfix)
	id 1D0466B05B5; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0767A6B05B0; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20306B05D6; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91D446B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C05DA4046F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:12 +0000 (UTC)
X-FDA: 85446189024.12.3D927B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A1A1720002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpeJ5DQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957790;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIshfsi1jWhoOiNy4fegdmvBAQZ0xKiyYeyrKPd8Xbo=;
	b=gsxh06vCTI6BfAmDPWBV25+yvO+66W1BR9Y0ouHYEqwl9WMHfA0cQL+89p2UdPHotYsuY3
	CkHTiAaqtie46/WD+VYfFlBWZaUtMEbGjsUqbRFyFIPyJU1T7mSBuXfyI2JyWC6w+CJVwk
	B6tOzJfoo9+l7DqKFriIKGMhhUv/i4w=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpeJ5DQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957790;
	b=RiBd59EQ3EMnrV8W5pVSH/e8C4s/FInMALbmsyFgybb3frMMgV39Q7fvcFVaPmiFXDiklR
	xJMMnQBg5J1flQFrXTolbc/nSJg87qeyl6Y9DjJkG6oB2qOf4zsHkQ9kd3tjCj3X6hwR+S
	dXFxy0pygCXZMqMwpfwVMmmH3MIMDBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC75645E89;
	Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957789;
	b=tZofsLBE9ZmvqkpVUrt/V6r6vBiXZ4Kz0uLR3fYuELIeqFZDhbIcLyXTgx51wu0ArB8E
	 /tA49rdx9Gy/q7XG9P3cY9vuyv59UQpKZlKC2SZMvNHQkTeiPiPx6tUg50EwfNEeHTA7G
	 TxAkSzDJO48nJN1b+zL0v6Vj5l86Z6AtT6ouxZzvB2Umt4ZL9sYFOUvut5qSubS/M+85n
	 frxd4tlvC2T5o2EDPfE5i0abrJWCA/rhPWk6KmuYCiKmfNYjuxO9K0pHE/9btUbHwAysy
	 uSgea3iPDpNdDhIbIGBul1iR44vRv/zpPFb1bmH/OLHBYcxsSyz1nueInuk0Jj8uFaA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957789;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aIshfsi1jWhoOiNy4fegdmvBAQZ0xKiyYeyrKPd8Xbo=;
	b=ZDbcY4T8i0/gOt9UQjULCYfIn4ms5YjtxpFEZFn/GCO6Oe5bSvhIbKSXlVfs/U6e36SZ
	 i2bWVeF7DpbvgnUlwybC+DbJSoosqGCz05w/R7ILfoWOafJ1rVuo4vYE9leIfRABaleJH
	 VyHq7AjuJfypQ2vI9EFhriQPur1NwF9gZDX4vEycoAaNLe4gqIKidEiNa/paLflCKQrTc
	 fMm4NloSrHLQsFlKAeA5GcT8kRBxpMfsOCRg4O7J2QU27pAGw5S8enDZHmWrGOQIwt6gN
	 igIj5U7i7n9JKyKmEHaQjMleT9jmNGfeCgHEy79Eqw6ybGEjYpCJT6SRZTer/GupNZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 741BB1F000C8;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957789;
	bh=aIshfsi1jWhoOiNy4fegdmvBAQZ0xKiyYeyrKPd8Xbo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QpeJ5DQRzFtcFo09xSyv/LP+PastLF6ctRZxiYsEqEMBQnq0VXsa9nmTbR2hxaFHn
	 Vd2xbPJOvCJfogTzbCqxFdfUus1UR7AzLyhK8aihmuTyspOH6EUnx36gVUqxN4CcI9
	 ogiANiiozzV5xJhGXgv4HC78EhOsfAbPiBG999gOQclnXqY+qxeHc5SBuj6472GKtl
	 FjNOb/MfJi/VE6lD3PehW/6TEnUnpXqJGyhwlELQ82jP8KrhnCfOB1h4wAxn7sbdzO
	 DVMImzvX5jAaqik5oKaFaBImqfoERGPjG9Psg/vKWI13DY7ObBgCtdtqaSMMldgElI
	 2SSxbeMpxl+Xg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F3BD14AB48;
	Tue, 17 Nov 2026 23:23:07 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:18 +0000
Subject: [PATCH v2 4/6] Docs/mm/damon/design: update for
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-4-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=1087;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=sxtzpPREIDw7ZFR+5CW2rzs4hwvhtdKiGsknt4ydMYc=;
 b=xiVHw5199HmKXsAOjssCMVsuFWusG6DrqEzzM1EhmXCqsD5qfarnz5oHJ3Esi7c9q4IO2vUhk
 5Fd52nRKojmBVQKEJF5MYGEkmW+QeOfHqB2Tu/ZJ9MIKpxS0THNEGAK
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1A1720002
X-Rspam-User: 
X-Stat-Signature: 5jha73ajx4454qsrgez4oc5tgx7xaxtg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794957790-215775
X-HE-Meta: U2FsdGVkX19UPHOBj4OPeUQXG2hrfR2LgWJIqMv9QFAeB5JRCRtKqcQ5PifMCMWEjw24vBC8m8Ht253+6OA1fdU6EX411dxGKOZMeTyYVg4A/z42C3e78vX9xoqybV8nKlaFM/UwRwiHNE7ie5rFMJD3+vHXVBetXODIW9EJhfC1VxDqyNjCKN60AdM8yOnaANuga2LEnfANZgsBktjOZO4cUi3YI4n9TN2enskWJDA6z4Gg58GYt0lfmtNx3EGUMx0wamJctPx/FhVYG1udxUtV7ismS+mJtzPvPIvZ0S4fVObxVGs/HWMEa9yFZ6qUm02AU6m2RM9wtqkmz37JJb6UBXjRTUPlMJV1fY/WMjlflYFKektqrQMr+JjFMi5iwSwkEM5IzPZYVlQW7rS4gd4OkoGWTgGB5jkOWUHvTcVfQZllnJqdyuTl4QsLUQ36aUpNW6Uo2KVJ4IwIJb8MFiAOEunc50GnqfFBQMsQ5/FDG5EGc8QBdhuETOpz3/jN+g/sooXJR9RNCVNRhwDwvdDy85ky6SzuZ3w7b7xuJsc5sAElA3Jn9focWXeFSs79WiV4m8FJ/mgNEireKPpV5M/wfPkdpooPWKuG5xcCWm0xXYMK9cuN/HqpD91a7JOOJkhhEVa5FvxZIErX+x1rbBBD88jG3+wQhTJOf5+1EALQw5+79k5qjO6GBTy5qEAZVECNVIfb+swGIiKRmpN/xHqbM4dyZUdsPlZWcmvA58Ds/ZE9yAJmMXcZgs1jkqeVQdh5Ja5pAxmyuqq9OzGXbbNVcsjXYKe0lI+J6Q1T9hg4WItRP34U70BLUi2kc8W7aLTMjp7c/waca0HGBERX3LzDkTr5jqeqfCb3UXQdaNJusJ8CjneXdDPZxwsSeD2/dzivZug60VpNDkSx0EKbNM2MLjFfR7aErfIUUSRsYzHFSHOfje6bH4vJK3yUQBS7mbjzXCypvDvVbqo+8T7
 9oUCsYk0
 kD7eOmWNhMhNfwBacI9GZXjYBzldHuTX3ZosX8fQbHy0j4+qUQaTPH+JjPHErP72OgGBQOyiV6ArL7O+Zh3JXjC79W9kBhphxnZ/c9EVTLbWpt+Ci3qwl67oDmUXUYZv1EHJ0CZRc5fo9F1qxVgN5jbndrKAqZIahbBPjuQlkN2wNsxUEzXUxJ+HU5+DMwBKkjy7V1L8ZZFezvz/TfkBG3WLwT9wa3M0FurtlPOrRkbEoqcAr02UaCO78+nqeyJXfIlnzPzezaQBpOgQqVwEKmLRVfiU1DuZLN6udGYGyJoa19R0pMQrS1HS1w3CNWv8A4VT/0T5Ska/yWS7ZZy56jrPz8Iv2+PeMp+hjeanwZQ0ZudMDUHWV5KCyHg6VS2zrCWA7WFJ8Ba9IoVLuQHnbEtEvIVa4QFd6x9vHJhUKRH9ksUYM8bWZyAc5y3+JK6/rwwIbql3PkpChROFs0qHL4U6zxWVY1/6VbnFiCD84ifi/zsr6W0tIQbIOeS1vRJ8cqsN8NqbvTnqzFiXSJEw85ZMU3xGpxgHeCEedXUGojP60SBU8vQpm2beGF6Zd5ybFBm4cQY2JBt1VN78jm0T2B2P9o+qg9H70GZNJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON design document for the newly added DAMOS stat,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b676be697158..41e56af84d45 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -876,6 +876,8 @@ scheme's execution.
 - ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
+- ``sz_ops_filter_passed_last``: Bytes that passed operations set
+  layer-handled DAMOS filters in the last ``apply_interval``.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.

-- 
2.54.0-uber3



