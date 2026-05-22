Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4041CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73CF6B00A3; Fri, 22 May 2026 10:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B247F6B00A5; Fri, 22 May 2026 10:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B376B00A6; Fri, 22 May 2026 10:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9292E6B00A3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:11:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3903EC2C0D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:11:34 +0000 (UTC)
X-FDA: 84795243708.26.2E40F80
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E1001A0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:11:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=lpmCqZgx;
	spf=pass (imf19.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHoK9Kgu4Ukogk/OuX5oJ2mC+IXl+XVKkhhR9Ymm7QI=;
	b=y77uXaD4DDG4+4OW6Jl3RLohE4vv8R5smhMqOO867Osv+p/9tgz7BJqkUN6Z0qn41Dlr4g
	9+hJmKgsqKj5JCyKxSlOG9EsPZYbb7cKNcyGKSmdZcUsphCxcWfCteCn0Wkqg+rzPO8niE
	MW2bq9GxXRuei2BNdzOlMnKC2B9YeJs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=lpmCqZgx;
	spf=pass (imf19.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459092; a=rsa-sha256;
	cv=none;
	b=rbQWC1LTh0y6eUgYgh01bjLJ5nHllNxJi7wW/j6paZee7liVa9YroWsb5FacauJHWVAbUk
	BL7j2/q/tJ/Mt5jg6EeJgi4V8SA3MRDZluLNum1wlYNRPZckVTflAz1X4whOeymzSPjKTA
	n5lRQsnfXlIF2NsEWbOdktWfqxikfwA=
Received: from macsyma.thunk.org (pool-173-48-115-85.bstnma.fios.verizon.net [173.48.115.85])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 64MEBFMM009434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 10:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1779459078; bh=mHoK9Kgu4Ukogk/OuX5oJ2mC+IXl+XVKkhhR9Ymm7QI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=lpmCqZgxMgz6LXGThL+FgpU/gHZm2q7cb9GG7Hmbw1HF0AaE+gTLZhx9dJOwJ0nAa
	 2x/e4DVdk6Mue88+of/m4/ffVBkjFqZKlQf1pjyNfEHE3qjYAT5bb4AA+yS6hK29dF
	 tpcNUTkTnuKZKnGb2yNXM1Xpq2G56JRBZFxvMjxungbdw4ZnXHfC9aHoYGP1zgzpe9
	 rCykZkCrU7T2G0hk7TF/PTaBZd6uVu1liAacXiKKP6Mtbrh5RAchLbF0HPslHhm0PS
	 hlvO2wQHeMa+U19lqVyv1mhCKetcXnea+xjcMVpqrI/U8nWD/W6aAO3aYuPE2RV/Mq
	 Mp2pkRBJcpAFA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 38EDE69D5323; Fri, 22 May 2026 10:11:15 -0400 (EDT)
Date: Fri, 22 May 2026 10:11:15 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Akilesh Kailash <akailash@google.com>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <20260522141115.GA8258@macsyma-wired.lan>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ag_OVwPF49LSZ7rz@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E1001A0009
X-Rspam-User: 
X-Stat-Signature: zuiysnqqt3sx7hdaxq5kc519ko9x76zn
X-HE-Tag: 1779459092-257196
X-HE-Meta: U2FsdGVkX1+E/n9fKhN5ZiEltj/rcpjstnX2dDOAYBWlDAC4FlhSPgxlqsTa7U9POj5AzzfWj0g5LMmP0pD6dmwmaiJ24eWMn9ZXng4gjxzU6kHavEf1KYbMHbcrYB+tJVzhPYfcbVeJNsedgjWv1Jh2lZI0PcPvXFwO0hIwGW+X3u2krUQBCJsvM+SYUEge4mcYtZsliq8JM/P6ZugsLbw+WuvW4jFj0hnTv4p1q3dgWjT3xjVpyCYytfbxgYeWDu8EMzY69RwcrvRqvDTooCMWWewPKP2uxcUcsVYCatE2DcQgFQ+WbeazC5vZgy2u03GtBAHEjd7sECApibCYwMPWwixVp/w0eimUZyA3HQGPRu/4Ui1Yu3ztA3mQmSplbdpJEQgwVAta3bc7BGc63m/sIX0ClFK4yeiJrYZG5BBwMrojk+nfu8QfzMKoIyl8bvX4MCranNgkSRDKh9178FPUUlCHAP3E6VLnjYZ/AExMH/fz1PrGe+J9hjpA+ZeexonSM/Sl2vScinIFrDqxnhMnLIVvE0gSXPpCnTXZtwQu9Bwh+775G/0tlZr2QqRRQqERq1p9bwzOdnBt9lQ1iAo3nCphpqjXfNn992XiJJf2o/aU/fqrGYfHnBQ2WFOsjtF1qvposgPlu9D0iBjtbG6XaEP3FWEXdOBER/GEvN1mFntdZrswDiZUgE8PcEJgDOew6cp+UOf0NKhiaXnaV69x7ecnbsh0YKVcrPumBl1Myf9rVEbe2tVu3cOsa4m8hcLvUmcJaA1t7JIRnH3YD/fjQA/L/QluCujhz0+L9KL32QG2UK8AhGS6+lMMf0Kcofkx4FA6XlaF0Zm1TSMuXQkgVgrqnT1cQJ0zl62grdM8WJk0jd2QkWGFCYYks5hpGt+mfCzHIc4KH5kzqrUmeq/+iS3vD3ltYxxbiYrPs4mAotMa+1cY06FeZOEQISqmWL9I+S2xUqySdp5fEwO
 JhiB/YEu
 eW6t7x4PwqDn5wcv6DQ7JQEgeKxiCV6n2tCBC7gmdB7/9B8SltxwYTWUIhRxwqbdJnqfTvI0bf+XPTP4YyrzqSyBqba3cn/y+7hOlkXPdfIGcNC99fNDG79PAiBd7qYloeBp2rK879T9JVxyyoLTm1URG8uEm5g2shGyT1tcsiuxtoL/SZw5BBfbGebk/o+diICbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> I went this route because Android heavily restricts ioctl() permissions
> and we needed broader access for this to work within the framework. It’s
> definitely a pragmatic choice just to get it running in production.
> 
> If ioctl() is a right way for upstream, I'm happy to change this patch. By
> the way, I really don't understand why all the messages are so offensive,
> even without trying to understand the problem or guiding right directions.

The reason why some people were getting annoyed was because as a Linux
file system maintainer, there was an assumption that you would
understand that extended attributes --- especially in the user.*
namespace --- have an intended use case of storing a user-chosen small
piece of metadata that would be stored in the file system.

Hijacking user.fadvise such that it no longer persistent stores an
extended attribute for one specific file system --- such that if a
hypothetical user application might decide to store a piece of
application data in the extended attribute named "fadvise" would do
something completely different on a single mainline file system is in
such poor taste that I would have *hoped* that any Linux file system
maintainer would know that this a Really Bad Thing, such that if
someone in your development community suggested such an idea, you
would reject it.

And then, when people complained that it was a bad idea, and you
decided to put in the f2fs branch, such that it would show up in
linux-next, and there was no way for other file system developers to
object (short of appealing to Linus) --- well, that's basically you
taking advantage of your file system maintainer privileges.  And this
is why I started proposing whether we needed to appeal this to Linus
so he could make the call to reject something that the community had
already told you was in terrible, terrible taste.

As far as trying to understand why you were doing this --- I have to
turn that question around.  Why didn't *you* explain why you needed to
do this thing?  I went through the e-mail history, and I couldn't find
an explanation of why you decided to do this thing.  

Perhaps we need to add an explanation the Documentation directory
explaining what the intended use of the extended attribute case, and
perhaps referencing past cases were people tried to use this to bypass
the linux-api review process (f2fs's user.fadvise is not the first
time someone has tried to do this) thing), so that automated review
bots like Sashiko can explain why it's in such terrible taste to patch
authors, perhaps we need to do this.  Up until now, I think the
assumption is that file system maintainers would know something this
self-evident, and if not, if it was pointed out, they wouldn't try to
force such an ill-advised interface to Linus.

						- Ted

P.S.  As an exmaple of how I hanlded a somewhat similar scenario in
the past, my employer's cluster file system needed
FALLOC_FL_NO_HIDE_STALE to save $$$$ in TCO storage costs.  But the
concern was this would be an attractive nuisance for enterprise distro
users, who would see the massive performance increase, not realize
that this would leak stale data, which could result in user PII being
exposed, thus making life hard for Enterprise Linux's reputation.
(This wasn't an issue at $WORK because we enrypt all data at rest, and
the cluster file system daemon was a privileged server who (a) knew
what it was doing, and (b) only it would have access to set
FALLOC_FL_NO_HIDE_STALE.)

I disclosed *why* $WORK needed such a thing (it made a huge difference
to storage TCO costss for Google's Cluster Filesystem), and after
discussion and negotiation, we came to a compromise which involved my
keeping the (very small) patch out of tree, but reserving the code
point upstream to avoid future bitfield collisions.  They key here was
that I *knew* it was controversial, and I understood what problems it
might cause in the rest of the ecosystem.  That's part of the job of a
maintainer, and it's also why a company might want to hire a
maintainer.  They can represent the needs of multiple stakeholders ---
the upstream community, upstream users and the greater Linux
ecosystem, as well as their employer.

