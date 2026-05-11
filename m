Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B7ACD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBF76B00C5; Mon, 11 May 2026 06:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3146B00C7; Mon, 11 May 2026 06:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4007B6B00C8; Mon, 11 May 2026 06:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBB26B00C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8A141206CF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:36 +0000 (UTC)
X-FDA: 84754825512.07.B4500E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 64FF41C0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTyVZyDr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYLEM5FFiwyjbeHWjoozW3XsPFH9tF/TJ2slcB0Hiyo=;
	b=zlPrkb6yGVgyJXRs9fbIS3EdMnUC3hCRRed0vT8oZ7hGBT1lO2dvohAo+Wf601pZs61cw4
	8WtEtg1N6fGqy7IQdcqlaZ6dEv3EgoaiUXV+x01S2UR4BzP755q4hCMdvymAwSbnFxe8t/
	hbbFTLr7Y15NdXmlWpW/fsZY+nzfx8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496755; a=rsa-sha256;
	cv=none;
	b=GlokHT9ooZ9jocbXrFqlSoEOLTXOiTeUbOpJ/by1WMqsXuKGXn/4DfrtXm9SdZiCeIYTgP
	GNEYvKrCOcwfmGBcJf7S8M5ENMhurnanvxh+rhBdP0wwP6z7qR7jkK1nIGy0oQVBxzmlfn
	MdzHit4m5aUtXQybJzITyuyUTxsCbDQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTyVZyDr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFEFE60125;
	Mon, 11 May 2026 10:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC26C2BCB0;
	Mon, 11 May 2026 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778496754;
	bh=TK8vbFo3IPPLv3mDTVloWgVI8sIHrIme4x6bk2ipAk4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bTyVZyDrH7UkNmmXFlL5FS+6s4zqf+bpazGJAlPXifeAZ8X7sE9DaU/pNI1v4U9eb
	 kCQAWT/UzEjcN1f0/2/D2zFRQSjI77sYkCBhPwIBy7Z61/4WsVNDwHLALipDGzHujW
	 9BX3FGtxDjvy8cB9VAVWXUQv5e58a8nGVydKNnvoFe1iejsfAj7tlLI3ndwbuOJGcx
	 r4Re3dc954Sz3OAYCGPnF/vjVVw7YTLutZVXnX9lB6vFr9wqtiPdD82RYvhRtWbZpP
	 izQlWj02ahPVAq9st/RSBiDTxWgqlI7hW71LT68PPIpf/nA0Qgp+Nw/9563oeqXFlG
	 17tMMKszYRzyQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Hugh Dickins <hughd@google.com>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jeff Xu <jeffxu@google.com>,  Kees Cook
 <kees@kernel.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Brendan Jackman
 <jackmanb@google.com>,  Greg Thelen <gthelen@google.com>,
  stable@vger.kernel.org
Subject: Re: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
In-Reply-To: <04a4e82a-2479-45e7-92e3-047ac8365ae4@kernel.org> (David
	Hildenbrand's message of "Fri, 8 May 2026 11:37:13 +0200")
References: <20260505133922.797635-1-pratyush@kernel.org>
	<04a4e82a-2479-45e7-92e3-047ac8365ae4@kernel.org>
Date: Mon, 11 May 2026 12:52:30 +0200
Message-ID: <2vxz8q9qdxqp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 64FF41C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: zryy15a4a1jjf9nc8a6d5s8uerc9hp6o
X-HE-Tag: 1778496755-281220
X-HE-Meta: U2FsdGVkX19Ot+drJG+wQ6l01IFlq7gGs8ap6PuKT7LeCb4ssB5aapqIo+YV5UhWggThLcroTE3ZIkJe47sWdw6OeZTmR8vPrMo0WqCrlGxPd26LHZdbio90QaQ91YAsB1iFihAqcLtkuN2D8dVCZ4blZj/U9BgawiJDagNKuzYaaOfCMUfxu/LjmEIBv8gTw2Q5JeXQ9H+hIL4EkvNXI5yPDWTxxBcoOXYc6m40FDC0zZLV88pDWnpGAH6d5r5023uO8rU0BUG85077/JMi3FsSq3OLIVB3xJfKSX4ogRs2W0qsJ4PbsWGE8Vm7sEMmGN1uBA26k0Cafxyf0pGqVIcTcuXeXFTYn2Q7DTSB9RlZGQMG5PpKYob+kpSLFn5HuQGsFHsOBsT28PueSkd0vfHbuQ0KPNJ6uXREorgtrsap0Kh/+/JSGM/pgOmuujRt+zxUK90XQYX8E7rhlZthpItA82TQn4ULe4DB8hFAiPsdZfDgCw+3mLBL5LLEiWsTc1kRL45OTrHPt1oDC1A7g3x1uTHhE7Q1xYcIYm7Mgp55vSdkXaAeVQO/F3r38m3z1946mzZWAoNzqKZhMcQ91ReKeovku7AuM/ak8+XTySijmrl5Gqb4KErIznVEf7Bj2A+eAAyg+TJ9Kx41i3t2tR+1Qj45OGGy4GJn0/XWc652MyFkKByHbCkqawL3f0VN9oGY32CTl9uCqOPlRSYGCO1+aGe40VbiTHtttBQKYDUEg9wfzvVPNxFjc7HnqKnhW5Ad1mZ4pi/mJCplRV8DJmK2Lnt3v/wbGfwQzDNCCNmmRdt8qwGZ8beRfC+h1tTbo82mUr2sPSd+pppZctVDz9eoKwz1xIxtgiqVoa1RyPOM92MrFekm/PhEPJC7HcMv/9z/scf+NK8n2f6xykSdxFHVe2h3bKuHsBlBrfB2+TSBO3DWJrc157wHF5H1WDyQIU9IfD+d8dxowzZB8En
 PeQhegwW
 IrR1paaFpQeDEbeXWjIWvvWfR17yr6SndJ0yWfHC+J8DOrq7tZOnWRyzII0zRoLa98GPLHySOTrPum00e8KMHt6GkVQXSuSrefAnMwQ7P9kKkabIxgQRovb7LnaatmHMdB2HkOXGO/T+vW3ndIXlJxieTJuwcJiVblVxS/rvMNGR/Mq0v4p+npGPJkm8pEQh8L99t1sEl194/jNy8s/j3Zgl7Dlo8fSRtOGBN4zH80fcMoabY2LK9oxSeCQYMHD/8smJbc7K3tQBPWtOzX0MChnGD1bc6jkb6tzwiXxAt2ITTkGo63RDEI0mOOiMMlUNGMqOfkd8M6tZ7a4Legsn1fxxRSdYopLmVUOBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08 2026, David Hildenbrand (Arm) wrote:

> On 5/5/26 15:39, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. 
>
> I don't quite understand that.
>
> I guess what you mean is "SEAL_EXEC implies SEAL_WRITE if the file is
> executable, to prevent W^X after sealing".

Yes, exactly. If the file is executable and SEAL_EXEC is set, SEAL_WRITE
is also set to make sure the executable code is not writeable.

>
> Because if the file is not executable, there is no sealing of writes happening?
>
> It's rather odd to combine both things, though. Likely the callers should just
> have requested SEAL_WRITE.
>
> But I guess we are stuck with this mess.

Yep :-/

>
>
>> But the
>> implied seal is set after the check that makes sure the memfd can not
>> have any writable mappings. This means one can use SEAL_EXEC to apply
>> SEAL_WRITE while having writeable mappings.
>> 
>> This breaks the contract that SEAL_WRITE provides and can be used by an
>> attacker to pass a memfd that appears to be write sealed but can still
>> be modified arbitrarily.
>> 
>> Fix this by adding the implied seals before the call for
>> mapping_deny_writable() is done.
>> 
>> Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  mm/memfd.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index fb425f4e315f..abe13b291ddc 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>>  		goto unlock;
>>  	}
>>  
>> +	/*
>> +	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
>> +	 */
>> +	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
>> +		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
>> +
>>  	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
>>  		error = mapping_deny_writable(file->f_mapping);
>>  		if (error)
>> @@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>>  		}
>>  	}
>>  
>> -	/*
>> -	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
>> -	 */
>> -	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
>> -		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
>> -
>>  	*file_seals |= seals;
>>  	error = 0;
>>  
>
> Given the weird semantics, this makes sense to me.
>
> Do we have to update documentation to reflect this? But staring at the man page
> [1] we don't even seem to document F_SEAL_EXEC?

I discovered the same when trying to read more about F_SEAL_EXEC. I've
never written man pages but I suppose I can give this a shot.

>
>
> [1] https://www.man7.org/linux/man-pages/man2/F_ADD_SEALS.2const.html

-- 
Regards,
Pratyush Yadav

