Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A89D606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R+N7uJ6C
Received: by kanga.kvack.org (Postfix)
	id 13D036B05B4; Mon, 16 Nov 2026 11:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDC96B05B5; Mon, 16 Nov 2026 11:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003BF6B05B6; Mon, 16 Nov 2026 11:29:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC37C6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:29:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 549C4140169
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:29:00 +0000 (UTC)
X-FDA: 85441516440.29.DA8819B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 65A5E40007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:28:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R+N7uJ6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794846538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s77Wh0jGQ82biYhvC+IxcW28aNcho8DkaL0D/lxzBTs=;
	b=fVlvc/D6vPsGjiQfBHx5/vWAUZPRySsCRo4E8DwfaPQEpWoAWTiCUo6D6PHVx0KmIGQIXP
	hDfH1DT9OerAwMEmcMoZYdpi2dNIMdwcdRcjGSkc5bqUAHBdhPEZHsvgSb3auRdjT7XvrZ
	LXBQWVhyqmVmjmlYZMFjCjh4FPvmxDY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R+N7uJ6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794846538;
	b=x5xkQpJZC2P9/RJzD/LRCWSswZBD9MmqZ4yriwGJM7Cx5PRhbaoioqZZTE6pLATvG84XZN
	KZZsxfemF1gOu/sf9uE84Jygut3CrSwf7SIlnTYhdlHLYsdozcMQTCqqHABitJiAOswTfl
	UKpQZfzMX0ZshN1YAJ8ZLcnlDswEv9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A591462F62;
	Mon, 16 Nov 2026 16:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA3E1F000CA;
	Mon, 16 Nov 2026 16:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794846537;
	bh=s77Wh0jGQ82biYhvC+IxcW28aNcho8DkaL0D/lxzBTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R+N7uJ6CVs7b5bWLMF4HnzoLO2LD3Gsadk9Q37GaxnC848Fialp//dIbuRkDUCgaP
	 aQLGRf+iUMwkA1qeX19lVqO+GIfs1vkymtf6T+8Bc1XHVH2IkaLVd4L+sxwEeKpRQb
	 CMA2S4lKD0R34zuXEQsbcmN203yfwTUtVTFyjYR4BWPx7Pmf/GNM2sa9WZnf+W3ArL
	 HwPuwbXUKwVXtYnn5ptTo1HSyFb7wGGG6HFHbfJnHSgKEW5+bowJHGm+lBs0yy6HaN
	 Z8IHFh2FpZi3j34C/z7o95PnzAjKAuVw/WX6t1IbTNLZ57rP2/HElwkHc7OKhkxfln
	 Hg08yRHrwVL+A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id A3AA4198003A;
	Mon, 16 Nov 2026 11:28:51 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 16 Nov 2026 11:28:54 -0500
X-ME-Sender: <xms:Qy_7arRLG_UdUq8qkXEY64ChlNdb-LHvpETpAU0Zyh3u2ujO9Z1OUg>
    <xme:Qy_7aqauMhLertWeNoutVTp3WOHQryiIEwrplJkYySJenfhzHpbO9rGldJn8Ggdb-
    QCEFyzJXf_5npbKbm1aLDBp4p_-91MF22M2HgFjqDgCCN-Sw-Ovm_s>
X-ME-Received: <xmr:Qy_7aoMSvgxEWgNaEKzT4wwcmsyaFttmuUwSFhQWUMSTolZBlcGk3vU6Q0E>
X-ME-Proxy-Cause: dmFkZTEHeSQUqRY1YhiGAt9xbok3Cz6xVJ5Xo3cfdcttzCYoRzXc8WXErePFu68Wle087D
    hXsQKfmFrb/APDBx0g1pr2Aa+HutXDgbWTbRTP7Oo4JH2epfiwmDtil9XvIHCmQRToNqD0
    H37WvBxy3jdygoEsZvmgMNfREfThGuE+f1/fQTxm/5o0v3LXAV6tA0KFr/8qm28SqLjKBC
    JIvQB7db13NmMEUQ6uicY6Wj1U2YPutN0ED61sQdotiWYJBY0erPuQxPjQAoZZKOHKEm1P
    CcSCuYQ79IWhDlSdDxsyaZJRWpg89Aij3uhmqBQtQttevR3Vm1wzASR/0SeNIObM2C2xnc
    RDA/5KFfa/eqjJkob8y6n3L2MsOHrmPlrRpVfQC4I7oC2NWb+2vU7DYstulbXClianeZvN
    hz6SpjO39Ug9ZQ9ldDmdTx8WrmCVG8/XGh2O8iMUMjsenDS7ogCZBAcLKOfGb5lwwV4BOy
    xMJxsm6FAEssW8JYs7csY51OzSNtNcNJf32P8O8w4Z+WCEbU1IgN4oDHIoGGPUqMaHSrpt
    WLylfruposUCDi1TPyDRkd3nHjmwduhDPEk6w0SUmiEfAuaYkx/jakAsxrW6kCFoaSF4NB
    GAlj9jnGsaNPLN0GfrTeUoHX6ZQNuRsSpHF4/7fYdpsUtSsVlNp6gigN1Y9g
X-ME-Proxy: <xmx:Qy_7ajNge65h59gJ5PeEE4jYojBTyP81J2yA0FOeaNDJOF898dHpPQ>
    <xmx:Qy_7asN_4RXOPsYejL8M9bOECto9bUKVRQOfA7r4uOzVXy-zSAocxw>
    <xmx:Qy_7avYYIK8u7x9s4QIZQgEyAGr7Qyrd0MSDYwg9VZwPuipYISLVug>
    <xmx:Qy_7aqjvvcj8KRi33l3BF_wnKOr2tP_Du7Vi1mYrMA_i-fhiCOXmkQ>
    <xmx:Qy_7arMWZXpiHu1sTF9s648ng43bZU-wyYhpHTqjt7OGLV8d113gqrBZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 11:28:50 -0500 (EST)
Date: Mon, 16 Nov 2026 16:28:49 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Peter Xu <peterx@redhat.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] Documentation/userfaultfd: document RWP behavior when
 the PTE is dropped
Message-ID: <avsu-yTSPKtZn_Ez@shutemov.name>
References: <20261116101004.15322-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116101004.15322-1-azpijr@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65A5E40007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ftioykfycn6nmkk531ihcx88gpt5q5ri
X-Rspam-User: 
X-HE-Tag: 1794846538-496094
X-HE-Meta: U2FsdGVkX19CB0xhj/5gV6qB0Jf6OdzrGRvNlIKAoyaKAGB2KHQsuU+PAFqogKkSBe6mKYeu3oVXIkhjI6OiovyI3PhvrD2hJXw0vTDj5dcHmlYp2x2qo6+4y0JZTTbwyIWgRdurL2Msmy3lHta6jHkhkF7MnqrzCAo7ptG2bFdRIy7N41tQTtfNCm5Ud9V0IXPz/wVDpx3tslhCA2+SWnAqc2Fc1XbUlgIxlR2jhG6IDVuLv7h8ulX7kRfwGyD18cQAM5EehzbjeqcYmwLof9naz/OvXgeFs/8Sxi6Dzl74pxqxllAxa70DkMzvvUMBsfybzDeyTj5Eec6Xpg1iVIkFNrKfVw5OFmw+SzL2Me1MmudTs2H1RuGnXVAaI28EXNACmhQxjfRlj836HQClpMR9/DotWVRh2dZwhgTTMVkjLkNgMYh6t5hSnW5jjgOqxlePtKEiZIwVu75ljoBfm6iqFURTlO8gNjVJpzYPsU9CY+4ZRuWXtDJ1IfOVFomNf04DVtYu8INp9jEq6SC67EpZ57giSlokFwWtrsGs1KSInimHINCnhHmi9IkTTIkD3C8vwyysFJbc3OQUQCU9rj/YKDIYVYT00XSNKVjyX6q2MncIoU/0L9gX3SNmjopimWpHYYWb2ryHnVmBWiW0p0om7RvgIbr0ez4nRUSyuT4zGGv8pZvzAu+V6GrsyLzmUx5c193JSftkjayLlFKncKQ3EdLGWUBHH2OarhS1kt3waYuo6XDtFKwyUQ9IvVpyM4+9ghwG2su7r0BvKKcnsctHCwVGjLet1lS9qLvkgaSbdXkP0Hw9fougj+iCds/6SpLZd/Tb0oVSRjWBh3NijENnQcViJFIOZR9vI+sIFdM6zyKepXUzPEUkP/dQ5maqW0hyoEv3iO27zjIDRbtBGmFRnyIVhQ0pSGLSu/k6LheX0LabcO2ZuB/7kdn8ssJPTA2IPAPWtjVVSmMpFPC
 srHDZi+t
 JUM6bwYaycwfGnuH59WbKRiXvWaSWc2DcynIm+8E3a3LSWzna0Oo8qyaO3lNY5Ltc3eRk/erQVCpK+pd0AQWQgYv8MUn3+3xZF8GbvBklSDbayYDODBwkWDFSMcm3GwJY6BwefcHY5fx/3bn3ts//nswCHf742TNXt3T0p9OAkiXmbEzSV6vGacaGLcQGh8IxizBd9bo+idrFDmy0cHopsCOEbgg+x3Fu9gdAvJcCHi1iIWjc33HINXDdhfIB1JWbfEptaIRXQdUflNyGMU6k+10MWMWABilLKYM8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 11:09:56AM +0100, Jose A. Perez de Azpillaga wrote:
> +The registration is fixed, but the tracking mode is not: a context that
> +switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below does,
> +needs the sync registration. This has a cost in async mode, because minor
> +faults are always synchronous: an access that takes a minor fault blocks
> +until the handler resolves it, even while RWP faults are resolved by the
> +kernel.

Nitpick, and my fault: I said in v1 that the registration is fixed. It
is not. UFFDIO_REGISTER on an already registered range with the same
context can add or drop MISSING and MINOR; only dropping WP or RWP needs
an unregister first. So the cost in async mode is optional: the VMM can
add MINOR before it switches to sync and drop it after it switches back.

Maybe something like:

  The registration does not follow the tracking mode: a context that
  switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below
  does, needs ``UFFDIO_REGISTER_MODE_MINOR`` while it is in sync mode.
  Minor faults are always synchronous, so keeping it registered makes
  them block in async mode as well. Re-registering the range to add
  ``UFFDIO_REGISTER_MODE_MINOR`` before switching to sync, and to drop
  it after switching back, avoids that.

The example can stay as it is.

Otherwise:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

