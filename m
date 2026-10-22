Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C261460A3816
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=vUN4yWgl
Received: by kanga.kvack.org (Postfix)
	id E70386B09B1; Thu, 22 Oct 2026 14:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19116B09B2; Thu, 22 Oct 2026 14:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30526B09B3; Thu, 22 Oct 2026 14:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A321F6B09B1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:33:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58DE340260
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:33:29 +0000 (UTC)
X-FDA: 85351110138.28.A7CB8CD
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8E73E40009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:33:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vUN4yWgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 39VbaagsKCGoacaMMVLZIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--suseendranb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=39VbaagsKCGoacaMMVLZIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--suseendranb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792694007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
	b=Rhm2nBa61Jic+Ql/+9a6LQTXL7Ru9zbasb+LPF7FkOABgI+YLms7u2z3vuiAwc2cEXORnP
	2jaUBwq22ND/3cAU6HmrohmYN4FiDMHIwsd9wFWOu1s9baFC2FUZrt9ebGZwtLuW3K5r8d
	/5iVjoQEZxHeFDu0l7eSiakJCC27X/Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vUN4yWgl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 39VbaagsKCGoacaMMVLZIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--suseendranb.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=39VbaagsKCGoacaMMVLZIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--suseendranb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792694007;
	b=avXiwGoJsHkJAZDPx9i4qBfm/VZ2sq21GC4IdMFOGCWvjfxYg3/mxzsdKo+8BtRbKBxYYZ
	FEWyQ+ZoTXB2o1JmkgWH7hhngbSLA5pk8Lu6ah5As9EFnNstQwZFNtoQjevl26wwG98GbH
	q9B632fqjqmcJ22odXhwB7k/2iU0+uE=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a064f294cbso111502b3a.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792694006; x=1793298806; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
        b=vUN4yWglDuw/echXdVjZ+x/lDJISsFmbyGLs8FQoZNn+sg7qvNzyPP7vnjSt6jgwMd
         CR5ZS40H6bFHdrxEtoTxUT/kQnLMteHxeAb67VPcFCXEGy5DEws4YiCAWYSNbsl4ORV+
         XSqZxmvPSHA6qYnh/xBTtWzr73fXoFEVOvT3CiaBrxRm+OPufH9KHAzpGEs0bPRciun7
         mT8oylDMCIXwFZXnCNz1243w3JiYlMgikDE0jWSizd4m4LHGvjqevVbV8lop4S1nv4J4
         hPc7tm9Au6RTgQiM1y5px7FnL0kD7TgQViRblsIH4Z9Mf2F21Iet8gG/juXmyQAWWQ8y
         FfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694006; x=1793298806;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kMc2eNn/OrrFKUYMVyLnIB+VtX1ihRJBTMeBnYRefLE=;
        b=KcW0leWcPLnZHg6WTtnKKSTb1dya3dAyIb/yMBjrSuZL40cbUHPlmfRCrHDB3WPudd
         K4jqW69QbeaHgOtC3zUkT9sNxDlRl/ClCSjbSraS5jfrPv/n6+go9pXmJRpZzIV5elpo
         m36yJYdBBBkK0LcXv7QaN06jFOXTt6R0R1O+u2lgNr3Ay7dVRD13y1VCbn+LFgVfmHl/
         Fzosgalv4nLf9z1b9whJUj+OEXOO7DyTNjSXU9XswGgDhNO4bxN4qVMzjv8gV/f1FbhV
         Qka+1iKSz1XcpXKNfhsRK/175a/cCou1td3UjYQ6z+6roX0NA/G7InugkgDKpPShXHMM
         45uQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJ+rbhg14HaBbELcLNL4TBQUXTVRJ3wtvn7u5pku3U7TvLHoijk1j3lfdBlSlqTPP+ji0oc2RYvw==@kvack.org
X-Gm-Message-State: AFq9FYLbJy2pqlGT/Rka2ieqTCr7JrUCrNgDA6lP5AiKwWFHzlk5E1+L
	yVA0ZPVNHkOmGjOhO6Quoz18T7o1TPQqYvUI2wcauU+324STuHDvZ5aSyVHH+KFelTU/fUgZOWh
	FvcpFgyBbo/kbnL+MV8+DlKmYlQ==
X-Received: from pfdc25.prod.google.com ([2002:aa7:8c19:0:b0:89d:3267:4348])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2395:b0:857:7317:cff5 with SMTP id d2e1a72fcca58-8a2c5f488famr51343b3a.22.1792694005807;
 Thu, 22 Oct 2026 11:33:25 -0700 (PDT)
Date: Thu, 22 Oct 2026 18:33:18 +0000
In-Reply-To: <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com> <CAO9r8zNtuN=_BTV53oHqaTqE0Bo2qiDSrgTBzEZo5oyOnWyeYA@mail.gmail.com>
 <20261022155144.4177200-1-suseendranb@google.com> <CAO9r8zP+GUE-hcGWSGzhLNLcchFoZ38EMVCAtX5yZ78tZ0bbgA@mail.gmail.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022183319.163484-1-suseendranb@google.com>
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Suseendran Bhaskaran <suseendranb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E73E40009
X-Stat-Signature: m3cextojhechumzr5wwrsqfh4gfaiii6
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792694007-464720
X-HE-Meta: U2FsdGVkX1+1rmn0XQPpRrYHfVwP0VKsoMXjQ2Bb56MVFRwgZNBYSid3ogFdFqv/Dw+B0Sfaq5qWIRqXGAMnq+EqNumUKdFte6e61Og6WR8wPcMzhrtiogOdGHPePmD4Igf+w3e3pcGEvADPxmgonCIUFrO4Nevm1Jyk0CvK1OyeVJ4XGc7bI07FDaZVTv7jGqebzGFVg6gJg/oXeVMFgPhlztktkxWzEMSjXclIn208QWMv/I69RcEGGpme/hXYJ9w8fwBIi9uvmLqwe6fqyh6h5VUeZYJI1JsAAMaxJ4jA43h5yd07VWqFRzRO/GQgTJM7loP9Kpf+ksqZWdwXHlVy2gXbSUREdb3FTa6CVqskSlgpIgs8f5b9cMDt7/NT9Cc2qLXlJXFcF7d6jkAvjK5cd3EkS4dYFCAJ3Ls+oheKDp2xDKuZ67ax8iPdiREFfv+nj4zQkkdcz18TTThnvDOYTyh/ycT5wr8DuMWFJG0dm+Kd+vUeSF02snqtmQbGPmrWZoD50b2xdeHb65WiyN5RFokC+Ec+Nf4sr3xCsd+p8HBGmSOkoGlqHprll0bpC09Ux0t6+46rTSZKJCkAAv9Y+UM8F2HebfppwfNWYTy20D0Oopc06q+mFC7AiSXRfoF3gASfGuD+mV3w8HRux7TbaJro0vdq2F/GyFXhmwXTgiC7n/HMX6lIU0P1TBpiXXmFmvv4qNdGYH+aKW26QtadI0uvTTPOqYYVcAs2xR+c1miCZO1xZLgWVfp5Z9bTrwePCK80IqoGevtgh4Hqck6tHbywVM+Aus5MxI9ekwGIRvDj78d5D1Luo01RIjeyLlYQ4PQA3U1VEiNQC516OWlk5yRZQLfyvc/r9Ce28X2Xu1VHKseeeSHgw4TmEs+RLdLhCC/vIHOqxQmcUVRIKQYu0MPRDgkAvaVAJrJPVZOMKKIupbs5jBnwkvbgEoVrDvW3e35sbsyIhKhMFMN
 kiFJjURT
 LdlB4qDiJWrpAyqaTmkyNh2OlVrQLwIUwdi5LPdGYrgjt96P/vqngU5LcLzsS4YQJaNf6ndeLO4MtdnHJ8GG6G3+H5mAm8jGhTjl1jxhtaItsuIv+4Sdf+743wNkpV4E9Jxiwa/i/izcDGBpiQiSqp2fmLLDxD9RQ7yv2jOHKKUjkTD6Fv8mhsDtZ2VqILSWGTTYvA28APU4Clo6NrF9TP/q4FzybGHz4AaWAlZM8YZ7BUEThFx0Bavy2zrXXH3V/i3AfTwDNdupVfQJWximdxIVB/PX9Qi2ILRwr+YDYaUeOHv/NG9Ms5a7ZX/7k/3t2AlkdVx84D4ZoMbiIR0YO5vs8rWNax1k6jxMFX9H35KL1lFFlXlsRMihdBtqm/5yE4k/tcfv6yQO5QkDPKkPIQJc0LYtfXTLmGw8kfBLXmjJ8XN1uMzB8YN2ydYpN1NCtJnVOo1mDECgaG6mZW1bUaVcCKHbiJwifOqnUDxG2W8A5A6/TWinQ2Y2j2g/6AUfcAwO93B0GvGgWSq1Y460Coz/09XYZXnr+TgKqAa+cwWVspeV9sZ98CSsdF9bv2WzV36SMxjzYL96XuRfbjvFCrfCBy2V03l3KmyXiLLDmNgUcv+vpzSmNgZxV6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 09:01:02AM -0700, Yosry Ahmed wrote:
> On Thu, Oct 22, 2026 at 8:51 AM Suseendran Bhaskaran
> <suseendranb@google.com> wrote:
[...]
> > With that unchanged, existing zswap_compress() already accounts -ENOSPC
> > vs other error codes when writeback is disabled, except for the
> > !comp_ret && dlen >= PAGE_SIZE case mentioned above:
>
> Is this actually possible? When we changed the buffer size to
> PAGE_SIZE, I thought we made sure all compressors wouldn't write
> beyond the buffer size. dlen > PAGE_SIZE means buffer overflow, which
> is a bigger problem than debugfs stats. Or maybe compressors can set
> dlen > PAGE_SIZE but won't actually write to the buffer? I didn't
> check.

dlen > PAGE_SIZE isn't possible, since all compressors bound their
output by the input req->dlen (PAGE_SIZE) as you mentioned, and only
set req->dlen <= PAGE_SIZE. The 'dlen >= PAGE_SIZE' check in commit
dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") was written when the buffer was still 2 * PAGE_SIZE prior to
commit 0b1bf60c324a ("mm/zswap: reduce the size of the compression
buffer to a single page").

> As for the (!comp_ret && dlen == PAGE_SIZE) case specifically, yeah we
> should probably use -ENOSPC to count it as poor compression.

Ack.

> The compt_ret and dlen checks are not super intuitive tbh, I wonder
> how they should relate. What is the expected value of dlen if comp_ret
> is an error? Is it always 0, or can the compressor set it as a
> non-zero value if compression fails?

On error (comp_ret != 0), dlen is not guaranteed to be 0. The value
left in dlen depends on the compressor used. For example:
- zstd, 842, and qat set dlen = 0 on error.
- lz4, lz4hc, lzo, lzo-rle (via scomp_acomp_comp_decomp()), deflate,
  and iaa return the error code without modifying dlen, so dlen
  remains at its input value (PAGE_SIZE).
- hisi_zip sets dlen to the hardware-reported produced bytes even
  on error.

So dlen is only meaningful when !comp_ret. The !dlen check was
added in commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE
compression failed page as-is") as a defensive check for the case when
comp_ret is 0 with 0 dlen which shouldn't happen unless the compressor
is faulty.

> >
> > -                       comp_ret = comp_ret ? comp_ret : -EINVAL;
> > +                       comp_ret = comp_ret ? comp_ret :
> > +                                  (dlen >= PAGE_SIZE ? -ENOSPC : -EINVAL);
> >
> > Would you prefer that I narrow Patch 2 to just that change in v2, or drop
> > Patch 2 and only send Patch 1?
>
> Let's figure out what needs to be done for patch 2 first, if anything.

Since dlen is only valid when !comp_ret, we could normalize comp_ret
first when !comp_ret and then just check 'if (comp_ret)':

diff --git a/mm/zswap.c b/mm/zswap.c
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -874,19 +874,24 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
+	if (!comp_ret) {
+		if (dlen == PAGE_SIZE)
+			comp_ret = -ENOSPC;
+		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
+			comp_ret = -EINVAL;
+	}
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
 	 * save the content as is without a compression, to keep the LRU order
 	 * of writebacks.  If writeback is disabled, reject the page since it
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}

Does this look good to you?

