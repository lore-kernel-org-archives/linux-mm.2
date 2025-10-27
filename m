Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C43CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4919380070; Mon, 27 Oct 2025 12:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442958000A; Mon, 27 Oct 2025 12:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A6D80070; Mon, 27 Oct 2025 12:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1932A8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:27:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D33A1A018F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:27:07 +0000 (UTC)
X-FDA: 84044423694.27.3B64A35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B3B5A001B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:27:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IGx5uxi7;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761582425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFGTrLXSQViuLtwu+2VekUSYMKsImqKp1Rcio5lWi+8=;
	b=yhT7vQzAdEuitFGy9R/cfhNHv9l1cnxXfWzfloU3bz+2Cqvn32qBp7k2+6+HyFBPmHyohE
	Xkeky2mfwdJIBvHooNdpx4cfwavyAd21+8XuJ9AuCmpEbQhT+0TWjnCOxF34YChDYHRcid
	94z6/nf5O/6ZquNs9tg1+XXaEPkieQI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IGx5uxi7;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761582425; a=rsa-sha256;
	cv=none;
	b=ZRaqU8M6v+3D0n88n4JJKsxjSIyXoUwq5w6w4APpPaK3pUUa+Lj5Mj3jfpK6Fc1VZH3/SF
	1GMwahdxxiKsdXuHq0NGPZodu7z65VZFQn1UXSNKxYPRh3r3QpO60/qZh/XgkFTP/nLj/m
	vGNvl2iwenoPBjpCl/ojRpmRIXnQenQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761582424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gFGTrLXSQViuLtwu+2VekUSYMKsImqKp1Rcio5lWi+8=;
	b=IGx5uxi7AJCSUAKwHzDXcKwwxaVQyEjaZiljIvT6/ebYSFOKgbfAKmxETSPQlir9Xdvg3t
	5ZBOVOq2k8hu2aCTAKs8QTMYnVkuYt/sVp8sLEo23T5djMjBxftv4Rav6GmOgqNuwpHGx+
	eFkrVMCS+4g9Zaa48hsoxkSvMUqO/Hk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-EagkAWH2PVKxe9su9o1FaQ-1; Mon, 27 Oct 2025 12:27:03 -0400
X-MC-Unique: EagkAWH2PVKxe9su9o1FaQ-1
X-Mimecast-MFC-AGG-ID: EagkAWH2PVKxe9su9o1FaQ_1761582422
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso3266515f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761582422; x=1762187222;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFGTrLXSQViuLtwu+2VekUSYMKsImqKp1Rcio5lWi+8=;
        b=mI7j8NtSXvmJbrI5IKfQ4lK0YIZcZ16yQ5tosDBbXimwk0WAbWuVFpyl7+kVwMP9Jd
         I8+Sn///LL1EwUxzhlBR9b9z60cbcgnW+u4kpA2pCBOl8DAHrZYNjSAqjOrZMHbsrtKw
         O7aB/1IqBiKDoOL+2IzuX8/WI9Du5h8gDH5catfvpdZuQ3Fn4Te73uC+I/ZqXIIxMMlx
         w3fyJdBzqje7YXhLc89L9B/Z5n+uD5hnLN/NrIvyWC9OPj1EDA0c18r4wk4lPg40/1nv
         jPdta8UatmbM/SB/pQoUSviMR9fLxYYWsKeuU46mIUlgHfS+6Bw9QHs5FFB5EN4XET3P
         6xRg==
X-Forwarded-Encrypted: i=1; AJvYcCU+++Ez1eQUkcyCGUj6LOC6t8+Ziiq4YIa8kDu3MfA661jzbWpcscQ6MvXzk9SL6ttw3hCR2d/zmg==@kvack.org
X-Gm-Message-State: AOJu0YzRtSKCNdLHgscGk0TFq6dH7aFMI/jKCje5OzTUhsppnBHw8AfY
	uaideMw3cW7lmXo+GFjKYWStPUTTtvLGLAvZBQ8FyKzW9SUnM3X9zDpBHetvG4qrFq0ttEzqSdZ
	BeoEWHX3AfBv6a+TzgymGixSePcXa9Pz6gGS6ADH/xmAR5TX6pT91
X-Gm-Gg: ASbGncvSP7e5mTjMC4a66QutI2NhOTSu0T4qrNqJbCKgzwfT6ZkJJbtb9ynHVfbcv5J
	AX+8wfNdSHZOdPM1HIbvWdEZSYyyuCneppYNHGdHQbq9NjR5UWO8RXrLLFjb5Kt/Yc7Cq5jzEoV
	/PCQaTXeI299H658+P5qxKWPSMWbm0DmRlOHf5MlH2eC3775SzmzZWshWQHCW4QCoHbQkqmsawQ
	qGU3YbZHFNqQz1j869EyIRGQrVqQ/WO0P2kiagLtBduUVpyudCgKoBlcJzU1ywZnCHy6kle5MiF
	XI+6QxES8vAWPwo18A//9RRLf32DtaHkLeX/8mI/HLiAtOtzVKhyJ4CEz2vmPwQy3Sk/TWDkZzs
	yOJb9nyUR3pYjisUoQy9Q/ylywTF/4ZrFahVWbEmJNt1L8kjwH98ubHu2T/QNlHWBkkMqK/BhcI
	i3lfUBOD7pCT2dNxz2kUXJEC5mMNQ=
X-Received: by 2002:a05:6000:240e:b0:429:8d74:4b16 with SMTP id ffacd0b85a97d-429a83dcae4mr27393f8f.20.1761582422057;
        Mon, 27 Oct 2025 09:27:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoo80cUWX+0e1u72oeksXrmAM7quVFts+JpWS6K9jyENOeTtl/MzibHxpQ/ny1e2QhKFedUQ==
X-Received: by 2002:a05:6000:240e:b0:429:8d74:4b16 with SMTP id ffacd0b85a97d-429a83dcae4mr27364f8f.20.1761582421600;
        Mon, 27 Oct 2025 09:27:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d9e80sm15164870f8f.28.2025.10.27.09.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:27:01 -0700 (PDT)
Message-ID: <20745ea3-4bc5-4032-ae61-b928f2568175@redhat.com>
Date: Mon, 27 Oct 2025 17:26:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
To: Dmitry Ilvokhin <d@ilvokhin.com>, Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Kiryl Shutsemau
 <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com> <aPstDXRerYqi1O2X@tiehlicka>
 <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com> <aPvjFuio9lBKf2In@casper.infradead.org>
 <aP-ciK_NsCPFZLHZ@shell.ilvokhin.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aP-ciK_NsCPFZLHZ@shell.ilvokhin.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: imFmvRdUdEBcKvwCnnPLPO4jsi_MXEjoJz3o1S06Npg_1761582422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B3B5A001B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kjarcjxhu1zrops4eae76ezf871x638h
X-HE-Tag: 1761582425-267793
X-HE-Meta: U2FsdGVkX1+prekNslYlgeY6VvTsxnZoS9AU+dXuG1zuex4WbPTY23jqQ7oKaNknpm0RTRm3IOY+Q1wH7LAgTxskDWpo14FcBEE7hMAC5DZ3aeSEu4SOz3OeESbnpwEvXQV5i9mSwhYuKlnYZ5wzgCv1xpdE6FzT8eDNuuO0H9U8wCjKFBaRWCvpC7ITr3sANwJtC8m5CHVRzKQdWCtgSKCb/7Mo239ROlTGHmPpbUYiiU6dTMiSUfri0kxUAv6BESU6Nx1CMbq1a4zftk+/sUF4txGFlNgbtHwzM2NgM/ZBu3m0RXIst43b1BN4IVynlloJVytQtG1JNSJRoLtecGg3aMvHCvEfXx4Q2uvkENgWEw4wQhOjnlUdgeajRuluo0/BvwwrwncQT3r+heuGlrws3hpp17zHlWRxQQfB/QTWGSnffhFyLMskIfHOlAo68m3eEEOA3Iu3YvbIMkqqmqX/rh6p3s1hxr91bnur/Udv7OG7mp3lMHbRomxfxetLS5YgYCy3Gifx62BKLeie/9n1ifbb1vI7N556EF6DagKOvj5fmSqEtyoufOINLvwUPEq88QGPd05y5/6pHmxuyyG7lZHJbPupTlo7y5gH573uylPpbYpQ/AA55ZMACyVWD8NYWdbVrn/rSuFxeXfpkm/uoHa+oX9Kd1w8PiFPk8tdxE/5STScyfDmgQLXMD2M6oHtYz02TQYzf08lzNfgqi1+UXLirYbQMLW7nxOO5Yezy13Zoz/ra41SHhkrBKKR3vc7YY6LdmTDgeS75G6yxZxQbRtFuG0z4XwfIwrj0ZoKri7MTRLfS1ZYZvmTWjlRBmuiGyzPEQBBa71B/rmydZYdUKewQGvWdqQ+7B/cFcnLfuiNCC9ie/36aCqU0ZgVidp4VPMlut2IJ21yd9vEW4E2TPJIlZOau6q44nPlqZfNzRU+QLHs0mCJqoIcv+nbZZEVUZkbiAgFRdblU4B
 qZYlUW0g
 3Ya5nN9No8272RJa6mV1oZL3AImU8G/pvpas/XKBzxa80N8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 17:23, Dmitry Ilvokhin wrote:
> On Fri, Oct 24, 2025 at 09:35:34PM +0100, Matthew Wilcox wrote:
>> On Fri, Oct 24, 2025 at 11:19:50AM +0000, Dmitry Ilvokhin wrote:
>>> Primary motivation for adding config option is to enable policy
>>> enforcement at build time. In large-scale production environments
>>> (Meta's for example), the kernel configuration is often maintained
>>
>> So you work for Meta?  It is poor form to send patches without
>> disclosing your employer.  That way, we'd all be able to see that the
>> positive reviews come from your colleagues rather than having it look
>> like everyone's just "oh, i'm a random developer doing this on my own
>> time".
> 
> Thanks for the feedback, Matthew. For transparency: I work for Meta, and
> this patch is being submitted as part of that work. I know it's common
> for many contributors to submit work-related patches using personal
> emails, but I can understand your point and appreciate the guidance.

Note that Willy, for example, signs-off patches with

	Matthew Wilcox (Oracle) <willy@infradead.org>

-- 
Cheers

David / dhildenb


