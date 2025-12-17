Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB97D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4D96B0005; Wed, 17 Dec 2025 06:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CD26B0089; Wed, 17 Dec 2025 06:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C3F6B008A; Wed, 17 Dec 2025 06:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 871316B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:44:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D0F514097F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:44:58 +0000 (UTC)
X-FDA: 84228781476.03.2780B94
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3CEA4100003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:44:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PiTfOijV;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765971896; a=rsa-sha256;
	cv=none;
	b=fdOLe8+oVrsfDKpLAvicpwbj+ERoLzgvSfwfPCJxNGtTeVv8N/H/VWvpNhxQc1BDB9gsni
	PCJEQXsHiebNJTQD0j4fYwH6o5RiAzeYECM/eclvvjsjtqXoMS0ovDcnF/Y2yUfjDovKMW
	jy9BLPFuwZ5t8gemLy+PjjX82+TG1dE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PiTfOijV;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765971896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUxF2tYr95VdL4lhzoIMI5El8zC5jNsVaJWBiHVxrjg=;
	b=xr+9fS74778W0iuC8fSv3y7DmxShbMdB/sls8QCROOuJZXYgmtguxuhapviMzyeaiG3jtR
	WCsIpSb5eJFWw0KfZOiZjTyd1yvHvoQEu9b566X2GwI9ullCffeP/g4S2+Are5Q2FmZp23
	PccYiwuy8DCOIdVj0fGYn2XojPjh+xs=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37fccf7035aso44817761fa.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765971894; x=1766576694; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WUxF2tYr95VdL4lhzoIMI5El8zC5jNsVaJWBiHVxrjg=;
        b=PiTfOijVXN9FgokhS1C9JKDYhW6NbMt/g78JrR7noim/UxMZZPrDoEopD8QXeA7VF0
         4IUs5XyyhR/G1zKoZkOilcM1TnDjkxccuWqjCKfaOqUguqyT5TPLlcUUQlDNB3DpZoL4
         QTL99LypIyx9Er7FpDxNoKh+W5ThM+r6DWs/wds5IiGptKvj/PzN4O6blvc63Yn1kVGj
         U6Nlmt/7WBTpQJbXnVwruequoT4NTtD4qSPD85B7G1cfZypHYPtsWNVklipk+rSAqHOO
         0k2WrkT0bpPTru2EGRARukmWbPWkEyZaeQRMQjZya8HEo5US1q8sc0G/F/rGvynm4ztv
         fP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765971894; x=1766576694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUxF2tYr95VdL4lhzoIMI5El8zC5jNsVaJWBiHVxrjg=;
        b=d1Wl7V8lVgD/7tjHR7upVxm+lhVs/YotWAtSHSKB5WRRrtrk+TjsGApFeGdrvZs7b/
         1/isX8h4nU8Ty14b6Rf2FxBtIi46v2WCEyMPT4C+U9yGvRPmNX8Vsy7SseV7JQaS1AzN
         goXjkdOIxP5X2omftbTVUgMwE5yH2YeRbFfXhKMjZia3snskdCDW/j/+hKXdyESh8r+n
         I9ILLKZxoIYqpFLq7Zw8XPnHRRUVFXNSIQpA3BfIFpJUsf5KVJd0fLluR7S3kfcSBM+m
         yiwt1Ws1g6Mii9N67QNzX2nzBih5DA+dvc6BuaGMC3irlU1xZBHa1C1Bru4+3U+9fAYP
         oBLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpPtsCo5NQi2wvcTKdmbHwFP0boGaBANgg/fNHCaKn7DVlXrIblVojKQziR6PSqhEMiwHinYLyvA==@kvack.org
X-Gm-Message-State: AOJu0YxEDDupkMp4dUiWuZ1/khWALuT3A2mY3FmeB3wwMjPRudYxfTA0
	KKdsnL41w38CPd7TPUpbmoA0zVkjvEeNmlo3EVcqMiFE5Y+cSIa+s+TH
X-Gm-Gg: AY/fxX7Uza2aYts0qqomQkyQKZ9MsVeiH7/ii2/SbirPTdt9WdWg+ouMukls2v1uZBu
	8alwNloTY94vQs1hTj6b9WGYVtuQuMnaQwyG134fQwkSQib5HdbqHROM3RmueZDz8q1CfDELBlh
	1dlKNE7G0NzaM2nPLqHp6MeAzsz3zkwhAuP8jpUjuOoFF9du24YJfa1sHgEtRhzdNHtNL1SQFHw
	VPHqPKErouYbyFcRoTxDjlifLpqZrW9WZ4uMxcswRyPjtWn1IkDC3ahKGAGROaTYr9/tnrGWCYv
	QxlNhvRB1xKzquDx1gCqge50c0ogGHbl0qaw37lObq3Cb1gJ1MtcNRbK/TXnQZ6PaKIhn4zDw8k
	KvFQ+ff3M32YM2VRhOCTUdjTGqApxXJ4rO+hQTtU2qVtYmcEBZSKF
X-Google-Smtp-Source: AGHT+IFnlFMh5lGk/zOymI8BJbm3P4LKts0zX06lNX7DArcdydKILQKJcbozknenpOui7kZh85vmCg==
X-Received: by 2002:a05:651c:418e:b0:37b:9e0b:e0d8 with SMTP id 38308e7fff4ca-37fd07a7c5cmr44972801fa.14.1765971894030;
        Wed, 17 Dec 2025 03:44:54 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37fded75d8esm50309421fa.27.2025.12.17.03.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:44:53 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 17 Dec 2025 12:44:51 +0100
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUKXs_3bxLyMvTgu@milan>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <aUIpciUKUeclNk2s@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUIpciUKUeclNk2s@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CEA4100003
X-Rspamd-Server: rspam04
X-Stat-Signature: rynyg3y1p7jawgto9keoiq3jk3e47k6e
X-HE-Tag: 1765971895-178806
X-HE-Meta: U2FsdGVkX19n8On8AjzMrBsSxC8qJsSE+oPKRhwKmlFcMSS3WRZ+nWPhPo+E61ot1F7uJ7b7Lc6k+PNu6JL3shVHCIMMi1vz3zLme4+3k6TQ2i9lS65g+ee2A//wSBirdkkGj4KTlJqHKr6colXY3rOioMEL8VLTv4loBdHTK3Ctk61F5Zsi3knxcXTy8d4+c2UD/YrL8GyRZKqwRyOjrQpjpTZfXipYCIQuRK9DkPc3InOorOknkPHqvpkyz6xAJaa7gxALlySJSqk2iIK7ysDUBwq9+iKK3aEjy5AdQoI7oD21kavB7WtUNEf4lhzaFIwkmXmziXrI+iloQhn/k2Qs3C7bvQxLy3FD7Lvm0CgXwY1D8BECOCAoPb6HzNfvxURoJbM/ZV/iCbXmBiEx1Cy/7YmSPgzlaEWUBBb6fBzvukxW21hQTHGPLvTYOKwahEvsf5qjDBpca+ewy52m/fqGmtw8rLZV2xBSExokrDIYj3D6n7KcCLIqln265CZPpujSru3M24dD/HxKRm71PwgNPcZ/nZDB5uG9b57fU65AGPPoqhXDDJa78YuIvR/zAwCmghZiH+AO9V/SatLQP3TyG5R+cDALASegc4mPQ5V/LR1ZF5Z2g0FVIpVvvTFS8A2xi8VA5gkFsr0MsX/xx456Nk4+cVXVrXjP68miDYy9tRYVYxZ1M62JeIFo4m0DVK/vrbj1DadhmWFsxVumgc2j/Ykg7RYMQIAjtBlJaZ5nQAC9z/ypndZnVyzHBs1O/4Xxe/KmZNtUF1+oNGOm0KZTGdBDUKvPuYXeEeKbSui9vp3xZbZoIWGHrMCN4IUACNn58zbRgwiCmLXztIL8mHoAPoxKPeSnBZUHl50sqpcqNoQbNQcgnHTOzrB+JrYpuVjFxWBpAFpMV1McFfnAXYLBLkNEDe/S3J5DPMuWBx91TVu0HfThDNXnK7obZVnfFplgw2FlbPzcYmZh182
 v2TMmdAK
 Ljg4Gi8Klo7uCfGotv9t4T1yIOvt+jxWWWb7RilJ44sCHIfGMh23WMOwcjW6cTehTfeSrMNM1PydJuxXfmM7752JD4jTtXlgutHFKoAllAxGIKzsWVlGJFhKZ2NmQBsMG5t1pbfnwnsTdHG6nB9IMHhBGAX0uq4NgDYSRIfuYk2FewYvdN3XlLRM8iiujD7pRBvx1wnFacXibmTkFIjTfJG69C4mAhpp+2oSZMhx/XQB8fPx6J9xVOWMvP7ybYYnHCWhLYqJCRo87kkmebxA4UV4mKGTWDUINO1/vP22CoOiZoKLH99nerhOEmYFfrvXi7UBmfyNa/++39p9PZOKpjDgGhjNIuZBZJMkQEn6uiXf52NoYA26p/srvzWziplpppkLWDzC4iQ3mBoHA2IIyP5qj/3y0lW4FC7Wu780KRTPPN8ivC4n9+nIgNmXg/U+wmkTh+k9ZVaD0EQFDQHu8H/tIhK9sphkjv07TixpmMiJuqpOi5mXUVIPfxpWxMnbbox2EXz3DOZ8dSFA6+xa884ke7gXV1XghlO6e+7HlPi9BtAbK1lglPfOeQRIZMhxmekZtOEFCWUxrDPIOtHbRmKDMfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 11:54:26AM +0800, Baoquan He wrote:
> Hi Uladzislau,
> 
> On 12/16/25 at 10:19pm, Uladzislau Rezki (Sony) wrote:
> > Introduce a module parameter to enable or disable the large-order
> > allocation path in vmalloc. High-order allocations are disabled by
> > default so far, but users may explicitly enable them at runtime if
> > desired.
> > 
> > High-order pages allocated for vmalloc are immediately split into
> > order-0 pages and later freed as order-0, which means they do not
> > feed the per-CPU page caches. As a result, high-order attempts tend
> 
> I don't get why order-0 do not feed the PCP caches.
> 
"they" -> high-order pages. I should improve it.

> > to bypass the PCP fastpath and fall back to the buddy allocator that
> > can affect performance.
> > 
> > However, when the PCP caches are empty, high-order allocations may
> > show better performance characteristics especially for larger
> > allocation requests.
> 
> And when PCP is empty, high-order alloc show better performance. Could
> you please help elaborate a little more about them? Thanks.
> 
This is what i/we measured. See below example:

# default order-3
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3718592 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740495 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3737213 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740765 usec

# patch order-3
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3350391 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3374568 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3286374 usec
Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3261335 usec

why higher-order wins, i think it is less cyclesto get one big chunk from the
buddy instead of looping and pick one by one.

--
Uladzislau Rezki

