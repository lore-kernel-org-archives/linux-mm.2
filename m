Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC7ECF64A3
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE686B002D; Wed, 19 Nov 2025 21:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E196B0088; Wed, 19 Nov 2025 21:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B846B0089; Wed, 19 Nov 2025 21:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39E1B6B002D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:06:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BE7B1606ED
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:06:11 +0000 (UTC)
X-FDA: 84129345342.08.FB254FD
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51F5D18000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:06:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763604370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5907c6E2y1EOsI0jU9wGh1DuToxcw49+XUAvUEh/T9Y=;
	b=p6VIselCImzE6j+yqekn5Z1N0G69/TdBcjRKYhR6OJUPyQd2Gv4IK7m2KO7yxJmU2YejF/
	u8TIAlPx2YKTNVzdlyD2D54EDvQ8xHTOJFq5xLSfu3fzJ2VH0eINW/lj2CjUHaUrxcDNgF
	FyZn4ABxWOSYQFkvuLZPyamvknlXy8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763604370; a=rsa-sha256;
	cv=none;
	b=8HdV8LIy34kr/nHVg3oR3XQAuascioE4/xsrCWcMZgZkglFhbwO0Z9AdnQbhHgUmjfvTUs
	VLm0vh+rFjnwZ35uOea//er4H0J+9i6YEmBohAgO2vEbRbiN4DQIBPsCZDofc/d9cmX0k1
	tvd/ffRYFor9MJZLVSyPTZsuD2eF33M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Nov 2025 11:06:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 20 Nov 2025 11:06:03 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
Message-ID: <aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330>
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
X-Stat-Signature: sc9d8u6kh7yf3mr14zgxc3kie46o9qh7
X-Rspam-User: 
X-Rspamd-Queue-Id: 51F5D18000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763604367-138216
X-HE-Meta: U2FsdGVkX1+wh/6fEdRTChxPMMIM2x2L/9TKAH1eFYv5RrUFxpeHWIvAO8vdOIpmvkhvpt/EzrIUgCvN4CaoC5BLRoNUIuCnUOFNgt93Q3jpP8QxOLJwK76LLzbU7RjF5r8Gf7CLNydJL0Sa8vO1azWfvJK/qT3lZ1csaJe/5USDlnMG58SMRizGHGh8Ca6poS5czcWK1L2+VoZF1ivhaAa9PEiztCoElz/2qHhWJtQjatr2Ife3e7vuy81gvPewkf+NhA9qS/L2s8Qj8ROTQ4TzvSvDvV3waY7+ZnF/WFEHvFHsPhwqju3UQfRINAbTh4ApBxmCxFwr4PbMkS8mQuOLJ/RAqEg+lWD87POfiUcd8LBDgbx5KVRaC2MFNBmcz1c/VFA4q7CD51JnGXBvFhdT7O4ypuwTwKu+h0mZkxV1gSBMO02aq+vfptPB8yWPdAVqvYyQQ8P/eTD1Lp0STZYn2Te3cJORABI9rO6gffoh6umU+4ZGhRJVaa+FxUo8AVSXPCjjdiDc+2tw+d3P1h7C4bzvoIsnF34Gf2RD9cFH2TMiS+AFt9rw3oBXGNyu71zyFOqNg9xPzNuH7tbIc1SAlz+Ou76ygkoie5ovFlW5xIzn5clN8+urdpCHC9/QL1F0tvzj0GgWfGRzKTDpqfLOpZ+RJocDVnrq0OipyCYV0bKW1Ij4gVa9DgNYF0gxOK6Up2Wthz0+HBJLPBHNRmbgmSkHl8w9Va+Si36E+htz4HNxOuJ7kMQPxzYEVE3/ELWQALgFezHHudAqEla20VLEhqnr+nD1Yt6T+Svyb4VISHM7gkbVGkMStuiHGiUPtT0hx2EcXRJ8jM9Amtggk8691GxfrLz5wLNc9qtaS0mpo6Q+yjSfAq5DxOWq/4o2CgkCr5p81x5cONwTHfQt36Ld2RelL7OH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've investigated this further and noticed something about swap_sync_discard.
During iteration, it doesn't perform an empty check on swap devices. As a
result, if the iteration exits because the next device is full
(deleted by plist at this time), the
operation(swap I/O) fails even when other available swap devices remain. 

Should this be addressed?

Best Regards,
Youngjun Park

