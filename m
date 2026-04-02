Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B31D3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1FD6B0089; Thu,  2 Apr 2026 09:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883066B008A; Thu,  2 Apr 2026 09:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771526B008C; Thu,  2 Apr 2026 09:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 657226B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:30:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F13361B8754
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:30:04 +0000 (UTC)
X-FDA: 84613699128.04.428881B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B43BBA001B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:30:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W69XV4mE;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775136603; a=rsa-sha256;
	cv=none;
	b=lth0VS8MONFNDm3alTxBYSPXjaooDOFlWJiUMl+ULJRp96RxkrudcdSLTSPn2NtinrDHXO
	R513TcCGY8wMo9CPCliJkSu3bYIDBgFB7i0AjnBySLc/l92Hp9fdskmNigQzPcw8rWcCDX
	ufLd2AdPw3gaHKaiLo0oElNjIcwR7Hk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775136603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oab+9bmugFMLkp4c4nxmqbTKnHGTJUk1xqQPbFv513o=;
	b=aSw+0brUVY2F8RfTRsj86yr8U39Ry7RKE5fjy6mJIoZN4FZ3p1Akrhgk8Kw2liB6UvdSOu
	H0RA7A4SzdYsw2xCImz0rN0Mc0mv78ZNvONXjBAiXbjeNT+85ontcnLmajT7Q0CXm/3TAw
	SLC7fwSnE0AfmyBxCJKjozsrFzvKIEk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W69XV4mE;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775136601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oab+9bmugFMLkp4c4nxmqbTKnHGTJUk1xqQPbFv513o=;
	b=W69XV4mES+ILYyjs2HPueiXJWSaRhbSBjm/OhwMdmzyjB/cqA81ojBdO2K5YFs9qzv5rKj
	GbcrL9sTcpGaVYwWICbiCiKho2KA0cTxxhQxkfiHlkIj4whymGQp9lAdvWSLD7tGsw4uAS
	2hClXU/JW2u5HWfRPeDUaNPHq4myIe4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-xTrEgh3iOYuFVyHig7cJcQ-1; Thu, 02 Apr 2026 09:30:00 -0400
X-MC-Unique: xTrEgh3iOYuFVyHig7cJcQ-1
X-Mimecast-MFC-AGG-ID: xTrEgh3iOYuFVyHig7cJcQ_1775136600
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd781c0d90so509844385a.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775136600; x=1775741400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oab+9bmugFMLkp4c4nxmqbTKnHGTJUk1xqQPbFv513o=;
        b=jjSTo/kxvo1gps/d3cBIMY15d44n3HUdM88byIXgnTS/yibdCka4jQN9R4qf82M1ro
         7yT6OvYsU8hYsg6DqUpC+xM6IdIpvlE0NPxkw8WOrMbwOUPNRdibhHji0TSgnkExUL53
         UHAhU734d63OGtEqiAjgwoU9E4jebnwsiwAePFabe5S6eG3UKsI8b+fVm2hQnM4pDDFs
         ky2bTXcTeaDL3DJ9N17AZFYxla/q1er/5MQnkugRUy3g0yekvAEdg31pmOuNGbxDgVNK
         4WHuc2zgaQNDIZtkN11Ki4q7Q4k6VXKN5fD/kb9mxB6zB5wenB6Bn+P2IacngsGYaVvl
         439Q==
X-Forwarded-Encrypted: i=1; AJvYcCVRBdRVy9e2xqadSnDLFB6969rmpGs7UIIT3YyR4cGIf7IkjOxH8xjXA+jSt0J65tZn4akr+P7v9w==@kvack.org
X-Gm-Message-State: AOJu0YzLftHl9sqaUbfecJWfWjCSfkNcFQpD4UKF7FGiVx3gsReEbgWF
	/cYYFkuDZaEOFPDbq4xH5Us2g5JeAYiWSrij6N6RDi5l0v40f3RLJP7SiaA41lFyzJzMu2+l/Tg
	mtyIBjc3LQ+XYoIryVlZ7bvbCFm0/KkSTtzbWQd/NIKqCclKkGvyLMNPp/4eu
X-Gm-Gg: ATEYQzw5TRTIPmKCZJJIUU0wErMgLkdx0JwQBtn9n1xyoBaEa5gNZCGsD6kaG4p28NX
	5qFjH45+2OqEZULcV5ht4oFAM40jaXnYjJTeqRrTm180PeoxEuytr/Wq2YlxEUui5lGh9bWEaaw
	P/0AxVNPStpyGhmBo4duv7MacPpHZQXwu1y4sW8dN/R5CWnbjJbUCokzDzKLAYqcaaoIgOdpqVj
	fQmiW3IcpLzvJb6Izd4BQ5K6QHCDjm3DSbIbbYjyNL/HuNxCA1frok78ABNYR++hSxahmD5zXp3
	kXNyekXKNGblLNenHoU7Ad03IVByXIns9J+CcDkRooguaC3x3CUiEgfbN7DzS2N1y2Ay8QnYgkw
	JBjXNdviAV/VdX6qUQuXXY4kqReTwHbLdFr5FwtIEEbK4yg==
X-Received: by 2002:a05:620a:2947:b0:8d0:907:a318 with SMTP id af79cd13be357-8d30321dad9mr264192885a.27.1775136599624;
        Thu, 02 Apr 2026 06:29:59 -0700 (PDT)
X-Received: by 2002:a05:620a:2947:b0:8d0:907:a318 with SMTP id af79cd13be357-8d30321dad9mr264187485a.27.1775136598937;
        Thu, 02 Apr 2026 06:29:58 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5c5fe8esm217774385a.16.2026.04.02.06.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:29:58 -0700 (PDT)
Date: Thu, 2 Apr 2026 09:29:56 -0400
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac5vVFXgyqODXaab@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
 <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local>
 <ac3qYA40OW29ibbq@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ac3qYA40OW29ibbq@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QKxbbvmGHtTCP9_Wla4MDPvL5TLlN4x1EAGx-JynsXY_1775136600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B43BBA001B
X-Stat-Signature: zkyqfxz9rjjrzg534gnpyakny4bw8urj
X-HE-Tag: 1775136602-221760
X-HE-Meta: U2FsdGVkX18hiG7shnh1rWOMR834+LkkRMNGs/SObCyNzX0dkRJQn/v3R+4/A7RzodpMaUY/sztlMd+5AtJEXVKbJh/1UuW0dKdiCeRRVKm/XgzKJ5dflv7OZVaPz/R+PM6x02OT90ewTyWBUG64844pTxhPLJgG7aqGCqFnimnXH52/4scYfg4Vh78bkZ4D9JmlaWlGUJFtmx3In30+qADtg+WHUm8ZUuk4y01WtF6yACldSEqQy0bXOwZ+VRziLndK3y8fvr4IAqtqg4V/cJ8HUkPNWy8oLFAmSGD9gYhfyF7udGMztlvhinH4DiRIBfQY659SO6zYBB+Mi6zkzbTbsqLH9HU+JIWRULu+z6CZHvcn/PjgIr6X65D49vyDppRPsRtqqLBSgHjmrIDalRViLLG/aL9W/EWJxxgiDFtsqo8gVZw4/o0nUhjgJwh9OpZvyp15ee9NaNMUO2A/y32hQiVSslvZdRgpgutBofxZioKCnxB4Z39Kbn3MfmuesbXHduJB88yxGocNuDEmQw6TMZopsxqFOpPURA2UqA+o7bRs+Uboi4eeLHcmXWxTMX4s1nw41UYNDCGcmBfaF06+QRtG7ut5ZxdNnOVw1qx6OxBhH7JsHfQ/bMROYfSgek4F2c5J1tctwgyrwgPrK4PtBHWV2XLMqzsbJ14pBguGfyfBGcJHapQ1Lxj62hpfH4HqXWq4wy0CAQK3nZCG9ADre31mfBUnSERSgNvd2HAQWYV6mo5UlTMmPnyKVsycf2W3IpmyAGbgplR22XO4+QJA6hUuADEP8i8SHCTPKc9zPqxz8ugvSAHBTuD2iH9cuSQMfH/gse8wcluOudiGXmZusVu+iGDstIbXm98Opt+2kTMzZ80Kxk9gaYSOfUTfVnZDpkHNVhYmupznA0eOXqIt2pdWD9y2TKiUoP08OF6wrtTN2LxgktGhVBm+hR1qnHoPT0uHtILcDHE2ydv
 uXW6HgQl
 2HtA6zDHD6XRJeUxqxypby5/VunXYLEuwObK/Fx5ZOg2QQJWd7yYagCBDP6Z1GBYVT4TNiOFwW+tk40Plt0gIqSiMegHjtETQDHrXbHqdx2/N1JQ55xS7KdJlXvRzi6etDWPcQ5mcYtXQ0BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike,

On Thu, Apr 02, 2026 at 07:02:40AM +0300, Mike Rapoport wrote:
> On Wed, Apr 01, 2026 at 03:22:03PM -0400, Peter Xu wrote:
> >
> > The other thing is I just noticed the err code was changed to -EINVAL for
> > snapshot changed cases, sorry I didn't follow previously as closely on the
> > discussion.  I think it should be -EAGAIN.  It's because the userapp can't
> > resolve -EINVAL failures and app will crash.  In a VMA change use case, we
> > should return -EAGAIN to imply the app to retry, rather than crashing.
> 
> No. The return value should express that the VMA is invalid. -EINVAL could
> work, but looking now at the manual -ENOENT would be even better:
> 
>        ENOENT (since Linux 4.11)
>               The faulting process has changed its virtual memory layout
>               simultaneously with an outstanding UFFDIO_COPY operation.

The VMA changed, but it doesn't mean the UFFDIO_COPY becomes illegal, am I
right?

For example, I wonder if it's possible someone runs soft-dirty concurrently
with userfaultfd, we shouldn't fail the userapp if there's a concurrent
thread collecting dirty information, which IIUC can cause VMA flag changes,
and should be benign, and I think there can be other things causing the
interruption too.

-EAGAIN essentially requested the user to retry.  If the VMA is not legal
to be operated anymore, it will fail later.  However we should allow legal
users to pass.

Thanks,

-- 
Peter Xu


