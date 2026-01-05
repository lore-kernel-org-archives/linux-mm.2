Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E66C79FB3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 19:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71CC6B0005; Mon,  5 Jan 2026 14:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F696B0088; Mon,  5 Jan 2026 14:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01616B008A; Mon,  5 Jan 2026 14:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C13A36B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 14:19:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F85D57946
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:19:08 +0000 (UTC)
X-FDA: 84298873176.07.00066BB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id A90C0180003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 19:19:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UF9KYGhY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b8/vA1fQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UF9KYGhY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b8/vA1fQ";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767640746; a=rsa-sha256;
	cv=none;
	b=a7asbcQCbk8xEyAlKq7sBSxYFEOmQinjA3K7w5amMFibMkGHoJp5ErUx9GwK8RSijw0xgc
	KoRUbnMbuWFkQTwyJRTfqYNbaSK15k2uDmYmyFpzFPQBYuv7w7Xew5gnf18eJwGFymnvGa
	e2DmYSod9rxVhtNr632qBQbEQbw7YjY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UF9KYGhY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b8/vA1fQ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UF9KYGhY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b8/vA1fQ";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767640746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gk7wjaXN1GmwZPiHBvOLEBq0hQxeWIal5KrLUNa/Zg=;
	b=Hk4PYaBF75wI8/m8xY7yhQLGJQNhLu3yvCmT3HTZvG/bRjORvwqigqW7csjHXD97jiI0m0
	BmrIrMS/9tDUd5CiufblY+y6y6Jp9N8V9A2RN5qLpQF7HS5WLTv+wwBw6Ka2ar1JtGgJ3v
	wjimWjsU0cC28sviofl+UblZnyfM0cA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D41C5BCC1;
	Mon,  5 Jan 2026 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767640743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Gk7wjaXN1GmwZPiHBvOLEBq0hQxeWIal5KrLUNa/Zg=;
	b=UF9KYGhYxKbIY6im4cAVFphaF79JcyJa2lMjJ51kISmpG8q7mRJX9OTYOdfJIdtDj2xTQL
	3FJFykCad4G+0df/w0v7+CoAN0IeZD9pLjZdKQTeOJtqh7a5t7tEQgahETyOyTKiRSDRxn
	7ti+G98zPmp7ANmHcDqM2om5vDrHQFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767640743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Gk7wjaXN1GmwZPiHBvOLEBq0hQxeWIal5KrLUNa/Zg=;
	b=b8/vA1fQlxADDvjyk76zcNr7jSl2Yy2c0vnIvXu/kQ1H7f6oiLYvi/Jq5XEWY5BYFzwmNp
	4hZI9g9h4QGPpaBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767640743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Gk7wjaXN1GmwZPiHBvOLEBq0hQxeWIal5KrLUNa/Zg=;
	b=UF9KYGhYxKbIY6im4cAVFphaF79JcyJa2lMjJ51kISmpG8q7mRJX9OTYOdfJIdtDj2xTQL
	3FJFykCad4G+0df/w0v7+CoAN0IeZD9pLjZdKQTeOJtqh7a5t7tEQgahETyOyTKiRSDRxn
	7ti+G98zPmp7ANmHcDqM2om5vDrHQFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767640743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Gk7wjaXN1GmwZPiHBvOLEBq0hQxeWIal5KrLUNa/Zg=;
	b=b8/vA1fQlxADDvjyk76zcNr7jSl2Yy2c0vnIvXu/kQ1H7f6oiLYvi/Jq5XEWY5BYFzwmNp
	4hZI9g9h4QGPpaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C49613964;
	Mon,  5 Jan 2026 19:19:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qU36EacOXGlbPAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 05 Jan 2026 19:19:03 +0000
Message-ID: <56598d76-02ca-490f-a100-0f223fb5717e@suse.cz>
Date: Mon, 5 Jan 2026 20:19:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Content-Language: en-US
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, lgoncalv@redhat.com
Cc: akpm@linux-foundation.org, ast@kernel.org, bigeasy@linutronix.de,
 cl@gentwo.org, clrkwllms@kernel.org, david.hunter.linux@gmail.com,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, rientjes@google.com,
 roman.gushchin@linux.dev, rostedt@goodmis.org, skhan@linuxfoundation.org,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com,
 Hao Li <hao.li@linux.dev>
References: <aUVTJyd74OoCtSyN@redhat.com>
 <20251219135143.7337-1-swarajgaikwad1925@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251219135143.7337-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A90C0180003
X-Stat-Signature: px5kikdh9zqip6hb9j4bbdeoufu6r1ya
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767640745-357945
X-HE-Meta: U2FsdGVkX19fq7enDSRaNurPywlTrW75c/27T2Z6HRZcSNsmXu4CX8OVVXCbFR6TFoapsebMhd6YzYRpfGFVImsM+vf0DMl8zy+x9kiSYoBb3bWbKrCs/YAg72Jq9EL9UzYWxmPCRUuwzigkV6oi2PerpT/UPZavZblClbokVqNJPsg9h7UdKAjHGFbufsu6xijWbtfx8U2HrcpsTeD1Kysf9di7RLOtYvyiBvP28I8GGAQnE4JRFscMixAcu5V2hHJvEBU+bBgW7U1P2JT2VrDugQLqfz+novvbnOVsGlfoqRDeHnP3oAC96GnDpJox9aBC17Zuh/OKaTs9wjPMfvkdfa5aj8G1tkzwkqhYAAg91Js9DA95MxDPcrtCxMznviygkU14HWXBYNomuF1iOYzyt5PtxYiyoOPzKsVyIY0vCebapafueGCrwrpVH9V2semWjoTFQTE+Z/1mKjm41vl4e2Jx4ZsrLLkbaZzlB1IOe0tk8crdOm3jQbQKk9Zchd404HqGTuZkyT546m0LWsvVkOe3VgtLhU1rim7xmRbOCUGAYQYmN08KAmv3hz3rCaqT5vUji+Z83vpHuyi1cx+nlwEqHLvxiYFJ3BqGfRYb5NjJRBVCmhVhJCOD86nMK/ODMoW4iffD9cjwbK5VpzZzDQaq6KTaP0uRFjeyaGjCXgAwRfWZF72jkUikYFnZ+WJOEu2ibvyirAA8ahby9d91eF+IT4KIcIkzI7lfBNewwe+5uBw6ergNXZwuOcNMWzuxDfGczZg4zyn3uUPVh+8bQF6zccIaYg/2BavaseEasbG1TZX9wp9Korm39c/gQzET6HqcWP+OwmmdgjaTYe6vrTOxXd0LLuDKVdpYFvN7r7UhBG4v2ziUU3atT9ZLWtrJXiQSgAPaHTdGNXVnwhKrNf2gyHU5OyArmEqWC8JIY89m8bYO02TST3BiewQqNqvXm+kDYooKifaj0j/
 09G5D8E7
 aiReGqb2hSkSB80RAwME2gpcG8NsOcccOZIuwBIGQPjYcFPlkEhjrIFIQTFoNVJKq1pSyBkrhzFGzQQfkt09uUYwdJq1n5hp5551C34lro4LflreUz4a7IXCuZGGWsdzSouA2aHccFfs4RuAB5uo8hcahYQIdgIUzhKMBqb7YRQ6TKpiIP33uVHiUsuvX9zDwUnyO5ElEx3ngKuV71EfIu65ufEXGQ69qOj+DOjdiL7KwwUS7nS/+iiStfMl3Wv5XHVhlanED0WKeAhSKLDoB3+Cr0x4VmksxeST5vwo7NkBfHhiJ26ewgpD3RTJsJoP2t7fP3ngbCgApdMbmCj2dNzv76nmOsMSoaElIhUiNe0xt52LQjkDS9+dqcxsbXmxxMrK792KgMWEYcpVvJj+rmywIPLqzx410fHnrf3ARGeevdFxc0CdwXNQn6R01Uha0bgi9bd4ucaOYpi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 14:51, Swaraj Gaikwad wrote:
> I agree that we can simplify this. I think !preemptible() would be
> the most descriptive choice here, as it directly expresses the
> constraint, we cannot take a sleeping lock when preemption is
> disabled.
> The updated check would be:
>     if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
> 
> I'll send a v2 with this change unless there are objections.

I think it's the best solution for now, so please do. We can change it back
later with sheaves, as Hao Li pointed out. It will limit PREEMPT_RT
kmalloc_nolock() for now. Steven explained to me it's the tracepoints
disabling preemption, but that will be also improved soon:

https://lore.kernel.org/all/20251219120607.7371034e@gandalf.local.home/


> Swaraj


