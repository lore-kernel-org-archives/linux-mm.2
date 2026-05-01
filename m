Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A967CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DA26B0005; Fri,  1 May 2026 13:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745816B008A; Fri,  1 May 2026 13:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681CB6B008C; Fri,  1 May 2026 13:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54F076B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:09:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04B3EA01CD
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:09:42 +0000 (UTC)
X-FDA: 84719487846.16.EC75F93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4768420018
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:09:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OX2L1x4x;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777655381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCKpiD8Crlk0uEQZs9vyjBCgLqxVn32/cxl6Y0AtRGE=;
	b=8QV38VnzEm+3myJtvvDGjW+EEAUBdg9GfltxjHYpxHsfYzLjob4ekAEXcnQExbIJ9Rw+NX
	YlxoWAqSgflBGE+B71QYEY/0kOD/IAD+vA9myFc0MWh1T5ctPph5ybre6ExCG13H8ceiGh
	a/8lvLcjILDPB0WW+CGV7dy14En8kEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777655381; a=rsa-sha256;
	cv=none;
	b=Vj7Os88UC3MN1c/z8qYolaVmOcNHSaOetje/RqR+IQMGIUDzfRjiGgnth76eRxwL4fqCQJ
	9n/d7T268IgbKEPQcNcN0HpyrVSYzgtGg7zN6EBLcEFErHKhBna+veY8PM21Lp7KfJPcHy
	yT3s+nEzuIKz/WSLB/K4Pdds7GmFeHY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OX2L1x4x;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE7D143E9A;
	Fri,  1 May 2026 17:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC2AC2BCB4;
	Fri,  1 May 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777655379;
	bh=aCKpiD8Crlk0uEQZs9vyjBCgLqxVn32/cxl6Y0AtRGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OX2L1x4xFIxbScfPDUbir6mmS+xdX9NmUYzJR0EJkE7ri86qbaeUTkDb4jWI5oeb+
	 aN4JbRR+N5UIrCNNa22w2pCZ2JSMSHoSZwNy2T2qFiVEenmDxH9tkupv+ZDyGU2ObI
	 654hr8gYpcXDtcmeRIPh1KdMIPoWk95vpdUy3GSPXi4IHKF8A7wxn55TDFMfm9T3X7
	 2RVfuwK5n/jkaekIr44u2S02mSaPb7gcycVdlcOtlmx86ngcN1rcmImzOHzRA44jyl
	 l2G+a79TnBeaUy0DKnFo0u2dmfaqSvsLz/R2tzsXHpnuJk6XOz3vggn1h43+SNrKA+
	 0+Ne8WhoVmpcw==
Date: Fri, 1 May 2026 18:09:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afTeKp90wGNixIOX@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <afTKsSj0i-ZkRZN5@lucifer>
 <afTPamwDbtY_tgk_@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afTPamwDbtY_tgk_@casper.infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4768420018
X-Rspam-User: 
X-Stat-Signature: g7s5sxi8kai1rw7rkt5iib9i85ceezt9
X-HE-Tag: 1777655381-209414
X-HE-Meta: U2FsdGVkX18S1XyC9XY7XnVF3Rdu8GMrA7OIoke8+gBsrCV2pjxuf8nLAYoQrm0f8GZ3jbr5X69xptWH8InpYmuClJ7n7Tn2xVQ3BPDW90Gt366UOMQYgJ+b8OztiucIw1qU8QN7L7BKh+4CP88WTKi3H16C3NYF5VZpjtyGd3Y68tYdKkgcY+a6xCr5DtaKFgX/lB/rTwdyr5Ih+IimaZxlTYt75YPhgV5RFcW3L4OSKIE7xuQIP3DJQ6aiyVXCtDNmigRqpcyecUeqB3d69bfLj1Uc+tZkDdLx0mhF8jp9GbuU5BL2PWch643ODM2N+8kUzdhzEkJjRJirswdaBZR4flaBM4YHITvkAtnUgbC9gmZlTydEBKje53ezum8O0pkD5Tdbu1za10usqpg5YPZmFB2aAZi39b31YytHLnocEECSsWf3izYSgpzwC6+KieNXQAaG5aZuJVfB+rwf1e8QFscTJJJTg3QMYzqWJw9fGT+I4kjyKBy+ClWAcNhvzYguhEBT+ZLqFTCvxDgBCEKkc8cnIO2Fcwy2nK7PLKbtpCCyid4bZ/Q/oVsojM98zUvCnPaGasWj6LGqawecJu4JQWcXzkuIZb21fgw06zXYuGwdBRm8Dwnr0Fm8XX7dEIUh8qxSNRw/nu/TthmjiPbB92zkYJtLFOE1n20k8/Hd7sb3Ai8BvuXETPMeQzeJn1X+3Dxjy/AWWD7bhtaEaxrsDl5KB6DR8aL4+xNs0yXAiQ4QMvfp6VCJQgADPkGCIrYyzlCaIDnstWvEYKYep9noVps73rcvbH9TeG7LrZ2xvEEUqZRh1kRjpEPE00YYHJ4XsrrMEntw+bCNXnaac4k3joiXVBbntCfbAMqkB8zOvOza3fjtS4fZEQ8fgp32/u8R26E0JroSJvMjXm9VPhljAUOZSUSHdQ0JtI8QDiiVPe1IZClE4RUgHtyhlO1QKzo+gwdhsS/dp0ZD0Gm
 5/qRih6b
 AWMoDSqPdUpBT5R6q7NMQZuPmS001IGLMQ0xX6L6jJRKsi3AC66VEMlgsywtur3G+U7BpgHY3/8FO2y6CbqG5PN3oq0+1eGtxM8Il1vxt7fV+20Pm/8uaMrOJuWBrNseYbypDFkEE9F+TC8UpGdK5nAGJ9lMay8megXAXNHVe7oZCdqZYzKdoqdz8TLFX3/ubxeb1v4IVHb2IAGSv44q0DF+WOkksSuY1e9Bu+vtw6C3BF/6dz/uQc5BdhxOqc5OnZ8dnv/QIbuocq8Kj6+OU05bO4NN4nNTEMhCehR1S5++jr0w8LUb06zMYoTOrTTb5PvQzmmnTEZrWwXueZMzu6kQdlzqh3yQvIAH6V0k/XuXdaHvDZ1HPffgc6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 05:06:02PM +0100, Matthew Wilcox wrote:
> On Fri, May 01, 2026 at 04:52:12PM +0100, Lorenzo Stoakes wrote:
> > After a brief eyeball I share Matthew's assessment, I really don't like this
> > series, it's piling on complexity for what seem like niche cases.
>
> I don't think they're niche cases ... I think it's a real problem.
> While our current code performs better for this workload than the
> pre-vma-lock code did, it doesn't perform as well as it could.
>
> > We already have enough weirdness in fault code honestly.
> >
> > Let's maybe discuss at LSF if you're attending?
>
> Not only is he attending, there's a topic scheduled (currently 10:30 on
> Wednesday).

Well then, let's revisit this in person in Zagreb :)

Cheers, Lorenzo

