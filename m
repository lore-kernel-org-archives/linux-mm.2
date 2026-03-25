Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FE0FEA81A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710906B0005; Wed, 25 Mar 2026 03:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1BF6B0089; Wed, 25 Mar 2026 03:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7716B008A; Wed, 25 Mar 2026 03:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 500386B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:21:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECB1FE07D7
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:21:26 +0000 (UTC)
X-FDA: 84583739772.24.40F83E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50FEF10000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:21:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=glXBATMd;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774423284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTBVdjMl0gw9L96tqaRdKumbhrIsABDruk8W4kuVLG0=;
	b=jvv4l+1K0XUVc9uz0Ak5m5I8ZO1OZ/q5xaeEeoJ/kuQMr4IPfSaXn1SveNl/Q9HkP8OOYP
	1LxEFrElZnr30mI7OghtxORZ7yUCq74SZChNynuqESXUmmt8L+i8lSsjI5QJU/E12yFcjV
	QZrhJl9H7wYnTpbsGk4Ymej0u8cDCuU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=glXBATMd;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774423284; a=rsa-sha256;
	cv=none;
	b=37/lIHIA648lpcDZlaFo6y/UeBVhjwmrrvRlW4enuyfsJ4g6oF/FLcRg9sUw6j0D/urLpF
	fl0Hqn8p3jTzbEMFfwsdv/FfuOZAToJXbbO3n5ltHbiyMQTBCllLFrqtfCwAFTFwbOx9UA
	NyoUntGxOjFnDxXmuc4mMIKaKlrK8AY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774423283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CTBVdjMl0gw9L96tqaRdKumbhrIsABDruk8W4kuVLG0=;
	b=glXBATMd/3QbfAQU/n7vW+eg9HIL9/zLsqnGWaK2duN60HgA2dBXRfnJTBNNOga6f2IfhT
	lr36t0cKi5jeoZNZZvPDM0HWP/8UguNpxRC1/EZdXB1LuGcRZ5/Ns02VTdUInP05IWOY7n
	Cc4OfuCvvvv8KVkJFwnAGiM/0ypKPYw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-9T8t3XCINc6TSHqmxvJ-5g-1; Wed, 25 Mar 2026 03:21:21 -0400
X-MC-Unique: 9T8t3XCINc6TSHqmxvJ-5g-1
X-Mimecast-MFC-AGG-ID: 9T8t3XCINc6TSHqmxvJ-5g_1774423280
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b0560c1320so140271165ad.2
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774423280; x=1775028080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTBVdjMl0gw9L96tqaRdKumbhrIsABDruk8W4kuVLG0=;
        b=iHCarCdlSaIAjxdIVacbcd2kfqxpVcRk84McSvW+KodDHSIclN26swnM3e2yLVAIfv
         4KAfg31m6LUnAvrtWbkw3STdAJNMFouHCJwC8v6HL8S0b4XpDEez4ONxdZH+NOV8qhac
         z+CTtYc2wfsCX/sY3OmCGTw8cZ2qgnwOJ2NBcqwbxXTcRnPPzP40IlS86lrlZFmpCB1t
         7688PNouu5MeUO1Y+gZ2dHMmWFvkAUjrTT4yr5PBm0r5J22S691Pqr0oOIVQW24Ck3cE
         MEAj32JC4KMXnJs9kE5Hj8ZDxhrY1bJ+sy5aXHmCCqkA6AkfT1jrn+/b6f9q5EmLIsjf
         XsLg==
X-Forwarded-Encrypted: i=1; AJvYcCUgA/N4LXsJTZb3MIYxpdOnl9bjEPInEkf/W4lpTAJuJ81MQ6d66DorNhfbPKOla5W4g3/JbLVNGQ==@kvack.org
X-Gm-Message-State: AOJu0YxIuGj0xvpIhdnDMYYeUgVThFsFf0YGEBIk5sFwsFSgyqVShkDD
	O+eXlZO/PPd1rzNBYlqIbngLR4nkjqGdMIxJrJBpQCUUUB3OhMxMzqt/EscLbiaG4Wrt9hWAzam
	sMil5RRrw1O2EsXg0K1TPt9jHwCQiPk044T9OlilyUKTZ31v673h0
X-Gm-Gg: ATEYQzz1mJvZPo7cxcs29hKVtYcCPpYeh5cSmZauRqOim5lqPTDAkNPI7Il+u8pf7Z3
	Yolixzfm5JIsc7ntMavhFgWgt7sdzHoBzaDzBiFfFV5oY/K97eFvsrpQXcnUq8BxRelknGL4B5O
	fSubtm3eYwf6VRboLS74r5l7NkpU4UteQE1ymm+lp+X/GKb6iTnKt4tCExKJiEkLCVbtplgFp8H
	3PA104OB7DPOogXx7JOU97jGs6pad0j4tuVrzAR2XzZ1cw7t3SLMibf3GCsfAqY6G9BtAf9WuBS
	wmyREFt6XbTmudeRfgVs3RWwhmHYL7HWpqePeaVSvC2Jl+KPe1iNIK9LkINvpDPcnxVtj9+rriz
	MSrFo/1GryM1vq3o2xg==
X-Received: by 2002:a17:903:1b28:b0:2b0:659e:97bb with SMTP id d9443c01a7336-2b0b0b0d6fcmr25894325ad.46.1774423280290;
        Wed, 25 Mar 2026 00:21:20 -0700 (PDT)
X-Received: by 2002:a17:903:1b28:b0:2b0:659e:97bb with SMTP id d9443c01a7336-2b0b0b0d6fcmr25894045ad.46.1774423279806;
        Wed, 25 Mar 2026 00:21:19 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516908sm210835885ad.1.2026.03.25.00.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 00:21:19 -0700 (PDT)
Date: Wed, 25 Mar 2026 15:21:17 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com,
	yosryahmed@google.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
	tj@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acOM7duMf-9plHAC@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
 <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com>
 <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
 <acNH6C6Ay7As4y60@redhat.com>
 <CAO9r8zO2Nq=8dGBuJ0xpQTEr4EM2iJ=WNULtCU5FLLj4a23dYA@mail.gmail.com>
 <acN8tN4FhuoxCxzs@redhat.com>
 <acN-BsPf0OR50sTP@redhat.com>
MIME-Version: 1.0
In-Reply-To: <acN-BsPf0OR50sTP@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hC74YzdYbfZ4RUHod7Z2HDaUvAKS6BVDEyWnGI7q2qI_1774423280
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 50FEF10000B
X-Stat-Signature: 65sbadascw9gsfjfkhemsxru9hgx77oe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774423284-470376
X-HE-Meta: U2FsdGVkX1+7ttsgla304fS52aLFxnnXA5+hjbGVtS5ORwBmGVO14pXw4jaiU7VoZLkV7MXJ5TYr+bEYvmREDI+u4hQB2CrsPpBCgCOvJvA0tgAiB6sad3LcyxYT/woetmXUevLSp9mD7MM8PC61ZFC1Zmcpv2xFso4+Gk/5XK+p6wRgj0isyAr0bnM8KnTwrjhFymXGCn1sLrAMxLgaXQcEa1Rn8wIP89AowEGKn3gIS4OrC1cruY0OQnbpku5TbAs5KKOSKIURp475ubGvLx17bDvntYWTfYOz7USAFFuTVFr15vytXMhkJ64e4Dfe/DJ+E2CfPMl6As6zKpDWhcxSiqx7/LuAZQK+PgWrpWERHT0tgFiTEBLP9cXgSal8qz1t4M0wEXrzDzugoMZiAVfgqoeSF4sxXqud2GIwFzAlABJxcwW9vDpnfA2pJAmdo1XmlfVVfczqDMhi+iE8NxEHjz02Vf3MsSC8zlvwgrrrZIwply+mobSqyTv97XrISqZ9uCv0v8W/aKGvcjN9PHlr9W0OHlK9azC5pMRI9JHKaIu+3m7B9zo6lgE2FadrdPGDo3um1gp8UjGo38b95Je0xsB/MgzBhJLazHJQjvsK1Rq+/8BJjhSIKHLu1rb88XytBAv8Itix7bW/fPNFyr7ht9QluOwB9q8yDM97Gr76PWuT2ljNcxAexDywmTOTHGwU/Aued2XOhFzRB98LSph0GPb78TENKLUDzORnjKOWMpUsgKZAteRqTwhVFOv5vMpRKOIO1kAWJC+DUCB+QQ+H3BQS1GjBDW9RMb8v84LaQvcGjLT4MhkJfO4KWd6/+VfZcH7UYMpV8ZDQo3ZQAcs0vjq3Adcm1i63lG+SA3iYADgf2ZoNoRtsiX0wuNBBm2biNkQkAWjALgvsLBeVI57hUzLDcGSXYplcU6L+nb+xrBwt80CdhT/M1J8UMuT6ZFAEadtaE+rOd0Ulorx
 GvlMasyu
 DBNsW/ADALB/xCuDc6rdfULx7/nEfHgw+EUMxscEf11J7nTvKhnIZMWO7zHEsJF2f37UfLg0ZBsj1g+ScMvjeoq3SiyRrWp1tybrt7+SSr0CnO+H7zRwfPtnnE5kf3h/nowzP0Z7Zy4wKkMetEfnx/6hFnvQBi5GYbIAtM3Y/hdj7HaGprqVGRqs7+9CjzDxROuL4l1HsRqdfZd2n/HmKcoeSeZTOXyuKL9ARDmbxsKaEkSPhHKFhLI6PiuqXqsTGSQYDB5YtqYPnM2VpZnw17kuF17PB+4GUMZTbtwexaMOAWL9y4HLJT/neWXcf5eHiHVa7raft4YWZVFJ9kH1nZ4YqcS6sgQ9ZC/0fdA+Jqz0aaBP6XOE8omOuIbPaFVGKt5Xa8jZ4knV0Pyw14cBbF3YODWGlXCVfTApWX4P0tyyekKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:17:42PM +0800, Li Wang wrote:
> > In summary, the problem is that 'zswpwb' does not update when zswap is executed
> > under the zstd algorithm. I'd debugging this issue separately from the kernel side.

Plz ignore above test logs and conclusion.

> I forgot to mention, this issue only observed on systems with a 64K
> pagesize (ppc64le, aarch64). I changed the aarch64 page size to 4K,
> and it passed the test every time.

Well, finally, I think I've found the root cause of the failure of
test_no_invasive_cgroup_shrink.

The test sets up two cgroups:
  wb_group, which is expected to trigger zswap writeback,
  control_group, which should have pages in zswap but must not experience any writeback.

However, the data patterns used for each group are reversed:

wb_group uses allocate_bytes(), which only writes a single byte per page (mem[i] = 'a').
The rest of each page is effectively zero. This data is trivially compressible,
especially by zstd, so the compressed pages easily fit within zswap.max and writeback
is never triggered.

control_group, on the other hand, uses getrandom() to dirty 1/4 of each page, producing
data that is much harder to compress. Ironically, this is the group that does not need
to trigger writeback.

So the test has the hard-to-compress data in the wrong cgroup. The fix is to swap the
allocation patterns: wb_group should use the partially random data to ensure its
compressed pages exceed zswap.max and trigger writeback, while control_group only
needs simple, easily compressible data to occupy zswap.

I have confirmed this when I reverse the two partens and get all passed
on both lzo and zstd.

Will fix in next patch version.

-- 
Regards,
Li Wang


