Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED449CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 00:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B256B0024; Thu, 27 Nov 2025 19:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12CF6B0029; Thu, 27 Nov 2025 19:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50496B002A; Thu, 27 Nov 2025 19:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C43D06B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:51:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3300912C43
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 00:51:26 +0000 (UTC)
X-FDA: 84158187372.04.C50659E
Received: from artoo.va1der.ca (artoo.va1der.ca [66.70.202.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88B8AC000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 00:51:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=va1der.ca header.s=rsa4k header.b=R31b8ACs;
	dmarc=pass (policy=reject) header.from=va1der.ca;
	spf=pass (imf10.hostedemail.com: domain of kurt_cryptsetup@va1der.ca designates 66.70.202.72 as permitted sender) smtp.mailfrom=kurt_cryptsetup@va1der.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764291084; a=rsa-sha256;
	cv=none;
	b=Ey2QA2n1TvHHaTCGnhmY2b4wJEp2k9PJmRM5Ou7KPKNv4aIbLS2ISmhro7jawE8G3ruM2H
	NBTOvqA7PEpMis5ykgES3y7D9KWqMQplkMd1DZk8+xHcXmHhvDLsl2ETXykqkTsGe4sI4n
	XlgV72s+7ZoJKsxgF+5Km1PHwaIy8S4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=va1der.ca header.s=rsa4k header.b=R31b8ACs;
	dmarc=pass (policy=reject) header.from=va1der.ca;
	spf=pass (imf10.hostedemail.com: domain of kurt_cryptsetup@va1der.ca designates 66.70.202.72 as permitted sender) smtp.mailfrom=kurt_cryptsetup@va1der.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764291084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ehl7XowOsgc/Hdy6CsvYc8pNeY/UToxQM+P3jbw8Rc=;
	b=bnyBplmvEOQzdA0+0Kpf8cUx4a/Jf5GeWKCXSBgE431xluyP/kzah2GKEaYZ/pDYeCttPG
	QQ2y7pyuOpZGVfH1wJqIACk56V8RFfHCsiWYIILuGO71itDI52PUwv1ZSES2dghdhthJDS
	QHTnD+h2fSMMPzYCKH/HTGUVcg6RJC8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=va1der.ca;
 i=@va1der.ca; q=dns/txt; s=rsa4k; t=1764291083; h=mime-version : date
 : from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding : from;
 bh=5ehl7XowOsgc/Hdy6CsvYc8pNeY/UToxQM+P3jbw8Rc=;
 b=R31b8ACshIZzZrktnZnDDJEipbXH60inGf6csxDL+9JH+B0UnTulOITG8jgdR/YsP4Mq6
 p5smPfxCWpQol1uZ+E9d7MofkrNx5eUbxbO7RUL0P2Nf9crsSg/Qdj/TzhlzmoLXFomns/G
 fULSPxW8wmxbqVEtSXEW8SKMTvWnEF/nmHh7H9+Ghn0IoNy16GBxpuIWJIF7SyWPS8xctUj
 BnETTMjtowC1XD6bqkRc93KASGl1VfL3ua1Kbr4EOne9cyT+VX45JKCwV5P2RahCPT4rz4e
 d0hCDz3JCwkqdq3rQVcyT/aLHqtWQD2Nwr3GGNVSfXvjgEJkOAP8ohk0X8FHZAB4MOXZ/i9
 VdZSc11M89rVguO87aXQgzMBUAu7A8XUMQICPkJKLpb0CSI8K9kSSutbvr4UTfBP++mj9Xo
 VYcBvV0CToKntXwH4U/rOXq/cULbuqZEp9bx8Rujcfb7J17rg4tXYiusGJ9FEFHkL4sOsrQ
 UkP9Kl2FOEc5RMeiPz59jYThMKQ/GU/PQFGfk/On9Cu73eGJDrx0UsceZKUhmqUb5Edcy5e
 eN7SyeD4jPCjMgen5ecrcJNFKczO/vpmhvsADg8bskVsE4BxNgVsNXEyari1UHmf/ItJgkv
 l/MzRLvaxSK7CZ4ibWFqafCpzQFMFi41oVAmW4exNnQdYE=
Received: from artoo (artoo.va1der.ca [66.70.202.72])
	by artoo.va1der.ca (Postfix) with ESMTPSA id 877083E5B31;
	Thu, 27 Nov 2025 20:51:23 -0400 (AST)
MIME-Version: 1.0
Date: Thu, 27 Nov 2025 20:51:23 -0400
From: Kurt Fitzner <kurt_cryptsetup@va1der.ca>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>,
 linux-mm@kvack.org, cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
 <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
 <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
Message-ID: <804601778974c504d42f4423d335a94d@va1der.ca>
X-Sender: kurt_cryptsetup@va1der.ca
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88B8AC000A
X-Stat-Signature: ndzj518iwq7uohy67jp9xs45orhrnt1u
X-Rspam-User: 
X-HE-Tag: 1764291084-204489
X-HE-Meta: U2FsdGVkX1/XMF+MaLL45h3dg4a7TyOhFNqQxncA6cbeMOdkRd/P5JOHgf7+pUzWTFXpxMYx8kWqjhElWoJB6pu2nNt7zcuu4xXGq7DhCCc6p2CLiM0upy8541OXXzrg3QZYVjt20IiTNsh652BaC9AT2dO4n35qjRHTl+tmwpdaand7INuuyJbc+27mR8iA81XCnOZvJ7LrOCiXw3vhRmAHykq6TIrx/Q1j5mWB7s3dltgd+/QGzMYEN2K1WAUdmBBeG05ptLHS8imS8JtH8w1DfRAaICkV0v1ylTaS+fwNor8NAKv0/RB+xuVFl+A/Hb89xkE81eGADw2d/rkZsfvQgoAnL+sVW7c3Kv4I8t2CpA2yTRTR1LcSV/Etv2Kh+3P/07+6fFX/9lmdEA2j3OpH/u+alflcF1THH9oPsk8AY5RY+2hm7ofAM6tr9q03kNK11xaMLCCK1m8PLDoQIFJBVvTiu//sc5bLGaUEpc7k8amZWKoTsAYS+gYNWKD/cLSaa+lvjIIv1kipljene6hIfQVjCVraG+5yR5mPKd8QOOUuelBW6FXgn61CVujlmeEABIOPyvRKVexCBAVV3bofC6vnXd+fG/4sABQNbw/cxIQcggaq/xrj3jEOo8SGwFNlraghLIzIuCQBGxlFJ07RE7C+HE96Mr4yriOXiuUU8+1zVuQHOXLwEVA9fkgXHkQJUF4K6KNlk7r3ahZE8v18xKcNHtdKbOzlJD94vmtRGcdTwNSHS09i4S0JB/Jt1iuDANtpfACiTLj8pwiOc3FdUzV7ndcUQ6uopGRrZHa6OaDyoz0T4ifOBjytUm0awaEHLxExF/o+yu9SepOCnPUMOXDhbyzJ86mFTJy3j8Khw87bg3wlngt0+WUxM5YKzzuUYzPEICIvkkHkStwzGwMiJZzS8pnUGDbXbp3Av+lMOoZ7DkN0G6kCpulyI0QGBKT/BVig6JqeDTXmT9W
 yqkuCaSJ
 3He4GzbO+sSYHSPF+YHJfnvsfgyk/ndqK14YlI7u6F8v+7tLyGsFOJpm36wm7g72CBx2EJgFqUPRVa6fqjTMlHN8jeqAPR71pB8wvDL0236S2UVO4YjCub5afjUJ44C4tN/LZ5huq2PB++CkdkMOUkC0AeJWAAcOCVrbPhWdpHZqNbd6HoXvlmFeABRVWz7kKaFspvDpzE5aR9hfsROV50IS12GeD6Ir8PEANqMjdHINYBBLL1Q8Lvx0ffw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-27 13:54, Mikulas Patocka wrote:

> Encrypted swap file is not supposed to work.

Do you have a reference for this?  The concept of encrypted swap files 
has been a valid workflow for a very long time.

> So, this is what happened to you - the machine runs out of memory, it
> needs to swap out some pages, dm-crypt encrypts the pages and generates
> write bios, the write bios are directed to the loop device, the loop
> device directs them to the filesystem, the filesystem attempts to 
> allocate
> more memory => deadlock.

If it's the filesystem trying to allocate memory on writes to a swap 
file that is causing a memory allocation/swap race, then any write to a 
swap file would engender the same result, regardless of encryption. The 
encryption layer is redundant under the failure mode you propose.

I can confirm I have put kernels up to and including 6.14 under heavy 
memory stress and have never encountered anything that feels like a 
memory allocation race.  All my systems have encrypted swap files.

I can't speak toward later kernels, or any bugs that may or may not be 
presesnt, but I know of nothing to suggest that encrypted swap files 
remain anything other than an intended feature.

     Kurt

