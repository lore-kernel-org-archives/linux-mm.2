Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 835C1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C26B6B0005; Tue, 14 Jul 2026 00:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772926B0088; Tue, 14 Jul 2026 00:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688606B008A; Tue, 14 Jul 2026 00:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38AC86B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:15:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 953E11C01CE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:14:59 +0000 (UTC)
X-FDA: 84986066718.03.E8358B2
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id E45CB120005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:14:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=iIQ6xewQ;
	spf=pass (imf29.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784002498;
	b=lYkumhUlygjmaNrEP3iy0JGBiX6yOjLoytkD2KG3JAGKY1YvOPiNJAjVeFhPyxI+yUk2Tg
	3S3jMvdES6LtdklXjDLwdb8QeXXfNnkk164z5q+KRz/P04XWgN603jrtY+qsj0/ul/N8S7
	ao/5BDA6ZpGMMnDKodR4cyv3gAwXSic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=iIQ6xewQ;
	spf=pass (imf29.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784002498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MV2PppsIiMWqIO+DNMAc6xCQwmADIksnc8DCtHjHJMI=;
	b=WiG2Pg3hzEGe+VJE1oKiOBZWzvtzaFS5+DzL8qL1Y3eNfQwhEDYFTGYel1cchQ2qAHQ7EG
	jhUAG6KyOJsksON4AJYy67cHhFLkyMf5vnRaVQtibH+STZ00SjHflCngre8eA7f48G5NvJ
	eH0KDQIFScc7/818LKuVmoPDuYic+ls=
Received: from macsyma.thunk.org ([151.240.45.25])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66E4ErRC025390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 00:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784002496; bh=MV2PppsIiMWqIO+DNMAc6xCQwmADIksnc8DCtHjHJMI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=iIQ6xewQv08RpAocToswgcb8vVJMxz9k1bD7fceVk+A763UEO24mt1+/b4GT46IUP
	 NjyJieu6TJDOGhozlV65RysZm4E3muBfUP+LbD195TGkwOfl7L8+0jRUOBOouRE5U9
	 65+kNDdOgNQt6azYCU3QJwFW1IP0hig6PB4toXyhgVLpuKTTA6hVYVmB+UL7f1KwdN
	 1vAPffzNJ2Zo4MNONM3va4Pn8ZoMipvUYJrHNF9LIPi6H54YfxiZnmFZEwrKEYI+/s
	 QRoPyEdQkxJ4neHEVUTgyE87/s+E4L1Wxzh51941RJYYZSZzPNaylQiRwy+N3lYpzr
	 SMgrWzkHYZEMw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C5547A04BAB; Tue, 14 Jul 2026 00:14:53 -0400 (EDT)
Date: Tue, 14 Jul 2026 00:14:53 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, ksummit@lists.linux.dev
Subject: Maintainers Summit 2026 Call for Topics
Message-ID: <alW3eJ9x6iJ8Juhi@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E45CB120005
X-Stat-Signature: ywsigom1yajfnihw8q5y8sc91ioyfuut
X-HE-Tag: 1784002497-162429
X-HE-Meta: U2FsdGVkX18glZVC7cQIM+Nwv2k52Hr7LpBvQB+RMWtBplu8ttxZ4h59jKGGNtWMwHv1VVPN2j0yxgWyt6rBYtTxvdECxS9NSk6+jUZO4hZ5i1wjc0hHoUlKCkwyKDhroO3exP4WNy7LEkUm1x0IM4bQ7FAdeQiqoAPOHvw2/IYcR7VSWzs3FU8sVIFFcMSG5v7rRT4fs9FrEEqVcVGcy9RjRHUb9H3DGTG3IHM+X08dC7Lc67E1RkRp8IrYPQsR4sZGI+83XbWWE84l6wzIlQv6yLBBJXwmT9AZWYdGHh6f780yy8kUIQUjlzxgyL2ftUoLNO98vwxabkZ3dvzpH6nqt33N9Kq9/3pcdlt2JxFPyXrlrQogxUkRyEz70XxocJhRWVA3AcgveyMRT8oxTK+2kS7nhnVjgVrZsYvpbgf8rXeiWhL7AOYAeXlqkMkSG0CahMq5imV+ro2DOwzgqvf649CMbWaPBa226ijcpyKV8qopWkFzxXYNt68SJhSwBuvzb2up7kL7PgT4tU34N7YOjcyXwuk4aQgKC3gGeCCLuiAntJBODM7N6YR3obnWSjWy4hAdahiFeHCISY85BWxLpKa59OYFF4xPsIaPlOdP4RmTlCU6U54nAkDNMA7zcun3yk8U4lBXDgUWe4VYQdXURJnMLXSG9uqgeDxuhjXGKSF334rieoAd+zTS5K7r2aZUiAj8zRsJeVBWvkMFOoeO+j5gLeXMBGWklOZMpwi6PqTrUqY+5HEbnHKbMkkvEQgtgjZQGUL8iqTHsdI9uA73ke6HITp9yxZ58wxL8Y8VGaxuEASeIsOAbw3sUYTZfQPOZAIjlhe1z6VE9hxn6sHtwV7sk7L9K9MziX+C3qa0imZkeskzGtJ7aWvFMwz4tee1i9+7xuZpRWDdxDNMTGLRnU/N7fHmwXJxXcAD/QCtdiK/5FAgvA0QoAvSVORHTka7Nsk02ITAlPw8b86
 pkHsbNrO
 UKw8vrlEl8homv9XdiA/ZlTeEDVBFwtiQz3OhMVvQsNVj+3UsIkBmVPYCFJd3R90FdoXCKuckExobtHb1DPP6z+H4BeTSGGuJLexGYT6mmsFQ6kXweDcTIwuab5OMkKU9gvCAhipxBdUZwkONITKSickF83cFrZZ8E5pT3mjhcsWMIhwgCoT21QvQ3+3pGafm9VhDRDp+Uky12VagH3sHazvf3AA6EWoANo/f+BEO2xrl1Xmlz5TaguQEwaozEIxMR1f5ZBQHu6abCUsCCmO3DgmSebtAyUgycfq64w/MV4rMCWNJE/fCxqUjS8sSDer3ydjVWbnSqN4OGfwbX61RSWyBqZ9/eKNKYRHWcuQZCUu4B+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This year, the Maintainers Summit will be held in Prague, Czech
Republic on Thursday, October 8th, 2026, just after the Linux
Plumber's Conference (October 5 -- 7th).

As in previous years, the Maintainers Summit is invite-only, where the
primary focus will be process issues around Linux Kernel Development.
It will be limited to 30 invitees and a handful of sponsored
attendees.

The Maintainers Summit depends on the development community to bring
forward topics that can benefit from discussion in that setting.  What
are the nagging development issues, pain points, or other important
decisions that are not amenable to resolution on the mailing lists?
If you have a topic in mind, please send it to ksummit@lists.linux.dev
with a subject prefix of [MAINTAINERS SUMMIT].

The attendees are jointly selected by Linus Torvlads (who has provided
us with a roughly a dozen maintainers that he would like to attend),
and the program committee, who choose from maintainers and developers
who have been the most active in the past year.

Anybody proposing a topic before July 24th will be added to the list
of potential attendees selected by the program committee; other
potential nominees can be proposed (as a self-nomination or by others)
by sending a note to the ksumimt list saying why that person's
presence would help the discussion.

For an examples of past Maintainers Summit topics, please see the
these LWN articles:

 * 2025 https://lwn.net/Articles/1049982/
 * 2024 https://lwn.net/Articles/990740/
 * 2023 https://lwn.net/Articles/951847/

The program committee this year is composed of the following people:

Christian Brauner
Jon Corbet
Greg KH
Ted Ts'o
Rafael J. Wysocki


