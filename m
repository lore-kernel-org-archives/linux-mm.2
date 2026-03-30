Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7A1FB3D04
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388AC6B00AB; Mon, 30 Mar 2026 06:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339446B00AD; Mon, 30 Mar 2026 06:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2282C6B00AF; Mon, 30 Mar 2026 06:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 115DE6B00AB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:36:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC548140638
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:36:46 +0000 (UTC)
X-FDA: 84602376012.30.2C98654
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BF591A0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:36:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtDeGNfV;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774867005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5WlQ2IszGP/nLaPNydK8Rqax5dSO63nPYJeSxxpPzo=;
	b=XsZI7K2c/bnuzgLzkeWlP4BN47jOZ2AJ4u+U9s701nBsgRw4kB1YvECXteuue+vWnJqgpX
	21hz7+bc5zvasR3RFnx17+Y+2uCVUAFmtzTCtCFAtz4NdY4nO9g8swf/LDfwKw1vjpmx52
	o3bCjivLhaQwcDTso/2+D0xJqDoFgxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774867005; a=rsa-sha256;
	cv=none;
	b=k7ioYH9MuXCxDrKYxwnZ5vRXz/xeUHeC4KMJEh8s5BDhJM/fTVg/nPgH++hSFB8JIphBp4
	uix5Z0wtg9ceV5gcb9LW5oSbV6l/27pXrRLQQWe/QxoIOnyFAY4IIIomAtA7KKT1vCPXrf
	GNdDFt1zgyQkxdDGTn2onZiCqOfUs4s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtDeGNfV;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B298600AE;
	Mon, 30 Mar 2026 10:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4D5C4CEF7;
	Mon, 30 Mar 2026 10:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774867004;
	bh=MixoYkFf2wzXKJK9Qx6XjivQgGj19kVLUbw1/lKX6T4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jtDeGNfVsoV4zvqOqmm1eMhhnBUDMcRTrBKhkEcM/YMoqDJ3v/4mRB0mbTNGRlLGK
	 H5htgs+yrNqxdt0EtJwISSV1kQWbHtOUYZQHZoxTC6AqrOwPsqPdvCcj0tqqQ1xomF
	 K3qx+Wj1oR5NKALElonasgdCbhS087QQvESdVKs2IY4T0V3/29Rh/LXV/yh9f69llR
	 9/gs5wO3/bfsUSLMaFz6VnPerNkLHg4IWMC225/uK9LaZ4E0DBNov/6yGeU1SgGi7U
	 FXhj0nqbtzu5Y+yLWeNOr8C6WoPi2ZuLOTsPUNjPjG5ulLSE5izW25bnoT6XK7hjOG
	 3ZBs6sk9wzSsQ==
Message-ID: <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
Date: Mon, 30 Mar 2026 12:36:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: Herbert <objecting@objecting.org>
Cc: krzk@kernel.org, ljs@kernel.org, hlcj1234567@gmail.com, sj@kernel.org,
 akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 kees@kernel.org, gregkh@linuxfoundation.org, brauner@kernel.org
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
 <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
 <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: yjthcgiuik4m7gpopdzr9afkyft1dnz6
X-Rspamd-Queue-Id: 0BF591A0002
X-Rspam-User: 
X-HE-Tag: 1774867004-438479
X-HE-Meta: U2FsdGVkX197HmfsN9+BC9uhOaPw2/dAuoX+qy8z5mLiLja8lJjUXPEEPV07scAGS8000kk8n6tPKU3DvMVC75tKjHGDG2K82sYiIFSUwQ4cwa/GA1Xe/LIMiO7sjUwY66M7YsVACj81Mlmc+oTnH0Y6h5Qf2mSN/IkCIcUofnsydO1JxbXfGOxTyTikALw31OSbeZZcVVMFJwFbnpcM4FdeObb15bJmWwRARJgz8SBA+FiKTyAvPyIwCZYZ33UGGNtMRn5ZqGXK6V4f+KBfP+oqCIzGhJEsKqDuSFXR0gBBUrcSo3sP4OhWJKrDx09I46kUgUrPjjT2S6v+VathzV7Sb5/AO/SVlQVeIfD/Gl5MoRp3ePWaF5GM2cA3V0txzPajAxo9dlKAgg3+7DDt7ccwWlyFX7YIxaRzmib6okb4G8d5og598sKrNrjKOWintyyUsldIeiQegG4kDyps2kavZzN3zkmp2fzzVPbAruITn3EkQGil03KURE7EZXSR9yyMCz/hcy9Z1h02EUVkH99qknJbHfYOSSYYu1+YQzU6+f5A3W49LJp+wsn8J10WV2YBFCJKO6X6mPngENonMdz+2aI9Y7vNkPTSrjG/NI4bVt9rAcPBt966yt2NuY1+us6tfigSqlQlr7Rj+uoegd6rD8mBfdqfnyA+cPR3UZnVRb+emlPrvt5DrDSQLmsMtH2pn0nUxhM+HjAwYQ9F7sp3xrT9KaeogRzjB44Ti06Acl3Po9hw5jqJXj97gWE8Go8DEInYJWPSLfC9o+7N2TDL2ulL6I0G5D8WvKKXi0z0qmFvgijqWE7Sik80gnXqrVZcC5bqks0zhAjhxSxuhaEx7FRDG2ogtUQL/7cwkiFeiEKtm2J4u+AkTrbldck6934BzWSoIlpinnPw71Xvx1G7bF5MFvkLSeFf9zGrkQQlwKhV7vVMnrlLlCDGpjdw/TRous1xFGi4Ft4QuMf
 iSoA18Aw
 VtqDhhNhLG+FOOvG967J7FaEUKxQAw/L9WKiZ+4HoJA+PON8a5GvwC37Pot4hBUy3ehnGHyXeT3cztU3ugZB5ZUkGF3Ukx/kKtrP7xmUKVR0xC3B/IXcZNf/UpVp0g7eQgvuN5z5kM5tt1MkNScvvngypvep7wYXzBinxJ4Hv3mnWnpyN3dPpk+swewCDFWvGUimkFT3YwHSdjgmoWIAFaOvyFUvmoj7QoL3MkJ0JwFx+Wn0v9jSJFz39GVvF12ETy+xjusqnvoi3GHbyt1w6lxHBfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 12:14, Herbert wrote:
> 
> 
> 
> 
> 
> 
> 
> 
> ---- On Mon, 30 Mar 2026 09:16:44 +0100 david@kernel.org wrote ----
> 
> 
>> On 3/30/26 09:50, Krzysztof Kozlowski wrote:
>>>
>>> Yeah, good luck. Several people asked for that already, like 10 or 20
>>> times. Andrew asked that a few times.
>>>
>>> And yesterday we got another sloppy posting, so that would be it for
>>> having some time off to learn things and take slowly. 3 days after this
>>> AI slop which does not even build.
>>
>> Bot confirmed, I guess :)
>> --
>> Cheers,
>>
>> David
> 
> 
> 
> 
> 
> 
> 
> 
> ? That was me learning the ropes, by making a patch to the QCOM subsystem
> 
> 
> and it was a genuinely "ok" patch.
> 
> 
> May you please tell me what I did wrong here.
I thought you wanted to "take a couple months break"? And I suggested
getting a mentor first.

Anyhow, this mail was sent from "Herbert", which is quite ... confusing.

-- 
Cheers,

David

