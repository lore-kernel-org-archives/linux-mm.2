Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9300FCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACFB6B008A; Thu, 15 Oct 2026 08:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D576B008C; Thu, 15 Oct 2026 08:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673E76B0092; Thu, 15 Oct 2026 08:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4203B6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:19:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC04F1609E1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:19:12 +0000 (UTC)
X-FDA: 85324765344.10.ECADC7C
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 02563C000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:19:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VG+PLl+w;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of zhujia.zj@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=zhujia.zj@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792066751;
	b=0oppt48hP2F1fAE/ut5uAVF+sseaZPKM5btp0dZPEWYxFaNF1MpQsO6NcQXW57VJGdVYwG
	ROGw9fsP44gGVo+oxP5To74yb37XqC26eLxqT4OtIIqQfoH6PYG6TZvuTXy354ieFDdYxQ
	8O3QSYOzTqv3d/7dmmPPl9mL2/yl1xw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VG+PLl+w;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of zhujia.zj@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=zhujia.zj@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792066751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pR+ZsPE/BAelWupFuHMCruhA+1GjAPIp291axGzUwWA=;
	b=SK+25KwJlMjF+iql7/KSgoUUJpqv50cnREU5tj0HmrWNa+I2vNBTzRYFXNoZ2HnRyl5v0z
	15OE/eX1upTGHOJk9/AcNExLi95bCqhygQvigcnkSv8QpDJu51TkmPLGGucp1XN13koLhR
	XZU04SyrO/vI8twyhSZXgc5br9hV4U8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792066744; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=pR+ZsPE/BAelWupFuHMCruhA+1GjAPIp291axGzUwWA=;
 b=VG+PLl+wPZaDDPMYPq6GkxYmKO4rNSzfOLsHrao2RDXa+4+k53dLu2UYnf9gyp2fTK2QdU
 Tn64X4BBxrbYniN1GhgIduuJYDU9d4njm6H2AvmGnU0XuOfTbqNs2Pt/GSVq6IrWyxWyXm
 CI+MkxfWi6BlQljNAkSrPqPjWK+HHSVA27xbgWXPfhuuOxykuXQsKOHN1LNqUfpNdlsCsQ
 VksMoK0AMe75t+QYbjp3E2/SrxjSUUzUeLbao/JRR4jm78EPARLKbXy3PWQ8+BITBBssta
 YMeZXmf8Esd8d2jIM0t3RkM8aryIP93oQk9NqS8Kkg2jfwd7/hlGVUR/G2Z4rw==
To: "Jan Kara" <jack@suse.cz>
From: "Jia Zhu" <zhujia.zj@bytedance.com>
X-Lms-Return-Path: <lba+26ad0c4b6+e3dc6e+kvack.org+zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: "Jia Zhu" <zhujia.zj@bytedance.com>, <amir73il@gmail.com>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Shakeel Butt" <shakeel.butt@linux.dev>
Content-Transfer-Encoding: 7bit
Message-Id: <20261015121850.1448810-1-zhujia.zj@bytedance.com>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
Mime-Version: 1.0
References: <cover.1791452174.git.zhujia.zj@bytedance.com> <mzx4rhr7zqhza6qh7zefytrmcx547nh2bvopwtdnannhnjl7md@sm2kdibrorwb>
In-Reply-To: <mzx4rhr7zqhza6qh7zefytrmcx547nh2bvopwtdnannhnjl7md@sm2kdibrorwb>
X-Mailer: git-send-email 2.20.1
Subject: Re: [PATCH v2 0/2] fsnotify: drop SRCU across inotify event delivery
Date: Thu, 15 Oct 2026 20:18:50 +0800
X-Stat-Signature: 9sfh39wf5m1ftegptastkppduk4a3ryu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02563C000A
X-HE-Tag: 1792066748-189920
X-HE-Meta: U2FsdGVkX19UnnPkvMuTsPsDDYZBOYxb/Y0pYeV0xBXxe5siLNL2nBRMxj87j1fyw8VtiPx5SmC6QJ4cy3eIbN3oeE5036iwKrmauCld3rz6mrXl+zzNn6kARc0/k6bqjQM3TysAS9xhqVVcOmVSJ9WQoEsaecibtF/f0giTOhKuc3EsfT6CbFiCeDP4z7nRcGY57tJZeqYwW4Bf6Pb6l5BIJDELa4IzkDUVbOnqjtiRRtt7SXokgOlNsqjMj4vv0VidOVEDXa+o76TnES6Tll3asxkgQekYD0k+ceh7o6wgL29dMWKoWrzURnTWE6qVH8SvLtRjDT+XQ4FW7pvneNoSi6g1W0e5gCPmziWg8v3mT/kZ+CyLgo86ur5/NImURyNkQjrhw0HPMJHDxZBCmLH1lQQ0kPTx4dPyczwFyRhwQsbemE0MroUuvDONHD4pIsIrOCg2AkMwIxkWc3lgLhziKsM4DD2dIxutY622nhoHUncgT/s1IucwtEMXpgYIBbzIZ3Wv6v/kInTJmk5kYhJVakw3g3UYQl1u2k44IpZlTgEJdlfPj7MHI8qeb8Z4ssVaIKQwRCd2GVqkP9g8bQKypR7URI9+ywDHmKKQkwURJ7A9t82QDB90w9MbJQU2JRby2kHAQk3VNzN+l+cR3HZ54Xz/Cj1PzBY2vJugU1d0Ucecx7e+4qJNt8Yz6ve2m3n78j1PZPuav7UPkZkAoWNngD2cfB5KEEz3CjbKbXgUeboUSq4Dp3e2OkYM8688E1kiXTwCiL7yqR3olj7BXWbuRuyiwoUZ3erf7pkFrgzK+raM3K0mOkouikMHdIdOsBI3yNRzZLIdLdhigg6EkhDPcCb6DzJZ04Z7iKsff9OLcSu0etYVOSgPjimhOTm/VijmrSu4CGRVzoWyd6+8OfyvLs498wFb5sk0ejtfMDYSqczO9pPaGKXOj0CLy9TU24w2Wm2AVNTp5Bx9R4K
 VtE+fic8
 3sNQTKzTftJ6WOcov63/92i254G+FgsBtLOLbeCOysKR1/TbIDYGt/pO3QkugzS45v0K8sZRWU9HSpEFD63uwF8jUzrYyx5Q2fC7SVCxdKlAi0qQHT/nAwsTgFFID4U0bsjdV6LzC3KgzEu95Uff5oNlAH55AveqfR3BfyToWhhPIYPF5EkWpPIOgjF+4dnBFi0WY/xi3p+BcXCcp+r3S1EOewViujjqVDmAMgGV2GEaRVlY8ePC5RT9p1KmCEdAVY0nx6mvdfxNI4CY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jan,

Agreed, addressing this in MM would solve the problem more generally.
I'm looking forward to Shakeel's work on this. Thanks for the review!

Thanks,
Jia

