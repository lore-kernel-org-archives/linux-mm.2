Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE3BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D426B00A9; Mon, 31 Aug 2026 23:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD796B00AA; Mon, 31 Aug 2026 23:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DBC6B00AC; Mon, 31 Aug 2026 23:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 556F46B00A9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:50:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7E991C1C72
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:50:15 +0000 (UTC)
X-FDA: 85163815590.18.65E8BBA
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id E065240003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:50:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CnI6gzdj;
	spf=pass (imf04.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788234613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oS+YgxWiYLpVEf2e6Auv3kRGzGPNIEMUh3WyA4TvRpc=;
	b=mX7K/SnSrjaKbmjEIBnGsJ2fytUmFjHqd1ral/Hd3aUTHs6f9hTHE61rBoRJI6gH5OSvcq
	s95Q1/5aE1SRF4pKVyHvIBUCCtVrCoDZZauyJiQbmI/F84oQ2l2w041Nr1r06MbYBXiYi+
	i9c3sRlmlxlzBl7lh92uVoelCWc8LNU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788234613;
	b=m605ynOXeYrYJ62RxEbaJM+gNZSx1OIpUmHKPwIsyxuQwcWS6RB6459X8Y8IvXRsf5qKEf
	bs+J/gK2SPFch3PTqw4YCbMq2mXlrAAqxFQ2X33ig1OV4YrQ3iFALYmrRThtWDQXSplh46
	vDQQHygVGDMH1hCE7n8sWC8KjULHmsM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CnI6gzdj;
	spf=pass (imf04.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66e5e33a9d0so691385d50.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788234613; cv=none;
        d=google.com; s=arc-20260327;
        b=BUhZ/4SqckovrE/egfHMSq/04ILC0HGI95LPumuOKAr3FjYn823fy1TjnRugs8oEWH
         hGdH8xQyq0tL6f/69z7okNQkaBJ1tryn47G3C5OhX0rgtzZxXGnYHEOywKQFEG7Md7P3
         O9Aq8pVlgsibYgjmRwLf6pCzCtdWIn/nvh8oEMua+HH3cR58vMlICTE50USGJsR3Ngb7
         FUWD1dnd/kGLWr+l686bXAiYjJNThUwCxI+fAOc+elZYQA8Xjqefw8Wp+Dgx0VnGsBXN
         kynZlme+bsz1q5XshLZdtjqtuBRQ4/ts3RsepOmfYgE1RT7TrYlzNmHOp4szS5dll/LG
         mFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oS+YgxWiYLpVEf2e6Auv3kRGzGPNIEMUh3WyA4TvRpc=;
        fh=b9PngdoJazyScvdMuI4MgArif4Z7VXDMi8vQjqTPFPE=;
        b=QncjKO7KJai3C+oZ2aGmtMZ4kJ34xTmJd4sxA3P7h3Jmm3arJ4ySjZjpVZfjQiuuRS
         9gtYQ3zInjSSP1cNBRW+XdTkyHA9ZgYNuR7Xul/dAdXpJPi3xbpRhs9B3qXoqFn1QZDj
         EC82RdVgQuVPrV6hvwQcAM1wGXW8J/HycaKXGiLs6Tde2h2EEApTaj42FZsrZxu66sfB
         p6xHTYRMJKn2LHZ57mTU/CF113lw3YD66P1pxQ1V2E+/nDgvgpQVj2iOxSaisy/r/751
         ofHyWUkC5uXMxRw+wvi6bC0DABDF2yXSJ/dtgsKPZYsgatYCY2luID5engKf4LAHi3D4
         VyAg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788234613; x=1788839413; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oS+YgxWiYLpVEf2e6Auv3kRGzGPNIEMUh3WyA4TvRpc=;
        b=CnI6gzdj8rSIGwsxvF5zdcHMQ+edZzl6THyJmdeuSAs1v48FKfYNR1ndETGkFQu5fv
         EQuwMWeOSEFixguW3I0+5RLYdAXecMTErAq+0pvR3JUYdTY5WbCoEVH9ufD9IItbWmvU
         s5N+b9fZMC+N28umW+Ji4FDNCBzFfE+4Q7IXZkv0Gmm7Qmg3hqraQQ0G9HJnuJx34E3Y
         DzEXDjD3/1UqPZm5f1/rkgeJYUGr4carwOZrg7RlviEdVmXlWxvHd+iBG8fO/nPkt9y7
         +52p0EZYJDdPME505W7rOHsgVGEq6Kfte71QObC02UEt6keWpVhr4VALuXKAl1Fo8OaS
         UOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788234613; x=1788839413;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oS+YgxWiYLpVEf2e6Auv3kRGzGPNIEMUh3WyA4TvRpc=;
        b=MFt1CIQkzWasPkna0VJFm8fSg14kxHg7J1YuBjLVmSLav9BUdlMQ450XbYfkOwGe3+
         4iHC6D9/SDSrbppHkj9OnarcYFLLxoxiLnthjjIcaCZn4eJrJhRm+Ktcy4z17tLGMDiL
         KDeDIs0Mfq/5NRU9+BHmak+wgV2/rz95Z8ot62h/SA2NKEI32WuUUm13vUipRhaXv/dl
         YkW79c0EhsOYIJLd4eX3YxEwdcr41nhLoC7Pl7kHQ5KpKn/lLLO8a2zk41HZXE4Lmgt/
         4yr9qY6TdQBivrGVU8tISCjqgHcauIJ3KjKK5QUMRcqG3oaKpNbYgsEDYsHNfggW4PC5
         ck0A==
X-Forwarded-Encrypted: i=1; AKwUvBw22OEFUEPvskUUwKEbZ8JWgO66DDBUtEgasV+jAOrat2kLb/dggRnHRUG8qhrc3Ssd6eqIdBrDoA==@kvack.org
X-Gm-Message-State: AFuF++m1sHtID5f/Yd7k/eO16Od8ec2MC3qL5pthwKDY161eIVuZtqBK
	1guyJAZfkcF387UdJzN8c4PGiEFGkKM/slwBzgidNbOewx9pG2sSx4zzBPNFWI9INV9Bi9A6E33
	Jo3BFdQ830ZsR3GKmDzvn/HMk0mzS7ag=
X-Gm-Gg: AYBFou0sCT9x3UlAucM8SPWWe8wyfTu3n3pKARagt/Vr4/3EacJ8MabRf9ZNUJW2+eJ
	D7CXmH0JXq+4N3PdJdgPj9NcbkQbxz47LVjDcaqCeKb5ECd5q37WgjrnvgzvstnAVGos6PwAOS2
	TRwbnWf+oAuyhKvrVpM6BRoJyypAwDHX3L+OR7tM/Syl4020g85EVgdZvufIEbcyBgKmblT0C9N
	hmClDQA7aD81C+LNXlkArCpvYC/2IwX3OyBiqO/JEw45ds/JUg+aC7Bqlus4imbHBaiLyfPcGPu
	vNLSZAGmZdgwn0CCTh2Vo/agXA7QK6im6/uPuG2F6ogosbxJLQwdnGtEVNYBaZQEVzIdyx/unDt
	DYzGJUzie4GNUulO4ZjfClZk=
X-Received: by 2002:a05:690e:4888:20b0:66c:71a4:6ef7 with SMTP id
 956f58d0204a3-66e4c76ec48mr7226022d50.35.1788234612985; Mon, 31 Aug 2026
 20:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com> <20260831092305.42062-7-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260831092305.42062-7-tasos.papagiannnis@gmail.com>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Tue, 1 Sep 2026 11:50:08 +0800
X-Gm-Features: AcwNN1U-TrFQ78uGmPSlh5DKr82QMmwSDUwbspb3nZbsW6N1XhgnhGW6LFmWno4
Message-ID: <CABFUUZEwY7B0VOvhbhieHXHuvms4dx_GO3gw99vL1zk8q+ESTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/7] bpf: Mark linux_binprm->mm as trusted-or-null
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	kpsingh@kernel.org, matt@bobrowski.net, song@kernel.org, 
	utilityemal77@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E065240003
X-Stat-Signature: 8g5to4nyth1b4jh4oaa6mi5k77gohgm6
X-HE-Tag: 1788234613-451288
X-HE-Meta: U2FsdGVkX19Ja/1FOt54NL35pBHOuW1O7x0kZKE83Xr370EiSvuyZ3Izwl3/DoLePft5YbUkrC31+fbLv4/TK3t1iNndmTVMsGcM89WgUMoeuthdrVLiFOuVVzVITR55waMCO/HQxGUW+ddg6CG0vuBFZHoru9p++nYuus0OdhSFH0+1SgiGza+g1+hfzJjwDSITTk28Z3FwRqCvuON2BrbT0b8AtPuI/QQe0J6qqQSO+T5DVugkGme+J6sB1MgXJECjUV3MDaFQdUeOdQB1KFhRmAKr9//3141m9RTUPty2qBjYCemFQQxGzX+XHeYNBhPlEgXd0U1d+iZzfiXPtsr06Pd3JHyqgamhTvD84GoAS+1ZNjvAgjayZVPSKxv+/r+yLB0C8qtiemlRnlUzqCBieTB2R7dkSfDyFlR17WKhnQVFs3r0OO1AJPJgiePeZ8/tuTZbRXp1jt6F/y/nUsqITx92/YaGRBjt1Uz0yTCnmzReOQEaPZhswYpTJsLCQw1fdCBdGhdeUVRYAD3ii9ys5MEXq//bmATf+JkU7VOljk9e+xzquVdJBIK6S1i5613+dvUVl5ABSMD88/UtaGGlAkPTAwwBFV6xgjRwBY1gSJvMn99ttz3MQRh5p/T759HfVAmED0Ag/4SUpUNcYNr5/G0DRg24zH2NF7LMoyjVleqcD1q5NsejyrQVu9ubDEI8vluvyGpyFZ9D0xg/l2xPbmpLCiJlesMndL5rVHzTfaTY7rkxT2fZKFVe3QQbzuD0puXG7y4vNoIrI8dYcyMDHV/MZkV9lQtGkKhTALiNv2I5tPSuR/HpU8cIw0aSucFubtsQ3nFpCOyZQjoZ69qQd2zuAKC4akFpzQnOmUz979Imdz/ND0K38AMxpIIDaVqD8JLSI2LyVFuM/geo109zETfmvO5dZSoh+nNmSzy/EyqdRDWjVNq7pUFfFqEBZFYgVyb0OKd5KWlF9Jx
 cvOEVXfJ
 WziMzHQIQ3OWlFPM/kESKBMsx+8m3I2uWA/oPz9R15S+SwhyX36+ywQ4NZ773zlxFDtsDYhMltNeAwSEgiKvu5XXWFwpmBEntjeo2AcHVE0DS0vcXCeEwWDppPXF0G+yKqJXFctoZiUYdWaPqVTzrM2/JJmnKBv2qapaH91szRDcufebTbWH/GWuqrp4gPp/QdHZC8KBVWKVfD1Qp+HdQUv09bpU4IVdMMkWeGTqlscOrO+0OukUs6rjgq/lXnkggWM9HYYweWrgTibcfW+ozBV86Wn4bwCT3mKCMBODE0+rb3slRzB0S+A+Yh9Xz+iFv/2CCuMYnlD3xjUlyndX8skXgx4WlI4+eBGN4Ll8Jeo84zPRNSfCiE0pxSkG1KY+IeYxiThinjSC+eb38XBgNngMvqSlGUzS5rD2sUoFCuROnmapcihbRkxhP0pv0XVYKgP9BrbuNQ7WHDM0UN7UJcTaK7kxQm9IszJ6nczBCvXQc4wp7PiLnDbHvE1UCIye9/TaOgsGMCG2aW7sLemAP1lWbNB5i1nki6U0uzKCSIfpdLsRw+46OD02bUrRI0/s/QfsTrFOkQTExnJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 5:28=E2=80=AFPM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
> can pass it to kfuncs after a NULL check. The linux_binprm owns this mm
> throughout the bprm_check_security hook and clears the pointer only after
> exec_mmap() installs the new address space.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 386401fe051d..584c79326b9c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5958,6 +5958,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
>         struct inode *d_inode;
>  };
>
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
> +       struct mm_struct *mm;
> +};
> +
>  BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
>         struct sock *sk;
>  };
> @@ -6012,6 +6016,7 @@ static bool type_is_trusted_or_null(struct bpf_veri=
fier_env *env,
>  {
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +       BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm))=
;
>         BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct=
));
>
>         return btf_nested_type_is_trusted(&env->log, reg, field_name, btf=
_id,
> --
> 2.55.0
>
>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>

