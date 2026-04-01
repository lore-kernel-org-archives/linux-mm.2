Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F9910FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068626B0088; Wed,  1 Apr 2026 14:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040C56B0089; Wed,  1 Apr 2026 14:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E986D6B008A; Wed,  1 Apr 2026 14:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98E16B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:47:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 700AE134022
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:47:12 +0000 (UTC)
X-FDA: 84610869504.26.5E1581A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7DA341C0002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:47:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qn1IIrXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775069230; a=rsa-sha256;
	cv=none;
	b=uvyreuSa1LWiVH1LLz/WfJXzyJ9B3qGGhBu1MYmidK9sMNcyIfU+NWAC+n0b8Xg/cNFYA1
	YMsDxzuonPOmugQOjLPU/lDC4UJS2s1XpINym5d83ZdKxXVICaJbcydnZgFFnaVXNdq72n
	IqVH/fwD3jAjFgV8rMixiw3jgIOsgrY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qn1IIrXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775069230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpRBWh/34JyqHmyDfKJLm0eryVs1QdVQqD2RYFPfKbM=;
	b=iwbFhbFWt2CcXx+edISaPxoCCviL09/qzT6utzH7Zu8WfQdJtYtNyWs5dLYFo/gyFfE6ZG
	VclhIZjU4zO0GrKaVabaDjWK8EnDkTbgTD9C31U2zLkMY0vglQkrROQx2Y6m8imuinIrPm
	b2O+hvRLbd0B0F0KaM4l/8x9ZVcqr24=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA3160120;
	Wed,  1 Apr 2026 18:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D402C4CEF7;
	Wed,  1 Apr 2026 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775069229;
	bh=Md1s0fr2AtVUtJNKp2WzOQLe+z9ypGkqmv3OND+GXq4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qn1IIrXF/o3xUq2xY/HivQNRlycebcDAdO5dYCh7bMq5adD8d3dCrePMeoe7E3HHj
	 HH6iQ3+bn5v+eWhFI1/5WDyaUJo4+gFTkLR6mJkoVo3OqLSjiioA2jn6RH2q9wOvxx
	 Qte94LmdrivH3BuyhVFoZA+MzaUKx5SmmtrbaHyFUoaubg7wj9YcGCIHwr7t6potHh
	 iG5IDp1/W43IWtEb0oMzPsXPatyjT3OWOutX7tIHMmBctCZMYTLgfJ6rxe+imD696/
	 ZN1gUPNNspO/mM1dnFrC7w1sp61I68FbegA+d/0ILgTr7/3P6ukYd1J1sgyxVYlbcP
	 jfMzWHokG7ocA==
Message-ID: <e0417e55-1de9-4b77-bea4-b889dc2ac01e@kernel.org>
Date: Wed, 1 Apr 2026 20:47:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: update stale locking comment in do_anonymous_page()
To: Aditya Sharma <adi.sharma@zohomail.in>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org
References: <20260331142936.229667-1-adi.sharma@zohomail.in>
 <20260331142936.229667-1-adi.sharma@zohomail.in>
 <db246b9b-2cc4-4aff-b92b-537ca27c47c0@kernel.org>
 <19d49eccfcb.5f815dde233268.9181527708613952801@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <19d49eccfcb.5f815dde233268.9181527708613952801@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DA341C0002
X-Stat-Signature: 6ch4f3dzfbjam6zths11mfodyah8yqpm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775069230-485180
X-HE-Meta: U2FsdGVkX1+W9326A47q2aSj3tiPVAtaRVf/nU8gb0ZAaPP/xQ/UMVCeS4s8h4zuuKw7b/a7pDD0I4selm9Bx2fUTVVSUtND0x909oddQwVsyL+47vdqPXb8XpM786wmgeVV/Bjt6J462QJ8xYkAUZsNsrcbegHzI8oQ+1EV1VhaVwhh/uVTz77zwGtbEKtg5axZOqHu1WspYVsnORPliIQ8koTH+79YlYY9FfYotwSqJORmC9nPE0/VHYY8hL4ziMRScfwEpFeFntpzCoF82fIyol7vupakBS10Yl/RLOzmPeDVkMXbk4C5Ca3JYgHBhFU+qkpSojH/udRXTWus1kX5VMbiRXSbdu0M8ObB+DEQzNgk1sxVjYidGnbjELLJcZgFJRC3fwJ7DCoagtGleOKnUC7EHRC72aQi7ptqxUWq08SvY8X00WwElCW/ujheIYDJfLewmpCxFO2fL+9XChXVaw/gShdi9onm77IL2SnDqhQuYXyCsvk5uvMX6sZuvWmXk6iyFbMXfRJ6BY7VuxLjXt2hzBIE1u9689AAmhEW6Y4I9dzq78ym2S71O8EsbQjKFTuAWYZvm5fV48uWQubKRaA/pKUTZnMkql8IfBez78xVwequpIEN+z9D1fZumMEHC6dtBe2ab+aMpmcEd5/VPaSJYd+7gogQ6nlnwxJIgGeG7+IQvo1f2LjG4Vbz0XANV39uytsg07zs+mxDHrRSGizRPZ7swoIC07+oNMQgMbivLYyXeTp6iBOxekgB+3Rz2EDLg6zNxrOhUtDlrI7cW5pwo5yJeAAVFA+DvDCH5JOhywo+8xTyyI0o3mQnSe43nVw2304UtnebutY5Da7CcsobG1C9/jhiT4WNRZf0/rRB2eTutQ2ahydY/dwmDj4PayXvFiphXLrXFkYq04qRXYc0/+lqJjlQX1GncIjNR14G6Pwg36xQhSaRWVO78FHeJSzNvm4C//+Pi5M
 fqBrLBEQ
 5Lc6v1Ta4PLe/RBw3NMxKP3RsvqSpSEFh+HrsM/GK16ZMsl51qiDT8kMacuO1KLgwPm+9MgXwPHbnJU07eGqgh5IoBPK+GVl8JEudyVQqDaPnwVHrz8bsrEKxwVI8+wc7O1KDcNsVbhvb51vIA2XdkwxHNfTK9WTt3ZwOh5gNjBmYj1EWNruhcHYw73Nz3K6UkcgiZo1vivHxuuoXFVO0EPiC3w/hmQoECNayyThxiV6HVqcb/MsDCxNNePboqsoRejJKp61oull9BIX2HFsjIaJzCIQeTR0fm2E+37Ukj4QoCtzOqFpV8nRzNpON++rb4Gru3ecWq0YeJyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 18:42, Aditya Sharma wrote:
> Sorry about that. The comment was AI assisted and probably too long. I
> had this confusion myself spending half a day debugging only to realise
> that the comment was stale. Will send an updated patch with a concise
> comment

Right "mmap lock or vma lock held", for example, is sufficient. While at
it, please look for other cases in the file that need similar care.

-- 
Cheers,

David

