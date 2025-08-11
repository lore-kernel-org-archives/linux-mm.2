Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F31ACA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FAD8E002B; Mon, 11 Aug 2025 05:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7748E000A; Mon, 11 Aug 2025 05:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEE78E002B; Mon, 11 Aug 2025 05:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 024CD8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:44:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A40F9C072F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:44:26 +0000 (UTC)
X-FDA: 83763991332.21.9473907
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2ABA5180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:44:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gY1pxwBp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905464; a=rsa-sha256;
	cv=none;
	b=bJ67gPaN0xsH0cDPfdx1Q2v25RSJMYr/wIl4xoyDlT6/4prDWgM/CN0Hx5n2JX8hJ09Tdu
	/D2gNkuyaIAU0foAD8ImmXCZcEO6PA7rxkPJWL9dmcSFI0mSUYFHa0tUahSzyKQiXvchAp
	ZgwrLEj8hPY7wSM37ZAgd93pg99TiLw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gY1pxwBp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F18giMtXeSOsJoxjGEWjUq9c9uihGO30W7aY2sZTIr0=;
	b=LY8+AbvsHOyACbfp2mc9Q1Pp/OyGD1IjYX9gqWfN4S2RIDJ0/touYR207ZHs8tBr7ZGKZk
	KMM0x0b3u/H0sits/i8lZhiVwHzhodFIcc3IJIh2NgNTohoEZtueYtFlySPdtvVcz5hHML
	zFGiEtVp2wSuKEwKAxs2i5UCwviJPnc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754905463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F18giMtXeSOsJoxjGEWjUq9c9uihGO30W7aY2sZTIr0=;
	b=gY1pxwBpwPntS49Exa5wFZWyJi+UxOqAdBwa7SlWTWNij0E4OD2uUEW8I/wdawqgZzL5/6
	DcVYulV/OdKL/y9+K8KXxdyek52+hi2EOtpSVY2mls3DAmuKR59yuN/m/IoaRuQ3h4uZ7H
	5kEGPjg3OB+PA1R7tFTKtbzPkhK3pZE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-jatLcB85Pm-MwkPAX46XyA-1; Mon, 11 Aug 2025 05:44:22 -0400
X-MC-Unique: jatLcB85Pm-MwkPAX46XyA-1
X-Mimecast-MFC-AGG-ID: jatLcB85Pm-MwkPAX46XyA_1754905461
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d665a87aso35069405e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754905461; x=1755510261;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F18giMtXeSOsJoxjGEWjUq9c9uihGO30W7aY2sZTIr0=;
        b=CWI0b/d3arVXaLAePnTpWiTjkA9WWVw74bboy/feSkY5NUJoNcy768vfg/5bpZ0fBd
         6COivs4IYm4wbGF6wR1GGvUFHiHpA3n7Ya4+eYt2MqBtUoubcl7gLeIcj42g3leLR8qY
         RCeJ0R1BCZFVlTuLIfsuqlL+9EBR5syLwYWm0p0t3EB09pe9TMPearI4iuAS0O67Vtd8
         aIK84HrAHcqLfFO5wzMGsRrJzNb4gO+eBvEJMoRpcnZZc8QVtIDIWYsGGq506+O5qpag
         DDzE4d0W/TlAOs6BBJ/bT6WgHbVh4mkP5YeTHwlHD2QykyyMnxKfywY5gzPDWvANdhEN
         1BTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu+n4FuEppqgCDopGGcsnRgI7C7fWYkJsjG26LG+nOYJ/zk0d1+9man6e752tTGTEAOr3SDHylKQ==@kvack.org
X-Gm-Message-State: AOJu0Yypp14MGcJrOOj8qmNHe3onnU1hGOrBITJtNjIcl3SrDaLEzW6U
	4Rp3P81/uWp5/P6ZVEUCIjFn/2eDUEoXpNypyxYcxiOKs24C/uQyNRvbCBAe/wavuTApf88N50l
	e27G0PcsuLyJQcFXXRqi4kobVPPg8DHGUczN0VWG11F4MXfPmHc+5
X-Gm-Gg: ASbGnctZUTkz3Vyve8naAKIvEg+kXASkK/m3Pb0aDU/b+vIXgXYp7r4dAQ6SuBG+H+Y
	+HvR/rx1RDFH6DK/LQm6LBR8DVdOuJCC2Fg+Xp/7tZd/x+GI/aMfP/PcPDIiA1+HlrGNCbSmPtE
	S01/RRaG/C0dUiEmwsoRdJmX74D66uQmaNowpKMuNnANi2duqoCWwvuG/ar7sPEnGu+Er3YwZzE
	MxdLIgEzrslem+11lAdTjgmv3yXNrDdPhFLRak1bNS3qJXBueFEWTGknolNNzqz//hBX0B9i7Rz
	VhfKWL+Lp8K9HMpFozxniYt1GKOF/xwMPUhdfgof5YXJXph90lJkJRySoKBFQDpdVVwGIhUqt6d
	Zo2Tngo+/UnMQv/tL0/qDIYPZZ2cm+5Q6dPyTgt3L3fyIWOu8h7s6bmGptd4mRxmfe+U=
X-Received: by 2002:a05:6000:310b:b0:3a4:fea6:d49f with SMTP id ffacd0b85a97d-3b900b7a325mr9729243f8f.49.1754905461118;
        Mon, 11 Aug 2025 02:44:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDnyT7w5uW8Z0cRPw8tOSrEfeGU//7NUygBZUK+G4oAhA4mCMSvoBXSssgH+X+wFwiUycmJw==
X-Received: by 2002:a05:6000:310b:b0:3a4:fea6:d49f with SMTP id ffacd0b85a97d-3b900b7a325mr9729207f8f.49.1754905460669;
        Mon, 11 Aug 2025 02:44:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4a2187sm41328501f8f.70.2025.08.11.02.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 02:44:20 -0700 (PDT)
Message-ID: <f7f9e444-1739-4b5e-85e1-3a9f86b7e50a@redhat.com>
Date: Mon, 11 Aug 2025 11:44:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] block: use largest_zero_folio in
 __blkdev_issue_zero_pages()
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <20250811084113.647267-6-kernel@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250811084113.647267-6-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UKZCvvzLi6MaiFbLc30QzsU8Xz8jhCTzjqhH-W-NJSw_1754905461
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ABA5180006
X-Stat-Signature: mce8jq9jthui6ib5gtjstmruao3woydu
X-HE-Tag: 1754905464-844608
X-HE-Meta: U2FsdGVkX18bBZrfIX6zkzIzJbPqE0YsdIpHNvzTXAVrUjocQ8evEfpvnZTnQgM0L9+pkS5spFSmGdV6cctZ02fbQnlcOnF6UObi41JH5TlYKSTM45ZeyvJmZVPzB6c3vPFgWkRMo1mGnJCx17DqeJEkXG8axqoCZqyh4WD6KCXUPWf3I+dpeAC1+CKcQcyQ+HT6gmWfIlZVMnoaDiWqkjzPQnHJODv6S3Ysp8zEosGgwwWdM/Yki/avun0rh+ey7m15YgO1tv37F44jQV7IJdiwWA3Aqr0tbV6IFDebYc0pfGpRdh52LzeuhLb2zXNkxJctlH4CH1DZy4kcc79U4FrVzgYTfnJXBS2Qv6SmQWXyE5lQBQVlDbqp1ZbuxpMRNbESuaOi/ViY6SmxsFid0uoCcnDSYyVPXdByXsTuI/oOkdO5mGaU/KDWO0mgfun6hBvlL4MwcDmd8Fc5RJhV0L0URKyGhfB45+KF4ek1mY3H7REZP6/sVqE8P8hfse4zHPxJwuf/IFVqL9yZgNAleuZhxI1Gd9AImQ9QmoExe/FlJUZPnMb5bWSuqjkDbZwQmuTMcc6b3T8lECqkj0i3yKUDsMapgTUWZX2LwDNp59dMZedda/w/L0BPqzDN4YXp7zPNvEQp5t5UmVNthW719UnjLCOwBmGN/+rxglJq8wpUEWHxauAHRBKHy/L4aTtGyoiE2jeQXHtNVRLO51jkeqKA7e+E6dsGyaXtOl7lOQz4paUn6kWx9ProDupN11b8MWEgCpUq18j1CRsjJB22294X3YHgEHoK/ShgBlINavtsf0HwnHzLBPEz9UDvSVF0HxsnR73+TS1IpG/0ueqcPoFTRprxdD8UFtF/UA2PJzzKebetNQclQIoK3O9P4p0606Vpee+lYtJNZz1CcL2fG6i/DbKwSstjnLuiJ7EvqrPhz7JKTaNA0K+oFHkt9SxL/yK7AB/5sNOpXMDjB94
 ewYQCW3D
 pzGCtnVU57heizqsiwVBSe5lmf5QX8F/O6Bc0779oVmL/8WJqIx1jDeMD4StXnpS9ocmYyG+xCv2RqkBkagAkEQaJIA0Jk+v1ZRb1kly04wlmqEMoXFNK7Oe2a1+KMSUdnZM19HLFTpb+w5HHYpUKc40qD0b96j5aEIYblBPEvQ7oX3oXygQFvdeyqfoTz2mfRdWZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 10:41, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Use largest_zero_folio() in __blkdev_issue_zero_pages().
> On systems with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO enabled, we will end up
> sending larger bvecs instead of multiple small ones.
> 
> Noticed a 4% increase in performance on a commercial NVMe SSD which does
> not support OP_WRITE_ZEROES. The device's MDTS was 128K. The performance
> gains might be bigger if the device supports bigger MDTS.
> 
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


