Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF83606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XYgL33LJ
Received: by kanga.kvack.org (Postfix)
	id CAEC36B0BDB; Fri, 23 Oct 2026 15:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FFD6B0BDC; Fri, 23 Oct 2026 15:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EA16B0BDD; Fri, 23 Oct 2026 15:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9161F6B0BDB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:51:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DBBA40208
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:51:28 +0000 (UTC)
X-FDA: 85354935456.17.EE06213
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37A4840009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:51:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XYgL33LJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajNcFZ5WussjgJU9fT6tDOCdCs4dRuGUCjNnd7n+pgg=;
	b=pvQfIgMBxyb0a8ldyZtgiCI0bc+BmVuNmXTxiTrxe+LI8a2z3Tfjr6LAhkesGV5F3AYjAU
	SXnKAW1uUlpwoar+B3be6cz7h/HKJu2Wt8lj0k1ZtedXojk2OLjiZEqTxtPU8O4bbxzdZU
	0GAA0DFR0DldJ3giGib43O9Gk/SudmA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XYgL33LJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.7 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785086;
	b=ZFzzeaNLvTAS/iZivHkAnUAD42QUaGy+txyuXuUx7TIoOWSZtr75q/VyujWQQUzXiqa7oY
	4w4iQ5YNhyYNsuoUyDv9Izy0IkczuZqcMdrcbcMOFzrd9x/cCx7EFEPYlsYD/kqB8GvXAv
	1LRQ54h+gTiucX99TjUkICavEKGN4hE=
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-368c26de2e0so357258eec.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792785085; x=1793389885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ajNcFZ5WussjgJU9fT6tDOCdCs4dRuGUCjNnd7n+pgg=;
        b=XYgL33LJMyiiRBM9FDjhMhJytdxRWV5dVUPZW2C32rM6FhGsddCY4NpLD5XVRx6SxK
         GcD+fyNIHuKoFhFvwCuTaRI7dw6qP2hM1CEEdy3bXIvKGpRN9kGx1pRm8F+tOT8uD+67
         jieG4fvFKBhmkPxxJ2v8pOUZ5u1UnDu1LP94ZGiAep3eNJ2w2otk0jM0kuMw2kU8z1Dr
         6PRc30SuifWGHT/CMaUDGnTzp4MTSTnJNYrswmcF8zSyzJsebcMNTcnPj4F+jozLLlEX
         sFmJYkoKfl/yZQe3QyFeKd7jVqHPNeMyuO62mQk8aY0TnKsMkVzxwVJ3HlO1BXsfgUE8
         mKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792785085; x=1793389885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ajNcFZ5WussjgJU9fT6tDOCdCs4dRuGUCjNnd7n+pgg=;
        b=ntx4QAnRaaHCEqFhwDwuZleDKA9gqE7dFsLogVCJyFZf3cfrfBuQQN3NT8r+3YiOGR
         e7mzxRztaukKOy2A8iib9DEPTJF6plYcpIwmJLTcrqJWjb4bXOKoiJJojGULT7R8xj8N
         /SgXUh6LxamTgtflTDcxaX1DsE9SJXYtpHSoNNxjl+vnS+VoI1d5JVCSVRoStUqs4lu4
         EvS7UWOwlTyfs6qA0UGfrRn0z2rn+3BfgqoRLsR5gWZbJl/UBrJWbpNI4W5FcI8D7w1Y
         pOdo6S0C9SaogWtPZ8SWbu1HeUeiAr8GRc08KT6FyLoc88JGFcNonsIZrM8s2311yO+9
         WzYQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4DHIGIfBbsAYK9xrFienrCz/sDn5zg6nXYEb3fJmHJJGWSnH7/2osuQFaBK1znH9Jy+Hnrt+T5g==@kvack.org
X-Gm-Message-State: AFq9FYJWkw0oZC7Aty2fG6MatEactnUhsstZTOAJftAsgbE2VsIWvvwB
	bZl5kEuIc2H5W8ckM0vWjM/tSUBFg+2AT4dHQQkDKzOnypgU+i5z0Lc=
X-Gm-Gg: AYBFou11zyM1LXCc093NEKytEAbJEaymRW+YIjwUKt+RbaRXoz7UhjcIr5K5gA3BF1O
	1eEqyt8CNgnyXBQrw+Mpoa/6gDcNn42HPKsQbMq/0wRWpYkPqN1PV6253ouTU26LBuo3GAiiItU
	YaY4DgbaN+TO5/RiUTL63GziCbn5kEYvkV7+j0fs0U9d4vdCVlTLSVMtFTpBHlyadsexUjP2EyI
	9V6g3NNU8oF4tbj+2nOMdHXweIRUKqBdWIBcjVyxP49kIc2BVQ4ksBaZse/zk/j7O+qBToAJnyD
	EI134ItguNPYwv840eWTuDNaeKdMT4okhomg0MY2hBEo4YM8II0RPqrxfPFftIgmmO1lYrwzuRz
	4wWxgJHxpg3nileqpd8N2kcnAbop895UL+pXLErccyB4UjcshUmcoLmyXU+gL823P6zUR+nu5fi
	CMiLjiZu6plMTq6aMhr0QEbNDP97nqs85mPb0R9vdl+xAc5iIb2FlSdJtouFnq6x7CbosE7iPg1
	zNcC5TqTolV/LyS8nOURPCc4iByEh37EMswYOd7XZWz0NkCeLBJ7ocjcBtDzc9s3etBJthA/OBk
	mBldqlMl4YrtNAYBI2+q/LBfJZJ53Nf9Cw==
X-Received: by 2002:a05:7300:50c5:b0:368:e6b5:35ad with SMTP id 5a478bee46e88-369e84dab92mr442217eec.12.1792785084531;
        Fri, 23 Oct 2026 12:51:24 -0700 (PDT)
Received: from localhost.localdomain ([137.201.204.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ee72c0sm420489eec.29.2026.10.23.12.51.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Oct 2026 12:51:23 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org
Cc: corbet@lwn.net,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Fri, 23 Oct 2026 12:51:22 -0700
Message-ID: <20261023195122.2481-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261022052913.90437-1-sj@kernel.org>
References: <20261017195747.89961-1-sj@kernel.org> <20261022041724.2712-1-ravis.opensrc@gmail.com> <20261022052913.90437-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37A4840009
X-Stat-Signature: n5ufhf5o33f37y9ce76xnsepe3o5n94j
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792785086-588152
X-HE-Meta: U2FsdGVkX18rQ8JjeiMBf0iBKhj0u2Ui0/PrZpj2Qu48ePyhT7sryhZpsRmyDtkB7FsBLsWUyXndyC7aPzJVLTAu5FiOYM93y1dS/Z5uOGI4KJxvD0dQPZzEDNkln1KbUWiFSbk+B6HHNWMhSdpUFNrRsEGSOJf7+iiBIhl5WlFrqMi7yYmEMgoZf9LAz1Ys900oShrkFCTQIL6gEnbuDzo8xArYnHXsgaZtIeTLE6TLR1iPfgFCpQsvLW7cW77JZE4IWJrxlUVJqMRNGfhSi5ZUcfrPoq+KJqkHQnlRS0wB6etBDvOHP+7bQG+6UM7CRKMjUsC1sgarIlWifgBwE3Fnnb3lGfvncMiK3UQz4H3dkpWt3yt0t5VhUabjFnQuHib9bZNFPhbVUnDJ+jI+yS7rAilYc2zOFnwMyomQJ6TK2jFaPwCb6PiHNqiRUlKcLClQiwmc7JuTLaJg9MgDPJT9bqJKhO0HZC/rran9FeGPqVCpYC6V14WcKdSelTGU8xpF/TpLOKe3zv0CFFVCe3bHT1FEd0V6917zq9mWvKcC8YEdwBqQA2XTuiOHvWZcNqpM97ztRLDnmg5m1x50sVZkLNCY0lO8HrcZQx9Is4JN9/QYe9OLOW6P/sEavRiZ8H+FaX+ogz2Nb4znIaSuH//iaOQskLnnDalTpjqR8h48HISVf9HxaVhoc6nBQ1f49LgjOHzlTIzNO6Zha8ykFFfpAGQzSITeKbA2IYcGj10amGs5jcRE0nbSuFga5OsLpyxUE1dO/w6+TBORuIsLCspyruPl72d06Lj7SeXJqe/AyHHo2fZqcS4utSRntP/CirVDi3Y26B7HWRAMuxy91cavc1J4SEZEvZSdJsSP8nwPAjFzkUnH9fjpmxxACtYALqvDhndc25uKBqhB5sz06FV7b4+UpF0LbFe7kg2ZJuU+GCdNaDIS/fDUIJOpH3Jwp2svOhAXGKTY3Dlxyg9
 MUW1JTB8
 FTF/Vj3q4TrqZkrzhkA5vUvFeFLeTPSUnSPPk7msttmnqhL3gd7X2cZz6++aNvQln16Khb4xrZivdgwWRWcWjluRzwNspiIEMl2/RoxVw7cZT166tjFw/5kW+xeJpt1LnYhkPMkzBFDanoHiemJOuvUbI3dOc6ECMiUwwEp0FyxahXhxgG9qOTCzniWgRM6eoppbyu/hPF/zBalOKHYawJyh2RpsPaLas7cRFvIVsW22IcXmRlDqubTPvQmlKYdf8rJm9lJH54/Ewyh5CJHvnBKSOy9xYX0cBrlfiYZrlOLCmLqwARtUGtgiLJyNPNM0K1mRL+ykNO0nnICBW6fGJuwfFOyrQob4h8MJnwu+WodSbT+Ts/dX/qO1oUCOhCEXuR9o0GQh1aT02/BR6z3eYkz26a7dCSZm0nP0sh9T4ZjrG27T1ON/ErHViSO6lYYfcelWh2Tb4IjNHo9TYQU1GjQHd14wvF8obx+QzkFMCnt/eFnntRZzQc5zdnshdk13VfcWQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Wed, 21 Oct 2026 22:29:12 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Ravi,
>
> On Wed, 21 Oct 2026 21:17:24 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
>
[...]
>
> Thank you for your detailed review and testing of the first design!  I'd still
> like to try decoding idea first, mainly for quick prototyping.

Sounds good.  Starting with decode makes sense, especially for VMs
where hardware address-sampling PMUs are often unavailable; some tips
for the prototype are in the other reply [1].

[...]
> > Yes, if the report has an address field with a validity bit and carries
> > the producing report-type (attr) id.  Then IBS, PEBS, Arm SPE (through
> > an adapter, since SPE uses the perf AUX buffer) and device-side
> > monitors all produce the same report, into the same queues and probes.
>
> Thank you for confirming.  And yes, I think we can add more (union) fields to
> the report structure.
>
> However, could you further clarify what are the validity bit and attr id, and
> why those are needed?  I'm still newbie to perf event, please bear in mind with
> me.

Neither is perf-specific:

- Validity bit (or union tag): a way to tell whether a report carries a
  virtual address, a physical address, or both.  For example, a decoded
  sample has no physical address if the page is not mapped.  If you use
  a union with a type field, that already covers it.

- Attr id: an id of the producer (report type) that made the report.  If
  several producers later feed one queue (e.g. perf sampling and a
  device-side monitor), a probe can filter on, or weigh, reports by
  their source.  If each queue only ever has one producer, the queue
  already identifies it, and the field is not needed.

[...]
> > 4. Binary search over a sorted region snapshot (your todo in
> >    kdamond_apply_access_report()) beats a linear walk from about 2
> >    reports per interval for 1,000 regions (a model, to be measured).
>
> Yes, this efficient region-report matching would be important.  We could also
> consider starting with linear walk and later optimize, though.

Agreed; starting with a linear walk for the prototype is fine, and once
it is out, happy to measure where binary search starts to matter.

[...]
> > 5. Samplers can stop silently: in a report on the v4 thread [1], IBS
[...]
> Unfortunately my understanding of perf event is not yet good enough to
> understand this in depth.  I will revisit this after starting implementation.

Sure.  The one part worth keeping in mind from the start: a sampler can
stop without any error, so a counter of reports received and dropped
helps tell "no accesses" from "no samples".

[...]
> >   - The queue: the per-CPU seqcount design in note 2 (suggested), or
> >     ftrace's ring buffer with one iterator per reader.
>
> My current plan is to use DAMON's original simple lockless and global queue per
> report queue.  Let me know if the report queue design is not clearly explaining
> what it would look like, or there is a clear problem.

A global queue is fine to start with, and the design is clear.  One
thing to keep in mind: perf writers run in interrupt or NMI context on
all CPUs at once, and an NMI can arrive in the middle of another write.
So reserving a slot needs to be lock-free, and a reader should not see
a half-written report.  If the design already covers that, there is
nothing to add.

[...]
> As soon as this design discussion is completed, I will start prototype
> implementation and share it as the next RFC version, as soon as possible.  Your
> review and test of the version will be super helpful.  I may also ask you some
> questions for perf event and your prototypes.  Thanks in advance for your help.
>
> There are competing works, though.  It would take time.  I expect about one
> month at minimum.  It might take longer; Thanksgiving holidays could be helpful
> to give me a time to concentrate.  Please bear in mind.  But once the initial
> prototype is implemented, I believe we could quickly iterate and meet the ETA
> (LSFMMBPF'27).

No rush on the timeline; that plan sounds good.  Please feel free to
ask any time, and I will be happy to share the test programs and review
and test the prototype when it is out.

Thanks,
Ravi

[1] https://lore.kernel.org/r/20261023194848.2449-1-ravis.opensrc@gmail.com

