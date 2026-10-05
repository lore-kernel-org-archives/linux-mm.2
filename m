Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0E9CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A71C6B0088; Mon,  5 Oct 2026 06:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6313A6B008C; Mon,  5 Oct 2026 06:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F89E6B0092; Mon,  5 Oct 2026 06:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274F26B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:21:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B37641C0BD9
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:21:34 +0000 (UTC)
X-FDA: 85288180908.09.0C1EC1E
Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD8FA140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:21:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qVbKiWvp;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791195692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0Zp9opT8YiIxnyesajyW83vYzMWJ2UB1wS3KyXFGYY=;
	b=FnW19NolV2KO8B6QO78lYsWuQf0JIXxzKc5zTAF0WtG1zwxtuJTzhBM7ckLzDSD4PLHQWH
	ybDYrNEg0jwSkQIW3AkD0BhZyF3bLjDlpRT8r3Dh+evdZfuxhjvvZyyQXxH2GcY8Bxpigt
	7zpfBWwZhs1BRJqEB7zsp+eBoNLPFL0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791195692;
	b=Q1FC7WIB53rQZ8fIXL4/qaP4DgD9Yf5mcT4moPrDaCfglkEsU2P67bJsydqt4p+KTkRkoD
	LKTAcgjq7eRTCREOObYmpQK0lkLsxCkcYpQlNqSqtugRYfkLdxC29gOMC0MWMbnrWbmOT0
	jdOlvsEHNkwhvsVSqoQLqc1AO1H+hts=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qVbKiWvp;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.227.167 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a49896dd9dso378007a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791195692; x=1791800492; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K0Zp9opT8YiIxnyesajyW83vYzMWJ2UB1wS3KyXFGYY=;
        b=qVbKiWvp2mAIa9WeYC9cjpa549dUBR9NNX1eGUStr0xHX7b19HgIG7GPI9NPOybhus
         tmPYUeVkn1x0jPH5mw6zDj+/2t0YeF40A4wn4kthJSRGMF9ufO+RnqH68b516+WUs3vP
         Ws9zwTpxjnlyDwPA2aootUCb/lJWyVIK/p5i5Oa8qQchjM8sQs0HovtspXDgWONKYPzl
         T6oSmV5X0qZgmRg02Yq25FokTHd55KUWIAHBJKh7tNmyVacAo9aU9zgntR1cqpXqr8NO
         mMsfUPDvdzjztWSR2ITFi7UEL0obg1UYhDWMHA87GFwBUoRVCs+9UaoaD/nJBFMM891q
         C2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791195692; x=1791800492;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K0Zp9opT8YiIxnyesajyW83vYzMWJ2UB1wS3KyXFGYY=;
        b=rBBFMQsHAqwpYcHXjzh67VUpweBcKO2+DnnOVpglsO3oRhGXOU2v4MCnw/nm3QZCXR
         dBiz9KlM1TRsikFhH5EzKFAhtR5HtNVCohajgK7TSpP8tcDVGywaFtq3d1fmvlHLzoc1
         mTP2/2S1es9/XQeWC1/w9WyRhPudEIDMr4t93yo8fvFaHMqaPWyDuup//yZj075jNLLj
         2CgsDP6IzbQg0OrXYGrSSkU/ytfFWvnQzfGED5upWg5/TNkGvf9jRu5gdf51X/uxDT//
         FT1Cxd1MSAO9nwNOu7hbnqMP51feBdtBkf/3rqj5+NZQFM5ApPqiI2yLEK2fntzC7CW7
         BPDg==
X-Forwarded-Encrypted: i=1; AKwUvBwBayOjQui1ggvekDXOB17s0NNIMd/qPBDKfMNqknh0aiK/jpCXbrwcF3uHU48Xt06VSB1bL0vivg==@kvack.org
X-Gm-Message-State: AFq9FYKxTm5pkmfiiCD7Jo7hUmbMtxKlqlEIMk8F+5mWQFIIzbAj+kbh
	4dvYuctwS/W6TqvXihCa+Ppe3rS++ai3VZud+8K6ySauG7jSguCE+pAt
X-Gm-Gg: AYBFou3G53+8Pf5sptgU9jQkz8HyY72SRtjxLazFFzgQMvZ4HYgcWvE96D1X361G5lU
	kmFfGCubpxCXBBWWdurmhEYYa5AkeNpsP1AGdT3vb8wMoJTHhb36pNQmAPmp8exhn7h5uFIWEH3
	oSagLTtHc2uwlJwxJCA3gSsF9xq0Cep/7/CP14lIBqiBHwQXe/Dc01V5kL42GmCke+Yin0UAehI
	cNWTwCsc/fLrHzGC3D7q1HvfIhXOMq9kZNQV9kjeA+PL3pj1V99jR7UHfTRaGWBZqlldiADv4yG
	tJThwLTcO3RExfiBBQH5tzKZaOopa4hgXsKa5KC0rMkKF4qoWrEQd3AXpqItvemkrRfgsU2zWfE
	f/U+dVrNfXhcAPycVCmpxigQ1+aGnVCAEgRCVkyb2hTFOUPyq4hxofXD5wAyzI80liWfNgIhm/g
	dH+fkZBnw0MgRhx1jVbqlpaJ6z26e6zqoGOLPu9p6SqFJ0wbb4iOo6XXeZRvGpvTN5lrBo6hydj
	L8enTwaS454GDRqDyXBJFzH
X-Received: by 2002:a17:90b:5483:b0:3a4:b509:88be with SMTP id 98e67ed59e1d1-3a6ce981729mr5582306a91.15.1791195691651;
        Mon, 05 Oct 2026 03:21:31 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6dd0cd76bsm8291372a91.2.2026.10.05.03.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 03:21:31 -0700 (PDT)
Date: Mon, 5 Oct 2026 18:21:23 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, ljs@kernel.org, roman.gushchin@linux.dev, dave@stgolabs.net, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-ID: <4cdb95f5-4140-4116-8247-c04f4b2a5c4c@gmail.com>
References: <20261005062236.564210-1-vernon2gm@gmail.com>
 <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD8FA140005
X-Stat-Signature: 9ff87wr479b9ynpwuzr55yacriwotcgm
X-Rspam-User: 
X-HE-Tag: 1791195692-906820
X-HE-Meta: U2FsdGVkX19BqKcGOzlLXO4ZnCWC8ZKd0BEtDAFJPiCtudc49r6BR+KsmyZKQLiDNhlzmuEAICeRyN9uZcuC7mrlbuFBUoExoZK0XVStvElsIq+6AsF9tUyI0TUFVa2F0LDShWkLpgLJqCIZPKLDq9s1bHuWaDQQq9MNujXww4rg6dVVhYTNsntWv+PVVjMihUYhFHiZmaA0404Qf66kui0oSATYoals9sfZcL7Up3oWIWsTxmRwfjUbYWEmXxsPl9+6QR4oHv9FLMMcgDSVtNnj8sXBxXUxj9mbC73NquOfhughhYNXm0QrPrHZEiUhYjTOH+lYPtdaHQTvra/HvUeGnPzn8dh3hjrFNAIqdUSaSjmwFoQBkKWaQvP0oEHSM9W0cUo8P5puOZC/lG300Yz/nqpBKoRx9YI3HxzD1SN/zUibqgteg4l/oh0W1BAsV/bUldZqcNCURJAF6okikQdsvH02JrQ9yR6L1RaWcpTxC9N1V+A43KPISWbqhtBGeNA3nWofRVjVhrl3v62GctM34laRgg2CCUCVBvnVWG6UPNAcncFmwZ5G4r7vUoJXH+xu8l/yGCycG5CKV3mnrLykNquG0s2mL13/FRxO1ldFzhcv5X1Yf9cC5aSiVmejPPHClqDkZIy7rwEOS+Oppm5BZxvVxRanhC981DDh5aVct5p69gqq7UrL+OquoNXV4kyXSnXlJz6duF7ze2nq/n6enSTvNI5tCC3vZ3cnFTFvnI0Knkqos22yih1F80963zeM/FK5r0xfru8nLXb5IhCgbVzGljEZcjD97YCQWRKTQM40rqIpo/Ekas/3uv4kyhrNph3aalSG9poNiW8LHdEzB3vO7kd8RaLMg3LIbp8CLRPz56pL3pFH9d2klrJbwLxh3F19yX+5UwJCG/Y7ZG2B+/N2DKBgGZZ/COQWFEdVuJfdTjh1oL711c69soWfjeB/BDz/EgELIBxWIq5
 eMDpQH/2
 KB8IQ+F4hNTlIrBjDLyiTl7oHMRv51NZY13GGRw0pJOyYoQNf6ssDUlegm5yFBuak6DWQXoqDPrK4OuI6kGtOzsGb+5J8yItN0FzRA9UAe5KZ5zBG/9yTME7F5ZQMZU7G2JLlHddsGTPA2X/2CRPDmaVcQspVRKJWss4POg+Xo/X1k/aAnAa3qtuIwFDCd/EYUZvCz8UICvOV4n2fFduko8arS1Xu9Tx5D6oX3u7vy+x1/JWTXKQJoVhdRFwe/2IubXbeV25uGrBs0ScSZoSBScsK/gdnCy7C91pihVPFKmdvxPXnnpgX/BegoHBJYNpKcExOrJCYqDwEeqPCjD5qJWjQe7haMIoexyVJVl99BN7sOKQbD6srzvMKvI11pQyjPquWmpo5FmHwq+VlUNQhmj9Xgdy8bWZadGWO5DCUieSkUpCoDaItEkeYqz+Po86l7E6e7X2MvFTZiuFyTKhiyD8ifKBN8kxyYJSRwTDMi8G8OHNuVgsSyh9d9AmlHiP6y1IcCfVC4+tBBD2/YNr3uW7+vgDrhgRGgdGW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 02:30:36PM +0800, Barry Song wrote:
> On Mon, Oct 5, 2026 at 2:23 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > When the cgroup has no memory pressure at all, writing to
> > /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> > NUMA node, causing increase in the writer cgroup's memory PSI.
> >
> > Due to this reclaim is performed in the context of the write(),
> > accounted as memory pressure on the writer, like
> > commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> > as memory pressure"). This is unexpected, the phenomenon resembling
> > senpai will appear again.
> >
> > The Documentation/ABI/stable/sysfs-devices-node documentation also
> > notes that "This interface is equivalent to the memcg variant."
> >
> > This patch unifies the semantics of the memcg and node interfaces:
> > per-node proactive reclaim is no longer counted as memory pressure,
> > and the per-node proactive reclaim interface no longer produces
> > phantom pressure.
> >
> > I ran demo[1] that performs per-node proactive reclaim 10000 times
> > in qemu, writer cgroup memory.pressure as follows:
> >
> > without patch:
> >
> > some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> > full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> >
> > with patch:
> >
> > some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> > full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> >
> > [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi
> >
> > Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
>
> This seems to be a valid concern. Personally, I don't like
> having the code depend on whether `__node_reclaim()` and
> `node_reclaim()` are called from proactive reclaim or page
> allocation.
>
> Can't we check whether `sc->proactive` is true? Am I missing
> something?

It is also fine to directly check `sc->proactive` in __node_reclaim().

I chose the current coding because a previous similar fix commit
e22c6ed90aa9 was written this way, and it is also very clear.

Of course, it depends on everyone's preference. If everyone prefers to
directly check `sc->proactive`, please let me know clearly. Thanks!

--
Cheers,
Vernon

