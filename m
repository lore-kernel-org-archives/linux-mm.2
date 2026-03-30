Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284B9FB3CEB
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BD9F6B0092; Mon, 30 Mar 2026 05:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794F86B0095; Mon, 30 Mar 2026 05:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB036B0098; Mon, 30 Mar 2026 05:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59C0B6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:59:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 023E114060E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:59:06 +0000 (UTC)
X-FDA: 84602281134.27.45578FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF2FD40009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:59:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMV2QD0E;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774864744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ol467QNmt0DQ6eYz8EW6+Q+7C35Qnp9U6TLS9yRvFHw=;
	b=vn9I5BPUbAxMM+dovXJGbiOkcoGWXnjUfIM53iZ6n1NYG0VVehFvNCCo/dLTNx/kzeW2D+
	ueu7JXAEd7lTVRYGwwkxBVWDRZWY9LikF945Nu9LxiZGFxDod7t0vF/uQIe3gMt523uA83
	B9E0wkznGPJbrc3xO8Ghilzj7W61pwY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GMV2QD0E;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774864744; a=rsa-sha256;
	cv=none;
	b=ok2vp3OxJNkmHJ1pXqMD23QboeDtxbUlQYZL9IgZDwf1ibJip4xKljyKqw1qZkHa62BYwD
	qQcFLim5M7d4h7lglLLFtGdOyfSUhjj/+Bkn/uxaBFIlmZ6cLVQkLB1pIHknEnvTf9wsD/
	XuOp0YbQGxaSbm5jcXipCsgdbdXCIbU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774864743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ol467QNmt0DQ6eYz8EW6+Q+7C35Qnp9U6TLS9yRvFHw=;
	b=GMV2QD0Ewz+qc29bVtGjyXFRPWRwqAoZSjkphzOnnUiS6dsNN9quaaudEINrSE4b70xyzP
	AYSHJ3rers0dnKNBLlPhl0eJOxO377Mz3p5Tv0PKi813Bw1SidFpFauj8abFHC/0cX+rMh
	bYESGmhPhEs/EdUE6AkANMUW7Ax6ae4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-qzkCFMcDO2ij3rlXAryOWQ-1; Mon, 30 Mar 2026 05:59:02 -0400
X-MC-Unique: qzkCFMcDO2ij3rlXAryOWQ-1
X-Mimecast-MFC-AGG-ID: qzkCFMcDO2ij3rlXAryOWQ_1774864742
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35daf3d3030so461354a91.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774864741; x=1775469541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ol467QNmt0DQ6eYz8EW6+Q+7C35Qnp9U6TLS9yRvFHw=;
        b=KJMSkxJAOW+iUWxPgmX2tc0+cwh/k+OXdEOUcx4iGq6SsTsdsk4z4ZbcZY5zdl+h41
         DKzfx7rfWb024tTTLDiSm6dkuqkYROuq/DLiL1GyJspwIE3gD4xAnyDbmOLxn0OzBsHu
         7MmRC0h/pCIh1LGAqWcUZZMJG2OJMlalaqZxHkeWzWxDa4VwGkIZ+y2MAHO/Ydnqs7lo
         6qVxwpKY5bzyXKkTgf6Akb8SFzYjKhriDxtB/lF/HaSLs18a6uqAVke6cJBeDgPZWVGX
         UsbSGGR5/jom5sPNrzMWAtk+qq4rW4gg/1sEj2vzf3bBKtc7SUP+kMaQqfte/C21WihJ
         kiuA==
X-Forwarded-Encrypted: i=1; AJvYcCVGuoLFTsNi6vRbFGtlntVsai2CVaRfS54FxOI3aDKs1peMZrQSGiWJRKl4DjhXwa4mm/T+8HfSdQ==@kvack.org
X-Gm-Message-State: AOJu0YyszsOmH1KnKawzFQIsvkRnhjpUlv2wQ7Jg8OhPKn/p78SsHD/j
	a3WvhsXt8I9fAY4NID9a5dcN057Lo6awGGS2a3p1wy3KSe18sq7AGA+XGYOpsMB4wsjijkglaZ1
	lXdnFDf4VlOmxBipdh0xNPrhJME1MysZUUSFNomD1rfjAjv4tWU1G
X-Gm-Gg: ATEYQzy+4/O++UWJ7zXADEjnelfZylH27snC/JxgDqTfLX0AxAhtwVkvtrRiPKrgsI0
	zTGKUPKxP8x4QADD2xVeLI75Q9LuXrXrHs4gmjk6B31/xy8weMKeYY3PzDeM3PqQXAS4NqCna3U
	5KHk83LHYFxeFvZprSyvXlo8zQkHBGYG5Z3q022tH5p5jLrH0IKb0SJjb7LKLxVWIfDuclU1fdr
	S5Wqtkl4p2GB9qL6CYvxGqPHKVkmis+PvGlYLjf0FaLGySaYaePM68/KWYfQYpzaqm6l2LaMNmq
	PH8bJKyiLO+IfBO+qZqOGLwytJfPYvHHxQmbqInqNW2DhntgxKFcdz0rodBTmQYDX0ppDAkihLz
	oW+Hii3Uu+/MP4EYizg==
X-Received: by 2002:a17:90a:2ca4:b0:35c:30a8:33a with SMTP id 98e67ed59e1d1-35c30a80a1amr6873860a91.12.1774864740119;
        Mon, 30 Mar 2026 02:59:00 -0700 (PDT)
X-Received: by 2002:a17:90a:2ca4:b0:35c:30a8:33a with SMTP id 98e67ed59e1d1-35c30a80a1amr6873768a91.12.1774864736640;
        Mon, 30 Mar 2026 02:58:56 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d908216ddsm3613964a91.5.2026.03.30.02.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:58:56 -0700 (PDT)
Date: Mon, 30 Mar 2026 17:58:53 +0800
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: aubaker@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-ID: <acpJXRokicaD5XC1@redhat.com>
References: <20260330053915.75442-1-liwang@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260330053915.75442-1-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oBAOX6dLrw91Ehi80aYJCg5nNLOr6lrurFAS7uMRQc4_1774864742
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: u5gdqjx8e5i6ym7gomoqhqsr9weh85ud
X-Rspamd-Queue-Id: AF2FD40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774864744-597821
X-HE-Meta: U2FsdGVkX18zFuUjlNz3Caa2QpGNn6hskhZD5AVtl3s8MNDCMI98czSvnMSmN0aUelezGBAa7GhEATwNplENIozTUWB2fXZXMmLHwsubs0/kcfzwLi+HCKqMB3gys+X/XC0B+jF16NMCPrMfRG5yKhrWXiZZzZ2BmnlAP/MbC0K2OtblL2aeDsAKoMzJAZJmxqYVRqA0/+6Nlp0Ia6HfRDMv6VwdpI7YXnUHTZiRz/dxwsqMWak+v0BTfqs5AMS0pjTJZKVheJ5pwR7SSsg9MDin+IaxN4nPjnxJRe6bPt5MsOIyW+fQthLfCW9zcVgFArHWgPKcLVEW026IfneZYY26HWNhWXTxX5uwv5lw3fV5fpweMg07XHA6bJnF4JvAzwOvuvtCKLkJJo0GSYL6jDeQ17a0kNsfsgJ+7200ZQMNqz31pH4zCOV1/ROCElB8yYtSHPXU+tgnEGnPczgWdS2OqPoqY7fIhL5fBRZJeiXieOEKoTrRgttaSo4r9enUBlimQBVSANFzX11jWj7fVzfNYHEXqIjQN35tJRgmWLm6dWtvFBdoZyQ73kCGM9t7L5T7EI5rY8hobwLA6XQYUXjVJRk6iMM0LJKV95S/Rx/NhkHtsILVzdJXScioR/Oh71I1odD42ee/OWW5Sk+cXGC+rVB+8Xy1XjcEWVo3LMT5jGLDbfeAPOBgNQH+c/BIMYZntC5dZui7kByIKNdhmyKliX/hYh5OBwzwxQTNDaKMyJMjxwSExHB3Y+/lE2igq84Lov2lqrGjCGHVMLgHgFs1xQ0GU0a/hGyGujMUAywrIcHF+pBkhcs3SN7WZL+ySt7AVilabFYSFkoMkpzGm58rCCYrn2JBzhyaS3794s28eQun8bXjlOz7opi+lV4Ru26hJOcE60CUWJP7Y/b4Lnxcfpe3X0z3ODDrFpy8yesbNc8qPYAIf/A3IZyTok4wcnXVbdCUGRgFUhEoSXx
 sErQ/6Qu
 FwloY74Tj1I3cXGvgcH42XnAr2DO3aYJ5xmw1q+T/J5hKBzzoTkXVwo6qW3a9e67gOZEpIBGi50doOCtA8bncVLYlM9OWL2SX9UC812MUdTU+o7QrB9p32VK9VRJGcF7CGZ7mHr6+V3vQCWzvZrvRE90+nocgDDT+xep7OnOeRvHw/oS4heCT90qxS8+MBrNO/tjq540u092/tzTqR0aQoIQqv4+HQI5c31Is+oMW8SFVQYXdMTjulK9Yts+9VEyapT6JPPKu82V0dGUklBqH5qGafzYJmUO0/Vy4vig2yKl+cn5rboRrvEP2uxY09dWHAXddyNWO2Hirp+nRiPFSGA9dR+X1ikutf32LkPbfsWBYGj9OFQBli0Pia3PiwwrYX+am
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Reply to Sashiko:

> +	if (start_off % dio_align != 0 || writesize % dio_align != 0) {
> +		ksft_test_result_skip("DIO alignment (%u) incompatible with "
> +				"buf offset %u and writesize %zu\n",
> +				dio_align, start_off, writesize);
> +		return;
> +	}

> Does start_off represent the memory buffer alignment rather than the file
> offset alignment?

> If it represents the memory buffer offset within the page-aligned hugepage,
> should it be validated against stx_dio_mem_align instead of
> stx_dio_offset_align?

Hmm, I don't believe this unless you give me strong evidence here!

After looking though Filesystems for handling the direct IO process, I just
found that Btrfs does the buffer-address alignment check but it uses the
dio_offset_align rather than dio_mem_align.

And, the check_direct_IO() does not actually distinguish between the two
alignments in its fast-path check. It applies dio_offset_align uniformly
to pos, length, and buffer address.

Also, I tried the reproducer on Btrfs, ext2/3/4, xfs, vfat, ntfs, all get
passed with this patch. So I'd keep the patch not check for dio_mem_align.

-- 
Regards,
Li Wang


