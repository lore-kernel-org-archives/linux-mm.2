Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6862B606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gZDEJiGi
Received: by kanga.kvack.org (Postfix)
	id 86EAD6B068B; Wed, 21 Oct 2026 05:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EEA6B068C; Wed, 21 Oct 2026 05:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734896B068D; Wed, 21 Oct 2026 05:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50A066B068B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:32:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66DA8404BA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:32:08 +0000 (UTC)
X-FDA: 85346117136.30.F5C1314
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A126340008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:32:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZDEJiGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792575126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBfPB6VG09nH9ZMSi9s+AuhJxAnfHm47tgfC2i8+kBg=;
	b=fzw1MaNTaF0Rv9eN/cx2q05zapw+XuqHsGCwj1Sr9Op+hsPmbQOaHTpL67fH2yMmoSULp8
	dzyIM5+atXnrGu7py73kOtf3VQgQNvBBZjgO/u/iq73Ty+B8bSPfujpsIsLlxU4Y7NCKRa
	xOokbkKXl6hSIY5CLkA/ZnERyUd/d+Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZDEJiGi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792575126;
	b=wGTGmd1ZIqeVkNmprVmTLyhLJiX8jzcrdEcsbJ2dX87gB7pk21RwZyg73AD2EeeMixksDw
	naz+8MB3sflJgHzrFoEyHViOSgRmd1dRymYTjjCDvVAOcoSeYzey+g2dUYPTbl/RFjwIaG
	IF9sS19H+TIcWL3MLHifGwbVLpGUPM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 070ED60052;
	Wed, 21 Oct 2026 09:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A074F1F000C9;
	Wed, 21 Oct 2026 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792575125;
	bh=QBfPB6VG09nH9ZMSi9s+AuhJxAnfHm47tgfC2i8+kBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gZDEJiGiy/W+SSFO1BQYcsSqY/klq/62RfPYVvYA3ujxlE9ctXqvA3k3EfVQJtt4S
	 j7sR5PEFVFNZp03AcUBVdxM1C2ro27eT+aQJw6gzbwEsuPMi7RK5LE8UMNsQLvQH8/
	 M1hX+mbFoojuJ8LqbivmexA+v4X0Qv2Qlw10uLnNkApo62qWQGbqI/YJaJDmuKEk2h
	 sgXEIHyQNXbXgKn/NrrwK0C50CsaSDL+59fX1HuEBUz5/DrFJ3bekgWgdVsCLnV6jP
	 dQT6JQ1tRp4Ue/v6Wc+CBW8M0KiPPlLGw0jhJkviAl/Hm94E/Qny4V3aHcK7KRslGC
	 hbC2NKJX7RmIA==
Message-ID: <e6ba0e36-c0b6-4cd0-b2fb-fc288468bce4@kernel.org>
Date: Wed, 21 Oct 2026 11:31:59 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory
 compaction
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 ziy@nvidia.com, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, zhaonanzhe@xiaomi.com, lipengfei28@xiaomi.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <11264869-00ad-44ea-b39c-a78347af0ee1@kernel.org>
 <20261021060059.2253219-1-zhangbo56@xiaomi.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261021060059.2253219-1-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A126340008
X-Stat-Signature: tdgjeunto7e1nsx5ouicpkxq6tin3jtc
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792575126-580872
X-HE-Meta: U2FsdGVkX19+12hk8NDG8iFav5nFkUZRfqAS46O5zjSLpjFC02GgwiTq8EAvU/ogCkoBEzSXb7O/XJzDtHVU0e3Vpnh3m9qSuDqxh0qRtXFZmUwQRUTual7hAC6SdzkBqS2U++zIAbLFNgZfGUdmVDgTFDWdFO0nmQK6qlBNz/RMc47d7UCQ+N0niyhQHw/YjNceW4YavryRyzmf3hx76SKv8XLGlR/BZtCLb2mSxQ1o7JRa/rKKwf4nVRsXd8TMa79zmBJo6WngkcfrsspNY6du/2GiOKliLqR6jlt6zJv45uTZC9P/1JuHJberD8wJBYem5etZ1LwTxLjv8CoUwxVXx9WkWMX21J7sisj4V3uxEOtVW8USU1zxpZ/URJ9wcRK0vxK0L3Nk9zjM+Lqqj3jTFdc0swwTdKg6oF/cXXzPgfnjncPwNfcbsrLAAwN7K3//n1D14yEzIq1kv/MHHZeZwjn7zEK7G7+EP1QIYNHDyWD1cdwvBl/nDPPKSUa/A9LASZfzsPF8kRALoq6qIzjQsT2qssS8ti4S3AQlCISJQfQ44LkQQX6M1iHsrctDssy9YsnQZGbY8jzaaOqBFFzGbIpeG1CbWy3mSADQSb1ouJLOakcToJX91Ynl6+SQzkVbpEMdd1pJr8WAaiN8pOW018BLdBtMeYa8IRyp9QJYMdtg16eZiF7joppghPmOGcRYSjiExM0T3ZE3nigL7bzbpG3ppNPWdRxKRn1O9r0blxEDu8H0g+/V1nB5wha7evvxGLa52Ibn0Zp4jMDliiFGO3kQrwBNJRJtkhs9SbpJU3iwF55ATt7Ad+VMndoN1qMMhjLSBENqUp7L0IOhaLdeY+0P3MjHGeKBHkOPgOMEUtd9prThO3aJeSvnMSBQcbuLEWIS+jwU4OwuLCNDbdh9Phar4ygKLN4SMyliIBJjEQroyus4RePX21zQaqaPgC/ZoChPWoCAGuDvuI2
 YmQACgUB
 VCIAgiJhCwTu2RsOws1orlBToIqjWCUSJWh3PUhiOT7kGJ5Y5Hj5aFUVA5ScfyEkOp1kUd2HazayxwiHlbV9lMSu4T+5rw4zGM4q8JEtlSxjc5HmNShrOWZUoJXj8usw9AvKxRkjZyghbTh+YZ22jbR3PP1pFyQNtR+eWui/i2bIEGEZtDx+jP6ztr8S680PObGntWciWhAtEsaLilbgIGK13r48AF8oGKQTqa6IHM5eerLxmE2ssHVyv0HxWSqTbt8xd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 08:00, Bo Zhang wrote:
> On 10/20/26 16:52, Vlastimil Babka (SUSE) wrote:
>> Isn't using  struct compact_control clean enough? There's already many
>> fields like
>>     bool direct_compaction;         /* False from kcompactd or /proc/... */
>>     bool proactive_compaction;      /* kcompactd proactive compaction */
>>
>> Who says is_via_compact_memory() cannot be refactored into something using
>> these kinds of fields and not 'order' being -1, which could be then used as
>> the target order.
> 
> Thanks, that's a much cleaner direction than reading huge_anon_orders_always
> and would also address the race I raised in the second open question.
> 
> I tried to work out what it takes, and ran into one thing I'd like your
> opinion on before committing to an approach.

I'm not going to answer your LLM's questions for you.


