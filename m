Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E687CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 06:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1F96B008A; Wed, 30 Jul 2025 02:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652DA6B008C; Wed, 30 Jul 2025 02:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590416B0092; Wed, 30 Jul 2025 02:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 492EE6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:31:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8C0D8041A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:31:00 +0000 (UTC)
X-FDA: 83719958280.04.F6ACB79
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20C5EA0006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:30:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rpOu97tU;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753857059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsdIZ1+Aa9Zb4OvCbgYo52FCKGd2vwNlEy0BgjnYGYI=;
	b=6gw8Is+bqigxip3GlaCsnnVIYhVszgnjAarTaJ3/ljdd70X0kOqVRpm2ZynhJ60Y+9JH4v
	eDNoQ5yOtZuwaWwbN6OBmvJqdqMCPSVskV22eQICXiMyBu/ZhgcfkIkPe0v60hHPwOLWMC
	NyRZ7/jv/VlbT/xZIGmg6y5W5cPqYiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753857059; a=rsa-sha256;
	cv=none;
	b=tWMJKjolnL1Xh0fbEykWKAp+g92175L5mXIRXBiacHWXWTktl/b8rp+K5GqKKP40lk51xI
	dhlFHCjrf2X+5NX6lIEGTUuuE+bPpj1XmeT7f9t0TIpTB63szBxOYy6kh4vQ8K7VW7qqTz
	gF9eLuab9Wb3GUrV1gUjU2z97LIBS9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rpOu97tU;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 51317A550BC;
	Wed, 30 Jul 2025 06:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8CDC4CEE7;
	Wed, 30 Jul 2025 06:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753857057;
	bh=5m2AZ35qhad3lXHXJA7t4elsAqF/q7HnQ8CqvB4/gl0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rpOu97tUQeUvQad0ivYCzxEXw0diHHGGMNcbZ7olMYb7XpTMa7eofFRVOKihJ1dCH
	 C52zPxO8001IaxGWgIr5PdH1aSOm+q0SIUdjApUnpsI5UuOymDwSuEdpfNitfVxoGp
	 C7Rwxp1Sx5hQINaQ1+aqWKAqRD92SWIGxcimmZHw=
Date: Tue, 29 Jul 2025 23:30:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, David Hildenbrand <david@redhat.com>,
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCHv4 0/3] mm/memory_hotplug: fixup crash during uevent
 handling
Message-Id: <20250729233056.c45b9c2e21ee7838434024c6@linux-foundation.org>
In-Reply-To: <907ee759-6051-4d47-bf09-cea362ac0cd9@suse.de>
References: <20250729064637.51662-1-hare@kernel.org>
	<20250729133806.979475704b1162d7aea99b2b@linux-foundation.org>
	<907ee759-6051-4d47-bf09-cea362ac0cd9@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q8tc8axw71wok6pkqeqbszdioesc3jem
X-Rspamd-Queue-Id: 20C5EA0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753857058-306899
X-HE-Meta: U2FsdGVkX1/a2jxH5WFpZ4JRXFND5Q4aInJODpNNLPnzpjG5lV4O828zFHVYsR/6hw52UKoigsxdCAgWkv7tvEmOqeq9htcyj1RQu0vLsoPsz1XIGjdHh6MA97Iebv7jxUmvcBDtzRog2RazjflQz4N288VqEHt8bLaTXJHPWfkBXyztAJMSdb9mnqKPspuq5kqDMJhfREuuuzEd4y+WJ0E3Qkyd46meEgz2mrzVc+5/okQ1Clq5AjNhqjmzNh9Rl4RzFIXseFPT62YBawVpHWbS20qiGtGuHifvXyYMe0iE+3mTqoCKgQlDzpr2t0m45qm/XyiwqrDj4TqS5GAlWV0t42mUf2iuKF09loeGdG8ibE3cheVEcGiDlarJQQ3R+VCQJte257fhmiUQauostq1vGux7CTbWeizpVK215aDgFd2FdJTbanms17M/RyfxJ7pXhtCNyh2l+soJ2bJW6fuup8jiqodN33mu9xJHtG36I3dhGsaYMdP9NahFkzMGBx2wZFJSneYoouslSbx1naQC8JLcz8pSr8BUvArdRZIgHPNunJYnj1WXucEToOz5GxtKHIetbHFZmt3ufnr3uL/xQOH2uEzLvm42AE+e6OaV6G/6wmnmarMaqcyl5Y2467d/G8E3DejRwb/TDxaF8eTezsiynIHgboxgozxbUfFKK5+bBu+PrznjD5+gAoBiSmeFVjS/Ud3U2795B8mbjIWxOvT0iH5IgzGUcxAcaHu96XE0PjmG2EUq0n0DxjSoVO15AT4TLVl3aU9mG7M5BXRRYuw57IMNVFJCRmssC+qMhQriDYzAHjUagwscraUhDQ05sXz6ntKtPyUC08MPE1GE93Tc6BLAKK+GMuJJL63pRAutpemocl8fUUDIDofdhtyKVb4N7W2y9uQFCpO32K6fxx2hUmuDPTkWV0OMmjUYDYLPoCeQMx0uFu7gjzhv/yGUzxa7BrDxBv7CiqV
 Sh5ClP5/
 3ZHuodE6EPFpukI4GN4BDngWrjCFcsEby6IOlXk9jtwO8enn/HBm8nv/F+vwcQBJj2yTgYEcuuNyanQNHxs6WHaO7fXEv/2evpTu21qVG9hicpHC7lR+LSsEe3CDawd+F4AQttmK1qYnCyMwu8CLsnBLd8cN8ymLSoXfc5PRJK24xMXXE5ZiG+VmVrdl/zXJgLjunoyCSFO1esG8BdbstsG8K0+ufGrfMixeYeMJ2t50C31PTa4ZDmiQm4N3Fkv3uByhgVRwuAP39oR4WmsJniJsflAm8iYSZy370uspnApct1se4bi4Eg+GFeSSCo8n1CNZj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 07:49:57 +0200 Hannes Reinecke <hare@suse.de> wrote:

> On 7/29/25 22:38, Andrew Morton wrote:
> > On Tue, 29 Jul 2025 08:46:33 +0200 Hannes Reinecke <hare@kernel.org> wrote:
> > be needed in earlier kernels?
> > 
> > IOW, if we wish to fix this crash in earlier kernels, I really cant use
> > this series as presented.  For now I'll add it to mm-new to get it a bit
> > of exposure while we decide what to do.
> > 
> > 
> And here's me who thought we were doing upstream work precisely to
> _not_ having to do backports :-)

Yeah, well, maybe others aren't as keen on caring for -stable but I do
think it's part of our role as kernel maintainers (as opposed to
"developers"?).  And as a large number of MM developers work at
organizations which use and ship older kernel releases, I assume
they're on board with that!

> I see if we can roll patch 1&2 into one; guess I'll need to do it
> anyway for our kernel.

You too!

Thanks.

