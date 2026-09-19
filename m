Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F71AC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E19B6B0088; Sat, 19 Sep 2026 03:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BC46B008A; Sat, 19 Sep 2026 03:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134436B008C; Sat, 19 Sep 2026 03:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D848C6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:54:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B76AC16020E
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:54:36 +0000 (UTC)
X-FDA: 85229749752.28.B1AF7F6
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id F27AB80002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:54:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dq1mOPIE;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789804475;
	b=Ea9XXZ0GNg+PLRX1KH7rmaSHG33GExDvVx/Ow2DYNVrTMWqgHdwszEtAUev44DrJ8U6g/V
	WU2R7TkbbY7s6uqEaH5DmnccQXBu12lC/O0bvlezGnT1HthpfUdOmdmfsrCp8igY71WgRG
	0db1lKMn0MSfp6B/9zZRDnOrJrbgCYk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dq1mOPIE;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789804475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J06q8hxVr93lubHITldJTNiWnSDZLX+yOQxaNg68pLw=;
	b=sXx5rrLON4B4twj3Yc30XusiV6SMed9YRSAlpX9a82a5NMJycnFcpaacbxolf9EoPtyd8a
	bHKI0+3cJHYEIf/WeMOZDKgpSo1xvdZj2LlFkaQnrDlgUR6MbZz7z2opfISSFaABBr9uf8
	Im0WnROKnItMqbcLswYBEVHkGtV9zfM=
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc50d1b048eso1287543a12.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789804474; x=1790409274; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J06q8hxVr93lubHITldJTNiWnSDZLX+yOQxaNg68pLw=;
        b=Dq1mOPIExBB3NnunSrL1ILOZPzPZ/IrWKlfFKYNwRdGfGGjGUM3O/q4YVYxn4xviG0
         MxbsgmvMVae8L1SAW5Kd+5EzyhSbq5k+bTZhyIC89DPr4fT+qqEU6gJcjbBuWuhudqoi
         y1KW0a2CWEwHiSffc9G/9LeCTA0BdP34zRtu60XegeQs87Bc2j2GuZHpe87ajBh3tmgJ
         pkKfc4LECcrQG5oFFMwBDnOatPHKAMgBxNks34piqA/h4bFYRUQc7l1EI/7R6ZZMfvGH
         pdLHAUUdjqgJH4hfx/TThszIE863pO/wY/cawnLa5aT7j4B0QgALdAW89EgH280KjgIn
         a3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789804474; x=1790409274;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J06q8hxVr93lubHITldJTNiWnSDZLX+yOQxaNg68pLw=;
        b=mrpVkKGFXl4YZpaujPiIBh21G44unIVf73c3sDkvdvFvtsAjccYUT/oJFLHkH14VM4
         ubk7PAVyT9jFIlDsapWvifIfk1I5SdW0NGjJNaOU0PUOz7sRr+uevQ0QZQZuVFjRM2fP
         65U/5n/BDj4omvVu5BnteQ8+laJ7X2XddGe6Pxf4jgzIVikjKmkmZrsa1hUtmABt6UmD
         Bo/a0N37R9Afpg3I5E/kTpNo2omp8uxQyx7DCby5B/3ovGFLqP4nq/PYnSOh6Gf2NLrj
         3vbCG8laTXethr4PMn3KOlxvlXf0FAhmUzJJVPu2DxuMK4Hm3svp8Nq9hV8/R6GOX++K
         +0Zw==
X-Forwarded-Encrypted: i=1; AKwUvBy6cYjz8eXALx+lzIhd+51QjBFdL/htAfkqroA4w1fPftQcslpW1jAt2DswcyqerfMPpF1b2MSt1g==@kvack.org
X-Gm-Message-State: AFuF++lPyH9bBwjdK7MIQVXIn2AzDbNxVuoCz037yz5Rx9rZEjuflVuj
	vxpuIDQs6rbjy3JB9eWTJkqxa3YO9LRPWh0U+I6gbe3wk9eWIXUGvmM1
X-Gm-Gg: AYBFou2U6wV1QH19bSh7WRh6rmozOMU9Db/m9Qm7g7lLky5tYVntNw6KknljNWnBoNA
	gg4hNbXt18cvhnQeYA1zxK+D4Ofd5xT2T0f3ZNs8/qjxq67Kb1bMyeZ2fvbW61p0NES9/ACxWGS
	EXMmJBx1ehGyK0bIE2X/PIco86UjM1jinpychfTmUgiLr4vzRn6JhKnQQrQCeO++LKv37MzopDN
	8Fx2L+v5VOZMxHRCFQH2ibAdI57RGTxk2IqeXmZuUnXM9HLmjrCtKQve5YBEbyke4oXV0gD9MlZ
	wHChrKbkqdajV8FHRhWD5IGhuNFucy4a7aSBCHpzCu/ewT9xOGEkg4F2UfK5Z7sSiubSrReK0EU
	w22rNEwDeAaJj69L9IWtcg7kjyRlZVsTwPoP3dQT6ZAr3aSE3E5HhR+pPc0qS4D8Z8RsSNtR5An
	030drI7Brqiu853ic//z0OaGSkZEQdDpwFmW/cB1eUvK8PRCk7QingdUvY61f2VJZ7DBYrdeodw
	c+N1VP8vw+8sg==
X-Received: by 2002:a05:6a20:3d8b:b0:3d2:2011:d184 with SMTP id adf61e73a8af0-3dd8c442440mr9560107637.14.1789804473615;
        Sat, 19 Sep 2026 00:54:33 -0700 (PDT)
Received: from celestia ([2402:1980:c3f:8e4f:9945:ef6a:453a:80bc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae9e9bbsm663791a12.16.2026.09.19.00.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:54:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Implementation for paused kdamond
Date: Sat, 19 Sep 2026 15:53:54 +0800
Message-ID: <20260919075445.627288-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918024506.13715-1-sj@kernel.org>
References: <20260918024506.13715-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F27AB80002
X-Stat-Signature: pyp9wxje1r69uwzcm5qfgzc3az5h7h5k
X-HE-Tag: 1789804474-620279
X-HE-Meta: U2FsdGVkX19I+PkSZHkGUIrZSqyTloYaOtLUMNOyDf1q3ADfIQqQdp69okfXj7iSR9VHb+w5V1hB+vC5cjWcQLST3VyGRdDRnl//SVtQTujCRPEjFoQ74w3EKhu0KxyWDieRbDNPAWyuVR2+U0t1anfn+bNFSxlJhighk2oz95gdtUJdEt+n4Pk8ZrDs+2PimPqZ0cWwBSIJsu+ekdeoW29YRxUkcSY5EePxkmTvOdZImDwaweiNIIVDIjUAYYu8WgzYBmNsmu+62Jt2b0IOSGG+vL395buG0TY1RDLwytBQcYwTZWFPf8VtYlqEP/mnQPL8G/mS9/zppkUMhhMJfViB5MKLuB8PpgltI2x0eDmL0kMbv/VRGm+ehDDbNzFGpMCVZRDt82EdgUYAOLA13gap2SSlWkc7W37amaGtjUSndcepwEk5dZu+UbGnwnmA+K9y8u0VbdlmyZR3/WrUuUMBLDw02fZn+ssEhKpVN7p6MXlZTIw2H/+Lg1qdAFVH9GHeoEQJJnsmKC0G6aP0FfnOHQndr+edabrmTBLjxifqBAqb7NcnW3pNxAG1eUZO4uSyTqJW2uKfEN96hHDhxZ293RQI2yffh/HYTLcQIFWng3vRSfGBt9OX7IrqmZZQ/DxsDQIAdjqGArCfgz2GVrpsdBfsOm3BL9Dyr1nhzugw1yR4uLINxTJ8KSk5EvEQJ/fSYL3Z0pdsDt2guRB6p+i4lipwwSGmNSj0njI0LW8cX4XiawsEBKKby/co78tNMSj7GtcYQO2mjhDjstOIJ86rPBhX+6bT5u5oZ2M3TkZmXnNRbZuPc7cV7A2xQ6G5oyDZ/Bf/c9ncz2/YfLLl/1cJK8aST0xy7/4m5eEdRw1X3SICZgiOTpcnH9X7f0/b9VsBg0uZjOtxDYLNX+MVEfe7ksdfmh356qopEhRF+cyZ9pZ64EpxLHaQ/ALdKAr1oNm1MiE8r+nIMCiRp4V
 kG2uiZ9c
 UVMcLFt41maM68tXkclhTmfxKgRbyjSegTVyg3XboBoj+C4p+/pDJZh0l23ein0YNdXIMR9acLegGiLWTNl+M9Zxfu0GUW/M8+bV9BbidXRSLCq1FOKg9Gezhij+YuFn0Cci5KvpVdk0sdjQV2iU09YWBCuRzSXRFjrMm8SGrGtMCQN5s0rJqUtOUzhn1w820gA4MOYcM3FQDKYVevLvok6HvGE65DWycoi7aPvKHwDR/USZrPPtb8Fj97Lg5kjxw5+ZH9dvJiUsB9g0M8tdMDLqhklDIXxGXT6wQkwahpsmwGfm21R40eGD0dHUjirMghDxz3biGzXm+tbhA2Bj9fWuVU9gotfZPrTinVxXME42vgjZgTHo1/yXizAS1I0xzWcT9/qqT0h8txoBuefxHnKWQcHZ00O4rz1ZdSyOy4pU77N/s5FXWx6d03VMh2j1lRiar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 19:45:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 17 Sep 2026 23:31:53 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Mon, 14 Sep 2026 17:28:35 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Mon, 14 Sep 2026 23:35:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > Hi SJ,
> > > > 
> > > > I noticed that the current implementation for paused kdamond is
> > > > periodically applies online parameter updates by kdamond_usleep().
> > > > 
> > > > I'd like to know if we should change it to waitqueue to achieve a lower
> > > > power consumption?
> > > 
> > > I'd like to make a data driven decision :)
> > > 
> > > > 
> > > > Previous Discussion
> > > > ===================
> > > > 
> > > > I noticed that when you introduced ctx->pause [1], Sashiko asked the
> > > > same question, and your response at the time was:
> > > > 
> > > >     "sample internval is 5ms by default and recommended auto-tuning
> > > >     setup makes it hundreds of milliseconds.  So I don't think such
> > > >     change is required."
> > > > 
> > > > I'm curious that, did you think it wasn't neccessary to change it to
> > > > waitqueue when it was introduced, or it wasn't neccessary to do so even
> > > > after it had been introduced?
> > > 
> > > I guess I thought so when the quiestion is raised.
> > > 
> > > > 
> > > > Asussmption
> > > > ===========
> > > > 
> > > > This is just my assumption, not a real use case I knew:  When 'pause' is
> > > > set on an Android device, user might want DAMON to stop running
> > > > completely when the screen is off, thereby reducing the load on the CPU
> > > > without losing important information such as regions and age.
> > > > 
> > > > The current polling may make it harder for the phone to enter idle mode,
> > > > resulting in some unnecessary power consumption.
> > > > 
> > > > However, pause feature is only present in the stable version v7.2 or
> > > > higher, and since the latest Android kernel is 6.18, this highly
> > > > unlikely will affect any Android users.
> > > 
> > > If whoever comes with a data that require changes, we can discuss.
> > 
> > Thank you for your clarify.
> > 
> > I recently backported the pause feature to my phone.  However, due to
> > Android's screen-off mechanisms, I wasn't able to obtain any valid data
> > during testing.
> > 
> > Since we haven't identified any practical issues with the existing pause
> > feature, switching to waitqueue isn't neccessary at this time.
> 
> Thank you for checking this.  I agree.
> 
> > 
> > Regarding the documentation, should we explicitly explain the
> > relationship between 'pause' and sample_interval in the documentation?
> > That way, users can adjust the sample_interval value when using pause
> > feature based on their specific use case.
> 
> I think that is too much detail for normal users, unless we find a problem from
> the lack of the documentation.

All right, since no normal users seems confused by how the pause feature
works right now, add documentation isn't necessary at this time.  Thank
you for your guidance.

Best regards,
Rui Yan

