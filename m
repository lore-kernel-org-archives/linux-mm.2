Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1CB606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qTBHxcXN
Received: by kanga.kvack.org (Postfix)
	id 096EB6B05B2; Thu, 26 Nov 2026 02:26:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047AB6B05B5; Thu, 26 Nov 2026 02:26:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F886B05B6; Thu, 26 Nov 2026 02:26:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7122D6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:26:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A9C6120319
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:26:28 +0000 (UTC)
X-FDA: 85476437256.18.FCA9DD6
Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	by imf12.hostedemail.com (Postfix) with ESMTP id B1F3640004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:26:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qTBHxcXN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795677986;
	b=3mNYW6eVJvwN81SEUgX0n8Tn4MfwWpDhC6C3xei9c4DbK4xUNGbBmCRN58YZCxSqvgahyc
	PUth+dSoQi9H1JE1h9zaNdW1ZyNOErFbsl2vEq5sYBgdDV1gosRKdhdYwVtXzw4+cB4fSb
	h2QNu1ai1npytuwwo3kuEzQJKvIHCy8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795677986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXhMDzXROUrP6zH1iZr5JFVo7mUfWfuBS1RHTgeL3j8=;
	b=NSVma6Gs8fFIaXkHXaUZ9nmk1i7azd5xeTMdMKaJ3/CFVzXyF1mh2YHp5Qa7GbOHbiQ4/y
	SPK+XAphYq4RiBDn9eg0ZlomTgb2ebWOJjrfIaa9FSB6fzAs5nQi12pW//jsU5fA9724l3
	JKW6/DGzsRKEtxI31ZXFkVL4Tmi023Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qTBHxcXN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.33 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gTa+FiRs62WDz953uXBqnXtabhJGkFZlwN7q3IrHJlo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795677979; v=1; x=1796282779;
 b=qTBHxcXNo9wpdFVX4/9vyn5CsJkqvoP2n2NrDcR9wU/4c72xEeDFykQo42MC4jSgpUujmqSG
 /VYXdCHRp/W772hYUdeePXahXtmlEkS5cslQLM908tDWjK/6LiXRs7xWrb7Cf6VFG+EFHKqPTaG
 bTme7vtbfDYW3oF0eL7Vj15A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id df473b4b10cf1edd;
	Thu, 26 Nov 2026 07:26:19 +0000
X-Mizu-Trace-ID: df473b4b10cf1edd
X-Migadu-Flow: FLOW_OUT
Message-ID: <dd0a62f4-b6e2-409a-8863-7e2903179e3b@linux.dev>
Date: Thu, 26 Nov 2026 15:26:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/27] mm/damon/sysfs: add admin/reports/ directory
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-5-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-5-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1F3640004
X-Stat-Signature: p8boqf9atpffz315fffjt94qatfkegy9
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795677984-707924
X-HE-Meta: U2FsdGVkX18F1XbT06C+PZAQ1cr1IGHhHzfAB1oFvPZVYF97es68nDa7BCXlUtdFLgtz7F85HFWy5Yx+KaaYrSc2ZEoyQXpypDQpT41zMCVyPfwZMoIry9S7J88OhR5PTNwDXXDu8HZ+SI46hpLDc/T9P/FENJ8OOrsR8FZPWwmnbdtSDliHbFyX5hWZD9eb24O/XQpS0g3uJBAXjsT9Cg0aw1uHGGtCfmHevPfq1tunv0gkKbP2osN2fPkafjgnLf8GJlAnVOJbjrIhjaQMw3vbPFGccVSTzkZqV9QCT7/LMhymuBzKokNo7GWuA+6GE7SGYrhEDnK9Wv0FKf80lpJv6Pc/jFsuVzFMhJkGSBPsSZNuECoOrgtJwi5RCw3w1kbW/rJJHUEmyIgdxKCvNosBB9SWIwJNUYWgWBRQc6DeQLQeBw+fIFfFuzOOvfeS3rJXyj+JcPuboy8mP+0Zqjtl0+hQb/sP3Ldc/Yi5/RDKSGTxhaubbbw2Scwg0GYk41GKGjMzxp4u8Hwor52O9Hb+AK9SzqUF9FMM+YwIxDiauQXEIJ9EO9byX1FQ+E3P6eaEifFfLls4yZM2E3M/nURmHpL+uKIXfyj8JaTqN6y38j3nsomHG/LKVZmAk0Whh3VZ1jVe6oxLBMuwMbh7xEfayrtcBdKOZ04PdpNS7gK69GqPnS2WFX7og73RSrd8bWMvBY6APIoBpey8R5ANjT1FpOLEIylj1pTywSybM5s4Zi/O6IfPNdPvqUY5wZoET6oY1cXxsKaoxHOtJtJ2p+GuovRHn5e6ECwBFnjxKqJmulnInc4wbbn8mpN6xLU03zsM6AycMh9Gy+JkAPJaII3vpaUun9VcK40HDIeFZqQiqjr9tHx44WOEFaA1Zts1YwE+ruqlhwTMwa9lhkkFbjivBUxt8lMuvdz+l+u3V/IBI7YZBFk1CKtHixFUp3ABg4zAf6UTw9Epq+eEDJJ
 Zf6TOvPv
 nv9XZBHmFHVPLbGb6vQ4D+iKILKZP45P0skQJEnZkGeI6zm+r2mC/V/6jgFAfsnfn/2Ebfs+/+jB/Go9LLpQgWYMKM/T3TedFd0jyMoLJwqfaYidnjQM2MKch5AF2R2OMh89b3bC3dewr9zX4dQXJYt1NiFiDT0VE/vUt8W9A345WcUJR8vFsjgoKvsFNt72Pd94UURt+mO7vfbdqscHAxl1cUVyNF/3EmxX2mVaWy5rW/tuSn96PKjoE235oef/GD2PStPe9BJSYASauoen7Iq1dWH7B93aGktlOkt3QRG0qipBG5ZoXhFUBtDrHKrZNU5+OMbyhtWUsZ2Bun3M3/NpadGgDn+lrOqUjQtrphT8ZfVxV2e1pUBhG3UOzAMnJn+NsdGb4XblkVMjIzaQ7ZIlttW9SGaiXUSyC9gLWPjc8yS1FcuEIWQslbB0Lsid/SpzHrYdJmYCdGJKMUfrIi4530tHNyOvMkWOY0FRdTa2pr3JH18ZAcIx5hl9R56QR3MrqWkJk8Lhq8g4Y3NelwZ39n4ThuuEGe3aeLkgertM1/qo38RrCVa9hOh0Yh+jveTCpEez8Q3v145jWhJEkiM+gsuKWZ5srK5EarcrUzthKKe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Add a new sysfs directory, reports/, as a place holder for sysfs files
> that will be used for controlling the data attribute report system.  Put
> the directory under the admin/ directory, next to kdamonds/ directory.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

