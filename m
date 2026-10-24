Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBFF0606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/+QLq+u
Received: by kanga.kvack.org (Postfix)
	id D50486B05B0; Sat, 24 Oct 2026 13:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29516B05B1; Sat, 24 Oct 2026 13:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EE16B05B2; Sat, 24 Oct 2026 13:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5936B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 13:59:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3091E8026B
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:59:05 +0000 (UTC)
X-FDA: 85358281050.26.2062ECA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 930428000A
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 17:59:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/+QLq+u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792864743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wn6LUunGIyzmVYEoJnx2e0JItf3hv7Cqz4SK0g8TuiA=;
	b=6IwK6sTO7bL3IsPdFNTI4sWlFYiKkt/WULQBPKLm5l20/q94rAbXdJ9cZeoAokJzx6GuQN
	MmjzOjOnrsz7qvXQVoqnMxOfv8Jjz5O56P3qnGqiu58xpL6oCO/3OJZ58BjbcBSd7zr0kO
	wYhrTMQDsIACC22EWy6K1Mlglgn0FdI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/+QLq+u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792864743;
	b=Lu9zKzzgxVs+wzIgJ5fDIvazZYRso/Qynp9Ep5Zw16I3NBmidz9n922GYh/zxjfaeBGBRi
	/R7wDh29n07S311P+eGmAneBBFFuxEtIC+m/Q/fwdn9HwCwFC4hji4lXYPagOPr3KtpXOq
	Dj11Gm/t+NOXxmz+KUHHZq2t+lIVdQ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D091D601DE;
	Sat, 24 Oct 2026 17:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167911F01828;
	Sat, 24 Oct 2026 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792864742;
	bh=wn6LUunGIyzmVYEoJnx2e0JItf3hv7Cqz4SK0g8TuiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/+QLq+uHY9+iyfrZ36J0jyEXPAPsXKqg63TZD5OGSFtSDbB7I2I5QXYJV4tqedn0
	 bc2iNK+u5q11BDWgIQrWP562ElPINCxorvSR9qLTV/kXnUeeiQk3hnfeOxTL4XbCIF
	 HcLSPhUm0rBK4jjhrpLtkm6uPd/mDLJzsPqWc4ZbO3XUA9FQqL+TRq5xm49J+Ofage
	 nCIESaVA/YX4k/oSriQZTEAqjbU+IIcXffb+ahZEABHRwv7ES7a9o+aEsgv3HPxtRt
	 tXoLEMNttdtlafvsmK2oNtMAImURhmZ9PE3qXLdF9GTnMgq5XiPA7YrOENrvQP107z
	 n5pEWJ9YINWCw==
From: SJ Park <sj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: SJ Park <sj@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org
Subject: Re: [Linux Memory Hotness and Promotion] Notes from October 22, 2026
Date: Sat, 24 Oct 2026 10:58:54 -0700
Message-ID: <20261024175855.81607-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a4676b13-ffca-636f-4590-640a1adbe422@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 930428000A
X-Stat-Signature: n4awcgazfn777sxs31j9fnwnmpokxgta
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792864743-918570
X-HE-Meta: U2FsdGVkX1/dIPE326KRue8xcVhFogLuzCK49x5qNtu6qMvisHN+DQzY/0NwytUOxHNPRTd1WY/zMnD+R52G7dS4yPsrYsUp+bfE2cPUkizPIqCjZgrdG5SXHRqCWm916WJX7/akTxBeX5SdN0XgXXHUl5AkP4zwsSQRBUqLvzej0WI8lGZDZXD47gmyn8Bol9o6gtxtrYCh7H8Sr8VsBO6anix++BTgcgWLlWQit9hZRQNoRqdssYubL8sqvKBcUSaJmawRE4VqeqqbiECKa+aGAwwJfBFiD+IcPoQn5A7+C1Lu7NuQttAHoNJZcE+TDO9tfoXsWXKEH+RRhUOV/7MDcsKpNvUV/sM+xdREKOvYBRMzX18DzLWj4f5DXRgLyYNkWNX3O8RgQwEZFqjvYc1k/4f3GikD54oWoMYu4q8PGX8GXNp87XJdEp4qtqleePo+Nd2VA1ZR5dL1175bManQeD7NeoRlQ9rJDSaZ9mxrCI42KLqnKRkzLljVCCxNz7upYvoLyqtuUjBfL1sO7QSPlibmVIoIe78HkJrN7d/W7n4xiyVQPxk3MkEG+eQkkMp7hRU1sMt2MDpVzKxsQgTymOTY0kNs7nzgWTv3FpcVHvT/6GTQeAc18nDXP4+HORD7GbXnLOXK5MSvLNtjgmSo0nUMsOfluKdNwyOI7Y95wYwrqa7uK+FJ0SwueUD1YU+ihtdJ04Jn29VWxyHPLqTCazr0ae6Eld0KrZz0rZ8tq/K9fEm3lXc7x+SNeK96CPn0a6vdsCDqLR479E1wunjWVAeK70RMGKwcVSyqKYZvrjmx/Ud3FX5+w0rakNYYFjyCqj8GkDuSlzK34LHo4rk0RgUAVuOzTaCA+QTtZmKrQGQm+i4qJVnXsyH8XQG29XKnGegPa5RcFEM/BOThH4e1qiqH/mIT7hOuJDJ480kOpP5ipwjyuQZv2L8f7GsPi2ZVqWCsdZbgMHAYuT9
 ikR5KusY
 c4s4/AwprY/F3b46FhY7NOQIv/qbfWB3xGv3AkNAqkDTGgbupUs9yE/1/nWFC8LcuXjuk+dPBrnfi0cV4Vw6U/L93lLfFlTf3SYW56mXvC0HZ0YCSKDxg99svzqoRyVBkVSypzMGgB07guEEAra9zYEnZhQcOErzmF0QScUHRSKaU489xF2+ke/x3vdjCgesZe5hwgqcQiyiHja9lbjNwwjn9JZ0RnVbh19Jg2RqCMdcHDQWT4YkuCnNhxwl9TLZlkS5ml7w9nd88W4RBVE9+aW4oWmHBF5HVxcPc/wukUkbHoDCj3oILPCPMxztyzKfXMN/aH/Wo6izqt9mViKhAr4B6CUvCLckb+SrTXtjzy+OmvzhSV39idIoc4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,


Thank you for sharing these nice notes!  I unforunately keep being unable to
join the meeting, so these notes are very helpful.

On Fri, 23 Oct 2026 20:14:53 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Hi everybody,
> 
> Here are the notes from the last Linux Memory Hotness and Promotion call
> that happened on Thursday, October 22.  Thanks to everybody who was 
> involved!
> 
> These notes are intended to bring people up to speed who could not attend 
> the call as well as keep the conversation going in between meetings.
[...]
> Davidlohr noted that this matched his expectation and that he is working 
> on upstreaming the CHMU support as a CXL driver, currently using DAMON as 
> its backend.  He'll then wait to see the outcome of the other patch series 
> in parallel.  Jonathan questioned how integration with DAMON would be done 
> to eventually support the asynchronous promotion stuff.  Davidlohr said 
> this would be done in the most generic way as possible.  CHMU has a 
> natural interface with ranges and large continguous chunks of memory that 
> can be passed to any interface.  If pghot is confined to the NUMA 
> Balancing aspects, then CHMU wouldn't be integrated with it.  Jonathan 
> asked if we're really getting large contiguous chunks of memory from the 
> CHMU and Davidlohr said this is what he is seeing in his evaluation.

Makes sense to me.  If CHMU can find address ranges of hot memory, it could
directly ask DAMOS to migrate those to a specific node.  DAMOS does not provide
such interface for now.  We could implement new API like damos_add_folios(),
which I proposed at LSFMMBPF'25.  For CHMU, I think it could be easier if the
API receives address ranges instead of folios.

Yet another idea is let users ask DAMON to do everything.  That is, DAMON will
turn on CHMU, get the hot memory information from it, and do the migration all
by itself.  DAMON sysfs ABI would need to be extended for CHMU configuration.

Both look doable to me.  Davidlohr may have a much better idea.  In any case, I
will be happy to help as always.  Please don't hesitate to reach out even if it
is only for internal prototyping that doesn't pursue upstreaming.

> 
> Bharata suggested it may be difficult to get the configuration of DAMON 
> correct, this is a complex undertaking.  If the only way to use CHMU is 
> through DAMON, this may be challenging.  Davidlohr agreed the 
> configuration was more complex but if you're going to go out and buy a 
> CHMU supported device then you can likely configure this correctly.

We (DAMON community) provide and support a auto-tuning based DAMON
configuration for general memory tiering on 2 nodes setup [1].  The support
means that if a user tried it and find it doesn't work as expected, they can
reach out to DAMON community for help.  In the case, we will help investigating
the issue and provide solutions.  We also merge back the solution to the
configuration and DAMON itself.

Of course our support is not constrained to only the auto-tuning based
configuration.  We samely help for any custom configuration usages.

Some people indeed trying the auto-tuning based config and reaching out to us
in the way.  We are helping them and improve DAMON.  I believe it will be
similar for CHMU case.

DAMON is an open source project that is actively maintained, supported and open
to changes.  Please feel free to ask questions and changes.

[1] https://github.com/damonitor/damo/blob/next/scripts/mem_tier.sh


Thanks,
SJ

[...]

