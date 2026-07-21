Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24BCC44515
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 01:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B430C6B0093; Mon, 20 Jul 2026 21:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A556B0095; Mon, 20 Jul 2026 21:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A097A6B0096; Mon, 20 Jul 2026 21:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED8D6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:34:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D423F1A037D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:34:42 +0000 (UTC)
X-FDA: 85011064404.22.40C9E83
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1DAB4C0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:34:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfHG1xRe;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784597681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/tCUmc6Af/w9eCR04YBcQ5lmA7aoPQojmTNJw54oAM=;
	b=UWPFh+DLqUet1AE6oLgKSkGiMK+AVU294AicmfvKHMFYjZnGcHpxw/3r5YqQaCrKTb4wxE
	UT2CB2byLuB6OaBlek0wy0cNSFS3ghd5KFF6hr9WkBAHgHr2Mn3rQTjXl0aprlEmZ15Lja
	R3GG+x8FHkkIjM/dDVQKV94Mphk5FAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784597681;
	b=PQHirneq8+aMFzx2x/4aVVCRzj61HNQF/JL6AKZFN+DHq1+ATTO/X4WWiL/FW2xqyfvAcb
	RV1RPVtoLduduooAgHmg1ZhKXsI/mUZVMMfx/Tb9bqpKwrtBFWrpHNzBHvPx8q7ZopiJ5t
	zUapbIrR7lK6wj2lq4uV+y50lJZ0f50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfHG1xRe;
	spf=pass (imf10.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2caf228a910so84795665ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784597680; x=1785202480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/tCUmc6Af/w9eCR04YBcQ5lmA7aoPQojmTNJw54oAM=;
        b=JfHG1xReMKtLjrNfrZdr0mFR7KPpAMLXVKpAdnLKpJDLPsmXiTji5aI91iBazFFYJ4
         KZDOdTx5k/hKGAKSzdUUiQRuoH13Rt1cFifVWJmaYdJIlfT4oLT2fAgh1fUVD8TxWP0f
         rY2oghOKlNcoh1RhJvIOQkr9FLVjjV6HOQEJrwbS/oei85BQslrcjS5rQyRB/AgCJMc5
         ZX4f06xCeU0uiRUs0YVi7yjTj7RFalY5AtvM9sVQlG2LLufywi/CQl6U9vw0+ualP2tX
         c1kpbXQvoWPLrNI5epoVPwDNvHJUGDoL1M5mPt/93am/ggTc6S3GUlFHMkf8RL8fsos8
         UbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784597680; x=1785202480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/tCUmc6Af/w9eCR04YBcQ5lmA7aoPQojmTNJw54oAM=;
        b=qrzlGfXJJyBNtRB17D+MsKkvT3du1KqIwOEi5AweVxyN183AbQU7Pa8cjDqH6JTDm3
         bwmDpj9UagmRRNDh08piN+WyzGuz01QfkUytEE/hHg3bIBNIJTluTWYebcju8yuNqHtV
         c7lTaUVoAPUUSVqKUUrAfqJi26SFn375CZAYNDa0WpB9++Nt7gYAAzYfrCXQs01NSHPQ
         noT2ojOcLUEZTUv9nYXgPtEg7hflUZydevMyIVjGbA9nsv7pIzAp7ws0JgWP3u3Jb335
         EacOzvGUdvhFkanIkIUc4Fq2jUllZPWjezD+7SyPePeTxaeuWg6aOMbfMz0kKQ2XZpY6
         lfnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqf6nVEqVE4Utvn00iykU1LyvYlZFGTXLr6dO2NV2MEu7hLdRW9nZk9qeVbz1H1vNuSF6doYGaGGA==@kvack.org
X-Gm-Message-State: AOJu0Yz26x3DgFBaTsa9SwUiGWWRvZ+jnbTlTGni2m8wHTN4I0vuNxfY
	TDz3A7iOtQy1ZfBHE3xhjTMBx7patq5lMpeo7fvjazQx1qpo+oGkxjTp
X-Gm-Gg: AR+sD10p94lXGdmWYgiDi/reHiCRlC+pAoPIiV2CJfcDmivg5lswoqIbRUi/nCEjftu
	AmRSM2fguIeQC+ObHQ77bO/LanvFm3c2v2k2oPisUSAQrOnbjv8o/TVp0zEVkV2niFXRCidKNWk
	T/7m3820RReKRpLztB6ETSkJTnQrvUjTT5Qzj1CWaA4GptptUwi5gDcP/Yrp5YsbCLhbkFA1YM6
	7QK7RaskSLVO5Oy0l4apFotTwvOW57EnmqDkof64faghX/BJivhVddQPxahPFjk+2V8T9dw1jvr
	YJdZ4WYVAHPxGVQq3n4N/2VXaruedr1EAfFKd56fItPh+b+B4/B3+GKi+e6XfEXtn/ibiSze/Bq
	fEEYYr635+HEf4bbJUHjVW4ZTZ3zwgavGYkR0I4fQk89ApuTM98XJ74n+lhKSE1GK/UXp1PDkv1
	8GJP3gCjfsMmdECp6/EDd9AkAlYLw=
X-Received: by 2002:a17:902:da85:b0:2ce:93a3:c16c with SMTP id d9443c01a7336-2cf348665f8mr180911895ad.12.1784597679975;
        Mon, 20 Jul 2026 18:34:39 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448f91bsm65631895ad.8.2026.07.20.18.34.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Jul 2026 18:34:39 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: sj@kernel.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Tue, 21 Jul 2026 09:34:30 +0800
Message-ID: <20260721013430.40303-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721004755.93824-1-sj@kernel.org>
References: <20260721004755.93824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DAB4C0009
X-Stat-Signature: x1ojxf67msrze6huayn1a4wf3w1fscke
X-Rspam-User: 
X-HE-Tag: 1784597680-819518
X-HE-Meta: U2FsdGVkX191wRURQTKkRe7M1g3n12wyFKNqbnLFL98/nGPfu0IJ0pquJtmxaSxEWV3JnhC0WQ7RZyp/o0DJiNluk+sTGotRr+9YCRGp9jzjGW+I7x/u1+DhwYuE6trev3mI9TNou4er0GZGd2sqnZEsmHOhw7IemR/hdvA81nfxgCrVdcPojMrd0fI32EdHJgxalo4TaBFJMwd5RvEqFmfEi2uhH1YBFEnzfPEiye5NJQnxyRUNa2VeuD6ypdWsxcjFwpLZpXycSXljNizYbLQAeWCB1edwGSOo1s8LHC+cDlP1BztONjk/twWHUFV0gvdsUBFbeI2ecBhJm0DJnIHC2bQ7RvcwvyK08poTKwFyM7crKc7Hu0YK8Z7lpfbzTGABo691/hcnx1ZtUjBoV2R0vhSdCsbmjlQocqptQfYFHHYn61SKsVOuFuyhyudeGpTdQO/bPBi7JCe3czI4AsIa/zNe74HwB75zGPxS3FC7L+s7PtnDrwl05wmOpK2L7v2KoH6pGwFIUlCIRWndTsmwW2cQzc8vgdZA6Fjcf4ZpslbeRmgefJxCBchO9cgA2xTVgnFEK0pEkPBZElmxXv9vhFsWmO2GH9q8rAiWJqRhneqZN/IOjLdmpi0bdCwA3TAYNV86o3vjkp7u1z5S9uRohMqhBZNBzTKxowFeOXRGiTHr5TZVoq2x2MG8VgJOFNoK0St+v0GWM6vf6SVC4BBo10tvPCnF93XDC560puTu5GKUJYjvyTFbf2goJpKsmAOcGdXkTtO5YQGim2cKFXTFNEaQwv93yyvNFRVjVTaU0Dnurc9MlGg/7rLJMAhkUKbKWCl4LGTG1wPiLHjAepVP8lDcRZL0/mDgdNDzvqX3TmXzkZrtDKl0zUzD1YuScWCDDOcv+WGLJm0xTDegJffSoEw9DmnGxxfOisvYpBR0nruKPmrARgiQU8C3uZsOvmC36CgZgIHD/Y8c7Ap
 lF9pCTc4
 1Dtv3pYo4moxiezVCtYOXZwLbc/s05SEUiqwojnVxiO5VSntKGD3JEUtHOtBxSThtIgcBM6S+98x/5/kX8OPfU2yDIC0q/pkS9sVj1GEUZNDyxGXacXSDXnF1dR0JTfMF8ZkIqas4phygZ+MOJHqbqa/avY3jEDJBAmmvtj1aAlm23xLg7l/6Oct/UdF7a6LkJQAl4yzMhxnpV48Vkf4UQufeJiN4fvnKlGgXDIQnqpof5BkuwLOXQ4duNxft6ZHzhVbNILULx42BeO8gOCQobbC8KFF7pCXWcsyoQC0+V6jQaqBYBMJLsGXMP4d8FT8+R8i2I/u4pn9wrqpHBrvH4uvQQB9vcP724e9CGC3AVS+bQEIVnMZXMChw3S3AOw9e6/cuI+NuxfHZRQByz2WzdZAcfaoptaDK3+pjDRDLNB5fEYW8wjhrRrTcq9xyMQcDWJkNbRSVFL37nwdfDsu/tQ24WgxMYvzeRALwBcNIfvVezU87MqEptDlvsdgMv5p7yfFw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 7/20/2026 5:47 PM, SJ Park wrote:
> To me, it's still unclear what is the real user impact, though.
> ...
> Only after understanding what is the problem and how bad it is, we
> will be able to think of different approaches and assess those.

You are right.  I will work with Sangfor to quantify the real impact
in their production scenario -- what DAMOS action is driven by the
inflated hot-memory readings, and how badly the monitoring error
affects the actual outcome.

Thank you, David, and Zi Yan for the honest and constructive feedback.
It made me realize I should have led with the problem, not the
mechanism.

Let me take a step back, gather concrete data on the problem severity,
and come back with a clearer picture.  I will follow up in this thread
once I have something solid to share.

Thanks,
Lian Wang

