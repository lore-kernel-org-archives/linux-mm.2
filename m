Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754FBCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 21:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF88E8E0012; Thu, 28 Aug 2025 17:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0558E0003; Thu, 28 Aug 2025 17:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF248E0012; Thu, 28 Aug 2025 17:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A07D8E0003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:00:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3AB0118FA1
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:00:09 +0000 (UTC)
X-FDA: 83827383738.21.4BEFB81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FB3D4000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:00:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ec6T5n9S;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756414807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkSDgbg7xWQW+ISMkJybRnH1oyxatG6U4F5HRgnHqwM=;
	b=Xsetaafm9QC/jFuDrEsARdeBpXfihcqfsBJ4d69yv95KMj4Vx206DHmFQSTLXJf3Y/86iv
	hocoDmaEzirc8f9iYqsOMzQufKkseLGJdY+GtIeYoIzXiTu9Cv6vuEyggO39jh7nXZ9hZZ
	LZp5nyBAYsup4/D0PxTFfXu7GJKMS44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756414807; a=rsa-sha256;
	cv=none;
	b=v4uV23E3JiM8CotBTPzBycqeUgI89p4edcAXIcNipQBRPX+gStOfq4JO0VeGEL+vWSHeyk
	Sut8PjxU8pPNHACf22YqBK/os2lxGx5vVFZSyJxHNHHPaOoXMskBcMg5yGPdSBJqizj6Uh
	NxPbaP1bQsUOXbvFbvOnlgeLkKxCQxw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ec6T5n9S;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756414806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mkSDgbg7xWQW+ISMkJybRnH1oyxatG6U4F5HRgnHqwM=;
	b=ec6T5n9SeYPE9qNLZCvPuDh5cVUTMF4xOtuMNi+GIjRfUb8KxZWbUitj0GstcMuDMGZYFt
	WvU1zzOm8MQPEECKw1I/YW8mcB68gLkiI3WpryLU66t1EmHg3U5jYqrk3xUuxnsMJs/Mok
	4RIoFir0vQy1m2J5ZuCtIV43l8KQyfQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-lycxChl-PnGef6qGRs1seg-1; Thu, 28 Aug 2025 17:00:04 -0400
X-MC-Unique: lycxChl-PnGef6qGRs1seg-1
X-Mimecast-MFC-AGG-ID: lycxChl-PnGef6qGRs1seg_1756414803
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so659869f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756414803; x=1757019603;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mkSDgbg7xWQW+ISMkJybRnH1oyxatG6U4F5HRgnHqwM=;
        b=FXJ3GkYQixgrAszRTikZAIpSarvY98Sa255sI/Uw8yThhtoDy04ooVsp15axspQQPk
         yL/KdYf3QGEtKOPPVcb2CF7UaiHF91fN2oVT/TKoJLwLjwYr+tV+1xeNcI4XXohsGFJQ
         zGVEhEKq1/n/FJvy2YTWsNkkcADvnNyBFu6PgOVcllfVrlO5ZD3PPKwozBzs0nABN2ak
         qU6OVEEPYu7jYSAscTTkDkM04OBotKzi6PrFxrg3/Q2T8dKKfzbR1PcDG6uJAKLWnarG
         2R7vdDsvXCPsQvM47hCgSHYAmC5CL7a6qLLoglyDC+GvW2GSAoNoqlCFWXU/UhkKRVu3
         Ps6w==
X-Forwarded-Encrypted: i=1; AJvYcCVfz3tdw8j0D/OcAb/XtX235PbBvYK7IpHSr27YIFGWnpe2/gu5h6s/oCfyfKe4lCJ2/qYqtkhsfg==@kvack.org
X-Gm-Message-State: AOJu0YyGl57V2uUPqDxMyB1M0KHefYamiv3nHt0h10qhWW/4rxZXxUQL
	+LN21p/GyCz42xC3jyYmiODyFWuUo2exRVHQXi/exH7IS22lokkJ7nET+Df2+x7AmrA+eWWmDls
	pqKMnaWMCfvMSCwa7atnjE/5A5xIs9Pzvk5pvvFiQuBEz01W6bLX3
X-Gm-Gg: ASbGncsXThmuhIjN0lwQChNx7M/0yu2XGDdoWwEZCxGYgmgRdxv7mmksbwkxMI+lf2M
	8ic5NUTrd0JRBrmFJuPcPOXY9cnZze/UpdBFLgP26iobpn2fB/zOxFj+/1fYh+Vmn+kIO4amH3y
	G/G/MKzAQRDUWL9kMq5Tc2eW5yh7WrDhUzETYXf6mRNGEfETLPp2KMyhHRlY8+EioF7ZUzMaJek
	7AXXNxkaUKnTDRMLsqZ93v9dXuprwEQZ11R5LW3RaNWhl+uIZJDhUHENi3hrOThLs9+bwiwGxu7
	fyzCcKFqg5/PkufBK7rUf0ZR64fD11H3JNI8tNJo4vcU3hcC5RfNmvssNopYhrL3TkqL5YfO0Lu
	3jyPmmlBQL8fEPKfybKVmjvlbBCxGaC0XlZScmstAktUf04wafu9nDR59W528DwcJA6I=
X-Received: by 2002:a05:6000:2512:b0:3c9:3f46:70eb with SMTP id ffacd0b85a97d-3c93f467c6amr12443228f8f.52.1756414803133;
        Thu, 28 Aug 2025 14:00:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6weiB8uQZLlY/pBc/wBfkqXIMndGWCy+/j+66w0gqGxnhnpdmegVfF1S2/N2OWbRnBL2yuQ==
X-Received: by 2002:a05:6000:2512:b0:3c9:3f46:70eb with SMTP id ffacd0b85a97d-3c93f467c6amr12443198f8f.52.1756414802646;
        Thu, 28 Aug 2025 14:00:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fba9c4sm613412f8f.48.2025.08.28.14.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 14:00:02 -0700 (PDT)
Message-ID: <7ef927d8-190d-4b22-8ec7-dcb9f5f75dba@redhat.com>
Date: Thu, 28 Aug 2025 23:00:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-4-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I-bdCJoiViIelht5TXjnYSmvz1HUqGMLMw2oGA56uBo_1756414803
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FB3D4000B
X-Stat-Signature: uh6h7yoekfc4musay1dtnihyikw5yu1q
X-Rspam-User: 
X-HE-Tag: 1756414807-7958
X-HE-Meta: U2FsdGVkX18S4ozjC8mPTwU0vg8lGVgP08/QNEI5aaVL1TqXDK1pv0nY21aTWE7yHPWB365F63lYl+IUPkQks5c89ijmlYGQyB+hLgSnTSfGYCIfHL/2tiGingqJSmwOlm9NG1wVGXCHXRjteN5BNvrZEHB+q1Sw+0dqDlrubZIdPPoSn3a38cexUJC/DQpevQsigXWTJomty9NX5fZwZxeXTuFsEMqFDV3fjVHvAsjyor2rp6jPYXAXfngDJO7oXtChe5t1gjDBF+/tcALirqgBAT9df0m9omUY1p9r+jxde00t+PVg+hOBih/OTVLdH3CSIdNZAGEMvQLbu285Jo9YqENQ7/imbUOH/tz1Jvw6OWdBUjtLkTsUIW1O8p9y3bVuB0kiWaeWqQA7vfdeowNXtVS7145wJ1G8nUvcK5xBQeX/Wd8WfsPpLUGgz6uTuWrdVja2s3rGL9BjbuOk8BgeLzIZEMzQFeH/C6ccn3fz9zy5RshSFPJlVDwx/cgU5gla3yonqEDAzFbfiqq1WrqWfxvT/DYj8ZnNp0fAKlO6fl15f93c+K7AkAdcfSG3ocNxYtNElSaJnlPkftE6yMrbpcT+JVHUKpBubYyYJGWQBE89D1V/lhOepxnKIZ0onDvy30bNHjobuCUInWPK+Spby3e6aGcP+LCIUMFyp5s5LEZYIMTNDsXZbqMTWOeWoqmsOB21dx9QKYHwSw6lHUA3oE5JQNvpciDt5kmCmoaAYoWuBwUpqBaeDo1G/bnvyr2co1cxOE/9sG8dGkZtwZREk1OKnIv5tQhDiSrPA+o5BbNMG+WIZhS8YHw64LxrWnger5azeu70FZA6ZGDG0OIBW7Cfv5ypQy9Wv5gMnaYF7GAUT7XL0vARqWphdAQSBARy1BO7KRxnqdyaxbpLSdiI33jtWuprH6p9xZ/PbZXM0lRE8ze5btW6iUpHg7JpeVVor9wTQhLfdUGB1SR
 IzH2JbrK
 K1MZo0EJe6dVFc80dVR12L+JJcTTqdp33KtJ6Fgr9+wl5Wx211iZWLrEiX63UNiMoGUq59hzPCAAdscTW9XrNPihWaBB3xy5eL6dC1+qK1L1vKkLMGVYrP7v8mnkcFLTrEw6qE70FgNnGz+rxGMNE+KiIyQ5ZLqPpgT5WdJlqrtVgj0aYfcykXiVky775hjLMg4PPjixI390YfpYOu/llcyCssWiqwPdxvKP+s31wb2oVMi+V8UcecQXIyQT2bG+2UYlKHxkugD8tCnMxmj2qEjHkknz0glYCB7aOGSUzFZHkJBvFH+mKy2qyOUZE1JSeMgqr9rJPhpq0p3kRFY3MfQRJJb6WAJV08bh2dWUjnauC07Fw+lvEfzYn5nQdPDwMviZLEYph/Cz/PfW/OcJekXrjWiKbVK+H1nlyFO5aJCXIqMOW7+xItMgEWB54GD3hJ7FWoeS5C7w64GtgnWr8O0GFdekcIiQbMaGzGPIFWb+c3NBbMwt0sC9adfAHDKldGnHJ/YcRSfhg11kBpDZ3TolxuCqESM+ERQMH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 11:39, Roy, Patrick wrote:
> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
> set to not present . Currently, mappings that match this description are
> secretmem mappings (memfd_secret()). Later, some guest_memfd
> configurations will also fall into this category.
> 
> Reject this new type of mappings in all locations that currently reject
> secretmem mappings, on the assumption that if secretmem mappings are
> rejected somewhere, it is precisely because of an inability to deal with
> folios without direct map entries, and then make memfd_secret() use
> AS_NO_DIRECT_MAP on its address_space to drop its special
> vma_is_secretmem()/secretmem_mapping() checks.
> 
> This drops a optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
> 
> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
> set by guest_memfd) because not all guest_memfd mappings will end up
> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
> can be mapped to userspace should also be GUP-able, and generally not
> have restrictions on who can access it).
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
[...]

> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> +{
> +	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> +}
> +

"vma_is_no_direct_map" reads a bit weird.

"vma_has_no_direct_map" or "vma_no_direct_mapping" might be better.

With the comment Mike and Fuad raised, this LGTM.


-- 
Cheers

David / dhildenb


