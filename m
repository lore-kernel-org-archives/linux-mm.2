Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD32C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6120F8E0006; Tue,  5 Aug 2025 10:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2E58E0001; Tue,  5 Aug 2025 10:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8C88E0006; Tue,  5 Aug 2025 10:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39E1A8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:44:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCF088025D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:44:03 +0000 (UTC)
X-FDA: 83742973566.02.25D01C0
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D626180004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:44:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="gpbfF/nK";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754405042; a=rsa-sha256;
	cv=none;
	b=nRyDz5V/dOGFpr9KCTiE6l9yxFBh6vQRTvjUYd0Xb9L5KSzUOAImSCyd+vRJt2fjGB0QDW
	R3Wa8YhFAbOz3TSNhvv61TsRgfsgzj8i/MolBJ8r5t5mqOqXy1bJJU59lrCSSfyuCVgcxs
	lNhh7+wf1/RUUdkAYqgZABabXOnoKc8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="gpbfF/nK";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf24.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754405042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TB3k5YKrolHS/wGUjD2XWMujqEOA7pI1XujVrZoQ09I=;
	b=EH3eO8SSdFH7CC/ZUgohMXBy3YljOrPOGkKOtFrPBHyGa04bvXnMTiM8puyxWOG84P7kSO
	Rcp25YXm0zI9YR39c9L/nwTmdO0RHKKsPN0cSHxXR3DgMKwwavcSwEHJTsZQYtKW4qJm42
	/BYQ9/HtyNo0Nd/uxxHh/P6yMUZhXx4=
Received: from trampoline.thunk.org (pool-173-48-114-137.bstnma.fios.verizon.net [173.48.114.137])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 575EhwY6023281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 5 Aug 2025 10:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1754405040; bh=TB3k5YKrolHS/wGUjD2XWMujqEOA7pI1XujVrZoQ09I=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=gpbfF/nK3AA4Y1mnGA0hs/TfMSdbkijSUdIs273Q6zm9/psDK+utT8OHPH+gl46KP
	 436vfh7zQOAzczzy5UfO8xFYFWy12q7HCXbWf5ZBOx8k+bDBlJXmb+yBV1k39yiWCS
	 x7exXNqYDYucIGA3Ks6QpKCBjrqerdRty2vSCJ31kMpML94GdTisBXAxsvG5FkoWAP
	 RIwfJ4syMf5yurVaLy8MKiNQQPQpF61rB/roGZvQYChjci/tSHFcqGTeCcIqvxP/mL
	 2ibjIT2kfSg/BMwgBCzZepQB9YA88kj0iIQhbXEvpZuOh/leO+dGsa5vxt9rQWo/7w
	 J74RKGlyqQoNg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id DEFF72E00D6; Tue, 05 Aug 2025 10:43:57 -0400 (EDT)
Date: Tue, 5 Aug 2025 10:43:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, ksummit@lists.linux.dev
Subject: Maintainers Summit 2025 Call for Topics
Message-ID: <20250805144357.GA762104@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 1D626180004
X-Stat-Signature: 8nigtwbwqxo9oz5ztenzmwwkx6uf1d1f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754405041-46367
X-HE-Meta: U2FsdGVkX1/bCvi5s5+vC6USiml5c+gyZgSTwdeOBVcSYQQ0AdlYWVXNKADboWJ75qkPWpdSG4XLiPQExHbQsPuIm9k4X2TatKEPYKcQLDOEMz4buj+CUZ9ipZGjwO6Apzm5Ecx/+UMyea+l7C7WVpo0mfp7ceTvpkRyRPhzQJQUfcOI21PsTc2usWlxrLGTEtmBWj6BU70EeYkqZbrTS0/KKJ10VTSmmt8qPKsJhFNGVEf5glmxPznpUDqLr8Tt8eqJXifsYCdQ59Ol7RIR9i+9L0HWokydDw69QuZ7ehChKm3+wHXNM3TzIRXwpvWQSx2d6uZKXCdDUDAodv7jIcB3POEb2/cRSbT6OpIiD3BOex+G/srE0NN7VrwJn05QHC5Q1EWYpbVItZI0D8deNz36jPp6zDoy/bo1Ad7fT8HmFIBBSgcAAxVgYmNGP2UmY7Czk0+k+ND3Q8iHN9oN/ZvFHKYJM18CQIDxRA7AiWfQ6Dp8r3uLsSdcjjtSu/pD70O4e7wH6CelvmzwmAFq3wDZx+jrsgJMpoGGz9E45OWo9XUjxdy6XiczQjrBXqEoJY0bOsXgfnaKJN6MNIWi51f6B3JJW0/mG8tvAAS5JBIDXpFrUoY40AGmfy7JwyK/IV8FCnLg+MTaF8lM8YfLbX3/kKMeVOzYyYUoLjC5SDTQgx/0gzzAMNO/9Q+kSUzJRu+XR5COqjN8tvo5M7y0ZBTexuyHrqHQjIh7kq7iaPsqYo+qcIHxjnyCzIQndVhbbFXUU6laSzKm1wzZCtF0foO4VVhCEaNZz8HXbcBslYM9BDwjzFskox8RaaJjDDMjnj01ESsXutm+X9vdgJJTZmSx32bdT2oVtT2jhBXs+MXUGiOu+QS3xUpSbqz2cM/bEgyWWdg+wiCmROzp4RC+yPjct92f69n5G+P9MbPtkKpo48phfj0C0pv22ZlrYq8SsmICXIHi6Mz2Ju1uLKU
 xe1gDKZi
 7cej2352zj44bVjclHWbzbK64Xx8/Otyqzavg5ZDOWl/gEAMIPIW+GyU3wVDpUwTARfX6VGXh3td4/XYg3pfmiQYcSKeAukzC8ht/bIvoRCiqLTTkpJIzFRm/nQp8lA8C7Ev3s9h8Rd4RyYwXosDNry47rvVe+VeBGcFN/I0O2ZE/3bHa0seIR1aHKvUKFL6kKDAVXe0UezhmNeB4VafFS2uCskWXVcGC8ZrSbBdMTc/BuQv4806dFtWAbg+4g8Xd7WsjqVZDi50KJmgVnmzIH9H+BAR5C3Q1gPxkWxC1fw6/oK1c+r1D8xgiiQ8A/PGrrX/H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000028, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This year, the Maintainers Summit will be held in Tokyo, Japan on
Wednesday, December 10th, 2025, just before the Linux Plumber's Conference
(December 11 -- 13th).

As in previous years, the Maintainers Summit is invite-only, where the
primary focus will be process issues around Linux Kernel Development.
It will be limited to 30 invitees and a handful of sponsored
attendees.

Linus has generated a list of people for the program committee to
consider.  People who suggest topics that should be discussed at the
Maintainers Summit will also be added to the list for consideration.
To make topic suggestions for the Maintainers Summit, please send
e-mail to ksummit@lists.linux.dev with a subject prefix of
[MAINTAINERS SUMMIT].  Late submissions will be considered, but people
submit submissions before September 10th will be considered for
receiving an invite.  Invitations may be issued after that date, but
only on a space-availale basis.

For an examples of past Maintainers Summit topics, please see the
these LWN articles:

 * 2025 https://lwn.net/Articles/990740/
 * 2024 https://lwn.net/Articles/951847/
 * 2022 https://lwn.net/Articles/908320/


Related to the Maintainer's Summit, the Kernel Summit is organized as
a track which is run in parallel with the other tracks at the Linux
Plumbers Conference (LPC), and is open to all registered attendees of
LPC.  The goal of the Kernel Summit track will be to provide a forum
to discuss specific technical issues that would be easier to resolve
in person than over e-mail.  The program committee will also consider
"information sharing" topics if they are clearly of interest to the
wider development community (i.e., advanced training in topics that
would be useful to kernel developers).

To suggest a topic for the Kernel Summit, please do two things. by
September 10th, 2025. First, please send e-mail with a subject prefix of
[TECH TOPIC] to ksummit@lists.linux.dev.  As before, please use a separate
e-mail for each topic.

Secondly, please create a topic at the Linux Plumbers Conference
proposal submission site and target it to the Kernel Summit track:

        https://lpc.events/event/19/abstracts

Please do both steps.  I'll try to notice if someone forgets one or
the other, but your chances of making sure your proposal gets the
necessary attention and consideration are maximized by submitting both
to the mailing list and the web site.

The program committee this year is composed of the following people:

Christian Brauner
Jon Corbet
Greg KH
Ted Ts'o
Rafael J. Wysocki


