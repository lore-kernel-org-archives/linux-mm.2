Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FD3C79F9E
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 00:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB376B008A; Tue,  8 Sep 2026 20:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C5A6B008C; Tue,  8 Sep 2026 20:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B586B0092; Tue,  8 Sep 2026 20:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 772ED6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:38:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78674A0843
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:38:11 +0000 (UTC)
X-FDA: 85192361982.13.0E80921
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D196140003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:38:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJDbuH4X;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788914289;
	b=BpCP5FoV1MJQh68EvxGtmluXE3rw3LJddN/vsjPI1Awq7T72OvFi1jh1evUM9mJpAD/zV9
	hJDNsVGtKCmAXFlVGp3wo9mLzyToFZYLHeu0jLV8+N6cxpTSBNU2+lqGUdcs91k689XG7B
	Hj04FGtUGyL3ikF38h+imKyMcVmtz5M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RJDbuH4X;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788914289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LW2YRdHu/X4/AGFVGhsWuCM7o9IYlbhU7Z1SrOilMgY=;
	b=nPzuCQiLJ+0cy02Gbh7PWTMUUFh6VvDEHEIwFveTs/ErZ8jb11jb1/3J9e7QznZ/vcZ8uV
	s9r9CJfB74/ha1kdy9TEn+w5ZKQNI9nhhUj91JtfK1ZeYD3XHEqr9rsKrKIWRS+YQ0DKdU
	sGEnVtUndJN34VyoHmwLRFZb7YeAmcA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA2B740B4F;
	Wed,  9 Sep 2026 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D81E1F00A3D;
	Wed,  9 Sep 2026 00:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788914288;
	bh=LW2YRdHu/X4/AGFVGhsWuCM7o9IYlbhU7Z1SrOilMgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJDbuH4Xd8C32OmTjQnl1Ekc1TagPeVNucME62r/LSxjMqbUS/NpGkKhLw7X77v+t
	 wMD2iRE4JvWPJckS/fJD5vdKocCwK6cSiFHPfLDFm5QCeOdDBUuqXySJuzh+hN4jIL
	 QJNwBLPpS66PBzJrC250WUOOlP7t5iDk9EddOCFqwsDJ7tkjd/gnVXUWP4NksqxE3f
	 PA1eV110rvY3PDvvKKUlioPKp2SknHbCSGVw/xhVwLX2zGKcypjNbH7ZZTrctTlWFl
	 VODweHOCKjSH0rM3I6byMsrxpjMyiMMkucPr1NxyRySHFGmzpeEO1O3IwZgiupc0NQ
	 qHZVDDlRkOWIw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Docs/mm/damon/design: clarify when qt_exceeds increases
Date: Tue,  8 Sep 2026 17:38:00 -0700
Message-ID: <20260909003800.112569-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908175105.42558-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D196140003
X-Stat-Signature: uqhg6j466ro5gpota3kojuwutcdm7k91
X-Rspam-User: 
X-HE-Tag: 1788914289-814412
X-HE-Meta: U2FsdGVkX19vgiQ40c27GvRYN3b3VmwbwNJJaZoF12ufmUA06Z4BD+02y4aKeSzToZY5mPgTHMxjaBbhjn/WzOGM9C/tsF2SnlWkd/UmDqDfuSC71mE90h7F6oH8UVlg7ieXgxKGIctf/cf/EIfhZ1aNYbtqA+FlPeRFYQFvJyfmWKqmmmRrjr/PZcQM8j/I3hZFExTt39wh9WZ+sitilwavzzfpsuK1DlAkQ7oi7UmR4txZ6UXvxZ0ZVE+jgOuuh9dtQ685dUovekp49eIDZ0hSMGDTiK32oQ/nx07WT71z1XhLpffeacL9n71EoWub9XhYjzyyFKFATtB4oK2YV2FRIXjBI3AE17DQGQgdxXTKuc3tBnf1vcdhZxpwvpBY3Erl5i9MD9u/EfDZdOLtGw13aD/YcEBhhvzkDr+kNdzbnqpmh4nMPBBLteSQL29HhN3u8Ix1iS5LcA/aHH+JJLMUFEsxaNRIcfVLZzMTfXKzDv6Pih9Kwn3C1tn8iR3U/UzF4unSEPi+rFyJ4ucJRP6N99nw2zLlklXxboRyq+Ja0iMLzMFclUv/r5rwwuLTrCzNDcWDZUyslbLL+Vr76AUIfnMNjcb18gIbNJcFKUGZR1rXYk3v7gD5vFpaYhVtoO3L+hej1qUowStrsOTSiWimpgF2hznWEcVP3clVeMgLl0eIamvhZv/WoP2YIF1JG1Rc2DV5rLbqnyBKDPbpMyUpPjSrw8UllyGi7igppqplrYo2Gtu2/Ak/Pc3etLViS3YXmogXnpzQJEsmBBRTwuDIHNupVh4TY5TsFybYcKsxTVzkqu02GiCnYZSe3W+LXXQp8A5Cr+zcLGMuNQNk3gb7PC11pTTaVp+htMaeKLn/IFt6MU819eAbwm1fVUn8JmvvdefXGoxSESTnsnWSfZ7zhMOkdcP3AFfTPQF8XV1R36vy/iXFsNfKi9MPQOKjx2E29gzuEESuo0b95z+
 8cNP9rrc
 dclMooDpzJxQp4bm2PdxXD+OQ1AJppHl5PSIlpaYbu+xUdZIXjs81kzowyaDftr9V10HY3DufAt3CcY4xGeoSN/f8DokgfxDCVH6dE3o3PkJ4sIKcARAAaW1uUZ68D7R0eolzXCLFt10+tG6YV1lDS350UHdVJHPGNC03KkXBpIqlTQ2wIJ4zC4t7DPbGjwBIkhtu1OcFhW2Qw9qcL+sAia6Q4I1CoeMIal4wrVlGqXAlE9OkChLQB3gWFFRsjOjyM6giWa4ANEjHjLDB8CWvKmx6GWi2qQtsAYxRTWdYgMrT050zSJEpUUiaKWplNHHxRsGbyVyForHzvAmiG7qi/BAWAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liew,

On Wed,  9 Sep 2026 01:50:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> qt_exceeds counts how many times the quota of a scheme has exceeded.
> 
> The value can confuse users when the effective size quota is zero,
> because a zero effective size quota does not always mean the quotas are
> unset.
> 
> If the quotas are unset, that is, both ms and bytes are zero and no
> quota goal is set, qt_exceeds never increases.  But if the user uses
> the temporal auto-tuning algorithm, the effective size quota becomes
> zero once the goal is [over-]achieved.  In that case the quotas are
> still set, so qt_exceeds keeps increasing once per quota reset
> interval while the goal stays achieved.
> 
> Clarify this on the design document.

Thank you for keep working on this with patience.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> 
> By the way, I found a thing in the design document that confused me.
> 
>     temporal: More straightforward algorithm. Tries to achieve the goal
>     as fast as possible, using maximum allowed quota, but only for a
>     temporal short time. ---> When the quota is under-achieved, this
>     algorithm keeps tuning quota to a maximum allowed one. Once the
>     quota is [over]-achieved <---, this sets the quota zero. Useful for
>     deterministic control required environments.
> 
> I'm not sure if "goal" was accidentally written as "quota" here.  Would
> this be better?
> 
>     When the goal is under-achieved, this algorithm keeps tuning quota
>     to a maximum allowed one. Once the goal is [over-]achieved, [...]

Good eyes!  Yes, seems it was only mistakenly written in the way.  Please feel
free to send a separate patch or include it into the next version of this
patch, whatever better for you.

> 
> ---
>  Documentation/mm/damon/design.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index d036340dae8a..e083b74d618b 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -863,6 +863,16 @@ scheme's execution.
>    completely tried to be applied.
>  - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
>  
> +``qt_exceeds`` is increased for schemes with set quotas when the quota is found
> +full at a quota reset interval boundary.  While the quotas are unset,
> +``qt_exceeds`` never increased.  However, a zero effective size quota does not
> +always mean the quotas are unset, if the ``temporal`` :ref:`auto-tuning
> +algorithm <damon_design_damos_quotas_auto_tuning>` is used, the effective size
> +quota is set to zero once the goal is [over-]achieved.  Since a set quota of
> +zero effective size is always considered full, ``qt_exceeds`` keeps being
> +increased once per quota reset interval in that case, until the goal is
> +under-achieved again.
> +
>  "A scheme is tried to be applied to a region" means DAMOS core logic determined
>  the region is eligible to apply the scheme's :ref:`action
>  <damon_design_damos_action>`.  The :ref:`access pattern

I think the clarification is better to be added to the 'temporal' quota tuner,
since this happens only when it is used.  Maybe the clarification could also be
shorter.  For example,

'''
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -775,7 +775,9 @@ There are two such tuning algorithms that users can select as they need.
   fast as possible, using maximum allowed quota, but only for a temporal short
   time.  When the quota is under-achieved, this algorithm keeps tuning quota to
   a maximum allowed one.  Once the quota is [over]-achieved, this sets the
-  quota zero.  Useful for deterministic control required environments.
+  quota zero.  Useful for deterministic control required environments.  Note
+  that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
+  <damon_design_damos_stat>` will keep increasing in the case.

 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
'''

What do you think, Liew?


Thanks,
SJ

[...]

