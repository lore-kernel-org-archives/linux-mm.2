Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D9DEC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F666B0092; Mon, 23 Mar 2026 05:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450846B0093; Mon, 23 Mar 2026 05:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33EFF6B0095; Mon, 23 Mar 2026 05:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E386B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:21:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C37ADC31FD
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:21:23 +0000 (UTC)
X-FDA: 84576784446.12.1B58345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C5464000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:21:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uR02mOpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQNdi+pQWOmOOQGZl6cXB/z1SeqIDdIuDUWJjlYF0Jk=;
	b=HVhSD1mCegorOWs/nwwPCEMpWvvuMPtiryByhGAJRO/rYPSVWfab1E+frc4rjgwy5uTjnX
	/1tVazOhra0sBfCZtFesqUtLMCkJLQvd8mVnTPeMVdbrX3/P4AYraR77egbdF/4lhO/rf4
	ioxz1fiRKWQ30qYiQZdnmR1/5gq3reU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uR02mOpA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774257682; a=rsa-sha256;
	cv=none;
	b=exSChci/iKiA3qIyJaW4ZQrYube0X85FADO6vZcQ9nQbgV6qD1YxZSuDalsS+2Hvk9FOC+
	cdRaUw9/mou8Mg5LI1dT8bG99rNpKSKKi0kR66p2Zo7Gdl8+QGcwipoN6SWHubU2fLngfG
	xmP9rDUq/i/CxvQGkSOZj4FSYC/ZLm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 760CF600C4;
	Mon, 23 Mar 2026 09:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DE5C4CEF7;
	Mon, 23 Mar 2026 09:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774257681;
	bh=MuhblPUT/+AeWelMNr/9mhderFBz80A1wpYV3W7ymaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uR02mOpA4SRf2uKWjQkxTJFnoyP0Ym9s4PKZN4RcDeIGEZUEBBe0Xi84UgCx5cmpv
	 EuSShX+psvzJj8PwdVwJwjxkbaI6nUgZ99QUwGoIH4WNFPuHVwUzGtTa/xIU016gsj
	 9TClVQBqu4AhICOirJH+ThGJq5vt0wReb1xsbXJ3FfiH2CSjRUDa7vM51InN0CogkV
	 4dIJHxn8mBL9FMh3J+3tAq9n6Ra9YF068alH8fSIDlK7w/ROg+ArYsTsEAzQLtXZxq
	 8W5olHRIIR8eBsyOXJPTQg2F4Ab6USZOdjQUN8SvFRqAwAubCo8JFYOQ4GfOe09Bi7
	 9UrzcgYPa6zpQ==
Message-ID: <f1ad6f74-c070-4eb8-9fc2-0b68c3259a87@kernel.org>
Date: Mon, 23 Mar 2026 10:21:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove unused page_is_file_lru() function
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>
Cc: Ye Liu <liuye@kylinos.cn>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260323090305.798057-1-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260323090305.798057-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C5464000E
X-Stat-Signature: fymwfu7oqgnacmiqomoiezcd8futpcdk
X-Rspam-User: 
X-HE-Tag: 1774257681-956589
X-HE-Meta: U2FsdGVkX1/WYfsp/yQVIdiFMDmHJnLoqV3p/ph0MEJXAEGlPJ9luQuy/THoMtbUUrCiDT/CwAOoNeFMhokY5ubDYrURlZxl7XTKxAM34i7HJt1PncrlAytFHOGNJ8DWd5yibO54ogt8Cuec7Qet5rXXDgwB1KfzKVXtF8/o+uPbhMERuo64QPDNZWMS97B4jftcPAwEQ1VaGaoC9dYRqtI8a0csAoHsCwKRKCExxIOy/jfsBZJW0E3fLI/pmSAoZ7hUUFTcXuB0X0G4WbqFEy1mNnK3Yz0Q29Q2/3Sd6PlM46vYPQ3DR1QAOawArYCsx8vYMAMDup2+jmPhg/DwxMDAMocI7vEtxGfHP6EnpoH6QfStFmXJ7gjj7eSxnLH+jxBc0SbkVGs9dRk7nWDMXas3EozEFGh0PWb7z18G20yanB/ZTYTeG0gm7tLonBkgIVcnFd0x99n8chfT0M1hePOBPnPxNWzitlcZxSeiQ/YAa4o5DLGJsciNeBPGk2WLlVgiv57uN6eIMUlIHi5EocIDtilc464kpHs+U2aSgoPwoSW67Yvln6x+CzxGecJU9AwUm6jsfM+ByoOuiApvZZXpeYjGEr+sCP5ypuqM0qB8Wv1EL9a2WsC1lCfxJD4x1rzB8qZ4AOPaO3iJVI1x/R62ZGmR3j+4r0cNt3SRJCobCExAwgCHPJCktA3Xe1ZXd9DL71b4QhK+uxtJvucbLR9s+xZKPqvhk377ntIgD0g6Wuv7hddcc9R9xlOSLxEgJv1Gm4GKRBcv8RmpkASH1oumB4wEEjuJTBVuteB3L26+3jNLMQ0rtN0mKyiRKxxdKCIWpYdpYFtxaWi5hpjm9KVv0hVoreXRR2RMDZPvhxRWh/ULeFQ2c2hKd7cib+GL2VTzFtov4I1IW6Wfad+ubS6btbxS5QvBrl95e6zgUJ3TuaTpvH2QLda9+X4qX+nT9suiah5KlaBpTpDK7rX
 rXAObggz
 lmh4yGalZNvnpiWIAivrYBqerEWFGDl7zVzRb4pN1g/u+7N0mimwF1io8VZ/9usKa6lcKy1f6Hr5PEsdrqWeVEHyVoZQqf9pZzPLZUyyk6hOXueqKcSesILkOowV/PcL0W66dAgUS/dT3x1lta4JzQRwklkssvS/PMlJokPiK1nub2Jw1duPlPD508yHXs6QNU6bfDKLy82FZJltvC0wn/0AqWhcqCCcsM5jiL31yMiNfVK0ra+rkCpOBym8C6AsijmjU0LirwqqiBQ8VqjLf65+HJ4uhWWCDM3QiKMPAkgo2k6Dpq3WoQK8qkG6orH8qoX+4lE8byiT2hFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 10:03, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The page_is_file_lru() wrapper function is no longer used. The kernel
> has moved to folio-based APIs, and all callers should use
> folio_is_file_lru() instead.
> 
> Remove the obsolete page-based wrapper function.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

