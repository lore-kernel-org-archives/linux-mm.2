Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 033C1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575A16B0115; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0E86B0118; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379396B0119; Wed, 29 Jul 2026 10:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C01CD6B0115
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16B51A0668
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:45 +0000 (UTC)
X-FDA: 85041548970.28.5881832
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5292114000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:11:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7kc6Smo;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785323503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izNHY96+KpUz6H88SX9UDBXo3sdRLH0ZWjvtcVBF0tQ=;
	b=Ta7O94oFsU2eAspRptj6shpE8/JRedUeULwvQ+vgiZ9+m3dSEOPcJXiB+qVKf0dMO8mEha
	P6iXxUQnQQNQiP5/LPMbzDImGmkmiiLNld/Hd+UTyjegKirQKs3/3trXi/9GpQnQwwtlPY
	ehuofrSr3KMYjuLwEcqBtFkpRmtb+5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785323503;
	b=LeWdS6RxyoZbthmRMmUITyAZtZBXgCkT2jWwp6/afk5LTkTAiRRhCnYnBlBB2dLD7DLc/o
	LRET3ZdUQKv59paM5HX8hFELK9qie1EmfVMIYOUwFydn26CUGruAduI8JM1+cXvgOhrgs0
	4zUfQYBZ4eJO8x+VPjNaHyB2zDlEUug=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N7kc6Smo;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8FA560A6C;
	Wed, 29 Jul 2026 11:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B21F00A3A;
	Wed, 29 Jul 2026 11:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785323502;
	bh=izNHY96+KpUz6H88SX9UDBXo3sdRLH0ZWjvtcVBF0tQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N7kc6SmoQxTdwsupiqADaxwodrc2rq1MDeww1UbcoZDBdifUpBgdJOffX837km3pO
	 HnZHBR/5BOQjjOFHVzL9Lo1Yk3z5e4AUmbSr/wIyTr+YVIsJiThzs6zKW7k+dd5Jgt
	 ILRnw0zbhzVk2C5bgWB1sf+pgKEyJUd+usU4A+e/43D1Zeu69ADhaPDkRAItCDz3u8
	 XwCSWtk076Pp3y01nryN5PaqpqMSlFplmTLb61o+dMyAPYibwV+AJoRSMde4KZWax6
	 zlpcBIahqsY3Ivs9vnB5+MHQbfjH+B5VAZ6c56o2Zich/EbaKJ34i0ATj2cfyO1pxY
	 qPUc7lx0i5TWw==
Message-ID: <2e1ca7be-ce73-4146-95fe-d8cff4da9494@kernel.org>
Date: Wed, 29 Jul 2026 13:11:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
 <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
 <amm72Bu9qmWLI-9b@gmail.com>
 <d0d62d7d-8701-4692-89b9-84dff71a7cf0@kernel.org>
 <amnTfwagJQpEY_21@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amnTfwagJQpEY_21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5292114000C
X-Stat-Signature: hheigq1d1soxztetmscq1pigrtgzt54m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785323503-107167
X-HE-Meta: U2FsdGVkX19FcQppoKlh0z7q8sem4miXR0Y29K1jUNNEY1V03XDOSwG3s5eIbn2KcE0/lJAxpM2kKegA+ybZYn2d4zT3KfSl8jkQ/fDUhaEajr8xA7ZR86JLy+HfHzFnLPjipVPUJfG7FA722yNyuvGEPVtOlFR9fUgm09hW/Ydsv/w6Fo7q4ynQLEFxIucx0hFBzAH6rdYHpdsgwCTrcGQsTRvtd/1DGf3yG2rqCatZ7OjXUHKAzVvVsj25gAulULkGn/TSDFTYSgHtThAeOG/X4WubxNHHFlzlUDmVDkx5Y5H9zw+J6Avh+rmDdIBM8BxqfFCdUQl3/P3k88/dt+5FCVCkMH2hWyCDaQuCr7h51ALcJW2XmaSWMiOy/vabDeklCkmrifqRRpUkCTIzagFvLAPetSOKBqdvHYB+QppLu60E654CBTQJrrJKqKWHF3DWZYo4zoaFHvEYayccnFEHC1yyw9gu3STvtmzIjIQU/sm//qyHqB3PiDOFQCXjyX4q0tg+Bo1NsPczPnJFohTlGMSHsZ0l5N/klbIX/xMl6RTUcteqoYsCmQDtAsLVZK2XIgOGaj/uyem5zzvsghlCCv3h9/6JAXHcjawbCkThrE05qhd/Xp1RbdLAWk/JeLT+s7G6Su8t1DUTVWTA8TOhZBvTD7se+CR8ubd0/gvu62jPyzlXEIJBq4lMgJanq+pl74n37P7/atoBiXVuZodbIAVyDKMD9lFA4jrT/3k4DFsjNQECYvX2QAULnH1iUfj0On+PCm5skxta5v8IBn1uJve61dV6roVbFvOJ3X4rEZ8SEuDyN3NWew1t65Lagtomlman1VeI1HdOj3A/dabkJwYRoQPOtJrLPtprjuVuLUHNDzSOmqYk8Ak5ZY5hpKIhBS/uUqlLikNKqnbHI5YHIYeDIOSC6I1jQD7Bdj3SkSd+W+K0aMhBZHGNUKgJ5wjUpva5O7SKaXmfX/G
 BTuLw4/w
 9d+70lxpbnaRM8ZueCw7TqGg/aHBNImM+o1LwLqqHTtPEK4wLuxvFWxkCiRVpYuuFChUdMmygiROGNl4wJYbP6qbYFJjgzqH+aKlaB4Xd+mp4kYC/glrqmPopPrYQ4LMj97EQkFAawbTmTWeMz4lHsWNhASb0SwQM2zOK/sPChLsNLr9HP1Z/lYogKcDsf95dPLvHW9oA4kv6bzxHn+Sd53XEIWWE/KBESMYlmqY1w1SPc/LW5a9ye5cZIjUzifh2vaX7PW3k0pTQ6ar7YmoK5HescX2kEe3Qo5lX+WirsZxuVXyMUYKfBDO9ac0VxHKTh/E3vsnnlTU7DpA6jY3D5a+4p9AD3KtvgeYVjbOr0X4efkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 12:21, Breno Leitao wrote:
> On Wed, Jul 29, 2026 at 11:09:11AM +0200, David Hildenbrand (Arm) wrote:
>> Avoid bash scripts, please :)
> 
> Sorry, I will try to control my fingers next time.
> 
> Jokes aside, all the selftests I maintain
> (tools/testing/selftests/drivers/net/netconsole) were done in bash, so,
> I got totally biased.

Ah, I see. The MM folks are not known to be bash experts, which is why we limit
our bash scripts to a bare minimum (and focus on C tests).

We do have some rather simple bash tests that are mostly used to load special
test kernel modules, where the real test logic resides.

For smaller things, I wouldn't mind a bash script in tools/mm. But the parsing
of pageflags is a bit ... advanced :)

Note that we already have some kpageflags processing in tools/mm/page-types.c,
not sure whether some of that could just easily be reused.

-- 
Cheers,

David

