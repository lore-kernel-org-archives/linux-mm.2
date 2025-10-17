Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51ACECCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA98F8E00A3; Fri, 17 Oct 2025 10:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A811A8E003B; Fri, 17 Oct 2025 10:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949B58E00A3; Fri, 17 Oct 2025 10:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7628E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:54:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18786140205
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:54:19 +0000 (UTC)
X-FDA: 84007901838.28.8322895
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B8CAC0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dXtEyu6v;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVg3pi7NpQHtM6ZoxI30PgKBLj0yHkiDuj7fimQcvas=;
	b=kv5/qNcn3qTNQjNwVCW5E4QXMbsLbheNYBrFdyNPDGQOmuQoXtGy+J4+FbpKellPlGZ/3j
	IqZVMWchPgUBOCQE8XEiLaCvcRTcJja8Tzh8XGmfjGbxoWfSErbFYzktcvudDaAJ7LgjE1
	nvyGpbF67f7SvsENdl0v4Q7wegvJVqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dXtEyu6v;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712856; a=rsa-sha256;
	cv=none;
	b=FgibTSvScgrrckQyHNfuV21aYBobQ0Qpn+r17SpKewGlnnIhdzReHY+TnTsyN+CnKonE6T
	bLjcjOnbI033OFI+8YVXhcJX0ToEI9068cRzcf5ihbcVj9fZZ5gdUCdoFG4v1fUg6zut6O
	ZVdo7+EpH4ub9aEbXQhv7cuXyceak8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KVg3pi7NpQHtM6ZoxI30PgKBLj0yHkiDuj7fimQcvas=;
	b=dXtEyu6vp5Nsi2eSfm1wHHtsPoExkT+aQQsTTubCoWJ6ZSW/H06MlowI5MDdfYc49WuWom
	TzSPLb8H45ZAgtBaQyCxao5szVbz0btBA7YHGCiBs0VigDUVnHmbqNeohTGyc+5DmhjfyC
	WG4TPsLQIDTOrrjCoiNACU9h1RmfafE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-PyAi8ckfPsm6JYUTV2ZtYg-1; Fri, 17 Oct 2025 10:54:14 -0400
X-MC-Unique: PyAi8ckfPsm6JYUTV2ZtYg-1
X-Mimecast-MFC-AGG-ID: PyAi8ckfPsm6JYUTV2ZtYg_1760712853
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-427015f63faso1187846f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760712853; x=1761317653;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KVg3pi7NpQHtM6ZoxI30PgKBLj0yHkiDuj7fimQcvas=;
        b=qzR8cUs0ks3R0O7tDqg897Q4NO5qa6wFwGWQl0XBM+gqU0MXe4kkU5j2t269d791Fq
         Oqy0MVu6StpmEdyEe1FOV9zF1PjcClIZ8ZIzVPoaT+IAp08ctYK0Qnm9Y6LrKyWSKcB6
         HF+np2WXIVZDvEiAjRUt3ceGpAcauZVWXnq007UysYdv2pdkF3y98QMEugesrQMJIDKu
         OYalaeQoPj69Vy4t6WXpJfRFW1kpE94O8UQ672JjQQiB20TSZda2dztmAstvOV09pAdh
         0Hx49J2ykzBDntPE6dfHB2U0kHyoq+Idk3/rBG2vI5QskBGwepIZgxjWx/uZI3hpsTvW
         0loA==
X-Forwarded-Encrypted: i=1; AJvYcCW8q7pZeEJehvQNdiIMCy5M/3n/rghmOhkUoBIdw9mpzZab5Z6FSuhFpkgv9kTmAciTkplUhBme1A==@kvack.org
X-Gm-Message-State: AOJu0Yyugv5da5JzotmNeCEzrsEoQGAwKQof5deGY+axGJudGvE/G+eM
	1oWsxQLGNzRJV3h5TCsptjfiXcjVGB1Xix3bXc05qhhaPYHE8WgrYNWjOuwZND6+d+0RBE+6rTH
	FMnRm9EEsiP6XVs+aRV3Z3G5c/Zey8ZoBHV8dbUhU9Ahm0OwvZCkD
X-Gm-Gg: ASbGncuxDtjTu3awgoomp/Zrp8r67eLWFw7fV4zwiBpc+cYAfQLTS8CycgiazMkvK3Y
	qKV0ffTFapAwgt1/6+P054yiXk9J5jo9whskdJT4pvl13u78TXOgdUvyUPRpe+w9AuPMS/z9zye
	4qHLn6NtOOJnAdqnQMJ2dJ9q/wVv/iIGqOxm9P2b7c948iXHL3Hpi5Ff2ZZq7ySpxHM+KEndspS
	NbksUXfBJppPKLXuqReUTWRE4/zbQ4TnT8+XsSpN3Jf5ShcAm2HiZoGvum1Tup36U1LOzIsd1Rx
	WQVp5GwL6BYnuitFETMvj+FqaFvVSOlv9ufOcBh8XkiEKvo4HmfAHxtxiHSgjS68ySGlB4cP9dE
	KVs1xqyx090gP364/p0qOtWN6B3kW0w6x5bCkMIPKaegvmZITePvFZbHBtDb5GyPsQNZOw6pcri
	VIWoNGiJChKAY+HcTLKq7NrxFiExo=
X-Received: by 2002:a05:600c:1d9b:b0:46e:4f25:aace with SMTP id 5b1f17b1804b1-4711787604fmr35583435e9.6.1760712853321;
        Fri, 17 Oct 2025 07:54:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY2i/XrXLNkdMltGFV0J0tBrRne+zVRBnrRcoyDQuxJFLmGYGJuLXfF8xyMKL8G2V4YC2CkQ==
X-Received: by 2002:a05:600c:1d9b:b0:46e:4f25:aace with SMTP id 5b1f17b1804b1-4711787604fmr35583205e9.6.1760712852931;
        Fri, 17 Oct 2025 07:54:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711441f975sm87898455e9.4.2025.10.17.07.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 07:54:12 -0700 (PDT)
Message-ID: <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
Date: Fri, 17 Oct 2025 16:54:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>, balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251017144924.10034-1-borntraeger@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NfMS1BBh-bKjIfRPxItGQlpct6RSFYLepX4Iww_5olY_1760712853
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B8CAC0008
X-Stat-Signature: ru787tx53xqupp7baybd3xhrx816qd6y
X-Rspam-User: 
X-HE-Tag: 1760712856-573491
X-HE-Meta: U2FsdGVkX19ScbgN3PPehSdW2tIr3w6TTqkgOgpECYkXtj/KaKkCt9KDrfw6We3Il8NtSInYGXtfzmBxSRFJtzSSA+AeDLz9JJRhor31uOPyvHTp+hIEQsv0Xckaqo+oYjRCPM0G2gu7CoCcWiSWXt2E5t/86RV7/MXCvGV+l++ygp8JGQ4rbeSi+96W/TvxkfuFtueCtMtrlBi9+iK/yrVCW61OAdudywLnlkC0LxLgbOaplrYStn7Ksm28EcEJFlFjxEBsdV1jV6xhswZf3Av03ZcMO+XT+GTHcX/+bNil45kKOjBcMYULaNg6VUDKk34sFSOBbbdQIDvL4tcDrLu8G8MZ11mqFNIU9I3dRco/IQoTA1I0eFaYRSk3LGPR65jNBpWKAuugClpGP7TX4PnOPoC0htQkRgUEIYFOp0EgQoCCUu3ye5GZmJGofeSott+Nh+KGSxn5U2aKbvYFwZk1cvxgHkBnEEmJMU7w6Euxaz0Ib8b15i+3lp9OfQJiAtajrHg680d+BpuGCTpbT6ieKfipZIi8YGpTuyKlnHqPEUaliUXO7cPs+KsfQaTHGiOzcCj2KFbCC0vVJuPiMKZn+ssGh+1NRl04bB3BJ2Mf4Rg92Ij6GbF9WDX/8f2pYb4b/W1qw8I5puWC3qY8sfoaSHNCVaJnN7uETuDL5By9QqWrpksdSvMPxcNlcdeMeL8ko/cxRE9gorW1znN7dhme/JNneW6wp+/+vU8XieTvhC1x+SXpqlxi6BqDFBNmAIbIiSwPxNX4dWOWKbx3iJrLCKfBcxhShcRHRkh0wYO5lVnwNJOuj2JXeN+yjIoFQx7H02GwtLM4hCqhjjkLrIpc7/qPGYCqdFQ2V1um94qD+ojlyzsIQ88E6PvkjHMgmeQpekJ8aHXb+SHAaJcXhoU6PLwXTO3WnHA/GZ1qkDGsJGdR1SvAUEdxROqM32W6AFuAc8gu0YHrdREYsji
 Ghea1C3T
 dE+DQ8x0W6c31PPlIzAT5zlhuCw3PCZYZkiaJpST8vCtbPVIwFrp9pVn1ML6UF/rPpMHEkomYjXhjIg3uTzLO5UKYLsHe35jwqLWGm6yUJxvPuXquoqkoWUX1ZGHs90oPkCrN4oSlKpkfPoOwbOcl8s2g1BM1K5hFsB6XYD3RPFFtV3wpBDi49STUwxIJiEd/KMDs+kR6tDK1rBn0sCPOD3QH4O4XmIC//WTf3Ar2FCb1VP+eyZOfoOITXWFiWYy5YvPEK1SMry0OOzJDlGtHsYwHGbdD5+S1KIz53kUCIwYQVwR2HX9k3euQpDoiRGCzcQ1wWG7NHhf3yFcRXoGnj+lhoYjd9lU+pioSSK1Xn6l8Byu+Q9kWG8fSCAgGiOuTB/xxL56I4Ko5XDLVT3DODupk4Hpel9ywIgUPtuFQtLKGtXeA6ZlV4EsPmAMfiDPBsxo/kOfE4XeI8q36qO3uWukAd2qQxCb+OuFXfkZvnQbUUczMyFNWYJ/PyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 16:49, Christian Borntraeger wrote:
> This patch triggers a regression for s390x kvm as qemu guests can no longer start
> 
> error: kvm run failed Cannot allocate memory
> PSW=mask 0000000180000000 addr 000000007fd00600
> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
> 
> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?

Only when running KVM guests and apart from that everything else seems 
to be fine?

That's weird :)

-- 
Cheers

David / dhildenb


