Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32B4CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323828E0001; Tue,  2 Sep 2025 04:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB386B0012; Tue,  2 Sep 2025 04:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9E88E0001; Tue,  2 Sep 2025 04:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4B86B0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:11:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D27FDC0B92
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:05:11 +0000 (UTC)
X-FDA: 83843574822.29.4622F30
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 70F7A1C0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:05:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N51TAcNg;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPo22dHqGBXNfMJC3YtYSt+ZH77YUJI8Qj4kJSNDPxU=;
	b=WbzDCCN1CtEOQb5qH+GJ/Ksn2G1LeII42Hn1dqXgNffN/2Esu3oU4XrNEb8qXLHq4/4ZAv
	nBD7kvnW23XaAJA/IuAxxjQ3mUoeGx+8l9n3SvPqFblYPuCdZQLR98xszdiwNLnFDaiMon
	FtD1sVV/T/2mO8ppRUoWAeGz8lidn9Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N51TAcNg;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800309; a=rsa-sha256;
	cv=none;
	b=Md36MgIr/8quG+zKFo2MW5lIEP7FcCuNeWITbNIB4H+b8MlS39xTvcSJfPXuNS6lMvsrk8
	aHVu6leOiqf/ZQPlnTp7B9a/rBhjcuwonkbE3SIS36Vw2drOOWqx6jvhUU3XHxMJIz+5fx
	Sg4ITGVn+9suhRFYRgVuea6ZWcWF8Ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tPo22dHqGBXNfMJC3YtYSt+ZH77YUJI8Qj4kJSNDPxU=;
	b=N51TAcNgANyDiw7lrPvQ+2sYIbNwOXTbdWUGYL6i0nhTfr/W+y/a71QgUeJkM0ZZYFvvoy
	eKflE5TOjPdJ4a1VZ3sFY4QZzv2/9qpUcd4MTMAKL7PW9Xp+vKjionlx7YW50IRIepP5ry
	KTJkvbL5MV8TYMHag+ccd/fMmyTt7NY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-_r7FOjqaObi0P8HrtmrnAw-1; Tue, 02 Sep 2025 04:05:07 -0400
X-MC-Unique: _r7FOjqaObi0P8HrtmrnAw-1
X-Mimecast-MFC-AGG-ID: _r7FOjqaObi0P8HrtmrnAw_1756800307
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3cf12498799so2082014f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800306; x=1757405106;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPo22dHqGBXNfMJC3YtYSt+ZH77YUJI8Qj4kJSNDPxU=;
        b=q+3qiHkZMu7h2ZbX7eGuOhlk89Wk2Y5caOyloA/Yqr/67dm10zkO2eXTkqx4qOkP+U
         o2bKz/kUC9wEeB6evHqu76fhqg/t8FJJAQjWWt+My4OgZxUlMCP/tzZq+3H0FzWULB1L
         v7zdo+U1lYs6S95jrsz7LAQejWezGaG1VC5BVgOcoZH0IwtADVaaGvhrKHAhD3/E5rbO
         aQ1ofo5nPQJpXATsY9JMaaI7rdihRGUeXbpNr3Us8JenbLcEEK5XzcDkS5o2L852rMOS
         DTMUROD3rtNsOCA5gQ67z6BOH8cFLhdSzNlQiglFQE1lNAKY4Xgx0D8xJpCqzZxSeV5g
         6B9A==
X-Forwarded-Encrypted: i=1; AJvYcCWKHdI3lawAa/1gTnsfGnblgTdpYXrmqVqWqF6NmUs/GQEDAOQ7Otu23oJzzqgq71snrK9NuHjWSg==@kvack.org
X-Gm-Message-State: AOJu0Yz499WR8PPnIDCcpsu9M2oWotPhgQyDgvvUSpzTghpueMIE6BxN
	UzggTDzlZPyv/AVx+7COvXKFxi+dUTOrWrex4U4kXvckWo0Rj/PUocN60gTN+kC96qUjAfZfN9b
	46OTN9cjT7NQPKmeB0k1HVZrSyA2Q0m0RnlxMppccZYnfZI3RErm0
X-Gm-Gg: ASbGncvrrU1wQXYC6Y7mzWtXoQAVxwI2caigdWeKZ4p6lew9gpnwUzGpD5XRTJT/gSU
	r/5ignp3cBVD/lU4pDwxHtHotXtExBPBtbwO2RoRfZUPjl0aUWSiS4mCyFguhdTQKizHc+f8i6J
	G8aCRGox6Z4q7wEW35oOHa+oMsalsMj4OoFsNiKNNUBfocIm08iOcnGGuCBhpmikb5zGBqGgEZu
	7ELI88yLphn30RAC0AS/Hqr4hRQV5mIjjmH6sVnwhNXRAWdf8Jmfqy8JAfEReiEvXrwAmzMFglZ
	aVu5sOh5pVRLq0FD6DAVet5RTfe4robncee9RH2dTOnay+bxp4lkr4HWSO1x+S0O1gp7O74cZnx
	roHRr6NwlhvFIYWo/ZL8lNsGaNQkUn/6iJSut11o7qxRjvoBPXLBa4OewKFtKlehn7rM=
X-Received: by 2002:a5d:5846:0:b0:3cf:2700:6815 with SMTP id ffacd0b85a97d-3d1dea8c5f7mr6987992f8f.41.1756800306407;
        Tue, 02 Sep 2025 01:05:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzPAh6/Ctw87y1nU9iTpmGdZ0U+BaubKbfxauYz4I7gupbzMzbOUFUgEPl3x3u19pXf1/bLw==
X-Received: by 2002:a5d:5846:0:b0:3cf:2700:6815 with SMTP id ffacd0b85a97d-3d1dea8c5f7mr6987903f8f.41.1756800305758;
        Tue, 02 Sep 2025 01:05:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d7330e4bc9sm6704550f8f.10.2025.09.02.01.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:05:05 -0700 (PDT)
Message-ID: <0f9791f1-ec4a-4517-8ace-945d3437ac74@redhat.com>
Date: Tue, 2 Sep 2025 10:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/12] mm: constify arch_pick_mmap_layout() for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-9-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901205021.3573313-9-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PpagsVb_LfF2mq6lG-fCE5muSwpQ3UtiN6McclSrMao_1756800307
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 70F7A1C0009
X-Rspam-User: 
X-Stat-Signature: m1ynke13zhxi1r6pm8qqqn46f43uke57
X-Rspamd-Server: rspam09
X-HE-Tag: 1756800309-344475
X-HE-Meta: U2FsdGVkX19OnePhuDI4k48srOBVu0olLzIsJ4oND41mgnkWlUZWYgF8jHD80uoKK4pAH/aW9tmezbK3Eo0tF7vw32QTSrCsResQfp6Z3bvC7fvcHcnBpwdoK6MFlHAfg813KqSr00j+8LYSxvBbGaWqv6/lqzwwJBFst8X6oL6XbtILRqWZt5f536MQvJpWT4hHi6TN3nIIT2yHYNmxUJFB+va4q78gZG2k+aeX7gVJe+PCDWcGF1Heb9fsteyEpVLP13bIXaAcUqFuEtOEzY+lrtSpW8dGnfpSAhEayDjWj9pglppIPdVIKVDGV6SoYSBANipjMIxvO2nElWrw9axM5kS4VtznVnvWQZwH5/epu0b0QI02wSAIBjJYJR9royE9qnd7Em0+eGZ5AlTnFxuZSMCyJ/RbiBS5IYFRt3dfphMZqc48E2mOCnc1QfoeCr5Q49SxM/4rOalnhsHlxlJzXGXPJh9xB0jvDwikEdWkykf9Xh8UiJrnQVCHMBusn0Xvd1tK+nesrxdxFqBqdtpy/rBwguHNbDp+atbByL21E1M8Gh8b44MZOKEK8DE0nBHHON/iTYUaAZorcNbdUCpUuHtaDLuzP8jMayAv3Zm1gop1YtquWE2jAxNBHM7mENelezu52QU83KIRA6Oxdq/uDOe1Tjv+lVEDANmmHEuwb2HU6RnN3WDeIjIuqf8nFrXDJOD0Gpe74xQIc4DuwrXtWYu/rR/+Da+gzt2C8ijCZfUmFFEBCE45ORgtypaBgBM2JVWtllF790OD73sNs/Phn2mm5ApsfTwqd6rk0KUWkt54IgPKIUwrhM1D2+e1SnSv8D8OmVBqQ8UAsJaOih5voYftyRuDQjL/xKVtF3scT2bNYLk80jpWvKCChIsBBWuKxosi+VfNT/01bN7iDNraICmUCfrnb4vMIQAKE1jG8COAtg8FykytDUCIzZRI82lu4GYf0ghzAZJR03x
 nS97hRfs
 LO2YaNwDRqizzNcFoXKBaMYvgV7at2yThhyx4qL3RiTN/pAJWhOB4/zAnQ+5TE+IY1uZks3SrVhH6PqEnq3Ssey+Whypcvt5DAjk3EyhIlHhyLldAwtp1BDYCLGB5zQ+xaLzP7qaFqrYrUyArZEz0cuU51uYujnqxTencXu74qePBnawULThKzNg9Qu8+Rz0Cb5n3GgOwSSaCd/CvDM4ZSSKc2cxgZ+SjOdDeYIgClN5dQmWjwVz5YRkrlJpCyv/68iuS4fiQd7L0P87ktFTB6U/v7swLPhFmUGHySzcSsBCHRAx91CpT4cLReSvlU9OqaN3fJmrjmd+j9dn3jCNph590lwGb2a6zOkMkSNS5Pa3bWtIRyMurlQiVEELPDNbT6FTdhXycMwvsc80oW+s2RST/hBhWH1lKXxbpP6t7UgJkNGgKCpVLCgNWBrmrub4reYh/8VBemUBlSDDM12jq9PQsNPlJmT+7Hf1QFPEzOTG8oHw+DZs9S7knv9OZtsNK2l6U6PyEK4UmoBHUBhQA1LmDeVqN2FB8BwTLyrJVAyZgtTobWQja9BBR7wgYT45vPEXvieFnFGPUnUG8VUsFRb8HREBlhkxqo7gM3kNmx5o+yU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> This function only reads from the rlimit pointer (but writes to the
> mm_struct pointer which is kept without `const`).
> 
> All callees are already const-ified or (internal functions) are being
> constified by this patch.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


