Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A56FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499186B0005; Wed, 21 Jan 2026 09:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C5E6B0088; Wed, 21 Jan 2026 09:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAE26B0089; Wed, 21 Jan 2026 09:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3806B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:22:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9FD7D2841
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:22:13 +0000 (UTC)
X-FDA: 84356185746.09.C83C0B2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E12F40008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:22:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ysbgqLyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pRX4TWzK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ysbgqLyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pRX4TWzK;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769005331; a=rsa-sha256;
	cv=none;
	b=VEH6/YEnuefCM0+/FdY8fsLyE/7sJ0YXzKJIH/uTDC/WRx3FeEdoGPg/PmtL4hWPUQeF7O
	IAbVMtnwglyVSmuc+glUdsMQBNvinHORv2/BNWkilN9jfmJIW8yR0rtF9OPrQAODVjwIhX
	k4xLZsZYjY2wMp5vsrrP12I+sSGucIM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ysbgqLyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pRX4TWzK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ysbgqLyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pRX4TWzK;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769005331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+yin5yG1LXvKg7jj+26aW4ppEi8musD0t2dIbcTZus=;
	b=PGJzb4rSaiCLZoAoKprZTRVaRIuszk/idsk1+lE1wWVNGIyeqNrU3oCLduRa8k0gEKtQFZ
	Ni+sMGVBFgQnxyGuDxnuN/aAfMGbyCxj144HlzZruxrIpOrjiv41tnjlBCEPyC1/6WKH6f
	H814kzAUSfPme5PD9qPOONb1Ys1j9dA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 624093368F;
	Wed, 21 Jan 2026 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769005329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z+yin5yG1LXvKg7jj+26aW4ppEi8musD0t2dIbcTZus=;
	b=ysbgqLyhDSZoiZyX7wl331QMeBUA6+9OdXN9ovdPcBDSeXlQhQhzVhotZW72DAAalk0TUz
	Ni0CPYSsObtMfCHQyNSpRzfjw5ouhojem7m5eK521nPh7WVNNK58XaVl6LVEp20Kg3zQeq
	PfvYnF7gvk4YNYST8KE/yl4dVORLVws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769005329;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z+yin5yG1LXvKg7jj+26aW4ppEi8musD0t2dIbcTZus=;
	b=pRX4TWzKrBLCIaq/rke8r9QzgvXWDj8SJsuGMhKNfnPn9KZFaFkL2gqjDqbfiSRRwpi9En
	BYCSE4kHlOjzymAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769005329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z+yin5yG1LXvKg7jj+26aW4ppEi8musD0t2dIbcTZus=;
	b=ysbgqLyhDSZoiZyX7wl331QMeBUA6+9OdXN9ovdPcBDSeXlQhQhzVhotZW72DAAalk0TUz
	Ni0CPYSsObtMfCHQyNSpRzfjw5ouhojem7m5eK521nPh7WVNNK58XaVl6LVEp20Kg3zQeq
	PfvYnF7gvk4YNYST8KE/yl4dVORLVws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769005329;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z+yin5yG1LXvKg7jj+26aW4ppEi8musD0t2dIbcTZus=;
	b=pRX4TWzKrBLCIaq/rke8r9QzgvXWDj8SJsuGMhKNfnPn9KZFaFkL2gqjDqbfiSRRwpi9En
	BYCSE4kHlOjzymAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34D053EA63;
	Wed, 21 Jan 2026 14:22:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3Z4bCxHhcGmiZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 14:22:09 +0000
Message-ID: <c17d4413-1ffa-4d3e-8d87-0e7c2b022c16@suse.cz>
Date: Wed, 21 Jan 2026 15:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz>
 <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E12F40008
X-Stat-Signature: 8rom1oqfx1zympanx3ntwshaykbiqj7z
X-HE-Tag: 1769005331-865313
X-HE-Meta: U2FsdGVkX1+JIHsXFdu/PdcSWXNhCvmcfwYepgEoEDAXjUrIUGtjsCEB+Tn3BRW4WHu295SnVS21WhoWgSoIxv4FOQAiUOM07BLw/7v1XINSGGYEKoG4mTyeHrwbJhwy4TZsrNdxgOHx99ldie4Kow6BihrwWcf2E3LP5HXE9CIZesPGIb8gxOexzU3pQFOXvlmH62w3lLzPV77n1CD1/2rxGzF2KJ0BSvDyxDKKw9fDaOXnepDrSTmGmkeITkooPy9AZfnk/Eki6D1EjtHchZiNWZfFWTlmUUY7hy2fOLZzOOCvt3vZFqiY5/CLI4EqbHpzSH+SqZpTxawtVphCheWKHCgKZHenf4m+w1Cjwsj1UK6qFEoeBuu7SUqs5DtdJjS9/TV+O+X4KnR4OlebCcSKJdanC9Kl74TC6UBg1DLaPV8cPZroclq5E/Q/aYm/WOEgVFS27icGFvromFF6QkvTWUVnHE1L2LuQkCqv2XO1T3XlDOdhObUKFDh+lmqICz8vVlqTTgXTCydLPrSM+E42S5j1ikEBbsRfyE/nvBEGr6MMnfbV7fltsdinFZq076bBmukuqY5z8c8jk02J3a9nY9N08TNxV/uTa5cfT2SAEqWZRkA0RgmpzTg2CELvokqnpIwV5QKcK9gnByCVlIAHvlcINsz4GsFIHkVlYVTW38Q8FG58xc+gaRDnBXTO0Dj52V1APGa341Renhd5EGZWYD9vihpmSyQde6R1Y33z388MESA0HhHa4Qeroe8Ct+b25R4IoIK52Xa/IqKvDdJGaaI2/bI/fupSCb5YSriYY82L1Oqly2YOvqD/xbHV8B4+t2cv+kymmdhh8P59bpxd8ETfEkbN5MIuEZCVtyggjj/bExFA128W/gk36QUJhNLCt9jpy9mYzKtZMVwMzxME87oPWMJ+o35biC2Kfo0sUpG6pfFlDS+fcVi3tuwjVfwfLrM/lG6dd8v7sHV
 8JBICLPD
 P0FHPVX+24sP/FykgFiSp/7wZyJnqZLLrpU5DULkBmv9QRokQmYMsnWExc+WTRIUbFwzWlQENxjAbzokire5F57kT7DkLNXFsOqF4LgkhXAobxzvEKgiInhiqtY7dL5krzaW3ZeSqj1b6KibFbgWTJigySjyQcPxJdIQ7e1DFx9Grl5qe7rQKabiVQVUxU5OdV+BenkV1Q+CE5hi3N31JkSCx8VtIsLTz7w5b7b7AEOjBN2TCEFAwQuBmKUSDNhpn7rrOh/5+8K4znNchpBsyVOWtnQWSI4zwW7u3OcLl2eoFqe4wstHiI5rpC56gKi/8EVPD2YZZ94jc23HvJKkgOU9luCJv4Xlr19kWguMINRLJS67Uvu4e8uCceDSOlxkc9aNi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 23:25, Suren Baghdasaryan wrote:
> On Fri, Jan 16, 2026 at 2:40 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> We have removed the partial slab usage from allocation paths. Now remove
>> the whole config option and associated code.
>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> I did?

Hmm looks like you didn't. Wonder if I screwed up, or b4 did. Sorry about that.

> Well, if so, I missed some remaining mentions about cpu partial caches:
> - slub.c has several hits on "cpu partial" in the comments.
> - there is one hit on "put_cpu_partial" in slub.c in the comments.

Should be addressed later by [PATCH v3 18/21] slab: update overview
comments. I'll grep the result if anything is missing.

> Should we also update Documentation/ABI/testing/sysfs-kernel-slab to
> say that from now on cpu_partial control always reads 0?

Uh those weird files. Does anyone care? I'd do that separately as well...

> Once addressed, please feel free to keep my Reviewed-by.

Thanks!


