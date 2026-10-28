Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70824606A338
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=QdFlOb1v
Received: by kanga.kvack.org (Postfix)
	id 0269F6B05B8; Wed, 28 Oct 2026 16:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1FF6B05B9; Wed, 28 Oct 2026 16:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B9F6B05BA; Wed, 28 Oct 2026 16:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A611E6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:37:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37D8C1A01D5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:11 +0000 (UTC)
X-FDA: 85373194662.24.7FB3368
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F68E1C0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:37:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QdFlOb1v;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793219829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOkZMWndE8pvmQEZjLf6QfLtdr6Oc875cvI2O5RWo1A=;
	b=urnqmVDlsFi2hmzU08oFBHUyq9J7vl8pbgWdSBZyvqZ3pq3tIP7QUVJiEF4XKOHMUUWPHj
	vlziB4ToHetr965Ebu6CLEL0iQCQM1AUmcpr/jZZNtUa+mLTE9uPIiBNiJi7rotetIaEDW
	2DWOgM2LQ9X/O9Pj6WkTemRfN36GXhE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QdFlOb1v;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793219829;
	b=F+6eMEbCbgcJLXhzI+uVsCeZdjSkraPpqXM/Mx4iAnYiCpyiWD7RTLcEVQg8gRgUIC9sZK
	5mVm4d61PTSvZxuHoI32XNBEkwJ9RaFgxL38GC+yvK0jciEB2k7uGGBvTyBwTk7rThSwIA
	umN8CMC8b05gRoK56YgTeLG9Xb5hFbY=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eaefe5b523so1189608e0c.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793219828; x=1793824628; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GOkZMWndE8pvmQEZjLf6QfLtdr6Oc875cvI2O5RWo1A=;
        b=QdFlOb1vvzmaYlwNiWe0V4T2/o16SUiKu2Z20WRix80NgirW9DLex876G0WOQD43cM
         NBvIWK9LqFNKbXUFmRHFSKFUHuyq2QvCraQ0f2M6YHhUhsKFr8rmXOrYDKBxfG2e6EiB
         T99LtD22KqBDGXDQw0cve/pKwoPuk2mkwpvnmdjm3fWtt1HzPR60wG/Uw8J79EPcreX7
         2TAZzJWtn5R2g+NJ81v2ixKtCysVf48uC61mY6g84QZP91Q4d9TdvJKOvxpCy6onre2w
         DQ0qW1+k2jwIhDHaFQSNc67HM/5RKkuK9RDSGq7pV3b7Z4VOlkTWrja5q9ChNtcJ35Rg
         ACGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793219828; x=1793824628;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GOkZMWndE8pvmQEZjLf6QfLtdr6Oc875cvI2O5RWo1A=;
        b=VyuiWbb6m62yvZpn1iDDRD+TAMjFiNQsgN6u/Uzgh37XxSVSjmKY29zu8wZwY2PgHt
         8yHPOdGL6nTK1Mn6GVPfNLmQ3Sa8/H1hFJ8Nh0RBFlNmSq4ms42WfCKb1lFfwKBrEjxx
         YzbhTLzMbmxR1ErQbrX1KFZdwB7asiYzDWZ2gYIifMxNBrHt0hiSt2rNZPPOFyaVOruW
         tSNZq88MvUBkeNwd9XfvMyAEE6uK855m5VKDE/JbFHPnbF3db2V8GTccnJ6GSdYW/sCi
         67CgHFPIcP63EiyHfefbM+qRRIc3F07MVPS2rUn7IEex2nBcwMIvF/f0NRITqV8KMpqr
         UDLg==
X-Forwarded-Encrypted: i=1; AKwUvByoTnNy0sC84W2yXHyvWDTqAEZ7vU1ckpclaBm8loEL4wnLp9TJq5C7blUAIQA47bpUnB2p+D2aOA==@kvack.org
X-Gm-Message-State: AFq9FYLJOpWSq1kTEhBCBy5LVfn4X838c9LGa0/oJCqNjKj7068BpV5V
	ed7pIVpcJT6laore8rr+GTJvjGs8tAlAL8StX4A36z4dZcP7xMKDHcuXBTGVoZfgt2I=
X-Gm-Gg: AYBFou3dK6WLCCrYaI7OR1Z61vgDyMgPkJn4EqdMPPr0b3jE7C2Mm2j235BTzV9cj8N
	x7t8jt4zKnjFzQTcjcGDRJ47HcLI4zhh3KWXriDG5wUiBYghJe3THqyOwf2Eebi7STgVnCkOmS2
	mDU1jCDAF5X//cr5hPoWSU0u0HjTCrsCy/FeDRDp/td4SIIfeSpAFKorYZiyc2knFMMQsoWxPb2
	GE1MmWwuHOrF6Ept+km2Qao5xG7yGqAIyJFUOLLd7wqEEuGUZm4UZOTJZY8tb0lzyyZaqA2gwmq
	ASKbsZdeIPugtaZ037yPSmYw0ScdlfjnEC6iCiT+ivAVMN5qjL3GXOy4zTgAneBqe45W+7Z3/6s
	XURk460lZhlVOCRpD5f4Bex+QQxHNBve9W92UPmegbFa6FCLhKbH7GR/G72KWt4mMRwTu4Bv+yt
	44sT+jjVuvBWWTSubtFZZDa7QJBxp+DDD6FQUYgg0M6P6lXgtsW+DaMPIHKMTfmkYVqqPTGgI1n
	Ky9d6h/+WplOJoM+R6BjqBPaMQma8OyYeuYe4VnFFAuRQ9+9AJLGsvwbvs/92xhStY3ChaGo6M7
	dg4pz6oNrZlBo1+8voLz2kw2zWa6+ikqcxB+QaF1uRCRxUKgIotvJGy5gLQ/ThLq+wRpJLG4cWD
	L+JcfCtKB3Mjv27nhJJ81duJnH5AXKfPwreb/SeatUMPp
X-Received: by 2002:a05:6122:e146:b0:5ea:aedd:6087 with SMTP id 71dfb90a1353d-5ec4cc275f7mr2103697e0c.4.1793219828216;
        Wed, 28 Oct 2026 13:37:08 -0700 (PDT)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f931911sm3001789e0c.10.2026.10.28.13.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:37:07 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/10] mm/shmem_luo: Don't make early retrieve
 failures permanent
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
In-Reply-To: <20261022225035.377445-7-dmatlack@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-7-dmatlack@google.com>
Date: Wed, 28 Oct 2026 16:36:59 -0400
Message-Id: <179321981903.1894369.10174219200491856665.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3851;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=tG1lwbJH2imddc9/EkdAvCrAH3EsxAEhBkg3bvhE7pU=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq4lzu/Ke5JngGl45TFenDqO7sG2rxu1esqb+GP
 W9djlMo20SJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauJc7gAKCRC7dyhM23N6
 3iaED/9+Ua/XelfQOiEDcPhs+IpN2Oer+RtBy5oWFs3Ld85ncxpkokj4M4S+zrCda7T6eqJ99qt
 WLFndguG8lw6lCfX6vMRTCE9OvLMPJBZgk++IOWd8vMSMo6sJuHC2aIVh3oiJGQbplm8A1pHtUd
 vK6/sqWNP+mqdoADa7IlEmu7uydtPZQ6gVUtj2oUDU/YZzfGVeoNe5EpResTvkYk6Vdp1neLYfh
 lGFsCCrjbH7TCtTThMrEBPQ4JJlJ1/OFqdkCwFpq+cdyUtErBGUGLeK2rxFf07U8U/ydQn4SZUM
 WENbDKA0F1DjRR8/sx7kedrfcj9vWP2vd3hFY+cEsyTLawSybRQS3QTUa+gEJtOXZPjHosBrYLV
 SgvOrjrbhjAv0oaxXMYRWWKgn64IPRbOdPvQ4F/QszjMPjkReBEjjmQFtsspuKgQddk58EUwpqT
 4ngiCEIpWUObRZBvgLFJYKOfdLl0q15dVVsk2n07fF0Neb1UD5cKlw/weF8lT3q6GuTXbsMyJum
 A4XQ+dpSI5XTmQAxL/tylp3fhJLTkVqQo9jG9GkfeVltDyl5rgMWOELBqk40kb4LfCQGwzLL4Hl
 lFLQ2ewQ3dOcxeCNM8ZEEzGZDPFihhVjKt13uUjJSoCIYziR5ctZUkisBrVjd+w69E7fYLFUC0e
 eLmLu3ergMn5ALQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 2F68E1C0009
X-Stat-Signature: dxxxaxr43cugewo9jhqii9ebcqyzn748
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793219829-698315
X-HE-Meta: U2FsdGVkX19Q+VZgovWFgORx4K6qZzR7uPv0cjFKsT+661UbaCLocIHOPtksIJAWvZnLhFu0DqqqKnJFkKOjR7nCL2LbDc83v4V5NfWPylvw2dRV/xYB3ZFHd7GTl2vhHtdjktSwiUdCwOYbjZZD/r8hFE4s3o+XCJNfitnBSMQdYCgSYV9LZBQ5IvhLu5WDIIlNddAVpU2ZB+frOuOJW5SAa9vjNO5VaK45LD4lzv9DDvaXnSF3eDCWDH21dAseGdNN3MzEB0fqzkEu+6dufz20Qk20bAqKe/eMi+QM0Zul60pbttpWpJLoN+JzT8rnDsKf/vNLggL7qfVAka0Pi/UsOd/NOlpOGLaT18ZoGA8EeeGaFd+nQ0G/9YqFCtHobacd1E7hU9MUKtSj3AQgBXsWAkJ7KO5JycqsW6bYWRdAYPPoHwOAw4aYq+FPY3YP4VJUmJgCYs8qBF9m5pTspFrebSVNuOdjFt99kDa1k+SzuHbgnZWnKZBOopieueLTOiUlcW1MwH4UHkpsWFBLEFGLhH4Cdq4Q4EyuVKwNE8n5OAgwPjYyTsXk4QuSOdsnocsqOe2gB/G4DwcV3W4exV6EmjrGNiLthOSpXDtBRpFouxnRdJlKCEHiLc4L+g3lC9n02wArMCilNLk47bGzI2CTc9iS6dsU4PBEDUO0Bey15GHcqpbkIvOA8r4LKzoxCI3RkmXNSzPvYWHLMt2BMn/fTUcjDTznsyMXExi7GFWFZqomx2ZU7PfVVNTDW0KCtYgNaAn3RFo+75LOY+AZa3ltm1C9Iz2qMmcH9E5h5tO6sbPhmSkXoXR2Rop5BZeJofE6l78zV1vGsNwy75CKgM+b2u83EChjpn6DDPPnD5B0wE/92VCh21Rq/H3G4Op9kWNGCrt9C7kxQeF2rFgXKrIKkX7ZKVvdaJA9qxIWliBEVSivuC5za8c0OeYu/s7gOl1UrnZoNVfWGH5kHGt
 T0fu27Fk
 rjmcaGtf21q3IazYpgZkZUEVpPflGKj146eGxmwfRKf+kiHhGopk+eSWtJdF/fx4HjadU3ARlifKx7eDBOmhRsLo3yU7cHllmWYv2TiTvVSrKqiZCXp37HoA09IAQS3ppOYCogr5KKzul1POvgvIr2cdFlBcCyg1b9htEoWczTJpHABQvxkiWFGzarrVsWXHwJ8y7MgI9fFmjtq/2DnDF+LJ/kJvf1nb3WYMoaxhyiT1LbHE6F8lCeE8wCXr6zgosfjGyqmDxDsxYthqkuFzjJzQsDTbpQAHMKr3MQearCh2QU4L+rQbLMf9ZguEvToMnHtOO7uX2aa+qAoxgbpNpPsqGZRnoVhu6KrMXDoAQ2FYQQTa+VX/z5gtO4GUuU9s9RBT21TTXPRdxmtY+mnAnVTNcWRtm3GLD4UqrzBt3ycCFI7Dk8K4OhS7IxsZQ5ysPgQToUWXCCz1dJ1OxhQnWYxd6tDShrexn/xb5xuXV3zulhy4u6NFIJlrvBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> If shmem_luo_retrieve() fails before it starts restoring the folios,
> mark the failure as retryable and return the error without freeing the
> serialized state. Nothing has consumed the preserved state at that
> point, so the retrieve can be tried again. If no retrieve succeeds,
> finish() frees the preserved folios, like it does for a file that was
> never retrieved.
> 
> This fixes leaking the preserved folios when one of these early steps
> fails, e.g. because the file has seals that this kernel doesn't support.
> The retrieve freed the serialized state but not the folios, and finish()
> then skipped the file because its retrieve had failed.

You should also note that args->retryable was introduced in this 
series, so there is no fixup required for this since this was 
previously not possible.

> Assisted-by: LLM
> Signed-off-by: David Matlack <dmatlack@google.com>
> Link: https://patch.msgid.link/20261022225035.377445-7-dmatlack@google.com
>
> diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
> index b8d86055912d..bcac1bbb3db3 100644
> --- a/mm/shmem_luo.c
> +++ b/mm/shmem_luo.c
> @@ -390,9 +390,9 @@ static void shmem_luo_finish(struct liveupdate_file_op_args *args)
>  	struct shmem_luo_ser *ser;
>  
>  	/*
> -	 * If retrieve was successful, nothing to do. If it failed, retrieve()
> -	 * already cleaned up everything it could. So nothing to do there
> -	 * either. Only need to clean up when retrieve was not called.
> +	 * If retrieve was successful, nothing to do. If it failed permanently,
> +	 * retrieve() already cleaned up everything it could. So nothing to do
> +	 * there either. Only need to clean up when the file was not retrieved.
>  	 */
>  	if (args->retrieve_status)
>  		return;
> @@ -526,11 +526,16 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
>  
> +	/*
> +	 * Nothing has consumed the preserved state until the folios are
> +	 * restored below, so failures before that can be retried. If no
> +	 * retrieve succeeds, finish() frees the preserved state.
> +	 */
> +	args->retryable = true;
> +
>  	/* Make sure the file only has seals supported by this version. */
> -	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
> -		err = -EOPNOTSUPP;
> -		goto free_ser;
> -	}
> +	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
> +		return -EOPNOTSUPP;
>  
>  	/*
>  	 * The seals are preserved. Allow sealing here so they can be added
> @@ -539,8 +544,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
>  	if (IS_ERR(file)) {
>  		pr_err("failed to setup file: %pe\n", file);
> -		err = PTR_ERR(file);
> -		goto free_ser;
> +		return PTR_ERR(file);
>  	}
>  
>  	err = memfd_add_seals(file, ser->seals);
> @@ -552,17 +556,20 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
>  	i_size_write(file_inode(file), ser->size);
>  
> +	/* The preserved state is consumed from here on. */
> +	args->retryable = false;
> +
>  	if (ser->nr_folios) {
>  		folios_ser = kho_restore_vmalloc(&ser->folios);
>  		if (!folios_ser) {
>  			err = -EINVAL;
> -			goto put_file;
> +			goto free_ser;
>  		}
>  
>  		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
>  		vfree(folios_ser);
>  		if (err)
> -			goto put_file;
> +			goto free_ser;
>  	}
>  
>  	args->file = file;
> @@ -570,10 +577,10 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
>  
>  	return 0;
>  
> -put_file:
> -	fput(file);
>  free_ser:
>  	kho_restore_free(ser);
> +put_file:
> +	fput(file);
>  	return err;
>  }
>  

Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

