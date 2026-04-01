Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC80010F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06196B0088; Wed,  1 Apr 2026 11:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCF66B008A; Wed,  1 Apr 2026 11:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3096B008C; Wed,  1 Apr 2026 11:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE7AE6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:23:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68DEA8C625
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:23:25 +0000 (UTC)
X-FDA: 84610355970.13.FB72DA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 24B464000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:23:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xy+ggk8X;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775057003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AS9sBE8MNzlgdJ7Owvs0YGGHjd+pXwcJRuuv+ZiN8LE=;
	b=qH9BzKVG7Hvdxyw+5DHodONwEUnfNx0vLoJbakKtcODYObsNwyo0VCxqx3GAH7SABO8UQ5
	koMPNNIrteDUTyXfXbBgQhhvadP+tAOxugNChiH79g1jVIMcZxkBYSgcRBwJ9eTmV6kdzf
	8XH4CvmaACM/HF3jRS233P7gknymgMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775057003; a=rsa-sha256;
	cv=none;
	b=1he+geddfdr9BrRqTqBt9nzh7IBeV6IVfLHwQFcdLVKnt7NJsuvPrQtz37jgweog3dcQpQ
	tA58wf7UTqWieGtWVFrj2FE6czg2M68Nlk+wUg014QN1nfmpi1SYMivFHpISVuKOO3QazG
	rl0n47Lia5fzYAC4QISRQ5EwlOGQoRo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xy+ggk8X;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775057002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AS9sBE8MNzlgdJ7Owvs0YGGHjd+pXwcJRuuv+ZiN8LE=;
	b=Xy+ggk8XalA8GicI6SyjtfbSnafV03ZJopH1gzkjMudGfVM6oqtpFJou9wiNQGNfztjWwe
	V4Npvo3FB0CHtrNXwehpfy15592QR5Vo/i3EATEfE8nh6mWCtQBme+P0C3CRljWc5s30ij
	H0YEZlzn06DcfRKilGgc+rcZZEnfN7k=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-s-QVMts0Ora-fBYgr61TFA-1; Wed, 01 Apr 2026 11:23:21 -0400
X-MC-Unique: s-QVMts0Ora-fBYgr61TFA-1
X-Mimecast-MFC-AGG-ID: s-QVMts0Ora-fBYgr61TFA_1775057001
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50b4fe4ff7bso33020371cf.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 08:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775057001; x=1775661801;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AS9sBE8MNzlgdJ7Owvs0YGGHjd+pXwcJRuuv+ZiN8LE=;
        b=IWdLIfERO/QG9EsgwhFrJC91VVK8e6zO0nTEtuufgn7pDUNcmZp5bQjz2P6h2bEn+e
         dXOPHV8iXz3zwbIm/5sz2t+DYOUPW5IzdMoj1wHjKOmSbOrj+jaPBNevyC9M1UDAM9rT
         ZBJRpRsAgt51jxAHMqCxIATC+LCB8kV2JSdalfmvtxbiWIYVqm3+ld06ib9PB5kcLret
         h3Nw2epGk7JuEdZUxQA/7F7apYMUlLojNoG68o2ffInsFP14jOz7vwqhdbksnZ0gAZ9n
         iLyWqluqcipOEfaS0e09fYuehHOTmvgnhilM8qSZEszbGC1w75jz/em3LzyxD19ojStL
         d4VQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSpDpSdJwYHYchPlbgd0XKcFiHm9XJ/LmzvydEj0OmMeNGcrKKVbWpjCGwIbnGHt1W3l9OOxBK9w==@kvack.org
X-Gm-Message-State: AOJu0YxG4BtIlHxo0opFTFsj4uGR+ZknG94O8953Zo6/3Jw1VfXtssSa
	ZCuSJeX89cpJkE7Gcq4GPK5vGtt3+ezuab+LUGXFPSl5WHVHTh2cdrCaESzUfl/Dr2p352JYvqy
	zKQEuRp6KWGtkeGzIXo5FsJIldgHFn93PgmjdMT1XLlkPzwEzrh1H
X-Gm-Gg: ATEYQzzGPoQwH1xK52Y1T3axtNcWecEUMwbQOEAcX5JCwwEqc/xSw/fgsaQLYCv0reu
	lVpmPKAZ1/QyOhffJYoaNvreZMU1Nz+bH5W3i+dTnlZQWjD8hQH28fbrduMpk51g68BPQ60f4ZE
	4QmVg+rsnvOyBJGmdhiP+4H7w+qz2iTqpJ4ZDuJU9FITn0320HDDR/cfjiLLorWLFtSVqoivuZV
	dsm9rOuP2EUfDdiK1WWWLFH6hNRLotbWt/6z9JsXf0n5Mt9ppEZj/G18a7Qs2prM7QNEEAo9pbj
	IzZX9vYOQaU+P2NLe56ghcNJJMvCU6oybrui4ZCEtea5KQtSje0QUGvKDOvKjuagyRlrhrouFdR
	5pp5H+WXCvsFphwavqJn4EIZgjCaWUFlFq82g8GhvVUEbcg==
X-Received: by 2002:ac8:5dcb:0:b0:509:5116:b433 with SMTP id d75a77b69052e-50d3c146b2fmr49400861cf.11.1775057000851;
        Wed, 01 Apr 2026 08:23:20 -0700 (PDT)
X-Received: by 2002:ac8:5dcb:0:b0:509:5116:b433 with SMTP id d75a77b69052e-50d3c146b2fmr49400251cf.11.1775057000209;
        Wed, 01 Apr 2026 08:23:20 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b1dcdaasm345181cf.9.2026.04.01.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 08:23:18 -0700 (PDT)
Date: Wed, 1 Apr 2026 11:23:17 -0400
From: Peter Xu <peterx@redhat.com>
To: David CARLIER <devnexen@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <ac04ZeFdz7yvByRp@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lDlPiFyZc6HqLsnYif5CpFiO9Qd5QzUjr1tBkzq9DNA_1775057001
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24B464000E
X-Stat-Signature: 7j76x1d3izx7ruou7t6gxnyia5gy36wo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775057002-747290
X-HE-Meta: U2FsdGVkX1/JTU3E+0EdGvdcc3rtz2Kyt4c36pYHIZGb/Ba78tvoi2ljv61JJ9xr/wb7SSa5H2he7tjuyfhTHGWwJE7ubWj2i5BX4fzE8+839w60kKpv4vjPcyJQwJxiplWvhclFPMs6x7zOkAAVgYDfNY/skZvUS389fN6WPOeERlv4GtZOEsK+np/E8FB/rAAdYqjGnxltZVWQkUq3BAPeV0KlMQ1lvUhx/++ek3Mk07t1NyaAEpyPTIRZSmc4ethumOecRyhWR0CxJIVNGNAX1Aae8+OzpMt2tQLl7ME3BuzyUuc1KG4jJ4FshLV1TBF9CsT9cdpVyQ09RaUgKiQFfxXfXDzhQuvqv8Br48PFdrAk1qjGgWJnAJd52XOhhHL1qZj5f1YtOtJffCJNK0jegtpjexHXBkCaBkzwdpQqoNVJfToZaaHj8oUZnDi0u7I8jfVpuN6wRSyQVxXBJH0oqVK3tDPCXmesxiZ18kMHYhCHMIH5XUtWJidTsp0kotdfmgU5R9RhGLliXv88T28jkaf8vhuNpE+kObrWGIwLpwuIe5mbeO2yvm3ebdUsIxEMKHO85nkGXewI0ctQfnn/FM/J8BK6WdaS/dKam1aNIuhxa8PPNgj3r8qpXjz+0/y5SSiUq8I7QdiyuCGbq9xyMkdEghCMpIN4Pslt409L619TN/BYPhW0eXAp+//fwjtm+56Px0Ozg0YoLp232+oBp/8X5nq7HPxwe11TNxds28GznX9af67oJO0X+JNtBvnvZFg6JQ530O00q0ETkEK21CQahXzkvsgCoWiNTUdFOP4L/T5o4dYt8zJgdDFuFnFrslYrDQQTzBTNcFpRLQdfLdzskpN8MhtXN8onLZsNR7zqpBJCJjo7JQWvcyJqQH3GClPlpHRk/iGXf8W1eIZdd0nlGFrR0W2j5I4nsV3onu73LX9TWenOVFWtvzn2vzIrU3xbCOjyOUKUXh7
 piQpMRI6
 znKsc5h1FhHUaBDQ3kjz3tECCXN2r5gddEyy8ImAhHxowS6XCUfsn3qGD9sHuc/OdpBh2e2KdeTqGiY2N25Ylr1qF+dKasGd2GTkoatEecnkoN8A3uo8WLuJiH6+FG69jjDAccIv1+mNwQ2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 09:06:36AM +0100, David CARLIER wrote:
>   The invariant I was going for: "the folio we allocated is still
>   compatible with the VMA we're about to install it into." Since
>   alloc_folio() allocates from the VMA's backing file (inode), checking
>   that vm_file is still the same after re-acquiring locks ensures the
>   folio matches the inode. The vm_flags comparison was a secondary guard
>   against permission/type changes during the window.
> 
>   That said, I can see the vma_snapshot abstraction is doing too much for
>   what's really needed. Would a simpler approach work better — just
>   saving vm_file (with get_file/fput) before the drop and comparing it
>   directly after re-acquiring? That makes the invariant explicit: "same
>   backing file means the folio is valid for this VMA."

IMHO the flags is needed, consider a shared shmem vma remapped to a private
shmem vma.  That needs to be covered in the fix.

Actually instead of reducing checks, maybe we also need to check the offset
of the mapping too, that is: vma->vm_pgoff can't change otherwise it may
also affect how the back store would behave on this UFFDIO_COPY request.

For that, see the example of shmem_get_pgoff_policy() where it seems we can
apply different policies to different ranges of the back store.

Thanks,

-- 
Peter Xu


