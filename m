Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CD6606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=uwUCamqD
Received: by kanga.kvack.org (Postfix)
	id E131E6B024A; Wed, 21 Oct 2026 11:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA026B024C; Wed, 21 Oct 2026 11:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27836B024D; Wed, 21 Oct 2026 11:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1D7F6B024A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:28:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49C42A051D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:28:08 +0000 (UTC)
X-FDA: 85347014256.18.E7DBD87
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C1FF12000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:28:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uwUCamqD;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792596486;
	b=RzDJgbfGLKEin6hPu1YoMvoX5+opg9XQc5kmlFujy5EhvmmURXLDc4AxQMhalsgdLP/9l2
	Gu954hl+IN6V0aPWGPiQK0x8tI4ouJ+aPxhPyWdNPSp/YXpj+tu9qq0wjXxDJKSv9pg5jk
	vRCeCci71+pv5zhuHw38tI4BOGC56z8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uwUCamqD;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792596486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7iM+yhWKMhlaRTv9Dtyn+iVYrKHxFutAHJMBB4EGzM=;
	b=q239yKpRb4bD+E4+hlg9fn3Tl2U95LMJoisOMq7RCxw7HAt6/kQScwURis8iWbqKsMVcI1
	Bso2rV+753kkviWE+yli/2o5KS203H/ZsS3tsLNAVs8nLsSDzSi9PuLdDUz++dS09swS2C
	5EECDiwGJ3z9hteYc97+FJ6JNV/lnC0=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91b813ac020so12111096d6.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792596485; x=1793201285; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J7iM+yhWKMhlaRTv9Dtyn+iVYrKHxFutAHJMBB4EGzM=;
        b=uwUCamqD2KrA6lYU2JNxBRVVn4Orf4UiLu+tdmcABSLo6KpzdsB959Y8U9laCFZGPG
         CalDHPiXWSoblxaaH654ccqL48+ikhvFsTJ9ueV0JRz5QkYF8ixpetHIRXfd72CODAg0
         rmejzCAc6hceDWUuqGLJRLguO9FWE/rnWdDRRvQ5vJAzwfpj+a/sJXdbtL6irVt45Vua
         G823d54IUJLeKWBsGKibH2h/0r5X8Ykzhugl1j4vBuyJHROnl8yIbGHiMJPg6UUutPcX
         dMKBxRdOZV25xdS1KvbKnZ7+r1dsXPjeh0CLBgqTkz24Q02r5yUi4aFRCtCE4kUxCSnU
         G9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596485; x=1793201285;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J7iM+yhWKMhlaRTv9Dtyn+iVYrKHxFutAHJMBB4EGzM=;
        b=l3Mo4GwP0BTj7I6I+/oAcw1/VM2hvOVPaPgK/sPofT4tL9fABfcuywl4zRZWkZ2t+G
         GjD4rOg5Ly/A7QNvNDTdIgKCTiVLWJE3m2UZVOFixOx5sp9sMc0wfyiaauqZph+Ky08z
         HeXF1bttP9dgRIEwPEXeeCX18Jbo6kuyJPzS5ngle9E0/NiVbwHZrCq8aRCj/aMql+C4
         4eJdisxdyhX02m2V/46NrJHQqi+v1YtImyhS5n7UEVtcY4hLlrj0VokMBhyivRMDTcxl
         g/nH2jkO7W9Fc+NM5NvyPAZZZxRaDoiPB7dyvhYa++Bm7jz+ztSyxXg1Ldg2Uml8cWTy
         fcPg==
X-Forwarded-Encrypted: i=1; AKwUvBwLv3Bb99Yvp964tKQdUugmBePdmMKla5S8vuSRDWVD44x9UelyOZFyy/yWd4xfHxYBX6CnjUo7yw==@kvack.org
X-Gm-Message-State: AFq9FYKmtK7kXGc2pzcP3PRkMjgasex0tr9Prc1n229gLjlb27a+wR4e
	VUrCXvVDUjk9o9wyMRBvKT85KLw9SQSLu/ZqtMQIEofcmrPOsDG/BRw6iliQOAa/5kI=
X-Gm-Gg: AYBFou03KQRRNJArukheQNfkT3FZIbgFHAJEAjqQofJzvltiOU7elPM4Qzb0X7DksJV
	vU6DNPTIdY4sIN/FYwlHRXyWtoSC8F5nbxnCp33TIIM6odbTM37yvvD2EMt3M3+er9qBLccilAv
	tmTdkCVSsfnETfYah+jy4Jp4NHfhl9zYWsLQqyULY4zbd+i5LRTumsa6DPBjstq8bYiw7WWdqbv
	8nB36MOa3x2tT8SffC3MFSMUJ+SGgt5UZBSfP/AgVQjux+4zpIuDSFY3LtR1pSBS8OYI7zZ/WU6
	PcoAb5MCrzCE8yblLrwgkTF0WuYNcQ9UoE5dyuwMdAwneWCkmfU7Ybb2UAdd0rG7+CfuKdt3TQ4
	sMUFFc0fQGSfoaJC+Flx3z0H8DHB11NZyI/nxi++46BBHIwBb7aWLGx9FBzp8Fg8qDr+u6mG/ex
	+XpeIQ9gBkQ8yaMeYad4PjLyRZygyxcvi+CFTPjdqz3QkNb74b0ARqERamLszcfE+ORb2SCPfp+
	VBjf2NARTKG+7Jo5UmZtg/ZxF/+lIztuTtKS1c0pc6OGohRpZscZAMkosJR6JUVX2VgcDpRW38B
	N2qZvEzjA80RxkQWKMa+npP245C6nLvShznZ
X-Received: by 2002:a05:6214:3a8c:b0:91b:d5d7:8c85 with SMTP id 6a1803df08f44-91c12eff3e3mr44319236d6.33.1792596485317;
        Wed, 21 Oct 2026 08:28:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c3b500sm27151986d6.35.2026.10.21.08.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:28:04 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:28:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	shr@devkernel.io, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page-writeback: avoid 32-bit overflow in dirty
 threshold shares
Message-ID: <atjZ6yadzSeqjozA@gourry-fedora-PF4VCD3F>
References: <20261021060654.27855-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021060654.27855-1-dennylin0707@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C1FF12000D
X-Stat-Signature: 3g86aa7my9wako75shya53itkfduor1i
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792596486-460843
X-HE-Meta: U2FsdGVkX1+Km2eJ4bSPh0W14jNp0qQtiqBMzFlDaOLT06Zl7bT/JZbGmuJlogmsl/krM3/HpqrFTTy3C3tT1mVg6rI487U46Wy3zPRYP9E+uKnj01tEqlj0e/NaW1IZ0tyTr26y80BaRz806fBDAoqMiQa7iiUa99+qQLtTtwIMLE8nky7nzVwicPnrzym4VxX6OLT3EpT+LP4EEZ2Y0D6qHUNv/kWrjtYELyhNhTAY4+5YicLDfT3Y4ZzKKmRPPUkYKQah1V5kGjcK7hHZOK1KvXaNTDWZJQ9CmW4SaHcxYMf+MDA3i50Vc/Hy6Nf2IjASXb3/W46lP6brQvgtmZkSmbxmWYQF7QjPmBJxt/hQsJ2o6LyBo51TfXNEKtxxAMuzzXbTh+4m+rfpaE6ZlVdODAf9jthJy8bSYFMM/xhaGYuPdOb3l48tQX+8sfV2qVGOaF2iVHU4FPpK+HiY2VYo/bqV+HhV3QYV+cAVSgK9QJvpWpnsBScA6vHAXAplc1ty0QRF/b7+ZNE6lIlb1+bJl30mXosWIudvrX3oHZAH2nVAHtsooQwKniAsVwFHAldhEGBcl1AS5jgetddIhNDW1i6CoHe3TZs0voUi39mRWk3GQW9AlkwqHNCQ5TMkb2KnYgOrKwqYvVyNK3qjACJ1RfbRDdN5SFKG9PPL8FjLlS0h4feGarPlOnYBGgUeoP2VNBzb5fWeq7q+lLIjtrB0oTtSTOlTIogeZJHuRe1HSS3U1DNWfF76dHShBZvzsDlZDtQUiDwKKRGFbjQ7rwC1UFwKq/NYMAOOd0+HuWSZ895GmypLSvkLi+kCUxF4OEg6udnxpiUx1sk2BqzLGa1cWTFHZ2kwPhizrlkXcLCrWP4KlpKwG2lxnltOep++VQ30Y4uT/7JXijT66xTW1SCp8MQ0VqKUKwfjVL66TjjlfEoURomFLP1vQbGs08RozGLA4J9J6HkqMBtZ62a
 2JdM+ruN
 alX2ugsqapbBJGFb1lSnQkCUaGzUePG+sJFCVRygWUX1zUbB5nh6wJVYIO+9llw24a7kB+zoz67zRtE0l40Fwo56CDWIygZOhZRjErQZC/0jGozHgBsdMWHaizi5RQKzei+x17pyw+wFyWPWTR+981JIRvKH+c0y7lrlU+z/iCzI0EBizaRUxXIM9zTPLngfmbN2CL1kAsYPToouAgjxNQ74xk4BCiiJd0jiIQLmv0G47idKLdYHMVB3FR/ob/+2PBcK4iU+Og5+Bc+n6enZstQ+CFSRq3aZIXlOZGPgL3glV3EmcHQHNKz0hSy6xjiKZr9uo8X2GDzr5J2aZI9fFSZEA6usirFRDE+J6XVHjwza9CaPLJJgmKiaCGykRYjdoqPoG8/PdLFUAeZK4kdY2woY1e48sCBtCIVCHP7p9PyYkxL1OLUSkLUg1JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 06:06:54AM +0000, Hungyu Lin wrote:
> The ratios used by __wb_calc_thresh() are scaled to parts per million,
> but the threshold and ratio operands are unsigned long. On 32-bit
> kernels, their multiplication can wrap before the result is assigned
> to u64.
> 
> For example, with a threshold of 25600 pages and the default maximum
> ratio of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.
> The shared threshold and minimum share calculations can overflow in
> the same way, producing incorrect per-writeback dirty limits.
> 
> Use a u64 threshold for the three ratio multiplications and div_u64()
> to retain the existing division order and rounding.
> 
> Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


