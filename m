Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA5EC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 18:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E8A6B0092; Thu, 10 Sep 2026 14:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7AD6B0093; Thu, 10 Sep 2026 14:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68E76B0095; Thu, 10 Sep 2026 14:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF4E6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:33:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0181A0640
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:33:09 +0000 (UTC)
X-FDA: 85198699698.27.57C5D1E
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id D56ED40008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:33:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGSDRc6q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789065187;
	b=hE0EHFsDsthDthDeKvR1oY834ytTH68ouwqk6NOmP+aGEtB1jFA++IiFVpHx9pvUaLUvoE
	XKtxixM9kkKQIQdml+p6pj+s4kMOjInGlLXmVvaPKyxY4UOV2VpifZt6ajLd3xWFbXI9XA
	d38kxJMwiPxr837nxgL6duPLg/pIKJA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OGSDRc6q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789065187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ost6d0L83lIoeZ+lEEXbmuX93WTw58C3/ZwNuzffpI=;
	b=xZHAtfFlpKUTaYKVrX+MnqhIcDj7gQwfaxCiZ74lvVYR4y6rfpjr6TtoYJoUQWH9VcvJyE
	q6XmA3rFsdAbTatAmbznFpE8VVxNynTmURsd843v6GRf23jo19FgP/CsJqTZxOKRX2YaPD
	0rjNAbEXBZrryLlXsNLonwXJkMHsnNo=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5faa1cfso174235e9.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789065186; x=1789669986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ost6d0L83lIoeZ+lEEXbmuX93WTw58C3/ZwNuzffpI=;
        b=OGSDRc6qSYY2pEQl2bCC5V4g6e8n66coXpkuRKDRMP1ckGasZuxLO1YHCRacLDadRr
         unVsXDMwebOLzNR3cNDgYbJ1GbBL4g2o307J+u1XJpMF4B03s7Ur2baPa6INCNWGTuuL
         Y8mpBhKoT+NSHV1NPEz+OHIApJavnt40Vgf+16arnBU4eH82mYB/AGbTCGJSFQlQTDVc
         CvsVR537KJavv7mdNx16PD9ibR7tDcSRjAPZrLnKERdHhU5+vpbz9ZcLp+5ux9BJ/gy6
         dPBLLqfzbscXtZ/hWwC8wz/rCDpNa4wAHk6F2kV7uEl93dyrTNVjcoIZ0sAByDW3PvaS
         9aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789065186; x=1789669986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ost6d0L83lIoeZ+lEEXbmuX93WTw58C3/ZwNuzffpI=;
        b=HGDuBWn52awqwIUMDy2+7/TNe6RqhKMeTwqa8CghU+jhFj41NX/zd2yuvvjBYDahLM
         dJHOhsTaST8zhAbyce7qMF58y5g4fNys4Uxt5N6t/dwzRhNCiqLEmFQtbEONZSe6IpqA
         x3KmGUWn9Nbn23fpkvjiDcnWb09iwVNkvH8pZNlnWUptu3PlTbbF+pRiT2NNorEGVjDj
         pgtZLRfwk2bsbdTuiy+IvR5+8KQGMcXH3T/WGBIzrGsAbYD4m836oXQ4n/fmvyi+Hawo
         WIQyiwGMyY6kmbYyuTEhtzyB6Cs+vJ4t+J2vTsLeA+QJdAu2Ein0YdTep/RLMP4fFzb/
         Lncg==
X-Forwarded-Encrypted: i=1; AKwUvBzFJrDcYqHRcQnTDiSEdN1dTJW96ku3k5VBdpcWwPjBKKh738DD/4l3CD40CiDzLRfHUyKVYkdBiQ==@kvack.org
X-Gm-Message-State: AFuF++luQWpeN/7lIR5VbWdHCpCh6Ero9zZ3dgyjU3HcYPwJToc+GtWF
	gi2RZOvu3+7miUsbZ1Ygz8278C2MqBd5fH/fNNZjhPQ271K90PvxVZae
X-Gm-Gg: AYBFou0Uk+YT5BqXbHBvwmX5w4uXlHalzF6qUCz95WUvK/J4eJlbfRwpRM3uTwdSPLE
	iPEHlo/FSXWAOZ593chUeaTpztgwFh+zBBPhLcXBXbx1QR2j/umP/fhnnFCXemipjCp+Rged99Y
	dek3a/g8vivttVjn8zPKxybzDCabh1GxzxA+YHYzBtqkKxxr/L6YPS0iy4XNDUTbgkZYcgPNVfA
	ohSpfQxahPv/N325AaXrERSw5Pub76zkTfyp40X8RYNRUBA7yzuH2y78c7ZMSwW67jIOTnp1v8z
	W11kxNrxoSGJTz0BTibk1DRzxNxrdJVF2WWbOYfPFKgGVz/s9bGD9uejx1ZvqhefzLwTFWh+8Y9
	0nwK6+/dVqIncFSt9iJcPNGL8vxggoyMoPoRoyp22xIGkE0jK6wEhOg7WCopH2ePcNEr0mH7K/j
	3xDcKyAGHvuqeZddtbbz4P3ojdnZVFADJkp+qo/r43YU1w2G8m8f6wn7rC6lvnQtu7Z7/EQhcto
	ghO6FTuyyE/yLZlwNB3LvIMAFUYcK3d
X-Received: by 2002:a05:600c:4688:b0:49c:cbf4:572b with SMTP id 5b1f17b1804b1-49e619ec129mr2824565e9.2.1789065185924;
        Thu, 10 Sep 2026 11:33:05 -0700 (PDT)
Received: from lima-kdev.local ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e5765152asm40701325e9.11.2026.09.10.11.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 11:33:05 -0700 (PDT)
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: tim.c.chen@linux.intel.com
Cc: brauner@kernel.org,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	imv4bel@gmail.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	qyousef@layalina.io,
	ricardo.neri-calderon@linux.intel.com,
	rostedt@goodmis.org,
	srikar@linux.ibm.com,
	sshegde@linux.ibm.com,
	vincent.guittot@linaro.org,
	vineethr@linux.ibm.com,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	wanglu.priv@gmail.com,
	yi1.lai@intel.com,
	yu.c.chen@intel.com,
	zhanxusheng1024@gmail.com,
	zhanxusheng@xiaomi.com,
	ziqianlu@bytedance.com
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Thu, 10 Sep 2026 21:33:01 +0300
Message-ID: <20260910183301.1208504-1-kayracizmeci@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
References: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D56ED40008
X-Stat-Signature: 896xkso53u5ktw518atfy6uus9pjke56
X-HE-Tag: 1789065187-218062
X-HE-Meta: U2FsdGVkX1+2YvKpOIfxJ6FqZI6zllDU259VqTwKL/xRgtQiiZRWAebISfWTMkjw0JmyHH+BgOqueCwm2SN/zOU1LXTiVuybBiUahkkIpVCAOEOW8cHhhtrD1V82EEeh8DDPovV8aemPjNy30+3LmLacYYM6vOnzDkDQyNApN3fgoxMUyC7Iyv3rMIremWXfTUSth1ngbnpoeuYHKxlsiKcYN8hbAq4Y41t9LmToGQCyUfOGBWO8/aT52ai1CDVgCTNzmz8845iqInJiE3N8XJzmDHLlqVBmtoGfCUYV46PTMorSlgxKCHjVGaXnW1HZQqJHN3DY8QZxwwSnKuC2Bh6ojKR1gsP54v1sIkBPOpBn52ZyNnlIHYOnN1COGpLv1BLCCPioeW/5HK+6OaNftiERRxI/bnHgEQ7kxp5XIRT8SXJp5ZHiPKCLulL/ByBHwmq85z/zTarZyuoGn9dH9cngF5oQ2WilKROQd3Kw5h4hjNDqu0M9kOe9MZV8TvOKt4QoxNNwaS3JKjNWS952AfK0gkAw1yZPcs5sbnrnnXxPjqmpOdPARQMm/fqbK9a1II1INenVlcd3KEn+CtfrMr2//BWTLASIFrZqRWC3/QBWk7iqmoowg1kfTSWeIQdHwouE3RUPMd1ZcxX2oGeZOjZluX+dXZYo+sQ4Mlc3CBkxIfeN99xBeSr5rr7HOH+gqKRIwKUFYdoKgRsaVMziZpXZ4EF/ugvtN8u9O51CBJQbqDFYFh/Diyjg99V4fL1SxaZ627kKOSnhigRXhrdrQ2IJhF3/8Jaj14giJmFius5RhQvFO+cDOfKNaJ8wI6Zl3XlRdapCANkMtkL6Qto77qAfuHEj18+TOIYX4RUlC+Twox0/QQ3rX+sQJc6OMrvOUEH1X61XaS7TpUjHPdtYDjfon4x3KGzKpur0xb83FxJzftEXPlOmJDPXs32+txT9Kyuse1gzp2LQ6zyuBjo
 Lx/kBHz/
 kaAnEUVfNynQ8q9ZZ2X8RHdyv7PCr+9JWCewkNnfxSzMXWeUAzECQ5SSw/YMHlDtkaKQhFvrRrO+WpD/aRNmDVHzQObQhTjDYUxK5Rb+JCHjsjoT+qaFO/2MAhgqV77u46RE7J9PMji6j4QaKHOOOwKfdQqJMkAZaxekh3HKKFOtowGuTbrvGthGh6G/ZNul3Avi9AAfYd6tl34Cf4hHilHasw47bY0CaFGeMy10Pzv3/Y7lbFvg/YN7q+NXw7Fl60YV3Z5FUPQVMxWUT0Kq3AQOrYLK1KQWXH4yYuEctclGjNOMr31VXoTI59UzP0zKgAzg+tg1Cw8ZXKEk9TIqU8n4DGStuzf+jST63nxB8Ds/783iuc9KZKE0DSSDtolWN3ZFgskr3OHWXIsoPoiiIN7YGNOC/7kXuKocjzP32THTj+4zAWqpszNM/SB7C6RsT0pmv5AqTFXA3PFOUqCVfY5ZXK1N/ZhYUAwkyjCdD/ja0YROWhN7wmf2hNPx+ZuQiX4qu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello :>,

> alb_break_llc() decides whether to break LLC preference during active
> load balance. It does so by testing that every runnable fair task on the
> source rq prefers its LLC:
> 
> 	env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable
> 
> But the two counters cover different sets. nr_pref_llc_running is updated
> in account_llc_enqueue()/account_llc_dequeue(), next to cfs_rq->nr_queued,
> so it follows queued tasks. h_nr_runnable is updated in set_delayed()/
> clear_delayed() and drops delay-dequeued tasks.

> So under DELAY_DEQUEUE, a preferring task that goes to sleep stays counted
> in nr_pref_llc_running while h_nr_runnable falls. The equality then breaks,
> alb_break_llc() returns false, and active balance is free to pull a task
> off its preferred LLC. Active balance only moves runnable tasks, and this
> is the only LLC check it consults: once the stopper runs, LBF_ACTIVE_LB
> skips the per-task test in can_migrate_task(). The runnable set is the one
> we want.

> Fix it on the counter side. A task should be counted in
> nr_pref_llc_running exactly while it is both queued on its preferred LLC
> (pref_llc_queued) and runnable (!sched_delayed). Define that membership
> once in task_pref_llc_runnable(), and adjust the counter only through
> pref_llc_running_inc()/pref_llc_running_dec() from the four sites that
> change either input: account_llc_enqueue(), account_llc_dequeue(),
> set_delayed() and clear_delayed(). Gating every update on the same
> predicate keeps the delay, wake and dequeue paths from double-counting
> or underflowing; see the comments at those sites for the ordering.

> nr_llc_running and sd->llc_counts are not touched and stay on queued
> semantics.

I have one question tho, can't we combine the checks with h_nr_runnable? On the paper
if we are updating h_nr_runnable we could check if the nr_pref_llc_running can be 
updated and update it if the condition is right. Because, every nr_pref_llc_running enters
h_nr_runnable while not every h_nr_runnable enters nr_pref_llc_running. 

Why instead we just check the nr_pref_llc_running's conditions on task_pref_llc_runnable()
and call these dec and inc functions after the h_nr_runnable updates. Wouldn't it be clear that way?
If possible?

Thanks,
Kayra :_:


