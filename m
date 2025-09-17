Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F02CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5011B8E000E; Wed, 17 Sep 2025 06:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7A68E0001; Wed, 17 Sep 2025 06:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6DB8E000E; Wed, 17 Sep 2025 06:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 238008E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:38:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8B59B9AD6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:38:41 +0000 (UTC)
X-FDA: 83898393642.27.897CB6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86645C000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:38:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dPtHLPgm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105519; a=rsa-sha256;
	cv=none;
	b=6ZX9X5FVFITvdGnC6phkR1PMxIysVlQ47aqt8HWIkzw9qZd9u6gEASXtCd9FcDE5UsBD7N
	zFzLW3IVzX0dJQxMoMvkokXRvMeDeIKgea0/y5PQQKUp1W+XGDwjg0yTVzQuLqJk2brCs5
	kufJSnzEUzb3J144Dk3QvTrgPWv4s+w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dPtHLPgm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soTuum+uvrVdwH4G5wCW13aWL0UwyqwjoUoslGSKOfc=;
	b=xu0SO0UlqcSp0jgMQHgHnvoYYHZDKqF+iCOwO77xiJKoF6tt3YEkp7E3d6AzCizYiOmSF4
	bittI5GSBZBX3HxZIYVTNX00F/7b1yayK62zfFCV1r9+uX2EmK15GAc1a6SsWgGlxY/Ivx
	d0AcEqZGFCcGFqdN0TrKDrMac8bucZw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758105519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=soTuum+uvrVdwH4G5wCW13aWL0UwyqwjoUoslGSKOfc=;
	b=dPtHLPgm3lUOgkZ0g+LmH9ehilU90YPZEzxAaXU/aqJYBkW0Oef/GWs79ozPq7zrYSeQnJ
	5jbm7OAFpl+MShiTwgR/OQIXJBO7tJ3qr//sutHsoPuWnPe6TaCLqe1/LGka6iw3y44XBo
	nObMx9/BlW+Q26ceWv8QptDbBZbjr08=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-b2rG-0-6Pg6TkfcLVb8arg-1; Wed, 17 Sep 2025 06:38:35 -0400
X-MC-Unique: b2rG-0-6Pg6TkfcLVb8arg-1
X-Mimecast-MFC-AGG-ID: b2rG-0-6Pg6TkfcLVb8arg_1758105515
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ccd58af2bbso274743f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758105514; x=1758710314;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=soTuum+uvrVdwH4G5wCW13aWL0UwyqwjoUoslGSKOfc=;
        b=ZrcBVt6RFPhHDv+YFzMoPwpU1Uh+4Gyu+lI6AXGigWBZZixkHzxIuFYYhva/OXGSy0
         nViK3IkpefK+mYy+ipc8Xaw/jsvJPDgEIYeQ/6Y2w9yDdg7Urk/eoAUQ/rWeTgrwkrzk
         OPbxro5ZMOgO3a25AyfoRr/4MZNIvJ4KMgRHrThhZu1CusTN2V8MQfx4KtLv/0X3tOqa
         yBnW2Yp37EA5S/4EYyFzvQd+YSswSeNHDI3l3zKbngI/cHJmb3HnmHv5Gv7AVxWtklbp
         fnDMjvh+Xq9gcA06eNudpvuroZ8TNPifWEJsbaBgpEI0dza48dJe57malozzihEs4zqM
         NEnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEGWxjgW/0kwS8xWuzTbL4fg+DPamp8bUFHjVc5S+XDVef8ahWrg9obW2h846EJs8B+Nqrc0I3JA==@kvack.org
X-Gm-Message-State: AOJu0YwTGjAcvMtBklJ0TPq2hni6zrj7uT7NNOHkUc325JvbeqFcOtlC
	WmLa9pB8iIBFNAESJgoqtGf+tNP6vvFp8fil/b+RSjjjKU6nNWMXqZfWGzeenMTbj6Xs/cL5xIy
	U7fdjw+JDtPC9Mdb5gee8gD7iArq2UgMSS0wuXk07LvHiS9Kr+k6F
X-Gm-Gg: ASbGncuJLwtqgbNXyPx2hTLqkVbRfCuzsNZ1y/82rT2KpbO6L/LhptLZAtW4Ndp3kwv
	ChQtvjAeTMTHsqV6bbCLvTLps7B45AhI5a/1xpcAx3g7H0iH9PAVbnNH+1zyaTpHiyM/NyB4sLN
	1vf7KldJoVeC/rQR0iWZCVih2Xw39M2u5R941kavjaAbs+GL402yxCFmxghyViJ/jnt+2+SfGae
	CSGfSFZ//OB0z82z9Z6mogjLIxR4altzi92OZiLCa/xwDYxePaulfo7CxJoaZ4C48mjuf+z4jOL
	xnGYRIjah/ILX20/NVIA2NKa/5wO/9jnKjWj2UVsqHmghGuFbXZgGdfIsM23x2FuNwJaK6nKSZO
	tkFDjsEa9Hb5w8+snm2e8yBom5KRz0lARNWw9Udjpp/rGvfBtSJ6CLMNmoVd/zJDa
X-Received: by 2002:a05:6000:4009:b0:3ea:c893:95b6 with SMTP id ffacd0b85a97d-3eca04743f7mr5153580f8f.27.1758105514582;
        Wed, 17 Sep 2025 03:38:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8tKIbcNk5D2bluX7BbsWlrG22DyI/8RTeAIZckT7d1/mvHIE0aGsiKEPHwv0/JBjR38b5Xg==
X-Received: by 2002:a05:6000:4009:b0:3ea:c893:95b6 with SMTP id ffacd0b85a97d-3eca04743f7mr5153552f8f.27.1758105514108;
        Wed, 17 Sep 2025 03:38:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e95b111b68sm15518054f8f.32.2025.09.17.03.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:38:33 -0700 (PDT)
Message-ID: <6dde7c50-a222-4984-bb69-07ace724f161@redhat.com>
Date: Wed, 17 Sep 2025 12:38:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/ksm: Fix incorrect KSM counter handling in
 mm_struct during fork
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
 stable@vger.kernel.org
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4044e7623953d9f4c240d0308cf0b2fe769ee553.1757946863.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BpLf9kfaiZX3mo90npuqA209ARAzWGnCfPSFovpxsxA_1758105515
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86645C000E
X-Stat-Signature: z6yjb6h9b98g43rs34qcykjk9f31nwan
X-Rspam-User: 
X-HE-Tag: 1758105519-989541
X-HE-Meta: U2FsdGVkX19TH6t6vLE31k6A5FHtgyfp7O5aFGANd6ub2ZFYRy91mGU9CRYxOvJzojdk/uoWYYuBFl3T3wsubRwg94tJVV9zh2ij8y1gaSCm5WzWlM3YNg6/BSUtcYMV8Oy/3SK/I1s4vKaY5VrFez/NJxi6L0iK4nBGWO0kNeCkCVJQl6gj6pQ1zEsR1MoGaFUqdO3HyoiQTPjcGppundVQh6CqnKh1OtIQ31HBd7zRnIW7xqft5WFmHM2tiW1YYVf/QGik1DC4qFdth7XuyoxzIoEvIAt+KVOLF394v2JV9ze3eFH6rrCyeaQm9QPAhjvMFUta0mt+/2nG/W0rt6cD9Z5LLjYOgwEvxcXVNTQdFgy2G2bswH29maFUK5fwS8+DAF5q0zc4g2RzCtDKAGBNJRTz49VwzMyuTK9gQif4Qej7QN3XBBeQaOu6hGaAV7D0w/XsF6xfElbMfBLcuxzxctwmtq7jiGR6TC25+pSCkhDnj1HRkqWAkcyWTJmfnPdz40o9Q87VewRpduiV2VCRHlyJ/qQGvIzqM6S1fNb9i2gJJ+mO8WfESAeFFRq41BRzaEVqF3+RNFFyFzCSNgRcgZWRpTB+JRjTLe7fg9gGH+QbOIom/IIHssgiadvNAyvq6JCC0KLmDO7jfPVeRy/M0Knav+N1LACxa0YuUUdHvfeAl+c71YRd1/3KtDblhcOJEzmlYQ5IThnyLGJlyWNujEpTZ9zTHZOVMjZOkPwYkflUhpHNgkTnbTxXHl6fWCehPRLvKaKlHs431kNCsLhfdMur+0g0o/1wd+fgIQjFKv23YHtmkAEyrbCUN6inpHlqufHnk6KsmAPE3k6+JgJ/yhclbrAGUgaqOzu2yXjy9GO1nxW0tLMQof8jB/gqWpoW/48hMtSNx1KtUfXO/dSddFRAoGiIFjre5H9VXt66lBM44QZpdHejW5xP0YCJi4MBt5DdhdnMGw2dodW
 jN5vCjdX
 DotVZQ/175lTWO4dJT1yxJt3nLkycEkm67KMsT6pjJ9pEWnK/yCm31oqan2HKdtfbm26icEHCwnkByi+n0uZ3fQwsl/ukBYysETTzTqEw1MI7SM8BRX/yYLYkUtAy0qHTj4IHUVii0fKdzWM6WLRkqbK9/tnT9mCEjzV0STTAYW9YRMYJibwi/DpWHpFFzKiuUMY/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 17:03, Donet Tom wrote:
> Currently, the KSM-related counters in `mm_struct`, such as
> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages`, are
> inherited by the child process during fork. This results in inconsistent
> accounting.
> 
> When a process uses KSM, identical pages are merged and an rmap item is
> created for each merged page. The `ksm_merging_pages` and
> `ksm_rmap_items` counters are updated accordingly. However, after a
> fork, these counters are copied to the child while the corresponding
> rmap items are not. As a result, when the child later triggers an
> unmerge, there are no rmap items present in the child, so the counters
> remain stale, leading to incorrect accounting.
> 
> A similar issue exists with `ksm_zero_pages`, which maintains both a
> global counter and a per-process counter. During fork, the per-process
> counter is inherited by the child, but the global counter is not
> incremented. Since the child also references zero pages, the global
> counter should be updated as well. Otherwise, during zero-page unmerge,
> both the global and per-process counters are decremented, causing the
> global counter to become inconsistent.
> 
> To fix this, ksm_merging_pages and ksm_rmap_items are reset to 0
> during fork, and the global ksm_zero_pages counter is updated with the
> per-process ksm_zero_pages value inherited by the child. This ensures
> that KSM statistics remain accurate and reflect the activity of each
> process correctly.
> 
> Fixes: 7609385337a4 ("ksm: count ksm merging pages for each process")
> Fixes: cb4df4cae4f2 ("ksm: count allocated ksm rmap_items for each process")
> Fixes: e2942062e01d ("ksm: count all zero pages placed by KSM")
> cc: stable@vger.kernel.org # v6.6
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   include/linux/ksm.h | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index 22e67ca7cba3..067538fc4d58 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -56,8 +56,14 @@ static inline long mm_ksm_zero_pages(struct mm_struct *mm)
>   static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>   {
>   	/* Adding mm to ksm is best effort on fork. */
> -	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
> +	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
> +		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
> +
> +		mm->ksm_merging_pages = 0;
> +		mm->ksm_rmap_items = 0;
> +		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
>   		__ksm_enter(mm);

That LGTM. KSM is all weird in combination with fork(), but that's 
something for another day to improve I guess.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


