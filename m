Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EA360A2605
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eiQFT9Am
Received: by kanga.kvack.org (Postfix)
	id 345C76B05B3; Fri, 20 Nov 2026 06:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6086B05B4; Fri, 20 Nov 2026 06:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CD76B05B5; Fri, 20 Nov 2026 06:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06C0D6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:15:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D929A0E29
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:15:43 +0000 (UTC)
X-FDA: 85455242166.09.C6C589E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E010F1C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:15:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eiQFT9Am;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795173342;
	b=ELX3EeMLiamDKDxBYZf4e17/G8S1w5Ep3kUGJC7yblDktxgma7A1ndhttRZT2I5Eyybqr8
	rCk+L9+/HRbGWAE8LhzJx0wUjaabpwFi+2Ie0D4rbNE6LmhUKOOkM6rk03yueSU3sJOmwN
	fApXIqOFScQf9k6SL9RY/v7vUG4AbHE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795173342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4q/HAzNWIc8z/Kxp9yRP6YEkL7lf8pSJ0VxSvJc2osU=;
	b=dEPv9oTT2Ke5U8junzjIULMv8NSEt7ZEeYNtGRiH5zsjXYolPGLEQcTmYncWy0Md6TbwE9
	vb0Q4BCuWLPyumnShyO0tfH+pG0xTdK5XJAL7aNZUUvZKedaoiRSpcRxOoQUIDiQjH53FX
	c/QqBf7ZqAiYPanGSTssej+jTZeoC/4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eiQFT9Am;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39A26402A6;
	Fri, 20 Nov 2026 11:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631FE1F000E6;
	Fri, 20 Nov 2026 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173340;
	bh=4q/HAzNWIc8z/Kxp9yRP6YEkL7lf8pSJ0VxSvJc2osU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=eiQFT9AmZXE80k4vQiQVbH6zGKuabiTwvqQFRzxu32eu1FITxzhp6ynTVFOKGWIYc
	 kdt1ABR1nlY1lXBi21g6qB4xy50TYfMLG9JmYyI3xud/sDdL0BZw9ANPtDHZLwQryW
	 CCpH0Hhfd8DgR8jKwZGeQedWSfEuCyYEqOcljny15MzC/AhsZEKPbyCj8I7Xxh0e7S
	 zUj9rDDS3ujW4FY2JfUfbNk9Qm+e3G/+IWEJNSMyMrAiW+P3glbGmOPyJLrc9jvroF
	 7BxRY3IzC/wbNUIiDAHAn+Kfn/hojteAjPxdyBf1vKZNdYdwr9rAyqQJN8eZxA0XXo
	 BMVJFKbr5u18w==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 07/19] liveupdate: Add helpers to track the files
 that LUO manages
In-Reply-To: <20261111002358.1842967-8-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:45 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-8-dmatlack@google.com>
Date: Fri, 20 Nov 2026 11:15:33 +0000
Message-ID: <2vxzbj7j3ga2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: E010F1C0008
X-Stat-Signature: 465rjcagidctcs7t7p4o564r9o83tb68
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795173341-303448
X-HE-Meta: U2FsdGVkX1/Jefy2pivhZ29OX5Zd8h0EyTtQQfnlcs2c37njP8jxCbU9JowS1bDU1yQ9XnfohGVprSJU+kh1wBsI9IpblAkBQN94r8cT4zsdl6PBBXffxcKogt5JPmGNfR3AL4uBgiRS2tEF61DZELbpNi7cfxOQ5bQ2hBCgSC6JIXRfrnH7YdbFtkF5EK0sgMMtlm+F7XtY0GfYyBB3JwCBVurodOyCZTYOgIwUSLbN87vHRGv1UkTYubKw0952OEc15/23dxa5f9KrGQ0algE/NVYGU1fcVLNIzqHdB0wvxmu2u3M1HFMuRp6dSIADfVH0biaD+KB+QAAaYm899awtcFnAvuUF5myio6Bb2glTs0LYMjFiQK/jTnSyCrKBta8j5IElFP0FYF6UB/3qjHBcwFWOQhZs9/MHV2AdXdupLYdn1K0/bAF+zlN4VZ3ArRMNG6vlI9g3LPOCDqY3OvLKRNvJ/GvokPFNoFCerlyA4+z/TbHUOvGnK2GxBrdNy4IpioofTQydGikrsfP19oaL94gwnYUeF959oKdvkrk27uHYxRFrxC+ZlSF4c7CGhllKBOK5HlXWC9BmMUKIs22F82/EacPiaYIPFHRbf2k39ZAPIkjxsctbK/n9EWOrxW8SupjSasSemVEl1PbemjwvlAA8wJyp6rYAI1oB6D53afreU7l2RGkAA2HFrwZTCbrUiZJ4boaRE5vNZSQQqlmBqkx3ih0gqY0hUES3SvboXTq8TAU8tLZO/+YXDjFp4w/hcLoKq7IBs4xl17EOYhZSPRGt8Xu4rnykWwcCbr064HzMZfxcPIoXGiJfyDImYl/245+Onvzg//PSQEdbVnfUC/uIctWF1+UPFWlR61xuOCkcmSywxDTe3AGGP0bAhzl+OlOlB0VDSdAM5sW2fN7w9+7gSRYDu+6vzYBc3erEgZB6MBP/ewcagxPWQa8pa6lr63OegSQz+DLfJt6
 jKXseSbB
 lrdEfPT2wwBZeZX963vr5N+VKtVZRmR5Y1OaL/OoH9zvhOkP5Qw8Dgz2+fVa9r2KQVeAnHP+/83oUdGDB51QLhUIgbkmDAtQflJILdQ9ffLXmFP0FLpqeuIV+DHO3cXDjD32OEX+ZCMH55fcow2XckeudEb5g8SrNuUt1WdQOpz4/ZoHYApiffPVc2PwZxywntHptgVY5wq1KvBIJKL/bxyiZqqRu5yRDmc2NzPPFKPpYOFDyXH8GrpJ95BY4hZs6RZCdsdJ78RAHe66d5ywkThb8IPsXLZhWfzCFyEnGTkiYS6k2JCa3BngcvvEpLV02oSOKfoSq+/ZXxQ8hY29CGF6jXOB6N898+dKFOAJC/PVHD5AXG/0L4j7WAGDQVpICdMiE75MvZ50YdB+0MwDDbQxCFVMbMthb+NaQVKZupvhzwMp9GT/otvloaJwTXRA6eVCVekhz956sBSldJfTZFd8OJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Add luo_track_file() and luo_untrack_file(), which add a file to and
> remove it from luo_preserved_files, and use them instead of open-coding
> xa_insert() and xa_erase() with luo_get_id() for preserved and retrieved
> files.
>
> The next commit lets file handlers make LUO track the file they retrieve
> into, which adds more users. The helpers keep the key and the -EBUSY
> behavior in one place.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
[...]
> @@ -395,8 +407,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>  		luo_file->fh->ops->unpreserve(&args);
>  		luo_flb_file_unpreserve(luo_file->fh);
>  
> -		xa_erase(&luo_preserved_files,
> -			 luo_get_id(luo_file->fh, luo_file->file));
> +		luo_untrack_file(luo_file->fh, luo_file->file);
>  		module_put(luo_file->fh->ops->owner);
>  
>  		list_del(&luo_file->list);
> @@ -668,9 +679,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  		return err;
>  	}
>  
> -	err = xa_insert(&luo_preserved_files,
> -			luo_get_id(luo_file->fh, args.file), args.file,
> -			GFP_KERNEL);
> +	err = luo_track_file(luo_file->fh, args.file);
>  	if (err) {
>  		/* A retrieved file is new, so it can't be tracked already. */
>  		WARN_ON_ONCE(err == -EBUSY);
> @@ -788,8 +797,7 @@ int luo_file_finish(struct luo_file_set *file_set)
>  		luo_file_finish_one(file_set, luo_file);
>  
>  		if (luo_file->file) {
> -			xa_erase(&luo_preserved_files,
> -				 luo_get_id(luo_file->fh, luo_file->file));
> +			luo_untrack_file(luo_file->fh, luo_file->file);

This looks dangerous.

Since the previous patch set luo_file->file when xa_insert() failed,
this will trigger in a failed retrieve. Except, the file was never
tracked to begin with.

While I don't see anything that actually breaks because of this today,
I think it is a bug in the making.

I think the below is a bit better. Although this change probably makes
more sense in the previous patch, since that introduced the problem.
This patch should just replace the xa_erase() with luo_untrack_file().

	if (luo_file->file)
		fput(luo_file->file);

	if (luo_file->retrieve_status > 0)
		luo_untrack_file(luo_file->fh, luo_file->file);

>  			fput(luo_file->file);
>  		}
>  		module_put(luo_file->fh->ops->owner);

-- 
Regards,
Pratyush Yadav

