Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F7DC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEFA6B0093; Wed, 16 Sep 2026 05:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0726B00C3; Wed, 16 Sep 2026 05:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93D06B00C4; Wed, 16 Sep 2026 05:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4D66B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:50:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 877BA1A067C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:50:22 +0000 (UTC)
X-FDA: 85219155084.25.7C2827B
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id A978DA0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:50:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtDQJtEk;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789552220;
	b=HpSx18uRsVGMAfxIX+SbB8dp2oxB/P96sT7cD6oB5SAYJZForBOtpp4O7FnuiHFtNT2RJ1
	qkMkvhCpPHUevwFMh6ltem4Tfb+RHrRa2myImB0Ua3EigkkNKcL+H57tCqhmDdqjiszKTw
	W8+srPHfDuxI7MvTJ3giHM2QJ0CXteY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UtDQJtEk;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789552220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79YAdtaHEv3S3nDvYc6X9C5ar06F3FncZEtUncQdJQ4=;
	b=G9EIjUU8Zxd4Nl2cROnURHD1bwm5aA/mUwk9YKXTGWKY5m9iyXkVwd3TvpPZrJx01wzy+l
	04hoZ2y5PHKHi+mv/iW5FCcv5IVrBBapKmPHRd1I7PANvwvwEL79vYTvajR0Q7K3DCW0c1
	EMlx4UQ7VV3uH0nN823jPvHzRKDjBco=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e66390995so4145615e9.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789552219; x=1790157019; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=79YAdtaHEv3S3nDvYc6X9C5ar06F3FncZEtUncQdJQ4=;
        b=UtDQJtEkS+QY3MYsSzeUf+Ncd3pOtaWGkAeIRwGtcJyzk12ztpqO4g/yiPfsvaimrJ
         WUVzGA2w6Ln8JLzRatuo1PA7VmrK0kH9M5YoTx3HxTmzESNRrdtO93viB84K9fI1LyfV
         Uyv9EJ+DKCeT+FUkM7HH55OilnaKU/caRV66VIUxE5/ATp05M6GxpqZgXAvWxMTkxoLO
         6J50AldLtTSt2ICn6Xhcc8cVRU9Mydmi9r9RGRdgdybI7qBBLgwLfXCGxBp9m21AyB7w
         7rfxy0tDEL+O7y4Y63eaIRoSiCeLA03WmJ/+AXfGpR/SWNirL63+UZGuI7bsKT0zcEOS
         LFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789552219; x=1790157019;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=79YAdtaHEv3S3nDvYc6X9C5ar06F3FncZEtUncQdJQ4=;
        b=EjbTpnSx5pzSH9E0JiZiGNsc0nVOP6Gg7jeSA/mVUhab7/yUwveWwPrm/1PYUl6LoI
         zfooXeCHQ1MiIuPB0OWItyYGNnDL8ZMueCyrpARaO6KKwFw66d8tXdscjux9LUzy4JXC
         Or9KoKuBbHgm1vS1/MEET592h/4M0sbzIFc9HEDjoN917sA3vmbK0L4ipLP7S7XV9lA1
         Kxbkvygs1SMVw26ZFduBZsSGvNLzRJKIpI0v9YFz8a3kGfOftv+2kRYretHxkKB1VKF8
         +ndrgzjW5IiwrThPUONso45+1z/l6m2b2CPjzlZTO7p/h/AbmhWi/exzF9NM8laO1yV5
         xUfg==
X-Forwarded-Encrypted: i=1; AKwUvBx5+naGzp00p88mXiwEwc3KovOc0eYn2mREIGhHmFnhCvxLPF1hzMTwb1I4TEsSAYUb25l+l2PL0A==@kvack.org
X-Gm-Message-State: AFuF++mFBadERnUvuqLROMQdjQbFUMLy7kBv6m/pA9OyJ7F/sj7xTxqH
	FxAOwwsy9oLsdM6GUSalNeTL9en0b2Mnpf/rLYwCnjtsm11gG0RITlrn
X-Gm-Gg: AYBFou0zMh6n71DuMo/6UMGTc6vxOtOWMAxuCTjBJhzE7iBm8c+k12xRyfzVfBiZvIz
	Jo5kPWn+6LFAlJjxqf/XkZmOMTxh6N71hTk5r5QS3AHmHG8jxNGASYsMXAyNrGUJybiabo8iYsV
	0M410oqi/6lKZPd2zId2Dw4s+fxF/lchpOR9RR11Dj3vGRkBnEMz6EMgBJQaoCZw91ZzPN4DeIW
	QrFH7eNZUd4dxU6Sl1MHCTZeyh0HrGeJwgowQpLm385sphMZ9m7fxKuO590p4KuLXpip0ntSdVY
	BHljwZIZZjj+My0b19AzgjaQ7looG4/uPjUV2aLdRC1+WUZqRuerYz0tAQ1hMCgNSSQtfcxB6Hp
	XsVE4+SHsJLCxlgPkcBrgq0p0yab0zp4yhTaQSmD+2o3gGa8J1dUSrCNSPWhtGyKoXXcDyW5Bed
	nHlwcOCba9TXI8DmYRx9cPh/0Stft6VsbnvW8jVkAJaQiNXGNrOBs5diKKFlC1hv1lDxQdi8aDN
	ezkVpnr+y9VC8ud0MfacX5AXizfHJLMtqRRR3TqdD9QtgQ=
X-Received: by 2002:a05:600c:4ec6:b0:49c:fea3:8633 with SMTP id 5b1f17b1804b1-49eb732aec0mr19444455e9.24.1789552219000;
        Wed, 16 Sep 2026 02:50:19 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e83b02245sm84055225e9.10.2026.09.16.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 02:50:18 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:50:17 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Ingo
 Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Oleg Nesterov <oleg@redhat.com>,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org, Jens Axboe
 <axboe@kernel.dk>, io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
Message-ID: <20260916105017.13ea5e36@pumpkin>
In-Reply-To: <CAHk-=wi3Kkqgfg6zUTHpQoZNL2VOB4vYqpi6RX0WNO++29UtyQ@mail.gmail.com>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
	<CAG48ez1RsdT=O=-0city3vjgWhDvY424KtTmrCJntWy5ds3HBQ@mail.gmail.com>
	<CAHk-=wi3Kkqgfg6zUTHpQoZNL2VOB4vYqpi6RX0WNO++29UtyQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A978DA0004
X-Stat-Signature: fu8kmt74zraohp6hwcsapj914ts1wjxy
X-Rspam-User: 
X-HE-Tag: 1789552220-995529
X-HE-Meta: U2FsdGVkX1/GHWaHhyrvKiSbyZ1fktF37tO7uRzhJagqbhdfXJTSuRcS7DiesxJcBP5j5aavt7DMoxDcBsLFRwiiqr3G86c7h7xGNF3G9V7gv4KWFh76EGA8wFJuN1LhU1Tx1il1xLlEVVdNPEoPoGKIZ/ktUl7U7PSeS+moRIHuSJmWjw7d5PGqyyWkRhecRtdfGcZe5NPOi7Cucb6lptSFt1+K0WDv2YRaFDPFyyZFmib4lQSYD50yTLI4MBumrMeDZgtr4GW8b2mAqCkEy4vunJuvxTpYlwFZWqAqRiN1Kw+2Pya755zxm93F0LwF04pa5URJ8yOljxfVTrmdJrY8G+APKzoulbi+ngrib9/d768zUz3V5/QnjGPZbkE7m0EnkAgVpSZJOlxhv48/RjpQy2S0506vhQpS6nLDcEmBtovYv9xuD1vabXnlaKbJY2D6DVwqDe+yZHXaXwnQ2hfSxD5mWd6OvRzBIwWtkzXRtqFAAaXA9QHhAx+W/j8WOxb05XI9umPTRPp7agy75UFZO8oAAe8nXWhzLXU6RFk61/kED1uqxBF8ZVwJrOiQKVs/H5Q8rabLPmpjkIxfFgW0P4XcFDxmiOumzwS7XsHDqSOxYHP9M8K3ytaAMKf0W9EIt2LE0jKScdJT9TJHhfhA4H3uhjc/v+Hx5vJLsMukwYZe12HxmTbdhz/p2UGkoELj7e2+oOEM6J5Z8BGh7qAYiYV1WU7vSvPArf/IpfYu3W97mybQtyRVFxAGT3+3ET6uc41rs2fxZwzmsYR0pWQ/vKB2NNT7uQ4eOVRxJrlN4ERLNRmEKlGLHJTXtQ1lUSn4tCRsiD8BDWUvrAMJHB1Ios+OdkY2xcHmW4H/08hPPpkabmgjdx8Lw+nCpsAUthLKxU9A6EnUns1koM2yLUStkiH1n2aV+kWKBHE5Y3B7q1g5hwORZREBtrdhO/nZwsmYRI74JvyJvSS6r/J
 E8+GCDEY
 YgwdyH9/CQCwz5SoQPEuKA+T+E5W1kfGk4ksEPZpfg9TeCmCwlHoSz9b/1D5POwluM+JbIjGnlfp5owgY9D2yPrzHmmmay59gnp9Hal+L/lVDmYdhDcMgatYwfB6I4BvIzqYQ40SHu5nDsv7Y7W4nAr1kBnFcKZHogyGVDMOoV9iDoeRtqIMad3qLbwNd60kTAb9pfpsXkaoNbAgnYLynqMH8d3giS1fQDRv7HmYY2FOXFMIvYmHB1QZon5hz3LDzVtCDf13/ui+APipDmv7MRCPFUyFKKgyvoOpvfj2yWK8RdXjsvU8fdwBG/UHYLcxTDurWm/+oRb0mlLsyrfQtDhxDhWipaz8wj2ruFyGC+2sS/PsD4x63ADrzeN7XT5o5JdD8B98oL0P8FmFi4dSIV9BdI2DwWhDxilvFZzseF9KQYI4hxUWa7NPPlWYOJmQLV61KH6ga9vs26ciIMrHZMMMb+YmDNQdLFX8hX49j+8Xji7yoo9Zi05M5NOyyVloEyLePVAjO0iYf7Hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 12:08:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 15 Sept 2026 at 10:52, Jann Horn <jannh@google.com> wrote:
> >
> > Is this mainly about stuff like "we installed a file descriptor and
> > then the following put_user() failed"? Because if so, I think a nicer
> > fix would be to have a policy of "if userspace provides unwritable
> > memory to a syscall, just keep going and pretend the access worked",
> > and maybe have a sysctl that kills the process when this happens to
> > emphasize that userspace should not be doing this.  
> 
> We've done that before, where we just ignore put_user() errors and the
> user gets whatever the user gets.
> 
> It is maybe not optimal, but it's fine. You can find quite a lot of
> unchecked put_user() calls with a pattern like
> 
>         git grep '^[[:space:]]*put_user(.*);'
> 
> and some of them are in core code - see the two in kernel/fork.c, for example.
> 
> One of them says "if userspace has not set up a proper pointer then
> tough luck". The other one doesn't even bother with a comment.

I think the code should try to return EFAULT (IIRC that is too hard
in one of the exec cases).
Otherwise very unexpected things might happen if the memory is just
readonly.
If you ignore the error and the pointer is invalid the application will
get a SIGSEGV and (usually) die.
But winding back kernel data because a user copy failed is likely to
be problematic/difficult and at best have error path code that isn't
really tested.

As well as writing fd numbers to userspace, some sockopt code tries to
wind back if the write to optlen fails (which has been read earlier).

I've forgotten which Unix converted EFAULT to SIGSEGV in the system
call exit code - I'm sure one of the ones I've used did.

David

> 
> The scheduler has two cases too, although one of them is admittedly
> for another error case.
> 
> So yes, saying "if you pass bogus arguments, you get what you get" is
> a valid model. It's perhaps not the *preferred* model, but it's not
> wrong.
> 
> It *would* be wrong to take code that already has error handling and
> remove the error handling, though.
> 
>                   Linus
> 


