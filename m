Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1F8FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 17:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620E16B0005; Sun, 26 Apr 2026 13:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1EB6B008A; Sun, 26 Apr 2026 13:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7756B008C; Sun, 26 Apr 2026 13:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0036B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:55:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD9D31B831F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:55:36 +0000 (UTC)
X-FDA: 84701459472.11.0AF8F76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0768740008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:55:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2QepOV6Z;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777226135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBOxJbyLC0+i6Wr0NOJS45bkPnMEf8c4isJpaouQifQ=;
	b=aSal3DR+FH/KhG+ws8CRBtR8IrSz/r+slOHoQ45flrID2U5ewe1Gix60jPZPGCDZYePkj2
	xrcS6ft56F9N9KiOKmhUbZ1l0+c3r4tPNOl/HrO8X4zjmHPbuirZuSC0mW41VnB7zGpEgi
	Ro5fBQssgylFup2TA8x9FIWb3XXHW4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777226135; a=rsa-sha256;
	cv=none;
	b=BTBD6pyUEdUuhvgqsqBefyBBOj2QfGMbJ7+dTfSsNOTxJjdsCJe3o7KspaVByRoaT6Bd0x
	CQwhsUXhPXgfCLJnSrueRy0MOkTpNyYEttsvztASIHGYVh42+Lj4nZGlDC1ce0p2Yudp0t
	4PlwmS3xBigxM7r+zBjLgMkgjTOh8sA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2QepOV6Z;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0FE641B0F;
	Sun, 26 Apr 2026 17:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553F2C2BCAF;
	Sun, 26 Apr 2026 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777226133;
	bh=mXOS8t04jSzoeTj2rqO9CLfoH5hEFOMVTL70yfmZC0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2QepOV6Z61ReiTObECNklIqDbeOPTElm/Pi8Xa0fndJCSHLwVfVhlKALqwFCTGf28
	 SXZkvKI9v17XSGxHsNJA/NA+EUMMMrtQfJ1pD60FhHMoIlOjbW8M2dHrMYK6DJMSXt
	 T5oGkHvUX7PnBy4178JQPwGRV4eeNNYgR9vtdvVw=
Date: Sun, 26 Apr 2026 10:55:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: shakeel.butt@linux.dev, syzbot
 <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
Message-Id: <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
In-Reply-To: <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
	<20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
	<e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0768740008
X-Stat-Signature: 5qgqbjsntkpxm7cfsjzakcq3wx8qqux3
X-Rspam-User: 
X-HE-Tag: 1777226134-123356
X-HE-Meta: U2FsdGVkX18Pjs9eU7RrDjDr8Ul34sppI8W3oRAOW6xj609ywC/RICEessIm35wsFt5jWcuCZPA+R5XckR7/RzASiSLybQbr6ZRKe7EwFsr2RfebPDted7ZlLqQo98g4fsqyW8echWHn2sXB7xNWJ3KoHmSoeO1iDg+tbFGPGn67fv+RjNcjwWwu+I0glqUxFOAPJjyGhZQMtQhRWNoPBbGh7c0FW1VWESVLy2VX5pe1NAKCEah1bzkziLs7BnSNTlSbxcNVj44pFVIcHF8k1ugmQX6RUMuEQ8Z5R7wCeQ5RLYUmDAMNLyYjMVVhTXqn6oWnAvrpsoRvN8UlGD4wNU62QXrKQF4K3C8KdMaJekjwDcduH9nbtM9LtaudrTTQ+EgHJciqZ2A/jZluZAeyWbfOJeM3zLTJm1BjW+JgQlfAiG7j9N2iowkA00W6FZpp9FLz/MY+Ai3MFp6DVs3qHfC9ZOICROMLOYcjlSn0WMVMbLP/ysZjHFmCQ8C6ER40P+xqj5yra+cpjiwe6ahnQ/3UEB6TE4szulJcoSXERS7dMzCY2S6/BFV/xb1qZKyu+zIZxc8UMjRdyOU5IrLG0XZZ/eHCiYRPcB0XRD9F9jorLXqXrufJ4AfWhp/0z6qsecXd7l8GwfNXs3oARdIB2yEyos6qskIp06SBFuR8yXjYcGra54f3Ru9bLH1W7ChnbrxDfq6/vDr7hX/5HtPTXHHs35XTRTOhMH89T+QIlX+DiJFQutbzfUQjcBkZfoY9bcBsB/oKjTB/ufyGmcXr3h0agGjZ2O/CnMLQMJI+TkFLsjLbr+dqN4/MwTo4tx49dqSsPNoITUQ+DWa4/LhAv4cZs3quj6knnlQXZuE0/2to+hkdhqx78pCHJzglLQ+EXD4m0JoAKLeqF6EEfxp9h8LDD2JWBjiGI6qMaatvcT98FGHCuVR/IJMnwdyDSvish0QCDeEw1wp9ldOxd/H
 sk2rtxlu
 wGHJOgZZTOCLZVSN2bc0zFm0S7TP+w55sAjX4KPJYEXPr0z5LXZAZYmmk5/NPP+Vzn46c9lZx2sq7X/Uj9whcV7yk4FBA1lnoUyEpB3BE6f6ZGeeD2z/ODjHqhIeY+WhWyx8386RVkmMA7JEQhDeSb9zfyz3s2NbxNvSEJzeblE/2TgFQTTN7DjF+WsvftgpfxUYIKhtc/1i+BeFXdHDeFelwvGcSOjqdCNKDnqNWe68rQNXXvPItdmnIn7L0z3GnpWRUQlqK8/5r8QnyR8vVDgVwITi3kDNf+js9fpJ5iSHhfMlsc8T8qWznXLktgKAjAjm0POxUzLoPfi9DBByQS7o62LHmhhm4L1Qjy6p+S7vO7bc4nlqDF01mmPyzYkoCMZXhk7R7ILEM1zUg+Opd0ZT2l7tYiclofSHr2PcrHtU94BPcRN0CyIPVCb70ior4TW33IibFfBH3BnrOioX19hv8hKMmY9DsJUZ7tyPVV38EJ+Kq0EYdkPREkVWCMD7NL5bDShLb7x++X7o447Ofm+hxtaPVdljtBWKK0pWpaZAaDuIWpDzlE8kr7oqSKfnU+fztmUMgb0qLerpXxfEtkkQE1z/UjiKDxdAAk1bMFAWaWhbaksEeHwz3/M6Q2LOnKSdcYHOHtmtywFALVZmOFhjTQKl2L1CNeAmLnI3n5/JSdW3uGkqRuTdqj9iz8IVeitXoMKPa0Wxn++Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 23:57:42 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Hi Andrew,
> 
> On 4/26/26 6:49 PM, Andrew Morton wrote:
> > On Sun, 26 Apr 2026 01:17:25 -0700 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com> wrote:
> > 
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=12483702580000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=7d60b33a8a546263da7c
> >> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> >> userspace arch: i386
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > argh, that dreaded sentence.
> > 
> > Thanks.
> > 
> > Something's definitely amiss.  This is at least the fifth report of
> > rcu_read_lock() imbalance post-7.0.  Others:
> > 
> > https://lore.kernel.org/69eab803.a00a0220.17a17.004a.GAE@google.com
> > https://lore.kernel.org/69eab803.a00a0220.17a17.004b.GAE@google.com
> > https://lore.kernel.org/69eafb0e.a00a0220.9259.0031.GAE@google.com
> > https://lore.kernel.org/69ebcbe2.a00a0220.7773.0005.GAE@google.com
> 
> All the kernel configs mentioned above include 'CONFIG_MEMCG_V1=y'.
> 
> Theoretically, a rebind_subsystems() can lead a rcu unbalance, see my
> previous discussion with Shakeel for details:
> 
> https://lore.kernel.org/all/358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev/

Right, that looks similar.

The rcu locking under lruvec_stat_mod_folio() is very simple, and that
return in get_non_dying_memcg_end() does look super suspicious.  Why
does it omit the unlock?

otoh, in
https://lore.kernel.org/all/69eafb0e.a00a0220.9259.0031.GAE@google.com/
we're trying to release an rcu_read_lock() which isn't presently held. 
But if cgroup_subsys_on_dfl() were to become false between the
get_non_dying_memcg_start/end pair, that's what would happen.

So yup, I agree, concurrent rebind_subsystems() activity could cause
all of this.  The reports are pretty common - is there some debugging
patch we can temporarily add to confirm this theory?  And/or is it
possible to cook up a selftest which will trigger this?

> However, in a production environment, this is practically impossible.

Can you expand on this?

sysbot isn't a production environment ;)

> So Shakeel and I chose to wait for a reproducer at the time. :(
> 
> > 
> > In some cases we released it too often, in other cases we failed to
> > release it.
> > 
> > The first one is slightly more useful in that it tells us that the
> > not-released rcu_read_lock() was taken in folio_lruvec_lock_irqsave().
> 
> I double-checked some callers of folio_lruvec_lock_irqsave() (such as
> folios_put_refs()), but didn't find anything suspicious. :(

Right - it's rare and smells of a race condition.


