Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19708FC72C2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 11:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93566B0098; Sun, 22 Mar 2026 07:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44C06B00A7; Sun, 22 Mar 2026 07:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A996B00A8; Sun, 22 Mar 2026 07:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B77006B0098
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:30:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5308D1E496
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:30:01 +0000 (UTC)
X-FDA: 84573479802.03.4902462
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F02980003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:29:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OgB/mRjo";
	spf=pass (imf02.hostedemail.com: domain of syoshida@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774178999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XisQ2l6ogLbGiZljuMaE/00Dj4me1YI5fSnPkoLFZQ4=;
	b=V+Ddf7batnsiq4CfqnHXr9XhAJa9IVWDzaeRiE7FZhMvBTLeBQJWJ8k+kWxAoGv145quqE
	Lg1bbywHvHn8ZHRIFxu2i+6wX/9vU5+6aBfVvjxbJP0wZwoXoBQpwT1BTKhw2MQmE+A+0E
	e/ivmWuMT2wM4BWY2wjTS3XNTRjWQwQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774178999; a=rsa-sha256;
	cv=none;
	b=Iqqk3N3z9hCGa/SB4E8/zCZIVKI2MzCCDGkgIVi9w0Qc4zcqQsxh9saoXGtsJSpFkeN3F1
	aVQioUbY0WjLFg9drTUKr5zvKWu9Wgeo3QByUjQ6nnhB3jW97bsdDGuYdmCnBi5IXyjSdV
	P4DEMnvt6lvrte4zyS5FuYw1SkxH+Sg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OgB/mRjo";
	spf=pass (imf02.hostedemail.com: domain of syoshida@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=syoshida@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774178998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XisQ2l6ogLbGiZljuMaE/00Dj4me1YI5fSnPkoLFZQ4=;
	b=OgB/mRjo5d33mq1fEl9SOi4Kpb+UCveeSUYzU5TL+HjCU5B0nZwaxdHEvcq+kFYdptt5e/
	PekdsL7fJZJIGEB/oG0jPdH34VkF5GcOdJTggs6VKMLzLP4wyGPy7UwVAF5vSGrwSX3OWH
	/wuFzpOjkxl3vOr3zEEmoslM4Q6w49g=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-2DksCQP8OACDLUpEY6xdmw-1; Sun, 22 Mar 2026 07:29:57 -0400
X-MC-Unique: 2DksCQP8OACDLUpEY6xdmw-1
X-Mimecast-MFC-AGG-ID: 2DksCQP8OACDLUpEY6xdmw_1774178996
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35a1e725a8fso14318330a91.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 04:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774178996; x=1774783796;
        h=mime-version:message-id:date:user-agent:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XisQ2l6ogLbGiZljuMaE/00Dj4me1YI5fSnPkoLFZQ4=;
        b=TSWPZg1KYew//YtTJHIjcY/AfmRHYV2Cnha61YO/G9rui51HEhv6b3TlFc9g5Qeo2H
         F/UrV6zl4n7nfkbX422Eto11zLQiS62HQ/DrgRjpE5vuE2HuSI0cjYqbwBYygX2uz0vy
         N4Jx1Ob5F5uVHB2Asvk0tu76VdIwjJHJXg33Rr9l73Yj5Zdd5B9f9F+NGO3zSClYgEea
         ahzPPGLXZUzvelqL8lyQnTzjDzz7dudNZpvfCpOem02X6Hah+QgRhNsKx44VoJSKj+3j
         YQ6OaP3odsFgiZcK5+n44We+R5F0TwqOYQQA/DFWbHCRWL2CxI8Ko0CazzXisv53vmk5
         IaFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9YkTO5c2DvNDhVlW5BIp4Tf5pjagJpCPjT8jO9dr903xpMhWHJnDZA4CWVSuJw0z7+05/oYpJ4Q==@kvack.org
X-Gm-Message-State: AOJu0Yza7qN6B6XxemuCf6VwrF+H6y064FdafmytyNuil6o+kTccgJlV
	p8LSsLDL+4xKJW1LIC/3Hmtomryif14XCJkuA+fRZl4E9tb7tO9r/S8yxyxTqm4ARJHcx1Age3Q
	GbkT8LeOdS7DznfHXRWTMGPrqhdf9Ds6VQj515ZxEnO4T5iDTJjZj
X-Gm-Gg: ATEYQzyDHlOKcrjvVzq9ZmCc4bOC9Te++N7MB9rKah1QvsLg5JrbHV+SJDitIyC7tPP
	zkE2JLxO+1H04Ud+bjUgeu9Zw4gRDtoAymjM3iUxP/LXkHRQF5LFe1LwrcYYam7qgHRgbIgXuw8
	n5/0rYyZQB8lxUPhuA6TPMpF6bKMbmFiwURCnRnc5ZwmvCUT9ESuEHpXdIekUFPs+5eV+DgdbLh
	vTM7TAbi03Do5gbrmIhZ95UY22dUTfZ2wJynaPFgerStolleB4gEjjEKg11Hyd3+5Hx9UspCWGt
	xuWfZetVQ84LatPzsFsDO5ut1KvYREKZ6bSN7wUz3Bj+2dlpGUsmwe+erdXbCq67hMT9xzCwrtA
	WsMQNfs/iQYLuLv35OBg=
X-Received: by 2002:a05:6a20:244f:b0:398:78cb:d85 with SMTP id adf61e73a8af0-39bce9ddf3emr8634365637.13.1774178995826;
        Sun, 22 Mar 2026 04:29:55 -0700 (PDT)
X-Received: by 2002:a05:6a20:244f:b0:398:78cb:d85 with SMTP id adf61e73a8af0-39bce9ddf3emr8634347637.13.1774178995435;
        Sun, 22 Mar 2026 04:29:55 -0700 (PDT)
Received: from localhost ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbebb2sm7205704b3a.14.2026.03.22.04.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 04:29:55 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,  Sergey Senozhatsky
 <senozhatsky@chromium.org>,  Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
In-Reply-To: <20260321104845.452d0f903a52d45d3b76894e@linux-foundation.org>
	(Andrew Morton's message of "Sat, 21 Mar 2026 10:48:45 -0700")
References: <20260321132912.93434-1-syoshida@redhat.com>
	<20260321104845.452d0f903a52d45d3b76894e@linux-foundation.org>
User-Agent: mu4e 1.12.12; emacs 30.2
Date: Sun, 22 Mar 2026 20:29:54 +0900
Message-ID: <87h5q8qez1.fsf@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7YS9NaHvT9jzveqN59faA59hMSrfLld_-pralrROsWc_1774178996
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1F02980003
X-Stat-Signature: txbibykcoiydwnhwmif1xg4w4gm4iwpn
X-Rspam-User: 
X-HE-Tag: 1774178998-265626
X-HE-Meta: U2FsdGVkX18h57pnc3EHpO4D3FHzMzH66KCytTg4I8g+vxpoTr7r5sC1klt3TXveVo2dU8vP+AK48JXa5rj8Xz28HTI32RuzwJiKRBpQgVlDY/2t8ijxxR4JT3gNj0C4tigknBUWfgLiJOVfef2wevLlYHSCuZD8aJbsH8kF61SedNJPxPYP9Ecu8Em/RX87pgybQOOL99nJ1MSEirwktYVgwautbzeI43ZnY0wVG5xJpmdllbXwcIgx1IGOhywgCXVhubylTRfDEYC2C61EHSwuf2keOcvSC+N9NsBX8qpj3L0qQRp4KEi6L11Z+PwgcLrpiqOXQIHAijM/oW1PM7nMti7ltWBn2a4ti+omEjVn7uT9cQHyb/ND4vSDRJTN0PzTene4HVBtoKQerD4PzXCg7WOc7MX3IGy2oqSuAoL7sJKFPNPO48LLrSWpx9kYodvw2J6zuR2QypVkmWLzEhDKee+WUrJzGQKY9DZVp5MrCVbhK/F5QZPbpwA4/7gWk+GPZFwsrtprX8GyBLI5r2HHqUg0fIx+M7YlxWmi17K3VZPwvcUab2KrLkSBMIhyV5ZfR+MRGwUZUuxQCxHpkpXMtWT8PMvhVb32jtrtnWK9YYS5z7T1qFopNDQto7l66hImQocK3H2luS4hhC3VOKibZmGRk37bHT8LTa9N5vZcA/J/uaM2tvj/kMFXB2sPSkC33/r67TAc+YFahcU0LmSGFTv5Z3MT1fyZjUnrslZCTy7bf+4pnGAz3H5uIFSw+5BJf1uAexE0Rxf/ALJumz0TPSJOmhM388KMd0VZ1wZuBc8n679N/M/RP5iduwmW9HvxUuMzSL4ofaXbktikBliQt8I4ldCX/COcF/0z6kRoehTCFAqWpYuFN6Ih5VV710sl3H+bFa0bw86b7no9PEHB/NbwZ6wGgDzCDJkUa+QcKvkdXNxh0e48hzjp8Zn/NGDtZlclbPGt+kOJhU5
 AXjssD2O
 BlXTnzS9MpOqKUN/z2Oi8Ou420iKan+FuE8jUwdgRRuSREzih6bPpCPJ5wVEe9UteHJvFXf0P1Aj44sp3N6K3nrpzUyekvMzhCiHtNdzU7MetpHFJ+D37h4hIylisxNcNf2/gxCIJtF7L0YV2zUk2ZEdt5moCSGceiiY7pFkIAUmCI1KT9zuzzXcS+LPrlz8A79SaF8SAW093fI41tBKp2l3j3jUgAtbpPG8ySV+gdQXHFBHXFeQBHUWDNwRYk/1hMQn3IbaKBhUj4CuH/uKCHRmpfPuO4VzsSZSAcSyX47v7UB/+qZMkuF+6ymubbHBXd4oXTqrHmyaOFtECIakxnTd6AsHQverdnrLJDNrNYOa/pu0e5bLzrG4g/ysklt3a0o9UIWgmVgZ0bWYsu+giFGE3n74sdyFHmyRSlO9zl+W+TbbtHye1MtttFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 21 Mar 2026 22:29:11 +0900 Shigeru Yoshida <syoshida@redhat.com> wrote:
>
>> zs_page_migrate() uses copy_page() to copy the contents of a zspage
>> page during migration. However, copy_page() is not instrumented by
>> KMSAN, so the shadow and origin metadata of the destination page are
>> not updated.
>> 
>> As a result, subsequent accesses to the migrated page are reported
>> as use-after-free by KMSAN, despite the data being correctly copied.
>> 
>> Add a kmsan_copy_page_meta() call after copy_page() to propagate the
>> KMSAN metadata to the new page, matching what copy_highpage() does
>> internally.
>> 
>> Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")
>
> That's three years old.  Can anyone suggest why this has only now been
> discovered?

I think it's because KMSAN is clang and x86-64-only, so very few people
run it. Also, this only triggers when compaction actually migrates a
zspage page, which needs significant memory pressure.

Shigeru


