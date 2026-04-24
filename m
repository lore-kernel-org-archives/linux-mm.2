Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ABACFED3C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5056B0095; Fri, 24 Apr 2026 08:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC086B0096; Fri, 24 Apr 2026 08:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09C76B0099; Fri, 24 Apr 2026 08:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A09776B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:43:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6619186847
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:21 +0000 (UTC)
X-FDA: 84693415002.14.E502FDD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7998180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:43:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qjPWIYXv;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TBvaZCHZYDtyO4zWE3xupCtTc6DCxfTmUnxqLkwOIo=;
	b=OTRMB6k/YiTzzww4/qvQ99YXLGF+EytmXEtmOJ2f5WiMajU7Tl1LG1bNpAnuRS/6dDHIPS
	KMJPzh0cdSfykkYVikmefep0f8PdkbXy5CWLoy5VWjb7GtmyGLZpxBgzayhTiUId6zKWfX
	TWpwOgwvtYu9WD+iOtTtRt5+XB93EZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034599; a=rsa-sha256;
	cv=none;
	b=E8+YbGhfgq+woG3CNcxiIEVt7u3cABKjXU6eiJchqRnVX5tje/VrhYji5kPRRyilHMq+VQ
	CxUtmITAt/iNA4Jl+Hq0jxl2oMhqNgXd3CkaoP02ylbwCPb7XTk28rUmL1NwlO1UDrd7ra
	e14aeRxMLfyYCMR8b7EqfSMMq77gmHo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=qjPWIYXv;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8TBvaZCHZYDtyO4zWE3xupCtTc6DCxfTmUnxqLkwOIo=; b=qjPWIYXvlg/prrtX7TRA4FpQ7o
	nrli+ltt9JvGCpxeG54RddXewSBe8uhFdpp5FrUe3UyXB/PdzioM+poBsArxNBkmCT2fRRuIutmFT
	0jyPR+AZqPH/uqBRt+rVIKU82sBQo4wDYLs5nvfsSRrGA3vZ9zzzzCqxtenJJ8ZvSAzxZHfBfBl2i
	C6jF6o0seW0r9pfrXJFWHj02Fp3Nabg2jX09h5mBIQzsxYbwEnH+JJ9btRO9jSAtBgJQIxqlG7NNL
	Up6DOanV99Qu8YJh2+J8Lx1GcuSjWs36XGijfmYJDoNhz1YIZynPD3/OTh7YDJCybA8XH6jb+D17O
	XyTxNM3A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFsD-003Aw4-37;
	Fri, 24 Apr 2026 12:43:10 +0000
Date: Fri, 24 Apr 2026 05:43:04 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <aetj6NrBDcyG9rQg@gmail.com>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
 <20260421-kmemleak_dedup-v1-1-65e31c6cdf0c@debian.org>
 <aeostKcaHzmVBFjb@arm.com>
 <aesymSWyh8NRIrDQ@gmail.com>
 <aetcgHhBXfPe6lr1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aetcgHhBXfPe6lr1@arm.com>
X-Debian-User: leitao
X-Stat-Signature: eeam6abh4c4f5mny7a46gjnuzhxqb6em
X-Rspam-User: 
X-Rspamd-Queue-Id: A7998180003
X-Rspamd-Server: rspam05
X-HE-Tag: 1777034599-838854
X-HE-Meta: U2FsdGVkX18ShfLTzH4MFCzNYcdtM8EVujpsnLwbU0lxionQoYtSQ6/nQUTMr2ZOGWTqhVQhzf8xrwmp4W0uL6U0geQRPcChEtppdx6FdS4H5TkQMNnXIx84zfU03y93yMB5VKM5sCcNql+Tn5F6DJY8yGNMsrDjMbal2bDczOwfGmUeEVbceyrAiWaeACNH4FHYaFca6IPvgthRroH/tC5XKXSLXnjT+zQ+ti0pGlAeCFoXwqIV2l9nd73MjRFAAYh7ZCbmLojlNS9dzpVMeU87SK1OEYHYaIqFi5WBtEsb6BxrPCKAKvEh9eReA1zoSixt8QQSHdx94telhJEaYxX65hPmK/98XFdOqEK4IuFldQjaSZ5X6++ZgZEn9pjZwScKodifKdDW6lmUhafsti5mtjr937a08xlqnzOB0lXxQ9uf37K8Pac1CPyvFtzergxEtyMOkCEE2uZeYj2V3N922sNh4W59Oox2rtP+facW7B0fWMm1TI0KII67yZ+Nybe4wfQYciYQCkY5dllEetDjof3Q9EMmVAxhL1zLKN6rV7TskgyzOiywWnko7UGMtrsleIFyeo+oiXPprfRZDyb0yufKyiMq1BlbUkjZiM7aCXGYJTiSp9VBoUpsrPZDhOjKh7+nI+dsr2p49CQ7lObRW8pUuV2NeRiig2Rn4Uqj7hD+XKihEBMqI0AwENOjtlnYrUIqt1Khrdh+jZclrVQTyyl7KpKvsOzh3ihDILt5T1tedDB9yZphAx6rWohu+uljeT5zNve+Eg7v/Yc7eRh+n6NSdloyYotyxPVd1dBz+eJ4RNjPqlX36xWVkpuOBdLn+26zhLYqDk8suybXHvMdECEqYKspr7F+LBssojzKahZcvw5nD4GAg/K7Z5xfoI+l6BTPHa2cRtIkCAvpjbDG9igbWxtpHR63l/MvR+M66jXiP50URfJp6yQ9Ja9JqM7gMOaKJlSZmmeNWvl
 7a+3XQgV
 uke+FUU8Xv9wpzrTcTZqcLUSzr/uUgj+s43lXeXNwQsoHAf7HDm1jp2yKB02CyKMbCBOi+PzcVyfmAb3LsE2cFFlfHs3Vazcx0fhyysZjKH//+rDkkphgxVWdGFmDkIUHO9jZcPFUsYuzZHWgD2vWBALnr+P5oHjGMuqZJ03t0v9vbrNYG2umDMZ3m2RLRPjUiyedvpyt+4+ybn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 01:05:20PM +0100, Catalin Marinas wrote:

> > @@ -153,6 +154,8 @@ struct kmemleak_object {
> >  	/* checksum for detecting modified objects */
> >  	u32 checksum;
> >  	depot_stack_handle_t trace_handle;
> > +	/* per-scan dedup count, valid only while in scan-local dedup xarray */
> > +	unsigned int dup_count;
> 
> I would add this around the pid_t pid member since both are 32-bit,
> better struct compaction. Here we'll get 32-bit padding.

Ack!

> > -	hex_dump_object(seq, object);
> > +	if (!no_hex_dump)
> > +		hex_dump_object(seq, object);
> 
> Nit: just use "hex_dump" and avoid double negation.

Ack!

> > +static void print_leak_locked(struct kmemleak_object *object, bool no_hex_dump)
> > +{
> > +	raw_spin_lock_irq(&object->lock);
> > +	if (object->flags & OBJECT_ALLOCATED)
> > +		__print_unreferenced(NULL, object, no_hex_dump);
> > +	raw_spin_unlock_irq(&object->lock);
> 
> I don't think OBJECT_ALLOCATED should prevent the printing here. If it's
> called from dedup_flush() and the first object that kept accumulating
> the dup_count is freed, you'd not print anything. I would only use
> OBJECT_ALLOCATED to decide whether to do the hex dump if requested.

That makes sense. I suppose we want something like:

  __print_unreferenced(NULL, object,
                       hex_dump && (object->flags & OBJECT_ALLOCATED));

Thanks for the review so far, I will respin the series,
--breno

