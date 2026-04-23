Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5370FAD3E1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1D896B0005; Wed, 22 Apr 2026 21:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE366B008A; Wed, 22 Apr 2026 21:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0ACD6B008C; Wed, 22 Apr 2026 21:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BEFF96B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:37:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58B9A16041D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:37:00 +0000 (UTC)
X-FDA: 84688107000.02.DD0B910
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BFD8B180003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:36:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpBZ9xFo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776908218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9rUY9YC5rYnyqRemTTfJUCseMVK/OZMJjFyjDs8kGs=;
	b=QuON1DoEYzlPF06HFxCPJ+7Vp+50PFxselXodigUkMuMQmQQyxMKkLbW7eEfPlrIApTBId
	h5tcAqzxn6aQKU+m2SYaEO6Lx0KrevN30HJ/ChOjUGixx0YsxY+YgtgtwazVt0BPpg5UUo
	QFKDTf2WD+SsYDWy9u4qT3TLpGd3zeo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GpBZ9xFo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776908218; a=rsa-sha256;
	cv=none;
	b=Mt/tH2jo/EWNq1ntEQ95lSxUo4508qNlqkIqpr8cYLA6yBFhXnDFgMx271Iw/vJoYgY0TG
	hPWqYM4+pDA8IcCv7sND/e7IqRAPLzB4RWdNMzidGVlEi6mKdihcuJqSGV0xv3rqwkUMh3
	XAPpFA3u1ty4J7oCr+Y635Km64q+nPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C0A060008;
	Thu, 23 Apr 2026 01:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC0C19425;
	Thu, 23 Apr 2026 01:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776908217;
	bh=5ophnTHEismmvQWNDghkIVI1SEYQ74JbW+R8huYXPOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GpBZ9xFo4lrMYIv2dAKyfjTO3L6bLC2iCu3G7ON2vbR0UXNKVfoEANFwoO8wK6jYj
	 dHfzZHBRKqFJfJiqqbQj1qm9E4c/TT37ZYF1hTGWv1Dsv3CZ9lud5na2bzE+w4QSRc
	 zljvenWVB3/E4Dre38b3Dl9/sSfu/zN3nSjLMFLAMGfrHosVkymFJTJ8GMS4Lq0uL0
	 Q7Flq6XNN59TPudpqGyVBUBK6TdeGqyOuKiThb5HDSXdJxnQb3aDupwW0NOAncpptZ
	 RflO7D+IGXpmneLUwhs0WLQsV/ZIRe0lch1K9DNHfAjngAaN8DSJFdyazTBjTn4jLe
	 sx/hSs2pqSFjQ==
Date: Thu, 23 Apr 2026 10:36:55 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/8] mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
Message-ID: <ael3t-hiRrJEPyIi@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-2-harry@kernel.org>
 <baa235a3-59c4-420e-8f1e-40c8526f3bf2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baa235a3-59c4-420e-8f1e-40c8526f3bf2@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BFD8B180003
X-Stat-Signature: p39egp9hr9f15rxeztdgyr19ymynu1zx
X-Rspam-User: 
X-HE-Tag: 1776908218-758739
X-HE-Meta: U2FsdGVkX1/ta9t33huMY78B8ECgu6dzMoyL/ZmKu0BBCdltf5WSAaoXZIc9M1hlOzzaF9uxPUNOvnnr+q/htrfUY9DiRKYaftrWqWFp8b7SG/NVkO+BPwkK5ioy5k9pNvzEaEu0l//qDqkMflM3fJ//0K62McnXKyRmPYRvefCXnwf+EUzEYoRbj8cUBL4tPuXIbJ8cY0KY5kL19lUE2NYCA85KwLSQf0SeiMUJdxWsxtON8INRr4fUIuqg4N13HXJargI1NCc2uZ4IckhBADEMuzlaJXdahofJUBjvaHjat2KdUAX774zeo8OiyAouVxEoweul7wxIvFgyT0RX9nTe7ApmiXbgbyfhE+xaevYgzEUvcyPtFr8lxqOrNhFOM+N5ZfNvOjFtSnDL59OdKfh1D62t5YiUJabKdmBRTEt4a2VAvhDTWKhiI2jbpnZ7oni2qYXEzWdj5MrsWjTVkhf+apxD+s4zynEpVCutgbWpt2BEhnRbdG4iymfVvOH/DXn6rf7qeayd16EMpWEyEWMNx1Jz7KK/mwfBeaazRP5AKCI5Au+8o+pRCsshPBVcHFeouqxF3Kv+egK/l/jSohQthF94EAHyYAoD+4WUdYJ+gUnX4VlqRau7tPQhetncYIm0qFDlyb+6Vexw1QNSSZijXvKeZXlwqioJM+DaEzsGEhRkMNk4+ejxLQcyJy0sMoKIigEDvez7Ib4QEzPqNYkZEOjpfzDLNdBSTAb4hqlRNfDLWEN54jSToJm5GEvRxgBoarxYLjU2iaeFVcG52UekR3s8/73CiRCw1vCwTocgzA/xYSBmBaNIgRkm6eSmRRSzNFoTXKIELyZb6rC/Oo3oWqzA5Zmyqy0h4Z1Q5mnxIFYdPbXGDxkdMAIb0IOpbKZCc3fuAYdCbFbe+4b5K6hXiU0gxYY6gj/F1y0yNmI7w44SJH16bCK7yeFcl49jIEU8lG9xtaiWaHu7CVH
 1YuYRAK0
 Yy418zt8aya5XBcJzppiicAL/gn2s2UJ43uCIJlK31puPOQ9jQFjZeaB0993C9r77s9bmeqM19UO/EO/Wx2SfXQA+DErWDZ+4S7BXyizfnx835kO/vhbbo8HV2j5Y2ODIXlPcpUlgrI2J2GjTbRub08P5k8+Wkltyh7CSMYNBf+Ua/rwsCN6I8xYsaajpUbfHtRk4N58J2xjZq2oeul0wMI8LSdCnprtRRcdUVAei4f8T6ghoNSlA8wxxzTZ12/UCcB579Lo/LZsmGagxJbRP+Ei2zfEZmxdQIPr31/uqK3QFFjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 04:41:19PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> > @@ -1523,18 +1522,34 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
> >  }
> >  
> >  static void
> > -kvfree_rcu_list(struct rcu_head *head)
> > +kvfree_rcu_list(struct rcu_ptr *head)
> >  {
> > -	struct rcu_head *next;
> > +	struct rcu_ptr *next;
> >  
> >  	for (; head; head = next) {
> > -		void *ptr = (void *) head->func;
> > -		unsigned long offset = (void *) head - ptr;
> > +		void *ptr;
> > +		unsigned long offset;
> > +		struct slab *slab;
> >  
> > +		if (is_vmalloc_addr(head)) {
> > +			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> > +		} else {
> > +			slab = virt_to_slab(head);
> > +			if (!slab)
> > +				ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
> > +			else if (is_kfence_address(head))
> > +				ptr = kfence_object_start(head);
> > +			else
> > +				ptr = nearest_obj(slab->slab_cache, slab, head);
> > +		}
> 
> It seems a bit wasteful to do this... (especially the virt_to_slab()) part.
> 
> > +
> > +		offset = (void *)head - ptr;
> >  		next = head->next;
> >  		debug_rcu_head_unqueue((struct rcu_head *)ptr);
> >  		rcu_lock_acquire(&rcu_callback_map);
> > -		trace_rcu_invoke_kvfree_callback("slab", head, offset);
> > +		trace_rcu_invoke_kvfree_callback("slab",
> > +						(struct rcu_head *)head,
> > +						offset);
> >  
> >  		kvfree(ptr);
> 
> ... and then throw it all away and let kvfree(ptr) do it again. So maybe we
> could then call something more internal and specific based on the result of
> the above.

Good point, will do.

-- 
Cheers,
Harry / Hyeonggon

