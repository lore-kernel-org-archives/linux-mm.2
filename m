Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A752BCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF826B00F0; Thu, 25 Jun 2026 03:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987F96B00F3; Thu, 25 Jun 2026 03:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829446B00F4; Thu, 25 Jun 2026 03:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0DD6B00F0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:41:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E49B0A059F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:41:40 +0000 (UTC)
X-FDA: 84917640360.30.30CD637
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35747C0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:41:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mXl9fp/v";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373299;
	b=3UQUk7Dlbb6LOqcHte+1v1I8WnvQlBfKW5M+eCnUPIaDuX2pZ5q+CdT6bJ7FY1suZ4qLtQ
	H4SfGf1LbiRJbqDSmFU1s0XusgtL8DjE5X8XFJFYvoOQeLUadoFEp1YHWGtAZ2516td2bY
	TeydXhlVgmU5JFxtQYFoMiDsUZYv7lM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qR6oIry2jf0Fr09AE+fKexDY2/aMs8tOBo4q26NdOrM=;
	b=xmlTI6urFzFXSI8IYqtSMbbN3wBXKUMHS0E0PA3wmXasrgIEx1YJOQ7v8NsaC+YALrXCvO
	m29e+JVvVXtilo8D/VhtnocZvZCw89igaxJfHXR3Q6W9tz/Lyfshk78N72yyWcwv2XEUWk
	2LHlmFm2erhMv7GoBiXaOD7WR8g6cOA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mXl9fp/v";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6B4A60217;
	Thu, 25 Jun 2026 07:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED8A1F000E9;
	Thu, 25 Jun 2026 07:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373298;
	bh=qR6oIry2jf0Fr09AE+fKexDY2/aMs8tOBo4q26NdOrM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mXl9fp/vua3/fO7+bl2QOvYDw6IGCi/i5tNvJKEo1qmWqSHI+kpeGoVdtIiZ1jXRB
	 C3BiULwUh4wqxeWOs19bVnurtNPF94AAgAzzYefnUPzahdtagh4tleRfKVgX7X7m5x
	 +hA4MAe+zAAYVztI5FnEhQ6towFy78rD++77RmwiiRXb8oN9WFvEaF0WmwRcYbRRl7
	 3rCu34Q5w1qUK5SV2+ziaq6O5jtURiXpP8HJII2qRtRJl2XtXJfkychZLCg8xLg53z
	 kq1ldF0v602LP92+s+hZFBb8851THUi/mrL4XeIN3GS+DtaOWrJYcsAoenEymXvK5n
	 kTuIY4wCywKTA==
Message-ID: <dd45e774-a2bf-4cdd-b27e-35a533fadedc@kernel.org>
Date: Thu, 25 Jun 2026 09:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/9] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <ajwpCOSGapenRPsu@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajwpCOSGapenRPsu@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fk6pops1q3mos7j5xtsmxopbqbaf8ppi
X-Rspamd-Queue-Id: 35747C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782373299-569026
X-HE-Meta: U2FsdGVkX18r2eCdHSUPgVo8ZEh2WqRHlSkNOBOge4EtNCPLPW05RqkEKW6WtyOjHyiOVCcD5LAKrzr8UjXOrk41Nkuyir0ha6eFfNxVrp7VrERbaBUIPdGp3WerXn2S/ZmA9LOfQEmJE0hURmZARRzyoP2Kl+1MPw40FpZHwqnCRpI0omXFdjLHenV2Ei6DpnFK3duTDW6XkheF66EXuXxL7YxSetX31lWrAAFLOTpYy7mjjW0hkJ5n/TcZ3Phd/RmvJfm87iKWP6KFFDJfU45gsuov/XkjKzUbT6bIZkvBCIPS6tgCcFlSkOO3+zuI3zi2GwK2UN/sikCuDjZlurDshwR6SWTv0bjJXGvXMjSey6U5VJBSvKlLCE04DhYYycmS7j2nN2jWHwT/kATbHuy8qiZJI1visTYFqruSF8tvEgb04hVQr59kSg037eIJ4JlUb486VCNaDUKmp0xjb22M02V60FrS8yNPMEVELgp4SwP7nsLUpgRlXDmtOBuC8Yb6lb1a8IfiwO9TBwBohWgejTCZzevkFC0yNFAGN3FksQGN+f/bOA0X1SUBkpoga5+3mIUqPCqh9nSuLduYt0oKLDukqHTOzuXFX9mOSU/bekc4niDso/V5SgV/jjFY+bmiiLt5pX0kfp1p+8aCQ1ERbK7WcJzqDYMtm2S7ywbLHnBnBGuDEkqJ60nYY0pM0VrgTzK+69xs5Dip9+ssf/g6snKaIuKUJWiVh2VUfFQXAZWDQqoSBzGHMSNe3PFl0BQk9n+oo++6I8msJ1+cckth0WYsinVWAoeEeu2WgxczWjxppvD78OSLDT3qkTKWcOQbBVXRJ7uanTqW74SnGJto23lBSw+ctXOyIBJNwQjZpT2MoD0e7WD+E2xrvSeN+mMiPRA/LPqjJTmqBRW3PXWwdw6WHQrYlRQYjGKVFVqmIG1DaohXtfQ8rVFjqSmGJhQ+3qza9pQjV8xyeb4
 v41Hc22G
 UpPF9MIVlULlXQ0EwrF7Sz0zu/Gn0mV1XbLzdooRVI7S7A5zvSOPL3Tc0HRpar+Xjy4zBwmQzme/czmetSMQ/jUsGUnjRMTsO6QTrbyWFwZgFfJFIqdyHZOJQjH2cO3Eak7ZbVeqHJeL8ajuErYzeQQ+0MBKmWvNLp3ZA+rTWvGlsei8s33SQiF6GszBB3LGGviGzpa2rtLzJDNc9pA1xa5ceobKJVmG4+/n58QDcsQDHuoYk6W0D7GumX/zhSZyc67naTBrtL3OuJ67swl1k8kI1Y8uafsD6WafX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 20:59, Gregory Price wrote:
> On Wed, Jun 24, 2026 at 10:57:35AM -0400, Gregory Price wrote:
>> ... snip ...
> 
> Disregard, there are a few unaddressed Sashiko comments, I'm just going
> to respin this.  Will wait until after the merge window closes for v6.
> 
> The rough shape of things should still hold w/ prior feedback.

Added some comments :)

-- 
Cheers,

David

