Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F06C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93EEE6B00A1; Thu, 30 Jul 2026 10:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB296B00A2; Thu, 30 Jul 2026 10:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5966B00A4; Thu, 30 Jul 2026 10:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44A8F6B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:43:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCBB21C0154
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:43:22 +0000 (UTC)
X-FDA: 85045711044.30.04915C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 034EA1A0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:43:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWJLcZtt;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785422601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KQS35DzEabNwIcHWPyLhVv3cK2APUvpFW9vocbMRy0=;
	b=jk+it2RzGrs11J79aPemppwznSVajL07iul4cNBt1l9uSeHOzSR5Si+6OdS9re28Qmxcte
	NtytQaP9TrWSTJww2FFGZhDk8kWrF4LcKJand8OTvy3Xpt6NFWaf6IwPMa9QND26HYJOJ4
	DKJ0SurNx7DYT1OleQuzSYVhpK12bis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785422601;
	b=rY5LnBiTJn6pUhPl5DSDZ7LRpXORLKGE0BdIha3C1zyBWM7naCFnPiBm1QjFpsWc77TDUQ
	hSi5h0w0KUr692ZygsRgDxdiDOFU2uA5CTwUkDE+tEWUsVd0vtpnpp8py5rfkxRCLE4qxv
	rd+z84F3rY7ZomFLpDIS7gtYc5nZ0c0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWJLcZtt;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7FC6600B1;
	Thu, 30 Jul 2026 14:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C8E1F00A3D;
	Thu, 30 Jul 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785422599;
	bh=6KQS35DzEabNwIcHWPyLhVv3cK2APUvpFW9vocbMRy0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XWJLcZttTcPRr/tQrWtKS/ixS1oQLP12Z++JvsU9aBW5rKURzD5Ekmk/1B63WvktM
	 siWXFjI5LTBU3iW+soOHN4jQ3GEo86ben28Zy+SiVzK/N5GTmElg5oaIVuacsX1yzC
	 P7TmmT3ZE6S7KIehA5igyuqyer9+mTya/z1vmCpPtFsdXysnyLSJBHQHsYjpc+TA20
	 e4qKfJNulaAm8pF+YBNK08CDFEXq/DN5lbVkzggvM5mIP2BVJkNYPqKz0O++rTtKqZ
	 9cL4D+dolutuIFHLZEbtHfAq40AOBsnluDJbdYGpQebJIlKOn87PcRjHtm8v2iI0en
	 mTaCqkHXRfcJw==
Message-ID: <fdfdf7ac-8ef5-457a-ad9e-c92f6df33ab1@kernel.org>
Date: Thu, 30 Jul 2026 16:43:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: make libnuma-dependent tests optional
To: Jiangshan Yi <yijiangshan@kylinos.cn>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 13667453960@163.com
References: <20260730142722.874189-1-yijiangshan@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730142722.874189-1-yijiangshan@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 034EA1A0003
X-Stat-Signature: nkh3i3pzfhamppsmk1g11zy9g1hdxsoz
X-Rspam-User: 
X-HE-Tag: 1785422600-228587
X-HE-Meta: U2FsdGVkX18p/0kVqAHgO+7mum9dHW1s3jSOazcOyqWh0Zq6p4KvvreuL3jfS2gS/LXIZY7SRuARMVlULcCHhc9YYrBGw9BPdFEFvLZoDUL8oZ8B9w01EcBRIVc5mDh8surA3Hnqc7UdZfTkO8a0tMMmYG0OfAiJTvaPSDnmFiqDemDOmKO8KvJ64Z9ypaBrdxivlTsmvWiIZz5mPYWsKgAVXpDxF3GgejRzo9/dnFtaxov034RdG6idDpaS1IrhP5rTi34gGfDhKS/TL2zlqPbahtSvxmwYvHUM+gYmJQWu4/mTJcVR1DREo9YXONpwxDNr5g32LrkZe5bI5UkziElwuMFL93o3ALD7aHXBohrTRBX+kqaHASAdXVqxL+6X+71U+zlIq9LRrBmG1vuJdwZi+MTK/2XpG15SIC0CRm87Awyios8m+rutI1lf8F1rHw29bJMz3xzDhtGy0G7klZLvQ15a44m0GVUGbBZ5oJZqUvhjr+fe7kpUGk/L73eAG9mWI4JwTwk/HuBak72MNpkvRD2ZC6ypGoh10Z6jai/7whinFaPodh/EPF8S8CMi3bDVnxD0GcMSwKacWIc9MmX19K+QRQmIkilGXIGhZnyfnLeQOaJQ5hZIEKDNTTYCHI8DMmq2nyc7fuBc098cpnRCSnVVQbdqwyiC9HhxQTEv9ko5FfXKn/fR4fVJtm1a+A+pxUeL94INi6FxMRPvdjy/I44QyhctkuhyFeLtm0TzgWDlZKFo624cD4rsb3y2rcbo4/E4DODLFy/Lv76ejGFlYKbRxlaNK+thTj+77t2hZliajfrucVr5tqImW29xAJ/3Plzbeak/mVTDXHd4keUaXz7TC1LeJwxRyZVAYqNGq1Q6id2dB2JVJDHeLkpvABYyiKSu5EimlYCDtcETi0oyUTeHxpYor41v0jY59Plljk46voaIi3JTiR7V5+8wPSK+loJogYPhHGeU6uF
 TArCeBVX
 fKyb8IiUXz3p54juw7lb2baswmnoORpFnew1/NbMc9eaY02/AEOVMTr2vNGkYcUsqT/yHEpGqkCFMWk0tXbkBywESOWX+fJs6jLXCk2sbDuI9xtutzxywUdI/84gLsfCRtwKL/4mQpd6ySSZxkHJkMrNK5zkLfEWk5f9aG7iYSb/lVtjMRJroPt/LUPJYl6ephllKeYgs61B1ZHEUKhKXxg/uDYMEZ7Iue4zAiBC7rJ3LAfWN9n8Divv/nK709CSwPVyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 16:27, Jiangshan Yi wrote:
> The mm selftests Makefile unconditionally builds three test binaries
> that depend on libnuma (migration, ksm_tests, rmap). When libnuma-dev
> is not installed, the build fails with a hard error, inconsistent with
> how the optional liburing dependency is already handled via
> check_config.sh.
> 
> These three tests hard-depend on libnuma at both compile time
> (#include <numa.h>) and link time (-lnuma), confirmed by grepping all
> .c files under tools/testing/selftests/mm/ for numa.h/numaif.h, which
> matches exactly ksm_tests.c, migration.c, and rmap.c.

Hi!

IIRC, liburing was not universally easily available when we added these changes.
libnuma is fairly old. (I might have added that :) )

So why should we bother about setups that don't just want to install libnuma +
headers? The real motivation is lacking.

-- 
Cheers,

David

