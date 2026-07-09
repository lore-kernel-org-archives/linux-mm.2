Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B009C4450F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3546B008C; Thu,  9 Jul 2026 04:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2641B6B0092; Thu,  9 Jul 2026 04:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179F96B009D; Thu,  9 Jul 2026 04:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9A6D6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:53:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 807778DEBA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:53:27 +0000 (UTC)
X-FDA: 84968624454.28.63B8F00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B753740007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:53:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lho/GWYk";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783587205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSpS/PyLHRyxppurqsi8ogug4ks/KZBHQbV+umcH6ws=;
	b=efMJvB420qBvsRoPTrFRc3Y4lihEdjeDBGioj6o7/RpiHo2aprPkiDbD7+Fxh2bloyFKcM
	gbe5OVzUD8FzI4FZEoJBQikz3/BR9z+teZSEVsI+hFtDgwliubZed0qZaJDC4A/OJQ+f8L
	8rv9HJj5O9t2mpzQs1gvMo0EvHixoBo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lho/GWYk";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783587205;
	b=2x1NCrdw9hTgwG0vf+32m5fg+g4tz2lbvtqFFIFZlKTRPrRYbSU7fSFj0gwqBELYbnPYTx
	H8rxp/648qIvbwN+WPne2Xg+SdoZhAH6LB6KqS+pzS4bBJ+6w4PJmaaBNz83F6Fio9GQpl
	I9S7VophjN90YWRpzGXITcjmaSRu9hI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F014C43610;
	Thu,  9 Jul 2026 08:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA571F000E9;
	Thu,  9 Jul 2026 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783587204;
	bh=iSpS/PyLHRyxppurqsi8ogug4ks/KZBHQbV+umcH6ws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Lho/GWYkGrBHkMfmwLwfv6NqJTWcb2ohNsjvFDssYybPnjyq1AUnoIPuYYFMlkVDD
	 UUv6gqkbIUr9IKAN5hjIPhC6yCV8ikXP6AUTCCKUXwZsCFHKaRJpcqJzP+b73S0qH+
	 4jPOVLQ2c4oqHEh4bQ2LAmUK3X03ZdiCsagawrCScneU+XH4EIDuyBGz/oh2aCZ0iO
	 UtcHvWMfGOgxnpMnGxqhBKfv2a0blF9c5cjYNrtZ7FwTvb6oPwk/C02e3wi9fKrAcQ
	 usrunzTQ0/YoAclMdQYUGmKZglio6NbMCHM5LgvfmVTjv0yjhKMPjX+0Ji2bwEy12o
	 kZwrmxIvA8ovg==
Message-ID: <1cf4efb5-1876-482e-8a92-a211570e91c8@kernel.org>
Date: Thu, 9 Jul 2026 10:53:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 2/2] mm/ksm: Use precise linear_page_index instead
 of the whole address space
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260709111055267XMDer8X5AKmOhy46TRjwa@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709111055267XMDer8X5AKmOhy46TRjwa@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B753740007
X-Stat-Signature: xu7adkwac8gcj66wwuhcfs1b6fe3zkij
X-HE-Tag: 1783587205-743984
X-HE-Meta: U2FsdGVkX18un16w5D5pwQSJjAHVjq8T+bIn5jvh9WpOJgsYUixhW3MIl9+6CtttgKakdr2tjjv2g09EONhXc6+1NQFlZpvyW6MCwPyNQC7wtFN2BHtNgi3grJmDYkPYxEEDD79rE0YDKV1DW4w/EjRw2299rxeJSvnrtjH7WNA6A1HGwPJagG4V1R4mDQ6cq35rqPnHv1vwZzrsPn40Dnq+Cxg9JFn32vcObK83MfNXsapJ2woE6TfmD0bw35xKB5rhtaapDpdD/QI6dlKgvUtgLdLTPuvZvY3o7vb86gCKMdwQv1OB5YtL2RF8yjlkoEIfkfdHku7HRmZpg5aGNIM2HheOo5FpZ6qcGdfAA4v2v6RrcNjp6jkXUbUzpUKDo6v2UICF3q8O5NS5qIHV5OqCc+dIAzVkelujPhq7FzTZn6brSlx0xvfvdg9MN+CnAWDP+uXyS4QjemoPG6Vgme0iD6t6CBlnJj5jlSQCgugz4By6x96xzyjiMA4oUJH7n74L+ho5jnJAsxRnmsBUAnPgTkNW+F4L8xsGH5bO/kVIywA+6Dn4oQtvtKhZHeD0vFHADmMdBGLmo5ariez4LOzpiWHjxQYrBqx4EtkJ8MJOD9Vg6hRWalBNyd46mUpDdzI8Uy2yktpkNirIAR0+7EZP0HuiapvHVy6fVZs/BFv7asu72VXWjyWBwuBg4IHYlFTvtBseIIx0jsPCOLXCBKtrFIs8PU2owirzjDbKrrM0vbGf2YSYqRv300LkgDJHYfRIRtAOt9/i2SJmfSupJIEDl2FQplk60KXTZKA16t+S1S4xKaXF0SBdjBD+tC6y63thzZVjlDpe0O/OO0vCMryCzIWNXnZk5z/b5vwPvOpdhbm+5E/muCae+a9nlWqh+/j8OzK9PBngwDdv25eArOlmOJG905Eu6Vagqhj4azYqNejeET5dk/EAz2VsFrZT2C4qhnAgdqOjX9mjtgA
 lzhpd6Zc
 EXEgCfKnjAdFfSSDjrB0Xupz7FOkaNrFDWZ+bZQRQizMUvhb5mBKF/1AmaVXCtljmchY4u5K5nDVDhcbqVaiEIBOCbK5v2h5+nA2GquL/JZymjt9E9jYUrLPf5GlZYOZX44cBs8QrZZtgIvDzIVpHpyJSusrpdtG4vHEaU5PkHKOtazRc/Z7vPzP2/fiKnCiuh8U2oxHhpCCExrGFxS9nEjZ+ZOeu/3FRnmUoayXAzX2B6Z1bNKsrpOCtL7VWTgqiMsoSA8sOMC8bTfqkX2iItZ7jGYHeXNLWeUIJ4aMQNhkSICmFgfCaNffFRkr1jzciQenU7/V6Q4dgKf5z/FQ9zyWzlxQFQ2VPf1DNYU9LKZ7GKVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 05:10, xu.xin16@zte.com.cn wrote:
>>> From: xu xin <xu.xin16@zte.com.cn>
>>>
>>> Since an earlier commit introduced the linear_page_index to struct
>>> ksm_rmap_item[1], allowing for optimizing the RMAP walk, we can use it
>>> to locate more precisely all processes that hit the KSM page, which will
>>> decrease a lot of unvalid iterations.
>>
>> It's awkward to reference a commit by a mailing list link. The other patch is
>> not upstream yet. Best to wait for that to go in first, so you can properly
>> reference the commit.
> 
> Ok, I'm going to resend this after that referenced patch is upstream.

Alternatively, just mention that we now have linear_page_index available that we
can use here, without referring to the other patch/commit.

That would probably be cleanest.

-- 
Cheers,

David

