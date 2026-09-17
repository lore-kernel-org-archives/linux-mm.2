Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C3D8C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BA96B008A; Thu, 17 Sep 2026 06:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C726B0092; Thu, 17 Sep 2026 06:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D7D6B0093; Thu, 17 Sep 2026 06:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2241A6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:29:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6A47A0172
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:29:43 +0000 (UTC)
X-FDA: 85222883046.02.18E47BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24B3A80007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jV3I3UmV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789640982;
	b=NDtdpEmNwdue7TVRX511QC2Vm75spKzUOvP9HKBSXZYk22GZt+Wn/E0f/DXGD8sCEk224q
	1mobgoi5LBfPskuGPkLDOgNZyhMjwc6HItab2doLF5jHvwNacyzTnUX6NgpkMZpEuKVyS5
	r+eFmO6KpRPUPOvcKm5kdG+WIiVMGfU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jV3I3UmV;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2fdU7ZCV46uVFIhqaM+LkYuD7fWh0388vMbNgqTAGM=;
	b=LFDT/K4iwCZKlgTn4BdO66223aYHilSNakL8h2swd44H1xw0agB+GKD7wFARXJz/MEbapt
	mF5BMkgnntMbfxaNAHrPJEWN+NxLpfV4D7Vg90mRmnCL6ee3slG7YK8FYLCdWW/X4yISR9
	Y+vG44Vzo2vYZ1FrNTjTk/xagYDKLXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A83B3600D4;
	Thu, 17 Sep 2026 10:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD9D1F00899;
	Thu, 17 Sep 2026 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789640981;
	bh=A2fdU7ZCV46uVFIhqaM+LkYuD7fWh0388vMbNgqTAGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jV3I3UmViUB2+jLzp3yKXMQ3n1CJKdYKHEv8AM79KRyQbDlgrg57uHLfrDvo3ZURK
	 QlRG+rWr4lSjeEVHGGtGmN6RDlZhH9aFZE7dfZBJ3rX8+8EfY9hzuvd2gzlHidvCyG
	 eX+SPWfveocWla2CfbtdQSme2Cn3k3qYacGYuGrVUK9tXoVOApqS7opKUlSicdpi2f
	 UcmPiRkpbscmIcGUAprpKkwJdOp5HEptgQ4p4rLIdVrJMp07vWPZbrO6LIiuG8V2AQ
	 vkBQ7UUQ+U+rQNMEYVx6d76andzLuLTjhTLRXMB3W2C3hhpaEpcFybAXP0bjTAsJ2u
	 kCPQDrqx3fq4Q==
Date: Thu, 17 Sep 2026 11:29:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, baohua@kernel.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low
 swapcache
Message-ID: <aqvA_tm8vSLyUWqe@gremlin>
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
 <20260906011820.382381-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906011820.382381-1-zhangbo56@xiaomi.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 24B3A80007
X-Rspam-User: 
X-Stat-Signature: dpkwwbgoo698zrm415m818na3tnhdn95
X-HE-Tag: 1789640981-788677
X-HE-Meta: U2FsdGVkX1+j0wuWQWQhsj9ralpkY0l4vTtiCyp/ofPRFvvVn15H/L/FGUgmgY82YLTDKlAxZNh5zh8b1IZv/0a4bdQnsqMeFDHyyRIJIyNu/t0N3EcYtGLUOWBAXMTdDsCp+9xBFz+U3c6RyfxQk8bjQHbWagkDtZIXlkXmq2JJkm8/Cgt8PkSinQ5tJJySUxKZqQsLLOkH3T/rwR82OA+tZ9jx31a5xBaXSYUnsQr2RSvMUePa8mv7XCaiJhjukSH+QwNPQVOwvSLcO5ql536G4GLIc1/FU4XdDEOcxAq4proYzgv57dfMiliL9CfQILXVUBQf/AMpO91NKR5/w+lubRAM0PTOpHYhHmTRkvij8zMKZXEf1WphlVqXOCLT63m88p8+3NjWVk3q4CrvzNxu7F5YMMXBRzmuu8o0rfx2wBTo6ZN8JTBMezB87F7TfhPhwrQ4gXWLM0tC3vxj3DXjR8l7DZc10wnVUPJ4TodfjQ20sgdbOK/Xh239su6Uwki7zFTqdzb9taqxWczDN0x45WtxCy+yC9b7zkkVI/wDTPl+arlqG0ib5ZB17Z3xqTl46H/ghyPj5/kt2zKi6PxL2NDloK1uNzKRVXYN4bMOsJhAuxycnbXiMH7PC5ITQPnLJ+nXmUX8FhDGgehnj92FjmMlKgNpV/3DN6PyXoEXPU0Ikl70de4FHHcW2/g8FJqhZ57+7U6cZ4ST2SPUJZ7dx5UAgzs+5e0+JnucXR0dOmo+q7ZvdUVyyrsmaPEylFzrtawo/sTVCZkhXOFor9Gb3MeGiC3DghWoZ50HIzPIDxg39GqPGM+GMiClpOs4KBP4yUX0CdspPUlEpvulgZbFAFb3u3Rb0QWi+6xm07rGYDW4snResAv9sElKlM3v6afenxA8l5MZCf1p1hGSzp66W2n5ExOZ6xjolLCSE1NxQCSby38ttbc0Vd+lVcOzHEGvHCIljWlaDlUPbey
 2jhLtxa6
 d9WB6qLUHBRIpzrnqyOqep5y/uyxmJ7nP1o7Sjt1gaIE8vBK2ogcqlEskLNNJnRrTnnzweZxWVRskLYQo+hW1+leC6wakILLFNZqZ3xyzWt0B1FKo2o+oTSSu/PQCfquo13hdHwo5Q0W0SIwbiRd1y0MybQ1aQlm6oUZOUWkEPSl4yf3Up18ixCV34kOvnJooLdfCjS32PuDwg497TQLuo4m2ZUEz2A0QBdfgZJ88ryv7TQ0NxOHm2uRHVHNr3bSEIgVLG6WlLC39yyDcUWx5OqESC3gonqz6DTK8jziK37YKrCJJqA6exGBkPajctq6116KaQi+uOqMfRFIOYL673CdeWs3fDSTZtMZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is the friendly patch-bot of Lorenzo Stoakes.

You have sent him a patch that has triggered this response.

He used to manually respond to these common problems, but in order to save
his sanity (he kept writing the same thing over and over, yet to different
people), I was created.

Hopefully you will not take offence and will fix the problem in your patch
and resubmit it so that it can be accepted into the Linux kernel tree.

When sending emails to mm:

New revisions sent in-reply-to mail

Please always send new revisions of series individually, not in-reply-to
any other email.

The easiest way of accomplishing this is to use b4 [0] (the recommended
way of sending patches to mm), otherwise format patches like this:

For a patch series, e.g. at v2:

$ git format-patch -v2 --cover-letter --thread ...

For an individual patch, e.g. at v2:

$ git format-patch -v2 HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

--
Cheers, Lorenzo

