Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2951FAD3E6
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658B96B0005; Wed, 22 Apr 2026 21:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609A36B008A; Wed, 22 Apr 2026 21:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520D96B008C; Wed, 22 Apr 2026 21:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E24D6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:13:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6D441B7E8C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:13:29 +0000 (UTC)
X-FDA: 84688047738.12.722F163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 22C2D80005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:13:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxvJ3rFp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776906808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a3WOFOESMx+QV4oqhIOQnW22LGGFKLoylynJC8e8rOg=;
	b=1Z+bGdMekfjXiYEcFAgN0K2oTi7vKcJrDOTWLi+jR7ZmHoa2fYBdspLorxO+d0YRtOHTWv
	ccHj1ffd/zwt8Xo6xoUUFDOt5/Oxd3mGa9GtNRzwk0BV1+J1quIZWLgkzXbM7a1SJZmxyQ
	My17JIzseJROEXL+Dvi1lcGLjv0GV2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776906808; a=rsa-sha256;
	cv=none;
	b=cm+SUu9NMOKxA231aVDg8jIlG9MzTCugSWNOX5yyRUsc2R7Jlt/tVu0IPhcV6IKl6v6uZG
	ogpnLNjCZ+iDWWnstpKMUVJaDssIGYQNQORHSax5hXlsZEExo6qXtF08n43IXEuX497r7D
	/7mPkKVkkQmge//kN8cxaKqdb+pibwM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxvJ3rFp;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 218704391E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DF5C19425;
	Thu, 23 Apr 2026 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776906807;
	bh=9PlMEv0oWcsxNV7gLe9VCQFtma4kLf2XofnBhTskP5Y=;
	h=From:To:Cc:Subject:Date:From;
	b=fxvJ3rFpRZEP/uYy2ouXLhPPyRpvamrDwiryvCxHFlVTyR9GhOo6MnAhVqkMLH39X
	 JjIvph9JqkPz1CgqOj4NjJtTO/MDJLHZPGIRwx8Pyc4QB6T61t6T1SQPJk3yMtaj5u
	 GqzxoJ0GL+Dfni1BJSrzHOl/Z6z62ma0xS91taABFe9kImfNUBGZEy9o+E7WPyhkMV
	 jYt6LLMkntzrHM5RvDKn6EdoFF3Jq0s/fcwRgfIXMUsbBjY4i8fkD5EQcF3HWje/V3
	 EQ8b/4yTpuH8whviWcUH00VcgDYyS2TYXIemc085u8Nn1IGm1X1P29JMs+flwAj0eD
	 jWZa63uIUe0GQ==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-04-27
Date: Wed, 22 Apr 2026 18:13:18 -0700
Message-ID: <20260423011319.32122-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j3ug9nnokm8ste1fua7ibpk85pxht3ae
X-Rspam-User: 
X-Rspamd-Queue-Id: 22C2D80005
X-Rspamd-Server: rspam05
X-HE-Tag: 1776906807-721964
X-HE-Meta: U2FsdGVkX184xLYIRwnbn1SLQDZxklUiYI3QwFX/SuVvcGG3xdL4sT8onuERJlTWj6rnnNHx/k8f3XlDGX/wAPz5K0KxVE23SoiZdefFkrJtcOH+86xW0cyTwLhTPCVCqB9khxX4l4ed2swMDJb81A7Ev8p67AxWcw61UVhrxuj5sS6KgwgX4JOT3MLzITo3lPPer4Jfokvg0d5JgN5EPE3K2I3a9FM4zu4omd5LBr0tNT7nZ3YhSSsddrenNz4NfZfCm2pH5n1jsXnsoA/mBIbgwx4vNoP1INcjIZlFKnHmbvENtTpB+pJiAfKqtURKtb2zridho4GARSZHOsR7mWxfoUf9k0fwlEVZJL36WIEnL3Rjbnv0n05Ejr0ACf3iuDzMSDCu64V13RinwVa7xb6dGnBhx4IMvzHOIs27KLkP7tlbpf/JkcMnicCUPk1ZuDds+0q21DDPmaBmw8xZ1qxWUwrNaCsAfDAp2CAvD3pYb/SInDEYiEOdBLMTiG7SoQBbNp5HNKG6c2PkcD9rcICF5uUfuCCZNrB/WkKzer/AtSihmQJUjn+S8NCf9RPp0Fwg10g8BqOann4wnfREeKj3H9Y/pEV3ivuWXqRAsJ1pTTqBip0dTIiJa7cmt4ZV5d+rETJG5Hj2zpGNOzgUMkmlkr36EossEV1JkkF9gz1FsTeOoWcyb3brxWNcc+1CYaGahVquwSf9iAjxwUFkkJFSMZqVEDckW25pnxC07KN7feep7a1ERb6LFh1nTEL/wPZ0flkN5ohTEVEv1SbVgUoxWobr05qtc13sWxMZu4DM+yVf/L7p5B1sVR3z9T8zq8jYvpgM15Kiv64PRM+9GL/xCw4SUdPms3s8ky41vd8aDA7BoBABGLM+W1ZHVb6MALaa8nPhj2byoTAJY7sRbQEVxWygRfX+RFLYPRC2jlW3s+1ovMMuhlVgOSjkptD4Mh6UX876f5xVdJqWfDT
 UdkEVMys
 QHdTdT1pyDz3MJyx+TVxJrz8DRrvZMo0uTSrNwtR01ad3ylSe0KM08r/JLBq4kJ/7xTm6++g7nhwRqcm8eTCq2AuKqHIIaObuvSglggUkAv9BvIuxDDUaYQQSbIHpNa3RNq2od0CZPlVjn5vKa+KS8+hKVj7m9ce3PCRiq1cBidw6pTMZb/hUGNh/guRpw+A7JX7rkBvaqPQUJTQjFhDM4fBfL5FmGxf8LQt65cvlGKRoLtDVxY/XY6o2L5LPCM+2xI3hUIxtE5QgeEBL3tb7f6Dv4A1prFXyLFsX6l7ZDUQr7w6U5Wqgfk5COw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
(https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
for the week of 2026-04-27.

As usual, we have two time slots for meetings in the week.

Next time slots including six virtual-only ones are as below.

2026-04-27 (Mon) 18:00 PT (not yet reserved)
2026-04-29 (Wed) 09:30 PT (not yet reserved)
2026-05-11 (Mon) 18:00 PT (not yet reserved)
2026-05-13 (Wed) 09:30 PT (not yet reserved)
2026-05-25 (Mon) 18:00 PT (not yet reserved)
2026-05-27 (Wed) 09:30 PT (not yet reserved)

Please reach out to me (sj@kernel.org or whatever) to reserve the
not-yet-reserved time slots for your topics.  The reservation is made in a
First-Come First-Served way, and I will send a Google Meet link to
reservation-confirmed attendees.

Please note that other time slots are also available on demands.

Shared Calendar
---------------

You can get the schedule via this shared Google Calendar:
https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t

You can also get the past and upcoming schedules via
https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing


Thanks,
SJ

