Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E352FEFCD9B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02BB6B0088; Mon,  9 Mar 2026 07:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E863B6B0089; Mon,  9 Mar 2026 07:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D676A6B008A; Mon,  9 Mar 2026 07:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C53D06B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:42:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4354B137873
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:42:43 +0000 (UTC)
X-FDA: 84526337406.24.9690776
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 047C48000F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:42:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rrEPqHMT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uLdBqfyv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rrEPqHMT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uLdBqfyv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773056561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9dcjx44x1l7Xkd6W45YBGBYjn4gAtqSJ05zAZ1TlVE=;
	b=W/cbgsw1SXUIdTAsZi5G2RnZC8tXb6UchOCA1By5604Yd+Ce9A65HniW1qqq8nDFiMXIeI
	bXKH/wRdFHHmrVB0doZ7OlaN3Gzz5WZaR86tuonQ6u9S+nMv4kngphcExsITRDAN4pWD/V
	ueBVKBIidW62rWfGJBkq56TMgZipFJs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rrEPqHMT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uLdBqfyv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rrEPqHMT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uLdBqfyv;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773056561; a=rsa-sha256;
	cv=none;
	b=v2AgpriD7hlMliwdWOozp3/reR3MSTKr2CUR/4j96bsey49Q4CeMegMv3K6yY6VnwUAcVT
	v1YbzQqFdKh2cdJutDVzuJx3fOnDxI5/UyknlEGx+t0e8cc45sejbd6yLDIAsMfKhSi4tX
	dPeoQ4gBoPU6XpqSyFPmcCDz5PSUjxk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FEF34D1FA;
	Mon,  9 Mar 2026 11:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773056559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9dcjx44x1l7Xkd6W45YBGBYjn4gAtqSJ05zAZ1TlVE=;
	b=rrEPqHMTQV0IUHbUnCr4xfKryl5PN7j/XkwJ1J88Vin40m3Oihx9IljPSyNqfvJJewGWm6
	W51+bYg0r1O+wOloVQa1Ql6Kukx3WgEr2rjcygN2iVpGyKI/MgDS0txS2uOyTd5n4dnzWD
	IxANiH2GhF4ORkL5BBi1TDUgaA8MJMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773056559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9dcjx44x1l7Xkd6W45YBGBYjn4gAtqSJ05zAZ1TlVE=;
	b=uLdBqfyvHY7lF+c0Q1lRyu/GuQ9uXGhJtEGa28HGIWAE5OPy7yLcSUS6P+ze6ntszL1sne
	Q6GsfVkcQx1dPaDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773056559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9dcjx44x1l7Xkd6W45YBGBYjn4gAtqSJ05zAZ1TlVE=;
	b=rrEPqHMTQV0IUHbUnCr4xfKryl5PN7j/XkwJ1J88Vin40m3Oihx9IljPSyNqfvJJewGWm6
	W51+bYg0r1O+wOloVQa1Ql6Kukx3WgEr2rjcygN2iVpGyKI/MgDS0txS2uOyTd5n4dnzWD
	IxANiH2GhF4ORkL5BBi1TDUgaA8MJMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773056559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9dcjx44x1l7Xkd6W45YBGBYjn4gAtqSJ05zAZ1TlVE=;
	b=uLdBqfyvHY7lF+c0Q1lRyu/GuQ9uXGhJtEGa28HGIWAE5OPy7yLcSUS6P+ze6ntszL1sne
	Q6GsfVkcQx1dPaDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 232303EE9E;
	Mon,  9 Mar 2026 11:42:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y8WOCC+yrmm1CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Mar 2026 11:42:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D4870A09A4; Mon,  9 Mar 2026 12:42:38 +0100 (CET)
Date: Mon, 9 Mar 2026 12:42:38 +0100
From: Jan Kara <jack@suse.cz>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v3 2/4] KVM: guest_memfd: Set release always on
 guest_memfd mappings
Message-ID: <5blfhtmxxudflnekbdd47dh6cu4eherrrdq2n7e4k2em4qiix2@msak4r6zcc22>
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-gmem-st-blocks-v3-2-815f03d9653e@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 047C48000F
X-Stat-Signature: a57p1ncn5e9udfmmhex6shnxr19d5cwg
X-Rspam-User: 
X-HE-Tag: 1773056560-598424
X-HE-Meta: U2FsdGVkX18wiVD/2rOfFE4rXxHxtzHBZ2loklQ5XNgKaZ0yBHlNimlo40uvSK3C9jMlSDXu2clmKcF4tuacWwchgLDWJ2q8Evg/vUeIJzptCxHGyvpV2i+fLhVhSWghPIfJ8rH/nY8IkMf2dypC5NxFaCa2XO6lWgZhLkJH+BKCa00mVxFxu5ww9n2J2VmYxXNi9050QfxV2J7BLeJOm47EyspeyuwHQl6TFQXLRmwUChCDayVAiYpbn6gq6OsqrSdAOy5ch8sLvVpOkB39jIj9rUQS62LDN+Gdx3YMPeiKnjqK08OEoNPbug5Bbc4swVEd4aKnysL4DhDYk8XYT88uK5P4iU/826Pvg94JPtkOD9AgObM/Vqd5nn0gjE+en2q70rn8h2niRZdPZ92xoWUeYf/pk6oA+mkwZ6mRl+mcgWbOU+OZRtvwvaS8hrj+aePDNQ5EMPw+N4kOuVLMjIJxuu5bvHaTOFwox2hgwu5akJWOdYY8atNfA69E3YITr+IxQ5B9AE1qNfeedA1ytrzdigeXUbNZ7wbIY2/mqPNrK2sKIrK5f/R5jL38IoNNzRUUkAzX7e087pAnWK11chOSJ3NbjXJeQC3NpX4OhJKGoz7gxZBizqKTWNUzem3TCqhMUJE0RREWxXOdW0fgKC5ipJWWEy7UZCC3LPZV72Uwlw4TYZrtV701lcuM88tfB6HLrICdy0ARrqDlgTeEl3u/jM//26iWrce+7WYTNMfo+EfdGZ0Ppnu5AXGOtbT1MJesUF8BllMsfC7EdHXarbz03jR5+3LdgLZfdPGYCeRwn7sK10sVSeE34oAwuqUc5L01KyHzUHxrWdKo4uk0WPgO4GTxnrFgOk2qTJSiw7dV9PrWtmLE0ykt9/DeX3IlOVlES/kIApC8SDQRvNiC4JAzZo5QlYDX3lUT9mbJ88lJJL4URBYK7T7Hvz+zvflvVQ/2Vh4Q3cnD+PbxiQe
 ve7DvJvQ
 5pd7l8V6/EO6GF3RblJ33yvZaaZXo9qaSGJLgV3s2xKCX1c+RqA7Tmux0Rh79VxPrwuvyTmmCy+DapbEecPJgyf7jB7aQNykfJ/g8+dOSPorK0CzsgIqhJwso490EgZCMqUicb101MTrbf/f5BTKZCfmXb6GCNAc4XhUXudpptciD0ZeTaC5RNmAMcfiZc5mCo1s6qyPp+IZ+DtCGn8AG2Gtpvswqe7ERoMuD07EWa1gxnDUZI2cFzsUfPtpoQLfbzkGzk0MF7r94v9/2/V6XqftuW58TsS+Sm5RoFY9B5CrmaJINZLkpvpgsa6luUs+0Qrfp4N8xGUcP3CU5k7K3S3whbk/Muv1soBT84wQ3Mnd8SzitMowUZf6+TMzcGEhH1Cb85oInbh4H7XmW4WxMq94HRryZb3obECVg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 09-03-26 09:53:53, Ackerley Tng wrote:
> Set release always on guest_memfd mappings to enable the use of
> .invalidate_folio, which performs inode accounting for guest_memfd.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

I'd fold this into the previous patch because that makes sense only with
this patch in place. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

for the first two patches.

								Honza

> ---
>  virt/kvm/guest_memfd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 77219551056a7..8246b9fbcf832 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -607,6 +607,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	mapping_set_inaccessible(inode->i_mapping);
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +	mapping_set_release_always(inode->i_mapping);
>  
>  	GMEM_I(inode)->flags = flags;
>  
> 
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

