Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A051CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A746B0088; Tue,  2 Jun 2026 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24DD6B008A; Tue,  2 Jun 2026 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC656B0092; Tue,  2 Jun 2026 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA916B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:31:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B44A1A090E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:31:52 +0000 (UTC)
X-FDA: 84835665264.28.5749632
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8394D40016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:31:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G3o6lrkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780421510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7YoU2thqOqR9q4NL8fspTtdh+TCHHvtfVavmrm+Sho=;
	b=50AzZxKhO0o1PVEhJwL6qcva01niqQo8AB0MKq0h/RKRBmdiMC9Ds+lMRR/gUKHSWMdfoc
	XnhUlblLy5TGmymI4Zd4KaaJg4S1XhRWG3vHU+tZFllw8M3QmngdvU7jrfPY2jzPa0E5Nd
	0t3LVVDgxGDBCUef0pxLtZjmHz3j8AU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G3o6lrkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780421510;
	b=jN91ou8rdIKhouq7j3opaXS2t6McwsEPHT9H6dHeQl1esgFJ3pphaMKbusKfa5NZg4EhaL
	wp+xi7wWxUIpDajET2TZFCrbct5SShvxnmFsw3j+6DFYqWXY1CJd/fKTduf6Hj6zc5fgGi
	wOQGmeB16hymzHeYMU7T2dpROS0WdIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2096432C2;
	Tue,  2 Jun 2026 17:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF911F00893;
	Tue,  2 Jun 2026 17:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780421509;
	bh=L7YoU2thqOqR9q4NL8fspTtdh+TCHHvtfVavmrm+Sho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G3o6lrkAn+/fVkI251MMo8MMjUTiQr9KTPberfX7b0Br8mtHbr0hsxJghBWOYpxzB
	 +7GjrVCZv0SN0cykNtvyMpbnaAILWKNHk2DmSA6MtVG1l00+baBmKtU0X7vcNN68M2
	 tBEjhf0fORijaqupTeEtKY65t8CQHCCXR+h7H4wTOzxMosTVCU7tThyRLGzcgzriBq
	 iFm90dyyU8L+45ZZi7rnQHAWcju9B/roRv1S8QDc5wUX0GBziulSNKBR0RAp/JGfyO
	 +aMG6Vrfgvq/RmZyobjirgFQoieySCu6LwVWFjei/uzYpyGVInOU8lpArnAJJBeN5C
	 Ls64ou6GY7GeQ==
Date: Tue, 2 Jun 2026 20:31:42 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Nico Pache <npache@redhat.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com,
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah8Tflgn50DTMvwl@kernel.org>
References: <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xcsn8xwjeb8cyzckbscbodu7gigsjwac
X-Rspamd-Queue-Id: 8394D40016
X-HE-Tag: 1780421510-873742
X-HE-Meta: U2FsdGVkX19pj5SCdKaoJHbzPBLxd6KdDGL5VleJsvSDRn/JnmrrJudWORCLFsVuEc15/4TRQCYhvAt/8bDeCW3hcGpTbpzT49agTXYe/REaxUp1EzNcwcyW9T3pnEiwRKAF6Wkm2qJZ622he1ZnlLQu0o9UpQK5GUkIVzE5w8d8Vrlc55tnQAsbjYiIMrCi6CWtOoMpkIZUeJza9deQQdfsslcBNaaE0tOdsE8e4SGRU8WwpG07ledWRIcrKXeGuVXouv2SIyDBol+ka7tlzCqB/vvM8iWTdc7xkqrbuGTXouIT7+OsWHgWeD+YR3L39z2eHjMiJ0eiHIB6zkas9+/SQc706FM0V+Tl3GdgQHbXLdY8WuNC+z2KlwBV7GAF64IR2ljzF7FNjhHBZ089HtK7XQUzrwEVXmKFIIExOKRgsUZO8rinZtq7Os9pAfXxhTtY6NWZX3PBTUbL6BZw1hM9owfw9j0g9g4xt6d2OjpUtqAHEo2IqO1OUxlC1qAjkiL+VMpFrzsIpgA6cDYRf+nedxHeknuOD8AlYbZCjyKRa8wr50EJaVI/okqjYNzoGAV70x8oagJvnDwuZ6F/kX1LXLl3CWjvRgeFOLptmu1sQ1nYD4xISSNgo11yN+k4fv+sgNquiezjLOwivkTuPmSzg77LSnfvJS+yDv9edsVxOlYR2xpQQRrWnBMlVXTUSbzepungE6Lcp5BN5N7VlSq4yO1gIPMNBWQNXypAqWx9WozM+diOZIoFZjYlHp1GCku/ShZvcr5viP1YqtVw1AcaC60ldLjhBPq3fD3yZdkvuySPD8FqwQnMC4TlMmhlFdWebqM41vwB+ivuJtlEFhEvjFvaTQ7WDe8KabC47lDK8xnbGhCqDAdSKzgbC64DOzQ1RBblOMhqxJ+iW4NGTSJ9meX0UIob0kPLKIRMuO6ckmqaHX/H8IJRn7x/voPEGaQZVA/ERvEeEcQYqYe
 wK6PplwT
 CLSZ3KJPefwzan6c+9MCuSWJ0ZcIypZZ6tTMaPW0LTh3Mw1BZDg5tLkIryJuVtNfF5p2QbRtXZ03Ggkv/HzF1MM1hDfseqbZx3SPpD49Q9ll7TeOKtWjjMxNCba9UY444yyKv/fH3/ERuKFmNRj0F9MqnhMUR/iZI6kqJ/hrElPzFHuODow60i7ql9loWL1hfFTlolSWWweWf4NBXa+e3YyZSDwt+Sg5Zm7XWbKjhhQnLv9U/gUiNiRg6BHzcpBQUHP8Mp6tn10QbmXdADsT8dAnFDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 02:55:30PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 13:31, David Hildenbrand (Arm) wrote:
> >>> learn from obviously) against how mm works in practice.
> >>>
> >>> High review load with many overlapping changes might favour a different approach
> >>> to a subsystem that looks different from that.
> >> Yeah, but as we said, we discussed, it's all rather complicated and we should
> >> move incrementally.
> >> 
> > 
> > Starting to read Documentation/process/maintainer-tip.rst, it's very interesting:
> > 
> > “The tip tree is both a direct development tree and and an aggregation tree for
> > several sub-maintainer trees.”
> > 
> > “In general, development against the head of the tip tree master branch is fine,
> 
> I don't think we'll be able to use this part as mm-next will be only an
> aggreggation tree and not also a direct development tree.
> 
> > but for the subsystems which are maintained separately, have their own git tree
> > and are only aggregated into the tip tree, development should take place against
> > the relevant subsystem tree or branch.”
> 
> So it would have to be this.
> As it might be hard for contributors to pick the right one (as Lorenzo
> pointed out), we might in general suggest they try developing against rc1
> first (which is the common base of all subsystem trees), then either it
> applies to one of the subsystem trees as-is, or it applies as a topic branch
> (which starts also on the rc1 base) with reasonable conflict resolution
> during merge, or we tell them which exising subtree/branch to rebase on.

Unless we carry semi-baked work through merge window *, at rc1 all trees
anyway restart the cycle.

So basing new work on rc1 is very reasonable choice. Once that work is
merged it will be merged to a particular sub-tree. Even patchsets that
touch files across the trees still will be merged to a single sub-tree.
And once a patches is merged it's clear what should be the base for the
work that builds on top of that patchest.

Obviously there would be conflicts when sub-trees are merged into the
integration tree, but that's maintainers responsibility to resolve them
IMHO.

* Supposing we keep the model of early merging for testing [Lorenzo, don't
yell at me ;-)] I think it's reasonable enough to drop everything that's
not going upstream at, say, rc6 and ask contributors to rinse and repeat
after rc1.

> > “Bug fixes which target mainline should always be applicable against the
> > mainline kernel tree. Potential conflicts against changes which are already
> > queued in the tip tree are handled by the maintainers.”
> 
> Ack.

+1

-- 
Sincerely yours,
Mike.

