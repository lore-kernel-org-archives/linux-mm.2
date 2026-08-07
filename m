Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0092C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 18:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02596B0088; Fri,  7 Aug 2026 14:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0A86B008A; Fri,  7 Aug 2026 14:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99FE86B008C; Fri,  7 Aug 2026 14:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC776B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:47:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B9AA120186
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:47:16 +0000 (UTC)
X-FDA: 85075356072.27.ED37C22
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id F1596100011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:47:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QL4BooFU;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786128434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHkc9rDqUe2P8JaMcDwcL4akwJKzjI4/vsUwMy8sChA=;
	b=uOu4hPnz6Cd4nHkw4Kxy1rqaE/Q+yl0cRkqnpJ8/cy47Hm/nx//maTS6zmCrYN2YgfFO8T
	hZ7LVauhn4FlrDv+wGES1daoIgeYNa4rGZ2G/Eh9MXQ0YdZ4t20w2k6qO39/avu1nnx5I/
	rst/29p+u75mZOb9QlNNaCQh1+Pv0as=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QL4BooFU;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786128434;
	b=yRGH/zYQBBR71oKrob4Z1214EmQCM68svSGauz+Ka5W2kTd9O6srp5v0oF6KH/A4j6uqW9
	Q8d7M5A36ZKUYzWf9sSiHs6N1yvTd66A28JMl6YtEnutzrGXQGARb/t1kBj7v7DOnWubvP
	5gZVlhPNKqIwbcSZs5iFoKsI1qWxNZs=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-480001972b8so529633f8f.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786128432; x=1786733232; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hHkc9rDqUe2P8JaMcDwcL4akwJKzjI4/vsUwMy8sChA=;
        b=QL4BooFUZSx6C2J5XZItheujD31Vg62yNNXXWumVZiX1KsH6gmG8XhaEy3UapMOOCy
         rVEHhSeKD/CLPRbfKx6Q+OGHuIf2/KuUrykklL5fd4MUuVWokd6DWtFF5SOUPOIbJIfR
         ZijmLifpuj0jvoTuSZiD393TqVBRI9FhhrZUW2kCChJltiRT9G5oupFcHzYgmSM+5xrw
         yDzmXOEttFhzgxAog2tfIfgcTMjp60f1GwlaaMhg5CpZIeRtOh6EA24cJsX1bOZNwQRO
         ciBTj0tAHEJFdSKM6lVAGLQda4Is5xR2g4D6Tu/q8ZZGtulwMkPzyJThecUrCRhDuT4R
         py7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786128432; x=1786733232;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hHkc9rDqUe2P8JaMcDwcL4akwJKzjI4/vsUwMy8sChA=;
        b=KpN3uFZuR1iPeVnI8t1boDfu99GSH/K8/jm8Wir5IiIyFTKmy1kNDaiGUaxzYGpSuq
         xO2/1x48HTarSu/G5QYt6uUeFzUqoffKtWm/Fvo9ASHg6QtQNv+QqdmnZNf8GtKgEIYJ
         Z0zx13wwLi9h8wi4qPgFvWsGMnIoK5lFeV83mbk+ccI/bufBXDi6f74l5P4g6F336y2Q
         X5/BO9PM7dSijp/otvl2NALg2tav6/vAThYZxaZvc56jg1D+nv9eoT74uQAYUdVW7cEc
         yYYfYCW7WMtsJjSBJThOgfIiInkfW8NOhvl1wZor2OMBZJ2DCxPmnirqSR63A3D0onZd
         7LoQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLMgbYQwSxISjwU7wSTukDrHd5oGdQl3IFFfap9dRc7DDr13y/l8vWXWC84LpO7SvDnOAJuCN3DA==@kvack.org
X-Gm-Message-State: AOJu0Yxqa6IwG/jf49tSjfqaftuW3gOu9AgwIfP2P0IxkIkSu4O91haE
	uFSIHdP++8AUnPdLQr9Obda99WsUgQR/MEmFSjZ4PZnpVO2iSN6ZYF0khjAOMCsa6dQ=
X-Gm-Gg: AR+sD110FyWOqMVNNoAdkV1a2Tp0i98UQTj6VdlEvRtS4VwQXAvGXv1wX2AlUc928KA
	JCloI6zNJ3Dy/GS3YOU182qFQmBBupm6FKSIiH/u8+FDOXIaAQtDeN+7IoBSCY6PiDuYBf3u+YJ
	Pja+/nvXOT73dyA07XuDJFcqbEb6LSviAMCYGpwPhGbaYsUQxnpCXz1ayLdS8LxBziHLrWcZPd6
	HDWcYs1cEgl5Ga6gZUW/nz7v50sTf00vQ0vY4vJYUifedy0Pnd6qTdOqqmTTiZDY95QFBdKFmn+
	NPPGkG5O1U3S+W630w2kj4MMU1rDPpX8QRlWcGJieFI3b5YHexUJHQFAQ6kp0zpdWFevHX1CWjE
	xFXslmKOY9e7ZwG3MZx74hI/GwRkD+83HsGtzbTkqOpgZ6M9pGxBLrfRft4WquBIxHIc0T5mDIe
	fpzYphC90ljqurVnMPPoldzfjrJIKvqiE/Ge9HpNHXkFix6qmnrDQSiANaS6RoTyFqZtcw0mn6p
	w==
X-Received: by 2002:a05:6000:2997:10b0:47f:7b75:9dfe with SMTP id ffacd0b85a97d-47fec4f5f96mr31634247f8f.8.1786128432412;
        Fri, 07 Aug 2026 11:47:12 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e8cd0sm8254153f8f.17.2026.08.07.11.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 11:47:12 -0700 (PDT)
Date: Fri, 7 Aug 2026 20:47:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anYoLs1B0MwUNR2n@tiehlicka>
References: <20260806151004.1825320-1-audra@redhat.com>
 <anWSHc04JJBJ1VbS@tiehlicka>
 <anX8VgySSw5OR_Sb@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anX8VgySSw5OR_Sb@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1596100011
X-Stat-Signature: eybqkex41kki6cuju7xa731r6pzuieq9
X-HE-Tag: 1786128433-838279
X-HE-Meta: U2FsdGVkX1+ijz8ch+FsXf0vf++3eGeDgDn78Fpu6TX2aM855/Xpq9c2LNUPjEZ06lZN9kB52AudIoGx4PVT7FaXP0PS+nJZgIkfZzHd4kyWOzyY7Nj1277pVuIdo0btNElUjwXC1PsdoR2IbMs/y5cKtF8XFIO+PH8u3s9jplD2WhnrsSKAjSjyXo91cN1voiUD8UAS648qiOYIDqYLfl7jDYDbuINx0t1wY/Rn5KwTMX8HXFY8yVUhn5Wh42XNXw03ioKbXoP8Gs1Eh89qcK8U/LHW00m2uD3RKAKeOEP3i24VaWMyUSHr2A21jlbquPH27q4i/dIDrOSNaNNy+Jj7PS464Z8/MwjDMAgH/BtZ4XQBkEBzFbXcXUKov+gvRDaYKnUh74ZJq+AtVKuHMNlOQi6yQpYhgizbEcHWzV1mnWaB1cxIVHg1+7zrbwLkFSJG3YoSfSBd3LUysu51X690N7qqw7ad5VA0EPJ16PdA85sXbN0scGvlm41t8cdpuLtuEczdwo3akGeSC3n/vTRoONRLdtNqr/cW7yjEx8p5mByZxBI0x7C1aHQUZ1OfuKzEv6yOU4rEeljJJhdT/1DACJ1ituvbbkQN1VeAML/sA9nmdCiBblBGRJhutO2YDq0U7GoRt6Xj904EFVwxo1nCSDbJXq/qo+34z3WR1qkgfY/J+LUZLpqCjA7UvJp7PJVDC8mRpetDZMUTAUGEw06xAthV/7qjjLgtzcj6wCE9wMtafObNave+8dz+E7veVGXr9mAbjkzZXiJ/kLXuQ9P3/ZgE8ghZYmcNGr5KcpwG2od0HWBgIXANPL89uNxUF56c6n9KprF1a3/RG4vWSZ4oDHbCae6VPCcj1evxEZPFwoKeYvL0x4RbJUgoiCnhhyv/axtnHVjemFzGd1WRexjbhU0LOWyxMFplesbJFFaZTopI+p/yfRCzpNawCy3qy5LtLl1a2UwdsNqIJpV
 6ejLo6QZ
 Dnx7WzXjEbJMceEnQoIE21HEF/qLXBdbYhesGeZTs+De8uA8espwRzLe3KkP8vIK4MJgzTLwIdizoZDkSFDAXG+2BrLvlqMHVQzO7E9R98ByJdvJ0j5aqUFwkqksZH8sEqNK/Ac8GXV+xlqSeiC+mBmxrqV8n2Cfat8R8PuZ8/oF6e6JaJ069Fxuf9yLfcp9XMfljhHowXI1QGIYT/2p4bg0e2+mXvcx89x+fTFFb78P3U97MeIGIOoNdnjc2MfrflZ0KkrZsnnTXlWq+siDPzcOZRGTt3XFLmG0wZJU6beKdwHRxpg6De52sDulBqXCJH2hEqpANoltc2Q49XgLQTLhIZFWx4IZHHPBtdLTDyL5qvVkuUFHY24lv7IE7hSZaJ/N6ZchofhNUqZK9mlAfo+s/sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 07-08-26 11:40:06, Audra Mitchell wrote:
> On Fri, Aug 07, 2026 at 10:06:53AM +0200, Michal Hocko wrote:
> > On Thu 06-08-26 11:10:03, Audra Mitchell wrote:
> > > Originally nr_retries was actually nr_oom_retries and we used it to track (and
> > > limit) the number of times we entered the mem_cgroup_oom path and then attempted
> > > a retry. The purpose of nr_retries counter changed with the introduction of
> > > 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> > > charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> > > to retry within the desired nr_retries threshold. Later d977aa939fca
> > > ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> > > nr_retries counter from 5 to 16.
> > > 
> > > As the function has evolved we now have multiple paths that have a goto retry
> > > path and we have lost the original purpose of the nr_retries counter, allowing
> > > us to take a goto retry path an unbounded number of times.
> > > 
> > > Fix the unbounded retries by nesting the code in a loop and decrementing the
> > > nr_retries counter correctly.
> > 
> > Are you trying to fix a theoretical problem spotted by the code review
> > or is there any actual problem that you are trying to fix?
> 
> We have had some customer complaints that performance has slowed to a crawl when
> the cgroup memory limit has come close to the maximum limit. In those cases, we
> have noticed that each process is spending a large amount of time in the direct
> reclaim path acquiring just enough memory for their specific allocation, thus
> by-passing the oom condition yet degrading the system's overall performance.

Yes, this is entirely possible scenario.

> In the global case, direct reclaim is bounded by DEF_PRIORITY,

Well, both global and memcg reclaim share the reclaim logic. Both of
them try to exercise all reclaim priorities (i.e. check whole eligible
LRU lists) and they fall back to OOM killer only if there is no other
option left. For the global case should_reclaim_retry is the gate keeper
around direct reclaim retries while for the memcg we have more or less
fixed number of retries.

> however, a cgroup
> will go through the try_charge_memcg path which will call
> try_to_free_mem_cgroup_pages->do_try_to_free_pages each time it does a retry (16
> times).

> If we bound the loop in try_charge_memcg, the worst case is 16*12 passes
> attempting to reclaim. This patch is meant to address the unbound case, limiting
> the loops to 16 attempts at following the direct reclaim path. An argument could
> be made to reduce nr_retries as well, but given that the nr_retries has been set
> to 16 for sometime, it seemed unlikely such a change would be considered.

As Shakeel said in other reply, this is a deliberate implementation
decision. The OOM killer is the very last resort and we are giving
chance to userspace to handle close to OOM situation much more
gracefully and also workload aware. Keep in mind that what might be seen
as a slow progress for one workload might be acceptable for others where
OOM killer could mean a lot of work being lost.

From what you are describing above those users might be hitting reclaim trashing.
I.e. last small portion of a reclaimable memory is bounced back and
forth for the workload to make tiny but steady forward progress. While
OOM killer might help to stop the suffering and restart the workload
sooner I would generally recommend revisiting limits set for the
particular workload. Especially if restarting it might lead to the same
state sooner or later. Watching PSI metric would be a good start to see
how the workload behaves wrt memory stalling. User space oom handlers
might be a proper measure as well but that will always be safeguard
rather than a solution.
-- 
Michal Hocko
SUSE Labs

