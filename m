Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727D5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F1B6B0088; Fri,  8 Aug 2025 08:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFFB6B0089; Fri,  8 Aug 2025 08:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7B76B008C; Fri,  8 Aug 2025 08:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71A96B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:01:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D447156AE0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:01:45 +0000 (UTC)
X-FDA: 83753450970.19.1C5A29D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 45EBE20005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:01:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PWWl3cBh;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754654503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fuVWCm8/vxZTQSAECo7taLOMmR2PQdm996aX0i+uTig=;
	b=K7gcyMDtV2MesKBZX5xOVGHJ/f+hyfgHHslr43/quLTaeqAMvWj93xz+8Rat+Nb98/ldbO
	KwN34sYdUvSy3Pu0Nwjc6CosjuuuxNA3sX1n6ifEmX1Fo9ocHnjl9GzQbGdC1ABdc7/uav
	hPxGpaCDP8/dlFUIAvAxPpWNqhT4LkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754654503; a=rsa-sha256;
	cv=none;
	b=3BO+lSqpQBpV68xagWF/Nsg7ZEIehr3zNFuNDgXofDAFwyVnfzfTQ1khcSgtdYqIElou6A
	gkqACKnPxDDiYbUqdbgq6KdkcrD8RKCcWseFv7eGL/Cwx/p7AUaG8uijQfxX6DpndAHTXn
	N/hb+oRcCrctGrghAcdpNXuzh+whssA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PWWl3cBh;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754654502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fuVWCm8/vxZTQSAECo7taLOMmR2PQdm996aX0i+uTig=;
	b=PWWl3cBhZ6k4Ol5cueBKjS0+oHMWwUnZaTGs4kykWHD6ogXILZ7F5XllnXs5DPyPUQ39bd
	RlvZ2Xoz1+STx5zHn5jzDEuUrI/f0is3A+gyUUdFAdAjgoNNiV950pAt3m1H2E7I/kbESK
	DdmromZNqjjlPZh+1lIoDDAonEwD0iA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-kuBcnwWeMmGWnRjHZB0TVg-1; Fri, 08 Aug 2025 08:01:41 -0400
X-MC-Unique: kuBcnwWeMmGWnRjHZB0TVg-1
X-Mimecast-MFC-AGG-ID: kuBcnwWeMmGWnRjHZB0TVg_1754654500
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b8d612996cso1398706f8f.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 05:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754654500; x=1755259300;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fuVWCm8/vxZTQSAECo7taLOMmR2PQdm996aX0i+uTig=;
        b=GByVPAFcJ3Hgf7MbAo0J3O7IUvTSP5/fCQnvlvW32yg65kuWBzI/5sofZHDQC2KAKO
         HzmjJTZR9rlW1ZeSza3lO6Bsnq0QhnDDZaGwyfT4jBYI3AiZqpcPko4ajs2Z3kwpKCjU
         JobdSlvl/BPz0QN101ArUR9DwBfm4ITcMjR9nhAdc4mIyYeighJS0XqPiPy0IaOdlSkK
         gxnmgU5H8KIdJ8sL9wvZNWjyR9sNyisDcIyT/049uzB6yvQopSDbugAcGvHNyxXTfe7r
         Teq75xUvtku1NhF6ikAH9zksq9zc/C1ErBxU1e/v0LvCcuZPvAG0yyUeDSuZH/uFrGwn
         W4VQ==
X-Gm-Message-State: AOJu0YxQg78HEp/vICkgcDfTFYtllx2IWDx89QqbaqRk0RBUP1Awjaw9
	m/0pXAx9nRFRsOT9H5jQtywqnn6DtbuiirGm7T6JrL8+BXdy1gkIDjUz3HcewUzPbLf6hNakYPd
	5ma8c8Z+SJ6J9d3lXJx5EDlC6DiaohfdScd+zstCpEsW8+J//UGul
X-Gm-Gg: ASbGnctbqE45Vwid7QwohhVRv0VzW+wf6Ge+nEKTFMNH/NVyiS/R/BZwXaXRQX1l+a3
	1ee3y5Znxm1LpUQzGydaThPV2dYqPbiyAGk65N17DGUYijfEpxVJF+0VE60Buk3CQWYZCFuUt1M
	gOUEYWmVQs3cP1gvRQmjK6Lsj6ZQFlhHCSzeAgM5wMIHmA5y5Khd1SO1pwwoZkuRqnUyJRDfUnx
	v4oBsLTArkX4kiH0hGt8g9X0IHeP+n152ssFu4gMzqze5S9SDyYBKZjbJvdWjFPxTR4w25YTUVk
	IhtrK+1/6HAqY/ogB1w+ru4oZ1ElO03FgyR8Lw9JcTyb8Sgya4b9Idx/cVbN0VoOH1LUsijWqLC
	04gbniiECZ9meNfgvt27Kumqad538TLSGeIaLVVghHizlSPXGX4VJSmRoX6OMis8J
X-Received: by 2002:a05:6000:2c03:b0:3b7:8832:fde5 with SMTP id ffacd0b85a97d-3b900b4d7f2mr2289643f8f.13.1754654500134;
        Fri, 08 Aug 2025 05:01:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7Cof+uVTZkeDN8zA+fsn/xE0Kjasw/BoUL2hR61ythCO9HbSu9Wf87sSKgu3iIzkGoTT9vg==
X-Received: by 2002:a05:6000:2c03:b0:3b7:8832:fde5 with SMTP id ffacd0b85a97d-3b900b4d7f2mr2289505f8f.13.1754654498111;
        Fri, 08 Aug 2025 05:01:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e0bfc79fsm19755204f8f.56.2025.08.08.05.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 05:01:37 -0700 (PDT)
Message-ID: <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
Date: Fri, 8 Aug 2025 14:01:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250808092156.1918973-1-quic_charante@quicinc.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jo9MSx1fdgiB96doL3SdRT2g__LgI6mU76Fpp4AjcL4_1754654500
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 45EBE20005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: m19chk4k3t5bqh1yrhxww4x1jdpikms7
X-HE-Tag: 1754654503-674252
X-HE-Meta: U2FsdGVkX181yrTw2CHkte5Uof4cGtfiUR6LWX0rVye8KiJaY2CTHGuRIDzdkzZxUlXKi0B6wRP+vV6xO57Mp0P3fO++5r8zEfdZyVKoXAOhjpHLeJfYXzClgCg7X9mVoRKn3DLNNMNVR698prxtufYJpNLau/iYaEI/TeZHTN0T1N2tP27kodzM3Ns/cdoUfOD6E58lvGaw1NzFttTMvFG9LcNdKXwIO5YVoUBBSsvBaALGiwoGSCNWXnCVIvpZiU4Vb4v4KL0em118Oh5oxQ20POSo1URWmHGhplwyRD7tmaxscETwa9639fApBHRLNUORZhe27dDkUwhz4+/40LZM3IdKbqjtzlUX8xdWlonVuViQn/vzhqBGJTbkVX5frJeuV8ry/m6GCrENpzRKcF6+aIqLJism9FtZcZyhBJwniCdU50sE9iYCbvfHd9J5+fR6qLTRYX87ecHd7Rc5+aE7pCtti8g7+5YlUCe6pHr+rZOOjKF0rZvvLHXw20D2yElWS3SDrv1BAjhRd6I9lHW/aAMO8U4k/YmgLdEqD+l8dpdqwIkaRyrq8qeEijbn614M5wJsNieZDwJNnTeommrMW/ywCGfukasS3TKvdkUq2DN9OQ6AeA7P1vwl0YIwIMZYfV3bpE3xep2tP9e0mudy0TMo8Hmta20Fl2chSBVuWi47CpnEIL3cjY8YWfQ3BXZUtERrOKcYf4iJ7WCqrW0thVxYllfAFT7g0YIvBhHG85CvgH+pC1Y16cez3ZDTt7nzS20LYZyLhEBdIPbTqqjZ9WcIamUQnv86cnDVjJYKU9bmAvWNcU7xNlo5VkdMoH9RcevihAHQBp4ldaiZzytx5cf/+rItGG1vFBj3CXAGTjnX+xm7rCrj5DMB3rkOP8iYf9xFHTCSPemnjj9/kmDDtrt0bXtu612s8FZ/je0OQTNKomklUgQOkeZr4GAu3xAgE2HtkEIULhIwI/B
 zPnJw9Nk
 R086aCUAdXxeDAyfObx408Qgfv6g9nLyhWRForoD85gG03JAlRqWuoCrEprdTrX9clIVjepOPrkbc1dkjRUbbZnLEqeiYH1s7o2D+J08oQMCc7hpQ20Ul0MZNt/P486YJ0DCr8kNGOLEMXSo7RyASKTViOvCIkkXAK44tALRYpm95xx+KPkgC2eYgPzdX6rfItM6jgyBM8L3RW9xjoZI39uSNq2GSmnEm95Zf1Y53VwKLW0AWG1rmjTXxN4hDGmepJmqxtyyEpZPoE83Ec5I0/P80JWB45m2o1SBLtUlI7/xJgMcZSoyvMuqw1wtVmhCZaj6jVzGWBUm5GcwOzfatmWMM5docLaYOlGhw4ecr0zM8WT97YaI7oUes+6zMuhbmNK/sg3kuKZnE6tuM9OuwvJUY7ipezE37JuaXvMcFpyplSgZZvYV8LZQsRyQtbdYCrQd2ey0CxD34xK+5NR1sQZRda9MdSNiAPBBXz9kivDdSjJ769GOdT8nJ1vXh4sBWSMIGKWnkF5rK9Xg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 11:21, Charan Teja Kalla wrote:
> It is possible to hit a zero entry while traversing the vmas in
> unuse_mm(), called from the swapoff path. Not checking the zero entry
> can result into operating on it as vma which leads into oops.
> 
> The issue is manifested from the below race between the fork() on a
> process and swapoff:
> fork(dup_mmap())			swapoff(unuse_mm)
> ---------------                         -----------------
> 1) Identical mtree is built using
>     __mt_dup().
> 
> 2) copy_pte_range()-->
> 	copy_nonpresent_pte():
>         The dst mm is added into the
>      mmlist to be visible to the
>      swapoff operation.
> 
> 3) Fatal signal is sent to the parent
> process(which is the current during the
> fork) thus skip the duplication of the
> vmas and mark the vma range with
> XA_ZERO_ENTRY as a marker for this process
> that helps during exit_mmap().
> 
> 				     4) swapoff is tried on the
> 					'mm' added to the 'mmlist' as
> 					part of the 2.
> 
> 				     5) unuse_mm(), that iterates
> 					through the vma's of this 'mm'
> 					will hit the non-NULL zero entry
> 					and operating on this zero entry
> 					as a vma is resulting into the
> 					oops.
> 

That looks like something Liam or Lorenzo could help with reviewing.
I suspect a proper fix would be around not exposing this
partially-valid tree to others when droping the mmap lock ...

While we dup the mm, the new process MM is write-locked -- see
dup_mmap() -- and unuse_mm() will read-lock the mmap_lock. So
in that period everything is fine.

I guess the culprit is in dup_mmap() when we do on error:

	} else {

		/*
		 * The entire maple tree has already been duplicated. If the
		 * mmap duplication fails, mark the failure point with
		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
		 * stop releasing VMAs that have not been duplicated after this
		 * point.
		 */
		if (mpnt) {
			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
			mas_store(&vmi.mas, XA_ZERO_ENTRY);
			/* Avoid OOM iterating a broken tree */
			set_bit(MMF_OOM_SKIP, &mm->flags);
		}
		/*
		 * The mm_struct is going to exit, but the locks will be dropped
		 * first.  Set the mm_struct as unstable is advisable as it is
		 * not fully initialised.
		 */
		set_bit(MMF_UNSTABLE, &mm->flags);
	}

Shouldn't we just remove anything from the tree here that was not copied
immediately?

-- 
Cheers,

David / dhildenb


