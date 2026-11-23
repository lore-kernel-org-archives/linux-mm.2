Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238B0606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=ByF24ktn
Received: by kanga.kvack.org (Postfix)
	id 2DCD16B05B0; Mon, 23 Nov 2026 04:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D246B05B1; Mon, 23 Nov 2026 04:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3A26B05B2; Mon, 23 Nov 2026 04:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4C7C6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:06:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CDF3140827
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:06:47 +0000 (UTC)
X-FDA: 85465803654.15.D7F258B
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf30.hostedemail.com (Postfix) with ESMTP id C0BFA8000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:06:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=ByF24ktn;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf30.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424805;
	b=RIb9iflibJOb+bLQgvxJd5cARk6/WS/wS/t5/NjC/N/RkC8bBI3s+0h2DuWkEP6KqmqF+k
	R9VVnc1TZNVLwsG/lyWRqB0cc+CdoSIkpxMIW34MuEANVdd1XWEhOqYmujThFlPiR3CJs8
	dei1LVtkjzrtDxI9QXO+L8G9gHHaTAQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aszNWFm3AavU3Fw6Y6RtvpwqKpNfGOGtFmRMkuOvBq0=;
	b=6YsVP+qOpwCzRdlc/1OBqwsZ6U32kPH+VzhJBCiHq0PPmHEs7XvuXvUVRn2irF0Tr4UGWp
	+9+tMEEVeYHxXxnQvuZr+eD62GRupeB4YNmUQXL6H516WzeR2jWLSLu15Lr/IslgHTRRFF
	VPOJZxfRIhpaDxDDoHEtPTNKdmRyaHI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=ByF24ktn;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf30.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aszNWFm3AavU3Fw6Y6RtvpwqKpNfGOGtFmRMkuOvBq0=; 
	b=ByF24ktnu3YoMJEhhcWrvct1F6WCpHNZsauPWZ667prMGxTjbliQImxa0Mt4kWN9ueGby05UztW
	ay3SV/2JiGaTL+pLfXhSNkHR/eHB4J6gG/V1/9WlnETY7nRV/TXPAMJ2lSoetC5CoWs5tifvLbUW1
	7504tFDwrRf4qra+0MFVcns7siFxWBtt4XzVYicUQ92t9hdi1RdkeymNZ8Mg3Us2lgEXIgupLFxJz
	BcIVq6kaSDZahKXJykdT+815t1efSIVyde17MAJ6ATtav9IjdU1gXXjEGDDvp/fgbrZWmm1Y7ERiD
	XPlhp+sFQZn/mmjKpZ7+QM5ooEkeJs9VdUFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xVQ0L-00000000tqn-3uaG;
	Mon, 23 Nov 2026 17:06:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Nov 2026 17:06:29 +0800
Date: Mon, 23 Nov 2026 17:06:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <awQCFZSSng2LLGnX@gondor.apana.org.au>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-202709@kernel.org>
 <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0BFA8000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: sho64efauekjwzxstzgdpd94mmhq3fcq
X-HE-Tag: 1795424804-637175
X-HE-Meta: U2FsdGVkX1+bGL6ivwF8KgraS1BiHHiSls15Ox7qLJ6I+a028Se/xRvFMJd1v+WZfg3ayFBprrk5CfP1AqdnL6HaaQH5aLpAETIyMLEkXyFKdNTM236tbMrA+qAu2nK3wwwgJYc8K7w+HLQNbqWio3AiH/J+XhCXQZVtOXMWSLzadSGRO0Lo7znQy7BaJFAff4M7O4JL6CP3m8YKiqwaDsE6D3p6mKam4H0ACQ1PxO6jNVmFwjxCpXMDED+zTidayvwrYuaYcYskHN5WQVYVG4XVWizuvH4hC/VavuxJISX1Xe3oLjmjPciUXrAa2FNla9jzYQjrLQZbIjEGsT8+YSNzal4w8COOiM2eOH18oDXg0XKXUSBjYCeXjARI8vw7+z5hPBaeseCL4n+7W1sQ1uIPGmUctxNImjHy52jYd+wv1hJ7aBE1DyAJuoL5MBKJ9ZF+RXkzNA1DNnq9vS76cwV3k9W/0m1gosXB7rLnlaku3hX1qpnjmP1Bx6r3ua40zLiJ93dSIVKF60APr/cIcbGJa/TDWxtS7dEtTGJux5KBVMciFaBs9XgPjvGG9j3DzLSJkg08+1KAthCx1XXaIRaE9eh/sZDZhl1PxQFGQvSjYuoCwqIAKA6f+uf9V8NiAESHGbNB+qwawFRj9G0nZuJz3JqiXxh2Kz2AzzSo6Kn4WEcYSdwqKjwOqR177QEfh1D5kioeCpq5M6A44Ln+xNXgML8mva/5r/Zb3mTyi419saJYaQnfZeB7DTLmUTVQhyf4F0jOJFQR8GX3sjb7UpGvTAWd41Zrez9Aas0LfeDnc9vJKONl39G5qnc/AMRhp5YzZLFQNdhRP1cJ13RgHa0KSK+lGaF+l6CyIG9FOa+479WHOm7TtC6uJjmAOMlZE/+sO9p4AIllSFodJQIl+Bb6XHxvHS7KbqRINXaTn1DfHlAY6Xks+65S9oT8NsMYgMsi48JfGi10VFlxikI
 xpm/sp6d
 6BS3LAJTAtrYTEtXWixgC3XlK8S3Roa6SSILmXqqK5sA6jxSioDMPtbI2K+KOlxTfypTN45Z3YVvfFqiELIzrGPPyJSu2/ZgaR+utVYeKHEo0Tp8FA+jPbdgTEY+yZ4zFaN84xCPZwJxuU2hVvLvaajHiOKkHQmsstxCfan8Hlc1guSSJdNkDZfnJuf55WZzARMW0HpQMlnj1j4WJNWFs8/aqFEXNZvn+RnwLjIYi2VzcVSznhHHNasgZAAaPj7gJ4rA4pTDp6QiM+cXct1M1/WqNXVO37OXv3Q1+mGHn0PYvs3Isy8oAyJPA+m1pfy++zSkDLuJjOF7orAOlKo8j31BSDqPhtdT6gpk2RbDB2BX+h51zsZBjAEBDPCPiA/4obb23l29OEEmJePS9s90Du4zQLoXWoebEXCHIfrLVZDeev4FCaXldyt6IHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:24:19AM -0800, Kanchana P. Sridhar wrote:
>
> > [Severity: Medium]
> > Can acomp_reqchain_finish() corrupt the destination buffer when a request
> > with a non-zero req->unit_size uses virtual addresses?
> >
> > In struct acomp_req, dst and dvirt share an anonymous union.  When
> > acomp_do_req_chain() handles a virtual-address request
> > (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
> > buffer pointer into req->dvirt before acomp_restore_req() restores
> > req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
> > struct scatterlist * and overwrites 4 bytes inside the caller's output
> > buffer.
> >
> > In addition, acomp_do_req_chain() is called for decompression (comp == false),
> > so a decompression request with req->unit_size set will also hit the
> > compression-only req->slen > req->unit_size check and write to
> > req->dst->length.
> 
> Herbert, is it Ok if this can be addressed as a follow-on to this patch-series?

I think this case needs to be outlawed since our API doesn't support
virtual addresses being used for dst.

IOW the code needs to abort on entry if unit_size is set and virtual
addresses are used.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

