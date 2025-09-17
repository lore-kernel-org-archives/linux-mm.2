Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDE1CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BF18E001D; Wed, 17 Sep 2025 09:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253D78E0003; Wed, 17 Sep 2025 09:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1427F8E001D; Wed, 17 Sep 2025 09:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 051608E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:21:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0090B9E71
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:21:47 +0000 (UTC)
X-FDA: 83898804654.17.9A885D7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DC6D80011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:21:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rRINjgm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oVzuygt4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rRINjgm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oVzuygt4;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758115305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9155gyRlp80SfDBgbiQCHV4RbmEErA6nXhhU6covV8=;
	b=Eh+HlncdWviKRl42oUGQgnCQdULpwNA14nPiCCIgGxUnqzMMYRQB5Tphqo2s4LIt5XaAn5
	6iL4Zh+rZfxcXY6I4UC77r5F/wMx75Ph1Z/LqSZcyzy4gMwnmCoz1U+wAnBuFghGqdVcuO
	fOLs4lhBJ4C16Fv5ZYjTehWCZMOv4vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758115305; a=rsa-sha256;
	cv=none;
	b=neLIPGH1lTBT+5SZgUe7ALPKI7zGHUb6biAY405ct4t/WnPilL9OcyLolMSYjoXnOR6Ioi
	tXKeKweBJZe9XztCi32gNKur/bJrOcVHEc6y1AHiienj/CJSH+zxA4WXZTOsFkQ54NaBPJ
	lpmWHghJUcgFb5c9uMfkFBCksKATqFw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rRINjgm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oVzuygt4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rRINjgm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oVzuygt4;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B7A1227FE;
	Wed, 17 Sep 2025 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758115303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x9155gyRlp80SfDBgbiQCHV4RbmEErA6nXhhU6covV8=;
	b=rRINjgm9XXftmCaFqE42aDxmpGTm2BIkPOrnkkwjG9lrcnauCu+UPkoyNHx60HU59KQ9dk
	mns/v9v8O83c7irrcJByzpDm36S4ZEcFL6DyEGYUF0qd849sAbAxLTl5ATT24D+R5cdmIF
	0i6g1uZWnJ8LTeKTEuGzguBcvbqoLVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758115303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x9155gyRlp80SfDBgbiQCHV4RbmEErA6nXhhU6covV8=;
	b=oVzuygt4YW03vGLdPSeVFvAVpQWFlQBvv/EAL9t7q1HZe1begUvNrilsf79hgVrA2LQU6u
	ytwwursrUCx7SECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758115303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x9155gyRlp80SfDBgbiQCHV4RbmEErA6nXhhU6covV8=;
	b=rRINjgm9XXftmCaFqE42aDxmpGTm2BIkPOrnkkwjG9lrcnauCu+UPkoyNHx60HU59KQ9dk
	mns/v9v8O83c7irrcJByzpDm36S4ZEcFL6DyEGYUF0qd849sAbAxLTl5ATT24D+R5cdmIF
	0i6g1uZWnJ8LTeKTEuGzguBcvbqoLVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758115303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x9155gyRlp80SfDBgbiQCHV4RbmEErA6nXhhU6covV8=;
	b=oVzuygt4YW03vGLdPSeVFvAVpQWFlQBvv/EAL9t7q1HZe1begUvNrilsf79hgVrA2LQU6u
	ytwwursrUCx7SECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B116137C3;
	Wed, 17 Sep 2025 13:21:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vICNFee1ymiQcgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 13:21:43 +0000
Message-ID: <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
Date: Wed, 17 Sep 2025 15:21:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, "Paul E . McKenney" <paulmck@kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo> <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMqyn6nenR8V_p1y@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: daagsiahx1hgxzk1kufxkjjafz5btm39
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DC6D80011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758115305-874472
X-HE-Meta: U2FsdGVkX18u7wlSvJVmPnk81R8tZ3cE5oirtfOWdGTsJYRp8vZp5C6qmcnIPVuzZ+z16t11qEjS0xn6Vn1aAfvWVYmpsqb/igJp5sj8mJrz6AdmmQxSU/nCySzL5C/9U4gNqFhy3NiKFlpeIjTG/0Db5ZUI8DDQLUxS3vcBn6SerMQqvIcBMUQxLax1A0RrWyobaX4gGwHPE151vScjJP+kQ45uIC6tMpcldORAw5M/UZmDIQA6k5UmFXov5tDS+hNzdMM6Ye+fZUSM+cKs3ZjGaJNN5VSU+m412QOKrEI1a1R79UYtUlF4EAnVjsCc6hcNqoycngFBzN7yRxE2lE4ESJ4U3MsixcYVGfsoRm2C9We7SuTTDwswUieOh4WpFLWx3XCQC+H8svgV2XO++wWKtS0cU8MrnqpkgK05MhSK/Y6AV22bVCs0EOd3HTcTwQDIWlFrJUpRXllvkxQYV7A4QgPcK/fyFRngTs9JV7bqSj10K+I1JE+nmo6wmQzsyonuzfuSQemrodj9wpIZdAb2HGvwITJJsxAyDpQmAXFs7xf5dJU4sS+THwzmXEw6tYKPbmmmMCTB6TYQ8qWqpBwxWYH2rgeLqQI0w973IX2xcAFdmfPRsxkHa2y8LJ0lSQlNCeehCxOzd71YV9LiXs0MRxBSo3xsz6Bguo/9o1Y7pW6I51z8z+dLu1NwbG+rEHWr2L+SSHiw5H2eUdGUxr7t+I57G2j/EkNp+icSQzXs4w56z5FC+7WWyydHOki4+KnwRo/dig0pF2nYdkfwkZdCnYRswm9YGSy1HCsRjsHtB8QvfcQlfXQp31hnH+BAGgaIdXTfqolkI7F1VXyzqViWdBerz+dGoXBTwxM/RCPR9vWropuHQCtenL6ON9873R5IXGZH5p+JRCrXEE7SFRyxpzJPb8dQz1fya/RcNqA9z1lUoJGW/SWSrzMVqz0QzBFleTpKFQIAgWKNEjS
 unwD4OLd
 Czj3ULSNqryLOLDdvS6/KDJD0zmpkfUTB1MCIRj7vjEaj4y7v3MuueyikE6D5RFqzpWL+M3d5kbzqqQEjajsAM0Stpe2FoBDvelUK92g8naoxzRo8eLyvS8mjIYCbsbsDN6dOTQu1MWgVkDfFOmjuUbcWZj9IzsBmViy3YEVk0OUNvAm7nGM2AgCHk8JxR8qc4qc768osCv5irkrOZFpfno/J8/blKTWqQUWsTDrT7h+yi0kAhbmNNDLa7HGZxeVSyJCnMIzIj9vNjw5RJ+KdgwtUpZqDuS7dAPKJjOnY9s7rTJOZphG+w+M2XalpdyUYOvgooKkm2TYGBGs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 15:07, Harry Yoo wrote:
> On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
>> On 9/17/25 13:32, Harry Yoo wrote:
>> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
>> >> On 9/17/25 10:30, Harry Yoo wrote:
>> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>> >> >> +				sfw->skip = true;
>> >> >> +				continue;
>> >> >> +			}
>> >> >>
>> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>> >> >> +			sfw->skip = false;
>> >> >> +			sfw->s = s;
>> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
>> >> >> +			flushed = true;
>> >> >> +		}
>> >> >> +
>> >> >> +		for_each_online_cpu(cpu) {
>> >> >> +			sfw = &per_cpu(slub_flush, cpu);
>> >> >> +			if (sfw->skip)
>> >> >> +				continue;
>> >> >> +			flush_work(&sfw->work);
>> >> >> +		}
>> >> >> +
>> >> >> +		mutex_unlock(&flush_lock);
>> >> >> +	}
>> >> >> +
>> >> >> +	mutex_unlock(&slab_mutex);
>> >> >> +	cpus_read_unlock();
>> >> >> +
>> >> >> +	if (flushed)
>> >> >> +		rcu_barrier();
>> >> > 
>> >> > I think we need to call rcu_barrier() even if flushed == false?
>> >> > 
>> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
>> >> > be processed before flush_all_rcu_sheaves() is called, and
>> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
>> >> > so flushed == false but the rcu callback isn't processed yet
>> >> > by the end of the function?
>> >> > 
>> >> > That sounds like a very unlikely to happen in a realistic scenario,
>> >> > but still possible...
>> >> 
>> >> Yes also good point, will flush unconditionally.
>> >> 
>> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
>> >> local_unlock().
>> >>
>> >> So we don't end up seeing a NULL pcs->rcu_free in
>> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
>> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
>> > 
>> > Makes sense to me.
> 
> Wait, I'm confused.
> 
> I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
> only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
> the object X to be freed before kvfree_rcu_barrier() returns?

Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
the rcu_sheaf fully and thus without submitting it to call_rcu(), then
migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
up the rcu_sheaf fully and is about to call_rcu() on it. And since that
sheaf also contains the object X, we should make sure that is flushed.

> IOW if flush_all_rcu_sheaves() is called while __kfree_rcu_sheaf(s, X) was
> running on another CPU, we don't have to guarantee that
> flush_all_rcu_sheaves() returns after the object X is freed?
> 
>> >> But then rcu_barrier() itself probably won't mean we make sure such cpus
>> >> finished the local_locked section, if we didn't queue work on them. So maybe
>> >> we need synchronize_rcu()?
> 
> So... we don't need a synchronize_rcu() then?
> 
> Or my brain started malfunctioning again :D
> 


