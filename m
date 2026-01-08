Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A9ED1D494
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D07A6B0088; Thu,  8 Jan 2026 16:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D846B0093; Thu,  8 Jan 2026 16:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9F26B0095; Thu,  8 Jan 2026 16:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A65A6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:28:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E25CB8B380
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:28:54 +0000 (UTC)
X-FDA: 84310086588.16.7FEB2C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 457EBC0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:28:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b8QOh+mY;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767907733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7wNp29pi+Y0iKY7i8OpoU4JUiHg2k6ezr6eGZ+Lw/k=;
	b=Qwg2qtPBGoFwDmHYTBUyecMguXrqjhUs6umqMCGDaWWFzp9ciQhPbOxZ1Xa15s5SnIH9HT
	qmYo4TzaWBlqSRE3dgrxjZ38kcnmiZaBArmfctceCCQ28YuIYVmYSvDegc3Y6DHAe+Xy8M
	E957uLKvpLGhU00YjKykrbEcVEkDH1M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b8QOh+mY;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767907733; a=rsa-sha256;
	cv=none;
	b=gTVWOXXKnELRg1sSOp89UlJcn30eMkZPZzhigYPzeNIJKBwYuqNaw/7VCfAfGYAae2Ad/r
	bg+eZzAdMXCimapnDVK6A+g8J+1WAjv+WfblmiQHCSDNHvnORZhPbVBmqKO0IUAWpkrcKv
	SRToku0UUyHmxoxxfnq+FTcbqniDRBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C5DD60130;
	Thu,  8 Jan 2026 21:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2ABC19421;
	Thu,  8 Jan 2026 21:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767907732;
	bh=nQwKD5GkV//Z8D4OWEudEfPuww3mHD9u3zSANae+Gms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b8QOh+mY/lUlw15paCcPsXhQa9G2Q64vnD465C/TmnlZmJOSgDbJ2UVzqgHtP4GKA
	 RwM9PgZFfl29Dn/qy8WqHHhdoJVG6Q4U1dhpseM0utFcsotwB4uO3aQfvO1S0BQgzd
	 /K502UcXbROCfTqOA71Qgqj7sMD+rdaR+GWjZE+w=
Date: Thu, 8 Jan 2026 13:28:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix relative path
 handling
Message-Id: <20260108132851.bb6b7813277a5b40ba3aec8f@linux-foundation.org>
In-Reply-To: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
References: <20260108031604.12379-1-sun.jian.kdev@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 457EBC0005
X-Stat-Signature: bgkuaf9wa7856h3ep9oqomzgej93m4tg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767907733-778488
X-HE-Meta: U2FsdGVkX1/pOPWcYiDPUrDcN+oizkRKR0reogPGlrjK71gw/dY7f6mF7yGVDjWc3Inv3Qg9i6Qfz+jNlJfH58hiiBOxnxAVqba6qOeAP3hj6WjXFLGMKPRy1Uo9Eo+OVjRNAoyJSfEDC000FP/w6QOXwxw5QhpDBqfyaLsbZ4B7k61Hfl8gkWhx6/1BoIFpArQODpI0PO/oM/yRbsnKH5APdUyv3qThPzlvqeIx2GL1AB9EeTKzBNuDsI07F7myHHmxIjRB4ewbMOHe+4bM0YBvyrPZ6Hgk/Vsi75GMqdYL0XUA7/oVFl/uEG3jQq/GbZSqMBIjhjKtahZI2wdyAFgawhaaGypfmDkAoozufyWlXXTTIU+E36u4no8xs+mz7g+g6MF/dSLeun4VPkZBiHV0dIH++7O2lccc9TZp3NAWhJIpTYEZRcdWB5qCOBk3zoK7PhyS8Nna5/rAjuSsp0Dpx9a/07LXDj8SGrxjKvNS50YCq95khdhWqdK7rtq5j39qyF7nfhY3WcM6MGf7RnjMAysS8mnVJblmPjP9I24jhQMvFDWPpAbvHDMX1niuCCFjqixAVloPlqqXQy2siCVAoyrRAWfFHwGfkxp1k14WKvgy2rhtQWHPsx6uzILqyaDj9XKg8Me/84c9QiQLO/hmUQaMtaaNZICZ7pqRo8vDc8aZMLhLllHuEHXz5F3Gsld8q8UWASjMXA3CzJt88lrN98TvFRLF7n4rtuQklc9FSAUM8MWMSQXyGGHwmtr0hgQWzj6APNdzmMK7yQna3yeOPToFx8J/ndDmEl6ExzWcwM82BPjdqNiCDpf1RlBTmihpT5EPCeXPs6SDOo3DtqWB+7eGVQ/3jzZ7JkD3fc5WA41655Zw9JAP7RZyDf2nfv0lzGOX/cn4EqHmgsvskrGsPDlVhB4EWQvKXHwNXcAm4dtnskaxYCQC9CUTRiMI9guuO8FZaMacEoCkdyX
 WGAfmJyk
 pjNKP4/3QF+N3lZ6HykwuNScKXX+ogUeAEkKk65ainZLb63cRk/LNHqPrK8EE1UN9hvNNJ388S2mhdACF1xN+c6M+j64rP8BJZLC8QO/K53LC9YJGvMgGUsmwdBUE2WGkcCCr2rD6BjjEVs/2UNtOOt9kfbnQL/6KWHLgBC7HYJ9kRnCHXRDt19yQBGvi3psvkG9ntagrkgECt/Std5Dvn5wiOg1eOcamajI1I2H7NLn2/t7ThMWAFwnl3GFGkdFsN32akABjBOGa70zSrkXABsW/ClqDy/yAD9zgtiUykbHWLmx3wTAQqlgoPWpSOn+pPz83FYc+cpYmVuIL6yei0PpLhSPwIkXsUkw8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 11:16:04 +0800 Sun Jian <sun.jian.kdev@gmail.com> wrote:

> run_vmtests.sh relies on being invoked from its own directory and uses
> relative paths to run tests.
> 
> Change to the script directory at startup so it can be run from any
> working directory without failing.
> 
> ...
>

hm, why?  Is that a thing people actually do?

Is anyone going to actually test this feature?

> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -5,6 +5,10 @@
>  # Kselftest framework requirement - SKIP code is 4.
>  ksft_skip=4
>  
> +# Ensure relative paths work regardless of caller's cwd.
> +SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
> +cd "$SCRIPT_DIR" || exit 1
> +

Alternatively we could check that we're in the correct directory and
error out if not.


