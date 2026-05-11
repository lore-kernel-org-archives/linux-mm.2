Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D50CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA836B014E; Mon, 11 May 2026 12:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B24F6B014F; Mon, 11 May 2026 12:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8116B0150; Mon, 11 May 2026 12:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CACA6B014E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:40:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FF4D1C00B0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:40:23 +0000 (UTC)
X-FDA: 84755701926.09.CABCA33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63F7914000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:40:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aoe08CUr;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waL1s2GXuDPz9kvHkNF3Pd1gPq/IAJncjl/05fQhw2k=;
	b=X2go4m5vFKzR34FgFEZ+qLqedf8dJN9KoA0Yc3+30KJwleR9qo4jt7+fh6YpDYF+XDAW9t
	XXC8sQYA2CFLnz1ZH7nEmFbjCbcaDLKZfPzzW9WqU8lge4JfdiNg0N9xjUAwfn/UErLYW5
	c5yY4hclvh9TZ4Jv0PS5NofxAjfX2v8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aoe08CUr;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517621; a=rsa-sha256;
	cv=none;
	b=vqjO4SSq6s45dsacmEAPeL4FliwsL3QT5KIUABjYpOdvzn8YQ6PMBp3VbgpzGEqpwnJfg2
	EiyNpaANRPL21UKzkBZ4T4ajCzH5Q0J/cZ1+yUQ34J+I4xnBBf+VOqR/52yYpXCywREN+O
	IR7PxsOg+Lb0bl36eDPXIKeCJyJdfMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 686D2416A1;
	Mon, 11 May 2026 16:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F20C2BCB0;
	Mon, 11 May 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517620;
	bh=5Sy2Vpv0vDIpYFu4ImjlfBjTqwz0lLOoa+OwNsUw6hM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Aoe08CUrjB1qKN3KIDK0zQ4/hDTZrmcaQTUPmLyK/bHWKwjdgnKG9VepTO99yXigc
	 UVChFCzbF1NI2uUpK/V9Um916/iJYf+MSkaqlMCzF3V/FYtDsXSCESVRCfQ55sRzNb
	 vBSTPTAGj8Usif7Iwdh4XNMm9ephMs8oPo2S6Tya+XxGJE1fKp6t7/X0WAYXkRqPAa
	 KczkmzTbCbOhyZWcoCyZeyT7WLBr82JP+O349v+7o0ZAA1tLHlSjCfsiou/zpafqk2
	 BRDlbEp+74njsAGBlzDGlyYgufscXlxRMGJI79qCw1P8hKDdWtCvEi++awc1nAVdip
	 0BAN09OnXzfJg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] kho: add callback for table pages
In-Reply-To: <2vxzv7ctc38a.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	11 May 2026 18:36:53 +0200")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-5-pratyush@kernel.org>
	<agHCbpn5Hn3XsEWH@kernel.org> <2vxzv7ctc38a.fsf@kernel.org>
Date: Mon, 11 May 2026 18:40:16 +0200
Message-ID: <2vxzik8tc32n.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63F7914000F
X-Stat-Signature: 6ahjxmoadoykj8ifis65ra9ige37334p
X-HE-Tag: 1778517621-191815
X-HE-Meta: U2FsdGVkX1+nZIG2N+m9PVKanFcNIVZXuoGzMvGQJmwi+Bv6lFOPLfekksY9xrgrpJin9gJ2ozo4Y2DJalgxZHTYD4hDdZLa83n4rXzWxB8WWXh/45Mbrj2nka4c/bfWegbK4scW12EwIo/SfDLXbsRDMGAmxUIySjlJaX6Bt8gI/5z41qcm2LX56J+PKSKIBAsVfoNlygsYTFw5nIX4DM7dNu/N4Lasu63acXRtH/kUGyHNpPGm73BBCOH+TMNdZgP53Kqyb5mDpRB6kw25bhL4Dsw7K2t4o5Ui9WA5reqMqpm1oXd9s2sv2yIwaFyuLZFnNRMCydHum51gdFyUWt8IxK4gn+x26QBlEp7IDNLbuNlii3zDXn50VrocKPOH1YjHET2Chk+JpIvKoOYu2KytSr/DBSXCq4RF4TAb7kI3IssGJN634kO7NCqMxEwdtQvtBc7tgnNTNo9XJDE74zTMpy0fA/kKtaYn6CTTmJm95NUws1GQL3yYaWS5GpBccVXvbJWtw1Icefrh1JHGYFBbLq3ISXF8EXgtOc+UWrhp7eWbYWHny22cPg8lpVZiKwUArZlu/bM/1wDTMZH2EOSxph8pa9ndTxhNc/maVe9QpSUS8f5aX2IF4jRBaoUJq4ktU6+PTqNZQ7Y8EBCZmr3KJHiIYBF0151dvJKXlbvAHabUG19xdixGamemupNQeZ9OIlifIdUCLk9monvJmM2PiwOVwPhFmKGrhziZ6vj90IpVow9iuH9tNRY5js9hdIqmnUi6qDd6JCzx6e0nyoaqNsslCO+FR7BecLh3pknSAeg0cCp4rMY0RkZz9cTjZ0kkBa2aL2ER0fF4s8rT3aLlayOZ257K9718m8JYOcyDNshkxGXb01PIVJgOYk/GSTCpstA5IcxcDwfpDGoAYm2sw5zM7Z3yHnhi8gGO6OQMsUlNtn773pUAa6RR1YyIz3CeZKiGHsGP69Z4SOp
 dZgnNms5
 SKsJ9NHwr7yeOAAH8bWTD4NVJnsWAhf2sf4QefyL9RGRtTBxJ07GgjdgVO3Id/Mqm04lQPftnvF5ulDmd9w69mJV3OYYmhoVPtLtkEzIKN99KUgaomgiJKx7dTI+f2ZMCvhtH6/YvrOkxPWf+HA7aoobQAjY+tOEc/T0HfkgMbThkSAGsu4oDBrNu5oifjEyIyVeV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Pratyush Yadav wrote:

> On Mon, May 11 2026, Mike Rapoport wrote:
>
>> On Wed, Apr 29, 2026 at 03:39:06PM +0200, Pratyush Yadav wrote:
>>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>> 
>>> The KHO memory preservation radix tree does not mark the table pages
>>> themselves as scratch. This is done to avoid a circular dependency where
>>> preserving a page can lead of allocating other preserved pages. This
>>> means any walker looking for free ranges of memory outside of scratch
>>> areas will ignore the table
>>> 
>>> Add a table callback that is invoked for each table page. The callback
>>
>> A sentence why a table callback helps would be nice here :)
>
> The main reason is that a later patch will create a radix tree for short
> use and will need to destroy it afterwards.

This was meant for patch 7.

The reason for this one is that kho_extend_scratch() needs to exclude
table pages from its free ranges. Will add it.

>
> Will add that here.
>
>>
>>> is given the physical address of the table page.
>>> 
>>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

