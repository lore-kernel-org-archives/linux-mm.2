Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEECCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E6A8E000D; Tue,  2 Sep 2025 11:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655508E0002; Tue,  2 Sep 2025 11:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DE28E000D; Tue,  2 Sep 2025 11:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4011B8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:40:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5FB9C0262
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:40:32 +0000 (UTC)
X-FDA: 83844722304.02.7D1AA01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66D6F100014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:40:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0XEad38;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756827630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PQsDee9NYIXTDUeC3sILYClfZwEF/KcDfxyRjS+bzM=;
	b=eEWPMJMvABgCeEWjDYAzQR8QZSh3MD1qI8fC2ZkN3T2D+nBlsv3TRCAoxVJyaJaMJgvn96
	DhEG8bVuHu0chBGKhiB5kfh/iSqwRH9yZaLyWEi7k323S2U2jqXMZ/OYQ8dkhaszJy2EQk
	siTVxnjrNkld/EgZdZFAj0wOp2V6h8w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0XEad38;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756827630; a=rsa-sha256;
	cv=none;
	b=U91fT6ID4QrUqDDHClapZaKBrM89ES2CKz07WTxxvzmkwshSh8+gXbnzLraTI1JI+AuUMc
	t5QD7bp6fzbzjDJ42g3df1jX1xSKRBAqt+povD0WMivCq6Eb3KdtKiKmP2rxdwCm5OhVmc
	JqAG/wTmFVC0fVUiNwdfANDegXR72nA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756827629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4PQsDee9NYIXTDUeC3sILYClfZwEF/KcDfxyRjS+bzM=;
	b=A0XEad38UCHStmiUumi0MOOydtssjFbaR6K9gI0M8OFUT4Mfmf1k5AWl77XmhehgEz8ZJj
	Y2pFPH9HqklOX31nxYDzAPcWPdX73LxGgwe2gAiep9vfhmnNV2vi+77gHnhcmg6SEdJdNH
	D32paygb+TWIzKFPVExbz4RRvNWw6bA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-SeKPnNUGNoqM3NBquT-OAA-1; Tue, 02 Sep 2025 11:40:28 -0400
X-MC-Unique: SeKPnNUGNoqM3NBquT-OAA-1
X-Mimecast-MFC-AGG-ID: SeKPnNUGNoqM3NBquT-OAA_1756827627
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3d1114879a4so1961292f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756827627; x=1757432427;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4PQsDee9NYIXTDUeC3sILYClfZwEF/KcDfxyRjS+bzM=;
        b=GJywAFymNG7u/hl86mcmDkF5NoSQ+JvsJ1ka6HqFY//02HkFwwh7S+Ki8NHO5gKntD
         xCwsgQC0UrJfZ8zVyq63Sra3A04ozYTGtEPYQPERhZFoiHQs5RzOZCHKQDS2LlSkHNdZ
         t6Lk+7Ehf0aOLjWqxc9PBeTdhSUvMx24lNamE9AkZbleSLT9Ck4dABkVaF7KSkoTt/p2
         FYNCI0kDSShY+Cnzs1IMHzDsQ6mYk68GC4E4dtxOlF03YdM8gaPvhDp8LrDQyGpG/I+9
         iNFrSo7cKI3fvNru3rG+5Vo9H+O7fsuZZMAfAJMZ0mgPlDrXlEtH1nzjCPnh1N4JO00G
         Ptxw==
X-Forwarded-Encrypted: i=1; AJvYcCUsUYc//doXarBSf/J9Lgt5osy4+vNQslrFYb1/r1caCS6pt8W1kPzIwsBub55kjHjr1BLAt5vfrQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9wWhE4WaqLfhAKnFbXm1sMjPwz6KLWae9BrKRu4YJ8Owg2sAu
	Tu5C/VixyQzrHZHQoBQQfeCRMbIe0dWt7GPG/2DGNKDmg0ZcoSlKrJAV1V4ZWOy2ZqjEAah8QHq
	eBRwRWjQKLkGpPOjj5QtJnWjYY4I0hrZLFkHMG/n41ssvPKh1Z/xo
X-Gm-Gg: ASbGncseGlervwgSQE+1glHLR5quIt+s+Jl8EG2sjKTVfI64jqxPHkos0upXm7gRHuK
	i6WtxZfRuAYudQmHmmgjwWXkmlZDlXDmBAfyMgXzUiSuaJkvU760hYBcpGPKcBrkAeLSiznsy5N
	Tkbd3AZFZquBStvnGopROxuz2mLr+8M3CZaJwKIM7wHmfQ4+0ZCL0BOOhhOPBYzhCxAkpetILBR
	CcelzpgetPosJpABdtOiVbsmLGwla20qbFFGNq18sIwBTgWxO87iU3DKGzGMbvz2EX5FDUPEJec
	kU5/rbOgdbeM7FpSnK4tfu+oobJD/cZnYVXwPX2yLpnxMyf0/vr0WrC2NyUv6ZfzTJxfQwThdYo
	gvXxoZhdlISTC5l37i0367WCo5X/teZcjUmMlTBM+lZYmZz+teXRlM1DUSqtSU273kl4=
X-Received: by 2002:a5d:5f44:0:b0:3d4:4a27:b1c with SMTP id ffacd0b85a97d-3d44a270e7fmr7177845f8f.28.1756827627143;
        Tue, 02 Sep 2025 08:40:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4FPky/sgy/N/Ry+JvGWmVxkdhlOkvKSYWJloSSkuJerelw+6xOcyYXqOq3BmCqi5iyUbw+w==
X-Received: by 2002:a5d:5f44:0:b0:3d4:4a27:b1c with SMTP id ffacd0b85a97d-3d44a270e7fmr7177818f8f.28.1756827626617;
        Tue, 02 Sep 2025 08:40:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3da13041bcasm3847253f8f.35.2025.09.02.08.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 08:40:26 -0700 (PDT)
Message-ID: <d987da2b-1b27-41fb-8e30-cbe9a9fe1cc0@redhat.com>
Date: Tue, 2 Sep 2025 17:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
From: David Hildenbrand <david@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <27A308FD-C7D8-4C65-90BA-9B1DC117B014@nvidia.com>
 <1d7e9c30-343e-41c4-814d-f6254b042509@redhat.com>
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
In-Reply-To: <1d7e9c30-343e-41c4-814d-f6254b042509@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a2aN_EfcF6kYgNDVVNtVd6_xhVO4UvV7NXhFKpdQM3g_1756827627
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66D6F100014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x3ni5gkh6w17aopi8z336jkupanbxbd5
X-HE-Tag: 1756827630-200454
X-HE-Meta: U2FsdGVkX19YeaxjP5eKJoomFaFCXJx4e2vgLvftS3PaZSbe0afEPBkfAV7Q5Hhhgf7wLdzAZIHJpMZt37UP2LgjDfZ298p0G+vmvLApKpddqjVXGVssTEuaG3vV3hW7C4V8BEplJ1Xg1re64BXKLb/kJ7jBvB8OlzZV3k9eVHRPd+u4IZFFtB5FmZ9KmVt36zFg9xKsSdoRhLbSVbeFFqOAU5c1EJVNwertvkiHQqKtke4uLQvSPTjN9f5vbbutADsv1uhHqGspY641xIpDM3jGsnEHUWlykJMGLXUJjoASi5EPSzOCwni/6z9aovmI0iAWgs6Gns1o4mE2zN6cADO9k1+cIDa+x1Wd6teE5Ah4cgf0+5bKMCpnHe6wJ8LAG+c7NsAZKosFuaur2ac7/nZa/BJrsZP4TJnSOpJmf8PbpGliHhAyqdqk8VSN1ljGWD1L/L4ScCAXAkd32Ih7T9gICUrIyAaNLLr1M7LbLEr2Oe/L2Kut31jA5IGxnAehIuBXFfEjFj/BmMhL7yubf27KVSUSZmcc1Nd9mHx+yGzlbhIkamxNkbtEpZFbS5CwJr2EnlQ0fAO/PQAMBwmbLcFLcmPbCTpb5jT1nc5xK0S0IyJRseNAdEYQ/1Uj0uW90HUnZbQYBgxAy1G7d5Iog4J7M8tttoO34nJUAarRkrwP+rnwCzSo/bqjw6xoWyn3gaID/qfEeFQSInnQtnGiCJ6vkGCgyneCGDuqD9UZOthU74mmlzWyk8DsDnGZikmZ8qrqSVnxb8uS4Vy8RFG9EYletXi83fTkyHmcrG06MsGKzlpr2FdhQ5mdUGRy3+92FNRvHLv6FQEqh2ZOZKYYmm76sRG6IJkMbR9ZqnqTx+0+VvX+jviAzTSL8+pH02Ow0tXNp/yxQgD5dCyQATJVFS3SLesjDnUnZ9JQ4ML1pepkO+SBE631Hk/FF9IvPkJg4gQ3xBk4eW4od7yWDlZ
 lSpbziSW
 X57ikSse7Bj9ggL76L8Q1efIzUXxGtVy/19tcUiCTB7r45fiRaHrcCTLfFcqnr2nKuo2xHkQlbThi6039doOJ9q1rVGzaDo7tLRSvhED7x9G1U+suVEJWHmYSyRkymIocEIP4ZMlc7Aubvga7J8Vi6fNlP8MHfnDWb4SUoHtf9a1X4YJCjsEeTI6yqt2jjDS7kCzJGZ1gnZx2ToqQV1dQi/hl3uWPYNirCg5197mvWy24iZDPj7Flc5zC3oRgtX3MePN8ypQGUaDrjnQ9GeW/FlMUDJzZfOpBdpvNOJJKThEbEE2rToxdHG5OlGy5huftiQjyASyFkrtXTuOiCsQ1yn73X4K0oZJaX6KA3yIC4xGyIY20kS6DAJ6elRSVhpHrRE2WXOERhtDH2ujLc6yiVtnBW4lWlSQHOJzbkA9yoC2k0ZETNZYpVacmwqLplZs0fhMIkRyJ/9HEAa3r4pp6yOcFcGqSfxPKuGVrnX/0mrLLD80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 17:28, David Hildenbrand wrote:
> [...]
> 
>>> @@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
>>>     static void split_pte_mapped_thp(void)
>>>    {
>>> -	char *one_page, *pte_mapped, *pte_mapped2;
>>> -	size_t len = 4 * pmd_pagesize;
>>> -	uint64_t thp_size;
>>> +	const size_t nr_thps = 4;
>>> +	const size_t thp_area_size = nr_thps * pmd_pagesize;
>>> +	const size_t page_area_size = nr_thps * pagesize;
>>> +	char *thp_area, *page_area = NULL, *tmp;
>>>    	size_t i;
>>>    -	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
>>> +	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
>>>    			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>>> -	if (one_page == MAP_FAILED)
>>> -		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>>> +	if (thp_area == MAP_FAILED) {
>>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>>> +		goto out;
>>
>> thp_area mmap failed and out label will try to munmap MAP_FAILED, which is
>> (void *) -1. munmap will fail with -EINVAL.
> 
> Indeed, should just be a "return;"
> 
>>
>>> +	}
>>>    -	madvise(one_page, len, MADV_HUGEPAGE);
>>> +	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>>>    -	for (i = 0; i < len; i++)
>>> -		one_page[i] = (char)i;
>>> +	for (i = 0; i < thp_area_size; i++)
>>> +		thp_area[i] = (char)i;
>>>    -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>>> -		ksft_exit_fail_msg("No THP is allocated\n");
>>> +	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
>>> +		ksft_test_result_skip("Not all THPs allocated\n");
>>> +		goto out;
>>> +	}
>>>    -	/* remap the first pagesize of first THP */
>>> -	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>>> -
>>> -	/* remap the Nth pagesize of Nth THP */
>>> -	for (i = 1; i < 4; i++) {
>>> -		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
>>> -				     pagesize, pagesize,
>>> -				     MREMAP_MAYMOVE|MREMAP_FIXED,
>>> -				     pte_mapped + pagesize * i);
>>> -		if (pte_mapped2 == MAP_FAILED)
>>> -			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
>>> -	}
>>> -
>>> -	/* smap does not show THPs after mremap, use kpageflags instead */
>>> -	thp_size = 0;
>>> -	for (i = 0; i < pagesize * 4; i++)
>>> -		if (i % pagesize == 0 &&
>>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>> -			thp_size++;
>>> -
>>> -	if (thp_size != 4)
>>> -		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>>> -
>>> -	/* split all remapped THPs */
>>> -	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
>>> -		      (uint64_t)pte_mapped + pagesize * 4, 0);
>>> -
>>> -	/* smap does not show THPs after mremap, use kpageflags instead */
>>> -	thp_size = 0;
>>> -	for (i = 0; i < pagesize * 4; i++) {
>>> -		if (pte_mapped[i] != (char)i)
>>> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>>> +	/*
>>> +	 * To challenge spitting code, we will mremap page[x] of the
>>> +	 * thp[x] into a smaller area, and trigger the split from that
>>> +	 * smaller area. This will end up replacing the PMD mappings in
>>> +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>>> +	 */
>>> +	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>>> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>>> +	if (page_area == MAP_FAILED) {
>>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>>> +		goto out;
>>> +	}
>>>    -		if (i % pagesize == 0 &&
>>> -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
>>> -			thp_size++;
>>> +	for (i = 0; i < nr_thps; i++) {
>>> +		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
>>> +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>>> +			     page_area + pagesize * i);
>>> +		if (tmp != MAP_FAILED)
>>> +			continue;
>>> +		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
>>> +		goto out;
>>> +	}
>>> +
>>> +	/*
>>> +	 * Verify that our THPs were not split yet. Note that
>>> +	 * check_huge_anon() cannot be used as it checks for PMD mappings.
>>> +	 */
>>> +	for (i = 0; i < nr_thps; i++) {
>>> +		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
>>> +				       pagemap_fd, kpageflags_fd))
>>> +			continue;
>>> +		ksft_test_result_fail("THP %zu missing after mremap\n", i);
>>> +		goto out;
>>>    	}
>>>    -	if (thp_size)
>>> -		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
>>> +	/* Split all THPs through the remapped pages. */
>>> +	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
>>> +		      (uint64_t)page_area + page_area_size, 0);
>>> +
>>> +	/* Corruption during mremap or split? */
>>> +	for (i = 0; i < page_area_size; i++) {
>>> +		if (page_area[i] == (char)i)
>>> +			continue;
>>> +		ksft_test_result_fail("%zu byte corrupted\n", i);
>>> +		goto out;
>>> +	}
>>> +
>>> +	/* Split failed? */
>>> +	for (i = 0; i < nr_thps; i++) {
>>> +		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_fd))
>> 			
>> page_area + i * pagesize, like Wei pointed out in another email.
>>
>>> +			continue;
>>> +		ksft_test_result_fail("THP %zu not split\n", i);
>>> +	}
>>>     	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>>> -	munmap(one_page, len);
>>> +out:
>>> +	munmap(thp_area, thp_area_size);
>>> +	if (page_area)
>>> +		munmap(page_area, page_area_size);
>>>    }
>>>     static void split_file_backed_thp(int order)
>>> -- 
>>> 2.50.1
>>
>> Otherwise, LGTM. With all the changes in this email and other email,
>> feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com> when you send it
>> out formally.
> 
> Thanks!
> 
> I'm currently chasing why I keep getting temporary
> 
> Bail out! Some THPs are missing during mremap
> 
> Already on the old test. Something doesn't work quite right as it seems.
> 

Ah, I think I know why:

  diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index c94fd64066ef6..4051a5c98a97c 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -95,7 +95,7 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
                 return true;
  
         /* this folio is bigger than the given order */
-       if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
+       if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL) == KPF_THP | KPF_COMPOUND_TAIL)
                 return false;
  
         return true;

Let me test with that.

-- 
Cheers

David / dhildenb


