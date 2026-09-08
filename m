Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50ADCC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1956B0092; Tue,  8 Sep 2026 06:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1B06B0093; Tue,  8 Sep 2026 06:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF1D6B0095; Tue,  8 Sep 2026 06:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 361E96B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:12:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2A4C1204A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:12:51 +0000 (UTC)
X-FDA: 85190181342.09.4BAE365
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF38CC0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:12:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=kAonQA+s;
	spf=pass (imf28.hostedemail.com: domain of matt@bobrowski.net designates 209.85.215.182 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862370;
	b=2OKWPjq0doY+3xKUNrKNk/I/mmhFJNW0cx5ueB5v0OWdJjpD2Zlegkr2VRFH6lAvAXKhaj
	RCxAWfJ2UmwbXn/+Q5b/0bpZ+ttfyr2rNp4bS0HO7Mi+X+PXtObXSDYp18XqB6SUn2D3M1
	YCCGEpqHW9SG8V1/fxbXVkmK0+ULZf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhA9ASZ5myh78peIx89yYob/fVYshdxCIaZiQ5E+/oU=;
	b=6Yfv1WCpT9gBJqGODGbyMAhZyLs1vQ8ss60Hf+2ZW8J2Xc16bzxnyMELYyK/RWLK6lk1WB
	ICTDPM4O6Iv0eY3QvQCTYxIG5BoBSyfoNradjwkMZ2T4ymiPf8MVKzXiyEa6csJ+VRbX00
	jkaHcsWxOXHT1Us3xqql8k2hqXRomSw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bobrowski.net header.s=google header.b=kAonQA+s;
	spf=pass (imf28.hostedemail.com: domain of matt@bobrowski.net designates 209.85.215.182 as permitted sender) smtp.mailfrom=matt@bobrowski.net;
	dmarc=pass (policy=none) header.from=bobrowski.net
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc48fe04342so823752a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 03:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobrowski.net; s=google; t=1788862369; x=1789467169; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GhA9ASZ5myh78peIx89yYob/fVYshdxCIaZiQ5E+/oU=;
        b=kAonQA+sPIuiiX0cAvyHe+SHGnRv9QEKbU0WzHHDxHgbaP1kzIOmqTxPRvb1/BO5pq
         QfR64UyWFNk9vD4Jl+ZdMSiZ1ZwrZt40uOkQLdcPtSaMWgCifvKN4pygIdGcsmYF/3jD
         ZkjJyWKrKaAVQ0JItxGx8cQdxtKFPDK/TTk0Zlmj3aSVycR/OUSP+sDfphxK0zS1pLJ/
         HV9x5mPbIcbjpAZXSC4EEkLmjB9hjgUaZsDOSalkzbZCrxuoJzRRzAUKaJSIVuJC5P/z
         avc7sAQ6OLgDqOuvXbCOawDuyomzHa6iHHZOxmRbXL26m5PJoKHK6ZXxU2rzSIYPwrHa
         6sHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862369; x=1789467169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GhA9ASZ5myh78peIx89yYob/fVYshdxCIaZiQ5E+/oU=;
        b=XjtCHtT68LwrJDkmDvjFqycdd7wC0NTR2tLWijueAvSrTlRblcgpMlkAVE2XbsxeUr
         6PC5Mix1jm1yaTIxU40+bmtqzHBLPhGH9XdM5YMgZKu/qFFLfaoYT0m4CLviJLuKoOyO
         wb2+GvatZ5tcjyOfujoSNq3jF6o0mUtPhkU8IuoWayzsewx0dfdXbJbKrR8MJXJImqLw
         +tsKa/pKHKvpCqU2863UxQyps3OUTSbtEtPZPffo9MhfmuqhjOkpJ9Pee7PnEA0VJJW/
         MsPktLvKME/1pfcHDrl5k/Aw0fV8ZuJC1gw6JHomBUETqF9xfsDVdNhrHoFwxuSZwO1S
         1hqg==
X-Forwarded-Encrypted: i=1; AKwUvBy43+zQZZBoDDecL7Dw1CiiqL41NP4GAT2Hg0vhLB9p7aXbmt+CZpBWQjY2Mk26LEIUSc/ANGJ48g==@kvack.org
X-Gm-Message-State: AFuF++n2zUOvLGn9jelIGhJQ/vkm3bYhwNsLrsFJz9744eOOSnEbuumG
	BYBeOCL2TB5tlYtPlcN/lPSJm/YqPVq19eGFneNnFN0fQUQmeOjHM82h5uRIRKtWcJz2
X-Gm-Gg: AYBFou1uJCF4ZWBxa+LfJbZNxPq79ffu84e2EdT1rr/M9XP+bm8vMvK+zQiYsN4anA0
	M0y0G1/VdfdVbAdTMaQJAPmYOsiQGZ6M7EOtJDjuCRI3dJ5fUKTLDDuMOFsRnEKu5UMtEJ3Yj8k
	E/TLj8oNFSDSm3QGe8j97X49GE1T0mK2aw2paO2lpooL84s3a9haKr5/p3G4AMKxpe5gIAJjFG5
	bW5M9Aw31KOUHSDw0x4msgAdqOrLXbxbUmfJBbzNT7HOQ4VgtnxihW+zOTL7DyL/WZxnG+/5J1l
	o6cZUHywCc7xAQFVbsA2DHraGa/byXn0SQmKY5pezSlTG8gw4xsBJCCpBqUuWIOh7DD3xc5HdRK
	smU/FjEk/iXqUkPENm+6RECeD2mNJpl6vFTYUxyiSbHDTPNbMZioea8WbnrdEzKL4cb4XzYylRl
	1Q4uxk6H/M+EEpkKtLuzc8O1dQ3RDtBth3fuF0tLlWhzmRv+xoHTfpZIWMlvGkkhH4CfLOYe6ja
	0LSNCSOzG/GRw6GtvGpkk8CsRNQWaca9XlLwG7L
X-Received: by 2002:a17:90b:1e51:b0:399:ecd:d68d with SMTP id 98e67ed59e1d1-39b26260f7dmr38959127a91.22.1788862368635;
        Tue, 08 Sep 2026 03:12:48 -0700 (PDT)
Received: from lima-development (163-53-146-23.ip4.superloop.au. [163.53.146.23])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b314cfcsm35093697eec.19.2026.09.08.03.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:12:48 -0700 (PDT)
Date: Tue, 8 Sep 2026 20:12:33 +1000
From: Matt Bobrowski <matt@bobrowski.net>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
	brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
	kpsingh@kernel.org, ljs@kernel.org, memxor@gmail.com,
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH bpf-next v5 6/7] bpf: Mark linux_binprm->mm as
 trusted-or-null
Message-ID: <ap_fkWbaG5u7UH7y@lima-development>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
 <20260907165220.52431-7-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907165220.52431-7-tasos.papagiannnis@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF38CC0006
X-Stat-Signature: hr7u3j7x6aogjarob8n39dzj3km4j9kf
X-HE-Tag: 1788862369-904764
X-HE-Meta: U2FsdGVkX1/r05Y3+g0OJwkfNxoZIcxmvADesN4LlF72OR2lE1VZpcTnYCi59Yqy+kbiGxnsdxAglJzFJ/qOzXVi/cIeQnC/ODjZvYDSaFTRYNKNLqgnlrPyI34s8s0iBI2HHWyv/FXT9QIMu75E8LuBBe9fuVJ0qUSWOC2+rVMcBJkDTAyU2PkidQN7NmIWneE7R0SbzW0vOYxCx4LI5WSXebr2RJZD8i5s1eK2Lknq9kkFML3xv/k0wcn1Ii8OPe0ZoBdZzNrlBoixebkuSW9pJRJfirV6PIa8hE27L6apohNyFHKtdzwLlqVCblgex4iZtSY4Smvk+yVoltoqnIZTv43gaZClBu68h2kMlLIbJMbvRtNItkR++8pHcmMT5+aFUCiyT2DMUn7bPWxTxdA4KSCl93KZdT1q48JAZ1F87ByM/tV3/zQAeaMZ0Bxu8872wM1wOcnIAScnTILfIne491U9oTTeRsWzx5n1SJzXHi6SgWjytUwkZoKAL7Kj36TFsIlHWJp3ORHygU+E/m503T/l60PkYyXO2wGSYuKEYnSFCbRl3KbgxkBzzpph8NPPfok28mmNpxnSD5FJCFBSIp5R/Fu31dsE/2mMml4uCcERf3z/NYIb8pu9DiRoMHUuuNRD46cPzWOX4pcjBlWrY+L8oFcBV5qQvxTw+oJCzGzyALxJLJ9E9KxAIpzhlb9j94TxZekgShQkMgcroed+HSsejV3/KXmHSuuAEsAA21qFCRM+5Wa+Q/gxmVQ2XBJWwSPQhs4QE0QViIzRsK0REq9VGB9wTMfsEBj/sWBla/1Xpkb2AcXrFiqiqC0n6673rSC7jT0Qh7knq5cG2QEDRl3eOm0sV3RIVceUH8etytoQkfrM+/J8Q7V+26ceTo/OCwJXfF3Np7tw+FyNfPxsme0PnL0JGBQs54iBCYKAUPIvySeGqwCwczzRK1OFjJzgJE4epsSJ07mnt77
 CvAh9opL
 MW8aJVyK4rTTP05rq33/UHTDPPgocYfOp6JeckC6q8huO+gad//i/LjOYGWp1Rkr7hcJrimYtOmw+QonsNq3h9crPfYq1xkSQStLCJ72PQ2DDiOA2vepybYGdwcN1pgAJnMHjga6loO29eOW0p3pehaLLKPHe/94asspscgcBE3wd+cl6X3kXBo3lgnYjfkqkz1f4PxhMnCBzugedevACbwFL0MnDwx0G6pGErrJQChmQoMAz4HEjegVpEmWJw/lvSSBSKnxt9FAsfSahwi5YNKCvv+haY1LPvjS58WngVjjxG1sxQtLhXx1WYRlsnSo1HrxDrrR3/kg2Ox6M8+yljojnHQLzEuj0jdmjyD9nDx/Qk3N8J0TLr9APSC4Nq48t0s6aptDQnf/v/8m1w49DyHaltUeBooQa/raPXcGAAdzsSfglio2eLV06lUJ5WECKTiafP1REXpZEeM0um+9wwkO8qG141Yf5CMK0EVvowSHGWVbJ/3DEjmKIXMZ8yBSvlOtALqVEuQjiS8V2caQGUpgyvHd1KEuGrLE9WchslzKGDhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:52:19PM +0300, Anastasios Papagiannis wrote:
> Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
> can pass it to kfuncs after a NULL check.
> 
> The field is either NULL or points to a live mm_struct whenever BPF can
> access a linux_binprm. On successful exec, exec_mmap() installs the new
> address space before begin_new_exec() clears bprm->mm. The bprm_mm_init()
> error path clears the field before mmdrop(), and free_bprm() clears it
> before mmput(), as ensured by an earlier patch in this series.
> 
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>

Feel free to add RVB tags:

Reviewed-By: Matt Bobrowski <matt@bobrowski.net>

> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b5186e664aea..6799d9e080fc 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6004,6 +6004,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
>  	struct inode *d_inode;
>  };
>  
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
> +	struct mm_struct *mm;
> +};
> +
>  BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
>  	struct sock *sk;
>  };
> @@ -6058,6 +6062,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
>  {
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
>  
>  	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
> -- 
> 2.55.0
> 

