Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF0EC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 16:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B466B009D; Fri,  8 Aug 2025 12:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCAA6B00A0; Fri,  8 Aug 2025 12:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419796B00A1; Fri,  8 Aug 2025 12:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3156F6B009D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:00:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04CEEB82AB
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:00:01 +0000 (UTC)
X-FDA: 83754051444.08.A40B1CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0458D100008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:59:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F9duI003;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754668800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGK9n6dq7VxCb/OM51wQ3RDMD15RnRtHlU5OclWuDJs=;
	b=UntNYf3AgIJwWv68QoPWoDfOm4ZiiTKLogbA3wsM6mAJqiLAbuBfThkOdW0HffJzoWrhVK
	jnyptdB0fYAV6ROk+uLAfRntxDhNrg4j8PzPdtWRGGeV8CQ+X/clhP/aqwz5Q9yQw59H0u
	p+dS+ejsD9h9l7vqJNxJo8BHFUYT148=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754668800; a=rsa-sha256;
	cv=none;
	b=H9tW6km8+ZHZx4wyry5CVeV1fDbzy1HVuMFq+UFrW2iu8zQXEY9FBYEXezC913l87vJG6i
	qSC+L09QXBZeva6713HG3cVkpc0R28t7qowYHHDMWUTwiVB4oNLHaMH29v3JxvR404/GE+
	SGXVwoCWQE9lb1ym3jjKNvKYx4W9lS4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F9duI003;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754668799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGK9n6dq7VxCb/OM51wQ3RDMD15RnRtHlU5OclWuDJs=;
	b=F9duI0035PH7W2D34PQDIDkL5oVTc3BK26nVk1BtWbiYf/AIX/YCS6vHEXYbUOA7Jfn3ju
	SeZLOL4XiEsE9XRMWZoDMdNU6wbJ9alLEU0X7GFVG1rCBKC/OtLANihraA+mR/VfnZv0fx
	D8c94JcyS5Cs09kNY8vPS4zTBrKBGgM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-wt4H8Zk0P262tjW9FjN_lw-1; Fri,
 08 Aug 2025 11:59:56 -0400
X-MC-Unique: wt4H8Zk0P262tjW9FjN_lw-1
X-Mimecast-MFC-AGG-ID: wt4H8Zk0P262tjW9FjN_lw_1754668794
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6256195608B;
	Fri,  8 Aug 2025 15:59:53 +0000 (UTC)
Received: from localhost (unknown [10.72.112.126])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54FE0300145A;
	Fri,  8 Aug 2025 15:59:51 +0000 (UTC)
Date: Fri, 8 Aug 2025 23:59:46 +0800
From: Baoquan He <bhe@redhat.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <aJYe8rAa3lIe4Nat@MiWiFi-R3L-srv>
References: <20250805062333.121553-1-bhe@redhat.com>
 <20250805062333.121553-5-bhe@redhat.com>
 <CACzwLxivXFYXuF1OkqcP9THar7UGQ3VVAQgQm=PU9Tohb8hnRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzwLxivXFYXuF1OkqcP9THar7UGQ3VVAQgQm=PU9Tohb8hnRQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 0458D100008
X-Stat-Signature: ezq9diusy6inp3ebcwf3onnd4xokzjfm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754668799-168319
X-HE-Meta: U2FsdGVkX18msGP2lootD5cjcv1YPZDnVNz8EIGUYHlPx3MYS2XdWYFxKiJsLQ1p3bVoiDAeWZT1WySNbG8dYj+GlOHyTlF85/42oqQSTCTL6Tu7ldo+6scHdugit0AAp+seMWOp9DEJSuTBPqm/PCTr5oZ0zMonkpkKGGeyn7sDdvJAck8UCZQV8gSjoazru1O/b7LkjLekS5jgHbMuJlzp5uMQ0CIN/vS/NEStcZXQJhEwJSMchle2dFIJlX1gdZfmqK5rsLN6Tt+CJ1lN9Aas4EJGa1Z2f0jswB7+85AZoPssdxikGuxIOYiazoaDDkwkgx0bnaF0mBVDr/KJueyVxmZBJOcstjFlL7CTU5bfWnA9frHflutM2yZBwIsQ0LxjJul1FjhYxG0G0WyqnMz6VRA/M3Fy/k6zeCVdSA9OQF8PtHjJ9WyAVfw3mIflo2YegrVRTnLFdzzzq6Fi17LeH++xyTQEAC5LUr0K6tkDG2ysnfM8tSmcrvv98epgvRZ3McysEtSE7yByu0EpnKknWMHzW9k0kZiy0djbYa9PSVjyeldjrJLirApWNQEB1MhHoMUZBE6WyWs9eD+VpsyJuMbCG30snG7ZHUADZ0kL4FeoykoaiMyrOWtdBksPMXAYEedEQ+mOrihSdEs9EqU41VyyUwlRSNFBY0Zp/KWuJJfo5ZCRLkc7A0+9yx954dITPhoadp++/N+nhFMxwsinoQTGmdKKWN5+69QVXBe3re7I7W0Fg9WfvSFRts3iHd24fSsRHnNJJqkPp8PkMaOhc9HKhjVmWmYMjwVs6NHrHu9wKsyFoy2WYfSoX28cYFPRqY1jpCz7GiqeT6+QrLX1GjjUVgxqyZ2Yb8DNfYKdwmfk/Cv9uWaoFuFLr3iaqAAFZ4x8ixzmeQZgwrUewhM04hxyyxkMetLtFLAWt8eIkA7KoO5u8QSQDXEvzdpJ30YP5KiTBkq/fcPkpka
 QhBs3dOO
 3mqXspMfGVmTO40HcUiNIDTfCDOH3FelaNCmuScCy33efY2rvRGOZDv9oB66V9PkUfgqpzh5kSZ5OPeYDY+JUn7USFmyF+p9uM96w5KqN0CMq9Vn3NafCI+tkOCDBgPI+W1fi+A6VxV4lI7X60EaF4i4o3fi67VRLe3/h/WpsmLpO2LldpS0+QJ68a4Y3XUunodxWupQ4Xv4/qi2VbP0YzoBwHH3uqLKnT/tQZ4I5CsULBysvG5XT4749dyB3ijDRm1jCoMNcHEDlKX0iHXNekJirMa+RjVc10q2PZzTvizRa7UGx7XUDpFCsU6yVYL9sYK2MnlpSPioPJ0/O7oidQNzBPv8DJ50PcixlG3at8IX+AaXBOoB9l8EU7SPlynaa2VN+6CScWUJEwrHy6d0EwT/g7L1/W3wW4x8Z3wYsYa6wkFoR6ZyzrKnAW4Dc2qHMyoNVNb7mo1CHfU8qXhaG5ARx6xJFqAijJ19chSkwb7/W4Mp3jlo7SPB0t6wT36rK93NeC/dKnC+GUwIXr9ktga1kiCWycKom+v9TL5jSVMOK1nii+kqEiMSvwUVnl7r7JDFl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/06/25 at 11:24pm, Sabyrzhan Tasbolatov wrote:
> On Tue, Aug 5, 2025 at 11:34 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > Now everything is ready, set kasan=off can disable kasan for all
> > three modes.
> >
> 
> Hello,
> 
> I've been working on this already and a different approach
> with the Kconfig ARCH_DEFER_KASAN has been proposed.

Thanks for telling, I don't always watch MM mailing list, so missed your
earlier posting. 

I went through your v5 series, we are doing different work. I am adding
kasan=on|off to generic/sw_tags, and have added kasan_enabled() to needed
places. In fact, based on this patchset, we can remove
kasan_arch_is_ready() more easily since in all places kasan_enabled() has
been added there. Before seeing your patches, this is what I planned to
do to remove kasan_arch_is_ready(). I will see what can be done better.
Maybe I can carry your patch in v2. I will try tomorrow.

> 
> Please see v4 thread.
> https://lore.kernel.org/all/20250805142622.560992-1-snovitoll@gmail.com/
> 
> It also covers the printing in a single KASAN codebase, instead of
> printing "KASAN intiilaized" in arch/* code.
> Also covers the enabling KASAN via kasan_enable() for all 3 modes.
> 
> It's up to KASAN maintainers to choose either version.
> I just need the confirmation now if I should proceed with v5,
> or your version if it covers all arch and cases should be picked up.
> 
> Thanks
> 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/kasan-enabled.h | 11 +----------
> >  1 file changed, 1 insertion(+), 10 deletions(-)
> >
> > diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.h
> > index 32f2d19f599f..b5857e15ef14 100644
> > --- a/include/linux/kasan-enabled.h
> > +++ b/include/linux/kasan-enabled.h
> > @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
> >
> >  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
> >
> > -#ifdef CONFIG_KASAN_HW_TAGS
> > -
> >  static __always_inline bool kasan_enabled(void)
> >  {
> >         return static_branch_likely(&kasan_flag_enabled);
> >  }
> >
> > +#ifdef CONFIG_KASAN_HW_TAGS
> >  static inline bool kasan_hw_tags_enabled(void)
> >  {
> >         return kasan_enabled();
> >  }
> > -
> >  #else /* CONFIG_KASAN_HW_TAGS */
> > -
> > -static inline bool kasan_enabled(void)
> > -{
> > -       return IS_ENABLED(CONFIG_KASAN);
> > -}
> > -
> >  static inline bool kasan_hw_tags_enabled(void)
> >  {
> >         return false;
> >  }
> > -
> >  #endif /* CONFIG_KASAN_HW_TAGS */
> >
> >  #endif /* LINUX_KASAN_ENABLED_H */
> > --
> > 2.41.0
> >
> >
> 


