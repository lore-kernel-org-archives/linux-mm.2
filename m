Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5002BF54ADD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 23:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A3C6B0088; Tue, 24 Mar 2026 19:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B306B0089; Tue, 24 Mar 2026 19:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578286B008A; Tue, 24 Mar 2026 19:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 497626B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:24:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D40C2C1761
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:24:48 +0000 (UTC)
X-FDA: 84582538656.07.A95E492
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50C28180006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:24:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="19/D0rw3";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774394687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bl+Clut4pcrBNBzDXD9S22CNBVQfuB4KXjiCUR0VwjE=;
	b=m+SJni36+DeP4kWbddWbohcAKHp9ZXtH9unEgaj/rg2EN8ghL3lulEHVhJKN2PsdUX1ejE
	J4HV6D33b00qeL+Q9iIXGldnP5DF8ee55CiTf+YKW9mZ9djwlIqj9EKtsxvCLxvDB/1NRu
	ChMLIOiqryg9ouLNeltQADD4DHbGH0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774394687; a=rsa-sha256;
	cv=none;
	b=zWjWVPZpWA5aXWh+SzffxRU98rzKCC3myL66K/k7UrB2ZfuQWaH18Va5vicaAGgfI6Z7GN
	/U7ak4gzfOrTahC5XY5F/L+gkpVUpJ2CKAePDfgur8JDQjnW9/VeodOLEe1pakXvHjFWVx
	uxrks63iTXCMLxdvxEiFrXGyM92QU44=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="19/D0rw3";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FA7D600AC;
	Tue, 24 Mar 2026 23:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE65C19424;
	Tue, 24 Mar 2026 23:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394686;
	bh=F4CyAlfEjGscpz8wF0DsMZgmHP8gEaFE9YsHc3AxTIo=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=19/D0rw31oXccpRiuy7Qx27TjjZIMtt8GhK18BEh9uOrxPAlnmfJJKBPL0+2S2H5/
	 YigBJ6rCxZpPrctE6hrka6hfrrRVGbxxlfelORLM8B4OFGjsGvnO7C0UFPeoaJHD8c
	 tA+4xAnhJgjyu/rvgJVPxwJ5rilQH7y8lQ2iy960=
Date: Tue, 24 Mar 2026 16:24:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Audra Mitchell
 <audra@redhat.com>, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, usama.anjum@collabora.com, colin.i.king@gmail.com,
 avagin@google.com, linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-Id: <20260324162445.fb353f4d2c85d89bc25be03a@linux-foundation.org>
In-Reply-To: <20260324162324.6efa49422d145afd4dd37dda@linux-foundation.org>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
	<20260320184010.759461-1-audra@redhat.com>
	<20260320184010.759461-2-audra@redhat.com>
	<a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
	<20260324162324.6efa49422d145afd4dd37dda@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 50C28180006
X-Stat-Signature: nxhiy75u6phcfgw5wx5dn4uzymjujciz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774394687-699350
X-HE-Meta: U2FsdGVkX1+jAGadUCDrmea4G5yRmOw5eX0/NyaGPPT2OV1QhrOC53OwL7iywjXNQxxEt+DB6TffJm0WFy/IYvY6uT6tAZ8ETr6Ld/aMZUvaXVGoxNaDNXPI4F13Q+Z4IP3b2VsIW3u3x9heHqOHC6+2CUz8hCiWXO2SW2r8AgFWdhI4gNI8GWAucqc7eVIO9J57qAiTNvOJzBA2qn/wWZTgLUQlplN0fdSbvP+LePceAA0tC5xejvsH3SEdgThj5/8nX1b6rEbv+FsSCYrLLCevrroGZCNVOvoZzjLWSCqs4LT6CdcP9lKiP6sXXGMgd1IAbHa5f3sQgG93JmSKBtXtmpBRvgF0xeT96Jk2yk4hBZ3BLzKfijbzgiL/MDX98mUWRdyZk4fhwl2q+fKteheDkKs9W2l99ydp63Y3wN9p87Vz2RigTtV37zodSmLAxydZaRG+Qb5NcUaS43/UudmDK60VAe/VTmRChZVrnxiibdXXT7yRo4xE8YR3BQRCI8s1xi5V/kHzOWvoSTsmQpk81HKryQNQykojR/xxvZ7OFVMuc4We6iVOGnUKCcqcIMoMGF7PiJG1uuC4d7vuaUHksKnJs0EaT0pgz4WAaEwBddulc6DgN1W6iSEiBjapRX8zyf/UeK8A6DZoepx1CDeS0JmpEdd/qh6K9FZQMm2OiPt2l5ZTpIHNcnIC0LJkkpPxxa7OlWOkEn5loIj60rchrvwJMtSABZpO1J3R1vNsoDd26XCbwZntzZzHvsMkVrqSYlDheuLsKwfBg759+Uhc/Y3JTMjWGA+8Jap3cfqrT7ILqW2pJ6cQYAfex+8zkku+jOyt/gmw1WJ1NWgFwupLnhUwAe188BG+XNRuAueVOU396jaikiTQ/6JLEZVK+u+cBow1LJtiX4DOdaZjeHgn/br768oozvcua5igYaqMQQjvcKkbhuzpSFspbxENK0S38HZtbuntGNcRpg6
 neE9F5zi
 ZkmT6pe9uCFEDdF+oes+3fNZcOP/shYjqzQSc9hCyHWd538elgBC6qULxm/mj1dorjObqVq79c/6SULDq+VyAUSmeERgbIEeCydjfndLlXQbzSoev+jcPhsIJsdp9ja2dCI2XNldiQmxX5r2diZ0jcOo9yiVkQui89vTwxIiN6DSlJQnfswy4H58l+JmZb4kS6TfWhkUD8KxrRCaF5qjXFPKFd1L02jLR/wdQwOeUj27bXgkZOvV5yHGlNbz2xbLbG0q4rvq3NJ10el3BeTcwmJrutGvaMo/TVH7lt/zh/eYVBVDRsaDZkLnu8Soiet0UPgCUy3s1sJvcQk7wrfoywKR8Mbqfcg/prh0OrFewf3D6wtCRs+rIiJ5SmG3PlNS4GenvnxF9bRTMY3FW5DVJWqQpdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 16:23:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 23 Mar 2026 12:56:33 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > > +		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
> > 
> > You have to cast it to a (long) first before comparing, like we do in
> > pagemap_scan_get_categories().
> > 
> > 
> > Maybe best written as
> > 
> > 	long ret = __pagemap_scan_get_categories(fd, test_area, &r);
> > 
> > 	if (ret >= 0)
> > 		supported = 1;
> > 
> > > +		ksft_print_msg("errno: %d\n", errno);
> > 
> > I guess we should drop that, was mostly for testing.

oops, sorry, just learned the difference between "delete" and "send"

I was going to say "unclear why we're printing the errno from a
successful mmap()".


