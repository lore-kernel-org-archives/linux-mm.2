Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05793CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FB28E000C; Tue, 30 Sep 2025 06:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616F88E0002; Tue, 30 Sep 2025 06:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D7E8E000C; Tue, 30 Sep 2025 06:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 394788E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:13:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05E8313B6A7
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:13:53 +0000 (UTC)
X-FDA: 83945505546.01.8449651
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id A65794000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:13:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGFe6kd7;
	spf=pass (imf12.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTdj2x1duI0XVbTi8RKgEoXVAmA0mcipGmJv/HdPjMU=;
	b=yB/rY9U9to8FkrUPpwcuSDsZvBwn5iz3Nr2J0DkhWW8uF82fZOLJkZ8HXxBliAfGzbpE5z
	i+Ca3KO9VvYXvJw6QWF5ILqbtGT1fQ/DmGAjtIM11HYisxKKNFcBzuJVNNpNOVBGKm3Qfs
	haFyVyXMSTmGfTTvO2NRiVkDcVvPS4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227230; a=rsa-sha256;
	cv=none;
	b=Tb8od35M4VuD7DCE7jyXrtwkOjIaBP19I0fEELc0nN65z53E8vrBh+Xo4dbWyENJeFGTUj
	/10actaeVdry0dWHlljK5Au7F7mVo15NQO+CikWJ6iRFKaAAALciW2ICQDsIUkRG66POiV
	+xpc9mIMvygAaXKklvFZvArmyv8Uy+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iGFe6kd7;
	spf=pass (imf12.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tTdj2x1duI0XVbTi8RKgEoXVAmA0mcipGmJv/HdPjMU=;
	b=iGFe6kd7ke4YbtqdwLK3TW1KWtySUixbuHDqY4VI3uUwZUMNtVzz4eYGojWc9TEuRSyA4C
	tWQ6Bxg7AtvK2x2eXuSqbeq3CqHjAe5T9xZ2ZAwhw2L7aruxLEzeAwcmsdMWgTvD1b7p1H
	BUfzOucVmm8snHyiUiyBcRLwATTECoo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-sbC5a23XOxyOfjV3xZYSJA-1; Tue, 30 Sep 2025 06:13:48 -0400
X-MC-Unique: sbC5a23XOxyOfjV3xZYSJA-1
X-Mimecast-MFC-AGG-ID: sbC5a23XOxyOfjV3xZYSJA_1759227227
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3f384f10762so3695819f8f.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759227227; x=1759832027;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tTdj2x1duI0XVbTi8RKgEoXVAmA0mcipGmJv/HdPjMU=;
        b=YI2qJ1vEtp1wIc/PjzbVGWFeXxPmLvWcEFcTIUj8yUR/o4wTnfWXBFWHBoFUPNQMeV
         1zWUXtGhGsjrKyAOiL442btCQ/JLk9nO4183jQOk10dlgr5e46Pm76fi7HexRwJ422e1
         ZOwzfNkIHXIgUn47Zp7rhhVvg/CFx28Gv/Jqrm/XoTnVApVyp3ivYvXt6ufrD8cnVrLw
         gLXI/NM8KJxwuQ+zdtepKZiwGu93ZK+j+7C6+JB9PPjtjxfBZSX9xCbsBIKkwjCnxziQ
         G7JBDci3htfTxGBEXJ1pppqd/dmQDqqmrYVpthqz5I8nCFe0dNRGIohSkPxvo778cCdk
         XL7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkzlol1DdIdTx4ahjfw/LzD2+Ph/c4uza6CrjeF+ipR4PNt5B88oF2ow+l/UeO7tP9RnPPp+4caA==@kvack.org
X-Gm-Message-State: AOJu0Yz9BG+6/GKexs5WdNEqvF7I3aIx+cgcR8ur8uNNwiSEkmGKKAnI
	JBl2dchd+F2RxCQnrs+59PlM4Fn1toFaoimH9N6dYf1RJTTPjbPe3tyUdrEo7sk68xCrwV7xEo3
	tYXTtKtwA/hv2iYLL4d3cfHfZM7E1wYhK8DNZW1rD4ShD3/4XSk4y
X-Gm-Gg: ASbGncteLIxlL9NRKUUYEHiFV6sGes9N15HzPJnVT4LsJ0QrMyQ2Gor9tHBR2gyRoMy
	6j7oDoJN+hb+/vHm58SABbf9APiZP0bUNegjjKrCHMF5EtDgkOWKEpZCLyiwQm5tOU1949oS3sw
	bIzz/2ZosRhuOldHP7mrHlJy+AE8lgiAgDTdMYUnWF4Q8JXAalXT7Y2GzVUxhcl41NcldumDUdY
	w/X1+yl0WeCmyHZvRPsVFsNVHu9AD65Vt6giZdSIsWIFtj0jxrOhq2EUnTW7VQ4KWyojc/Q4Gll
	QpUoM95m/Kp+w0AdbDqs6tkiYPjZpydk27DBiIbqYDu3DHkhsTXrw1Xm/PUjdxllgnemqm1WRT9
	8dEiRVExhGstycODndA==
X-Received: by 2002:adf:a3c9:0:b0:410:3a4f:12c8 with SMTP id ffacd0b85a97d-4103a4f171dmr13075687f8f.20.1759227227232;
        Tue, 30 Sep 2025 03:13:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwYnflRxUnEHcREPjaWRJh+kaEETsmLI3R09O6JWD4FyGDD7s6VNm2WmKwFMqpdqp5jv1+sw==
X-Received: by 2002:adf:a3c9:0:b0:410:3a4f:12c8 with SMTP id ffacd0b85a97d-4103a4f171dmr13075665f8f.20.1759227226729;
        Tue, 30 Sep 2025 03:13:46 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603356sm22452426f8f.30.2025.09.30.03.13.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:13:46 -0700 (PDT)
Message-ID: <0dc3f975-c769-4a78-9211-80869509cfd2@redhat.com>
Date: Tue, 30 Sep 2025 12:13:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 Mina Almasry <almasrymina@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Jakub Kicinski <kuba@kernel.org>, Helge Deller <deller@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20250926113841.376461-1-toke@redhat.com>
 <CAHS8izMsRq4tfx8603R3HLKPYGqEsLqvPH8qfENFnzeB5Ja8AA@mail.gmail.com>
 <873484o02h.fsf@toke.dk>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <873484o02h.fsf@toke.dk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k6IJFvjs3ANul2YsIxTJmvAvcAjZqvxTHOIPa6joYcA_1759227227
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A65794000A
X-Stat-Signature: dqrh3wc9z195dmx85bhdfnqotqnbchs9
X-Rspam-User: 
X-HE-Tag: 1759227230-551682
X-HE-Meta: U2FsdGVkX18Z+EteDZCkSblWAhadPKwZGtDXMgZUGaFaW9bRNG5mkEKkY56A8LxxNqNX8lRp0rnjQseRUWWcTg7MORsI1l7oqJNhJm+Fj4SdhpssLVrNmmz8z5jEVJi5JFNNtwVrz3WRlXV3UCQBhScgPnRwPyaXhFBrRXiX2wusTVga2KLRKZFRV2LPmM5IImx3N4YdyFBVUDwXKkaAXJPPbsU3ZLC6CgHU3oJBRE8Mfdxxu6d8zpjK50v7bnXmeBid4Tc+4v3LeiZPGVVo1z/TUdWorFTinCmhX5nF3+BBS+m4pF/MdAXuSqa0ZDp8yEg/2Fk3ZP3FqMBemQcNUUwtMmzBEv0gxw3eU6agAyWmQXvotmjBih86VPRCM8IC3xr+MXCuasOFztgBjoy90s4fvS4XW41458h8YuquFBXtPjrd3xbAg7m7uyHQLZRVVc05AcpUke4fjtkkbkl75rL+N1a1Li0RMt7fSxHEU6GasuwaERBKkb4o4f4wq4VBiOVS84LnGdKSKSbU0Mmacn+f+n9F0RxWkSCwHr17XupIqT5O62OTICRYkDHfcotNOhkI3isJbAs2N+Q2rFBGkNVz5UbEAPouvPdS/NAfb+migsKttangdhbCos/AYR7sSbEgesrGXXN4hY73ODvH6cKyLp4K/oubnBH0kLm53gdlrBzDGgaNPKBbdZakQmrEaULMU01kff0tQDPsT5gPLSZbdEK2bqQ9zhKwKc3NtZH/NEHclrkiXaha2H35NCyA3b3+0PmLJYORFEL2HaZ+jltLGYSyQODm+83/oKF5iKRAVlN8eWwX9ffp0l0M2Ux2Vf8PSHXPkVuJnn/18bqVAF+LhYFwUpyCFZT3qpcIIPpeSnPEqk2VTPuwQqoUov2/sVvQO5r87xoN5+oxZ09xsohLAvW2AZZezLaYes9IS+Lc2wXNVYHFsU2yUPMyOeflWacjxj+wSTD7TDjO3HF
 ImSrm7qy
 5MBHcfrW0JnbPQ8+jPZxrmVsO1PTAbw4P/QToDIOd35XlDgmRoyIE9yNbqI7+PYT9qobiDxGM3Q0LR8bmSKy6lxErsF9k6JoLvZanKp4nGmXeXNgAafOv4ncnZjsrfGIIWlaRI7msHeW5OLzCNIwj9TtcgNpbvqLq9VPW5tECnmIbk1/30Jn8+P1xct/ICTAtDvZ7J6QI9REwrXdBk9yh8QHKCZ8Uw61Gzchb1RAeId7hMwHyA49tAHr92W2G0uF+LLGgdT+aXCgko9Aq/rdzTEkf6rYz281Y4LLmKbKofIcOsEf8Ue0eyvK8+4N4GMIjQXfiZKBpjVAxtMY6IgXY7tKViD00ePaZnuWpj3UyYJkN45HfMH1c8x8caRUo8BsNM2ccfmbUeMeTBrBJ6n43PAaH17p0qVDijkitTR4ivwhflpbGBYOYJ0+/iGgG0pCb/WJQYsmHZmnINTUsuKUnWZKkShL/mABU0qjIts+eisp9JhhKTFA/AnZ4AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 9:45 AM, Toke Høiland-Jørgensen wrote:
> Mina Almasry <almasrymina@google.com> writes:
>> On Fri, Sep 26, 2025 at 4:40 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>
>>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
>>> boot on his 32-bit parisc machine. The cause of this is the mask is set
>>> too wide, so the page_pool_page_is_pp() incurs false positives which
>>> crashes the machine.
>>>
>>> Just disabling the check in page_pool_is_pp() will lead to the page_pool
>>> code itself malfunctioning; so instead of doing this, this patch changes
>>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>>> pointers for page_pool-tagged pages.
>>>
>>> The fix relies on the kernel pointers that alias with the pp_magic field
>>> always being above PAGE_OFFSET. With this assumption, we can use the
>>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>>
>>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>>> constant, nor on it always being >0, we fall back to disabling the
>>> dma_index storage when there are no bits available. This leaves us in
>>> the situation we were in before the patch in the Fixes tag, but only on
>>> a subset of architecture configurations. This seems to be the best we
>>> can do until the transition to page types in complete for page_pool
>>> pages.
>>>
>>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>> Sorry for the delay on getting this out. I have only compile-tested it,
>>> since I don't have any hardware that triggers the original bug. Helge, I'm
>>> hoping you can take it for a spin?
>>>
>>>  include/linux/mm.h   | 18 +++++------
>>>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>>>  2 files changed, 62 insertions(+), 32 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 1ae97a0b8ec7..28541cb40f69 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>>>   * since this value becomes part of PP_SIGNATURE; meaning we can just use the
>>>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA), and the
>>>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_DELTA is
>>> - * 0, we make sure that we leave the two topmost bits empty, as that guarantees
>>> - * we won't mistake a valid kernel pointer for a value we set, regardless of the
>>> - * VMSPLIT setting.
>>> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that value is
>>> + * known at compile-time.
>>>   *
>>> - * Altogether, this means that the number of bits available is constrained by
>>> - * the size of an unsigned long (at the upper end, subtracting two bits per the
>>> - * above), and the definition of PP_SIGNATURE (with or without
>>> - * POISON_POINTER_DELTA).
>>> + * If the value of PAGE_OFFSET is not known at compile time, or if it is too
>>> + * small to leave some bits available above PP_SIGNATURE, we define the number
>>> + * of bits to be 0, which turns off the DMA index tracking altogether (see
>>> + * page_pool_register_dma_index()).
>>>   */
>>>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DELTA))
>>>  #if POISON_POINTER_DELTA > 0
>>> @@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>>>   */
>>>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_INDEX_SHIFT)
>>>  #else
>>> -/* Always leave out the topmost two; see above. */
>>> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
>>> +/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
>>> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE_OFFSET > PP_SIGNATURE) ? \
>>> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT) : 0)
>>
>> Do you have to watch out for an underflow of __ffs(PAGE_OFFSET) -
>> PP_DMA_INDEX_SHIFT (at which point we'll presumably use 32 here
>> instead of the expected 0)? Or is that guaranteed to be positive for
>> some reason I'm not immediately grasping.
> 
> That's what the 'PAGE_OFFSET > PP_SIGNATURE' in the ternary operator is
> for. I'm assuming that PAGE_OFFSET is always a "round" number (e.g.,
> 0xc0000000), in which case that condition should be sufficient, no?

IDK if such assumption is obviously true. I think it would be safer to
somehow express it with a build time constraint.

/P


