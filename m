Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00EFC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B426B6B0092; Sun, 30 Aug 2026 03:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3956B0095; Sun, 30 Aug 2026 03:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08B96B0096; Sun, 30 Aug 2026 03:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8447E6B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:04:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 145831A0236
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:04:18 +0000 (UTC)
X-FDA: 85157046996.25.78C7E0C
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E9F6180007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:04:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ncxVuLtX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788073456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fCeRGLBJKDhd1zxoKor8/347vytyDNRSfu4cMLTY8c=;
	b=L+AjoFfRoMdxIGtfL/ad+GCXR4U19efiJEjtADtgiBUMxVwQlgSlSj8hGtmh7rAkbXUy6Y
	8NlauGCXzGyZAS8CfGVs5oqXnIR+6GYhUdjx5MQu92LmrepCabNkeXccWcScw0xasHhD/4
	yeFtWZ3R3jSx/JuYusBZwqb+vhmHEIU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ncxVuLtX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788073456;
	b=IwdHHBgVWaq4J2+SJPycgz2xF6D62cvhS6OjLWTfBrsTrOgZmfq8npbVNJmUw8ExtljRC6
	utOZ9Rcpz28cq20ghhXC1BRj8s95TQTxYF25OMT/w5N8qtiLlXPGUdsxolhF2zVAsO219o
	qaEH6zRSyci9RJd7OEE/qRI3zak/1aU=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d58efc7356so27986455ad.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788073455; x=1788678255; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/fCeRGLBJKDhd1zxoKor8/347vytyDNRSfu4cMLTY8c=;
        b=ncxVuLtXBlBnNCgHtaQR1oueiXk51cD36zJ/7obU4RcvudU2QwS/v/FuKFh0rZ3nck
         dpMyn3XQG7S5bLjXlNYXbjNJnjdA7BdobzZx23/ccL0uCS4aG4vCkjsxxv1p6dhFMBJ3
         jqNVxx/D0U0k56iy/hWh4Ea7QdR6InNIxezO/3byOHe18ty0JwihaC0CANKDbqM/LiHn
         A9btJZ6GlBQVGfO5KAk/pjiGHb+DYrd29B0emnQWq1omE/QvKj7yW7B7iO0cmAKzFwIp
         WRB83wLFgwArrrO63mqGRhPgIa4srCjw5s9l9ydFCwp3nFwFIGRyaXCxxufKACPERTRj
         OFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788073455; x=1788678255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/fCeRGLBJKDhd1zxoKor8/347vytyDNRSfu4cMLTY8c=;
        b=gq1dNWtm5/1GY5DZG/R5wZGER1elhcR0ZxWSpZ/HOPTEc7UZHeO4Lhv0Xo2bOGiMBQ
         iKz4ZlahRwccNk9Gyf/CjGai4SW1a9suskANyiRen5duS8KVC3FCXtSAc8oH2oLQf5/+
         GhFcrSVsYFbu6EcB4YfoxBxOtH+Yea2kViugee/1lsZBu9clIu8/AidvwBKdZFyEjrjR
         X4Ogv40sd+0dW2jf/exZZ0Mv/0PuQIa1oN47GRCsLRmFmu8ZKYSrx5adg0gkthkfCJLU
         FEr36xSWt3JxSs1U8GdyhGPNT7ErSNvgt8UxNlNDuBNOumfvhB6+Ab+C0QFXdQSQf2J5
         G1Hg==
X-Forwarded-Encrypted: i=1; AKwUvBylcHwPsey0idOACY9gqNlA8BmC/VyoGMJiao/Tl+WARZulFKnpT6DDuPBbdzyiN0Dq2IotEPGK5Q==@kvack.org
X-Gm-Message-State: AFuF++mLjmP07uF945sjey1qNsHvc7DEaJqq7jumJrk7utVzl8tGKDcW
	/bm1sKzWLITQphhNwgOstOh+1NQMuk+meyjWzdNb38l/8H4mc6b1QIqg
X-Gm-Gg: AYBFou1iFrrD8ksn3wLstEbOJbzo9RAi2uhX47DlYqy49TMPZF9ghTc/fZoeT6i6PU5
	yA1UqzacHD07DiROMMrFT5abSyXfXUaMrWrHGHiPhs39RDlP8JUup54/lVhXotwN6dchqvpx10w
	NqI76SgH/KJvOVKAfprNne6gYyTpKntA5spCslwUdCbe5xMGMR+sSdUmMhpId2v7aZZMBmRYV4G
	Z7p3tI/JJ3Cd/FEGdLpMHkfis6ecyohGcJ+JDkPgURavzW/z72HWlpSQXS9JrOVLiie5uSiJR++
	zVSqj8Y4FrGZ+6JvcBmSXSb+VJZEW8XoaIxdYrbVbLFNgN37ZrChwqBbOpUvTR6aaSkOqpnZVfZ
	xbq4BZgt7eh21DUsC5UXzxMRRnsROG+hOPEXgiQobke7SABotXg3H5GG8/3llHhnWl/Hx7HoFSn
	oKa4O1/onWFke/HYOMn6eNsb7zg+36D8Bm/KnFIN8K9HGffmqh60s+1B7iiMncVplJK19oXckY4
	aSwBTDQ3f1ImIqqj0OvIrIoCCmI
X-Received: by 2002:a17:903:906:b0:2d8:d4d0:7932 with SMTP id d9443c01a7336-2d8d4d0796cmr169846685ad.22.1788073455150;
        Sun, 30 Aug 2026 00:04:15 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598b8607sm20821615ad.72.2026.08.30.00.04.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:04:14 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 4/7] mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Sun, 30 Aug 2026 15:03:40 +0800
Message-ID: <20260830070353.78030-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-5-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-5-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9a8yomdryq9ic5kkjdmgd1eu1b4ia1mj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E9F6180007
X-Rspam-User: 
X-HE-Tag: 1788073456-409190
X-HE-Meta: U2FsdGVkX18RJmF/cY0zrnywnHpnmd39Rd/V1OfALwdQroSTVili0uflx3nZ9Mn3W8OB1oAGbYPI01Lq9Ojujc5irritIz9XXE1z2ZYCwjoyiobIsncTgbUCpDhFuj9vJfQsgxe38MX1mDM8xKShikzLgbITgWSWWsd5D5LRe3nsinzeq7C7lwOIFlPwXpvm+IVe9PdaprdKdCtAicv3ji/tvJlDSoTBRRHFAwqHmelKPdjgChD0eRFsUyxRPMPmScH2DkrRHNyGH5eeHoxnudzR+3aDKTTAtoTk/5F7VRy4ktTFw5t7k0+gFkzQ+8AWRd53nBxscXxabcQiNQ4zY1r2Vupvo+QYKzSwBjBrfdveqULLUt3mJkggpTAvxd1ZNR/N7gCBMB9/Nk6keBB+re9roAnads/HSWXfIecoCPG5ROFZb0AYWw0i1L3+I4R639Oxdz5/EdCbaGG9R9D5vtNENeQUIFokf156RmxEG/Hnj1alMMR3Ll+cHwc2a4qrxp4NxFvUzhaLDfd4oqjLw4GqVSGTW4nAnT0DVNF/uPUFa+tcAFYfNpJDR7MQwnIyjSTeqGCa+hLx+sA6zX+wawm5QzZ0GCew+3zULyNH2c7PXhclnuVZjZaRW2/cKbluUr3qW4Z4GEYq0pXQwxJjKW8CUV8WWtHfrVSQghlsIXfRMOlyq3S+bXW0xorQuik0zgDAQgIZI0X1PcKH5nCzW4nUmtnQEO+8gRzYG2qwiipuwhPmmZvtCpIFP+0Znenm8I6F4hyoRpHF2rnhC3vbnv8aAojioGsH5W/CtlPx+AS58EyQurY+3QBJ7K+02VtiHHKhgq71IfsWmg2zpm7e7zCAAozRED7DSKS2Ra9aDTgWMZCZdvopo0daPKXOYlIEBNG5oxKamnyud2jUviBXUyhucGgyGHa0yxhYK5x8Rb7DEZLytt8wgLkfFEkG0AhHFr/iVXCK8YX1jZ511Mu
 xj2p+jpl
 0uEAFLOYZ07Glsz56LwRUM/GtcORYWQEC4D7PVbKGz0nv2Ma5NolvNUcefty/bJdxYADxBoAnQLhwSLr9gDW+lgNFLjkfhkwG54A7DB78wftuOPmi8NqNk/FQ0xxCrjH38SA5TlDTOc2cUAb7wvgDNKZL7fObtvWZqaUwTEL+VChafLhwVwEeExYummy0XCdkPE1Ktw/TGsHiVMABKzjh/4hgcNmr65r5VNhDHwkWBoevclitnte1eNZ8OHVi/jW7Zm3GixTJGSJMeLHhvmkZ7nwZ9dny2FkFRPvJh8QLcmWzX1iQxxvgf7WVRuBEzFCA8ViN4L+wuuBDN12vEb/19ZgQwMGiWrVGfUiuaKJTjcRZkNNFCQkDiVtgCgR6F4Y5LpcA0oHuU/fuzD/T4yCQhtU9HNqqUaqtBU3H/FTROvMiMZ7CC3/RI44RmLM09G/VlGakpliho0sodp16uAwMcWYaGZu2Lk26QIMfIjTL0zlaqIixPi+nSwR9fDH3E6jKz/q0L0lim2mRNSuOoPbWHGo8n2jxlgoUb/zXWcLALE/U4MWAuy4q9NEqPug1QxJiDoth0omVeA1nxiZFt9pyLVvd9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Some folios may have been promoted during aging, so don't count them
> as protected, similar to sort_folio().

This makes sense to me and matches sort_folio().

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

