Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE24C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935986B008C; Thu, 10 Sep 2026 18:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0856B0092; Thu, 10 Sep 2026 18:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7600B6B0093; Thu, 10 Sep 2026 18:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3056B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:03:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88E0A120158
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:39 +0000 (UTC)
X-FDA: 85199230158.25.6A52C87
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id A416D4000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHcc+qBi;
	spf=pass (imf11.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789077817;
	b=HVO7DtfKBCnsM/TZI6X1XotezgwXwJB+WXD/yfHCz/OVbw3W7jhlCFxeTIoLtcYOwRqdU2
	hWsocZbrOCEqYRrX2+JinyOw51LykgCie4tVtgcSe5ViV1ee35uGEFkP1ClRcQcs0R6Hc5
	JBdnO3DdN0bjYtPMYy6ScIj4f6d0mBk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHcc+qBi;
	spf=pass (imf11.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789077817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4VC0C0lSHCs8Fcark7cmj0Id1dSh7PB6GmHxMlnI8k=;
	b=zMsitZD2RS1Zs43aR4075znNTiMa/dchVTtG+AjYld3HuaQVzKCen0u+igrd2PytyKdAeo
	y4UWn6zFk9k+ijQWPlMCy9M/os4hq5VEXXu1xV5aSq8rjSjK+hngITKb3F7d3JN9EUO7Mv
	K7BveeSDHUwNOo9TPAXu7dLNj0J6N5A=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b30c94so22600f8f.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789077816; x=1789682616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4VC0C0lSHCs8Fcark7cmj0Id1dSh7PB6GmHxMlnI8k=;
        b=YHcc+qBixneIIQgTM7w9NtLNBSUy0+27oWev2CI5XrsOMni2Lc0GBGZ5IMqkoryo22
         Td8+eGcWFeCMW7f08czcPD5dyPygwHElGuJCbDII2ZD+9ccMbEnoEMMHtYNBD5xR1XAW
         gBfkX8gxC21kh+0Iy7B18uWonwi0kXIVJtPSvkQ935oROElL2AEHoswXC4GD/cj9QCWv
         CHwrgzH5U2XaG2jOrw+Lr3BgLq2caB8gmVOfOgcxH3TPIldRVBEn/LW0ekR46HwMn2A8
         WlrYP4+Opq1B79U2Ks5X8d7Vlje/YQtNjPmQstWA9FHqbpPMBJ/y9uVvacqdJvtmFyHO
         VLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789077816; x=1789682616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y4VC0C0lSHCs8Fcark7cmj0Id1dSh7PB6GmHxMlnI8k=;
        b=oEwC3WxAeCIC9+bb9CJJGgbflySHhoQTiV2Sd5n8dh5FMDjv4U8Q55nPUC7zIgAYdO
         MPss/RYhDbhTKg9nwGg8QVfQKHh4fzdxOgGfbA6oMi4+3iaH66NKzpm4JW6cCukJ2bpY
         JoLRXFXoRDtvYa3NioJa7J0vTyKk9z1QGbVsrcPgqZP2ILAwKOcNrq2aExzN6y6BP+BO
         0NKbIOCsUgCI3pW+4bIq4cCrii2MNK7cu8rkYJ5qX1SAVH9dTmjps9ZbsfEXVUFYiHPN
         0pk8a3h3mqxBipDmjKVaLrDplwg1LiCSYCTCG21ZAaiD77GjgSoIgcOKUPifEQOlGmFx
         fJ5A==
X-Forwarded-Encrypted: i=1; AKwUvBzh8b3LpTdQh0uNrKqX/v+lPFONVbnjU1x8BwuEUw0ZmU2SZc/7MmCUaFlJyT9NYPW1If17aH4Meg==@kvack.org
X-Gm-Message-State: AFuF++mcKxZQiu77HiUksEcSRr8lAsthirhBi6Kj/iG4XLgcZMH3XMav
	OP9VVV6BiyuP39wgCPBKQIrSWt6ZxJPcLNWyZ7seRZfV5EGXdqfdJIP9
X-Gm-Gg: AYBFou3KRG51nbedjxbjJIg03oaL2GcjfuxamZqdNMOynZwcyyWirgAIUaZm2sQ9iYa
	CFqa1eqKrVih8o7jwhf7XZK5QoUUqMqcH/kMRyrsI81R3CDSdpkHhxpMR1wNjGUO1BXRG+OAdj4
	5kxIHkFTswz2bybL8fNgi1KRDjyqNTe+6pIsgcFltfw/Y6ZnE8pHASBBU1X/ajgGw0Cm2osMVoq
	HrDa9IBoDTT1jkH7nUBYkCLrBWT6SuzYntMndmAUgmYXg+/2btXgXKx8hw8rHrF02ouqvfbRIOf
	J1xXgWKrLUgfbCl11xguFkkSAjlQsZdctu51VPh41hCa10lLYzlRYVkBR0yJKYkmJIx+Uxzqqpn
	OBWB/Gd1twdrQSs0z+pWtLcRkTfU6UWQgoqnvDTDFhcFVwmdAbW/iWAORXZqf8SOzo3IPshR42e
	heMgxsatz5u8szJmPABiLu4IgBJ5plRG4ZZLbJBv5WJyFSa1N57dCBIGke9pp6LK9CEFEn3h5s1
	sZxdYTlAKLmO9U99dY3/w==
X-Received: by 2002:a05:600c:4712:b0:499:d95a:41f with SMTP id 5b1f17b1804b1-49e61643939mr10000435e9.0.1789077815736;
        Thu, 10 Sep 2026 15:03:35 -0700 (PDT)
Received: from lima-kdev.local ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c300e2sm111238475e9.8.2026.09.10.15.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 15:03:35 -0700 (PDT)
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: tim.c.chen@linux.intel.com
Cc: brauner@kernel.org,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	imv4bel@gmail.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kayracizmeci@gmail.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	qyousef@layalina.io,
	ricardo.neri-calderon@linux.intel.com,
	rostedt@goodmis.org,
	srikar@linux.ibm.com,
	sshegde@linux.ibm.com,
	vincent.guittot@linaro.org,
	vineethr@linux.ibm.com,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	wanglu.priv@gmail.com,
	yi1.lai@intel.com,
	yu.c.chen@intel.com,
	zhanxusheng1024@gmail.com,
	zhanxusheng@xiaomi.com,
	ziqianlu@bytedance.com
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Fri, 11 Sep 2026 01:03:30 +0300
Message-ID: <20260910220331.1209469-1-kayracizmeci@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f3b70dd40e29b309ff3449a95a4af4513ad0ef70.camel@linux.intel.com>
References: <f3b70dd40e29b309ff3449a95a4af4513ad0ef70.camel@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A416D4000C
X-Stat-Signature: mf5s6qrtwd8hxp4gupz1z1zgzxd1j6a9
X-HE-Tag: 1789077817-750180
X-HE-Meta: U2FsdGVkX18r8ywfLNoPmX3nY3SbIpydq3YGhMPWeFtl+NBLQ0YGONUhsMofBBae2kDiy0V++DVmj1oIRNGJB2EG9W0QM8m7shaMZmz1MNQbpVNzAG7rEiSVCjvhTJBkPWzoHOCKqetTaJhIYMsZYZun+ymS27seK7sbBpspQNqrism+HVBcjnsMFkjsCu4quqjuirOp5INrwMf6YLpwLsGzwBUQ8ePCp7cCZel54CNyZOqGBYAN4ChES5QicD87uHiH87ISeqCJWW8q5I5c6TA0krswUsiio1RWEoPBEmtxBYgpSnODEmwMZyhvXnsjhW5+ekCluA2/B5NfBtF/il+Tvn98h/iR5DOJNC6hCe4Nzj8Xd4tHMGajgRLt07wAN7ZFHpbGbExMV9X6HmcPWOjR9HFaQPXDY8gfHGSqpWfwHkuT2emYfFv2/U+pdY/70eUp0AfDcSuhSarpFd7SG/9i3fSV7H4tXVdFmGw3V/yAkoQwCIRSnqHC8ySoGmJHJsNyMxDQp1ajhN1ovs3JUBAX+Mfq0uLU4zz4yMrvmqt/gDqh2wEd00XtClWxqSO+Fjyd8RweIXsIZXvZC+Slz5B+QCdFD32nEVnzVYlM+ltp1jt48+usLbE58ft0/ptOdacj4zaOp2ZMI1OGXBxm3j0ACrgc1D97ZL1XNJAe5hIO/Z18J4S2dwoRBlsOqPzIOAOztvACA5r2P1YTL/ajNsaxDP+z9rtbDKUeOPH+Xdf9n10zC6sFWdF0DMvxIH93VsszHJgOeyPtL5tOF7wZ+UZUh99V834ujSJOy0+w+y1/powD1Tfx1td/FlorI/BhTrCAfs6mrIULm0+6AlqUj3xKhUs3z+jQM26K52+wI5i7OPyt8/4c+56N81HQH2/ocvIvtgBSVklOcg/2hHKzQ4VQpmx3fimk9DfmqiYuY+ZmQhndvvDOmRs6mru3a+xEae9tD3zrsbzHmHJNAIK
 xDFCwSgm
 6Y9cLpRbf1xWg1UflzOLezJDaEGxpd+zowXwJNKphNeaxnNb18BXSo/qfDhfDphQWFbrARUqBqpq9N41uxmFQMaPTDfmE0mQ+QkPRlcv1m7+8fiDsxbZubx1LQD7bB721u3KM4JW06YMhwjitqwTE8mVvsnbPu66UusRxYwoJqK6CPGb3a+5WpXkzEw1v7PnTdribecuJlf3u8WVHGvmCC2bkzJFpFXhRa2p01nWOZCCEcIC2tZgu2ogBrC3uFN8HYxKG0o2X9VkZwZKrZZWxafbBjTa2Fo4V+pBYvLubFKkJ2aGZmTdqgQwM8H844WjtrSFWrgJEwlJE0x5svw+oOP3rWL7NJItwbpVKzDBY/K8XmHWQ2u45pfpawD1oJnp5t/RMqmF72xdEZJAk6cDMnVi98N60RuJucH65BqbwkWQM/O+nG3J0ygXS8DLnEhRZNVdixsZj0ZwaX3hjcmfrvNHufIA/JSfWrDj29FJFZ+5CWg3UOlAPnoGOhtyoxbHrg6NI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Tim,

> So moving the accounting next to (or after) the h_nr_runnable update
> would make task_pref_llc_runnable() return false and skip the
> decrement, leaving nr_pref_llc_running too high.

What I really wanted wasn't getting the accounting next to or after the h_nr_runnable. 
If we are updating h_nr_runnable in some way that means we don't need
its check since it's already getting updated. And if it's getting updated
that means on that branch we know how our check should behave since we 
are a subset of it. We can skip the delayed check on that way since we are
trying to behave as h_nr_runnable's subset.

>        if (entity_is_task(se))
>                pref_llc_running_dec(...);      /* sched_delayed still 0 */
>        se->sched_delayed = 1;
>        ...
>        for_each_sched_entity(se)
>                cfs_rq->h_nr_runnable--;        /* sched_delayed already 1 */

For example:

In this code the h_nr_runnable is updated the same way regarding what is sched_delayed.
That means if we want to behave as a subset of it, we don't need the check delayed,
since we check the delayed to be a subset but if h_nr_runnable is decreasing/increasing
we should look into our checks.

My head hurts. Please notify if I'm wrong.

Thanks,
Kayra


