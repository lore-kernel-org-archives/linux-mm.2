Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C187FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4F06B0088; Thu, 30 Apr 2026 10:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CE96B008C; Thu, 30 Apr 2026 10:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9926B0092; Thu, 30 Apr 2026 10:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF5D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:00:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F0B4433BE
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:40:19 +0000 (UTC)
X-FDA: 84715331358.02.0CFEF57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44CB018000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:40:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VWLOgp/7";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlXVNabpIV+9bt7j7uIr1ECIm42zuG69qg1vVniiQ9A=;
	b=lpSYQ16WYWJMtEninHfnbYgDRZ7Ec96YGzohbOqAKMmF9Z2szm67H1TAXd1aYLYKuuxwS1
	Ke2x5eLtj4cKA1MP892QuTnYU6l5H1WhY/yXk5S91Ola6mn92r+KOSsvvqLkByYMGhDJRh
	/fL5s1/HcPy3QQHvjGIdc+LsGy2v1U8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VWLOgp/7";
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556417; a=rsa-sha256;
	cv=none;
	b=LQOsUhy6Z1R67etirA1Hh6dwJgIMj7kRz0wNdYK0AtL7Le+eZxHyrHJz2VGhVe6QGULNQw
	rXCj5de3HVT3QIPGrmzb3fPf/bg7PLGW9c5xr9Aol/bTURd09kS4MOLf7h4aTSWi2n6+dx
	OiQw6TxjDOha0bxHQTusiacsDbnt1+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A74860142;
	Thu, 30 Apr 2026 13:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BA0C2BCB3;
	Thu, 30 Apr 2026 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777556416;
	bh=7U8ayXs8dLaDtAfBoZdyIo0zZFSxc/yxzpat1zXZUMw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VWLOgp/7lmtUIlfIBQsumZu9DqNoyrI6AFV/UJZFNKHwi3s2WunGOAVYOtVpexm0H
	 oo3XENSmWYRSIE31RiCAYVpqkRwPC1RuQuBRkO0UBZpZrwLJBv9InZA0xaL/JlZyFz
	 eNklDEVLen2i/TmnQzAjSQbPLDsR4hH/R8BYHQncZETlDt2g87pUfun60PtKxa0VYw
	 6aoAt2KanmXWVK41cR2Sx9eJImTYV5lwIjdNAjColajbxOEgjmfGWfgNLEsl/Hplp9
	 XfTzLgIdw6QK5Feg2nPX+FgGRJGZ4kaCeL5TuBCAACgag/3t6JDueiFS+a77nEbkaR
	 DRcbb6fDXV/nA==
Message-ID: <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
Date: Thu, 30 Apr 2026 15:40:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
Content-Language: en-US
To: Marco Elver <elver@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
 llvm@lists.linux.dev, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20260424132427.2703076-1-elver@google.com>
 <20260424132427.2703076-2-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260424132427.2703076-2-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44CB018000C
X-Rspam-User: 
X-Stat-Signature: mubre6ym58gkcn3jrtqhr47yuarj4y6r
X-HE-Tag: 1777556417-963556
X-HE-Meta: U2FsdGVkX1/CaRIwEaSU0om9aup3KIm+7CnlRjiwNgnF8XqYmGPJ0o9DCZcKSsfFGsZupSDG8LHydsBMWXqDYMV6UdhbioxB0r6kn3jWAk0H0csvW8/wlZz/1Ea1QIKPsWG1LXjxd0RyhL1L9bADR/ZRafArqWQ0RQx6kxKeF6SxWgo37infCnr/Ic8CU2Bn2fX7zZauvbyck0K/LzEs6KV4SN01tM42+qYpx+R7QKGdUoJGu5LiNeRdCYYjAunWKUNfNSxIwnF6fHuofrfQfPm2iOlA6UHPfAV5YKvqTOAN/RwYTorp+W8icu0hSOmI51wkWWr4qfVN0cE1zmsd/5ZliPea5EeLEQ45BpVoqj4R6exWXlsJk49dypK4yG/A0aXE55pXvblB87DQjrZTLd6D5JFOfLCgg5Gny1KrSLiFY63sTBlglxyI3KuI+bgvCSgu1PQ5+2rTbuDEMz1PM/O27ykuWIYZVSdNBGl8fhlMI/zPCybq5iJfz9taFk8NERtzBgD6BrAnKS3gKyzMjt5Uk4229ezSoRzc4rl53mtsV+aegkft6onVMmvk1MgaNKeYlLxktl/KUWW/hazTWkikpaJHjM6uAzFHBfG6ZdUPP4JybPE9L4Sy9HCj/pvmBLFNjGmpsxUfIUbsryWc/kOe9xCTlZUTEWTBpXF6nNYwamRBkeaZQeZky0zEpbqXRDbF4ozoFxGIYSZfwClB5MNnu61uYSKE5ldzWie1bAWdHojKdnwSJzvZFUsTmwqgCqQvgdDaTkcgsC5SUTGVI2QYZ0Pr1S+AAFbYF4421Fzfvj9i2gXgdVXcg35Lhq/CCyiUcvkVfm0182YUpzAKYcc9ds73hBOCiBnXwailISXsKpMcbylQ7mNzZU7+5KLXE6KW9OOD3+PZIdGONmSPRr8cOy1rfWIX+wnhRAg1TogW4Amiw/UPNvUGTIWqzIg0YXQ2lMwSkKrdx7IT2KO
 Kbo0hheS
 BK9aIq01kMbDxWDnt2Nxhlyg9fmIRbfeiihkvIE1hR2pDLYKJJHBoAfF6cTeL13rcE/0c1kbWeMF55lLbk3sWQDsF9BeYB+TvEvnLE3M8GwHNAUeVfrYRzCC/MUv2E14mUS5EVV7PgCzH/QB1UWI4PVbWX/xzYolHnzPcKdZAbt+CqFt9zYDyCzMLcBUKW85yDQ3oGATDYp7pzO/Ws7cEuHvntpudTr7fYOSvldAcYgYErOB/6X2W4bzermbU+0St9amELS3yFmbyAG4HhBF5YYtM9Rd6BydD9+XeWNqmT3oCjjzbDObiNLvYyQ2Hl9RyiN+2lERTusizeRisjjvS2Unbimnqy6nJFFrfruLo1XKoRMj0ztmh16KWKZbdgB7XkKlAsNwhXt4tLEnN669i8r4bWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 15:24, Marco Elver wrote:
> The mm-api kernel-doc comments have been broken for a while, as many
> documented symbols shifted from being direct function definitions to
> macros wrapping _noprof implementations during the introduction of
> allocation tagging (starting with commit 7bd230a26648 "mm/slab: enable
> slab allocation tagging for kmalloc and friends").
> 
> When the kernel-doc block remains above the internal implementation
> function but uses the public API name, the documentation generator fails
> to associate the documented symbol and generates warnings and fails to
> emit the documentation.
> 
> Fix this by:
> 
> 1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
>    them directly above the user-facing macros.
> 
> 2. Converting the variadic macros for the documented APIs to use
>    explicit arguments.
> 
> No functional change intended.
> 
> Signed-off-by: Marco Elver <elver@google.com>

+Cc Jon

I thought it was supposed to work because the kernel-doc scripts were at the
time taught by commit 51a7bf0238c2 ("scripts/kernel-doc: drop "_noprof" on
function prototypes") to handle _noprof. In the current form git grep finds:

tools/lib/python/kdoc/kdoc_parser.py:        suffixes = [ '_noprof' ]
tools/lib/python/kdoc/xforms_lists.py:        (KernRe("_noprof"), ""),

Doesn't it work for you then?


