Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68723C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497EF6B009E; Wed,  2 Sep 2026 02:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421826B009F; Wed,  2 Sep 2026 02:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3107B6B00A0; Wed,  2 Sep 2026 02:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05B1F6B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:16:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 821601402F3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:16:37 +0000 (UTC)
X-FDA: 85167813234.13.C199554
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E5F5E80006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:16:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1e89WsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjODJWm4HQ0zWK/uBNhYkH4uHbacHZCWiA6PuoaG+UM=;
	b=UuFkK2HMekCKpL8v9ci/NG4/6HyCCNQ2T170ybhNFAG3AGwjLwfAetcLCQx2HcNjpQijOw
	nEqFomAqLW72OJPx92IKK9yA3LlpEynUd+Ih/R/rSitF4dzePlA1tOiYI950uqaQqEODe+
	YK608RzYzypHWpKpCOG7WNQ86CL1SM8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1e89WsA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329795;
	b=XRQEnQ+KQxWPrw4aenWTmAk71VOsUo81gyoWrMV7QMuNysCX35JH9orcZ8ca6AbbmfsJIi
	Dhha8s2ftx/oQs2xrdVKgha6M2vc1V2fRWs7JtJRHyzgS1gUMyLBoooK8S8y4JGF9TcUTW
	dDWAkc7VX1jZJJGoROFWDCjxhZfDa+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65EA560229;
	Wed,  2 Sep 2026 06:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618FA1F000E9;
	Wed,  2 Sep 2026 06:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329795;
	bh=BjODJWm4HQ0zWK/uBNhYkH4uHbacHZCWiA6PuoaG+UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1e89WsAYo18WECLuDiEp5fWTcq0n+WFFOj1SD4qSWJT//FyO73JSKFuM+tyXMV85
	 muzG6bod7qNplXg8aCpt/J5CztbBQe5DT9Ax1eDA58i2Q20sP5XqeAXpZnapWzSdSa
	 6gBR4bomJzq7h9XE8Vx/E+szEW+iKc3UGlTGsGJcCu7CT6nwfXJj1PxgsPpXqKbtS2
	 +3c2hlxMIUKKHn4hYVmtLFubOD+Nqb1xBxuy823jcUR1AlN5mKZK69NyQtlgPdf0vy
	 NSGiHOcstE2jXkL0sEIoqiwTI+7vrJEDWccdu6OOjfTEeXKiYuWE7kWzZoPCqHQdga
	 9LgVPRptuCVhA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/12] mm/damon: cleanup code, add test cases, and update guidances in docs
Date: Tue,  1 Sep 2026 23:16:26 -0700
Message-ID: <20260902061627.104566-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nanda6saqpw84egpmnjtho36bofmbzwb
X-Rspamd-Queue-Id: E5F5E80006
X-HE-Tag: 1788329795-461427
X-HE-Meta: U2FsdGVkX1+oC46dDocEp+RU8OjL/4t8iYElE3djX/tStKVHqQfAGKT3E7PM9WMBHvDkliI/2J3cJZAma6K2Kv3P8pNrpxGw+OaumTydP9VHwU8N0Drqpwi7EWpjr9Sd/xLDXyYn+Px/A4jwKHVksQHH0xmaX4QZD6X2uKro1/NzXv27baCctIDPbAbgDCV0DMGKHiMHeMh/Mb+4hWDvRyD7bU0IRcs2018m777cp7jalk81YcycNCAZCinOB4w0r4AYk7RgxgiuK5904aPGYZcns+BH+HQ/643MCFETO90Bij9rnJ+oXp3slImk6d3pzMEdWsFiHSo4t5uhR+CGrNGGpG9JzngLRbtvKV6RAKgF/szbaBpsevkaWbKTlOFEfwRLhlFFqKZc900u0y5AL0i3mGwKUuE4Ebob94NxGNKprw9Sd1IwinJYv4hmj13jQ9kQlfpyuRKPTn6Nsmiik8nY6QE15e2v6xcoBxIu6YamK126Ac2kLZ8PwpNnUgDBRLVG5hpi6DCUfwzNqaDa966lXnnsD31vx+A25qnvegULF1O8YaHWj04ua5iSaVSPfJKyasGJvOb5yPBlbBfJLXsH5scAyojHsq/Bo9OcT3jWVMLEwcJ0WTBPlfej7ShpF9aaeKROscORkE/HVmXmedHMnlAGk4ygYBNCNbHeDfwsIhw8gisf9eohuMatG2jth+D3Pv1TNtLdCaQemJEApnzmwlTlWG9G2/XuPi1eKySL2RRFa7fHvYnKZgri1phrOuq79agU2FrCdVnbEHuo8qioU243o+8mqOuRiQWD3aMNEqpefyHyJegyXVp1mEERFbpMMXEx7z0HNBa8DFzTrqV9VxMP5vwBuWNi4gjXEZmf3bKqGym2p45WDfUGOWmgCNQvF40wqypdJatqqeh8TBjQCz/0kRoeZesRmaTJF2VysKUXo2jYWTBzhvBLLLEDHJsb88TJh0gZXQFRiqU
 lNWl/Hmi
 Xx93l5QrfKRSAh6Z9maJvXU0kJSXBx7yDUqmTy6LQaD+kdHfHV7PJ1J4JUkLTq5Rzc4KenwdEG6WygoHkGvca0SpSigUtC2Pa752RhpwJ5Bys40ayUq3eRTaORhDElf2+LO95zZSQGye+2oThotUAScI+zQtKEBIz4X3NAUSmyNZqF66Dx6p7bYEsOTfJs2V9vHKkK9Hg6Qrp8lGGuRihGfEIFpKH12Km+QkARL67ohfZNt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:33 -0700 SJ Park <sj@kernel.org> wrote:

> Misc cleanup, improvements and updates of code, test, and documents.

Sashiko found one better-to-do change for patch 2.  Since it is quite trivial
in my opinion, I asked Andrew to pick a fixup patch as a reply to the patch 2.
Andrew, please feel free to let me know if you prefer reposting.

Sashiko sent findings to damon@ mailing list [1], and I replied to all the
comments having some findings.  Please read those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

