Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5E8CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800646B0098; Fri, 16 Oct 2026 03:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D09B6B0099; Fri, 16 Oct 2026 03:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E79D6B009B; Fri, 16 Oct 2026 03:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48AB56B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:41:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A409C120319
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:41:34 +0000 (UTC)
X-FDA: 85327694508.12.EFCC0A1
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id CDCCEC0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:41:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QXArVKTk;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792136492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOTRRbTqkUt5QQM9REwuEs6V4HIikB0VLV6DTKCbGLE=;
	b=n4NEjOluejrivuFJ5bv+wOEoydxPhtriodkVOlRUCvp1jDyswfyfwJ3aQQJvl2T0DEiKjt
	X/HiBHDRYNU28GoeLL4t3KmBK2bz7nIKWsL1LI6FfJiTZZzzqb3OUBkXXxFYSJbk7FjdxZ
	BrNyKYOR6RLlIu8e6rj5wKJVxqx+bxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792136492;
	b=jxmjKS8Q5gypHVK9myKgeJwAm7y4EcBcVWNM/aen7DnHCPqzUN6iFynQsmlCz72ZR2rCrI
	Z5a8uSv3LMAuFW5/VIseEj6OFvlxoKpwFFnpS23DFoQAIuSgqXwX8q3O4nQKatbjhqlSYu
	5Q4G0NGAH3pLglAR2P9ZZ9wOrOd53jw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QXArVKTk;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48de72fc832so944889f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792136491; x=1792741291; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TOTRRbTqkUt5QQM9REwuEs6V4HIikB0VLV6DTKCbGLE=;
        b=QXArVKTkkVoGD115EMJlsBhWWvz5G5/YP1iynffIGJnCEmZRdrpj9NNc5XuzpbBkP1
         46tEExYoFRyo7J3tVfJ4MlRCnFXLDRq/QPJjjVwsgiu6RR5Z+PayhPGmAYQxMwadcvWW
         6hX2XAA3UZOCLcwGl5nzUqVZLoTqjtJs9/en0rzQpoO9bdZFXH2mnkx8/vbdsxAijBXQ
         XicX0a4qN2jxuYNCQsTwFPR1l4GyV1n76cZ7oxda8UJ9PLAdEl9CL2dv6f6L00sjk0u3
         aURkZQ3PxAfxCDLs7ml1fcVmEIOfZ9KdjZ3YFiMmj6uF7GSP5zvQAomsTsvgAEq/8aYl
         naIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792136491; x=1792741291;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TOTRRbTqkUt5QQM9REwuEs6V4HIikB0VLV6DTKCbGLE=;
        b=JwA5dJ4wfnjbzbQcrsO0iZ5Tnlx8lrLufy87jLt2F4zisqMmopBtAZoM6KcN8HwCmr
         uo0NwMi7420BKbnpdQAHQ6/YOM6MnWY4gzD5U3t5Pv+P+230LP10mbOa2wRcjOR6Sn/3
         0MEXMV4EaAcHrZq+sJaN99S52rcYsbZNNEdEUfeSoK3ZjKXMLy0yAzlrv66eW3A5kBiO
         r0FpvwMgSXgcJnSBoOF3GcQfjtGcRaONtwj/Biu6VAfxMLHFYmXwoyEThSbgmaznka2z
         Yd8hsmCTMcKNwwVTv99Uxt7xqBL9Y1fSfG/xA9NTST3OkO7wujTnpwMowdwdeqS2uw0a
         aT+Q==
X-Gm-Message-State: AFq9FYKFzm5EcKRELdxfDxN3d/G+L7rZ0I+njN//1COkCkPlYxj+9Rhx
	vk+W/aoNhv7eTkLH0EU7rQXtiV3+ZLwS7cIEEB1pN5fr06Ht1+CNIEJv
X-Gm-Gg: AYBFou3ciybt2gfe7DSRG2qBkMkWzyIQ20RIFayKCPxJfaunsLZhUpt/V9MCRhOEcUM
	O1ijWR/DF18OVs+U28VT1e1hH0nNO675s4VQUvFwe1JZ3cPGVw0n1RoQJJM3HLsC7dfVDiBx6Kd
	fdKqVBzxZ7Ne39WkyXC9/8t23tDIqsVhy0imLKZyHqPj3BY72s8UP4KLapwX8bF6rJekrm3EtH+
	cEL9uHlbnK5VwiWa9eYm4ur3BFjTSsOklYPQ5Jfs7EakmagW1gWSXl2v+zdsG5yXMr8maOm0xEM
	a4r0CYdSj8EelNnU0ZPnvb3wBEdGwrOBb7Z8LkEwbYYVINKj4aSVMj9/uLjYZ+xAJa9Fgv+SozT
	FEXYONrJCUNDKLEw+MurbTwUyUchcW2MXyilETJ6wscZHc1nVpiYRxXFn3pTk5aZm5EDU1wTOcT
	s6ReWwZh6IrzcRlN/aqn6oj6+FUMvPs7MH+G/F6YtS/AlW34eGNPV9Wl0n8trgymFiRyiMjGG7Q
	4M3PGkVCoVEZxV2EudLa47rzs75FHvbgGkKTNWSv1ykQErU+8U=
X-Received: by 2002:a05:6000:178a:b0:48d:fd4d:7fbf with SMTP id ffacd0b85a97d-48dfd4d8272mr3048376f8f.4.1792136490979;
        Fri, 16 Oct 2026 00:41:30 -0700 (PDT)
Received: from [192.168.1.18] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd471a35sm2822036f8f.7.2026.10.16.00.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 00:41:30 -0700 (PDT)
Message-ID: <f5548d05-5aec-42d0-b9d9-c14fb575dec9@gmail.com>
Date: Fri, 16 Oct 2026 09:41:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vma: avoid spurious write locks when mm->mm_lock_seq
 overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>,
 stable@vger.kernel.org
References: <20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261015-fix-vma-lock-overflow-v1-1-01beb245d9da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CDCCEC0004
X-Stat-Signature: 9cmi7ps7obb41xd3hqk4g5xgm3p1ifch
X-HE-Tag: 1792136492-465074
X-HE-Meta: U2FsdGVkX1/QO1SYu9DM/hq1eq8S64xKcd5y9Qfm4f5Te2QbHodiFMscLXSM1nKqtGaQAWv2OgEnVRLM7GxLfAti7Pul1KVlqpod6VnYU2RGEgfvbeYjqaYYjgUC6ZTFQBcsaB0BknD0Uu6Ot3sEC/FcbT6nf6hEKYY+OzxILRClgQUWVrTTS+zRvakOYpmdRYyoZRd8LOp3E6m+Oj4YsRXXHhO318QDOhYEmWHVASxBXb6RWxZCxa8Scqp5N8w4LaIWtT2HPhJuw8aAsv2ZBc6w8XZgjYBvf/4vUcn6ukT//jWDigpV5iAKnqQ7yzXAETlPZ5NYdmujruIaTKZgrfNURbxWbzu5dMfJJRg78pEurlaUbf3W25jES1BGXXKNKpQZG/N+GflbYJ+0QH79TNUUa3QecNVt1UZ7lVTx0qaR0JCVmwyduwpCYDkEcTFKoZSMgBbugCeG3I2Wt7Bbz/uF9XrtxdP/B1z/NeWAnkviygStNNJEtTm9PUznKPYjoZ2uEqbaQcBbcvmyBSCMBpxHr8Ux7WacdZjjuJ3iJDFQUM5cq0HxfkZG2jjVxwmHn0ZABHxkDnLY+jFFYAxXDQZCnBckr59X9C7RY9PeoH1f7B0uMty/+iK45qlMk6vFuGzXi+uQUncbQdIxAUFimo5JO70nhXuzPBSceTt8UY8LG6T0zr2Jnt703j9uaWsJAbjZYkCBNVplat1rI+dmvzu3JXe0u5uMSyaZWOJnMfExZPHZunuImfgxYCn/JQKl9nsWSaprn1q4CW3oUKywznUXxMP2c2ftFiuogkpv+jnpvNtoMPKHLWGuU+38Y2b0DBewyolrqNbxELipyWWg83T71v7gfnI++qHCtZ4CgfHDumRRKil4r630+ipr2C55M9crqGiT164dHOqfyubnTsduPCO9fPZiU25qZP0pnERg9doJUXmge60TgMqXzy0kzpoEB7Wr0dJVvaD3fkn
 TATpIiNf
 5BIqA3xZI7f26xEnGweNhpylTryJKnj6qHQR8/dT1RATe9fYdeqV1eJdsIOEjtisApGCd3ClGxTY+Lk6UcpmsIso0CA72SrQeu0ei43SbQLeXF7ffHIRZvHsdje/5yw40baptqnZQv46X0pZUGZ+uhlN7iD8iPQN7Fc4We06GvdusnpchJA9AFclJs643apx2xIQOUJ4gK5Ul14/dDg3MuzphOXs6vf6Y1v/O/x5WjHukj46bKOcsAFwTksv3JZVTgjLFG3YpwPVHUFq0XQ94WIRfS56ykemR+nZbp7JELh+Cw0I0Bl4mxLY9X6LOUQ5SiOT2SLPfl4yk0mYW/Vk4nPxZSTVD8ty3hJXB/KkapahzXVbwyLUlnKxvIr4D7fwlM5tanPzVXIGQXwC/DM03cDAvnkVBNnb+wzpi2vBPxHAM3cWscsfmUIPtP+Rhw3hRgQgqc8JWLqTlCaB0pulYOb7PWJ2ffV4RRD2xb/XZsowbg6aLaLPj9+vhqQDJU7KRxWB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 10:31 PM, Lorenzo Stoakes (ARM) wrote:
[snip]

> The reset, performed in reset_vma_seqcounts(), only needs to WRITE_ONCE()
> the value. The stores follow the smp_wmb() in do_raw_write_seqcount_end(),
> so a reader observing a reset value also observes the VMA modifications
> made under the write lock.

the writer side looks fine, but what orders it on the reader side?
raw_read_seqcount() is just an smp_load_acquire() since d0dd066a0fa2,
not the smp_rmb() the comment mentions, so the earlier
READ_ONCE(vma->vm_lock_seq) isn't ordered against the later vma reads.
couldn't a reader on arm64 see the reset 0 with the old odd
mm_lock_seq, pass the parity check and read stale vma fields? would
smp_load_acquire(&vma->vm_lock_seq) be enough?

[snip]

> Cc: stable@vger.kernel.org

the parity check relies on e5e7fb278e59. before that, mm_lock_seq only
increments on unlock, so locked values can be odd or even. should this
be limited to 6.14+, with a note that older trees need a different fix?
a straight backport of the odd check would ignore write locks taken on
even cycles.

[snip]

> +	/*
> +	 * The VMA seqcount is always odd if locked. An even value can only be
> +	 * the zero stored by reset_vma_seqcounts(), never a write lock.
> +	 */

vma_lock_init() now stores 0 too, so this isn't quite true, is it?

[snip]

> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> -						    struct vm_area_struct *vma)
> +static struct vm_area_struct *vma_start_read(struct mm_struct *mm,
> +					     struct vm_area_struct *vma)

is dropping the inline intended?

[snip]

> +EXPORT_SYMBOL(reset_vma_seqcounts);

since it has to be exported for the inline mmap_write_unlock(), would a
__ prefix make sense, so nobody calls it outside vma_end_write_all()?

I tested it on x86 in qemu with KASAN, lockdep and DEBUG_VM on top of
mm-unstable and saw no issues, but I'm hesitant about the points above.
happy to give a Tested-by on the next version :)

-- 
cheers,
jose a. p-a

