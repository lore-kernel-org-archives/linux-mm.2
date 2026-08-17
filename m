Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C910EC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA36F6B0830; Mon, 17 Aug 2026 11:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B836B0832; Mon, 17 Aug 2026 11:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69C16B0833; Mon, 17 Aug 2026 11:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3686B0830
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:37:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C0BB807C4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:37:40 +0000 (UTC)
X-FDA: 85111166280.26.A5E0691
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 302754000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:37:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=wW8JnRT3;
	spf=pass (imf17.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.173 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786981058;
	b=4lYluXIafxxNxWrMAWjoBorxhonrwG+CQkjxjPaRTh9XVy40PdGky45RerKsy9zfNqPxaO
	y1QLL6mgOekBByb0Bh5rdlHHLSfyZ6L/P5bsyItbjC6+yhuRX4gGutJ+WbZwbd1s2+fBR0
	zgmRfCIcm8lkZHGYxUHISJQKRNI3T3U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=wW8JnRT3;
	spf=pass (imf17.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.173 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786981058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zvtwet2mmperbd15jKuLJ2cEJWb4hiwaUW/F5C2XVJA=;
	b=8CcIvcUrlYQr5he/+RMYTjTo6xvINy/zGLM9XB099v57QKM89rXW1j8I7ZQNaOQzwI/Cy+
	5hsiwWtSNIyQlTXrO3ZOahKlc4bUAeRduNbsRf2/B8LU2XHp5QHThXgLj6BGpeZ3TQmaMP
	8yWh38BzMenBHydGv3LgI+paChvfI+Y=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-936dfd009d1so133585a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786981057; x=1787585857; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zvtwet2mmperbd15jKuLJ2cEJWb4hiwaUW/F5C2XVJA=;
        b=wW8JnRT3oJNCC4nw6Zd3gM0bQcCGfcSH5dPXRReC2mXKv0avysY1ewMqPm/PSkS6fi
         VR0zv9TKWQc3+M3SAZHD9vEXWYEMBez0PeFuLS4g4FWlv52WThSowNHeurEmj/6Lr7s1
         Wm6sSmwhcx9rjABatBWv+52M9kCVWeORX8qsOXME0tlQ/JbjM5T4kGBlbZ2VxnwXeRMY
         XxPGnsxntTbf2DW/r+3Gq9uFFn8vkX6SHzEK/ezJglGEvmEVZsIXVCYQ+77cRAhBqsnw
         1omv6WeLsz9qyK7kO/JOkUGzybLzSd0m9279KYt+gMXgt7Khv0tv48a4KAj/PSgTLEq2
         SagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786981057; x=1787585857;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zvtwet2mmperbd15jKuLJ2cEJWb4hiwaUW/F5C2XVJA=;
        b=VHe6e/SHK5QAhns6XozTkUq3RYw9l2yo5xI9AeZWDXRSSiUWVaRzneKq75yhu+Ojsh
         x7WZJ2h9tIWz54Kjfu06sWCHXQ5eXv3T7eg8o6T9YDBMI90KQo5JXKjSnKYsqejrXyCM
         I5imZ1iRZuSgpGsPmf2AJgtr8nR/OFZJg35j4Q8p28Za40ra0WYG7ipW7V+K048ijpHB
         hhpW2Lhb0tY6epOII1yDzDmGEwJuMetpOgve3cTwlAbWbFIaMAy/XmS00bkOc4kbi+Oe
         Q55mb0iiYuHWmJGt1J/+z8JWW6zNSWABTzeh7vT1SyUZgOUJKsv2Lr2fU2zYUuPYQogE
         wr6g==
X-Forwarded-Encrypted: i=1; AHgh+RrE2WusKlL6WVEMQBt4Gx3AoBcIuPjRP9Q6IQXdYy9B28X1hHifrTtvTa7ZbzKRy8iznvW4s36MCw==@kvack.org
X-Gm-Message-State: AOJu0Yw6jO2PszR2lbfn9KAiZkfc485OqZAAe8fb/Bii4psilPhxpq09
	fHgTQyyTwQSecMejfryBKQDu6J5RKkQdjeQ42nsAChNwEgluY1dKD1SOJZYdbvL17g==
X-Gm-Gg: AR+sD13CwsYjloJXU9iMfTvcJZflwLpZ2/kiJ5YXsrl2GN49Al0W+Dd7AANpuBPxDIL
	PhhjNs9oLB2Um0ltlV7hzCEum3uD3LySYXa9CZUFdTY2fzPU+YC6F57y2v6x0F2Y9uXP3n9107a
	gGGYfAGzFmH56kxfAMWo+AZwchi87vhEx4lf7xi2FeAhvqqaHd+nsCirdjPxcRou9VUSiDoAYKm
	E8+kuIFh+d4nQCb19xNRoBFCmhq7rBl3xElc/GCz2HLoXp1AXbjTJvL2O8vKNGgT+K//LYJRb7A
	lPPf0yzGwsIJz1ZKf0wAr5G2KEM7aYr5sdmH5QNChUrrQ0g9n23PrVDQXHpdXfkLAb1YB1xlexu
	/BHH6EIAQ8AO6XSxhmDo6F8bWbcf+10SRgIxzmWrNOHWJD2pwlNQzcs6MRT98O9zhhfuKCjPpZ6
	YJhgfgX23SdwnM2rO2e1++q9d7zhaJAmMNrsxFAdMAEQlYUJHcUVyGWRwAWx4ac2HZv6iNQOQ3C
	uE/qLw0xDSybopkd/MIas3/x6Y/nVAc
X-Received: by 2002:a05:620a:8084:b0:929:f78f:6bf9 with SMTP id af79cd13be357-93706624b9cmr2264085a.16.1786981057302;
        Mon, 17 Aug 2026 08:37:37 -0700 (PDT)
Received: from rowland.harvard.edu ([2607:fb60:1011:2006:2008:aeb7:73d7:d8ff])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937010c3304sm111069285a.5.2026.08.17.08.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:37:36 -0700 (PDT)
Date: Mon, 17 Aug 2026 11:37:34 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <2bf01548-723c-465d-8368-247a814f61eb@rowland.harvard.edu>
References: <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
 <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
 <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 302754000C
X-Stat-Signature: df7uxpk9y9fczu9coafsm9km1hzy9twu
X-HE-Tag: 1786981058-553673
X-HE-Meta: U2FsdGVkX19Asxn/P0kDJWydO58flIH0LX5UMKfm5PFjoT1o9X+DNMeIG5VKYFMzFqTCu5fj26wQDrnDekcz2M1rNt6t0ovNapV7qXymjZGkvBUBhbPyullNBkFGrwkLx7jqAQa9wZLRysj1hoO7/bsPzU5DyfT2IVV2PhkHTgndQeAoR1LcAo3heaU080gpE1zazLWgRB6gYilfttbcIezeV7R+CboKsqYbdaTeTf1/Gs3ZWl6g5u0ThkbeUfpD0X/zVEZLCVq6OYxY8oPh95/v8IeS9aD61e6GQE1g/cgic9VD8wzHW9bLmZWpWEkrVBaI8BfXTqYYheolpbvUvGWYmEQale1sadbseT0GkZijHGnzB18QinVt9EotWzIil+dGK7QI2zGoFu9o/THRjS7AWb2S+I+kjV7cQg7AHavw15cOqPFkWx0FgQF/8No/DVhPALfau6rf4R0xE78prk1H8wpXpT4WAsn1TodRAwcxjQGLkmHdpTSLQmgpz5rjwiT2cim0KlMa/scPJ29CwCzZNLxRiJfheMdz3uM0KaCwue9hoYIJQFelU5unHqPMLeLJESw51dzTDlEGhK4+ulLtU7Ur0nhGnf9+vhNyvIOJPcgS9erMuUQ8F28C4fxghQ+DC1GswVkO0oyXOy6Hrj0fUKi1EAV2m8YnDr6LTOOTmaF50MQHcNJ5fXYn0E7+G/X7V/028+3RiVhH8Mc77HCwyuFZDa5aW9mDxZnD/qeVhq6aUXKKl3D52kDbcQmWHXvX/xRAnTy+/Pj1xZ05rZ60rjRixRrohynPescvDoeh7hWV0ZenMuVE13WQRz4pvdOsWCJrFJxDkQJlx1JqduOertriksIisAutF/9DgEnorBgv2mzBEaf/Pm7o+TVZ50ktQXZJdryuYT4dATk0S327b7SOw1Y5u2KpgTYTbgjkvOhL8MzrpsxPJT9GEkJsNhotwiqDs1qy9lFwGWQ
 5U/kAjb1
 vj/S7ZlBR9eG04DFEDhWzyD7W/JQGGcQJ9bYQML2+VTQLsmZ5DzZpBv3NtQKvjMUOd6JgMlgVqmAGnCwE1VnklFf3zjhLki9aVRgJELNOYl7hF0Krc/chpZo2nieEehvMe0SFPEBYWv2AKHMZIf+aIRTaPo6qJZcUbwqj3MFd9xIXuEimi48YGqaUzAnK31bV5yrZSf9NpqTww59lixqbesRAOL0YPl41Endzexn5HEB+K353Eg45PezRxerh07oBZ38e72Prgx/BHd3Qk/vcnt0kYrbjK7QZqKV9FWyWGhJJZKfGX8cu771fPoXrjYlWR75ZSP2zUnqVdnA7FXNqxWabbJt10Dqywyp6h3+6Vav8e8qMSmuRt0dmM72GBLSD4W0rJLf5L/NEtAOzh5FNtNAW3arqDE04uvONp7BcVHKBs031+5hJdFeYXcxVUqdZXP/WfHWxWVgbel0IXW5IlzMSWff+HLFkUrpQVS4A90rKdox/cyr0AvsH8dYC9UvENVv+4eke6VofPMk2AY8801tZaynS2wYFlfK5ninzKfAq6RFF6fk5EoD0WnX7tiVW/FriVsqWCHv2lpdEHLYOe/Pd9riX+7HIKkD5KS/kbBwIUosloN270+qhrjKBdd9RZEvEZyB1znkL2xBGHWvU2lman2ejb67zJKj1iZtNkNTUuBdLcxiQ52pYW/aictvA6hV6L/9QrES0NkOeztjZweAxMvvnlNTdkT08Bx7JXcR3SqKl/yRdSmnHNy7zoB8XoFxijIpwQIXYNxJ6ReSnMFEfWAzjdRAjNupD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:22:47AM -0400, Zi Yan wrote:
> > Again, I disagree with some of the details of this argument in this
> > context.  For instance, if all kernel developers are supposed to know
> > that they shouldn't ask kmalloc() for more than MAX_PAGE_ORDER at the
> > risk of provoking a WARN, if this is such an important restriction, then
> > shouldn't this requirement be mentioned in the kerneldoc for kmalloc()?
> 
> 
> kmalloc is the normal method of allocating memory
> for objects smaller than page size in the kernel.

This means when you are allocating small objects, kmalloc is the normal 
way to do it.  It says nothing about what you should do when allocating 
large objects.

In particular, it doesn't say that if you ask kmalloc for more than 4 MB 
of memory, your system is likely to crash.

> See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/slab.h?h=v7.2#n1001
> 
> In this case, kmalloc is used to request > 4MB memory.
> 
> >
> > Regardless, if it is important to let kernel developers know that their
> > code is doing something wrong, why not make the WARN conditional on
> > CONFIG_EXPERT or something similar?  In other words, prevent it from
> > crashing production systems.

You didn't respond to this.

Alan Stern

