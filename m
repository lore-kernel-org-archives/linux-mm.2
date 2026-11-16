Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75587606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BooxNSGX
Received: by kanga.kvack.org (Postfix)
	id 5B0966B05B4; Mon, 16 Nov 2026 15:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588986B05B5; Mon, 16 Nov 2026 15:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E3D6B05B7; Mon, 16 Nov 2026 15:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 134186B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:00:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 470CFA7213
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:00:16 +0000 (UTC)
X-FDA: 85442048832.17.DA24189
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32788180011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:00:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BooxNSGX;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgYoS8Jg+X3AS3gIOJEgllVRt0eGZvLJAbdMyeSaVoE=;
	b=4qT6fr1/BKyj9+mZ4g4L3Iibvh4O2GxudeszzZqnkpZmDq0hOf7dYYIEUHgJC6MWn0yc6v
	BOvXSeKx2dXvDo0lr1XPh83/en6nXImgLzWHcfArZXUyzSpppoHL4/vFspgtfhHaLzrWqv
	8JCl1U/81FdhPwQiysGZ1gUH41C+OHQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BooxNSGX;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf06.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859214;
	b=GUz5OV0yOnvQgDSNiTfDIcyERkSBS22m75/9iVYl2gOuth60h2FxCf0FtT39eK+7ewsr6v
	lISr4of3vJZxGU2kkyNSKRWcG/GGoi+gWWW+jEPHEOHmHs2ACZVEOd2rCsmqAN/ucrxXcu
	rbyYfFqpEDYIrrnHdz1qQzGGI/RJRuA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so10806755e9.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794859213; x=1795464013; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fgYoS8Jg+X3AS3gIOJEgllVRt0eGZvLJAbdMyeSaVoE=;
        b=BooxNSGXNV/JHH0T8BtbQYi/EJ3IjJ2QPk5Zxb1PVlcesWPVA9JdIKgRAygeyXRq1C
         N0GUlk2HMtHq8cxvCJuJTLtwEHC5e7umqSU920bAqWgDeZLDijV2xDcmsjQrCSDd6S6v
         via3vSBkcEQ5BG1zwcZ3Dv2dZ8lgnpZi+lFqT8DSgp8mBuaupT5FsEbqB3/WgNZynrTj
         JYylZ/kDrvhYzjUTxYr5b/MY+6gsVrHfgOeWBYc0sVTG7G9vfcXPxB2Mmf2jhIFqG5e6
         qOeLlcvtjZQMuWp/lkgEfRsPRnxP4lgoJxhH2ygwX3hCTBMpLX/FAT65Vo1/MTJNBGYG
         gSZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859213; x=1795464013;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgYoS8Jg+X3AS3gIOJEgllVRt0eGZvLJAbdMyeSaVoE=;
        b=ySnqThghHw8pfWnaDP5/YNPQE/bYG9/ZQQgfaHCMFtenk16YszMIiLS0YLcMrEpnTj
         9PodUmKtjAAqMybu3mnZwnkAb+d4W4zwsnnNbPjUfNXnMYKIR3C2BsyGgppU7CwvkSUc
         mhe7oQZeZgsFMmraTMGH6S3OnAdRKCquE8USR0FuztEITIyOeclx9yWugl2dJ0crE8AR
         ByY+XOzKX0prYiEoKrw0s3GoaZ83nTr53duRvlBcFezOqQwEft0yAsgaD2Ps/7KibuAu
         V7RKC6wfn2sfAdpLKe2bPEYK3NpnXaRMunYPCGiZboPePows5JvYqc+zOcn5zEzJv26Y
         DVNw==
X-Forwarded-Encrypted: i=1; AL+hErG0eZWiru+Mfb67XDmd6kOOqwG1cTZtYuZqg8brIgu/oVhTnCnIfk2kdDALFXlXVWDlW0nsyRzvZQ==@kvack.org
X-Gm-Message-State: APuU4Z+epp8/Atm5BJQu5XDcYUV05PapDDfChQUNjao1LBpPjELchWkf
	9Mwq5kalhEjKzgBKZ4y7tImAh18U91bYd2zx0xjQOoTXj+QqhZgdAklC2LLLKKWBzco=
X-Gm-Gg: AYBFou0jEsWfaSZfUKvK3lyW9N5Rh1xxTdWEGC4o9nGY8TjDhFEdqVcBoVXSTxIX3eH
	nyr70RGYiaYc3LfH45PHClxKRHZ38bKaHqG6A9Q7Xgxj5Q6IfKdHRF9OaZpLHxg2uTWCiofQgtT
	xUTN83ub8Z4bWZC/jYk0/eBCImCqxmMqm1iGFzw1/dWKza/v/OPTziZ4V7El3UB0yoQBxDoUBgu
	DlpJ6SeV6STxc2LgxtrWPrpLvyNnXDoYSYyOinBMCcoMEz1Cjv+SfmDzx6hYAaWMGrbkTUNVsmd
	5SSWrmY/PUhGZ9mlxWGPCmOKaIbMKOk2fo/GRKipQWsuvJLCS88K5LOXm2AXB1OJ8BpbkAJzLLo
	IHFoiCtKK5l2gPcKkf5rT2Uxjm1tjr7kPRbqlAz5x0gy50P8pHEg+glSmUKIU1b08EtpYiGh9B5
	aw5KUymOBnYMtxReS7ETWdazvSP8iCLatppz2jAI+Esrn+PIQPlIxbFHZYjPbQmKlYLUnikDKUp
	5c7FRLQ/e4/7wyXIvYoeZdr+A7zGOBtBPjUCjjehkzRed8Cwx9lhLkwyfhSvdf5CdhzAe7bHbQ9
	VN0V87in4kCybU893uk6AEkk3pbSZXE=
X-Received: by 2002:a05:600c:8709:b0:4bb:73ad:c1f0 with SMTP id 5b1f17b1804b1-4bb73ade318mr72004685e9.23.1794859211890;
        Mon, 16 Nov 2026 12:00:11 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78386902sm14032225e9.1.2026.11.16.12.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:00:11 -0800 (PST)
Date: Mon, 16 Nov 2026 21:00:07 +0100
From: Petr Mladek <pmladek@suse.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: john.ogness@linutronix.de, rostedt@goodmis.org,
	senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, kees@kernel.org, anna-maria@linutronix.de,
	frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
	clrkwllms@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 4/5] printk, tracing: Support console flush
 suppression and tail pinning
Message-ID: <avtgx3WkeDvn7zoK@pathway.suse.cz>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-5-atomlin@atomlin.com>
 <avs4igB_mEc9U-Yw@pathway.suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avs4igB_mEc9U-Yw@pathway.suse.cz>
X-Stat-Signature: mp8qb8m6bki4uwcm47u7s7zytdpeswr1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32788180011
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794859214-103563
X-HE-Meta: U2FsdGVkX1+h5xsKHNLPe/hpxKCFGP3FGMrkETeDR67UjsPDsBZ5VFskzv6xYwjbKDAVEvv6mGEV9a5Wb01ROhEcMfA/SB8fWYJXr8Q0SJfpoZy8kJKXMYibPbR6+dLza+6DWi4el0tZiTZZshVi8uY6c4Ux5HzNgbdAI4ggrahtiUlde/1Nbef5fZWG9DVMxoVU3XWg1bCYu94eZNJrwbfkyFr6kI1il0+Vh4wgfnht+i5GQDN5yOEusqsbkVFiU7F+Qyfv0j/+UgJSe9KMSnVr8kIPnv4U/xt8F/8MjHB1/3qwBHvZrYfl76tNeSSdSOUtlyUUgqmDzdtcHajrgiCoWQpmeS7aP4AzUpTyjxrD06ZH6CzICTcwKeQ/W9N7gaC96QLvwHmpgCK/7P/2SNoyFib6uBDAGaXNy7QeubDNrgicH4BjIEpXyLhheP81RPWscDkLVojvkqu4XSRknKiKKMgXXACOrQJ0cg0JUuXjmBs9jEPEZpPjwEAz8SQMHwe9sBWVaiPTC52oSeHV9bU9Fa9NMtXDA6ncGCiMoe/ueAErWMHFR+A0POg6SW/hD7amxMGjVqDNSchUNe8UVMaSiX9jpDhc74JUwvyEaQinmXoEtC3YRGLRWYpa02Uw3DNlT8JqcBqsJ6pbOAfU3qa8xi8bBhnoOXtl8Tii8KKjU9/V9AJnnNyp1XhV6lbBborGsTk1rnp/7pq3hpTGJfw7e0Rfi+JoSpAHTDbpperumWZ2ABhrxIyjWyVhPNAcSKQgf65E6pSknIZQkYZ7uNmru/iQRmeIrzdoA1zwXMihTDMQ3qK6qTgfVgg9Xj7Hq9BscM3rzzp95T+hm+SQ4lD8OwXM+RJ9oM+qE/O/YIipdWob7rgEOEeeffpYr1XxJnyLVI2sH/LPrJPOvtznjcfri/Vrb7w3qakXga36x+IOVJ1mTUEBJ5ys3AZ+b+sGL2CUWycsTZBu9wrvo7C
 3+qn4hmh
 wL2v+dQy8IO41tK5rJBjXhgKIxSU45XPPtLSEPGWywsBeC8yE2COhNSrv1DA/g6H+3c+ORoEvIcZJ8uPP9+gcaeroy72x8slIt0HStqYy3miHec3GlZ07k/gn4t+SS+qHJx7kHDQAWWXpbkHWW5n44vo3SNf9RZFVbJKlVRNKEqRoopCYtIO3pFapWn5mOrubGTjDWSBShRKikcGOHxCngsJgpZso9M++cg7W7Jx5hRhw6bCFwDf3HIzzIsmuURoLcuB+F7Z0I1u5clzChN4a/VtWjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 2026-11-16 18:08:31, Petr Mladek wrote:
> On Mon 2026-11-02 21:44:52, Aaron Tomlin wrote:
> >     2.  Ring buffer tail pinning
> > 
> >         Provide printk_mark_panic_start(), printk_clear_panic_start(),
> >         printk_freeze_tail(bool), and printk_is_tail_full(). Recording
> >         the next reserved sequence number at the start of a crash (or
> >         clamping to prb_first_valid_seq(prb) if the crash output itself
> >         already wrapped the buffer) allows data_make_reusable() and
> >         desc_push_tail() to continue recycling older pre-crash records
> >         while refusing to advance the tail past the pinned crash
> >         sequence number. Once the watermark is reached, prb_reserve(),
> >         prb_reserve_in_last(), and ftrace_dump_one() finalize the last
> >         record and stop reserving descriptors or consuming trace entries
> >         so the primary crash context and remaining trace buffer remain
> >         intact.
> > 
> > --- a/kernel/printk/printk_ringbuffer.c
> > +++ b/kernel/printk/printk_ringbuffer.c
> > @@ -377,6 +377,90 @@ static struct prb_data_block *to_block(struct prb_data_ring *data_ring,
> >  	return (void *)&data_ring->data[DATA_INDEX(data_ring, begin_lpos)];
> >  }
> >  
> > +static atomic64_t printk_panic_seq = ATOMIC64_INIT(U64_MAX);
> > +static bool printk_tail_frozen;
> > +static bool printk_tail_full;
> > +
> > +/**
> > + * printk_mark_panic_start - record the ring buffer sequence at crash start
> > + *
> > + * Pin the next reserved sequence number at the beginning of a top-level Oops,
> > + * fatal warning, or panic so subsequent tail freezing can recycle older
> > + * pre-crash records without overwriting the primary crash output.
> >
> > + * Context: Any context.
> > + * Return: true if this call newly pinned the crash start sequence from
> > + *         U64_MAX, false if a crash start sequence was already active.
> > + */
> > +bool printk_mark_panic_start(void)
> > +{
> > +	s64 panic_seq = atomic64_read(&printk_panic_seq);
> > +	u64 first_seq, next_seq;
> > +	bool pinned;
> > +
> > +	do {
> > +		first_seq = prb_first_valid_seq(prb);
> > +		if ((u64)panic_seq == U64_MAX) {
> > +			next_seq = prb_next_reserve_seq(prb);
> > +			pinned = true;
> > +		} else if ((u64)panic_seq < first_seq) {
> > +			next_seq = first_seq;
> > +			pinned = false;
> 
> What scenario does this handle, please?
> Why do we need to move the "pin" when there are concurrent callers?
> What happens when the original caller clears the pin and
> the other racy caller continues with panic()?
> 
> > +		} else {
> > +			return false;
> > +		}
> 
> 
> 
> 
> > +	} while (!atomic64_try_cmpxchg(&printk_panic_seq, &panic_seq, next_seq));
> 
> Are the atomic64 operations safe in NMI? I would expect that they use
> some locking.

To make it clear. I think that it is not safe on 32-bit system.
This is why we used 32-bit lpos values internally in the ring buffer.
Also we use struct latched_seq for "clear_seq" in the printk code.

> I am afraid that we might need another approach.
> 
> IMHO, it would be much easier when the caller knows whether it will
> panic() or not. And the panicing caller would just freeze buffer so
> that the next_seq will always stay there.

I know that your proposed design make the new API easier for use.
You just remember next_seq at the beginning of a potential panic()
message. And you freeze the buffer when you realized that it really
ended in panic(), ...

But the proposed changes in the printk_ringbuffer code look complicated.
They are not easy to review, definitely.

I feel that there must be an easier solution. For example,
desc_push_tail() reads the state of the tail_id descriptor
including the @seq number. It should be enough to compare it
with the pinned sequence number and return failure when
it is greater or equal.

One more variable might be set when the pinned sequence is reached.
And prb_reserve() might then always fail at the very beginning
when we could not make any more space reusable.

I am not sure why you touched so many other locations. I guess that
you wanted to allow saving short strings when they would fit
into the remaining free space. But I think that it is not worth
the complexity. This feature should be used with a big log buffer
so using few more bytes is negligible. And it might even be misleading
when we store some random short string later.

Best Regards,
Petr

