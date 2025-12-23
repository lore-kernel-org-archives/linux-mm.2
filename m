Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A22E6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 19:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9E66B0098; Tue, 23 Dec 2025 14:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1976B0099; Tue, 23 Dec 2025 14:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9966B009B; Tue, 23 Dec 2025 14:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADE5C6B0098
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:58:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 605B558FE6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:58:08 +0000 (UTC)
X-FDA: 84251797056.27.413E95F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 76CB416000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:58:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/rehiH6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766519886; a=rsa-sha256;
	cv=none;
	b=zfMzEh1xx4V0OpJVEZdgKTZ1tyYfuQK44iWErgN5Kj69P/8bHTrK0ArjsmdH27e8RwXUfB
	QaBRC6bMow/nR1jGgZmLeaFjhb4YU5x7F1RVH5/qb6hDAkMKXuP2jG2IMlEvpCsVSw74Ua
	PxNYkI586i83Z3Cw5ERWqU8s8Z46Dys=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="F/rehiH6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766519886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypZ04WzUZcjv8chBde4W5E+WNGEjNP6J/99avXKgkYQ=;
	b=jdfcB+1jdTFk+yjeXu71DRNnTIRJ/WgcD+/E679LRRusSt3m6SKB8mpaW7AF0Av+y5ixFs
	GOTOXHCOv69llPFYeBLdFMQB/81C8/0lQ1S8wAp1I8LfX2fZqZyDUbpGv3F40ljEemZ9qr
	BZiHUDtVjSl2lavyEE6f8/9Ee4Bu6Wo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766519884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypZ04WzUZcjv8chBde4W5E+WNGEjNP6J/99avXKgkYQ=;
	b=F/rehiH61vSusu5N50yrYz2fWEYreVEnoYWl0HxPAq9CqRjLcZRmKlbE5W8REAHNOb2H3P
	JZj/AH9T/SKZl7ECOLFegKmiz/e2XduXJkbr+IhEghYpt4nxLF51Bt7T4190/v1o83Vndq
	pLf0wFHrtWKTJ1B7ZS8E+Rdi/mwQxCE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,  bpf
 <bpf@vger.kernel.org>,  linux-mm <linux-mm@kvack.org>,  LKML
 <linux-kernel@vger.kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Daniel Borkmann
 <daniel@iogearbox.net>,  Shakeel Butt <shakeel.butt@linux.dev>,  Michal
 Hocko <mhocko@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
In-Reply-To: <CAADnVQLAFav8czDjCYPyjDK6Bj7X_L70WQ0eSFTwvsxxEXDzCw@mail.gmail.com>
	(Alexei Starovoitov's message of "Tue, 23 Dec 2025 09:25:35 -1000")
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
	<CAADnVQLAFav8czDjCYPyjDK6Bj7X_L70WQ0eSFTwvsxxEXDzCw@mail.gmail.com>
Date: Tue, 23 Dec 2025 11:57:53 -0800
Message-ID: <875x9xt1ha.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 76CB416000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 876wfigg99s5tsfjefghpfghbqzrr48b
X-Rspam-User: 
X-HE-Tag: 1766519886-205930
X-HE-Meta: U2FsdGVkX1/UE8CBTsq/cfzZGLXuD292gmqDR6+0lwxfNur/skXra7ltyCFrSrgLeju9WfI+NYBISmG7mnKtrskSGB7bvg6/LHt0vrYb63pY/1vOImG3SPeGd4vMT/HSPBtXS6E4/1a4CxwLZcFoH5PebDL2djRiduKC7c9ykwDran1k2ar0mQHW9s6j4ZNoA6phVPqCtOgYqnTunbA3HQKMIYL744O4/rx3iFtoNy4eKXs6vJs/STFiI9zmPPH/CnyRFvRTquMsyuhMA6GD72C3jt4AlPRMWYFoEvr+8GGUF/MjAaEs+XIiMH47I/pX4nqezyhXLeCNtRgA5RuRkqLHJuvdY9ORIzAZScGdvdgqfDZThhSuPmy1khSdnEj36Wk+ARAGSCTHOFw1YfMZMijpl6H+6rr7AeXOXIx2cKHZK2p932AaXCoYFQy73GfvLMrSHW9lyo1HjUbQePQFl/2scLu1S+CUiXVnZskjcFMlZDr+hspsLYxHedV2+umhjthUkApgRwC3KVlGOHm+P3w8i0T2qd8nGFp/fYkMBnKDPZQKuSaKCZHESPFFGkwjLkdi/JyAu4KErG8vsqayLXdB2KruFphtQXFH5jg74fiw8472oormuJ3utCdPSeVeEQn1+J4x+/v5j27P+Sv2qZh3b9skcMR1CMgh+jQ8QMB/DWRVsdUeY60Xlq9B9WDGZ5LccNFxP1+2VdARDS4p/aNDYWgd8edg2BAjcWWaVnlbxloBNij3o6GJNIr/jnUrmAeiBgldzowoCu6qbox24muqgNUM7fZWgzlXoGP8APrFrP16lAuRfyXIZ9rD/5cCP0XH7TxsJEAGvT1DPCyIDXlpkLvCaxuKbXuFtuknjYWnUDusaL05uaYfcpaD9brtnuVjODpkxjQ7Gs+gh5aQYdFDzaU9jlF66slN21vJf3FkwoiQbeII3lqTgBEMQRMAUQVV5T9yPBg0TrE4Q5S
 dLbMEwjS
 h0NkrjI0JQ2oAOQg6us/Za0DID2VlC8EAg2w1Gem42Gkrf7PRc7TNFmMnvvYugGn4mPgtgKVZoYI+X9aie/rHwvAM+sWoytY/FPL+x2NGWj5xrDzR5whgk3KPyBrYjg64w8EMx/k3IghFzkqAp2myx0IgVR8toOJz/CyVUE2SZTFyZIeU1FtZpymy+5FGV5hbgFOtiQDa/Ao8E/C3g8Fxfyjo6CSD+ObP8TxJdvJqVY3pvgaXIRPEr6DhxIgLtJxFPhjpgBViz166UipfFS2wDOAjLAGvjLmius32PTmXyrKPJAtWGJ/Db9Z/75vmXxs+5mYf6SEGIolScWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Mon, Dec 22, 2025 at 6:42=E2=80=AFPM Roman Gushchin <roman.gushchin@li=
nux.dev> wrote:
>>
>> Introduce kfuncs to simplify the access to the memcg data.
>> These kfuncs can be used to accelerate monitoring use cases and
>> for implementing custom OOM policies once BPF OOM is landed.
>>
>> This patchset was separated out from the BPF OOM patchset to simplify
>> the logistics and accelerate the landing of the part which is useful
>> by itself. No functional changes since BPF OOM v2.
>>
>> v4:
>>   - refactored memcg vm event and stat item idx checks (by Alexei)
>
> Applied yesterday.

Thank you!

> pw-bot seems to be completely broken. No notifications for the last few d=
ays.

Yep, also there were some infra issues in the ci output... Something
about git being unavailable.

