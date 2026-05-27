Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170F8CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C09A6B008A; Wed, 27 May 2026 03:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771526B008C; Wed, 27 May 2026 03:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687656B0092; Wed, 27 May 2026 03:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2A86B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:22:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BE331A0519
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:22:00 +0000 (UTC)
X-FDA: 84812355600.22.B9DFED6
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 444D016000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:21:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EvtlZTmq;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779866518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbeQ0cOV/xX8qRCoZ0tY0TlvEmEpG2Jpa9wLZjTTDgQ=;
	b=sr4yzVNqMbLzY3XAB0isaeWLSxxlHhSxNcQDShjgODuCF28rqrNrCL5XTzmvs7uN3Wbp2/
	hdW8xX2Rl6jjV0CJfAB/eQKhNxZQhxJWQD/CmLI2w2KkE+DleSf/WkPql/g15HTo5FNHYL
	k1rMqBcvi2pGra+xj08Munn/Yp38T8U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EvtlZTmq;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779866518; a=rsa-sha256;
	cv=none;
	b=BEF9gjR7UJhk6lMjs4xMahFmOzcHw8jAchPoRIEizCJ++io054vRfHBGpd/zFXi2SJXiUF
	JitofQdQ5FkwbXM19dHpkQt8wx7S1Wz9siBN7q0auE37IThsstXb56bbcPQLRbF2Vi/A99
	sHA9qEIvj2/aw11Zty8xr2SM9Zjy21s=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-841882f8f4bso1465513b3a.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 00:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779866517; x=1780471317; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SbeQ0cOV/xX8qRCoZ0tY0TlvEmEpG2Jpa9wLZjTTDgQ=;
        b=EvtlZTmqZRxiLm/XsbeUbEO01UVqndClUsdtCk5kwqrjs7R9I0rBxH9Qtwb4DqYpu8
         RF1n1njwWpwxbC7j08ZjREkZn2AuazfErAjRNTit6KVu/CQMLguPZN29DvWMM8EYkUqt
         TcKu3xZ2MHVF3r9YhsfUNItTfbjCy6Lg2yO+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779866517; x=1780471317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SbeQ0cOV/xX8qRCoZ0tY0TlvEmEpG2Jpa9wLZjTTDgQ=;
        b=J0N6HbF+8DtiVYPQGUjRjGq+E+dFqmq2Vf6ygUScG3PCTRryauplnBOhrMkst5912t
         eixbHxfVKppSCFMWxpSL0Gkbs3e9N788TrrmZ3ZGmxjKUybIwJ84PnVjNTn8m9aamSg0
         1fs12t6l56UusBmwshkjeWQBWvwQuU2RzjSAyr/ckjH0NEn3QHCjnqUCzeSYRE86nErq
         BE3zN/aIhzGfsU1A2b+B3SxajV8CMWA7jsueOTI0AshfE+0bX32uHJ05KYei5ZG6U1Jw
         YrodujcevdaA7vX91tVJlXnIQcwlZxGuvOmKX99j0p/w7alnkF10SO6AcxkDgfm9AOl1
         Nf+Q==
X-Forwarded-Encrypted: i=1; AFNElJ88pnEp1lxrJ/71PComIMn9fHO+XZg0kO/kJfF5KxYuro86257valm4netJMCp1HnB5g1Ayo85Owg==@kvack.org
X-Gm-Message-State: AOJu0Yz1VPSg6dfeb7RqglEtifd0OvU1wY6XSisljOvB460d/4LqmkPb
	0uB5t2CWIZq52YE67Y4OYcp/hbVVo9+qFl8cD5mCo/j+iLnGVkoPBNGxtykN+guESg==
X-Gm-Gg: Acq92OGPQFO0UWaonA66h2GbeJV3texajSm2oPC2UjGY8D9yH0SPIVlCDWtfrnUKyTW
	v+pxFXq4TzD9lxiHUBL2GkM8zJZr/+n0yqEy1mssj+SL4UJ8+Z8ANyTh/9BVtXSZORMRLJHGn1F
	zUHfcGeSdhep5fQbHK1fRPu6WrWGWMiWe/VZxD3nMF7hfcEo8n6HIAIPL5A/YLfTjqhMkccy98F
	GK/OB5A5ZUKpKd0hm4Xx6y3Y6sF+Rb1CQwMH1aeaQtqOL9T97dIa8szf065e1RFxW2rZFv/bl6i
	L01P1ueJyHRNn1lsYsdpMi9iGJl06BxFmLWq0Bmzl6lBepIYOBGaFpXjJLnKB+6N2IT54EpWE3K
	14x6xhW3WNdpYC8xClwHBa3Cwt7V0Yygn6qGXueNlTDAui78VnMT4SBnqqEdDVt+JGTHTT21OHn
	Y0tcqxDv0TcisearKKO4UPaZobGlPpL7IeEH/MG6xXA4EchIR7EwVEk7V2OsLo/Sk=
X-Received: by 2002:a05:6a00:a383:b0:82f:21ee:270e with SMTP id d2e1a72fcca58-8415f6d0bb4mr21703648b3a.42.1779866517012;
        Wed, 27 May 2026 00:21:57 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:140f:40ed:a6bd:f680])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70bf92asm1369996b3a.31.2026.05.27.00.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 00:21:56 -0700 (PDT)
Date: Wed, 27 May 2026 16:21:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] zram: fix UAF in zram_bvec_write_partial() and
 drop dead bio plumbing
Message-ID: <ahabSU6QcGJ4T4ZP@google.com>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
X-Stat-Signature: jnhm144btnkdupp6up85hmp9dqdnaxsa
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 444D016000B
X-HE-Tag: 1779866518-688737
X-HE-Meta: U2FsdGVkX186CUV03pmG7LQNON8WY8iX6GpAnPTvjK4rJu1CeWEXhBuIC0SqQZpRiwSdINm1PK0/aYYQfK3fC6VfvbQiAXmlJ6M4u4xLjPcvnoCyslIm73oO4pkC5KHZ9AdZJSNtc7x0jaCyZZ2z4KEj1SM5QgQ98toQgzMzOBLvSqqvSxn8R8f6pUMFhcUSfwLOcMvzgB7r3dLhGFeSCsbS+dYdgnOyZN2gnoSl4Seno8qUHfwxFEoH37B9jSAnXgvyLavHedg/6bQjl62cuJsg9WaAd7KaxfMwuzdDfDe3vkkOi3iRnKIIt8oV2FSxJGNEhTESoCZlf2Le0iLd6KrKMzKHVRRX+YX8Y/iTk/ZJdBzfJBqx+pI0v3V3SXSC3Iw3NgbHqy/ZvGop81BeI/sbkmrltNxrpLsw0bIiXgVAcCImEcvaYz7vaj8p1dHJxI5EpdSX/Zfzr4dWhHzT7VGzpB4u/QoOpprTViMvPXC7v1N/Mu+gBFYnOO8/K8rweXOrG8TYaj/lciC6sj2z7rHHlJ8kSfax8KCs51FlRA9Ic6YSapLNodbMtaadvcBX0zWziYRnSF53sNPdmNYuLMkNw9d1QtvplGwTUH1kXwi8DIQy4wPOAPz/r2VF57S0VorC1w+3EDVhyn7m8zBA4U4ne5MO552oBlBqG1eRvDKNGY5YP5eAtO/1v2eFVPkqdPr8s0EOoeTUfDDg8lZy5NTaCZxx+DsuYDq3fd8x9mSybbrFPKmWMKmdCtfzTQOdh9nWs+QRQJspRs+EVCQ1+ABs8W29DNJ2txsL1tB+WLNq+anP+jBpTOgQ9DbJnwVT8HCe5QtKj4TkKoPUh7ekqMnGz1BFOjiHjTuFWoI4m+4yv6iYRyU6kxfp8BDPwbv33sOE243DMIKycJbz/v+/yozrVAwXOdlvJ26r6uqS/hE2FZCd+hoja241iLcJobTEtX6qC20No21cl1piI96
 Q4r2uHI2
 k0WiEblzLn/XxAcKv/cOEFFVvkk0gNG3PSQSpv+MVCZwkx7InUfbDEKFG3jHZ9Yn/3tNUqjU+IPYjE3fOuvHvVhg5Rpuf/kAZd/u+XmEzgCsKS4J7jtpKpG6BOgRotKW3AY2TOefauaNEF3rXaW9GW4bi0omuaIg37CUxfBnpPfzDuoYh0niHm2Mxw8yvoleTCMh5Zh9dSYmy+fFJAQlQ5f4UTpwwOF2oNoYn7gAGN1DmBtKFklS14U+pAypqa1xduTIdrQPAJpRiZQCpEqjhDGo/wl2SkqbbSP6tAjVLPA6+tYX9wABSx17ii6FpdMLmlEH/l34ZjbMOhzQh0ZIDiMXRz9jsB+U65v/tWOEVHmF87ZRo/djao+kRYNOUJOM5r9gEu1t8XFclNZ3QZav2dGyD47JgP14/+SuxzoWRJHTX+I9fhkvj4eTu8Pm/j3qJYsphs1vP1CKu+rUoz+hX2+w8sUr989w5xM/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/27 12:49), Cunlong Li wrote:
> Patch 1 fixes a use-after-free in zram_bvec_write_partial() that
> happens on PAGE_SIZE > 4K configurations when a partial write hits a
> ZRAM_WB slot.
> 
> Patch 2 is a follow-up cleanup that drops the now-unused bio parameter
> from zram_bvec_write_partial() and zram_bvec_write(), no functional
> change.

Did you test it?

Looks reasonable (unless I'm missing something):
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

