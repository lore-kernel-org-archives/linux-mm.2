Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE07CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B328480085; Mon, 27 Oct 2025 14:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09B18000A; Mon, 27 Oct 2025 14:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F3580085; Mon, 27 Oct 2025 14:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7288000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:32:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33B791A023D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:32:42 +0000 (UTC)
X-FDA: 84044740164.08.D1996E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A57C20007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:32:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=28hhJwrW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCSSo1Q6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MFgb0DcY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NNHO9nAz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761589960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8rPVFIRQgCv92HXGFMD6V73imct01W8ORHRoz8nI7Y=;
	b=yWJCIXsYSG8ueq4IRr5nVpMjfzPPMd25Lp/TBEyRXQcsM+yeKKlm7xkZNIoJ7TsJXpah7n
	PxhjQfSHaPIZgvg/32rm64uyTVayji8KtAY9EQMNxBBdh1z4G734RR4KpW1qBiIqdDvNqR
	qkOMfsMK3z2JDRebYYPYUNsIdY5Dfxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761589960; a=rsa-sha256;
	cv=none;
	b=VNhaPJdUa90/ENFHaks+aVCqlBjz0z0GTK3djxsDK7PZAalS/ANZNx1TYDejVZ/XCyGHAo
	rV1St35+Ql0kscHMQlUfFkp0NK5NS+F8F8Gb+Dvrn9xrG5zK7aL9JuWnIGKuIXjKX+XhW8
	vEBBkQjL3Kl/V1iHw4+bKAaF7pPtqC8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=28hhJwrW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCSSo1Q6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MFgb0DcY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NNHO9nAz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D9D61F387;
	Mon, 27 Oct 2025 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761589956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8rPVFIRQgCv92HXGFMD6V73imct01W8ORHRoz8nI7Y=;
	b=28hhJwrW6vdDKviAa1rsA6mADWrOFjhxZO7GNHzLNcjo+sKw5qMxMsRXiRrELaoovBvJbT
	2Ec3hzzRRAGeU0Ov6n0fOsRlvykGUTZRY/kAmUB29uODhleZ6hfN35znL+6r7yw0/eqvH1
	Aawc1EgPXeGA6PDnqPovmKjPfknc9+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761589956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8rPVFIRQgCv92HXGFMD6V73imct01W8ORHRoz8nI7Y=;
	b=oCSSo1Q6f5p/sw3jTqmBU8nru5dSlTedDUcdVCwqox/EQwfC7hFq4qCWBttdEEr3vDXMET
	iMMmbh2WDY1UYEAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761589955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8rPVFIRQgCv92HXGFMD6V73imct01W8ORHRoz8nI7Y=;
	b=MFgb0DcYPS4VOwDZBLt+R1ZzdjSNtxGZJB19HEsRrg3x89beEvCVhXiWCYwaH92JLo15Dd
	iYNnXwCAVujKeZmz9jhhTWjAB30EOILqN+zgwjExoyxENMSZkbmz+HbStou0yYYx9mX7fA
	+J5Pa3RZfjZuP6MIAYhX6SWcM58ln9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761589955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=O8rPVFIRQgCv92HXGFMD6V73imct01W8ORHRoz8nI7Y=;
	b=NNHO9nAzROXYjCE6mO52dtZV4lNQxzZcAxn5SzGZSHH3nodezCwW7X/7LllPxfp+qcFakW
	NCrBYOAohVEY0XBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C84013693;
	Mon, 27 Oct 2025 18:32:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dK0THsO6/2iLCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 18:32:35 +0000
Message-ID: <44066802-b505-4431-881d-371cf36f6d92@suse.cz>
Date: Mon, 27 Oct 2025 19:32:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/17] memcg: Convert mem_cgroup_from_obj_folio() to
 mem_cgroup_from_obj_slab()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-16-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-16-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: 4niz7578kqcj4gftgnhcxgr4zthswhhm
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A57C20007
X-HE-Tag: 1761589957-145087
X-HE-Meta: U2FsdGVkX18JPP8G3DD2l75ODOdORaWiEl8JgNmEyr9LwCxnbj1y5JOX6dIhnXixsW+FpEkYrq51xNExJZbN8DLnkviNjDHLPsDdf8nGrNAWFBKKUNulIFPf9y+7GlcoykWbK4XaZbcA4/6Bgl+9K7gVjB57hVD2e58RA/JzM4ZH10mbU1EKWsdBBogDhvboTTuGofD8khr/XlZPRRzrrce8YApTysy8y3OWL24kf/TRxocTFcnZnOLRkGulMP7K1HAg1mcEQqpa0+C2Kmk7DxE9tFxhz+UwE50CcFzA3GGDlSL3SJgCfjBTyAg6u4wag58TzxmZY/1b13MLkyuzqFY1DkgHmRHSCRulnc64HC6Wn9K3pQdkkrI2XSb3DEV0p8EcfYALD47qA6SWWQDo9sAbMScDOId9WLjdYjbz0/yjSe/v9SM1uxlrJ+yGeSa+naWXPpAQj+E9i4aBDzyu7xsP9yc7Pt2YLGSeK/aFtF/WY7DndjRd++7qxtdcDD0pLwJpw1BVcnauS/u/hws3vNzanxZe9UVNDymBwfEoj5nR0dlSMcEGQGGQ03kG/UmKqHFM3hiyXEbMgrJ+Pi5kvoF99hOOabup548fPBlNJMGvvuDOeVLVaOIOXWs4jreRws18M+rYCNoAaeORhJuESDFV8Aw5HfnDpXLcEc0rHc3b/OtHwpMlVVMsuySVHBYld9Wme958+UD8oLuiZ2KqzY6Y1TGcCT0Cyq/SqRm/aLceaTpDakhhEHebbF4P/bBuSwsBdiwJMgdH+3KUlE6gsj1pfs8asw8UQnojuK+rsz06M8K73IZMHyGuvspxf9j3i/hziNRbxurpeDzQ+MogpJB/8P258Zq+nfMxMVVpMuK3cey6foGWIZUVaI4+bjgpi0p4+VRdg7WZZ1zbvo7yaWT8xo3TRd4DpZ0rC+wOo74fXuPNlYRGkdQEf8rBZ1IKm6dHYeUvNnixYGWymkf
 ErSFS8lF
 1ZdlKzKh6D5mQjJcpxYZ4xxLycZ0u4wAoQKZsdYywKwOOGRAMz8FdsQhwjwRl+Zcw745vA69GjA6CmNz5bP6L+CkunvfwFZfRmAPuRMzOIQ6iL/AOs1GTg9JGd4UP5/LZYgwY+qN2mHffMJz0xA830z09pS+RCfhhM/gM66/rLBG6+uJQfZs0+JlDRkghAGViS7oahmVGismvr8YpStVzQG0GqPNmG9veEJF3GiUUdVCzDMl8Ty8BwbzSsvmD+Xi9FdgxhQdBe7Bu2VMZpQmySMZ2EidRWluhCO4p+krtZYI6VO/Shupbx/XiSbLa6G1/NJpO3HdutYk8ajimGf9L5kl23SXnXBVs5CIdt5RpqktDkDEYrDNyDaPw7q7mOB14qNKwk3Z2WTJ26vY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, convert the pointer to a slab rather than a folio.  This means
> we can end up passing a NULL slab pointer to mem_cgroup_from_obj_slab()
> if the pointer is not to a page allocated to slab, and we handle that
> appropriately by returning NULL.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/memcontrol.c | 36 +++++++++++++-----------------------
>  1 file changed, 13 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1a95049d8b88..c3ba53b40375 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2558,38 +2558,28 @@ static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
>  }
>  
>  static __always_inline
> -struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
> +struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>  {
>  	/*
>  	 * Slab objects are accounted individually, not per-page.
>  	 * Memcg membership data for each individual object is saved in
>  	 * slab->obj_exts.
>  	 */
> -	if (folio_test_slab(folio)) {
> -		struct slabobj_ext *obj_exts;
> -		struct slab *slab;
> -		unsigned int off;
> -
> -		slab = folio_slab(folio);
> -		obj_exts = slab_obj_exts(slab);
> -		if (!obj_exts)
> -			return NULL;
> +	struct slabobj_ext *obj_exts;
> +	unsigned int off;
>  
> -		off = obj_to_index(slab->slab_cache, slab, p);
> -		if (obj_exts[off].objcg)
> -			return obj_cgroup_memcg(obj_exts[off].objcg);
> +	if (!slab)
> +		return NULL;
>  
> +	obj_exts = slab_obj_exts(slab);
> +	if (!obj_exts)
>  		return NULL;
> -	}
>  
> -	/*
> -	 * folio_memcg_check() is used here, because in theory we can encounter
> -	 * a folio where the slab flag has been cleared already, but
> -	 * slab->obj_exts has not been freed yet
> -	 * folio_memcg_check() will guarantee that a proper memory
> -	 * cgroup pointer or NULL will be returned.
> -	 */
> -	return folio_memcg_check(folio);

The changelog should perhaps mention this removal so it doesn't give people
pause. I think the comment describes an impossible scenario, you probably
concluded the same. I'm not sure if it became impossible unnoticed at some
point, or was bogus since the beginning. I'll pretend I did not try git
blame that.

> +	off = obj_to_index(slab->slab_cache, slab, p);
> +	if (obj_exts[off].objcg)
> +		return obj_cgroup_memcg(obj_exts[off].objcg);
> +
> +	return NULL;
>  }
>  
>  /*
> @@ -2606,7 +2596,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
> +	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
>  }
>  
>  static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)


