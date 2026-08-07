Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27F8C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 23:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16DC6B00A6; Fri,  7 Aug 2026 19:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9A26B00A7; Fri,  7 Aug 2026 19:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90746B00A9; Fri,  7 Aug 2026 19:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 746A36B00A6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:59:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDAD81C07D8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:59:32 +0000 (UTC)
X-FDA: 85076142984.30.C6CFED2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A43720007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:59:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2tMhiFE;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786147171;
	b=00++vY+zgC5KAid1cKtpzmddxZpYJSdzYgDG4Zy/UN4Y5lIzjSIO2lgECKE2dLSjaenrFF
	OnfSyeU9ae45oiimPTx5CY2g4hKiEmi1jN9ShX3XTkiNvDhVPw50OPwpJ9l+RJZb7Kxzbm
	ePwSwELK7XYsJSHlv4L6u2Oq/ydkLc0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d2tMhiFE;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786147171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih4/vMKtjC0ICTAP+VeJSUaN55ExTa2E+IFm6J2Z3vE=;
	b=Gk7GwEUhgIpAvooiVT/rMybwp5kj8tz7TDftVpYkSmup/9O7BPuXNHcM3VjOhrmAb1A3vp
	44H7utoBduuilkJ3nUqZaJhwahR7z2HDAqNQh0XbOwYjKijnpv80ulFpTqg2Ne0Pz67jW6
	svH1lMkjwMkz3JGGbXrz6LtW6v4Qn+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CAF34193B;
	Fri,  7 Aug 2026 23:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411851F000E9;
	Fri,  7 Aug 2026 23:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786147170;
	bh=Ih4/vMKtjC0ICTAP+VeJSUaN55ExTa2E+IFm6J2Z3vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2tMhiFEt/FNjGa039RVJKAL0/PjD+BSC0G4kW6g0dMN8NqJ7jfnyfC5isGM8s4l7
	 xujO6aPCAgCH0rbiLlYjAwcpy4nWGgvDdhMMX17I/g1ocItdM4oM/6jSR4Oe2cB0Cv
	 z+Y8reIcWlZqrYyQq+pyzLthexRqLJvMdjIgCZpA5FTPkhtOqYF9JGy0jCvC/Oy7Ft
	 KOnppwc0P+vK6Dg95wpLiDrJjpy+z33vgxCSaSOhnJH8cegfhhXl7Tqp9hniysGeVq
	 x+VlekkFOWW3b8ooa0pKHoGTnyE/7E2maWWeOsrP4LFeQ41VhFgZ+KXKzao9dK1ymB
	 SjbX6P7Eil6Dw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/damon: fix nr_snapshots semantics and max_nr_snapshots check coverage
Date: Fri,  7 Aug 2026 16:59:25 -0700
Message-ID: <20260807235925.1146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807161900.57054-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A43720007
X-Stat-Signature: rn3a6mi3qidpo7dbh5wq3cwtntsqh8ho
X-Rspam-User: 
X-HE-Tag: 1786147171-92744
X-HE-Meta: U2FsdGVkX1+inuoR9mdAgMBCa69n6lZqN9u50eIgS2Bl2ILViKR6qa3Bzwt9/Vz3w6dQku8Ea1+a2/snk+nX+dt1BYDHUiyUf2aw6Of33doPobIpa1z1hq/Qdb0+EH7NCFuEgGHYCVAOya/3eT63F/JgtPcqY6QvD6Y/xKOjizzUAYz18S6cjGx3e5csd96NUe0VpdOelo5gTjch5/3EWIIx+CCcMVaw92/78yVgw0iRZnVwVyXVnkhZamgxFgkeRnX0YzYdTTXWdfIXvQR4LG46xhaD/Db8H8Nmucqh9J9RW2bX2/YU3Y4QuL7AvRrXxEwgICQalN3Eur/bi0QHK45606oUugy3smgtMAZy96lGf3kWW5hIe9NTlYsgZYAwwK6gZiG3DfhqfGFyhQpao3W4oWbl+m21sgeYVVS4llpWFCR31Chb6GvifL99uqUXBbspEKnfc0JCoAJRAbXginOtIyvkSjenbQmqI8fRxZpD/aORlf0aSg6UZRS7tAowEYg/HiT8AOzoy/F9ZOWrEnoK18x6dXuOJhZJGlDhNPryI7BN8vm7rqmijeDWRWMgQXd028068XxkKkkoVIQI5z7YqMYNHmgVtQkbS4tAN/Z6OpVx5hdXgSL0nE3kBkzI9jX9BqDaVpKHqcf5rfQliXOP1lbY6MVjcYCmtxlRCXkZ7Ao4Akgn0H74qojGX4lVS+f+RTt2HKCFG6FtWYov46lcH7mhWwJ1m4hlKzFz9Pwo6VdUFfKxhS8TKvyZ2TTi4qehNlcWJVDug+EEHyFYcxDgxOOb9uWgqjGrTmO59JDYvvz81ZB7iief10bI+nzTO/3EPE5NfNJGlh2mCsqNMJ/y68CiDisvOHV8k0oKHJq5AUHKbSAiOBiLFUtx0XWf+C80z+Qq9c7Wt9fr/qOkUJrdxzqzfEK67ryDeToZdGosYgqa5Hith1eh6USzOp+pB+OjOKObLMh51tnsMYz
 f80uR82W
 3LlJTQs12SbwcsSddotaT1T4StwXO0ksc9M/Ow2n8IxNKS68acwm/zeTkTcU010Lozf0ZVO3A8D2Lr0zyF+i6/0I93nNPNP/S+/YCKtdOqxmD3iz3GtL6n2mIOLzPDYAD2xe79RyytMIdpOLEmW9VxwVax289A4yIYn9U867mI/+g9oftYySJw0C4wVlqmETYmNmYYGGBFvAHk/lcSNg6G3U8ue3INjRoyPrGOySN735DV9vU4O8McbxN5EOG1PjHZEoMImuwZBGGRpM0xrR4yPO4VhEWIDdLd3xvwzaiwNYaAOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Aug 2026 00:19:00 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> On Fri,  7 Aug 2026 07:12:13 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Thank you for sharing this patch series.  However, I don't think the patches
> > are fixing real problems.  Rather, it seems the poor documentation has confused
> > you.  Sorry for writing the documentation in the confusing way.  I commented to
> > each patch for details.  If you want, please feel free to send documentation
> > update patches.  I will also try to find a time to do that if nobody does.
> 
> I will update those documentations! Thank you again for your detailed
> explanations.

Thank you, looking forward to it!


Thanks,
SJ

