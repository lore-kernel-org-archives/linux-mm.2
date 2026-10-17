Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2CDCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 23:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBD06B0088; Sat, 17 Oct 2026 19:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A37B6B008A; Sat, 17 Oct 2026 19:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8AB6B008C; Sat, 17 Oct 2026 19:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40DBE6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:26:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE15514032D
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:26:15 +0000 (UTC)
X-FDA: 85333703910.14.9607C0F
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0B2F140003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:26:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b="wzZ/6EHB";
	spf=pass (imf23.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792279574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+ChxQruMtybdrIxH4Oe8hOrLdCEmzhndPHUNt+XKPE=;
	b=vss085Y07orw1ag4ZyKuUv2U0mcR1bRQojSDITecdtgicqyBGSkdrQBrUJdRy7OauyMLr8
	nhxbtbAUdYVeVOgYL73pNQWfHaLPifi0OLMLpyHWJxMXpAIyHw+tKNnwqKqgXWwjHwTFjm
	YKm0f09wfvmiI/0KteDkFIxQ5YDpMic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792279574;
	b=mEuZefIrTbz3sRtHB0WKDr+KHSXQBFlu51DaHKawQ4J+uDyy9pRb4YGZgTb693h8v1nmkH
	nfB66HkVpIYOB7fNzr19C+ghNjKrAjgutqtoJaJCo5MZUFZ7rCKg6wK2Azy9cJXBtbrdzM
	/i3+J0HMLKIFARngeAOANKEGuZm8UpY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b="wzZ/6EHB";
	spf=pass (imf23.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1792279572;
	bh=5+ChxQruMtybdrIxH4Oe8hOrLdCEmzhndPHUNt+XKPE=;
	b=wzZ/6EHBiigs8/TQYNjoDCs/bWZhBQxV0oRv+5YMCJCot3fU2FYd14whwZFUYDLrpys3
	kZlYEeQH/bQTabrsz58OVISF2LFeixWETRaWwZKJNS0bpwZbV3qzxg1GJVA+6gpY4P8aWp
	nUh/rCk5wI+tB5+966TTp9MOzLesKXbNHI0vV0FnmGXVIDE1txhlWWy3FG/ZqHQkfZVR0y
	AsN32Yox8zgMV/3++bTYWWkls1ddzl1Esxw1wcFgrYDcL8f5RdIDUN+TAemb3wXQQ8AeSx
	oKFM/1JsiluDALnxZSNCfdUudaJMqAmnvRpXnoDi54KBOm7SDYo1mw5mfWVWAFFw==
Received: by recvd-567c5c9644-whh6j with SMTP id recvd-567c5c9644-whh6j-1-6AD40414-60
	2026-10-17 23:26:12.752423817 +0000 UTC m=+1578342.782868143
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-142 (SG)
	with ESMTP
	id BqvlJyNgSimQIUNJgrYm1A
	Sat, 17 Oct 2026 23:26:12.534 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of
 syncs
Date: Sat, 17 Oct 2026 23:26:12 +0000 (UTC)
Message-ID: <20261017232610.58733-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io> <20261017040710.1174009-1-lizf@honeycomb.io>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeZBE29le3x4T?=
 =?us-ascii?Q?AizvtRpU7VP809D=2Fmwb1shMNqfUcvGTQsx53Zse?=
 =?us-ascii?Q?L=2FBtvuK5SBXStd+Nht40iPrZhf4f+iwfv6L4xO+?=
 =?us-ascii?Q?tx=2FgyVkcqEq0DIVvfS8GRUpXHwkVT5VCn5dFeRY?=
 =?us-ascii?Q?BuIHBFnNpBLo+XXnXblxIE=3D?=
To: Christian Brauner <brauner@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
	"Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C0B2F140003
X-Stat-Signature: h863wabpinwwzc977xzkcsxzw6ky3uk3
X-Rspamd-Server: rspam05
X-HE-Tag: 1792279573-958154
X-HE-Meta: U2FsdGVkX19n3vcoeaFeAUjqLtBF1/2drm8XH3QJm+cANQ8WArSRENQPvoG2psH7OpIxVMHSO+Dprxlkur0zQOsutGVMQNPU+ZdXlSQzHxwAbQsu9MR+GnBrdTFnVvRDmn9crYNCmyp7MbMY1hSp1o9uP6W/a8grjbs957Jj1k62LaV/WyFHUkXjyRRXjaQDBo4objcuaKZX0VJVmNYzWTP3h25Xgt+Gzj5HU68ioWRnVippzNaH0qHU09ISJ2Pkk1EteRp3hzAv/+yjgHMtnVSuLJUOyZdR2fXWIdrgD5/o/GuQFYhXqA+ZoRJbYwJ+7VXTHd6BfvGAgvKops0L83IdLWM53zUOVbRMKrqG20faXGGlPUo5BVtO30z3cMTYXpcErBZGfUMxetGY+5vtWylLVGcukO9tWsN3Bc5WapUIt2zyKajAGY2bG5WpkRR6hMAcNMAwmdyQLNcBVN07qJtgfpXNzmAEtiRhgs1zIbUc5GJk8LqNod218nKrUQbd3PS7X4+F883RrpTfE51BDjM1bbaidFU48pupZfIuN3eVdwEUG9ftL5g6CpeErojILZ47dqF+sCMMpo74wu9lXGq+/ZaeuIlU8L1Wtgf7FhjQp1fMWsewA/w306LZSnWJQpqtK9Ara883qZ01W1AvqIv8WGYY/YQ2P2z7vW0eYefBM2sVxfno8h3Zg0W8gZ5dD7z3P4sFoFvp7UZW7+OmfFozjyHf8rJ1Ra9pw/ni9ouln2BrqIb9tsp9RepQ8DzCbUjvVIh0TBnMnME/deGXN0KflLtAWSusETh8wKWpKvqYukHifqavOGgSb2yo9v2+NWrNInbpiIpvQGVt71W/xtGmbDMjIZhJ4DcQjL/Gs0skVFNPQKe03s4RO9zG20RrBwreW/Fy0pk98OcrN85NmvhX50MGmYitrIlMokijV9nzw4c5kQ1iq23bLSFeynTDt/lAwmq3JI6InaypuJW
 GiYUfM67
 oyNWMUdeRM7klS6K/DK9Pa95paxqIzL0l5d3I3QBjiYG3Y0m5wARCxqarsA1QF61roDdVUU+NorzZ4IrH97qmH6zzcUKlGu/z0LhICkDD4b7IuznjeEwE/cgwcqL17l3BVkott6S81E8rO6XuOfPBztR+H8E3rIoZEmlEBERlOS9tb5i/IMAcf0kklDsQSGNr5Ki6b9Iv7WB+36nuM2aYg3LhRugpTSPRttdEndkdQ2JwNVrYCNDJEvy14kNAL0cgoe/31orpScuvzNep61XfZxuywlAYXA9rnHkgWLdIxqr/cw5MtopvSUn05aXkvnFSeukj7PijAaWcgNSthk9vVhcZm3dkjMZHLtJ9I0n/t00jR+t6Qup68K/ANfHI1Rw24Uhq+4SDlLNYg117rtCJjJ7dv0IF33k8cLMU7LsSk8HK5cBmUtNqevIloXKsw7RyuOWgLBYr/JRp8iNXNRNzW95SWnKdvqE84aF3kn+WGSUY+ItC8P2OVXNcZohmeMiAYOyNtjAQAtn9oV8KpSM9frJMeGUHK/idxbn43iYm1q29f87amVvQIr7lzOyMKk7/xc000IyHjlkojwYPLbSKpz69NH2/9Q/lDzDbgM2Ul8i3Fqw416IFNJZ859PuvXZGeAlJwBMaonoIpDiI5VIFZuDkzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Christian,

This fixes f6988c90671e, which went into 7.3-rc5, so the regression is
new in this cycle, and f6988c90671e is already tagged for stable. Could
it go into vfs.fixes before 7.3 is released? Tejun has acked it:

  b4 shazam 20261017040710.1174009-1-lizf@honeycomb.io

Separately, the wb-dying-cgwb-flush series now has Tejun's ack on all
three patches and Jan's Reviewed-by, for whichever cycle suits:
https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

Thanks,
Liz

