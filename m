Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6B0C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8546B007B; Fri,  1 Aug 2025 06:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358D96B0088; Fri,  1 Aug 2025 06:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247AD6B008A; Fri,  1 Aug 2025 06:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 140476B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:23:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78D0AC07FA
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:23:02 +0000 (UTC)
X-FDA: 83727800604.12.4813F71
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19CD6A0007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:22:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcUzxOaV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x7xLNPL5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkmvhwXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nylRbN6I;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754043780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/mttwEsHX709YDwlVU+ZGi3l/yWMWZKQA9ZzFewbak=;
	b=PncYxxwISLaIjyQWoyuFt9ZJ6trwb+VxeY2/set3b0c+Nc3g2BAbHSFNQp323WPwUabuSJ
	Tp00MM+9IEMcolg6xRRhXBb9qXU1x/2fyvJSzQNdIfBd30EonlZ7NPtnTydpdrNOi6bt1i
	X3sr2fbVZ7zyLAUe//lsl+nOEhIYjwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754043780; a=rsa-sha256;
	cv=none;
	b=olr0CKBciOPjPYz82M78RYg9mxtLmPFTw83RZqR/2MoLZJ9MT7PQMx9pX2GYMG27z+uSsS
	XxvV1X2k0+INv7gWjU1xBoyBM4DmYvoeB8410So83epejjXEwwxe6VoqWPO9mTb4kfodis
	QZVP1uEwHtwzW/KBI6UoVfjZRdmYcY8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcUzxOaV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x7xLNPL5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rkmvhwXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nylRbN6I;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5A95121B74;
	Fri,  1 Aug 2025 10:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754043778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+/mttwEsHX709YDwlVU+ZGi3l/yWMWZKQA9ZzFewbak=;
	b=LcUzxOaV8EBJnI7oUHzumPHmHutfKhkZaUGXorFJkoODeP+xVa9NdkgvoFfrZUNsFPCeE7
	RK7wzshg8CzfDA9B7vxtz8Y6ss1ovQKeId63Jnd2c/VPVZg8nbTXYQQgDJuXnZ80Z6mJTO
	CnsT6iZvbyb76HsvyAPGmT44z+M3DOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754043778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+/mttwEsHX709YDwlVU+ZGi3l/yWMWZKQA9ZzFewbak=;
	b=x7xLNPL5asUcyzJ59bjPh2dWcv1o3ap96slV9iiO01QIybF67aI3i6MLKYJLm7/jMFxTku
	MiVgHWr5a/ljAHCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754043777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+/mttwEsHX709YDwlVU+ZGi3l/yWMWZKQA9ZzFewbak=;
	b=rkmvhwXaoem0d+wKEQ/0i/ZrLlmcmJN/WcUvOiWX09qsq65UU1IJOjAcN4100Fw7hD+gof
	nAzVC8Jv3URrGRLTOf8WvOHMQt0s1An4S+6y7coCzTxwd9dvqQkfMWCHvYstwPX7pD4Ioz
	WhCVLFbhnw8sF4Ci7J3vQeu0f3IQ8zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754043777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+/mttwEsHX709YDwlVU+ZGi3l/yWMWZKQA9ZzFewbak=;
	b=nylRbN6I6rpif8yaqi3lMlabl//ni7rvPavKKEuw2Zl8t2DUhQ1wf+qxCIIYCZzn1vL/N0
	H2sGYS0zAWCNDhBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32127138A5;
	Fri,  1 Aug 2025 10:22:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KPu6CoGVjGhRSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 10:22:57 +0000
Message-ID: <759cbc9a-bf34-4acc-87cf-6f1f708d985c@suse.cz>
Date: Fri, 1 Aug 2025 12:22:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 2/4] mm/slub: allow to set node and align in
 k[v]realloc
To: Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
 <20250730192017.356410-1-vitaly.wool@konsulko.se>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250730192017.356410-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19CD6A0007
X-Stat-Signature: tw1i4qskhc8kdc6ok3mk8i5pfh43a43j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754043779-692536
X-HE-Meta: U2FsdGVkX18T84rlajq1cuYyRN8+Z+clk2gS+3YSgn9XGR5R2LY/apRMpPEQUL1gMkF7upmZgee/r8DlfMcMwxLjxHr+FiXZb/NxSBXB2D3t/lfQx8JhXbOl4eSU318VX41d7/+75bhjRPsQLW8i2p/qFRA+aany9RLZuffhYuJd201lcAyVsN8iIBnsx+okN1gSjTNruQaf57xyS1g4rhg58OYWnyuPGJbBjBF1Qxtz6B5BUjO+FOHmaafUH6/XflhCzqnCXjlD8gpJVMlzu++67tJwYwcQhefhgXFcnNk4Uc4d/5aDWjQFDrMpUeA8JOI15k8XymjOWvCJjMMwa278zcOeb51EwrB441dBLct2joptaMPl3iWgZLInhjf5aOj9P2w0pKOQAuFXsCPeULVNt7TaPSYnkDJguh8k72JeevJHc/k9mKAoAr1da0LwWdQPKi6iFe5gTwXAj/GpjpzpPN51Vbhc3HIozdBovQtK5Q+uoa1VBHEiDqTe+89IoXSPuMxAZ2UoTNEA3C6n6jFqBe5C1A5avVNR8UMdFv5NLIFNFFUe9eI5DebvyfXyM7eh3Vh36N5gmDwRblt1sLO69s0sdXHC0zu20lhEPyJ/D0beMeyXgQrZb5bu4jop97i5t7xGwkWfmZ9gPSijVqkpFT4l2clvawUMuVXp6yDxd4i3MpR+ad5BqneRBYx0Zzp4DLGpxzEQb5gNWxWYShWkkyxTSuS9HaCyp7i1gC2W0JuXcO7BWrWF1inYzy/QWM9yldPeY8+qyltkREs4uL86o13U6AYa/o8xlKz8bEsLwn3gZWoO1eZ/2+dZ6G8LCcQREubMnOXk72AScV1VRHJDOhPoecI/wvO1LOhZe2Lhng4+BWgghviSgD4PZhb3gHhjoBXC3salc0aHjk6QdAt41+sNXXj+jhIwNFHJgraTZ3BJVzBLujl5+Wu2Io52XmXkVlfIcuGhldUcC71
 f3F+gw7e
 qZLHAd3Yeo1C7nBF9aEMZQIRZVKxWTIWWNABUetpwgiGBgIPnJBkFIZQ/tYm5NxVAoQ6e1Rgoeh6yEbe5GzpKHaJcGD+LEztjzibT1BCaTLsN3kLam9nhWcGZoDCgvTaSbeybKBp2jj0AKpyoPVP7ddG5U7QRVfPHyuSkf98qjbVPoa2Iud40Oq6aH8UTYs4XN2+q+wi+5m0d8D8zQOMdm5z2AJFArYdU1ubAhTs6HOxO8/8d07nicN9iLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 21:20, Vitaly Wool wrote:
> Reimplement k[v]realloc_node() to be able to set node and
> alignment should a user need to do so. In order to do that while
> retaining the maximal backward compatibility, add
> k[v]realloc_node_align() functions and redefine the rest of API
> using these new ones.
> 
> While doing that, we also keep the number of  _noprof variants to a
> minimum, which implies some changes to the existing users of older
> _noprof functions, that basically being bcachefs.
> 
> With that change we also provide the ability for the Rust part of
> the kernel to set node and alignment in its K[v]xxx
> [re]allocations.
> 
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


