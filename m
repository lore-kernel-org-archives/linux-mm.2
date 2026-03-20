Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D624E108B900
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2343B6B0005; Fri, 20 Mar 2026 07:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4806B0088; Fri, 20 Mar 2026 07:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA256B0089; Fri, 20 Mar 2026 07:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 020FF6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:34:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A48A4140172
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:34:56 +0000 (UTC)
X-FDA: 84566234592.30.33871F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A077180007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:34:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bFfhqtIq;
	spf=pass (imf16.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XAFuMj8200/2Yl3T2tu1n7OQ463xMtcQ3l4BrZLY4E=;
	b=A9ERdrLWtD/sJoMi6iXm710wOu8iDv6ZToa512QaXzDof2rPSVJ+VN6IrybjQrCGOf35yM
	PdW3f5fe9xQNv6j5IvKQLN/JwY0FG6MZdvVtmripdoTvVOFyX2HQuMWgImIKKIlU04NClC
	CrdCgRtyi2layjHCf7k4bX3va1oL16I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006494; a=rsa-sha256;
	cv=none;
	b=QK1huP4oL5r1v8W74L1L7M8cF8httrucoRGrhJVJn7eKUGWJZAb+wSIee5WMGjBhr/Gygu
	03L+idY8V6wGyjZgi4PE+1DhJ2UgkV0voaLo038FZ3kw/GWfeYFTF6K/anw07wRyVoDJjg
	yW1XRwn84AlZUcqfrvb10nx+LL2ZAB4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bFfhqtIq;
	spf=pass (imf16.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774006493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/XAFuMj8200/2Yl3T2tu1n7OQ463xMtcQ3l4BrZLY4E=;
	b=bFfhqtIqeBuElOI+hN5D54U35GC8X9VERCpC2ZNHsRKqiKBy4DWxVtwsUYT/lt0/4ev+ft
	igUXOg3zmrqSsp1vt48vbcPHiZFwIQh9e+tlDg/kb2PPCpvMsPr48tCvZ2AQpMYiTaDS+4
	eW4Rbe7LnhcvNPiYtByDZsMsit+4rTI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-B2E9rSmhPPWNUb3dmgy9Eg-1; Fri, 20 Mar 2026 07:34:52 -0400
X-MC-Unique: B2E9rSmhPPWNUb3dmgy9Eg-1
X-Mimecast-MFC-AGG-ID: B2E9rSmhPPWNUb3dmgy9Eg_1774006491
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b08025f240so13027665ad.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774006491; x=1774611291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XAFuMj8200/2Yl3T2tu1n7OQ463xMtcQ3l4BrZLY4E=;
        b=cGx11WI2TpshQU5QDamsSe01sFOraC8RrhoDDMceFnDNgbzZVKufL4q0E1AasiIAP7
         RzEMSv0JYAw6htYDKxQwR73ykvhyvdtMD0pnsm+N7zP003nfH3Pyapx1YW2uATqyBejV
         78cYbost+gYUpL5CUCF2qSisme+FBq4BV5G4IorKrkWfkj5PKu+q/zqx62NvCU9DH2sq
         DSzkvKqiWOjCiU47BGR3LJYKuIjoy36HynLd8giRCJhEmUJYR94LENGK5/skO5FOHHlD
         ouPV+0KQViqfXStycZIzAlaPHaPSHl9qMMYDbhgR6evnCkdhrOz0Aksa9YZPf0DmstWx
         Z3rw==
X-Forwarded-Encrypted: i=1; AJvYcCUeC1ifYmQ2qFkRxERKWwNnX9rW9t08INnX+vUTlXH6HLsQuWbXwj4ZfALGNhO6Ke/VUeE1YABwnA==@kvack.org
X-Gm-Message-State: AOJu0YwnZsVeY9StxTJVdZ8lygHJDa4K8kEhojRMYPM1JUdUIkfTlzja
	iX+BXqbUUEC3hczb5gVPegWHRkvBhvx7UFRabS+UNnUFpemIkfKNa2FHigoZNNc0q66ozC2PKa0
	t5tI3EXHtpp2YZ/BINiIEBidiIYWEM/vcFxBHSC1vh8UQwSwK9pBn
X-Gm-Gg: ATEYQzzjivBLKg8PPMJS1XsUY8D2CkCPV+qrMTAzTYiZWoUd9T5ingTWdanugphLONT
	NX1tXAUBx9WPX72cSrSeVIyheGnMpbqCmntY0BkVatq/eOGJq3MuAI1/p3y/5ZB0ru1Qar7xzfy
	xc0kDQqGb0Jzh/BV00cXtLqzjZmr5fVC7o+D23NVHVgZM+Lv4ml06Re3mQDnvJTp7Un2bOjyV1g
	3qgWNzz1Qn/E4Ad8MM/0c08KDfWp2G1b6qOka9fsKBZB5C2BDeM+CkndkJZhOZUcfFVPZZYpapV
	7F64CAkz1giXZ4IgvAQroPjntIKiPEaSIDgN/2xPsHaTm8DB8/NSqxfFfBqAkKQIIyPzcohUCu9
	wfQdiWFWdB7gklHMQ/A==
X-Received: by 2002:a17:902:c40f:b0:2ae:4d6b:b2c7 with SMTP id d9443c01a7336-2b0827564dfmr22400255ad.9.1774006491326;
        Fri, 20 Mar 2026 04:34:51 -0700 (PDT)
X-Received: by 2002:a17:902:c40f:b0:2ae:4d6b:b2c7 with SMTP id d9443c01a7336-2b0827564dfmr22400125ad.9.1774006490957;
        Fri, 20 Mar 2026 04:34:50 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836a3066sm19628795ad.75.2026.03.20.04.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 04:34:50 -0700 (PDT)
Date: Fri, 20 Mar 2026 19:34:48 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH 3/7] selftests: memcg: Iterate pages based on the actual
 page size
Message-ID: <ab0w2PCcYBEKxm2B@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319173752.1472864-4-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260319173752.1472864-4-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uCoY5GecUUZ9EhhV-FunIGVv62LvcxAn9W9lGmuaajU_1774006491
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: fwhzjyas97grqndzh7ae1x7qt8nj8595
X-Rspamd-Queue-Id: 4A077180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1774006494-727464
X-HE-Meta: U2FsdGVkX1+4V+P1CsP8LQmZMf/IBvG50OPcyzquua4HCo471imMNTTLhXbhgNQcz8NWo+A3fHc4wrNN5G5ICnN95hXEajVznn+GQBTaA1lKq9Xod3ZGOfld4CpL1ph2PZ/bez+vd2x9chhe9hAWC7nDaPCuzgGtFKy0NATVcqDwmnHcnlr+/Uz6iRNoDCoEn6rQuoMOdPubmUBwwZJybICfplSGY0VZDDwR4jC4ouO9dgQMMX5tq+JzbADH9JiLos0tNW8VKJT1ooGki1cqzMe62zh+Nfc8F5Td//auqEmu3tL+zeB50zgY3nouhiU6AXmgWzHnfeJWYeTA+jlwyVyvb8f2Sv4cxySZhsLnUVwGJW0D6zKhpaOudcQDxLf/hN56GJ09dvjAbW6JpUBd+9vA1V3UKN+5zwziPuUbFfstl4v5WxcI4bGUs3wfdaksfuUnskwvz9K4d9RC52Qzdz//7LTOnJJYOdrbWsI8R+tNA8kZOlDYRW0DtEwnRLrMqdDpD829xShSwnW4F0bkAbTp4pGVjZrE44w7c5GU8R5t6v8wyrOfWaKRa5E9KXXKb0B9J2iaNr7ce7IUBL9wDNIScLO6GSoQ/kPUNyp64QcIZCIMV82KnB3gEQICYbJoubpoFAr7sQ91l31/AzvYxgj+zw0gWK2V2lvKTvXVeQdfiBCw8O9IJMtC1/hRbGGSm6HxQfDAA2fQ8mMAzH5P7gbs6zH+I0YV+3XYHG6kJN6TrJZ00Uc3frr+r1KBPC9CUVxGIZQoCmrM4DaikbM/bCw0jFR7ZNRBdToLW664V90SZoY4ysndWi3XXbES4y1LGYhUUnARhHNKuxA3icJC47ZbExECnuUIdgwsQ0HrUqN+dMoUKSxm/GQlbXNYB9VgKzeRMXtzeJwIb6+ATkuHj+CucRWZklZReir8uzh87Z/1zK3zCpLppbZVqPCaUXrogT97R8DXny5dCUpFAZI
 zpqJnr82
 4NYP4uMnUxBMUMHp60jKyj00YsYzTtla868LKXbYiNPK854+QvsUvQaCTv3nfClkVeUUmyLNgrDp5gLy2XI1E5oQqA9GhlHChQNjqy7BaOduMrMNfCkE6FTa+875PymbrLtJSRbvhKjKkw4CibnKxhJQnTCS3SJQVQSrQzBVR3kVheRvkCn/qxqFoYqgQ6xzQr5EXcrzHAJhu7o8x77WJAgUKuMNotekmsX5AsZ/s/Xyyx0ZKSL6O+3rQdWG086bCUvFzYmFPE+p1Vvdf2AKbnhNzqeG2BVsRzskD+tNrvF/iBmQZORo1TLLrzU3l67JHJps5SGddM3fYz1MRq9ilXJQzNogxbydMXhuW1p3VpoI9RW/OciiUlcwT80T7ixUu3W3VQu4gbFHRc1MyAviljk5F+GIQFh+oIl5e7IVAv+NSRdvOmHHOzIN4z/nx+quxUpzrnjkWCzLoiIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 01:37:48PM -0400, Waiman Long wrote:
> The current test_memcontrol test fault in memory by write a value
> to the start of a page based on the default value of 4k page size.
> Micro-optimize it by using the actual system page size to do the
> iteration.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Li Wang <liwang@redhat.com>

-- 
Regards,
Li Wang


