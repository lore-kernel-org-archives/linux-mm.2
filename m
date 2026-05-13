Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8317DCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3B26B0093; Wed, 13 May 2026 03:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84666B009B; Wed, 13 May 2026 03:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A1A6B009D; Wed, 13 May 2026 03:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB0BC6B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:58:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41B86C27D3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:58:46 +0000 (UTC)
X-FDA: 84761645052.08.67CF941
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E305100005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:58:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7A9hVUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778659124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrkBN/u+6ltGDhsPgBXFUoHF7FkgQq1LPDjGfY01vJ8=;
	b=4VBDORHHMC8YJINraRQSXRCbxJfZ/H5mRKxq/sFJ//X5PqTcxgu2ne2DDY8y7yYQe6WvnB
	diIeoQuHi+zEhlAEQUjRCt7Cki7xjJgzm6XwYjnEhtWQyDsQ8BfRk0SLbGdJYhJ54SI5b/
	dQ8TQMEC5hcZJwxtZ31zat0fjxNdgNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778659124; a=rsa-sha256;
	cv=none;
	b=L/RghLYKWbjnWj34t54YOzb1awyTRMugh3YjeW8699HrZV9QWGYiSA33IMikkiK1hBwQyQ
	/9+JChvwuZ1WLCDljYiuQzjBP9Rk28SygcEvp5BNFoJo8/4xmGqHkDZFq6Df/67cOiQ2x8
	yveVnwfbxpCBJf1jMjc1GRplLbgsHo4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7A9hVUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7BE260120;
	Wed, 13 May 2026 07:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FF3C2BCB7;
	Wed, 13 May 2026 07:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778659123;
	bh=ZFOLhdTLTDwHAC91xE1k1QxOntVrUq2R8VzrDX/0eKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N7A9hVUV0qRwGIlPSwv6zb8J15Avw/8OiY0tC2pYfT3vAImBYoTK+1lI8++KSnfTQ
	 enquvQ1kQFG5q2SLMBOMl5LIdaa3HrPz8yfV/mB+IPtRZ9EwSTq915aLv9gnYaUSZ0
	 2czee33FVo8GdHO98/Unlcwyp8wZLK0wN4oPZakxBFnLVZVt/BEiOmCdWJRI4N+cY+
	 3MR1Iv22FF+LhxmqxonfMaEmbjDzyvgI6p8HLq6tmndsgXMGnxPjs/zzCmTTAuJh8z
	 ofabM7G9g1LGbCLvCfh554V2u3vKBFrubmNJsMCnPLUeVj1Xtx7dZ5jJC2Yhh6Ns+W
	 0VbT0WJxHsqZQ==
Message-ID: <b37ca8a7-289e-45a0-8cbd-eb14d7453b97@kernel.org>
Date: Wed, 13 May 2026 16:58:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
 Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-10-hch@lst.de>
 <20260512170846.GJ9555@frogsfrogsfrogs> <20260513055806.GC1236@lst.de>
 <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
 <20260513074608.GA3693@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513074608.GA3693@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E305100005
X-Stat-Signature: kzukjxdqynpyhztm9ywasd8q66gx34qx
X-Rspam-User: 
X-HE-Tag: 1778659124-531914
X-HE-Meta: U2FsdGVkX1+eiUAcox5Gqlt8sIHzM8YRkpS50EFoWDx0TlO8Ox55Nm+LFKxYZ+fIPcV0Sv9HdSK3Kyo6kNSXgylJCFyDFi9eVaKJTtvtPH8+UDJQ/8E33uTUEjPNU/TGV9VRKFpeV+0tPcaGggwUQEGJp7uI4vdIwcFuutWPdj8DU+xlk5mxAgTPEA0LAucc8UakeNRrBk+5nOUlxsQYmpyzMj3ONY+hqv9RdL5avrJW4yY1vz/jL5NpGoSBO0ZyjwrsbnI6sz3gHTJMjt4Jkexdcv04XmqzjIQSate8w1cZcxfCYHMSMLaTHGB4qdsAOdp86vR+H+4TJSqo+oO/uBpe2vUB7TXuNbhPwiNUbben9NbvbcHzpD7kDrcCiGE6t83Y9xa1NtJEZhWZkkaylQcp5s1JtoAtavWUnYH5OzJJ2CXPxfX+hCI4qDBsT/BI9maTJ5+JSYUdgl1rpl2IfqlYglzbX93jwsMiLMchUlNhEWbCAEdTDFMvQOF6O1yFuAmxmCr0JFckPaJeVhOmMt7Gt3mnb4A81fCRf8BpF6hHxiQdreOCCoKgSCVYwJYdlUZERH6oygVulgL2CwnJvCTOPPWc5wELNd6B8YfuZ1dJ0MSdNn3fJa8IZ7yCOJQdBRiQ+cZN+Kp1Idf8ITrPgNZlr92ZK2DuTQAiL3LlenPszHnX0d8BK24a4vTTl7nFowFUOCF3QH1VogMGwyxpQ2KlECIsxN7AhYj6F6xhakcxM5MTuj8R57AOJfngUy8Y2D3F+BF7EwYeZS5f2HbnE/dWf4lG5V9lnRaGr74dRd36i/Iu35v6EpYzWP3GnK6sd4w3Z88kZW+PH3k+j58glDM6l6Du+n0q2WWQglpT870UXgZntQYtJHAxC83O1O/vt9wqvy+mfPu2NRs2DrzwCwf/ZzUrG1gAzhUGbwCzw9ZXP0As65BShqmmP9AMR4tF33AR5bN1LaX/lx8EEfS
 7cpRxCXS
 Eo29EL/yrr7ITaAhM63j/RkgOVtKRGift3htss3KuSDarIbr3vqFLP4oInF98ro/+r2c28Mc/KdX7gHqP/CD7nOu5VWKUK2k8rN6/usyUF2XuQd/2O/YZ+Bnyi9M34Jr3XzmvuoP1cGVHR4yiYPS1viK5YuvFpUPs+dApzDO1RnTqDju2jhtKGxTPZuwvVRUv4KU8tsmpQbsLxMjn3whzvuPB6095KLYBOOFmBcEm6zPEUWjEciPzMqtY8yNPfZhOKv+DrRKvM1o32FyHxA/DPgHXxYCVDE4VwTItzh0TQp06BOY0M6dM8mfeIO/AF4TWsMtyvVbcLpj1vqlXLGTVNek2C+tgfJtcTlESDkYYzmd5DG7sgj3pf8LzD7tGztOBwqDLgOCwXNfdXG76a8qNfzBo+sphcx+VM3JC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 16:46, Christoph Hellwig wrote:
> On Wed, May 13, 2026 at 04:44:53PM +0900, Damien Le Moal wrote:
>> Hmmm... With zonefs, swap files can be created on top of conventional zone
>> files. So enforcing "no swap on zoned device" here would break that.
> 
> We can check that none of the extents fall onto sequential zones instead
> of just devices.
> 
> I still wonder why you bother with swap to zonefs at all, though.

Yeah. I do not think anyone actually use that... But since it is there from the
start, kind of stuck with it now.


-- 
Damien Le Moal
Western Digital Research

