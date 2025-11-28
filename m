Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97452D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A0D6B0029; Fri, 28 Nov 2025 12:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA706B008A; Fri, 28 Nov 2025 12:50:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2686B008C; Fri, 28 Nov 2025 12:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A81DE6B0029
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:50:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A685BA50B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:50:48 +0000 (UTC)
X-FDA: 84160756176.12.916D431
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id BC3E2100002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:50:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nQjuKCDT;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764352246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISlazhlQCvrNS1N+QRuhxBA4roAuVAjOK83kV5oq3EI=;
	b=puJp697PTHP6xzl1uQPfb73ajYnfR4Ntq3Kx/aPEqhLaxuTU8XI40mEoG9ygYx+I4uqavy
	L+FhLYZFw0e0TgKSDoB81GJnjiDWAOJvNQOQB/AEWhjIHhVy/cY84hZyV15GHwAeycKz7K
	Sj+ENYeikpOU2g38Am+h+80uN670zEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764352246; a=rsa-sha256;
	cv=none;
	b=5TSnBBtt1xu7H0xgNnYCF0X6RkAOclEgMYoDTYlytJ67z07JcEyOb/lb95kKYirrfYaRx2
	DTAV/l0s6jzHbIbupS2UTVX+bgemcqdhjHE+rnatvGp7EqjcfwRpSY5ln8S9bx61R8fHjT
	y0cYoZH2BwA+Droi/wXFO5zXZG61I8Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nQjuKCDT;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ISlazhlQCvrNS1N+QRuhxBA4roAuVAjOK83kV5oq3EI=; b=nQjuKCDTL1ZW2JnJee46rMuyxC
	xO9FjOm5E1qkedtVN4/qFx7K/obuiyPkPjX0iIe8zYPBkXrcuyPvh6V8SnFLTedreigH7fSKcZ6CX
	JHH38tt6sgOA72/2WBR2tP4xeSebgQ/zZoc3IQhPc1pyBj0KLe6aPaRZA2GyoMvTjPwe39bckygZA
	KN5JPw/BhEcUv4N/PEaYAevBZWlsoTeaCempHddKuBGZnvDnKnAHkRayrocXlUEdg9EFB5XTVTNQi
	CygbMkNvUKEKjxK/yCcTk/UTCmRkiIezm7cbIYY4km0PbbVHw2u/p1XRoXURdi4LsOPSj7rXgJdDV
	qsmY327g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vP2cE-0000000Da5F-2iR2;
	Fri, 28 Nov 2025 17:50:42 +0000
Date: Fri, 28 Nov 2025 17:50:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Sokolowski, Jan" <jan.sokolowski@intel.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aSng8hKuttOWQuds@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
 <aShb9lLyR537WDNq@casper.infradead.org>
 <aShmW2gMTyRwyC6m@casper.infradead.org>
 <IA4PR11MB9251BBCF39B18A557BF08C0799DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
 <aSnFME6-LqQXKazB@casper.infradead.org>
 <IA4PR11MB92511BAEF257742C82ED590199DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <IA4PR11MB92511BAEF257742C82ED590199DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: BC3E2100002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 1p6eh4ngsp315a583sjdubboah88fcnj
X-HE-Tag: 1764352245-185745
X-HE-Meta: U2FsdGVkX1/BCyEk8J/c48syOQHU71YPgpMUAUBYqvkeZoBKlpRRrsFRR0MF9HLaDmGfAcpfORKoa4SjpsaaNQmGMLBq1sJY4ruL/xoXHXIvGtPyAKaCm+9pgNLalGGIWcL/B4Jzb2C5ly4jrDxzyQtjT7Koh7eJpxYUCfR5JaRy1PyZblnwLkmXL/g+hTBuaMpw1f9q8c/OR4DMU5u7aPIp/NcRXB4tpc88lg2m3VSvj2bwIZlBugPEIwr09Cca/tMo3NekgYNqfL7eWZASz0nmesRwls4SGs428hJin6oc0B/TP0BMiqKT/py5nkGhIATQyXjZaszcME1QwB3RldooYuNoAvIiAt6aqnvi558O4gkadf2mjGZ5oNM5VHZWO/Upg/gIzV3qQ5qWB3p0hBL+cAjBL3I3x+UpCSXbSjBwVxd9UxS8o31QSTH/243NVvLTxCcHikCWJkrOlBrjqWjDhnoNm/gzDxl5+cFdTssAnx2/ctSq9UuQuxesse2chZh5sVwWfeSormBwTDjDA+op8uJ+xyzf84z1lCYjZRJ3oNXDU2cxkqXbM962/XbgV5RMzEeNnnu/YuGBCvtHS8RWMGJ38N9h10NEz2thJg5Yx9UdvWgIFI+Ozs+V0MdDJQfvB9FfDCghvYwhBxr6lL08bUWT6K2c2FdmQgiUHhtBorYpCloDxAaNVEGHEbQX0ymlnh6CdGYStfEDpdyoMZCfugAA/9Oudj0ExkRAUF0DeYaE2oM6tb1EV83w1dYhX447d/xYzDCYip8/t9tEd8l986ngEwc4ECp8WccZK5UpTT/Ji7kQpW+8zMmdGZpbJ1o4BzJ7umFg8fI9CnXPGpZpsJaTu1OVu3q2gCNUsdXornh91EVW85+4EY1GCrKbr71ID+hsfAtO1+Hg/Kkmf8aok0V4ZCLBhfbrZZGofrTjn+eqGVPvQq637wpMy6q+t+uhYtuxuSFAyjpDehQ
 YWHMLPp5
 G1yCLMUTOIxxUFDdxj/VzBr0OI4KNFYRTM4sAVrih+BZ4b3Gnj9NTleictew7QJOaomOCPRjdaP/ZCsoHRjHv+XeOA+9TKpJdHz23nX8HJzKZDxO2kQ8e3g2+SGmExDiOlIFQg7r9wUVKUfP/vo+r6Y+AGfgkXzX3+eKbIfoIQ8TnNlpqjbEnLGd6N/2XtwkcERAD2s8NKI9iFxlwAIzIIp2IQD07vT66BNu0iEHH/1olGYD4ra+w5G0HHB5WCMWKt+NoK72HaA56SFy4P0BRn6BwOnO2X3frzN9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 04:47:17PM +0000, Sokolowski, Jan wrote:
> > No.  You didn't co-develop anything.  You reported the bug, badly.
> > 
> And I've sent a potential patch on how it should've been fixed. That should count for something, right?

Literally everything about that patch was wrong.  If I'd used any of it,
you'd have a point, but the entire approach was wrong.

You _can't_allow the allocation to succeed and then undo it.  There might
be an RCU-protected reader which would see the intermediate state.
And that's an inconsistency we guarantee can't happen; an RCU reader
can see the state before the lock, the state after the lock.  It must
not see a state that never happened.

If you'd written a test case, I'd happily add a co-developed-by tag.
But you didn't do that either.

