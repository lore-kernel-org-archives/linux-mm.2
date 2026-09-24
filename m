Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8D1C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02306B009D; Thu, 24 Sep 2026 04:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BE76B009E; Thu, 24 Sep 2026 04:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1316B009F; Thu, 24 Sep 2026 04:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF25F6B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:43:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BEB616026A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:43:17 +0000 (UTC)
X-FDA: 85248016434.01.44DBAE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B22DA180006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:43:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCTnzgxu;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMq8QR5h18vm/WWPf2tv3W8LVB5hO9oSgXVqugErPLI=;
	b=6PFPPvfqG5oIEfqwOK1nV6azgJxkk5flW0sphHhEgWUZhmRq1mBD/gZMMqLj36ssjA3JeN
	LsraMkk+VPdnoBTlDRWGQw/VmCYAItwj+4SU1CS+SiYUUlSvVINVVplUj8DwbpoWQYqKRV
	j9mc2badeFHkZCy33NLTQD81K3yFSd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239395;
	b=46j/b0rnBrwOcKYnFwm/dUiRrbvA+9sPKdO2N7eO6jesPRtTuozwuAMP0NxNw9cX1BIZPD
	W6kHtdjf3c612b1NqQhM/SpDvEvZoCIR5KJARApSpIYJXW6w64xC6wtl1Nkg5cUFEwHCta
	J9RIC3GhAgJ6ECEmL+ZzISifeE8WNXI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCTnzgxu;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F124843B19
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED701F000FF;
	Thu, 24 Sep 2026 08:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790239394;
	bh=hMq8QR5h18vm/WWPf2tv3W8LVB5hO9oSgXVqugErPLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCTnzgxunf1khUtNUynT7epEs5UcIa8xdYGplAoe/vycsrThaCYfYntIdqXoFEAKW
	 lBDIjgIe8NVsrE7Yu2MwTZbFZW+Ho97F+HBTQb5DoVEcIaSIUrLM1syQsy7zx33yQq
	 lRyRTuxbZFUgf5YyiN330R3QtZPXh1W7skajl6IVT57BMhSvnbWqcF7LIvjJ/UlME2
	 h1dcg9EcFXe32LxIKbOulNNJkPjkufRH2jXN9ztEUJ04Xr+O8ArD/5NAWxMko3Y3wm
	 t8P7I59BbE3znMwZIlfgAm2pZMhz0lA1VQ630PKdoaGiWqndt2y0Ma4Jo0iYdqZUU7
	 CrnmRENEuCIDw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: DAMON Beer/Coffee/Tea chat reminder for the week of 2026-09-28
Date: Thu, 24 Sep 2026 01:43:11 -0700
Message-ID: <20260924084312.3773-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924083912.3464-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: whusomsdjq5zsqf3zw5tof5j6xu4zsmm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B22DA180006
X-HE-Tag: 1790239395-683362
X-HE-Meta: U2FsdGVkX19uQjMlV462/HYDJoZJTJo4IrgrgGBm2TUTmlz9VxYnSZlQNS0rcwoInkPGXog8szil0p4qw0nHHhlEub2p6wiJJy3IcUsd4YHhh5sPQ8nVGuEmhU1IEZxbxP9i71LHoG5XG5UT95pEwZId1B/6qoxgqsOpM28/AN2y8jsB2yeE/YfY25EWIRWtlDoXIEkEcWIgTt1vLzoBNOl6kaTMqnSDyCo3ntH2EAClGUg8Up4oCgrS643DmrX0g1WHs3SwYtfVolH2L0XRoT1ThEv0VYDhbWSZRmOshqumcQX3W56rKltBI61RxWhFIygu0hQI59LN0qi4KH6/wKf28+9CFMNvAUgO0EM0p1RIc+fDJYSGugDHOlJ9vbCiQmXA3x3rUepfUXvIB2HFk8oFlcFWqiyrdHMWP9fenv9Ncl4fu2poi1q5+GQ0rE6LeyrrbaP9jEp+1kSei9CjhNSuY8hYKe3DZpv6gLTHg2EWOFKaaiTxIlLM+Wy1HM1yZEdqfWMXMUffaD2DwzAsvERW6FN+dlJcJgBVolI3JlhFVzzHuREN29FF4SpFLB6KWwVthdJwmhibeX5WT+tBsw2IgeBCfHrAw+nBSQVruT8tn1TkHdN3c22V+/z+4hkGlLslLL89LWIwRWpRl0dEuVNY7NJoKvfACHK3FrsQHI2hCJyWRx4VrE5blWz9POHwWePPQSzrWgpReGNbcGh+m2cGRuudTFOCjuHgf5IPl5gtK1hYFerH6ORRNd5wE5GQMoMF3ohq6VumFyqwZdSYUac7S1M7JUNYbTby/QKT1KbMEecAwrnUH1ZWHcqRIkt24O5rWdXwP29y5bAbI+OWXUOBpKEcr400ucO/k9jnmJ/+8dSF90CmUgMLoJw0cyImax6VjqybOPdWJMoNNOj2UewOAuy/me2Y4wJSP8J81Q0z9IiQUAvebk76RT1s8QzmfrcdLhRfpstE9nJBLGr
 vxqS/bBJ
 s0RoyfRtRRy2IljzIWHFPvnyntllQ4rQ3lQp9GOZiNCt5Bm3W7aK959uu9+Ex3T+qvZP54Ps7xVqbIS3NsJSJ4YTMEpJjxr03rjBMp7HzPY4/h8KJSUe4ppS3At4Aj1xlaNRmGoz3RIM/utKNdszv5/eircOdlcjhUyKuhQwTKMZv5v1K/cAXXvCD/71icQvdZMNtj7Atog8aqxZmniPdhOLP+FW+2XeNZihqjxUuv60cxyX3KAaOV5PXy3inVz4KM5Ah1EjacghjclsPadN30N7qoVDQ99vGJ7rlM+EeuhoxrpacPZH5YQs4TV8l+u5baW5mk8K2fYhgqh7SmK7tuKMZwwczbKRvYIudEnk8rEEGkg+VJ/k3PRwaJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 01:39:11 -0700 SJ Park <sj@kernel.org> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Hello,
> 
> 
> This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
> (https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
> for the week of 2026-09-28.
> 
> As usual, we have two time slots for meetings in the week.  The slot for
> Tuesday is already reserved, though.  I will also be in Europe in the week of
> 2026-09-28.  Changing the time to CEST.  Next six time slots are as below.

Sorry, forgot updating above paragraph.  Two time slots for the next week are
available.  And we will use Europe time zone for the slots.


Thanks,
SJ

> 
> 2026-09-28 (Mon) 18:00 CEST (not yet reserved)
> 2026-09-29 (Tue) 09:30 CEST (not yet reserved)
> 2026-10-12 (Mon) 18:00 PT (not yet reserved)
> 2026-10-13 (Tue) 09:30 PT (not yet reserved)
> 2026-10-26 (Mon) 18:00 PT (not yet reserved)
> 2026-10-27 (Tue) 09:30 PT (not yet reserved)
> 
> Please reach out to me (sj@kernel.org or whatever) to reserve the
> not-yet-reserved time slots for your topics.  The reservation is made in a
> First-Come First-Served way, and I will send a Google Meet link to
> reservation-confirmed attendees.
> 
> Please note that other time slots are also available on demands.
> 
> Shared Calendar
> ---------------
> 
> You can get the schedule via this shared Google Calendar:
> https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t
> 
> 
> Thanks,
> SJ

Sent using hkml (https://github.com/sjp38/hackermail)

