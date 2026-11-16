Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7A9606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0dYFo6CO
Received: by kanga.kvack.org (Postfix)
	id EE6E66B00EF; Sun, 15 Nov 2026 22:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEDA6B05B0; Sun, 15 Nov 2026 22:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBE36B05B1; Sun, 15 Nov 2026 22:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C10316B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:44:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA1051606E1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:44:08 +0000 (UTC)
X-FDA: 85439588976.29.8ED47DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0088220002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:44:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0dYFo6CO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794800647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLeSRzbCytnZXNus5jLvaHfW3mKYG8u2Hq9MNKiQaJc=;
	b=SIi8bwL26bKFNCQtPIFEOraqgkCeBNmBp8NNQVGJ57UrHyskozJ3/3q1Ib7btJCp/G4ZqI
	wtcsX2BwVi92ZRWFlUZeavkHFLfRtQZOtDPyxmu978GSo9guFFBEmkWhZMzCF2kc91kqSZ
	MgTf6UrlA3G64yCMEFqcw1QeFmzD82I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794800647;
	b=dDANP/mdM8vwXLwGIx1fccri3POljEHA1QiX5/Vs8dlb/oekS/TICQ6HFT9rbZxDY9KZex
	2f4y8vcowjE1lHYWn4x0AjOp2XX9GYeKEfgPHDtejzllQcdDM/Io4I1jMHT9bN7HALfIn4
	a3/i3Rzu2Qwg/HU8mVyIp+MxFt11h8M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0dYFo6CO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A57C61E7B;
	Mon, 16 Nov 2026 03:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D862C1F000C4;
	Mon, 16 Nov 2026 03:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794800645;
	bh=vLeSRzbCytnZXNus5jLvaHfW3mKYG8u2Hq9MNKiQaJc=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=0dYFo6COd5e4jza16vX0GgnRiQwhcpkoC72T/5GM9HYvGLzjzr0L5LvmJPsFm5zWg
	 R9Zztxn7YHiRRzbnyxYV+3KB8p4smv63q2CrSCc3/dzietkS3agZMK3NXfw6vtdWxL
	 MoBcwzGfgGf/vRXULlElKpN/Eul4Z/VCEfVmsvqI=
Date: Sun, 15 Nov 2026 19:44:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiebin Sun <jiebin.sun@intel.com>, dennis@kernel.org, tj@kernel.org,
 cl@gentwo.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 linux-rt-devel@lists.linux.dev, tim.c.chen@linux.intel.com,
 tianyou.li@intel.com, wangyang.guo@intel.com
Subject: Re: [PATCH] lib/percpu_counter: allow concurrent sums with an
 rwlock
Message-Id: <20261115194404.a8d751a7c17904c756b16b61@linux-foundation.org>
In-Reply-To: <20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
References: <20261116015655.2744577-1-jiebin.sun@intel.com>
	<20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xzoxwhybh86wuqe5c6ub1a7k84r47qra
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0088220002
X-HE-Tag: 1794800646-572960
X-HE-Meta: U2FsdGVkX1/91rb7pm5OBgjXIjUWVYAd3lRMZE/ao8hqnVEg9D2VDJtYPl8BDqZQEKqi2OfxaOFkuaADhog7hOWntdBsoW2PLgxMHeSr1ReS2uOjzZ8n68w0qjwBMrMT5oS37BFhxtBFs7gjsdGog0WdDb8d8FmGgwlPwtxoNqk35a9mlPhxQPEJvk7nf7Cr6slae8QulSDhOwEy6xPs6grwMPZWZFidomuEIrFhcBiyVMQuNFbeiWQHuWaLSjNJnxVMJwLteRM+SVE+DK7dVtdeys1zPmSyIM+TGILR4gPIYx46LCCC0v2HGCgnCudweue3ab9320RaCzQVPRWizvzZe6yF92eo0c8UXf3/E/a6xSk9lgTJbNqWFlaa8Nck2il2dDIfkp0iAuPIK/xS3iTHOoT6VRU6m/q1yPgk1ujn7tCFDJGMa63wCcapyj//bymBwezE0Q1oYO5vfFadfiQKXlxQiYqNeL5BQ+C0I6c3uVHhg9i5efijtYPsO/y0fHVnG8B4AM85E6abWOTm0QuxmvB/i3DzMvNBwsonBPuyMi8u3pGNzjlw+8n435j17Z+AteoZjDhnFe8eJGUL8tbGUBecQw9v7Juf/87Y5KwEHN5+7o8pYcBZtfY7GGy4UIPufhxOUTi+ZUhV47om2IqI2zuZF/f21LVHbn+iSuF9O1awR8adrYw2LZRK3vywzOJxTZtDa2YyC5pR+n8r1RUUfF4HiKQqdtuQ0YoJHWEoM0hVUrjoMMzxtOLPQWo32mPf5DJpDb0eyJB5wI3WquluA5S1pTvu4QvbDoa63uaXDao8oyzn+v2KevzxAfTaGKjW0hMDLatZL6V2awBMzyYKR0K+wIRQF0TT+j+3cETqk7jC251nJHt1y86BvgLzdQAw8yoiEgZs/wxA1ofTTDRjx3J1AKahJRJzIO7R/FL0ETrQifDDRDVbqLXxkRZ8KwPtE0+3eCownq7/IGX
 ECfFojuI
 tN9zb33PDWVXY6oVubugLxPACtq8NzoviwXJGUi8jINqr8KkeY29g29NeMJqOSqdbnRxyK842W5WsgtVjwLLdRfOZMYBoO7b2whz1s1eVKBgEh4breO01XIHXgYu4aGzBpkx0xIgpEbT3SU8fHJXkH5QxwN3jQkYd2ohL1je0njq8WoNTLhGlFzbuP3AQtOdCVh1qNPQKVGxhTa8rn+660hlzC2T83kMQeXByKJ/qHbpMQpJcnQKIsau6JNV40/Nzb8ymBi+20C8U6axigIMCGMZC5X7k3rOF5TkMb98o/rsNgOEpGlxhv72YfTVWh2wcPkO5P1/y6EZmRo2ovzgPopVOKmbih6Lad5PI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 19:16:36 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> > stress-ng dentry test average throughput change:
> > 
> >   +------------------------+------------+--------------------+
> >   | Case                   | Unit       | Average change (%) |
> >   +------------------------+------------+--------------------+
> >   | Dentry, 64 workers     | bogo ops/s |             +47.34 |
> >   +------------------------+------------+--------------------+
> > 
> > Dentry ran on ext4 with 64 workers pinned to physical CPUs:
> > 
> >   stress-ng --dentry 64 --dentries 4096 --timeout 20s
> 
> lol, this is a fun patch

It's *probably* OK, for sane workloads.

But if some workload is busily running percpu_counter_sum on 1000 CPUs,
how is a writer ever to get in there to spill ->counters into ->count? 

Modern rwlock_t does implement queuing, so the writer will get in
there eventually.  But nothing is simple any more - there are
complications with rwlocks on PREEMPT_RT and with interrupt-time reads
(do we even do that?).

So I think indefinite writer starvation is a risk here?

