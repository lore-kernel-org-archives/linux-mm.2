Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25199C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053616B00BD; Fri, 10 Jul 2026 05:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003D76B00BE; Fri, 10 Jul 2026 05:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10866B00BF; Fri, 10 Jul 2026 05:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD0A46B00BD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:54:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25032403C6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:54:52 +0000 (UTC)
X-FDA: 84972408024.16.D171F41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4ACB840005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:54:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E21ryJ6k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783677290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Luiq+rufALoz7TWFSsrdQQTUMr5CjG0YobeBAejEP2g=;
	b=g8kPHa2h2xKVIxUsB2kjxXgNhPAqUttLrYWmR6gSga0BLmY27UvkV+kEc0DB2pL1QLMGgJ
	s7rSgA7ZB0sduLHR4Ga6rRsPvx5aFhr0NgfSpLWzUj4qjFqY+d3A2uj+xq+3DN/dkkO6dU
	eXZ7G4XJNz/b0cg6WX47es0aFXxjSh8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E21ryJ6k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783677290;
	b=W3pmLNKy7ZxxbzL3b5QWeC/AfpbwXxsXpiSaGGmefvd/JShlcTPjPQxb9k0z1kzZ/vlKUv
	XtRe86LBZ79mtcDK0WCCu1j+bu9JIUz22J9j3cEyYlaTbMRaR3XtJfAWMROyQ6WawbiytX
	teDVdAIr+UqN4my1ZR5y9L+WMYfZtXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE07435E8;
	Fri, 10 Jul 2026 09:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B911F000E9;
	Fri, 10 Jul 2026 09:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783677289;
	bh=Luiq+rufALoz7TWFSsrdQQTUMr5CjG0YobeBAejEP2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E21ryJ6k7ZRC/x3HnIYXKjJb8pZyISGJTauG+sNaEBXAExCjFbvq8Ui3wU6cMAA8+
	 YaFn3EfkB6+DhJY6nhHVFyHBh9whFH1Tc6iFrCat1alfztO0ZRsl7chen+QtrA8vM5
	 +7igdmHey2TR56QjM2S+WASF+UoSZvf0usAupuL3SzbxsJSPt/tQNcmSPDTR4l9/KC
	 DjjJRSKW8UvGi8tklxTvI/yi5ZyIB82PZl7hzk7I7Wz/Pb8W4Ochw04j3iepVTUbX6
	 uvOay1rKPnsPbvBytSwn7/LqFmUlUlLkYcC5Dv4tOIvgeXAVhLzZgLQ9g+/+woepcd
	 Ai4KLYdxajk7g==
Message-ID: <c7768cad-db55-48e6-afb8-5916c1a6f00d@kernel.org>
Date: Fri, 10 Jul 2026 11:54:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: extract __free_to_pcs_batch() from
 free_to_pcs_bulk()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Shengming Hu <hu.shengming@zte.com.cn>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org>
 <alB_hIJFVgFM3HxM@fedora> <alCAyjxEDM7PmsRy@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <alCAyjxEDM7PmsRy@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ACB840005
X-Stat-Signature: rheh6sb5fc4xrn5sdbngbnq7x3rxrg49
X-HE-Tag: 1783677290-463995
X-HE-Meta: U2FsdGVkX18f+1xkbnPTCwMtLwlVLI6hjuY4rDr0E4i1aLmkqiradS8rs9MmzfAbbGjRhUBL3Xy5JVig/lBhQHm7mJJ3NskuaIRArhMQQ+8KYR3Nh2MAy++kJXo3unwIjKN1UWohNV5LS3PqiTE/6qKoQqWuqQOTnCGjxay0br0aAtIeeLHxDPoUAeSmidb8M++CVCZHtC4Amre+mjwp4QKyp0cKutPGdeHokSLUvZIiKUYsmHX1rEv0co/M1p7m/AmEhIZf/GXoWvr59hvpXwSsx2Xjzxh/DKHeME4sSNoNz8Pr0grwBrJcIymKDjz3/GC/P9gPn040oOBWebf4ZiQdIQr65d0DS+oPU/rYgw07uKPJOIjWmbgwNRG75gl/riBUBR56Zb9yySMRg9DxsXx8H5GOWqS/u92lsdQvHW8bT9L9vjkE/KcTLWD+fCW6ZRfr+LDlwgIwAVnuSiR7U88MNI7heecCFP33eaqykOaS7yQK9PpLCExI72K8oxV+PKe6SLPwrTUWfe0IBKth/OxP/se1TLjC4AHOWGQE4S9MxEZgeIUcbWZLMTVfBxMkwUoGRglBWgpJGEWfB7BQxZ0KQmhEIEfJdhkiKjZYYMlaQQmgi46nQBoMCQDQ0V98bSv34UQ4XaXfz9zdQN9HcwCbJV0a3Jy1w75zpnj/MSg7i9/OcSvprJJ2fhtKuCIEZHZKJHtABJA1bzS0MhfhvbHa0ARr01XxglX3sMd0xvQDTvwMTJvbZ7h0USIugd7RpwO1YnmKBk6x1z5kqvQ6TYOVBX/D/6qua5W8CnDKWb84WWlWBG5lT1kauheEmJ3l95icP98T99yz1yt0GHD6uKhRTjNl9yedSPzauc2wsAWWHmirx3GUAhvG4gNYxSd4Har4u8HFXPOabogl/PSuNiQWx5jSToxfQPgJaX3dPim4KLJuGMGaMfwsT+2towRERecvPpb47V8iuQ5Wtiu
 gnn/Yy6+
 8LmXXQlPtWDoXPXiWsjQFOh1iM7veu/T/BiHRuijYcZ0UYheoKu0g2Eoecq+uWa2Izcr70aJsK5qnxs6JsIrSEAiiHhP2HmzC38S9/A67arCyjyrtxsNT0OQmnEuS8zVNI3SNABUEXKvEvfiNRQ72crdlwoMi3hmuVpJIGvNgPXWgRcB3pynep2+7eH47xRx8jnx3arYmYX3JdWoYPr8Qth64Ly9BiMk6CTcRKbBXRg92DbEsFds2TO9eloLJKx18jhkZxOtPPXeV/WIzQp2PYmZewUphxRcQ3wci5tkNywk91fFNXBAR0ro33dqrm1AMRTroPNymTwdqL2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 07:21, Hao Li wrote:
> On Fri, Jul 10, 2026 at 01:18:25PM +0800, Hao Li wrote:
>> On Tue, Jul 07, 2026 at 02:16:00PM +0200, Vlastimil Babka (SUSE) wrote:
>> > It has been noted that free_to_pcs_bulk() is difficult to follow, with a
>> > number of goto labels, and this has contributed to two memory leak bugs
>> > in there.
>> > 
>> > Extract part of the code to __free_to_pcs_batch(), which focuses only on
>> > freeing free-hook-processed local objects to a percpu sheaf, and
>> > returning how many were freed. Zero means a trylock failure or no empty
>> > sheaf available, and thus the caller should fallback to
>> > __kmem_cache_free_bulk().
>> > 
>> > Make free_to_pcs_bulk() call this in a while loop, removing all goto
>> > labels from the function. __free_to_pcs_batch() retains two rather
>> > straightforward ones.
>> > 
>> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> 
>> Nice simplification!
>> 
>> [...]
>> > +/*
>> > + * Bulk free objects to the percpu sheaves.
>> > + * Unlike free_to_pcs() this includes the calls to all necessary hooks
>> > + * and the fallback to freeing to slab pages.
>> > + */
>> > +static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>> > +{
>> > +	bool init = slab_want_init_on_free(s);
>> > +	void *remote_objects[PCS_BATCH_MAX];
>> > +	unsigned int remote_nr = 0;
>> > +
>> > +	for (unsigned int i = 0; i < size;) {
>> > +		struct slab *slab = virt_to_slab(p[i]);
>> > +
>> > +		memcg_slab_free_hook(s, slab, p + i, 1);
>> > +		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
>> > +
>> > +		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>> > +			p[i] = p[--size];
>> > +			continue;
>> > +		}
>> > +
>> > +		if (unlikely(!can_free_to_pcs(slab))) {
>> > +			remote_objects[remote_nr] = p[i];
>> > +			p[i] = p[--size];
>> > +			if (++remote_nr >= PCS_BATCH_MAX) {
>> > +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>> > +				stat_add(s, FREE_SLOWPATH, remote_nr);
>> > +				remote_nr = 0;
>> > +			}
>> > +			continue;
>> > +		}
>> > +
>> > +		i++;
>> >  	}
>> >  
>> > -	if (remote_nr)
>> > -		goto flush_remote;
>> > +	while (size) {
>> > +		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
>> >  
>> > -	return;
>> > +		if (!batch_freed)
>> > +			break;
>> >  
>> > -no_empty:
>> > -	local_unlock(&s->cpu_sheaves->lock);
>> > +		p += batch_freed;
>> > +		size -= batch_freed;
>> > +	}
>> >  
>> > -	/*
>> > -	 * if we depleted all empty sheaves in the barn or there are too
>> > -	 * many full sheaves, free the rest to slab pages
>> > -	 */
>> > -fallback:
>> > -	__kmem_cache_free_bulk(s, size, p);
>> > -	stat_add(s, FREE_SLOWPATH, size);
>> > +	if (size) {
>> > +		__kmem_cache_free_bulk(s, size, p);
>> > +		stat_add(s, FREE_SLOWPATH, size);
>> > +	}
>> 
>> By the way, could we move this directly into the loop inside the
>> `if (!batch_freed)` block to make it a bit more concise? but it's totally fine
>> to leave it as is! :)

Ah right, great suggestion! will do.

> oops, forgot to add the r-b tag just now :P
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!

>> 
>> >  
>> > -flush_remote:
>> >  	if (remote_nr) {
>> >  		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>> >  		stat_add(s, FREE_SLOWPATH, remote_nr);
>> > 
>> > ---
>> > base-commit: 72bb229f9161a1efcd5df32141b69fcc6ae81a13
>> > change-id: 20260707-slab-simplify-bulk-pcs-a8d0478feef6
>> > 
>> > Best regards,
>> > --  
>> > Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> > 
> 


