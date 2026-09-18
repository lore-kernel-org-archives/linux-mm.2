Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4614BC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB936B0095; Fri, 18 Sep 2026 12:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC636B0096; Fri, 18 Sep 2026 12:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B0E6B0098; Fri, 18 Sep 2026 12:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF9856B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:24:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C91F1C2FEA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:24:14 +0000 (UTC)
X-FDA: 85227405228.23.DFA4572
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id CBB1740003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:24:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WDJd7G82;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789748652;
	b=CzOmG/iAO7HjCUfb9YY16cnuyGmQSQ/KVPgffMV0M8jkzY3r08t2a/Ihs54XVJBr6CFuhb
	Y9N2jlA/JUG9+p254+scZEbdSEircoWvS3NlhzjVKJ5KxDs+srNZHhTwIShYT6PT1ueNCl
	8hwkF7shA7hlAexPdjp1tP772KI4AVE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=WDJd7G82;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789748652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22UHuqAYfKNfgslt+w3Gb+mOi1pe1zYpAqvus/G0CRA=;
	b=vfN37aHOmBz13kkZ9k4yW4kXuCdxXs878nYuDpCnJzpmItUBF12yYQH5lrbItUEFCrM+EZ
	yMFME0OHnaKuSKWeeOQCsNVflf6ALBcWZM45E8cVCZcB0t/oCTREHpLbYZ1MxJGloNpBaQ
	28vzLjFKIAz64Y97VqX9hM8haQykZ30=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910c9ff1cso77838285a.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789748651; x=1790353451; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=22UHuqAYfKNfgslt+w3Gb+mOi1pe1zYpAqvus/G0CRA=;
        b=WDJd7G82zPrv97jmqmdxKRiq+aQ6NaZJk6fyHkH/x9zqPIdSkvpDHqK9pHnReBTZ+N
         F4HeqE/KUqhdB34dRIA6+Jp24DriA8LTMyUMVSWRYmZFZKDQ2HmOPbddKCSAFNOGTXjQ
         xaCyVcpR8G3Nsrmu5YzUxLamvFomEBGj0UJxEy3MYNY2sofdRg/H5OOchxTmv5XqFkpK
         EEnyVcCcx5duuzRYtQb2Exjbrc8XbD1Th7JSxj0Kg5IjfvT0EUTirCLhjkbycIWK2EK6
         G5qyOrYeIXgf4HDVyJQImJeBPvioMDbDJpxKeITVhlSuKHLHjK+ujKWr326giGCNdRvn
         bRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789748651; x=1790353451;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=22UHuqAYfKNfgslt+w3Gb+mOi1pe1zYpAqvus/G0CRA=;
        b=GEUK+OyqMRMuxT4EwiSAmF36EtFI4pkh9MQSdulpjj5H/vDkmiBSPwBszX87iMdtvE
         qevRdJCcrLi0kIJBsjSg4j/ZazzgHt/0qXRYQoVL38c/RpurPweWxjBtUyWP6Hc+3mhj
         3n7CDoYrW7Vsy+Dm3ccDIjRHyiQ9x9raP4yD1FqeUys7RsFygJfYgyOg69dA9JJXSyiW
         hsaSg4IgYM4VxwDJ5Bb1D9KWd8j9KvQYAvJmiA7WdigvKQyGxZf6guILeRHNUVJd5BSv
         XnqHgUkETlKY2B56jUvoVVCZkC9dTAVOTE7QJ2tALFORhA5AKZnfc29WJoTVUJjTZEZb
         rrrA==
X-Forwarded-Encrypted: i=1; AKwUvBza3m0A59+pyDD17go36+xtrs4PW2lAyNFfgQkR921s9gcSa3tK3KlsR86xqpbSaUDJH8XbXchPcQ==@kvack.org
X-Gm-Message-State: AFuF++l9T17+guypOi3PVFWKucMLoXERouwQxejgeVUwvP5LfnzhyF1g
	dTXqd7OSm/qe9p23xGgK9AtvImNMjT1XAlcEoV1bClJp9GP5LsOag1rpTOY4FtHRvxo=
X-Gm-Gg: AYBFou0fz9ONsPxktRL5aFHLiwQcMjs0grVDZFecauFzxkzuRXbtBjtXkoO7YG3by1g
	PTSOmIBn6/gAqqr86bwcHbUV2xE5ve8nwBnd44K8C/eWdk5bICuE4fdgzgIPVwl6dIwHA974UOX
	T7BWd6k3g1sWx2q6oX6hL6EW2mq/gOitARrMF7bB0fLR3ANuH2tLljsjCOy3FBoWFf6dngsD/eY
	7aXgGt22CDgO5O8Yg1LMNv3hKrTo5fvNlUKh94IwkHD45+28WOYIg5v9NKle6V1l37itg3nWN/V
	+atJxzYa/vNXWT7bAfWoZfxev2rupkDorsDO1ijdYU6IXu+Ejuf0/8xliIMSfuyqkqRY0vpuyBq
	ODjd8y3gS6XHqn3Hrg49o0baOje23tBTAN17GjOTi9Er5bOWYjuOlqECXhplVyf0xniKNVOdYF3
	9ErG/Cfiyc+sVCG2/0NEW/h7+8MqZx84YuNM4mmKp+4T99Ddla43qmOrSPehpGDprHpyUVVg==
X-Received: by 2002:a05:620a:4455:b0:93b:da6f:50a4 with SMTP id af79cd13be357-93bdc6aef5amr427968285a.36.1789748650894;
        Fri, 18 Sep 2026 09:24:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e95a4asm173223285a.18.2026.09.18.09.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:24:09 -0700 (PDT)
Date: Fri, 18 Sep 2026 12:24:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tao Cui <cui.tao@linux.dev>,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
Message-ID: <aq1lqJdVZ1stTKCn@cmpxchg.org>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
 <aqxMk6yaiFHeeAAg@linux.dev>
 <aq0HNe5s3zvOnM_I@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0HNe5s3zvOnM_I@tiehlicka>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBB1740003
X-Rspam-User: 
X-Stat-Signature: 38co3g1e5ntr43fb58nkbsuuj9wed9ho
X-HE-Tag: 1789748651-84456
X-HE-Meta: U2FsdGVkX192/icG1Ps0KMOR2anVuXBGxFai+IP9YmaSBq6L7Lhawt/yHi3Rz5ON4vtfdiudPXSU3kwtu+sGjsK+FQfHkCkSjnd6vNDzHSJu2kL8EeTeTimQJJBQzeyeJlPZq+ApzTu7XottxPUAVDdbzZah4FiVc0log/Zp5ShxdaOe8R2IsFxkqS89ZPu3s7TtEx1OKl+EEvFUx06baP1bHN365QUE8lUsUbe9B0n2Ew8S5yrkZ2KdcFw8B1QiKW4YfHSfvmdYj4AVxqbT83fhSs02ykcSAW6YEecI68A83h1wxDV7sGZDZgSx/w+QZicEOZQ9t0w0Amn6pnxRJPW2VfIvcuTiTU4zDGgDzPpACmbpLH6kJhFFAR7c6KX/4VA0GQakRvnvKaOTA5c+76PwfG44/0l201ofX7HAlc2z22Mmif0TmpwzMmzfyuFehQXy1/nPRWbAxLjqfqJLZxk65BdeMDna1CWPCsvIoFt1T6eQuiqM6MJfDjuTGF7DVW0WnsmqBNG49khNJ8+IYIAWQ5pYuMpEg2amFFPxWn8RMqI5uQcf29/99O9zUYLwE+kXdh1zM4ptwdLqlq5llEUibEeS+T/DedApORjxz4L2NyR/zvpc770ZgU3ox57v/1Ki/bJmgAdeICe7AXu1HoDtcIpq3UlT7DSv/PsRw8DYTFOX0XxrvcjsWEIuQ02j42mlMWxks9bsmCGdwaY+hvnGYXJffgAXyXfCgsuDMY9kc8rPuMVEI5RC8QIuGEZNzyQV+X+TJ0GScirw3d4qGDN8f0z1MhDyn+bfln0zALmR6fUVxDdGQmaOdjoMR2+HNpeLwxCdsX0ztzkhnWSzrJtM65LPIfRbTUNjFxnNNFkWmkXFo1KGZpz+uNn1XLGR31rhrFgC2nPtY3mGtnrc8bNT/KzPa4s8lu3L6Er0RMU/6OnZYooiqzWKp6RJHtvMpGBzAirgDApTa07Fq7f
 ECJhnGfB
 0ISgPXLep9ol4DpZORvlL/beS9F/cGCFsiNDidIMi0tj2iUh49Abf+zDUzFbDXKBSDqwpGF1+/CxMtCbwLlNgVb7g/b7T2mDcXG5RerE+vVngbJ9jJ6uiczR74X5qZ8m+rjcaIbe1Xk3fSs2kzM+wz8AhBVfeSXX9cMKGwh5SydRnKGZlhZYH0e8nnDbEyT+ijVTLjbSQudyjloG/Kbwhp/kJmE4+Su9urQghjQhGtK1DPnnLnII53nni0B7SP9jC7Q0tuJ2GHS9SQyAnlLXc9NZFBFNb5en+nnRgQUGQhdvteDVkXYSziWR99ACLJDrD2EcJColyJXjlJS18SSdfLmRo218zGa9rn6wpulpb+7ijsA25/gZkAMyd0BtHq7PBus9+Vpo+HcyY/iqpv7t5Dk6sizvdkbGtwc+479UPN3dhFbnC0TJBQ56hUX+5LhLthGb7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
> > On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
> > > From: Tao Cui <cuitao@kylinos.cn>
> > > 
> > > The legacy cgroup v1 memory controller has already been moved out of
> > > the shared implementation at the file level (mm/memcontrol-v1.c) and at
> > > the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
> > > per-cgroup state, however, still sits as individual members inside
> > > struct mem_cgroup, guarded by #ifdefs.
> > > 
> > > This series isolates the deprecated implementation from the shared hot
> > > structure: all v1-only members are grouped into a dedicated
> > > struct mem_cgroup_v1, and every access goes through memcg->v1.X.
> > > 
> > > With this in place the v1 implementation is self-contained: its
> > > interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
> > > its eventual removal becomes a localized deletion of this struct
> > > together with mm/memcontrol-v1.c, instead of unwinding
> > > ifdef-scattered members across the shared header.
> > 
> > Sorry I don't see any benefit of this code churn. The code is already behind
> > config. What exactly this code churn is giving us?
> 
> The only arguable upside is that this would make it ever so slightly
> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).

I had the same thought. It's kiiind of nice to see which members are
completely specific to memcg1.

> I am not convinced this is sufficient to justify the churn either.

IMO it helps that it's mostly in memcontrol-v1.c where the chances of
interfering with other work are pretty slim.

The patch 1 + patch 2 split is a bit bothersome: indenting everything
into a union, only to then move it out in the next patch.

Tao, if you folded these two patches to make it one clean extraction
and changed over the sites at the same time, I would probably lean
supportive on this.

