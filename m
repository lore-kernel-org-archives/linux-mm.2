Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693F2CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F0A8E0003; Tue,  2 Sep 2025 05:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFCD8E0001; Tue,  2 Sep 2025 05:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9906F8E0003; Tue,  2 Sep 2025 05:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 826788E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:42:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D77711A945
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:42:40 +0000 (UTC)
X-FDA: 83843820480.05.510EB0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id CDFFB40007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:42:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E9zJZ1ao;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756806157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asWSuLH6iU8nN8yxFqi4dFvgrrSedS75Z/J4pSraBcc=;
	b=ARuOcm2huXqfM8mf4ok3FqkT0Fs/WRxtEjPvSMS7ahNFoXQRKzA9Teg2CzPoee55HolDKZ
	JVWDz3kCbkrTAa0+Gekv0mahAuefIQ1YVbdopdq1sJ4ZCi5FbyXvbbnP+2fupxtsbMhruv
	ZwfrtRhK9jl6rD9eStz3QgfckQhozVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756806157; a=rsa-sha256;
	cv=none;
	b=1Wr7jutmrfzU86yGccFI2ImDtczcJ3TzQvYH34aUl9vdbH0C8Bupp6KWDhNlwQvWVwjSS+
	4QpMEiN0dssU1+Yqw6cGBTpIK1xpYOnGo5HNpc/lPoh9KwRpdRa5mSxF67Cn3OUHh5KWFm
	EH0vuB8ZdAZu/fX7UkjCorMMkUsT16w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E9zJZ1ao;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756806157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=asWSuLH6iU8nN8yxFqi4dFvgrrSedS75Z/J4pSraBcc=;
	b=E9zJZ1aoIwXJLF8wtF0rPENWj8qxa0CoI7H1xy4OIJ5KNO8nqolaTnri3pmpEvVZnmlBc+
	c/JvZvfvQRe9OCz4oAasfVW6exC529zBP4v7YhSH6c12gSCUNzTFWeghucHKTelhZxJOAQ
	RbOADTL875KPGE75VjXAqmUyCY/ZpO4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-1C6nFw1mOiWZ7EmMDSlYMw-1; Tue, 02 Sep 2025 05:42:36 -0400
X-MC-Unique: 1C6nFw1mOiWZ7EmMDSlYMw-1
X-Mimecast-MFC-AGG-ID: 1C6nFw1mOiWZ7EmMDSlYMw_1756806155
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so19751585e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756806155; x=1757410955;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=asWSuLH6iU8nN8yxFqi4dFvgrrSedS75Z/J4pSraBcc=;
        b=RN6pOmxb57fhzKkfJvOlCe14/rgTV0CSse/Fiy+ZG+8mJy77Sec7SPkaYgCiGuvSeH
         kV9sC35p1ITEchoUJuuYAt3Knz1vhhH9t+dWK8JGXc2fgNqmC6yP+R8YpUfclrP4OZDv
         v6g38j6EDtmI2fM7gHOwqLPiuMZJEZ2rTdnwhodQrZ956Rfi7d3eHDinbVMFvGuaweo+
         aXGOimSibUyvBhrId+3ctf7FpdPCPg/Ojpvaqblb/ZytwwTtW1qTnc4mJAHFeU6EVGj0
         USHMGT4QYz97d7e6jxgVYndnBCuiQgHnzmMoXw+BBpqXc63oivTfv/MHcv0WV8a2msfj
         9wvg==
X-Forwarded-Encrypted: i=1; AJvYcCXNJv/t4GKYN1M8vdmm/DDuvn+VTJas3OYHTwWrtLNOKY5QqRyKmCbcS+CFd7Rq8lL+UcNFqtKyBA==@kvack.org
X-Gm-Message-State: AOJu0Yz44EXZguLt39gOpEPpBAPG6cz8Z+ZPrruvP7CHZR8MqtR1Ln7t
	TQRlR5FULZA4YrfCVqjTWIBfi8/C2zj2n8fer8QPIOatz1/fzvpM9Jt99oePYi5+MVuOu80a1t2
	78S35J0Ycf6O8v0y4vTrB/a1JxWnnXbuBXHB//+RaeSaL06xVDv0I
X-Gm-Gg: ASbGncv2JkoZB1w8SULeTbd7qjOad/pxdhJOFc1Ow2VgDQYK8VamaFm12WG+5a8sQ2x
	f7EZUGGN+pEKvDkPydDZYsxH1SMENOsL5B7Acn0eXqjX2kV4FOruNNwlRDMXXxE/U0j9rhiTvF8
	6clu0iPB4zptRSKiWobwoFG8bH7PK7p+RuzmBzTYCHYgcev6OqZ/YuCWwsf+T9nNRkbI7cmsCwi
	cgkZm1q+HYG8Y+z54T7jLX94m6hOVOMCvn5vL0D5mURXLn3rYGzoSsIXJ2B+ivJR9q56SZnk1VX
	gNcsqho9Mw7Dl8owSKGElWHOtiNGF62L70Mc2Fd0rJxyNdeUmbxokv/od0lBNXXcNXfNKmRDFkL
	xUbavoxGD4znKcb2DeBOPuinPBPLnmsA4Fa7lb1Gm13FzWlI8RN9xxlwpEmcvRTvT+Ek=
X-Received: by 2002:a05:600c:1ca4:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45b8554e2ffmr100852515e9.10.1756806154833;
        Tue, 02 Sep 2025 02:42:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDiNU8UZPL8aTl3qS6g7/9CMF4yIxtcwFaCcDzAuhGVy5bNnLkv/vvSAEHWB2EXNvzk4IR6w==
X-Received: by 2002:a05:600c:1ca4:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45b8554e2ffmr100852105e9.10.1756806154215;
        Tue, 02 Sep 2025 02:42:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8acbe982sm57017205e9.6.2025.09.02.02.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:42:33 -0700 (PDT)
Message-ID: <22019944-2ef2-4463-9b3f-23c9e7c70b2f@redhat.com>
Date: Tue, 2 Sep 2025 11:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/37] drm/i915/gem: drop nth_page() usage within SG
 entry
To: Tvrtko Ursulin <tursulin@ursulin.net>, linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-27-david@redhat.com>
 <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5UnVS9WV1ZUSM9JPt2pBQkP8u6AkL5VPzW83XmUhs74_1756806155
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDFFB40007
X-Stat-Signature: jk6wusunnnyhzkfdpfj8geuei3uf4mu7
X-HE-Tag: 1756806157-640618
X-HE-Meta: U2FsdGVkX193y59leUwoiB56v/GBrSFNGENzyPPFDY0BsAlHL2j7x6nDgWOkOt7qo2JStfaLqhSfX+n6ruvzVCMFRbm1bfwMVMUlYpKOvDbZz770BXvsFm66NEjuW4GYVTuhU9dbLdjiGvNCMieV0BRPJEmvH54ZkkKfPwnMpASq2zQW3aPIH7sQJU3URd2YAksSKWGowQ+Q64yVgD5YAYG4CeS0XqV95nQ2rQYZMkX/x9YshsvzAzY46XBAdgwgg0Ui2Zv0InoyVyRX7G6QEaPRBlUkOU+d8QGZ4pBaeKD6M7vUw72oKt31yR59ZABeOUD+LJGpPkeXc58Dq9xRmvNyd4rPmQTfEWUMgi0H4iqAFZ+T3n0f3TCveNFDN48kK3pBi2UXsBMnbP8Gha8R5zZoUdwiP0AorPABTUPpr5UK0L4NQewKTnm31KAZUvVL1TVSZQfmRDaLtKS3/cz8PiM6Aeo2qvDFR2Hfks4rgwmNSrSUB3BPVbee8B2FUQKT0XhQTTw+V+LWJf4+9ZXMLthOSS3ym60zbXxq1ktJpy8tYG9JLTtj7ElFm3ISOGgmiW4TyatI+zEHzwIrar65z8ICkmI0vD0rTtg/QH3PQD6jtZnhU6SJnwTnc1Txl/D7f4TlWSWVcK3NaIMj/vp4QrkrrH6ECGbCPKhXpIuuRHrMRr6eTd9EX4PT3eOEGxHnnieg6yRAGT09JW1cJ/BM/TCgvFXU2AyZW+JsCU9fPF413+mtcZihXWoYst3UaQxNRoj28Y9AaVSqzwI50eMRsgNBK1lLKt/lTXaqMayAd/lgTPnC3DcVsCYACFYCyaOGTCledANuCvTIJ1xjukbfIb4zvoIZqZ5sIPvretB0/NauB6gXhVBQd2v6oDcBufkKJZS4nVJSVopCDhyXfEoeio0lpE4FlRbvRDloagBEnTGUF8B8/c900Xhr1ESQo0USz2YzYXcXWpiH4sj/J5O
 JRIeCjjn
 ZB7z4I0nA59biKkm3u7RWfRWHLRS5VxTNOvelkLIuqZiJedPRLExUEmJhjWSIwtQ4hBVYHhrx/S6OB3xE3XLCnrM/6s2/+PZ7O+XzwiLjZ3xNsuDpGOnIE7im3rCHjTKMcLsPaE8QqvN6VzNdlFkGmsz6uva82eKMfSXESUJrCf3Wdl6rRYXthu9v2Hq1hvrZI1pHSszmK8/BQG5iZZOqojYNyI5TgXXYHDi17aF0ExpIoxeuJpj8wg/syTnaz9aqcNCyNFt3iwViiivp+SUdjp2sV0j15ro3ij36AsGWqP1Xva8CCwPS4i2e931CDl+paULGX5k6R74mCvhvlQ6c5ecn2uUVueG7me5c8dpsknEELn2dppvTVhRwW1F8b45WPrRXoke3aIQN3Vr+nN1InKagtR10P2eRUybcG5n53j4U8gfmaMJdnkI8CWI6lrvehPQKTIO+985hNOS4SSXr9v1IgAhF8nVRSDwOpVxXoC6xBHuv/Z1ahzya5c5fuz8bzwExpv7TsAda3gW/mjxlIhfbMtnqAqryPKbny1dm0KnSfJMbDoItT6EPVnmrxK1j7+kzMtcMxcQk2qQh44+Wws3HaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 11:22, Tvrtko Ursulin wrote:
> 
> On 01/09/2025 16:03, David Hildenbrand wrote:
>> It's no longer required to use nth_page() when iterating pages within a
>> single SG entry, so let's drop the nth_page() usage.
>>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: Tvrtko Ursulin <tursulin@ursulin.net>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> index c16a57160b262..031d7acc16142 100644
>> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
>> @@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
>>    	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
>>    
>>    	sg = i915_gem_object_get_sg(obj, n, &offset);
>> -	return nth_page(sg_page(sg), offset);
>> +	return sg_page(sg) + offset;
>>    }
>>    
>>    /* Like i915_gem_object_get_page(), but mark the returned page dirty */
> 
> LGTM. If you want an ack to merge via a tree other than i915 you have
> it. I suspect it might be easier to coordinate like that.

Yeah, it would be best to route all of that through the MM tree. Thanks!

-- 
Cheers

David / dhildenb


