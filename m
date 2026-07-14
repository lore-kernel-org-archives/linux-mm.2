Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766EAC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DEC6B0088; Tue, 14 Jul 2026 06:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7036B0093; Tue, 14 Jul 2026 06:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59EBA6B0095; Tue, 14 Jul 2026 06:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B97D6B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:18:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AD57C0301
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:18:04 +0000 (UTC)
X-FDA: 84986981688.01.8E35C06
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8497740003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:18:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YPQmMD0/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDiZS8zttT4a9O025kBB1zOShFsYsLLFK1SisQ6msEY=;
	b=YXRaHCDE4JvHkCVbrNov9BHMANZG8ekD5XnuK1dOA2D/fAH/Kr9+DnMP/9BPf3KZTQgpKV
	YIGMVE3KaE94VTX744oS3KuYQMLAXSfmuCTsM8Yc2wfX1kJZAeDNEKGqYlioHpjAHVmaDa
	QivF2SNpAG8oc1F34/ZOAaw8Lq5r6Sg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YPQmMD0/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024281;
	b=aa2rRFceM9Y4OUmEQTSDuEnBFC1ss/cQOxc+xWjrApSB3nYntLfgEtuqksp3UMYiq5+kHx
	gH4lT2d3nxhPXNvK3R6D4oUgRnbmGxJwSSlOnR4g+GxG5OG+cj50YRg6uj2i6FTM1WUj2N
	pdN9svOIt32f181kLoyPceocGUcJaiU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784024278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EDiZS8zttT4a9O025kBB1zOShFsYsLLFK1SisQ6msEY=;
	b=YPQmMD0/zTCtgtqVy5SDNK+fsg0BTqTsor+JXyoKqwEfTjG7p9IsJgjJNVeLOLicga3pXM
	gP9//+7EcPmcJzR94Erhzir6snvi2gfkCwv0wOCWnsrLDd1Hd30WV/lxmMJyKojs/BGpkv
	I7T1czZ32Ibjv2lEpa1TLNGT4zPUUE8=
From: Usama Arif <usama.arif@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	hughd@google.com,
	boris@bur.io,
	clm@fb.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	cem@kernel.org,
	linux-xfs@vger.kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
Date: Tue, 14 Jul 2026 03:17:38 -0700
Message-ID: <20260714101740.1270419-1-usama.arif@linux.dev>
In-Reply-To: <d39f8258-66d5-4ce3-8080-69dc4e2ab197@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8497740003
X-Stat-Signature: y9fzy1yfkqp7p1qmufif66ax1wftuic1
X-HE-Tag: 1784024281-357846
X-HE-Meta: U2FsdGVkX1+0/x84bgJJS/kz6L5XhqIYnsCSN7Fjwx9ZppWcfGHlB1qjN61yoFu62d0UJLsqbW5ow+fFajgWkQNqBkl9awjAreIhZtu2heszV7Fv3E6qWkdjjSQc/gGCgffazTTrcBwxMPhSVb7YJTS30RkzmohxAzXojn/TIM2v/UxIKYQ1LMQksvn6UIVZuvVWy8wUE3zsD/930NdLErgVBZV3ytvN1D1ZfztHtlf5oIMVAXUOPsoNchditC+XdFe/6ui/4UaYZ7w2monM3yN7iNpOuHPXnzG9P7ornCeMYOZqqXI+clzQaonTpNtIBFxljOOygNu3WerIiWs6oYaiQspC9/0edzbWu5UpVtmYVp27aj1kd+LVBCfu/9CEmXOVb6LV1k1ykWcfwmiEMn7sGuT/P+cZbRrBYhiYyKrfxxMaUmw7O2vGN7U6zP8me3L//czKQsVnFG8ioRSlBNfQgLtzwf95mnSU5JMVGgNH7IXjTnpZUUYHBUTNiQpTx8oYoPbeM57U9G5BDGRpQXz1e3h72x0H+q+EUKZWbR2LVe684bEpvpGqtn60gdpf/8bPMO/BfD9NY0ppZVThts/ZIiaGJGDq4jwrFUCpXPZgDJejs9FdaEYa+dc9VX+H/fgeoZ2YLEJY4+/YCgGxQ2sGYPLl7DkUXzKrxYaYHRJxzZWpzCg09qOn9ensQ6Ub/qVsENa81s47VybnHyn/+eYlKMwrSncckWxMemj7KbVVE5xDCumqsO+Ud/N+yjB8pdzbJK6ahP/lo8D4PbLU2LHk/kH1Mzm1d6GVi2Dt4IQPjSA/rYWfwiqIeyQc2Nq5mCy9PhRghjI8FP7JU9n1lFa00p32Eb/xH8JIHE4oaNbOE2+cbXAnr56UbiaJW7VCQKhitxtOySckHNO7ZLo4tS000RbXAcOEmYj70ZrZGfqSvfGIC9d7fp8I2lspJtzSMyF212c9uFCLpXagZ8j
 PWMLT/BS
 lSPScJHZ5KZ9ejzb9wDUE2BrCPac/IGulEw+wqZEptthnfqQGhpYyxNTu94PVTyKva+EihlT5Pd+90IOD8j0/eml1NO+tbsEzlrymFCc11mCQt/Qm0cPyvebkcgkl/wEhFiOYcDQMDoMKx88IYo29W6OWwGjlb07pYY6YohbEdSPtSeVgHom3YsdigTspA/tZqlXtBNeE76GEMZ/X9h/xXc20LTSzuakjtt0AzcQYPH+r42zcWTZcd53BDXIMGmAEkL36120soGkGOJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 10:09:26 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Hi Usama,
> 
> On 7/13/26 11:34 PM, Usama Arif wrote:
> > 
> > 
> > On 13/07/2026 14:12, Qi Zheng wrote:
> >> Hi Usama,
> >>
> >> On 6/9/26 8:30 PM, Usama Arif wrote:
> >>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> >>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> >>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> >>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> >>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> >>> None of them filter by sc->memcg.
> >>
> >> This makes sense for now, but how should we handle this if these
> >> shrinkers are made memcg-aware in the future?
> >>
> >> I've recently been working on making the shmem huge shrinker
> >> memcg-aware, but noticed my changes broke after rebasing onto the latest
> >> tree, which led me to this patch.
> >>
> >> As for the shmem huge shrinker, I can work around this limitation by
> >> making it a separate shrinker. But this feels more like an overall
> >> design decision, effectively meaning that all nr_cached_objects are
> >> precluded from being memcg-aware.
> >>
> >> Thanks,
> >> Qi
> >>
> > 
> > 
> > Hi Qi,
> > 
> > Thanks for raising this. I think the alternative is what I mentioned in
> > https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
> > move this down to the fs own callbacks instead of here. Would that
> > be better?
> 
> Yes, I think this is a better approach.
> 
> Later on, shrinkers that are converted to be memcg-aware can lift this 
> restriction themselves.
> 
> Thanks,
> Qi

Thanks Qi, I have sent a patch to push it down to filesystems in [1].
No functional change inteneded in there. You would have to rebase your
patch on top of that one and remove my code in shmem specifically.

[1] https://lore.kernel.org/all/20260714101454.1202449-1-usama.arif@linux.dev/

> 
> > 
> > Thanks,
> > Usama
> 
> 

