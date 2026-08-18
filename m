Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BF3C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABC06B0196; Mon, 17 Aug 2026 23:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C296B0705; Mon, 17 Aug 2026 23:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AD36B08D4; Mon, 17 Aug 2026 23:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE65D6B0196
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:43:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 306E41C1BC7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:43:03 +0000 (UTC)
X-FDA: 85112994246.08.29D49E3
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 646BD40005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:43:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V1HRyp11;
	spf=pass (imf04.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787024581;
	b=xcw129UqDOHcq0fWwOVfSK2aCxFREMnYku+Fb5Hwc5hG9vB8dS7QD1CF/AtTRusk58+j3l
	epp0HsKyMbMR9TMGTM3XSB8cH48oKPHJha1HiG9cSevA3/MiExfsJCXrX30LNxI4ylkBfl
	S24t14wFhDfktWnsjIbSsNgH1NOPYkg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V1HRyp11;
	spf=pass (imf04.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=4ncienth@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787024581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRDoeNY2WfplCeM6Yc0GSWDWLkBmqI8DxH4apG0CyCA=;
	b=iX5IazhcZhCRmG7RCI1w9aAqs1d3adyf4DR12Plq4ZGMTHcg2slnvc1U+BgRoybFLDIJdC
	nIsk9E3CoxFrIT8JwfL3gctKmWH48/3QCGPywdcGKXAd4rrz5UrIVO6GVYMpjEsvtNyCK4
	A0W8ou1prm2qhfVZX8z/A7z8xbdYo1Y=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso4966426a91.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787024580; x=1787629380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dRDoeNY2WfplCeM6Yc0GSWDWLkBmqI8DxH4apG0CyCA=;
        b=V1HRyp11zXsoIGSPjCGwoAVuRclqlf1dnv+Q6nSzqA6TTOGmvCiMAXGoZJ05CigTQ1
         oBNXfAHxAJpdOcCrNg6aoh1EdrMwQ2pjqJUF0AIh+9tJoCaIu/rDbPxd6SyVjqYikIFm
         OVtIGXoUC+qp/BHolb4Igm3OsWHdGJjcC6dE7Ewk/eDAZT6NDu5ii3zRG3wRMKhspb6B
         I/qwc9qTUlEwEJ5IH2wpPxpXqlrElHmHlQMQSom9G+9ejpFhmwxS0U2fM//NwjJSHMRr
         wCaS3Mqprmqosfgnkd6Sxv1W9l+rhMhQxolodm3vPKwsuIVcc4JKPnUrattbzw/m83qm
         4Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024580; x=1787629380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dRDoeNY2WfplCeM6Yc0GSWDWLkBmqI8DxH4apG0CyCA=;
        b=P+G1JW14B5DdVFky1yLw/4b5+KAzUGB/MdOJUPS/QwomG33DNPAp0SsUgyLVtx/2KZ
         qm5Vk9pkIRuUVk2fAHc6uZaK1TaA/3v3vD6tYnCkjT5OsDP1L9ae5s5xz5upfb6vaRow
         YEJUeXATRWaBoE5k1ox2R064vFvNWg1/LMjpi5PJPXdcAvSIYhWR0PdlscnM4k4s7Tzq
         wfzzpfFMC6kxFhmtM55ZN/3OUyUxomD7WJTbtx54gezIkkwol+4W9WWD1K9nOHKnkKe0
         FEs+jnfud3MeJXbyUv932asjZjyILrbzmSVdyhyGrEQlQ8QXYnnGE8rwOQcCTiqtHbqO
         7W2w==
X-Forwarded-Encrypted: i=1; AHgh+Ros3Ivl/BcPZbHHbLI7aCqm7KTX0EkCv41FcOJvAMDlfAQwxi3L+S0QVPySu8q6QM3g8raFwLUGQw==@kvack.org
X-Gm-Message-State: AOJu0YxzlsJXuivFCCUX18PlulRpbCZKKjNg+1gmkKsTDmkVsXNQvU0D
	Fy8nx+K17sknXuCRaQKlv0/E2UoJhjRbIIF2oybqSHPHWnX0eBeeoQPO
X-Gm-Gg: AR+sD10vKZmkLrihQ0nBfiTzS1wqxX+J+m7y1BatVG1A8rB/gnWMEi4wy4M1ozXtjuK
	3EkLgLeSEPd730MZCnOxIfdQT6gtfG9plUG6Tb9pNCbWIgCiTfVJhv1lN5wYDpVGX+RCv0pj99A
	Y5xrpXoTSmp/CzoZf1PUe2/BEX0KzsnTE0nzI1wukNN5tHdijwlvZGNHbO3JQ1IzqtWTS9NdMrO
	D/csw8DHL3qJUvAFvn7mx+0jXBZIG5gXARamE95Nccf1AVVJHpRQ4Hc2uamETiptWmPTP4DR+RL
	PeV3teNAs0HCUdWuc4jCugxsnd+pIaLei063F4Ufuyy9cx3r0UEkh8oA2Wh66+2z1WKPQGytyc6
	27WoXm5Vg644T+NHjmqBOIgvBiTdCisKEGxHusczyAfO/3VCB48wLcidq2aJjZUP+8CAk3nKGRP
	nAVesIdfO1Rq+dnSV6Y7ymvidWxEoyG2ZBgt9ZrPmkpMUlg/njuSp8cuDEU92r6L/U0LVQFZcg
X-Received: by 2002:a17:90a:e18d:b0:380:7688:fbe9 with SMTP id 98e67ed59e1d1-3933b764d23mr33386383a91.8.1787024579941;
        Mon, 17 Aug 2026 20:42:59 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d3b3b91sm4418656a91.13.2026.08.17.20.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:42:59 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: prevent uncharged mremap expansion after fork
Date: Tue, 18 Aug 2026 12:42:12 +0900
Message-ID: <20260818034212.1761451-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260817154356.552ccde5d279f6e0a9ef0ff2@linux-foundation.org>
References: <20260813225328.2010303-1-4ncienth@gmail.com> <20260817154356.552ccde5d279f6e0a9ef0ff2@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 646BD40005
X-Rspam-User: 
X-Stat-Signature: rsswfdi8doxxf5ntqgn7tgg3xapwmxcz
X-Rspamd-Server: rspam06
X-HE-Tag: 1787024581-812739
X-HE-Meta: U2FsdGVkX1/85GQ6YXOuMAigYsF8+OjcBZ/uASqSOBSlE2HkgtTaSemGAD+xMqg21O90xi79Moc51Wo2TN9BL6yciGgN/RE8sg4ri7UcZgLKmjlNdk8sBi/hlqzfIhAjYlXd4UsBGXzs6rRSIyXHF6rTabC1m/Pm3ymSUUe0VWjBMDASoeIyERaWJGIt6AKdga4DzWk3IZsFqHWZWyyMBcqvCf+0JwuVRtMJyB/Jh98OorXHpD9GPVQebryzSK4UaKshWKabaIUdNixIKJE6etR7ED1lqGlVCNh5KnMRmW1o1y3gwwxG+FJ9rxyM/EIVqzkGq1kFEwmgktosGEMuDT69ATu6+YvCbP2TloDVWXqLdNIQZt/C1Lu+DH4hGCrJMYivMWM9Cjhag51TbpDmMascCoFYKNEBWOi/Md7Xb//MxXhqweBIitIDIKjFIRHamKwcqZV5oeu5DGCcogaQalYr6TihBevFrDix0JSPTGSSkfjn0rl/a/MbMPBC5D6B3zKoS8eMYKcthI992D2GZqTb9yJtxnSLrqKy8knoaXexwF7CkZqYoqmo4yQgnBtAdXRiB6TNAPmfKrA9iHbuVZ6bTcXGwdWNmMr/zHBesTw9A1e7o0gWTXlWgVaSr39zKaF+r+EUuECedYKTBvFH4lFaNYQri7MPzb98RCuL4osikhGDsVdhL5WrMh0LoCii+HC/dqze5LUnfwMtU/UOAVU9ZPf5PHUyxod8Jt13CLcKnNzJCwaeL94t190KaH5L9ZJx9vzL2y3+SViErt89jwh+krvMd5Kn4qUWKOBmu+UkeUWHQ/+D0SGtKhVEuFv0jRKAdW02A6YrXP/QoisP5BNVFWODiFcU6+b9gFS7pzFqrKJTVIujqu/MREMpZ0aEjBE7NGA6x+KElNo3Y7VRuw4WbukTmZ1bYsrhVTp+uAZlrglOcFf87BxCeBEpvJJNPF3+r/H36dEM95fwZrJ
 dOnnEa0y
 VjXy7eUQMarVV+gOTctALfxDijsISrXhjojcQpOAr5ViqhBo6Wx3K0Gl4LG0mbJQeHpiqJPmJZBCYoyZ7ixMzHhZKBCcSjpGOa/6fFAOaPIWatr+IhZQM3tquoP0+HV0G6qkS32Gy4ydpDD7phzlHaVCxeMSVkLpYbRHCRRDKD1tR7CniZdPB4QIvLbRMAxWKmUgeYwVvui3c4XZiXrLfD/voMggXH1+vK78CreH7FpCSLfw4Xmc7lw2Ek3wrMG9scoX8E93qM/lzQ8kzo2I496ZgI5Mk4LBHR9Z8T26vCH5LQm9zO6yUpweh2aVF4UZY20iJN5LLOnfkPrwNnzgxFn6nADZtryiKWBOn0xxFtEm9VM/T1Dd4xx5D1rv6sDRLYS5e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review.

Yes, this patch was developed with AI assistance. I should have included the
required Assisted-by trailer, and I apologize for the omission.

The related issue is pertinent. Lorenzo's follow-up shows that the underlying
problem is broader than the fork/mremap path: secretmem accounting follows the
VMA lifetime, while the folios remain unevictable until inode eviction. My
VM_DONTEXPAND approach only blocks one path and is not an appropriate fix.

Please drop this patch. I will test Lorenzo's follow-up patch and report the
results on that thread.

Thanks,
Daehyeon

