Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780B7606A338
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8FD6B051F; Tue, 20 Oct 2026 12:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF126B0520; Tue, 20 Oct 2026 12:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0AC6B0521; Tue, 20 Oct 2026 12:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A606B051F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:18:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C08C7160283
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:18:51 +0000 (UTC)
X-FDA: 85343513262.04.BAAF98F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C2CDA000E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:18:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=t+az=IK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=t+az=IK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792513130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HDHLVURJlZ0OyavP+yVh87qyK/wkUYysdpJSAYO5tK8=;
	b=5Iv3zLkl4DiB3nplAWMe4ZudLlU62JoXWiuZy4o+7AD8UDZQaOV1F5FETb1Y/4iR06rtJQ
	RQBIPuqDD58ONu9bb7O7fAbKb1J3tpfpkePw5mslUjETCArb7pQxIzt9PpUIvX9QLnBGw+
	ZYL5NBewepQ6xZyY3bvFnJymMm3cFHo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of "SRS0=t+az=IK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=t+az=IK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792513130;
	b=LfM8RXEXV5B0mgtStNJwP8/mb/PPZzWe7MMzELfZ2UyuGYlwb///mhpkXG3wVerwaQhATG
	MvNAcMxnZjYhA6IF1LbOJOckRVNi6iu9agPPczS0MWZZoc8vVGpitASIU/tgTNZteXuPge
	Z6eluKZWSycH5usBab5CogrfiT2k5+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31A2D44501;
	Tue, 20 Oct 2026 16:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A2A1F000CB;
	Tue, 20 Oct 2026 16:18:49 +0000 (UTC)
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id DE4ABCE1B83; Tue, 20 Oct 2026 09:18:18 -0700 (PDT)
Date: Tue, 20 Oct 2026 09:18:18 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Puranjay Mohan <puranjay12@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, RCU <rcu@vger.kernel.org>
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
Message-ID: <43ba22f4-f7c0-40c0-b327-a71d07f02280@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20261016155340.3304319-1-puranjay@kernel.org>
 <3225a379-a959-44b2-a2e8-02ca93759316@kernel.org>
 <CANk7y0jHbggDHB_68MjZNq4h=Gu_N_G-Ytf0YLrKM_B8A=qsoA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANk7y0jHbggDHB_68MjZNq4h=Gu_N_G-Ytf0YLrKM_B8A=qsoA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C2CDA000E
X-Stat-Signature: 6gktg9cjr5g37o95cknqi7tomruqmyfd
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792513129-124354
X-HE-Meta: U2FsdGVkX1/2ukO6y0+wbYIghQGkTtyM//Zs54MryGckM4w4UYOjjF6hHH8X/Rdl2lEHSHpTnLMonpjC2ftxkSnk387ksmYHDc/UWqvBzXw9oGNZe5+2zHh89nP1inyQngVQ8K2HgiKcaonhCFSVDqMcxD7LtMLC5xxkof7+HtgsmpmHXSxwqW2BM95qV/k7RZYP0d5/JZ6obVSIvePQ3isnRB6bm529imh98Brt5CknaitGCFVaK5qdQdkvOJ90Ozzqzt+Yr+P5rjV+b2OdslI1GJuhcKmBntWh2864AaDRzLcj4H2JgEums0Je4qwViiGVLJmfOIfcHXaujo5smppNTBbsVEE3AVoD2J/HA9lbkHnK2DWFK64XxwcNtkrx38/rv1H5gfsXYc2JB9UyAKNQn1jl1lJoYMa+qiE6WV9FmCh6YOerg5ciVCCPez1xWD6auUUxID/XU3O+8icmbqEOtQIppeFimtjDLDfqmq2UGDSRxWtSyIgncqsXo5ip85dh+LGAtGVFjkfsA7h8ELeMOEcRLxKQnByIlRT/J/CEf5t8r4mPnYJ05pldQ176gCmpcZyJ4jbHgtWjB9PyIsOGV0OjboJc7rBQK0f9NgmSy+ZkFBdaJ04zUu688XUh8LUvPu6Gsa8XVXg/7YQFkjfdEkaTLrQ9sAqZCAAYLwpvlnLxW0IFkyi+IxjcAuu/BTjNAsRgBt3Kb0bJpSmhrh+c+uPrgcp0lKkwjG9fiSH+hDNMJZ+OEIgJ4CZB5oLO8Yxw+TsomjL/KIuIlS5K1LeyAFdUAY2NjHTdzmCj2FKbfCj2Rh80pNA5S94E0anaPrWw4xS5XeUywoX0LZzfum59IZhpfW47eUCBBKmmCdUTUgcY6a7Eah+62UJZm95e7JTXWV5+R4Blz6XTCl/gvgk/vxUEj5A6OhdVC39dXwChZUHaNFm8u8h4fRnZnqk7zLCXYGjiqIChIof9VvO
 VKhHM1R9
 gNImKLIl2Q6Up68kXY2T3/REANxzmVTQOPN9czzLzLR+maj8/FO2FBx5qJ9ylWSUHCkrIuZ/DZXgmuFdI+bWWzrBsQmP+2V1BxoiIHmidIM9hsmkHYM6hnJxG/5yVOKB4LB9MWvCD0+ETwVTWN9xhXGa+r2j3aAHa+UIu4P3tSzCPUW0/ZOfm5CD7KQCYSv2abK4rU+W+hwYWSyrpzQTd+2DgNWUP5fgn/H/zunp0ecQNpzSsqtXz0YXudVH0y7T/96ACuMTPxqqqsPTBkm1Zq7U3CXI/MT8S2O2BxBUviW54lwP7Ln4J3nkysZu5IhTz6cV64lIZwF8A4lyAPcdv7fcxs8B0qaPgZC7165J9u1EHgXN4fa1ZGWoYhEviLwEG6I5zuosWVcaDw/TwYYsGnTUEGkURffUcjZr2vtiEq19xaEA7f/y1R21OaxQOnzvF8WxQPCK/5x/WEYbm4tM9VLbx2SCCOmYQ10DPWdu2rWquk/++tADnSDMtYlR7VzvUtIx1R8bH082DWxff8xUQJDbP8MhOQBiuWY5BEqz5WOBmMbo5O0Y0Jt99Y0AkpBLuDUM2xGUeCbL82tt8HPYBQ8NDYaC7ijuJZCLfYjFEDr00ETmRhbLMPWRrE5sdZv0Ix8zr879l7xYeUd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 11:06:23AM +0100, Puranjay Mohan wrote:
> On Tue, Oct 20, 2026 at 10:23 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
> >
> > On 10/16/26 17:53, Puranjay Mohan wrote:
> > > __kfree_rcu_sheaf() can run with allow_spin == false, e.g. from
> > > kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the same
> > > CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
> > > extend deferred free mechanism to handle rcu sheaves") added a fallback:
> > > when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
> > > per-CPU llist and submitted to call_rcu() later from irq_work.
> > >
> > > call_rcu() now handles this itself. When it is called with IRQs disabled
> >
> > That's great! can you reference which commit does that? I assume it will be
> > merged in this 7.4 merge window?

Glad you like it, and thanks to Puranjay for making this happen!

> It is part of the RCU pull request for 7.4:
> https://lore.kernel.org/all/720d335d-17f1-48e7-b5e6-49352712cdca@paulmck-laptop/

More specifically, these guys:

af78eca13b035 rcu: Make call_rcu() safe to call from any context
0ed912d346fdb rcu: Make Tiny call_rcu() safe to call from any context
35a26d87042b7 srcu: Make call_srcu() safe to call from any context
a04b2854bedc7 srcu: Make Tiny call_srcu() safe to call from any context
d23e30d76c32d rcutorture:  Disable fragile readers during overload testing
813f2ad270032 rcutorture: Exercise ->call() from NMI context
0464f587c61af selftests/bpf: Add a call_srcu() re-entry reproducer

							Thanx, Paul

