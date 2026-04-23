Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54819FAD408
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AD06B0005; Thu, 23 Apr 2026 00:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAD36B008A; Thu, 23 Apr 2026 00:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8279C6B008C; Thu, 23 Apr 2026 00:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70DA96B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:39:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B8228B97E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:39:00 +0000 (UTC)
X-FDA: 84688565640.28.79E17E9
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf26.hostedemail.com (Postfix) with ESMTP id B4C64140008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:38:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776919138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+o1+DnYAkm5VhDWTq8bVDXLn07FCCbnEnQVj0mYPkk=;
	b=0d5ZtBfdMUgrZeeWM/Znq/nqAvP8uiH7g5j+Y0JHBFgFJ/9b+6tKgTO8GXYsrm7mRItBvB
	f5Y3Zeae7o5DcNUn1PbJ9V4Kpe4zmIKGtDlaSQDFgrDlCiWsm+GqkSN48akHR2ZCp3eT28
	LrnbPAuFOlZpILvbEtR9ScNcs+tN1/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776919138; a=rsa-sha256;
	cv=none;
	b=fL44Y/b9oHuTLnFKSl3TN4AhEqAgalImLb1PqcIhWbjC9kcPH6G/Xx9MR95920weju6W8a
	G11sxomGZj7DUbu/RCqbI/r0bGtTsMbCrEQ/fkSj4Yre2dE/UWsCTvsxhCJZ85heo/+Z9n
	4FmEDiCz8ShrKi2W4dH/TFs1MIjM3X4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 23 Apr 2026 13:38:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Apr 2026 13:38:53 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v6 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <aemiXROn4MPN5H9P@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-5-youngjun.park@lge.com>
X-Stat-Signature: u5c574hc97pwht68ad3oo8ztbnbrxqks
X-Rspam-User: 
X-Rspamd-Queue-Id: B4C64140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776919137-966397
X-HE-Meta: U2FsdGVkX1+nhXwyJWn8uBJG38adFSB3dqKpMClzqg8c+a4M3jod9vN0bnwoTy45vPstV+iT4fl3aqLGKwV7YvMw0ooo2qb0kW5oqjKM/s98KIHfPzgdFh/COCPYvHl0g2RRj7EidHu7oweznKImzjX77m/RnDaV6utUgiqV9hiDxjDGgYXSlP8pbjTqN/Qi56jWAsDwuWgenxFW9Dly5j7nwJCLkvjRLGS24F2jkAHR8N4Yil5QmGRlB3Op2gRJGnIF7b0vZVeFsq2vr/wOD9tBPdKpyAprlaKwVOZnNFsWMRpqE5EtaM4szlNd3ZY8/MMLNfC7eR6qvwzjQUvQrpMqR7fcl0wqrsQ7V3MucYvCoJNOwWUl3hn+38zJkrx40J6yG2oXW/K1G/FKUOkJsCNKyCSNhKUwnH99bH0EbRxMc6xa+dr5J7vWOVRHa2KDbo8D2Pq628BQ5+F49Sajp1Aandfv69sFYafSs095OXZBT/EATC01YvaX6bSbnlOU8INdIQ0M0JPlb2hOzSkNn1gktCSwrpQfM9aBSPnPxCcF7zTCi1NgKR/oH01qvw+O8Z85N/UOiYVhEg5njgjGRSmpmFHs6PP/3lOYC4nBTKn+xhZ/vEYMAIYi/pkVtk/VuRCMKmyzzoO/OnbhapMhpoLOoqHyZ/lfhyCBVECh4gNe1NXonWlMdWHD6HMEM9Ro5fP/RvtEiu/F8wT86bXcINO/Uv5nZ8xXDfvVE1eFTtCD6l3eXoJt7nlUD0N73YFUsTeZvbMxcLoTXOWV0xX9871+KZt6DFeXaYoV1wqy5wkEuIfs/A2ZZiZA89ibEtQDYfLwI3ZaRJKutxAXC7kh8f7yogmGVPY23Lz6E+pfehsgXAA8XkIl6ku5FhDmQ8f3YBKRSwxlNrHbdAt7clPCzPMRuMaTEKDfLjpyCtjjeCDSMempGTbJuIHNKxmqsn5Ppcs6JjnS+RusSg2ERzm
 pJZyZs3T
 FjrUsT/VtAKfMbJ0rqrK1+d5xq+zPyHWk0HOgvXkc0tnLuK/ey3ILqt8ODjBDqW+MbVE8i5sJyCfcokyXwS6+Vt6tsZXk9ui9dKLdoQYmxBhZoMBaZ8kU9ONXDivj5OsTVlZLKwU9SPXAjLPOY0B9Bby6qTa2ZSjEhjhMhATODIBnS3IX544iqKwXLmnLnK0og7PQkDd+7hBVi/DqJyDzVBm6/nZZ9Ypqni/PjCfzxAi+H8smuFy+GLt7bs2pcmjfIci3VZ2a4H497uGmqJPxfIW5CA2LymdNR5eRJ9wtdM9xRgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:53:23PM +0900, Youngjun Park wrote:

Another low impact review from sashiko
https://sashiko.dev/#/patchset/20260421055323.940344-1-youngjun.park@lge.com?part=4

Proper concern, 
But .. it is also not needed to modify. just small optimization of code flow.
If somebody thinks differently, happy to apply it. :)

Best regards,
Youngjun Park

