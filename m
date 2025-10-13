Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9289ECCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC45F8E0028; Mon, 13 Oct 2025 05:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E0C8E0026; Mon, 13 Oct 2025 05:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE738E0028; Mon, 13 Oct 2025 05:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A677C8E0026
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:25:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 469CB13A930
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:25:36 +0000 (UTC)
X-FDA: 83992558272.13.5FDB6A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6AB3140007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:25:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M8TW8TbY;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760347534; a=rsa-sha256;
	cv=none;
	b=mFWnfxjaBEhMphr0WTmQvsWl6q5GEy7NGz22MIjZ/DrgJBKl70USesFodpN5G1wlC8UVkf
	WhHr2+pez7sBaDuFEuob9RkuMf+9mg6KTOoTx4+TnAidxIQN62PGbgpimdDwkmOaFvmG6i
	QRl66QAJ1KEMmMlIASrXlQhBUx27QDs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M8TW8TbY;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45f1b0mXkQ/bXJiKQOO3KwWzxkP9Zc+3arM6UV73Zeg=;
	b=eXHdrb3wUSJeOVoF/YcNQ0vapoUfuxTNUSwERw/0ehE6JqivStFywQDYL8Celf34BXFtFY
	KKM+714w4jI5j7b8qJVzoHN9m9dDHzj917Ee/QuRfuYaFiqwkUd9hey40ew1MkIfqWPA18
	sEvG+FwAwknxcX26ssVyMJgJdGnwp1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760347533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=45f1b0mXkQ/bXJiKQOO3KwWzxkP9Zc+3arM6UV73Zeg=;
	b=M8TW8TbYjTfJzLPBVqBeK0aWgWGYzGnogXrFL6lxzkUcunnakR3ODE4IA8OqZfuHCniW7m
	NjZ03ezPImyAaGowpf3CjrblJacsetAW9nJ09E7lGspNTDPriQxWy1X8I3b53PNHrHo4Iz
	pVTm8U6whbXUpljXX8P89igUIvrCrIE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-bu5GiIX5OZmecT-v7O5idg-1; Mon, 13 Oct 2025 05:25:28 -0400
X-MC-Unique: bu5GiIX5OZmecT-v7O5idg-1
X-Mimecast-MFC-AGG-ID: bu5GiIX5OZmecT-v7O5idg_1760347527
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-426d314d0deso1400247f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:25:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760347527; x=1760952327;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=45f1b0mXkQ/bXJiKQOO3KwWzxkP9Zc+3arM6UV73Zeg=;
        b=n91HawjO1XCtTbeSvsX6Je1btLQ6HwsYE1xC2e1useENYHSfRGNDotbyKynEYGTZt1
         KE5PxLr3cCZXGs4wOwQudqrtORcVIxdk7IReiIMGAKbutz3LWlYRa0JuB4nT/xqkbx9e
         FyxLsp5Pg5/EFka8n5BLWdjA0fW0YJfXydYZesBtOnKX5L3izJUZWJd44RpksFFYa54d
         X9+R6LKIvXlYwPQdIvlpMIHiJF5LG2JZPbOZFjGvSjixDINZRNWMs8+nk6Rx/9VQzHds
         lSH7IJTMIQh7U72lADOR5BS+8cSlN8WYEwgon4qHeyeLoO5Htn1U6mMhhw3nqS71+Q+S
         ++/w==
X-Forwarded-Encrypted: i=1; AJvYcCWL9cicncV+c/Fsnikf0Kjee4HnA8DuDym6rOyWRIKQGtnC5HKqBRNc3KwgS/y2ay74wd9YaP87hA==@kvack.org
X-Gm-Message-State: AOJu0Yz5uFeoGo7t6AINphRn4lcSxfZ8hQnUqVVZNQtCo040bvHMHMTP
	5yAGAa2IiajhetPvUe8WGCtEWS+gyxMDL+dTUvf0oFoF94nwufoVhSyxSzPgiHFM1GFHbGqa0DV
	ncocAYbWhMuw6EKhaWLqROUFbYxQCe6UBfm24wl1vmyID+qFT3+Cl
X-Gm-Gg: ASbGncvWJHy3Vl9NepRg0gv1+1TzRUNOJiGI4cx2sBgbtNSsWk1lHrt9qXSfiH9Akwd
	CzXlw5H/tRpGwFim7U/quv0hPzvQntlVEffQVQafRWAkCrvhm1A+Hywcwf+J7JQldOs/ubonGSM
	kL3OKnQ/m/tsUzA2cmm9X+jOVxKHkqsPGDIx8Bct4ow2B+wUdEuqiRQK5UUJmUbUBLYFALQmSbR
	cZHhknQB7XHcxibdw52ACNqcNmukj+DiYwD1jSlHSUf4KNUinSLY7drhNDh0yxpCJ2xPbBvQ1h7
	v+FsyoznoxRFPZCsGoTDaIbHM1Z1JVjbu+eT4xkZCgP6IKFVNH6klh4KnsdpxpSKgO2XWTQjjT9
	N22I=
X-Received: by 2002:a5d:5f54:0:b0:3ee:1586:6c73 with SMTP id ffacd0b85a97d-42667177de1mr12847272f8f.19.1760347527134;
        Mon, 13 Oct 2025 02:25:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYg9XjYPSU7V3J15wqS0ZRoHv9WaUOniN3wcI031rVOGGwlPRCDH+RKYRnwAJfJ5gFX+HfUg==
X-Received: by 2002:a5d:5f54:0:b0:3ee:1586:6c73 with SMTP id ffacd0b85a97d-42667177de1mr12847240f8f.19.1760347526728;
        Mon, 13 Oct 2025 02:25:26 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb492e6ddsm194397015e9.0.2025.10.13.02.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 02:25:26 -0700 (PDT)
Message-ID: <3e6500dc-723f-4682-9e37-b28bc78a2bdb@redhat.com>
Date: Mon, 13 Oct 2025 11:25:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
To: Lance Yang <lance.yang@linux.dev>
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
 <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
 <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PNLcwpp8u1GcOIKEb5_wh0Hyqqu723682kBUDUPC1i4_1760347527
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: crbbhbm9nfzty6bjim3uem6jjz5zj7nq
X-Rspamd-Queue-Id: B6AB3140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760347533-612771
X-HE-Meta: U2FsdGVkX18iFWaPHaG2kWrOyFMdO8gcUH2MNu3N8D1iB9+TxaVAvdHCGJgB2aHVTsmVQNRFpRw+k4ChVp9KKFVmutscNEVLCSUDUG+wiPdkwE44C5XN5biYC8pDp3S5uWWOynn3Shvs1tmzxFilBW0zECVe7todiWJwtotIhWvDXWctj3qYvLXNFkGEG2lPjwqTbioh9bZjGkDYteXEEw2j16kmSwowWUMP4JqgCkP4wFeNI5xWtHIV6EU/4Yke9mdNrq16ffCRsFAjjBfZTKb/vn22UHzZUL29tML/3BH/WotQXiHFT2woz5dqyWqt8MQw3U2m/Lipgktzz1WNRGDlk9nVDvbeERzDUiTxZE61iPyynNfSzfM1JlwPcMWyukFEaYYsocucIBMmClcZTkfzHHj7hiHtZwlekBdiw8qhST9h23dTy1H8xyApMtOO+Pv1lXt5nshYO4QhrfRtOOGsjb8msahH++RnMOSA6b4Hh/GqUilJvzHFqwD4EJVdCxMiLQb3AEjghb+XEZ++HcmIC0oZ75rgQr2JJ8PCY/NqQkKVwLch3VZkiZMirG7e09u04wQcP5VGqanjJ8qVZq2Vo4GV1zIvVRJ4kh3gZqTpqVr9sdr/am+jBQ0C+J12gSTOYY1dD3h1qg/XCMcGdh21WGdt6ub7QK6B9Id2RG0qddNNUN6h0ng/TW7691ptAj43Z97zIiCikjvaaeB98pVq8T6WxBV2e/AZLKkSJTHq3E+JLdBmCderpQSW+ZDPGL4BKePFQAIuNVoNw7BootvUg8Q9bEGj41nV7ZypZGGAxOdZcH/uuDrImd1Lx5Gk67VUNw43M+S2kyI3OVlJGO4J40a1JUbL5eLb10gM41wyaz71AUjuavVOP6JSDeV+JDKP6mieMkNNOkDXlkCm/GOprKGxzwLe3XVYCb3zzh03YV+yasr2DJKTvaHm42rwGdueqrTiibHgoMQzCTG
 jbOdUciU
 yHUVFeOWXRdC3a9kA1gWKEuT21nXe5xPtqflZZ8g9dPoXEc1S/kaWZkjniUgWF7tK8bGyW/5Y0l36ruM1vy7EG2Hc739nkqMjBM/QehiG5EdvU9Wqd1SPDWb5cs5PatB+F+l7JKP8vzqu0gg3ef4/V7SmgfTIX1/zx08xJWt1VnB8FBng1iXICGV/D4Tsk2enEHduZkoJ9VtTA+s+lxpzgkjw7+0d5HMvDANY8MiYYdYWJwYFpAphIUDzyIQEyMfYA67bAQG7JEAd5VY88c4Mjc3YikgIL+GU0JCDcknu8TMIfMppvY7v+MbOSvKz+Xo4/BRDjR4GhbIQoxbLjCW9UkeyexmpIC80MiNLhm1qKuRMrxt2csgMjzRCyn5EBsu54wIkt5vFUkW1XEQfRYWCPM+duGnQCO6hqUMSv0jK7GfjgzIUvpwdAFug6Hu1Xj4m3oA32tyzA+05o/MqoHcFoyjy2fNrkhIDXyfeOnTcx4gm7ZTbzglN7wgFTmFGDZjVn/lAXACa5Mbpu7GUfwKRL9JeY0pfVxZRzGF4YPnh8zL1c/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 11:15, Lance Yang wrote:
> @David
> 
> Cc: MM CORE folks
> 
> On 2025/10/13 12:42, Lance Yang wrote:
> [...]
> 
> Cool. Hardware error injection with EINJ was the way to go!
> 
> I just ran some tests on the shared zero page (both regular and huge), and
> found a tricky behavior:
> 
> 1) When a hardware error is injected into the zeropage, the process that
> attempts to read from a mapping backed by it is correctly killed with a
> SIGBUS.
> 
> 2) However, even after the error is detected, the kernel continues to
> install
> the known-poisoned zeropage for new anonymous mappings ...
> 
> 
> For the shared zeropage:
> ```
> [Mon Oct 13 16:29:02 2025] mce: Uncorrected hardware memory error in
> user-access at 29b8cf5000
> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: Sending SIGBUS to
> read_zeropage:13767 due to hardware memory corruption
> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: recovery action
> for already poisoned page: Failed
> ```
> And for the shared huge zeropage:
> ```
> [Mon Oct 13 16:35:34 2025] mce: Uncorrected hardware memory error in
> user-access at 1e1e00000
> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: Sending SIGBUS to
> read_huge_zerop:13891 due to hardware memory corruption
> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: recovery action for
> already poisoned page: Failed
> ```
> 
> Since we've identified an uncorrectable hardware error on such a critical,
> singleton page, should we be doing something more?

I mean, regarding the shared zeropage, we could try walking all page 
tables of all processes and replace it be a fresh shared zeropage.

But then, the page might also be used for other things (I/O etc), the 
shared zeropage is allocated by the architecture, we'd have to make 
is_zero_pfn() succeed on the old+new page etc ...

So a lot of work for little benefit I guess? The question is how often 
we would see that in practice. I'd assume we'd see it happen on random 
kernel memory more frequently where we can really just bring down the 
whole machine.

-- 
Cheers

David / dhildenb


