Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1165C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 23:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3026B007B; Tue, 11 Aug 2026 19:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164046B0088; Tue, 11 Aug 2026 19:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BCB6B008A; Tue, 11 Aug 2026 19:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8D5B6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:50:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 490D91C08F0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:50:18 +0000 (UTC)
X-FDA: 85090634916.17.0C5C745
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D28F140006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:50:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrcUSQbf;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786492216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUJlehNradj4bdcRGpoJrN6Nl2Yt17W/u3/rUGCliQc=;
	b=VCjNniLxJ1zHoANUQoulYJL4u9Nnr2EzwHTXpPp2iNpvXK3mfqQN2DRaoq1GClD0TGX2M8
	xEPoemlbWsULVIFwprWdQMxST4AuqkiXwQpCoF4D0DXiadl0eSNOsXBIazX0gBCIva+WnD
	Kg0AzEpgnTci0Xxo26Q5bL/qyZeNK6A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrcUSQbf;
	spf=pass (imf23.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786492216;
	b=zjCKwM0wwkKqe7koh3Pznx09bSCC6hRuXhPVEE6UFZJIFqiXaQ8paCL/53kzsGsovNt6BE
	JEu1tS1ayZH0ViKefhGRoG2yjCnTxmEaqS3/nmBQzafDKyEsVjIY+5W0zuLAsdyZe8eXYL
	1p7gdmhoy0bDmKKiindirNiypDcrqos=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efef6533aaso2803906d6.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786492215; x=1787097015; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JUJlehNradj4bdcRGpoJrN6Nl2Yt17W/u3/rUGCliQc=;
        b=JrcUSQbf5O9lOoFm9T7Tq6kpmUpY0S36CY1gOC3/sm6fPHgCpIuwVVaTL1stDMdqdF
         zYHxDf2pnC4bHAaWMaI5tIE0odzn9QgzczrZ0Kb7U0kl0e+2Wh5VoLcXsc8ErEffbpCd
         Ac7tsujvKHm22w64+Lga2LrulBxsXAhJxNW619jdOjKXThMaltLsOPpUHrZl0XLuhGiF
         pB85K05zHeG4f4GPxkL5QnCXjL6xJxRP1c1ME6p7goAh/UFEz1/d5ogCFJ83fhEUIGLQ
         I57J+0H1d33iipsEVocekhKSppfAA1VRDZPxpuLU4SddznGZuO3e+G1Jpf5l6Ycrd4+Y
         2e5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786492215; x=1787097015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JUJlehNradj4bdcRGpoJrN6Nl2Yt17W/u3/rUGCliQc=;
        b=HkSQC7uP+tOxvhZ78AeqSnJwmNUjs4Rl9sAJ42CxahzMpGWC3FgCIE/Ep5YDBe/sR5
         dH1GkOoUxF+bVmPrIgtqjheG1mmZCoyJP4rABXif2Y/ueI2wtzrgP3F1tzlSkqce6i0O
         GGC5vFlFSESh7/zc27OPqn6gjSY5ZLYxjBV04cmt64NzRWDgz3mMuE0QAUSkmYFla21a
         HCFnXgPNFaDObBXmJdO39S7qAuzaiKcGJZssh7QKgu+AoYMCSazAbwPDNsqvdPLStft8
         Zk4l/fJ6ktCTLiJAW7w2tTRUCPmSy+tMtMzFkjIY0hJ6y6APzhnmS3PmnDp6++IoP4Xh
         7F2A==
X-Forwarded-Encrypted: i=1; AHgh+RotGbZEV1uNIEyDUBMLXNlWsKirMTx9SVXKc4BB0oixTWQRjaaQHq84/S48qNPY7doy76gOJtsVdg==@kvack.org
X-Gm-Message-State: AOJu0Ywdglu0Nkg6rzaTdLDmkoDrouFrzbkr+jLafvp1lnwRQN8VEnAb
	Ah0j8KdNGRBqhCy8kO827MpDbD7XjXy+PhJYOLUa0VJOMi3EvbCyghYZ
X-Gm-Gg: AR+sD11pa5WF5R/I8qhZvUAdHWi16BUCTzQbjBagmM+PU3l9zPyz5Wrw35MKBqNAEm0
	XjDL3OrTrSdQ4viyMJGbkJ0b0mCfEw9igLSd62QnhsbIZLybjBtjXm0Q79w7+kjzJ3tPOsoOYe5
	DAi5csi2d5zgw9yfhJKA6DBOki7WunU2aDH6/jA/8Kfb0Je2JlAMfLo0bHgESjMioJwpM48Lk/K
	xGaFRGvEy22X3YhAxM8gja1eujJ4Bz+pVsX+GCPKzV8FCqv6x+r6mHRhDpsC7PLCuFYLmvCkEqE
	w+b8ngs27pcWIxYQz2IXl475UB3zxqWaVA5OoTujTp2Wc/cX67wmQnZUvjNL/ZNQ9xZLkrnSqAn
	vhouj+qQSWpaWMV/yOj6EhyibfqkdO9BvR82afKBrszZh68xYARfY0QHX7Qu8EWKi9us/G4JaoQ
	V5Gx/Tbr1nzBGNSoaTiIv8PoPDGECnhrw8CiRHLKJ/BcYOOkky+8sSPXZKMRoth0Vq
X-Received: by 2002:a05:6214:2607:b0:8f3:13e4:739d with SMTP id 6a1803df08f44-90a6ff67324mr8542036d6.7.1786492215512;
        Tue, 11 Aug 2026 16:50:15 -0700 (PDT)
Received: from skinsburskii ([38.69.194.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c299be7sm10134006d6.14.2026.08.11.16.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 16:50:14 -0700 (PDT)
Date: Tue, 11 Aug 2026 16:50:15 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <anu1N-DOnQwxO1kF@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
 <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D28F140006
X-Stat-Signature: zqfh9aymfh4qq964s7rgr5rzcn37gegx
X-Rspam-User: 
X-HE-Tag: 1786492216-433245
X-HE-Meta: U2FsdGVkX1+l1YiSK/haJhdXMWRzRe7Od5tYjyD3/xXA5GHKZvFEkP5DWhuwagyh+n7JPBGUdPpkDUjyLdKcWde1RrWzaFGjDka/UlAh91hgeFGvzBVcaeUbLVDKzbKcBTMj1asOOsYTLFOnmtv0TFPEpi/1B/8cThOO1drJbkFSTOVCxkN/y9ZTdNTp77/iXfbELNPltGcCrRq4LdCfrem859WTyMLIrcX0OJxKRd2rCwNWNapyv/WGhaG5LkDChTSQ5TN3lmrxFk2vZQq/kVVv0Yix0RvtnSlTRCdtxCliZFGtQPn/Z45HItvJ4KUwyWkbaFRChebiRFQZ2Th8gRxE1J0jyN611+E3M1w37ucgAFXFl3nAAQJ7iyA2q1e7kJXJ/NX59ClCD1Izdg1zoDuXRv6ZMEobFsmBGhZasrfXFqeaC2pG7eMDIoauIhBx7E5Lyko+8OL+lGKbTI0/MMFPJ2wJz0Sxb1EDRc5FSzlfvh3fZKtoNjBwlH/b1xWWgH4CZUypLJAdQVuK9jebcJ3K/SR1XOBmU5XvwbgKjGvg0IND5UFV/jvcGDiAfYa8mVMWNvxU3ZkPEO/fbt5DkuQw27nO4IkyqDVjOEp+jqd7axe+m+H2dWS7l7mwWu0vt9DwB/5lOy33ML9syNXsR4yaMVl6rfXygBXQt82bG6D7SC/m2Dn70hVji/GM/w1rx7GDE0UF3ZduH5v9TcjNwXmYZEGV7jGtdggwqmVWk2DX5MkH9mTyN85dsaa9lwYJbX1kgAWkvfXSu5y1f8Oi44+ESeLxJTGBh1uM+PcWjsATAIu/4JLrEUjvWgldSvsgvFfNcJ6EL7zpkoHIM0weFcPA8BpSnNjZw4GYtQMmpRYPQRTEhzkE4PogjTe059qkS/L5OM0yRej1SNIy+GxiIYOzn4zvt9pQrQhGdap25+M1S1crYAuk6UULbgBznx8ZqXdJybm5wr6pnJBP14V
 vl5Wm/U1
 aQU3oeFxPoanH+u3czv0DTyZdNGuzpVfimrsgC8OaqWJ0wmHHWEiXeZybwXRe3OQonqxJaX9enyxJYfVea2H1Qxv1jzABhe5Y2UPAbsZcHIjLDxfcrEyGpdHZgTMQTcSRgZuXk+KKa3Ga02gx3+wCinoM3n4ZjHojggMKOzQDxLDbfI9/dZsAFNe8HNa8c6V1leG1g18DdzC4lrwEZsArVNo94zYpGp594YNTDq9wQk165cGNDhSgzpl1NJSQMOQa/mmUgxgOKkOVJ/1JPf+GkxGSxJmRuL0cH7CJuo6DVoKzW1odfCkzgDunvqRUNEa+U1ICD0MCoxEnD/Ig7IHLCRfHoeThgr9X0nuCOO4xkMk8HVDcfW/w6g0uHhip28bhVKM9Kp30mn+mENrSU1NvDA1gW640JRULp+AstXuonZ8R4xnJDlJgfBZnYwY0VI2HkPV/FA1ucRLOTQdOeRqENg96Eg3TpmzuVaz4srogJkjVuhmsvdnvaYkgtGqLslLvM8AKI4f/p+978tYPeDlD8jSpB7QwCMyHvLWZ6Vx45gegpdNhmMR9VOoowmuju9d179Nq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 01:23:34PM -0700, Andrew Morton wrote:
> On Mon, 10 Aug 2026 10:44:13 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin
> > 
> > Unverified Warning (likely false positive, kindly check if interested):
> > 
> >     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> > 
> >     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> > 
> > Warning ids grouped by kconfigs:
> 
> Thanks.  I assume this warning was produced by sparse?  The report
> doesn't tell us this, and I suggest that it do so.
> 
> > recent_errors
> > `-- s390-randconfig-r071-20260809
> >     `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)
> 
> Caused by
> 
> 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> 
> 
> Stanislaw, you've previously said that this is a can't-happen, but boy
> I'm getting tired of seeing this warning report.  Would the below change
> hurt anything?  I can't immediately think of a cost-free way of doing
> this.
> 

I think this change doesn't do any harm.
Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
behavior?

Thanks,
Stanislav

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
> Date: Mon Aug 10 01:16:37 PM PDT 2026
> 
> mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Stanislav says this can't happen.  Waste a few cycles to make the warning
> go away.
> 
> Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
> Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/hmm.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
> +++ a/mm/hmm.c
> @@ -670,7 +670,8 @@ static int hmm_do_fault(struct mm_struct
>  		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>  
>  		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> -			*hmm_vma_walk->locked = false;
> +			if (hmm_vma_walk->locked)	/* needed by sparse */
> +				*hmm_vma_walk->locked = false;
>  			return HMM_FAULT_UNLOCKED;
>  		}
>  
> _
> 

