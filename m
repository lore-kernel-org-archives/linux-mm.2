Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEF4606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wl6FpETe
Received: by kanga.kvack.org (Postfix)
	id C9EE96B09DE; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F446B09E1; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92776B09DE; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAFD6B09DE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:00:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77234140E1E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:07 +0000 (UTC)
X-FDA: 85473498054.18.C41C1FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CD3482000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wl6FpETe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795608005;
	b=wn1MvOFszLzb5QVMNOGxQau7Gx8q41A3H94a6TBimK4Q0L8LuTDD+VgmP0Wi2LATuadRZI
	KoGx4Lsi/7OTQ+ZceoOdmb8j1mbXtkwvjdPLolS+FDvUf0ZllmRTXlOe2aNYMG0ekIuAS8
	q5OOkKq7K0WWPPwJlvZAvGP4vmxrmS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795608005;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xxu0bPb2V0jwv7Yxq96R2JrKTa1qATXmL+4rVigoyqU=;
	b=CjMcUqa1Jsl1t5WMqFYjVAwtkI5+LfHBPsk5wxsngXAKD/CGGXUWPFe3YG6nX6gJl672xM
	CVlGNumCNZhWR/rgvacxdV5HeyAETB66W7xpv5RYVFzbUHdSXMtsrAaMaVaYV1M+v+9W6a
	PxBKQ/nKlR3WT35RMj1DRFUqEn3pNHI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wl6FpETe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5641E62946;
	Wed, 25 Nov 2026 12:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4484B1F000D3;
	Wed, 25 Nov 2026 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795608004;
	bh=Xxu0bPb2V0jwv7Yxq96R2JrKTa1qATXmL+4rVigoyqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wl6FpETeE/Sz2LGE8PVwAzgwN/M8PJ44XNS7XnqhKbuh2f4vz/CjOOEtA7AzHBryI
	 FcSJ8vrq8PlozavfA0ww2eXTy7Oz2aIkGjDslo1uOxAfIbMWaSFu/D4VS30p5Q5pnJ
	 Vg4Ox/gLmJr55OmGVcw9qX4nt2530aWjvCsEq7sFdjLJFDk2XnZz4Wub+AMxbgIX1K
	 GE5gekSS4VG0yPthYrPTi+TdqRNk4+TGVZT7VBEjuA7ZSoW+nvjY4dQ1yhS4ZmpcNK
	 GcOu1XGxMU4CRs46YzGnKco12fDUKSg/AnsQLdAvq264eFdPQ4s0pYZfkbR0gJDI6U
	 dG/RNYy2Eei6g==
Message-ID: <sashiko-outbox-233312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] fs: Basic infrastructure for offloading inode
 reclaim
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org, "Mikhail
 Rudenko" <xyzzy@yandex-team.ru>, "Andreas Gruenbacher" <agruenba@redhat.com>
In-Reply-To: <20261124115850.3512-11-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-11-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:00:03 +0000
X-Rspamd-Queue-Id: CD3482000A
X-Stat-Signature: 3o8wbm4abw1tw4o3yr4usrr5wnm3rhzp
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795608005-474400
X-HE-Meta: U2FsdGVkX1+LTicM24w3aC2dPdEVouUaeZIC4lhyXH0c0I2PJThVIQqV8stFy1JDkwWhCziJkkGy1rbN4hRPprPnIZTcfzHL7n+rM0nvpLf+d4NUZlI05QoKe9JuWnjrE75o/yQdToO+lLQp+2pwKZ8QSyQTJEMT38YJubFEVOmOyGu9UwcAVvIMt4B9zLL6TdXxlD7q4cI3gkdsp50iOYrEnUiKxCD4UQJ+s1dg9MLhth7gE+x4xzhKtCyU7PoQ6vzIz5sFhE5sqn7IHARUlrdoo/L6dlclOlsNEmM8gt5JucYbLCyD53PZrteGI2o9bBMxmz7xpyfeYwn4HU1Gn3xLvd7prZSfBgWQauNqv55UJ8fs+cG+PWh33w9FnB5SWsZWsDkWpjMoFZ+jc1CmwwTYLkVuy+duadXLSvG2RKwVs62FZnY1ljEIvOLwXuQg50x4cfGSL8eoWpuQbfAlKOFDXE36qR7BEbIbgsUMqdCtLuqhLED+03IH+N3HKeDPtyyEJli9C7ArQ1rgNvSWe6xmzSN0LytspT6n3zqctZqzYQZTmhIXLpJ131Eyk6Tq6hCI9s6lgyzFj89zh3aDSTs2V8CCMgG8leEkETp3BoCRRHctAfHu+NPiwCWSUwK7JPH+vSnG1shq0Nn2r1IODBnF9Kiy0E6UzWxS1EzdHXgwNWThCJZ9bEGbHG2HGmLOiFam3HDQmRlTiZYZaajr89wHMaEC54DB6nmrDQw7O5K95khIb+xbPgE91m2DLvEtG+zCaWb+EYtu9heTVnEonykv7XiIX6NsGt1r9RVSr4mnJNjbHFnbaz3a0197uGGBDpZUqEkJf0fPPGheWrMCCu5ZduPEW7hNvJcDKU9a+8/i32+/8UqGT/dq3uToGmNxbUkLiGccC/6zOqoWgNoGk9fUwIR2nbCzYUeHhWqtmwxWSGxvS5Kymo8/Se6TqHrr7177DPXWjl0SGqKaH26
 SX0xlIHc
 jAQvBiXRmAVfMj05aWBseqzEK9lG1nFs/xAsyZZ4U1+8wN9BLtvOf3lKN7gJf+/fBiPnoAg6loHb2OWzvpT227DXUj83COJdegXdwtN0aD7cr9rQsFzayvnqhxNWRUPo/LeiC6PfkDUC7w1Au398Lhyfe+EcD6wTbC5dhfka2ohZ3WTLjRHEKOKdsLmVv2SmSBKYvcUYNLulpQa7h0qUcNzBMnrEmtnSJYC2eAzUmmHFUVHBome7yIlBDbifE/CdMAgaeVPLnIFsNYlPQgPZ6HSsQA4iuQqH/9pMguD9/tqz6b2+VwUW+kc98j6xI5AtIJuRlMGPj77kEEEuS+Ze87d4SI7RzrES/MwguZZO8pS7+qQidNQWzo2XSianYke8TTSvSO0+0DzFXkG9K7Q4CJVY/BvF+g3KR/8hoUagphXF3YBL0gxWTvzDFu6G42gSC2ymoheznuT4SiMaqD6nmRaZatsmP72TFXmTrpo3YllWNxQSXN4NT2ugaQIBji56MqmKM72aFbo5j00yUGAAoezOvKmdsyZlHl2Tnqqfm+P0VYLCLHgBuvzyHrSS9MyEeWM69o4+OqKL5DeMElANcmgsAot/iSA80ptwrIryO4msm9WfYhZ1R19TxrY23Ww7bZIYQ/humLQJDp7449R4OAH2J1Fssp1gYzt0eA/30h+dEWeVwJTBBzDV8lI+ZCHg83bCsCrS6NmKr4ygBlemKwDxzhC5cMtFXRQHlFgIBpi+LHbiEEEIOcHm4AaADNOiJaOJqMt/41PFqmffJbq0OuZUddKT+aCvlNn5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] fs: queue_deferred_reclaim() fails to wake sibling workers on
  small batches
--

commit 8c1021dc7fb5b82263bdc1a9f11c91562cd680a6
Author: Jan Kara <jack@suse.cz>

fs: Basic infrastructure for offloading inode reclaim

This commit adds infrastructure for marking inodes with I_DEFER_RECLAIM
and offloading their eviction from the superblock shrinker to a multi-worker
workqueue.

> diff --git a/fs/inode.c b/fs/inode.c
> index 4b13125f0678c..8853eb6015dc0 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
[ ... ]
> @@ -1017,6 +1036,38 @@ static enum lru_status inode_lru_isolate(struct li=
st_head *item,
>  	return LRU_REMOVED;
>  }
> =20
> +/* Number of inodes to process in one reclaim batch */
> +#define INODE_RECLAIM_BATCH_SIZE 16
> +
> +static int get_deferred_sb_id(struct super_block *sb)
> +{
> +	return hash_ptr(sb, 32) % deferred_reclaim.workers;
> +}
> +
> +static void queue_deferred_reclaim(struct super_block *sb, int count,
> +				   struct list_head *list)
> +{
> +	int id =3D get_deferred_sb_id(sb);
> +	struct deferred_reclaim_queue *queue =3D
> +					&deferred_reclaim.queues[id];
> +	int i, wake_count;
> +
> +	spin_lock(&queue->lock);
> +	list_splice_tail(list, &queue->list);
> +	atomic_add(count, &sb->s_deferred_reclaim_count);
> +	spin_unlock(&queue->lock);
> +
> +	/* Queue works to process inodes we've added to the list */
> +	wake_count =3D DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
> +	if (wake_count > deferred_reclaim.workers)
> +		wake_count =3D deferred_reclaim.workers;
> +	for (i =3D 0; i < wake_count; i++) {
> +		queue_work(deferred_reclaim.wq,
> +			   &deferred_reclaim.work[id]);
> +		id =3D (id + 1) % deferred_reclaim.workers;
> +	}
> +}

[Severity: Medium]
Can queue_deferred_reclaim() serialize deferred eviction for a superblock
onto a single worker when inodes are queued in batches of
INODE_RECLAIM_BATCH_SIZE (16) or fewer?

Because get_deferred_sb_id(sb) returns a fixed starting index for a given
superblock and wake_count is computed only from the current call's count,
any call with count <=3D 16 sets wake_count =3D 1 and only tries to queue
deferred_reclaim.work[id].  When multiple prune_icache_sb() scans (or
single-inode queuing from iput_final() in commit "fs: Defer reclaim of
unlinked inodes") each add <=3D 16 inodes while work[id] is busy and already
marked pending, queue_work() on work[id] returns false and the loop exits
without waking work[id + 1] or any of the other idle workers, even if a
large backlog has accumulated on queue->list.

Computing wake_count from the total queued count (or advancing to the next
worker when queue_work() returns false) would allow sibling workers to help
drain the queue via get_inode_reclaim_batch().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124115850.3512=
-9-jack@suse.cz?part=3D3

