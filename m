Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF01CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154296B0158; Fri,  8 May 2026 08:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C416B0159; Fri,  8 May 2026 08:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0427D6B015A; Fri,  8 May 2026 08:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5EBD6B0158
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:19:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83C291C17D4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:19:28 +0000 (UTC)
X-FDA: 84744158016.30.DB1FFA3
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D668140002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:19:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UDUuzOeq;
	spf=pass (imf23.hostedemail.com: domain of sozdayvek@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=sozdayvek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778242766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPuuBoZsJsMQg4Ux+i6kMwWg7G2z365jWoV41M3Piz4=;
	b=W8GnW7QalvorgHkV5pu1sMmUPztlvKDgGlj3Sgg9KkvxoGCcwB0NHM8WoMaRVkzrmi7FZT
	RRm86qB/q+z6g4YlZFFpfaKZZvVZgee4zMOiDm8x/UCQlskUrP6OEZ4FhkCTFDPdt3+MaF
	hYo10I16EYt42KU+gph+w8fSOvnw0ks=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UDUuzOeq;
	spf=pass (imf23.hostedemail.com: domain of sozdayvek@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=sozdayvek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778242766; a=rsa-sha256;
	cv=none;
	b=cOrwWaXPHU5t+AdvE8fvO1CKCK5r2dil7wrJfI0BUGo7mMBPGAFz4z3XYVKqLoB4Xrd27k
	Jkb8ZsS3niZmXY8zkJjUFBImW7Y4wvNk94y+EW2QC0cbDjqpyvRD1efHeKhYXv10Q/zcq2
	mbpQjbcieOoiFzhEdfy2StwpdaY+DBE=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38ee0fe3bdeso2823061fa.2
        for <linux-mm@kvack.org>; Fri, 08 May 2026 05:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778242764; x=1778847564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPuuBoZsJsMQg4Ux+i6kMwWg7G2z365jWoV41M3Piz4=;
        b=UDUuzOeqoLKdtEFHzyBGdUCfVWSLB+HcYRxRWUIniA/se257BbJD2ec7ZUhfEvJVJk
         qF/eVkM0uXfx8wvJ3jLF6yqvy8BguOaM9TmqEG9w47ky2j1XQ4VgMKaur9Gs6HpaATx1
         lyw0elbHRVXj5UIGelQaz6HJVbzMND0op827iBPqUw0Usd5MVQVj49sJW9PVj8Z8OzqM
         RWk5cEkvTuuylwZ0nssYnCKxID8OFOjTeBFFq/0uj46cYI2EJO+Jz0Sj+febAr6DXPK7
         IJM2Jke4rn47Pd43+/i7IZBKD/K9z8Y+roHeuK6S7adg0Gbf0GX0G6swVbhpyqO0xPxb
         G6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778242764; x=1778847564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sPuuBoZsJsMQg4Ux+i6kMwWg7G2z365jWoV41M3Piz4=;
        b=tJVje+ug2dTSFVyNjQPm3c30wbmdESG39HIEjZoSaSSUqhTDKFT4/whqlbklD0FwU2
         svUrTWmYTklK2uRNW1cFrnpPnjKY/mpjCMUPNu4Pli+sDNBdQO9dHhr2fpgwL0C7sq6q
         w026pgDtjQ0i6EIM+pT4+O11znQnIryeWee0SjfEGuSDFOLSNuI+kSQauuTdcmjqkN3d
         oA52yQzqVFTS50wgyjz8jIOAx9abJqAanMvsmqvNrauc06wJDoQJFo6U4kfEXQaeLH8m
         t3inmJtVXaiFIheygs/74R2/+FViHbPO5XyWMz/iaN3XQZt8xqrZul7aB9TI2oBlvJ7f
         DJPg==
X-Forwarded-Encrypted: i=1; AFNElJ8LCiPew3V3/Wd0hnQ3kTflTh5lD5XCsKMjvWbue7vi15Geq/tuFnXmavs0kwOpI5bCPZ6U/iFWDg==@kvack.org
X-Gm-Message-State: AOJu0Yx4k8hiM6hn+HETxBCHmnV/nG87t/5svYBBCXk6IQ0ZXuqEtPTH
	H8gum5FvZhTsK56wG/jIORRfCeVDz8VYx1WeJYJjeMrgbEC4ea9gY5jK
X-Gm-Gg: Acq92OFWRMFVArq+CBcbdHB2ql8BAtWpBW3sEZeKgIW1Ct/rqPt6MoMDpvZjIEyj4qU
	85tRYoTzAaZVS5Z/Z9wVk1ML4O2gWBJuLljjwvk3OKkduXQHi/pHc44ykDQQV62qVGNy6eSTjkv
	1UGkcA2hqs6R9oPeQezk4b57vUI0PQsWYT1VHHPt9iw/szON2weqiX13SHQTDJvxDO9vzEx1WjM
	IaZSu0BAQb6WcApVTzwBLFrjfdtxg5IRktV25Pp9hGr5LxUNNj8L5T5GKwZOGSSBiP8i2a3lgQ9
	kz1iVsOI9zOMsbx9Bg5+tWRCyhOSpdndF0wU+RPtwwWNyKL3qR9AfIJ/QGRQ2vLRTBsO0vbsafa
	LTv2bMmUxAc5MNwGZPDp0Te1xftb6WOQLZ4alABoKf9YtaFa4Jpmg+bkncuYQzWFHRV0t0yk+MX
	Rbz3FlnkNfJGqEmq+BuS6dpqJjXbjY3pPQbmhC2DgDpQtm0T8=
X-Received: by 2002:a05:6512:3a93:b0:5a8:7396:63e3 with SMTP id 2adb3069b0e04-5a887ce5f21mr1706229e87.5.1778242764182;
        Fri, 08 May 2026 05:19:24 -0700 (PDT)
Received: from localhost.localdomain ([144.124.192.245])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a8a95652acsm474206e87.56.2026.05.08.05.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 05:19:23 -0700 (PDT)
From: Stepan Ionichev <sozdayvek@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stepan Ionichev <sozdayvek@gmail.com>
Subject: Re: [PATCH] mm/gup: tolerate NULL unlocked in fixup_user_fault()
Date: Fri,  8 May 2026 16:18:49 +0500
Message-Id: <20260508111849.10379-1-sozdayvek@gmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
In-Reply-To: <b1ec6c2a-b198-420c-9ab3-5ffad7f8b92b@kernel.org>
References: <20260507083050.416-1-sozdayvek@gmail.com> <b1ec6c2a-b198-420c-9ab3-5ffad7f8b92b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eqf53aj8q7dhakoocw36zowhwo3jrajd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D668140002
X-Rspam-User: 
X-HE-Tag: 1778242766-856053
X-HE-Meta: U2FsdGVkX1+Syg7bcLeWDiKJ13TMV3NwUlHk1AIh1zK3W33oTwt/YfA4EAr0LW0ZcjFDZq7+ccf58V1G11A7yOxNxxGvePHaPXOW+EH+Xk2phkIDXkLRbnEfdVW+caGgykBHl/Zv3007d66x7xmwPhOzWTsP69CEdr82YEkkwOufYoSjv23vfGPGkd8jIFyYKHG0d5G3ZN4RM89yFgcsEdjM5IJsn3OxQpBMPwlZW+DvOik9RjvWrj2mMQ2hRuJqSqL8JbErSTky0ZtTErKgWYAUzIATXNC9XVGZoNWsw3zBZMfg9bptb8ZV8C2MjvuAwmX8jUvR+KdJV55nW8xwe/K0A4jolS7YIvSV4By5nbbSZrAO/TCkHkvqDAcc/AgJRGspa5QzAAVZ9sPVoxOsrQQMrMRwmwyWHhav02aytmZvl99vD357cYZvhUx46vi4Z5yAbT1er3YNa1S6z7Q3vVgpwEPHMm9NaA0Tj0tZMsMO06PD1+hZinBbyn6yWj1W9WlkiAGryeetvmSdIT1YIijKm4JSSN3zyodk+VWlgFWj0TsPkfnZC7Wk2tr7yi6+SpZA7GI/33VAba1gogUU7ATEGGTWJnq/vBqvU5VbSJY/W+oZxvLVxRZvh7N1mgOG0LUJD2rys0RhmMy4JtYJY4FBi5sAy8NF3H+gKpPtB2QaiUB6eHRZLcRG2iYkTvPakKpIAxcIqJL0y7/JFDdjS7m5j47Srk/BaoVOAu1cuCFvp/cgF1LLm9K0hPqOH1fo13MrTo6895kWdGD901FZF9KwakppXZ2tdSxjEcJry2WzZ1xcIT1Qr5ZUXZhqURT5XWlovSa5GibooKS7YUzHfESUo3ylr1WRfx06fl16nGKdUUevXf2wVrTg61DREhzYMnLtyDhZNPLgfGexIzrhtY93cKYA37pXNf1w+eKMqrII2tQGd9HogcWp60etXbpzf8Py+20S1QCvzn+Bh8g
 x7m4ePmi
 uvylDVqadHuRQQQa78VlmVyhKhQtH1iPN+tKaBXvCTjgt8skGD34lvrX58EGbamf9Z3ipz8YIE3IVK7HFKZQjLBZ+a5T44bpAHsz4Xieac9gt8p7RcqS9ImqvrawMiuqyXQXTQLH7y8MmUq8SW0QCvSk7YYsZk51MMslrEx4J9awtGnX+u6QT0NzoqhBYPaAOdDicxNN0rSFpuGQwnoZvgMd/69WrGQ0nWexsLLw05Bj1e9aytl6lCBVHI3NfCQHU08lEXPO6IYipigu58y3VEVmxmWr44P9L3GiZNuzMPiEcgFJVhlm6wbqMD+9qW+636iVCIw/yF8vTaEecJw/EIIqJ3ZIHq1g66/XRXUkQjRZrpREqhlB+ORgMKLv01vgvcpu1bo7vfG2dhfTvGQx9P4KrYQXUUWilcpmdjap4qIMbncZF0ec7Wz4vZYJinWekZ5V9COP3yzuDSGqAri01EMAhF0MxiOdcsM2LJ5rjORMLUFBxUmIfllFYGAVn99XPflDjA9WsqZ6t+yxXqHFbZQ6z5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 08 May 2026, David Hildenbrand wrote:
> That would be completely broken. We must not drop the mmap lock unless
> FAULT_FLAG_ALLOW_RETRY was set. Returning VM_FAULT_COMPLETED/VM_FAULT_RETRY
> would mean that we did that. Broken.
>
> And the function documents "If NULL, the caller must guarantee that fault_flags
> does not contain FAULT_FLAG_ALLOW_RETRY."

You're right -- the contract is already enforced by the surrounding
code and documented at the function. Defensive guards against an
impossible scenario would just hide future real bugs.

Please drop this patch.

Thanks for taking the time to explain.

Stepan

