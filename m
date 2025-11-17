Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2DBCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8A88E000D; Mon, 17 Nov 2025 14:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7988D8E0002; Mon, 17 Nov 2025 14:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6869D8E000D; Mon, 17 Nov 2025 14:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF048E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:39:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB2F3140292
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:39:15 +0000 (UTC)
X-FDA: 84121112670.11.455F62B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92A6B18000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:39:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AANx6MsL;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763408353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
	b=z3UeJhnHibEaxfRAZlSyhfIyGu16KamhGvDAmnf1Rd6xTo49x18vl1NbBS/ya5xWFN0yr8
	ujzVItkrulXJWbRoqC75KJ6+9sXjfKQANEt5ZN3mJoZxOU0YlNYdA68x1dd/VGK37CxeDy
	jq6TpNlc5ig2GQ3mcomuhHRwqNJXtGY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AANx6MsL;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763408353; a=rsa-sha256;
	cv=none;
	b=Mn4sM/pN7B305/gOW6tovjuxTJiFKcLvDNmd9GBXGqWe53d9PzdTG7QeTcfWPVxQC3M2tr
	7WPWf/QCb1CqlhL0l+ucXrOo058bmXao8o49Rpyxkw4cQgUOOHDLqE90sdhiH4nqm2jehW
	LA3VYHuk+8DNanRXJ58xrVLyH0yGviI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763408353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
	b=AANx6MsLVPsAKOy8d6FYIT9MXqn68TZcdYkx+IPOdjJtFixBvbeeSarh0IwDoT1Vbrlim0
	vIx+P3h5k0CIRKe/bo+PO+PUxCcZ65khGrl+G7tJZGPsHfobwoSqDgtkFzFYUxoNlD7I90
	7wVUyzvv1OUOX1rkvrpA3BhfLB97ofI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-wU3nlYcjO8W7Hn4pj_WvYg-1; Mon, 17 Nov 2025 14:39:11 -0500
X-MC-Unique: wU3nlYcjO8W7Hn4pj_WvYg-1
X-Mimecast-MFC-AGG-ID: wU3nlYcjO8W7Hn4pj_WvYg_1763408351
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8803f43073bso181031196d6.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763408351; x=1764013151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K36xwmi8QzbZYxYPWk/InVL39QSCuciwcJPm/PdZki0=;
        b=fdjQDgXaAN5P4iP8amn9qFyaNL6rQstAlR1YCNhgjkarLD1a4JLVT6Ikpz2S1wOT0L
         sVelFZtvHBTcbz/Qn2zK1njw9Ebk0fMbqdnwcoNIg0rVdK2ujh3jQIsrKdgJ0gvBxrJc
         r7jnVUImM/m0w1dK7AIqfln7EbVnv3kEYJq/7FCl4qiDfYXWn29aBXsL3LmKNKNu39Yb
         2uJZt2T7j43mTY4rMqOi85fdKqEHnMeSxXL2hv93Otke7U57NpqS5yO7eVKUCUsj9b2J
         X/sssZwVXHJOZhXUsce4Dl11X0jFUNdqyAfyPLdy1c16xIK0fdjJWzcCnaqaQiW+YBoL
         uWhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEovyrxv0r6evDRTgY0zBTCHimWrhoX3dBtUl7/3Sizaxw34kmdCLuTieJOJSsXXFAZN9L7lEVGw==@kvack.org
X-Gm-Message-State: AOJu0Yw+iqa2FfUysDNpsIuDXf5Nea6o7YekqSszDji6WWjki1P+q7nn
	ZKi6Txsb+Hfb/cjLRYoE2TF/OAtsyV0TuBSx3U6hZ6PXRfAv/eqOqUGGa15gyBc98gzHVncFMvi
	kv6yEopT9aS7HKu4BPliHT4/6mpPFsvdfUYIqpjGL5T1lrwVBrzGs
X-Gm-Gg: ASbGncsbTBxv44hD5szQ6+V/arTbrPeIr5Pub58Yep6tgE5u3dMFXPp1OfBw3kp7j30
	dCd/87CWBOKZCMxqJouPHrqbENNNXkyp5D1901z8Lz5kUW95Qb+dhqJKOZu6+6ogtrCkB2Vc34i
	BWJInhruEVH4X08ow3SqH8ABlZo5SLz9/g7HnwLx9ILfYLpRDRnh9d0YysE9cMqITXP1bnNbnTi
	ZnFo44BEHNsEqZVzP37yo24bb8bYD4OF7A1j8mSgIDlHLG46SKbIUJnFMS/Ud2rPUv6N3TEqijd
	ItC746lgsmPy3syVl2lgS0FZ7UXKbTVFdd8j4VPm/t5IQKOxn5I3i2Uogz6XC3MNTTAd6KKFQTr
	ELg==
X-Received: by 2002:a05:6214:c28:b0:802:a79d:3132 with SMTP id 6a1803df08f44-8829267c1c6mr192021056d6.47.1763408351057;
        Mon, 17 Nov 2025 11:39:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdehJMTGS035Eb/OzG7cG5rRd+07wCiKuKE4YM34HxqUOjomc6mUNHGC8OLoiF8h+l5gT9Zw==
X-Received: by 2002:a05:6214:c28:b0:802:a79d:3132 with SMTP id 6a1803df08f44-8829267c1c6mr192020686d6.47.1763408350619;
        Mon, 17 Nov 2025 11:39:10 -0800 (PST)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828658ae99sm97099586d6.48.2025.11.17.11.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 11:39:10 -0800 (PST)
Date: Mon, 17 Nov 2025 14:39:06 -0500
From: Peter Xu <peterx@redhat.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] mm, kvm: add guest_memfd support for uffd minor
 faults
Message-ID: <aRt52tDCh72ytIp1@x1.local>
References: <20251117114631.2029447-1-rppt@kernel.org>
 <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com>
MIME-Version: 1.0
In-Reply-To: <a5531d06-dd11-402b-a701-a7c6a62186a7@amazon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5wPfQwwa0Mhuc8wdMmIgsEhdd1hWpenTcQ5dAsZBLXQ_1763408351
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92A6B18000D
X-Stat-Signature: 6wdputkyc3mhygknkn6q5nn88ast1ebc
X-Rspam-User: 
X-HE-Tag: 1763408353-141837
X-HE-Meta: U2FsdGVkX18FMWEkD4DyNmMI5RMygxOoqCIRIRfpOCzIG8ShCjNiETM0YUFQK6cvaUVpnJmhhVa8SQ1HSd7xB/drRcyCCD+DHXe48xodCljkxkI/RqC1/OgQEXqrYSmEfezh1xfd9yaQqhrL+pHYPavdcAOnx7YY+pp31sQi14U0VWKH4QSPhwYiqaKiOw7VtVOEAsLc9qqpFqKxH92uc8CdLPqEzS7JAqLJWAQAMgxNHJt9I6x1PGYslslAgpSbug6BFx9WszWe0sfbIrabL3wERS4CxiMR2ivrXb8gSjuwtvAq75r/WXhZrrdycBf4wY+joX5+V3BOKR2MjImgmIq7mpv3LdcLZzZT2nF+WaItlon8L4a5Tm62jmO43Ey6Py15jWGzTgGHE5p1N0R6Ar28ozUd3aoSRIp9Xf6/v8Ic/elrKf4lQ/nGSlHYEOGN2ZjHtGqXA8CELXAdyMoh2N3Gma1FVdKQ+9I8fi4iHYliem+EqB40ebRksUKilGQByy6BI/tGeAsM5REioqYk/+dv/4sqZzMIPtc07CWZs5aav7pxGhF7jc1LuD6b7B5QSbmqtEe3wLEFU6Y3+W+cpuIl5yPkCFX/qPLWtCSEFz5rIyWh+OYErQ0U7e9ELqZjbJoPELLxL1JD59KY4Q6/45sTzARaf9KrjSBGZOxENEdI5pi6qdHPJ/vFtXBuQqF2cbv8Nt3ykEypp30ehrZL37/2afhHY8iDQaR3Eudv6CmqQF3UwU6DmQCw6mmjbdSLpx2zI0/Wl3Vv3otmMr0GmeTwbYsGcUVqR8m/vzDQ6Tw1mNetQMBaP90p0zNPaeMN4yJrFS1K0LDQDtmz5M6o2IzbHtnRLy0zZ6fE17Nr+7Gmx82dqPrqR8+l18bm0dFDP+TB/+1H2NRIsODqSwvFycq0Kw6J47TElg2SGuOBGQCLDa6GReZEWX5kOkYZWr9Zb6r/cGByQxSnSSjX9d9
 IaxpCTM9
 KZCSpRQcSahp/0hMUKkpo1ACA2gy10RQTFg4dzBwkhd2CHEunatBmsWc8rLM0SSIq1I48fNrV+pqQgPcq6p5G5D9wUn8tmRFAHaPChNgfXZp6wdtTv1L6t1h5afNTJwEfjKItpRGrRmZ0TzGJZ4vC7ledIg3hNXB5tpmzMWnNzD/lqGIaP9r90vq8Z6qku9wCKMzd5pqD7FmQ/N+3QT5qSBnWCMnEKkuEVVGOK54jeguWLu1NnLtdmBI/vWJ6VQBwPx/4if0U7YAK2xPjeslcUN0lPMzzbCXpGdMg6y0f4rotDDbMNvJe+gQBATi4lFTG9t7KETuoRv5FcFPD8o1pgR+/FJ2915L8EuNuWoxkQr2gLZTJvdUfC7MMi7HpPsvwBS9RKU1yo37gplKdf9aca2YaCYZDy77EsyfuR1iX9K3M33sfWQm3P7ARpbhFiUSwJ7MeFU+Fy+a7Ok0LnCf0olThK4Ws9muwOt+92eK51e01U/LWn8My00KNeQBJv8mu3TXN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 05:55:46PM +0000, Nikita Kalyazin wrote:
> In our use case, Firecracker snapshot-restore using UFFD [1], we will use
> UFFD minor/continue to respond to guest_memfd faults in user mappings
> primarily due to VMM accesses that are required for PV (virtio) device
> emulation and also KVM accesses when decoding MMIO operations on x86.

I'm curious if firecracker plans to support live snapshot save.  When with
something like ioctls_supported flags, guest-memfd can declare support for
wr-protect support easily too, and synchronous userfaultfd wr-protect traps
will be an efficient way to do live save.

I'm guessing it's not an immediate demand now or it would have been asked
already supporting both MINOR and WP, but I just want to raise this
question.  Qemu already supports live snapshot save, so it'll always be
good gmem can also support wp at some point, but it can be done later too.

Thanks,

-- 
Peter Xu


