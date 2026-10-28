Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38896606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khWkVIOI
Received: by kanga.kvack.org (Postfix)
	id 3B4486B05B0; Wed, 28 Oct 2026 13:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B756B05B1; Wed, 28 Oct 2026 13:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A20F6B05B2; Wed, 28 Oct 2026 13:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 032686B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:54:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90CC1120196
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:54:55 +0000 (UTC)
X-FDA: 85372785750.26.81C1013
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5218100009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:54:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=khWkVIOI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793210094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6lgge4WdsOVmOEXha6YU4EWcAVpqL0HGPQBV5WSBkY=;
	b=Tm0e9tBrrMHOGuB7PT/kvsc+HTmh6aON4EWMeO7tmPulNRxQaQRycBfzT+s0KWHfFJskWr
	60tb/4X2e3D5SuwUUB06yIZ2NxuUMw/2MwLPgwoEF7Bt9mpLhcP9laAzMymMC/rw6kZ2ov
	hJrTLxCWbKsWTN+m8cde3Js5N6jboZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793210094;
	b=7I6cSbE0hCEt2LrD+CRJdKRQ53miZwZdIqFZ5wxspOZLxXm9Nvy7kqeH/ULt5LlaBMwJmr
	tKg7jf45TE8bAqJE4D60ZY3QSYvJ0dbGWjqex452jPuzU3Ubyb7PeI6EAYB6NfIdLftxnS
	FJ5AXYmiIHGxaQZWaCnp6/VLHn/LkpM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=khWkVIOI;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F37ED601F8;
	Wed, 28 Oct 2026 17:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8A01F01828;
	Wed, 28 Oct 2026 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793210092;
	bh=v6lgge4WdsOVmOEXha6YU4EWcAVpqL0HGPQBV5WSBkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=khWkVIOIxNRfDHMWRxAQtKPepjJau1mWH1tfNKVk66Ch1Lv9J7cPoDH51yRVQkwQe
	 lm9acNXE11ARvqj46A/Jyhi7EbsCe7jxWNp+QA+oIQecZm/cowX6xbtuw2ZcnMLeZW
	 F66i8Mn634THVYeZ8kW0a7P38yefWynfUloLYRA+QdcLjo8wWma67XNK0XQZydnh42
	 /vDm0n3McPffCVHg9YW7z8haJZkTA8RlJPH1/umGHKF2jPmhag50YsXMCtLexT4VbV
	 Ii/RzfMxlGoN8SWgNRUNR0nsu7SeT0M1r10FoZv6ArCr77yMxsJQbPadK4R3ESzy4a
	 4ho1RTRTgtRxw==
Date: Wed, 28 Oct 2026 17:54:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 3/4] maple_tree: Update internal warning and bug_on code
Message-ID: <auImniguGIVq6c_L@gremlin>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-4-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028154218.1668182-4-liam@infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5218100009
X-Stat-Signature: ujtu3bhcg65kstr3bcm9eiker7g5dj5r
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793210093-980491
X-HE-Meta: U2FsdGVkX19Bo+UnYCrcy4GFgDzXgtMHloATYrpcO1LgqquTD1TONFtro7ErH0YNAGBYEbOyclgNReRkEd6/nCl3rpcQp4blj7X6ohByDosmxUzIA0Tt10j0Q+yLmLrY07ad2Bkbia8RJjDmvtejkUTCCvtmS6o+clrkDbhaehii16Q/kFfX7DM7tPMdEFScSHiTaMDMDGUqujBPC14cN4TGofjHil/69hbzv3YvQ5Ym+aue0ZeXhAuelX0SU3A+PksgnqdD/yim9f9iRGiGpM3GuPfPS1zdue7JvV8droCwllZ1aDw5+mFbV0sqgNUw/upFnlSLvXOLsXmeuMiXwx1IYF83bCulwU2xzItNDRJ+5oy4yRD4CI34GsTtDrnJ5M9FkV61mACMie/rynGo395k0gkUP4OUnbBOBwaVmym73dc3nO19qMuhVObddpGOcYyIy5VZX8Zg9temv4wzitiKTxHo2gATq3qE1/h56y+5Ao46MFwQfXqt6w+kQv39MxNTvQ5QZBPzJQgjjbgdzaTJkp+YPYB35F3VHaqmhkVKI80ia8Mej/1nSQTb0S3EqEoWr3Ud0FcVVilv91Gv5hq5nZr1WxepHXmrjpNx0xoTy7gPDzAJxAc6bRvTU0QaHdcpjUhmQ/W3LOeT1hNQI5XQO5PoNUMQIqDnooVK6FvRDYr8029ruQDacXfoRXk/1zLryscJSv4CJcg4GhD4tdqYhUcDK6PJkN3N2HmGM1bYzScVqxAfkITZJ7E82UnI27loIPfTkhJ2/6g0cHAl4TEsSJ/hEYltUlJhnT92YHq+5tV16IyhrxvzYBiATL4ZAsB/ksNHqrG8BI2FjBivqAJZvXSheJ1RXIpsVYg4XRmAi3YvO4H5/M+72FbYlokcSgiE3zBlZaD8DdTGtp34nWzWUABQH2SPMt/ojFhxFDKAZiCxxo7ba3HOU5LruawQXv8MNWPYerR7Z2eWehp
 lQgZ+a1/
 O8Ha/BBRkjcpc5GaXQpZp0MtECBrZaFA7ft7KubL3QvefLlGezk+dxsi3EUInIUnysKn5mKllNjD0iUn+adtAZwVMPT94cKF2hzmXH+zw/LWD4PumKThfF8WiDGekfVXTr8VFruiZ+yTvSQtrC9cWEm3Ijy90wRtoYmqYNie6O5qEOIj5lOxNDH1G/rJAZA+xgNjpehK26trOmd4Bsx/+M8pMVR+h3x9jKQj5Goch0iXxWCDQHTiPB3BthLcwPXwc3wpxAdyBCQlAAkDHRr5eJ4Uz1ZKBbRBwvUNWIUsoYD0NChWY7JdtfpB60yw5RmhbSOKdB90sJLaPqFZ5dadfVWvoDud+/NAcqG1qzpUIupaOz5+EcfoAsCjHB+ewXWRuLTPJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ma
 On Wed, Oct 28, 2026 at 11:42:17AM -0400, Liam R. Howlett (Google) wrote:
> When CONFIG_DEBUG_MAPLE_TREE is set, call the WARN_ON_ONCE() after the
> custom information is dumped about the tree.  Without using the kernel's
> WARN_ON calls, syzbot will not catch issues detected by this code.

Mega nit but commit message doesn't mention the BUG_ON() bits :)

>
> Update the non-debug code to call WARN_ON_ONCE() as well.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Lorenzo Stoakes <ljs@kernel.org>
> Fixes: bf857ddd21d0b ("maple_tree: move debug check to __mas_set_range()")

LLM overlord says bf857ddd21d0b only moved it, and f0a1f866aba1 actually
implemented it.

> Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>

Looks sensible to me from kernel perspective, but LLM overlord tells me this
changes the userland tests from asserting on dump_stack() to just printing
something out on WARN_ON().

(BUG_ON() is OK, it asserts already).

However we really do need this for the kernel so CONFIG_DEBUG_MAPLE_TREE
triggers syzbot and such, so maybe the userland bit can be a follow-up?

On that basis:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Or... maybe just respin with something actually, can fix it by updating the
shared maple tree testing header to make warn do something like this
(schlopped, apologies):

diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index 2a1e9a8594a2..112052e7201f 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -10,6 +10,30 @@
 #include <time.h>
 #include "linux/init.h"

+/*
+ * The tools/include/asm/bug.h WARN*() family only prints a message and
+ * carries on.  Nothing in the maple tree or VMA tests expects a warning, so
+ * treat one as a failure and abort at the site.
+ */
+#undef WARN
+#undef WARN_ON
+#undef WARN_ON_ONCE
+#undef WARN_ONCE
+
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on)) {					\
+		fprintf(stderr, "WARN at %s:%d: ", __FILE__, __LINE__);	\
+		fprintf(stderr, format);				\
+		abort();						\
+	}								\
+	unlikely(__ret_warn_on);					\
+})
+
+#define WARN_ON(condition)	WARN(condition, "%s\n", #condition)
+#define WARN_ON_ONCE(condition)	WARN_ON(condition)
+#define WARN_ONCE(condition, format...)	WARN(condition, format)

> ---
>  include/linux/maple_tree.h | 54 +++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index e30e57f5f3df9..0f96f1f19eb95 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -680,7 +680,7 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
> @@ -696,7 +696,7 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
> @@ -713,62 +713,68 @@ void mt_cache_shrink(void);
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> +		BUG_ON(1);						\
>  	} else {							\
>  		atomic_inc(&maple_tree_tests_passed);			\
>  	}								\
>  } while (0)
>
>  #define MT_WARN_ON(__tree, __x)  ({					\
> +	static bool __warned;						\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (!__warned) {						\
> +		__warned = true;					\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mt_dump(__tree, mt_dump_hex);				\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
>
>  #define MAS_WARN_ON(__mas, __x) ({					\
> +	static bool __warned;						\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (!__warned) {						\
> +		__warned = true;					\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mas_dump(__mas);					\
>  		mt_dump((__mas)->tree, mt_dump_hex);			\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
>
>  #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
> +	static bool __warned;						\
>  	int ret = !!(__x);						\
>  	atomic_inc(&maple_tree_tests_run);				\
> -	if (ret) {							\
> -		pr_info("WARN at %s:%d (%u)\n",				\
> -		__func__, __LINE__, __x);				\
> +	if (!ret) {							\
> +		atomic_inc(&maple_tree_tests_passed);			\
> +	} else if (!__warned) {						\
> +		__warned = true;					\
> +		pr_info("WARN at %s:%d\n",				\
> +		__func__, __LINE__);					\
>  		mas_wr_dump(__wrmas);					\
>  		mas_dump((__wrmas)->mas);				\
>  		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
>  		pr_info("Pass: %u Run:%u\n",				\
>  			atomic_read(&maple_tree_tests_passed),		\
>  			atomic_read(&maple_tree_tests_run));		\
> -		dump_stack();						\
> -	} else {							\
> -		atomic_inc(&maple_tree_tests_passed);			\
> +		WARN_ON(1);						\
>  	}								\
>  	unlikely(ret);							\
>  })
> @@ -776,9 +782,9 @@ void mt_cache_shrink(void);
>  #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
>  #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
>  #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
> -#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
> -#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
> -#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
> +#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
> +#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
> +#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
>  #endif /* CONFIG_DEBUG_MAPLE_TREE */
>
>  /**
> --
> 2.47.3
>

--
Cheers, Lorenzo

