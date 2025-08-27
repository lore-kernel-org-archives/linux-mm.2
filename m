Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FED4CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 09:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1443E6B0381; Wed, 27 Aug 2025 05:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F57F6B0382; Wed, 27 Aug 2025 05:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF648E0105; Wed, 27 Aug 2025 05:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34876B0381
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:13:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11EA1139C13
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:13:16 +0000 (UTC)
X-FDA: 83821973592.24.3D4BB34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 759561C0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:13:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BmA/SGWq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756285993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3R5UIBu60N8GGCrwU0rXeHVTKJbO3dfGTf6qmwj8MI=;
	b=bOCXkx85j1FPlsAlLp6iGDqe842994HXCMIyR+iy69niVN0va8yhiCEW2N6SjJVXZE5APj
	7TKcQIa+NZuDJPZvJrY8A3SH4DbKoUwPS5aIQTM42BSOGwK2HcQ0zNFZH5LIC78Xu9VBN6
	P5I0pnMpbKXxBYQdfaFrHgxjEM55fwQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BmA/SGWq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756285993; a=rsa-sha256;
	cv=none;
	b=U5nOJslstI2BdA9fJuCTr+s8J8boBpQTYaTuczsGnsOoUvujzH6EDVZfmc5s+XRQr2llc1
	9Nrb5VjIkb/ZVGEcogJMYsV7qlmFw9PszKhbX9K8fKzwBNvpn9C2IZYbFMVTvuTPwW1W3J
	6ls5Y0ZFLDWJeS0KP26MUDZS0wBqOoc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756285992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x3R5UIBu60N8GGCrwU0rXeHVTKJbO3dfGTf6qmwj8MI=;
	b=BmA/SGWqCWULwSLB2ngxz8hUYiIO4bPj0Q6XJ3xkv2QTnrsyjzPDVM+OT0+4Ub9X7njqCO
	ityt2fLk30uaOacc4NV7Y/b5jeDi+j/Gld4TAUyme4rfr02gk2maB9ixV5BSBREaRBbYFv
	xCnLERD18zUCcCOVpd/kUjrpY5byjsA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-nDPFarWtNs6GSX1vTeoHcQ-1; Wed, 27 Aug 2025 05:13:08 -0400
X-MC-Unique: nDPFarWtNs6GSX1vTeoHcQ-1
X-Mimecast-MFC-AGG-ID: nDPFarWtNs6GSX1vTeoHcQ_1756285988
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7f674810ddbso266796485a.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756285988; x=1756890788;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x3R5UIBu60N8GGCrwU0rXeHVTKJbO3dfGTf6qmwj8MI=;
        b=TyJ7jLwqrthENNYRqbVIWwwxlMaBhpBEqam7l/dHmN4hPhD6utcXGJaKS5qcypTNzA
         3XoFPRrKlgtGqBaAziPfdFDgkS8a1OLr9WJLSbaDk2kOu/oTIpnE+bixj5gnB/ItAvQd
         aDp13+wlLTOSxV3ouIehtIvEGhjL5HWJ5Xvobl8snJl/v50WRzjoYMEkINAGtnRqWv/+
         cGxZqulAR0z41JckTgerxsija3drcsUPhqYBfrmOuT9N+JEmZ4Cb0+d4nxWLXbymM4o8
         TxABclejPHM8fJDUoIYN8ir3KfPnLEYMJDSyb2u8g368TEQDNLYXRNKvHNa6/jhVs+ii
         /CXA==
X-Forwarded-Encrypted: i=1; AJvYcCWyUqSBlr3US2e8Bnvlt0dZsM7rNnuYTu91YEE8QhLnR+Cwd0zHf4wDMNgvQOk8jB/bgnmVGmqpSA==@kvack.org
X-Gm-Message-State: AOJu0YwOS7pDZCPvjfUIjdU6XorWYYmYECCvCY/pps9dsK5kjV14f+cb
	bQb1KXN35AcwvFnKMyNpX14zTwR7DTCpli/am6NeP3horIqkAkfQ2ioP72s8/O3Tdbh2wcwDu/I
	+G5wdOW9Zqf538LeMXte/Pwf9xjZSx5eSpKR4EIqP+T1rjkixryij
X-Gm-Gg: ASbGncuPopUoHa+7zPCaVfRfKocbP9LAZmME5T08th1P/cWCRRUY4ZtwNw+EiFErqDA
	dJoZQ/Phphw9GEHCWLd3z4oyyv4kRUmr4rwbqAqe/3RutmgOkkZTuZJpcEcbFlwTPSD4MucDF3r
	IGhm+gqftycEJfTtxEoo0rVZ+7IGPeigsmW44uFyaxA4i4e6wmEWDMp9ajKH+hZZxPc6jQwEpFo
	CFDdkxoVdWLufeHImZHkoMuvYXXFbPH8aDnnEKobgEXF23brQf9+asvHSScl40wekSOjOS/yEK5
	w+8cvQCX37MY7tdQ9qppcWs4kLJWPs8bTC4rE/bdP7QCVrye3S2apeKX4FCkTw==
X-Received: by 2002:a05:620a:bd6:b0:7e6:218e:ff2 with SMTP id af79cd13be357-7ea10fd9fe5mr1992934285a.20.1756285987753;
        Wed, 27 Aug 2025 02:13:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE25yZ28t05+y+8tGkTrMZGNC04YKUGA762w/1HEenRyoEnjTTJpHwY5f7MnLOX5vOcptcYXQ==
X-Received: by 2002:a05:620a:bd6:b0:7e6:218e:ff2 with SMTP id af79cd13be357-7ea10fd9fe5mr1992931585a.20.1756285987096;
        Wed, 27 Aug 2025 02:13:07 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebed8911aesm830103585a.19.2025.08.27.02.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 02:13:06 -0700 (PDT)
Message-ID: <d4f8365a-a840-4024-8d25-d7930035947f@redhat.com>
Date: Wed, 27 Aug 2025 11:13:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: make folio page count functions return unsigned
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
References: <20250826153721.GA23292@cathedrallabs.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250826153721.GA23292@cathedrallabs.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HowV5Rn54PnhSxIiH7eR95JF5iMvnFFScKGQBOYnbus_1756285988
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 759561C0007
X-Stat-Signature: jgmuz8f38rb9nzyiytc7ozc5eppknfw4
X-Rspam-User: 
X-HE-Tag: 1756285993-14652
X-HE-Meta: U2FsdGVkX1/Rf2hC84hpkZIaviuxSLzlvnCL81tOvZIg/7P/nUhQY/S7j4ONn5lmZbHQIboyAkdmpPg7HyyQuiarwn6GYw3b9HCNgToAAmxXz3uYE2JwuXK9cTlfh76v4cHIUD389KhGHiVL/FbpskbuTmVeSamiEK3j0m6ylusXpYN+VT84GYuO0+gElHNm1CF4bt+yOHGA5s5kWYpBFJD8+hBhM9SdtcESkVVJ7G+T05pbcU69ftiFVng9pO/+Ndbl/BiYexKd1s8Ubascm0ldXNHKKdjgVkmI7LI6Eop2MzbuwDEvzfj8g6IETYC1fDJS/b18Fg4jARTI1k+FovokDFn5/vA79nwwLI6Vupb96rHCUxy61abkN1/mjTIkSxX0ANxjTuvXuE46IYOJxp5h+4qEw6Muz46JcuUgfDt3WHUeg5fDK6WZWYrEdPj5mAEoV6Uh/8EcEqbVuureHEEyLMP+n8PpfjI8xzrpkosbIwsLg3GcXw4FgZmaOkKpUNkVW81k8yGDjoZkRB+iPhWg1/UeSlvXakrs5gbLrrmAFfZLH2TqFT7/6qrketuXGpN6qzImUIXQJwf25NUb7jGcJPAZWi8vy2sChtX6/ZOaSv8yCovNRgJa+CeGMMalgHfRKgR6Q/qivQWJeoSlVjTErbpLzD9FmVsJHiuxkM6MepxB8iejge+i7v0wCZ5Xum6RRaeUg8VJDGOWVkQlfqJrsbUMQC+2O0/Okd2JaIvVKvm5o7FXYXUohYw58DGDxLYqKJievHIWIZ+3sh1/1yLNuyFErHZGApcs1BXesF8w+ps74aTiU9haZQDOgYM4IpZNlMCHd9iifVXFVRWfplwRw5VDzEHKmzVckQYIa9KYa7gTmmVLR7gsx7o70Javt82/u4ywtC5UXGp/8mwRZ94KwgP6eXBmEvVBQL+Bgm+VMzJtI1t2ATJn1SmCmDVuDalAB0FlSIbYB+LQGl3
 1azJSZup
 1FCowdq2oc9JPpO1WPHue+AWsozDwa2RJkgh7cIM1nCTTZmQi2vXpm1XMU/RFlQ9DHq2m/rtJMya+2EYbdR/p/Tp3DYVsfR6mqKyvYwaMWUEeDS4qN8mN1mAKpRGxj+fRmaI2JN2Z4Ng8MAcNqMpVJqeblD/a/WinxsDq35j+f+NBCjIzJVFmulM1Az3c8aJvAoiRY8c8TerrtoRv2TpjNEBgagVr+y7v+zMEHbQDGwZlCzx4dvv+QS7jvc3DZ46AXLqE8BeDGroShPWZCUZYXWP81zq6nH1wXv6JZZVYNwdvR75c3cjiXXyKDRL/8caUWbPFWtiLpE1uW0QS6K5x3q1V72OpM5Awvo74L1RjBxe+KTmBkW09pZKLfpaHXyVA0/H0ScPp8Nl4Edm5RBFQuZ0HJa/McmAlCHmB8peRkasZIGj/kPAAvRzuKz2dXcXbhYcutWu5eELjJzLHejf36iaMuHyKtMkLOt1AImtUIFi+nWXo9A86xau57bHK9Djwk5tOQ/UQBpQBoS03yLx941Ar07Y4HuksHNF9fuilxNoGdF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 17:37, Aristeu Rozanski wrote:
> As raised by Andrew [1], a folio/compound page never spans a negative number
> of pages. Consequently, let's use "unsigned long" instead of "long"
> consistently for folio_nr_pages(), folio_large_nr_pages() and compound_nr().
> 
> Using "unsigned long" as return value is fine, because even
> "(long)-folio_nr_pages()" will keep on working as expected. Using "unsigned
> int" instead would actually break these use cases.
> 
> This patch takes the first step changing these to return unsigned long (and
> making drm_gem_get_pages() use the new types instead of replacing min()).
> 
> In the future, we might want to make more callers of these functions to
> consistently use "unsigned long".
> 
> [1] https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/
> 
> Link: https://lore.kernel.org/linux-mm/20250503182858.5a02729fcffd6d4723afcfc2@linux-foundation.org/
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> 

TL;DR

Acked-by: David Hildenbrand <david@redhat.com>



I agree with Andrew that using an unsigned type is clearer, and it confused me in
the past.

When I last looked at that, I realized that "unsigned int" is problematic
(the hard way ...)  and concluded that "unsigned long" should work as well.

commit 1ea5212aed0682ae1249cba9df7ad7ef539d0a7d
Author: David Hildenbrand <david@redhat.com>
Date:   Mon Mar 3 17:29:55 2025 +0100

     mm: factor out large folio handling from folio_nr_pages() into folio_large_nr_pages()
     
     Let's factor it out into a simple helper function.  This helper will also
     come in handy when working with code where we know that our folio is
     large.
     
     While at it, let's consistently return a "long" value from all these
     similar functions.  Note that we cannot use "unsigned int" (even though
     _folio_nr_pages is of that type), because it would break some callers that
     do stuff like "-folio_nr_pages()".  Both "int" or "unsigned long" would
     work as well.


compound_nr() used "unsigned long" before.

I did a quick test below to make sure I am not missing something.

"unsigned long" works as expected except. The only exception would be 32bit
when we would have a function that expects a signed or unsigned "long long".

Should we be using "unsigned long long"? I don't think so.


Using long long / unsigned long long for something nr_pages (or PFN) related
is highly questionable and should be cleaned up.

Because I am curious, si I looked around (I hope I caught most cases):

$ git grep -e "\- *folio_nr_pages"
include/linux/mm_inline.h:                      -folio_nr_pages(folio));

-> consumes "long nr_pages"

include/linux/vmstat.h: __mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
include/linux/vmstat.h: mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
include/linux/vmstat.h: __mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
include/linux/vmstat.h: mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));

-> consume "long delta"

include/linux/vmstat.h: __lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
include/linux/vmstat.h: lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));

-> Consume "int val"

mm/khugepaged.c:                        -folio_nr_pages(folio));

-> Consumes "long nr"

mm/memcontrol-v1.c:     memcg1_charge_statistics(memcg, -folio_nr_pages(folio));

-> Consumes "int nr_pages"

mm/migrate.c:                                   folio_is_file_lru(folio), -folio_nr_pages(folio));

-> consume "long delta"

mm/migrate.c:   folio_ref_unfreeze(src, expected_count - folio_nr_pages(src));

-> expected_count is an "int"

mm/migrate.c:                               folio_is_file_lru(src), -folio_nr_pages(src));

-> Consumes "long nr"


$ git grep -e "\-= *folio_nr_pages"
fs/bcachefs/fs-io-buffered.c:                   ractl->_index -= folio_nr_pages(folio);

-> "pgoff_t _index" -> "unsigned long"

fs/btrfs/extent_io.c:                   wbc->nr_to_write -= folio_nr_pages(folio);
fs/ext4/inode.c:        mpd->wbc->nr_to_write -= folio_nr_pages(folio);
fs/ext4/inode.c:        mpd->wbc->nr_to_write -= folio_nr_pages(folio);

-> "long nr_to_write"

mm/memory-failure.c:            count -= folio_nr_pages(page_folio(p));

-> "int count"

mm/page-writeback.c:            wbc->nr_to_write -= folio_nr_pages(folio);

-> "long nr_to_write"

--

$ gcc tst.c -o tst; ./tst
Testing: receive_unsigned_long_long(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_long_long(-return_long_long())
         PASS
Testing: receive_unsigned_long_long(-return_unsigned_long())
         PASS
Testing: receive_unsigned_long_long(-return_long())
         PASS
Testing: receive_unsigned_long_long(-return_unsigned_int())
         FAIL
Testing: receive_unsigned_long_long(-return_int())
         PASS
Testing: receive_long_long(-return_unsigned_long_long())
         PASS
Testing: receive_long_long(-return_long_long())
         PASS
Testing: receive_long_long(-return_unsigned_long())
         PASS
Testing: receive_long_long(-return_long())
         PASS
Testing: receive_long_long(-return_unsigned_int())
         FAIL
Testing: receive_long_long(-return_int())
         PASS
Testing: receive_unsigned_long(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_long(-return_long_long())
         PASS
Testing: receive_unsigned_long(-return_unsigned_long())
         PASS
Testing: receive_unsigned_long(-return_long())
         PASS
Testing: receive_unsigned_long(-return_unsigned_int())
         FAIL
Testing: receive_unsigned_long(-return_int())
         PASS
Testing: receive_long(-return_unsigned_long_long())
         PASS
Testing: receive_long(-return_long_long())
         PASS
Testing: receive_long(-return_unsigned_long())
         PASS
Testing: receive_long(-return_long())
         PASS
Testing: receive_long(-return_unsigned_int())
         FAIL
Testing: receive_long(-return_int())
         PASS
Testing: receive_unsigned_int(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_int(-return_long_long())
         PASS
Testing: receive_unsigned_int(-return_unsigned_long())
         PASS
Testing: receive_unsigned_int(-return_long())
         PASS
Testing: receive_unsigned_int(-return_unsigned_int())
         PASS
Testing: receive_unsigned_int(-return_int())
         PASS
Testing: receive_int(-return_unsigned_long_long())
         PASS
Testing: receive_int(-return_long_long())
         PASS
Testing: receive_int(-return_unsigned_long())
         PASS
Testing: receive_int(-return_long())
         PASS
Testing: receive_int(-return_unsigned_int())
         PASS
Testing: receive_int(-return_int())
         PASS

$ gcc -m32 tst.c -o tst; ./tst
Testing: receive_unsigned_long_long(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_long_long(-return_long_long())
         PASS
Testing: receive_unsigned_long_long(-return_unsigned_long())
         FAIL
Testing: receive_unsigned_long_long(-return_long())
         PASS
Testing: receive_unsigned_long_long(-return_unsigned_int())
         FAIL
Testing: receive_unsigned_long_long(-return_int())
         PASS
Testing: receive_long_long(-return_unsigned_long_long())
         PASS
Testing: receive_long_long(-return_long_long())
         PASS
Testing: receive_long_long(-return_unsigned_long())
         FAIL
Testing: receive_long_long(-return_long())
         PASS
Testing: receive_long_long(-return_unsigned_int())
         FAIL
Testing: receive_long_long(-return_int())
         PASS
Testing: receive_unsigned_long(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_long(-return_long_long())
         PASS
Testing: receive_unsigned_long(-return_unsigned_long())
         PASS
Testing: receive_unsigned_long(-return_long())
         PASS
Testing: receive_unsigned_long(-return_unsigned_int())
         PASS
Testing: receive_unsigned_long(-return_int())
         PASS
Testing: receive_long(-return_unsigned_long_long())
         PASS
Testing: receive_long(-return_long_long())
         PASS
Testing: receive_long(-return_unsigned_long())
         PASS
Testing: receive_long(-return_long())
         PASS
Testing: receive_long(-return_unsigned_int())
         PASS
Testing: receive_long(-return_int())
         PASS
Testing: receive_unsigned_int(-return_unsigned_long_long())
         PASS
Testing: receive_unsigned_int(-return_long_long())
         PASS
Testing: receive_unsigned_int(-return_unsigned_long())
         PASS
Testing: receive_unsigned_int(-return_long())
         PASS
Testing: receive_unsigned_int(-return_unsigned_int())
         PASS
Testing: receive_unsigned_int(-return_int())
         PASS
Testing: receive_int(-return_unsigned_long_long())
         PASS
Testing: receive_int(-return_long_long())
         PASS
Testing: receive_int(-return_unsigned_long())
         PASS
Testing: receive_int(-return_long())
         PASS
Testing: receive_int(-return_unsigned_int())
         PASS
Testing: receive_int(-return_int())
         PASS

--

#include <stdio.h>
#include <stdbool.h>

volatile int orig_val = 1234;
volatile int receive_val = -1234;

static unsigned long long return_unsigned_long_long(void)
{
	return orig_val;
}

static long long return_long_long(void)
{
	return orig_val;
}

static unsigned long return_unsigned_long(void)
{
	return orig_val;
}

static long return_long(void)
{
	return orig_val;
}

static unsigned int return_unsigned_int(void)
{
	return orig_val;
}

static int return_int(void)
{
	return orig_val;
}

static bool receive_unsigned_long_long(unsigned long long val)
{
	return val == receive_val;
}

static bool receive_long_long(long long val)
{
	return val == receive_val;
}

static bool receive_unsigned_long(unsigned long val)
{
	return val == receive_val;
}

static bool receive_long(long val)
{
	return val == receive_val;
}

static bool receive_unsigned_int(unsigned int val)
{
	return val == receive_val;
}

static bool receive_int(int val)
{
	return val == receive_val;
}

#define TEST(cmd) \
	do { \
		printf("Testing: " #cmd "\n"); \
		if (cmd) \
			printf("\tPASS\n"); \
		else \
			printf("\tFAIL\n"); \
	} while(0)

int main(int ac, char** av) {
	TEST(receive_unsigned_long_long(-return_unsigned_long_long()));
	TEST(receive_unsigned_long_long(-return_long_long()));
	TEST(receive_unsigned_long_long(-return_unsigned_long()));
	TEST(receive_unsigned_long_long(-return_long()));
	TEST(receive_unsigned_long_long(-return_unsigned_int()));
	TEST(receive_unsigned_long_long(-return_int()));
	TEST(receive_long_long(-return_unsigned_long_long()));
	TEST(receive_long_long(-return_long_long()));
	TEST(receive_long_long(-return_unsigned_long()));
	TEST(receive_long_long(-return_long()));
	TEST(receive_long_long(-return_unsigned_int()));
	TEST(receive_long_long(-return_int()));
	TEST(receive_unsigned_long(-return_unsigned_long_long()));
	TEST(receive_unsigned_long(-return_long_long()));
	TEST(receive_unsigned_long(-return_unsigned_long()));
	TEST(receive_unsigned_long(-return_long()));
	TEST(receive_unsigned_long(-return_unsigned_int()));
	TEST(receive_unsigned_long(-return_int()));
	TEST(receive_long(-return_unsigned_long_long()));
	TEST(receive_long(-return_long_long()));
	TEST(receive_long(-return_unsigned_long()));
	TEST(receive_long(-return_long()));
	TEST(receive_long(-return_unsigned_int()));
	TEST(receive_long(-return_int()));
	TEST(receive_unsigned_int(-return_unsigned_long_long()));
	TEST(receive_unsigned_int(-return_long_long()));
	TEST(receive_unsigned_int(-return_unsigned_long()));
	TEST(receive_unsigned_int(-return_long()));
	TEST(receive_unsigned_int(-return_unsigned_int()));
	TEST(receive_unsigned_int(-return_int()));
	TEST(receive_int(-return_unsigned_long_long()));
	TEST(receive_int(-return_long_long()));
	TEST(receive_int(-return_unsigned_long()));
	TEST(receive_int(-return_long()));
	TEST(receive_int(-return_unsigned_int()));
	TEST(receive_int(-return_int()));
	return 0;
}

-- 
Cheers

David / dhildenb


