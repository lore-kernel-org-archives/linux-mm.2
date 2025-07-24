Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D71EC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D51B8E0076; Thu, 24 Jul 2025 07:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EEE8E0074; Thu, 24 Jul 2025 07:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800258E0076; Thu, 24 Jul 2025 07:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66F668E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:57:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2222E112B33
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:57:41 +0000 (UTC)
X-FDA: 83699008722.20.DFFEFAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC99B180007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:57:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpTdv34T;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753358258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfpJaY0i9heXv55+AsXvn41rTRtAfctbmZRtuKj65Rw=;
	b=dj0DS7S0i2GqWj9fAaowF2wh3PXu9EpfpqrwASJ4cegFhjWbYHxXOXI6BV660LWIQlSPN3
	7JynIlu34A7CwMHsDWqwKaL1IaFwzJjhQCyx0zBnONaIcq/WIOTboh9ncbDhi2kTldnDeW
	JpfsTIoGRE4KzFRO8wA/AUXlZ0zaaio=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpTdv34T;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753358258; a=rsa-sha256;
	cv=none;
	b=XiG/nUktuaiWUFC9ckvjEqe85+f0gABrHLrEqJ/xm+xXjwHGS+Tg8Jlkf8OuX+UJpxBAKX
	yp+mrct7FAQcTxDuTStAIb+Mfm1BqJqS00l7WSjbe98abuWZV80O5VJmm9T3VVZRupfVCF
	5ZzLunhj1BunsPvqy1E91Rw7wtW5FZ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753358258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IfpJaY0i9heXv55+AsXvn41rTRtAfctbmZRtuKj65Rw=;
	b=HpTdv34TWVOzNUSMF5gIB2zzh0wfe4Jg8GNBWceuWR2OCXyNGH7ssojuAyWhkpuIc6wwHB
	fSkOMU8vB7cU51N125exZfHPIbLHDfGneDlOKINAYfsuEXM25hsUlR+62TnoTO7r3oK7oY
	MTFDs287eEJj074U/ODRn5C4k6/6weM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-wqRxwIP5Oiiv-ZByxSH2ow-1; Thu, 24 Jul 2025 07:57:36 -0400
X-MC-Unique: wqRxwIP5Oiiv-ZByxSH2ow-1
X-Mimecast-MFC-AGG-ID: wqRxwIP5Oiiv-ZByxSH2ow_1753358256
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a5058f9ef4so364340f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753358255; x=1753963055;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IfpJaY0i9heXv55+AsXvn41rTRtAfctbmZRtuKj65Rw=;
        b=kQphWLqf27JXwDw1q/1Nk/8pDXuYjBiGXmOYX/5pAXtSiduHeRSw5QUJIVGmgRmTJZ
         Z8DQ6yFfuKS0UqOuurd0so8X9BeX5Ibv2Hc2Dv8ERlCOa46yJeKnyeEC9GCKjIsHJRtP
         E8ZQBKgpPM5QjrHFsjDZy+Bv0vk3B/bqcNhQYpB2N5m1nglX3TyEz1J92RelRiDtc9Yv
         ewxy//YJkJ0wfRRCnj0iaJh6+m/jKXU6Qu3M7rgz3VBjCRFfH/MI8zgwDAI173vSNT+J
         QQmEbrBWdtGBKg8dS3CDWugXWcwTvR9JRDF/TESawwUZtr9A1gjIfEKsBJfJyL7i0b9M
         9LSA==
X-Forwarded-Encrypted: i=1; AJvYcCWXnuQOEiIVsWvp+oMFzmF3G7M6batgWQC1ngajSWKB1OS13/vNiUsP9FKCFZVOVf57HbZhhdGUAA==@kvack.org
X-Gm-Message-State: AOJu0YwMmehL1vTmnnrOKRnoJaX3v5HERH9w57Eg4pCf6Wx7xYuDwCTK
	yDQZ93pSALATD9rOD1D5KctxB3WUP/L/MyYtfObOsh1ppcls7iNLODFxeZAszdkZB0h8vUsXUXf
	fzF/eAP7jLlS+XBrx5B2eYkPI/kV8UmBvViJazeV/ZCElort1fset
X-Gm-Gg: ASbGncu/PWyaoZF9j3K4SWWjq1/VDTW8B03XV8yf6lwNKmQZE50kgz+S1/jw1SLii6G
	7b6FJwYFOLWLvkVswEt/3JouH9eOEbvL4Rr0jKMYe1Ko3aKaO7Fz+yXoQkqjDR9FuTlirXf1Kub
	bgrQLWiV2oZNUQew/psDDPoV/ckKZANjQJHnjA9S1InorW7siS+ZtG88WDSgVEaVhY+Ivh3yYnF
	xDFtvsqIDwEWGsWf9bkVkqyhl77MWlgCqjvMYSgTwjBGpHNk69FIOsK4/kP3BpMd494TVWgtit8
	HsFfTLh4ubU5K7OA/1WsN/TaURE8QbvtxtOWfsVRmorcOqP4ftU+jDXJEgFpEhZnUJHvbQl5EVy
	raJaKyNRz7yV/ZsWiGNbp7lOqU7hoYQxbMMUTKnTKTo3c9K6APzz7rCZudN1kDQ46
X-Received: by 2002:a05:6000:40cc:b0:3b3:a6c2:1a10 with SMTP id ffacd0b85a97d-3b768c98f7bmr5578792f8f.12.1753358255341;
        Thu, 24 Jul 2025 04:57:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3CNg0Q8ekhpe4If+ptwIZaS02E1ZZYo7XDg+YeCtzQ4aBATaJ2jYa5KVbphllNjRL4gIyZg==
X-Received: by 2002:a05:6000:40cc:b0:3b3:a6c2:1a10 with SMTP id ffacd0b85a97d-3b768c98f7bmr5578740f8f.12.1753358254762;
        Thu, 24 Jul 2025 04:57:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:5e00:c941:d6fb:3e30:b42? (p200300d82f1f5e00c941d6fb3e300b42.dip0.t-ipconnect.de. [2003:d8:2f1f:5e00:c941:d6fb:3e30:b42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870554a02sm18071815e9.21.2025.07.24.04.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 04:57:34 -0700 (PDT)
Message-ID: <6c17dd99-43e6-439a-a30a-194311eba889@redhat.com>
Date: Thu, 24 Jul 2025 13:57:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/15] lib: provide kmemdup_const()
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
 Bartosz Golaszewski <brgl@bgdev.pl>, Linus Walleij
 <linus.walleij@linaro.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Alexey Klimov <alexey.klimov@linaro.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
 Andy Shevchenko <andy@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>,
 Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 NXP S32 Linux Team <s32@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Tony Lindgren <tony@atomide.com>, Haojian Zhuang
 <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
 linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
 linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org>
 <e1253b8a-4940-417f-b530-09e57c6a8932@lucifer.local>
 <CAHp75VeWbhuL1pYvEza44Pnb5YUufgY=1WYXSx2nNMJVfcytTA@mail.gmail.com>
 <5c7edf57-bf13-4633-8348-791e0620cc79@lucifer.local>
 <aIIef0MDcZiElgN1@smile.fi.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIIef0MDcZiElgN1@smile.fi.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 93QVdc7bIqjkTuiJF245XfAOGAEZwdwCaNw5LmuVZTw_1753358256
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BC99B180007
X-Rspamd-Server: rspam06
X-Stat-Signature: 7qubp4rhbayu4wt5egmiq5gsj18bj3wj
X-HE-Tag: 1753358258-571891
X-HE-Meta: U2FsdGVkX19RawvFBzjLcO9jFHcsfQoKMfEZV+U1BsSCKtihjVlI8cY5AR0LVANGBPpprv5PTb08fMHR+kA5PvPgXpCV3qC+7GZX+Dgou0MDdD7mCnvSiYcpf1WN1bH2pHEzMFcJpWPJnryg7D9cwwtTwE97JztgITEuGYTOFmrDTS2EoVC43ytNM7xyvzKGdRNvIndmz6o+GLZFVTNkrVHBmUhS/IvjesAsG4JNaZyYkQ9mNxrp3MevH1nn3PSk7DyH/xl71slMrA6oVkROlWsg/5OUlavDyZyhBs2/zckYfiV/QY8oZDWU3OgcS6ocX5r3SiBD5OqzqccJin1LC6F0vVH9ILd0mM/2z+aDrGT8a9Noijc2M2L8quD0zuy8cQjveub1xuqklKol0/XUNQWmjTdlb76vRAmgeXkzg8UF4cMvtCbK1BpjS6OIJXhJcbq3v4z2LR9RlIg1MtkVK2LY9BuiqzbjoIuvrfR0egHcRp61P0/lYnDxbMS0CQ7ghosLGolXIxCryczEPne76JEbryMUSW42mj9oGmu/WGIYNdI+qIip8MoIHHercet3ud8DhVLlKxm1ZD32SWCL9BOM7m2dDGq0oReqUnp8fIaCyfkUybmUbwwkdkEUNaHvZivHIU4zuW68IhE52T6pyWba+7e469Z1HC8UpLX9/g3k4STthEV9IncrWZN3RcKHlXvhnE/PA8hUoo3JK/zVWmdc6r0amZ14foL4HkJSDT1uvVM7wJURldHLPMkkdtZuIdyltqy51AZQga9ejfywZdRLG8d4zM+MzNuLERyA8NagORvYpC1shFTdpv00195JYnPs7B+PiARPxmCN4wGOVwvp/PHMklewU3P0VI5233YDsWQ6vJyXR4KNmXI/+bOI1mVY9dFt8SqW29fgcDiEZKpE9ByzoP9vAFVqQdWMuffTt/nF/DXEBJON2hRCcNQ9NwfCrjpHiK14aKFEGnA
 M8IOBOXM
 BOV+0vcjWSc6oChnjHhdfvgW4UsORF/Et95aKpNXuQnpwjWv5qgWRm7hhydT/M0PCk7bVu62kfTg8sBwyObdGB+pYh9sHqu0k3jfZqN11JQ4tJmQdRO8nZo3ckboDhe3AQquM1K/Q9+KivdN/IpOHIedJpNY3AcQHN2pjvl+5gD3eU94gA38/mCMDHHiJPofzcDnm80SPmQz5ubOu6yJrghE5qr4UygFORbOeDrqiIxrUkYal74U8vXpwSXXqSbNoQzfh4l+D2muOoSpQMmaguINYmpnQhEE9jvgcYnYWGvvTTrViVqqxm5Z5zAiNxxFTCTeIZYDcsIB/sXiGRcMdPPFD0DZW0nEnhVwfwp1n/0X+FwcROUqQsZ3oX+d6eWDT/XbLTqAiTrGVAUqmY0LUP/s8YyYNRokb0m51ixsjPz1JVef8hJR0WZhEBPQa/ug3hSr8naM3rwdtLhuB5Tj96r3dGnyIwMgjPYeUbexTJ0eQaYW0d9rh4sTzf1Tdirz1uedv0rJBPon2mz/qE1FOctvGGI4XsLs2uwN0kjIctZ8/B492AUF/QfeEt7lWmVwiT4MnRqVfgA2otGZJovLgVqHon06kKoov5FZA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 13:52, Andy Shevchenko wrote:
> On Thu, Jul 24, 2025 at 12:15:11PM +0100, Lorenzo Stoakes wrote:
>> On Thu, Jul 24, 2025 at 01:12:49PM +0200, Andy Shevchenko wrote:
>>> On Thu, Jul 24, 2025 at 1:10 PM Lorenzo Stoakes
>>> <lorenzo.stoakes@oracle.com> wrote:
>>>> On Thu, Jul 24, 2025 at 11:24:29AM +0200, Bartosz Golaszewski wrote:
>>>>> +extern const void *kmemdup_const(const void *src, size_t len, gfp_t gfp);
>>>>
>>>> Please drop extern, it's unnecessary.
>>>
>>> It's all over the header. This should be done as a precursor patch and
>>> I know that usually people push back on doing that. I gave up on this.
>>> Kernel is going to rot sooner or later... :-(
>>
>> In mm we just update as we go, this is probably the best approach to avoid
>> unnecessary churn.
> 
> I agree on the idea of eliminating it, but also I agree on the consistency over
> redundancy. That's why I prefer to see this done at once for all (in the same
> header) than doing one-by-one. And this approach got a lot of pushes back, while
> the former even more pushed back on the (in)consistency matters.

No new extern where unnecessary.

-- 
Cheers,

David / dhildenb


