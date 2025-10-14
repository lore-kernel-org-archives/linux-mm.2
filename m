Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F6BCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196918E0075; Mon, 13 Oct 2025 23:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FF58E0007; Mon, 13 Oct 2025 23:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB2A8E0075; Mon, 13 Oct 2025 23:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE6B48E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:21:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CE2F11AB33
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:21:08 +0000 (UTC)
X-FDA: 83995268616.30.7D69324
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id B11E080005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:21:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=NP42bns8;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760412067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41OSkq8dhVlpXFlmK5VxSYY/DHIKRiJto96FUVix4L0=;
	b=HHfTXDPGagwnZ5IPs28qlhiNxOFJeNfFnkospcixSfk5GUVe7zL80N9KWbhN+R4uBEM23k
	40Ketc92WaW1rutYlNKpLhejU08UBkNMam4prcClbML0FiXYmy8BJ+btx3EXbd0kGDnZN2
	Q2PXwMquclun4Ec0kZkUu7A6XplWxpE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=NP42bns8;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760412067; a=rsa-sha256;
	cv=none;
	b=6y3eDWEolUnm3y7URe2zDnGT1mt1x8RqEH8MOzsOnREzJPpDZnFgD7VOasZksjEYw0Pol5
	A9XU5YLUXogJIEmTVgq2n/m+uMCs4f8Fu8jyy4aDWyqjKNOnDWP98fLo9qNlHL+JKxxJZr
	U1ChRUoYUsxnm7U+u/1JfwByO6u3+Gc=
Received: from trampoline.thunk.org (pool-173-48-82-170.bstnma.fios.verizon.net [173.48.82.170])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 59E3KsU7014549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Oct 2025 23:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1760412057; bh=41OSkq8dhVlpXFlmK5VxSYY/DHIKRiJto96FUVix4L0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=NP42bns88QjT/FW6rfonREwhQSPUJN/eEvD0QNw7h90hB0l6EU3SqotxLxWIh39gx
	 4WN08/IPuTGAdNzZ8lW/YtHoMKHfCjyhBp2uRqu1RzFJ3JtWbBak1IFjHfn9KsY3jT
	 UUGKFJAHfY/uffvWEBHySfOF+iZxkpLDZu+VpHlYVP6onFReFKJ9rat2CYVTAezQvl
	 IBrJaTZZQh3ytQqP7FHxUa69mh9lDXdrxhYKgG2GpMugZa7jBPfcQcG7yvFYT2EbxZ
	 XLFK2BT6XotlVagaec9EKrn7Ty8eTdPwO+tjezP4hRBf3rwtqTTRAHge8BUCVPh9Ly
	 ndpVqQup1Ahgg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id BE7E32E00D9; Mon, 13 Oct 2025 23:20:54 -0400 (EDT)
Date: Mon, 13 Oct 2025 23:20:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <20251014032054.GP354523@mit.edu>
References: <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
 <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
 <20251013172654.GI354523@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013172654.GI354523@mit.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B11E080005
X-Stat-Signature: rybs5wimwp185xse6tht41xy66zx4jtc
X-Rspam-User: 
X-HE-Tag: 1760412066-726358
X-HE-Meta: U2FsdGVkX18x4ws5JTUxX1GW+6js/EO12UalwieVfwyLWjfbNaxkIa/uFN7D/2nJ2GlSs2ZigdZh05H63QB1xn9PKGUUEQcujCK+WwnbzsawnrWkXj1lXLepb3ELxsV4LG6Pofp2T9saE7XdCCYTC0MsymD/J0NDLHhJ0Irv1cjHetEDgVpX/AwOdwHuUylPxKQFm9rZsymJ8Cf4XP17k5fcNAPxBa6XlFdv7hVCWS6BRZBUkXiZS0PRPeymtw8RUQGIISzuZ4fQ1dDMKziTSgmlbm6vQjjdhcaYNN0sLsJCLBKgjUULPmsj0ZgzRBES5K3nIkpyQJo3QSpb+8VP1MdO37+8kXeVLardeDANcfFlqf41Pb9SC9CAJqNrQHVSafL4Gp/5s1EhZHK9kJjeDOC2Xasbol3D8jQuO5/CUyjpbPDFqSejfFfpNbbUDSklKpY3G1BW4RkhwrIVPMl87zsxpq7wHHGUfIUe2lAkZYaYeKW9+s8Tn8EqlxyAK+MrSKF73zrP/g4Gl5I7ch8nQpGF7uGMRvaxK8Yin0WerXm49hnMd2D4Ybi7dOvwM+8og7dZsg8INEQPSwXDOR5MYidGrKfT6IvKhlVMZ26b3uDJp3enTBGMV2saXICKOhUWl0oIvLs24xcIr69YB2uMoKWbJgLkP73AJOTxZqTlW0r/d8c1HxqtMrwU5CTl9vWr68PP3V1GnPWkNEHMDnVFIGf0U7FqKb3k16fQ0cXy0dsNvza9bukc6b6+q092azsmIlRLsA7sAolp/+I7f34qmOrzwszaOxnWWk3jQ4tG+7qmetHknD6XczrRP+OxWGZyqv0Bn969nH2oKMFdm+XE/mVDx2ea5OwTsJeBH802XBQW7Jrynh6G8/ns667SpGRfdYhTdSfnTF07/RP3cLVjqQxry2P1aroVzAS13UxVaXZgxxOv16hrJ0nr5EoRLRx+q/ZpY8cnCOSFzQyFSJE
 oZWioqIK
 zx7mhm7J5sN1GaO+1xWQfwyzilx1Px5n/I/Bn8qSNWcTXz0aNB/GDDY8Xva8tldqJzU3gYTc1vX1auN8mNtvxHu1yAlRLvU3t2/6hdef7+hzh1hJLRCgkc7MGQxMaQCfcyuuNZMs1wV5lNdjqnZQKhl61VjLV70zRE2itO1Qy4GJNbw8h3qHZcc+gtnKymvJF3p4DmAfYL7PBOSjn7UROPg0n9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 01:26:54PM -0400, Theodore Ts'o wrote:
> On Mon, Oct 13, 2025 at 04:35:17PM +0100, Kiryl Shutsemau wrote:
> > I also need to run xfstests. Unless someone can help me with this?
> > I don't have ready-to-go setup.
> 
> Sure, I've kicked off xfstests with your patch for ext4 and xfs.
> Results should be available in 2-3 hours.

No xfstests regressions were noted for ext4; the xfs test run didn't
get started due to hiccup.  I've restarted it, and can let you know
tomorrow morning.

						- Ted

