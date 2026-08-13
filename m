Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515ECC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8976B0347; Wed, 12 Aug 2026 20:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9E96B0349; Wed, 12 Aug 2026 20:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F062B6B034A; Wed, 12 Aug 2026 20:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA4296B0347
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:08:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47BB8120434
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:08:50 +0000 (UTC)
X-FDA: 85094310420.24.482F762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B63D61A0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:08:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mvH6aU/H";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786579728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QY5IlRziZNTfZ6Z+fu1Ef4fAj7qOAG9xqtNlFCx4xzk=;
	b=YSfQupEzceYsOgKfYpw3FqVOzwudjP4VPu099RfN9a89BsF1hz7pwhaN5LwmEaHX94HOIf
	FITwlgZmJYq8tbd2lO7UU8ucgFKrAqtoCdVpbCbpI/P4HquudDXRl58kgu1M5L7eTZvieS
	fpYLPuuDPmUxDg3WqsBKMEKJUpvz4MA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786579728;
	b=SIyo5O5gWwG8/pZlONQnVXwE1+q6CRr63usLBxDOJEGOkApP2iyjjUiQxnDVwCkIlV/APL
	+IyWosGMvRdYlNRBC/vWsMDqAsRz1zEIetmvcpzwkUyN0jgW+m5RLjrMgK2Lr+IcmxnjuP
	jZCTbVHrHl1tf/otlFCFD0UMJDCH2qw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mvH6aU/H";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1439B600AD;
	Thu, 13 Aug 2026 00:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C311F000E9;
	Thu, 13 Aug 2026 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786579727;
	bh=QY5IlRziZNTfZ6Z+fu1Ef4fAj7qOAG9xqtNlFCx4xzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvH6aU/HppVAC2zVlIBrNmXlBC4rNDmbU9XDOAPMoFDCWFY+MIME2MoWw9OLUizBF
	 FQ4kB49p/fVRI+HLlqDnVBDnAj2RiztEuH3rIE7sTis4qLT4A7Yp3BDLe1U0hiEvf9
	 svcIUNzPBmKzzdw1cxSV83DWvW+WgkpYI7VWjW1E2vySv9BPRuu5tQLrxwoNTfl2UE
	 HErh/itsJ74SA++qlbKfjnxJW5xeHYfdYCQPBEU81NvAJNbNBDnT6N4s2VHxM+t3IL
	 2vxtYz63XauupoZHYgzAtHaHLXaEyaN6r7lwl5U2ZnT8znqjF/GvuXIWj5zMEDeoIL
	 aBUazDhHsEDPQ==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections
Date: Wed, 12 Aug 2026 17:08:43 -0700
Message-ID: <20260813000843.128434-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 318aqf4twhd5udonfcrdmksrsupsaan7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B63D61A0003
X-HE-Tag: 1786579728-742137
X-HE-Meta: U2FsdGVkX1/JMmEwf7Ow9VJ7oBQ+WznRYHOXeFUmE2w+NtV0Glylmv3QvgXDoFiCdi5fGZuzGXIjsNkLZdUyxAAMEMo6wylwvW97hhAcoHpkEKgY3eqiAf0LhjiH5XO9N1D6r8VeuObghoIXNElLalx3zSKCMmcWn9y5Y48himXHM2DeQ4kH9a6zEvC6ggaks5LPhAmsy8MCf+ZsGAusP7s8KKa0U9pI0rv/EJkZHAcsUB14t7F2g504FOMOIGwD9sIrdQH8JUPNOs4thAeQtqDur4JKz0JE6H+COYrOrksfPZlpeRTAhhXvh6jr4eeAf/FtcOapi3Pwfd+ewee2Z/uGWRh61ShkyNOfqVwxqvIQxNPbMNOVcimsJIDav1tdZWAcDDPFTNFDVxvs4Lp7MA1+UTdEVwuG+0+JfYK4ZwDDztVNMK1rugnK7m5KwZoTFrGBbI2tJmaTaeosG3VlQGgf0xdcNeG3Ql+1cnm57ZYdhW5Dtxsfa99NFybSFrrbWn1fo6x6yjtxlHptAnp0CjW6byp+n45pCLka7F3lUbsgetuxQe5O3Byrpek4qXuSqStmNQ5ufleBcomXlD15UFW4GstY2zfOh3PpBynsndu+CL0U2kO7O7+Ym3tHBz/YBwgiHy7O386beAH3H0w8QDPppR376/UW+xhUmSxfXb+lgiE9N8ArOTjrpXZ1h6YWMhHPhuisDZWe2XO1UT0FBzkzy8JSnzkC0tCVvKLnx3guAUZzCGpR2peyJWaNl2HYOtR9xs9Awtjq6efzRNBGVMp6Jwyud4VRARYJb3UCTcvUI9jF+9wL7JM+uCwflFYAf95SVC8vivsA3k0LmDCv2QEDWer+xbux6WyAhKnElLvi6aPyVfn8CofJ+ksJ71ly4lhJE9mqUuC0drSLeREeUSikuL1FbrwJfYOdMoosj3DmLQjQ/JP0ahjUkiqYYHoSOjSh/jv8r0pGZ7K2aCT
 VesJ7MgQ
 VnpGtc1BPinICmAqsa6sjTNBrzrHZ5lVC94bNHLaNqqLmAH8kKqxN83mKzXBnhZ1e9X28psLuIko+DOblURkBC90rrjYhLZQubaWNPvc4wizYYTIGY+GNp2x6qj2OuuRectlY7HAqThV7qIRGKhB4LhEcHFu7yYEAJBOPq8KLM/+0Ri8+bfIutiD2tmEKWEWTQMDH3LJwhTyU1cLtC9NzDlA+Gnwwr6tfP9WwBd0gIl5xybI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 08:43:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> This file is a 'special' driver that implements /dev/zero and /dev/mem
> among other things.
> 
> As such it makes sense for mm to be cc'd on mails and to have some say in
> how things are changed there, so add it to the mm misc section.
> 
> Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
> MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping, therefore
> also add it to the memory mapping section.

Makes sense.

> 
> scripts/get_maintainer.pl copes perfectly fine with files in multiple
> sections so everything should work correctly.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

