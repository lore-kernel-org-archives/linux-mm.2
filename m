Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3133606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 20:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gEJqrs8P
Received: by kanga.kvack.org (Postfix)
	id 093856B00EF; Mon,  2 Nov 2026 15:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D7C6B05B1; Mon,  2 Nov 2026 15:48:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51326B05B2; Mon,  2 Nov 2026 15:48:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5D936B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:48:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49D6816024B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:48:44 +0000 (UTC)
X-FDA: 85391367768.02.4110626
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 358F218000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:48:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gEJqrs8P;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793652522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
	b=mhLnZzqz1ipzsou3bVUFJamBuNH+mWQgW4UUd9kE371JvdTI7bBQkkltLvtvgZ2+r9vkkk
	7rm9+2Xa4NqWRMqOngGhdvXERA8LvIK5vG79C2xjEjYyhUx85T3vToW3SHygvWxr2dgj40
	zDeUD6VY8VEAAxgW6omyBBb9jV5jrIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793652522;
	b=zMvm5ctnri4Ng9TfoSo+su9vq9skMhCBO9dLFQWlvGS2qXv3XqlubsmuZb/UJ/oXjCddZy
	x2nGIDQZUzQMVqnP+DsBYYikH/HouaF8BpmuNbUixgW0U5Md3tqTDYa8xpvbiETOkzEo6V
	Vh0MKPCTFIC4ewagp5Hhqh/JR65azNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gEJqrs8P;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2787339f8f.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 12:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793652521; x=1794257321; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
        b=gEJqrs8PY8Nb7Mjx9e1Yec3MjD4YnXS6XgrMvPDCrbEEKbEdPF9HXqMbRXy+PnXujs
         hwDmiPHhZhIsN8j4p4Y7rBcO1xJKZYI0jk4jjj+RyLzocjpOF60s6nzWZWIX6ZPWr8lH
         l6V2fbS/r/EfjS3NPjA5Z3K2Y86EqPSmDAiOxMB5NLK7/Sz+0/+cWr73KuHMXPd8ON1a
         MxJo1Pu6K02U9Xsgqf8DX0yUCbJBI9AF7f2GoxdQYnGftoKESuwsZ8TiYwBNmRExNQzD
         CdRmASimMJgDDWi6WQlN7wZWtnZw/cePRAaizc5Ug4hMWaLO+fSnxcLl4U2vpxcA95GE
         RvlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652521; x=1794257321;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Tqk8hLSfa24lrMQkcg/49BjZeHEkNKhCmyNnUdkMSKA=;
        b=DBCOmpgEiJSsVtQtp1f/bErql1UbV4zWkfj5T4FyPlmgkrz/ZY0mB0cilLzXAsshUA
         ru3gL3pmNrXEN+6I7rmHS8777RuCjqk9nBm6Raq/jzEX9uV8zNuwdPE65hMcMltpfTI4
         kRhmT+51BttSDIISFwtxr+7FuSHXG0pf48/SxwPNBIcF31Oe+6U2zIFqGsf8WuFtT0uV
         leGhETZBkaM/4vIqjSwrQPbe+dGcrv0oQTjY9+gjQ9CNoLbfCG1utAu4m2kA3yRjSBRt
         LRewDUFBhKj+PWpcj1FMxyLM93yzOwUt3XzgNNkDWdcmmcy9cxXlxnD4CpwxaP6vYWGS
         pgGw==
X-Forwarded-Encrypted: i=1; AKwUvBwy5eNJNbpLDOatpCnIuCAbDwvqrwkt+VEjjl+VayRHYNdvWQVevyZCzdFlIB/TR9H4FSRDPQz6SQ==@kvack.org
X-Gm-Message-State: APuU4Z8D5AaXBGEQcN2Si42h0Nr3PhgP6PX+Nuc7WrVo1cMHCvOfxsQy
	VBxa+RIRYUqKRztzIHL0stVEw5UK57xA8ZvgYAAeVHAyMGyENJXd/zIJ3A+ukcrO0BE=
X-Gm-Gg: AYBFou1/ro5nARetXGm9avPNkctzyo1aWswt0XmZDOM3wYzupUVkdYNf3LWZlVfhT7L
	n8ybHwATFoYI45jm4L4ZSN0tCDnJI8tdhIO3Ngz6ObX+jfDGeQw0Gpmvmr+QjrUd5tRQKR477/X
	1odiBBzz3BUTXWLIGj1y0h3PRqsd9fSsGFvkw8x/HaDSmxchi+3XEBHqZ5WQp0vIm4eUuVsOS3T
	+PNCjGOLWr1ECtxwAxL338QNlv6GTXAtsjC50hEVDEld7TnlQiDK1QHWlL6mFFMgeW6fpwupdCO
	SeEWp14KExBKRCTtVaFKO9aP5y5wDkM8yx5ZWkGgsakUkpXveYgtluNJ0TYwvnoMmfRZcQuWvCF
	lE1wRz9CZGkkQ5zx/hwl6Z9/c5CSVFdEDWrlMYWcilf6sCdEP63GzkCLBS8FquQhYGdj8/KIU+g
	f9fHE1bxjfWGHnOXcvNOsljG7O4Qq6TT9F94bybARzcWWxVawhWTXDAhz/dmFry7erusNOr1EPb
	ty79XA440xaleXL0UwFcHhi4L+GYxv+H4sGA4Rc0AgkS3LFZ+zxBrlK3z5QbK6SQztnp/UTmNAN
	sARSpAvHbE0Gz0wu1Pw2BSp2Zfu3yVsiUEn2Llo=
X-Received: by 2002:a05:6000:2889:b0:48e:f10:ceb8 with SMTP id ffacd0b85a97d-48e6e2e769amr23073454f8f.11.1793652520570;
        Mon, 02 Nov 2026 12:48:40 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80ecbsm22252091f8f.35.2026.11.02.12.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 12:48:40 -0800 (PST)
Date: Mon, 2 Nov 2026 21:48:39 +0100
From: Michal Hocko <mhocko@suse.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Tao Cui <cui.tao@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <auj3JyE47UjKa3ek@tiehlicka>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
 <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
 <7ia41p9341lv.fsf@castle.c.googlers.com>
 <aujhaEfimB0S5Msu@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aujhaEfimB0S5Msu@cmpxchg.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: q4pc3q149ybyiprnkf78tbw937ohadnq
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 358F218000A
X-Rspam-User: 
X-HE-Tag: 1793652522-51838
X-HE-Meta: U2FsdGVkX1//yn+4TUJJgKOflSgaxLsDcU6kRg7oibkrWPkkxkd92gqlBvVWoil3jHB9KPMa301hGa0UJm3SDZyjvDW56IuV/TFC9eVSAqYgI7cxqvznB7rcj07Lb68XPNCtDgB2o5Hy+aOY1bMQ7UTm3UBKXaYQU8yPM5tAKRl7mjYCPHEYtWeb3ohy+35uJJhGdguy5GX8lUBFYofvGiMv0pP84rUpSA/EqeHCkT9EtmUSfSzf72IOgRyFLN0agX9SHVzBSjZDmbCV0I/wMLpWYJfgVLbPJa78nFgj0u1qsywHH/sFi77jHw60KFBLUuYL1E9ygOFVtGifDBnRett1FxTKXZxav3nahiSTD8bjM5n0ltYh+KWLi11q6wv653TRr/k6pM6ri1nhqtChIMkGs0LBbNUaHhBIZ6j0Rv2/6DiiMaFtiVItinVSdgZsVzSLd3l9mXEYZx84MjY+npa8OSgo4jXPm4+40n+wz2OlKhe0aiZZCCi0ifZuWzplUt39WqpL4vWRngRgloFBn3Joqo+ofElLLOL5qGN/f4RT1tTjI3HWoR6BfLnJ27YQzLghoRyY2Hf87oDC46i8EOEfOEbPTYBgQvG1x+A4xJ4nnMzB5Xscpe4zZalBrgLo92Da7s0GrI+PG5Zaixmt3AJ9vw7L171af1iT8w9SJBGthOofl5JlrSiKsuScO94xOUxb1gKvLf+rFeeyagGYLMEjbAUr/wtph6o+1aw97BFZV61GhfZf2et/US+UQOP/Uvma7BWm3wTmVWZI6aOED85gRlztPx/tcWW8LD2ypU9v4nw1iuF7Z153VgmNlfsCYgRlyiujuPMl+33mZf4CkMQUUXuqG9MREj14gjjwhyR724oDbEpBhTzkyqWXiGkcpywQj7RGWZyC5oUOmFOXKWN1NMz6QxT9YWlC4imnQ23ovCQrDWD/0cpMNlvqhYeobJaNoWpMnuv9lOS42bS
 MK21rPuw
 GAWXnKNl423XoIteRtd1dk0ZBF/+kuwy7EQdxkdrAktGFds8k1aFAq6p+JtUic6Q9hhL6UtXonfZ3m6RE62JE7V+/Y4Uhmw5hHj677E9s57464z/0EqoVr78bov3sEIQ1q5xOfoi9FHNhmrs2e95IWAvrjv+7gRyGvThoyn5yOH08bhUMaPau4XvpEGBsyONlp3O73cdMrK5o2Z03h3b+7xwteUrUGS2UoTbj8E7lTfUiwoEkZ00YhtejGlGybtTC58c4JFC1RVPvJxht898V5aSBdK4dL7c/k+pBl6AaXK3NJa4apIvke4AKikdZSTfCsvu/aVDvoBaY4vrhaUXAvaTl/QzyxwNJ0HjjBZS9RaStJcuvwvuNQrnNOxGsxwhfZgPwnC3xB2RpDQsN/TxYwuwl08Tgmfw+S1uFg8kg4Ba/+0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 14:15:52, Johannes Weiner wrote:
> On Mon, Nov 02, 2026 at 04:52:44PM +0000, Roman Gushchin wrote:
> > Tao Cui <cui.tao@linux.dev> writes:
> > 
> > > Hi Roman,
> > >
> > > 在 2026/10/30 14:05, Roman Gushchin 写道:
> > >> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> > >> 
> > >
> > > My assumption was that v1 would still be maintained for some time
> > > before its eventual removal, and the goal was to reduce the coupling
> > > between the remaining v1 code and the shared core structures during
> > > that period, rather than to rewrite the implementation for its own
> > > sake.
> > 
> > I understand. But personally I don't see big issues with the current
> > code caused by the v1 stuff. Maybe I miss something...
> > 
> > The proposed changes on the other hand create difficulties for those
> > who use v1 and maintain some local changes or simple backport upstream
> > fixes. Of course, it's not a reason to not change the upstream code if
> > it's justified, but in this case I'm hardly convinced.
> > 
> > > If the expectation is that the remaining v1 implementation will be
> > > removed in the near future, then I agree this work becomes much harder
> > > to justify.
> > >
> > > Am I being too optimistic about how long the remaining v1 code is
> > > expected to stay around?
> > 
> > Well, Idk, it was considered deprecated for quite some time already,
> > so maybe announcing that it will be deleted in a year is reasonable?
> 
> That might be tougher for v1 users than the member placement :-)
> 
> My understanding is that there are still a few heavy v1 users out
> there. I'm not sure they can move within that timeframe. Personally I
> think the cost of the v1 code now is kind of negligible now?

Fully agreed. 
-- 
Michal Hocko
SUSE Labs

