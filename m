Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53499C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 15:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAD96B0088; Sat, 26 Sep 2026 11:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593906B008A; Sat, 26 Sep 2026 11:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8C66B008C; Sat, 26 Sep 2026 11:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 222176B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:49:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83F6F808EE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:49:47 +0000 (UTC)
X-FDA: 85256348814.23.CDEC101
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0261140006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 15:49:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sz+wuXrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790437785;
	b=RrU5vN8eYZ18D3oGfAZ80jMteqtut3/EJwpSxoCEUTde0nAj1NJgTM1XXFYTwTFDPCIKpN
	Ss8Oq4T1JWVrvG23qEf5cGFDaKz2WWqGkxZu2rKZGzW4J0ssAIv32DhsBHXsi862ztAJTR
	lZdHFMPyiOOo+Ixuaq9/mCk2h6FLet8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sz+wuXrK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790437785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=led8hfaOrEtmmOiSO1x3wL7AB5T4FRzeMXFG3N+Q9Cs=;
	b=dG74ICeq91EmoB986n1BGWdCoJuiIr8V+WQ5I7lzanPqNlUxMM1mqo9WItddjM+cvoPdbI
	60BVloIBrPQL/Cc8CGzg71Lg0LIVsyrGbyubBRoYziTE2MepdOVYa7izeqaBRB9gv1cVXa
	7KRz+e5/IxtozbRO8ZyWOSUEktOeYhI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so14075245e9.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790437784; x=1791042584; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=led8hfaOrEtmmOiSO1x3wL7AB5T4FRzeMXFG3N+Q9Cs=;
        b=sz+wuXrKFJFkxUNTc/MHLSznCeLk1VeYFardi5o8lMKizMYC+we0cTdFmUSMbSR4ha
         ys/sUBk99Kq+CClBJc3emFUxgBIdB4bmGyG2Z53AxHzzUBlsnRXNDhcdkgnz23v4AAaG
         0Xp7hEgDabDlpQr7CmNiKCsJ9DpQ76jcO1cxNKDfoSapyrquomhzls4xgeVMQU28eYMW
         qPz8FHJStjX1RFxj8iKMSgyg4vmgUZCm+jE3ocqHBwueeksNSQWuUwfiMtt3f7UT6kg2
         hJXBrNspUQyr86W1otpC26PpwNZF5ZOuunrTCi8YoGV/I4rAuN3MRFCMLSXp2nwTYs5C
         Br9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790437784; x=1791042584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=led8hfaOrEtmmOiSO1x3wL7AB5T4FRzeMXFG3N+Q9Cs=;
        b=MQixgUEyfvBX4L33XrIPJwbV0Vnnt130TXBgQkvnlqn5nrg2XBCxZE3Bth9S69ZrH5
         4UVkBX/V9/GmYn46BNyHAxoTU134MtWv9JONNiQyw7w9vzHY8PsCdxPQlN7dNR8ncVmL
         0FpZ3vlTlCSjB9QW4UItN7aW1CkYI6FmmUyUPeZc2qGqe2RBum2KxkG8eDsukyFhLoLN
         lEFrCC9YNiMmIM2Qb8xTCEQv7LDIdJ4+Na322MffQNKn/0VxGS0ZAR2TLKHwiRdMR0Z3
         RyBLRQKYL4h3dJOI82XVuoA/AjWvesvj/X4MAVSs5QLUVc2O+szN6m+vZYleEHuWbnyw
         ekyA==
X-Forwarded-Encrypted: i=1; AKwUvBzxOAfwldLQtwxd5t/C4M9bFpYTr+hGLgN+vbPQm5VW5dhR60ggXrdNEBpZcGSUrUw3fgqTZdJ42A==@kvack.org
X-Gm-Message-State: AFuF++kmwZ+NdlQUVS33jTwgSjnZI3f+oki8Tn7Fee0L4uYcdEF8JFJZ
	/P5H0MCUEXj2UDTGxBKruRsJzDNfB1oHSwRCcur57q3tlA0ee3Bc+pr2
X-Gm-Gg: AYBFou1KSk4ANFRgjBWS6SadpAzcFQAP9sSJ/VczO3tzZ9ZrCVXoZg/lTZ24jdwf3hh
	cLux1AeYq9TdBUUrYYSBnDmp3V79B+qrvZLsLR7aQGfCtXOtu/Zs0V62fju/NXyp/s5QIGahHqG
	NW0YYYyQQbRzMYRWIjLrxGxnYdNogaAdeZdR3VAvzHWAHnXgWGVYmxWBCosy9n5afPiaodbUrHB
	zuH8TsgJXSg1beK261JEfo2xqdN+G/fHOPBIiuzZorzpxHp+HD/hhMmNfLQ+tWGN/YMNPvKsjNL
	qpWjHEwUHAJHzykkvMlIeK7J+nBypZMtMBTibV7jzh1K4MtnsATRth1695JPh/hgHkAGQIdfPol
	Riw7zBT43ZQ1zTHLPSeQxxw2fd8Udyy8fVanihEJkSZKLUQ2VD2uyat3mkcwu4yYRXXyrXO9AXx
	fhtp5LWRfbr28mLmCAqR49XTAt0rk2Kdf/DoGDzZ3tPR9BDAfQsUCygCyD3qnO7h6MovJIxjcnS
	64QKL0AT9voY+8bt0qjm5NGRJ1T6u9f6hN/zXnDJ89h
X-Received: by 2002:a05:600c:46c6:b0:49f:fe88:e7d1 with SMTP id 5b1f17b1804b1-49ffe88e87dmr20467445e9.15.1790437784212;
        Sat, 26 Sep 2026 08:49:44 -0700 (PDT)
Received: from gmail.com ([188.250.243.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff065873csm136947835e9.2.2026.09.26.08.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 08:49:43 -0700 (PDT)
Date: Sun, 27 Sep 2026 00:49:40 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Lian Wang <lianux.mm@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, taejoon.song@lge.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arfplImR24PFlk5H@gmail.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
 <arAHu_BD5oqpZJER@gmail.com>
 <arQJIjzE0BlUg0CV@cmpxchg.org>
 <20260925065521.36340-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925065521.36340-1-lianux.mm@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: f9kk9cm8gjh3na1qmarsrgr9jtwfx6wp
X-Rspam-User: 
X-Rspamd-Queue-Id: C0261140006
X-HE-Tag: 1790437785-614409
X-HE-Meta: U2FsdGVkX1+zvvAYLRiZGbYj8Ucnouj+Z+NnJbVOgboWtFl0G1sN71nrCyol6xfINyVhulhWQTNG26QrAm/PFt0h89UnrKiZNR7wxu1T1U+vJleYWWsbV/q4npNI2RTF15WLAsrF54yY4/UIhaVDFY8CJY//8KB8HyA4O1g+YVHzZnkdGOFFuWBTehFKQA+Cae9A/INZrszeZKOJpw4HIua7RNxX/Y4dm3/aPYAgg8MaLZ0MPTd6+sJyq0EWMmGoJ7IduuccRaQxwEANgg2OIBrtRwJHMh3VV7710719K/9MTkO/WYGVTvMBDBvQvFAKnL20pgSTjNXXktZwKPJG9Ul2mZSCIK8Fv9+n0mUbaVHl4j93Ho70VjFyVzNM3YVtvlLVHZ1pGf2PkU35t9oHZTrjq3Mjkp2lit9laVIy8RIG8DZoJlxEFkrFZhSp5MZXTjdws+UmBRh+0tEKXr7gs93MDgsd9K4eCNeIkwF4z0qT2ELjwxZb628XzMUy3NZ6ROGTuYfbcs6zfWrwrqftkM82RojGX3vEBv2lc1bEE6wiCCMdqrj32GpIDog361Oo+HRTnK0adtGq5ESy1UULP56vjfr6p6Y+6dsA89CpQmtn1QRAb3gNufkt54UiAhF912fJs/ZRku8QhOUzEVroWn/VwJNym6BXnA8Lavfqv2m4psAl4E+J3sVCmSV9aHsxea5pZP26yEJ7jIxOGW769bu8SluZC16k1ER87GM4WbtpFIBs8ZAAPhCpbPtYNaC4TfdWrlttRWduONube5Cc0FDe/Mv78o0cQoAh7Osbu68PtHhc3ANVMJjr87hbjUBSEDwE2bn7F1mF6Gb5tVgGMMQNk33W2e+IjC0Z/ObzMcEygOLn2aUaFb3oAJOctxSpHUvZESlG5PJxdCFrG/uknYRVDJic4nIC3XdwJcFq3gJj9p6dS+6ZU4tpd9UR3Rpqcrq+2LYVRMzQzGHPPT9
 gVaYEwCu
 67mBzAAxmE0UjOdm4YW76kj5eDAsGAPLlg96+wdK0VHDmN4+9JZsHhag419jiW9xpHsBscpzR0X9+1KUdr/z9q4EGCqYywq7FzUxT57YAsIpxIDWGXGJeNi0QiQbJqrPrKP0/A0BTUQ/kWKNrit+5G97adMezWl8vR9qDE6op9m4Dgxfh5Tvlgojq1GtICVvPsFYrHsiNugPS1rhq4Z3ZZyJkwy2HZ9Y3cfQUvcJB9paDr7cU0Ry/SJwa/7I/SZQRQebY5Zcudc/oWHjv4L8C1/UMlwlxXxgki7k3KozXPkXLe0MV/Bpa91jSsRH5d6ulKvj+tsR0aH7oR5eBX0JbTnBKlzv0EtpxuUGpaARFMk0gvLnR02RTPgmf0TkTjbX/bBh/e9jSCJ9CuPWfatwR8kKzJanAp1JPnapklk94lGjZWirl0a4ogmDklLJwty8kBefrmq3nI/TDMsuI8oLCn/03xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian!

> zram integration test, not yet a real multi-SSD performance test.
>
> One result seems relevant to this discussion: with a restricted parent
> and an unconfigured child, the child could still use the faster tier. I

I intentionally left out the parent/child hierarchy handling in this
version, since I thought it would be needed only at memcg integration
time. At this point, though, I think it is better to keep the
hierarchy even in the debugfs interface, 
so after reconsideration. I'll do that in v12!

> therefore agree that an inheritable memory.swap.prio.max looks like the
> cleaner first cgroup interface. A hole in the mask worked mechanically,
> but I do not yet have a convincing hierarchical use case for it; it felt
> more like per-cgroup swap-pool membership.

I plan to proceed with v12 as Johannes suggested. (I've replied
with my thoughts in the thread.)

> For the queue integration, one possible boundary is for the tier to own
> the queue/reader and for the swap queue to become the default per-tier
> device allocation policy. I would like to align this with both of you
> before changing v2. I will also continue the real multi-SSD tests.

I'd like to hear what Kairui and Chris think as well. If they agree,
this is the direction I prefer. Honestly, beyond preference, I think
it is the right one :) instead of allocating a separate swap queue
structure, the swap tier itself can be used for it!

> If either of you has suggestions or specific test cases you would like
> to see, please let me know. I have a few test setups available and should
> be able to try some of them. I am still getting up to speed on this part
> of MM, so please correct me if I missed some context or got any detail
> wrong.

When I send v12, I'll spell out more clearly the parts where we can
collaborate and what I'd like to propose to you. If anything comes up
before then, I'll reply on the v2 thread.

Thanks,
Youngjun

