Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC192C98327
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 11:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91A06B0005; Sat, 17 Jan 2026 06:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F0B6B0088; Sat, 17 Jan 2026 06:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BCF6B0089; Sat, 17 Jan 2026 06:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 973EB6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 06:55:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30C8EB8BAF
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 11:55:11 +0000 (UTC)
X-FDA: 84341300022.07.774E7E2
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6D6A7C0002
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 11:55:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TEiMa/Ci";
	spf=pass (imf10.hostedemail.com: domain of 3m3hraQkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3m3hraQkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768650909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLzmroCaS/6bTcyxw8v2f5hrQAsPrQS2nRkMsKAP0sg=;
	b=zLarNU+08LdfpiiYGOPiY3S0agJkEWd0kuLYH3+t/W73BdTe6As36RcOjIIhyus0F7OdsW
	wxOCDW+RCGTXKF2nGMCqgnHCEbhRVigFHKrGuTjO1x5AjPsjTrfB13fQafdEzajleVUUbS
	RuYTKg6aq+lDRS7tvtt2/GHR0XTqE7E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TEiMa/Ci";
	spf=pass (imf10.hostedemail.com: domain of 3m3hraQkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3m3hraQkKCIwq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768650909; a=rsa-sha256;
	cv=none;
	b=Q8TeT0NC+rlXvf4CPVA+Qkoo+aWEvdqIZPWJS0pmIL/n3oTHa1gg8QeDXB3H5zVtU+OO3D
	yMB1RCggBvyMb9x6usjrTYEcEscl2pyAN8RHQOfq/P0MLejwsos1dzKXjm//LNTfu0hXyb
	RQHXSn23gC79ByPyJqzNWOum9cMPYoM=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47edc79ff28so18421755e9.2
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768650908; x=1769255708; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLzmroCaS/6bTcyxw8v2f5hrQAsPrQS2nRkMsKAP0sg=;
        b=TEiMa/Ci2L8e1+d0RAXIH9ZRBWDwCpcx3GFI57AdIj5adoiVShwYKB7J+BO3UoDMy4
         g8FU0UTnz2WmFjQO2sHDmGjY/2Uv9IhSCdrCeGviieVo99p2YAWgKin8jl2S8uCeysgw
         94FQaL28VF7w/nw0hvdBjMkba7WSRehuq0f9GYqVkuagNe5zF4IMhmPZwH+Usbrj81Ex
         CnrgA6+K3wXuecQRwlsa9ejBmJ4HXSluS2y3uf6etsBV+muei9KzAjdL0NTptB5Fqu8M
         6u6xL4kswl9w0MIp1xkgsXSjBrQoagmRWJy0onlhj4NZGnSesBmTYAaDUUPxbs+hGbOe
         K7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768650908; x=1769255708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLzmroCaS/6bTcyxw8v2f5hrQAsPrQS2nRkMsKAP0sg=;
        b=kYUF/XOme0jLsDa7vfyMfuhY5de+BZB4l5n4M9ZaNlrFl1avIwYm5mBIRiO/LJucPb
         Z4rHydTBa1ZBvX9ah7RCKsdWB09vyH5AdKojFqBT25XgIqnS2VWZpyJL6fgppJmt7jx5
         0dEiEfGrDi9T7fvDO80G8oCPxSgq68eeLqDJlKmfxzyRooDPjRHtzV5Sjxh5SuS9rcck
         77hmppC/P7B90KN1LgVG0/YxVaGiOgMTiVy/HO9+SYRhXIk146vfaq2MkhBdEYHQ5EXm
         CFtAB78YdyFe/LqOCL+ccywgESpz2wJmNaJXi6s9dEO8JHGCeE6UxcXs8gb694nuLxBJ
         xmzg==
X-Forwarded-Encrypted: i=1; AJvYcCVRI3x8g/zAEkegnb6/kA4vcX/qf37+mPTJVcQT7h4xKIvx/Rwqe89o5Kw0VoCBmk3SCoH+THSx8w==@kvack.org
X-Gm-Message-State: AOJu0YyOA6cKnEgbxwd5yrqYrMaWIeH7p/XWpDvRxzbzitRCcJUNhcX5
	3AOXktu+vn/RIypStd7eMCLlhybs6B9E7urm/VyVLZzU7GhKe2P3mWSKQJVMcAiAi4Dqm5lv1XL
	7vYr/1Ri6Bs7JH7YsRw==
X-Received: from wmpx37.prod.google.com ([2002:a05:600c:18a5:b0:476:ddb0:2391])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:458d:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-4801e341e2emr60365675e9.19.1768650907837;
 Sat, 17 Jan 2026 03:55:07 -0800 (PST)
Date: Sat, 17 Jan 2026 11:55:06 +0000
In-Reply-To: <aWrSkAPFkdH_tvtN@tardis-2.local>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com> <aWrSkAPFkdH_tvtN@tardis-2.local>
Message-ID: <aWt4muGXbe7lBmXt@google.com>
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
From: Alice Ryhl <aliceryhl@google.com>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: khztwm1nsway38rs717h39mhd31t13n7
X-Rspamd-Queue-Id: 6D6A7C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768650909-833881
X-HE-Meta: U2FsdGVkX191fYW34o+cv97e/DQ/1SHt8RLLJ2oYZB7yCUwK3JRaHOf2YaZAB012V5P4+DMD2kWrUSYiomBOVsiSo0NWzVW3fIZgpvMp9pxUgO7AnyzfkG3VIiN0G3GGoPQdEVDXELuE+tJjYUXVQ1NS+JMd1969/1TnrQVIGU71d0vTJiDPsKkaVjx1dsb56DmPdhzkjOqmwksGdQfbRMvvY2FdDcLcPXLX85Vqv3B4ztfWVpsVE9OasFLv1RoCOdj71bfXeuxrXuWROoFG4D3R3jl9SngrmpXvHPQ1cXIbvTmIcw9HS+Pj0qDYffgJMapy7S8UpCVPOA02G6ZFhzgoUBkuXlQlQwL3JjAwcmNFpFcLqm0Z9n4qNE5ODwD6tOugkHxBQ4uGcujoVy05yahlIMjBy+wYOsSRxMUNMyejgw0PIO+GRa2MfplHGTak1Da25vSwAKmOlr5OMpQDExe49Hf5a9d+TDxdo696qas4EgfvseQ0Svo/m44olAtNbBFNwnwjmtY9kyyrLA7tJHAy5b2DKodDJaKshaMnkLihGF6rc6boabOhbNh2uJlF3cgliwX4MUmKiOPcXVsqyRgJPyYi/vQG5L7hqaWN07DS6/GuAWqfvI9aX9GkeLCBuPR8af9ZnMk3Mujh7RnECZ9UTld8VkOoDSop3hzTeg/Zup6ExZUOJJ7Weat4eLl+VVyntHy+l7FBkoPs58pznouVjw9MuYeVV8TBILk0cmOsX6mBAAXFaun0+BQoBCk1dXWjqldt/bEAEZHgflobVqpOGJIAlVZlC5u69l9Mj5ZYydFRHK/k8gVyD9iOroQedUg+l9z9/xqNvWQ9VZbKk7T5jEXlCPxJ2GOAlfk1zKdMdgBeokliuzyBWp80+rezM6Wauaj+oxGNE8ZnxXrowBB7FYNjHh2ggYGhtOjtLB3kdN5tGxbCNRgiPECr4RCGQ/zs+EFtWGD6fZrb74y
 DJVZOQ9A
 UdlIqB0vcnFS1uSpa3mLW4KSX4PrfZfXV4e0czJRS0B8zlpV0WsVkPG2M4yGeChmdIWVPAqgMjBYaorWOKdcqpPEcAjaEXrTjO0bngiato8K0cDeW77gitCIlRLwLP01vOzkaSipf5FPA8G3WlAnPShQ/SDiRsHOCNMqYrTy2tCHYdHBcHiWbZbk1GwFpH89tOdBQ7x4R1yaRKXOd+Eoa356lFix4g0kG6sYup24TAIcKW6yWXNyA3TZUf33+l1TkGRonJGPH2RDrQ+b6yM/HQnmTpKzGy7s5bvrHkLcoOHSA0SnEKt2QfF75yHGlJr27oB4DVd8y81sElDw9CAaH9xLUi15OkXZrMEadtF6aE8Bq6JDp5neG1PtqbCVMQEWBNge3K0macLC8K36QCqLUC1t/DxDjaVipo3HETQB0i92mqG0RMODGpWypEabaJ+X1ByAP2X3IL8ebL7F5U1doInyuBCluMyZBiHwU9c5eZx1Ez6OqjOWpesVciBvrHE+5jUe4ilJcs35paM3sTQaFn5NgBvzaocCfJO7ldTXGtr9U6oulAr9LUVQF07UpfvXONNCka+GnQQsb+cqA8LkbaBXU2wXLSXV46c9nRVnIdLKQAGd5gLYp98q4cqr8mZtJpPWQe27N6uAd3TeCdVl8T5JJork/MHfbB0DkA8UjRYiRx9TpygCjPJof6/InxZvitWcbwio/0nHMBYoz8s+W0PcGaE35TMX1eddC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 08:06:40AM +0800, Boqun Feng wrote:
> On Fri, Jan 16, 2026 at 03:46:35PM +0000, Alice Ryhl wrote:
> > I'm sending this RFC to share an experiment I'm looking at. This may let
> > us replace the range allocator in Rust Binder with a maple tree.
> > 
> 
> Thank you, Alice.
> 
> > An RcuBox is like a Box except that it lets you obtain a &T that
> > outlives the box by a grace period. It does not allow mutable access to
> 
> I think the `RcuBox` can be folded into the more generic RCU pointer api
> [1], e.g. Rcu<Box<RcuBoxInner<T>>> where RcuBoxInner<T>: HasRcuHead. The
> benefits are at least 1) we use relaxed atomic read for RCU readers
> which guarantees address dependency that RCU needs under LKMM (while in
> the RcuBox here, we just use plain reads), 2) we also support mutable
> access as well.

1) But mtree_load() does use rcu_dereference() to obtain the pointer?
1) "relaxed atomic" does not sound like something that provides an
   address dependency to me.
2) How do you intend to provide mutable access? By waiting a grace
   period?

> As for the progress of that effort, the Rcu atomic pointer is almost
> ready [2], I will likely send it early next week. For the `HasRcuHead`
> part, as you may be aware, I'm working on a generic `HasField` approach
> to avoid duplication of `Has*` trait and macros [3], that requires some
> syn adjustments from Gary and Benno, but they should be available next
> cycle. I will probably send the patches for reviews before that. Once we
> have that `HasRcuHead` should be easily to add.
> 
> Given the WIP code I have, I *think* we are not that far from providing
> what you need for binder.

Hmm, so I looked over [2], and I think my RcuBox is an RcuOld<_> rather
than an Rcu<_> under this model. Though I can't afford to pay
synchronize_rcu() for cleanup - I need kfree_rcu().

Alice

