Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E370CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA0C6B0093; Tue, 26 May 2026 04:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA646B0095; Tue, 26 May 2026 04:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A076B0096; Tue, 26 May 2026 04:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52BE6B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:19:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D2941C12C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:19:28 +0000 (UTC)
X-FDA: 84808871616.17.046C96A
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf31.hostedemail.com (Postfix) with ESMTP id 48B1420002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:19:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N NMcuZo";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=t5TCYBJH;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779783566; a=rsa-sha256;
	cv=none;
	b=IPnJg21ekW82ybkt37KdPgPEmCxk6HWoCors65fwVseFEAQI/Eqh5NZCBQ6KFP9HDTsIa/
	s5CDoJsVSVKYPjC5dC0fb0WLKSrSly1254WgM4JbDauMHHPo0b2Fden63DLn0EF690rpjI
	w8D1aT6xANgXz9SwDeaeaFXBO2SHoXM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N NMcuZo";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=t5TCYBJH;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779783566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZv6DmRHsbAvyhU5VLHqEzbXbswDumT7KoHiGFwcjS4=;
	b=a1a+ZGvjyJ7oiqqXDCA/SUqQ7iypxps6BM0XmCW09KK7FSedtIZ5nAbS8UpfArezRFxovT
	CA4FqKqu3k4cEHwJfsD1YeXcLUe+4ZBOVTGNsJnqxpy77cKamM+J7AXgQfeEcoNjiDmNTS
	jb+2mNRmsduGYZNS+VtC/advbey6NBA=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id B6754130018A;
	Tue, 26 May 2026 04:19:23 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 26 May 2026 04:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779783563; x=
	1779790763; bh=NZv6DmRHsbAvyhU5VLHqEzbXbswDumT7KoHiGFwcjS4=; b=N
	NMcuZoz+vT7pqMT9TnQljKDBpFqwmj78ogb2CR1FVUjR7CUPaGx1vVq3CNfa7M82
	S3110WO9V/RGdvWxThX00e48cgLPfYpl1ZRqzhLsMWUPToefmbgPXWVFDvpZFdXb
	288BzcyB2SFw0DoyBMxh+SzDJ5hN/Vl/76AjAb913P6h8WO0hniYifZWNvKxz3fh
	JTzg6Q39Hu8iT2pAfccvgva58NQ69JdFJ1+YLoFXDz24WVPIp0oLJLQYS6B7XyYq
	QYEpiZqy50vhSEbHW5ZRjul4gyEs+9eOS7NZMpaZtebqe1aH9SbG7fGNUhvTS/TO
	W+IVlFJ5KWrzoy57toDuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779783563; x=1779790763; bh=NZv6DmRHsbAvyhU5VLHqEzbXbswDumT7KoH
	iGFwcjS4=; b=t5TCYBJHdLNsxFEkQbKmYIRZwBaRBimwbvFosqSH1njr1zWX3dk
	U+K+G51A46JPj2GKC1/4UgduhU96c7cJKe7O5hnYMYXtxAdWX76pcss1vKsXEdBL
	vxVZrE62joOcTKRogMh1o1DfJuG0iL+AupHtuv3QJgMRMo6/x7d9yVVjV8dEU1zH
	0+Mykptm9VkCm2Yomz1fsSi/2P27mSnmHEsQp0uDGsv37baf+INpQ94jM+RD2Hvp
	S41wC6ZwTaTkxx/npE1lUjOKmexInMoRem+E75HBNw9Vw5TF4SyDlDQFodUxyk7I
	9i+Cm9mdPRFeZmBU0aN4E7/p3W0eRZAwL5g==
X-ME-Sender: <xms:ilcVag74itIFR2KD_wU1wJSlcm08voAA3bWLKq-EJag-EaC0YAFgMQ>
    <xme:ilcVaqS6TVaRJD54bayaqHjFj_TQYXKKjT3erd6dre_vcN0HiTdJHgZi58ISD7DS3
    JMdk4h_P4wFHNCTQaUIVzVjPX5F6ZtY13AC2yvDoC3U7GsW-bg75Y4>
X-ME-Received: <xmr:ilcVapsVL30QWKNuN98-R1YfLYLH8u37eQOQUh7eeidHZTJI6KzgwRda7ZUvyw>
X-ME-Proxy-Cause: dmFkZTGg3NKGEoTEY919NCtnOF8MXOv3USa+FVzdfGv8gK+6Kmljj9Z7v+MEhBOmgQ4iJz
    2wkryOqsOOaL72yi/M9sWzEc2149MsMisNlSFsbjS2gc4WdjUB1aMMawTlxaNfjsVW9dII
    R0i7J6B+bwSd+x0K9fRdEAtCQLXpfvwBXFKonzv+hsxozQjCRiBrUq+9trag9LFaMeWwLw
    uYts+B7zg01wIjauFMjqZkURWggbx/h2EfR7rxs3yAa1jzHPFQB6AGBsGlpCUDRbV4j4de
    jUbsEfDZQWvNRB2FmLkOYhv1Ae+RJKanr0+cxI61K9142+8LcdCDjsJjTPJZpjHgmRfSgQ
    b+kVapfvL/TRnNIo1+vDt9AEIpEhNalldrNMDB+L2DR2+qi/krrW0BjTrxC8M44EYkHpAN
    Kog5k8r7BvYencRrXX6SRUvv0VVL6u/Auw+3NsY9Fh0/tYV7mlNNl4AWlrFhZvycIA4NiH
    ONClnHj1O33ouGoEDFDI39O4wIb4YKoe1EPycCPzb6U9bj+9euSdE0cxwudMTPiPgZPO3b
    JDeqtl1N2YoBjXClkgqSPQyFk9WzsxFVb4f929aLSmtQgLD+NVG33DcGNYTQVcUWqllkdF
    2Nx8b9c1sR6/BCQH0FN55gMnfx1/9tPuR8eIUD1QQK8Z+WovoWueBlV5a9JQ
X-ME-Proxy: <xmx:ilcVapt-OAd4UoTqoiR5yS5t8LDd5Ctkc9mueTqlIRgTFzkN-5qlJg>
    <xmx:ilcVahepuMvCuvNXf2n_WXImHh3faz3xDbTkrsj79OJ7BhUEtGrv0Q>
    <xmx:ilcVas6IGiIsnNh9XJE3GNP0qZP2olrro0gRqCCkw7ybgOCPdOd3zw>
    <xmx:ilcVaik7rIxQdrGwf_D1Jk3lXr5gbvOsZFsUyjUYtbRkAtDHtl0CtQ>
    <xmx:i1cVagYklGZxC9VVnFQWBN53-Kkuw3Gg3XrNoE5Iff-8cbhsP3341TpK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 04:19:20 -0400 (EDT)
Date: Tue, 26 May 2026 09:19:14 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 06/14] mm: preserve RWP marker across PTE rewrites
Message-ID: <ahVXF5gplFCK7HDc@thinkstation>
References: <20260525113737.1942478-7-kas@kernel.org>
 <20260525120819.C18561F000E9@smtp.kernel.org>
 <ahRk5tphnTx_CVnA@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahRk5tphnTx_CVnA@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48B1420002
X-Stat-Signature: ssfic85h4ia848xtsjq5jtujqqzf7h73
X-HE-Tag: 1779783566-413609
X-HE-Meta: U2FsdGVkX18HUjxogp29KPcQdi9U5W4hQJG52NwOQOYldnXzL+vW0ZN4Sc6pFUtriBX2+FsRlwdrQVPfss3f5r6LUPBznqPtz59gMgRdIdW2Dga1Cb5BGNJ+RYASNANHnfeKUReiSMRsrPa3qjsxNijAMVIsaS2VNFODPCZP0kpCeTGY0cmR5/u3Pi18wn+UySJu21eO52nSUm0lrztkRUvB2BX31TB6YzbYE0/lq4N8DNMTmCcZ9BgeHovaSAWW2wZbiKOKIzwIatR7QLV08X11a+dppce3L6gQ648+GtwrUU2OKxRrV1ImhrQ2zDXnHIXW4itYtDKdPJoiOjlhxV85kRnq2YlO/yqhKiJ7b/RqfQIcnIipJAhoyA1hJU6cV9xtR8/LsaHa74uA1av8Zf3IGpL/uX9+A/WR1R/8f5OQ8Vb2HFJvMFXWnGq4mjCv40Ubrw9KVSiewv1/eTod8uCY3m+TMfn57SX4Tx7a/ZCSYJda5Wu1dFRbGhPBTO0xukSAjs1nJlAoN8f0SrFfwwwAhB0zum2ngw4b0wyipSlz9JJRE/4a+1nUX2YIUUzIRrAlgwiITCA7lrakz3mVzuRIKpXKykFSEYr+9BrD+9DtJu6BemHtTuDHVxYfMD+euqty4gE6NV17eEJ3L6VMhpHN6cqhD1BnTEFy2RsRqbP4lZJocoZoprToFPV4dBpLQjTiqDUWkIAahSdynGGS9ClRz/ItrU2q2+Pe3mUZsQ6jJhJWXBJxZVwUqe1UoqRw7pMr2nK/de/34BJtyFmQhfRBxdxySWvuSOBIORc6Pjs4xekyqPh7qWhhl83dikgleeVQtBmKBZVH8ifHPgqMhyt0K68/xWEGivD/5YJWbldqN4CdgkWxGJB6VxZPlpmeUaEhON4QYNVEh2wADaI2MyohPFca9kLFB8/8m0Y46xNjCFaWzU0LBzpP3bH3RtXOtZwyuq0LT4yn9YjBH84
 V6XaUck5
 udiXcl4lWTWTOxHvcbuBijOADGBbS9t1JZv/CWafdKFU+oJm2QcNm+DoG8yW3SRD0yf1q8ksaXKZqI4NOVK1hsSfj25J8OJLchYDiEabyuTErTmGXYtXq1TXNFm7gc6lm1h1U2yLRCS/8674XHpSM4pvrJBKUmXRwTVuKRVOX2H2Mr5cWSKkCtbyIEb5hy6gHYnwhYhKGxxkJf7e1LiaXlfvA1CF2/ofpnFFYndh4D7YgujIWv7SH6XO3IkSYXavH85fBZBWq3vYK7+GNYPkDUsDtOp+IfSLhIL4vlHGF7ucnkd7osMZpj2aPFWj2qKah7R2m8d52h71WF9N+mWnBOL9i7YCKk79lTvxHuvXVpT5MXXEI6+25nIMrLAzEiimHU0kUBx2oMwJ9LCAmt2EVdxSevWwRmJfRnL9HgOigNM7Dc7lcVes3glwE42Qp+go4ddXtuvbuxEKOXq/OBpF7AITW0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 04:07:15PM +0100, Kiryl Shutsemau wrote:
> On Mon, May 25, 2026 at 12:08:19PM +0000, sashiko-bot@kernel.org wrote:
> > Pre-existing issues:
> > - [High] Failure to write-protect the destination PTE in
> > copy_present_page() completely bypasses UFFD_WP tracking for pinned
> > pages.
> 
> Confirmed and pre-existing -- copy_present_page() builds the dest PTE
> with maybe_mkwrite(pte_mkdirty(pte), dst_vma) and only adds the UFFD
> bit, never wrprotects. Will address in a separate fix after this
> series.

Looking closer, this is false alarm. pte_mkuffd() makes the PTE
write-protected. No change needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

