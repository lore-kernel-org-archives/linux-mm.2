Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC01C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6466B6B0088; Fri, 25 Sep 2026 06:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E9A6B008A; Fri, 25 Sep 2026 06:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AC96B008C; Fri, 25 Sep 2026 06:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360CD6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:13:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC3B2A6923
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:13:53 +0000 (UTC)
X-FDA: 85251873546.15.8A6FE95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2B30F140009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:13:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvvqWOPq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790331232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvTmyd62NBwPnh1Rpluu6TR3mWFhWCcbU/2COoqGdLM=;
	b=OA4It6ELvlimVR+Ly0uFgeJHhrQPFhy0H/9vow9n7r3Y2z1oGRqHkwYVqRnUYItLBe0veZ
	SOcXuSGd7kjZ+6XFc3udWcHvnULYBU9olxsAQN67HFpFpN0brhkyPkCJ9macHS8OFUvALC
	/WZmIpnf/IWXGPfae2+D3KWb8ln39V8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvvqWOPq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790331232;
	b=VCOzaJIBxsNG2O84tA3rvjldR62tsNdkAJuzADHq/4+UIrw0L0CEDcH2vcHBXME1CXP6CO
	BbfL56W5Ky2EMLY5vx+yTtB4ugKpviwy2qGI+0KVGBbVG2G+GTqDXWtJtjykrhSaQF42Us
	w1vn1BnieYvdDbcWaYwRZCVjyGxAOec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51C7842ACD;
	Fri, 25 Sep 2026 10:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DF11F000FF;
	Fri, 25 Sep 2026 10:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790331231;
	bh=UvTmyd62NBwPnh1Rpluu6TR3mWFhWCcbU/2COoqGdLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvvqWOPqHwDB7b4EieW2LrcnPCJawtrbIfkw04FY4bPgyu9mU08uV6/OK3SBmW5QW
	 27XiiSIqsyjoqK1GukPc7SuaJmpdXa4wcxGR5wyqZLL2MfMryc6MHAjpvP9BJToIiE
	 qlPmgpdLWTALGwfqvs4oxi1IgUpmQIJ59NIHkrCBKx3qiBj65y8BFVlMu71aUd74mG
	 ovB5F76svNHCn/TdhP5H2639BPuc30kJWQolmjCf5QuVvs3rR9FpZXo/hBoZeFIRXD
	 N8vi0L3EUtkpmBZrmGkiew5vOooElz4cP5BJxezPJMy4UpxnZJqhSEa9fYQ7EmUmNw
	 rLjyZ+gdlhHKw==
From: SJ Park <sj@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	mst@redhat.com,
	david@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	ryncsn@gmail.com,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Fri, 25 Sep 2026 03:13:31 -0700
Message-ID: <20260925101332.49502-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260925054408.10431-1-lance.yang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B30F140009
X-Rspam-User: 
X-Stat-Signature: br73uew7fix7swuxcknogqsbasa6xuar
X-HE-Tag: 1790331232-118204
X-HE-Meta: U2FsdGVkX1+XEFSxsjaY8KYk619chSDGv37HskKIlerJiYo2z5nN7WfU9XmXP5mAzM2R9t9f6H5JMe/GMWaRoxZWteS813J7wsvlyfk00nVsEdGdHYH5dzjZvbtKR5PEbQHYlhz8v+gZfs3peI8j/NDZmorh9VMXQB9XFPtVuusBsKZ9MKa4rzk9PzknTOKV+9jSePpqMbxcugIznj9zRoSeL3YJbxNesiP7R2r7dkPTUVfFMbTDyc5UBV2OAuKbQyw+ArsfvNmPvaNbcdQkJ+sm0Y5CZgqyxKPHttzVAjFvgCvdsrjF+TcsCQoVGwEhagDq1qc5J3KmhU7LSfskKj5YXpxHDmRnwy8wnHHrVK1MIQcdISMwYl0e99CtaPBlscuXi2PaBw+zRpw/9Lj0dmCXdW/1p+d5p4ePFYdaR4t7DfR+GDUQqw5EKYli8a2I8Yb+OmY8PQip4CxLmxeCfskNXW0HRlUUV3wXj0L5RuqgHmqoyfbn8gQhGu8/BIR8ne9NJffcFfElA/kPzC2EQkkz0/jGKPCvpEMuL8i6clvgwcRusbKrMam1eABVBHUYQAIz1EtCFf4e15w6x5Y/IIyRKtZvLie8mVoyAOhm1Xg5xSjpOGvzh+OWOWUi41ulnCAzUelgAxGEzw/3qsl7ysquiZLw1dWNmP4j1B3oMTnmaTbi2eyB1ScipoUHhn2nNNwRLP4FY++pTKCReBMfa5PmZOaHshbynEfMZvOsUp0vlrubp0PB5Y+WQK4yIAC6nwz1SefqMuwBr4MtOf5q7NN6HLGOgHMKg74fMluZ4FrYcAcK5Gpi8VoELKTcilhQmmQU7GsmFBxQAMfnmBW36VVVVg2/eoD4rTxnxlHKZ+62ikLqPJB3782RVl1zplAZB1Snm/ycM16IzA+N+DxifUAlHPZ1UcDudAy5NXjIL+VREc0OVlMm3hGLxgZcSSggmBmhLUfnFug8y52fqrS
 RyOnN6CW
 M78Pso1eiqxX6xxJOFapNdN0Yc1jXQoC+VJMKJZLsEVPxgcwVVqX8lfgfuqbXn6H2rAAy01is9KauC2E8mXp0CuiNmTc/7tlQS6rkyGxsSrs8hxPsxojL9Wwy4MVGnUZd+sunD0g0wUQw2ZvDpFLnNKvbdpXqydeeHxbw7lrLp2UpIvx+0+x5KJzPu7+ZSGiwDa3HLD+/N2vVOCTP1mWphB6vF3KRau9KeaiXTABvcEmrAdE5sCIggSy055cshrSI44yv5Ft779BvPdsr6WnUCzFr+WnrK7vy46+NIsbefyBvSm9+ATx0WgWGU3N1Uf4jeCDveoMlCSqNxUIrcVs1eeU2PsGaIgtrmhbtnSVCysiOogpUMzEY0av5cgNn72jpnQF7x+NnGvMsMKkH3lH+KDyuJWs32ng70UUc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

On Fri, 25 Sep 2026 13:44:08 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Hi all,
> 
> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
> and virtio-balloon:
> 
> With this kind of workload, an agent may read a file once and never touch
> it again, while those pages remain in the guest page cache. Without memory
> pressure in the guest, they can stay cached even though the host would
> like that memory back ...
> 
> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
> cold file pages from the guest page cache; buddy gets a chance to coalesce
> them into reportable blocks, and virtio-balloon passes those blocks to
> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.
> 
> And it worked: time-integrated host memory use fell by 21.2%, while peak
> usage stayed about the same, with no significant CPU overhead. Pretty cool
> to see these pieces show up in another real, large-scale system :)

Thank you for sharing this, Lance!

> 
> Kernel work still changes the world. Cheers to that!

Indeed, the community is making the work a great place.

> 
> Anyhow, I still don't know DAMON and virtio-balloon as well as I should
> (mostly I just know the people who built them) :P

Please feel free to ask any question to DAMON community and me, whenever you
get :)

> 
> [1] https://arxiv.org/html/2609.22978

I only briefly read the paper.  But it looks like DeepSeek's DAMON usage is
similar to AWS' DAMON usage [1] for their serverless service.

While I was in AWS, I proposed [2] a more advanced version called
Access/Contiguity-aware Memory Autoscaling (ACMA).  After the RFC idea v2 [2],
no progress is made so far, though.  I shortly covered it in LSFMMBPF'25 [3],
but all I mentioned was that the project is suspended.  Recently a useer has
personally reached out to me asking the status of ACMA.  It is too early stage
of the discussion to say or promise something in my humble perspective, though.

[1] https://cdn.amazon.science/ee/a4/41ff11374f2f865e5e24de11bd17/resource-management-in-aurora-serverless.pdf
[2] https://lore.kernel.org/all/20240512193657.79298-1-sj@kernel.org/
[3] https://lore.kernel.org/all/20250121183103.42877-1-sj@kernel.org/


Thanks,
SJ

[...]

