Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08635C982DA
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 11:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3926B0088; Sat, 19 Sep 2026 07:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D636B008A; Sat, 19 Sep 2026 07:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25646B008C; Sat, 19 Sep 2026 07:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB3F06B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:05:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2528A140213
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:05:02 +0000 (UTC)
X-FDA: 85230229644.30.4E59DF5
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf19.hostedemail.com (Postfix) with ESMTP id 455901A0002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:05:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D3hcyEas;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789815900;
	b=k92ZqgHr9pbhiCAco3UE0WJwcrtBCZgP+X2ywwZP1ZaoFByC2lE6t5ZzajJ8UUSMPw9iYU
	nDdafN/1kLe91HC7MN+lZFy6HaHQDdGp8gqMr3j+hlgFH5+lpwGKBYmxaKEaOpL0yyP1Oq
	O4f9qt8zCaDqJsxL21eu/2Dmzqt7tok=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D3hcyEas;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789815900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rwy3osRntuCmj5MLCO/i0SriZXb6Zy0hh2IOAi6LGs=;
	b=4X5BnQWTGg4wnoK6+N8PYkJr2BA8rpODzt5f8WjWzJwgh4aJSGvpIj3yQhGUXh8ts4nhKd
	Ldyy+pwSAGhYkeZtITYR7vZL+TWqtEVRSj/cHeW9C/yk7BenTfkgdfy0p6OKxHxxS5VGBS
	lff3GjWDxFz0/YJnSf2NdL25lQOC2Tg=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b24c3so815874f8f.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789815899; x=1790420699; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7rwy3osRntuCmj5MLCO/i0SriZXb6Zy0hh2IOAi6LGs=;
        b=D3hcyEasDcY5+u6A9HmJjZDzaD+cmuyUim2/9dlId8VSMfsvZzYbwgXjG0kV40MiQm
         ZtYHRIL9Fl79lkXpg8ZcBGTgSXCTwFghZF2DYcXGDWy7zXLejPEI7ezfrTgbmu8//BW5
         kCzVrP02g3pGMeGYXla0F8oRGk59ccqKAYp35Z2CDyFuPZXPiRL5BTTJ6kYzeEHEB/6D
         uVc7Ndqye17bR4W70x9trwsRGeYAnlgS8SusgnRQAumxu9FM7MuPnqwSX0widZnIqB2G
         XS7fUivuAkdU9cCimawJ21OMDMg4TvDVOdWQxP2FgxDk/ULjhlLgon1SNK3Lxsr9Zgda
         nhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789815899; x=1790420699;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7rwy3osRntuCmj5MLCO/i0SriZXb6Zy0hh2IOAi6LGs=;
        b=WJDoO9nHQ11ydU941eR72FPs2hYUzs9aQ/SWsPYQu5NGOq5yIfjAABShtccmJlHP2b
         5k/BEb2U3jI0KcjwW955MGrfGkyvKzBIQnNXU1X2gnVaImeG6DluC/X9mWCSIwQrPpSz
         NjL9tTkPfeVaTm83Mp1Jfq+aOoeNAX48CJsJb2g5Eky6map0+MEqE6z1/d2Q/kMJzpOm
         JDsGRICJ8+cI35L/w7URLgJ85HFNtTyyq2w7bEaPm1Db6SJO11PTOHURxye3QQUKj+DO
         vevf664GQ7c6ZIKp4YxHpjx/RNluQZ02kO2hszZd9Mq5xnm+JkSQVVTUZKGYqHJCK2Sl
         golg==
X-Forwarded-Encrypted: i=1; AKwUvBwRvbtLUY61YPSn43n7PSRhNLuARKqgt48c7B5hj3QpwJ7WSTuYPT3ubsEhsxzcb/TrIatF5Q6lEQ==@kvack.org
X-Gm-Message-State: AFuF++nhaxwweCXvu+YOLpnBJ9ByZMPkquzOVJ1NjjLM16+/MkYWah0I
	P7PneCOPxQAyEDhzdCLA5BpYs6Sj4ldSitI6fpci0/IgAHHlXwNNNwQ9
X-Gm-Gg: AYBFou1oxQHlhJdY4cktnZStPwc7E6ZNh7u+v8KOO6Ye/vv8QS6ZrWrn0aAnMNjVoJX
	CGfOEyiZTjxkTIoHNqrVjx46ACyV7rtA8pah6K/PgsDVznVA8p78T8eobtNfWI05ynMTYe7MwCn
	VNHzqQmqm3yRb7q+jYN1bAPGjXDVsTyslLmXzQSTUdGwxnmWimCI2NX9mprX4BuMVcr0Ux8gyOS
	XmxZxhuE7CVID3ekTCt6btr5ENUxCnWWuGB3zKpVFSMy2EtDEUdsQsTpU9UeuVMjlYRfl0aEa4Z
	zCATFlsuVFQLWZExGcz8y/DGwGDdjOw6nGoniYs9SMG7aWRoYzW2cYSHgIfUuFnpI0GfXwMrwPS
	krssa1+y2nu/jomS23ISIxsxy1Bj80xmVPP7HN/CKS6d98w+jSQ7wye0D2ZmiA6EhASRb7alukV
	7xA/anfkCL2HFDFkJg4JzP3Kk6x/pD9WLQpEMTWR+W3a22nYtajWPymmBjXZOU3mi3xW3pUVtfH
	DNblOddHsA4nrQJr3AC2o2EMpGyEh81GkUW
X-Received: by 2002:a5d:5d02:0:b0:485:8ee5:5ffa with SMTP id ffacd0b85a97d-4871e36b1c7mr7900927f8f.38.1789815898629;
        Sat, 19 Sep 2026 04:04:58 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724460767sm6267511f8f.13.2026.09.19.04.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 04:04:58 -0700 (PDT)
Date: Sat, 19 Sep 2026 12:04:56 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, Kees
 Cook <kees@kernel.org>, "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v3 3/5] slab: handle ERR_PTR values in kfree and
 hardened usercopy
Message-ID: <20260919120456.5575e0a4@pumpkin>
In-Reply-To: <20260903203720.63689-4-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
	<20260903203720.63689-4-kmehltretter@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 455901A0002
X-Stat-Signature: beqpepzznguap9i7oezrqro1z43ykxre
X-Rspam-User: 
X-HE-Tag: 1789815900-137484
X-HE-Meta: U2FsdGVkX18aggrXQEoPrSQhdT1kAD+BJ07sQDZk1PQrkR4893aHGm5yvmlm+wFwrsOgCs1T5Axs97pSXSqzC9sRWq7IlqD0mUQHCkVbA+taKKt0k7sG1HOEI5iCCr65FIlnOLXe2T6N12Mm+UnFGMRyOhRdj24Ttx38dIMvNJNcFipxrLzgHUbyiYGup7SAWyzDfLpBc6Z5lye9csN33+VZwsbGWf9Fgo8iYvxXkaEv3Y3EI698DqXeor2ipdqFym98Lv3u17Y/tQRx/bMSsISjSVD4+01/n3bWl8vyyu2mmi/nS4P33tP61edy7dANetoRXYvTeMEVOqBwXw/roITBfD/vHI3gsYZsmfcrwKvqiFGiDuaxScm0ZmmPBSA0aTrOS+f+ItRvRp8uoek/JWHY4niacfHGENc5y53Lxvqp0E3DeTeFrMDmx99daDwBVxwotvZT/nc+SF5oSp6USi4jIm7MSs6rN8VZ8sWtqpfgGZjtZGbcqSyiMmCc6tSezigTbcDhGn928ZuNjUNwSFJHj36ddLouUxhQjdET1TXIXI54Oe9hyyAeboaMgalE0TeRFaIRUiKc3bsAgXR4Wqrk/AIbtQp16CqhP+TUmpJJlN+wKfvFeGw4bvcnndZJvPF/ZuQX3aAOi2zmcD9vfCKbLK5WKQP1snbJxybvrJZy7Bo08kSBPvWEOLD89VhAjwt6bmd5LVPg8ZQSv2X4sfSxtE5W48EBE+/0eu3QVyjAoB9q0u2OzwmfHilmwtdTkCW1Qt3WFhPDzdrO5yEqb4kXyAIpuAyAgpG/mPxR6GaNOj7VISayUFwQKLy57QLbQDJlANS7ulNh+vuk2eDJXo6b6UOzkrhI1tXGaybc25d5DrCsvZLRc8OhcOp4+RObfa02VHaobBaTslK7KaStfWzOTxbdUxncAijKWpJkerAjlJbOYI+2ASEcUtliJ0nX7dnCrAXMFp7M0u6Fk3g
 Vnxkp5A/
 NYTy7ub2dptanRB/5ahPWzow9VCTwidhLnEKLVBbTNYceCVByhBqbsvPqjPdA4A7p4mFt1DwJ/5mJTYID7x0UYlZJDHuAO1GcjJhLcVQ+284LLPM3yunurcuEahn6Mz0rpBSBzBxBY+4uSX1jWdiwvV7w+VqP9pjWNhK7b2dJJQcR4bKTXLQ9pyDIVtkQChRD/RZSnrWalJnwGBTo8tyYiP2TdUSe2ffmTiZ7985iGsIPZkkYHDfBqnhX90ZEunkNDOsg+67B2XrIJRA5B/7j/OiS2r5yyKiEseVloWUIM14se5vO11iuM8KVQf77oyqmRg+4iG+iVIdXarpzfqHdz3zA1f1plZMAThRK7mA65x8R1DLfcLeFQJCVDQD2HkGSl91cx6tBJ5iZBemEWIMCNrAZhEJZsAUseHtu3VtNn1T6jmyAR9jT6yTMuq0fkqihdFKbIu4qxz3u3aHomJwiMbOahTm9p7pG8tcaFHfzXWfQnIDLV9yisP2Fllbrgxy5cW5xm1LXcnCInfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 22:37:18 +0200
Karl Mehltretter <kmehltretter@gmail.com> wrote:

> Passing an ERR_PTR to kfree() currently reaches virt_to_page() and may
> fault. Warn and return instead, leaving the bad caller visible without
> using the pointer as allocator metadata.
> 
> Also reject ERR_PTR values in hardened usercopy. Keep both checks
> separate from ZERO_OR_NULL_PTR(), whose exact matching is required by
> krealloc().
> 
> Link: https://lore.kernel.org/r/CAG48ez05QVn6_gQ2TBrRa1a_DWQoaSSYubUsu5YMWxx-gqMijQ@mail.gmail.com
> Link: https://lore.kernel.org/r/202608111716.0FA9DB17@keescook
> Link: https://github.com/KSPP/linux/issues/93
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/slub.c     | 3 +++
>  mm/usercopy.c | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e7..027b44dd7f07 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6780,6 +6780,9 @@ void kfree(const void *object)
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
>  
> +	if (WARN_ON(IS_ERR(object)))
> +		return;
> +

Since kfree isn't usually called with NULL it is likely to be better to
have a initial single check for all the error cases.
Something like:
	if (unlikely((unsigned long)object + MAX_ERRNO <= MAX_ERRNO + ZERO_SIZE_PTR) {
		WARN_ON(!ZERO_OR_NULL_PTR(object))
		return;
	}

Although is would save a lot of code elsewhere if kfree(-errno) were valid.

David

>  	page = virt_to_page(object);
>  	slab = page_slab(page);
>  	if (!slab) {
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 5de7a518b1b1..c8d8703544c6 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -157,6 +157,9 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
>  	/* Reject if NULL or ZERO-allocation. */
>  	if (ZERO_OR_NULL_PTR(ptr))
>  		usercopy_abort("null address", NULL, to_user, ptr, n);
> +
> +	if (IS_ERR_VALUE(ptr))
> +		usercopy_abort("ERR_PTR", NULL, to_user, ptr, n);
>  }
>  
>  static inline void check_heap_object(const void *ptr, unsigned long n,


