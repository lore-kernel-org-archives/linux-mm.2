Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D327FC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4542A6B00AC; Mon,  4 Aug 2025 12:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BF36B00AD; Mon,  4 Aug 2025 12:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AE16B00AE; Mon,  4 Aug 2025 12:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1206B00AC
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:20:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C153F5B186
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:20:43 +0000 (UTC)
X-FDA: 83739588366.02.12D50E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12D932000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:20:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fqq7mtNF;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754324441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmcerhNKzNmjyRr4sZ9dZ2KiJbHT0jTKc2OnHcaBr5A=;
	b=tOCa9Ik5U+tfTfI2QAw4hgglBbfhshO2jEb+NKs31KRkY6LG7gJlPA4Se0Ii9H3hDTQ1YY
	DWiHS0UVMwUf/yW+EYQMP9WRljP7CuFgoMeQOTgdbo5leHWFMnsBZctXNZbAH62Ta2wE+o
	fuYt1k7/n3Z2PhHTU1MjylwO8ZuvRv8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754324441; a=rsa-sha256;
	cv=none;
	b=c3KDjkI0QknNX13LDEjsMNGVjIN4Oe9kh91zAQJNUvR/0lX8eYg3YFQaJgQLucq/KVadXw
	uirv6STLPD5WetKHW86u03zESt2+Q3NyBNHnA79G5sUuwqv+kbmxolgXvmO55rzfzTMtOb
	tlRmDqzkfgx0qb04KWTcfyUtxZpG1bQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fqq7mtNF;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754324440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bmcerhNKzNmjyRr4sZ9dZ2KiJbHT0jTKc2OnHcaBr5A=;
	b=fqq7mtNF9mRU6prZcvlVrT39LDkuIcRbMWBrGAhfH1oCFTE4rxBvrlqR98OVSFYXmSxUfm
	RwOHYZdmqYhyzxtURlkBzDCBFZ4I9nsaGiNpyM8S/FZ64dZBwJgFo5nOlglv/i5CSvJovZ
	8Y89fgyU47NXlm4PPGiMWfA9AI+GNas=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-M8SUBvMQPwW1uAwKbqvImA-1; Mon, 04 Aug 2025 12:20:39 -0400
X-MC-Unique: M8SUBvMQPwW1uAwKbqvImA-1
X-Mimecast-MFC-AGG-ID: M8SUBvMQPwW1uAwKbqvImA_1754324438
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b783265641so2925242f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 09:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754324438; x=1754929238;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bmcerhNKzNmjyRr4sZ9dZ2KiJbHT0jTKc2OnHcaBr5A=;
        b=SnYnenU0OcKpDrpTeQ9YC+HSYTShM7AOe2J1TOtEB0d/d0jBJI6LTOu1A5zhWdZBSf
         yFcdkiDbtXZESnFwANa7X1eZhDKv4KB/vY8mONK6FoQcThfHqxJAHEX8fiyDaTvENfYc
         o3pZMpncklDBwIp1vKbFiRS9D4MOcjBtI0qNh4lX0O97wmYstQMS5DxrAmUjEYQs25PV
         1a+q/zWzerg0KCHlrFUpQswygJHT8GdERfau/JaH4Apz29YjjJ+A3X+88tkVdKHodFDM
         ASqtb86RGmJXPX+hPMTytf2Z+AlToQCDYR792rJAfviX378iyW8+V51jvqAAxJmCYQPn
         xK5g==
X-Forwarded-Encrypted: i=1; AJvYcCXXU9Uep5BZM/gBahytvYgwGFEYlRGOrZxGSX48CKFW2tKrI6NYgH6/E0TqDSickK4pBQT7ceSVFQ==@kvack.org
X-Gm-Message-State: AOJu0YxFUYCLC1Trksen2i7ofrJCFxyQYwsX3Jz03SwqJehV52E5Cnru
	bS2MlfYMjiopMXJqmnFD+E3qQXfA5o7VNoyagNZdDm/A0vIV5c5i/lHy5kUPubaDGKMJ1PZB0ox
	MHIh/6ItVjAXddNsk6B4yIFzEz+htcossT1JTPdiSndybVMCWnEt8
X-Gm-Gg: ASbGncuaOm3F8MbpdnvrUhCtY9KYl/vCt0p3iY2LYcxPOJwOx3APRw/Xk9+lfkb8Lra
	tj94PaKJdRcnaJwZfKXEyLmwOvwaXDjYbuxRYQLuf2/17nBmjmw0iW0zLsrut9HYmX9H+TpDWcL
	fh5lSqJ/6O4oNAeBJ3+vG81KF55V7x7BNuA8Xz/uJOBDUYmmWZltE2REx3gkTindxGYIq3CQ7Po
	EZHUlfF9nkU+/eZDLRFOUTdDzYNOqj0vVQiRQauLlrgcqNk2OQKSZX7gwWTa4WM5b+xLed66/Y7
	u9NYzGpMjUO0jIoi++WTA5RtVY6onUyH7LTsB5Tn9PXz+4hpXckwVh70vts0Dzzq3gKID8WGnXz
	6txzsz7HOf+EQmDXgUd6ZJr1yt6BZkT4GM2vPoTlraYHGMeX/7414wDE3n0e7AFhC+o0=
X-Received: by 2002:a5d:5c84:0:b0:3b5:dc07:50a4 with SMTP id ffacd0b85a97d-3b8d94680admr8012471f8f.2.1754324437834;
        Mon, 04 Aug 2025 09:20:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtpsZO2E8iNDmn6PTMkvZD6V3Ng4XKWdcXLa17P8AykUV8Nl1mYZ0d9GDllhAf/3anr0k/aQ==
X-Received: by 2002:a5d:5c84:0:b0:3b5:dc07:50a4 with SMTP id ffacd0b85a97d-3b8d94680admr8012434f8f.2.1754324437380;
        Mon, 04 Aug 2025 09:20:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf93dsm16081235f8f.27.2025.08.04.09.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 09:20:36 -0700 (PDT)
Message-ID: <9306c53d-6c39-4e47-b541-e25dab528e33@redhat.com>
Date: Mon, 4 Aug 2025 18:20:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-3-kernel@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804121356.572917-3-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u7WxMyDnVSPtZqZwIUtkO7lbFR2caciTqj9oNSBHrFc_1754324438
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12D932000E
X-Stat-Signature: 93atbhoo563dry1nyzajo3xzahqrhbck
X-Rspam-User: 
X-HE-Tag: 1754324440-427382
X-HE-Meta: U2FsdGVkX1/eO8geZHa2fKrO8W8SO8Ms6QSmrBeUksFEJAllKCQAKxsXSkNnpTda9wTQB9ZN4zWr5wLR51b7UpDAHoWM6GKkRLfg1l+5vsX9lKcIpJZL2w3Nz6fx1YmjboJS8zSGx5ScyeWa9tZeJRjfBiqkv0OEiuaGduvyCtfiQfN6H3DgAi0fobOrbFiFi2Eycy898W+RH7f6KS+QcMg+7PWG0ODKYGWKN49U5EgqqaoSekWSaWh/Gz/aymumBAe4NSodV31kk59kBh7TQ5QZpIk2gkg3TIylg3EO3TpG0u+VrP644DUFcinx3dzy3mTO4Q7Wopk2hvZ8riiibB0/OqGIVWtOQy8TnGvrabYOUSgLKnIS0xxqjrwXV+BQBCd2KwhwlUeUsDrSu/NVW/qgQhra3uInQqR8NQfZXW7TuMpZMr2PUn9mLOeVRFSo0IwWHWsXjWGPDrNR19oBtnpd3KyHw6LCtZwBG6DkD5yinJwEjVbhre3qXO0FVCJuNG7HJGtRj4Ga2DIF74G0dj7HWzKZ+HiIV8DCPy1kTdGUyXKb+MVsChYK+35XcCbVpbKLzyz4AhDHB/0bw3eOlwpbcqh8Ww7O6N6nFMyw64DN8ceChVRkQRIwKHusokbMheqqrmEl8CmODXrpdqMarADjQqkWViHFGi8YG6hy75gnhQ3qwzFE0C4sliHihhpdCi4zxebAhiOfcRXdiLhQ/IAqI6/HFd6ZnPLNHwTeR5a6LuKe4rlibtdM3nSlZOl10ZJmc+zZV6VqIeSU7uAnIQtRAa6SUrj/mks13vOIsRXGdLlhDsZZmXKreIW3arMNaA4h4u7wH1XI0KDtC+oU1ANzJYzZWEV00E9xPBLOCh+Fw47n/VxPzTIsiTw22As1qqGcQcqQ2KK/Zut1XhC0S22ZoIa6Xc3OtVTI5IGK+1JiJjqsWfnqBPPf5YcZW8G3lFi0/skB+AhmKRZcbRK
 JNq58ror
 iwbNTG5yPlo181aZ/lpi6zJ+F+CBn6SSfsMgmkqMwMFojjRoNd9p3dMmuAKD/vV2rfLpMZP3TJchvcj8Xieepc145lhbzapJlKVWNxQJsulPlAceXHqkMaSuY2xHfEzZoKEqrMs1wcrTmchqMkLU/nH4mih4d8zGLmYi271CIrxh0NUJCiJh573KO+KH5Tv9vsT5lRV+lqBEWLdmhHQC6ICz9UTAQhs+HryLnQh6kyJBq7KGAqR+lA9mPh46U131/TEaFXn8IaOD1HWQLtUIwlcqFfHWMJM4I0ZkW3d88w/LeR9Qn+W8vEHE4CgzbN+wi1zK8lZQKB8nzS9n1nsJ81umi4ebWFrgvpFZHXX59aas8M+lBqyq5Bjtxs6JSC/7/2TmgpCcv73Fg8QqQyMNRKDZXU+6Gs9Sz0Z8ePDsiYMAN/+tfknYCKn3JTx7Pul4bvWRC1tL7oyj+SN2QZjpWTYfa7R4CDb8FJu6I5ZeiYcG50fWZA0unWy5iwdTpJnhAw4+qo8ejzYAmco/BZ0PVX4iIu8BVNCigkFbVaVvue7alHqC2kUGBMnagUX8zHpDuXBaYpgqucRc3iIyLyqQx1wsgjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 14:13, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> As all the helper functions has been renamed from *_page to *_folio,
> rename the MM flag from MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.
> 
> No functional changes.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---



Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


