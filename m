Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1666DC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5766B0099; Mon, 10 Aug 2026 11:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C2E6B009D; Mon, 10 Aug 2026 11:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1FE6B009F; Mon, 10 Aug 2026 11:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D170D6B0099
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:25:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 491C51A01EC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:25:22 +0000 (UTC)
X-FDA: 85085733684.23.C1AF32E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 70E781A0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:25:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OW6n/RNe";
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786375520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aD0bxRIH0QvO9hW9MI8bXYuqWD7VWpFBbaXOQyoMgDc=;
	b=x8LQd5txfvkZV15bX8RnUfbIiOSOZHM1wo4OgzYK7fqduG1sWiwQsehTDJBGBIynHNVNTG
	8VvMOGuHbk8FPSN3kiVSt+j4VSSCu62TL+TZ3VDpDsDxf4yCf6rhdcAY7tM4WsUrZreyvh
	ziu/QRED8nJJw5hG2c19+ULlZWMTCu4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OW6n/RNe";
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786375520;
	b=wztrjw2nOpm3hPXwTBfpxpb9Mqsgd4TIXJJjHcF7pLG5Rnfo2S1Qbfq67OWTsLf4nastoa
	wp3niwXnmfh5zlX+IhKuKJTipKkFtYrm5GhNgFMwg+KE4EqoCK9y2ZEflByh20uO6Y5id+
	Qjy264TLB5sJ6uBuETSZdJjZ3M4crwA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786375519; x=1817911519;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MQNxgk9NBJOdbXn6RtUZdseoRTbQhrXnkphWEH+MqIg=;
  b=OW6n/RNe8IOZaVm4/WAEylq8i5iP5ixA5KnqKmOY6AmxG0XcfurSV01v
   mHF8MGtHNpMEOfnByHOnskuxKd/UWVsW4zFjLa6IAUDn3AsURvZwjougE
   CiY+sipm6li5+qwb6K3SmryqcJdWj9LSOkzqENhFYozb9a6Jvwxr5O+55
   huJMtNqkhsWsCi35tt9Cup+NrVdn5lu+4wFFNHnZVYE+KIuCz6VD8ofEy
   4NNebO1DTeJ0JunRVLCxpg/CDA98ITlKFcpxKkoiBE0ljQY8ctVzpizUb
   nyVbw18n21PlobkKPJunJfRCyBxTXjI5Ij3Ux8g8PE39g0RiWKugr7+6h
   g==;
X-CSE-ConnectionGUID: OroI7habT2+ljz3vmKyEkw==
X-CSE-MsgGUID: PobEiheiSRC+XOt89ekGbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86902136"
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="86902136"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:25:18 -0700
X-CSE-ConnectionGUID: VjWgQZaeSp21nrem+KsjHA==
X-CSE-MsgGUID: jVvUXN5AQwCtCdJSxx46ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="263674064"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.110.41]) ([10.125.110.41])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:25:18 -0700
Message-ID: <b605f3c5-825f-4248-88fc-cea8ec292bd4@intel.com>
Date: Mon, 10 Aug 2026 08:25:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] mm: Add RCU-based VMA lookup helper that waits for
 writers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
 dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@kernel.org,
 shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
 aliceryhl@google.com, arve@android.com, cmllamas@google.com,
 christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-4-surenb@google.com>
 <anbZpzFbtYG7Ngit@casper.infradead.org>
 <CAJuCfpGdyNq10F15G9Z=TrkcGL8my5RB1w+nZMKOTaH1o9mrGA@mail.gmail.com>
 <anmmd0tIiqu2V6Lr@lucifer>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <anmmd0tIiqu2V6Lr@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70E781A0003
X-Stat-Signature: 8ciznyocujnswbuuew1nnf4au717xp67
X-HE-Tag: 1786375519-480104
X-HE-Meta: U2FsdGVkX1/4D/bjmd7pgOWHlsgGs/k+1AkWc0FKm8O7TJx0mXhptdKq3ZOW5Gi4b6Ov85uqhZ8B/PoXX/fPa2EUpywN3O1w4I3DcGkp6NjNH5DcxscSdEq8QDPKLUd+ZYlFMEBm06xYtrr20f/j/25NqUG9vmQ05VT05m/QYDabdmZOz+5kdFVJss3OETR0MrtQc6bcCl98cgKn0JGO3YDupJUyXjhO4WxtJuWZFzWICE8TS0kZuhuga+MorjZghUZuNxa3N6t5bCeo1sy4ksl/+r/xJMrek5gqi5itWv3fl8gWv2S4utVchIAVw8TL/KVhQTgMXrvSwpiGy8AUC8j3IrY9JMHAMZgqe9u6SYRfwFVR2lHybAjV5dta142sNG1dupSf2YK/F5obUmDv95Y2SaIi9qStGz6ARs4IIKs96MCIcUeAV2IwLzfKvMyl8IPJOYuwQe5xGWBrFhPyOIiBPcPRre06ISnCvbxIpjwgsXHqG+2Dkzcd7We6xQgxVUp8FFe+GATjBm7J5X8DUnQXhrEncaEPRmoDe7nAUqZeOD0d8956u2Jdc3vK3PG0tD92QSi16NG0ilXKEc08S/cp9kdg71lTZUDHUrEgPCfE0GRftCmNZCYl4t7KjZcZjbsNf4fOW+LjeSrV25BSyVpHWlBrbPKYaM15+pf9CQqpnRdQj4M7iBj0Nuh21gZEORxNrg/i7SrKTZqBZgxYEn2z2yuXFd8aw14XZcFqWbOf3w177j/El+v0VL5/5wOXm51/cUQ8TvIgCnHGCrY7O/oB2Gn/tIoXBu0RbH/bbqD9j3QU832U4yCqmkkCo3G+iq0DYZgPx2YjjE4hLts5AUCoplNMlaD4pwR9NgWkiDMmhdL2aaMvJwGRSdF7h8kKH+w0L3TuAgu/GVKEI+diBd/tMGu+LtvdnszahlSyUGDxryZ2MMokTe2bhzBtxeVYNmyrxpNA+5YY7+cRLPx
 +BVkV+4Q
 lGLe0U7We36i9w6tuI0jfeOlYnVgYv+xlB9/hMaU4thWHpRxKtQTn8iLH5+LgwIG2F1oM7yBLXsHkRaeo2P4oxDugSIfMCcFrCC64ZGo7l3ew4ZOVaz8ZdBK3dj5ufjZm6oldra4kIkj7nFOAkZJbb3cV797X58C+U85jijSE+h8gLKSkWuuIpYwGz6fg15xHIlOO9WxU/SeeerX19Y+JLIaUofg+LNCm8iYS+aXeQBA0MG00q1S4uGf+ZmGxr7RGdA9wkmY1UXjIE1cbl3PQoYSq9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 03:24, Lorenzo Stoakes (ARM) wrote:
> Yeah I wonder about the value of this. Dave can write all this up when he makes
> the change to use this in the relevant shadow stack (I think it was?) code.
> 
> Having it here when just adding the function is not really helpful I don't think.

Yeah, all the analysis and chit chat needs to get moved to the place
where it is used (if it's even possible), not here.

