Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4B8CF3953
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 995256B00B2; Wed, 19 Nov 2025 11:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C156B00C5; Wed, 19 Nov 2025 11:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AB66B00D1; Wed, 19 Nov 2025 11:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 750056B00B2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:28:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CF5C1405E5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:28:03 +0000 (UTC)
X-FDA: 84127888446.17.3860B73
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7D1CE40013
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:28:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F+7aKlyo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=52ga7Pyw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IDb9oqdv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jdEHFe2N;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763569681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVGaf65rlgGbyF9diOMG0lcgKbDR4qeICAOaHzaIUL8=;
	b=AqRwI50dyDokPUNqClR58GAg9ZOgu752miGul2dlcMRCkLF0EUlQt+sjenR/kJ3YGbyh9z
	klsfCgSe+/fP3QtSbGFyK+YzVflM8vvG5q407a5AlCYgh/NosI4rLzf55JB6C4uDzOWNlj
	wdmtd3Xr4EEoreGvTtH3IYKB8cTq98o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F+7aKlyo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=52ga7Pyw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IDb9oqdv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jdEHFe2N;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763569681; a=rsa-sha256;
	cv=none;
	b=yaZAgKKqyarY0TCp+x9ZNgtfTKwoAaRz+6nyqYdERUxBCMDKXyOcYczeY1SjZytIIOWKI/
	eqYwG136Om4bnfZV51s5LDia/eGnhshX4noKJZEdXjP110ICAExfmWKR8FNXuEM7XzVFjy
	Xi0A2QoFEj+Mo6zZa95mqU6BrzkFn9E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E35320589;
	Wed, 19 Nov 2025 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763569673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DVGaf65rlgGbyF9diOMG0lcgKbDR4qeICAOaHzaIUL8=;
	b=F+7aKlyoMulWpbQB7R8crVLgmLNuONc7wd94FNFh9hbJyHSS0ugM7JgLuVoLcOpLcWlr5n
	5kclOyOzxseG4yC2nhBDXQm8cCF2TLGRBz/C5NJqpesIFylFR7aGSD5FdmUfQk3Lo0Ypbg
	D9xy+BMvapqji0uFFE2mpwt2kUGwJ5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763569673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DVGaf65rlgGbyF9diOMG0lcgKbDR4qeICAOaHzaIUL8=;
	b=52ga7PywMYBmf5VqP7XoY2nQ4MXISqJk6TrZvekY+6Bqp1tk/FMGUHQYFIHTcd6Yf37kMb
	/BEc6BIc3a8fBDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763569668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DVGaf65rlgGbyF9diOMG0lcgKbDR4qeICAOaHzaIUL8=;
	b=IDb9oqdvXBTsgmwX8XjdVesOnPYoUILAkgnZYlR8l5KbDZXFmUk4dqPpoQcB1L6b3NpXuX
	mDs2FaFlE3HBVIrH3wDFlDUosrwsTJYk65yYswtZmL0g1NnDcFxmPwaMx6/KsZSfe0hc68
	zy5/otA/jsva5YNmUwdhQjfYfkQK+bk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763569668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DVGaf65rlgGbyF9diOMG0lcgKbDR4qeICAOaHzaIUL8=;
	b=jdEHFe2NSLDJ9IFrFgcZOcT3bVTsMe8tvVjE3/fX7C887u8VZRviIMQgB1d002FxSW2OYt
	Sp8UbSU2wKKLr1CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5F4143EA61;
	Wed, 19 Nov 2025 16:27:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eZnUFQTwHWmBagAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 19 Nov 2025 16:27:48 +0000
Message-ID: <89778199-d4c9-4b0e-9e6d-64c9a23e1287@suse.cz>
Date: Wed, 19 Nov 2025 17:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] mm: update vma_modify_flags() to handle residual
 flags, document
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7D1CE40013
X-Stat-Signature: wcjgbhnwnsmz8o4atuywip6kzu6n8abj
X-Rspam-User: 
X-HE-Tag: 1763569680-563861
X-HE-Meta: U2FsdGVkX19DlYa/UIuyo+eDhisX9kmtjR6MW03sgOrsTEKoM6hctqLomv0e5m5r/t6xeCa2GKAQj7taM5WmkWn7SxOOC+sfu4HPprDk5Rr4VgG5QdkFrJ+YIEovxVxmiChJBy+DnHWcNxEKTWyFRBniIuiC4dckjbPxHSLO7k4/aos2Mcq50b33QWJPvU35H1o8o8hj38jrYeAWwhSSs/Q4D90HODTuMysj05iMxz0E7m8FywqP56Fd2cW5+CoiO9QGKVnq494abJ250rjDXrG0r6TyyNmMnTtoqFArFfSHK9OGKGWkpAb4bOSxKXV2MmG9eFnQaFBXzgKAaPvrs+9zensTFfD2hN0ZnbbJJvO5Rgp3sQg5/Oo2MhUX7R5HDJn7DRZa++nbw45cAeH/9KzFjIIsYK6v9Ax3+qZts8EMhCo4pnbOMLYNXl6MDWGTxm3Z+Nm56nKBWsW4UfaoralRJLG9keZAUS1PvdUBoBqdklURKlI6AkcyI7HgNqqq7C85VL1ebPVlkug9nBNVu5Qe91zjix4GsNnDGuRcX7z0+VJUYillp5ovSaEYPG63JeV4zE1OCgCb+ASubGcoVlY+9w1Dqs0MS4TVil3KeojWS82iDGVNVAY1zVeUFi/30YJNmponxXDCGsJDXSuDgqopN9FNvAl08cJVzHAld2YiK0CmhN+Z4ak//UWEdn85NxlQrh9VaA6kPCLl6MdFgiF4rqDKykxVvtrGllXIRtMea8I3xVAagv7uI3VzS6oQ3HLK3QIwXd8KnzHjFu9zLuWLgjVBqW2B+Jw6coLhuY9D+zJ5Q4MEYCxl7k00PA4ScAqR/3Nta94QxPcmvgY11ppjSnjXNSUCVXKtInX4nkj+SLux5DfeXmBihBnGqtCSqaVOfE+o/gDspqpj8wxrLiaXALQFZwrhbG4PkwQaVhzLnnYSK06r3ABjzwDJvxXSBNn54lkYzNIty7vICFS
 Q1RDHcb6
 FST4NQ1n39IaHuPkgwti1fLj/NeajgGZTNqVXL52PTGTeDBHAFn6kSAdqjqMfpBA3XzVAvOpQ/S6WskgNOr83AGmHmLdbH1qV1XIdK23k2ixJ8eu/WaLrmsKVcSF774JyKQ2Y7Vcg0QvtYRD1TzPpJ8vcn5UdK5cjdSRu27s7n7x2cU7Q/XmyCfoq5LOqO/FaTuICP1BAiU2bk6omO9oOcMg4B2fIP//BTM0D+WmrNpKtQBGZvi9E4xblV/QVTWGg4rK0ynRjQ13bRnYLaKAWPsXTO3DjNI6XDmkfSLW+zW2CPB0Rx0+PUsOeh4Wg4qogy9oDwpGQ/g2pRGlO+2sw2gay9DhM6PV3Bn6ZKcusKYIwVpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/18/25 11:17, Lorenzo Stoakes wrote:
> The vma_modify_*() family of functions each either perform splits, a merge
> or no changes at all in preparation for the requested modification to
> occur.
> 
> When doing so for a VMA flags change, we currently don't account for any
> flags which may remain (for instance, VM_SOFTDIRTY) despite the requested
> change in the case that a merge succeeded.
> 
> This is made more important by subsequent patches which will introduce the
> concept of sticky VMA flags which rely on this behaviour.
> 
> This patch fixes this by passing the VMA flags parameter as a pointer and
> updating it accordingly on merge and updating callers to accommodate for
> this.
> 
> Additionally, while we are here, we add kdocs for each of the
> vma_modify_*() functions, as the fact that the requested modification is
> not performed is confusing so it is useful to make this abundantly
> clear.
> 
> We also update the VMA userland tests to account for this change.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM (where the "good" means "correct" (*), not "nice", which is however not
a fault of the patch but the pre-existing code :)

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

(*) but it's likely there will be a fix needed, whenever I conclude this


