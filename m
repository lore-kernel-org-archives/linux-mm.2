Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AFE606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=1RWlV4lW
Received: by kanga.kvack.org (Postfix)
	id 257216B05B2; Wed, 28 Oct 2026 14:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206B76B05B3; Wed, 28 Oct 2026 14:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC36B05B4; Wed, 28 Oct 2026 14:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E73C26B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:37:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FB951401E5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:37:47 +0000 (UTC)
X-FDA: 85372893774.30.D89386A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A6432000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:37:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1RWlV4lW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793212665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g52qDqbCr8uPmZi3S+SnsnfsE1Wav8hnqrD+It3yFgY=;
	b=oHhnEsRdVPkW5YCejE3/ZySmSKe2R7xCQbIUrXDR2tj4FliNjLBYYYulAEs6R6wYFUu7uo
	sdbKqjRrJAp/IBnRZlT5I601cDBn286rRaUUntqSe9tNq7JJQn52klEK2/19rd71f+TCUJ
	7KHfA6Yr1lmuN34ngArAzGq4NO2u7qE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1RWlV4lW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793212665;
	b=nh8y61B/VuFloJqXaqRdSvno5QP6qZV4/RlBDVepo4FUvdO4aXIGPge2aUSTVSfjstlAJn
	9Rw+S7KjRlzak7zFUsYiM9Tucd7vUYP25a3lCLCZ9uqDp7ej8pJP7nBR8rICNnAUk/eNUC
	6B4XNvguxsiVjg882ZJdVSPWR/XBEuc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g52qDqbCr8uPmZi3S+SnsnfsE1Wav8hnqrD+It3yFgY=; b=1RWlV4lWSXGhQErZ+rFG3aO3z+
	bSIhwsJuZHDAeYzFzYNYDnM7bnDGxSWIQmJUeBNpKzvYL9XEhcSioanid3Sj04ovj6veC3RJXfiB8
	BKTqsxnS9vaW5btcbryB7dk0UBUL0lXh7r7/ahjCzs6W0CZ1Q73/L9HyyOK71Eu0+2lp2CrvY/KFI
	Sa/lB9gz34gOTfhVtE1N5+0Ygw0ILo07BUrjTQmNt1SFCPDprdmolaHEFZE4x/c+9ny8qgDL72rzR
	cOoXdXtSxW6uGRwhhn+6BhldWxNEq4S4iv7g8H+xd51S4gdkMDgXFnYwh640yyk4Z5HZZaLY5ckHy
	e4LmRvCg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM8Wt-00000007lCO-3Yv8;
	Wed, 28 Oct 2026 18:37:44 +0000
Date: Wed, 28 Oct 2026 14:37:41 -0400
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4] maple_tree: Update internal warning and bug_on code
Message-ID: <bdl7exlh542lhpn2qbiv4upq7bn4ugxbkntchjxnorbrr25rho@xyixysbubc6x>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-4-liam@infradead.org>
 <auImniguGIVq6c_L@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auImniguGIVq6c_L@gremlin>
X-Rspamd-Queue-Id: 5A6432000C
X-Stat-Signature: pbqhx9io5iqi3nkg47jrtfywnywtkd3g
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793212665-612028
X-HE-Meta: U2FsdGVkX1+SiTFz6RFnfVz4XE6dqbPRuW/LaQpM70laexJshA/gYbQp4IQACWy+YlsN/9LuK+tn561oHp6HpENZTcO2BN1szQbAtKMCPEs2+gOdJq/Q5DKhjFRuwxIB59usGE19/kIM6FAUGnHHls1d+bDcJzC4O3tW8PDRGPSYpUXZ1M7kxTxDO6ukWhZ4Ogi6HZKX9lfbnFF+AR/IOr82x1H9rWM7wSLq8KrPQMI7ErE3ALSZDOREzSnVAQA2YOD5r3ogTPlFUVb4idYM7CdqhMXby8d7CtF3hOxV3LmiyXseuLritj0Qlh7SFWyUGCYdTIl/JNetuz1s2r8xVd+YkSXGPPBFsQaUatACr+eUF58HiZYCaf5rfxvf6VaE1f4cFfm3ECXW4eOX12953gvgcV67rmRI8xOC/9qeCoC7aOsqZGcyXbmQDAd+scg7TV0begY04q3hmweUFaIvzus8Mfyi5h0QCCx78gnC565Um+K0cnaS5Ojqt/BpWFLPyiyGPAZS4SYBf85VycxH+N9roNlyU7L1L1K1qzKzd0P+G4zabi/pfQXmAFNOjLlRbgrtytXh0Q5rrcws3siygNXlJ8gtekYfsCfDvIGDHtXA0yEI/I+j1VffKn28r1vjtPlvN1GfI54vgnK6R3K4JEnepu1zjE86oIEZ2UGeRv/5fbHbNNvJ+0ZatLuQI44gPx//On6HtYnp8DIN/DR57oWAemgX7kGS6QVtlxN9yGYKbReEhxosEGniVGdj1OnEFd5hS6N9Mtdts2/gxtFFDinsInagXMSSFoh+Nz8Phk4zrXUaZBCsrq8BM2qpyccHu2SwmwNJcFrdvTejwFzNo+p5XS5hHpnm2579X0dOMBsN9kqy2BA5TN9qMLFfIgRrGAHh/LsnEgzetylpBpWQr2kqIj/1cmbnCRcmzn99Fy4q2wxPrNVRkpcgl7qjBjz/XVn/ixOdDjuOLTyNyiy
 TuYkM7Z+
 AibaKqqALmS4spv9czRWhL9aAh1ma1Si0g5J/T7yNmuXnCUjHaydJP097qt+Vgi3ZvMpaj+SKeKEAN5LzaJnde77RjNThN/JfP/wKCl+CakvF0QJnJiIfyoT98TlLzF4s20npiTD8AdGi/mDNLqOGEonUkFJvu6Y31dL/Chev5hAnWpSnGcKBQywv0ohmC2KWBgMY1AWxx7b7jSWZpkMR1kIAMs3NkUP+7RMSarHIKglRpcfwSnPsy78MqeiiBBJBJjfcBpUtbmPLZUobWR8Ae1WbIbSlddWk1nJTvSjDbzpIw52n4L5DL6AM32DtZu+ZspiAEkbiYPEFVp6/JaA28H/NyEiWZIYITPb0+n4VgNzAj96ga9knvz6Wkxu+Rnl9lrunX3mIqBLmEEmKDiX4oaKSh9zV7f0pNR/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/28 05:54PM, Lorenzo Stoakes (ARM) wrote:
> ma
>  On Wed, Oct 28, 2026 at 11:42:17AM -0400, Liam R. Howlett (Google) wrote:
> > When CONFIG_DEBUG_MAPLE_TREE is set, call the WARN_ON_ONCE() after the
> > custom information is dumped about the tree.  Without using the kernel's
> > WARN_ON calls, syzbot will not catch issues detected by this code.
> 
> Mega nit but commit message doesn't mention the BUG_ON() bits :)
> 
> >
> > Update the non-debug code to call WARN_ON_ONCE() as well.
> >
> > Cc: <stable@vger.kernel.org>
> > Reported-by: Lorenzo Stoakes <ljs@kernel.org>
> > Fixes: bf857ddd21d0b ("maple_tree: move debug check to __mas_set_range()")
> 
> LLM overlord says bf857ddd21d0b only moved it, and f0a1f866aba1 actually
> implemented it.
> 
> > Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
> 
> Looks sensible to me from kernel perspective, but LLM overlord tells me this
> changes the userland tests from asserting on dump_stack() to just printing
> something out on WARN_ON().
> 
> (BUG_ON() is OK, it asserts already).
> 
> However we really do need this for the kernel so CONFIG_DEBUG_MAPLE_TREE
> triggers syzbot and such, so maybe the userland bit can be a follow-up?

Wow, so any WARN() before... I'm trying not to think about it.

The change below is good to be squashed into the fix I sent.  It also
makes vma warnings fatal - which should also happen.

Andrew, can you take care of this or would you rather a respin?


> 
> On that basis:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> Or... maybe just respin with something actually, can fix it by updating the
> shared maple tree testing header to make warn do something like this
> (schlopped, apologies):
> 
> diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
> index 2a1e9a8594a2..112052e7201f 100644
> --- a/tools/testing/shared/maple-shared.h
> +++ b/tools/testing/shared/maple-shared.h
> @@ -10,6 +10,30 @@
>  #include <time.h>
>  #include "linux/init.h"
> 
> +/*
> + * The tools/include/asm/bug.h WARN*() family only prints a message and
> + * carries on.  Nothing in the maple tree or VMA tests expects a warning, so
> + * treat one as a failure and abort at the site.
> + */
> +#undef WARN
> +#undef WARN_ON
> +#undef WARN_ON_ONCE
> +#undef WARN_ONCE
> +
> +#define WARN(condition, format...) ({					\
> +	int __ret_warn_on = !!(condition);				\
> +	if (unlikely(__ret_warn_on)) {					\
> +		fprintf(stderr, "WARN at %s:%d: ", __FILE__, __LINE__);	\
> +		fprintf(stderr, format);				\
> +		abort();						\
> +	}								\
> +	unlikely(__ret_warn_on);					\
> +})
> +
> +#define WARN_ON(condition)	WARN(condition, "%s\n", #condition)
> +#define WARN_ON_ONCE(condition)	WARN_ON(condition)
> +#define WARN_ONCE(condition, format...)	WARN(condition, format)
> 
> > ---
> >  include/linux/maple_tree.h | 54 +++++++++++++++++++++-----------------
> >  1 file changed, 30 insertions(+), 24 deletions(-)
> >
> > diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> > index e30e57f5f3df9..0f96f1f19eb95 100644
> > --- a/include/linux/maple_tree.h
> > +++ b/include/linux/maple_tree.h
> > @@ -680,7 +680,7 @@ void mt_cache_shrink(void);
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > +		BUG_ON(1);						\
> >  	} else {							\
> >  		atomic_inc(&maple_tree_tests_passed);			\
> >  	}								\
> > @@ -696,7 +696,7 @@ void mt_cache_shrink(void);
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > +		BUG_ON(1);						\
> >  	} else {							\
> >  		atomic_inc(&maple_tree_tests_passed);			\
> >  	}								\
> > @@ -713,62 +713,68 @@ void mt_cache_shrink(void);
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > +		BUG_ON(1);						\
> >  	} else {							\
> >  		atomic_inc(&maple_tree_tests_passed);			\
> >  	}								\
> >  } while (0)
> >
> >  #define MT_WARN_ON(__tree, __x)  ({					\
> > +	static bool __warned;						\
> >  	int ret = !!(__x);						\
> >  	atomic_inc(&maple_tree_tests_run);				\
> > -	if (ret) {							\
> > -		pr_info("WARN at %s:%d (%u)\n",				\
> > -		__func__, __LINE__, __x);				\
> > +	if (!ret) {							\
> > +		atomic_inc(&maple_tree_tests_passed);			\
> > +	} else if (!__warned) {						\
> > +		__warned = true;					\
> > +		pr_info("WARN at %s:%d\n",				\
> > +		__func__, __LINE__);					\
> >  		mt_dump(__tree, mt_dump_hex);				\
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > -	} else {							\
> > -		atomic_inc(&maple_tree_tests_passed);			\
> > +		WARN_ON(1);						\
> >  	}								\
> >  	unlikely(ret);							\
> >  })
> >
> >  #define MAS_WARN_ON(__mas, __x) ({					\
> > +	static bool __warned;						\
> >  	int ret = !!(__x);						\
> >  	atomic_inc(&maple_tree_tests_run);				\
> > -	if (ret) {							\
> > -		pr_info("WARN at %s:%d (%u)\n",				\
> > -		__func__, __LINE__, __x);				\
> > +	if (!ret) {							\
> > +		atomic_inc(&maple_tree_tests_passed);			\
> > +	} else if (!__warned) {						\
> > +		__warned = true;					\
> > +		pr_info("WARN at %s:%d\n",				\
> > +		__func__, __LINE__);					\
> >  		mas_dump(__mas);					\
> >  		mt_dump((__mas)->tree, mt_dump_hex);			\
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > -	} else {							\
> > -		atomic_inc(&maple_tree_tests_passed);			\
> > +		WARN_ON(1);						\
> >  	}								\
> >  	unlikely(ret);							\
> >  })
> >
> >  #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
> > +	static bool __warned;						\
> >  	int ret = !!(__x);						\
> >  	atomic_inc(&maple_tree_tests_run);				\
> > -	if (ret) {							\
> > -		pr_info("WARN at %s:%d (%u)\n",				\
> > -		__func__, __LINE__, __x);				\
> > +	if (!ret) {							\
> > +		atomic_inc(&maple_tree_tests_passed);			\
> > +	} else if (!__warned) {						\
> > +		__warned = true;					\
> > +		pr_info("WARN at %s:%d\n",				\
> > +		__func__, __LINE__);					\
> >  		mas_wr_dump(__wrmas);					\
> >  		mas_dump((__wrmas)->mas);				\
> >  		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
> >  		pr_info("Pass: %u Run:%u\n",				\
> >  			atomic_read(&maple_tree_tests_passed),		\
> >  			atomic_read(&maple_tree_tests_run));		\
> > -		dump_stack();						\
> > -	} else {							\
> > -		atomic_inc(&maple_tree_tests_passed);			\
> > +		WARN_ON(1);						\
> >  	}								\
> >  	unlikely(ret);							\
> >  })
> > @@ -776,9 +782,9 @@ void mt_cache_shrink(void);
> >  #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
> >  #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
> >  #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
> > -#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
> > -#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
> > -#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
> > +#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
> > +#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
> > +#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
> >  #endif /* CONFIG_DEBUG_MAPLE_TREE */
> >
> >  /**
> > --
> > 2.47.3
> >
> 
> --
> Cheers, Lorenzo

