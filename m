Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B9ACD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449B36B0005; Fri, 12 Jun 2026 20:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAA66B008A; Fri, 12 Jun 2026 20:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3102B6B008C; Fri, 12 Jun 2026 20:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223B26B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:29:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60D701C16DD
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:29:25 +0000 (UTC)
X-FDA: 84873005490.20.5B003C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAD548000A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:29:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUpR1vVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781310563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX5EeFoYIlnqcKiVqHYMI6diVjZF3ZLYKQ9rUYIgtI8=;
	b=3qOHJWhPUZW8tHj5Kvm+gngC+UAWPlvylD8V8ykZF+3GXF2E57gC4LwXWKW9Yd6G9UUAd8
	TALNQyhPpUf9xpSKuyKb1v//HF41VSq3pmQBA8EBXSDsb21jXxpgE+5ojbrCSSzxPRGJKr
	zHN59MTV7VgGk8Mbp6iN27sF0QspHMo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUpR1vVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781310563;
	b=FrvtkdzQ+zGDcu64JZmDA60RRro+NGoKbnAw1e159j61CW+VyixnNHAUVLjeKmkByrr8Fo
	NI+C2dQvGF1FIkUZCPdabshaI0A/vi9EbIdZ6gqlpTY/YAMxiL6rhHC6Zi5MdoLwwg0COh
	TkjZiB7zECudYv9qutrxU/+xiuprqB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 422BE60008;
	Sat, 13 Jun 2026 00:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9609A1F000E9;
	Sat, 13 Jun 2026 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310563;
	bh=SX5EeFoYIlnqcKiVqHYMI6diVjZF3ZLYKQ9rUYIgtI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUpR1vVypzZUy7iOl2MXFnRW/6mZ/1+VIoE13SDcSHC573v0ePiooO9gs5VCyqoc9
	 8VGkV6wBRPKF31K1hLzZJI663R7cqJHJIhGwXb+ckGDkHURmFQpNJo8onaq47qC/Gv
	 0e2tzNrPLZon3rj5TwesGnY+z1lp0Bz9r1cyTtCvPEnTXLlADOOBe6slkKnvf/178J
	 yKlYa6Lxqt4WtKvzgvnLYcaFnmhGpBLywdLo7+oYMeroWzp898iaN09DqLaMUAMAX6
	 dqpgSSM0dJLJvCohEHlUsyn/tihlUWuL7o/nqKoWCyOduDRGlDnX+uAhXVVwQPtKht
	 TV0PTxSXinNGQ==
From: SeongJae Park <sj@kernel.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	penberg@cs.helsinki.fi,
	clameter@sgi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
Date: Fri, 12 Jun 2026 17:29:12 -0700
Message-ID: <20260613002913.1509-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BAD548000A
X-Stat-Signature: 6rwdpjbekghipncub55oczmktqn3q7ip
X-HE-Tag: 1781310563-70390
X-HE-Meta: U2FsdGVkX18X+hysGmbwyR+VO9F0w0MkkT+f4NJLKP5nMUhQCmTd9flrhovA6TBc5jqOE1zs1zI2kOmGd+9qparpsSidENReBinFcYl1w/v/EAZhBPI0NRSIXQKS095zVf9/pNB+FnrFHoUgmbLMxRun6DR3Ea+foc863Tfak+aTnm3JJMieZCx6lZypBSNLdzdEt02BuxnXIL0uU9hQILg3HA9s5vdGG6qFTM/ggS+eTjxVOIp0h8hu43yD1SAcgl7W3URqEWYhDLt74OoznWDfhL0lP6s330o70E1Js10fX120bQaHIohQk/Z1GksA8ufkyelkEz+RSyzjVLPuRXw8Tlf7G/q1bASiuMtlpg7XltCRSceHl06orKlzdt8vTIuHPtyWpo9lvx7Cbr0divmlYwjWxMQMLQkN5LuyAW2EkRPr0pI9i8CFTIzuYf12ikex+dgB16tdyBw4k+53JslB46wr7DQkiABovOWOr2vPIFVwkRfGhzSRjv+d+CzLRKver0p0rJAW3q+eYsgJx1i+vspB5RgjIrIImkrSW88LOEPXsfy/27TNw1nnNAZuPzp5I2gpQKnpKTMVJ4ae01br+Rhr9wFsttwpwlZqr3gUqZaUfPARsU4bUpjpYvn+xdVglYOsr+C4ZIgDQrmxmMTioUk9dyv7G6BqA2AcYmZbdwCFZ3T5a8zHfkQtS34ZLp5k6iV1hAJAhOWIBee6HEkYAgb1K5q15F3rXgOf20mvFgo5+9aKNBBSnP6vvXf2UGUQavwZtrIhy6iF2AT9REC3Sd7xEifC+c56hcP6oqOrSiCBfs1jfkCMQIQZv6xCTDAI+GsY9LbasJ1QQ6VCUfBUBEZ3CZMlpQNgc83BjxwJqXut+UVTWG3Hnkw4B0DfLOUnmogYk9zQYcModi7fUGc+Dcj8E4Zr41FTVIISjp1ZP4T35DDwrAFUGN6IVDNEflyjy7M3jNphG4M2/Ue
 BfXQJQUH
 fyOFBEmZoQRdOml6aLWb7gnghzG0v2ySRudBjpqFJcbcnqsioqhAtanzxrKsfvkbQjrsg/c1MAdau/AFh3Wj7Ejrl+Pb8e8zIZA808gNr8ouIJRDWHLX0x7i7NSBqOo1PiqqOkRI8aW4bZhesqaYUT1ksRxQwmvYQK+cex+/3Saq4mn9ra1gbUisZyRwQqvrLYjYIBXVRoEdAEcWOoCBWtdn4l90wN9DHVt/MrW+kjo6SbGjbjkFjcf7HjOFRbHW2/OgxHmt4JrPQ/B8CGqAQFRYycfRcTJ7g0mEA8qbTzbVxLcOLi9sPcOY3cyp9Bk6ZDeKLw0h7rqXRaU1MkQaxcr+edA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 15:13:59 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> SLUB exports the total_objects sysfs attribute, but slabinfo tries to read
> objects_total. As a result, the lookup fails and the field remains zero.
> 
> Use the correct attribute name and rename the corresponding structure
> member to match.

Good finding, thank you for fixing this!

> 
> Fixes: 205ab99dd103 ("slub: Update statistics handling for variable order slabs")

Should we add Cc: stable@ ?

> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

