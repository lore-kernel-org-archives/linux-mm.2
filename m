Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75980FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F326B008A; Wed, 29 Apr 2026 03:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B276F6B008C; Wed, 29 Apr 2026 03:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63376B0092; Wed, 29 Apr 2026 03:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95C476B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:09:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21D3F1204EC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:09:34 +0000 (UTC)
X-FDA: 84710717868.25.56722C1
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DFCD1C000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:09:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=cm1UrNK2;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=awKvtRvn;
	spf=pass (imf20.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777446572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EJhBkHEX7NcpQ00immYDqBnfdLu+6YEZWr1kaPs/oBk=;
	b=sj9uyKccS3tF5uDjPostmGTVRk0mQvtIV4jRtwHjUY9iunoFygXvU5bkb11e+rO+E8eY18
	Nwt0OETUGaAb2ebs65rmydneyS9UgzNnxYzBrMb9qlmDS5cls8BCiBHHKok4rlLmsv9WtL
	zyelTvF0Dc/zPil6EssGdjBRbYYwx5U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=cm1UrNK2;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=awKvtRvn;
	spf=pass (imf20.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777446572; a=rsa-sha256;
	cv=none;
	b=6Gn8GwTIRSW9qwE9xojse27Qp/gdnpxacKqpDAdgsL/1RyQ2yJT6vb8srM2PAJNPw/1jv/
	HzgjRyUgwomN4jAjqdD+C9+vWncLpFqJB1SniJSIxyO9MNjUk1G1KF2h4GfkhSULwPDUs7
	uruxqz0JADVdWkK48+yj/HDjdEjJnOo=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g57hn301Bz9v19;
	Wed, 29 Apr 2026 09:09:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777446569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJhBkHEX7NcpQ00immYDqBnfdLu+6YEZWr1kaPs/oBk=;
	b=cm1UrNK2iMJJFxNbNY7XoMX39vrgS0PKId/qR2ZO21EQgEKS397JDUze1GLzI6WzrsLvRO
	CuY3Bn4nWyDbLoluvOzqLLfVA6owWezodPuaSaGMI4OuqM/PDU3EKxGQ/V4y+diYzDbMMZ
	+l1sYNCUe5KPLh6Gta7dLnQe5VdTbOdguiq4T9L2A3xWRrmnA9r0xMxTtH/Y4NFGF1yVi/
	R6hOHDqAZ9AWml7xrpLGjrzRnJF2ZPZJhRhJ3Wws5Ii73UNWhE2p4FXVzngQP1cT9ow4f6
	LvQqsEWN8ENm6Gii6Dm6aLG2+Rc7ASsSPscIA1NjvhFH/b36cmzPX/P8EGKIDg==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777446567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJhBkHEX7NcpQ00immYDqBnfdLu+6YEZWr1kaPs/oBk=;
	b=awKvtRvnhsBSywBXCFoyYO2QzqYzTvKe4xYMLRo60eBqjHRNpOfqxu6y0KVHrWQCk8hdCU
	zvl21II5s2BbwlWKnpaXL5Ltwr1hNoygRA3yVBQp4EII6O/JxFOehCjR0FTamsy7ruodtx
	uDkaXTs4CLvuqiTNc28DY6Su3OHBxM+ugjYqQzoeVNyBNe0048beVS3gZ7je3y7cRKWhpJ
	qrvvq4qfVcGThU54TELoLj3fJzvpjbylNqFmVfb9zaMcEus6CGhKpeserV3+BbmmjvSPBy
	XpojvX9HfPZr0QsPWfstowzWWDgsx1y9qBG3VkzvQjstebue6wEKw0bhrolgqQ==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-sound@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v4 0/3] Documentation: adopt new coding style of type-aware kmalloc-family
Date: Wed, 29 Apr 2026 09:08:01 +0200
Message-ID: <20260429070759.309110-3-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 214930e8f274b4c9e15
X-MBO-RS-META: y7dqgagn76jnut9fzikn837x4rxj8e6i
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DFCD1C000E
X-Stat-Signature: w8oquhkeoksp3toqxsjihauc55teia3z
X-HE-Tag: 1777446571-898266
X-HE-Meta: U2FsdGVkX1/2BBD0QeTlrMgEbDe1ZMMhH3RFIx3DzNMNr9AlVQrkLYlIEzJYcz2XlUO3/5x2TUJx7QrurXRZJzoPQzx66ZhQ42OjBQGbWRikVjwhoXB75wY/4rbDzyo/xYgOyNEYt8EPolyHzfHNIy70clslgWUBiesz0Tmyql36XN24hs7GKsRyu+162FjzT3vJcsyRKNWiDSyc48BiOfrb4VtBz3TzZK7ZfTMkto0Pbf0HSQ0CGcyCh+ti1IxogcETtfj2DtXUpCzfrVLITwLiLVNMKKpxLwX2hAYz2RiPAZGsssXN2FeEmakvaZW0vJHr1LkPunJhFWPXQW/q1tDCAo0wLzOkjbJySTlUoQljS9eF5fQvY9JYZ6DSXPDhOml9IueB//ylU0Y6UmOH0sQj9aiM+J1UVvOTGXyEUkGqsHvmYMY4zVUm3qNG8MiMmkX6a9br6A6nI4w4kJTkogpyI3+ghmNPg4r6g7gYaoNIaoLvm3PdlNF02S3Rwk7eAFPA5UWYnqhobidxWYRsPTEcp3QUWJtPi9zPHcOgtF3lrzJsswQKqzo9uIxf9WxoGKTEd26Vlmkzce8Xt9uO9A3G+cmkcnrVbfBpdhp5+dYsGkd2mjHzWOVnOOYCmsE9tdbBkQFCOPA+sJ19+x2oRR956aVdFhu/iP78Dw2XX3yk5OPo299jpTVsmhAuAmy7phDqItC5h3VIaRhGjd+ax50Uldaf9F1li0iBWtbClnanV6sUkqQocahGSDNodO1PCvKlDWO3UCOu5RGZLe+5/kskulGeXJn2dSP3ScimtVw9uKKd2Lk8UdUCJpWufRct1knBeO1QhaKLEV/zGzFqpIpvWKKHJhoanydqhMrsLV5Nh+IZFuee0U0jxLHwSTqbCSL9uUYPzCK7N0Orlt0bG9pyIA/jszWYhspFWjgNrv/EE8libfilnpSRBWjzlupdBbVSwoJVNu8zsH6ylWZ
 pAnSel3e
 JOkjfikYwUHbLEcEFiGOT7UQ2kQysJfASoD3gq2CRUQzV0lA2lYKaz8xJkXTt8AUhwoecxGRjYhVLfryY/+SL5vAdGqmOf47bvjnwG/qCRTiJqSC9lFiCE7To7WeXRtrTOgoUg+c6xLNaH6IMXaYrgEAH61KyWYQGKW38hSv/IzoyYhZzRfYlyo9etxk3aqh1qNbmwetDkroWieD50ZvWyatX6u/AHe559+zkRzylFxOdM51NJVVlORsHB6nt8daJvHGD191Ez78xJD23+XLjzWRSSIzW1LRebk0wDaRkQjE8uPX6bOCamS+jl1m2edmWRtPLbLCXMc50M72aQAl01BntWws3nOaeGc+OacFo5qaePJU2u/z2D+dpY7K/M6eH89Oy3fFMyjvgz3xPYuw6M12iYf1iEqOIg6VgN9ES5wAYUjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation to reflect new type-aware kmalloc-family as
suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
and family")

 [v3] -> [v4]:
state the default argument in deprecated.rst [3/3]

 [v2] -> [v3]:
remove obvious wrong replacements in [1/3]
add Acked-by: Paul E. McKenney in [2/3]
change how to mark the optional argument in [3/3]
add recipants
 --cc="linux-mm@kvack.org"
 --to="Kees Cook"
 --cc="Geert Uytterhoeven"

 [v1] -> [v2]:
put RCU/* in a seperate patch [Patch 2/3]
Omit optional argument (GFP_KERNEL) as suggested by https://lwn.net/Articles/1062856/
deprecated.rst: change the argument gfp to optional [Patch 3/3]

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

