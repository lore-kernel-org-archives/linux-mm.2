Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912C2606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7OGn8fG
Received: by kanga.kvack.org (Postfix)
	id A948F6B011B; Mon, 19 Oct 2026 21:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45F36B011C; Mon, 19 Oct 2026 21:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935646B011F; Mon, 19 Oct 2026 21:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6994D6B011B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:20:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DB301407FC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:20:15 +0000 (UTC)
X-FDA: 85341248790.04.9EC113D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1DC0580005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:20:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7OGn8fG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792459213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdN55TTbw0U+5htfZUR2VCgK6iVR6j3/f8Ws052RgS0=;
	b=LKA9xs9oupHYFCfxxpko1cLk8a37m2fJWFyykSO/dox90JogcDb7/k68N1Pyb82yPLk5Dn
	3qEAPL+TsAEEFjxO//9KYXQ6bpFNkoUsonlJuvtST0M4Kd7VfKpRcTO6fBbIouCAstPWt1
	Os2TcHvLBlJQWZWbGYUXeRxaDABwTUs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7OGn8fG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792459213;
	b=Lyt8JnFZYf5+yhXHuEWmXor7h3l5z57jxaPPHnf53hd5CWbSxnwBx6AzFXBn+gfvriSJBu
	BjsZNit6cOs6juJ0rFLCtzTRymffOerFnfE3qc2n5Zxau838jsN1gYJ+4ccpTu8hSqhzTk
	Wrfal4jv2QQTKbKziAQlU12oD/62ovE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5419544517
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1801F000D2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792459212;
	bh=mdN55TTbw0U+5htfZUR2VCgK6iVR6j3/f8Ws052RgS0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a7OGn8fG461GryeWDftKmbd0r9jq4CpnKIo5bj2PLMkbPJjsPCLgd7XOfkQIG3mzk
	 cOZ0S9YCTNLGDXb1KAcKqsE5jngLbN6/VW5YPAMubSOuEnJ+f43Le1Y2j0LlyJzlCh
	 I8t5kfaDiMrjvzKulC27qKJggdJ9kgulsn44Z6pWXi36mA/X8DkMYdhhhRPnPHDT/K
	 c+0IIDPUxiQ5S9D3aF+6pTJc//erkv5HIkIE2noCEPNqKEMLbHsP19siEFsxkEzhSV
	 XwAWTouTdRnzRhA0N6BaTvPa8R6NGK5Ta+NywuL3o6CK1D5LQ9sM6gth8ONqKsKUBQ
	 XjuYw9FexNCqw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f36c18b75so138955885a.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:20:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxkcID7fGWiloEQjReM9BU+BY+07O95wGREIMMR4hFUk5fKKHDMnRZUTQcWWbIPMt42quOGS1drlA==@kvack.org
X-Gm-Message-State: AFq9FYJZg4jwTjTjX0WvYFTIaT58LygCa9ww7bwa3gfAH/xoP334/xkh
	THBsULwYSYa3WFlFpInl7EY5ICt/Ax9PgEo22DRgjbAz/jcBYeVafOSfReebutdTKObRMQnk7qU
	zzfT1SratEnS8mZ8TgtY+M5u51y/CYMA=
X-Received: by 2002:a05:620a:44cd:b0:93c:68f0:f09b with SMTP id
 af79cd13be357-93f29b7fa3fmr1545675885a.5.1792459211376; Mon, 19 Oct 2026
 18:20:11 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
 <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
 <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
 <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com> <CAE5sdEjFgVoQbWw12=+AKdCOB9cWm-akxzbX7hJzvyO3vpCtgw@mail.gmail.com>
In-Reply-To: <CAE5sdEjFgVoQbWw12=+AKdCOB9cWm-akxzbX7hJzvyO3vpCtgw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 09:20:00 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yrAosgxnxqc18qXyeJQHszYOdTxJw4TzSJqp10YQWjag@mail.gmail.com>
X-Gm-Features: AclHuK9xt7Olf4mZCtGBt5rmDDZTYfTK8Foa3EtnoHBlxoLgp0J3AiuCJekg4AM
Message-ID: <CAGsJ_4yrAosgxnxqc18qXyeJQHszYOdTxJw4TzSJqp10YQWjag@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1DC0580005
X-Stat-Signature: nw36yr4tetzekmez5bb9qa7j1x4u8zhh
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792459212-214342
X-HE-Meta: U2FsdGVkX18L3rpD/KP+gpR/b68Yu3028NIFvD8MqsAWme304CswXWP1uIejqLePoqCMGMteePyaFOkB3hrfHkVNruQyiaMmOGMm3HnyCQZeg0GvkM/c2yk0gLn/6M6ellc8POVqWAqmfiV0x1BgtOrAQ9lJb5F+F6/S2WEf2FqRO3+fSCbuymBE0EQAg7t6+d7lCL5sdN0p3+dViqUKSz0le8p9Jd7KkAhAKubisFbCycBelLJCsUv4wq8yAOR6kGwBa1zVDtynvb+HmqJSaV07HwEND8J23OuSdENBLOq08Lkwh8RVJd74O9R4/aEXdfltrtYjyrFdPYRCGIRG1RqLHUH7odMWj9VoRsqLprX5S93J/HrQEibWGdb9fsM/E40v1/eVMCyMaBJ2qC7bMcX2BEI81w4s1atOEncfR7ha9+ael8ihw+YdtgfSO28cPYIKt6pFsqt2o94uD1hfzfXxA8ihQoHmohALUJ8j57qv/XIThrfJ4p4uschOkN0vuFxuvH6D2U/k0n6RdZz1ZjZAAHMX3He8VtANaocwnhhcXOc0JQX/EsJBgtItojS+QNIZYpv++hMFvitUT/rfzUu+gSPdHsUfOCO9wiFCuw9/MCHR5b+ZpKV8JyMOy39n7mDTJr9jyXkshSrYhDdyV79U2SCTM6f1UxtJOvZxs75++bcz13mlNnEY8L2P0rHkLttLq3V/VKVec6R7DNYDr9c0qP3d32y2b4DmwcCRn54EdfKwJ8n/84IzxW2khxgllOocQw8blRuzqksDXWetZGasecepIEdz9gG6xjwevyGVd4ulBC3OTeElE7OpzgF8znwlZfdeJQ6otCH1FoHQ39Mh9312SXf82v5t7MbTbG7bu5AxbsNHhB1phCaZkPIhSgKjW/eYm14nvNJPHjtzVNHkdRror6bOxJFWBrHmETeZmp9kMhn5A1Rqpxxz4P2gr2u3nFxczXymCZVu3Tf
 cSd/1kq+
 WAlSTGIfkmtM7DzcSd1vN2lsbLS99XaaUq7T6U2mYg6jmuWiQw13yRsQgP9nsI1aM9pIXhcFtwplK4xVKWgmwWRaHgmWXzi/yVHIwrmrdQyOveTBAwr5D8iseZH+GxBE14riX+fmWXonK2Ca4E8n8FUCLSw63DeUCrtUxIxvRnA7slyHo7u/g8NI4RRuTeRKWUjWUmaLR5/tpE/jSPXWFqav9MVZeLcB0h0VLR3ND7E5CyfLj+kg2ilGmDmPOBqUU8F0pIWYSHeyVaSinluPRLQgcfyNP7R+gv9zKlRtQZNt/XXgufSUMfkrKwTJdxEeb0VSqp+6Yt7QEiqgcESKYLb+gFA07S4+W8Xrs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 9:02=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
[...]
> >
> > Thanks!
> > I guess you mean the following:
> >
> > -module_init(kswapd_init)
> > +//module_init(kswapd_init)
> >
> > Yes, I can reproduce it with the above as well.
> >
> > But kswapd_init() is definitely called before we enter userspace,
> > so this doesn't seem to be an issue here?
> >
>
> Looking at the callee sites of get_lruvec, all of them happen after
> boot. So it should be fine. Anyway code clean up will address the
> issue.
>
> > So I feel there is no bug here, but this cleanup is still welcome.
>
> Are you ok with the patch as is, or would you recommend  changing the
> callsite of get_lruvec to mem_cgroup_lruvec?

Overall, I'd be happy to see MGLRU-specific code being removed.

If possible, could we split this into a two-patch series? The
first patch would be this one, and the second would drop
get_lruvec().

In any case, if this isn't a bug fix, there's no need for a Fixes tag or
a stable backport.

BTW, I've been struggling to understand why MGLRU introduced
its own version in the first place. Maybe your follow-up
patchset will help clarify that :-)

Best Regards
Barry

