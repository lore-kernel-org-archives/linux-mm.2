Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2508606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zBhjgpsl
Received: by kanga.kvack.org (Postfix)
	id CC2D46B05B1; Thu, 12 Nov 2026 10:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74236B05B2; Thu, 12 Nov 2026 10:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63F56B05B3; Thu, 12 Nov 2026 10:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9B06B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2DA6120552
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:45:50 +0000 (UTC)
X-FDA: 85426892460.16.89AB0E6
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id DAC1A80003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:45:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zBhjgpsl;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794498349;
	b=XBtunCJ/MQr1/T4rEAJ8SdLZ3ekR/cUO/y/Ewhhc8wI21TAzzXwt5UmxgacuP4ik774M8c
	WnzTHtzghdaAo0QVWFWa5tuis6H4LZOrcUWL7vySCAxAEMrk0JXVciJlKe9IofG3U12BZP
	M246BxLNkflfzU6dA8397CtO23bqtRo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zBhjgpsl;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
	b=ayrvIlrJ2JmcbjVSdrqPsnEikUar3vJEVfsdjCt3ujMKkMrHQQSsIjoWJZSL0AwOcDAGXa
	M31nZnQ+dwhK36+AXuNHB3pUWHHGpTKeXbCQNy4rEnYc/a3iuR4/UaEve6mRzXFYtL5R5P
	9xTViol+8bgOkocnWPzmnImG7cRk6KQ=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-498f5fa5103so1637980f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:45:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794498347; cv=none;
        d=google.com; s=arc-20260327;
        b=imWYMMZSWAl+y82rbL1NFVaKMmRJPZRnXgwhcniruF7TimL4xZphv61d5C2V2/vAZn
         gmPCcia38N6i7nJCBVuFADRD2IsmAJMwh3JS5nDtNwY+GFjkdayCYpiWjrGSVt3ioL4i
         LCz+rVMb3Ge1WUlp1CVDhRzGpj0ef1JBeSb32OMDueFvMTdvlsSSMZbQ9NEpgFr3wTK2
         xiLVqqQtmbk0ZFbyx+YPLTbzk5K9WuOMyVKujHuBzvAfRVRZ684To9a4RYsPAaypM/oZ
         8B2wldOaVzgDp1wYQcVKckbeAAu5HOtcAELIo/M3FTu6GShgFSEKVz1U9Ly5ijclWGDQ
         3eVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        fh=/vT6F2AuJh0zzxXn4ONqZ25vLk6E5DWOx4gJ7HvHoFE=;
        b=FhgRYEwNfjw5TzMTKgCglh0fTqubeeF9C+0DcQe3uERb3ame6Q7nZWmu8VRYb4vwAc
         MSAM6WLMh3iqNwkWL6gDM1rONuiVcK8GOof9BjEdh4fp+Y7NzjnLMy+k4NFMBUOXUHp8
         Ww20Cn3a4hf+Lc7/Bo831Y7W4dLUL0izTfh818sTl6raQidRr8vrODcA6vPaB4THXSZQ
         f0LQE2HBGplzsqRuGn/H+CF4lEzmxfgAlZav0fSZB2mzkLLGPFb49EMLv6hu34WUk7RU
         3+TPvAxQ2/c8qALDYH8wb8d9mL0sZow9e17dNaH2Bp1YHT6G4UvfCHH6ssKQWpw2EP1c
         +tvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498347; x=1795103147; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        b=zBhjgpslx6Sowe114prWKQnxQbS1IZXiHyZ1KZg1XGn5FlZY3XXuBGztrnk5QH9B1n
         eOuBbYzRZ1utiAtDVWe6QcbLEhtD4WWIvrpAuPaH5LplZU6TCcfvteCnLSmuOkq2cX+n
         xjw4Pli8YFfFQN/qbK/S9sffMh9/B8ew/767DBP2uG8ib7K7Cas9bh00khO6P23y5elr
         dzxMS54jss2rHAGH1L98WAtrYWDXatzq04Ytna1XNsgjyq63GHvP9bY1yMtUjLlLiljC
         mPSowzm+gr4k7nXT8V0aLnSGatyiCpZeg5BxsPo/sfsdnREroSmpoqatlwsgp5hQS9V8
         DkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498347; x=1795103147;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kA9f5sjuaRG2vzctzCp8dttJKbGRMLmrAhhg35dIa8A=;
        b=b5fmYwxU2Lq7Pw9MOvhW9uSyHycYVLxB6d4BqfETn7ujE3NQmCRivkdeWeUipcwLAi
         cVc1/4fyPgIyz9Z6s8CXqYAdLfLOnq/4jieRSA3w1YAAnnf6eAWLFTPq1FI9y18FW+6+
         m9k5NUWTPe1L59aZgzTY5Jc8Zr4nBjte9SZxzVmZLZ5Dcuy1IyBxdpjcOrXmp/FVKlAm
         SIh3e2pmlGajpb7sfeckKVPQTTjgCp/mTCxXshO2ApzxhL5gyeQa3QiTDc8P1m60fUCJ
         1nU6R81Bk2xLQkVUye+7cPmF2nfB697JL4qVBSf9qCUkdTh8ouEqLuHIExmsN8YesOSI
         6oTg==
X-Forwarded-Encrypted: i=1; AL+hErG2wG+VHF5HOlzh8L/HZmsrp468O00kjciBWBeMGEsBKkCUY7xXGX3Gben2ALKnpms5SvDZjr1Wsg==@kvack.org
X-Gm-Message-State: APuU4Z+KxcqAWJlyNCNBWyxd7riqQgPnOuS+BVyTiAuhvv+QExOxpS9y
	73TeyYNynWdHvhgdIwTuarxMHxUovdAHF/NuM8Ma++bt5uTaLonxAOTX8lKoO3YR8KGYeh7VJZP
	cHIKp2p9d8/VJVuoHVBYcpWaTS3GMRvA=
X-Gm-Gg: AYBFou2VeyWTxLaTUcHK7Fd2SkCappoBVT+qz4hxj7amvqG4XX11JXabKIHMEtB5qHc
	gcGSepf870RipoD66mFQuyW/oWj4NAw+Na6fbBANdbKHPVLS6uosskh5HcFRRlAidQQa8rxBtMp
	HYfEUZsAOkRvCB18CCA4uq7xa1gevuKE5JFkt6eLdYNnkQHd7huRmUn11kF5v8Wx4xXNXkrqF4b
	3QuhSgco4ymc+6PbS2UvX5klLjaGPL5gYRaSXngVif4sroxUI5zscW7Bt2/IjAf/Rt8dJHa9bcj
	7Iy5B+/uNcQqz8AyFEEB/K9F873VRRz5g2RLZc7ALRHSt4p5crGmh3OSPrDI3wwJUqcBMcYewdl
	4ZaxmPtKRIHX+S8BHNQQKzhowt50u2iGIM2lZvfnkaergfuVUgTsvvhcYlPmnfv1UynZPdnHiPK
	YYgO88+JoprDKXOtsYsjhVVP2Fn58bWNy/j9Zxboj3fJbh3XGcybkx
X-Received: by 2002:a05:6000:2308:b0:48c:5304:5e50 with SMTP id
 ffacd0b85a97d-499c0781a7bmr11850028f8f.0.1794498347231; Thu, 12 Nov 2026
 07:45:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
 <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com> <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
In-Reply-To: <CAEEBa3VA2vycMaRCe4K-qnO3SGCuvAqhECmjmk6PQC3xxERiLw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Nov 2026 08:45:35 -0700
X-Gm-Features: AclHuK9YTgclXVDvcKdpOmhHB6JA7-MrKBIZCLI9W7C--1NSD0gtJgLIGYRP7cw
Message-ID: <CAKEwX=NVox_NYML-5Gg6W_gDt-j6gquk3sba9hmbvz-U+t=ehA@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: =?UTF-8?Q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
Cc: yosry@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: diufggciw5tr35y5ch87g4s4juhab7u8
X-Rspamd-Queue-Id: DAC1A80003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794498348-756963
X-HE-Meta: U2FsdGVkX18Hwqgb9eonobQ2ixN7aFmj8Ez1FIAJCalKIFrekenxuWjptHXTKEiKLj3J9exqvMcRMjTaabIe+FN3yQg2hmUOR4XF+fv9k+wOXU48D4aVWajCAMIMYmKqrL0LPod06cahezNmQf1hiX3QqDIgdEHhLGLKinn6XvmBIWrU/TNlTimySFnWIUXkezIYXsJCuew3C68rOKxBM7JJmCjFer9rTxAPnE7OhG1QL7qjtD2r+dhvOkMLZ45FvlEyHuE7sCqaPnnJeHh2Vhle9abovixwuH0I6SecSO52YpqHRq5i3NY3S1rV/YWz7JhWJpYuazIkMB0Xnh0DV7X7YJI5eqTmLWIOC9RnzGPwB6asGVEECSOwpl27Xhyykh5Ex8nCLlLkdJquk/OyXM8WNlofTSoADFY3u725PXpaohmZ2YY5GvzXfsQ+0H/U/zZcgOXQvq4e9j47HbWiQ8MWmt0gyCzgFVxrQbhly5teiD8nFOED4mLxUK0GTd+EnI3Wvjobx+AyQOH0zNzb1Ue0AM1xg1nvTZ6094ViK/YsjwgagktHrJYYmWaE5aj/09yF0CCofRvwvTgBLwk0VT4Jo4upRxXRoS4Bzom4GiilDNU1v9ZyMmm1kzqbsZi5ZeWaZhYCYvVJKxOom+1vaH7XtA7hLPoBjQQpfNqA2sNEJscD5FdJR1DfdbEjFYAvvAXDNPWAjdpfarcUNdkuu58P6BgqR8TD9/cBMpp8QfTfsEUxsKYcTOORvGZSHnuNHNVeVWWQZOS7ntviIIxWIqGG+f6RgEatPFmICsQaDaElc0u4lQobilEu5EJIy2K/jWOxgyx8JBrM3wrCyDODZ7kq0TmAJ4SCkCpC7+dtMt0g9jn9hJ2QrrRicq3Pg/fFNyhNJcesjt5C95KqFry8f7+a/VNVCzBtX4wCszgc7e/SrVFZU7sWms7Zw6Yv3ZHtpIAluTtTt7Ql5jEhi7A
 a8Dyu7Z/
 VAeNDRRuL2hC59cF54EEZheekZXz2oZTfxiAGwJORZ1Y/4OhoTtQyI6thbE8DDiB7Rwm9QkX9jzSF03hK8SNp2Fu/W2kc5NLXZP2c7w+R3I5N+J4pBHVHC9YdgFB1lm1aImjID1BIV9e22wAZvfpU7y+KNgKdJ76Lt6xs5pu6cjoeCqR80QUyE+9t1EnfikDIoxoxdgL3iBRgcR2Gyh5cQSDlEtfZ+LwLKqD3Y+ioQmDhr4ecgGzAOHWRUVHhKJhs29PwC760DHAAusOm6OXNSR7/AjC/vghqYWCF+oWoLyiAKq1LdLLDDeZ51n3uYV91M4qFRYPOoY3MFoKKLi0zN1HPx77OvAiLQgMgnAtzHbPzI5GfvCqc3IgxhMLdsLWXGokwcFnttSBSvDH3roIfUXBzusa1v5NpPiEF4JXD0voa248=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 5:55=E2=80=AFPM Tom=C3=A1s Senart <ts@perfloop.ai> =
wrote:
>
> On Thu, Nov 12, 2026 at 12:28 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
> > has active swapping processes is naturally racy. The limit can be set
> > to 0 right after we check it again anyway?
>
> Agreed on the race, this doesn't try to fix it.
>
> The case here is different: with the limit already at 0, every store
> writes back an old entry and then stores the new page anyway, until
> the pool drains. It's bounded, so if it's not worth a special case,
> happy to drop it.

Yeah I don't think zswap.max =3D 0 is special here. We can violate the
limit by changing zswap.max to a value lower than zswap.current. In
future zswap_store() attempt, we will let it proceed if it shrinks at
least one page.

The hope is that in the long run, the violation is bounded and
self-correcting, because the number of objects in zswap will decrease
or remain unchanged after every zswap_store() call.

