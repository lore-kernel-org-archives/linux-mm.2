Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0769CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2467C8E002D; Mon, 25 Aug 2025 10:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6C78E0001; Mon, 25 Aug 2025 10:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF188E002D; Mon, 25 Aug 2025 10:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAABF8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:46:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5828EC042E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:46:54 +0000 (UTC)
X-FDA: 83815556748.13.9BD680B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 003651C0013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:46:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CQDVxarI;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133212; a=rsa-sha256;
	cv=none;
	b=fG6Kgm7w+OX51vYcpzmDayfkh7ThISdOKbtU6ER5qC//Z4Ik4wj+HG0IKtE5tRbvNVIqJP
	neF2skG/Z+LQ+rdLjAi8SfDInN5agPdDzAETOQ8NaiMFTYZit8TiP/4ghZaUEv1cijdbVt
	Jm/dqWZ/VdDI4KGRl8OonpX+73Zk4ZA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CQDVxarI;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY2wm3NrmZibOSyrPDfEQp80W2axFO0h9jlPQgJYcCQ=;
	b=Lh7xUTlV1FdkpFXDkXmQcAlr9CkVtnZn8yEc756drUfjjNKWNTHH1Yhd0EkIYzIZNlJzxB
	IKPojsdqq6n6P9ye1m154DsLX/KtOJE8v2n6tywgk6M9uo4zSxVVqQ2ziSxrqMgbD9I6Lj
	BWwZQRdoBm07/XXFKsnPustv6ldLtbo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756133211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KY2wm3NrmZibOSyrPDfEQp80W2axFO0h9jlPQgJYcCQ=;
	b=CQDVxarI+RUaIuVrQbYyyOpJS5YMAg+uCJVdvCApxsHEn2oSrGblC4XJRuH10ryx0asboz
	/hEyuGw4gTtYOqOZlMtUpItBq6aP0jWN3KdVWZzLJlFz0xO6T+/nn8Ab9FnOAZsDjLu3Ij
	ZjJp3paMdvOviaFnbvcer52Q4PMvdlk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-RkD_3cWoOnat_7ikUBoSJg-1; Mon, 25 Aug 2025 10:46:49 -0400
X-MC-Unique: RkD_3cWoOnat_7ikUBoSJg-1
X-Mimecast-MFC-AGG-ID: RkD_3cWoOnat_7ikUBoSJg_1756133209
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c79f0a5babso607204f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:46:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133208; x=1756738008;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KY2wm3NrmZibOSyrPDfEQp80W2axFO0h9jlPQgJYcCQ=;
        b=jS/0BIopCYHSAKoAZyRQs7VqLu4Tj9CRle6dm+NSihGzq7/oEM3NTwHGi7OQeIM1mW
         C1QTqI5b8esFRoxHx8iY5TaeMupOhab+l7Whp8hadVP175K3t+FZ/TSZaMzGphfW66LL
         jLS8nHXFLbyWtza9E938tFDe37nyYz+8nd+HYrnDm7JVtohbBWfRVFq9tl6ad0Ncg039
         5Q5AA7pbI1o5ZwQB7zsWCo9Oa/zdlaCQCKsQpUOIgayKvE9cj08oJxNhoIWTkNpK7Hze
         zREplWWsYu5+cR+CdCPsP1j/a2YdFNb+bXvm06M8etO39V/S0abWeljJSnw2AhsPojWl
         Q6MQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT1hBuNO1SF0MPQz3xPyfwrqQMJDlaYls9MrSIoqHSY07IKyCnfLGTrtUrGgqNDeWjfuxzbyAF5w==@kvack.org
X-Gm-Message-State: AOJu0YxJNZFYRWBn6fRRlcz7ipFWXmtMK87plzE85f0JdmpdpxhcYG+e
	Fb+vvMd5/7ZKv8rxRlY+1LE/m7dIBvvAS8Cee0z6QSEKPzExZJe3aWKMuZpb6L7/fWDeCSgDlGh
	9sWQEiYtvhEr1ug3eULKfq3ndLqYMBMqb84kubhUwLOeEv/U5JbZ9
X-Gm-Gg: ASbGncv4lSXqzst6fBopgSembLOP5f3BgcmdVPPG/d0HFp30VCUfH54dJqnwCYn0l61
	gh94yetsASDjWWfiUFO+UYwR+tE1Y9G4ao+UhM/EqQ34wv9Dni3nbQxFv0K26VELy2+Zy3G0loQ
	jyhm1WmH8O+ekPONxz5+TvCgQnFR3jaRxrXsCrxRudNH8RBiqY6aAa3xIv3xllj1XRsas3/PcL+
	ivbfdMNcHAwe+cKLvNUZdyfypvtQ18FNFeXsKYLJMw9G+s1CncvXZo5q9Rce+qgT1RG0ocqxdO8
	gjMtbKNIyosdLdeO2foJ4+hXlqd5/u0aaNOJUju1hj6QwDmu3qAY8lJS+KS8wxIxEXk9JwQKAFq
	qWNIy0wK3TrFYlYI5F7acazBu9TS0fNh1yWHgdp4lhxdGu7Mnulj00EzWB/ZnA0ROCuM=
X-Received: by 2002:a5d:4283:0:b0:3c6:71c4:15b1 with SMTP id ffacd0b85a97d-3c671c41891mr6599860f8f.37.1756133208519;
        Mon, 25 Aug 2025 07:46:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtUFUJHVoJc+4Q00c4CeDXG5Gf93RhjBiSX4FnqG9Oi+HjScx8FQNE8maF1Zwc4YLjexR1iw==
X-Received: by 2002:a5d:4283:0:b0:3c6:71c4:15b1 with SMTP id ffacd0b85a97d-3c671c41891mr6599840f8f.37.1756133208084;
        Mon, 25 Aug 2025 07:46:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57487910sm111202325e9.15.2025.08.25.07.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 07:46:47 -0700 (PDT)
Message-ID: <9cb4adf8-94c7-4fa0-8bed-2f9274969b48@redhat.com>
Date: Mon, 25 Aug 2025 16:46:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/1] writeback: add sysfs to config the number of writeback
 contexts
To: wangyufei <wangyufei@vivo.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
 "open list:PAGE CACHE" <linux-fsdevel@vger.kernel.org>
Cc: kundan.kumar@samsung.com, anuj20.g@samsung.com, hch@lst.de,
 bernd@bsbernd.com, djwong@kernel.org, jack@suse.cz,
 opensource.kernel@vivo.com
References: <20250825122931.13037-1-wangyufei@vivo.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250825122931.13037-1-wangyufei@vivo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0f9HDizjvLIKHQTcGFh3nBPG18mivujh9oB-g3PSGwM_1756133209
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 003651C0013
X-Stat-Signature: 58tocat9mzgkhgyr56pwtppooqj6yz1w
X-Rspam-User: 
X-HE-Tag: 1756133211-171225
X-HE-Meta: U2FsdGVkX18fkFLBWgX1UHlAjWnb1rG3zLdj2pCbHSOUZIyOHq2tAp8+SNiMs5GTMli2SkP8oyi0KlFPSlIFAFJGk/TyoVOpG2Ei9SwWZvDVvQvB5bb2rAQ5MsVFbNutjs4iskxwG/A2+X7/HTzT5P1ltqoPWE+iXCLt88upySMrJMAbxyUbTjAr2SQOw0hi+hD8MVgXXbnwYr7BF1P8o2iMfL+P5JwcKaJRW7W79uqw/Kq0YKVrFjSzIcEZ7RMaNc8vNYJ3yIm+l+5eC385kbFZH1KGXSpy4+TlB1KD3BLSdu/WU8RS2KS92KQlwFEqn+9hWcxcndSk7lcvOdRpQrbaeAwmAT6pf7diWktFI6e3O5hPeffYix/mfPeZGSSX2+OGE399hEDRhhej3VTrMt7t286mvFk4MrWjvlxqiY0JY5ffBy3FWhTSxo7oYDjqoed4EG3isISCyuNsaVrXLjmJh7pVNaGOk6zx0MXsIxV+rYsB+grtir0lu3kWZ6xG1lSCrhh/le7yJB9XnUMYqb/idqbV3CjHdgxmqhu9/GEpT+MouWGIj4bpPJ9U53LoQFiom0J12WJELYH+jlk6VUZMvAFkcFWEGKwUjNoQLTxxzo+DDjjbbODfBiKfg8+QGIe0MpT8v8dOhH2UgJyDu9weJz7dqgZKax5BTiU+hGuKvFMl3Jla8cgRq1yyhWM/vFsMitdVoJYuXOyupA8jpILv1RXgWeNf1u0+iW9kIsbAO7m1t+cOkJWGqWeq4hG9kEjCE05W3G2NvG4b2QjmrbPkNNVfPj2N8RUV08laCTNNTuOQpGIUO8Be6rUHp8JgJ13f8RpgurkynNe/MCLmH3rpUYrMY/KdiQ2mfOFiIM6zjHo6bCfLdr8hyD7XqcXRb2k9VU4WP61Nez6+VuasungUs1YwkXNyTepLnfQcn+9wNGf61zzWQA6hjf6BPqTAKoscg2YUAcazmnz85Em
 1kJcGjsj
 czO9D3NIF5JPPND3S8BO2z5DMBCu3XpvjRx3Eed+/shI6rR0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 14:29, wangyufei wrote:
> Hi everyone,
> 
> We've been interested in this patch about parallelizing writeback [1]
> and have been following its discussion and development. Our testing in
> several application scenarios on mobile devices has shown significant
> performance improvements.
> 
> Currently, we're focusing on how the number of writeback contexts impacts
> the performance on different filesystems and storage workloads. We noticed
> the previous discussion about making the number of writeback contexts an
> opt-in configuration to adapt to different filesystems [2]. Currently, it
> can only be set via a sysfs interface at system initialization. We'd like
> to discuss the possibility of supporting dynamic runtime configuration of
> the number of writeback contexts.
> 
> We have developed a mechanism that allows the number of writeback contexts
> to be configured at runtime via a sysfs interface. To configure, use:
> echo <nr_wb_ctx> > /sys/class/bdi/<dev>/nwritebacks.

What's the target use case for updating it dynamically?

If it's mostly for debugging/testing (find out what works, what 
doesn't), it might better go into debugfs or just carried out of tree.

If it's about setting sane default based on specific filesystems, maybe 
it could be optimized from within the kernel, without the need to expose 
this to an admin?

-- 
Cheers

David / dhildenb


