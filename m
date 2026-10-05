Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E8BCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6656B008C; Mon,  5 Oct 2026 02:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE096B0092; Mon,  5 Oct 2026 02:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B963D6B0096; Mon,  5 Oct 2026 02:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8906C6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:36:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E40C1A0129
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:36:18 +0000 (UTC)
X-FDA: 85287613236.29.6F94E4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34450A0006
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:36:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OrbE4PEd;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791182177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbDE0v1NrHNoI7W+4NVAoanI+Fqx6m2jrPk15Sb5Q2c=;
	b=DnhWelaoWGPiQ5Nx29SPcPeRyFM1GnYbp632TbjskTj8uD/q/2u+ugKk0JSUJrgK/r5gV8
	l3S0KP6UDQ5uZzuToRhU8c+cXdcFhdK+shbmeT0pQ+NPe/zdxEheRqT1VvamHPgmMBF0eX
	LflvA9BeBEjPb5/VkkYFYuaSofcTbGg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OrbE4PEd;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791182177;
	b=vh/ed2dT5S6zBaFRpxdEXFWpUQaRbWRMllU0Uso1mvRfPbnlUKcwdASXShi9XPzDnNEKxA
	6MY7zJ2vFIRl9+X2eKKTucI0hV60+5xicFlbaIj4JLKkPkiPqxhjSO0+GYl4cij5dUiwem
	N4Wv57GIj+EoJPhRw3GdIE3mz0y6xNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 938E86022A;
	Mon,  5 Oct 2026 06:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF11F000FF;
	Mon,  5 Oct 2026 06:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791182176;
	bh=mbDE0v1NrHNoI7W+4NVAoanI+Fqx6m2jrPk15Sb5Q2c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OrbE4PEdyLw5DXjC4jcVD/Tri+x0F2xafcSrTG6gZSBwEEnwX7hQq0Nbs26c3junY
	 EWq9jV80bGcJyrkrcmdCQ9jtbwZ/alCT7O1sUn57Va/TUcca+V6cydKzNTblpHA0C2
	 zycxKNEimZNI9MGugDKAfwwQT4qxQrJdwDFprQdE=
Date: Sun, 4 Oct 2026 23:36:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: david@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org,
 roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-Id: <20261004233615.df26e580c1bc916c7f3a23b2@linux-foundation.org>
In-Reply-To: <20261005062236.564210-1-vernon2gm@gmail.com>
References: <20261005062236.564210-1-vernon2gm@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34450A0006
X-Stat-Signature: u3uh9tp8rexii9n6wyit4c4xt4pbzuf9
X-Rspam-User: 
X-HE-Tag: 1791182177-202766
X-HE-Meta: U2FsdGVkX1/DZRV+fEoYnwKoihtpRytkKeky7pzyZBUuYboXO05UX3U6wv4XV9Id5djwMAmveV6LY6pF25IMIY9oRHqbcDXRPC5VAeRYDBhMuY6Gu/vvwCDhlbHbLXZhzU0Xwp03w9fYNGhR3NANLgrmit77Dyg3dZsVtDxLCYJx7PcZ5eWpGCuYXzbmUXkvoWtl8iSZcH8swY16OJODl+CpSYI6dpPEVGI3Mb/Dh99baIU05nWZWRkTkegM3XC/buW41nsWY61C3AE1FL9hRQ2/BwKndzoZp+D7oytP9E+XEN4WsasiV6dT/pW629xdHJwsHouXrEp/IiVFgIiyc7AyOZxgHgDDJ20446xalorN0XkZRaziPfa2e0JEH32Q6j4RRyFmYi8xGLvPqdbFSEkAlOwUawsY4vH86EUctYqXXwT8LGPmTJeSKMbuiQYhFKKTrl2+C8bOANQ1rYKmjRdjBLfjUDKS6dHpl+BpFILsnzTfzt2aKm1xxWz23t7/nhXtxfvExA4wjowTXXm6m6wQxMcnRzrXGjT4jyUMqP2Zmamu7Fhld4u/6RNMO1I7eSjtqWynZA7j1i5yX1PzkODICNa541PSsSHomrQEzlSJFckZwopguAH/Vcbmhx4QNHL0f8x8vb1Vcq1gwjrjGz9Re9dXxSHmb9TvVmQKVGms3tKDhK4BXve1yZiXoAHdxmvppAaBGyuvXqPw6NsJ6aIQBjdYyskZCUd9W/ujD/luOW3c0hL3QQGFyOtroh2Ec7LebUhALNMAqO8+FbGvQ+MqpeuLHurKUBoyRrmg9ExhMZjK2y5Tjaa511Zw3Wg4CAznDbLlORAafYsEZ58uNsZYw81KBNMA7CS9HCII2UhxhKn+/0VEzsvyhpgBiOyf3fZ86962KgFTZRHNbiv0gQWAluOR70GM+BZahU5y55Il3K4hayDmT/ev/Ab+wuqicHGlBteQsEZ1NTjCEfn
 ciaoCH/R
 yHUkfQHN7E7Vmt8EmXXFrYap7H4YW/lW5SsuVzGjG6aFyla1HHtWpat6C4ekjeU/9amaNhAXEcGZIWFCHQhTvsmK8H1vUszEaLyoaiSKH83p6eYlefNwFVQs9/AIPZRRK1hIBbHZqwXT1CBTytBXFFouBYtvNoEFZMM7ALStl0SxjlRzELW872TT0YkcYl65sZjEGEvNf12nCoalF7rmG4nRfp3WyOIZSQgG1HzZwp+0sTJNVm7a674px9Skz8Ad3g+q1ts2sqMle2D+/w1YDB4oDJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  5 Oct 2026 14:22:36 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> When the cgroup has no memory pressure at all, writing to
> /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> NUMA node, causing increase in the writer cgroup's memory PSI.
> 
> Due to this reclaim is performed in the context of the write(),
> accounted as memory pressure on the writer, like
> commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure"). This is unexpected, the phenomenon resembling
> senpai will appear again.

What is this?

> The Documentation/ABI/stable/sysfs-devices-node documentation also
> notes that "This interface is equivalent to the memcg variant."
> 
> This patch unifies the semantics of the memcg and node interfaces:
> per-node proactive reclaim is no longer counted as memory pressure,
> and the per-node proactive reclaim interface no longer produces
> phantom pressure.
> 
> I ran demo[1] that performs per-node proactive reclaim 10000 times
> in qemu, writer cgroup memory.pressure as follows:
> 
> without patch:
> 
> some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> 
> with patch:
> 
> some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221

