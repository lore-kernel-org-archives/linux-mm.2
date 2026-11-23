Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B5A606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IpMah2Ts
Received: by kanga.kvack.org (Postfix)
	id D88FB6B05B1; Mon, 23 Nov 2026 06:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D393E6B05B2; Mon, 23 Nov 2026 06:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E456B05B8; Mon, 23 Nov 2026 06:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A58C16B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:13:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C8C9C0880
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:13:29 +0000 (UTC)
X-FDA: 85466122938.09.3E39D54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A02BAC0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:13:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpMah2Ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795432407;
	b=zlPTP9RKwjc+ptENlrtcbHIip7PugAXrESgAM+TDCkCPVtSBDJJe3pB+wrW5kD+V0VFLbl
	osUjLWsaHOSYcLbAzJkijeJbe3UjGE1LehOIfWGmbLSf9AcHIRThgL4Hf/Hvuzbzu6lk/D
	4UYVWqb3UjNueMPDKtfWRV7b1lLUH6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795432407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSNPqJ2wns2AgHtQuJTveAPlZdwvlJJAYiPAVLO7n6w=;
	b=bIDbAsRsB5Kgwizs6aTjLfMfGsEFbTByJwqM9jP9EfVWbk3O0uxi50/6hTiK/EytBf2yda
	QQfiu++Ri5GPHK1M43bDE/MrN39qw0W0JXW6wJuLwWlyRWypawQ4K1koC3avuDlDJURVEk
	UbV4Yrnj4fBixD/H8nCXXmG+DJVt+ec=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpMah2Ts;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B56D6190F;
	Mon, 23 Nov 2026 11:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAFD1F000CA;
	Mon, 23 Nov 2026 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432406;
	bh=FSNPqJ2wns2AgHtQuJTveAPlZdwvlJJAYiPAVLO7n6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IpMah2TsMZXWQGbxBbVtoMVRvzKKgY5TUI+7S5hzuVspiJkOSMgC6069CBNRxbWlf
	 +FwwxKYKTg+K9NB0e/SLP0XvcwUjk6RhzDdnDxBKwG97bQacxHsYibYeu7aI8AvyA3
	 ytxRK01EN5fypqN/gzAPM7AnqFH0+ssbzHQlPZ41qmNfNQqV43iFqkzgpycCwNFB21
	 0+4C0p5w0OTTl3RwCFzL+4sh0DFZs/QI77MMWjvDkZWtigi9ptTNQVIrqw3N2lmbqE
	 F/nihpuJXymI3GgwxdWoaqv1eiuozJ0J10Tq4RTiXC4aCQLcBL9EoAjrU0btyHc/rD
	 KVcVR9YIvldEw==
Date: Mon, 23 Nov 2026 01:13:25 -1000
Message-ID: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, penguin-kernel@i-love.sakura.ne.jp, mkoutny@suse.com, chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
In-Reply-To: <awQRT7InNqEF-K8-@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com> <awQRT7InNqEF-K8-@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A02BAC0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: bctytb58kd3eaqomxdg6xepbb36jnk9j
X-HE-Tag: 1795432407-755000
X-HE-Meta: U2FsdGVkX1+2lot0JM5yZRu13AqzNh8QFG4cSBzRuQ0K+J+ndnW7aEQXWbFPvj0DFQCq9BzT3FRzdvtEYh9AAJicXcxad9N4GrEHlIrIOULBV/YmZcJjD1Gtx8YbOzrtwu4jCuemfV6yMKa1mDZ4VCvv9m/0K02NHtO/aZ6sQyLbU3sCLuTSHB0+r8cUa+qxsvflhjhOivoHfQfWS3fhfl6zphfphHeIE+m1RVgAPsG3N3iVvuPYA/ZxRMpM/nS+yATOEE6cUrD7dheCWtPYGGFkgmfPunyEsYZQ6jewMK2nP/wNPQK/tcWQnlv3ax1KQjdoM2i58dMf9CwqM8Gvi3Tu+kkf1a3GRTaxvtcf0JM4lXBd6p2ZhRYkfh4oBx+DRifREBA5cTs7YaW+WPkCkUFK62qJsJJ3onn4DjHAQtrNJDJkFiM/nPQW+yvDizZzmp8l2D/icJrPeTwMYSYfNntEWNqsF43put0+RRhfbz+HJapnKvsv8sRCEExZ9KpS3sG0gkWSL+KxKGGTMr1QStGtdQs8HdhTGU7mOjCyHLOSarjbaoAHAbLAAjKXAPn1NuI2TBoASZsDfdHzwvM1kdSI3sOzvsvKZKR/rn0ObkAzEctMq8DwExFoHYIFoP4PgUHHyu5OZDAABbhRgGAyBrkQv82SysgUAu2AjcE2JuEG9zxp3sJVd/rZbL2S2Dh5R7pm508EuBn+Fi+4VZlEQeZxfmRjp4ZiHrL+kpSp9hi/ayCkLW0uFgFoOaTbJNGH/+5gOl0etVvQgnh1OKlRT5OKmW/+ZQXZ/c9lyr3tl0mLyNiSotRQCpWVKf3Ua2aJjk7BaI0yz1ckc+YD6L7UmWJjB2cSao8zbtSW6Z3y4Jz+svo3Ye6g5dQ7kDY/ZFB8XAncPAGjaJegvGN+0HSPb7310zNL4X/n6mokpXqZZ5q1xpbHUjkuNIl2AuPbCalYaPaYhkFyXgZxzIfCYgt
 VjUz7lci
 OH251QE0BFAlN3ueJhwP6zLBu/s6JwCRVlFQjLbYMb0UfIlKoIbg3gOjaU25f56OroqlQl5HfXjX2AKT8sF5gE6LQZyMLzdBxmblgc2T/gbU0K2/tbLbWP5ebybn/1uN5MKrxElohUDs6GITEbTgAbX7TGc46o5uvfpaCGzRC8RcU7deC2nvb3w/o8JCoWGmCfVfYpRL3fkWa8jDPEGseVb2vqgXpi9Xcg4DpQ7d3IkmI0/09CvmFSs0ZBXqICAmlljgdbdjW6/phvg+1aoYXbOspCbfwt5ZTK62hZd1mZm8I6625CRWFIuF2I7SrcvZGYci9rchgulCkXZNwA8b3wd8+d62ACoW2l/dRGKplXcj8p+ef+CESJQeFGdG41gqiXNa8yim+jFga+w+wZ8ZhSowz4/VZ2+l+AC9J/tvHIIo5VddLBOa3B3NOrZp4Q19aRJeymoaY3DHZxkOmOXPx/TvhqMZ/v1Q/tv6t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Michal.

On Mon, Nov 23, 2026 at 11:11:27AM +0100, Michal Hocko wrote:
> Tejun, is there any strong reason to keep the exiting thread group
> leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
> really tricky and error prone as above examples show.

No, and I agree that the leader should follow the rest of the process on
cgroup.procs migrations. It's this way because controllers primarily care
about resources and exiting and zombie tasks don't matter much in that
regard, so migration skips them and controllers don't have to deal with
them. I don't want to change that. It doesn't make much sense to teach
all controllers about them.

That rules out the full migration path for the leader, and moving it
without one looks fragile. If cgroup core switches its css_set without
involving the controllers, ->release() sees a different css from the one
the task exited in, which breaks e.g. pids uncharging, and that still
doesn't work for a leader which is exiting but not dead yet as it's still
running.

Maybe the leader can pretend to be in the new cgroup instead. On
cgroup.procs migrations, record the destination css_set in an exiting or
dead leader without touching the css_set it's actually on. When a
CSS_TASK_ITER_PROCS iteration finds the first live thread of a process
whose leader is exiting or dead, it looks at the leader and visits it
there if the recorded css_set agrees.

That leaves the leader's actual css_set and everything that the
controllers see as they are now. Only the iteration changes, and exiting
and dead leaders are handled the same way.

Thanks.

--
tejun

