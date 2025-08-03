Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED06DC87FCA
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 08:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75186B0088; Sun,  3 Aug 2025 04:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25946B0089; Sun,  3 Aug 2025 04:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62716B008A; Sun,  3 Aug 2025 04:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C971C6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 04:18:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB5D4C0486
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 08:18:13 +0000 (UTC)
X-FDA: 83734743666.30.97BDC80
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf30.hostedemail.com (Postfix) with ESMTP id 85F0780004
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 08:18:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UvYmjfgf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754209092; a=rsa-sha256;
	cv=none;
	b=ycIvGpkKm7HgCGpjvF/cauuuCXH0aosJE4zpsceDu9vYeyUEfryRIwuaJ02EgIzgfhlN2x
	N8UQqV8Pr0wZ2cKWP8XHk08UizqJbs2CpDC+JJ6WZW0LKnluFvBf/CaxMe4oPKIrIzrPrc
	x5+XgfFkfX7MMB1pp+ANtsFlnvDX92w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UvYmjfgf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754209092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5pGs5rghx9u7uNUFrGVTGwAH7l493LZs2yJh3CQs/I=;
	b=Chqct76k5a6XkpR2V4A7fvlsQPuyPPvKbiwdH63HbqPumUb4c/XgXJTKkQXO/8wdii3mAK
	E+u4b5I6I/ouSrogw9Yh6YsNWpW0Vq5E2nJ/sD6BN1rETwQXdkQoWG2IFTUfLvvxOxkw9W
	MTeJCCR75LBV6UoDxw8Oeh7pu9GoqLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id C92CCA4BB79;
	Sun,  3 Aug 2025 08:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E203C4CEF4;
	Sun,  3 Aug 2025 08:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754209091;
	bh=ByXRHJAbOYgU0cIygd2V2UEXXynkeCaZrRIAnBlXViI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UvYmjfgf+a/Xn7Wx44t7M6g5DeO0hEZGLNLuPzB/vqm9VUq4UmkW/zfcg3fdLK/9B
	 EcSQHhBOAyOmsXHKN1OZlcIEm5XOkJ+4PkLHE0tyxm4YmpwNrQRMZPi/uVw1AWYUFu
	 UkoVV35jNQhXae8WVrhcKuLT7PAdDJN7PoAOouXL+/GUODMUHvvNSxngvG46ffiSxP
	 hYoslzkIpX/kYctsYz+JSnsfml4fro5a8sTI8hB5OhXj4HEhf07Fj6KOG56zp0RoIT
	 eOx+1etKR2lrj3d2rdG2KX/4ZTL95VQ7mu0uLe5CdRNtW8BBXPXQvCosg7+wk/hOdY
	 tGyP9uDEt1VRg==
Date: Sun, 3 Aug 2025 11:18:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kim Tae Hyun <kimth0312@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, corbet@lwn.net,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] docs: update physical memory documentation by
 adding N_GENERIC_INITIATOR to enum node_states
Message-ID: <aI8bO2n8RuhF0Zb5@kernel.org>
References: <20250802125801.10068-1-kimth0312@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802125801.10068-1-kimth0312@gmail.com>
X-Stat-Signature: ad3s9gk751wj4e8p5768wbbfdjho1pjk
X-Rspam-User: 
X-Rspamd-Queue-Id: 85F0780004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754209092-910169
X-HE-Meta: U2FsdGVkX183hCSmdlP2M6tCwOWzK7CppdSofdEsZgZBsxoWoZVQTVSC2+FLcgN5J3ZaUfl9L3sDsBaTjEuQocuAwwzEI6jkYWSnJZYSrKTHSlsn/FMXs9NdVko1PFuKGLqIGByx94F18+gMOD4Qos2pkbzAFxtdEdgioFV4BinvYiv9RX9dq7PXoUmHVEnyqMwOBT31kRY5+2kZ9NmkOn8X0wntU53pLCg6atsVfsMSMiYzsfvlMddiXBFkUsj71H2a4XVKLA6HSWUU3GhqLpOUEbd+OJaUKTLvZ3Nqyej/24FNGHL00t1HczPLJDmjSMH7tIkYHmCI5DZ9Cms4VCDOV9VArurp06mZuIkSNSnpOyk/NjcOMrYkqDfvxdI/wd1YVkDxb4+qmCj4d60w08FGrE5ry6IUQcCKXHYyNpmpEzLpukd5gCSDjyeSIc2pzxnHCpQJyBhcTK2SDB68nLLq78VLAmZVF5SF7lTkeBGjWi3zk7YoNiy8KJUHAGPHIiU4Ey3/yGenO5dHqP9oVnZ9kMfdmip80cCcD0djYmNr2ScwKQvpcH3KM7HX6D1rfEXw92gC4hkDaXUcxdXw5o//Q/A+nVUfqHh4EGXHXA5TwNO9dACYPRJ0gpMbuozcR2HfCiBWXTnh/iadoPyKkq5f3Z2FZRLgZLbyqxEJv7E3XodBvKlCLLiKOdyzQ0BfrR9Wfc7AzlZ9syKiklgeAcqJFiC0VBAGjGa5BE/VOrn3Ah9cZKnlCuQ6webiQDdWFskEkQzZTBz7lGs+ECGXAm6E3U/m/x58jSGYNrm0TuQFGHYKQZ+RqCR/BDc7H7mRjYZIlsRvOtizpr71n520i5cVRPTbxWaCdAeHjz8RPKpQCXli1gRowl1UXRAqxfoqIsvR+T9a0SCcEq0uu+b+vel+uebTJ9AjEZhXzZiq2PgJXJLR3YNrECX8/08pDsVh1gGbl2TgFSHamTycj9d
 Au3kcPIO
 iBvDN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 09:58:01PM +0900, Kim Tae Hyun wrote:
> While reading physical_memory.rst, I noticed that N_GENERIC_INITIATOR has not been update
> from the node_states list, even though it's already added in commit 894c26a1c274b8eafbb4b1dad67e70e51a106061.
> 
> Signed-off-by: Kim Tae Hyun <kimth0312@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/mm/physical_memory.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index 9af11b5bd145..b76183545e5b 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -171,6 +171,8 @@ nodes with particular properties as defined by ``enum node_states``:
>    The node has memory(regular, high, movable)
>  ``N_CPU``
>    The node has one or more CPUs
> +``N_GENERIC_INITIATOR``
> +  The node has one or more Generic Initiators
>  
>  For each node that has a property described above, the bit corresponding to the
>  node ID in the ``node_states[<property>]`` bitmask is set.
> -- 
> 2.49.0
> 

-- 
Sincerely yours,
Mike.

