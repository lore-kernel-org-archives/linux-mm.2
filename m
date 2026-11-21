Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055E4606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfOJU2OB
Received: by kanga.kvack.org (Postfix)
	id 0ACAA6B00EF; Sat, 21 Nov 2026 12:22:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0360F6B05B0; Sat, 21 Nov 2026 12:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E402C6B05B1; Sat, 21 Nov 2026 12:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF5B36B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:21:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38B4214058F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:21:59 +0000 (UTC)
X-FDA: 85459793958.27.50C7CC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95906100002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:21:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfOJU2OB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795281717;
	b=Spu9tYKriZ7s7ZqdV354C0DtMl6Sa+uJetv/ZN/hQI2dduV2Ap2s9pM+Lwr462r41QR1zZ
	3Evod3mOqlYDXab8jye358xToyjmKXiaLEXiX+yUSD1T9FfXxwcm5ReEvmN/f4SunBYlVx
	TCbLx3g9n93kvFPWuTayeDDE2G9zxLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795281717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohIR6Qw82vrbkY4AEMlZ5OFiQyPze3nGc8ZbxW8VQNk=;
	b=QxvNrGf8xTm1mQsIaakADusXkrQzRvtAdQUBIs/MVegDOryR4s7YbSggeAc8sXe7XwUUW4
	8439ybIaloXXOZMBDAkgWwAhSSHx68ttG9uUCsheAs6UwQg5sVeDsfg8ed1YbDb5FOt9KF
	h2A5Pfj7HK+gnMTL3iVdGDjje7b8hGc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfOJU2OB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 13B3760DDF;
	Sat, 21 Nov 2026 17:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 34F461F000C0;
	Sat, 21 Nov 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795281716;
	bh=ohIR6Qw82vrbkY4AEMlZ5OFiQyPze3nGc8ZbxW8VQNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MfOJU2OB8lw5gSY9BnMmPvchn99+EsG8UzO4ZvAUo1WYMnnEcq9l22P9SFCMIfG97
	 6g1DB1fPOHkkhNeQyatKx6xx82XIKQq6NmVa7ROmN01aXYxgdXSh+pSXWh7ZQo9nrb
	 VuEg7DF7+VCLLHrN2rKKof0hdINX2MahCtu7DK97H5v+99TQtkYaYP+EmJrWbSPfZ8
	 w+WXxHVoDa4iCMOGX0YxSgkypG1gOGZhRWzBQzr6JMwomnHh5KIaqjJJWoMW3McUpJ
	 apwmVODt2VzXn5CnaPnu7Ie+YskEZN+V3ZYeFSpJHkDC8zS5rqBo7LJqcHZFHJxnLg
	 NMzrk1GVnTNEg==
Date: Sat, 21 Nov 2026 19:21:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 25/25] MAINTAINERS: Add entry for ROOT NAMESPACE
Message-ID: <awHTMNdonDO8IQtF@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-26-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-26-jarkko@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95906100002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tk7rk8ezucxegpgborwcmaxe7u47oh8h
X-HE-Tag: 1795281717-285131
X-HE-Meta: U2FsdGVkX18s7lObGEb6RqAQ92Eo5npAgWIrvCJI07GYqUs2OqNMHxd1UX57xXPO/DD5829TpN4TpyCbqqbgDZgOsXMY7jL1rrt7o/qnwxnpc3QR+dssU9nr4damhfTY/5F1/X6T8UyVRb+tdbgo1aV/z6V7ZGy8W6+E6O8NOnPwIkoD2KQmsQ/6WoXOmCHAZ4tEa6BPJsM8EuhHTbAFqlu1Sbbv4xmlCvtOVyYDNKI1BAGQZq4dyoEByw4rz7iHLwdokgF/OxsbqSrc1wHK27Q/xuPSpNxbKHUfJNRbWMrV9T+WJZEAiIEX/P0G8A8kbnR/4gwT3wpMd5TnnG/sQPPnAo3ytGHJNS4o1LPf9cEpli0n0VNRFAzvVBshliWZaMSPh9N78wxHy18ulCvrQtjzJVGccniHtNRBS1Xu0STLY2D/0X065n0Gnw2lWUzHYvELzVTgSy3iRLxGt6WSlcyaEUeas/MATjVyC7OLICIKlxHC126necDA3G3yHwroedygbWZ66PYEtrMKCQGCgkAGNme4njIjmFHUvy4YqdeaxQjn9Yg5SWCleiJnmCEFjpjT/N0hbhi3erQrAGQew6Fc39Jw+PhoCB/ONKHOWYSjZfSkrbW3wxdz8Z0uBpPpDA4hEFeBtQ//cEGvEZyND4FR4uoccI4Kv0DCLpQ2zLLWgSgZo1cjCQXdyILvx07Y9ztR94cxKg4V8UGQHlYGd10zewR/pXh/e/Za01w1IUYWmu20VJGb1BNXEYhhTpP/PCQae0b2JjLDVimqqZdHwDa+0I+4/2FuMMLQyLKx4P7mrTyiNNfDT9EEgdCTsi1fdp5NEmIIQQgaGzjfwFkJRf/zJJADj3lz4CfV20mF6YHal9OWY5xBM0cqohn3s8aaFTScSOsnKzSQ+bWUWob8WRcy+i/sTazMJPuDgsS1yNV9CjvdVFW/O3gNpG0/E+j1G0HkOm9b28AwwLRk7QD
 3vbzD3CE
 wIpU0PMtJW2zjD/fU6z81HdzyIO+OPhPVEKq0rrMztYkFVcInjRHSbfAI6ra9DsmpZ/ZcVFK6pFmcDrXN1q9nB+OxunJfn8+kpVWR98g3H2IT9yMKGSs5gr+ruUemomWILDPPkkbWy8UOufu80fViJsEdpwbvpelkizFQuba7QiApbt61oCTKdxF7vDBdNSgfTFmaV8osEvmm7sWY/weqgr8HuWd87LfIkdWJICs0DYt5uVRikUm7KIyLacMIMKCWpf/ckl7ZeC0EUvAylopcJqwSUXysxNAjg/VBlvOwDD4C4eLiyYTEN46HpIolhptyqHNuP5dkaKyRhBFcNdqFZM44bLzARCxvZXnkxLKEANAEfqQRof/8u28B7ujpnFbDjo468yh/pUh3gEof0pbSgmM2af5qlpoEuniw7YqYrRu8I1iUqmeBLp/xSQyj9KfstUeIX9knbQTUIlhx3RfF/vfu9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:44AM +0200, Jarkko Sakkinen wrote:
> Record maintainership and mailing list routing for the root namespace
> subsystem across its uAPI headers, core implementation, documentation,
> and selftests.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  MAINTAINERS | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7cbce21ba45a..072be5ec7fd8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
>  F:	include/linux/mfd/rohm-generic.h
>  F:	include/linux/mfd/rohm-shared.h
>  
> +ROOT NAMESPACE

Out-of-date.

Not sure if rootns is a great name overall, it just randomly picked WiP
name. What gets produced are opaque fd-bound containers so maybe even
calling syscall as container() would not be such a bad idea (unweighted
and unconsidered idea).

Br, Jarkko

